#!/bin/bash

set -ex

mkdir -pv build
pushd build

cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  ${SRC_DIR}

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# install
cmake --install .

# install activate/deactivate scripts
for action in activate deactivate; do
	mkdir -p ${PREFIX}/etc/conda/${action}.d
        _target="${PREFIX}/etc/conda/${action}.d/${action}-${PKG_NAME}.sh"
	echo "-- Installing: ${_target}"
	# Source the installed script instead of copying it: a relocatable cWB
	# install (gwburst/public/library!30) locates HOME_CWB from the path of
	# cwb-activate.sh itself, so a copy here would resolve it to
	# etc/conda/activate.d. Sourcing works with older releases too.
	printf '. "${CONDA_PREFIX}/etc/cwb/cwb-%s.sh"\n' "${action}" > "${_target}"
done
