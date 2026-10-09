@echo off
rem Tu dong chay atvloadly (an) moi khi dang nhap Windows - khong can quyen Admin
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
> "%STARTUP%\atvloadly.vbs" echo CreateObject("WScript.Shell").Run "wscript.exe ""%~dp0start-hidden.vbs""", 0, False
echo Da bat tu khoi dong: "%STARTUP%\atvloadly.vbs"
echo (Neu di chuyen thu muc atvloadly, hay chay lai file nay.)
pause
