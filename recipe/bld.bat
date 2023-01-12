@echo on

set "LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%"
set "PGROOT=%LIBRARY_PREFIX%"

nmake /NOLOGO /F Makefile.win
nmake /NOLOGO /F Makefile.win install


initdb -D test_db
pg_ctl -D test_db -l test.log -o "-F -p 5434" start
createuser --username=%USERNAME% -w --port=5434 -s postgres
nmake /NOLOGO /F Makefile.win installcheck
pg_ctl -D test_db stop