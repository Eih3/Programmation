
#Region
#AutoIt3Wrapper_icon=K:\Documents\Images\Windows Live 9.0\Windows Live WOW Icon Pack\Programs\Windows Live Messenger.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=Le Messenger toujours a portée de main.
#AutoIt3Wrapper_Res_Language=1036
#EndRegion

#include<IE.au3>
#include<_winanimate.au3>




$PIC1 = ("close.gif")
$PIC2 = ("windows_live_10x10.gif")
Opt("TrayMenuMode", 1)

If FileExists("ini.ini") Then
$inireadlogin= IniRead("ini.ini","identifiants","login","")
$inireadmdp= IniRead("ini.ini","identifiants","mdp","")
endif
$STARTH = GUICreate("Windows Live Messenger", 300, 400, -1, -1, -2138570752)
GUISetBkColor("0xFFFFFF", $STARTH)
$IMGGUI = GUICtrlCreatePic("main.jpg", 10, 25, 278, 230)
$LABLOGIN = GUICtrlCreateLabel("Nom d'utilisateur", 100, 265, 100, 20)
GUICtrlSetFont(-1, 8.5, 800)
$LABPASSE = GUICtrlCreateLabel("Mot de passe", 110, 315, 100, 20)
GUICtrlSetFont(-1, 8.5, 800)
$LABTITRE = GUICtrlCreateLabel("Windows Live Messenger", 25, 4, -1, 20)
$HOMEICON = GUICtrlCreatePic($PIC2, 5, 2, 16, 16)
$HOMEOK = GUICtrlCreateButton(" Connexion ", 80, 363)
$HOMENON = GUICtrlCreateButton("    Ignorer    ", 150, 363)
$HOMEEXIT = GUICtrlCreatePic($PIC1, 250, 0, 43, 17)
_WINANIMATE($STARTH, $AW_FADE_IN, 200)
$INPLOGIN = GUICtrlCreateInput($inireadlogin, 30, 280, 240, 20)
$INPMDP = GUICtrlCreateInput($inireadmdp, 30, 330, 240, 20)
TraySetIcon("ico.ico", 0)
GUISetState()
While 1
	$MSGX = GUIGetMsg()
	Select
		Case $MSGX = $HOMEEXIT
			_WINANIMATE($STARTH, $AW_FADE_OUT, 200)
			Exit
		Case $MSGX = $HOMEOK
			$LOGINMSN = GUICtrlRead($INPLOGIN)
			$MDPMSN = GUICtrlRead($INPMDP)
			$QUEST = "YES"
			ExitLoop
		Case $MSGX = $HOMENON
			$QUEST = "NO"
			ExitLoop
	EndSelect
WEnd
_WINANIMATE($STARTH, $AW_FADE_OUT, 200)
GUIDelete()
$GUI = GUICreate("Windows Live Messenger", 500, 600, -1, -1, -2138570752)
GUISetBkColor("0xFFFFFF", $GUI)
$REDUIRE = GUICtrlCreatePic("minimize.gif", 220, 0, 26, 17)
$QUITTER = GUICtrlCreatePic("close_2.gif", 246, 0, 43, 17)
_WINANIMATE($GUI, $AW_FADE_IN, 200)
GUISetState()
$TABGUI = GUICtrlCreateTab(5, 35,490, 560)
GUICtrlSetBkColor($TABGUI, "0xFFFFFF")
If $QUEST = "YES"  Then
	$TABMSN = GUICtrlCreateTabItem("Connexion en cours")
	$IEGUI = _IECREATEEMBEDDED()
	$IEOBJECT = GUICtrlCreateObj($IEGUI, 10, 60,480,525)
	_IENAVIGATE($IEGUI, "http://paris.ebuddy.com/vo6.19.11/start.jsp")
	_IELOADWAIT($IEGUI)
	$IEMAIL = _IEGETOBJBYNAME($IEGUI, "username")
	_IEFORMELEMENTSETVALUE($IEMAIL, $LOGINMSN)
	Sleep(1000)
	$IEPASS = _IEGETOBJBYNAME($IEGUI, "password")
	_IEFORMELEMENTSETVALUE($IEPASS, $MDPMSN)
	Sleep(1000)
	$IEGO = _IEGETOBJBYNAME($IEGUI, "login_submit")
	_IEACTION($IEGO, "click")
	_IELOADWAIT($IEGUI)
	GUICtrlSetData($TABMSN, "Messenger : " & $LOGINMSN)
EndIf
$TABRADIO = GUICtrlCreateTabItem(" Radio : Déconnécté ")
GUICtrlSetBkColor($TABRADIO, "0xFFFFFF")
$MENU = GUICtrlCreateListView("Type de radio|                 Station                 ", 10, 100, 375, 460, 4)
$MENUAW = GUICtrlCreateListViewItem("Infos", $MENU)
$MENUAA = GUICtrlCreateListViewItem("| RTL ", $MENU)
$MENUAB = GUICtrlCreateListViewItem("| RMC ", $MENU)
$MENUAC = GUICtrlCreateListViewItem("| France Inter ", $MENU)
$MENUAD = GUICtrlCreateListViewItem("| France Info ", $MENU)
$MENUAE = GUICtrlCreateListViewItem("| BFM ", $MENU)
$MENUAF = GUICtrlCreateListViewItem("| Europe 1 ", $MENU)
$MENUAX = GUICtrlCreateListViewItem(" ", $MENU)
$MENUAY = GUICtrlCreateListViewItem("---------------|---------------", $MENU)
$MENUAZ = GUICtrlCreateListViewItem(" ", $MENU)
$MENUBW = GUICtrlCreateListViewItem("Musicales", $MENU)
$MENUBA = GUICtrlCreateListViewItem("| Contact ", $MENU)
$MENUBB = GUICtrlCreateListViewItem("| Nostalgie ", $MENU)
$MENUBC = GUICtrlCreateListViewItem("| Fun Radio ", $MENU)
$MENUBE = GUICtrlCreateListViewItem("| Rire et chanson ", $MENU)
$MENUBF = GUICtrlCreateListViewItem("| Cherie FM ", $MENU)
$MENUBG = GUICtrlCreateListViewItem("| Skyrock ", $MENU)
$MENUBH = GUICtrlCreateListViewItem("| NRJ ", $MENU)
$MENUBI = GUICtrlCreateListViewItem("| Virgin Radio ", $MENU)
$MENUBJ = GUICtrlCreateListViewItem("| France musique ", $MENU)
$MENUBK = GUICtrlCreateListViewItem("| RFM ", $MENU)
$MENUBL = GUICtrlCreateListViewItem("| Frequence rock ", $MENU)
$MENUBX = GUICtrlCreateListViewItem(" ", $MENU)
$MENUBY = GUICtrlCreateListViewItem("---------------|---------------", $MENU)
$MENUBZ = GUICtrlCreateListViewItem(" ", $MENU)
$MEDIAERROR = ObjEvent("AutoIt.Error", "Quit")
$MEDIA = ObjCreate("WMPlayer.OCX.7")
If Not IsObj($MEDIA) Then Exit
$MEDIA.Enabled = True
$MEDIA.WindowlessVideo = True
$MEDIA.UImode = "invisible"
$MEDIACTRL = $MEDIA.Controls
$MEDIASET = $MEDIA.Settings
$MEDIACTRL.Stop
$MEDIAPLAY = GUICtrlCreateButton("Play", 10, 65, 50, 30)
$MEDIASTOP = GUICtrlCreateButton("Stop", 335, 65, 50, 30)
GUICtrlCreateTabItem("")
$TRAYMENU = TrayCreateItem("Afficher")
While 1
	$MSG = GUIGetMsg()
	$TRAY = TrayGetMsg()
	Select
		Case $MSG = $QUITTER
			_WINANIMATE($GUI, $AW_FADE_OUT, 200)
			ExitLoop
		Case $MSG = $REDUIRE
			_WINANIMATE($GUI, $AW_SLIDE_OUT_BOTTOM, 350)
			TrayTip("Information", "Windows Live Messenger a été réduit." & @CRLF & "Cliquez ici pour plus d'informations.", 10, 1)
			GUISetState(@SW_MINIMIZE)
			GUISetState(@SW_HIDE)
		Case $TRAY = $TRAYMENU
			GUISetState(@SW_SHOW)
		Case $MSG = $MEDIAPLAY
			$MEDIACTRL.Play
		Case $MSG = $MENUAA
			$MEDIA.URL = "http://streaming.radio.rtl.fr/rtl-1-44-96"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUAB
			$MEDIA.URL = "http://cache.yacast.fr/V4/rmc/rmc.m3u"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUAC
			$MEDIA.URL = "http://www.tv-radio.com/station/france_inter_mp3/france_inter_mp3-128k.m3u"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUAD
			$MEDIA.URL = "http://players.creacast.com/creacast/france_info/playlist.m3u"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUAE
			$MEDIA.URL = "http://cache.yacast.net/V4/bfm/bfm.m3u"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUAF
			$MEDIA.URL = "http://live.europe1.fr/V4/europe1/europe1.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBA
			$MEDIA.URL = "http://213.186.39.130:8000/live64.m3u"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBB
			$MEDIA.URL = "http://player.nostalgie.fr/V4/nostalgie/nostalgie.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBC
			$MEDIA.URL = "http://radio.funradio.fr/funradio.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBE
			$MEDIA.URL = "http://player.rireetchansons.fr/V4/rireetchansons/rireetchansons.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBF
			$MEDIA.URL = "http://player.cheriefm.fr/V4/cheriefm/cheriefm.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBG
			$MEDIA.URL = "http://player.skyrock.com/V4/skyrock/skyrock.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBH
			$MEDIA.URL = "http://player.nrj.fr/V4/nrj/nrj.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBI
			$MEDIA.URL = "http://viphttp.yacast.fr/V4/virgin/virgin.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBJ
			$MEDIA.URL = "http://www.tv-radio.com/station/france_musique_mp3/france_musique_mp3-128k.m3u"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBK
			$MEDIA.URL = "http://viphttp.yacast.net/V4/player_rfm/rfm.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MENUBL
			$MEDIA.URL = "http://www.frequencemetz.fr/listen/high.asx"
			GUICtrlSetData($TABRADIO, " Radio : " & StringRegExpReplace(GUICtrlRead($MSG), "[|]", ""))
		Case $MSG = $MEDIASTOP
			$MEDIACTRL.Stop
		Case Else
	EndSelect
WEnd
Exit