#NoTrayIcon
#AutoIt3Wrapper_Icon=Mario.ico
#include <Misc.au3>
_Singleton("Super Autoit Mario")

If _VersionCompare(@AutoItVersion, "3.3.2.0") = -1 Then
	MsgBox(0, "", "this game requires AutoIt 3.3.2.0 or higher")
	Exit
EndIf

#include <File.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <Memory.au3>

Global $bDebug = False, $sLevelFile
If $Cmdline[0] > 1 And $Cmdline[1] = "Debug" And FileExists($Cmdline[2]) Then
	$bDebug = True
	$sLevelFile = $Cmdline[2]
EndIf

Global Const $M_PILZ = 0 ; Pilz
Global Const $M_BLME = 1 ; Blume
Global Const $M_STRN = 2 ; Stern
Global Const $M_WMAN = 3 ; Watschelmann
Global Const $M_SKRT = 4 ; Schildkröte
Global Const $M_PFNZ = 5 ; Pflanze Aufrecht
Global Const $M_AUFZ = 6 ; Aufzug
Global Const $M_MONY = 7 ; Gold
Global Const $M_FAHN = 8 ; Fahne
Global Const $M_FSKR = 9 ; Fliegende Schildkröte
Global Const $M_FIRE = 100 ; Feuerball
Global Const $M_PNZR = 99 ; Schildkröten Panzer
Global Const $M_KNKG = 98 ; KanonenKugel
Global Const $M_ZERB = 97 ; Zerbrechende Mauer

Global Const $S_RASL = 0 ; Rasen Links
Global Const $S_RASM = 1 ; Mitte
Global Const $S_RASR = 2 ; Rechts
Global Const $S_MAUR = 3 ; Mauer Braun
Global Const $S_FRGZ = 4 ; Fragezeichen
Global Const $S_STNR = 5 ; Stein runde Ecken
Global Const $S_STNE = 6 ; Stein eckig
Global Const $S_RORO = 7 ; Rohr Eingang oben
Global Const $S_RORU = 8 ; Rohr Unten
Global Const $S_RORL = 9 ; Rohr Links
Global Const $S_RORR = 10 ; Rohr Rechts
Global Const $S_RORV = 11 ; Rohr vertikal
Global Const $S_RORH = 12 ; Rohr horizontal
Global Const $S_KANO = 13 ; Kanone
Global Const $S_FANO = 14 ; Fahnenstange oben
Global Const $S_FANS = 15 ; Fahnenstange
Global Const $S_MAU2 = 16 ; Mauer blau
Global Const $S_UNSI = 17 ; Unsichtbar
Global Const $S_UNS2 = 18 ; Unsichtbar
Global Const $S_TRAL = 19 ; Turmrasen Links
Global Const $S_TRAM = 20 ; Mitte
Global Const $S_TRAR = 21 ; Rechts
Global Const $S_PALL = 22 ; Palme Links
Global Const $S_PALM = 23 ; Mitte
Global Const $S_PALR = 24 ; Rechts
Global Const $S_GELB = 25 ; Gelber Stein

Opt("GuiOnEventMode", 1)
Opt("GUICloseOnESC", 0)

#Region Declare Variables/Const
_GDIPlus_Startup()
Global $hUser32dll = DllOpen("User32.dll")
Global $hDwmApiDll = DllOpen("dwmapi.dll")

If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_7" Then
	;	If _IsAeroEnable() = 0 Then _EnableDisableAero(False) ; Uncomment, to disable Aerostyle while playing
EndIf

Global Const $WMSZ_BOTTOM = 6
Global Const $WMSZ_BOTTOMLEFT = 7
Global Const $WMSZ_BOTTOMRIGHT = 8
Global Const $WMSZ_LEFT = 1
Global Const $WMSZ_RIGHT = 2
Global Const $WMSZ_TOP = 3
Global Const $WMSZ_TOPLEFT = 4
Global Const $WMSZ_TOPRIGHT = 5
;Global Const $WM_MOVING = 0x0216
Global Const $margin = 18

Global $iKeyDown = IniRead(@ScriptDir & "\Mario.ini", "Control", "Down", 40)
Global $iKeyUp = IniRead(@ScriptDir & "\Mario.ini", "Control", "Up", 38)
Global $iKeyLeft = IniRead(@ScriptDir & "\Mario.ini", "Control", "Left", 37)
Global $iKeyRight = IniRead(@ScriptDir & "\Mario.ini", "Control", "Right", 39)
Global $iKeyFire = IniRead(@ScriptDir & "\Mario.ini", "Control", "Fire", 32)
Global $iKeyPause = IniRead(@ScriptDir & "\Mario.ini", "Control", "Pause", 80)
Global $iKeySound = IniRead(@ScriptDir & "\Mario.ini", "Control", "Sound", 83)
Global $bSoundEnabled = True
If IniRead(@ScriptDir & "\Mario.ini", "Settings", "Sound", True) = "False" Then $bSoundEnabled = False
Global $nLandF = IniRead(@ScriptDir & "\Mario.ini", "Gui", "Factor", 1)
Global $iGuiX = IniRead(@ScriptDir & "\Mario.ini", "Gui", "XPos", -1)
Global $iGuiY = IniRead(@ScriptDir & "\Mario.ini", "Gui", "YPos", -1)
Global $nLeft, $nRight, $nTop, $nBottom

Global $lpKeyState = DllStructCreate("byte[256]"), $aKeyReturn[256], $aKeyReturnOld[256]
$aKeyReturnOld = _WinAPI_GetKeyboardState_Mario(False)

Global $aGFX_BKG[50], $aGFX_HRO[50], $aGFX_STN[100], $aGFX_SBK[100], $aGFX_MOV[200], $aGFX_TXT[100], $aGFX_MNU[20]
Global $aSTN[20][400][13][20], $aSBK[20][400][13], $aMOV[20][1000][25], $aBKGIndex[20], $aLevelWidth[20], $aCollected[20][400][13]
Global $aCredits = StringSplit("Super Autoit Mario;;Coded by:;Eukalyptus;;Special THX to:;Gummibaer;Progandy;BrettF;GtaSpider;Zedna;Martin;Funkey;;www.autoit.de;www.autoitscript.com;www.un4seen.com;;Autoit 3.3.2.0;Xmas 2009;;;This Game is still beta :)", ";")
Global $iLVL = 0, $bFullFrameRate = True, $iFullFrameRateStep = 0, $bPause = False, $iPause, $bDrawBackground = False, $iMarioEnterSubLevelIcon, $bCompleteLevel, $iMarioCompleteIcon
Global $iLandX = 0, $iTimer = TimerInit(), $iTimerDelay = 22, $iTimerDiff = 0, $bTimerStep = False, $iTime
Global $iMarioX = -20, $iMarioY = 0, $iMarioSize = 0, $iMarioRunSpeed, $bMarioLeft, $iMarioRunStep, $bMarioDown, $iMarioJumpHeight = 20
Global $iMarioJumpStep = 0, $bMarioHurt = False, $iMarioHurtStep = 0, $bMarioStern = False, $iMarioSternStep = 0, $iMarioFireStep = 0
Global $bBoden, $bDecke, $bWandL, $bWandR, $bCheckMCol = True, $bReDraw = True, $iMoneyIcon = 24, $iMoneyIconStep = 0, $bEnterSublevel = False
Global $iMarioTaler = 0, $iMarioLeben = 5, $iAddMoneyStep = 0, $iAddMoneyX = 1, $iAddMoneyY = 1, $sAddMoney = "", $iStatusMoneyStep = 0, $iMarioMoney = 0
Global $iZielXPos, $iStartXPos, $iPlantIcon = 17, $iPlantIconStep = 0, $bCompleteText = False, $iLevelTime, $iLevelTimeStep, $bMarioFire = False
Global $sMessageText = "", $iSleep = TimerInit(), $iRedrawTime = 22, $iRedrawTimer, $aDoubleTime[2] = [22, 22]

Global $iMarioIcon, $iLogoY = 240, $iGrassStep = 0, $iGrassIcon, $iGrassX = 220, $iGrassNew = -400, $iBkX = 0, $iSteinX = 0
Global $iCreditY = 100, $iMenu = 0, $iMenuSelected = 0, $aKeys[256], $sKeys, $sKeysOld, $aLevels[1000], $iLevelSelected = 1, $sLevelSelected = "", $iControlSelected = 0, $bControlEdit = False
Global $iSoundStep = 100, $bCreditEnd = False
Global $hSFX[20][2], $hMSC[30][2]
#EndRegion Declare Variables/Const

#Region GUICreate
Global $hGui = GUICreate("Super AutoIt Mario Beta", 428 * $nLandF, 282 * $nLandF, $iGuiX, $iGuiY, $WS_POPUP, $WS_EX_LAYERED)
GUISetOnEvent($GUI_EVENT_CLOSE, "_EXIT")
GUISetBkColor(0xABCDEF)
_WinAPI_SetLayeredWindowAttributes_($hGui, 0xABCDEF, 255)
GUISetState(@SW_SHOW, $hGui)
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
GUIRegisterMsg($WM_SIZING, "WM_SIZING")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")
GUIRegisterMsg($WM_MOVING, "WM_MOVING")
GUIRegisterMsg($WM_KILLFOCUS, "WM_KILLFOCUS")
GUIRegisterMsg($WM_SETFOCUS, "WM_SETFOCUS")
GUIRegisterMsg($WM_LBUTTONDOWN, "WM_LBUTTONDOWN")
GUIRegisterMsg($WM_MOUSEMOVE, "_SetCursor")
Global $hGraphicDC = _GDIPlus_GraphicsCreateFromHWND($hGui)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics(320, 240, $hGraphicDC)
Global $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
Global $hBitmapBK = _GDIPlus_BitmapCreateFromGraphics(320, 240, $hGraphicDC)
Global $hGraphicsBK = _GDIPlus_ImageGetGraphicsContext($hBitmapBK)
Global $hBitmapFR = _GDIPlus_BitmapCreateFromGraphics(320, 240, $hGraphicDC)
Global $hGraphicsFR = _GDIPlus_ImageGetGraphicsContext($hBitmapFR)
Global $hBitmapTXT = _GDIPlus_BitmapCreateFromGraphics(320, 240, $hGraphicDC)
Global $hGraphicsTXT = _GDIPlus_ImageGetGraphicsContext($hBitmapTXT)
Global $hBrush = _WinAPI_CreateSolidBrush(0xEFCDAB)
Global $hImageIcon = _ResourceLoadImage("GFX.dat", "GUI1")
Global $hIcon = _GDIPlus_BitmapCreateHICONFromBitmap($hImageIcon)
_GDIPlus_ImageDispose($hImageIcon)

#EndRegion GUICreate

Global $hBassFXDll = DllOpen(@ScriptDir & "\BASS_FX.dll")
Global $hBassDll = DllOpen(@ScriptDir & "\BASS.dll")
_BASS_Init($hBassDll, 0, -1, 44100, 0, "")
If @error Then $bSoundEnabled = False
If Not $bSoundEnabled Then $iSoundStep = 0
$aLevels = _FileListToArray(@ScriptDir & "\LVL", "*.lvl", 1)
If Not @error Then $sLevelSelected = $aLevels[1]

_LoadGFX()
_StatusDrawText($hGraphicsTXT, "+ ", 17, 24)
_StatusDrawText($hGraphicsTXT, "Mario + ", 210, 9)
_StatusDrawText($hGraphicsTXT, "Time : ", 210, 24)
If $bDebug Then _StatusDrawText($hGraphicsTXT, "Debug Mode", 50, 35, 2)
_LoadSFX()
GUIRegisterMsg($WM_ERASEBKGND, "_WM_ERASEBKGND")
_WinAPI_RedrawWindow($hGui)
Switch $bDebug
	Case False
		_BASS_ChannelPlay($hBassDll, $hMSC[27][0], 1)
		While $iMarioX < 150 ; ________________________________________________________________________________________Intro
			$iTime = TimerDiff($iTimer)
			Select
				Case $iTime < 38 - 9
					Sleep(9)
				Case $iTime > 37
					$iTimer = TimerInit()
					$iMarioX += 4
					$iLogoY -= 4
					$iMarioRunStep += 1
					$iGrassStep += 1
					_WinAPI_RedrawWindow_($hGui)
			EndSelect
		WEnd
	Case Else
		_LoadLevel($sLevelFile)
		$iMenu = -1
EndSwitch
$sKeys = _WinAPI_GetKeyboardState_Mario(1, True, 1)
$sKeysOld = $sKeys
$iTimerDelay = 22
While 1
	Switch $iMenu
		Case -1
			$iTime = TimerDiff($iTimer)
			Select
				Case $bPause
					Sleep(100)
					_WinAPI_GetKeyboardState_Mario()
					ContinueLoop
				Case $iTime > $iTimerDelay - $iTimerDiff
					$iTimer = TimerInit()
					$bTimerStep = Not $bTimerStep
					$bReDraw = Not $bTimerStep
					$bCheckMCol = $bTimerStep
					_STNSet()
					_MOVSetItems()
					If _MarioMove() Then ContinueLoop
					_MarioCheckCollision()
					Select
						Case $bReDraw
							_WinAPI_RedrawWindow_($hGui)
						Case TimerDiff($iTimer) + $iRedrawTime <= $iTimerDelay ;Wenn genügend Zeit, dann FullFramerate
							_WinAPI_RedrawWindow_($hGui)
					EndSelect
					$iLevelTimeStep += 1
					Switch $iLevelTimeStep
						Case 44
							$iLevelTimeStep = 0
							$iLevelTime -= 1
							Switch $iLevelTime
								Case 1 To 100
									Switch $bMarioStern
										Case False
											_BASS_ChannelSetAttribute($hBassDll, $hMSC[$iLVL][0], 0x10000, 40 - $iLevelTime / 3)
										Case Else
											_BASS_ChannelSetAttribute($hBassDll, $hMSC[29][0], 0x10000, 40 - $iLevelTime / 3)
									EndSwitch
								Case 0
									$sMessageText = "Time over"
									_MarioDeath()
							EndSwitch
					EndSwitch
					$iTimerDiff = 0
					$aDoubleTime[$bTimerStep] = TimerDiff($iTimer)
					If $aDoubleTime[0] + $aDoubleTime[1] > $iTimerDelay * 2 Then $iTimerDiff = $aDoubleTime[0] + $aDoubleTime[1] - $iTimerDelay
			EndSelect
		Case Else
			$iTime = TimerDiff($iTimer)
			Select
				Case $iTime < 38 - 16
					_Sleep(12)
				Case $iTime > 37
					$iTimer = TimerInit()
					If $iLogoY > 10 Then
						$iLogoY -= 4
					Else
						If $iMenu = 0 Then $iMenu = 2
					EndIf
					$iMarioRunStep += 1
					$iGrassStep += 1
					$iGrassX -= 4
					$iBkX -= 1
					$iSteinX -= 4
					If $iMarioX < 150 Or $bCreditEnd Then $iMarioX += 2
					$sKeys = _WinAPI_GetKeyboardState_Mario(1, True, 1)
					If $sKeys <> $sKeysOld Then
						$sKeysOld = $sKeys
						$aKeys = _WinAPI_GetKeyboardState_Mario(0, True)
						Switch $iMenu
							Case 1
								If $aKeys[27] > 1 Or $bCreditEnd Then
									$bCreditEnd = False
									_BASS_ChannelStop($hBassDll, $hMSC[26][0])
									_BASS_ChannelPlay($hBassDll, $hMSC[27][0], 1)
									$iMarioX = -20
									$iMenu = 2
									_PlaySound(16)
								EndIf
							Case 2 ; Menu
								_NaviMenu($aKeys)
							Case 3 ; Select
								_NaviSelect($aKeys)
							Case 4 ; Settings
								_NaviControl($aKeys)
						EndSwitch
					EndIf
					_WinAPI_RedrawWindow_($hGui)
			EndSelect
	EndSwitch
WEnd


#Region Set Movings
Func _MOVSetItems()
	Local $aReturn
	$iMoneyIconStep += 1
	Switch $iMoneyIconStep
		Case 0 To 3
			$iMoneyIcon = 24
		Case 4 To 6
			$iMoneyIcon = 25
		Case 7 To 9
			$iMoneyIcon = 26
		Case 10 To 12
			$iMoneyIcon = 27
		Case 13 To 15
			$iMoneyIcon = 26
		Case 16 To 18
			$iMoneyIcon = 25
		Case Else
			$iMoneyIcon = 24
			$iMoneyIconStep = 0
	EndSwitch
	$iPlantIconStep += 1
	Switch $iPlantIconStep
		Case 0 To 10
			$iPlantIcon = 17
		Case 11 To 19
			$iPlantIcon = 18
		Case Else
			$iPlantIcon = 18
			$iPlantIconStep = 0
	EndSwitch
	For $i = 1 To $aMOV[$iLVL][0][0]
		If Not $aMOV[$iLVL][$i][0] Then ContinueLoop
		;Zuerst allgemeine Berechnungen, die für alle gelten...
		Switch $bCheckMCol
			Case True
				If $aMOV[$iLVL][$i][9] <> $M_AUFZ Then
					If $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] > 240 Then $aMOV[$iLVL][$i][0] = 0
					Switch $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $iLandX
						Case -100000 To -180, 480 To 100000 ;Wenn außerhalb, dann keine Berechnung (außer Reset)
							_MOVReset($i)
							ContinueLoop
					EndSwitch
				EndIf
		EndSwitch
		Switch $aMOV[$iLVL][$i][0]
			Case 1 ;Normale Berechnung
				$aMOV[$iLVL][$i][3] += $aMOV[$iLVL][$i][13] ;Bewegung in X
				$aMOV[$iLVL][$i][4] += $aMOV[$iLVL][$i][14] ;Bewegung in Y
				Switch $aMOV[$iLVL][$i][15]
					Case True ;Jump (=auch fallen)
						$aMOV[$iLVL][$i][4] -= $aMOV[$iLVL][$i][16] * 0.5
						$aMOV[$iLVL][$i][16] -= 1
						If $aMOV[$iLVL][$i][16] <= -12 Then $aMOV[$iLVL][$i][16] = -12
				EndSwitch
				If Not $bCheckMCol Then ContinueLoop
				;Item-spezifische Berechnungen
				Switch $aMOV[$iLVL][$i][9]
					Case $M_BLME, $M_FAHN, $M_MONY, $M_ZERB
						ContinueLoop
					Case $M_WMAN
						$aMOV[$iLVL][$i][10] += 1
						Switch $aMOV[$iLVL][$i][10]
							Case 0 To 5
								$aMOV[$iLVL][$i][8] = 6
							Case 6 To 9
								$aMOV[$iLVL][$i][8] = 7
							Case Else
								$aMOV[$iLVL][$i][10] = 0
						EndSwitch
					Case $M_SKRT
						$aMOV[$iLVL][$i][10] += 1
						Switch $aMOV[$iLVL][$i][10]
							Case 0 To 5
								$aMOV[$iLVL][$i][8] = 9
								If $aMOV[$iLVL][$i][13] > 0 Then $aMOV[$iLVL][$i][8] = 11
							Case 6 To 9
								$aMOV[$iLVL][$i][8] = 10
								If $aMOV[$iLVL][$i][13] > 0 Then $aMOV[$iLVL][$i][8] = 12
							Case Else
								$aMOV[$iLVL][$i][10] = 0
						EndSwitch
					Case $M_FSKR
						$aMOV[$iLVL][$i][10] += 1
						Switch $aMOV[$iLVL][$i][10]
							Case 0 To 3
								$aMOV[$iLVL][$i][8] = 31
								If $aMOV[$iLVL][$i][13] > 0 Then $aMOV[$iLVL][$i][8] = 33
							Case 4 To 6
								$aMOV[$iLVL][$i][8] = 32
								If $aMOV[$iLVL][$i][13] > 0 Then $aMOV[$iLVL][$i][8] = 34
							Case Else
								$aMOV[$iLVL][$i][10] = 0
						EndSwitch
					Case $M_PNZR
						$aMOV[$iLVL][$i][10] += 1
						Switch $aMOV[$iLVL][$i][10]
							Case 0 To 2
								$aMOV[$iLVL][$i][8] = 13
							Case 3 To 4
								$aMOV[$iLVL][$i][8] = 14
							Case 5 To 6
								$aMOV[$iLVL][$i][8] = 15
							Case 7
								$aMOV[$iLVL][$i][8] = 16
							Case Else
								$aMOV[$iLVL][$i][10] = 0
						EndSwitch
						If $aMOV[$iLVL][$i][12] > 0 Then $aMOV[$iLVL][$i][12] -= 1
						If $aMOV[$iLVL][$i][13] <> 0 Then _PanzerCheckCollision($i)
					Case $M_MONY
						$aMOV[$iLVL][$i][8] = $iMoneyIcon
					Case $M_STRN
						$aMOV[$iLVL][$i][10] += 2
						If $aMOV[$iLVL][$i][10] > 300 Then $aMOV[$iLVL][$i][0] = 0
					Case $M_PFNZ
						Switch $aMOV[$iLVL][$i][11]
							Case 0
								If Abs($iLandX) + $iMarioX > $aMOV[$iLVL][$i][1] - 40 And Abs($iLandX) + $iMarioX < $aMOV[$iLVL][$i][1] + 50 Then ContinueLoop
								$aMOV[$iLVL][$i][4] += $aMOV[$iLVL][$i][10] * 2
							Case 1 To 14
								If $aMOV[$iLVL][$i][4] <> 0 Then $aMOV[$iLVL][$i][4] += $aMOV[$iLVL][$i][10] * 2
							Case 15 To 45
							Case 46 To 60
								$aMOV[$iLVL][$i][4] -= $aMOV[$iLVL][$i][10] * 2
							Case 61 To 105
							Case 106
								$aMOV[$iLVL][$i][11] = -1
						EndSwitch
						$aMOV[$iLVL][$i][11] += 1
						$aMOV[$iLVL][$i][8] = $iPlantIcon
						If $aMOV[$iLVL][$i][10] > 0 Then $aMOV[$iLVL][$i][8] += 2
						ContinueLoop
					Case $M_AUFZ ; Aufzug reseten, wenn ober bzw. unterhalb des Bildes
						Switch $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4]
							Case 240 To 1000
								Switch $aMOV[$iLVL][$i][13]
									Case 0 ;Aufzug bewegt sich nur senkrecht
										$aMOV[$iLVL][$i][4] = -10 - $aMOV[$iLVL][$i][2]
									Case Else ; Aufzug bewegt sich schräg => reset
										;ToolTip($aMOV[$iLVL][$i][4])
										$aMOV[$iLVL][$i][3] = 0
										$aMOV[$iLVL][$i][4] = 0
								EndSwitch
							Case -1000 To -10
								Switch $aMOV[$iLVL][$i][13]
									Case 0 ;Aufzug bewegt sich nur senkrecht
										$aMOV[$iLVL][$i][4] = 240 - $aMOV[$iLVL][$i][2]
									Case Else ; Aufzug bewegt sich schräg => reset
										;ToolTip($aMOV[$iLVL][$i][4])
										$aMOV[$iLVL][$i][3] = 0
										$aMOV[$iLVL][$i][4] = 0
								EndSwitch
						EndSwitch
				EndSwitch
				Select
					Case $aMOV[$iLVL][$i][15] And $aMOV[$iLVL][$i][16] < 0 ;Item kann fallen oder springen
						If _CheckBoden($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] / 2, $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6], $aReturn) Then
							$aMOV[$iLVL][$i][16] = $aMOV[$iLVL][$i][23]
							$aMOV[$iLVL][$i][4] = $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][2] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][4] - $aMOV[$iLVL][$i][2] - $aMOV[$iLVL][$i][6]
							Switch $aMOV[$iLVL][$i][9]
								Case $M_WMAN, $M_SKRT ;Watschelmänner, Schildkröten drehen um falls Abgrund
									Select
										Case $aMOV[$iLVL][$i][13] < 0
											If Not $aSTN[$iLVL][$aReturn[0] - 1][$aReturn[1]][0] Then $aMOV[$iLVL][$i][13] *= -1
										Case $aMOV[$iLVL][$i][13] > 0
											If Not $aSTN[$iLVL][$aReturn[0] + 1][$aReturn[1]][0] Then $aMOV[$iLVL][$i][13] *= -1
									EndSelect
							EndSwitch
						EndIf
					Case $aMOV[$iLVL][$i][15] And $aMOV[$iLVL][$i][16] > 0 ;Item kann fallen oder springen
						If _CheckDecke($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] / 2, $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aReturn) Then
							$aMOV[$iLVL][$i][16] = 0
							$aMOV[$iLVL][$i][4] = $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][2] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][4] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][6] - $aMOV[$iLVL][$i][2]
						EndIf
					Case $aMOV[$iLVL][$i][14] > 0 ;Lineare Y Bewegung runter
						If _CheckBoden($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] / 2, $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][14] *= -1
					Case $aMOV[$iLVL][$i][14] < 0 ;Lineare Y Bewegung rauf
						If _CheckDecke($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] / 2, $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aReturn) Then $aMOV[$iLVL][$i][14] *= -1
				EndSelect
				Select
					Case $aMOV[$iLVL][$i][13] > 0
						If _CheckWandL($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][5], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][13] *= -1
					Case $aMOV[$iLVL][$i][13] < 0
						If _CheckWandR($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][13] *= -1
				EndSelect
			Case 2 ; Item stirbt
				$aMOV[$iLVL][$i][4] -= $aMOV[$iLVL][$i][10]
				$aMOV[$iLVL][$i][10] -= 1
				If $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] > 240 Then $aMOV[$iLVL][$i][0] = 0
			Case 3 ; Mauer Zerbricht
				Switch $aMOV[$iLVL][$i][8]
					Case 28
						$aMOV[$iLVL][$i][8] = 29
					Case Else
						$aMOV[$iLVL][$i][8] = 28
				EndSwitch
				$aMOV[$iLVL][$i][14] -= 1
				$aMOV[$iLVL][$i][3] += $aMOV[$iLVL][$i][13]
				$aMOV[$iLVL][$i][4] -= $aMOV[$iLVL][$i][14]
			Case 4 ; Fireball
				Switch $aMOV[$iLVL][$i][8]
					Case 1
						$aMOV[$iLVL][$i][8] = 2
					Case Else
						$aMOV[$iLVL][$i][8] = 1
				EndSwitch
				$aMOV[$iLVL][$i][3] += $aMOV[$iLVL][$i][13]
				$aMOV[$iLVL][$i][4] += $aMOV[$iLVL][$i][14]
				$aMOV[$iLVL][$i][14] += 1
				$aMOV[$iLVL][$i][10] += 1
				If $aMOV[$iLVL][$i][14] > 6 Then $aMOV[$iLVL][$i][14] = 6
				If $aMOV[$iLVL][$i][10] > 200 Then $aMOV[$iLVL][$i][0] = 0
				If _CheckBoden($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] / 2, $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6], $aReturn) Then
					$aMOV[$iLVL][$i][14] = -5
					$aMOV[$iLVL][$i][4] += $aMOV[$iLVL][$i][14]
				EndIf
				Select
					Case $aMOV[$iLVL][$i][13] > 0
						If _CheckWandL($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][5], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][0] = 0
					Case $aMOV[$iLVL][$i][13] < 0
						If _CheckWandR($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][0] = 0
				EndSelect
				_FireBallCheckCollision($i)
			Case 5 ; Kanonenkugel
				$aMOV[$iLVL][$i][3] += $aMOV[$iLVL][$i][13] ;Bewegung in X
				Select
					Case $aMOV[$iLVL][$i][13] > 0
						If _CheckWandL($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][5], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][0] = 0
					Case $aMOV[$iLVL][$i][13] < 0
						If _CheckWandR($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][0] = 0
				EndSelect
		EndSwitch
	Next
EndFunc   ;==>_MOVSetItems

Func _PanzerCheckCollision($iI)
	For $i = 1 To $aMOV[$iLVL][0][0]
		If $aMOV[$iLVL][$i][0] <> 1 Or $i = $iI Then ContinueLoop
		Switch $aMOV[$iLVL][$i][9]
			Case $M_WMAN, $M_SKRT, $M_PNZR, $M_FSKR, $M_PFNZ ; Diese Items können vom Panzer getötet werden
				Switch $aMOV[$iLVL][$iI][1] + $aMOV[$iLVL][$iI][3]
					Case $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] - $aMOV[$iLVL][$iI][5] To $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] ;X-Koordinate
						Switch $aMOV[$iLVL][$iI][2] + $aMOV[$iLVL][$iI][4]
							Case $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] - $aMOV[$iLVL][$iI][6] To $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6] ;Y-Koordinate
								$aMOV[$iLVL][$i][0] = 2
								$aMOV[$iLVL][$i][10] = 8
								$aMOV[$iLVL][$i][8] += 100
								_PlaySound(8)
						EndSwitch
				EndSwitch
		EndSwitch
	Next
EndFunc   ;==>_PanzerCheckCollision

Func _FireBallCheckCollision($iI)
	For $i = 1 To $aMOV[$iLVL][0][0]
		If $aMOV[$iLVL][$i][0] <> 1 Then ContinueLoop
		Switch $aMOV[$iLVL][$i][9]
			Case $M_WMAN, $M_SKRT, $M_PNZR, $M_FSKR, $M_PFNZ ; Diese Items können vom Panzer getötet werden
				Switch $aMOV[$iLVL][$iI][1] + $aMOV[$iLVL][$iI][3]
					Case $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] - $aMOV[$iLVL][$iI][5] To $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] ;X-Koordinate
						Switch $aMOV[$iLVL][$iI][2] + $aMOV[$iLVL][$iI][4]
							Case $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] - $aMOV[$iLVL][$iI][6] To $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6] ;Y-Koordinate
								$aMOV[$iLVL][$i][0] = 2
								$aMOV[$iLVL][$i][10] = 8
								$aMOV[$iLVL][$iI][0] = 0
								$aMOV[$iLVL][$i][8] += 100
								_MarioAddMoney(1000, $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4])
								_PlaySound(8)
								Return
						EndSwitch
				EndSwitch
		EndSwitch
	Next
EndFunc   ;==>_FireBallCheckCollision

Func _MOVReset($iIndex)
	Switch $aMOV[$iLVL][$iIndex][9]
		Case $M_PNZR, $M_PILZ, $M_STRN, $M_FIRE, $M_ZERB, $M_KNKG, $M_MONY ;Panzer, Pilz, Stern, Feuerball, Kanonenkugel, Bruchstücke verschwinden
			$aMOV[$iLVL][$iIndex][0] = 0
			Return
	EndSwitch
	If $aMOV[$iLVL][$iIndex][1] + $iLandX <= -20 Or $aMOV[$iLVL][$iIndex][1] + $iLandX > 320 Then
		$aMOV[$iLVL][$iIndex][3] = 0
		$aMOV[$iLVL][$iIndex][4] = 0
		$aMOV[$iLVL][$iIndex][10] = $aMOV[$iLVL][$iIndex][17]
		$aMOV[$iLVL][$iIndex][11] = $aMOV[$iLVL][$iIndex][18]
		$aMOV[$iLVL][$iIndex][12] = $aMOV[$iLVL][$iIndex][19]
		$aMOV[$iLVL][$iIndex][13] = $aMOV[$iLVL][$iIndex][20]
		$aMOV[$iLVL][$iIndex][14] = $aMOV[$iLVL][$iIndex][21]
		$aMOV[$iLVL][$iIndex][15] = $aMOV[$iLVL][$iIndex][22]
		$aMOV[$iLVL][$iIndex][16] = $aMOV[$iLVL][$iIndex][23]
	EndIf
EndFunc   ;==>_MOVReset

Func _STNSet()
	If Not $bCheckMCol Then Return
	Local $iStartX = Floor(Abs($iLandX) / 20)
	For $X = $iStartX - 2 To $iStartX + 19
		If $X < 1 Or $X > 399 Then ContinueLoop
		For $Y = 1 To 12
			If Not $aSTN[$iLVL][$X][$Y][0] Then ContinueLoop
			Switch $aSTN[$iLVL][$X][$Y][9]
				Case $S_KANO
					$aSTN[$iLVL][$X][$Y][10] += 2
					If $aSTN[$iLVL][$X][$Y][10] < 100 Then ContinueLoop
					$aSTN[$iLVL][$X][$Y][10] = 0
					Select
						Case Abs($iLandX) + $iMarioX < $aSTN[$iLVL][$X][$Y][1]
							_AddMOVItem($M_KNKG, $X, $Y, 0, 0, 0)
						Case Else
							_AddMOVItem($M_KNKG, $X, $Y, 1, 0, 0)
					EndSelect
				Case $S_STNR
					If $aSTN[$iLVL][$X][$Y][12] Then $aSTN[$iLVL][$X][$Y][10] += 2
					If $aSTN[$iLVL][$X][$Y][10] > 6 Then $aSTN[$iLVL][$X][$Y][4] += ($aSTN[$iLVL][$X][$Y][10] - 4) * 2
					If $aSTN[$iLVL][$X][$Y][2] + $aSTN[$iLVL][$X][$Y][4] > 240 Then $aSTN[$iLVL][$X][$Y][0] = 0
				Case $S_FRGZ, $S_MAU2, $S_MAUR
					If $aSTN[$iLVL][$X][$Y][4] < 0 Then $aSTN[$iLVL][$X][$Y][4] += 2
				Case $S_GELB
					If $X < $iStartX Or $X > $iStartX + 17 Then $aSTN[$iLVL][$X][$Y][10] = 0
					Switch $aSTN[$iLVL][$X][$Y][10]
						Case 300
							$aSTN[$iLVL][$X][$Y][7] = 0
							$aSTN[$iLVL][$X][$Y][4] = 7
							$aSTN[$iLVL][$X][$Y][6] = 6
							$aSTN[$iLVL][$X][$Y][8] = 27
						Case 0
							$aSTN[$iLVL][$X][$Y][7] = BitOR(1, 2, 4, 8)
							$aSTN[$iLVL][$X][$Y][4] = 0
							$aSTN[$iLVL][$X][$Y][6] = 20
							$aSTN[$iLVL][$X][$Y][8] = 26
							ContinueLoop
					EndSwitch
					$aSTN[$iLVL][$X][$Y][10] -= 2
					$aSTN[$iLVL][$X][$Y][11] += 1
					Switch $aSTN[$iLVL][$X][$Y][11]
						Case 0 To 1
							$aSTN[$iLVL][$X][$Y][4] = 0
							$aSTN[$iLVL][$X][$Y][8] = 26
						Case 2 To 3
							$aSTN[$iLVL][$X][$Y][4] = 3
							$aSTN[$iLVL][$X][$Y][8] = 27
						Case 4 To 5
							$aSTN[$iLVL][$X][$Y][4] = 8
							$aSTN[$iLVL][$X][$Y][8] = 28
						Case 6
							$aSTN[$iLVL][$X][$Y][4] = 3
							$aSTN[$iLVL][$X][$Y][8] = 29
						Case Else
							$aSTN[$iLVL][$X][$Y][11] = 0
					EndSwitch
			EndSwitch
		Next
	Next
EndFunc   ;==>_STNSet

Func _STN_MovedUp($X, $Y)
	$aSTN[$iLVL][$X][$Y][4] = -8
	For $i = 1 To $aMOV[$iLVL][0][0] ;Sind MOV auf dem Stein?
		If Not $aMOV[$iLVL][$i][0] Then ContinueLoop
		Switch $aSTN[$iLVL][$X][$Y][1] + $aSTN[$iLVL][$X][$Y][3]
			Case $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] - $aSTN[$iLVL][$X][$Y][5] - 1 To $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] + 1
				Switch $aSTN[$iLVL][$X][$Y][2] + $aSTN[$iLVL][$X][$Y][4]
					Case $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6] - 19 To $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6]
						Switch $aMOV[$iLVL][$i][9]
							Case $M_PILZ
								$aMOV[$iLVL][$i][16] = 12
								_PlaySound(8)
							Case $M_PNZR, $M_SKRT, $M_WMAN
								$aMOV[$iLVL][$i][0] = 2
								$aMOV[$iLVL][$i][10] = 8
								$aMOV[$iLVL][$i][8] += 100
								_PlaySound(8)
						EndSwitch
				EndSwitch
		EndSwitch
	Next
	Select
		Case $aSTN[$iLVL][$X][$Y][11] = 1 ;Pilz/Blume
			Switch $iMarioSize
				Case 0
					Local $iIndex = _AddMOVItem($M_PILZ, $X, $Y + 1)
					$aMOV[$iLVL][$iIndex][16] = 12
				Case Else
					_AddMOVItem($M_BLME, $X, $Y + 1)
			EndSwitch
			$aSTN[$iLVL][$X][$Y][11] = 0
			_PlaySound(16)
		Case $aSTN[$iLVL][$X][$Y][11] = 2 ;Stern
			_AddMOVItem($M_STRN, $X, $Y + 1)
			$aSTN[$iLVL][$X][$Y][11] = 0
			_PlaySound(16)
		Case $aSTN[$iLVL][$X][$Y][10] > 0
			_AddMOVItem($M_MONY, $X, $Y)
			_MarioAddCoin()
			$aSTN[$iLVL][$X][$Y][10] -= 1
			If $aSTN[$iLVL][$X][$Y][10] = 0 And $aSTN[$iLVL][$X][$Y][9] = $S_FRGZ Then
				$aSTN[$iLVL][$X][$Y][8] = $S_STNR + 1
				$aSTN[$iLVL][$X][$Y][9] = $S_STNR
				$aSTN[$iLVL][$X][$Y][4] = 0
			EndIf
	EndSelect
	If $aSTN[$iLVL][$X][$Y][10] <= 0 Then
		Switch $aSTN[$iLVL][$X][$Y][9]
			Case $S_MAU2, $S_MAUR ;Können zerbrochen werden
				If $iMarioSize > 0 Then
					$aSTN[$iLVL][$X][$Y][0] = 0
					_AddMOVItem($M_ZERB, $X, $Y, 28, -2, 12)
					_AddMOVItem($M_ZERB, $X, $Y, 29, 2, 12)
					_AddMOVItem($M_ZERB, $X, $Y, 29, -2, 10)
					_AddMOVItem($M_ZERB, $X, $Y, 28, 2, 10)
					_PlaySound(13)
				Else
					_PlaySound(12)
				EndIf
			Case $S_FRGZ
				$aSTN[$iLVL][$X][$Y][8] = $S_STNR + 1
				$aSTN[$iLVL][$X][$Y][9] = $S_STNR
				$aSTN[$iLVL][$X][$Y][4] = 0
				$aSTN[$iLVL][$X][$Y][10] = 0
		EndSwitch
	EndIf
EndFunc   ;==>_STN_MovedUp
#EndRegion Set Movings

#Region KollisionsCheck
Func _CheckBoden($X, $Y, ByRef $aIndex, $W = 20)
	Local $aReturn[2] = [0, 0]
	Local $iX = Floor($X / 20)
	Local $iY = Ceiling((240 - $Y) / 20)
	For $i = $iX - 1 To $iX + 2
		If $i < 1 Or $i > 399 Then ContinueLoop
		For $j = $iY To $iY - 1 Step -1
			If $j < 1 Or $j > 12 Then ContinueLoop
			If Not $aSTN[$iLVL][$i][$j][0] Or Not BitAND($aSTN[$iLVL][$i][$j][7], 1) Then ContinueLoop
			Switch $X
				Case $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + 3 - $W / 4 To $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + $aSTN[$iLVL][$i][$j][5] - 1 + $W / 4
					Switch $Y
						Case $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] To $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] + 11
							$aReturn[0] = $i
							$aReturn[1] = $j
							$aIndex = $aReturn
							Return True
					EndSwitch
			EndSwitch
		Next
	Next
	$aIndex = $aReturn
	Return False
EndFunc   ;==>_CheckBoden

Func _CheckDecke($X, $Y, ByRef $aIndex, $W = 20)
	Local $aReturn[2] = [0, 0]
	Local $iX = Floor($X / 20)
	Local $iY = Floor((240 - $Y) / 20) + 1
	For $i = $iX To $iX + 2
		If $i < 1 Or $i > 399 Then ContinueLoop
		For $j = $iY To $iY + 1
			If $j < 1 Or $j > 12 Then ContinueLoop
			If Not $aSTN[$iLVL][$i][$j][0] Or Not BitAND($aSTN[$iLVL][$i][$j][7], 2) Then ContinueLoop
			Switch $Y
				Case $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] + $aSTN[$iLVL][$i][$j][6] - 11 To $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] + $aSTN[$iLVL][$i][$j][6] - 1
					Switch $X
						Case $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + 3 - $W / 4 To $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + $aSTN[$iLVL][$i][$j][5] - 1 + $W / 4
							$aReturn[0] = $i
							$aReturn[1] = $j
							$aIndex = $aReturn
							Return True
					EndSwitch
			EndSwitch
		Next
	Next
	$aIndex = $aReturn
	Return False
EndFunc   ;==>_CheckDecke

Func _CheckWandL($X, $Y, $W, $H, ByRef $aIndex)
	Local $aReturn[2] = [0, 0]
	Local $iX = Floor(($X + $W) / 20) + 1
	$aIndex = $aReturn
	If $iX < 1 Or $iX > 399 Then Return False
	Local $iY = Floor((240 - $Y) / 20)
	For $j = $iY - 1 To $iY + 2 ;_______________________________________________________________________________________-1 To +2
		If $j < 1 Or $j > 12 Then ContinueLoop
		If Not $aSTN[$iLVL][$iX][$j][0] Or Not BitAND($aSTN[$iLVL][$iX][$j][7], 4) Then ContinueLoop
		Switch $Y
			Case $aSTN[$iLVL][$iX][$j][2] + $aSTN[$iLVL][$iX][$j][4] - $H + 2 To $aSTN[$iLVL][$iX][$j][2] + $aSTN[$iLVL][$iX][$j][4] + $aSTN[$iLVL][$iX][$j][6] - 4
				Switch $X + $W
					Case $aSTN[$iLVL][$iX][$j][1] + $aSTN[$iLVL][$iX][$j][3] + 1 To $aSTN[$iLVL][$iX][$j][1] + $aSTN[$iLVL][$iX][$j][3] + 11
						$aReturn[0] = $iX
						$aReturn[1] = $j
						$aIndex = $aReturn
						Return True
				EndSwitch
		EndSwitch
	Next
	$aIndex = $aReturn
	Return False
EndFunc   ;==>_CheckWandL

Func _CheckWandR($X, $Y, $H, ByRef $aIndex)
	Local $aReturn[2] = [0, 0]
	Local $iX = Floor($X / 20) + 1
	Local $iY = Ceiling((240 - $Y) / 20)
	For $i = $iX - 1 To $iX
		If $i < 1 Or $i > 399 Then ContinueLoop
		For $j = $iY - 2 To $iY + 1 ; _____________________________________________________________________________________-2 To +2
			If $j < 1 Or $j > 12 Then ContinueLoop
			If Not $aSTN[$iLVL][$i][$j][0] Or Not BitAND($aSTN[$iLVL][$i][$j][7], 8) Then ContinueLoop
			Switch $Y
				Case $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] - $H + 2 To $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] + $aSTN[$iLVL][$i][$j][6] - 4
					Switch $X
						Case $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + $aSTN[$iLVL][$i][$j][5] - 11 To $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + $aSTN[$iLVL][$i][$j][5]
							$aReturn[0] = $i
							$aReturn[1] = $j
							$aIndex = $aReturn
							Return True
					EndSwitch
			EndSwitch
		Next
	Next
	$aIndex = $aReturn
	Return False
EndFunc   ;==>_CheckWandR

Func _CheckTouch($X, $Y, $W, $H, ByRef $aIndex)
	Local $aReturn[2] = [0, 0]
	Local $iX = Floor(($X + $W) / 20)
	$aIndex = $aReturn
	Local $iY = Floor((240 - $Y) / 20)
	For $i = $iX To $iX + 1
		If $i < 1 Or $i > 399 Then ContinueLoop
		For $j = $iY - 1 To $iY + 1
			If $j < 1 Or $j > 12 Then ContinueLoop
			If Not $aSTN[$iLVL][$i][$j][0] Or Not BitAND($aSTN[$iLVL][$i][$j][7], 16) Then ContinueLoop
			Switch $Y
				Case $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] - $H To $aSTN[$iLVL][$i][$j][2] + $aSTN[$iLVL][$i][$j][4] + $aSTN[$iLVL][$i][$j][6] - 38 + $H
					Switch $X
						Case $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] - $W To $aSTN[$iLVL][$i][$j][1] + $aSTN[$iLVL][$i][$j][3] + $aSTN[$iLVL][$i][$j][5]
							Switch $aSTN[$iLVL][$i][$j][0]
								Case 1
									Switch $aSTN[$iLVL][$i][$j][9]
										Case $S_FANO, $S_FANS
											_MarioLevelComplete($i, $j)
											Return
									EndSwitch
								Case 2 ; Money
									$aSTN[$iLVL][$i][$j][0] = 0
									$aCollected[$iLVL][$i][$j] = True
									_MarioAddCoin()
									$iMarioMoney += 25
									_PlaySound(1)
								Case 3 ; Pflanze
									_MarioSchrumpfen(0)
									Return
								Case Else
									$aReturn[0] = $i
									$aReturn[1] = $j
									$aIndex = $aReturn
									Return True
							EndSwitch
					EndSwitch
			EndSwitch
		Next
	Next
	$aIndex = $aReturn
	Return False
EndFunc   ;==>_CheckTouch


Func _MarioCheckCollision()
	Local $iSizeX, $iSizeY, $aReturn
	$bBoden = False
	$bDecke = False
	$bWandL = False
	$bWandR = False
	Select
		Case $iMarioSize = 0
			$iSizeX = 16
			$iSizeY = 19
		Case $iMarioSize > 0 And $bMarioDown = False
			$iSizeX = 20
			$iSizeY = 38
		Case $iMarioSize > 0 And $bMarioDown = True
			$iSizeX = 20
			$iSizeY = 19
	EndSelect
	If $iMarioJumpStep <= 0 Then $bBoden = _CheckBoden(Abs($iLandX) + $iMarioX + 10, $iMarioY + 38, $aReturn, $iSizeX)
	Switch $bBoden
		Case True
			$iMarioY = $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][2] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][4] - 38
			Switch $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][9]
				Case $S_STNR
					If $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][10] Then $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][12] = True
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][9] = $S_STNR
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][8] = $S_STNR + 1
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][7] = BitOR(1, 2, 4, 8)
				Case $S_RORO
					If $bMarioDown And $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][11] <> 0 Then
						_EnterSubLevel($aReturn[0], $aReturn[1])
						Return
					EndIf
			EndSwitch
	EndSwitch
	If $iMarioJumpStep >= 0 Then $bDecke = _CheckDecke(Abs($iLandX) + $iMarioX + 10, $iMarioY + 38 - $iSizeY, $aReturn, $iSizeX)
	Switch $bDecke
		Case True
			$iMarioJumpStep = 0
			$iMarioY = $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][2] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][4] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][6] + $iSizeY - 38
			Switch $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][9]
				Case $S_UNSI
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][9] = $S_STNR
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][8] = $S_STNR + 1
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][7] = BitOR(1, 2, 4, 8)
					_PlaySound(12)
				Case $S_FRGZ, $S_MAUR, $S_MAU2
					_STN_MovedUp($aReturn[0], $aReturn[1])
				Case $S_GELB
					$aSTN[$iLVL][$aReturn[0]][$aReturn[1]][10] = 300
				Case $S_RORU
					If $aKeyReturn[38] > 1 And $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][11] <> 0 Then
						_EnterSubLevel($aReturn[0], $aReturn[1])
						Return
					EndIf
			EndSwitch
	EndSwitch
	If $iMarioRunSpeed >= 0 Then $bWandL = _CheckWandL(Abs($iLandX) + $iMarioX + 9 - $iSizeX / 2, $iMarioY + 38 - $iSizeY, $iSizeX, $iSizeY, $aReturn)
	Switch $bWandL
		Case True
			If $iMarioRunSpeed > 0 Then $iMarioX = $iLandX + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][1] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][3] - $iSizeX
			Switch $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][9]
				Case $S_RORL
					If $aKeyReturn[39] > 1 And $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][11] <> 0 Then
						_EnterSubLevel($aReturn[0], $aReturn[1])
						Return
					EndIf
			EndSwitch
	EndSwitch
	If $iMarioRunSpeed <= 0 Then $bWandR = _CheckWandR(Abs($iLandX) + $iMarioX + 10 - $iSizeX / 2, $iMarioY + 38 - $iSizeY, $iSizeY, $aReturn)
	Switch $bWandR
		Case True
			If $iMarioRunSpeed < 0 Then $iMarioX = $iLandX + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][1] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][3] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][5] + $iSizeX / 2 - 10
			Switch $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][9]
				Case $S_RORR
					If $aKeyReturn[37] > 1 And $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][11] <> 0 Then
						_EnterSubLevel($aReturn[0], $aReturn[1])
						Return
					EndIf
			EndSwitch
	EndSwitch
	_CheckTouch(Abs($iLandX) + $iMarioX + 10 - $iSizeX / 2, $iMarioY, $iSizeX, $iSizeY, $aReturn)
	_MarioCheckMOVCollision(Abs($iLandX) + $iMarioX, $iMarioY, $iSizeX, $iSizeY)
	If $bDebug And $iMarioY > 202 Then
		$bBoden = True
		$iMarioY = 202
	EndIf
EndFunc   ;==>_MarioCheckCollision

Func _MarioCheckMOVCollision($iMX, $iMY, $iMW, $iMH)
	Local $aReturn
	For $i = 1 To $aMOV[$iLVL][0][0]
		If $aMOV[$iLVL][$i][0] <> 1 And $aMOV[$iLVL][$i][0] <> 5 Then ContinueLoop
		Switch $iMX
			Case $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] - 10 - $iMW / 2 To $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] + $iMW / 2 - 10 ;Item befindet sich im X Bereich von Spielfigur
				Switch $aMOV[$iLVL][$i][9]
					Case $M_AUFZ
						Switch $iMY + 38
							Case $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] To $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + 11
								If Not $bDecke Then $iMarioY = $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] - 38
								$iMarioX += $aMOV[$iLVL][$i][13]
								If $iMarioJumpStep <= 0 Then
									$bBoden = True
									$iMarioJumpStep = 0
								EndIf
								$bDecke = _CheckDecke($iMX + 10, $iMY + 38 - $iMH, $aReturn)
								Switch $bDecke
									Case True
										$iMarioJumpStep = 0
										$iMarioY = $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][2] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][4] + $aSTN[$iLVL][$aReturn[0]][$aReturn[1]][6] + $iMH - 38
										$bBoden = False
									Case Else
										If $aMOV[$iLVL][$i][14] > 0 Then $iMarioY += $aMOV[$iLVL][$i][14]
								EndSwitch
						EndSwitch
						ContinueLoop
					Case Else
						If BitAND($aMOV[$iLVL][$i][7], 1) And $iMarioJumpStep < 1 And Not $bMarioStern Then ;Draufspringen ;Mario springt nach oben, also gibt es kein draufspringen
							Switch $iMY + 38
								Case $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $iMarioJumpStep * 0.5 To $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + 19
									Switch $aMOV[$iLVL][$i][9]
										Case $M_WMAN
											$aMOV[$iLVL][$i][0] = 2
											$aMOV[$iLVL][$i][8] = 8
											$aMOV[$iLVL][$i][10] = 8
											_MarioAddMoney(1000, $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4])
											$iMarioJumpStep = 12
											_PlaySound(8)
										Case $M_SKRT ;Schildkröte wird zu Panzer
											$aMOV[$iLVL][$i][2] += 10
											$aMOV[$iLVL][$i][6] = 20
											$aMOV[$iLVL][$i][8] = 14
											$aMOV[$iLVL][$i][12] = 0
											$aMOV[$iLVL][$i][13] = 0
											$aMOV[$iLVL][$i][7] = 16
											$aMOV[$iLVL][$i][23] = 0
											$aMOV[$iLVL][$i][9] = $M_PNZR
											_MarioAddMoney(1000, $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4])
											$iMarioJumpStep = 12
											_PlaySound(5)
										Case $M_FSKR ; Fliegende Schildkröte wird normal
											$aMOV[$iLVL][$i][9] = $M_SKRT
											$aMOV[$iLVL][$i][16] = -8
											$aMOV[$iLVL][$i][23] = 0
											$iMarioJumpStep = 12
											_PlaySound(5)
										Case $M_PNZR ;rollender Panzer
											Switch $aMOV[$iLVL][$i][12]
												Case 0
													$aMOV[$iLVL][$i][7] = 16
													$aMOV[$iLVL][$i][13] = 0
													_PlaySound(8)
													$iMarioJumpStep = 12
											EndSwitch
										Case Else ;Alle anderen werden getötet, Icon wird auf Kopf gestellt
											$aMOV[$iLVL][$i][0] = 2
											$aMOV[$iLVL][$i][10] = 8
											$aMOV[$iLVL][$i][8] += 100
											_PlaySound(8)
											$iMarioJumpStep = 12
											;_MarioAddMoney(1000, $aMOV[$iLVL][$i][1]+$aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2]+$aMOV[$iLVL][$i][4])
									EndSwitch
									If $aKeyReturn[38] > 1 Then $iMarioJumpStep = 20
									Return
							EndSwitch
						EndIf
						If BitAND($aMOV[$iLVL][$i][7], 16) Then ;Berühren
							Switch $iMY
								Case $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] - 38 To $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4] + $aMOV[$iLVL][$i][6] + $iMH - 38
									Switch $aMOV[$iLVL][$i][9]
										Case $M_PILZ, $M_BLME ;Mario wird größer
											$aMOV[$iLVL][$i][0] = 0
											_MarioWachsen($aMOV[$iLVL][$i][9])
											_MarioAddMoney(1000, $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4])
										Case $M_WMAN, $M_SKRT, $M_PFNZ, $M_FSKR ;Mario wird kleiner
											_MarioSchrumpfen($i)
											Return
										Case $M_STRN ;Unverwundbar
											$aMOV[$iLVL][$i][0] = 0
											$iMarioMoney += 1000
											Switch $bMarioStern
												Case False
													$bMarioStern = True
													$iMarioSternStep = Int(Not $bTimerStep)
													_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
													_BASS_ChannelPlay($hBassDll, $hMSC[29][0], 1)
												Case Else
													$iMarioSternStep = Int(Not $bTimerStep)
											EndSwitch
										Case $M_PNZR ; Panzer starten/stoppen
											Switch $aMOV[$iLVL][$i][13]
												Case 0
													$aMOV[$iLVL][$i][7] = BitOR(1, 16)
													Switch $iMX + 10
														Case $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] - 20 To $aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3] + $aMOV[$iLVL][$i][5] / 2
															$aMOV[$iLVL][$i][13] = 5
															If _CheckWandL($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][5], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][13] = -5
														Case Else
															$aMOV[$iLVL][$i][13] = -5
															If _CheckWandR($aMOV[$iLVL][$i][1] + $aMOV[$iLVL][$i][3], $aMOV[$iLVL][$i][2] + $aMOV[$iLVL][$i][4], $aMOV[$iLVL][$i][6], $aReturn) Then $aMOV[$iLVL][$i][13] = 5
													EndSwitch
													$aMOV[$iLVL][$i][12] = 12; solange nicht 0, kann Panzer nicht mehr gestoppt werden
												Case Else
													If $aMOV[$iLVL][$i][12] = 0 Then
														_MarioSchrumpfen($i)
														Return
													EndIf
											EndSwitch
										Case $M_KNKG
											_MarioSchrumpfen($i)
											Return
									EndSwitch
									ContinueLoop
							EndSwitch
						EndIf
						If BitAND($aMOV[$iLVL][$i][7], 4) Then ;von Links
						EndIf
						If BitAND($aMOV[$iLVL][$i][7], 8) Then ;von Rechts
						EndIf
				EndSwitch
		EndSwitch
	Next
EndFunc   ;==>_MarioCheckMOVCollision

Func _MarioWachsen($iType)
	Switch $iType
		Case $M_PILZ
			If $iMarioSize = 0 Then $iMarioSize += 1
			_PlaySound(7)
		Case $M_BLME
			$iMarioSize = 2
			_PlaySound(6)
	EndSwitch
	If $iMarioSize > 2 Then $iMarioSize = 2
	$bMarioHurt = False
EndFunc   ;==>_MarioWachsen

Func _MarioSchrumpfen($iI)
	If $bMarioHurt Then Return
	Switch $bMarioStern
		Case False
			$iMarioSize -= 1
			If $bDebug And $iMarioSize < 0 Then $iMarioSize = 0
			If $iMarioSize < 0 Then
				$iMarioJumpStep = 12
				_MarioDeath()
				Return
			EndIf
			$bMarioHurt = True
			$iMarioHurtStep = Int(Not $bTimerStep)
			_PlaySound(11)
		Case Else
			If $iI = 0 Then Return
			$aMOV[$iLVL][$iI][0] = 2
			$aMOV[$iLVL][$iI][10] = 8
			$aMOV[$iLVL][$iI][8] += 100
			_PlaySound(8)
	EndSwitch
EndFunc   ;==>_MarioSchrumpfen

Func _MarioAddMoney($iMoney, $iX = 0, $iY = 0)
	If $iX = 0 Then $iX = Abs($iLandX) + $iMarioX
	If $iY = 0 Then $iY = $iMarioY
	$iAddMoneyX = $iX
	$iAddMoneyY = $iY
	$iAddMoneyStep = 0
	$sAddMoney = String($iMoney)
	$iMarioMoney += $iMoney
EndFunc   ;==>_MarioAddMoney

Func _MarioAddCoin()
	$iMarioTaler += 1
	If $iMarioTaler >= 150 Then
		_PlaySound(18)
		$iMarioLeben += 1
		$iMarioTaler = 0
	EndIf
EndFunc   ;==>_MarioAddCoin

Func _MarioDeath()
	$iMarioJumpStep = 12
	Switch $bMarioStern
		Case True
			_BASS_ChannelStop($hBassDll, $hMSC[29][0])
			_BASS_ChannelPlay($hBassDll, $hMSC[28][0], 1)
		Case Else
			_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
			_BASS_ChannelPlay($hBassDll, $hMSC[28][0], 1)
	EndSwitch
	Do
		$iMarioY -= $iMarioJumpStep * 0.5
		$iMarioJumpStep -= 1
		_WinAPI_RedrawWindow_($hGui)
		_Sleep($iTimerDelay)
	Until $iMarioY > 240
	If $bSoundEnabled And $hBassDll > 0 Then
		Do
			Sleep(100)
		Until _BASS_ChannelIsActive($hBassDll, $hMSC[28][0]) <> 1
	Else
		Sleep(1000)
	EndIf
	$iMarioLeben -= 1
	If $iMarioLeben >= 0 Then
		_LoadLevel(@ScriptDir & "\LVL\" & $aLevels[$iLevelSelected])
	Else
		;_MarioEnd()
		_MarioQuit(False)
	EndIf
EndFunc   ;==>_MarioDeath

Func _MarioLevelComplete($X, $Y)
	$bCompleteText = False
	$iMarioX = $iLandX + $aSTN[$iLVL][$X][$Y][1] - 12
	$iMarioRunSpeed = 0
	$iMarioJumpStep = 0
	$bCompleteLevel = True
	$iMarioCompleteIcon = 33 + $iMarioSize * 2
	Local $iFahne = 999
	For $i = 1 To $aMOV[$iLVL][0][0]
		If $aMOV[$iLVL][$i][9] <> $M_FAHN Then ContinueLoop
		$iFahne = $i
		ExitLoop
	Next
	While $iMarioY < 220 - 38
		$iMarioY += 6
		$aMOV[$iLVL][$iFahne][4] -= 5
		If $iMarioY > 220 - 38 Then $iMarioY = 220 - 38
		_WinAPI_RedrawWindow_($hGui)
		_Sleep($iTimerDelay)
	WEnd
	$iOffset = 0
	While Abs($iLandX) + $iMarioX < $iZielXPos
		$iMarioX += 4
		$iMarioRunStep += 1
		$iMarioCompleteIcon = 1 + $iMarioSize * 5
		Switch $iMarioRunStep
			Case 0 To 1
			Case 2 To 3
				$iMarioCompleteIcon += 1
			Case 4 To 5
				$iMarioCompleteIcon += 2
			Case 6
				$iMarioCompleteIcon += 1
			Case Else
				$iMarioCompleteIcon += 1
				$iMarioRunStep = 0
		EndSwitch
		_WinAPI_RedrawWindow_($hGui)
		_Sleep($iTimerDelay)
	WEnd
	$bCompleteText = True
	$iMarioX = $iLandX + $iZielXPos
	$iMarioCompleteIcon = 39 + $iMarioSize
	_WinAPI_RedrawWindow_($hGui)
	Switch $bMarioStern
		Case True
			_BASS_ChannelStop($hBassDll, $hMSC[29][0])
		Case Else
			_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
	EndSwitch
	Switch $bSoundEnabled
		Case True
			_PlaySound(15)
		Case Else
			Sleep(1000)
	EndSwitch
	_MarioQuit(False)
EndFunc   ;==>_MarioLevelComplete

Func _EnterSubLevel($X, $Y)
	Local $iSubLevel, $iXPos, $iYPos, $iSize = 20
	If $iMarioSize > 0 Then $iSize = 38
	$iSubLevel = $aSTN[$iLVL][$X][$Y][10]
	$iXPos = $aSTN[$iLVL][$X][$Y][11]
	$iYPos = $aSTN[$iLVL][$X][$Y][12]
	If $iYPos = 0 Then $iYPos = 12
	$bEnterSublevel = True
	Switch $aSTN[$iLVL][$X][$Y][9]
		Case $S_RORO ; Eingang von oben
			$iMarioEnterSubLevelIcon = 39 + $iMarioSize
			$iMarioX = $iLandX + $aSTN[$iLVL][$X][$Y][1] + 10
			_PlaySound(9)
			For $i = 1 To $iSize
				$iMarioY += 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case $S_RORU ; Eingang von unten
			$iMarioEnterSubLevelIcon = 39 + $iMarioSize
			$iMarioX = $iLandX + $aSTN[$iLVL][$X][$Y][1] + 10
			_PlaySound(9)
			For $i = 1 To $iSize
				$iMarioY -= 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case $S_RORL ; Eingang von links
			$iMarioEnterSubLevelIcon = $iMarioSize * 5 + 1
			$iMarioY = $aSTN[$iLVL][$X][$Y][2] + 1
			_PlaySound(9)
			For $i = 1 To 20
				$iMarioX += 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case $S_RORR ; Eingang von rechts
			$iMarioEnterSubLevelIcon = $iMarioSize * 5 + 16
			$iMarioY = $aSTN[$iLVL][$X][$Y][2] + 1
			_PlaySound(9)
			For $i = 1 To 20
				$iMarioX -= 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
	EndSwitch
	For $i = 1 To $aMOV[$iLVL][0][0] ;Entferne unnötige MOV
		Switch $aMOV[$iLVL][$i][0]
			Case 0
				ContinueLoop
			Case 2
				$aMOV[$iLVL][$i][0] = 0
			Case Else
				Switch $aMOV[$iLVL][$i][9]
					Case $M_PFNZ
						$aMOV[$iLVL][$i][11] = 0
						$aMOV[$iLVL][$i][4] = 0
					Case Else
						_MOVReset($i)
				EndSwitch
		EndSwitch
	Next
	For $X = 1 To 399
		For $Y = 1 To 12
			If Not $aSTN[$iLVL][$X][$Y][0] Or ($aSTN[$iLVL][$X][$Y][9] <> $S_GELB And $aSTN[$iLVL][$X][$Y][9] <> $S_STNR) Then ContinueLoop
			Switch $aSTN[$iLVL][$X][$Y][9]
				Case $S_GELB
					$aSTN[$iLVL][$X][$Y][10] = 0
				Case $S_STNR
					If $aSTN[$iLVL][$X][$Y][4] > 0 Then $aSTN[$iLVL][$X][$Y][0] = 0
			EndSwitch
		Next
	Next
	If $iSubLevel <> $iLVL Then
		If Not $bMarioStern Then _BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
		$iLVL = $iSubLevel
		If Not $bMarioStern Then _BASS_ChannelPlay($hBassDll, $hMSC[$iLVL][0], 1)
	EndIf
	_DrawStaticBackGround()
	$iMarioX = $iLandX + (($iXPos - 1) * 20)
	Select
		Case $iMarioX < 145
			$iLandX += 145 - $iMarioX
			If $iLandX < 0 Then
				$iMarioX += 145 - $iMarioX
			Else
				$iLandX = 0
			EndIf
		Case $iMarioX > 175
			$iLandX += 175 - $iMarioX
			If $iLandX > -6400 Then
				$iMarioX += 175 - $iMarioX
			Else
				$iLandX = -6400
			EndIf
	EndSelect
	If $iMarioX < 10 Then $iMarioX = 10
	If $iMarioX > 290 Then $iMarioX = 290
	Switch $aSTN[$iSubLevel][$iXPos][$iYPos][9]
		Case $S_RORU ;Ausgang nach unten
			$iMarioEnterSubLevelIcon = 39 + $iMarioSize
			$iMarioX = $iLandX + ($iXPos * 20 - 10)
			$iMarioY = 240 - $iYPos * 20 - 18
			For $i = 1 To $iSize
				$iMarioY += 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case $S_RORO ;Ausgang nach oben
			$iMarioEnterSubLevelIcon = 39 + $iMarioSize
			$iMarioX = $iLandX + ($iXPos * 20 - 10)
			$iMarioY = 240 - $iYPos * 20 - (38 - $iSize)
			For $i = 1 To $iSize
				$iMarioY -= 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case $S_RORR ;Ausgang nach rechts
			$iMarioEnterSubLevelIcon = $iMarioSize * 5 + 1
			$iMarioX = $iLandX + ($iXPos * 20 - 20)
			$iMarioY = 240 - $iYPos * 20 + 1
			For $i = 1 To 20
				$iMarioX += 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case $S_RORL ;Ausgang nach links
			$iMarioEnterSubLevelIcon = $iMarioSize * 5 + 16
			$iMarioX = $iLandX + ($iXPos * 20 - 20)
			$iMarioY = 240 - $iYPos * 20 + 1
			For $i = 1 To 20
				$iMarioX -= 1
				_WinAPI_RedrawWindow_($hGui)
				_Sleep($iTimerDelay)
			Next
		Case Else
			$iMarioX = $iLandX + ($iXPos * 20)
			$iMarioY = 0
	EndSwitch
	$iMarioRunSpeed = 0
	$iMarioJumpStep = 0
	$bEnterSublevel = False
EndFunc   ;==>_EnterSubLevel

Func _Sleep($iTime)
	While TimerDiff($iSleep) <= $iTime
	WEnd
	$iSleep = TimerInit()
EndFunc   ;==>_Sleep
#EndRegion KollisionsCheck


#Region Move
Func _MarioMove()
	If $bEnterSublevel Then Return
	$iMarioFireStep += 1
	Switch $bMarioHurt
		Case True
			$iMarioHurtStep += 1
			If $iMarioHurtStep > 200 Then $bMarioHurt = False
		Case Else
			$iMarioHurtStep = 0
	EndSwitch
	Switch $bMarioStern
		Case True
			$iMarioHurtStep = 0
			$iMarioSternStep += 1
			Select
				Case $iMarioSternStep = 1
					_BASS_ChannelSetAttribute($hBassDll, $hMSC[29][0], 0x10002, 44100)
				Case $iMarioSternStep > 1000
					$bMarioStern = False
					_BASS_ChannelStop($hBassDll, $hMSC[29][0])
					_BASS_ChannelSetAttribute($hBassDll, $hMSC[29][0], 0x10002, 44100)
					_BASS_ChannelPlay($hBassDll, $hMSC[$iLVL][0], 0)
				Case $iMarioSternStep > 900
					_BASS_ChannelSetAttribute($hBassDll, $hMSC[29][0], 0x10002, 44100 - ($iMarioSternStep - 900) * 400)
			EndSelect
		Case Else
			$iMarioSternStep = 0
	EndSwitch
	Switch $bMarioDown
		Case True
			Local $aReturn
			$bDecke = _CheckDecke(Abs($iLandX) + $iMarioX + 10, $iMarioY + 38 - 21, $aReturn)
			If Not $bDecke Then $bMarioDown = False
	EndSwitch
	Switch $iMarioSize
		Case 0 To 2
			Local $aKeys = _WinAPI_GetKeyboardState_Mario()
			Switch 1
				Case $aKeys[37] > 1
					_Left($aKeys[38], $aKeys[40], $aKeys[32])
				Case $aKeys[39] > 1
					_Right($aKeys[38], $aKeys[40], $aKeys[32])
				Case $aKeys[38] > 1
					_NotMove()
					_Jump($aKeys[32])
				Case $aKeys[40] > 1
					_NotMove()
					_Down($aKeys[32])
				Case $aKeys[32] > 1
					_NotMove()
					_Fire()
				Case $aKeys[27] > 1
					_MarioQuit()
					Return True
				Case Else
					_NotMove()
			EndSwitch
			$iMarioY -= $iMarioJumpStep * 0.5
			$iMarioJumpStep -= 1
			If $iMarioJumpStep < -18 Then $iMarioJumpStep = -18
			$iMarioRunSpeed = Round($iMarioRunSpeed, 1)
			$iMarioX += $iMarioRunSpeed
		Case Else
			;_MarioKilled()
	EndSwitch
	Switch $bMarioDown
		Case True
			$iMarioJumpHeight = 24
		Case Else
			$iMarioJumpHeight = 20
	EndSwitch
	If $iMarioY > 240 Then _MarioDeath()
	Return False
EndFunc   ;==>_MarioMove

Func _NotMove()
	Select
		Case $iMarioRunSpeed > -0.5 And $iMarioRunSpeed < 0.5 And $iMarioRunSpeed <> 0
			$iMarioRunSpeed = 0
			$iMarioRunStep = 0
		Case $iMarioRunSpeed > 0
			$iMarioRunSpeed -= 0.5
			$iMarioRunStep += 1
		Case $iMarioRunSpeed < 0
			$iMarioRunSpeed += 0.5
			$iMarioRunStep += 1
		Case $iMarioRunSpeed = 0
			$iMarioRunStep = 0
	EndSelect
EndFunc   ;==>_NotMove

Func _Fire()
	If $iMarioFireStep < 20 Or $iMarioSize <> 2 Or $bMarioDown Then Return
	$iMarioFireStep = 0
	Switch $bMarioLeft
		Case True
			$bMarioFire = True
			_AddMOVItem($M_FIRE, Abs($iLandX) + $iMarioX + 3, $iMarioY + 0, -6, 6)
		Case Else
			$bMarioFire = True
			_AddMOVItem($M_FIRE, Abs($iLandX) + $iMarioX + 17, $iMarioY + 0, 6, 6)
	EndSwitch
EndFunc   ;==>_Fire

Func _Down($bFire = 1)
	If $bFire > 1 Then _Fire()
	$bMarioDown = True
EndFunc   ;==>_Down


Func _Jump($bFire = 1)
	If $bFire > 1 Then _Fire()
	If $bBoden And Not $bDecke Then
		$iMarioJumpStep = $iMarioJumpHeight
		_PlaySound(2)
	EndIf
EndFunc   ;==>_Jump

Func _Left($bUp, $bDown, $bFire = 1)
	If $bFire > 1 Then _Fire()
	If $bUp > 1 And $bBoden And Not $bDecke Then
		$iMarioJumpStep = $iMarioJumpHeight
		_PlaySound(2)
	EndIf
	Switch $bMarioLeft
		Case False
			$bMarioLeft = True
			$iMarioRunStep = 0
	EndSwitch
	If $bDown > 1 Then
		Select
			Case $iMarioRunSpeed > 0
				$iMarioRunSpeed -= 0.1
			Case $iMarioRunSpeed < 0
				$iMarioRunSpeed += 0.1
		EndSelect
		$bMarioDown = True
	Else
		$iMarioRunStep += 1
		$iMarioRunSpeed -= 0.5
	EndIf
	If $iMarioRunSpeed < -4 Then $iMarioRunSpeed = -4
EndFunc   ;==>_Left

Func _Right($bUp, $bDown, $bFire = 1)
	If $bFire > 1 Then _Fire()
	If $bUp > 1 And $bBoden And Not $bDecke Then
		$iMarioJumpStep = $iMarioJumpHeight
		_PlaySound(2)
	EndIf
	Switch $bMarioLeft
		Case True
			$bMarioLeft = False
			$iMarioRunStep = 0
	EndSwitch
	If $bDown > 1 Then
		Select
			Case $iMarioRunSpeed > 0
				$iMarioRunSpeed -= 0.1
			Case $iMarioRunSpeed < 0
				$iMarioRunSpeed += 0.1
		EndSelect
		$bMarioDown = True
	Else
		$iMarioRunStep += 1
		$iMarioRunSpeed += 0.5
	EndIf
	If $iMarioRunSpeed > 4 Then $iMarioRunSpeed = 4
EndFunc   ;==>_Right

#EndRegion Move



#Region Draw
Func _WM_ERASEBKGND($hWnd, $Msg, $wParam, $lParam)
	Switch $bDrawBackground
		Case True
			Switch $iMenu
				Case -1
					_DrawBackGround()
					_DrawMario()
				Case 99 ; Quit Game
					_DrawBackGround()
					_DrawMario()
					_DrawText($hGraphics, "Quit Level", 105, 90)
					_DrawText($hGraphics, "(Y)es", 130, 110)
					_DrawText($hGraphics, "(N)o", 130, 130)
				Case Else
					_DrawBackgroundMenu()
					Switch $bCreditEnd
						Case True
							_DrawText($hGraphics, "THX 4 Playing", 90, 120)
							_DrawText($hGraphics, "press any key...", 80, 140)
					EndSwitch
			EndSwitch
			Local $hGraphicsTemp = _GDIPlus_GraphicsCreateFromHDC($wParam)
			_GDIPlus_GraphicsDrawImageRect($hGraphicsTemp, $hBitmap, 68 * $nLandF, 23 * $nLandF, 320 * $nLandF, 240 * $nLandF)
			_GDIPlus_GraphicsDispose($hGraphicsTemp)
		Case Else
			Local $tRect = DllStructCreate("long;long;long;long")
			DllStructSetData($tRect, 1, 0);$nLeft)
			DllStructSetData($tRect, 2, 0);$nTop)
			DllStructSetData($tRect, 3, $nRight - $nLeft)
			DllStructSetData($tRect, 4, $nBottom - $nTop)
			_WinAPI_FillRect($wParam, DllStructGetPtr($tRect), $hBrush)
			_WinAPI_DrawIconEx($wParam, 0, 0, $hIcon, 428 * $nLandF, 282 * $nLandF)
			$tRect = 0
			Local $hGraphicsTemp = _GDIPlus_GraphicsCreateFromHDC($wParam)
			_GDIPlus_GraphicsDrawImageRect($hGraphicsTemp, $hBitmap, 68 * $nLandF, 23 * $nLandF, 320 * $nLandF, 240 * $nLandF)
			_GDIPlus_GraphicsDispose($hGraphicsTemp)
	EndSwitch
	;_WinAPI_DrawIconEx($wParam, 0, 0, $hIcon, 428*$nLandF, 282*$nLandF)
	Return True
EndFunc   ;==>_WM_ERASEBKGND

Func _DrawMario()
	If Not $bCompleteLevel And (Mod($iMarioHurtStep, 3) = 1 Or Mod($iMarioSternStep, 3) = 1 Or $bEnterSublevel) Then Return
	Switch $bCompleteLevel
		Case True
			If $bCompleteText Then _StatusDrawText($hGraphics, "Level complete", 90, 100)
			_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_HRO[$iMarioCompleteIcon], $iMarioX, $iMarioY)
			Return
	EndSwitch
	Switch $bMarioFire
		Case True
			_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_HRO[31 + $bMarioLeft], $iMarioX, $iMarioY)
			If $iMarioFireStep > 4 Then $bMarioFire = False
			Return
	EndSwitch
	Switch $iMarioSize
		Case -1
			_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_HRO[5], $iMarioX, $iMarioY)
			Return
		Case 0
			$iMarioIcon = 1
		Case 1
			$iMarioIcon = 6
		Case Else
			$iMarioIcon = 11
	EndSwitch
	Switch $bBoden
		Case True
			Switch $iMarioRunStep
				Case 0 To 1
					$iMarioIcon += 0
				Case 2 To 3
					$iMarioIcon += 1
				Case 4 To 5
					$iMarioIcon += 2
				Case 6 To 7
					$iMarioIcon += 1
				Case Else
					$iMarioIcon += 0
					$iMarioRunStep = 0
			EndSwitch
			If $iMarioSize = 1 And $bMarioDown Then $iMarioIcon = 10
			If $iMarioSize > 1 And $bMarioDown Then $iMarioIcon = 15
		Case Else
			$iMarioIcon += 3
	EndSwitch
	If $bMarioLeft Then $iMarioIcon += 15
	;$iMarioIcon=39
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_HRO[$iMarioIcon], $iMarioX, $iMarioY)
	If $bPause Then _StatusDrawText($hGraphics, "Paused", 125, 105)
EndFunc   ;==>_DrawMario

Func _DrawBackGround()
	Select
		Case $iMarioX < 145
			$iLandX += 145 - $iMarioX
			If $iLandX < 0 Then
				$iMarioX += 145 - $iMarioX
			Else
				$iLandX = 0
			EndIf
		Case $iMarioX > 175
			$iLandX += 175 - $iMarioX
			If $iLandX > $aLevelWidth[$iLVL] * - 20 + 320 Then
				$iMarioX += 175 - $iMarioX
			Else
				$iLandX = $aLevelWidth[$iLVL] * - 20 + 320
			EndIf
	EndSelect
	If $iMarioX < 10 Then $iMarioX = 10
	If $iMarioX > 290 Then $iMarioX = 290
	For $i = 0 To 7 ;Zeichne Hintergrund
		If $iLandX / 3 + 320 * $i <= -320 Or $iLandX / 3 + 320 * $i > 319 Then ContinueLoop
		_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_BKG[Mod($i, 2) + $aBKGIndex[$iLVL]], $iLandX / 3 + 320 * $i, 0)
	Next
	;
	If $bEnterSublevel Then _GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_HRO[$iMarioEnterSubLevelIcon], $iMarioX, $iMarioY)
	;_GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hBitmapBK, Abs($iLandX), 0, 320, 240, 0, 0, 320, 240)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapBK, Floor($iLandX), 0)
	Local $iStartX = Floor(Abs($iLandX) / 20)
	For $X = $iStartX To $iStartX + 17
		For $Y = 1 To 12
			;If $aSBK[$iLVL][$X][$Y] Then _GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_SBK[$aSBK[$iLVL][$X][$Y]], $iLandX + ($X - 1) * 20, 240 - $Y * 20)
			Switch $aSTN[$iLVL][$X][$Y][0]
				Case 1
					Switch $aSTN[$iLVL][$X][$Y][9]
						Case $S_MAUR, $S_FRGZ, $S_STNR, $S_MAU2, $S_GELB
							_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_STN[$aSTN[$iLVL][$X][$Y][8]], $iLandX + $aSTN[$iLVL][$X][$Y][1] + $aSTN[$iLVL][$X][$Y][3], $aSTN[$iLVL][$X][$Y][2] + $aSTN[$iLVL][$X][$Y][4])
					EndSwitch
				Case 2 ; Money
					_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MOV[$iMoneyIcon], $iLandX + $aSTN[$iLVL][$X][$Y][1] + $aSTN[$iLVL][$X][$Y][3], $aSTN[$iLVL][$X][$Y][2] + $aSTN[$iLVL][$X][$Y][4])
				Case 3 ; Pflanze
					_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MOV[$iPlantIcon + $aSTN[$iLVL][$X][$Y][8]], $iLandX + $aSTN[$iLVL][$X][$Y][1] + $aSTN[$iLVL][$X][$Y][3], $aSTN[$iLVL][$X][$Y][2] + $aSTN[$iLVL][$X][$Y][4])
			EndSwitch
		Next
	Next
	For $X = 1 To $aMOV[$iLVL][0][0]
		If $aMOV[$iLVL][$X][0] And $iLandX + $aMOV[$iLVL][$X][1] + $aMOV[$iLVL][$X][3] > -20 And $iLandX + $aMOV[$iLVL][$X][1] + $aMOV[$iLVL][$X][3] < 320 Then _GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MOV[$aMOV[$iLVL][$X][8]], $iLandX + $aMOV[$iLVL][$X][1] + $aMOV[$iLVL][$X][3], $aMOV[$iLVL][$X][2] + $aMOV[$iLVL][$X][4])
	Next
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapFR, Floor($iLandX), 0)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapTXT, 0, 0)
	_DrawStatus()
	If $sMessageText <> "" Then _StatusDrawText($hGraphics, $sMessageText, 160 - StringLen($sMessageText) / 2 * 10, 100)
	If $bDebug Then _StatusDrawText($hGraphics, "X: " & StringFormat("%03s", Floor((Abs($iLandX) + $iMarioX + 10) / 20)) & "   Y: " & StringFormat("%03s", 12 - Round(($iMarioY + 38) / 20)), 90, 60, 1)
EndFunc   ;==>_DrawBackGround


Func _DrawStaticBackGround()
	_GDIPlus_GraphicsDispose($hGraphicsBK)
	_GDIPlus_BitmapDispose($hBitmapBK)
	$hBitmapBK = _GDIPlus_BitmapCreateFromGraphics($aLevelWidth[$iLVL] * 20, 240, $hGraphicDC)
	$hGraphicsBK = _GDIPlus_ImageGetGraphicsContext($hBitmapBK)
	_GDIPlus_GraphicsDispose($hGraphicsFR)
	_GDIPlus_BitmapDispose($hBitmapFR)
	$hBitmapFR = _GDIPlus_BitmapCreateFromGraphics($aLevelWidth[$iLVL] * 20, 240, $hGraphicDC)
	$hGraphicsFR = _GDIPlus_ImageGetGraphicsContext($hBitmapFR)
	For $X = 1 To $aLevelWidth[$iLVL]
		For $Y = 1 To 12
			If $aSBK[$iLVL][$X][$Y] Then _GDIPlus_GraphicsDrawImage($hGraphicsBK, $aGFX_SBK[$aSBK[$iLVL][$X][$Y]], ($X - 1) * 20, 240 - $Y * 20)
			If $aSTN[$iLVL][$X][$Y][0] <> 1 Then ContinueLoop
			Switch $aSTN[$iLVL][$X][$Y][9]
				Case $S_RORO, $S_RORU, $S_RORL, $S_RORR, $S_RORV, $S_RORH, $S_RASL, $S_RASM, $S_RASR, $S_STNE, $S_KANO, $S_FANO, $S_FANS, $S_TRAL, $S_TRAM, $S_TRAR, $S_PALL, $S_PALM, $S_PALR
					_GDIPlus_GraphicsDrawImage($hGraphicsFR, $aGFX_STN[$aSTN[$iLVL][$X][$Y][8]], $aSTN[$iLVL][$X][$Y][1] + $aSTN[$iLVL][$X][$Y][3], $aSTN[$iLVL][$X][$Y][2] + $aSTN[$iLVL][$X][$Y][4])
			EndSwitch
		Next
	Next
EndFunc   ;==>_DrawStaticBackGround

Func _DrawStatus()
	Switch $iAddMoneyStep ; Zeigt das Geld an, das man gerade geerntet hat (Schildkröte tot: +100, Blume: +1000 usw...)
		Case 0 To 30
			Local $aMoney = StringSplit($sAddMoney, "", 2)
			$iAddMoneyY -= 1
			$iAddMoneyStep += 1
			_StatusDrawText($hGraphics, $sAddMoney, $iLandX + $iAddMoneyX, $iAddMoneyY, 0.8)
	EndSwitch
	_StatusDrawText($hGraphics, StringFormat("%06s", $iMarioMoney), 0, 9)
	$iStatusMoneyStep += 1
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MOV[$iMoneyIcon], 9, 20)
	_StatusDrawText($hGraphics, String($iMarioTaler), 30, 24)
	_StatusDrawText($hGraphics, StringFormat("%02s", $iMarioLeben), 275, 9)
	_StatusDrawText($hGraphics, StringFormat("%03s", $iLevelTime), 265, 24)
EndFunc   ;==>_DrawStatus

Func _StatusDrawText($hGraphics, $sText, $iX, $iY, $nF = 1)
	Local $aText = StringSplit($sText, ""), $iXOff = 0, $iIcon = 0
	If Not IsArray($aText) Then Return
	For $i = 1 To $aText[0]
		$aText[$i] = StringUpper($aText[$i])
		Switch $aText[$i]
			Case " "
				$iXOff += 3
				ContinueLoop
			Case "I"
				$iXOff += 8 * $nF
			Case Else
				$iXOff += 10 * $nF
		EndSwitch
		Switch $aText[$i]
			Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
				$iIcon = Asc($aText[$i]) - 42
			Case "A" To "Z"
				$iIcon = Asc($aText[$i]) - 49
			Case ":"
				$iIcon = 45
			Case "+"
				$iIcon = 42
		EndSwitch
		Switch $nF
			Case 1
				_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_TXT[$iIcon], $iX + $iXOff, $iY)
			Case Else
				_GDIPlus_GraphicsDrawImageRect($hGraphics, $aGFX_TXT[$iIcon], $iX + $iXOff, $iY, 12 * $nF, 10 * $nF)
		EndSwitch
	Next
EndFunc   ;==>_StatusDrawText
#EndRegion Draw



#Region Load Level / GFX

Func _AddMOVItem($Type, $X, $Y, $P1 = 0, $P2 = 0, $P3 = 0)
	Local $iIndex = $aMOV[$iLVL][0][0] + 1, $bClear = False
	If $iIndex > 999 Then Return
	$aMOV[$iLVL][$iIndex][0] = 1
	$aMOV[$iLVL][$iIndex][1] = ($X - 1) * 20
	$aMOV[$iLVL][$iIndex][2] = 240 - $Y * 20
	$aMOV[$iLVL][$iIndex][3] = 0
	$aMOV[$iLVL][$iIndex][4] = 0
	$aMOV[$iLVL][$iIndex][5] = 20
	$aMOV[$iLVL][$iIndex][6] = 20
	$aMOV[$iLVL][$iIndex][7] = 16 ;Standartmässig nur berühren
	$aMOV[$iLVL][$iIndex][8] = 0 ;Icon
	$aMOV[$iLVL][$iIndex][9] = $Type
	$aMOV[$iLVL][$iIndex][10] = 0 ;P1
	$aMOV[$iLVL][$iIndex][11] = 0 ;P2
	$aMOV[$iLVL][$iIndex][12] = 0 ;P3
	$aMOV[$iLVL][$iIndex][13] = 0 ;Move X
	$aMOV[$iLVL][$iIndex][14] = 0 ;Move Y
	$aMOV[$iLVL][$iIndex][15] = True ;Jump / Fallen On
	$aMOV[$iLVL][$iIndex][16] = 0 ;Jumpstep
	Switch $Type
		Case $M_FIRE
			Local $aReturn
			$aMOV[$iLVL][$iIndex][0] = 4
			$aMOV[$iLVL][$iIndex][1] = $X
			$aMOV[$iLVL][$iIndex][2] = $Y
			$aMOV[$iLVL][$iIndex][5] = 12
			$aMOV[$iLVL][$iIndex][6] = 12
			$aMOV[$iLVL][$iIndex][7] = 0
			$aMOV[$iLVL][$iIndex][8] = 1
			$aMOV[$iLVL][$iIndex][10] = 0
			$aMOV[$iLVL][$iIndex][13] = $P1 ; X Richtung
			$aMOV[$iLVL][$iIndex][14] = $P2 ; Y
			$bClear = True
			Select
				Case $P1 < 0
					If _CheckWandR($aMOV[$iLVL][$iIndex][1] + $aMOV[$iLVL][$iIndex][3], $aMOV[$iLVL][$iIndex][2] + $aMOV[$iLVL][$iIndex][4], $aMOV[$iLVL][$iIndex][6], $aReturn) Then $aMOV[$iLVL][$iIndex][0] = 0
				Case $P1 > 0
					If _CheckWandL($aMOV[$iLVL][$iIndex][1] + $aMOV[$iLVL][$iIndex][3], $aMOV[$iLVL][$iIndex][2] + $aMOV[$iLVL][$iIndex][4], $aMOV[$iLVL][$iIndex][5], $aMOV[$iLVL][$iIndex][6], $aReturn) Then $aMOV[$iLVL][$iIndex][0] = 0
			EndSelect
			_PlaySound(4)
		Case $M_MONY
			$aMOV[$iLVL][$iIndex][0] = 1
			$aMOV[$iLVL][$iIndex][7] = 0
			$aMOV[$iLVL][$iIndex][8] = $iMoneyIcon
			$aMOV[$iLVL][$iIndex][9] = $M_MONY
			$aMOV[$iLVL][$iIndex][14] = -8
			$aMOV[$iLVL][$iIndex][15] = 0
			$bClear = True
			_MarioAddMoney(200, $aMOV[$iLVL][$iIndex][1] - 10, $aMOV[$iLVL][$iIndex][2] - 10)
			_PlaySound(1)
		Case $M_ZERB
			$aMOV[$iLVL][$iIndex][0] = 3
			$aMOV[$iLVL][$iIndex][1] = ($X - 1) * 20 + 5
			$aMOV[$iLVL][$iIndex][2] = 240 - $Y * 20 + 10
			$aMOV[$iLVL][$iIndex][5] = 10
			$aMOV[$iLVL][$iIndex][6] = 8
			$aMOV[$iLVL][$iIndex][7] = 0
			$aMOV[$iLVL][$iIndex][8] = $P1 ; Icon
			$aMOV[$iLVL][$iIndex][13] = $P2 ; X Richtung
			$aMOV[$iLVL][$iIndex][14] = $P3 ; Y
			$bClear = True
		Case $M_PILZ
			$aMOV[$iLVL][$iIndex][8] = 3
			$aMOV[$iLVL][$iIndex][13] = -1
			$bClear = True
		Case $M_BLME
			$aMOV[$iLVL][$iIndex][8] = 4
			$aMOV[$iLVL][$iIndex][15] = False
			$bClear = True
		Case $M_WMAN
			$aMOV[$iLVL][$iIndex][7] = BitOR(1, 16) ;Draufspringen und berühren
			$aMOV[$iLVL][$iIndex][8] = 6
			$aMOV[$iLVL][$iIndex][13] = -1
		Case $M_STRN
			$aMOV[$iLVL][$iIndex][8] = 5
			$aMOV[$iLVL][$iIndex][13] = -2
			$aMOV[$iLVL][$iIndex][16] = 12
			$bClear = True
		Case $M_SKRT
			$aMOV[$iLVL][$iIndex][7] = BitOR(1, 16) ;Draufspringen und berühren
			$aMOV[$iLVL][$iIndex][2] -= 10
			$aMOV[$iLVL][$iIndex][6] = 30
			$aMOV[$iLVL][$iIndex][8] = 9
			$aMOV[$iLVL][$iIndex][13] = -1
		Case $M_FSKR
			$aMOV[$iLVL][$iIndex][7] = BitOR(1, 16) ;Draufspringen und berühren
			$aMOV[$iLVL][$iIndex][2] -= 10
			$aMOV[$iLVL][$iIndex][6] = 30
			$aMOV[$iLVL][$iIndex][8] = 31
			$aMOV[$iLVL][$iIndex][13] = -1
			$aMOV[$iLVL][$iIndex][16] = 12
		Case $M_AUFZ
			$aMOV[$iLVL][$iIndex][5] = 59
			$aMOV[$iLVL][$iIndex][6] = 9
			$aMOV[$iLVL][$iIndex][8] = 21
			$aMOV[$iLVL][$iIndex][13] = $P1
			$aMOV[$iLVL][$iIndex][14] = $P2
			$aMOV[$iLVL][$iIndex][15] = False
		Case $M_FAHN
			_SetStone_STN($iLVL, $X, $Y, $S_FANS, 0, 0, 0, 0, 0, 0)
			$aMOV[$iLVL][$iIndex][1] += 10
			$aMOV[$iLVL][$iIndex][7] = 16
			$aMOV[$iLVL][$iIndex][8] = 30
			$aMOV[$iLVL][$iIndex][15] = 0
		Case $M_KNKG
			$aMOV[$iLVL][$iIndex][0] = 5
			$aMOV[$iLVL][$iIndex][1] -= 25
			$aMOV[$iLVL][$iIndex][7] = 16
			$aMOV[$iLVL][$iIndex][15] = 0
			$aMOV[$iLVL][$iIndex][8] = 22
			$aMOV[$iLVL][$iIndex][13] = -6
			If $P1 Then
				$aMOV[$iLVL][$iIndex][1] += 50
				$aMOV[$iLVL][$iIndex][13] = 6
				$aMOV[$iLVL][$iIndex][8] = 23
			EndIf
			$bClear = True
			_PlaySound(17)
		Case $M_PFNZ
			$aMOV[$iLVL][$iIndex][1] += 10
			$aMOV[$iLVL][$iIndex][15] = 0
			Switch $P1
				Case $S_RORO
					$aMOV[$iLVL][$iIndex][10] = -1
					$aMOV[$iLVL][$iIndex][2] += 1
				Case $S_RORU
					$aMOV[$iLVL][$iIndex][10] = 1
					$aMOV[$iLVL][$iIndex][2] -= 11
			EndSwitch
	EndSwitch
	For $i = 10 To 16
		$aMOV[$iLVL][$iIndex][$i + 7] = $aMOV[$iLVL][$iIndex][$i]; Parameter sichern, damit Item resetet werden kann
	Next
	$aMOV[$iLVL][0][0] = $iIndex
	If $bClear Then _ClearMOV()
	Return $aMOV[$iLVL][0][0]
EndFunc   ;==>_AddMOVItem

Func _ClearMOV()
	Local $iIndex = 0
	For $i = 1 To $aMOV[$iLVL][0][0]
		If Not $aMOV[$iLVL][$i][0] Then ContinueLoop
		$iIndex += 1
		For $j = 0 To 23
			$aMOV[$iLVL][$iIndex][$j] = $aMOV[$iLVL][$i][$j]
		Next
	Next
	If $iIndex > 0 Then $aMOV[$iLVL][0][0] = $iIndex
EndFunc   ;==>_ClearMOV

Func _ResetVariables()
	Local $aSTN_X[20][400][13][20], $aSBK_X[20][400][13], $aMOV_X[20][1000][25], $aBKGIndex_X[20], $aLevelWidth_X[20]
	$iMarioX = 100
	$iMarioY = 0
	$iMarioSize = 0
	$iMarioJumpStep = 0
	$bMarioHurt = False
	$bMarioStern = False
	$aSTN = $aSTN_X
	$aSBK = $aSBK_X
	$aMOV = $aMOV_X
	$aBKGIndex = $aBKGIndex_X
	$aLevelWidth = $aLevelWidth_X
	$iMarioRunSpeed = 0
	$iMarioRunStep = 0
	$bBoden = True
	$bMarioLeft = False
	$iLandX = 0
	$iLVL = 0
	$iStartXPos = 0
	$iZielXPos = 0
	$bEnterSublevel = False
	$bCompleteLevel = False
	$iLevelTime = 300
	$iLevelTimeStep = 0
	$sMessageText = ""
EndFunc   ;==>_ResetVariables


Func _LoadLevel($sLevelFile)
	_ResetVariables()
	Local $aFile, $aLine, $aType, $aCoords, $aParam
	_FileReadToArray($sLevelFile, $aFile)
	If @error Or Not IsArray($aFile) Then _MarioQuit()
	For $i = 1 To $aFile[0]
		Select
			Case StringInStr($aFile[$i], "SUBLEVEL")
				$aLine = StringSplit($aFile[$i], "=", 2)
				$iLVL = $aLine[1]
			Case StringInStr($aFile[$i], "BACKGROUND")
				$aParam = StringSplit($aFile[$i], "=", 2)
				If $aParam[1] = 0 Then $aParam[1] += 1
				$aBKGIndex[$iLVL] = $aParam[1]
			Case StringRegExp($aFile[$i], "[SMB]\-\d+\h\d+\-\d+\h[\-0-9]+;[\-0-9]+;[\-0-9]+;[\-0-9]+;[\-0-9]+")
				$aLine = StringSplit($aFile[$i], " ", 2)
				$aType = StringSplit($aLine[0], "-", 2)
				$aCoords = StringSplit($aLine[1], "-", 2)
				$aParam = StringSplit($aLine[2], ";", 2)
				Switch $aType[0]
					Case "B" ; Set SBK
						_SetStone_SBK($iLVL, $aCoords[0], $aCoords[1], $aType[1])
					Case "M" ; Set MOV
						_SetStone_MOV($iLVL, $aCoords[0], $aCoords[1], $aType[1], $aParam[0], $aParam[1], $aParam[2], $aParam[3], $aParam[4], $aParam[5])
					Case "S" ; Set STN
						_SetStone_STN($iLVL, $aCoords[0], $aCoords[1], $aType[1], $aParam[0], $aParam[1], $aParam[2], $aParam[3], $aParam[4], $aParam[5])
				EndSwitch
				If $aLevelWidth[$iLVL] < Int($aCoords[0]) Then $aLevelWidth[$iLVL] = Int($aCoords[0])
				If $aLevelWidth[$iLVL] < 16 Then $aLevelWidth[$iLVL] = 16
			Case StringInStr($aFile[$i], "MUSIC")
				$aParam = StringSplit($aFile[$i], "=", 2)
				_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
				_BASS_StreamFree($hBassDll, $hMSC[$iLVL][0])
				_ResourceFree($hMSC[$iLVL][1])
				$hMSC[$iLVL][0] = _ResourceLoadSound("SFX.dat", "MSC" & $aParam[1], 1, True)
				$hMSC[$iLVL][1] = @extended
			Case StringInStr($aFile[$i], "TIME")
				$aParam = StringSplit($aFile[$i], "=", 2)
				$iLevelTime = $aParam[1]
		EndSelect
	Next
	$iLVL = 0
	Switch $iStartXPos
		Case 0
			$iMarioX = 100
			$iMarioY = 50
		Case Else
			$iMarioX = $iStartXPos
			$iMarioY = 220 - 38
	EndSwitch
	_DrawStaticBackGround()
	_WinAPI_RedrawWindow_($hGui)
	_PlaySound(14)
	_BASS_ChannelPlay($hBassDll, $hMSC[$iLVL][0], 1)
EndFunc   ;==>_LoadLevel

Func _SetStone_SBK($iI, $X, $Y, $Type)
	$aSBK[$iI][$X][$Y] = $Type + 1
	If $Type <> 2 Then Return
	Switch $iStartXPos
		Case 0
			$iStartXPos = ($X - 1) * 20
		Case Else
			$iZielXPos = ($X - 1) * 20
	EndSwitch
EndFunc   ;==>_SetStone_SBK

Func _SetStone_MOV($iI, $X, $Y, $Type, $P1, $P2, $P3, $p4, $p5, $p6)
	Switch $Type
		Case $M_PFNZ
			$aSTN[$iI][$X][$Y][0] = 3
			$aSTN[$iI][$X][$Y][1] = ($X - 1) * 20
			$aSTN[$iI][$X][$Y][2] = 230 - $Y * 20
			$aSTN[$iI][$X][$Y][3] = 0
			$aSTN[$iI][$X][$Y][4] = 0
			$aSTN[$iI][$X][$Y][5] = 20
			$aSTN[$iI][$X][$Y][6] = 20
			$aSTN[$iI][$X][$Y][7] = 16
			$aSTN[$iI][$X][$Y][8] = $P1
			$aSTN[$iI][$X][$Y][9] = $M_PFNZ
			$aSTN[$iI][$X][$Y][10] = 0
			$aSTN[$iI][$X][$Y][11] = 0
			$aSTN[$iI][$X][$Y][12] = 0
		Case $M_MONY
			If $aCollected[$iI][$X][$Y] Then Return
			$aSTN[$iI][$X][$Y][0] = 2
			$aSTN[$iI][$X][$Y][1] = ($X - 1) * 20
			$aSTN[$iI][$X][$Y][2] = 240 - $Y * 20
			$aSTN[$iI][$X][$Y][3] = 0
			$aSTN[$iI][$X][$Y][4] = 0
			$aSTN[$iI][$X][$Y][5] = 20
			$aSTN[$iI][$X][$Y][6] = 20
			$aSTN[$iI][$X][$Y][7] = 16
			$aSTN[$iI][$X][$Y][8] = 25
			$aSTN[$iI][$X][$Y][9] = $M_MONY
			$aSTN[$iI][$X][$Y][10] = 0
			$aSTN[$iI][$X][$Y][11] = 0
			$aSTN[$iI][$X][$Y][12] = 0
		Case Else
			_AddMOVItem($Type, $X, $Y, $P1, $P2, $P3)
	EndSwitch
EndFunc   ;==>_SetStone_MOV

Func _SetStone_STN($iI, $X, $Y, $Type, $P1, $P2, $P3, $p4, $p5, $p6)
	$aSTN[$iI][$X][$Y][0] = 1
	$aSTN[$iI][$X][$Y][1] = ($X - 1) * 20
	$aSTN[$iI][$X][$Y][2] = 240 - $Y * 20
	$aSTN[$iI][$X][$Y][3] = 0
	$aSTN[$iI][$X][$Y][4] = 0
	$aSTN[$iI][$X][$Y][5] = 20
	$aSTN[$iI][$X][$Y][6] = 20
	$aSTN[$iI][$X][$Y][7] = BitOR(1, 2, 4, 8)
	$aSTN[$iI][$X][$Y][8] = $Type + 1
	$aSTN[$iI][$X][$Y][9] = $Type
	$aSTN[$iI][$X][$Y][10] = 0
	$aSTN[$iI][$X][$Y][11] = 0
	$aSTN[$iI][$X][$Y][12] = 0
	Switch $Type
		Case $S_FRGZ, $S_MAU2, $S_MAUR
			;[10]=Geld
			;[11]=1:Pilz, 2:Stern
			$aSTN[$iI][$X][$Y][10] = $P1
			If $P3 = 1 Then $aSTN[$iI][$X][$Y][11] = 2
			If $P2 = 1 Then $aSTN[$iI][$X][$Y][11] = 1
		Case $S_STNR
			If $P1 = 1 Then $aSTN[$iI][$X][$Y][10] = True
		Case $S_UNSI, $S_UNS2
			$aSTN[$iI][$X][$Y][8] = $S_UNSI + 1
			$aSTN[$iI][$X][$Y][9] = $S_UNSI
			$aSTN[$iI][$X][$Y][7] = 2
		Case $S_RORV
			$aSTN[$iI][$X][$Y][5] = 40
		Case $S_RORU, $S_RORO ; Eingang
			$aSTN[$iI][$X][$Y][5] = 40
			$aSTN[$iI][$X][$Y][10] = $P2 ; Ziel Sublevel
			$aSTN[$iI][$X][$Y][11] = $P3 ; Ziel X
			$aSTN[$iI][$X][$Y][12] = $p4 ; Ziel Y
			If $P1 > 0 Then _AddMOVItem($M_PFNZ, $X, $Y, $Type)
		Case $S_RORH
			$aSTN[$iI][$X][$Y][6] = 40
		Case $S_RORL, $S_RORR ; Eingang
			$aSTN[$iI][$X][$Y][6] = 40
			$aSTN[$iI][$X][$Y][10] = $P2 ; Ziel Sublevel
			$aSTN[$iI][$X][$Y][11] = $P3 ; Ziel X
			$aSTN[$iI][$X][$Y][12] = $p4 ; Ziel Y
		Case $S_TRAL, $S_TRAM, $S_TRAR, $S_PALL, $S_PALM, $S_PALR
			$aSTN[$iI][$X][$Y][7] = 1
		Case $S_FANO, $S_FANS
			$aSTN[$iI][$X][$Y][7] = 16
			$aSTN[$iI][$X][$Y][6] = 21
		Case $S_KANO
			$aSTN[$iI][$X][$Y][6] = 40
	EndSwitch
EndFunc   ;==>_SetStone_STN


Func _LoadGFX()
	For $i = 1 To 6
		$aGFX_BKG[$i] = _ResourceLoadImage("GFX.dat", "BKG" & $i)
	Next
	For $i = 1 To 41
		$aGFX_HRO[$i] = _ResourceLoadImage("GFX.dat", "HRO" & $i)
	Next
	For $i = 1 To 30
		$aGFX_SBK[$i] = _ResourceLoadImage("GFX.dat", "SBK" & $i)
	Next
	For $i = 1 To 29
		$aGFX_STN[$i] = _ResourceLoadImage("GFX.dat", "STN" & $i)
	Next
	For $i = 1 To 50
		$aGFX_TXT[$i] = _ResourceLoadImage("GFX.dat", "TXT" & $i)
	Next
	For $i = 1 To 34
		$aGFX_MOV[$i] = _ResourceLoadImage("GFX.dat", "MOV" & $i)
		$aGFX_MOV[$i + 100] = _ResourceLoadImage("GFX.dat", "MOV" & $i)
		_GDIplus_ImageRotateFlip($aGFX_MOV[$i + 100], 6)
	Next
	For $i = 1 To 3
		$aGFX_MNU[$i] = _ResourceLoadImage(@ScriptDir & "\GFX.dat", "HRO" & $i + 5)
	Next
	$aGFX_MNU[4] = _ResourceLoadImage(@ScriptDir & "\GFX.dat", "BKG5")
	$aGFX_MNU[5] = _ResourceLoadImage(@ScriptDir & "\GFX.dat", "BKG6")
	$aGFX_MNU[6] = _ResourceLoadImage(@ScriptDir & "\GFX.dat", "STN2")
	$aGFX_MNU[7] = _ResourceLoadImage(@ScriptDir & "\GFX.dat", "MOV3")
	For $i = 1 To 11
		$aGFX_MNU[$i + 7] = _ResourceLoadImage(@ScriptDir & "\GFX.dat", "MAP" & $i)
	Next
EndFunc   ;==>_LoadGFX

Func _PlaySound($iIndex)
	If Not $bSoundEnabled Or $hBassDll < 0 Then Return
	Switch $iIndex
		Case 1 ; Punkt
			Switch _BASS_ChannelGetPosition($hBassDll, $hSFX[1][0], 0)
				Case 1 To 12000
					Return
				Case 12000 To 150000
					_BASS_ChannelSetPosition($hBassDll, $hSFX[1][0], 9200, 0)
				Case Else
					_BASS_ChannelPlay($hBassDll, $hSFX[1][0], 1)
			EndSwitch
		Case 2, 3 ; Sprung
			Switch $iMarioSize
				Case 0
					_BASS_ChannelPlay($hBassDll, $hSFX[2][0], 1)
				Case Else
					_BASS_ChannelPlay($hBassDll, $hSFX[3][0], 1)
			EndSwitch
		Case 4 To 7
			_BASS_ChannelPlay($hBassDll, $hSFX[$iIndex][0], 1)
		Case 8
			Switch _BASS_ChannelGetPosition($hBassDll, $hSFX[8][0], 0)
				Case 1 To 30000
					Return
				Case 30000 To 70000
					_BASS_ChannelSetPosition($hBassDll, $hSFX[8][0], 15000, 0)
				Case Else
					_BASS_ChannelPlay($hBassDll, $hSFX[8][0], 1)
			EndSwitch
		Case 9 To 13
			_BASS_ChannelPlay($hBassDll, $hSFX[$iIndex][0], 1)
		Case 14, 15 ; Start Stage, Win Stage
			_BASS_ChannelPlay($hBassDll, $hSFX[$iIndex][0], 1)
			Do
				Sleep(100)
			Until _BASS_ChannelIsActive($hBassDll, $hSFX[$iIndex][0]) <> 1
		Case 16 To 19
			_BASS_ChannelPlay($hBassDll, $hSFX[$iIndex][0], 1)
	EndSwitch
EndFunc   ;==>_PlaySound

Func _LoadSFX()
	For $i = 1 To 19
		$hSFX[$i][0] = _ResourceLoadSound("SFX.dat", "SFX" & $i)
		$hSFX[$i][1] = @extended
		$hMSC[$i][0] = _ResourceLoadSound("SFX.dat", "MSC" & $i, 1, True)
		$hMSC[$i][1] = @extended
	Next
	$hMSC[26][0] = _ResourceLoadSound("SFX.dat", "MSC27", 1, True)
	$hMSC[26][1] = @extended
	$hMSC[27][0] = _ResourceLoadSound("SFX.dat", "MSC4", 1, True)
	$hMSC[27][1] = @extended
	$hMSC[28][0] = _ResourceLoadSound("SFX.dat", "MSC28")
	$hMSC[28][1] = @extended
	$hMSC[29][0] = _ResourceLoadSound("SFX.dat", "MSC29", 1, True)
	$hMSC[29][1] = @extended
EndFunc   ;==>_LoadSFX
#EndRegion Load Level / GFX



#Region Generelle Funktionen
Func _WinAPI_RedrawWindow_($hWnd)
	$iRedrawTimer = TimerInit()
	$bDrawBackground = True
	DllCall($hUser32dll, "int", "RedrawWindow", "hwnd", $hWnd, "ptr", 0, "int", 0, "int", 5)
	$bDrawBackground = False
	$iRedrawTime = TimerDiff($iRedrawTimer)
EndFunc   ;==>_WinAPI_RedrawWindow_

Func _TooglePause()
	$aKeyReturnOld[80] = $aKeyReturn[80]
	Switch $bPause
		Case False
			Switch $bSoundEnabled
				Case True
					Switch $bMarioStern
						Case True
							_BASS_ChannelStop($hBassDll, $hMSC[29][0])
						Case Else
							_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
					EndSwitch
					_PlaySound(10)
			EndSwitch
			$bPause = True
			_WinAPI_RedrawWindow_($hGui)
		Case Else
			Switch $bSoundEnabled
				Case True
					Switch $bMarioStern
						Case True
							_BASS_ChannelPlay($hBassDll, $hMSC[29][0], 0)
						Case Else
							_BASS_ChannelPlay($hBassDll, $hMSC[$iLVL][0], 0)
					EndSwitch
			EndSwitch
			$bPause = False
	EndSwitch
EndFunc   ;==>_TooglePause

Func _ToogleSound()
	$aKeyReturnOld[77] = $aKeyReturn[77]
	If $hBassDll < 0 Then Return
	Switch $bSoundEnabled
		Case True
			Switch $iMenu
				Case -1
					Switch $bMarioStern
						Case True
							_BASS_ChannelStop($hBassDll, $hMSC[29][0])
						Case Else
							_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
					EndSwitch
				Case Else
					_BASS_ChannelStop($hBassDll, $hMSC[27][0])
					$iSoundStep = 0
			EndSwitch
			$bSoundEnabled = False
		Case Else
			$bSoundEnabled = True
			Switch $iMenu
				Case -1
					Switch $bMarioStern
						Case True
							_BASS_ChannelPlay($hBassDll, $hMSC[29][0], 0)
						Case Else
							_BASS_ChannelPlay($hBassDll, $hMSC[$iLVL][0], 0)
					EndSwitch
				Case Else
					_BASS_ChannelPlay($hBassDll, $hMSC[27][0], 0)
					$iSoundStep = 0
			EndSwitch
	EndSwitch
EndFunc   ;==>_ToogleSound

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

Func _WinAPI_GetKeyboardState_Mario($bCheck = True, $bFull = False, $iFlag = 0)
	Switch $bFull
		Case False
			DllCall($hUser32dll, "int", "GetKeyboardState", "ptr", DllStructGetPtr($lpKeyState))
			$aKeyReturn[32] = DllStructGetData($lpKeyState, 1, $iKeyFire + 1) ; Space
			$aKeyReturn[37] = DllStructGetData($lpKeyState, 1, $iKeyLeft + 1) ; left
			$aKeyReturn[38] = DllStructGetData($lpKeyState, 1, $iKeyUp + 1) ; up
			$aKeyReturn[39] = DllStructGetData($lpKeyState, 1, $iKeyRight + 1) ; right
			$aKeyReturn[40] = DllStructGetData($lpKeyState, 1, $iKeyDown + 1) ; down
			$aKeyReturn[77] = DllStructGetData($lpKeyState, 1, $iKeySound + 1) ; M = Music on/off
			$aKeyReturn[80] = DllStructGetData($lpKeyState, 1, $iKeyPause + 1) ; P = Pause
			$aKeyReturn[27] = DllStructGetData($lpKeyState, 1, 28) ; P = Pause
			Switch $bCheck
				Case True
					If $aKeyReturn[77] > 1 And $aKeyReturn[77] <> $aKeyReturnOld[77] Then _ToogleSound()
					If $aKeyReturn[80] > 1 And $aKeyReturn[80] <> $aKeyReturnOld[80] Then _TooglePause()
			EndSwitch
			Return $aKeyReturn
		Case Else
			Local $aDllRet, $lpKeyState = DllStructCreate("byte[256]")
			$aDllRet = DllCall($hUser32dll, "int", "GetKeyboardState", "ptr", DllStructGetPtr($lpKeyState))
			If @error Then Return SetError(@error, 0, 0)
			If $aDllRet[0] = 0 Then
				Return SetError(1, 0, 0)
			Else
				Switch $iFlag
					Case 0
						Local $aReturn[256]
						For $i = 1 To 256
							$aReturn[$i - 1] = DllStructGetData($lpKeyState, 1, $i)
						Next
						Return $aReturn
					Case Else
						Return DllStructGetData($lpKeyState, 1)
				EndSwitch
			EndIf
	EndSwitch
EndFunc   ;==>_WinAPI_GetKeyboardState_Mario




;===============================================================================
; Function Name:   _GDIplus_ImageRotateFlip
; Description::    Rotates or flips an Image
; Parameter(s):    $hImage         - GDIPlus image handle
;                  $RotateFlipType - RotateFlip action to perform
; Requirement(s):  GDIplus
; Return Value(s): Success: 1
;                  Error: 0 and @error <> 0
; Author(s):       Prog@ndy
;===============================================================================
Func _GDIplus_ImageRotateFlip($hImage, $RotateFlipType)
	Local $ret = DllCall($ghGDIPDll, "int", "GdipImageRotateFlip", "hwnd", $hImage, "dword", $RotateFlipType)
	If @error Then Return SetError(1, 0, 0)
	Return SetError($ret[0], 0, $ret[0] = 0)
EndFunc   ;==>_GDIplus_ImageRotateFlip

;===============================================================================
; Function Name:   _EnableDisableAero()
; Description:    Enables or Disables the Aero design from Vista to the default design.
; Parameter(s):    $bEnable [BOOLEAN]: True enables the Aero, False disables it.
; Requirement(s):  dwmapi.dll, Windows Vista
; Return Value(s): Returnvals of DLLCall
; Author(s):       GtaSpider
;===============================================================================
Func _EnableDisableAero($bEnable = True) ;True/False
	Local $aDll = DllCall($hDwmApiDll, "int", "DwmEnableComposition", "int", $bEnable)
	If @error Then Return SetError(@error, 0, 0)
	Return $aDll[0]
EndFunc   ;==>_EnableDisableAero
;===============================================================================
; Function Name:   _IsAeroEnable
; Description:    Checks if aero is enable
; Parameter(s):    None
; Requirement(s):  dwmapi.dll, Windows Vista
; Return Value(s): 0 If disabeld, 1 if enabled
; Author(s):       GtaSpider
;===============================================================================
Func _IsAeroEnable()
	Local $asDll = DllCall($hDwmApiDll, "int", "DwmIsCompositionEnabled", "str", "")
	If @error Then Return SetError(@error, 0, 0)
	Return StringReplace(StringReplace(Asc($asDll[1]), "1", True), "0", False)
EndFunc   ;==>_IsAeroEnable

Func _ResourceLoadSound($DLL, $ResName, $Loop = 0, $Tempo = False)
	Local $hInstance, $InfoBlock, $GlobalMemoryBlock, $MemoryPointer, $ResSize, $SampleLoop = 0, $StreamHandle, $TempoHandle
	If $Loop Then $SampleLoop = 4
	$hInstance = DllCall("kernel32.dll", "int", "LoadLibrary", "str", $DLL)
	$InfoBlock = DllCall("kernel32.dll", "int", "FindResourceA", "int", $hInstance[0], "str", $ResName, "long", 10)
	$ResSize = DllCall("kernel32.dll", "dword", "SizeofResource", "int", $hInstance[0], "int", $InfoBlock[0])
	$GlobalMemoryBlock = DllCall("kernel32.dll", "int", "LoadResource", "int", $hInstance[0], "int", $InfoBlock[0])
	$MemoryPointer = DllCall("kernel32.dll", "int", "LockResource", "int", $GlobalMemoryBlock[0])
	DllCall("Kernel32.dll", "int", "FreeLibrary", "str", $hInstance[0])
	Switch $Tempo
		Case True
			$StreamHandle = _BASS_StreamCreateFile($hBassDll, True, $MemoryPointer[0], 0, $ResSize[0], 0x200000); Decoding Channel
			$TempoHandle = _BASS_FX_TempoCreate($hBassDll, $hBassFXDll, $StreamHandle, BitOR($SampleLoop, 0x10000)); Free StreamHandle as well
			SetExtended($MemoryPointer[0])
			Return $TempoHandle
		Case Else
			$StreamHandle = _BASS_StreamCreateFile($hBassDll, True, $MemoryPointer[0], 0, $ResSize[0], $SampleLoop); Decoding Channel
			SetExtended($MemoryPointer[0])
			Return $StreamHandle
	EndSwitch
EndFunc   ;==>_ResourceLoadSound

Func _BASS_StreamCreateFile($bass_dll, $mem, $file, $offset, $length, $flags)
	If $hBassDll < 0 Then Return
	$BASS_ret_ = DllCall($bass_dll, "dword", "BASS_StreamCreateFile", "int", $mem, "ptr", $file, "uint64", $offset, "uint64", $length, "DWORD", $flags)
	Return SetError(0, "", $BASS_ret_[0])
EndFunc   ;==>_BASS_StreamCreateFile

Func _BASS_FX_TempoCreate($bass_dll, $bassfx_dll, $chan, $flags)
	If $hBassDll < 0 Or $bassfx_dll < 0 Then Return
	Local $BASS_ret_ = DllCall($bassfx_dll, "dword", "BASS_FX_TempoCreate", "dword", $chan, "dword", $flags)
	Local $BS_ERR = _BASS_ErrorGetCode($bass_dll)
	If $BS_ERR <> 0 Then
		Return SetError($BS_ERR, "", 0)
	Else
		Return SetError(0, "", $BASS_ret_[0])
	EndIf
EndFunc   ;==>_BASS_FX_TempoCreate

Func _BASS_ChannelSetAttribute($bass_dll, $handle, $attrib, $value)
	If Not $bSoundEnabled Or $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_ChannelSetAttribute", "DWORD", $handle, "DWORD", $attrib, "float", $value)
EndFunc   ;==>_BASS_ChannelSetAttribute

Func _BASS_ChannelPlay($bass_dll, $handle, $restart)
	If Not $bSoundEnabled Or $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_ChannelPlay", "DWORD", $handle, "int", $restart)
EndFunc   ;==>_BASS_ChannelPlay

Func _BASS_ChannelStop($bass_dll, $handle)
	If $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_ChannelStop", "DWORD", $handle)
EndFunc   ;==>_BASS_ChannelStop

Func _BASS_StreamFree($bass_dll, $handle)
	If $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_StreamFree", "dword", $handle)
EndFunc   ;==>_BASS_StreamFree

Func _BASS_SetVolume($bass_dll, $volume)
	If $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_SetVolume", "float", $volume)
EndFunc   ;==>_BASS_SetVolume

Func _BASS_GetVolume($bass_dll)
	If $hBassDll < 0 Then Return
	Local $BASS_ret_ = DllCall($bass_dll, "float", "BASS_GetVolume")
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_GetVolume

Func _BASS_ChannelGetPosition($bass_dll, $handle, $mode)
	If $hBassDll < 0 Then Return -1
	$BASS_ret_ = DllCall($bass_dll, "UINT", "BASS_ChannelGetPosition", "DWORD", $handle, "DWORD", $mode)
	$bass_error = _BASS_ErrorGetCode($bass_dll)
	If $bass_error <> 0 Then
		Return SetError($bass_error, "", 0)
	Else
		Return SetError(0, "", $BASS_ret_[0])
	EndIf
EndFunc   ;==>_BASS_ChannelGetPosition

Func _BASS_ChannelSetPosition($bass_dll, $handle, $pos, $mode)
	If Not $bSoundEnabled Or $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_ChannelSetPosition", "DWORD", $handle, "UINT64", $pos, "DWORD", $mode)
EndFunc   ;==>_BASS_ChannelSetPosition

Func _BASS_ChannelIsActive($bass_dll, $handle)
	If $hBassDll < 0 Then Return 0
	Local $BASS_ret_ = DllCall($bass_dll, "int", "BASS_ChannelIsActive", "DWORD", $handle)
	Local $bass_error = _BASS_ErrorGetCode($bass_dll)
	If $bass_error <> 0 Then
		Return SetError($bass_error, "", 0)
	Else
		Return SetError(0, "", $BASS_ret_[0])
	EndIf
EndFunc   ;==>_BASS_ChannelIsActive

Func _BASS_Init($bass_dll, $flags, $device = -1, $freq = 44100, $win = 0, $clsid = "")
	If $hBassDll < 0 Then Return SetError(1, 0, 0)
	Local $BASS_ret_ = DllCall($bass_dll, "int", "BASS_Init", "int", $device, "dword", $freq, "dword", $flags, "hwnd", $win, "hwnd", $clsid)
	Local $bass_error = _BASS_ErrorGetCode($bass_dll)
	If $bass_error <> 0 Then
		Return SetError($bass_error, "", 0)
	Else
		Return SetError(0, "", $BASS_ret_[0])
	EndIf
EndFunc   ;==>_BASS_Init

Func _BASS_ErrorGetCode($bass_dll)
	If Not $bSoundEnabled Or $hBassDll < 0 Then Return
	Local $BASS_ret_ = DllCall($bass_dll, "int", "BASS_ErrorGetCode")
	Return SetError(0, "", $BASS_ret_[0])
EndFunc   ;==>_BASS_ErrorGetCode

Func _BASS_Free($bass_dll)
	If $hBassDll < 0 Then Return
	DllCall($bass_dll, "int", "BASS_Free")
EndFunc   ;==>_BASS_Free

Func _ResourceFree($handle)
	If $handle = 0 Then Return
	DllCall("kernel32.dll", "int", "FreeResource", "int", $handle)
EndFunc   ;==>_ResourceFree

Func _EXIT()
	GUIRegisterMsg($WM_ERASEBKGND, "")
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Down", $iKeyDown)
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Up", $iKeyUp)
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Left", $iKeyLeft)
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Right", $iKeyRight)
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Fire", $iKeyFire)
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Pause", $iKeyPause)
	IniWrite(@ScriptDir & "\Mario.ini", "Control", "Sound", $iKeySound)
	IniWrite(@ScriptDir & "\Mario.ini", "Gui", "Factor", $nLandF)
	IniWrite(@ScriptDir & "\Mario.ini", "Gui", "XPos", $iGuiX)
	IniWrite(@ScriptDir & "\Mario.ini", "Gui", "YPos", $iGuiY)
	IniWrite(@ScriptDir & "\Mario.ini", "Settings", "Sound", $bSoundEnabled)
	_GDIPlus_BitmapDispose($hBitmapTXT)
	_GDIPlus_GraphicsDispose($hGraphicsTXT)
	_GDIPlus_BitmapDispose($hBitmapFR)
	_GDIPlus_GraphicsDispose($hGraphicsFR)
	_GDIPlus_BitmapDispose($hBitmapBK)
	_GDIPlus_GraphicsDispose($hGraphicsBK)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphicDC)
	_GDIPlus_GraphicsDispose($hGraphics)
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_DestroyIcon($hIcon)
	For $i = 0 To 49
		If $aGFX_BKG[$i] Then _GDIPlus_BitmapDispose($aGFX_BKG[$i])
		If $aGFX_HRO[$i] Then _GDIPlus_BitmapDispose($aGFX_HRO[$i])
	Next
	For $i = 0 To 99
		If $aGFX_STN[$i] Then _GDIPlus_BitmapDispose($aGFX_STN[$i])
		If $aGFX_SBK[$i] Then _GDIPlus_BitmapDispose($aGFX_SBK[$i])
		If $aGFX_MOV[$i] Then _GDIPlus_BitmapDispose($aGFX_MOV[$i])
		If $aGFX_MOV[$i + 100] Then _GDIPlus_BitmapDispose($aGFX_MOV[$i + 100])
		If $aGFX_TXT[$i] Then _GDIPlus_BitmapDispose($aGFX_TXT[$i])
	Next
	_GDIPlus_Shutdown()
	_BASS_Free($hBassDll)
	For $i = 1 To 19
		_ResourceFree($hSFX[$i][1])
		_ResourceFree($hMSC[$i][1])
	Next
	Exit
EndFunc   ;==>_EXIT
#EndRegion Generelle Funktionen

#Region Menu
Func _DrawControl()
	Local $hBitmapTXT = _GDIPlus_BitmapCreateFromGraphics(320, 160, $hGraphics)
	Local $hGraphicsTXT = _GDIPlus_ImageGetGraphicsContext($hBitmapTXT)
	If $iControlSelected < 0 Then $iControlSelected = 0
	If $iControlSelected > 7 Then $iControlSelected = 7
	_DrawText($hGraphicsTXT, "move left:", 15, 5)
	_DrawText($hGraphicsTXT, "move right:", 15, 25)
	_DrawText($hGraphicsTXT, "jump:", 15, 45)
	_DrawText($hGraphicsTXT, "crouch:", 15, 65)
	_DrawText($hGraphicsTXT, "fireball:", 15, 85)
	_DrawText($hGraphicsTXT, "pause:", 15, 105)
	_DrawText($hGraphicsTXT, "sound:", 15, 125)
	_DrawText($hGraphicsTXT, "done", 220, 145)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeyLeft), 140, 5)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeyRight), 140, 25)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeyUp), 140, 45)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeyDown), 140, 65)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeyFire), 140, 85)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeyPause), 140, 105)
	_DrawText($hGraphicsTXT, _GetKeyName($iKeySound), 140, 125)
	Switch $iControlSelected
		Case 7
			_GDIPlus_GraphicsDrawImageRect($hGraphicsTXT, $aGFX_MNU[7], 208, 142, 15, 15)
		Case Else
			_GDIPlus_GraphicsDrawImageRect($hGraphicsTXT, $aGFX_MNU[7], 8, 2 + 20 * $iControlSelected, 15, 15)
	EndSwitch
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapTXT, 0, 10)
	_GDIPlus_GraphicsDispose($hGraphicsTXT)
	_GDIPlus_BitmapDispose($hBitmapTXT)
EndFunc   ;==>_DrawControl

Func _DrawText($hGraphics, $sText, $iX, $iY, $nF = 1)
	Local $aText = StringSplit($sText, ""), $iXOff = 0, $iIcon = 0
	If Not IsArray($aText) Then Return
	For $i = 1 To $aText[0]
		$aText[$i] = StringUpper($aText[$i])
		$iXOff += 10 * $nF
		Switch $aText[$i]
			Case " "
				ContinueLoop
			Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
				$iIcon = Asc($aText[$i]) - 42
			Case "A" To "Z"
				$iIcon = Asc($aText[$i]) - 49
			Case ":"
				$iIcon = 45
			Case "."
				$iIcon = 46
			Case "+"
				$iIcon = 42
			Case "("
				$iIcon = 48
			Case ")"
				$iIcon = 49
			Case Else
				$iIcon = 47
		EndSwitch
		Switch $nF
			Case 1
				_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_TXT[$iIcon], $iX + $iXOff, $iY)
			Case Else
				_GDIPlus_GraphicsDrawImageRect($hGraphics, $aGFX_TXT[$iIcon], $iX + $iXOff, $iY, 12 * $nF, 10 * $nF)
		EndSwitch
	Next
EndFunc   ;==>_DrawText

Func _NaviControl($aKeys)
	Switch $bControlEdit
		Case False
			Select
				Case $aKeys[27] > 1
					$iMenu = 2
					$iLogoY = 10
					_PlaySound(16)
				Case $aKeys[40] > 1
					$iControlSelected += 1
					_PlaySound(16)
				Case $aKeys[38] > 1
					$iControlSelected -= 1
					_PlaySound(16)
				Case $aKeys[39] > 1
					$iControlSelected = 7
					_PlaySound(16)
				Case $aKeys[37] > 1
					If $iControlSelected = 7 Then $iControlSelected = 6
					_PlaySound(16)
				Case $aKeys[13] > 1 Or $aKeys[$iKeyFire] > 1
					_PlaySound(1)
					Switch $iControlSelected
						Case 7
							$iLogoY = 10
							$iMenu = 2
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Down", $iKeyDown)
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Up", $iKeyUp)
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Left", $iKeyLeft)
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Right", $iKeyRight)
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Fire", $iKeyFire)
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Pause", $iKeyPause)
							IniWrite(@ScriptDir & "\Mario.ini", "Control", "Sound", $iKeySound)
						Case 0
							$iKeyLeft = 0
							$bControlEdit = True
						Case 1
							$iKeyRight = 0
							$bControlEdit = True
						Case 2
							$iKeyUp = 0
							$bControlEdit = True
						Case 3
							$iKeyDown = 0
							$bControlEdit = True
						Case 4
							$iKeyFire = 0
							$bControlEdit = True
						Case 5
							$iKeyPause = 0
							$bControlEdit = True
						Case 6
							$iKeySound = 0
							$bControlEdit = True
					EndSwitch
				Case $aKeys[$iKeySound] > 1
					_ToogleSound()
			EndSelect
		Case Else
			Switch $iControlSelected
				Case 0
					If _GetNewKey($iKeyLeft, $aKeys) Then $bControlEdit = False
				Case 1
					If _GetNewKey($iKeyRight, $aKeys) Then $bControlEdit = False
				Case 2
					If _GetNewKey($iKeyUp, $aKeys) Then $bControlEdit = False
				Case 3
					If _GetNewKey($iKeyDown, $aKeys) Then $bControlEdit = False
				Case 4
					If _GetNewKey($iKeyFire, $aKeys) Then $bControlEdit = False
				Case 5
					If _GetNewKey($iKeyPause, $aKeys) Then $bControlEdit = False
				Case 6
					If _GetNewKey($iKeySound, $aKeys) Then $bControlEdit = False
			EndSwitch
	EndSwitch
EndFunc   ;==>_NaviControl

Func _GetNewKey(ByRef $iKey, $aKeys)
	For $i = 1 To 255
		If $aKeys[$i] > 1 And $i <> 27 And $i <> $iKeyLeft And $i <> $iKeyRight And $i <> $iKeyUp And $i <> $iKeyDown And $i <> $iKeyFire And $i <> $iKeyPause And $i <> $iKeySound Then
			$iKey = $i
			_PlaySound(1)
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_GetNewKey

Func _GetKeyName($iKey)
	Switch $iKey
		Case 0
			Return "...Press new key"
		Case 37
			Return "Arrow left"
		Case 39
			Return "Arrow right"
		Case 38
			Return "Arrow up"
		Case 40
			Return "Arrow down"
		Case 32
			Return "Space"
		Case 13
			Return "Enter"
		Case 17
			Return "Ctrl"
		Case 18
			Return "Alt"
		Case 16
			Return "Shift"
		Case 65 To 90
			Return Chr($iKey)
		Case 48 To 57
			Return Chr($iKey)
		Case 33
			Return "Page Up"
		Case 34
			Return "Page Down"
		Case 36
			Return "Home"
		Case 35
			Return "End"
		Case 112 To 123
			Return "F" & $iKey - 111
		Case Else
			Return "Key Nr.: " & $iKey
	EndSwitch
EndFunc   ;==>_GetKeyName

Func _NaviMenu($aKeys)
	Select
		Case $aKeys[40] > 1
			$iMenuSelected += 1
			_PlaySound(16)
		Case $aKeys[38] > 1
			$iMenuSelected -= 1
			_PlaySound(16)
		Case $aKeys[37] > 1
			If $iMenuSelected >= 3 Then $iMenuSelected = 2
			_PlaySound(16)
		Case $aKeys[39] > 1
			If $iMenuSelected < 3 Then $iMenuSelected = 3
			_PlaySound(16)
		Case $aKeys[13] > 1 Or $aKeys[$iKeyFire] > 1
			_PlaySound(1)
			Switch $iMenuSelected
				Case 0 ; Play
					_MarioRun("Level")
				Case 1 ; Select
					$aLevels = _FileListToArray(@ScriptDir & "\LVL", "*.lvl", 1)
					If UBound($aLevels) = 0 Then $iLevelSelected = 0
					If $iLevelSelected > 0 And $iLevelSelected > $aLevels[0] Then $iLevelSelected = 1
					If $iLevelSelected > 0 And $iLevelSelected <= $aLevels[0] Then $iMenu = 3
				Case 2 ; Editor
					_MarioRun("Editor")
				Case 3 ; Settings
					$iLogoY = -100
					$iControlSelected = 0
					$bControlEdit = False
					$iMenu = 4
				Case 4 ; Credits
					_BASS_ChannelStop($hBassDll, $hMSC[27][0])
					_BASS_ChannelPlay($hBassDll, $hMSC[26][0], 1)
					$iCreditY = 110
					$iMenu = 1
				Case 5 ;
					_EXIT()
			EndSwitch
		Case $aKeys[$iKeySound] > 1
			_ToogleSound()
	EndSelect
EndFunc   ;==>_NaviMenu

Func _NaviSelect($aKeys)
	Select
		Case $aKeys[27] > 1
			$iMenu = 2
			_PlaySound(16)
		Case $aKeys[40] > 1
			$iLevelSelected += 1
			_PlaySound(16)
		Case $aKeys[38] > 1
			$iLevelSelected -= 1
			_PlaySound(16)
		Case $aKeys[37] > 1 Or $aKeys[33] > 1
			$iLevelSelected -= 10
			_PlaySound(16)
		Case $aKeys[39] > 1 Or $aKeys[34] > 1
			$iLevelSelected += 10
			_PlaySound(16)
		Case $aKeys[36] > 1
			$iLevelSelected = 0
			_PlaySound(16)
		Case $aKeys[35] > 1
			$iLevelSelected = $aLevels[0]
			_PlaySound(16)
		Case $aKeys[13] > 1 Or $aKeys[$iKeyFire] > 1
			$sLevelSelected = $aLevels[$iLevelSelected]
			$iMenu = 2
			_PlaySound(1)
		Case $aKeys[$iKeySound] > 1
			_ToogleSound()
	EndSelect
EndFunc   ;==>_NaviSelect

Func _DrawSelect()
	Local $hBitmapTXT = _GDIPlus_BitmapCreateFromGraphics(320, 110, $hGraphics)
	Local $hGraphicsTXT = _GDIPlus_ImageGetGraphicsContext($hBitmapTXT)
	Select
		Case $iLevelSelected < 1
			$iLevelSelected = 1
		Case $iLevelSelected > $aLevels[0]
			$iLevelSelected = $aLevels[0]
	EndSelect
	For $i = $iLevelSelected - 3 To $iLevelSelected + 3
		If $i < 1 Or $i > $aLevels[0] Then ContinueLoop
		Switch $i - $iLevelSelected
			Case 0
				_DrawText($hGraphicsTXT, $aLevels[$i], 20, 15 * ($i - $iLevelSelected + 3), 1)
			Case Else
				_DrawText($hGraphicsTXT, $aLevels[$i], 20, 15 * ($i - $iLevelSelected + 3), 0.7)
		EndSwitch
	Next
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapTXT, 0, 90)
	_GDIPlus_GraphicsDispose($hGraphicsTXT)
	_GDIPlus_BitmapDispose($hBitmapTXT)
EndFunc   ;==>_DrawSelect

Func _DrawBackgroundMenu()
	If $iSteinX <= -20 Then $iSteinX = 0
	If $iBkX <= -320 Then
		Local $iSwap = $aGFX_MNU[4]
		$aGFX_MNU[4] = $aGFX_MNU[5]
		$aGFX_MNU[5] = $iSwap
		$iBkX = 0
	EndIf
	If $iGrassX < $iGrassNew Then
		$iGrassX = 320
		$iGrassNew = Random(-800, -20, 1)
	EndIf
	Switch $iMarioRunStep
		Case 0, 1
			$iMarioIcon = 1
		Case 2, 3
			$iMarioIcon = 2
		Case 4, 5
			$iMarioIcon = 3
		Case 6
			$iMarioIcon = 2
		Case Else
			$iMarioIcon = 2
			$iMarioRunStep = 0
	EndSwitch
	Switch $iGrassStep
		Case 0 To 4
			$iGrassIcon = 0
		Case 5 To 9
			$iGrassIcon = 1
		Case 10 To 13
			$iGrassIcon = 2
		Case Else
			$iGrassIcon = 2
			$iGrassStep = 0
	EndSwitch
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[4], $iBkX, 0)
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[5], $iBkX + 320, 0)
	Switch $iMenu
		Case 1 ; Credits
			_DrawCredits()
		Case 2 ; Menu
			_DrawMenu()
		Case 3
			_DrawSelect()
		Case 4
			_DrawControl()
	EndSwitch
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[9], -4, $iLogoY + 8)
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[8], 0, $iLogoY)
	For $i = 0 To 16
		_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[6], $i * 20 + $iSteinX, 220)
	Next
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[10 + $iGrassIcon], $iGrassX, 200)
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[13 + $iGrassIcon], $iGrassX + 20, 200)
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[16 + $iGrassIcon], $iGrassX + 40, 200)
	_GDIPlus_GraphicsDrawImage($hGraphics, $aGFX_MNU[$iMarioIcon], $iMarioX, 182)
	Select
		Case $iSoundStep < 50 And $bSoundEnabled = True
			$iSoundStep += 1
			_DrawText($hGraphics, "Sound on", 100, 110, 1.2)
		Case $iSoundStep < 50 And $bSoundEnabled = False
			$iSoundStep += 1
			_DrawText($hGraphics, "Sound off", 100, 110, 1.2)
	EndSelect
	;_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 320 * $nLandF, 240 * $nLandF)
EndFunc   ;==>_DrawBackgroundMenu

Func _DrawMenu()
	Local $hBitmapTXT = _GDIPlus_BitmapCreateFromGraphics(320, 110, $hGraphics)
	Local $hGraphicsTXT = _GDIPlus_ImageGetGraphicsContext($hBitmapTXT)
	_DrawText($hGraphicsTXT, "Play:", 20, 15)
	_DrawText($hGraphicsTXT, _StringTrim($sLevelSelected, 23), 100, 16, 0.9)
	_DrawText($hGraphicsTXT, "Select Level", 20, 35)
	_DrawText($hGraphicsTXT, "Level Editor", 20, 55)
	_DrawText($hGraphicsTXT, "Control", 220, 65)
	_DrawText($hGraphicsTXT, "Credits", 220, 80)
	_DrawText($hGraphicsTXT, "Exit", 220, 95)
	Select
		Case $iMenuSelected < 0
			$iMenuSelected = 0
		Case $iMenuSelected > 5
			$iMenuSelected = 5
	EndSelect
	Switch $iMenuSelected
		Case 0 To 2
			_GDIPlus_GraphicsDrawImageRect($hGraphicsTXT, $aGFX_MNU[7], 8, 12 + 20 * $iMenuSelected, 15, 15)
		Case 3 To 5
			_GDIPlus_GraphicsDrawImageRect($hGraphicsTXT, $aGFX_MNU[7], 208, 62 + 15 * ($iMenuSelected - 3), 15, 15)
	EndSwitch
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapTXT, 0, 90)
	_GDIPlus_GraphicsDispose($hGraphicsTXT)
	_GDIPlus_BitmapDispose($hBitmapTXT)
	If $iCreditY < -($aCredits[0] * 15 + 30) Then $iMenu = 2
EndFunc   ;==>_DrawMenu

Func _StringTrim($sString, $iLen)
	Local $iSLen = StringLen($sString)
	Select
		Case $iSLen <= $iLen
			Return $sString
		Case Else
			Return StringLeft($sString, $iLen / 2 - 1) & "..." & StringRight($sString, $iLen / 2 - 2)
	EndSelect
EndFunc   ;==>_StringTrim

Func _DrawCredits()
	Local $hBitmapTXT = _GDIPlus_BitmapCreateFromGraphics(320, 100, $hGraphics)
	Local $hGraphicsTXT = _GDIPlus_ImageGetGraphicsContext($hBitmapTXT)
	$iCreditY -= 1
	For $i = 1 To $aCredits[0]
		If $iCreditY + $i * 15 > -10 Or $iCreditY + $i * 15 < 100 Then _DrawText($hGraphicsTXT, $aCredits[$i], 155 - StringLen($aCredits[$i]) * 5, $iCreditY + $i * 15)
	Next
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmapTXT, 0, 90)
	_GDIPlus_GraphicsDispose($hGraphicsTXT)
	_GDIPlus_BitmapDispose($hBitmapTXT)
	If $iCreditY < -($aCredits[0] * 15 + 30) Then $bCreditEnd = True
EndFunc   ;==>_DrawCredits

Func _MarioRun($SRUN)
	Local $aCollectedNew[20][400][13], $hPID
	Switch $SRUN
		Case "Level"
			$iMenu = -1
			_BASS_ChannelStop($hBassDll, $hMSC[27][0])
			$aKeyReturn = _WinAPI_GetKeyboardState_Mario(0)
			$aKeyReturnOld = $aKeyReturn
			$iMarioLeben = 5
			$aCollected = $aCollectedNew
			_LoadLevel(@ScriptDir & "\LVL\" & $aLevels[$iLevelSelected])
		Case "Editor"
			Switch FileExists(@ScriptDir & "\Editor.exe")
				Case True
					$hPID = Run(@ScriptDir & '\Editor.exe "' & $sLevelSelected & '"', @ScriptDir)
				Case Else
					$hPID = Run(@AutoItExe & ' "' & @ScriptDir & '\Editor.au3" "' & $sLevelSelected & '"', @ScriptDir)
			EndSwitch
			If $hPID <> 0 Then _EXIT()
	EndSwitch
EndFunc   ;==>_MarioRun

Func _MarioQuit($bAsk = True)
	Local $aKeys
	Switch $bDebug
		Case False
			Switch $bAsk
				Case True
					$iMenu = 99
					Do
						_Sleep($iTimerDelay)
						_WinAPI_RedrawWindow_($hGui)
						$aKeys = _WinAPI_GetKeyboardState_Mario(0, True)
					Until $aKeys[89] > 1 Or $aKeys[78] > 1
					Select
						Case $aKeys[89] > 1
							_BASS_ChannelStop($hBassDll, $hMSC[29][0])
							_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
							$iMenu = 2
							$iMarioX = 150
							$iLogoY = 10
							$sKeys = _WinAPI_GetKeyboardState_Mario(0, True, 1)
							$sKeysOld = $sKeys
							_BASS_ChannelPlay($hBassDll, $hMSC[27][0], 1)
						Case $aKeys[78] > 3
							$iMenu = -1
					EndSelect
				Case Else
					_BASS_ChannelStop($hBassDll, $hMSC[29][0])
					_BASS_ChannelStop($hBassDll, $hMSC[$iLVL][0])
					$iMenu = 2
					$iMarioX = 150
					$iLogoY = 10
					_BASS_ChannelPlay($hBassDll, $hMSC[27][0], 1)
			EndSwitch
		Case Else
			_EXIT()
	EndSwitch
EndFunc   ;==>_MarioQuit

#EndRegion Menu

#Region Informationen
;========================================
;SFX
;----------------------------------------
;01	=> Punkt
;02	=> Sprungklein
;03	=> Sprunggroß
;04	=> Feuerball
;05	=> Schildkröte
;06	=> Blume
;07	=> Pilz
;08	=> Panzer
;========================================


;========================================
;GFX Hintergrund (GFX_BKG.icl):
;----------------------------------------
;01-02 => Wolken
;03-04 => Sublevel
;05-06 => BK 1
;07-08 => BK 2
;09-10 => BK 3
;...
;========================================

;========================================
;GFX Mario (GFX_HRO.icl):
;----------------------------------------
;01-05, 16-20 => Klein (stehen, laufen1, laufen2, springen, sterben)
;06-10, 21-25 => Groß (stehen, laufen1, laufen2, springen, ducken)
;11-15, 26-30 => Feuer (stehen, laufen1, laufen2, springen, ducken)
;31-32        => Schießen
;33-38        => Klettern (klein1, klein2, groß1, groß2, feuer1, feuer2)
;========================================

;========================================
;GFX Beweglich (GFX_MOV.icl):
;----------------------------------------
;01-02 	=> Feuerball
;03		=> Pilz
;04		=> Blume
;05		=> Stern
;06-08	=> Watschelmann
;09-12	=> Schildkröte (gehen1 links, gehen2 links, gehen1 rechts, gehen2 rechts)
;13-16	=> Panzer (drehen 1-4)
;17-20	=> Pflanze
;21		=> Aufzug
;22-23	=> Kanonenkugel
;24-27	=> Geld
;28-29	=> Mauerbruchstücke
;30		=> Fahne
;31-34	=> Springende Schildkröte (wird zu normaler Schildkröte)
;========================================

;========================================
;GFX Steine ohne Kollisionscheck (GFX_SBK.icl):
;----------------------------------------
;01-29 Allerlei Steine, die nur als Hintergrund gezeichnet werden
;========================================

;========================================
;GFX Steine mit Kollisionscheck (GFX_STN.icl):
;----------------------------------------
;01-03	=> Rasen
;04		=> Mauer
;05		=> Fragezeichen
;06		=> Stein mit runden Ecken
;07		=> eckiger Stein
;08-13	=> Rohrsystem
;14		=> Kanone
;15-16	=> Fahnenstange
;17		=> blaue Mauer
;18-19	=> Unsichtbarer Stein
;20-22	=> Turmrasen
;23-25	=> Palme
;26		=> gelber Stein
;========================================

;====================================================================
;ARRAY Spezifikation
;--------------------------------------------------------------------
;[0]	= 0:Off 1:On 2:Erweitert (Item Stirbt, Geld als Stein...)
;[1]	= X Koordinate
;[2]	= Y Koordinate
;[3]	= X Offset
;[4]	= Y Offset
;[5]	= Breite
;[6]	= Höhe
;[7]	= Kollision Bitor(1=Boden, 2=Decke, 4=von Links, 8=von Rechts, 16=Berühren)
;[8]	= Icon
;[9]	= Item ID
;[10]	= Parameter 1
;[11]	= Parameter 2
;[12]	= Parameter 3
;----- nur mehr MoveItems: -----
;[13]	= Move X
;[14]	= Move Y
;[15]	= Jump on/off
;[16]	= Jumpstep
;[17-23]= beinhalten Resetparameter P1;P2;P3;MX;MY;J;JS
;====================================================================

#EndRegion Informationen

Func _GDIPlus_BitmapCreateHICONFromBitmap($hBitmap)
	; Prog@ndy
	Local $result = DllCall($ghGDIPDll, "int", "GdipCreateHICONFromBitmap", "ptr", $hBitmap, "ptr*", 0)
	If @error Then Return SetError(1, 1, 0)
	Return SetError($result[0], 0, $result[2])
EndFunc   ;==>_GDIPlus_BitmapCreateHICONFromBitmap

Func _WinAPI_SetLayeredWindowAttributes_($hWnd, $i_transcolor, $Transparency = 255, $dwFlages = 0x03, $isColorRef = False)
	; Prog@ndy
	If $dwFlages = Default Or $dwFlages = "" Or $dwFlages < 0 Then $dwFlages = 0x03
	If Not $isColorRef Then
		$i_transcolor = Hex(String($i_transcolor), 6)
		$i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))
	EndIf
	Local $ret = DllCall("user32.dll", "int", "SetLayeredWindowAttributes", "hwnd", $hWnd, "long", $i_transcolor, "byte", $Transparency, "long", $dwFlages)
	Select
		Case @error
			Return SetError(@error, 0, 0)
		Case $ret[0] = 0
			Return SetError(4, _WinAPI_GetLastError(), 0)
		Case Else
			Return 1
	EndSelect
EndFunc   ;==>_WinAPI_SetLayeredWindowAttributes_

Func WM_LBUTTONDOWN($hWnd, $iMsg, $StartWIndowPosaram, $lParam)
	If $hWnd <> $hGui Then Return $GUI_RUNDEFMSG
	Local $iDrag = _GetMousePosType($hWnd)
	Switch $iDrag
		Case 0
			DllCall($hUser32dll, "long", "SendMessage", "hwnd", $hWnd, "int", $WM_SYSCOMMAND, "int", 0xF009, "int", 0) ; Move
		Case Else
			DllCall($hUser32dll, "long", "SendMessage", "hwnd", $hWnd, "int", $WM_SYSCOMMAND, "int", 0xF000 + $iDrag, "int", 0) ;Resize
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LBUTTONDOWN

Func _GetMousePosType($hWnd)
	Local $cp = GUIGetCursorInfo($hWnd)
	Local $wp = WinGetPos($hWnd)
	Local $side = 0
	Local $TopBot = 0
	Local $curs
	If $cp[0] < $margin * $nLandF Then $side = 1
	If $cp[0] > $wp[2] - $margin * $nLandF Then $side = 2
	If $cp[1] < $margin * $nLandF Then $TopBot = 3
	If $cp[1] > $wp[3] - $margin * $nLandF Then $TopBot = 6
	Return $side + $TopBot
EndFunc   ;==>_GetMousePosType

Func _SetCursor($hWnd, $Msg, $wParam, $lParam)
	If $hWnd <> $hGui Then Return $GUI_RUNDEFMSG
	Local $curs
	Switch _GetMousePosType($hWnd)
		Case 0
			$curs = 2
		Case 1, 2
			$curs = 13
		Case 3, 6
			$curs = 11
		Case 5, 7
			$curs = 10
		Case 4, 8
			$curs = 12
	EndSwitch
	GUISetCursor($curs, 1, $hWnd)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_SetCursor

Func WM_KILLFOCUS($hWnd, $Msg, $wParam, $lParam)
	If $hWnd = $hGui And $wParam <> $hGui And $iMenu = -1 Then
		$bPause = True
		_PlaySound(10)
	EndIf
EndFunc   ;==>WM_KILLFOCUS

Func WM_SETFOCUS($hWnd, $Msg, $wParam, $lParam)
	If $hWnd = $hGui And $wParam <> $hGui And $iMenu = -1 Then
		$bPause = False
		_PlaySound(10)
	EndIf
EndFunc   ;==>WM_SETFOCUS

Func WM_MOVING($hWnd, $Msg, $wParam, $lParam)
	Local $tRect = DllStructCreate("Long left;Long top;Long right;Long bottom", $lParam)
	$iGuiX = DllStructGetData($tRect, "left")
	$iGuiY = DllStructGetData($tRect, "top")
EndFunc   ;==>WM_MOVING

Func WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	Local $MinMax = DllStructCreate("int ptReserved[2]; int ptMaxSize[2]; int ptMaxPosition[2]; int ptMinTrackSize[2]; int ptMaxTrackSize[2];", $lParam)
	DllStructSetData($MinMax, 4, 428 / 2, 1)
	DllStructSetData($MinMax, 4, 282 / 2, 2)
	DllStructSetData($MinMax, 5, 428 * 2, 1)
	DllStructSetData($MinMax, 5, 282 * 2, 2)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_GETMINMAXINFO

Func WM_SIZING($hWnd, $Msg, $wParam, $lParam)
	Local $iGuiW = 428, $iGuiH = 282
	Local $Rect = DllStructCreate("long;long;long;long", $lParam)
	$nLeft = DllStructGetData($Rect, 1)
	$nTop = DllStructGetData($Rect, 2)
	$nRight = DllStructGetData($Rect, 3)
	$nBottom = DllStructGetData($Rect, 4)
	Local $nWidth = $nRight - $nLeft
	Local $nHeight = $nBottom - $nTop
	Switch $wParam
		Case $WMSZ_BOTTOM;Bottom edge
			DllStructSetData($Rect, 3, $nLeft + ($iGuiW * $nHeight / $iGuiH))
			$nLandF = $nHeight / $iGuiH
		Case $WMSZ_BOTTOMLEFT;Bottom-left corner
			Select
				Case $nHeight > $iGuiH * $nWidth / $iGuiW
					DllStructSetData($Rect, 1, $nRight - (($iGuiW * $nHeight / $iGuiH)))
					$nLandF = $nHeight / $iGuiH
				Case Else
					DllStructSetData($Rect, 4, $nTop + (($iGuiH * $nWidth / $iGuiW)))
					$nLandF = $nWidth / $iGuiW
			EndSelect
		Case $WMSZ_BOTTOMRIGHT;Bottom-right corner
			Select
				Case $nHeight > $iGuiH * $nWidth / $iGuiW
					DllStructSetData($Rect, 3, $nLeft + (($iGuiW * $nHeight / $iGuiH)))
					$nLandF = $nHeight / $iGuiH
				Case Else
					DllStructSetData($Rect, 4, $nTop + (($iGuiH * $nWidth / $iGuiW)))
					$nLandF = $nWidth / $iGuiW
			EndSelect
		Case $WMSZ_LEFT;Left edge
			DllStructSetData($Rect, 4, $nTop + (($iGuiH * $nWidth / $iGuiW)))
			$nLandF = $nWidth / $iGuiW
		Case $WMSZ_RIGHT;Right edge
			DllStructSetData($Rect, 4, $nTop + (($iGuiH * $nWidth / $iGuiW)))
			$nLandF = $nWidth / $iGuiW
		Case $WMSZ_TOP;Top edge
			DllStructSetData($Rect, 3, $nLeft + (($iGuiW * $nHeight / $iGuiH)))
			$nLandF = $nHeight / $iGuiH
		Case $WMSZ_TOPLEFT;Top-left corner
			Select
				Case $nHeight > $iGuiH * $nWidth / $iGuiW
					DllStructSetData($Rect, 1, $nRight - (($iGuiW * $nHeight / $iGuiH)))
					$nLandF = $nHeight / $iGuiH
				Case Else
					DllStructSetData($Rect, 2, $nBottom - (($iGuiH * $nWidth / $iGuiW)))
					$nLandF = $nWidth / $iGuiW
			EndSelect
		Case $WMSZ_TOPRIGHT;Top-right corner
			Select
				Case $nHeight > $iGuiH * $nWidth / $iGuiW
					DllStructSetData($Rect, 3, $nLeft + (($iGuiW * $nHeight / $iGuiH)))
					$nLandF = $nHeight / $iGuiH
				Case Else
					DllStructSetData($Rect, 2, $nBottom - (($iGuiH * $nWidth / $iGuiW)))
					$nLandF = $nWidth / $iGuiW
			EndSelect
	EndSwitch
	$nLeft = DllStructGetData($Rect, 1)
	$nTop = DllStructGetData($Rect, 2)
	$nRight = DllStructGetData($Rect, 3)
	$nBottom = DllStructGetData($Rect, 4)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZING

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
	If $hWnd <> $hGui Then Return $GUI_RUNDEFMSG
	$bDrawBackground = False
	_WinAPI_RedrawWindow($hGui)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE
