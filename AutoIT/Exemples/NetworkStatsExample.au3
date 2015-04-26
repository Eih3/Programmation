#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=NetworkStatsExample.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_After=del NetworkStatsExample_Obfuscated.au3
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/om /cn=0 /cs=0 /sf=1 /sv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ========================================================================================================
; <NetworkStatsExample.au3>
;
; Example of reading and displaying Network Interface Information and Statistics
; (using <NetworkStatistics.au3> UDF)
; Statistics information, including IP, TCP*, UDP, and ICMP and internet interface traffic,
; are displayed in a 'Splash' window - with both IPv4 and IPv6 data separated
;
; Author: Ascend4nt
; ========================================================================================================

#include "_NetworkStatistics.au3"


;   --------------------    HOTKEY FUNCTION & VARIABLE --------------------

Global $bHotKeyPressed = False

Func _EscPressed()
    $bHotKeyPressed=True
EndFunc

;   --------------------    MAIN PROGRAM CODE   --------------------

HotKeySet("{Esc}", "_EscPressed")

Local $hSplash, $sSplashText
; Network Stats
Local $aUDPStats, $aTCPStats, $aIPStats, $aICMPStats
Local $aUDPv6Stats, $aTCPv6Stats, $aIPv6Stats, $aICMPv6Stats
Local $aIPv4Adapters, $nAdapters
Local $aIPv4AddrTable, $aIPAllAddrTable, $nInterfaces, $aNIEntryInfo
Local $sSeparator = "-----------------------------------------"

; IP Stats: IPv4 and IPv6
For $i = 0 To 1
	$aIPStats = _Network_IPStatistics($i)
	If @error Then
		ConsoleWrite("_Network_IPStatistics("&$i&") error: "&@error&", @extended="&@extended&@CRLF)
		ContinueLoop
	EndIf
	If $i Then
		ConsoleWrite("IP [IPv6] Stats:")
	Else
		ConsoleWrite("IP [IPv4] Stats:")
	EndIf

	ConsoleWrite( _
		" [0]  = IP Forwarding Status: [1 = Enabled, 2 = Disabled] : " & $aIPStats[0] & _
		", [1]  = Default initial time-to-live (TTL) for datagrams : " & $aIPStats[1] & @CRLF & _
		", [2]  = # Received Datagrams : " & $aIPStats[2] & _
		", [3]  = # Received Datagrams w/Header errors : " & $aIPStats[3] & _
		", [4]  = # Received Datagrams w/Address errors : " & $aIPStats[4] & @CRLF & _
		", [5]  = # Forwarded Datagrams : " & $aIPStats[5] & _
		", [6]  = # Received Datagrams w/Unknown Protocol : " & $aIPStats[6] & _
		", [7]  = # Received Datagrams Discarded : " & $aIPStats[7] & @CRLF & _
		", [8]  = # Received Datagrams Delivered : " & $aIPStats[8] & _
		", [9]  = # Requested Outgoing Datagrams : " & $aIPStats[9] & _
		", [10] = # Outgoing Datagrams Discarded : " & $aIPStats[10] & @CRLF & _
		", [11] = # Transmitted Datagrams Discarded : " & $aIPStats[11] & _
		", [12] = # Datagrams w/o Routes that were Discarded : " & $aIPStats[12] & _
		", [13] = TimeOut for Reassembling Incoming Fragmented Datagrams : " & $aIPStats[13] & @CRLF & _
		", [14] = # Datagrams Requiring Reassembly : " & $aIPStats[14] & _
		", [15] = # Datagrams Successfully Reassembled : " & $aIPStats[15] & _
		", [16] = # Datagrams that Failed to be Reassembled : " & $aIPStats[16] & @CRLF & _
		", [17] = # Datagrams that were Fragmented Successfully : " & $aIPStats[17] & _
		", [18] = # Datagrams not Fragmented, and Discarded : " & $aIPStats[18] & _
		", [19] = # Fragments created (for Datagrams) : " & $aIPStats[19] & @CRLF & _
		", [20] = # of Interfaces : " & $aIPStats[20] & _
		", [21] = # of IP addresses associated with PC : " & $aIPStats[21] & _
		", [22] = # of Routes in the Routing table : " & $aIPStats[22] & _
		@CRLF)
	ConsoleWrite($sSeparator & @CRLF)
Next

; TCP Stats: IPv4 and IPv6
For $i = 0 To 1
	$aTCPStats = _Network_TCPStatistics($i)
	If @error Then
		ConsoleWrite("_Network_TCPStatistics("&$i&") error: "&@error&", @extended="&@extended&@CRLF)
		ContinueLoop
	EndIf
	If $i Then
		ConsoleWrite("TCP [IPv6] Stats:")
	Else
		ConsoleWrite("TCP [IPv4] Stats:")
	EndIf

	ConsoleWrite( _
		"[0] Rto Algorithm = " & $aTCPStats[0] & _
		",[1] Rto Min = " & $aTCPStats[1] & _
		",[2] Rto Max = " & $aTCPStats[2] & _
		",[3] #Max Connections = " & $aTCPStats[3] & _
		",[4] #Active Opens = " & $aTCPStats[4] & _
		",[5] #Passive Opens = " & $aTCPStats[5] & @CRLF & _
		" [6] #Failed Connection Attempts = " & $aTCPStats[6] & _
		",[7] #Established Connections that were Reset = " & $aTCPStats[7] & _
		",[8] #Established Connections [current] = " & $aTCPStats[8] & @CRLF & _
		" [9] #Recvd Segments = " & $aTCPStats[9] & _
		",[10] #Sent Segments = " & $aTCPStats[10] & _
		",[11] #Retransmitted Segments = " & $aTCPStats[11] & @CRLF & _
		" [12] #Receive Errors = " & $aTCPStats[12] & _
		",[13] #Sent Segments with Reset Flag = " & $aTCPStats[13] & _
		",[14] #Connections = " & $aTCPStats[14] & _
		@CRLF)
	ConsoleWrite($sSeparator & @CRLF)
Next

; UDP Stats: IPv4 and IPv6
For $i = 0 To 1
	$aUDPStats = _Network_UDPStatistics($i)
	If @error Then
		ConsoleWrite("_Network_UDPStatistics("&$i&") error: "&@error&", @extended="&@extended&@CRLF)
		ContinueLoop
	EndIf
	If $i Then
		ConsoleWrite("UDP [IPv6] Stats:")
	Else
		ConsoleWrite("UDP [IPv4] Stats:")
	EndIf
	ConsoleWrite( _
		" [0] #Recvd Datagrams = " & $aUDPStats[0] & _
		",[1] #Discarded Datagrams [invalid port] = " & $aUDPStats[1] & _
		",[2] #Erroneous Datagrams = " & $aUDPStats[2] & @CRLF & _
		" [3] #Sent Datagrams = " & $aUDPStats[3] & _
		",[4] #UDP Listener Entries = " & $aUDPStats[4] & _
		@CRLF)
	ConsoleWrite($sSeparator & @CRLF)
Next

; ICMP Stats: IPv4 and IPv6
For $i = 0 To 1
	$aICMPStats = _Network_ICMPStatistics($i)
	If @error Then
		ConsoleWrite("_Network_ICMPStatistics("&$i&") error: "&@error&", @extended="&@extended&@CRLF)
		ContinueLoop
	EndIf

	ConsoleWrite("ICMP [IPv"&4+($i*2)&"] Stats:" & _
		" [0] = # Incoming ICMP Messages : " & $aICMPStats[0] & _
		", [1] = # Incoming ICMP Errors : " & $aICMPStats[1] & _
		", [2] = # Outgoing ICMP Messages : " & $aICMPStats[2] & _
		", [3] = # Outgoing ICMP Errors : " & $aICMPStats[3] & _
		@CRLF)
	ConsoleWrite($sSeparator & @CRLF)
Next

; IPv4 Adapters Info (very basic info)
_Network_IPv4AdaptersInfo()
ConsoleWrite($sSeparator & @CRLF)

; IPv4 Adapters Info (comprehensive info)
$aIPv4Adapters = _Network_IPv4AdaptersInfoEx()
$nAdapters = @extended
ConsoleWrite("# of Adapters: "&$nAdapters&@CRLF)
For $i = 0 To $nAdapters - 1
	ConsoleWrite("Adapter #"&$i+1&":" & _
		"  [0] Index #"& $aIPv4Adapters[$i][0] & _
		", [1] Type = " & $aIPv4Adapters[$i][1] & _
		", [2] DHCP Enabled Flag = " & $aIPv4Adapters[$i][2] & _
		", [3] WINS Enabled Flag = " & $aIPv4Adapters[$i][3] & _
		", [4] Physical [MAC] Address: " & $aIPv4Adapters[$i][4] & _
		", [5] (0) =  " & $aIPv4Adapters[$i][5] & @CRLF & _
		", [6] Description: "& $aIPv4Adapters[$i][6] & _
		", [7] [Empty '']: " & $aIPv4Adapters[$i][7] & _
		", [8] Adapter/Service Name [GUID] = " & $aIPv4Adapters[$i][8] & _
		", [9]  [Empty] =  " & $aIPv4Adapters[$i][9] & _
		", [10] [Empty] =  " & $aIPv4Adapters[$i][10] & @CRLF & _
		", [11] IPv4 Address(es): "& $aIPv4Adapters[$i][11] & _
		", [12] IP Address Mask(s): "& $aIPv4Adapters[$i][12] & @CRLF & _
		", [13] Gateway IPv4 Address(es): "& $aIPv4Adapters[$i][13] & _
		", [14] Gateway Address Mask(s) : "& $aIPv4Adapters[$i][14] & @CRLF & _
		", [15] DHCP IPv4 Address(es) = " & $aIPv4Adapters[$i][15] & _
		", [16] DHCP Address Mask(s)  = " & $aIPv4Adapters[$i][16] & _
		", [17] DHCP LeaseObtained Time = " & $aIPv4Adapters[$i][17] & _
		", [18] DHCP LeaseExpires Time = " & $aIPv4Adapters[$i][18] & @CRLF & _
		", [19] Primary WINS Server IP = " & $aIPv4Adapters[$i][19] & _
		", [20] Primary WINS Server Address Mask = " & $aIPv4Adapters[$i][20] & _
		", [21] Secondary WINS Server IP(s) = " & $aIPv4Adapters[$i][21] & _
		", [22] Secondary WINS Server Address Mask(s) = " & $aIPv4Adapters[$i][22] & @CRLF)
	ConsoleWrite($sSeparator & @CRLF)
Next

; IPv4 Interface Info alt #2
$aIPv4AddrTable = _Network_IPv4AddressTable()
$nInterfaces = @extended
ConsoleWrite(@CRLF)
For $i = 0 To $nInterfaces - 1
	ConsoleWrite("Adapter #"&$i+1&": [0] Interface Index # = " & $aIPv4AddrTable[$i][0] & _
		", [1] IPv4 Address = " & $aIPv4AddrTable[$i][1] & _
		", [2] Subnet Mask = " & $aIPv4AddrTable[$i][2] & _
		", [3] Broadcast Address = " & $aIPv4AddrTable[$i][3] & @CRLF & _
		"  [4] Max Reassembly Size = " & $aIPv4AddrTable[$i][4] & _
		", [5] Address Type/State = " & $aIPv4AddrTable[$i][5] & @CRLF)
Next
ConsoleWrite($sSeparator & @CRLF)

; IPv4 and IPv6 Interface Info (includes everything except Address Masks)
;  params: 0 (IPv4 AND IPv6), 0 (don't get all IP's), 0 (don't include down-status interfaces)
$aIPAllAddrTable = _Network_IPAllAddressTable(0, 0, 0)
$nInterfaces = @extended

ConsoleWrite($sSeparator & @CRLF)

For $i = 0 To $nInterfaces - 1
	ConsoleWrite("Interface #"&$i+1&": [0] Index #"& $aIPAllAddrTable[$i][0] & _
		", [1] Type = " & $aIPAllAddrTable[$i][1] & _
		", [2] Operational Status = " & $aIPAllAddrTable[$i][2] & _
		", [3] Flags = 0x" & Hex($aIPAllAddrTable[$i][3], 8) & _
		", [4] Physical [MAC] Address: " & $aIPAllAddrTable[$i][4] & _
		", [5] MTU =  " & $aIPAllAddrTable[$i][5] & @CRLF & _
		", [6] Description: "& $aIPAllAddrTable[$i][6] & _
		", [7] Friendly Name: " & $aIPAllAddrTable[$i][7] & _
		", [8] Adapter/Service Name [GUID] = " & $aIPAllAddrTable[$i][8] & @CRLF & _
		", [9] Max Receive Speed [Vista+] = " & $aIPAllAddrTable[$i][9] & _
		", [10] Max Transmit Speed [Vista+] = " & $aIPAllAddrTable[$i][10] & @CRLF & _
		", [11] IPv4 Address(es): "& $aIPAllAddrTable[$i][11] & _
		", [12] IPv6 Address(es): "& $aIPAllAddrTable[$i][12] & @CRLF & _
		", [13] DNS IPv4 Address(es): "& $aIPAllAddrTable[$i][13] & _
		", [14] DNS IPv6 Address(es): "& $aIPAllAddrTable[$i][14] & @CRLF & _
		", [15] Gateway IPv4 Address(es) [Vista+]: "& $aIPAllAddrTable[$i][15] & _
		", [16] Gateway IPv6 Address(es) [Vista+]: "& $aIPAllAddrTable[$i][16] & @CRLF & _
		", [17] DHCP IPv4 Address(es) [Vista+]: "& $aIPAllAddrTable[$i][17] & _
		", [18] DHCP IPv6 Address(es) [Vista+]: "& $aIPAllAddrTable[$i][18] & @CRLF & _
		", [19] WINS IPv4 Address(es) [Vista+]: "& $aIPAllAddrTable[$i][19] & _
		", [20] WINS IPv6 Address(es) [Vista+]: "& $aIPAllAddrTable[$i][20] & @CRLF & _
		", [21] Connection Type [Vista+] = " & $aIPAllAddrTable[$i][21] & _
		", [22] Tunnel Type [Vista+] = " & $aIPAllAddrTable[$i][22] & @CRLF)

	; Interface Statistics & Info for Given index
	$aNIEntryInfo = _Network_InterfaceEntryInfo($aIPAllAddrTable[$i][0])
;~ 	ConsoleWrite("_Network_InterfaceEntryInfo return, @error = " & @error & ", @extended = " & @extended & @CRLF)
	ConsoleWrite("Interface #"&$i+1&" Entry Info: [0] Interface Index = " & $aNIEntryInfo[0] & _
		", [1] Interface Type = " & $aNIEntryInfo[1] & _
		", [2] Operational Status = " & $aNIEntryInfo[2] & _
		", [3] Admin Status = " & $aNIEntryInfo[3] & _
		", [4] Physical Address = " & $aNIEntryInfo[4] & _
		", [5] MTU [Max Trans. Unit] in bytes = " & $aNIEntryInfo[5] & @CRLF & _
		", [6] Description = " & $aNIEntryInfo[6] & _
		", [7] Interface Name = " & $aNIEntryInfo[7] & @CRLF & _
		", [8] Last change [1/100th second] = " & $aNIEntryInfo[8] & _
		", [9] Interface Speed [bps] = " & $aNIEntryInfo[9] & @CRLF & _
		", [10] # Recvd Data [in Octets] = " & $aNIEntryInfo[10] & _
		", [11] # Recvd Unicast Packets = " & $aNIEntryInfo[11] & _
		", [12] # Recvd Non-Unicast Packets = " & $aNIEntryInfo[12] & _
		", [13] # Recvd Packets Discarded [no error] = " & $aNIEntryInfo[13] & _
		", [14] # Recvd Packets Discarded [error] = " & $aNIEntryInfo[14] & _
		", [15] # Recvd Packets Discarded [unk. protocol] = " & $aNIEntryInfo[15] & @CRLF & _
		", [16] # Sent Data [in Octets] = " & $aNIEntryInfo[16] & _
		", [17] # Sent Unicast Packets = " & $aNIEntryInfo[17] & _
		", [18] # Sent Non-Unicast Packets = " & $aNIEntryInfo[18] & _
		", [19] # Sent Packets Discarded [no error] = " & $aNIEntryInfo[19] & _
		", [20] # Sent Packets Discarded [error] = " & $aNIEntryInfo[20] & @CRLF & _
		", [21] Transmit Queue Length [n/a] = " & $aNIEntryInfo[21] & @CRLF)
	ConsoleWrite($sSeparator & @CRLF)
Next

$hSplash=SplashTextOn("Network Usage Information", "", 520, 24 + (19 * 15) + ($nInterfaces * (5.5 * 15)), Default, Default, 16+4, "Lucida Console", 11)

; Start loop
Do
	$aIPStats   = _Network_IPStatistics()
	$aTCPStats  = _Network_TCPStatistics()
	$aUDPStats  = _Network_UDPStatistics()
	$aICMPStats = _Network_ICMPStatistics()

	$aIPv6Stats   = _Network_IPStatistics(1)
	$aTCPv6Stats  = _Network_TCPStatistics(1)
	$aUDPv6Stats  = _Network_UDPStatistics(1)
	$aICMPv6Stats = _Network_ICMPStatistics(1)

	$sSplashText  = StringFormat("%35s", "== TCP Stats ==") & @CRLF
	$sSplashText &= StringFormat("IPv4: [Segments] Recvd   = %10u | Sent = %10u", $aTCPStats[9], $aTCPStats[10]) & @CRLF
	$sSplashText &= StringFormat("IPv6: [Segments] Recvd   = %10u | Sent = %10u", $aTCPv6Stats[9], $aTCPv6Stats[10]) & @CRLF
	$sSplashText &= StringFormat("<Total Connections> IPv4:  %10u | IPv6:  %10u", $aTCPStats[14], $aTCPv6Stats[14]) & @CRLF

	$sSplashText &= @CRLF & StringFormat("%35s", "== UDP Stats ==") & @CRLF
	$sSplashText &= StringFormat("IPv4: [Datagrams] Recvd  = %10u | Sent = %10u", $aUDPStats[0], $aUDPStats[3]) & @CRLF
	$sSplashText &= StringFormat("IPv6: [Datagrams] Recvd  = %10u | Sent = %10u", $aUDPv6Stats[0], $aUDPv6Stats[3]) & @CRLF
	$sSplashText &= StringFormat("<Total Listeners>   IPv4:  %10u | IPv6:  %10u", $aUDPStats[4], $aUDPv6Stats[4]) & @CRLF

	$sSplashText &= @CRLF & StringFormat("%35s", "== IP Stats ==") & @CRLF
	$sSplashText &= StringFormat("IPv4: [Datagrams] Recvd  = %10u | Sent = %10u", $aIPStats[2], $aIPStats[9]) & @CRLF
	$sSplashText &= StringFormat("IPv6: [Datagrams] Recvd  = %10u | Sent = %10u", $aIPv6Stats[2], $aIPv6Stats[9]) & @CRLF

	$sSplashText &= @CRLF & StringFormat("%35s", "== ICMP Stats ==") & @CRLF
	$sSplashText &= StringFormat("IPv4: [Messages]  Recvd  = %10u | Sent = %10u", $aICMPStats[0], $aICMPStats[2]) & @CRLF
	$sSplashText &= StringFormat("IPv6: [Messages]  Recvd  = %10u | Sent = %10u", $aICMPv6Stats[0], $aICMPv6Stats[2]) & @CRLF


	For $i = 0 To $nInterfaces - 1

;~ 		$aNIEntryInfo = _Network_InterfaceEntryInfo($aIPv4AddrTable[$i][0])
;~ 		$sSplashText &= @CRLF & StringFormat("%35s", "== IP " & $aIPv4AddrTable[$i][1] & " ==" ) & @CRLF

		$aNIEntryInfo = _Network_InterfaceEntryInfo($aIPAllAddrTable[$i][0])
		If @error Then
			ConsoleWrite("_Network_InterfaceEntryInfo return, @error = " & @error & ", @extended = " & @extended & @CRLF)
			ExitLoop
		EndIf

		If $aIPAllAddrTable[$i][11] <> "" Then
			$sSplashText &= @CRLF & StringFormat("%40s", "== IPv4 " & $aIPAllAddrTable[$i][11] & " ==" ) & @CRLF
		Else
			$sSplashText &= @CRLF & StringFormat("%52s", "== IPv6 " & $aIPAllAddrTable[$i][12] & " ==" ) & @CRLF
		EndIf
		$sSplashText &= StringFormat("%45.56s", $aNIEntryInfo[6]) & @CRLF

		; Octet *should* be the same as Bytes..
		$sSplashText &= StringFormat("Data (Octets/Bytes): Recvd = %10u | Sent = %10u", $aNIEntryInfo[10], $aNIEntryInfo[16]) & @CRLF
		$sSplashText &= StringFormat("Unicast Packets:     Recvd = %10u | Sent = %10u", $aNIEntryInfo[11], $aNIEntryInfo[17]) & @CRLF
		$sSplashText &= StringFormat("Non-Unicast Packets: Recvd = %10u | Sent = %10u", $aNIEntryInfo[12], $aNIEntryInfo[18]) & @CRLF
	Next

	$sSplashText &= @CRLF & StringFormat("%35s", "[ESC] Exits") & @CRLF

	ControlSetText($hSplash, "", "[CLASS:Static; INSTANCE:1]", $sSplashText)

	Sleep(500)
Until $bHotKeyPressed