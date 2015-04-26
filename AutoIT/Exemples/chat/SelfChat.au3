#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	Chat décentralisé (LAN)

 Configuration:
	Pour changer les adresses IP utilisées par UDPBind et UDPOpen,
	Créez un fichier "selfchat.ini" dans le même dossier que l'exécutable
	SelfChat.exe, et mettez y les lignes suivantes:
	---
	[SelfChat_Config]
	UDPBind_IP=adresse IP
	UDBOpen_IP=adresse IP
	---

	- UDPBind_IP doit correspondre à l'adresse IP de la carte réseau
	- UDPOpen_IP doit correspondre à ... euh un exemple plutôt!
		Si votre carte réseau est configuré de cette manière:
			IP = 192.168.1.3
			Masque = 255.255.255.0
		Alors, vous devrez mettre: 192.168.1.255
		---
		Si votre carte réseau est configuré de cette manière:
			IP = 192.168.2.16
			Masque = 255.255.0.0
		Alors, vous devrez mettre: 192.168.255.255

	Les valeurs par défaut sont:
	UDPBind_IP = @IPAddress1
	UDPOpen_IP = 192.168.1.255

#ce ----------------------------------------------------------------------------

#include <Crypt.au3>
#include <Misc.au3>
#include <Array.au3>

#include "lib\AutoConfig.au3"

Global $__Name, $__Canal, $__Users[1][2] = [[0, ""]] ; name, ListView Index
Global $__Buffer, $hKey, $__UniqueID = 0
Global $__LastUserMsg, $__LastPrivateMsg, $tmp, $tmp2

#include "GUI.au3"

_AutoCfg_Init($ACFG_INI, @ScriptDir & "\selfchat.ini", "SelfChat_Config")
	_AutoCfg_AddEntry("pseudo", @UserName)
	_AutoCfg_AddEntry("canal", "")
	; ---
	_AutoCfg_AddEntry("UDPBind_ip", @IPAddress1)
	_AutoCfg_AddEntry("UDPOpen_ip", "192.168.0.255")
_AutoCfg_Update()

_Crypt_Startup()
$hKey = _Crypt_DeriveKey("5eg6é(('-(è-_è-è--èç_èç_èr5e+v52rez+f5v6+s2cv+e_çèàè_ç15.r9g6er+sfv6+ser41g", $CALG_RC4)

UDPStartup()
OnAutoItExitRegister("_onExit")
; ======================================================;\
; à modifier selon votre réseau ========================;|
Global $Sock_Recv = UDPBind(CFG("UDPbind_ip"), 32166)	;\
Global $Sock_Send = UDPOpen(CFG("UDPOpen_ip"), 32166, 1);|
; ======================================================;\

;HotKeySet("{esc}", "_Debug")
;Func _Debug()
;	_ArrayDisplay($__Users)
;EndFunc

_GUI_Main()
_GUI_Main($__GUI_Show)

_GUI_Connect($__GUI_Create, CFG("pseudo"), CFG("canal"))
_GUI_Connect($__GUI_Show)

While 1
	$MSG = GUIGetMsg(1)
	Select
		Case $MSG[1] = $GUI_Main And $GUI_Main <> 0
			Switch $MSG[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $B_Menu
					ControlClick($GUI_Main, "", $B_Menu, "right")
				Case $Menu_Identification
					_GUI_Connect($__GUI_Create, _GetName($__Name), $__Canal)
					_GUI_Connect($__GUI_Show)
				Case $Menu_Clear
					_GuiCtrlTexte_Clear($HTML)
					$__LastUserMsg = ""
				Case $Menu_Refresh
					_Send("in", $__Name)
				Case $B_Send
					$tmp = GuiCtrlRead($Input)
					If $tmp Then
						$tmp2 = _GUI_List_GetSelected()
						If $tmp2 <> $__LastPrivateMsg Then $__LastUserMsg = ""
						If $tmp2 Then
							_Send("msg", $__Name & Chr(31) & $tmp & Chr(31) & $tmp2)
							$__LastPrivateMsg = $tmp2
						Else
							_Send("msg", $__Name & Chr(31) & $tmp)
						EndIf
						GuiCtrlSetData($Input, "")
					EndIf
			EndSwitch
		; ---
		Case $MSG[1] = $GUI_Connect And $GUI_Connect <> 0
			Switch $MSG[0]
				Case $GUI_EVENT_CLOSE
					_GUI_Connect($__GUI_Delete)
				Case $B_Connect
					$tmp = GuiCtrlRead($I_Pseudo)
					If $tmp Then
						If $__Name Then _Send("out", $__Name)
						; ---
						$__Name = _MakeName($tmp)
						$__Canal = GuiCtrlRead($I_Canal)
						If $__Canal = "" Then $__Canal = "Canal Principal"
						; ---
						GuiCtrlSetData($List, "")
						$__LastUserMsg = ""
						_Send("in", $__Name)
						; ---
						GuiCtrlSetData($L_Canal, $__Canal)
						WinSetTitle($GUI_Main, "", "SelfChat - " & _GetName($__Name) & " @ " & $__Canal)
						; ---
						_AutoCfg_SetEntry("pseudo", _GetName($__Name))
						_AutoCfg_SetEntry("canal", $__Canal)
						; ---
						_GUI_Connect($__GUI_Delete)
					Else
						MsgBox(48, "SelfChat", "Il vous faut un pseudonyme")
					EndIf
			EndSwitch
	EndSelect
	; ---
	_UDP_Process()
WEnd

; ##############################################################

Func _UDP_Process()
	Local $recv = UDPRecv($Sock_Recv, 1024)
	If $recv Then
		_dbg("---> Recv: " & $recv & @CRLF)
		$__Buffer &= $recv
	EndIf
	; ---
	If Not StringRegExp($__Buffer, Chr(2) & ".*" & Chr(3)) Then Return
	_dbg("String Reg Exp OK" & @CRLF)
	; ---
	Local $cmd, $data, $tmp, $privateMsgOK = 1
	If Not _UDP_CheckBuffer($cmd, $data) Then
		$__Buffer = ""
		Return
	EndIf
	; ---
	_dbg("Recv: " & $cmd & @TAB & $data & @CRLF)
	_dbg("======================================" & @CRLF & @CRLF)
	Switch $cmd
		; ---
		; Recéption d'un message
		Case "msg"
			$data = StringSplit($data, Chr(31))
			If $data[0] = 2 Or $data[3] Then
				; Teste si c'est un message privé, et si on fait partie des utilisateurs ciblés
				If $data[0] = 3 Then
					$privateMsgOK = 0
					$tmp = StringSplit($data[3], Chr(30))
					For $i = 1 To $tmp[0]
						If $tmp[$i] = $__Name Then
							$privateMsgOK = 2
							ExitLoop
						EndIf
					Next
				EndIf
				If $privateMsgOK Then
				; ---
					If $data[1] <> $__LastUserMsg Then
						; Si ce n'est pas le même utilisateur que le dernier message reçu,
						; alors on inscrit le ligne du nom de l'utilisateur
						$__LastUserMsg = $data[1]
						; ---
						If $data[1] = $__Name Then ; Remplace mon nom par: "Moi"
							$data[1] = "Moi"
							$tmp = "myname"
						Else
							$data[1] = _GetName($data[1])
							$tmp = "username"
						EndIf
						; ---
						; Marqueur de message privé
						If $privateMsgOK = 2 Then $data[1] &= " (Privé)"
						; ---
						_GUI_Write("<span class=" & $tmp & ">" & $data[1] & "</span><br/>")
					EndIf
					; On écris le contenu du message
					_GUI_Write('<span class=msg>' & StringRegExpReplace($data[2], "<|>", "_") & '</span><br/>')
				; ---
				EndIf
			EndIf
		; ---
		; Quand un utilisateur se connecte
		Case "in"
			_Users_Add($data, 1)
			_Send("notif_in", $data)
			If $data <> $__Name Then _Send("notif_in", $__Name) ; Pour dir "je suis là!" au nouveaux venus!
		; ---
		; Quand un utilisateur se déconnecte
		Case "out"
			_Users_Del($data, 1)
			_Send("notif_out", $data)
		; ---
		; Notification de connexion
		Case "notif_in"
			_Users_Add($data)
		; ---
		; Notification de déconnexion
		Case "notif_out"
			_Users_Del($data)
	EndSwitch
EndFunc

Func _UDP_CheckBuffer(ByRef $cmd, ByRef $data)
	_dbg(">> Start:" & @CRLF)
	$__Buffer = StringRegExpReplace($__Buffer, Chr(2) & "(.+)" & Chr(3), '$1')
	$__Buffer = BinaryToString(_Crypt_DecryptData(Binary("0x" & $__Buffer), $hKey, $CALG_USERKEY), 4)
	$__Buffer = StringSplit($__Buffer, Chr(29))
	_dbg(@TAB & "Buffer3: " & $__Buffer & @CRLF)
	For $elem In $__Buffer
		_dbg(@TAB & @TAB & $elem & @CRLF)
	Next
	If $__Buffer[0] <> 3 Then Return 0
	; ---
	_dbg($__Buffer[1] & " <> " & $__Canal & @CRLF)
	If $__Buffer[1] <> $__Canal Then Return 0
	; ---
	$cmd = $__Buffer[2]
	$data = $__Buffer[3]
	$__Buffer = ""
	Return 1
EndFunc

Func _Send($sCmd, $sData)
	_dbg("Send: " & Chr(2) & $__Canal & Chr(29) & $sCmd & Chr(29) & $sData & Chr(3) & @CRLF)
	UDPSend($Sock_Send, Chr(2) & StringTrimLeft(_Crypt_EncryptData(StringToBinary($__Canal & Chr(29) & $sCmd & Chr(29) & $sData, 4), $hKey, $CALG_USERKEY), 2) & Chr(3))
EndFunc

; ##############################################################

Func _Users_Add($sName, $iNotif = 0)
	_Users_Del($sName, 0, 0) ; éviter les doubles, on update pas car ce sera fait ici (*)
	; ---
	Local $ub = $__Users[0][0]
	ReDim $__Users[$ub + 2][2]
	$__Users[$ub + 1][0] = $sName
	$__Users[$ub + 1][1] = -1
	$__Users[0][0] += 1
	; ---
	_Users_Display() ; (*)
	; ---
	If $iNotif Then
		If $sName = $__Name Then
			$sName = "<b>Vous</b> êtes"
		Else
			$sName = "<b>" & _GetName($sName) & "</b> est"
		EndIf
		_GUI_Write('<p class=sysmsg><span class=sysmsg_in>' & $sName & ' connecté au canal: <i>"' & $__Canal & '"</i></span></p>')
		$__LastUserMsg = ""
	EndIf
EndFunc

Func _Users_Del($sName, $iNotif = 0, $iUpdate = 1)
	For $i = $__Users[0][0] To 1 Step -1
		If $sName = $__Users[$i][0] Then
			If $iNotif Then
				If $sName = $__Name Then
					$sName = "<b>Vous</b> êtes"
				Else
					$sName = "<b>" & _GetName($sName) & "</b> est"
				EndIf
				_GUI_Write('<p class=sysmsg><span class=sysmsg_out>' & $sName & ' déconnecté du canal: <i>"' & $__Canal & '"</i></span></p>')
				$__LastUserMsg = ""
			EndIf
			; ---
			_ArrayDelete($__Users, $i)
			$__Users[0][0] -= 1
			; ---
			If $iUpdate Then _Users_Display()
			Return
		EndIf
	Next
EndFunc

Func _Users_Display()
	_GuiCtrlListView_BeginUpdate($hList)
	_GuiCtrlListView_DeleteAllItems($hList)
	; ---
	For $i = 1 To $__Users[0][0]
		$__Users[$i][1] = _GuiCtrlListView_AddItem($hList, _GetName($__Users[$i][0]))
	Next
	; ---
	_GuiCtrlListView_SetColumnWidth($hList, 0, $LVSCW_AUTOSIZE)
	If _GuiCtrlListView_GetColumnWidth($hList, 0) < 115 Then _GuiCtrlListView_SetColumnWidth($hList, 0, 115)
	_GuiCtrlListView_EndUpdate($hList)
EndFunc

Func _Users_Exists($sName)
	For $i = 1 To $__Users[0]
		If $sName = $__Users[$i] Then Return 1
	Next
	Return 0
EndFunc

; ##############################################################

Func _GetName($sName = Default)
	If $sName = Default Then Return _GetName($__Name)
	Return StringLeft($sName, StringInStr($sName, Chr(28)) - 1)
EndFunc

Func _MakeName($sName)
	If $__UniqueID = 0 Then $__UniqueID = Random(100000, 999999, 1) & @HOUR & @MIN & @SEC
	Return StringRegExpReplace($sName & Chr(28) & $__UniqueID, "<|>", "_")
EndFunc

Func _dbg($text)
	If Not @Compiled Then ConsoleWrite($text)
EndFunc

Func _onExit()
	_Send("out", $__Name)
	_Crypt_DestroyKey($hKey)
	_Crypt_Shutdown()
	UDPShutdown()
EndFunc
