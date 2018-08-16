IsUpdateAvailable() {
	global PROGRAM
	iniFile := PROGRAM.INI_FILE

	useBeta := INI.Get(iniFile, "UPDATING", "UseBeta")
	INI.Set(iniFile, "UPDATING", "LastUpdateCheck", A_Now)

	recentRels := GitHubAPI_GetRecentReleases(PROGRAM.GITHUB_USER, PROGRAM.GITHUB_REPO)
	if !(recentRels)
		return
	latestRel := recentRels.1
	for index, value in recentRels {
		if (foundStableTag && foundBetaTag)
			Break

		isPreRelease := recentRels[index].prerelease
		if (isPreRelease && !foundBetaTag)
			latestBeta := recentRels[index], foundBetaTag := True
		else if (!isPreRelease && !foundStableTag)
			latestStable := recentRels[index], foundStableTag := True
	}
	stableTag := latestStable.tag_name, betaTag := latestBeta.tag_name
	stableSubVers := StrSplit(stableTag, "."), betaSubVers := StrSplit(betaTag, ".")
	if (useBeta) && (betaSubVers.1 = stableSubVers.1 && betaSubVers.2 = stableSubVers.2)
		isStableBetter := True

	INI.Set(iniFile, "UPDATING", "LatestStable", stableTag)
	INI.Set(iniFile, "UPDATING", "LatestBeta", betaTag)
	Declare_LocalSettings()

	updateRel := (useBeta && isStableBetter)?(latestStable)
		: (useBeta && !isStableBetter)?(latestBeta)
		: (latestStable)
	relTag := updateRel.tag_name, relDL := updateRel.assets.1.browser_download_url, relNotes := updateRel.body

	if (relTag && relDL) && (relTag != PROGRAM.VERSION) {
		Return updateRel
	}
	else if (relTag = PROGRAM.VERSION) {
		return False
	}
	else {
		SplashTextOn(PROGRAM.NAME " - Updating Error", "There was an issue when retrieving the latest release from GitHub API"
		.											"`nIf this keeps on happening, please try updating manually."
		.											"`nYou can find the GitHub repository link in the Settings menu.", 1, 1)
		return False
	}
}

UpdateCheck(checkType="normal", notifOrBox="notif") {
	global PROGRAM, SPACEBAR_WAIT
	iniFile := PROGRAM.INI_FILE

	autoupdate := INI.Get(iniFile, "UPDATING", "DownloadUpdatesAutomatically")
	lastUpdateCheck := INI.Get(iniFile, "UPDATING", "LastUpdateCheck")
	if (checkType="forced") ; Fake the last update check, so it's higher than set limit
		lastUpdateCheck := 1994042612310000

	timeDif := A_Now
	timeDif -= lastUpdateCheck, Minutes

	if FileExist(PROGRAM.UPDATER_FILENAME)
		FileDelete,% PROGRAM.UPDATER_FILENAME

	if !(timeDif > 5) ; Hasn't been longer than 5mins since last check, cancel to avoid spamming GitHub API
		Return

	updateRel := IsUpdateAvailable()
	if !(updateRel) {
		TrayNotifications.Show(PROGRAM.NAME, "You are up to date!")
		return
	}	

	updTag := updateRel.tag_name, updDL := updateRel.assets.1.browser_download_url, updNotes := updateRel.body
	global UPDATE_TAGNAME, UPDATE_DOWNLOAD, UPDATE_NOTES
	UPDATE_TAGNAME := updTag, UPDATE_DOWNLOAD := updDL, UPDATE_NOTES := updNotes

	if (checkType="on_start") && (autoupdate = "True") {
		DownloadAndRunUpdater()
		return
	}

	if (notifOrBox="box")
		ShowUpdatePrompt(updTag, updDL)
	else if (notifOrBox="notif")
		TrayNotifications.Show(updTag " is available!", "Left click on this notification to run the automatic download.`nRight click to dismiss.", {Is_Update:1, Fade_Timer:20000})
}

ShowUpdatePrompt(ver, dl) {
	global PROGRAM

	MsgBox, 4100,% PROGRAM.NAME " - Update prompt",% ""
	. "Current:" A_Tab A_Tab PROGRAM.VERSION
	. "`nAvailable: " A_Tab ver
	. "`n"
	. "`nWould you like to update now?"
	. "`nThe entire updating process is automated."
	IfMsgBox, Yes
	{
		DownloadAndRunUpdater(dl)
	}
}

DownloadAndRunUpdater(dl="") {
	global PROGRAM, UPDATE_DOWNLOAD

	dl := dl?dl : UPDATE_DOWNLOAD
	if !(dl) {
		MsgBox(4096, "", "Dowload URL empty, canceling! ")
		return
	}

	SplitPath, A_ScriptName, , , scriptExt
	if (scriptExt = "ahk") {
		MsgBox(4096+48+4, "", "The script was about to update but you are using the .ahk source. Currently, there is no way to update automatically. Sorry for the inconvenience."
			. "`n"	"Would you like to open the GitHub releases page?")
		IfMsgBox, Yes
			Run,% PROGRAM.LINK_GITHUB "/releases"
		return
	}

	success := Download(PROGRAM.LINK_UPDATER, PROGRAM.UPDATER_FILENAME)
	if (success)
		Run_Updater(dl)
	else
		MsgBox(4096, "", "Failed to download the updater!")
}

Run_Updater(downloadLink) {
	global PROGRAM
	iniFile := PROGRAM.Ini_File

	INI.Set(iniFile, "UPDATING", "LastUpdate", A_Now)
	Run,% PROGRAM.UPDATER_FILENAME 
	. " /Name=""" PROGRAM.NAME  """"
	. " /File_Name=""" A_ScriptDir "\" PROGRAM.NAME ".exe" """"
	. " /Local_Folder=""" PROGRAM.Local_Folder """"
	. " /Ini_File=""" PROGRAM.Ini_File """"
	. " /NewVersion_Link=""" downloadLink """"
	ExitApp
}
