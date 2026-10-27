ATVLOADLY FOR WINDOWS (NATIVE BUILD, NO DOCKER/WSL NEEDED)
==========================================================
Version: atvloadly v0.8.0-1-win + plumesign 2.7.1-patch.5 (Windows x64)
Requirements: Windows 10/11 64-bit, PC and Apple TV on the same LAN/Wi-Fi.

1. FOLDER CONTENTS
------------------
  atvloadly.exe          Web server + app install/renewal manager (web UI embedded).
  plumesign.exe          IPA signing/install engine and Apple TV pairing (bitxeno/PlumeImpactor,
                         the fork atvloadly needs - NOT claration/impactor's plumesign,
                         which lacks the pair/check/certificate/sign-rsd commands).
  start.bat              Runs atvloadly (with a console window) and opens the browser.
  start-hidden.vbs       Runs hidden in the background (no window).
  stop.bat               Stops atvloadly.
  install-autostart.bat  Start hidden at Windows sign-in (no Admin needed).
  remove-autostart.bat   Remove autostart.
  firewall-allow.bat     Open the firewall (right-click > Run as administrator).
  scripts\setup-anisette.ps1  Downloads Apple's anisette libraries (start.bat runs it the first time).
  data\                  Data: config.yaml, app.db, app.log, tmp...
  source\, licenses\     Source patch + licenses (AGPL-3.0 / MIT).

2. HOW TO RUN
-------------
  a) Extract to a permanent folder, e.g. C:\atvloadly (avoid folders with accented/non-ASCII names).
  b) Right-click firewall-allow.bat > Run as administrator (once). If Windows shows a
     firewall prompt when running, choose "Allow" for Private networks.
     The PC's Wi-Fi/LAN network must be set to "Private" (Settings > Network > Properties).
  c) Run start.bat. The first run tries to download ~140MB of optional anisette libraries from Apple.
  d) Open a browser: http://localhost:5533  (from another LAN machine: http://<PC-IP>:5533)
  e) To run in the background + autostart: run install-autostart.bat (after running start.bat once).

  Default port: 5533 (change in data\config.yaml, server.port).
  (Upstream atvloadly defaults to 9000; Docker uses 80. This build uses 5533.)

3. PAIRING AN APPLE TV (tvOS 17 and later)
------------------------------------------
  - On the Apple TV: Settings > Remotes and Devices > Remote App and Devices
    (leave the pairing screen open).
  - In the atvloadly UI the Apple TV appears (found via built-in mDNS/Bonjour,
    no Bonjour install needed). Click Pair and enter the PIN shown on the TV.
  - Pairing files are stored in: %APPDATA%\PlumeImpactor\pairing_files
  - Then sign in with an Apple ID, upload an IPA; atvloadly renews it every 7 days
    (the PC must be on and atvloadly running).

4. DATA LOCATIONS
-----------------
  - data\ in this folder: config.yaml, app.db (SQLite), app.log, keys\, tmp\
  - %APPDATA%\PlumeImpactor : Apple ID accounts (accounts.json), pairing_files,
    lib\x86_64 (anisette), plumesign data.
  - %ProgramData%\Apple\Lockdown : lockdown records (only for the legacy connection, see section 5).

5. NOTES / RISKS
----------------
  - This is a community Windows build of bitxeno/atvloadly (upstream only ships
    Linux/Docker). Tested on real Windows: Apple TV discovery via mDNS, pairing,
    app install and anisette all work. If you hit a problem, see data\app.log.
  - No WSL, Docker, VMware, iTunes or Bonjour needed for Apple TV tvOS 17+ (RemotePairing/RSD
    connection over the network).
  - Only the legacy "Lockdown" connection (tvOS 16 and older, or USB devices)
    needs Apple Mobile Device Service (Apple's usbmuxd, port 127.0.0.1:27015):
      install the "Apple Devices" app from the Microsoft Store (Windows 10/11)
        https://apps.microsoft.com/detail/9np83lwlpz9k
      or iTunes for Windows: https://www.apple.com/itunes/download/win64
    (Apple does not allow redistributing these components, so they are not bundled.)
  - Anisette: plumesign 2.7.1 uses a remote anisette server (mac-ani.jkcoxson.com) by default,
    which fixes the login error "Authentication SRP error -80045". Apple's local libraries
    (libstoreservicescore.so/libCoreADI.so) are optional and not bundled; start.bat tries to
    download them from apps.mzstatic.com, and a failed download is harmless. Retry from
    Settings > Update CoreADI in the UI.
  - The "restart usbmuxd" button in the UI has no effect on Windows.
  - "Service status" (avahi-daemon) in the UI is empty on Windows - this is normal.
  - Antivirus/SmartScreen may warn because the exe is unsigned: choose "More info > Run anyway".
  - Using your main Apple ID is discouraged: use a secondary Apple ID for sideloading.
