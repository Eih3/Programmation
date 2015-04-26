#include-once
; #FUNCTION# ====================================================================================================================
; Name...........:	_ProgressGui
; Description ...:	A small splash screen type GUI with a progress bar and a configurable label
; Syntax.........:	_ProgressGUI($s_MsgText = "Text Message", $s_MarqueeType = 0, $i_Fontsize = 14, $s_Font = "Arial", $i_XSize = 290, $i_YSize = 100, $b_GUIColor = -1, $b_FontColor = -1)
; Parameters ....: 	$s_MsgText 	 - Text to display on the GUI
;					$s_MarqueeType - [optional] Style of Progress Bar you want to use
;						0 = Marquee style [default]
;						1 = Normal Progress Bar style
;					$i_Fontsize - [optional] The font size that you want to display the $s_MsgText at [default = 14]
;					$s_Font - [optional] The font you want the message to use [default = "Arial"]
;					$i_XSize - [optional] Width of the GUI [Default = 290] - Minimum size is 80
;					$i_YSize - [optional] Height of the GUI [Default = 100] - Minimum size is 100
;					$b_GUIColor  - [optional] Background color of the GUI [default = 0x00080FF = Blue]
;					$s_FontColor - [optional] Color of the text message [default = 0x0FFFC19 = Yellow]
; Return values .:	Success - An array containing the following information
;						$Array[0] - ControlID of the GUI created
;						$Array[1] - ControlID  of the ProgressBar control
;						$Array[2] - ControlID of the label
;					Failure - 0 and @error to 1 if the GUI couldn't be created
;
; Author ........: 	Bob Marotte (BrewManNH)
; Remarks .......: 	This will create a customizable GUI with a progress bar. The default style of the progress bar using this function is the
;					Marquee style of progress bar. If you call this function with any positive, non-zero number in the $s_MarqueeType
;					parameter it will use the normal progress bar style. All optional parameters will accept the "Default" keyword, an empty
;					string "", or -1 if passed to the function.  Use the return value to delete the GUI when you're done using it
;					(ex. GUIDelete($Returnvalue[0]))
; Related .......: 	None
; Link ..........:
; Example .......: 	No
; ===============================================================================================================================
Func _ProgressGUI($s_MsgText = "Text Message", $s_MarqueeType = 0, $i_Fontsize = 14, $s_Font = "Arial", $i_XSize = 290, $i_YSize = 100, $b_GUIColor = -1, $b_FontColor = -1)
	Local $PBMarquee[3]
;~ 	UDF Constants so no includes are needed
	Local Const $PG_WS_POPUP = 0x80000000 ; same as the $WS_POPUP constant in WindowsConstants.au3
	Local Const $PG_WS_DLGFRAME = 0x00400000 ; same as the $WS_DLGFRAME constant in WindowsConstants.au3
	Local Const $PG_PBS_MARQSMTH = 9 ; BitOr of $PBS_SMOOTH and $PBS_MARQUEE
	Local Const $PG_PBS_SMTH = 1 ; same as the $PBS_SMOOTH constant in ProgressConstants.au3
	Local Const $PG_PBM_SETMARQUEE = 1034 ; same as the $PBM_SETMARQUEE constant in ProgressConstants.au3
	; bounds checking/correcting
	If $i_Fontsize = "" Or $i_Fontsize = Default Or $i_Fontsize = "-1" Then $i_Fontsize = 14 ; use the default setting of 14 for font size
	If $i_Fontsize < 1 Then $i_Fontsize = 1 ; minimum font size is 1
	If $i_XSize = "" Or $i_XSize = "-1" Or $i_XSize = Default Then $i_XSize = 290 ; use the default setting for X dimension of the GUI
	If $i_XSize < 80 Then $i_XSize = 80 ; minimum X dimension is 80
	If $i_XSize > @DesktopWidth - 50 Then $i_XSize = @DesktopWidth - 50 ; maximum X dimension is Desktop Width - 50
	If $i_YSize = "" Or $i_YSize = "-1" Or $i_YSize = Default Then $i_YSize = 100 ; use the default setting for Y dimension of the GUI
	If $i_YSize > @DesktopHeight - 50 Then $i_YSize = @DesktopHeight - 50 ; maximum y dimension is Desktop Height - 50
	If $i_YSize < 100 Then $i_YSize = 100 ; minimum Y dimension is 100
	If $s_Font = "" Or $s_Font = "-1" Or $s_Font = "Default" Then $s_Font = "Arial" ; use the default font type
	;create the GUI
	$PBMarquee[0] = GUICreate("", $i_XSize, $i_YSize, -1, -1, BitOR($PG_WS_DLGFRAME, $PG_WS_POPUP))
	If @error Then Return SetError(@error, 0, 0) ; if there's any error with creating the GUI, return the error code
	Switch $b_GUIColor ; background color of the GUI
		Case "-1", Default; Used to set the default color
			GUISetBkColor(0x00080FF, $PBMarquee[0])
		Case ""
			; don't set a default color, use the theme's coloring
		Case Else ; set the BG color of the GUI to the user provided color
			GUISetBkColor($b_GUIColor, $PBMarquee[0])
	EndSwitch
	;	Create the progressbar
	If $s_MarqueeType < 1 Then ; if $s_MarqueeType < 1 then use the Marquee style progress bar
		$PBMarquee[1] = GUICtrlCreateProgress(20, $i_YSize - 20, $i_XSize - 40, 15, $PG_PBS_MARQSMTH) ; uses the $PBS_SMOOTH and $PBS_MARQUEE style
		GUICtrlSendMsg($PBMarquee[1], $PG_PBM_SETMARQUEE, True, 20) ; change last parameter to change update speed of marquee style PB
	Else ; If $s_MarqueeType > 0 then use the normal style progress bar
		$PBMarquee[1] = GUICtrlCreateProgress(20, $i_YSize - 20, $i_XSize - 40, 15, $PG_PBS_SMTH) ; Use the $PBS_SMOOTH style
	EndIf
	;	Create the label
	$PBMarquee[2] = GUICtrlCreateLabel($s_MsgText, 20, 20, $i_XSize - 40, $i_YSize - 45) ; create the label for the GUI
	GUICtrlSetFont($PBMarquee[2], $i_Fontsize, 400, Default, $s_Font)
	Switch $b_FontColor
		Case "-1", Default; Used to set the default color of the label
			GUICtrlSetColor($PBMarquee[2], 0x0FFFC19)
		Case ""
			; don't set a default color, use the theme's coloring
		Case Else
			GUICtrlSetColor($PBMarquee[2], $b_FontColor)
	EndSwitch
	GUISetState()
	Return SetError(0, 0, $PBMarquee) ;Return an array containing the ControlIDs of the GUI, Progress bar, and the Label (in that order)
EndFunc   ;==>_ProgressGUI
