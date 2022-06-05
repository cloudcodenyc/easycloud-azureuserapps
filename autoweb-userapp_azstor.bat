::#############################################################################
::# AUTOMATIC AZURE USERAPPS (Microsoft Azure Storage Explorer)               #
::#                                                                           #
::# LICENSE  = MIT                                                            #
::# VERSION  = 0.0.1                                                          #
::# FILENAME = autoweb-userapp_azstor.bat                                     #
::# GITREPO  = https://github.com/cloudcodenyc/easycode-azureuserapps         #
::#                                                                           #
::#############################################################################
::# Copyright (c) 2022 Matthew Simon                                          #
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
reg QUERY "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32|| set OS=64

::## Application Web Download Links
	set AZEXP="https://go.microsoft.com/fwlink/?LinkId=708343"
	set XNAME=StorageExplorer.exe
	set WPATH=%TEMP%\%XNAME%
	set WDIR=%~dp0
	
::## Check for CURL and QUIT if NOT FOUND
IF NOT EXIST "%WINDIR%\System32\curl.exe" (echo NO CURL FOUND && exit 1) 2>nul

IF EXIST "%TEMP%\%XNAME%" (del /F /S /Q "%WPATH%") 2>nul
IF NOT EXIST "%WPATH%" (curl -L --url %AZEXP% -o "%WPATH%")

::## Silent Installation
IF EXIST "%WPATH%" ("%WPATH%" /VERYSILENT /SUPPRESSMSGBOXES /ALLUSERS=2 /LOG="%TEMP%\autoweb-az-StorageExplorer-Install.log")

::## Verify previous command executed without ERROR and QUIT if ERROR detected
IF /I "%ERRORLEVEL%" NEQ "1" (
    IF EXIST "%TEMP%\%XNAME%" (del /F /S /Q "%TEMP%\%XNAME%") && EXIT 0
)

EXIT 1