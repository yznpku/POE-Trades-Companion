/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Helper																															*
*					See all the information about the trade request upon receiving a poe.trade whisper															*
*																																								*
*					https://github.com/lemasato/POE-Trades-Helper/																								*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/																						*
*					https://www.pathofexile.com/forum/view-thread/1755148/																						*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

OnExit("Exit_Func")
#SingleInstance Off
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8 ; Required for cyrillic characters

;___Some_Variables___;
global userprofile, iniFilePath, programName, programVersion, programFolder, programPID, sfxFolderPath, programChangelogFilePath, POEGameArray, POEGameList
EnvGet, userprofile, userprofile
programVersion := "1.4.1", programRedditURL := "https://redd.it/57oo3h"
programName := "POE Trades Helper", programFolder := userprofile "\Documents\AutoHotKey\" programName
iniFilePath := programFolder "\Preferences.ini"
sfxFolderPath := programFolder "\SFX"
programLogsPath := programFolder "\Logs"
programLogsFilePath := userprofile "\Documents\AutoHotKey\" programName "\Logs\" A_YYYY "-" A_MM "-" A_DD "_" A_Hour "-" A_Min "-" A_Sec ".txt"
programChangelogFilePath := programFolder "\Logs\changelog.txt"
GroupAdd, POEGame, ahk_exe PathOfExile.exe
GroupAdd, POEGame, ahk_exe PathOfExile_x64.exe
GroupAdd, POEGame, ahk_exe PathOfExileSteam.exe
GroupAdd, POEGame, ahk_exe PathOfExile_x64Steam.exe
POEGameArray := Object()
POEGameArray.Insert(0, "PathOfExile.exe", "PathOfExile_x64.exe", "PathOfExileSteam.exe", "PathOfExile_x64Steam.exe")
POEGameList := "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe"

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
Create_Tray_Menu()
Run_As_Admin()
Prevent_Multiple_Instancies()
Tray_Refresh()
Set_INI_Settings()
settingsArray := Get_INI_Settings()
Declare_INI_Settings(settingsArray)
Create_Tray_Menu(1)
Delete_Old_Logs_Files(10)
Do_Once()
Check_Update()

;___Hotkeys___;
Loop 6 {
	index := A_Index
	if ( VALUE_HK%index%_Toggle ) {
			userHotkey%index% := VALUE_HK%index%_KEY
		if ( VALUE_HK%index%_CTRL )
			userHotkey%index% := "^" userHotkey%index%
		if ( VALUE_HK%index%_ALT )
			userHotkey%index% := "!" userHotkey%index%
		if ( VALUE_HK%index%_SHIFT )
			userHotkey%index% := "+" userHotkey%index%
			titleMatchMode := A_TitleMatchMode
			SetTitleMatchMode, RegEx
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" )
				Hotkey,% userHotkey%index%,Hotkeys_User_%index%
			SetTitleMatchMode, %titleMatchMode%
	}

}

;___Window Switch Detect___;
Gui +LastFound 
Hwnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,Hwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")

ShellMessage(wParam,lParam) {
	global VALUE_Show_Mode, VALUE_Dock_Mode, guiTradesHandler, tradesGuiWidth, VALUE_Dock_Window
	if ( wParam=4 or wParam=32772 ) { ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED
		if WinActive("ahk_id" guiTradesHandler) {
;		Prevent keyboard presses from interacting with the tradesGUI and thus mis-clicking a button
			Hotkey, IfWinActive, ahk_id %guiTradesHandler%
			Hotkey, NumpadEnter, DoNothing, On
			Hotkey, Escape, DoNothing, On
			Hotkey, Space, DoNothing, On
			Hotkey, Tab, DoNothing, On
			Hotkey, Enter, DoNothing, On
			Hotkey, Left, DoNothing, On
			Hotkey, Right, DoNothing, On
			Hotkey, Up, DoNothing, On
			Hotkey, Down, DoNothing, On
			Return ; returning prevents from triggering Gui_Trades_Set_Position while the GUI is active
		}
		if ( VALUE_Trades_GUI_Mode = "Window" )
			Return

		WinGet, winEXE, ProcessName, ahk_id %lParam%
		WinGet, winID, ID, ahk_id %lParam%
		if ( VALUE_Show_Mode = "Always" ) && ( tradesGuiWidth > 0 ) {
			Gui_Trades_Set_Position()
		}
		else if ( ( VALUE_Show_Mode = "InGame" ) && ( tradesGuiWidth > 0 ) && ( VALUE_Dock_Window = winID ) )
			Gui_Trades_Set_Position()
		else if ( ( VALUE_Show_Mode = "InGame" ) && ( VALUE_Dock_Window != winID ) )
			Gui, Trades:Show, NoActivate Hide
	}
	if WinActive("ahk_id" guiTradesHandler) {
;		Prevent keyboard presses from interacting with the tradesGUI and thus mis-clicking a button
		Hotkey, IfWinActive, ahk_id %guiTradesHandler%
		Hotkey, NumpadEnter, DoNothing, On
		Hotkey, Escape, DoNothing, On
		Hotkey, Space, DoNothing, On
		Hotkey, Tab, DoNothing, On
		Hotkey, Enter, DoNothing, On
		Hotkey, Left, DoNothing, On
		Hotkey, Right, DoNothing, On
		Hotkey, Up, DoNothing, On
		Hotkey, Down, DoNothing, On
	}
}

;	Uncomment only for testing purposes -- Simulates trade tabs
;	Also comment the Monitor_Game_Logs() line, otherwise the GUI will be overwritten
;	newItemInfos := Object()
;	newItemInfos.Insert(0, "iSellStuff", "level 1 Faster Attacks Support", "5 alteration", "Breach (stash tab ""Gems""; position: left 6, top 8")
;	newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
;	Gui_Trades(newItemArray)
;	newItemInfos.Insert(0, "FIRST BUYER", "FIRST ITEM", "FIRST PRICE", "FIRST LOCATION")
;	newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
;	Gui_Trades(newItemArray)
;	newItemInfos.Insert(0, "SECOND BUYER", "SECOND ITEM", "SECOND PRICE", "SECOND LOCATION")
;	newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
;	Gui_Trades(newItemArray)
;	newItemInfos.Insert(0, "THIRD BUYER", "THIRD ITEM", "THIRD PRICE", "THIRD LOCATION")
;	newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
;	Gui_Trades(newItemArray)

;___Logs Monitoring AKA Trades GUI___;
;Gui_Settings()
;Logs_Append("Start")
Monitor_Game_Logs()
Return

;==================================================================================================================
;
;										LOGS MONITORING
;
;==================================================================================================================

GUI_Multiple_Instances_OLD(foundMatchArray, foundMatchHandlersArray) {
	static
	global tempVar := foundMatchHandlersArray
	Gui, Instances:Destroy
	Gui, Instances:New, +ToolWindow +AlwaysOnTop -SysMenu +hwndGUIInstancesHandler
	Gui, Instances:Add, Text, x10 y10,% "Multiple instances of the game have been found!"
	. "`nPlease select "
	Gui, Instances:Add, DropDownList, w230 vHandlersList hwndHandlersListHandler AltSubmit
	Gui, Instances:Add, Button, gGUI_Instances_Flash w230 h30,MAKE IT FLASH
	Gui, Instances:Add, Button, gGUI_Instances_Apply w230 h30,APPLY
	for key, element in foundMatchArray { 
		GuiControl, Instances:,% HandlersListHandler,% element "|"
	}
	GuiControl, Instances:Choose,% HandlersListHandler,1
	Gui, Instances:Show,,% programName
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	Return HandlersList

	GUI_Instances_Flash:
		Gui, Instances:Submit, NoHide
		DllCall("FlashWindow", UInt, tempVar[HandlersList], Int, 1) ; Flashes the game window
	Return

	GUI_Instances_Apply:
		GuiControl, Instances:-AltSubmit,% HandlersListHandler
		Gui, Instances:Submit, NoHide
		Gui, Instances:Destroy
	Return
}

GUI_Multiple_Instances(handlersArray) {
	static
	Gui, Instances:Destroy
	Gui, Instances:New, +ToolWindow +AlwaysOnTop -SysMenu +hwndGUIInstancesHandler
	Gui, Instances:Add, Text, x10 y10,% "Detected instances are using different logs file."
	Gui, Instances:Add, Text, x10 y25,% "Please, select the one you would like to use!"
	ypos := 30
	for key, element in handlersArray {
		index := A_Index - 1
		Gui, Add, Text, x10 yp+30,Executable:
		WinGet, pName, ProcessName,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly w150,% pName
		Gui, Add, Button,xp+155 yp-2 gGUI_Multiple_Instances_Continue vContinue%index%,Continue with this one
		Gui, Add, Text, x10 yp+32,Path:
		WinGet, pPath, ProcessPath,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly,% pPath
		if ( index != handlersArray.MaxIndex() )
			Gui, Add, Text, w0 h0 xp yp+10
	}
	Gui, Instances:Show,NoActivate,% programName " - Multiple instances found"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Multiple_Instances_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := handlersArray[btnID]
		Gui, Instances:Destroy
	Return
}

Restart_Monitor_Game_Logs(previousTrades="") {
	static
	global GuiTradesHandler

	WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
	Monitor_Game_Logs("close")
	Monitor_Game_Logs(, previousTrades, xpos, ypos)
}

Monitor_Game_Logs(mode="", previousTrades="", previousX="unspecified", previousY="unspecified") {
;			Gets the logs location based on VALUE_Logs_Mode
;			Read trough the logs file for new whisper/trades
;			Pass the trade message infos to Gui_Trades()
;			Clipboard the item's info if the user enabled
;			Play a sound or tray notification (if the user enabled) on whisper/trade
	static
	global VALUE_Whisper_Tray, VALUE_Logs_Mode, VALUE_Clip_New_Items, VALUE_Trade_Toggle, VALUE_Trade_Sound_Path, VALUE_Whisper_Toggle, VALUE_Whisper_Sound_Path, VALUE_Whisper_Flash, GuiTradesHandler, POEGameArray, VALUE_Dock_Window

	if (mode = "close") {
		fileObj.Close()
		Return
	}
	
	WinGet windows, List
	matchHandlers := Object()
	index := 0
	Loop %windows%
	{
		id := windows%A_Index%
		WinGet ExeLocation, ProcessName,% "ahk_id " id
		if ExeLocation in %POEGameList%
		{
			matchHandlers.Insert(index, id)
			index++
		}
	}
	if ( index = 0 ) { ; No matching process found
		Gui_Trades(,"exenotfound")
		Sleep 10000
		Monitor_Game_Logs()
	}
	for key, element in matchHandlers {
		index := A_Index
		WinGet, tempExeLocation, ProcessPath,% "ahk_id " element
		SplitPath, tempExeLocation, ,tempExeDir
		tempLogsFile%index% := tempExeDir "\logs\Client.txt"
	}
	tempLogsFileBackup := tempLogsFile1
	Loop %index% {
		index := A_Index
			if ( tempLogsFileBackup = tempLogsFile%index% ) {
				logsFile := tempLogsFileBackup
				VALUE_Dock_Window := matchHandlers[0]
			}
			Else
				multipleInstances := 1
		tempLogsFileBackup := tempLogsFile%index%
	}
	if ( multipleInstances = 1 ) {
		winHandler := GUI_Multiple_Instances(matchHandlers)
		WinGet, exeLocation, ProcessPath,% "ahk_id " winHandler
		SplitPath, exeLocation, ,exeDir
		logsFile := exeDir "\logs\Client.txt"
		VALUE_Dock_Window := winHandler ; assign global var after choosing the right instance
	}
	Gui_Trades(previousTrades, ,previousX, previousY)

	fileObj := FileOpen(logsFile, "r")
	fileObj.pos := fileObj.length
	Loop {
		if ( !( FileExist(logsFile) ) || ( fileObj.pos > fileObj.length ) || fileObj.pos = -1 ) ||  {
			Break
		}
		if ( fileObj.pos < fileObj.length ) {
			lastMessage := fileObj.Read() ; Stores the last message into a var
			Loop, parse, lastMessage, `n, `r ; This makes sure to not skip messages, when receiving multiple at once
			{
				if ( RegExMatch( A_LoopField, ".*\[.*\D+(.*)\].*@(?:From|De|От кого) (.*?): (.*)", subPat ) ) ; Whisper found --  (.*?) makes sure to stop at the first ":", fixing the "stash tab:" error
				{
					gamePID := subPat1, whispName := subPat2, whispMsg := subPat3
					if ( VALUE_Whisper_Tray = 1 ) && !( WinActive("ahk_pid " gamePID) ) {
						gameHwnd := WinExist("ahk_pid " gamePID)
						TrayTip, Whisper Received:,%whispName%: %whispMsg%
						TrayTip, Whisper Received:,%whispName%: %whispMsg%
						SetTimer, Remove_TrayTip, -10000
						if ( VALUE_Whisper_Toggle = 1 ) && ( FileExist(VALUE_Whisper_Sound_Path) )
							SoundPlay,%VALUE_Whisper_Sound_Path%
					}
					if ( VALUE_Whisper_Flash = 1 ) && !( WinActive("ahk_pid " gamePID) ) {
						DllCall("FlashWindow", UInt, gameHwnd, Int, 1) ; Flashes the game window
					}
					messages := whispName . ": " whispMsg "`n"
					if ( RegExMatch( messages, ".*Hi, I(?: would|'d) like to buy your (.*) (?:listed for|for my) (.*) in (.*)", subPat ) ) ; Trade message found
					{
						tradeItem := subPat1, tradePrice := subPat2, tradeStash := subPat3
						if tradeItem contains % " 0`%"
							StringReplace, tradeItem, tradeItem, 0`%
	;					__TO_BE_ADDED__
	;					A way to know when the item being sold is currency, so we only copy that currency's name and not the entire string (ex: "50 chaos")
	;					if ( RegExMatch( messages, ".*Hi, I'd like to buy your .* for my .* in .*", subPat ) ) ; Trade message found
	;						isCurrency := 1
						newTradesInfos := Object()
						newTradesInfos.Insert(0, whispName, tradeItem, tradePrice, tradeStash, gamePID)
						messagesArray := Gui_Trades_Manage_Trades("Add_New", newTradesInfos)
						if WinExist("ahk_id " GuiTradesHandler)
							WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
						Gui_Trades(messagesArray, ,xpos, ypos)
						if ( VALUE_Clip_New_Items = 1 )
							Clipboard := tradeitem
						if ( VALUE_Trade_Toggle = 1 ) && ( FileExist(VALUE_Trade_Sound_Path) )
							SoundPlay,%VALUE_Trade_Sound_Path%
					}
				}
			}
		}
		sleep 100
	}
	Loop 2 { ; Used to make the TrayTip appears instantly instead of fading in
		TrayTip,% "POE Trades Helper - Issue with the logs file!",% "It could be one of the following reasons: "
		. "`n- The file doesn't exist anymore."
		. "`n- Content from the file was deleted."
		. "`n- The file object used by the program was closed."
		. "`n`nThe logs monitoring function will be restarting in 10 seconds."
	}
	sleep 10000
	messagesArray := Gui_Trades_Manage_Trades("Get_All")
	Restart_Monitor_Game_Logs(messagesArray)
}

;==================================================================================================================
;
;												HOTKEYS
;
;==================================================================================================================

Hotkeys_User_1:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_2:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_3:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_4:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_5:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_6:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_Handler(thisLabel="") {
	key := (thisLabel="Hotkeys_User_1")?("HK1"):(thisLabel="Hotkeys_User_2")?("HK2"):(thisLabel="Hotkeys_User_3")?("HK3"):(thisLabel="Hotkeys_User_4")?("HK4"):(thisLabel="Hotkeys_User_5")?("HK5"):(thisLabel="Hotkeys_User_6")?("HK6"):("ERROR")
	IniRead, textToSend,% iniFilePath,HOTKEYS,% key "_TEXT"
	;Send_InGame_Message(textToSend, 0, 2) ; __TO_BE_ADDED__ Go back to the previous channel
	Send_InGame_Message(textToSend)
}

;==================================================================================================================
;
;												TRADES GUI
;
;==================================================================================================================
	
Gui_Trades(infosArray="", errorMsg="", xpos="unspecified", ypos="unspecified") {
;			Trades GUI. Each new item will be added in a new tab
;			Clicking on a button will do its corresponding action
;			Switching tab will clipboard the item's infos if the user enabled
;			Is transparent and click-through when there is no trade on queue
	global
	static tabWidth, tabHeight, tradesCount, index, element, varText, varName, tabName, trans, priceArray, btnID, Clipboard_Backup, gameGroup, itemArray, itemName, itemPrice, messageToSend
	static nameArray, buyerName

	Gui, Trades:Destroy
	Gui, Trades:New, +ToolWindow +AlwaysOnTop -Border +hwndGuiTradesHandler +LabelGui_Trades_ +LastFound -SysMenu
	Gui, Trades:Default
	tabWidth := 390, tabHeight := 190
	if ( VALUE_Trades_GUI_Mode = "Window" ) {
		Gui, Trades: +Border
	}
	tabsCount := infosArray.BUYERS.Length()
	if (tabsCount = "" || tabsCount = 0) {
		infosArray := Object()
		infosArray.BUYERS := Object()
		if ( errorMsg = "exenotfound" )
			infosArray.BUYERS.Insert(0, "Process not found, retrying in 10seconds...`n`nRight click on the tray icon`nthen [Settings] to set your preferences.")
		else 
			infosArray.BUYERS.Insert(0, "No trade on queue!`n`nRight click on the tray icon`nthen [Settings] to set your preferences.")
		tabWidth := 325, tabHeight := 95	; Tab size is smaller when there is no item
		IniWrite,0,% iniFilePath,PROGRAM,Tabs_Number
		if ( tabsCount = "" )
			tabsCount := 0
	}
	tabHeight := tabHeight +  18*( Floor( tabsCount/10 ) ) ; Adds 18 in height for every 10 tabs
	tabHeight := tabHeight +  18*( Floor( tabsCount/100 ) ) ; Adds 18 in height for every 100 tabs
	if tabsCount in 19,28,29,37,38,39,46,47,48,49,55,56,57,58,59,64,65,66,67,68,69,73,74,75,76,77,78,79,82,83,84,85,86,87,88,89,91,92,93,94,95,96,97,98,99
		tabHeight += 18
	
	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		Gui, Add, Tab3,x10 y10 vTab gGui_Trades_OnTabSwitch w%tabWidth% h%tabHeight%
	else
		Gui, Add, Tab3,x10 y10 vTab gGui_Trades_OnTabSwitch w%tabWidth% h%tabHeight% -Theme
	for index, element in infosArray.BUYERS
	{
		tabName := index
		GuiControl,,Tab,%tabName%
		if ( index=0 ) { ; allows to have the "No trade in queue" on tab 0 and trades on 1,2,3...
			Gui, Tab,% index+1
			Gui, Add, Text, w300 h55 vtextSlot%index% 0x1,% infosArray.BUYERS[0]
			VALUE_Trades_GUI_Current_State := "Inactive"
		}
		else {
			Gui, Tab,% index
			Gui, Add, Text, ,% "Buyer: "
			Gui, Add, Text, xp+50 yp vBuyerSlot%index%,% infosArray.BUYERS[index]
			Gui, Add, Text, w300 xp-50 yp+15 ,% "Item: "
			Gui, Add, Text, w300 xp+50 yp vItemSlot%index%,% infosArray.ITEMS[index]
			Gui, Add, Text, w300 xp-50 yp+15 ,% "Price "
			Gui, Add, Text, w300 xp+50 yp vPriceSlot%index%,% infosArray.PRICES[index]
			Gui, Add, Text, w300 xp-50 yp+15 ,% "Location: "
			Gui, Add, Text, w300 xp+50 yp vLocationSlot%index%,% infosArray.LOCATIONS[index]
			Gui, Add, Text, w0 h0 xp yp vPIDSlot%index%,% infosArray.GAMEPID[index]
			VALUE_Trades_GUI_Current_State := "Active"
		}
		if ( index > 0 ) {
			Gui, Add, Button,w115 h35 x20 yp+25 vcopyBtn%index% -Theme +0x8000 gGui_Trades_CopyItemName,% "Clipboard Item"
			Gui, Add, Button,w115 h35 x145 yp vwaitBtn%index% -Theme +0x8000 gGui_Trades_Wait,% "Ask to Wait"
			Gui, Add, Button,w115 h35 x270 yp vinviteBtn%index% -Theme +0x8000 gGui_Trades_Invite,% "Party Invite"
			Gui, Add, Button,w240 h35 x20 yp+45 vthanksBtn%index% -Theme +0x8000 gGui_Trades_Thanks,% "Say Thanks`n (close tab)"
			Gui, Add, Button,w115 h35 x270 yp vsoldBtn%index% -Theme +0x8000 gGui_Trades_Sold,% "Say Item Sold`n   (close tab)"
			Gui, Add, Button,w20 h20 x375 yp-120 vdelBtn%index% -Theme +0x8000 gGui_Trades_RemoveItem,% "X"
		}
		else {
			IniRead, trans,% iniFilePath,SETTINGS,Transparency
			Gui, Trades: +E0x20 
			WinSet, Transparent,% VALUE_Transparency
		}
		IniWrite,%index%,% iniFilePath,PROGRAM,Tabs_Number
	}
	if ( tabsCount > 0 )
		WinSet, Transparent,% VALUE_Transparency_Active
	Gui, Show, NoActivate Hide AutoSize,% programName " - Queued Trades"
	sleep 100
	Gui_Trades_Set_Position(xpos, ypos)
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
;		Copy the first item or the second item if the first tab is being closed
		if ( VALUE_Clip_On_Tab_Switch = 1 ) {
			btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
			if ( btnID = 1 )
				btnID++
			else
				btnID := 1
			tradesInfosArray := Object()
			tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
			Clipboard := tradesInfosArray[1]
		}
;		Remove the current tab
		messagesArray := Gui_Trades_Manage_Trades("Remove_Current")
		if WinExist("ahk_id " GuiTradesHandler)
			WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
		Gui_Trades(messagesArray, ,xpos, ypos)
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
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice - [3] thisPID
		if ( VALUE_Wait_Text_Toggle = 1 ) {
			Send_InGame_Message(VALUE_Wait_Text, tradesInfosArray)
			; Send_InGame_Message(VALUE_Wait_Text, 1, 2, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2]) ; __TO_BE_ADDED__ Go back to the previous channel
		}
	return
	
	Gui_Trades_Invite:
;		Send a message and invite the player to the party
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Invite_Text_Toggle = 1 ) {
			Send_InGame_Message(VALUE_Invite_Text, tradesInfosArray)
		}
		Send_InGame_Message("/invite " tradesInfosArray[0], tradesInfosArray)
		; Send_InGame_Message("/invite " tradesInfosArray[0], 1, 3) ; __TO_BE_ADDED__ Go back to the previous channel
	return
	
	Gui_Trades_Thanks:
;		Send a message to the player and close the tab
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Thanks_Text_Toggle = 1 ) {
;			if ( VALUE_Support_Text_Toggle = 1 )
;				goBackUp := 0
;			Else
;				goBackUp := 2
;			Send_InGame_Message(VALUE_Thanks_Text, 1, goBackUp, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2]) ; __TO_BE_ADDED__ Go back to the previous channel
			Send_InGame_Message(VALUE_Thanks_Text, tradesInfosArray) 
			if ( VALUE_Support_Text_Toggle = 1 )
				Send_InGame_Message("@%buyerName% - - - POE Trades Helper: Keep track of your trades! // Look it up! (not a bot!)", tradesInfosArray)
;				Send_InGame_Message("@%buyerName% . . - POE Trades Helper: Keep track of your trades! // URL: " programRedditURL " (not a bot!)", 1, 3, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2])
		}
		GoSub, Gui_Trades_RemoveItem
	return
	
	Gui_Trades_Sold:
;		Send a message to the player and close the tab
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		if ( VALUE_Sold_Text_Toggle = 1 ) {
;			if ( VALUE_Support_Text_Toggle = 1 )
;				goBackUp := 0
;			Else
;				goBackUp := 2
;			Send_InGame_Message(VALUE_Sold_Text, 1, goBackUp, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2]) ;  __TO_BE_ADDED__ Go back to the previous channel
			Send_InGame_Message(VALUE_Sold_Text, tradesInfosArray)
			if ( VALUE_Support_Text_Toggle = 1 )
				Send_InGame_Message("@%buyerName% - - - POE Trades Helper: Keep track of your trades! // Look it up! (not a bot!)", tradesInfosArray)
;				Send_InGame_Message("@%buyerName% . . - POE Trades Helper: Keep track of your trades! // URL: " programRedditURL " (not a bot!)", 1, 3, tradesInfosArray[0], tradesInfosArray[1], tradesInfosArray[2])
		}
		GoSub, Gui_Trades_RemoveItem
	return

	Gui_Trades_Size:
;		Declare the GUI width and height
		tradesGuiWidth := A_GuiWidth
		tradesGuiHeight := A_GuiHeight
	return
}

GUI_Trades_Mode:
	thisMenuItem := A_ThisMenuItem
	global VALUE_Trades_GUI_Mode, iniFilePath
	if VALUE_Trades_GUI_Mode is not Number
		VALUE_Trades_GUI_Mode := 1
	if ( thisMenuItem = "Mode: Overlay") {
		Menu, Tray, UnCheck,% "Mode: Window"
		Menu, Tray, Check,% "Mode: Overlay"
		VALUE_Trades_GUI_Mode := "Overlay"
	}
	else if ( thisMenuItem = "Mode: Window") {
		Menu, Tray, UnCheck,% "Mode: Overlay"
		Menu, Tray, Check,% "Mode: Window"
		VALUE_Trades_GUI_Mode := "Window"
	}
	IniWrite,% VALUE_Trades_GUI_Mode,% iniFilePath,SETTINGS,Trades_GUI_Mode
	messagesArray := Gui_Trades_Manage_Trades("Get_All")
	Gui_Trades(messagesArray)
Return

Gui_Trades_Get_Tab_ID(controlName){
	GuiControlGet, varName, Trades:Name, %controlName%
	btnID := RegExReplace(varName, "\D")
	return btnID
}

Gui_Trades_Get_Trades_Infos(btnID){
	GuiControlGet, buyerName, ,buyerSlot%btnID%
	GuiControlGet, itemName, ,itemSlot%btnID%
	GuiControlGet, itemPrice, ,priceSlot%btnID%
	GuiControlGet, thisPID, ,PIDSlot%btnID%
	returnArray := Object()
	returnArray.Insert(0, buyerName, itemName, itemPrice, thisPID)
	return returnArray
}

Gui_Trades_Manage_Trades(mode="", newItemInfos=""){
;
;
	static

	if ( mode = "" )
		Return

	returnArray := Object()
	returnArray.COUNT := Object()
	returnArray.BUYERS := Object()
	returnArray.ITEMS := Object()
	returnArray.PRICES := Object()
	returnArray.LOCATIONS := Object()
	returnArray.GAMEPID := Object()
	GuiControlGet, varName, Trades:Name,% A_GuiControl
	btnID := RegExReplace(varName, "\D")

	if ( mode = "Get_All" || mode = "Add_New") {
	;	___BUYERS___	
		Loop {
			bcount := A_Index
			GuiControlGet, content, Trades:,buyerSlot%A_Index%
			if ( content ) {
				returnArray.BUYERS.Insert(A_Index, content)
			}
			else break
		}
		
	;	___ITEMS___
		Loop {
			icount := A_Index
			GuiControlGet, content, Trades:,itemSlot%A_Index%
			if ( content ) {
				returnArray.ITEMS.Insert(A_Index, content)
			}
			else break
		}
		
	;	___PRICES___
		Loop {
			pcount := A_Index
			GuiControlGet, content, Trades:,priceSlot%A_Index%
			if ( content ) {
				returnArray.PRICES.Insert(A_Index, content)
			}
			else break
		}
		
	;	___LOCATIONS___
		Loop {
			lcount := A_Index
			GuiControlGet, content, Trades:,locationSlot%A_Index%
			if ( content ) {
				returnArray.LOCATIONS.Insert(A_Index, content)
			}
			else break
		}

	;	___GAMEPID___
		Loop {
			PIDCount := A_Index
			GuiControlGet, content, Trades:,PIDSlot%A_Index%
			if ( content ) {
				returnArray.GAMEPID.Insert(A_Index, content)
			}
			else break
		}
	}

	if ( mode = "Add_New") {
		name := newItemInfos[0], item := newItemInfos[1], price := newItemInfos[2], location := newItemInfos[3], gamePID := newItemInfos[4]
		name := Gui_Trades_RemoveGuildPrefix(name)
		returnArray.COUNT.Insert(0, bCount)
		returnArray.BUYERS.Insert(bCount, name)
		returnArray.ITEMS.Insert(iCount, item)
		returnArray.PRICES.Insert(pCount, price)
		returnArray.LOCATIONS.Insert(lCount, location)
		returnArray.GAMEPID.Insert(PIDCount, gamePID)
	}

	if ( mode = "Remove_Current") {
	;	___BUYERS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,buyerSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.BUYERS.Insert(index, content)
			}
			else break
		}

	;	___ITEMS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,itemSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.ITEMS.Insert(index, content)
			}
			else break
		}
		
	;	___PRICES___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,priceSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.PRICES.Insert(index, content)
			}
			else break
		}
		
	;	___LOCATIONS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,locationSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.LOCATIONS.Insert(index, content)
			}
			else break
		}
;	___GAMEPID___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,PIDSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.GAMEPID.Insert(index, content)
			}
			else break
		}
	}

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

Gui_Trades_Set_Position(xpos="unspecified", ypos="unspecified"){
;			Refresh the Trades GUI position
	global VALUE_Trades_GUI_Mode, tradesGuiWidth, tradesGuiHeight, GuiTradesHandler, VALUE_Trades_GUI_Last_State, VALUE_Trades_GUI_Current_State, VALUE_Dock_Window
	
	gameGroup := Get_Exe_From_Mode(VALUE_Dock_Mode, "VALUE_Dock_Mode")
	dpiFactor := Get_DPI_Factor()

	if ( VALUE_Trades_GUI_Mode = "Window" && xpos != "unspecified" && ypos != "unspecified" ) {
		xpos := xpos * dpiFactor, ypos := ypos * dpiFactor
		if ( VALUE_Trades_GUI_Last_State = "Inactive" && VALUE_Trades_GUI_Current_State = "Active" ) ; Inactive and Active GUI have different size, so we have to compensate when switching from one to another
			xpos := xpos - (65*dpiFactor)
		else if ( VALUE_Trades_GUI_Last_State = "Active" && VALUE_Trades_GUI_Current_State = "Inactive")
			xpos := xpos + (65*dpiFactor)
		Gui, Trades:Show,% "x" xpos " y" ypos " NoActivate"
	}
	else {
		if ( WinExist("ahk_id " VALUE_Dock_Window ) ) {
			WinGetPos, winX, winY, winWidth, winHeight, ahk_id %VALUE_Dock_Window%
			xpos := ( (winX+winWidth)-tradesGuiWidth * dpiFactor ) -14
			ypos := winY
			if xpos is not number
				xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor ) - 6
			if ypos is not number
				ypos := 0
			if ( xpos = -32264 || ypos = -32000 )
				xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor ) - 6, ypos := 0
			Gui, Trades:Show, % "x" xpos " y" ypos " NoActivate"
		}
		else {
			xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor ) - 6
			Gui, Trades:Show, % "x" xpos " y0" " NoActivate"
		}
	}
	VALUE_Trades_GUI_Last_State := VALUE_Trades_GUI_Current_State ; backup of the old state, so we know when we switch from one to another
}

;==================================================================================================================
;
;												SETTINGS GUI
;
;==================================================================================================================

Gui_Settings() {
	static
	iniFile := iniFilePath
	global Hotkey1_KEYHandler, Hotkey2_KEYHandler, Hotkey3_KEYHandler, Hotkey4_KEYHandler, Hotkey5_KEYHandler, Hotkey6_KEYHandler, 
	
	OnMessage(0x200,"WM_MOUSEMOVE", 1)
	Gui, Settings:Destroy
	Gui, Settings:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_Settings_ hwndSettingsHandler,% programName " - Settings"
	Gui, Settings:Default
	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		Gui, Add, Tab3, vTab x10 y10,Settings|Messages|Hotkeys
	else
		Gui, Add, Tab3, vTab x10 y10 -Theme,Settings|Messages|Hotkeys
	Gui, Tab, Settings
;	Settings Tab
;		Trades GUI
		Gui, Add, GroupBox, x20 y40 w200 h260,Trades GUI
		Gui, Add, Radio, xp+10 yp+20 vShowAlways hwndShowAlwaysHandler,Always show
		Gui, Add, Radio, xp yp+15 vShowInGame hwndShowInGameHandler,Only show while in game

		Gui, Add, GroupBox, x25 yp+25 w190 h115,Transparency
		Gui, Add, Text, xp+10 yp+20,Inactive (no trade on queue)
		Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyHandler gGui_Settings_Transparency vShowTransparency AltSubmit ToolTip Range0-100
		Gui, Add, Text, xp-10 yp+30,Active (trades are on queue)
		Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyActiveHandler gGui_Settings_Transparency vShowTransparencyActive AltSubmit ToolTip Range30-100
;		Notifications
;			Trade Sound Group
			Gui, Add, GroupBox, x230 y40 w210 h120,Notifications
			Gui, Add, Checkbox, xp+10 yp+20 vNotifyTradeToggle hwndNotifyTradeToggleHandler,Trade
			Gui, Add, Edit, xp+60 yp-2 w70 h17 vNotifyTradeSound hwndNotifyTradeSoundHandler ReadOnly
			Gui, Add, Button, xp+75 yp-2 h20 vNotifyTradeBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Sound Group
			Gui, Add, Checkbox, x240 y85 vNotifyWhisperToggle hwndNotifyWhisperToggleHandler,Whisper
			Gui, Add, Edit, xp+60 yp-2 w70 h17 vNotifyWhisperSound hwndNotifyWhisperSoundHandler ReadOnly
			Gui, Add, Button, xp+75 yp-2 h20 vNotifyWhisperBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Tray Notification
			Gui, Add, Checkbox, x240 yp+24 vNotifyWhisperTray hwndNotifyWhisperTrayHandler,Tray notifications for whispers`n when POE is not active
			Gui, Add, Checkbox, x240 yp+29 vNotifyWhisperFlash hwndNotifyWhisperFlashHandler,Make the game's taskbar icon flash
;		Clipboard
		Gui, Add, GroupBox, x230 y160 w210 h60,Clipboard
		Gui, Add, Checkbox, xp+10 yp+20 hwndClipNewHandler vClipNew,Clipboard new items
		Gui, Add, Checkbox, xp yp+15 hwndClipTabHandler vClipTab,Clipboard item on tab switch
;		Support
		Gui, Add, GroupBox, x230 y220 w210 h80,Support
		Gui, Add, Checkbox, xp+80 yp+20 vMessageSupportToggle hwndMessageSupportToggleHandler gGui_Settings_Support_MsgBox
		Gui, Add, Text, gGUI_Settings_Tick_Case vMessageSupportToggleText xp-55 yp+13,% "Support the software by allowing`n   an additional message when`nclicking the Thanks/Sold buttons"
;		Apply Button
		Gui, Add, Button, x20 y310 w420 h30 gGui_Settings_Btn_Apply vApplyBtn,Apply Settings
	
;	Message Tab
	Gui, Tab, Messages
;		Top message
		Gui, Add, Text, x20 y40,Use these variables in your message to specify the infos about the item:
		Gui, Add, Text, xp+10 yp+15,`%buyerName`% %A_Tab%%A_Tab% Contains the buyer's name
		Gui, Add, Text, xp yp+15,`%itemName`% %A_Tab%%A_Tab% Contains the item's infos
		Gui, Add, Text, xp yp+15,`%itemPrice`% %A_Tab%%A_Tab% Contains the item's price
;		One moment button
		Gui, Add, Text, x20 y120,"Ask to Wait" button:
		Gui, Add, CheckBox, xp yp+20 vMessageWaitToggle hwndMessageWaitToggleHandler,
		Gui, Add, Edit, xp+25 yp-3 w390 vMessageWait hwndMessageWaitHandler
;		Invite to party button
		Gui, Add, Text, x20 y165,"Party Invite" button:
		Gui, Add, CheckBox, xp yp+20 vMessageInviteToggle hwndMessageInviteToggleHandler,
		Gui, Add, Edit, xp+25 yp-3 w390 vMessageInvite hwndMessageInviteHandler
;		Thanks button
		Gui, Add, Text, x20 y210,"Say Thanks" button:
		Gui, Add, CheckBox, xp yp+20 vMessageThanksToggle hwndMessageThanksToggleHandler,
		Gui, Add, Edit, xp+25 yp-3 w390 vMessageThanks hwndMessageThanksHandler
;		Sold button
		Gui, Add, Text, x20 y255,"Say Item Sold" button:
		Gui, Add, CheckBox, xp yp+20 vMessageSoldToggle hwndMessageSoldToggleHandler,
		Gui, Add, Edit, xp+25 yp-3 w390 vMessageSold hwndMessageSoldHandler
;		Apply Button
		Gui, Add, Button, x20 y310 w420 h30 gGui_Settings_Btn_Apply vApplyBtn2,Apply Settings

;	Hotkeys Tab
	Gui, Tab, Hotkeys

	ypos := 30,	xpos := 20
	Loop 6 {
		btnID := A_Index
		if (btnID > 1 && btnID <= 3)
			ypos += 90
		else if (btnID = 4)
			xpos := 235, ypos := 30
		else if (btnID > 4)
			ypos +=90
		Gui, Add, GroupBox, x%xpos% y%ypos% w200 h95
		Gui, Add, Checkbox, xp+10 yp+20 vHotkey%btnID%_Toggle hwndHotkey%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-4 w150 vHotkey%btnID%_Text hwndHotkey%btnID%_TextHandler,
		Gui, Add, Hotkey, xp yp+25 vHotkey%btnID%_KEY hwndHotkey%btnID%_KEYHandler gGui_Settings_Hotkeys,
		Gui, Add, Checkbox, xp yp+28 vHotkey%btnID%_CTRL hwndHotkey%btnID%_CTRLHandler,CTRL
		Gui, Add, Checkbox, xp+50 yp vHotkey%btnID%_ALT hwndHotkey%btnID%_ALTHandler,ALT
		Gui, Add, Checkbox, xp+42 yp vHotkey%btnID%_SHIFT hwndHotkey%btnID%_SHIFTHandler,SHIFT
	}
	Gui, Add, Button, x20 y310 w420 h30 gGui_Settings_Btn_Apply vApplyBtn3,Apply Settings

	GuiControl, Choose, Tab, 1
	GoSub Gui_Settings_Set_Preferences
	Gui, Trades: -E0x20
	Gui, Show
	sleep 100
return

	Gui_Settings_Support_MsgBox:
		Gui, Settings: Submit, NoHide
		if ( MessageSupportToggle = 1 ) {
			Gui, Trades: +OwnDialogs
			MsgBox, 4096,:o,% "Thank you for enabling the support message!"
			.	"`nAlso, feel free to recommend " programName " to your friends!"
		}
		
	Return

	
	GUI_Settings_Tick_Case:
		Gui, Settings: Submit, NoHide
		if ( A_GuiControl = "MessageSupportToggleText" ) {
			GuiControl, Settings:,% MessageSupportToggleHandler,% !MessageSupportToggle 
			GoSub Gui_Settings_Support_MsgBox
		}
	Return

	Gui_Settings_Transparency:
	;	Set the transparency
		Gui, Settings: Submit, NoHide
		trans := ( ShowTransparency / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		transActive := ( ShowTransparencyActive / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		Gui, Trades: +LastFound
		if ( A_GuiControl = "ShowTransparency" )
			WinSet, Transparent,% trans
		else
			WinSet, Transparent,% transActive
		if ( A_GuiControlEvent = "Normal" ) {
			IniRead, isActive,% iniFilePath,PROGRAM,Tabs_Number
			Gui, Trades: +LastFound
			if ( isActive > 0 )
				Winset, Transparent,% transActive
			else
				Winset, Transparent,% trans
		}
	return
	
	Gui_Settings_Close:
		OnMessage(0x200,"WM_MOUSEMOVE", 0)
		Gui, Settings: Destroy
		IniRead, isActive,% iniFilePath,PROGRAM,Tabs_Number
		if ( isActive = 0 )
			Gui, Trades: +E0x20
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
		transActive := ( ShowTransparencyActive / 100 ) * 255 ; ( value - percentage ) * max // Convert percentage to 0-255 range
		IniWrite,% trans,% iniFile,SETTINGS,Transparency
		IniWrite,% transActive,% iniFile,SETTINGS,Transparency_Active
		showMode := ( ShowAlways = 1 ) ? ( "Always" ) : ( ShowInGame = 1 ) ? ( "InGame" ) : ( "Always" )
		IniWrite,% showMode,% iniFile,SETTINGS,Show_Mode
;	Clipboard	
		IniWrite,% ClipNew,% iniFile,AUTO_CLIP,Clip_New_Items
		IniWrite,% ClipTab,% iniFile,AUTO_CLIP,Clip_On_Tab_Switch
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
		IniWrite,% NotifyWhisperFlash,% iniFile,NOTIFICATIONS,Whisper_Flash
;	Support
		IniWrite,% MessageSupportToggle,% iniFile,MESSAGES,Support_Text_Toggle
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
;		Sold
		IniWrite,% MessageSoldToggle,% iniFile,MESSAGES,Sold_Text_Toggle
		IniWrite,% MessageSold,% iniFile,MESSAGES,Sold_Text
;	Hotkeys
	;	1 -- Cant use a loop to write all six at once, since the variable has to be globally assigned to make it work
		IniWrite,% Hotkey1_Toggle,% iniFile,HOTKEYS,HK1_Toggle
		IniWrite,% Hotkey1_Text,% iniFile,HOTKEYS,HK1_Text
		IniWrite,% Hotkey1_KEY,% iniFile,HOTKEYS,HK1_KEY
		IniWrite,% Hotkey1_CTRL,% iniFile,HOTKEYS,HK1_CTRL
		IniWrite,% Hotkey1_ALT,% iniFile,HOTKEYS,HK1_ALT
		IniWrite,% Hotkey1_SHIFT,% iniFile,HOTKEYS,HK1_SHIFT
	;	2
		IniWrite,% Hotkey2_Toggle,% iniFile,HOTKEYS,HK2_Toggle
		IniWrite,% Hotkey2_Text,% iniFile,HOTKEYS,HK2_Text
		IniWrite,% Hotkey2_KEY,% iniFile,HOTKEYS,HK2_KEY
		IniWrite,% Hotkey2_CTRL,% iniFile,HOTKEYS,HK2_CTRL
		IniWrite,% Hotkey2_ALT,% iniFile,HOTKEYS,HK2_ALT
		IniWrite,% Hotkey2_SHIFT,% iniFile,HOTKEYS,HK2_SHIFT
	;	3
		IniWrite,% Hotkey3_Toggle,% iniFile,HOTKEYS,HK3_Toggle
		IniWrite,% Hotkey3_Text,% iniFile,HOTKEYS,HK3_Text
		IniWrite,% Hotkey3_KEY,% iniFile,HOTKEYS,HK3_KEY
		IniWrite,% Hotkey3_CTRL,% iniFile,HOTKEYS,HK3_CTRL
		IniWrite,% Hotkey3_ALT,% iniFile,HOTKEYS,HK3_ALT
		IniWrite,% Hotkey3_SHIFT,% iniFile,HOTKEYS,HK3_SHIFT
	;	4
		IniWrite,% Hotkey4_Toggle,% iniFile,HOTKEYS,HK4_Toggle
		IniWrite,% Hotkey4_Text,% iniFile,HOTKEYS,HK4_Text
		IniWrite,% Hotkey4_KEY,% iniFile,HOTKEYS,HK4_KEY
		IniWrite,% Hotkey4_CTRL,% iniFile,HOTKEYS,HK4_CTRL
		IniWrite,% Hotkey4_ALT,% iniFile,HOTKEYS,HK4_ALT
		IniWrite,% Hotkey4_SHIFT,% iniFile,HOTKEYS,HK4_SHIFT
	;	5
		IniWrite,% Hotkey5_Toggle,% iniFile,HOTKEYS,HK5_Toggle
		IniWrite,% Hotkey5_Text,% iniFile,HOTKEYS,HK5_Text
		IniWrite,% Hotkey5_KEY,% iniFile,HOTKEYS,HK5_KEY
		IniWrite,% Hotkey5_CTRL,% iniFile,HOTKEYS,HK5_CTRL
		IniWrite,% Hotkey5_ALT,% iniFile,HOTKEYS,HK5_ALT
		IniWrite,% Hotkey5_SHIFT,% iniFile,HOTKEYS,HK5_SHIFT
	;	6
		IniWrite,% Hotkey6_Toggle,% iniFile,HOTKEYS,HK6_Toggle
		IniWrite,% Hotkey6_Text,% iniFile,HOTKEYS,HK6_Text
		IniWrite,% Hotkey6_KEY,% iniFile,HOTKEYS,HK6_KEY
		IniWrite,% Hotkey6_CTRL,% iniFile,HOTKEYS,HK6_CTRL
		IniWrite,% Hotkey6_ALT,% iniFile,HOTKEYS,HK6_ALT
		IniWrite,% Hotkey6_SHIFT,% iniFile,HOTKEYS,HK6_SHIFT
;	Declare the new settings
		settingsArray := Get_INI_Settings()
		Declare_INI_Settings(settingsArray)
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
	returnArray.SETTINGS_HandlersArray.Insert(0, "ShowAlways", "ShowInGame", "ShowTransparency", "ShowTransparencyActive")
	returnArray.SETTINGS_HandlersKeysArray := Object() ; contains all the .ini KEYS for those HANDLERS
	returnArray.SETTINGS_HandlersKeysArray.Insert(0, "Show_Mode", "Show_Mode", "Transparency", "Transparency_Active")
	returnArray.SETTINGS_KeysArray := Object() ; contains all the individual .ini KEYS
	returnArray.SETTINGS_KeysArray.Insert(0, "Show_Mode", "Transparency", "Trades_GUI_Mode", "Transparency_Active")
	returnArray.SETTINGS_DefaultValues := Object() ; contains all the DEFAULT VALUES for the .ini KEYS
	returnArray.SETTINGS_DefaultValues.Insert(0, "Always", "150", "Overlay", "255")
	
	returnArray.AUTO_CLIP_HandlersArray := Object()
	returnArray.AUTO_CLIP_HandlersArray.Insert(0, "ClipNew", "ClipTab")
	returnArray.AUTO_CLIP_HandlersKeysArray := Object()
	returnArray.AUTO_CLIP_HandlersKeysArray.Insert(0, "Clip_New_Items", "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_KeysArray := Object()
	returnArray.AUTO_CLIP_KeysArray.Insert(0, "Clip_New_Items", "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_DefaultValues := Object()
	returnArray.AUTO_CLIP_DefaultValues.Insert(0, "1", "1")
	
	returnArray.HOTKEYS_HandlersArray := Object()
	returnArray.HOTKEYS_HandlersKeysArray := Object()
	returnArray.HOTKEYS_KeysArray := Object()
	returnArray.HOTKEYS_DefaultValues := Object()
	keyID := 0
	Loop 6 {
		index := A_Index
		returnArray.HOTKEYS_HandlersArray.Insert(keyID, "Hotkey" index "_Toggle", "Hotkey" index "_Text", "Hotkey" index "_KEY", "Hotkey" index "_CTRL", "Hotkey" index "_ALT", "Hotkey" index "_SHIFT")
		returnArray.HOTKEYS_HandlersKeysArray.Insert(keyID, "HK" index "_Toggle", "HK" index "_Text", "HK" index "_KEY","HK" index "_CTRL", "HK" index "_ALT", "HK" index "_SHIFT")
		returnArray.HOTKEYS_KeysArray.Insert(keyID, "HK" index "_Toggle", "HK" index "_Text", "HK" index "_KEY","HK" index "_CTRL", "HK" index "_ALT", "HK" index "_SHIFT")
		hkToggle := (index=1)?(1) : (0)
		hkTxtCmd := (index=1)?("/hideout") : (index=2)?("/kick YourName") : (index=4)?("/oos") : ("Insert Command or Message")
		hkKeyCmd := (index=1)?("F2") : ("")
		returnArray.HOTKEYS_DefaultValues.Insert(keyID, hkToggle, hkTxtCmd, hkKeyCmd, "0", "0", "0")
		keyID+=6
	}
	
	returnArray.NOTIFICATIONS_HandlersArray := Object()
	returnArray.NOTIFICATIONS_HandlersArray.Insert(0, "NotifyTradeToggle", "NotifyTradeSound", "NotifyWhisperToggle", "NotifyWhisperSound", "NotifyWhisperTray", "NotifyWhisperFlash")
	returnArray.NOTIFICATIONS_HandlersKeysArray := Object()
	returnArray.NOTIFICATIONS_HandlersKeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Whisper_Toggle", "Whisper_Sound", "Whisper_Tray", "Whisper_Flash")
	returnArray.NOTIFICATIONS_KeysArray := Object()
	returnArray.NOTIFICATIONS_KeysArray.Insert(0, "Trade_Toggle", "Trade_Sound", "Trade_Sound_Path", "Whisper_Toggle", "Whisper_Sound", "Whisper_Sound_Path", "Whisper_Tray", "Whisper_Flash")
	returnArray.NOTIFICATIONS_DefaultValues := Object()
	returnArray.NOTIFICATIONS_DefaultValues.Insert(0, "1", "WW_MainMenu_Letter.wav", sfxFolderPath "\WW_MainMenu_Letter.wav", "0", "None", "", "1", "0")
	
	returnArray.MESSAGES_HandlersArray := Object()
	returnArray.MESSAGES_HandlersArray.Insert(0, "MessageWaitToggle", "MessageWait", "MessageInviteToggle","MessageInvite", "MessageThanksToggle","MessageThanks", "MessageSoldToggle", "MessageSold", "MessageSupportToggle")
	returnArray.MESSAGES_HandlersKeysArray := Object()
	returnArray.MESSAGES_HandlersKeysArray.Insert(0, "Wait_Text_Toggle", "Wait_Text", "Invite_Text_Toggle", "Invite_Text", "Thanks_Text_Toggle", "Thanks_Text", "Sold_Text_Toggle", "Sold_Text", "Support_Text_Toggle")
	returnArray.MESSAGES_KeysArray := Object()
	returnArray.MESSAGES_KeysArray.Insert(0, "Wait_Text_Toggle", "Wait_Text", "Invite_Text_Toggle", "Invite_Text", "Thanks_Text_Toggle", "Thanks_Text", "Sold_Text_Toggle", "Sold_Text", "Support_Text_Toggle")
	returnArray.MESSAGES_DefaultValues := Object()
	returnArray.MESSAGES_DefaultValues.Insert(0, "1", "@%buyerName% One moment please! (%itemName% // %itemPrice%)", "1", "@%buyerName% Your item is ready to be picked up at my hideout! (%itemName% // %itemPrice%)", "1", "@%buyerName% Thank you, good luck & have fun!", "1", "@%buyerName% The requested item was sold! (%itemName% // %itemPrice%)", "0")
	
	return returnArray
}

Get_Control_ToolTip(controlName) {
;			Retrieves the tooltip for the corresponding control
;			Return a variable conaining the tooltip content
	ShowInGame_TT := ShowAlways_TT := "Decide when should the GUI show."
	. "`nAlways show:" A_Tab . A_Tab "The GUI will always appear."
	. "`nOnly show while in game:" A_Tab "The GUI will only appear when the game's window is active."
	ShowTransparency_TT := "The GUI is click-through when it is inactive."
	. "`n"
	. "`nTransparency of the GUI when no trade is on queue."
	. "`nSetting the value to 0% will effectively make the GUI invisible."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on if it's active or inactive."
	ShowTransparencyActive_TT := "Transparency of the GUI when trades are on queue."
	. "`nThe minimal value is set to 30% to make sure you can still see the window."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on if it's active or inactive."
	
	DockSteam_TT := DockGGG_TT := "Mostly used when running two instancies, one being your shop and the other your main account"
	. "`nIf you run only one instancie of the game, make sure that both settings are set to the same PoE executable."
	. "`nWhen the window is not found, it will default on the top right of your primary monitor"
	. "`n"
	. "`nDecide on which window should the GUI dock to."
	. "`nGGG:" A_Tab "Dock the GUI to GGG'executable."
	. "`nSteam:" A_Tab "Dock the GUI to Steam's executable."
	
	LogsSteam_TT := LogsGGG_TT := "Mostly used when running two instancies, one being your shop and the other your main account"
	. "`nIf you run only one instancie of the game, make sure that both settings are set to the same PoE executable."
	. "`n"
	. "`nDecide which log file should be read."
	. "`nGGG:" A_Tab "Dock the GUI to GGG'executable."
	. "`nSteam:" A_Tab "Dock the GUI to Steam's executable."
	
	NotifyTradeBrowse_TT := NotifyTradeSound_TT := NotifyTradeToggle_TT := "Play a sound when you receive a trade message."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperBrowse_TT := NotifyWhisperSound_TT := NotifyWhisperToggle_TT := "Play a sound when you receive a whisper message."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperTray_TT := "Show a tray notification when you receive"
	. "`na whisper while the game window is not active."

	NotifyWhisperFlash_TT := "Make the game's window flash when you receive"
	. "`na whisper while the game window is not active."
	
	ClipTab_TT := ClipNew_TT := ClipNew_TT := "Automatically put an item's infos in clipboard"
	. "`nso you can easily ctrl+f ctrl+v in your stash to search for the item."
	. "`n"
	. "`nClipboard new items:" A_Tab . A_Tab "New trade item will be placed in clipboard."
	. "`nClipboard item on tab switch:" A_Tab "Active tab's item will be placed on clipboard."

	MessageSupportToggle_TT := ":)", MessageSupportToggleText_TT := "(:"
	
	HelpBtn2_TT := HelpBtn_TT := "Hover controls to get infos about their function."
	ApplyBtn3_TT := ApplyBtn2_TT := ApplyBtn_TT := "Do not forget that the game needs to be in ""Windowed"" or ""Windowed Fullscreen"" for the Trades GUI to work!"
		
	MessageSoldToggle_TT := MessageSold_TT := MessageWaitToggle_TT := MessageInvite_TT := MessageInviteToggle_TT := MessageThanks_TT := MessageThanksToggle_TT := MessageWait_TT := "Message that will be sent upon clicking the corresponding button."
	. "`nTick the case to enable."
	. "`nIf you wish to reset the message to default, delete its content and reload " programName "."

		
	Hotkey1_Toggle_TT := "Tick the case to enable this hotkey."
	Hotkey1_Text_TT := "Message that will be sent upon pressing this hotkey."
	Hotkey1_KEY_TT := "Hotkey to trigger this custom command/message."
	Hotkey1_CTRL_TT := "Enable CTRL as a modifier for this hotkey."
	Hotkey1_ALT_TT := "Enable ALT as a modifier for this hotkey."
	Hotkey1_SHIFT_TT := "Enable SHIFT as a modifier for this hotkey."
	Hotkey6_Toggle_TT := Hotkey5_Toggle_TT := Hotkey4_Toggle_TT := Hotkey3_Toggle_TT := Hotkey2_Toggle_TT := Hotkey1_Toggle_TT
	Hotkey6_Text_TT := Hotkey5_Text_TT := Hotkey4_Text_TT := Hotkey3_Text_TT := Hotkey2_Text_TT := Hotkey1_Text_TT
	Hotkey6_KEY_TT := Hotkey5_KEY_TT := Hotkey4_KEY_TT := Hotkey3_KEY_TT := Hotkey2_KEY_TT := Hotkey1_KEY_TT
	Hotkey6_CTRL_TT := Hotkey5_CTRL_TT := Hotkey4_CTRL_TT := Hotkey3_CTRL_TT := Hotkey2_CTRL_TT := Hotkey1_CTRL_TT
	Hotkey6_ALT_TT := Hotkey5_ALT_TT := Hotkey4_ALT_TT := Hotkey3_ALT_TT := Hotkey2_ALT_TT := Hotkey1_ALT_TT
	Hotkey6_SHIFT_TT := Hotkey5_SHIFT_TT := Hotkey4_SHIFT_TT := Hotkey3_SHIFT_TT := Hotkey2_SHIFT_TT := Hotkey1_SHIFT_TT
	
	try
		controlTip := % %controlName%_TT
;	if ( controlTip ) 
;		return controlTip
;	else 
;		controlTip := controlName ; Used to get the control tooltip
	return controlTip
}

;==================================================================================================================
;
;												UPDATE GUI
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
	Gui, Show
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
;												ABOUT GUI
;
;==================================================================================================================

Gui_About() {
	static
	global programChangelogFilePath, programRedditURL
	Gui, About:Destroy
	Gui, About:New, +HwndaboutGuiHandler +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs,% programName " by masato v" programVersion
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
		myLink := "www.google.com"
		Gui, Add, Link, xp yp+15,% "<a href=""https://github.com/lemasato/POE-Trades-Helper/"">GitHub</a> - "
		Gui, Add, Link, gReddit_Thread xp+45 yp,% "<a href="""">Reddit</a> - "
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
	Gui, Show, AutoSize
	
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
		Msgbox, 4096,:o,% "I would truely appreciate your support..."
		. "`nbut it'd be even better if you could talk about " programName " to your friends!"
		. "`n`nAltough, if you really wish to spend money on something..."
		. "`nI'd recommend you to get anything you like from POE MTX Shop!"
		. "`n(closing this window will open your browser to pathofexile.com/shop)"
		Run, % "https://www.pathofexile.com/shop"
	return

	Reddit_Thread:
		global programRedditURL
		Run, % programRedditURL
	Return
}

;==================================================================================================================
;
;											INI SETTINGS
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

	DetectHiddenWindows On
	WinGet, fileProcessName, ProcessName, ahk_pid %programPID%
	IniWrite,% fileProcessName,% iniFile,PROGRAM,FileProcessName
	DetectHiddenWindows, Off

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
;												MISC STUFF
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
		allSettings := Object()
		allSettings := Get_INI_Settings()
		for key, element in allSettings.KEYS {
			FileAppend,% allSettings.KEYS[A_Index] " is " allSettings.VALUES[A_Index] "`n",% programLogsFilePath
		}
	}
	if ( funcName = "Prevent_Multiple_Instancies" ) {
		existPID := paramsArray[0], thisPID := paramsArray[1]
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] -- Blocked new instancie from starting up: (Current PID: " thisPID " - Existing PID: " existPID ")", % programLogsFilePath
	}
	if ( funcName = "Send_InGame_Message" ) {
		gamePID := paramsArray[0], messageToSend := paramsArray[1]
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] -- Failed to send message to PID """ gamePID """ containing the following: """ messageToSend """", % programLogsFilePath
	}
	FileAppend,% "`n",% programLogsFilePath
}

Delete_Old_Logs_Files(filesToKeep) {
;			Make sure to only keep 10 (+current) logs file
;			Delete the older logs file
	global programLogsPath
	filesToKeep++ ; Or it will delete also the latest
	
	loop, %programLogsPath%\*.txt
	{
		filesNum := A_Index
		if ( A_LoopFileName != "changelog.txt" ) {
			allFiles .= A_LoopFileName "|"
		}
	}
	Sort, allFiles, D|
	split := StrSplit(allFiles, "|")
	if ( filesNum > filesToKeep ) {
		Loop {
			index := A_Index
			fileLocation := programLogsPath "\" split[A_Index]
			FileDelete,% fileLocation
			filesNum -= 1
			if ( filesNum <= filesToKeep )
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

Send_InGame_Message(messageToSend, infosArray="", goBackUp=0) {
;			Sends a message InGame and replace the "variables text" into their content
	global VALUE_Logs_Mode

	buyerName := infosArray[0], itemName := infosArray[1], itemPrice := infosArray[2], gamePID := infosArray[3]

	messageToSendRaw := messageToSend
	StringReplace, messageToSend, messageToSend, `%buyerName`%, %buyerName%, 1
	StringReplace, messageToSend, messageToSend, `%itemName`%, %itemName%, 1
	StringReplace, messageToSend, messageToSend, `%itemPrice`%, %itemPrice%, 1
	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx
	if WinExist("ahk_pid " gamePID) {
		WinActivate,.* ahk_pid %gamePID%
		WinWaitActive,.* ahk_pid %gamePID%
		SendInput,{Enter}/{BackSpace}
		SendInput,{Raw}%messageToSend%
		SendInput,{Enter}
	}
	else {
		paramsArray := Object()
		paramsArray.Insert(0, gamePID, messageToSend)
		Logs_Append(A_ThisFunc, paramsArray)
		SetTitleMatchMode, %titleMatchMode%
		Return
	}

	if ( goBackUp > 0 ) {
		SendInput,{Enter}{Up %goBackUp%}{Escape}	; Send back to the previous chat channel
	}

	SetTitleMatchMode, %titleMatchMode%
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
;			If an instancie already exist, close and replace it by this one
	IniRead, lastPID,% iniFilePath,PROGRAM,PID
	IniRead, lastProcessName,% iniFilePath,PROGRAM,FileProcessName

	if ( A_IsAdmin = 0 )
	Return ; Not running as admin means script will be reloaded soon as admin

	Process, Exist, %lastPID%
	existingPID := ErrorLevel
	if ( existingPID = 0 )
		Return ; pid doesn't exist
	else { ; pid exist
		DetectHiddenWindows, On ; required to find the process name
		WinGet, existingProcessName, ProcessName, ahk_pid %existingPID% ; get process name from pid
		DetectHiddenWindows, Off
		if ( existingProcessName = lastProcessName ) { ; pid exist and has same processname, close it
			Process, Close, %existingPID%
			Process, WaitClose, %existingPID%
		}
	}

}

GUI_Trades_Cycle:
	matchHandlers := Get_Matching_Window_Handlers()
	currentDockID++
	if ( currentDockID > matchHandlers.MaxIndex() )
		currentDockID := 0
	VALUE_Dock_Window := matchHandlers[currentDockID]
	Gui_Trades_Set_Position()
Return

Get_Matching_Window_Handlers() {
	WinGet windows, List
	matchHandlers := Object()
	index := 0
	Loop %windows%
	{
		id := windows%A_Index%
		WinGet ExeLocation, ProcessName,% "ahk_id " id
		if ExeLocation in %POEGameList%
		{
			matchHandlers.Insert(index, id)
			index++
		}
	}
	return matchHandlers
}

Create_Tray_Menu(globalDeclared=0) {
	static
	global VALUE_Trades_GUI_Mode
	if ( globalDeclared = 0 ) {
		Menu, Tray, DeleteAll
		Menu, Tray, Tip,% programName " v" programVersion
		Menu, Tray, NoStandard
		Menu, Tray, Add,Settings, Gui_Settings
		Menu, Tray, Add,About?, Gui_About
		Menu, Tray, Add, 
		Menu, Tray, Add,Cycle Overlay,GUI_Trades_Cycle
		Menu, Tray, Add, 
		Menu, Tray, Add,Mode: Overlay,GUI_Trades_Mode
		Menu, Tray, Add,Mode: Window,GUI_Trades_Mode
		Menu, Tray, Add, 
		Menu, Tray, Add,Reload, Reload_Func
		Menu, Tray, Add,Close, Exit_Func
	}
	else if ( globalDeclared = 1 ) {
		Menu, Tray, Check,% "Mode: " VALUE_Trades_GUI_Mode	
	}
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
		SetTimer, Display_ToolTip, -500 	; shorter wait, shows the tooltip quicker
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
		else {
			SetTimer, Remove_ToolTip, -1
		}
	return
	
	Remove_ToolTip:
		ToolTip
	return
}

Remove_TrayTip:
	TrayTip
Return


Run_As_Admin() {
;			Make sure the program is running as admin
;			Works for compiled and uncompiled scripts
	global 0
	IniWrite,% A_IsAdmin,% iniFilePath,PROGRAM,Is_Running_As_Admin
	if ( A_IsAdmin = 1 ) {
		IniWrite, 0,% iniFilePath,PROGRAM,Run_As_Admin_Attempts
		Return
	}

	IniRead, attempts,% iniFilePath,PROGRAM,Run_As_Admin_Attempts
	if ( attempts = "ERROR" || attempts = "" )
		attempts := 0
	attempts++
	IniWrite,% attempts,% iniFilePath,PROGRAM,Run_As_Admin_Attempts
	if ( attempts > 2 ) {

		IniWrite,0,% iniFilePath,PROGRAM,Run_As_Admin_Attempts
		MsgBox, 4100,% "Running as admin failed!",% "It seems " programName " was unable to run with admin rights previously."
		. "`nTry right clicking the executable and choose ""Run as Administrator""."
		. "`n`nPossible known causes could be:"
		. "`n-You are not using an account with administrative rights."
		. "`n-You are using an account with administrative right"
		. "`n    but declined the UAC prompt."
		. "`n-You are using an account with standard rights"
		. "`n    and the administrator disabled UAC."
		. "`n`nWoud you like to continue without admin rights?"
		. "`nYou will still be able to see the incoming trade requests."
		. "`nThough, some of the GUI buttons and the hotkeys will not work."
		IfMsgBox, Yes
		{
			return
		}
		IfMsgBox, Cancel
		{
			OnExit("Exit_Func", 0)
			ExitApp
		}
		IfMsgBox, No
		{
			OnExit("Exit_Func", 0)
			ExitApp
		}
	}
	SplashTextOn, 525, 80,% programName,% programName " needs to run with Admin privileges.`nOtherwise, you will encounter issues such as hotkeys and GUI buttons not working.`n`nAttempt to restart with admin rights in 3 seconds..."
	sleep 3000

	Loop, %0%
		params .= A_Space . %A_Index%
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath
	: A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	OnExit("Exit_Func", 0)
	ExitApp
}

Tray_Refresh()
{
;			Refreshes the Tray Icons, to remove any "leftovers"
;			Should work both for Windows 7 and 10
	WM_MOUSEMOVE := 0x200
	HiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, On
	TrayTitle := "AHK_class Shell_TrayWnd"
	ControlNN := "ToolbarWindow322"
	IcSz := 24
	Loop, 8
	{
		index := A_Index
		if ( index = 1 || index = 3 || index = 5 || index = 7 ) {
			IcSz := 24
		}
		else if ( index = 2 || index = 4 || index = 6 || index = 8 ) {
			IcSz := 32
		}
		if ( index = 1 || index = 2 ) {
			TrayTitle := "AHK_class Shell_TrayWnd"
			ControlNN := "ToolbarWindow322"
		}
		else if ( index = 3 || index = 4 ) {
			TrayTitle := "AHK_class NotifyIconOverflowWindow"
			ControlNN := "ToolbarWindow321"
		}
		if ( index = 5 || index = 6 ) {
			TrayTitle := "AHK_class Shell_TrayWnd"
			ControlNN := "ToolbarWindow321"
		}
		else if ( index = 7 || index = 8 ) {
			TrayTitle := "AHK_class NotifyIconOverflowWindow"
			ControlNN := "ToolbarWindow322"
		}
		ControlGetPos, xTray,yTray,wdTray,htTray, %ControlNN%, %TrayTitle%
		y := htTray - 10
		While (y > 0)
		{
			x := wdTray - IcSz/2
			While (x > 0)
			{
				point := (y << 16) + x
				PostMessage, %WM_MOUSEMOVE%, 0, %point%, %ControlNN%, %TrayTitle%
				x -= IcSz/2
			}
			y -= IcSz/2
		}
	}
	DetectHiddenWindows, %HiddenWindows%
	Return
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