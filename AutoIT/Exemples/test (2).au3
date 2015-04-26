Opt("WinTitleMatchMode", 4)
$hwnd = WinGetHandle('classname=Progman')
DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hwnd, 'int', 274, 'int', 61808, 'int', 2)
sleep(1000)
DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hwnd, 'int', 274, 'int', 61808, 'int', -1)    #include <guiconstants.au3>
    #include <iNet.au3>

    ;récupération de l'ip de la passerelle
    $ipPasserelle = _GetIP() ;
    ;création du GUI
    GUICreate("Menu Principal + PingMaster_v1", 400, 500)
    ;création du conteneur d'onglets
    $tabPrincipal = GUICtrlCreateTab(10, 10, 380, 480)
    ;création de l'onglet Ping Passerelle
    $tabItemPG = GUICtrlCreateTabItem("Ping Passerelle")
    GUICtrlSetState(+1, $GUI_SHOW)
    GUICtrlCreateLabel("Entrez l'adresse IP de la passerelle ( routeur , gateway , box... ) , ", 15, 40, +1, +1, $SS_CENTER)
    GUICtrlCreateLabel("Puis cliquez sur Ping.", 15, 60, +1, +1, $SS_CENTER)
    $inputIP = GUICtrlCreateInput($ipPasserelle, 15, 100, 180)
    $butPing1 = GUICtrlCreateButton("Ping", 150, 160, 100)
    $areaPingStat1 = GUICtrlCreateEdit(" + + + + *Fenêtre de stats* + + + + " & @CRLF, 35, 220, 320, 210, $ES_MULTILINE + $ES_READONLY + $ES_WANTRETURN + $ES_AUTOVSCROLL)
    ;création de l'onglet Ping Internet
    $tabitemPI = GUICtrlCreateTabItem("Ping Internet")
    GUICtrlCreateLabel("Entrez l'URL d'un serveur web , puis cliquez sur Ping", 15, 40, +1, +1, $SS_CENTER)
    $inputURL = GUICtrlCreateInput("www.google.fr", 15, 100, 250)
    $butPing2 = GUICtrlCreateButton("Ping", 150, 160, 100)
    $areaPingStat2 = GUICtrlCreateEdit(" + + + + *Fenêtre de stats* + + + + " & @CRLF, 35, 220, 320, 210, $ES_MULTILINE + $ES_READONLY + $ES_WANTRETURN + $ES_AUTOVSCROLL)
    ;création de l'onglet Ping Internet et Passerelle
    $tabItemP2 = GUICtrlCreateTabItem("Ping Internet et Passerelle")
    GUICtrlCreateLabel("Entrez l'adresse IP de la passerelle puis l'URL du serveur web", 15, 40, +1, +1, $SS_CENTER)
    $inputIP2 = GUICtrlCreateInput($ipPasserelle, 15, 75, 180)
    $inputURL2 = GUICtrlCreateInput("www.google.fr", 15, 120, 250)
    $butPing3 = GUICtrlCreateButton("Ping", 150, 160, 100)
    $areaPingStat3 = GUICtrlCreateEdit(" + + + + *Fenêtre de stats* + + + + " & @CRLF, 35, 220, 320, 210, $ES_MULTILINE + $ES_READONLY + $ES_WANTRETURN + $ES_AUTOVSCROLL)
    GUICtrlCreateTabItem("")
    GUISetState()
    ;écoute des messages
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $butPing1
                $GIPA = GUICtrlRead($inputIP)
                $pingGatewayResult = fPingGateway($GIPA)
                GUICtrlSetData($areaPingStat1, $pingGatewayResult, Default)
            Case $msg = $butPing2
                $SURLA = GUICtrlRead($inputURL)
                $pingServerResult = fPingServer($SURLA)
                GUICtrlSetData($areaPingStat2, $pingServerResult, Default)
            Case $msg = $butPing3
                $IP = GUICtrlRead($inputIP2)
                $URL = GUICtrlRead($inputURL2)
                $pingAllResult = fPingAll($IP, $URL)
                GUICtrlSetData($areaPingStat3, $pingAllResult, Default)
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
        EndSelect
    WEnd
    ;définition des fonctions
    ;définition de fPingGateway ( )
    Func fPingGateway($value1)
        Local $Ping = Ping($value1, 250)
        If $Ping Then
            Local $ResultGood = "La passerelle est en ligne , roundtrip: " & $Ping & @CRLF
            Return $ResultGood
        Else
            Local $ResultBad = "La passerelle est injoignable , code d'erreur: " & @error & @CRLF
            Return $ResultBad
        EndIf
    EndFunc   ;==>fPingGateway
    ;définition de fPingServer ( )
    Func fPingServer($value2)
        Local $Ping = Ping($value2, 250)
        If $Ping Then
            Local $ResultGood = "Le serveur est en ligne , vous êtes connecter à internet , roundtrip: " & $Ping & @CRLF
            Return $ResultGood
        Else
            Local $ResultBad = "Le serveur n'est pas joignable , code d'erreur: " & @error & @CRLF
            Return $ResultBad
        EndIf
    EndFunc   ;==>fPingServer
    ;définition de fPingAll ( )
    Func fPingAll($value3, $value4)
        Local $PingIP = Ping($value3, 250)
        If $PingIP Then
            Local $ResultGoodIP = "La passerelle est en ligne , roundtrip: " & $PingIP & @CRLF
            Local $PingURL = Ping($value4, 250)
            If $PingURL Then
                Local $ResultGoodURL = "Le serveur est en ligne , vous êtes connecter à internet , roundtrip: " & $PingURL & @CRLF & @CRLF
                Local $FinalResultGG = $ResultGoodIP & $ResultGoodURL
                Return $FinalResultGG
            Else
                Local $ResultBadURL = "Le serveur n'est pas joignable , code d'erreur: " & @error & @CRLF
                Local $FinalResultGB = $ResultGoodIP & $ResultBadURL
                Return $FinalResultGB
            EndIf
        Else
            Local $ResultBadIP = "La passerelle est injoignable , code d'erreur: " & @error & @CRLF & @CRLF
            Return $ResultBadIP
        EndIf
    EndFunc   ;==>fPingAll