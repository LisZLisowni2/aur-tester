#!/bin/bash

# Default values
IMAGE_NAME="aur-tester-image"
PACKAGE_NAME=""
VERBOSE=""
VERSION="1.0.0"
SCANMINIMAL=""

# Help message
usage() {
	echo "Usage: aur-tester [options] <aur-package-name>"
    echo "Automates testing AUR packages in an isolated Docker environment."
    echo "WARNING! Even with that script you have to double check the makepkg file before installation of package!"
    echo
    echo "Options:"
    echo "  -h, --help            Show this help message and exit"
    echo "  -v, --verbose         Enable verbose output - More output (default: false). Do not use with -q or --quiet flag"
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
        -v|--verbose)
            VERBOSE="-v"  
            shift
            ;;
        -s|--minimal-scan)
            SCANALL="-s"
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

if [ "$VERBOSE" = true ]; then
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
    docker run --rm -it --name $PACKAGE_NAME-testing aur-tester-image:$VERSION $VERBOSE $SCANMINIMAL $PACKAGE_NAME
}

test_docker_service
run_docker_and_test
