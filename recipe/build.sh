#!/bin/bash
set -ex

make
make install

initdb -D test_db
pg_ctl -D test_db -l test.log start


if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then

make installcheck

fi

pg_ctl -D test_db stop

