#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\projet autoit en cour\Mes icones\memo.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiDateTimePicker.au3>
#include <File.au3>
#include <Misc.au3>
#include <Toast.au3>
#include <Array.au3>

Dim $memo[101]
Dim $heure[101]
Dim $min[101]
Dim $rappel[101]
Dim $date[101]

Global $active = False
Global $nombredememo, $heure, $min, $memo, $memo_fait, $rappel_fait, $memoactuel = 1, $normal = True
Global $dossier = @AppDataDir & "\Memo"
Global $fichier = $dossier & "\Info.ini"

FileInstall("gauche.jpg", $dossier & "\gauche.jpg", 1)
FileInstall("droite.jpg", $dossier & "\droite.jpg", 1)
FileInstall("ajouter.jpg", $dossier & "\ajouter.jpg", 1)
FileInstall("valider.jpg", $dossier & "\valider.jpg", 1)
FileInstall("supprimer.jpg", $dossier & "\supprimer.jpg", 1)




$nombredememo = IniRead($fichier, "Memo", "Nombre de memo", "1")
For $i = 1 To $nombredememo
	$memo[$i] = IniRead($fichier, "Memo" & $i, "Memo", "")
	$heure[$i] = IniRead($fichier, "Memo" & $i, "Heure", "")
	$min[$i] = IniRead($fichier, "Memo" & $i, "Minute", "")
	$rappel[$i] = IniRead($fichier, "Memo" & $i, "Rappel", "")
	$date[$i] = IniRead($fichier, "Memo" & $i, "Date", "")
Next


Opt("TrayMenuMode", 1)

Global $Form1 = GUICreate("Memo", 585, 245, 215, 170)
Global $Group_information = GUICtrlCreateGroup("Informations", 160, 32, 265, 145)

Global $Input_memo = GUICtrlCreateInput($memo[1], 232, 56, 169, 21)
Global $Input_heure = GUICtrlCreateInput($heure[1], 232, 88, 25, 21)
Global $Input_min = GUICtrlCreateInput($min[1], 280, 88, 25, 21)
Global $Input_rappel = GUICtrlCreateInput($rappel[1], 278, 143, 17, 21)

Global $Label_memo = GUICtrlCreateLabel("Memo :", 176, 56, 48, 20)
Global $Label_heure = GUICtrlCreateLabel("Heure :", 176, 88, 47, 20)
Global $Label_h = GUICtrlCreateLabel("h", 264, 93, 13, 24)
Global $Label_date = GUICtrlCreateLabel("Date :", 184, 120, 39, 20)
Global $Label_rappel1 = GUICtrlCreateLabel("Rappel ", 230, 146, 44, 20)
Global $Label_rappel2 = GUICtrlCreateLabel("minute(s) avant", 304, 145, 94, 20)

Global $GuiDate = _GUICtrlDTP_Create($Form1, 232, 120, 177, 17)

Global $Checkbox = GUICtrlCreateCheckbox("", 205, 144, 16, 21)

_GUICtrlDTP_SetFormat($GuiDate, "d MMMM yyyy")

GUICtrlSetFont($Label_memo, 10, 400, 0, "MS Sans Serif")
GUICtrlSetFont($Label_heure, 10, 400, 0, "MS Sans Serif")
GUICtrlSetFont($Label_rappel1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetFont($Label_rappel2, 10, 400, 0, "MS Sans Serif")
GUICtrlSetFont($Label_date, 10, 400, 0, "MS Sans Serif")


GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Label_info = GUICtrlCreateLabel($memoactuel & "/" & $nombredememo, 536, 208, 26, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

If @Compiled Then
	Global $Pic1 = GUICtrlCreatePic($dossier & "\gauche.jpg", 8, 56, 137, 109)
	Global $Pic2 = GUICtrlCreatePic($dossier & "\droite.jpg", 432, 56, 137, 109)
	Global $Pic3 = GUICtrlCreatePic($dossier & "\ajouter.jpg", 160, 184, 65, 57)
	Global $Pic4 = GUICtrlCreatePic($dossier & "\valider.jpg", 256, 184, 73, 57)
	Global $Pic5 = GUICtrlCreatePic($dossier & "\supprimer.jpg", 360, 184, 65, 57)
Else
	Global $Pic1 = GUICtrlCreatePic(@ScriptDir & "\gauche.jpg", 8, 56, 137, 109)
	Global $Pic2 = GUICtrlCreatePic(@ScriptDir & "\droite.jpg", 432, 56, 137, 109)
	Global $Pic3 = GUICtrlCreatePic(@ScriptDir & "\ajouter.jpg", 160, 184, 65, 57)
	Global $Pic4 = GUICtrlCreatePic(@ScriptDir & "\valider.jpg", 256, 184, 73, 57)
	Global $Pic5 = GUICtrlCreatePic(@ScriptDir & "\supprimer.jpg", 360, 184, 65, 57)
EndIf

GUISetState(@SW_SHOW)
TraySetIcon("", -1)
TraySetClick("1")
TrayCreateItem("")
$Trayitem1 = TrayCreateItem("Restorer")
TrayCreateItem("")
$Trayitem2 = TrayCreateItem("Quitter")



While 1
	$oldrapel = _IsChecked($Checkbox)
	$oldmemo = $memo[$memoactuel]
	If _IsPressed("0D") And WinActive($Form1) Then
		actualiser_les_variables()
		$active = True
		GUISetState(@SW_HIDE, $Form1)
	EndIf
	$pos = GUIGetCursorInfo()
	If Not @error Then
		If _IsPressed("01") And $pos[4] = $Pic1 Then
			If @Compiled Then
				GUICtrlSetImage($Pic1, $dossier & "\gauche hover.jpg")
			Else
				GUICtrlSetImage($Pic1, @ScriptDir & "\gauche hover.jpg")
			EndIf
			$normal = False
		ElseIf _IsPressed("01") And $pos[4] = $Pic2 Then
			If @Compiled Then
				GUICtrlSetImage($Pic1, $dossier & "\droite hover.jpg")
			Else
				GUICtrlSetImage($Pic1, @ScriptDir & "\droite hover.jpg")
			EndIf
			$normal = False
		ElseIf _IsPressed("01") And $pos[4] = $Pic3 Then
			If @Compiled Then
				GUICtrlSetImage($Pic1, $dossier & "\ajouter hover.jpg")
			Else
				GUICtrlSetImage($Pic1, @ScriptDir & "\ajouter hover.jpg")
			EndIf

			$normal = False
		ElseIf _IsPressed("01") And $pos[4] = $Pic4 Then
			If @Compiled Then
				GUICtrlSetImage($Pic1, $dossier & "\valider hover.jpg")
			Else
				GUICtrlSetImage($Pic1, @ScriptDir & "\valider hover.jpg")
			EndIf

			$normal = False
		ElseIf _IsPressed("01") And $pos[4] = $Pic5 Then
			If @Compiled Then
				GUICtrlSetImage($Pic1, $dossier & "\supprimer hover.jpg")
			Else
				GUICtrlSetImage($Pic1, @ScriptDir & "\supprimer hover.jpg")
			EndIf
			$normal = False
		Else
			If $normal = False Then
				If @Compiled Then
					GUICtrlDelete($Pic1)
					Global $Pic1 = GUICtrlCreatePic($dossier & "\gauche.JPG", 8, 56, 137, 109)
					GUICtrlDelete($Pic2)
					Global $Pic2 = GUICtrlCreatePic($dossier & "\droite.JPG", 432, 56, 137, 109)
					GUICtrlDelete($Pic3)
					Global $Pic3 = GUICtrlCreatePic($dossier & "\ajouter.JPG", 160, 184, 65, 57)
					GUICtrlDelete($Pic4)
					Global $Pic4 = GUICtrlCreatePic($dossier & "\valider.JPG", 256, 184, 73, 57)
					GUICtrlDelete($Pic5)
					Global $Pic5 = GUICtrlCreatePic($dossier & "\supprimer.JPG", 360, 184, 65, 57)
				Else
					GUICtrlDelete($Pic1)
					Global $Pic1 = GUICtrlCreatePic(@ScriptDir & "\gauche.JPG", 8, 56, 137, 109)
					GUICtrlDelete($Pic2)
					Global $Pic2 = GUICtrlCreatePic(@ScriptDir & "\droite.JPG", 432, 56, 137, 109)
					GUICtrlDelete($Pic3)
					Global $Pic3 = GUICtrlCreatePic(@ScriptDir & "\ajouter.JPG", 160, 184, 65, 57)
					GUICtrlDelete($Pic4)
					Global $Pic4 = GUICtrlCreatePic(@ScriptDir & "\valider.JPG", 256, 184, 73, 57)
					GUICtrlDelete($Pic5)
					Global $Pic5 = GUICtrlCreatePic(@ScriptDir & "\supprimer.JPG", 360, 184, 65, 57)
				EndIf

				$normal = True
			EndIf
		EndIf
	EndIf


	If $active = True Then
		For $i = 1 To $nombredememo
			$rappel_en_cour = $heure[$i] & $min[$i] - $rappel[$i]

			If $min[$i] - $rappel[$i] = @MIN And $heure[$i] = @HOUR And StringLeft($date[$i], StringInStr($date[$i], "|", 0, 3) - 1) = date() And $rappel_en_cour <> $rappel_fait And _IsChecked($Checkbox) Then
				If $memo[$i] <> "" Then
					_Toast_Show(64, "Memo", "Dans " & $rappel[$memoactuel] & " minute(s) : " & $memo[$i], 1)
				Else
					_Toast_Show(64, "Memo", "Dans " & $rappel[$memoactuel] & " minute(s) : Rappel sans informations", 1)
				EndIf
				$rappel_fait = $heure[$i] & $min[$i] - $rappel[$i]
				_Toast_Hide()
			EndIf
			$memo_en_cour = $memo[$i] & $heure[$i] & $min[$i]
			If $min[$i] = @MIN And $heure[$i] = @HOUR And StringLeft($date[$i], StringInStr($date[$i], "|", 0, 3) - 1) = date() And $memo_en_cour <> $memo_fait Then
				If $memo[$i] <> "" Then
					MsgBox(64, "Memo", "Rappel : " & $memo[$i])
				Else
					MsgBox(64, "Memo", "Rappel : Sans information")
				EndIf
				$memo_fait = $memo[$i] & $heure[$i] & $min[$i]
			EndIf
		Next
	EndIf

	$msg = TrayGetMsg()
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg = $GUI_EVENT_CLOSE
			actualiser_les_variables()
			enregistrement_des_variables()
			Exit
		Case $nMsg = $Pic1
			If $memoactuel > 1 Then
				actualiser_les_variables()
				$memoactuel = $memoactuel - 1
				actualiser_les_controls()
			EndIf
		Case $nMsg = $Pic2
			If $memoactuel < $nombredememo Then
				actualiser_les_variables()
				$memoactuel = $memoactuel + 1
				actualiser_les_controls()
			EndIf
		Case $nMsg = $Pic3
			If $nombredememo < 100 Then
				$nombredememo = $nombredememo + 1
				GUICtrlSetData($Label_info, $memoactuel & "/" & $nombredememo)
			Else
				MsgBox(64, "Information", "Vous oublier beaucoup de chose vous :p")
			EndIf
		Case $nMsg = $Pic4
			actualiser_les_variables()
			$active = True
			GUISetState(@SW_HIDE, $Form1)
		Case $nMsg = $Pic5
			If $memoactuel = $nombredememo Then
				If $nombredememo > 1 Then
					$date[$memoactuel] = ""
					$rappel[$memoactuel] = ""
					$memo[$memoactuel] = ""
					$heure[$memoactuel] = ""
					$min[$memoactuel] = ""
					$memoactuel = $memoactuel - 1
					$nombredememo = $nombredememo - 1
					actualiser_les_controls()
				EndIf

			Else
				For $i = $memoactuel To $nombredememo
					$rappel[$i] = $rappel[$i + 1]
					$min[$i] = $min[$i + 1]
					$heure[$i] = $heure[$i + 1]
					$memo[$i] = $memo[$i + 1]
				Next
				$nombredememo = $nombredememo - 1
				actualiser_les_controls()
			EndIf
		Case $msg = $Trayitem1
			GUISetState(@SW_SHOW, $Form1)
			$active = False
		Case $msg = $Trayitem2
			actualiser_les_variables()
			enregistrement_des_variables()
			Exit
	EndSelect

	If $oldrapel = 0 And _IsChecked($Checkbox) = 1 Then
		GUICtrlSetState($Checkbox, $GUI_CHECKED)
		Sleep(500)
		If GUICtrlRead($Input_memo) = "" Then
			_Toast_Show(64, "Memo", "Rappel dans " & GUICtrlRead($Input_rappel) & " minute(s) : Votre memo", 1)
			_Toast_Hide()
		Else
			_Toast_Show(64, "Memo", "Rappel dans " & GUICtrlRead($Input_rappel) & " minute(s) : " & GUICtrlRead($Input_memo), 1)
			_Toast_Hide()
		EndIf
	EndIf
WEnd

Func date()
	Return @YEAR & "|" & @MON & "|" & @MDAY
EndFunc   ;==>date

Func actualiser_les_controls()
	$datemodif = StringSplit($date[$memoactuel], "|")
	If $datemodif[0] = 6 Then
		$datemodif[0] = False
		_GUICtrlDTP_SetSystemTime($GuiDate, $datemodif)
	EndIf
	GUICtrlSetData($Input_heure, $heure[$memoactuel])
	GUICtrlSetData($Input_min, $min[$memoactuel])
	GUICtrlSetData($Input_rappel, $rappel[$memoactuel])
	GUICtrlSetData($Label_info, $memoactuel & "/" & $nombredememo)
	GUICtrlSetData($Input_memo, $memo[$memoactuel])
EndFunc   ;==>actualiser_les_controls

Func actualiser_les_variables()
	$dateold = _GUICtrlDTP_GetSystemTime($GuiDate)
	If $dateold[2] < 10 Then $dateold[2] = "0" & $dateold[2]
	If $dateold[1] < 10 Then $dateold[1] = "0" & $dateold[1]
	$date[$memoactuel] = $dateold[0] & "|" & $dateold[1] & "|" & $dateold[2] & "|" & $dateold[3] & "|" & $dateold[4] & "|" & $dateold[5]
	$rappel[$memoactuel] = GUICtrlRead($Input_rappel)
	$memo[$memoactuel] = GUICtrlRead($Input_memo)
	$heure[$memoactuel] = GUICtrlRead($Input_heure)
	$min[$memoactuel] = GUICtrlRead($Input_min)
EndFunc   ;==>actualiser_les_variables

Func enregistrement_des_variables()
	If Not FileExists($dossier) Then DirCreate($dossier)
	If Not FileExists($fichier) Then _FileCreate($fichier)
	IniWrite($fichier, "Memo", "Nombre de memo", $nombredememo)
	For $i = 1 To $nombredememo
		IniWrite($fichier, "Memo" & $i, "Memo", $memo[$i])
		IniWrite($fichier, "Memo" & $i, "Heure", $heure[$i])
		IniWrite($fichier, "Memo" & $i, "Minute", $min[$i])
		IniWrite($fichier, "Memo" & $i, "Rappel", $rappel[$i])
		IniWrite($fichier, "Memo" & $i, "Date", $date[$i])
	Next
EndFunc   ;==>enregistrement_des_variables

Func _IsChecked($control)
	Return BitAND(GUICtrlRead($control), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
