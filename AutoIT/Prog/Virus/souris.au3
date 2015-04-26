#NoTrayIcon

HotKeySet("{ESC}", "Stop")
While 1
$x = Random(50,1500)
$y = Random(50,1500)
MouseMove($x,$y)
WEnd


Func Stop()
Exit
EndFunc