#!/bin/bash

set -ex

BUILD_DIR="$(pwd)/_build"
mkdir -pv ${BUILD_DIR}

cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -B _build \
  -S ${SRC_DIR}

# build
cmake --build ${BUILD_DIR} --parallel ${CPU_COUNT} --verbose

# install
cmake --install ${BUILD_DIR}

# install activate/deactivate scripts
for action in activate deactivate; do
  mkdir -p ${PREFIX}/etc/conda/${action}.d
  _target="${PREFIX}/etc/conda/${action}.d/${action}-${PKG_NAME}.sh"
  echo "-- Installing: ${_target}"
  cp "${PREFIX}/etc/cwb/cwb-${action}.sh" "${_target}"
done
