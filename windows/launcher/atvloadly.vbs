' atvloadly launcher: chay atvloadly.exe an duoi nen (neu chua chay) roi mo trinh duyet.
' Tham so /nobrowser: chi khoi dong, khong mo trinh duyet (dung cho tu khoi dong).
' Doi cong web: sua PORT ben duoi (can quyen Admin vi file nam trong Program Files).
Const PORT = "5533"
Dim sh, fso, appDir, dataDir, cfg, f, noBrowser, a, wmi, procs, running, q
Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
q = Chr(34)
appDir = fso.GetParentFolderName(WScript.ScriptFullName)
dataDir = sh.Environment("PROCESS")("LOCALAPPDATA") & "\atvloadly"
cfg = dataDir & "\config.yaml"

On Error Resume Next
fso.CreateFolder dataDir
Err.Clear
' Fallback (cmd mkdir) in case FileSystemObject cannot create the folder.
sh.Run "cmd.exe /c if not exist " & q & dataDir & q & " mkdir " & q & dataDir & q, 0, True
Err.Clear
If Not fso.FileExists(cfg) Then
  Set f = fso.CreateTextFile(cfg, True)
  If Err.Number = 0 Then
    f.WriteLine "server:"
    f.WriteLine "  listen_addr: 0.0.0.0"
    f.WriteLine "  work_dir: '" & dataDir & "'"
    f.WriteLine "log:"
    f.WriteLine "  log_file: '" & dataDir & "\app.log'"
    f.Close
  End If
  Err.Clear
End If

noBrowser = False
For Each a In WScript.Arguments
  If LCase(a) = "/nobrowser" Then noBrowser = True
Next

running = False
Set wmi = GetObject("winmgmts:\\.\root\cimv2")
If Err.Number = 0 Then
  Set procs = wmi.ExecQuery("SELECT ProcessId FROM Win32_Process WHERE Name='atvloadly.exe'")
  If Err.Number = 0 Then running = (procs.Count > 0)
End If
Err.Clear
On Error GoTo 0

If Not running Then
  sh.CurrentDirectory = dataDir
  sh.Run q & appDir & "\atvloadly.exe" & q & " server -p " & PORT & " -c " & q & cfg & q, 0, False
  If Not noBrowser Then WScript.Sleep 4000
End If
If Not noBrowser Then sh.Run "http://localhost:" & PORT
