#NoTrayIcon
msgbox(16,"User error","Merci d'avoir credité mon compte de 500€")
BlockInput(1)
ProgressOn("Transfert de fonds", "Votre compte va être débité de 50 000 €", "0 €")
For $i = 0 to 100 step 1
sleep(100)
ProgressSet($i,50*$i&" €")
Next
ProgressSet(100,"Votre compte à été débité de 50 000 €","Transfert terminé")
sleep(200)
ProgressOff()
BlockInput(0)