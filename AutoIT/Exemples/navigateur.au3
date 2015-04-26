    #include <GUIConstantsEx.au3>
    #include <IE.au3>
    #include <WindowsConstants.au3>
    #include <date.au3>

    Opt("GUIOnEventMode", 1)
    GUICreate("Navigateur Perso", 800, 600, 0, 0, $WS_OVERLAPPEDWINDOW)
    $lblAdresse = GUICtrlCreateLabel(" Adresse : ", 0, 8)
    $txtAdresse = GUICtrlCreateInput("", 60, 5, 700)
    $cmdGo = GUICtrlCreateButton(" Go ! ", 760, 5, 40, 22)
    GUICtrlSetOnEvent($cmdGo, "go")
    $lblHistorique = GUICtrlCreateLabel(" Historique : ", 0, 34)
    $listeHistorique = GUICtrlCreateCombo("", 60, 30, 700)
    $cmdGo2 = GUICtrlCreateButton(" Go ! ", 760, 30, 40, 22)
    GUICtrlSetOnEvent($cmdGo2, "go2")
    $gauche = 50
    $cmdPrecedent = GUICtrlCreateButton(" <---- ", 60, 55, 70, 22)
    GUICtrlSetOnEvent($cmdPrecedent, "precedent")
    $cmdSuivant = GUICtrlCreateButton(" ----> ", 130, 55, 70, 22)
    GUICtrlSetOnEvent($cmdSuivant, "suivant")
    $cmdArreter = GUICtrlCreateButton(" Arrêter ", 200, 55, 70, 22)
    GUICtrlSetOnEvent($cmdArreter, "arreter")
    $cmdAcutaliser = GUICtrlCreateButton(" Acutaliser ", 270, 55, 70, 22)
    GUICtrlSetOnEvent($cmdAcutaliser, "actualiser")
    $cmdDemarrage = GUICtrlCreateButton(" Démarrage ", 340, 55, 70, 22)
    GUICtrlSetOnEvent($cmdDemarrage, "demarrage")
    $cmdRechercher = GUICtrlCreateButton(" Rechercher ", 410, 55, 70, 22)
    GUICtrlSetOnEvent($cmdRechercher, "rechercher")
    $cmdEnregistrer = GUICtrlCreateButton(" Enregistrer ", 480, 55, 70, 22)
    GUICtrlSetOnEvent($cmdEnregistrer, "enregistrer")
    $cmdImprimer = GUICtrlCreateButton(" Imprimer ", 550, 55, 70, 22)
    GUICtrlSetOnEvent($cmdImprimer, "imprimer")
    _IEErrorHandlerRegister()
    $ie = _IECreateEmbedded()
    $ieobject = GUICtrlCreateObj($ie, 0, 82, 800, 540)
    $ancien = ""
    $go = 1
    _IEAction($ie, "home")
    HotKeySet("{esc}", "arreter")
    GUISetOnEvent($GUI_EVENT_CLOSE, "quitter")
    GUISetState()
    While 1
        If ControlGetFocus("Navigateur Perso") = "Edit1" Then
            HotKeySet("{enter}", "go")
        Else
            If ControlGetFocus("Navigateur Perso") = "Edit2" Then
                HotKeySet("{enter}", "go2")
            Else
                HotKeySet("{enter}")
            EndIf
        EndIf
        Sleep(10)
        GUICtrlSetResizing($ieobject, $GUI_DOCKAUTO + $GUI_DOCKBOTTOM + $GUI_DOCKTOP)
        GUICtrlSetResizing($lblAdresse, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
        GUICtrlSetResizing($txtAdresse, $GUI_DOCKRIGHT + $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetResizing($cmdGo, $GUI_DOCKRIGHT + $GUI_DOCKSIZE + $GUI_DOCKTOP)
        GUICtrlSetResizing($lblHistorique, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
        GUICtrlSetResizing($listeHistorique, $GUI_DOCKRIGHT + $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetResizing($cmdGo2, $GUI_DOCKRIGHT + $GUI_DOCKSIZE + $GUI_DOCKTOP)
        GUICtrlSetResizing($cmdPrecedent, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdSuivant, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdArreter, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdAcutaliser, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdDemarrage, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdRechercher, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdEnregistrer, $GUI_DOCKALL)
        GUICtrlSetResizing($cmdImprimer, $GUI_DOCKALL)
        $nouveau = _IEPropertyGet($ie, "locationurl")
        If $ancien <> $nouveau Then
            GUICtrlSetData($txtAdresse, $nouveau)
            GUICtrlSetData($listeHistorique, _Now() & " => " & $nouveau, _Now() & " => " & $nouveau)
            $ancien = $nouveau
            $go = 0
        EndIf
    WEnd
    Func go()
        _IENavigate($ie, GUICtrlRead($txtAdresse), 0)
    EndFunc   ;==>go
    Func go2()
        _IENavigate($ie, StringMid(GUICtrlRead($listeHistorique), 24), 0)
    EndFunc   ;==>go2
    Func precedent()
        _IEAction($ie, "back")
        If @error Then
            MsgBox(0, "", "")
        EndIf
    EndFunc   ;==>precedent
    Func suivant()
        _IEAction($ie, "forward")
    EndFunc   ;==>suivant
    Func arreter()
        _IEAction($ie, "stop")
    EndFunc   ;==>arreter
    Func actualiser()
        _IEAction($ie, "refresh")
    EndFunc   ;==>actualiser
    Func demarrage()
        _IEAction($ie, "home")
    EndFunc   ;==>demarrage
    Func rechercher()
        _IENavigate($ie, "http://www.google.fr", 0)
    EndFunc   ;==>rechercher
    Func enregistrer()
        _IEAction($ie, "saveas")
    EndFunc   ;==>enregistrer
    Func imprimer()
        _IEAction($ie, "print")
    EndFunc   ;==>imprimer
    Func quitter()
        Exit
    EndFunc   ;==>quitter