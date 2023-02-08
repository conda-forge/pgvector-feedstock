#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export PGROOT="${PREFIX}"
fi

make
make install


if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then

initdb -D test_db
pg_ctl -D test_db -l test.log start

make installcheck

pg_ctl -D test_db stop

fi

