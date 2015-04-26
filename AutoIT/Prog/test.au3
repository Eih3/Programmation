HotKeySet("{ESC}", "Stop")

While 1
Sleep(100)
MouseMove(50, 95)
MouseMove(50, 150)
MouseMove(500, 150)
MouseMove(500, 95)
Sleep(100)
Beep(262*2, 500)
Beep(262*2, 200)
Beep(294*2, 500)
Beep(262*2, 1000)
Beep(349*2, 500)
Beep(330*2, 2000)
Sleep(500)
Beep(262*2, 500)
Beep(262*2, 200)
Beep(294*2, 500)
Beep(262*2, 1000)
Beep(392*2, 500)
Beep(349*2, 1000)
WEnd


Func Stop()
Exit
EndFunc