#include "Wifi33b.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#Include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#Include <String.au3>

Global $pass

If Not FileExists("Config_Wifi.ini") Then
	 $pass = InputBox("Encryption","Quel Mot de passe voulez-vous pour votre fichier .ini?","","*",200,150)
	_ini()
Else

$Form1 = GUICreate("", 203, 73, 192, 124)
$Button1 = GUICtrlCreateButton("Modifier le .ini", 8, 8, 187, 25)
$Button2 = GUICtrlCreateButton("Configurer les connections", 8, 40, 187, 25)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Button1, $Button2

			$pass = InputBox("Encryption","Quel est le mot de passe du fichier .ini?","","*",200,150)
			$var = IniReadSectionNames("Config_Wifi.ini")
			$split = StringSplit($var[1],"{}")
			If _StringEncrypt(0, $split[$split[0]-1], $pass) = "Mot_de_passe" And $nMsg = $Button1 And $pass <> "" Then
				GUIDelete($Form1)
			    _ini()
		    ElseIf _StringEncrypt(0, $split[$split[0]-1], $pass) = "Mot_de_passe" And $nMsg = $Button2 And $pass <> "" Then
				GUIDelete($Form1)
				_configuration()
			Else
			    MsgBox(16,"Erreur","Mauvais mot de passe!")
			EndIf

		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
EndIf





Func _ini()
Dim $Profile[11]

Global $Form1 = GUICreate("Création et modification du fichier .ini", 516, 173, 216, 149, -1, BitOR($WS_EX_LEFTSCROLLBAR,$WS_EX_WINDOWEDGE))
GUIStartGroup()
Global $Combo1 = GUICtrlCreateCombo("", 8, 32, 201, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
Global $Radio1 = GUICtrlCreateRadio("Utiliser les données de cette connection", 216, 112, 217, 17)
Global $Radio2 = GUICtrlCreateRadio("Utiliser des données personnalisées", 216, 136, 193, 17)
Global $Button1 = GUICtrlCreateButton("Suivant", 432, 120, 75, 25, $BS_MULTILINE)
GUIStartGroup()
Global $Combo2 = GUICtrlCreateCombo("", 8, 120, 201, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
Global $Radio3 = GUICtrlCreateRadio("Modifier cette connection", 216, 24, 153, 17)
Global $Radio4 = GUICtrlCreateRadio("Supprimer cette connection", 216, 48, 153, 17)
Global $Button2 = GUICtrlCreateButton("Confirmer", 432, 32, 75, 25)
Global $Label1 = GUICtrlCreateLabel("___________________________________________________________________________", 30, 66, 454, 17, $SS_CENTER)
Global $Label2 = GUICtrlCreateLabel("Ajouter une connection", 162, 80, 190, 24)
GUICtrlSetFont(-1, 12, 800, 4, "MS Sans Serif")
Global $Label3 = GUICtrlCreateLabel("Modifier ou supprimer une connection", 105, 0, 305, 24)
GUICtrlSetFont(-1, 12, 800, 4, "MS Sans Serif")
GUISetState(@SW_SHOW)


Global $Form2 = GUICreate("Information de connection", 304, 253, 192, 124)
Global $Label10 = GUICtrlCreateLabel("SSID:", 0, 8, 150, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label11 = GUICtrlCreateLabel("Type de connection :", 0, 32, 153, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label12 = GUICtrlCreateLabel("Mode de connection :", 0, 56, 156, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label4 = GUICtrlCreateLabel("Autentification :", 0, 80, 156, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label5 = GUICtrlCreateLabel("Encryption :", 0, 104, 153, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label6 = GUICtrlCreateLabel("UseOneX :", 0, 128, 156, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label7 = GUICtrlCreateLabel("Type de clé :", 0, 152, 154, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label8 = GUICtrlCreateLabel("Clé :", 0, 176, 150, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Label9 = GUICtrlCreateLabel("Numero de clé :", 0, 200, 154, 20, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $Input1 = GUICtrlCreateInput("", 152, 8, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input2 = GUICtrlCreateInput("", 152, 32, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input3 = GUICtrlCreateInput("", 152, 56, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input4 = GUICtrlCreateInput("", 152, 80, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input5 = GUICtrlCreateInput("", 152, 104, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input6 = GUICtrlCreateInput("", 152, 128, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input7 = GUICtrlCreateInput("", 152, 152, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
Global $Input8 = GUICtrlCreateInput("", 152, 176, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_PASSWORD))
Global $Input9 = GUICtrlCreateInput("", 152, 200, 145, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
Global $Button3 = GUICtrlCreateButton("Confirmer", 176, 224, 75, 25)
Global $Button4 = GUICtrlCreateButton("Annuler", 48, 224, 75, 25)
Dim $Form1_AccelTable[1][2] = [["{enter}", $Button4]]
GUISetAccelerators($Form1_AccelTable)


GUICtrlSetState($Radio1,$GUI_CHECKED)
GUICtrlSetState($Radio3,$GUI_CHECKED)

$Handle = _Wlan_OpenHandle()
If @error Then MsgBoxer(@error, $Handle)
$Enum = _Wlan_EnumInterfaces($Handle)
_Wlan_SetGlobalConstants($Handle, $Enum[0][0])
_Wlan_Scan(-1, -1)

$Network = _Wlan_GetAvailableNetworkList(-1,-1,-1)
If @error Then
	    GUICtrlSetState($Radio1,$GUI_DISABLE)
	    GUICtrlSetState($Combo2,$GUI_DISABLE)
Else

    $conn = -1

    For $i=0 To UBound($Network)-1
	    If $Network[$i][6] = "(Connecté)" Then
	    $combo_network = $Network[$i][0] & $Network[$i][6] & "|"
	    $conn = $i
	    EndIf
    Next


    If $conn <> -1 Then
        For $i=0 To UBound($Network)-1
	        If $Network[$i][0] <> $Network[$conn][0] And $Network[$i][6] = "" Then
	            $combo_network = $combo_network & $Network[$i][0] & $Network[$i][6] & "|"
	        EndIf
        Next
    Else
	    For $i=0 To UBound($Network)-1
	        If $Network[$i][6] = "" Then
	            $combo_network = $combo_network & $Network[$i][0] & $Network[$i][6] & "|"
	        EndIf
        Next
    EndIf
    $split = StringSplit($combo_network,"|",2)
    GUICtrlSetData($Combo2,$combo_network,$split[0] )
EndIf

_combo1()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Button1
                GUISetState(@SW_HIDE)
				GUISwitch($Form2)
				GUISetState(@SW_SHOW)
				If GUICtrlRead($Radio1) = $GUI_CHECKED Then
					$ssid = GUICtrlRead($Combo2)
                    If StringInStr($ssid,"(Connecté)") Then _
					$ssid=StringTrimRight($ssid,10)
					$Profile = _Wlan_GetProfile(-1,-1,$ssid)
					For $i=1 To 7
						GUICtrlSetData(Eval("input" & $i),$Profile[$i-1])
					Next
					GUICtrlSetState($Input8,$GUI_FOCUS)
				Else
					For $i=1 To 9
						GUICtrlSetData(Eval("input" & $i),"")
					Next
				EndIf
                _form2_boucle()
				_combo1()

        Case $Button2
			$a=0
			Do
				$a=$a+1
			Until _StringEncrypt(0,IniRead("Config_Wifi.ini",$connection[$a],0,""), $pass) = GUICtrlRead($Combo1)
			If GUICtrlRead($Radio3) = $GUI_CHECKED Then
                GUISetState(@SW_HIDE)
				GUISwitch($Form2)
				GUISetState(@SW_SHOW)
				For $i=0 to 8
					If IniRead("Config_Wifi.ini",$connection[$a],$i,"") = "" Then
						$Profile[$i] = ""
					Else
						$Profile[$i]=_StringEncrypt(0,IniRead("Config_Wifi.ini",$connection[$a],$i,""),$pass)
					EndIf
				Next
				For $i=1 To 9
					GUICtrlSetData(Eval("input" & $i),$Profile[$i-1])
				Next
                _form2_boucle()
				IniDelete("Config_Wifi.ini",$connection[$a])
				_combo1()
			ElseIf 	GUICtrlRead($Radio4) = $GUI_CHECKED	Then
				IniDelete("Config_Wifi.ini",$connection[$a])
				_combo1()
			EndIf
		Case $GUI_EVENT_CLOSE
			Exit

    EndSwitch
    Sleep(10)
    If _GUICtrlComboBox_GetDroppedState($combo2) Then
		$tooltip = ""
		Do
	    $ssid = GUICtrlRead($Combo2)
	    If StringInStr($ssid,"(Connecté)") Then _
	    $ssid=StringTrimRight($ssid,10)
	    For $i=0 to UBound($Network)-1
		    If $Network[$i][0] = $ssid And $tooltip <> $Network[$i][0] Then
		    	ToolTip("SSID : " & $Network[$i][0] & @CRLF & _
				"Encryption : " & $Network[$i][5] & @CRLF & _
				"Signal : " & $Network[$i][3] & "%")
				$tooltip = $Network[$i][0]
		    EndIf
	    Next
		Until _GUICtrlComboBox_GetDroppedState($combo2)=False
        ToolTip("")
    EndIf
WEnd

EndFunc ;ini

Func _form2_boucle()
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button3
				$titre=TimerInit() & "{" & _StringEncrypt(1,"Mot_de_passe", $pass) & "}"
				For $i=1 to 9
					if GUICtrlRead(Eval("input" & $i)) <> "" Then _
					IniWrite("Config_Wifi.ini", $titre,$i-1, _StringEncrypt(1,GUICtrlRead(Eval("input" & $i)), $pass))
				Next
				ExitLoop
			Case $Button4
				ExitLoop
			case $GUI_EVENT_CLOSE
				Exit

		EndSwitch
	WEnd
	GUISetState(@SW_HIDE)
	GUISwitch($Form1)
	GUISetState(@SW_SHOW)
EndFunc;Form2 boucle

Func _combo1()

	If FileExists("Config_Wifi.ini") Then
	$combo_conn="|"
	Global $connection = IniReadSectionNames("Config_Wifi.ini")
	If Not @error Then
	    GUICtrlSetState($Radio4,$GUI_ENABLE)
	    GUICtrlSetState($Combo1,$GUI_ENABLE)
	    GUICtrlSetState($Radio3,$GUI_ENABLE)
	    GUICtrlSetState($Button2,$GUI_ENABLE)
	    For $i=1 to $connection[0]
			$ssid=_StringEncrypt(0,IniRead("Config_Wifi.ini",$connection[$i],0,""),$pass)
		    $combo_conn = $combo_conn & $ssid & "|"
	    Next
	    GUICtrlSetData($Combo1,$combo_conn,$ssid)
    Else
	    GUICtrlSetState($Radio4,$GUI_DISABLE)
	    GUICtrlSetState($Combo1,$GUI_DISABLE)
	    GUICtrlSetState($Radio3,$GUI_DISABLE)
	    GUICtrlSetState($Button2,$GUI_DISABLE)
    EndIf
Else
	GUICtrlSetState($Radio4,$GUI_DISABLE)
	GUICtrlSetState($Combo1,$GUI_DISABLE)
	GUICtrlSetState($Radio3,$GUI_DISABLE)
	GUICtrlSetState($Button2,$GUI_DISABLE)
EndIf

EndFunc;combo1

Func MsgBoxer($Er, $Stat)
    MsgBox(262208,"Error #" & $Er,"Fatal Error..." & @CRLF & @CRLF & $Stat & "   ", 5)
    Exit
EndFunc ;MsgBoxer

Func _configuration()

$Handle = _Wlan_OpenHandle()
$Enum = _Wlan_EnumInterfaces($Handle)
_Wlan_SetGlobalConstants($Handle, $Enum[0][0])
_Wlan_Scan(-1, -1)
Dim $profile[9]
$connection=IniReadSectionNames("Config_Wifi.ini")
For $i=1 to $connection[0]
	For $a=0 To 8
	    $profile[$a] = _StringEncrypt(0,IniRead("Config_Wifi.ini",$connection[$i],$a,""), $pass)
    Next
	_Wlan_SetProfile($Handle,-1,$profile)
Next
_Wlan_Connect(-1,-1,$profile[0])
$ProfileList = _Wlan_GetProfileList(-1, -1)
$liste=""
For $i=0 to UBound($ProfileList)-1
	$liste = $liste & $i+1 & " : " & $ProfileList[$i] & @CRLF
Next
MsgBox(0,"Connection Wifi",$liste)

EndFunc ;Configuration