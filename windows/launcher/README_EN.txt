ATVLOADLY FOR WINDOWS - INSTALLER EDITION
=========================================
atvloadly v0.6.2-7-g0cb114d-win + plumesign 2.2.3-patch.8 (Windows x64)
Community Windows build of bitxeno/atvloadly (upstream only ships Linux/Docker).

USAGE
- Open "atvloadly" from the Start Menu or Desktop: the app runs in the background and opens http://localhost:5533
- Use "Stop atvloadly" in the Start Menu to shut it down.
- From another machine on the LAN: http://<PC-IP>:5533
- Change the port: edit the line  Const PORT = "5533"  in <install dir>\atvloadly.vbs (requires Admin).

PAIRING AN APPLE TV (tvOS 17+)
- Apple TV: Settings > Remotes and Devices > Remote App and Devices (opens the pairing screen).
- In atvloadly click Pair and enter the PIN shown on the TV.
- No iTunes/Bonjour/Docker/WSL needed for tvOS 17+.

IF THE APPLE TV DOES NOT SHOW UP (mDNS)
- atvloadly listens for mDNS itself (UDP 5353) and shares the port with Bonjour (mDNSResponder.exe)
  and the Windows mDNS service - you do NOT need to uninstall Bonjour. The installer does not touch Bonjour.
- Check: the network is set to "Private"; the firewall allows UDP 5353; Apple TV and PC are on the same network
  (no VPN, not on a Guest network / AP isolation).
- If Bonjour is installed, you can check whether the Apple TV is advertising, in cmd:
    dns-sd -B _remotepairing-manual-pairing._tcp     (while the TV pairing screen is open)
    dns-sd -B _remotepairing._tcp                    (after pairing)
  If dns-sd sees it but atvloadly does not: stop the app, start it again, check app.log.
- Manual pairing (bypassing atvloadly's mDNS):
    dns-sd -L "<name shown in the Instance Name column>" _remotepairing-manual-pairing._tcp
      -> get the IP/host and port
    "<install dir>\plumesign.exe" pair --ip <AppleTV-IP> --port <port>
  The pairing file is saved to %APPDATA%\PlumeImpactor\pairing_files. Installing apps afterwards
  still requires atvloadly to see the Apple TV via mDNS (_remotepairing._tcp).

DATA
- %LOCALAPPDATA%\atvloadly : config.yaml, app.db (installed apps), app.log
- %APPDATA%\PlumeImpactor  : Apple ID, pairing_files, lib\x86_64 (anisette)

MICROSOFT DEFENDER / ANTIVIRUS
- The installer (optionally) adds Defender exclusions for the install dir and %APPDATA%\PlumeImpactor;
  uninstalling removes these exclusions.
- If Defender still quarantines plumesign.exe/atvloadly.exe:
  Windows Security > Virus & threat protection > Protection history > select the blocked item >
  Actions > Restore (or "Allow on device"), then reinstall atvloadly.
  Add exclusions manually: Virus & threat protection settings > Exclusions > Add an exclusion
  > Folder > choose the install dir and %APPDATA%\PlumeImpactor.
- Other antivirus (Kaspersky, Avast...): add similar exceptions in that software.
- SmartScreen warns that the installer is unsigned: More info > Run anyway.

NOTES
- The legacy connection (tvOS 16 and older, USB) needs Apple Mobile Device Service: install the
  "Apple Devices" app from the Microsoft Store: https://apps.microsoft.com/detail/9np83lwlpz9k
- The Apple anisette libraries are downloaded from apps.mzstatic.com and run by the ELF loader
  built into plumesign. If download/loading fails, plumesign uses a remote anisette server
  (ani.sidestore.io). Retry: Settings > Update CoreADI in atvloadly, or
  powershell -ExecutionPolicy Bypass -File "<install dir>\scripts\setup-anisette.ps1"
- Tested on real Windows: Apple TV discovery, pairing, app install and anisette all work.
  If you hit a problem, see %LOCALAPPDATA%\atvloadly\app.log.
