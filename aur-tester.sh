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
    echo
    echo "Options:"
    echo "  -h, --help            Show this help message and exit"
    echo "  -o, --output <dir>    Specify the output directory for built packages (default: $OUTPUT_DIR)"
    echo "  -k, --keep-container  Keep the Docker container after execution (default: false)"
    echo "  -v, --verbose         Enable verbose output (default: false)"
    echo "  -s, --minimal-scan    Scan only changed files, not all system"
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
        set -ex &&
        echo \"Clone a git repo of $PACKAGE_NAME and build it\" &&
        find $pkgdir -type f > /tmp/before_install.txt &&
        su buildtest -c \"
            echo \"Clone\" &&
            git clone https://aur.archlinux.org/$PACKAGE_NAME.git && 
            cd $PACKAGE_NAME &&
            echo \"Sums\" &&
            sha256sum PKGBUILD
            if [ \$? -ne 0 ]; then
                echo \"sha256sum failed, continuing...\"
            fi &&
            echo \"Code\" &&
            shellcheck PKGBUILD
            if [ \$? -ne 0 ]; then
                echo \"shellcheck failed, continuing...\"
            fi &&
            echo \"Install\" &&
            makepkg -is --noconfirm \" &&
        find $pkgdir -type f > /tmp/after_install.txt &&
        diff /tmp/before_install.txt /tmp/after_install.txt > /tmp/changed.txt &&
        cd / &&
        echo \"Update the clamAV database\" &&
        freshclam &&
        if [ \"$SCANALL\" = true ]; then
            echo \"Scan the system\" &&
            clamscan -r
            if [ \$? -ne 0 ]; then
                echo \"clamscan failed, continuing...\"
            fi
            echo \"Scan for rootkits\" &&
            rkhunter
            if [ \$? -ne 0 ]; then
                echo \"rkhunter failed, continuing...\"
            fi
        else
            echo \"Scan the system\" &&
            cat /tmp/changed.txt | clamscan -
            if [ \$? -ne 0 ]; then
                echo \"clamscan failed, continuing...\"
            fi
            echo \"Scan for rootkits\" &&
            rkhunter --scan-files=$(cat /tmp/changed.txt | tr '\n' ' ')
            if [ \$? -ne 0 ]; then
                echo \"clamscan failed, continuing...\"
            fi
        fi
    "
}

log "Verbose mode enabled"
echo "Building package: $PACKAGE_NAME"
echo "Output directory: $OUTPUT_DIR"
echo "Keep container: $KEEP_CONTAINER"
test_docker_service
run_docker_and_test
