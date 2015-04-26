;coded by UEZ build 2013-05-29, idea from http://www.alessioatzeni.com/wp-content/tutorials/html-css/CSS3-Loading-Animation/index.html
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
Global $iW = 300, $iH = 120
Global Const $hGUI = GUICreate("Increasing Balls", $iW, $iH, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
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
	$hHBmp_BG = _GDIPlus_IncreasingBalls($iW, $iH, $iPerc, "Please wait..." & StringFormat("%05.2f %", Min($iPerc, 100)))
	$hB = GUICtrlSendMsg($iPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	$iPerc += 0.5
	If $iPerc > 110 Then $iPerc = 0
EndFunc   ;==>PlayAnim

Func _GDIPlus_IncreasingBalls($iW, $iH, $iPerc, $sString = "Please wait...", $iRadius = 12, $iBalls = 5, $bHBitmap = True)
	Local Const $iDiameter = $iRadius * 2

	Local $tPointF1 = DllStructCreate("float;float")
	Local $pPointF1 = DllStructGetPtr($tPointF1)
	Local $tPointF2 = DllStructCreate("float;float")
	Local $pPointF2 = DllStructGetPtr($tPointF2)
	DllStructSetData($tPointF1, 1, $iDiameter)
	DllStructSetData($tPointF1, 2, 0)
	DllStructSetData($tPointF2, 1, $iDiameter)
	DllStructSetData($tPointF2, 2, $iDiameter)
	Local $hBrushBall2 = DllCall($ghGDIPDll, "uint", "GdipCreateLineBrush", "ptr", $pPointF1, "ptr", $pPointF2, "uint", 0xFF2287E7, "uint", 0xFF9BE6FE, "int", 1, "int*", 0)
	$hBrushBall2 = $hBrushBall2[6]

	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]

	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hCtxt, 2)
	Local Const $hBmp_BG = _GDIPlus_BMPFromMemory(_Background())
	Local $hBrushTexture = DllCall($ghGDIPDll, "uint", "GdipCreateTexture", "handle", $hBmp_BG, "int", 0, "int*", 3)
	$hBrushTexture = $hBrushTexture[3]
	_GDIPlus_BitmapDispose($hBmp_BG)
	_GDIPlus_GraphicsFillRect($hCtxt, 0, 0, $iW, $iH, $hBrushTexture)

	Local Const $hBrushBall1 = _GDIPlus_BrushCreateSolid(0xFF040404)

	Local Const $fFontSize = 11, $iSize = 10 * $iRadius + 2 * $iBalls * $iRadius
	Local $aPos[$iBalls + 2][4], $iArrayPos, $j = 1
	Local Static $aCircle[$iBalls + 1]
	For $i = 0 To $iBalls - 1
		$aPos[($iBalls - 1) - $i][0] = ($iW / 2) - (($iDiameter + $iRadius) * ($i + 1)) + (($iBalls - 1) / 2 * ($iDiameter + $iRadius)) + $iDiameter
		$aPos[($iBalls - 1) - $i][1] = ($iH - $iRadius) / 2
		_GDIPlus_GraphicsFillEllipse($hCtxt, $aPos[($iBalls - 1) - $i][0], $aPos[($iBalls - 1) - $i][1], $iDiameter, $iDiameter, $hBrushBall1) ;draw background
		$aPos[($iBalls - 1) - $i][2] = 100 / $iBalls
		$iArrayPos = Int($iPerc / ($aPos[($iBalls - 1) - $i][2]))
		$aPos[$iArrayPos][3] = ($iPerc - ($iArrayPos * ($aPos[($iBalls - 1) - $i][2]))) / $aPos[($iBalls - 1) - $i][2]
		If $iArrayPos > 0 Then
			For $j = 0 To $iArrayPos - 1
				$aPos[$j][3] = 1
			Next
		EndIf
	Next

	Local $fMax = 2, $hPen = _GDIPlus_PenCreate(0, 2)
	For $i = 0 To $iBalls - 1
		_GDIPlus_PenSetColor($hPen, 0x1000000 * Int(BitAND(BitShift(0xFF000000, 24), 0xFF) * ($fMax - $aCircle[$i])) + 0x2287E7)
		DllCall($ghGDIPDll, "int", "GdipFillEllipse", "handle", $hCtxt, "handle", $hBrushBall2, _
				"float", $iRadius + $aPos[$i][0] - $iRadius * $aPos[$i][3], "float", $iRadius + $aPos[$i][1] - $iRadius * $aPos[$i][3], _
				"float", $iDiameter * $aPos[$i][3], "float", $iDiameter * $aPos[$i][3])
		If $aPos[$i][3] = 1 And $aCircle[$i] < $fMax Then ;draw balls according to percent
			DllCall($ghGDIPDll, "int", "GdipDrawEllipse", "handle", $hCtxt, "handle", $hPen, _
					"float", $iRadius + $aPos[$i][0] - $iRadius * (1 + $aCircle[$i]), "float", $iRadius + $aPos[$i][1] - $iRadius * (1 + $aCircle[$i]), _
					"float", $iDiameter * (1 + $aCircle[$i]), "float", $iDiameter * (1 + $aCircle[$i]))
			$aCircle[$i] += 0.1
		EndIf
	Next

	If Not $iPerc Then
		For $i = 0 To $iBalls - 1
			$aCircle[$i] = 0
		Next
	EndIf

	Local Const $hFormat = _GDIPlus_StringFormatCreate()
	Local Const $hFamily = _GDIPlus_FontFamilyCreate("Arial")
	Local Const $hFont = _GDIPlus_FontCreate($hFamily, $fFontSize, 2)
	Local Const $hBrushTxt = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local Const $tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
	Local Const $aInfo = _GDIPlus_GraphicsMeasureString($hCtxt, $sString, $hFont, $tLayout, $hFormat)
	DllStructSetData($tLayout, "X", ($iW - DllStructGetData($aInfo[0], "Width")) / 2)
	DllStructSetData($tLayout, "Y", $iH - $iH / 4)
	_GDIPlus_GraphicsDrawStringEx($hCtxt, $sString, $hFont, $tLayout, $hFormat, $hBrushTxt)

	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrushTxt)
	_GDIPlus_BrushDispose($hBrushTexture)

	_GDIPlus_GraphicsDispose($hCtxt)
	_GDIPlus_BrushDispose($hBrushBall1)
	_GDIPlus_BrushDispose($hBrushBall2)
	_GDIPlus_PenDispose($hPen)

	If $bHBitmap Then
		Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBITMAP
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_IncreasingBalls

Func Min($a, $b)
	If $a < $b Then Return $a
	Return $b
EndFunc   ;==>Min

;==================================================================================================================================
; Function Name:       	_GDIPlus_BMPFromMemory
; Description:         	Loads an image which is saved as a binary string and converts it to a bitmap or hbitmap
;
; Parameters:          	$bImage:    the binary string which contains any valid image which is supported by GDI+
; Optional:             $hHBITMAP:  if false a bitmap will be created, if true a hbitmap will be created
;
; Remark:               hbitmap format is used generally for GUI internal images, $bitmap is more a GDI+ image format
;                       Don't forget _GDIPlus_Startup() and _GDIPlus_Shutdown()
;
; Requirement(s):      	GDIPlus.au3, Memory.au3 and _WinAPI_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
; Return Value(s):     	Success: handle to bitmap (GDI+ bitmap format) or hbitmap (WinAPI bitmap format),
;                       Error: 0
; Error codes:          1: $bImage is not a binary string
;                       2: unable to create stream on HGlobal
;                       3: unable to create bitmap from stream
;
; Author(s):            UEZ
; Additional Code:      thanks to progandy for the MemGlobalAlloc and tVARIANT lines and
;                       Yashied for _WinAPI_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
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
	$Background &= 'iVBORw0KGgoAAAANSUhEUgAAAAQAAAAEAgMAAADUn3btAAAADFBMVEUaGhoTExMqKiofHx8rvcjDAAAAGUlEQVR4XgXAgRAAAAwCwNeY0+RyCqwTdX4IagG79dgjpgAAAABJRU5ErkJggg=='
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