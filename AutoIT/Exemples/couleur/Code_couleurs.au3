#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.0
	
#ce ----------------------------------------------------------------------------

#include <WindowsConstants.au3>
#include <SliderConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GUIconstants.au3>

Dim $Palette1 = @TempDir & "\palette1.jpg"
Dim $Palette2 = @TempDir & "\palette2.jpg"
FileInstall("palette1.jpg", @TempDir & "\palette1.jpg", 1)
FileInstall("palette2.jpg", @TempDir & "\palette2.jpg", 1)

GUICreate("Codes des couleurs", 630, 325, -1, -1, $WS_SYSMENU)
WinSetOnTop("Codes des couleurs", "", 1)
Opt("GUIOnEventMode", 1)
$lblCodeRGB = GUICtrlCreateLabel("Code RGB : ", 10, 10, 60)
$lblRouge = GUICtrlCreateLabel("Rouge : ", 30, 30, 40)
GUICtrlSetColor($lblRouge, 0xff0000)
$txtRouge = GUICtrlCreateLabel("0", 75, 30, 30)
$lblVert = GUICtrlCreateLabel("Vert : ", 30, 50, 40)
GUICtrlSetColor($lblVert, 0x00ff00)
$txtVert = GUICtrlCreateLabel("0", 75, 50, 30)
$lblBleu = GUICtrlCreateLabel("Bleu : ", 30, 70, 40)
GUICtrlSetColor($lblBleu, 0x0000ff)
$txtBleu = GUICtrlCreateLabel("0", 75, 70, 30)
$lblHexa = GUICtrlCreateLabel("Code Hexadécimal : ", 10, 97, 100)
;$lblCodeHexa = GUICtrlCreateInput("000000",110,97,50,-1,$ES_READONLY)
$lblCodeHexa = GUICtrlCreateLabel("000000", 110, 97, 50)
$lblCouleur = GUICtrlCreateLabel("", 160, 10, 130, 100)
GUICtrlSetBkColor($lblCouleur, 0x000000)
$lblSliderRouge = GUICtrlCreateLabel("Rouge : ", 10, 135, 40)
GUICtrlSetColor($lblSliderRouge, 0xff0000)
$SliderRouge = GUICtrlCreateSlider(50, 130, 250, 30, $TBS_NOTICKS)
GUICtrlSetLimit($SliderRouge, 255, 0)
$lblSliderVert = GUICtrlCreateLabel("Vert : ", 10, 165, 40)
GUICtrlSetColor($lblSliderVert, 0x00ff00)
$SliderVert = GUICtrlCreateSlider(50, 160, 250, 30, $TBS_NOTICKS)
GUICtrlSetLimit($SliderVert, 255, 0)
$lblSliderBleu = GUICtrlCreateLabel("Bleu : ", 10, 195, 40)
GUICtrlSetColor($lblSliderBleu, 0x0000ff)
$SliderBleu = GUICtrlCreateSlider(50, 190, 250, 30, $TBS_NOTICKS)
GUICtrlSetLimit($SliderBleu, 255, 0)
$cmdStart = GUICtrlCreateButton("Lancer couleur curseur", 10, 230, 135, 25)
GUICtrlSetOnEvent($cmdStart, "start")
$cmdStop = GUICtrlCreateButton("Stopper couleur curseur", 155, 230, 135, 25)
GUICtrlSetOnEvent($cmdStop, "stop")
$cmdChanger = GUICtrlCreateButton("Changer de palette", 10, 260, 135, 25)
GUICtrlSetOnEvent($cmdChanger, "changer")
$cmdCopier = GUICtrlCreateButton("Copier le code hexa", 155, 260, 135, 25)
GUICtrlSetOnEvent($cmdCopier, "copier")
$palette = $Palette1
$img = GUICtrlCreatePic($palette, 305, 10, 310, 275)
GUICtrlSetOnEvent($img, "test")
HotKeySet("+!d", "start")
HotKeySet("+!s", "stop")
$fin = 1
GUISetOnEvent($GUI_EVENT_CLOSE, "quitter")
GUISetState()
While 1
	Sleep(500)

	$tabFenetre = WinGetPos("Codes des couleurs")
	$tabCurseur = GUIGetCursorInfo()
	If Not @error Then
		$x = $tabCurseur[0]
		$y = $tabCurseur[1]
		If $y >= 230 And $y <= 255 Then
			If $x >= 10 And $x <= 145 Then
				ToolTip("Lancer : Shift+Alt+D", $x + 12 + $tabFenetre[0], $y + 50 + $tabFenetre[1])
			Else
				If $x >= 155 And $x <= 290 Then
					ToolTip("Stopper : Shift+Alt+S", $x + 12 + $tabFenetre[0], $y + 50 + $tabFenetre[1])
				Else
					ToolTip("")
				EndIf
			EndIf
		Else
			ToolTip("")
		EndIf
		If $y >= 10 And $y <= 285 Then
			If $x >= 305 And $x <= 615 Then
				ToolTip("Cliquez sur un couleur", $x + 12 + $tabFenetre[0], $y + 50 + $tabFenetre[1])
			EndIf
		EndIf

		If $fin = 0 Then
			$pos = MouseGetPos()
			$couleurSouris = PixelGetColor($pos[0], $pos[1])
			GUICtrlSetBkColor($lblCouleur, "0x" & Hex($couleurSouris, 6))
			GUICtrlSetData($lblCodeHexa, Hex($couleurSouris, 6))
			GUICtrlSetData($txtRouge, Dec(StringLeft(Hex($couleurSouris, 6), 2)))
			GUICtrlSetData($txtVert, Dec(StringMid(Hex($couleurSouris, 6), 3, 2)))
			GUICtrlSetData($txtBleu, Dec(StringRight(Hex($couleurSouris, 6), 2)))
			GUICtrlSetData($SliderRouge, GUICtrlRead($txtRouge))
			GUICtrlSetData($SliderVert, GUICtrlRead($txtVert))
			GUICtrlSetData($SliderBleu, GUICtrlRead($txtBleu))
		Else
			$rouge = Hex(GUICtrlRead($SliderRouge), 2)
			GUICtrlSetData($txtRouge, GUICtrlRead($SliderRouge))
			$vert = Hex(GUICtrlRead($SliderVert), 2)
			GUICtrlSetData($txtVert, GUICtrlRead($SliderVert))
			$bleu = Hex(GUICtrlRead($SliderBleu), 2)
			GUICtrlSetData($txtBleu, GUICtrlRead($SliderBleu))
			$CodeCouleurHexa = $rouge & $vert & $bleu
			GUICtrlSetBkColor($lblCouleur, "0x" & $CodeCouleurHexa)
			GUICtrlSetData($lblCodeHexa, $CodeCouleurHexa)
		EndIf
	EndIf
WEnd
Func test()
	If $y >= 10 And $y <= 285 Then
		If $x >= 305 And $x <= 615 Then
			$couleurSouris = PixelGetColor($x + 3 + $tabFenetre[0], $y + 30 + $tabFenetre[1])
			GUICtrlSetBkColor($lblCouleur, "0x" & Hex($couleurSouris, 6))
			GUICtrlSetData($lblCodeHexa, Hex($couleurSouris, 6))
			GUICtrlSetData($txtRouge, Dec(StringLeft(Hex($couleurSouris, 6), 2)))
			GUICtrlSetData($txtVert, Dec(StringMid(Hex($couleurSouris, 6), 3, 2)))
			GUICtrlSetData($txtBleu, Dec(StringRight(Hex($couleurSouris, 6), 2)))
			GUICtrlSetData($SliderRouge, GUICtrlRead($txtRouge))
			GUICtrlSetData($SliderVert, GUICtrlRead($txtVert))
			GUICtrlSetData($SliderBleu, GUICtrlRead($txtBleu))
		EndIf
	EndIf
EndFunc   ;==>test
Func start()
	$fin = 0
	$tableau = GUIGetCursorInfo()
	$x = $tableau[0]
	$y = $tableau[1]
	ToolTip("Shift+Alt+d", $x, $y)
EndFunc   ;==>start
Func stop()
	$fin = 1
EndFunc   ;==>stop
Func changer()
	If $palette = $Palette1 Then
		$palette = $Palette2
		GUICtrlSetImage($img, $palette)
	Else
		If $palette = $Palette2 Then
			$palette = $Palette1
			GUICtrlSetImage($img, $palette)
		EndIf
	EndIf
EndFunc   ;==>changer
Func copier()
	ClipPut(GUICtrlRead($lblCodeHexa))
EndFunc   ;==>copier
Func quitter()
	Exit
EndFunc   ;==>quitter