@echo off
setlocal
title atvloadly
cd /d "%~dp0"
if not exist "data" mkdir "data"

rem Tai thu vien anisette (CoreADI) cua Apple neu chua co (chi lan dau)
if not exist "%APPDATA%\PlumeImpactor\lib\x86_64\libstoreservicescore.so" (
  echo [atvloadly] Chua co thu vien anisette, dang tai lan dau ^(~140MB^)...
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\setup-anisette.ps1"
)

tasklist /FI "IMAGENAME eq atvloadly.exe" 2>nul | find /I "atvloadly.exe" >nul
if not errorlevel 1 (
  echo [atvloadly] Dang chay roi. Mo trinh duyet...
  start "" http://localhost:5533
  exit /b 0
)

echo [atvloadly] Khoi dong tai http://localhost:5533  ^(dong cua so nay de tat^)
start "" /min cmd /c "timeout /t 4 /nobreak >nul && start http://localhost:5533"
"%~dp0atvloadly.exe" server -c "%~dp0data\config.yaml"
echo.
echo [atvloadly] Da dung. Xem log: data\app.log
pause
