Class GUI_MyStats {
	
	Create(param="") {
		global PROGRAM, GAME
		global GuiMyStats, GuiMyStats_Controls, GuiMyStats_Submit
		static guiCreated

		Gui, MyStats:Destroy
		Gui.New("MyStats", "-Caption +Resize -MaximizeBox +MinSize720x480  +LabelGUI_MyStats_ +HwndhGuiMyStats", "MyStats")
		; Gui.New("MyStats", "-Caption -Border +LabelGUI_MyStats_ +HwndhGuiMyStats", "MyStats")
		GuiMyStats.Is_Created := False

		guiCreated := False
		guiFullHeight := 480, guiFullWidth := 720, borderSize := 1, borderColor := "Red"
		guiHeight := guiFullHeight-(2*borderSize), guiWidth := guiFullWidth-(2*borderSize)
		leftMost := borderSize, rightMost := guiWidth-borderSize
		upMost := borderSize, downMost := guiHeight-borderSize

		Style_Tab := [ [0, "0xEEEEEE", "", "Black", 0, , ""] ; normal
			, [0, "0xdbdbdb", "", "Black", 0] ; hover
			, [3, "0x44c6f6", "0x098ebe", "Black", 0]  ; press
			, [3, "0x44c6f6", "0x098ebe", "White", 0 ] ] ; default

		Style_RedBtn := [ [0, "0xff5c5c", "", "White", 0, , ""] ; normal
			, [0, "0xff5c5c", "", "White", 0] ; hover
			, [3, "0xe60000", "0xff5c5c", "Black", 0]  ; press
			, [3, "0xff5c5c", "0xe60000", "White", 0 ] ] ; default

		/* * * * * * *
		* 	CREATION
		*/

		Gui.Margin("MyStats", 0, 0)
		Gui.Color("MyStats", "White")
		Gui.Font("MyStats", "Segoe UI", "8")
		Gui, MyStats:Default ; Required for LV_ cmds

		; *	* Borders
		/*
		Upon resizing a PROGRESS control, it will have some kind of "border" around it
		This end up making the border greyish as the actual PROGRESS control color starts 1-2 px away
		Since this GUI is resizable, we use a workaround that consists of adding a TEXT control with a black border via the 0x7 style

		bordersPositions := [{X:0, Y:0, W:guiFullWidth, H:borderSize}, {X:0, Y:0, W:borderSize, H:guiFullHeight} ; Top and Left
			,{X:0, Y:downMost, W:guiFullWidth, H:borderSize}, {X:rightMost, Y:0, W:borderSize, H:guiFullHeight}] ; Bottom and Right
		Loop 4 ; Left/Right/Top/Bot borders
			Gui.Add("MyStats", "Progress", "x" bordersPositions[A_Index]["X"] " y" bordersPositions[A_Index]["Y"] " w" bordersPositions[A_Index]["W"] " h" bordersPositions[A_Index]["H"] " hwndhPROGRESS_Border" A_Index " cRed -Smooth", 100)
		*/
		Gui.Add("MyStats", "Text", "x0 y0 w" guiWidth " h" guiHeight " hwndhTEXT_Borders 0x7 BackgroundTrans")
		

		; * * Title bar
		Gui.Add("MyStats", "Text", "x" leftMost " y" upMost " w" guiWidth-(borderSize*2)-30 " h25 hwndhTEXT_HeaderGhost BackgroundTrans ", "") ; Title bar, allow moving
		Gui.Add("MyStats", "Progress", "xp yp wp hp hwndhPROGRESS_TitleBackground Background359cfc") ; Title bar background
		Gui.Add("MyStats", "Text", "xp yp wp hp Center 0x200 cWhite BackgroundTrans hwndhTEXT_TitleText", "POE Trades Companion - MyStats") ; Title bar text
		imageBtnLog .= Gui.Add("MyStats", "ImageButton", "x+0 yp w30 hp hwndhBTN_CloseGUI", "X", Style_RedBtn, PROGRAM.FONTS["Segoe UI"], 8)

        ; * * Filtering options
        Gui.Add("MyStats", "GroupBox", "x" leftMost+10 " y+10 w" guiWidth-20 " R6 c000000 hwndhGB_FilteringOptions", "Filtering Options")
        Gui.Add("MyStats", "Text", "x" leftMost+25 " yp+25 w40", "Buyer:")
        Gui.Add("MyStats", "DropDownList", "x+0 yp-2 vvDDL_BuyerFilter hwndhDDL_BuyerFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w50", "Item:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 ToolTip hwndhDDL_ItemFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w40", "League:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 hwndhDDL_LeagueFilter w160", "All")

        Gui.Add("MyStats", "Text", "x" leftMost+25 " y+20 w40", "Guild:")
        Gui.Add("MyStats", "DropDownList", "x+0 yp-2 hwndhDDL_GuildFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w50", "Currency:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 hwndhDDL_CurrencyFilter w160", "All")
        Gui.Add("MyStats", "Text", "x+20 yp+2 w40", "Tab:")
        Gui.Add("MyStats", "DropDownList", "x+5 yp-2 hwndhDDL_TabFilter w160", "All")

        ; * * Stats list
        Gui.Add("MyStats", "ListView", "x" leftMost+10 " y+30 w" guiWidth-20 " R17 hwndhLV_Stats", "#|Date|Time|Guild|Buyer|Item|Price|League|Tab|Other")

		; * * Stats parse
		GUI_MyStats.UpdateData()

		; Gui, Stats: Show, AutoSize NoActivate


        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
		*	SHOW
		*/

		GUI_MyStats.EnableSubroutines()

        Gui.Show("MyStats", "h" guiHeight " w" guiWidth-1 " NoActivate Hide")

		OnMessage(0x201, "WM_LBUTTONDOWN")
		OnMessage(0x202, "WM_LBUTTONUP")
		OnMessage(0x84, "WM_NCHITTEST")
		OnMessage(0x83, "WM_NCCALCSIZE")
		OnMessage(0x86, "WM_NCACTIVATE")

		Gui.Show("MyStats", "h" guiHeight " w" guiWidth " NoActivate Hide")

        Return

        Gui_MyStats_Size:
            GUI_MyStats.Resize()
        Return
    }

	DisableSubroutines() {
		GUI_MyStats.ToggleSubroutines("Disable")	
	}
	EnableSubroutines() {
		GUI_MyStats.ToggleSubroutines("Enable")	
	}

	ToggleSubroutines(enableOrDisable) {
		global GuiMyStats, GuiMyStats_Controls

		for ctrlName, ctrlHandle in GuiMyStats_Controls {
			loopedCtrl := ctrlName
			RegExMatch(loopedCtrl, "\D+", loopedCtrl_NoNum)
			RegExMatch(loopedCtrl, "\d+", loopedCtrl_NumOnly)

			if (enableOrDisable = "Disable")
				GuiControl, MyStats:-g,% GuiMyStats_Controls[loopedCtrl]
			else if (enableOrDisable = "Enable") {
				if (loopedCtrl = "hTEXT_HeaderGhost")
					__f := GUI_MyStats.DragGui.bind(GUI_MyStats, GuiMyStats.Handle)
				else if (loopedCtrl = "hBTN_CloseGUI")
					__f := GUI_MyStats.Close.bind(GUI_MyStats)
				else if IsIn(loopedCtrl, "hDDL_BuyerFilter,hDDL_ItemFilter,hDDL_LeagueFilter,hDDL_GuildFilter,hDDL_CurrencyFilter,hDDL_TabFilter") {
					StringTrimLeft, trimmedCtrl, loopedCtrl, 5
					__f := GUI_MyStats.FilterList.bind(GUI_MyStats, trimmedCtrl, filterContent:="")
				}
				else if (loopedCtrl = "hLV_Stats") {
					__f := GUI_MyStats.OnLVClick.bind(GUI_MyStats)
				}
				else
					__f := 

				if (__f)
					GuiControl, MyStats:+g,% GuiMyStats_Controls[loopedCtrl],% __f 
			}
		}
	}

	OnLVClick(hwnd, guiEvent="", eventInfo="") {
		Gui, MyStats:Default
		Gui, MyStats:ListView,% GuiMyStats_Controls.hLV_Stats

		if (guiEvent="ColClick") {
			LV_GetText(Out1, 1, eventInfo)
			LV_GetText(Out2, LV_GetCount(), eventInfo)
			isSortedDown := Out2 < Out1
			if (isSortedDown)
				LV_ModifyCol(eventInfo, "Sort") 	
			else
				LV_ModifyCol(eventInfo, "SortDesc") 
		}
	}

	Submit(CtrlName="") {
		global GuiMyStats_Submit, GuiMyStats_Controls
		Gui.Submit("MyStats")

		if (CtrlName) {
			Return GuiMyStats_Submit[ctrlName]
		}
	}

	GetFilters(fType="All") {
		global GuiMyStats_Submit

		Gui_MyStats.Submit()
		sub := GuiMyStats_Submit
		
		if (fType = "All") {
			return {Buyer: sub.hDDL_BuyerFilter, Item: sub.hDDL_ItemFilter, League: sub.hDDL_LeagueFilter
			, Guild: sub.hDDL_GuildFilter, Currency: sub.hDDL_CurrencyFilter, Tab: sub.hDDL_TabFilter}
		}
		else
			return sub["hDDL_" fType]
	}

	FilterList(filterType, filterContent="") {
		global GuiMyStats, GuiMyStats_Controls

		filters := GUI_MyStats.GetFilters("All")
		data := GuiMyStats.Stats_Data

		LV_Delete()
		addIndex := 1
		Loop % data.MaxIndex() {
			loopIndex := A_Index
			loopedData := data[loopIndex]

			cInfos_price := Get_CurrencyInfos(loopedData.Price)
			cInfos_item := Get_CurrencyInfos(loopedData.Item)

			if ( (loopedData.Buyer = filters.Buyer) || (filters.Buyer = "All") )
			&& ( (loopedData.Item = filters.Item) || (cInfos_item.Is_Listed && cInfos_item.Name = filters.Item) || (filters.Item = "All") )
			&& ( (loopedData.Location_League = filters.League) || (filters.League = "All") )
			&& ( (loopedData.Guild = filters.Guild) || (filters.Guild = "All") || (filters.Guild = "No guild" && loopedData.Guild = "") )
			&& ( (cInfos_price.Name = filters.Currency) || (filters.Currency = "All") )
			&& ( (loopedData.Location_Tab = filters.Tab) || (filters.Tab = "All") ) {
				GUI_MyStats.StatsData_AddRow(addIndex, loopedData)
				addindex++
			}
		}
	}

	StatsData_AddRow(num, what) {
		loopedData := what
		Loop {
			; Get all the Other_xx and set it in a single string
			otherIndex := A_Index
			loopedDataOther := loopedData["Other_" otherIndex]
			if (loopedDataOther != "" && loopedDataOther != "ERROR")
				loopedOther .= (loopedOther)?("     " otherIndex ": " loopedDataOther):(otherIndex ": " loopedDataOther)
			else
				Break

			if (otherIndex > 100) {
				AppendToLogs("GUI_MyStats.StatsData_AddRow(): Broke out of loop after 100")
				Break
			}
			otherIndex--
			; Add the content into the lv line
			loopedOther := (otherIndex)?(otherIndex " message ->    " loopedOther):("")
		}

		LV_Add("", num, loopedData.Date_YYYYMMDD, loopedData.Time, loopedData.Guild, loopedData.Buyer, loopedData.Item
			, loopedData.Price, loopedData.Location_League, loopedData.Location_Tab, loopedOther)
	}

	UpdateData() {
		global GuiMyStats, GuiMyStats_Controls

		; Set GUI as default, needed for LV cmds. Set LV as default for gui.
		Gui, MyStats:Default
		Gui, MyStats:ListView,% GuiMyStats_Controls.hLV_Stats

		; Empty LV
		LV_Delete()

		; Get data and parse it
		data := GUI_MyStats.GetData(), GuiMyStats.Stats_Data := data
		allBuyers := allGuilds := allItems := allCurrency := allLeagues := allTabs := ""
		Loop % data.MaxIndex() {
			loopIndex := A_Index
			loopedData := data[loopIndex]

			GUI_MyStats.StatsData_AddRow(loopIndex, loopedData)

			; Replace any possible comma to avoid interfer with IsIn()
			loopedBuyer := StrReplace(loopedData.Buyer, ",", "{COMMA}")
			loopedGuild := StrReplace(loopedData.Guild, ",", "{COMMA}")
			loopedItem := StrReplace(loopedData.Item_Name, ",", "{COMMA}")
			loopedCurrency := StrReplace(loopedData.Price, ",", "{COMMA}")
			loopedLeague := StrReplace(loopedData.Location_League, ",", "{COMMA}")
			loopedTab := StrReplace(loopedData.Location_Tab, ",", "{COMMA}")

			; Create the lists
			if (loopedBuyer)
				allBuyers .= (!allBuyers)?(loopedBuyer)
				: !IsIn(loopedBuyer, allBuyers)?("," loopedBuyer) : ("")
			if (loopedGuild)
				allGuilds .= (!allGuilds)?(loopedGuild)
				: !IsIn(loopedGuild, allGuilds)?("," loopedGuild) : ("")
			if (loopedItem)
				allItems .= (!allItems)?(loopedItem)
				: !IsIn(loopedItem, allItems)?("," loopedItem) : ("")
			if (loopedCurrency)
				allCurrencies .= (!allCurrencies)?(loopedCurrency)
				: !IsIn(loopedCurrency, allCurrencies)?("," loopedCurrency) : ("")
			if (loopedLeague)
				allLeagues .= (!allLeagues)?(loopedLeague)
				: !IsIn(loopedLeague, allLeagues)?("," loopedLeague) : ("")
			if (loopedTab)
				allTabs .= (!allTabs)?(loopedTab)
				: !IsIn(loopedTab, allTabs)?("," loopedTab) : ("")
		}

		; Parse items, in case its currency
		allItems_parsed := ""
		Loop, Parse, allItems,% ","
		{
			cInfos := Get_CurrencyInfos(A_LoopField)
			if (cInfos.Is_Listed) && !IsIn(cInfos.Name, allItems_parsed)
				allItems_parsed .= (!allItems_parsed)?(cInfos.Name)
				: ("," cInfos.Name)
			else
				allItems_parsed .= (!allItems_parsed)?(A_LoopField)
				: ("," A_LoopField)
		}

		; Parse currencies, separate unlisted and listed
		listedCurrencies := unlistedCurrencies := ""
		Loop, Parse, allCurrencies,% ","
		{
			cInfos := Get_CurrencyInfos(A_LoopField)
			if (cInfos.Is_Listed) && !IsIn(cInfos.Name, listedCurrencies)
				listedCurrencies .= (!listedCurrencies)?(cInfos.Name)
				: !IsIn(cInfos.Name, listedCurrencies)?("," cInfos.Name) : ("")
			else if (!cInfos.Is_Listed) && !IsIn(cInfos.Name, unlistedCurrencies)
				unlistedCurrencies .= (!unlistedCurrencies)?(cInfos.Name)
				: !IsIn(cInfos.Name, unlistedCurrencies)?("," cInfos.Name) : ("")
		}

		; Replace comma separator with vertical bar, put back comma in place of temporary str
		allBuyers := StrReplace(allBuyers, ",", "|"), StrReplace(allBuyers, "{COMMA}", ",")
		allGuilds := StrReplace(allGuilds, ",", "|"), StrReplace(allGuilds, "{COMMA}", ",")
		allItems := StrReplace(allItems, ",", "|"), StrReplace(allItems, "{COMMA}", ",")
		allItems_parsed := StrReplace(allItems_parsed, ",", "|"), StrReplace(allItems_parsed, "{COMMA}", ",")
		allCurrencies := StrReplace(allCurrencies, ",", "|"), StrReplace(allCurrencies, "{COMMA}", ",")
		listedCurrencies := StrReplace(listedCurrencies, ",", "|"), StrReplace(listedCurrencies, "{COMMA}", ",")
		unlistedCurrencies := StrReplace(unlistedCurrencies, ",", "|"), StrReplace(unlistedCurrencies, "{COMMA}", ",")
		allCurrencyTypes := unlistedCurrencies?listedCurrencies "| |Unknown: |" unlistedCurrencies : listedCurrencies
		allLeagues := StrReplace(allLeagues, ",", "|"), StrReplace(allLeagues, "{COMMA}", ",")
		allTabs := StrReplace(allTabs, ",", "|"), StrReplace(allTabs, "{COMMA}", ",")
		; Declare global var in case of need
		GuiMyStats.All_Buyers := allBuyers, GuiMyStats.All_Guilds := allGuilds, GuiMyStats.All_Items := allItems, GuiMyStats.All_Items_Parsed := allItems_parsed
		GuiMyStats.All_Currencies := allCurrencies, GuiMyStats.All_ListedCurrencies := listedCurrencies, GuiMyStats.All_UnlistedCurrencies := unlistedCurrencies
		GuiMyStats.All_Leagues := allLeagues, GuiMyStats.All_Tabs := allTabs
		; Set GUI controls
		GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_BuyerFilter,% "|All|" allBuyers
		GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_GuildFilter,% "|All|No guild|" allGuilds
		GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_ItemFilter,% "|All|" allItems_parsed
		GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_CurrencyFilter,% "|All|" allCurrencyTypes
		GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_LeagueFilter,% "|All|" allLeagues
		GuiControl, MyStats:,% GuiMyStats_Controls.hDDL_TabFilter,% "|All|" allTabs
		GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_BuyerFilter, 1
		GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_GuildFilter, 1
		GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_ItemFilter, 1
		GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_CurrencyFilter, 1
		GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_LeagueFilter, 1
		GuiControl, MyStats:Choose,% GuiMyStats_Controls.hDDL_TabFilter, 1

		; Autoadjust col
		Loop 9
			LV_ModifyCol(A_Index, "AutoHdr NoSort")
		LV_ModifyCol(10, "NoSort")
		LV_ModifyCol(10, 100)
	}

	GetData() {
		global PROGRAM
		statsINI := PROGRAM.TRADES_HISTORY_FILE

		index := INI.Get(statsINI, "GENERAL", "Index")
		index := IsNum(index) ? index : 0

		data := {}
		Loop % index {
			loopIndex := A_Index

			data[loopIndex] := {}
			keysAndValues := INI.Get(statsINI, loopIndex,,True)
			for key, value in keysAndValues
				data[loopIndex][key] := value
		}
		return data
	}

    Resize() {
        global GuiMyStats_Controls

        ; Borders
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_Borders,% "x0 y0 w" A_GuiWidth " h" A_GuiHeight
        ; Title
        coords := Get_ControlCoords("MyStats", GuiMyStats_Controls.hPROGRESS_TitleBackground)
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hPROGRESS_TitleBackground,% " h26 w" A_GuiWidth-30+1 " "
		GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_HeaderGhost,% "w" A_GuiWidth-30
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hTEXT_TitleText,% "w" A_GuiWidth-30
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hBTN_CloseGUI,% "x" A_GuiWidth-30 " "
        ; Filter + List
        coords := Get_ControlCoords("MyStats", GuiMyStats_Controls.hLV_Stats)
        GuiControl, MyStats:Move,% GuiMyStats_Controls.hLV_Stats,% "w" A_GuiWidth-20 " h" A_GuiHeight-(coords.Y+10)
    	GuiControl, MyStats:Move,% GuiMyStats_Controls.hGB_FilteringOptions,% "w" A_GuiWidth-20

		GUI_MyStats.Redraw()
		; GuiControl, MyStats:+Redraw,% GuiMyStats_Controls.hTEXT_Borders
    }

    DragGui(GuiHwnd) {
		PostMessage, 0xA1, 2,,,% "ahk_id " GuiHwnd
	}

    Show() {
		global GuiMyStats

		hiddenWin := A_DetectHiddenWindows
		DetectHiddenWindows, On
		foundHwnd := WinExist("ahk_id " GuiMyStats.Handle)
		DetectHiddenWindows, %hiddenWin%

		GUI_MyStats.UpdateData()

		if (foundHwnd) {
			Gui, MyStats:Show, xCenter yCenter
			; GUI_MyStats.OnTabBtnClick("MyStats Main")
		}
		else {
			AppendToLogs("GUI_MYStats.Show(): Non existent. Recreating.")
			GUI_MyStats.Create()
			GUI_MyStats.Show()
		}
	}

    Close() {
		Gui, MyStats:Hide

		; TrayNotifications.Show("Recreating the Trades window with the new skin settings.")

		; UpdateHotkeys()

		; Declare_SkinAssetsAndSettings()

		; Gui_Trades.RecreateGUI()
	}

	Redraw() {
		Gui, MyStats:+LastFound
		WinSet, Redraw
	}




}