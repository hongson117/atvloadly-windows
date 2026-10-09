# Tai thu vien anisette (libstoreservicescore.so, libCoreADI.so) tu APK Apple Music
# chinh thuc cua Apple (giong Dockerfile cua atvloadly), giai nen vao
# %APPDATA%\PlumeImpactor\lib\x86_64 - noi plumesign.exe doc.
# Neu khong co, plumesign se tu dung may chu anisette tu xa (ani.sidestore.io).
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$dest = Join-Path $env:APPDATA 'PlumeImpactor\lib\x86_64'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$apk = Join-Path $env:TEMP 'atvloadly-applemusic.apk'
try {
  Write-Host "Dang tai Apple Music APK tu apps.mzstatic.com ..."
  Invoke-WebRequest -UseBasicParsing -Uri 'https://apps.mzstatic.com/content/android-apple-music-apk/applemusic.apk' -OutFile $apk
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = [System.IO.Compression.ZipFile]::OpenRead($apk)
  try {
    foreach ($name in 'libstoreservicescore.so','libCoreADI.so') {
      $entry = $zip.Entries | Where-Object { $_.FullName -eq "lib/x86_64/$name" }
      if (-not $entry) { throw "Khong tim thay lib/x86_64/$name trong APK" }
      [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, (Join-Path $dest $name), $true)
    }
  } finally { $zip.Dispose() }
  Write-Host "OK: da cai thu vien anisette vao $dest"
} catch {
  Write-Warning "Khong tai duoc thu vien anisette: $_"
  Write-Warning "atvloadly van chay; plumesign se dung anisette tu xa. Co the thu lai trong Settings > Update CoreADI."
} finally {
  Remove-Item -Force -ErrorAction SilentlyContinue $apk
}
