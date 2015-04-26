#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#include <date.au3>
#Include <GuiButton.au3>
#include <SliderConstants.au3>
#include <annonce avant commen du script.au3>
#include <Misc.au3>

Global $imgra
Dim $img1 = "\google.jpg"
$fi = FileInstall ("google.jpg",@TempDir &"\google.jpg",1)	
Dim $img2 = "\google h.jpg"
FileInstall ("google h.jpg",@TempDir &"\google h.jpg",1)
Dim $img3 = "\google h2.jpg"
FileInstall ("google h2.jpg",@TempDir &"\google h2.jpg",1)
Dim $img4 = "\google h3.jpg"
FileInstall ("google h3.jpg",@TempDir &"\google h3.jpg",1)
Dim $img5 = "\google h4.jpg"
FileInstall ("google h4.jpg",@TempDir &"\google h4.jpg",1)
Dim $img6 = "\google m.jpg"
FileInstall ("google m.jpg",@TempDir &"\google m.jpg",1)
Dim $img7 = "\google l.jpg"
FileInstall ("google l.jpg",@TempDir &"\google l.jpg",1)
Dim $img8 = "\google h1.jpg"
FileInstall ("google n.jpg",@TempDir &"\google n.jpg",1)

Dim $img9 = "\au3.jpg"
FileInstall ("au3.jpg",@TempDir &"\au3.jpg",1)
image("\google.jpg")



$Form1 = GUICreate ("SAE",623,386,135,124)
$Group1 = GUICtrlCreateGroup("Options", 8, 24, 257, 201)
$Checkbox1 = GUICtrlCreateradio("Checkbox1", 16, 56, 17, 17)
$Radio1 = GUICtrlCreateRadio("Radio1", 96, 56, 17, 17)
$Radio2 = GUICtrlCreateRadio("Radio2", 96, 80, 17, 17)
$Radio3 = GUICtrlCreateRadio("Radio3", 96, 104, 17, 17)
$Radio4 = GUICtrlCreateRadio("Radio4", 96, 128, 17, 17)
$Radio5 = GUICtrlCreateRadio("Radio5", 96, 152, 17, 17)
$Radio6 = GUICtrlCreateRadio("Radio6", 96, 176, 17, 17)
$Radio7 = GUICtrlCreateRadio("Radio7", 96, 200, 17, 17)
$Label1 = GUICtrlCreateLabel("Aide générale", 112, 56, 148, 17)
$Label2 = GUICtrlCreateLabel("Interface Utilisateur (GUI)", 112, 80, 148, 17)
$Label3 = GUICtrlCreateLabel("Active X/COM", 112, 104, 148, 17)
$Label4 = GUICtrlCreateLabel("Exemple de script", 112, 128, 148, 17)
$Label5 = GUICtrlCreateLabel("Fonction et UDF", 112, 152, 148, 17)
$Label6 = GUICtrlCreateLabel("Demande création de Scripts", 112, 176, 148, 17)
$Label7 = GUICtrlCreateLabel("Menu Principal", 112, 200, 148, 17)
$Label8 = GUICtrlCreateLabel("Rechercher", 32, 56, 60, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Go Autoit france", 336, 24, 193, 49, 0)
$imgra = _randomimg ()
If $imgra = 1 Then
	$imgr = $img1
ElseIf $imgra = 2 Then
$imgr = $img2
ElseIf $imgra = 3 Then
	$imgr = $img3
ElseIf $imgra = 4 Then
$imgr = $img4
ElseIf $imgra = 5 Then
	$imgr = $img5
ElseIf $imgra = 6 Then
$imgr  = $img6
ElseIf $imgra = 7 Then
	$imgr = $img7
ElseIf $imgra = 8 Then
$imgr = $img8
EndIf
$Pic1 = GUICtrlCreatePic(@ScriptDir & $imgr,280,150,320,138)
GUICtrlSetState(-1, $GUI_DISABLE)
$Label9 = GUICtrlCreateLabel("Créé par guitarist", 8, 304, 100, 65)
$menu1 = GUICtrlCreateMenu ("Option")
$menuitem1 = GUICtrlCreateMenuItem ("Option de couleur",$menu1)
GUICtrlSetBkColor ($Button1,0x00CBFE)
GUISetState(@SW_SHOW)
GUISetBkColor (232546)

If FileExists ("SAE.txt")Then
	$msgb = MsgBox (4,"Couleure de fond","Voulez-vous charger la couleure de fond de la derniere fois?")
	If $msgb = 6 Then
		$cc = FileReadLine ("SAE.txt",1) 
		GUISetBkColor ($cc)
	EndIf
EndIf 

	

$ttt = String ("Cliquez pour lancer Google")
$executeimg = String("http://www.google.fr")
TrayTip ("SAE","Super Autoit Navigator ==== by guitarist",130000)
While 1
	$mgp = MouseGetPos ()
_tooltip (350,500,150,250,$ttt,$Form1)
	$nMsg = GUIGetMsg()
	If $nMsg = $GUI_EVENT_CLOSE Then
		GUIDelete ()
		image ("\au3.jpg")	
            Exit
	EndIf
	Select
			
	Case $nMsg = $button1 And _IsChecked ($Radio1) 
			_internetautoit ("http://www.autoitscript.fr/forum/viewforum.php?f=3")
		
	Case $nMsg =  $button1 And  _IsChecked ($Radio7) 
			_internetautoit ("http://www.autoitscript.fr/forum/index.php")

	Case $nMsg =  $button1 And _IsChecked ($Radio2)	
			_internetautoit ("http://www.autoitscript.fr/forum/viewforum.php?f=4")
	
	Case $nMsg =  $button1 And _IsChecked ($Radio3) 
			_internetautoit ("http://www.autoitscript.fr/forum/viewforum.php?f=5")
	
	Case $nMsg =  $button1 And _IsChecked ($Radio4)
			_internetautoit ("http://www.autoitscript.fr/forum/viewforum.php?f=6")

	Case $nMsg =  $button1 And _IsChecked ($Radio5)
			_internetautoit ("http://www.autoitscript.fr/forum/viewforum.php?f=21")

	Case $nMsg =  $button1 And _IsChecked ($Radio6) 
			_internetautoit ("http://www.autoitscript.fr/forum/viewforum.php?f=20")

	Case $nMsg =  $button1 And _IsChecked ($CheckBox1)  
			_internetautoit ("http://www.autoitscript.fr/forum/search.php")
	
	Case $nMsg = $Pic1
			_tooltip (0,0,0,0,"",$Form1)
			_internetautoit ($executeimg)
			
	Case $nMsg =  $Button1
			MsgBox (1+16,"Erreur","Merci de rentrer une option",5)
		Case $nMsg =  $menuitem1
				_changecouleurguifenetre ($Form1)
		
EndSelect	

WEnd

Func _IsChecked($control)
    Return BitAnd(GUICtrlRead($control),$GUI_CHECKED) = $GUI_CHECKED
EndFunc

Func _tooltip($x1,$x2,$y1,$y2,$texteaff,$Form1)

$tabFenetre = WinGetPos($Form1)
$pos = GUIGetCursorInfo ($Form1)
$x = $pos[0]
$y = $pos[1]

		If $y >= $y1 And $y <= $y2 Then
			If $x >= $x1 And $x <= $x2 Then
				ToolTip($texteaff, $x + 12 + $tabFenetre[0], $y + 50 + $tabFenetre[1])
			EndIf	
	
	Else 
		ToolTip ("")
	EndIf
endfunc	

Func _internetautoit ($adresse)
$internetgui = GUICreate("Navigateur Perso", 800, 600, 0, 0, $WS_OVERLAPPEDWINDOW)
$lblAdresse = GUICtrlCreateLabel(" Adresse : ", 0, 8)
$txtAdresse = GUICtrlCreateInput("", 60, 5, 700)
$cmdGo = GUICtrlCreateButton(" Go ! ", 760, 5, 40, 22)
$lblHistorique = GUICtrlCreateLabel(" Historique : ", 0, 34)
$listeHistorique = GUICtrlCreateCombo("", 60, 30, 700)
$cmdGo2 = GUICtrlCreateButton(" Go ! ", 760, 30, 40, 22)

$gauche = 50
$cmdPrecedent = GUICtrlCreateButton(" <---- ", 60, 55, 70, 22)
$cmdSuivant = GUICtrlCreateButton(" ----> ", 130, 55, 70, 22)
$cmdArreter = GUICtrlCreateButton(" Arrêter ", 200, 55, 70, 22)
$cmdAcutaliser = GUICtrlCreateButton(" Acutaliser ", 270, 55, 70, 22)
$cmdDemarrage = GUICtrlCreateButton(" Démarrage ", 340, 55, 70, 22)
$cmdRechercher = GUICtrlCreateButton(" Rechercher ", 410, 55, 70, 22)
$cmdEnregistrer = GUICtrlCreateButton(" Enregistrer ", 480, 55, 70, 22)
$cmdImprimer = GUICtrlCreateButton(" Imprimer ", 550, 55, 70, 22)
_IEErrorHandlerRegister()
$ie = _IECreateEmbedded()
$ieobject = GUICtrlCreateObj($ie, 0, 82, 800, 540)
$ancien = ""
$go = 1
_IEAction($ie, "home")

GUISetState()
_IENavigate ($ie,$adresse)
Do
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
$nMsg2 = GUIGetMsg ()
	Select
	Case $nMsg2 = $cmdGo Or _IsPressed ("0D")	
		    _IENavigate($ie, GUICtrlRead($txtAdresse), 0)
	Case $nMsg2 = $cmdGo2
		_IENavigate($ie, StringMid(GUICtrlRead($listeHistorique), 24), 0)
	Case $nMsg2 = $cmdPrecedent	
		    _IEAction($ie, "back")
			If @error Then
				MsgBox(0, "", "")
			EndIf
	Case $nMsg2 = $cmdSuivant
			_IEAction($ie, "forward")
	Case $nMsg2 = $cmdArreter	
			_IEAction($ie, "stop")
	Case $nMsg2 = $cmdAcutaliser	
			_IEAction($ie, "refresh")
	Case $nMsg2 = $cmdDemarrage	
			_IEAction($ie, "home")
	Case $nMsg2 = $cmdRechercher
			_IENavigate($ie, "http://www.google.fr", 0)
	Case $nMsg2 = $cmdEnregistrer
			_IEAction($ie, "saveas")
	Case $nMsg2 = $cmdImprimer
			_IEAction($ie, "print")

			
EndSelect
	
Until $nMsg2 = $GUI_EVENT_CLOSE
			GUIDelete ($internetgui)
			_tooltip (350,500,150,250,$ttt,$Form1)
EndFunc			
Func _changecouleurguifenetre ($gui)

$Form2 = GUICreate("Option", 566, 109, 155, 193)
$couleur = GUICtrlCreateLabel("", 304, 8, 100, 89)
$Slider1 = GUICtrlCreateSlider(424, 8, 129, 17)
$Slider2 = GUICtrlCreateSlider(424, 40, 129, 17)
$Slider3 = GUICtrlCreateSlider(424, 72, 129, 17)
$B1 = GUICtrlCreateButton ("OK",1,1,290,100)
GUICtrlSetLimit ($Slider1 ,255,0)
GUICtrlSetLimit ($Slider2 ,255,0)
GUICtrlSetLimit ($Slider3 ,255,0)
GUISetState(@SW_SHOW)
Global $c1 = $Slider1,$c2 = $Slider2,$c3 = $Slider3 ,$c4 = $couleur
AdlibEnable ("_couleur",500)
Do
	$nMsg3 = GUIGetMsg()	

	If $nMsg3 = $B1 Then
		GUISetBkColor ("0x"&$CodeCouleurHexa,$Form1)
		FileDelete ("SAE.txt")
		FileWrite("SAE.txt","0x"&$CodeCouleurHexa)
	EndIf	
Until $nMsg3 = $GUI_EVENT_CLOSE
	GUIDelete ($Form2)
	
EndFunc	

Func _couleur ()
	$rouge = Hex(GUICtrlRead($c1), 2)
	$vert = Hex(GUICtrlRead($c2), 2)	
	$bleu = Hex(GUICtrlRead($c3), 2)
	$CodeCouleurHexa = $rouge & $vert & $bleu
	GUICtrlSetBkColor($c4, "0x" & $CodeCouleurHexa)	
Global $CodeCouleurHexa

EndFunc	

Func _randomimg ()
	$random = Random(1,8,1)



if $random =  1 Then

	Return 1
ElseIf $random =  2 Then
	
	Return 2
elseif $random =  3  Then
	
	Return 3
elseif $random =  4  Then
	
	Return 4
elseif $random =  5 Then
	
Return 5	
elseif $random =  6 Then

Return 6	
elseif $random =  7 Then
	
	Return 7
elseif $random =  8 Then

	Return 8
EndIf
EndFunc