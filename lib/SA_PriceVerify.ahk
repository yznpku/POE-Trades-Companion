#SingleInstance, Off
#KeyHistory 0
#Persistent
#NoEnv

cmdLineParams := Get_CmdLineParameters()
VerifyItemPrice(cmdLineParams)
ExitApp

VerifyItemPrice(cmdLineParams) {
    global PROGRAM
    ; Converting cmd line params into obj
    startPos := 1, cmdLineParamsObj := {}
    Loop {
        foundPos := RegExMatch(cmdLineParams, "iO)/(.*?)=""(.*?)""", outMatch, startPos)
        if (!foundPos || A_Index > 100)
            Break

        startPos := foundPos+StrLen(outMatch.0), cmdLineParamsObj[outMatch.1] := outMatch.2
    }
    ; setting cURL location bcs of how my modified library work
    PROGRAM := {"CURL_EXECUTABLE": cmdLineParamsObj.cURL}

    if (cmdLineParamsObj.TradeType = "Regular") { ; poe.trade
        Loop, Parse,% cmdLineParamsObj.Accounts,% ","
        {
            thisAccount := A_LoopField
            
            ; infos required to create search url
			searchURLObj := {"name": cmdLineParamsObj.ItemName, "buyout": cmdLineParamsObj.ItemPrice
			, "level_min": cmdLineParamsObj.ItemLevel, "level_max": cmdLineParamsObj.ItemLevel
			, "q_min": cmdLineParamsObj.ItemQuality, "q_max": cmdLineParamsObj.ItemQuality
			, "league": cmdLineParamsObj.League, "seller": thisAccount}
			itemURL := PoeTrade_GetItemSearchUrl(searchURLObj)

            ; looking for a matching item based on data we have
            searchObj := {"seller": thisAccount, "online": ""
                , "buyout": cmdLineParamsObj.ItemPrice, "name": cmdLineParamsObj.ItemName
                , "level_min": cmdLineParamsObj.ItemLevel, "level_max": cmdLineParamsObj.ItemLevel
                , "q_min": cmdLineParamsObj.ItemQuality, "q_max": cmdLineParamsObj.ItemQuality
                , "league": cmdLineParamsObj.League, "tab": cmdLineParamsObj.StashTab
                , "x": cmdLineParamsObj.StashX, "y" : cmdLineParamsObj.StashY}
            poeTradeObj := PoeTrade_GetMatchingItemData(searchObj, itemURL)

            if IsObject(poeTradeObj) { ; Obj means match was found
                ; split currency count and name
                RegExMatch(cmdLineParamsObj.ItemPrice, "O)(\d+) (.*)", whisperBuyoutPat), whisper_currencyCount := whisperBuyoutPat.1, whisper_currencyType := whisperBuyoutPat.2
                RegExMatch(poeTradeObj.buyout, "O)(\d+) (.*)", poeTradeBuyoutPat), poeTrade_currencyCount := poeTradeBuyoutPat.1, poeTrade_currencyType := poeTradeBuyoutPat.2

                if (cmdLineParamsObj.ItemPrice = poeTradeObj.buyout) { ; Exactly same price (OK)
                    vInfos := "Price confirmed legit."
                    . "\npoe.trade: `t" poeTradeObj.buyout
                    . "\nwhisper: `t`t" cmdLineParamsObj.ItemPrice
                    vColor := "Green"
                }
                else if (poeTrade_currencyType=whisper_currencyType && whisper_currencyCount >= poeTrade_currencyCount) { ; Whisper is higher than poeTrade (OK)
                    vInfos := "Price is higher."
                    . "\npoe.trade: `t" poeTradeObj.buyout
                    . "\nwhisper: `t`t" cmdLineParamsObj.ItemPrice
                    vColor := "Green"
                }
                else {
                    if (cmdLineParamsObj.CurrencyName = "") { ; Unpriced item 
                        vInfos := "/!\ Cannot verify unpriced items yet. /!\"
                        vColor := "Orange"
                    }
                    else if (!cmdLineParamsObj.CurrencyIsListed) { ; Unknown currency 
                        vInfos := "Unknown currency name: """ currencyInfos.Name """"
                        . "\nPlease report it."
                        vColor := "Orange"
                    }
                    else if (cmdLineParamsObj.CurrencyIsListed && cmdLineParamsObj.ItemPrice != poeTradeObj.buyout) { ; Whisper is different from poe.trade (NOTOK)
                        vInfos := "Price is different."
                        . "\npoe.trade: `t" poeTradeObj.buyout
                        . "\nwhisper: `t`t" cmdLineParamsObj.ItemPrice
                        vColor := "Red"
                    }

                }
            }
            else { ; No match was found
                if (cmdLineParamsObj.WhisperLang != "ENG") { ; Whisper is not eng
                    vInfos := "Cannot verify price for"
                    . "\npathofexile.com/trade translated whispers."
                    vColor := "Orange"
                }
                else { ; Couldn't find any item matching tab name and x;y pos
                    vInfos := "Could not find any item matching the same stash location"
                    . "\nMake sure to set your account name in the settings."
                    . "\nAccounts: " cmdLineParamsObj.Accounts
                    vColor := "Orange"
                }
            }
        }
    }

    else if (cmdLineParamsObj.TradeType = "Currency") { ; currency.poe.trade

    }

    ; Construct data string that'll be transmited to intercom
    data := "tabNum := GUI_Trades.GetTabNumberFromUniqueID(" cmdLineParamsObj.TabUniqueID ")"
    . "`n"  "GUI_Trades.SetTabVerifyColor(%tabNum%," vColor ")"
    . "`n"  "GUI_Trades.UpdateSlotContent(%tabNum%,TradeVerifyInfos," vInfos ")"
    ControlSetText, ,% data,% "ahk_id " cmdLineParamsObj.IntercomSlotHandle
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