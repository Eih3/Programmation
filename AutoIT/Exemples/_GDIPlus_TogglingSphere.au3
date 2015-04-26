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
If Not $bAero Then $fStep = 1.5

_GDIPlus_Startup()
Global Const $STM_SETIMAGE = 0x0172, $IMAGE_BITMAP = 0
Global $iW = 400, $iH = 150
Global Const $hGUI = GUICreate("Monochromatic Blinker", $iW, $iH, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
GUISetBkColor(0xEEEEEE)
Global Const $iPic = GUICtrlCreatePic("", 0, 0, $iW, $iH)
GUICtrlSetState(-1, $GUI_DISABLE)
WinSetTrans($hGUI, "", 0)
GUISetState()
Global $hHBmp_BG, $hB, $iSleep = 30
GUIRegisterMsg($WM_TIMER, "PlayAnim")
DllCall("user32.dll", "int", "SetTimer", "hwnd", $hGUI, "int", 0, "int", $iSleep, "int", 0)
Global $z, $iPerc = 0

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
	$hHBmp_BG = _GDIPlus_TogglingSphere($iW, $iH, "Loading... " & StringFormat("%05.2f %", $iPerc))
	$hB = GUICtrlSendMsg($iPic, $STM_SETIMAGE, $IMAGE_BITMAP, $hHBmp_BG)
	If $hB Then _WinAPI_DeleteObject($hB)
	_WinAPI_DeleteObject($hHBmp_BG)
	$iPerc += 0.1
	If $iPerc > 99.9 Then $iPerc = 0
EndFunc   ;==>PlayAnim

Func _GDIPlus_TogglingSphere($iW, $iH, $sString = "Please wait...", $bHBitmap = True)
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]

	Local Const $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hCtxt, 2)
	Local Const $hBmp_BG = _GDIPlus_BMPFromMemory(_Background())
	Local $hBrushTexture = DllCall($ghGDIPDll, "uint", "GdipCreateTexture", "handle", $hBmp_BG, "int", 0, "int*", 3)
	$hBrushTexture = $hBrushTexture[3]
	_GDIPlus_BitmapDispose($hBmp_BG)
	_GDIPlus_GraphicsFillRect($hCtxt, 0, 0, $iW, $iH, $hBrushTexture)
	Local Const $fDeg = ACos(-1) / 180, $iW2 = $iW / 2, $iH2 = $iH / 2, $iSizeBall = 20, $iSizeBall2 = $iSizeBall / 2, $fFontSize = 16, $fSpeed = 0.5, _
			$iLength = 150, $iLength2 = $iLength / 2, $iBorder = 6, $iBorder2 = $iBorder / 2, $iBorder3 = $iBorder / 3, $iBorder4 = $iBorder3 / 2

	Local Const $hBrushRect = _GDIPlus_BrushCreateSolid(0xA0F8F8F8)
	Local Const $hPenRect = _GDIPlus_PenCreate(0x28000000, $iBorder)
	Local Const $hPenBall = _GDIPlus_PenCreate(0x30303030, $iBorder2)

	Local $hPath = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0)
	$hPath = $hPath[2]
	DllCall($ghGDIPDll, "uint", "GdipAddPathArcI", "handle", $hPath, "int", $iW2 - $iLength2 - $iSizeBall - $iBorder2, "int", $iH2 - $iSizeBall2 - 2, "int", $iSizeBall + $iBorder, "int", $iSizeBall + $iBorder, "float", 90, "float", 180)
	DllCall($ghGDIPDll, "uint", "GdipAddPathArcI", "handle", $hPath, "int", $iW2 + $iLength2 - $iBorder2, "int", $iH2 - $iSizeBall2 - 2, "int", $iSizeBall + $iBorder, "int", $iSizeBall + $iBorder, "float", -90, "float", 180)
	DllCall($ghGDIPDll, "uint", "GdipClosePathFigure", "handle", $hPath)

	DllCall($ghGDIPDll, "uint", "GdipFillPath", "handle", $hCtxt, "handle", $hBrushRect, "handle", $hPath)
	DllCall($ghGDIPDll, "uint", "GdipDrawPath", "handle", $hCtxt, "handle", $hPenRect, "handle", $hPath)
	Local Static $iPosX = 0, $f
	DllCall($ghGDIPDll, "int", "GdipDrawEllipse", "handle", $hCtxt, "handle", $hPenBall, "float", $iPosX + $iW2 - $iSizeBall2, "float", $iH2 - $iSizeBall2 + $iBorder4, "float", $iSizeBall, "float", $iSizeBall)

	Local $hPath = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0)
	$hPath = $hPath[2]
	DllCall($ghGDIPDll, "uint", "GdipAddPathEllipse", "handle", $hPath, "float", $iPosX + $iW2 - $iSizeBall2, "float", $iH2 - $iSizeBall2 + $iBorder4, "float", $iSizeBall, "float", $iSizeBall)
	Local $hBrushBall = DllCall($ghGDIPDll, "uint", "GdipCreatePathGradientFromPath", "handle", $hPath, "int*", 0)
	$hBrushBall = $hBrushBall[2]
	Local $tPointF = DllStructCreate("float;float")
	DllStructSetData($tPointF, 1, $iPosX + $iSizeBall2 * ($iSizeBall / ($iSizeBall / 20) ^ 2))
	DllStructSetData($tPointF, 2, $iSizeBall2 * (1 + $iSizeBall / 200))
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterPoint", "handle", $hBrushBall, "struct*", $tPointF)
;~ 	DllCall($ghGDIPDll, "uint", "GdipSetLineGammaCorrection", "handle", $hBrushBall, "int", 1)
	Local $tARGB = DllStructCreate("int")
	DllStructSetData($tARGB, 1, 0xB8C8C8C8, 1)
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSurroundColorsWithCount", "handle", $hBrushBall, "struct*", $tARGB, "int*", 1)

	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterColor", "handle", $hBrushBall, "int", 0xFFFFFFFF)
	DllCall($ghGDIPDll, "uint", "GdipFillPath", "handle", $hCtxt, "handle", $hBrushBall, "handle", $hPath)

	$iPosX = Sin($f) * ($iLength2 + $iSizeBall2)
	$f += 0.065

	Local Const $hFormat = _GDIPlus_StringFormatCreate()
	Local Const $hFamily = _GDIPlus_FontFamilyCreate("Times New Roman")
	Local Const $hFont = _GDIPlus_FontCreate($hFamily, $fFontSize, 1)
	Local Const $hBrushTxt = _GDIPlus_BrushCreateSolid(0)
	Local Const $tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
	Local Const $aInfo = _GDIPlus_GraphicsMeasureString($hCtxt, $sString, $hFont, $tLayout, $hFormat)
	DllStructSetData($tLayout, "X", 1 + ($iW - DllStructGetData($aInfo[0], "Width")) / 2)
	DllStructSetData($tLayout, "Y", 1 + $iH / 2 + $iSizeBall + $iSizeBall2)
	_GDIPlus_BrushSetSolidColor($hBrushTxt, 0xFFFFFFFF)
	_GDIPlus_GraphicsDrawStringEx($hCtxt, $sString, $hFont, $tLayout, $hFormat, $hBrushTxt)
	DllStructSetData($tLayout, "X", ($iW - DllStructGetData($aInfo[0], "Width")) / 2)
	DllStructSetData($tLayout, "Y", $iH / 2 + $iSizeBall + $iSizeBall2)
	_GDIPlus_BrushSetSolidColor($hBrushTxt, 0xFF101010)
	_GDIPlus_GraphicsDrawStringEx($hCtxt, $sString, $hFont, $tLayout, $hFormat, $hBrushTxt)

	DllCall($ghGDIPDll, "uint", "GdipDeletePath", "handle", $hPath)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrushTxt)
	_GDIPlus_BrushDispose($hBrushTexture)
	_GDIPlus_GraphicsDispose($hCtxt)
	_GDIPlus_BrushDispose($hBrushBall)
	_GDIPlus_BrushDispose($hBrushRect)
	_GDIPlus_PenDispose($hPenRect)
	_GDIPlus_PenDispose($hPenBall)
	If $bHBitmap Then
		Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBITMAP
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_TogglingSphere

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
	$Background &= '/CLHzCrsZIBL3LLHMzlqakA/IFCdpSnKoSJzxyoDsCS84YEAmAA2eHjzyMZR2U69Q7MgD1UVPXUTYyNJFLFAUBqds7rRAyVlbKv6fnCdR4qFTqZD7vnIAIAxgxIQUzECS7mcWKCQwLztBSwWUq1MkyuQf86AyXzAxtt0GI4e4l0ph0GGh3QrU3OaWTel1lMp73ziEKGgj3ZNM8cKyLqa9kSKXcWfiMYgYJXapv3cc4q7PpCV6uSed5Ik6YwRHJTOvMLLS6AZsEWvhwMewNwwRQ2ARHFNYkBTWQ/IBjE0IcYpEJK1GlfCA+arI1Bb1JToCbJNyzrOVieTARpgjYlF5jCllshKXtgP/ctIcBEaUaLKOQbnGSImiSLh+z2+sBjGXcQjcyxYYpi4lkp9KqLOoiXaDzjHKZhZYVG/R5LJwaKctIG2J3z4Fl5atBnNKdghJfFvIay5BG24JaRT4nCDwDSWACAUaVQK2ZIYUgLCKIkKxoHJQaAig+6NR21hV7H5DiBHA23i8pUWma6GldotnDwhIx+CRg7ntiYvaYyRPkP4dmEuOCeunmV6c4qZAkkYdIwu15zgo0CrZTJFdL9Q5SJFy8V9CrVHzJZIS0DJyI5FVHuXqa8my7qaY6Rr3FRGdtJAZ0JBaQOWaQ02OSjTZfTW8kMrtcwUf2Ou86giWJ5UDhCrbcaQlcXJc0WobiINX1EhAsoFDpwoR4kYISt9Il9z/9oADAMBAAIAAwAAABBRjDizhBDSDiSCjDj/xAAUEQEAAAAAAAAAAAAAAAAAAABA/9oACAEDAQE/EAf/xAAUEQEAAAAAAAAAAAAAAAAAAABA/9oACAECAQE/EAf/xAAdEAEBAQEBAQEBAQEAAAAAAAABESExAEFRYXGh/9oACAEBAAE/EMcMJfpGfAQABB5aBfT4lvmCaD6eO2wl9/7/ACmfHUo7JaB2CH4PnnVpce1pjNp0TE8whlErE+S1qFhooSOpZTZ+SCSpfFGu7UPEIzXLxAKC4xPM4MHQnpIlBf8AAuFD1+ngvwNgMtrvC0Qe30Qbo+TTmw2IJybBsdjjP9W++IR4m2ujuU9amTwz5BDIt/0gGfPBGlF+Qr4ci/o8EBccbkv8Qu4v7NgyzBt8FA5rSx6bJ1TFbMkBRUkyY69o9VXmKAyqap6G4EH9bO+Ca4f03EnYAWqihQDjuSJoti7HJkUhM5WCrHQPqr9BxTb9FNqqUfl6a+q64Bgqvwxk8vb+6kh/2Pzq/Z7Z8ETDZ/P/ACVd8oTJAAASjRwAcednssb0uWv1DHwKMQgsUNIzNSweI4EisIELMc3mrzhcOweO4A/ABgPqeKIOxrZEohIQWKOBEIP/AIN0IwgXZ8rGNQlGbvhAFDypssI80x8I3yi/YfER7L+vriro4xElnwlI9PPWTU8DsPhyHtO5jELE3dlQA9RMJri04JJATcaKQo0rrJLU6QcWV/Q20TDZ1sELFkLEEiZAleBGIaKHKNzMDoUCpwDc8hxewUEAB0n5bizuguCv6IS+Qqh+nBr7YViRIj2OadDkcezONtbOuMOufEHWeIPG0H5hGvKCkBAMcYT6VfGaIu1a/wCE3hloezcawmnHsWAWcJOLHiTw5QMQICEJaN5hHGhWAihXUatV6TWpcAGAqAhJzcq5UF1WHwqUuGnjS0YNKWA0UZqjJpQNSCUUdSqFTfFouJV4ddFCdVGQSwwJ6JZxVJID0B+KTvv/2Q=='
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