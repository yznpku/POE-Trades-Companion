PoeTrade_GenerateCurrencyData() {
    returnVal := PoeTrade_GetCurrencyData(createData:=True)
    jsonData := returnVal.1, txtData := returnVal.2

    if !(jsonData) {
        MsgBox(4096, "", "Function: " A_ThisFunc "`nCurrency JSON data is invalid, cancelling.")
        return
    }
    if !(txtData) {
        MsgBox(4096, "", "Function: " A_ThisFunc "`nCurrency TXT data is invalid, cancelling.")
        return
    }

    fileLocation := A_ScriptDir "/data/poeTradeCurrencyData.json"
    FileDelete,% fileLocation
    FileAppend,% jsonData,% fileLocation

    fileLocation := A_ScriptDir "/data/CurrencyNames.txt"
    FileDelete,% fileLocation
    FileAppend,% txtData,% fileLocation
}

PoeTrade_GenerateCurrencyListTXT() {
    
}

PoeTrade_GetCurrencyData(createData=False) {
    global PROGRAM

	Url := "http://currency.poe.trade/"
	postData 	:= ""
	options	:= ""

	reqHeaders	:= []
	reqHeaders.push("User-Agent:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
	reqHeaders.push("Accept-Encoding:gzip, deflate")
	reqHeaders.push("Accept-Language:de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4")
	reqHeaders.push("Connection:keep-alive")
	reqHeaders.push("Referer:http://poe.trade/")
	reqHeaders.push("Upgrade-Insecure-Requests:1")

	html := cURL_Download(url, postData, reqHeaders, options, false)

    regexPos := 1, categories := {}
    Loop {
        loopIndex := A_Index
        foundPos := RegExMatch(html, "iO)id=""cat-want-(.*?)id=""cat-(want-|have-|input)", htmlPat, regexPos)
        if (foundPos) {
            categories.Push(htmlPat.1)
            regexPos := foundPos+1
        }
        else
            Break
    }

    currenciesObj := {}
    for key, value in categories {
        regExPos := 1
        Loop {
            foundPos := RegExMatch(value, "iO)<div(.*?)<\/div>", currencyItemPat, regExPos)
            if (foundPos) {
                currencyData := currencyItemPat.1
                regExPos := foundPos+1 + StrLen(currencyData)
                
                RegExMatch(currencyData, "iO)title=""(.*?)""", curTitlePat), curTitle := curTitlePat.1
                RegExMatch(currencyData, "iO)data-title=""(.*?)""", curDataTitlePat), curDataTitle := curDataTitlePat.1
                RegExMatch(currencyData, "iO)data-id=""(.*?)""", curDataIDPat), curDataID := curDataIDPat.1
                curTitle := StrReplace(curTitle, "&#39;", "'")
                curDataTitle := StrReplace(curDataTitle, "&#39;", "'")

                if (curTitle) {
                    currenciesObj[curTitle] := {}
                    currenciesObj[curTitle]["Full"] := curTitle
                    currenciesObj[curTitle]["Abridged"] := curDataTitle
                    currenciesObj[curTitle]["ID"] := curDataID

                    curTitle := "", curDataTitle := "", curDataID := ""
                }
                if (curDataTitle) {
                    currenciesObj[curDataTitle] := curTitle
                }
            }
            else 
                Break
        }
    }

    

    if !(currenciesObj["Chaos Orb"]) {
        ; TO_DO logs, fallback to json file
        FileRead, JSONFile,% PROGRAM.DATA_FOLDER "\poeTradeCurrencyData.json"
        currenciesObj := JSON.Load(JSONFile)
    }

    if (createData=True) {
        if !(currenciesObj["Chaos Orb"])
            return 0

        txtData := ""
        jsonData := "{`n"
        for key, value in currenciesObj {
            fName := currenciesObj[key].Full, cID := currenciesObj[key].ID, sName := currenciesObj[key].Abridged
                    
            if (sName != fName) {
                jsonData .= A_Tab """" fName """: {"
                . "`n" A_Tab A_Tab """Abridged"": " """" sName ""","
                . "`n" A_Tab A_Tab """ID"": " """" cID """"
                . "`n" A_Tab "},"
                . "`n" A_Tab """" sName """: """ fName """,`n"
            }
            else {
                jsonData .= A_Tab """" fName """: {"
                . "`n" A_Tab A_Tab """ID"": " """" cID """"
                .  "`n" A_Tab "},`n"

                txtData .= txtData?"`n" fName : fName
            }
        }
        StringTrimRight, jsonData, jsonData, 2
        jsonData .= "`n}"

        return [jsonData, txtData]
    }

    Return currenciesData
}

PoeTrade_Get_CurrencyAbridgedName_From_FullName(lName) {
    global PROGRAM
    data := PROGRAM.DATA.POETRADE_CURRENCY_DATA

    sName := data[lName].Abridged ? data[lName].Abridged : lName

    return sName
}

PoeTrade_GetMatchingItemData(dataObj, itemURL) {
    
    ; itemURL := PoeTrade_GetItemSearchUrl(dataObj)
    html := PoeTrade_GetSource("http://poe.trade/search?" itemURL)

    ; if !dataObj.HasKey("seller") && dataObj.HasKey("ItemName") ; Its a TradesGUI obj, need to convert
        ; dataObj := ConvertPoeTCObjToPoeTradeObj(dataObj)

    regexPos := 1
    Loop {
        loopindex := A_Index
        foundPos := RegExMatch(html, "iO)<tbody id=""item-container-\d+"" class=""item.*?"".*?</tbody>", htmlPat, regexPos)
        if (foundPos) {
            tBody := htmlPat.0, regexPos := foundPos+1

            saleInfoTags := "seller,buyout,ign,league,name,tab,level,quality,x,y", foundObj := {}
            Loop, Parse, saleInfoTags,% ","
            {
                RegExMatch(tBody, "iO)data-" A_LoopField "=""(.*?)""", foundPat)
                foundObj[A_LoopField] := foundPat.1
            }

            ; poe.trade data-x and data-y start at 1 instead of 0 like in the whisper, so we add +1
            if (foundObj.seller = dataObj.seller) && (foundObj.league = dataObj.league)
            && (foundObj.tab = dataObj.tab) && (foundObj.level = dataObj.level_min) && (foundObj.quality = dataObj.q_min)
            && (foundObj.x+1 = dataObj.x) && (foundObj.y+1 = dataObj.y) { ; Item is the same
                return foundObj
            }
        }
        else    
            Break
    }
}

; PoeTrade_CompareItemDatas(poeTradeData, tcData) {
    
; }

PoeTrade_ParseSource(html) {
    regexPos := 1
    RegExMatch(Haystack, NeedleRegEx [, UnquotedOutputVar = "", StartingPos = 1])
    Loop {
        loopindex := A_Index
        foundPos := RegExMatch(html, "iO)<tbody id=""item-container-\d+"" class=""item.*?"".*?</tbody>", htmlPat, regexPos)
        if (foundPos) {
            tBody := htmlPat.0, regexPos := foundPos+1

            saleInfoTags := "seller,buyout,ign,league,name,tab,level,quality,x,y", saleObj := {}
            Loop, Parse, saleInfoTags,% ","
            {
                RegExMatch(tBody, "iO)data-" A_LoopField "=""(.*?)""", foundPat)
                saleObj[A_LoopField] := foundPat.1
                msgbox % foundPat.1
            }
            
            ; PoeTrade_CompareItemDatas(saleObj, tcObj)
        }
        else    
            Break
    }
    
    ; FileDelete, poeTradeHtml.html
    ; FileAppend, %html%, poeTradeHtml.html
}

PoeTrade_CreatePayload(obj, addDefaultParams=False) {
    defaultParams := {"altart": "", "aps_max": "", "aps_min": "", "armour_max": "", "armour_min": "", "base": "", "block_max": "", "block_min": "", "buyout_currency": ""
    , "buyout_max": "", "buyout_min": "", "capquality": "x", "corrupted": "", "crafted": "", "crit_max": "", "crit_min": "", "dmg_max": "", "dmg_min": ""
    , "dps_max": "", "dps_min": "", "edps_max": "", "edps_min": "", "elder": "", "enchanted": "", "evasion_max": "", "evasion_min": "", "exact_currency": ""
    , "group_count": 1, "group_max": "", "group_min": "", "group_type": "And", "has_buyout": "", "identified": "", "ilvl_max": "", "ilvl_min": ""
    , "league": "Incursion", "level_max": "", "level_min": "", "link_max": "", "link_min": "", "linked_b": "", "linked_g": "", "linked_r": "", "linked_w": ""
    , "map_series": "", "mod_max": "", "mod_min": "", "mod_name": "", "mod_weight": "", "name": "", "online": "x", "pdps_max": "", "pdps_min": ""
    , "progress_max": "", "progress_min": "", "q_max": "", "q_min": "", "rarity": "", "rdex_max": "", "rdex_min": "", "rint_max": "", "rint_min": ""
    , "rlevel_max": "", "rlevel_min": "", "rstr_max": "", "rstr_min": "", "seller": "", "shaper": "", "shield_max": "", "shield_min": "", "sockets_a_max": ""
    , "sockets_a_min": "", "sockets_b": "", "sockets_g": "", "sockets_max": "", "sockets_min": "", "sockets_r": "", "sockets_w": "", "thread": "" , "type": ""}

    poeTradeObj := obj

    ; Capitalize league first letters
    league := poeTradeObj["league"]
    StringUpper, league, league, T
    poeTradeObj["league"] := league

    ; Create payload
    payload := ""
    if (addDefaultParams) {
        for key, defValue in defaultParams {
            value := poeTradeObj.HasKey(key) ? poeTradeObj[key] : addDefaultParams=True && defValue?defValue : ""
            payloadStr := key "=" value
            payload .= (payload)?("&" payloadStr):(payloadStr)
        }
    }
    else {
        for key, value in poeTradeObj {
            payloadStr := key "=" value
            payload .= (payload)?("&" payloadStr):(payloadStr)
        }
    }

    return payload
}

PoeTrade_GetItemSearchUrl(itemObj) {
    itemURL := PoeTrade_CreatePayload(itemObj)
    return itemURL
}

PoeTrade_OpenItemSearchUrl(itemObj) {
    itemURL := PoeTrade_GetItemSearchUrl(itemObj)

    Run, http://poe.trade/search?%itemURL%
}

PoeTrade_GetSource(url) {
    RegExMatch(url, "O).*poe\.trade/search\?(.*)", payloadPat)
    payload := payloadPat.1

    postData 	:= payload
	payLength	:= StrLen(postData)
	url 		:= "http://poe.trade/search"
	options	    := ""

	reqHeaders	:= []
	reqHeaders.push("Connection: keep-alive")
	reqHeaders.push("Cache-Control: max-age=0")
	reqHeaders.push("Origin: http://poe.trade")
	reqHeaders.push("Upgrade-Insecure-Requests: 1")
	reqHeaders.push("Content-type: application/x-www-form-urlencoded; charset=UTF-8")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
	reqHeaders.push("Referer: http://poe.trade/")

    html := cURL_Download(url, postData, reqHeaders, options, false)

    return html
}
