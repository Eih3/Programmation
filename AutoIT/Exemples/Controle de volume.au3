#AutoIt3Wrapper_Plugin_Funcs=_GetMasterVolume_Vista,_GetMasterVolumeScalar_Vista, _ ;~On indique les fonctions contenu dans le plugin
_SetMasterVolume_Vista,_SetMasterVolumeScalar_Vista,_GetVolumeRange_Vista,_IsMute_Vista, _
_SetMute_Vista,_GetVolumeStepInfo_Vista,_VolumeStepUp_Vista,_VolumeStepDown_Vista

;~Plugin trouvé ==> http://www.autoitscript.com/forum/topic/84834-control-vista-master-volume/
;~Fonction _setprogress trouvé ==> http://www.autoitscript.com/forum/topic/121883-progress-bar-without-animation-in-vista7/page__p__846019__hl__progress__fromsearch__1#entry846019

;######### On désigne les includes #########
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>
OnAutoItExitRegister( "_Exit" ) ;~À l'arrêt du script lancer la fonction _exit



;############# On crée la Gui#############
$Form = GUICreate("", 30, 185, 401, 240, $WS_POPUP, 0) ;Création de la Gui
WinSetOnTop($Form,"",1) ;~On met la fenêtre au premier plan
$Progress = GUICtrlCreatePic('', 0, 0, 30, 185) ;Création d'une progress bar au format image pour plus de personnalisation
_SetProgress($Progress, 0, 1, True)
GUISetState(@SW_SHOW)

$hdll = PluginOpen("vista_vol.dll") ;~On ouvre le plugin
$mute_status = _IsMute_Vista() ;~On indique si le mute est activé
$pourcentage = _GetMasterVolumeScalar_Vista() ;~On appelle la fonction pour connaître le volume actuel et note le résultat dans la variable $pourcentage
_SetProgress($Progress, $pourcentage, $mute_status, True) ;~On actualise la barre de progression(Heuresement les couleurs concordent avec le return de Ismutevista
$droit = 0 ;~ Initialisation d'une variable pour vérifier le relachement du clic droit

;########## On lance une boucle infini#########
While 1 ; Début d'une boucle infini
    $cursor = GUIGetCursorInfo ($Form) ;Connaître la position du curseur par rapport à la fenêtre
    If $cursor[0] <= 30 And $cursor[0] >=0 And _ ;Si le curseur est sur la fenêtre alors on continue
	    $cursor[1] <= 180 And $cursor[1] >= 0 Then
		Switch $cursor[2] ;Savoir si le clic gauche est enfoncé
			Case 1 ;Si le clic gauche est enfoncé
				Do ;Début de la boucle
				$mouse = MouseGetPos() ;On regarde les position du curseur
				WinMove($Form,"",$mouse[0]-$cursor[0],$mouse[1]-$cursor[1]);On déplace la fenêtre où le curseur est situé et on prend en compte sa position sur la fenêtre
				$clicnot = GUIGetCursorInfo ($Form) ;On récupère encore les données du curseur mais sous une autre variable
				Until not $clicnot[2] ; On effectue la boucle do jusqu'à ce que le clic gauche sois fini
			case 0 ;Si le clic gauche n'est pas enfoncé
				$pourcentage = Round((180-$cursor[1])/180*100,0) ; On calcule le pourcentage en fonction de la position du curseur par rapport à la fenêtre verticalement
				_SetProgress($Progress, $pourcentage, $mute_status, True) ; On modifie les données de la barre de progression
				_SetMasterVolumeScalar_Vista($pourcentage) ; On modifie le volume
		EndSwitch ; Fin de la condition de clic gauche enfoncé
		If not $cursor[3] And $droit Then $droit = 0 ;~ Si le clic droit n'est pas cliquer et que la variable $droit vaut 1 alors $droit vaut 0
		If $cursor[3] And not $droit Then ;~ Si le clic droit est cliquer et que $droit vaut 0
			If _IsMute_Vista() Then ;~ Si le volume est muter
				_SetMute_Vista(0) ;~On retire le mute
				$mute_status = 0 ;~on met la variable mute status à 0
			ElseIf not _IsMute_Vista() Then ;~ Si l'ordinateur n'est pas à mute
				_SetMute_Vista(1) ;~On la met à mute
				$mute_status = 1 ;~On met la variable mutestatus à 1
			EndIf
			_SetProgress($Progress, $pourcentage, $mute_status, True) ;~On met la barre de progression à jour
			$droit = 1 ;~On met la variable droit à 1
		EndIf

	EndIf ; Fin de la condition du curseur présent ou non dans la fenêtre
	Sleep(50) ; Pause pour soulager notre ordinateur :P
WEnd  ; Fin de la boucle infini


Func _exit() ;~Début de la fonction de fermeture
PluginClose($hDLL) ;~On ferme le plugin :)
EndFunc ;exit


Func _SetProgress($hWnd, $iPercent, $iState = 0, $fVertical = False)
    Local $hDC, $hMemDC, $hSv, $hObj, $hBitmap, $hTheme, $tRect, $tClip, $W, $H, $Ret, $Rusult = 1

    If Not IsHWnd($hWnd) Then
        $hWnd = GUICtrlGetHandle($hWnd)
        If Not $hWnd Then
            Return 0
        EndIf
    EndIf
    $hTheme = DllCall('uxtheme.dll', 'ptr', 'OpenThemeData', 'hwnd', $hWnd, 'wstr', 'Progress')
    If (@error) Or (Not $hTheme[0]) Then
        Return 0
    EndIf
    $tRect = _WinAPI_GetClientRect($hWnd)
    $W = DllStructGetData($tRect, 3) - DllStructGetData($tRect, 1)
    $H = DllStructGetData($tRect, 4) - DllStructGetData($tRect, 2)
    $hDC = _WinAPI_GetDC($hWnd)
    $hMemDC = _WinAPI_CreateCompatibleDC($hDC)
    $hBitmap = _WinAPI_CreateSolidBitmap(0, _WinAPI_GetSysColor(15), $W, $H, 0)
    $hSv = _WinAPI_SelectObject($hMemDC, $hBitmap)
    DllStructSetData($tRect, 1, 0)
    DllStructSetData($tRect, 2, 0)
    DllStructSetData($tRect, 3, $W)
    DllStructSetData($tRect, 4, $H)
    $Ret = DllCall('uxtheme.dll', 'uint', 'DrawThemeBackground', 'ptr', $hTheme[0], 'hwnd', $hMemDC, 'int', 2 - (Not $fVertical), 'int', 0, 'ptr', DllStructGetPtr($tRect), 'ptr', 0)
    If (@error) Or ($Ret[0]) Then
        $Rusult = 0
    EndIf
    If $fVertical Then
        DllStructSetData($tRect, 2, $H * (1 - $iPercent / 100))
    Else
        DllStructSetData($tRect, 3, $W * $iPercent / 100)
    EndIf
    $tClip = DllStructCreate($tagRECT)
    DllStructSetData($tClip, 1, 1)
    DllStructSetData($tClip, 2, 1)
    DllStructSetData($tClip, 3, $W - 1)
    DllStructSetData($tClip, 4, $H - 1)
    DllCall('uxtheme.dll', 'uint', 'DrawThemeBackground', 'ptr', $hTheme[0], 'hwnd', $hMemDC, 'int', 6 - (Not $fVertical), 'int', 1 + $iState, 'ptr', DllStructGetPtr($tRect), 'ptr', DllStructGetPtr($tClip))
    If (@error) Or ($Ret[0]) Then
        $Rusult = 0
    EndIf
    _WinAPI_ReleaseDC($hWnd, $hDC)
    _WinAPI_SelectObject($hMemDC, $hSv)
    _WinAPI_DeleteDC($hMemDC)
    DllCall('uxtheme.dll', 'uint', 'CloseThemeData', 'ptr', $hTheme[0])
    If $Rusult Then
        _WinAPI_DeleteObject(_SendMessage($hWnd, 0x0172, 0, $hBitmap))
        $hObj = _SendMessage($hWnd, 0x0173)
        If $hObj <> $hBitmap Then
            _WinAPI_DeleteObject($hBitmap)
        EndIf
    EndIf
    Return $Rusult
EndFunc   ;==>_SetProgress