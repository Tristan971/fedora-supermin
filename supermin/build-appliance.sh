#!/usr/bin/env bash

function dirof() {
    dirname "$(realpath "$1")"
}

# there's a lot to say about $0, but the TL;DR is that it works
# if you're reasonable. Be reasonable.
EXEC=$(realpath "$0")
echo "Executing $EXEC"

EXEC_DIR=$(dirof "$EXEC")
echo "Moving to: $EXEC_DIR"

pushd "$EXEC_DIR" > /dev/null || exit 1

if ! command -v supermin > /dev/null; then
    echo "Supermin binary not found in PATH! Install it first."
    exit 1
fi

pushd "$(dirof "$EXEC")" > /dev/null || exit 1

SUPERMIN_FOLDER=$(pwd)
echo "Supermin work directory: $SUPERMIN_FOLDER"

APPLIANCE_FOLDER=$SUPERMIN_FOLDER/appliance.d
echo "Appliance output folder: $APPLIANCE_FOLDER"

BUILD_FOLDER=$SUPERMIN_FOLDER/dist
echo "Build output folder: $BUILD_FOLDER"

PACKAGES=$SUPERMIN_FOLDER/PACKAGES
echo "Packages list file: $PACKAGES"

function supermin2() {
    supermin -v --lock /tmp/supermin.lock --if-newer "$@"
}

# we DO want word splitting in this case
# shellcheck disable=SC2046
supermin2 -o "$APPLIANCE_FOLDER" --use-installed --prepare $(< "$PACKAGES")

supermin2 --build --format chroot "$APPLIANCE_FOLDER" -o "$BUILD_FOLDER"

echo "Returning to original directory"
popd > /dev/null || exit 1
