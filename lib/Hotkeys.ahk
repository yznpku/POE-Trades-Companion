OnHotkeyPress() {
	global PROGRAM
	static uniqueNum
	hkPressed := A_ThisHotkey
	hkSettings := PROGRAM.HOTKEYS[hkPressed]

	isHKBasic := hkSettings.Type ? True : False
	isHKAdvanced := hkSettings.Action_1_Type ? True : False

	KeyWait, Ctrl, U
	KeyWait, Shift, U
	KeyWait, Alt, U
	keysState := GetKeyStateFunc("Ctrl,LCtrl,RCtrl")
	if (isHKBasic) {
		Do_Action(hkSettings.Type, hkSettings.Content, True)
	}
	else if (isHKAdvanced) {
		uniqueNum := !uniqueNum
		Loop % hkSettings.Actions_Count {
			acType := hkSettings["Action_" A_Index "_Type"], acContent := hkSettings["Action_" A_Index "_Content"]

			if (actionType != "COPY_ITEM_INFOS")
				Do_Action(acType, acContent, True, uniqueNum)
			else if (actionType = "COPY_ITEM_INFOS")
				doCopyActionAtEnd := True
		}
		if (doCopyActionAtEnd)
			Do_Action("COPY_ITEM_INFOS", "", True, uniqueNum)
	}
	SetKeyStateFunc(keysState)
}

UpdateHotkeys() {
	DisableHotkeys()
	Declare_LocalSettings()
	EnableHotkeys()
}

DisableHotkeys() {
	global PROGRAM, POEGameGroup

	; Disable hotkeys
	for hk, nothing in PROGRAM.HOTKEYS {
		if (hk != "") {
			Hotkey, IfWinActive, ahk_group POEGameGroup
			try Hotkey,% hk, Off

			logsStr := "Disabled hotkey with key """ hk """"
			logsAppend .= logsAppend ? "`n" logsStr : logsStr
		}
	}

	if (logsAppend)
		AppendToLogs(logsAppend)

	; Reset the arr 
	PROGRAM.HOTKEYS := {}
}

EnableHotkeys() {
	global PROGRAM, POEGameGroup
	programName := PROGRAM.NAME, iniFilePath := PROGRAM.INI_FILE
	Set_TitleMatchMode("RegEx")

	PROGRAM.HOTKEYS := {}
	Loop 15 { ; 15 Basic hotkeys
		thisHotkeySettings := PROGRAM.SETTINGS["SETTINGS_HOTKEY_" A_Index]
		toggle := thisHotkeySettings.Enabled
		acContent := thisHotkeySettings.Content
		acType := thisHotkeySettings.Type
		hk := thisHotkeySettings.Hotkey
		hkSC := GetKeySC(hk), hkSC := Format("SC{:X}", hkSC)

		if (toggle = "True") && (hk != "") && (acType != "") {
			PROGRAM.HOTKEYS[hkSC] := {}
			PROGRAM.HOTKEYS[hkSC].Content := acContent
			PROGRAM.HOTKEYS[hkSC].Type := acType
			Hotkey, IfWinActive, ahk_group POEGameGroup
			try Hotkey,% hkSC, OnHotkeyPress, On
			logsStr := "Enabled hotkey with key """ hk """ (scan code: """ hkSC """)"
			logsAppend .= logsAppend ? "`n" logsStr : logsStr
		}
	}

	Loop { ; Infinite Advanced Hotkeys
		thisHotkeySettings := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" A_Index]
		acContent := thisHotkeySettings.Action_1_Content
		acType := thisHotkeySettings.Action_1_Type
		hk := thisHotkeySettings.Hotkey
		hkSC := GetKeySC(hk), hkSC := Format("SC{:X}", hkSC)

		if (hk != "") && (acType != "") {
			PROGRAM.HOTKEYS[hkSC] := {}

			Loop {
				LoopAcType := thisHotkeySettings["Action_" A_Index "_Type"]
				LoopAcContent := thisHotkeySettings["Action_" A_Index "_Content"]

				if !(LoopAcType)
					Break

				PROGRAM.HOTKEYS[hkSC]["Action_" A_Index "_Type"] := LoopAcType
				PROGRAM.HOTKEYS[hkSC]["Action_" A_Index "_Content"] := LoopAcContent
				PROGRAM.HOTKEYS[hkSC]["Actions_Count"] := A_Index
			}
			if (hk != "") {
				
				Hotkey, IfWinActive, ahk_group POEGameGroup
				Hotkey,% hkSC, OnHotkeyPress, On
				logsStr := "Enabled hotkey with key """ hk """ (scan code: """ hkSC """)"
				logsAppend .= logsAppend ? "`n" logsStr : logsStr
			}
		}
		else if (A_Index > 1000) {
			AppendToLogs(A_ThisFunc "(): Broke out of loop after 1000.")
			Break
		}
		else
			Break
	}

	if (logsAppend)
		AppendToLogs(logsAppend)
		
	Set_TitleMatchMode()
}