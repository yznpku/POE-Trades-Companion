/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Companion																															*
*					See all the information about the trade request upon receiving a poe.trade whisper															*
*																																								*
*					https://github.com/lemasato/POE-Trades-Companion/																								*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/																						*
*					https://www.pathofexile.com/forum/view-thread/1755148/																						*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

OnExit("Exit_Func")
#SingleInstance Off
#Persistent
#NoEnv
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8 ; Required for cyrillic characters
#KeyHistory 0
SetWinDelay, 0
DetectHiddenWindows, Off

Menu,Tray,Tip,POE Trades Companion
Menu,Tray,NoStandard ; Prevent right clicking the icon while initializing
Menu,Tray,Add,Close,Exit_Func

;	Creating Window Switch Detect
Gui +LastFound 
Hwnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,Hwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage")

Start_Script()
Return

Start_Script() {
/*
*/
	global ProgramValues, GlobalValues, ProgramFonts, RunParameters, GameValues
	global TradesGUI_Controls
	global POEGameArray, POEGameList

;	Values Assignation
	TradesGUI_Controls := Object() ; TradesGUI controls handlers
	ProgramFonts := Object() ; Fonts private to the program
	RunParameters := Object() ; Run-time parameters
	GameValues := Object() ; Settings from the game .ini

	Handle_CommandLine_Parameters()
	MyDocuments := (RunParameters.MyDocuments)?(RunParameters.MyDocuments):(A_MyDocuments)

	GlobalValues := Object() ; Preferences.ini keys + some other shared global variables
	GlobalValues.Insert("Screen_DPI", Get_DPI_Factor())

	ProgramValues := Object() ; Specific to the program's informations
	ProgramValues.Insert("Name", "POE Trades Companion")
	ProgramValues.Insert("Version", "1.9.8")
	ProgramValues.Insert("Debug", 0)
	ProgramValues.Debug := (A_IsCompiled)?(0):(ProgramValues.Debug) ; Prevent from enabling debug on compiled executable

	ProgramValues.Insert("PID", DllCall("GetCurrentProcessId"))

	ProgramValues.Insert("Reddit", "https://redd.it/57oo3h")
	ProgramValues.Insert("GGG", "https://www.pathofexile.com/forum/view-thread/1755148/")
	ProgramValues.Insert("GitHub", "https://github.com/lemasato/POE-Trades-Companion")
	ProgramValues.Insert("Paypal", "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BSWU76BLQBMCU")

	ProgramValues.Insert("Local_Folder", MyDocuments "\AutoHotkey\" ProgramValues["Name"])
	ProgramValues.Insert("SFX_Folder", ProgramValues["Local_Folder"] "\SFX")
	ProgramValues.Insert("Logs_Folder", ProgramValues["Local_Folder"] "\Logs")
	ProgramValues.Insert("Skins_Folder", ProgramValues["Local_Folder"] "\Skins")
	ProgramValues.Insert("Fonts_Folder", ProgramValues["Local_Folder"] "\Fonts")
	ProgramValues.Insert("Others_Folder", ProgramValues["Local_Folder"] "\Others")

	ProgramValues.Insert("Ini_File", ProgramValues["Local_Folder"] "\Preferences.ini")
	ProgramValues.Insert("Logs_File", ProgramValues["Logs_Folder"] "\" A_YYYY "-" A_MM "-" A_DD "_" A_Hour "-" A_Min "-" A_Sec ".txt")
	ProgramValues.Insert("Changelogs_File", ProgramValues["Logs_Folder"] "\changelogs.txt")

	ProgramValues.Insert("Game_Folder", MyDocuments "\my games\Path of Exile")
	ProgramValues.Insert("Game_Ini_File", ProgramValues.Game_Folder "\production_Config.ini")
	ProgramValues.Insert("Game_Ini_File_Copy", ProgramValues.Local_Folder "\production_Config.ini")

	GlobalValues.Insert("Support_Message", "@%buyerName% " ProgramValues.Name ": view-thread/1755148") 

	GroupAdd, POEGame, ahk_exe PathOfExile.exe
	GroupAdd, POEGame, ahk_exe PathOfExile_x64.exe
	GroupAdd, POEGame, ahk_exe PathOfExileSteam.exe
	GroupAdd, POEGame, ahk_exe PathOfExile_x64Steam.exe
	POEGameArray := Object()
	POEGameArray.Insert(0, "PathOfExile.exe", "PathOfExile_x64.exe", "PathOfExileSteam.exe", "PathOfExile_x64Steam.exe")
	POEGameList := "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe"

;	Directories Creation
	Loop {
		directory := (A_Index=1)?(ProgramValues["Local_Folder"])
					:(A_Index=2)?(ProgramValues["SFX_Folder"])
					:(A_Index=3)?(ProgramValues["Logs_Folder"])
					:(A_Index=4)?(ProgramValues["Skins_Folder"])
					:(A_Index=5)?(ProgramValues["Fonts_Folder"])
					:(A_Index=6)?(ProgramValues["Others_Folder"])
					:("ERROR")
		if ( directory = "ERROR" )
			Break

		else if (!InStr(FileExist(directory), "D")) {
			FileCreateDir, % directory
		}
	}

;	Function Calls
	Run_As_Admin()
	Close_Previous_Program_Instance()
	Tray_Refresh()

	Set_Local_Settings()
	localSettings := Get_Local_Settings()
	Declare_Local_Settings(localSettings)

	gameSettings := Get_Game_Settings()
	Declare_Game_Settings(gameSettings)

	Delete_Old_Logs_Files(10)
	Do_Once()
	Extract_Sound_Files()
	Extract_Skin_Files()
	Extract_Font_Files()
	Extract_Others_Files()
	Manage_Font_Resources("LOAD")
	Check_Update()
	Enable_Hotkeys()

	; Pre-rendering Trades-GUI
	Gui_Trades(,"CREATE")
	Create_Tray_Menu()


	;	Debug purposes. Simulates TradesGUI tabs. 
	if ( ProgramValues["Debug"] ) {
		newItemInfos := Object()
		Loop 1 {
			newItemInfos.Insert(0, "iSellStuff", "level 1 Faster Attacks Support", "5 alteration", "Breach (stash tab ""Gems""; position: left 6, top 8)", "",A_Hour ":" A_Min, "Offering 1alch?")
			newItemArray := Gui_Trades_Manage_Trades("ADD_NEW", newItemInfos)
			Gui_Trades(newItemArray, "UPDATE")
			newItemInfos.Insert(0, "aktai0", "Kaom's Heart Glorious Plate", "10 exalted", "Hardcore Legacy", "",A_Hour ":" A_Min, "-")
			newItemArray := Gui_Trades_Manage_Trades("ADD_NEW", newItemInfos)
			Gui_Trades(newItemArray, "UPDATE")
			newItemInfos.Insert(0, "MindDOTA2pl", "Voll's Devotion Agate Amulet ", "4 exalted", "Standard", "",A_Hour ":" A_Min, "-")
			newItemArray := Gui_Trades_Manage_Trades("ADD_NEW", newItemInfos)
			Gui_Trades(newItemArray, "UPDATE")
			newItemInfos.Insert(0, "Krillson", "Rainbowstride Conjurer Boots", "3 mirror", "Hadcore", "",A_Hour ":" A_Min, "-")
			newItemArray := Gui_Trades_Manage_Trades("ADD_NEW", newItemInfos)
			Gui_Trades(newItemArray, "UPDATE")
		}
	}

	; Gui_Settings()
	; Gui_About()
	Logs_Append("DUMP", localSettings)
	Monitor_Game_Logs()
}

;==================================================================================================================
;
;										LOGS MONITORING
;
;==================================================================================================================

Restart_Monitor_Game_Logs() {
	global ProgramValues
	global guiTradesHandler

	Gui_Trades_Save_Position()
	Monitor_Game_Logs("CLOSE")
	Monitor_Game_Logs()
}

Monitor_Game_Logs(mode="") {
;			Retrieve the logs file location by adding \Logs\Client.txt to the PoE executable path
;			Monitor the logs file, waiting for new whispers
;			Upon receiving a poe.trade whisper, pass the trades infos to Gui_Trades()
	static
	global GlobalValues, RunParameters
	global GuiTradesHandler, POEGameArray

	if (mode = "CLOSE") {
		fileObj.Close()
		Return
	}

	if ( RunParameters["GamePath"] ) {
		WinGet, tempExeLocation, ProcessPath,% "ahk_id " element
		SplitPath,% RunParameters["GamePath"], ,directory
		logsFile := directory "\logs\Client.txt"
	}
	else {
		r := Get_All_Games_Instances()
		if ( r = "EXE_NOT_FOUND" ) {
			Gui_Trades_Redraw("EXE_NOT_FOUND", {noSplash:1})
		}
		else {
			logsFile := r
			Gui_Trades_Redraw("UPDATE", {noSplash:1}) ; Prevent the interface from staying on "exe not found"
			Gui_Trades_Set_Position()
		}
	}
	Logs_Append(A_ThisFunc, {File:logsFile})

	fileObj := FileOpen(logsFile, "r")
	fileObj.pos := fileObj.length
	Loop {
		if !FileExist(logsFile) || ( fileObj.pos > fileObj.length ) || ( fileObj.pos = -1 ) {
			Logs_Append("Monitor_Game_Logs_Break", {objPos:fileObj.pos, objLength:fileObj.length})
			Break
		}
		if ( fileObj.pos < fileObj.length ) {
			lastMessage := fileObj.Read() ; Stores the last message into a variable
			Loop, Parse, lastMessage, `n, `r ; For each new individual line since last check
			{
				; New RegEx pattern matches the trading message, but only from whispers and local chat (for debugging), and specifically ignores global/trade/guild/party chats
				if ( RegExMatch( A_LoopField, "^(?:[^ ]+ ){6}(\d+)\] (?=[^#$&%]).*@(?:From|De|От кого) (.*?): (.*)", subPat ) )
				{
					gamePID := subPat1, whispName := subPat2, whispMsg := subPat3
					GlobalValues.Insert("Last_Whisper", whispName)

					; Append the new whisper to the buyer's Other slots
					tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
					for key, element in tradesInfos.BUYERS {
						if (whispName = element) {
							otherContent := tradesInfos.OTHER[key]
							if otherContent not contains (Hover to see all messages) ; Only one message in the Other slot.
							{
								StringReplace, otherContent, otherContent,% "`n",% "",1 ; Remove blank lines
								otherContent := "[" tradesInfos.TIME[key] "] " otherContent ; Add timestamp
							}
							StringReplace, otherContent, otherContent,% "(Hover to see all messages)`n",% "",1
							otherText := "(Hover to see all messages)`n" otherContent "`n[" A_Hour ":" A_Min "] " whispMsg
							setInfos := Object(), setInfos.OTHER := otherText, setInfos.TabID := key
							Gui_Trades_Set_Trades_Infos(setInfos)
						}
					}

					if ( GlobalValues["Whisper_Tray"] = 1 ) && !WinActive("ahk_pid " gamePID) { ; Show a tray notification of the whisper
						Loop 2 {
							TrayTip, Whisper Received:,%whispName%: %whispMsg%
						}
						SetTimer, Remove_TrayTip, -10000
					}

					if ( GlobalValues["Whisper_Flash"] = 1 ) && !WinActive("ahk_pid " gamePID) { ; Flash the game window taskbar icon
						gameHwnd := WinExist("ahk_pid " gamePID)
						DllCall("FlashWindow", UInt, gameHwnd, Int, 1)
					}

					whisp := whispName ": " whispMsg "`n"
					poeappRegExStr := "(.*)wtb (.*) listed for (.*) in (?:(.*)\(stash ""(.*)""; left (.*), top (.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)"
					poetradeRegExStr := "(.*)Hi, I(?: would|'d) like to buy your (?:(.*) |(.*))(?:listed for (.*)|for my (.*)|)(?!:listed for|for my) in (?:(.*)\(stash tab ""(.*)""; position: left (.*), top (.*)\)|Hardcore (.*?)\W|(.*?)\W)(.*)"
					allRegExStr := {poeapp:poeappRegExStr, poetrade:poetradeRegExStr}
					for regExName, regExStr in allRegExStr {
						if RegExMatch(whisp, "i).*: " regExStr) {
							Break
						}
					}
					if RegExMatch(whisp, "i).*: " regExStr, subPat ) ; poe.trade whisper found
					{
						timeSinceLastTrade := 0

						if ( regExName = "poetrade" ) {
							tradeItem := (subPat2)?(subPat2):(subPat3)?(subPat3):("ERROR RETRIEVING ITEM")
							if RegExMatch(tradeItem, "level (.*) (.*)% (.*)", itemPat) {
								tradeItem := itemPat3 " (Lvl:" itemPat1 " / Qual:" itemPat2 "%)"
								itemPat1 := "", itemPat2 := "", itemPat3 := ""
							}
							tradePrice := (subPat4)?(subPat4):(subPat5)?(subPat5):("See Offer")
							tradeStash := (subPat6)?(subPat6 " (Tab:" subPat7 " / Pos:" subPat8 ";" subPat9 ")"):(subPat10)?("Hardcore " subPat10):(subPat11)?(subPat11):("ERROR RETRIEVING LOCATION")
							tradeOther := (subPat11!=subPat6 && subPat11!=subPat10 && subPat11!=tradeStash)?(subPat1 subPat11):(subPat12 && subPat12!="`n")?(subPat12):("-")

							tradeItem = %tradeItem% ; Remove blank spaces
							tradePrice = %tradePrice%
							tradeStash = %tradeStash%
							tradeOther = %tradeOther%
						}
						else if ( regExName = "poeapp" ) {
							tradeItem := subPat2
							if RegExMatch(tradeItem, "(.*) \((.*)/(.*)%\)", itemPat) {
								tradeItem := itemPat1 " (Lvl:" itemPat2 " / Qual:" itemPat3 "%)"
								itemPat1 := "", itemPat2 := "", itemPat3 := ""
							}
							tradePrice := subPat3
							tradeStash := (subPat4)?(subPat4 " (Tab:" subpat5 " / Pos:" subPat6 ";" subPat7 ")"):(subPat8)?("Hardcore " subPat8):(subPat9)?(subPat9):("ERROR RETRIEVING LOCATION")								
							tradeOther := subPat1 . subPat10

							tradeItem = %tradeItem% ; Remove blank spaces
							tradePrice = %tradePrice%
							tradeStash = %tradeStash%
							tradeOther = %tradeOther%
						}

						; Do not add the trade if the same is already in queue
						tradesExists := 0
						tradesInfos := Gui_Trades_Manage_Trades("GET_ALL")
						for key, element in tradesInfos.BUYERS {
							buyerContent := tradesInfos.BUYERS[key], itemContent := tradesInfos.ITEMS[key], priceContent := tradesInfos.PRICES[key], locationContent := tradesInfos.LOCATIONS[key], otherContent = tradesInfos.OTHER[key]
							if (buyerContent=whispName && itemContent=tradeItem && priceContent=tradePrice && locationContent=tradeStash) {
								tradesExists := 1
							}
						}

						; Trade does not already exist
						if (tradesExists = 0) {
							newTradesInfos := Object()
							newTradesInfos.Insert(0, whispName, tradeItem, tradePrice, tradeStash, gamePID, A_Hour ":" A_Min, tradeOther)
							messagesArray := Gui_Trades_Manage_Trades("ADD_NEW", newTradesInfos)
							Gui_Trades(messagesArray, "UPDATE")

							if ( GlobalValues["Trade_Toggle"] = 1 ) && FileExist(GlobalValues["Trade_Sound_Path"]) { ; Play the sound set for trades
								SoundPlay,% GlobalValues["Trade_Sound_Path"]
							}
						}
					}
					else {
						if ( GlobalValues["Whisper_Toggle"] = 1 ) && FileExist(GlobalValues["Whisper_Sound_Path"]) { ; Play the sound set for whispers
							SoundPlay,% GlobalValues["Whisper_Sound_Path"]
						}
					}
				}
			}
		}
		sleepTime := (timeSinceLastTrade>300)?(500):(100)
		timeSinceLastTrade += 1*(sleepTime/1000)
		Sleep %sleepTime%
	}
	Loop 2 {
		TrayTip,% "Issue with the logs file!",% "It could be one of the following reasons: "
		. "`n- The file doesn't exist anymore."
		. "`n- Content from the file was deleted."
		. "`n- The file object used by the program was closed."
		. "`n`nThe logs monitoring function will be restarting in 5 seconds."
	}
	SetTimer, Remove_TrayTip, -5000
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
Hotkeys_TradesGUI_1:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_2:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_3:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_4:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_5:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_6:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_7:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_8:
	Hotkeys_User_Handler(A_ThisLabel)
Return
Hotkeys_TradesGUI_9:
	Hotkeys_User_Handler(A_ThisLabel)
Return

Hotkeys_User_Handler(thisLabel) {

	global GlobalValues, ProgramValues, TradesGUI_Controls, guiTradesHandler

	iniFilePath := ProgramValues["Ini_File"]

	RegExMatch(thisLabel, "\d+", hotkeyID)
	RegExMatch(thisLabel, "\D+", labelType)

	if ( labelType = "Hotkeys_User_" ) {
		tradesInfosArray := Object()
		tabID := GlobalValues["Trades_GUI_Current_Active_Tab"]
		if ( tabID ) {
			tabInfos := Gui_Trades_Get_Trades_Infos(tabID) ; [0] buyerName - [1] itemName - [2] itemPrice
		}
		if ( GlobalValues["Hotkeys_Mode"] = "Advanced" ) {
			key := "HK" hotkeyID
			IniRead, textToSend,% iniFilePath,HOTKEYS_ADVANCED,% key "_ADV_TEXT"
		}
		else {
			key := "HK" hotkeyID
			IniRead, textToSend,% iniFilePath,HOTKEYS,% key "_TEXT"
		}
		messages := [textToSend]
		Send_InGame_Message(messages, tabInfos, {isHotkey:1})
	}
	else if ( labelType = "Hotkeys_TradesGUI_" ) {
		ControlClick,,% "ahk_id " TradesGUI_Controls["Button_Custom_" hotkeyID]
	}
}

;==================================================================================================================
;
;												TRADES GUI
;
;==================================================================================================================

Gui_Trades(infosArray="", errorMsg="") {
;			Trades GUI. Each new item will be added in a new tab
;			Clicking on a button will do its corresponding action
;			Switching tab will clipboard the item's infos if the user enabled
;			Is transparent and click-through when there is no trade on queue
	static
	global ProgramValues, GlobalValues, TradesGUI_Controls
	global GuiTradesHandler, TradesGuiHeight, TradesGuiWidth
	iniFilePath := ProgramValues.Ini_File
	programName := ProgramValues.Name
	programSkinFolderPath := ProgramValues.Skins_Folder

	activeSkin := GlobalValues.Active_Skin
	guiScale := GlobalValues.Scale_Multiplier

	IniRead, fontSizeAuto,% ProgramValues.Fonts_Folder "\Settings.ini",FONTS,% GlobalValues.Font
	fontName := (GlobalValues.Font="System")?(""):(GlobalValues["Font"])
	fontSize := (GlobalValues.Font_Size_Mode="Custom")?(GlobalValues.Font_Size_Custom)
			   :(fontSizeAuto*guiScale)

	colorTitleActive := GlobalValues["Font_Color_Title_Active"]
	colorTitleInactive := GlobalValues["Font_Color_Title_Inactive"]
	colorTradesInfos1 := GlobalValues["Font_Color_Trades_Infos_1"]
	colorTradesInfos2 := GlobalValues["Font_Color_Trades_Infos_2"]
	colorTabs := GlobalValues["Font_Color_Tabs"]
	colorButtons := GlobalValues["Font_Color_Buttons"]
	colorTitleActive := (colorTitleActive="SYSTEM")?(""):(colorTitleActive)
	colorTitleInactive := (colorTitleInactive="SYSTEM")?(""):(colorTitleInactive)
	colorTradesInfos1 := (colorTradesInfos1="SYSTEM")?(""):(colorTradesInfos1)
	colorTradesInfos2 := (colorTradesInfos2="SYSTEM")?(""):(colorTradesInfos2)
	colorTabs := (colorTabs="SYSTEM")?(""):(colorTabs)
	colorButtons := (colorButtons="SYSTEM")?(""):(colorButtons)

	maxTabsRow := 7
	maxTabsStage1 := 10
	maxTabsStage2 := 25
	maxTabsStage3 := 50
	maxTabsStage4 := 100
	maxTabsStage5 := 255

	errorTxt := (errorMsg="EXE_NOT_FOUND")?("Process not found, retrying in 10 seconds...`n`nRight click on the tray icon,`nthen [Settings] to set your preferences.")
				:("No trade on queue!`n`nRight click on the tray icon,`nthen [Settings] to set your preferences.")

	if ( errorMsg = "CREATE" ) {
		Gui, Trades:Destroy
		Gui, Trades:New, +ToolWindow +AlwaysOnTop -Border +hwndGuiTradesHandler +LabelGui_Trades_ +LastFound -SysMenu -Caption
		Gui, Trades:Default
		Gui, Margin, 0, 0

		tabHeight := Gui_Trades_Get_Tab_Height(), tabWidth := 390*guiScale
		guiWidth := 402*guiScale, guiHeight := Floor((tabHeight+38)*guiScale), guiHeightMin := 30*guiScale
		borderSize := 2*Round(guiScale)

		maxTabsRendered := (!maxTabsRendered)?(maxTabsStage1):(maxTabsRendered)

		if ( maxTabsRendered > maxTabsStage2 ) { 
			Loop 2 { ; Skip the tray-tip fade-in animation
				TrayTip,% programName,% "Current tabs limit reached." . "`nRendering more tabs",3
			}
			SetTimer, Remove_TrayTip,-3000
		}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *									System TradesGUI													*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/
		if ( activeSkin = "System" ) {
;			Header
			Gui, Font,s%fontSize%,% fontName
			Gui, Add, Picture,% "x" borderSize . " y" borderSize . " w" guiWidth-borderSize . " h" 30*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Header.png"
			Gui, Add, Picture,% "x" borderSize+10*guiScale . " y" borderSize+5*guiScale . " w" 22*guiScale . " h" 22*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\icon.png"
			Gui, Add, Text,% "x" borderSize+(35*guiScale) . " y" borderSize . " w" guiWidth-(100*guiScale) . " h" 28*guiScale " hwndguiTradesTitleHandler gGui_Trades_Move c" colorTitleInactive . " +BackgroundTrans +0x200 ",% programName " - Queued Trades: 0"
			Gui, Add, Text,% "x" guiWidth-(65*guiScale) . " y" borderSize . " w" 65*guiScale . " h" 28*guiScale " hwndguiTradesMinimizeHandler gGui_Trades_Minimize c" colorTitleInactive . " +BackgroundTrans +0x200",% "MINIMIZE"

;			Borders
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" guiWidth . " h" borderSize,% programSkinFolderPath "\" activeSkin "\Border.png" ; Top
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" borderSize . " h" guiHeight,% programSkinFolderPath "\" activeSkin "\Border.png" ; Left
			Gui, Add, Picture,% "x" guiWidth-borderSize . " y" 0 . " w" borderSize . " h" guiHeight,% programSkinFolderPath "\" activeSkin "\Border.png" ; Right
			Gui, Add, Picture,% "x" 0 . " y" guiHeight-borderSize . " w" guiWidth . " h" borderSize,% programSkinFolderPath "\" activeSkin "\Border.png" ; Bottom

			Gui, Add, Text,% "x" borderSize . " y" 70*guiScale . " w" guiWidth-borderSize . " hwndErrorMsgTextHandler" . " Center +BackgroundTrans c" colorTradesInfos1,% errorTxt
			Gui, Add, Tab3,% "x" borderSize . " y" 30*guiScale . " w" . guiWidth-borderSize " h" (tabHeight+7)*guiScale . " -Wrap  vTab hwndTabHandler gGui_Trades_OnTabSwitch +BackgroundTrans",% ""
			TradesGUI_Controls.Insert("Tab", TabHandler)


			Loop %maxTabsRendered% {
				index := A_Index
				Gui, Tab,%index%

				Gui, Add, Button,% "x" 374*guiScale . " y" 38*guiScale . " w" 20*guiScale . " h" 20*guiScale . " vdelBtn" index . " hwndCloseBtn1Handler" . " gGui_Trades_RemoveItem +BackgroundTrans",X

;				Buyer / Item / ... Static Text
				Gui, Add, Text,% "x" 9*guiScale . " y" 40*guiScale . " w" 60*guiScale . " h" 15*guiScale . " hwndBuyerText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Buyer: "
				Gui, Add, Text,% "x" 9*guiScale . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndItemText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Item: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndPriceText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Price: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndLocationText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Location: "
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndOtherText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Other: "

;				Buyer / Item / ... Slots
				Gui, Add, Text,% "x" 75*guiScale . " y" 40*guiScale . " w" 255*guiScale . " h" 15*guiScale . " vBuyerSlot" index . " hwndBuyerSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vItemSlot" index . " hwndItemSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vPriceSlot" index . " hwndPriceSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vLocationSlot" index . " hwndLocationSlot" index "Handler" . " +BackgroundTrans +0x0100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vOtherSlot" index . " hwndOtherSlot" index "Handler" . " +BackgroundTrans +0x100 R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "x" 340*guiScale . " y" 40*guiScale . " w" 30*guiScale . " h" 15*guiScale . " vTimeSlot" index . " hwndTimeSlot" index "Handler" . " +BackgroundTrans R1" . " c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vPIDSlot" index . " hwndPIDSlot" index "Handler +BackgroundTrans" . " c" colorTradesInfos2,% ""

				TradesGUI_Controls.Insert("Buyer_Slot_" index,BuyerSlot%index%Handler)
				TradesGUI_Controls.Insert("Item_Slot_" index,ItemSlot%index%Handler)
				TradesGUI_Controls.Insert("Price_Slot_" index,PriceSlot%index%Handler)
				TradesGUI_Controls.Insert("Location_Slot_" index,LocationSlot%index%Handler)
				TradesGUI_Controls.Insert("Other_Slot_" index,OtherSlot%index%Handler)
				TradesGUI_Controls.Insert("Time_Slot_" index,TimeSlot%index%Handler)
				TradesGUI_Controls.Insert("PID_Slot_" index,PIDSlot%index%Handler)

				;__TO_BE_ADDED__ New buttons, smaller with a specific action
				if ( debug = 2 ) {
					; hexCodes := [ "0527", "0427", "C621", "CC21", "0927", "9923", "2623" ]
					fonts := ["Wingdings 3", "Wingdings 2", "Wingdings", "Wingdings", "MyScriptFont"]
					hexCodes := ["44", "32", "2A", "33", "41"]
					for key, element in hexCodes {
						xpos := ((A_Index-1)*35)+9
						Gui, Font,% "S" fontSize+3,% fonts[A_Index]
						Gui, Add, Button,% "x" xpos . " y120" . " w30 h20 " . " hwndUnicodeBtn" A_Index "Handler",% ""
						ConvertesChars := Hex2Bin(nString, element) ; Convert hex code into its corresponding unicode character
		   				SetUnicodeText(nString, UnicodeBtn%A_Index%Handler) ; Replace the control's content with the unicode character
	   				}
					; Gui, Add, Button,% "xm+10" . " y120" . " w20 h20",
					Gui, Font ; Revert to system font
					Gui, Font,% "S" fontSize
				}
				;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _


				;			Customizable Buttons.
				Loop 9 {
					btnW := (GlobalValues["Button" A_Index "_SIZE"]="Small")?(124):(GlobalValues["Button" A_Index "_SIZE"]="Medium")?(254):(GlobalValues["Button" A_Index "_SIZE"]="Large")?(384):("ERROR")
					btnX := (GlobalValues["Button" A_Index "_H"]="Left")?(9):(GlobalValues["Button" A_Index "_H"]="Center")?(139):(GlobalValues["Button" A_Index "_H"]="Right")?(269):("ERROR")
					btnY := (GlobalValues["Button" A_Index "_V"]="Top")?(120):(GlobalValues["Button" A_Index "_V"]="Middle")?(160):(GlobalValues["Button" A_Index "_V"]="Bottom")?(200):("ERROR")
					btnName := GlobalValues["Button" A_Index "_Label"]
					btnSub := RegExReplace(GlobalValues["Button" A_Index "_Action"], "[ _+()]", "_")
					btnSub := RegExReplace(btnSub, "___", "_")
					btnSub := RegExReplace(btnSub, "__", "_")
					btnSub := RegExReplace(btnSub, "_", "", ,1,-1)
					if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnSub != "" && btnSub != "ERROR" ) {
						Gui, Add, Button,% "x" btnX*guiScale . " y" btnY*guiScale . " w" btnW*guiScale . " h" 35*guiScale . " vCustomBtn" A_Index "_" index  . " hwndCustomBtn" A_Index "_" index "Handler" . " gGui_Trades_" btnSub . " +BackgroundTrans c" colorButtons,% btnName
						TradesGUI_Controls.Insert("Button_Custom_" A_Index, CustomBtn%A_Index%_%index%Handler)
					}
				}
			}
		}
			
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *									Skinned TradesGUI													*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/
		else {
;			Header
			Gui, Color, Black ; Prevents the flickering from being too noticeable
			Gui, Font,s%fontSize%,% fontName
			Gui, Add, Picture,% "x" borderSize . " y" borderSize . " w" guiWidth-borderSize . " h" 30*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Header.png"
			Gui, Add, Picture,% "x" borderSize+10*guiScale . " y" borderSize+5*guiScale . " w" 22*guiScale . " h" 22*guiScale . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\icon.png"
			Gui, Add, Text,% "x" borderSize+(35*guiScale) . " y" borderSize . " w" guiWidth-(100*guiScale) . " h" 28*guiScale " hwndguiTradesTitleHandler gGui_Trades_Move c" colorTitleInactive . " +BackgroundTrans +0x200 ",% programName " - Queued Trades: 0"
			Gui, Add, Text,% "x" guiWidth-(65*guiScale) . " y" borderSize . " w" 65*guiScale . " h" 28*guiScale " hwndguiTradesMinimizeHandler gGui_Trades_Minimize c" colorTitleInactive . " +BackgroundTrans +0x200",% "MINIMIZE"

;			Static pictures assets
			Gui, Add, Picture,% "x" borderSize . " y" 30*guiScale . " w" guiWidth-borderSize . " h" guiHeight-borderSize . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Background.png"
			Gui, Add, Picture,% "x" 0 . " y" 50*guiScale . " w" guiWidth . " h" 2*guiScale . " hwndTabUnderlineHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\TabUnderline.png"
			Gui, Add, Picture,% "x" 360*guiScale . " y" 30*guiScale . " w" 20*guiScale . " h" 20*guiScale . " vGoLeft" . " hwndGoLeftHandler" . " gGui_Trades_Arrow_Left +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ArrowLeft.png"
			Gui, Add, Picture,% "x" 380*guiScale . " y" 30*guiScale . " w" 20*guiScale . " h" 20*guiScale . " vGoRight" . " hwndGoRightHandler" . " gGui_Trades_Arrow_Right +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ArrowRight.png"
			Gui, Add, Picture,% "x" 374*guiScale . " y" 53*guiScale . " w" 25*guiScale . " h" 25*guiScale . " vdelBtn1" . " hwndCloseBtn1Handler" . " gGui_Trades_RemoveItem  +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\Close.png"
			TradesGUI_Controls.Insert("Arrow_Left", GoLeftHandler)
			TradesGUI_Controls.Insert("Arrow_Right", GoRightHandler)
			TradesGUI_Controls.Insert("Button_Close", CloseBtn1Handler)

;			Borders
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" guiWidth . " h" borderSize,% programSkinFolderPath "\" activeSkin "\Border.png" ; Top
			Gui, Add, Picture,% "x" 0 . " y" 0 . " w" borderSize . " h" guiHeight,% programSkinFolderPath "\" activeSkin "\Border.png" ; Left
			Gui, Add, Picture,% "x" guiWidth-borderSize . " y" 0 . " w" borderSize . " h" guiHeight,% programSkinFolderPath "\" activeSkin "\Border.png" ; Right
			Gui, Add, Picture,% "x" 0 . " y" guiHeight-borderSize . " w" guiWidth . " h" borderSize,% programSkinFolderPath "\" activeSkin "\Border.png" ; Bottom

;			Error message
			Gui, Add, Text,% "x" borderSize . " y" 70*guiScale . " w" guiWidth-borderSize . " hwndErrorMsgTextHandler" . " Center +BackgroundTrans c" colorTradesInfos1,% errorTxt

			Loop %maxTabsRendered% {
				index := A_Index, tabPos := A_Index, xposMult := 50
				xpos := (tabPos * xposMult) - xposMult + borderSize, ypos := 30

;				Tab Pictures
				Gui, Add, Picture,% "x" xpos*guiScale . " y" ypos*guiScale . " w" 48*guiScale . " h" 20*guiScale " hwndTabIMG" index "Handler" . " vTabIMG" index . " gGui_Trades_Tabs_Handler +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\TabInactive.png"
				Gui, Font,% "Bold"
				Gui, Add, Text,% "xp" . " yp+" 3*guiScale . " w" 50*guiScale . " h" 20*guiScale . " hwndTabTXT" index "Handler" . " vTabTXT" index . " gGui_Trades_Tabs_Handler +BackgroundTrans 0x01 c" colorTabs,% index
				Gui, Font, Norm

;				Buyer / Item / ... Static Text
				if ( index = 1 ) {
					Gui, Add, Text,% "x" 9*guiScale . " y" 60*guiScale . " w" 60*guiScale . " h" 15*guiScale . " hwndBuyerText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Buyer: "
					Gui, Add, Text,% "x" 9*guiScale . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndItemText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Item: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndPriceText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Price: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndLocationText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Location: "
					Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 60*guiScale . " h" 15*guiScale " hwndOtherText" index "Handler" . " +BackgroundTrans" . " c" colorTradesInfos1,% "Other: "
				}

;				Buyer / Item / ... Slots
				Gui, Add, Text,% "x" 75*guiScale . " y" 60*guiScale . " w" 255*guiScale . " h" 15*guiScale . " vBuyerSlot" index . " hwndBuyerSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vItemSlot" index . " hwndItemSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vPriceSlot" index . " hwndPriceSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vLocationSlot" index . " hwndLocationSlot" index "Handler" . " +BackgroundTrans +0x0100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp+" 15*guiScale . " w" 310*guiScale . " h" 15*guiScale . " vOtherSlot" index . " hwndOtherSlot" index "Handler" . " +BackgroundTrans +0x100 R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "x" 340*guiScale . " y" 60*guiScale " w" 30*guiScale . " h" 15*guiScale . " vTimeSlot" index . " hwndTimeSlot" index "Handler" . " +BackgroundTrans R1 c" colorTradesInfos2,% ""
				Gui, Add, Text,% "xp" . " yp" . " w0" . " h0" . " vPIDSlot" index . " hwndPIDSlot" index "Handler",


;				Hide the controls. They will be re-enabled later, based on the current amount of trade requests.
				GuiControl, Trades:Hide,% TabIMG%index%Handler
				GuiControl, Trades:Hide,% TabTXT%index%Handler
				TradesGUI_Controls.Insert("Tab_IMG_" index,TabIMG%index%Handler)
				TradesGUI_Controls.Insert("Tab_TXT_" index,TabTXT%index%Handler)

				GuiControl, Trades:Hide,BuyerSlot%index%
				GuiControl, Trades:Hide,ItemSlot%index%
				GuiControl, Trades:Hide,PriceSlot%index%
				GuiControl, Trades:Hide,LocationSlot%index%
				GuiControl, Trades:Hide,OtherSlot%index%
				GuiControl, Trades:Hide,TimeSlot%index%
				TradesGUI_Controls.Insert("Buyer_Slot_" index,BuyerSlot%index%Handler)
				TradesGUI_Controls.Insert("Item_Slot_" index,ItemSlot%index%Handler)
				TradesGUI_Controls.Insert("Price_Slot_" index,PriceSlot%index%Handler)
				TradesGUI_Controls.Insert("Location_Slot_" index,LocationSlot%index%Handler)
				TradesGUI_Controls.Insert("Other_Slot_" index,OtherSlot%index%Handler)
				TradesGUI_Controls.Insert("Time_Slot_" index,TimeSlot%index%Handler)
				TradesGUI_Controls.Insert("PID_Slot_" index,PIDSlot%index%Handler)
			}

;			Customizable Buttons.
			Loop 9 {
				btnW := (GlobalValues["Button" A_Index "_SIZE"]="Small")?(124):(GlobalValues["Button" A_Index "_SIZE"]="Medium")?(254):(GlobalValues["Button" A_Index "_SIZE"]="Large")?(384):("ERROR")
				btnX := (GlobalValues["Button" A_Index "_H"]="Left")?(9):(GlobalValues["Button" A_Index "_H"]="Center")?(139):(GlobalValues["Button" A_Index "_H"]="Right")?(269):("ERROR")
				btnY := (GlobalValues["Button" A_Index "_V"]="Top")?(140):(GlobalValues["Button" A_Index "_V"]="Middle")?(180):(GlobalValues["Button" A_Index "_V"]="Bottom")?(220):("ERROR")
				btnName := GlobalValues["Button" A_Index "_Label"]
				btnSub := RegExReplace(GlobalValues["Button" A_Index "_Action"], "[ _+()]", "_")
				btnSub := RegExReplace(btnSub, "___", "_")
				btnSub := RegExReplace(btnSub, "__", "_")
				btnSub := RegExReplace(btnSub, "_", "", ,1,-1)
				if ( btnW != "ERROR" && btnX != "ERROR" && btnY != "ERROR" && btnSub != "" && btnSub != "ERROR" ) {
					Gui, Add, Picture,% "x" btnX*guiScale . " y" btnY*guiScale . " w" btnW*guiScale . " h" 35*guiScale . " vCustomBtn" A_Index . " hwndCustomBtn" A_Index "Handler" . " +BackgroundTrans gGui_Trades_" btnSub,% programSkinFolderPath "\" activeSkin "\ButtonBackground.png"
					Gui, Add, Picture,% "x" btnX*guiScale . " y" btnY*guiScale . " w" 8*guiScale . " h" 35*guiScale . " vCustomBtn" A_Index "OrnamentLeft" . " hwndCustomBtn" A_Index "OrnamentLeftHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonOrnamentLeft.png"
					Gui, Add, Picture,% "x" (btnX*guiScale)+(btnW-8)*guiScale . " y" btnY*guiScale . " w" 8*guiScale . " h" 35*guiScale . " vCustomBtn" A_Index "OrnamentRight" . " hwndCustomBtn" A_Index "OrnamentRightHandler" . " +BackgroundTrans",% programSkinFolderPath "\" activeSkin "\ButtonOrnamentRight.png"
					Gui, Add, Text,% "x" btnX*guiScale . " yp+" 10*guiScale . " w" btnW*guiScale . " vCustomBtnTXT" A_Index . " hwndCustomBtnTXT" A_Index "Handler" . " Center +BackgroundTrans c" colorButtons,% btnName

					TradesGUI_Controls.Insert("Button_Custom_" A_Index, CustomBtn%A_Index%Handler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_OrnamentLeft", CustomBtn%A_Index%OrnamentLeftHandler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_OrnamentRight", CustomBtn%A_Index%OrnamentRightHandler)
					TradesGUI_Controls.Insert("Button_Custom_" A_Index "_Text", CustomBtnTXT%A_Index%Handler)
				}
			}
		}
	}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

	if ( errorMsg = "EXE_NOT_FOUND" ) {
		Loop {
			countdown := 10
			Loop 11 {
				GuiControl, Trades:,% ErrorMsgTextHandler,% "Process not found, retrying in " countdown " seconds...`n`nRight click on the tray icon,`nthen [Settings] to set your preferences."
				countDown--
				Sleep 1000
			}
			gameInstances := Get_All_Games_Instances()
			if ( gameInstances != "EXE_NOT_FOUND" )
				Break
		}
		gameInstances := ""
		Monitor_Game_Logs()
	}
	else if ( errorMsg = "REMOVE_DUPLICATES" ) {
		tabToDel := infosArray[0]
		for key, element in infosArray {
			messagesArray := Gui_Trades_Manage_Trades("REMOVE_CURRENT", ,element)
			if ( tabToDel >= element ) ; our tabToDel moved to the left due to a lesser tab being deleted
				tabToDel--
			Gui_Trades(messagesArray, "UPDATE")
			if ( activeSkin != "System" )
				Gosub, Gui_Trades_Tabs_Handler
		}
	}
	if ( errorMsg = "UPDATE" || errorMsg = "CREATE" ) {

		tabsCount := (infosArray.BUYERS.Length())?(infosArray.BUYERS.Length()):(0) ; If empty, set to 0
		if (activeSkin="System") {
			currentActiveTab := (Gui_Trades_Get_Tab_ID())?(Gui_Trades_Get_Tab_ID()):(currentActiveTab) ; Retain the value if the return is empty
		}

		lastActiveTab := (GlobalValues.Trades_Select_Last_Tab && tabsCount >p reviousTabsCount)?(currentActiveTab) ; Select last tab enabled. Last tab is now the current tab (before current tab is assigned to most recent tab)
						:(lastActiveTab) ; Leave it as it is
		currentActiveTab := (!currentActiveTab)?(1) ; Value previously unassigned, make sure to focus tab 1.
						   :(GlobalValues.Trades_Select_Last_Tab && tabsCount > previousTabsCount)?(tabsCount) ; Assign to most recent tab.
						   :(currentActiveTab) ; Leave it as it is

;		Update the fields with the trade infos
		tabsList := "", isGuiActive := false
		for key, element in infosArray.BUYERS {
			isGuiActive := true
			tabsList .= "|" key
			GuiControl, Trades:,% buyerSlot%key%Handler,% infosArray.BUYERS[key]
			GuiControl, Trades:,% itemSlot%key%Handler,% infosArray.ITEMS[key]
			GuiControl, Trades:,% priceSlot%key%Handler,% infosArray.PRICES[key]
			GuiControl, Trades:,% locationSlot%key%Handler,% infosArray.LOCATIONS[key]
			GuiControl, Trades:,% PIDSlot%key%Handler,% infosArray.GAMEPID[key]
			GuiControl, Trades:,% TimeSlot%key%Handler,% infosArray.TIME[key]
			GuiControl, Trades:,% OtherSlot%key%Handler,% infosArray.OTHER[key]
			if ( key <= maxTabsRow && activeSkin != "System" ) {
				GuiControl, Trades:Show,% TabIMG%key%Handler
				GuiControl, Trades:Show,% TabTXT%key%Handler
			}
		}

;		Handle some GUI elements
		if (isGuiActive) {
			showState := "Show"
			GuiControl, Trades:Hide,% ErrorMsgTextHandler
			GuiControl, Trades: +c%colorTitleActive%,% guiTradesTitleHandler
			GuiControl, Trades: +c%colorTitleActive%,% guiTradesMinimizeHandler
		}
		else {
			showState := "Hide"
			GuiControl, Trades:,% ErrorMsgTextHandler,% errorTxt
			GuiControl, Trades:Show,% ErrorMsgTextHandler
			GuiControl, Trades: +c%colorTitleInactive%,% guiTradesTitleHandler
			GuiControl, Trades: +c%colorTitleInactive%,% guiTradesMinimizeHandler
		}
		clickThroughState := ( GlobalValues.Trades_Click_Through && !isGuiActive )?("+"):("-")
		transparency := (!isGuiActive)?(GlobalValues.Transparency):(GlobalValues.Transparency_Active)
		Gui, Trades: +LastFound
		Gui, Trades: %clickThroughState%E0x20
		WinSet, Transparent,% transparency ; Using A_Gui instead of the Gui's handle fixes an issue where the transparency would not be applied with EXE_NOT_FOUND.
										   ; After testings, it creates another issue where it sets the transparency to the game's window
										   ; It seems that activating another window prior to applying the transparency allows us to use the handler.
										   ; Using +LastFound and WinSet without any specified window seems to be the most reliable way to detect the GUI handler.

		GuiControl, Trades:Text,% guiTradesTitleHandler,% programName " - Queued Trades: " tabsCount ; Update the title
		GuiControl, Trades:%showState%,Tab ; Only used when no skin is applied
		GuiControl, Trades:%showState%,% GoLeftHandler ; Only used for skins
		GuiControl, Trades:%showState%,% GoRightHandler ; Only used for skins
		GuiControl, Trades:%showState%,% TabUnderlineHandler ; Only used for skins

		if ( activeSkin != "System" ) { ; Remove the deleted tab image.
			tabDeleted := tabsCount+1
			GuiControl, Trades:Hide,% TabIMG%tabDeleted%Handler
			GuiControl, Trades:Hide,% TabTXT%tabDeleted%Handler

			Loop 9 { ; Hide or show the controls.
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%Handler
				GuiControl, Trades:%showState%,% CustomBtnTXT%A_Index%Handler
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%OrnamentLeftHandler
				GuiControl, Trades:%showState%,% CustomBtn%A_Index%OrnamentRightHandler

				GuiControl, Trades:%showState%,% BuyerText1Handler
				GuiControl, Trades:%showState%,% ItemText1Handler
				GuiControl, Trades:%showState%,% PriceText1Handler
				GuiControl, Trades:%showState%,% LocationText1Handler
				GuiControl, Trades:%showState%,% CloseBtn1Handler
				GuiControl, Trades:%showState%,% OtherText1Handler
			}

			Gosub Gui_Trades_Tabs_Handler ;	Make sure all tabs are correctly ordered.
		}
		else {
			GuiControl, Trades:,Tab,% tabsList  ;	Apply the new list of tabs.
;			Select the correct tab after udpating
			if ( GlobalValues.Trades_Select_Last_Tab ) && (!A_GuiEvent) { ; A_GuiEvent means we've just closed a tab. We do not want to activate the latest available tab.
				GuiControl, Trades:Choose,Tab,% tabsCount
				GlobalValues.Trades_GUI_Current_Active_Tab := tabsCount
			}
			else {
				GuiControl, Trades:Choose,Tab,%currentActiveTab%
				if ( ErrorLevel ) {
					GuiControl, Trades:Choose,Tab,% currentActiveTab-1
					currentActiveTab--
				}
			}
		}

		if (tabsCount >= maxTabsRendered-1 && maxTabsRendered != maxTabsStage5) { ;	Tabs limit almost reached.
			maxTabsRendered := (maxTabsRendered=maxTabsStage1)?(maxTabsStage2)
							  :(maxTabsRendered=maxTabsStage2)?(maxTabsStage3)
							  :(maxTabsRendered=maxTabsStage3)?(maxTabsStage4)
							  :(maxTabsRendered=maxTabsStage4)?(maxTabsStage5)
							  :(maxTabsStage2)
			if ( activeSkin="System")
				currentActiveTab := Gui_Trades_Get_Tab_ID()
			else
				currentActiveTab := GlobalValues.Trades_GUI_Current_Active_Tab

			currentActiveTab := (!currentActiveTab)?(1):(currentActiveTab)
			lastActiveTab := currentActiveTab+1
			Gui_Trades_Redraw("CREATE", {noSplash:1})

			if ( activeSkin != "System" ) {
				Loop { ; Go back to the previously selected tab
					currentActiveTab := (GlobalValues["Trades_Select_Last_Tab"] = 1)?(tabsCount):(currentActiveTab) ; Set the active tab to the latest available tab if Select_Last_Tab is enabled

					GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" maxTabsRow]
					GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]
					if currentActiveTab between %firstTab% and %lastTab%
						Break
					GoSub Gui_Trades_Arrow_Right
				}
				GoSub Gui_Trades_Tabs_Handler
				lastActiveTab := (GlobalValues["Trades_Select_Last_Tab"] = 1)?(currentActiveTab):(lastActiveTab) ; Avoid controls content overlap
				if ( GlobalValues.Clip_On_Tab_Switch )
					GoSub Gui_Trades_Clipboard_Item
			}
			else {
				currentActiveTab := (GlobalValues.Trades_Select_Last_Tab)?(tabsCount):(lastActiveTab-1)
				GuiControl, Trades:Choose,Tab,% currentActiveTab
				if ( GlobalValues.Clip_On_Tab_Switch )
					GoSub Gui_Trades_Clipboard_Item
			}
			Return
		}
		if (tabsCount=0 && maxTabsRendered>maxTabsStage1) && (errorMsg!="CREATE") { ; Tabs limit higher than default, and no tab on queue. We can reset to default limit.
			maxTabsRendered := maxTabsStage1
			Gui_Trades_Redraw("CREATE", {noSplash:1})
			currentActiveTab := 0, lastActiveTab := 0
			Return
		}

		if ( activeSkin != "System") {
			if ( GlobalValues.Trades_Select_Last_Tab ) && ( tabsCount > previousTabsCount ) {
					GoSub Gui_Trades_Tabs_Handler
					GoSub Gui_Trades_Arrow_Right
					GoSub Gui_Trades_Arrow_Right ; Make sure the tab bar is on far right
			}
		}

		if ( GlobalValues.Trades_Auto_Minimize && !isGuiActive && tradesGuiHeight != guiHeightMin && errorMsg != "EXE_NOT_FOUND" ) {
			GlobalValues.Trades_GUI_Minimized := 0
			GoSub, Gui_Trades_Minimize
		}
		if ( GlobalValues.Trades_Auto_UnMinimize && isGuiActive && tradesGuiHeight != guiHeight ) {
			GlobalValues.Trades_GUI_Minimized := 1
			GoSub, Gui_Trades_Minimize
		}

		if ( GlobalValues.Clip_On_Tab_Switch )
			GoSub Gui_Trades_Clipboard_Item
	}
	if ( errorMsg = "CREATE" ) {
		showWidth := guiWidth
		showHeight := (GlobalValues.Trades_GUI_Minimized)?(guiHeightMin):(guiHeight)
		IniRead, showX,% iniFilePath,PROGRAM,X_POS
		IniRead, showY,% iniFilePath,PROGRAM,Y_POS
		showXDefault := A_ScreenWidth-(showWidth), showYDefault := 0 ; Top right
		showX := (showX="ERROR"||showX=""||(!showX && showX != 0))?(showXDefault):(showX) ; Prevent unassigned or incorrect value
		showY := (showY="ERROR"||showY=""||(!showY && showY != 0))?(showYDefault):(showY)
		Gui, Trades:Show,% "NoActivate w" showWidth " h" showHeight " x" showX " y" showY,% programName " - Queued Trades"
		OnMessage(0x200, "WM_MOUSEMOVE")
		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x203, "WM_LBUTTONDBLCLK")
		OnMessage(0x2A3, "WM_MOUSELEAVE")
		OnMessage(0x204, "WM_RBUTTONDOWN")

		dpiFactor := GlobalValues["Screen_DPI"], showX := guiWidth-49
	}


	if ( GlobalValues["Trades_GUI_Mode"] = "Overlay") {
		try	Gui_Trades_Set_Position()
	}

	Gui, Trades: +LastFound
	WinSet, Redraw
	WinSet, AlwaysOnTop, On
	IniWrite,% tabsCount,% iniFilePath,PROGRAM,Tabs_Number

	GlobalValues.Trades_GUI_Current_Active_Tab := currentActiveTab
	previousTabsCount := tabsCount
	sleep 10
	return

	Gui_Trades_OnTabSwitch:
;		Clipboard the item's infos on tab switch if the user enabled
		Gui, Submit, NoHide
		currentActiveTab := Gui_Trades_Get_Tab_ID()
		if (  GlobalValues.Clip_On_Tab_Switch )
			Gui_Trades_Clipboard_Item_Func(currentActiveTab)
		GlobalValues.Insert("Trades_GUI_Current_Active_Tab", currentActiveTab)
	return

	Gui_Trades_Arrow_Left:
;		Only used when a skin is applied.
;		Simulates scrolling through tabs.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" maxTabsRow]
		GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]

		if ( firstTab > 1 ) {
			index := maxTabsRow
			Loop %maxTabsRow% {
				index := A_Index
				txtContent := firstTab+index-2
				GuiControl,Trades:,% TradesGUI_Controls["Tab_TXT_" index],% txtContent
			}
			inactiveTabID := lastActiveTab-firstTab+1
			activeTabID := currentActiveTab-firstTab+2
			if (inactiveTabID > 0) ; Prevents from using a negative TabID due to the users selecting a tab, then moving with the arrows and selecting a new tab while the old one is out of range
				GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" inactiveTabID],% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\TabInactive.png"
			if (activeTabID > 0)
				GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" activeTabID],% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\TabActive.png"
		}
	Return

	Gui_Trades_Arrow_Right:
;		Only used when a skin is applied.
;		Simulates scrolling through tabs.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" maxTabsRow]
		GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]

		if ( tabsCount > lastTab ) {
			index := maxTabsRow
			Loop %maxTabsRow% {
				index := A_Index
				txtContent := firstTab+index
				GuiControl,Trades:,% TradesGUI_Controls["Tab_TXT_" index],% txtContent
			}
			inactiveTabID := lastActiveTab-firstTab+1
			activeTabID := currentActiveTab-firstTab
			if (inactiveTabID > 0) ; Prevents from using a negative TabID due to the users selecting a tab, then moving with the arrows and selecting a new tab while the old one is out of range
				GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" inactiveTabID],% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\TabInactive.png"
			if (activeTabID > 0)
				GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" activeTabID],% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\TabActive.png"
		}

	Return

	Gui_Trades_Tabs_Handler:
;		Only used when a skin is applied.
;		Set the "Active" tab image when the user click a tab.
;		Reposition the tab-bar after deleting a tab.
		GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" maxTabsRow]
		GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]

		RegExMatch(A_GuiControl, "\D+", btnType)
		RegExMatch(A_GuiControl, "\d+", btnID)
		btnType := (btnType = "CustomBtn")?("delBtn"):(btnType) ; Label is accessed from a Custom button, act like the DelBtn

		if ( btnType = "TabIMG" ) { ; User switched tab
			GuiControlGet, tabID, Trades:,% TradesGUI_Controls["Tab_TXT_" btnID]
			currentActiveTab := tabID
			if ( GlobalValues["Clip_On_Tab_Switch"] = 1 )
				Gui_Trades_Clipboard_Item_Func(currentActiveTab)
		}

		if ( btnType != "delBtn" && A_GuiControl ) {
			GuiControlGet, tabID, Trades:,% TradesGUI_Controls["Tab_TXT_" btnID]
			currentActiveTab := (tabID)?(tabID):(currentActiveTab)
		}

		if ( tabsCount < currentActiveTab ) && ( tabsCount > 0 ) {
;			User closed the highest available tab
;			Add one to the lastActiveTab prevent from having new trades text from overlapping the current tab
			currentActiveTab--
			lastActiveTab := currentActiveTab+1
			wasReduced := 1
		}

		showState := "Hide"
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Buyer_Slot_" lastActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Item_Slot_" lastActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Price_Slot_" lastActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Location_Slot_" lastActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Time_Slot_" lastActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Other_Slot_" lastActiveTab]

		showState := "Show"
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Buyer_Slot_" currentActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Item_Slot_" currentActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Price_Slot_" currentActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Location_Slot_" currentActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Time_Slot_" currentActiveTab]
		GuiControl, Trades:%showState%,% TradesGUI_Controls["Other_Slot_" currentActiveTab]

		activeTabID := (wasReduced=1 && currentActiveTab > maxTabsRow)?(currentActiveTab-firstTab+2):(currentActiveTab-firstTab+1)
		inactiveTabID := (wasReduced=1)?(activeTabID+1):(lastActiveTab-firstTab+1)

		if (inactiveTabID > 0) ; Prevents from using a negative TabID due to the users selecting a tab, then moving with the arrows and selecting a new tab while the old one is out of range 
			GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" inactiveTabID],% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\TabInactive.png"
		GuiControl, Trades:,% TradesGUI_Controls["Tab_IMG_" activeTabID],% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\TabActive.png"

		if ( btnType != "delBtn" || wasReduced = 1 ) {
			lastActiveTab := currentActiveTab
			wasReduced := 0
		}

		if ( (lastTab > tabsCount && tabsCount > maxTabsRow) || (lastTab = maxTabsRow+1 && firstTab = 2 && tabsCount = maxTabsRow) ) {
			GoSub Gui_Trades_Arrow_Right
			GoSub Gui_Trades_Arrow_Left
		}

		GlobalValues.Insert("Trades_GUI_Current_Active_Tab", currentActiveTab)
	Return

	Gui_Trades_Minimize:
;		Switch between minimized and full-sized.
		if !WinExist("ahk_id " guiTradesHandler)
			Return

		GlobalValues.Insert("Trades_GUI_Minimized", !GlobalValues["Trades_GUI_Minimized"])
		if ( GlobalValues["Trades_GUI_Minimized"] ) {
			tHeight := guiHeight
			Loop {
				if ( tHeight = guiHeightMin )
					Break
				tHeight := (guiHeightMin<tHeight)?(tHeight-30):(guiHeightMin)
				tHeight := (tHeight-30<guiHeightMin)?(guiHeightMin):(tHeight)
				Gui, Trades:Show, NoActivate h%tHeight%
				sleep 1 ; Smoothen up the animation
			}
		}
		else  {
			tHeight := guiHeightMin
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
;		Allows dragging the GUI when holding left click on the title bar.
		if ( GlobalValues["Trades_GUI_Mode"] = "Window" ) {
			PostMessage, 0xA1, 2,,,% "ahk_id " guiTradesHandler
		}
		KeyWait, LButton, Up
		Gui_Trades_Save_Position()
	Return 

	Gui_Trades_Clipboard_Item:
;		Clipboard the current tab item upon pressing the button.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		Gui_Trades_Clipboard_Item_Func(currentActiveTab)
	Return

	Gui_Trades_Send_Message:
;		Send a sinle message in-game upon pressing the button.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		RegExMatch(A_GuiControl, "\d+", btnID)
		tabInfos := Gui_Trades_Get_Trades_Infos(currentActiveTab)
		if !(tabInfos.Buyer)
			Return
		messages := Object()
		messages.Push(GlobalValues["Button" btnID "_Message_1"], GlobalValues["Button" btnID "_Message_2"], GlobalValues["Button" btnID "_Message_3"])
		Send_InGame_Message(messages, tabInfos)
	Return

	Gui_Trades_Send_Message_Close_Tab:
;		Send a single message in-game and close the current tab upon pressing the button.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		RegExMatch(A_GuiControl, "\d+", btnID)
		tabInfos := Gui_Trades_Get_Trades_Infos(currentActiveTab)
		if !(tabInfos.Buyer)
			Return
		messages := Object()
		messages.Push(GlobalValues["Button" btnID "_Message_1"], GlobalValues["Button" btnID "_Message_2"], GlobalValues["Button" btnID "_Message_3"])
		errorLvl := Send_InGame_Message(messages, tabInfos)
		if !(errorLvl) {
			if ( GlobalValues["Support_Text_Toggle"] = 1 ) {
				tabInfos := Gui_Trades_Get_Trades_Infos(currentActiveTab) ; Prevent from asking to replace the PID twice
				messages.Delete(0, 10)
				messages.Push(GlobalValues["Support_Message"])
				Send_InGame_Message(messages, tabInfos)
			}
			Gosub, Gui_Trades_RemoveItem
			;__TO_BE_ADDED__ Append the trade infos to a file.
		}
	Return

	Gui_Trades_Write_Message:
;		Write a message without sending it.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		RegExMatch(A_GuiControl, "\d+", btnID)
		tabInfos := Gui_Trades_Get_Trades_Infos(currentActiveTab)
		if !(tabInfos.Buyer)
			Return
		messages := Object()
		messages.Push(GlobalValues["Button" btnID "_Message_1"])
		Send_InGame_Message(messages, tabInfos, {doNotSend:1})
	Return
	
	Gui_Trades_RemoveItem:
;		Empties the current tab content and close it upon pressing the button.
		if ( GlobalValues["Trades_GUI_Button_Cancel"] ) {
			GlobalValues.Insert("Trades_GUI_Button_Cancel", 0)
			Return
		}

		RegExMatch(A_GuiControl, "\d+", btnID)

		if ( activeSkin != "System" ) {
			GuiControlGet, lastTab, Trades:,% TradesGUI_Controls["Tab_TXT_" maxTabsRow]
			GuiControlGet, firstTab, Trades:,% TradesGUI_Controls["Tab_TXT_1"]
		}

		if ( GlobalValues["Clip_On_Tab_Switch"] = 1 ) {
			Gui_Trades_Clipboard_Item_Func(btnID)
		}

;		Remove the current tab
		messagesArray := Gui_Trades_Manage_Trades("REMOVE_CURRENT", ,currentActiveTab)
		Gui_Trades(messagesArray, "UPDATE")
		if (activeSkin != "System")
			Gosub, Gui_Trades_Tabs_Handler
	return

	Gui_Trades_Size:
;		Declare the global GUI width and height
		tradesGuiWidth := A_GuiWidth
		tradesGuiHeight := A_GuiHeight
	return

	Gui_Trades_Close:
	Return
	Gui_Trades_Escape:
	Return
}

Gui_Trades_Clipboard_Item_Func(tabID) {
/*		Retrieve the specified tab's item.
		Change the clipboard content with a precise item search.
*/
	tabInfos := Gui_Trades_Get_Trades_Infos(tabID)
	item := tabInfos.Item
	RegExMatch(item, "(.*?) \(Lvl:(.*?) \/ Qual:(.*?)%\)", itemPat)
	clipContent := (itemPat1 && itemPat2 && itemPat3)?("""" itemPat1 """" . A_Space . """Level: " itemPat2 """" . A_Space . """Quality: +" itemPat3 "%""")
				  :(itemPat1 && itemPat2 && !itemPat3)?("""" itemPat1 """" . A_Space . """Level: " itemPat2 """")
				  :(itemPat4)?(itemPat4)
				  :(item)
	Clipboard := clipContent
}

Gui_Trades_Redraw(msg, params="") {
/*		Retrieve the current pending trades
		Re-create the Trades GUI
		Add the pending trades back to the GUI
*/
	global ProgramValues

	Gui_Trades_Save_Position()
	if ( !params.noSplash )
		SplashTextOn, 250, 40,% ProgramValues.Name,Please wait...`nCurrently re-creating the interface.
	allTrades := Gui_Trades_Manage_Trades("GET_ALL")
	if ( params.preview ) {
		if !(allTrades.BUYERS.MaxIndex()) {
			allTrades.BUYERS.Push("iSellStuff")
			allTrades.ITEMS.Push("level 1 Faster Attacks Support")
			allTrades.PRICES.Push("5 alteration")
			allTrades.LOCATIONS.Push("Breach (stash tab ""Gems""; position: left 6, top 8)")
			allTrades.OTHER.Push("Offering 1 alch?")
			allTrades.TIME.Push(A_Hour ":" A_Min)
			allTrades.PID.Push(0)
		}
	}
	Gui_Trades(, msg)
	Gui_Trades(allTrades, "UPDATE")
	SplashTextOff
}

Gui_Trades_Get_Tab_ID() {
/*		Only used when no skin is applied.
 *		Returns the currently active tab ID.
*/
	Global TradesGUI_Controls

	GuiControlGet, tabID, Trades:,% TradesGUI_Controls.Tab
	return tabID
}

Gui_Trades_Check_Duplicate(currentActiveTab) {
/*			Create a list containing all the duplicates tab ID
 *			Sort them in reverse, then include them in an array and returns it.
*/
	duplicates := currentActiveTab
	messagesArray := Gui_Trades_Manage_Trades("GET_ALL")
	maxIndex := messagesArray.BUYERS.MaxIndex()
	currentTabInfos := Gui_Trades_Get_Trades_Infos(currentActiveTab)
	arrayKey := 1
	Loop %maxIndex% {
		if (A_Index != currentActiveTab) {
			otherTabInfos := Gui_Trades_Get_Trades_Infos(A_Index)
			if (otherTabInfos.Item = currentTabInfos.Item && otherTabInfos.Price = currentTabInfos.Price && otherTabInfos.Location = currentTabInfos.Location) {
				duplicates .= "|" A_Index
				arrayKey++
			}
		}
	}
	Sort, duplicates, D| N R
	duplicatesID := Object()
	Loop, Parse, duplicates, |
		duplicatesID.Push(A_LoopField)
	
	return duplicatesID
}


Gui_Trades_Get_Tab_Height() {
/*			Returns a number based on the lowest custom button to determine the GUI height
*/
	global GlobalValues

	tabHeight := 145
	Loop 9 {
		index := A_Index
		if ( GlobalValues["Button" index "_SIZE"] != "Disabled" ) {
			if ( GlobalValues["Button" index "_V"] = "Middle" && tabHeight = 145 ) {
				tabHeight := 185
			}
			if ( GlobalValues["Button" index "_V"] = "Bottom" && ( tabHeight = 145 || tabHeight = 185 ) ) {
				tabHeight := 225
			}
		}
	}
	return tabHeight
}

GUI_Trades_Mode:
	Gui_Trades_Mode_Func(A_ThisMenuItem)
Return

Gui_Trades_Mode_Func(thisMenuItem) {
/*			Switch between Overlay and Window mode
*/
	global GlobalValues, ProgramValues
	global tradesGuiWidth

	iniFilePath := ProgramValues["Ini_File"]

	if ( thisMenuItem = "Mode: Overlay") {
		Menu, Tray, UnCheck,% "Mode: Window"
		Menu, Tray, Check,% "Mode: Overlay"
		GlobalValues.Insert("Trades_GUI_Mode", "Overlay")
		Gui_Trades_Save_Position(A_ScreenWidth-tradesGuiWidth, 0)
	}
	else if ( thisMenuItem = "Mode: Window") {
		Menu, Tray, UnCheck,% "Mode: Overlay"
		Menu, Tray, Check,% "Mode: Window"
		GlobalValues.Insert("Trades_GUI_Mode", "Window")
	}
	IniWrite,% GlobalValues["Trades_GUI_Mode"],% iniFilePath,SETTINGS,Trades_GUI_Mode
	Gui_Trades_Redraw("CREATE", {noSplash:1})
}

Gui_Trades_Get_Trades_Infos(tabID){
/*			Returns the specified tab informations
*/
	global TradesGUI_Controls

	GuiControlGet, tabBuyer, Trades:,% TradesGUI_Controls["Buyer_Slot_" tabID]
	tabBuyer := Gui_Trades_RemoveGuildPrefix(tabBuyer) ; Removing guild prefix so we can use the actual player name
	GuiControlGet, tabItem, Trades:,% TradesGUI_Controls["Item_Slot_" tabID]
	GuiControlGet, tabPrice, Trades:,% TradesGUI_Controls["Price_Slot_" tabID]
	GuiControlGet, tabLocation,Trades:,% TradesGUI_Controls["Location_Slot_" tabID]
	GuiControlGet, tabOther,Trades:,% TradesGUI_Controls["Other_Slot_" tabID]
	GuiControlGet, tabPID, Trades:,% TradesGUI_Controls["PID_Slot_" tabID]
	GuiControlGet, tabTime, Trades:,% TradesGUI_Controls["Time_Slot_" tabID]

	TabInfos := {}
	TabInfos.Buyer := tabBuyer
	TabInfos.Item := tabItem
	TabInfos.Price := tabPrice
	TabInfos.Location := tabLocation
	TabInfos.Other := tabOther
	TabInfos.PID := tabPID
	TabInfos.Time := tabTime
	TabInfos.TabID := tabID
	return tabInfos
}

Gui_Trades_Set_Trades_Infos(setInfos){
/*			Overrides the specified tab content
*/
	global TradesGUI_Controls

	newPID := setInfos.NewPID, oldPID := setInfos.OldPID, other := setInfos.Other, tabID := setInfos.TabID

	if ( newPID ) {
		; Replace the PID for all trades matching the same PID
		allTrades := Gui_Trades_Manage_Trades("GET_ALL")
		tradeInfos := Gui_Trades_Get_Trades_Infos(tabID)
		for key, element in allTrades.BUYERS {
			if ( tradeInfos.PID = oldPID ) {
				GuiControl,Trades:,% TradesGUI_Controls["PID_Slot_" key],% newPID
			}
		}
	}

	else if ( other ) {
		GuiControl,Trades:,% TradesGUI_Controls["Other_Slot_" tabID],% other
	}
}

Gui_Trades_Manage_Trades(mode, newItemInfos="", activeTabID=""){
/*			GET_ALL retrieves all the currently existing tabs infos
 *			ADD_NEW add the provided infos to a new tab
 *			REMOVE_CURRENT deletes the currently active tab infos
*/
	global TradesGUI_Controls

	returnArray := Object()
	returnArray.COUNT := Object()
	returnArray.BUYERS := Object()
	returnArray.ITEMS := Object()
	returnArray.PRICES := Object()
	returnArray.LOCATIONS := Object()
	returnArray.GAMEPID := Object()
	returnArray.TIME := Object()
	returnArray.OTHER := Object()
	btnID := activeTabID

	if ( mode = "GET_ALL" || mode = "ADD_NEW") {
	;	___BUYERS___	
		Loop {
			bcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Buyer_Slot_" A_Index]
			if ( content ) {
				returnArray.BUYERS.Insert(A_Index, content)
			}
			else break
		}
		
	;	___ITEMS___
		Loop {
			icount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Item_Slot_" A_Index]
			if ( content ) {
				returnArray.ITEMS.Insert(A_Index, content)
			}
			else break
		}
		
	;	___PRICES___
		Loop {
			pcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Price_Slot_" A_Index]
			if ( content ) {
				returnArray.PRICES.Insert(A_Index, content)
			}
			else break
		}
		
	;	___LOCATIONS___
		Loop {
			lcount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Location_Slot_" A_Index]
			if ( content ) {
				returnArray.LOCATIONS.Insert(A_Index, content)
			}
			else break
		}

	;	___GAMEPID___
		Loop {
			PIDCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["PID_Slot_" A_Index]
			if ( content ) {
				returnArray.GAMEPID.Insert(A_Index, content)
			}
			else break
		}

	;	___TIME___
		Loop {
			timeCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Time_Slot_" A_Index]
			if ( content ) {
				returnArray.TIME.Insert(A_Index, content)
			}
			else break
		}
	;	___OTHER___
		Loop {
			otherCount := A_Index
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Other_Slot_" A_Index]
			if ( content ) {
				returnArray.OTHER.Insert(A_Index, content)
			}
			else break
		}
	}

	if ( mode = "ADD_NEW") {
		name := newItemInfos[0], item := newItemInfos[1], price := newItemInfos[2], location := newItemInfos[3], gamePID := newItemInfos[4], time := newItemInfos[5], other := newItemInfos[6]
		returnArray.COUNT.Insert(0, bCount)
		returnArray.BUYERS.Insert(bCount, name)
		returnArray.ITEMS.Insert(iCount, item)
		returnArray.PRICES.Insert(pCount, price)
		returnArray.LOCATIONS.Insert(lCount, location)
		returnArray.GAMEPID.Insert(PIDCount, gamePID)
		returnArray.TIME.Insert(timeCount, time)
		returnArray.OTHER.Insert(timeCount, other)
	}

	if ( mode = "REMOVE_CURRENT") {
	;	___BUYERS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Buyer_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.BUYERS.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Buyer_Slot_" counter],% "" ; Empties the slot content

	;	___ITEMS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Item_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.ITEMS.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Item_Slot_" counter],% ""
		
	;	___PRICES___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Price_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.PRICES.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Price_Slot_" counter],% ""
		
	;	___LOCATIONS___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Location_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.LOCATIONS.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Location_Slot_" counter],% ""

;	___GAMEPID___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["PID_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.GAMEPID.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["PID_Slot_" counter],% ""

;	___TIME___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Time_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.TIME.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Time_Slot_" counter],% ""

;	___OTHER___
		Loop {
			if ( A_Index < btnID )
				counter := A_Index
			else if ( A_Index >= btnID )
				counter := A_Index+1
			GuiControlGet, content, Trades:,% TradesGUI_Controls["Other_Slot_" counter]
			if ( content ) {
				index := A_Index
				returnArray.Other.Insert(index, content)
			}
			else break
		}
		counter--
		GuiControl,Trades:,% TradesGUI_Controls["Other_Slot_" counter],% ""
	}

	return returnArray
}

Gui_Trades_RemoveGuildPrefix(name) {
/*			Remvove the guild prefix from the name, is there is one
*/
	AutoTrim, On
	RegExMatch(name, "<.*>(.*)", namePat)
	if ( namePat1 )
		name := namePat1
	name = %name% ; Removes whitespaces
	return name
}

Gui_Trades_Set_Position(xpos="UNSPECIFIED", ypos="UNSPECIFIED"){
/*			Update the Trades GUI position
*/
	static
	global GlobalValues
	global tradesGuiWidth, tradesGuiHeight

	if ( GlobalValues.Dock_Mode != "Overlay" )
		Return

	dpiFactor := GlobalValues["Screen_DPI"]

	if ( WinExist("ahk_id " GlobalValues["Dock_Window"] ) ) {
		WinGetPos, winX, winY, winWidth, winHeight,% "ahk_id " GlobalValues["Dock_Window"]
		xpos := ( (winX+winWidth)-tradesGuiWidth * dpiFactor ), ypos := winY
		WinGet, isMinMax, MinMax,% "ahk_id " GlobalValues["Dock_Window"] ; -1: Min | 1: Max | 0: Neither
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
	Logs_Append(A_ThisFunc, {xpos:xpos, ypos:ypos})
}


;==================================================================================================================
;
;												SETTINGS GUI
;
;==================================================================================================================

Gui_Settings() {
	static
	global GlobalValues, ProgramValues, ProgramFonts
	global Hotkey1_KEYHandler, Hotkey2_KEYHandler, Hotkey3_KEYHandler, Hotkey4_KEYHandler, Hotkey5_KEYHandler, Hotkey6_KEYHandler

	programName := ProgramValues["Name"], iniFilePath := ProgramValues["Ini_File"], programSFXFolderPath := ProgramValues["SFX_Folder"]

	guiCreated := 0
	
	Gui, Settings:Destroy
	Gui, Settings:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +LabelGui_Settings_ hwndSettingsHandler,% programName " - Settings"
	Gui, Settings:Default

;		Apply Button

	guiXWorkArea := 150, guiYWorkArea := 10
	Gui, Add, TreeView, x10 y10 h380 w130 -0x4 -Buttons gGui_Settings_TreeView
    P1 := TV_Add("Settings","", "Expand")
    P2 := TV_Add("Customization","","Expand")
    P2C1 := TV_Add("Appearance", P2, "Expand")
    P2C2 := TV_Add("Buttons Actions", P2, "Expand")
    P3 := TV_Add("Hotkeys","","Expand")

	Gui, Add, Text,% "x" guiXWorkarea . " y" 360,% "Settings will be saved upon closing this window."
	Gui, Add, Link,% "x" guiXWorkarea . " y" 375 . " vWikiBtn gGui_Settings_Btn_WIKI",% "Keep the cursor above a control to know more about it. You may also <a href="""">Visit the Wiki</a>"
    ; Gui, Add, Button,% "x" guiXWorkArea . " y" 360 . " w" 430 . " h" 30 . " gGui_Settings_Btn_Apply vApplyBtn",Apply Settings

	Gui, Add, Tab2, x10 y10 w0 h0 vTab hwndTabHandler,Settings|Customization|Appearance|Buttons Actions|Hotkeys
	Gui, Tab, Settings
;	Settings Tab
;		Trades GUI
		Gui, Add, GroupBox,% " x" guiXWorkArea . " y" guiYWorkArea . " w430 h340",Main interface
		Gui, Add, Radio, xp+10 yp+20 vShowAlways hwndShowAlwaysHandler,Always show
		Gui, Add, Radio, xp yp+15 vShowInGame hwndShowInGameHandler,Only show while in game

		Gui, Add, Checkbox, xp yp+30 hwndClipTabHandler vClipTab,Clipboard item on tab switch
		Gui, Add, Checkbox,% " xp" . " yp+15 hwndSelectLastTabHandler vSelectLastTab",Focus newly created tabs

		Gui, Add, Checkbox, xp yp+30 hwndAutoMinimizeHandler vAutoMinimize,Minimize when inactive
		Gui, Add, Checkbox, xp yp+15 hwndAutoUnMinimizeHandler vAutoUnMinimize,Un-Minimize when active
;			Transparency
			Gui, Add, GroupBox,% " x" guiXWorkArea+215 . " y" guiYWorkArea+125 " w205 h140",Transparency
			Gui, Add, Checkbox, xp+30 yp+25 hwndClickThroughHandler vClickThrough,Click-through while inactive
			Gui, Add, Text, xp yp+20,Inactive (no trade on queue)
			Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyHandler gGui_Settings_Transparency vShowTransparency AltSubmit ToolTip Range0-100
			Gui, Add, Text, xp-10 yp+30,Active (trades are on queue)
			Gui, Add, Slider, xp+10 yp+15 hwndShowTransparencyActiveHandler gGui_Settings_Transparency vShowTransparencyActive AltSubmit ToolTip Range30-100

; ;		Notifications
;			 Trade Sound Group
			Gui, Add, GroupBox,% "x" guiXWorkarea+215 . " y" guiYWorkArea+10 . " w205 h110",Notifications
			Gui, Add, Checkbox, xp+10 yp+20 vNotifyTradeToggle hwndNotifyTradeToggleHandler,Trade
			Gui, Add, Edit, xp+65 yp-2 w70 h17 vNotifyTradeSound hwndNotifyTradeSoundHandler ReadOnly
			Gui, Add, Button, xp+80 yp-2 h20 vNotifyTradeBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Sound Group
			Gui, Add, Checkbox,% "xp-145 yp+25" . " vNotifyWhisperToggle hwndNotifyWhisperToggleHandler",Whisper
			Gui, Add, Edit, xp+65 yp-2 w70 h17 vNotifyWhisperSound hwndNotifyWhisperSoundHandler ReadOnly
			Gui, Add, Button, xp+80 yp-2 h20 vNotifyWhisperBrowse gGui_Settings_Notifications_Browse,Browse
;			Whisper Tray Notification
			Gui, Add, Checkbox,% "xp-145"   " yp+29 vNotifyWhisperTray hwndNotifyWhisperTrayHandler",Show tray notifications
			Gui, Add, Checkbox,% "xp"  " yp+14 vNotifyWhisperFlash hwndNotifyWhisperFlashHandler",Flash the taskbar icon
; ;		Support
		Gui, Add, GroupBox,% "x" guiXWorkArea+10 " y" guiYWorkArea+180 . " w200 h85",Support
		Gui, Add, Checkbox, xp+90 yp+20 vMessageSupportToggle hwndMessageSupportToggleHandler
		Gui, Add, Text, gGUI_Settings_Tick_Case vMessageSupportToggleText xp-55 yp+18,% "Send an additional message`n   containing the thread-id`n     upon closing a trade"

;	-----------------------
	Gui, Tab, Customization
	Gui, Add, Text,% "x" guiXWorkarea+80 . " y" guiYWorkArea+100 " Center",% "This section is empty.`nSelect one of the sub-sections to change your settings."
;	--------------------
	Gui, Tab, Appearance
	Gui, Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea . " w420 h55",Preset
		presetsList := "User Defined"
		Loop, Files,% ProgramValues["Skins_Folder"] "\*", D
		{
			presetsList .= "|" A_LoopFileName
		}
		Sort, presetsList,D|
		Gui, Add, DropDownList,% "x" guiXWorkarea+10 . " y" guiYWorkArea+20 . " w400" . " vActivePreset hwndActivePresetHandler gGui_Settings_Presets",% presetsList

	Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+60 . " w430 h85",Skin

		skinsList := ""
		Loop, Files,% ProgramValues["Skins_Folder"] "\*", D
		{
			IniRead, skinName,% A_LoopFileFullPath "\Settings.ini",CUSTOMIZATION_APPEARANCE,Active_Skin
			if ( skinName && skinName != "ERROR" )
				skinsList .= skinName "|"
		}
		Sort, skinsList,D|
		Sleep 1
		Gui, Add, ListBox,% "xp+10" . " yp+20" . " w190" . " vSelectedSkin hwndSelectedSkinHandler R4" . " gGui_Settings_Set_Custom_Preset",% skinsList

		scalingList := "50%|75%|100%|125%|150%|175%|200%"
		Gui, Add, Text,% "xp+200" . " yp+3",Scale: 
		Gui, Add, DropDownList,% "xp+40" . " yp-3" . " w145" . " vSkinScaling hwndSkinScalingHandler" . " gGui_Settings_Set_Custom_Preset",% scalingList

	Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+150 . " w430 h85",Font

		fontsList := "System"
		for fontFile, fontTitle in ProgramFonts {
			fontsList .= "|" fontTitle
		}
		Sort, fontsList,D|
		Sleep 1
		Gui, Add, ListBox,% "xp+10" . " yp+20" . " w190" . " vSelectedFont hwndSelectedFontHandler R4" . " gGui_Settings_Set_Custom_Preset",% fontsList
		Gui, Add, Text,% "xp+200" . " yp+3",Size:
		Gui, Add, DropDownList,% "xp+40" . " yp-3" . " w100" . " vFontSize hwndFontSizeHandler" . " gGui_Settings_Set_Custom_Preset",% "Automatic|Custom"
		Gui, Add, Edit,% "xp+100" . " yp" . " w50" . " ReadOnly"
		Gui, Add, UpDown, vFontSizeCustom hwndFontSizeCustomHandler gGui_Settings_Set_Custom_Preset

	Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+240 . " w430 h85",Font Colors

		Gui, Add, Text,% "xp+10" . " yp+23",Title (Active):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTitleActiveColor" . " hwndTitleActiveColorHandler" . " Limit6",% ""
		Gui, Add, Text,% "xp-75" . " yp+28",Title (Inactive):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTitleInactiveColor" . " hwndTitleInactiveColorHandler" . " Limit6",% ""

		Gui, Add, Text,% "xp+65" . " yp-22",Trade Infos (1):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTradesInfos1Color" . " hwndTradesInfos1ColorHandler" . " Limit6",% ""
		Gui, Add, Text,% "xp-75" . " yp+28",Trade Infos (2):
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTradesInfos2Color" . " hwndTradesInfos2ColorHandler" . " Limit6",% ""

		Gui, Add, Text,% "xp+65" . " yp-22",Tabs:
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vTabsColor" . " hwndTabsColorHandler" . " Limit6",% ""
		Gui, Add, Text,% "xp-75" . " yp+28",Buttons:
		Gui, Add, Edit,% "xp+75" . " yp-3" . " w60" . " vButtonsColor" . " hwndButtonsColorHandler" . " Limit6",% ""

		Gui, Add, Link,% "x" guiXWorkArea + 80 . " y" guiYWorkArea+240,% "(Use <a href=""http://hslpicker.com/"">HSL Color Picker</a> to retrieve the 6 characters code starting with #) "

;	-------------------------
	Gui, Tab, Buttons Actions
	DynamicGUIHandlersArray := Object()

	Loop 9 {
		index := A_Index
		xpos := (index=1||index=4||index=7)?(guiXWorkArea+32):(index=2||index=5||index=8)?(guiXWorkArea+152):(index=3||index=6||index=9)?(guiXWorkArea+272):("ERROR")
		ypos := (index=1||index=2||index=3)?(guiYWorkArea):(index=4||index=5||index=6)?(guiYWorkArea+35):(index=7||index=8||index=9)?(guiYWorkArea+70):("ERROR")
		Gui, Add, Button, x%xpos% y%ypos% w120 h35 vTradesBtn%index% hwndTradesBtn%index%Handler gGui_Settings_Custom_Label,% "Custom " index

		Gui, Add, GroupBox,% "x" guiXWorkArea . " y" guiYWorkArea+120 . " w425 h85",Positioning
			Gui, Add, Text,% "xp+10" . " yp+20" . " hwndTradesHPOS" index "TextHandler",Horizontal:
			Gui, Add, ListBox, w70 xp+55 yp vTradesHPOS%index% hwndTradesHPOS%index%Handler gGui_Settings_Trades_Preview R3,% "Left|Center|Right"
			Gui, Add, Text, xp+75 yp hwndTradesVPOS%index%TextHandler,Vertical:
			Gui, Add, ListBox, w70 xp+45 yp vTradesVPOS%index% hwndTradesVPOS%index%Handler gGui_Settings_Trades_Preview R3,% "Top|Middle|Bottom"
			Gui, Add, Text, xp+75 yp hwndTradesSIZE%index%TextHandler,Size:
			Gui, Add, ListBox, w70 xp+30 yp vTradesSIZE%index% hwndTradesSIZE%index%Handler gGui_Settings_Trades_Preview R4,% "Disabled|Small|Medium|Large"

		Gui, Add, GroupBox,% "x" guiXWorkarea . " y" guiYWorkArea+215 . " w425 h110",Behaviour
			Gui, Add, Text,% "xp+10" . " yp+20" . " hwndTradesLabel" index "TextHandler",Label:
			Gui, Add, Edit, xp+50 yp-3 w160 vTradesLabel%index% hwndTradesLabel%index%Handler gGui_Settings_Custom_Label,
			Gui, Add, Text, xp+170 yp+3 vTradesHK%index%Text hwndTradesHK%index%TextHandler,Hotkey:
			Gui, Add, Hotkey, xp+50 yp-3 vTradesHK%index% hwndTradesHK%index%Handler,

			Gui, Add, Text,% "xp-270" . " yp+33" . " hwndTradesAction" index "TextHandler",Action:
			Gui, Add, DropDownList, xp+50 yp-3 w160 vTradesAction%index% hwndTradesAction%index%Handler gGui_Settings_Custom_Label,% "Clipboard Item|Send Message|Send Message + Close Tab|Write Message"
			Gui, Add, CheckBox,xp+170 yp+3 vTradesMarkCompleted%index% hwndTradesMarkCompleted%index%Handler,Mark the trade as completed?

			Gui, Add, Edit,% "x" guiXWorkarea+10 . " yp+30 w50" . " hwndTradesMsgEditID" index "Handler" . " ReadOnly Limit1",1|2|3
			Gui, Add, UpDown,% " vTradesMsgID" index " hwndTradesMsgID" index "Handler" . " Range1-3 gGui_Settings_Cycle_Messages"
			Gui, Add, Edit, xp+50 yp w355 vTradesMsg1_%index% hwndTradesMsg1_%index%Handler,
			Gui, Add, Edit, xp yp w355 vTradesMsg2_%index% hwndTradesMsg2_%index%Handler,
			Gui, Add, Edit, xp yp w355 vTradesMsg3_%index% hwndTradesMsg3_%index%Handler,

		GuiControl,Settings:Hide,% TradesHPOS%index%Handler
		GuiControl,Settings:Hide,% TradesHPOS%index%TextHandler
		GuiControl,Settings:Hide,% TradesVPOS%index%Handler
		GuiControl,Settings:Hide,% TradesVPOS%index%TextHandler
		GuiControl,Settings:Hide,% TradesSIZE%index%Handler
		GuiControl,Settings:Hide,% TradesSIZE%index%TextHandler
		GuiControl,Settings:Hide,% TradesLabel%index%Handler
		GuiControl,Settings:Hide,% TradesLabel%index%TextHandler
		GuiControl,Settings:Hide,% TradesHK%index%Handler
		GuiControl,Settings:Hide,% TradesHK%index%TextHandler		
		GuiControl,Settings:Hide,% TradesAction%index%Handler
		GuiControl,Settings:Hide,% TradesAction%index%TextHandler
		GuiControl,Settings:Hide,% TradesMarkCompleted%index%Handler
		GuiControl,Settings:Hide,% TradesMsgEditID%index%Handler
		GuiControl,Settings:Hide,% TradesMsgID%index%Handler
		GuiControl,Settings:Hide,% TradesMsg1_%index%Handler
		GuiControl,Settings:Hide,% TradesMsg2_%index%Handler
		GuiControl,Settings:Hide,% TradesMsg3_%index%Handler

		DynamicGUIHandlersArray["Btn" index] := TradesBtn%index%Handler
		DynamicGUIHandlersArray["HPOS" index] := TradesHPOS%index%Handler
		DynamicGUIHandlersArray["HPOSText" index] := TradesHPOS%index%TextHandler
		DynamicGUIHandlersArray["VPOS" index] := TradesVPOS%index%Handler
		DynamicGUIHandlersArray["VPOSText" index] := TradesVPOS%index%TextHandler
		DynamicGUIHandlersArray["SIZE" index] :=  TradesSIZE%index%Handler
		DynamicGUIHandlersArray["SIZEText" index] := TradesSIZE%index%TextHandler
		DynamicGUIHandlersArray["Label" index] := TradesLabel%index%Handler
		DynamicGUIHandlersArray["LabelText" index] := TradesLabel%index%TextHandler
		DynamicGUIHandlersArray["Action" index] := TradesAction%index%Handler
		DynamicGUIHandlersArray["ActionText" index] := TradesAction%index%TextHandler
		DynamicGUIHandlersArray["Hotkey" index] := TradesHK%index%Handler
		DynamicGUIHandlersArray["HotkeyText" index] := TradesHK%index%TextHandler
		DynamicGUIHandlersArray["MarkCompleted" index] := TradesMarkCompleted%index%Handler
		DynamicGUIHandlersArray["MsgEditID" index] := TradesMsgEditID%index%Handler
		DynamicGUIHandlersArray["MsgID" index] :=  TradesMsgID%index%Handler
		DynamicGUIHandlersArray["Msg1" index] := TradesMsg1_%index%Handler
		DynamicGUIHandlersArray["Msg2" index] := TradesMsg2_%index%Handler
		DynamicGUIHandlersArray["Msg3" index] := TradesMsg3_%index%Handler
	}
	
;	Hotkeys Tab
	Gui, Tab, Hotkeys
	Gui, Add, Button,% "x" guiXWorkArea . " y" guiYWorkArea . " w415 h22 gGui_Settings_Hotkeys_Switch hwndHotkeys_SwitchToBasicHandler",Switch to Basic
	xpos := guiXWorkArea, ypos := guiYWorkArea+30
	Loop 16 {
		btnID := A_Index
		if ( btnID > 1 && btnID <= 8 ) || ( btnID > 9 )
			ypos += 30
		else if ( btnID = 9 )
			xpos := guiXWorkArea+210, ypos := guiYWorkArea+30
		Gui, Add, Checkbox, x%xpos% y%ypos% vHotkeyAdvanced%btnID%_Toggle hwndHotkeyAdvanced%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-3 w60 vHotkeyAdvanced%btnID%_KEY hwndHotkeyAdvanced%btnID%_KEYHandler
		Gui, Add, Edit, xp+65 yp w110 gGui_Settings_Hotkeys_Tooltip vHotkeyAdvanced%btnID%_Text hwndHotkeyAdvanced%btnID%_TextHandler
		if ( GlobalValues["Hotkeys_Mode"] != "Advanced" )  {
			GuiControl,Settings:Hide,% Hotkeys_SwitchToBasicHandler
			GuiControl,Settings:Hide,% HotkeyAdvanced%btnID%_ToggleHandler
			GuiControl,Settings:Hide,% HotkeyAdvanced%btnID%_KEYHandler
			GuiControl,Settings:Hide,% HotkeyAdvanced%btnID%_TextHandler
		}
	}

	Gui, Add, Button,% "x" guiXWorkArea . " y" guiYWorkArea . " w415 h22 gGui_Settings_Hotkeys_Switch hwndHotkeys_SwitchToAdvancedHandler",Switch to Advanced
	xpos := guiXWorkArea, ypos := guiYWorkArea+20
	Loop 6 {
		btnID := A_Index
		if (btnID > 1 && btnID <= 3) || (btnID > 4)
			ypos += 80
		else if (btnID = 4)
			xpos := guiXWorkArea+210, ypos := guiYWorkArea+20
		Gui, Add, GroupBox, x%xpos% y%ypos% w209 h90 hwndHotkey%btnID%_GroupBox
		Gui, Add, Checkbox, xp+10 yp+20 vHotkey%btnID%_Toggle hwndHotkey%btnID%_ToggleHandler
		Gui, Add, Edit, xp+30 yp-4 w150 vHotkey%btnID%_Text hwndHotkey%btnID%_TextHandler,
		Gui, Add, Hotkey, xp yp+25 w150 vHotkey%btnID%_KEY hwndHotkey%btnID%_KEYHandler gGui_Settings_Hotkeys,
		Gui, Add, Checkbox, xp yp+28 vHotkey%btnID%_CTRL hwndHotkey%btnID%_CTRLHandler,CTRL
		Gui, Add, Checkbox, xp+50 yp vHotkey%btnID%_ALT hwndHotkey%btnID%_ALTHandler,ALT
		Gui, Add, Checkbox, xp+42 yp vHotkey%btnID%_SHIFT hwndHotkey%btnID%_SHIFTHandler,SHIFT
		if ( GlobalValues["Hotkeys_Mode"] != "Basic" ) {
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

	GoSub, Gui_Settings_Set_Preferences
	Gui, Trades: -E0x20
	Gui, Show
	GuiControl, Settings:Choose,% TabHandler, 1
	guiCreated := 1
return

	Gui_Settings_Cycle_Messages:
		Gui, Settings:Submit, NoHide

		btnID := RegExReplace(A_GuiControl, "\D")
		ctrlHandler := DynamicGUIHandlersArray["MsgID" btnId]
		GuiControlGet, currentMsgID,,% ctrlHandler

		GuiControl, Settings: Hide,% DynamicGUIHandlersArray["Msg1" btnID]
		GuiControl, Settings: Hide,% DynamicGUIHandlersArray["Msg2" btnID]
		GuiControl, Settings: Hide,% DynamicGUIHandlersArray["Msg3 "btnID]

		if ( currentMsgID = 1 )
			GuiControl, Settings: Show,% DynamicGUIHandlersArray["Msg1" btnID]
		else if ( currentMsgID = 2 )
			GuiControl, Settings: Show,% DynamicGUIHandlersArray["Msg2" btnID]
		else if ( currentMsgID = 3 )
			GuiControl, Settings: Show,% DynamicGUIHandlersArray["Msg3" btnID]
	Return

	Gui_Settings_Set_Custom_Preset:
		Gui, Settings:Submit, NoHide
		if ( A_GuiControl != "ActivePreset" ) {
			GuiControl, Settings:Choose,% ActivePresetHandler,User Defined
		}

;		Enable or disable the control.
		state := (FontSize="Custom")?("Enable"):("Disable")
		GuiControl, Settings:%state%,% FontSizeCustomHandler
		state := (SelectedSkin="System")?("Disable"):("Enable")
		GuiControl, Settings:%state%,% ButtonsColorHandler
		GuiControl, Settings:%state%,% TabsColorHandler

		if ( A_GuiControl!="ActivePreset")
			GoSub Gui_Settings_Trades_Preview
	Return

	Gui_Settings_Presets:
		Gui, Settings:Submit, NoHide
		ActivePresetSettings := Gui_Settings_Get_Settings_Arrays()
		INI_Keys := ActivePresetSettings.CUSTOMIZATION_APPEARANCE_KeysArray
		ControlsHandlers := ActivePresetSettings.CUSTOMIZATION_APPEARANCE_HandlersArray

		for key, element in INI_Keys {
			skinSettingsFile := (ActivePreset="User Defined")?(ProgramValues[("Ini_File")]):(ProgramValues["Skins_Folder"] "\" ActivePreset "\Settings.ini")
			
			IniRead, value,% skinSettingsFile,% "CUSTOMIZATION_APPEARANCE",% element
			ctrlName := ControlsHandlers[key]
			ctrlHandler := (ctrlName="ActivePreset")?(ActivePresetHandlerHandler)
						  :(ctrlName="SelectedSkin")?(SelectedSkinHandler)
						  :(ctrlName="SkinScaling")?(SkinScalingHandler)
						  :(ctrlName="SelectedFont")?(SelectedFontHandler)
						  :(ctrlName="FontSize")?(FontSizeHandler)
						  :(ctrlName="FontSizeCustom")?(FontSizeCustomHandler)
						  :(ctrlName="TitleActiveColor")?(TitleActiveColorHandler)
						  :(ctrlName="TitleInactiveColor")?(TitleInactiveColorHandler)
						  :(ctrlName="TradesInfos1Color")?(TradesInfos1ColorHandler)
						  :(ctrlName="TradesInfos2Color")?(TradesInfos2ColorHandler)
						  :(ctrlName="TabsColor")?(TabsColorHandler)
						  :(ctrlName="ButtonsColor")?(ButtonsColorHandler)
						  :("ERROR")

			GuiControl, Settings:-g,% ctrlHandler ; Prevent from triggeting the gLabel
			if element in Font_Size_Custom,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
			{
				GuiControl, Settings:,% ctrlHandler,% value
			}
			else if ( element = "Scale_Multiplier" ) {
				value := value*100
				value := Round(value, 0)
				GuiControl, Settings:Choose,% ctrlHandler,% value "%"
			}
			else
				GuiControl, Settings:Choose,% ctrlHandler,% value

			GuiControl, Settings:+gGui_Settings_Set_Custom_Preset,% ctrlHandler ; Re-enable gLabel
		}
		GoSub, Gui_Settings_Set_Custom_Preset
		GoSub, Gui_Settings_Trades_Preview
	Return

	Gui_Settings_TreeView:
	  if (A_GuiEvent = "S") {
	  	evntinf := A_EventInfo
	  	tabName := (evntinf=P1)?("Settings")
	  			:(evntinf=P2)?("Customization")
	  			:(evntinf=P2C1)?("Appearance")
	  			:(evntinf=P2C2)?("Buttons Actions")
	  			:(evntinf=P3)?("Hotkeys")
	  			:("ERROR")
	      GuiControl, Settings:Choose,% TabHandler,% tabName
	  }
	Return

	Gui_Settings_Trades_Preview:
		GoSub, Gui_Settings_Btn_Apply

		backup := GlobalValues.Trades_GUI_Minimized, backup2 := GlobalValues.Trades_Auto_Minimize
		GlobalValues.Trades_GUI_Minimized := 0, GlobalValues.Trades_Auto_Minimize := 0

		Gui_Trades_Redraw("CREATE", {preview:1})

		GlobalValues.Trades_GUI_Minimized := backup, GlobalValues.Trades_Auto_Minimize := backup2
		backup := "", backup2 := ""
	Return

	Gui_Settings_Custom_Label:
		Gui, Settings:Submit, NoHide
		RegExMatch(A_GuiControl, "\d+", btnID)
		RegExMatch(A_GuiControl, "\D+", btnType)
		actionContent := (btnID=1)?(TradesAction1):(btnID=2)?(TradesAction2):(btnID=3)?(TradesAction3):(btnID=4)?(TradesAction4):(btnID=5)?(TradesAction5):(btnID=6)?(TradesAction6):(btnID=7)?(TradesAction7):(btnID=8)?(TradesAction8):(btnID=9)?(TradesAction9):("ERROR")
		labelContent := (btnID=1)?(TradesLabel1):(btnID=2)?(TradesLabel2):(btnID=3)?(TradesLabel3):(btnID=4)?(TradesLabel4):(btnID=5)?(TradesLabel5):(btnID=6)?(TradesLabel6):(btnID=7)?(TradesLabel7):(btnID=8)?(TradesLabel8):(btnID=9)?(TradesLabel9):("ERROR")
		Gui_Settings_Custom_Label_Func(btnType, DynamicGUIHandlersArray, btnID, actionContent, labelContent)
	Return

	Gui_Settings_Btn_WIKI:
		Run, % "https://github.com/lemasato/POE-Trades-Companion/wiki"
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
			GlobalValues.Insert("Hotkeys_Mode", "Advanced")
		}
		else {
			IniWrite,% "Basic",% iniFilePath, SETTINGS,Hotkeys_Mode
			GlobalValues.Insert("Hotkeys_Mode", "Basic")
		}
		GoSub Gui_Settings_Btn_Apply
		Gui_Settings()
		GuiControl, Settings:Choose,% TabHandler, Hotkeys
	Return

	GUI_Settings_Tick_Case:
		Gui, Settings: Submit, NoHide
		if ( A_GuiControl = "MessageSupportToggleText" ) {
			GuiControl, Settings:,% MessageSupportToggleHandler,% !MessageSupportToggle 
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
			if ( isActive > 0 )
				Winset, Transparent,% transActive
			else
				Winset, Transparent,% trans
		}
	return
	
	Gui_Settings_Close:
		Gui, Settings: Hide ; Hide the window while settings are being saved
		GoSub Gui_Settings_Btn_Apply
		Gui, Settings: Destroy
		IniRead, isActive,% iniFilePath,PROGRAM,Tabs_Number
		if ( isActive = 0 && GlobalValues["Trades_Click_Through"] = 1 )
			Gui, Trades: +E0x20

		Gui_Trades_Redraw("CREATE")
	return
	
	Gui_Settings_Notifications_Browse:
		FileSelectFile, soundFile, ,% programSFXFolderPath, Select an audio file (%programName%),Audio (*.wav; *.mp3)
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
		IniWrite,% trans,% iniFilePath,SETTINGS,Transparency
		IniWrite,% transActive,% iniFilePath,SETTINGS,Transparency_Active
		showMode := ( ShowAlways = 1 ) ? ( "Always" ) : ( ShowInGame = 1 ) ? ( "InGame" ) : ( "Always" )
		IniWrite,% showMode,% iniFilePath,SETTINGS,Show_Mode
		IniWrite,% AutoMinimize,% iniFilePath,SETTINGS,Trades_Auto_Minimize
		IniWrite,% AutoUnMinimize,% iniFilePath,SETTINGS,Trades_Auto_UnMinimize
		IniWrite,% ClickThrough,% iniFilePath,SETTINGS,Trades_Click_Through
		if ( ClickThrough )
			Gui, Trades: +E0x20
		else 
			Gui, Trades: -E0x20
		IniWrite,% SelectLastTab,% iniFilePath,SETTINGS,Trades_Select_Last_Tab
;	Clipboard
		IniWrite,% ClipTab,% iniFilePath,AUTO_CLIP,Clip_On_Tab_Switch
;	Notifications
		IniWrite,% NotifyTradeToggle,% iniFilePath,NOTIFICATIONS,Trade_Toggle
		IniWrite,% NotifyTradeSound,% iniFilePath,NOTIFICATIONS,Trade_Sound
		if ( tradesSoundFile )
			IniWrite,% tradesSoundFile,% iniFilePath,NOTIFICATIONS,Trade_Sound_Path
		IniWrite,% NotifyWhisperToggle,% iniFilePath,NOTIFICATIONS,Whisper_Toggle
		IniWrite,% NotifyWhisperSound,% iniFilePath,NOTIFICATIONS,Whisper_Sound
		if ( whispersSoundFile )
			IniWrite,% whispersSoundFile,% iniFilePath,NOTIFICATIONS,Whisper_Sound_Path
		IniWrite,% NotifyWhisperTray,% iniFilePath,NOTIFICATIONS,Whisper_Tray
		IniWrite,% NotifyWhisperFlash,% iniFilePath,NOTIFICATIONS,Whisper_Flash
;	Support Message
		IniWrite,% MessageSupportToggle,% iniFilePath,SETTINGS,Support_Text_Toggle
;	Hotkeys
		Loop 6 {
			index := A_Index
			KEY := "HK" index "_Toggle"
			CONTENT := (index=1)?(Hotkey1_Toggle):(index=2)?(Hotkey2_Toggle):(index=3)?(Hotkey3_Toggle):(index=4)?(Hotkey4_Toggle):(index=5)?(Hotkey5_Toggle):(index=6)?(Hotkey6_Toggle):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY

			KEY := "HK" index "_KEY"
			CONTENT := (index=1)?(Hotkey1_KEY):(index=2)?(Hotkey2_KEY):(index=3)?(Hotkey3_KEY):(index=4)?(Hotkey4_KEY):(index=5)?(Hotkey5_KEY):(index=6)?(Hotkey6_KEY):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY

			KEY := "HK" index "_Text"
			CONTENT := (index=1)?(Hotkey1_Text):(index=2)?(Hotkey2_Text):(index=3)?(Hotkey3_Text):(index=4)?(Hotkey4_Text):(index=5)?(Hotkey5_Text):(index=6)?(Hotkey6_Text):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,HOTKEYS,% KEY ; Quotes allows us to keep the spaces on IniRead

			KEY := "HK" index "_CTRL"
			CONTENT := (index=1)?(Hotkey1_CTRL):(index=2)?(Hotkey2_CTRL):(index=3)?(Hotkey3_CTRL):(index=4)?(Hotkey4_CTRL):(index=5)?(Hotkey5_CTRL):(index=6)?(Hotkey6_CTRL):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY

			KEY := "HK" index "_ALT"
			CONTENT := (index=1)?(Hotkey1_ALT):(index=2)?(Hotkey2_ALT):(index=3)?(Hotkey3_ALT):(index=4)?(Hotkey4_ALT):(index=5)?(Hotkey5_ALT):(index=6)?(Hotkey6_ALT):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY

			KEY := "HK" index "_SHIFT"
			CONTENT := (index=1)?(Hotkey1_SHIFT):(index=2)?(Hotkey2_SHIFT):(index=3)?(Hotkey3_SHIFT):(index=4)?(Hotkey4_SHIFT):(index=5)?(Hotkey5_SHIFT):(index=6)?(Hotkey6_SHIFT):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS,% KEY
		}
;	Hotkeys Advanced
		Loop 16 {
			index := A_Index
			KEY := "HK" index "_ADV_Toggle"
			CONTENT := (index=1)?(HotkeyAdvanced1_Toggle):(index=2)?(HotkeyAdvanced2_Toggle):(index=3)?(HotkeyAdvanced3_Toggle):(index=4)?(HotkeyAdvanced4_Toggle):(index=5)?(HotkeyAdvanced5_Toggle):(index=6)?(HotkeyAdvanced6_Toggle):(index=7)?(HotkeyAdvanced7_Toggle):(index=8)?(HotkeyAdvanced8_Toggle):(index=9)?(HotkeyAdvanced9_Toggle):(index=10)?(HotkeyAdvanced10_Toggle):(index=11)?(HotkeyAdvanced11_Toggle):(index=12)?(HotkeyAdvanced12_Toggle):(index=13)?(HotkeyAdvanced13_Toggle):(index=14)?(HotkeyAdvanced14_Toggle):(index=15)?(HotkeyAdvanced15_Toggle):(index=16)?(HotkeyAdvanced16_Toggle):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS_ADVANCED,% KEY

			KEY := "HK" index "_ADV_KEY"
			CONTENT := (index=1)?(HotkeyAdvanced1_KEY):(index=2)?(HotkeyAdvanced2_KEY):(index=3)?(HotkeyAdvanced3_KEY):(index=4)?(HotkeyAdvanced4_KEY):(index=5)?(HotkeyAdvanced5_KEY):(index=6)?(HotkeyAdvanced6_KEY):(index=7)?(HotkeyAdvanced7_KEY):(index=8)?(HotkeyAdvanced8_KEY):(index=9)?(HotkeyAdvanced9_KEY):(index=10)?(HotkeyAdvanced10_KEY):(index=11)?(HotkeyAdvanced11_KEY):(index=12)?(HotkeyAdvanced12_KEY):(index=13)?(HotkeyAdvanced13_KEY):(index=14)?(HotkeyAdvanced14_KEY):(index=15)?(HotkeyAdvanced15_KEY):(index=16)?(HotkeyAdvanced16_KEY):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,HOTKEYS_ADVANCED,% KEY

			KEY := "HK" index "_ADV_Text"
			CONTENT := (index=1)?(HotkeyAdvanced1_Text):(index=2)?(HotkeyAdvanced2_Text):(index=3)?(HotkeyAdvanced3_Text):(index=4)?(HotkeyAdvanced4_Text):(index=5)?(HotkeyAdvanced5_Text):(index=6)?(HotkeyAdvanced6_Text):(index=7)?(HotkeyAdvanced7_Text):(index=8)?(HotkeyAdvanced8_Text):(index=9)?(HotkeyAdvanced9_Text):(index=10)?(HotkeyAdvanced10_Text):(index=11)?(HotkeyAdvanced11_Text):(index=12)?(HotkeyAdvanced12_Text):(index=13)?(HotkeyAdvanced13_Text):(index=14)?(HotkeyAdvanced14_Text):(index=15)?(HotkeyAdvanced15_Text):(index=16)?(HotkeyAdvanced16_Text):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,HOTKEYS_ADVANCED,% KEY ; Quotes allows us to keep the spaces on IniRead
		}
;	Buttons Actions
		Loop 9 {
			index := A_Index

			KEY := "Button" index "_Hotkey"
			CONTENT := (index=1)?(TradesHK1):(index=2)?(TradesHK2):(index=3)?(TradesHK3):(index=4)?(TradesHK4):(index=5)?(TradesHK5):(index=6)?(TradesHK6):(index=7)?(TradesHK7):(index=8)?(TradesHK8):(index=9)?(TradesHK9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Label"
			CONTENT := (index=1)?(TradesLabel1):(index=2)?(TradesLabel2):(index=3)?(TradesLabel3):(index=4)?(TradesLabel4):(index=5)?(TradesLabel5):(index=6)?(TradesLabel6):(index=7)?(TradesLabel7):(index=8)?(TradesLabel8):(index=9)?(TradesLabel9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Action"
			CONTENT := (index=1)?(TradesAction1):(index=2)?(TradesAction2):(index=3)?(TradesAction3):(index=4)?(TradesAction4):(index=5)?(TradesAction5):(index=6)?(TradesAction6):(index=7)?(TradesAction7):(index=8)?(TradesAction8):(index=9)?(TradesAction9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_H"
			CONTENT := (index=1)?(TradesHPOS1):(index=2)?(TradesHPOS2):(index=3)?(TradesHPOS3):(index=4)?(TradesHPOS4):(index=5)?(TradesHPOS5):(index=6)?(TradesHPOS6):(index=7)?(TradesHPOS7):(index=8)?(TradesHPOS8):(index=9)?(TradesHPOS9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_V"
			CONTENT := (index=1)?(TradesVPOS1):(index=2)?(TradesVPOS2):(index=3)?(TradesVPOS3):(index=4)?(TradesVPOS4):(index=5)?(TradesVPOS5):(index=6)?(TradesVPOS6):(index=7)?(TradesVPOS7):(index=8)?(TradesVPOS8):(index=9)?(TradesVPOS9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_SIZE"
			CONTENT := (index=1)?(TradesSIZE1):(index=2)?(TradesSIZE2):(index=3)?(TradesSIZE3):(index=4)?(TradesSIZE4):(index=5)?(TradesSIZE5):(index=6)?(TradesSIZE6):(index=7)?(TradesSIZE7):(index=8)?(TradesSIZE8):(index=9)?(TradesSIZE9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Mark_Completed"
			CONTENT := (index=1)?(TradesMarkCompleted1):(index=2)?(TradesMarkCompleted2):(index=3)?(TradesMarkCompleted3):(index=4)?(TradesMarkCompleted4):(index=5)?(TradesMarkCompleted5):(index=6)?(TradesMarkCompleted6):(index=7)?(TradesMarkCompleted7):(index=8)?(TradesMarkCompleted8):(index=9)?(TradesMarkCompleted9):("ERROR")
			IniWrite,% CONTENT,% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY

			KEY := "Button" index "_Message_1"
			CONTENT := (index=1)?(TradesMsg1_1):(index=2)?(TradesMsg1_2):(index=3)?(TradesMsg1_3):(index=4)?(TradesMsg1_4):(index=5)?(TradesMsg1_5):(index=6)?(TradesMsg1_6):(index=7)?(TradesMsg1_7):(index=8)?(TradesMsg1_8):(index=9)?(TradesMsg1_9):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY ; Quotes allows us to keep the spaces on IniRead

			KEY := "Button" index "_Message_2"
			CONTENT := (index=1)?(TradesMsg2_1):(index=2)?(TradesMsg2_2):(index=3)?(TradesMsg2_3):(index=4)?(TradesMsg2_4):(index=5)?(TradesMsg2_5):(index=6)?(TradesMsg2_6):(index=7)?(TradesMsg2_7):(index=8)?(TradesMsg2_8):(index=9)?(TradesMsg2_9):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY ; Quotes allows us to keep the spaces on IniRead

			KEY := "Button" index "_Message_3"
			CONTENT := (index=1)?(TradesMsg3_1):(index=2)?(TradesMsg3_2):(index=3)?(TradesMsg3_3):(index=4)?(TradesMsg3_4):(index=5)?(TradesMsg3_5):(index=6)?(TradesMsg3_6):(index=7)?(TradesMsg3_7):(index=8)?(TradesMsg3_8):(index=9)?(TradesMsg3_9):("ERROR")
			IniWrite,% """" CONTENT """",% iniFilePath,CUSTOMIZATION_BUTTONS_ACTIONS,% KEY ; Quotes allows us to keep the spaces on IniRead
		}
;	Appearance Tab
		IniWrite,% ActivePreset,% iniFilePath,CUSTOMIZATION_APPEARANCE,Active_Preset
		IniWrite,% SelectedSkin,% iniFilePath,CUSTOMIZATION_APPEARANCE,Active_Skin
		StringReplace, SkinScaling, SkinScaling,% "%",% "", 1
		SkinScaling := SkinScaling/100
		SkinScaling := Round(SkinScaling, 2)
		IniWrite,% SkinScaling,% iniFilePath,CUSTOMIZATION_APPEARANCE,Scale_Multiplier
		IniWrite,% SelectedFont,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font
		IniWrite,% FontSize,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Size_Mode
		IniWrite,% FontSizeCustom,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Size_Custom
		IniWrite,% TitleActiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Title_Active
		IniWrite,% TitleInactiveColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Title_Inactive
		IniWrite,% TradesInfos1Color,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Trades_Infos_1
		IniWrite,% TradesInfos2Color,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Trades_Infos_2
		IniWrite,% TabsColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Tabs
		IniWrite,% ButtonsColor,% iniFilePath,CUSTOMIZATION_APPEARANCE,Font_Color_Buttons
;	Declare the new settings
		Disable_Hotkeys()
		settingsArray := Get_Local_Settings()
		Declare_Local_Settings(settingsArray)
		gameSettings := Get_Game_Settings()
		Declare_Game_Settings(gameSettings)
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
		HOTKEYS_ADVANCED_HandlersArray := returnArray.HOTKEYS_ADVANCED_HandlersArray
		HOTKEYS_ADVANCED_HandlersKeysArray := returnArray.HOTKEYS_ADVANCED_HandlersKeysArray
		CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray := returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray
		CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray := returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray
		CUSTOMIZATION_APPEARANCE_HandlersArray := returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray
		CUSTOMIZATION_APPEARANCE_HandlersKeysArray := returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray

		for key, element in sectionArray
		{
			sectionName := element
			for key, element in %sectionName%_HandlersKeysArray
			{
				keyName := element
				handler := %sectionName%_HandlersArray[key]

				IniRead, var,% iniFilePath,% sectionName,% keyName
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
				else if ( sectionName = "CUSTOMIZATION_BUTTONS_ACTIONS" ) {
					if RegExMatch(keyName, "_(H|V|SIZE|Action)$") ; Ends with either
					{
						GuiControl, Settings:Choose,% %handler%Handler,% var
					}
					else {
						handler := %sectionName%_HandlersArray[key]
						GuiControl, Settings:,% %handler%Handler,% var
					}
				}
				else if ( sectionName = "CUSTOMIZATION_APPEARANCE" ) {
					if keyName in Active_Skin,Font,Font_Size_Mode,Font_Size_Custom,Active_Preset,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
					{
						if keyName in Font_Size_Custom,Font_Color_Title_Active,Font_Color_Title_Inactive,Font_Color_Trades_Infos_1,Font_Color_Trades_Infos_2,Font_Color_Tabs,Font_Color_Buttons
						{
							GuiControl, Settings:-g,% %handler%Handler ; Prevent from triggeting the gLabel
							GuiControl, Settings:,% %handler%Handler,% var
							GuiControl, Settings:+gGui_Settings_Set_Custom_Preset,% %handler%Handler ; Re-enable gLabel
						}
						else {
							if ( keyName = "Active_Skin" ) {
								state := (var="System")?("Disable"):("Enable")
								GuiControl, Settings:%state%,% ButtonsColorHandler
								GuiControl, Settings:%state%,% TabsColorHandler
							}
							GuiControl, Settings:Choose,% %handler%Handler,% var
							if ( keyName = "Font_Size_Mode" ) {
								state := (var="Custom")?("Enable"):("Disable")
								GuiControl, Settings:%state%,% FontSizeCustomHandler
							}
						}
					}
					else if (keyName = "Scale_Multiplier")
					{
						var := var*100
						var := Round(var, 0)
						GuiControl, Settings:Choose,% %handler%Handler,% var "%"
					}
				}
				else if ( var != "ERROR" && var != "" ) { ; Everything else)
					handler := %sectionName%_HandlersArray[key]
					if ( handler = "FontSizeCustom")
						msgbox
					GuiControl, Settings:,% %handler%Handler,% var
				}
			}
		}
return

}

Gui_Settings_Custom_Label_Func(type, controlsArray, btnID, action, label) {
	if ( type = "TradesBtn" ) {
		controlsToHide := "(?:HPOS|HPOSText|VPOS|VPOSText|SIZE|SIZEText|Label|LabelText|Hotkey|HotkeyText|MarkCompleted|Action|ActionText|MsgEditID|MsgID|Msg1|Msg2|Msg3)"
		controlsToShow := "(?:HPOS" btnID "|HPOSText" btnID "|VPOS" btnID "|VPOSText" btnID "|SIZE" btnID "|SIZEText" btnID "|Label" btnID "|LabelText" btnID "|Hotkey" btnID "|HotkeyText" btnID "|Action" btnID "|ActionText" btnID "|MarkCompleted" btnID ")"

		for key, element in controlsArray {
			if RegExMatch(key, controlsToHide) {
				GuiControl,Settings:Hide,% element
			}
			if RegExMatch(key, controlsToShow) {
				GuiControl,Settings:Show,% element
			}
		}
	}

	if ( type = "TradesLabel" )
	GuiControl,Settings:,% controlsArray.Btn[btnID],% label

	if ( type = "TradesAction" || type = "TradesBtn" ) && ( action != "Clipboard Item" && action != "" ) {
		GuiControl,Settings:Show,% controlsArray["MsgEditID" btnID]
		GuiControl,Settings:Show,% controlsArray["MsgID" btnID]
		GuiControl,Settings:Show,% controlsArray["Msg1" btnID]
	}

	if ( type = "TradesAction" || type = "TradesBtn" ) && ( action = "Clipboard Item" || action = "" ) {
		GuiControl,Settings:Hide,% controlsArray["MsgEditID" btnID]
		GuiControl,Settings:Hide,% controlsArray["MsgID" btnID]
		GuiControl,Settings:Hide,% controlsArray["Msg1" btnID]
	}
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
	global ProgramValues

	programSFXFolderPath := ProgramValues["SFX_Folder"]

	returnArray := Object()
	returnArray.sectionArray := Object() ; contains all the .ini SECTIONS
	returnArray.sectionArray.Insert(0, "SETTINGS", "AUTO_CLIP", "HOTKEYS", "NOTIFICATIONS", "HOTKEYS_ADVANCED", "CUSTOMIZATION_BUTTONS_ACTIONS", "CUSTOMIZATION_APPEARANCE")
	
	returnArray.SETTINGS_HandlersArray := Object() ; contains all the Gui_Settings HANDLERS from this SECTION
	returnArray.SETTINGS_HandlersArray.Insert(0, "ShowAlways", "ShowInGame", "ShowTransparency", "ShowTransparencyActive", "AutoMinimize", "AutoUnMinimize", "ClickThrough", "SelectLastTab", "MessageSupportToggle")
	returnArray.SETTINGS_HandlersKeysArray := Object() ; contains all the .ini KEYS for those HANDLERS
	returnArray.SETTINGS_HandlersKeysArray.Insert(0, "Show_Mode", "Show_Mode", "Transparency", "Transparency_Active", "Trades_Auto_Minimize", "Trades_Auto_UnMinimize", "Trades_Click_Through", "Trades_Select_Last_Tab", "Support_Text_Toggle")
	returnArray.SETTINGS_KeysArray := Object() ; contains all the individual .ini KEYS
	returnArray.SETTINGS_KeysArray.Insert(0, "Show_Mode", "Transparency", "Trades_GUI_Mode", "Transparency_Active", "Hotkeys_Mode", "Trades_Auto_Minimize", "Trades_Auto_UnMinimize", "Trades_Click_Through", "Trades_Select_Last_Tab", "Support_Text_Toggle")
	returnArray.SETTINGS_DefaultValues := Object() ; contains all the DEFAULT VALUES for the .ini KEYS
	returnArray.SETTINGS_DefaultValues.Insert(0, "Always", "255", "Window", "255", "Basic", "1", "0", "0", "0", "0")
	
	returnArray.AUTO_CLIP_HandlersArray := Object()
	returnArray.AUTO_CLIP_HandlersArray.Insert(0, "ClipTab")
	returnArray.AUTO_CLIP_HandlersKeysArray := Object()
	returnArray.AUTO_CLIP_HandlersKeysArray.Insert(0, "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_KeysArray := Object()
	returnArray.AUTO_CLIP_KeysArray.Insert(0, "Clip_On_Tab_Switch")
	returnArray.AUTO_CLIP_DefaultValues := Object()
	returnArray.AUTO_CLIP_DefaultValues.Insert(0, "1")
	
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
	returnArray.NOTIFICATIONS_DefaultValues.Insert(0, "1", "WW_MainMenu_Letter.wav", programSFXFolderPath "\WW_MainMenu_Letter.wav", "0", "None", "", "1", "0")

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

	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray := Object()
	returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues := Object()
	keyID := 0
	keyID2 := 0
	Loop 9 {
		index := A_Index
		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersArray.Insert(keyID
		,"TradesBtn" index
		,"TradesAction" index
		,"TradesHPOS" index
		,"TradesVPOS" index
		,"TradesSIZE" index
		,"TradesLabel" index
		,"TradesHK" index
		,"TradesMsg1_" index
		,"TradesMsg2_" index
		,"TradesMsg3_" index
		,"TradesMarkCompleted" index)

		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_HandlersKeysArray.Insert(keyID
		, "Button" index "_Label"
		, "Button" index "_Action"
		, "Button" index "_H"
		, "Button" index "_V"
		, "Button" index "_SIZE"
		, "Button" index "_Label"
		, "Button" index "_Hotkey"
		, "Button" index "_Message_1"
		, "Button" index "_Message_2"
		, "Button" index "_Message_3"
		, "Button" index "_Mark_Completed")

		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray.Insert(keyID2
		, "Button" index "_Label"
		, "Button" index "_Action"
		, "Button" index "_H"
		, "Button" index "_V"
		, "Button" index "_SIZE"
		, "Button" index "_Label"
		, "Button" index "_Hotkey"
		, "Button" index "_Message_1"
		, "Button" index "_Message_2"
		, "Button" index "_Message_3"
		, "Button" index "_Mark_Completed")

		btnLabel := (index=1)?("Clipboard Item")
				 :(index=2)?("Ask to Wait")
				 :(index=3)?("Party Invite")
				 :(index=4)?("Thank You")
				 :(index=5)?("Sold It")
				 :(index=6)?("Still Interested?")
				 :(index=7)?("Trade Request")
				 :("[Undefined]")

		btnAction := (index=1)?("Clipboard Item")
				  :(index=2)?("Send Message")
				  :(index=3)?("Send Message")
				  :(index=4)?("Send Message + Close Tab")
				  :(index=5)?("Send Message + Close Tab")
				  :(index=6)?("Send Message")
				  :(index=7)?("Send Message"):("")

		btnHotkey := ("")

		btnMsg1 := (index=1)?("")
				:(index=2)?("@%buyerName% Can you wait a moment? Currently busy. (%itemName% listed for %itemPrice%)")
				:(index=3)?("/invite %buyerName%")
				:(index=4)?("/kick %buyerName%")
				:(index=5)?("@%buyerName% Sorry! My %itemName% listed for %itemPrice% is not available anymore!")
				:(index=6)?("@%buyerName% I'm back! Do you still want to buy my %itemName% listed for %itemPrice%?")
				:(index=7)?("/tradewith %buyerName%")
				:("")
		btnMsg2 := (index=1)?("")
				:(index=2)?("")
				:(index=3)?("@%buyerName% My %itemName% listed for %itemPrice% is ready to be picked up!")
				:(index=4)?("@%buyerName% Thank you! Good luck and have fun!")
				:(index=5)?("")
				:(index=6)?("")
				:(index=7)?("")
				:("")
		btnMsg3 := (index=1)?("")
				:(index=2)?("")
				:(index=3)?("")
				:(index=4)?("")
				:(index=5)?("")
				:(index=6)?("")
				:(index=7)?("")
				:("")

		btnMarkCompleted := (index=4)?(1):(0)
		btnH := (index=1)?("Left"):(index=2)?("Center"):(index=3)?("Right"):(index=4)?("Left"):(index=5)?("Right"):(index=6)?:("")
		btnV := (index=1)?("Top"):(index=2)?("Top"):(index=3)?("Top"):(index=4)?("Middle"):(index=5)?("Middle"):(index=6)?:("")
		btnSIZE := (index=1)?("Small"):(index=2)?("Small"):(index=3)?("Small"):(index=4)?("Medium"):(index=5)?("Small"):("Disabled")
		returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues.Insert(keyID2, btnLabel, btnAction, btnH, btnV, btnSIZE, btnLabel, btnHotkey, btnMsg1, btnMsg2, btnMsg3, btnMarkCompleted)
		keyID += 11
		keyID2 += 11
	}

	returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_KeysArray := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_DefaultValues := Object()
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersArray.Insert(0, "ActivePreset", "SelectedSkin", "SkinScaling", "SelectedFont", "FontSize", "FontSizeCustom", "TitleActiveColor", "TitleInactiveColor", "TradesInfos1Color", "TradesInfos2Color", "TabsColor", "ButtonsColor")
	returnArray.CUSTOMIZATION_APPEARANCE_HandlersKeysArray.Insert(0, "Active_Preset", "Active_Skin", "Scale_Multiplier", "Font", "Font_Size_Mode", "Font_Size_Custom", "Font_Color_Title_Active", "Font_Color_Title_Inactive", "Font_Color_Trades_Infos_1", "Font_Color_Trades_Infos_2", "Font_Color_Tabs", "Font_Color_Buttons")
	returnArray.CUSTOMIZATION_APPEARANCE_KeysArray.Insert(0, "Active_Preset", "Active_Skin", "Scale_Multiplier", "Font", "Font_Size_Mode", "Font_Size_Custom", "Font_Color_Title_Active", "Font_Color_Title_Inactive", "Font_Color_Trades_Infos_1", "Font_Color_Trades_Infos_2", "Font_Color_Tabs", "Font_Color_Buttons")
	returnArray.CUSTOMIZATION_APPEARANCE_DefaultValues.Insert(0, "System", "System", "1", "System", "Automatic", "8", "FFFF00", "FFFFFF", "SYSTEM", "SYSTEM" , "SYSTEM", "SYSTEM")

	return returnArray
}

Get_Control_ToolTip(controlName) {
;			Retrieves the tooltip for the corresponding control
;			Return a variable conaining the tooltip content
	global ProgramValues

	btnType := RegExReplace(controlName, "\d")

	programName := ProgramValues["Name"]

	ShowInGame_TT := ShowAlways_TT := "Decide when should the GUI show."
	. "`nAlways show:" A_Tab . A_Tab "The interface will always appear."
	. "`nOnly show while in game:" A_Tab "The interface will only appear when the game's window is active."

	ClickThrough_TT := "Clicks will go through the interface while it is inactive,"
	. "`nallowing you to click any window behind it."
	ShowTransparency_TT := "Transparency of the interface when no trades are on queue."
	. "`nSetting the value to 0% will effectively make it invisible."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on the current active/inactive state."
	ShowTransparencyActive_TT := "Transparency of the GUI when trades are on queue."
	. "`nThe minimal value is set to 30% to make sure you can still see the window."
	. "`nWhile moving the slider, you can see a preview of the result."
	. "`nUpon releasing the slider, it will revert back to its default transparency based on the current active/inactive state."

	SelectLastTab_TT := "Always focus the new tab upon receiving a new trade whisper."

	AutoMinimize_TT := "Automatically minimize the Trades GUI when no trades are on queue."
	AutoUnMinimize_TT := "Automatically un-minimize the Trades GUI upon receiving a trade whisper."
	
	NotifyTradeBrowse_TT := NotifyTradeSound_TT := NotifyTradeToggle_TT := "Play a sound when you receive a trade whisper."
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperBrowse_TT := NotifyWhisperSound_TT := NotifyWhisperToggle_TT := "Play a sound when you receive a regular whisper"
	. "`nTick the case to enable."
	. "`nClick on [Browse] to select a sound file."
	
	NotifyWhisperTray_TT := "Show a tray notification when you receive"
	. "`na whisper while the game window is not active."

	NotifyWhisperFlash_TT := "Make the game's window flash when you receive"
	. "`na whisper while the game window is not active."
	
	ClipTab_TT := "Automatically put the tab's item in clipboard"
	. "`nso you can easily CTRL+F CTRL+V in your stash to search for the item."

	MessageSupportToggle_TT := ":)`n`nOnly triggers for ""Send Message + Close Tab"" buttons.", MessageSupportToggleText_TT := "(:`n`nOnly triggers for ""Send Message + Close Tab"" buttons."

	Hotkey_Toggle_TT := "Tick the case to enable this hotkey."
	Hotkey_Text_TT := "Message that will be sent upon pressing this hotkey."
	Hotkey_KEY_TT := "Hotkey to trigger this custom command/message."
	Hotkey_CTRL_TT := "Enable CTRL as a modifier for this hotkey."
	Hotkey_ALT_TT := "Enable ALT as a modifier for this hotkey."
	Hotkey_SHIFT_TT := "Enable SHIFT as a modifier for this hotkey."

	HotkeyAdvanced_TT := Hotkey_Toggle_TT
	HotkeyAdvanced_KEY_TT := Hotkey_KEY_TT
	HotkeyAdvanced_Text_TT := Hotkey_Text_TT

	TradesHPOS_TT := "Horizontal position of the button."
	. "`nLeft:" A_Tab . A_Tab "The button will be positioned on the left side."
	. "`nCenter:" A_Tab . A_Tab "The button will be positioned on the center."
	. "`nRight:" A_Tab . A_Tab "The button will be positioned on the right side."

	TradesVPOS_TT := "Vertical position of the button."
	. "`nTop:" A_Tab . A_Tab "The button will be positioned on the top row."
	. "`nCenter:" A_Tab . A_Tab "The button will be positioned on the middle row."
	. "`nBottom:" A_Tab . A_Tab "The button will be positioned on the bottom row."

	TradesSIZE_TT := "Size of the button."
	. "`nDisabled:" A_Tab "The button will not appear."
	. "`nSmall:" A_Tab . A_Tab "The button will take one third of the row."
	. "`nMedium:" A_Tab "The button will take two third of the row."
	. "`nLarge:" A_Tab . A_Tab "The button will take the whole row."

	TradesLabel_TT := "Name of the button as it will appear on the interface."

	TradesAction_TT := "Action that will be triggered upon clicking the button."
	. "`nClipboard Item:" A_Tab . A_Tab "Put the current tab's item into the clipboard."
	. "`nSend Message:" A_Tab . A_Tab "Send all the messages you have set for this button."
	. "`nClose Tab:" A_Tab . A_Tab "Close the currently active tab."
	. "`nWrite Message:" A_Tab . A_Tab "Write a single message in chat, without sending it."

	TradesMarkCompleted_TT := "Store the trade's infos in a local file."
	. "`nThis will be later used for statistics purposes."

	TradesMSG__TT := TradesMsgID_TT := "Cycle between the messages that will be sent upon pressing this button."
	
	try
		controlTip := % %btnType%_TT
	if ( controlTip ) 
		return controlTip
	else 
		controlTip := btnType ; Used to get the control tooltip 
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
	global ProgramValues

	programVersion := ProgramValues["Version"], programFolder := ProgramValues["Local_Folder"], programChangelogsFilePath := ProgramValues["Changelogs_File"]
	
	updaterPath := "POE-TC-Updater.exe"
	updaterDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/Updater.exe"
	versionDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/version.txt"
	changelogDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/changelogs.txt"
	
;	Delete files remaining from updating
	if (FileExist(updaterPath))
		FileDelete,% updaterPath
	if (FileExist("POE-TC-NewVersion.exe"))
		FileDelete,% "POE-TC-NewVersion.exe"
	
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
		FileRead, changelogLocal,% programChangelogsFilePath
		if ( changelogLocal != changelogText ) {
			FileDelete, % programChangelogsFilePath
			UrlDownloadToFile, % changelogDL,% programChangelogsFilePath
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
	global ProgramValues

	iniFilePath := ProgramValues["Ini_File"], programName := ProgramValues["Name"], programPID := ProgramValues["PID"]

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
		FileSetAttrib, +H,% updaterPath
		sleep 1000
		Run, % updaterPath
		Process, Close, %programPID%
		ExitApp
	return
	
	Gui_Update_Refuse:
		Gui, Submit
		if ( autoUpdate )
			IniWrite, 1,% iniFilePath,PROGRAM,AutoUpdate
	return

	Gui_Update_Open_Page:
		Gui, Submit
		Run, % "https://github.com/lemasato/POE-Trades-Companion/releases"
	return
}

;==================================================================================================================
;
;												ABOUT GUI
;
;==================================================================================================================

Gui_About() {
	static
	global ProgramValues

	programChangelogsFilePath := ProgramValues["Changelogs_File"]
	iniFilePath := ProgramValues["Ini_File"], programName := ProgramValues["Name"], programVersion := ProgramValues["Version"]

	Gui, About:Destroy
	Gui, About:New, +HwndaboutGuiHandler +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs,% programName " by lemasato v" programVersion
	Gui, About:Default

	FileRead, changelogText,% programChangelogsFilePath
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
	Gui, Add, DropDownList, w500 gVersion_Change AltSubmit vVerNum hwndVerNumHandler R10,%allVersions%
	Gui, Add, Edit, Section vChangesText hwndChangesTextHandler wp R15 ReadOnly,An internet connection is required
	GuiControl, Choose,%VerNumHandler%,1
	GoSub, Version_Change

	Gui, Add, Text, xs ,See on:
	Gui, Add, Link, gGitHub_Link xp yp+15,% "<a href="""">GitHub</a> - "
	Gui, Add, Link, gReddit_Link xp+45 yp,% "<a href="""">Reddit</a> - "
	Gui, Add, Link, gGGG_Link xp+45 yp,% "<a href="""">GGG</a>"
	Gui, Add, Picture,xp+335 yp-5 gPaypal_Link,% ProgramValues["Others_Folder"] "\DonatePaypal.png"

	Gui, Show, AutoSize
	return
	
	Version_Change:
		Gui, Submit, NoHide
		GuiControl, ,%ChangesTextHandler%,% allChanges[verNum]
		Gui, Show, AutoSize
	return

	Reddit_Link:
		Run,% ProgramValues["Reddit"]
	Return

	Github_Link:
		Run,% ProgramValues["GitHub"]
	Return

	GGG_Link:
		Run,% ProgramValues["GGG"]
	Return

	Paypal_Link:
		Run,% ProgramValues["Paypal"]
	Return
}

;==================================================================================================================
;
;											INI SETTINGS
;
;==================================================================================================================

Get_Game_Settings() {
	global ProgramValues

	gameFile := ProgramValues.Game_Ini_File
	gameFileCopy := ProgramValues.Game_Ini_File_Copy

	if !FileExist(gameFile) {
		String := "File Not Found: """ gameFile """"
		Logs_Append("DEBUG", {String:String})
	}

	FileRead, fileContent,% gameFile
	if !(fileContent || ErrorLevel) {
		String := "Unable to retrieve content: """ gameFile """"
		Logs_Append("DEBUG", {String:String})
	}

	File := FileOpen(gameFileCopy, "w", "UTF-16")
	File.Write(fileContent)
	if (ErrorLevel) {
		String := "Could not Write in File: " gameFileCopy
		Logs_Append("DEBUG", {String:String})
		doAlternative := 1
	}
	File.Close()

	if (doAlternative && fileContent) {
		fileEncode := A_FileEncoding
		FileEncoding,UTF-16

		FileDelete,% gameFileCopy
		FileAppend,% fileContent,% gameFileCopy

		FileEncoding,% fileEncode
	}

	IniRead, chatKeySC,% gameFileCopy,ACTION_KEYS,chat
	IniRead, fullscreen,% gameFileCopy,DISPLAY,fullscreen

	chatKeyVK := StringToHex(chr(chatKeySC+0))
	chatKeyName := GetKeyName("VK" chatKeyVK)

	returnObj := { "Chat_SC" : chatKeySC
				  ,"Chat_VK" : chatKeyVK
				  ,"Chat_Name" : chatKeyName
				  ,"Fullscreen" : fullscreen }

	return returnObj
}

Declare_Game_Settings(settings) {
	global GameValues

	for key, value in settings {
		GameValues.Insert(key, value)
	}
}

Get_Local_Settings() {
;			Retrieve the INI settings
;			Return a big array containing arrays for each section containing the keys and their values
	global ProgramValues

	iniFilePath := ProgramValues["Ini_File"]
	
	returnArray := Object()
	returnArray := Gui_Settings_Get_Settings_Arrays()
	
	sectionArray := returnArray.sectionArray
	SETTINGS_KeysArray := returnArray.SETTINGS_KeysArray
	AUTO_CLIP_KeysArray := returnArray.AUTO_CLIP_KeysArray
	HOTKEYS_KeysArray := returnArray.HOTKEYS_KeysArray
	NOTIFICATIONS_KeysArray := returnArray.NOTIFICATIONS_KeysArray
	HOTKEYS_ADVANCED_KeysArray := returnArray.HOTKEYS_ADVANCED_KeysArray
	CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray := returnArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray
	CUSTOMIZATION_APPEARANCE_KeysArray := returnArray.CUSTOMIZATION_APPEARANCE_KeysArray
	
	returnArray.KEYS := Object()
	returnArray.VALUES := Object()
	for key, element in sectionArray
	{
		sectionName := element
		for key, element in %sectionName%_KeysArray
		{
			keyName := element
			IniRead, var,% iniFilePath,% sectionName,% keyName
			returnArray.KEYS.Insert(keyName)
			returnArray.VALUES.Insert(var)
		}
	}
	return returnArray
} 

Set_Local_Settings(){
;			Set the default INI settings if they do not exist
	global ProgramValues

	iniFilePath := ProgramValues["Ini_File"], programPID := ProgramValues["PID"]

;	Set the PID and filename, used for the auto updater
	IniWrite,% programPID,% iniFilePath,PROGRAM,PID
	IniWrite,% A_ScriptName,% iniFilePath,PROGRAM,FileName

	HiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows On
	WinGet, fileProcessName, ProcessName, ahk_pid %programPID%
	IniWrite,% fileProcessName,% iniFilePath,PROGRAM,FileProcessName
	DetectHiddenWindows, %HiddenWindows%

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
	HOTKEYS_ADVANCED_KeysArray := settingsArray.HOTKEYS_ADVANCED_KeysArray
	HOTKEYS_ADVANCED_DefaultValues := settingsArray.HOTKEYS_ADVANCED_DefaultValues
	CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray := settingsArray.CUSTOMIZATION_BUTTONS_ACTIONS_KeysArray
	CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues := settingsArray.CUSTOMIZATION_BUTTONS_ACTIONS_DefaultValues
	CUSTOMIZATION_APPEARANCE_KeysArray := settingsArray.CUSTOMIZATION_APPEARANCE_KeysArray
	CUSTOMIZATION_APPEARANCE_DefaultValues := settingsArray.CUSTOMIZATION_APPEARANCE_DefaultValues
;	Set the value for each key
	for key, element in sectionArray
	{
		sectionName := element
		for key, element in %sectionName%_KeysArray
		{
			keyName := element
			value := %sectionName%_DefaultValues[key]
			IniRead, var,% iniFilePath,% sectionName,% keyName
			if ( var = "ERROR" ) {
				IniWrite,% value,% iniFilePath,% sectionName,% keyName
			}
		}
	}
}

Declare_Local_Settings(iniArray) {
;			Declare the settings to global variables
	global GlobalValues

	for key, element in iniArray.KEYS {
		value := iniArray.VALUES[key]
		GlobalValues.Insert(element, value) ;access value using: GlobalValues["element"]
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
	global GlobalValues

	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx

;	Basic Hotkeys
	Loop 6 {
		index := A_Index
		if ( GlobalValues["HK" index "_Toggle"] ) {
			userHotkey%index% := GlobalValues["HK" index "_KEY"]
			if ( GlobalValues["HK" index "_CTRL"] )
				userHotkey%index% := "^" userHotkey%index%
			if ( GlobalValues["HK" index "_ALT"] )
				userHotkey%index% := "!" userHotkey%index%
			if ( GlobalValues["HK" index "_SHIFT"] )
				userHotkey%index% := "+" userHotkey%index%
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%,Off
				}
			}
		}
	}
;	Advanced Hotkeys
	Loop 16 {
		index := A_Index
		if ( GlobalValues["HK" index "_ADV_Toggle"] ) {
			userHotkey%index% := GlobalValues["HK" index "_ADV_KEY"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%indzex% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%,Off
				}
			}
		}
	}		
;	Trades GUI Hotkeys
	Loop 9 {
		index := A_Index
		if ( GlobalValues["Button" index "_SIZE"] != "Disabled") {
			userHotkey%index% := GlobalValues["Button" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				try {
					Hotkey,% userHotkey%index%, Off
				}
			}
		}
	}
	SetTitleMatchMode, %titleMatchMode%	
}

Enable_Hotkeys() {
	;	Enable the hotkeys, based on its global VALUE_ content
	global GlobalValues, ProgramValues

	programName := ProgramValues["Name"], iniFilePath := ProgramValues["Ini_File"]

	titleMatchMode := A_TitleMatchMode
	SetTitleMatchMode, RegEx

;	Trades GUI Hotkeys
	Loop 9 {
		index := A_Index
		if ( GlobalValues["Button" index "_SIZE"] != "Disabled" ) {
			userHotkey%index% := GlobalValues["Button" index "_Hotkey"]
			Hotkey,IfWinActive,ahk_group POEGame
			if ( userHotkey%index% != "" && userHotkey%index% != "ERROR" ) {
				Hotkey,% userHotkey%index%,Hotkeys_TradesGUI_%index%,On
			}
		}
	}
;	Advanced Hotkeys
	if ( GlobalValues.Hotkeys_Mode = "Advanced" ) {
		Loop 16 {
			index := A_Index
			if ( GlobalValues["HK" index "_ADV_Toggle"] ) {
				userHotkey%index% := GlobalValues["HK" index "_ADV_KEY"]
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
;	Basic Hotkeys
	else if ( GlobalValues.Hotkeys_Mode = "Basic" ) {
		Loop 6 {
			index := A_Index
			if ( GlobalValues["HK" index "_Toggle"] ) {
				userHotkey%index% := GlobalValues["HK" index "_KEY"]
				if ( GlobalValues["HK" index "_CTRL"] )
					userHotkey%index% := "^" userHotkey%index%
				if ( GlobalValues["HK" index "_ALT"] )
					userHotkey%index% := "!" userHotkey%index%
				if ( GlobalValues["HK" index "_SHIFT"] )
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
;												OTHERS GUI
;
;==================================================================================================================

GUI_Replace_PID(handlersArray, gamePIDArray) {
;		GUI used when clicking one of the Trades GUI buttons and the PID is not associated with POE anymore
;		Provided two array containing all the POE handlers and PID, it allows the user to choose which PID to use as a replacement
	static
	global ProgramValues

	programName := ProgramValues["Name"]

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
	}
	Gui, ReplacePID:Show,NoActivate,% programName " - Replace PID"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Replace_PID_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := gamePIDArray[btnID]
		Gui, ReplacePID:Destroy
		Logs_Append("GUI_Replace_PID_Return", {PID:r})
	Return
}

GUI_Multiple_Instances(handlersArray) {
;		GUI used when multiple instances of POE running in different folders have been found upon running the Monitor_Logs() function
;		Provided an array containing all the POE handlers, it allows the user to choose which logs file to monitor
	static
	global ProgramValues

	programName := ProgramValues["Name"]

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
		Logs_Append(A_ThisFunc, {Handler:element, Path:pPath})
	}
	Gui, Instances:Show,NoActivate,% programName " - Multiple instances found"
	WinWait, ahk_id %GUIInstancesHandler%
	WinWaitClose, ahk_id %GUIInstancesHandler%
	return r

	GUI_Multiple_Instances_Continue:
		btnID := RegExReplace(A_GuiControl, "\D")
		r := handlersArray[btnID]
		Gui, Instances:Destroy
		Logs_Append("GUI_Multiple_Instances_Return", {Handler:r})
	Return
}

;==================================================================================================================
;
;												WM_MESSAGES
;
;==================================================================================================================

WM_RBUTTONDOWN(wParam, lParam, msg, hwnd) {
	global TradesGUI_Controls, GlobalValues

	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	if ( A_Gui = "Trades" ) {
		if (btnType = "delBtn") {
			Menu, TradesCloseBtn, Add, Close similar trades, Gui_Trades_Close_Similar
			Menu, TradesCloseBtn, Show
		}
	}
	return

	Gui_Trades_Close_Similar:
;		Check for other trades with different buyer but same item/price/location
 		tabToDel := GlobalValues["Trades_GUI_Current_Active_Tab"]
 		duplicatesID := Gui_Trades_Check_Duplicate(tabToDel)
 		if ( duplicatesID.MaxIndex() ) {
 			duplicatesInfos := Gui_Trades_Get_Trades_Infos(duplicatesID[0])
			Gui_Trades(duplicatesID, "REMOVE_DUPLICATES")	
		}
	Return
}

Set_Mouse_Leave_Tracking(hwnd) {
/*			Allows to use WM_MouseLeave (0x2A3) with GUI that do not have a border.
 *			Credits: RHCP - autohotkey.com/board/topic/120763-wm-mousemove-how/?p=685998
 *
 *			Requires: 	Existing functions: WM_MOUSEMOVE(wParam, lParam, msg, hwnd)
 *											WM_MOUSELEAVE(wParam, lParam, msg, hwnd)
 *						A global variable shared between these two
 *
 *			Usage:		Inside WM_MOUSEMOVE: if !VALUE_Mouse_Tracking
 *											 VALUE_Mouse_Tracking := Set_Mouse_Leave_Tracking(hwnd)
 *
*/
	static v
	if !v
	{
		VarSetCapacity(v, size := A_Ptrsize = 8 ? 24 : 16, 0)
		NumPut(size, v, 0, "UInt")            ; cbSize
		NumPut(0x00000002, v, 4, "UInt")    ; dwFlags (TME_LEAVE)
		NumPut(hwnd, v, 8, "Ptr")          ; HWND
		NumPut(0, v, A_Ptrsize = 8 ? 16 : 12, "UInt")            ; dwHoverTime (ignored) 
	}
	return  DllCall("TrackMouseEvent", "Ptr", &v) ; Non-zero on success
}

WM_LBUTTONDBLCLK(wParam, lParam, msg, hwnd) {
/*			Blocks the default behaviour of placing in clipboard
 *				when double-clicking a static (text) control
 *
 *			Usage: 	OnMessage(0x203, "WM_LBUTTONDBLCLK") - Enabled
 *					OnMessage(0x203, "WM_LBUTTONDBLCLK", 0) - Disabled
 *
 *			Credits: Lexikos
 *			autohotkey.com/board/topic/94962-doubleclick-on-gui-pictures-puts-their-path-in-your-clipboard/?p=682595
*/
	WinGetClass class, ahk_id %hwnd%
	if (class = "Static") {
		if !A_Gui
			return 0  ; Just prevent Clipboard change.
		; Send a WM_COMMAND message to the Gui to trigger the control's g-label.
		Gui +LastFound
		id := DllCall("GetDlgCtrlID", "ptr", hwnd) ; Requires AutoHotkey v1.1.
		static STN_DBLCLK := 1
		PostMessage 0x111, id | (STN_DBLCLK << 16), hwnd
		if GetKeyState("LButton") ; LButton down
			WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
		; Return a value to prevent the default handling of this message.
		return 0
	}

}

WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
	static
	global GlobalValues, ProgramValues, TradesGUI_Controls
	global guiTradesHandler

	programSkinFolderPath := ProgramValues["Skins_Folder"]

	lastButton := GlobalValues["TradesGUI_Last_Hover_Button"]
	lastPngFilePrefix := GlobalValues["TradesGUI_Last_PNG"]
	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	; if (A_GUI) {
	; 	sleep 10
	; 	if !VALUE_Mouse_Tracking {
	; 		VALUE_TradesGUI_Last_Hover_Control := A_GuiControl
	; 		VALUE_Mouse_Tracking := Set_Mouse_Leave_Tracking(hwnd)
	; 	}
	; }
	if (A_GUI = "Trades") {

		btnHandler := (btnType="CustomBtn")?(TradesGUI_Controls["Button_Custom_" btnID])
				     :(btntype="delBtn")?(TradesGUI_Controls["Button_Close"])
				     :(btnType="GoRight")?(TradesGUI_Controls["Arrow_Right"])
				     :(btnType="GoLeft")?(TradesGUI_Controls["Arrow_Left"])
				     :(btntype="BuyerSlot")?(TradesGUI_Controls["Buyer_Slot_" btnID])
				     :(btntype="ItemSlot")?(TradesGUI_Controls["Item_Slot_" btnID])
				     :(btntype="PriceSlot")?(TradesGUI_Controls["Price_Slot_" btnID])
				     :(btntype="LocationSlot")?(TradesGUI_Controls["Location_Slot_" btnID])
				     :(btntype="OtherSlot")?(TradesGUI_Controls["Other_Slot_" btnID])
				     :("ERROR")

		if (btnType = "CustomBtn" || btnType = "delBtn" || btnType = "GoRight" || btnType = "GoLeft") {
			if ( btnHandler != lastButton && btnHandler ) {
				; GuiControlGet, outVar, Hwnd,%A_GuiControl%
				pngFilePrefix := (btnType="CustomBtn")?("ButtonBackground"):(btnType="delBtn")?("Close"):(btnType="GoRight")?("ArrowRight"):(btnType="GoLeft")?("ArrowLeft"):("ERROR")
				; tooltip % pngFilePrefix "`n" FileExist(programSkinFolderPath "\" pngFilePrefix "Hover.png")
				if FileExist(programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Hover.png") && FileExist(programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Press.png") {
					GetKeyState, LButtonState, LButton
					if ( LButtonState = "D" && btnHandler = GlobalValues["Trades_GUI_Button_Held"] ) {
					 	GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Press.png"
					}
					else {
						GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Hover.png"
					}
					GuiControl, Trades:,% lastButton,% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" lastPngFilePrefix ".png"
					lastPngFilePrefix := pngFilePrefix
					; tooltip % btnType
					; Gui, Trades:Font, c875516
					; GuiControl, Trades:Font,CustomBtnTXT%lastBtnID%
					; GuiControl, Trades:,% lastButton,% programSkinFolderPath "\" VALUE_Skin "\" lastPngFilePrefix ".png"
				}
			}

			GlobalValues.Insert("TradesGUI_Last_Hover_Button", btnHandler)
			btnState := "Hover"
		}
		else if (btnState = "Hover") {
			GuiControl, Trades:,% lastButton,% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" lastPngFilePrefix ".png"
			btnState := "Default"

			; Gui, Trades:Font, c875516
			; tooltip % btnType " - " A_GuiControl " - " lastBtnID "- " VALUE_Trades_GUI_Hover_Control " - " VALUE_TradesGUI_Last_Hover_Button
			RegExMatch(GlobalValues["TradesGUI_Last_Hover_Button"], "\D+", lastbtnType)
			GlobalValues.Insert("TradesGUI_Last_Hover_Button", "")
			if (lastbtnType = "CustomBtn") {
				; GuiControl, Trades:Hide,% TradesGUI_Controls["Button_Custom_" lastBtnID]
				; GuiControl, Trades:+Redraw,CustomBtn%lastbtnID%OrnamentLeft
				; GuiControl, Trades:+Redraw,CustomBtn%lastbtnID%OrnamentRight
				; GuiControl, Trades:+Redraw,CustomBtnTXT%lastbtnID%
			}
		}
		else if (btnType = "BuyerSlot" || btnType = "ItemSlot" || btnType = "PriceSlot" || btnType = "LocationSlot" || btnType = "OtherSlot") {
			CoordMode, ToolTip, Screen
			GuiControlGet, content,Trades:,% btnHandler
			GuiControlGet, ctrlPOS,Trades:Pos,% btnHandler
			WinGetPos, tradesXPOS, tradesYPOS
			ToolTip, % content,% tradesXPOS+ctrlPOSX,% tradesYPOS+ctrlPOSY
			MouseGetPos, mouseX, mouseY
			SetTimer, ToolTipTimer, 100
		}
		else {
			ToolTip, 
		}
	}

	else if ( A_GUI = "Settings" ) {
		timer := (ProgramValues.Debug)?(-100):(-1000)
		curControl := A_GuiControl
		If ( curControl <> prevControl ) {
			controlTip := Get_Control_ToolTip(curControl)
			if ( controlTip )
				SetTimer, Display_ToolTip,% timer
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

		ToolTipTimer:
;			Credits to POE-TradeMacro: https://github.com/PoE-TradeMacro/POE-TradeMacro
			MouseGetPos, ,CurrY
			MouseMoved := (CurrY - mouseY) ** 2 > 10 ** 2
			if (MouseMoved)	{
				SetTimer, ToolTipTimer, Off
				ToolTip 
			}
		return
	}

	; MouseGetPos, , , underMouseHandler
	; if (underMouseHandler != guiTradesHandler) {
	; 	; tooltip ok
	; 	btnType := "CustomBtn"
	; 	pngFilePrefix := (btnType="CustomBtn")?("ButtonBackground"):(btnType="delBtn")?("Close"):(btnType="GoRight")?("ArrowRight"):(btnType="GoLeft")?("ArrowLeft"):("ERROR")
	; 	; Loop 9 {
	; 		GuiControlGet, var,Trades:,CustomBtn1
	; 		tooltip % A_Index " : " var
	; 		; sleep 500
	; 		; if ( var && var != programSkinFolderPath "\" VALUE_Skin "\" pngFilePrefix ".png")
	; 		; tooltip % var
	; 		; GuiControl, Trades:,CustomBtn%A_Index%,% programSkinFolderPath "\" VALUE_Skin "\" pngFilePrefix ".png"
	; 	; }
	; }
	if (btnID)
		lastBtnID := btnID
	if (pngFilePrefix)
		GlobalValues.Insert("TradesGUI_Last_PNG", pngFilePrefix)
	if (A_GuiControl)
		GlobalValues.Insert("Trades_GUI_Hover_Control", A_GuiControl)
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
	global GlobalValues, ProgramValues, TradesGUI_Controls

	programSkinFolderPath := ProgramValues["Skins_Folder"]

	RegExMatch(A_GuiControl, "\D+", btnType)
	RegExMatch(A_GuiControl, "\d+", btnID)

	if (A_GUI = "Trades") {
		btnHandler := (btnType="CustomBtn")?(TradesGUI_Controls["Button_Custom_" btnID])
				     :(btntype="delBtn")?(TradesGUI_Controls["Button_Close"])
				     :(btnType="GoRight")?(TradesGUI_Controls["Arrow_Right"])
				     :(btnType="GoLeft")?(TradesGUI_Controls["Arrow_Left"])
				     :("ERROR")

		if (btnType = "CustomBtn" || btnType = "delBtn" || btnType = "GoRight" || btnType = "GoLeft") {
			pngFilePrefix := (btnType="CustomBtn")?("ButtonBackground"):(btnType="delBtn")?("Close"):(btnType="GoRight")?("ArrowRight"):(btnType="GoLeft")?("ArrowLeft"):("ERROR")
			if FileExist(programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Hover.png") && FileExist(programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Press.png") {
				GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Press.png"
				GlobalValues.Insert("Trades_GUI_Button_Held", btnHandler)
				KeyWait, LButton, U

;				Retrieve handlers of the button's assets
				MouseGetPos, , , , underMouseHandler, 2
				if ( btnType = "CustomBtn" ) {
					GuiControlGet, ClickedBtnHandler, Trades:Hwnd,% TradesGUI_Controls["Button_Custom_" btnID]
					GuiControlGet, ClickedBtnOrnateLeftHandler, Trades:Hwnd,% TradesGUI_Controls["Button_Custom_" btnID "_OrnamentLeft"]
					GuiControlGet, ClickedBtnOrnateRightHandler, Trades:Hwnd,% TradesGUI_Controls["Button_Custom_" btnID "_OrnamentRight"]
					GuiControlGet, ClickedBtnTXTHandler, Trades:Hwnd,% TradesGUI_Controls["Button_Custom_" btnID "_Text"]
					matchsList := ClickedBtnHandler "," ClickedBtnOrnateLeftHandler "," ClickedBtnOrnateRightHandler "," ClickedBtnTXTHandler
				}
				else {
					GuiControlGet, ClickedBtnHandler, Trades:Hwnd,% btnHandler
					matchsList := ClickedBtnHandler
				}
				
				if underMouseHandler in %matchsList% ; Button still under cursor after releasing click, revert to Hover state
					GuiControl, Trades:,% btnHandler,% programSkinFolderPath "\" GlobalValues["Active_Skin"] "\" pngFilePrefix "Hover.png"
				else ; Button not anymore under cursor, cancel the button gLabel
					GlobalValues.Insert("Trades_GUI_Button_Cancel", 1)
			}
		}
	}
}

WM_MOUSELEAVE(wParam, lParam, Msg, hwnd){
	static
	global ProgramValues, GlobalValues
	global guiTradesHandler

	programSkinFolderPath := ProgramValues["Skins_Folder"]

	; Set_Mouse_Leave_Tracking(hwnd)

	; if (A_GUI="Trades" && !VALUE_TradesGUI_Last_Hover_Control) {
	; 		MouseGetPos, , , underMouseHandler
	; 		if (underMouseHandler != guiTradesHandler) {
	; 			tooltip fuk
	; 			btnType := "CustomBtn"
	; 			pngFilePrefix := (btnType="CustomBtn")?("ButtonBackground"):(btnType="delBtn")?("Close"):(btnType="GoRight")?("ArrowRight"):(btnType="GoLeft")?("ArrowLeft"):("ERROR")
	; 			Loop 9 {
	; 				GuiControlGet, var,Trades:Font,CustomBtnTXT%A_Index%
	; 				msgbox % var
	; 				GuiControl, Trades:,CustomBtn%A_Index%,% programSkinFolderPath "\" VALUE_Skin "\" pngFilePrefix ".png"
	; 			}
	; 		}

		; GuiControl, Trades:,% VALUE_TradesGUI_Last_Hover_Control,% programSkinFolderPath "\" VALUE_Skin "\" VALUE_TradesGUI_Last_PNG ".png"
		; RegExMatch(VALUE_TradesGUI_Last_Hover_Control, "\D+", btnType)
		; if ( btnType = "CustomBtn" ) {
		; 	RegExMatch(VALUE_TradesGUI_Last_Hover_Control, "\d+", btnID)
		; 	Gui, Trades:Font, c875516
		; 	GuiControl, Trades:Font,CustomBtn%btnID%
		; 	GuiControl, Trades:+Redraw,CustomBtn%btnID%
		; 	GuiControl, Trades:+Redraw,CustomBtn%btnID%OrnamentLeft
		; 	GuiControl, Trades:+Redraw,CustomBtn%btnID%OrnamentRight
		; }
	; }
	; if (!A_GUI) {
	; 	GuiControl, Trades:,% VALUE_TradesGUI_Last_Hover_Button,% programSkinFolderPath "\" VALUE_Skin "\" VALUE_TradesGUI_Last_PNG ".png"
	; 	RegExMatch(VALUE_TradesGUI_Last_Hover_Button, "\D+", btnType)
	; 	if ( btnType = "CustomBtn" ) {
	; 		RegExMatch(VALUE_TradesGUI_Last_Hover_Button, "\d+", btnID)
	; 		Gui, Trades:Font, c875516
	; 		GuiControl, Trades:Font,CustomBtn%btnID%
	; 		GuiControl, Trades:+Redraw,CustomBtn%btnID%
	; 		GuiControl, Trades:+Redraw,CustomBtn%btnID%OrnamentLeft
	; 		GuiControl, Trades:+Redraw,CustomBtn%btnID%OrnamentRight
	; 	}
	; }

	; else {
	; 	traytip,,%A_GUI% - %VALUE_TradesGUI_Last_Hover_Control%
	; }
	; sleep 100
	GlobalValues.Insert("Mouse_Tracking", 0)
}


ShellMessage(wParam,lParam) {
/*			Triggered upon activating a window
 *			Is used to correctly position the Trades GUI while in Overlay mode
*/
	global ProgramValues, GlobalValues
	global guiTradesHandler, tradesGuiWidth, POEGameList

	programSkinFolderPath := ProgramValues["Skins_Folder"]

	if ( wParam=4 or wParam=32772 ) { ; 4=HSHELL_WINDOWACTIVATED | 32772=HSHELL_RUDEAPPACTIVATED
		if WinActive("ahk_id" guiTradesHandler) {
;		Prevent these keyboard presses from interacting with the Trades GUI
			Hotkey, IfWinActive, ahk_id %guiTradesHandler%
			Hotkey, NumpadEnter, DoNothing, 
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

		WinGet, winEXE, ProcessName, ahk_id %lParam%
		WinGet, winID, ID, ahk_id %lParam%
		if ( GlobalValues["Show_Mode"] = "InGame" ) {

			if ( tradesGuiWidth > 0 ) { ; TradesGUI exists
				if POEGameList not contains %winEXE%
				{
					Gui, Trades:Show, NoActivate Hide
				}
				else {
					Gui, Trades:Show, NoActivate
				}
			}
		}
		else
			Gui, Trades:Show, NoActivate ; Always Shwo

		if ( GlobalValues["Gui_Trades_Mode"] = "Overlay")
			Gui_Trades_Set_Position() ; Re-position the GUI

		Gui, Trades:+LastFound
		WinSet, AlwaysOnTop, On
	}
}

/******************************************************************************************************************
*
*	FGP by kon
*	https://autohotkey.com/boards/viewtopic.php?f=6&t=3806
*	
*	Example Usage:
	#NoEnv
	SetBatchLines, -1
	FileSelectFile, FilePath					; Select a file to use for this example.
	
	PropName := FGP_Name(0)						; Gets a property name based on the property number.
	PropNum  := FGP_Num("Size")					; Gets a property number based on the property name.
	PropVal1 := FGP_Value(FilePath, PropName)	; Gets a file property value by name.
	PropVal2 := FGP_Value(FilePath, PropNum)	; Gets a file property value by number.
	PropList := FGP_List(FilePath)				; Gets all of a file's non-blank properties.
	
	MsgBox, % PropName ":`t" PropVal1			; Display the results.
	. "`n" PropNum ":`t" PropVal2
	. "`n`nList:`n" PropList.CSV
*
*******************************************************************************************************************
*/

/*  FGP_Init()
 *		Gets an object containing all of the property numbers that have corresponding names. 
 *		Used to initialize the other functions.
 *	Returns
 *		An object with the following format:
 *			PropTable.Name["PropName"]	:= PropNum
 *			PropTable.Num[PropNum]		:= "PropName"
 */
FGP_Init() {
	static PropTable
	if (!PropTable) {
		PropTable := {Name: {}, Num: {}}, Gap := 0
		oShell := ComObjCreate("Shell.Application")
		oFolder := oShell.NameSpace(0)
		while (Gap < 11)
			if (PropName := oFolder.GetDetailsOf(0, A_Index - 1)) {
				PropTable.Name[PropName] := A_Index - 1
				PropTable.Num[A_Index - 1] := PropName
				Gap := 0
			}
			else
				Gap++
	}
	return PropTable
}


/*  FGP_Value(FilePath, Property)
 *		Gets a file property value.
 *	Parameters
 *		FilePath	- The full path of a file.
 *		Property	- Either the name or number of a property.
 *	Returns
 *		If succesful the file property value is returned. Otherwise:
 *		0			- The property is blank.
 *		-1			- The property name or number is not valid.
 */
FGP_Value(FilePath, Property) {
	static PropTable := FGP_Init()
	if ((PropNum := PropTable.Name[Property] != "" ? PropTable.Name[Property]
	: PropTable.Num[Property] ? Property : "") != "") {
		SplitPath, FilePath, FileName, DirPath
		oShell := ComObjCreate("Shell.Application")
		oFolder := oShell.NameSpace(DirPath)
		oFolderItem := oFolder.ParseName(FileName)
		if (PropVal := oFolder.GetDetailsOf(oFolderItem, PropNum))
			return PropVal
		return 0
	}
	return -1
}

;==================================================================================================================
;
;												MISC STUFF
;
;==================================================================================================================

Remove_TrayTip:
	TrayTip
Return

Get_All_Games_Instances() {
	global GlobalValues

	WinGet windows, List
	matchHandlers := Get_Matching_Windows_Infos("ID")

	if ( matchHandlers.MaxIndex() = "" ) { ; No matching process found
		return "EXE_NOT_FOUND"
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
				GlobalValues.Insert("Dock_Window", matchHandlers[0])
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
		GlobalValues.Insert("Dock_Window", winHandler) ; assign global var after choosing the right instance
	}
	r := logsFile
	return r
}

Do_Once() {
/*			
 *			Things that only need to be done ONCE
*/
	global ProgramValues

	iniFilePath := ProgramValues["Ini_File"]

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
	dpiFactor := (ErrorLevel || dpiValue=96)?(1):(dpiValue/96)
	return dpiFactor
}

Logs_Append(funcName, params) {
	global ProgramValues, GlobalValues, GameValues

	programName := ProgramValues["Name"]
	programVersion := ProgramValues["Version"]
	iniFilePath := ProgramValues["Ini_File"]
	programLogsFilePath := ProgramValues["Logs_File"]

	if ( funcName = "DUMP" ) {
		dpiFactor := GlobalValues["Screen_DPI"]
		OSbits := (A_Is64bitOS)?("64bits"):("32bits")
		FileAppend,% "OS: Type:" A_OSType " - Version:" A_OSVersion " - " OSbits "`n",% programLogsFilePath
		FileAppend,% "DPI: " dpiFactor "`n",% programLogsFilePath
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		FileAppend,% ">>> PROGRAM SECTION `n",% programLogsFilePath
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		IniRead, content,% iniFilePath,PROGRAM
		FileAppend,% content "`n",% programLogsFilePath
		FileAppend,% "`n",% programLogsFilePath

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		FileAppend,% ">>> GAME SETTINGS `n",% programLogsFilePath
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		for key, element in GameValues {
			FileAppend,% key ": """ element """`n",% programLogsFilePath
		}
		FileAppend,% "`n",% programLogsFilePath

		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		FileAppend,% ">>> LOCAL SETTINGS `n",% programLogsFilePath
		FileAppend,% ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>`n",% programLogsFilePath
		for key, element in params.KEYS {
			FileAppend,% params.KEYS[A_Index] ": """ params.VALUES[A_Index] """`n",% programLogsFilePath
		}
		FileAppend,% "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n",% programLogsFilePath
		FileAppend,% "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<`n",% programLogsFilePath
		FileAppend,% "`n",% programLogsFilePath
	}

	if ( funcName = "DEBUG" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% params.String,% programLogsFilePath
	}

	if ( funcName = "GUI_Multiple_Instances" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Found multiple instances. Handler: " params.Handler " - Path: " params.Path,% programLogsFilePath
	}
	if ( funcName = "GUI_Multiple_Instances_Return" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Found multiple instances (Return). Handler: " params.Handler,% programLogsFilePath
	}

	if ( funcName = "Monitor_Game_Logs" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Monitoring logs: " params.File,% programLogsFilePath
	}
	if ( funcName = "Monitor_Game_Logs_Break" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Monitoring logs (Break). Obj.pos: " params.objPos " - Obj.length: " params.objLength,% programLogsFilePath
	}

	if ( funcName = "Gui_Trades_Set_Position" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Trades GUI Position: x" params.xpos " y" params.ypos ".",% programLogsFilePath
	}

	if (funcName = "ShellMessage" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Trades GUI Hidden: Show_Mode: " params.Show_Mode " - Dock_Window ID: " params.Dock_Window " - Current Win ID: " params.Current_Win_ID "."
	}

	if ( funcName = "Send_InGame_Message" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Sending IG Message to PID """ params.PID """ with content: """ params.Message,% programLogsFilePath
		matchsArray := Get_Matching_Windows_Infos("PID")
		for key, element in matchsArray
			FileAppend,% " | Instance" key " PID: " element,% programLogsFilePath
	}

	if ( funcName = "Gui_Trades_Cycle_Func" ) {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Docking the GUI to ID: " params.Dock_Window " - Total matchs found: " params.Total_Matchs + 1,% programLogsFilePath
	}

	if ( funcName = "GUI_Replace_PID_Return") {
		FileAppend,% "[" A_YYYY "-" A_MM "-" A_DD "_" A_Hour ":" A_Min ":" A_Sec "] ",% programLogsFilePath
		FileAppend,% "Replacing linked PID (Return). PID: " params.PID,% programLogsFilePath
	}

	FileAppend,% "`n",% programLogsFilePath
}

Delete_Old_Logs_Files(filesToKeep) {
/*
 *			Delete logs files
 *			Keeps only the ammount specified
*/
	global ProgramValues

	programLogsPath := ProgramValues["Logs_Folder"]

	loop, %programLogsPath%\*.txt
	{
		filesNum := A_Index
		if ( A_LoopFileName != "changelog.txt" ) {
			allFiles .= A_LoopFileName "|"
		}
	}
	Sort, allFiles, D|
	split := StrSplit(allFiles, "|")
	if ( filesNum >= filesToKeep ) {
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

Send_InGame_Message(allMessages, tabInfos="", specialEvent="") {
/*
 *			Sends a message in game
 *			Replaces all the %variables% into their actual content
*/
	global GlobalValues, ProgramValues, GameValues

	programName := ProgramValues["Name"]
	gameIniFile := ProgramValues["Game_Ini_File"]

	buyerName := tabInfos.Buyer, itemName := tabInfos.Item, itemPrice := tabInfos.Price, gamePID := tabInfos.PID, activeTab := tabInfos.TabID
	messageRaw1 := allMessages[1], messageRaw2 := allMessages[2], messageRaw3 := allMessages[3]
	message1 := allMessages[1], message2 := allMessages[2], message3 := allMessages[3]

	chatVK := GameValues.Chat_VK
	if (!chatVK) {
		MsgBox, 4096,% programName " - Operation Cancelled.",% "Could not detect the chat key!"
		. "`nPlease send me an archive containing the Logs folder."
		. "`nYou can find links to GitHub / GGG / Reddit in the [About?] tray menu."
		. "`n`n(The local folder containing the Logs folder will open upon closing this box)."
		Run, % ProgramValues.Local_Folder
		Return 1
	}

	Loop 3 { ; Include the trade variable content into the variables.
		StringReplace, message%A_Index%, message%A_Index%, `%buyerName`%, %buyerName%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%itemName`%, %itemName%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%itemPrice`%, %itemPrice%, 1
		StringReplace, message%A_Index%, message%A_Index%, `%lastWhisper`%,% GlobalValues["Last_Whisper"], 1
	}

	if ( specialEvent.isHotkey ) {
		messageToSend := message1
		if ( GlobalValues["Hotkeys_Mode"] = "Advanced" ) {
			SendInput,%messageToSend%
		}
		else {
			firstChar := SubStr(messageToSend, 1, 1) ; Returns abc

			SendInput,{VK%chatVK%}
			Sleep 10

			if firstChar not in /,`%,&,#,@
				SendInput, /{BackSpace} ; Send in local chat
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
				Return 1
			}
			else {
				newPID := GUI_Replace_PID(handlersArray, PIDArray)
				setInfos := Object(), setInfos.NewPID := newPID, setInfos.OldPID := gamePID, setInfos.TabID := tabInfos.TabID
				Gui_Trades_Set_Trades_Infos(setInfos)
				gamePID := newPID
			}
		}
		titleMatchMode := A_TitleMatchMode
		SetTitleMatchMode, RegEx
		WinActivate,[a-zA-Z0-9_] ahk_pid %gamePID%
		WinWaitActive,[a-zA-Z0-9_] ahk_pid %gamePID%, ,5
		if (!ErrorLevel) {
			Loop 3 {
				messageToSend := message%A_Index%
				if ( !messagetoSend )
					Break
				else {
					Sleep 10
					if chatVK in 0x1,0x2,0x4,0x5,0x6,0x9C,0x9D,0x9E,0x9F ; Mouse buttons
					{
						keyDelay := A_KeyDelay, keyDuration := A_KeyDuration
						SetKeyDelay, 10, 10
						ControlSend, ,{VK%keyVK%}, [a-zA-Z0-9_] ahk_pid %gamePID% ; Mouse buttons tend to activate the window under the cursor.
																				  ; Therefore, we need to send the key to the actual game window.
  						SetKeyDelay,% keyDelay,% keyDuration
						Sleep 10
					}
					else
						SendInput,{VK%chatVK%}

					firstChar := SubStr(messageToSend, 1, 1) ; Returns abc
					if firstChar not in /,`%,&,#,@
						SendInput,/{BackSpace}
					SendInput,{Raw}%messageToSend%
					if !( specialEvent.doNotSend )
						SendInput,{Enter}
					Sleep 10
				}
			}
		}

		Logs_Append(A_ThisFunc, {PID:gamePID, Message:messageToSend})
		BlockInput, Off
	}
}


StringToHex(String) {
;		Original script author ahklerner
;		autohotkey.com/board/topic/15831-convert-string-to-hex/?p=102873
	
	formatInteger := A_FormatInteger 	;Save the current Integer format
	SetFormat, Integer, Hex ; Set the format of integers to their Hex value
	
	;Parse the String
	Loop, Parse, String 
	{
		CharHex := Asc(A_LoopField) ; Get the ASCII value of the Character (will be converted to the Hex value by the SetFormat Line above)
		; StringTrimLeft, CharHex, CharHex, 2 ; Comment out the following line to leave the '0x' intact
		HexString .= CharHex . " " ; Build the return string
	}
	SetFormat, Integer,% formatInteger ; Set the integer format to what is was prior to the call
	
	HexString = %HexString% ; Remove blankspaces	
	Return HexString
}


Extract_Font_Files() {
/*			Include the Resources into the compiled executable
 *			Extract the Resources into their specified folder
*/
	global ProgramValues, ProgramFonts

	programFontFolderPath := ProgramValues["Fonts_Folder"]

	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\Fontin-SmallCaps.ttf,% programFontFolderPath "\Fontin-SmallCaps.ttf"
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Fonts\Settings.ini,% programFontFolderPath "\Settings.ini"
}

Extract_Skin_Files() {
/*			Include the default skins into the compilled executable
 *			Extracts the included skins into the skins Folder
*/
	global ProgramValues

	programSkinFolderPath := ProgramValues["Skins_Folder"]

;	System Skin
	if !( InStr(FileExist(programSkinFolderPath "\System"), "D") )
		FileCreateDir, % programSkinFolderPath "\System"
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Settings.ini,% programSkinFolderPath "\System\Settings.ini", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Header.png,% programSkinFolderPath "\System\Header.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Border.png,% programSkinFolderPath "\System\Border.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\System\Icon.png,% programSkinFolderPath "\System\Icon.png", 1

;	Path of Exile Skin
	if !( InStr(FileExist(programSkinFolderPath "\Path of Exile"), "D") )
		FileCreateDir, % programSkinFolderPath "\Path of Exile"
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Settings.ini,% programSkinFolderPath "\Path Of Exile\Settings.ini", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowLeft.png,% programSkinFolderPath "\Path Of Exile\ArrowLeft.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowLeftHover.png,% programSkinFolderPath "\Path Of Exile\ArrowLeftHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowLeftPress.png,% programSkinFolderPath "\Path Of Exile\ArrowLeftPress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowRight.png,% programSkinFolderPath "\Path Of Exile\ArrowRight.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowRightHover.png,% programSkinFolderPath "\Path Of Exile\ArrowRightHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ArrowRightPress.png,% programSkinFolderPath "\Path Of Exile\ArrowRightPress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Background.png,% programSkinFolderPath "\Path Of Exile\Background.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonBackground.png,% programSkinFolderPath "\Path Of Exile\ButtonBackground.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonBackgroundHover.png,% programSkinFolderPath "\Path Of Exile\ButtonBackgroundHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonBackgroundPress.png,% programSkinFolderPath "\Path Of Exile\ButtonBackgroundPress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonOrnamentLeft.png,% programSkinFolderPath "\Path Of Exile\ButtonOrnamentLeft.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ButtonOrnamentRight.png,% programSkinFolderPath "\Path Of Exile\ButtonOrnamentRight.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Close.png,% programSkinFolderPath "\Path Of Exile\Close.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\CloseHover.png,% programSkinFolderPath "\Path Of Exile\CloseHover.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\ClosePress.png,% programSkinFolderPath "\Path Of Exile\ClosePress.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\TabActive.png,% programSkinFolderPath "\Path Of Exile\TabActive.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\TabInactive.png,% programSkinFolderPath "\Path Of Exile\TabInactive.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\TabUnderline.png,% programSkinFolderPath "\Path Of Exile\TabUnderline.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Header.png,% programSkinFolderPath "\Path Of Exile\Header.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path Of Exile\Border.png,% programSkinFolderPath "\Path Of Exile\Border.png", 1
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Skins\Path of Exile\Icon.png,% programSkinFolderPath "\Path of Exile\Icon.png", 1
}

Extract_Sound_Files() {
/*			Include the SFX into the compilled executable
 *			Extracts the included SFX into the SFX Folder
*/
	global ProgramValues

	programSFXFolderPath := ProgramValues["SFX_Folder"]

	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\MM_Tatl_Gleam.wav,% programSFXFolderPath "\MM_Tatl_Gleam.wav", 0
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\MM_Tatl_Hey.wav,% programSFXFolderPath "\MM_Tatl_Hey.wav", 0
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\WW_MainMenu_CopyErase_Start.wav,% programSFXFolderPath "\WW_MainMenu_CopyErase_Start.wav", 0
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\SFX\WW_MainMenu_Letter.wav,% programSFXFolderPath "\WW_MainMenu_Letter.wav", 0
}

Extract_Others_Files() {
/*			Include any other file that does not belong to the others
			Extracts the included files into the specified folder
*/
	global ProgramValues

	programOthersFolderPath := ProgramValues["Others_Folder"]
	FileInstall, C:\Users\Masato\Documents\GitHub\POE-Trades-Companion\Resources\Others\DonatePaypal.png,% programOthersFolderPath "\DonatePaypal.png", 0
}

Close_Previous_Program_Instance() {
/*
 *			Prevents from running multiple instances of this program
 *			Works by reading the last PID and process name from the .ini
 *				, checking if there is an existing match
 *				and closing if a match is found
*/
	global ProgramValues, RunParameters

	if ( RunParameters["NoReplace"] = 1 ) {
		Return
	}

	iniFilePath := ProgramValues["Ini_File"]

	IniRead, lastPID,% iniFilePath,PROGRAM,PID
	IniRead, lastProcessName,% iniFilePath,PROGRAM,FileProcessName

	if ( A_IsAdmin = 0 )
		Return ; Not running as admin means script will be going through the Run_As_Admin function

	Process, Exist, %lastPID%
	existingPID := ErrorLevel
	if ( existingPID = 0 )
		Return ; No match found
	else {
		HiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, On ; Required to access the process name
		WinGet, existingProcessName, ProcessName, ahk_pid %existingPID% ; Get process name from PID
		DetectHiddenWindows, %HiddenWindows%
		if ( existingProcessName = lastProcessName ) { ; Match found, close the previous instance
			Process, Close, %existingPID%
			Process, WaitClose, %existingPID%
		}
	}

}

GUI_Trades_Cycle:
	Gui_Trades_Cycle_Func()
Return

Gui_Trades_Cycle_Func() {
/*
 *			Retrieves the existing POE instances
 *				then cycle the Trades GUI through each instance
 *				for every time the user triggers the function
 *			Once the last match was reached
 *				we reset back to the first match
*/
	static
	global ProgramValues, GlobalValues
	global guiTradesHandler

	programName := ProgramValues["Name"]
	nextID := GlobalValues["Current_DockID"]
	nextID += 1

	if ( GlobalValues["Trades_GUI_Mode"] != "Overlay" )
		Return

	if !(guiTradesHandler) {
		Loop 2
			TrayTip,% programName,% "Couldn't find the Trades GUI!`nOperation Canceled."
		Return
	}
	matchHandlers := Get_Matching_Windows_Infos("ID")
	GlobalValues.Insert("Current_DockID", nextID)
	if ( GlobalValues["Current_DockID"] > matchHandlers.MaxIndex() ) {
		GlobalValues.Insert("Current_DockID", 0)
	}
	GlobalValues.Insert("Dock_Window", matchHandlers[GlobalValues["Current_DockID"]])
	Gui_Trades_Set_Position()
	Logs_Append(A_ThisFunc, {Dock_Window:GlobalValues.Dock_Window, Total_Matchs:matchHandlers.MaxIndex()})
}

Get_Matching_Windows_Infos(mode) {
/*
 *			Retrieves a list of all existing windows
 *				then returns an array containing only those matching the game
*/
	global POEGameList

	matchsArray := Object()
	matchsList := ""
	index := 0

	HiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off

	WinGet, windows, List
	Loop %windows%
	{
		ExeID := windows%A_Index%
		WinGet, ExeName, ProcessName,% "ahk_id " ExeID
		WinGet, ExePID, PID,% "ahk_id " ExeID
		if ExeName in %POEGameList%
		{
			if ( mode = "ID" ) {
				if ExeID not in %matchsList%
					matchsList .= ExeID ","
			}
			else if ( mode = "PID" ){
				if ExePID not in %matchsList%
					matchsList .= ExePID ","
			}
		}
	}
	Loop, Parse, matchsList,% ","
	{
		if ( A_LoopField != "" ) {
			matchsArray.Insert(index, A_LoopField)
			index++
		}
	}
	DetectHiddenWindows, %HiddenWindows%
	return matchsArray
}

Create_Tray_Menu() {
/*
 *			Creates the Tray Menu
*/
	global GlobalValues, ProgramValues

	programName := ProgramValues["Name"], programVersion := ProgramValues["Version"]

	Menu, Tray, NoStandard
	Menu, Tray, DeleteAll
	Menu, Tray, Tip,% programName " v" programVersion
	if ( ProgramValues.Debug ) {
		Menu, Debug, Add,Open game folder,Open_Game_Folder
		Menu, Debug, Add,Open local folder,Open_Local_Folder
		Menu, Debug, Add,Delete local settings (+Reload),Delete_Local_Folder
		Menu, Tray, Add, Debug,:Debug
	}
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
	Menu, Tray, Check,% "Mode: " GlobalValues["Trades_GUI_Mode"]
	Menu, Tray, Icon
	Return

	Delete_Local_Folder:
		FileRemoveDir,% ProgramValues.Local_Folder, 1
		Reload_Func()
	Return

	Open_Game_Folder:
		Run,% ProgramValues.Game_Folder,,UseErrorLevel
		if (A_LastError) {
			ErrorMsg := Get_System_Error_Codes(A_LastError)
		}
	Return

	Open_Local_Folder:
		Run,% ProgramValues.Local_Folder,,UseErrorLevel
		if (A_LastError) {
			ErrorMsg := Get_System_Error_Codes(A_LastError)
		}
	Return
}

Get_System_Error_Codes(Err) {
	Msg := (Err=2)?("Code: " Err " (ERROR_FILE_NOT_FOUND) `nThe system cannot find the file specified.")
		  :(Err=3)?("Code: " Err " (ERROR_PATH_NOT_FOUND) `nThe system cannot find the path specified.")
		  :(Err=5)?("Code: " Err " (ERROR_ACCESS_DENIED) `nAccess is denied.")
		  :("Code: " Err " `nReport to Microsoft System Error Codes to get description of the error.")

	MsgBox, 4096,% ProgramValues.Name,% Msg
}


Run_As_Admin() {
/*			If not running with as admin, reload with admin rights. 
*/
	global ProgramValues, GlobalValues

	programName := ProgramValues["Name"]

	IniWrite,% A_IsAdmin,% ProgramValues.Ini_File,PROGRAM,Is_Running_As_Admin

	if ( A_IsAdmin ) {
		IniWrite, 0,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
		Return
	}

	IniRead, attempts,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
	attempts := (attempts=""||attempts="ERROR")?(0):(attempts), attempts++
	IniWrite,% attempts,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
	if ( attempts > 2 ) {
		IniWrite,0,% ProgramValues.Ini_File,PROGRAM,Run_As_Admin_Attempts
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
		. "`nThough, clicking the buttons and using hotkeys will not work."
		IfMsgBox, Yes
		{
			return
		}
		IfMsgBox, Cancel
		{
			ExitApp
		}
		IfMsgBox, No
		{
			ExitApp
		}
	}
	dpiFactor := GlobalValues["Screen_DPI"]
	SplashTextOn, 370*dpiFactor, 40*dpiFactor,% programName,% programName " needs to run with Admin .`nAttempt to restart with admin rights in 3 seconds..."
	sleep 3000

	Reload_Func()
}

Handle_CommandLine_Parameters() {
	global 0
	global RunParameters, ProgramValues

	programName := ProgramValues.Name

	Loop, %0% { ; Process cmdline parameters
		param := %A_Index%
		if ( param = "/NoReplace" ) {
			RunParameters.Insert("NoReplace", 1)
		}
		else if RegExMatch(param, "/GamePath=(.*)", found) {
			if FileExist(found1) {
				RunParameters.Insert("GamePath", found1)
				found1 := ""
			}
			else {
				MsgBox, 4096,% programName,% "The /GamePath parameter was detected but the specified file does not exist:"
				. "`n" found1
				. "`n`nIf you need help about Command Line Parameters, please check the WIKI here: https://github.com/lemasato/POE-Trades-Companion/wiki"
				. "`n`nThe program will now exit."
				ExitApp
			}
		}
		else if RegExMatch(param, "/PrefsFile=(.*)", found) {
			path := ProgramValues.Local_Folder "/" found1
			ProgramValues.Insert("Ini_File", path)
			found1 := "", path = ""
		}
		else if RegExMatch(param, "/GameINI=(.*)", found) {
			if FileExist(found1) {
				ProgramValues.Insert("Game_Ini_File", found1)
				found1 := ""
			}
			else {
				MsgBox, 4096,% programName,% "The /GameINI parameter was detected but the specified file does not exist:"
				. "`n" found1
				. "`n`nIf you need help about Command Line Parameters, please check the WIKI here: https://github.com/lemasato/POE-Trades-Companion/wiki"
				. "`n`nThe program will now exit."
				ExitApp
			}
		}
		else if RegExMatch(param, "/MyDocuments=(.*)", found) {
			RunParameters.Insert("MyDocuments", found1)
		}
	}
}

Tray_Refresh() {
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
/*
 *		Reload the application, including the command-line parameters.
 * 
 *		Credits to art for the DllCall to reload in admin mode.
 *		https://autohotkey.com/board/topic/46526-run-as-administrator-xpvista7-a-isadmin-params-lib/?p=600596
*/
	global 0
	global RunParameters

	Sleep 10

	Loop, %0%
	{
		param := RegExReplace(%A_Index%, "(.*)=(.*)", "$1=""$2""") ; Add quotation mark to the parameter. Missing quotation marks would incorectly parse the run parameters on next load.
		params .= A_Space . param
	}
	if !(A_IsAdmin) {
		params .= A_Space . "/MyDocuments=" A_MyDocuments
	}
	else {
		params .= A_Space . "/MyDocuments=" RunParameters.MyDocuments
	}

	Exit_Func("Reload","")
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath
	: A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	OnExit("Exit_Func", 0)
	ExitApp

	Sleep 10000
}

Gui_Trades_Save_Position(X="FALSE", Y="FALSE") {
;		Save the current X and Y positions of the Trades GUI.
;		Only if the GUI is in Winodw Mode.
	global GlobalValues, ProgramValues
	global GuiTradesHandler, tradesGuiWidth

	iniFilePath := ProgramValues.Ini_File

	if ( X != "FALSE" && Y != "FALSE" ) {
		IniWrite,% X,% iniFilePath,PROGRAM,X_POS
		IniWrite,% Y,% iniFilePath,PROGRAM,Y_POS
	}
	else {
		if ( GlobalValues.Trades_GUI_Mode = "Window" ) {
			WinGetPos, xpos, ypos, , ,% "ahk_id " GuiTradesHandler
			IniWrite,% xpos,% iniFilePath,PROGRAM,X_POS
			IniWrite,% ypos,% iniFilePath,PROGRAM,Y_POS
		}
	}
}

Manage_Font_Resources(mode) {
	global ProgramValues, ProgramFonts

	fontsFolder := ProgramValues["Fonts_Folder"]

	Loop, Files, %fontsFolder%\*.*
	{
		if A_LoopFileExt in otf,otc,ttf,ttc
		{
			if ( mode="LOAD") {
				DllCall( "GDI32.DLL\AddFontResourceEx", Str, A_LoopFileFullPath,UInt,(FR_PRIVATE:=0x10), Int,0)
				fontTitle := FGP_Value(A_LoopFileFullPath, 21)	; 21 = Title
				ProgramFonts.Insert(A_LoopFileName, fontTitle)
			}
			else if ( mode="UNLOAD") {
				DllCall( "GDI32.DLL\RemoveFontResourceEx",Str, A_LoopFileFullPath,UInt,(FR_PRIVATE:=0x10),Int,0)
			}
		}
	}
}

Exit_Func(ExitReason, ExitCode) {
	Gui_Trades_Save_Position()
	Manage_Font_Resources("UNLOAD")

	if ExitReason not in Reload
		ExitApp
}

DoNothing:
return

;__TO_BE_ADDED__ Functions used by the unicode buttons.
SetUnicodeText(ByRef ptrUnicodeText,hWnd) {
/*	Original function author: derRaphael (nli)
 *	autohotkey.com/board/topic/28591-displaying-non-supported-characters-and-letters-in-gui/?p=183128
*/
   static WM_SETTEXT := 0x0C
   DllCall("SendMessageW", "UInt",hWnd, "UInt",WM_SETTEXT, "UInt",0, "Uint",&ptrUnicodeText)
}

#Include %A_ScriptDir%/Resources/AHK/BinaryEncodingDecoding.ahk