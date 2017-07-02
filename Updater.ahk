#NoEnv
#Persistent
#SingleInstance Force
#Warn LocalSameAsGlobal
OnExit("Exit_Func")

DetectHiddenWindows, Off
FileEncoding, UTF-8
ListLines, Off
SetWorkingDir, %A_ScriptDir%

Menu,Tray,Tip,Updater
Menu,Tray,NoStandard
Menu,Tray,Add,Close,Exit_Func

Start_Script()
ExitApp
Return

Start_Script() {
/*
*/
	EnvGet, userprofile, userprofile
	global ProgramValues := {}

	Handle_CommandLine_Parameters()

	ProgramValues.Local_Folder_Old_1 		:= userprofile "\Documents\AutoHotKey\POE Trades Helper\"
	ProgramValues.Local_Folder_Old_2 		:= userprofile "\Documents\AutoHotKey\" ProgramValues.Name
	ProgramValues.Temporary_File			:= A_ScriptDir "\NewVersionTemp.exe"

	Close_Program_Instancies()

;	Deleting old POE Trades Helper folder is it exists
	if InStr(FileExist(ProgramValues.Local_Folder_Old_1), "D") {
		FileRemoveDir,% ProgramValues.Local_Folder_Old_1, 1
	}

;	Comparing userprofile\Documents and A_MyDocuments location. Move old location to new one.
	if InStr(FileExist(ProgramValues.Local_Folder_Old_2), "D") && (ProgramValues.Local_Folder_Old_2 != ProgramValues.Local_Folder) {
		FileMoveDir,% ProgramValues.Local_Folder_Old_2,% ProgramValues.Local_Folder, 2
	}

;	Downloading the new version.
	Download_New_Version()
}


Handle_CommandLine_Parameters() {
	global 0
	global ProgramValues

	Loop, %0% {
		param := %A_Index%
		if RegExMatch(param, "/Name=(.*)", found) {
			ProgramValues.Name := found1, found1 := ""
		}
		else if RegExMatch(param, "/File_Name=(.*)", found) {
			ProgramValues.File_Name := found1, found1 := ""
		}
		else if RegExMatch(param, "/Local_Folder=(.*)", found1) {
			ProgramValues.Local_Folder := found1, found1 := ""
		}
		else if RegExMatch(param, "/Ini_File=(.*)", found1) {
			ProgramValues.Ini_File := found1, found1 := ""
		}
		else if RegExMatch(param, "/NewVersion_Link=(.*)", found1) {
			ProgramValues.NewVersion_Link := found1, found1 := ""
		}
	}
}


Close_Program_Instancies() {
/*		Close running instances of the program.
		Delete the file, unless it's .ahk.
 */
 	global ProgramValues

	IniRead, programPID,% ProgramValues.Ini_File,PROGRAM,PID
	IniRead, fileName,% ProgramValues.Ini_File,PROGRAM,FileName

	executables := programPID "|" fileName "|POE Trades Helper.exe|POE-Trades-Helper.exe"
	Loop, Parse, executables, D|
	{
		Process, Close,% A_LoopField
		Process, WaitClose,% A_LoopField
		Sleep 1

		SplitPath, A_LoopField, fileExt, , fileExt
		if (fileExt != ".ahk")
			FileDelete,% A_LoopField
		Sleep 1
	}
}

Download_New_Version() {
/*		Download the new version. Rename. Run.
*/
	global ProgramValues
	UrlDownloadToFile,% programDL,% ProgramValues.File_Name
	if ( ErrorLevel = 1 ) {
		funcParams := {	 Width:350
						,Height:125
						,BorderColor:"White"
						,Background:"Blue"
						,Title:"Download timed out."
						,TitleColor:"White"
						,Text:"Please make sure your network is working correctly,`nor try downloading the new version manually."
						,TextColor:"White"
						,Condition:"Previous_Instance_Close"}
		GUI_Beautiful_Warning(funcParams)
	}
	Sleep 10
	FileSetAttrib, -H,% ProgramValues.File_Name
	IniWrite, 1,% ProgramValues.Ini_File,PROGRAM,Show_Changelogs
	Sleep 10
	Run, % ProgramValues.File_Name
}

GUI_Beautiful_Warning(params) {
	global ProgramValues

	guiWidth := params.Width
	guiHeight := params.Height
	guiBackground := params.Background
	borderSize := (params.Border)?(params.Border):(2)
	borderColor := params.BorderColor

	warnTitle := params.Title
	warnTitleColor := params.TitleColor
	warnText := params.Text
	warnTextColor := params.TextColor

	condition := params.Condition
	count := params.ConditionCount

	static WarnTextHandler

	Gui, BeautifulWarn:Destroy
	Gui, BeautifulWarn:New, +AlwaysOnTop +ToolWindow -Caption -Border +LabelGui_Beautiful_Warning_ hwndGuiBeautifulWarningHandler,% ProgramValues.Name
	Gui, BeautifulWarn:Default
	Gui, Margin, 0, 0
	Gui, Color,% guiBackground
	Gui, Font, S10 Bold, Consolas
	Gui, Add, Progress,% "x0" . " y0" . " h" borderSize . " w" guiWidth . " Background" borderColor ; Top
	Gui, Add, Text, xm ym+5 Center w%guiWidth% c%warnTitleColor% BackgroundTrans Section,% ProgramValues.Name
	if (warnTitle) {
		Gui, Add, Text, xs Center w%guiWidth% c%warnTitleColor% BackgroundTrans Section,% warnTitle
		Gui, Add, Progress,% "xs" . " y+5 h" borderSize . " w" guiWidth . " Background" borderColor " Section" ; Underline
		underlineExists := true
	}
	Gui, Add, Progress,% "x" guiWidth-borderSize . " y0" . " h" guiHeight . " w" borderSize . " Background" borderColor ; Right
	Gui, Add, Progress,% "x0" . " y" guiHeight-borderSize . " h" borderSize . " w" guiWidth . " Background" borderColor ; Bot
	Gui, Add, Progress,% "x0" . " y0" . " h" guiHeight . " w" borderSize . " Background" borderColor ; Left
	yOffset := (underlineExists)?(5):(20)
	Gui, Add, Text, xs ys+%yOffset% Center w%guiWidth% c%warnTextColor% BackgroundTrans hwndWarnTextHandler,% warnText
	Gui, Show, w%guiWidth% h%guiHeight%
	WinWait,% "ahk_id " GuiBeautifulWarningHandler
	WinWaitClose,% "ahk_id " GuiBeautifulWarningHandler
	Return

	GUI_Beautiful_Warning_Close:
	Return
	GUI_Beautiful_Warning_Escape:
	Return
}

Exit_Func(ExitReason, ExitCode) {
	if ExitReason not in Reload
		ExitApp
}