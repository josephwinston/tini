#!/bin/bash
# Should be run from the root dir, or SOURCE_DIR should be set.
set -o errexit
set -o nounset

: ${SOURCE_DIR:="."}
: ${DIST_DIR:="${SOURCE_DIR}/dist"}
: ${BUILD_DIR:="/tmp/build"}

# Build
cmake -B"${BUILD_DIR}" -H"${SOURCE_DIR}"

pushd "${BUILD_DIR}"
make clean
make

popd

# Smoke tests (actual tests need Docker to run; they don't run within the CI environment)
tini="${BUILD_DIR}/tini"
echo "Testing $tini with: true"
$tini -vvvv true

echo "Testing $tini with: false"
if $tini -vvvv false; then
  exit 1
fi

# Place files
mkdir -p "${DIST_DIR}"
cp "${BUILD_DIR}"/tini "${DIST_DIR}"
