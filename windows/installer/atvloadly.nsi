; atvloadly Windows installer (NSIS 3, Unicode, English + Vietnamese)
Unicode true
Target amd64-unicode
ManifestDPIAware true
SetCompressor /SOLID lzma

!define APPNAME "atvloadly"
!define APPVER "0.6.2.7"
!define APPVERSTR "0.6.2-7-win"
!define PUBLISHER "Community Windows build of bitxeno/atvloadly"
!define UNINSTKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\atvloadly"
!define STOREURL "ms-windows-store://pdp/?ProductId=9NP83LWLPZ9K"
!define STOREWEB "https://apps.microsoft.com/detail/9np83lwlpz9k"
!define PORT "5533"

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

Name "${APPNAME}"
Caption "$(S_Caption)"
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
VIAddVersionKey /LANG=1033 "ProductName" "${APPNAME}"
VIAddVersionKey /LANG=1033 "FileVersion" "${APPVERSTR}"
VIAddVersionKey /LANG=1033 "ProductVersion" "${APPVERSTR}"
VIAddVersionKey /LANG=1033 "FileDescription" "atvloadly installer for Windows"
VIAddVersionKey /LANG=1033 "LegalCopyright" "AGPL-3.0 (atvloadly) / MIT (PlumeImpactor)"

!define MUI_ABORTWARNING
!define MUI_LANGDLL_REGISTRY_ROOT "HKLM"
!define MUI_LANGDLL_REGISTRY_KEY "Software\atvloadly"
!define MUI_LANGDLL_REGISTRY_VALUENAME "InstallerLanguage"
!define MUI_LANGDLL_ALLLANGUAGES
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_WELCOMEPAGE_TITLE "$(S_WelcomeTitle)"
!define MUI_WELCOMEPAGE_TEXT "$(S_WelcomeText)"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "payload\licenses\atvloadly-LICENSE-AGPL3.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "$(S_FinishTitle)"
!define MUI_FINISHPAGE_TEXT "$(S_FinishText)"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "$(S_FinishRun)"
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchApp
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(S_FinishStore)"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION OpenAppleDevicesStore
!define MUI_FINISHPAGE_LINK "$(S_FinishLink)"
!define MUI_FINISHPAGE_LINK_LOCATION "$INSTDIR\$(S_ReadmeFile)"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Vietnamese"
!insertmacro MUI_RESERVEFILE_LANGDLL

; ---------------------------------------------------------------- strings
!define EN ${LANG_ENGLISH}
!define VI ${LANG_VIETNAMESE}
LangString S_Caption ${EN} "${APPNAME} ${APPVERSTR} Setup"
LangString S_Caption ${VI} "Cài đặt ${APPNAME} ${APPVERSTR}"
LangString S_WelcomeTitle ${EN} "Install atvloadly for Windows"
LangString S_WelcomeTitle ${VI} "Cài đặt atvloadly cho Windows"
LangString S_WelcomeText ${EN} "This installer will install atvloadly (web server that installs & auto-renews apps on Apple TV) and plumesign.$\r$\n$\r$\nNo Docker, WSL or virtual machine needed. Web UI: http://localhost:${PORT}$\r$\n$\r$\nThis is a community Windows build of bitxeno/atvloadly.$\r$\n$\r$\nClick Next to continue."
LangString S_WelcomeText ${VI} "Bộ cài sẽ cài atvloadly (máy chủ web nạp & tự gia hạn app cho Apple TV) và plumesign.$\r$\n$\r$\nKhông cần Docker, WSL hay máy ảo. Giao diện: http://localhost:${PORT}$\r$\n$\r$\nĐây là bản build Windows cộng đồng từ bitxeno/atvloadly.$\r$\n$\r$\nNhấn Tiếp để tiếp tục."
LangString S_FinishTitle ${EN} "atvloadly has been installed"
LangString S_FinishTitle ${VI} "Đã cài xong atvloadly"
LangString S_FinishText ${EN} "atvloadly has been installed on this computer.$\r$\n$\r$\nWeb UI: http://localhost:${PORT}$\r$\nApple TV (tvOS 17+): Settings > Remotes and Devices > Remote App and Devices, then click Pair in atvloadly."
LangString S_FinishText ${VI} "atvloadly đã được cài vào máy.$\r$\n$\r$\nGiao diện web: http://localhost:${PORT}$\r$\nApple TV (tvOS 17+): Settings > Remotes and Devices > Remote App and Devices, rồi bấm Pair trong atvloadly."
LangString S_FinishRun ${EN} "Run atvloadly and open http://localhost:${PORT}"
LangString S_FinishRun ${VI} "Chạy atvloadly và mở http://localhost:${PORT}"
LangString S_FinishStore ${EN} "Open Microsoft Store to install Apple Devices (only needed for tvOS 16 and older / USB)"
LangString S_FinishStore ${VI} "Mở Microsoft Store để cài Apple Devices (chỉ cần cho tvOS 16 trở xuống / USB)"
LangString S_FinishLink ${EN} "Guide (English README)"
LangString S_FinishLink ${VI} "Hướng dẫn (README tiếng Việt)"
LangString S_ReadmeFile ${EN} "README_EN.txt"
LangString S_ReadmeFile ${VI} "README_VI.txt"
LangString S_Stopping ${EN} "Stopping atvloadly (if running)..."
LangString S_Stopping ${VI} "Đang dừng atvloadly (nếu đang chạy)..."
LangString S_RemovingDefender ${EN} "Removing Microsoft Defender exclusions..."
LangString S_RemovingDefender ${VI} "Đang gỡ loại trừ Microsoft Defender..."
LangString S_Only64 ${EN} "atvloadly only supports 64-bit Windows."
LangString S_Only64 ${VI} "atvloadly chỉ hỗ trợ Windows 64-bit."
LangString S_SecDefender ${EN} "Add Microsoft Defender exclusions (install folder + %APPDATA%\PlumeImpactor)"
LangString S_SecDefender ${VI} "Thêm loại trừ Microsoft Defender (thư mục cài đặt + %APPDATA%\PlumeImpactor)"
LangString S_AddingDefender ${EN} "Adding Microsoft Defender exclusions..."
LangString S_AddingDefender ${VI} "Đang thêm loại trừ Microsoft Defender..."
LangString S_DefenderFail ${EN} "Could not add Defender exclusions (code $0) - Defender is off/managed by an organization, or another antivirus is used."
LangString S_DefenderFail ${VI} "Không thêm được loại trừ Defender (mã $0) - Defender bị tắt/quản lý bởi tổ chức, hoặc dùng antivirus khác."
LangString S_SecCore ${EN} "atvloadly (required)"
LangString S_SecCore ${VI} "atvloadly (bắt buộc)"
LangString S_LnkStop ${EN} "Stop atvloadly"
LangString S_LnkStop ${VI} "Dừng atvloadly"
LangString S_LnkReadme ${EN} "Guide (README)"
LangString S_LnkReadme ${VI} "Hướng dẫn (README)"
LangString S_LnkUninstall ${EN} "Uninstall atvloadly"
LangString S_LnkUninstall ${VI} "Gỡ cài đặt atvloadly"
LangString S_SecFirewall ${EN} "Open firewall (TCP ${PORT}, UDP 5353 mDNS - Private network)"
LangString S_SecFirewall ${VI} "Mở tường lửa (TCP ${PORT}, UDP 5353 mDNS - mạng Private)"
LangString S_AddingFirewall ${EN} "Adding Windows Firewall rules..."
LangString S_AddingFirewall ${VI} "Đang thêm luật tường lửa Windows..."
LangString S_FirewallWarn ${EN} "Warning: netsh returned code $0 - you may need to open the firewall manually."
LangString S_FirewallWarn ${VI} "Cảnh báo: netsh trả về mã $0 - có thể cần mở tường lửa thủ công."
LangString S_SecAnisette ${EN} "Download Apple's anisette libraries (~140MB)"
LangString S_SecAnisette ${VI} "Tải thư viện anisette của Apple (~140MB)"
LangString S_DlAnisette ${EN} "Downloading anisette libraries (a PowerShell window shows progress)..."
LangString S_DlAnisette ${VI} "Đang tải thư viện anisette (cửa sổ PowerShell hiển thị tiến độ)..."
LangString S_AnisetteFailLog ${EN} "Could not download anisette libraries (code: $0)."
LangString S_AnisetteFailLog ${VI} "Không tải được thư viện anisette (mã: $0)."
LangString S_AnisetteFailMsg ${EN} "Could not download Apple's anisette libraries.$\r$\n$\r$\natvloadly still works: plumesign will use a remote anisette server (ani.sidestore.io).$\r$\nYou can retry later in atvloadly: Settings > Update CoreADI."
LangString S_AnisetteFailMsg ${VI} "Không tải được thư viện anisette của Apple.$\r$\n$\r$\natvloadly vẫn hoạt động: plumesign sẽ dùng máy chủ anisette từ xa (ani.sidestore.io).$\r$\nCó thể thử lại sau trong atvloadly: Settings > Update CoreADI."
LangString S_AnisetteOk ${EN} "Anisette libraries installed to %APPDATA%\PlumeImpactor\lib\x86_64"
LangString S_AnisetteOk ${VI} "Đã cài thư viện anisette vào %APPDATA%\PlumeImpactor\lib\x86_64"
LangString S_SecDesktop ${EN} "Desktop shortcut"
LangString S_SecDesktop ${VI} "Biểu tượng trên Desktop"
LangString S_SecAutostart ${EN} "Start atvloadly automatically at Windows sign-in"
LangString S_SecAutostart ${VI} "Tự chạy atvloadly khi đăng nhập Windows"
LangString S_DescCore ${EN} "atvloadly.exe, plumesign.exe, Start Menu shortcuts and the uninstaller."
LangString S_DescCore ${VI} "atvloadly.exe, plumesign.exe, lối tắt Start Menu và trình gỡ cài đặt."
LangString S_DescFirewall ${EN} "Allow web port ${PORT}/TCP and mDNS 5353/UDP (Apple TV discovery) on Private networks."
LangString S_DescFirewall ${VI} "Cho phép cổng web ${PORT}/TCP và mDNS 5353/UDP (tìm Apple TV) trên mạng Private."
LangString S_DescDefender ${EN} "Add Defender exclusions for the install folder and %APPDATA%\PlumeImpactor so Defender does not quarantine plumesign.exe / the anisette libraries. Uninstalling removes these exclusions."
LangString S_DescDefender ${VI} "Thêm loại trừ Defender cho thư mục cài đặt và %APPDATA%\PlumeImpactor, tránh Defender cách ly plumesign.exe / thư viện anisette. Gỡ cài đặt sẽ xóa loại trừ này."
LangString S_DescAnisette ${EN} "Download the Apple Music APK from Apple's servers and extract libstoreservicescore.so/libCoreADI.so into %APPDATA%\PlumeImpactor. If skipped, plumesign uses remote anisette."
LangString S_DescAnisette ${VI} "Tải Apple Music APK từ máy chủ Apple và lấy libstoreservicescore.so/libCoreADI.so vào %APPDATA%\PlumeImpactor. Nếu bỏ qua, plumesign dùng anisette từ xa."
LangString S_DescDesktop ${EN} "Create an atvloadly icon on the Desktop."
LangString S_DescDesktop ${VI} "Tạo biểu tượng atvloadly trên Desktop."
LangString S_DescAutostart ${EN} "Run atvloadly in the background at every sign-in (needed to auto-renew apps every 7 days)."
LangString S_DescAutostart ${VI} "Chạy ngầm atvloadly mỗi khi đăng nhập (cần để tự gia hạn app 7 ngày)."
LangString S_RemovingFirewall ${EN} "Removing firewall rules..."
LangString S_RemovingFirewall ${VI} "Đang xóa luật tường lửa..."
LangString S_DeleteData ${EN} "Also delete user data?$\r$\n$\r$\n- $LOCALAPPDATA\atvloadly (configuration, installed-apps database, logs)$\r$\n- $APPDATA\PlumeImpactor (Apple ID session, Apple TV pairing files, anisette)$\r$\n$\r$\nChoose No to keep it (a later reinstall can reuse it)."
LangString S_DeleteData ${VI} "Xóa cả dữ liệu người dùng?$\r$\n$\r$\n- $LOCALAPPDATA\atvloadly (cấu hình, CSDL app đã cài, log)$\r$\n- $APPDATA\PlumeImpactor (phiên Apple ID, file ghép đôi Apple TV, anisette)$\r$\n$\r$\nChọn Không để giữ lại (cài lại sau vẫn dùng được)."

; ---------------------------------------------------------------- helpers
!macro StopApp
  DetailPrint "$(S_Stopping)"
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
  DetailPrint "$(S_RemovingDefender)"
  nsExec::ExecToLog `${PS} "try { Remove-MpPreference -ExclusionPath '$INSTDIR','$1' -ErrorAction Stop; 'Defender: da go loai tru' } catch { 'Defender: ' + $$_.Exception.Message }"`
  Pop $0
!macroend

Function .onInit
  ${IfNot} ${RunningX64}
    MessageBox MB_ICONSTOP "$(S_Only64)" /SD IDOK
    Abort
  ${EndIf}
  SetRegView 64
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function un.onInit
  SetRegView 64
  !insertmacro MUI_UNGETLANGUAGE
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
Section "$(S_SecDefender)" SecDefender
  ; Runs before the files are extracted so Defender cannot quarantine them on write.
  DetailPrint "$(S_AddingDefender)"
  nsExec::ExecToLog `${PS} "try { Add-MpPreference -ExclusionPath '$INSTDIR','$APPDATA\PlumeImpactor' -ErrorAction Stop; 'Defender: da them loai tru' } catch { 'Defender: khong them duoc loai tru: ' + $$_.Exception.Message; exit 1 }"`
  Pop $0
  ${If} $0 != 0
    DetailPrint "$(S_DefenderFail)"
  ${Else}
    WriteRegStr HKLM "Software\atvloadly" "DefenderPlumeDir" "$APPDATA\PlumeImpactor"
  ${EndIf}
SectionEnd

Section "$(S_SecCore)" SecCore
  SectionIn RO
  !insertmacro StopApp
  SetOutPath "$INSTDIR"
  File "payload\atvloadly.exe"
  File "payload\plumesign.exe"
  File "payload\atvloadly.vbs"
  File "payload\stop.bat"
  File "payload\README_VI.txt"
  File "payload\README_EN.txt"
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
  CreateShortcut "$SMPROGRAMS\atvloadly\$(S_LnkStop).lnk" "$INSTDIR\stop.bat" "" "$SYSDIR\shell32.dll" 27
  CreateShortcut "$SMPROGRAMS\atvloadly\$(S_LnkReadme).lnk" "$INSTDIR\$(S_ReadmeFile)"
  CreateShortcut "$SMPROGRAMS\atvloadly\$(S_LnkUninstall).lnk" "$INSTDIR\uninstall.exe"
  SetShellVarContext current
SectionEnd

Section "$(S_SecFirewall)" SecFirewall
  DetailPrint "$(S_AddingFirewall)"
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
    DetailPrint "$(S_FirewallWarn)"
  ${EndIf}
SectionEnd


Section "$(S_SecAnisette)" SecAnisette
  DetailPrint "$(S_DlAnisette)"
  ClearErrors
  ExecWait '"$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$INSTDIR\scripts\setup-anisette.ps1"' $0
  ${If} ${Errors}
  ${OrIf} $0 != 0
    DetailPrint "$(S_AnisetteFailLog)"
    MessageBox MB_ICONEXCLAMATION "$(S_AnisetteFailMsg)" /SD IDOK
  ${Else}
    DetailPrint "$(S_AnisetteOk)"
  ${EndIf}
SectionEnd

Section "$(S_SecDesktop)" SecDesktop
  SetShellVarContext all
  CreateShortcut "$DESKTOP\atvloadly.lnk" "$SYSDIR\wscript.exe" '"$INSTDIR\atvloadly.vbs"' "$INSTDIR\atvloadly.exe" 0
  SetShellVarContext current
SectionEnd

Section /o "$(S_SecAutostart)" SecAutostart
  SetShellVarContext all
  CreateShortcut "$SMSTARTUP\atvloadly.lnk" "$SYSDIR\wscript.exe" '"$INSTDIR\atvloadly.vbs" /nobrowser' "$INSTDIR\atvloadly.exe" 0
  SetShellVarContext current
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "$(S_DescCore)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFirewall} "$(S_DescFirewall)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDefender} "$(S_DescDefender)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAnisette} "$(S_DescAnisette)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "$(S_DescDesktop)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAutostart} "$(S_DescAutostart)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ---------------------------------------------------------------- uninstaller
Section "Uninstall"
  !insertmacro StopApp
  DetailPrint "$(S_RemovingFirewall)"
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
  Delete "$INSTDIR\README_EN.txt"
  Delete "$INSTDIR\SHA256SUMS.txt"
  RMDir /r "$INSTDIR\scripts"
  RMDir /r "$INSTDIR\licenses"
  RMDir /r "$INSTDIR\source"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"

  DeleteRegKey HKLM "${UNINSTKEY}"
  DeleteRegKey HKLM "Software\atvloadly"

  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "$(S_DeleteData)" /SD IDNO IDNO keepdata
    RMDir /r "$LOCALAPPDATA\atvloadly"
    RMDir /r "$APPDATA\PlumeImpactor"
  keepdata:
SectionEnd
