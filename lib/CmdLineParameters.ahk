Get_CmdLineParameters() {
	global 0
	
	Loop, %0% {
		param := ""
		param := RegExReplace(%A_Index%, "(.*)=(.*)", "$1=""$2""") ; Add quotes to parameters. In case any contain a space

		if (param)
			params .= A_Space . param
	}

	return params
}

Handle_CmdLineParameters() {
	global 0, PROGRAM, GAME, RUNTIME_PARAMETERS

	programName := PROGRAM.NAME

	Loop, %0% {
		param := ""
		param := RegExReplace(%A_Index%, "(.*)=(.*)", "$1=""$2""") ; Add quotes to parameters. In case any contain a space

		if RegExMatch(param, "O)/MyDocuments=(.*)", found) {
			RUNTIME_PARAMETERS["MyDocuments"] := found.1, found := ""
		}
		else if (param="/NoAdmin" || param="/SkipAdmin") {
			RUNTIME_PARAMETERS["SkipAdmin"] := True
		}
		else if (param="/NoReplace" || param="/NewInstance") {
			RUNTIME_PARAMETERS["NewInstance"] := True
		}
		else if RegExMatch(param, "O/GamePath=(.*)", found) || RegExMatch(param, "O/GameFolder=(.*)", found) {
			if FileExist(found.1 "\logs\Client.txt")
				RUNTIME_PARAMETERS["GameFolder"] := found.1, found := ""
			else
				Msgbox(4096+16, "", "Parameter invalid: Client.txt not found in logs subfolder.`n`nParam: " param "`nFolder: " found.1)
		}
		else if RegExMatch(param, "O)/Screen_DPI=(.*)", found)
			MsgBox(4096+48, "", "Parameter invalid: This parameter was removed due to it being unnecessary.`n`nParam: " param "`nFolder: " found.1)
	}
}