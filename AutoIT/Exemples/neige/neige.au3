    #include <GUIConstants.au3>
    #include <WindowsConstants.au3>
    ; Script Start - Add your code below here
    $image = "sne.bmp"
    $lol=GUICreate("Test",@desktopwidth,@desktopheight,0,0, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW,$WS_EX_LAYERED))
    GUISetBkColor(0xFFFFFF)
    GUISetState(@sw_show)
    WinSetOnTop($lol,"",1)
    $no = 5
    Local $dx[$no],$xp[$no],$yp[$no],$am[$no],$stx[$no],$sty[$no],$img[$no]
    $doc_width = @DesktopWidth
    $doc_height = @DesktopHeight
    For $i=0 to $no-1
        $dx[$i] = 0
        $xp[$i] = Random()*($doc_width-50)
        $yp[$i] = Random()*$doc_height
        $am[$i] = Random()*20
        $stx[$i] = 0.01 + Random()/10
        $sty[$i] = 0.7 + Random()
        $img[$i] = GUICtrlCreatePic($image,0,0,29,22)
    Next
    While 1
    For $i=0 to $no-1
        $yp[$i] += $sty[$i]
        if ($yp[$i] > $doc_height-50) Then
        $dx[$i] = 0
        $xp[$i] = Random()*($doc_width-$am[$i]-30)
        $yp[$i] = 0
        $stx[$i] = 0.02 + Random()/10
        $sty[$i] = 0.7 + Random()
    EndIf
    $pos = MouseGetPos()
    If $pos[0]<>MouseGetPos(0) And $pos[1]<>MouseGetPos(1) Then
        Exit
    EndIf
    GUICtrlSetPos($img[$i],$xp[$i]+$am[$i]*Sin($dx[$i]),$yp[$i])
        $dx[$i] += $stx[$i]
    Next
    WEnd