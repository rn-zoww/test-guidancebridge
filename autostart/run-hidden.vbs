' Starts the GuidanceBridge server with no console window. Output goes to server.log in the project folder.
Set fso = CreateObject("Scripting.FileSystemObject")
Set sh = CreateObject("WScript.Shell")
projectDir = fso.GetParentFolderName(fso.GetParentFolderName(WScript.ScriptFullName))
sh.CurrentDirectory = projectDir
sh.Run "cmd /c node server.js >> server.log 2>&1", 0, False
