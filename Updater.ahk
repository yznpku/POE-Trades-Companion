/*
	Changelog:
		v1.0: Initial release
		v1.0.1: Attempts at fixing the tool
		v1.1: Greatly enhanced the tool, updates should go smooth now
		v1.2: Added beta download
*/


#SingleInstance Force
SetWorkingDir, A_ScriptDir
EnvGet, userprofile, userprofile
global programName := "POE Trades Helper"
global iniFilePath := userprofile "\Documents\AutoHotKey\" programName "\Preferences.ini"
global newVersionPath := "poe_trades_helper_newversion.exe"
global programDL := "https://raw.githubusercontent.com/lemasato/POE-Trades-Helper/master/POE Trades Helper.exe"

;		Retrieving the current date and time, then separating into their own vars
FormatTime, currentDateTime,,dd/MM/yy-HH:mm:ss
currentDateTimeArray := Split_DateTime(currentDateTime)
currentDay := currentDateTimeArray[1], currentMonth := currentDateTimeArray[2], currentYear := currentDateTimeArray[3]
currentHour := currentDateTimeArray[4], currentMin := currentDateTimeArray[5], currentSec := currentDateTimeArray[6]

;		Same thing, but for the last update attempt
IniRead,previousDateTime,% iniFilePath,PROGRAM,LastUpdate
previousDateTime := Split_DateTime(previousDateTime)
previousDay := previousDateTime[1], previousMonth := previousDateTime[2], previousYear := previousDateTime[3]
previousHour := previousDateTime[4], previousMin := previousDateTime[5], previousSec := previousDateTime[6]

;		We can now write the current date and time to the ini
IniWrite,% currentDateTime,% iniFilePath,PROGRAM,LastUpdate

;		We make sure it's not stuck in a loop, if auto-update is activated
IniRead,autoUpdate,% iniFilePath,PROGRAM,AutoUpdate
if ( autoUpdate = 1 )
	Compare_Both_DateTime(autoUpdate, currentDay, currentMonth, currentYear, currentHour, currentMin, currentSec, previousDay, previousMonth, previousYear, previousHour, previousMin, previousSec)

;		Random comment line to make things look pretty
Close_Program_Instancies()
Download_New_Version()
ExitApp

;======================================
;										FUNCTIONS
;======================================

Split_DateTime(dateAndTime) {
;			Split the date and time into their own variables
	Loop, Parse, dateAndTime
	{
		if ( A_Index = 1 || A_Index = 2 )
			day := day A_LoopField
		if ( A_Index = 4 || A_Index = 5 )
			month := month A_LoopField
		if ( A_Index = 7 || A_Index = 8 )
			year := year A_LoopField
		if ( A_Index = 10 || A_Index = 11 )
			hour := hour A_LoopField
		if ( A_Index = 13 || A_Index = 14 )
			min := min A_LoopField
		if ( A_Index = 16 || A_Index = 17 )
			sec := sec A_LoopField
	}
	return [day, month, year, hour, min, sec]
}

Compare_Both_DateTime(auto, cDay, cMonth, cYear, cHour, cMin, cSec, pDay, pMonth, pYear, pHour, pMin, pSec) {
;		Check if there was an update attempt in the last minute
;		If so, make sure to disable the auto update as it was probably stuck in an update loop
	if ( auto = 1 ) && ( cYear = pYear ) && ( cMonth = pMonth ) && ( cDay = pDay ) && ( cHour = pHour ) && ( cMin = pMin ) {
		IniWrite,0,% iniFilePath,SETTINGS,AutoUpdate
		issue := "The program was stuck updating in a loop."
		solution := "Auto-update has been disabled. Please update manually."
		Create_Warning_Gui(issue, solution, "Loop")
		ExitApp
	}
}

Close_Program_Instancies() {
;			Retrieve the PID and file name stored in the ini file
;			Close all possible instancie of the program
;			Also delete all possible file name
	IniRead, programPID,% iniFilePath,PROGRAM,PID
	IniRead, fileName,% iniFilePath,PROGRAM,FileName
	Loop {
		if ( programPID != "ERROR" ) && ( programPID != "" )
			Process, Close, %programPID%
		Process, Close, %fileName%
		Process, Close, POE Trades Helper.exe
		sleep 100
		FileDelete,% fileName
		FileDelete,% "POE Trades Helper.exe"
		sleep 100
		if !( FileExist(fileName) ) && !( FileExist("POE Trades Helper.exe") )
			break
	}
}

Download_New_Version() {
;			Download the new version, rename and runs it
;			Warns the user if it couldn't be retrieved
	UrlDownloadToFile,% programDL,% newVersionPath
		if ( ErrorLevel = 1 ) {
			problem := "The program timed out while trying to retrieve the new version."
			solution := "Auto-update was disabled. Please make sure your network is working correctly.`nOr try downloading the new version manually."
			Create_Warning_Gui(issue, solution, "TimedOut")
			ExitApp
		}
	sleep 1000
	FileMove,% newVersionPath,% "POE Trades Helper.exe",1
	sleep 1000
	Run, % "POE Trades Helper.exe"
}

Create_Warning_Gui(issue, solution, code) {
;			Create a gui to warn the user about what happened and how to fix it
;			Places the element correctly based on the code (incase of linefeed)
	if ( code = "Loop" )
		y1 := 10, y2 := 25, y3 := 50, y4 := 65, y5 := 80, y6 := 110
	else if ( code = "TimedOut" )
		y1 := 10, y2 := 25, y3 := 50, y4 := 65, y5 := 95, y6 := 125
	Gui, Warning:Destroy
	Gui, Warning:New, +AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox +OwnDialogs +HwndWarningGuiHwnd,% "WARNING!"
	Gui, Warning:Default
	Gui, Add, text, x10 y%y1% cRed,Issue : 
	Gui, Add, text, x25 y%y2%,%issue%
	Gui, Add, text, x10 y%y3% cGreen,Solution:
	Gui, Add, text, x25 y%y4%,%solution%
	Gui, Add, text, x25 y%y5% cblue gDownload_Link,Click here to open the download page
	Gui, Add, text, x150 y%y6% cgreen gThread_Link,Thread
	Gui, Add, text, x250 y%y6%, / 
	Gui, Add, text, x262 y%y6% cgreen gRepo_Link,Github
	Gui, Show
	WinWait, ahk_id %WarningGuiHwnd%
	WinWaitClose, ahk_id %WarningGuiHwnd%
}

;======================================
;											LABELS
;======================================

Download_Link:
	Run, % programDL
return
Thread_Link:
	Run, "https://github.com/lemasato/POE-Trades-Helper/releases"
return
Repo_Link:
	Run, "https://github.com/lemasato/POE-Trades-Helper/"
return