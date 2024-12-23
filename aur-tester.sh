#!/bin/bash

# Default values
OUTPUT_DIR="./aur-packages"
IMAGE_NAME="aur-tester-image"
KEEP_CONTAINER=false
VERBOSE=false
VERSION="1.0.0"
SCANALL=true

# Help message
usage() {
	echo "Usage: aur-tester [options] <aur-package-name>"
    echo "Automates testing AUR packages in an isolated Docker environment."
    echo "WARNING! Even with that script you have to double check the makepkg file before installation of package!"
    echo
    echo "Options:"
    echo "  -h, --help            Show this help message and exit"
    echo "  -o, --output <dir>    Specify the output directory for built packages (default: $OUTPUT_DIR)"
    echo "  -k, --keep-container  Keep the Docker container after execution (default: false)"
    echo "  -v, --verbose         Enable verbose output (default: false)"
    echo "  -s, --minimal-scan    Scan only changed files, not all system (work in progress)"
    echo "  --version             Show the script version and exit"
    exit 0
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -o|--o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -k|--keep-container)
            KEEP_CONTAINER=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true  
            shift
            ;;
        -s|--minimal-scan)
            SCANALL=false
            shift
            ;;
        --version)
            echo "aur-tester version $VERSION"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
        *)
            PACKAGE_NAME="$1"
            shift
            ;;
    esac
done

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Missing AUR package name." >&2
    usage
fi

log() {
    if [ "$VERBOSE" = true ]; then
        echo "$@"
    fi
}

test_docker_service() {
    if ! systemctl is-active --quiet docker; then
        sudo systemctl start docker
    fi
}

run_docker_and_test() {
    docker run --rm -it --name $PACKAGE_NAME-testing --user root aur-tester-image:$VERSION -c "
        set -ex
        echo \"Update the system\"
        pacman -Syu --noconfirm
        echo \"Clone a git repo of $PACKAGE_NAME and build it\"
        find / -type f 2>/dev/null > /tmp/before_install.txt || echo 'before installation fail creation failed, continuing...'
        if [ -s /tmp/before_install.txt ]; then
            sort /tmp/before_install.txt > /tmp/before.sort
            echo \"Size of before:\"
            du -h /tmp/before.sort
        else
            echo \"before_install.txt file doesn't exist\"
        fi
        su buildtest -c \"
            echo 'Clone'
            git clone https://aur.archlinux.org/$PACKAGE_NAME.git
            cd $PACKAGE_NAME
            echo 'Sums'
            sha256sum PKGBUILD || echo 'sha256sum failed, continuing...'
            echo 'Code'
            shellcheck PKGBUILD || echo 'shellcheck failed, continuing...'
            echo 'Install'
            makepkg -is --noconfirm \"
        cd /
        find / -type f 2>/dev/null > /tmp/after_install.txt || echo 'after installation fail creation failed, continuing...'
        if [ -s /tmp/after_install.txt ]; then
            sort /tmp/after_install.txt > /tmp/after.sort
            echo \"Size of after:\"
            du -h /tmp/after.sort
        else
            echo \"after_install.txt file doesn't exist\"
        fi

        #if [ -s /tmp/before.sort ] && [ -s /tmp/after.sort ]; then
        #    diff --speed-large-files /tmp/before.sort /tmp/after.sort > /tmp/changed.txt
        #    DIFF_EXIT_CODE=$?
        #    if [ $DIFF_EXIT_CODE -eq 0]; then
        #        echo \"Differences found and saved to /tmp/changed.txt\"
        #    elif [ $DIFF_EXIT_CODE -eq 1]; then
        #        echo \"Differences not found.\"
        #        echo \"\" > /tmp/changed.txt
        #    else
        #        echo \"ERROR: diff failed with unexcpected error!\"
        #    fi
        #else
        #    echo \"One of sorted file is empty or missing!\"
        #fi

        echo \"Update the clamAV database\"
        freshclam
        if [ \"$SCANALL\" = true ]; then
            echo \"Scan the system\"
            clamscan -r || echo \"clamscan failed, continuing...\"
            echo \"Scan for rootkits\"
            rkhunter || echo \"rkhunter failed, continuing...\"
        else
            echo \"Scan the system\"
            cat /tmp/changed.txt | clamscan - || echo \"clamscan failed, continuing...\"
            echo \"Scan for rootkits\"
            FILE=cat /tmp/changed.txt | tr '\n' ' ' rkhunter --scan-files=FILE || echo \"rkhunter failed, continuing...\"
        fi
    "
}

log "Verbose mode enabled"
log "Building package: $PACKAGE_NAME"
log "Output directory: $OUTPUT_DIR"
log "Keep container: $KEEP_CONTAINER"
log "Scan all: $SCANALL"
test_docker_service
run_docker_and_test
