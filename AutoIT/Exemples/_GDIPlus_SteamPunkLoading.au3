;coded by UEZ build 2013-05-02, idea from http://tympanus.net/codrops/2012/11/14/creative-css-loading-animations/
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Memory.au3>
#include <GDIPlus.au3>

If @AutoItVersion < "3.3.8.0" Then Exit MsgBox(16 + 262144, "ERROR", "AutoIt version 3.3.8.0 or higher needed! Please update!", 180)

Global Const $hDwmApiDll = DllOpen("dwmapi.dll")
Global $sChkAero = DllStructCreate("int;")
DllCall($hDwmApiDll, "int", "DwmIsCompositionEnabled", "ptr", DllStructGetPtr($sChkAero))
Global $bAero = DllStructGetData($sChkAero, 1)
Global $fStep = 0.02
If Not $bAero Then $fStep = 1.25

_GDIPlus_Startup()
Global Const $STM_SETIMAGE = 0x0172, $IMAGE_BITMAP = 0
Global $iW = 400, $iH = 250
Global Const $hGUI = GUICreate("Steam Punk Loading", $iW, $iH, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
GUISetBkColor(0xD2CEC6)
Global Const $iPic = GUICtrlCreatePic("", 0, 0, $iW, $iH)
GUICtrlSetState(-1, $GUI_DISABLE)
WinSetTrans($hGUI, "", 0)
GUISetState()
Global $hHBmp_BG, $hB, $iSleep = 50
GUIRegisterMsg($WM_TIMER, "PlayAnim")
DllCall("user32.dll", "int", "SetTimer", "hwnd", $hGUI, "int", 0, "int", $iSleep, "int", 0)
Global $z
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
	$hHBmp_BG = _GDIPlus_SteamPunkLoading($iW, $iH)
	$hB = GUICtrlSendMsg($iPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
EndFunc   ;==>PlayAnim

Func _GDIPlus_SteamPunkLoading($iW, $iH, $sString = "Please wait...", $bHBitmap = True)
	Local Const $hPenArc = _GDIPlus_PenCreate(0xA08ABDC3, 25)
	DllCall($ghGDIPDll, "uint", "GdipSetPenLineJoin", "handle", $hPenArc, "int", 2)
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]

	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hCtxt, 2)
	Local Const $hBmp_BG = _GDIPlus_BMPFromMemory(_Background())
	Local $hBrushTexture = DllCall($ghGDIPDll, "uint", "GdipCreateTexture", "handle", $hBmp_BG, "int", 0, "int*", 3)
	$hBrushTexture = $hBrushTexture[3]
	_GDIPlus_BitmapDispose($hBmp_BG)
	_GDIPlus_GraphicsFillRect($hCtxt, 0, 0, $iW, $iH, $hBrushTexture)
	Local $fCosX, $fSinY, $i
	Local Const $fDeg = ACos(-1) / 180, $iW2 = $iW / 2, $iH2 = $iH / 2, $iDiameter = 200, $iRadius = $iDiameter / 2, $iSize = 25, $iSize2 = $iSize / 2, $fFontSize = 20
	Local Static $iAngle = 0, $iX = 0, $iDir = 1
	_GDIPlus_PenSetColor($hPenArc, 0x60F0F0F0)
	DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - $iRadius, "float", $iH2 - $iRadius, "float", $iDiameter, "float", $iDiameter, "float", 0, "float", 360)

	_GDIPlus_PenSetColor($hPenArc, 0xA08ABDC3)
	For $i = 0 To 7
		If Not Mod($i, 2) Then
			DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - ($iRadius - $iSize), "float", $iH2 - ($iRadius - $iSize), "float", $iDiameter - 2 * $iSize, "float", $iDiameter - 2 * $iSize, "float", $iAngle + $i * 45, "float", 45)
		EndIf
	Next
	_GDIPlus_PenSetColor($hPenArc, 0x20F0F0F0)
	DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - ($iRadius - $iSize), "float", $iH2 - ($iRadius - $iSize), "float", $iDiameter - 2 * $iSize, "float", $iDiameter - 2 * $iSize, "float", 0, "float", 360)

	_GDIPlus_PenSetColor($hPenArc, 0x508ABDC3)
	For $i = 0 To 5
		If Not Mod($i, 2) Then
			DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - ($iRadius - 2 * $iSize), "float", $iH2 - ($iRadius - 2 * $iSize), "float", $iDiameter - 4 * $iSize, "float", $iDiameter - 4 * $iSize, "float", $iAngle + $i * 60, "float", 60)
		EndIf
	Next
	_GDIPlus_PenSetColor($hPenArc, 0x30F0F0F0)
	DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - ($iRadius - 2 * $iSize), "float", $iH2 - ($iRadius - 2 * $iSize), "float", $iDiameter - 4 * $iSize, "float", $iDiameter - 4 * $iSize, "float", 0, "float", 360)

	_GDIPlus_PenSetColor($hPenArc, 0x808ABDC3)
	For $i = 0 To 3
		If Not Mod($i, 2) Then
			DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - ($iRadius - 3 * $iSize), "float", $iH2 - ($iRadius - 3 * $iSize), "float", $iDiameter - 6 * $iSize, "float", $iDiameter - 6 * $iSize, "float", $iAngle + $i * 90, "float", 90)
		EndIf
	Next
	_GDIPlus_PenSetColor($hPenArc, 0x20F0F0F0)
	DllCall($ghGDIPDll, "float", "GdipDrawArc", "handle", $hCtxt, "handle", $hPenArc, "float", $iW2 - ($iRadius - 3 * $iSize), "float", $iH2 - ($iRadius - 3 * $iSize), "float", $iDiameter - 6 * $iSize, "float", $iDiameter - 6 * $iSize, "float", 0, "float", 360)

	Local $hBrushCircle = _GDIPlus_BrushCreateSolid(0x60F0F0F0)
	_GDIPlus_GraphicsFillEllipse($hCtxt, $iW2 - $iSize2, $iH2 - $iSize2, $iSize, $iSize, $hBrushCircle)

	$iAngle += 4
	Local Const $hFormat = _GDIPlus_StringFormatCreate()
	Local Const $hFamily = _GDIPlus_FontFamilyCreate("Impact")
	Local Const $hFont = _GDIPlus_FontCreate($hFamily, $fFontSize)
	Local Const $tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
	Local Const $aInfo = _GDIPlus_GraphicsMeasureString($hCtxt, $sString, $hFont, $tLayout, $hFormat)
	Local Const $hBrushTxt = _GDIPlus_LineBrushCreate($iX, 0, DllStructGetData($aInfo[0], "Width"), 0, 0x90101010, 0xFFA0A0A0, 2)
	DllCall($ghGDIPDll, "uint", "GdipSetLineLinearBlend", "handle", $hBrushTxt, "float", $iX, "float", 1)
	DllStructSetData($tLayout, "X", ($iW - DllStructGetData($aInfo[0], "Width")) / 2)
	DllStructSetData($tLayout, "Y", ($iH - DllStructGetData($aInfo[0], "Height")) / 2)
	DllCall($ghGDIPDll, "uint", "GdipSetLineGammaCorrection", "handle", $hBrushTxt, "int", 1)
	_GDIPlus_GraphicsDrawStringEx($hCtxt, $sString, $hFont, $tLayout, $hFormat, $hBrushTxt)
	$iX += 0.02 * $iDir
	If $iX > 0.98 Or $iX < 0.02 Then $iDir *= -1

	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrushTxt)
	_GDIPlus_BrushDispose($hBrushTexture)
	_GDIPlus_BrushDispose($hBrushCircle)
	_GDIPlus_GraphicsDispose($hCtxt)
	_GDIPlus_PenDispose($hPenArc)
	If $bHBitmap Then
		Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBITMAP
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_SteamPunkLoading

Func _GDIPlus_LineBrushCreate($nX1, $nY1, $nX2, $nY2, $iARGBClr1, $iARGBClr2, $iWrapMode = 0)
	Local $tPointF1, $pPointF1
	Local $tPointF2, $pPointF2
	Local $aResult
	$tPointF1 = DllStructCreate("float;float")
	$pPointF1 = DllStructGetPtr($tPointF1)
	$tPointF2 = DllStructCreate("float;float")
	$pPointF2 = DllStructGetPtr($tPointF2)
	DllStructSetData($tPointF1, 1, $nX1)
	DllStructSetData($tPointF1, 2, $nY1)
	DllStructSetData($tPointF2, 1, $nX2)
	DllStructSetData($tPointF2, 2, $nY2)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipCreateLineBrush", "ptr", $pPointF1, "ptr", $pPointF2, "uint", $iARGBClr1, "uint", $iARGBClr2, "int", $iWrapMode, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[6]
EndFunc   ;==>_GDIPlus_LineBrushCreate

;==================================================================================================================================
; Function Name: 		_GDIPlus_BMPFromMemory
; Description:			Loads an image which is saved as a binary string and converts it to a bitmap or hbitmap
;
; Parameters:			$bImage:    the binary string which contains any valid image which is supported by GDI+
; Optional:             $hHBITMAP:  if false a bitmap will be created, if true a hbitmap will be created
;
; Remark:               hbitmap format is used generally for GUI internal images, $bitmap is more a GDI+ image format
;                       Don't forget _GDIPlus_Startup() and _GDIPlus_Shutdown()
;
; Requirement(s):		GDIPlus.au3, Memory.au3 and _WinAPI_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
; Return Value(s):		Success: handle to bitmap (GDI+ bitmap format) or hbitmap (WinAPI bitmap format),
;                       Error: 0
; Error codes:          1: $bImage is not a binary string
;                       2: unable to create stream on HGlobal
;                       3: unable to create bitmap from stream
;
; Author(s):            UEZ
; Additional Code:    	thanks to progandy for the MemGlobalAlloc and tVARIANT lines and
;						Yashied for _WinAPI_BitmapCreateDIBFromBitmap() from WinAPIEx.au3
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
	$Background &= 'LOFCvoQczPJitnNhK6LyTXI9KjVA1dtXWqnrFOSdR05mZE3yI2Ukuuj9N/2PwA0mbXTJCbJMAW64+752oCjN8S38V6F+KX0KB2/UvGerk6TC+J86gww9lqeynRnz76ZymsQWkPdR+B0F/8xeLjgh6ayUf9JpbxbfqDDUwpZ/1OT26fRIyi0f8H3Q4LzBFGX6BDoxVM78d+cAxHYzi2B2qMhJgo+q0llrIvmU/BlJiNwrAyX0IH6Wm00eKfWpjaa8TbIGyAa3gBRO0CN9XtQBMhnnhIlX6jlgGQ9XLlw5RdOeMZ+QJVnO5xL8BCAvlXa2cOVwUHaO9DDrDYHdgFZe+Vvj/BVX23yt2759JLfouOXvscO5npH0qRCp3tKaySMj/ynGv+FBJzwVq0j9OPhonMSowPcAWtlwZx6TQw+sUkhQYsGe2XxktUVkVDKobOZU9zH1BAjDf2SrBx9YxNtUr1+oUWLv/wqBL9s/CWf9p0FKcEiPG0RXYbgLipCqkhCrykEjA2L/InZQipV73xP+7RFHH2EHQqdRZAPgrbTodI+sLgQbY77HESDf7S4Xsv6Ag9/c+Du/nGKVTs7TVjl90tkazPB2w8xXtiDK8aDJxmy4chwo+BCaL5/wWPJOK3RCnEuTb2q2syrwD9X+x/PkL77C4T+5ZI+XHX5hV+Mzei1xfP6G72H1OH7Ibg8W2nKjtbdoQPTGdnUXeCGOtVb9Vsz2lUsx0s6IZ2YljZ2D8po570z1B5HeagoBOWp/JS2QhlWvpxzQ6ZFX/SLXKRufdqvHjW9q8jOqnDB5rx4bXXBbgY6efisZvvNgz4yPfJaGWR+guIWsCeWVpWpSeNBArcSsCxWhwWAGwPVOZyvYsfKELV9c68nFX8Phj/rkPZJ6vvXiA77oQAOFv4wA13bwBAlHGuxSjir1TDiASHdF2MjscLNHgh6wsgLRNHHfyVPHFlq8rZClpLLxg2ckd9390RIuJImnJujuBiz/KtZLiO2N6Q7zM5hLVdoBOoe02TiBsZlSSrglkFInnmjRbUPgb/DFW3M6y+WAhVJ0O+X+yxNQ61Dp2R6SqGWvbK/R+46ZD/wsZNZoBKcJJWXks9O6Etc1V+ZscgHwCQUOe83XYrX3L4ZQcz7rlgtPefNeIV79bjvl5YBOv6fVvsYZLXe5+YSJne4wevdHHSA2l2VVRxOUeyh8g9bclLo2aZhx6wWBHNwFIKOAQt2VNaHyZqtxKG2NcB9ql/RK6fHDSr5IxyMPd775wmK/oOE5rvUFKd/YhEP4f8fMHdf+y87obHLHS9dxi6Sf5HHVBxJNd+tadQ5iiJBbgboRyYL8f97GxFpfoTQpxKvgRtlOQ/yFlruI7sQi3Ok15tI52ZMnrPV7Zr7Vc/IEXyX1h0D3zBXyBVsc9k9Mbad1aQLk+sKinZvbyP4bBgBnZpLVnGnFKL8WjO5BdZDOkbFUlBcGlSGawo8rtXyHx+kpT5xWYIrTvTp9T9+0jd3ekOhbTpbUcV8a/ajXeLSPQitOv9pVDvSxS7OVeS0Cn42WuHJ4t+wThE6rOIOXrUv91QjnoNgtD1sQU2a/V1sou75sUtEHJI76RZv+/dPtxe+61iITplxwRS+Nf1j3LYe/3MCXTc9y0p4Ptrq3DSv/P++8o9FNjW8tAAAAAElFTkSuQmCC'
	Local $bString = Binary(_Base64Decode($Background))
	If $bSaveBinary Then
		Local $hFile = FileOpen($sSavePath & "\hexabump.png", 18)
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
