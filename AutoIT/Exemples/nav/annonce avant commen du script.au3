#include-once
#Include <GDIPlus.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>
#include <IE.au3>

;CONSTANTS
Global Const $AW_FADE_IN = 0x00080000 ;fade-in
Global Const $AW_FADE_OUT = 0x00090000;fade-out
Global Const $AW_SLIDE_IN_LEFT = 0x00040001 ;slide in from left
Global Const $AW_SLIDE_OUT_LEFT = 0x00050002 ;slide out to left
Global Const $AW_SLIDE_IN_RIGHT = 0x00040002 ;slide in from right
Global Const $AW_SLIDE_OUT_RIGHT = 0x00050001 ;slide out to right
Global Const $AW_SLIDE_IN_TOP = 0x00040004 ;slide-in from top
Global Const $AW_SLIDE_OUT_TOP = 0x00050008 ;slide-out to top
Global Const $AW_SLIDE_IN_BOTTOM = 0x00040008 ;slide-in from bottom
Global Const $AW_SLIDE_OUT_BOTTOM = 0x00050004 ;slide-out to bottom
Global Const $AW_DIAG_SLIDE_IN_TOPLEFT = 0x00040005 ;diag slide-in from Top-left
Global Const $AW_DIAG_SLIDE_OUT_TOPLEFT = 0x0005000a ;diag slide-out to Top-left
Global Const $AW_DIAG_SLIDE_IN_TOPRIGHT = 0x00040006 ;diag slide-in from Top-Right
Global Const $AW_DIAG_SLIDE_OUT_TOPRIGHT = 0x00050009 ;diag slide-out to Top-Right
Global Const $AW_DIAG_SLIDE_IN_BOTTOMLEFT = 0x00040009 ;diag slide-in from Bottom-left
Global Const $AW_DIAG_SLIDE_OUT_BOTTOMLEFT = 0x00050006 ;diag slide-out to Bottom-left
Global Const $AW_DIAG_SLIDE_IN_BOTTOMRIGHT = 0x0004000a ;diag slide-in from Bottom-right
Global Const $AW_DIAG_SLIDE_OUT_BOTTOMRIGHT = 0x00050005 ;diag slide-out to Bottom-right
Global Const $AW_EXPLODE = 0x00040010 ;explode
Global Const $AW_IMPLODE = 0x00050010 ;implode



Func image($I_Image, $I_Duration = 2000, $I_Speed = 1000, $I_ModeIn = 0x00040010, $I_ModeOff = 0x00050010, $I_IeFlag = 0)
    If StringLeft($I_Image,7) = 'http://' Then
        Local $I_Type = StringSplit($I_Image,'.')
        $I_Type = $I_Type[$I_Type[0]]
        InetGet($I_Image,@ScriptDir & "\I_Image." & $I_Type,1)
        $I_Image = @ScriptDir & "\I_Image." & $I_Type
    EndIf
    _GDIPlus_Startup ()
    Local $I_hImage = _GDIPlus_BitmapCreateFromFile($I_Image)
    Local $I_X = _GDIPlus_ImageGetWidth ($I_hImage)
    Local $I_Y = _GDIPlus_ImageGetHeight ($I_hImage)
    _GDIPlus_ImageDispose($I_hImage)
    _WinAPI_DeleteObject($I_hImage)
    _GDIPlus_ShutDown ()
    Local $I_GUI = GUICreate('',$I_X,$I_Y,-1,-1,$WS_POPUP, $WS_EX_TOPMOST)
    If $I_IeFlag Then
        Local $I_oIE = _IECreateEmbedded ()
        Local $I_GUIActiveX = GUICtrlCreateObj($I_oIE, 0, 0, $I_X, $I_Y)
        _IENavigate ($I_oIE, $I_Image)
    Else
        GUICtrlCreatePic($I_Image,0,0,$I_X,$I_Y)
    EndIf
    _WinAnimate($I_GUI,$I_ModeIn,$I_Speed)
    Sleep($I_Duration)
    _WinAnimate($I_GUI,$I_ModeOff,$I_Speed)
    GUIDelete($I_GUI)
EndFunc

Func _WinAnimate($v_gui, $i_mode, $i_duration = 1000)
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", WinGetHandle($v_gui), "int", $i_duration, "long", $i_mode)
    Local $ai_gle = DllCall('kernel32.dll', 'int', 'GetLastError')
    If $ai_gle[0] <> 0 Then
        SetError(1)
        Return 0
    EndIf
    Return 1
EndFunc ;==> _WinAnimate()