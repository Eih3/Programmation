#include-once
#include <IE.au3>

#region ##### EXAMPLE #####
;~ #include <GUIConstants.au3>
;~ #region - GUI Create
;~ GUICreate('HTML Edit Test', 640, 480)
;~ $Tmp = _GuiCtrlTexte_Create(5, 5, 630, 470)
;~ GUISetState()
;~ #endregion

;~ _GuiCtrlTexte_Write($Tmp, "<h2>Test de l'UDF: GuiCtrlTexte.au3</h2>")
;~ _GuiCtrlTexte_Add($Tmp, '<p>Voici le premier paragraphe de test pour cet UDF!<br/>Il à été créer à la base par <strong>timmalos</strong> du <A HREF="http://www.autoitscript.fr">forum ' & _
;~ 							'de la communauté francophone AutoIt</A>.')
;~ _GuiCtrlTexte_Add($Tmp, '<p>Il fut en suite amélioré par <strong>bubule</strong>, il lui a en effet ajouter plusieurs fonction fort utiles</p>')
;~ _GuiCtrlTexte_Add($Tmp, '<p>Et c''est la que j''entre en jeu! Trouvant que l''UDF méritait beaucoups plus d''attention, et une meilleur gestion des erreurs, ' & _
;~ 							'Je me mis à ajouter les définitions des fonction, à améliorer la lisibilité du code et la gestion des erreurs, et enfin ' & _
;~ 							'à tapoter ce petit exemple tout simple pour montrer un peut comment ça marche!')

;~ #region - GUI SelectLoop
;~ While 1
;~ 	$msg = GUIGetMsg()
;~ 	Select
;~ 		Case $msg = $GUI_EVENT_CLOSE
;~ 			Exit
;~ 	EndSelect
;~ WEnd
#endregion

#endregion

;===============================================================================
;
; Function Name:   	_GuiCtrlTexte_Create($x, $y, $width = -1, $height = -1, $bgcolor = "white", $sFontColor = "black", $sFont = "", $iFontSize = 0)
; Description::		Create a HTML based Edit Control
; Parameter(s):		$x = Position In the GUI
;					$y = Position In the GUI
;					$width = Width of the control
;					$height = Height of the control
;					$sCss = CSS Style used in the Control
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0, @Extended = The function that have failed, @Error = the error returned by that function
; Author(s): 		timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Create($x, $y, $width = -1, $height = -1, $sCss = "")
	If Int($x) <> $x Or Int($y) <> $y Or $x = "" Or $y = "" Or $x = 0 Or $y = 0  Then Return 0

	Local $hCtrlObj, $hCtrl, $baseHtml, $style
	Dim $hReturn[2]

	$hCtrlObj = _IECreateEmbedded()
	If @error Then Return SetError(@error, "_IECreateEmbedded", 0)

	$hCtrl = GUICtrlCreateObj($hCtrlObj, $x, $y, $width, $height)

	_IENavigate($hCtrlObj, "about:blank")
	If @error Then Return SetError(@error, "_IENavigate", 0)

	$baseHtml = '<html><head><style>' & $sCss & '</style></head><body></body></html>'

;~ 	ConsoleWrite($baseHtml & @CRLF)

	_IEDocWriteHTML($hCtrlObj, $baseHtml)
	If @error Then Return SetError(@error, "_IEDocWriteHTML", 0)

	$hReturn[0] = $hCtrlObj
	$hReturn[1] = $hCtrl

	Return $hReturn
EndFunc

;===============================================================================
;
; Function Name:   	_GuiCtrlTexte_Config($hCtrl, $bgcolor = "white", $sFontColor = "black", $sFont = "", $iFontSize = 0)
; Description::		Configure the background color, the font name and size
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
;					$sCss = CSS Style used in the Control
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0, @Extended = The function that have failed, @Error = the error returned by that function
; Author(s): timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Config($hCtrl, $sCss)

	Local $stxt = _GuiCtrlTexte_Read($hCtrl, 1), $baseHtml, $style
	If @error Then Return SetError(@error, "_IEBodyReadHTML", 0)

	$baseHtml = '<html><head><style>' & $sCss & '</style></head><body></body></html>'

	_IEDocWriteHTML($hCtrl[0], $baseHtml)
	If @error Then Return SetError(@error, "_IEDocWriteHTML", 0)

	If $stxt Then
		_IEBodyWriteHTML($hCtrl[0], $stxt)
		If @error Then Return SetError(@error, "_IEBodyWriteHTML", 0)
	EndIf

	Return 1
EndFunc

;===============================================================================
;
; Function Name:   	_GuiCtrlTexte_Write($hCtrl, $s_html)
; Description::		Write HTML code in the edit
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
;					$s_html = HTML code to write in the edit
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0, @Extended = The function that have failed, @Error = the error returned by that function
; Author(s): timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Write($hCtrl, $s_html)
	_IEBodyWriteHTML($hCtrl[0], $s_html)
	If @error Then Return SetError(@error, "_IEBodyWriteHTML", 0)

	Return 1
EndFunc

;===============================================================================
;
; Function Name:   	_GuiCtrlTexte_Add($hCtrl, $s_html)
; Description::		Adds HTML code to the edit
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
;					$s_html = HTML code to add in the edit
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0, @Extended = The function that have failed, @Error = the error returned by that function
; Author(s): timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Add($hCtrl, $s_html)
	Local $Texte = _GuiCtrlTexte_Read($hCtrl, 1)
	If @error Then Return SetError(@error, "_GuiCtrlTexte_Read -> " & @extended, 0)

	_IEBodyWriteHTML($hCtrl[0], $Texte & $s_html)
	If @error Then Return SetError(@error, "_IEBodyWriteHTML", 0)

	Return 1
EndFunc

;===============================================================================
;
; Function Name:   _GuiCtrlTexte_Read($hCtrl, $rpt = 0)
; Description::		Read either the HTML code, or the text only in the edit
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
;					$flag = False (Default) => Returns text
;							True => Returns entire HTML code
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0, @Extended = The function that have failed, @Error = the error returned by that function
; Author(s): timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Read($hCtrl, $bHTML = True, $bHeaders = False)
	Local $return
	Switch $bHTML
		Case False
			$return = _IEBodyReadText($hCtrl[0])
			If @error Then Return SetError(@error, "_IEBodyReadText", 0)
		Case True
			If $bHeaders Then
				$return = _IEDocReadHTML($hCtrl[0])
				If @error Then Return SetError(@error, "_IEBodyReadHTML", 0)
			Else
				$return = _IEBodyReadHTML($hCtrl[0])
				If @error Then Return SetError(@error, "_IEBodyReadHTML", 0)
			EndIf
	EndSwitch
	If $return = "0" Then $return = ""
	Return $return
EndFunc

;===============================================================================
;
; Function Name:   	_GuiCtrlTexte_Clear($hCtrl)
; Description::		Clear the edit
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0, @Extended = The function that have failed, @Error = the error returned by that function
; Author(s): timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Clear($hCtrl)
	_IEBodyWriteHTML($hCtrl[0], "")
	If @error Then Return SetError(@error, "_IEBodyWriteHTML", 0)
	Return 1
EndFunc

;===============================================================================
;
; Function Name:	_GuiCtrlTexte_Scroll($hCtrl)
; Description::		Scrolls the HTML Control
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
;					$iScroll = Scroll amount: 0 means UP, -1 means DOWN
; Requirement(s):
; Return Value(s):	1
; Author(s):		Matwachich (with the help of bloodwolf)
;
;===============================================================================
;
Func _GuiCtrlTexte_Scroll($hCtrl, $iScroll)
	If $iScroll = -1 Then $iScroll = Number($hCtrl[0].document.body.scrollHeight)
	$hCtrl[0].document.body.scrollTop = $iScroll
	Return 1
EndFunc

;===============================================================================
;
; Function Name:  	_GuiCtrlTexte_Delete()
; Description::		Destroy the edit
; Parameter(s):		$hCtrl = Handle returned by _GuiCtrlTexte_Create()
; Requirement(s):
; Return Value(s):	Succes => Handle to the control (An array containing the _IECreateEmbedded and GUICtrlCreateObj)
;					Failed => 0
; Author(s): timmalos -> Bubule -> Matwachich
;
;===============================================================================
;
Func _GuiCtrlTexte_Delete($hCtrl)
	_IEQuit($hCtrl[0])
	Return GUICtrlDelete($hCtrl[1])
EndFunc
