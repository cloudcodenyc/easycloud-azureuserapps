::#############################################################################
::# AUTOMATIC AZURE USERAPPS (Microsoft Visual Studio Code) "VSCode"          #
::#                                                                           #
::# LICENSE  = MIT                                                            #
::# VERSION  = 0.0.1                                                          #
::# FILENAME = autoweb-userapp_vscode.bat                                     #
::# GITREPO  = https://github.com/cloudcodenyc/easycode-azureuserapps         #
::#                                                                           #
::#############################################################################
::# Copyright (c) 2022 cloudcodenyc                                           #
::#                                                                           #
::# Permission is hereby granted, free of charge, to any person obtaining     #
::# a copy of this software and associated documentation files (the           #
::# "Software"), to deal in the Software without restriction, including       #
::# without limitation the rights to use, copy, modify, merge, publish,       #
::# distribute, sublicense, and/or sell copies of the Software, and to        #
::# permit persons to wh.om the Software is furnished to do so, subject to    #
::# the following conditions:                                                 #
::#                                                                           #
::# The above copyright notice and this permission notice shall be            #
::# included in all copies or substantial portions of the Software.           #
::#                                                                           #
::# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,           #
::# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF        #
::# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                     #
::# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE    #
::# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION    #
::# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION     #
::# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.           #
::#############################################################################
@echo OFF
	
	set VSU64="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
	set VSU32="https://code.visualstudio.com/sha/download?build=stable&os=win32-user"

IF NOT EXIST "%WINDIR%\System32\curl.exe" (echo "NO CURL FOUND" && exit 1) 2>nul
reg QUERY "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32|| set OS=64

::## Setup Variables
	set XNAME=VsCodeUser-%OS%.exe
	set WPATH=%TEMP%\%XNAME%
	set WDIR=%~dp0

::## Check for old copy of VSCode installer and remove if found
IF EXIST "%TEMP%\%XNAME%" (del /F /S /Q "%WPATH%") 2>nul

::## Autodownload appropriate VSCode variant
IF "%OS%" == "64" (curl -L --url %VSU64% -o "%WPATH%")
IF "%OS%" == "32" (curl -L --url %VSU32% -o "%WPATH%")

::## Silent Installation
IF EXIST "%WPATH%" ("%WPATH%" /CLOSEAPPLICATIONS /VERYSILENT /NORESTART /MERGETASKS=!runcode,desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath /LOG="%TEMP%\autoweb-az-VSCode%OS%-Install.log")

::## Confirm no installation ERROR and CLEAN EXIT
IF /I "%ERRORLEVEL%" NEQ "1" (
    IF EXIST "%TEMP%\%XNAME%" (del /F /S /Q "%TEMP%\%XNAME%") && EXIT 0
)

::## ERROR EXIT
EXIT 1