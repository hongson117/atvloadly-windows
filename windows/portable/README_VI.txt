ATVLOADLY CHO WINDOWS (BAN NATIVE, KHONG CAN DOCKER/WSL)
========================================================
Phien ban: atvloadly v0.8.0-1-win + plumesign 2.7.1-patch.5 (Windows x64)
Yeu cau: Windows 10/11 64-bit, PC va Apple TV cung mot mang LAN/Wi-Fi.

1. NOI DUNG THU MUC
-------------------
  atvloadly.exe          May chu web + quan ly nap/gia han app (giao dien da nhung san).
  plumesign.exe          Engine ky & cai IPA, ghep doi Apple TV (bitxeno/PlumeImpactor,
                         ban fork ma atvloadly can - KHONG dung plumesign cua claration/impactor,
                         vi ban do thieu cac lenh pair/check/certificate/sign-rsd).
  start.bat              Chay atvloadly (co cua so console) va mo trinh duyet.
  start-hidden.vbs       Chay an duoi nen (khong cua so).
  stop.bat               Tat atvloadly.
  install-autostart.bat  Tu chay an khi dang nhap Windows (khong can Admin).
  remove-autostart.bat   Bo tu chay.
  firewall-allow.bat     Mo tuong lua (chuot phai > Run as administrator).
  scripts\setup-anisette.ps1  Tai thu vien anisette cua Apple (start.bat tu goi lan dau).
  data\                  Du lieu: config.yaml, app.db, app.log, tmp...
  source\, licenses\     Ban va (patch) ma nguon + giay phep (AGPL-3.0 / MIT).

2. CACH CHAY
------------
  a) Giai nen ra thu muc co dinh, vi du C:\atvloadly (tranh thu muc co dau tieng Viet).
  b) Chuot phai firewall-allow.bat > Run as administrator (1 lan). Neu Windows hien
     hop thoai tuong lua khi chay, chon "Allow" cho mang Private.
     Mang Wi-Fi/LAN cua PC phai dat la "Private" (Settings > Network > Properties).
  c) Chay start.bat. Lan dau se thu tai ~140MB thu vien anisette (tuy chon) tu Apple.
  d) Mo trinh duyet: http://localhost:5533  (tu may khac trong LAN: http://<IP-PC>:5533)
  e) Muon chay ngam + tu khoi dong: chay install-autostart.bat (sau khi da chay start.bat 1 lan).

  Cong mac dinh: 5533 (sua trong data\config.yaml, muc server.port).
  (Ban goc atvloadly mac dinh 9000; Docker dung 80. Ban nay dat 5533.)

3. GHEP DOI APPLE TV (tvOS 17 tro len)
---------------------------------------
  - Tren Apple TV: Settings > Remotes and Devices > Remote App and Devices
    (de man hinh ghep doi mo).
  - Trong giao dien atvloadly, Apple TV se hien ra (tim qua mDNS/Bonjour tich hop san,
    khong can cai Bonjour). Bam Pair va nhap ma PIN hien tren TV.
  - File ghep doi luu tai: %APPDATA%\PlumeImpactor\pairing_files
  - Sau do dang nhap Apple ID, upload IPA, atvloadly se tu gia han moi 7 ngay
    (PC phai bat va atvloadly phai dang chay).

4. VI TRI DU LIEU
-----------------
  - data\ trong thu muc nay: config.yaml, app.db (SQLite), app.log, keys\, tmp\
  - %APPDATA%\PlumeImpactor : tai khoan Apple ID (accounts.json), pairing_files,
    lib\x86_64 (anisette), du lieu cua plumesign.
  - %ProgramData%\Apple\Lockdown : ho so lockdown (chi dung cho kieu ket noi cu, xem muc 5).

5. LUU Y / RUI RO
-----------------
  - Day la ban build Windows cong dong tu bitxeno/atvloadly (tac gia goc chi phat hanh
    ban Linux/Docker). Da kiem tra tren Windows that: tim Apple TV qua mDNS, ghep doi,
    cai app va anisette deu hoat dong. Neu gap loi, xem data\app.log.
  - Khong can WSL, Docker, VMware, iTunes hay Bonjour cho Apple TV tvOS 17+ (ket noi
    RemotePairing/RSD qua mang).
  - Chi khi dung kieu ket noi cu "Lockdown" (tvOS 16 tro xuong, hoac thiet bi cam USB)
    moi can Apple Mobile Device Service (usbmuxd cua Apple, cong 127.0.0.1:27015):
      cai app "Apple Devices" tu Microsoft Store (Windows 10/11)
        https://apps.microsoft.com/detail/9np83lwlpz9k
      hoac iTunes cho Windows: https://www.apple.com/itunes/download/win64
    (Apple khong cho phan phoi lai cac thanh phan nay nen khong dong goi san.)
  - Anisette: plumesign 2.7.1 mac dinh dung may chu anisette tu xa (mac-ani.jkcoxson.com),
    sua loi dang nhap "Authentication SRP error -80045". Thu vien cuc bo cua Apple
    (libstoreservicescore.so/libCoreADI.so) la tuy chon, khong dong goi; start.bat se thu tai
    tu apps.mzstatic.com, tai loi cung khong sao. Thu lai trong Settings > Update CoreADI.
  - Nut "khoi dong lai usbmuxd" trong giao dien khong co tac dung tren Windows.
  - Muc "Service status" (avahi-daemon) trong giao dien se trong tren Windows - binh thuong.
  - Antivirus/SmartScreen co the canh bao vi exe chua ky so: chon "More info > Run anyway".
  - Neu dung Apple ID chinh: nen dung Apple ID phu cho sideload (khuyen cao chung).
