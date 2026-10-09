' Chay atvloadly an duoi nen (khong co cua so console)
Set fso = CreateObject("Scripting.FileSystemObject")
Set sh = CreateObject("WScript.Shell")
dir = fso.GetParentFolderName(WScript.ScriptFullName)
sh.CurrentDirectory = dir
If Not fso.FolderExists(dir & "\data") Then fso.CreateFolder(dir & "\data")
sh.Run """" & dir & "\atvloadly.exe"" server -c """ & dir & "\data\config.yaml""", 0, False
