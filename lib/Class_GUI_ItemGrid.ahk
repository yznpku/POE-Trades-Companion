class GUI_ItemGrid {
/*  Function usage example:
        GUI_ItemGrid.Show(5, 2, "Shop", 0, 0, 1080)
        ^ Will show the location of an item at X5 Y2, tab name "Shop", in borderless fullscreen, with a H res of 1080 
        Make sure to always retrieve the Client height and not the window height.

    With as reference resolution 800x600
    
    Grid starts at 10x 90y
    xRoot           10 / 600 = 0,01666666666666666666666666666667
    yRoot           90 / 600 = 0.15

    A square is 29x29
    squareWRoot     29 / 600 = 0,04833333333333333333333333333333
    
    To know where the grid starts for a specific resolution, we do (xRoot * resH)
    Example. On a resolution of 1920x1080:
        The grid will start at px 18: (xRoot * 1080) = ~18
        A single square will be 52px: (squareWRoot * 1080) = 52,199 = ~52
        The grid will end at px 642: 18 + (52 * 12) = 18 + 624 = 642
        Or for a slightly more accurate result: 18 + (52,199 * 12) = 18 + 626,388 = 644,388 = ~644
        
*/
    static xRoot := 0.01666666666666666666666666666667
	static yRoot := 0.15

    static squareWRoot := 0.04833333333333333333333333333333
    static squareHRoot := 0.04833333333333333333333333333333
    static casesCountX := 12
    static casesCountY := 12

    static squareQuadWRoot := 0.04833333333333333333333333333333/2
    static squareQuadHRoot := 0.04833333333333333333333333333333/2
    static casesCountQuadX := 24
    static casesCountQuadY := 24

    static stashTabHeightRoot := 0.025 ; 0,02666666666666666666666666666667

    static gridThicc := 2
    static tabThicc := 1

    Create(gridItemX, gridItemY, gridItemTab, winX, winY, winH, winBorderSide="", winBorderTop="") {
        global PROGRAM

        ; Get default border size if unspecified
        ; SysGet, SM_CXSIZEFRAME, 32
        ; SysGet, SM_CYSIZEFRAME, 33
        ; SysGet, SM_CYCAPTION, 4
        ; winBorderTop := winBorderTop=""?SM_CYSIZEFRAME+SM_CYCAPTION : winBorderTop
        ; winBorderSide := winBorderSide=""?SM_CXSIZEFRAME : winBorderSide

        ; Set border size at 0 if unspecified (borderless)
        winBorderTop := winBorderTop?winBorderTop:0
        winBorderSide := winBorderSide?winBorderSide:0

        xStart := this.xRoot * winH, yStart := this.yRoot * winH ; Calc first case x/y start pos
        gridItemX--, gridItemY-- ; Minus one, so we can get correct case multiplier

        GUI_ItemGrid.Destroy()

        ; Only show normal tab grid if both X and Y are lower than the max case count
        if (gridItemX <= this.casesCountX) && (gridItemY <= this.casesCountY) {
            caseW := this.squareWRoot * winH, caseH := this.squareHRoot * winH ; Calc case w/h
            stashX := xStart + (gridItemX * caseW), stashY := yStart + (gridItemY * caseH) ; Calc point pos
            stashXRelative := stashX + winX, stashYRelative := stashY + winY ; Relative to win pos
            stashXRelative += winBorderSide, stashYRelative += winBorderTop ; Add win border
            pointW := caseW, pointH := caseH ; Make a square same size as stash square

            Gui, ItemGrid: -Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu
            Gui, ItemGrid:Color, EEAA99
            WinSet, TransColor, EEAA99
            Gui, ItemGrid:Add, Progress,% "x0 y0 w" pointW " h" this.gridThicc " BackgroundWhite" ; ^
            Gui, ItemGrid:Add, Progress,% "x" pointW " y0 w" this.gridThicc " h" pointH " BackgroundWhite" ; > 
            Gui, ItemGrid:Add, Progress,% "x0 y" pointH " w" pointW " h" this.gridThicc " BackgroundWhite" ; v 
            Gui, ItemGrid:Add, Progress,% "x0 y0 w" this.gridThicc " h" pointH " BackgroundWhite" ; <
            showNormalTabGrid := True 
        }
        ; Quad tab
        caseQuadW := this.squareQuadWRoot * winH, caseQuadH := this.squareQuadHRoot * winH ; Calc case w/h
        stashQuadX := xStart + (gridItemX * caseQuadW), stashQuadY := yStart + (gridItemY * caseQuadH) ; Calc point pos
        stashQuadXRelative := stashQuadX + winX, stashQuadYRelative := stashQuadY + winY ; Relative to win pos
        stashQuadXRelative += winBorderSide, stashQuadYRelative += winBorderTop ; Add win border
        pointQuadW := caseQuadW, pointQuadH := caseQuadH ; Make a square same size as stash square

        Gui, ItemGridQuad:-Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu
        Gui, ItemGridQuad:Color, EEAA99
        WinSet, TransColor, EEAA99
        Gui, ItemGridQuad:Add, Progress,% "x0 y0 w" pointQuadW " h" this.gridThicc " BackgroundWhite" ; ^
        Gui, ItemGridQuad:Add, Progress,% "x" pointQuadW " y0 w" this.gridThicc " h" pointQuadH " BackgroundWhite" ; > 
        Gui, ItemGridQuad:Add, Progress,% "x0 y" pointQuadH " w" pointQuadW " h" this.gridThicc " BackgroundWhite" ; v 
        Gui, ItemGridQuad:Add, Progress,% "x0 y0 w" this.gridThicc " h" pointQuadH " BackgroundWhite" ; <

        ; Stash tab name
        guiFont := "Fontin Regular", guiFontSize := 12
        txtSize := Get_TextCtrlSize("Tab: " gridItemTab, guiFont, guiFontSize)
        guiSizeW := txtSize.W+30, guiSizeH := txtSize.H+10
        fontColor := "d4b172", borderColor := "000000"

        stashTabHeight := this.stashTabHeightRoot*winH
        ; stashTabNameX := xStart, stashTabNameY := yStart + (this.casesCountY * caseH) + 5 ; Position: Under all cases
        stashTabNameX := xStart, stashTabNameY := yStart - (this.stashTabHeightRoot*winH) - guiSizeH - 5 ; Position: Above tabs
        stashTabNameX += winBorderSide, stashTabNameY += winBorderTop ; Add window border
        stashTabNameXRelative := stashTabNameX + winX, stashTabNameYRelative := stashTabNameY + winY ; Relative to win pos
       
        Gui, ItemGridTabName:-Border +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow -SysMenu
        Gui, ItemGridTabName:Font, S%guiFontSize%, %guiFont%
        Gui, ItemGridTabName:Color, %fontColor%
        Gui, ItemGridTabName:Add, Progress,% "x0 y0 w" guiSizeW " h" this.tabThicc " Background" borderColor ; ^
        Gui, ItemGridTabName:Add, Progress,% "x" guiSizeW-this.tabThicc " y0 w" this.tabThicc " h" guiSizeH " Background" borderColor ; > 
        Gui, ItemGridTabName:Add, Progress,% "x0 y" guiSizeH-this.tabThicc " w" guiSizeW-this.tabThicc " h" this.tabThicc " Background" borderColor ; v 
        Gui, ItemGridTabName:Add, Progress,% "x0 y0 w" this.tabThicc " h" guiSizeH " Background" borderColor ; <
        Gui, ItemGridTabName:Add, Text,% "x0 y0 cBlack Center BackgroundTrans w" guiSizeW " h" guiSizeH " 0x200",% "Tab: " gridItemTab

        if (showNormalTabGrid)
            Gui, ItemGrid:Show, x%stashXRelative% y%stashYRelative% AutoSize
        Gui, ItemGridQuad:Show, x%stashQuadXRelative% y%stashQuadYRelative% AutoSize
        Gui, ItemGridTabName:Show,% "x" stashTabNameXRelative " y" stashTabNameYRelative " w" guiSizeW " h" guiSizeH
    }

    Destroy() {
        Gui, ItemGrid:Destroy
        Gui, ItemGridQuad:Destroy
        Gui, ItemGridTabName:Destroy
    }
}
