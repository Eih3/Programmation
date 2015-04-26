#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <String.au3>
#include <File.au3>

$Langue = IniRead(@ScriptDir&"\Reglages.ini","langue","langue","Fran�ais")

If UBound($CmdLine) = 1 Then
	$File = FileOpenDialog(IniRead(@ScriptDir&"\Langues\"&$Langue,"Exe2Bat","choisir","Choissisez le fichier � d�compiler :"),@UserProfileDir&"\BatchProg\",IniRead(@ScriptDir&"\Langues\"&$Langue,"Exe2Bat","ext","Fichiers executables (*.exe)"))
	If @error = 1 Then
		Exit
	EndIf
ElseIf UBound($CmdLine) > 1 Then
	$File = $CmdLine[1]
EndIf

$TempDir = FileGetLongName(@TempDir)
$File = StringReplace($File,"*"," ")
$BatFile = StringReplace($File,".exe",".bat")

ShellExecute($File)
$Timer1 = TimerInit()
While 1
	If TimerDiff($Timer1) > 5000 Then
		$Code = "0000####0000"
		ExitLoop
	EndIf
	;Partie supprim�e pour emp�cher la d�compilation non autoris�e.
		;Partie supprim�e pour emp�cher la d�compilation non autoris�e.
		;Partie supprim�e pour emp�cher la d�compilation non autoris�e.
		ProcessClose("cmd.exe")
		ExitLoop
	EndIf
WEnd
$Timer2 = TimerInit()
While 1
	If TimerDiff($Timer2) > 5000 Then ExitLoop
	If ProcessExists("cmd.exe") Then
		ProcessClose("cmd.exe")
		ExitLoop
	EndIf
WEnd

$CodeUser = InputBox("BatchProg",IniRead(@ScriptDir&"\Langues\"&$Langue,"Exe2Bat","code","Entrez le code du fichier :"))

If $CodeUser <> $Code Then
	MsgBox(16,"BatchProg",IniRead(@ScriptDir&"\Langues\"&$Langue,"Exe2Bat","erreur","Le code entr� est incorrecte !"))
	Exit
EndIf

If $CodeUser = $Code Then
	;Partie supprim�e pour emp�cher la d�compilation non autoris�e.
		_ReplaceStringInFile($BatFile,"TITLE "&$File,"")
		MsgBox(64,"BatchProg",IniRead(@ScriptDir&"\Langues\"&$Langue,"Exe2Bat","fin","Le fichier � �t� d�compil� et plac� dans le m�me dossier que l'executable."))
	Else
		MsgBox(16,"BatchProg",IniRead(@ScriptDir&"\Langues\"&$Langue,"Exe2Bat","erreur2","Une erreur c'est produite et le fichier n'as pas �t� d�compil� !"))
	EndIf
EndIf