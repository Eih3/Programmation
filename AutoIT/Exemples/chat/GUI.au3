#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>

#include "lib\GuiCtrlTexte.au3"

Global Enum $__GUI_Create, $__GUI_Delete, $__GUI_Show, $__GUI_Hide

Global  $__CSS = _
'body{font-family:tahoma;font-size:12px;padding:5px;margin:0px}' & @CRLF & _
'.sysmsg{margin:3px;margin-left:0px;margin-right:0px;paddin:0px;padding-top:2px;padding-bottom:2px;border-bottom:1px solid black;border-top:1px solid black}' & @CRLF & _
'.sysmsg_in{color:blue}' & @CRLF & _
'.sysmsg_out{color:red}' & @CRLF & _
'.msg{margin:0px;padding-left:10px}' & @CRLF & _
'.username{padding-left:3px;padding-top:1px;padding-bottom:1px;margin:0px;margin-top:5px;width:100%;background-color:silver;font-weight:bolder}' & @CRLF & _
'.myname{padding-left:3px;padding-top:1px;padding-bottom:1px;margin:0px;margin-top:5px;width:100%;background-color:black;color:white;font-weight:bolder}' & @CRLF

; ##############################################################
; GUI_Main
Global $GUI_Main, $HTML, $L_Canal, $List, $hList, $Input, $B_Menu, $B_Send
Global $Menu, $Menu_Clear, $Menu_Refresh, $Menu_Identification

Global $aUtil_MinMax[4]

Func _GUI_Main($flag = $__GUI_CREATE)
	Switch $flag
		Case $__GUI_CREATE
			$GUI_Main = GUICreate("SelfChat", 507, 281, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
			If @OSVersion = "WIN_7" Or @OSVersion = "WIN_VISTA" Then
				GUISetFont(10, 400, 0, "Calibri")
			Else
				GUISetFont(10, 400, 0, "Tahoma")
			EndIf
			; ---
			$HTML = _GuiCtrlTexte_Create(6, 6, 365, 239, $__CSS)
				GUICtrlSetResizing($HTML[1], $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
			$L_Canal = GUICtrlCreateLabel("", 378, 6, 125, 18)
				GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Canal actuel")
			$List = GUICtrlCreateListView("Utilisateurs", 378, 24, 121, 249, BitOr($GUI_SS_DEFAULT_LISTVIEW, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER), $LVS_EX_FULLROWSELECT + $WS_EX_CLIENTEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH)
				$hList = GuiCtrlGetHandle($List)
				GuiCtrlSetTip($List, "C'est la liste des utilisateurs connectés au même canal que vous." & @CRLF & _
									"Sélectionnez un/plusieurs utilisateur(s) pour leur(s) envoyer des messages privés")
			$Input = GUICtrlCreateInput("", 6, 252, 277, 23)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
			; ---
			$B_Menu = GUICtrlCreateButton("Menu", 333, 252, 39, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$Menu = GuiCtrlCreateContextMenu($B_Menu)
					$Menu_Clear = GuiCtrlCreateMenuItem("Vider la fenêtre de conversation", $Menu)
					$Menu_Refresh = GuiCtrlCreateMenuItem("Mise à jour de la liste des utilisateurs", $Menu)
					$Menu_Identification = GuiCtrlCreateMenuItem("Changer de pseudo et/ou de canal", $Menu)
			; ---
			$B_Send = GUICtrlCreateButton("Send", 290, 252, 39, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GuiCtrlSetTip(-1, "Envoyer un message (Entrée)")
			; ---
			Local $accels[1][2] = [["{enter}", $B_Send]]
			GuiSetAccelerators($accels, $GUI_Main)
			; ---
			_InitMinMax(507, 281, @DesktopWidth, @DesktopHeight)
		Case $__GUI_SHOW
			GuiSetState(@SW_SHOW, $GUI_Main)
			ControlFocus($GUI_Main, "", $Input)
		Case $__GUI_HIDE
			GuiSetState(@SW_HIDE, $GUI_Main)
		Case $__GUI_DELETE
			GuiDelete($GUI_Main)
			$GUI_Main = 0
	EndSwitch
EndFunc

Func _GUI_Write($sData)
	_GuiCtrlTexte_Add($HTML, $sData)
	_GuiCtrlTexte_Scroll($HTML, -1)
EndFunc

Func _GUI_List_GetSelected() ; Chr(30) separated
	Local $sel = _GuiCtrlListView_GetSelectedIndices($hList, 1)
	Local $str = ""
	; C'est aussi complex car il faut récupérer le Nom & UniqueID depuis le array des utilisateurs
	; (et pas seulement le Nom qui est inscrit dans la Liste)
	For $i = 1 To $sel[0]
		For $x = 1 To $__Users[0][0]
			If $sel[$i] = $__Users[$x][1] Then $str &= $__Users[$x][0] & Chr(30)
		Next
	Next
	If $str Then $str &= $__Name ; Un message nous est toujour destiné!
	Return $str
EndFunc

; ##############################################################
; Merci Tlem!!!

Func _InitMinMax($x0, $y0, $x1, $y1)
    $aUtil_MinMax[0] = $x0
    $aUtil_MinMax[1] = $y0
    $aUtil_MinMax[2] = $x1
    $aUtil_MinMax[3] = $y1
    GUIRegisterMsg(0x24, 'MY_WM_GETMINMAXINFO') ; $WM_GETMINMAXINFO
EndFunc

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
    Local $minmaxinfo = DllStructCreate('int;int;int;int;int;int;int;int;int;int',$lParam)
    DllStructSetData($minmaxinfo,7,$aUtil_MinMax[0]); min X
    DllStructSetData($minmaxinfo,8,$aUtil_MinMax[1]); min Y
    DllStructSetData($minmaxinfo,9,$aUtil_MinMax[2]); max X
    DllStructSetData($minmaxinfo,10,$aUtil_MinMax[3]); max Y
    Return $GUI_RUNDEFMSG
EndFunc

; ##############################################################
; GUI_Connect

Global $GUI_Connect, $I_Pseudo, $I_Canal, $B_Connect

Func _GUI_Connect($flag = $__GUI_CREATE, $sPseudo = "", $sCanal = "")
	Switch $flag
		Case $__GUI_CREATE
			$GUI_Connect = GUICreate("SelfChat - Connexion", 238, 201)
				GUISetFont(10, 400, 0, "Tahoma")
			; ---
			GUICtrlCreateLabel("SelfChat", 58, 12, 120, 46)
				GUICtrlSetFont(-1, 24, 800, 0, "Tempus Sans ITC")
			GUICtrlCreateLabel("Pseudonyme", 24, 60, 76, 20)
			GUICtrlCreateLabel("Canal de conversation", 24, 108, 130, 18)
			; ---
			$I_Pseudo = GUICtrlCreateInput($sPseudo, 45, 78, 151, 24)
				GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
				GuiCtrlSetTip(-1, "C'est le nom sous lequel vous apparaissez dans le chat")
			$I_Canal = GUICtrlCreateInput($sCanal, 45, 126, 151, 24)
				GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
				GuiCtrlSetTip(-1, "C'est la canal de discussion." & @CRLF & _
								"Vous ne pouvez discuter qu'avec des personnes connectées au même canal." & @CRLF & _
								"Laissez vide pour vous connecter au canal par défaut")
			; ---
			$B_Connect = GUICtrlCreateButton("Go!", 81, 162, 75, 25)
			; ---
			Local $accels[1][2] = [["{enter}", $B_Connect]]
			GuiSetAccelerators($accels, $GUI_Connect)
		Case $__GUI_SHOW
			GuiSetState(@SW_SHOW, $GUI_Connect)
		Case $__GUI_HIDE
			GuiSetState(@SW_HIDE, $GUI_Connect)
		Case $__GUI_DELETE
			GuiDelete($GUI_Connect)
			$GUI_Connect = 0
	EndSwitch
EndFunc
