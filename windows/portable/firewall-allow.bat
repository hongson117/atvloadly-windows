@echo off
rem Mo tuong lua cho atvloadly (web 5533 + mDNS 5353) va plumesign. Can chay bang quyen Administrator.
net session >nul 2>&1
if errorlevel 1 (
  echo Hay chuot phai file nay ^> "Run as administrator".
  pause & exit /b 1
)
netsh advfirewall firewall delete rule name="atvloadly" >nul 2>&1
netsh advfirewall firewall delete rule name="atvloadly-plumesign" >nul 2>&1
netsh advfirewall firewall add rule name="atvloadly" dir=in action=allow program="%~dp0atvloadly.exe" enable=yes profile=private,domain
netsh advfirewall firewall add rule name="atvloadly-plumesign" dir=in action=allow program="%~dp0plumesign.exe" enable=yes profile=private,domain
echo Xong. Luu y: mang Wi-Fi/LAN cua ban phai dat la "Private" (Rieng tu).
pause
