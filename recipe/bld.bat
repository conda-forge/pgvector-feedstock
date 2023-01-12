@echo on

set "LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%"
set "PGROOT=%LIBRARY_PREFIX%"

nmake /NOLOGO /F Makefile.win
nmake /NOLOGO /F Makefile.win install
nmake /NOLOGO /F Makefile.win installcheck