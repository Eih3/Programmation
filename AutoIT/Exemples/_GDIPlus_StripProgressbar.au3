;coded by UEZ build 2013-08-15
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>

_GDIPlus_Startup()
Global Const $STM_SETIMAGE = 0x0172, $IMAGE_BITMAP = 0
Global $iW = 400, $iH = 25, $iBGColor = 0xFFFFFF
Global Const $hGUI = GUICreate("Strip Progressbar", $iW, $iH, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
GUISetBkColor($iBGColor)
Global Const $iPic = GUICtrlCreatePic("", 0, 0, $iW, $iH)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState()
Global $hHBmp_BG, $hB, $iSleep = 30, $hTooltip
GUIRegisterMsg($WM_TIMER, "PlayAnim")
DllCall("user32.dll", "int", "SetTimer", "hwnd", $hGUI, "int", 0, "int", $iSleep, "int", 0)
Global $fPerc = 0, $aPos, $iPosX, $iPosY
Global $aColors[5][2] = [[0xFFEE5F5B, 0xFFF07673],[0xFFABCC04, 0xFFBBD636],[0xFF78CCEE, 0xFF93D6F1],[0xFFFFBB58, 0xFFFFC97A],[0xFFFF6677, 0xFFFF8795]]
Global $iRandom = Random(0, UBound($aColors) - 1, 1)
$aPos = WinGetPos($hGUI)
$iPosX = $aPos[0]
$iPosY = $aPos[1] + $aPos[3]
Global $iColorTP = BitShift(BitAND(BitAND(0x00FFFFFF, $aColors[$iRandom][1]), 0xFF), -16) + BitAND(0x0000FF00, $aColors[$iRandom][1]) + BitShift(BitAND(BitAND(0x00FFFFFF, $aColors[$iRandom][1]), 0xFF0000), 16) ;convert to BGR

	
Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ToolTip("")
			GUIRegisterMsg($WM_TIMER, "")
			_WinAPI_DeleteObject($hHBmp_BG)
			_GDIPlus_Shutdown()
			GUIDelete()
			Exit
	EndSwitch
Until False

Func PlayAnim()
	$hHBmp_BG = _GDIPlus_StripProgressbar($fPerc, $iW, $iH, 0xFF000000 + $iBGColor, $aColors[$iRandom][0], $aColors[$iRandom][1])
	$hB = GUICtrlSendMsg($iPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	$fPerc += 0.25
	If $fPerc > 100 Then $fPerc = 0
	ToolTip(StringFormat("%02d %", $fPerc), $iPosX + $fPerc / 100 * $iW - 1, $iPosY, "", "", 3)
	$hTooltip = WinGetHandle(StringFormat("%02d %", $fPerc))
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", $hTooltip, "wstr", "", "wstr", "")
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $hTooltip, "int", 1043, "int", $iColorTP, "int", 0)
EndFunc   ;==>PlayAnim

Func _GDIPlus_StripProgressbar($fPerc, $iW, $iH, $iBgColorGui = 0xFFF0F0F0, $iFgColor = 0xFFEE5F5B, $iBGColor = 0xFFF07673, $sText = "Loading...", $iTextColor = 0x000000, $iDir = -1, $iSpeed = 1, $sFont = "Arial", $bFlip = False, $bHBitmap = True)
	If $fPerc < 0 Then $fPerc = 0
	If $fPerc > 100 Then $fPerc = 100
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]
	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsClear($hCtxt, $iBgColorGui)
	
	Local $iWidth = $iH * 2, $iLen = $iWidth / 2, $iY
	Local $hBmp = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBmp = $hBmp[6]
	Local Const $hCtxt_Bmp = _GDIPlus_ImageGetGraphicsContext($hBmp)
	Local $hPen = _GDIPlus_PenCreate($iFgColor), $iPenSize = Int($iH / 12)
	Local $hPen2 = _GDIPlus_PenCreate(0x40000000, $iPenSize)
	
	_GDIPlus_GraphicsClear($hCtxt_Bmp, $iBGColor)
	Local Static $iX = 0
	For $iY = 0 To $iH - 1
		Switch $iDir
			Case 1
				_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, $iX + $iY, $iY, $iX + $iY + $iLen, $iY, $hPen)
				_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, $iX + $iY - 2 * $iLen, $iY, $iX + $iY - 1 * $iLen, $iY, $hPen)
			Case Else
				_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, -$iX + $iY, $iY, -$iX + $iY + $iLen, $iY, $hPen)
				_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, -$iX + $iY + 2 * $iLen, $iY, -$iX + $iY + 3 * $iLen, $iY, $hPen)
		EndSwitch
	Next
	Local $tPoint1 = DllStructCreate("float;float")
	Local $tPoint2 = DllStructCreate("float;float")
	DllStructSetData($tPoint1, 1, $iW / 2) ;x1
	DllStructSetData($tPoint2, 1, $iW / 2) ;x2
	Local $hLineBrush
	
	If $bFlip Then
		_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, 0, 0, $iWidth, 0, $hPen2)
		DllStructSetData($tPoint2, 2, $iH * 2 / 3) ;y2
		DllStructSetData($tPoint1, 2, $iH / 3) ;y1
		$hLineBrush = DllCall($ghGDIPDll, "uint", "GdipCreateLineBrush", "struct*", $tPoint1, "struct*", $tPoint2, "uint", 0x00FFFFFF, "uint", 0xB0FFFFFF, "int", 0, "int*", 0)
		$hLineBrush = $hLineBrush[6]
		_GDIPlus_GraphicsFillRect($hCtxt_Bmp, 0, $iH * 2 / 3 + 1, $iW, $iH / 3, $hLineBrush)
	Else
		_GDIPlus_GraphicsDrawLine($hCtxt_Bmp, 0, $iH - $iPenSize / 2, $iWidth, $iH - $iPenSize / 2, $hPen2)
		DllStructSetData($tPoint1, 2, 0) ;y1
		DllStructSetData($tPoint2, 2, $iH / 3) ;y2
		$hLineBrush = DllCall($ghGDIPDll, "uint", "GdipCreateLineBrush", "struct*", $tPoint1, "struct*", $tPoint2, "uint", 0xB0FFFFFF, "uint", 0x00FFFFFF, "int", 0, "int*", 0)
		$hLineBrush = $hLineBrush[6]
		_GDIPlus_GraphicsFillRect($hCtxt_Bmp, 0, 0, $iW, $iH / 3, $hLineBrush)
	EndIf
	$iX = Mod($iX + $iSpeed, $iWidth)
	
	Local $hTextureBrush = DllCall($ghGDIPDll, "uint", "GdipCreateTexture", "handle", $hBmp, "int", 0, "int*", 0)
	$hTextureBrush = $hTextureBrush[3]
	
	_GDIPlus_GraphicsFillRect($hCtxt, 0, 0, $fPerc / 100 * $iW, $iH, $hTextureBrush)
	If $bFlip Then DllCall($ghGDIPDll, "uint", "GdipImageRotateFlip", "handle", $hBitmap, "int", 6)
	
	DllCall($ghGDIPDll, "int", "GdipSetTextRenderingHint", "handle", $hCtxt, "int", 4)
	Local $hBrush = _GDIPlus_BrushCreateSolid(0x40000000 + $iTextColor)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $iH * 3 / 5, 2)
	Local $tLayout = _GDIPlus_RectFCreate(0, 0, $iW, $iH)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_GraphicsDrawStringEx($hCtxt, $sText, $hFont, $tLayout, $hFormat, $hBrush)

	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_GraphicsDispose($hCtxt)
	_GDIPlus_GraphicsDispose($hCtxt_Bmp)
	_GDIPlus_BitmapDispose($hBmp)
	_GDIPlus_BrushDispose($hTextureBrush)
	_GDIPlus_BrushDispose($hLineBrush)
	If $bHBitmap Then
		Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBITMAP
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_StripProgressbar