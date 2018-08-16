Load_DebugJSON() {
/*		Only works when using the ahk source
*/
	global DEBUG

	if (A_IsCompiled)
		Return

	FileRead, debugJSON,% A_ScriptDir "\Debug.json"
	parsed_debugJSON := JSON.Load(debugJSON)

	DEBUG.SETTINGS 		:= parsed_debugJSON.settings
	DEBUG.CHATLOGS 		:= parsed_debugJSON.chat_logs
}