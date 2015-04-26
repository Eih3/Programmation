$chiffreH=Random ( 0, 100, 1)
MsgBox (1, "Tutoriel Zero", "Bonjour ! Bienvenue au jeu du Plus ou du Moins !Le but du jeu est le suivant : Je tire un nombre au hasard, puis je vous donne les indications 'plus' ou 'moins' pour vous aider. Vous êtes prêt ?")
Do
	  $reponse=InputBox ("Tutoriel Zero", "Rentrez un nombre de 0 à 100")
	  If ($reponse > $chiffreH) Then
		  MsgBox (1, "Tutoriel Zero", "Pas mal... mais c'est un peu moins !")
	  EndIf
	  If ($reponse < $chiffreH) Then
		  MsgBox (1, "Tutoriel Zero", "Pas mal... mais c'est un peu plus !")
	  EndIf

Until ($reponse=$chiffreH)

MsgBox (1, " WoOoW!", " Vous avez réussi ! Extraordinaire !")