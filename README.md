# atvloadly-windows

Bản build **Windows x64 native** (không cần Docker / WSL / máy ảo) của [bitxeno/atvloadly](https://github.com/bitxeno/atvloadly) — công cụ nạp và tự gia hạn (7 ngày) app IPA cho Apple TV.

> ⚠️ **Bản KHÔNG CHÍNH THỨC.** Tác giả atvloadly chỉ hỗ trợ Linux/Docker. Đây là fork có vá nhỏ để chạy trên Windows. Đừng báo lỗi của bản này lên repo gốc.
>
> README gốc của atvloadly: [README.upstream.md](README.upstream.md)

## Tải về

Xem [Releases](../../releases):

- `atvloadly-setup.exe` — bộ cài (khuyên dùng), giao diện tiếng Việt.
- `atvloadly-windows.zip` — bản portable (giải nén và chạy `start.bat`).
- `SHA256SUMS.txt` — mã băm để kiểm tra file.

## Cài đặt (bộ cài)

1. Chạy `atvloadly-setup.exe` (cần quyền Admin). SmartScreen có thể cảnh báo vì file chưa ký số: **More info → Run anyway**.
2. Chọn thành phần:
   - Loại trừ Microsoft Defender (thư mục cài đặt + `%APPDATA%\PlumeImpactor`).
   - Mở tường lửa: TCP 5533, UDP 5353 (mDNS), chỉ mạng **Private**.
   - Tải thư viện anisette của Apple (~140 MB, từ `apps.mzstatic.com`).
   - Biểu tượng Desktop, tự chạy khi đăng nhập (tuỳ chọn).
3. Kết thúc: app chạy ngầm và mở **http://localhost:5533**.

Dữ liệu: `%LOCALAPPDATA%\atvloadly` (cấu hình, CSDL, log) và `%APPDATA%\PlumeImpactor` (Apple ID, file ghép đôi, anisette). Gỡ cài đặt sẽ dừng app, xoá luật tường lửa, loại trừ Defender, tự khởi động, và hỏi có xoá dữ liệu không.

## Ghép đôi Apple TV (tvOS 17+)

1. Apple TV và PC cùng mạng LAN/Wi-Fi (mạng của PC đặt là **Private**, không qua VPN / Guest network).
2. Trên Apple TV: **Settings → Remotes and Devices → Remote App and Devices** (để màn hình ghép đôi mở).
3. Trong atvloadly, Apple TV hiện ra → bấm **Pair** → nhập mã PIN hiển thị trên TV.
4. Đăng nhập Apple ID (nên dùng Apple ID phụ), upload IPA. atvloadly tự gia hạn khi PC bật và app đang chạy.

Không cần iTunes/Bonjour cho tvOS 17+ (kết nối RemotePairing/RSD qua mạng). Kiểu kết nối cũ (tvOS 16 trở xuống hoặc USB) cần Apple Mobile Device Service: cài app [Apple Devices](https://apps.microsoft.com/detail/9np83lwlpz9k) từ Microsoft Store.

## Lưu ý / rủi ro

- **Đã kiểm tra trên Windows thật:** tìm Apple TV qua mDNS, ghép đôi, cài app, trình nạp anisette, máy chủ web, giao diện, API, gọi `plumesign.exe`, cài/gỡ bằng bộ cài. Log: `%LOCALAPPDATA%\atvloadly\app.log`.
- **Bonjour:** atvloadly nghe mDNS trên UDP 5353 với `SO_REUSEADDR`, dùng chung cổng với Bonjour (`mDNSResponder.exe`, cũng dùng `SO_REUSEADDR`) — không cần gỡ Bonjour; bộ cài không đụng tới Bonjour. Nếu không thấy Apple TV, có thể kiểm tra bằng `dns-sd -B _remotepairing-manual-pairing._tcp` và ghép đôi thủ công: `plumesign.exe pair --ip <IP> --port <port>` (lấy IP/port bằng `dns-sd -L`).
- **Anisette:** plumesign nạp trực tiếp thư viện Android ELF của Apple (`libstoreservicescore.so`, `libCoreADI.so`) bằng trình nạp ELF tích hợp (android-loader + hàm POSIX giả lập cho Windows). Nếu thiếu/lỗi, plumesign tự dùng máy chủ anisette từ xa `ani.sidestore.io`. Thư viện Apple **không** nằm trong repo hay bộ cài; được tải từ máy chủ Apple khi cài.
- **Defender / antivirus:** nếu file bị cách ly: Windows Security → Virus & threat protection → Protection history → Restore / Allow on device, rồi cài lại. Loại trừ Defender làm giảm bảo vệ cho 2 thư mục trên (có thể bỏ chọn khi cài).
- **SmartScreen:** bộ cài và exe chưa ký số.
- Đổi cổng: sửa `Const PORT = "5533"` trong `C:\Program Files\atvloadly\atvloadly.vbs`.

## Build từ mã nguồn

Trên Linux (Debian/Ubuntu), cần: Go ≥ 1.25 (hoặc `GOTOOLCHAIN=auto`), Node.js/npm, `gcc-mingw-w64-x86-64`, rustup (stable) + target `x86_64-pc-windows-gnu`, `cmake`, `nasm`, `nsis`, `python3`.

```bash
rustup target add x86_64-pc-windows-gnu
./windows/build.sh
# -> windows/dist/atvloadly-setup.exe, atvloadly-windows.zip, SHA256SUMS.txt
```

`plumesign.exe` được build (không sửa) từ [bitxeno/PlumeImpactor](https://github.com/bitxeno/PlumeImpactor) tag `v2.2.3-patch.8` — bản fork mà atvloadly cần. Bản `plumesign` của [claration/impactor](https://github.com/claration/impactor) **không** dùng được vì thiếu các lệnh `pair`, `check`, `certificate`, `sign-rsd`, `device-info`.

### Thay đổi so với bitxeno/atvloadly

Toàn bộ trong [windows/patches/atvloadly-windows.patch](windows/patches/atvloadly-windows.patch) (và commit trong repo này):

| File | Thay đổi |
|---|---|
| `internal/signing/flock_{unix,windows}.go`, `workspace.go`, `material.go` | Thay `syscall.Flock`/`O_NOFOLLOW` (chỉ có trên Unix) bằng `LockFileEx` trên Windows; giải phóng khoá trước khi xoá thư mục. |
| `internal/i18n/i18n.go` | Đường dẫn trong `embed.FS` dùng `path.Join` (lỗi crash `locales\en.json` trên Windows). |
| `internal/app/config.go` | Thư mục dữ liệu plumesign trên Windows là `%APPDATA%\PlumeImpactor`. |
| `internal/exec/resolve.go`, `command.go` | Tìm `plumesign.exe` cạnh `atvloadly.exe` (Go chặn chạy file trong thư mục hiện tại — `exec.ErrDot`). |
| `internal/utils/env_platform.go`, `install_manager.go`, `install_external.go` | Cô lập thư mục tạm/home cho plumesign bằng `TMP`/`TEMP`/`APPDATA`/`USERPROFILE` trên Windows. |
| `internal/service/service.go` | "Update CoreADI" ghi vào `%APPDATA%\PlumeImpactor\lib` trên Windows. |
| `go.mod` | `golang.org/x/sys` thành dependency trực tiếp. |

Trên Linux hành vi không đổi.

## License

- atvloadly và các thay đổi trong repo này: **AGPL-3.0** ([LICENSE](LICENSE)) — © bitxeno và cộng sự.
- plumesign / PlumeImpactor ([bitxeno/PlumeImpactor](https://github.com/bitxeno/PlumeImpactor), fork của [claration/impactor](https://github.com/claration/impactor)): **MIT** — kèm trong bộ cài (`licenses/`).
- Thư viện anisette là tài sản của Apple, không được phân phối trong repo/bộ cài.

---

## English (short)

Unofficial **native Windows x64** build of [bitxeno/atvloadly](https://github.com/bitxeno/atvloadly) (sideload & auto-refresh IPAs on Apple TV) — no Docker/WSL/VM.

- **Install:** run `atvloadly-setup.exe` from [Releases](../../releases) (admin; SmartScreen: *More info → Run anyway*). It installs to `Program Files\atvloadly`, optionally adds Defender exclusions and Private-profile firewall rules (TCP 5533, UDP 5353), downloads Apple's anisette libraries from Apple's CDN, and opens http://localhost:5533. A portable zip is also provided.
- **Pairing (tvOS 17+):** Apple TV → Settings → Remotes and Devices → Remote App and Devices, then click *Pair* in atvloadly and enter the PIN. No iTunes/Bonjour needed; legacy (tvOS ≤16/USB) needs the *Apple Devices* app from the Microsoft Store.
- **Caveats:** Tested on real Windows: mDNS discovery, pairing, installs, the in-process ELF anisette loader, the server/UI, plumesign invocation and the installer. Coexists with Bonjour on UDP 5353 (both use `SO_REUSEADDR`). Falls back to remote anisette (`ani.sidestore.io`) if the local libraries fail. Binaries are unsigned.
- **Build:** `./windows/build.sh` on Linux (Go, Node, mingw-w64, Rust windows-gnu target, cmake, nasm, NSIS). `plumesign.exe` is built unmodified from bitxeno/PlumeImpactor `v2.2.3-patch.8`.
- **License:** AGPL-3.0 (atvloadly + this fork's changes); plumesign is MIT. Apple's libraries are not redistributed.
