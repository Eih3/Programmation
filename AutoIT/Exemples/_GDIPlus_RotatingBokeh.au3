;coded by UEZ build 2013-05-02, idea from http://tympanus.net/codrops/2012/11/14/creative-css-loading-animations/
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Memory.au3>
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
Global $iW = 400, $iH = 210
Global Const $hGUI = GUICreate("Rotating Bokeh", $iW, $iH, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
GUISetBkColor(0)
Global Const $iPic = GUICtrlCreatePic("", 0, 0, $iW, $iH)
GUICtrlSetState(-1, $GUI_DISABLE)
WinSetTrans($hGUI, "", 0)
GUISetState()
Global $hHBmp_BG, $hB, $iSleep = 20
GUIRegisterMsg($WM_TIMER, "PlayAnim")
DllCall("user32.dll", "int", "SetTimer", "hwnd", $hGUI, "int", 0, "int", $iSleep, "int", 0)

Global $z, $iPerc
For $z = 1 To 255 Step $fStep
	WinSetTrans($hGUI, "", $z)
Next

Do
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			GUIRegisterMsg($WM_TIMER, "")
			_WinAPI_DeleteObject($hHBmp_BG)
			_GDIPlus_Shutdown()
			GUIDelete()
			Exit
	EndSwitch
Until False

Func PlayAnim()
	$hHBmp_BG = _GDIPlus_RotatingBokeh($iW, $iH, "Please wait..." & StringFormat("%05.2f %", $iPerc))
	$hB = GUICtrlSendMsg($iPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	$iPerc += 0.1
	If $iPerc > 99.9 Then $iPerc = 0
EndFunc   ;==>PlayAnim

Func _GDIPlus_RotatingBokeh($iW, $iH, $sString = "Please wait...", $bHBitmap = True)
	Local Const $hBrushBall1 = _GDIPlus_BrushCreateSolid(0xE004AC6B)
	Local Const $hBrushBall2 = _GDIPlus_BrushCreateSolid(0xC0E0AB27)
	Local Const $hBrushBall3 = _GDIPlus_BrushCreateSolid(0xD081B702)
	Local Const $hBrushBall4 = _GDIPlus_BrushCreateSolid(0xB0E70339)
	Local Const $hPen = _GDIPlus_PenCreate(0xFF303030)
	DllCall($ghGDIPDll, "uint", "GdipSetPenLineJoin", "handle", $hPen, "int", 2)
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]

	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hCtxt, 2)
	Local Const $hBmp_BG = _GDIPlus_BMPFromMemory(_Background())
	Local $hBrushTexture = DllCall($ghGDIPDll, "uint", "GdipCreateTexture", "handle", $hBmp_BG, "int", 0, "int*", 3)
	$hBrushTexture = $hBrushTexture[3]
	_GDIPlus_BitmapDispose($hBmp_BG)
	_GDIPlus_GraphicsFillRect($hCtxt, 0, 0, $iW, $iH, $hBrushTexture)
	Local Const $fDeg = ACos(-1) / 180, $iRadius = 40, $iBallSize = $iRadius / 1.77, $iCircleSize = $iBallSize + 2 * $iRadius, $iBallSize2 = $iBallSize / 2, _
			$iCircleSize2 = $iCircleSize / 2, $fFontSize = 11, $iW2 = -1 + $iW / 2, $iH2 = -1 + $iH / 2
	Local Static $iAngle = 0
	DllCall($ghGDIPDll, "int", "GdipDrawEllipse", "handle", $hCtxt, "handle", $hPen, "float", $iW2 - $iCircleSize2, "float", $iH2 - $iCircleSize2, "float", $iCircleSize, "float", $iCircleSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall1, "float", -$iBallSize2 + $iW2 + Cos(2.25 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(2.25 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall2, "float", -$iBallSize2 + $iW2 + Cos(1.75 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(1.75 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall3, "float", -$iBallSize2 + $iW2 + Cos(1.66 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(1.66 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall4, "float", -$iBallSize2 + $iW2 + Cos(1.33 * $iAngle * $fDeg) * $iRadius, "float", -$iBallSize2 + $iH2 + Sin(1.33 * $iAngle * $fDeg) * $iRadius, "float", $iBallSize, "float", $iBallSize)
	$iAngle += 2.5

	Local Const $hFormat = _GDIPlus_StringFormatCreate()
	Local Const $hFamily = _GDIPlus_FontFamilyCreate("Arial")
	Local Const $hFont = _GDIPlus_FontCreate($hFamily, $fFontSize, 2)
	Local Const $hBrushTxt = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local Const $tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
	Local Const $aInfo = _GDIPlus_GraphicsMeasureString($hCtxt, $sString, $hFont, $tLayout, $hFormat)
	DllStructSetData($tLayout, "X", ($iW - DllStructGetData($aInfo[0], "Width")) / 2)
	DllStructSetData($tLayout, "Y", $iH / 2 + $iRadius + $iBallSize)
	_GDIPlus_GraphicsDrawStringEx($hCtxt, $sString, $hFont, $tLayout, $hFormat, $hBrushTxt)

	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrushTxt)
	_GDIPlus_BrushDispose($hBrushTexture)

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

;==================================================================================================================================
; Function Name:         _GDIPlus_BMPFromMemory
; Description:            Loads an image which is saved as a binary string and converts it to a bitmap or hbitmap
;
; Parameters:            $bImage:    the binary string which contains any valid image which is supported by GDI+
; Optional:             $hHBITMAP:  if false a bitmap will be created, if true a hbitmap will be created
;
; Remark:               hbitmap format is used generally for GUI internal images, $bitmap is more a GDI+ image format
;                       Don't forget _GDIPlus_Startup() and _GDIPlus_Shutdown()
;
; Requirement(s):        GDIPlus.au3, Memory.au3 and _WinAPI_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
; Return Value(s):        Success: handle to bitmap (GDI+ bitmap format) or hbitmap (WinAPI bitmap format),
;                       Error: 0
; Error codes:          1: $bImage is not a binary string
;                       2: unable to create stream on HGlobal
;                       3: unable to create bitmap from stream
;
; Author(s):            UEZ
; Additional Code:        thanks to progandy for the MemGlobalAlloc and tVARIANT lines and
;                        Yashied for _WinAPI_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
; Version:              v0.98 Build 2012-08-29 Beta
;===================================================================================================================================
Func _GDIPlus_BMPFromMemory($bImage, $hHBITMAP = False)
	If Not IsBinary($bImage) Then Return SetError(1, 0, 0)
	Local $aResult
	Local Const $memBitmap = Binary($bImage) ;load image  saved in variable (memory) and convert it to binary
	Local Const $len = BinaryLen($memBitmap) ;get length of image
	Local Const $hData = _MemGlobalAlloc($len, $GMEM_MOVEABLE) ;allocates movable memory  ($GMEM_MOVEABLE = 0x0002)
	Local Const $pData = _MemGlobalLock($hData) ;translate the handle into a pointer
	Local $tMem = DllStructCreate("byte[" & $len & "]", $pData) ;create struct
	DllStructSetData($tMem, 1, $memBitmap) ;fill struct with image data
	_MemGlobalUnlock($hData) ;decrements the lock count  associated with a memory object that was allocated with GMEM_MOVEABLE
	$aResult = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "handle", $pData, "int", True, "ptr*", 0) ;Creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hStream = $aResult[3]
	$aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromStream", "ptr", $hStream, "int*", 0) ;Creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	Local Const $hBitmap = $aResult[2]
	Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, _
			"dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT)) ;release memory from $hStream to avoid memory leak
	$tMem = 0
	$tVARIANT = 0
	If $hHBITMAP Then
		Local Const $hHBmp = _WinAPI_BitmapCreateDIBFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_BMPFromMemory

Func _WinAPI_BitmapCreateDIBFromBitmap($hBitmap) ;create 32-bit bitmap v5 (alpha channel supported)
	Local $tBIHDR, $aRet, $tData, $pBits, $hResult = 0
	$aRet = DllCall($ghGDIPDll, 'uint', 'GdipGetImageDimension', 'ptr', $hBitmap, 'float*', 0, 'float*', 0)
	If (@error) Or ($aRet[0]) Then Return 0
	$tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet[2], $aRet[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$pBits = DllStructGetData($tData, 'Scan0')
	If Not $pBits Then Return 0
	$tBIHDR = DllStructCreate('dword bV5Size;long bV5Width;long bV5Height;word bV5Planes;word bV5BitCount;dword bV5Compression;' & _ ;http://msdn.microsoft.com/en-us/library/windows/desktop/dd183381(v=vs.85).aspx
			'dword bV5SizeImage;long bV5XPelsPerMeter;long bV5YPelsPerMeter;dword bV5ClrUsed;dword bV5ClrImportant;' & _
			'dword bV5RedMask;dword bV5GreenMask;dword bV5BlueMask;dword bV5AlphaMask;dword bV5CSType;' & _
			'int bV5Endpoints[3];dword bV5GammaRed;dword bV5GammaGreen;dword bV5GammaBlue;dword bV5Intent;' & _
			'dword bV5ProfileData;dword bV5ProfileSize;dword bV5Reserved')
	DllStructSetData($tBIHDR, 'bV5Size', DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, 'bV5Width', $aRet[2])
	DllStructSetData($tBIHDR, 'bV5Height', $aRet[3])
	DllStructSetData($tBIHDR, 'bV5Planes', 1)
	DllStructSetData($tBIHDR, 'bV5BitCount', 32)
	DllStructSetData($tBIHDR, 'bV5Compression', 0) ; $BI_BITFIELDS = 3, $BI_RGB = 0, $BI_RLE8 = 1, $BI_RLE4 = 2, $RGBA = 0x41424752
	DllStructSetData($tBIHDR, 'bV5SizeImage', $aRet[3] * DllStructGetData($tData, 'Stride'))
	DllStructSetData($tBIHDR, 'bV5AlphaMask', 0xFF000000)
	DllStructSetData($tBIHDR, 'bV5RedMask', 0x00FF0000)
	DllStructSetData($tBIHDR, 'bV5GreenMask', 0x0000FF00)
	DllStructSetData($tBIHDR, 'bV5BlueMask', 0x000000FF)
	DllStructSetData($tBIHDR, 'bV5CSType', 2) ; LCS_WINDOWS_COLOR_SPACE = 2
	DllStructSetData($tBIHDR, 'bV5Intent', 4) ; $LCS_GM_IMA
	$hResult = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', DllStructGetPtr($tBIHDR), 'uint', 0, 'ptr*', 0, 'ptr', 0, 'dword', 0)
	If (Not @error) And ($hResult[0]) Then
		DllCall('gdi32.dll', 'dword', 'SetBitmapBits', 'ptr', $hResult[0], 'dword', $aRet[2] * $aRet[3] * 4, 'ptr', DllStructGetData($tData, 'Scan0'))
		$hResult = $hResult[0]
	Else
		$hResult = 0
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
	$tData = 0
	$tBIHDR = 0
	Return $hResult
EndFunc   ;==>_WinAPI_BitmapCreateDIBFromBitmap

;Code below was generated by: 'File to Base64 String' Code Generator v1.12 Build 2013-03-27

Func _Background($bSaveBinary = False, $sSavePath = @ScriptDir)
	Local $Background
	$Background &= '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'
	$Background &= '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'
	$Background &= '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'
	$Background &= 'G86ltb46g01fM7u5dOL3KyYID01ELYyLM/zxBP8AyK3J9TSQWgrTuIGSWEUZ/wAnLjmDtQ5lA60QIVliWNeEtaPPUwRY+05CNRZpG425V32EKzhnL0Jnh+o6ZjaOY4QY+DjEsUy/ca764gW7N9RO+2Axg+PMKsxxMFtcfmdD9LKF13+ILFH2SgTWXsluGSXMKyO4WlXOwzqGWeUotv5nLaAfCCwUGjcxXIZiq8kzYntF+ZioljC9js6jeqa6iILcbEzG1EbeWI7t0xKT0gMa4gVqtzsSFHiGBnp17xNlqKToK+2W4y8/iWhhfiXhbz1NmoZcQN5rfcbQtPmG8pfrDWjfc//Z'
	Local $bString = Binary(_Base64Decode($Background))
	If $bSaveBinary Then
		Local $hFile = FileOpen($sSavePath & "\stressed_linen.jpg", 18)
		FileWrite($hFile, $bString)
		FileClose($hFile)
	EndIf
	Return $bString
EndFunc   ;==>_Background

Func _Base64Decode($sB64String)
	Local $a_Call = DllCall("Crypt32.dll", "bool", "CryptStringToBinaryA", "str", $sB64String, "dword", 0, "dword", 1, "ptr", 0, "dword*", 0, "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
	Local $a = DllStructCreate("byte[" & $a_Call[5] & "]")
	$a_Call = DllCall("Crypt32.dll", "bool", "CryptStringToBinaryA", "str", $sB64String, "dword", 0, "dword", 1, "struct*", $a, "dword*", $a_Call[5], "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode