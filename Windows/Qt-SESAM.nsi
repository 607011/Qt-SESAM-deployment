!define VERSIONMAJOR "2"
!define VERSIONMINOR "5"
!define VERSIONPATCH ".0-DEV"
!define VERSION "${VERSIONMAJOR}.${VERSIONMINOR}${VERSIONPATCH}"
!define GUID "{f25f512a-7d58-4e2f-a52b-3663fd8ca813}"
!define APP "Qt-SESAM"
!define PUBLISHER "Heise Medien GmbH & Co. KG - Redaktion c't"
!define QTDIR "D:\Qt\5.5\msvc2013\bin"
!define SRCDIR "..\..\Qt-SESAM"
!define BUILDDIR "..\..\Qt-SESAM-Desktop_Qt_5_5_0_MSVC2013_32bit-Release\Qt-SESAM\release"
!define BUILDDIR_CHROME_EXT "..\..\Qt-SESAM-Desktop_Qt_5_5_0_MSVC2013_32bit-Release\SESAM2Chrome\release"
!define CHROME_EXT "SESAM2Chrome"
!define PATH_TO_CHROME "C:\Program Files (x86)\Google\Chrome\Application"

Name "${APP} ${VERSION}"
OutFile "${APP}-${VERSION}-x86-setup.exe"
InstallDir $PROGRAMFILES\${APP}
InstallDirRegKey HKLM "Software\${PUBLISHER}\${APP}" "Install_Dir"
RequestExecutionLevel admin
SetCompressor lzma
ShowInstDetails show

# !include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"

# !define MUI_FINISHPAGE_RUN "$INSTDIR\${APP}.exe"
# !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
# !define MUI_FINISHPAGE_RUN_TEXT "${APP} starten"

# Function LaunchLink
#   SetOutPath $INSTDIR
#   ExecShell "" '"$INSTDIR\${APP}.exe"'
# FunctionEnd


!define StrRep "!insertmacro StrRep"
!macro StrRep output string old new
    Push `${string}`
    Push `${old}`
    Push `${new}`
    !ifdef __UNINSTALL__
        Call un.StrRep
    !else
        Call StrRep
    !endif
    Pop ${output}
!macroend
 
!macro Func_StrRep un
    Function ${un}StrRep
        Exch $R2 ;new
        Exch 1
        Exch $R1 ;old
        Exch 2
        Exch $R0 ;string
        Push $R3
        Push $R4
        Push $R5
        Push $R6
        Push $R7
        Push $R8
        Push $R9
 
        StrCpy $R3 0
        StrLen $R4 $R1
        StrLen $R6 $R0
        StrLen $R9 $R2
        loop:
            StrCpy $R5 $R0 $R4 $R3
            StrCmp $R5 $R1 found
            StrCmp $R3 $R6 done
            IntOp $R3 $R3 + 1 ;move offset by 1 to check the next character
            Goto loop
        found:
            StrCpy $R5 $R0 $R3
            IntOp $R8 $R3 + $R4
            StrCpy $R7 $R0 "" $R8
            StrCpy $R0 $R5$R2$R7
            StrLen $R6 $R0
            IntOp $R3 $R3 + $R9 ;move offset by length of the replacement string
            Goto loop
        done:
 
        Pop $R9
        Pop $R8
        Pop $R7
        Pop $R6
        Pop $R5
        Pop $R4
        Pop $R3
        Push $R0
        Push $R1
        Pop $R0
        Pop $R1
        Pop $R0
        Pop $R2
        Exch $R1
    FunctionEnd
!macroend
!insertmacro Func_StrRep ""
!insertmacro Func_StrRep "un."


Section "vcredist"
  ClearErrors
  ReadRegDword $R0 HKLM "SOFTWARE\Wow6432Node\Microsoft\DevDiv\vc\Servicing\12.0\RuntimeMinimum" "Version"
  ${If} $R0 != "12.0.21005"
    SetOutPath "$INSTDIR"
    File "x86\vcredist_msvc2013_x86.exe"
    ExecWait '"$INSTDIR\vcredist_msvc2013_x86.exe" /norestart /passive'
    Delete "$INSTDIR\vcredist_msvc2013_x86.exe"
  ${EndIf}
SectionEnd


Page license

  LicenseData "${SRCDIR}\LICENSE"

Page directory

Page instfiles

Section "${APP}"
  SetOutPath "$INSTDIR"
  CreateDirectory "$INSTDIR\platforms"
  CreateDirectory "$INSTDIR\plugins"
  CreateDirectory "$INSTDIR\plugins\imageformats"
  CreateDirectory "$INSTDIR\resources"
  CreateDirectory "$INSTDIR\resources\images"
  File "${BUILDDIR}\${APP}.exe"
  File "${SRCDIR}\LICENSE"
  File "x86\libeay32.dll"
  File "x86\ssleay32.dll"
  File "${QTDIR}\Qt5Core.dll"
  File "${QTDIR}\Qt5Gui.dll"
  File "${QTDIR}\Qt5Widgets.dll"
  File "${QTDIR}\Qt5Network.dll"
  File "${QTDIR}\Qt5Concurrent.dll"
  File "${QTDIR}\icudt54.dll"
  File "${QTDIR}\icuin54.dll"
  File "${QTDIR}\icuuc54.dll"

  SetOutPath "$INSTDIR\platforms"
  File "${QTDIR}\..\plugins\platforms\qminimal.dll"
  File "${QTDIR}\..\plugins\platforms\qwindows.dll"

; SetOutPath "$INSTDIR\plugins\imageformats"
; File "${QTDIR}\..\plugins\imageformats\qico.dll"
; File "${QTDIR}\..\plugins\imageformats\qdds.dll"
; File "${QTDIR}\..\plugins\imageformats\qgif.dll"
; File "${QTDIR}\..\plugins\imageformats\qicns.dll"
; File "${QTDIR}\..\plugins\imageformats\qjp2.dll"
; File "${QTDIR}\..\plugins\imageformats\qjpeg.dll"
; File "${QTDIR}\..\plugins\imageformats\qmng.dll"
; File "${QTDIR}\..\plugins\imageformats\qsvg.dll"

  SetOutPath "$INSTDIR"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "DisplayName" "${APP}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "DisplayIcon" "$INSTDIR\resources\images\ctSESAM.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "Publisher" "${PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "NoRepair" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "VersionMajor" "${VERSIONMAJOR}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "VersionMinor" "${VERSIONMINOR}"

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}" "EstimatedSize" "$0"

  SetOutPath "$INSTDIR\resources\images"
  File /a /r "${SRCDIR}\Qt-SESAM\resources\images\"

  SetOutPath "$INSTDIR"
SectionEnd


Section "Chrome Extension"
  WriteRegStr HKCU "Software\Google\Chrome\NativeMessagingHosts\de.ct.qtsesam" "" "$INSTDIR\manifest.json"
  SetOutPath "$INSTDIR"
  Var /GLOBAL CRXID
  File "${BUILDDIR_CHROME_EXT}\${CHROME_EXT}.exe"
  File "${CHROME_EXT}.crx"
  File "crx_id.txt"
  FileOpen $4 "crx_id.txt" r
  FileSeek $4 0
  FileRead $4 $CRXID 32
  FileClose $4
  FileOpen $4 "$INSTDIR\\manifest.json" w
  Var /GLOBAL CRX
  ${StrRep} $CRX "$INSTDIR\${CHROME_EXT}.exe" "\" "\\"
  FileWrite $4 '{ "name": "de.ct.qtsesam", "description": "SESAM2Chrome", "path": "$CRX", "type": "stdio", "allowed_origins": [ "chrome-extension://$CRXID/" ] }'
  FileClose $4
SectionEnd


Section "Start Menu Shortcuts"
  CreateDirectory "$SMPROGRAMS\${APP}"
  CreateShortCut "$SMPROGRAMS\${APP}\${APP} ${VERSION}.lnk" "$INSTDIR\${APP}.exe"
  CreateShortcut "$SMPROGRAMS\${APP}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
SectionEnd


Section "Desktop Icon"
  CreateShortCut "$DESKTOP\${APP}-${VERSION}.lnk" "$INSTDIR\${APP}.exe" ""
SectionEnd


# !insertmacro MUI_PAGE_FINISH

Section "Uninstall"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GUID}"
  DeleteRegKey HKLM "SOFTWARE\${APP}"

  Delete "$INSTDIR\LICENSE"
  Delete "$INSTDIR\${APP}.exe"
  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\LICENSE"
  Delete "$INSTDIR\Qt5Core.dll"
  Delete "$INSTDIR\Qt5Gui.dll"
  Delete "$INSTDIR\Qt5Widgets.dll"
  Delete "$INSTDIR\Qt5Network.dll"
  Delete "$INSTDIR\Qt5Concurrent.dll"
  Delete "$INSTDIR\Qt5Test.dll"
  Delete "$INSTDIR\icudt54.dll"
  Delete "$INSTDIR\icuin54.dll"
  Delete "$INSTDIR\icuuc54.dll"
  Delete "$INSTDIR\libeay32.dll"
  Delete "$INSTDIR\ssleay32.dll"
  Delete "$INSTDIR\platforms\qminimal.dll"
  Delete "$INSTDIR\platforms\qwindows.dll"
  RMDir "$INSTDIR\platforms"
  RMDir /r "$INSTDIR\plugins"

  Delete "$INSTDIR\${CHROME_EXT}.exe"
  Delete "$INSTDIR\${CHROME_EXT}.crx"
  Delete "crx_id.txt"
  Delete "manifest.json"

  Delete "$DESKTOP\${APP}-${VERSION}.lnk"
  Delete "$SMPROGRAMS\${APP}\*.*"
  RMDir "$SMPROGRAMS\${APP}"

  RMDir /r "$INSTDIR\resources"
  RMDir "$INSTDIR"
SectionEnd
