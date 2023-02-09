#!/bin/bash
set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export PGROOT="${PREFIX}"
  export CFLAGS="${CFLAGS} -arch arm64 -mmacosx-version-min=11.0"
fi


make OPTFLAGS="${CFLAGS}" CC="${CC}"

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  # Manually installing files because pgvector does auto-detection of install directory using pgxs in $BUILD_PREFIX
  /usr/bin/install -c -m 755 vector.so "${PREFIX}/lib/vector.so"
  /usr/bin/install -c -m 644 vector.control "${PREFIX}/share/extension/"
  /usr/bin/install -c -m 644 sql/* "${PREFIX}/share/extension/"
else
  make install
fi


if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then

initdb -D test_db
pg_ctl -D test_db -l test.log start

make installcheck

pg_ctl -D test_db stop

fi

