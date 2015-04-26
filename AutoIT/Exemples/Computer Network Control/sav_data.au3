#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=black-gear.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Computer Network Control - 1.0.0 - http://autoit.koumla.com
#AutoIt3Wrapper_Res_Description=Computer Network Control - 1.0.0
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Made by Koumla - http://autoit.koumla.com
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#NoTrayIcon
#include <Misc.au3>

if _Singleton("CNC_1",1) = 0 Then
	Msgbox(0,"Attention","Attendre quelque seconde pour relancer l'application")
	Exit
EndIf
if _Singleton("CNC_2",1) = 0 Then
	Msgbox(0,"Attention","Attendre quelque seconde pour relancer l'application")
	Exit
EndIf

sleep (3000)

IniWrite(IniRead(@TempDir & "\cnc.ini", "exe", "exe", ""), "poste", "nombre", IniRead(@TempDir & "\cnc.ini", "poste", "nombre", ""))

	for $x = 1 to IniRead(@TempDir & "\cnc.ini", "poste", "nombre", "")

		IniWrite(IniRead(@TempDir & "\cnc.ini", "exe", "exe", ""), "poste", $x, IniRead(@TempDir & "\cnc.ini", "poste", $x, ""))

	next

FileDelete(@TempDir & "\cnc.ini")

exit