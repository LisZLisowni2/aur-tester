#!/bin/bash

# Default values
OUTPUT_DIR="./aur-packages"
KEEP_CONTAINER=false
VERBOSE=false
VERSION="1.0.0"

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
    echo "  --version             Show the script version and exit"
    exit 0
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -o|--o)
            OUTPUT_DIR="$2"
            ;;
        -k|--keep-container)
            KEEP_CONTAINER=true
            ;;
        -v|--verbose)
            VERBOSE=true  
            ;;
        --version)
            echo "aur-tester version $VERSION"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            ;;
        *)
            PACKAGE_NAME="$1"
            ;;
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

log "Verbose mode enabled"
echo "Building package: $PACKAGE_NAME"
echo "Output directory: $OUTPUT_DIR"
echo "Keep container: $KEEP_CONTAINER"
systemctl start docker

systemctl stop docker