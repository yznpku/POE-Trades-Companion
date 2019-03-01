class GUI_Intercom {
    Create() {
        global GuiIntercom, GuiIntercom_Controls

        Gui, Intercom:Destroy
        Gui.New("Intercom", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +LabelGUI_Intercom_ +HwndhGuiIntercom", "Intercom")

        Loop 100 {
            Gui.Add("Intercom", "Edit", "x0 y0 w0 h0 hwndhEDIT_Slot" A_Index " ")
            __f := GUI_Intercom.OnSlotContentChange.bind(GUI_Intercom, A_Index)
            GuiControl, Intercom:+g,% GuiIntercom_Controls["hEDIT_Slot" A_Index],% __f
        }

        Gui.Show("Intercom", "x0 y0 w0 w0 NoActivate Hide")
    }

    GetNextAvailableSlot() {
        Loop 100 {
            if ( GUI_Intercom.IsSlotAvailable(A_Index) = True )
                return A_Index
        }
    }

    IsSlotAvailable(slotNum) {
        if ( GUI_Intercom.GetSlotContent(slotNum) = "")
            return True
        else return False
    }

    GetSlotContent(slotNum) {
        global GuiIntercom_Controls
        return GUI_Intercom.Submit("hEDIT_Slot" slotNum)
    }

    ReserveSlot(slotNum) {
        global GuiIntercom_Controls
        GuiControl, Intercom:,% GuiIntercom_Controls["hEDIT_Slot" slotNum], RESERVED
    }

    GetSlotHandle(slotNum) {
        global GuiIntercom_Controls
        return GuiIntercom_Controls["hEDIT_Slot" slotNum]
    }

    OnSlotContentChange(slotNum="", CtrlHwnd="") {
        global GuiIntercom_Controls
        _ctrl := GuiIntercom_Controls["hEDIT_Slot1"]
    
        newContent := GUI_Intercom.GetSlotContent(slotNum)
        if (newContent) {
            Loop, Parse, newContent, `n
            {
                RegExMatch(A_LoopField, "O)(.*?)\((.*)\)", match)
                fName := match.1, fParams := match.2
                split := StrSplit(fParams, ",")
                if ( split.Count() > 10 )  
                    MsgBox % "Intercom can only take up to 10 parameters, function has " split.Count()
                    . "`n" A_LoopField

                msgbox % "Func:`t" fName
                . "`nParams:`t" fParams
                . "`n`n" A_LoopField
             
                fn := Func(fName)
                bound := fn.bind(empty)
                bound.call(split.1, split.2, split.3, split.4, split.5, split.6, split.7, split.8, split.9, split.10)
            }
        }
    }

    Submit(CtrlName="") {
		global GuiIntercom_Submit
		Gui.Submit("Intercom")

		if (CtrlName) {
			Return GuiIntercom_Submit[ctrlName]
		}
	}
}
