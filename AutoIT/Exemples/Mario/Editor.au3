;Macros
;Start Ziel
#include <File.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
#include <EditConstants.au3>
#include <GuiTab.au3>
#include <ButtonConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <Memory.au3>
#include <WinAPI.au3>

Global Const $STM_SETIMAGE = 0x0172
Global Const $MK_LBUTTON = 0x0001

HotKeySet("{LEFT}", "_Cursor")
HotKeySet("{RIGHT}", "_Cursor")

Opt("GuiOnEventMode", 1)
Opt("GUIResizeMode", BitOR($GUI_DOCKTOP, $GUI_DOCKHEIGHT))

Global $hUser32dll = DllOpen("User32.dll")
_GDIPlus_Startup()

Global $aLevel[20][400][13][11], $aTarget[999][6], $aSubLevel[20][2]
$aTarget[0][0] = 0
For $i = 0 To 19
	$aSubLevel[$i][0] = 1
	$aSubLevel[$i][1] = 1
Next


Global $hGFX_BKG[10], $hGFX_STN[100], $hGFX_TXT[100], $hGFX_SBK[100], $hGFX_MOV[50]
Global $hButtonNavi[20], $hBitmapNavi[20], $hBitmapNaviNumber[20], $aNaviEnabled[20], $aNaviY[20], $aNaviPos[2]
Global $hTabItem[10], $aItem[100][5], $iItem, $iItemX, $iItemY, $bDrawX = False, $hDummyBKG, $hDummySTN, $hDummyITM, $hDummySTN_E, $hDummyITM_E
Global $aSet[2] = [1, 1], $hSettings[5][10]

Global $hGui = GUICreate("Edit", 640, 480, IniRead(@ScriptDir & "\Mario.ini", "Editor", "XPos", -1), IniRead(@ScriptDir & "\Mario.ini", "Editor", "YPos", -1), BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
GUISetState(@SW_SHOW, $hGui)
Global $hGraphicsGui = _GDIPlus_GraphicsCreateFromHWND($hGui)

Global $hGuiNavi = GUICreate("Navigate", 399 * 20 / 10 + 6, 30 + 20, IniRead(@ScriptDir & "\Mario.ini", "Editor", "NaviX", -1), IniRead(@ScriptDir & "\Mario.ini", "Editor", "NaviY", -1), -1, $WS_EX_TOOLWINDOW, $hGui)
GUISetFont(7)
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
$hButtonNavi[0] = GUICtrlCreateCheckbox("Main", 2, 2, 40, 15, $BS_PUSHLIKE)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
For $i = 1 To 19
	$hButtonNavi[$i] = GUICtrlCreateCheckbox("Sub_" & $i, $i * 40 + 2, 2, 40, 15, $BS_PUSHLIKE)
	GUICtrlSetOnEvent(-1, "_NaviButton")
Next
GUISetState(@SW_SHOW, $hGuiNavi)
Global $hGraphicsNavi = _GDIPlus_GraphicsCreateFromHWND($hGuiNavi)
Global $hPenNavi = _GDIPlus_PenCreate(0xFFFF0000, 2)
Global $hPenNaviArrow[20]
Global $hEndCap = _GDIPlus_ArrowCapCreate(4, 6)
For $i = 0 To 19
	$hPenNaviArrow[$i] = _GDIPlus_PenCreate(_Color($i), 2)
	_GDIPlus_PenSetCustomEndCap($hPenNaviArrow[$i], $hEndCap)
Next

_LoadGFX()

Global $hGuiItem = GUICreate("Build", 350, 230, IniRead(@ScriptDir & "\Mario.ini", "Editor", "ItemX", -1), IniRead(@ScriptDir & "\Mario.ini", "Editor", "ItemY", -1), -1, $WS_EX_TOOLWINDOW, $hGui)
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
$hTab = GUICtrlCreateTab(0, 0, 350, 230)
GUICtrlSetOnEvent(-1, "_Test")
$hTabItem[0] = GUICtrlCreateTabItem("Background")
_CreateBackgroundRadio()
$hTabItem[1] = GUICtrlCreateTabItem("Stones")
_CreateStonesRadio()
$hTabItem[2] = GUICtrlCreateTabItem("Items/Enemies")
_CreateItemsRadio()
$hTabItem[3] = GUICtrlCreateTabItem("Macros")
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW, $hGuiItem)


Global $hGuiMenu = GUICreate("Menu", 300, 330, IniRead(@ScriptDir & "\Mario.ini", "Editor", "MenuX", -1), IniRead(@ScriptDir & "\Mario.ini", "Editor", "MenuY", -1), -1, $WS_EX_TOOLWINDOW, $hGui)
GUISetBkColor(0xFFFFFF, $hGuiMenu)
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
GUICtrlCreateGroup("Level", 5, 5, 290, 80)
GUICtrlCreateButton("New", 15, 25, 80, 20)
GUICtrlSetOnEvent(-1, "_LEVELNEW")
GUICtrlCreateButton("Load", 110, 25, 80, 20)
GUICtrlSetOnEvent(-1, "_LEVELLOAD")
GUICtrlCreateButton("Save as", 205, 25, 80, 20)
GUICtrlSetOnEvent(-1, "_Save")
GUICtrlCreateButton("Test Level", 15, 55, 80, 20)
GUICtrlSetOnEvent(-1, "_TestLevel")
GUICtrlCreateButton("Exit", 205, 55, 80, 20)
GUICtrlSetOnEvent(-1, "_Quit")
GUICtrlCreateGroup("Level Settings", 5, 95, 290, 75)
GUICtrlCreateLabel("Background Music:", 20, 115, 100, 20)
Global $hLabelMusic = GUICtrlCreateLabel("Main Level:", 130, 115, 110, 20)
GUICtrlSetFont(-1, 8.5, 800)
Global $hInputMusic = GUICtrlCreateInput("1", 240, 112, 40, 20, $ES_READONLY)
GUICtrlSetOnEvent(-1, "_SETMUSIC")
GUICtrlCreateUpdown($hInputMusic)
GUICtrlSetLimit(-1, 4, 1)
GUICtrlCreateLabel("Level Timeout", 20, 140, 100, 20)
Global $hInputTime = GUICtrlCreateInput("300", 140, 137, 50, 20, $ES_READONLY)
GUICtrlCreateUpdown($hInputTime)
GUICtrlSetLimit(-1, 999, 1)
GUICtrlCreateLabel("Seconds", 200, 140, 80, 20)
GUICtrlCreateGroup("Item Settings", 5, 180, 290, 140)
GUICtrlCreateLabel("Item:", 20, 200, 50, 20)
GUICtrlCreateLabel("X-", 80, 200, 20, 20)
GUICtrlCreateLabel("Y-", 130, 200, 20, 20)
Global $hLabelXPos = GUICtrlCreateLabel("", 100, 200, 30, 20)
GUICtrlSetFont(-1, 8.5, 800)
Global $hLabelYPos = GUICtrlCreateLabel("", 150, 200, 30, 20)
GUICtrlSetFont(-1, 8.5, 800)
GUICtrlCreateLabel("Params:", 20, 293, 80, 20)
Global $hInputParams[7]
$hInputParams[1] = GUICtrlCreateInput("0", 80, 290, 25, 20, $ES_RIGHT)
$hInputParams[2] = GUICtrlCreateInput("0", 115, 290, 25, 20, $ES_RIGHT)
$hInputParams[3] = GUICtrlCreateInput("0", 150, 290, 25, 20, $ES_RIGHT)
$hInputParams[4] = GUICtrlCreateInput("0", 185, 290, 25, 20, $ES_RIGHT)
$hInputParams[5] = GUICtrlCreateInput("0", 220, 290, 25, 20, $ES_RIGHT)
$hInputParams[6] = GUICtrlCreateInput("0", 255, 290, 25, 20, $ES_RIGHT)

$hSettings[1][1] = GUICtrlCreateCheckbox("Mushroom", 80, 220)
GUICtrlSetOnEvent(-1, "_SETMushroom")
$hSettings[1][2] = GUICtrlCreateCheckbox("Star", 80, 240)
GUICtrlSetOnEvent(-1, "_SETStar")
$hSettings[1][3] = GUICtrlCreateLabel("Money", 130, 263)
$hSettings[1][4] = GUICtrlCreateInput("0", 80, 260, 40, 20)
GUICtrlSetOnEvent(-1, "_SETMoney")
$hSettings[1][5] = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 99, 0)
$hSettings[1][0] = 5

GUIStartGroup($hGuiMenu)
$hSettings[2][1] = GUICtrlCreateRadio("UP", 100, 220, 50, 20, $BS_PUSHLIKE)
GUICtrlSetOnEvent(-1, "_SETAufz")
$hSettings[2][2] = GUICtrlCreateRadio("DOWN", 100, 260, 50, 20, $BS_PUSHLIKE)
GUICtrlSetOnEvent(-1, "_SETAufz")
GUIStartGroup($hGuiMenu)
$hSettings[2][3] = GUICtrlCreateRadio("LEFT", 50, 240, 50, 20, $BS_PUSHLIKE)
GUICtrlSetOnEvent(-1, "_SETAufz")
$hSettings[2][4] = GUICtrlCreateRadio("RIGHT", 150, 240, 50, 20, $BS_PUSHLIKE)
GUICtrlSetOnEvent(-1, "_SETAufz")
$hSettings[2][5] = GUICtrlCreateButton("", 100, 240, 50, 20)
GUICtrlSetOnEvent(-1, "_SETAufz")
$hSettings[2][0] = 5

$hSettings[3][1] = GUICtrlCreateCheckbox("Falling down", 100, 230, 150, 20)
GUICtrlSetOnEvent(-1, "_SETFalling")
$hSettings[3][2] = GUICtrlCreateCheckbox("Unvisible", 100, 250, 150, 20)
GUICtrlSetOnEvent(-1, "_SETUnVisible")
$hSettings[3][0] = 2

$hSettings[4][1] = GUICtrlCreateCheckbox("Plant", 100, 230, 100, 20)
GUICtrlSetOnEvent(-1, "_SETPlant")
$hSettings[4][2] = GUICtrlCreateLabel("Set Target:", 30, 253, 70, 20)
$hSettings[4][3] = GUICtrlCreateCombo("", 100, 250, 180, 20)
GUICtrlSetData($hSettings[4][3], "None")
GUICtrlSetOnEvent(-1, "_SETTarget")
$hSettings[4][0] = 3

_ShowSettings(0)

GUISetState(@SW_SHOW, $hGuiMenu)
Global $hBrushWhite = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
Global $hGraphicsMenu = _GDIPlus_GraphicsCreateFromHWND($hGuiMenu)


;GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 2, 0)




For $i = 0 To 19
	$hBitmapNaviNumber[$i] = _GDIPlus_BitmapCreateFromGraphics(24, 24, $hGraphicsNavi)
	$hTempGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmapNaviNumber[$i])
	_DrawString($hTempGraphics, $i, 1, 2, "Arial", 12, 0, 0xFFFFFFFF, 0xFF000000)
	_GDIPlus_GraphicsDispose($hTempGraphics)
	$hBitmapNavi[$i] = _GDIPlus_BitmapCreateFromGraphics(7980, 240, $hGraphicsNavi)
	_NaviCreateBackground($hBitmapNavi[$i], 1)
Next


GUIRegisterMsg($WM_LBUTTONDOWN, "_WM_LBUTTONDOWN")
GUIRegisterMsg($WM_RBUTTONDOWN, "_WM_RBUTTONDOWN")
GUIRegisterMsg($WM_MOUSEWHEEL, "_WM_MOUSEWHEEL")
GUIRegisterMsg($WM_MOUSEMOVE, "_WM_MOUSEMOVE")
GUIRegisterMsg($WM_PAINT, "_WM_PAINT")

_NaviButton()
If $CmdLine[0] = 1 Then
	_LoadLevel(@ScriptDir & "\lvl\" & $CmdLine[1])
EndIf
_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
While 1
	Sleep(100)
WEnd

Func _TestLevel()
	Local $sFile = @ScriptDir & "\lvl\TEST\TEST.LVL"
	DirCreate(@ScriptDir & "\LVL\TEST\")
	Local $hFile = FileOpen($sFile, 2)
	#cs
		GUISetState(@SW_DISABLE, $hGui)
		GUISetState(@SW_DISABLE, $hGuiNavi)
		GUISetState(@SW_DISABLE, $hGuiMenu)
		GUISetState(@SW_DISABLE, $hGuiItem)
		GUIRegisterMsg($WM_LBUTTONDOWN, "")
		GUIRegisterMsg($WM_RBUTTONDOWN, "")
		GUIRegisterMsg($WM_MOUSEWHEEL, "")
		GUIRegisterMsg($WM_MOUSEMOVE, "")
		GUIRegisterMsg($WM_PAINT, "")
	#ce
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}")

	_SaveLevel($hFile)
	FileClose($hFile)
	Select
		Case @Compiled And FileExists(@ScriptDir & "\Mario.exe")
			RunWait(@ScriptDir & '\Mario.exe Debug "' & $sFile & '"', @ScriptDir)
		Case Else
			RunWait(@AutoItExe & " " & @ScriptDir & '\Mario.au3 Debug "' & $sFile & '"', @ScriptDir)
	EndSelect
	FileDelete($sFile)
	DirRemove(@ScriptDir & "\LVL\TEST\")
	#cs
		GUISetState(@SW_ENABLE, $hGui)
		GUISetState(@SW_ENABLE, $hGuiNavi)
		GUISetState(@SW_ENABLE, $hGuiMenu)
		GUISetState(@SW_ENABLE, $hGuiItem)
		GUIRegisterMsg($WM_LBUTTONDOWN, "_WM_LBUTTONDOWN")
		GUIRegisterMsg($WM_RBUTTONDOWN, "_WM_RBUTTONDOWN")
		GUIRegisterMsg($WM_MOUSEWHEEL, "_WM_MOUSEWHEEL")
		GUIRegisterMsg($WM_MOUSEMOVE, "_WM_MOUSEMOVE")
		GUIRegisterMsg($WM_PAINT, "_WM_PAINT")
	#ce
	HotKeySet("{LEFT}", "_Cursor")
	HotKeySet("{RIGHT}", "_Cursor")

EndFunc   ;==>_TestLevel

Func _Quit()
	If MsgBox(4, "Exit", "Exit ?", 5) = 6 Then _EXIT()
EndFunc   ;==>_Quit

Func _Save()
	Local $sFile = FileOpenDialog("Save Level", @ScriptDir & "\LVL\", "(*.lvl)", 11), $hFile
	$hFile = FileOpen($sFile, 2)
	If @error Then
		MsgBox(0, "ERROR " & @error, "Error - saving level", 5)
		Return
	EndIf
	_SaveLevel($hFile)
	FileClose($hFile)
	MsgBox(0, "Ready", $sFile & " saved...", 5)
EndFunc   ;==>_Save


Func _SaveLevel($hFile)
	For $iLVL = 0 To 19
		Switch $iLVL
			Case 0
				FileWriteLine($hFile, "TIME=" & GUICtrlRead($hInputTime))
			Case Else
				FileWriteLine($hFile, "SUBLEVEL=" & $iLVL)
		EndSwitch
		FileWriteLine($hFile, "BACKGROUND=" & $aSubLevel[$iLVL][0])
		FileWriteLine($hFile, "MUSIC=" & $aSubLevel[$iLVL][1])
		For $x = 1 To 399
			For $y = 1 To 12
				If $aLevel[$iLVL][$x][$y][0] Then FileWriteLine($hFile, $aLevel[$iLVL][$x][$y][0] & " " & $x & "-" & $y & " " & String($aLevel[$iLVL][$x][$y][4]) & ";" & String($aLevel[$iLVL][$x][$y][5]) & ";" & String($aLevel[$iLVL][$x][$y][6]) & ";" & String($aLevel[$iLVL][$x][$y][7]) & ";" & String($aLevel[$iLVL][$x][$y][8]) & ";" & String($aLevel[$iLVL][$x][$y][9]))
			Next
		Next
	Next
EndFunc   ;==>_SaveLevel

Func _LEVELLOAD()
	Local $sFile
	$sFile = FileOpenDialog("Load Level", @ScriptDir & "\LVL\", "(*.lvl)", 3)
	If @error Then
		MsgBox(0, "Error " & @error, "Error loading level", 5)
		Return
	EndIf
	_LEVELNEW()
	_LoadLevel($sFile)
EndFunc   ;==>_LEVELLOAD


Func _LoadLevel($sLevelFile)
	Local $aFile, $aLine, $aType, $aCoords, $aParam, $iLVL
	_FileReadToArray($sLevelFile, $aFile)
	If @error Or Not IsArray($aFile) Then Return
	ToolTip("Loading Level " & $sLevelFile & @LF & "Please wait...")
	For $i = 0 To 998
		For $j = 0 To 5
			$aTarget[$i][$j] = 0
		Next
	Next
	For $i = 1 To $aFile[0]
		Select
			Case StringInStr($aFile[$i], "SUBLEVEL")
				$aLine = StringSplit($aFile[$i], "=", 2)
				$iLVL = $aLine[1]
			Case StringInStr($aFile[$i], "BACKGROUND")
				$aParam = StringSplit($aFile[$i], "=", 2)
				If $aParam[1] = 0 Then $aParam[1] += 1
				$aSubLevel[$iLVL][0] = $aParam[1]
			Case StringRegExp($aFile[$i], "[SMB]\-\d+\h\d+\-\d+\h[\-0-9]+;[\-0-9]+;[\-0-9]+;[\-0-9]+;[\-0-9]+")
				$aLine = StringSplit($aFile[$i], " ", 2)
				$aType = StringSplit($aLine[0], "-", 2)
				$aCoords = StringSplit($aLine[1], "-", 2)
				$aParam = StringSplit($aLine[2], ";", 2)
				$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][0] = $aLine[0]
				Switch $aType[0]
					Case "B" ; Set SBK
						$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_SBK[$aType[1] + 1]
					Case "M" ; Set MOV
						;M-1 1-12 0;0;0;0;0;0 Pflanze
						;M-7 2-12 0;0;0;0;0;0 Geld
						;M-3 4-12 0;0;0;0;0;0 WM
						;M-4 5-12 0;0;0;0;0;0 S
						;M-9 6-12 0;0;0;0;0;0 FS
						;M-5 7-12 0;0;0;0;0;0 PF
						;M-5 8-12 0;0;0;0;0;0 PF
						;M-6 10-11 0;0;0;0;0;0 AUFZ
						Switch $aType[1]
							Case 1
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 3]
							Case 2, 3
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 4]
							Case 4
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 6]
							Case 5
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 13]
							Case 6
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 15]
							Case 7
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 20]
							Case 8
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 22]
							Case 9
								$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_MOV[$aType[1] + 22]
						EndSwitch
					Case "S" ; Set STN
						$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_STN[$aType[1] + 1]
						If $aType[1] = 17 Then $aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3] = $hGFX_STN[$aType[1] + 2]
						Switch $aLine[0]
							Case "S-7", "S-8", "S-9", "S-10"
								If $aParam[2] <> 0 And $aParam[3] <> 0 Then _AddTarget($iLVL, $aCoords[0], $aCoords[1], $aParam[1], $aParam[2], $aParam[3])
								_AddTargetCombo($iLVL, $aCoords[0], $aCoords[1])
						EndSwitch
				EndSwitch
				$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][0] = $aLine[0]
				$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][1] = _GDIPlus_ImageGetWidth($aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3])
				$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][2] = _GDIPlus_ImageGetHeight($aLevel[$iLVL][$aCoords[0]][$aCoords[1]][3])
				For $j = 0 To 5
					$aLevel[$iLVL][$aCoords[0]][$aCoords[1]][4 + $j] = $aParam[$j]
				Next
			Case StringInStr($aFile[$i], "MUSIC")
				$aParam = StringSplit($aFile[$i], "=", 2)
				If $aParam[1] = 0 Then $aParam[1] += 1
				$aSubLevel[$iLVL][1] = $aParam[1]
			Case StringInStr($aFile[$i], "TIME")
				$aParam = StringSplit($aFile[$i], "=", 2)
				GUICtrlSetData($hInputTime, $aParam[1])
		EndSelect
	Next
	For $i = 0 To 19
		_NaviCreateBackground($hBitmapNavi[$i], $aSubLevel[$i][0], $i)
	Next
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
	ToolTip("")
EndFunc   ;==>_LoadLevel

Func _LEVELNEW()
	Local $aNew[20][400][13][10]
	$aLevel = $aNew
	For $i = 0 To 19
		$aSubLevel[$i][0] = 1
		$aSubLevel[$i][1] = 1
		_NaviCreateBackground($hBitmapNavi[$i], 1, $i)
	Next
	For $i = 0 To 998
		For $j = 0 To 5
			$aTarget[$i][$j] = 0
		Next
	Next
	GUICtrlSetData($hInputTime, 300)
	GUICtrlSetData($hInputMusic, 1)
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGuiMenu, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
EndFunc   ;==>_LEVELNEW

Func _Color($iIndex)
	Local $sHex = ""
	Switch Mod($iIndex, 6)
		Case 0
			$sHex = "FF0000"
		Case 1
			$sHex = "00FF00"
		Case 2
			$sHex = "0000FF"
		Case 3
			$sHex = "FFFF00"
		Case 4
			$sHex = "FF00FF"
		Case 5
			$sHex = "00FFFF"
	EndSwitch
	Return "0xFF" & $sHex
EndFunc   ;==>_Color

Func _SETMUSIC()
	$aSubLevel[$aNaviPos[0]][1] = GUICtrlRead(@GUI_CtrlId)
EndFunc   ;==>_SETMUSIC


Func _SETTarget(); 0;SubLevel;X;Y
	Local $sTarget = GUICtrlRead(@GUI_CtrlId)
	Local $aTemp = StringSplit($sTarget, "<"), $sLevel = "0", $sX = "1", $sY = "12", $aTemp2
	If UBound($aTemp) <> 5 Then
		_DelTarget($aNaviPos[0], $aSet[0], $aSet[1])
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = "0"
		GUICtrlSetData($hInputParams[2], "0")
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][6] = "0"
		GUICtrlSetData($hInputParams[3], "0")
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][7] = "0"
		GUICtrlSetData($hInputParams[4], "0")
	Else
		$sLevel = StringSplit($aTemp[2], ">", 2)
		$sX = StringSplit($aTemp[3], ">", 2)
		$sY = StringSplit($aTemp[4], ">", 2)
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = $sLevel[0]
		GUICtrlSetData($hInputParams[2], $sLevel[0])
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][6] = $sX[0]
		GUICtrlSetData($hInputParams[3], $sX[0])
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][7] = $sY[0]
		GUICtrlSetData($hInputParams[4], $sY[0])
		_AddTarget($aNaviPos[0], $aSet[0], $aSet[1], $aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5], $aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][6], $aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][7])
	EndIf
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
EndFunc   ;==>_SETTarget

Func _DelTarget($iL, $iX, $iY)
	If $aTarget[0][0] = 1 Then
		$aTarget[0][0] = 0
		Return
	ElseIf $aTarget[0][0] = 0 Then
		Return
	EndIf
	Local $aNew[999][6], $iStep = 0
	For $i = 1 To $aTarget[0][0]
		If $aTarget[$i][0] = $iL And $aTarget[$i][1] = $iX And $aTarget[$i][2] = $iY Then ContinueLoop
		$iStep += 1
		$aNew[$iStep][0] = $aTarget[$i][0]
		$aNew[$iStep][1] = $aTarget[$i][1]
		$aNew[$iStep][2] = $aTarget[$i][2]
		$aNew[$iStep][3] = $aTarget[$i][3]
		$aNew[$iStep][4] = $aTarget[$i][4]
		$aNew[$iStep][5] = $aTarget[$i][5]
	Next
	$aNew[0][0] = $iStep
	$aTarget = $aNew
	;_ArrayDisplay($aTarget)
EndFunc   ;==>_DelTarget

Func _AddTarget($iL, $iX, $iY, $iTL, $iTX, $iTY)
	Local $iIs = False
	For $i = 1 To $aTarget[0][0]
		If $aTarget[$i][0] = $iL And $aTarget[$i][1] = $iX And $aTarget[$i][2] = $iY Then $iIs = $i
	Next
	Switch $iIs
		Case 0
			$aTarget[0][0] += 1
			Local $iI = $aTarget[0][0]
			$aTarget[$iI][0] = $iL
			$aTarget[$iI][1] = $iX
			$aTarget[$iI][2] = $iY
			$aTarget[$iI][3] = $iTL
			$aTarget[$iI][4] = $iTX
			$aTarget[$iI][5] = $iTY
		Case Else
			$aTarget[$iIs][3] = $iTL
			$aTarget[$iIs][4] = $iTX
			$aTarget[$iIs][5] = $iTY
	EndSwitch
	;_ArrayDisplay($aTarget)
EndFunc   ;==>_AddTarget

Func _DelTargetCombo($iL, $iX, $iY)
	Local $iIndex, $sText
	If $iL = 0 Then
		$sText = "MainLevel "
	Else
		$sText = "SubLevel "
	EndIf
	If Not $iL Then $iL = "0"
	$sText &= "<" & $iL & "> - X = <" & $iX & "> Y = <" & $iY & ">"
	$iIndex = _GUICtrlComboBox_FindStringExact($hSettings[4][3], $sText)
	If $iIndex > 0 Then _GUICtrlComboBox_DeleteString($hSettings[4][3], $iIndex)
EndFunc   ;==>_DelTargetCombo

Func _AddTargetCombo($iL, $iX, $iY)
	Local $iIndex, $sText
	If $iL = 0 Then
		$sText = "MainLevel "
	Else
		$sText = "SubLevel "
	EndIf
	If Not $iL Then $iL = "0"
	$sText &= "<" & $iL & "> - X = <" & $iX & "> Y = <" & $iY & ">"
	$iIndex = _GUICtrlComboBox_FindStringExact($hSettings[4][3], $sText)
	If $iIndex < 0 Then _GUICtrlComboBox_AddString($hSettings[4][3], $sText)
EndFunc   ;==>_AddTargetCombo

Func _SetTargetCombo($iL, $iX, $iY)
	Local $iIndex, $sText
	If $iL = 0 Then
		$sText = "MainLevel "
	Else
		$sText = "SubLevel "
	EndIf
	If Not $iL Then $iL = "0"
	$sText &= "<" & $iL & "> - X = <" & $iX & "> Y = <" & $iY & ">"
	$iIndex = _GUICtrlComboBox_FindStringExact($hSettings[4][3], $sText)
	If $iIndex > 0 Then
		_GUICtrlComboBox_SetCurSel($hSettings[4][3], $iIndex)
	Else
		_GUICtrlComboBox_SetCurSel($hSettings[4][3], -1)
	EndIf
EndFunc   ;==>_SetTargetCombo

Func _SETPlant()
	If GUICtrlRead(@GUI_CtrlId) = 1 Then
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = 1
		GUICtrlSetData($hInputParams[1], "1")
	Else
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = 0
		GUICtrlSetData($hInputParams[1], "0")
	EndIf
EndFunc   ;==>_SETPlant

Func _SETUnVisible()
	If GUICtrlRead(@GUI_CtrlId) = 1 Then
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 1
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][0] = "S-17"
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][3] = $hGFX_STN[19]
		GUICtrlSetData($hInputParams[2], "1")
	Else
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 0
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][0] = "5"
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][3] = $hGFX_STN[6]
		GUICtrlSetData($hInputParams[2], "0")
	EndIf
	_SetStone($aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][3], 0, $aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][0], ($aSet[0] - 1) * 20, 240 - $aSet[1] * 20, 20, 20)
EndFunc   ;==>_SETUnVisible

Func _SETFalling()
	If GUICtrlRead(@GUI_CtrlId) = 1 Then
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = 1
		GUICtrlSetData($hInputParams[1], "1")
	Else
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = 0
		GUICtrlSetData($hInputParams[1], "0")
	EndIf
EndFunc   ;==>_SETFalling

Func _SETAufz()
	Switch @GUI_CtrlId
		Case $hSettings[2][1]
			$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = -2
			GUICtrlSetData($hInputParams[2], "-2")
		Case $hSettings[2][2]
			$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 2
			GUICtrlSetData($hInputParams[2], "2")
		Case $hSettings[2][3]
			$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = -2
			GUICtrlSetData($hInputParams[1], "-2")
		Case $hSettings[2][4]
			$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = 2
			GUICtrlSetData($hInputParams[1], "2")
		Case Else
			$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = 0
			$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 0
			GUICtrlSetData($hInputParams[1], "0")
			GUICtrlSetData($hInputParams[2], "0")
			GUICtrlSetState($hSettings[2][1], $GUI_UNCHECKED)
			GUICtrlSetState($hSettings[2][2], $GUI_UNCHECKED)
			GUICtrlSetState($hSettings[2][3], $GUI_UNCHECKED)
			GUICtrlSetState($hSettings[2][4], $GUI_UNCHECKED)
	EndSwitch
EndFunc   ;==>_SETAufz


Func _ShowSettings($iIndex)
	For $i = 1 To 4
		For $j = 1 To $hSettings[$i][0]
			Switch $iIndex
				Case $i
					GUICtrlSetState($hSettings[$i][$j], $GUI_SHOW)
				Case Else
					GUICtrlSetState($hSettings[$i][$j], $GUI_HIDE)
			EndSwitch
		Next
	Next
EndFunc   ;==>_ShowSettings


Func _SETMushroom()
	If GUICtrlRead(@GUI_CtrlId) = 1 Then
		GUICtrlSetState(@GUI_CtrlId + 1, $GUI_UNCHECKED)
		GUICtrlSetData($hInputParams[2], 1)
		GUICtrlSetData($hInputParams[3], 0)
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 1
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][6] = 0
	Else
		GUICtrlSetData($hInputParams[2], 0)
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 0
	EndIf
EndFunc   ;==>_SETMushroom

Func _SETStar()
	If GUICtrlRead(@GUI_CtrlId) = 1 Then
		GUICtrlSetState(@GUI_CtrlId - 1, $GUI_UNCHECKED)
		GUICtrlSetData($hInputParams[3], 1)
		GUICtrlSetData($hInputParams[2], 0)
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][6] = 1
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][5] = 0
	Else
		GUICtrlSetData($hInputParams[3], 0)
		$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][6] = 0
	EndIf
EndFunc   ;==>_SETStar

Func _SETMoney()
	Local $iMoney = GUICtrlRead(@GUI_CtrlId)
	GUICtrlSetData($hInputParams[1], $iMoney)
	$aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][4] = $iMoney
EndFunc   ;==>_SETMoney

Func _Test()
	Local $iTab = _GUICtrlTab_GetCurSel(GUICtrlGetHandle(@GUI_CtrlId))
	Switch $iTab
		Case 1
			For $i = $hDummySTN To $hDummySTN_E
				If GUICtrlRead($i) = $GUI_CHECKED Then
					$iItem = $i
					Switch $aItem[$iItem][4]
						Case "S-4", "S-3", "S-16"
							_ShowSettings(1)
						Case "M-6"
							_ShowSettings(2)
						Case "S-5", "S-17"
							_ShowSettings(3)
						Case "S-7", "S-8", "S-9", "S-10"
							_ShowSettings(4)
						Case Else
							_ShowSettings(0)
					EndSwitch
					Return
				EndIf
			Next
		Case 2
			For $i = $hDummyITM To $hDummyITM_E
				If GUICtrlRead($i) = $GUI_CHECKED Then
					$iItem = $i
					Switch $aItem[$iItem][4]
						Case "S-4", "S-3", "S-16"
							_ShowSettings(1)
						Case "M-6"
							_ShowSettings(2)
						Case "S-5", "S-17"
							_ShowSettings(3)
						Case "S-7", "S-8", "S-9", "S-10"
							_ShowSettings(4)
						Case Else
							_ShowSettings(0)
					EndSwitch
					Return
				EndIf
			Next
	EndSwitch
EndFunc   ;==>_Test

Func _CreateBackgroundRadio()
	$hDummyBKG = GUICtrlCreateDummy()
	_CreateRadio(15, 40, 100, 75, $hGFX_BKG[1], -1)
	GUICtrlSetOnEvent(-1, "_SelectBackground")
	_CreateRadio(125, 40, 100, 75, $hGFX_BKG[3], -1)
	GUICtrlSetOnEvent(-1, "_SelectBackground")
	_CreateRadio(235, 40, 100, 75, $hGFX_BKG[5], -1)
	GUICtrlSetOnEvent(-1, "_SelectBackground")
	_CreateRadio(15, 125, 100, 75, 0, -1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_CreateRadio(125, 125, 100, 75, 0, -1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_CreateRadio(235, 125, 100, 75, 0, -1)
	GUICtrlSetState(-1, $GUI_DISABLE)
EndFunc   ;==>_CreateBackgroundRadio

Func _CreateItemsRadio()
	$hDummyITM = GUICtrlCreateDummy()
	_CreateRadio(15, 35, 25, 25, $hGFX_MOV[4], 0, "M-1") ; Löschen
	_CreateRadio(55, 35, 25, 25, $hGFX_MOV[27], 0, "M-7") ; Boden
	_CreateRadio(15, 95, 25, 25, $hGFX_MOV[6], 0, "M-3")
	_CreateRadio(55, 85, 25, 35, $hGFX_MOV[9], 0, "M-4")
	_CreateRadio(95, 85, 25, 35, $hGFX_MOV[31], 0, "M-9")
	_CreateRadio(135, 85, 25, 35, $hGFX_MOV[17], 0, "M-5")
	_CreateRadio(175, 85, 25, 35, $hGFX_MOV[19], 0, "M-5")
	_CreateRadio(15, 165, 55, 25, $hGFX_MOV[21], 0, "M-6")
	_CreateRadio(85, 145, 25, 45, $hGFX_STN[14], 0, "S-13")
	$hDummyITM_E = GUICtrlCreateDummy()
EndFunc   ;==>_CreateItemsRadio


Func _CreateStonesRadio()
	$hDummySTN = GUICtrlCreateDummy()
	_CreateRadio(10, 35, 25, 25, $hGFX_TXT[2]) ; Löschen
	_CreateRadio(45, 35, 25, 25, $hGFX_STN[1], 0, "S-0") ; Boden
	_CreateRadio(70, 35, 25, 25, $hGFX_STN[2], 0, "S-1")
	_CreateRadio(95, 35, 25, 25, $hGFX_STN[3], 0, "S-2")

	_CreateRadio(130, 35, 25, 25, $hGFX_STN[4], 1, "S-3")
	_CreateRadio(165, 35, 25, 25, $hGFX_STN[17], 1, "S-16")
	_CreateRadio(200, 35, 25, 25, $hGFX_STN[5], 1, "S-4")
	_CreateRadio(235, 35, 25, 25, $hGFX_STN[6], 0, "S-5")
	_CreateRadio(270, 35, 25, 25, $hGFX_STN[7], 0, "S-6")
	_CreateRadio(305, 35, 25, 25, $hGFX_STN[26], 0, "S-25")

	_CreateRadio(10, 70, 45, 25, $hGFX_STN[8], 2, "S-7") ; Rohr Vertikal
	_CreateRadio(10, 95, 45, 25, $hGFX_STN[12], 0, "S-11")
	_CreateRadio(10, 120, 45, 25, $hGFX_STN[9], 2, "S-8")

	_CreateRadio(65, 80, 25, 45, $hGFX_STN[10], 2, "S-9") ; Rohr Horizontal
	_CreateRadio(90, 80, 25, 45, $hGFX_STN[13], 0, "S-12")
	_CreateRadio(115, 80, 25, 45, $hGFX_STN[11], 2, "S-10")

	_CreateRadio(150, 70, 25, 25, $hGFX_STN[20], 0, "S-19")
	_CreateRadio(175, 70, 25, 25, $hGFX_STN[21], 0, "S-20")
	_CreateRadio(200, 70, 25, 25, $hGFX_STN[22], 0, "S-21")
	_CreateRadio(150, 95, 25, 25, $hGFX_SBK[19], 0, "B-18")
	_CreateRadio(175, 95, 25, 25, $hGFX_SBK[21], 0, "B-20")
	_CreateRadio(200, 95, 25, 25, $hGFX_SBK[20], 0, "B-19")
	_CreateRadio(150, 120, 25, 25, $hGFX_SBK[22], 0, "B-21")
	_CreateRadio(200, 120, 25, 25, $hGFX_SBK[23], 0, "B-22")

	_CreateRadio(235, 70, 25, 25, $hGFX_STN[23], 0, "S-22")
	_CreateRadio(260, 70, 25, 25, $hGFX_STN[24], 0, "S-23")
	_CreateRadio(285, 70, 25, 25, $hGFX_STN[25], 0, "S-24")
	_CreateRadio(260, 95, 25, 25, $hGFX_SBK[24], 0, "B-23")
	_CreateRadio(235, 120, 25, 25, $hGFX_SBK[25], 0, "B-24")
	_CreateRadio(260, 120, 25, 25, $hGFX_SBK[26], 0, "B-25")
	_CreateRadio(285, 120, 25, 25, $hGFX_SBK[27], 0, "B-26")

	For $i = 0 To 9
		_CreateRadio(10 + $i * 25, 190, 25, 25, $hGFX_SBK[$i + 1], 0, "B-" & $i)
	Next
	For $i = 0 To 6
		_CreateRadio(10 + $i * 25, 155, 25, 25, $hGFX_SBK[$i + 11], 0, "B-" & $i + 10)
	Next
	_CreateRadio(210, 155, 25, 25, $hGFX_SBK[18], 0, "B-17")
	_CreateRadio(235, 155, 25, 25, $hGFX_MOV[30], 0, "M-8")
	_CreateRadio(260, 155, 25, 25, $hGFX_STN[16], 0, "S-15")
	_CreateRadio(285, 155, 25, 25, $hGFX_STN[15], 0, "S-14")
	$hDummySTN_E = GUICtrlCreateDummy()
EndFunc   ;==>_CreateStonesRadio

Func _CreateRadio($iX, $iY, $iW, $iH, $hBitmap, $iEdit = 0, $sItem = "X-0")
	Local $iID = GUICtrlCreateRadio("", $iX, $iY, $iW, $iH, BitOR($BS_BITMAP, $BS_PUSHLIKE))
	_SetCtrlBitmap(-1, $hBitmap, $iW - 5, $iH - 5)
	If $iEdit >= 0 Then
		GUICtrlSetOnEvent(-1, "_SelectStone")
		$aItem[$iID][0] = $hBitmap
		$aItem[$iID][1] = $iEdit
		$aItem[$iID][2] = _GDIPlus_ImageGetWidth($hBitmap)
		$aItem[$iID][3] = _GDIPlus_ImageGetHeight($hBitmap)
		$aItem[$iID][4] = $sItem
	EndIf
EndFunc   ;==>_CreateRadio

Func _SelectBackground()
	$aSubLevel[$aNaviPos[0]][0] = (@GUI_CtrlId - $hDummyBKG - 1) * 2 + 1
	_NaviCreateBackground($hBitmapNavi[$aNaviPos[0]], (@GUI_CtrlId - $hDummyBKG - 1) * 2 + 1, $aNaviPos[0])
	_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
EndFunc   ;==>_SelectBackground

Func _SelectStone()
	$iItem = @GUI_CtrlId
	Switch $aItem[$iItem][4]
		Case "S-4", "S-3", "S-16"
			_ShowSettings(1)
		Case "M-6"
			_ShowSettings(2)
		Case "S-5", "S-17"
			_ShowSettings(3)
		Case "S-7", "S-8", "S-9", "S-10"
			_ShowSettings(4)
		Case Else
			_ShowSettings(0)
	EndSwitch
EndFunc   ;==>_SelectStone

Func _SetCtrlBitmap($hCtrlID, $hBitmap, $iW = 50, $iH = 50)
	Local $hOldBmp, $hBmp, $hTempBitmap, $hTempGraphics
	$hTempGraphics = _GDIPlus_GraphicsCreateFromHWND($hGuiItem)
	$hTempBitmap = _GDIPlus_BitmapCreateFromGraphics($iW, $iH, $hTempGraphics)
	_GDIPlus_GraphicsDispose($hTempGraphics)
	$hTempGraphics = _GDIPlus_ImageGetGraphicsContext($hTempBitmap)
	_GDIPlus_GraphicsDrawImageRect($hTempGraphics, $hBitmap, 0, 0, $iW, $iH)
	_GDIPlus_GraphicsDispose($hTempGraphics)
	$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hTempBitmap)
	_GDIPlus_BitmapDispose($hTempBitmap)
	$hOldBmp = GUICtrlSendMsg($hCtrlID, $BM_SETIMAGE, 0, $hBmp)
	If $hOldBmp Then _WinAPI_DeleteObject($hOldBmp)
EndFunc   ;==>_SetCtrlBitmap

Func _NaviCreateBackground($hBitmap, $iIndex, $iI = 0)
	Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	For $i = 0 To 12
		_GDIPlus_GraphicsDrawImage($hGraphics, $hGFX_BKG[$iIndex], $i * 640, 0)
		_GDIPlus_GraphicsDrawImage($hGraphics, $hGFX_BKG[$iIndex + 1], $i * 640 + 320, 0)
	Next
	For $x = 1 To 399
		For $y = 1 To 12
			If Not $aLevel[$iI][$x][$y][0] Then ContinueLoop
			_DrawStone($iI, $x, $y)
		Next
	Next
	_GDIPlus_GraphicsDispose($hGraphics)
EndFunc   ;==>_NaviCreateBackground

Func _LoadGFX()
	For $i = 1 To 6
		$hGFX_BKG[$i] = _ResourceLoadImage("GFX.dat", "BKG" & $i)
	Next
	For $i = 1 To 30
		$hGFX_STN[$i] = _ResourceLoadImage("GFX.dat", "STN" & $i)
	Next
	For $i = 1 To 30
		$hGFX_SBK[$i] = _ResourceLoadImage("GFX.dat", "SBK" & $i)
	Next
	For $i = 1 To 10
		$hGFX_TXT[$i] = _ResourceLoadImage("GFX.dat", "TXT" & $i)
	Next
	For $i = 1 To 35
		$hGFX_MOV[$i] = _ResourceLoadImage("GFX.dat", "MOV" & $i)
	Next
EndFunc   ;==>_LoadGFX

Func _Cursor()
	Local $wParam = 0, $iDir = 0
	Switch @HotKeyPressed
		Case "{LEFT}"
			$iDir = 1
		Case "{RIGHT}"
			$iDir = -1
	EndSwitch
	If _IsPressed("01", $hUser32dll) Then
		$wParam = _WinAPI_MakeLong($MK_LBUTTON, $iDir)
	Else
		$wParam = _WinAPI_MakeLong(0, $iDir)
	EndIf
	_WM_MOUSEWHEEL($hGui, 0, $wParam, 0)
EndFunc   ;==>_Cursor

Func _WM_MOUSEWHEEL($hWnd, $Msg, $wParam, $lParam)
	Local $iStep = -2
	If BitShift($wParam, 16) < 0 Then $iStep = 2
	$aNaviPos[1] += $iStep
	If $aNaviPos[1] < 0 Then
		$aNaviPos[1] = 0
		Return
	EndIf
	If $aNaviPos[1] > 766 Then
		$aNaviPos[1] = 766
		Return
	EndIf
	If BitAND(BitAND($wParam, 0xFFFF), $MK_LBUTTON) Then
		ConsoleWrite("Set " & Random(0, 9, 1) & @LF)
		$iItemX += $iStep * 10
		_SetStone($aItem[$iItem][0], $aItem[$iItem][1], $aItem[$iItem][4], $iItemX, $iItemY, $aItem[$iItem][2], $aItem[$iItem][3])
	EndIf
	_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
EndFunc   ;==>_WM_MOUSEWHEEL

Func _WM_MOUSEMOVE($hWnd, $Msg, $wParam, $lParam)
	Switch $hWnd
		Case $hGui
			GUISetCursor(3, 1, $hGui)
			;ConsoleWrite($aItem[$iItem][3] & @LF)
			Local $iX = Floor((BitAND($lParam, 0xFFFF) + $aNaviPos[1] * 20) / 40) * 20, $iY = Floor(BitShift($lParam, 16) / 40) * 20, $iOff = 0
			If $aItem[$iItem][3] = 30 Then $iOff = -10
			If $iX <> $iItemX Or $iY <> $iItemY Then
				_GDIPlus_GraphicsDrawImageRectRect($hGraphicsGui, $hBitmapNavi[$aNaviPos[0]], $aNaviPos[1] * 10, 0, 320, 240, 0, 0, 640, 480)
				_GDIPlus_GraphicsDrawRect($hGraphicsGui, ($aSet[0] - 1) * 40 - $aNaviPos[1] * 20 - 2, 480 - ($aSet[1] * 40) - 2, 43, 43, $hPenNavi)
				_GDIPlus_GraphicsDrawImageRect($hGraphicsGui, $aItem[$iItem][0], $iX * 2 - $aNaviPos[1] * 20, $iY * 2 + $iOff * 2, $aItem[$iItem][2] * 2, $aItem[$iItem][3] * 2)
				$iItemX = $iX
				$iItemY = $iY
				If $iItem And BitAND($wParam, $MK_LBUTTON) Then _SetStone($aItem[$iItem][0], $aItem[$iItem][1], $aItem[$iItem][4], $iItemX, $iItemY, $aItem[$iItem][2], $aItem[$iItem][3])
			EndIf
		Case $hGuiNavi
			If BitAND($wParam, $MK_LBUTTON) Then
				$aNaviPos[1] = BitAND($lParam, 0xFFFF) - 16
				If $aNaviPos[1] < 0 Then $aNaviPos[1] = 0
				If $aNaviPos[1] > 766 Then $aNaviPos[1] = 766
				Local $iMouseY = BitShift($lParam, 16)
				If $iMouseY < $aNaviY[$aNaviPos[0]] - 10 Or $iMouseY > $aNaviY[$aNaviPos[0]] + 34 Then
					For $i = 0 To 19
						If Not $aNaviEnabled[$i] Then ContinueLoop
						If $iMouseY > $aNaviY[$i] And $iMouseY < $aNaviY[$i] + 24 Then
							If $i <> $aNaviPos[0] Then
								If $i = 0 Then
									GUICtrlSetData($hLabelMusic, "MainLevel")
								Else
									GUICtrlSetData($hLabelMusic, "SubLevel " & $i)
								EndIf
								GUICtrlSetData($hInputMusic, $aSubLevel[$i][1])
							EndIf
							$aNaviPos[0] = $i
						EndIf
					Next
				EndIf
				_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
				_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_MOUSEMOVE

Func _SetStone($hBitmap, $iEdit, $sItem, $iX, $iY, $iW, $iH)
	Local $hTempGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmapNavi[$aNaviPos[0]])
	Switch $sItem
		Case "X-0" ;löschen
			Switch $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][0]
				Case "S-7", "S-8", "S-9", "S-10"
					_DelTargetCombo($aNaviPos[0], $iX / 20 + 1, 12 - $iY / 20)
					_DelTarget($aNaviPos[0], $iX / 20 + 1, 12 - $iY / 20)
			EndSwitch
			$aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][0] = False
			Local $iXOFF = Mod($iX, 320), $iBmp = Mod($iX, 640), $iWW = 20, $iHH = 20
			If Mod($iX, 640) < 320 Then
				$iBmp = 0
			Else
				$iBmp = 1
			EndIf
			If $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][1] > 20 Then $iWW = $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][1]
			If $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][2] > 20 Then $iHH = $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][2]
			_GDIPlus_GraphicsDrawImageRectRect($hTempGraphics, $hGFX_BKG[1 + $iBmp], $iXOFF, $iY, $iWW, $iHH, $iX, $iY, $iWW, $iHH)
			$bDrawX = True
			If $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][1] > 20 Then _DrawStone($aNaviPos[0], $iX / 20 + 2, 12 - $iY / 20)
			If $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][2] > 20 Then _DrawStone($aNaviPos[0], $iX / 20 + 1, 12 - $iY / 20 + 1)
			_DrawStone($aNaviPos[0], $iX / 20, 12 - $iY / 20)
			_DrawStone($aNaviPos[0], $iX / 20 + 1, 12 - $iY / 20 - 1)
		Case Else
			$aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][0] = $sItem
			$aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][1] = $iW
			$aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][2] = $iH
			$aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][3] = $hBitmap
			Local $iXOFF = Mod($iX, 320), $iBmp = Mod($iX, 640), $iWW = 20, $iHH = 20
			If Mod($iX, 640) < 320 Then
				$iBmp = 0
			Else
				$iBmp = 1
			EndIf
			If $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][1] > 20 Then $iWW = $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][1]
			If $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][2] > 20 Then $iHH = $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][2]
			_GDIPlus_GraphicsDrawImageRectRect($hTempGraphics, $hGFX_BKG[1 + $iBmp], $iXOFF, $iY, $iWW, $iHH, $iX, $iY, $iWW, $iHH)
			_GDIPlus_GraphicsDrawImageRect($hTempGraphics, $hBitmap, $iX, $iY, $iW, $iH)
			$aSet[0] = Floor($iX / 20 + 1)
			$aSet[1] = Floor(12 - $iY / 20)
			GUICtrlSetData($hLabelXPos, $aSet[0])
			GUICtrlSetData($hLabelYPos, $aSet[1])
			If Not $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4] Then $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4] = "0"
			If Not $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5] Then $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5] = "0"
			If Not $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6] Then $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6] = "0"
			If Not $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][7] Then $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][7] = "0"
			If Not $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][8] Then $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][8] = "0"
			If Not $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][9] Then $aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][9] = "0"
			GUICtrlSetData($hInputParams[1], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]))
			GUICtrlSetData($hInputParams[2], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]))
			GUICtrlSetData($hInputParams[3], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6]))
			GUICtrlSetData($hInputParams[4], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][7]))
			GUICtrlSetData($hInputParams[5], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][8]))
			GUICtrlSetData($hInputParams[6], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][9]))
			Switch $sItem
				Case "S-4", "S-3", "S-16" ;Fragezeichen
					;_ShowSettings(1)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) Then
						GUICtrlSetState($hSettings[1][1], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[1][1], $GUI_UNCHECKED)
					EndIf
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6]) Then
						GUICtrlSetState($hSettings[1][2], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[1][2], $GUI_UNCHECKED)
					EndIf
					GUICtrlSetData($hSettings[1][4], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]))
				Case "M-6"
					GUICtrlSetState($hSettings[2][1], $GUI_UNCHECKED)
					GUICtrlSetState($hSettings[2][2], $GUI_UNCHECKED)
					GUICtrlSetState($hSettings[2][3], $GUI_UNCHECKED)
					GUICtrlSetState($hSettings[2][4], $GUI_UNCHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) < 0 Then GUICtrlSetState($hSettings[2][1], $GUI_CHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) > 0 Then GUICtrlSetState($hSettings[2][2], $GUI_CHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) < 0 Then GUICtrlSetState($hSettings[2][3], $GUI_CHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) > 0 Then GUICtrlSetState($hSettings[2][4], $GUI_CHECKED)
				Case "S-5", "S-17"
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) Then
						GUICtrlSetState($hSettings[3][1], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[3][1], $GUI_UNCHECKED)
					EndIf
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) Then
						GUICtrlSetState($hSettings[3][2], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[3][2], $GUI_UNCHECKED)
					EndIf
				Case "S-7", "S-8", "S-9", "S-10"
					_AddTargetCombo($aNaviPos[0], $iX / 20 + 1, 12 - $iY / 20)
					_SetTargetCombo(Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]), Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6]), Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][7]))
					;_GUICtrlComboBox_SetCurSel ($hSettings[4][3],0)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) Then
						GUICtrlSetState($hSettings[4][1], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[4][1], $GUI_UNCHECKED)
					EndIf
				Case Else
					;_ShowSettings(0)
			EndSwitch
	EndSwitch
	_GDIPlus_GraphicsDispose($hTempGraphics)
	_WinAPI_RedrawWindow($hGuiMenu, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
	_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
EndFunc   ;==>_SetStone

Func _DrawStone($iLVL, $iX, $iY)
	If Not $iLVL Then $iLVL = 0
	If Not $aLevel[$iLVL][$iX][$iY][0] Then Return
	Local $hTempGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmapNavi[$iLVL]), $iOff = 0
	If $aLevel[$iLVL][$iX][$iY][2] = 30 Then $iOff = -10
	_GDIPlus_GraphicsDrawImageRect($hTempGraphics, $aLevel[$iLVL][$iX][$iY][3], ($iX - 1) * 20, 240 - ($iY * 20) + $iOff, $aLevel[$iLVL][$iX][$iY][1], $aLevel[$iLVL][$iX][$iY][2])
	_GDIPlus_GraphicsDispose($hTempGraphics)
EndFunc   ;==>_DrawStone


Func _WM_RBUTTONDOWN($hWnd, $Msg, $wParam, $lParam)
	;Hier muß noch position berechnet werden!
	Local $iX = $iItemX, $iY = $iItemY
	Switch $hWnd
		Case $hGui
			;ConsoleWrite($aLevel[$aNaviPos[0]][$iItemX / 20 + 1][12 - $iItemY / 20][0] & @LF)
			Switch $aLevel[$aNaviPos[0]][$iItemX / 20 + 1][12 - $iItemY / 20][0]
				Case "S-4", "S-3", "S-16"
					_ShowSettings(1)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) Then
						GUICtrlSetState($hSettings[1][1], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[1][1], $GUI_UNCHECKED)
					EndIf
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6]) Then
						GUICtrlSetState($hSettings[1][2], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[1][2], $GUI_UNCHECKED)
					EndIf
					GUICtrlSetData($hSettings[1][4], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]))
				Case "M-6"
					_ShowSettings(2)
					GUICtrlSetState($hSettings[2][1], $GUI_UNCHECKED)
					GUICtrlSetState($hSettings[2][2], $GUI_UNCHECKED)
					GUICtrlSetState($hSettings[2][3], $GUI_UNCHECKED)
					GUICtrlSetState($hSettings[2][4], $GUI_UNCHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) < 0 Then GUICtrlSetState($hSettings[2][1], $GUI_CHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) > 0 Then GUICtrlSetState($hSettings[2][2], $GUI_CHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) < 0 Then GUICtrlSetState($hSettings[2][3], $GUI_CHECKED)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) > 0 Then GUICtrlSetState($hSettings[2][4], $GUI_CHECKED)
				Case "S-5", "S-17"
					_ShowSettings(3)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) Then
						GUICtrlSetState($hSettings[3][1], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[3][1], $GUI_UNCHECKED)
					EndIf
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]) Then
						GUICtrlSetState($hSettings[3][2], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[3][2], $GUI_UNCHECKED)
					EndIf
				Case "S-7", "S-8", "S-9", "S-10"
					_ShowSettings(4)
					_SetTargetCombo(Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]), Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6]), Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][7]))
					;_GUICtrlComboBox_SetCurSel ($hSettings[4][3],0)
					If Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]) Then
						GUICtrlSetState($hSettings[4][1], $GUI_CHECKED)
					Else
						GUICtrlSetState($hSettings[4][1], $GUI_UNCHECKED)
					EndIf
				Case Else
					_ShowSettings(0)
			EndSwitch
			$aSet[0] = Floor($iX / 20 + 1)
			$aSet[1] = Floor(12 - $iY / 20)
			GUICtrlSetData($hLabelXPos, $aSet[0])
			GUICtrlSetData($hLabelYPos, $aSet[1])
			GUICtrlSetData($hInputParams[1], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][4]))
			GUICtrlSetData($hInputParams[2], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][5]))
			GUICtrlSetData($hInputParams[3], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][6]))
			GUICtrlSetData($hInputParams[4], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][7]))
			GUICtrlSetData($hInputParams[5], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][8]))
			GUICtrlSetData($hInputParams[6], Int($aLevel[$aNaviPos[0]][$iX / 20 + 1][12 - $iY / 20][9]))
			_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_RBUTTONDOWN

Func _WM_LBUTTONDOWN($hWnd, $Msg, $wParam, $lParam)
	Switch $hWnd
		Case $hGui
			If $iItem Then
				Local $iOff = 0
				If $aItem[$iItem][3] = 30 Then $iOff = -10
				_SetStone($aItem[$iItem][0], $aItem[$iItem][1], $aItem[$iItem][4], $iItemX, $iItemY + $iOff, $aItem[$iItem][2], $aItem[$iItem][3])
			EndIf
		Case $hGuiNavi
			If BitShift($lParam, 16) > 20 Then
				$aNaviPos[1] = BitAND($lParam, 0xFFFF) - 16
				If $aNaviPos[1] < 0 Then $aNaviPos[1] = 0
				If $aNaviPos[1] > 766 Then $aNaviPos[1] = 766
				Local $iMouseY = BitShift($lParam, 16)
				If $iMouseY < $aNaviY[$aNaviPos[0]] - 10 Or $iMouseY > $aNaviY[$aNaviPos[0]] + 34 Then
					For $i = 0 To 19
						If Not $aNaviEnabled[$i] Then ContinueLoop
						If $iMouseY > $aNaviY[$i] And $iMouseY < $aNaviY[$i] + 24 Then $aNaviPos[0] = $i
					Next
				EndIf
				_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
				_WinAPI_RedrawWindow($hGui, 0, 0, $RDW_INTERNALPAINT)
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_LBUTTONDOWN

Func _GDIPlus_GraphicsDrawLine_($hGraphics, $iX1, $iY1, $iX2, $iY2, $hPen = 0)
	$aResult = DllCall($ghGDIPDll, "int", "GdipDrawLineI", "hwnd", $hGraphics, "hwnd", $hPen, "int", $iX1, "int", $iY1, "int", $iX2, "int", $iY2)
EndFunc   ;==>_GDIPlus_GraphicsDrawLine_

Func _WM_PAINT($hWnd, $Msg, $wParam, $lParam)
	;ConsoleWrite("PAINT " & $hWnd & @LF)
	Switch $hWnd
		Case $hGui
			_GDIPlus_GraphicsDrawImageRectRect($hGraphicsGui, $hBitmapNavi[$aNaviPos[0]], $aNaviPos[1] * 10, 0, 320, 240, 0, 0, 640, 480)
			_GDIPlus_GraphicsDrawRect($hGraphicsGui, ($aSet[0] - 1) * 40 - $aNaviPos[1] * 20 - 2, 480 - ($aSet[1] * 40) - 2, 43, 43, $hPenNavi)
			If $bDrawX Then _GDIPlus_GraphicsDrawImageRect($hGraphicsGui, $hGFX_TXT[2], $iItemX * 2 - $aNaviPos[1] * 20, $iItemY * 2, 40, 40)
			$bDrawX = False
		Case $hGuiNavi
			;Local $aPos[20]
			For $i = 0 To 19
				If $aNaviEnabled[$i] Then
					_GDIPlus_GraphicsDrawRect($hGraphicsNavi, 2, $aNaviY[$i] - 1, 799, 25)
					_GDIPlus_GraphicsDrawImageRect($hGraphicsNavi, $hBitmapNavi[$i], 3, $aNaviY[$i], 798, 24)
					_GDIPlus_GraphicsDrawImage($hGraphicsNavi, $hBitmapNaviNumber[$i], 3, $aNaviY[$i])
				EndIf
				If $aNaviPos[0] = $i Then _GDIPlus_GraphicsDrawRect($hGraphicsNavi, $aNaviPos[1] + 3, $aNaviY[$i], 32, 24, $hPenNavi)
				;EndIf
			Next
			For $j = 1 To $aTarget[0][0]
				If $aNaviEnabled[$aTarget[$j][0]] And $aNaviEnabled[$aTarget[$j][3]] Then _GDIPlus_GraphicsDrawLine_($hGraphicsNavi, 3 + $aTarget[$j][1] * 2, $aNaviY[$aTarget[$j][0]] + 24 - $aTarget[$j][2] * 2, 3 + $aTarget[$j][4] * 2, $aNaviY[$aTarget[$j][3]] + 24 - $aTarget[$j][5] * 2, $hPenNaviArrow[$aTarget[$j][0]])
			Next
		Case $hGuiMenu
			If Not $aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][0] Then Return $GUI_RUNDEFMSG
			_GDIPlus_GraphicsFillRect($hGraphicsMenu, 240, 200, 40, 40, $hBrushWhite)
			_GDIPlus_GraphicsDrawImage($hGraphicsMenu, $aLevel[$aNaviPos[0]][$aSet[0]][$aSet[1]][3], 240, 200)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_PAINT


Func _NaviButton()
	Local $iCnt = 0, $aPos, $aClnt
	For $i = 0 To 19
		If GUICtrlRead($hButtonNavi[$i]) = 1 Then
			$aNaviEnabled[$i] = True
			$aNaviY[$i] = $iCnt * 30 + 22
			$iCnt += 1
		Else
			$aNaviEnabled[$i] = False
		EndIf
	Next
	$aPos = WinGetPos($hGuiNavi)
	$aClnt = WinGetClientSize($hGuiNavi)
	WinMove($hGuiNavi, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3] - $aClnt[1] + $iCnt * 30 + 20)
	_GDIPlus_GraphicsDispose($hGraphicsNavi)
	$hGraphicsNavi = _GDIPlus_GraphicsCreateFromHWND($hGuiNavi)
	_WinAPI_RedrawWindow($hGuiNavi, 0, 0, $RDW_INTERNALPAINT)
EndFunc   ;==>_NaviButton

Func _DrawString($hGraphics, $sString, $nX, $nY, $sFont = "Arial", $nSize = 10, $iFormat = 0, $iColor = 0xFFFFFFFF, $iColorBk = 0xFF000000)
	Local $hBrush, $iError, $hFamily, $hFont, $hFormat, $aInfo, $tLayout, $bResult

	$hBrush = _GDIPlus_BrushCreateSolid($iColor)
	$hBrushBk = _GDIPlus_BrushCreateSolid($iColorBk)
	$hFormat = _GDIPlus_StringFormatCreate($iFormat)
	$hFamily = _GDIPlus_FontFamilyCreate($sFont)
	$hFont = _GDIPlus_FontCreate($hFamily, $nSize)
	For $i = -1 To 1
		For $j = -1 To 1
			If $i = $j Then ContinueLoop
			$tLayout = _GDIPlus_RectFCreate($nX + $i, $nY + $j, 0, 0)
			$aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
			_GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrushBk)
		Next
	Next
	$tLayout = _GDIPlus_RectFCreate($nX, $nY, 0, 0)
	$aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	$bResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	$iError = @error
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	Return SetError($iError, 0, $bResult)
EndFunc   ;==>_DrawString

Func _ResourceLoadImage($DLL, $ResName); THX to Progandy, Zedna
	Local $hInstance, $InfoBlock, $GlobalMemoryBlock, $MemoryPointer, $ResSize, $hData, $pData, $pStream, $dll2, $pBitmap
	$hInstance = DllCall("kernel32.dll", "int", "LoadLibrary", "str", $DLL)
	$InfoBlock = DllCall("kernel32.dll", "int", "FindResourceA", "int", $hInstance[0], "str", $ResName, "long", 10)
	$ResSize = DllCall("kernel32.dll", "dword", "SizeofResource", "int", $hInstance[0], "int", $InfoBlock[0])
	$GlobalMemoryBlock = DllCall("kernel32.dll", "int", "LoadResource", "int", $hInstance[0], "int", $InfoBlock[0])
	$MemoryPointer = DllCall("kernel32.dll", "int", "LockResource", "int", $GlobalMemoryBlock[0])
	DllCall("Kernel32.dll", "int", "FreeLibrary", "str", $hInstance[0])
	$hData = _MemGlobalAlloc($ResSize[0], 2)
	$pData = _MemGlobalLock($hData)
	_MemMoveMemory($MemoryPointer[0], $pData, $ResSize[0])
	_MemGlobalUnlock($hData)
	$pStream = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "int", $hData, "long", 1, "Int*", 0)
	$pBitmap = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream[3], "int*", 0)
	$DLL = DllStructCreate("Uint", $pStream[3])
	$dll2 = DllStructCreate("uInt", DllStructGetData($DLL, 1) + 8)
	DllCall("", "UInt", DllStructGetData($dll2, 1), "UInt", $pStream[3])
	_WinAPI_DeleteObject($pStream[3])
	$pStream[3] = 0
	_MemGlobalFree($hData)
	Return $pBitmap[2]
EndFunc   ;==>_ResourceLoadImage

Func _EXIT()
	Local $aPos
	For $i = 0 To 19
		_GDIPlus_BitmapDispose($hBitmapNavi[$i])
	Next
	_GDIPlus_GraphicsDispose($hGraphicsGui)
	_GDIPlus_GraphicsDispose($hGraphicsNavi)
	_GDIPlus_Shutdown()
	$aPos = WinGetPos($hGuiMenu)
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "MenuX", $aPos[0])
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "MenuY", $aPos[1])
	$aPos = WinGetPos($hGuiItem)
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "ItemX", $aPos[0])
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "ItemY", $aPos[1])
	$aPos = WinGetPos($hGuiNavi)
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "NaviX", $aPos[0])
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "NaviY", $aPos[1])
	$aPos = WinGetPos($hGui)
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "XPos", $aPos[0])
	IniWrite(@ScriptDir & "\Mario.ini", "Editor", "YPos", $aPos[1])
	Exit
EndFunc   ;==>_EXIT