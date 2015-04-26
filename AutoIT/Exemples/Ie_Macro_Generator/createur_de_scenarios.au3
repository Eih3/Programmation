#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <ListBoxConstants.au3>
#include <IE.au3>
#include <string.au3>
#include <file.au3>
#Include <GuiListBox.au3>
#include <GuiConstantsEx.au3>

Opt("WinTitleMatchMode", -2)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase


Global $total_width = @DesktopWidth,$total_height = @DesktopHeight,$i = 1, $ii
Global $auto_texte[500],$auto_fait = 0,$oIE,$first_irl
Global $loc = @ScriptDir & "\scenario\scenario.ini"
$hMonitor = GetMonitorFromPoint(0, 0)
If $hMonitor <> 0 Then
	GetMonitorInfos($hMonitor)
EndIf



GuiCreate("Createur De Scénarios • Simulati On • Version 1.0",$total_width,$total_height,0,0)
GUISetBkColor(0xE0EEEE)
$texte = FileRead(@ScriptDir & "\procedure.txt")
GUICtrlCreateLabel($texte,50,50)
GUISetState()

MsgBox(48,"Créateur de Scénarios.","Bienvenue dans la création de scénarios compatibles avec Simulati On.")

$msg300 = _Msg("Souhaitez vous utiliser le Mode Automatique? (Utilisable Si la simulation ne comporte pas de Javascript. Vous pourrez Ensuite Modifier dans le mode Complexe)")
If $msg300 = 0 Then
		Redim $auto_texte[2]
		$auto_texte[1] = "##{Action 1}##"
Else
		_Automatique()
EndIf
$texte_ar = _Input2($auto_texte)
$msg2 = 0
$code_action = ""
For $i = 0 to UBound($texte_ar) -1
	If StringInStr($texte_ar[$i],"{Action "&$msg2+1&"}") Then
		$msg2 += 1
		If $msg2 >= 2 Then
			Assign("msg2_1"&($msg2-1),$code_action,2)
			$code_action = ""
		EndIf
	Else
		$code_action &= $texte_ar[$i] & " "
	EndIf
Next
Assign("msg2_1"&($msg2),$code_action,2)
Iniwrite($loc,"general","nombre",$msg2)

$file = Fileopen(@ScriptDir & "\modele.dat",0)
$texte = Fileread($file)
;MsgBox(0,"",$texte)

$actions = "#Region ACTIONS"&@CRLF
Global $verifs = ''
;MsgBox(0,@error,@extended)
For $i = 1 to $msg2
	$actions &= "Func _action"&$i&"()" & @CRLF & _
							"$t = TimerInit()" & @CRLF & _
							";-----------------" & @CRLF & _
							";actions" & @CRLF
	Assign("msg2_1"&$i, Eval("msg2_1"&$i) & " FIN")
	;MsgBox(0,"",Eval("msg2_1"&$i))
	$reg = StringRegExp(Eval("msg2_1"&$i),"(([A-Z]{0,1}[a-z]?)\[(.*?)\])+",3)

	For $ii = 1 to UBound($reg) - 1 step 3
		Switch $reg[$ii]
			Case ""
							$actions &= "Execute("&$reg[$ii+1]&")" & @CRLF
			Case "A"
							$actions &= "_IENavigate($oIE,Eval('adresse"&$i&"'))" & @CRLF & "_IELoadWait($oIE)" & @CRLF
							Iniwrite($loc,"verifications",$i&"_adresse",$reg[$ii+1])
			Case "In"
							$actions &= "_IEImgClick($oIE,'"&$reg[$ii+1]&"','name')" & @CRLF
			Case "Is"
							$actions &= "_IEImgClick($oIE,'"&$reg[$ii+1]&"','src')" & @CRLF
			Case "Ia"
							$actions &= "_IEImgClick($oIE,'"&$reg[$ii+1]&"','alt')" & @CRLF
			Case "Ii"
							$actions &= " _IEAction(_IEImgGetCollection($oIE,"&$reg[$ii+1]&"),'click')" & @CRLF & "_IELoadWait($oIE)" & @CRLF
			Case "Ln"
							$actions &= "_IELinkClickByText($oIE,'"&$reg[$ii+1]&"')" & @CRLF
			Case "Li"
							$actions &= "_IELinkClickByIndex($oIE,"&$reg[$ii+1]&")" & @CRLF & "_IELoadWait($oIE)" & @CRLF
			Case "Jn"
							$actions &= "For $oLink in _IELinkGetCollection($oIE)" & @CRLF & _
											"If StringInStr(_IEPropertyGet($oLink, 'innerText'), '"&$reg[$ii+1]&"') Then" & @CRLF & _
												"_IEAction($oLink, 'click')" & @CRLF & _
												"_IELoadWait($oIE)" & @CRLF & _
												"ExitLoop" & @CRLF & _
											"EndIf" & @CRLF & _
										"Next" & @CRLF
			Case "Ji"
							$actions &= " _IEAction(_IELinkGetCollection($oIE,"&$reg[$ii+1]&"),'click')" & @CRLF & "_IELoadWait($oIE)" & @CRLF

			Case "Sl"
							$actions &= "Sleep("&$reg[$ii+1]&")" & @CRLF
			Case 'Fn'
							$actions &= "$oForm = _IEFormGetObjByName($oIE,'"&$reg[$ii+1]&"')" & @CRLF
			Case 'Fi'
							$actions &= "$oForm = _IEFormGetCollection($oIE,"&$reg[$ii+1]&")" & @CRLF
			Case 'En'
							$actions &= "$object = _IEFormElementGetObjByName($oForm,'"&$reg[$ii+1]&"')" & @CRLF
			Case 'Ei'
							$actions &= "$object = _IEFormElementGetCollection($oForm,"&$reg[$ii+1]&")" & @CRLF
			Case 'Es'
							$actions &= "_IEFormElementSetValue($object,string('"&$reg[$ii+1]&"'))" & @CRLF
			Case 'Di'
							$actions &= "_IEFormElementCheckBoxSelect($oForm,"&$reg[$ii+1]&",'',"&$reg[$ii+4]&",'byIndex')" & @CRLF
			Case 'Dn'
							$actions &= "_IEFormElementCheckBoxSelect($oForm,'"&$reg[$ii+1]&"','',"&$reg[$ii+4]&",'byValue')" & @CRLF
			Case 'Ri'
							$actions &= "_IEFormElementRadioSelect($oForm,"&$reg[$ii+1]&",'',"&$reg[$ii+4]&",'byIndex')" & @CRLF
			Case 'Rn'
							$actions &= "_IEFormElementRadioSelect($oForm,'"&$reg[$ii+1]&"','',"&$reg[$ii+4]&",'byValue')" & @CRLF
			Case 'Et'
							$actions &= "_IEAction($object, 'focus')" & @CRLF & _
										"ControlSend(_IEPropertyGet($oIE, 'hwnd'), '', '[CLASS:Internet Explorer_Server; INSTANCE:1]', '"&$reg[$ii+1]&"')" & @CRLF
			Case 'Ci'
							$actions &= "_IEFormElementOptionSelect($oForm,"&$reg[$ii+1]&","&$reg[$ii+4]&",'byIndex')" & @CRLF
			Case 'Cn'
							$actions &= "_IEFormElementOptionSelect($oForm,'"&$reg[$ii+1]&"',"&$reg[$ii+4]&",'byText')" & @CRLF
			Case 'Cv'
							$actions &= "_IEFormElementOptionSelect($oForm,'"&$reg[$ii+1]&"',"&$reg[$ii+4]&",'byValue')" & @CRLF
			Case "Xx"
							$actions &= "_IEAction($oIe,String('"&$reg[$ii+1]&"'))" & @CRLF& "_IELoadWait($oIE)" & @CRLF
			Case 'Vb'
							$actions &= "_IEFormSubmit ($oForm,0)" & @CRLF& "_IELoadWait($oIE)" & @CRLF
			Case "Vn"
							$actions &= "_IEFormImageClick($oIE,'"&$reg[$ii+1]&"','name')" & @CRLF
			Case "Vs"
							$actions &= "_IEFormImageClick($oIE,'"&$reg[$ii+1]&"','src')" & @CRLF
			Case "Va"
							$actions &= "_IEFormImageClick($oIE,'"&$reg[$ii+1]&"','alt')" & @CRLF
			Case "Vj"
							$actions &= "_IEAction($oForm,'click')" & @CRLF& "_IELoadWait($oIE)" & @CRLF

		EndSwitch
	Next
	$actions &= ";-----------------" &  @CRLF & _
				"EndFunc"&  @CRLF&  @CRLF







Next


$texte = StringReplace($texte,"#Region ACTIONS",$actions,1)

SplashTextOn("","Ecriture du fichier en cours, veuillez patienter.",@DesktopWidth,100,-1,-1,1)
FileWrite (_PathFull(@ScriptDir & "\scenario\scenario.au3"),$texte)
ShellExecuteWait(_PathFull(@ScriptDir & "\Tidy\Tidy.exe"),'"'&_PathFull(@ScriptDir & "\scenario\scenario.au3")&'"',"","",@SW_HIDE)
SplashOff()
MsgBox(48,"Créateur de Scénarios.","Félicitations. Votre scénario a été créé.")
Exit
#endregion
Func _Automatique()
			HotKeySet("{escape}","quitter")
			Global $GLOBAL_FINI = 0
			_Msg("Internet Explorer va s'ouvrir. Quand vous aurez terminé, appuyez sur ECHAP pour Enregistrer",0)
			Dim $ii = 0, $links[2],$i_i = 1,$i_actions = 1,$objL,$objP

			Local $oResult = _IEAttach("", "Instance",1)
			If IsObj($oResult) Then
				WinActivate(HWnd($oResult.HWND))
				$oIE = $oResult
			Else
				$oIE = _IeCreate("about:blanc",0,1,0)
			EndIf
			_IELoadWait($oIE)
			$first = 1
			$iiii = 0
			While $GLOBAL_FINI = 0
				$oLinks = _IELinkGetCollection ($oIE)


				iF @error = 0 Then
					If @extended <> 0 then 	ReDim $links[@extended]
					$ii = 0
					For $oLink In $oLinks
						$links[$ii] = $oLink.href
						$ii += 1
					Next
				EndIf
				$oForm = _IEFormGetCollection($oIE,0)
				$oElements = _IEFormElementGetCollection($oForm)
				iF @error = 0 Then
					$i = 0
					If __IEIsObjType($oElements, "forminputelement") Then
						$o = $oElements
						If String($o.type) = "text"  Then
							$objL = $o
							$objLi = $i
						EndIf
						If String($o.type) = "password"  Then
							$objP = $o
							$objPi = $i
						EndIf
					Else
						For $o In $oElements
							If String($o.type) = "text" Then
								$objL = $o
								$objLi = $i
								ExitLoop
							EndIf
							If String($o.type) = "password" Then
								$objP = $o
								$objPi = $i
								ExitLoop
							EndIf
							$i += 1
						Next
					EndIf
					$A_login = ""
					$A_password = ""
				Else
					$A_login = ""
					$A_password = ""
				EndIf
				If $GLOBAL_FINI = 1 then ExitLoop

				;Maintenant, on wait l'action de l'utilisateur

				While Not _IEPropertyGet($oIE,"busy")
					If $GLOBAL_FINI = 1 then ExitLoop
				WEnd
				If $GLOBAL_FINI = 1 then ExitLoop
				If IsObj($objL) then $A_login = _IEFormElementGetValue($objL)
				If IsObj($objP) then $A_password = _IEFormElementGetValue($objP)

				_IELoadWait($oIE)
				While _IEPropertyGet($oIE,"busy")
					If $GLOBAL_FINI = 1 then ExitLoop
				WEnd
				If $GLOBAL_FINI = 1 then ExitLoop

				;Maintenant, on analyse les actions, et on recommence la boucle

				$url = _IEPropertyGet($oIE,"locationurl")
				If $first = 1 Then
					$first_irl = $url
					$first = 0
				EndIf
				$auto_fait = 0

				If $GLOBAL_FINI = 1 then ExitLoop
				If $A_login <> "" Then
					$auto_texte[$i_i] = "##{Action "&$i_actions&"}##"
					$auto_texte[$i_i+1] = "Fi[0] "
					$auto_texte[$i_i+2] = "Ei["&$objLi&"] Es["&$A_login&"] "
					If $A_password <> "" then
						$auto_texte[$i_i+3] = "Ei["&$objPi&"] Es["&$A_password&"] "
						$auto_texte[$i_i+4] = "Vj[] "
						$i_i += 5
					Else
						$auto_texte[$i_i+3] = "Vj[] "
						$i_i += 4
					EndIf
					$i_actions += 1
					$auto_fait = 1
				EndIf

				For $ii = 0 to UBound($links) - 1
					If $url = $links[$ii] Then
						$auto_texte[$i_i] = "##{Action "&$i_actions&"}##"
						$auto_texte[$i_i+1] = "Ii["&$ii&"] "
						$i_i += 2
						$i_actions += 1
						$auto_fait = 1
					EndIf
				Next

				If Not $auto_fait Then
					$auto_texte[$i_i] = "##{Action "&$i_actions&"}##"
					$auto_texte[$i_i+1] = "A["&$url&"] "
					$auto_fait = 1
					$i_i += 2
					$i_actions += 1
				EndIf
			ToolTip($iiii,10,10)
			$iiii += 1
			WEnd
		_IEQuit($oIE)
		HotKeySet("{escape}")
		Return 1
EndFunc

Func quitter()
	$GLOBAL_FINI = 1
EndFunc


Func _Input($func,$default = "")
	$rep = InputBox("Créateur de Simulations. Etape n°" & $i,$func,$default)
	If $rep = "" and $func <> 14 Then
		;MsgBox(48,"Créateur de Simulations. Etape n°" & $i,"Erreur. Vous n'avez rien rentré. Fin de l'assistant")
		Return $rep
	Else
		Return $rep
	EndIf
	$i += 1
EndFunc

Func _Input2($W_array)
	$W_gui_delete = GUICreate("Scénario", 300, 480,-1,-1,-1)
	GUISwitch($W_gui_delete)
	GUICtrlCreateLabel("Liste des actions", 70, 14, 200, 25)
	GUICtrlSetFont(-1, 15, -1, -1, "Verdana")
	;$W_list = GUICtrlCreateList("", 10, 60, 280, 300)
	Global $hListBox = _GUICtrlListBox_Create($W_gui_delete,"",10, 60, 250, 300,$WS_VSCROLL, $LBS_NOTIFY)

	Global 	$W_haut = GUICtrlCreateButton("H", 265, 70, 30, 30,$BS_ICON)
	 GUICtrlSetImage(-1, @ScriptDir & "\Raise.ico")
	Global 	$W_bas = GUICtrlCreateButton("B", 265, 102, 30, 30,$BS_ICON)
	 GUICtrlSetImage(-1, @ScriptDir & "\Fall.ico")

	Global 	$W_folder = GUICtrlCreateButton("B", 265, 150, 30, 30,$BS_ICON)
	 GUICtrlSetImage(-1, @ScriptDir & "\Folder.ico")

	Global $W_add = GUICtrlCreateButton("+", 265, 200, 30, 30,$BS_ICON)
	 GUICtrlSetImage(-1, @ScriptDir & "\Add.ico")
	Global 	$W_mod = GUICtrlCreateButton("M", 265, 232, 30, 30,$BS_ICON)
	 GUICtrlSetImage(-1, @ScriptDir & "\Modify.ico")
	Global 	$W_del = GUICtrlCreateButton("-", 265, 264, 30, 30,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\Trash.ico")
	Global 	$W_copy = GUICtrlCreateButton("-", 265, 296, 30, 30,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\Copy.ico")

	Global $W_input = GuiCtrlCreateInput("",40,365,150,20)
	GUICtrlSetState($W_input,$GUI_HIDE)
	Global $W_valider = GUICtrlCreateButton("V",195,360,30,30,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\Apply.ico")
	Global $W_stop = GUICtrlCreateButton("V",228,360,30,30,$BS_ICON)
	GUICtrlSetImage(-1, @ScriptDir & "\Delete.ico")

	GUICtrlSetState($W_valider,$GUI_HIDE)
	Global $W_continue = GUICtrlCreateButton("Valider le Scénario",20,360,260,40)
	Global 	$W_group = GUICtrlCreateGroup("",5,400,290,73)
	Global 	$W_info = GUICtrlCreateLabel( "Action :" & @CRLF & "Position :" & @CRLF & "Description :", 10, 410, 280, 60)
	GUICtrlSetState($W_info, $GUI_DISABLE)
	GUISetState(@SW_SHOW,$W_gui_delete)
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
    _GUICtrlListBox_BeginUpdate($hListBox)
    _GUICtrlListBox_ResetContent($hListBox)
    _GUICtrlListBox_InitStorage($hListBox, 100, 4096)
	For $W_i = 1 to UBound($W_array)-1
		_GUICtrlListBox_AddString($hListBox,$W_array[$W_i])
	Next
    _GUICtrlListBox_EndUpdate($hListBox)

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE

				If _Msg("Etes Vous vraiment certain de vouloir quitter l'assistant de création de scénarios?") = 1 Then
					Guidelete($W_gui_delete)
					Exit
				EndIf
			Case $W_continue
				Dim $return[_GUICtrlListBox_GetCount($hListBox)]
				For $i = 0 to _GUICtrlListBox_GetCount($hListBox) -1
					$return[$i] = _GUICtrlListBox_GetText($hListBox,$i)
				Next
				Guidelete($W_gui_delete)
				Return $return
			Case $W_add
				_GuiAff(1)
				Global $W_hAction = "ajouter"
				$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)

			Case $W_mod
				If _GUICtrlListBox_GetCurSel($hListBox) = -1 Then
					MsgBox(32,"Scénario","Erreur : Vous n'avez séléctionné aucune action.")
				Else
					_GuiAff(1)
					Global $W_hAction = "modifier"
					$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
					GUICtrlSetData($W_input,_GUICtrlListBox_GetText($hListBox,$W_old_sel))
				EndIf
			Case $W_folder
				_GuiAff(0)
				$i = -1
				$ii = 1
				$lasti = 3
				While 1
					$i = _GUICtrlListBox_FindInText($hListBox, "Action "&$ii)
					If $i <> -1 then
						$ii += 1
					Else
						$lasti = $i
						ExitLoop
					EndIf

				WEnd
				_GUICtrlListBox_InsertString($hListBox,"##{Action "&$ii&"}##",$lasti)
			Case $W_copy
				_GuiAff(0)
				If _GUICtrlListBox_GetCurSel($hListBox) = -1 Then
					MsgBox(32,"Scénario","Erreur : Vous n'avez séléctionné aucune action.")
				Else
					$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
					_GUICtrlListBox_AddString($hListBox,_GUICtrlListBox_GetText($hListBox,$W_old_sel))
					_GUICtrlListBox_SetCurSel($hListBox, _GUICtrlListBox_GetCount($hListBox) -1)
					$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
					GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,$W_old_sel) & @CRLF & "Position :"&$W_old_sel + 1 & @CRLF & "Description :")

				EndIf
			Case $W_valider
				Switch $W_hAction
					Case "ajouter"
						If GuiCtrlRead($W_input) = "" Then
							MsgBox(32,"Scénario","Erreur : Vous devez rentrez un code action.")
						Else
							_GUICtrlListBox_InsertString($hListBox,GuiCtrlRead($W_input),$W_old_sel)
							_GUICtrlListBox_SetCurSel($hListBox, $W_old_sel)
							GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,$W_old_sel) & @CRLF & "Position :"&$W_old_sel + 1 & @CRLF & "Description :")
						EndIf
					Case "modifier"
						If GuiCtrlRead($W_input) = "" Then
							MsgBox(32,"Scénario","Erreur : Vous devez rentrez un code action.")
						Else
							_GUICtrlListBox_ReplaceString($hListBox,$W_old_sel,GuiCtrlRead($W_input))
							_GUICtrlListBox_SetCurSel($hListBox, $W_old_sel)
							GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,$W_old_sel) & @CRLF & "Position :"&$W_old_sel + 1 & @CRLF & "Description :")
						EndIf


				EndSwitch
			Case $W_stop
				_GuiAff(0)
				_GUICtrlListBox_SetCurSel($hListBox, $W_old_sel)
			Case $W_del
				_GuiAff(0)
				If _GUICtrlListBox_GetCurSel($hListBox) = -1 Then
					MsgBox(32,"Scénario","Erreur : Vous n'avez séléctionné aucune action.")
				Else
					$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
					_GUICtrlListBox_DeleteString($hListBox,$W_old_sel)
					_GUICtrlListBox_SetCurSel($hListBox, $W_old_sel)
					GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,$W_old_sel) & @CRLF & "Position :"&$W_old_sel + 1 & @CRLF & "Description :")
				EndIf
			Case $W_haut
				_GuiAff(0)
				If _GUICtrlListBox_GetCurSel($hListBox) = -1 Then
					MsgBox(32,"Scénario","Erreur : Vous n'avez séléctionné aucune action.")
				Else
					$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
					If $W_old_sel > 0 then
						_GUICtrlListBox_SwapString($hListBox,$W_old_sel, $W_old_sel - 1)
						_GUICtrlListBox_SetCurSel($hListBox, $W_old_sel -1)
						$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
						GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,$W_old_sel) & @CRLF & "Position :"&$W_old_sel + 1 & @CRLF & "Description :")
					EndIf
				EndIf
			Case $W_bas
				_GuiAff(0)
				If _GUICtrlListBox_GetCurSel($hListBox) = -1 Then
					MsgBox(32,"Scénario","Erreur : Vous n'avez séléctionné aucune action.")
				Else
					$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
					If $W_old_sel < _GUICtrlListBox_GetCount($hListBox) -1 then
						_GUICtrlListBox_SwapString($hListBox,$W_old_sel, $W_old_sel + 1)
						_GUICtrlListBox_SetCurSel($hListBox, $W_old_sel +1)
						$W_old_sel =  _GUICtrlListBox_GetCurSel($hListBox)
						GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,$W_old_sel) & @CRLF & "Position :"&$W_old_sel + 1 & @CRLF & "Description :")
					EndIf
				EndIf
		EndSwitch
		Sleep(10)
	WEnd
EndFunc

Func __string_between($func,$start,$end)
	$t1 = _StringBetween($func,$start,$end)
	Return $t1[0]
EndFunc
Func _Msg($func,$func2 = 36)
	$rep = MsgBox($func2,"Créateur de Simulations. Etape n°" & $i,$func)
	If $rep = 6 Then
		Return 1
	ElseIf $rep = 1 Then
		Return 1
	ElseIf $rep = 7 Then
		Return 0
	EndIf
EndFunc

Func GetMonitorFromPoint($x, $y)
	Global Const $MONITOR_DEFAULTTONULL     = 0x00000000
	Global Const $MONITOR_DEFAULTTOPRIMARY  = 0x00000001
	Global Const $MONITOR_DEFAULTTONEAREST  = 0x00000002

	Global Const $CCHDEVICENAME             = 32
	Global Const $MONITORINFOF_PRIMARY      = 0x00000001

    $hMonitor = DllCall("user32.dll", "hwnd", "MonitorFromPoint", _
                                            "int", $x, _
                                            "int", $y, _
                                            "int", $MONITOR_DEFAULTTONULL)
    Return $hMonitor[0]
EndFunc


Func GetMonitorInfos($hMonitor)
    Local $stMONITORINFOEX = DllStructCreate("dword;int[4];int[4];dword;char[" & $CCHDEVICENAME & "]")
    DllStructSetData($stMONITORINFOEX, 1, DllStructGetSize($stMONITORINFOEX))

    $nResult = DllCall("user32.dll", "int", "GetMonitorInfo", _
                                            "hwnd", $hMonitor, _
                                            "ptr", DllStructGetPtr($stMONITORINFOEX))
    If $nResult[0] = 1 Then
		$total_width =Number(DllStructGetData($stMONITORINFOEX, 3, 3))
		$total_height = Number(DllStructGetData($stMONITORINFOEX, 3, 4))
    EndIf

    Return $nResult[0]
EndFunc
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg
    Local $hWndFrom, $iIDFrom, $iCode, $hWndListBox
    If Not IsHWnd($hListBox) Then $hWndListBox = GUICtrlGetHandle($hListBox)
    $hWndFrom = $ilParam
    $iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
    $iCode = BitShift($iwParam, 16) ; Hi Word

    Switch $hWndFrom
        Case $hListBox, $hWndListBox
			_GuiAff(0)
			Switch $iCode
                Case $LBN_DBLCLK ; Sent when the user double-clicks a string in a list box
                    _DebugPrint("$LBN_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
                            "-->IDFrom:" & @TAB & $iIDFrom & @LF & _
                            "-->Code:" & @TAB & $iCode)
                    ; no return value
					ControlClick("Scénario","",$W_mod)
                Case $LBN_SELCHANGE ; Sent when the selection in a list box has changed
                    GUICtrlSetData($W_info,"Action :"&_GUICtrlListBox_GetText($hListBox,_GUICtrlListBox_GetCurSel($hListBox)) & @CRLF & "Position :"&_GUICtrlListBox_GetCurSel($hListBox) + 1 & @CRLF & "Description :")
					_DebugPrint("$LBN_SELCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
                            "-->IDFrom:" & @TAB & $iIDFrom & @LF & _
                            "-->Code:" & @TAB & $iCode)
                    ; no return value

            EndSwitch
    EndSwitch
    ; Proceed the default Autoit3 internal message commands.
    ; You also can complete let the line out.
    ; !!! But only 'Return' (without any value) will not proceed
    ; the default Autoit3-message in the future !!!
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
Func _GuiAff($func)
		If $func = 1 And BitAnd(GUICtrlGetState($W_continue),$GUI_SHOW) Then
			GUICtrlSetState($W_input,$GUI_SHOW)
			GUICtrlSetState($W_valider,$GUI_SHOW)
			GUICtrlSetState($W_continue,$GUI_HIDE)
			GUICtrlSetState($W_stop,$GUI_SHOW)
		ElseIf $func = 0 And BitAnd(GUICtrlGetState($W_continue),$GUI_HIDE) Then
			GUICtrlSetState($W_input,$GUI_HIDE)
			GUICtrlSetState($W_valider,$GUI_HIDE)
			GUICtrlSetState($W_continue,$GUI_SHOW)
			GUICtrlSetState($W_stop,$GUI_HIDE)
		EndIf
	EndFunc
Func _DebugPrint($s_text)
    $s_text = StringReplace($s_text, @LF, @LF & "-->")
    ConsoleWrite("!===========================================================" & @LF & _
            "+===========================================================" & @LF & _
            "-->" & $s_text & @LF & _
            "+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint


