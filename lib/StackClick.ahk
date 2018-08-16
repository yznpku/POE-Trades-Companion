StackClick() {
	global PROGRAM
	static lastAvailable

	LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount
	SendInput {Shift Up}^{sc02E} ; Ctrl+C

	; wait for the clipboard and do nothing if it fails 
	ClipWait,% LongCopy ? 0.6 : 0.2, 1
	if (ErrorLevel) {
		ShowToolTip(PROGRAM.NAME "'s StackClick function timed out due`nto the clipboard not updating in time.")
		return
	}
	clip := Clipboard

	activeTab := GUI_Trades.GetActiveTab()
	tabContent := GUI_Trades.GetTabContent(activeTab)
	item := Get_CurrencyInfos(tabContent.Item).Name

	if (item && RegExMatch(clip, "i)(?:" item ")[\s\S]*: (\d+(?:[,.]\d+)*)\/(\d+(?:[,.]\d+)*)", match)) {
		available := RegexReplace(match1, "[,.]")
		stackSize := RegexReplace(match2, "[,.]")

		RegExMatch(tabContent.Item, "\d+", required) ; get required amount
		withdrawn := tabContent.WithdrawTally
		amount := (available >= stackSize) ? stackSize : available

		; if available amount hasn't changed, it's likely the previous click hasn't gone through yet
		if (available = lastAvailable) {
			tipInfo := "Stack size hasn't changed since your last click. `n"
			tipInfo .= "This is normaly caused by latency issues but `n"
			tipInfo .= "could mean the macro has run into problems"
			Gosub %A_ThisFunc%_ShowToolTip
			return
		}
		; Don't do anything if we've already withdrawn all we need
		if ( ((required-withdrawn) <= 0) && withdrawn ) {
			tipInfo := "You've already withdrawn the " required " " item "."
			Gosub %A_ThisFunc%_ShowToolTip
			return
		}

		if ((withdrawn + amount) < required) {
			Gosub %A_ThisFunc%_CtrlClick
		} else if ((withdrawn + amount) = required) {
			Gosub %A_ThisFunc%_CtrlClick
			Gosub %A_ThisFunc%_Finished
		} else {
			amount := required - withdrawn
			Gosub %A_ThisFunc%_ShiftClickPlus
			Gosub %A_ThisFunc%_Finished
		}

		withdrawn := withdrawn + amount ;update for tooltip
		GUI_Trades.UpdateSlotContent(activeTab, "WithdrawTally", withdrawn)
		Gosub %A_ThisFunc%_ShowToolTip
		; If transfering individual stacks, add a 250ms delay to account for lag and remove lastAvailable. Otherwise next click will do nothing
		if (available == stackSize) {
			Sleep 250
			lastAvailable := 0
		} else {
			lastAvailable := available
		}
	} else {
		Gosub %A_ThisFunc%_CtrlClick
	}
	return

	; Using these because ^{LButton} was finicky, sometimes including shifts or not executing properly
	StackClick_CtrlClick:
		Gosub %A_ThisFunc%_GetKeyStates
		SendInput {Ctrl Down}{Shift Up}{Lbutton Up}{Ctrl Up}
		Gosub %A_ThisFunc%_ReturnKeyStates
		return
	StackClick_ShiftClickPlus:
		Gosub %A_ThisFunc%_GetKeyStates
		SendInput {Shift Down}{Ctrl Up}{LButton Up}{Shift Up}
		SendInput, %amount%{Enter}
		Gosub %A_ThisFunc%_ReturnKeyStates
		return
	StackClick_GetKeyStates:
		shiftState := (GetKeyState("Shift"))?("Down"):("Up")
		ctrlState := (GetKeyState("Shift"))?("Down"):("Up")
		Hotkey, *Shift, DoNothing, On
		Hotkey, *Ctrl, DoNothing, On
		sleep 10
		return
	StackClick_ReturnKeyStates:
		sleep 10
		Hotkey, *Shift, DoNothing, Off
		Hotkey, *Ctrl, DoNothing, Off
		Send {Shift %shiftState%}{Ctrl %ctrlState%} ; Restore ctrl/shift state
		return
	StackClick_Finished: 
		lastAvailable := 0
		tipInfo := "Finished.`nYou should have " required " " item "."
		return
	StackClick_ShowToolTip:
		_tip := "Needed: " required
		. "`nTaken: " withdrawn

		if (tipInfo)
			_tip := tipInfo "`n`n" _tip
		; _tip := PROGRAM.Name " `n"
		; _tip .= "===============================`n"
		; _tip .= item.Name "`n"
		; _tip .= "Required: " required " | Withdrawn: "  withdrawn "`n"
		; if (tipInfo) {
		; 	_tip .= "===============================`n"
		; 	_tip .= tipInfo
		; }
		ShowToolTip(_tip)
		return
}
