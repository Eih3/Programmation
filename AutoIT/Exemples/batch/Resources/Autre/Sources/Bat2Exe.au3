#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

$Langue = IniRead(@ScriptDir&"\Reglages.ini","langue","langue","Français")

If UBound($CmdLine) = 1 Then
	$File = FileOpenDialog(IniRead(@ScriptDir&"\Langues\"&$Langue,"Bat2Exe","choisir","Choisissez le fichier à compiler :"),@UserProfileDir&"\BatchProg\",IniRead(@ScriptDir&"\Langues\"&$Langue,"Bat2Exe","ext","Fichiers batch (*.bat)"))
	If @error = 1 Then
		Exit
	EndIf
ElseIf UBound($CmdLine) > 1 Then
	$File = $CmdLine[1]
EndIf

$Code = InputBox("BatchProg",IniRead(@ScriptDir&"\Langues\"&$Langue,"Bat2Exe","code","Choisissez un code à votre fichier :"))

$File = StringReplace($File,"*"," ")
$Exe = StringReplace($File,".bat",".exe")

FileDelete(@ScriptDir&"\Temp.au3")
FileDelete($Exe)
FileWrite(@ScriptDir&"\Temp.au3",	;Partie supprimée pour empécher la décompilation non autorisée.
									; Partie supprimée pour empécher la décompilation non autorisée.
									; Partie supprimée pour empécher la décompilation non autorisée.
									;Partie supprimée pour empécher la décompilation non autorisée.
									;Partie supprimée pour empécher la décompilation non autorisée.
									;Partie supprimée pour empécher la décompilation non autorisée.
									;Partie supprimée pour empécher la décompilation non autorisée.
									"While 1"&@CRLF& _
									;Partie supprimée pour empécher la décompilation non autorisée.
									"WEnd"&@CRLF& _
									;Partie supprimée pour empécher la décompilation non autorisée.
If FileExists($File) Then
	Run(@ScriptDir&"\Aut2Exe\Aut2exe.exe /in "&@ScriptDir&"\Temp.au3 /icon "&@ScriptDir&"\img\exe.ico")
Else
	MsgBox(16,"BatchProg",IniRead(@ScriptDir&"\Langues\"&$Langue,"Bat2Exe","lefichier","Le fichier '")&$File&IniRead(@ScriptDir&"\Langues\"&$Langue,"Bat2Exe","nexistepas","' n'existe pas."))
	FileDelete(@ScriptDir&"\Temp.au3")
	Exit
EndIf

Sleep(1000)
While 1
	If FileExists(@ScriptDir&"\Temp.upx") = 0 Then
		ExitLoop
	EndIf
WEnd
Sleep(1000)

FileMove(@ScriptDir&"\Temp.exe",$Exe)
FileDelete(@ScriptDir&"\Temp.au3")

MsgBox(64,"Info",IniRead(@ScriptDir&"\Langues\"&$Langue,"Bat2Exe","termine","Compilation terminée."))