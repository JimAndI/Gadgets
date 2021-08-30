-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

Easy Drawer Maker was written by JimAndi Gadgets of Houston Texas 2019

]]
-- =====================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
Milling = {}
Project = {}
Drawer = {}
Sheet = {}
DialogWindow = {}
local MyProgressBar
local myRecord = 1.0
local Tools
local Tool_ID1 = ToolDBId()
local Tool_ID2 = ToolDBId()
local Tool_ID3 = ToolDBId()
local Tool_ID4 = ToolDBId()
local Tool_ID5 = ToolDBId()
local Tool_ID6 = ToolDBId()
local lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
Tool_ID3:LoadDefaults("My Toolpath3", "")
Tool_ID4:LoadDefaults("My Toolpath4", "")
Tool_ID5:LoadDefaults("My Toolpath5", "")
Tool_ID6:LoadDefaults("My Toolpath6", "")
Project.ProgramVersion = 3.5
DialogWindow.ProgramName = "Easy Drawer Maker"
DialogWindow.MillHelp    = "https://www.jimandi.com/EasyGadgets/EasyDrawerMaker/Help/DrawerMilling.html"
DialogWindow.ProjectHelp = "https://www.jimandi.com/EasyGadgets/EasyDrawerMaker/Help/DrawerProject.html"
DialogWindow.LayerHelp   = "https://www.jimandi.com/EasyGadgets/EasyDrawerMaker/Help/DrawerLayer.html"
DialogWindow.MainHelp    = "https://www.jimandi.com/EasyGadgets/EasyDrawerMaker/Help/DrawerMain.html"
Drawer.WP = Point2D(1, 1)
local RegName = "EasyDrawerMaker" .. string.format(Project.ProgramVersion)
local g_pt1 = Point2D(1, 1)      -- Left Side Panel
local g_pt2 = Point2D(10, 1)     -- Right Side Panel
local g_pt3 = Point2D(20, 1)     -- Base_CabinetShelf
local g_pt4 = Point2D(30, 1)     -- Base_CenterPanel
local g_pt5 = Point2D(40, 1)     -- Wall_CabinetShelf
Milling.MillTool1 = {}
Milling.MillTool2 = {}
Milling.MillTool3 = {}
Milling.MillTool4 = {}
Milling.MillTool5 = {}
Milling.MillTool6 = {}
-- =====================================================]]
function Drawer_Math()                                  -- All the math for Wall Cabinet
  Drawer.PlacementStep     = math.max(Drawer.OpeningDepth, Drawer.OpeningHeight, Drawer.OpeningWidth)
  Drawer.Depth             = Drawer.OpeningDepth - (Drawer.SideGap * 2.0)
  Drawer.Height            = Drawer.OpeningHeight - (Drawer.TopGap + Drawer.BottomGap)
  Drawer.Length            = Drawer.OpeningWidth - (Drawer.SideGap * 2.0)
  Drawer.SideWidth         = Drawer.Height
  Drawer.FrontWidth        = Drawer.Height
  Drawer.BackWidth         = Drawer.Height
  Project.DrawerID         = StartDate()
  Drawer.SideLength        = Drawer.OpeningDepth - 1.0
  Drawer.FrontLength       = Drawer.OpeningWidth - (Drawer.SideGap * 2.0)
  Drawer.BackLength        = Drawer.FrontLength - (Milling.DadoHeight * 2.0)
  Drawer.BottomPanelLength = ((Drawer.SideLength - Drawer.BackThickness) - Drawer.BackDatoInset) - Drawer.FrontThickness + (Milling.DadoHeight * 2.0)
  Drawer.BottomPanelWidth  = Drawer.Length  - (Milling.DadoHeight * 2.0)
  Drawer.SideFingerWidth   = Drawer.SideWidth/Drawer.SideFingerCount
  Project.DatFile          = Project.ProjectPath .. "\\" .. Project.DrawerName .. "-" .. Project.DrawerID

  if Drawer.Unit then
    Drawer.BlumeMax  = 13.0
    Drawer.BlumeDia  =  6.0
    Drawer.BlumeWide = 33.0
    Drawer.BlumeDown = 11.0
    Drawer.BlumeIn   =  7.0
  else
    Drawer.BlumeMax  = 0.511811
    Drawer.BlumeDia  = 0.236220
    Drawer.BlumeWide = 1.299213
    Drawer.BlumeDown = 0.433071
    Drawer.BlumeIn   = 0.275591
  end -- if end

-- Bit and Milling Values

  Milling.PocketToolDia     = Milling.ProfileToolDia
  Milling.ProfileToolRadius = Milling.ProfileToolDia * 0.5000
  Milling.PocketToolRadius  = Milling.PocketToolDia  * 0.5000
  Milling.FingerToolRadius  = Milling.FingerToolDia  * 0.5000

  if Milling.Profile then
    Milling.ProfileToolDia = Milling.MillTool1.ToolDia
    Milling.ProfileToolRadius = Milling.ProfileToolDia * 0.5000
  end

  if Milling.Dado then
    Milling.PocketToolDia = Milling.MillTool2.ToolDia
    Milling.ProfileToolRadius = Milling.ProfileToolDia * 0.5000
  end

  if Milling.Finger then
    Milling.FingerToolDia = Milling.MillTool4.ToolDia
    Milling.FingerToolRadius  = Milling.FingerToolDia  * 0.5000
  end
  g_pt2 = Polar2D(g_pt1, 0.0, (Drawer.SideWidth  + Milling.PartGap))   -- Right Side Panel
  g_pt3 = Polar2D(g_pt2, 0.0, (Drawer.SideWidth  + Milling.PartGap))   -- Base_CabinetShelf
  g_pt4 = Polar2D(g_pt3, 0.0, (Drawer.FrontWidth + Milling.PartGap))   -- Base_CenterPanel
  g_pt5 = Polar2D(g_pt4, 0.0, (Drawer.BackWidth  + Milling.PartGap))   -- Draw Panel Bottom
  REG_UpdateRegistry()
  return true
end
-- =====================================================]]
function REG_ReadRegistry()                             -- Read from Registry values
  local RegistryRead = Registry(RegName)
  Drawer.BackDatoInset              = RegistryRead:GetDouble("Drawer.BackDatoInset",         0.7500)
  Drawer.BackLength                 = RegistryRead:GetDouble("Drawer.BackLength",            18.2500)
  Drawer.BackThickness              = RegistryRead:GetDouble("Drawer.BackThickness",         0.5000)
  Drawer.BackWidth                  = RegistryRead:GetDouble("Drawer.BackWidth",             5.2500)
  Drawer.BottomDatoInset            = RegistryRead:GetDouble("Drawer.BottomDatoInset",       0.3750)
  Drawer.BottomGap                  = RegistryRead:GetDouble("Drawer.BottomGap",             0.5000)
  Drawer.BottomPanelLength          = RegistryRead:GetDouble("Drawer.BottomPanelLength",     18.2500)
  Drawer.BottomPanelWidth           = RegistryRead:GetDouble("Drawer.BottomPanelWidth",      5.2500)
  Drawer.BottomThickness            = RegistryRead:GetDouble("Drawer.BottomThickness",       0.2500)
  Drawer.Count                      = RegistryRead:GetInt("Drawer.Count",                    1)
  Drawer.Depth                      = RegistryRead:GetDouble("Drawer.Depth",                 18.0000)
  Drawer.FrontLength                = RegistryRead:GetDouble("Drawer.FrontLength",           18.2500)
  Drawer.FrontThickness             = RegistryRead:GetDouble("Drawer.FrontThickness",        0.5000)
  Drawer.FrontWidth                 = RegistryRead:GetDouble("Drawer.FrontWidth",            1.2500)
  Drawer.Height                     = RegistryRead:GetDouble("Drawer.Height",                6.0000)
  Drawer.Length                     = RegistryRead:GetDouble("Drawer.Length",                16.0000)
  Drawer.OpeningDepth               = RegistryRead:GetDouble("Drawer.OpeningDepth",          18.0000)
  Drawer.OpeningHeight              = RegistryRead:GetDouble("Drawer.OpeningHeight",         6.0000)
  Drawer.OpeningWidth               = RegistryRead:GetDouble("Drawer.OpeningWidth",          16.0000)
  Drawer.SideFingerCount            = RegistryRead:GetInt("Drawer.SideFingerCount",          9)
  Drawer.SideFingerWidth            = RegistryRead:GetDouble("Drawer.SideFingerWidth",       0.5000)
  Drawer.SideGap                    = RegistryRead:GetDouble("Drawer.SideGap",               0.5000)
  Drawer.SideLength                 = RegistryRead:GetDouble("Drawer.SideLength",            18.2500)
  Drawer.SideThickness              = RegistryRead:GetDouble("Drawer.SideThickness",         0.5000)
  Drawer.SideWidth                  = RegistryRead:GetDouble("Drawer.SideWidth",             1.2500)
  Drawer.TopGap                     = RegistryRead:GetDouble("Drawer.TopGap",                1.5000)
  Milling.DadoHeight                = RegistryRead:GetDouble("Milling.DadoHeight",           0.2500)
  Milling.FingerClearance           = RegistryRead:GetDouble("Milling.FingerClearance",      0.0050)
  Milling.FingerToolDia             = RegistryRead:GetDouble("Milling.FingerToolDia",        0.1250)
  Milling.FingerToolRadius          = RegistryRead:GetDouble("Milling.FingerToolRadius",     0.0625)
  Milling.LNBackPocket              = RegistryRead:GetString("Milling.LNBackPocket",         "BackPocketProfile")
  Milling.LNBlume                   = RegistryRead:GetString("Milling.LNBlume",              "BlumeMilling")
  Milling.BlumeSoftClose            = RegistryRead:GetString("Milling.BlumeSoftClose",       "Yes")
  Milling.BlumeHole                 = RegistryRead:GetString("Milling.BlumeHole",            "Yes")
  Milling.LNBackProfile             = RegistryRead:GetString("Milling.LNBackProfile",        "BackPanelProfile")
  Milling.LNBottomProfile           = RegistryRead:GetString("Milling.LNBottomProfile",      "Bottom Profile")
  Milling.LNDrawNotes               = RegistryRead:GetString("Milling.LNDrawNotes",          "Drawing Notes")
  Milling.LNFingerBox               = RegistryRead:GetString("Milling.LNFingerBox",          "BoxJoint")
  Milling.LNFrontPocket             = RegistryRead:GetString("Milling.LNFrontPocket",        "Front Panel Pocket")
  Milling.LNFrontProfile            = RegistryRead:GetString("Milling.LNFrontProfile",       "Front Panel Profile")
  Milling.LNPartLabels              = RegistryRead:GetString("Milling.LNPartLabels",         "LabelParts")
  Milling.LNSidePocket              = RegistryRead:GetString("Milling.LNSidePocket",         "Side Panel Pocket")
  Milling.LNSideProfile             = RegistryRead:GetString("Milling.LNSideProfile",        "Side Panel Profile")
  Milling.LNBackPocketColor         = RegistryRead:GetString("Milling.LNBackPocketColor",    "Blue")
  Milling.LNBlumeColor              = RegistryRead:GetString("Milling.LNBlumeColor",         "Black")
  Milling.LNBackProfileColor        = RegistryRead:GetString("Milling.LNBackProfileColor",   "Black")
  Milling.LNBottomProfileColor      = RegistryRead:GetString("Milling.LNBottomProfileColor", "Black")
  Milling.LNDrawNotesColor          = RegistryRead:GetString("Milling.LNDrawNotesColor",     "Blue")
  Milling.LNFingerBoxColor          = RegistryRead:GetString("Milling.LNFingerBoxColor",     "Green")
  Milling.LNFrontPocketColor        = RegistryRead:GetString("Milling.LNFrontPocketColor",   "Green")
  Milling.LNFrontProfileColor       = RegistryRead:GetString("Milling.LNFrontProfileColor",  "Red")
  Milling.LNPartLabelsColor         = RegistryRead:GetString("Milling.LNPartLabelsColor",    "Black")
  Milling.LNSidePocketColor         = RegistryRead:GetString("Milling.LNSidePocketColor",    "Blue")
  Milling.LNSideProfileColor        = RegistryRead:GetString("Milling.LNSideProfileColor",   "Green")
  Milling.PartGap                   = RegistryRead:GetDouble("Milling.PartGap",              0.7500)
  Milling.DadoClearance             = RegistryRead:GetDouble("Milling.DadoClearance",        0.0500)
  Milling.PocketToolDia             = RegistryRead:GetDouble("Milling.PocketToolDia",        0.2500)
  Milling.ProfileToolDia            = RegistryRead:GetDouble("Milling.ProfileToolDia",       0.2500)
  Milling.ProfileToolRadius         = RegistryRead:GetDouble("Milling.ProfileToolRadius",    0.1250)

  Milling.MillTool1.Name            = RegistryRead:GetString("Milling.MillTool1.Name",      "Not Selected")
  Milling.MillTool1.InMM            = RegistryRead:GetBool("Milling.MillTool1.InMM ",        false)
  Milling.MillTool1.ToolDia         = RegistryRead:GetDouble("Milling.MillTool1.ToolDia",    0.1250)
  Milling.MillTool1.Stepdown        = RegistryRead:GetDouble("Milling.MillTool1.Stepdown",   0.2000)
  Milling.MillTool1.Stepover        = RegistryRead:GetDouble("Milling.MillTool1.Stepover",   0.0825)
  Milling.MillTool1.RateUnits       = RegistryRead:GetInt("Milling.MillTool1.RateUnits",     4)
  Milling.MillTool1.FeedRate        = RegistryRead:GetDouble("Milling.MillTool1.FeedRate",   30.000)
  Milling.MillTool1.PlungeRate      = RegistryRead:GetDouble("Milling.illTool1.PlungeRate",  15.000)
  Milling.MillTool1.SpindleSpeed    = RegistryRead:GetInt("Milling.MillTool1.SpindleSpeed",     20000)
  Milling.MillTool1.ToolNumber      = RegistryRead:GetInt("Milling.MillTool1.ToolNumber",     1)

  Milling.MillTool2.Name            = RegistryRead:GetString("Milling.MillTool2.Name",      "Not Selected")
  Milling.MillTool2.InMM            = RegistryRead:GetBool("Milling.MillTool2.InMM ",        false)
  Milling.MillTool2.ToolDia         = RegistryRead:GetDouble("Milling.MillTool2.ToolDia",    0.1250)
  Milling.MillTool2.Stepdown        = RegistryRead:GetDouble("Milling.MillTool2.Stepdown",   0.2000)
  Milling.MillTool2.Stepover        = RegistryRead:GetDouble("Milling.MillTool2.Stepover",   0.0825)
  Milling.MillTool2.RateUnits       = RegistryRead:GetInt("Milling.MillTool2.RateUnits",     4)
  Milling.MillTool2.FeedRate        = RegistryRead:GetDouble("Milling.MillTool2.FeedRate",   30.000)
  Milling.MillTool2.PlungeRate      = RegistryRead:GetDouble("Milling.illTool2.PlungeRate",  15.000)
  Milling.MillTool2.SpindleSpeed    = RegistryRead:GetInt("Milling.MillTool2.SpindleSpeed",     20000)
  Milling.MillTool2.ToolNumber      = RegistryRead:GetInt("Milling.MillTool2.ToolNumber",     2)

  Milling.MillTool3.Name            = RegistryRead:GetString("Milling.MillTool3.Name",      "Not Selected")
  Milling.MillTool3.InMM            = RegistryRead:GetBool("Milling.MillTool3.InMM ",        false)
  Milling.MillTool3.ToolDia         = RegistryRead:GetDouble("Milling.MillTool3.ToolDia",    0.1250)
  Milling.MillTool3.Stepdown        = RegistryRead:GetDouble("Milling.MillTool3.Stepdown",   0.2000)
  Milling.MillTool3.Stepover        = RegistryRead:GetDouble("Milling.MillTool3.Stepover",   0.0825)
  Milling.MillTool3.RateUnits       = RegistryRead:GetInt("Milling.MillTool3.RateUnits",     4)
  Milling.MillTool3.FeedRate        = RegistryRead:GetDouble("Milling.MillTool3.FeedRate",   30.000)
  Milling.MillTool3.PlungeRate      = RegistryRead:GetDouble("Milling.illTool3.PlungeRate",  15.000)
  Milling.MillTool3.SpindleSpeed    = RegistryRead:GetInt("Milling.MillTool3.SpindleSpeed",     20000)
  Milling.MillTool3.ToolNumber      = RegistryRead:GetInt("Milling.MillTool3.ToolNumber",     3)

  Milling.MillTool4.Name            = RegistryRead:GetString("Milling.MillTool4.Name",      "Not Selected")
  Milling.MillTool4.InMM            = RegistryRead:GetBool("Milling.MillTool4.InMM ",        false)
  Milling.MillTool4.ToolDia         = RegistryRead:GetDouble("Milling.MillTool4.ToolDia",    0.1250)
  Milling.MillTool4.Stepdown        = RegistryRead:GetDouble("Milling.MillTool4.Stepdown",   0.2000)
  Milling.MillTool4.Stepover        = RegistryRead:GetDouble("Milling.MillTool4.Stepover",   0.0825)
  Milling.MillTool4.RateUnits       = RegistryRead:GetInt("Milling.MillTool4.RateUnits",     4)
  Milling.MillTool4.FeedRate        = RegistryRead:GetDouble("Milling.MillTool4.FeedRate",   30.000)
  Milling.MillTool4.PlungeRate      = RegistryRead:GetDouble("Milling.illTool4.PlungeRate",  15.000)
  Milling.MillTool4.SpindleSpeed    = RegistryRead:GetInt("Milling.MillTool4.SpindleSpeed",     20000)
  Milling.MillTool4.ToolNumber      = RegistryRead:GetInt("Milling.MillTool4.ToolNumber",     4)

  Milling.MillTool5.Name            = RegistryRead:GetString("Milling.MillTool5.Name",      "Not Selected")
  Milling.MillTool5.InMM            = RegistryRead:GetBool("Milling.MillTool5.InMM ",        false)
  Milling.MillTool5.ToolDia         = RegistryRead:GetDouble("Milling.MillTool5.ToolDia",    0.1250)
  Milling.MillTool5.Stepdown        = RegistryRead:GetDouble("Milling.MillTool5.Stepdown",   0.2000)
  Milling.MillTool5.Stepover        = RegistryRead:GetDouble("Milling.MillTool5.Stepover",   0.0825)
  Milling.MillTool5.RateUnits       = RegistryRead:GetInt("Milling.MillTool5.RateUnits",     4)
  Milling.MillTool5.FeedRate        = RegistryRead:GetDouble("Milling.MillTool5.FeedRate",   30.000)
  Milling.MillTool5.PlungeRate      = RegistryRead:GetDouble("Milling.illTool5.PlungeRate",  15.000)
  Milling.MillTool5.SpindleSpeed    = RegistryRead:GetInt("Milling.MillTool5.SpindleSpeed",     20000)
  Milling.MillTool5.ToolNumber      = RegistryRead:GetInt("Milling.MillTool5.ToolNumber",     5)

  Milling.MillTool6.Name            = RegistryRead:GetString("Milling.MillTool6.Name",      "Not Selected")
  Milling.MillTool6.InMM            = RegistryRead:GetBool("Milling.MillTool6.InMM ",        false)
  Milling.MillTool6.ToolDia         = RegistryRead:GetDouble("Milling.MillTool6.ToolDia",    0.1250)
  Milling.MillTool6.Stepdown        = RegistryRead:GetDouble("Milling.MillTool6.Stepdown",   0.2000)
  Milling.MillTool6.Stepover        = RegistryRead:GetDouble("Milling.MillTool6.Stepover",   0.0825)
  Milling.MillTool6.RateUnits       = RegistryRead:GetInt("Milling.MillTool6.RateUnits",     4)
  Milling.MillTool6.FeedRate        = RegistryRead:GetDouble("Milling.MillTool6.FeedRate",   30.000)
  Milling.MillTool6.PlungeRate      = RegistryRead:GetDouble("Milling.illTool6.PlungeRate",  15.000)
  Milling.MillTool6.SpindleSpeed    = RegistryRead:GetInt("Milling.MillTool6.SpindleSpeed",     20000)
  Milling.MillTool6.ToolNumber      = RegistryRead:GetInt("Milling.MillTool6.ToolNumber",     6)

  Project.CodeBy                    = RegistryRead:GetString("Project.CodeBy",               "JimAndi Gadgets")
  Project.DatFile                   = RegistryRead:GetString("Project.DatFile",              "Default")
  Project.DrawerName                = RegistryRead:GetString("Project.DrawerName",           "C1")
  Project.ProgramContact            = RegistryRead:GetString("Project.ProgramContact",       "Who")
  Project.ProgramName               = RegistryRead:GetString("Project.ProgramName",          "Easy Drawer Maker")
  Project.ProgramVersion            = RegistryRead:GetString("Project.ProgramVersion",       string.format(Project.ProgramVersion))
  Project.ProgramYear               = RegistryRead:GetString("Project.ProgramYear",          "2020")
  Project.ContactEmail              = RegistryRead:GetString("Project.ContactEmail",         "Default@Email.com")
  Project.ContactName               = RegistryRead:GetString("Project.ContactName",          "Default")
  Project.ContactPhoneNumber        = RegistryRead:GetString("Project.ContactPhoneNumber",   "(123)456-7890")
  Project.ProjectName               = RegistryRead:GetString("Project.ProjectName",          "DRAWER PROJECTS")
  Project.ProjectPath               = RegistryRead:GetString("Project.ProjectPath",          "Default")
  DialogWindow.ProjectXY            = RegistryRead:GetString("DialogWindow.ProjectPath",     " x ")
  DialogWindow.MillingXY            = RegistryRead:GetString("DialogWindow.MillingXY",       " x ")
  DialogWindow.AboutXY              = RegistryRead:GetString("DialogWindow.AboutXY",         " x ")
  DialogWindow.DrawerXY             = RegistryRead:GetString("DialogWindow.DrawerXY",        " x ")
  return true
end
-- =====================================================]]
function REG_UpdateRegistry()                           -- Write to Registry values
  local RegistryWrite = Registry(RegName)
  local RegValue = RegistryWrite:SetString("Milling.LNBackPocket",              Milling.LNBackPocket)
        RegValue = RegistryWrite:SetString("Milling.LNBackProfile",             Milling.LNBackProfile)
        RegValue = RegistryWrite:SetString("Milling.LNBottomProfile",           Milling.LNBottomProfile)
        RegValue = RegistryWrite:SetString("Milling.LNSideProfile",             Milling.LNSideProfile)
        RegValue = RegistryWrite:SetString("Milling.LNSidePocket",              Milling.LNSidePocket)
        RegValue = RegistryWrite:SetString("Milling.LNFrontProfile",            Milling.LNFrontProfile)
        RegValue = RegistryWrite:SetString("Milling.LNFrontPocket",             Milling.LNFrontPocket)
        RegValue = RegistryWrite:SetString("Milling.LNDrawNotes",               Milling.LNDrawNotes)
        RegValue = RegistryWrite:SetString("Milling.LNPartLabels",              Milling.LNPartLabels)
        RegValue = RegistryWrite:SetString("Milling.LNFingerBox",               Milling.LNFingerBox)
        RegValue = RegistryWrite:SetString("Milling.LNFingerBox",               Milling.LNFingerBox)
        RegValue = RegistryWrite:SetString("Milling.LNBackPocketColor",         Milling.LNBackPocketColor)
        RegValue = RegistryWrite:SetString("Milling.LNBackProfileColor",        Milling.LNBackProfileColor)
        RegValue = RegistryWrite:SetString("Milling.LNBottomProfileColor",      Milling.LNBottomProfileColor)
        RegValue = RegistryWrite:SetString("Milling.LNSideProfileColor",        Milling.LNSideProfileColor)
        RegValue = RegistryWrite:SetString("Milling.LNSidePocketColor",         Milling.LNSidePocketColor)
        RegValue = RegistryWrite:SetString("Milling.LNFrontProfileColor",       Milling.LNFrontProfileColor)
        RegValue = RegistryWrite:SetString("Milling.LNFrontPocketColor",        Milling.LNFrontPocketColor)
        RegValue = RegistryWrite:SetString("Milling.LNDrawNotesColor",          Milling.LNDrawNotesColor)
        RegValue = RegistryWrite:SetString("Milling.LNPartLabelsColor",         Milling.LNPartLabelsColor)
        RegValue = RegistryWrite:SetString("Milling.LNFingerBoxColor",          Milling.LNFingerBoxColor)
        RegValue = RegistryWrite:SetString("Milling.LNBlumeColor",              Milling.LNBlumeColor)
        RegValue = RegistryWrite:SetString("Milling.LNBlume",                   Milling.LNBlume)  -- Yes or No
        RegValue = RegistryWrite:SetString("Milling.BlumeHole",                Milling.BlumeHole)
        RegValue = RegistryWrite:SetString("Milling.BlumeSoftClose",            Milling.BlumeSoftClose)
        RegValue = RegistryWrite:SetDouble("Milling.PartGap",                   Milling.PartGap)
        RegValue = RegistryWrite:SetDouble("Milling.PocketToolDia",             Milling.PocketToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.FingerToolDia",             Milling.FingerToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.ProfileToolDia",            Milling.ProfileToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.DadoClearance",           Milling.DadoClearance)
        RegValue = RegistryWrite:SetDouble("Milling.FingerClearance",           Milling.FingerClearance)
        RegValue = RegistryWrite:SetDouble("Milling.DadoHeight" ,               Milling.DadoHeight)

        RegValue = RegistryWrite:SetString("Milling.MillTool1.Name",            Milling.MillTool1.Name)
        RegValue = RegistryWrite:SetBool(  "Milling.MillTool1.InMM",            Milling.MillTool1.InMM)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool1.ToolDia" ,        Milling.MillTool1.ToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool1.Stepdown" ,       Milling.MillTool1.Stepdown)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool1.Stepover" ,       Milling.MillTool1.Stepover)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool1.RateUnits",       Milling.MillTool1.RateUnits)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool1.FeedRate" ,       Milling.MillTool1.FeedRate)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool1.PlungeRate" ,     Milling.MillTool1.PlungeRate)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool1.SpindleSpeed",    Milling.MillTool1.SpindleSpeed)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool1.ToolNumber",      Milling.MillTool1.ToolNumber)

        RegValue = RegistryWrite:SetString("Milling.MillTool2.Name",            Milling.MillTool2.Name)
        RegValue = RegistryWrite:SetBool(  "Milling.MillTool2.InMM",            Milling.MillTool2.InMM)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool2.ToolDia" ,        Milling.MillTool2.ToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool2.Stepdown" ,       Milling.MillTool2.Stepdown)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool2.Stepover" ,       Milling.MillTool2.Stepover)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool2.RateUnits",       Milling.MillTool2.RateUnits)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool2.FeedRate" ,       Milling.MillTool2.FeedRate)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool2.PlungeRate" ,     Milling.MillTool2.PlungeRate)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool2.SpindleSpeed",    Milling.MillTool2.SpindleSpeed)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool2.ToolNumber",      Milling.MillTool2.ToolNumber)

        RegValue = RegistryWrite:SetString("Milling.MillTool3.Name",            Milling.MillTool3.Name)
        RegValue = RegistryWrite:SetBool(  "Milling.MillTool3.InMM",            Milling.MillTool3.InMM)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool3.ToolDia" ,        Milling.MillTool3.ToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool3.Stepdown" ,       Milling.MillTool3.Stepdown)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool3.Stepover" ,       Milling.MillTool3.Stepover)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool3.RateUnits",       Milling.MillTool3.RateUnits)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool3.FeedRate" ,       Milling.MillTool3.FeedRate)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool3.PlungeRate" ,     Milling.MillTool3.PlungeRate)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool3.SpindleSpeed",    Milling.MillTool3.SpindleSpeed)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool3.ToolNumber",      Milling.MillTool3.ToolNumber)

        RegValue = RegistryWrite:SetString("Milling.MillTool4.Name",            Milling.MillTool4.Name)
        RegValue = RegistryWrite:SetBool(  "Milling.MillTool4.InMM",            Milling.MillTool4.InMM)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool4.ToolDia" ,        Milling.MillTool4.ToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool4.Stepdown" ,       Milling.MillTool4.Stepdown)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool4.Stepover" ,       Milling.MillTool4.Stepover)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool4.RateUnits",       Milling.MillTool4.RateUnits)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool4.FeedRate" ,       Milling.MillTool4.FeedRate)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool4.PlungeRate" ,     Milling.MillTool4.PlungeRate)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool4.SpindleSpeed",    Milling.MillTool4.SpindleSpeed)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool4.ToolNumber",      Milling.MillTool4.ToolNumber)

        RegValue = RegistryWrite:SetString("Milling.MillTool5.Name",            Milling.MillTool5.Name)
        RegValue = RegistryWrite:SetBool(  "Milling.MillTool5.InMM",            Milling.MillTool5.InMM)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool5.ToolDia" ,        Milling.MillTool5.ToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool5.Stepdown" ,       Milling.MillTool5.Stepdown)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool5.Stepover" ,       Milling.MillTool5.Stepover)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool5.RateUnits",       Milling.MillTool5.RateUnits)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool5.FeedRate" ,       Milling.MillTool5.FeedRate)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool5.PlungeRate" ,     Milling.MillTool5.PlungeRate)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool5.SpindleSpeed",    Milling.MillTool5.SpindleSpeed)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool5.ToolNumber",      Milling.MillTool5.ToolNumber)

        RegValue = RegistryWrite:SetString("Milling.MillTool6.Name",            Milling.MillTool6.Name)
        RegValue = RegistryWrite:SetBool(  "Milling.MillTool6.InMM",            Milling.MillTool6.InMM)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool6.ToolDia" ,        Milling.MillTool6.ToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool6.Stepdown" ,       Milling.MillTool6.Stepdown)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool6.Stepover" ,       Milling.MillTool6.Stepover)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool6.RateUnits",       Milling.MillTool6.RateUnits)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool6.FeedRate" ,       Milling.MillTool6.FeedRate)
        RegValue = RegistryWrite:SetDouble("Milling.MillTool6.PlungeRate" ,     Milling.MillTool6.PlungeRate)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool6.SpindleSpeed",    Milling.MillTool6.SpindleSpeed)
        RegValue = RegistryWrite:SetInt(   "Milling.MillTool6.ToolNumber",      Milling.MillTool6.ToolNumber)

        RegValue = RegistryWrite:SetString("Project.DrawerName",                Project.DrawerName)
        RegValue = RegistryWrite:SetString("Project.CodeBy",                    Project.CodeBy)
        RegValue = RegistryWrite:SetString("Project.ProgramContact",            Project.ProgramContact)
        RegValue = RegistryWrite:SetString("Project.ProgramName",               Project.ProgramName)
        RegValue = RegistryWrite:SetString("Project.ProgramVersion",            Project.ProgramVersion)
        RegValue = RegistryWrite:SetString("Project.ProgramYear",               Project.ProgramYear)
        RegValue = RegistryWrite:SetString("Project.ContactEmail",              Project.ContactEmail)
        RegValue = RegistryWrite:SetString("Project.ContactName",               Project.ContactName)
        RegValue = RegistryWrite:SetString("Project.ContactPhoneNumber",        Project.ContactPhoneNumber)
        RegValue = RegistryWrite:SetString("Project.ProjectName",               Project.ProjectName)
        RegValue = RegistryWrite:SetString("Project.ProjectPath",               Project.ProjectPath)
        RegValue = RegistryWrite:SetString("Project.DatFile",                   Project.DatFile)
        RegValue = RegistryWrite:SetDouble("Drawer.OpeningDepth",               Drawer.OpeningDepth)
        RegValue = RegistryWrite:SetDouble("Drawer.OpeningHeight",              Drawer.OpeningHeight)
        RegValue = RegistryWrite:SetDouble("Drawer.OpeningWidth",              Drawer.OpeningWidth)
        RegValue = RegistryWrite:SetDouble("Drawer.Depth",                      Drawer.Depth)
        RegValue = RegistryWrite:SetDouble("Drawer.Height",                     Drawer.Height)
        RegValue = RegistryWrite:SetDouble("Drawer.Length",                     Drawer.Length)
        RegValue = RegistryWrite:SetInt("Drawer.Count",                         Drawer.Count)
        RegValue = RegistryWrite:SetInt("Drawer.SideFingerCount",               Drawer.SideFingerCount)
        RegValue = RegistryWrite:SetDouble("Drawer.SideFingerWidth",            Drawer.SideFingerWidth)
        RegValue = RegistryWrite:SetDouble("Drawer.BottomDatoInset",            Drawer.BottomDatoInset)
        RegValue = RegistryWrite:SetDouble("Drawer.BackDatoInset",              Drawer.BackDatoInset)
        RegValue = RegistryWrite:SetDouble("Drawer.BottomThickness",            Drawer.BottomThickness)
        RegValue = RegistryWrite:SetDouble("Drawer.SideWidth",                  Drawer.SideWidth)
        RegValue = RegistryWrite:SetDouble("Drawer.SideThickness",              Drawer.SideThickness)
        RegValue = RegistryWrite:SetDouble("Drawer.FrontThickness",             Drawer.FrontThickness)
        RegValue = RegistryWrite:SetDouble("Drawer.FrontWidth",                 Drawer.FrontWidth)
        RegValue = RegistryWrite:SetDouble("Drawer.BackThickness",              Drawer.BackThickness)
        RegValue = RegistryWrite:SetDouble("Drawer.BackWidth",                  Drawer.BackWidth)
        RegValue = RegistryWrite:SetDouble("Drawer.SideGap",                    Drawer.SideGap)
        RegValue = RegistryWrite:SetDouble("Drawer.BottomGap",                  Drawer.BottomGap)
        RegValue = RegistryWrite:SetDouble("Drawer.TopGap",                     Drawer.TopGap)
        RegValue = RegistryWrite:SetDouble("Drawer.SideLength",                 Drawer.SideLength)
        RegValue = RegistryWrite:SetDouble("Drawer.BackLength",                 Drawer.BackLength)
        RegValue = RegistryWrite:SetDouble("Drawer.FrontLength",                Drawer.FrontLength)
        RegValue = RegistryWrite:SetDouble("Drawer.BottomPanelLength",          Drawer.BottomPanelLength)
        RegValue = RegistryWrite:SetDouble("Drawer.BottomPanelWidth",           Drawer.BottomPanelWidth)
        RegValue = RegistryWrite:SetString("DialogWindow.ProjectXY",            DialogWindow.ProjectXY)
        RegValue = RegistryWrite:SetString("DialogWindow.MillingXY",            DialogWindow.MillingXY)
        RegValue = RegistryWrite:SetString("DialogWindow.AboutXY",              DialogWindow.AboutXY)
        RegValue = RegistryWrite:SetString("DialogWindow.LayersXY",             DialogWindow.LayersXY)
        RegValue = RegistryWrite:SetString("DialogWindow.DrawerXY",             DialogWindow.DrawerXY)
  return true
  end
-- =====================================================]]
function OnLuaButton_InquiryTooling()
  Milling.MillTool1.Name = "Not Selected"
  Milling.MillTool2.Name = "Not Selected"
  Milling.MillTool3.Name = "Not Selected"
  Milling.MillTool4.Name = "Not Selected"
  Milling.MillTool5.Name = "Not Selected"
  Milling.MillTool6.Name = "Not Selected"
  Drawer.dialog:UpdateLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  Drawer.dialog:UpdateLabelField("ToolNameLabel2", Milling.MillTool2.Name)
  Drawer.dialog:UpdateLabelField("ToolNameLabel3", Milling.MillTool3.Name)
  Drawer.dialog:UpdateLabelField("ToolNameLabel4", Milling.MillTool4.Name)
  Drawer.dialog:UpdateLabelField("ToolNameLabel5", Milling.MillTool5.Name)
  Drawer.dialog:UpdateLabelField("ToolNameLabel6", Milling.MillTool6.Name)
  REG_UpdateRegistry()
  return true
end
-- =====================================================]]
function InquiryDrawer(Header)
  Drawer.dialog = HTML_Dialog(true, DialogWindow.myHtml1, 582, 481,  Header)
  if Project.ProjectPath == "Default"  then
    Drawer.dialog:AddLabelField("Alert", "Project Path is required")
  else
    Drawer.dialog:AddLabelField("Alert", "")
  end
  Drawer.dialog:AddIntegerField("Drawer.SideFingerCount", Drawer.SideFingerCount)
  Drawer.dialog:AddDoubleField("Drawer.OpeningHeight",    Drawer.OpeningHeight)
  Drawer.dialog:AddDoubleField("Drawer.OpeningDepth",     Drawer.OpeningDepth)
  Drawer.dialog:AddDoubleField("Drawer.OpeningWidth",     Drawer.OpeningWidth)
  Drawer.dialog:AddDoubleField("Drawer.SideThickness",    Drawer.SideThickness)
  Drawer.dialog:AddDoubleField("Drawer.BackThickness",    Drawer.BackThickness)
  Drawer.dialog:AddDoubleField("Drawer.FrontThickness",   Drawer.FrontThickness)
  Drawer.dialog:AddDoubleField("Drawer.BottomThickness",  Drawer.BottomThickness)
  Drawer.dialog:AddDoubleField("Drawer.SideGap",          Drawer.SideGap)
  Drawer.dialog:AddDoubleField("Drawer.TopGap",           Drawer.TopGap)
  Drawer.dialog:AddDoubleField("Drawer.BottomGap",        Drawer.BottomGap)
  Drawer.dialog:AddDoubleField("Drawer.Count",            Drawer.Count)
  Drawer.dialog:AddTextField("Project.DrawerName",        Project.DrawerName)

  Drawer.dialog:AddLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  Drawer.dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1) -- Profile
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton1", Tool.END_MILL)

  Drawer.dialog:AddLabelField("ToolNameLabel2", Milling.MillTool2.Name)
  Drawer.dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2) -- Dados
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)

  Drawer.dialog:AddLabelField("ToolNameLabel3", Milling.MillTool3.Name)
  Drawer.dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3) -- Dado Clearing
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton3", Tool.END_MILL)

  Drawer.dialog:AddLabelField("ToolNameLabel4", Milling.MillTool4.Name)
  Drawer.dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID4) -- Finger
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton4", Tool.END_MILL)

  Drawer.dialog:AddLabelField("ToolNameLabel5", Milling.MillTool5.Name)
  Drawer.dialog:AddToolPicker("ToolChooseButton5", "ToolNameLabel5", Tool_ID5) -- Finger Clearing
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton5", Tool.END_MILL)

  Drawer.dialog:AddLabelField("ToolNameLabel6", Milling.MillTool6.Name)
  Drawer.dialog:AddToolPicker("ToolChooseButton6", "ToolNameLabel6", Tool_ID6) -- Blume Circle
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton6", Tool.END_MILL)

  if Drawer.dialog:ShowDialog() then
    Drawer.SideFingerCount = math.abs(Drawer.dialog:GetIntegerField("Drawer.SideFingerCount"))
    Drawer.OpeningHeight   = math.abs(Drawer.dialog:GetDoubleField("Drawer.OpeningHeight"))
    Drawer.OpeningDepth    = math.abs(Drawer.dialog:GetDoubleField("Drawer.OpeningDepth"))
    Drawer.OpeningWidth    = math.abs(Drawer.dialog:GetDoubleField("Drawer.OpeningWidth"))
    Drawer.SideThickness   = math.abs(Drawer.dialog:GetDoubleField("Drawer.SideThickness"))
    Drawer.BackThickness   = math.abs(Drawer.dialog:GetDoubleField("Drawer.BackThickness"))
    Drawer.FrontThickness  = math.abs(Drawer.dialog:GetDoubleField("Drawer.FrontThickness"))
    Drawer.BottomThickness = math.abs(Drawer.dialog:GetDoubleField("Drawer.BottomThickness"))
    Drawer.SideGap         = math.abs(Drawer.dialog:GetDoubleField("Drawer.SideGap"))
    Drawer.TopGap          = math.abs(Drawer.dialog:GetDoubleField("Drawer.TopGap"))
    Drawer.BottomGap       = math.abs(Drawer.dialog:GetDoubleField("Drawer.BottomGap"))
    Drawer.Count           = math.abs(Drawer.dialog:GetDoubleField("Drawer.Count"))
    Project.DrawerName     = All_Trim(Drawer.dialog:GetTextField("Project.DrawerName"))
    if Drawer.dialog:GetTool("ToolChooseButton1") then
      Milling.MillTool1   = Drawer.dialog:GetTool("ToolChooseButton1")  -- Profile
    end
    if Drawer.dialog:GetTool("ToolChooseButton2") then
      Milling.MillTool2   = Drawer.dialog:GetTool("ToolChooseButton2")  -- Dados
    end
    if Drawer.dialog:GetTool("ToolChooseButton3") then
      Milling.MillTool3   = Drawer.dialog:GetTool("ToolChooseButton3")  -- Dado Clearing
    end
    if Drawer.dialog:GetTool("ToolChooseButton4") then
      Milling.MillTool4   = Drawer.dialog:GetTool("ToolChooseButton4")  -- Finger
    end
    if Drawer.dialog:GetTool("ToolChooseButton5") then
      Milling.MillTool5   = Drawer.dialog:GetTool("ToolChooseButton5")  -- Finger Clearing
    end
    if Drawer.dialog:GetTool("ToolChooseButton6") then
      Milling.MillTool6   = Drawer.dialog:GetTool("ToolChooseButton6")  -- Blume Circles
    end
    DialogWindow.DrawerXY = tostring(Drawer.dialog.WindowWidth) .. " x " ..  tostring(Drawer.dialog.WindowHeight)
    if Drawer.SideFingerCount < 3 then
      Drawer.SideFingerCount = 3
    end
    if Drawer.Count == 0 then
      Drawer.Count = 1
    end
    Drawer_Math()
    REG_UpdateRegistry()
    return  true
  else
    return  false
  end
end
-- =====================================================]]
function OnLuaButton_InquiryProjectInfo()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml3, 591, 300, "Project  Setup") ;
  dialog:AddTextField("Project.ProjectName",        Project.ProjectName) ;
  dialog:AddTextField("Project.ContactEmail",       Project.ContactEmail) ;
  dialog:AddTextField("Project.ContactName",        Project.ContactName) ;
  dialog:AddTextField("Project.ContactPhoneNumber", Project.ContactPhoneNumber) ;
  dialog:AddTextField("Project.DrawerID",           StartDate()) ;
  dialog:AddTextField("Project.ProjectPath",        Project.ProjectPath ) ;
  dialog:AddDirectoryPicker("DirectoryPicker",      "Project.ProjectPath" , true) ;
  if dialog:ShowDialog() then
    Project.ProjectName         = All_Trim(dialog:GetTextField("Project.ProjectName"))
    Project.ContactEmail        = All_Trim(dialog:GetTextField("Project.ContactEmail"))
    Project.ContactName         = All_Trim(dialog:GetTextField("Project.ContactName"))
    Project.ContactPhoneNumber  = All_Trim(dialog:GetTextField("Project.ContactPhoneNumber"))
    Project.DrawerID            = All_Trim(dialog:GetTextField("Project.DrawerID"))
    Project.ProjectPath         = All_Trim(dialog:GetTextField("Project.ProjectPath"))
    DialogWindow.ProjectXY      = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    REG_UpdateRegistry()
    if not(Project.ProjectPath == "Default") then
      Drawer.dialog:UpdateLabelField("Alert", "")
    else
      Drawer.dialog:UpdateLabelField("Alert", "Error: Project Path is set to Default")
    end
  end
  return  true
end
-- =====================================================]]
function OnLuaButton_InquiryLayers()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, 648, 403, "Layer Setup") ;
  dialog:AddTextField("Milling.LNBottomProfile",         Milling.LNBottomProfile)
  dialog:AddTextField("Milling.LNSideProfile",           Milling.LNSideProfile)
  dialog:AddTextField("Milling.LNSidePocket",            Milling.LNSidePocket)
  dialog:AddTextField("Milling.LNFrontProfile",          Milling.LNFrontProfile)
  dialog:AddTextField("Milling.LNFrontPocket",           Milling.LNFrontPocket)
  dialog:AddTextField("Milling.LNBackProfile",           Milling.LNBackProfile)
  dialog:AddTextField("Milling.LNBackPocket",            Milling.LNBackPocket)
  dialog:AddTextField("Milling.LNDrawNotes",             Milling.LNDrawNotes)
  dialog:AddTextField("Milling.LNPartLabels",            Milling.LNPartLabels)
  dialog:AddTextField("Milling.LNBlume",                 Milling.LNBlume)
  dialog:AddDropDownList("Milling.LNBlumeColor",         Milling.LNBlumeColor)
  dialog:AddDropDownList("Milling.LNBottomProfileColor", Milling.LNBottomProfileColor)
  dialog:AddDropDownList("Milling.LNSideProfileColor",   Milling.LNSideProfileColor)
  dialog:AddDropDownList("Milling.LNSidePocketColor",    Milling.LNSidePocketColor)
  dialog:AddDropDownList("Milling.LNFrontProfileColor",  Milling.LNFrontProfileColor)
  dialog:AddDropDownList("Milling.LNFrontPocketColor",   Milling.LNFrontPocketColor)
  dialog:AddDropDownList("Milling.LNBackProfileColor",   Milling.LNBackProfileColor)
  dialog:AddDropDownList("Milling.LNBackPocketColor",    Milling.LNBackPocketColor)
  dialog:AddDropDownList("Milling.LNDrawNotesColor",     Milling.LNDrawNotesColor)
  dialog:AddDropDownList("Milling.LNPartLabelsColor",    Milling.LNPartLabelsColor)
  if  dialog:ShowDialog() then
    Milling.LNBottomProfile      = All_Trim(dialog:GetTextField("Milling.LNBottomProfile"))
    Milling.LNSideProfile        = All_Trim(dialog:GetTextField("Milling.LNSideProfile"))
    Milling.LNSidePocket         = All_Trim(dialog:GetTextField("Milling.LNSidePocket"))
    Milling.LNFrontProfile       = All_Trim(dialog:GetTextField("Milling.LNFrontProfile"))
    Milling.LNFrontPocket        = All_Trim(dialog:GetTextField("Milling.LNFrontPocket"))
    Milling.LNBackProfile        = All_Trim(dialog:GetTextField("Milling.LNBackProfile"))
    Milling.LNBackPocket         = All_Trim(dialog:GetTextField("Milling.LNBackPocket"))
    Milling.LNDrawNotes          = All_Trim(dialog:GetTextField("Milling.LNDrawNotes"))
    Milling.LNPartLabels         = All_Trim(dialog:GetTextField("Milling.LNPartLabels"))
    Milling.LNBlume              = All_Trim(dialog:GetTextField("Milling.LNBlume"))
    Milling.LNBlumeColor         = dialog:GetDropDownListValue("Milling.LNBlumeColor")
    Milling.LNBottomProfileColor = dialog:GetDropDownListValue("Milling.LNBottomProfileColor")
    Milling.LNSideProfileColor   = dialog:GetDropDownListValue("Milling.LNSideProfileColor")
    Milling.LNSidePocketColor    = dialog:GetDropDownListValue("Milling.LNSidePocketColor")
    Milling.LNFrontProfileColor  = dialog:GetDropDownListValue("Milling.LNFrontProfileColor")
    Milling.LNFrontPocketColor   = dialog:GetDropDownListValue("Milling.LNFrontPocketColor")
    Milling.LNBackProfileColor   = dialog:GetDropDownListValue("Milling.LNBackProfileColor")
    Milling.LNBackPocketColor    = dialog:GetDropDownListValue("Milling.LNBackPocketColor")
    Milling.LNDrawNotesColor     = dialog:GetDropDownListValue("Milling.LNDrawNotesColor")
    Milling.LNPartLabelsColor    = dialog:GetDropDownListValue("Milling.LNPartLabelsColor")
    DialogWindow.LayersXY = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml5 , 720, 468, "About")
  dialog:AddLabelField("SysName", Project.ProgramName)
  dialog:AddLabelField("Version", "Version: " .. Project.ProgramVersion)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
  REG_UpdateRegistry()
  return  true
end
-- =====================================================]]
function OnLuaButton_InquiryMilling()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml4, 560, 214, "Milling Setting ")
  dialog:AddDoubleField("Milling.DadoClearance", Milling.DadoClearance)
  dialog:AddDoubleField("Milling.DadoHeight",      Milling.DadoHeight)
  dialog:AddDoubleField("Milling.PartGap",         Milling.PartGap)
  dialog:AddDoubleField("Milling.FingerClearance", Milling.FingerClearance)
  dialog:AddDoubleField("Milling.ProfileToolDia",  Milling.ProfileToolDia)
  dialog:AddDoubleField("Milling.FingerToolDia",   Milling.FingerToolDia)
  dialog:AddDropDownList("Milling.BlumeSoftClose", Milling.BlumeSoftClose)
  dialog:AddDropDownList("Milling.BlumeHole",      Milling.BlumeHole)

  if dialog:ShowDialog() then
    Milling.DadoClearance   = dialog:GetDoubleField("Milling.DadoClearance")
    Milling.FingerClearance = dialog:GetDoubleField("Milling.FingerClearance")
    Milling.DadoHeight      = math.abs(dialog:GetDoubleField("Milling.DadoHeight"))
    Milling.PartGap         = math.abs(dialog:GetDoubleField("Milling.PartGap"))
    Milling.ProfileToolDia  = math.abs(dialog:GetDoubleField("Milling.ProfileToolDia"))
    Milling.FingerToolDia   = math.abs(dialog:GetDoubleField("Milling.FingerToolDia"))
    Milling.BlumeSoftClose  = dialog:GetDropDownListValue("Milling.BlumeSoftClose")
    Milling.BlumeHole       = dialog:GetDropDownListValue("Milling.BlumeHole")
    DialogWindow.MillingXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
function StringChecks()
  local MyTrue = false
  if Milling.LNBottomProfile == "" then
    MessageBox("Error: Bottom Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif  Milling.LNSideProfile  == "" then
    MessageBox("Error: Side Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif  Milling.LNSidePocket  == "" then
    MessageBox("Error: Side Pocket layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNFrontProfile == "" then
    MessageBox("Error: Front Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNFrontPocket  == "" then
    MessageBox("Error: Front Pocket layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNBackProfile  == "" then
    MessageBox("Error: Back Profile layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNBackPocket == "" then
    MessageBox("Error: Back Pocket layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNDrawNotes == "" then
    MessageBox("Error: Draw Notes layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNPartLabels == "" then
    MessageBox("Error: Part Lables layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Milling.LNBlume == "" then
    MessageBox("Error: Blume layer name cannot be blank")
    OnLuaButton_InquiryLayers()
  elseif Project.ProjectName == "" then
    MessageBox("Error: Project Name cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ContactEmail  == "" then
    MessageBox("Error: Contact Email cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ContactName == "" then
    MessageBox("Error: Contact Name cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ContactPhoneNumber == "" then
    MessageBox("Error: Project Name cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.DrawerID == "" then
    MessageBox("Error: Contact Phone Number cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  elseif Project.ProjectPath == "" then
    MessageBox("Error: Project Path cannot be blank")
    OnLuaButton_InquiryProjectInfo()
  else
    MyTrue = true
  end -- if end
  return MyTrue
end -- function end
-- =====================================================]]
function main(script_path) -- script_path
  Milling.job = VectricJob()
  if not Milling.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  Tools = assert(loadfile(script_path .. "\\EasyDrawerToolsVer03.4.xlua")) (Tools)
  HTML()
  GetMaterialSettings()
  REG_ReadRegistry()
  Drawer_Math()
  local mtl_block = MaterialBlock()
  local mtl_thick = mtl_block.Thickness
  local R1, R2, R3
  local DialogLoop = 1 -- Nope do it again
  while DialogLoop == 1 do
    if InquiryDrawer("Easy Drawer Maker") then
      if Project.ProjectPath == "Default"  then
        MessageBox("Error: Cannot find project setup data. \n Rerun program and setup Project.")
        OnLuaButton_InquiryProjectInfo()
        DialogLoop = 1 -- Nope do it again
      elseif Milling.FingerToolDia == 0 then
        MessageBox("Error: Finger Tool Diameter is too small")
        OnLuaButton_InquiryMilling()
        DialogLoop = 1 -- Nope do it again
      elseif Milling.ProfileToolDia == 0 then
        MessageBox("Error: Profile Tool Diameter is too small")
        OnLuaButton_InquiryMilling()
        DialogLoop = 1 -- Nope do it again
      elseif Project.DrawerName == "" then
        MessageBox("Error: Drawer Name cannot be blank")
        DialogLoop = 1 -- Nope do it again
      elseif Drawer.OpeningDepth < (10 * Drawer.SideThickness) then
        MessageBox("Error: Drawer Opening Depth is too small of value. \nEnter a larger Drawer Depth value or enter a smaller Side Thickness")
        DialogLoop = 1 -- Nope do it again
      elseif (Drawer.SideWidth / Drawer.SideFingerCount) < (Milling.FingerToolDia / 0.70) then
        MessageBox("Error: Number of fingers is to high to alow proper milling. \nReduce the Finger Count to ~" .. tostring(math.ceil(Drawer.SideWidth/(Milling.FingerToolDia / 0.70))) .. " fingers.")
        DialogLoop = 1 -- Nope do it again
      elseif Drawer.SideFingerCount < 1 then
        MessageBox("Error: Drawer Count cannot be less than 1")
        DialogLoop = 1 -- Nope do it again
      elseif not StringChecks() then
      DialogLoop = 1 -- Nope do it again
      elseif Milling.MillTool6 then
        if Milling.MillTool6.ToolDia > Drawer.BlumeDia then
          MessageBox("Error: Bit for Blume Operaction it too large Max Dia = " .. string.format(Drawer.BlumeDia))
          DialogLoop = 1 -- Nope do it again
        else
          DialogLoop = 2 -- Good to Go
        end -- if end
      else
        DialogLoop = 2 -- Good to Go
      end
    else
      DialogLoop = 0  -- pressed Cancel
    end
  end
  if DialogLoop == 2 then
    MyProgressBar = ProgressBar("Drawing Parts", ProgressBar.LINEAR)          -- Setup Type of progress barr
    MyProgressBar:SetPercentProgress(0)                                       -- Sets progress barr to zero
    R1, R2, R3 =   os.rename(Project.ProjectPath, Project.ProjectPath)
    if not(R1) then
      if R3 == 13 then
        DisplayMessageBox("Alert: " .. R2 .. "\nYou may have a file open in the Directory")
      else
        DisplayMessageBox("Error: " .. R2)
        return false
      end
    end -- if not R1
    if Milling.MillTool1.Name == "Not Selected"  then
      Milling.Profile = false
    else
      Milling.Profile = true
    end  -- if end
    if Milling.MillTool2.Name == "Not Selected"  then
      Milling.Dado = false
    else
      Milling.Dado = true
    end  -- if end
    if Milling.MillTool3.Name == "Not Selected"  then
      Milling.DadoClear = false
    else
      Milling.DadoClear = true
    end  -- if end

    if Milling.MillTool4.Name == "Not Selected"  then
      Milling.Finger = false
    else
      Milling.Finger = true
    end  -- if end
    if Milling.MillTool5.Name == "Not Selected"  then
      Milling.FingerClear = false
    else
      Milling.FingerClear = true
    end  -- if end
    if Milling.MillTool6.Name == "Not Selected"  then
      Milling.Blume = false
    else
      Milling.Blume = true
    end  -- if end
    Drawer.Record = (61.0 * Drawer.Count)
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    CutBySheets()
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    Drawer_Math()
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    MakeLayers()
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    -- REG_ReadRegistry()
    if GetAppVersion() < 10.999 then
      StampIt(mtl_thick) -- Job Setup thickness
    end --if end
    CutListfileWriterHeader()
    -- ==== Sheet 1
    Drawer.WP = Point2D(1.0, 1.0)
    if Sheet.Side == 1 then
      NewSheet(Drawer.SideThickness)
    elseif Sheet.Back == 1 then
      NewSheet(Drawer.BackThickness)
    elseif Sheet.Front == 1 then
      NewSheet(Drawer.FrontThickness)
    elseif Sheet.Bottom == 1 then
      NewSheet(Drawer.BottomThickness)
    end
    if Sheet.Side == 1 then
      ProcessSide()
    end
    if Sheet.Bottom == 1 then
      ProcessBottom()
    end
    if Sheet.Front == 1 then
      ProcessFront()
    end
    if Sheet.Back == 1 then
      ProcessBack()
    end
    if Sheet.Side == 2 or Sheet.Back == 2 or Sheet.Front == 2 or Sheet.Bottom == 2 then
      if Sheet.Side == 2 then
        NewSheet(Drawer.SideThickness)
      elseif Sheet.Back == 2 then
        NewSheet(Drawer.BackThickness)
      elseif Sheet.Front == 2 then
        NewSheet(Drawer.FrontThickness)
      elseif Sheet.Bottom == 2 then
        NewSheet(Drawer.BottomThickness)
      end
      if GetAppVersion() > 10.999 then
        Drawer.WP = Point2D(1, Drawer.WP.y + Drawer.PlacementStep + (4 * Drawer.FrontThickness))
      else
        Drawer.WP = Point2D(1, 1)
      end -- if end
      if Sheet.Side == 2 then
        ProcessSide()
      end
      if Sheet.Bottom == 2 then
        ProcessBottom()
      end
      if Sheet.Front == 2 then
        ProcessFront()
      end
      if Sheet.Back == 2 then
        ProcessBack()
      end
    end
    if Sheet.Side == 3 or Sheet.Back == 3 or Sheet.Front == 3 or Sheet.Bottom == 3 then
      if Sheet.Side == 3 then
        NewSheet(Drawer.SideThickness)
      elseif Sheet.Back == 3 then
        NewSheet(Drawer.BackThickness)
      elseif Sheet.Front == 3 then
        NewSheet(Drawer.FrontThickness)
      elseif Sheet.Bottom == 3 then
        NewSheet(Drawer.BottomThickness)
      end
      if GetAppVersion() > 10.999 then
        Drawer.WP = Point2D(1, Drawer.WP.y + Drawer.PlacementStep + (4 * Drawer.FrontThickness))
      else
        Drawer.WP = Point2D(1, 1)
      end -- if end
      if Sheet.Side == 3 then
        ProcessSide()
      end
      if Sheet.Bottom == 3 then
        ProcessBottom()
      end
      if Sheet.Front == 3 then
        ProcessFront()
      end
      if Sheet.Back == 3 then
        ProcessBack()
      end
    end
    if Sheet.Side == 4 or Sheet.Back == 4 or Sheet.Front == 4 or Sheet.Bottom == 4 then
      if Sheet.Side == 4 then
        NewSheet(Drawer.SideThickness)
      elseif Sheet.Back == 4 then
        NewSheet(Drawer.BackThickness)
      elseif Sheet.Front == 4 then
        NewSheet(Drawer.FrontThickness)
      elseif Sheet.Bottom == 4 then
        NewSheet(Drawer.BottomThickness)
      end
      if GetAppVersion() > 10.999 then
        Drawer.WP = Point2D(1, Drawer.WP.y + Drawer.PlacementStep + (4 * Drawer.FrontThickness))
      else
        Drawer.WP = Point2D(1, 1)
      end -- if end
      if Sheet.Side == 4 then
        ProcessSide()
      end
      if Sheet.Bottom == 4 then
        ProcessBottom()
      end
      if Sheet.Front == 4 then
        ProcessFront()
      end
      if Sheet.Back == 4 then
        ProcessBack()
      end
    end
    CutListfileWriterFooter()
    MyProgressBar:SetText("Compete")                                          -- Sets the lable to Complete
    MyProgressBar:Finished()                                                  -- Close Progress Bar
  end
  Milling.job:Refresh2DView()
  return true
end
-- =====================================================]]
function ProcessSide()
  for _ = 1, Drawer.Count do
    Drawer_Side()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, Drawer.SideWidth + Milling.PartGap)    -- Left Side
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  end
  CreateLayerDadoToolpath("Side Dado", Milling.LNSidePocket, 0.0, (Drawer.SideThickness - Milling.DadoHeight))
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  CreateLayerFingerToolpath("Side-Fingers", "Side-" .. Milling.LNFingerBox, 0.0, Drawer.SideThickness)
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  CreateLayerProfileToolpath("Side-Profile", Milling.LNSideProfile, 0.0, Drawer.SideThickness, "OUT")
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  return true
end
-- =====================================================]]
function ProcessFront()
  for _ = 1, Drawer.Count do
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    Drawer_Front()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, Drawer.SideWidth + Milling.PartGap)   --  Front Panel
  end
  CreateLayerDadoToolpath("Front Dado", Milling.LNFrontPocket, 0.0, (Drawer.FrontThickness - Milling.DadoHeight))
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  CreateLayerFingerToolpath("Front-Fingers", "Front-" .. Milling.LNFingerBox, 0.0, Drawer.FrontThickness)
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  CreateLayerProfileToolpath("Front-Profile", Milling.LNFrontProfile, 0.0, Drawer.FrontThickness, "OUT")
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  return true
end
-- =====================================================]]
function ProcessBack()
  for _ = 1, Drawer.Count do
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    Drawer_Back()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, (Drawer.FrontWidth + Milling.PartGap))   -- Back Panel
  end
  CreateLayerDadoToolpath("Back Dado", Milling.LNBackPocket, 0.0, (Drawer.BackThickness - Milling.DadoHeight))
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  CreateLayerProfileToolpath("Back-Profile", Milling.LNBackProfile, 0.0, Drawer.BackThickness, "OUT")
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  CreateLayerBlumeToolpath("Blume Pockets", Milling.LNBlume, 0.0, Drawer.BackThickness)
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  return true
end
-- =====================================================]]
function ProcessBottom()
  for _ = 1, Drawer.Count do
    myRecord = myRecord + 1.0
    MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
    Drawer_Bottom()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, (Drawer.BottomPanelWidth + Milling.PartGap))   -- Draw Panel Bottom
  end
  CreateLayerProfileToolpath("Bottom-Profile", Milling.LNBottomProfile, 0.0, Drawer.BottomThickness, "OUT")
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  return true
end
-- =====================================================]]
function CutBySheets()                                  -- Groups parts by thickness per sheet
  Sheet.Side = 0
  Sheet.Bottom = 0
  Sheet.Front = 0
  Sheet.Back = 0
    for i = 1, 4, 1 do
      if Sheet.Side == 0 then
        Drawer.Thick = Drawer.SideThickness
      elseif Sheet.Front == 0 then
        Drawer.Thick = Drawer.FrontThickness
      elseif Sheet.Back == 0 then
        Drawer.Thick = Drawer.BackThickness
      elseif Sheet.Bottom == 0 then
        Drawer.Thick = Drawer.BottomThickness
      else
        Drawer.Thick = 0.0
      end
      if Sheet.Side == 0 then
        if Drawer.Thick == Drawer.SideThickness then
          Sheet.Side = i
        end
      end
      if Sheet.Front == 0 then
        if Drawer.Thick == Drawer.FrontThickness then
          Sheet.Front = i
        end
      end
      if Sheet.Back == 0 then
        if Drawer.Thick == Drawer.BackThickness then
          Sheet.Back = i
        end
      end
      if Sheet.Bottom == 0 then
        if Drawer.Thick == Drawer.BottomThickness then
          Sheet.Bottom = i
        end
      end
    end
  return true
end
-- =====================================================]]
function Drawer_Side()
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile)
  local pt2 = Polar2D(Drawer.WP, 90.0, Drawer.SideLength)
  local pt3 = Polar2D(pt2,    0.0, Drawer.SideWidth)
  local pt4 = Polar2D(pt3,  270.0, Drawer.SideLength)
  local pt1 = pt4
  local line = Contour(0.0)
  line:AppendPoint(Drawer.WP) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(Drawer.WP)
  layer:AddObject(CreateCadContour(line), true)
  -- Part Note
  local pt1Text = Polar2D(Drawer.WP,  45.0, 1.50)
        pt1Text = Polar2D(pt1Text, 0.0, 0.75)
  DrawWriter("Drawer - Left Side", pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  pt1Text = Polar2D(pt1Text, 0.0,  0.75, 0.0)
  DrawWriter("( " .. tostring(Drawer.SideThickness) .. " X " .. GetDistance(pt2, pt3) .. " X " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("A", "Left Side", "1", Drawer.SideThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  FingerBox(Drawer.WP, "L")
  -- Draw bottom dato
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket)
    pt2 = Polar2D(Drawer.WP,   0.0,    Drawer.SideWidth - Drawer.BottomDatoInset)
    pt1 = Polar2D(pt2,   270.0,    Milling.PocketToolRadius)
    pt2 = Polar2D(pt1,   180.0,    Drawer.BottomThickness + Milling.DadoClearance)
    pt3 = Polar2D(pt1,    90.0,    Drawer.SideLength + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,    90.0,    Drawer.SideLength + Milling.PocketToolDia)
   line = Contour(0.0)
  line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  -- Draw back dato
    pt2 = Polar2D(Drawer.WP,  90.0,    Drawer.SideLength - Drawer.BackDatoInset)
    pt1 = Polar2D(pt2,   180.0,    Milling.PocketToolRadius)
    pt2 = Polar2D(pt1,   270.0,    Drawer.BackThickness + Milling.DadoClearance)
    pt3 = Polar2D(pt1,     0.0,    Drawer.SideWidth + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,     0.0,    Drawer.SideWidth + Milling.PocketToolDia)
   line = Contour(0.0)
  line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  Drawer.WP = Polar2D(Drawer.WP, 0.0, (Drawer.SideWidth + Milling.PartGap))    -- Right Side
-- ====================================
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile)
    pt2 = Polar2D(Drawer.WP,  90.0,    Drawer.SideLength)
    pt3 = Polar2D(pt2,     0.0,    Drawer.SideWidth)
    pt4 = Polar2D(pt3,   270.0,    Drawer.SideLength)
   line = Contour(0.0)
  line:AppendPoint(Drawer.WP) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt2) ; line:LineTo(Drawer.WP)
  layer:AddObject(CreateCadContour(line), true)
  -- Part Note
  FingerBox(pt4, "R")
  pt1Text = Polar2D(Drawer.WP, 45.0,  1.5)
  pt1Text = Polar2D(pt1Text, 0.0,  0.75)
  DrawWriter("Drawer - Right Side" , pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  pt1Text = Polar2D(pt1Text, 0.0,  0.75, 0.0)
  DrawWriter("( " .. tostring(Drawer.SideThickness) .. " X " .. GetDistance(pt2, pt3) .. " X " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 90.0)

  CutListfileWriterItem("A", "Right Side", "1", Drawer.SideThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  -- Draw bottom dato
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket)
    pt2 = Polar2D(Drawer.WP, 0.0, Drawer.BottomDatoInset)
    pt1 = Polar2D(pt2, 270.0, Milling.PocketToolRadius)
    pt2 = Polar2D(pt1,   0.0, Drawer.BottomThickness + Milling.DadoClearance)
    pt3 = Polar2D(pt1,  90.0, Drawer.SideLength + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,  90.0, Drawer.SideLength + Milling.PocketToolDia)
    line = Contour(0.0); line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  -- Draw back dato
    pt2 = Polar2D(Drawer.WP, 90.0, Drawer.SideLength - Drawer.BackDatoInset)
    pt1 = Polar2D(pt2, 180.0, Milling.PocketToolRadius)
    pt2 = Polar2D(pt1, 270.0, Drawer.BackThickness + Milling.DadoClearance)
    pt3 = Polar2D(pt1,   0.0, Drawer.SideWidth + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,   0.0, Drawer.SideWidth + Milling.PocketToolDia)
   line = Contour(0.0); line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  --Drawer.WP = Polar2D(Drawer.WP,  0.0,  Milling.PartGap)
  return true
end
-- =====================================================]]
function Drawer_Front()
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFrontProfile)
  local pt1 = Point2D(0,0)
  local pt1Text = pt1
  local pt2 = Polar2D(Drawer.WP,  90.0,    Drawer.FrontLength)
  local pt3 = Polar2D(pt2,     0.0,    Drawer.FrontWidth)
  local pt4 = Polar2D(pt3,   270.0,    Drawer.FrontLength)

  local line = Contour(0.0)
  line:AppendPoint(Drawer.WP) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(Drawer.WP)
  layer:AddObject(CreateCadContour(line), true)
  --FingerBoxF(g_pt3, pt2)
  FingerBoxF(Drawer.WP, pt2)
  -- Part Note
        pt1Text = Polar2D(Drawer.WP,  45.0, 1.5)
        pt1Text = Polar2D(pt1Text, 0.0, 0.75)
  DrawWriter("Drawer - Front" , pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  pt1Text = Polar2D(pt1Text, 0.0,  0.75, 0.0)
  DrawWriter("( " .. tostring(Drawer.FrontThickness) .. " X " .. GetDistance(pt2, pt3) .. " X " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("B", "Front", "1", Drawer.FrontThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  -- Draw bottom dato
      layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFrontPocket)
        pt2 = Polar2D(pt4, 180.0, Drawer.BottomDatoInset)
        pt1 = Polar2D(pt2, 270.0, Milling.PocketToolRadius)
        pt2 = Polar2D(pt1, 180.0, Drawer.BottomThickness + Milling.DadoClearance)
        pt3 = Polar2D(pt1,  90.0, Drawer.FrontLength + Milling.PocketToolDia)
        pt4 = Polar2D(pt2,  90.0, Drawer.FrontLength + Milling.PocketToolDia)
       line = Contour(0.0); line:AppendPoint(pt1); line:LineTo(pt2); line:LineTo(pt4); line:LineTo(pt3); line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- =====================================================]]
function Drawer_Back()
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local pt1 = Point2D(0,0)
  local pt1Text = pt1
  local Bit
  if Milling.MillTool1.Name == "Not Selected" then
    Bit = math.sin(math.rad(45.0)) * Milling.ProfileToolDia
  else
    Bit = math.sin(math.rad(45.0)) * Milling.MillTool1.ToolDia
  end -- if end
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackProfile)
  local pt2 = Polar2D(Drawer.WP,  90.0,    Drawer.BackLength)
  local pt3 = Polar2D(pt2,     0.0,    Drawer.BackWidth)
  local pt4 = Polar2D(pt3,   270.0,    Drawer.BackLength)

  local line = Contour(0.0)
  if Milling.BlumeSoftClose == "No" then
    line:AppendPoint(Drawer.WP) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(Drawer.WP)
    layer:AddObject(CreateCadContour(line), true)
  else
    local pt5  = Polar2D(Drawer.WP, 0.0, Drawer.BottomDatoInset)
    local pt10 = Polar2D(pt2,       0.0, Drawer.BottomDatoInset)
    local pt6  = Polar2D(pt5,      90.0, (Drawer.SideThickness - Milling.DadoHeight) + Drawer.BlumeWide)
    local pt6a = Polar2D(pt6,     270.0, Bit)
    local pt6b = Polar2D(pt6,     180.0, Bit)
    local pt7  = Polar2D(pt6,     180.0, Drawer.BottomDatoInset)
    local pt9  = Polar2D(pt10,    270.0, (Drawer.SideThickness - Milling.DadoHeight) + Drawer.BlumeWide)
    local pt8  = Polar2D(pt9,     180.0, Drawer.BottomDatoInset)
    local pt9a = Polar2D(pt9,     180.0, Bit)
    local pt9b = Polar2D(pt9,      90.0, Bit)
    local pt11 = Polar2D(Polar2D(pt5, 0.0, Drawer.BlumeDown), 90.0, Drawer.BlumeIn + (Drawer.SideThickness - Milling.DadoHeight))
    local pt12 = Polar2D(Polar2D(pt10, 0.0, Drawer.BlumeDown), 270.0, Drawer.BlumeIn + (Drawer.SideThickness - Milling.DadoHeight))
    line:AppendPoint(pt5) ; line:LineTo(pt6a) ; line:ArcTo(pt6b, 1.0) ; line:LineTo(pt7) ; line:LineTo(pt8) ;
    line:LineTo(pt9a) ; line:ArcTo(pt9b, 1.0) ; line:LineTo(pt10) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(pt5)
    layer:AddObject(CreateCadContour(line), true)
    if Milling.BlumeHole == "Yes" then
      DrawCircle(pt11, Drawer.BlumeDia * 0.5, Milling.LNBlume)
      DrawCircle(pt12, Drawer.BlumeDia * 0.5, Milling.LNBlume)
    end -- if end
  end -- if end

  -- Part Note
      pt1Text = Polar2D(Drawer.WP, 45,  1.5)
      pt1Text = Polar2D(pt1Text, 0,  0.75)
  DrawWriter("Drawer - Back" , pt1Text, 0.350, Milling.LNPartLabels, 90.0)

  pt1Text = Polar2D(pt1Text, 0,  0.75, 0.0)
  DrawWriter("( " .. tostring(Drawer.BackThickness) .. " X " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("C", "Back", "1", Drawer.BackThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  -- Draw bottom dato
      layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackPocket)
        pt2 = Polar2D(Drawer.WP, 0.0, Drawer.BottomDatoInset)
        pt1 = Polar2D(pt2, 270.0, Milling.PocketToolRadius)
        pt2 = Polar2D(pt1,   0.0, Drawer.BottomThickness + Milling.DadoClearance)
        pt3 = Polar2D(pt1,  90.0, Drawer.BackLength + Milling.PocketToolDia)
        pt4 = Polar2D(pt2,  90.0, Drawer.BackLength + Milling.PocketToolDia)
       line = Contour(0.0)
  line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- =====================================================]]
function Drawer_Bottom()
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local pt1     = Point2D(0,0)
  local pt1Text = pt1
  local layer   = Milling.job.LayerManager:GetLayerWithName(Milling.LNBottomProfile)
  local pt2     = Polar2D(Drawer.WP,  90.0,    Drawer.BottomPanelLength)
  local pt3     = Polar2D(pt2,     0.0,    Drawer.BottomPanelWidth)
  local pt4     = Polar2D(pt3,   270.0,    Drawer.BottomPanelLength)
  local line    = Contour(0.0)
  line:AppendPoint(Drawer.WP) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(Drawer.WP)
  layer:AddObject(CreateCadContour(line), true)
  -- Part Note
      pt1Text = Polar2D(Drawer.WP, 45,  1.5)
      pt1Text = Polar2D(pt1Text, 0,  0.75)
  DrawWriter("Drawer - Bottom" , pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  pt1Text = Polar2D(pt1Text, 0,  0.75, 0.0)
  DrawWriter("( " .. tostring(Drawer.BottomThickness) .. " X " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("D", "Bottom", "1", Drawer.BottomThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  return true
end
-- =====================================================]]
function CutListfileWriterHeader()
  local file = io.open(Project.DatFile .. ".dat", "w")
  -- Open dat file for writing lines to the file
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  file:write("================================================================ \n")
  file:write("=====================  Drawer Cut-list  ======================== \n")
  file:write("Run ID = ".. Project.DrawerID .."\n")
  file:write("Drawer Run Count = ".. Drawer.Count .."\n")
  file:write("================================================================ \n")
  file:write("Drawer Opening Size\n")
  file:write("Drawer Opening Height   = ".. Drawer.OpeningHeight .."\n")
  file:write("Drawer Opening Width    = ".. Drawer.OpeningWidth .."\n")
  file:write("Drawer Opening Depth    = ".. Drawer.OpeningDepth .."\n")
  file:write("Drawer Opening Diagonal = ".. math.sqrt ((Drawer.OpeningHeight * Drawer.OpeningHeight) + Drawer.OpeningWidth^2) .."\n")
  file:write("Side Gap     .........  = ".. Drawer.SideGap .."\n")
  file:write("Bottom Gap   .........  = ".. Drawer.BottomGap .."\n")
  file:write("Top Gap      .........  = ".. Drawer.TopGap .."\n")
  file:write("----------------------------------------------------------------\n")
  file:write("Finish Depth  ........  = ".. Drawer.Depth .."\n")
  file:write("Finish Height ........  = ".. Drawer.Height .."\n")
  file:write("Finish Width  ........  = ".. Drawer.Length .."\n")
  file:write("----------------------------------------------------------------\n")
  file:write("ID | Name       |Count| Thick | Material     | Width   | Length \n")
  file:write("----------------------------------------------------------------\n")
  file:close()-- closes the the door on the open file
  file = io.open(Project.DatFile .. ".csv", "w")
  -- Open dat file for writing lines to the file
  file:write("ID,Name,Count,Thick,Material,Width,Length\n")
  file:close()-- closes the the door on the open file
  return true
end  -- function end
-- =====================================================]]
function CutListfileWriterItem(ID, Name, Count, Thick, Material, Width, Length)
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local file = io.open(Project.DatFile .. ".dat", "a")
  local sID       = " " .. ID .. " "
  local Space     = "                             "
  local sName     = string.sub("| ".. Name     .. Space ,1 ,13)
  local sCount    = string.sub("| ".. Count    .. Space ,1, 6)
  local sThick    = string.sub("| ".. Thick    .. Space ,1, 8)
  local sMaterial = string.sub("| ".. Material .. Space ,1, 15)
  local sWidth    = string.sub("| ".. Width    .. Space ,1, 10)
  local sLength   = string.sub("| ".. Length   .. Space ,1, 9)
  file:write(sID .. sName .. sCount .. sThick .. sMaterial .. sWidth .. sLength .. "\n")
  file:close()-- closes the the door on the open file
  file = io.open(Project.DatFile .. ".csv", "a")
  file:write(ID .. "," .. Name .. "," .. Count .. "," .. Thick .. "," .. Material .. "," .. Width .. "," .. Length  .. "     \n")
  file:close()-- closes the the door on the open file
  return true
end  -- function end
-- =====================================================]]
function CutListfileWriterFooter()
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local file = io.open(Project.DatFile .. ".dat", "a")
  file:write("----------------------------------------------------------------\n")
  file:close()-- closes the the door on the open file
  file = io.open(Project.DatFile .. ".csv", "a")
  file:write( "\n")
  file:close()-- closes the the door on the open file
end  -- function end
-- =====================================================]]
function FingerBox(pt, hand)
  local pt1 = pt
  local pt2 = pt
  local fCount = 1
  if (Drawer.SideFingerCount % 2 == 0) then
    fCount = math.floor(Drawer.SideFingerCount * 0.5)
  else
    fCount = math.floor(Drawer.SideFingerCount * 0.5) + 1
  end
  if hand == "L" then
    pt1 = Polar2D(pt1,   0.0, Drawer.SideFingerWidth * 0.5)
  else
    pt1 = Polar2D(pt1, 180.0, Drawer.SideFingerWidth * 0.5)
  end
  for _ = 1, fCount do
    if hand == "L" then
      myRecord = myRecord + 1.0
      MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
      pt2 = SideFingerBox(pt1,   0.0)
      pt1 = Polar2D(pt2,   0.0, Drawer.SideFingerWidth)
    else
      myRecord = myRecord + 1.0
      MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
      pt2 = SideFingerBox(pt1, 180.0)
      pt1 = Polar2D(pt2, 180.0, Drawer.SideFingerWidth)
    end
  end
  return true
end  -- function end
-- =====================================================]]
function SideFingerBox(pta, ang)
  local Bit
  if Milling.MillTool4.Name == "Not Selected" then
    Bit = math.sin(math.rad(45.0)) * Milling.FingerToolDia
  else
    Bit = math.sin(math.rad(45.0)) * Milling.MillTool4.ToolDia
  end -- if end
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local ptAx = Polar2D(pta,   ang + 180.0, Milling.FingerClearance * 0.5)
  local ptBx = Polar2D(pta,   ang, Drawer.SideFingerWidth)
  local ptCx = Polar2D(ptBx,  ang, Milling.FingerClearance * 0.5)
  local pt1 = Polar2D(ptAx,  90.0, Drawer.FrontThickness)
  local pt2 = Polar2D(ptAx, 270.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
  local pt3 = Polar2D(pta,   ang, Drawer.SideFingerWidth)
  local pt4 = Polar2D(ptCx,  90.0, Drawer.FrontThickness)
  local pt5 = Polar2D(ptCx, 270.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
  local ptw = Polar2D(pt1, 270.0, Bit)
  local ptx = Polar2D(pt1,   0.0, Bit)
  local pty = Polar2D(pt4, 180.0, Bit)
  local ptz = Polar2D(pt4, 270.0, Bit)
  local layer = Milling.job.LayerManager:GetLayerWithName("Side-" .. Milling.LNFingerBox)
  local line = Contour(0.0)
      line:AppendPoint(pt2)
  if ang == 0 then
    line:LineTo(ptw)
    line:ArcTo(ptx, -1.0)
    line:LineTo(pty)
    line:ArcTo(ptz,-1.0)
    line:LineTo(pt5)
    line:LineTo(pt2)
  else
    ptw = Polar2D(pt1, 270.0, Bit)
    ptx = Polar2D(pt1, 180.0, Bit)
    pty = Polar2D(pt4,   0.0, Bit)
    ptz = Polar2D(pt4, 270.0, Bit)
    line:LineTo(ptw)
    line:ArcTo(ptx, 1.0)
    line:LineTo(pty)
    line:ArcTo(ptz,1.0)
    line:LineTo(pt5)
    line:LineTo(pt2)
  end
    layer:AddObject(CreateCadContour(line), true)
  return pt3
end
-- =====================================================]]
function FrontFingerBox(pta, ang)
  local Bit
  if Milling.MillTool4.Name == "Not Selected" then
    Bit = math.sin(math.rad(45.0)) * Milling.FingerToolDia
  else
    Bit = math.sin(math.rad(45.0)) * Milling.MillTool4.ToolDia
  end -- if end
  myRecord = myRecord + 1.0
  MyProgressBar:SetPercentProgress(ProgressAmount(Drawer.Record, myRecord))  -- sends percent of process progress barr (adds to the bar)
  local ptAx = Polar2D(pta,  180.0, 0.0)--Milling.FingerClearance * 0.5)
  local pt1  = Polar2D(ptAx,  90.0, Drawer.SideThickness)
  local pt2  = Polar2D(ptAx, 270.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
  local pt3  = Polar2D(pta,    0.0, Drawer.SideFingerWidth)
  local ptCx = Polar2D(pt3,    0.0, 0.0)--Milling.FingerClearance * 0.5)
  local pt4  = Polar2D(ptCx,  90.0, Drawer.SideThickness)
  local pt5  = Polar2D(ptCx, 270.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
  local ptw  = Polar2D(pt1,  270.0, Bit)
  local ptx  = Polar2D(pt1,    0.0, Bit)
  local pty  = Polar2D(pt4,  180.0, Bit)
  local ptz  = Polar2D(pt4,  270.0, Bit)
  if ang == 270.0 then
    ptAx = Polar2D(pta,    0.0, 0.0)--Milling.FingerClearance * 0.5)
    pt1  = Polar2D(ptAx, 270.0, Drawer.SideThickness)
    pt2  = Polar2D(ptAx,  90.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
    pt3  = Polar2D(pta,    0.0, Drawer.SideFingerWidth)
    ptCx = Polar2D(pt3,  180.0, 0.0)--Milling.FingerClearance * 0.5)
    pt4  = Polar2D(ptCx, 270.0, Drawer.SideThickness)
    pt5  = Polar2D(ptCx,  90.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
    ptw  = Polar2D(pt1,   90.0, Bit)
    ptx  = Polar2D(pt1,    0.0, Bit)
    pty  = Polar2D(pt4,  180.0, Bit)
    ptz  = Polar2D(pt4,   90.0, Bit)
  end
  local layer = Milling.job.LayerManager:GetLayerWithName("Front-" .. Milling.LNFingerBox)
  local line = Contour(0.0)
  line:AppendPoint(pt2)
  if ang == 270.0 then
    line:LineTo(ptw)
    line:ArcTo(ptx, 1.0)
    line:LineTo(pty)
    line:ArcTo(ptz, 1.0)
    line:LineTo(pt5)
    line:LineTo(pt2)
else
    line:LineTo(ptw)
    line:ArcTo(ptx, -1.0)
    line:LineTo(pty)
    line:ArcTo(ptz, -1.0)
    line:LineTo(pt5)
    line:LineTo(pt2)
  end
  layer:AddObject(CreateCadContour(line), true)
  return pt3
end
-- =====================================================]]
function FingerBoxF(pta, ptb)
  --local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFingerBox)
  local pt1 = Polar2D(pta, 180.0, Drawer.SideFingerWidth * 0.5)
  local pt2 = pt1
  local fCount = (Drawer.SideFingerCount * 0.5 ) + 1
  for _ = 1, fCount do
    pt2 = FrontFingerBox(pt1, 90.0)
    pt1 = Polar2D(pt2, 0.0, Drawer.SideFingerWidth)
  end
  pt1 = Polar2D(ptb, 180.0, Drawer.SideFingerWidth * 0.5)
  for _ = 1, fCount do
    pt2 = FrontFingerBox(pt1, 270.0)
    pt1 = Polar2D(pt2, 0.0, Drawer.SideFingerWidth)
  end
  return true
end  -- function end
-- =====================================================]]
function MakeLayers()
  local Red, Green, Blue = 0, 0, 0
  local function GetColor(str) -- returns color value for a Color Name
    local sx = str
    local Red, Green, Blue = 0
    local Colors = {}
    Colors.Black = "0,0,0"; Colors.Red = "255,0,0"; Colors.Blue = "0,0,255"; Colors.Yellow = "255,255,0"; Colors.Cyan = "0,255,255"; Colors.Magenta = "255,0,255"; Colors.Green = "0,128,0";
    if "" == str then
      DisplayMessageBox("Error: Empty string passed")
    else
      str = Colors[str]
      if "string" == type(str) then
        if string.find(str, ",") then
          Red   = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          str  = string.sub(str, assert(string.find(str, ",") + 1))
          Green = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          Blue  = tonumber(string.sub(str, assert(string.find(str, ",") + 1)))
        end
      else
        DisplayMessageBox("Error: Color " .. sx .. " not Found" )
        Red = 0
        Green = 0
        Blue = 0
      end
    end
    return Red, Green, Blue
  end
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackPocket)
        Red, Green, Blue = GetColor(Milling.LNBackPocketColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackProfile)
        Red, Green, Blue = GetColor(Milling.LNBackProfileColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBottomProfile)
        Red, Green, Blue = GetColor(Milling.LNBottomProfileColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile)
        Red, Green, Blue = GetColor(Milling.LNSideProfileColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket)
        Red, Green, Blue = GetColor(Milling.LNSidePocketColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFrontProfile)
        Red, Green, Blue = GetColor(Milling.LNFrontProfileColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFrontPocket)
        Red, Green, Blue = GetColor(Milling.LNFrontPocketColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNDrawNotes)
        Red, Green, Blue = GetColor(Milling.LNDrawNotesColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNPartLabels)
        Red, Green, Blue = GetColor(Milling.LNPartLabelsColor)
        layer:SetColor (Red, Green, Blue)
        layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBlume)
        Red, Green, Blue = GetColor(Milling.LNBlumeColor)
        layer:SetColor (Red, Green, Blue)
  return true
end
-- ====================================================]]
function CreateLayerBlumeToolpath(name, layer_name, start_depth, cut_depth)
  if (Milling.Blume) and (Milling.BlumeHole == "Yes") then
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
   -- Create tool we will use to machine vectors
    local tool = Tool(Milling.MillTool6.Name, Tool.END_MILL)    -- BALL_NOSE, END_MILL, VBIT
          tool.InMM         = Milling.MillTool6.InMM            -- tool_in_mm
          tool.ToolDia      = Milling.MillTool6.ToolDia         -- tool_dia
          tool.Stepdown     = Milling.MillTool6.Stepdown        -- tool_stepdown
          tool.Stepover     = Milling.MillTool6.Stepover        -- tool_dia * (tool_stepover_percent / 100)
          tool.RateUnits    = Milling.MillTool6.RateUnits       -- Tool.MM_SEC, MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Milling.MillTool6.FeedRate        -- 30
          tool.PlungeRate   = Milling.MillTool6.PlungeRate      -- 10
          tool.SpindleSpeed = Milling.MillTool6.SpindleSpeed    -- 20000
          tool.ToolNumber   = Milling.MillTool6.ToolNumber      -- 1
   -- we will set home position and safe z relative to material block size
    local mtl_block = MaterialBlock()
    local mtl_box = mtl_block.MaterialBox
    local mtl_box_blc = mtl_box.BLC
   -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
          pos_data.SafeZGap = mtl_block.Thickness * 0.1
   -- Create  object used to pass pocketing options
    local pocket_data = PocketParameterData()
          -- start depth for toolpath
          pocket_data.StartDepth = start_depth
          -- cut depth for toolpath this is depth below start depth
          pocket_data.CutDepth = cut_depth
          -- direction of cut for offet Clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
          pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
          -- Allowance to leave on when machining
          pocket_data.Allowance = 0.0
          -- if true use raster Clearance strategy , else use offset area Clearance
          pocket_data.DoRasterClearance = false --true
          -- angle for raster if using raster Clearance
          pocket_data.RasterAngle = 0
          -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
          pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
          -- if true we ramp into pockets (always zig-zag)
          pocket_data.DoRamping = false
          --  if ramping, distance to ramp over
          pocket_data.RampDistance = 1.0
          -- if true in Aspire, project toolpath onto composite model
          pocket_data.ProjectToolpath = false
   -- Create object which can used to automatically select geometry on layers etc
    local geometry_selector = GeometrySelector()
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
   -- if this is true we will display errors and warning to the user
    local display_warnings = false --true
   -- if we are doing two tool pocketing define tool to use for area Clearance
    local area_clear_tool = nil
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreatePocketingToolpath(
                                              name,
                                              tool,
                                              area_clear_tool,
                                              pocket_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
    if toolpath_id  == nil  then
      DisplayMessageBox("Error creating Dado Toolpath")
      return false
    end
  end
  return true
end
-- =====================================================]]
function CreateLayerDadoToolpath(name, layer_name, start_depth, cut_depth)
  if Milling.Dado then
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
   -- Create tool we will use to machine vectors
    local tool = Tool(Milling.MillTool2.Name, Tool.END_MILL)    -- BALL_NOSE, END_MILL, VBIT
          tool.InMM         = Milling.MillTool2.InMM            -- tool_in_mm
          tool.ToolDia      = Milling.MillTool2.ToolDia         -- tool_dia
          tool.Stepdown     = Milling.MillTool2.Stepdown        -- tool_stepdown
          tool.Stepover     = Milling.MillTool2.Stepover        -- tool_dia * (tool_stepover_percent / 100)
          tool.RateUnits    = Milling.MillTool2.RateUnits       -- Tool.MM_SEC     -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Milling.MillTool2.FeedRate        -- 30
          tool.PlungeRate   = Milling.MillTool2.PlungeRate      -- 10
          tool.SpindleSpeed = Milling.MillTool2.SpindleSpeed    -- 20000
          tool.ToolNumber   = Milling.MillTool2.ToolNumber      -- 1
      --  tool.VBitAngle    = Milling.MillTool2.VBitAngle          -- 90.0            -- used for vbit only
      --  tool.ClearStepover = Milling.MillTool2.ClearStepover   --  tool_dia * (tool_stepover_percent / 100)  -- used for vbit only
   -- we will set home position and safe z relative to material block size
    local mtl_block = MaterialBlock()
    local mtl_box = mtl_block.MaterialBox
    local mtl_box_blc = mtl_box.BLC
   -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
          pos_data.SafeZGap = mtl_block.Thickness * 0.1
   -- Create  object used to pass pocketing options
    local pocket_data = PocketParameterData()
          -- start depth for toolpath
          pocket_data.StartDepth = start_depth
          -- cut depth for toolpath this is depth below start depth
          pocket_data.CutDepth = cut_depth
          -- direction of cut for offet Clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
          pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
          -- Allowance to leave on when machining
          pocket_data.Allowance = 0.0
          -- if true use raster Clearance strategy , else use offset area Clearance
          pocket_data.DoRasterClearance = false --true
          -- angle for raster if using raster Clearance
          pocket_data.RasterAngle = 0
          -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
          pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
          -- if true we ramp into pockets (always zig-zag)
          pocket_data.DoRamping = false
          --  if ramping, distance to ramp over
          pocket_data.RampDistance = 1.0
          -- if true in Aspire, project toolpath onto composite model
          pocket_data.ProjectToolpath = false
   -- Create object which can used to automatically select geometry on layers etc
    local geometry_selector = GeometrySelector()
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
   -- if this is true we will display errors and warning to the user
    local display_warnings = false --true
   -- if we are doing two tool pocketing define tool to use for area Clearance
   local area_clear_tool = nil
   if Milling.DadoClear then
   -- we just create a tool twice as large for testing here
--   local jim = Milling.MillTool3
    area_clear_tool = Tool(Milling.MillTool3.Name, Tool.END_MILL)      -- BALL_NOSE, END_MILL, VBIT
     area_clear_tool.InMM         = Milling.MillTool3.InMM       -- tool_in_mm
     area_clear_tool.ToolDia      = Milling.MillTool3.ToolDia    -- tool_dia * 2
     area_clear_tool.Stepdown     = Milling.MillTool3.Stepdown   -- tool_stepdown * 2
     area_clear_tool.Stepover     = Milling.MillTool3.Stepover   -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits    = Milling.MillTool3.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate     = Milling.MillTool3.FeedRate      -- 30
     area_clear_tool.PlungeRate   = Milling.MillTool3.PlungeRate    -- 10
     area_clear_tool.SpindleSpeed = Milling.MillTool3.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber   = Milling.MillTool3.ToolNumber    -- 1
     -- area_clear_tool.VBitAngle     = Carrier.MillTool3.VBitAngle      -- 90.0 -- used for vbit only
     -- area_clear_tool.ClearStepover = Carrier.MillTool3.ClearStepover  -- tool_dia * 2 * (tool_stepover_percent / 100)  -- used for vbit only
   -- Create our toolpath
   end
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreatePocketingToolpath(
                                              name,
                                              tool,
                                              area_clear_tool,
                                              pocket_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
    if toolpath_id  == nil  then
      DisplayMessageBox("Error creating Dado Toolpath")
      return false
    end
  end
  return true
end
-- =====================================================]]
function CreateLayerFingerToolpath(name, layer_name, start_depth, cut_depth)
  if Milling.Finger then
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
   -- Create tool we will use to machine vectors
    local tool = Tool(Milling.MillTool4.Name, Tool.END_MILL)    -- BALL_NOSE, END_MILL, VBIT
          tool.InMM         = Milling.MillTool4.InMM            -- tool_in_mm
          tool.ToolDia      = Milling.MillTool4.ToolDia         -- tool_dia
          tool.Stepdown     = Milling.MillTool4.Stepdown        -- tool_stepdown
          tool.Stepover     = Milling.MillTool4.Stepover        -- tool_dia * (tool_stepover_percent / 100)
          tool.RateUnits    = Milling.MillTool4.RateUnits       -- Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Milling.MillTool4.FeedRate        -- 30
          tool.PlungeRate   = Milling.MillTool4.PlungeRate      -- 10
          tool.SpindleSpeed = Milling.MillTool4.SpindleSpeed    -- 20000
          tool.ToolNumber   = Milling.MillTool4.ToolNumber      -- 1
   -- we will set home position and safe z relative to material block size
    local mtl_block = MaterialBlock()
    local mtl_box = mtl_block.MaterialBox
    local mtl_box_blc = mtl_box.BLC
   -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
          pos_data.SafeZGap = mtl_block.Thickness * 0.1
   -- Create  object used to pass pocketing options
    local pocket_data = PocketParameterData()
          -- start depth for toolpath
          pocket_data.StartDepth = start_depth
          -- cut depth for toolpath this is depth below start depth
          pocket_data.CutDepth = cut_depth
          -- direction of cut for offet Clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
          pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
          -- Allowance to leave on when machining
          pocket_data.Allowance = 0.0
          -- if true use raster Clearance strategy , else use offset area Clearance
          pocket_data.DoRasterClearance = false --true
          -- angle for raster if using raster Clearance
          pocket_data.RasterAngle = 0
          -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
          pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
          -- if true we ramp into pockets (always zig-zag)
          pocket_data.DoRamping = false
          --  if ramping, distance to ramp over
          pocket_data.RampDistance = 1.0
          -- if true in Aspire, project toolpath onto composite model
          pocket_data.ProjectToolpath = false
   -- Create object which can used to automatically select geometry on layers etc
    local geometry_selector = GeometrySelector()
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
   -- if this is true we will display errors and warning to the user
    local display_warnings = false  -- true
   -- if we are doing two tool pocketing define tool to use for area Clearance
    local area_clear_tool = nil
    if Milling.FingerClear then
   -- we just create a tool twice as large for testing here
    area_clear_tool = Tool(Milling.MillTool5.Name, Tool.END_MILL)       -- BALL_NOSE, END_MILL, VBIT
     area_clear_tool.InMM         = Milling.MillTool5.InMM       -- tool_in_mm
     area_clear_tool.ToolDia      = Milling.MillTool5.ToolDia    -- tool_dia * 2
     area_clear_tool.Stepdown     = Milling.MillTool5.Stepdown   -- tool_stepdown * 2
     area_clear_tool.Stepover     = Milling.MillTool5.Stepover   -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits    = Milling.MillTool5.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate     = Milling.MillTool5.FeedRate      -- 30
     area_clear_tool.PlungeRate   = Milling.MillTool5.PlungeRate    -- 10
     area_clear_tool.SpindleSpeed = Milling.MillTool5.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber   = Milling.MillTool5.ToolNumber    -- 1
    end
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreatePocketingToolpath(
                                              name,
                                              tool,
                                              area_clear_tool,
                                              pocket_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
    if toolpath_id  == nil  then
      DisplayMessageBox("Error creating Finger Toolpath")
      return false
    end
  end
  return true
end
-- =====================================================]]
function CreateLayerProfileToolpath(name,layer_name, start_depth, cut_depth, InOrOut)
  if Milling.Profile then
  --  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
  -- Create tool we will use to machine vectors
    local tool               = Tool(Milling.MillTool1.Name, Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
          tool.InMM          = Milling.MillTool1.InMM         -- tool_in_mm
          tool.ToolDia       = Milling.MillTool1.ToolDia      -- tool_dia
          tool.Stepdown      = Milling.MillTool1.Stepdown     -- tool_stepdown
          tool.Stepover      = Milling.MillTool1.Stepover     -- tool_dia * 0.25
          tool.RateUnits     = Milling.MillTool1.RateUnits    -- Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
          tool.FeedRate      = Milling.MillTool1.FeedRate     -- 30
          tool.PlungeRate    = Milling.MillTool1.PlungeRate   -- 10
          tool.SpindleSpeed  = Milling.MillTool1.SpindleSpeed -- 20000
          tool.ToolNumber    = Milling.MillTool1.ToolNumber   -- 1
       -- tool.VBitAngle     = Carrier.MillTool.VBitAngle     -- 90.0 -- used for vbit only
       -- tool.ClearStepover = tool_dia * 0.5                 -- used for vbit only
  -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(0, 0, 5.0)
          pos_data.SafeZGap    = 5.0
  -- Create object used to pass profile options
    local profile_data = ProfileParameterData()
  -- start depth for toolpath
    profile_data.StartDepth    = start_depth
    profile_data.CutDepth      = cut_depth -- cut depth for toolpath this is depth below start depth
    profile_data.CutDirection  = ProfileParameterData.CLIMB_DIRECTION -- direction of cut - ProfileParameterData. CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
    if InOrOut == "IN" then
      profile_data.ProfileSide = ProfileParameterData.PROFILE_INSIDE
    elseif InOrOut == "OUT" then
      profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE
    else  -- InOrOut == "ON"
      profile_data.ProfileSide = ProfileParameterData.PROFILE_ON
    end
    profile_data.Allowance = 0.0 -- Allowance to leave on when machining
    profile_data.KeepStartPoints = false -- true to preserve start point positions, false to reorder start points to minimise toolpath length
    profile_data.CreateSquareCorners = false -- true if want to create 'square' external corners on toolpath
    profile_data.CornerSharpen = false -- true to perform corner sharpening on internal corners (only with v-bits)
    profile_data.UseTabs = false -- UseTab -- true to use tabs (position of tabs must already have been defined on vectors)
    profile_data.TabLength = 0.5 -- length for tabs if being used
    profile_data.TabThickness = 0.25
    profile_data.Use3dTabs = true -- if true then create 3d tabs else 2d tabs
    profile_data.ProjectToolpath = false -- if true in Aspire, project toolpath onto composite model
    local ramping_data = RampingData() -- Create object used to control ramping
    ramping_data.DoRamping = false -- if true we do ramping into toolpath
    ramping_data.RampType = RampingData.RAMP_ZIG_ZAG -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG or RampingData.RAMP_SPIRAL
    ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE or RampingData.CONSTRAIN_ANGLE
    ramping_data.RampDistance = 100.0 -- if we are constraining ramp by distance, distance to ramp over
    ramping_data.RampAngle = 25.0 -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
    ramping_data.RampMaxAngleDist = 15 -- if we are contraining ramp by angle, max distance to travel before 'zig zaging' if zig zaging
    ramping_data.RampOnLeadIn = false -- if true we restrict our ramping to lead in section of toolpath
    lead_in_out_data.DoLeadIn = false -- if true we create lead ins on profiles (not for profile on)
    lead_in_out_data.DoLeadOut = false -- if true we create lead outs on profiles (not for profile on)
    lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
    lead_in_out_data.LeadLength = 5.0 -- length of lead to create
    lead_in_out_data.LinearLeadAngle = 45 -- Angle for linear leads
    lead_in_out_data.CirularLeadRadius = 5.0 -- Radius for circular arc leads
    lead_in_out_data.OvercutDistance = 0.0 -- distance to 'overcut' (travel past start point) when profiling
    local geometry_selector = GeometrySelector() -- Create object which can be used to automatically select geometry
    local create_2d_previews = true -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local display_warnings = false  --true -- if this is true we will display errors and warning to the user
    local toolpath_manager = ToolpathManager() -- Create our toolpath
    local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data,
                        ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating Profile Toolpath")
      return false
    end
  end
  return true
end
-- =====================================================]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
  -- Please Note: SelectVectorsOnLayer is provided by Vectric and can be found in the SDK and Sample Gadget files.
  --[[  ---------------- SelectVectorsOnLayer ----------------
  -- |   SelectVectorsOnLayer("Stringer Profile", selection, true, falus, falus)
  -- |   Add all the vectors on the layer to the selection
  -- |     layer,            -- layer we are selecting vectors on
  -- |     selection         -- selection object
  -- |     select_closed     -- if true  select closed objects
  -- |     select_open       -- if true  select open objects
  -- |     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
  -- |  Return Values:
  -- |     true if selected one or more vectors|
  --]]
  local objects_selected = false
  local warning_displayed = false
  local pos = layer:GetHeadPosition()
  while pos ~= nil do
    local object
    object, pos = layer:GetNext(pos)
    local contour = object:GetContour()
    if contour == nil then
      if (object.ClassName == "vcCadObjectGroup") and select_groups then
        selection:Add(object, true, true)
        objects_selected = true
      else
        if not warning_displayed then
          local message = "Object(s) without contour information found on layer - ignoring"
          if not select_groups then
            message = message ..  "\r\n\r\n" ..
            "If layer contains grouped vectors these must be ungrouped for this script"
          end -- if end
          DisplayMessageBox(message)
          warning_displayed = true
        end -- if end
      end -- if end
    else  -- contour was NOT nil, test if Open or Closed
      if contour.IsOpen and select_open then
        selection:Add(object, true, true)
        objects_selected = true
      elseif select_closed then
        selection:Add(object, true, true)
        objects_selected = true
      end -- if end
    end -- if end
  end -- while end
  -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
  -- tell selection we have now finished updating
  if objects_selected then
    selection:GroupSelectionFinished()
  end -- if end
  return objects_selected
end -- function end

