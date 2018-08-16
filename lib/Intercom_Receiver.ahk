Intercom_Receiver() {
    Gui, ShellMsg:Destroy
    Gui, ShellMsg:New, +LastFound +HwndhGUI
    Gui, ShellMsg:Add, Edit, hwndhEdit vvEdit gGoSub
    Gui, ShellMsg:Show, NoActivate
}