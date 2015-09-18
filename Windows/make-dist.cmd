REM *************************************************************************
REM * Build portable application and installers from QtSESAM binaries.      *
REM *                                                                       *
REM * Copyright (c) 2015 Oliver Lau <ola@ct.de>, Heise Medien GmbH & Co. KG *
REM *************************************************************************

@ECHO OFF

SET SRCDIR="..\..\Qt-SESAM"
SET DESTDIR_X86="QtSESAM-portable-x86"
SET DESTDIR_X64="QtSESAM-portable-x64"
SET QTDIR_X86="D:\Qt\5.5\msvc2013\bin"
SET QTDIR_X64="D:\Qt\5.5\msvc2013_64\bin"
SET BUILDDIR_X86="..\..\Qt-SESAM-Desktop_Qt_5_5_0_MSVC2013_32bit-Release\Qt-SESAM\release"
SET BUILDDIR_X64="..\..\Qt-SESAM-Desktop_Qt_5_5_0_MSVC2013_64bit-Release\Qt-SESAM\release"
SET PATH=%PATH%;C:\Program Files\7-Zip;D:\Developer\NSIS\
SET INSTALLER_GLOB="Qt-SESAM-*-setup.exe"

ECHO Removing old files ...

RD /S /Q %DESTDIR_X64% >NUL
DEL %DESTDIR_X64%.zip >NUL
DEL %DESTDIR_X64%.7z >NUL
DEL %DESTDIR_X64%.zip.txt >NUL
DEL %DESTDIR_X64%.7z.txt >NUL

RD /S /Q %DESTDIR_X86% >NUL
DEL %DESTDIR_X86%.zip >NUL
DEL %DESTDIR_X86%.7z >NUL
DEL %DESTDIR_X86%.zip.txt >NUL
DEL %DESTDIR_X86%.7z.txt >NUL

DEL %INSTALLER_GLOB% >NUL
DEL %INSTALLER_GLOB%.txt >NUL

ECHO Making directories in %DESTDIR_X86% ...

IF NOT EXIST %DESTDIR_X86% MKDIR %DESTDIR_X86%
IF NOT EXIST %DESTDIR_X86%\platforms MKDIR %DESTDIR_X86%\platforms
IF NOT EXIST %DESTDIR_X86%\resources\images MKDIR %DESTDIR_X86%\resources\images

ECHO Making directories in %DESTDIR_X64% ...

IF NOT EXIST %DESTDIR_X64% MKDIR %DESTDIR_X86%
IF NOT EXIST %DESTDIR_X64%\platforms MKDIR %DESTDIR_X64%\platforms
IF NOT EXIST %DESTDIR_X64%\resources\images MKDIR %DESTDIR_X64%\resources\images

ECHO Copying files to %DESTDIR_X86% ...

COPY /B %SRCDIR%\LICENSE %DESTDIR_X86% >NUL
COPY /B %SRCDIR%\LIESMICH.txt %DESTDIR_X86% >NUL
COPY /B x86\ssleay32.dll %DESTDIR_X86% >NUL
COPY /B x86\libeay32.dll %DESTDIR_X86% >NUL
COPY /B x86\msvcp120.dll %DESTDIR_X86% >NUL
COPY /B x86\msvcr120.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\Qt5Core.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\Qt5Gui.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\Qt5Widgets.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\Qt5Network.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\Qt5Concurrent.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\icudt54.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\icuin54.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\icuuc54.dll %DESTDIR_X86% >NUL
COPY /B %QTDIR_X86%\..\plugins\platforms\qminimal.dll %DESTDIR_X86%\platforms >NUL
COPY /B %QTDIR_X86%\..\plugins\platforms\qwindows.dll %DESTDIR_X86%\platforms >NUL
COPY /B %BUILDDIR_X86%\Qt-SESAM.exe %DESTDIR_X86% >NUL
COPY /B ..\resources\images\* %DESTDIR_X86%\resources\images >NUL
ECHO Removing this file will disable portability.>%DESTDIR_X86%\PORTABLE

COPY /B %SRCDIR%\LICENSE %DESTDIR_X64% >NUL
COPY /B %SRCDIR%\LIESMICH.txt %DESTDIR_X64% >NUL
COPY /B X64\ssleay32.dll %DESTDIR_X64% >NUL
COPY /B X64\libeay32.dll %DESTDIR_X64% >NUL
COPY /B X64\msvcp120.dll %DESTDIR_X64% >NUL
COPY /B X64\msvcr120.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\Qt5Core.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\Qt5Gui.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\Qt5Widgets.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\Qt5Network.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\Qt5Concurrent.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\icudt54.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\icuin54.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\icuuc54.dll %DESTDIR_X64% >NUL
COPY /B %QTDIR_X64%\..\plugins\platforms\qminimal.dll %DESTDIR_X64%\platforms >NUL
COPY /B %QTDIR_X64%\..\plugins\platforms\qwindows.dll %DESTDIR_X64%\platforms >NUL
COPY /B %BUILDDIR_X64%\Qt-SESAM.exe %DESTDIR_X64% >NUL
COPY /B ..\resources\images\* %DESTDIR_X64%\resources\images >NUL
ECHO Removing this file will disable portability.>%DESTDIR_X64%\PORTABLE

ECHO Launching installer script ...

makensis.exe /V4 Qt-SESAM-x86.nsi
makensis.exe /V4 Qt-SESAM-x64.nsi

ECHO Build compressed archives ...

7z a -t7z -mmt=on %DESTDIR_X86%.7z %DESTDIR_X86%
7z a -tZip -mmt=on %DESTDIR_X86%.zip %DESTDIR_X86%

7z a -t7z -mmt=on %DESTDIR_X64%.7z %DESTDIR_X64%
7z a -tZip -mmt=on %DESTDIR_X64%.zip %DESTDIR_X64%

ECHO Generating hash files ...

HashMaster.exe %INSTALLER_GLOB%
HashMaster.exe %DESTDIR_X86%.7z
HashMaster.exe %DESTDIR_X86%.zip
HashMaster.exe %DESTDIR_X64%.7z
HashMaster.exe %DESTDIR_X64%.zip
