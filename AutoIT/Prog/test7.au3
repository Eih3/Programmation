$hMsg = MsgBoxC(4, "Warning", "AutoIt just did something useful!", "{d9108ba3-9a61-4398-bfbc-b02102c77e8c}") MsgBox(0, "Return Value:", "$hMsg returned: " & $hMsg) Func MsgBoxC($dwType, $lpszTitle, $lpszText, $lpszId)     $Ret = DllCall("shlwapi.dll", "long", "SHMessageBoxCheck", "long", ControlGetHandle("Program Manager", "", "SysListView32"), "string", $lpszText, _     "string", $lpszTitle, "long", $dwType, "long", 0, "string", $lpszId)     Return $Ret[0] EndFunc