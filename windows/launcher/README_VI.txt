ATVLOADLY CHO WINDOWS - BAN CAI DAT
===================================
atvloadly v0.6.2-7-g0cb114d-win + plumesign 2.2.3-patch.8 (Windows x64)
Ban build Windows cong dong tu bitxeno/atvloadly (tac gia goc chi phat hanh ban Linux/Docker).

SU DUNG
- Mo "atvloadly" tu Start Menu hoac Desktop: app chay ngam va mo http://localhost:5533
- "Dung atvloadly" trong Start Menu de tat.
- Tu may khac trong LAN: http://<IP-cua-PC>:5533
- Doi cong: sua dong  Const PORT = "5533"  trong <thu muc cai dat>\atvloadly.vbs (can Admin).

GHEP DOI APPLE TV (tvOS 17+)
- Apple TV: Settings > Remotes and Devices > Remote App and Devices (mo man hinh ghep doi).
- Trong atvloadly bam Pair va nhap ma PIN tren TV.
- Khong can iTunes/Bonjour/Docker/WSL cho tvOS 17+.

NEU KHONG THAY APPLE TV (mDNS)
- atvloadly tu nghe mDNS (UDP 5353) va dung chung cong voi Bonjour (mDNSResponder.exe)
  va dich vu mDNS cua Windows - KHONG can go Bonjour. Bo cai khong dong cham Bonjour.
- Kiem tra: mang dat la "Private"; tuong lua da mo UDP 5353; Apple TV va PC cung mang
  (khong qua VPN, khong o mang Guest/AP isolation).
- Neu da cai Bonjour, co the kiem tra Apple TV co quang ba khong, trong cmd:
    dns-sd -B _remotepairing-manual-pairing._tcp     (khi TV dang mo man hinh ghep doi)
    dns-sd -B _remotepairing._tcp                    (sau khi da ghep doi)
  Neu dns-sd thay ma atvloadly khong thay: tat app, bat lai, xem app.log.
- Ghep doi thu cong (khong qua mDNS cua atvloadly):
    dns-sd -L "<ten hien o cot Instance Name>" _remotepairing-manual-pairing._tcp
      -> lay IP/host va cong (port)
    "<thu muc cai dat>\plumesign.exe" pair --ip <IP-AppleTV> --port <port>
  File ghep doi se luu vao %APPDATA%\PlumeImpactor\pairing_files. Viec cai app sau do
  van can atvloadly thay Apple TV qua mDNS (_remotepairing._tcp).

DU LIEU
- %LOCALAPPDATA%\atvloadly : config.yaml, app.db (app da cai), app.log
- %APPDATA%\PlumeImpactor  : Apple ID, pairing_files, lib\x86_64 (anisette)

MICROSOFT DEFENDER / ANTIVIRUS
- Bo cai (tuy chon) them loai tru Defender cho thu muc cai dat va %APPDATA%\PlumeImpactor;
  go cai dat se xoa loai tru nay.
- Neu Defender van cach ly (quarantine) plumesign.exe/atvloadly.exe:
  Windows Security > Virus & threat protection > Protection history > chon muc bi chan >
  Actions > Restore (hoac "Allow on device"), roi cai lai atvloadly.
  Them loai tru thu cong: Virus & threat protection settings > Exclusions > Add an exclusion
  > Folder > chon thu muc cai dat va %APPDATA%\PlumeImpactor.
- Antivirus khac (Kaspersky, Avast...): them ngoai le tuong tu trong phan mem do.
- SmartScreen canh bao bo cai chua ky so: More info > Run anyway.

LUU Y
- Ket noi kieu cu (tvOS 16-, USB) can Apple Mobile Device Service: cai app
  "Apple Devices" tu Microsoft Store: https://apps.microsoft.com/detail/9np83lwlpz9k
- Thu vien anisette (Apple) duoc tai tu apps.mzstatic.com va chay bang trinh nap ELF
  tich hop trong plumesign. Neu tai/nap loi, plumesign dung anisette tu xa
  (ani.sidestore.io). Thu lai: Settings > Update CoreADI trong atvloadly, hoac
  powershell -ExecutionPolicy Bypass -File "<thu muc cai dat>\scripts\setup-anisette.ps1"
- Da kiem tra tren Windows that: tim Apple TV, ghep doi, cai app, anisette deu hoat dong.
  Neu gap loi, xem %LOCALAPPDATA%\atvloadly\app.log.
