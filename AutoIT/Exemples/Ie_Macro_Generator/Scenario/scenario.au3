#Region START NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSOUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                    Directives de preprocesseur                   ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                     Mise en place des Options                    ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <IE.au3>
#include <Misc.au3>
#include <String.au3>
#include <Constants.au3>

Opt("WinTitleMatchMode", -2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
Opt("TrayIconDebug", 1)
_IELoadWaitTimeout(30000)
_IEErrorHandlerRegister("MyErrFunc")



;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                Declaration des Variables                        ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
Global $texte = '', $oIE, $t, $erreur_de_simulation = 0, $temps, $code, $erreur_sql = "", $file;necessaires
Global $temps_total = 0, $deja_connect = 0, $object, $nombre_verifs = IniRead(@ScriptDir & "\scenario.ini", "general", "nombre");necessaires
Local $i = 1
;Chargement des Variables du.ini

For $i = 1 To $nombre_verifs
	Assign("adresse" & $i, IniRead(@ScriptDir & "\" & $nom & ".ini", "verifications", $i & "_adresse", ""), 2)
Next


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSOUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;probleme du certificat
If ProcessExists("iexplore.exe") Then ProcessWaitClose("iexplore.exe", 20000)
$oIE = _IECreate("about:blanc", 0, 1, 0)
_IELoadWait($oIE)
_demarrage()
For $i = 1 To $nombre_verifs
	Call("_action" & $i)
Next
_fin()

#EndRegion START NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;

#Region ACTIONS
Func _action1()
	$t = TimerInit()
	;-----------------
	;actions
	_IENavigate($oIE, Eval('adresse1'))
	_IELoadWait($oIE)
	;-----------------
EndFunc   ;==>_action1



#EndRegion ACTIONS
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                                       Fonctions                                              ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;



Func _demarrage()

	;Ci dessous on v�rifie que Internet explorer est bien lanc�e. Ne pas toucher
	$aerror = @error
	$t = TimerInit()
	Dim $1[6]
	While $1[3] <= 3791
		Sleep(100)
		$1 = ProcessGetStats("iexplore.exe", 1)
		If TimerDiff($t) >= $TimeOut Then
			$aerror = 1
			ExitLoop
		EndIf
	WEnd

	;Si il y a presence d' erreur au lancement d'Internet explorer, alors on va ouvrir le log puis on quitte
	If ($oIE = 0) And ($aerror <> 0) Then
		$t = TimerInit()
		While ProcessExists("iexplore.exe") And TimerDiff($t) <= 15000
			ProcessClose("iexplore.exe")
		WEnd
		Exit
	EndIf
	_IEPropertySet($oIE, "theatermode", 1);On met en plein ecran
	_IEPropertySet($oIE, "toolbar", False);On vire la toolbar
	Sleep(1000)
EndFunc   ;==>_demarrage
Func _fin()
	$t = TimerInit()
	_IEQuit($oIE)
	While ProcessExists("iexplore.exe") And TimerDiff($t) <= 15000
		ProcessClose("iexplore.exe")
		Sleep(1000)
	WEnd
EndFunc   ;==>_fin
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                              NE PAS TOUCHER CI-DESSOUS                                       ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
#Region START NE PAS TOUCHER

Func MyErrFunc()
	; Important: the error object variable MUST be named $oIEErrorHandler
	$ErrorScriptline = $oIEErrorHandler.scriptline
	$ErrorNumber = $oIEErrorHandler.number
	$ErrorNumberHex = Hex($oIEErrorHandler.number, 8)
	$ErrorDescription = StringStripWS($oIEErrorHandler.description, 2)
	$ErrorWinDescription = StringStripWS($oIEErrorHandler.WinDescription, 2)
	$ErrorSource = $oIEErrorHandler.Source
	$ErrorHelpFile = $oIEErrorHandler.HelpFile
	$ErrorHelpContext = $oIEErrorHandler.HelpContext
	$ErrorLastDllError = $oIEErrorHandler.LastDllError
	$ErrorOutput = ""
	$ErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$ErrorOutput &= "----> $ErrorScriptline = " & $ErrorScriptline & @CR
	$ErrorOutput &= "----> $ErrorNumberHex = " & $ErrorNumberHex & @CR
	$ErrorOutput &= "----> $ErrorNumber = " & $ErrorNumber & @CR
	$ErrorOutput &= "----> $ErrorWinDescription = " & $ErrorWinDescription & @CR
	$ErrorOutput &= "----> $ErrorDescription = " & $ErrorDescription & @CR
	$ErrorOutput &= "----> $ErrorSource = " & $ErrorSource & @CR
	$ErrorOutput &= "----> $ErrorHelpFile = " & $ErrorHelpFile & @CR
	$ErrorOutput &= "----> $ErrorHelpContext = " & $ErrorHelpContext & @CR
	$ErrorOutput &= "----> $ErrorLastDllError = " & $ErrorLastDllError
	If $log Then
		FileWrite($file, $ErrorOutput)
		FileWrite($file, @CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & @MON & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Fin de la session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////")
		FileClose($file)
	Else
		$file = FileOpen(@ScriptDir & "\rehucit.log", 1)
		FileWrite($file, @CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & "/" & @MON & "/" & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Debut De La Session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////" & @CRLF)
		FileWrite($file, $ErrorOutput)
		FileWrite($file, @CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & @MON & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Fin de la session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////")
		FileClose($file)
	EndIf
	SetError(1)
	Return
EndFunc   ;==>MyErrFunc
Func _EmptyIECache()
	; Lecture de la cl� dans la base de registre pour la compatibilit� Vista/Seven
	$IECache = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Cache")
	If $IECache = "" Then
		SetError(1)
		Return 0
	EndIf
	; Au cas ou la cl� serait �crite avec la variable %userprofile%
	$IECache = StringReplace($IECache, "%userprofile%", @UserProfileDir)
	; Suppression du cache IE
	_FileAndDirectoryDelete($IECache)
	; Suppression du contenu du r�pertoire Content.IE5.
	Run(@ComSpec & ' /c rd /s /q "' & $IECache & '\Content.IE5"', $IECache, @SW_HIDE)
	$Size = DirGetSize($IECache & '\Content.IE5', 1)
	If $Size[2] <> 0 Then ; V�rifie que le r�pertoire est vide.
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_EmptyIECache

Func _FileAndDirectoryDelete($sDir)
	$search = FileFindFirstFile($sDir & "\*")
	If @error Then Exit
	While 1
		$Next = FileFindNextFile($search)
		If @error Then ExitLoop
		$Next = $sDir & "\" & $Next
		$att = FileGetAttrib($Next)
		If StringInStr($att, "d") Then
			FileSetAttrib($Next, "-RSH", 1)
			DirRemove($Next, 1)
		Else
			FileSetAttrib($Next, "-RSH")
			FileDelete($Next)
		EndIf
	WEnd
	FileClose($search)
EndFunc   ;==>_FileAndDirectoryDelete
Func _DateFormat($func)
	Local $split, $texte = ""

	$split = StringRegExp($func, "([0-9]{1,4})", 3)

	If IsArray($split) And @error = 0 Then $texte &= $split[2] & "-" & $split[1] & "-" & $split[0] & " " & $split[3] & ":" & $split[4] & ":" & $split[5]
	Return $texte
EndFunc   ;==>_DateFormat
Func _array($func, $t)
	$func2 = StringSplit(Eval($func), ",")
	Return $func2[$t]
EndFunc   ;==>_array
#EndRegion START NE PAS TOUCHER

#Region START NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSOUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                    Directives de preprocesseur                   ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                     Mise en place des Options                    ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <IE.au3>
#include <Misc.au3>
#include <String.au3>
#include <Constants.au3>

Opt("WinTitleMatchMode", -2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
Opt("TrayIconDebug", 1)
_IELoadWaitTimeout(30000)
_IEErrorHandlerRegister("MyErrFunc")



;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                Declaration des Variables                        ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
Global $texte = '', $oIE, $t, $erreur_de_simulation = 0, $temps, $code, $erreur_sql = "", $file;necessaires
Global $temps_total = 0, $deja_connect = 0, $object, $nombre_verifs = IniRead(@ScriptDir & "\scenario.ini", "general", "nombre");necessaires
Local $i = 1
;Chargement des Variables du.ini

For $i = 1 To $nombre_verifs
	Assign("adresse" & $i, IniRead(@ScriptDir & "\" & $nom & ".ini", "verifications", $i & "_adresse", ""), 2)
Next


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSOUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;probleme du certificat
If ProcessExists("iexplore.exe") Then ProcessWaitClose("iexplore.exe", 20000)
$oIE = _IECreate("about:blanc", 0, 1, 0)
_IELoadWait($oIE)
_demarrage()
For $i = 1 To $nombre_verifs
	Call("_action" & $i)
Next
_fin()

#EndRegion START NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;

#Region ACTIONS
Func _action1()
	$t = TimerInit()
	;-----------------
	;actions
	;-----------------
EndFunc   ;==>_action1



#EndRegion ACTIONS
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                                       Fonctions                                              ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;



Func _demarrage()

	;Ci dessous on v�rifie que Internet explorer est bien lanc�e. Ne pas toucher
	$aerror = @error
	$t = TimerInit()
	Dim $1[6]
	While $1[3] <= 3791
		Sleep(100)
		$1 = ProcessGetStats("iexplore.exe", 1)
		If TimerDiff($t) >= $TimeOut Then
			$aerror = 1
			ExitLoop
		EndIf
	WEnd

	;Si il y a presence d' erreur au lancement d'Internet explorer, alors on va ouvrir le log puis on quitte
	If ($oIE = 0) And ($aerror <> 0) Then
		$t = TimerInit()
		While ProcessExists("iexplore.exe") And TimerDiff($t) <= 15000
			ProcessClose("iexplore.exe")
		WEnd
		Exit
	EndIf
	_IEPropertySet($oIE, "theatermode", 1);On met en plein ecran
	_IEPropertySet($oIE, "toolbar", False);On vire la toolbar
	Sleep(1000)
EndFunc   ;==>_demarrage
Func _fin()
	$t = TimerInit()
	_IEQuit($oIE)
	While ProcessExists("iexplore.exe") And TimerDiff($t) <= 15000
		ProcessClose("iexplore.exe")
		Sleep(1000)
	WEnd
EndFunc   ;==>_fin
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                              NE PAS TOUCHER CI-DESSOUS                                       ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
#Region START NE PAS TOUCHER

Func MyErrFunc()
	; Important: the error object variable MUST be named $oIEErrorHandler
	$ErrorScriptline = $oIEErrorHandler.scriptline
	$ErrorNumber = $oIEErrorHandler.number
	$ErrorNumberHex = Hex($oIEErrorHandler.number, 8)
	$ErrorDescription = StringStripWS($oIEErrorHandler.description, 2)
	$ErrorWinDescription = StringStripWS($oIEErrorHandler.WinDescription, 2)
	$ErrorSource = $oIEErrorHandler.Source
	$ErrorHelpFile = $oIEErrorHandler.HelpFile
	$ErrorHelpContext = $oIEErrorHandler.HelpContext
	$ErrorLastDllError = $oIEErrorHandler.LastDllError
	$ErrorOutput = ""
	$ErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$ErrorOutput &= "----> $ErrorScriptline = " & $ErrorScriptline & @CR
	$ErrorOutput &= "----> $ErrorNumberHex = " & $ErrorNumberHex & @CR
	$ErrorOutput &= "----> $ErrorNumber = " & $ErrorNumber & @CR
	$ErrorOutput &= "----> $ErrorWinDescription = " & $ErrorWinDescription & @CR
	$ErrorOutput &= "----> $ErrorDescription = " & $ErrorDescription & @CR
	$ErrorOutput &= "----> $ErrorSource = " & $ErrorSource & @CR
	$ErrorOutput &= "----> $ErrorHelpFile = " & $ErrorHelpFile & @CR
	$ErrorOutput &= "----> $ErrorHelpContext = " & $ErrorHelpContext & @CR
	$ErrorOutput &= "----> $ErrorLastDllError = " & $ErrorLastDllError
	If $log Then
		FileWrite($file, $ErrorOutput)
		FileWrite($file, @CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & @MON & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Fin de la session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////")
		FileClose($file)
	Else
		$file = FileOpen(@ScriptDir & "\rehucit.log", 1)
		FileWrite($file, @CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & "/" & @MON & "/" & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Debut De La Session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////" & @CRLF)
		FileWrite($file, $ErrorOutput)
		FileWrite($file, @CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & @MON & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Fin de la session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////")
		FileClose($file)
	EndIf
	SetError(1)
	Return
EndFunc   ;==>MyErrFunc
Func _EmptyIECache()
	; Lecture de la cl� dans la base de registre pour la compatibilit� Vista/Seven
	$IECache = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Cache")
	If $IECache = "" Then
		SetError(1)
		Return 0
	EndIf
	; Au cas ou la cl� serait �crite avec la variable %userprofile%
	$IECache = StringReplace($IECache, "%userprofile%", @UserProfileDir)
	; Suppression du cache IE
	_FileAndDirectoryDelete($IECache)
	; Suppression du contenu du r�pertoire Content.IE5.
	Run(@ComSpec & ' /c rd /s /q "' & $IECache & '\Content.IE5"', $IECache, @SW_HIDE)
	$Size = DirGetSize($IECache & '\Content.IE5', 1)
	If $Size[2] <> 0 Then ; V�rifie que le r�pertoire est vide.
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_EmptyIECache

Func _FileAndDirectoryDelete($sDir)
	$search = FileFindFirstFile($sDir & "\*")
	If @error Then Exit
	While 1
		$Next = FileFindNextFile($search)
		If @error Then ExitLoop
		$Next = $sDir & "\" & $Next
		$att = FileGetAttrib($Next)
		If StringInStr($att, "d") Then
			FileSetAttrib($Next, "-RSH", 1)
			DirRemove($Next, 1)
		Else
			FileSetAttrib($Next, "-RSH")
			FileDelete($Next)
		EndIf
	WEnd
	FileClose($search)
EndFunc   ;==>_FileAndDirectoryDelete
Func _DateFormat($func)
	Local $split, $texte = ""

	$split = StringRegExp($func, "([0-9]{1,4})", 3)

	If IsArray($split) And @error = 0 Then $texte &= $split[2] & "-" & $split[1] & "-" & $split[0] & " " & $split[3] & ":" & $split[4] & ":" & $split[5]
	Return $texte
EndFunc   ;==>_DateFormat
Func _array($func, $t)
	$func2 = StringSplit(Eval($func), ",")
	Return $func2[$t]
EndFunc   ;==>_array
#EndRegion START NE PAS TOUCHER

