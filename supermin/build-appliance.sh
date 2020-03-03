#!/usr/bin/env bash

set -euo pipefail

if ! command -v supermin > /dev/null; then
    echo "Supermin binary not found in PATH! Install it first."
    exit 1
fi

echo "Supermin work directory: $SUPERMIN_FOLDER"

APPLIANCE_FOLDER=$SUPERMIN_FOLDER/prepare
echo "Appliance output folder: $APPLIANCE_FOLDER"

BUILD_FOLDER=$SUPERMIN_FOLDER/build
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

echo "Built rootfs at $BUILD_FOLDER"

echo "Returning to original directory"
