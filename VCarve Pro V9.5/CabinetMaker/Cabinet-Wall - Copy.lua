-- VECTRIC LUA SCRIPT
require "strict"

    
    --[[    
    Notes:    
        1.  Add Projects and Cabinet logic (Done)
        2.  Remove all calculated items from Dialog (Done)
        3.  Added Dado Half and Full / Blind and Through (Done)
        4.  Add Nailer and Stretchers to Dialog (Done)
        5.  Add Logic for Nailer inside or outside (Done)
        6.  Add Cabinet Logic to do a Face Frame, Stretchers or none (Done)
        7.  Design dialog for user input (Done)
        8.  Redesign code to remover all HTML files (Done)
        9.  Change code to read text file to Draw Cabinet (Done)
        10. Add Layer Naming Configuration ...
        11. Cut the tool into 3 programs (Base Cabinet, Wall Cabinet, and Cabinet Maker) 
            a.  Cabinet Maker – manage Standard and default settings
            b.  Base Cabinet – produce Base cabinets
            c.  Wall Cabinet – produce Wall cabinets
        12. Add Cabinet naming logic (Done)
        13. Build new smaller & shorter Dialog for Cabinet build ***
        14. Build some Items on New Sheet – (Done)
        15. Build Dialog for managing the general settings/configurations
        16. Add milling logic for pockets on Nailer & Stretchers
        17. Redesign and clean up drawing code and Logic 
        18. Add Hinge center logic 
        19. Build Art work Upper and Base Cabinet details
        20. Dialog redesigns - Both wall and base cabinet
        21. Write User guide 
    ]] 
    --Global variables
    Projects = {} -- List of Projects
    Cabinets = {} -- List of Cabinets
    IniFile = {} -- List of values for the InquiryDropList
    Project = {} -- Current Project values
    BaseDim = {} -- BaseDim Project values
    BaseQuestion = {} -- BaseQuestion Project values
    Hardware = {} -- Hardware values
    Milling = {} -- Milling values
    ProjectQuestion = {} -- ProjectQuestion values
    WallDim = {} -- WallDim values
    WallQuestion = {} -- WallQuestion values
    x_DebugPlay = "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Projects\\Cabinet-Wall.log"
    g_FullDialog = "Short Dialog"
    x_DebugMsg = 4 -- (0 = off), (1,2,3,4,5,6,7,8,9 = will show that value and any lesser), (-1,-2,-3,-4... will only show that number value)
    x_DebugLog = true
    x_DebugClear = true
    x_ShowMe = true   
    x_LogPath = ""
    lay = ""    
-- ===================================================
-- Calculated Values
    g_boxHight = 0.0000 ; g_boxLength = 0.0000 ; g_boxDepth = 0.0000 ; 
    g_backHight = 0.0000 ; g_backWidth = 0.0000 ; g_PartGap = 0.5 ; 
    g_pt1 = Point2D(1,1) ; g_pt2 = Point2D(20,1) ; g_pt3 = Point2D(40,1) ; 
    g_pt4 = Point2D(14,1) ; g_pt5 = Point2D(14,34) ; g_pt6 = Point2D(30,1) ;     
    g_pt7 = Point2D(30,34) ; g_pt8 = Point2D(45,1) ; 
-- <><><><><><><><><><><><><><><><><><><><><><><><><><>
-- <>================ Debug Tools ==================<>
-- <>================================================<>
    function DeBug(id, lev, txt) -- Debugger tool
        local NowX = "[" .. os.date("%b %d, %Y") .. " - " ..os.date("%H") .. ":" .. os.date("%m") ..":".. os.date("%S") .. "]"
        if x_DebugClear then 
            local file = io.open(x_DebugPlay, "w") ; 
            file:write("=============================================\n") ; 
            file:write("=========== " .. os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p") .. " ============\n") ; 
            file:write("=============================================\n") ; 
            file:close() -- closes the open file 
            x_DebugClear = false
        end
        -- return true
        if x_DebugLog then
            local file = io.open(x_DebugPlay, "a") ; 
                if x_DebugMsg >= 1 then   
                    if lev <= x_DebugMsg then   
                       --DisplayMessageBox(tostring(txt))
                       file:write( NowX .." [" .. tostring(lev) .. "] [" .. tostring(id) .. "] ".. tostring(txt) .. "\n") ;
                    end
                else 
                    if lev == math.abs(g_DebugMsg) then   
                        --DisplayMessageBox(tostring(txt))
                         file:write( NowX .." [" .. tostring(id) .. "]  " .. tostring(txt) .. "\n") ;
                    end
                end
            file:close()-- closes the open file 
        else
            if x_DebugMsg >= -1 then   
                if lev <= x_DebugMsg then   
                   DisplayMessageBox(tostring(id) .. "-" .. tostring(txt))
                end
            else 
                if lev == math.abs(g_DebugMsg) then   
                    DisplayMessageBox(tostring(id) .. "-" .. tostring(txt))
                end
            end
        end
    end
-- ===================================================
    function ShowMe()
       DeBug(9250,1, "ShowMe-")
    if x_ShowMe then
       DeBug(9250, 2, "ShowMe-BaseDim.BackPocketDepthBase = " .. tostring(BaseDim.BackPocketDepthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.BlindDadoSetbackBase = " .. tostring(BaseDim.BlindDadoSetbackBase))
       DeBug(9250, 2, "ShowMe-BaseDim.CabDepthBase = " .. tostring(BaseDim.CabDepthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.CabHeightBase = " .. tostring(BaseDim.CabHeightBase))
       DeBug(9250, 2, "ShowMe-BaseDim.CabWidthBase = " .. tostring(BaseDim.CabWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameBottomRailWidthBase = " .. tostring(BaseDim.FaceFrameBottomRailWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameBottomRevealBase = " .. tostring(BaseDim.FaceFrameBottomRevealBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameCenterStileWidthBase = " .. tostring(BaseDim.FaceFrameCenterStileWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameRevealBase = " .. tostring(BaseDim.FaceFrameRevealBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameStileWidthBase = " .. tostring(BaseDim.FaceFrameStileWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameThicknessBase = " .. tostring(BaseDim.FaceFrameThicknessBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameTopOverlapBase = " .. tostring(BaseDim.FaceFrameTopOverlapBase))
       DeBug(9250, 2, "ShowMe-BaseDim.FaceFrameTopRailWidthBase = " .. tostring(BaseDim.FaceFrameTopRailWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.NailerThicknessBase = " .. tostring(BaseDim.NailerThicknessBase))
       DeBug(9250, 2, "ShowMe-BaseDim.NailerWidthBase = " .. tostring(BaseDim.NailerWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.RevealBase = " .. tostring(BaseDim.RevealBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfCountBase = " .. tostring(BaseDim.ShelfCountBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfEndClarenceBase = " .. tostring(BaseDim.ShelfEndClarenceBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfFaceFrameThicknessBase = " .. tostring(BaseDim.ShelfFaceFrameThicknessBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfFaceFrameWidthBase = " .. tostring(BaseDim.ShelfFaceFrameWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfFrontClearanceBase = " .. tostring(BaseDim.ShelfFrontClearanceBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfHoleFirstRowSpacingBase = " .. tostring(BaseDim.ShelfHoleFirstRowSpacingBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfHoleLastRowSpacingBase = " .. tostring(BaseDim.ShelfHoleLastRowSpacingBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfHoleSpacingBase = " .. tostring(BaseDim.ShelfHoleSpacingBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfMaterialThicknessBase = " .. tostring(BaseDim.ShelfMaterialThicknessBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfPinHoleBackBase = " .. tostring(BaseDim.ShelfPinHoleBackBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ShelfPinHoleFrontBase = " .. tostring(BaseDim.ShelfPinHoleFrontBase))
       DeBug(9250, 2, "ShowMe-BaseDim.StretcherThicknessBase = " .. tostring(BaseDim.StretcherThicknessBase))
       DeBug(9250, 2, "ShowMe-BaseDim.StretcherWidthBase = " .. tostring(BaseDim.StretcherWidthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ThicknessBackBase = " .. tostring(BaseDim.ThicknessBackBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ThicknessBase = " .. tostring(BaseDim.ThicknessBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ToeKickBottomOffsetHightBase = " .. tostring(BaseDim.ToeKickBottomOffsetHightBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ToeKickDepthBase = " .. tostring(BaseDim.ToeKickDepthBase))
       DeBug(9250, 2, "ShowMe-BaseDim.ToeKickHightBase = " .. tostring(BaseDim.ToeKickHightBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddBackNailerBase = " .. tostring(BaseQuestion.AddBackNailerBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddCenterPanelBase = " .. tostring(BaseQuestion.AddCenterPanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddFaceFrameBase = " .. tostring(BaseQuestion.AddFaceFrameBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddShelfHingPilotHolesBase = " .. tostring(BaseQuestion.AddShelfHingPilotHolesBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddShelfHolesBase = " .. tostring(BaseQuestion.AddShelfHolesBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddShelfingBase = " .. tostring(BaseQuestion.AddShelfingBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddStretchersBase = " .. tostring(BaseQuestion.AddStretchersBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.AddToeKickBase = " .. tostring(BaseQuestion.AddToeKickBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.BackDadoOrOverlapBase = " .. tostring(BaseQuestion.BackDadoOrOverlapBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DadoStyleBase = " .. tostring(BaseQuestion.DadoStyleBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DadoTypeBase = " .. tostring(BaseQuestion.DadoTypeBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawBackPanelBase = " .. tostring(BaseQuestion.DrawBackPanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawBackPanelOnNewSheetBase = " .. tostring(BaseQuestion.DrawBackPanelOnNewSheetBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawBottomPanelBase = " .. tostring(BaseQuestion.DrawBottomPanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawCenterPanelBase = " .. tostring(BaseQuestion.DrawCenterPanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawFaceFrameBase = " .. tostring(BaseQuestion.DrawFaceFrameBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawFaceFrameOnNewSheetBase = " .. tostring(BaseQuestion.DrawFaceFrameOnNewSheetBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawLeftSidePanelBase = " .. tostring(BaseQuestion.DrawLeftSidePanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawRightSidePanelBase = " .. tostring(BaseQuestion.DrawRightSidePanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawShelfPanelBase = " .. tostring(BaseQuestion.DrawShelfPanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.DrawTopPanelBase = " .. tostring(BaseQuestion.DrawTopPanelBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.FaceFrameOrStretchersBase = " .. tostring(BaseQuestion.FaceFrameOrStretchersBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.NailerLocationBase = " .. tostring(BaseQuestion.NailerLocationBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.ProvideCabinetNotesOnDrawingBase = " .. tostring(BaseQuestion.ProvideCabinetNotesOnDrawingBase))
       DeBug(9250, 2, "ShowMe-BaseQuestion.ProvideCabinetNotesOnNewSheetBase = " .. tostring(BaseQuestion.ProvideCabinetNotesOnNewSheetBase))
       DeBug(9250, 2, "ShowMe-Hardware.HingBottomClearnace = " .. tostring(Hardware.HingBottomClearnace))
       DeBug(9250, 2, "ShowMe-Hardware.HingCountBase = " .. tostring(Hardware.HingCountBase))
       DeBug(9250, 2, "ShowMe-Hardware.HingCountWall = " .. tostring(Hardware.HingCountWall))
       DeBug(9250, 2, "ShowMe-Hardware.HingHoleCenters = " .. tostring(Hardware.HingHoleCenters))
       DeBug(9250, 2, "ShowMe-Hardware.HingTopClearnace = " .. tostring(Hardware.HingTopClearnace))
       DeBug(9250, 2, "ShowMe-Hardware.ShelfPinDiameter = " .. tostring(Hardware.ShelfPinDiameter))
       DeBug(9250, 2, "ShowMe-Milling.DadoClearnace = " .. tostring(Milling.DadoClearnace))
       DeBug(9250, 2, "ShowMe-Milling.DadoToolDia = " .. tostring(Milling.DadoToolDia))
       DeBug(9250, 2, "ShowMe-Milling.HalfDadoWidth = " .. tostring(Milling.HalfDadoWidth))
       DeBug(9250, 2, "ShowMe-Milling.PilotBitDia = " .. tostring(Milling.PilotBitDia))
       DeBug(9250, 2, "ShowMe-Milling.PocketToolDia = " .. tostring(Milling.PocketToolDia))
       DeBug(9250, 2, "ShowMe-Milling.ProfileToolDia = " .. tostring(Milling.ProfileToolDia))
       DeBug(9250, 2, "ShowMe-Milling.RabbitClearing = " .. tostring(Milling.RabbitClearing))
       DeBug(9250, 2, "ShowMe-Milling.SidePocketDepth = " .. tostring(Milling.SidePocketDepth))
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideProfile = " .. tostring(Milling.LayerNameSideProfile))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameShelfProfile = " .. tostring(Milling.LayerNameShelfProfile))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameBackProfile = " .. tostring(Milling.LayerNameBackProfile))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameTopBottomProfile = " .. tostring(Milling.LayerNameTopBottomProfile))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameCenterPanleProfile = " .. tostring(Milling.LayerNameCenterPanleProfile))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideTopBottomPocket = " .. tostring(Milling.LayerNameSideTopBottomPocket))              
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideBackPocket = " .. tostring(Milling.LayerNameSideBackPocket))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideStretcherPocket = " .. tostring(Milling.LayerNameSideStretcherPocket))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideNailerPocket = " .. tostring(Milling.LayerNameSideNailerPocket))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideShelfPinDrill = " .. tostring(Milling.LayerNameSideShelfPinDrill))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameSideHingCentersDrill = " .. tostring(Milling.LayerNameSideHingCentersDrill))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameCenterPanleShelfPinDrill = " .. tostring(Milling.LayerNameCenterPanleShelfPinDrill))                
       DeBug(9250, 2, "ShowMe-Milling.LayerNameBackPocket = " .. tostring(Milling.LayerNameBackPocket))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameTopBottomCenterDado = " .. tostring(Milling.LayerNameTopBottomCenterDado))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameDrawNotes = " .. tostring(Milling.LayerNameDrawNotes))       
       DeBug(9250, 2, "ShowMe-Milling.LayerNameDrawFaceFrame = " .. tostring(Milling.LayerNameDrawFaceFrame))       
--     DeBug(9250, 2, "ShowMe-ProjectQuestion.AddCabinetSettingsToProject = " .. tostring(ProjectQuestion.AddCabinetSettingsToProject))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.CabinetName = " .. tostring(ProjectQuestion.CabinetName))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.ProjectContactEmail = " .. tostring(ProjectQuestion.ProjectContactEmail))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.ProjectContactName = " .. tostring(ProjectQuestion.ProjectContactName))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.ProjectContactPhoneNumber = " .. tostring(ProjectQuestion.ProjectContactPhoneNumber))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.ProjectName = " .. tostring(ProjectQuestion.ProjectName))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.ProjectPath = " .. tostring(ProjectQuestion.ProjectPath))
       DeBug(9250, 2, "ShowMe-ProjectQuestion.StartDate = " .. tostring(ProjectQuestion.StartDate))
       DeBug(9250, 2, "ShowMe-WallDim.BackPocketDepthWall = " .. tostring(WallDim.BackPocketDepthWall))
       DeBug(9250, 2, "ShowMe-WallDim.BlindDadoSetbackWall = " .. tostring(WallDim.BlindDadoSetbackWall))
       DeBug(9250, 2, "ShowMe-WallDim.CabDepthWall = " .. tostring(WallDim.CabDepthWall))
       DeBug(9250, 2, "ShowMe-WallDim.CabHeightWall = " .. tostring(WallDim.CabHeightWall))
       DeBug(9250, 2, "ShowMe-WallDim.CabLengthWall = " .. tostring(WallDim.CabLengthWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameBottomRailWidthWall = " .. tostring(WallDim.FaceFrameBottomRailWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameBottomRevealWall = " .. tostring(WallDim.FaceFrameBottomRevealWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameCenterStileWidthWall = " .. tostring(WallDim.FaceFrameCenterStileWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameRevealWall = " .. tostring(WallDim.FaceFrameRevealWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameStileWidthWall = " .. tostring(WallDim.FaceFrameStileWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameThicknessWall = " .. tostring(WallDim.FaceFrameThicknessWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameTopOverlapWall = " .. tostring(WallDim.FaceFrameTopOverlapWall))
       DeBug(9250, 2, "ShowMe-WallDim.FaceFrameTopRailWidthWall = " .. tostring(WallDim.FaceFrameTopRailWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.NailerThicknessWall = " .. tostring(WallDim.NailerThicknessWall))
       DeBug(9250, 2, "ShowMe-WallDim.NailerWidthWall = " .. tostring(WallDim.NailerWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.RevealWall = " .. tostring(WallDim.RevealWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfCountWall = " .. tostring(WallDim.ShelfCountWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfEndClarenceWall = " .. tostring(WallDim.ShelfEndClarenceWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfFaceFrameRevealWall = " .. tostring(WallDim.ShelfFaceFrameRevealWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfFaceFrameThicknessWall = " .. tostring(WallDim.ShelfFaceFrameThicknessWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfFaceFrameWidthWall = " .. tostring(WallDim.ShelfFaceFrameWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfFrontClearanceWall = " .. tostring(WallDim.ShelfFrontClearanceWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfHoleFirstRowSpacingWall = " .. tostring(WallDim.ShelfHoleFirstRowSpacingWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfHoleLastRowSpacingWall = " .. tostring(WallDim.ShelfHoleLastRowSpacingWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfHoleSpacingWall = " .. tostring(WallDim.ShelfHoleSpacingWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfMaterialThicknessWall = " .. tostring(WallDim.ShelfMaterialThicknessWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfPinHoleBackWall = " .. tostring(WallDim.ShelfPinHoleBackWall))
       DeBug(9250, 2, "ShowMe-WallDim.ShelfPinHoleFrontWall = " .. tostring(WallDim.ShelfPinHoleFrontWall))
       DeBug(9250, 2, "ShowMe-WallDim.StretcherThicknessWall = " .. tostring(WallDim.StretcherThicknessWall))
       DeBug(9250, 2, "ShowMe-WallDim.StretcherWidthWall = " .. tostring(WallDim.StretcherWidthWall))
       DeBug(9250, 2, "ShowMe-WallDim.ThicknessBackWall = " .. tostring(WallDim.ThicknessBackWall))
       DeBug(9250, 2, "ShowMe-WallDim.ThicknessWall = " .. tostring(WallDim.ThicknessWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddBackNailerWall = " .. tostring(WallQuestion.AddBackNailerWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddCenterPanelWall = " .. tostring(WallQuestion.AddCenterPanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddFaceFrameWall = " .. tostring(WallQuestion.AddFaceFrameWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddShelfHingPilotHolesWall = " .. tostring(WallQuestion.AddShelfHingPilotHolesWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddShelfHolesWall = " .. tostring(WallQuestion.AddShelfHolesWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddShelfingWall = " .. tostring(WallQuestion.AddShelfingWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.AddStretchersWall = " .. tostring(WallQuestion.AddStretchersWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.BackDadoOrOverlapWall = " .. tostring(WallQuestion.BackDadoOrOverlapWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DadoStyleWall = " .. tostring(WallQuestion.DadoStyleWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DadoTypeWall = " .. tostring(WallQuestion.DadoTypeWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawBackPanelOnNewSheetWall = " .. tostring(WallQuestion.DrawBackPanelOnNewSheetWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawBackPanelWall = " .. tostring(WallQuestion.DrawBackPanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawBottomPanelWall = " .. tostring(WallQuestion.DrawBottomPanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawCenterPanelWall = " .. tostring(WallQuestion.DrawCenterPanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawFaceFrameOnNewSheetWall = " .. tostring(WallQuestion.DrawFaceFrameOnNewSheetWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawFaceFrameWall = " .. tostring(WallQuestion.DrawFaceFrameWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawLeftSidePanelWall = " .. tostring(WallQuestion.DrawLeftSidePanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawRightSidePanelWall = " .. tostring(WallQuestion.DrawRightSidePanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawShelfPanelWall = " .. tostring(WallQuestion.DrawShelfPanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.DrawTopPanelWall = " .. tostring(WallQuestion.DrawTopPanelWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.FaceFrameOrStretchersWall = " .. tostring(WallQuestion.FaceFrameOrStretchersWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.NailerLocationWall = " .. tostring(WallQuestion.NailerLocationWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.ProvideCabinetNotesOnDrawingWall = " .. tostring(WallQuestion.ProvideCabinetNotesOnDrawingWall))
       DeBug(9250, 2, "ShowMe-WallQuestion.ProvideCabinetNotesOnNewSheetWall = " .. tostring(WallQuestion.ProvideCabinetNotesOnNewSheetWall))
    end
end 
-- ===================================================
    function ProjectBackup(xPath)

    local filename = xPath .. "/CabinetBackup.cmd"
    local file = io.open(filename, "w")
    local NowX = NowName()
    file:write("echo ================================================================================ \n") ;
    file:write("echo CabinetMaker \n") ;
    file:write("echo on \n") ;
--  file:write("cd CabinetMaker \n") ;
--  file:write("cd Projects \n") ;  
 
    file:write("cd _Backup \n") ; 
    file:write("mkdir " .. NowX .. " \n") ;  
    file:write("cd \\ \n") ; 
    file:write("echo ================================================================================= \n")
    file:write("echo ========= CabinetMaker.ini ====================================================== \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\CabinetMaker.ini" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ========= Test.lua ============================================================== \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Test.lua" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ========= MakeBackUp.lua ======================================================== \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\MakeBackUp.lua" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ========= CabinetMaker.htm ====================================================== \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\CabinetMaker.htm" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ======== CabinetProjects.ini ==================================================== \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\CabinetProjects.ini" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ======== CabinetMaker.lua ======================================================= \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\CabinetMaker.lua" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ======== Cabinet-Wall.lua ======================================================= \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Cabinet-Wall.lua" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ====== Cabinet-Base.lua ========================================================= \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Cabinet-Base.lua" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ======== Cabinet-Base.ini ======================================================= \n")
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Cabinet-Base.ini" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ============= Cabinet-Base.lua ================================================== \n") 
    file:write("copy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Cabinet-Base.lua" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\" .. string.char(34) .. " \n")
    file:write("echo ================================================================================= \n")
    file:write("echo ============= Projects ========================================================== \n") 
    file:write("xcopy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Projects" .. string.char(34) .. " " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\_Backup\\" .. NowX .. "\\Projects\\" .. string.char(34) .. " /d/e/y \n")
    file:write("echo ================================================================================= \n")
    file:write("pause \n") ;
    file:close()-- closes the open file 
    return true  
    end
-- ===================================================

-- <><><><><><><><><><><><><><><><><><><><><><><><><><>
--[[-- Not used-- 
function fileWriter(datFile) -- Not used-- Writes values a InI style file for testing
       DeBug(9310,1, "fileWriter")
    local file = io.open(datFile, "w")
-- write line of the file
    file:write("#============================================ == = = \n") ; 
    file:write("# Standard Cabinet Configuration File \n") ; 
    file:write("#============================================ == = = \n") ; 
    file:write("[DEFAULT]\n") ; 
    file:write("WallDim.ThicknessBackWall = " .. WallDim.ThicknessBackWall .. " \n") ; 
    file:write("WallDim.ThicknessWall = " .. WallDim.ThicknessWall .. " \n") ; 
    file:write("WallDim.CabLengthWall = " .. WallDim.CabLengthWall .. " \n") ; 
    file:write("WallDim.CabHeightWall = " .. WallDim.CabHeightWall .. " \n") ; 
    file:write("WallDim.CabDepthWall = " .. WallDim.CabDepthWall .. " \n") ; 
    file:write("WallDim.BlindDadoSetbackWall = " .. WallDim.BlindDadoSetbackWall .. " \n") ; 
    file:write("Milling.SidePocketDepth = " .. Milling.SidePocketDepth .. " \n") ; 
    file:write("WallDim.BackPocketDepthWall = " .. WallDim.BackPocketDepthWall .. " \n") ;       
    file:write("WallDim.DadoTypeWall = " .. WallDim.DadoTypeWall .. " \n") ; 
    file:write("WallQuestion.AddFaceFrameWall = " .. BtoS(WallQuestion.AddFaceFrameWall) .. " \n") ; 
    file:write("WallQuestion.AddShelfingWall = " .. BtoS(WallQuestion.AddShelfingWall) .. " \n") ; 
    file:write("WallQuestion.AddCenterFaceFrame = " .. BtoS(WallQuestion.AddCenterFaceFrame) .. " \n") ; 
    file:write("WallQuestion.AddCenterPanelWall = " .. BtoS(WallQuestion.AddCenterPanelWall) .. " \n") ; 
    file:write("WallQuestion.AddBackNailerWall = " .. BtoS(WallQuestion.AddBackNailerWall) .. " \n") ; 
    file:write("WallQuestion.AddStretchersWall = " .. BtoS(WallQuestion.AddStretchersWall) .. " \n");    
    file:write("WallDim.NailerThicknessWall = " .. WallDim.NailerThicknessWall .. " \n") ; 
    file:write("WallDim.NailerWidthWall = " .. WallDim.NailerWidthWall .. " \n") ; 
    file:write("WallDim.ShelfEndClarenceWall = " .. WallDim.ShelfEndClarenceWall .. " \n") ; 
    file:write("Hardware.PinDiameter = " .. Hardware.PinDiameter .. " \n") ;    
    file:write("WallDim.ShelfCountWall = " .. WallDim.ShelfCountWall .. " \n") ; 
    file:write("WallDim.FaceFrameRevealWall = " .. WallDim.FaceFrameRevealWall .. " \n") ; 
    file:write("WallDim.WidthClearanceWall = " .. WallDim.WidthClearanceWall .. " \n") ; 
    file:write("WallDim.FaceFrameWidthWall = " .. WallDim.FaceFrameWidthWall .. " \n") ; 
    file:write("WallDim.FaceFrameThicknessWall = " .. WallDim.FaceFrameThicknessWall .. " \n") ; 
    file:write("WallDim.ShelfPinHoleFrontWall = " .. WallDim.ShelfPinHoleFrontWall .. " \n") ; 
    file:write("WallDim.ShelfPinHoleBackWall = " .. WallDim.ShelfPinHoleBackWall .. " \n") ; 
    file:write("WallDim.ShelfHoleSpacingWall = " .. WallDim.ShelfHoleSpacingWall .. " \n") ; 
    file:write("WallDim.ShelfHoleFirstRowSpacingWall = " .. WallDim.ShelfHoleFirstRowSpacingWall .. " \n") ; 
    file:write("WallDim.ShelfHoleLastRowSpacingWall = " .. WallDim.ShelfHoleLastRowSpacingWall .. " \n") ; 
    file:write("WallDim.PartLengthWall = " .. WallDim.PartLength .. " \n") ; 
    file:write("WallDim.PartDepthWall = " .. WallDim.PartDepth .. " \n") ; 
    file:write("WallDim.ShelfMaterialThicknessWall = " .. WallDim.ShelfMaterialThicknessWall .. " \n") ; 
    file:write("Milling.RabbitClearing = " .. Milling.RabbitClearing .. " \n") ; 
    file:write("Milling.PocketToolDia = " .. Milling.PocketToolDia .. " \n") ; 
    file:write("Milling.RabbitClearing = " .. Milling.RabbitClearing .. " \n") ;    
    file:write("ProjectQuestion.ProjectContactEmail = " .. ProjectQuestion.ProjectContactEmail .. " \n") ; 
    file:write("ProjectQuestion.ProjectName = " .. ProjectQuestion.ProjectName .. " \n") ; 
    file:write("ProjectQuestion.CabinetName = " .. ProjectQuestion.CabinetName .. " \n") ; 
    file:write("ProjectQuestion.Profile = " .. ProjectQuestion.Profile .. " \n") ;      
    file:write("ProjectQuestion.ProgramTitle = " .. ProjectQuestion.ProgramTitle .. " \n") ;  
    file:write("ProjectQuestion.ProgramVersion = " .. ProjectQuestion.ProgramVersion .. " \n") ;   
    file:write("ProjectQuestion.CodeBy = " .. ProjectQuestion.CodeBy .. " \n") ;  
    file:write("ProjectQuestion.ProjectPath = " .. ProjectQuestion.ProjectPath .. " \n") ; 
    file:write("ProjectQuestion.ProgramName = " .. ProjectQuestion.ProgramName .. " \n") ;   
    file:write("ProjectQuestion.Contact = " .. ProjectQuestion.Contact .. " \n") ;  
    file:write("ProjectQuestion.Year = " .. ProjectQuestion.Year .. " \n") ; 
    file:write("ProjectQuestion.ProjectContactName = " .. ProjectQuestion.ProjectContactName .. " \n") ; 
    file:write("ProjectQuestion.ProjectContactPhoneNumber = " .. ProjectQuestion.ProjectContactPhoneNumber .. " \n") ; 
    file:write("ProjectQuestion.StartDate = " .. ProjectQuestion.StartDate .. " \n") ;    
    file:write("WallQuestion.DrawFaceFrameWall = " .. BtoS(WallQuestion.DrawFaceFrameWall) .. " \n") ; 
    file:write("WallDwg.DrawBackPanelWall = " .. BtoS(WallDwg.DrawBackPanelWall) .. " \n") ; 
    file:write("WallDwg.DrawRightSidePanelWall = " .. BtoS(WallDwg.DrawRightSidePanelWall) .. " \n") ; 
    file:write("WallDwg.DrawLeftSidePanelWall = " .. BtoS(WallDwg.DrawLeftSidePanelWall) .. " \n") ; 
    file:write("WallQuestion.DrawTopPanelWall = " .. BtoS(WallQuestion.DrawTopPanelWall) .. " \n") ; 
    file:write("WallDwg.DrawBottomPanelWall = " .. BtoS(WallDwg.DrawBottomPanelWall) .. " \n") ; 
    file:write("WallQuestion.DrawCenterPanelWall = " .. BtoS(WallQuestion.DrawCenterPanelWall) .. " \n") ; 
    file:write("WallQuestion.ProvideCabinetNotesOnDrawingWall = " .. BtoS(WallQuestion.ProvideCabinetNotesOnDrawingWall) .. " \n") ; 
    file:write("WallQuestion.DrawShelfPanelWall = " .. BtoS(WallQuestion.DrawShelfPanelWall) .. " \n") ; 
    file:write("WallDim.FaceFrameRevealWall = " .. WallDim.FaceFrameRevealWall .. " \n") ; 
    file:write("WallDim.FaceFrameThicknessWall = " .. WallDim.FaceFrameThicknessWall .. " \n") ; 
    file:write("WallDim.StileWidthWall = " .. WallDim.StileWidthWall .. " \n") ; 
    file:write("WallDim.BottomRailWidthWall = " .. WallDim.BottomRailWidthWall .. " \n") ; 
    file:write("WallDim.TopRailWidthWall = " .. WallDim.TopRailWidthWall .. " \n") ; 
    file:write("WallDim.CenterStileWidthWall = " .. WallDim.CenterStileWidthWall .. " \n") ; 
    file:write("WallDim.BottomFaceFrameReveal = " .. WallDim.BottomFaceFrameReveal .. " \n") ; 
    file:write("WallDim.TopOverlapWall = " .. WallDim.TopOverlapWall .. " \n") ; 
    file:write("WallDim.StileLength = " .. WallDim.StileLength .. " \n") ; 
    file:write("WallDim.RailLength = " .. WallDim.RailLength .. " \n") ; 
    file:write("WallDim.CenterStileLength = " .. WallDim.CenterStileLength .. " \n") ; 
    file:write("Variables.g_boxHight = " .. g_boxHight .. " \n") ; 
    file:write("Variables.g_boxLength = " .. g_boxLength .. " \n") ; 
    file:write("Variables.g_boxDepth = " .. g_boxDepth .. " \n") ; 
    file:write("Variables.g_backHight = " .. g_backHight .. " \n") ; 
    file:write("Variables.g_backWidth = " .. g_backWidth .. " \n") ; 
    file:close()-- closes the open file 
    return true  
end
-- ===================================================
function AllValuesWriter() -- file for testing Debugging
       DeBug(9320,1, "AllValuesWriter")
    local file = io.open("E:/Cabinet.dat", "w")
-- write line of the file
    file:write("#============================================ == = = \n") ; 
    file:write("# Testing Values File \n") ; 
    file:write("#============================================ == = = \n") ; 
    file:write("BaseDim.BackPocketDepthBase = " .. BaseDim.BackPocketDepthBase .. " \n") ;
    file:write("BaseDim.BlindDadoSetbackBase = " .. BaseDim.BlindDadoSetbackBase .. " \n") ;
    file:write("BaseDim.CabDepthBase = " .. BaseDim.CabDepthBase .. " \n") ;
    file:write("BaseDim.CabHeightBase = " .. BaseDim.CabHeightBase .. " \n") ;
    file:write("BaseDim.CabWidthBase = " .. BaseDim.CabWidthBase .. " \n") ;
    file:write("BaseDim.FaceFrameBottomRailWidthBase = " .. BaseDim.FaceFrameBottomRailWidthBase .. " \n") ;
    file:write("BaseDim.FaceFrameBottomRevealBase = " .. BaseDim.FaceFrameBottomRevealBase .. " \n") ;
    file:write("BaseDim.FaceFrameCenterStileWidthBase = " .. BaseDim.FaceFrameCenterStileWidthBase .. " \n") ;
    file:write("BaseDim.FaceFrameRevealBase = " .. BaseDim.FaceFrameRevealBase .. " \n") ;
    file:write("BaseDim.FaceFrameStileWidthBase = " .. BaseDim.FaceFrameStileWidthBase .. " \n") ;
    file:write("BaseDim.FaceFrameThicknessBase = " .. BaseDim.FaceFrameThicknessBase .. " \n") ;
    file:write("BaseDim.FaceFrameTopOverlapBase = " .. BaseDim.FaceFrameTopOverlapBase .. " \n") ;
    file:write("BaseDim.FaceFrameTopRailWidthBase = " .. BaseDim.FaceFrameTopRailWidthBase .. " \n") ;
    file:write("BaseDim.NailerThicknessBase = " .. BaseDim.NailerThicknessBase .. " \n") ;
    file:write("BaseDim.NailerWidthBase = " .. BaseDim.NailerWidthBase .. " \n") ;
    file:write("BaseDim.RevealBase = " .. BaseDim.RevealBase .. " \n") ;
    file:write("BaseDim.ShelfCountBase = " .. BaseDim.ShelfCountBase .. " \n") ;
    file:write("BaseDim.ShelfEndClarenceBase = " .. BaseDim.ShelfEndClarenceBase .. " \n") ;
    file:write("BaseDim.ShelfFaceFrameThicknessBase = " .. BaseDim.ShelfFaceFrameThicknessBase .. " \n") ;
    file:write("BaseDim.ShelfFaceFrameWidthBase = " .. BaseDim.ShelfFaceFrameWidthBase .. " \n") ;
    file:write("BaseDim.ShelfFrontClearanceBase = " .. BaseDim.ShelfFrontClearanceBase .. " \n") ;
    file:write("BaseDim.ShelfHoleFirstRowSpacingBase = " .. BaseDim.ShelfHoleFirstRowSpacingBase .. " \n") ;
    file:write("BaseDim.ShelfHoleLastRowSpacingBase = " .. BaseDim.ShelfHoleLastRowSpacingBase .. " \n") ;
    file:write("BaseDim.ShelfHoleSpacingBase = " .. BaseDim.ShelfHoleSpacingBase .. " \n") ;
    file:write("BaseDim.ShelfMaterialThicknessBase = " .. BaseDim.ShelfMaterialThicknessBase .. " \n") ;
    file:write("BaseDim.ShelfPinHoleBackBase = " .. BaseDim.ShelfPinHoleBackBase .. " \n") ;
    file:write("BaseDim.ShelfPinHoleFrontBase = " .. BaseDim.ShelfPinHoleFrontBase .. " \n") ;
    file:write("BaseDim.StretcherThicknessBase = " .. BaseDim.StretcherThicknessBase .. " \n") ;
    file:write("BaseDim.StretcherWidthBase = " .. BaseDim.StretcherWidthBase .. " \n") ;
    file:write("BaseDim.ThicknessBackBase = " .. BaseDim.ThicknessBackBase .. " \n") ;
    file:write("BaseDim.ThicknessBase = " .. BaseDim.ThicknessBase .. " \n") ;
    file:write("BaseDim.ToeKickBottomOffsetHightBase = " .. BaseDim.ToeKickBottomOffsetHightBase .. " \n") ;
    file:write("BaseDim.ToeKickDepthBase = " .. BaseDim.ToeKickDepthBase .. " \n") ;
    file:write("BaseDim.ToeKickHightBase = " .. BaseDim.ToeKickHightBase .. " \n") ;
    file:write("BaseQuestion.AddBackNailerBase = " .. BaseQuestion.AddBackNailerBase .. " \n") ;
    file:write("BaseQuestion.AddCenterPanelBase = " .. BaseQuestion.AddCenterPanelBase .. " \n") ;
    file:write("BaseQuestion.AddFaceFrameBase = " .. BaseQuestion.AddFaceFrameBase .. " \n") ;
    file:write("BaseQuestion.AddShelfHingPilotHolesBase = " .. BaseQuestion.AddShelfHingPilotHolesBase .. " \n") ;
    file:write("BaseQuestion.AddShelfHolesBase = " .. BaseQuestion.AddShelfHolesBase .. " \n") ;
    file:write("BaseQuestion.AddShelfingBase = " .. BaseQuestion.AddShelfingBase .. " \n") ;
    file:write("BaseQuestion.AddStretchersBase = " .. BaseQuestion.AddStretchersBase .. " \n") ;
    file:write("BaseQuestion.AddToeKickBase = " .. BaseQuestion.AddToeKickBase .. " \n") ;
    file:write("BaseQuestion.BackDadoOrOverlapBase = " .. BaseQuestion.BackDadoOrOverlapBase .. " \n") ;
    file:write("BaseQuestion.DadoStyleBase = " .. BaseQuestion.DadoStyleBase .. " \n") ;
    file:write("BaseQuestion.DadoTypeBase = " .. BaseQuestion.DadoTypeBase .. " \n") ;
    file:write("BaseQuestion.DrawBackPanelBase = " .. BaseQuestion.DrawBackPanelBase .. " \n") ;
    file:write("BaseQuestion.DrawBackPanelOnNewSheetBase = " .. BaseQuestion.DrawBackPanelOnNewSheetBase .. " \n") ;
    file:write("BaseQuestion.DrawBottomPanelBase = " .. BaseQuestion.DrawBottomPanelBase .. " \n") ;
    file:write("BaseQuestion.DrawCenterPanelBase = " .. BaseQuestion.DrawCenterPanelBase .. " \n") ;
    file:write("BaseQuestion.DrawFaceFrameBase = " .. BaseQuestion.DrawFaceFrameBase .. " \n") ;
    file:write("BaseQuestion.DrawFaceFrameOnNewSheetBase = " .. BaseQuestion.DrawLeftSidePanelBase .. " \n") ;
    file:write("BaseQuestion.DrawLeftSidePanelBase = " .. BaseQuestion.DrawLeftSidePanelBase .. " \n") ;
    file:write("BaseQuestion.DrawRightSidePanelBase = " .. BaseQuestion.DrawRightSidePanelBase .. " \n") ;
    file:write("BaseQuestion.DrawShelfPanelBase = " .. BaseQuestion.DrawShelfPanelBase .. " \n") ;
    file:write("BaseQuestion.DrawTopPanelBase = " .. BaseQuestion.DrawTopPanelBase .. " \n") ;
    file:write("BaseQuestion.FaceFrameOrStretchersBase = " .. BaseQuestion.FaceFrameOrStretchersBase .. " \n") ;
    file:write("BaseQuestion.NailerLocationBase = " .. BaseQuestion.NailerLocationBase .. " \n") ;
    file:write("BaseQuestion.ProvideCabinetNotesOnDrawingBase = " .. BaseQuestion.ProvideCabinetNotesOnDrawingBase .. " \n") ;
    file:write("BaseQuestion.ProvideCabinetNotesOnNewSheetBase = " .. BaseQuestion.ProvideCabinetNotesOnNewSheetBase .. " \n") ;
    file:write("Hardware.HingBottomClearnace = " .. Hardware.HingBottomClearnace .. " \n") ;
    file:write("Hardware.HingCountBase = " .. Hardware.HingCountBase .. " \n") ;
    file:write("Hardware.HingCountWall = " .. Hardware.HingCountWall .. " \n") ;
    file:write("Hardware.HingTopClearnace = " .. Hardware.HingTopClearnace .. " \n") ;
    file:write("Hardware.ShelfPinDiameter = " .. Hardware.ShelfPinDiameter .. " \n") ;
    file:write("Hardware.HingHoleCenters = " .. Hardware.HingHoleCenters .. " \n") ;
    file:write("Milling.DadoClearnace = " .. Milling.DadoClearnace .. " \n") ;
    file:write("Milling.DadoToolDia = " .. Milling.DadoToolDia .. " \n") ;
    file:write("Milling.HalfDadoWidth = " .. Milling.HalfDadoWidth .. " \n") ;
    file:write("Milling.PilotBitDia = " .. Milling.PilotBitDia .. " \n") ;
    file:write("Milling.PocketToolDia = " .. Milling.PocketToolDia .. " \n") ;
    file:write("Milling.ProfileToolDia = " .. Milling.ProfileToolDia .. " \n") ;
    file:write("Milling.RabbitClearing = " .. Milling.RabbitClearing .. " \n") ;
    file:write("Milling.SidePocketDepth = " .. Milling.SidePocketDepth .. " \n") ;
--    file:write("ProjectQuestion.AddCabinetSettingsToProject = " .. ProjectQuestion.AddCabinetSettingsToProject .. " \n") ;
    file:write("ProjectQuestion.CabinetName = " .. ProjectQuestion.CabinetName .. " \n") ;
    file:write("ProjectQuestion.ProjectContactEmail = " .. ProjectQuestion.ProjectContactEmail .. " \n") ;
    file:write("ProjectQuestion.ProjectContactName = " .. ProjectQuestion.ProjectContactName .. " \n") ;
    file:write("ProjectQuestion.ProjectContactPhoneNumber = " .. ProjectQuestion.ProjectContactPhoneNumber .. " \n") ;
    file:write("ProjectQuestion.ProjectName = " .. string.upper(ProjectQuestion.ProjectName) .. " \n") ;
    file:write("ProjectQuestion.ProjectPath = " .. ProjectQuestion.ProjectPath .. " \n") ;
    file:write("ProjectQuestion.StartDate = " .. ProjectQuestion.StartDate .. " \n") ;
    file:write("WallDim.BackPocketDepthWall = " .. WallDim.BackPocketDepthWall .. " \n") ;
    file:write("WallDim.BlindDadoSetbackWall = " .. WallDim.BlindDadoSetbackWall .. " \n") ;
    file:write("WallDim.CabDepthWall = " .. WallDim.CabDepthWall .. " \n") ;
    file:write("WallDim.CabHeightWall = " .. WallDim.CabHeightWall .. " \n") ;
    file:write("WallDim.CabLengthWall = " .. WallDim.CabLengthWall .. " \n") ;
    file:write("WallDim.FaceFrameBottomRailWidthWall = " .. WallDim.FaceFrameBottomRailWidthWall .. " \n") ;
    file:write("WallDim.FaceFrameBottomRevealWall = " .. WallDim.FaceFrameBottomRevealWall .. " \n") ;
    file:write("WallDim.FaceFrameCenterStileWidthWall = " .. WallDim.FaceFrameCenterStileWidthWall .. " \n") ;
    file:write("WallDim.FaceFrameRevealWall = " .. WallDim.FaceFrameRevealWall .. " \n") ;
    file:write("WallDim.FaceFrameStileWidthWall = " .. WallDim.FaceFrameStileWidthWall .. " \n") ;
    file:write("WallDim.FaceFrameThicknessWall = " .. WallDim.FaceFrameThicknessWall .. " \n") ;
    file:write("WallDim.FaceFrameTopOverlapWall = " .. WallDim.FaceFrameTopOverlapWall .. " \n") ;
    file:write("WallDim.FaceFrameTopRailWidthWall = " .. WallDim.FaceFrameTopRailWidthWall .. " \n") ;
    file:write("WallDim.NailerThicknessWall = " .. WallDim.NailerThicknessWall .. " \n") ;
    file:write("WallDim.NailerWidthWall = " .. WallDim.NailerWidthWall .. " \n") ;
    file:write("WallDim.RevealWall = " .. WallDim.RevealWall .. " \n") ;
    file:write("WallDim.ShelfCountWall = " .. WallDim.ShelfCountWall .. " \n") ;
    file:write("WallDim.ShelfEndClarenceWall = " .. WallDim.ShelfEndClarenceWall .. " \n") ;
    file:write("WallDim.ShelfFaceFrameThicknessWall = " .. WallDim.ShelfFaceFrameThicknessWall .. " \n") ;
    file:write("WallDim.ShelfFaceFrameWidthWall = " .. WallDim.ShelfFaceFrameWidthWall .. " \n") ;
    file:write("WallDim.ShelfFrontClearanceWall = " .. WallDim.ShelfFrontClearanceWall .. " \n") ;
    file:write("WallDim.ShelfHoleFirstRowSpacingWall = " .. WallDim.ShelfHoleFirstRowSpacingWall .. " \n") ;
    file:write("WallDim.ShelfHoleLastRowSpacingWall = " .. WallDim.ShelfHoleLastRowSpacingWall .. " \n") ;
    file:write("WallDim.ShelfHoleSpacingWall = " .. WallDim.ShelfHoleSpacingWall .. " \n") ;
    file:write("WallDim.ShelfMaterialThicknessWall = " .. WallDim.ShelfMaterialThicknessWall .. " \n") ;
    file:write("WallDim.ShelfFaceFrameRevealWall = " .. WallDim.ShelfFaceFrameRevealWall .. " \n") ;
    file:write("WallDim.ShelfPinHoleBackWall = " .. WallDim.ShelfPinHoleBackWall .. " \n") ;
    file:write("WallDim.ShelfPinHoleFrontWall = " .. WallDim.ShelfPinHoleFrontWall .. " \n") ;
    file:write("WallDim.StretcherThicknessWall = " .. WallDim.StretcherThicknessWall .. " \n") ;
    file:write("WallDim.StretcherWidthWall = " .. WallDim.StretcherWidthWall .. " \n") ;
    file:write("WallDim.ThicknessBackWall = " .. WallDim.ThicknessBackWall .. " \n") ;
    file:write("WallDim.ThicknessWall = " .. WallDim.ThicknessWall .. " \n") ;
    file:write("WallQuestion.AddBackNailerWall = " .. WallQuestion.AddBackNailerWall .. " \n") ;
    file:write("WallQuestion.AddCenterPanelWall = " .. WallQuestion.AddCenterPanelWall .. " \n") ;
    file:write("WallQuestion.AddFaceFrameWall = " .. WallQuestion.AddFaceFrameWall .. " \n") ;
    file:write("WallQuestion.AddShelfHingPilotHolesWall = " .. WallQuestion.AddShelfHingPilotHolesWall .. " \n") ;
    file:write("WallQuestion.AddShelfHolesWall = " .. WallQuestion.AddShelfHolesWall .. " \n") ;
    file:write("WallQuestion.AddShelfingWall = " .. WallQuestion.AddShelfingWall .. " \n") ;
    file:write("WallQuestion.AddStretchersWall = " .. WallQuestion.AddStretchersWall .. " \n") ;
    file:write("WallQuestion.BackDadoOrOverlapWall = " .. WallQuestion.BackDadoOrOverlapWall .. " \n") ;
    file:write("WallQuestion.DadoStyleWall = " .. WallQuestion.DadoStyleWall .. " \n") ;
    file:write("WallQuestion.DadoTypeWall = " .. WallQuestion.DadoTypeWall .. " \n") ;
    file:write("WallQuestion.DrawBackPanelOnNewSheetWall = " .. WallQuestion.DrawBackPanelOnNewSheetWall .. " \n") ;
    file:write("WallQuestion.DrawBackPanelWall = " .. WallQuestion.DrawBackPanelWall .. " \n") ;
    file:write("WallQuestion.DrawBottomPanelWall = " .. WallQuestion.DrawBottomPanelWall .. " \n") ;
    file:write("WallQuestion.DrawCenterPanelWall = " .. WallQuestion.DrawCenterPanelWall .. " \n") ;
    file:write("WallQuestion.DrawFaceFrameOnNewSheetWall = " .. WallQuestion.DrawFaceFrameOnNewSheetWall .. " \n") ;
    file:write("WallQuestion.DrawFaceFrameWall = " .. WallQuestion.DrawFaceFrameWall .. " \n") ;
    file:write("WallQuestion.DrawLeftSidePanelWall = " .. WallQuestion.DrawLeftSidePanelWall .. " \n") ;
    file:write("WallQuestion.DrawRightSidePanelWall = " .. WallQuestion.DrawRightSidePanelWall .. " \n") ;
    file:write("WallQuestion.DrawShelfPanelWall = " .. WallQuestion.DrawShelfPanelWall .. " \n") ;
    file:write("WallQuestion.DrawTopPanelWall = " .. WallQuestion.DrawTopPanelWall .. " \n") ;
    file:write("WallQuestion.FaceFrameOrStretchersWall = " .. WallQuestion.FaceFrameOrStretchersWall .. " \n") ;
    file:write("WallQuestion.NailerLocationWall = " .. WallQuestion.NailerLocationWall .. " \n") ;
    file:write("WallQuestion.ProvideCabinetNotesOnDrawingWall = " .. WallQuestion.ProvideCabinetNotesOnDrawingWall .. " \n") ;
    file:write("WallQuestion.ProvideCabinetNotesOnNewSheetWall = " .. WallQuestion.ProvideCabinetNotesOnNewSheetWall .. " \n") ;
    file:write("Variables.g_boxHight = " .. g_boxHight .. " \n") ; 
    file:write("Variables.g_boxLength = " .. g_boxLength .. " \n") ; 
    file:write("Variables.g_boxDepth = " .. g_boxDepth .. " \n") ; 
    file:write("Variables.g_backHight = " .. g_backHight .. " \n") ; 
    file:write("Variables.g_backWidth = " .. g_backWidth .. " \n") ; 
    file:close()-- closes the open file 
    return true  
end
]]
-- <><><><><><><><><><><><><><><><><><><><><><><><><><>
-- <>=================== Tools  =====================<>
-- <>================================================<>
function FileExists(name)
    -- DisplayMessageBox(name)
    DeBug(7521, 3, "FileExists - " .. name )    
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end
-- ===================================================
function BtoS(x)-- Returns String of a boolean
--[[
    Converts a boolean to a string
    Returns = String
]]
    DeBug(9140,5, "BtoS = " .. tostring(x)  )
    local Z = "" ;     
    if x then ;         
        Z = "true" ;     
    else ;         
        Z = "false" ;     
    end 
    return Z
end
-- ===================================================
function StrIniValue(str, ty)-- convert string to the correct data type
       DeBug(9210, 9, "StrIniValue")
    if nil == str then
          DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
    else
        if "" == all_trim(str) then
          DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
    else
        local j = (string.find(str, "=") + 1) ;   
        if ty == "N" then ; return tonumber(string.sub(str, j)) ; end ; 
        if ty == "S" then ; return all_trim(string.sub(str, j)) ; end;    
        if ty == "B" then ; 
        if "TRUE" == all_trim(string.upper(string.sub(str, j))) then ; 
        return true ; else ; 
        return false ; end ; 
        end ; 
        end
    end
    return nil
end
-- ===================================================
function GetIniValue(xPath, FileName, GroupName, ItemName, ValueType) 
--  XX.YY = GetIniValue(xPath, FileName, GroupName, "XX.YY", "N") 
    DeBug(9220, 3, "GetIniValu")
    DeBug(9221, 3, "FileName " .. FileName)
    DeBug(9222, 3, "GroupName " .. string.upper(GroupName))
    DeBug(9223, 3, "ItemName " .. ItemName)
    DeBug(9224, 3, "ValueType " .. ValueType)
    
    local filenameR = xPath .. "/" .. FileName .. ".ini"
    local FL = LengthOfFile(filenameR)
    local file = io.open(filenameR, "r")  
    local dat = "."  
    local ItemNameLen = string.len(ItemName) ; 
    DeBug(9225, 6, "--1 Length of = " .. tostring(FL))
    while (FL >= 1) do        
        dat = all_trim(file:read()) ; 
        if dat == "[" .. string.upper(GroupName) .. "]" then
            DeBug(9226, 4, "------------ Found Group ------------")
            break
        else
            FL = FL - 1
        end        
    end
       DeBug(9227,6, "--2")
    
    while (FL >= 1) do        
        dat = all_trim(file:read()) ; 
                DeBug(9227, 9, tostring(FL))
        if ItemName == string.sub(dat, 1, ItemNameLen)  then
               DeBug(9226, 4, "------------ Found Item ------------")
            break
        else
            FL = FL - 1
            if FL == 0 then
                dat = "Error - item not  found                                                                    "
                break
            end
        end        
    end  
    DeBug(9228,5, "--3")
    file:close()-- closes the open file
    local XX = StrIniValue(dat, ValueType)
    return XX
end
-- ===================================================
function InquiryTextBox(Header, Quest, Defaltxt)
--[[
    TextBox for user input with default value
    Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[ <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css">  html {overflow: auto ; } body { background-color: #EBEBEB ; }body, td, th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ; width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Questions"> <strong> Message Here</strong> </td> </tr> <tr> <th width = "48" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th> <th width = "416" colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"> <input name = "qInput" type = "text" id = "qInput" size = "65"> </th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle" bgcolor = "#EBEBEB"> <table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"></td> <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td> <td style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </td> </tr> </table> </body> 
    </html>]] ; local dialog = HTML_Dialog(true, myHtml, 525, 160, Header) ; dialog:AddLabelField("Questions", Quest) ; dialogAddTextField("qInput", Defaltxt) ; if not dialog:ShowDialog() then ; return "" ; else ; return dialog:GetTextField("qInput") ; end    
end
-- ===================================================
function InquiryPathBox(Header, Quest, Defaltxt)
       DeBug(9230,1, "InquiryPathBox")
--[[
    PathBox for user input with DEFAULT path value
    Caller: local z = InquiryPathBox("Cabinet Maker", "Job Path", ProjectQuestion.JobPath)
    DisplayMessageBox(z) 
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    DEFAULT Question = Anderson
    Returns = String
]]
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto; } body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 { font-size: 10px; font-weight: bold; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h2" id = "Questions">Message Here</strong></td> </tr> <tr> <th width = "48" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"> <input id = "DirectoryPicker" class = "DirectoryPicker" name = "DirectoryPicker" type = "button" value = "Path..."> </th> <th width = "416" colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact"> <input name = "DInput" type = "text" id = "DInput" size = "65"> </th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%">&nbsp ; </td> <td style = "width: 20%">&nbsp ; </td> <td style = "width: 25%">&nbsp ; </td> <td style = "width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> <td style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr> </table></td> </tr> </table> </body> </html>]]
    local dialog = HTML_Dialog(true, myHtml, 525, 160, Header) ;     dialog:AddLabelField("Questions", Quest) ;     dialog:AddTextField("DInput", Defaltxt) ;     dialog:AddDirectoryPicker("DirectoryPicker",  "DInput", true) ;     if not dialog:ShowDialog() then ; return "" ;     else ;         return dialog:GetTextField("DInput") ;    end    
end
-- ===================================================
function StartDate()
--[[
        %a  abbreviated weekday name (e.g., Wed)
        %A  full weekday name (e.g., Wednesday)
        %b  abbreviated month name (e.g., Sep)
        %B  full month name (e.g., September)
        %c  date and time (e.g., 09/16/98 23:48:10)
        %d  day of the month (16) [01-31]
        %H  hour, using a 24-hour clock (23) [00-23]
        %I  hour, using a 12-hour clock (11) [01-12]
        %M  minute (48) [00-59]
        %m  month (09) [01-12]
        %p  either "am" or "pm" (pm)
        %S  second (10) [00-61]
        %w  weekday (3) [0-6 = Sunday-Saturday]
        %x  date (e.g., 09/16/98)
        %X  time (e.g., 23:48:10)
        %Y  full year (1998)
        %y  two-digit year (98) [00-99]
        %%  the character `%´
]]
    DeBug(9360,4, "StartDate")
    return os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p")
end
-- ===================================================
function LongDate()
--[[
        %a  abbreviated weekday name (e.g., Wed)
        %A  full weekday name (e.g., Wednesday)
        %b  abbreviated month name (e.g., Sep)
        %B  full month name (e.g., September)
        %c  date and time (e.g., 09/16/98 23:48:10)
        %d  day of the month (16) [01-31]
        %H  hour, using a 24-hour clock (23) [00-23]
        %I  hour, using a 12-hour clock (11) [01-12]
        %M  minute (48) [00-59]
        %m  month (09) [01-12]
        %p  either "am" or "pm" (pm)
        %S  second (10) [00-61]
        %w  weekday (3) [0-6 = Sunday-Saturday]
        %x  date (e.g., 09/16/98)
        %X  time (e.g., 23:48:10)
        %Y  full year (1998)
        %y  two-digit year (98) [00-99]
        %%  the character `%´
]]    
    return "[" .. os.date("%b %d, %Y") .. " - " ..os.date("%H") .. ":" .. os.date("%m") ..":".. os.date("%S") .. "]"
end
-- ===================================================
function NowName()
--[[ Date time vars
        %a  abbreviated weekday name (e.g., Wed)
        %A  full weekday name (e.g., Wednesday)
        %b  abbreviated month name (e.g., Sep)
        %B  full month name (e.g., September)
        %c  date and time (e.g., 09/16/98 23:48:10)
        %d  day of the month (16) [01-31]
        %H  hour, using a 24-hour clock (23) [00-23]
        %I  hour, using a 12-hour clock (11) [01-12]
        %M  minute (48) [00-59]
        %m  month (09) [01-12]
        %p  either "am" or "pm" (pm)
        %S  second (10) [00-61]
        %w  weekday (3) [0-6 = Sunday-Saturday]
        %x  date (e.g., 09/16/98)
        %X  time (e.g., 23:48:10)
        %Y  full year (1998)
        %y  two-digit year (98) [00-99]
        %%  the character `%´
]]
    DeBug(9370, 4, "NowName - ")
    return os.date("%d").. os.date("%H").. os.date("%M").. os.date("%S")
end
-- ===================================================
function NameStrip(str, var) -- convert string to the correct data type
-- Local Words = NameStrip("KPSDFKSPSK - 34598923", "-") -- returns "KPSDFKSPSK"
    DeBug(9840,1, "NameStrip - " .. str)   
    if "" == str then
        DisplayMessageBox("Error in string")
    else
        if string.find(str, var) then
            local j = assert(string.find(str, var) - 1) 
            return all_trim(string.sub(str, 1, j)) ;
        else
            return str
        end
    end    
end
-- ===================================================
-- <><><><><><><><><><><><><><><><><><><><><><><><><><>
function SetupDefalts()
    Hardware.ShelfPinRadus = Hardware.ShelfPinDiameter * 0.5 
    Milling.DadoToolRadus = Milling.DadoToolDia * 0.5 
    Milling.PocketToolRadus = Milling.PocketToolDia * 0.5 
    Milling.ProfileToolRadus = Milling.ProfileToolDia * 0.5 
end
-- ===================================================
function NewProject(xPath)
    --  Cabinet     
    if "SETUP NEW PROJECT" == string.upper(ProjectQuestion.ProjectName) then
        -- New Project
        DeBug(8001, 2, "NewProject CG - NewProjectSetup" ) 
        NewProjectSetup(xPath)
    -- ShowMe()
        DeBug(8003, 2, "NewProject CH - If " ) 
        UpdateRegistryStandardCabinetList()-- Write to Registry
        ProjectQuestion.ProjectCabinetWall = "DEFAULT"
    else
        -- Not the new Project
        -- Read Project Values  
        G_ReadProjectinfo(xPath, ProjectQuestion.ProjectName, "CabinetProjects" )
    -- ShowMe()
        DeBug(8004, 2, "NewProject CH - If " ) 
        -- Write to Registry
        UpdateRegistryStandardCabinetList()       
        DeBug(8005,2, "Read the Selected Project for a list of Cabinets")
       -- CabinetHeaderReader(xPath, ProjectQuestion.ProjectName)-- Read Default Cabinets
        CabinetHeaderReader(ProjectQuestion.ProjectPath, ProjectQuestion.ProjectName)-- Read Default Cabinets
       -- DeBug(8006,2, "NewProject D - " ) 
       -- ProjectQuestion.ProjectCabinetWall = CabinetDropList("Cabinet Maker", "Select Cabinet Name",  480, 365, IniFile)
        DeBug(8007,2, "NewProject E - " ) 
    end
end
-- ===================================================
function CabinetCalculations() 
    if WallQuestion.AddCenterPanelWall == false then ;     
        WallQuestion.DrawCenterPanelWall = false ; 
    end
        
    if WallQuestion.AddShelf == false then ;
        WallQuestion.DrawShelfPanelWall = false ;           WallDim.PartLength = 0 ; 
        WallDim.PartDepth = 0 ;                             WallDim.ShelfCountWall = 0 ; 
        WallDim.FaceFrameThickness = 0 ;                    WallDim.WidthClearance = 0 ; 
        WallDim.FaceFrameWidth = 0 ;                        WallDim.ShelfHoleSpacingWall = 0 ;  
        WallDim.ShelfHoleFirstRowSpacingWall = 0 ;          WallDim.ShelfHoleLastRowSpacingWall = 0 ; 
        WallDim.ShelfMaterialThicknessWall = 0 ;            WallDim.FaceFrameReveal = 0 ; 
        WallDim.ShelfEndClarenceWall = 0 ;     
    end
    DeBug(8012, 1, "main J - " )     
    if WallQuestion.AddFaceFrameWall == false then ;    
        WallQuestion.DrawFaceFrameWall = false ;         WallDim.FaceFrameThicknessWall = 0 ; 
        WallDim.FaceFrameBottomRailWidthWall = 0 ;         WallDim.FaceFrameTopRailWidthWall = 0 ; 
        WallDim.FaceFrameCenterStileWidthWall = 0 ;         WallDim.FaceFrameBottomRevealWall = 0 ; 
        WallDim.FaceFrameTopOverlapWall = 0 ;         WallDim.FaceFrameRevealWall = 0 ; 
        WallDim.FaceFrameStileWidthWall = 0 ; 
    end
    DeBug(8013, 1, "main K - " )  
    if WallQuestion.AddFaceFrameWall then
        g_boxHight = (WallDim.CabHeightWall - (WallDim.FaceFrameTopRailWidthWall + WallDim.FaceFrameBottomRailWidthWall)) + (WallDim.FaceFrameBottomRevealWall + WallDim.FaceFrameTopOverlapWall + (WallDim.ThicknessWall * 2.0))   
        g_boxLength = WallDim.CabLengthWall - (WallDim.FaceFrameRevealWall * 2.0) 
        g_boxDepth = WallDim.CabDepthWall - WallDim.FaceFrameThicknessWall
    else 
        g_boxLength = WallDim.CabLengthWall 
        g_boxDepth = WallDim.CabDepthWall
        g_boxHight = WallDim.CabHeightWall
        WallDim.FaceFrameTopRailWidthWall = 0.0
        WallDim.FaceFrameBottomRailWidthWall = 0.0
        WallDim.FaceFrameBottomRevealWall = 0.0
        WallDim.FaceFrameTopOverlapWall = 0.0  
            
    end

--[[    if WallQuestion.AddFaceFrameWall == false then ;
    
    else 
        WallQuestion.BackDadoOrOverlapWall="Dado"
    end
]]
    DeBug(8014, 1, "main L - " )  
    g_backHight = g_boxHight - WallDim.ThicknessWall
    g_backWidth = g_boxLength - WallDim.ThicknessWall 
    g_pt2 = Point2D((g_boxHight + (3 * g_PartGap)),1)
    g_pt3 = Point2D(1.0,(g_boxDepth + (3 * g_PartGap)))
    g_pt4 = Polar2D(g_pt3, 0, ((g_boxLength - (WallDim.ThicknessWall * 1.0) ) + (1.0 * g_PartGap)))
    g_pt5 = Point2D(1.0,((g_boxDepth * 2.0) + (4.0 * g_PartGap)))-- Shelf
    g_pt6 = Point2D(1.0,((g_boxDepth * 3.0) + (5.0 * g_PartGap)))-- Center
    if  g_boxLength >= g_boxHight then
        g_pt7 = Point2D(((g_boxLength * 2.0) + (3.0 * g_PartGap) - (WallDim.ThicknessWall * 1.0)) ,1.0)-- Back
        g_pt8 = Point2D(((g_boxLength * 2.0) + (3.0 * g_PartGap) + (g_backHight * 1.0)),1.0)-- FaceFrame
    else
        g_pt7 = Point2D(((g_boxHight * 2.0) + (3.0 * g_PartGap) - (WallDim.ThicknessWall * 1.0)) ,1.0)-- Back
        g_pt8 = Point2D(((g_boxHight * 2.0) + (3.0 * g_PartGap) + (g_backHight * 1.0)),1.0)-- FaceFrame
    end
end
-- ===================================================
function CabinetSides()
    DeBug(8015, 1, "CabinetSides - UpperCabinetSide L" ) 
    if WallQuestion.DrawLeftSidePanelWall then 
        UpperCabinetSide( "L",  WallDim.ThicknessWall .. "-Profile")
    end
    DeBug(8016, 1, "CabinetSides - UpperCabinetSide R" ) 
    if WallQuestion.DrawRightSidePanelWall then
        UpperCabinetSide( "R",  WallDim.ThicknessWall .. "-Profile")
    end
end
-- ===================================================
function TopandBottom()
    DeBug(6010, 1, "TopandBottom - UpperCabinetTandB T" ) 
    if WallQuestion.DrawTopPanelWall then
        UpperCabinetTandB("T", WallDim.ThicknessWall .. "-Profile" )
    end
    DeBug(6020, 1, "TopandBottom - UpperCabinetTandB B" ) 
    if WallQuestion.DrawBottomPanelWall then
        UpperCabinetTandB("B", WallDim.ThicknessWall .. "-Profile")
    end
end
-- ===================================================
function CabinetShelfs()
    DeBug(7001, 1, "CabinetShelfs")
    if WallQuestion.DrawShelfPanelWall then
        if WallDim.ShelfCountWall >= 1 then
            local CountX = WallDim.ShelfCountWall
            while (CountX > 0) do
              DeBug(8021, 2, "CabinetShelfs A:" .. tostring(CountX))
            -- Loop here, draw each Shelf on it own Layer and the Lay name will number per count
                lay = WallDim.ThicknessWall .. "-Profile"                                 
                UpperCabinetShelf(lay, CountX)
                g_pt5 = Polar2D(g_pt5, 0, (WallDim.PartLength + (2 * g_PartGap))) 
                CountX = CountX - 1
            end
        end
    end
end
-- ===================================================
function NewProjectSetup(xPath)
    DeBug(9001, 1,"NewProjectSetup")
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto; } HoleFirstRowSpacing body { background-color: #EBEBEB; } body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 { font-size: 10px; font-weight: bold; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h2" id = "Messages"><strong>Header Message Here</strong></td> </tr> <tr> <td align = "right" valign = "middle" nowrap bgcolor = "#EBEBEB" class = "h3">Project Name</td> <th colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"><input name = "ProjectName" type = "text" id = "ProjectName" size = "30"></th> </tr> <tr> <td align = "right" valign = "middle" nowrap bgcolor = "#EBEBEB" class = "h3">Start Date</td> <th colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"><input name = "StartDate" type = "text" id = "StartDate" size = "20"></th> </tr> <tr> <td align = "right" valign = "middle" nowrap bgcolor = "#EBEBEB" class = "h3">Contact Name</td> <th colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"><input name = "ProjectContactName" type = "text" id = "ProjectContactName" size = "30"></th> </tr>  <tr> <td align = "right" valign = "middle" nowrap bgcolor = "#EBEBEB" class = "h3">Phone Number</td> <th colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"><input name = "ProjectContactPhoneNumber" type = "text" id = "ProjectContactPhoneNumber" size = "30"></th> </tr> <tr> <td align = "right" valign = "middle" nowrap bgcolor = "#EBEBEB" class = "h3">Contact Email</td> <th colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"><input name = "ProjectContactEmail" type = "text" id = "ProjectContactEmail" size = "40"></th> </tr> <tr> <th width = "98" align = "right" valign = "middle" bgcolor = "#EBEBEB"><input id = "DirectoryPicker" class = "DirectoryPicker" name = "DirectoryPicker" type = "button" value = "Path..."></th> <th width = "366" colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"><input name = "DInput" type = "text" id = "DInput" size = "60"></th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%">&nbsp;</td> <td style = "width: 20%">&nbsp;</td> <td style = "width: 25%">&nbsp;</td> <td style = "width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> <td style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr> </table></td> </tr> </table> </body> </html>]]
    DeBug(9010, 5, "+") 
    local dialog = HTML_Dialog(true, myHtml, 520, 290, "Setup New Project") ; 
    dialog:AddLabelField("Messages", "All Are Fields Required") ;
    DeBug(010, 5, "Dialog Load") 
    dialog:AddTextField("ProjectContactEmail", "Contact.Name@Builder.com") ; 
    dialog:AddTextField("ProjectName", NowName()) ; 
    dialog:AddTextField("ProjectContactName", "Person Name") ; 
    dialog:AddTextField("ProjectContactPhoneNumber", "(098) 765-4321") ;    
    dialog:AddTextField("StartDate",    StartDate()) ; 
    dialog:AddTextField("DInput",  ProjectQuestion.ProjectPath) ;     
    dialog:AddDirectoryPicker("DirectoryPicker",  "DInput", true) ;        
    DeBug(9020,3,"++") 
    if not dialog:ShowDialog() then ; 
        DeBug(id,id,5,"+++")
        return nil ;     
    else ;    
        DeBug(9030,5,"+++") 
        ProjectQuestion.ProjectPath = dialog:GetTextField("DInput") ;
        ProjectQuestion.ProjectContactEmail = dialog:GetTextField("ProjectContactEmail") ; 
        ProjectQuestion.ProjectName = dialog:GetTextField("ProjectName") ;    
        ProjectQuestion.ProjectContactName = dialog:GetTextField("ProjectContactName") ;    
        ProjectQuestion.ProjectContactPhoneNumber = dialog:GetTextField("ProjectContactPhoneNumber") ;   
        ProjectQuestion.StartDate = dialog:GetTextField("StartDate") ;     
        if CheckArray(ProjectQuestion.ProjectName, Projects) then
            DeBug(9040,7,"++++")
            AddNewProject(xPath)
            NewProjectSeedFile(xPath)
            return true  
        else
            DeBug(9050,7,"++++")
            DisplayMessageBox("Project name is already loaded")
            return false 
        end
    end         
end
-- ===================================================
function ProjectHeaderReader(xPath)
       DeBug(9060,1,"ProjectHeaderReader")
--[[
    Gets the INI Header values of a ini file and uploads to "IniFile" Array 
    IniFile = {} Global variables
    xPath = script_path
]]
    
    local filename = xPath .. "/CabinetProjects.ini"
    local file = io.open(filename, "r")
    local Cabing = (LengthOfFile(filename) - 1)
    table.insert (Projects, "SETUP NEW PROJECT") 
    local dat = all_trim(file:read())
    while (Cabing >= 1) do
       DeBug(9070,5,tostring(Cabing))
        if "[" == string.sub(dat, 1, 1) then
              DeBug(9071,5, 4, dat)
            table.insert (Projects, string.upper(string.sub(dat, 2, (string.len(dat) - 1))))
        end       
        dat = file:read()
        if dat then
             dat = all_trim(dat)
          else
             return true 
        end
        Cabing = Cabing - 1
    end
       DeBug(9080,5, dat)
    return true
end
-- ===================================================
function CabinetHeaderReader(xPath, Fname) 
--[[
    Gets the INI Header values of a ini file and uploads to "IniFile" Array 
    IniFile = {} Global variables
    xPath = script_path
]]
    DeBug(9090,1, "CabinetHeaderReaders-")
    DeBug(9090,1, "CabinetHeaderReaders-" .. xPath )
    DeBug(9090,1, "CabinetHeaderReaders-" .. Fname )
    
    local filename = xPath .. "/" .. Fname .. ".ini"
    if FileExists(filename) then
        local file = io.open(filename, "r")
        DeBug(9090,1, "CabinetHeaderReaders - (LengthOfFile(" .. filename .. ")" )
        local Cabing = (LengthOfFile(filename) - 1)
        local dat = all_trim(file:read())
        while (Cabing >= 1) do
            if "[" == string.upper(string.sub(dat, 1, 1)) then
                table.insert (IniFile, string.sub(dat, 2, (string.len(dat) - 1))) 
            end       
            dat = file:read()
            if dat then
                 dat = all_trim(dat)
              else
                 return true 
            end
            Cabing = Cabing - 1
        end
       else
       table.insert (IniFile, "No Project folder-file found")
    end
    return true
end
-- ===================================================
function AddGroupToJob(job, group, layer_name)
       DeBug(9100,1, AddGroupToJob)
   local cad_object = CreateCadGroup(group) ; 
   local layer = job.LayerManager:GetLayerWithName(layer_name) ; 
   layer:AddObject(cad_object, true) ; 
   return cad_object 
end
-- ===================================================
function AddNewProject(xPath)-- Appends a New Project to CabinetProjectQuestion.ini
    DeBug(9110,1, AddNewProject)
    local filename = xPath .. "/CabinetProjects.ini"
    local file = io.open(filename, "a")
    file:write("[" .. string.upper(all_trim(ProjectQuestion.ProjectName)) .. "] \n") ; 
    file:write("ProjectQuestion.ProjectPath = " .. ProjectQuestion.ProjectPath .. " \n") ; 
    file:write("ProjectQuestion.StartDate = " .. ProjectQuestion.StartDate .. " \n") ; 
    file:write("ProjectQuestion.ProjectContactName = " .. ProjectQuestion.ProjectContactName .. " \n") ; 
    file:write("ProjectQuestion.ProjectContactEmail = " .. ProjectQuestion.ProjectContactEmail .. " \n") ; 
    file:write("ProjectQuestion.ProjectContactPhoneNumber = " .. ProjectQuestion.ProjectContactPhoneNumber .. " \n") ; 
    file:write("ProjectQuestion.ProjectName = " .. string.upper(ProjectQuestion.ProjectName) .. " \n") ;    
    file:write("#====================================== \n") ;
    file:close()-- closes the open file 
    return true  
end
-- ===================================================
function CheckArray(StrValue, DList)
       --DeBug(9120,1, CheckArray)
    local found = false
    for index, value in pairs(DList) do 
        --DeBug(9121,5, value)    
        if StrValue == value then
            found = true
            break
        end
    end 
    return found
end
-- ===================================================
function NewProjectSeedFile(xPath)-- Adds a New Project File XYZ.ini
    DeBug(9150,1, "NewProjectSeedFile")
    local filenameR = xPath .. "/CabinetMaker.ini"
    local FL = (LengthOfFile(filenameR) - 9)
    local FLH = 8
    local fileR = io.open(filenameR, "r")
    table.insert (Projects, "SETUP NEW PROJECT") 
    local dat = all_trim(fileR:read())
    local filenameW = ProjectQuestion.ProjectPath .. "/" .. ProjectQuestion.ProjectName .. ".ini"
    local fileW = io.open(filenameW, "w")
    fileW:write("#====================================== \n") ;
    fileW:write("#    Project Name: " .. string.upper(all_trim(ProjectQuestion.ProjectName) .. "\n")) 
    fileW:write("#      Start Date: " .. StartDate() .. "\n") ; 
    fileW:write("# Project Contact: " .. ProjectQuestion.ProjectContactName .. "\n") ; 
    fileW:write("#   Contact Email: " .. ProjectQuestion.ProjectContactEmail .. "\n") ; 
    fileW:write("#   Contact Phone: " .. ProjectQuestion.ProjectContactPhoneNumber .. "\n") ;     
    fileW:write("#====================================== \n") ; 
    fileW:write("[DEFAULT]\n") ;     
    while (FLH >= 1) do
        fileR:read()
        FLH = FLH - 1
    end
    local XX
    while (FL >= 1) do
        XX = fileR:read()
        if XX then
            fileW:write(all_trim(XX) .. "\n")
            FL = FL - 1
        else             
            break
        end
    end
    fileW:write("#====================================== \n") ;
    fileR:close()-- closes the open file 
    fileW:close()-- closes the open file
       DeBug(9159,5, "closes the open file")    
    return true  
end
-- ===================================================
function UpdateRegistryStandardCabinetList()-- Write to Registry values
       DeBug(9170,1, "UpdateRegistryStandardCabinetList")
    local RegistryWrite = Registry("CabinetMaker") ;  
    local RegValue = RegistryWrite:SetString("ProjectCabinetBase", ProjectQuestion.ProjectCabinetBase) ;    
          RegValue = RegistryWrite:SetString("ProjectCabinetWall", ProjectQuestion.ProjectCabinetWall) ;     
          RegValue = RegistryWrite:SetString("ProjectName",        string.upper(ProjectQuestion.ProjectName)) ;
          RegValue = RegistryWrite:SetString("ProjectPath",        ProjectQuestion.ProjectPath) ;
end
-- ===================================================
--[[ -- Write to Registry values
function WriteRegistryStandardCabinetList()   -- Write to Registry values
    local RegistryWrite = Registry("CabinetMaker") ;  
    local RegValue = RegistryWrite:SetString("ProgramCodeBy",      ProjectQuestion.ProgramCodeBy) ; 
    RegValue = RegistryWrite:SetString("ProgramContact",     ProjectQuestion.ProgramContact) ; 
    RegValue = RegistryWrite:SetString("ProgramName",        ProjectQuestion.ProgramName) ;
    RegValue = RegistryWrite:SetString("ProgramVersion",     ProjectQuestion.ProgramVersion) ; 
    RegValue = RegistryWrite:SetString("ProgramYear",        ProjectQuestion.ProgramYear) ; 
    RegValue = RegistryWrite:SetString("ProjectCabinetBase", ProjectQuestion.ProjectCabinetBase) ;    
    RegValue = RegistryWrite:SetString("ProjectCabinetWall", ProjectQuestion.ProjectCabinetWall) ;     
    RegValue = RegistryWrite:SetString("ProjectName",        ProjectQuestion.ProjectName) ;
    RegValue = RegistryWrite:SetString("ProjectName",        ProjectQuestion.ProjectPath) ;
end
]]
-- ==================================================== 
function ReadRegistryStandardCabinetList()-- Read from Registry values
       DeBug(9180,1, "ReadRegistryStandardCabinetList")
    local RegistryRead = Registry("CabinetMaker") ; 
    ProjectQuestion.ProgramCodeBy = RegistryRead:GetString("ProgramCodeBy",       ProjectQuestion.CodeBy) ; 
    ProjectQuestion.ProgramContact = RegistryRead:GetString("ProgramContact",      ProjectQuestion.Contact) ; 
    ProjectQuestion.ProgramName = RegistryRead:GetString("ProgramName",         ProjectQuestion.ProgramName) ;
    ProjectQuestion.ProgramVersion = RegistryRead:GetString("ProgramVersion",      ProjectQuestion.ProgramVersion ) ; 
    ProjectQuestion.ProgramYear = RegistryRead:GetString("ProgramYear",         ProjectQuestion.Year) ; 
    ProjectQuestion.ProjectCabinetBase = RegistryRead:GetString("ProjectCabinetBase",  ProjectQuestion.ProjectCabinetBase) ;    
    ProjectQuestion.ProjectCabinetWall = RegistryRead:GetString("ProjectCabinetWall",  ProjectQuestion.ProjectCabinetWall) ;     
    ProjectQuestion.ProjectName = RegistryRead:GetString("ProjectName",         string.upper(ProjectQuestion.ProjectName)) ;
    ProjectQuestion.ProjectPath = RegistryRead:GetString("ProjectPath",        ".") ;
    if ProjectQuestion.ProjectPath == "." then
        DisplayMessageBox("Error: The CabinetMaker program Setup this computer. \n Run CabinetMaker Gadget")
    end
end
-- ===================================================
function InquiryDropList(Header, Quest, XX, YY, DList)
--[[
    Drop list foe user input
    Caller = local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
    Dialog Header = "Cabinet Maker"
    User Question = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = String
]]
       DeBug(9190,1, "InquiryDropList")
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto } 
    body, td, th { font-family: Arial, Helvetica, sans-serif font-size: 10px color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 { font-size: 10px; font-weight: bold; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "248" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h1"  id = "Questions"><strong class = "h2">Message Here</strong></td> </tr> <tr> <th width = "20%" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "Questions2"> </th> <th width = "60%" height = "15" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> <select name = "DList" size = "10" class = "h2" id = "ListBox"> <option>Defalt</option> </select> </th> <th width = "20%" height = "15" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"></th> </tr> <tr> <th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th> </tr> <tr> <td colspan = "3" align = "center"  valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 40%"><span style = "width: 40%"> <input id = "ButtonCancel" class = "FormButton"  name = "ButtonCancel" type = "button" value = "Cancel"> </span></td> <td style = "width: 20%"></td> <td style = "width: 40%"><span style = "width: 40%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td> </tr> </table></td> </tr> </table> </body> </html> ]] ; 
    local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ;  dialog:AddLabelField("Questions", Quest) ; dialog:AddDropDownList("ListBox", "DEFAULT") ;     dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
    for index, value in pairs(DList) do ; 
        dialog:AddDropDownListValue("ListBox", value) ; 
    end ; 
    if not dialog:ShowDialog() then ; 
    return "." ; 
    else ; 
    return string.upper(dialog:GetDropDownListValue("ListBox")) ;   
    end    
end
-- ===================================================
function ProjectDropList(Header, Quest, XX, YY, DList)
--[[
    Drop list foe user input
    Caller = local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
    Dialog Header = "Cabinet Maker"
    User Question = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = String
]]
       DeBug(9190,1, "InquiryDropList")
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type">
<title>Cabinet Maker and Tool-path Creator</title>
<style type = "text/css">
html {
	overflow: auto
}
body, td, th {
font-family: Arial, Helvetica, sans-serif font-size: 10px color: #000;
}
.FormButton {
	font-weight: bold;
	width: 100%;
font-family: Arial, Helvetica, sans-serif font-size: 12px;
}
.h1 {
	font-size: 14px;
	font-weight: bold;
}
.h2 {
	font-size: 12px;
	font-weight: bold;
}
.h3 {
	font-size: 10px;
	font-weight: bold;
}
</style>
</head>
<body bgcolor = "#EBEBEB" text = "#000000">
<table width = "248" border = "0" cellpadding = "0">
  <tr>
    <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h1"  id = "Questions"><strong class = "h2">Message Here</strong></td>
  </tr>
  <tr>
    <th width = "41%" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "Questions2"> </th>
    <th width = "39%" height = "15" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> <span class="h2">
      <select name = "DList" size = "10" class = "h2" id = "ListBox">
        <option>Defalt</option>
      </select>
      </span></th>
    <th width = "20%" height = "15" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"></th>
  </tr>
  <tr>
    <th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID2"></th>
  </tr>
  <tr>
    <th height = "10" align = "right" valign = "middle" bgcolor = "#EBEBEB" class="h2" id = "QuestionID"><span class="h2">Show Full Dialog</span></th>
    <th height = "1" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "CabinetStyle"><span class="h2">
      <select name = "DList2" size = "1" class = "h2" id = "DList">
        <option value="1">Full Dialog</option>
        <option value="2">Short Dialog</option>
      </select>
      </span></th>
    <th height = "10" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th>
  </tr>
  <tr>
    <th height = "10" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID3"></th>
    <th height = "10" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID3"></th>
    <th height = "10" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID3"></th>
  </tr>
  <tr>
    <td colspan = "3" align = "center"  valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%">
        <tr align = "right">
          <td style = "width: 40%"><span style = "width: 40%">
            <input id = "ButtonCancel" class = "FormButton"  name = "ButtonCancel" type = "button" value = "Cancel">
            </span></td>
          <td style = "width: 20%"></td>
          <td style = "width: 40%"><span style = "width: 40%">
            <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK">
            </span></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>]] ; 
    local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ;  
    dialog:AddLabelField("Questions", Quest) ; 
    dialog:AddDropDownList("ListBox", "DEFAULT") ;     
    dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
    for index, value in pairs(DList) do ; 
        dialog:AddDropDownListValue("ListBox", value) ; 
    end ; 
    dialog:AddDropDownList("CabinetStyle",                g_FullDialog ) ; 
    dialog:AddDropDownListValue("CabinetStyle",           "Short Dialog") ; 
    dialog:AddDropDownListValue("CabinetStyle",           "Full Dialog") ; 
    
    if not dialog:ShowDialog() then ; 
    return "." ; -- g_FullDialog = "Short Dialog"
    else ; 
    g_FullDialog = dialog:GetDropDownListValue("CabinetStyle") ; 
    return string.upper(dialog:GetDropDownListValue("ListBox")) ;   
    end    
end
-- ===================================================
function CabinetDropList(Header, Quest, XX, YY, DList)
--[[
    Drop list foe user input
    Caller = local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
    Dialog Header = "Cabinet Maker"
    User Question = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = String
]]
       DeBug(9190,1, "InquiryDropList")
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type">
<title>Cabinet Maker and Tool-path Creator</title>
<style type = "text/css">
html {
	overflow: auto
}
body, td, th {
font-family: Arial, Helvetica, sans-serif font-size: 10px color: #000;
}
.FormButton {
	font-weight: bold;
	width: 100%;
font-family: Arial, Helvetica, sans-serif font-size: 12px;
}
.h1 {
	font-size: 14px;
	font-weight: bold;
}
.h2 {
	font-size: 12px;

}
.h3 {
	font-size: 10px;
	font-weight: bold;
}
</style>
</head>
<body bgcolor = "#EBEBEB" text = "#000000">
<table width = "441" border = "0" cellpadding = "0">
  <tr>
    <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h1"  id = "Questions"><strong class = "h2">Build A New Cabnet</strong></td>
  </tr>
  <tr>
    <th width = "138" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" class="h2" id = "Questions2">Select Previous Cabinet </th>
    <th width = "102" height = "15" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> <span class="h2">
      <select name = "DList" size = "10" class = "h2" id = "ListBox">
        <option>Defalt</option>
      </select>
    </span></th>
    <th width = "202" height = "15" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"></th>
  </tr>
  <tr>
    <th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID6"></th>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap bgcolor="#EBEBEB" class="h2">Wall Cabinet Namw</td>
    <td align="center" valign="middle" bgcolor="#EBEBEB"><input name="CabNameWall" type="text" class="h2" id="CabNameWall" size="16" maxlength="10"></td>
    <td align="left" valign="middle" bgcolor="#EBEBEB" class="h2">Wall Cabinet Name or ID Number</td>
  </tr>
  <tr>    
  <td width="138" align="right" valign="middle" nowrap bgcolor="#EBEBEB" class="h2">Wall Cabinet Width</td>
    <td align="center" valign="middle" bgcolor="#EBEBEB"><input name="CabWidthWall" type="text" class="h2" id="CabWidthWall" size="16" maxlength="10"></td>
    <td width="202" align="left" valign="middle" bgcolor="#EBEBEB" class="h2">Wall Cabinet Width (Left to Right)</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap bgcolor="#EBEBEB" class="h2">Wall Cabinet Height</td>
    <td align="center" valign="middle" bgcolor="#EBEBEB"><input name="CabHeightWall" type="text" class="h2" id="CabHeightWall" size="16" maxlength="10"></td>
    <td align="left" valign="middle" bgcolor="#EBEBEB" class="h2">Wall Cabinet Height (Top to Bottom)</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap bgcolor="#EBEBEB" class="h2">Wall Cabinet Depth</td>
    <td align="center" valign="middle" bgcolor="#EBEBEB"><input name="CabDepthWall" type="text" class="h2" id="CabDepthWall" size="16" maxlength="10"></td>
    <td align="left" valign="middle" bgcolor="#EBEBEB" class="h2">Wall Cabinet Depth (Front to Back)</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap class="h2">Material Thickness</td>
    <td align="center" valign="middle"><input name="ThicknessWall" type="text" class="h2" id="ThicknessWall" size="16" maxlength="10"></td>
    <td align="left" valign="middle" class="h2">Material Thickness for Cabinet Sides</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap class="h2">Back Material Thickness</td>
    <td align="center" valign="middle"><input name="ThicknessBackWall" type="text" class="h2" id="ThicknessBackWall" size="16" maxlength="10"></td>
    <td align="left" valign="middle" class="h2">Material Thickness Used On The Back</td>
  </tr>
  <tr>
    <th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th>
  </tr>
  <tr>
    <td colspan = "3" align = "center"  valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%">
        <tr align = "right">
          <td style = "width: 40%"><span style = "width: 40%">
            <input id = "ButtonCancel" class = "FormButton"  name = "ButtonCancel" type = "button" value = "Cancel">
            </span></td>
          <td style = "width: 20%"></td>
          <td style = "width: 40%"><span style = "width: 40%">
            <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK">
            </span></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html> ]] ; 
    local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ;  
    dialog:AddLabelField("Questions", Quest) ; 
    dialog:AddDropDownList("ListBox", "DEFAULT") ;     
    dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
    for index, value in pairs(DList) do ; 
        dialog:AddDropDownListValue("ListBox", value) ; 
    end ; 
    if not dialog:ShowDialog() then ; 
    return "." ; 
    else ; 
    return string.upper(dialog:GetDropDownListValue("ListBox")) ;   
    end    
end
-- ===================================================
function NewSheet(job)
    local layer_manager = job.LayerManager
    -- get current sheet count - note sheet 0 the default sheet counts as one sheet
	local orig_num_sheets = layer_manager.NumberOfSheets
	 -- get current active sheet index
	local orig_active_sheet_index = layer_manager.ActiveSheetIndex
	-- set active sheet to last sheet
	local num_sheets = layer_manager.NumberOfSheets
	layer_manager.ActiveSheetIndex = num_sheets - 1
	job:Refresh2DView();
	-- Add a new sheet
    layer_manager:AddNewSheet()
	-- set active sheet to last sheet we just added
	num_sheets = layer_manager.NumberOfSheets
	layer_manager.ActiveSheetIndex = num_sheets - 1
    job:Refresh2DView();
 end
-- ===================================================
function StdHeaderReader(xPath, Fname) 
       DeBug(9260,1, "StdHeaderReader")
--[[
    Gets the INI Header values of a ini file and uploads to "IniFile" Array 
    IniFile = {} Global variables
    xPath = script_path
]]

    local filename = xPath .. "/" .. Fname .. ".ini"
    local file = io.open(filename, "r")
    local WallMilling = (LengthOfFile(filename) - 1)
    local dat = all_trim(file:read())
    while (WallMilling >= 0) 
    do
        if "[" == string.sub(dat, 1, 1) then
            table.insert (IniFile, string.upper(string.sub(dat, 2, (string.len(dat) - 1))))
        end       
        dat = file:read()
        if dat then
             dat = all_trim(dat)
          else
             return true 
        end
        WallMilling = WallMilling - 1
    end
    file:close() ; 
    return true
end
-- ===================================================
function LengthOfFile(filename)-- Returns file line count
--[[
Counts the lines in a file
returns a number
]]
    DeBug(9270,5, "LengthOfFile " .. filename)
    local len = 0
    if FileExists(filename) then
        local file = io.open(filename)
        for Line in file:lines() do
            len = len + 1
        end
        DeBug(9271,5, "File length = " .. tostring(len)) 
        file:close() ; 
    end
    return len 
end 
-- ===================================================
function G_ReadINICabinetMaker(xPath, xGroup, xFile)
    local filename = xPath .. "\\" .. xFile 
    DeBug(9281, 1, "G_ReadINICabinetMaker - " .. xPath  )
    DeBug(9282, 1, "G_ReadINICabinetMaker - " .. xGroup )
    DeBug(9283, 1, "G_ReadINICabinetMaker - " .. xFile)
    local XX = (filename .. ".ini")
    DeBug(9284, 1, "G_ReadINICabinetMaker - " .. tostring(XX))
  
    if FileExists(XX) then
        DeBug(9281, 1, "G_ReadINICabinetMaker - " .. filename)
        BaseDim.BackPocketDepthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.BackPocketDepthBase", "N")
        BaseDim.BlindDadoSetbackBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.BlindDadoSetbackBase", "N")
        BaseDim.CabDepthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.CabDepthBase", "N")
        BaseDim.CabHeightBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.CabHeightBase", "N")
        BaseDim.CabWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.CabWidthBase", "N")
        BaseDim.FaceFrameBottomRailWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRailWidthBase", "N")
        BaseDim.FaceFrameBottomRevealBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRevealBase", "N")
        BaseDim.FaceFrameCenterStileWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameCenterStileWidthBase", "N")
        BaseDim.FaceFrameRevealBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameRevealBase", "N")
        BaseDim.FaceFrameStileWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameStileWidthBase", "N")
        BaseDim.FaceFrameThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameThicknessBase", "N")
        BaseDim.FaceFrameTopOverlapBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopOverlapBase", "N")
        BaseDim.FaceFrameTopRailWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopRailWidthBase", "N")
        BaseDim.NailerThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerThicknessBase", "N")
        BaseDim.NailerWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerWidthBase", "N")
        BaseDim.RevealBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.RevealBase", "N")
        BaseDim.ShelfCountBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfCountBase", "N")
        BaseDim.ShelfEndClarenceBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfEndClarenceBase", "N")
        BaseDim.ShelfFaceFrameThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameThicknessBase", "N")
        BaseDim.ShelfFaceFrameWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameWidthBase", "N")
        BaseDim.ShelfFrontClearanceBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFrontClearanceBase", "N")
        BaseDim.ShelfHoleFirstRowSpacingBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleFirstRowSpacingBase", "N")
        BaseDim.ShelfHoleLastRowSpacingBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleLastRowSpacingBase", "N")
        BaseDim.ShelfHoleSpacingBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleSpacingBase", "N")
        BaseDim.ShelfMaterialThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfMaterialThicknessBase", "N")
        BaseDim.ShelfPinHoleBackBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleBackBase", "N")
        BaseDim.ShelfPinHoleFrontBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleFrontBase", "N")
        BaseDim.StretcherThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherThicknessBase", "N")
        BaseDim.StretcherWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherWidthBase", "N")
        BaseDim.ThicknessBackBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBackBase", "N")
        BaseDim.ThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBase", "N")
        BaseDim.ToeKickBottomOffsetHightBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickBottomOffsetHightBase", "N")
        BaseDim.ToeKickDepthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickDepthBase", "N")
        BaseDim.ToeKickHightBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickHightBase", "N")
        BaseQuestion.AddBackNailerBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddBackNailerBase", "B")
        BaseQuestion.AddCenterPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddCenterPanelBase", "B")
        BaseQuestion.AddFaceFrameBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddFaceFrameBase", "B")
        BaseQuestion.AddShelfHingPilotHolesBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHingPilotHolesBase", "B")
        BaseQuestion.AddShelfHolesBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHolesBase", "B")
        BaseQuestion.AddShelfingBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfingBase", "B")
        BaseQuestion.AddStretchersBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddStretchersBase", "B")
        BaseQuestion.AddToeKickBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddToeKickBase", "B")
        BaseQuestion.BackDadoOrOverlapBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.BackDadoOrOverlapBase", "S")
        BaseQuestion.DadoStyleBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoStyleBase", "S")
        BaseQuestion.DadoTypeBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoTypeBase", "S")
        BaseQuestion.DrawBackPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelBase", "B")
        BaseQuestion.DrawBackPanelOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelOnNewSheetBase", "B")
        BaseQuestion.DrawBottomPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBottomPanelBase", "B")
        BaseQuestion.DrawCenterPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawCenterPanelBase", "B")
        BaseQuestion.DrawFaceFrameBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameBase", "B")
        BaseQuestion.DrawFaceFrameOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameOnNewSheetBase", "B")
        BaseQuestion.DrawLeftSidePanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawLeftSidePanelBase", "B")
        BaseQuestion.DrawRightSidePanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawRightSidePanelBase", "B")
        BaseQuestion.DrawShelfPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawShelfPanelBase", "B")
        BaseQuestion.DrawTopPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawTopPanelBase", "B")
        BaseQuestion.FaceFrameOrStretchersBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.FaceFrameOrStretchersBase", "S")
        BaseQuestion.NailerLocationBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.NailerLocationBase", "S")
        BaseQuestion.ProvideCabinetNotesOnDrawingBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnDrawingBase", "B")
        BaseQuestion.ProvideCabinetNotesOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnNewSheetBase", "B")
        Hardware.HingBottomClearnace = GetIniValue(xPath, xFile, xGroup, "Hardware.HingBottomClearnace", "N")
        Hardware.HingCountBase = GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountBase", "N")
        Hardware.HingCountWall = GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountWall", "N")
        Hardware.HingTopClearnace = GetIniValue(xPath, xFile, xGroup, "Hardware.HingTopClearnace", "N")
        Hardware.ShelfPinDiameter = GetIniValue(xPath, xFile, xGroup, "Hardware.ShelfPinDiameter", "N")
        Hardware.HingHoleCenters = GetIniValue(xPath, xFile, xGroup, "Hardware.HingHoleCenters", "N")
        Milling.DadoClearnace = GetIniValue(xPath, xFile, xGroup, "Milling.DadoClearnace", "N")
        Milling.DadoToolDia = GetIniValue(xPath, xFile, xGroup, "Milling.DadoToolDia", "N")
        Milling.HalfDadoWidth = GetIniValue(xPath, xFile, xGroup, "Milling.HalfDadoWidth", "N")
        Milling.PilotBitDia = GetIniValue(xPath, xFile, xGroup, "Milling.PilotBitDia", "N")
        Milling.PocketToolDia = GetIniValue(xPath, xFile, xGroup, "Milling.PocketToolDia", "N")
        Milling.ProfileToolDia = GetIniValue(xPath, xFile, xGroup, "Milling.ProfileToolDia", "N")
        Milling.RabbitClearing = GetIniValue(xPath, xFile, xGroup, "Milling.RabbitClearing", "N")
        Milling.SidePocketDepth = GetIniValue(xPath, xFile, xGroup, "Milling.SidePocketDepth", "N")
        Milling.LayerNameSideProfile = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideProfile", "S")
        Milling.LayerNameShelfProfile = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameShelfProfile", "S")
        Milling.LayerNameBackProfile = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameBackProfile", "S")
        Milling.LayerNameTopBottomProfile = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameTopBottomProfile", "S")
        Milling.LayerNameCenterPanleProfile = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameCenterPanleProfile", "S")
        Milling.LayerNameSideTopBottomPocket = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideTopBottomPocket", "S")
        Milling.LayerNameSideBackPocket = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideBackPocket", "S")
        Milling.LayerNameSideStretcherPocket = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideStretcherPocket", "S")
        Milling.LayerNameSideNailerPocket = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideNailerPocket", "S")
        Milling.LayerNameSideShelfPinDrill = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideShelfPinDrill", "S")
        Milling.LayerNameSideHingCentersDrill = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideHingCentersDrill", "S")
        Milling.LayerNameCenterPanleShelfPinDrill = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameCenterPanleShelfPinDrill", "S")
        Milling.LayerNameBackPocket = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameBackPocket", "S")
        Milling.LayerNameTopBottomCenterDado = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameTopBottomCenterDado", "S")
        Milling.LayerNameDrawNotes = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawNotes", "S")
        Milling.LayerNameDrawFaceFrame = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawFaceFrame", "S")
    --  ProjectQuestion.AddCabinetSettingsToProject = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.AddCabinetSettingsToProject", "B")
        ProjectQuestion.ProjectName = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectName", "S")
        ProjectQuestion.CabinetName = NameStrip(GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.CabinetName", "S"), "-")
        ProjectQuestion.ProjectPath = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectPath", "S")
        ProjectQuestion.StartDate = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.StartDate", "S")
        ProjectQuestion.ProjectContactEmail = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactEmail", "S")
        ProjectQuestion.ProjectContactName = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactName", "S")
        ProjectQuestion.ProjectContactPhoneNumber = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactPhoneNumber", "S")
        WallDim.BackPocketDepthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.BackPocketDepthWall", "N")
        WallDim.BlindDadoSetbackWall = GetIniValue(xPath, xFile, xGroup, "WallDim.BlindDadoSetbackWall", "N")
        WallDim.CabDepthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.CabDepthWall", "N")
        WallDim.CabHeightWall = GetIniValue(xPath, xFile, xGroup, "WallDim.CabHeightWall", "N")
        WallDim.CabLengthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.CabLengthWall", "N")
        WallDim.FaceFrameBottomRailWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRailWidthWall", "N")
        WallDim.FaceFrameBottomRevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRevealWall", "N")
        WallDim.FaceFrameCenterStileWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameCenterStileWidthWall", "N")
        WallDim.FaceFrameRevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameRevealWall", "N")
        WallDim.FaceFrameStileWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameStileWidthWall", "N")
        WallDim.FaceFrameThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameThicknessWall", "N")
        WallDim.FaceFrameTopOverlapWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopOverlapWall", "N")
        WallDim.FaceFrameTopRailWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopRailWidthWall", "N")
        WallDim.NailerThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.NailerThicknessWall", "N")
        WallDim.NailerWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.NailerWidthWall", "N")
        WallDim.RevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.RevealWall", "N")
        WallDim.ShelfCountWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfCountWall", "N")
        WallDim.ShelfEndClarenceWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfEndClarenceWall", "N")
        WallDim.ShelfFaceFrameRevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameRevealWall", "N")
        WallDim.ShelfFaceFrameThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameThicknessWall", "N")
        WallDim.ShelfFaceFrameWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameWidthWall", "N")
        WallDim.ShelfFrontClearanceWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFrontClearanceWall", "N")
        WallDim.ShelfHoleFirstRowSpacingWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleFirstRowSpacingWall", "N")
        WallDim.ShelfHoleLastRowSpacingWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleLastRowSpacingWall", "N")
        WallDim.ShelfHoleSpacingWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleSpacingWall", "N")
        WallDim.ShelfMaterialThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfMaterialThicknessWall", "N")
        WallDim.ShelfPinHoleBackWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleBackWall", "N")
        WallDim.ShelfPinHoleFrontWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleFrontWall", "N")
        WallDim.StretcherThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherThicknessWall", "N")
        WallDim.StretcherWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherWidthWall", "N")
        WallDim.ThicknessBackWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessBackWall", "N")
        WallDim.ThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessWall", "N")
        WallQuestion.AddBackNailerWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddBackNailerWall", "B")
        WallQuestion.AddCenterPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddCenterPanelWall", "B")
        WallQuestion.AddFaceFrameWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddFaceFrameWall", "B")
        WallQuestion.AddShelfHingPilotHolesWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHingPilotHolesWall", "B")
        WallQuestion.AddShelfHolesWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHolesWall", "B")
        WallQuestion.AddShelfingWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfingWall", "B")
        WallQuestion.AddStretchersWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddStretchersWall", "B")
        WallQuestion.BackDadoOrOverlapWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.BackDadoOrOverlapWall", "S")
        WallQuestion.DadoStyleWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoStyleWall", "S")
        WallQuestion.DadoTypeWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoTypeWall", "S")
        WallQuestion.DrawBackPanelOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelOnNewSheetWall", "B")
        WallQuestion.DrawBackPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelWall", "B")
        WallQuestion.DrawBottomPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBottomPanelWall", "B")
        WallQuestion.DrawCenterPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawCenterPanelWall", "B")
        WallQuestion.DrawFaceFrameOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameOnNewSheetWall", "B")
        WallQuestion.DrawFaceFrameWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameWall", "B")
        WallQuestion.DrawLeftSidePanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawLeftSidePanelWall", "B")
        WallQuestion.DrawRightSidePanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawRightSidePanelWall", "B")
        WallQuestion.DrawShelfPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawShelfPanelWall", "B")
        WallQuestion.DrawTopPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawTopPanelWall", "B")
        WallQuestion.FaceFrameOrStretchersWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.FaceFrameOrStretchersWall", "S")
        WallQuestion.NailerLocationWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.NailerLocationWall", "S")
        WallQuestion.ProvideCabinetNotesOnDrawingWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnDrawingWall", "B")
        WallQuestion.ProvideCabinetNotesOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnNewSheetWall", "B")
        return true
    else
        DeBug(4384, 3, "No Project path or file found")
        DisplayMessageBox("No Project path or file found")
        return false
    end
end
-- ===================================================
function G_ReadProjectinfo(xPath, xGroup, xFile)
    DeBug(9400,1, "G_ReadProjectinfo" )
    ProjectQuestion.ProjectContactEmail = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactEmail", "S") 
    ProjectQuestion.ProjectContactName = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactName", "S") 
    ProjectQuestion.ProjectContactPhoneNumber = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactPhoneNumber", "S") 
    ProjectQuestion.ProjectName = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectName", "S") 
    ProjectQuestion.ProjectPath = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectPath", "S") 
    ProjectQuestion.StartDate = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.StartDate", "S") 
end
-- ===================================================
function G_IniUpdateFile(xPath, xGroup, xFile, xItem, xValue)
--    DeBug(9450, 1, "G_IniUpdateFile" )
-- G_IniUpdateFile("E:/Test", "Wall", "Bob", "Cabinet Depth", "22")
-- xItem = "Cabinet Depth" 
-- xValue = "22"
    local NfileName = xPath .. "/" .. xFile .. ".ini"
    local OfileName = xPath .. "/" .. xFile .. ".bak"
    os.remove(OfileName)
    --DisplayMessageBox(NfileName)
    --DisplayMessageBox(OfileName)
    os.rename(NfileName, OfileName) -- makes backup file
    local fileR = io.open(OfileName)
    local fileW = io.open(NfileName,  "w")
    local groups = false
    local txt = ""
    for Line in fileR:lines() do
        txt = Line
        if all_trim(Line) == "[" .. all_trim(xGroup) .. "]" then
            groups = true
        end
        if xItem == string.sub(Line, 1, string.len(xItem))  then
            if groups then
            txt = xItem .. "=" .. xValue 
             groups = false
            end
        end
        fileW:write(txt .. "\n") ;
    end
    os.remove(OfileName)
    --   DeBug(9271,5, "File length = " .. tostring(len)) 
    fileR:close() ; 
    fileW:close() ; 
end
-- ===================================================
function G_ReadINIProject(xPath, xGroup, xFile)
    DeBug(9290, 1, "G_ReadINIProject-")
    DeBug(9290, 1, "G_ReadINIProject-" .. xPath)
    DeBug(9290, 1, "G_ReadINIProject-" .. xGroup)
    DeBug(9290, 1, "G_ReadINIProject-" .. xFile)
    BaseDim.BackPocketDepthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.BackPocketDepthBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-BackPocketDepthBase" )
    BaseDim.BlindDadoSetbackBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.BlindDadoSetbackBase", "N") 
    DeBug(9290, 3, "G_ReadINIProject-BlindDadoSetbackBase" )
    BaseDim.CabDepthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.CabDepthBase", "N") 
    DeBug(9290, 3, "G_ReadINIProject-CabDepthBase" )
    BaseDim.CabHeightBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.CabHeightBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-CabHeightBase" )
    BaseDim.CabWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.CabWidthBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-CabWidthBase" )
    BaseDim.FaceFrameBottomRailWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRailWidthBase", "N") 
    DeBug(9290, 3, "G_ReadINIProject-FaceFrameBottomRailWidthBase" )
    BaseDim.FaceFrameBottomRevealBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRevealBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-FaceFrameBottomRevealBase" )
    BaseDim.FaceFrameCenterStileWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameCenterStileWidthBase", "N")
    DeBug(9290, 3 , "G_ReadINIProject-FaceFrameCenterStileWidthBase" )
    BaseDim.FaceFrameRevealBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameRevealBase", "N")
    BaseDim.FaceFrameStileWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameStileWidthBase", "N")
    DeBug(9290, 3 , "G_ReadINIProject-FaceFrameStileWidthBase" )
    BaseDim.FaceFrameThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameThicknessBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-FaceFrameThicknessBase" )
    BaseDim.FaceFrameTopOverlapBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopOverlapBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-FaceFrameTopOverlapBase" )
    BaseDim.FaceFrameTopRailWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopRailWidthBase", "N") 
    DeBug(9290, 3, "G_ReadINIProject-FaceFrameTopRailWidthBase" )
    BaseDim.NailerThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerThicknessBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-NailerThicknessBase" )
    BaseDim.NailerWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerWidthBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-NailerWidthBase" )
    BaseDim.RevealBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.RevealBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-RevealBase" )
    BaseDim.ShelfCountBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfCountBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-ShelfCountBase" )
    BaseDim.ShelfEndClarenceBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfEndClarenceBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-ShelfEndClarenceBase" )
    BaseDim.ShelfFaceFrameThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameThicknessBase", "N") 
    DeBug(9290, 3, "G_ReadINIProject-ShelfFaceFrameThicknessBase" )
    BaseDim.ShelfFaceFrameWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameWidthBase", "N") 
    DeBug(9290, 3, "G_ReadINIProject-ShelfFaceFrameWidthBase" )
    BaseDim.ShelfFrontClearanceBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFrontClearanceBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-ShelfFrontClearanceBase" )
    BaseDim.ShelfHoleFirstRowSpacingBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleFirstRowSpacingBase", "N")
    BaseDim.ShelfHoleLastRowSpacingBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleLastRowSpacingBase", "N")
    BaseDim.ShelfHoleSpacingBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleSpacingBase", "N")
    BaseDim.ShelfMaterialThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfMaterialThicknessBase", "N")
    BaseDim.ShelfPinHoleBackBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleBackBase", "N")
    BaseDim.ShelfPinHoleFrontBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleFrontBase", "N")
    BaseDim.StretcherThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherThicknessBase", "N")
    DeBug(9290, 3, "G_ReadINIProject-StretcherThicknessBase" )
    BaseDim.StretcherWidthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherWidthBase", "N")
    BaseDim.ThicknessBackBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBackBase", "N")
    BaseDim.ThicknessBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBase", "N")
    BaseDim.ToeKickBottomOffsetHightBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickBottomOffsetHightBase", "N")
    BaseDim.ToeKickDepthBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickDepthBase", "N")
    BaseDim.ToeKickHightBase = GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickHightBase", "N") 
    BaseQuestion.AddBackNailerBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddBackNailerBase",  "B") 
    BaseQuestion.AddCenterPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddCenterPanelBase",  "B") 
    BaseQuestion.AddFaceFrameBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddFaceFrameBase",  "B") 
    BaseQuestion.AddShelfHingPilotHolesBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHingPilotHolesBase",  "B") 
    BaseQuestion.AddShelfHolesBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHolesBase",  "B") 
    BaseQuestion.AddShelfingBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfingBase",  "B") 
    BaseQuestion.AddStretchersBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddStretchersBase",  "B") 
    BaseQuestion.AddToeKickBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddToeKickBase",  "B") 
    BaseQuestion.BackDadoOrOverlapBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.BackDadoOrOverlapBase", "S") 
    DeBug(9290, 3, "G_ReadINIProject-BackDadoOrOverlapBase" )
    BaseQuestion.DadoStyleBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoStyleBase", "S") 
    BaseQuestion.DadoTypeBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoTypeBase", "S") 
    BaseQuestion.DrawBackPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelBase",  "B") 
    BaseQuestion.DrawBackPanelOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelOnNewSheetBase",  "B") 
    BaseQuestion.DrawBottomPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBottomPanelBase",  "B") 
    BaseQuestion.DrawCenterPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawCenterPanelBase",  "B") 
    BaseQuestion.DrawFaceFrameBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameBase",  "B") 
    BaseQuestion.DrawFaceFrameOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameOnNewSheetBase",  "B") 
    BaseQuestion.DrawLeftSidePanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawLeftSidePanelBase",  "B") 
    BaseQuestion.DrawRightSidePanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawRightSidePanelBase",  "B") 
    BaseQuestion.DrawShelfPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawShelfPanelBase",  "B") 
    BaseQuestion.DrawTopPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawTopPanelBase",  "B") 
    BaseQuestion.FaceFrameOrStretchersBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.FaceFrameOrStretchersBase",  "B") 
    BaseQuestion.NailerLocationBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.NailerLocationBase", "S") 
    BaseQuestion.ProvideCabinetNotesOnDrawingBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnDrawingBase",  "B") 
    BaseQuestion.ProvideCabinetNotesOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnNewSheetBase",  "B")  
--    ProjectQuestion.AddCabinetSettingsToProject = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.AddCabinetSettingsToProject",  "B") 
    ProjectQuestion.CabinetName = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.CabinetName", "S") 
    
    Hardware.HingBottomClearnace = GetIniValue(xPath, xFile, xGroup, "Hardware.HingBottomClearnace",  "N")  
    Hardware.HingCountBase = GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountBase",  "N")  
    Hardware.HingCountWall = GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountWall",  "N")  
    Hardware.HingTopClearnace = GetIniValue(xPath, xFile, xGroup, "Hardware.HingTopClearnace",  "N")  
    Hardware.ShelfPinDiameter = GetIniValue(xPath, xFile, xGroup, "Hardware.ShelfPinDiameter",  "N")  
    Hardware.HingHoleCenters = GetIniValue(xPath, xFile, xGroup, "Hardware.HingHoleCenters",  "N")  
    Milling.DadoClearnace = GetIniValue(xPath, xFile, xGroup, "Milling.DadoClearnace", "N") 
    Milling.DadoToolDia = GetIniValue(xPath, xFile, xGroup, "Milling.DadoToolDia", "N")  
    Milling.HalfDadoWidth = GetIniValue(xPath, xFile, xGroup, "Milling.HalfDadoWidth", "N") 
    Milling.PilotBitDia = GetIniValue(xPath, xFile, xGroup, "Milling.PilotBitDia", "N")  
    Milling.PocketToolDia = GetIniValue(xPath, xFile, xGroup, "Milling.PocketToolDia", "N") 
    Milling.ProfileToolDia = GetIniValue(xPath, xFile, xGroup, "Milling.ProfileToolDia", "N") 
    Milling.RabbitClearing = GetIniValue(xPath, xFile, xGroup, "Milling.RabbitClearing", "N") 
    Milling.SidePocketDepth = GetIniValue(xPath, xFile, xGroup, "Milling.SidePocketDepth", "N") 
    DeBug(9290,5, "X - 1")    
    WallDim.BackPocketDepthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.BackPocketDepthWall", "N")  
    DeBug(9290, 5, "X - 2") 
    WallDim.BlindDadoSetbackWall = GetIniValue(xPath, xFile, xGroup, "WallDim.BlindDadoSetbackWall", "N") 
    WallDim.CabDepthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.CabDepthWall", "N") 
    WallDim.CabHeightWall = GetIniValue(xPath, xFile, xGroup, "WallDim.CabHeightWall", "N") 
    WallDim.CabLengthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.CabLengthWall", "N") 
    WallDim.FaceFrameBottomRailWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRailWidthWall", "N") 
    WallDim.FaceFrameBottomRevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRevealWall", "N") 
    DeBug(9290, 3, "FaceFrameBottomRevealWall" )
    WallDim.FaceFrameCenterStileWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameCenterStileWidthWall", "N") 
    WallDim.FaceFrameRevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameRevealWall", "N") 
    WallDim.FaceFrameStileWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameStileWidthWall", "N") 
    WallDim.FaceFrameThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameThicknessWall", "N") 
    WallDim.FaceFrameTopOverlapWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopOverlapWall", "N") 
    WallDim.FaceFrameTopRailWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopRailWidthWall", "N")
    WallDim.NailerThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.NailerThicknessWall", "N") 
    WallDim.NailerWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.NailerWidthWall", "N") 
    WallDim.RevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.RevealWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-RevealWall" )
    WallDim.ShelfCountWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfCountWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfCountWall" )
    WallDim.ShelfEndClarenceWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfEndClarenceWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfEndClarenceWall" )
    WallDim.ShelfFaceFrameRevealWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameRevealWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfFaceFrameRevealWall" )
    WallDim.ShelfFaceFrameThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameThicknessWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfFaceFrameThicknessWall" )
    WallDim.ShelfFaceFrameWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameWidthWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfFaceFrameWidthWall" )
    WallDim.ShelfFrontClearanceWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFrontClearanceWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfFrontClearanceWall" )
    WallDim.ShelfHoleFirstRowSpacingWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleFirstRowSpacingWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfHoleFirstRowSpacingWall" )
    WallDim.ShelfHoleLastRowSpacingWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleLastRowSpacingWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfHoleLastRowSpacingWall" )
    WallDim.ShelfHoleSpacingWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleSpacingWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfHoleSpacingWall" )
    WallDim.ShelfMaterialThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfMaterialThicknessWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfMaterialThicknessWall" )
    WallDim.ShelfPinHoleBackWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleBackWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfPinHoleBackWall" )
    WallDim.ShelfPinHoleFrontWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleFrontWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-ShelfPinHoleFrontWall" )
    WallDim.StretcherThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherThicknessWall", "N") 
    WallDim.StretcherWidthWall = GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherWidthWall", "N") 
       DeBug(9290, 3, "G_ReadINIProject-StretcherWidthWall" )
    WallDim.ThicknessBackWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessBackWall", "N") 
    WallDim.ThicknessWall = GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessWall", "N") 
    WallQuestion.AddBackNailerWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddBackNailerWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-AddBackNailerWall" )
    WallQuestion.AddCenterPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddCenterPanelWall",  "B") 
    WallQuestion.AddFaceFrameWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddFaceFrameWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-AddFaceFrameWall" )
    WallQuestion.AddShelfHingPilotHolesWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHingPilotHolesWall",  "B") 
    WallQuestion.AddShelfHolesWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHolesWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-AddShelfHolesWall" )
    WallQuestion.AddShelfingWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfingWall",  "B") 
    WallQuestion.AddStretchersWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddStretchersWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-AddStretchersWall" )
    WallQuestion.BackDadoOrOverlapWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.BackDadoOrOverlapWall", "S")
       DeBug(9290, 3, "G_ReadINIProject-BackDadoOrOverlapWall" )
    WallQuestion.DadoStyleWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoStyleWall", "S")
       DeBug(9290, 3, "G_ReadINIProject-DadoStyleWall" )
    WallQuestion.DadoTypeWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoTypeWall", "S")
       DeBug(9290, 3, "G_ReadINIProject-DadoTypeWall" )
    WallQuestion.DrawBackPanelOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelOnNewSheetWall",  "B") 
    WallQuestion.DrawBackPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-DrawBackPanelWall" )
    WallQuestion.DrawBottomPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBottomPanelWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-DrawBottomPanelWall" )
    WallQuestion.DrawCenterPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawCenterPanelWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-DrawCenterPanelWall" )
    WallQuestion.DrawFaceFrameOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameOnNewSheetWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-DrawFaceFrameOnNewSheetWall" )
    WallQuestion.DrawFaceFrameWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-DrawFaceFrameWall" )
    WallQuestion.DrawLeftSidePanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawLeftSidePanelWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-DrawLeftSidePanelWall" )
    WallQuestion.DrawRightSidePanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawRightSidePanelWall",  "B") 
    WallQuestion.DrawShelfPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawShelfPanelWall",  "B") 
    WallQuestion.DrawTopPanelWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawTopPanelWall",  "B") 
    WallQuestion.FaceFrameOrStretchersWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.FaceFrameOrStretchersWall", "S")
       DeBug(9290, 3, "G_ReadINIProject-FaceFrameOrStretchersWall" )
    WallQuestion.NailerLocationWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.NailerLocationWall", "S")
    WallQuestion.ProvideCabinetNotesOnDrawingWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnDrawingWall",  "B") 
    WallQuestion.ProvideCabinetNotesOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnNewSheetWall",  "B") 
       DeBug(9290, 3, "G_ReadINIProject-ProvideCabinetNotesOnNewSheetWall" )
    return true
end
-- ===================================================
function all_trim(s) -- Trims spaces off both ends of a string
       DeBug(9300, 9, "all_trim-" )
    return s:match( "^%s*(.-)%s*$" )
end
-- ===================================================

-- ===================================================
function Polar2D(pt, ang, dis)
       DeBug(9330, 9, "Polar2D-")
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end -- function end
-- ===================================================
function Holer(job, pt, ang, dst, dia, lay)
    DeBug(9340,1, "Holer")
    local group = ContourGroup(true) ; 
--    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0)) ; 

    BuildCircle(pt, dia)
    pt = Polar2D(pt, ang, dst)
--   group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   
--    AddGroupToJob(job, group, lay)  
    BuildCircle(pt, dia)    
    job:Refresh2DView()
    return true   
end -- function end
-- ===================================================
function CADLeters(job, pt, letter, scl, lay)
       DeBug(9350,7, "CADLeters")
    scl = (scl * 0.5)
    local pA0 = pt ; local pA1 = Polar2D(pt, 90.0000, (0.2500 * scl)) ; local pA2 = Polar2D(pt, 90.0000, (0.5000 * scl)) ; local pA3 = Polar2D(pt, 90.0000, (0.7500 * scl)) ; local pA4 = Polar2D(pt, 90.0000, (1.0000 * scl)) ; local pA5 = Polar2D(pt, 90.0000, (1.2500 * scl)) ; local pA6 = Polar2D(pt, 90.0000, (1.5000 * scl)) ; local pA7 = Polar2D(pt, 90.0000, (1.7500 * scl)) ; local pA8 = Polar2D(pt, 90.0000, (2.0000 * scl)) ; local pB0 = Polar2D(pt,  0.0000, (0.2500 * scl)) ; local pB1 = Polar2D(pt, 45.0000, (0.3536 * scl)) ; local pB3 = Polar2D(pt, 71.5651, (0.7906 * scl)) ; local pB4 = Polar2D(pt, 75.9638, (1.0308 * scl)) ; local pB5 = Polar2D(pt, 78.6901, (1.2748 * scl)) ; local pB7 = Polar2D(pt, 81.8699, (1.7678 * scl)) ; local pB8 = Polar2D(pt, 82.8750, (2.0156 * scl)) ; local pB10 = Polar2D(pt, 84.2894, (2.5125 * scl)) ; local pC0 = Polar2D(pt,  0.0000, (0.5000 * scl)) ; local pC2 = Polar2D(pt, 45.0000, (0.7071 * scl)) ; local pC8 = Polar2D(pt, 75.9638, (2.0616 * scl)) ; local pC10 = Polar2D(pt,78.6901, (2.5125 * scl)) ; local pD0 = Polar2D(pt,  0.0000, (0.6250 * scl)) ; local pD1 = Polar2D(pt, 21.8014, (0.6731 * scl)) ; local pD4 = Polar2D(pt, 57.9946, (1.1792 * scl)) ; local pD7 = Polar2D(pt, 70.3462, (1.8583 * scl)) ; local pD8 = Polar2D(pt, 72.6460, (2.0954 * scl)) ; local pE0 = Polar2D(pt,  0.0000, (0.7500 * scl)) ; local pE2 = Polar2D(pt, 33.6901, (0.9014 * scl)) ; local pE3 = Polar2D(pt, 45.0000, (1.0607 * scl)) ; local pE8 = Polar2D(pt, 69.4440, (2.1360 * scl)) ; local pF0 = Polar2D(pt,  0.0000, (1.0000 * scl)) ; local pF3 = Polar2D(pt, 36.8699, (1.2500 * scl)) ; local pF4 = Polar2D(pt, 45.0000, (1.4142 * scl)) ; local pF7 = Polar2D(pt, 60.2551, (2.0156 * scl)) ; local pF8 = Polar2D(pt, 63.4349, (2.2361 * scl)) ; local pF10 = Polar2D(pt,59.0362, (2.9155 * scl)) ; local pG0 = Polar2D(pt,  0.0000, (1.2500 * scl)) ; local pG1 = Polar2D(pt, 11.3099, (1.2748 * scl)) ; local pG2 = Polar2D(pt, 21.8014, (1.3463 * scl)) ; local pG3 = Polar2D(pt, 30.9638, (1.4577 * scl)) ; local pG4 = Polar2D(pt, 38.6598, (1.6008 * scl)) ; local pG5 = Polar2D(pt, 45.0000, (1.7678 * scl)) ; local pG6 = Polar2D(pt, 50.1944, (1.9526 * scl)) ; local pG7 = Polar2D(pt, 54.4623, (2.1506 * scl)) ; local pG8 = Polar2D(pt, 57.9946, (2.3585 * scl)) ; local pH0 = Polar2D(pt,  0.0000, (1.5000 * scl)) ; local pH10 = Polar2D(pt,63.4349, (2.7951 * scl)) ; local group = ContourGroup(true) ; local layer = job.LayerManager:GetLayerWithName(lay) ; local line = Contour(0.0) ; 
    if letter == 65 then ; line:AppendPoint(pA0) ; line:LineTo(pD8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pF3) ; layer:AddObject(CreateCadContour(line), true) ; end
    if letter == 66 then ; line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; end
    if letter == 67 then ; line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 68 then ; line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 69 then ; line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 70 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 71 then ; line:AppendPoint(pG6) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 72 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 73 then ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end
    if letter == 74 then ; line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 75 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 76 then ; line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 77 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 78 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end
    if letter == 79 then ; line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 80 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 81 then ; line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 82 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 83 then ; line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)    
    end  
    if letter == 84 then ; line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 85 then ; line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 86 then ; line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 87 then ; line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end     
    if letter == 88 then ; line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 89 then ; line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 90 then ; line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 48 then ; line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 49 then ; line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 50 then ; line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 51 then ; line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 52 then ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 53 then ; line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 54 then ; line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 55 then ; line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 56 then ; line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ; 
    end   
    if letter == 57 then ; line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 47 then ; line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 43 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 61 then ; line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 45 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 39 then ; line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0 
    end   
    if letter == 34 then ; line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end   
    if letter == 40 then ; line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end   
    if letter == 41 then ; line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 60 then ; line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 62 then ; line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 95 then ; line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 58 then ; line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 46 then ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 59 then ; line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
     if letter == 35 then ; line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) 
    end    
    if letter == 32 then ; pH0 = pH0 
    end   
    if letter == 33 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 36 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 37 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 38 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 42 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 63 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 64 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 91 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 92 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 93 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 94 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 96 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 123 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 124 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 125 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 126 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    return pH0  
end -- function end
-- ===================================================
function SelectCabinet()
    if ProjectQuestion.ProjectName ~= "." then 
        DeBug(6011,1, "SelectCabinet A  - " )     
        G_ReadINIProject(ProjectQuestion.ProjectPath,  ProjectQuestion.ProjectCabinetWall, ProjectQuestion.ProjectName) -- Load per selection 
    else
        DeBug(6012, 1, "SelectCabinet B - " )    
        -- goto exit ;-- when timing of want to finish script.
    end
end
-- ===================================================
function CutListfileWriter(xPath)
    if WallQuestion.ProvideCabinetNotesOnDrawingWall then 
        DeBug(9380,1, "CutListfileWriter")
        local A1 = os.date("%B %d, %Y") ; 
        local dY = os.date("%Y") ; 
        local dM = os.date("%m") ; 
        local dD = os.date("%d") ; 
        local dH = os.date("%I") ; 
        local dMin = os.date("%M") ; 
        --local xPath = InquiryPathBox("Cabinet Maker", "Job Path", xPath) ; 

        if WallQuestion.PartLength == 0 then ; 
            WallDim.PartLength = (g_boxLength - (WallDim.ThicknessWall * 2) + (WallDim.ShelfEndClarenceWall * 2)) ; 
            WallDim.PartDepth = (g_boxDepth - (WallDim.ThicknessBackWall * 0.5)) ; 
        end ; 
        local file = io.open(xPath .. "//CutList" .. dY .. dM .. dD .. dMin .. ".dat", "w")
        -- Get the file open for writing lines to the file
        file:write("================================================================ \n") ; 
        file:write("================ Upper Cabinet Cut-list  ====================== \n") ; 
        file:write("----------------------------------------------------------------\n") ; 
        file:write("Run Date = " .. A1 .. "\n") ; 
        file:write("Cabinet Style = " .. ProjectQuestion.ProgramName .. "\n") ; 
        file:write("================================================================ \n") ;
        file:write("Project Name = " .. string.upper(ProjectQuestion.ProjectName) .. "\n") ; 
        file:write("Wall Cabinet size\n") ; 
        file:write("Cabinet Hight = " .. WallDim.CabHeightWall .. "\n") ; 
        file:write("Cabinet Length = " .. WallDim.CabLengthWall .. "\n") ; 
        file:write("Cabinet Depth = " .. WallDim.CabDepthWall .. "\n") ; 
        file:write("Face Frame Diagonal = " .. math.sqrt ((WallDim.CabHeightWall * WallDim.CabHeightWall)+ (WallDim.CabLengthWall *   WallDim.CabLengthWall)) .. "\n") ; 
        file:write("----------------------------------------------------------------\n") ; 
        -- Shelf info
        if WallQuestion.AddBackNailerWall then ; file:write("Nailer Frames          - 2 pcs of " .. WallDim.NailerThicknessWall .. " Plywood " .. WallDim.NailerWidthWall .. " X " .. g_backWidth .. " \n")
        end
        if WallDim.ShelfCountWall >= 1 then ; file:write("Shelf Face Frame       - " .. WallDim.ShelfCountWall .. " pcs of " .. WallDim.ShelfFaceFrameWidthWall .. " Hardwood " .. WallDim.ShelfFaceFrameThicknessWall .. " X " .. WallDim.PartLength .. " \n")
        end
        if WallDim.ShelfCountWall >= 1 then ; file:write("Shelf Panel            - " .. WallDim.ShelfCountWall .. " pcs of " .. WallDim.ThicknessWall .. " Plywood " .. WallDim.PartDepth .. " X " .. WallDim.PartLength .. " \n") ; 
        end
        file:write("Face Frame Top Rail    - 1 pcs of " .. WallDim.FaceFrameTopRailWidthWall .. " Hardwood " .. WallDim.FaceFrameThicknessWall .. " X " .. WallDim.FaceFrameRailLengthWall .. " \n") ; 
        file:write("Face Frame Stiles      - 2 pcs of " .. WallDim.FaceFrameBottomRailWidthWall .. " Hardwood " .. WallDim.FaceFrameThicknessWall .. " X " .. WallDim.FaceFrameStileLengthWall .. " \n") ; 
        file:write("Face Frame Bottom Rail - 1 pcs of " .. WallDim.FaceFrameBottomRailWidthWall .. " Hardwood " .. WallDim.FaceFrameThicknessWall .. " X " .. WallDim.FaceFrameRailLengthWall .. " \n") ; 
        if WallQuestion.AddCenterFaceFrame then ; file:write("Face Frame Center      - 1 pcs of " .. WallDim.FaceFrameBottomRailWidthWall .. " Hardwood " .. WallDim.FaceFrameThicknessWall .. " X " .. WallDim.FaceFrameCenterStileLengthWall .. " \n") ; 
        end
        if WallQuestion.AddCenterPanelWall then ; file:write("Center Panel           - 1 pcs of " .. WallDim.ThicknessWall .. " Plywood " .. (g_boxDepth + (WallDim.ThicknessBackWall * 0.5)) .. " X " .. g_boxHight - WallDim.ThicknessWall .. " \n") ; 
        end
        file:write("Sides Panels           - 2 pcs of " .. WallDim.ThicknessWall .. " Plywood " .. g_boxDepth .. " X " .. g_boxHight .. "\n") ; 
        file:write("Top and Bottom Panels  - 2 pcs of " .. WallDim.ThicknessWall .. " Plywood " .. g_boxDepth .. " X " .. g_boxLength .. "\n") ; 
        file:write("Back Panel             - 1 pcs of " .. WallDim.ThicknessBackWall .. " Plywood " .. g_backHight .. " X " .. g_backWidth .. "\n") ; 
        file:write("----------------------------------------------------------------\n") ; 
        file:close()-- closes the the door on the open file
    end
end -- function end
-- ===================================================
function BuildLine(pt1, pt2)
       DeBug(9390,1, "BuildLine")
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ; 
    return line
end -- function end
-- ===================================================
function BuildBox(job, pt1, lay, xx, yy)
    DeBug(9410,1, "BuildBox")
--[[
pt1 = 2Dpoint (2,2) 
lay = "Jim" 
xx = 22
yy = 24
]]
--[[ -- makes object in a Group
    local line = Contour(0.0) ;-- use default tolerance
    line:AppendPoint(pt1) ; 
    line:LineTo(Polar2D(pt1, 0, xx)) ; 
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) ; 
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) ; 
    line:LineTo(pt1) ; 
    return line
    ]]  
    DeBug(9410, 3, "BuildBox-lay = " .. tostring(lay))
    -- makes closed rectangle object in a non-Group    
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    DeBug(9411, 3, "BuildBox-lay = " .. tostring(lay))
    local line = Contour(0.0) ; 
    DeBug(9412, 3, "BuildBox-line")
    line:AppendPoint(pt1) ; 
    DeBug(9413, 3, "BuildBox-AppendPoint")
    line:LineTo(Polar2D(pt1, 0, xx)) ; 
    DeBug(9414, 3, "BuildBox-pt1")
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) ; 
    DeBug(9415, 3, "BuildBox-pt2")
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) ;  
    DeBug(9416, 3, "BuildBox-pt3")
    line:LineTo(pt1) ; 
    DeBug(9417, 3, "BuildBox-pt4")
    layer:AddObject(CreateCadContour(line), true)
    DeBug(9418, 3, "BuildBox-Done")
end -- function end
-- ===================================================
function BuildCircle(pt1, lay, crad)
    DeBug(9420,1, "BuildCircle")

    --[[ --BuildCircle
        pt1 = 2Dpoint (2,2) 
        lay = "Jim" 
        crad = 0.125
    ]]
--[[    -- makes Circle object in a Group
    local line = Contour(0.0)
    DeBug(9425,5, tostring(crad))
    line:AppendPoint(Polar2D(pt1, 0, crad))    
    line:ArcTo(Polar2D(pt1, 180, crad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, crad), 1.0)
    return line
    ]]
    
    -- makes Circle object in a non-Group    
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(Polar2D(pt1, 0, crad)) ; 
    line:LineTo(Polar2D(pt1, 0, xx)) ; 
    line:ArcTo(Polar2D(pt1, 180, crad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, crad), 1.0)
    layer:AddObject(CreateCadContour(line), true)    
    
    
end -- function end
-- ===================================================
function DrawWriter(what, where, size, lay)
       DeBug(9430,3, "DrawWriter")
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    local strlen = string.len(what) ; 
    local strup = string.upper(what) ; 
    local x = strlen ; 
    local i = 1 ; 
    local y = "" ; 
    local ptx = where ; 
    while i <= x do ; 
      y = string.byte(string.sub(strup, i, i)) ; 
      ptx = CADLeters(job, ptx, y , size, lay) ; 
      i = i + 1 ; 
    end ; 
end -- function end
-- ===================================================
function StdFileWriter(xPath, Fname, CabNames) 
       DeBug(9240,1, "StdFileWriter")
--[[
    Adds Standard Upper Wall Cabinet to the INI file 
    xPath = script_path
    Names = Group Name
    Returns = true
]]
    local file = io.open(xPath .. "/" .. Fname .. ".ini", "a") ; 
    file:write("[" .. string.upper(CabNames) .. "]\n") ; 
        DeBug(9240,1, "StdFileWriter 1")
    file:write("BaseDim.BackPocketDepthBase = " .. tostring(BaseDim.BackPocketDepthBase ) .. " \n") ;
    file:write("BaseDim.BlindDadoSetbackBase = " .. tostring(BaseDim.BlindDadoSetbackBase ) .. " \n") ;
    file:write("BaseDim.CabDepthBase = " .. tostring(BaseDim.CabDepthBase ) .. " \n") ;
    file:write("BaseDim.CabHeightBase = " .. tostring(BaseDim.CabHeightBase ) .. " \n") ;
    file:write("BaseDim.CabWidthBase = " .. tostring(BaseDim.CabWidthBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameBottomRailWidthBase = " .. tostring(BaseDim.FaceFrameBottomRailWidthBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameBottomRevealBase = " .. tostring(BaseDim.FaceFrameBottomRevealBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameCenterStileWidthBase = " .. tostring(BaseDim.FaceFrameCenterStileWidthBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameRevealBase = " .. tostring(BaseDim.FaceFrameRevealBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameStileWidthBase = " .. tostring(BaseDim.FaceFrameStileWidthBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameThicknessBase = " .. tostring(BaseDim.FaceFrameThicknessBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameTopOverlapBase = " .. tostring(BaseDim.FaceFrameTopOverlapBase ) .. " \n") ;
    file:write("BaseDim.FaceFrameTopRailWidthBase = " .. tostring(BaseDim.FaceFrameTopRailWidthBase ) .. " \n") ;
    file:write("BaseDim.NailerThicknessBase = " .. tostring(BaseDim.NailerThicknessBase ) .. " \n") ;
    file:write("BaseDim.NailerWidthBase = " .. tostring(BaseDim.NailerWidthBase ) .. " \n") ;
    file:write("BaseDim.RevealBase = " .. tostring(BaseDim.RevealBase ) .. " \n") ;
    file:write("BaseDim.ShelfCountBase = " .. tostring(BaseDim.ShelfCountBase ) .. " \n") ;
    file:write("BaseDim.ShelfEndClarenceBase = " .. tostring(BaseDim.ShelfEndClarenceBase ) .. " \n") ;
    file:write("BaseDim.ShelfFaceFrameThicknessBase = " .. tostring(BaseDim.ShelfFaceFrameThicknessBase ) .. " \n") ;
    file:write("BaseDim.ShelfFaceFrameWidthBase = " .. tostring(BaseDim.ShelfFaceFrameWidthBase ) .. " \n") ;
    file:write("BaseDim.ShelfFrontClearanceBase = " .. tostring(BaseDim.ShelfFrontClearanceBase ) .. " \n") ;
    file:write("BaseDim.ShelfHoleFirstRowSpacingBase = " .. tostring(BaseDim.ShelfHoleFirstRowSpacingBase ) .. " \n") ;
    file:write("BaseDim.ShelfHoleLastRowSpacingBase = " .. tostring(BaseDim.ShelfHoleLastRowSpacingBase ) .. " \n") ;
    file:write("BaseDim.ShelfHoleSpacingBase = " .. tostring(BaseDim.ShelfHoleSpacingBase ) .. " \n") ;
    file:write("BaseDim.ShelfMaterialThicknessBase = " .. tostring(BaseDim.ShelfMaterialThicknessBase ) .. " \n") ;
    file:write("BaseDim.ShelfPinHoleBackBase = " .. tostring(BaseDim.ShelfPinHoleBackBase ) .. " \n") ;
    file:write("BaseDim.ShelfPinHoleFrontBase = " .. tostring(BaseDim.ShelfPinHoleFrontBase ) .. " \n") ;
    file:write("BaseDim.StretcherThicknessBase = " .. tostring(BaseDim.StretcherThicknessBase ) .. " \n") ;
    file:write("BaseDim.StretcherWidthBase = " .. tostring(BaseDim.StretcherWidthBase ) .. " \n") ;
    file:write("BaseDim.ThicknessBackBase = " .. tostring(BaseDim.ThicknessBackBase ) .. " \n") ;
    file:write("BaseDim.ThicknessBase = " .. tostring(BaseDim.ThicknessBase ) .. " \n") ;
    file:write("BaseDim.ToeKickBottomOffsetHightBase = " .. tostring(BaseDim.ToeKickBottomOffsetHightBase ) .. " \n") ;
    file:write("BaseDim.ToeKickDepthBase = " .. tostring(BaseDim.ToeKickDepthBase ) .. " \n") ;
    file:write("BaseDim.ToeKickHightBase = " .. tostring(BaseDim.ToeKickHightBase ) .. " \n") ;
    file:write("BaseQuestion.AddBackNailerBase = " .. tostring(BaseQuestion.AddBackNailerBase ) .. " \n") ;
    file:write("BaseQuestion.AddCenterPanelBase = " .. tostring(BaseQuestion.AddCenterPanelBase ) .. " \n") ;
    file:write("BaseQuestion.AddFaceFrameBase = " .. tostring(BaseQuestion.AddFaceFrameBase ) .. " \n") ;
    file:write("BaseQuestion.AddShelfHingPilotHolesBase = " .. tostring(BaseQuestion.AddShelfHingPilotHolesBase ) .. " \n") ;
    file:write("BaseQuestion.AddShelfHolesBase = " .. tostring(BaseQuestion.AddShelfHolesBase ) .. " \n") ;
    file:write("BaseQuestion.AddShelfingBase = " .. tostring(BaseQuestion.AddShelfingBase ) .. " \n") ;
    file:write("BaseQuestion.AddStretchersBase = " .. tostring(BaseQuestion.AddStretchersBase ) .. " \n") ;
    file:write("BaseQuestion.AddToeKickBase = " .. tostring(BaseQuestion.AddToeKickBase ) .. " \n") ;
    file:write("BaseQuestion.BackDadoOrOverlapBase = " .. tostring(BaseQuestion.BackDadoOrOverlapBase ) .. " \n") ;
    file:write("BaseQuestion.DadoStyleBase = " .. tostring(BaseQuestion.DadoStyleBase ) .. " \n") ;
    file:write("BaseQuestion.DadoTypeBase = " .. tostring(BaseQuestion.DadoTypeBase ) .. " \n") ;
    file:write("BaseQuestion.DrawBackPanelBase = " .. tostring(BaseQuestion.DrawBackPanelBase ) .. " \n") ;
    file:write("BaseQuestion.DrawBackPanelOnNewSheetBase = " .. tostring(BaseQuestion.DrawBackPanelOnNewSheetBase ) .. " \n") ;
    file:write("BaseQuestion.DrawBottomPanelBase = " .. tostring(BaseQuestion.DrawBottomPanelBase ) .. " \n") ;
    file:write("BaseQuestion.DrawCenterPanelBase = " .. tostring(BaseQuestion.DrawCenterPanelBase ) .. " \n") ;
    file:write("BaseQuestion.DrawFaceFrameBase = " .. tostring(BaseQuestion.DrawFaceFrameBase ) .. " \n") ;
    file:write("BaseQuestion.DrawFaceFrameOnNewSheetBase = " .. tostring(BaseQuestion.DrawFaceFrameOnNewSheetBase ) .. " \n") ;
    file:write("BaseQuestion.DrawLeftSidePanelBase = " .. tostring(BaseQuestion.DrawLeftSidePanelBase ) .. " \n") ;
    file:write("BaseQuestion.DrawRightSidePanelBase = " .. tostring(BaseQuestion.DrawRightSidePanelBase ) .. " \n") ;
    file:write("BaseQuestion.DrawShelfPanelBase = " .. tostring(BaseQuestion.DrawShelfPanelBase ) .. " \n") ;
    file:write("BaseQuestion.DrawTopPanelBase = " .. tostring(BaseQuestion.DrawTopPanelBase ) .. " \n") ;
    file:write("BaseQuestion.FaceFrameOrStretchersBase = " .. tostring(BaseQuestion.FaceFrameOrStretchersBase ) .. " \n") ;
    file:write("BaseQuestion.NailerLocationBase = " .. tostring(BaseQuestion.NailerLocationBase ) .. " \n") ;
    file:write("BaseQuestion.ProvideCabinetNotesOnDrawingBase = " .. tostring(BaseQuestion.ProvideCabinetNotesOnDrawingBase ) .. " \n") ;
    file:write("BaseQuestion.ProvideCabinetNotesOnNewSheetBase = " .. tostring(BaseQuestion.ProvideCabinetNotesOnNewSheetBase ) .. " \n") ;
    file:write("Hardware.HingBottomClearnace = " .. tostring(Hardware.HingBottomClearnace ) .. " \n") ;
    file:write("Hardware.HingCountBase = " .. tostring(Hardware.HingCountBase ) .. " \n") ;
    file:write("Hardware.HingCountWall = " .. tostring(Hardware.HingCountWall ) .. " \n") ;
    file:write("Hardware.HingHoleCenters = " .. tostring(Hardware.HingHoleCenters ) .. " \n") ;
    file:write("Hardware.HingTopClearnace = " .. tostring(Hardware.HingTopClearnace ) .. " \n") ;
    file:write("Hardware.ShelfPinDiameter = " .. tostring(Hardware.ShelfPinDiameter ) .. " \n") ;
    file:write("Milling.DadoClearnace = " .. tostring(Milling.DadoClearnace ) .. " \n") ;
    file:write("Milling.DadoToolDia = " .. tostring(Milling.DadoToolDia ) .. " \n") ;
    file:write("Milling.HalfDadoWidth = " .. tostring(Milling.HalfDadoWidth ) .. " \n") ;
    file:write("Milling.PilotBitDia = " .. tostring(Milling.PilotBitDia ) .. " \n") ;
    file:write("Milling.PocketToolDia = " .. tostring(Milling.PocketToolDia ) .. " \n") ;
    file:write("Milling.ProfileToolDia = " .. tostring(Milling.ProfileToolDia ) .. " \n") ;
    file:write("Milling.RabbitClearing = " .. tostring(Milling.RabbitClearing ) .. " \n") ;
    file:write("Milling.SidePocketDepth = " .. tostring(Milling.SidePocketDepth ) .. " \n") ;
    file:write("Milling.LayerNameSideProfile = " .. tostring(Milling.LayerNameSideProfile ) .. " \n") ;   
    file:write("Milling.LayerNameShelfProfile = " .. tostring(Milling.LayerNameShelfProfile ) .. " \n") ;   
    file:write("Milling.LayerNameBackProfile = " .. tostring(Milling.LayerNameBackProfile ) .. " \n") ;   
    file:write("Milling.LayerNameTopBottomProfile = " .. tostring(Milling.LayerNameTopBottomProfile ) .. " \n") ;   
    file:write("Milling.LayerNameCenterPanleProfile = " .. tostring(Milling.LayerNameCenterPanleProfile ) .. " \n") ;   
    file:write("Milling.LayerNameSideTopBottomPocket = " .. tostring(Milling.LayerNameSideTopBottomPocket ) .. " \n") ;   
    file:write("Milling.LayerNameSideBackPocket = " .. tostring(Milling.LayerNameSideBackPocket ) .. " \n") ;   
    file:write("Milling.LayerNameSideStretcherPocket = " .. tostring(Milling.LayerNameSideStretcherPocket ) .. " \n") ;   
    file:write("Milling.LayerNameSideNailerPocket = " .. tostring(Milling.LayerNameSideNailerPocket ) .. " \n") ;   
    file:write("Milling.LayerNameSideShelfPinDrill = " .. tostring(Milling.LayerNameSideShelfPinDrill ) .. " \n") ;   
    file:write("Milling.LayerNameSideHingCentersDrill = " .. tostring(Milling.LayerNameSideHingCentersDrill ) .. " \n") ;   
    file:write("Milling.LayerNameCenterPanleShelfPinDrill = " .. tostring(Milling.LayerNameCenterPanleShelfPinDrill ) .. " \n") ;   
    file:write("Milling.LayerNameBackPocket = " .. tostring(Milling.LayerNameBackPocket ) .. " \n") ;   
    file:write("Milling.LayerNameTopBottomCenterDado = " .. tostring(Milling.LayerNameTopBottomCenterDado ) .. " \n") ;   
    file:write("Milling.LayerNameDrawNotes = " .. tostring(Milling.LayerNameDrawNotes ) .. " \n") ;   
    file:write("Milling.LayerNameDrawFaceFrame = " .. tostring(Milling.LayerNameDrawFaceFrame ) .. " \n") ;   
--     file:write("ProjectQuestion.AddCabinetSettingsToProject = " .. tostring(ProjectQuestion.AddCabinetSettingsToProject ) .. " \n") ;
    file:write("ProjectQuestion.CabinetName = " .. tostring(ProjectQuestion.CabinetName ) .. " \n") ;
    file:write("ProjectQuestion.ProjectContactEmail = " .. tostring(ProjectQuestion.ProjectContactEmail ) .. " \n") ;
    file:write("ProjectQuestion.ProjectContactName = " .. tostring(ProjectQuestion.ProjectContactName ) .. " \n") ;
    file:write("ProjectQuestion.ProjectContactPhoneNumber = " .. tostring(ProjectQuestion.ProjectContactPhoneNumber ) .. " \n") ;
    file:write("ProjectQuestion.ProjectName = " .. tostring(ProjectQuestion.ProjectName ) .. " \n") ;
    file:write("ProjectQuestion.ProjectPath = " .. tostring(ProjectQuestion.ProjectPath ) .. " \n") ;
    file:write("ProjectQuestion.StartDate = " .. tostring(ProjectQuestion.StartDate ) .. " \n") ;
    file:write("WallDim.BackPocketDepthWall = " .. tostring(WallDim.BackPocketDepthWall ) .. " \n") ;
    file:write("WallDim.BlindDadoSetbackWall = " .. tostring(WallDim.BlindDadoSetbackWall ) .. " \n") ;
    file:write("WallDim.CabDepthWall = " .. tostring(WallDim.CabDepthWall ) .. " \n") ;
    file:write("WallDim.CabHeightWall = " .. tostring(WallDim.CabHeightWall ) .. " \n") ;
    file:write("WallDim.CabLengthWall = " .. tostring(WallDim.CabLengthWall ) .. " \n") ;
    file:write("WallDim.FaceFrameBottomRailWidthWall = " .. tostring(WallDim.FaceFrameBottomRailWidthWall ) .. " \n") ;
    file:write("WallDim.FaceFrameBottomRevealWall = " .. tostring(WallDim.FaceFrameBottomRevealWall ) .. " \n") ;
    file:write("WallDim.FaceFrameCenterStileWidthWall = " .. tostring(WallDim.FaceFrameCenterStileWidthWall ) .. " \n") ;
    file:write("WallDim.FaceFrameRevealWall = " .. tostring(WallDim.FaceFrameRevealWall ) .. " \n") ;
    file:write("WallDim.FaceFrameStileWidthWall = " .. tostring(WallDim.FaceFrameStileWidthWall ) .. " \n") ;
    file:write("WallDim.FaceFrameThicknessWall = " .. tostring(WallDim.FaceFrameThicknessWall ) .. " \n") ;
    file:write("WallDim.FaceFrameTopOverlapWall = " .. tostring(WallDim.FaceFrameTopOverlapWall ) .. " \n") ;
    file:write("WallDim.FaceFrameTopRailWidthWall = " .. tostring(WallDim.FaceFrameTopRailWidthWall ) .. " \n") ;
    file:write("WallDim.NailerThicknessWall = " .. tostring(WallDim.NailerThicknessWall ) .. " \n") ;
    file:write("WallDim.NailerWidthWall = " .. tostring(WallDim.NailerWidthWall ) .. " \n") ;
    file:write("WallDim.RevealWall = " .. tostring(WallDim.RevealWall ) .. " \n") ;
    file:write("WallDim.ShelfCountWall = " .. tostring(WallDim.ShelfCountWall ) .. " \n") ;
    file:write("WallDim.ShelfEndClarenceWall = " .. tostring(WallDim.ShelfEndClarenceWall ) .. " \n") ;
    file:write("WallDim.ShelfFaceFrameRevealWall = " .. tostring(WallDim.ShelfFaceFrameRevealWall ) .. " \n") ;
    file:write("WallDim.ShelfFaceFrameThicknessWall = " .. tostring(WallDim.ShelfFaceFrameThicknessWall ) .. " \n") ;
    file:write("WallDim.ShelfFaceFrameWidthWall = " .. tostring(WallDim.ShelfFaceFrameWidthWall ) .. " \n") ;
    file:write("WallDim.ShelfFrontClearanceWall = " .. tostring(WallDim.ShelfFrontClearanceWall ) .. " \n") ;
    file:write("WallDim.ShelfHoleFirstRowSpacingWall = " .. tostring(WallDim.ShelfHoleFirstRowSpacingWall ) .. " \n") ;
    file:write("WallDim.ShelfHoleLastRowSpacingWall = " .. tostring(WallDim.ShelfHoleLastRowSpacingWall ) .. " \n") ;
    file:write("WallDim.ShelfHoleSpacingWall = " .. tostring(WallDim.ShelfHoleSpacingWall ) .. " \n") ;
    file:write("WallDim.ShelfMaterialThicknessWall = " .. tostring(WallDim.ShelfMaterialThicknessWall ) .. " \n") ;
    file:write("WallDim.ShelfPinHoleBackWall = " .. tostring(WallDim.ShelfPinHoleBackWall ) .. " \n") ;
    file:write("WallDim.ShelfPinHoleFrontWall = " .. tostring(WallDim.ShelfPinHoleFrontWall ) .. " \n") ;
    file:write("WallDim.StretcherThicknessWall = " .. tostring(WallDim.StretcherThicknessWall ) .. " \n") ;
    file:write("WallDim.StretcherWidthWall = " .. tostring(WallDim.StretcherWidthWall ) .. " \n") ;
    file:write("WallDim.ThicknessBackWall = " .. tostring(WallDim.ThicknessBackWall ) .. " \n") ;
    file:write("WallDim.ThicknessWall = " .. tostring(WallDim.ThicknessWall ) .. " \n") ;
    file:write("WallQuestion.AddBackNailerWall = " .. tostring(WallQuestion.AddBackNailerWall ) .. " \n") ;
    file:write("WallQuestion.AddCenterPanelWall = " .. tostring(WallQuestion.AddCenterPanelWall ) .. " \n") ;
    file:write("WallQuestion.AddFaceFrameWall = " .. tostring(WallQuestion.AddFaceFrameWall ) .. " \n") ;
    file:write("WallQuestion.AddShelfHingPilotHolesWall = " .. tostring(WallQuestion.AddShelfHingPilotHolesWall ) .. " \n") ;
    file:write("WallQuestion.AddShelfHolesWall = " .. tostring(WallQuestion.AddShelfHolesWall ) .. " \n") ;
    file:write("WallQuestion.AddShelfingWall = " .. tostring(WallQuestion.AddShelfingWall ) .. " \n") ;
    file:write("WallQuestion.AddStretchersWall = " .. tostring(WallQuestion.AddStretchersWall ) .. " \n") ;
    file:write("WallQuestion.BackDadoOrOverlapWall = " .. tostring(WallQuestion.BackDadoOrOverlapWall ) .. " \n") ;
    file:write("WallQuestion.DadoStyleWall = " .. tostring(WallQuestion.DadoStyleWall ) .. " \n") ;
    file:write("WallQuestion.DadoTypeWall = " .. tostring(WallQuestion.DadoTypeWall ) .. " \n") ;
    file:write("WallQuestion.DrawBackPanelOnNewSheetWall = " .. tostring(WallQuestion.DrawBackPanelOnNewSheetWall ) .. " \n") ;
    file:write("WallQuestion.DrawBackPanelWall = " .. tostring(WallQuestion.DrawBackPanelWall ) .. " \n") ;
    file:write("WallQuestion.DrawBottomPanelWall = " .. tostring(WallQuestion.DrawBottomPanelWall ) .. " \n") ;
    file:write("WallQuestion.DrawCenterPanelWall = " .. tostring(WallQuestion.DrawCenterPanelWall ) .. " \n") ;
    file:write("WallQuestion.DrawFaceFrameOnNewSheetWall = " .. tostring(WallQuestion.DrawFaceFrameOnNewSheetWall ) .. " \n") ;
    file:write("WallQuestion.DrawFaceFrameWall = " .. tostring(WallQuestion.DrawFaceFrameWall ) .. " \n") ;
    file:write("WallQuestion.DrawLeftSidePanelWall = " .. tostring(WallQuestion.DrawLeftSidePanelWall ) .. " \n") ;
    file:write("WallQuestion.DrawRightSidePanelWall = " .. tostring(WallQuestion.DrawRightSidePanelWall ) .. " \n") ;
    file:write("WallQuestion.DrawShelfPanelWall = " .. tostring(WallQuestion.DrawShelfPanelWall ) .. " \n") ;
    file:write("WallQuestion.DrawTopPanelWall = " .. tostring(WallQuestion.DrawTopPanelWall ) .. " \n") ;
    file:write("WallQuestion.FaceFrameOrStretchersWall = " .. tostring(WallQuestion.FaceFrameOrStretchersWall ) .. " \n") ;
    file:write("WallQuestion.NailerLocationWall = " .. tostring(WallQuestion.NailerLocationWall ) .. " \n") ;
    file:write("WallQuestion.ProvideCabinetNotesOnDrawingWall = " .. tostring(WallQuestion.ProvideCabinetNotesOnDrawingWall ) .. " \n") ;
    file:write("WallQuestion.ProvideCabinetNotesOnNewSheetWall = " .. tostring(WallQuestion.ProvideCabinetNotesOnNewSheetWall) .. " \n") ;
        DeBug(9240,1, "StdFileWriter 5")   
    file:write("#============================ \n") ; 
    file:close()-- closes the open file 
       DeBug(9240,1, "StdFileWriter 6")
    return true
end
-- ===================================================
function UpperCabinetFaceFrame(lay)  
    DeBug(9440,1, "UpperCabinetFaceFrame") 
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    if WallQuestion.DrawFaceFrameWall then 
        if WallQuestion.DrawFaceFrameOnNewSheetWall then
            NewSheet(job)
            g_pt7 = Point2D(1.0 ,1.0)  -- Back
            g_pt8 = Point2D(((g_boxHight * 1.0) + (2.0 * g_PartGap)),1.0) -- FaceFrame
            DrawWriter("Note: - " .. WallDim.ThicknessBackWall .. " Plywood", Point2D(2,24), 1.5, "Notes") ;   
        end
        local job = VectricJob()
        if not job.Exists then
             DisplayMessageBox("No job loaded")
             return false ; 
        end
           DeBug(9441, 2, "1")  
        local layer = job.LayerManager:GetLayerWithName(lay) ; 
        local pt2 = Polar2D(g_pt8, 0,   WallDim.CabHeightWall) ; 
        local pt3 = Polar2D(pt2,  90,   WallDim.CabLengthWall) ; 
        local pt4 = Polar2D(pt3, 180,   WallDim.CabHeightWall) ; 
           DeBug(9442, 2, "2")  
        local line = Contour(0.0) ; 
        line:AppendPoint(g_pt8) ; 
        line:LineTo(pt2) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(g_pt8) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        local A1 = Polar2D(g_pt8, 90,  WallDim.FaceFrameStileWidthWall) ; 
        local B1 = Polar2D(pt2,   90,  WallDim.FaceFrameStileWidthWall) ; 
        local C1 = Polar2D(pt3,  270,  WallDim.FaceFrameStileWidthWall) ; 
        local D1 = Polar2D(pt4,  270,  WallDim.FaceFrameStileWidthWall) ; 
           DeBug(9443, 2, "3")  
        line = Contour(0.0) ; 
        line:AppendPoint(A1) ; 
        line:LineTo(B1) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        line = Contour(0.0) ; 
        line:AppendPoint(C1) ; 
        line:LineTo(D1) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        local A2 = Polar2D(A1, 0,       WallDim.FaceFrameBottomRailWidthWall) ; 
        local B2 = Polar2D(B1, 180,     WallDim.FaceFrameTopRailWidthWall) ; 
        local C2 = Polar2D(C1, 180,     WallDim.FaceFrameTopRailWidthWall) ; 
        local D2 = Polar2D(D1, 0,       WallDim.FaceFrameBottomRailWidthWall) ; 
           DeBug(9444, 2, "4")  
        line = Contour(0.0) ; 
        line:AppendPoint(A2) ; 
        line:LineTo(D2) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        line = Contour(0.0) ; 
        line:AppendPoint(B2) ; 
        line:LineTo(C2) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        if WallQuestion.AddCenterPanelWall then ; 
            WallDim.FaceFrameCenterStileLengthWall = (WallDim.CabLengthWall * 0.5) - (WallDim.FaceFrameStileWidthWall + (WallDim.FaceFrameCenterStileWidthWall * 0.5)) ; 
            local A3 = Polar2D(A2, 90,   WallDim.FaceFrameCenterStileLengthWall) ; 
            local B3 = Polar2D(B2, 90,  WallDim.FaceFrameCenterStileLengthWall) ; 
            local C3 = Polar2D(C2, 270,  WallDim.FaceFrameCenterStileLengthWall) ; 
            local D3 = Polar2D(D2, 270,   WallDim.FaceFrameCenterStileLengthWall) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(A3) ; 
            line:LineTo(B3) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(D3) ; 
            line:LineTo(C3) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
        end ; 
        WallDim.FaceFrameStileLengthWall = WallDim.CabHeightWall ; 
        WallDim.FaceFrameRailLengthWall = WallDim.CabLengthWall - (WallDim.FaceFrameStileWidthWall * 2.0) ; 
        WallDim.FaceFrameCenterStileLengthWall = WallDim.CabHeightWall - (WallDim.FaceFrameBottomRailWidthWall + WallDim.FaceFrameTopRailWidthWall) ; 
        
        local pt1Text = Polar2D(g_pt8, 0,  4) ; 
        local pt1Text = Polar2D(pt1Text, 90,  ((WallDim.CabLengthWall * 0.5) + 8)) ; 
        DrawWriter(ProjectQuestion.ProgramName, pt1Text, 0.750, "Notes") ; 
        pt1Text = Polar2D(pt1Text, 270, 1) ; 
        DeBug(9445, 2, "9a")
        DrawWriter("Version: " .. ProjectQuestion.ProgramVersion, pt1Text, 0.50, "Notes") ; 
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter("By: " .. ProjectQuestion.ProgramCodeBy, pt1Text, 0.50, "Notes") ; 
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter(" ======= Stiles and Rail Cut list  ======= ", pt1Text, 0.50, "Notes") ; 
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter("Stiles: 2 pcs " .. tostring(WallDim.FaceFrameBottomRailWidthWall) .. " x " .. tostring(WallDim.FaceFrameStileWidthWall) .. " - " .. 
        WallDim.FaceFrameStileLengthWall .. "'' long", pt1Text, 0.5, "Notes") ; 
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter("Top Rile: 1 pcs " .. tostring(WallDim.FaceFrameBottomRailWidthWall) .. " x " .. tostring(WallDim.FaceFrameTopRailWidthWall) .. " - " .. WallDim.FaceFrameRailLengthWall .. " long", pt1Text, 0.50, "Notes") ; 
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter("Bottom Rail: 1 pcs " .. tostring(WallDim.FaceFrameBottomRailWidthWall) .. " x " .. tostring(WallDim.FaceFrameBottomRailWidthWall) .. " - " .. WallDim.FaceFrameRailLengthWall .. " long", pt1Text, 0.50, "Notes") ;
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter("Pull a ruler twice and cut cut and cut some more :)", pt1Text, 0.50, "Notes") ;
        if WallQuestion.AddCenterPanelWall then  
        pt1Text = Polar2D(pt1Text, 270, 0.75) ; 
        DrawWriter("Center Stile: 1 pcs " .. tostring(WallDim.FaceFrameBottomRailWidthWall) .. " x " .. WallDim.FaceFrameCenterStileWidthWall .. " - " .. WallDim.FaceFrameCenterStileLengthWall .. " long", pt1Text, 0.50, "Notes") ; 
        end ; 
    end  
end -- function end
-- ===================================================
function UpperCabinetShelf(lay, CountX)  
       DeBug(9460,1, "UpperCabinetShelf")  
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    if WallQuestion.DrawCenterPanelWall then ; 
        WallDim.PartLength = ((g_boxLength - (WallDim.ThicknessWall * 2.0) - (WallDim.ShelfEndClarenceWall * 4.0)) * 0.5) ; 
    else ; 
        WallDim.PartLength = (g_boxLength - (WallDim.ThicknessWall * 2) - (WallDim.ShelfEndClarenceWall * 2)) ; 
    end ; 
    WallDim.PartDepth = (g_boxDepth - (WallDim.ThicknessBackWall * 0.5)) ; 
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local pt2 = Polar2D(g_pt5, 0,  WallDim.PartLength) ; 
    local pt3 = Polar2D(pt2, 90,  WallDim.PartDepth) ; 
    local pt4 = Polar2D(pt3, 180, WallDim.PartLength) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(g_pt5) ; 
    line:LineTo(pt2) ; 
    line:LineTo(pt3) ; 
    line:LineTo(pt4) ; 
    line:LineTo(g_pt5) ; 
    layer:AddObject(CreateCadContour(line), true) ; 
    local pt1Text = Polar2D(Polar2D(g_pt5, 0,  3), 90,  (WallDim.PartDepth / 2)) ; 
    DrawWriter("Cabinet Shelf" .. CountX .. " - " .. WallDim.ThicknessWall .. " Plywood", pt1Text, 0.5, "Notes") ; 
  return true   
end -- function end
-- ===================================================
function UpperCabinetBack(job, lay) -- Add Dado for the UpperCab-CenterPanel
    if WallQuestion.DrawBackPanelWall then
        DeBug(9470,1, "UpperCabinetBack")  
        local layer = job.LayerManager:GetLayerWithName(lay) ; 
        local pt2 = Polar2D(g_pt7, 0, g_backHight) ; 
        local ptC = Polar2D(g_pt7, 90, g_backWidth * 0.5) ; 
        local pt3 = Polar2D(pt2, 90,  g_backWidth) ; 
        local pt4 = Polar2D(pt3, 180, g_backHight) ; 
        local ptW = g_pt7 ; 
        local ptX = g_pt7 ; 
        local ptY = g_pt7 ; 
        local ptZ = g_pt7 ; 
        ptW = Polar2D(ptC, 270.0, ((WallDim.ThicknessWall + Milling.RabbitClearing) * 0.5)) ; 
        ptW = Polar2D(ptW, 180.0, Milling.PocketToolDia) ; 
        ptX = Polar2D(ptW,  90.0, (WallDim.ThicknessWall + Milling.RabbitClearing)) ; 
        ptY = Polar2D(ptX,   0.0, g_backHight + (Milling.PocketToolDia * 2.0)) ; 
        ptZ = Polar2D(ptW,   0.0, g_backHight + (Milling.PocketToolDia * 2.0)) ; 
        local line = Contour(0.0) ; 
        line:AppendPoint(g_pt7) ; 
        line:LineTo(pt2) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(g_pt7) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        if WallQuestion.AddCenterPanelWall then ; 
            layer = job.LayerManager:GetLayerWithName("BackPocket") ; 
            line = Contour(0.0) ; 
            line:AppendPoint(ptW) ; 
            line:LineTo(ptX) ; 
            line:LineTo(ptY) ; 
            line:LineTo(ptZ) ; 
            line:LineTo(ptW) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
        end ; 
        local pt1Text = Polar2D(g_pt7, 45,  4) ; 
        DrawWriter("Cabinet Back - " .. WallDim.ThicknessBackWall .. " Plywood", pt1Text, 0.5, "Notes") ; 
    end    
end -- function end
-- ===================================================
function UpperCabinetTandB(top, lay) -- Add Dado for the UpperCab-CenterPanel
    DeBug(9480, 2, "UpperCabinetTandB")  
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    local pt1 = g_pt1 ; local pt2 = g_pt1 ; local ptC = g_pt1 ; local pt3 = g_pt1 ; local pt4 = g_pt1 ;local ptG = g_pt1 ; local ptH = g_pt1 ; local ptE = g_pt1 ; local ptF = g_pt1 ; local ptW = g_pt1 ; 
    local ptX = g_pt1 ; local ptY = g_pt1 ; local ptZ = g_pt1 ; 
    local pt1Text = g_pt1
    -- Where on the sheet to draw the part
    if top == "T" then ; 
        pt1 = g_pt3 ; 
        pt1Text = Polar2D(pt1, 45,  4) ; 
        DrawWriter("Cabinet Top - " .. WallDim.ThicknessWall .. " Plywood", pt1Text, 0.5000, "Notes")
    else
        pt1 = g_pt4 ; 
        pt1Text = Polar2D(pt1, 45,  4) ; 
        DrawWriter("Cabinet BOTTOM - " .. WallDim.ThicknessWall .. " Plywood", pt1Text, 0.5000, "Notes") ; 
    end
    -- Setup all points
    pt2 = Polar2D(pt1,   0, (g_boxLength - (Milling.SidePocketDepth * 2))) ; 
    ptC = Polar2D(pt1,   0, ((g_boxLength - (Milling.SidePocketDepth * 2)) * 0.5)) ; 
    pt3 = Polar2D(pt2,  90, g_boxDepth) ; 
    pt4 = Polar2D(pt3, 180, (g_boxLength - (Milling.SidePocketDepth * 2))) ; 
    ptG = Polar2D(pt3,   0, Milling.PocketToolRadus) ; 
    ptH = Polar2D(ptG, 270, WallDim.ThicknessBackWall) ; 
    ptE = Polar2D(pt4, 180, Milling.PocketToolRadus) ; 
    ptF = Polar2D(ptE, 270, WallDim.ThicknessBackWall) ; 
    ptE = Polar2D(ptE,  90, Milling.RabbitClearing) ; 
    ptG = Polar2D(ptG,  90, Milling.RabbitClearing) ; 
    ptW = Polar2D(ptC, 180, ((WallDim.ThicknessWall + Milling.RabbitClearing) * 0.5)) ; 
    ptW = Polar2D(ptW, 270, Milling.PocketToolDia) ; 
    ptX = Polar2D(ptW,   0, (WallDim.ThicknessWall + Milling.RabbitClearing)) ; 
    ptY = Polar2D(ptX,  90, g_boxDepth + (Milling.PocketToolDia * 2)) ; 
    ptZ = Polar2D(ptW,  90, g_boxDepth + (Milling.PocketToolDia * 2)) ; 
    DeBug(9480, 2, "UpperCabinetTandB - ptZ") 
    
    --draw the proprietor     
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameTopBottomProfile) ; 
    local line = Contour(0.0) ; 
        line:AppendPoint(pt1) ; 
        line:LineTo(pt2) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(pt1) ; 
        layer:AddObject(CreateCadContour(line), true)   
    
    --draw the Back Dado 
    if WallQuestion.BackDadoOrOverlapWall == "Dado" then
        -- DrawRabbit()
        -- WallDim.ThicknessBackWall
        -- Milling.LayerNameSideBackPocket
        
        DrawRabbit(job, pt3, 180, WallDim.ThicknessBackWall, g_boxLength, Milling.LayerNameSideBackPocket, 0.125)
        

    end
    if WallQuestion.DadoTypeWall == "Through" then ;
        layer = job.LayerManager:GetLayerWithName(lay) ; 
        line = Contour(0.0) ; 
        line:AppendPoint(pt1) ; 
        line:LineTo(pt2) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(pt1) ; 
        layer:AddObject(CreateCadContour(line), true)
    elseif WallQuestion.DadoTypeWall == "Blind" then
        layer = job.LayerManager:GetLayerWithName(lay) ; 
        line = Contour(0.0) ; 
        line:AppendPoint(Polar2D(pt1, 90, WallDim.BlindDadoSetbackWall)) ; 
        line:LineTo(Polar2D(Polar2D(pt1, 90, WallDim.BlindDadoSetbackWall), 0, Milling.SidePocketDepth)) ; 
        line:LineTo(Polar2D(pt1, 0, Milling.SidePocketDepth)) ; 
        
        line:LineTo(Polar2D(pt2, 180, Milling.SidePocketDepth)) ; 
        line:LineTo(Polar2D(Polar2D(pt2, 90, WallDim.BlindDadoSetbackWall), 180, Milling.SidePocketDepth)) ; 
        line:LineTo(Polar2D(pt2, 90, WallDim.BlindDadoSetbackWall)) ; 

        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(Polar2D(pt1, 90, WallDim.BlindDadoSetbackWall)) ; 
        layer:AddObject(CreateCadContour(line), true)
    end         
    --draw the Center Dado 
    if WallQuestion.AddCenterPanelWall then ; 
        if WallDim.DadoTypeWall == "Full" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptW = Polar2D(ptW,  90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall)) ;
            ptX = Polar2D(ptX,  90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall)) ;
            line = Contour(0.0) ; line:AppendPoint(ptW) ; line:LineTo(ptX) ; line:LineTo(ptY) ;
            line:LineTo(ptZ) ; line:LineTo(ptW) ; layer:AddObject(CreateCadContour(line), true) ; 
        else ;  -- Half
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ;
            line = Contour(0.0) ; line:AppendPoint(ptW) ; line:LineTo(ptX) ; line:LineTo(ptY) ; line:LineTo(ptZ) ;
            line:LineTo(ptW) ; layer:AddObject(CreateCadContour(line), true) ; 
        end             
    end
    --draw the Center Nailer pockets 
    if WallQuestion.AddBackNailerWall then ; 
--    WallDim.NailerThicknessWall = 0.0
         layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
         pt4 = Polar2D(pt4, 270, WallDim.NailerThicknessWall) ; 
         pt3 = Polar2D(pt3, 270, WallDim.NailerThicknessWall) ; 
         ptE = Polar2D(pt4, 180, Milling.PocketToolRadus) ; 
         ptH = Polar2D(pt3,   0, Milling.PocketToolRadus) ; 
         ptG = Polar2D(ptE, 270, (WallDim.ThicknessBackWall + Milling.RabbitClearing)) ; 
         ptF = Polar2D(ptH, 270, (WallDim.ThicknessBackWall + Milling.RabbitClearing)) ; 
         
         line = Contour(0.0) ; 
         line:AppendPoint(ptE) ; 
         line:LineTo(ptH) ; 
         line:LineTo(ptF) ; 
         line:LineTo(ptG) ; 
         line:LineTo(ptE) ; 
         layer:AddObject(CreateCadContour(line), true) ; 
    else ; 
        layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; line = Contour(0.0) ; line:AppendPoint(ptE) ; line:LineTo(ptF) ; line:LineTo(ptH) ; line:LineTo(ptG) ; line:LineTo(ptE) ; layer:AddObject(CreateCadContour(line), true) ; 
    end
  return true   
end -- function end
-- ===================================================
function DrawRabbit(job, pt, ang, wide, long, lay, Clear)
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    local pt1 = pt ;     local pt2 = pt ;    local pt3 = pt ;    local pt4 = pt
    -- + Milling.RabbitClearing))
    if ang == 0 then
        pt1 = Polar2D(pt,   90, wide) ; 
        pt4 = Polar2D(pt1, 180, Clear) ; 
        pt1 = Polar2D(pt4, 270, wide + Clear) ; 
        pt2 = Polar2D(pt1,   0, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4,   0, long + (Clear * 2)) ; 
    elseif ang == 90 then
        pt1 = Polar2D( pt, 180, wide) ; 
        pt4 = Polar2D(pt1, 270, Clear) ; 
        pt1 = Polar2D(pt4,   0, wide + Clear) ; 
        pt2 = Polar2D(pt1,  90, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4,  90, long + (Clear * 2)) ; 
    elseif ang == 180 then
        pt1 = Polar2D( pt, 270, wide) ; 
        pt4 = Polar2D(pt1,   0, Clear) ; 
        pt1 = Polar2D(pt4,  90, wide + Clear) ; 
        pt2 = Polar2D(pt1, 180, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4, 180, long + (Clear * 2)) ; 
    else -- 270
        pt1 = Polar2D( pt,   0, wide) ; 
        pt4 = Polar2D(pt1,  90, Clear) ; 
        pt1 = Polar2D(pt4, 180, wide + Clear) ; 
        pt2 = Polar2D(pt1, 270, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4, 270, long + (Clear * 2)) ; 
    end
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ;  line:LineTo(pt3) ;  line:LineTo(pt4) ; line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function DrawNailer(pt, l_r)
end
-- ===================================================
function DrawStretcherPocket(pt, l_r)

end
-- ===================================================
function DrawPinHoles(pt, l_r)

end
-- ===================================================
function DrawDado(pt, ort, lay, wide, len, rads, cle)
--[[ -- DrawDado Usage
    pt = 2D point
    ort = ordination ("X" or "Y")
    lay = layer to be draw on
    wide = wide distance
    len = len distance
    rads = bit radius
    cle = milling clearance
    Call = DrawDado(Point2D(2,12),    0, "Jim", 0.75, 20, 0.125, 0.01)
    Call = DrawDado(Point2D(12,2),   90, "Jim", 0.75, 20, 0.125, 0.01)
    Call = DrawDado(Point2D(22,10), 180, "Jim", 0.75, 20, 0.125, 0.01)
    Call = DrawDado(Point2D(10,22), 270, "Jim", 0.75, 20, 0.125, 0.01)
]]
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    local cpt = pt ; local pt1 = pt ; local pt2 = pt ; local pt3 = pt ; local pt4 = pt
        
    if ort == 0 then
         cpt = Polar2D( pt, 180, rads)
         pt1 = Polar2D(cpt, 270, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,  90, (wide + cle))
         pt3 = Polar2D(pt2,   0, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1,   0, (len + (rads * 2.0)))
    elseif ort == 90 then
         cpt = Polar2D( pt, 270, rads)
         pt1 = Polar2D(cpt, 180, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,   0, (wide + cle))
         pt3 = Polar2D(pt2,  90, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1,  90, (len + (rads * 2.0)))
    elseif ort == 180 then
         cpt = Polar2D( pt,   0, rads)
         pt1 = Polar2D(cpt, 270, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,  90, (wide + cle))
         pt3 = Polar2D(pt2, 180, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1, 180, (len + (rads * 2.0)))
    else -- 270
         cpt = Polar2D( pt,  90, rads)
         pt1 = Polar2D(cpt, 180, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,  00, (wide + cle))
         pt3 = Polar2D(pt2, 270, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1, 270, (len + (rads * 2.0)))
    end
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ; 
    line:LineTo(pt3) ; 
    line:LineTo(pt4) ; 
    line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function DrawDogPocket(pt, o, l, x, y, r, c, a)
--[[
    pt = 2D point
    o = ordination ("X" or "Y")
    l = layer to be draw on
    x = distance
    y = distance
    r = bit radius
    c = milling clearance
    a = array of bones {"A", "B", "F", "E"} or { "I", "K"} or {"I", "E", "G"}
    call DrawDado((2,2) "X" ,"Layer-jim" , 0.75, 20.0, 0.125, 0.01)
]]
    if o <= "Y" then
        local cpt = Polar2D( pt, 180, r)
        local pt1 = Polar2D(cpt, 270, ((y * 0.5) + (c * 0.5)))
        local pt2 = Polar2D(pt1,   0, (x + (r * 2.0)))
        local pt3 = Polar2D(pt2,  90, (y + c))
        local pt4 = Polar2D(pt3, 270, (x + (r * 2.0)))
    else
        local cpt = Polar2D( pt, 270, r)
        local pt1 = Polar2D(cpt,   0, ((x * 0.5)+(c * 0.5)))
        local pt2 = Polar2D(pt1,   0, (y + (r * 2.0)))
        local pt3 = Polar2D(pt2,  90, (x + c))
        local pt4 = Polar2D(pt3, 270, (y + (r * 2.0)))
    end
    local layer = job.LayerManager:GetLayerWithName(l) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(cpt) ; 
    -- A ---------------------------------------  
    if CheckArray("A", a) then
        line:LineTo(Polar2D(pt1, 270, r)) --pta
        line:LineTo(Polar2D(pta,   0, r)) --ptb
        line:LineTo(Polar2D(pt1,  90, r)) --ptc
    end
    -- B ---------------------------------------
    if CheckArray("B", a) then    
        line:LineTo(Polar2D(pt2, 180, r)) --ptd
        line:LineTo(Polar2D(ptd, 270, r)) --pte
        line:LineTo(Polar2D(pte,   0, r)) --ptf
    end
    -- C ---------------------------------------   
    if CheckArray("C", a) then
        line:LineTo(Polar2D(pt2,   0, r)) --ptg
        line:LineTo(Polar2D(ptg,  90, r)) --pth
        line:LineTo(Polar2D(pth, 180, r)) --pti
    end
    -- D ---------------------------------------   
    if CheckArray("D", a) then
        line:LineTo(Polar2D(ct3, 270, r)) --ptj
        line:LineTo(Polar2D(ptj,   0, r)) --ptk
        line:LineTo(Polar2D(ptk,  90, r)) --ptl
    end
    -- E ---------------------------------------   
    if CheckArray("E", a) then
        line:LineTo(Polar2D(pt3,  90, r)) --ptm
        line:LineTo(Polar2D(ptm, 180, r)) --ptn
        line:LineTo(Polar2D(ptn,   0, r)) --pto
    end
    -- F ---------------------------------------   
    if CheckArray("F", a) then
        line:LineTo(Polar2D(pt4, 180, r)) --ptp
        line:LineTo(Polar2D(cpt, 270, r)) --ptq
        line:LineTo(Polar2D(pt1,   0, r)) --ptr
    end
    -- G ---------------------------------------   
    if CheckArray("G", a) then
        line:LineTo(Polar2D(pt4, 180, r)) --pts
        line:LineTo(Polar2D(pt3, 270, r)) --ptt
        line:LineTo(Polar2D(pt1,   0, r)) --ptu
    end
    -- H ---------------------------------------   
    if CheckArray("H", a) then
        line:LineTo(Polar2D(pt1,  90, r)) --ptv
        line:LineTo(Polar2D(ptv, 180, r)) --ptw
        line:LineTo(Polar2D(ptw, 270, r)) --ptx
    end
    -- I ---------------------------------------   
    if CheckArray("I", a) then
        line:LineTo(Polar2D(pt1, 270, r)) --ptaa
        line:LineTo(Polar2D(pt2, 270, r)) --ptbb
    end
    -- J ---------------------------------------   
    if CheckArray("J", a) then
        line:LineTo(Polar2D(pt2,   0, r)) --ptcc
        line:LineTo(Polar2D(pt3,   0, r)) --ptdd
    end
    -- K ---------------------------------------   
    if CheckArray("K", a) then
        line:LineTo(Polar2D(pt3,  90, r)) --ptee
        line:LineTo(Polar2D(pt4,  90, r)) --ptff
    end
    -- L --------------------------------------- 
    if CheckArray("L", a) then    
        line:LineTo(Polar2D(pt1, 180, r)) --ptgg
        line:LineTo(Polar2D(ptv, 180, r)) --pthh
    end
    line:LineTo(cpt) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function UpperCabinetSidex(side, lay)
    DeBug(9490,1, "UpperCabinetSide")  
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    local pt2 = g_pt1 ; local pt3 = g_pt1 ; local pt4 = g_pt1 ; local ptA = g_pt1 ; local ptB = g_pt1 ; local ptL = g_pt1 ; local ptK = g_pt1 ; local ptG = g_pt1 ; local ptH = g_pt1 ; local ptI = g_pt1 ; local ptJ = g_pt1 ; local ptD = g_pt1 ; local ptC = g_pt1 ; local ptE = g_pt1 ; local ptF = g_pt1 ; local ptM = g_pt1 ; local ptN = g_pt1
    local pt1Text = Polar2D(g_pt1, 45,  6)
    local ptx = g_pt1 ; local anx = 0
    if side == "L" then-- L side ; 
        pt1Text = Polar2D(g_pt1, 45,  6) ; 
        pt2 = Polar2D(g_pt1,   0, g_boxHight) ; pt3 = Polar2D(pt2,    90, g_boxDepth) ; 
        pt4 = Polar2D(pt3,   180, g_boxHight) ; ptA = Polar2D(g_pt1, 270, Milling.PocketToolRadus) ; ptB = Polar2D(ptA,     0, WallDim.ThicknessWall) ; 
        ptL = Polar2D(pt2,   270, Milling.PocketToolRadus) ; ptK = Polar2D(ptL,   180, WallDim.ThicknessWall) ; 
        ptG = Polar2D(pt3,     0, Milling.PocketToolRadus) ; ptH = Polar2D(ptG,   270, WallDim.ThicknessBackWall) ; 
        ptI = Polar2D(pt3,    90, Milling.PocketToolRadus) ; ptJ = Polar2D(ptI,   180, WallDim.ThicknessWall) ; 
        ptD = Polar2D(pt4,    90, Milling.PocketToolRadus) ; ptC = Polar2D(ptD,     0, WallDim.ThicknessWall) ; 
        ptE = Polar2D(pt4,   180, Milling.PocketToolRadus) ; ptF = Polar2D(ptE,   270, WallDim.ThicknessBackWall) ; 
        ptA = Polar2D(ptA,   180, Milling.RabbitClearing) ; ptL = Polar2D(ptL,     0, Milling.RabbitClearing) ; 
        ptG = Polar2D(ptG,    90, Milling.RabbitClearing) ; ptI = Polar2D(ptI,     0, Milling.RabbitClearing) ; 
        ptE = Polar2D(ptE,    90, Milling.RabbitClearing) ; ptD = Polar2D(ptD,   180, Milling.RabbitClearing) ; 
        DrawWriter("Cabinet Left Side - " .. WallDim.ThicknessWall .. " Plywood", pt1Text, 0.5000, "Notes") ; 
        line:AppendPoint(g_pt1) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(g_pt1) ; layer:AddObject(CreateCadContour(line), true)
-- top Dado - Through
        if WallQuestion.DadoTypeWall == "Through" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            line = Contour(0.0) ; 
            line:AppendPoint(ptA) ; 
            line:LineTo(ptB) ; 
            line:LineTo(ptC) ; 
            line:LineTo(ptD) ; 
            line:LineTo(ptA) ; 
            layer:AddObject(CreateCadContour(line), true)
        end
        if WallQuestion.DadoTypeWall == "Blind" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptA = Polar2D(ptA, 90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall)) ; 
            ptB = Polar2D(ptB, 90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall - Milling.PocketToolRadus)); 
            ptM = Polar2D(ptB, 180, (Milling.PocketToolDia + Milling.RabbitClearing)) ; 
            ptN = Polar2D(ptM, 90, Milling.PocketToolRadus) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(ptA) ; 
            line:LineTo(ptN) ; 
            line:LineTo(ptM) ;             
            line:LineTo(ptB) ; 
            line:LineTo(ptC) ; 
            line:LineTo(ptD) ; 
            line:LineTo(ptA) ; 
            layer:AddObject(CreateCadContour(line), true)
        end
        if WallQuestion.DadoTypeWall == "Full" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptB = Polar2D(ptB,  90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)); 
            ptA = Polar2D(ptA,  90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)); 
            ptD = Polar2D(ptD, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)); 
            ptC = Polar2D(ptC, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)); 
            line = Contour(0.0) ; 
            line:AppendPoint(ptA) ; 
            line:LineTo(ptB) ; 
            line:LineTo(ptC) ; 
            line:LineTo(ptD) ; 
            line:LineTo(ptA); 
            layer:AddObject(CreateCadContour(line), true); 
        end
-- back Dado
        if WallQuestion.AddBackNailerWall then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptE = Polar2D(pt4, 90, Milling.PocketToolRadus) ; 
            ptF = Polar2D(pt3, 90, Milling.PocketToolRadus) ; 
            local x1 = Polar2D(ptE,180, Milling.PocketToolRadus) ; 
            local x2 = Polar2D(x1, 270, (Milling.PocketToolRadus + WallDim.NailerThicknessWall + WallDim.ThicknessBackWall + Milling.RabbitClearing)) ; 
            local x4 = Polar2D(ptF,  0, Milling.PocketToolRadus) ; 
            local x3 = Polar2D(x4, 270, (Milling.PocketToolRadus + WallDim.NailerThicknessWall + WallDim.ThicknessBackWall + Milling.RabbitClearing)) ; 
            local x5 = Polar2D(x4, 180, (Milling.PocketToolRadus + WallDim.NailerWidthWall + WallDim.ThicknessWall)) ; 
            local x6 = Polar2D(x5, 270, (Milling.PocketToolRadus + WallDim.NailerThicknessWall)) ; 
            local x8 = Polar2D(x1,   0, (Milling.PocketToolRadus + WallDim.NailerWidthWall + WallDim.ThicknessWall)) ; 
            local x7 = Polar2D(x8, 270, (Milling.PocketToolRadus + WallDim.NailerThicknessWall)) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(x1) ; 
            line:LineTo(x2) ; 
            line:LineTo(x3) ; 
            line:LineTo(x4) ; 
            line:LineTo(x5) ; 
            line:LineTo(x6) ; 
            line:LineTo(x7) ; 
            line:LineTo(x8) ; 
            line:LineTo(x1) ; 
            layer:AddObject(CreateCadContour(line), true)
        else-- No Back Nailer
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado")
            line = Contour(0.0) ; 
            line:AppendPoint(ptE) ; 
            line:LineTo(ptF) ; 
            line:LineTo(ptH) ; 
            line:LineTo(ptG) ; 
            line:LineTo(ptE) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
        end ; 
-- bottom Dado
        if WallQuestion.DadoTypeWall == "Through" then   
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado")
            line = Contour(0.0) ; 
            line:AppendPoint(ptI) ; 
            line:LineTo(ptJ) ; 
            line:LineTo(ptK) ; 
            line:LineTo(ptL) ; 
            line:LineTo(ptI) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
            ptx = g_pt1 ; anx = 0 ; 
            ptx = Polar2D(Polar2D(g_pt1, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 90, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall)) ; anx = 90 ; 
        end ; 
        if WallQuestion.DadoTypeWall == "Half" then   
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptL = Polar2D(ptL,  90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall)) ; 
            ptK = Polar2D(ptK,  90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall - Milling.PocketToolRadus)) ; 
            ptM = Polar2D(ptK,  0,  (Milling.PocketToolDia + Milling.RabbitClearing)) ; 
            ptN = Polar2D(ptM,  90, Milling.PocketToolRadus) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(ptI) ; 
            line:LineTo(ptJ) ; 
            line:LineTo(ptK) ; 
            line:LineTo(ptM) ; 
            line:LineTo(ptN) ; 
            line:LineTo(ptL) ; 
            line:LineTo(ptI) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
            ptx = g_pt1 ; anx = 0 ; 
            ptx = Polar2D(Polar2D(g_pt1, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 90, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall)) ; anx = 90 ; 
        end
        if WallQuestion.DadoTypeWall == "Full" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptK = Polar2D(ptK,  90, (Milling.PocketToolRadus + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            ptL = Polar2D(ptL,  90, (Milling.PocketToolRadus + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            ptJ = Polar2D(ptJ,  270, (Milling.PocketToolRadus + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            ptI = Polar2D(ptI,  270, (Milling.PocketToolRadus + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            line = Contour(0.0) ; line:AppendPoint(ptI) ; line:LineTo(ptJ) ; line:LineTo(ptK) ; line:LineTo(ptL) ; line:LineTo(ptI) ; layer:AddObject(CreateCadContour(line), true) ; 
            ptx = g_pt1 ; anx = 0 ; 
            ptx = Polar2D(Polar2D(g_pt1, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 90, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall)) ; anx = 90 ; 
        end ; 
    else-- R side 
 
            pt1Text = Polar2D(g_pt2, 45,  6) ; 
            pt2 = Polar2D(g_pt2,   0, g_boxHight) ; 
            pt3 = Polar2D(pt2,    90, g_boxDepth) ; 
            pt4 = Polar2D(pt3,   180, g_boxHight) ; 
            ptA = Polar2D(g_pt2, 270, Milling.PocketToolRadus) ; ptB = Polar2D(ptA,     0, WallDim.ThicknessWall) ; 
            ptL = Polar2D(pt2,   270, Milling.PocketToolRadus) ; ptK = Polar2D(ptL,   180, WallDim.ThicknessWall) ; 
            ptI = Polar2D(pt3,    90, Milling.PocketToolRadus) ; ptJ = Polar2D(ptI,   180, WallDim.ThicknessWall) ; 
            ptD = Polar2D(pt4,    90, Milling.PocketToolRadus) ; ptC = Polar2D(ptD,     0, WallDim.ThicknessWall) ; 
            ptG = Polar2D(pt2,     0, Milling.PocketToolRadus) ; ptH = Polar2D(ptG,    90, WallDim.ThicknessBackWall) ; 
            ptE = Polar2D(g_pt2, 180, Milling.PocketToolRadus) ; ptF = Polar2D(ptE,    90, WallDim.ThicknessBackWall) ; 

-- Right Side
            ptL = Polar2D(ptL,     0, Milling.RabbitClearing) ; ptI = Polar2D(ptI,     0, Milling.RabbitClearing)
-- Back Side
            ptG = Polar2D(ptG,   270, Milling.RabbitClearing) ; ptE = Polar2D(ptE,   270, Milling.RabbitClearing)
-- Left Side
            ptD = Polar2D(ptD,   180, Milling.RabbitClearing) ; ptA = Polar2D(ptA,   180, Milling.RabbitClearing) ; 
            DrawWriter("Cabinet Right Side - " .. WallDim.ThicknessWall .. " Plywood", pt1Text, 0.5000, "Notes") ; 
            line:AppendPoint(g_pt2) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(g_pt2) ; layer:AddObject(CreateCadContour(line), true) ; 
-- top Dado
        if WallQuestion.DadoTypeWall == "Through" then 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado")
            line = Contour(0.0) ; 
            line:AppendPoint(ptA) ; 
            line:LineTo(ptB) ; 
            line:LineTo(ptC) ; 
            line:LineTo(ptD) ; 
            line:LineTo(ptA) ; 
            layer:AddObject(CreateCadContour(line), true)
        end
        if WallQuestion.DadoTypeWall == "Half" then 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado")
            ptD = Polar2D(ptD, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall))
            ptC = Polar2D(ptC, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall - Milling.PocketToolRadus))
            
            ptM = Polar2D(ptC,  180,  (Milling.PocketToolDia + Milling.RabbitClearing)) 
            ptN = Polar2D(ptM,  270, Milling.PocketToolRadus) 
            
            line = Contour(0.0) ; 
            line:AppendPoint(ptA) ; 
            line:LineTo(ptB) ; 
            line:LineTo(ptC) ; 
            line:LineTo(ptM) ; 
            line:LineTo(ptN) ; 
            line:LineTo(ptD) ; 
            line:LineTo(ptA) ; layer:AddObject(CreateCadContour(line), true)
        end    
        if WallQuestion.DadoTypeWall == "Full" then 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado")
            ptC = Polar2D(ptC, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus))
            ptD = Polar2D(ptD, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus))
            ptA = Polar2D(ptA, 90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus))
            ptB = Polar2D(ptB, 90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus))
            line = Contour(0.0) ; 
            line:AppendPoint(ptA) ; 
            line:LineTo(ptB) ; 
            line:LineTo(ptC) ; 
            line:LineTo(ptD) ; 
            line:LineTo(ptA) ; layer:AddObject(CreateCadContour(line), true)
        end  
-- back Dado
        if WallQuestion.AddBackNailerWall then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptE = Polar2D(g_pt2, 270, Milling.PocketToolRadus) ; 
            ptF = Polar2D(pt2, 270, Milling.PocketToolRadus) ; 
            local y1 = Polar2D(ptE, 180, Milling.PocketToolRadus) ; 
            local y2 = Polar2D(y1, 90, (Milling.PocketToolRadus + WallDim.NailerThicknessWall + WallDim.ThicknessBackWall + Milling.RabbitClearing)) ; 
            local y4 = Polar2D(ptF,  0, Milling.PocketToolRadus) ; 
            local y3 = Polar2D(y4,  90, (Milling.PocketToolRadus + WallDim.NailerThicknessWall + WallDim.ThicknessBackWall + Milling.RabbitClearing)) ; 
            local y5 = Polar2D(y4, 180, (Milling.PocketToolRadus + WallDim.NailerWidthWall + WallDim.ThicknessWall)) ; 
            local y6 = Polar2D(y5, 90, (Milling.PocketToolRadus + WallDim.NailerThicknessWall)) ; 
            local y8 = Polar2D(y1,   0, (Milling.PocketToolRadus + WallDim.NailerWidthWall + WallDim.ThicknessWall)) ; 
            local y7 = Polar2D(y8, 90, (Milling.PocketToolRadus + WallDim.NailerThicknessWall)) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(y1) ; 
            line:LineTo(y2) ; 
            line:LineTo(y3) ; 
            line:LineTo(y4) ; 
            line:LineTo(y5) ; 
            line:LineTo(y6) ; 
            line:LineTo(y7) ; 
            line:LineTo(y8) ; 
            line:LineTo(y1) ; 
            layer:AddObject(CreateCadContour(line), true)

        else-- No Back Nailer

            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado")
            line = Contour(0.0) ; line:AppendPoint(ptE) ; line:LineTo(ptF) ; line:LineTo(ptH) ; line:LineTo(ptG) ; line:LineTo(ptE) ; layer:AddObject(CreateCadContour(line), true)
        
        end
-- bottom Dado
        if WallQuestion.DadoTypeWall == "Through" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            line = Contour(0.0) ; line:AppendPoint(ptI) ; line:LineTo(ptJ) ; line:LineTo(ptK) ; line:LineTo(ptL) ; line:LineTo(ptI) ; layer:AddObject(CreateCadContour(line), true) ; 
            ptx = g_pt2 ; anx = 0 ; 
            ptx = Polar2D(Polar2D(pt4, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 270, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall)) ; anx = 270 ; 
        end
        if WallQuestion.DadoTypeWall == "Half" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptI = Polar2D(ptI, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall)) ; 
            ptJ = Polar2D(ptJ, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall - Milling.PocketToolRadus)) ; 
            ptM = Polar2D(ptJ,  0,  (Milling.PocketToolDia + Milling.RabbitClearing)) ; 
            ptN = Polar2D(ptM,  270, Milling.PocketToolRadus) ; 
            line = Contour(0.0) ; line:AppendPoint(ptI) ; 
            line:LineTo(ptN) ; 
            line:LineTo(ptM) ; 
            line:LineTo(ptJ) ; 
            line:LineTo(ptK) ; 
            line:LineTo(ptL) ; 
            line:LineTo(ptI) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
            ptx = g_pt2 ; anx = 0 ; 
            ptx = Polar2D(Polar2D(pt4, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 270, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall)) ; anx = 270 ; 
        end        
        if WallQuestion.DadoTypeWall == "Full" then ; 
            layer = job.LayerManager:GetLayerWithName(tostring(Milling.SidePocketDepth) .. "-Dado") ; 
            ptI = Polar2D(ptI, 270, (Milling.PocketToolDia +WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            ptJ = Polar2D(ptJ, 270, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            ptK = Polar2D(ptK,   90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            ptL = Polar2D(ptL,   90, (Milling.PocketToolDia + WallDim.BlindDadoSetbackWall + Milling.PocketToolRadus)) ; 
            line = Contour(0.0) ; line:AppendPoint(ptI) ; line:LineTo(ptJ) ; line:LineTo(ptK) ; line:LineTo(ptL) ; line:LineTo(ptI) ; layer:AddObject(CreateCadContour(line), true) ; 
            ptx = g_pt2 ; anx = 0 ; 
            ptx = Polar2D(Polar2D(pt4, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 270, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall)) ; anx = 270 ; 
        end          
 
    end-- End of L/R 

   if WallQuestion.AddShelf then ; 
        local spc = ((g_boxDepth - WallDim.ThicknessWall) * WallDim.ShelfPinHoleFrontWall) ; 
        local rows = ((g_boxHight - (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ShelfHoleLastRowSpacingWall + (WallDim.ThicknessWall * 2.0))) / WallDim.ShelfHoleSpacingWall) ; 
        while (rows > 0) do ; 
            Holer (job, ptx, anx, spc, Hardware.PinRadus, "PinHoles") ; 
             ptx = Polar2D(ptx, 0, WallDim.ShelfHoleSpacingWall) ; 
            rows = (rows - 1.0) ; 
        end ; 
    end
  return true   
end -- function end
-- ===================================================
function UpperCabinetSide(side, lay)
    DeBug(9490,1, "UpperCabinetSide")  
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
-- setup object values
    local pt1 = g_pt1   --lower left panel corner 
    local pt2 = g_pt1   --Top dado corner 
    local pt3 = g_pt1   --Bottom dado corner  
    local pt4 = g_pt1   --Back dado corner 
    local pt5 = g_pt1   --Stretcher corner
    local pt6 = g_pt1   --lower left panel corner 

-- draw side

    BuildBox(job, g_pt1, Milling.LayerNameSideProfile, g_boxHight, g_boxDepth)

    local   pt1Text = Polar2D(g_pt1,  45, 4) ; 
            pt2 = Polar2D(g_pt1,   0, g_boxHight) ; 
            pt3 = Polar2D(pt2,    90, g_boxDepth) ; 
            pt4 = Polar2D(pt3,   180, g_boxHight) ; 
    local   ptA = Polar2D(g_pt1, 270, Milling.PocketToolRadus) ; 
    local   ptB = Polar2D(ptA,     0, WallDim.ThicknessWall) ; 

-- draw top Dado
    if WallQuestion.BackDadoOrOverlapWall == "Dado" then ; 
    
    elseif WallQuestion.BackDadoOrOverlapWall == "Overlap" then
    
    end
    
    if WallQuestion.DadoStyleWall == "Through" then ; 
            
    elseif WallQuestion.DadoStyleWall == "Blind" then ;  

    end
    if WallQuestion.DadoTypeWall == "Full" then ; 
    
    elseif WallQuestion.DadoTypeWall == "Half" then ; 
    
    end

    if WallQuestion.BackDadoOrOverlapWall == "Dado" then ; 
    
    elseif WallQuestion.BackDadoOrOverlapWall == "Overlap" then
    
    end
    
    -- FaceFrameOrStretchersWall=FaceFrame
    if WallQuestion.FaceFrameOrStretchersWall == "FaceFrame" then ; 
    
    elseif WallQuestion.FaceFrameOrStretchersWall == "Stretchers" then
    
    elseif WallQuestion.FaceFrameOrStretchersWall == "None" then
       
   --     DrawRabbit(job, Point2D(8,8), 180, 0.75, 20, "JIM", 0.125)
    end
-- back Dado
    if WallQuestion.AddBackNailerWall then ; 
    else-- No Back Nailer
    end ; 

   if WallQuestion.AddShelf then ; 
        local spc = ((g_boxDepth - WallDim.ThicknessWall) * WallDim.ShelfPinHoleFrontWall) ; 
        local rows = ((g_boxHight - (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ShelfHoleLastRowSpacingWall + (WallDim.ThicknessWall * 2.0))) / WallDim.ShelfHoleSpacingWall) ; 
        while (rows > 0) do ; 
            Holer (job, ptx, anx, spc, Hardware.PinRadus, "PinHoles") ; 
             ptx = Polar2D(ptx, 0, WallDim.ShelfHoleSpacingWall) ; 
            rows = (rows - 1.0) ; 
        end ; 
    end

  return true  
 
end  -- function end
-- ===================================================
function UpperCenterPanel(lay)
    DeBug(9510, 1, "UpperCenterPanel") 
    if WallQuestion.DrawCenterPanelWall then
        DeBug(9510, 1, "UpperCenterPanel")  
        local job = VectricJob()
        if not job.Exists then
             DisplayMessageBox("No job loaded")
             return false ; 
        end
        DeBug(9510, 2, "UpperCenterPanel 1") 
        local layer = job.LayerManager:GetLayerWithName(lay)
        local pt1 = Polar2D(g_pt6, 0, (WallDim.ThicknessWall * 0.5))
        local pt2 = Polar2D(pt1, 0, g_boxHight - WallDim.ThicknessWall)
        local pt3 = Polar2D(pt2, 90, (g_boxDepth - (WallDim.ThicknessBackWall * 0.5) - WallDim.NailerThicknessWall))
        local pt4 = Polar2D(pt3, 180, g_boxHight - WallDim.ThicknessWall)
        local pt1Text = Polar2D(g_pt6, 45,  4)
        DrawWriter("Cabinet Center Panel - " .. WallDim.ThicknessWall .. " Plywood", pt1Text, 0.5000, "Notes")
        DeBug(9510, 2, "UpperCenterPanel 2") 
        local line = Contour(0.0) ; 
        if WallQuestion.DadoTypeWall == "Through" then
            DeBug(9510, 2, "UpperCenterPanel 3") 
            layer = job.LayerManager:GetLayerWithName(lay) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(pt1) ; 
            line:LineTo(pt2) ; 
            line:LineTo(pt3) ; 
            line:LineTo(pt4) ; 
            line:LineTo(pt1) ; 
            layer:AddObject(CreateCadContour(line), true) ; 
        end
        if WallQuestion.DadoTypeWall == "Half" then
            DeBug(9510, 2, "UpperCenterPanel 4") 
            layer = job.LayerManager:GetLayerWithName(lay) ; 
            line = Contour(0.0) ; 
            line:AppendPoint(Polar2D(pt1, 90, WallDim.BlindDadoSetbackWall)) ; 
            line:LineTo(Polar2D(Polar2D(pt1, 90, WallDim.BlindDadoSetbackWall), 0, Milling.SidePocketDepth)) ; 
            line:LineTo(Polar2D(pt1, 0, Milling.SidePocketDepth)) ; 
            line:LineTo(Polar2D(pt2, 180, Milling.SidePocketDepth)) ; 
            line:LineTo(Polar2D(Polar2D(pt2, 90, WallDim.BlindDadoSetbackWall), 180, Milling.SidePocketDepth)) ; 
            line:LineTo(Polar2D(pt2, 90, WallDim.BlindDadoSetbackWall)) ; 
            line:LineTo(pt3) ; 
            line:LineTo(pt4) ; 
            line:LineTo(Polar2D(pt1, 90, WallDim.BlindDadoSetbackWall)) ; 
            layer:AddObject(CreateCadContour(line), true)
        end 
        local ptx = g_pt6 ; local anx = 90 ; ptx = Polar2D(Polar2D(g_pt6, 0, (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ThicknessWall)), 90, ((g_boxDepth - WallDim.ThicknessBackWall) * WallDim.ShelfPinHoleBackWall))
        if WallQuestion.AddShelf then
            local spc = ((g_boxDepth - WallDim.ThicknessWall) * WallDim.ShelfPinHoleFrontWall)
            local rows = ((g_boxHight - (WallDim.ShelfHoleFirstRowSpacingWall + WallDim.ShelfHoleLastRowSpacingWall + (WallDim.ThicknessWall * 2.0))) / WallDim.ShelfHoleSpacingWall)
            DeBug(9510, 2, "UpperCenterPanel 5") 
            while (rows > 0) do
                Holer (job, ptx, anx, spc, Hardware.PinRadus, "PinHoles")
                DeBug(9510, 2, "UpperCenterPanel 6 row: " .. tostring(rows))
                ptx = Polar2D(ptx, 0, WallDim.ShelfHoleSpacingWall)
                rows = (rows - 1.0)
            end
        end     
    end  
end -- function end
-- ===================================================
function LoadDialog1(job) -- Full Dialog
       DeBug(9520,1, "LoadDialog") 
ShowMe()
-- local registry = Registry("CabinetMaker")

    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  <html> <head> <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type="text/css"> html { overflow: auto; } body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton {    width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h2 { font-size: 12px; font-family: Arial, Helvetica, sans-serif; width: 98%; } .h3 { font-size: 12px; font-weight: bold; } .h4 { font-size: 12px; font-family: Arial, Helvetica, sans-serif; width: 99%; </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width="675" border="2" cellpadding="0"> <tr> <th align="center" valign="middle" id="ProgramTitle">0.0</th> <th align="center" valign="middle" id="Message">&nbsp;</th> <th align="center" valign="middle" id="ProgramTitle">&nbsp;</th> <th align="right" valign="middle" id="codeBy"><strong>0.0</strong></th> </tr> <tr> <th align="center" valign="middle" id="ProgramVersion">0.0</th> <th align="center" valign="middle" id="Year">0.0</th> <th align="center" valign="middle" id="ProgramName">0.0</th> <th align="right" valign="middle" id="Contact">0.0</th> </tr> <tr> <th align="right" valign="middle">Project Name</th> <th colspan="3" align="left" valign="middle"> <input name="ProjectName" type="text" class="h4" id="ProjectName" value="Required" size="50" maxlength="50"readonly></th> </tr> <tr> <th align="right" valign="middle">Project Path</th> <th colspan="3" align="left" valign="middle"> <input name="ProjectPath" type="text" class="h4" id="ProjectPath" value="Required" size="50" maxlength="50"readonly></th> </tr> <tr> <th align="right" valign="middle" bgcolor="#FFFF00">Cabinet Name</th> <th colspan="3" align="left" valign="middle"> <input name="CabinetName" type="text" class="h4" id="CabinetName" value="Required" size="50" maxlength="50"></th> </tr> <tr> <th width="159" align="center" valign="middle"><strong>Item</strong></th> <th width="97" align="center" valign="middle">Value</th> <th width="70" align="center" valign="middle"><strong>Default Value</strong></th> <th width="300" align="center" valign="middle"><strong>Information</strong></th> </tr> <tr> <td align="right" valign="middle" nowrap>Wall Cabinet Width</td> <td align="center" valign="middle"><input name="CabLengthWall" type="text" class="h4" id="CabLengthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">36</td> <td align="left" valign="middle">Wall Cabinet Width (Left to Right)</td> </tr> <tr> <td align="right" valign="middle" nowrap>Wall Cabinet Height</td> <td align="center" valign="middle"><input name="CabHeightWall" type="text" class="h4" id="CabHeightWall" size="6" maxlength="10"></td> <td align="center" valign="middle">28</td> <td align="left" valign="middle">Wall Cabinet Height (Top to Bottom)</td> </tr> <tr> <td align="right" valign="middle" nowrap>Wall Cabinet Depth</td> <td align="center" valign="middle"><input name="CabDepthWall" type="text" class="h4" id="CabDepthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">12</td> <td align="left" valign="middle">Wall Cabinet Depth (Front to Back)</td> </tr> <tr> <td align="right" valign="middle" nowrap>Material Thickness</td> <td align="center" valign="middle"><input name="ThicknessWall" type="text" class="h4" id="ThicknessWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Material Thickness for Cabinet Sides</td> </tr> <tr> <td align="right" valign="middle" nowrap>Back Material Thickness</td> <td align="center" valign="middle"><input name="ThicknessBackWall" type="text" class="h4" id="ThicknessBackWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.5</td> <td align="left" valign="middle">Material Thickness Used On The Back</td> </tr> <tr> <td align="right" valign="middle" nowrap>Add Center Panel</td> <td align="center" valign="middle"><input type="checkbox" name="AddCenterPanelWall" id="AddCenterPanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Frame Panel In The Opening</td> </tr> <tr> <td align="right" valign="middle" nowrap>Add Shelf's</td> <td align="center" valign="middle"><input type="checkbox" name="AddShelfingWall" id="AddShelfingWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Frame Panel In The Opening</td> </tr> <tr> <td align="right" valign="middle" nowrap>Add Back Nailer</td> <td align="center" valign="middle"><input type="checkbox" name="AddBackNailerWall" id="AddBackNailerWall"> <label for="xxxx5"></label></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Face Frame In The Opening</td> </tr> <tr> <td align="right" valign="middle" nowrap>FaceFrame or Stretchers</td> <td align="center" valign="middle"><select name="FaceFrameOrStretchersWall" class="FormButton" id="FaceFrameOrStretchersWall"> <option value="1">FaceFrame</option> <option value="2">Stretchers</option> <option value="3">None</option> </select></td> <td align="center" valign="middle">FaceFrame</td> <td align="left" valign="middle">Cabinet Style: FaceFrame, Stretchers or None</td> </tr> <tr> <td align="right" valign="middle">Profile Tool Diameter</td> <td align="center" valign="middle"><input name="ProfileToolDia" type="text" class="h4" id="ProfileToolDia" size="6" maxlength="10"></td> <td align="center" valign="middle">0.25</td> <td align="left" valign="middle">Milling Profile Tool Diameter</td> </tr> <tr> <td align="right" valign="middle">Dado Tool Diameter</td> <td align="center" valign="middle"><input name="DadoToolDia" type="text" class="h4" id="DadoToolDia" size="6" maxlength="10"></td> <td align="center" valign="middle">0.25</td> <td align="left" valign="middle">Milling Dado Tool Diameter</td> </tr> <tr> <td align="right" valign="middle">Dado Clearnace</td> <td align="center" valign="middle"><input name="DadoClearnace" type="text" class="h4" id="DadoClearnace" size="6" maxlength="10"></td> <td align="center" valign="middle">0.01</td> <td align="left" valign="middle">Milling Clearance Amount For Dado's </td> </tr> <tr> <td align="right" valign="middle">Pilot Bit Dia</td> <td align="center" valign="middle"><input name="PilotBitDia" type="text" class="h4" id="PilotBitDia" size="6" maxlength="10"></td> <td align="center" valign="middle">0.01</td> <td align="left" valign="middle">Pilot Bit Dia</td> </tr> <tr> <td align="right" valign="middle" nowrap>Dado Back or Overlap</td> <td align="center" valign="middle"><select name="BackDadoOrOverlapWall" class="FormButton" id="BackDadoOrOverlapWall"> <option value="1">Dado</option> <option value="2">Overlap</option> </select></td> <td align="center" valign="middle">Dado</td> <td align="left" valign="middle">Dado Back or Overlap</td> </tr> <tr> <td align="right" valign="middle" nowrap>Dado Style</td> <td align="center" valign="middle"><select name="DadoTypeWall" class="FormButton" id="DadoTypeWall"> <option value="1">Full</option> <option value="2">Half</option> </select></td> <td align="center" valign="middle">Full</td> <td align="left" valign="middle">Types Of Dado To Cut</td> </tr> <tr> <td align="right" valign="middle" nowrap>Dado Type</td> <td align="center" valign="middle"><select name="DadoStyleWall" class="FormButton" id="DadoStyleWall"> <option value="1">Through</option> <option value="2">Blind</option> </select></td> <td align="center" valign="middle">Through</td> <td align="left" valign="middle">Types Of Dado To Cut</td> </tr> <tr> <td align="right" valign="middle" nowrap>Blind Dado Setback</td> <td align="center" valign="middle"><input name="BlindDadoSetbackWall" type="text" class="h4" id="BlindDadoSetbackWall" size="6" maxlength="10"></td> <td align="center" valign="middle">1.375</td> <td align="left" valign="middle">Amount To Cut Dado Depth</td> </tr> <tr> <td align="right" valign="middle" nowrap>Side Dado Depth</td> <td align="center" valign="middle"><input name="SidePocketDepth" type="text" class="h4" id="SidePocketDepth" size="6" maxlength="10"></td> <td align="center" valign="middle">0.375</td> <td align="left" valign="middle">Amount To Cut Side Dado Depth</td> </tr> <tr> <td align="right" valign="middle" nowrap>Back Dado Depth</td> <td align="center" valign="middle"><input name="BackPocketDepthWall" type="text" class="h4" id="BackPocketDepthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.375</td> <td align="left" valign="middle">Amount To Cut Back Dado Depth</td> </tr> <tr> <td align="right" valign="middle">Rabbit Clearance</td> <td align="center" valign="middle"><input name="RabbitClearing" type="text" class="h4" id="RabbitClearing" size="6" maxlength="10"></td> <td align="center" valign="middle">0.05</td> <td align="left" valign="middle">Milling Offset Amount To Mill Over The Edge of Material</td> </tr> <tr> <td align="right" valign="middle">Pocket Tool Dia</td> <td align="center" valign="middle"><input name="PocketToolDia" type="text" class="h4" id="PocketToolDia" size="6" maxlength="10"></td> <td align="center" valign="middle">0.05</td> <td align="left" valign="middle">Milling Offset Amount To Mill Over The Edge of Material</td> </tr> <tr> <td align="right" valign="middle">Half Dado Width</td> <td align="center" valign="middle"><input name="HalfDadoWidth" type="text" class="h4" id="HalfDadoWidth" size="6" maxlength="10"></td> <td align="center" valign="middle">0.05</td> <td align="left" valign="middle">Half Dado Width</td> </tr>  <tr> <td align="right" valign="middle">Cabinet Reveal </td> <td align="center" valign="middle"><input name="RevealWall" type="text" class="h4" id="RevealWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.05</td> <td align="left" valign="middle">Cabinet Side Reveal </td> </tr>    <tr> <td align="right" valign="middle" nowrap>Draw FaceFrame On New Sheet</td> <td align="center" valign="middle"><input name="DrawFaceFrameOnNewSheetWall" type="checkbox" id="DrawFaceFrameOnNewSheetWall"></td> <td align="center" valign="middle">Not Checked</td> <td align="left" valign="middle">Make This A Standard Cabinet</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Face Frame Drawing</td> <td align="center" valign="middle"><input type="checkbox" name="DrawFaceFrameWall" id="DrawFaceFrameWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw Cabinet Face Frame If Applicable</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Back Drawing</td> <td align="center" valign="middle"><input type="checkbox" name="DrawBackPanelWall" id="DrawBackPanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A DrawBack</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Right Side Panel</td> <td align="center" valign="middle"><input type="checkbox" name="DrawRightSidePanelWall" id="DrawRightSidePanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw The Right Side Panel</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Left Side Panel</td> <td align="center" valign="middle"><input type="checkbox" name="DrawLeftSidePanelWall" id="DrawLeftSidePanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw The Left Side Panel</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Top Part</td> <td align="center" valign="middle"><input type="checkbox" name="DrawTopPanelWall" id="DrawTopPanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw The Top Panel</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Bottom Part</td> <td align="center" valign="middle"><input type="checkbox" name="DrawBottomPanelWall" id="DrawBottomPanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw The Bottom Panel</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Center Panel</td> <td align="center" valign="middle"><input type="checkbox" name="DrawCenterPanelWall" id="DrawCenterPanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw The Center Panel If Applicable</td> </tr> <tr> <td align="right" valign="middle" nowrap>Write Cabinet Notes File</td> <td align="center" valign="middle"><input type="checkbox" name="ProvideCabinetNotesOnDrawingWall" id="ProvideCabinetNotesOnDrawingWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Write Cabinet Notes File</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Shelf Drawing</td> <td align="center" valign="middle"><input type="checkbox" name="DrawShelfPanelWall" id="DrawShelfPanelWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw Shelf Panel If Applicable</td> </tr> <tr> <td align="right" valign="middle" nowrap>Draw Notes On New Sheet</td> <td align="center" valign="middle"><input type="checkbox" name="ProvideCabinetNotesOnNewSheetWall" id="ProvideCabinetNotesOnNewSheetWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw Cabinet Notes On New Sheet</td> </tr> <tr> <td align="right" valign="middle" nowrap>Add FaceFrame Wall</td> <td align="center" valign="middle"><input type="checkbox" name="AddFaceFrameWall" id="AddFaceFrameWall"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw FaceFrames</td> </tr> <tr> <td align="right" valign="middle" nowrap>Stretcher Thickness</td> <td align="center" valign="middle"><input name="StretcherThicknessWall" type="text" class="h4" id="StretcherThicknessWall" size="6" maxlength="1"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Stretcher Thickness</td> </tr> <tr> <td align="right" valign="middle" nowrap>Stretcher Width</td> <td align="center" valign="middle"><input name="StretcherWidthWall" type="text" class="h4" id="StretcherWidthWall" size="6" maxlength="1"></td> <td align="center" valign="middle">3</td> <td align="left" valign="middle">Stretcher Width</td> </tr> <tr> <td align="right" valign="middle" nowrap>Nailer Thickness</td> <td align="center" valign="middle"><input name="NailerThicknessWall" type="text" class="h4" id="NailerThicknessWall" size="6" maxlength="1"></td> <td align="center" valign="middle">0.5</td> <td align="left" valign="middle">Nailer Thickness</td> </tr> <tr> <td align="right" valign="middle" nowrap>Nailer Width</td> <td align="center" valign="middle"><input name="NailerWidthWall" type="text" class="h4" id="NailerWidthWall" size="6" maxlength="1"></td> <td align="center" valign="middle">1.5</td> <td align="left" valign="middle">Nailer Width</td> </tr> <tr> <td align="right" valign="middle" nowrap>Back or Inside</td> <td align="center" valign="middle"><select name="NailerLocationWall" class="FormButton" id="NailerLocationWall"> <option value="1">Inside</option> <option value="2">Back</option> </select></td> <td align="center" valign="middle">InSide</td> <td align="left" valign="middle">Nailer Location Back or InSide</td> </tr> <tr> <td align="right" valign="middle" nowrap>Side Reveal</td> <td align="center" valign="middle"><input name="FaceFrameRevealWall" type="text" class="h4" id="FaceFrameRevealWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.25</td> <td align="left" valign="middle">Amount Face Frame Extends The Face Frame Passed The Cabinet Side</td> </tr> <tr> <td align="right" valign="middle" nowrap>Face Frame Stile Width</td> <td align="center" valign="middle"><input name="FaceFrameStileWidthWall" type="text" class="h4" id="FaceFrameStileWidthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">2.75</td> <td align="left" valign="middle">Face Frame Stile Face Width</td> </tr> <tr> <td align="right" valign="middle" nowrap> Bottom Rail Width</td> <td align="center" valign="middle"><input name="FaceFrameBottomRailWidthWall" type="text" class="h4" id="FaceFrameBottomRailWidthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">2.75</td> <td align="left" valign="middle">Face Frame Bottom Rail Face Width</td> </tr> <tr> <td align="right" valign="middle" nowrap>Face Frame Thickness</td> <td align="center" valign="middle"><input name="FaceFrameThicknessWall" type="text" class="h4" id="FaceFrameThicknessWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Face Frame Thickness</td> </tr> <tr> <td align="right" valign="middle" nowrap>Top Face Frame Width</td> <td align="center" valign="middle"><input name="FaceFrameTopRailWidthWall" type="text" class="h4" id="FaceFrameTopRailWidthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">2.75</td> <td align="left" valign="middle">Top Face Frame Width</td> </tr> <tr> <td align="right" valign="middle" nowrap>Center Stile Width</td> <td align="center" valign="middle"><input name="FaceFrameCenterStileWidthWall" type="text" class="h4" id="FaceFrameCenterStileWidthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">2.25</td> <td align="left" valign="middle">Center Face Frame Width</td> </tr> <tr> <td align="right" valign="middle">Bottom Rail Reveal</td> <td align="center" valign="middle"><input name="FaceFrameBottomRevealWall" type="text" class="h4" id="FaceFrameBottomRevealWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.0625</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Bottom Of The Cabinet</td> </tr> <tr> <td align="right" valign="middle">Top Frame Overlap</td> <td align="center" valign="middle"><input name="FaceFrameTopOverlapWall" type="text" class="h4" id="FaceFrameTopOverlapWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Amount Face Frame Is Lowered Below The Inside Cabinet Top</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Thickness</td> <td align="center" valign="middle"><input name="ShelfMaterialThicknessWall" type="text" class="h4" id="ShelfMaterialThicknessWall" size="6" maxlength="1"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Shelf Material Thickness</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Count</td> <td align="center" valign="middle"><input name="ShelfCountWall" type="text" class="h4" id="ShelfCountWall" size="6" maxlength="10"></td> <td align="center" valign="middle">2</td> <td align="left" valign="middle">Number of Shelves In The Cabinet</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Pin Front</td> <td align="center" valign="middle"><input name="ShelfPinHoleFrontWall" type="text" class="h4" id="ShelfPinHoleFrontWall" size="6" maxlength="10"></td> <td align="center" valign="middle">1.0</td> <td align="left" valign="middle">Front Shelf Pin Offset</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Pin Back</td> <td align="center" valign="middle"><input name="ShelfPinHoleBackWall" type="text" class="h4" id="ShelfPinHoleBackWall" size="6" maxlength="10"></td> <td align="center" valign="middle">1.25</td> <td align="left" valign="middle">Back Shelf Offset </td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Width Clearance</td> <td align="center" valign="middle"><input name="ShelfFrontClearanceWall" type="text" class="h4" id="ShelfFrontClearanceWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.18</td> <td align="left" valign="middle">Shelf Face Clarence.</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf End Clarence</td> <td align="center" valign="middle"><input name="ShelfEndClarenceWall" type="text" class="h4" id="ShelfEndClarenceWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.18</td> <td align="left" valign="middle">Shelf End Clarence, To Clear The Pin Plate (amount applied to each end)</td> </tr> <tr> <td align="right" valign="middle">Shelf Hole Spacing</td> <td align="center" valign="middle"><input name="ShelfHoleSpacingWall" type="text" class="h4" id="ShelfHoleSpacingWall" size="6" maxlength="10"></td> <td align="center" valign="middle">2</td> <td align="left" valign="middle">Distance Of Hole Spacing</td> </tr> <tr> <td align="right" valign="middle" nowrap>Bottom Row Spacing For Hole</td> <td align="center" valign="middle"><input name="ShelfHoleFirstRowSpacingWall" type="text" class="h4" id="ShelfHoleFirstRowSpacingWall" size="6" maxlength="10"></td> <td align="center" valign="middle">4</td> <td align="left" valign="middle">Amount Of Space for First Shelf</td> </tr> <tr> <td align="right" valign="middle">Top Hole Row Spacing</td> <td align="center" valign="middle"><input name="ShelfHoleLastRowSpacingWall" type="text" class="h4" id="ShelfHoleLastRowSpacingWall" size="6" maxlength="10"></td> <td align="center" valign="middle">3</td> <td align="left" valign="middle">Min Space At Top Shelf</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Face Frame Reveal</td> <td align="center" valign="middle"><input name="ShelfFaceFrameRevealWall" type="text" class="h4" id="ShelfFaceFrameRevealWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.0625</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Shelf</td> </tr> <tr> <td align="right" valign="middle" nowrap>Hing Bottom Clearnace </td> <td align="center" valign="middle"><input name="HingBottomClearnace" type="text" class="h4" id="HingBottomClearnace" size="6" maxlength="10"></td> <td align="center" valign="middle">0.194</td> <td align="left" valign="middle">Hing Bottom Clearnace</td> </tr> <tr> <td align="right" valign="middle" nowrap>Hing Count </td> <td align="center" valign="middle"><input name="HingCountWall" type="text" class="h4" id="HingCountWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.194</td> <td align="left" valign="middle">Hing Count</td> </tr> <tr> <td align="right" valign="middle" nowrap>Hing Top Clearnace</td> <td align="center" valign="middle"><input name="HingTopClearnace" type="text" class="h4" id="HingTopClearnace" size="6" maxlength="10"></td> <td align="center" valign="middle">0.194</td> <td align="left" valign="middle">Hing Top Clearnace</td> </tr> <tr> <td align="right" valign="middle" nowrap>Hing Hole Centers</td> <td align="center" valign="middle"><input name="HingHoleCenters" type="text" class="h4" id="HingHoleCenters" size="6" maxlength="10"></td> <td align="center" valign="middle">0.194</td> <td align="left" valign="middle">Hing Hole Centers Front to back</td> </tr> <tr> <td align="right" valign="middle" nowrap>Face Frame Thickness</td> <td align="center" valign="middle"><input name="ShelfFaceFrameThicknessWall" type="text" class="h4" id="ShelfFaceFrameThicknessWall" size="6" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Shelf Face Frame Thickness</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Face Frame Width</td> <td align="center" valign="middle"><input name="ShelfFaceFrameWidthWall" type="text" class="h4" id="ShelfFaceFrameWidthWall" size="6" maxlength="10"></td> <td align="center" valign="middle">1.5</td> <td align="left" valign="middle">Shelf Face Frame Width</td> </tr> <tr> <td align="right" valign="middle" nowrap>Shelf Pin Diameter</td> <td align="center" valign="middle"><input name="ShelfPinDiameter" type="text" class="h4" id="ShelfPinDiameter" size="6" maxlength="10"></td> <td align="center" valign="middle">0.194</td> <td align="left" valign="middle">Shelf Pin Diameter</td> </tr> <tr> <td colspan="4" align="center" valign="middle"><table border="0" width="82%"> <tr> <td style="width: 20%">&nbsp;</td> <td style="width: 20%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td style="width: 20%">&nbsp;</td> <td style="width: 20%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> <td style="width: 20%">&nbsp;</td> </tr> </table></td> </tr> </table> </body> </html>]]
    --local html_path = "file:" .. script_path .. "\\Cabinet-WallDim.htm"
    local dialog = HTML_Dialog(true, myHtml, 730, 700,      ProjectQuestion.ProgramTitle) ; 
    dialog:AddLabelField("ProgramVersion",                  ProjectQuestion.ProgramVersion) ; 
    dialog:AddLabelField("ProgramTitle",                    ProjectQuestion.ProgramTitle) ; 
    dialog:AddLabelField("CodeBy",                          ProjectQuestion.CodeBy) ; 
    dialog:AddLabelField("ProgramName",                     ProjectQuestion.ProgramName) ; 
    dialog:AddLabelField("Contact",                         ProjectQuestion.Contact) ; 
    dialog:AddLabelField("Year",                            ProjectQuestion.Year) ; 
    dialog:AddTextField("CabinetName",                      NameStrip(string.upper(ProjectQuestion.CabinetName),"-"))  ;  
    dialog:AddTextField("ProjectName",                      string.upper(ProjectQuestion.ProjectName)) ;
    dialog:AddTextField("ProjectPath",                      ProjectQuestion.ProjectPath) ;  
    dialog:AddDoubleField("HingCountWall",                  Hardware.HingCountWall) ;  
    dialog:AddDoubleField("HingBottomClearnace",            Hardware.HingBottomClearnace) ;   
    dialog:AddDoubleField("HingTopClearnace",               Hardware.HingTopClearnace) ; 
    dialog:AddDoubleField("ShelfPinDiameter",               Hardware.ShelfPinDiameter) ; 
    dialog:AddDoubleField("HingHoleCenters",                Hardware.HingHoleCenters) ; 
    dialog:AddDoubleField("SidePocketDepth",                Milling.SidePocketDepth) ; 
    dialog:AddDoubleField("DadoClearnace",                  Milling.DadoClearnace) ; 
    dialog:AddDoubleField("RabbitClearing",                 Milling.RabbitClearing) ; 
    dialog:AddDoubleField("ProfileToolDia",                 Milling.ProfileToolDia) ; 
    dialog:AddDoubleField("PocketToolDia",                  Milling.PocketToolDia) ; 
    dialog:AddDoubleField("DadoToolDia",                    Milling.DadoToolDia) ; 
    dialog:AddDoubleField("HalfDadoWidth",                  Milling.HalfDadoWidth) ; 
    dialog:AddDoubleField("PilotBitDia",                    Milling.PilotBitDia) ; 
    dialog:AddDoubleField("BackPocketDepthWall",            WallDim.BackPocketDepthWall) ;
    dialog:AddDoubleField("BlindDadoSetbackWall",           WallDim.BlindDadoSetbackWall) ; 
    dialog:AddDoubleField("CabDepthWall",                   WallDim.CabDepthWall) ; 
    dialog:AddDoubleField("CabLengthWall",                  WallDim.CabLengthWall) ; 
    dialog:AddDoubleField("CabHeightWall",                  WallDim.CabHeightWall) ; 
    dialog:AddDoubleField("FaceFrameBottomRailWidthWall",   WallDim.FaceFrameBottomRailWidthWall) ; 
    dialog:AddDoubleField("FaceFrameBottomRevealWall",      WallDim.FaceFrameBottomRevealWall) ; 
    dialog:AddDoubleField("FaceFrameCenterStileWidthWall",  WallDim.FaceFrameCenterStileWidthWall) ; 
    dialog:AddDoubleField("FaceFrameRevealWall",            WallDim.FaceFrameRevealWall) ; 
    dialog:AddDoubleField("FaceFrameStileWidthWall",        WallDim.FaceFrameStileWidthWall) ; 
    dialog:AddDoubleField("FaceFrameThicknessWall",         WallDim.FaceFrameThicknessWall) ; 
    dialog:AddDoubleField("FaceFrameTopOverlapWall",        WallDim.FaceFrameTopOverlapWall) ; 
    dialog:AddDoubleField("FaceFrameTopRailWidthWall",      WallDim.FaceFrameTopRailWidthWall) ; 
    dialog:AddDoubleField("NailerThicknessWall",            WallDim.NailerThicknessWall) ; 
    dialog:AddDoubleField("NailerWidthWall",                WallDim.NailerWidthWall) ; 
    dialog:AddDoubleField("RevealWall",                     WallDim.RevealWall) ; 
    dialog:AddDoubleField("ShelfCountWall",                 WallDim.ShelfCountWall) ; 
    dialog:AddDoubleField("ShelfEndClarenceWall",           WallDim.ShelfEndClarenceWall) ; 
    dialog:AddDoubleField("ShelfFaceFrameRevealWall",       WallDim.ShelfFaceFrameRevealWall) ; 
    dialog:AddDoubleField("ShelfFaceFrameThicknessWall",    WallDim.ShelfFaceFrameThicknessWall) ; 
    dialog:AddDoubleField("ShelfFaceFrameWidthWall",        WallDim.ShelfFaceFrameWidthWall) ; 
    dialog:AddDoubleField("ShelfFrontClearanceWall",        WallDim.ShelfFrontClearanceWall) ;
    dialog:AddDoubleField("ShelfHoleFirstRowSpacingWall",   WallDim.ShelfHoleFirstRowSpacingWall) ; 
    dialog:AddDoubleField("ShelfHoleLastRowSpacingWall",    WallDim.ShelfHoleLastRowSpacingWall) ; 
    dialog:AddDoubleField("ShelfHoleSpacingWall",           WallDim.ShelfHoleSpacingWall) ; 
    dialog:AddDoubleField("ShelfMaterialThicknessWall",     WallDim.ShelfMaterialThicknessWall) ; 
    dialog:AddDoubleField("ShelfPinHoleBackWall",           WallDim.ShelfPinHoleBackWall) ; 
    dialog:AddDoubleField("ShelfPinHoleFrontWall",          WallDim.ShelfPinHoleFrontWall) ; 
    dialog:AddDoubleField("StretcherThicknessWall",         WallDim.StretcherThicknessWall) ; 
    dialog:AddDoubleField("StretcherWidthWall",             WallDim.StretcherWidthWall) ; 
    dialog:AddDoubleField("ThicknessBackWall",              WallDim.ThicknessBackWall) ; 
    dialog:AddDoubleField("ThicknessWall",                  WallDim.ThicknessWall) ; 
--    dialog:AddCheckBox("AddCabinetSettingsToProject",       ProjectQuestion.AddCabinetSettingsToProject) ;
    dialog:AddCheckBox("AddBackNailerWall",                 WallQuestion.AddBackNailerWall) ; 
    dialog:AddCheckBox("AddCenterPanelWall",                WallQuestion.AddCenterPanelWall) ; 
    dialog:AddCheckBox("AddFaceFrameWall",                  WallQuestion.AddFaceFrameWall) ; 
    dialog:AddCheckBox("AddShelfHingPilotHolesWall",        WallQuestion.AddShelfHingPilotHolesWall) ; 
    dialog:AddCheckBox("AddShelfHolesWall",                 WallQuestion.AddShelfHolesWall) ; 
    dialog:AddCheckBox("AddShelfingWall",                   WallQuestion.AddShelfingWall) ; 
    dialog:AddCheckBox("AddStretchersWall",                 WallQuestion.AddStretchersWall) ; 
    dialog:AddCheckBox("DrawBackPanelWall",                 WallQuestion.DrawBackPanelWall) ; 
    dialog:AddCheckBox("DrawBottomPanelWall",               WallQuestion.DrawBottomPanelWall) ; 
    dialog:AddCheckBox("DrawCenterPanelWall",               WallQuestion.DrawCenterPanelWall) ; 
    dialog:AddCheckBox("DrawFaceFrameOnNewSheetWall",       WallQuestion.DrawFaceFrameOnNewSheetWall) ; 
    dialog:AddCheckBox("DrawFaceFrameWall",                 WallQuestion.DrawFaceFrameWall) ; 
    dialog:AddCheckBox("DrawLeftSidePanelWall",             WallQuestion.DrawLeftSidePanelWall) ; 
    dialog:AddCheckBox("ProvideCabinetNotesOnNewSheetWall", WallQuestion.ProvideCabinetNotesOnNewSheetWall) ; 
    dialog:AddCheckBox("ProvideCabinetNotesOnDrawingWall",  WallQuestion.ProvideCabinetNotesOnDrawingWall) ; 
    dialog:AddCheckBox("DrawRightSidePanelWall",            WallQuestion.DrawRightSidePanelWall) ;    
    dialog:AddCheckBox("DrawShelfPanelWall",                WallQuestion.DrawShelfPanelWall) ; 
    dialog:AddCheckBox("DrawTopPanelWall",                  WallQuestion.DrawTopPanelWall) ; 
    dialog:AddDropDownList("DadoStyleWall",                 WallQuestion.DadoStyleWall ) ; 
    dialog:AddDropDownList("DadoTypeWall",                  WallQuestion.DadoTypeWall ) ; 
    dialog:AddDropDownList("FaceFrameOrStretchersWall",     WallQuestion.FaceFrameOrStretchersWall ) ; 
    dialog:AddDropDownList("BackDadoOrOverlapWall",         WallQuestion.BackDadoOrOverlapWall ) ; 
    dialog:AddDropDownList("NailerLocationWall",            WallQuestion.NailerLocationWall ) ; 
    dialog:AddDropDownListValue("NailerLocationWall",           "Inside") ; 
    dialog:AddDropDownListValue("NailerLocationWall",           "Onback") ; 
    dialog:AddDropDownListValue("BackDadoOrOverlapWall",        "Dado") ; 
    dialog:AddDropDownListValue("BackDadoOrOverlapWall",        "OverlapWall") ;
    dialog:AddDropDownListValue("FaceFrameOrStretchersWall",    "FaceFrame") ; 
    dialog:AddDropDownListValue("FaceFrameOrStretchersWall",    "Stretchers") ; 
    dialog:AddDropDownListValue("DadoTypeWall",                 "Through") ; 
    dialog:AddDropDownListValue("DadoTypeWall",                 "Blind") ; 
    dialog:AddDropDownListValue("DadoStyleWall",                "Full") ; 
    dialog:AddDropDownListValue("DadoStyleWall",                "Half") ; 
    if not dialog:ShowDialog() then
        return false
        -- Done and run ; -)
    end 
-- Get the data from the Dialog and update my global variables

    WallQuestion.DadoTypeWall = dialog:GetDropDownListValue("DadoTypeWall") ; 
    WallQuestion.DadoStyleWall = dialog:GetDropDownListValue("DadoStyleWall") ; 
    WallQuestion.DadoTypeWall = dialog:GetDropDownListValue("DadoTypeWall") ; 
    WallQuestion.FaceFrameOrStretchersWall = dialog:GetDropDownListValue("FaceFrameOrStretchersWall") ; 
    WallQuestion.BackDadoOrOverlapWall = dialog:GetDropDownListValue("BackDadoOrOverlapWall") ; 
    WallQuestion.NailerLocationWall = dialog:GetDropDownListValue("NailerLocationWall") ; 
--    ProjectQuestion.ProjectName = string.upper(dialog:GetCheckBox("ProjectName")) ;
    WallQuestion.AddBackNailerWall = dialog:GetCheckBox("AddBackNailerWall") ;             
    WallQuestion.AddCenterPanelWall = dialog:GetCheckBox("AddCenterPanelWall") ;            
    WallQuestion.AddFaceFrameWall = dialog:GetCheckBox("AddFaceFrameWall") ;              
    WallQuestion.AddShelfHingPilotHolesWall = dialog:GetCheckBox("AddShelfHingPilotHolesWall") ;    
    WallQuestion.AddShelfHolesWall = dialog:GetCheckBox("AddShelfHolesWall") ;              
    WallQuestion.AddShelfingWall = dialog:GetCheckBox("AddShelfingWall") ;              
    WallQuestion.AddStretchersWall = dialog:GetCheckBox("AddStretchersWall") ;              
    WallQuestion.DrawBackPanelWall = dialog:GetCheckBox("DrawBackPanelWall") ;             
    WallQuestion.DrawBottomPanelWall = dialog:GetCheckBox("DrawBottomPanelWall") ;           
    WallQuestion.DrawCenterPanelWall = dialog:GetCheckBox("DrawCenterPanelWall") ;           
    WallQuestion.DrawFaceFrameOnNewSheetWall = dialog:GetCheckBox("DrawFaceFrameOnNewSheetWall") ;  
    WallQuestion.DrawFaceFrameWall = dialog:GetCheckBox("DrawFaceFrameWall") ;             
    WallQuestion.DrawLeftSidePanelWall = dialog:GetCheckBox("DrawLeftSidePanelWall") ;         
    WallQuestion.DrawRightSidePanelWall = dialog:GetCheckBox("DrawRightSidePanelWall") ;        
    WallQuestion.DrawShelfPanelWall = dialog:GetCheckBox("DrawShelfPanelWall") ;            
    WallQuestion.DrawTopPanelWall = dialog:GetCheckBox("DrawTopPanelWall") ;              
    WallQuestion.ProvideCabinetNotesOnDrawingWall = dialog:GetCheckBox("ProvideCabinetNotesOnDrawingWall") ;  
    WallQuestion.ProvideCabinetNotesOnNewSheetWall = dialog:GetCheckBox("ProvideCabinetNotesOnNewSheetWall");
    ProjectQuestion.CabinetName = string.upper(dialog:GetTextField("CabinetName")) .. " - " .. NowName()
    WallDim.ThicknessWall = tonumber(dialog:GetDoubleField("ThicknessWall")) ; 
    WallDim.CabLengthWall = tonumber(dialog:GetDoubleField("CabLengthWall")) ; 
    WallDim.CabHeightWall = tonumber(dialog:GetDoubleField("CabHeightWall")) ; 
    WallDim.CabDepthWall = tonumber(dialog:GetDoubleField("CabDepthWall")) ; 
    WallDim.ThicknessBackWall = tonumber(dialog:GetDoubleField("ThicknessBackWall")) ; 
    WallDim.BlindDadoSetbackWall = tonumber(dialog:GetDoubleField("BlindDadoSetbackWall")) ; 
    WallDim.NailerThicknessWall = tonumber(dialog:GetDoubleField("NailerThicknessWall")) ; 
    WallDim.NailerWidthWall = tonumber(dialog:GetDoubleField("NailerWidthWall")) ; 
    WallDim.SidePocketDepth = tonumber(dialog:GetDoubleField("SidePocketDepth")) ; 
    WallDim.BackPocketDepthWall = tonumber(dialog:GetDoubleField("BackPocketDepthWall")) ; 
    WallQuestion.DrawFaceFrameWall = dialog:GetCheckBox("DrawFaceFrameWall") ; 
    WallQuestion.DrawBackPanelWall = dialog:GetCheckBox("DrawBackPanelWall") ; 
    WallQuestion.DrawRightSidePanelWall = dialog:GetCheckBox("DrawRightSidePanelWall") ; 
    WallQuestion.DrawLeftSidePanelWall = dialog:GetCheckBox("DrawLeftSidePanelWall") ; 
    WallQuestion.DrawTopPanelWall = dialog:GetCheckBox("DrawTopPanelWall") ; 
    WallQuestion.DrawBottomPanelWall = dialog:GetCheckBox("DrawBottomPanelWall") ; 
    WallQuestion.DrawCenterPanelWall = dialog:GetCheckBox("DrawCenterPanelWall") ; 
    WallQuestion.ProvideCabinetNotesOnDrawingWall = dialog:GetCheckBox("ProvideCabinetNotesOnDrawingWall") ; 
    WallQuestion.DrawShelfPanelWall = dialog:GetCheckBox("DrawShelfPanelWall") ; 
--  ProjectQuestion.AddCabinetSettingsToProject = dialog:GetCheckBox("AddCabinetSettingsToProject") ;   
    Hardware.HingCountWall = tonumber(dialog:GetDoubleField("HingCountWall")) ; 
    Hardware.HingBottomClearnace = tonumber(dialog:GetDoubleField("HingBottomClearnace")) ;  
    Hardware.HingTopClearnace = tonumber(dialog:GetDoubleField("HingTopClearnace")) ;  
    Hardware.ShelfPinDiameter = tonumber(dialog:GetDoubleField("ShelfPinDiameter")) ; 
    Hardware.HingHoleCenters = tonumber(dialog:GetDoubleField("HingHoleCenters")) ; 
    Hardware.ShelfPinRadus = Hardware.ShelfPinDiameter * 0.5 ; 
    Milling.PocketToolDia = tonumber(dialog:GetDoubleField("PocketToolDia")) ; 
    Milling.PocketToolRadus = Milling.PocketToolDia * 0.5 ;
    Milling.RabbitClearing = tonumber(dialog:GetDoubleField("RabbitClearing")) ;  
    Milling.SidePocketDepth = tonumber(dialog:GetDoubleField("SidePocketDepth")) ; 
    Milling.DadoClearnace = tonumber(dialog:GetDoubleField("DadoClearnace")) ; 
    Milling.ProfileToolDia = tonumber(dialog:GetDoubleField("ProfileToolDia")) ;   
    Milling.DadoToolDia = tonumber(dialog:GetDoubleField("DadoToolDia")) ;
    Milling.HalfDadoWidth = tonumber(dialog:GetDoubleField("HalfDadoWidth")) ; 
    Milling.PilotBitDia = tonumber(dialog:GetDoubleField("PilotBitDia")) ; 
    WallDim.BackPocketDepthWall = tonumber(dialog:GetDoubleField"BackPocketDepthWall" ) ;
    WallDim.BlindDadoSetbackWall = tonumber(dialog:GetDoubleField"BlindDadoSetbackWall" ) ;
    WallDim.CabDepthWall = tonumber(dialog:GetDoubleField"CabDepthWall" ) ;
    WallDim.CabLengthWall = tonumber(dialog:GetDoubleField"CabLengthWall" ) ;
    WallDim.CabHeightWall = tonumber(dialog:GetDoubleField"CabHeightWall" ) ;
    WallDim.FaceFrameBottomRailWidthWall = tonumber(dialog:GetDoubleField"FaceFrameBottomRailWidthWall" ) ;
    WallDim.FaceFrameBottomRevealWall = tonumber(dialog:GetDoubleField"FaceFrameBottomRevealWall" ) ;
    WallDim.FaceFrameCenterStileWidthWall = tonumber(dialog:GetDoubleField"FaceFrameCenterStileWidthWall" ) ;
    WallDim.FaceFrameRevealWall = tonumber(dialog:GetDoubleField"FaceFrameRevealWall" ) ; 
    WallDim.FaceFrameStileWidthWall = tonumber(dialog:GetDoubleField"FaceFrameStileWidthWall" ) ;
    WallDim.FaceFrameThicknessWall = tonumber(dialog:GetDoubleField"FaceFrameThicknessWall" ) ;
    WallDim.FaceFrameTopOverlapWall = tonumber(dialog:GetDoubleField"FaceFrameTopOverlapWall" ) ;
    WallDim.FaceFrameTopRailWidthWall = tonumber(dialog:GetDoubleField"FaceFrameTopRailWidthWall" ) ;
    WallDim.NailerThicknessWall = tonumber(dialog:GetDoubleField"NailerThicknessWall" ) ;
    WallDim.NailerWidthWall = tonumber(dialog:GetDoubleField"NailerWidthWall" ) ;
    WallDim.RevealWall = tonumber(dialog:GetDoubleField"RevealWall" ) ;
    WallDim.ShelfCountWall = tonumber(dialog:GetDoubleField"ShelfCountWall" ) ;
    WallDim.ShelfEndClarenceWall = tonumber(dialog:GetDoubleField"ShelfEndClarenceWall" ) ; 
    WallDim.ShelfFaceFrameRevealWall = tonumber(dialog:GetDoubleField"ShelfFaceFrameRevealWall" ) ;
    WallDim.ShelfFaceFrameThicknessWall = tonumber(dialog:GetDoubleField"ShelfFaceFrameThicknessWall" ) ;
    WallDim.ShelfFaceFrameWidthWall = tonumber(dialog:GetDoubleField"ShelfFaceFrameWidthWall" ) ; 
    WallDim.ShelfFrontClearanceWall = tonumber(dialog:GetDoubleField"ShelfFrontClearanceWall" ) ;
    WallDim.ShelfHoleFirstRowSpacingWall = tonumber(dialog:GetDoubleField"ShelfHoleFirstRowSpacingWall" ) ;
    WallDim.ShelfHoleLastRowSpacingWall = tonumber(dialog:GetDoubleField"ShelfHoleLastRowSpacingWall" ) ;
    WallDim.ShelfHoleSpacingWall = tonumber(dialog:GetDoubleField"ShelfHoleSpacingWall" ) ;
    WallDim.ShelfMaterialThicknessWall = tonumber(dialog:GetDoubleField"ShelfMaterialThicknessWall" ) ;
    WallDim.ShelfPinHoleBackWall = tonumber(dialog:GetDoubleField"ShelfPinHoleBackWall" ) ;
    WallDim.ShelfPinHoleFrontWall = tonumber(dialog:GetDoubleField"ShelfPinHoleFrontWall" ) ;
    WallDim.StretcherThicknessWall = tonumber(dialog:GetDoubleField"StretcherThicknessWall" ) ;
    WallDim.StretcherWidthWall = tonumber(dialog:GetDoubleField"StretcherWidthWall" ) ; 
    WallDim.ThicknessBackWall = tonumber(dialog:GetDoubleField"ThicknessBackWall" ) ; 
    WallDim.ThicknessWall = tonumber(dialog:GetDoubleField"ThicknessWall" ) ;

--[[        ]]
    return true  
end -- function end  
-- ===================================================
function LoadDialog2(job) -- Short Dialog
       DeBug(9520,1, "LoadDialog") 
ShowMe()
-- local registry = Registry("CabinetMaker")

    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type">
<title>Cabinet Maker and Tool-path Creator</title>
<style type="text/css">
html {
	overflow: auto;
}
body, td, th {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	color: #000;
}
.FormButton {
	width: 100%;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.h2 {
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	width: 98%;
}
.h4 {
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	width: 99%;
</style>
</head>
<body bgcolor = "#EBEBEB" text = "#000000">
<table width="675" border="2" cellpadding="0">
  <tr>
    <th align="center" colspan="1" valign="middle" id="ProgramTitle">ProgramTitle</th>
    <th align="center" colspan="1" valign="middle" id="Message">Message</th>
    <th align="center" colspan="1" valign="middle" id="ProgramTitle">ProgramTitle</th>
    <th align="right" colspan="1" valign="middle" id="codeBy">Code By</th>
  </tr>
  <tr>
    <th align="center" colspan="1" valign="middle" id="ProgramVersion">ProgramVersion</th>
    <th align="center" colspan="1" valign="middle" id="Year">Year</th>
    <th align="center" colspan="1" valign="middle" id="ProgramName">ProgramName</th>
    <th align="right" colspan="1" valign="middle" id="Contact">Contact</th>
  </tr>
    <tr>
    <th width = "166" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" class="h2" id = "Questions2">Select Previous Cabinet </th>
    <th height = "15" colspan="3" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> <span class="h2">
      <select name = "DList" size = "1" class = "FormButton" id = "ListBox">
        <option>Defalt</option>
      </select>
    </span></th>
  </tr>
  <tr>
    <th align="right" valign="middle">Project Name</th>
    <th colspan="3" align="left" valign="middle"> <input name="ProjectName" type="text" class="FormButton" id="ProjectName" value="Required" size="50" maxlength="50"readonly></th>
  </tr>
  <tr>
    <th align="right" valign="middle">Project Path</th>
    <th colspan="3" align="left" valign="middle"> <input name="ProjectPath" type="text" class="FormButton" id="ProjectPath" value="Required" size="50" maxlength="50"readonly></th>
  </tr>
  <tr>
    <th align="right" valign="middle" bgcolor="#FFFF00">Cabinet Name</th>
    <th colspan="3" align="left" valign="middle"> <input name="CabinetName" type="text" class="FormButton" id="CabinetName" value="Required" size="50" maxlength="50"></th>
  </tr>
  <tr>
    <th width="166" align="center" valign="middle"><strong>Item</strong></th>
    <th width="395" align="center" valign="middle">Value</th>
    <th width="37" align="center" valign="middle" nowrap><strong>Default Value</strong></th>
    <th width="55" align="center" valign="middle"><strong>Information</strong></th>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap>Wall Cabinet Width</td>
    <td align="center" valign="middle"><input name="CabLengthWall" type="text" class="h4" id="CabLengthWall" size="6" maxlength="10"></td>
    <td align="center" valign="middle" nowrap>36</td>
    <td align="left" valign="middle" nowrap>Wall Cabinet Width (Left to Right)</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap>Wall Cabinet Height</td>
    <td align="center" valign="middle"><input name="CabHeightWall" type="text" class="h4" id="CabHeightWall" size="6" maxlength="10"></td>
    <td align="center" valign="middle" nowrap>28</td>
    <td align="left" valign="middle" nowrap>Wall Cabinet Height (Top to Bottom)</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap>Wall Cabinet Depth</td>
    <td align="center" valign="middle"><input name="CabDepthWall" type="text" class="h4" id="CabDepthWall" size="6" maxlength="10"></td>
    <td align="center" valign="middle" nowrap>12</td>
    <td align="left" valign="middle" nowrap>Wall Cabinet Depth (Front to Back)</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap>Material Thickness</td>

    <td align="center" valign="middle"><input name="ThicknessWall" type="text" class="h4" id="ThicknessWall" size="6" maxlength="10"></td>
    <td align="center" valign="middle" nowrap>0.75</td>
    <td align="left" valign="middle" nowrap>Material Thickness for Cabinet Sides</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap>Back Material Thickness</td>
    <td align="center" valign="middle"><input name="ThicknessBackWall" type="text" class="h4" id="ThicknessBackWall" size="6" maxlength="10"></td>
    <td align="center" valign="middle" nowrap>0.5</td>
    <td align="left" valign="middle" nowrap>Material Thickness Used On The Back</td>
  </tr>
  <tr>
    <td align="right" valign="middle" nowrap>Shelf Count</td>
    <td align="center" valign="middle"><input name="ShelfCountWall" type="text" class="h4" id="ShelfCountWall" size="6" maxlength="10"></td>
    <td align="center" valign="middle" nowrap>2</td>
    <td align="left" valign="middle" nowrap>Number of Shelves In The Cabinet</td>
  </tr>
  <tr>
    <td colspan="4" align="center" valign="middle"><table border="0" width="82%">
        <tr>
          <td style="width: 20%">&nbsp;</td>
          <td style="width: 20%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td>
          <td style="width: 20%">&nbsp;</td>
          <td style="width: 20%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td>
          <td style="width: 20%">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html> </html>]]
    --local html_path = "file:" .. script_path .. "\\Cabinet-WallDim.htm"
    local dialog = HTML_Dialog(true, myHtml, 730, 465,      ProjectQuestion.ProgramTitle) ; 
    dialog:AddDropDownList("ListBox", "DEFAULT") ;     
    dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
    for index, value in pairs(IniFile) do ; 
        dialog:AddDropDownListValue("ListBox", value) ; 
    end ; 
    dialog:AddLabelField("ProgramVersion",                  ProjectQuestion.ProgramVersion) ; 
    dialog:AddLabelField("ProgramTitle",                    ProjectQuestion.ProgramTitle) ; 
    dialog:AddLabelField("CodeBy",                          ProjectQuestion.CodeBy) ; 
    dialog:AddLabelField("ProgramName",                     ProjectQuestion.ProgramName) ; 
    dialog:AddLabelField("Contact",                         ProjectQuestion.Contact) ; 
    dialog:AddLabelField("Year",                            ProjectQuestion.Year) ; 
    dialog:AddTextField("CabinetName",                      NameStrip(string.upper(ProjectQuestion.CabinetName),"-"))  ;  
    dialog:AddTextField("ProjectName",                      string.upper(ProjectQuestion.ProjectName)) ;
    dialog:AddTextField("ProjectPath",                      ProjectQuestion.ProjectPath) ;  
    dialog:AddDoubleField("CabDepthWall",                   WallDim.CabDepthWall) ; 
    dialog:AddDoubleField("CabLengthWall",                  WallDim.CabLengthWall) ; 
    dialog:AddDoubleField("CabHeightWall",                  WallDim.CabHeightWall) ; 
    dialog:AddDoubleField("ShelfCountWall",                 WallDim.ShelfCountWall) ; 
    dialog:AddDoubleField("ThicknessBackWall",              WallDim.ThicknessBackWall) ; 
    dialog:AddDoubleField("ThicknessWall",                  WallDim.ThicknessWall) ; 
    if not dialog:ShowDialog() then
        return false
        -- Done and run ; -)
    end 
-- Get the data from the Dialog and update my global variables
    ProjectQuestion.CabinetName = string.upper(dialog:GetTextField("CabinetName")) .. " - " .. NowName()
    WallDim.ThicknessWall = tonumber(dialog:GetDoubleField("ThicknessWall")) ; 
    WallDim.CabLengthWall = tonumber(dialog:GetDoubleField("CabLengthWall")) ; 
    WallDim.CabHeightWall = tonumber(dialog:GetDoubleField("CabHeightWall")) ; 
    WallDim.CabDepthWall = tonumber(dialog:GetDoubleField("CabDepthWall")) ; 
    WallDim.ThicknessBackWall = tonumber(dialog:GetDoubleField("ThicknessBackWall")) ; 
    WallDim.ShelfCountWall = tonumber(dialog:GetDoubleField"ShelfCountWall" ) ;
    WallDim.ThicknessBackWall = tonumber(dialog:GetDoubleField"ThicknessBackWall" ) ; 
    WallDim.ThicknessWall = tonumber(dialog:GetDoubleField"ThicknessWall" ) ;
    Milling.PocketToolRadus = Milling.PocketToolDia * 0.5 ;
    return true  
end -- function end  
-- ===================================================
function main(script_path)
    local job = VectricJob()
-- -----------------------------------------------------------------------------
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        goto exit ;-- when timing of want to finish script.
        return false ; 
    end
-- -----------------------------------------------------------------------------  
--      DeBug(8001 , 1, "main - DeBugClear" ) 
--  Check to clear the debug log
--      if (not DeBugClear()) then goto exit end
    
    DeBug(8002 , 1, "main - ProjectBackup" ) 
--  Write the backup script
    if (not ProjectBackup(script_path)) then goto exit end
    
    DeBug(8003 , 1, "main - G_ReadINICabinetMaker" ) 
--  Global Read Cabinet Var's loaded
    G_ReadINICabinetMaker(script_path, "Settings", "CabinetMaker") 
    
    DeBug(8004 , 1, "main - ReadRegistryStandardCabinetList" ) 
--  Read Registry Vars loaded
    ReadRegistryStandardCabinetList()
    
    DeBug(8005 , 1, "main - SetupDefalts" ) 
--  Setup default values
    SetupDefalts()
    
    DeBug(8006 , 1, "main - UpdateRegistryStandardCabinetList" ) 
--  Write to Registry
    UpdateRegistryStandardCabinetList()

    DeBug(8007, 1, "main - ProjectHeaderReader") 
--  Read ProjectHeader  
    ProjectHeaderReader(script_path)-- Read Default Projects

    DeBug(8008, 1, "main - ProjectDropList" ) 
--  Show and get the Project Names
    ProjectQuestion.ProjectName = ProjectDropList("Cabinet Maker", "Select Project",  290, 205,  Projects)

    DeBug(8009, 1, "main - NewProject") 
--  New Project
    NewProject(script_path)
    
    DeBug(8010, 1, "main - SelectCabinet") 
--  Select Cabinet  
    SelectCabinet()  

    
    DeBug(8013, 1, "main - LoadDialog" )   
    if g_FullDialog == "Full Dialog" then
        repeat
            local ret_value = LoadDialog1(job)
            if ret_value == false then
                return false
            end         
        until ret_value == true
    else
        repeat
            local ret_value = LoadDialog2(job)
            if ret_value == false then
                return false
            end         
        until ret_value == true
    end
    
    
 --ShowMe()   
 
    DeBug(8014, 1, "main - StdFileWriter" ) 
    StdFileWriter(ProjectQuestion.ProjectPath, string.upper(ProjectQuestion.ProjectName), ProjectQuestion.CabinetName) 
    
    DeBug(8015, 1, "main - CabinetCalculations" )  
    CabinetCalculations() 

    DeBug(8016, 1, "main - CabinetSides" ) 
    CabinetSides()

    DeBug(8017, 1, "main - UpperCabinetTandB" )
    TopandBottom()

    DeBug(8018, 1, "main - UpperCenterPanel" ) 
    UpperCenterPanel(WallDim.ThicknessWall .. "-Profile")

    DeBug(8019, 1, "main - CabinetShelfs" ) 
    CabinetShelfs()

    DeBug(8020, 1, "main - UpperCabinetFaceFrame" ) 
    UpperCabinetFaceFrame("FaceFrame")

    DeBug(8021, 1, "main - CutListfileWriter" ) 
    CutListfileWriter(ProjectQuestion.ProjectPath)

    DeBug(8022, 1, "main - UpperCabinetBack" )     
    UpperCabinetBack(job,   WallDim.ThicknessBackWall .. "-Profile") 

-- ------------------------------------------------------------------------------
    ::exit::
        DeBug(8023, 1, "main - exit" ) 
    job:Refresh2DView()-- Regenerate the drawing display
  
    return true 
end -- function end
-- ===================================================