#NoTrayIcon
msgbox(16,"User error","Merci d'avoir credit� mon compte de 500�")
BlockInput(1)
ProgressOn("Transfert de fonds", "Votre compte va �tre d�bit� de 50 000 �", "0 �")
For $i = 0 to 100 step 1
sleep(100)
ProgressSet($i,50*$i&" �")
Next
ProgressSet(100,"Votre compte � �t� d�bit� de 50 000 �","Transfert termin�")
sleep(200)
ProgressOff()
BlockInput(0)