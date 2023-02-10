#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .



if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  mkdir build
  pushd build

  cmake ${CMAKE_ARGS} ..


  cmake --build . --verbose --config Release -- -v -j ${CPU_COUNT}
  ls src/
  cmake --install . --verbose --config Release
  popd
else
  make
  make install

  initdb -D test_db
  pg_ctl -D test_db -l test.log start

  make installcheck

  pg_ctl -D test_db stop
fi


