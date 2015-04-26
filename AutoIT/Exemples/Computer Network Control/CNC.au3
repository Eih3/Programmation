; ligne 147 - Remplacer xxx par le domaine de préférence au démarrage
; ligne 155 - activer si Remplacer xxx par le domaine de préférence au démarrage











#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=black-gear.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Computer Network Control - 1.0.0 - http://autoit.koumla.com
#AutoIt3Wrapper_Res_Description=Computer Network Control - 1.0.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Made by Koumla - http://autoit.koumla.com
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#NoTrayIcon
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <GUIComboBox.au3>
#include <StaticConstants.au3>
#include <Array.au3>
#include <GuiAVI.au3>
#include <file.au3>
#include <list_comp.au3>
#include <Misc.au3>
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if _Singleton("CNC_1",1) = 0 Then
	Msgbox(0,"Attention","Attendre quelque seconde pour relancer l'application")
	Exit
EndIf
if _Singleton("CNC_2",1) = 0 Then
	Msgbox(0,"Attention","Attendre quelque seconde pour relancer l'application")
	Exit
EndIf
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FileInstall("N:\Computer Network Control\loading.avi", @TempDir & "\loading.avi", 1)
FileInstall("N:\Computer Network Control\sav_data.exe", @TempDir & "\sav_data.exe", 1)
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Opt("GUIDataSeparatorChar", "|")
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode",1)
HotKeySet("{ESC}", "Terminate")
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Global $poste
Global $hWnd
Global $domaine

Global Const $SV_TYPE_WORKSTATION = 0x1
Global Const $SV_TYPE_SERVER = 0x2
Global Const $SV_TYPE_SQLSERVER = 0x4
Global Const $SV_TYPE_DOMAIN_CTRL = 0x8
Global Const $SV_TYPE_DOMAIN_BAKCTRL = 0x10
Global Const $SV_TYPE_TIME_SOURCE = 0x20
Global Const $SV_TYPE_AFP = 0x40
Global Const $SV_TYPE_NOVELL = 0x80
Global Const $SV_TYPE_DOMAIN_MEMBER = 0x100
Global Const $SV_TYPE_PRINTQ_SERVER = 0x200
Global Const $SV_TYPE_DIALIN_SERVER = 0x400
Global Const $SV_TYPE_XENIX_SERVER = 0x800
Global Const $SV_TYPE_NT = 0x1000
Global Const $SV_TYPE_WFW = 0x2000
Global Const $SV_TYPE_SERVER_MFPN = 0x4000
Global Const $SV_TYPE_SERVER_NT = 0x8000
Global Const $SV_TYPE_POTENTIAL_BROWSER = 0x10000
Global Const $SV_TYPE_BACKUP_BROWSER = 0x20000
Global Const $SV_TYPE_MASTER_BROWSER = 0x40000
Global Const $SV_TYPE_DOMAIN_MASTER = 0x80000
Global Const $SV_TYPE_WINDOWS = 0x400000
Global Const $SV_TYPE_CLUSTER_NT = 0x1000000
Global Const $SV_TYPE_TERMINALSERVER = 0x2000000
Global Const $SV_TYPE_CLUSTER_VS_NT  = 0x4000000
Global Const $SV_TYPE_LOCAL_LIST_ONLY = 0x40000000
Global Const $SV_TYPE_DOMAIN_ENUM = 0x80000000
Global Const $SV_TYPE_ALL = 0xFFFFFFFF

dim $Label[100]

Global $TempsAttente_Secondes, $TempsAttente_Minutes, $TempsAttente_Heures
Global $TempsAttente_Total, $TempsPasse, $TempsRestant
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Local $DomainList = _NetServerEnum($SV_TYPE_DOMAIN_ENUM)
$DomainList = _ArrayToString($DomainList, '|', 1)
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Region ### START Koda GUI section ###
Global $Form1 = GUICreate("C.N.C - 1.0.0", 453, 502, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
Global $Label9 = GUICtrlCreateLabel("Computer Network Control - 1.0.0", 5, 480, 158, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Label9Click")
Global $Label10 = GUICtrlCreateLabel("Made by Koumla", 310, 480, 142, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Label10Click")
Global $Group0 = GUICtrlCreateGroup("Domaine :  ", 5, 5, 300, 290)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
Global $Combo1 = GUICtrlCreateCombo("", 90, 25, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Combo1Change")
Global $Group1 = GUICtrlCreateGroup("Postes : 0 ", 10, 55, 140, 230)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
Global $List1 = GUICtrlCreateList("", 15, 75, 130, 201)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "List1Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Group2 = GUICtrlCreateGroup("Postes : 0 ", 157, 55, 140, 230)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
Global $List2 = GUICtrlCreateList("", 162, 75, 130, 201)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "List2Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Group3 = GUICtrlCreateGroup("Postes en surveillance : 0 ", 310, 5, 140, 20)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Group5 = GUICtrlCreateGroup("Options", 5, 300, 300, 175)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
Global $Button1 = GUICtrlCreateButton("Démarrer", 10, 445, 290, 25)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Button1Click")
Global $Group6 = GUICtrlCreateGroup("Durée pause", 10, 320, 85, 120)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
Global $Radio1 = GUICtrlCreateRadio("5 Minutes", 15, 340, 68, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Radio1Click")
Global $Radio2 = GUICtrlCreateRadio("10 Minutes", 15, 360, 73, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Radio2Click")
Global $Radio3 = GUICtrlCreateRadio("15 Minutes", 15, 380, 73, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Radio3Click")
Global $Radio4 = GUICtrlCreateRadio("20 Minutes", 15, 400, 73, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Radio4Click")
Global $Radio5 = GUICtrlCreateRadio("30 Minutes", 15, 420, 73, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
GUICtrlSetOnEvent(-1, "Radio5Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$AVI = GUICtrlCreateAvi (@TempDir & "\loading.avi",0, 180,360)

_GUICtrlAVI_Play($AVI)
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GUISetState()
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

;ConsoleWrite ("liste des domaines : " & $DomainList & @CRLF)
GUICtrlSetData($Combo1, $DomainList,"xxx") ; Remplacer xxx par le domaine de préférence au démarrage

$avant = _GUICtrlListBox_GetCount($list2)

$size = WinGetPos("[active]")
$avant_x = $size[2]
$avant_y = $size[3]

;Combo1Change() ; activer si Remplacer xxx par le domaine de préférence au démarrage

	for $x = 1 to IniRead(@scriptdir & "\" & @ScriptName, "poste", "nombre", "")

		IniRead(@scriptdir & "\" & @ScriptName, "poste",$x, "")

		_GUICtrlListBox_AddString($list2, IniRead(@scriptdir & "\" & @ScriptName, "poste",$x, ""))

		GUICtrlSetData($Group2, "Postes : " & _GUICtrlListBox_GetCount($list2))

	next

label_affichage()

_GUICtrlAVI_Stop($AVI)
_GUICtrlAVI_Show($AVI, false)
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
While 1

	Sleep(1000)

WEnd
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func duree_pause()

	Select

		Case GUICtrlRead($Radio1) = 1

			$TempsAttente_Heures = 0
			$TempsAttente_Minutes = 5
			$TempsAttente_Secondes = 0

		Case GUICtrlRead($Radio2) = 1

			$TempsAttente_Heures = 0
			$TempsAttente_Minutes = 10
			$TempsAttente_Secondes = 0

		Case GUICtrlRead($Radio3) = 1

			$TempsAttente_Heures = 0
			$TempsAttente_Minutes = 15
			$TempsAttente_Secondes = 0

		Case GUICtrlRead($Radio4) = 1

			$TempsAttente_Heures = 0
			$TempsAttente_Minutes = 20
			$TempsAttente_Secondes = 0

		Case GUICtrlRead($Radio5) = 1

			$TempsAttente_Heures = 0
			$TempsAttente_Minutes = 30
			$TempsAttente_Secondes = 0

	EndSelect

$TempsAttente_Total=($TempsAttente_Secondes+($TempsAttente_Minutes*60)+($TempsAttente_Heures*3600))*1000
$TempsPasse=0
$TempsRestant=0

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func affiche_duree()

	if $TempsPasse<>$TempsAttente_Total then

		$TempsPasse=$TempsPasse+1000
		$TempsRestant=$TempsAttente_Total-$TempsPasse

		$TrayHeures_nonint=($TempsRestant/3600)/1000
		$TrayHeures=Int($TrayHeures_nonint)

		$TrayMinutes_nonint=(($TempsRestant/60)-(60*$TrayHeures*1000))/1000
		$TrayMinutes=Int($TrayMinutes_nonint)

		$TraySecondes=(($TempsRestant-($TrayHeures*3600*1000)-($TrayMinutes*60*1000))/1000)

		;ConsoleWrite("Il reste : " & $TrayHeures & "h" & $TrayMinutes & "m" & $TraySecondes & "s" & @crlf)

		GUICtrlSetData($Button1, "Arrêter / Ping : " & $TrayMinutes & "m" & $TraySecondes & "s")

	Else

		label_affichage()

		duree_pause()

		_GUICtrlAVI_Stop($AVI)

		_GUICtrlAVI_Show($AVI, false)

		ping_()

	EndIf

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Button1Click()

label_affichage()

ping_()

_GUICtrlAVI_Show($AVI, true)
_GUICtrlAVI_Play($AVI)

duree_pause()

AdlibRegister("affiche_duree", 1000)

GUICtrlSetOnEvent($Button1, "Button1_1Click")

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Button1_1Click()

AdlibUnRegister("affiche_duree")

GUICtrlSetData($Button1, "Démarrer")

GUICtrlSetOnEvent($Button1, "Button1Click")

_GUICtrlAVI_Stop($AVI)

_GUICtrlAVI_Show($AVI, false)

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func ping_()

_GUICtrlAVI_Show($AVI, true)
_GUICtrlAVI_Play($AVI)

$dialogue = ""

	for $x = 0 to _GUICtrlListBox_GetCount($list2) -1

		;ConsoleWrite ($x & " " & _GUICtrlListBox_GetCount($list2) & " " & _GUICtrlListBox_GetText($List2, $x) & @CRLF)

		GUICtrlSetBkColor($Label[$x + 1],0xFFFF00) ; jaune

		TrayTip("Ping en cours", $x + 1 & " / " & _GUICtrlListBox_GetCount($list2), 1, 1)

		Ping(_GUICtrlListBox_GetText($List2, $x))

			If @error = 0 Then

				GUICtrlSetBkColor($Label[$x + 1],0x008000)

			Else

				GUICtrlSetBkColor($Label[$x + 1],0xFF0000) ; rouge

			EndIf

	next

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
func label_affichage()

; noir 0x000000
; rouge 0xFF0000
; vert 0x008000
; bleu 0x0000FF
; jaune 0xFFFF00
; blanc 0xFFFFFF

	if _GUICtrlListBox_GetCount($list2) = 0 Then

		GUICtrlSetPos($Group3, 310, 5, 140, 20)

	EndIf

; efface les labels
;ConsoleWrite ("-------------------------------------------------------------------------------------" & @CRLF)
;ConsoleWrite ("on efface les labels"  & @CRLF)

GUICtrlSetData($Group3, "Postes en surveillance : " & _GUICtrlListBox_GetCount($list2))

	for $x = 0 to $avant

		GUICtrlSetPos($Label[$x], -200, -200)

	next

$top = 0 ; met le top a zero pour la position

;ConsoleWrite ("nombre de poste dans la liste : "  &  _GUICtrlListBox_GetCount($list2) & @CRLF)

	if _GUICtrlListBox_GetCount($list2) <= 18 Then

		;ConsoleWrite("si inferieur a 18" & @CRLF)

		WinMove("[active]", "", $size[0] , $size[1], $avant_x, $avant_y)

		;ConsoleWrite ("il y a moins de 18 postes dans la liste"  & @CRLF)

			for $x = 0 to _GUICtrlListBox_GetCount($list2) -1

				;ConsoleWrite ("traitement de la liste : " & " X= " & $x & " nombre de poste dans la liste : " & _GUICtrlListBox_GetCount($list2) & " nom du poste : " & _GUICtrlListBox_GetText($List2, $x) & @CRLF)

				$top = $top + 25

				GUICtrlSetPos($Group3, 310, 5, 140, 20 + $top)

				$Label[$x + 1] = GUICtrlCreateLabel(_GUICtrlListBox_GetText($List2, $x), 315, $top, 130, 15, BitOR($SS_CENTER,$WS_BORDER))
				GUICtrlSetColor(-1, 0xFFFFFF)   ; Red
				GUICtrlSetBkColor(-1,0x000000)

			next

		GUICtrlSetPos($avi, 180, 360, 50, 50)

	Else

		;ConsoleWrite ("il y a plus de 18 postes dans la liste"  & @CRLF)

		;ConsoleWrite ("on efface les labels"  & @CRLF)

			for $x = 0 to $avant

				GUICtrlSetPos($Label[$x], -200, -200)

			next

		$top = 0 ; met le top a zero pour la position

		;ConsoleWrite ("nombre de poste dans la liste : "  &  _GUICtrlListBox_GetCount($list2) & @CRLF)

			for $x = 0 to 17

				;ConsoleWrite ("traitement de la liste : " & " X= " & $x & " nombre de poste dans la liste : " & _GUICtrlListBox_GetCount($list2) & " nom du poste : " & _GUICtrlListBox_GetText($List2, $x) & @CRLF)

				$top = $top + 25

				GUICtrlSetPos($Group3, 310, 5, 140, 20 + $top)

				GUICtrlSetPos($avi, 180, 360, 50, 50)
				;ConsoleWrite("inferieur a 18 - il y en a plus au total" & @CRLF)

				$Label[$x + 1] = GUICtrlCreateLabel(_GUICtrlListBox_GetText($List2, $x), 315, $top, 130, 15, BitOR($SS_CENTER,$WS_BORDER))
				GUICtrlSetResizing($Label[$x + 1], $GUI_DOCKLEFT+$GUI_DOCKWIDTH)
				GUICtrlSetColor(-1, 0xFFFFFF)   ; Red
				GUICtrlSetBkColor(-1,0x000000)

			next

		;ConsoleWrite ("agrandissement de la form" & @CRLF)
		$size = WinGetPos("[active]")
		;MsgBox(0, "Active window stats (x,y,width,height):", $size[0] & " " & $size[1] & " " & $size[2] & " " & $size[3])
		WinMove("[active]", "", $size[0] , $size[1], 605, $size[3])

		;ConsoleWrite ("agrandissement du group" & @CRLF)
		GUICtrlSetPos($Group3, 310, 5, 280, 20 + $top)

		GUICtrlSetPos($avi, 179, 360, 50, 50)

		;ConsoleWrite("superieur a 18 - il y en a plus au total" & @CRLF)

		$top = 0

			for $x = 18 to _GUICtrlListBox_GetCount($list2) -1 ; _GUICtrlListBox_GetCount($list2) -1

				;ConsoleWrite ("traitement de la liste : " & " X= " & $x & " nombre de poste dans la liste : " & _GUICtrlListBox_GetCount($list2) & " nom du poste : " & _GUICtrlListBox_GetText($List2, $x) & @CRLF)

				$top = $top + 25

				$Label[$x + 1] = GUICtrlCreateLabel(_GUICtrlListBox_GetText($List2, $x), 455, $top, 130, 15, BitOR($SS_CENTER,$WS_BORDER))
				GUICtrlSetColor(-1, 0xFFFFFF)   ; Red
				GUICtrlSetBkColor(-1,0x000000)

			next

	EndIf

$avant = _GUICtrlListBox_GetCount($list2)

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Combo1Change()

_GUICtrlAVI_Show($AVI, true)
_GUICtrlAVI_Play($AVI)

_GUICtrlListBox_ResetContent($list1)

$domaine = GUICtrlRead($Combo1)

GUICtrlSetData($Group0, "Domaine : " & $Domaine)

$nombre_poste = 0

GUICtrlSetData($Group1, "Postes : " & $nombre_poste)

creation_list_comp()

$file = FileOpen(@TempDir & "\list_comp.txt", 0)

	If $file = -1 Then

		MsgBox(0, "Error", "Erreur a l'ouverture du fichier de donnée.")

		Exit

	EndIf

	While 1

		$line = FileReadLine($file)

			If @error = -1 Then ExitLoop

		_GUICtrlListBox_AddString($list1, $line) ; ajoute les postes dans la listbox

		$nombre_poste = $nombre_poste +1

		GUICtrlSetData($Group1, "Postes : " & $nombre_poste)

	Wend

FileClose($file)

FileDelete(@TempDir & "\list_comp.vbs")
FileDelete(@TempDir & "\list_comp.txt")

_GUICtrlAVI_Stop($AVI)
_GUICtrlAVI_Show($AVI, false)

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)

Local $hWndFrom, $iCode, $hWndListBox

	If Not IsHWnd($list1) Then

		$hWndListBox = GUICtrlGetHandle($List1)

		$hWndFrom = $ilParam

		$iCode = BitShift($iwParam, 16)

			Switch $hWndFrom

				Case $List1, $hWndListBox

					Switch $iCode

							Case $LBN_DBLCLK

								if _GUICtrlListBox_GetCount($list2) <= 35 then

									$poste = _GUICtrlListBox_GetText($list1, _GUICtrlListBox_GetCurSel($list1))

									;ConsoleWrite ("selection dans la list 1 du poste : " & $poste & @CRLF)

									;_GUICtrlListBox_DeleteString($list1, _GUICtrlListBox_GetCurSel($list1)) ; supprime de la listbox1 la machine qui a ete ajouter dans la listbox2

									_GUICtrlListBox_AddString($list2, $poste) ; ajoute les postes dans la listbox 2

									GUICtrlSetData($Group2, "Postes : " & _GUICtrlListBox_GetCount($list2))

									label_affichage()

								Else

								EndIf

					EndSwitch

			EndSwitch

	endif

	If Not IsHWnd($list2) Then

		$hWndListBox = GUICtrlGetHandle($List2)

		$hWndFrom = $ilParam

		$iCode = BitShift($iwParam, 16)

			Switch $hWndFrom

				Case $List2, $hWndListBox

					Switch $iCode

						Case $LBN_DBLCLK

							$poste = _GUICtrlListBox_GetText($list2,  _GUICtrlListBox_GetCurSel($list2))

							;ConsoleWrite ("selection dans la liste 2 du poste : " & $poste & @CRLF)

							_GUICtrlListBox_DeleteString($list2, _GUICtrlListBox_GetCurSel($list2)) ; supprime de la listbox 2 la machine qui a ete ajouter dans la listbox2

							;_GUICtrlListBox_AddString($list2, $poste) ; ajoute les postes dans la listbox 2

							GUICtrlSetData($Group2, "Postes : " &  _GUICtrlListBox_GetCount($list2))

							label_affichage()

					EndSwitch

			EndSwitch

	endif

Return $GUI_RUNDEFMSG

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func _NetServerEnum ($iSrvType = -1, $sDomain = '')
    Local $uBufPtr = DllStructCreate("ptr;int;int"), $res[1]=[0], $i
    Local $uRecord = DllStructCreate("dword;ptr"), $iRecLen = DllStructGetSize($uRecord)
    Local $uString = DllStructCreate("char[16]")
    Local $uDomain = DllStructCreate("byte[32]"), $pDomain = 0
    If Not ($sDomain='' Or $sDomain='*') Then
        DllStructSetData($uDomain, 1, StringToBinary($sDomain,2))
        $pDomain = DllStructGetPtr($uDomain)
    EndIf
    Local $ret = DllCall ("netapi32.dll", "int", "NetServerEnum", _
        "ptr", 0, "int", 100, _
        "ptr", DllStructGetPtr($uBufPtr,1), "int", -1, _
        "ptr", DllStructGetPtr($uBufPtr,2), _
        "ptr", DllStructGetPtr($uBufPtr,3), _
        "int", $iSrvType, "ptr", $pDomain, "int", 0 )
    If $ret[0] Then Return SetError(1, $ret[0], '')
    Local $res[DllStructGetData($uBufPtr,3)+1]=[DllStructGetData($uBufPtr,3)]
    For $i=1 To DllStructGetData($uBufPtr,3)
        Local $uRecord = DllStructCreate("dword;ptr", DllStructGetData($uBufPtr,1)+($i-1)*$iRecLen)
        Local $sNBName = DllStructCreate("byte[32]", DllStructGetData($uRecord,2))
        DllStructSetData($uString,1,BinaryToString(DllStructGetData($sNBName,1),2))
        $res[$i] = DllStructGetData($uString,1)
    Next
    $ret = DllCall ("netapi32.dll", "int", "NetApiBufferFree", "ptr", DllStructGetData($uBufPtr,1))
    Return $res
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Terminate()

_GUICtrlAVI_Close($AVI)

FileDelete(@TempDir & "\list_comp.vbs")
FileDelete(@TempDir & "\list_comp.txt")
FileDelete(@TempDir & "\loading.avi")

IniWrite(@TempDir & "\cnc.ini", "exe", "exe", @scriptdir & "\" & @ScriptName)

IniWrite(@TempDir & "\cnc.ini", "poste", "nombre", _GUICtrlListBox_GetCount($list2))

	for $x = 0 to _GUICtrlListBox_GetCount($list2) -1

		;ConsoleWrite ("nombre de poste dans la liste : " & _GUICtrlListBox_GetCount($list2) & " nom du poste : " & _GUICtrlListBox_GetText($List2, $x) & @CRLF)

		IniWrite(@TempDir & "\cnc.ini", "poste", $x + 1,  _GUICtrlListBox_GetText($List2, $x))

	next

$cnx = @TempDir & "\sav_data.exe"

Run(@ComSpec & ' /c ' & $cnx,  "", @SW_HIDE)

Exit

EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Region ###  ###
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Func Form1Close()

Terminate()

EndFunc

Func Combo2Change()
EndFunc

Func Form1Maximize()
EndFunc

Func Form1Minimize()
EndFunc

Func Form1Restore()
EndFunc

Func Radio1Click()

duree_pause()

EndFunc

Func Radio2Click()

duree_pause()

EndFunc

Func Radio3Click()

duree_pause()

EndFunc

Func Radio4Click()

duree_pause()

EndFunc

Func Radio5Click()

duree_pause()

EndFunc

Func List1Click()
EndFunc

Func List2Click()
EndFunc

Func Label10Click()
EndFunc

Func Label9Click()
EndFunc
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
[poste]
nombre=3
1=MARYLINE-PC
2=MICHEL-XP
3=NETGEARB8B99C
