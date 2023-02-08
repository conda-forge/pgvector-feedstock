#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export PGROOT="${PREFIX}"
fi

make

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  /usr/bin/install -c -m 755 vector.so "${PREFIX}/lib/vector.so"
  /usr/bin/install -c -m 644 vector.control "${PREFIX}/share/extension/"
  /usr/bin/install -c -m 644 sql/* "${PREFIX}/share/extension/"
  ls
  ls $PREFIX/share/extension
  ls $BUILD_PREFIX/share/extension
else
  make install
fi


if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then

initdb -D test_db
pg_ctl -D test_db -l test.log start

make installcheck

pg_ctl -D test_db stop

fi

