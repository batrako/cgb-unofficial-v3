; #FUNCTION# ====================================================================================================================
; Name ..........: CGB GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Opt("GUIOnEventMode", 1)
Opt("MouseClickDelay", 10)
Opt("MouseClickDownDelay", 10)
Opt("TrayMenuMode", 3)

#include-once
#include "functions\Other\GUICtrlGetBkColor.au3" ; Included here to use on GUI Control

;Dynamic declaration of Array controls, cannot be on global variables because the GUI has to be created first for these control-id's to be known.
Local $aChkDonateControls[16] = [$chkDonateBarbarians, $chkDonateArchers, $chkDonateGiants, $chkDonateGoblins, $chkDonateWallBreakers, $chkDonateBalloons, $chkDonateWizards, $chkDonateHealers, $chkDonateDragons, $chkDonatePekkas, $chkDonateMinions, $chkDonateHogRiders, $chkDonateValkyries, $chkDonateGolems, $chkDonateWitches, $chkDonateLavaHounds]
Local $aChkDonateAllControls[16] = [$chkDonateAllBarbarians, $chkDonateAllArchers, $chkDonateAllGiants, $chkDonateAllGoblins, $chkDonateAllWallBreakers, $chkDonateAllBalloons, $chkDonateAllWizards, $chkDonateAllHealers, $chkDonateAllDragons, $chkDonateAllPekkas, $chkDonateAllMinions, $chkDonateAllHogRiders, $chkDonateAllValkyries, $chkDonateAllGolems, $chkDonateAllWitches, $chkDonateAllLavaHounds]
Local $aTxtDonateControls[16] = [$txtDonateBarbarians, $txtDonateArchers, $txtDonateGiants, $txtDonateGoblins, $txtDonateWallBreakers, $txtDonateBalloons, $txtDonateWizards, $txtDonateHealers, $txtDonateDragons, $txtDonatePekkas, $txtDonateMinions, $txtDonateHogRiders, $txtDonateValkyries, $txtDonateGolems, $txtDonateWitches, $txtDonateLavaHounds]
Local $aTxtBlacklistControls[16] = [$txtBlacklistBarbarians, $txtBlacklistArchers, $txtBlacklistGiants, $txtBlacklistGoblins, $txtBlacklistWallBreakers, $txtBlacklistBalloons, $txtBlacklistWizards, $txtBlacklistHealers, $txtBlacklistDragons, $txtBlacklistPekkas, $txtBlacklistMinions, $txtBlacklistHogRiders, $txtBlacklistValkyries, $txtBlacklistGolems, $txtBlacklistWitches, $txtBlacklistLavaHounds]
Local $aLblBtnControls[16] = [$lblBtnBarbarians, $lblBtnArchers, $lblBtnGiants, $lblBtnGoblins, $lblBtnWallBreakers, $lblBtnBalloons, $lblBtnWizards, $lblBtnHealers, $lblBtnDragons, $lblBtnPekkas, $lblBtnMinions, $lblBtnHogRiders, $lblBtnValkyries, $lblBtnGolems, $lblBtnWitches, $lblBtnLavaHounds]

_GDIPlus_Startup()

Func GUIControl($hWind, $iMsg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	#forceref $hWind, $iMsg, $wParam, $lParam
	Switch $iMsg
		Case 273
			Switch $nID
				Case $GUI_EVENT_CLOSE
					_GDIPlus_Shutdown()
					_GUICtrlRichEdit_Destroy($txtLog)
					SaveConfig()
					Exit
			    Case $labelGameBotURL
					 ShellExecute("https://GameBot.org") ;open web site when clicking label
			    Case $labelClashGameBotURL
					 ShellExecute("https://www.ClashGameBot.com") ;open web site when clicking label
			    Case $labelForumURL
			         ShellExecute("https://GameBot.org/forums/forumdisplay.php?fid=2") ;open web site when clicking label
				Case $btnStop
					If $RunState Then btnStop()
 				Case $btnPause
 					If $RunState Then btnPause()
				Case $btnResume
					If $RunState Then btnResume()
				Case $btnHide
					If $RunState Then btnHide()
				Case $btnAttackNow
					If $RunState then btnAttackNow()
			EndSwitch
		Case 274
			Switch $wParam
				Case 0xf060
					_GDIPlus_Shutdown()
					_GUICtrlRichEdit_Destroy($txtLog)
					SaveConfig()
					Exit
			EndSwitch
		 EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl

Func SetTime()
    Local $time = _TicksToTime(Int(TimerDiff($sTimer)), $hour, $min, $sec)
	If GUICtrlRead($tabMain, 1) = $tabStatsCredits Then GUICtrlSetData($lblresultruntime, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
EndFunc   ;==>SetTime

Func btnStart()
	CreateLogFile()

	SaveConfig()
	readConfig()	
	applyConfig()

	_GUICtrlEdit_SetText($txtLog, "")

	If WinExists($Title) Then
		DisableBS($HWnD, $SC_MINIMIZE)
		DisableBS($HWnD, $SC_CLOSE)
		If IsArray(ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) Then
			Local $BSsize = [ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[2], ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[3]]
			If $BSsize[0] <> 860 Or $BSsize[1] <> 720 Then
				SetLog("BlueStacks resolution is not set to 860x720!", $COLOR_RED)
				sleep(1000)
				SetLog("We will now automatically resize for you", $COLOR_RED)
				SetLog("Please Wait...", $COLOR_RED)

	If Not FileExists(@ScriptDir & "\860x720.reg") Then
		$Resize = InetGet("http://tinyurl.com/l9tnh8b", @ScriptDir & "\860x720.reg")
		InetClose($Resize)
		Sleep(4000)

		Run('Regedit.exe /s "' & @ScriptDir & '\860x720.reg"')
				SetLog("Resize complete", $COLOR_BLUE)
				SetLog("Close BlueStacks then press Start Bot", $COLOR_BLUE)
				sleep(10000)
				FileDelete(@ScriptDir & "\860x720.reg")
				EndIf
				Else
	WinActivate($Title)

	SetLog(_PadStringCenter(" Welcome to " & $sBotTitle & "! ", 50, "~"), $COLOR_PURPLE)
;				Global $Source = StringMid(_INetGetSource(StringFromASCIIArray($G)), 504, 1)
;				If Not($Source = StringFromASCIIArray($eThing)) Then SetLog(StringMid(_INetGetSource(StringFromASCIIArray($G)), 35148, 500), $COLOR_PURPLE)
				;SetLog($Compiled & " running on " & @OSArch & " OS")
				SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)
				SetLog(_PadStringCenter(" Bot Start ", 50, "="), $COLOR_GREEN)

				$RunState = True
				For $i = $FirstControlToHide To $LastControlToHide ; Save state of all controls on tabs
					If $i = $tabGeneral or $i = $tabSearch or $i = $tabAttack or $i = $tabAttackAdv or $i = $tabDonate or $i = $tabTroops or $i = $tabMisc or $i = $tabPushBullet then $i += 1 ; exclude tabs
					$iPrevState[$i] = GUICtrlGetState($i)
				Next
				For $i = $FirstControlToHide To $LastControlToHide ; Disable all controls in 1 go on all tabs
					If $i = $tabGeneral or $i = $tabSearch or $i = $tabAttack or $i = $tabAttackAdv or $i = $tabDonate or $i = $tabTroops or $i = $tabMisc or $i = $tabPushBullet then $i += 1 ; exclude tabs
					GUICtrlSetState($i, $GUI_DISABLE)
				Next

				GUICtrlSetState($chkBackground, $GUI_DISABLE)
				GUICtrlSetState($btnStart, $GUI_HIDE)
				GUICtrlSetState($btnStop, $GUI_SHOW)
 				GUICtrlSetState($btnPause, $GUI_SHOW)
				GUICtrlSetState($btnResume, $GUI_HIDE)

			    $sTimer = TimerInit()
			    AdlibRegister("SetTime", 1000)
				checkMainScreen()
				ZoomOut()
				BotDetectFirstTime()
				SaveConfig()
				readConfig()
				applyConfig()

				runBot()
		EndIf
		Else
		SetLog("Please Launch The Game", $COLOR_RED)
		EndIf
		Else
		SetLog("Please Launch BlueStacks", $COLOR_RED)

		EndIf
EndFunc   ;==>btnStart

	Func btnStop()
	If $RunState Then
		$RunState = False
		;$FirstStart = true
		EnableBS($HWnD, $SC_MINIMIZE)
		EnableBS($HWnD, $SC_CLOSE)
		For $i = $FirstControlToHide To $LastControlToHide ; Restore previous state of controls
			If $i = $tabGeneral or $i = $tabSearch or $i = $tabAttack or $i = $tabAttackAdv or $i = $tabDonate or $i = $tabTroops or $i = $tabMisc or $i = $tabPushBullet Then $i += 1 ; exclude tabs
			GUICtrlSetState($i, $iPrevState[$i])
		Next

		GUICtrlSetState($chkBackground, $GUI_ENABLE)
		GUICtrlSetState($btnStart, $GUI_SHOW)
		GUICtrlSetState($btnStop, $GUI_HIDE)
 		GUICtrlSetState($btnPause, $GUI_HIDE)
		GUICtrlSetState($btnResume, $GUI_HIDE)

		AdlibUnRegister("SetTime")
		_BlockInputEx(0, "", "", $HWnD)

		FileClose($hLogFileHandle)
		SetLog(_PadStringCenter(" Bot Stop ", 50, "="), $COLOR_ORANGE)
	EndIf
EndFunc   ;==>btnStop

	Func btnPause()
	Send ("{PAUSE}")
	EndFunc

	Func btnResume()
	Send ("{PAUSE}")
	EndFunc

Func btnAttackNow()
	If $RunState Then
		$bBtnAttackNowPressed = True
	EndIf
EndFunc

Func Check()
	If IsArray(ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) Then
	btnStart()
 Else
	Sleep(500)
	Check()
	EndIf
EndFunc

Func btnLocateBarracks()
	$RunState = True
	While 1
		ZoomOut()
		LocateBarrack()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateBarracks

Func btnLocateArmyCamp()
	$RunState = True
	While 1
		ZoomOut()
		LocateBarrack(True)
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateArmyCamp

Func btnLocateClanCastle()
	$RunState = True
	While 1
		ZoomOut()
		LocateClanCastle()
		ExitLoop
	WEnd
	$RunState = False
 EndFunc   ;==>btnLocateClanCastle

 Func btnLocateSpellfactory()
	$RunState = True
	While 1
		ZoomOut()
		LocateSpellFactory()
		ExitLoop
	WEnd
	$RunState = False
 EndFunc		;==>btnLocateSpellFactory

Func btnLocateTownHall()
	$RunState = True
	While 1
		ZoomOut()
		LocateTownHall()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateTownHall

Func btnSearchMode()
	While 1
		GUICtrlSetState($btnStart, $GUI_HIDE)
		GUICtrlSetState($btnStop, $GUI_SHOW)

		GUICtrlSetState($btnLocateBarracks, $GUI_DISABLE)
		GUICtrlSetState($btnSearchMode, $GUI_DISABLE)
		GUICtrlSetState($cmbTroopComp, $GUI_DISABLE)
		GUICtrlSetState($chkBackground, $GUI_DISABLE)
		;GUICtrlSetState($btnLocateCollectors, $GUI_DISABLE)

		$RunState = True
			PrepareSearch()
			If _Sleep(1000) Then Return
			VillageSearch()
		$RunState = False

		GUICtrlSetState($btnStart, $GUI_SHOW)
		GUICtrlSetState($btnStop, $GUI_HIDE)

		GUICtrlSetState($btnLocateBarracks, $GUI_ENABLE)
		GUICtrlSetState($btnSearchMode, $GUI_ENABLE)
		GUICtrlSetState($cmbTroopComp, $GUI_ENABLE)
		GUICtrlSetState($chkBackground, $GUI_ENABLE)
		;GUICtrlSetState($btnLocateCollectors, $GUI_ENABLE)
		ExitLoop
	WEnd
EndFunc   ;==>btnSearchMode

Func btnHide()
	If $Hide = False Then
		GUICtrlSetData($btnHide, "Show BS")
		$botPos[0] = WinGetPos($Title)[0]
		$botPos[1] = WinGetPos($Title)[1]
		WinMove($Title, "", -32000, -32000)
		$Hide = True
	Else
		GUICtrlSetData($btnHide, "Hide BS")

		If $botPos[0] = -32000 Then
			WinMove($Title, "", 0, 0)
		Else
			WinMove($Title, "", $botPos[0], $botPos[1])
			WinActivate($Title)
		EndIf
		$Hide = False
	EndIf
EndFunc   ;==>btnHide

Func chkDeployRedArea()
		If GUICtrlRead($chkDeployRedArea) = $GUI_CHECKED Then
		$chkRedArea = 1
		For $i = $lblSmartDeploy to $chkAttackNearDarkElixirDrill
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$chkRedArea = 0
		For $i = $lblSmartDeploy to $chkAttackNearDarkElixirDrill
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc

Func cmbTroopComp()
	If _GUICtrlComboBox_GetCurSel($cmbTroopComp) <> $icmbTroopComp Then
		$icmbTroopComp = _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		for $i=0 to Ubound($TroopName) - 1 
			 Assign("Cur" & $TroopName[$i],1)
		next
		for $i=0 to Ubound($TroopDarkName) - 1 
			 Assign("Cur" & $TroopDarkName[$i],1)
		next
		SetComboTroopComp()
	EndIf
EndFunc   ;==>cmbTroopComp

Func SetComboTroopComp()
	Switch _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		Case 0
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			GUICtrlSetData($txtNumBarb, "0")
			GUICtrlSetData($txtNumArch, "100")
			GUICtrlSetData($txtNumGobl, "0")

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next
		Case 1
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next
			GUICtrlSetData($txtNumBarb, "100")
		Case 2
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next
			GUICtrlSetData($txtNumGobl, "100")
		Case 3
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next

			GUICtrlSetData($txtNumBarb, "50")
			GUICtrlSetData($txtNumArch, "50")
		Case 4
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next

			_GUICtrlEdit_SetReadOnly($txtNumGiant, False)

			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")

			GUICtrlSetData($txtNumGiant, $GiantComp)
		Case 5
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next
			_GUICtrlEdit_SetReadOnly($txtNumGiant, False)

			GUICtrlSetData($txtNumBarb, "50")
			GUICtrlSetData($txtNumArch, "50")

			GUICtrlSetData($txtNumGiant, $GiantComp)
		Case 6
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next
			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")
		Case 7
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), True)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), True)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), "0")
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), "0")
			next

			_GUICtrlEdit_SetReadOnly($txtNumGiant, False)
			_GUICtrlEdit_SetReadOnly($txtNumWall, False)

			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")

			GUICtrlSetData($txtNumGiant, $GiantComp)
			GUICtrlSetData($txtNumWall, $WallComp)
			GUICtrlSetData($txtNumWiza, $WizaComp)
			GUICtrlSetData($txtNumMini, $MiniComp)
			GUICtrlSetData($txtNumHogs, $HogsComp)
		Case 8
			GUICtrlSetState($cmbBarrack1, $GUI_ENABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_ENABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_ENABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_ENABLE)
			;GUICtrlSetState($txtCapacity, $GUI_DISABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_DISABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_DISABLE)
			next
		Case 9
			GUICtrlSetState($cmbBarrack1, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack2, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack3, $GUI_DISABLE)
			GUICtrlSetState($cmbBarrack4, $GUI_DISABLE)
			;GUICtrlSetState($txtCapacity, $GUI_ENABLE)
			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetState(eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetState(eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			next

			for $i=0 to Ubound($TroopName) - 1 
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopName[$i]), False)
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				_GUICtrlEdit_SetReadOnly(eval("txtNum" & $TroopDarkName[$i]), False)
			next

			for $i=0 to Ubound($TroopName) - 1 
				GUICtrlSetData(eval("txtNum" & $TroopName[$i]), eval($TroopName[$i]&"Comp"))
			next
			for $i=0 to Ubound($TroopDarkName) - 1  
				GUICtrlSetData(eval("txtNum" & $TroopDarkName[$i]), eval($TroopDarkName[$i]&"Comp"))
			next

	EndSwitch
	lblTotalCount()
EndFunc   ;==>SetComboTroopComp

Func cmbBotCond()
   If _GUICtrlComboBox_GetCurSel($cmbBotCond) = 13 Then
	  If _GUICtrlComboBox_GetCurSel($cmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($cmbHoursStop, 1)
	  GUICtrlSetState($cmbHoursStop, $GUI_ENABLE)
   Else
	  _GUICtrlComboBox_SetCurSel($cmbHoursStop, 0)
	  GUICtrlSetState($cmbHoursStop, $GUI_DISABLE)
   EndIf
EndFunc	  ;==>cmbBotCond

Func Randomspeedatk()
   If GUICtrlRead($Randomspeedatk) = $GUI_CHECKED Then
	  $iRandomspeedatk = 1
	  GUICtrlSetState($cmbUnitDelay, $GUI_DISABLE)
	  GUICtrlSetState($cmbWaveDelay, $GUI_DISABLE)
   Else
	  $iRandomspeedatk = 0
	  GUICtrlSetState($cmbUnitDelay, $GUI_ENABLE)
	  GUICtrlSetState($cmbWaveDelay, $GUI_ENABLE)
   EndIf
EndFunc   ;==>Randomspeedatk

Func chkSearchReduction()
	If GUICtrlRead($chkSearchReduction) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtSearchReduceCount, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceGold, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceElixir, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceDark, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceTrophy, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtSearchReduceCount, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceGold, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceElixir, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceDark, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceTrophy, True)
	EndIf
EndFunc

Func chkMeetDE()
	If GUICtrlRead($chkMeetDE) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtMinDarkElixir, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtMinDarkElixir, True)
	EndIf
EndFunc

Func chkMeetTrophy()
	If GUICtrlRead($chkMeetTrophy) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtMinTrophy, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtMinTrophy, True)
	EndIf
EndFunc

Func chkMeetTH()
	If GUICtrlRead($chkMeetTH) = $GUI_CHECKED Then
		GUICtrlSetState($cmbTH, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbTH, $GUI_DISABLE)
	EndIf
EndFunc

Func chkBackground()
	If GUICtrlRead($chkBackground) = $GUI_CHECKED Then
		$ichkBackground = 1
		GUICtrlSetState($btnHide, $GUI_ENABLE)
	Else
		$ichkBackground = 0
		GUICtrlSetState($btnHide, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBackground

Func radWeakBases()
	GUICtrlSetState($grpWeakBaseSettings, $GUI_ENABLE)
	GUICtrlSetState($lblWBMortar, $GUI_ENABLE)
	GUICtrlSetState($cmbWBMortar, $GUI_ENABLE)
	GUICtrlSetState($lblWBWizTower, $GUI_ENABLE)
	GUICtrlSetState($cmbWBWizTower, $GUI_ENABLE)
	;GUICtrlSetState($lblWBXBow, $GUI_ENABLE)
	;GUICtrlSetState($cmbWBXbow, $GUI_ENABLE)
EndFunc   ;==>radWeakBases

Func radNotWeakBases()
	GUICtrlSetState($grpWeakBaseSettings, $GUI_DISABLE)
	GUICtrlSetState($lblWBMortar, $GUI_DISABLE)
	GUICtrlSetState($cmbWBMortar, $GUI_DISABLE)
	GUICtrlSetState($lblWBWizTower, $GUI_DISABLE)
	GUICtrlSetState($cmbWBWizTower, $GUI_DISABLE)
	GUICtrlSetState($lblWBXBow, $GUI_DISABLE)
	GUICtrlSetState($cmbWBXbow, $GUI_DISABLE)
EndFunc   ;==>radNotWeakBases

Func chkAttackNow()
	If GUICtrlRead($chkAttackNow) = $GUI_CHECKED Then
		$iChkAttackNow = 1
		GUICtrlSetState($lblAttackNow, $GUI_ENABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
	Else
		$iChkAttackNow = 0
		GUICtrlSetState($lblAttackNow, $GUI_DISABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_DISABLE)
	EndIf
EndFunc

Func GUILightSpell()
	If GUICtrlRead($chkLightSpell) = $GUI_CHECKED Then
	$iChkLightSpell = 1
	    GUICtrlSetState($lbliLSpellQ, $GUI_ENABLE)
		GUICtrlSetState($cmbiLSpellQ, $GUI_ENABLE)
		GUICtrlSetState($lbliLSpellQ2, $GUI_ENABLE)
	Else
	   $iChkLightSpell = 0
		GUICtrlSetState($lbliLSpellQ, $GUI_DISABLE)
		GUICtrlSetState($cmbiLSpellQ, $GUI_DISABLE)
		GUICtrlSetState($lbliLSpellQ2, $GUI_DISABLE)
	EndIf
EndFunc

Func chkBullyMode()
	If GUICtrlRead($chkBullyMode) = $GUI_CHECKED Then
		$OptBullyMode = 1
		GUICtrlSetState($txtATBullyMode, $GUI_ENABLE)
		GUICtrlSetState($cmbYourTH, $GUI_ENABLE)
	Else
		$OptBullyMode = 0
		GUICtrlSetState($txtATBullyMode, $GUI_DISABLE)
		GUICtrlSetState($cmbYourTH, $GUI_DISABLE)
	EndIf
EndFunc

Func chkSnipeMode()
		If GUICtrlRead($chkTrophyMode) = $GUI_CHECKED Then
		$OptBullyMode = 1
		GUICtrlSetState($txtTHaddtiles, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackTHType, $GUI_ENABLE)
	Else
		$OptBullyMode = 0
		GUICtrlSetState($txtTHaddtiles, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackTHType, $GUI_DISABLE)
	EndIf
EndFunc

Func chkRequest()
	If GUICtrlRead($chkRequest) = $GUI_CHECKED Then
		$ichkRequest = 1
		GUICtrlSetState($txtRequest, $GUI_ENABLE)
		GUICtrlSetState($btnLocateClanCastle, $GUI_SHOW)
	Else
		$ichkRequest = 0
		GUICtrlSetState($txtRequest, $GUI_DISABLE)
		GUICtrlSetState($btnLocateClanCastle, $GUI_HIDE)
	EndIf
EndFunc

Func lblTotalCount()
	GUICtrlSetData($lblTotalCount, GUICtrlRead($txtNumBarb) + GUICtrlRead($txtNumArch) + GUICtrlRead($txtNumGobl))
	IF GUICtrlRead($lblTotalCount) = "100" Then
		GUICtrlSetBkColor ($lblTotalCount, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblTotalCount) = "0" Then
		GUICtrlSetBkColor ($lblTotalCount, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor ($lblTotalCount, $COLOR_RED)
	EndIf
EndFunc

Func btnDonateBarbarians()
	If GUICtrlGetState($grpBarbarians) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBarbarians, $txtBlacklistBarbarians) ;Hide/Show controls on Donate tab
	EndIf
EndFunc

Func btnDonateArchers()
	If GUICtrlGetState($grpArchers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpArchers, $txtBlacklistArchers)
	EndIf
EndFunc

Func btnDonateGiants()
	If GUICtrlGetState($grpGiants) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpGiants, $txtBlacklistGiants)
	EndIf
EndFunc

Func btnDonateGoblins()
	If GUICtrlGetState($grpGoblins) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpGoblins, $txtBlacklistGoblins)
	EndIf
EndFunc

Func btnDonateWallBreakers()
	If GUICtrlGetState($grpWallBreakers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpWallBreakers, $txtBlacklistWallBreakers)
	EndIf
EndFunc

Func btnDonateBalloons()
	If GUICtrlGetState($grpBalloons) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBalloons, $txtBlacklistBalloons)
	EndIf
EndFunc

Func btnDonateWizards()
	If GUICtrlGetState($grpWizards) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpWizards, $txtBlacklistWizards)
	Endif
EndFunc

Func btnDonateHealers()
	If GUICtrlGetState($grpHealers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpHealers, $txtBlacklistHealers)
	Endif
EndFunc

Func btnDonateDragons()
	If GUICtrlGetState($grpDragons) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpDragons, $txtBlacklistDragons)
	Endif
EndFunc

Func btnDonatePekkas()
	If GUICtrlGetState($grpPekkas) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpPekkas, $txtBlacklistPekkas)
	Endif
EndFunc

Func btnDonateMinions()
	If GUICtrlGetState($grpMinions) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpMinions, $txtBlacklistMinions)
	EndIf
EndFunc

Func btnDonateHogRiders()
	If GUICtrlGetState($grpHogRiders) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpHogRiders, $txtBlacklistHogRiders)
	EndIf
EndFunc

Func btnDonateValkyries()
	If GUICtrlGetState($grpValkyries) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpValkyries, $txtBlacklistValkyries)
	EndIf
EndFunc

Func btnDonateGolems()
	If GUICtrlGetState($grpGolems) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpGolems, $txtBlacklistGolems)
	EndIf
EndFunc

Func btnDonateWitches()
	If GUICtrlGetState($grpWitches) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpWitches, $txtBlacklistWitches)
	EndIf
EndFunc

Func btnDonateLavaHounds()
	If GUICtrlGetState($grpLavaHounds) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpLavaHounds, $txtBlacklistLavaHounds)
	EndIf
EndFunc

Func btnDonateBlacklist()
	If GUICtrlGetState($grpBlacklist) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBlacklist, $txtBlacklist)
	EndIf
EndFunc

Func chkDonateAllBarbarians()
	IF GUICtrlRead($chkDonateAllBarbarians) = $GUI_CHECKED Then
		_DonateAllControls($eBarb, True)
	Else
		_DonateAllControls($eBarb, False)
	EndIf
EndFunc

Func chkDonateAllArchers()
	IF GUICtrlRead($chkDonateAllArchers) = $GUI_CHECKED Then
		_DonateAllControls($eArch, True)
	Else
		_DonateAllControls($eArch, False)
	EndIf
EndFunc

Func chkDonateAllGiants()
	IF GUICtrlRead($chkDonateAllGiants) = $GUI_CHECKED Then
		_DonateAllControls($eGiant, True)
	Else
		_DonateAllControls($eGiant, False)
	EndIf
EndFunc

Func chkDonateAllGoblins()
	IF GUICtrlRead($chkDonateAllGoblins) = $GUI_CHECKED Then
		_DonateAllControls($eGobl, True)
	Else
		_DonateAllControls($eGobl, False)
	EndIf
EndFunc

Func chkDonateAllWallBreakers()
	IF GUICtrlRead($chkDonateAllWallBreakers) = $GUI_CHECKED Then
		_DonateAllControls($eWall, True)
	Else
		_DonateAllControls($eWall, False)
	EndIf
EndFunc

Func chkDonateAllBalloons()
	IF GUICtrlRead($chkDonateAllBalloons) = $GUI_CHECKED Then
		_DonateAllControls($eBall, True)
	Else
		_DonateAllControls($eBall, False)
	EndIf
EndFunc

Func chkDonateAllWizards()
	IF GUICtrlRead($chkDonateAllWizards) = $GUI_CHECKED Then
		_DonateAllControls($eWiza, True)
	Else
		_DonateAllControls($eWiza, False)
	EndIf
EndFunc

Func chkDonateAllHealers()
	IF GUICtrlRead($chkDonateAllHealers) = $GUI_CHECKED Then
		_DonateAllControls($eHeal, True)
	Else
		_DonateAllControls($eHeal, False)
	EndIf
EndFunc

Func chkDonateAllDragons()
	IF GUICtrlRead($chkDonateAllDragons) = $GUI_CHECKED Then
		_DonateAllControls($eDrag, True)
	Else
		_DonateAllControls($eDrag, False)
	EndIf
EndFunc

Func chkDonateAllPekkas()
	IF GUICtrlRead($chkDonateAllPekkas) = $GUI_CHECKED Then
		_DonateAllControls($ePekk, True)
	Else
		_DonateAllControls($ePekk, False)
	EndIf
EndFunc

Func chkDonateAllMinions()
	IF GUICtrlRead($chkDonateAllMinions) = $GUI_CHECKED Then
		_DonateAllControls($eMini, True)
	Else
		_DonateAllControls($eMini, False)
	EndIf
EndFunc

Func chkDonateAllHogRiders()
	IF GUICtrlRead($chkDonateAllHogRiders) = $GUI_CHECKED Then
		_DonateAllControls($eHogs, True)
	Else
		_DonateAllControls($eHogs, False)
	EndIf
EndFunc

Func chkDonateAllValkyries()
	IF GUICtrlRead($chkDonateAllValkyries) = $GUI_CHECKED Then
		_DonateAllControls($eValk, True)
	Else
		_DonateAllControls($eValk, False)
	EndIf
EndFunc

Func chkDonateAllGolems()
	IF GUICtrlRead($chkDonateAllGolems) = $GUI_CHECKED Then
		_DonateAllControls($eGole, True)
	Else
		_DonateAllControls($eGole, False)
	EndIf
EndFunc

Func chkDonateAllWitches()
	IF GUICtrlRead($chkDonateAllWitches) = $GUI_CHECKED Then
		_DonateAllControls($eWitc, True)
	Else
		_DonateAllControls($eWitc, False)
	EndIf
EndFunc

Func chkDonateAllLavaHounds()
	IF GUICtrlRead($chkDonateAllLavaHounds) = $GUI_CHECKED Then
		_DonateAllControls($eLava, True)
	Else
		_DonateAllControls($eLava, False)
	EndIf
EndFunc

Func chkDonateBarbarians()
	IF GUICtrlRead($chkDonateBarbarians) = $GUI_CHECKED Then
		_DonateControls($eBarb)
	Else
		GUICtrlSetBkColor($lblBtnBarbarians, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateArchers()
	IF GUICtrlRead($chkDonateArchers) = $GUI_CHECKED Then
		_DonateControls($eArch)
	Else
		GUICtrlSetBkColor($lblBtnArchers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateGiants()
	IF GUICtrlRead($chkDonateGiants) = $GUI_CHECKED Then
		_DonateControls($eGiant)
	Else
		GUICtrlSetBkColor($lblBtnGiants, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateGoblins()
	IF GUICtrlRead($chkDonateGoblins) = $GUI_CHECKED Then
		_DonateControls($eGobl)
	Else
		GUICtrlSetBkColor($lblBtnGoblins, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateWallBreakers()
	IF GUICtrlRead($chkDonateWallBreakers) = $GUI_CHECKED Then
		_DonateControls($eWall)
	Else
		GUICtrlSetBkColor($lblBtnWallBreakers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateBalloons()
	IF GUICtrlRead($chkDonateBalloons) = $GUI_CHECKED Then
		_DonateControls($eBall)
	Else
		GUICtrlSetBkColor($lblBtnBalloons, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateWizards()
	IF GUICtrlRead($chkDonateWizards) = $GUI_CHECKED Then
		_DonateControls($eWiza)
	Else
		GUICtrlSetBkColor($lblBtnWizards, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateHealers()
	IF GUICtrlRead($chkDonateHealers) = $GUI_CHECKED Then
		_DonateControls($eHeal)
	Else
		GUICtrlSetBkColor($lblBtnHealers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateDragons()
	IF GUICtrlRead($chkDonateDragons) = $GUI_CHECKED Then
		_DonateControls($eDrag)
	Else
		GUICtrlSetBkColor($lblBtnDragons, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonatePekkas()
	IF GUICtrlRead($chkDonatePekkas) = $GUI_CHECKED Then
		_DonateControls($ePekk)
	Else
		GUICtrlSetBkColor($lblBtnPekkas, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateMinions()
	IF GUICtrlRead($chkDonateMinions) = $GUI_CHECKED Then
		_DonateControls($eMini)
	Else
		GUICtrlSetBkColor($lblBtnMinions, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateHogRiders()
	IF GUICtrlRead($chkDonateHogRiders) = $GUI_CHECKED Then
		_DonateControls($eHogs)
	Else
		GUICtrlSetBkColor($lblBtnHogRiders, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateValkyries()
	IF GUICtrlRead($chkDonateValkyries) = $GUI_CHECKED Then
		_DonateControls($eValk)
	Else
		GUICtrlSetBkColor($lblBtnValkyries, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateGolems()
	IF GUICtrlRead($chkDonateGolems) = $GUI_CHECKED Then
		_DonateControls($eGole)
	Else
		GUICtrlSetBkColor($lblBtnGolems, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateWitches()
	IF GUICtrlRead($chkDonateWitches) = $GUI_CHECKED Then
		_DonateControls($eWitc)
	Else
		GUICtrlSetBkColor($lblBtnWitches, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkDonateLavaHounds()
	IF GUICtrlRead($chkDonateLavaHounds) = $GUI_CHECKED Then
		_DonateControls($eLava)
	Else
		GUICtrlSetBkColor($lblBtnLavaHounds, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc

Func chkWalls()
	IF GUICtrlRead($chkWalls) = $GUI_CHECKED Then
		GUICtrlSetState($UseGold, $GUI_ENABLE)
;		GUICtrlSetState($UseElixir, $GUI_ENABLE)
;		GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
		GUICtrlSetState($cmbWalls, $GUI_ENABLE)
		GUICtrlSetState($txtWallMinGold, $GUI_ENABLE)
;		GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		cmbWalls()
	Else
		GUICtrlSetState($UseGold, $GUI_DISABLE)
		GUICtrlSetState($UseElixir, $GUI_DISABLE)
		GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		GUICtrlSetState($cmbWalls, $GUI_DISABLE)
		GUICtrlSetState($txtWallMinGold, $GUI_DISABLE)
		GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
	EndIf
EndFunc

Func cmbWalls()
	Switch _GUICtrlComboBox_GetCurSel($cmbWalls)
		Case 0
			$WallCost = 30000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
		  GUICtrlSetState($UseElixir, $GUI_DISABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 1
			$WallCost = 75000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
		  GUICtrlSetState($UseElixir, $GUI_DISABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 2
			$WallCost = 200000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
		  GUICtrlSetState($UseElixir, $GUI_DISABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 3
			$WallCost = 500000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
		  GUICtrlSetState($UseElixir, $GUI_DISABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 4
			$WallCost = 1000000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
		  GUICtrlSetState($UseElixir, $GUI_ENABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		Case 5
			$WallCost = 3000000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
		  GUICtrlSetState($UseElixir, $GUI_ENABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		Case 6
			$WallCost = 4000000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
		  GUICtrlSetState($UseElixir, $GUI_ENABLE)
		  GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
		  GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
	EndSwitch
EndFunc

Func chkTrap()
	If GUICtrlRead($chkTrap) = $GUI_CHECKED Then
		$ichkTrap = 1
		GUICtrlSetState($btnLocateTownHall, $GUI_SHOW)
	Else
		$ichkTrap = 0
		GUICtrlSetState($btnLocateTownHall, $GUI_HIDE)
	EndIf
EndFunc

Func sldVSDelay()
	$iVSDelay = GUICtrlRead($sldVSDelay)
	GUICtrlSetData($lblVSDelay, $iVSDelay)

	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, "second")
	Else
		GUICtrlSetData($lbltxtVSDelay, "seconds")
	EndIf
EndFunc

Func tabMain()
	If GUICtrlRead($tabMain, 1) = $tabGeneral Then
		ControlShow("", "", $txtLog)
	Else
		ControlHide("", "", $txtLog)
	EndIf
EndFunc ;==>tabMain

Func DisableBS($HWnD, $iButton)
	ConsoleWrite('+ Window Handle: ' & $HWnD & @CRLF)
	$hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 0)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>DisableBS

Func EnableBS($HWnD, $iButton)
	ConsoleWrite('+ Window Handle: ' & $HWnD & @CRLF)
	$hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 1)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>EnableBS

Func btnLocateUp1()
	$RunState = True
	While 1
		ZoomOut()
		LocateUpgrade1()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateUp1

Func btnLocateUp2()
	$RunState = True
	While 1
		ZoomOut()
		LocateUpgrade2()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateUp2

Func btnLocateUp3()
	$RunState = True
	While 1
		ZoomOut()
		LocateUpgrade3()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateUp3

Func btnLocateUp4()
	$RunState = True
	While 1
		ZoomOut()
		LocateUpgrade4()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateUp4

Func btnLoots()
    Run ("Explorer.exe " & @ScriptDir & "\Loots")
EndFunc   ;==>btnLoots

Func btnLogs()
    Run ("Explorer.exe " & @ScriptDir & "\Logs")
EndFunc   ;==>btnLogs


;---------------------------------------------------
; Extra Functions used on GUI Control
;---------------------------------------------------

Func _DonateAllControls($TroopType, $Set)
	If $Set = True Then
		For $i = 0 to Ubound($aLblBtnControls) - 1
			If $i = $TroopType Then
				GUICtrlSetBkColor($aLblBtnControls[$i], $COLOR_NAVY)
			Else
				GUICtrlSetBkColor($aLblBtnControls[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		Next

		For $i = 0 to Ubound($aChkDonateAllControls) - 1
			If $i <> $TroopType Then
				GUICtrlSetState($aChkDonateAllControls[$i], $GUI_UNCHECKED)
			EndIf
		Next

		For $i = 0 to UBound($aChkDonateControls) - 1
			GUICtrlSetState($aChkDonateControls[$i], $GUI_UNCHECKED)
		Next

		For $i = 0 to UBound($aTxtDonateControls) - 1
			If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_DISABLE)
		Next

		For $i = 0 to UBound($aTxtBlacklistControls) - 1
			If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_DISABLE)
		Next

		If BitAND(GUICtrlGetState($txtBlacklist), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($txtBlacklist, $GUI_DISABLE)
	Else
		GUICtrlSetBkColor($aLblBtnControls[$TroopType], $GUI_BKCOLOR_TRANSPARENT)

		For $i = 0 to UBound($aTxtDonateControls) - 1
			If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_ENABLE)
		Next

		For $i = 0 to UBound($aTxtBlacklistControls) - 1
			If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_ENABLE)
		Next

		If BitAND(GUICtrlGetState($txtBlacklist), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($txtBlacklist, $GUI_ENABLE)
	EndIf
EndFunc

Func _DonateControls($TroopType)
	For $i = 0 to Ubound($aLblBtnControls) - 1
		If $i = $TroopType Then
			GUICtrlSetBkColor($aLblBtnControls[$i], $COLOR_GREEN)
		Else
			If GUICtrlGetBkColor($aLblBtnControls[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($aLblBtnControls[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf
	Next

	For $i = 0 to Ubound($aChkDonateAllControls) - 1
		GUICtrlSetState($aChkDonateAllControls[$i], $GUI_UNCHECKED)
	Next

	For $i = 0 to UBound($aTxtDonateControls) - 1
		If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_ENABLE)
	Next

	For $i = 0 to UBound($aTxtBlacklistControls) - 1
		If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_ENABLE)
	Next
EndFunc

Func _DonateBtn($FirstControl, $LastControl)
	; Hide Controls
	If $LastDonateBtn1 = -1 Then
		For $i = $grpBarbarians To $txtBlacklistBarbarians ; 1st time use: Hide Barbarian controls
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	Else
		For $i = $LastDonateBtn1 To $LastDonateBtn2 ; Hide last used controls on Donate Tab
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf

	$LastDonateBtn1 = $FirstControl
	$LastDonateBtn2 = $LastControl

	;Show Controls
	For $i = $FirstControl To $LastControl ; Show these controls on Donate Tab
		GUICtrlSetState($i, $GUI_SHOW)
	Next
EndFunc

;---------------------------------------------------
If FileExists($config) Then
	readConfig()
	applyConfig()
EndIf
If FileExists($building) Then
	readConfig()
	applyConfig()
EndIf
GUIRegisterMsg($WM_COMMAND, "GUIControl")
GUIRegisterMsg($WM_SYSCOMMAND, "GUIControl")
;---------------------------------------------------
