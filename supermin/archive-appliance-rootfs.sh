#!/usr/bin/env bash

BUILD_FOLDER=$1
OUTPUT_FILE=$2

pushd "$BUILD_FOLDER" > /dev/null || exit 1

echo "Archiving $(pwd)..."
tar c ./* | xz --best > "$OUTPUT_FILE"

echo "Created image at: $OUTPUT_FILE"

popd > /dev/null || exit 1
