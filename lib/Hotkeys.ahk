﻿OnHotkeyPress() {
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
	global PROGRAM

	; Disable hotkeys
	for hk, nothing in PROGRAM.HOTKEYS {
		if (hk != "") {
			Hotkey, IfWinActive, ahk_group POEGameGroup
			try Hotkey,% hk, Off
			Hotkey, IfWinActive

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
	global PROGRAM
	programName := PROGRAM.NAME, iniFilePath := PROGRAM.INI_FILE
	Set_TitleMatchMode("RegEx")

	PROGRAM.HOTKEYS := {}
	Loop 15 { ; 15 Basic hotkeys
		thisHotkeySettings := PROGRAM.SETTINGS["SETTINGS_HOTKEY_" A_Index]
		toggle := thisHotkeySettings.Enabled
		acContent := thisHotkeySettings.Content
		acType := thisHotkeySettings.Type
		hk := thisHotkeySettings.Hotkey
		hkSC := TransformKeyStr_ToScanCodeStr(hk)
		if !(hkSC)
			hkSC := TransformKeyStr_ToVirtualKeyStr(hk)

		if (toggle = "True") && (hk != "") && (acType != "") {
			PROGRAM.HOTKEYS[hkSC] := {}
			PROGRAM.HOTKEYS[hkSC].Content := acContent
			PROGRAM.HOTKEYS[hkSC].Type := acType
			Hotkey, IfWinActive, ahk_group POEGameGroup
			try Hotkey,% hkSC, OnHotkeyPress, On
			logsStr := "Enabled hotkey with key """ hk """ (sc/vk: """ hkSC """)"
			logsAppend .= logsAppend ? "`n" logsStr : logsStr
		}
	}

	Loop { ; Infinite Advanced Hotkeys
		thisHotkeySettings := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" A_Index]
		acContent := thisHotkeySettings.Action_1_Content
		acType := thisHotkeySettings.Action_1_Type
		hk := thisHotkeySettings.Hotkey
		hkSC := TransformKeyStr_ToScanCodeStr(hk)
		if !(hkSC)
			hkSC := TransformKeyStr_ToVirtualKeyStr(hk)

		if (A_Index > 1000) {
			AppendToLogs(A_ThisFunc "(): Broke out of loop after 1000.")
			Break
		}

		if IsObject(thisHotkeySettings) {
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
			if (hk != "") && (hkSC != "") {
				Hotkey, IfWinActive, ahk_group POEGameGroup
				try {
					Hotkey,% hkSC, OnHotkeyPress, On
					logsStr := "Enabled hotkey with key """ hk """ (sc/vk: """ hkSC """)"
					logsAppend .= logsAppend ? "`n" logsStr : logsStr
				}
				catch {
					logsStr := "Failed to enable hotkey doe to key or sc/vk being empty: key """ hk """ (sc/vk: """ hkSC """)"
					logsAppend .= logsAppend ? "`n" logsStr : logsStr
				}
			}
		}
		else
			Break
	}

	if (logsAppend)
		AppendToLogs(logsAppend)
		
	Set_TitleMatchMode()
}

TransformKeyStr_ToVirtualKeyStr(hk) {
	hkStr := hk, hkLen := StrLen(hk)
	Loop 3 {
		char := SubStr(hkStr, A_Index, A_Index)
		if IsIn(char, "^,+,!,#") && (hkLen > A_Index)
			hkStr_final .= char
	}
	StringTrimLeft, hkStr_noMods, hkStr,% StrLen(hkStr_final)
	hkVK := GetKeyVK(hkStr_noMods), hkVK := Format("VK{:X}", hkVK)
	hkStr_final .= hkVK

    if (hkVK = "VK0")
        return

	return hkStr_final
}

TransformKeyStr_ToScanCodeStr(hk) {
	hkStr := hk, hkLen := StrLen(hk)
	Loop 3 {
		char := SubStr(hkStr, A_Index, A_Index)
		if IsIn(char, "^,+,!,#") && (hkLen > A_Index)
			hkStr_final .= char
	}
	StringTrimLeft, hkStr_noMods, hkStr,% StrLen(hkStr_final)
	hkSC := GetKeySC(hkStr_noMods), hkSC := Format("SC{:X}", hkSC)
	hkStr_final .= hkSC

    if (hkSC = "SC0")
        return

	return hkStr_final
}