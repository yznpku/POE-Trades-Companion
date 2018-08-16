Get_ActiveTradingLeagues() {
/*		Retrieves leagues from the API
		Parse them, to keep only non-solo or non-ssf leagues
*/
	global PROGRAM, GAME
	static timeOut

	apiLink 			:= "http://api.pathofexile.com/leagues?type=main&compact=1"
	excludedWords 		:= "SSF,Solo"
	activeLeaguesList	:= "Standard,Hardcore,Beta Standard,Beta Hardcore,Harbinger,Hardcore Harbinger"
	tradingLeagues := []
	Loop, Parse, activeLeaguesList,% ","
		tradingLeagues.Push(A_LoopField) ; In case api cannot be reached


	attempts++
	timeOut := (attempts = 1)?(10000) ; 10s
			   :(attempts = 2)?(30000) ; 30s
			   :(60000) ; 60s
	nextAttempt := (IsBetween(attempts, 1, 2))?(300000) ; 5mins
				  :(IsBetween(attempts, 3, 4))?(600000) ; 10mins
				  :(1800000)
	if (attempts > 1) {
		TrayNotifications.Show(PROGRAM.Name, "Now retrying to retrieve leagues from API...")
	}
	Try {
;		Retrieve from online API
		WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		WinHttpReq.SetTimeouts(timeOut, timeOut, timeOut, timeOut)
		WinHttpReq.Open("GET", apiLink, true) ; Using true above and WaitForResponse allows the script to r'emain responsive.
		WinHttpReq.Send()
		WinHttpReq.WaitForResponse(10) ; 10 seconds
		leaguesJSON := WinHttpReq.ResponseText
	}
	Catch e { ; Cannot reach. Use internal leagues instead.
		Set_Format("Float", "0")

		AppendtoLogs("Failed to reach Leagues API. Obj.Message: """ WinHttpReq.Message """")
		TrayNotifications.Show(PROGRAM.Name, "Failed to reach the Leagues API."
		. "`n" 								"Whispers from temporary leagues may fail to appear correclty."
		. "`n`n"							"Retrying in " (nextAttempt/1000)/60 "minutes...", {Fade_Timer:10000})
		SetTimer,% A_ThisFunc, -%nextAttempt%

		Set_Format()

		Trading_Leagues := tradingLeagues
		Return
	}

	if (attempts > 1) {
		AppendtoLogs("Successfully reached Leagues API on attempt " attempts})
		TrayNotifications.Show(PROGRAM.Name, "Successfully retrieved leagues from API on attempt " attempts, {Fade_Timer:5000})
		attempts := 0
	}

;	Parse the leagues (JSON)
	parsedLeagues := JSON.Load(leaguesJSON)
	Loop % parsedLeagues.MaxIndex() {
		arrID 		:= parsedLeagues[A_Index]
		leagueName 	:= arrID.ID
		if leagueName not in %activeLeagues%
		{
 			activeLeagues .= "," leagueName
		}
	}

;	Remove SSF & Solo leagues
	tradingLeagues := []
	Loop, Parse, activeLeagues,% "D," 
	{
		if A_LoopField not contains %excludedWords%
		{
			tradingLeagues.Push(A_LoopField)
		}
	}

	Return tradingLeagues
}