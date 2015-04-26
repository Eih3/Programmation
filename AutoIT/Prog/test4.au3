$var1 = Ping("192.168.0.10",250)
If $var1 Then
MsgBox(64,"Status","En ligne, le roundtrip est de : " & $var1)
Else
MsgBox(64,"Status","Impossible de contacter la passerelle,erreur n°: " & @error)
Endif
WinWaitClose("Status")
If $var1 <> 0 Then
$var2 = Ping("www.google.fr",250)
If $var2 Then
MsgBox(64,"Status","En ligne, le roundtrip est de: " & $var2)
Else
MsgBox(64,"Status","Impossible de contacter google, erreur n°: " & @error)
EndIf
EndIf