@echo on

set "LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%"
set "PGROOT=%LIBRARY_PREFIX%"

nmake /NOLOGO /F Makefile.win
if errorlevel 1 exit 1
nmake /NOLOGO /F Makefile.win install
if errorlevel 1 exit 1


initdb -D test_db
if errorlevel 1 exit 1
pg_ctl -D test_db -l test.log start
if errorlevel 1 exit 1
createuser --username=%USERNAME% -w -s postgres
if errorlevel 1 exit 1
mkdir results
nmake /NOLOGO /F Makefile.win installcheck
type test.log
dir results /s /b /o:gn
if errorlevel 1 exit 1
pg_ctl -D test_db stop