; Computer Network Control - 1.0.0 - Made by Koumla - http://autoit.koumla.com
#include-once
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Global $domaine
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
func creation_list_comp()

$file = FileOpen(@TempDir & "\list_comp.vbs", 2)

FileWrite($file, 'Set objShell = WScript.CreateObject("WScript.Shell")' & @CRLF)

FileWrite($file, 'Set objFSO = CreateObject("Scripting.FileSystemObject")' & @CRLF)

FileWrite($file, "Dim objDomain" & @CRLF)

FileWrite($file, "Dim objComputer" & @CRLF)

FileWrite($file, 'Set objDomain = GetObject("WinNT://' & $domaine & '")' & @CRLF)

FileWrite($file, 'objDomain.Filter = Array("computer")' & @CRLF)

FileWrite($file, 'If objFSO.FileExists("' & @TempDir  & '\list_comp.txt") = True Then' & @CRLF)

FileWrite($file, 'objFSO.DeleteFile("' & @TempDir  & '\list_comp.txt")' & @CRLF)

FileWrite($file, "End If" & @CRLF)

FileWrite($file, 'Set txtOutput = objFSO.CreateTextFile ("' & @TempDir  & '\list_comp.txt")' & @CRLF)

FileWrite($file, "On Error Resume Next" & @CRLF)

FileWrite($file, "For Each objComputer In objDomain" & @CRLF)

FileWrite($file, "strComputer = objComputer.Name" & @CRLF)

FileWrite($file, "txtOutput.Writeline strComputer" & @CRLF)

FileWrite($file, "Next" & @CRLF)

FileWrite($file, "WScript.Sleep 2000" & @CRLF)

FileClose($file)

$cnx = "cscript.exe " & @TempDir  & "\list_comp.vbs"

RunWait(@ComSpec & ' /c ' & $cnx,"",@SW_HIDE)

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------