Run ( "notepad.exe" ) ; Lance le bloc note
WinWaitActive ( "[CLASS:Notepad]" ) ; Attend que la fen�tre nomm�e "Sans titre - Bloc - notes" apparaisse
Sleep (1000)
Send ( "Texte � copier" ) ; Tape le texte : "Texte � copier"
Sleep ( 500 ) ; Ne fait rien pendant 500ms pour que le script ne soit pas trop rapide

Send ( "^a" ) ; Appuie sur CTRL + a ( selectionne tout )
Sleep ( 500 )
Send ( "^c" ) ; Appuie sur CTRL + c ( copie la s�lection )
Sleep ( 500 )

Send ( "{RIGHT}" ) ; Appuie sur la fl�che de droite, pour remettre le curseur au bout de la ligne
Sleep ( 500 )

Send ( "{ENTER}" ) ; Appuie sur ENTREE pour passer � la ligne suivante
sleep ( 500 )

Send ( "^v" ) ; Appuie sur CTRL + v ( colle )
Sleep ( 500 )

Send ( "{ENTER}" ) ; Appuie sur ENTREE pour aller � la ligne
Sleep ( 500 )

Send ( "La date et l'heure sont : {F5}" ) ; Tape le texte "La date et l'heure sont :", puis appuie sur F5 ( F5 est une fonction du bloc note qui ins�re la date et l'heure )
Sleep ( 500 )

Send ( "!f" ) ; Appuie sur ALT + f : ouvre le fichier menu
Sleep ( 500 )

Send ( "q" ) ; Appuie sur q : pour Quitter
Sleep ( 500 )

Send ( "n" ) ; Appuie sur n ( ne pas sauvegarder )