#NoTrayIcon
HotKeySet("{ESC}", "Stop")

While 1
WEnd


Func Stop()
Sleep (1000)
Send ( "34N0v16Agd&W" ) ; Tape le texte : "Texte à copier"
Sleep ( 500 ) ; Ne fait rien pendant 500ms pour que le script ne soit pas trop rapide
Send ( "{ENTER}" ) ; Appuie sur ENTREE pour aller à la ligne

Exit
EndFunc
