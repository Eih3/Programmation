    #include <Inet.au3>
    #include <ButtonConstants.au3>
    #include <EditConstants.au3>
    #include <GUIConstantsEx.au3>
    #include <StaticConstants.au3>
    #include <WindowsConstants.au3>
    #include <GuiComboBox.au3>
    #Include <String.au3>
    Global $smtp, $titre, $emaildestin, $emailemet, $smtp, $file, $nom
    #Region ### START Koda GUI section ### Form=
    $Messager = GUICreate("Messager V1.2 ", 340, 660, 300, 160)
    $GRP_INFOS = GUICtrlCreateGroup("Infos", 9, 11, 321, 113)
    $LBL_SMTP = GUICtrlCreateLabel("Votre FAI :", 17, 31, 66, 19)
    $LBL_EMAILE = GUICtrlCreateLabel("Votre adresse e-mail :", 17, 61, 102, 19)
    $INP_EMAILE = GUICtrlCreateInput("", 179, 61, 145, 23)
    $INP_EMAILD = GUICtrlCreateInput("", 179, 91, 145, 23)
    $LBL_EMAILD = GUICtrlCreateLabel("Adresse e-mail du destinataire :", 17, 91, 146, 19)
    $GRP_MESS = GUICtrlCreateGroup("E-Mail", 8, 128, 321, 377 + 60)
    $INP_TITRE = GUICtrlCreateInput("", 178, 148, 145, 23)
    $LBL_TITRE = GUICtrlCreateLabel("Titre du message :", 16, 148, 87, 19)
    $LBL_BODY = GUICtrlCreateLabel("Corps du message :", 16, 242, 244, 19)
    $EDIT = GUICtrlCreateEdit("", 16, 216 + 50, 305, 285)
    $BTN_SEND = GUICtrlCreateButton("Envoyer", 8, 512 + 60, 321, 33, $WS_GROUP)
    $LBL_NOM = GUICtrlCreateLabel("Nom sous lequel vous souhaitez" & @CRLF & " apparaître :", 16, 190)
    $INP_NOM = GUICtrlCreateInput("", 178, 200, 145, 23)
    GUISetState(@SW_SHOW)
    $CMB_FAI = GUICtrlCreateCombo("", 179, 31, 145, 23)
    GUICtrlSetData(-1, " 9 Telecom| ALICE| AOL| Bouygues BBOX| Bouygues Télécom| CEGETEl| DARTY BOX| FREE| ORANGE| Numéricable| SFR| TELE2| WANADOO| YAHOO")
    $BTN_FILE = GUICtrlCreateButton("Enregistrer les paramètres", 8, 550 + 60, 321, 33)
    $PRG_FILE = GUICtrlCreateProgress(9,646,"",10)
    GUICtrlSetFont(-1, 8, 400, 0, "Futura Lt")
    GUICtrlSetFont($LBL_NOM, 8, 400, 0, "Futura Lt")
    GUICtrlSetFont($INP_NOM, 8, 400, 0, "Futura Lt")
    GUICtrlSetFont($GRP_MESS, 8, 400, 0, "Futura Lt")
    GUICtrlSetFont($GRP_MESS, 8, 400, 0, "Futura Lt")
    GUICtrlSetFont($LBL_BODY, 8, "", "", "Futura Lt")
    GUICtrlSetFont($LBL_EMAILD, 8, "", "", "Futura Lt")
    GUICtrlSetFont($LBL_EMAILE, 8, "", "", "Futura Lt")
    GUICtrlSetFont($LBL_TITRE, 8, "", "", "Futura Lt")
    GUICtrlSetFont($LBL_SMTP, 8, "", "", "Futura Lt")
    GUICtrlSetFont($BTN_FILE, 8, "", "", "Futura Lt")
    GUICtrlSetFont($INP_EMAILD, 8, "", "", "Futura Lt")
    GUICtrlSetFont($INP_EMAILE, 8, "", "", "Futura Lt")
    GUICtrlSetFont($INP_TITRE, 8, "", "", "Futura Lt")
    GUICtrlSetFont($CMB_FAI, 8, "", "", "Futura Lt")
    GUICtrlSetFont($GRP_INFOS, 8, "", "", "Futura Lt")
    GUICtrlSetFont($EDIT, 8, "", "", "Futura Lt")
    GUICtrlSetFont($BTN_SEND, 8, "", "", "Futura Lt")
    #EndRegion ### END Koda GUI section ###
    Global $body[10]
    lireFile()
    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit
            Case $BTN_SEND
                sendEmail()
            Case $BTN_FILE
                ecrireFile()
        EndSwitch
    WEnd
    Func sendEmail()
        $bodyString = GUICtrlRead($EDIT)
        $body = StringSplit($bodyString, @CRLF, 1)
        For $i = 1 To UBound($body) - 1
        Next
        $titre = GUICtrlRead($INP_TITRE)
        $emaildestin = GUICtrlRead($INP_EMAILD)
        $emailemet = GUICtrlRead($INP_EMAILE)
        $smtp1 = GUICtrlRead($CMB_FAI)
        Switch $smtp1
            Case " 9 Telecom"
                $smtp = "smtp.neuf.fr"
            Case " ALICE"
                $smtp = "smtp.alice.fr"
            Case " AOL"
                $smtp = "smtp.neuf.fr"
            Case " Bouygues BBOX"
                $smtp = "smtp.bbox.fr"
            Case " Bouygues Télécom"
                $smtp = "smtp.bouygtel.fr"
            Case " CEGETEL"
                $smtp = "smtp.cegetel.net"
            Case " DARTY BOX"
                $smtp = "smtpauth.dbmail.com"
            Case " FREE"
                $smtp = "smtp.free.fr"
            Case " ORANGE"
                $smtp = "smtp.orange.fr"
            Case " Numéricable"
                $smtp = "smtp.numericable.fr"
            Case " SFR"
                $smtp = "smtp.sfr.fr"
            Case " TELE2"
                $smtp = "smtp.tele2.fr"
            Case " WANADOO"
                $smtp = "smtp.wanadoo.fr"
            Case " YAHOO"
                $smtp = "smtp.mail.yahoo.fr"
        EndSwitch
        $nom = GUICtrlRead($INP_NOM)
        If 0 = _INetSmtpMail($smtp, $nom, $emailemet, $emaildestin, $titre, $body) Then
            Switch @error
                Case 1
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Paramètres invalides.")
                Case 2
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Impossible de lancer le service TCP.")
                Case 3
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Impossible de résoudre l'IP.")
                Case 4
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Impossible de créer le socket.")
                Case 50 To 59
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Impossible d'ouvrir la session SMTP.")
                Case 500 To 509
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Impossible d'envoyer le corps.")
                Case 5000
                    MsgBox(0, "Erreur", "Echec dans l'envoi de l'email. Erreur " & @error & ". Impossible de fermer la session SMTP.")
            EndSwitch
        Else
            GUICtrlSetData($PRG_FILE,100)
            Sleep(600)
            GUICtrlSetData($PRG_FILE,0)
        EndIf
    EndFunc   ;==>sendEmail
    Func ecrireFile()
        IniWrite("messager.INI", "Paramètres", "smtp1",(_StringEncrypt(1,(_GUICtrlComboBox_GetCurSel($CMB_FAI)),"Cadernis",5)))
        GUICtrlSetData($PRG_FILE,33)
        IniWrite("messager.INI", "Paramètres", "emailemet", (_StringEncrypt(1,(GUICtrlRead($INP_EMAILE)),"Cadernis",5)))
        GUICtrlSetData($PRG_FILE,66)
        IniWrite("messager.INI", "Paramètres", "nom", (_StringEncrypt(1,(GUICtrlRead($INP_NOM)),"Cadernis",5)))
        GUICtrlSetData($PRG_FILE,100)
        Sleep(600)
        GUICtrlSetData($PRG_FILE,0)
    EndFunc   ;==>ecrireFile
    Func lireFile()
        _GUICtrlComboBox_SetCurSel($CMB_FAI, (_StringEncrypt(0,(IniRead("messager.INI", "Paramètres", "smtp1", "")),"Cadernis",5)))
        GUICtrlSetData($INP_EMAILE, (_StringEncrypt(0,(IniRead("messager.INI", "Paramètres", "emailemet", "")),"Cadernis",5)))
        GUICtrlSetData($INP_NOM, (_StringEncrypt(0,(IniRead("messager.INI", "Paramètres", "nom", "")),"Cadernis",5)))


    EndFunc   ;==>lireFile