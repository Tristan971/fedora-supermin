#!/usr/bin/env bash

set -euo pipefail

echo "Building supermin appliance image"
SUPERMIN_IMAGE="$(docker build . -f Dockerfile.supermin | tee /dev/tty | tail -n1 | rev | cut -d ' ' -f1 | rev)"
echo "Supermin appliance image: $SUPERMIN_IMAGE"

SUPERMIN_CONTAINER=$(docker create "$SUPERMIN_IMAGE")
echo "Supermin container: $SUPERMIN_CONTAINER"

SUPERMIN_TEMP=$(pwd)/supermin/tmp
mkdir -p "$SUPERMIN_TEMP"

SUPERMIN_IMAGE=$SUPERMIN_TEMP/image.tar.xz
echo "Extracting supermin rootfs in $SUPERMIN_TEMP"

if ! docker cp "$SUPERMIN_CONTAINER":/supermin/image.tar.xz "$SUPERMIN_TEMP"; then
    exit 1
else
    ls -lh "$SUPERMIN_TEMP/"
fi

echo "Building image based on rootfs"
CMD="docker build . -f Dockerfile.image"
echo "$CMD"
$CMD

echo "Cleaning up local rootfs"
rm -rfv "$SUPERMIN_TEMP"

echo "Done!"
