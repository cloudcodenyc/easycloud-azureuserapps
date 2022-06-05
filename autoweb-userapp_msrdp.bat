::#############################################################################
::# AUTOMATIC AZURE USERAPPS (Microsoft Remote Desktop Viewer) "RDP"          #
::#                                                                           #
::# LICENSE  = MIT                                                            #
::# VERSION  = 0.0.1                                                          #
::# FILENAME = autoweb-userapp_msrdp.bat                                      #
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
reg QUERY "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=86|| set OS=64

::## Application Web Download Links
	set RDP64=https://go.microsoft.com/fwlink/?linkid=2068602
	set RDP32=https://go.microsoft.com/fwlink/?linkid=2098960
	set RNAME=RDP_x%OS%

::## Check for CURL and QUIT if NOT FOUND
IF NOT EXIST "%WINDIR%\System32\curl.exe" (echo NO CURL FOUND && exit 1) 2>nul
IF EXIST "%TEMP%\%RNAME%.msi" (del /F /S /Q "%TEMP%\%RNAME%.msi") 2>nul

::## Download x32/x64 based on CPU
IF "%OS%" == "64" (curl -L --url "%RDP64%" -o "%TEMP%\RDP_x%OS%.msi")
IF "%OS%" == "32" (curl -L --url "%RDP32%" -o "%TEMP%\RDP_x%OS%.msi")

::## Silent Installation
IF EXIST "%TEMP%\%RNAME%.msi" (msiexec /i "%TEMP%\RDP_x%OS%.msi" /qn ALLUSERS=2 MSIINSTALLPERUSER=1) 2>nul

::## Verify previous command executed without ERROR and QUIT if ERROR detected
IF /I "%ERRORLEVEL%" NEQ "1" (
    IF EXIST "%TEMP%\%RNAME%.msi" (del /F /S /Q "%TEMP%\%RNAME%.msi") && EXIT 0
)

exit 1