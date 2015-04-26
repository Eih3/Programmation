
; ----------------------------------------------------
; -------------------- Section VI --------------------
; ----------------------------------------------------
#region ################### Fonctions ###################

	; Lancement du splash screen.
	SplashTextOn("", "Fermeture du script en cours,  Veuillez patienter ...", 450, 70, -1, -1, 0 + 1 + 16 + 32, "Arial", 12, 800)

	; Pause de 3 secondes.
	Sleep(3000)

	; Fermeture du splash.
	SplashOff()



#endregion ################### Fonctions ###################


Local $destination = "logo.jpg"

SplashImageOn("Splash Screen", $destination, 250, 50)
Sleep(3000)
SplashOff()