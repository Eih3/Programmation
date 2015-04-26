#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiEdit.au3>

$Gui = GUICreate("Form 1",1000,500,0,0,BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX));Création de la GUI.

$Edit = GUICtrlCreateEdit("",30,0,970,500)
GUICtrlSetFont($Edit,-1,15)

$NumLine = ""
For $i = 1 To 70 Step 1
	$NumLine &= $i & @CRLF
Next
$Label = GUICtrlCreateLabel($NumLine,0,2,30,480)
GUICtrlSetFont($Label,-1,15)
$Old_Ind = 1

GUISetState(@SW_SHOW)
WinSetState($GUI,"",@SW_MAXIMIZE)

While 1
	$ind_1 = _GUICtrlEdit_GetFirstVisibleLine($Edit)+1
	If $ind_1 <> $Old_Ind Then
		$NumLine = ""
		For $i = $ind_1 To $ind_1+70 Step 1
			$NumLine &= $i & @CRLF
		Next
		GUICtrlSetData($Label,$NumLine)
		$Old_Ind = $ind_1
	EndIf
	$Msg = GUIGetMsg()
	Switch $Msg
	Case $GUI_EVENT_CLOSE
		Exit
	EndSwitch
WEnd