﻿if (!A_IsCompiled && A_ScriptName = "FileInstall_Cmds.ahk") {
	#Include %A_ScriptDir%/lib/Logs.ahk
	#Include %A_ScriptDir%/lib/WindowsSettings.ahk
	#Include %A_ScriptDir%/lib/third-party/Get_ResourceSize.ahk

	if (!PROGRAM)
		PROGRAM := {}

	Loop, %0% {
		paramAE := %A_Index%
		if RegExMatch(paramAE, "O)/(.*)=(.*)", foundAE)
			PROGRAM[foundAE.1] := foundAE.2
	}

	FileInstall_Cmds()
}
; --------------------------------

FileInstall_Cmds() {
global PROGRAM


if !(PROGRAM.MAIN_FOLDER) {
	Msgbox You cannot run this file manually!
ExitApp
}

if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("lib\third-party\curl.exe")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
else {
	FileGetSize, sourceFileSize, lib\third-party\curl.exe
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\curl.exe"
}
if (sourceFileSize != destFileSize)
	FileInstall, lib\third-party\curl.exe, % PROGRAM.MAIN_FOLDER "\curl.exe", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: lib\third-party\curl.exe"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\curl.exe"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("Wiki.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\Wiki.url"
}
else {
	FileGetSize, sourceFileSize, Wiki.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\Wiki.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, Wiki.url, % PROGRAM.MAIN_FOLDER "\Wiki.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: Wiki.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\Wiki.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: Wiki.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\Wiki.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("GitHub.url")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
else {
	FileGetSize, sourceFileSize, GitHub.url
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\GitHub.url"
}
if (sourceFileSize != destFileSize)
	FileInstall, GitHub.url, % PROGRAM.MAIN_FOLDER "\GitHub.url", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: GitHub.url"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\GitHub.url"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\CurrencyNames.txt")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
}
else {
	FileGetSize, sourceFileSize, data\CurrencyNames.txt
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\CurrencyNames.txt, % PROGRAM.DATA_FOLDER "\CurrencyNames.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\CurrencyNames.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\CurrencyNames.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\CurrencyNames.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\mapsData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\mapsData.json"
}
else {
	FileGetSize, sourceFileSize, data\mapsData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\mapsData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\mapsData.json, % PROGRAM.DATA_FOLDER "\mapsData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\mapsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\mapsData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\mapsData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\mapsData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\poeDotComCurrencyData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
}
else {
	FileGetSize, sourceFileSize, data\poeDotComCurrencyData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\poeDotComCurrencyData.json, % PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\poeDotComCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\poeDotComCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeDotComCurrencyData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\poeTradeCurrencyData.json")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
}
else {
	FileGetSize, sourceFileSize, data\poeTradeCurrencyData.json
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\poeTradeCurrencyData.json, % PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\poeTradeCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\poeTradeCurrencyData.json"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.DATA_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.DATA_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("data\UniqueMaps.txt")
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
}
else {
	FileGetSize, sourceFileSize, data\UniqueMaps.txt
	FileGetSize, destFileSize, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, data\UniqueMaps.txt, % PROGRAM.DATA_FOLDER "\UniqueMaps.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: data\UniqueMaps.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: data\UniqueMaps.txt"
	.	"`nDest: " PROGRAM.DATA_FOLDER "\UniqueMaps.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog.txt, % PROGRAM.MAIN_FOLDER "\changelog.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\changelog_beta.txt")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
}
else {
	FileGetSize, sourceFileSize, resources\changelog_beta.txt
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\changelog_beta.txt, % PROGRAM.MAIN_FOLDER "\changelog_beta.txt", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\changelog_beta.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\changelog_beta.txt"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\changelog_beta.txt"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.MAIN_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.MAIN_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icon.ico")
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icon.ico
	FileGetSize, destFileSize, % PROGRAM.MAIN_FOLDER "\icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icon.ico, % PROGRAM.MAIN_FOLDER "\icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icon.ico"
	.	"`nDest: " PROGRAM.MAIN_FOLDER "\icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Consolas.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Consolas.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Consolas.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Consolas.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Consolas.ttf, % PROGRAM.FONTS_FOLDER "\Consolas.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Consolas.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Consolas.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Consolas.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Consolas.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Fontin-Regular.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Fontin-Regular.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Fontin-Regular.ttf, % PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-Regular.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-Regular.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-Regular.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Fontin-SmallCaps.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Fontin-SmallCaps.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Fontin-SmallCaps.ttf, % PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-SmallCaps.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Fontin-SmallCaps.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Fontin-SmallCaps.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Segoe UI.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Segoe UI.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Segoe UI.ttf, % PROGRAM.FONTS_FOLDER "\Segoe UI.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Segoe UI.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Segoe UI.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\Settings.ini")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Settings.ini"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\Settings.ini
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\Settings.ini"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\Settings.ini, % PROGRAM.FONTS_FOLDER "\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\Settings.ini"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Settings.ini"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\Settings.ini"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\Settings.ini"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.FONTS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.FONTS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\fonts\TC_Symbols.ttf")
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
}
else {
	FileGetSize, sourceFileSize, resources\fonts\TC_Symbols.ttf
	FileGetSize, destFileSize, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\fonts\TC_Symbols.ttf, % PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\fonts\TC_Symbols.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\fonts\TC_Symbols.ttf"
	.	"`nDest: " PROGRAM.FONTS_FOLDER "\TC_Symbols.ttf"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\chart.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\chart.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\chart.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\chart.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\chart.ico, % PROGRAM.ICONS_FOLDER "\chart.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\chart.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\chart.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\chart.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\chart.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\gear.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\gear.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\gear.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\gear.ico, % PROGRAM.ICONS_FOLDER "\gear.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\gear.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\gear.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\POE.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\POE.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\POE.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\POE.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\POE.ico, % PROGRAM.ICONS_FOLDER "\POE.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\POE.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\POE.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\POE.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\POE.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\qmark.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\qmark.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\qmark.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\qmark.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\qmark.ico, % PROGRAM.ICONS_FOLDER "\qmark.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\qmark.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\qmark.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\qmark.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\qmark.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\refresh.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\refresh.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\refresh.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\refresh.ico, % PROGRAM.ICONS_FOLDER "\refresh.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\refresh.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\refresh.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.ICONS_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.ICONS_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\icons\x.ico")
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
else {
	FileGetSize, sourceFileSize, resources\icons\x.ico
	FileGetSize, destFileSize, % PROGRAM.ICONS_FOLDER "\x.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\icons\x.ico, % PROGRAM.ICONS_FOLDER "\x.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\icons\x.ico"
	.	"`nDest: " PROGRAM.ICONS_FOLDER "\x.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord.png, % PROGRAM.IMAGES_FOLDER "\Discord.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord_big.png, % PROGRAM.IMAGES_FOLDER "\Discord_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Discord_big_forums.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Discord_big_forums.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Discord_big_forums.png, % PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Discord_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Discord_big_forums.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\DonatePaypal.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\DonatePaypal.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\DonatePaypal.png, % PROGRAM.IMAGES_FOLDER "\DonatePaypal.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\DonatePaypal.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\DonatePaypal.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub.png, % PROGRAM.IMAGES_FOLDER "\GitHub.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub_big.png, % PROGRAM.IMAGES_FOLDER "\GitHub_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\GitHub_big_forums.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\GitHub_big_forums.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\GitHub_big_forums.png, % PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\GitHub_big_forums.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\GitHub_big_forums.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\POE.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\POE.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\POE.png, % PROGRAM.IMAGES_FOLDER "\POE.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\POE.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\POE.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\POE_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\POE_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\POE_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\POE_big.png, % PROGRAM.IMAGES_FOLDER "\POE_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\POE_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\POE_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\POE_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Reddit.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Reddit.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Reddit.png, % PROGRAM.IMAGES_FOLDER "\Reddit.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.IMAGES_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.IMAGES_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\imgs\Reddit_big.png")
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
}
else {
	FileGetSize, sourceFileSize, resources\imgs\Reddit_big.png
	FileGetSize, destFileSize, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\imgs\Reddit_big.png, % PROGRAM.IMAGES_FOLDER "\Reddit_big.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\imgs\Reddit_big.png"
	.	"`nDest: " PROGRAM.IMAGES_FOLDER "\Reddit_big.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\MM_Tatl_Gleam.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\MM_Tatl_Gleam.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\MM_Tatl_Gleam.wav, % PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Gleam.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Gleam.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Gleam.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\MM_Tatl_Hey.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\MM_Tatl_Hey.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\MM_Tatl_Hey.wav, % PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Hey.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\MM_Tatl_Hey.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\MM_Tatl_Hey.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Notif_1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Notif_1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Notif_1.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Notif_2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Notif_2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Notif_2.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Notif_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Notif_2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_1.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_2.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\Rhodesmas_Up_3.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\Rhodesmas_Up_3.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\Rhodesmas_Up_3.wav, % PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\Rhodesmas_Up_3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\Rhodesmas_Up_3.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\WW_MainMenu_CopyErase_Start.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\WW_MainMenu_CopyErase_Start.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\WW_MainMenu_CopyErase_Start.wav, % PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_CopyErase_Start.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_CopyErase_Start.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_CopyErase_Start.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\WW_MainMenu_Letter.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\WW_MainMenu_Letter.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\WW_MainMenu_Letter.wav, % PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_Letter.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\WW_MainMenu_Letter.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\WW_MainMenu_Letter.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate1.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate1.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate1.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate1.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate1.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate2.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate2.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate2.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate2.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate2.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate3.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate3.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate3.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate3.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate3.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SFX_FOLDER ""), "D")
	FileCreateDir,% PROGRAM.SFX_FOLDER ""

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\sfx\ZSS_Calibrate4.wav")
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
}
else {
	FileGetSize, sourceFileSize, resources\sfx\ZSS_Calibrate4.wav
	FileGetSize, destFileSize, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\sfx\ZSS_Calibrate4.wav, % PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate4.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\sfx\ZSS_Calibrate4.wav"
	.	"`nDest: " PROGRAM.SFX_FOLDER "\ZSS_Calibrate4.wav"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

FileInstall, resources\skins\Dark Blue\Assets.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Background.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonOneThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonOneThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonOneThird.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonOneThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonOneThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonOneThirdHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonOneThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonOneThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonOneThirdPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonOneThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonSpecial.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecial.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonSpecial.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecial.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonSpecial.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecial.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonSpecial.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecial.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonSpecial.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecial.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonSpecialHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonSpecialHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonSpecialHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonSpecialHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonSpecialHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonSpecialPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonSpecialPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonSpecialPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonSpecialPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonSpecialPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonSpecialPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonThreeThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonThreeThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonThreeThird.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonThreeThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonThreeThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonThreeThirdHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonThreeThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonThreeThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonThreeThirdPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTwoThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTwoThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTwoThird.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTwoThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTwoThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTwoThirdHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\ButtonTwoThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\ButtonTwoThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\ButtonTwoThirdPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\CloseTab.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Header.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Icon.ico, % PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Maximize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Minimize.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\Preview.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

FileInstall, resources\skins\Dark Blue\Settings.ini, % PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabsUnderline.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabsUnderline.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabsUnderline.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabsUnderline.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Dark Blue"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Dark Blue"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Dark Blue\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Dark Blue\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Dark Blue\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Dark Blue\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Dark Blue\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

FileInstall, resources\skins\Path of Exile\Assets.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Background.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonOneThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonOneThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonOneThird.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonOneThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonOneThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonOneThirdHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonOneThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonOneThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonOneThirdPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonOneThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonSpecial.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecial.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonSpecial.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecial.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonSpecial.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecial.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonSpecial.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecial.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonSpecial.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecial.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonSpecialHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonSpecialHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonSpecialHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonSpecialHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonSpecialHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonSpecialPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonSpecialPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonSpecialPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonSpecialPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonSpecialPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonSpecialPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonThreeThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonThreeThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonThreeThird.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonThreeThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonThreeThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonThreeThirdHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonThreeThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonThreeThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonThreeThirdPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTwoThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTwoThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTwoThird.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTwoThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTwoThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTwoThirdHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\ButtonTwoThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\ButtonTwoThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\ButtonTwoThirdPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\CloseTab.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Header.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Icon.ico, % PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Maximize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Minimize.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\Preview.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

FileInstall, resources\skins\Path of Exile\Settings.ini, % PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabsUnderline.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsUnderline.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabsUnderline.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsUnderline.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabsUnderline.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabsUnderline.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsUnderline.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabsUnderline.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\Path of Exile"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\Path of Exile"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\Path of Exile\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\Path of Exile\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\Path of Exile\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\Path of Exile\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\Path of Exile\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowLeft.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowLeft.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowLeft.png, % PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeft.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeft.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowLeftHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowLeftHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowLeftHover.png, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowLeftPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowLeftPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowLeftPress.png, % PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowLeftPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowLeftPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowRight.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowRight.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowRight.png, % PROGRAM.SKINS_FOLDER "\White\ArrowRight.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRight.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRight.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowRightHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowRightHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowRightHover.png, % PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ArrowRightPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ArrowRightPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ArrowRightPress.png, % PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ArrowRightPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ArrowRightPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

FileInstall, resources\skins\White\Assets.ini, % PROGRAM.SKINS_FOLDER "\White\Assets.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Assets.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Assets.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Assets.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Background.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Background.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Background.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Background.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Background.png, % PROGRAM.SKINS_FOLDER "\White\Background.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Background.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Background.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Background.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonOneThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonOneThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonOneThird.png, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonOneThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonOneThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonOneThirdHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonOneThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonOneThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonOneThirdPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonOneThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonOneThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonSpecial.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecial.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonSpecial.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecial.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonSpecial.png, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecial.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonSpecial.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonSpecial.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonSpecial.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonSpecial.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonSpecialHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecialHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonSpecialHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecialHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonSpecialHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecialHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonSpecialHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonSpecialHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonSpecialHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonSpecialHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonSpecialPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecialPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonSpecialPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecialPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonSpecialPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonSpecialPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonSpecialPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonSpecialPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonSpecialPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonSpecialPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonThreeThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonThreeThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonThreeThird.png, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonThreeThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonThreeThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonThreeThirdHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonThreeThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonThreeThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonThreeThirdPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonThreeThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonThreeThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTwoThird.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTwoThird.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTwoThird.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThird.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThird.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTwoThirdHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTwoThirdHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTwoThirdHover.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\ButtonTwoThirdPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\ButtonTwoThirdPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\ButtonTwoThirdPress.png, % PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\ButtonTwoThirdPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\ButtonTwoThirdPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\CloseTab.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\CloseTab.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\CloseTab.png, % PROGRAM.SKINS_FOLDER "\White\CloseTab.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTab.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTab.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\CloseTabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\CloseTabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\CloseTabHover.png, % PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\CloseTabPress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\CloseTabPress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\CloseTabPress.png, % PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\CloseTabPress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\CloseTabPress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Header.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Header.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Header.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Header.png, % PROGRAM.SKINS_FOLDER "\White\Header.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Header.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Header.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\HeaderMin.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\HeaderMin.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\HeaderMin.png, % PROGRAM.SKINS_FOLDER "\White\HeaderMin.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\HeaderMin.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\HeaderMin.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Icon.ico")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Icon.ico"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Icon.ico
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Icon.ico"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Icon.ico, % PROGRAM.SKINS_FOLDER "\White\Icon.ico", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Icon.ico"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Icon.ico"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Icon.ico"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Maximize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Maximize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Maximize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Maximize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Maximize.png, % PROGRAM.SKINS_FOLDER "\White\Maximize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Maximize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Maximize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Maximize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MaximizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MaximizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MaximizeHover.png, % PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MaximizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MaximizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MaximizePress.png, % PROGRAM.SKINS_FOLDER "\White\MaximizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MaximizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MaximizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Minimize.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Minimize.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Minimize.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Minimize.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Minimize.png, % PROGRAM.SKINS_FOLDER "\White\Minimize.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Minimize.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Minimize.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Minimize.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MinimizeHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MinimizeHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MinimizeHover.png, % PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizeHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizeHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\MinimizePress.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\MinimizePress.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\MinimizePress.png, % PROGRAM.SKINS_FOLDER "\White\MinimizePress.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\MinimizePress.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\MinimizePress.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\Preview.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\Preview.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\Preview.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\Preview.png, % PROGRAM.SKINS_FOLDER "\White\Preview.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Preview.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Preview.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

FileInstall, resources\skins\White\Settings.ini, % PROGRAM.SKINS_FOLDER "\White\Settings.ini", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Settings.ini"
	.	"`nFlag: " 1)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\Settings.ini"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\Settings.ini"
	.	"`nFlag: " 1
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabActive.png, % PROGRAM.SKINS_FOLDER "\White\TabActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabHover.png, % PROGRAM.SKINS_FOLDER "\White\TabHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedActive.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedHover.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabJoinedInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabJoinedInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabJoinedInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabJoinedInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabJoinedInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabsBackground.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabsBackground.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabsBackground.png, % PROGRAM.SKINS_FOLDER "\White\TabsBackground.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsBackground.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsBackground.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabsUnderline.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabsUnderline.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabsUnderline.png, % PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabsUnderline.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabsUnderline.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperActive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperActive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperActive.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperActive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperActive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperHover.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperHover.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperHover.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperHover.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperHover.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TabWhisperInactive.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TabWhisperInactive.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TabWhisperInactive.png, % PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TabWhisperInactive.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TabWhisperInactive.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyGreen.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyGreen.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyGreen.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGreen.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGreen.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyGrey.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyGrey.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyGrey.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyGrey.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyGrey.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyOrange.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyOrange.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyOrange.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyOrange.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyOrange.png"
	.	"`nFlag: " 2
}

; ----------------------------
if !InStr(FileExist(PROGRAM.SKINS_FOLDER "\White"), "D")
	FileCreateDir,% PROGRAM.SKINS_FOLDER "\White"

if (A_IsCompiled) {
	sourceFileSize := Get_ResourceSize("resources\skins\White\TradeVerifyRed.png")
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
}
else {
	FileGetSize, sourceFileSize, resources\skins\White\TradeVerifyRed.png
	FileGetSize, destFileSize, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
}
if (sourceFileSize != destFileSize)
	FileInstall, resources\skins\White\TradeVerifyRed.png, % PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png", 1
if (ErrorLevel) {
	AppendToLogs("Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
	.	"`nFlag: " 2)
	errorLog .= "`n`n""Failed to extract file!"
	.	"`nSource: resources\skins\White\TradeVerifyRed.png"
	.	"`nDest: " PROGRAM.SKINS_FOLDER "\White\TradeVerifyRed.png"
	.	"`nFlag: " 2
}

; ----------------------------


if (errorLog)
	MsgBox, 4096, POE Trades Companion,% "One or multiple files failed to be extracted. Please check the logs file for details."
	.	PROGRAM.LOGS_FILE 

}
