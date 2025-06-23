@echo off

SETLOCAL

SET vswherePath=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe
IF NOT EXIST "%vswherePath%" GOTO :ERROR

FOR /F "tokens=*" %%i IN (
    '"%vswherePath%" -products * -latest -prerelease -find **\VC\Auxiliary\Build\vcvarsall.bat'
) DO SET vsvarsallPath=%%i

CALL "%vsvarsallPath%" x86 > NUL

cl %* > NUL

ENDLOCAL