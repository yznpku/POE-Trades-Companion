/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Helper																												*
*					See all the information about the trade request upon receiving a poe.trade whisper			*
*																																								*
*					https://github.com/lemasato/POE-Trades-Helper/																*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/													*
*					https://www.pathofexile.com/forum/view-thread/1755148/												*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*																																								*
*					Known issues:																														*
*						-																																		*
*																																								*
*					Future updates:																													*
*						-	More, customizable, binds																							*
*																																								*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/


OnExit("Exit_Func")
#SingleInstance Off
#SingleInstance Force ; Uncomment when using .ahk version
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8 ; Required for cyrillic characters

;___Some_Variables___;
global userprofile, iniFilePath, programName, programVersion, programFolder, programPID, sfxFolderPath, programChangelogFilePath
EnvGet, userprofile, userprofile
programVersion := "1.2.3" , programName := "POE Trades Helper", programFolder := userprofile "\Documents\AutoHotKey\" programName
iniFilePath := programFolder "\Preferences.ini"
sfxFolderPath := programFolder "\SFX"
programLogsPath := programFolder "\Logs"
programLogsFilePath := userprofile "\Documents\AutoHotKey\" programName "\Logs\" A_YYYY "-" A_MM "-" A_DD "_" A_Hour "-" A_Min "-" A_Sec ".txt"
programChangelogFilePath := programFolder "\Logs\changelog.txt"
GroupAdd, POEGame, ahk_exe PathOfExile.exe
GroupAdd, POEGame, ahk_exe PathOfExile_x64.exe
GroupAdd, POEGameSteam, ahk_exe PathOfExileSteam.exe
GroupAdd, POEGameSteam, ahk_exe PathOfExile_x64Steam.exe

;___Creating_INI_Dir___;
if !( InStr(FileExist(userprofile "\Documents"), "D") )
	FileCreateDir, % userprofile "\Documents"
if !( InStr(FileExist(userprofile "\Documents\AutoHotkey"), "D") )
	FileCreateDir, % userprofile "\Documents\AutoHotkey"
if !( InStr(FileExist(userprofile "\Documents\AutoHotkey\" programName ), "D") )
	FileCreateDir, % userprofile "\Documents\AutoHotkey\" programName
if !( InStr(FileExist(sfxFolderPath), "D") )
	FileCreateDir, % sfxFolderPath
if !( InStr(FileExist(programLogsPath), "D") )
	FileCreateDir, % programLogsPath

;___Function_Calls___;
Prevent_Multiple_Instancies()
Set_INI_Settings()
settingsArray := Get_INI_Settings()
Declare_INI_Settings(settingsArray)
Delete_Old_Logs_Files()
Create_Tray_Menu()
Do_Once()
Check_Update()

;___Hotkeys___;
hotkey1 := VALUE_HK_1
if ( VALUE_HK_1_CTRL = 1 )
	hotkey1 := "^" hotkey1
if ( VALUE_HK_1_ALT = 1 )
	hotkey1 := "!" hotkey1
if ( VALUE_HK_1_SHIFT = 1 )
	hotkey1 := "+" hotkey1
if ( VALUE_HK_1_Toggle = 1 ) {
	Hotkey,IfWinActive,ahk_group POEGame
	Hotkey,% hotkey1,Hotkey_Hideout
	Hotkey,IfWinActive,ahk_group POEGameSteam
	Hotkey,% hotkey1,Hotkey_Hideout
}

;___Window Switch Detect___;
Gui +LastFound 
Hwnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,Hwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")

ShellMessage(wParam,lParam) {
	global VALUE_Show_Mode, VALUE_Dock_Mode, guiTradesHandler, tradesGuiWidth
	WinGet, winEXE, ProcessName, ahk_id %lParam%
	if ( wParam=4 or wParam=32772 ) { ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED
;		Set the correct TradesGUI position upon activating a new window
		gameGroup := Get_Exe_From_Mode(VALUE_Dock_Mode, "VALUE_Dock_Mode")
		if ( gameGroup = "POEGame" ) {
			gameExe1 := "PathOfExile.exe", gameExe2 := "PathOfExile_x64.exe"
		}
		else if ( gameGroup = "POEGameSteam" ) {
			gameExe1 := "PathOfExileSteam.exe", gameExe2 := "PathOfExile_x64Steam.exe"
		}
		if ( VALUE_Show_Mode = "Always" ) && ( tradesGuiWidth > 0 ) || ( ( VALUE_Show_Mode = "InGame" ) && ( winExe = gameExe1 || winExe = gameExe2 ) && ( tradesGuiWidth > 0 ) ) {
			Gui_Trades_Set_Position()
		}
		else
			Gui, Trades:Show, NoActivate Hide
	}
	if WinActive("ahk_id" guiTradesHandler) {
;		Prevent keyboard presses from interacting with the tradesGUI and thus mis-clicking a button
		Hotkey, IfWinActive, ahk_id %guiTradesHandler%
		Hotkey, Space, DoNothing, On
		Hotkey, Tab, DoNothing, On
		Hotkey, Enter, DoNothing, On
		Hotkey, Left, DoNothing, On
		Hotkey, Right, DoNothing, On
		Hotkey, Up, DoNothing, On
		Hotkey, Down, DoNothing, On
	}
}

;___Logs Monitoring AKA Trades GUI___;
Logs_Append("Start")
Monitor_Game_Logs()


;==================================================================================================================
;
;																														LOGS MONITORING
;
;==================================================================================================================

Monitor_Game_Logs() {
;			Gets the logs location based on VALUE_Logs_Mode
;			Read trough the logs file for new whisper/trades
;			Pass the trade message infos to Gui_Trades()
;			Clipboard the item's info if the user enabled
;			Play a sound or tray notification (if the user enabled) on whisper/trade
	global VALUE_Whisper_Tray, VALUE_Logs_Mode, VALUE_Clip_New_Items, VALUE_Trade_Toggle, VALUE_Trade_Sound_Path, VALUE_Whisper_Toggle, VALUE_Whisper_Sound_Path, fileObj

	gameGroup := Get_Exe_From_Mode(VALUE_Logs_Mode, "VALUE_Logs_Mode")
	WinGet, exeLocation, ProcessPath, ahk_group %gameGroup%
	SplitPath, exeLocation, ,exeDir
	logsFile := exeDir "\logs\Client.txt"
	if !( WinExist("ahk_group " gameGroup) ) {
		Gui_Trades(,"exenotfound")
		Sleep 30000
		Monitor_Game_Logs()
	}
	else 
		Gui_Trades()
	
	fileObj := FileOpen(logsFile, "r")
	fileObj.pos := fileObj.length
	Loop {
		if ( fileObj.pos < fileObj.length ) {
			lastMessage := fileObj.Read() ; Stores the last message into a var
			if ( RegExMatch( lastMessage, ".*@(?:From|De|От кого) (.*?): (.*)", subPat ) ) ; Whisper found --  (.*?) makes sure to stop at the first ":", fixing the "stash tab:" error
			{
				whispName := subPat1, whispMsg := subPat2
				if ( VALUE_Whisper_Tray = 1 ) && !( WinActive("ahk_group" gameGroup) ) {
					TrayTip, Whisper Received:,%whispName%: %whispMsg%
					TrayTip, Whisper Received:,%whispName%: %whispMsg%
					if ( VALUE_Whisper_Toggle = 1 ) && ( FileExist(VALUE_Whisper_Sound_Path) )
						SoundPlay,%VALUE_Whisper_Sound_Path%
				}
				messages := whispName . ": " whispMsg "`n"
				if ( RegExMatch( messages, "Hi, I would like to buy your (.*) listed for (.*) in (.*)", subPat ) ) ; Trade message found
				{
					tradeItem := subPat1, tradePrice := subPat2, tradeStash := subPat3
					if tradeItem contains % " 0`%"
						StringReplace, tradeItem, tradeItem, 0`%
					messagesArray := Gui_Trades_AddNewItem(whispName, tradeItem, tradePrice, tradeStash)
					Gui_Trades(messagesArray)
					if ( VALUE_Clip_New_Items = 1 )
						Clipboard := tradeitem
					if ( VALUE_Trade_Toggle = 1 ) && ( FileExist(VALUE_Trade_Sound_Path) )
						SoundPlay,%VALUE_Trade_Sound_Path%
				}
			}
		}
		sleep 500
	}
}

;==================================================================================================================
;
;																														HOTKEYS
;
;==================================================================================================================

Hotkey_HideOut:
	Hotkey_HideOut_Func()
return

Hotkey_HideOut_Func() {
;		Sends /hideout into the chat
	if WinActive("ahk_group POEGame") || WinActive("ahk_group POEGameSteam") {
		BlockInput On
		SendInput {Space}{Enter}	; Close potential opened window and open the chat
		sleep 2
		SendInput, {Space}{/}hideout{Enter}	; First space is in case the current channel is whisper and there is no space after the name
		SendInput {Enter}{Up}{Up}{Escape}	; Send back to the previous chat channel
		BlockInput Off
	}
}

;==================================================================================================================
;
;																														TRADES GUI
;
;==================================================================================================================
	
Gui_Trades(messagesArray="",errorMsg="") {
;			Trades GUI. Each new item will be added in a new tab
;			Clicking on a button will do its corresponding action
;			Switching tab will clipboard the item's infos if the user enabled
;			Is transparent and click-trough when there is no trade on queue
	global
	static tabWidth, tabHeight, tradesCount, index, element, varText, varName, tabName, trans, priceArray, btnID, Clipboard_Backup, gameGroup, itemArray, itemName, itemPrice, messageToSend
	static nameArray, buyerName
	;~ messagesArray := Object()
	;~ Loop 10
		;~ messagesArray.Insert("Name: iSellStuff`nItem: level 1 Faster Attacks Support`nPrice: 5 alteration`nLocation: Essence (stash tab ""Gems""; position: left 6, top 8)")
	Gui, Trades:Destroy
	Gui, Trades:New, +ToolWindow +AlwaysOnTop -Border +hwndGuiTradesHandler +LabelGui_Trades_ +LastFound
	Gui, Trades:Default
	tabWidth := 390, tabHeight := 180
	if (messagesArray.Length() = "" || messagesArray.Length() = "0") {
		messagesArray := Object()
		if ( errorMsg = "exenotfound" )
			messagesArray.Insert(0, "ERROR: Process not found, retrying in 30seconds...`n`nRight click on the tray icon`nthen [Settings] to set your preferences.")
		else 
			messagesArray.Insert(0, "No trade on queue!`n`nRight click on the tray icon`nthen [Settings] to set your preferences.")
		tabWidth := 325, tabHeight := 95	; Tab size is smaller when there is no item
		IniWrite,0,% iniFilePath,PROGRAM,Tabs_Number
	}
	tradesCount := messagesArray.Length()
	tabHeight := tabHeight +  18*( Floor( tradesCount/10 ) ) ; Adds 18 in height for every 10 tabs
	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		Gui, Add, Tab3,x10 y10 vTab gGui_Trades_OnTabSwitch w%tabWidth% h%tabHeight%
	else
		Gui, Add, Tab3,x10 y10 vTab gGui_Trades_OnTabSwitch w%tabWidth% h%tabHeight% -Theme
	for index, element in messagesArray 
	{
		tabName := index
		GuiControl,,Tab,%tabName%
		if ( index=0 ) { ; allows to have the "No trade in queue" on tab 0 and trades on 1,2,3...
			Gui, Tab,% index+1
			Gui, Add, Text, w300 h55 vtextSlot%index% 0x1,% element ; text is centered
		}
		else {
			Gui, Tab,% index
			Gui, Add, Text, w300 vtextSlot%index%,% element
		}
		if ( index > 0 ) {
			Gui, Add, Button,w110 h35 x20 yp+65 vcopyBtn%index% -Theme +0x8000 gGui_Trades_CopyItemName,% "Clipboard`nitem infos"
			Gui, Add, Button,w111 h35 x147 yp vwaitBtn%index% -Theme +0x8000 gGui_Trades_Wait,% "  Message`none moment"
			Gui, Add, Button,w110 h35 x275 yp vinviteBtn%index% -Theme +0x8000 gGui_Trades_Invite,% " Invite`nto party"
			Gui, Add, Button,w365 h35 x20 yp+45 vthanksBtn%index% -Theme +0x8000 gGui_Trades_Thanks,% "Message thank you`n  and close this tab"
			Gui, Add, Button,w20 h20 x370 yp-110 vdelBtn%index% -Theme +0x8000 gGui_Trades_RemoveItem,% "X"
		}
		else {
			IniRead, trans,% iniFilePath,SETTINGS,Transparency
			Gui, Trades: +E0x20 
			WinSet, Transparent, %trans%
		}
		IniWrite,%index%,% iniFilePath,PROGRAM,Tabs_Number
	}
	Gui, Show, NoActivate Hide AutoSize
	sleep 100
	Gui_Trades_Set_Position()
	return
	
	Gui_Trades_OnTabSwitch:
;		Clipboard the item's infos on tab switch if the user enabled
		Gui, Submit, NoHide
		btnID := %A_GuiControl%
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Clip_On_Tab_Switch = 1 )
			Clipboard := tradesInfosArray[1]
	return

	Gui_Trades_RemoveItem:
;		Remove the current tab
		messagesArray := Gui_Trades_RemoveItemFunc()
		Gui_Trades(messagesArray)
	return
	
	Gui_Trades_CopyItemName:
;		Clipboard the item's infos
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		Clipboard := tradesInfosArray[1]
	return
	
	Gui_Trades_Wait:
;		Send a message asking to wait
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Wait_Text_Toggle = 1 )
			Send_InGame_Message(VALUE_Wait_Text, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2])
	return
	
	Gui_Trades_Invite:
;		Send a message and invite the player to the party
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Invite_Text_Toggle = 1 )
			Send_InGame_Message(VALUE_Invite_Text, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2])
		Send_InGame_Message("/invite " tradesInfosArray[0])
	return
	
	Gui_Trades_Thanks:
;		Send a message to the player and close the tab
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Thanks_Text_Toggle = 1 )
			Send_InGame_Message(VALUE_Thanks_Text, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2])
		GoSub, Gui_Trades_RemoveItem
	return
	
	Gui_Trades_Size:
;		Declare the gui width and height
		tradesGuiWidth := A_GuiWidth
		tradesGuiHeight := A_GuiHeight
	return
}

Gui_Trades_Get_Tab_ID(controlName){
	GuiControlGet, varName, Trades:Name, %controlName%
	btnID := RegExReplace(varName, "\D")
	return btnID
}

Gui_Trades_Get_Trades_Infos(btnID){
	GuiControlGet, varText, ,textSlot%btnID%
	RegExMatch( varText, "Item: (.*)", subPat )
	itemArray := StrSplit(subPat1, "`n"), itemName := itemArray[1]
	RegExMatch( varText, "Name: (.*)", subPat )
	nameArray := StrSplit(subPat1, "`n"), buyerName := nameArray[1]
	RegExMatch( varText, "Price: (.*)", subPat )
	priceArray := StrSplit(subPat1, "`n"), itemPrice := priceArray[1]
	buyerName := Gui_Trades_RemoveGuildPrefix(buyerName)
	returnArray := Object()
	returnArray.Insert(0, buyerName, itemName, itemPrice)
	return returnArray
}

Gui_Trades_RemoveItemFunc() {
;			Remove the item from the list by re-creating the array
;			Return the newly arranged array
	GuiControlGet, varName, Trades:Name, %A_GuiControl%
	btnID := RegExReplace(varName, "\D")
	GuiControlGet, varText, ,textSlot%btnID%
	returnArray := Object()
	Loop {
		if ( A_Index < btnID )
			counter := A_Index
		else if ( A_Index >= btnID )
			counter := A_Index+1
		GuiControlGet, content, ,textSlot%counter%
		if ( content )
			returnArray.Insert(A_Index, content)
		else	break
	}
	return returnArray
}	

Gui_Trades_AddNewItem(name, item, price, location) {
;			Add a new item to the list by appening it to the array
;			Return the newly arranged array
	returnArray := Object()
	Loop {
		count := A_Index
		GuiControlGet, content, ,textSlot%A_Index%
		if ( content ) {
			returnArray.Insert(A_Index, content)
		}
		else break
	}
	name := Gui_Trades_RemoveGuildPrefix(name)
	newItem := "Name: " . name . "`n" . "Item: " item . "`n" . "Price: " price . "`n" . "Location: " location
	returnArray.Insert(count, newItem)
	return returnArray
}

Gui_Trades_RemoveGuildPrefix(name) {
;			Remove the guild prefix
	AutoTrim, On
	RegExMatch(name, "<.*>(.*)", namePat) ; name contains guild prefix, remove it
	if ( namePat1 )
		name := namePat1
	name = %name% ; Removes whitespaces
	return name
}

Gui_Trades_Set_Position(){
;			Refresh the Trades GUI position
	global VALUE_Dock_Mode, tradesGuiWidth, tradesGuiHeight, GuiTradesHandler
	
	gameGroup := Get_Exe_From_Mode(VALUE_Dock_Mode, "VALUE_Dock_Mode")
	dpiFactor := Get_DPI_Factor()
	
	if ( WinExist("ahk_group " gameGroup ) ) {
		WinGetPos, winX, winY, winWidth, winHeight, ahk_group %gameGroup%
		xpos := ( (winX+winWidth)-tradesGuiWidth * dpiFactor ) -14
		if xpos is not number
			xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor ) - 6
		if ypos is not number
			ypos := 0
		Gui, Trades:Show, % "x" xpos " y" winY " NoActivate"
	}
	else {
		xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor ) - 6
		Gui, Trades:Show, % "x" xpos " y0" " NoActivate"
	}
}

;==================================================================================================================
;
;																														SETTINGS GUI
;
;==================================================================================================================

Gui_Settings() {
	static
	iniFile := iniFilePath
	global hotkey1Handler
	
	helpstate := 0
	Gui, Settings:Destroy
	Gui, Settings:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_Settings_ hwndSettingsHandler,% programName " - Settings"
	Gui, Settings:Default
	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		Gui, Add, Tab3, vTab x10 y10,Settings|Messages
	else
		Gui, Add, Tab3, vTab x10 y10 -Theme,Settings|Messages
	Gui, Tab, Settings
;	Settings Tab
;		Trades GUI
		Gui, Add, GroupBox, x20 y40 w200 h260,Trades GUI
		Gui, Add, Radio, x30 yp+20 vShowAlways hwndShowAlwaysHandler,Always show
		Gui, Add, Radio, x30 yp+15 vShowInGame hwndShowInGameHandler,Only show while in game
		Gui, Add, Text, x52 yp+20,Transparency
		Gui, Add, Text, x30 yp+15,when no trade is on queue
		Gui, Add, Slider, x30 yp+15 hwndShowTransparencyHandler gGui_Settings_Transparency vShowTransparency AltSubmit ToolTip Range0-100
;		Docking
		Gui, Add, Text, x30 y165,Dock the GUI to:
		Gui, Add, Radio, x30 yp+20 vDockGGG hwndDockGGGHandler,GGG
		Gui, Add, Radio, x30 yp+15 vDockSteam hwndDockSteamHandler,Steam
;		Logs
		Gui, Add, Text, x30 y230,Logs File:
		Gui, Add, Radio, x30 yp+20 vLogsGGG hwndLogsGGGHandler,GGG
		Gui, Add, Radio, x30 yp+15 vLogsSteam hwndLogsSteamHandler,Steam
;		Hotkeys
		Gui, Add, GroupBox, x230 y40 w200 h70,Hotkeys
		Gui, Add, Checkbox, x240 yp+20 hwndHotkey1ToggleHandler vHotkey1Toggle,/hideout
		Gui, Add, Hotkey, x300 yp-3 w100 hwndHotkey1Handler vHotkey1 gGui_Settings_Hotkeys
		Gui, Add, Checkbox, x240 yp+28 hwndHotkey1CTRLHandler vHotkey1CTRL,CTRL
		Gui, Add, Checkbox, x290 yp hwndHotkey1ALTHandler vHotkey1ALT,ALT
		Gui, Add, Checkbox, x332 yp hwndHotkey1SHIFTHandler vHotkey1SHIFT,SHIFT
;		Notifications
;			Trade Sound Group
			Gui, Add, GroupBox, x230 y120 w200 h110,Notifications
			Gui, Add, Checkbox, x240 yp+20 vNotifyTradeToggle hwndNotifyTradeToggleHandler,Trade
			Gui, Add, Edit, x300 yp-2 w70 h17 vNotifyTradeSound hwndNotifyTradeSoundHandler ReadOnly
			Gui, Add, Button, x375 yp-2 h20 vNotifyTradeBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Sound Group
			Gui, Add, Checkbox, x240 y165 vNotifyWhisperToggle hwndNotifyWhisperToggleHandler,Whisper
			Gui, Add, Edit, x300 yp-2 w70 h17 vNotifyWhisperSound hwndNotifyWhisperSoundHandler ReadOnly
			Gui, Add, Button, x375 yp-2 h20 vNotifyWhisperBrowse gGui_Settings_Notifications_Browse,Browse
			Gui, Add, Checkbox, x240 yp+24 vNotifyWhisperTray hwndNotifyWhisperTrayHandler,Tray notifications for whispers`n when POE is not active.
;		Clipboard
		Gui, Add, GroupBox, x230 y240 w200 h60,Clipboard
		Gui, Add, Checkbox, x240 yp+20 hwndClipNewHandler vClipNew,Clipboard new items
		Gui, Add, Checkbox, x240 yp+15 hwndClipTabHandler vClipTab,Clipboard item on tab switch
;		Apply Button
		Gui, Add, Button, x20 y310 w320 h30 gGui_Settings_Btn_Apply vApplyBtn,Apply Settings
		Gui, Add, Button, x340 yp h30 w90 hwndHelpBtnHandler vHelpBtn gGui_Settings_Btn_Help,Help? (OFF)
	
;	Message Tab
	Gui, Tab, Messages
;		Top message
		Gui, Add, Text, x20 y40,Use these variables in your message to specify the infos about the item:
		Gui, Add, Text, x30 yp+15,`%buyerName`% %A_Tab%%A_Tab% Contains the buyer's name
		Gui, Add, Text, x30 yp+15,`%itemName`% %A_Tab%%A_Tab% Contains the item's name
		Gui, Add, Text, x30 yp+15,`%itemPrice`% %A_Tab%%A_Tab% Contains the item's price
;		One moment button
		Gui, Add, Text, x20 y120,"Message one moment" button:
		Gui, Add, CheckBox, x20 yp+20 vMessageWaitToggle hwndMessageWaitToggleHandler, 
		Gui, Add, Edit, x45 yp-3 w390 vMessageWait hwndMessageWaitHandler
;		Invite to party button
		Gui, Add, Text, x20 y170,"Invite to party" button:
		Gui, Add, CheckBox, x20 yp+20 vMessageInviteToggle hwndMessageInviteToggleHandler, 
		Gui, Add, Edit, x45 yp-3 w390 vMessageInvite hwndMessageInviteHandler
;		Thanks button
		Gui, Add, Text, x20 y220,"Message thank you" button:
		Gui, Add, CheckBox, x20 yp+20 vMessageThanksToggle hwndMessageThanksToggleHandler, 
		Gui, Add, Edit, x45 yp-3 w390 vMessageThanks hwndMessageThanksHandler
;		Apply Button
		Gui, Add, Button, x20 y310 w320 h30 gGui_Settings_Btn_Apply vApplyBtn2,Apply Settings
		Gui, Add, Button, x340 yp h30 w90 hwndHelpBtnHandler2 vHelpBtn2 gGui_Settings_Btn_Help,Help? (OFF)
	GuiControl, Choose, Tab, 1
	GoSub Gui_Settings_Set_Preferences
	Gui, Show, NoActivate
	sleep 100
	return
	
	Gui_Settings_Transparency:
	;	Set the transparency
		Gui, Settings: Submit, NoHide
		trans := ( ShowTransparency / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		Gui, Trades: +LastFound
		WinSet, Transparent,% trans
	return
	
	Gui_Settings_Btn_Help:
		if ( helpState = 0 ) {
			OnMessage(0x200,"WM_MOUSEMOVE", 1)
			GuiControl, Settings:,% HelpBtnHandler,Help? (ON)
			GuiControl, Settings:,% HelpBtnHandler2,Help? (ON)
			helpState := 1
		}
		else {
			OnMessage(0x200,"WM_MOUSEMOVE", 0)
			GuiControl, Settings:,% HelpBtnHandler,Help? (OFF)
			GuiControl, Settings:,% HelpBtnHandler2,Help? (OFF)
			helpState := 0
			Tooltip,
		}
	return
	
	Gui_Settings_Close:
		Gui, Settings: Submit
		Gui, Settings: +OwnDialogs
		OnMessage(0x200,"WM_MOUSEMOVE", 0)
		IniRead, tabsNumber,% iniFile,PROGRAM,Tabs_Number
		if ( tabsNumber > 0 ) {
			Gui, Trades: +LastFound
			WinSet, Transparent,255
		}
		MsgBox,4,% programName " - Settings",% programName " needs to be reloaded`nin order to take the new settings in count!`n`nWould you like to reload now?`n(You may also manually reload using the [Reload] tray option)"
		IfMsgBox Yes
			Reload_Func()
		Gui, Settings: Destroy
	return
	
	Gui_Settings_Notifications_Browse:
		FileSelectFile, soundFile, ,% sfxFolderPath, Select an audio file (%programName%),Audio (*.wav; *.mp3)
		if ( soundFile ) {
			SplitPath, soundFile, soundFileName
			if ( A_GuiControl = "NotifyTradeBrowse" ) {
				GuiControl, Settings:,% NotifyTradeSoundHandler,% soundFileName
				tradesSoundFile := soundFile
			}
			if ( A_GuiControl = "NotifyWhisperBrowse" ) {
				GuiControl, Settings:,% NotifyWhisperSoundHandler,% soundFileName
				whispersSoundFile := soundFile
			}
		}
	return
	
	Gui_Settings_Hotkeys:
		Gui, +OwnDialogs
		thisControl := A_GuiControl
		hotkeyHandler := %thisControl%Handler
		GuiControlGet, strHotkey, ,% hotkeyHandler
		if strHotKey contains ^,!,+ ; Prevent modifier keys from slipping trough
			GuiControl, Settings: ,% hotkeyHandler, None
	return
	
	Gui_Settings_Btn_Apply:
		Gui, +OwnDialogs
		Gui, Submit, NoHide
;	Trades GUI
		trans := ( ShowTransparency / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		IniWrite,% trans,% iniFile,SETTINGS,Transparency
		showMode := ( ShowAlways = 1 ) ? ( "Always" ) : ( ShowInGame = 1 ) ? ( "InGame" ) : ( "Always" )
		IniWrite,% showMode,% iniFile,SETTINGS,Show_Mode
		dockMode := ( DockSteam = 1 ) ? ( "Steam" ) : ( DockGGG = 1 ) ? ( "GGG" ) : ( "" )
		IniWrite,% dockMode,% iniFile,SETTINGS,Dock_Mode
		logsMode := ( LogsSteam = 1 ) ? ( "Steam" ) : ( LogsGGG = 1 ) ? ( "GGG" ) : ( "" )
		IniWrite,% logsMode,% iniFile,SETTINGS,Logs_Mode
;	Clipboard	
		IniWrite,% ClipNew,% iniFile,AUTO_CLIP,Clip_New_Items
		IniWrite,% ClipTab,% iniFile,AUTO_CLIP,Clip_On_Tab_Switch
;	Hotkeys
;		/hideout
		IniWrite,% Hotkey1Toggle,% iniFile,HOTKEYS,HK_1_Toggle
		IniWrite,% Hotkey1,% iniFile,HOTKEYS,HK_1
		IniWrite,% Hotkey1CTRL,% iniFile,HOTKEYS,HK_1_CTRL
		IniWrite,% Hotkey1ALT,% iniFile,HOTKEYS,HK_1_ALT
		IniWrite,% Hotkey1SHIFT,% iniFile,HOTKEYS,HK_1_SHIFT
;	Notifications
		IniWrite,% NotifyTradeToggle,% iniFile,NOTIFICATIONS,Trade_Toggle
		IniWrite,% NotifyTradeSound,% iniFile,NOTIFICATIONS,Trade_Sound
		if ( tradesSoundFile )
			IniWrite,% tradesSoundFile,% iniFile,NOTIFICATIONS,Trade_Sound_Path
		IniWrite,% NotifyWhisperToggle,% iniFile,NOTIFICATIONS,Whisper_Toggle
		IniWrite,% NotifyWhisperSound,% iniFile,NOTIFICATIONS,Whisper_Sound
		if ( whispersSoundFile )
		IniWrite,% whispersSoundFile,% iniFile,NOTIFICATIONS,Whisper_Sound_Path
		IniWrite,% NotifyWhisperTray,% iniFile,NOTIFICATIONS,Whisper_Tray
;	Messages
;		Wait
		IniWrite,% MessageWaitToggle,% iniFile,MESSAGES,Wait_Text_Toggle
		IniWrite,% MessageWait,% iniFile,MESSAGES,Wait_Text
;		Party
		IniWrite,% MessageInviteToggle,% iniFile,MESSAGES,Invite_Text_Toggle
		IniWrite,% MessageInvite,% iniFile,MESSAGES,Invite_Text
;		Thanks
		IniWrite,% MessageThanksToggle,% iniFile,MESSAGES,Thanks_Text_Toggle
		IniWrite,% MessageThanks,% iniFile,MESSAGES,Thanks_Text
	return

	Gui_Settings_Size:
		GuiWidth := A_GuiWidth
		GuiHeight := A_GuiHeight
		sleep 10
	return
	
	Gui_Settings_Set_Preferences:
;	Trades GUI
		returnArray := Gui_Settings_Get_Settings_Arrays()
		sectionArray := returnArray.sectionArray
		SETTINGS_HandlersArray := returnArray.SETTINGS_HandlersArray
		SETTINGS_HandlersKeysArray := returnArray.SETTINGS_HandlersKeysArray
		AUTO_CLIP_HandlersArray := returnArray.AUTO_CLIP_HandlersArray
		AUTO_CLIP_HandlersKeysArray := returnArray.AUTO_CLIP_HandlersKeysArray
		HOTKEYS_HandlersArray := returnArray.HOTKEYS_HandlersArray
		HOTKEYS_HandlersKeysArray := returnArray.HOTKEYS_HandlersKeysArray
		NOTIFICATIONS_HandlersArray := returnArray.NOTIFICATIONS_HandlersArray
		NOTIFICATIONS_HandlersKeysArray := returnArray.NOTIFICATIONS_HandlersKeysArray
		MESSAGES_HandlersArray := returnArray.MESSAGES_HandlersArray
		MESSAGES_HandlersKeysArray := returnArray.MESSAGES_HandlersKeysArray

		for key, element in sectionArray
		{
			sectionName := element
			for key, element in %sectionName%_HandlersKeysArray
			{
				keyName := element
				handler := %sectionName%_HandlersArray[key]
				IniRead, var,% iniFile,% sectionName,% keyName
				if ( keyName = "Show_Mode" ) { ; Make sure only one goes trough
					GuiControl, Settings:,% Show%var%Handler,1
				}
				else if ( keyName = "Dock_Mode" ) { ; Make sure only one goes trough
					GuiControl, Settings:, % Dock%var%Handler,1
				}
				else if ( keyName = "Transparency" ) { ; Convert to pecentage
					var := ((var - 0) * 100) / (255 - 0)
					GuiControl, Settings:,% %handler%Handler,% var
				}
				else if ( keyName = "Logs_Mode" ) { ; Make sure only one goes trough
					GuiControl, Settings:,% Logs%var%Handler,1
				}
				else if ( var != "ERROR" && var != "" ) { ; Everything else
					handler := %sectionName%_HandlersArray[key]
					GuiControl, Settings:,% %handler%Handler,% var
				}
			}
		}
	return
}

Gui_Settings_Get_Settings_Arrays() {
;			Contains all the section/handlers/keys/defaut values for the Settings GUI
;			Return an array containing all those informations
	returnArray := Object()
	returnArray.sectionArray := Object() ; contains all the .ini SECTIONS
	returnArray.sectionArray.Insert(0, "SETTINGS", "AUTO_CLIP", "HOTKEYS", "NOTIFICATIONS", "MESSAGES")
	
	returnArray.SETTINGS_HandlersArray := Object() ; contains all the Gui_Settings HANDLERS from this SECTION
	returnArray.SETTINGS_HandlersArray.Insert(0, "ShowAlways", "ShowInGame", "ShowTransparency", "DockSteam", "DockGGG", "LogsSteam", "LogsGGG")
	returnArray.SETTINGS_HandlersKeysArray := Object() ; contains all the .ini KEYS for those HANDLERS
	returnArray.SETTINGS_HandlersKeysArray.Insert(0, "Show_Mode", "Show_Mode", "Transparency", "Dock_Mode", "Dock_Mode", "Logs_Mode", "Logs_Mode")
	returnArray.SETTINGS_KeysArray := Object() ; contains all the individual .ini KEYS
	returnArray.SETTINGS_KeysArray.Insert(0, "Show_Mode", "Transparency", "Dock_Mode", "Logs_Mode")
	returnArray.SETTINGS_DefaultValues := Object() ; contains all the DEFAULT VALUES for the .ini KEYS
	returnArray.SETTINGS_DefaultValues.Insert(0, "Always", "150", "GGG", "GGG")
	
	returnArray.AUTO_CLIP_HandlersArray := Object()
	returnArray.AUTO_CLIP_HandlersArray.Insert(0, "ClipNew", "ClipTab")
	returnArray.AUTO_CLIP_HandlersKeysArray := Object()
	returnArray.AUTO_CLIP_HandlersKeysArray.Insert(0, "Clip_New_Items", "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_KeysArray := Object()
	returnArray.AUTO_CLIP_KeysArray.Insert(0, "Clip_New_Items", "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_DefaultValues := Object()
	returnArray.AUTO_CLIP_DefaultValues.Insert(0, "1", "1")
	
	returnArray.HOTKEYS_HandlersArray := Object()
	returnArray.HOTKEYS_HandlersArray.Insert(0, "Hotkey1Toggle", "Hotkey1", "Hotkey1CTRL", "Hotkey1ALT", "Hotkey1SHIFT")
	returnArray.HOTKEYS_HandlersKeysArray := Object()
	returnArray.HOTKEYS_HandlersKeysArray.Insert(0, "HK_1_Toggle", "HK_1", "HK_1_CTRL", "HK_1_ALT", "HK_1_SHIFT")
	returnArray.HOTKEYS_KeysArray := Object()
	returnArray.HOTKEYS_KeysArray.Insert(0, "HK_1_Toggle", "HK_1", "HK_1_CTRL", "HK_1_ALT", "HK_1_SHIFT")
	returnArray.HOTKEYS_DefaultValues := Object()
	returnArray.HOTKEYS_DefaultValues.Insert(0, "1", "F2", "0", "0", "0")
	
	returnArray.NOTIFICATIONS_HandlersArray := Object()
	returnArray.NOTIFICATIONS_HandlersArray.Insert(0, "NotifyTradeToggle", "NotifyTradeSound", "NotifyWhisperToggle", "NotifyWhisperSound", "NotifyWhisperTray")
	returnArray.NOTIFICATIONS_HandlersKeysArray := Object()
	returnArray.NOTIFICATIONS_HandlersKeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Whisper_Toggle", "Whisper_Sound", "Whisper_Tray")
	returnArray.NOTIFICATIONS_KeysArray := Object()
	returnArray.NOTIFICATIONS_KeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Trade_Sound_Path", "Whisper_Toggle", "Whisper_Sound", "Whisper_Sound_Path", "Whisper_Tray")
	returnArray.NOTIFICATIONS_DefaultValues := Object()
	returnArray.NOTIFICATIONS_DefaultValues.Insert(0, "1", "WW_MainMenu_Letter.wav", sfxFolderPath "\WW_MainMenu_Letter.wav", "0", "None", "", "1")
	
	returnArray.MESSAGES_HandlersArray := Object()
	returnArray.MESSAGES_HandlersArray.Insert(0, "MessageWaitToggle", "MessageWait", "MessageInviteToggle","MessageInvite", "MessageThanksToggle","MessageThanks")
	returnArray.MESSAGES_HandlersKeysArray := Object()
	returnArray.MESSAGES_HandlersKeysArray.Insert(0, "Wait_Text_Toggle", "Wait_Text", "Invite_Text_Toggle", "Invite_Text", "Thanks_Text_Toggle", "Thanks_Text")
	returnArray.MESSAGES_KeysArray := Object()
	returnArray.MESSAGES_KeysArray.Insert(0, "Wait_Text_Toggle", "Wait_Text", "Invite_Text_Toggle", "Invite_Text", "Thanks_Text_Toggle", "Thanks_Text")
	returnArray.MESSAGES_DefaultValues := Object()
	returnArray.MESSAGES_DefaultValues.Insert(0, "1", "@%buyerName% One moment please! (%itemName% // %itemPrice%)", "1", "@%buyerName% Your item is ready to be picked up at my hideout! (%itemName% // %itemPrice%)", "1", "@%buyerName% Thank you, good luck & have fun!")
	
	return returnArray
}

Get_Control_ToolTip(controlName) {
;			Retrieves the tooltip for the corresponding control
;			Return a variable conaining the tooltip content
	ShowAlways_TT := "Decide when should the GUI show."
	. "`nAlways show:" A_Tab . A_Tab "The GUI will always appear."
	. "`nOnly show while in game:" A_Tab "The GUI will only appear when the game's window is active."
	ShowInGame_TT := ShowAlways_TT
	ShowTransparency_TT := "The GUI is click-trough when it is inactive."
	. "`n"
	. "`nTransparency of the GUI when no trade is on queue."
	. "`nWhile moving the slider, you can see a preview of the result."
	
	DockGGG_TT := "Mostly used when running two instancies, one being your shop and the other your main account"
	. "`nIf you run only one instancie of the game, make sure that both settings are set to the same PoE executable."
	. "`nWhen the window is not found, it will default on the top right of your primary monitor"
	. "`n"
	. "`nDecide on which window should the GUI dock to."
	. "`nGGG:" A_Tab "Dock the GUI to GGG'executable."
	. "`nSteam:" A_Tab "Dock the GUI to Steam's executable."
	DockSteam_TT := DockGGG_TT
	
	LogsGGG_TT := "Mostly used when running two instancies, one being your shop and the other your main account"
	. "`nIf you run only one instancie of the game, make sure that both settings are set to the same PoE executable."
	. "`n"
	. "`nDecide which log file should be read."
	. "`nGGG:" A_Tab "Dock the GUI to GGG'executable."
	. "`nSteam:" A_Tab "Dock the GUI to Steam's executable."
	LogsSteam_TT := LogsGGG_TT
	
	Hotkey1Toggle_TT := "Pressing this key will send you to your hideout."
	. "`nTick the hotkey's case to enable it."
	. "`nTick the modifier's case if you'd like to use them."
	Hotkey1_TT := Hotkey1Toggle_TT
	Hotkey1CTRL_TT := Hotkey1_TT
	Hotkey1ALT_TT := Hotkey1_TT
	Hotkey1SHIFT_TT := Hotkey1_TT
	
	NotifyTradeToggle_TT := "Play a sound when you receive a trade message."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	NotifyTradeSound_TT := NotifyTradeToggle_TT
	NotifyTradeBrowse_TT := NotifyTradeToggle_TT
	
	NotifyWhisperToggle_TT := "Play a sound when you receive a whisper message."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	NotifyWhisperSound_TT := NotifyWhisperToggle_TT
	NotifyWhisperBrowse_TT := NotifyWhisperToggle_TT
	
	NotifyWhisperTray_TT := "Show a tray notification when you receive a"
	. "`nwhisper while the game window is not active."
	
	ClipNew_TT := "Automatically put an item's infos in clipboard"
	. "`nso you can easily ctrl+f ctrl+v in your stash to search for the item."
	. "`n"
	. "`nClipboard new items:" A_Tab . A_Tab "New trade item will be placed in clipboard."
	. "`nClipboard item on tab switch:" A_Tab "Active tab's item will be placed on clipboard."
	ClipTab_TT := ClipNew_TT
	
	HelpBtn_TT := "Hover controls to get infos about their function."
	HelpBtn2_TT := HelpBtn_TT
	ApplyBtn_TT := "Do not forget that the game needs to be in ""Windowed"" or ""Windowed Fullscreen"" for the GUI to work!"
	ApplyBtn2_TT := ApplyBtn_TT
	
	MessageWait_TT := "Message that will be sent upon clicking the ""Message one moment"" button."
	. "`nTick the case to enable."
	. "`nIf you wish to reset the message to default, delete its content and reload " programName "."
	MessageWaitToggle_TT := MessageWait_TT
	
	MessageInvite_TT := "Message that will be sent upon clicking the ""Invite to party"" button."
	. "`nTick the case to enable."
	. "`nIf you wish to reset the message to default, delete its content and reload " programName "."
	MessageInviteToggle_TT := MessageInvite_TT
	
	MessageThanks_TT := "Message that will be sent upon clicking the ""Message thank you and close this tab"" button."
	. "`nTick the case to enable."
	. "`nIf you wish to reset the message to default, delete its content and reload " programName "."
	MessageThanksToggle_TT := MessageThanks_TT
	
	controlTip := % %controlName%_TT
	;~ if ( controlTip ) 
		;~ return controlTip
	;~ else 
		;~ controlTip := controlName ; Used to get the control tooltip
	return controlTip
}

;==================================================================================================================
;
;																														UPDATE GUI
;
;==================================================================================================================

Check_Update() {
;			It works by downloading both the new version and the auto-updater
;			then closing the current instancie and renaming the new version
	static
	global programFolder, programChangelogFilePath
	
	updaterPath := "poe_trades_helper_updater.exe"
	updaterDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Helper/master/Updater.exe"
	versionDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Helper/master/version.txt"
	changelogDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Helper/master/changelog.txt"
	
;	Delete files remaining from updating
	if (FileExist(updaterPath))
		FileDelete,% updaterPath
	if (FileExist("poe_trades_helper_newversion.exe"))
		FileDelete,% "poe_trades_helper_newversion.exe"
	
;	Retrieve the changelog file and update the local file if required
	ComObjError(0)
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", changelogDL, true)
	whr.Send()
	; Using 'true' above and the call below allows the script to r'emain responsive.
	whr.WaitForResponse(10) ; 10 seconds
	changelogText := whr.ResponseText
	changelogText = %changelogText%
	if ( changelogText != "" ) && !(RegExMatch(changelogText, "NotFound")) && !(RegExMatch(changelogText, "404: Not Found")) {
		FileRead, changelogLocal,% programChangelogFilePath
		if ( changelogLocal != changelogText ) {
			FileDelete, % programChangelogFilePath
			UrlDownloadToFile, % changelogDL,% programChangelogFilePath
		}
	}
	
;	Retrieve the version number
	ComObjError(0)
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", versionDL, true)
	whr.Send()
	; Using 'true' above and the call below allows the script to remain responsive.
	whr.WaitForResponse(10) ; 10 seconds
	versionNumber := whr.ResponseText
	if ( versionNumber != "" ) && !(RegExMatch(versionNumber, "NotFound")) && !(RegExMatch(versionNumber, "404: Not Found")) {
		newVersion := versionNumber
		StringReplace, newVersion, newVersion, `n,,1 ; remove the 2nd white line
		newVersion = %newVersion% ; remove any whitespace
	}
	else
		newVersion := programVersion ; couldn't reach the file, cancel update
	if ( programVersion != newVersion )
		Gui_Update(newVersion, updaterPath, updaterDL)
}

Gui_Update(newVersion, updaterPath, updaterDL) {
	static
	IniRead, auto,% iniFilePath,PROGRAM,AutoUpdate
	if ( auto = 1 ) {
		GoSub Gui_Update_Accept
		return
	}
	Gui, Update:Destroy
	Gui, Update:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +HwndUpdateGuiHwnd,% "Update! v" newVersion " - " programName
	Gui, Update:Default
	Gui, Add, Text, x70 y10 ,Would you like to update now?
	Gui, Add, Text, x10 y30,The process is automatic, only your permission is required.
	Gui, Add, Button, x10 y55 w135 h35 gGui_Update_Accept,Accept
	Gui, Add, Button, x145 y55 w135 h35 gGui_Update_Refuse,Refuse
	Gui, Add, Button, x10 y95 w270 h40 gGui_Update_Open_Page,Open the download page ; Open download page
	Gui, Add, CheckBox, x10 y150 vautoUpdate,Update automatically from now ; Update automatically...
	Gui, Show, 
	WinWait, ahk_id %UpdateGuiHwnd%
	WinWaitClose, ahk_id %UpdateGuiHwnd%
	return
	
	Gui_Update_Accept:
;		Downlaod the updater that will handle the updating process
		Gui, Submit
		if ( autoUpdate )
			IniWrite, 1,% iniFilePath,PROGRAM,AutoUpdate
		IniWrite,% A_ScriptName,% iniFilePath,PROGRAM,FileName
		UrlDownloadToFile,% updaterDL,% updaterPath
		sleep 1000
		Run, % updaterPath
		Process, close, %programPID%
		OnExit("Exit_Func", 0)
		ExitApp
	return
	
	Gui_Update_Refuse:
		Gui, Submit
		if ( autoUpdate )
			IniWrite, 1,% iniFilePath,PROGRAM,AutoUpdate
	return

	Gui_Update_Open_Page:
		Gui, Submit
		Run, % "https://github.com/lemasato/POE-Trades-Helper/releases"
	return
}

;==================================================================================================================
;
;																														ABOUT GUI
;
;==================================================================================================================

Gui_About() {
	static
	global programChangelogFilePath
	Gui, About:Destroy
	Gui, About:New, +HwndaboutGuiHandler +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs,% programName " by masato - " programVersion
	Gui, About:Default
	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		Gui, Add, Tab3,x10 y10 vTab hwndTabHandler h190 w425,About|Changelogs
	else
		Gui, Add, Tab3,x10 y10 vTab hwndTabHandler -Theme
	Gui, Tab, 1
		Gui, Add, Text, x20 y40 ,Hello, thank you for using %programName%!
		Gui, Add, Text, xp yp+15 h50,It allows you to keep at sight your trade requests!
		Gui, Add, Text, xp yp+20 h50,Upon receiving a typical whisper from poe.trade, a new tab will appear containing:
		Gui, Add, Text, xp yp+15 ,The buyer's name, the item, the price listed, and the league/stash tab.
		Gui, Add, Text, xp yp+15 ,Several buttons will let you invite/message the person.
		Gui, Add, Text, xp yp+20,If you would like to change your preferences, head over the [Settings] tray menu.
		Gui, Add, Text, xp yp+30,See on:
		Gui, Add, Link, xp yp+15,% "<a href=""https://github.com/lemasato/POE-Trades-Helper/"">GitHub</a> - "
		Gui, Add, Link, xp+45 yp,% "<a href=""https://www.reddit.com/r/pathofexile/comments/57oo3h/"">Reddit</a> - "
		Gui, Add, Link, xp+45 yp,% "<a href=""https://www.pathofexile.com/forum/view-thread/1755148/"">GGG</a>"
		if !( FileExist( A_Temp "\poethpp.png" ) ) {
			UrlDownloadToFile, % "https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif", % A_Temp "\poethpp.png"
			if ( ErrorLevel )
				Gui, Add, Button, x350 yp-2 gGui_About_Donate hwnddonateHandler,Donations
		}
		Gui, Add, Picture, x350 yp gGui_About_Donate hwnddonateHandler,% A_Temp "\poethpp.png"
	
	Gui, Tab, 2
		FileRead, changelogText,% programChangelogFilePath
		allChanges := Object()
		Loop {
			if RegExMatch(changelogText, "sm)\\\\.*?--(.*?)--(.*?)//(.*)", subPat) {
				version%A_Index% := subPat1, changes%A_Index% := subPat2, changelogText := subPat3
				StringReplace, changes%A_Index%, changes%A_Index%,`n,% "",0
				
				allVersions .= version%A_Index% "|"
				allChanges.Insert(changes%A_Index%)
			}
		else
			break
		}
		Gui, Add, DropDownList, gVersion_Change AltSubmit vVerNum hwndVerNumHandler,%allVersions%
		Gui, Add, Edit, vChangesText hwndChangesTextHandler w395 h150 ReadOnly,An internet connection is required
		GuiControl, Choose,%VerNumHandler%,1
		GoSub, Version_Change
	Gui, Show, AutoSize NoActivate
	
	IniRead, state,% iniFilePath,PROGRAM,Show_Changelogs
	if ( state = 1 ) {
		GuiControl,About:Choose,%tabHandler%,2
		IniWrite, 0,% iniFilePath,PROGRAM,Show_Changelogs
	}
	return
	
	Version_Change:
		Gui, Submit, NoHide
		GuiControl, ,%ChangesTextHandler%,% allChanges[verNum]
		Gui, Show, AutoSize
	return
	
	Gui_About_Donate:
		Run, % "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7UXGQVX6WW3GW"
	return
}

;==================================================================================================================
;
;																														INI SETTINGS
;
;==================================================================================================================

Get_INI_Settings() {
;			Retrieve the INI settings
;			Return a big array containing arrays for each section containing the keys and their values
	iniFile := iniFilePath
	
	returnArray := Object()
	returnArray := Gui_Settings_Get_Settings_Arrays()
	
	sectionArray := returnArray.sectionArray
	SETTINGS_KeysArray := returnArray.SETTINGS_KeysArray
	AUTO_CLIP_KeysArray := returnArray.AUTO_CLIP_KeysArray
	HOTKEYS_KeysArray := returnArray.HOTKEYS_KeysArray
	NOTIFICATIONS_KeysArray := returnArray.NOTIFICATIONS_KeysArray
	MESSAGES_KeysArray := returnArray.MESSAGES_KeysArray
	
	returnArray.KEYS := Object()
	returnArray.VALUES := Object()
	for key, element in sectionArray
	{
		sectionName := element
		for key, element in %sectionName%_KeysArray
		{
			keyName := element
			IniRead, var,% iniFile,% sectionName,% keyName
			returnArray.KEYS.Insert(keyName)
			returnArray.VALUES.Insert(var)
		}
	}
	return returnArray
} 

Set_INI_Settings(){
;			Set the default INI settings if they do not exist
	global iniFilePath
	iniFile := iniFilePath	
	
;	Set the PID and filename, used for the auto updater
	programPID := DllCall("GetCurrentProcessId")
	IniWrite,% programPID,% iniFile,PROGRAM,PID
	IniWrite,% A_ScriptName,% iniFile,PROGRAM,FileName
	IniRead, firstRun,% iniFile,PROGRAM,First_Time_Running
	if ( firstRun != 0 && firstRun != 1 && )
		IniWrite,1,% iniFile,PROGRAM,First_Time_Running
	IniRead, fixBuyer,% iniFile,PROGRAM,FIX_Add_BuyerName
	if ( fixBuyer != 0 && fixBuyer != 1 )
		IniWrite,1,% iniFile,PROGRAM,FIX_Add_BuyerName
	IniRead, showLogs,% iniFile,PROGRAM,Show_Changelogs
	if ( showLogs != 0 && showLogs != 1 )
		IniWrite, 0,% iniFile,PROGRAM,Show_Changelogs
	
;	Retrieve the settings arrays
	settingsArray := Gui_Settings_Get_Settings_Arrays()
	sectionArray := settingsArray.sectionArray
	SETTINGS_KeysArray := settingsArray.SETTINGS_KeysArray
	SETTINGS_DefaultValues := settingsArray.SETTINGS_DefaultValues
	AUTO_CLIP_KeysArray := settingsArray.AUTO_CLIP_KeysArray
	AUTO_CLIP_DefaultValues := settingsArray.AUTO_CLIP_DefaultValues
	HOTKEYS_KeysArray := settingsArray.HOTKEYS_KeysArray
	HOTKEYS_DefaultValues := settingsArray.HOTKEYS_DefaultValues
	NOTIFICATIONS_KeysArray := settingsArray.NOTIFICATIONS_KeysArray
	NOTIFICATIONS_DefaultValues := settingsArray.NOTIFICATIONS_DefaultValues
	MESSAGES_KeysArray := settingsArray.MESSAGES_KeysArray
	MESSAGES_DefaultValues := settingsArray.MESSAGES_DefaultValues	
;	Set the value for each key
	for key, element in sectionArray
	{
		sectionName := element
		for key, element in %sectionName%_KeysArray
		{
			keyName := element
			value := %sectionName%_DefaultValues[key]
			IniRead, var,% iniFile,% sectionName,% keyName
			if ( var = "ERROR" || var = "" ) {
				IniWrite,% value,% iniFile,% sectionName,% keyName
			}
		}
	}
;~ returnArray.MESSAGES_DefaultValues.Insert(0, "1", "@%buyerName% One moment please! (%itemName% // %itemPrice%)", "1", "@%buyerName% Your item is ready to be picked up at my hideout! (%itemName% // %itemPrice%)", "1", "@%buyerName% Thank you, good luck & have fun!")
	
	
}

Declare_INI_Settings(iniArray) {
;			Declare the settings to global variables
	global
	static key, element
	for key, element in iniArray.KEYS {
		VALUE_%element% := iniArray.VALUES[key]
	}
}

;==================================================================================================================
;
;																														MISC STUFF
;
;==================================================================================================================

Do_Once() {
;			Things that only need to be done ONCE
;																			
;	Run the Settings GUI when the user is using the program for the first time
	IniRead, state,% iniFilePath,PROGRAM,First_Time_Running
	if ( state = 1 ) {
		Extract_Sound_Files()
		MsgBox, ,Welcome!,Welcome & thank you for trying out this program!`n`Seems like it's your first time running %programName%...`nWorry not! The interface is simple and easy to understand.`n`nThe settings window will now open.`nThe "Help?" setting has been enabled: Hover the controls to see helpful tooltips!`n`nIf you would like to access the Settings menu again,`n  right click on the tray icon and pick [Settings]!
		Gui_Settings()
		IniWrite, 0,% iniFilePath,PROGRAM,First_Time_Running
	}
;	Add @%buyerName% to the message due to function change in 1.2
	IniRead, state,% iniFilePath,PROGRAM,FIX_Add_BuyerName
	if ( state = 1 ) {
		key1 := "Wait_Text", key2 := "Invite_Text", key3 := "Thanks_Text"
		Loop 3 {
			index := A_Index
			IniRead, msg,% iniFilePath,MESSAGES,% key%index%
			if !( RegExMatch(msg, "@`%buyerName`%?") ) {
				msg := "@`%buyerName`% " msg
				IniWrite,% msg,% iniFilePath,MESSAGES,% key%index%
				didChange := 1
			}
		}
		IniWrite, 0,% iniFilePath,PROGRAM,FIX_Add_BuyerName
		if ( didChange = 1 )
			MsgBox,4096,% programName " v" programVersion,% "Due to a small change in the function,`nyou now need to include ""@`%buyerName`%"" in your`ncustom messages if you wish to send the message as a whisper.`n`nTo make things easier for you, your custom messages`nhave been edited to include the new format!`n`n" programName " will now be reloaded..."
		Reload_Func()
	}
;	Open the changelog menu
	IniRead, state,% iniFilePath,PROGRAM,Show_Changelogs
	if ( state = 1 ) {
		Gui_About()
		IniWrite, 0,% iniFilePath,PROGRAM,Show_Changelogs
	}
}

Get_DPI_Factor() {
;			Credits to ANT-ilic
;			autohotkey.com/board/topic/6893-guis-displaying-differently-on-other-machines/?p=77893
;			Retrieves the current DPI value and returns it
;			If the key wasn't found or is set at 96, returns default setting
	RegRead, dpiValue, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
	if (errorlevel = 1) || (dpiValue = 96)
		dpiFactor := 1
	else
		dpiFactor := dpiValue/96
	return dpiFactor
}

Logs_Append(funcName, paramsArray=""){
	global programLogsFilePath, programName, programVersion
	global VALUE_Show_Mode, VALUE_Transparency, VALUE_Dock_Mode, VALUE_Logs_Mode
	global VALUE_Clip_New_Items, VALUE_Clip_On_Tab_Switch
	global VALUE_HK_1_Toggle, VALUE_HK_1, VALUE_HK_1_CTRL, VALUE_HK_1_ALT, VALUE_HK_1_SHIFT
	global VALUE_Wait_Text_Toggle, VALUE_Wait_Text, VALUE_Invite_Text_Toggle, VALUE_Invite_Text, VALUE_Thanks_Text_Toggle, VALUE_Thanks_Text
	global VALUE_Trade_Toggle, VALUE_Trade_Sound, VALUE_Whisper_Toggle, VALUE_Whisper_Sound, VALUE_Whisper_Tray
	if ( funcName = "Start" ) {
		FileAppend,% "__________PROGRAM__________",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "Successfully started " programName " with PID " programPID,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "Version: " programVersion,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "File Name: " A_ScriptName,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "__________SETTINGS__________",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Showing Mode:" VALUE_Show_Mode,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Transparency:" VALUE_Transparency,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Docking Mode:" VALUE_Dock_Mode,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Logs Mode:" VALUE_Logs_Mode,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "__________AUTO_CLIP__________",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Clip new Items:" VALUE_Clip_New_Items,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Clip on tab Switch:" VALUE_Clip_On_Tab_Switch,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "__________HOTKEYS__________",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "State (HK1): " VALUE_HK_1_Toggle " - Key: " VALUE_HK_1,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "Modifiers: CTRL:" VALUE_HK_1_CTRL " - ALT:" VALUE_HK_1_ALT " - SHIFT:" VALUE_HK_1_SHIFT,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "__________NOTIFICATIONS__________",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "State (Trade Sound): " VALUE_Trade_Toggle " - Sound: " VALUE_Trade_Sound,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "State (Whisper Sound): " VALUE_Whisper_Toggle " - Sound: " VALUE_Whisper_Sound,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "State (Whisper Tray): " VALUE_Whisper_Tray,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "__________MESSAGES__________",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "State (Wait): " VALUE_Wait_Text_Toggle " - Content: " VALUE_Wait_Text,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "State (Invite): " VALUE_Invite_Text_Toggle " - Content: " VALUE_Invite_Text,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend,% "State (Thanks): " VALUE_Thanks_Text_Toggle " - Content: " VALUE_Thanks_Text,% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "`n",% programLogsFilePath
		FileAppend % "*******************************************************************`n",% programLogsFilePath
		FileAppend % "*******************************************************************`n",% programLogsFilePath
	}
	if ( funcName = "Prevent_Multiple_Instancies" ) {
		existPID := paramsArray[0], thisPID := paramsArray[1]
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] -- Blocked new instancie from starting up: (Current PID: " thisPID " - Existing PID: " existPID ")", % programLogsFilePath
	}
	if ( funcName = "Send_InGame_Message" ) {
		messageToSend := paramsArray[0]
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] -- Sent In-Game message containing the following: " messageToSend , % programLogsFilePath
	}
	FileAppend,% "`n",% programLogsFilePath
}

Delete_Old_Logs_Files() {
;			Make sure to only keep 10 (+current) logs file
;			Delete the older logs file
	global programLogsPath
	
	loop, %programLogsPath%\*txt
	{
		filesNum := A_Index
		if ( A_LoopFileName != "changelog.txt" ) {
			allFiles .= A_LoopFileName "|"
		}
	}
	Sort, allFiles, D|
	split := StrSplit(allFiles, "|")
	if ( filesNum > 10 ) {
		Loop {
			index := A_Index
			fileLocation := programLogsPath "\" split[A_Index]
			FileDelete,% fileLocation
			filesNum -= 1
			if ( filesNum <= 10 )
				break
		}
	}
}

Get_Aero_Status(){
;			Retrieve the AERO status and returns it
;			(When AERO is disabled, we have to put -Theme to the GUI that use tabs or text will be blacked out)
	hr := DllCall("Dwmapi\DwmIsCompositionEnabled", "Int*", isEnabled)
	If (hr == 0) {
		if (isEnabled)
			state := 1
		else
			state := 0
	}
	else
		state := "ERROR"
	return state
}

DoNothing:
return

Send_InGame_Message(messageToSend, buyerName="", itemName="", itemPrice="") {
;			Sends a message InGame and replace the "variables text" into their content
	global VALUE_Logs_Mode
	SetKeyDelay, 30, 1
	messageToSendRaw := messageToSend
	StringReplace, messageToSend, messageToSend, `%buyerName`%, %buyerName%, 1
	StringReplace, messageToSend, messageToSend, `%itemName`%, %itemName%, 1
	StringReplace, messageToSend, messageToSend, `%itemPrice`%, %itemPrice%, 1
	Clipboard_Backup := Clipboard
	Clipboard := messageToSend
	sleep 10
	gameGroup := Get_Exe_From_Mode(VALUE_Logs_Mode, "VALUE_Logs_Mode")
	ControlSend, ,{Enter}{Shift Down}{Home}{Shift Up}{Ctrl Down}v{Ctrl Up}{Enter},ahk_group %gameGroup%
	Clipboard := Clipboard_Backup
;-------------------------------------------------------------------------------------------------------------------------
	paramsArray := Object()
	paramsArray.Insert(0, messageToSend)
	Logs_Append(A_ThisFunc, paramsArray)
}

Extract_Sound_Files() {
;			Extracts the included sfx into the .ini settings folder
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\MM_Tatl_Gleam.wav,% sfxFolderPath "\MM_Tatl_Gleam.wav", 1
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\MM_Tatl_Hey.wav,% sfxFolderPath "\MM_Tatl_Hey.wav", 1
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\WW_MainMenu_CopyErase_Start.wav,% sfxFolderPath "\WW_MainMenu_CopyErase_Start.wav", 1
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\WW_MainMenu_Letter.wav,% sfxFolderPath "\WW_MainMenu_Letter.wav", 1
}

Prevent_Multiple_Instancies() {
;			Prevent from running multiple instancies of the program
;			Check if an instancie already exist and close the new instancie if so
	IniRead, runningProcess,% iniFilePath,PROGRAM,FileName
	Process, Exist, %runningProcess%
	runningPID := ErrorLevel
	if ( runningPID ) {
		currentPID := DllCall("GetCurrentProcessId")
		if ( runningPID != currentPID ) {
			paramsArray := Object()
			paramsArray.Insert(0, runningPID, currentPID)
			Logs_Append(A_ThisFunc, paramsArray)
			OnExit("Exit_Func", 0)
			ExitApp	
		}
	}
}

Create_Tray_Menu() {
	Menu, Tray, DeleteAll
	Menu, Tray, Tip,% programName
	Menu, Tray, NoStandard
	Menu, Tray, Add,Settings, Gui_Settings
	Menu, Tray, Add,About?, Gui_About
	Menu, Tray, Add, 
	Menu, Tray, Add,Reload, Reload_Func
	Menu, Tray, Add,Close, Exit_Func
	return
}

Get_Exe_From_Mode(value, varName) {
;			Convert the mode to the corresponding .exe name
;			Return the .exe name
	if ( varName = "VALUE_Logs_Mode" ) {
		if ( value = "GGG" )
			exeGroup := "POEGame"
		if ( value = "Steam" )
			exeGroup := "POEGameSteam"
	}
	if ( varName = "VALUE_Dock_Mode" ) {
		if ( value = "GGG" )
			exeGroup := "POEGame"
		if ( value = "Steam" )
			exeGroup := "POEGameSteam"
	}
	return exeGroup
}

WM_MOUSEMOVE() {
;			Taken from Alpha Bravo. Shows tooltip upon hovering a gui control
;			https://autohotkey.com/board/topic/81915-solved-gui-control-tooltip-on-hover/#entry598735
	static
	curControl := A_GuiControl
	If ( curControl <> prevControl ) {
		SetTimer, Display_ToolTip, -300 	; shorter wait, shows the tooltip quicker
		prevControl := curControl
	}
	return
	
	Display_ToolTip:
		controlTip := Get_Control_ToolTip(curControl)
		if ( controlTip ) {
		try
			tooltip,% controlTip
		catch
			ToolTip,
		SetTimer, Remove_ToolTip, -20000
	}
	else
		SetTimer, Remove_ToolTip, -1
	return
	
	Remove_ToolTip:
		ToolTip
	return
}

Reload_Func() {
	sleep 10
	Reload
	Sleep 10000
}

Exit_Func(ExitReason, ExitCode) {
	global fileObj
	if ( ExitReason != "LogOff" ) && ( ExitReason != "ShutDown" ) && ( ExitReason != "Reload" ) && ( ExitReason != "Single" ) {
		MsgBox, 4100, % programName " v" programVersion,Are you sure you wish to close %programName%?
		IfMsgBox, No
			return 1  ; OnExit functions must return non-zero to prevent exit.
	}
	fileObj.Close()
	OnExit("Exit_Func", 0)
	ExitApp
}