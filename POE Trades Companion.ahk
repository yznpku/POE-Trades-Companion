/*
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*					POE Trades Companion																														*
*					See all the information about the trade request upon receiving a poe.trade whisper															*
*																																								*
*					https://github.com/lemasato/POE-Trades-Companion/																							*
*					https://www.reddit.com/r/pathofexile/comments/57oo3h/																						*
*					https://www.pathofexile.com/forum/view-thread/1755148/																						*
*																																								*	
*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*
*/

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

; #Warn LocalSameAsGlobal, StdOut
; #ErrorStdOut
#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoEnv

OnExit("Exit")

DetectHiddenWindows, Off
FileEncoding, UTF-8 ; Cyrilic characters
SetWinDelay, 0
ListLines, Off

; Basic tray menu
if ( !A_IsCompiled && FileExist(A_ScriptDir "\resources\icon.ico") )
	Menu, Tray, Icon, %A_ScriptDir%\resources\icon.ico
Menu,Tray,Tip,POE Trades Companion
Menu,Tray,NoStandard
Menu,Tray,Add,Tool is loading..., DoNothing
Menu,Tray,Disable,Tool is loading...
Menu,Tray,Add,GitHub,Tray_GitHub
Menu,Tray,Add
Menu,Tray,Add,Reload,Tray_Reload
Menu,Tray,Add,Close,Tray_Exit
Menu,Tray,Icon

; try {
	Start_Script()
; }
; catch e {
; 	MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
;         . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
; }
; msgbox
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#IfWinActive ahk_group POEGame
^+LButton::StackClick()

#IfWinActive ahk_group GUITradesGroup
^SC00F::GUI_Trades.SelectNextTab() ; Ctrl Tab
^+SC00F::GUI_Trades.SelectPreviousTab() ; Ctrl Shift Tab 
^SC002::GUI_Trades.SetActiveTab(1) ; 1
^SC003::GUI_Trades.SetActiveTab(2) ; 2
^SC004::GUI_Trades.SetActiveTab(3) ; 3
^SC005::GUI_Trades.SetActiveTab(4) ; 4
^SC006::GUI_Trades.SetActiveTab(5) ; 5
^SC007::GUI_Trades.SetActiveTab(6) ; 6
^SC008::GUI_Trades.SetActiveTab(7) ; 7
^SC009::GUI_Trades.SetActiveTab(8) ; 8
^SC00A::GUI_Trades.SetActiveTab(9) ; 9
^WheelDown::GUI_Trades.SelectNextTab() ; Ctrl WheelDown
^^WheelUp::GUI_Trades.SelectPreviousTab() ; Ctrl WheelUp

#IfWinActive

~*Space::
	global PROGRAM, AUTOWHISPER_CANCEL, AUTOWHISPER_WAITKEYUP
	if (SPACEBAR_WAIT) {
		SplashTextOff()
	}
	else if (AUTOWHISPER_WAITKEYUP) {
		AUTOWHISPER_CANCEL := True
		ShowToolTip(PROGRAM.NAME "`nEasy whisper cancelled.")
	}
Return

GUI_Trades_RefreshIgnoreList:
	GUI_Trades.RefreshIgnoreList()
return

RefreshIgnoreList:
GUI_Trades.RefreshIgnoreList()
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Start_Script() {

	global DEBUG 							:= {} ; Debug values
	global PROGRAM 							:= {} ; Specific to the program's informations
	global GAME								:= {} ; Specific to the game config files
	global RUNTIME_PARAMETERS 				:= {}

	global Stats_TradeCurrencyNames 		:= {} ; Abridged currency names from poe.trade
	global Stats_RealCurrencyNames 			:= {} ; All currency full names

	global LEAGUES 							:= [] ; Trading leagues

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Handle_CmdLineParameters() 		; RUNTIME_PARAMETERS

	MyDocuments 					:= (RUNTIME_PARAMETERS.MyDocuments)?(RUNTIME_PARAMETERS.MyDocuments):(A_MyDocuments)

	; Set global - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.NAME					:= "POE Trades Companion"
	PROGRAM.VERSION 				:= "1.13.BETA_7"
	PROGRAM.IS_BETA					:= IsContaining(PROGRAM.VERSION, "beta")?"True":"False"

	PROGRAM.GITHUB_USER 			:= "lemasato"
	PROGRAM.GITHUB_REPO 			:= "POE-Trades-Companion"
	PROGRAM.GUTHUB_BRANCH			:= "master"

	PROGRAM.MAIN_FOLDER 			:= MyDocuments "\lemasato\" PROGRAM.NAME
	PROGRAM.SFX_FOLDER 				:= PROGRAM.MAIN_FOLDER "\SFX"
	PROGRAM.LOGS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Logs"
	PROGRAM.SKINS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Skins"
	PROGRAM.FONTS_FOLDER 			:= PROGRAM.MAIN_FOLDER "\Fonts"
	PROGRAM.DATA_FOLDER				:= PROGRAM.MAIN_FOLDER "\Data"
	PROGRAM.IMAGES_FOLDER			:= PROGRAM.MAIN_FOLDER "\Images"
	PROGRAM.ICONS_FOLDER			:= PROGRAM.MAIN_FOLDER "\Icons"

	prefsFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Preferences.ini"):("Preferences.ini")
	backupFileName 					:= (RUNTIME_PARAMETERS.InstanceName)?(RUNTIME_PARAMETERS.InstanceName "_Trades_Backup.ini"):("Trades_Backup.ini")
	PROGRAM.FONTS_SETTINGS_FILE		:= PROGRAM.FONTS_FOLDER "\Settings.ini"
	PROGRAM.INI_FILE 				:= PROGRAM.MAIN_FOLDER "\" prefsFileName
	PROGRAM.LOGS_FILE 				:= PROGRAM.LOGS_FOLDER "\" A_YYYY "-" A_MM "-" A_DD " " A_Hour "h" A_Min "m" A_Sec "s.txt"
	PROGRAM.CHANGELOG_FILE 			:= PROGRAM.MAIN_FOLDER "\changelog.txt"
	PROGRAM.CHANGELOG_FILE_BETA 	:= PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	PROGRAM.TRADES_HISTORY_FILE 	:= PROGRAM.MAIN_FOLDER "\Trades_History.ini" 
	PROGRAM.TRADES_BACKUP_FILE		:= PROGRAM.MAIN_FOLDER "\" backupFileName

	PROGRAM.NEW_FILENAME			:= PROGRAM.MAIN_FOLDER "\POE-TC-NewVersion.exe"
	PROGRAM.UPDATER_FILENAME 		:= PROGRAM.MAIN_FOLDER "\POE-TC-Updater.exe"
	PROGRAM.LINK_UPDATER 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/Updater_v2.exe"
	PROGRAM.LINK_CHANGELOG 			:= "https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/changelog.txt"

	PROGRAM.CURL_EXECUTABLE			:= PROGRAM.MAIN_FOLDER "\curl.exe"

	PROGRAM.LINK_REDDIT 			:= "https://www.reddit.com/user/lemasato/submitted/"
	PROGRAM.LINK_GGG 				:= "https://www.pathofexile.com/forum/view-thread/1755148/"
	PROGRAM.LINK_GITHUB 			:= "https://github.com/lemasato/POE-Trades-Companion"
	PROGRAM.LINK_SUPPORT 			:= "https://www.paypal.me/masato/"
	PROGRAM.LINK_DISCORD 			:= "https://discord.gg/UMxqtfC"

	GAME.MAIN_FOLDER 				:= MyDocuments "\my games\Path of Exile"
	GAME.INI_FILE 					:= GAME.MAIN_FOLDER "\production_Config.ini"
	GAME.INI_FILE_COPY 		 		:= PROGRAM.MAIN_FOLDER "\production_Config.ini"
	GAME.EXECUTABLES 				:= "PathOfExile.exe,PathOfExile_x64.exe,PathOfExileSteam.exe,PathOfExile_x64Steam.exe"
	GAME.CHALLENGE_LEAGUE 			:= "Incursion,Delve"

	PROGRAM.SETTINGS.SUPPORT_MESSAGE 	:= "@%buyerName% " PROGRAM.NAME ": view-thread/1755148"

	PROGRAM.PID 					:= DllCall("GetCurrentProcessId")

	SetWorkingDir,% PROGRAM.MAIN_FOLDER

	; Auto admin reload - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	if (!A_IsAdmin && !RUNTIME_PARAMETERS.SkipAdmin) { ; TO_DO re-enable, also prob dont need warn
		; GUI_SimpleWarn.Show("", "Reloading to request admin privilieges in 3...`nClick on this window to reload now.", "Green", "White", {CountDown:True, CountDown_Timer:1000, CountDown_Count:3, WaitClose:1, CloseOnClick:True})
		ReloadWithParams(" /MyDocuments=""" MyDocuments """", getCurrentParams:=True, asAdmin:=True)
	}

	; Game executables groups - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	global POEGameArr := ["PathOfExile.exe", "PathOfExile_x64.exe", "PathOfExileSteam.exe", "PathOfExile_x64Steam.exe"]

	global POEGameList := ""
	for nothing, executable in POEGameArr {
		GroupAdd, POEGameGroup, ahk_exe %executable%
		POEGameList .= executable ","
	}
	StringTrimRight, POEGameList, POEGameList, 1

	; Create local directories - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	directories := PROGRAM.MAIN_FOLDER "`n" PROGRAM.SFX_FOLDER "`n" PROGRAM.LOGS_FOLDER "`n" PROGRAM.SKINS_FOLDER
	. "`n" PROGRAM.FONTS_FOLDER "`n" PROGRAM.IMAGES_FOLDER "`n" PROGRAM.DATA_FOLDER "`n" PROGRAM.ICONS_FOLDER

	Loop, Parse, directories, `n, `r
	{
		if (!InStr(FileExist(A_LoopField), "D")) {
			AppendtoLogs("Local directory non-existent. Creating: """ A_LoopField """")
			FileCreateDir, % A_LoopField
			if (ErrorLevel && A_LastError) {
				AppendtoLogs("Failed to create local directory. System Error Code: " A_LastError ". Path: """ A_LoopField """")
			}
		}
	}

	; Currency names for stats gui - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	PROGRAM.DATA := {}
	FileRead, allCurrency,% PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	Loop, Parse, allCurrency, `n, `r
	{
		if (A_LoopField)
			currencyList .= A_LoopField ","
	}
	StringTrimRight, currencyList, currencyList, 1 ; Remove last comma
	PROGRAM.DATA.CURRENCY_LIST := currencyList

	PROGRAM["DATA"]["POETRADE_CURRENCY_DATA"] := PoeTrade_GetCurrencyData()

	; PoeTrade_GenerateCurrencyData() ; Disabled by default. Used to re-generate currency data json/txt

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	Load_DebugJSON()

	if (!RUNTIME_PARAMETERS.NewInstance)
		Close_PreviousInstance()
	TrayRefresh()

	if !(DEBUG.settings.skip_assets_extracting)
		AssetsExtract()

	GDIP_Startup()

	; Fonts related
	LoadFonts() 

	; Local settings
	Set_LocalSettings()
	Update_LocalSettings()
	localSettings := Get_LocalSettings()
	Declare_LocalSettings(localSettings)

	; Game settings
	gameSettings := Get_GameSettings()
	Declare_GameSettings(gameSettings)

	Declare_SkinAssetsAndSettings()

	; Logs files
	Create_LogsFile()
	Delete_OldLogsFile()

	; Update checking
	if !(DEBUG.settings.skip_update_check) {
		periodicUpdChk := PROGRAM.SETTINGS.UPDATE.CheckForUpdatePeriodically
		updChkTimer := (periodicUpdChk="OnStartOnly")?(0)
			: (periodicUpdChk="OnStartAndEveryFiveHours")?(18000000)
			: (periodicUpdChk="OnStartAndEveryDay")?(86400000)
		
		if (updChkTimer)
			SetTimer, UpdateCheck, %updChkTimer%

		if (A_IsCompiled)
			UpdateCheck(checktype:="on_start")
		else
			UpdateCheck(checkType:="on_start", "box")
	}
	else if (DEBUG.settings.force_update_check) {
		UpdateCheck(checkType:="forced")
	}

	Get_TradingLeagues() ; Getting leagues

	TrayMenu()
	EnableHotkeys()

	ImageButton_TestDelay() ;
	Gui_Trades.Create()
	GUI_Trades.LoadBackup()

	; Parse debug msgs
	if (DEBUG.settings.use_chat_logs) {
		Loop % DEBUG.chatlogs.MaxIndex()
			Parse_GameLogs(DEBUG.chatlogs[A_Index])
	}
	Monitor_GameLogs()

	global GuiSettings
	if !WinExist("ahk_id " GuiSettings.Handle)
		Gui_Settings.Create()
	if (DEBUG.settings.open_settings_gui) {
		Gui_Settings.Show()
	}

	if (DEBUG.settings.open_mystats_gui) {
		GUI_MyStats.Create()
		GUI_MyStats.Show()
	}

	if (PROGRAM.SETTINGS.PROGRAM.Show_Changelogs = True) 
	|| (PROGRAM.SETTINGS.GENERAL.ShowChangelog = "True") {
		INI.Remove(PROGRAM.INI_FILE, "PROGRAM")
		INI.Set(PROGRAM.INI_FILE, "GENERAL", "ShowChangelog", "False")
		PROGRAM.SETTINGS.PROGRAM.Show_Changelogs := ""
		PROGRAM.SETTINGS.GENERAL.ShowChangelog := "False"
		GUI_Settings.Show("Misc Updating")
	}
	
	ShellMessage_Enable()
	OnClipboardChange("OnClipboardChange_Func")
	SetTimer, GUI_Trades_RefreshIgnoreList, 60000 ; One min

	TrayNotifications.Show(PROGRAM.Name, "Right click on the tray icons to access settings.")	
}

DoNothing:
Return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Include %A_ScriptDir%\lib\
#Include Class_GUI_SimpleWarn.ahk
#Include Class_GUI.ahk
#Include Class_GUI_BetaTasks.ahk
#Include Class_Gui_Trades.ahk
#Include Class_Gui_Settings.ahk
#Include Class_Gui_ChooseInstance.ahk
#Include Class_Gui_MyStats.ahk
#Include Class_Gui_ItemGrid.ahk
#Include WM_Messages.ahk

#Include Game.ahk
#Include Logs.ahk
#Include TrayMenu.ahk
#Include AssetsExtract.ahk
#Include FileInstall.ahk
#Include ManageFonts.ahk
#Include Misc.ahk
#Include CmdLineParameters.ahk
#Include Debug.ahk
#Include EasyFuncs.ahk
#Include Local_File.ahk
#Include Game_File.ahk
#Include WindowsSettings.ahk
#Include StackClick.ahk

#Include Class_INI.ahk
#Include TrayRefresh.ahk
#Include Exit.ahk
#Include Reload.ahk
#Include Hotkeys.ahk
#Include PoeTrade.ahk

#Include Updating.ahk
#Include GitHubAPI.ahk
#Include SplashText.ahk
#Include ShowToolTip.ahk
#Include TrayNotifications.ahk
#Include OnClipboardChange.ahk

#Include %A_ScriptDir%\lib\third-party\
#Include PushBullet.ahk

#Include AddToolTip.ahk
#Include Clip.ahk
#Include Class_ImageButton.ahk
#Include ChooseColor.ahk
#Include cURL.ahk
#Include Download.ahk
#Include FGP.ahk
#Include JSON.ahk
#Include LV_SetSelColors.ahk
#Include SetEditCueBanner.ahk
#Include StringtoHex.ahk
#Include StdOutStream.ahk
#Include TilePicture.ahk
#Include GDIP.ahk
#Include Extract2Folder.ahk

if (A_IsCompiled) {
	#Include %A_ScriptDir%/FileInstall_Cmds.ahk
	Return
}
