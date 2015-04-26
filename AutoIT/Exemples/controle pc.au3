#include <GUIConstants.au3>


$Form1 = GUICreate("Contrôle Ordinateur", 287, 120, 193, 125)
$Button1 = GUICtrlCreateButton("Ouvrire CD", 8, 8, 129, 17, 0)
$Button2 = GUICtrlCreateButton("Fermer CD", 8, 32, 129, 17, 0)
$Button3 = GUICtrlCreateButton("Ouvrire C:", 8, 72, 129, 17, 0)
$Button4 = GUICtrlCreateButton("Ouvrire D:", 8, 96, 129, 17, 0)
$Button5 = GUICtrlCreateButton("Arret PC", 150, 8, 129, 17, 0)
$Button6 = GUICtrlCreateButton("Redémarer PC", 150, 32, 129, 17, 0)
$Button7 = GUICtrlCreateButton("Ouvrir Clé", 150, 72, 129, 17, 0)
$Button8 = GUICtrlCreateButton("Ouvrir Disque Externe", 150, 96, 129, 17, 0)
GUISetState(@SW_SHOW)


While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $Button1
CDTray("E:", "open")
Case $Button2
CDTray("E:", "close")
Case $Button3
ShellExecute("C:")
Case $Button4
ShellExecute("D:")
Case $Button5
Shutdown (5)
Case $Button6
Shutdown (6)
Case $Button7
ShellExecute("E:")
Case $Button8
ShellExecute("H:")
Case $GUI_EVENT_CLOSE
Exit

EndSwitch
WEnd