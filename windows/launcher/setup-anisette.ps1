# Tai thu vien anisette cua Apple (libstoreservicescore.so, libCoreADI.so) tu APK
# Apple Music chinh thuc, giai nen vao %APPDATA%\PlumeImpactor\lib\x86_64.
# Exit code: 0 = OK / da co, 1 = loi (plumesign se dung anisette tu xa).
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'atvloadly - Tai thu vien anisette'
$dest = Join-Path $env:APPDATA 'PlumeImpactor\lib\x86_64'
$names = 'libstoreservicescore.so','libCoreADI.so'
if (($names | ForEach-Object { Test-Path (Join-Path $dest $_) }) -notcontains $false) {
  Write-Host "Thu vien anisette da co san: $dest"; exit 0
}
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$url = 'https://apps.mzstatic.com/content/android-apple-music-apk/applemusic.apk'
$apk = Join-Path $env:TEMP ('atvloadly-applemusic-' + [guid]::NewGuid().ToString('N') + '.apk')
try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Write-Host "Dang tai: $url"
  $req = [Net.HttpWebRequest]::Create($url)
  $req.Timeout = 60000; $req.ReadWriteTimeout = 120000
  $resp = $req.GetResponse()
  $total = $resp.ContentLength
  $in = $resp.GetResponseStream()
  $out = [IO.File]::Create($apk)
  try {
    $buf = New-Object byte[] 1048576; $done = 0; $last = -1
    while (($n = $in.Read($buf, 0, $buf.Length)) -gt 0) {
      $out.Write($buf, 0, $n); $done += $n
      if ($total -gt 0) {
        $pct = [int](100 * $done / $total)
        if ($pct -ne $last) {
          Write-Progress -Activity 'Tai Apple Music APK (thu vien anisette)' -Status ("{0:N1} / {1:N1} MB" -f ($done/1MB), ($total/1MB)) -PercentComplete $pct
          $last = $pct
        }
      }
    }
  } finally { $out.Close(); $in.Close(); $resp.Close() }
  Write-Progress -Activity 'Tai Apple Music APK' -Completed
  Write-Host 'Dang giai nen...'
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = [IO.Compression.ZipFile]::OpenRead($apk)
  try {
    foreach ($name in $names) {
      $entry = $zip.Entries | Where-Object { $_.FullName -eq "lib/x86_64/$name" }
      if (-not $entry) { throw "Khong tim thay lib/x86_64/$name trong APK" }
      [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, (Join-Path $dest $name), $true)
    }
  } finally { $zip.Dispose() }
  Write-Host "OK: da cai thu vien anisette vao $dest"
  exit 0
} catch {
  Write-Warning "Khong tai duoc thu vien anisette: $_"
  Start-Sleep -Seconds 5
  exit 1
} finally {
  Remove-Item -Force -ErrorAction SilentlyContinue $apk
}
