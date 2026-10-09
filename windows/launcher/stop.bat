@echo off
taskkill /IM atvloadly.exe /F
taskkill /IM plumesign.exe /F 2>nul
echo Da tat atvloadly.
timeout /t 2 >nul
