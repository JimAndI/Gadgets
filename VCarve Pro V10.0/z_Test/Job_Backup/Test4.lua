-- VECTRIC LUA SCRIPT
require "strict"
--Global variables
    g_boxHight = 0.0000
    g_boxLength = 0.0000
    g_boxDepth = 0.0000
    g_backHight = 0.0000
    g_backWidth = 0.0000
    -- g_pt1 = Point2D(2,2)
-- ==============================================================================
Global = {}
    Global.ProgramTitle = "Wall Cabinet Creator"
    Global.ProgramName = "Wall-Cabinet"
    Global.ProgramVersion = "Version 1.1"
    Global.CodeBy = "Coded by James Anderson"
    Global.Contact = "James.L.Anderson@outlook.com"
    Global.Year = "2018"
    Global.JobPath = "C://Users//CNC//Documents//AAA"
    Global.StandardsPath = "C://Users//Public//Documents//Vectric Files//Gadgets//VCarve Pro V9.5//Test//"    

Milling = {} 
    Milling.millClearnace = 0.010
    Milling.DefaultToolName = "No Tool Selected" 
    Milling.ToolNameLabel = "No Tool Selected" 
    Milling.ToolSizeDia = 0.25
    Milling.ToolSizeRadus = 0.0 
    Milling.Units = "inch"
    Milling.BlindDatoDist = 1.25
    Milling.ClearnaceOffset = 0.010  -- can be + or - number, used for dato over sizing
    Milling.Offset = 0.050

StandardCabs = {} 
    StandardCabs.Name  = "None"  
    
Wall = {} -- Wall Cabinet
    Wall.ThicknessBack = 0.5000
    Wall.Length = 36.0000
    Wall.Height = 28.0000
    Wall.Depth = 12.0000
    Wall.Thickness = 0.750
    Wall.DatoDeep =  0.375
    Wall.DatoType = "Through"           -- Half, Full
    Wall.AddFaceFrame = "Y"
    Wall.AddShelf = "Y"
    Wall.AddCenterFaceFrame = "Y"
    Wall.AddCenterPanel = "Y"           -- Insert Panel in Cabinet
    Wall.BackNailer = "Y"
    Wall.NailerThickness = 0.500
    Wall.NailerWidth = 3.500

FaceFrame = {}
    FaceFrame.Thickness = 0.7500
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
     
Shelf = {}
    Shelf.WidthClearance = 0.25
    Shelf.FaceFrameWidth = 1.500
    Shelf.FaceFrameThickness = 0.7500
    Shelf.EndClarence = 0.1800
    Shelf.PinDiameter = 0.194
    Shelf.PinRadus = 0.0970
    Shelf.Count = 2.0
    Shelf.Thickness = 0.7500
    Shelf.Length = 0.0000
    Shelf.Depth = 0.0000
    Shelf.PinOuter = 0.7000
    Shelf.PinInter = 0.1600
    Shelf.FaceFrameReveal = 0.0625
    Shelf.HoleSpacing = 2.0000
    Shelf.HoleFirstRowSpacing = 4.0000
    Shelf.HoleLastRowSpacing = 3.0000 

-- ==============================================================================
function FWriter() -- "G://Job.ini"
    local file = io.open("E://Job.ini", "w")
    -- write line of the file
    file:write("#======================================================================\n")
    file:write("# Standard Cabinet Configuration File \n")
    file:write("#======================================================================\n")
    file:write("[Wall]\n")
    file:write("ThicknessBack="..       Wall.ThicknessBack   .."   \n")
    file:write("Thickness="..           Wall.Thickness   .."   \n")
    file:write("Length="..              Wall.Length   .."   \n")
    file:write("Height="..              Wall.Height   .."   \n")
    file:write("Depth="..               Wall.Depth   .."   \n")
    file:write("DatoDeep="..            Wall.DatoDeep   .."   \n")
    file:write("DatoType="..            Wall.DatoType   .."   \n")
    file:write("AddFaceFrame="..        Wall.AddFaceFrame   .."   \n")
    file:write("AddShelf="..            Wall.AddShelf   .."   \n")
    file:write("AddCenterFaceFrame="..  Wall.AddCenterFaceFrame   .."   \n")
    file:write("AddCenterPanel="..      Wall.AddCenterPanel   .."   \n")
    file:write("BackNailer="..          Wall.BackNailer   .."   \n")
    file:write("NailerThickness="..     Wall.NailerThickness   .."   \n")
    file:write("NailerWidth="..         Wall.NailerWidth   .."   \n")        
    file:write("#======================================================================\n")
        
    file:write("[Shelf]\n")   
        file:write("EndClarence="..           Shelf.EndClarence   .."   \n")
        file:write("PinDiameter="..           Shelf.PinDiameter   .."   \n")
        file:write("PinRadus="..              Shelf.PinRadus   .."   \n")
        file:write("Count="..                 Shelf.Count   .."   \n")
        file:write("FaceFrameReveal="..       Shelf.FaceFrameReveal   .."   \n")
        file:write("WidthClearance="..        Shelf.WidthClearance   .."   \n")
        file:write("FaceFrameWidth="..        Shelf.FaceFrameWidth   .."   \n")
        file:write("FaceFrameThickness="..    Shelf.FaceFrameThickness   .."   \n")
        file:write("PinOuter="..              Shelf.PinOuter   .."   \n")
        file:write("PinInter="..              Shelf.PinInter   .."   \n")
        file:write("HoleSpacing="..           Shelf.HoleSpacing   .."   \n")
        file:write("HoleFirstRowSpacing="..   Shelf.HoleFirstRowSpacing   .."   \n")
        file:write("HoleLastRowSpacing="..    Shelf.HoleLastRowSpacing   .."   \n")
        file:write("Length="..                Shelf.Length   .."   \n")
        file:write("Depth="..                 Shelf.Depth   .."   \n")
        file:write("Thickness="..             Shelf.Thickness   .."   \n")        
        file:write("#======================================================================\n")

    file:write("[Milling]\n")   
        file:write("millClearnace="..       Milling.millClearnace .."   \n")
        file:write("DefaultToolName="..     Milling.DefaultToolName .."   \n")
        file:write("ToolNameLabel="..       Milling.ToolNameLabel .."   \n")
        file:write("ToolSizeDia="..         Milling.ToolSizeDia .."   \n")
        file:write("ToolSizeRadus="..       Milling.ToolSizeRadus .."   \n")
        file:write("Units="..               Milling.Units .."   \n")
        file:write("BlindDatoDist="..       Milling.BlindDatoDist .."   \n")
        file:write("ClearnaceOffset="..     Milling.ClearnaceOffset .."   \n")
        file:write("Offset="..              Milling.Offset .."   \n")
        file:write("#======================================================================\n")    

    file:write("[Global]\n") 
        file:write("ProgramTitle="..    Global.ProgramTitle   .."   \n")
        file:write("ProgramVersion="..  Global.ProgramVersion   .."   \n")
        file:write("CodeBy="..          Global.CodeBy   .."   \n")
        file:write("JobPath="..         Global.JobPath   .."   \n")
        file:write("ProgramName="..     Global.ProgramName   .."   \n")
        file:write("Contact="..         Global.Contact   .."   \n")
        file:write("Year="..            Global.Year   .."   \n")
        file:write("StandardsPath="..   Global.StandardsPath   .."   \n")
        file:write("#======================================================================\n")
        
    file:write("[FaceFrame]\n") 
        file:write("FFReveal="..  FaceFrame.FFReveal   .."   \n")
        file:write("Thickness="..  FaceFrame.Thickness   .."   \n")
        file:write("StileWidth="..  FaceFrame.StileWidth   .."   \n")
        file:write("BottomRailWidth="..  FaceFrame.BottomRailWidth   .."   \n")
        file:write("TopRailWidth="..  FaceFrame.TopRailWidth   .."   \n")
        file:write("CenterStileWidth="..  FaceFrame.CenterStileWidth   .."   \n")
        file:write("BottomFFReveal="..  FaceFrame.BottomFFReveal   .."   \n")
        file:write("TopOverlap="..  FaceFrame.TopOverlap   .."   \n")
        file:write("StileLength="..  FaceFrame.StileLength   .."   \n")
        file:write("RailLength="..  FaceFrame.RailLength   .."   \n")
        file:write("CenterStileLength="..  FaceFrame.CenterStileLength   .."   \n")
        file:write("#======================================================================\n")

    file:write("[Variables]\n") 
        file:write("g_boxHight="..  g_boxHight .."   \n")
        file:write("g_boxLength=".. g_boxLength  .."   \n")
        file:write("g_boxDepth="..  g_boxDepth .."   \n")
        file:write("g_backHight=".. g_backHight  .."   \n")
        file:write("g_backWidth=".. g_backWidth  .."   \n")
        file:write("#======================================================================\n")   
    
        
    file:close()-- closes the open file
end

-- ==============================================================================
function main()
   
    g_boxHight =  (Wall.Height - (FaceFrame.TopRailWidth + FaceFrame.BottomRailWidth)) + (FaceFrame.BottomFFReveal + FaceFrame.TopOverlap + (Wall.Thickness * 2.0))
    g_boxLength = Wall.Length - (FaceFrame.FFReveal * 2.0) ; g_backHight = g_boxHight - Wall.Thickness ; g_backWidth = g_boxLength - Wall.Thickness ; g_boxDepth  = Wall.Depth - FaceFrame.BottomRailWidth
    
    FWriter()
    DisplayMessageBox("jim")
    return true   
end -- function end
-- ==============================================================================
