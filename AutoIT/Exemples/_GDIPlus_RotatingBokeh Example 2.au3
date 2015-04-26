;coded by UEZ build 2013-05-08, idea from http://tympanus.net/codrops/2012/11/14/creative-css-loading-animations/
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>

If @AutoItVersion < "3.3.8.0" Then Exit MsgBox(16 + 262144, "ERROR", "AutoIt version 3.3.8.0 or higher needed! Please update!", 180)

Global Const $hDwmApiDll = DllOpen("dwmapi.dll")
Global $sChkAero = DllStructCreate("int;")
DllCall($hDwmApiDll, "int", "DwmIsCompositionEnabled", "ptr", DllStructGetPtr($sChkAero))
Global $bAero = DllStructGetData($sChkAero, 1)
Global $fStep = 0.02
If Not $bAero Then $fStep = 1.25

_GDIPlus_Startup()
Global Const $STM_SETIMAGE = 0x0172, $IMAGE_BITMAP = 0
Global $iW = 300, $iH = 200
Global Const $hGUI = GUICreate("Rotating Bokeh", $iW, $iH)
Global Const $iBtn = GUICtrlCreateButton("Go", 250, 150, 40, 40, $BS_BITMAP)
Global Const $hBtn = GUICtrlGetHandle($iBtn)
GUICtrlCreateLabel("Animation Test GUI", 0, 0, 300, 40, $SS_CENTER)
GUICtrlSetFont(-1, 24, 400, 0, "Arial", 5)
Global Const $iEdit = GUICtrlCreateEdit("Waiting ...", 0, 45, 300, 100)
GUISetState()
Global $hHBmp_BG, $hB
Global $iPerc, $iFlipFlop = -1

Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			AdlibUnRegister("PlayAnim")
			_WinAPI_DeleteObject($hHBmp_BG)
			_GDIPlus_Shutdown()
			GUIDelete()
			Exit
		Case $iBtn
			Switch $iFlipFlop
				Case -1
					AdlibRegister("PlayAnim", 20)
					$iFlipFlop *= -1
					GUICtrlSetData($iEdit, "Transfer started! Please wait...")
				Case Else
					AdlibUnRegister("PlayAnim")
					$iFlipFlop *= -1
					$hB = _SendMessage($hBtn, $BM_SETIMAGE, $IMAGE_BITMAP, 0)
					If $hB Then _WinAPI_DeleteObject($hB)
					GUICtrlSetData($iEdit, "Transfer stopped. Please Go to start again")
			EndSwitch
	EndSwitch
Until False

Func PlayAnim()
	$hHBmp_BG = _GDIPlus_RotatingBokeh(32, 32)
	$hB = _SendMessage($hBtn, $BM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	$iPerc += 0.1
	If $iPerc > 99.9 Then $iPerc = 0
EndFunc   ;==>PlayAnim

Func _GDIPlus_RotatingBokeh($iW, $iH, $bHBitmap = True)
	Local Const $hPen = _GDIPlus_PenCreate(0xFF303030)
	DllCall($ghGDIPDll, "uint", "GdipSetPenLineJoin", "handle", $hPen, "int", 2)
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]

	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hCtxt, 2)
	If @OSBuild < 6000 Then
		Local $iBtnColor = _WinAPI_GetSysColor($COLOR_BTNFACE)
		_GDIPlus_GraphicsClear($hCtxt, 0xFF000000 + 0x10000 * BitAND($iBtnColor, 0xFF) + BitAND($iBtnColor, 0x00FF00) + BitShift($iBtnColor, 16))
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iBtnColor = ' & Hex($iBtnColor, 6) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf

	Local Const $fDeg = ACos(-1) / 180, $iRadius = 12, $iBallSize = $iRadius / 1.77, $iCircleSize = $iBallSize + 2 * $iRadius, $iBallSize2 = $iBallSize / 2, _
			$iCircleSize2 = $iCircleSize / 2, $fFontSize = 5, $iW2 = -1 + $iW / 2, $iH2 = -1 + $iH / 2
	Local Static $iAngle = 0
	Local Const $hBrushBall1 = _GDIPlus_BrushCreateSolid(0xE004AC6B)
	Local Const $hBrushBall2 = _GDIPlus_BrushCreateSolid(0xC0E0AB27)
	Local Const $hBrushBall3 = _GDIPlus_BrushCreateSolid(0xD081B702)
	Local Const $hBrushBall4 = _GDIPlus_BrushCreateSolid(0xB0E70339)
	DllCall($ghGDIPDll, "int", "GdipDrawEllipse", "handle", $hCtxt, "handle", $hPen, "float", $iW2 - $iCircleSize2, "float", $iH2 - $iCircleSize2, "float", $iCircleSize, "float", $iCircleSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall1, "float", -$iBallSize2 + $iW2 + Cos(2.25 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(2.25 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall2, "float", -$iBallSize2 + $iW2 + Cos(1.75 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(1.75 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall3, "float", -$iBallSize2 + $iW2 + Cos(1.66 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(1.66 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall4, "float", -$iBallSize2 + $iW2 + Cos(1.33 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(1.33 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	$iAngle += 2.5

	_GDIPlus_GraphicsDispose($hCtxt)
	_GDIPlus_BrushDispose($hBrushBall1)
	_GDIPlus_BrushDispose($hBrushBall2)
	_GDIPlus_BrushDispose($hBrushBall3)
	_GDIPlus_BrushDispose($hBrushBall4)
	_GDIPlus_PenDispose($hPen)
	If $bHBitmap Then
		Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBITMAP
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_RotatingBokeh