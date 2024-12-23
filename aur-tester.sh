#!/bin/bash

# Default values
OUTPUT_DIR="./aur-packages"
LOG_DIR="/var/log/aurtester.log"
IMAGE_NAME="aur-tester-image"
KEEP_CONTAINER=false
VERBOSE=false
QUIET=false
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
    echo "  -v, --verbose         Enable verbose output - More output (default: false). Do not use with -q or --quiet flag"
    echo "  -q, --quiet           Enable quiet output - Less output (default: false). Do not use with -v or --verbose flag"
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
        -q|--quiet)
            QUIET=true
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

if [ "$VERBOSE" = true ] && [ "$QUIET" = true ]; then
    echo "Error: Verbose and quiet cannot be combined." >&2
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
    docker run -it --rm --name $PACKAGE_NAME-testing --user root aur-tester-image:$VERSION -c "
        log() {
            echo \"[\$(date '+%Y-%m-%d %H:%M:%S')]: \$@\"
        }

        if [ "$VERBOSE" = true ]; then
            VERBOSE_FLAG=\"-v\"
        else
            VERBOSE_FLAG=\"\"
        fi

        if [ "$QUIET" = true ]; then
            QUIET_FLAG=\"-q\"
        else
            QUIET_FLAG=\"\"
        fi

        set -ex
        log \"Update the system\"
        pacman -Syu $VERBOSE_FLAG $QUIET_FLAG --noconfirm
        log \"Clone a git repo of $PACKAGE_NAME and build it\"
        find / -type f 2>/dev/null > /tmp/before_install.txt || echo 'before installation fail creation failed, continuing...'
        if [ -s /tmp/before_install.txt ]; then
            sort /tmp/before_install.txt > /tmp/before.sort
            if [ "$VERBOSE" = true ]; then
                log \"Size of before:\"
                du -h /tmp/before.sort
            fi
        else
            log \"before_install.txt file doesn't exist\"
        fi
        su buildtest -c \"
            log \'Clone\'
            git clone https://aur.archlinux.org/$PACKAGE_NAME.git
            cd $PACKAGE_NAME
            log \'Sums\'
            sha256sum PKGBUILD || log \'sha256sum failed, continuing...\'
            log \'Code\'
            shellcheck PKGBUILD || log \'shellcheck failed, continuing...\'
            log \'Install\'
            makepkg -is $VERBOSE_FLAG $QUIET_FLAG --noconfirm \"
        cd /
        find / -type f 2>/dev/null > /tmp/after_install.txt || log 'after installation fail creation failed, continuing...'
        if [ -s /tmp/after_install.txt ]; then
            sort /tmp/after_install.txt > /tmp/after.sort
            if [ "$VERBOSE" = true ]; then
                log \"Size of after:\"
                du -h /tmp/after.sort
            fi
        else
            log \"after_install.txt file doesn't exist or verbose flag is disabled\"
        fi

        if [ -s /tmp/before.sort ] && [ -s /tmp/after.sort ]; then
            log \"Content of /tmp directory\"
            ls -lh /tmp
            log \"Preview of before.sort file\"
            head -n 20 /tmp/before.sort
            log \"Preview of after.sort file\"
            head -n 20 /tmp/after.sort
            set +e && diff --speed-large-files /tmp/before.sort /tmp/after.sort > /tmp/changed.txt
            DIFF_EXIT_CODE=$?
            set -e
            if [ $DIFF_EXIT_CODE -eq 0 ]; then
                log \"Differences found and saved to /tmp/changed.txt\"
            elif [ $DIFF_EXIT_CODE -eq 1 ]; then
                log \"Differences not found.\"
                echo \"\" > /tmp/changed.txt
            else
                log \"ERROR: diff failed with unexpected error! Code: $DIFF_EXIT_CODE\"
            fi
        else
            log \"One of sorted file is empty or missing!\"
        fi

        log \"Update the clamAV database\"
        freshclam
        if [ \"$SCANALL\" = true ]; then
            log \"Scan the system\"
            clamscan -r || log \"clamscan failed, continuing...\"
            log \"Scan for rootkits\"
            rkhunter -c || log \"rkhunter failed, continuing...\"
        else
            log \"Scan the system\"
            cat /tmp/changed.txt | clamscan - || log \"clamscan failed, continuing...\"
            log \"Scan for rootkits\"
            cat /tmp/changed.txt | tr '\n' ' ' > /tmp/result.txt
            rkhunter -c --scan-files=/tmp/result.txt || log \"rkhunter failed, continuing...\"
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
