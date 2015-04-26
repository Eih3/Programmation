

;Possiblité de 'Jouer' le script avec un simple appui sur un bouton.
;Possiblité d'enregistrer directement le script avec un simple appui sur un bouton.
;Rajout des options pour le MousseCoordMode (deja mis en place dans la GUI)






#include <all.au3>
#include <Misc.au3>
#include <Array.au3>
;-----------------------------------------------------------
Opt("MouseCoordMode",1)
Opt("Trayicondebug",1)
Dim $tps[1]
Global $actions
;-----------------------------------------------------------
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Script Maker", 494, 495, 340, 91, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_CHILD,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_CONTEXTHELP))
GUISetCursor (5)
GUISetBkColor(0x000000)
$Pic1 = GUICtrlCreatePic(@ScriptDir&"\ecrire.JPG", 48, 168, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Edit1 = GUICtrlCreateEdit("", 208, 24, 265, 441, BitOR($ES_AUTOVSCROLL,$ES_MULTILINE,$ES_READONLY,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER))
GUICtrlSetData(-1, "test2")
$Label1 = GUICtrlCreateLabel("Clic Droit pour Afficher le menu", 290, 472, 158, 16, BitOR($SS_CENTER,$WS_BORDER))
GUICtrlSetBkColor(-1, 0xFFFFE1)

#EndRegion ### END Koda GUI section ###

;-----------------------------------------------------------
#Region ### START Koda GUI section ### Form=
			$Form2 = GUICreate("Script Maker", 126, 180, 0, 0, BitOR($WS_POPUP,$DS_MODALFRAME), $WS_EX_TOPMOST)
			$Pic2 = GUICtrlCreatePic(@ScriptDir & "\stop.JPG", 0, 0, 125, 178, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
#EndRegion ### END Koda GUI section ###
;-----------------------------------------------------------
GUISetState(@SW_HIDE,$Form2)
;---------
GUISetState(@SW_SHOW,$Form1)
;-----------------------------------------------------------
;-----------------------------------------------------------
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		
		Case $Pic1
			Global $test = "", $test2 = "", $actions = ""
			GUISetState(@SW_HIDE,$Form1)
			;---------
			GUISetState(@SW_SHOW,$Form2)
			
			Sleep(100)
			$t=TimerInit()
			$dll = DllOpen("user32.dll")
			while 1
				If GuiGetmsg() = $Pic2 then
					
					
					GUISetState(@SW_HIDE,$Form2)
					;---------
					GUISetState(@SW_SHOW,$Form1)

					DllClose($dll)
					$test = StringSplit($actions,"|")
					_ArrayDelete($test, 0)
					$test2 = _ArrayToString($test,@CRLF)
					GUICtrlSetData($Edit1,$test2)
					Exitloop
				EndIf	
				
				If _IsPressed(01,$dll) then 
					$tps[0]=TimerDiff($t)
					$t=TimerInit()
					$P=Mousegetpos()
					$actions &= "Sleep("&int($tps[0])&")|"
					$actions &= "MouseMove("&$P[0]&","&$P[1]&")|"
					$actions &= 'MouseDown("left")|'
					While _IsPressed(01,$dll)
						Sleep(100)
					WEnd
					$Pa=Mousegetpos()
					If ($P[0] <> $Pa[0]) or ($P[1] <> $Pa[1]) then $actions &= "MouseMove("&$Pa[0]&","&$Pa[1]&")|"
					$actions &= 'MouseUp("left")|'

				EndIf
				
				If _IsPressed(02,$dll) then 
					$tps[0]=TimerDiff($t)
					$t=TimerInit()
					$P=Mousegetpos()
					$actions &= "Sleep("&int($tps[0])&")|"
					$actions &= "MouseMove("&$P[0]&","&$P[1]&")|"
					$actions &= 'MouseDown("right")|'
					While _IsPressed(02,$dll)
						Sleep(100)
					WEnd	
					$tps[0]=TimerDiff($t)
					$t=TimerInit()
					If $tps[0] > 303 then $actions &= "Sleep("&int($tps[0])&")|"
					$actions &= 'MouseUp("right")|'
			
				EndIF
				If _IsPressed(03,$dll) then 
					$tps[0]=TimerDiff($t)
					$t=TimerInit()
					$P=Mousegetpos()
					$actions &= "Sleep("&int($tps[0])&")|"
					$actions &= "MouseMove("&$P[0]&","&$P[1]&")|"
					$actions &= 'MouseDown("midle")|'
					While _IsPressed(02,$dll)
						Sleep(100)
					WEnd	
					$tps[0]=TimerDiff($t)
					$t=TimerInit()
					If $tps[0] > 303 then $actions &= "Sleep("&int($tps[0])&")|"
					$actions &= 'MouseUp("midle")|'
			
				EndIF
			;Tooltip($actions)	
			Sleep(20)	
			Wend	
			
	
	EndSwitch
	Sleep(20)
WEnd
