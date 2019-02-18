PoeNinja_GetMapOverview(league) {
    /*  Retrieve map infos from poe.ninja
    */
    url := "https://poe.ninja/api/Data/GetMapOverview?league=" league
	postData		:= ""
	reqHeaders		:= []
	reqHeaders.Push("Content-Type: text/html; charset=UTF-8")
	options			:= ""
	html 			:= cURL_Download(url, ioData := postData, reqHeaders, options, false, false, false, errorMsg)

    mapsJSON := JSON.Load(html)
    return mapsJSON
}

PoeNinja_CreateMapDataFile(league) {
    /*  Create our map data file from map infos of poe.ninja
    */
    mapsJSON := PoeNinja_GetMapOverview(league)
    excludeList := "Elder,Shaped"
    maps := {}

    for index, nothing in mapsJSON.lines {
        mapName := mapsJSON.lines[index].name
        mapTier := mapsJSON.lines[index].mapTier

        if !IsContaining(mapName, excludeList) {
            if !IsObject(maps[mapTier])
                maps[mapTier] := {}
            maps[mapTier].Push(mapName)
        }
    }

    mapsSorted := {}
    for index, nothing in maps {        
        tierMapsList := ""
        Loop % maps[index].Count()
            tierMapsList := tierMapsList ? tierMapsList "`n" maps[index][A_Index] : maps[index][A_Index]

        Sort, tierMapsList, D`n
        mapsSorted["tier_" index] := {}
        Loop, Parse, tierMapsList, `n, `r
        {
            mapName := A_LoopField
            mapsSorted["tier_" index][mapName] := {}
            mapsSorted["tier_" index][mapName].pos := A_Index
        }
    }

    finalData := JSON.Beautify(mapsSorted)
    FileDelete,% A_ScriptDir "/data//mapsData.json"
    FileAppend,% finalData,% A_ScriptDir "/data//mapsData.json"
}
