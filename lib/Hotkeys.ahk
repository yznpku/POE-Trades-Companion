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
			Hotkey,% hk, Off
		}
	}

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

		if (toggle = "True") && (hk != "") && (acType != "") {
			PROGRAM.HOTKEYS[hk] := {}
			PROGRAM.HOTKEYS[hk].Content := acContent
			PROGRAM.HOTKEYS[hk].Type := acType
			Hotkey, IfWinActive, ahk_group POEGameGroup
			Hotkey,% hk, OnHotkeyPress, On
		}
	}

	Loop { ; Infinite Advanced Hotkeys
		thisHotkeySettings := PROGRAM.SETTINGS["SETTINGS_HOTKEY_ADV_" A_Index]
		acContent := thisHotkeySettings.Action_1_Content
		acType := thisHotkeySettings.Action_1_Type
		hk := thisHotkeySettings.Hotkey

		if (hk != "") || (acType != "") {
			PROGRAM.HOTKEYS[hk] := {}

			Loop {
				LoopAcType := thisHotkeySettings["Action_" A_Index "_Type"]
				LoopAcContent := thisHotkeySettings["Action_" A_Index "_Content"]

				if !(LoopAcType)
					Break

				PROGRAM.HOTKEYS[hk]["Action_" A_Index "_Type"] := LoopAcType
				PROGRAM.HOTKEYS[hk]["Action_" A_Index "_Content"] := LoopAcContent
				PROGRAM.HOTKEYS[hk]["Actions_Count"] := A_Index
			}
			if (hk != "") {
				Hotkey, IfWinActive, ahk_group POEGameGroup
				Hotkey,% hk, OnHotkeyPress, On
			}
		}
		else if (A_Index > 1000) {
			AppendToLogs(A_ThisFunc "(): Broke out of loop after 1000.")
			Break
		}
		else
			Break
	}
	Set_TitleMatchMode()
}