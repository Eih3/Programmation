; Includes the GuiConstants (required for GUI function usage)
#include <GuiConstants.au3>
; Hides tray icon
#NoTrayIcon
; Change to OnEvent mode
Opt('GUIOnEventMode', 1)
; GUI Creation
GuiCreate("Ai Smart Homes - Saint Louis, Missouri", 400, 300)
GuiSetIcon("icon.ico")
; Runs the GUIExit() function if the GUI is closed
GUISetOnEvent($GUI_EVENT_CLOSE, 'GUIExit')
; Logo / Pic
GuiCtrlCreatePic("logo.jpg",120,5,156,160)
; Instructions
GUICtrlCreateLabel("Please Choose an Option Below:", 50, 180, 300, 15, $SS_CENTER)
GUICtrlSetColor(-1,0xFF0000) ; Makes instructions Red
; Button1
GUICtrlCreateButton("Visit Our Website", 100, 210, 200, 30)
GUICtrlSetOnEvent(-1, 'website') ; Runs website() when pressed
; Button2
GUICtrlCreateButton("Send an Email", 100, 250, 200, 30)
GUICtrlSetOnEvent(-1, 'email') ; Runs email() when pressed
Func website()
; Hides the GUI while the function is running
GUISetState(@SW_HIDE)
Run("C:\Program Files\Internet Explorer\iexplore.exe www.aismarthomes.com")
Exit
EndFunc
Func email()
; Hides the GUI while the function is running
GUISetState(@SW_HIDE)
Run("mailto:contact@aismarthomes.com")
Exit
EndFunc
; Shows the GUI after the function completes
GUISetState(@SW_SHOW)
; Idles the script in an infinite loop - this MUST be included when using
OnEvent mode
While 1
Sleep(500)
WEnd
; This function makes the script exit when the GUI is closed
Func GUIExit()
Exit
EndFunc