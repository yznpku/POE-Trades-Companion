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
#NoEnv
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8 ; Required for cyrillic characters
#KeyHistory 0
ListLines Off
SetWinDelay, 0

;___Some_Variables___;
global userprofile, iniFilePath, programName, programVersion, programFolder, programPID, sfxFolderPath, programChangelogFilePath, POEGameArray, POEGameList
EnvGet, userprofile, userprofile
programVersion := "1.7.3", programRedditURL := "https://redd.it/57oo3h"
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
Close_Previous_Program_Instance()
Tray_Refresh()
Set_INI_Settings()
settingsArray := Get_INI_Settings()
Declare_INI_Settings(settingsArray)
Create_Tray_Menu(1)
Delete_Old_Logs_Files(10)
Do_Once()
Extract_Sound_Files()
Check_Update()
Enable_Hotkeys()

;___Window Switch Detect___;
Gui +LastFound 
Hwnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,Hwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")

Gui_Trades(,"Create")
;	Uncomment only for testing purposes -- Simulates trade tabs
;	Also comment the Monitor_Game_Logs() line, otherwise the GUI will be overwritten
	; newItemInfos := Object()
	; newItemInfos.Insert(0, "iSellStuff", "level 1 Faster Attacks Support", "5 alteration", "Breach (stash tab ""Gems""; position: left 6, top 8)", "",A_Hour ":" A_Min, "Offering 1alch?")
	; newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
	; Gui_Trades(newItemArray, "Update")
	; newItemInfos.Insert(0, "FIRST BUYER", "FIRST ITEM", "FIRST PRICE", "FIRST LOCATION", "",A_Hour ":" A_Min, "-")
	; newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
	; Gui_Trades(newItemArray, "Update")
	; newItemInfos.Insert(0, "SECOND BUYER", "SECOND ITEM", "SECOND PRICE", "SECOND LOCATION", "",A_Hour ":" A_Min, "-")
	; newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
	; Gui_Trades(newItemArray, "Update")
	; newItemInfos.Insert(0, "THIRD BUYER", "THIRD ITEM", "THIRD PRICE", "THIRD LOCATION", "",A_Hour ":" A_Min, "-")
	; newItemArray := Gui_Trades_Manage_Trades("Add_New", newItemInfos)
	; Gui_Trades(newItemArray, "Update")

;___Logs Monitoring AKA Trades GUI___;
;Gui_Settings()
Logs_Append("Start", settingsArray)
Monitor_Game_Logs()
Return

;==================================================================================================================
;
;										LOGS MONITORING
;
;==================================================================================================================

GUI_Replace_PID(handlersArray, gamePIDArray) {
;		GUI used when clicking one of the Trades GUI buttons and the PID is not associated with POE anymore
;		Provided two array containing all the POE handlers and PID, it allows the user to choose which PID to use as a replacement
	static

	Gui, ReplacePID:Destroy
	Gui, ReplacePID:New, +ToolWindow +AlwaysOnTop -SysMenu +hwndGUIInstancesHandler
	Gui, ReplacePID:Add, Text, x10 y10,% "The previous PID is no longer associated to a POE instance."
	Gui, ReplacePID:Add, Text, x10 y25,% "Please, select the new one you would like to use!"
	ypos := 30
	for key, element in handlersArray {
		index := A_Index - 1
		Gui, Add, Text, x10 yp+30,Executable:
		WinGet, pName, ProcessName,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly w150,% pName
		Gui, Add, Button,xp+155 yp-2 gGUI_Replace_PID_Continue vContinue%index%,Continue with this one
		Gui, Add, Text, x10 yp+32,Path:
		WinGet, pPath, ProcessPath,ahk_id %element%
		Gui, Add, Edit, xp+55 yp-3 ReadOnly,% pPath
		if ( index != handlersArray.MaxIndex() ) ; Put a 10px margin if it's not the last element
			Gui, Add, Text, w0 h0 xp yp+10
		Logs_Append(A_ThisFunc,,element,pPath)
	}
	Gui, ReplacePID:Show,NoActivate,% programName " - Replace PID"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Replace_PID_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := gamePIDArray[btnID]
		Gui, ReplacePID:Destroy
;		Logs_Append("GUI_Multiple_Instances_Return",,r)
	Return
}

GUI_Multiple_Instances(handlersArray) {
;		GUI used when multiple instances of POE running in different folders have been found upon running the Monitor_Logs() function
;		Provided an array containing all the POE handlers, it allows the user to choose which logs file to monitor
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
		if ( index != handlersArray.MaxIndex() ) ; Put a 10px margin if it's not the last element
			Gui, Add, Text, w0 h0 xp yp+10
		Logs_Append(A_ThisFunc,,element,pPath)
	}
	Gui, Instances:Show,NoActivate,% programName " - Multiple instances found"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Multiple_Instances_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := handlersArray[btnID]
		Gui, Instances:Destroy
		Logs_Append("GUI_Multiple_Instances_Return",,r)
	Return
}

Restart_Monitor_Game_Logs() {
;		
	static
	global GuiTradesHandler, iniFilePath

	WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
	IniWrite,% xpos,% iniFilePath,PROGRAM,X_POS
	IniWrite,% ypos,% iniFilePath,PROGRAM,Y_POS
	Monitor_Game_Logs("close")
	Monitor_Game_Logs()
}

Get_All_Games_Instances() {
	static
	global VALUE_Dock_Window
	WinGet windows, List
	matchHandlers := Get_Matching_Windows_Infos("ID")

	if ( matchHandlers.MaxIndex() = "" ) { ; No matching process found
		return "exenotfound"
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

	r := logsFile
	return r
}

Monitor_Game_Logs(mode="") {
;			Gets the logs location based on VALUE_Logs_Mode
;			Read through the logs file for new whisper/trades
;			Pass the trade message infos to Gui_Trades()
;			Clipboard the item's info if the user enabled
;			Play a sound or tray notification (if the user enabled) on whisper/trade
	static
	global VALUE_Whisper_Tray, VALUE_Logs_Mode, VALUE_Clip_New_Items, VALUE_Trade_Toggle, VALUE_Trade_Sound_Path, VALUE_Whisper_Toggle, VALUE_Whisper_Sound_Path, VALUE_Whisper_Flash, GuiTradesHandler, POEGameArray, VALUE_Dock_Window, VALUE_Last_Whisper

	if (mode = "close") {
		fileObj.Close()
		Return
	}

	IniRead, tX,% iniFilePath,PROGRAM,X_POS
	IniRead, tY,% iniFilePath,PROGRAM,Y_POS
	tX := (tX="ERROR"||tX=""||(!tX && tX != 0))?("unspecified"):(tX)
	tY := (tY="ERROR"||tY=""||(!tY && tY != 0))?("unspecified"):(tY)
	r := Get_All_Games_Instances()
	if ( r = "exenotfound" ) {
		messagesArray := Gui_Trades_Manage_Trades("Get_All")
		Gui_Trades(messagesArray, "exenotfound",tX,tY)
	}
	else {
		messagesArray := Gui_Trades_Manage_Trades("Get_All")
		Gui_Trades(messagesArray, "Update",tX,tY)
		logsFile := r
	}
	Logs_Append(A_ThisFunc,,logsFile)

	fileObj := FileOpen(logsFile, "r")
	fileObj.pos := fileObj.length
	Loop {
		if ( !( FileExist(logsFile) ) || ( fileObj.pos > fileObj.length ) || fileObj.pos = -1 ) ||  {
			Logs_Append("Monitor_Game_Logs_Break",,fileObj.pos,fileObj.length)
			Break
		}
		if ( fileObj.pos < fileObj.length ) {
			lastMessage := fileObj.Read() ; Stores the last message into a var
			Loop, parse, lastMessage, `n, `r ; This makes sure to not skip messages, when receiving multiple at once
			{
				if ( RegExMatch( A_LoopField, ".*\[.*\D+(.*)\].*@(?:From|De|От кого) (.*?): (.*)", subPat ) ) ; Whisper found --  (.*?) makes sure to stop at the first ":", fixing the "stash tab:" error
				{
					gamePID := subPat1, whispName := subPat2, whispMsg := subPat3
					VALUE_Last_Whisper := whispName
					if ( VALUE_Whisper_Tray = 1 ) && !( WinActive("ahk_pid " gamePID) ) {
						TrayTip, Whisper Received:,%whispName%: %whispMsg%
						TrayTip, Whisper Received:,%whispName%: %whispMsg%
						SetTimer, Remove_TrayTip, -10000
						if ( VALUE_Whisper_Toggle = 1 ) && ( FileExist(VALUE_Whisper_Sound_Path) )
							SoundPlay,%VALUE_Whisper_Sound_Path%
					}
					if ( VALUE_Whisper_Flash = 1 ) && !( WinActive("ahk_pid " gamePID) ) {
						gameHwnd := WinExist("ahk_pid " gamePID)
						DllCall("FlashWindow", UInt, gameHwnd, Int, 1) ; Flashes the game window
					}
					messages := whispName . ": " whispMsg "`n"
					if ( RegExMatch( messages, ".*: (.*)Hi, I(?: would|'d) like to buy your (?:(.*) |(.*))(?:listed for (.*)|for my (.*)|)(?!:listed for|for my) in (?:(.*)\(.*""(.*)""(.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)", subPat ) ) ; Trade message found
					{
			
						tradeItem := (subPat2)?(subPat2):(subPat3)?(subPat3):("ERROR retrieving ITEM")
						tradePrice := (subPat4)?(subPat4):(subPat5)?(subPat5):("Unpriced Item")
						tradeStash := (subPat6)?(subPat6 "- " subpat7 " " subPat8):(subPat9)?("Hardcore " subPat9):(subPat10)?(subPat10):("ERROR retrieving LOCATION")
						tradeOther := (subPat10!=subPat6 && subPat10!=subPat9 && subPat10!=tradeStash)?(subPat1 subPat10):(subPat11 && subPat11!="`n")?(subPat11):("-")
						tradeItem = %tradeItem%
						tradePrice = %tradePrice%
						tradeStash = %tradeStash%
						tradeOther = %tradeOther%
						if tradeItem contains % " 0`%"
							StringReplace, tradeItem, tradeItem, 0`% ; Removes 0% from the string, allowing us to stash search it
;						__TO_BE_ADDED__
	;					A way to know when the item being sold is currency, so we only copy that currency's name and not the entire string (ex: "50 chaos")
	;					if ( RegExMatch( messages, ".*Hi, I'd like to buy your .* for my .* in .*", subPat ) ) ; Trade message found
						newTradesInfos := Object()
						newTradesInfos.Insert(0, whispName, tradeItem, tradePrice, tradeStash, gamePID, A_Hour ":" A_Min, tradeOther)
						messagesArray := Gui_Trades_Manage_Trades("Add_New", newTradesInfos)
						if WinExist("ahk_id " GuiTradesHandler)
							WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
						Gui_Trades(messagesArray, "Update",xpos, ypos)
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
		. "`n`nThe logs monitoring function will be restarting in 5 seconds."
	}
	sleep 5000
	Restart_Monitor_Game_Logs()
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

Hotkeys_User_7:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_8:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_9:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_10:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_11:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_12:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_13:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_14:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_15:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_16:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_Handler(thisLabel) {
	static
	global VALUE_Hotkeys_Mode
	tradesInfosArray := Object()
	tabID := Gui_Trades_Get_Tab_ID()
	if ( tabID != 0 ) {
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(tabID) ; [0] buyerName - [1] itemName - [2] itemPrice
	}
	if ( VALUE_Hotkeys_Mode = "Advanced" ) {
		key := (thisLabel="Hotkeys_User_1")?("HK1"):(thisLabel="Hotkeys_User_2")?("HK2"):(thisLabel="Hotkeys_User_3")?("HK3"):(thisLabel="Hotkeys_User_4")?("HK4"):(thisLabel="Hotkeys_User_5")?("HK5"):(thisLabel="Hotkeys_User_6")?("HK6"):(thisLabel="Hotkeys_User_7")?("HK7"):(thisLabel="Hotkeys_User_8")?("HK8"):(thisLabel="Hotkeys_User_9")?("HK9"):(thisLabel="Hotkeys_User_10")?("HK10"):(thisLabel="Hotkeys_User_11")?("HK11"):(thisLabel="Hotkeys_User_12")?("HK12"):(thisLabel="Hotkeys_User_13")?("HK13"):(thisLabel="Hotkeys_User_14")?("HK14"):(thisLabel="Hotkeys_User_15")?("HK15"):(thisLabel="Hotkeys_User_16")?("HK16"):("ERROR")
		IniRead, textToSend,% iniFilePath,HOTKEYS_ADVANCED,% key "_ADV_TEXT"
	}
	else {
		key := (thisLabel="Hotkeys_User_1")?("HK1"):(thisLabel="Hotkeys_User_2")?("HK2"):(thisLabel="Hotkeys_User_3")?("HK3"):(thisLabel="Hotkeys_User_4")?("HK4"):(thisLabel="Hotkeys_User_5")?("HK5"):(thisLabel="Hotkeys_User_6")?("HK6"):("ERROR")
		IniRead, textToSend,% iniFilePath,HOTKEYS,% key "_TEXT"
	}
	;Send_InGame_Message(textToSend, 0, 2) ; __TO_BE_ADDED__ Go back to the previous channel
	Send_InGame_Message(textToSend, tradesInfosArray,1)
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
	static tabWidth, tabHeight, tradesCount, index, element, varText, varName, tabName, trans, priceArray, btnID, Clipboard_Backup, itemArray, itemName, itemPrice, messageToSend
	static nameArray, buyerName, guiX, guiY, guiHeight, guiWidth, defaultX, defaultY

	if ( errorMsg = "Create" ) {
		defaultMaxTabs := 10

		Gui, Trades:Destroy
		Gui, Trades:New, +ToolWindow +AlwaysOnTop -Border +hwndGuiTradesHandler +LabelGui_Trades_ +LastFound -SysMenu -Caption
		Gui, Trades:Default
		tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390
		guiWidth := 403, guiHeight := tabHeight + 38
		Gui, Add, Text,% "x0 y0 w" guiWidth " h25 +0x4 gGui_Trades_Move hwndguiTradesMoveHandler",% ""
		Gui, Add, Text,% "x5 y0 w" guiWidth " h25 cFFFFFF BackgroundTrans +0x200 hwndguiTradesTitleHandler",% programName " - Queued Trades: 0"
		Gui, TradesMin:Destroy
		Gui, TradesMin:-Caption +Parent%guiTradesMoveHandler%
		Gui, TradesMin:Color, 696969
		Gui, TradesMin:Margin, 0, 0
		Gui, TradesMin:Add, Text,% "x" 0 " y0 h25 cFFFFFF BackgroundTrans Section +0x200 gGui_Trades_Minimize",% "MINIMIZE"
		Gui, Trades:Default
		Gui, Add, Text,% "x0 y0 w5 h" guiHeight " +0x4",% "" ; Left
		Gui, Add, Text,% "x0 y" guiHeight - 5 " w" guiWidth + 5 " h5 +0x4",% "" ; Bottom
		Gui, Add, Text,% "x" guiWidth " y0 w5 h" guiHeight " +0x4",% "" ; Right
		
		aeroStatus := Get_Aero_Status()
		if ( aeroStatus = 1 )
			themeState := "+Theme -0x8000"
		else
			themeState := "-Theme +0x8000"

		tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390
		Gui, Add, Tab3,x10 y30 vTab gGui_Trades_OnTabSwitch w%tabWidth% h%tabHeight% %themeState% -Wrap
		VALUE_Trades_GUI_Current_State := "Active"
		IniRead, tabsMax,% iniFilePath, PROGRAM, Rendered_Tabs
		tabsMax := (tabsMax="ERROR"||tabsMax=""||!tabsMax)?(2):(tabsMax)
		if ( tabsMax > 25 ) {
			Loop 2
				TrayTip,% programName,Rendering more tabs,3
			SetTimer, Remove_TrayTip,-3000
		}
		Loop %tabsMax% {
			index := A_Index
			GuiControl, ,Tab,% index
			Gui, Tab,% index

			Gui, Add, Text, x345 y53 w30 h15 vTimeSlot%index%,% ""
			Gui, Add, Text, x20 y58 w45 h15 hwndBuyerText%index%Handler,% "Buyer: "
			Gui, Add, Text, xp+50 yp w270 h15 vBuyerSlot%index%,
			Gui, Add, Text, w45 h15 xp-50 yp+15 hwndItemText%index%Handler,% "Item: "
			Gui, Add, Text, w325 h15 xp+50 yp vItemSlot%index%,
			Gui, Add, Text, w45 h15 xp-50 yp+15 hwndPriceText%index%Handler,% "Price: "
			Gui, Add, Text, w325 h15 xp+50 yp vPriceSlot%index%,
			if ( infosArray.PRICES[index] = "Unpriced Item")
				GuiControl, Trades: +cRed, PriceSlot%index%
			Gui, Add, Text, w45 h15 xp-50 yp+15 hwndLocationText%index%Handler,% "Location: "
			Gui, Add, Text, w325 h15 xp+50 yp vLocationSlot%index%,
			Gui, Add, Text, w45 h15 xp-50 yp+15 hwndOtherText%index%Handler,% "Other: "
			Gui, Add, Text, w325 h15 xp+50 yp vOtherSlot%index%,
			Gui, Add, Text, w0 h0 xp yp vPIDSlot%index%,
			Gui, Add, Button,w20 h20 x377 y51 vdelBtn%index% %themeState% gGui_Trades_RemoveItem hwndCloseBtn%index%Handler,% "X"

			Loop 9 {
				Gui, Tab,% index
				btnW := (VALUE_Button%A_Index%_SIZE="Small")?(119):(VALUE_Button%A_Index%_SIZE="Medium")?(244):(VALUE_Button%A_Index%_SIZE="Large")?(369):("ERROR")
				btnX := (VALUE_Button%A_Index%_H="Left")?(20):(VALUE_Button%A_Index%_H="Center")?(145):(VALUE_Button%A_Index%_H="Right")?(270):("ERROR")
				btnY := (VALUE_Button%A_Index%_V="Top")?(135):(VALUE_Button%A_Index%_V="Middle")?(175):(VALUE_Button%A_Index%_V="Bottom")?(215):("ERROR")
				btnName := VALUE_Button%A_Index%_Label
				btnSub := RegExReplace(VALUE_Button%A_Index%_Action, "[ _+()]", "_")
				btnSub := RegExReplace(btnSub, "___", "_")
				btnSub := RegExReplace(btnSub, "__", "_")
				btnSub := RegExReplace(btnSub, "_", "", ,1,-1)
				if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnSub != "" && btnSub != "ERROR" ) {
					Gui, Add, Button,x%btnX% y%btnY% w%btnW% h35 vCustomBtn%A_Index%_%index% gGui_Trades_%btnSub%,% btnName
				}
			}
		}
		Progress, Off
	}

	if ( errorMsg = "Update" || errorMsg = "Create" || errorMsg = "exenotfound" ) {
		tabID := Gui_Trades_Get_Tab_ID()
		tabsCount := infosArray.BUYERS.Length()
		allTabs := ""
		for key, element in infosArray.BUYERS {
			allTabs .= "|" key
			GuiControl, Trades:,buyerSlot%key%,% infosArray.BUYERS[key]
			GuiControl, Trades:,itemSlot%key%,% infosArray.ITEMS[key]
			GuiControl, Trades:,priceSlot%key%,% infosArray.PRICES[key]
			GuiControl, Trades:,locationSlot%key%,% infosArray.LOCATIONS[key]
			GuiControl, Trades:,PIDSlot%key%,% infosArray.GAMEPID[key]
			GuiControl, Trades:,TimeSlot%key%,% infosArray.TIME[key]
			GuiControl, Trades:,OtherSlot%key%,% infosArray.OTHER[key]
		}
		if ( tabsCount = 0 || tabsCount = "" ) {
			tabsCount := 0
			allTabs := "|Monitoring"
			showState := "Hide"
			txtColor := "White"
			if ( errorMsg = "exenotfound" )
				GuiControl, Trades:,% BuyerText1Handler,% "`n`nProcess not found, retrying in 10 seconds...`n`nRight click on the tray icon,`nthen [Settings] to set your preferences."
			else
				GuiControl, Trades:,% BuyerText1Handler,% "`n`nNo trade on queue!`n`nRight click on the tray icon,`nthen [Settings] to set your preferences."
			GuiControl, Trades:Move,% BuyerText1Handler,w%guiWidth% h%guiHeight%
			GuiControl, Trades:+0x1,% BuyerText1Handler,
			VALUE_Trades_GUI_Current_State := "Inactive"
			if ( VALUE_Trades_Click_Through )
				Gui, Trades: +E0x20
			WinSet, Transparent,% VALUE_Transparency
		}
		else {
			showState := "Show"
			txtColor := "Yellow"
			GuiControl, Trades:Move,% BuyerText1Handler,w45 h15
			GuiControl, Trades:,% BuyerText1Handler,Buyer:
			GuiControl, Trades:-0x1,% BuyerText1Handler,
			VALUE_Trades_GUI_Current_State := "Active"
			Gui, Trades: -E0x20
			WinSet, Transparent,% VALUE_Transparency_Active
		}
		Gui, Trades:Font, c%txtColor%
		GuiControl, Trades:Font,% guiTradesTitleHandler
		GuiControl, Trades:Text,% guiTradesTitleHandler,% programName " - Queued Trades: " tabsCount ; Update the GUI Title
;		Hide or show the controls
		Loop 9 {
			GuiControl, Trades:%showState%,CustomBtn%A_Index%_1
		}
		GuiControl, Trades:%showState%,buyerSlot1
		GuiControl, Trades:%showState%,ItemSlot1
		GuiControl, Trades:%showState%,PriceSlot1
		GuiControl, Trades:%showState%,LocationSlot1
		GuiControl, Trades:%showState%,TimeSlot1
		GuiControl, Trades:%showState%,OtherSlot1
		GuiControl, Trades:%showState%,% ItemText1Handler
		GuiControl, Trades:%showState%,% PriceText1Handler
		GuiControl, Trades:%showState%,% LocationText1Handler
		GuiControl, Trades:%showState%,% CloseBtn1Handler
		GuiControl, Trades:%showState%,% OtherText1Handler
		GuiControl, Trades:,Tab,% allTabs
		GuiControl, Trades:Choose,Tab,%tabID%
		if ( ErrorLevel )
			GuiControl, Trades:Choose,Tab,% tabID-1

		if (tabsCount >= tabsMax - 1 && tabsMax != 255) {
			tabsMax := (tabsMax=defaultMaxTabs)?(25):(tabsMax=25)?(50):(tabsMax=50)?(100):(tabsMax=100)?(255):(50)
			IniWrite,% tabsMax,% iniFilePath,PROGRAM,Rendered_Tabs
			tradesArray := Gui_Trades_Manage_Trades("Get_All")
			WinGetPos, guiX, guiY, , ,% "ahk_id " GuiTradesHandler
			Gui_Trades(tradesArray,"Create",guiX,guiY)
			Return
		}
		if (tabsCount=0 && tabsMax>defaultMaxTabs) {
			tabsMax := defaultMaxTabs
			IniWrite,% tabsMax,% iniFilePath,PROGRAM,Rendered_Tabs
			tradesArray := Gui_Trades_Manage_Trades("Get_All")
			WinGetPos, guiX, guiY, , ,% "ahk_id " GuiTradesHandler
			Gui_Trades(tradesArray,"Create")
			Gui_Trades(,"Update",guiX,guiY)
			Return
		}
	}

	WinSet, Redraw, ,% "ahk_id " guiTradesHandler ; Make sure to update the GUI appearance (the custom "title bar" would sometimes disappear)
	IniWrite,% tabsCount,% iniFilePath,PROGRAM,Tabs_Number
	if ( errorMsg != "Create" ) {
		defaultX := A_ScreenWidth-(guiWidth+5), defaultY := 0
		xpos := (xpos="unspecified" || xpos="" || (!xpos && xpos!=0))?(defaultX):(xpos)
		ypos := (ypos="unspecified" || ypos="" || (!ypos && ypos!=0))?(defaultY):(ypos)
		Gui, Trades:Show,% "NoActivate w" guiWidth+5 " h" guiHeight " x" xpos " y" ypos,% programName " - Queued Trades"
		dpiFactor := Get_DPI_Factor()
		Gui, TradesMin:Show,% "x" (guiWidth-49)*dpiFactor " y0"

		if ( VALUE_Trades_Select_Last_Tab = 1 )
			GuiControl, Trades:Choose,Tab,% tabsCount

		if ( VALUE_Trades_Auto_Minimize || VALUE_Trades_Auto_UnMinimize ) {
			if ( VALUE_Trades_Auto_Minimize && tabsCount = 0 ) {
				VALUE_Trades_GUI_Minimized := 0
				GoSub, Gui_Trades_Minimize
			}
			else if ( VALUE_Trades_Auto_UnMinimize && tabsCount > 0 ) {
				VALUE_Trades_GUI_Minimized := 1
				GoSub, Gui_Trades_Minimize
			}
		}
	}
	if ( errorMsg = "exenotfound" ) {
		countdown := 10
		Loop 11 {
			GuiControl, Trades:,% BuyerText1Handler,% "`n`nProcess not found, retrying in " countdown " seconds...`n`nRight click on the tray icon,`nthen [Settings] to set your preferences."
			countdown--
			sleep 1000
		}
		WinGetPos, guiX, guiY, , ,% "ahk_id " GuiTradesHandler
		IniWrite,% guiX,% iniFilePath,PROGRAM,X_POS
		IniWrite,% guiY,% iniFilePath,PROGRAM,Y_POS
		Monitor_Game_Logs()
	}
	if ( VALUE_Trades_GUI_Mode = "Overlay") {
		try	Gui_Trades_Set_Position()
	}
	sleep 10
	return

	Gui_Trades_Minimize:
		VALUE_Trades_GUI_Minimized := !VALUE_Trades_GUI_Minimized
		tHeight := tradesGuiHeight
		if ( VALUE_Trades_GUI_Minimized ) {
			Loop {
				if ( tHeight = 25 )
					Break
				tHeight := (25<tHeight)?(tHeight-30):(25)
				tHeight := (tHeight-30<25)?(25):(tHeight)
				Gui, Trades:Show, NoActivate h%tHeight%
				sleep 1
			}
		}
		else  {
			Loop {
				if ( tHeight = guiHeight )
					Break
				tHeight := (guiHeight>tHeight)?(tHeight+30):(guiHeight)
				tHeight := (tHeight+30>guiHeight)?(guiHeight):(tHeight)
				Gui, Trades:Show, NoActivate h%tHeight%
				sleep 1
			}
		}
		sleep 10
	Return

	Gui_Trades_Move:
		if ( VALUE_Trades_GUI_Mode = "Window" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " guiTradesHandler
		}
	Return 

	Gui_Trades_Close:
	Return

	Gui_Trades_Escape:
	Return

	Gui_Trades_Clipboard_Item:
		btnID := Gui_Trades_Get_Tab_ID(A_GuiControl)
		if ( btnID = "0" )
			return
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(btnID) ; [0] buyerName - [1] itemName - [2] itemPrice
		Clipboard := tradesInfosArray[1]
	Return

	Gui_Trades_Message_Basic:
		RegExMatch(A_GuiControl, "\d+", btnID)
		tabID := Gui_Trades_Get_Tab_ID()
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(tabID)
		Send_InGame_Message(VALUE_Button%btnID%_Message, tradesInfosArray)
	Return

	Gui_Trades_Message_Basic_Close_Tab:
		RegExMatch(A_GuiControl, "\d+", btnID)
		tabID := Gui_Trades_Get_Tab_ID()
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(tabID)
		Send_InGame_Message(VALUE_Button%btnID%_Message, tradesInfosArray)
		if ( VALUE_Support_Text_Toggle = 1 )
			Send_InGame_Message("@%buyerName% - - - POE Trades Helper: Keep track of your trades! // Look it up! (not a bot!)", tradesInfosArray)
		Gosub, Gui_Trades_RemoveItem
	Return

	Gui_Trades_Message_Advanced:
		RegExMatch(A_GuiControl, "\d+", btnID)
		tabID := Gui_Trades_Get_Tab_ID()
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(tabID)
		Send_InGame_Message(VALUE_Button%btnID%_Message, tradesInfosArray,0,1)
	Return

	Gui_Trades_Message_Advanced_Close_Tab:
		RegExMatch(A_GuiControl, "\d+", btnID)
		tabID := Gui_Trades_Get_Tab_ID()
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(tabID)
		Send_InGame_Message(VALUE_Button%btnID%_Message, tradesInfosArray,0,1)
		if ( VALUE_Support_Text_Toggle = 1 )
			Send_InGame_Message("@%buyerName% - - - POE Trades Helper: Keep track of your trades! // Look it up! (not a bot!)", tradesInfosArray)
		Gosub, Gui_Trades_RemoveItem
	Return
	
	Gui_Trades_OnTabSwitch:
;		Clipboard the item's infos on tab switch if the user enabled
		Gui, Submit, NoHide
		tabID := Gui_Trades_Get_Tab_ID()
		tradesInfosArray := Object()
		tradesInfosArray := Gui_Trades_Get_Trades_Infos(tabID) ; [0] buyerName - [1] itemName - [2] itemPrice
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
		Gui_Trades(messagesArray, "Update",xpos, ypos)
	return

	Gui_Trades_Size:
;		Declare the GUI width and height
		tradesGuiWidth := A_GuiWidth
		tradesGuiHeight := A_GuiHeight
	return
}

Gui_Trades_Get_Tab_Height() {
	static
	global VALUE_Button1_SIZE, VALUE_Button2_SIZE, VALUE_Button3_SIZE, VALUE_Button4_SIZE
	global VALUE_Button5_SIZE, VALUE_Button6_SIZE, VALUE_Button7_SIZE, VALUE_Button8_SIZE, VALUE_Button9_SIZE
	global VALUE_Button1_V, VALUE_Button2_V, VALUE_Button3_V, VALUE_Button4_V
	global VALUE_Button5_V, VALUE_Button6_V, VALUE_Button7_V, VALUE_Button8_V, VALUE_Button9_V

	tabHeight := 145
	Loop 9 {
		index := A_Index
		if ( VALUE_Button%index%_SIZE != "Disabled" ) {
			if ( VALUE_Button%index%_V = "Middle" && tabHeight = 145 )
				tabHeight := 185
			if ( VALUE_Button%index%_V = "Bottom" && ( tabHeight = 145 || tabHeight = 185 ) )
				tabHeight := 225
		}
	}
	return tabHeight
}

GUI_Trades_Mode:
	Gui_Trades_Mode_Func(A_ThisMenuItem)
Return

Gui_Trades_Mode_Func(thisMenuItem) {
	static
	global VALUE_Trades_GUI_Mode, iniFilePath
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
}

Gui_Trades_Get_Tab_ID(controlName=""){
	static
	GuiControlGet, tabID, Trades:, Tab
	return tabID
}

Gui_Trades_Get_Trades_Infos(btnID){
;	Used by the Send_InGame_Message function
;	Allows to retrieve the trades variable
	static
	GuiControlGet, buyerName, Trades:,buyerSlot%btnID%
	GuiControlGet, itemName, Trades:,itemSlot%btnID%
	GuiControlGet, itemPrice, Trades:,priceSlot%btnID%
	GuiControlGet, thisPID, Trades:,PIDSlot%btnID%
	returnArray := Object()
	returnArray.Insert(0, buyerName, itemName, itemPrice, thisPID)
	return returnArray
}

Gui_Trades_Set_Trades_Infos(newPID){
;	Used by the Send_InGame_Message function
;	Allows to set the new PID to the trades
	static
	Loop {
		index := A_Index
		infosArray := Gui_Trades_Get_Trades_Infos(index)
		if ( infosArray[0] )
			GuiControl,Trades:,PIDSlot%index%,% newPID
		else
			Break
	}
}

Gui_Trades_Manage_Trades(mode="", newItemInfos=""){
;		Allows to retrieve all current trades, add a new or or remove the currently active tab
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
	returnArray.TIME := Object()
	returnArray.OTHER := Object()
	btnID := Gui_Trades_Get_Tab_ID()

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

	;	___TIME___
		Loop {
			timeCount := A_Index
			GuiControlGet, content, Trades:,TimeSlot%A_Index%
			if ( content ) {
				returnArray.TIME.Insert(A_Index, content)
			}
			else break
		}
	;	___OTHER___
		Loop {
			otherCount := A_Index
			GuiControlGet, content, Trades:,OtherSlot%A_Index%
			if ( content ) {
				returnArray.OTHER.Insert(A_Index, content)
			}
			else break
		}
	}

	if ( mode = "Add_New") {
		name := newItemInfos[0], item := newItemInfos[1], price := newItemInfos[2], location := newItemInfos[3], gamePID := newItemInfos[4], time := newItemInfos[5], other := newItemInfos[6]
		name := Gui_Trades_RemoveGuildPrefix(name)
		returnArray.COUNT.Insert(0, bCount)
		returnArray.BUYERS.Insert(bCount, name)
		returnArray.ITEMS.Insert(iCount, item)
		returnArray.PRICES.Insert(pCount, price)
		returnArray.LOCATIONS.Insert(lCount, location)
		returnArray.GAMEPID.Insert(PIDCount, gamePID)
		returnArray.TIME.Insert(timeCount, time)
		returnArray.OTHER.Insert(timeCount, other)
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
		counter--
		GuiControl,,buyerSlot%counter%,% "" ; Empties the slot content

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
		counter--
		GuiControl,,itemSlot%counter%,% ""
		
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
		counter--
		GuiControl,,priceSlot%counter%,% ""
		
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
		counter--
		GuiControl,,locationSlot%counter%,% ""

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
		counter--
		GuiControl,,PIDSlot%counter%,% ""

;	___TIME___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,TimeSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.TIME.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,,TimeSlot%counter%,% ""

;	___OTHER___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,OtherSlot%counter%
			if ( content ) {
				index := A_Index
				returnArray.Other.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,,OtherSlot%counter%,% ""
	}

	return returnArray
}

Gui_Trades_RemoveGuildPrefix(name) {
;			Remove the guild prefix
	static
	AutoTrim, On
	RegExMatch(name, "<.*>(.*)", namePat) ; name contains guild prefix, remove it
	if ( namePat1 )
		name := namePat1
	name = %name% ; Removes whitespaces
	return name
}

Gui_Trades_Set_Position(xpos="unspecified", ypos="unspecified"){
;			Refresh the Trades GUI position
	static
	global VALUE_Trades_GUI_Mode, tradesGuiWidth, tradesGuiHeight, GuiTradesHandler, VALUE_Trades_GUI_Last_State, VALUE_Trades_GUI_Current_State, VALUE_Dock_Window, VALUE_Trades_GUI_Mode

;	Gui, Trades:Show,% "NoActivate w" guiWidth+5 " h" guiHeight " x" xpos " y" ypos,% programName " - Queued Trades"

	dpiFactor := Get_DPI_Factor()
	if ( VALUE_Trades_GUI_Mode = "Window" && xpos != "unspecified" && ypos != "unspecified" ) {
		if ( VALUE_Trades_GUI_Last_State = "Inactive" && VALUE_Trades_GUI_Current_State = "Active" ) ; Inactive and Active GUI have different size, so we have to compensate when switching from one to another
			xpos := xpos - (65*dpiFactor)
		else if ( VALUE_Trades_GUI_Last_State = "Active" && VALUE_Trades_GUI_Current_State = "Inactive")
			xpos := xpos + (65*dpiFactor)
		Gui, Trades:Show,% "x" xpos " y" ypos " NoActivate"
	}
	else {
		if ( WinExist("ahk_id " VALUE_Dock_Window ) ) {
			WinGetPos, winX, winY, winWidth, winHeight, ahk_id %VALUE_Dock_Window%
			xpos := ( (winX+winWidth)-tradesGuiWidth * dpiFactor ), ypos := winY
			WinGet, isMinMax, MinMax,% "ahk_id " VALUE_Dock_Window ; -1: Min | 1: Max | 0: Neither
			xpos := (isMinMax=1)?(xpos-8):(isMinMax=-1)?(((A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor):(xpos)
			ypos := (isMinMax=1)?(ypos+8):(isMinMax=-1)?(0):(ypos)
			if xpos is not number
				xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor )
			if ypos is not number
				ypos := 0
			Gui, Trades:Show, % "x" xpos " y" ypos " NoActivate"
		}
		else {
			xpos := ( ( (A_ScreenWidth/dpiFactor) - tradesGuiWidth ) * dpiFactor )
			Gui, Trades:Show, % "x" xpos " y0" " NoActivate"
		}
	}
	VALUE_Trades_GUI_Last_State := VALUE_Trades_GUI_Current_State ; backup of the old state, so we know when we switch from one to another
	Logs_Append(A_ThisFunc,, xpos, ypos)
}


;==================================================================================================================
;
;												SETTINGS GUI
;
;==================================================================================================================

Gui_Settings() {
	static
	iniFile := iniFilePath
	global Hotkey1_KEYHandler, Hotkey2_KEYHandler, Hotkey3_KEYHandler, Hotkey4_KEYHandler, Hotkey5_KEYHandler, Hotkey6_KEYHandler, VALUE_Hotkeys_Mode
	
	guiCreated := 0
	OnMessage(0x200,"WM_MOUSEMOVE", 1)
	Gui, Settings:Destroy
	Gui, Settings:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_Settings_ hwndSettingsHandler,% programName " - Settings"
	Gui, Settings:Default

	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		themeState := "+Theme -0x8000"
	else 
		themeState := "-Theme +0x8000"
	Gui, Add, Tab3, vTab x10 y10 %themeState%,Settings|TradesGUI|Hotkeys

	Gui, Tab, 1
;	Settings Tab
;		Trades GUI
		Gui, Add, GroupBox, x20 y40 w200 h260,Trades GUI
		Gui, Add, Radio, xp+10 yp+20 vShowAlways hwndShowAlwaysHandler,Always show
		Gui, Add, Radio, xp yp+15 vShowInGame hwndShowInGameHandler,Only show while in game
;			Transparency
			Gui, Add, GroupBox, x25 yp+25 w190 h140,Transparency
			Gui, Add, Checkbox, xp+10 yp+25 hwndClickThroughHandler vClickThrough,Click-through while inactive
			Gui, Add, Text, xp yp+20,Inactive (no trade on queue)
			Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyHandler gGui_Settings_Transparency vShowTransparency AltSubmit ToolTip Range0-100
			Gui, Add, Text, xp-10 yp+30,Active (trades are on queue)
			Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyActiveHandler gGui_Settings_Transparency vShowTransparencyActive AltSubmit ToolTip Range30-100
;			Bottom
			Gui, Add, Checkbox, x25 yp+45 hwndSelectLastTabHandler vSelectLastTab,Focus newly created tabs
			Gui, Add, Checkbox, xp yp+15 hwndAutoMinimizeHandler vAutoMinimize,Minimize when inactive
			Gui, Add, Checkbox, xp yp+15 hwndAutoUnMinimizeHandler vAutoUnMinimize,Un-Minimize when active
;		Notifications
;			Trade Sound Group
			Gui, Add, GroupBox, x230 y40 w210 h120,Notifications
			Gui, Add, Checkbox, xp+10 yp+20 vNotifyTradeToggle hwndNotifyTradeToggleHandler,Trade
			Gui, Add, Edit, xp+65 yp-2 w70 h17 vNotifyTradeSound hwndNotifyTradeSoundHandler ReadOnly
			Gui, Add, Button, xp+80 yp-2 h20 vNotifyTradeBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Sound Group
			Gui, Add, Checkbox, x240 y85 vNotifyWhisperToggle hwndNotifyWhisperToggleHandler,Whisper
			Gui, Add, Edit, xp+65 yp-2 w70 h17 vNotifyWhisperSound hwndNotifyWhisperSoundHandler ReadOnly
			Gui, Add, Button, xp+80 yp-2 h20 vNotifyWhisperBrowse gGui_Settings_Notifications_Browse,Browse
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
		Gui, Add, Button, x20 y310 w300 h30 gGui_Settings_Btn_Apply vApplyBtn,Apply Settings
		Gui, Add, Button, x320 y310 w120 h30 vWikiBtn gGui_Settings_Btn_WIKI,Visit the WIKI
	
;	TradesGUI tab
	Gui, Tab, 2
	DynamicGUIHandlersArray := Object()
	DynamicGUIHandlersArray.Btn := Object()
	DynamicGUIHandlersArray.HPOS := Object()
	DynamicGUIHandlersArray.HPOSText := Object()
	DynamicGUIHandlersArray.VPOS := Object()
	DynamicGUIHandlersArray.VPOSText := Object()
	DynamicGUIHandlersArray.SIZE := Object()
	DynamicGUIHandlersArray.SIZEText := Object()
	DynamicGUIHandlersArray.Label := Object()
	DynamicGUIHandlersArray.LabelText := Object()
	DynamicGUIHandlersArray.Action := Object()
	DynamicGUIHandlersArray.ActionText := Object()
	DynamicGUIHandlersArray.Msg := Object()
	Loop 9 {
		index := A_Index
		xpos := (index=1||index=4||index=7)?(60):(index=2||index=5||index=8)?(175):(index=3||index=6||index=9)?(290):("ERROR")
		ypos := (index=1||index=2||index=3)?(40):(index=4||index=5||index=6)?(75):(index=7||index=8||index=9)?(110):("ERROR")
		Gui, Add, Button, x%xpos% y%ypos% %themeState% w115 h35 vTradesBtn%index% hwndTradesBtn%index%Handler gGui_Settings_Custom_Label,% "Custom " index

		Gui, Add, Text, x60 y160 hwndTradesHPOS%index%TextHandler,H-POS:
		Gui, Add, DropDownList, w70 xp+50 yp-3 vTradesHPOS%index% hwndTradesHPOS%index%Handler,% "Left|Center|Right"
		Gui, Add, Text, xp+75 yp+3 hwndTradesVPOS%index%TextHandler,V-POS:
		Gui, Add, DropDownList, w70 xp+40 yp-3 vTradesVPOS%index% hwndTradesVPOS%index%Handler,% "Top|Middle|Bottom"
		Gui, Add, Text, xp+75 yp+3 hwndTradesSIZE%index%TextHandler,SIZE:
		Gui, Add, DropDownList, w70 xp+35 yp-3 vTradesSIZE%index% hwndTradesSIZE%index%Handler,% "Disabled|Small|Medium|Large"

		Gui, Add, Text, x60 yp+33 hwndTradesLabel%index%TextHandler,Label:
		Gui, Add, Edit, xp+50 yp-3 w295 vTradesLabel%index% hwndTradesLabel%index%Handler gGui_Settings_Custom_Label,
		Gui, Add, Text, x60 yp+33 hwndTradesAction%index%TextHandler,Action:
		Gui, Add, DropDownList, xp+50 yp-3 w295 vTradesAction%index% hwndTradesAction%index%Handler gGui_Settings_Custom_Label,% "Clipboard Item|Message (Basic)|Message (Basic) + Close Tab|Message (Advanced)|Message (Advanced) + Close Tab"
		Gui, Add, Edit, xp yp+25 w295 vTradesMsg%index% hwndTradesMsg%index%Handler,

		GuiControl,Settings:Hide,% TradesHPOS%index%Handler
		GuiControl,Settings:Hide,% TradesHPOS%index%TextHandler
		GuiControl,Settings:Hide,% TradesVPOS%index%Handler
		GuiControl,Settings:Hide,% TradesVPOS%index%TextHandler
		GuiControl,Settings:Hide,% TradesSIZE%index%Handler
		GuiControl,Settings:Hide,% TradesSIZE%index%TextHandler
		GuiControl,Settings:Hide,% TradesLabel%index%Handler
		GuiControl,Settings:Hide,% TradesLabel%index%TextHandler
		GuiControl,Settings:Hide,% TradesAction%index%Handler
		GuiControl,Settings:Hide,% TradesAction%index%TextHandler
		GuiControl,Settings:Hide,% TradesMsg%index%Handler

		DynamicGUIHandlersArray.Btn.Insert(index,TradesBtn%index%Handler)
		DynamicGUIHandlersArray.HPOS.Insert(index,TradesHPOS%index%Handler)
		DynamicGUIHandlersArray.HPOSText.Insert(index, TradesHPOS%index%TextHandler)
		DynamicGUIHandlersArray.VPOS.Insert(index, TradesVPOS%index%Handler)
		DynamicGUIHandlersArray.VPOSText.Insert(index, TradesVPOS%index%TextHandler)
		DynamicGUIHandlersArray.SIZE.Insert(index, TradesSIZE%index%Handler)
		DynamicGUIHandlersArray.SIZEText.Insert(index, TradesSIZE%index%TextHandler)
		DynamicGUIHandlersArray.Label.Insert(index,TradesLabel%index%Handler)
		DynamicGUIHandlersArray.LabelText.Insert(index,TradesLabel%index%TextHandler)
		DynamicGUIHandlersArray.Action.Insert(index,TradesAction%index%Handler)
		DynamicGUIHandlersArray.ActionText.Insert(index,TradesAction%index%TextHandler)		
		DynamicGUIHandlersArray.Msg.Insert(index,TradesMsg%index%Handler)		
	}
	Gui, Add, Button, x130 y280 w200 gGui_Settings_Trades_Preview,Preview
	;		Apply Button
	Gui, Add, Button, x20 y310 w300 h30 gGui_Settings_Btn_Apply vApplyBtn2,Apply Settings
	Gui, Add, Button, x320 y310 w120 h30 vWikiBtn2 gGui_Settings_Btn_WIKI,Visit the WIKI

;	Hotkeys Tab
	Gui, Tab, 3
	Gui, Add, Button, x130 y35 gGui_Settings_Hotkeys_Switch w200 hwndHotkeys_SwitchToBasicHandler,Switch to Basic
	xpos := 20, ypos := 70
	Loop 16 {
		btnID := A_Index
		if ( btnID > 1 && btnID <= 8 ) || ( btnID > 9 )
			ypos += 30
		else if ( btnID = 9 )
			xpos := 235, ypos := 70
		Gui, Add, Checkbox, x%xpos% y%ypos% vHotkeyAdvanced%btnID%_Toggle hwndHotkeyAdvanced%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-3 w60 vHotkeyAdvanced%btnID%_KEY hwndHotkeyAdvanced%btnID%_KEYHandler
		Gui, Add, Edit, xp+65 yp w110 gGui_Settings_Hotkeys_Tooltip vHotkeyAdvanced%btnID%_Text hwndHotkeyAdvanced%btnID%_TextHandler
		if ( VALUE_Hotkeys_Mode != "Advanced" )  {
			GuiControl,Settings:Hide,% Hotkeys_SwitchToBasicHandler
			GuiControl,Settings:Hide,% HotkeyAdvanced%btnID%_ToggleHandler
			GuiControl,Settings:Hide,% HotkeyAdvanced%btnID%_KEYHandler
			GuiControl,Settings:Hide,% HotkeyAdvanced%btnID%_TextHandler
		}
	}

	Gui, Add, Button, x130 y35 gGui_Settings_Hotkeys_Switch w200 hwndHotkeys_SwitchToAdvancedHandler,Switch to Advanced
	xpos := 20, ypos := 55
	Loop 6 {
		btnID := A_Index
		if (btnID > 1 && btnID <= 3) || (btnID > 4)
			ypos += 80
		else if (btnID = 4)
			xpos := 230, ypos := 55
		Gui, Add, GroupBox, x%xpos% y%ypos% w209 h90 hwndHotkey%btnID%_GroupBox
		Gui, Add, Checkbox, xp+10 yp+20 vHotkey%btnID%_Toggle hwndHotkey%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-4 w150 vHotkey%btnID%_Text hwndHotkey%btnID%_TextHandler,
		Gui, Add, Hotkey, xp yp+25 w150 vHotkey%btnID%_KEY hwndHotkey%btnID%_KEYHandler gGui_Settings_Hotkeys,
		Gui, Add, Checkbox, xp yp+28 vHotkey%btnID%_CTRL hwndHotkey%btnID%_CTRLHandler,CTRL
		Gui, Add, Checkbox, xp+50 yp vHotkey%btnID%_ALT hwndHotkey%btnID%_ALTHandler,ALT
		Gui, Add, Checkbox, xp+42 yp vHotkey%btnID%_SHIFT hwndHotkey%btnID%_SHIFTHandler,SHIFT
		if ( VALUE_Hotkeys_Mode != "Basic" ) {
			GuiControl,Settings:Hide,% Hotkeys_SwitchToAdvancedHandler
			GuiControl,Settings:Hide,% Hotkey%btnID%_GroupBox
			GuiControl,Settings:Hide,% Hotkey%btnID%_ToggleHandler
			GuiControl,Settings:Hide,% Hotkey%btnID%_TextHandler
			GuiControl,Settings:Hide,% Hotkey%btnID%_KEYHandler
			GuiControl,Settings:Hide,% Hotkey%btnID%_CTRLHandler
			GuiControl,Settings:Hide,% Hotkey%btnID%_ALTHandler
			GuiControl,Settings:Hide,% Hotkey%btnID%_SHIFTHandler
		}
	}
	Gui, Add, Button, x20 y310 w300 h30 gGui_Settings_Btn_Apply vApplyBtn3,Apply Settings
	Gui, Add, Button, x320 y310 w120 h30 vWikiBtn3 gGui_Settings_Btn_WIKI,Visit the WIKI
	GuiControl, Choose, Tab, 1
	GoSub, Gui_Settings_Set_Preferences
	Gui, Trades: -E0x20
	Gui, Show
	guiCreated := 1
return

	Gui_Settings_Trades_Preview:
		Gosub, Gui_Settings_Btn_Apply
		Gui_Trades_Clone()
	Return

	Gui_Settings_Custom_Label:
		Gui, Settings:Submit, NoHide
		thisCtrl := A_GuiControl
		RegExMatch(thisCtrl, "\d+", btnID)
		RegExMatch(thisCtrl, "\D+", btnType)
		actionContent := (btnID=1)?(TradesAction1):(btnID=2)?(TradesAction2):(btnID=3)?(TradesAction3):(btnID=4)?(TradesAction4):(btnID=5)?(TradesAction5):(btnID=6)?(TradesAction6):(btnID=7)?(TradesAction7):(btnID=8)?(TradesAction8):(btnID=9)?(TradesAction9):("ERROR")
		labelContent := (btnID=1)?(TradesLabel1):(btnID=2)?(TradesLabel2):(btnID=3)?(TradesLabel3):(btnID=4)?(TradesLabel4):(btnID=5)?(TradesLabel5):(btnID=6)?(TradesLabel6):(btnID=7)?(TradesLabel7):(btnID=8)?(TradesLabel8):(btnID=9)?(TradesLabel9):("ERROR")
		Gui_Settings_Custom_Label_Func(btnType, DynamicGUIHandlersArray, btnID, actionContent, labelContent)
	Return

	Gui_Settings_Btn_WIKI:
		Run, % "https://github.com/lemasato/POE-Trades-Helper/wiki"
	Return
	
	Gui_Settings_Hotkeys_Tooltip:
		if ( guiCreated = 0 )
			Return
		Gui, Settings:Submit, NoHide
		RegExMatch(A_GuiControl, "\d+", btnID)
		ctrlHandler := (btnID=1)?(HotkeyAdvanced1_TextHandler):(btnID=2)?(HotkeyAdvanced2_TextHandler):(btnID=3)?(HotkeyAdvanced3_TextHandler):(btnID=4)?(HotkeyAdvanced4_TextHandler):(btnID=5)?(HotkeyAdvanced5_TextHandler):(btnID=6)?(HotkeyAdvanced6_TextHandler):(btnID=7)?(HotkeyAdvanced7_TextHandler):(btnID=8)?(HotkeyAdvanced8_TextHandler):(btnID=9)?(HotkeyAdvanced9_TextHandler):(btnID=10)?(HotkeyAdvanced10_TextHandler):(btnID=11)?(HotkeyAdvanced11_TextHandler):(btnID=12)?(HotkeyAdvanced12_TextHandler):(btnID=13)?(HotkeyAdvanced13_TextHandler):(btnID=14)?(HotkeyAdvanced14_TextHandler):(btnID=15)?(HotkeyAdvanced15_TextHandler):(btnID=16)?(HotkeyAdvanced16_TextHandler):("ERROR")
		GuiControlGet, ctrlContent, Settings:,% ctrlHandler
		try 
			ToolTip,% ctrlContent
	Return

	Gui_Settings_Hotkeys_Switch:
		if ( A_GuiControl = "Switch to Advanced" ) {
			IniWrite,% "Advanced",% iniFilePath, SETTINGS,Hotkeys_Mode
			VALUE_Hotkeys_Mode := "Advanced"
		}
		else {
			IniWrite,% "Basic",% iniFilePath, SETTINGS,Hotkeys_Mode
			VALUE_Hotkeys_Mode := "Basic"
		}
		GoSub Gui_Settings_Btn_Apply
		Gui_Settings()
		GuiControl, Settings:Choose, Tab, 3
	Return

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
		global VALUE_Trades_Click_Through
		OnMessage(0x200,"WM_MOUSEMOVE", 0)
		Gui, Settings: Destroy
		IniRead, isActive,% iniFilePath,PROGRAM,Tabs_Number
		if ( isActive = 0 && VALUE_Trades_Click_Through = 1 )
			Gui, Trades: +E0x20
		Gui, TradesClone:Destroy
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
		RegExMatch(A_GuiControl, "\d+", btnID)
		hotkeyHandler := (btnID="1")?(Hotkey1_KEYHandler):(btnID="2")?(Hotkey2_KEYHandler):(btnID="3")?(Hotkey3_KEYHandler):(btnID="4")?(Hotkey4_KEYHandler):(btnID="5")?(Hotkey5_KEYHandler):(btnID="6")?(Hotkey6_KEYHandler):("ERROR")
		Gui_Settings_Hotkeys_Func(hotkeyHandler)
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
		IniWrite,% AutoMinimize,% iniFile,SETTINGS,Trades_Auto_Minimize
		IniWrite,% AutoUnMinimize,% iniFile,SETTINGS,Trades_Auto_UnMinimize
		IniWrite,% ClickThrough,% iniFile,SETTINGS,Trades_Click_Through
		if ( ClickThrough )
			Gui, Trades: +E0x20
		else 
			Gui, Trades: -E0x20
		IniWrite,% SelectLastTab,% iniFile,SETTINGS,Trades_Select_Last_Tab
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
	;	1
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
;	Hotkeys Advanced
		Loop 16 {
			index := A_Index
			KEY := "HK" index "_ADV_Toggle"
			CONTENT := (index=1)?(HotkeyAdvanced1_Toggle):(index=2)?(HotkeyAdvanced2_Toggle):(index=3)?(HotkeyAdvanced3_Toggle):(index=4)?(HotkeyAdvanced4_Toggle):(index=5)?(HotkeyAdvanced5_Toggle):(index=6)?(HotkeyAdvanced6_Toggle):(index=7)?(HotkeyAdvanced7_Toggle):(index=8)?(HotkeyAdvanced8_Toggle):(index=9)?(HotkeyAdvanced9_Toggle):(index=10)?(HotkeyAdvanced10_Toggle):(index=11)?(HotkeyAdvanced11_Toggle):(index=12)?(HotkeyAdvanced12_Toggle):(index=13)?(HotkeyAdvanced13_Toggle):(index=14)?(HotkeyAdvanced14_Toggle):(index=15)?(HotkeyAdvanced15_Toggle):(index=16)?(HotkeyAdvanced16_Toggle):("ERROR")
			IniWrite,% CONTENT,% iniFile,HOTKEYS_ADVANCED,% KEY

			KEY := "HK" index "_ADV_KEY"
			CONTENT := (index=1)?(HotkeyAdvanced1_KEY):(index=2)?(HotkeyAdvanced2_KEY):(index=3)?(HotkeyAdvanced3_KEY):(index=4)?(HotkeyAdvanced4_KEY):(index=5)?(HotkeyAdvanced5_KEY):(index=6)?(HotkeyAdvanced6_KEY):(index=7)?(HotkeyAdvanced7_KEY):(index=8)?(HotkeyAdvanced8_KEY):(index=9)?(HotkeyAdvanced9_KEY):(index=10)?(HotkeyAdvanced10_KEY):(index=11)?(HotkeyAdvanced11_KEY):(index=12)?(HotkeyAdvanced12_KEY):(index=13)?(HotkeyAdvanced13_KEY):(index=14)?(HotkeyAdvanced14_KEY):(index=15)?(HotkeyAdvanced15_KEY):(index=16)?(HotkeyAdvanced16_KEY):("ERROR")
			IniWrite,% CONTENT,% iniFile,HOTKEYS_ADVANCED,% KEY

			KEY := "HK" index "_ADV_Text"
			CONTENT := (index=1)?(HotkeyAdvanced1_Text):(index=2)?(HotkeyAdvanced2_Text):(index=3)?(HotkeyAdvanced3_Text):(index=4)?(HotkeyAdvanced4_Text):(index=5)?(HotkeyAdvanced5_Text):(index=6)?(HotkeyAdvanced6_Text):(index=7)?(HotkeyAdvanced7_Text):(index=8)?(HotkeyAdvanced8_Text):(index=9)?(HotkeyAdvanced9_Text):(index=10)?(HotkeyAdvanced10_Text):(index=11)?(HotkeyAdvanced11_Text):(index=12)?(HotkeyAdvanced12_Text):(index=13)?(HotkeyAdvanced13_Text):(index=14)?(HotkeyAdvanced14_Text):(index=15)?(HotkeyAdvanced15_Text):(index=16)?(HotkeyAdvanced16_Text):("ERROR")
			IniWrite,% CONTENT,% iniFile,HOTKEYS_ADVANCED,% KEY
		}
;	Dynamic TradesGUI
		Loop 9 {
			index := A_Index

			KEY := "Button" index "_Label"
			CONTENT := (index=1)?(TradesLabel1):(index=2)?(TradesLabel2):(index=3)?(TradesLabel3):(index=4)?(TradesLabel4):(index=5)?(TradesLabel5):(index=6)?(TradesLabel6):(index=7)?(TradesLabel7):(index=8)?(TradesLabel8):(index=9)?(TradesLabel9):("ERROR")
			IniWrite,% CONTENT,% iniFile,TRADES_GUI,% KEY

			KEY := "Button" index "_Action"
			CONTENT := (index=1)?(TradesAction1):(index=2)?(TradesAction2):(index=3)?(TradesAction3):(index=4)?(TradesAction4):(index=5)?(TradesAction5):(index=6)?(TradesAction6):(index=7)?(TradesAction7):(index=8)?(TradesAction8):(index=9)?(TradesAction9):("ERROR")
			IniWrite,% CONTENT,% iniFile,TRADES_GUI,% KEY

			KEY := "Button" index "_Message"
			CONTENT := (index=1)?(TradesMsg1):(index=2)?(TradesMsg2):(index=3)?(TradesMsg3):(index=4)?(TradesMsg4):(index=5)?(TradesMsg5):(index=6)?(TradesMsg6):(index=7)?(TradesMsg7):(index=8)?(TradesMsg8):(index=9)?(TradesMsg9):("ERROR")
			IniWrite,% CONTENT,% iniFile,TRADES_GUI,% KEY

			KEY := "Button" index "_H"
			CONTENT := (index=1)?(TradesHPOS1):(index=2)?(TradesHPOS2):(index=3)?(TradesHPOS3):(index=4)?(TradesHPOS4):(index=5)?(TradesHPOS5):(index=6)?(TradesHPOS6):(index=7)?(TradesHPOS7):(index=8)?(TradesHPOS8):(index=9)?(TradesHPOS9):("ERROR")
			IniWrite,% CONTENT,% iniFile,TRADES_GUI,% KEY

			KEY := "Button" index "_V"
			CONTENT := (index=1)?(TradesVPOS1):(index=2)?(TradesVPOS2):(index=3)?(TradesVPOS3):(index=4)?(TradesVPOS4):(index=5)?(TradesVPOS5):(index=6)?(TradesVPOS6):(index=7)?(TradesVPOS7):(index=8)?(TradesVPOS8):(index=9)?(TradesVPOS9):("ERROR")
			IniWrite,% CONTENT,% iniFile,TRADES_GUI,% KEY

			KEY := "Button" index "_SIZE"
			CONTENT := (index=1)?(TradesSIZE1):(index=2)?(TradesSIZE2):(index=3)?(TradesSIZE3):(index=4)?(TradesSIZE4):(index=5)?(TradesSIZE5):(index=6)?(TradesSIZE6):(index=7)?(TradesSIZE7):(index=8)?(TradesSIZE8):(index=9)?(TradesSIZE9):("ERROR")
			IniWrite,% CONTENT,% iniFile,TRADES_GUI,% KEY
		}
;	Declare the new settings
		Disable_Hotkeys()
		settingsArray := Get_INI_Settings()
		Declare_INI_Settings(settingsArray)
		Enable_Hotkeys()
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
		HOTKEYS_ADVANCED_HandlersArray := returnArray.HOTKEYS_ADVANCED_HandlersArray
		HOTKEYS_ADVANCED_HandlersKeysArray := returnArray.HOTKEYS_ADVANCED_HandlersKeysArray
		TRADES_GUI_HandlersArray := returnArray.TRADES_GUI_HandlersArray
		TRADES_GUI_HandlersKeysArray := returnArray.TRADES_GUI_HandlersKeysArray

		for key, element in sectionArray
		{
			sectionName := element
			for key, element in %sectionName%_HandlersKeysArray
			{
				keyName := element
				handler := %sectionName%_HandlersArray[key]
				IniRead, var,% iniFile,% sectionName,% keyName
				if ( keyName = "Show_Mode" ) { ; Make sure only one goes through
					GuiControl, Settings:,% Show%var%Handler,1
				}
				else if ( keyName = "Dock_Mode" ) { ; Make sure only one goes through
					GuiControl, Settings:, % Dock%var%Handler,1
				}
				else if ( keyName = "Transparency" || keyName = "Transparency_Active" ) { ; Convert to pecentage
					var := ((var - 0) * 100) / (255 - 0)
					GuiControl, Settings:,% %handler%Handler,% var
				}
				else if ( keyName = "Logs_Mode" ) { ; Make sure only one goes through
					GuiControl, Settings:,% Logs%var%Handler,1
				}
				else if ( sectionName = "TRADES_GUI" ) {
					if keyName contains _H,_V,_SIZE,_ACTION
						GuiControl, Settings:Choose,% %handler%Handler,% var
					else {
						handler := %sectionName%_HandlersArray[key]
						GuiControl, Settings:,% %handler%Handler,% var
					}
				}
				else if ( var != "ERROR" && var != "" ) { ; Everything else
					handler := %sectionName%_HandlersArray[key]
					GuiControl, Settings:,% %handler%Handler,% var
				}
			}
		}
	return
}

Gui_Trades_Clone() {
;			Trades GUI. Each new item will be added in a new tab
;			Clicking on a button will do its corresponding action
;			Switching tab will clipboard the item's infos if the user enabled
;			Is transparent and click-through when there is no trade on queue
	static
	global VALUE_Button1_H, VALUE_Button2_H, VALUE_Button3_H, VALUE_Button4_H, VALUE_Button5_H, VALUE_Button6_H, VALUE_Button7_H, VALUE_Button8_H, VALUE_Button9_H
	global VALUE_Button1_V, VALUE_Button2_V, VALUE_Button3_V, VALUE_Button4_V, VALUE_Button5_V, VALUE_Button6_V, VALUE_Button7_V, VALUE_Button8_V, VALUE_Button9_V
	global VALUE_Button1_SIZE, VALUE_Button2_SIZE, VALUE_Button3_SIZE, VALUE_Button4_SIZE, VALUE_Button5_SIZE, VALUE_Button6_SIZE, VALUE_Button7_SIZE, VALUE_Button8_SIZE, VALUE_Button9_SIZE
	global VALUE_Button1_Label, VALUE_Button2_Label, VALUE_Button3_Label, VALUE_Button4_Label, VALUE_Button5_Label, VALUE_Button6_Label, VALUE_Button7_Label, VALUE_Button8_Label, VALUE_Button9_Label

	infosArray := Object()
	infosArray.BUYERS := Object()
	infosArray.ITEMS := Object()
	infosArray.PRICES := Object()
	infosArray.LOCATIONS := Object()
	infosArray.TIME := Object()
	infosArray.OTHER := Object()
	infosArray.BUYERS.Insert(1, "iSellStuff")
	infosArray.ITEMS.Insert(1, "level 1 Faster Attacks Support")
	infosArray.PRICES.Insert(1, "5 alteration")
	infosArray.LOCATIONS.Insert(1, "Breach (stash tab ""Gems""; position: left 6, top 8)")
	infosArray.TIME.Insert(1, A_Hour ":" A_Min)
	infosArray.OTHER.Insert(1, "Offering 1alch?")

	Gui, TradesClone:Destroy
	Gui, TradesClone:New, +AlwaysOnTop +LastFound +hwndGuiTradesCloneHandler
	Gui, TradesClone:Default
	tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390
	guiWidth := 403, guiHeight := tabHeight + 38
	Gui, Add, Text,% "x0 y0 w" guiWidth " h25 +0x4 hwndguiTradesCloneMoveHandler",% ""
	Gui, Add, Text,% "x5 y0 w" guiWidth " h25 cFFFFFF BackgroundTrans +0x200 hwndguiTradesCloneTitleHandler",% programName " - Queued Trades: 1 (PREVIEW)"
	Gui, TradesCloneMin:-Caption +Parent%guiTradesCloneMoveHandler%
	Gui, TradesCloneMin:Color, 696969
	Gui, TradesCloneMin:Margin, 0, 0
	Gui, TradesCloneMin:Add, Text,% "x" 0 " y0 h25 cFFFFFF BackgroundTrans Section +0x200",% "MINIMIZE"
	Gui, Add, Text,% "x0 y0 w5 h" guiHeight " +0x4",% "" ; Left
	Gui, Add, Text,% "x0 y" guiHeight - 5 " w" guiWidth + 5 " h5 +0x4",% "" ; Bottom
	Gui, Add, Text,% "x" guiWidth " y0 w5 h" guiHeight " +0x4",% "" ; Right
		
	aeroStatus := Get_Aero_Status()
	if ( aeroStatus = 1 )
		themeState := "+Theme -0x8000"
	else
		themeState := "-Theme +0x8000"

	tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390
	Gui, Add, Tab3,x10 y30 vTab w%tabWidth% h%tabHeight% %themeState% -Wrap
	Gui, TradesClone:Default
	Loop 1 {
		index := A_Index
		percent := ( index / 255 ) * 100
		GuiControl, ,Tab,% index
		Gui, Tab,% index

		Gui, Add, Text, x345 y53 w30 h15 vTimeSlotClone%index%,% ""
		Gui, Add, Text, x20 y58 w45 h15 hwndBuyerTextClone%index%Handler,% "Buyer: "
		Gui, Add, Text, xp+50 yp w270 h15 vBuyerSlotClone%index%,
		Gui, Add, Text, w45 h15 xp-50 yp+15 hwndItemTextClone%index%Handler,% "Item: "
		Gui, Add, Text, w325 h15 xp+50 yp vItemSlotClone%index%,
		Gui, Add, Text, w45 h15 xp-50 yp+15 hwndPriceTextClone%index%Handler,% "Price: "
		Gui, Add, Text, w325 h15 xp+50 yp vPriceSlotClone%index%,
		if ( infosArray.PRICES[index] = "Unpriced Item")
			GuiControl, TradesClone: +cRed, PriceSlotClone%index%
		Gui, Add, Text, w45 h15 xp-50 yp+15 hwndLocationTextClone%index%Handler,% "Location: "
		Gui, Add, Text, w325 h15 xp+50 yp vLocationSlotClone%index%,
		Gui, Add, Text, w45 h15 xp-50 yp+15 hwndOtherTextClone%index%Handler,% "Other: "
		Gui, Add, Text, w325 h15 xp+50 yp vOtherSlotClone%index%,
		Gui, Add, Text, w0 h0 xp yp vPIDSlotClone%index%,
		Gui, Add, Button,w20 h20 x377 y51 vdelBtnClone%index% %themeState% hwndCloseBtnClone%index%Handler,% "X"

		for key, element in infosArray.BUYERS {
			GuiControl, TradesClone:,buyerSlotClone%key%,% infosArray.BUYERS[key]
			GuiControl, TradesClone:,itemSlotClone%key%,% infosArray.ITEMS[key]
			GuiControl, TradesClone:,priceSlotClone%key%,% infosArray.PRICES[key]
			GuiControl, TradesClone:,locationSlotClone%key%,% infosArray.LOCATIONS[key]
			GuiControl, TradesClone:,PIDSlotClone%key%,% infosArray.GAMEPID[key]
			GuiControl, TradesClone:,TimeSlotClone%key%,% infosArray.TIME[key]
			GuiControl, TradesClone:,OtherSlotClone%key%,% infosArray.OTHER[key]
		}

		Loop 9 {
			Gui, Tab,% index
			btnW := (VALUE_Button%A_Index%_SIZE="Small")?(119):(VALUE_Button%A_Index%_SIZE="Medium")?(244):(VALUE_Button%A_Index%_SIZE="Large")?(369):("ERROR")
			btnX := (VALUE_Button%A_Index%_H="Left")?(20):(VALUE_Button%A_Index%_H="Center")?(145):(VALUE_Button%A_Index%_H="Right")?(270):("ERROR")
			btnY := (VALUE_Button%A_Index%_V="Top")?(135):(VALUE_Button%A_Index%_V="Middle")?(175):(VALUE_Button%A_Index%_V="Bottom")?(215):("ERROR")
			btnName := VALUE_Button%A_Index%_Label
			btnSub := RegExReplace(VALUE_Button%A_Index%_Action, "[ _+()]", "_")
			btnSub := RegExReplace(btnSub, "___", "_")
			btnSub := RegExReplace(btnSub, "__", "_")
			btnSub := RegExReplace(btnSub, "_", "", ,1,-1)
			if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnSub != "" && btnSub != "ERROR" ) {
				Gui, Add, Button,x%btnX% y%btnY% w%btnW% h35 vCustomBtnClone%A_Index%_%index%,% btnName
			}
		}
	}
	Gui, TradesClone:Font, cYellow
	GuiControl, TradesClone:Font,% guiTradesCloneTitleHandler
	xpos := 10, ypos := 10
	Gui, TradesClone:Show,% "NoActivate w" guiWidth+5 " h" guiHeight " x" xpos " y" ypos,% programName " - Queued Trades"
	Gui, TradesCloneMin:Show,% "x" guiWidth - 49 " y0"
}

Gui_Settings_Custom_Label_Func(type, controlsArray, btnID, action, label) {
	static

	if ( type = "TradesBtn" ) {
		for key, element in controlsArray.HPOS
			GuiControl,Settings:Hide,% element
		for key, element in controlsArray.HPOSText
			GuiControl,Settings:Hide,% element

		for key, element in controlsArray.VPOS
			GuiControl,Settings:Hide,% element
		for key, element in controlsArray.VPOSText
			GuiControl,Settings:Hide,% element

		for key, element in controlsArray.SIZE
			GuiControl,Settings:Hide,% element
		for key, element in controlsArray.SIZEText
			GuiControl,Settings:Hide,% element
		
		for key, element in controlsArray.Label
			GuiControl,Settings:Hide,% element
		for key, element in controlsArray.LabelText
			GuiControl,Settings:Hide,% element

		for key, element in controlsArray.Action
			GuiControl,Settings:Hide,% element	
		for key, element in controlsArray.ActionText
			GuiControl,Settings:Hide,% element

		for key, element in controlsArray.Msg
			GuiControl,Settings:Hide,% element

		GuiControl,Settings:Show,% controlsArray.HPOS[btnID]
		GuiControl,Settings:Show,% controlsArray.HPOSText[btnID]

		GuiControl,Settings:Show,% controlsArray.VPOS[btnID]
		GuiControl,Settings:Show,% controlsArray.VPOSText[btnID]

		GuiControl,Settings:Show,% controlsArray.SIZE[btnID]
		GuiControl,Settings:Show,% controlsArray.SIZEText[btnID]

		GuiControl,Settings:Show,% controlsArray.Label[btnID]
		GuiControl,Settings:Show,% controlsArray.LabelText[btnID]

		GuiControl,Settings:Show,% controlsArray.Action[btnID]
		GuiControl,Settings:Show,% controlsArray.ActionText[btnID]
	}

	if ( type = "TradesLabel" )
		GuiControl,Settings:,% controlsArray.Btn[btnID],% label

	if ( type = "TradesAction" || type = "TradesBtn" ) && ( action != "Clipboard Item" && action != "" )
		GuiControl,Settings:Show,% controlsArray.Msg[btnID]
	if ( type = "TradesAction" || type = "TradesBtn" ) && ( action = "Clipboard Item" || action = "" )
		GuiControl,Settings:Hide,% controlsArray.Msg[btnID]
}

Gui_Settings_Hotkeys_Func(ctrlHandler) {
	GuiControlGet, strHotkey, ,% ctrlHandler
	if strHotKey contains ^,!,+ ; Prevent modifier keys from slipping through
		GuiControl, Settings: ,% ctrlHandler, None
}

Show_Tooltip(ctrlName, ctrlHandler) {
	RegExMatch(ctrlName, "\d+", btnID)
	GuiControlGet, ctrlVar, Settings:,% ctrlHandler
	ToolTip,% ctrlVar
}


Gui_Settings_Get_Settings_Arrays() {
;			Contains all the section/handlers/keys/defaut values for the Settings GUI
;			Return an array containing all those informations
	static
	returnArray := Object()
	returnArray.sectionArray := Object() ; contains all the .ini SECTIONS
	returnArray.sectionArray.Insert(0, "SETTINGS", "AUTO_CLIP", "HOTKEYS", "NOTIFICATIONS", "MESSAGES", "HOTKEYS_ADVANCED", "TRADES_GUI")
	
	returnArray.SETTINGS_HandlersArray := Object() ; contains all the Gui_Settings HANDLERS from this SECTION
	returnArray.SETTINGS_HandlersArray.Insert(0, "ShowAlways", "ShowInGame", "ShowTransparency", "ShowTransparencyActive", "AutoMinimize", "AutoUnMinimize", "ClickThrough", "SelectLastTab")
	returnArray.SETTINGS_HandlersKeysArray := Object() ; contains all the .ini KEYS for those HANDLERS
	returnArray.SETTINGS_HandlersKeysArray.Insert(0, "Show_Mode", "Show_Mode", "Transparency", "Transparency_Active", "Trades_Auto_Minimize", "Trades_Auto_UnMinimize", "Trades_Click_Through", "Trades_Select_Last_Tab")
	returnArray.SETTINGS_KeysArray := Object() ; contains all the individual .ini KEYS
	returnArray.SETTINGS_KeysArray.Insert(0, "Show_Mode", "Transparency", "Trades_GUI_Mode", "Transparency_Active", "Hotkeys_Mode", "Trades_Auto_Minimize", "Trades_Auto_UnMinimize", "Trades_Click_Through", "Trades_Select_Last_Tab")
	returnArray.SETTINGS_DefaultValues := Object() ; contains all the DEFAULT VALUES for the .ini KEYS
	returnArray.SETTINGS_DefaultValues.Insert(0, "Always", "255", "Window", "255", "Basic", "0", "0", "0", "0")
	
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
		hkTxtCmd := (index=1)?("/hideout") : (index=2)?("/kick YourName") : (index=3)?("/oos") : ("Insert Command or Message")
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

	returnArray.HOTKEYS_ADVANCED_HandlersArray := Object()
	returnArray.HOTKEYS_ADVANCED_HandlersKeysArray := Object()
	returnArray.HOTKEYS_ADVANCED_KeysArray := Object()
	returnArray.HOTKEYS_ADVANCED_DefaultValues := Object()
	keyID := 0
	Loop 16 {
		index := A_Index
		returnArray.HOTKEYS_ADVANCED_HandlersArray.Insert(keyID, "HotkeyAdvanced" index "_Toggle", "HotkeyAdvanced" index "_Text", "HotkeyAdvanced" index "_KEY")
		returnArray.HOTKEYS_ADVANCED_HandlersKeysArray.Insert(keyID, "HK" index "_ADV_Toggle", "HK" index "_ADV_Text", "HK" index "_ADV_KEY")
		returnArray.HOTKEYS_ADVANCED_KeysArray.Insert(keyID, "HK" index "_ADV_Toggle", "HK" index "_ADV_Text", "HK" index "_ADV_KEY")
		hkToggle := (index=1)?(1) : (0)
		hkTxtCmd := (index=1)?("{Enter}/hideout{Enter}") : (index=2)?("{Enter}/kick YourCharacter{Enter}{Enter}/kick YourOtherCharacter{Enter}") : (index=3)?("{Enter}/oos{Enter}") : ("")
		hkKeyCmd := (index=1)?("F2") : ("")
		returnArray.HOTKEYS_ADVANCED_DefaultValues.Insert(keyID, hkToggle, hkTxtCmd, hkKeyCmd)
		keyID+=3
	}

	returnArray.TRADES_GUI_HandlersArray := Object()
	returnArray.TRADES_GUI_HandlersKeysArray := Object()
	returnArray.TRADES_GUI_KeysArray := Object()
	returnArray.TRADES_GUI_DefaultValues := Object()
	keyID := 0
	keyID2 := 0
	Loop 9 {
		index := A_Index
		returnArray.TRADES_GUI_HandlersArray.Insert(keyID, "TradesBtn" index, "TradesHPOS" index, "TradesVPOS" index, "TradesSIZE" index, "TradesLabel" index, "TradesMsg" index, "TradesAction" index)
		returnArray.TRADES_GUI_HandlersKeysArray.Insert(keyID, "Button" index "_Label", "Button" index "_H", "Button" index "_V", "Button" index "_SIZE", "Button" index "_Label", "Button" index "_Message", "Button" index "_Action")
		returnArray.TRADES_GUI_KeysArray.Insert(keyID2, "Button" index "_Label", "Button" index "_Action","Button" index "_Message", "Button" index "_H", "Button" index "_V", "Button" index "_SIZE")
		btnLabel := (index=1)?("Clipboard Item"):(index=2)?("Ask to Wait"):(index=3)?("Party Invite"):(index=4)?("Thank You"):(index=5)?("Sold It"):(index=6)?("Still Interested?"):(index=7)?("Trade Request"):("[Undefined]")
		btnAction := (index=1)?("Clipboard Item"):(index=2)?("Message (Basic)"):(index=3)?("Message (Advanced)"):(index=4)?("Message (Advanced) + Close Tab"):(index=5)?("Message (Basic) + Close Tab"):(index=6)?("Message (Basic)"):(index=7)?("Message (Basic)"):("")
		btnMsg := (index=1)?(""):(index=2)?("@%buyerName% One moment please! (%itemName% // %itemPrice%)"):(index=3)?("{Enter}/invite %buyerName%{Enter}{Enter}@%buyerName% Your item is ready to be picked up at my hideout! (%itemName% // %itemPrice%){Enter}"):(index=4)?("{Enter}/kick %buyerName%{Enter}{Enter}@%buyerName% Thank you, good luck & have fun!{Enter}"):(index=5)?("@%buyerName% The requested item was sold! (%itemName% // %itemPrice%)"):(index=6)?("@%buyerName% Still interested in the item? (%itemName% // %itemPrice%)"):(index=7)?("/tradewith %buyerName%"):("")
		btnH := (index=1)?("Left"):(index=2)?("Center"):(index=3)?("Right"):(index=4)?("Left"):(index=5)?("Right"):(index=6)?:("")
		btnV := (index=1)?("Top"):(index=2)?("Top"):(index=3)?("Top"):(index=4)?("Middle"):(index=5)?("Middle"):(index=6)?:("")
		btnSIZE := (index=1)?("Small"):(index=2)?("Small"):(index=3)?("Small"):(index=4)?("Medium"):(index=5)?("Small"):("Disabled")
		returnArray.TRADES_GUI_DefaultValues.Insert(keyID2, btnLabel, btnAction, btnMsg, btnH, btnV, btnSIZE)
		keyID += 6
		keyID2 += 6
	}
	
	return returnArray
}

Get_Control_ToolTip(controlName) {
;			Retrieves the tooltip for the corresponding control
;			Return a variable conaining the tooltip content
	static
	ShowInGame_TT := ShowAlways_TT := "Decide when should the GUI show."
	. "`nAlways show:" A_Tab . A_Tab "The GUI will always appear."
	. "`nOnly show while in game:" A_Tab "The GUI will only appear when the game's window is active."

	ClickThrough_TT := "Clicks will go through the Trades GUI whil it is inactive,"
	. "`nallowing you to click the windows beneath it."
	ShowTransparency_TT := "Transparency of the GUI when no trade is on queue."
	. "`nSetting the value to 0% will effectively make the GUI invisible."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on if it's active or inactive."
	ShowTransparencyActive_TT := "Transparency of the GUI when trades are on queue."
	. "`nThe minimal value is set to 30% to make sure you can still see the window."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on if it's active or inactive."

	SelectLastTab_TT := "Always focus the new tab upon receiving a new trade whisper."
	. "`nIf disabled, it will stay on the current tab instead."

	AutoMinimize_TT := "Automatically minimize the Trades GUI when no trades are on queue."
	AutoUnMinimize_TT := "Automatically un-minimize the Trades GUI upon receiving a trade whisper."
	
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

	TradesHPOS1_TT := "Horizontal position of the button."
	. "`nLeft:" A_Tab . A_Tab "The button will be positioned on the left side."
	. "`nCenter:" A_Tab . A_Tab "The button will be positioned on the center."
	. "`nRight:" A_Tab . A_Tab "The button will be positioned on the right side."
	TradesVPOS1_TT := "Vertical position of the button."
	. "`nTop:" A_Tab . A_Tab "The button will be positioned on the top row."
	. "`nCenter:" A_Tab . A_Tab "The button will be positioned on the middle row."
	. "`nBottom:" A_Tab . A_Tab "The button will be positioned on the bottom row."
	TradesSIZE1_TT := "Size of the button."
	. "`nDisabled:" A_Tab "The button will not appear."
	. "`nSmall:" A_Tab . A_Tab "The button will take one third of the row."
	. "`nMedium:" A_Tab "The button will take two third of the row."
	. "`nLarge:" A_Tab . A_Tab "The button will take the whole row."
	TradesLabel1_TT := "Label of the button."
	TradesAction1_TT := "Action that will be triggered upon clicking the button."
	. "`nClipboard Item:" A_Tab . A_Tab "Will put the current tab's item into the clipboard."
	. "`nMessage (Basic):" A_Tab . A_Tab "Will send a single message."
	. "`nMessage (Advanced):" A_Tab "Can send multiple messages."
	. "`nClose Tab:" A_Tab . A_Tab "Will close the tab upon clicking the button."
	TradesHPOS9_TT := TradesHPOS8_TT := TradesHPOS7_TT := TradesHPOS6_TT := TradesHPOS5_TT := TradesHPOS4_TT := TradesHPOS3_TT := TradesHPOS2_TT := TradesHPOS1_TT
	TradesVPOS9_TT := TradesVPOS8_TT := TradesVPOS7_TT := TradesVPOS6_TT := TradesVPOS5_TT := TradesVPOS4_TT := TradesVPOS3_TT := TradesVPOS2_TT := TradesVPOS1_TT
	TradesSIZE9_TT := TradesSIZE8_TT := TradesSIZE7_TT := TradesSIZE6_TT := TradesSIZE5_TT := TradesSIZE4_TT := TradesSIZE3_TT := TradesSIZE2_TT := TradesSIZE1_TT
	TradesLabel9_TT := TradesLabel8_TT := TradesLabel7_TT := TradesLabel6_TT := TradesLabel5_TT := TradesLabel4_TT := TradesLabel3_TT := TradesLabel2_TT := TradesLabel1_TT
	TradesAction9_TT := TradesAction8_TT := TradesAction7_TT := TradesAction6_TT := TradesAction5_TT := TradesAction4_TT := TradesAction3_TT := TradesAction2_TT := TradesAction1_TT

	Preview_TT := "Show a preview of the TradesGUI."
	. "`nNote: The button's function are disabled in preview mode."
	. "`nYou will need to reload the script to take the new buttons in count!"
	
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

	Gui, Tab, 2
		FileRead, changelogText,% programChangelogFilePath
		allChanges := Object()
		allVersions := ""
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
		Gui, Add, Edit, vChangesText hwndChangesTextHandler w395 R9 ReadOnly,An internet connection is required
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
	static
	global iniFilePath
	iniFile := iniFilePath
	
	returnArray := Object()
	returnArray := Gui_Settings_Get_Settings_Arrays()
	
	sectionArray := returnArray.sectionArray
	SETTINGS_KeysArray := returnArray.SETTINGS_KeysArray
	AUTO_CLIP_KeysArray := returnArray.AUTO_CLIP_KeysArray
	HOTKEYS_KeysArray := returnArray.HOTKEYS_KeysArray
	NOTIFICATIONS_KeysArray := returnArray.NOTIFICATIONS_KeysArray
	MESSAGES_KeysArray := returnArray.MESSAGES_KeysArray
	HOTKEYS_ADVANCED_KeysArray := returnArray.HOTKEYS_ADVANCED_KeysArray
	TRADES_GUI_KeysArray := returnArray.TRADES_GUI_KeysArray
	
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
	static
	global iniFilePath
	iniFile := iniFilePath	
	
;	Set the PID and filename, used for the auto updater
	programPID := DllCall("GetCurrentProcessId")
	IniWrite,% programPID,% iniFile,PROGRAM,PID
	IniWrite,% A_ScriptName,% iniFile,PROGRAM,FileName
	IniWrite, 10,% iniFilePath,PROGRAM,Rendered_Tabs

	DetectHiddenWindows On
	WinGet, fileProcessName, ProcessName, ahk_pid %programPID%
	IniWrite,% fileProcessName,% iniFile,PROGRAM,FileProcessName
	DetectHiddenWindows, Off

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
	HOTKEYS_ADVANCED_KeysArray := settingsArray.HOTKEYS_ADVANCED_KeysArray
	HOTKEYS_ADVANCED_DefaultValues := settingsArray.HOTKEYS_ADVANCED_DefaultValues
	TRADES_GUI_KeysArray := settingsArray.TRADES_GUI_KeysArray
	TRADES_GUI_DefaultValues := settingsArray.TRADES_GUI_DefaultValues
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
;												HOTKEYS
;
;==================================================================================================================

Disable_Hotkeys() {
;	Disable the current hotkeys
;	Always run Enable_Hotkeys() after to retrieve and assign the new hotkeys
	static
	global VALUE_Hotkeys_Mode
	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx
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
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%,Off
				}
			}
		}
	}
	Loop 16 {
		index := A_Index
		if ( VALUE_HK%index%_ADV_Toggle ) {
			userHotkey%index% := VALUE_HK%index%_ADV_KEY
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%indzex% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%,Off
				}
			}
		}
	}		
	SetTitleMatchMode, %titleMatchMode%	
}

Enable_Hotkeys() {
;	Enable the hotkeys, based on its global VALUE_ content
	static
	global VALUE_Hotkeys_Mode
	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx
	if ( VALUE_Hotkeys_Mode = "Advanced" ) {
		Loop 16 {
			index := A_Index
			if ( VALUE_HK%index%_ADV_Toggle ) {
				userHotkey%index% := VALUE_HK%index%_ADV_KEY
				Hotkey,IfWinActive,ahk_group POEGame
				if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
					try	
						Hotkey,% userHotkey%index%,Hotkeys_User_%index%,On
					catch {
						IniWrite,0,% iniFilePath,HOTKEYS_ADVANCED,% "HK" index "_ADV_Toggle"
						MsgBox, 4096,% programName,% "The following Hotkey is invalid: " userHotkey%index%
						. "`n`nThe Hotkey will be disabled."
						. "`nPlease refer to the WIKI."
					}
				}
			}
		}		
	}
	else {
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
				Hotkey,IfWinActive,ahk_group POEGame
				if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
					Hotkey,% userHotkey%index%,Hotkeys_User_%index%,On
				}
			}
		}
	}
	SetTitleMatchMode, %titleMatchMode%
}

;==================================================================================================================
;
;												MISC STUFF
;
;==================================================================================================================

ShellMessage(wParam,lParam) {
	global VALUE_Show_Mode, guiTradesHandler, tradesGuiWidth, VALUE_Dock_Window, VALUE_Trades_GUI_Mode
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
		else if ( ( VALUE_Show_Mode = "InGame" ) && ( VALUE_Dock_Window != winID ) ) {
			Logs_Append(A_ThisFunc,,VALUE_Show_Mode,VALUE_Dock_Window,winID)
			Gui, Trades:Show, NoActivate Hide
		}
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

Do_Once() {
;			Things that only need to be done ONCE
;
;	Open the changelog menu
	static
	global iniFilePath

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
	static

	RegRead, dpiValue, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
	if (errorlevel = 1) || (dpiValue = 96)
		dpiFactor := 1
	else
		dpiFactor := dpiValue/96
	return dpiFactor
}

Logs_Append(funcName, paramsArray="", params*){
	static
	global programLogsFilePath, programName, programVersion, iniFilePath

	if ( funcName = "Start" ) {
		dpiFactor := Get_DPI_Factor()
		FileAppend,% "OS: " A_OSVersion "`n",% programLogsFilePath
		FileAppend, "DPI: " dpiFactor "`n",% programLogsFilePath
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		FileAppend,% ">>> PROGRAM SECTION DUMP START`n",% programLogsFilePath
		IniRead, content,% iniFilePath,PROGRAM
		FileAppend,% content "`n",% programLogsFilePath
		FileAppend,% "PROGRAM SECTION DUMP END <<<`n",% programLogsFilePath
		FileAppend,% "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n`n",% programLogsFilePath
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		FileAppend,% ">>> GLOBAL VALUE_ DUMP START`n",% programLogsFilePath
		for key, element in paramsArray.KEYS {
			FileAppend,% paramsArray.KEYS[A_Index] ": """ paramsArray.VALUES[A_Index] """`n",% programLogsFilePath
		}
		FileAppend,% "GLOBAL VALUE_ DUMP END <<<`n",% programLogsFilePath
		FileAppend,% "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n",% programLogsFilePath
	}

	if ( funcName = "GUI_Multiple_Instances" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Found multiple instances. Handler: " params[1] " - Path: " params[2],% programLogsFilePath
	}
	if ( funcName = "GUI_Multiple_Instances_Return" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Found multiple instances (Return). Handler: " params[1],% programLogsFilePath
	}

	if ( funcName = "Monitor_Game_Logs" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Monitoring logs: " params[1],% programLogsFilePath
	}
	if ( funcName = "Monitor_Game_Logs_Break" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Monitoring logs (Break). Obj.pos: " params[1] " - Obj.length: " params[2],% programLogsFilePath
	}

	if ( funcName = "Gui_Trades_Set_Position" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Trades GUI Position: x" params[1] " y" params[2] ".",% programLogsFilePath
	}

	if (funcName = "ShellMessage" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Trades GUI Hidden: Show_Mode: " params[1] " - Dock_Window ID: " params[2] " - Current Win ID: " winID "."
	}

	if ( funcName = "Send_InGame_Message" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Sending IG Message to PID """ params[3] """ with content: """ params[1] """ | %buyerName%:""" params[2] """",% programLogsFilePath
		matchsArray := Get_Matching_Windows_Infos("PID")
		for key, element in matchsArray
			FileAppend,% " | Instance" key " PID: " element,% programLogsFilePath
	}

	if ( funcName = "Gui_Trades_Cycle_Func" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Docking the GUI to ID: " params[1] " - Total matchs found: " params[2] + 1,% programLogsFilePath
	}

	FileAppend,% "`n",% programLogsFilePath
}

Delete_Old_Logs_Files(filesToKeep) {
;			Make sure to only keep 10 (+current) logs file
;			Delete the older logs file
	static
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
	static

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

Send_InGame_Message(messageToSend, infosArray="", isHotkey=0, isAdvanced=0) {
;			Sends a message InGame and replace the "variables text" into their content
	static
	global VALUE_Logs_Mode, VALUE_Hotkeys_Mode, POEGame, programName, VALUE_Last_Whisper

	buyerName := infosArray[0], itemName := infosArray[1], itemPrice := infosArray[2], gamePID := infosArray[3]
	messageToSendRaw := messageToSend
	StringReplace, messageToSend, messageToSend, `%buyerName`%, %buyerName%, 1
	StringReplace, messageToSend, messageToSend, `%itemName`%, %itemName%, 1
	StringReplace, messageToSend, messageToSend, `%itemPrice`%, %itemPrice%, 1
	StringReplace, messageToSend, messageToSend, `%lastWhisper`%, %VALUE_Last_Whisper%, 1
	if ( isHotkey = 1 ) {
		if ( VALUE_Hotkeys_Mode = "Advanced" ) {
			SendInput,%messageToSend%
		}
		else {
			SendInput,{Enter}/{BackSpace}
			SendInput,{Raw}%messageToSend%
			SendInput,{Enter}
		}
		Return
	}
	else {
		if !WinExist("ahk_pid " gamePID " ahk_group POEGame") {
			PIDArray := Get_Matching_Windows_Infos("PID")
			handlersArray := Get_Matching_Windows_Infos("ID")
			if ( handlersArray.MaxIndex() = "" ) {
				Loop 2
				TrayTip,% programName,% "The PID assigned to the tab does not belong to a POE instance, and no POE instance was found!`n`nPlease click the button again after restarting the game."
			}
			else {
				gamePID := GUI_Replace_PID(handlersArray, PIDArray)
				Gui_Trades_Set_Trades_Infos(gamePID)
			}
		}
		titleMatchMode := A_TitleMatchMode
		SetTitleMatchMode, RegEx
		WinActivate,[a-zA-Z0-9_] ahk_pid %gamePID%
		WinWaitActive,[a-zA-Z0-9_] ahk_pid %gamePID%, ,5
		if (!ErrorLevel) {
			if ( isAdvanced = 1 ) {
				StringReplace, messageToSend, messageToSend, !, {!}, 1
				StringReplace, messageToSend, messageToSend, ^, {^}, 1
				StringReplace, messageToSend, messageToSend, +, {+}, 1
				StringReplace, messageToSend, messageToSend, #, {#}, 1
				SendInput,%messageToSend%
			}
			else {
				sleep 10
				SendInput,{Enter}/{BackSpace}
				SendInput,{Raw}%messageToSend%
				SendInput,{Enter}
			}
		}
		if ( goBackUp > 0 ) {
			SendInput,{Enter}{Up %goBackUp%}{Escape}	; Send back to the previous chat channel
		}
		Logs_Append(A_ThisFunc,, messageToSend, buyerName, gamePID)
		BlockInput, Off
	}
}

Extract_Sound_Files() {
;			Extracts the included sfx into the .ini settings folder
	static
	global sfxFolderPath

	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\MM_Tatl_Gleam.wav,% sfxFolderPath "\MM_Tatl_Gleam.wav", 0
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\MM_Tatl_Hey.wav,% sfxFolderPath "\MM_Tatl_Hey.wav", 0
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\WW_MainMenu_CopyErase_Start.wav,% sfxFolderPath "\WW_MainMenu_CopyErase_Start.wav", 0
	FileInstall, C:\Users\Hatsune\Documents\GitHub\POE-Trades-Helper\SFX\WW_MainMenu_Letter.wav,% sfxFolderPath "\WW_MainMenu_Letter.wav", 0
}

Close_Previous_Program_Instance() {
;			Prevent from running multiple instancies of the program
;			If an instancie already exist, close and replace it by this one
	static
	global iniFilePath

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
	global VALUE_Trades_GUI_Mode
	if ( VALUE_Trades_GUI_Mode = "Overlay" ) {
		Gui_Trades_Cycle_Func()
	}
Return

Gui_Trades_Cycle_Func() {
	static
	global VALUE_Dock_Window, VALUE_Current_DockID, guiTradesHandler, programName

	if !(guiTradesHandler) {
		Loop 2
			TrayTip,% programName,% "Couldn't find the Trades GUI!`nOperation Canceled."
		Return
	}
	matchHandlers := Get_Matching_Windows_Infos("ID")
	VALUE_Current_DockID++
	if ( VALUE_Current_DockID > matchHandlers.MaxIndex() )
		VALUE_Current_DockID := 0
	VALUE_Dock_Window := matchHandlers[VALUE_Current_DockID]
	Gui_Trades_Set_Position()
	Logs_Append(A_ThisFunc,, VALUE_Dock_Window, matchHandlers.MaxIndex())
}

Get_Matching_Windows_Infos(mode) {
	static
	global POEGameList

	matchsArray := Object()
	matchsList := ""
	index := 0

	WinGet, windows, List
	Loop %windows%
	{
		id := windows%A_Index%
		WinGet, ExeName, ProcessName,% "ahk_id " id
		WinGet, ExePID, PID,% "ahk_id " id
		if ExeName in %POEGameList%
		{
			if ( mode = "ID" ) {
				matchsList .= id "`n"
			}
			else if ( mode = "PID" ){
				matchsList .= ExePID "`n"
			}
		}
	}
	Loop, Parse, matchsList, `n
	{
		matchsList := (A_Index=1 ? A_LoopField : matchsList . (InStr("`n" matchsList "`n", "`n" A_LoopField "`n") ? "" : "`n" A_LoopField ) )
	}
	Loop, Parse, matchsList, `n
	{
		if ( A_LoopField != "" ) {
			matchsArray.Insert(index, A_LoopField)
			index++
		}
	}
	return matchsArray
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

WM_MOUSEMOVE() {
;			Taken from Alpha Bravo. Shows tooltip upon hovering a gui control
;			https://autohotkey.com/board/topic/81915-solved-gui-control-tooltip-on-hover/#entry598735
	static
	curControl := A_GuiControl
	If ( curControl <> prevControl ) {
		controlTip := Get_Control_ToolTip(curControl)
		if ( controlTip )
			SetTimer, Display_ToolTip, -1500
		Else
			Gosub, Remove_ToolTip
		prevControl := curControl
	}
	return
	
	Display_ToolTip:
		controlTip := Get_Control_ToolTip(curControl)
		if ( controlTip ) {
			try
				ToolTip,% controlTip
			SetTimer, Remove_ToolTip, -20000
		}
		else {
			ToolTip,
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
	static
	global 0
	global iniFilePath, programName

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
	dpiFactor := Get_DPI_Factor()
	SplashTextOn, 370*dpiFactor, 40*dpiFactor,% programName,% programName " needs to run with Admin .`nAttempt to restart with admin rights in 3 seconds..."
	sleep 3000

	Loop, %0%
		params .= A_Space . %A_Index%
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath
	: A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	OnExit("Exit_Func", 0)
	ExitApp
}

Tray_Refresh() {
;			Refreshes the Tray Icons, to remove any "leftovers"
;			Should work both for Windows 7 and 10
	static

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
	static

	sleep 10
	Reload
	Sleep 10000
}

Exit_Func(ExitReason, ExitCode) {
	static
	global GuiTradesHandler, iniFilePath, VALUE_Trades_GUI_Mode
	if ( VALUE_Trades_GUI_Mode = "Window" ) {
		WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
		IniWrite,% xpos,% iniFilePath,PROGRAM,X_POS
		IniWrite,% ypos,% iniFilePath,PROGRAM,Y_POS
	}
	ExitApp
}