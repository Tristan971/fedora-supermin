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

PACKAGES=$SUPERMIN_FOLDER/PACKAGES
echo "Packages list file: $PACKAGES"

# we DO want word splitting in this case
# shellcheck disable=SC2046
supermin -v -o "$APPLIANCE_FOLDER" --prepare $(< "$PACKAGES")

echo "Returning to original directory"
popd > /dev/null || exit 1
