-- VECTRIC LUA SCRIPT
require "strict"
--Global variables

    g_BoxHight = 0.0000
    g_BoxLength = 0.0000
    g_BoxDepth = 0.0000
    g_BackHight = 0.0000
    g_BackWidth = 0.0000
    g_PartGap = 0.5
    g_pt1 = Point2D(1,1)
    g_pt2 = Point2D(20,1)
    g_pt3 = Point2D(40,1)
    g_pt4 = Point2D(14,1)
    g_pt5 = Point2D(14,34)
    g_pt6 = Point2D(30,1)
    g_pt7 = Point2D(30,34)
    g_pt8 = Point2D(45,1)

    IniFile = {} 
    Global = {}
    Global.ProgramTitle = "Wall Cabinet Creator"
    Global.ProgramName = "Wall-Cabinet"
    Global.ProgramVersion = "Version 1.2"
    Global.CodeBy = "James Anderson"
    Global.Contact = "James.L.Anderson@outlook.com"
    Global.Year = "2018"
    Global.JobPath = "G://Tester"

    Milling = {} 
    Milling.MillClearnace = 0.010 -- can be + or - number, used for dato over sizing
    Milling.ToolSizeDia = 0.25
    Milling.ToolSizeRadus = 0.125 
    Milling.RabbitClearnace = 0.050
    Milling.Tool = 0.0
   
    StandardCabs = {} 
    StandardCabs.New  = false

    Base = {} -- Wall Cabinet
    Base.ThicknessBack = 0.5000
    Base.CabLength = 36.0000
    Base.CabHeight = 28.0000
    Base.CabDepth =  23.5000
    Base.Thickness = 0.750
    Base.DatoSetback =  1.375
    Base.DatoDeep =  0.375
    Base.DatoType = "Through"           -- Half, Full
    Base.AddFaceFrame = true
    Base.AddShelf = true
    Base.AddCenterFaceFrame = true
    Base.AddCenterPanel = true           -- Insert Panel in Cabinet
    Base.AddBackNailer = true
    Base.NailerThickness = 0.500
    Base.NailerWidth = 3.500
    Base.AddToeKick = true
    Base.ToeKickDepth = 4.0000
    Base.ToeKickHight = 3.5000
    Base.ToeKickBottomOffsetHight = 0.5000
    Base.ToeKickCoverHight = 0.00
    Base.CenterPanelHight = 0.0
    Base.CenterPanelDepth = 0.0

    FaceFrame = {}
    FaceFrame.FFThickness = 0.7500
    FaceFrame.StileWidth = 2.25
    FaceFrame.BottomRailWidth = 1.25
    FaceFrame.TopRailWidth = 1.75
    FaceFrame.CenterStileWidth = 1.7500
    FaceFrame.StileLength = 0.0000
    FaceFrame.RailLength = 0.0000
    FaceFrame.CenterStileLength = 0.0000   
    FaceFrame.FFReveal = 0.25
    FaceFrame.BottomFFReveal = 0.0625 
    FaceFrame.TopOverlap = 0.7500
    FaceFrame.AddDrawers = true
    FaceFrame.DrawerHeight = 6.0
    FaceFrame.DrawerRowCount = 1.0
    FaceFrame.DrawerFrameWidth = 2.25
    FaceFrame.NumberDrawersPerRow = 2.0
    
    Drawing = {}
    Drawing.DrawFaceFrame = true
    Drawing.DrawBack = true
    Drawing.DrawSideR = true
    Drawing.DrawSideL = true
    Drawing.DrawTop = true
    Drawing.DrawBottom = true
    Drawing.DrawCenter = true 
    Drawing.DrawNotes = true  
    Drawing.DrawShelf = true
 
    Shelf = {}
    Shelf.WidthClearance = 0.25
    Shelf.FaceFrameWidth = 1.500
    Shelf.FaceFrameThickness = 0.7500
    Shelf.EndClarence = 0.1800
    Shelf.PinDiameter = 0.194
    Shelf.PinRadus = 0.0970
    Shelf.Count = 2.0
    Shelf.PartThickness = 0.7500
    Shelf.PartLength = 30.0000
    Shelf.PartDepth = 10.0000
    Shelf.PinOuter = 0.7000
    Shelf.PinInter = 0.1600
    Shelf.FaceFrameReveal = 0.0625
    Shelf.HoleSpacing = 2.0000
    Shelf.HoleFirstRowSpacing = 4.0000
    Shelf.HoleLastRowSpacing = 3.0000       
-- ==============================================================================
function AddGroupToJob(job, group, layer_name)
   local cad_object = CreateCadGroup(group) ; 
   local layer = job.LayerManager:GetLayerWithName(layer_name)
   layer:AddObject(cad_object, true)
   return cad_object 
end
-- ==============================================================================
function fileWriterccc(datFile) 
    local file = io.open(datFile .."//Job.dat", "w")
    -- write line of the file
        file:write("==============================================================================\n")
        file:write("==================== Job Data File for Cabinet Maker 2018 ====================\n")
        file:write("------------------------------------------------------------------------------\n")
        file:write("Milling.MillClearnace        = "..  Milling.MillClearnace      .."   \n")
        file:write("Shelf.EndClarence           = "..  Shelf.EndClarence   .."   \n")
        file:write("Shelf.PinDiameter           = "..  Shelf.PinDiameter   .."   \n")
        file:write("Shelf.Count                 = "..  Shelf.Count   .."   \n")
        file:write("Shelf.FaceFrameWidth        = "..  Shelf.FaceFrameWidth   .."   \n")
        file:write("Shelf.WidthClearance        = "..  Shelf.WidthClearance   .."   \n")
        file:write("Base.ThicknessBack      = "..  Base.ThicknessBack   .."   \n")
        file:write("Base.Thickness          = "..  Base.Thickness   .."   \n")
        file:write("Milling.RabbitClearnace                 = "..  Milling.RabbitClearnace   .."   \n")
        file:write("Global.ProgramTitle               = "..  Global.ProgramTitle   .."   \n")
        file:write("Global.ProgramVersion             = "..  Global.ProgramVersion   .."   \n")
        file:write("Global.CodeBy                     = "..  Global.CodeBy   .."   \n")
        file:write("Milling.ToolSizeDia                = "..  Milling.ToolSizeDia   .."   \n")
        file:write("Milling.ToolSizeRadus              = "..  Milling.ToolSizeRadus   .."   \n")
        file:write("Base.DatoDeep                   = "..  Base.DatoDeep   .."   \n")
        file:write("Shelf.PinRadus                   = "..  Shelf.PinRadus   .."   \n")
        file:write("Base.CabLength         = "..  Base.CabLength   .."   \n")
        file:write("Base.CabHeight         = "..  Base.CabHeight   .."   \n")
        file:write("Base.CabDepth          = "..  Base.CabDepth   .."   \n")
        file:write("Shelf.PinOuter                   = "..  Shelf.PinOuter   .."   \n")
        file:write("Shelf.PinInter                   = "..  Shelf.PinInter   .."   \n")
        file:write("FaceFrame.StileWidth           = "..  FaceFrame.StileWidth   .."   \n")
        file:write("FaceFrame.StileWidth         = "..  FaceFrame.StileWidth   .."   \n")
        file:write("FaceFrame.BottomRailWidth      = "..  FaceFrame.BottomRailWidth  .."   \n")
        file:write("FaceFrame.FFThickness         = "..  FaceFrame.FFThickness   .."   \n")
        file:write("FaceFrame.TopRailWidth          = "..  FaceFrame.TopRailWidth   .."   \n")
        file:write("FaceFrame.CenterStileWidth       = "..  FaceFrame.CenterStileWidth   .."   \n")
        file:write("Base.AddCenterFaceFrame            = "..  Base.AddCenterFaceFrame   .."   \n")
        file:write("Base.AddCenterPanel                = "..  Base.AddCenterPanel   .."   \n")
        file:write("FaceFrame.BottomFFReveal     = "..  FaceFrame.BottomFFReveal   .."   \n")
        file:write("FaceFrame.TopOverlap        = "..  FaceFrame.TopOverlap   .."   \n")
        file:write("Shelf.HoleSpacing                = "..  Shelf.HoleSpacing   .."   \n")
        file:write("Shelf.HoleFirstRowSpacing        = "..  Shelf.HoleFirstRowSpacing   .."   \n")
        file:write("Shelf.HoleLastRowSpacing         = "..  Shelf.HoleLastRowSpacing   .."   \n")
        file:write("g_BoxHight                   = "..  g_BoxHight   .."   \n")
        file:write("g_BoxLength                  = "..  g_BoxLength   .."   \n")
        file:write("g_BoxDepth                   = "..  g_BoxDepth   .."   \n")
        file:write("g_BackHight                  = "..  g_BackHight   .."   \n")
        file:write("g_BackWidth                  = "..  g_BackWidth   .."   \n")
        file:write("Shelf.PartLength                = "..  Shelf.PartLength   .."   \n")
        file:write("Shelf.PartDepth                 = "..  Shelf.PartDepth   .."   \n")
        file:write("FaceFrame.StileLength                      = "..  FaceFrame.StileLength   .."   \n")
        file:write("FaceFrame.RailLength                      = "..  FaceFrame.RailLength   .."   \n")
        file:write("FaceFrame.CenterStileLength                = "..  FaceFrame.CenterStileLength   .."   \n")
        file:write("Base.ToeKickDepth               = "..  Base.ToeKickDepth   .."   \n")
        file:write("Base.ToeKickHight               = "..  Base.ToeKickHight   .."   \n")
        file:write("Base.ToeKickBottomOffsetHight   = "..  Base.ToeKickBottomOffsetHight   .."   \n")
        file:write("Shelf.HoleSpacing           = "..  Shelf.HoleSpacing   .."   \n")
        file:write("Shelf.FaceFrameWidth   = "..  Shelf.FaceFrameWidth   .."   \n")
        file:write("Base.CabLength         = "..  Base.CabLength   .."   \n")
        file:write("Base.CabHeight         = "..  Base.CabHeight   .."   \n")
        file:write("Base.CabDepth          = "..  Base.CabDepth   .."   \n")
        file:write("Base.AddCenterPanel        = "..  Base.AddCenterPanel   .."   \n")
        file:write("Base.AddCenterFaceFrame    = "..  Base.AddCenterFaceFrame   .."   \n")
        file:write("Shelf.Count            = "..  Shelf.Count   .."   \n")
        file:write("FaceFrame.AddDrawers            = "..  FaceFrame.AddDrawers   .."   \n")
        file:write("FaceFrame.DrawerHeight          = "..  FaceFrame.DrawerHeight   .."   \n")
        file:write("FaceFrame.DrawerRowCount        = "..  FaceFrame.DrawerRowCount   .."   \n")
        file:write("FaceFrame.NumberDrawersPerRow  = "..  FaceFrame.NumberDrawersPerRow  .."   \n")
        file:write("Shelf.PinOuter              = "..  Shelf.PinOuter   .."   \n")
        file:write("Shelf.PinInter              = "..  Shelf.PinInter   .."   \n")
        file:write("Shelf.WidthClearance         = "..  Shelf.WidthClearance   .."   \n")
        file:write("FaceFrame.FFReveal      = "..  FaceFrame.FFReveal   .."   \n")
        file:write("FaceFrame.StileWidth   = "..  FaceFrame.StileWidth   .."   \n")
        file:write("FaceFrame.BottomRailWidth  = "..  FaceFrame.BottomRailWidth   .."   \n")
        file:write("FaceFrame.FFThickness    = "..  FaceFrame.FFThickness   .."   \n")
        file:write("FaceFrame.TopRailWidth     = "..  FaceFrame.TopRailWidth   .."   \n")
        file:write("FaceFrame.CenterStileWidth  = "..  FaceFrame.CenterStileWidth   .."   \n")
        file:write("FaceFrame.BottomFFReveal= "..  FaceFrame.BottomFFReveal   .."   \n")
        file:write("Shelf.HoleFirstRowSpacing= "..  Shelf.HoleFirstRowSpacing   .."   \n")
        file:write("Shelf.HoleLastRowSpacing    = "..  Shelf.HoleLastRowSpacing   .."   \n")
        file:write("Shelf.FaceFrameReveal               = "..  Shelf.FaceFrameReveal   .."   \n")
        file:write("Shelf.PinDiameter           = "..  Shelf.PinDiameter   .."   \n")
        file:write("Global.JobPath                    = "..  Global.JobPath   .."   \n")
        file:write("------------------------------------------------------------------------------")
    -- closes the open file
    file:close()
end
-- ==============================================================================
function CutListfileWriter(datFile)
    local A1 = os.date("%B %d, %Y")
    local dY = os.date("%Y")
    local dM = os.date("%m")
    local dD = os.date("%d")
    local dH = os.date("%I")
    local dMin = os.date("%M")
    local datFile = InquiryPathBox("Cabinet Maker", "Job Path", datFile)
    
    if Shelf.PartLength == 0 then
        Shelf.PartLength = (g_BoxLength - (Base.Thickness * 2) + (Shelf.EndClarence * 2))
        Shelf.PartDepth = (g_BoxDepth - (Base.ThicknessBack * 0.5))
    end
    local file = io.open(datFile .. "//CutList" .. dY .. dM .. dD .. dMin ..".dat", "w")
    -- Get the file open for writing lines to the file
        file:write("================================================================\n")
        file:write("===================== Base Cabinet Cut-list ===================\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Run Date = ".. A1 .."\n")
        file:write("Cabinet Style = ".. Global.ProgramName .."\n")
        file:write("================================================================\n")
        file:write("Base Cabinet size\n")
        file:write("Cabinet Hight       = ".. Base.CabHeight .."\n")
        file:write("Cabinet Length      = ".. Base.CabLength .."\n")
        file:write("Cabinet Depth       = ".. Base.CabDepth .."\n")
        file:write("Face Frame Diagonal = ".. math.sqrt ((Base.CabHeight * Base.CabHeight)+ (Base.CabLength * Base.CabLength)) .."\n")
        file:write("----------------------------------------------------------------\n")
        -- Shelf info
        if Base.AddBackNailer then
            file:write("Nailer Frames          - 2 pcs of ".. Base.NailerThickness .." Plywood ".. Base.NailerWidth  .." X "..  g_BackWidth .."     \n")
        end
        if Shelf.Count >= 1 then
            file:write("Shelf Face Frame       - ".. Shelf.Count .." pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. Shelf.FaceFrameThickness .." X ".. Shelf.PartLength .."     \n")
        end
        if Shelf.Count >= 1 then
            file:write("Shelf Panel            - ".. Shelf.Count .." pcs of ".. Base.Thickness .." Plywood ".. Shelf.PartDepth  .." X ".. Shelf.PartLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.TopRailWidth .." X ".. FaceFrame.RailLength .."     \n")
        file:write("Face Frame Stiles      - 2 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.StileWidth .." X ".. FaceFrame.StileLength .."     \n")
        file:write("Face Frame Bottom Rail - 1 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.BottomRailWidth .." X ".. FaceFrame.RailLength .."     \n")
        if Base.AddCenterFaceFrame then
            file:write("Face Frame Center      - 1 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.CenterStileWidth .." X ".. FaceFrame.CenterStileLength .."     \n")
        end
        if Base.AddCenterPanel then
            file:write("Center Panel           - 1 pcs of ".. Base.Thickness .." Plywood ".. (g_BoxDepth + (Base.ThicknessBack * 0.5))  .." X ".. g_BoxHight - Base.Thickness .."     \n")
        end
        file:write("Sides Panels           - 2 pcs of ".. Base.Thickness .." Plywood ".. g_BoxDepth .." X ".. g_BoxHight .."\n")
        file:write("Top and Bottom Panels  - 2 pcs of ".. Base.Thickness .." Plywood ".. g_BoxDepth .." X ".. g_BoxLength .."\n")
        file:write("Back Panel             - 1 pcs of ".. Base.ThicknessBack .." Plywood ".. g_BackHight .." X ".. g_BackWidth .."\n")
        file:write("----------------------------------------------------------------\n")
    file:close()-- closes the the door on the open file
end  -- function end
-- ==============================================================================
function BuildLine(pt1, pt2)
    local line = Contour(0.0);     -- use default tolerance
    line:AppendPoint(pt1) 
    line:LineTo(pt2) 
    return line
end  -- function end
-- ==============================================================================
function BuildBox(pt1, xx, yy)
    local line = Contour(0.0);     -- use default tolerance
    line:AppendPoint(pt1) 
    line:LineTo(Polar2D(pt1, 0, xx)) 
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) 
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) 
    line:LineTo(pt1) 
    return line
end -- function end
-- ==============================================================================
function BuildCircle(pt1, rad)
    local line = Contour(0.0)
    -- DisplayMessageBox(tostring(rad))
    line:AppendPoint(Polar2D(pt1, 0, rad))    
    line:ArcTo(Polar2D(pt1, 180, rad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, rad), 1.0)
    return line
end -- function end
-- ==============================================================================
function DrawWriter(what, where, size, lay)
    local strlen = string.len(what)
    local strup = string.upper(what)
    local x = strlen
    local i = 1
    local y = ""
    local ptx = where
    while i <= x do
      y =  string.byte(string.sub(strup, i, i))
      ptx = CADLeters(ptx, y , size, lay)
      i = i + 1
    end
end  -- function end
-- ==============================================================================
function fileWriter(datFile) -- Not used - Writes values a InI style file
    local file = io.open(datFile, "w")
    -- write line of the file
    file:write("#======================================================================\n")
    file:write("# Standard Base Cabinet Configuration File \n")
    file:write("#======================================================================\n")
    file:write("[Defalt]\n")
    file:write("Base.ThicknessBack="..          Base.ThicknessBack   .."   \n")
    file:write("Base.Thickness="..              Base.Thickness   .."   \n")
    file:write("Base.CabLength="..              Base.CabLength   .."   \n")
    file:write("Base.CabHeight="..              Base.CabHeight   .."   \n")
    file:write("Base.CabDepth="..               Base.CabDepth   .."   \n")
    file:write("Base.DatoSetback="..            Base.DatoSetback   .."   \n")
    file:write("Base.DatoDeep="..               Base.DatoDeep   .."   \n")
    file:write("Base.DatoType="..               Base.DatoType   .."   \n")
    file:write("Base.AddFaceFrame="..           BtoS(Base.AddFaceFrame)   .."   \n")
    file:write("Base.AddShelf="..               BtoS(Base.AddShelf)   .."   \n")
    file:write("Base.AddCenterFaceFrame="..     BtoS(Base.AddCenterFaceFrame)   .."   \n")
    file:write("Base.AddCenterPanel="..         BtoS(Base.AddCenterPanel)   .."   \n")
    file:write("Base.AddBackNailer="..          BtoS(Base.AddBackNailer)   .."   \n")
    file:write("Base.NailerThickness="..        Base.NailerThickness   .."   \n")
    file:write("Base.NailerWidth="..            Base.NailerWidth   .."   \n")        
    file:write("Shelf.EndClarence="..           Shelf.EndClarence   .."   \n")
    file:write("Shelf.PinDiameter="..           Shelf.PinDiameter   .."   \n")
    file:write("Shelf.PinRadus="..              Shelf.PinRadus   .."   \n")
    file:write("Shelf.Count="..                 Shelf.Count   .."   \n")
    file:write("Shelf.FaceFrameReveal="..       Shelf.FaceFrameReveal   .."   \n")
    file:write("Shelf.WidthClearance="..        Shelf.WidthClearance   .."   \n")
    file:write("Shelf.FaceFrameWidth="..        Shelf.FaceFrameWidth   .."   \n")
    file:write("Shelf.FaceFrameThickness="..    Shelf.FaceFrameThickness   .."   \n")
    file:write("Shelf.PinOuter="..              Shelf.PinOuter   .."   \n")
    file:write("Shelf.PinInter="..              Shelf.PinInter   .."   \n")
    file:write("Shelf.HoleSpacing="..           Shelf.HoleSpacing   .."   \n")
    file:write("Shelf.HoleFirstRowSpacing="..   Shelf.HoleFirstRowSpacing   .."   \n")
    file:write("Shelf.HoleLastRowSpacing="..    Shelf.HoleLastRowSpacing   .."   \n")
    file:write("Shelf.PartLength="..            Shelf.PartLength   .."   \n")
    file:write("Shelf.PartDepth="..             Shelf.PartDepth   .."   \n")
    file:write("Shelf.PartThickness="..         Shelf.PartThickness   .."   \n")        
    file:write("Milling.MillClearnace="..       Milling.MillClearnace .."   \n")
    file:write("Milling.ToolSizeDia="..         Milling.ToolSizeDia .."   \n")
    file:write("Milling.ToolSizeRadus="..       Milling.ToolSizeRadus .."   \n")
    file:write("Milling.RabbitClearnace="..     Milling.RabbitClearnace .."   \n")
    file:write("Global.ProgramTitle="..         Global.ProgramTitle   .."   \n")
    file:write("Global.ProgramVersion="..       Global.ProgramVersion   .."   \n")
    file:write("Global.CodeBy="..               Global.CodeBy   .."   \n")
    file:write("Global.JobPath="..              Global.JobPath   .."   \n")
    file:write("Global.ProgramName="..          Global.ProgramName   .."   \n")
    file:write("Global.Contact="..              Global.Contact   .."   \n")
    file:write("Global.Year="..                 Global.Year   .."   \n")
    file:write("Drawing.DrawFaceFrame="..       BtoS(Drawing.DrawFaceFrame)   .."   \n")
    file:write("Drawing.DrawBack="..            BtoS(Drawing.DrawBack)   .."   \n")
    file:write("Drawing.DrawSideR="..           BtoS(Drawing.DrawSideR)   .."   \n")
    file:write("Drawing.DrawSideL="..           BtoS(Drawing.DrawSideL)   .."   \n")
    file:write("Drawing.DrawTop="..             BtoS(Drawing.DrawTop)   .."   \n")
    file:write("Drawing.DrawBottom="..          BtoS(Drawing.DrawBottom)   .."   \n")
    file:write("Drawing.DrawCenter="..          BtoS(Drawing.DrawCenter)   .."   \n")
    file:write("Drawing.DrawNotes="..           BtoS(Drawing.DrawNotes)   .."   \n")
    file:write("Drawing.DrawShelf="..           BtoS(Drawing.DrawShelf)   .."   \n")
    file:write("FaceFrame.FFReveal="..          FaceFrame.FFReveal   .."   \n")
    file:write("FaceFrame.FFThickness="..       FaceFrame.FFThickness   .."   \n")
    file:write("FaceFrame.StileWidth="..        FaceFrame.StileWidth   .."   \n")
    file:write("FaceFrame.BottomRailWidth="..   FaceFrame.BottomRailWidth   .."   \n")
    file:write("FaceFrame.TopRailWidth="..      FaceFrame.TopRailWidth   .."   \n")
    file:write("FaceFrame.CenterStileWidth="..  FaceFrame.CenterStileWidth   .."   \n")
    file:write("FaceFrame.BottomFFReveal="..    FaceFrame.BottomFFReveal   .."   \n")
    file:write("FaceFrame.TopOverlap="..        FaceFrame.TopOverlap   .."   \n")
    file:write("FaceFrame.StileLength="..       FaceFrame.StileLength   .."   \n")
    file:write("FaceFrame.RailLength="..        FaceFrame.RailLength   .."   \n")
    file:write("FaceFrame.CenterStileLength=".. FaceFrame.CenterStileLength   .."   \n")
    file:write("Variables.g_BoxHight="..  g_BoxHight .."   \n")
    file:write("Variables.g_BoxLength=".. g_BoxLength  .."   \n")
    file:write("Variables.g_BoxDepth="..  g_BoxDepth .."   \n")
    file:write("Variables.g_BackHight=".. g_BackHight  .."   \n")
    file:write("Variables.g_BackWidth=".. g_BackWidth  .."   \n")
    file:close()-- closes the open file
      return true
end
-- ==============================================================================
function Polar2D(pt, ang, dis)
  local y_ = dis * math.sin(math.rad(ang))
  local x_ = dis * math.cos(math.rad(ang))
  return Point2D((pt.X + x_), (pt.Y + y_))
end  -- function end
-- ==============================================================================
function Holer(pt, ang, dst, dia, lay)

    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local group = ContourGroup(true)
    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   
    pt = Polar2D(pt, ang, dst)
    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   
    AddGroupToJob(job, group, lay)        
    job:Refresh2DView()
    return true   
end
-- ==============================================================================
function CADLeters(pt, letter, scl, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    scl = (scl * 0.5)
    local pA0 = pt ; local pA1 = Polar2D(pt, 90.0000, (0.2500 * scl)) ; local pA2 = Polar2D(pt, 90.0000, (0.5000 * scl)) ; local pA3 = Polar2D(pt, 90.0000, (0.7500 * scl)) ; local pA4 = Polar2D(pt, 90.0000, (1.0000 * scl)) ; local pA5 = Polar2D(pt, 90.0000, (1.2500 * scl)) ; local pA6 = Polar2D(pt, 90.0000, (1.5000 * scl)) ; local pA7 = Polar2D(pt, 90.0000, (1.7500 * scl)) ; local pA8 = Polar2D(pt, 90.0000, (2.0000 * scl))
    local pB0 = Polar2D(pt,  0.0000, (0.2500 * scl)) ; local pB1 = Polar2D(pt, 45.0000, (0.3536 * scl)) ; local pB3 = Polar2D(pt, 71.5651, (0.7906 * scl)) ; local pB4 = Polar2D(pt, 75.9638, (1.0308 * scl)) ; local pB5 = Polar2D(pt, 78.6901, (1.2748 * scl)) ; local pB7 = Polar2D(pt, 81.8699, (1.7678 * scl)) ; local pB8 = Polar2D(pt, 82.8750, (2.0156 * scl)) ; local pB10 = Polar2D(pt, 84.2894, (2.5125 * scl)) 
    local pC0 = Polar2D(pt,  0.0000, (0.5000 * scl)) ; local pC2 = Polar2D(pt, 45.0000, (0.7071 * scl)) ; local pC8 = Polar2D(pt, 75.9638, (2.0616 * scl)) ; local pC10 = Polar2D(pt,78.6901, (2.5125 * scl)) ; local pD0 = Polar2D(pt,  0.0000, (0.6250 * scl)) ; local pD1 = Polar2D(pt, 21.8014, (0.6731 * scl)) ; local pD4 = Polar2D(pt, 57.9946, (1.1792 * scl)) ; local pD7 = Polar2D(pt, 70.3462, (1.8583 * scl))
    local pD8 = Polar2D(pt, 72.6460, (2.0954 * scl)) ; local pE0 = Polar2D(pt,  0.0000, (0.7500 * scl)) ; local pE2 = Polar2D(pt, 33.6901, (0.9014 * scl)) ; local pE3 = Polar2D(pt, 45.0000, (1.0607 * scl)) ; local pE8 = Polar2D(pt, 69.4440, (2.1360 * scl)) ; local pF0 = Polar2D(pt,  0.0000, (1.0000 * scl)) ; local pF3 = Polar2D(pt, 36.8699, (1.2500 * scl)) ; local pF4 = Polar2D(pt, 45.0000, (1.4142 * scl))
    local pF7 = Polar2D(pt, 60.2551, (2.0156 * scl)) ; local pF8 = Polar2D(pt, 63.4349, (2.2361 * scl)) ; local pF10 = Polar2D(pt,59.0362, (2.9155 * scl)) ; local pG0 = Polar2D(pt,  0.0000, (1.2500 * scl)) ; local pG1 = Polar2D(pt, 11.3099, (1.2748 * scl)) ; local pG2 = Polar2D(pt, 21.8014, (1.3463 * scl)) ; local pG3 = Polar2D(pt, 30.9638, (1.4577 * scl)) ; local pG4 = Polar2D(pt, 38.6598, (1.6008 * scl))
    local pG5 = Polar2D(pt, 45.0000, (1.7678 * scl)) ; local pG6 = Polar2D(pt, 50.1944, (1.9526 * scl)) ; local pG7 = Polar2D(pt, 54.4623, (2.1506 * scl)) ; local pG8 = Polar2D(pt, 57.9946, (2.3585 * scl)) ; local pH0 = Polar2D(pt,  0.0000, (1.5000 * scl)) ; local pH10 = Polar2D(pt,63.4349, (2.7951 * scl))
    local group = ContourGroup(true)
    local layer = job.LayerManager:GetLayerWithName(lay)
    local line = Contour(0.0) 
    if letter == 65 then  
        line:AppendPoint(pA0) 
        line:LineTo(pD8) ;         
        line:LineTo(pG0)         
        layer:AddObject(CreateCadContour(line), true)          
        line = Contour(0.0)          
        line:AppendPoint(pB3)          
        line:LineTo(pF3)          
        layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 66 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 67 then ; 
        line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 68 then ; 
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 69 then ; 
        line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 70 then ; 
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 71 then ; 
        line:AppendPoint(pG6) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 72 then ; 
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 73 then ; 
        line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end
    if letter == 74 then
        line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 75 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 76 then
        line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 77 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 78 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end
    if letter == 79 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 80 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 81 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 82 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 83 then
        line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)    
    end  
    if letter == 84 then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 85 then
        line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 86 then
        line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 87 then
        line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end     
    if letter == 88 then
        line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 89 then
        line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 90 then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 48 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 49 then
        line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 50 then
        line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 51 then
        line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 52 then
        line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 53 then
        line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 54 then
        line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 55 then
        line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 56 then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ; 
    end   
    if letter == 57 then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 47 then
        line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 43 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 61 then
        line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 45 then
       line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 39 then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0 
    end   
    if letter == 34 then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end   
    if letter == 40 then
        line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end   
    if letter == 41 then
        line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 60 then
        line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 62 then
        line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 95 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 58 then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 46 then
        line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 59 then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
     if letter == 35 then
         line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) 
    end    
    if letter == 32 then
        pH0 = pH0 
    end   
    if letter == 33 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 36 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 37 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 38 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 42 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 63 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 64 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 91 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 92 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 93 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 94 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 96 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 123 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 124 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 125 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 126 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    return pH0  
end
-- ==============================================================================
function CutListfileWriter(datFile)
    local A1 = os.date("%B %d, %Y")
    local dY = os.date("%Y")
    local dM = os.date("%m")
    local dD = os.date("%d")
    local dH = os.date("%I")
    local dMin = os.date("%M")
    if Shelf.PartLength == 0 then
        Shelf.PartLength = (g_BoxLength - (Base.Thickness * 2) + (Shelf.EndClarence * 2))
        Shelf.PartDepth = (g_BoxDepth - (Base.ThicknessBack * 0.5))
    end
    local file = io.open(datFile .. "//CutList" .. dY .. dM .. dD .. dMin ..".dat", "w")
    -- Get the file open for writing lines to the file
        file:write("================================================================\n")
        file:write("===================== Lower Cabinet Cut-list ===================\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Run Date = ".. A1 .."\n")
        file:write("================================================================\n")
        file:write("Wall Cabinet size\n")
        file:write("Cabinet Hight       = ".. Base.CabHeight .."\n")
        file:write("Cabinet Lenght      = ".. Base.CabLength .."\n")
        file:write("Cabinet Depth       = ".. Base.CabDepth .."\n")
        file:write("Face Frame Diagonal = ".. math.sqrt ((Base.CabHeight * Base.CabHeight)+ (Base.CabLength * Base.CabLength)) .."\n")
        file:write("----------------------------------------------------------------\n")
        -- Shelf info

        if Shelf.Count >= 1 then
            file:write("Face Frame Shelf       - ".. Shelf.Count .." pcs of ".. FaceFrame.FFThickness .." Hardwood ".. Shelf.FaceFrameWidth .." X ".. Shelf.PartLength .."     \n")
        end
        if Shelf.Count >= 1 then
            file:write("Shelf Panel            - ".. Shelf.Count .." pcs of ".. Base.Thickness .." Plywood ".. Shelf.PartDepth  .." X ".. Shelf.PartLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.TopRailWidth .." X ".. FaceFrame.RailLength .."     \n")
        file:write("Face Frame Stiles      - 2 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.StileWidth .." X ".. FaceFrame.StileLength .."     \n")
        file:write("Face Frame Bottom Rail - 1 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.BottomRailWidth.." X ".. FaceFrame.RailLength .."     \n")
        if Base.AddCenterFaceFrame then
            file:write("Face Frame Center      - 1 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.CenterStileWidth .." X ".. FaceFrame.CenterStileLength .."     \n")
        end
        if Base.AddCenterPanel then
            file:write("Center Panel           - 1 pcs of ".. Base.Thickness .." Plywood ".. (g_BoxDepth + (Base.ThicknessBack * 0.5))  .." X ".. g_BoxHight - Base.Thickness .."     \n")
        end
        file:write("Sides Panels           - 2 pcs of ".. Base.Thickness .." Plywood ".. g_BoxDepth .." X ".. g_BoxHight .."\n")
        file:write("Top and Bottom Panels  - 2 pcs of ".. Base.Thickness .." Plywood ".. g_BoxDepth .." X ".. g_BoxLength .."\n")
        file:write("Back Panel             - 1 pcs of ".. Base.ThicknessBack .." Plywood ".. g_BackHight .." X ".. g_BackWidth .."\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Base Cabinet size\n")
        file:write("Cabinet Hight               = ".. Base.CabHeight .."\n")
        file:write("Cabinet Length              = ".. Base.CabLength .."\n")
        file:write("Cabinet Depth               = ".. Base.CabDepth .."\n")
        file:write("Cabinet Face Frame Diagonal = ".. math.sqrt ((FaceFrame.StileLength * FaceFrame.StileLength)+ (Base.CabLength * Base.CabLength)) .."\n")
        file:write("Cabinet Back Diagonal       = ".. math.sqrt ((Base.CabHeight * Base.CabHeight)+ (Base.CabLength * Base.CabLength)) .."\n")
        file:write("----------------------------------------------------------------\n")
        if Shelf.Count >= 1 then
            file:write("Face Frame Shelf       - ".. Shelf.Count .." pcs of ".. FaceFrame.FFThickness .." Hardwood ".. Shelf.FaceFrameWidth .." X ".. Shelf.PartLength .."     \n")
        end
        if Shelf.Count >= 1 then
            file:write("Shelf Panel            - ".. Shelf.Count .." pcs of ".. Base.Thickness .." Plywood ".. Shelf.PartDepth  .." X ".. Shelf.PartLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.TopRailWidth .." X ".. FaceFrame.RailLength .."     \n")
        file:write("Face Frame Stiles      - 2 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.StileWidth .." X ".. FaceFrame.StileLength .."     \n")
        file:write("Face Frame Bottom Rail - 1 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.BottomRailWidth.." X ".. FaceFrame.RailLength .."     \n")
        if FaceFrame.AddDrawers then
            file:write("Drawer Rails           - "..  FaceFrame.DrawerRowCount  .." pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.TopRailWidth .." X ".. FaceFrame.StileLength .."     \n")
            if FaceFrame.NumberDrawersPerRow>= 2 then
                file:write("Drawer Center Rails    - " .. FaceFrame.DrawerRowCount .." pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.TopRailWidth .." X ".. FaceFrame.DrawerHeight .."     \n")
            end
        end
       
        if Base.AddCenterFaceFrame then
            file:write("Face Frame Center      - 1 pcs of ".. FaceFrame.FFThickness .." Hardwood ".. FaceFrame.CenterStileWidth .." X ".. Base.AddCenterFaceFrameLen .."     \n")
        end
        if Base.AddCenterPanel then
            file:write("Center Panel           - 1 pcs of ".. Base.Thickness .." Plywood ".. Base.CenterPanelHight  .." X ".. Base.CenterPanelDepth .."     \n")
        end
        file:write("Sides Panels           - 2 pcs of ".. Base.Thickness .." Plywood ".. g_BoxDepth .." X ".. g_BoxHight .."\n")
        file:write("Bottom Panel           - 1 pcs of ".. Base.Thickness .." Plywood ".. g_BoxDepth .." X ".. g_BoxLength - Base.Thickness .."\n")
        file:write("Back Panel             - 1 pcs of ".. Base.ThicknessBack .." Plywood ".. g_BackHight .." X ".. g_BackWidth .."\n")
        file:write("Toe Kick Panel         - 1 Pcs of ".. Base.Thickness .. " Plywood " .. Base.ToeKickCoverHight .. " X " .. g_BoxLength - Base.Thickness .."\n")
        file:write("----------------------------------------------------------------\n")
        file:write("\n")
        file:write("================================================================\n")
        file:write("============== Job Data Values Cabinet Maker 2018 ==============\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Milling.MillClearnace         = "..  Milling.MillClearnace      .."   \n")
        file:write("Shelf.EndClarence            = "..  Shelf.EndClarence   .."   \n")
        file:write("Shelf.PinDiameter            = "..  Shelf.PinDiameter   .."   \n")
        file:write("Shelf.Count                  = "..  Shelf.Count   .."   \n")
        file:write("Shelf.FaceFrameWidth         = "..  Shelf.FaceFrameWidth   .."   \n")
        file:write("Shelf.WidthClearance         = "..  Shelf.WidthClearance   .."   \n")
        file:write("Base.ThicknessBack       = "..  Base.ThicknessBack   .."   \n")
        file:write("Base.Thickness           = "..  Base.Thickness   .."   \n")
        file:write("Milling.RabbitClearnace                  = "..  Milling.RabbitClearnace   .."   \n")
        file:write("Global.ProgramTitle                = "..  Global.ProgramTitle   .."   \n")
        file:write("Global.ProgramVersion              = "..  Global.ProgramVersion   .."   \n")
        file:write("Global.CodeBy                      = "..  Global.CodeBy   .."   \n")
        file:write("Milling.ToolSizeDia                 = "..  Milling.ToolSizeDia   .."   \n")
        file:write("Milling.ToolSizeRadus               = "..  Milling.ToolSizeRadus   .."   \n")
        file:write("Base.DatoDeep                    = "..  Base.DatoDeep   .."   \n")
        file:write("Shelf.PinRadus                    = "..  Shelf.PinRadus   .."   \n")
        file:write("Base.CabLength          = "..  Base.CabLength   .."   \n")
        file:write("Base.CabHeight          = "..  Base.CabHeight   .."   \n")
        file:write("Base.CabDepth           = "..  Base.CabDepth   .."   \n")
        file:write("Shelf.PinOuter                    = "..  Shelf.PinOuter   .."   \n")
        file:write("Shelf.PinInter                    = "..  Shelf.PinInter   .."   \n")
        file:write("FaceFrame.StileWidth            = "..  FaceFrame.StileWidth   .."   \n")
        file:write("FaceFrame.StileWidth          = "..  FaceFrame.StileWidth   .."   \n")
        file:write("FaceFrame.BottomRailWidth       = "..  FaceFrame.BottomRailWidth  .."   \n")
        file:write("FaceFrame.FFThickness          = "..  FaceFrame.FFThickness   .."   \n")
        file:write("FaceFrame.TopRailWidth           = "..  FaceFrame.TopRailWidth   .."   \n")
        file:write("FaceFrame.CenterStileWidth        = "..  FaceFrame.CenterStileWidth   .."   \n")
        file:write("Base.AddCenterFaceFrame             = "..  Base.AddCenterFaceFrame   .."   \n")
        file:write("Base.AddCenterPanel                 = "..  Base.AddCenterPanel   .."   \n")
        file:write("FaceFrame.BottomFFReveal      = "..  FaceFrame.BottomFFReveal   .."   \n")
        file:write("FaceFrame.TopOverlap         = "..  FaceFrame.TopOverlap   .."   \n")
        file:write("Shelf.HoleSpacing                 = "..  Shelf.HoleSpacing   .."   \n")
        file:write("Shelf.HoleFirstRowSpacing         = "..  Shelf.HoleFirstRowSpacing   .."   \n")
        file:write("Shelf.HoleLastRowSpacing          = "..  Shelf.HoleLastRowSpacing   .."   \n")
        file:write("g_BoxHight                    = "..  g_BoxHight   .."   \n")
        file:write("g_BoxLength                   = "..  g_BoxLength   .."   \n")
        file:write("g_BoxDepth                    = "..  g_BoxDepth   .."   \n")
        file:write("g_BackHight                   = "..  g_BackHight   .."   \n")
        file:write("g_BackWidth                   = "..  g_BackWidth   .."   \n")
        file:write("Shelf.PartLength                 = "..  Shelf.PartLength   .."   \n")
        file:write("Shelf.PartDepth                  = "..  Shelf.PartDepth   .."   \n")
        file:write("FaceFrame.DrawerFrameWidth          = "..  FaceFrame.DrawerFrameWidth   .."   \n")
        file:write("FaceFrame.StileLength                       = "..  FaceFrame.StileLength   .."   \n")
        file:write("FaceFrame.RailLength                       = "..  FaceFrame.RailLength   .."   \n")
        file:write("FaceFrame.CenterStileLength                 = "..  FaceFrame.CenterStileLength   .."   \n")
        file:write("Base.ToeKickDepth                = "..  Base.ToeKickDepth   .."   \n")
        file:write("Base.ToeKickHight                = "..  Base.ToeKickHight   .."   \n")
        file:write("Base.ToeKickBottomOffsetHight    = "..  Base.ToeKickBottomOffsetHight   .."   \n")
        file:write("Shelf.HoleSpacing            = "..  Shelf.HoleSpacing   .."   \n")
        file:write("Shelf.FaceFrameWidth    = "..  Shelf.FaceFrameWidth   .."   \n")
        file:write("Base.CabLength          = "..  Base.CabLength   .."   \n")
        file:write("Base.CabHeight          = "..  Base.CabHeight   .."   \n")
        file:write("Base.CabDepth           = "..  Base.CabDepth   .."   \n")
        file:write("Base.AddCenterPanel         = "..  Base.AddCenterPanel   .."   \n")
        file:write("Base.AddCenterFaceFrame     = "..  Base.AddCenterFaceFrame   .."   \n")
        file:write("Shelf.Count             = "..  Shelf.Count   .."   \n")
        file:write("FaceFrame.AddDrawers             = "..  FaceFrame.AddDrawers   .."   \n")
        file:write("FaceFrame.DrawerHeight           = "..  FaceFrame.DrawerHeight   .."   \n")
        file:write("FaceFrame.DrawerRowCount         = "..  FaceFrame.DrawerRowCount   .."   \n")

        file:write("FaceFrame.NumberDrawersPerRow   = "..  FaceFrame.NumberDrawersPerRow  .."   \n")
        file:write("Shelf.PinOuter               = "..  Shelf.PinOuter   .."   \n")
        file:write("Shelf.PinInter               = "..  Shelf.PinInter   .."   \n")
        file:write("Shelf.WidthClearance          = "..  Shelf.WidthClearance   .."   \n")
        file:write("FaceFrame.FFReveal       = "..  FaceFrame.FFReveal   .."   \n")
        file:write("FaceFrame.StileWidth    = "..  FaceFrame.StileWidth   .."   \n")
        file:write("FaceFrame.BottomRailWidth   = "..  FaceFrame.BottomRailWidth   .."   \n")
        file:write("FaceFrame.FFThickness     = "..  FaceFrame.FFThickness   .."   \n")
        file:write("FaceFrame.TopRailWidth      = "..  FaceFrame.TopRailWidth   .."   \n")
        file:write("FaceFrame.CenterStileWidth   = "..  FaceFrame.CenterStileWidth   .."   \n")
        file:write("FaceFrame.BottomFFReveal = "..  FaceFrame.BottomFFReveal   .."   \n")
        file:write("Shelf.HoleFirstRowSpacing = "..  Shelf.HoleFirstRowSpacing   .."   \n")
        file:write("Shelf.HoleLastRowSpacing     = "..  Shelf.HoleLastRowSpacing   .."   \n")
        file:write("Shelf.FaceFrameReveal                = "..  Shelf.FaceFrameReveal   .."   \n")
        file:write("Shelf.PinDiameter            = "..  Shelf.PinDiameter   .."   \n")
        file:write("Global.JobPath                     = "..  Global.JobPath   .."   \n")
        file:write("-----------------------------END-------------------------------")
 -- closes the the door on the open file
    file:close()
end
-- ==============================================================================
function DrawWriter(what, where, size, lay)
    local strlen = string.len(what)
    local strup = string.upper(what)
    local x = strlen
    local i = 1
    local y = ""
    local ptx = where
    while i <= x do
      y =  string.byte(string.sub(strup, i, i))
      ptx = CADLeters(ptx, y , size, lay)
      i = i + 1
    end
end
-- ==============================================================================
function LowerCabinetBottom(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local BD = g_BoxDepth - Base.ThicknessBack
    local BL = g_BoxLength - Base.Thickness
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, BD)
    local ptC = Polar2D(g_pt1, 90, (BL * 0.5))
    local pt3 = Polar2D(pt2, 90,  BL)
    local pt4 = Polar2D(pt3, 180, BD)
    local ptW = g_pt1
    local ptX = g_pt1
    local ptY = g_pt1
    local ptZ = g_pt1
    ptW = Polar2D(ptC, 270,   ((Base.Thickness + Milling.RabbitClearnace) * 0.5))
    ptW = Polar2D(ptW, 180,   Milling.ToolSizeRadus)
    ptX = Polar2D(ptW, 90,    (Base.Thickness + Milling.RabbitClearnace))
    ptY = Polar2D(ptX, 0,     BD + (Milling.ToolSizeRadus * 2))
    ptZ = Polar2D(ptW, 0,     BD + (Milling.ToolSizeRadus * 2))
    local line = Contour(0.0)
    if Base.AddCenterPanel then
        line:AppendPoint(ptW) 
        line:LineTo(ptX)
        line:LineTo(ptY)
        line:LineTo(ptZ)
        line:LineTo(ptW)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
    end
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    
    local pt1Text = Polar2D(g_pt1, 45,  4)
    DrawWriter("Cabinet Bottom - ".. Base.ThicknessBack .." Plywood", pt1Text, 0.5, lay)
    return true   
end
-- ==============================================================================
function LowerCabinetFaceFrame(lay)   
    local job = VectricJob()
    local Dist = 0.0
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
--    FaceFrame.StileLength = ((Base.CabHeight - Base.ToeKickHight - FaceFrame.BottomFFReveal - Base.Thickness - Base.ToeKickBottomOffsetHight) + FaceFrame.BottomRailWidth)
    FaceFrame.StileLength = (Base.CabHeight - Base.ToeKickHight)
    FaceFrame.RailLength = Base.CabLength - (FaceFrame.StileWidth * 2)
-- Draw outer frame box  
    local pt2 = Polar2D(g_pt1, 0,  FaceFrame.StileLength)
    local pt3 = Polar2D(pt2,  90,  Base.CabLength)
    local pt4 = Polar2D(pt3, 180,  FaceFrame.StileLength)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    
-- Draw Stile Lines 
    local A1 = Polar2D(g_pt1, 90,  FaceFrame.StileWidth)
    local B1 = Polar2D(pt2,   90,  FaceFrame.StileWidth)
    local C1 = Polar2D(pt3,  270,  FaceFrame.StileWidth)
    local D1 = Polar2D(pt4,  270,  FaceFrame.StileWidth)
    line = Contour(0.0)
    line:AppendPoint(A1) 
    line:LineTo(B1)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(C1) 
    line:LineTo(D1)
    layer:AddObject(CreateCadContour(line), true)
-- Draw the Top and Bottom rails    
    local A2 = Polar2D(A1,   0,   FaceFrame.TopRailWidth)
    local B2 = Polar2D(B1, 180,   FaceFrame.BottomRailWidth)
    local C2 = Polar2D(C1, 180,   FaceFrame.BottomRailWidth)
    local D2 = Polar2D(D1,   0,   FaceFrame.TopRailWidth)
    line = Contour(0.0)
    line:AppendPoint(A2) 
    line:LineTo(D2)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(B2)
    line:LineTo(C2)
    layer:AddObject(CreateCadContour(line), true)
    


    if FaceFrame.AddDrawers then
        
        local DrawerRowCountX = FaceFrame.DrawerRowCount

        while DrawerRowCountX >= 1 do
            A2 = Polar2D(A2,  0,   FaceFrame.DrawerHeight)
            D2 = Polar2D(D2,  0,   FaceFrame.DrawerHeight)
            line = Contour(0.0)
            line:AppendPoint(A2) 
            line:LineTo(D2)
            layer:AddObject(CreateCadContour(line), true)
            if FaceFrame.NumberDrawersPerRow>=2 then
                Dist = ((Base.CabLength * 0.5) - (FaceFrame.StileWidth + (FaceFrame.CenterStileWidth * 0.5) ))
                local B2 = Polar2D(A2,  90,   Dist)
                local C2 = Polar2D(D2, 270,   Dist)
                line = Contour(0.0)
                line:AppendPoint(B2) 
                line:LineTo(Polar2D(B2, 180, FaceFrame.DrawerHeight))
                layer:AddObject(CreateCadContour(line), true)
                line = Contour(0.0)
                line:AppendPoint(C2)
                line:LineTo(Polar2D(C2, 180, FaceFrame.DrawerHeight))
                layer:AddObject(CreateCadContour(line), true)
            end
            A2 = Polar2D(A2,  0,   FaceFrame.TopRailWidth)
            D2 = Polar2D(D2,  0,   FaceFrame.TopRailWidth)
            line = Contour(0.0)
            line:AppendPoint(A2) 
            line:LineTo(D2)
            layer:AddObject(CreateCadContour(line), true)
            DrawerRowCountX = DrawerRowCountX -1
        end
    end
    if Base.AddCenterFaceFrame then
        Dist = ((Base.CabLength * 0.5) - (FaceFrame.StileWidth + (FaceFrame.CenterStileWidth * 0.5) ))
        local A3 = Polar2D(A2, 90,   Dist)
        local B3 = Polar2D(B2, 90,  Dist)
        local C3 = Polar2D(C2, 270,  Dist)
        local D3 = Polar2D(D2, 270,   Dist)
        line = Contour(0.0)
        line:AppendPoint(A3) 
        line:LineTo(B3)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
        line:AppendPoint(D3)
        line:LineTo(C3)
        layer:AddObject(CreateCadContour(line), true)
    end
    
    FaceFrame.StileLength = Base.CabHeight
    FaceFrame.RailLength = Base.CabLength - (FaceFrame.StileWidth * 2.0)
    FaceFrame.CenterStileLength = Base.CabHeight - (FaceFrame.BottomRailWidth + FaceFrame.TopRailWidth) 
    
    local pt1Text = Polar2D(g_pt1, 0,  4)
    local pt1Text = Polar2D(pt1Text, 90,  ((Base.CabLength * 0.5) + 8))
    DrawWriter(Global.ProgramTitle, pt1Text, 0.750, lay)
        pt1Text = Polar2D(pt1Text, 270, 1)
    DrawWriter("Version: " .. Global.ProgramVersion, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("By: " .. Global.CodeBy, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("= Stiles and FaceFrame.RailLength Cut list =", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Stiles: 2 pcs " .. tostring(FaceFrame.FFThickness)  .. " x " .. tostring(FaceFrame.StileWidth) .. " - " .. FaceFrame.StileLength .. "'' long", pt1Text, 0.5, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Top Rile: 1 pcs " .. tostring(FaceFrame.FFThickness)  .. " x " .. tostring(FaceFrame.TopRailWidth) .. " - " .. FaceFrame.RailLength .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Bottom Rail: 1 pcs " .. tostring(FaceFrame.FFThickness)  .. " x " .. tostring(FaceFrame.BottomRailWidth) .. " - " .. FaceFrame.RailLength .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Pull a ruller twice and cut cut and cut some more :)", pt1Text, 0.50, lay)
    if Base.AddCenterFaceFrame then
        pt1Text = Polar2D(pt1Text, 270, 0.75)
        DrawWriter("Center Stile: 1 pcs " .. tostring(FaceFrame.FFThickness)  .. " x " .. FaceFrame.CenterStileWidth .. " - " .. FaceFrame.CenterStileLength .. " long", pt1Text, 0.50, lay) 
    end
  return true   
end
-- ==============================================================================
function LowerCabinetShelf(lay, CountX)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local LSL = (g_BoxLength - (Base.Thickness * 2) + (Shelf.EndClarence * 2))
    local LSD = g_BoxDepth - (Base.ThicknessBack + FaceFrame.FFThickness + Shelf.WidthClearance)
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0,  LSL)
    local pt3 = Polar2D(pt2, 90,  LSD)
    local pt4 = Polar2D(pt3, 180, LSL)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    local pt1Text = Polar2D(Polar2D(g_pt1, 0,  3), 90,  (LSD / 2))
    DrawWriter("Cabinet Shelf".. CountX .." - ".. Base.Thickness .." Plywood", pt1Text, 0.5, lay)
  return true   
end
-- ==============================================================================
function LowerCabinetBack(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, g_BoxDepth)
    local ptC = Polar2D(g_pt1, 90, ((g_BoxLength - Base.Thickness) * 0.5))
    local pt3 = Polar2D(pt2, 90,  g_BoxLength - Base.Thickness)
    local pt4 = Polar2D(pt3, 180, g_BoxDepth)
    local ptW = g_pt1
    local ptX = g_pt1
    local ptY = g_pt1
    local ptZ = g_pt1
    ptW = Polar2D(ptC, 270,   ((Base.Thickness + Milling.RabbitClearnace) * 0.5))
    ptW = Polar2D(ptW, 180,   Milling.ToolSizeRadus)
    ptX = Polar2D(ptW, 90,    (Base.Thickness + Milling.RabbitClearnace))
    ptY = Polar2D(ptX, 0,     g_BoxDepth + (Milling.ToolSizeRadus * 2))
    ptZ = Polar2D(ptW, 0,     g_BoxDepth + (Milling.ToolSizeRadus * 2))
    local line = Contour(0.0)
    if Base.AddCenterPanel then
        line:AppendPoint(ptW) 
        line:LineTo(ptX)
        line:LineTo(ptY)
        line:LineTo(ptZ)
        line:LineTo(ptW)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
    end
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    
    local pt1Text = Polar2D(g_pt1, 45,  4)
    DrawWriter("Cabinet Back - ".. Base.ThicknessBack .." Plywood", pt1Text, 0.5, lay)
    return true   
end
-- ==============================================================================
function LowerCabinetSide(side, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local ptA = g_pt1 ; local ptB = g_pt1 ; local ptL = g_pt1 ; local ptK = g_pt1 ; local ptG = g_pt1 ; local ptH = g_pt1 ;
    local ptI = g_pt1 ; local ptJ = g_pt1 ; local ptD = g_pt1 ; local ptC = g_pt1 ; local ptE = g_pt1 ; local ptF = g_pt1 ;
    local ptG = g_pt1 ; local ptH = g_pt1 ; local ptI = g_pt1 ; local ptJ = g_pt1 ; local ptJA = g_pt1 ; local ptJB = g_pt1 ;
    local ptJC = g_pt1 ; local ptK = g_pt1 ; local ptL = g_pt1 ; local ptM = g_pt1 ; local ptMA = g_pt1 ; local ptMB = g_pt1 ;
    local ptMC = g_pt1 ; local ptN = g_pt1 ; local ptNA = g_pt1 ; local ptNB = g_pt1 ; local ptNC = g_pt1 ; local ptO = g_pt1 ; local ptP = g_pt1 ;
    local ptS = g_pt1 ; local ptSA = g_pt1 ; local ptSB = g_pt1 ; local ptSC = g_pt1 ; local ptT = g_pt1 ; local ptR = g_pt1 ;
    local ptQ = g_pt1 ; local pt1Text = g_pt1  ; local pt2 = g_pt1 ; local pt3 = g_pt1 ; local pt4 = g_pt1 ; local pt5 = g_pt1 ; local pt6 = g_pt1 ; local pt7 = g_pt1 ; 
    local layer = job.LayerManager:GetLayerWithName(lay)    
    local line = Contour(0.0)
    Base.ToeKickCoverHight = ((Base.ToeKickHight + FaceFrame.BottomRailWidth) - (FaceFrame.BottomFFReveal + Base.Thickness + Base.ToeKickBottomOffsetHight))
    if side == "R" then
        pt1Text = Polar2D(g_pt1, 45,  6)
        pt2 = Polar2D(g_pt1, 0, Base.CabHeight)
        pt3 = Polar2D(pt2,  90, g_BoxDepth)
        pt4 = Polar2D(pt3, 180, Base.CabHeight)
        pt5 = Polar2D(pt3, 270, Base.ToeKickDepth)

        pt6 = Polar2D(pt5, 180, Base.ToeKickCoverHight)
        pt7 = Polar2D(pt3, 180, Base.ToeKickCoverHight)
        line:AppendPoint(g_pt1) ;
        line:LineTo(pt2) ; 
        line:LineTo(pt5) ; 
        line:LineTo(pt6) ; 
        line:LineTo(pt7) ; 
        line:LineTo(pt4) ; 
        line:LineTo(g_pt1) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
--Back Dato    
        ptA = Polar2D(g_pt1,  90, Base.ThicknessBack) ;
        ptD = Polar2D(ptA,   180, Milling.ToolSizeRadus) ;
        ptA = Polar2D(ptD,   270, Base.ThicknessBack + Milling.RabbitClearnace)
        ptC = Polar2D(pt2,   90, Base.ThicknessBack) ;
        ptC = Polar2D(ptC,    0, Milling.ToolSizeDia) ;
        ptB = Polar2D(ptC,   270, Base.ThicknessBack + Milling.RabbitClearnace)

        line = Contour(0.0)
        line:AppendPoint(ptA) ;
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        
--Bottom Dato (Base.ToeKickHight + FaceFrame.BottomRailWidth) - (FaceFrame.BottomFFReveal + Base.Thickness + Base.ToeKickBottomOffsetHight)
        ptF = Polar2D(pt2,   180, Base.ToeKickCoverHight + Base.ToeKickBottomOffsetHight) ;
        ptF = Polar2D(ptF,   270, Milling.ToolSizeRadus) ;
        ptG = Polar2D(pt3,   180, Base.ToeKickCoverHight + Base.ToeKickBottomOffsetHight) ;
        ptG = Polar2D(ptG,    90, Milling.ToolSizeRadus) ;
        ptE = Polar2D(ptF,   180, Base.Thickness)
        ptH = Polar2D(ptG,   180, Base.Thickness) ;

        line = Contour(0.0)
        line:AppendPoint(ptF) ;
        line:LineTo(ptG) ; 
        line:LineTo(ptH) ; 
        line:LineTo(ptE) ; 
        line:LineTo(ptF) ; 
        layer:AddObject(CreateCadContour(line), true) ;

-- Top Frame Back Dato
        ptO = Polar2D(g_pt1,  90, Base.ThicknessBack)
        ptO = Polar2D(ptO,     0, Base.Thickness)
        ptN = Polar2D(ptO,    90, FaceFrame.DrawerFrameWidth) ; 
        ptNA = Polar2D(ptN,   90, Milling.ToolSizeRadus) ; 
        ptNB = Polar2D(ptNA, 180, Milling.ToolSizeDia + Milling.MillClearnace) ; 
        ptNC = Polar2D(ptNB, 270, Milling.ToolSizeRadus) ; 
        ptM = Polar2D(ptN,   180, Base.Thickness + Milling.RabbitClearnace) ; 
        ptO = Polar2D(ptO,   270, Milling.RabbitClearnace)
        ptP = Polar2D(ptO,   180, Base.Thickness + Milling.RabbitClearnace) ; 

        line = Contour(0.0)
        line:AppendPoint(ptO) ;
        line:LineTo(ptNA) ; 
        line:LineTo(ptNB) ; 
        line:LineTo(ptNC) ; 
        line:LineTo(ptM) ; 
        line:LineTo(ptP) ; 
        line:LineTo(ptO) ; 
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Top Frame Front Dato
        ptI = Polar2D(pt4,     0, Base.Thickness)
        ptJ = Polar2D(ptI,   270, FaceFrame.DrawerFrameWidth) ; 
        ptJA = Polar2D(ptJ,  270, Milling.ToolSizeRadus) ; 
        ptJB = Polar2D(ptJA, 180, Milling.ToolSizeDia + Milling.MillClearnace) ; 
        ptJC = Polar2D(ptJB,  90, Milling.ToolSizeRadus) ; 
        ptI = Polar2D(ptI,    90, Milling.RabbitClearnace)
        ptK = Polar2D(ptJ,   180, Base.Thickness + Milling.RabbitClearnace) ; 
        ptL = Polar2D(ptI,   180, Base.Thickness + Milling.RabbitClearnace) ; 

        line = Contour(0.0)
        line:AppendPoint(ptI) ;
        line:LineTo(ptJA) ; 
        line:LineTo(ptJB) ; 
        line:LineTo(ptJC) ; 
        line:LineTo(ptK) ; 
        line:LineTo(ptL) ; 
        line:LineTo(ptI) ; 
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Toe Front Dato
        ptR = Polar2D(pt5,   270, Base.Thickness)
        ptS = Polar2D(ptR,   180, Base.ToeKickCoverHight) ; 
        ptSA = Polar2D(ptS,  180, Milling.ToolSizeRadus) ; 
        ptSB = Polar2D(ptSA,  90, Milling.ToolSizeDia + Milling.MillClearnace) ; 
        ptSC = Polar2D(ptSB,   0, Milling.ToolSizeRadus) ; 
        ptR = Polar2D(ptR,     0, Milling.RabbitClearnace)
        ptQ = Polar2D(ptR,    90, Base.Thickness + Milling.RabbitClearnace)
        ptT = Polar2D(ptS,    90, Base.Thickness + Milling.RabbitClearnace) ; 
        line = Contour(0.0)
        line:AppendPoint(ptR) ;
        line:LineTo(ptSA) ; 
        line:LineTo(ptSB) ; 
        line:LineTo(ptSC) ; 
        line:LineTo(ptT) ; 
        line:LineTo(ptQ) ; 
        line:LineTo(ptR) ; 
        layer:AddObject(CreateCadContour(line), true) ;
        DrawWriter("Base Cabinet Right Side - ".. Base.Thickness .." Plywood", pt1Text, 0.5000, lay)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    else
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        pt1Text = Polar2D(g_pt1, 45,  6)
        pt2 = Polar2D(g_pt1, 0, Base.CabHeight)
        pt3 = Polar2D(pt2,  90, g_BoxDepth)
        pt4 = Polar2D(pt3, 180, Base.CabHeight)
        pt5 = Polar2D(pt2, 90, Base.ToeKickDepth)
        pt6 = Polar2D(pt5, 180, Base.ToeKickCoverHight)
        pt7 = Polar2D(pt2, 180, Base.ToeKickCoverHight)
        
        line:AppendPoint(g_pt1) ;
        line:LineTo(pt7) ; 
        line:LineTo(pt6) ; 
        line:LineTo(pt5) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ;
        line:LineTo(g_pt1) ; 
        layer:AddObject(CreateCadContour(line), true) ; 

--Back Dato    
        ptA = Polar2D(pt4,   270, Base.ThicknessBack) ;
        ptA = Polar2D(ptA,   180, Milling.ToolSizeRadus) ;
        ptD = Polar2D(ptA,    90, Base.ThicknessBack + Milling.RabbitClearnace)
        ptB = Polar2D(pt3,   270, Base.ThicknessBack) ;
        ptB = Polar2D(ptB,     0, Milling.ToolSizeRadus) ;
        ptC = Polar2D(ptB,    90, Base.ThicknessBack + Milling.RabbitClearnace)

        line = Contour(0.0)
        line:AppendPoint(ptA) ;
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        
--Bottom Dato
        ptF = Polar2D(pt2,   180, Base.ToeKickCoverHight + Base.ToeKickBottomOffsetHight) ;
        ptF = Polar2D(ptF,   270, Milling.ToolSizeRadus) ;
        ptG = Polar2D(pt3,   180, Base.ToeKickCoverHight + Base.ToeKickBottomOffsetHight) ;
        ptG = Polar2D(ptG,    90, Milling.ToolSizeRadus) ;
        ptE = Polar2D(ptF,   180, Base.Thickness)
        ptH = Polar2D(ptG,   180, Base.Thickness) ;

        line = Contour(0.0)
        line:AppendPoint(ptF) ;
        line:LineTo(ptG) ; 
        line:LineTo(ptH) ; 
        line:LineTo(ptE) ; 
        line:LineTo(ptF) ; 
        layer:AddObject(CreateCadContour(line), true) ;

-- Top Frame Front Dato
        ptO = Polar2D(g_pt1,   0, Base.Thickness)
        ptN = Polar2D(ptO,    90, FaceFrame.DrawerFrameWidth) ; 
        ptNA = Polar2D(ptN,   90, Milling.ToolSizeRadus) ; 
        ptNB = Polar2D(ptNA, 180, Milling.ToolSizeDia + Milling.MillClearnace) ; 
        ptNC = Polar2D(ptNB, 270, Milling.ToolSizeRadus) ; 
        ptM = Polar2D(ptN,   180, Base.Thickness + Milling.RabbitClearnace) ; 
        ptO = Polar2D(ptO,   270, Milling.RabbitClearnace)
        ptP = Polar2D(ptO,   180, Base.Thickness + Milling.RabbitClearnace) ; 

        line = Contour(0.0)
        line:AppendPoint(ptO) ;
        line:LineTo(ptNA) ; 
        line:LineTo(ptNB) ; 
        line:LineTo(ptNC) ; 
        line:LineTo(ptM) ; 
        line:LineTo(ptP) ; 
        line:LineTo(ptO) ; 
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Top Frame Back Dato
        ptI = Polar2D(pt4,   270, Base.ThicknessBack)
        ptI = Polar2D(ptI,     0, Base.Thickness)
        ptJ = Polar2D(ptI,   270, FaceFrame.DrawerFrameWidth) ; 
        ptJA = Polar2D(ptJ,  270, Milling.ToolSizeRadus) ; 
        ptJB = Polar2D(ptJA, 180, Milling.ToolSizeDia + Milling.MillClearnace) ; 
        ptJC = Polar2D(ptJB,  90, Milling.ToolSizeRadus) ; 
        ptI = Polar2D(ptI,    90, Milling.RabbitClearnace)
        ptK = Polar2D(ptJ,   180, Base.Thickness + Milling.RabbitClearnace) ; 
        ptL = Polar2D(ptI,   180, Base.Thickness + Milling.RabbitClearnace) ; 

        line = Contour(0.0)
        line:AppendPoint(ptI) ;
        line:LineTo(ptJA) ; 
        line:LineTo(ptJB) ; 
        line:LineTo(ptJC) ; 
        line:LineTo(ptK) ; 
        line:LineTo(ptL) ; 
        line:LineTo(ptI) ; 
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Toe Front Dato
        ptR = Polar2D(pt5,    90, Base.Thickness)
        ptS = Polar2D(ptR,   180, Base.ToeKickCoverHight) ; 
        ptSA = Polar2D(ptS,  180, Milling.ToolSizeRadus) ; 
        ptSB = Polar2D(ptSA, 270, Milling.ToolSizeDia + Milling.MillClearnace) ; 
        ptSC = Polar2D(ptSB,   0, Milling.ToolSizeRadus) ; 
        ptR = Polar2D(ptR,     0, Milling.RabbitClearnace)
        ptQ = Polar2D(ptR,    270, Base.Thickness + Milling.RabbitClearnace)
        ptT = Polar2D(ptS,    270, Base.Thickness + Milling.RabbitClearnace) ; 
          
        line = Contour(0.0)
        line:AppendPoint(ptR) ;
        line:LineTo(ptSA) ; 
        line:LineTo(ptSB) ; 
        line:LineTo(ptSC) ; 
        line:LineTo(ptT) ; 
        line:LineTo(ptQ) ; 
        line:LineTo(ptR) ; 
        layer:AddObject(CreateCadContour(line), true) ;
        DrawWriter("Base Cabinet Left Side - ".. Base.Thickness .." Plywood", pt1Text, 0.5000, lay)
    end
    if Shelf.Count >= 1 then
        local ptx = g_pt1 ; local anx = 0
        if side == "L" then
                ptx = Polar2D(Polar2D(g_pt1, 0, (Shelf.HoleFirstRowSpacing + Base.Thickness)), 90, ((g_BoxDepth - Base.ThicknessBack) * Shelf.PinInter)) ; anx = 90
            else
                ptx = Polar2D(Polar2D(pt4, 0, (Shelf.HoleFirstRowSpacing + Base.Thickness)), 270, ((g_BoxDepth - Base.ThicknessBack) * Shelf.PinInter)) ; anx = 270
        end
        local spc = ((g_BoxDepth - Base.Thickness) * Shelf.PinOuter)
        local rows = ((g_BoxDepth - (Shelf.HoleFirstRowSpacing + Shelf.HoleLastRowSpacing + (Base.Thickness * 2.0))) / Shelf.HoleSpacing)
        while (rows > 0) do
            Holer (ptx, anx, spc, Shelf.PinRadus, lay)
             ptx = Polar2D(ptx, 0, Shelf.HoleSpacing)
            rows = (rows - 1.0)
        end
    end
  return true   
end
-- ==============================================================================
function LowerCenterPanel(lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end

    Base.CenterPanelHight = Base.CabDepth - ((Base.ThicknessBack * 0.5) + FaceFrame.FFThickness)
    Base.CenterPanelDepth = Base.CabHeight - ((Base.Thickness * 0.5) + (Base.ToeKickHight + (Base.Thickness * 0.5)))
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt1 = Polar2D(g_pt1, 0, (Base.Thickness * 0.5))
    local pt1 = Polar2D(pt1, 90, (Base.ThicknessBack * 0.5))
    local pt2 = Polar2D(pt1, 0, Base.CenterPanelDepth)
    local pt3 = Polar2D(pt2, 90, Base.CenterPanelHight)
    local pt4 = Polar2D(pt3, 180, Base.CenterPanelDepth)
    local line = Contour(0.0)
    line:AppendPoint(pt1) ;
    line:LineTo(pt2) ; 
    line:LineTo(pt3) ; 
    line:LineTo(pt4) ; 
    line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true) 
    local pt1Text = Polar2D(g_pt1, 45,  8)
    DrawWriter("Base Cabinet Center Panel - ".. Base.Thickness .." Plywood", pt1Text, 0.5000, lay)
    
     if Shelf.Count >= 1 then
        local ptx = g_pt1 ; local anx = 0
        ptx = Polar2D(Polar2D(pt4, 0, (Shelf.HoleFirstRowSpacing + (Base.Thickness * 0.5))), 270, ((g_BoxDepth - Base.ThicknessBack) * Shelf.PinInter)) ; anx = 270

        local spc = ((g_BoxDepth - Base.Thickness) * Shelf.PinOuter)
        local rows = ((g_BoxDepth - (Shelf.HoleFirstRowSpacing + Shelf.HoleLastRowSpacing + (Base.Thickness * 2.0))) / Shelf.HoleSpacing)
        while (rows > 0) do
            Holer (ptx, anx, spc, Shelf.PinRadus, lay)
             ptx = Polar2D(ptx, 0, Shelf.HoleSpacing)
            rows = (rows - 1.0)
        end
    end 
  return true   
end
-- ==============================================================================
function LoadDialog(job, script_path)
    local registry = Registry("CabinetMaker")
	local html_path = "file:" .. script_path .. "\\CabinetMaker.htm"
    local dialog = HTML_Dialog(false, html_path, 850, 600,      Global.ProgramTitle)
    dialog:AddDoubleField("Milling.RabbitClearnace",                       Milling.RabbitClearnace)  
    dialog:AddDoubleField("Milling.MillClearnace",              Milling.MillClearnace)
    dialog:AddDoubleField("Base.Thickness",                Base.Thickness)   
    dialog:AddDoubleField("Shelf.PinDiameter",                 Shelf.PinDiameter)    
    dialog:AddDoubleField("Base.CabLength",               Base.CabLength)      
    dialog:AddDoubleField("Base.CabHeight",               Base.CabHeight)
    dialog:AddDoubleField("Base.CabDepth",                Base.CabDepth)      
    dialog:AddDoubleField("Base.CabLength",               Base.CabLength)      
    dialog:AddDoubleField("Base.CabHeight",               Base.CabHeight)
    dialog:AddDoubleField("Base.CabDepth",                Base.CabDepth)      
    dialog:AddDoubleField("Base.ThicknessBack",            Base.ThicknessBack)      
    dialog:AddDoubleField("Shelf.PinOuter",                         Shelf.PinOuter)
    dialog:AddDoubleField("Shelf.PinInter",                         Shelf.PinInter)     
    dialog:AddDoubleField("Shelf.EndClarence",                 Shelf.EndClarence)
    dialog:AddDoubleField("Shelf.Count",                       Shelf.Count)
    dialog:AddDoubleField("FaceFrame.StileWidth",                 FaceFrame.StileWidth)     
    dialog:AddDoubleField("FaceFrame.StileWidth",               FaceFrame.StileWidth)      
    dialog:AddDoubleField("FaceFrame.BottomRailWidth",             FaceFrame.BottomRailWidth)
    dialog:AddDoubleField("Shelf.FaceFrameWidth",              Shelf.FaceFrameWidth)
    dialog:AddDoubleField("FaceFrame.FFThickness",               FaceFrame.FFThickness)    
    dialog:AddDoubleField("FaceFrame.TopRailWidth",                FaceFrame.TopRailWidth)
    dialog:AddDoubleField("FaceFrame.CenterStileWidth",             FaceFrame.CenterStileWidth)
    dialog:AddLabelField("Global.ProgramVersion",                    Global.ProgramVersion)
    dialog:AddLabelField("Global.ProgramTitle",                      Global.ProgramTitle)   
    dialog:AddLabelField("Global.CodeBy",                            Global.CodeBy)  
    dialog:AddDoubleField("FaceFrame.BottomFFReveal",           FaceFrame.BottomFFReveal)
    dialog:AddDoubleField("FaceFrame.TopOverlap",              FaceFrame.TopOverlap)
    dialog:AddDoubleField("Shelf.FaceFrameWidth",               Shelf.FaceFrameWidth)
    dialog:AddDoubleField("Shelf.FaceFrameReveal",                     Shelf.FaceFrameReveal)
    dialog:AddDoubleField("Shelf.HoleSpacing",                 Shelf.HoleSpacing)
    dialog:AddDoubleField("Shelf.WidthClearance",              Shelf.WidthClearance)
    dialog:AddDoubleField("Base.ToeKickDepth",                     Base.ToeKickDepth)
    dialog:AddDoubleField("Base.ToeKickHight",                     Base.ToeKickHight)
    dialog:AddDoubleField("FaceFrame.DrawerFrameWidth",               FaceFrame.DrawerFrameWidth)
    dialog:AddDoubleField("Base.ToeKickBottomOffsetHight",         Base.ToeKickBottomOffsetHight)
    dialog:AddDoubleField("Shelf.Count",                        Shelf.Count)
    dialog:AddDoubleField("FaceFrame.DrawerHeight",                FaceFrame.DrawerHeight)   
    dialog:AddDoubleField("FaceFrame.DrawerRowCount",              FaceFrame.DrawerRowCount)
    dialog:AddDoubleField("FaceFrame.NumberDrawersPerRow",         FaceFrame.NumberDrawersPerRow)
    dialog:AddDoubleField("Shelf.PinOuter",                    Shelf.PinOuter)
    dialog:AddDoubleField("Shelf.PinInter",                    Shelf.PinInter)
    dialog:AddDoubleField("Shelf.WidthClearance",               Shelf.WidthClearance)
    dialog:AddDoubleField("FaceFrame.FFReveal",            FaceFrame.FFReveal)
    dialog:AddDoubleField("FaceFrame.StileWidth",         FaceFrame.StileWidth)
    dialog:AddDoubleField("FaceFrame.BottomRailWidth",        FaceFrame.BottomRailWidth)
    dialog:AddDoubleField("FaceFrame.FFThickness",          FaceFrame.FFThickness)
    dialog:AddDoubleField("FaceFrame.TopRailWidth",           FaceFrame.TopRailWidth)
    dialog:AddDoubleField("FaceFrame.CenterStileWidth",        FaceFrame.CenterStileWidth)
    dialog:AddDoubleField("FaceFrame.BottomFFReveal",      FaceFrame.BottomFFReveal)
    dialog:AddDoubleField("Shelf.HoleSpacing",                      Shelf.HoleSpacing)
    dialog:AddDoubleField("Shelf.HoleFirstRowSpacing",              Shelf.HoleFirstRowSpacing)
    dialog:AddDoubleField("Shelf.HoleFirstRowSpacing",      Shelf.HoleFirstRowSpacing)
    dialog:AddDoubleField("Shelf.HoleLastRowSpacing",               Shelf.HoleLastRowSpacing)
    dialog:AddDoubleField("Shelf.HoleLastRowSpacing",          Shelf.HoleLastRowSpacing)
    dialog:AddTextField("Base.AddCenterPanel",                Base.AddCenterPanel)
    dialog:AddTextField("Base.AddCenterFaceFrame",            Base.AddCenterFaceFrame)
    dialog:AddTextField("FaceFrame.AddDrawers",                    FaceFrame.AddDrawers)
    dialog:AddTextField("Base.AddCenterPanel",                        Base.AddCenterPanel)
    dialog:AddTextField("Base.AddCenterFaceFrame",                    Base.AddCenterFaceFrame)
    dialog:AddDirectoryPicker("g_selectJobPath",  "Global.JobPath", true);
	if not dialog:ShowDialog() then
		return false
		-- Done and run ;-)
	end
	local tool = dialog:GetTool("ToolChooseButton")
-- Get the data from the Dialog and update my global variables
    Shelf.PinOuter                      = tonumber(dialog:GetDoubleField("Shelf.PinOuter"))
    Shelf.PinInter                      = tonumber(dialog:GetDoubleField("Shelf.PinInter"))
    Shelf.EndClarence                   = tonumber(dialog:GetDoubleField("Shelf.EndClarence"))
    Base.ThicknessBack                  = tonumber(dialog:GetDoubleField("Base.ThicknessBack"))
    FaceFrame.StileWidth                = tonumber(dialog:GetDoubleField("FaceFrame.StileWidth"))
    FaceFrame.StileWidth                = tonumber(dialog:GetDoubleField("FaceFrame.StileWidth"))
    FaceFrame.BottomRailWidth           = tonumber(dialog:GetDoubleField("FaceFrame.BottomRailWidth"))
    Milling.MillClearnace               = tonumber(dialog:GetDoubleField("Milling.MillClearnace"))
    Milling.RabbitClearnace             = tonumber(dialog:GetDoubleField("Milling.RabbitClearnace"))
    Base.Thickness                      = tonumber(dialog:GetDoubleField("Base.Thickness"))
    Shelf.PinDiameter                   = tonumber(dialog:GetDoubleField("Shelf.PinDiameter"))
    Base.CabLength                      = tonumber(dialog:GetDoubleField("Base.CabLength"))
    Base.CabHeight                      = tonumber(dialog:GetDoubleField("Base.CabHeight"))
    Base.CabDepth                       = tonumber(dialog:GetDoubleField("Base.CabDepth"))
    Base.CabLength                      = tonumber(dialog:GetDoubleField("Base.CabLength"))
    Base.CabHeight                      = tonumber(dialog:GetDoubleField("Base.CabHeight"))
    Base.CabDepth                       = tonumber(dialog:GetDoubleField("Base.CabDepth"))
    Shelf.Count                         = tonumber(dialog:GetDoubleField("Shelf.Count"))
    Shelf.FaceFrameWidth                = tonumber(dialog:GetDoubleField("Shelf.FaceFrameWidth"))
    FaceFrame.FFThickness               = tonumber(dialog:GetDoubleField("FaceFrame.FFThickness"))
    FaceFrame.DrawerFrameWidth          = tonumber(dialog:GetDoubleField("FaceFrame.DrawerFrameWidth"))
    FaceFrame.TopRailWidth              = tonumber(dialog:GetDoubleField("FaceFrame.TopRailWidth"))
    FaceFrame.CenterStileWidth          = tonumber(dialog:GetDoubleField("FaceFrame.CenterStileWidth"))
    FaceFrame.BottomFFReveal            = tonumber(dialog:GetDoubleField("FaceFrame.BottomFFReveal"))
    FaceFrame.TopOverlap                = tonumber(dialog:GetDoubleField("FaceFrame.TopOverlap"))
    Shelf.HoleSpacing                   = tonumber(dialog:GetDoubleField("Shelf.HoleSpacing"))
    Shelf.WidthClearance                = tonumber(dialog:GetDoubleField("Shelf.WidthClearance"))
    Base.ToeKickDepth                   = tonumber(dialog:GetDoubleField("Base.ToeKickDepth"))
    Base.ToeKickHight                   = tonumber(dialog:GetDoubleField("Base.ToeKickHight"))
    Base.ToeKickBottomOffsetHight       = tonumber(dialog:GetDoubleField("Base.ToeKickBottomOffsetHight"))
    Shelf.FaceFrameWidth                = tonumber(dialog:GetDoubleField("Shelf.FaceFrameWidth"))
    Shelf.FaceFrameReveal               = tonumber(dialog:GetDoubleField("Shelf.FaceFrameReveal"))
    Base.AddCenterPanel                 =          dialog:GetTextField("Base.AddCenterPanel")
    Base.AddCenterFaceFrame             =          dialog:GetTextField("Base.AddCenterFaceFrame")
    FaceFrame.AddDrawers                =          dialog:GetTextField("FaceFrame.AddDrawers")
    Shelf.Count                         = tonumber(dialog:GetDoubleField("Shelf.Count"))
    FaceFrame.DrawerHeight              = tonumber(dialog:GetDoubleField("FaceFrame.DrawerHeight"))
    FaceFrame.DrawerRowCount            = tonumber(dialog:GetDoubleField("FaceFrame.DrawerRowCount"))
    FaceFrame.NumberDrawersPerRow       = tonumber(dialog:GetDoubleField("FaceFrame.NumberDrawersPerRow"))
    Shelf.PinOuter                      = tonumber(dialog:GetDoubleField("Shelf.PinOuter"))
    Shelf.PinInter                      = tonumber(dialog:GetDoubleField("Shelf.PinInter"))
    Shelf.WidthClearance                = tonumber(dialog:GetDoubleField("Shelf.WidthClearance"))
    FaceFrame.FFReveal                  = tonumber(dialog:GetDoubleField("FaceFrame.FFReveal"))
    FaceFrame.StileWidth                = tonumber(dialog:GetDoubleField("FaceFrame.StileWidth"))
    FaceFrame.BottomRailWidth           = tonumber(dialog:GetDoubleField("FaceFrame.BottomRailWidth"))
    FaceFrame.FFThickness               = tonumber(dialog:GetDoubleField("FaceFrame.FFThickness"))
    FaceFrame.TopRailWidth              = tonumber(dialog:GetDoubleField("FaceFrame.TopRailWidth"))
    FaceFrame.CenterStileWidth          = tonumber(dialog:GetDoubleField("FaceFrame.CenterStileWidth"))
    FaceFrame.BottomFFReveal            = tonumber(dialog:GetDoubleField("FaceFrame.BottomFFReveal"))
    Shelf.HoleSpacing                   = tonumber(dialog:GetDoubleField("Shelf.HoleSpacing"))
    Shelf.HoleFirstRowSpacing           = tonumber(dialog:GetDoubleField("Shelf.HoleFirstRowSpacing"))
    Shelf.HoleFirstRowSpacing           = tonumber(dialog:GetDoubleField("Shelf.HoleFirstRowSpacing"))
    Shelf.HoleLastRowSpacing            = tonumber(dialog:GetDoubleField("Shelf.HoleLastRowSpacing"))
    Shelf.HoleLastRowSpacing            = tonumber(dialog:GetDoubleField("Shelf.HoleLastRowSpacing"))
    Base.AddCenterPanel                   = dialog:GetTextField("Base.AddCenterPanel")
    Base.AddCenterFaceFrame               = dialog:GetTextField("Base.AddCenterFaceFrame")

    Shelf.PinRadus = Shelf.PinDiameter * 0.5
    
    Milling.ToolSizeDia = 0.25
    Milling.ToolSizeRadus = Milling.ToolSizeDia * 0.50 
    return true
end  -- function end
-- ==============================================================================
function main(script_path)
    -- create a layer with passed name if it doesn't already exist
    local job = VectricJob()
    local CountX = 0.0
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    local lay = "A"
    	-- loop the Dialog to get all user inputs
	repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == false then
			return false
		end		
	until ret_value == true

    g_BoxHight =  (Base.CabHeight - (FaceFrame.TopRailWidth + FaceFrame.BottomRailWidth)) + (FaceFrame.BottomFFReveal + FaceFrame.TopOverlap + (Base.Thickness * 2.0))
    g_BoxLength = Base.CabLength - (FaceFrame.StileWidth * 2.0) ; g_BackHight = g_BoxHight - Base.Thickness ; g_BackWidth = g_BoxLength - Base.Thickness ; g_BoxDepth  = Base.CabDepth - FaceFrame.FFThickness
    g_BoxDepth = Base.CabDepth - FaceFrame.FFThickness
    g_BoxLength = Base.CabLength - (FaceFrame.FFReveal * 2)

    if Shelf.Count >= 1 then
        CountX = Shelf.Count
        while (CountX > 0) do
        --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
            lay = Base.Thickness .. "-WallCab-Shelf".. CountX        
            LowerCabinetShelf(lay, CountX)
            CountX = CountX - 1
        end
    end
    if Base.AddCenterPanel then
        LowerCenterPanel(Base.Thickness ..  "-WallCab-CenterPanel")
    end
    LowerCabinetFaceFrame("WallCab-FaceFrame")
    LowerCabinetSide("L", Base.Thickness .. "-BaseCab-LeftSide")
    LowerCabinetSide("R", Base.Thickness .. "-BaseCab-RightSide")
    LowerCabinetBottom(Base.Thickness ..    "-BaseCab-Bottom" )
    LowerCabinetBack(Base.ThicknessBack ..  "-BaseCab-Back") 
    if Shelf.Count >= 1 then
        CountX = Shelf.Count
        while (CountX > 0) do
        --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
            lay = Base.Thickness .. "-BaseCab-Shelf".. CountX        
            LowerCabinetShelf(lay, CountX)
            CountX = CountX - 1
        end
    end
    if Base.AddCenterFaceFrame then
        LowerCenterPanel(Base.Thickness .. "-BaseCab-CenterPanel")
    end
    LowerCabinetFaceFrame("BaseCab-FaceFrame")
    CutListfileWriter(Global.JobPath)
-- Regenerate the drawing display
	job:Refresh2DView()
    return true 
end
-- ==============================================================================
function mainBase(script_path)
    -- create a layer with passed name if it doesn't already exist
    local lay = ""
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    -- Pop-up Dialog message for Cabinet Style
    StdHeaderReader(script_path) -- Read Default Cabinets
    Global.ProgramName = InquiryDropList("Cabinet Maker", "Select Cabinet Style", IniFile)
    -- DisplayMessageBox(" A - " .. Global.ProgramName)    
    if Global.ProgramName ~= "." then
        -- DisplayMessageBox(" T - " .. Global.ProgramName)    
        StdLoader(script_path, Global.ProgramName) -- Load per selection 
    else
        -- DisplayMessageBox(" F - " .. Global.ProgramName)    
        goto exit; -- when timing of want to finish script.
    end
        -- DisplayMessageBox(" z - " .. Global.ProgramName)    
    repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == 2 then
			-- DisplayMessageBox("No Tool Selected")
            goto exit; -- when timing of want to finish script.
		end	

		if ret_value == false then
			return false
		end	        
	until ret_value == true
    -- DisplayMessageBox(BtoS(Base.AddFaceFrame))  
    if Base.AddFaceFrame then
        g_BoxHight =  (Base.CabHeight - (FaceFrame.TopRailWidth + FaceFrame.BottomRailWidth)) + (FaceFrame.BottomFFReveal + FaceFrame.TopOverlap + (Base.Thickness * 2.0))   
        g_BoxLength = Base.CabLength - (FaceFrame.FFReveal * 2.0) 
        g_BoxDepth  = Base.CabDepth - FaceFrame.FFThickness
    else 
        g_BoxLength = Base.CabLength 
        g_BoxDepth  = Base.CabDepth
        g_BoxHight =  Base.CabHeight
        FaceFrame.TopRailWidth = 0.0
        FaceFrame.BottomRailWidth = 0.0
        FaceFrame.BottomFFReveal = 0.0
        FaceFrame.TopOverlap = 0.0  
    end

    g_BackHight = g_BoxHight - Base.Thickness
    g_BackWidth = g_BoxLength - Base.Thickness 
  
    g_pt2 = Point2D((g_BoxHight + (3 * g_PartGap)),1)
    g_pt3 = Point2D(1.0,(g_BoxDepth + (3 * g_PartGap)))
    g_pt4 = Polar2D(g_pt3, 0, ((g_BoxLength - (Base.Thickness * 1.0) ) + (1.0 * g_PartGap)))
    g_pt5 = Point2D(1.0,((g_BoxDepth * 2.0) + (4.0 * g_PartGap))) -- Shelf
    g_pt6 = Point2D(1.0,((g_BoxDepth * 3.0) + (5.0 * g_PartGap))) -- Center
    g_pt7 = Point2D(((g_BoxLength * 2.0) + (3.0 * g_PartGap) - (Base.Thickness * 1.0)) ,1.0) -- Back
    g_pt8 = Point2D(((g_BoxLength * 2.0) + (3.0 * g_PartGap) + (g_BackHight * 1.0)),1.0) -- FaceFrame
   
    if StandardCabs.New then
        local xa = InquiryTextBox("Cabinet Maker", "Standard Cabinet Name", "Style-0001")
        if xa ~= "" then
            StdFileWriter(script_path, xa) 
        end
    end
 
    if Drawing.DrawSideL then 
        LowerCabinetSide("L",  Base.Thickness .. "-Profile")
    end
    if Drawing.DrawSideR then
        LowerCabinetSide("R",  Base.Thickness .. "-Profile")
    end
    if Drawing.DrawTop then
        LowerCabinetTandB("T", Base.Thickness .. "-Profile" )
    end
    if Drawing.DrawBottom then
        LowerCabinetTandB("B", Base.Thickness .. "-Profile")
    end
    if Drawing.DrawBack then
        LowerCabinetBack(Base.ThicknessBack .. "-Profile") 
    end 
    if Drawing.DrawShelf then
        if Shelf.Count >= 1 then
            local CountX = Shelf.Count
            while (CountX > 0) do
            --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
                lay = Base.Thickness .. "-Profile"                                 
                LowerCabinetShelf(lay, CountX)
                g_pt5 = Polar2D(g_pt5, 0, (Shelf.PartLength + (2 * g_PartGap))) -- (g_BoxHight + (Base.Thickness * 3.0) + (2 * g_PartGap)))  
                CountX = CountX - 1
            end
        end
    end
    if Drawing.DrawCenter then
        LowerCenterPanel(Base.Thickness ..  "-Profile")
    end
    if Drawing.DrawFaceFrame then 
        LowerCabinetFaceFrame("FaceFrame")
    end 
    if Drawing.DrawNotes then 
        CutListfileWriter(Global.JobPath)
    end 
    ::exit::
	job:Refresh2DView()  -- Regenerate the drawing display
    return true 
end  -- function end
-- ==============================================================================