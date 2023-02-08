#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export PGROOT="${PREFIX}"
fi

make

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  /bin/sh $PREFIX/lib/pgxs/src/makefiles/../../config/install-sh -c -d '$PREFIX/lib'
  /bin/sh $PREFIX/lib/pgxs/src/makefiles/../../config/install-sh -c -d '$PREFIX/share/extension'
  /bin/sh $PREFIX/lib/pgxs/src/makefiles/../../config/install-sh -c -d '$PREFIX/share/extension'
else
  make install
fi
ls
ls sql/
ls $PREFIX/share/extension
ls $BUILD_PREFIX/share/extension


if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then

initdb -D test_db
pg_ctl -D test_db -l test.log start

make installcheck

pg_ctl -D test_db stop

fi

