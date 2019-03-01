#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoEnv

; ControlSetText, Edit1, New Text Here, Intercom

cmdLineParams := Get_CmdLineParameters()
VerifyItemPrice(cmdLineParams)
ExitApp

VerifyItemPrice(cmdLineParams) {
    global PROGRAM
    ; Converting cmd line params into obj
    startPos := 1, tradeInfos := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break

        startPos := foundPos+StrLen(outMatch.0), tradeInfos[outMatch.1] := outMatch.2
    }
    PROGRAM := {"CURL_EXECUTABLE": tradeInfos.cURL}

    poeTradeObj := {"name": tradeInfos.name, "buyout": poeTradePrice
        , "level_min": tradeInfos.level_min, "level_max": tradeInfos.level_max
        , "q_min": tradeInfos.q_min, "q_max": tradeInfos.q_max
		, "league": tradeInfos.league, "seller": tradeInfos.seller

		, "level": tradeInfos.level
		, "quality": tradeInfos.quality, "tab": tradeInfos.tab
		, "x": tradeInfos.x, "y": tradeInfos.y, "online": tradeInfos.online}

    if IsObject( PoeTrade_GetMatchingItemData(poeTradeObj, tradeInfos.itemURL) ) {
        data := "GUI_Trades.SetTabVerifyColor(GUI_Trades.GetTabNumberFromUniqueID(" tradeInfos.UniqueID "),Green)"
        . "`n"  "GUI_Trades.UpdateSlotContent(GUI_Trades.GetTabNumberFromUniqueID(" tradeInfos.UniqueID "),TradeVerifyInfos,wow)"
        ControlSetText, ,% data,% "ahk_id " tradeInfos.IntercomSlotHandle
    }
}

#Include %A_ScriptDir%
#Include CmdLineParameters.ahk
#Include EasyFuncs.ahk
#Include Logs.ahk
#Include PoeTrade.ahk
#Include WindowsSettings.ahk

#Include %A_ScriptDir%/third-party
#Include cURL.ahk
#Include StdOutStream.ahk