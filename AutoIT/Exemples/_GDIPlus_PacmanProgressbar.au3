#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>

_GDIPlus_Startup()
$hGUI = GUICreate("Pac-Man Progressbar Beta by UEZ 2013", 640, 200)
GUISetBkColor(0x101040)
$iPB = GUICtrlCreatePic("", 160, 83, 420, 35, $SS_SUNKEN)
$iBtnStart = GUICtrlCreateButton("Start", 40, 80, 40, 40)
$iLabelPerc = GUICtrlCreateLabel("0.00%", 95, 90, 50, 40)
GUICtrlSetFont(-1, 10)
GUICtrlSetColor(-1, 0xF0F0F0)
_GDIPlus_PacmanProgressbar(0, $iPB)
GUISetState()

Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			GUIDelete()
			_GDIPlus_Shutdown()
			Exit
		Case $iBtnStart
			$iMax = 133
			For $i = 0 To $iMax
				$fProg = $i / $iMax * 100
				_GDIPlus_PacmanProgressbar($fProg, $iPB)
				GUICtrlSetData($iLabelPerc, StringFormat("%.2f%", $fProg))
				Sleep(30)
			Next
			MsgBox(0, "Test", "Done", 30, $hGUI)
			_GDIPlus_PacmanProgressbar(0, $iPB)
			GUICtrlSetData($iLabelPerc, StringFormat("%.2f%", 0))
	EndSwitch
Until False

; #FUNCTION# ====================================================================================================================
; Name ..........: _GDIPlus_PacmanProgressbar
; Description ...: An alternativ progressbar
; Syntax ........: _GDIPlus_PacmanProgressbar($iProgress, $iCtrl[, $iScalar = 15[, $iPacManSize = 0[, $iDotSize = 0[,
;                  $iPacManColor = 0xFFFFFF00[, $iDotColor = 0xFFFFFFFF[, $iFinishColor = 0xFF00FF00[, $iBGColor = 0xFF404040[,
;                  $iPacManSpeed = 125]]]]]]]])
; Parameters ....: $iProgress           - An integer value between 0 and 100.
;                  $iCtrl               - An integer value (control id).
;                  $iPacManColor        - [optional] An integer value. Default is 0xFFFFFF00.
;                  $iScalar             - [optional] An integer value. Default is 15.
;                  $iPacManSize         - [optional] An integer value. Default is 0 = automatically calculated.
;                  $iDotSize            - [optional] An integer value. Default is 0 = automatically calculated.
;                  $iDotColor           - [optional] An integer value. Default is 0xFFFFFFFF.
;                  $iFinishColor        - [optional] An integer value. Default is 0xFF00FF00.
;                  $iBGColor            - [optional] An integer value. Default is 0xFF404040.
;                  $iPacManSpeed        - [optional] An integer value. Default is 125 (the higher the value the slower the pac-man).
; Return values .: None
; Author ........: UEZ
; Version .......: 0.90 build 2013-07-28 beta
; Modified ......:
; Remarks .......: need GDIPlus.au3
; Related .......: GDI+, GUI
; ===============================================================================================================================
Func _GDIPlus_PacmanProgressbar($iProgress, $iCtrl, $iPacManColor = 0xFFFFFF00, $iScalar = 15, $iPacManSize = 0, $iDotSize = 0, $iDotColor = 0xFFFFFFFF, $iFinishColor = 0xFF00FF00, $iBGColor = 0xFF404040, $iPacManSpeed = 125) ; coded by UEZ build 2013-07-28 beta
	Local $hGUI, $hCtrl, $aResult, $hBitmap, $hGfxCtxt, $aCtrlSize, $hB, $hGDIBmp, $hBrush, $i, $f, $fSpace, $iX, $fDX, $iC = 0, $iProgressMax = 100
	Local Static $iFrame = 0, $iTimer = TimerInit()
	$hCtrl = GUICtrlGetHandle($iCtrl)
	$hGUI = _WinAPI_GetAncestor($hCtrl)
	If @error Then Return SetError(1, 0, -1)
	$aCtrlSize = ControlGetPos($hGUI, "", $iCtrl)
	If @error Then Return SetError(2, 0, -2)
	;$GWL_STYLE = 0xFFFFFFF0, $GWL_EXSTYLE = 0xFFFFFFEC
	If BitAND(_WinAPI_GetWindowLong($hCtrl, 0xFFFFFFF0), 0x1000) = 0x1000 Or _  ;$SS_SUNKEN
			BitAND(_WinAPI_GetWindowLong($hCtrl, 0xFFFFFFEC), 0x00020000) = 0x00020000 Then $iC += 2 ;$WS_EX_STATICEDGE
	If BitAND(_WinAPI_GetWindowLong($hCtrl, 0xFFFFFFEC), 0x00000200) = 0x00000200 Then $iC += 4 ;$WS_EX_CLIENTEDGE
	If BitAND(_WinAPI_GetWindowLong($hCtrl, 0xFFFFFFF0), 0x00800000) = 0x00800000 Then $iC += 2 ;$WS_BORDER
	$aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $aCtrlSize[2] - $iC, "int", $aCtrlSize[3] - $iC, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $aResult[6]
	$hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsClear($hGfxCtxt, $iBGColor)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, 2)
	$hBrush = _GDIPlus_BrushCreateSolid($iDotColor)
	If Not $iDotSize Then $iDotSize = ($aCtrlSize[3] - $iC) / 4
	If Not $iPacManSize Then $iPacManSize = $iDotSize * 2
	$fSpace = $aCtrlSize[2] / $iScalar
	$fDX = -3 + (($aCtrlSize[2] - $iC) - ($fSpace * $iScalar - $fSpace + $iDotSize)) / 2
	If $iProgress < $iProgressMax Then
		For $i = Int($iProgress / 100 * $iScalar) To $iScalar - 2
			$iX = $fDX + $fSpace * $i
			DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hGfxCtxt, "handle", $hBrush, "float", $iX, "float", (($aCtrlSize[3] - $iC) - $iDotSize) / 2, "float", $iDotSize, "float", $iDotSize)
		Next
		_GDIPlus_BrushSetSolidColor($hBrush, $iFinishColor)
		$iX = $fDX + $fSpace * $i - $iDotSize / 2
		DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hGfxCtxt, "handle", $hBrush, "float", $iX, "float", (($aCtrlSize[3] - $iC) - $iDotSize) / 2.5, "float", $iDotSize * 1.5, "float", $iDotSize * 1.5)

		_GDIPlus_BrushSetSolidColor($hBrush, $iPacManColor)
		$iX = -$fSpace + $fDX + ($iProgress / $iScalar / 100) * $iScalar * ($aCtrlSize[2] - $iC)
		Switch Mod($iFrame, 2)
			Case 0
				DllCall($ghGDIPDll, "int", "GdipFillPie", "handle", $hGfxCtxt, "handle", $hBrush, "float", $iX, "float", (($aCtrlSize[3] - $iC) - $iPacManSize) / 2, "float", $iPacManSize, "float", $iPacManSize, "float", 45, "float", 270)
			Case Else
				DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hGfxCtxt, "handle", $hBrush, "float", $iX, "float", (($aCtrlSize[3] - $iC) - $iPacManSize) / 2, "float", $iPacManSize, "float", $iPacManSize)
		EndSwitch
		_GDIPlus_BrushSetSolidColor($hBrush, 0xFF000000)
		$f = $iDotSize / 4

		DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hGfxCtxt, "handle", $hBrush, "float", $iX + $iDotSize, "float", $iDotSize / 5 + (($aCtrlSize[3] - $iC) - $iDotSize * 2) / 2, "float", $f, "float", $f)
		If TimerDiff($iTimer) > $iPacManSpeed Then
			$iFrame += 1
			$iTimer = TimerInit()
		EndIf
	EndIf
	$hGDIBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	$hB = GUICtrlSendMsg($iCtrl, 0x0172, 0, $hGDIBmp) ;$STM_SETIMAGE = 0x0172, $IMAGE_BITMAP = 0
	If $hB Then _WinAPI_DeleteObject($hB)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	_GDIPlus_BitmapDispose($hBitmap)
	_WinAPI_DeleteObject($hGDIBmp)
EndFunc   ;==>_GDIPlus_PacmanProgressbar