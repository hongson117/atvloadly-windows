; atvloadly Windows installer (NSIS 3, Unicode, tieng Viet)
Unicode true
Target amd64-unicode
ManifestDPIAware true
SetCompressor /SOLID lzma

!define APPNAME "atvloadly"
!define APPVER "0.6.2.7"
!define APPVERSTR "0.6.2-7-win"
!define PUBLISHER "bitxeno/atvloadly (ban build Windows khong chinh thuc)"
!define UNINSTKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\atvloadly"
!define STOREURL "ms-windows-store://pdp/?ProductId=9NP83LWLPZ9K"
!define STOREWEB "https://apps.microsoft.com/detail/9np83lwlpz9k"
!define PORT "5533"

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

Name "${APPNAME}"
Caption "Cài đặt ${APPNAME} ${APPVERSTR}"
!ifndef OUTFILE
  !define OUTFILE "atvloadly-setup.exe"
!endif
OutFile "${OUTFILE}"
InstallDir "$PROGRAMFILES64\atvloadly"
InstallDirRegKey HKLM "Software\atvloadly" "InstallDir"
RequestExecutionLevel admin
ShowInstDetails show
ShowUninstDetails show
BrandingText "atvloadly ${APPVERSTR}"

VIProductVersion "${APPVER}"
VIAddVersionKey /LANG=1066 "ProductName" "${APPNAME}"
VIAddVersionKey /LANG=1066 "FileVersion" "${APPVERSTR}"
VIAddVersionKey /LANG=1066 "ProductVersion" "${APPVERSTR}"
VIAddVersionKey /LANG=1066 "FileDescription" "Bộ cài atvloadly cho Windows"
VIAddVersionKey /LANG=1066 "LegalCopyright" "AGPL-3.0 (atvloadly) / MIT (PlumeImpactor)"

!define MUI_ABORTWARNING
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_WELCOMEPAGE_TITLE "Cài đặt atvloadly cho Windows"
!define MUI_WELCOMEPAGE_TEXT "Bộ cài sẽ cài atvloadly (máy chủ web nạp & tự gia hạn app cho Apple TV) và plumesign.$\r$\n$\r$\nKhông cần Docker, WSL hay máy ảo. Giao diện: http://localhost:${PORT}$\r$\n$\r$\nĐây là bản build KHÔNG CHÍNH THỨC từ mã nguồn bitxeno/atvloadly.$\r$\n$\r$\nNhấn Tiếp để tiếp tục."
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "payload\licenses\atvloadly-LICENSE-AGPL3.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "Đã cài xong atvloadly"
!define MUI_FINISHPAGE_TEXT "atvloadly đã được cài vào máy.$\r$\n$\r$\nGiao diện web: http://localhost:${PORT}$\r$\nApple TV (tvOS 17+): Settings > Remotes and Devices > Remote App and Devices, rồi bấm Pair trong atvloadly."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Chạy atvloadly và mở http://localhost:${PORT}"
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchApp
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Mở Microsoft Store để cài Apple Devices (chỉ cần cho tvOS 16 trở xuống / USB)"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION OpenAppleDevicesStore
!define MUI_FINISHPAGE_LINK "Hướng dẫn (README tiếng Việt)"
!define MUI_FINISHPAGE_LINK_LOCATION "$INSTDIR\README_VI.txt"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "Vietnamese"

; ---------------------------------------------------------------- helpers
!macro StopApp
  DetailPrint "Đang dừng atvloadly (nếu đang chạy)..."
  nsExec::ExecToLog '"$SYSDIR\taskkill.exe" /F /IM atvloadly.exe'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\taskkill.exe" /F /IM plumesign.exe'
  Pop $0
  Sleep 1000
!macroend

!macro RemoveFirewallRules
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall delete rule name="atvloadly Web (TCP ${PORT})"'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall delete rule name="atvloadly mDNS (UDP 5353)"'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall delete rule name="atvloadly app"'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall delete rule name="atvloadly plumesign"'
  Pop $0
!macroend

!define PS '"$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command'

!macro RemoveDefenderExclusions
  ; Exclusions were added for the installing user's %APPDATA%\PlumeImpactor and the install dir.
  ReadRegStr $1 HKLM "Software\atvloadly" "DefenderPlumeDir"
  ${If} $1 == ""
    StrCpy $1 "$APPDATA\PlumeImpactor"
  ${EndIf}
  DetailPrint "Đang gỡ loại trừ Microsoft Defender..."
  nsExec::ExecToLog `${PS} "try { Remove-MpPreference -ExclusionPath '$INSTDIR','$1' -ErrorAction Stop; 'Defender: da go loai tru' } catch { 'Defender: ' + $$_.Exception.Message }"`
  Pop $0
!macroend

Function .onInit
  ${IfNot} ${RunningX64}
    MessageBox MB_ICONSTOP "atvloadly chỉ hỗ trợ Windows 64-bit." /SD IDOK
    Abort
  ${EndIf}
  SetRegView 64
FunctionEnd

Function un.onInit
  SetRegView 64
FunctionEnd

; Launch as the normal (non-elevated) user through Explorer, so the app and its
; data run under the desktop user rather than the elevated installer.
Function LaunchApp
  Exec '"$WINDIR\explorer.exe" "$INSTDIR\atvloadly.vbs"'
FunctionEnd

Function OpenAppleDevicesStore
  ExecShell "open" "${STOREURL}"
  ${If} ${Errors}
    ExecShell "open" "${STOREWEB}"
  ${EndIf}
FunctionEnd

; ---------------------------------------------------------------- sections
Section "Thêm loại trừ Microsoft Defender (thư mục cài đặt + %APPDATA%\PlumeImpactor)" SecDefender
  ; Runs before the files are extracted so Defender cannot quarantine them on write.
  DetailPrint "Đang thêm loại trừ Microsoft Defender..."
  nsExec::ExecToLog `${PS} "try { Add-MpPreference -ExclusionPath '$INSTDIR','$APPDATA\PlumeImpactor' -ErrorAction Stop; 'Defender: da them loai tru' } catch { 'Defender: khong them duoc loai tru: ' + $$_.Exception.Message; exit 1 }"`
  Pop $0
  ${If} $0 != 0
    DetailPrint "Không thêm được loại trừ Defender (mã $0) - Defender bị tắt/quản lý bởi tổ chức, hoặc dùng antivirus khác."
  ${Else}
    WriteRegStr HKLM "Software\atvloadly" "DefenderPlumeDir" "$APPDATA\PlumeImpactor"
  ${EndIf}
SectionEnd

Section "atvloadly (bắt buộc)" SecCore
  SectionIn RO
  !insertmacro StopApp
  SetOutPath "$INSTDIR"
  File "payload\atvloadly.exe"
  File "payload\plumesign.exe"
  File "payload\atvloadly.vbs"
  File "payload\stop.bat"
  File "payload\README_VI.txt"
  File "payload\SHA256SUMS.txt"
  SetOutPath "$INSTDIR\scripts"
  File "payload\scripts\setup-anisette.ps1"
  SetOutPath "$INSTDIR\licenses"
  File /r "payload\licenses\*"
  SetOutPath "$INSTDIR\source"
  File /r "payload\source\*"
  SetOutPath "$INSTDIR"

  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "Software\atvloadly" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTKEY}" "DisplayName" "atvloadly"
  WriteRegStr HKLM "${UNINSTKEY}" "DisplayVersion" "${APPVERSTR}"
  WriteRegStr HKLM "${UNINSTKEY}" "Publisher" "${PUBLISHER}"
  WriteRegStr HKLM "${UNINSTKEY}" "DisplayIcon" "$INSTDIR\atvloadly.exe"
  WriteRegStr HKLM "${UNINSTKEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTKEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKLM "${UNINSTKEY}" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
  WriteRegStr HKLM "${UNINSTKEY}" "URLInfoAbout" "https://github.com/bitxeno/atvloadly"
  WriteRegDWORD HKLM "${UNINSTKEY}" "NoModify" 1
  WriteRegDWORD HKLM "${UNINSTKEY}" "NoRepair" 1
  WriteRegDWORD HKLM "${UNINSTKEY}" "EstimatedSize" 38000

  ; Start Menu shortcuts (all users)
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\atvloadly"
  CreateShortcut "$SMPROGRAMS\atvloadly\atvloadly.lnk" "$SYSDIR\wscript.exe" '"$INSTDIR\atvloadly.vbs"' "$INSTDIR\atvloadly.exe" 0
  CreateShortcut "$SMPROGRAMS\atvloadly\Dừng atvloadly.lnk" "$INSTDIR\stop.bat" "" "$SYSDIR\shell32.dll" 27
  CreateShortcut "$SMPROGRAMS\atvloadly\Hướng dẫn (README).lnk" "$INSTDIR\README_VI.txt"
  CreateShortcut "$SMPROGRAMS\atvloadly\Gỡ cài đặt atvloadly.lnk" "$INSTDIR\uninstall.exe"
  SetShellVarContext current
SectionEnd

Section "Mở tường lửa (TCP ${PORT}, UDP 5353 mDNS - mạng Private)" SecFirewall
  DetailPrint "Đang thêm luật tường lửa Windows..."
  !insertmacro RemoveFirewallRules
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall add rule name="atvloadly Web (TCP ${PORT})" dir=in action=allow protocol=TCP localport=${PORT} profile=private enable=yes'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall add rule name="atvloadly mDNS (UDP 5353)" dir=in action=allow protocol=UDP localport=5353 profile=private enable=yes'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall add rule name="atvloadly app" dir=in action=allow program="$INSTDIR\atvloadly.exe" profile=private enable=yes'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\netsh.exe" advfirewall firewall add rule name="atvloadly plumesign" dir=in action=allow program="$INSTDIR\plumesign.exe" profile=private enable=yes'
  Pop $0
  ${If} $0 != 0
    DetailPrint "Cảnh báo: netsh trả về mã $0 - có thể cần mở tường lửa thủ công."
  ${EndIf}
SectionEnd


Section "Tải thư viện anisette của Apple (~140MB)" SecAnisette
  DetailPrint "Đang tải thư viện anisette (cửa sổ PowerShell hiển thị tiến độ)..."
  ClearErrors
  ExecWait '"$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$INSTDIR\scripts\setup-anisette.ps1"' $0
  ${If} ${Errors}
  ${OrIf} $0 != 0
    DetailPrint "Không tải được thư viện anisette (mã: $0)."
    MessageBox MB_ICONEXCLAMATION "Không tải được thư viện anisette của Apple.$\r$\n$\r$\natvloadly vẫn hoạt động: plumesign sẽ dùng máy chủ anisette từ xa (ani.sidestore.io).$\r$\nCó thể thử lại sau trong atvloadly: Settings > Update CoreADI." /SD IDOK
  ${Else}
    DetailPrint "Đã cài thư viện anisette vào %APPDATA%\PlumeImpactor\lib\x86_64"
  ${EndIf}
SectionEnd

Section "Biểu tượng trên Desktop" SecDesktop
  SetShellVarContext all
  CreateShortcut "$DESKTOP\atvloadly.lnk" "$SYSDIR\wscript.exe" '"$INSTDIR\atvloadly.vbs"' "$INSTDIR\atvloadly.exe" 0
  SetShellVarContext current
SectionEnd

Section /o "Tự chạy atvloadly khi đăng nhập Windows" SecAutostart
  SetShellVarContext all
  CreateShortcut "$SMSTARTUP\atvloadly.lnk" "$SYSDIR\wscript.exe" '"$INSTDIR\atvloadly.vbs" /nobrowser' "$INSTDIR\atvloadly.exe" 0
  SetShellVarContext current
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "atvloadly.exe, plumesign.exe, lối tắt Start Menu và trình gỡ cài đặt."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFirewall} "Cho phép cổng web ${PORT}/TCP và mDNS 5353/UDP (tìm Apple TV) trên mạng Private."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDefender} "Thêm loại trừ Defender cho thư mục cài đặt và %APPDATA%\PlumeImpactor, tránh Defender cách ly plumesign.exe / thư viện anisette. Gỡ cài đặt sẽ xóa loại trừ này."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAnisette} "Tải Apple Music APK từ máy chủ Apple và lấy libstoreservicescore.so/libCoreADI.so vào %APPDATA%\PlumeImpactor. Nếu bỏ qua, plumesign dùng anisette từ xa."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Tạo biểu tượng atvloadly trên Desktop."
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAutostart} "Chạy ngầm atvloadly mỗi khi đăng nhập (cần để tự gia hạn app 7 ngày)."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ---------------------------------------------------------------- uninstaller
Section "Uninstall"
  !insertmacro StopApp
  DetailPrint "Đang xóa luật tường lửa..."
  !insertmacro RemoveFirewallRules
  !insertmacro RemoveDefenderExclusions

  SetShellVarContext all
  Delete "$SMSTARTUP\atvloadly.lnk"
  Delete "$DESKTOP\atvloadly.lnk"
  RMDir /r "$SMPROGRAMS\atvloadly"
  SetShellVarContext current
  Delete "$SMSTARTUP\atvloadly.lnk"

  Delete "$INSTDIR\atvloadly.exe"
  Delete "$INSTDIR\plumesign.exe"
  Delete "$INSTDIR\atvloadly.vbs"
  Delete "$INSTDIR\stop.bat"
  Delete "$INSTDIR\README_VI.txt"
  Delete "$INSTDIR\SHA256SUMS.txt"
  RMDir /r "$INSTDIR\scripts"
  RMDir /r "$INSTDIR\licenses"
  RMDir /r "$INSTDIR\source"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"

  DeleteRegKey HKLM "${UNINSTKEY}"
  DeleteRegKey HKLM "Software\atvloadly"

  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "Xóa cả dữ liệu người dùng?$\r$\n$\r$\n- $LOCALAPPDATA\atvloadly (cấu hình, CSDL app đã cài, log)$\r$\n- $APPDATA\PlumeImpactor (phiên Apple ID, file ghép đôi Apple TV, anisette)$\r$\n$\r$\nChọn Không để giữ lại (cài lại sau vẫn dùng được)." /SD IDNO IDNO keepdata
    RMDir /r "$LOCALAPPDATA\atvloadly"
    RMDir /r "$APPDATA\PlumeImpactor"
  keepdata:
SectionEnd
