#include <File.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>



If FileExists("Lista.ini") Then

	$lista = IniRead("Lista.ini", "Lista" , "Caminho","")
	$var = $lista
Else
	$var = @ScriptDir
EndIf



Local $FileList = _FileListToArray($var, "*.*", 1)

$tocando = False
$music = 1
$voll = "Vol"
$vol = 50
$title = "Nova Música"
$max = $FileList[0]

#region ### START Koda GUI section ### Form=d:\documents and settings\xan\meus documentos\programação\autoit\koda_1.7.3.0\forms\player.kxf

$Form1_1 = GUICreate("Autoit Sound Play", 500, 313, 192, 124)
GUISetBkColor(0x393952)

$List1 = GUICtrlCreateList("", 200, 8, 261, 220)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

For $i = 1 To $max Step 1
	GUICtrlSetData($List1, $FileList[$i])
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Next

$Volume = GUICtrlCreateLabel("Volume", 0, 344, 92, 33)
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
$Prev = GUICtrlCreateButton("Prev", 104, 2, 81, 41)
GUICtrlSetBkColor(-1, 0xff6633)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Next = GUICtrlCreateButton("Next", 104, 51, 81, 49)
GUICtrlSetBkColor(-1, 0xff6633)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xffffff)
$Play = GUICtrlCreateButton("Play", 8, 2, 89, 97)
GUICtrlSetBkColor(-1, 0xbdc6c6)
GUICtrlSetFont(-1, 24, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x008000)
$Stop = GUICtrlCreateButton("Stop", 8, 110, 177, 33)
GUICtrlSetBkColor(-1, 0xbdc6c6)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x800000)
$List = GUICtrlCreateButton("List", 136, 147, 49, 73)
GUICtrlSetBkColor(-1, 0x999999)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xcccccc)
$VolUP = GUICtrlCreateButton("VolUP", 72, 147, 57, 73)
GUICtrlSetBkColor(-1, 0xbdc6c6)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x808000)
$AutoSound = GUICtrlCreateLabel("A" & @CR & "U" & @CR & "T" & @CR & "O" & @CR & @CR & @CR & "S" & @CR & "O" & @CR & "U" & @CR & "N" & @CR & "D", 478, 10, 257, 217)
$VolDown = GUICtrlCreateButton("VolDown", 8, 147, 57, 73)
GUICtrlSetBkColor(-1, 0xbdc6c6)
GUICtrlSetColor(-1, 0x808000)
$Volume = GUICtrlCreateLabel("Volume", 40, 230, 400, 45)
GUICtrlSetFont(-1, 30, 500, 0, "MS Sans Serif")
$List2 = GUICtrlCreateList($title & " *********************************", 0, 280, 500, 45)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)

#endregion ### END Koda GUI section ###

SoundPlay($var & "\" & $music, 0)

While 1

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Play
			$title = $FileList[$music]
			SoundPlay($var & "\" & $FileList[$music], 0)
			$List2 = GUICtrlCreateList($title & " *********************************", 0, 280, 500, 45)
			GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
			$tocando = True;

		Case $Prev

			If $tocando And $music > 1 Then
				$music -= 1
				$title = $FileList[$music]
				SoundPlay($var & "\" & $FileList[$music], 0)
				$List2 = GUICtrlCreateList($title & " *********************************", 0, 280, 500, 45)
				GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")

			EndIf
			If $tocando And $music < 2 Then

				SoundPlay($var & "\" & $FileList[$music], 0)

			EndIf

		Case $Next
			If $tocando And $music < $max Then
				$music += 1
				$title = $FileList[$music]
				$List2 = GUICtrlCreateList($title & " *********************************", 0, 280, 500, 45)
				GUICtrlSetBkColor(-1, 0xFFFFFF)
				GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
				SoundPlay($var & "\" & $FileList[$music], 0)

			EndIf
		Case $Stop
			SoundPlay("nosound", 0)
			$tocando = False
		Case $VolDown
			If $tocando And $vol >= 10 Then
				$vol -= 10
				$Volume = GUICtrlCreateLabel($voll & "  " & $vol, 40, 230, 400, 45)
				GUICtrlSetFont(-1, 30, 500, 0, "MS Sans Serif")
			EndIf
		Case $VolUP
			If $tocando And $vol < 500 Then
				$vol += 100
				$Volume = GUICtrlCreateLabel($voll & "  " & $vol, 40, 230, 400, 45)
				GUICtrlSetFont(-1, 30, 500, 0, "MS Sans Serif")
			EndIf

		Case $List
			$List1 = GUICtrlCreateList("", 200, 8, 261, 220)
             GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif") ; Zerando as  músicas
			$openwin = FileSelectFolder("Escolha um pasta.", "")
			$var = $openwin                                       ; var igual ao diretório aberto
			Local $FileList = _FileListToArray($var, "*.mp3", 0)  ; transforma os mp3 em arreys
			$max = $FileList[0]                                   ; [0] número de mp3 é o limite max
            $open  = FileOpen("Lista.ini", 2)
			$lista = IniWrite("Lista.ini", "Lista", "Caminho", $var)

			For $i = 1 To $max Step 1
				GUICtrlSetData($List1, $FileList[$i])
				GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
			Next

		Case $GUI_EVENT_CLOSE

			Exit

	EndSwitch
	SoundSetWaveVolume($vol)
	Sleep(10)

WEnd