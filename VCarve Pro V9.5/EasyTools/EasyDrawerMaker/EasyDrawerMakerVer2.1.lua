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

Easy Drawer Maker was written by Jim Anderson of Houston Texas 2019

]]
-- =====================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
local Milling = {}
local Project = {}
local Drawer = {}
local Sheet = {}
local DialogWindow = {}
local Tool_ID1 = ToolDBId()
local Tool_ID2 = ToolDBId()
local Tool_ID3 = ToolDBId()
local Tool_ID4 = ToolDBId()
local Tool_ID5 = ToolDBId()
local lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
Tool_ID3:LoadDefaults("My Toolpath3", "")
Tool_ID4:LoadDefaults("My Toolpath4", "")
Tool_ID5:LoadDefaults("My Toolpath5", "")
Project.ProgramVersion = "2.1"
DialogWindow.ProgramName = "Easy Drawer Maker"
Drawer.SDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Drawer_Maker"
local RegName = "EasyDrawerMaker" .. Project.ProgramVersion
local g_pt1 = Point2D(1, 1)      -- Left Side Panel
local g_pt2 = Point2D(10, 1)     -- Right Side Panel
local g_pt3 = Point2D(20, 1)     -- Base_CabinetShelf
local g_pt4 = Point2D(30, 1)     -- Base_CenterPanel
local g_pt5 = Point2D(40, 1)     -- Wall_CabinetShelf
-- =====================================================]]
function Drawer_Math()  -- All the math for Wall Cabinet
  Drawer.Depth             = Drawer.OpeningDepth - (Drawer.SideGap * 2.0)
  Drawer.Height            = Drawer.OpeningHeight - (Drawer.TopGap + Drawer.BottomGap)
  Drawer.Length            = Drawer.OpeningLength - (Drawer.SideGap * 2.0)
  Drawer.SideWidth         = Drawer.Height
  Drawer.FrontWidth        = Drawer.Height
  Drawer.BackWidth         = Drawer.Height
  Project.DrawerID         = StartDate()
  Drawer.SideLength        = Drawer.OpeningDepth - 1.0
  Drawer.FrontLength       = Drawer.OpeningLength - (Drawer.SideGap * 2.0)
  Drawer.BackLength        = Drawer.FrontLength - (Milling.DadoHeight * 2.0)
  Drawer.BottomPanelLength = ((Drawer.SideLength - Drawer.BackThickness) - Drawer.BackDatoInset) - Drawer.FrontThickness + (Milling.DadoHeight * 2.0)
  Drawer.BottomPanelWidth  = Drawer.Length  - (Milling.DadoHeight * 2.0)
  Drawer.SideFingerWidth   = Drawer.SideWidth/Drawer.SideFingerCount
  Project.DatFile          = Project.ProjectPath .. "\\" .. Project.DrawerName .. "-" .. Project.DrawerID
-- Bit and Milling Values
  if Milling.MillTool4  then    -- Finger
    Milling.FingerToolDia = Milling.MillTool4.ToolDia
  end
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
  if Milling.Dado then
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
function REG_ReadRegistry()  -- Read from Registry values
  local RegistryRead = Registry(RegName)
  Drawer.BackDatoInset              = RegistryRead:GetDouble("Drawer.BackDatoInset",      0.7500)
  Drawer.BackLength                 = RegistryRead:GetDouble("Drawer.BackLength",        18.2500)
  Drawer.BackThickness              = RegistryRead:GetDouble("Drawer.BackThickness",      0.5000)
  Drawer.BackWidth                  = RegistryRead:GetDouble("Drawer.BackWidth",          5.2500)
  Drawer.BottomDatoInset            = RegistryRead:GetDouble("Drawer.BottomDatoInset",    0.3750)
  Drawer.BottomGap                  = RegistryRead:GetDouble("Drawer.BottomGap",          0.5000)
  Drawer.BottomPanelLength          = RegistryRead:GetDouble("Drawer.BottomPanelLength", 18.2500)
  Drawer.BottomPanelWidth           = RegistryRead:GetDouble("Drawer.BottomPanelWidth",   5.2500)
  Drawer.BottomThickness            = RegistryRead:GetDouble("Drawer.BottomThickness",    0.2500)
  Drawer.Count                      = RegistryRead:GetInt("Drawer.Count",                 1)
  Drawer.Depth                      = RegistryRead:GetDouble("Drawer.Depth",             18.0000)
  Drawer.FrontLength                = RegistryRead:GetDouble("Drawer.FrontLength",       18.2500)
  Drawer.FrontThickness             = RegistryRead:GetDouble("Drawer.FrontThickness",     0.5000)
  Drawer.FrontWidth                 = RegistryRead:GetDouble("Drawer.FrontWidth",         1.2500)
  Drawer.Height                     = RegistryRead:GetDouble("Drawer.Height",             6.0000)
  Drawer.Length                     = RegistryRead:GetDouble("Drawer.Length",            16.0000)
  Drawer.OpeningDepth               = RegistryRead:GetDouble("Drawer.OpeningDepth",      18.0000)
  Drawer.OpeningHeight              = RegistryRead:GetDouble("Drawer.OpeningHeight",      6.0000)
  Drawer.OpeningLength              = RegistryRead:GetDouble("Drawer.OpeningLength",      16.0000)
  Drawer.SideFingerCount            = RegistryRead:GetInt("Drawer.SideFingerCount",       9)
  Drawer.SideFingerWidth            = RegistryRead:GetDouble("Drawer.SideFingerWidth",    0.5000)
  Drawer.SideGap                    = RegistryRead:GetDouble("Drawer.SideGap",            0.5000)
  Drawer.SideLength                 = RegistryRead:GetDouble("Drawer.SideLength",        18.2500)
  Drawer.SideThickness              = RegistryRead:GetDouble("Drawer.SideThickness",      0.5000)
  Drawer.SideWidth                  = RegistryRead:GetDouble("Drawer.SideWidth",          1.2500)
  Drawer.TopGap                     = RegistryRead:GetDouble("Drawer.TopGap",             1.5000)
  Milling.DadoHeight                = RegistryRead:GetDouble("Milling.DadoHeight",        0.2500)
  Milling.FingerClearance           = RegistryRead:GetDouble("Milling.FingerClearance",   0.0050)
  Milling.FingerToolDia             = RegistryRead:GetDouble("Milling.FingerToolDia",     0.1250)
  Milling.FingerToolRadius          = RegistryRead:GetDouble("Milling.FingerToolRadius",  0.0625)
  Milling.LNBackPocket       = RegistryRead:GetString("Milling.LNBackPocket",    "BackPocketProfile")
  Milling.LNBackProfile      = RegistryRead:GetString("Milling.LNBackProfile",   "BackPanelProfile")
  Milling.LNBottomProfile    = RegistryRead:GetString("Milling.LNBottomProfile", "Bottom Profile")
  Milling.LNDrawNotes        = RegistryRead:GetString("Milling.LNDrawNotes",     "Drawing Notes")
  Milling.LNFingerBox        = RegistryRead:GetString("Milling.LNFingerBox",     "BoxJoint")
  Milling.LNFrontPocket      = RegistryRead:GetString("Milling.LNFrontPocket",   "Front Panel Pocket")
  Milling.LNFrontProfile     = RegistryRead:GetString("Milling.LNFrontProfile",  "Front Panel Profile")
  Milling.LNPartLabels       = RegistryRead:GetString("Milling.LNPartLabels",    "LabelParts")
  Milling.LNSidePocket       = RegistryRead:GetString("Milling.LNSidePocket",    "Side Panel Pocket")
  Milling.LNSideProfile      = RegistryRead:GetString("Milling.LNSideProfile",   "Side Panel Profile")
  Milling.LNBackPocketColor       = RegistryRead:GetString("Milling.LNBackPocketColor",    "Blue")
  Milling.LNBackProfileColor      = RegistryRead:GetString("Milling.LNBackProfileColor",   "Black")
  Milling.LNBottomProfileColor    = RegistryRead:GetString("Milling.LNBottomProfileColor", "Black")
  Milling.LNDrawNotesColor        = RegistryRead:GetString("Milling.LNDrawNotesColor",     "Blue")
  Milling.LNFingerBoxColor        = RegistryRead:GetString("Milling.LNFingerBoxColor",     "Green")
  Milling.LNFrontPocketColor      = RegistryRead:GetString("Milling.LNFrontPocketColor",   "Green")
  Milling.LNFrontProfileColor     = RegistryRead:GetString("Milling.LNFrontProfileColor",  "Red")
  Milling.LNPartLabelsColor       = RegistryRead:GetString("Milling.LNPartLabelsColor",    "Black")
  Milling.LNSidePocketColor       = RegistryRead:GetString("Milling.LNSidePocketColor",    "Blue")
  Milling.LNSideProfileColor      = RegistryRead:GetString("Milling.LNSideProfileColor",   "Green")
  Milling.PartGap                   = RegistryRead:GetDouble("Milling.PartGap",           0.7500)
  Milling.PocketClearance           = RegistryRead:GetDouble("Milling.PocketClearance",   0.0500)
  Milling.PocketToolDia             = RegistryRead:GetDouble("Milling.PocketToolDia",     0.2500)
  Milling.ProfileToolDia            = RegistryRead:GetDouble("Milling.ProfileToolDia",    0.2500)
  Milling.ProfileToolRadius         = RegistryRead:GetDouble("Milling.ProfileToolRadius", 0.1250)
  Project.CodeBy                    = RegistryRead:GetString("Project.CodeBy",              "James Anderson")
  Project.DatFile                   = RegistryRead:GetString("Project.DatFile",           "Defalt")
  Project.DrawerName                = RegistryRead:GetString("Project.DrawerName",          "C1")
  Project.ProgramContact            = RegistryRead:GetString("Project.ProgramContact",      "Who")
  Project.ProgramName               = RegistryRead:GetString("Project.ProgramName",         "Easy Drawer Maker")
  Project.ProgramVersion            = RegistryRead:GetString("Project.ProgramVersion",      Project.ProgramVersion)
  Project.ProgramYear               = RegistryRead:GetString("Project.ProgramYear",        "2020")
  Project.ProjectContactEmail       = RegistryRead:GetString("Project.ProjectContactEmail","Defalt@Email.com")
  Project.ProjectContactName        = RegistryRead:GetString("Project.ProjectContactName", "Defalt")
  Project.ProjectContactPhoneNumber = RegistryRead:GetString("Project.ProjectContactPhoneNumber", "(123)456-7890")
  Project.ProjectName               = RegistryRead:GetString("Project.ProjectName",       "DRAWER PROJECTS")
  Project.ProjectPath               = RegistryRead:GetString("Project.ProjectPath",       "Defalt")
  DialogWindow.ProjectXY            = RegistryRead:GetString("DialogWindow.ProjectPath",   " x ")
  DialogWindow.MillingXY            = RegistryRead:GetString("DialogWindow.MillingXY",     " x ")
  DialogWindow.AboutXY              = RegistryRead:GetString("DialogWindow.AboutXY",       " x ")
  DialogWindow.DrawerXY              = RegistryRead:GetString("DialogWindow.DrawerXY",     " x ")
  return true
end
-- =====================================================]]
function REG_UpdateRegistry() -- Write to Registry values
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
        RegValue = RegistryWrite:SetDouble("Milling.PartGap",                   Milling.PartGap)
        RegValue = RegistryWrite:SetDouble("Milling.PocketToolDia",             Milling.PocketToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.FingerToolDia",             Milling.FingerToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.ProfileToolDia",            Milling.ProfileToolDia)
        RegValue = RegistryWrite:SetDouble("Milling.PocketClearance",           Milling.PocketClearance)
        RegValue = RegistryWrite:SetDouble("Milling.FingerClearance",           Milling.FingerClearance)
        RegValue = RegistryWrite:SetDouble("Milling.DadoHeight" ,               Milling.DadoHeight)
        RegValue = RegistryWrite:SetString("Project.DrawerName",                Project.DrawerName)
        RegValue = RegistryWrite:SetString("Project.CodeBy",                    Project.CodeBy)
        RegValue = RegistryWrite:SetString("Project.ProgramContact",            Project.ProgramContact)
        RegValue = RegistryWrite:SetString("Project.ProgramName",               Project.ProgramName)
        RegValue = RegistryWrite:SetString("Project.ProgramVersion",            Project.ProgramVersion)
        RegValue = RegistryWrite:SetString("Project.ProgramYear",               Project.ProgramYear)
        RegValue = RegistryWrite:SetString("Project.ProjectContactEmail",       Project.ProjectContactEmail)
        RegValue = RegistryWrite:SetString("Project.ProjectContactName",        Project.ProjectContactName)
        RegValue = RegistryWrite:SetString("Project.ProjectContactPhoneNumber", Project.ProjectContactPhoneNumber)
        RegValue = RegistryWrite:SetString("Project.ProjectName",               Project.ProjectName)
        RegValue = RegistryWrite:SetString("Project.ProjectPath",               Project.ProjectPath)
        RegValue = RegistryWrite:SetString("Project.DatFile",                   Project.DatFile)
        RegValue = RegistryWrite:SetDouble("Drawer.OpeningDepth",               Drawer.OpeningDepth)
        RegValue = RegistryWrite:SetDouble("Drawer.OpeningHeight",              Drawer.OpeningHeight)
        RegValue = RegistryWrite:SetDouble("Drawer.OpeningLength",              Drawer.OpeningLength)
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

  -- DeBug(9360,4, "StartDate")
  -- return os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p")
  return os.date("%Y%m%d%H%M")
end
-- =====================================================]]
function GetDistance(objA, objB)
  -- Get the length for each of the components x and y
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end
-- =====================================================]]
function DrawWriter(what, where, size, lay, ang)
  local strlen = string.len(what)
  local strup = string.upper(what)
  local x = strlen
  local i = 1
  local y = ""
  local ptx = where
  while i <=  x do
    y = string.byte(string.sub(strup, i, i))
    ptx = DrawCADLeters(Milling.job, ptx, y , size, lay, ang)
    i = i + 1
  end
  return true
end-- function end
-- =====================================================]]
function DrawCADLeters(job, pt, letter, scl, lay, ang)
  scl = (scl * 0.5)
  local pA0 = pt ; local pA1 = Polar2D(pt, ang + 90.0000, (0.2500 * scl)) ; local pA2 = Polar2D(pt, ang + 90.0000, (0.5000 * scl)) ; local pA3 = Polar2D(pt, ang + 90.0000, (0.7500 * scl)) ; local pA4 = Polar2D(pt, ang + 90.0000, (1.0000 * scl)) ; local pA5 = Polar2D(pt, ang + 90.0000, (1.2500 * scl)) ; local pA6 = Polar2D(pt, ang + 90.0000, (1.5000 * scl)) ; local pA7 = Polar2D(pt, ang + 90.0000, (1.7500 * scl)) ; local pA8 = Polar2D(pt, ang + 90.0000, (2.0000 * scl)) ; local pB0 = Polar2D(pt, ang +  0.0000, (0.2500 * scl)) ; local pB1 = Polar2D(pt, ang + 45.0000, (0.3536 * scl)) ; local pB3 = Polar2D(pt, ang + 71.5651, (0.7906 * scl)) ; local pB4 = Polar2D(pt, ang + 75.9638, (1.0308 * scl)) ; local pB5 = Polar2D(pt, ang + 78.6901, (1.2748 * scl)) ; local pB7 = Polar2D(pt, ang + 81.8699, (1.7678 * scl)) ; local pB8 = Polar2D(pt, ang + 82.8750, (2.0156 * scl)) ; local pB10 = Polar2D(pt, ang + 84.2894, (2.5125 * scl)) ; local pC0 = Polar2D(pt, ang +  0.0000, (0.5000 * scl)) ; local pC2 = Polar2D(pt, ang + 45.0000, (0.7071 * scl)) ; local pC8 = Polar2D(pt, ang + 75.9638, (2.0616 * scl)) ; local pC10 = Polar2D(pt,78.6901, (2.5125 * scl)) ; local pD0 = Polar2D(pt, ang +  0.0000, (0.6250 * scl)) ; local pD1 = Polar2D(pt, ang + 21.8014, (0.6731 * scl)) ; local pD4 = Polar2D(pt, ang + 57.9946, (1.1792 * scl)) ; local pD7 = Polar2D(pt, ang + 70.3462, (1.8583 * scl)) ; local pD8 = Polar2D(pt, ang + 72.6460, (2.0954 * scl)) ; local pE0 = Polar2D(pt, ang +  0.0000, (0.7500 * scl)) ; local pE2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ; local pE3 = Polar2D(pt, ang + 45.0000, (1.0607 * scl)) ; local pE8 = Polar2D(pt, ang + 69.4440, (2.1360 * scl)) ; local pF0 = Polar2D(pt, ang +  0.0000, (1.0000 * scl)) ; local pF3 = Polar2D(pt, ang + 36.8699, (1.2500 * scl)) ; local pF4 = Polar2D(pt, ang + 45.0000, (1.4142 * scl)) ; local pF7 = Polar2D(pt, ang + 60.2551, (2.0156 * scl)) ; local pF8 = Polar2D(pt, ang + 63.4349, (2.2361 * scl)) ; local pF10 = Polar2D(pt,59.0362, (2.9155 * scl)) ; local pG0 = Polar2D(pt, ang +  0.0000, (1.2500 * scl)) ; local pG1 = Polar2D(pt, ang + 11.3099, (1.2748 * scl)) ; local pG2 = Polar2D(pt, ang + 21.8014, (1.3463 * scl)) ; local pG3 = Polar2D(pt, ang + 30.9638, (1.4577 * scl)) ; local pG4 = Polar2D(pt, ang + 38.6598, (1.6008 * scl)) ; local pG5 = Polar2D(pt, ang + 45.0000, (1.7678 * scl)) ; local pG6 = Polar2D(pt, ang + 50.1944, (1.9526 * scl)) ; local pG7 = Polar2D(pt, ang + 54.4623, (2.1506 * scl)) ; local pG8 = Polar2D(pt, ang + 57.9946, (2.3585 * scl)) ; local pH0 = Polar2D(pt, ang +  0.0000, (1.5000 * scl)) ; local pH10 = Polar2D(pt,63.4349, (2.7951 * scl)) ; local group = ContourGroup(true) ; local layer = job.LayerManager:GetLayerWithName(lay) ; local line = Contour(0.0) ;
  if letter  ==   65 then
    line:AppendPoint(pA0) ; line:LineTo(pD8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pF3) ; layer:AddObject(CreateCadContour(line), true) ; end
    if letter  ==   66 then
      line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; end
    if letter  ==   67 then
      line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   68 then
      line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   69 then  line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   70 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   71 then
      line:AppendPoint(pG6)
      line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   72 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   73 then
      line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0
    end
    if letter  ==   74 then  line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   75 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   76 then
      line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   77 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   78 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0
    end
    if letter  ==   79 then
      line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   80 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   81 then
      line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   82 then
      line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   83 then
      line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   84 then
      line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   85 then
      line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   86 then
      line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   87 then
       line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   88 then
      line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   89 then
      line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   90 then
      line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   48 then
      line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   49 then
      line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   50 then
      line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   51 then
      line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   52 then
      line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   53 then
      line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   54 then
      line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   55 then
      line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   56 then
      line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ;
    end
    if letter  ==   57 then
      line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   47 then
      line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0
    end
    if letter  ==   43 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   61 then
      line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   45 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   39 then
      line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0
    end
    if letter  ==   34 then
      line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0
    end
    if letter  ==   40 then
      line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0
    end
    if letter  ==   41 then
      line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0
    end
    if letter  ==   60 then
      line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   62 then
      line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   95 then
      line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   58 then
      line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0
    end
    if letter  ==   46 then
      line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0
    end
    if letter  ==   59 then
      line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0
    end
    if letter  ==   35 then
      line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   32 then
      pH0 = pH0
    end
    if letter  ==   33 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   36 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   37 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   38 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   42 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   63 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   64 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   91 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   92 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   93 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   94 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   96 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   123 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   124 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   125 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter  ==   126 then
      line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    return pH0
  end-- function end
-- =====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end-- function end
-- =====================================================]]
function NewSheet(X)
  -- Note: I did not write this code. Not sure where I got it.
  local layer_manager = Milling.job.LayerManager
  -- get current sheet count - note sheet 0 the default sheet counts as one sheet
  --local orig_num_sheets = layer_manager.NumberOfSheets
  -- get current active sheet index
  --local orig_active_sheet_index = layer_manager.ActiveSheetIndex
  -- set active sheet to last sheet
  local num_sheets = layer_manager.NumberOfSheets
  layer_manager.ActiveSheetIndex = num_sheets - 1
  -- Add a new sheet
  layer_manager:AddNewSheet()
  -- set active sheet to last sheet we just added
  num_sheets = layer_manager.NumberOfSheets
  layer_manager.ActiveSheetIndex = num_sheets - 1
  Milling.job:Refresh2DView()
  StampIt(X)
  return true
end
-- =====================================================]]
function InquiryDrawer(Header)
  Drawer.dialog = HTML_Dialog(true, DialogWindow.myHtml1, 582, 474,  Header)
  if Project.ProjectPath == "Default"  then
    Drawer.dialog:AddLabelField("Alert", "Project Path is required")
  else
    Drawer.dialog:AddLabelField("Alert", "")
  end
  Drawer.dialog:AddIntegerField("Drawer.SideFingerCount",    Drawer.SideFingerCount)
  Drawer.dialog:AddDoubleField("Drawer.OpeningHeight",   Drawer.OpeningHeight)
  Drawer.dialog:AddDoubleField("Drawer.OpeningDepth",    Drawer.OpeningDepth)
  Drawer.dialog:AddDoubleField("Drawer.OpeningLength",   Drawer.OpeningLength)
  Drawer.dialog:AddDoubleField("Drawer.SideThickness",   Drawer.SideThickness)
  Drawer.dialog:AddDoubleField("Drawer.BackThickness",   Drawer.BackThickness)
  Drawer.dialog:AddDoubleField("Drawer.FrontThickness",  Drawer.FrontThickness)
  Drawer.dialog:AddDoubleField("Drawer.BottomThickness", Drawer.BottomThickness)
  Drawer.dialog:AddDoubleField("Drawer.SideGap",         Drawer.SideGap)
  Drawer.dialog:AddDoubleField("Drawer.TopGap",          Drawer.TopGap)
  Drawer.dialog:AddDoubleField("Drawer.BottomGap",       Drawer.BottomGap)
  Drawer.dialog:AddDoubleField("Drawer.Count",           Drawer.Count)
  Drawer.dialog:AddTextField("Project.DrawerName",       Project.DrawerName)
  Drawer.dialog:AddLabelField("ToolNameLabel1", "Not Selected")
  Drawer.dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1) -- Profile
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton1", Tool.END_MILL)
  Drawer.dialog:AddLabelField("ToolNameLabel2", "Not Selected")
  Drawer.dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2) -- Dados
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
  Drawer.dialog:AddLabelField("ToolNameLabel3", "Not Selected")
  Drawer.dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3) -- Dado Clearing
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton3", Tool.END_MILL)
  Drawer.dialog:AddLabelField("ToolNameLabel4", "Not Selected")
  Drawer.dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID4) -- Finger
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton4", Tool.END_MILL)
  Drawer.dialog:AddLabelField("ToolNameLabel5", "Not Selected")
  Drawer.dialog:AddToolPicker("ToolChooseButton5", "ToolNameLabel5", Tool_ID5) -- Finger Clearing
  Drawer.dialog:AddToolPickerValidToolType("ToolChooseButton5", Tool.END_MILL)

  if Drawer.dialog:ShowDialog() then
    Drawer.SideFingerCount   = Drawer.dialog:GetIntegerField("Drawer.SideFingerCount")
    Drawer.OpeningHeight   = Drawer.dialog:GetDoubleField("Drawer.OpeningHeight")
    Drawer.OpeningDepth    = Drawer.dialog:GetDoubleField("Drawer.OpeningDepth")
    Drawer.OpeningLength   = Drawer.dialog:GetDoubleField("Drawer.OpeningLength")
    Drawer.SideThickness   = Drawer.dialog:GetDoubleField("Drawer.SideThickness")
    Drawer.BackThickness   = Drawer.dialog:GetDoubleField("Drawer.BackThickness")
    Drawer.FrontThickness  = Drawer.dialog:GetDoubleField("Drawer.FrontThickness")
    Drawer.BottomThickness = Drawer.dialog:GetDoubleField("Drawer.BottomThickness")
    Drawer.SideGap         = Drawer.dialog:GetDoubleField("Drawer.SideGap")
    Drawer.TopGap          = Drawer.dialog:GetDoubleField("Drawer.TopGap")
    Drawer.BottomGap       = Drawer.dialog:GetDoubleField("Drawer.BottomGap")
    Drawer.Count           = Drawer.dialog:GetDoubleField("Drawer.Count")
    Project.DrawerName     = Drawer.dialog:GetTextField("Project.DrawerName")
    Milling.MillTool1      = Drawer.dialog:GetTool("ToolChooseButton1")  -- Profile
    Milling.MillTool2      = Drawer.dialog:GetTool("ToolChooseButton2")  -- Dados
    Milling.MillTool3      = Drawer.dialog:GetTool("ToolChooseButton3")  -- Dado Clearing
    Milling.MillTool4      = Drawer.dialog:GetTool("ToolChooseButton4")  -- Finger
    Milling.MillTool5      = Drawer.dialog:GetTool("ToolChooseButton5")  -- Finger Clearing
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
  dialog:AddTextField("Project.ProjectName",               Project.ProjectName) ;
  dialog:AddTextField("Project.ProjectContactEmail",       Project.ProjectContactEmail) ;
  dialog:AddTextField("Project.ProjectContactName",        Project.ProjectContactName) ;
  dialog:AddTextField("Project.ProjectContactPhoneNumber", Project.ProjectContactPhoneNumber) ;
  dialog:AddTextField("Project.DrawerID",                  StartDate()) ;
  dialog:AddTextField("Project.ProjectPath",               Project.ProjectPath ) ;
  dialog:AddDirectoryPicker("DirectoryPicker",             "Project.ProjectPath" , true) ;
  if dialog:ShowDialog() then
    Project.ProjectName               = dialog:GetTextField("Project.ProjectName")
    Project.ProjectContactEmail       = dialog:GetTextField("Project.ProjectContactEmail")
    Project.ProjectContactName        = dialog:GetTextField("Project.ProjectContactName")
    Project.ProjectContactPhoneNumber = dialog:GetTextField("Project.ProjectContactPhoneNumber")
    Project.DrawerID                  = dialog:GetTextField("Project.DrawerID")
    Project.ProjectPath               = dialog:GetTextField("Project.ProjectPath")
    DialogWindow.ProjectXY = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
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
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, 648, 366, "Layer Setup") ;
  dialog:AddTextField("Milling.LNBottomProfile",         Milling.LNBottomProfile)
  dialog:AddTextField("Milling.LNSideProfile",           Milling.LNSideProfile)
  dialog:AddTextField("Milling.LNSidePocket",            Milling.LNSidePocket)
  dialog:AddTextField("Milling.LNFrontProfile",          Milling.LNFrontProfile)
  dialog:AddTextField("Milling.LNFrontPocket",           Milling.LNFrontPocket)
  dialog:AddTextField("Milling.LNBackProfile",           Milling.LNBackProfile)
  dialog:AddTextField("Milling.LNBackPocket",            Milling.LNBackPocket)
  dialog:AddTextField("Milling.LNDrawNotes",             Milling.LNDrawNotes)
  dialog:AddTextField("Milling.LNPartLabels",            Milling.LNPartLabels)
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
    Milling.LNBottomProfile      = dialog:GetTextField("Milling.LNBottomProfile")
    Milling.LNSideProfile        = dialog:GetTextField("Milling.LNSideProfile")
    Milling.LNSidePocket         = dialog:GetTextField("Milling.LNSidePocket")
    Milling.LNFrontProfile       = dialog:GetTextField("Milling.LNFrontProfile")
    Milling.LNFrontPocket        = dialog:GetTextField("Milling.LNFrontPocket")
    Milling.LNBackProfile        = dialog:GetTextField("Milling.LNBackProfile")
    Milling.LNBackPocket         = dialog:GetTextField("Milling.LNBackPocket")
    Milling.LNDrawNotes          = dialog:GetTextField("Milling.LNDrawNotes")
    Milling.LNPartLabels         = dialog:GetTextField("Milling.LNPartLabels")
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

  local dialog = HTML_Dialog(true, DialogWindow.myHtml4, 560, 195, "Milling Setting ")
  dialog:AddDoubleField("Milling.PocketClearance", Milling.PocketClearance)
  dialog:AddDoubleField("Milling.DadoHeight",      Milling.DadoHeight)
  dialog:AddDoubleField("Milling.PartGap",         Milling.PartGap)
  dialog:AddDoubleField("Milling.FingerClearance", Milling.FingerClearance)
  dialog:AddDoubleField("Milling.ProfileToolDia",  Milling.ProfileToolDia)
  dialog:AddDoubleField("Milling.FingerToolDia",   Milling.FingerToolDia)
  if dialog:ShowDialog() then
    Milling.PocketClearance = dialog:GetDoubleField("Milling.PocketClearance")
    Milling.FingerClearance = dialog:GetDoubleField("Milling.FingerClearance")
    Milling.DadoHeight      = dialog:GetDoubleField("Milling.DadoHeight")
    Milling.PartGap         = dialog:GetDoubleField("Milling.PartGap")
    Milling.ProfileToolDia  = dialog:GetDoubleField("Milling.ProfileToolDia")
    Milling.FingerToolDia   = dialog:GetDoubleField("Milling.FingerToolDia")
    DialogWindow.MillingXY = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
function StampIt(Thick)
  local mtl_block = MaterialBlock()
  local mtl_box = mtl_block.MaterialBox
  local pt1Text = Point2D(0.5, mtl_box.TLC.Y - 1.25)
  DrawWriter("Alert: Material Thinkness = " .. Thick, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.5)
  DrawWriter(Project.ProgramName, pt1Text, 0.3, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.35)
  DrawWriter("Project ID: " .. Project.DrawerID, pt1Text, 0.25, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.25)
  DrawWriter("Version: " .. Project.ProgramVersion, pt1Text, 0.20, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.25)
  DrawWriter("Gadget By: " .. Project.CodeBy, pt1Text, 0.20, Milling.LNDrawNotes, 0.0)
  return true
end
-- =====================================================]]
function main() -- script_path
  Milling.job = VectricJob()
  if not Milling.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  HTML()
  REG_ReadRegistry()
  Drawer_Math()
  local mtl_block = MaterialBlock()
  local mtl_thick = mtl_block.Thickness
  local R1, R2, R3
  local DialogLoop = 1
  while DialogLoop == 1 do
    if InquiryDrawer("Easy Drawer Maker") then
      if Project.ProjectPath == "Default"  then
        MessageBox("Error: Cannot find project setup data. \n Rerun program and setup Project.")
        DialogLoop = 1
      elseif Drawer.OpeningDepth < (10 * Drawer.SideThickness) then
        MessageBox("Error: Drawer Opening Depth is too small of value. \nEnter a larger Drawer Depth value or enter a smaller Side Thickness")
        DialogLoop = 1
      elseif (Drawer.SideWidth / Drawer.SideFingerCount) < (Milling.FingerToolDia / 0.70) then
        MessageBox("Error: Number of fingers is to high to alow proper milling. \nReduce the Finger Count to ~" .. tostring(math.ceil(Drawer.SideWidth/(Milling.FingerToolDia / 0.70))) .. " fingers.")
        DialogLoop = 1
      elseif Drawer.SideFingerCount < 1 then
        MessageBox("Error: Drawer Count cannot be less than 1")
        DialogLoop = 1
      else
        DialogLoop = 2 -- Good to Go
      end
    else
      DialogLoop = 0  -- pressed Cancel
    end
  end

  if DialogLoop == 2 then
    R1, R2, R3 =   os.rename(Project.ProjectPath, Project.ProjectPath)
    if not(R1) then
      if R3 == 13 then
        DisplayMessageBox("Alert: " .. R2 .. "\nYou may have a file open in the Directory")
      else
        DisplayMessageBox("Error: " .. R2)
        return false
      end
    end -- if not R1
    if type(Milling.MillTool1) == "userdata"  then
      Milling.Profile = true
    else
      Milling.Profile = false
    end  -- if end
    if type(Milling.MillTool2) == "userdata" then --  and type(Milling.MillTool3) == "userdata") then
      Milling.Dado = true
    else
      Milling.Dado = false
    end  -- if end
    if type(Milling.MillTool4) == "userdata" then -- and type(Milling.MillTool5) == "userdata") then
      Milling.Finger = true
    else
      Milling.Finger = false
    end  -- if end
    CutBySheets()
    Drawer_Math()
    MakeLayers()
    REG_ReadRegistry()
    StampIt(mtl_thick) -- Job Setup thickness
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
       Drawer.WP = Point2D(1, 1)
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
       Drawer.WP = Point2D(1, 1)
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
       Drawer.WP = Point2D(1, 1)
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
  end
  Milling.job:Refresh2DView()
  return true
end
-- =====================================================]]
function ProcessSide()
  for _ = 1, Drawer.Count do
    Drawer_Side()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, Drawer.SideWidth + Milling.PartGap)    -- Left Side
  end
  -- Drawer.WP = Polar2D(Drawer.WP, 180.0, Milling.PartGap)                         -- Left Side
  CreateLayerDadoToolpath("Side Dado", Milling.LNSidePocket, 0.0, (Drawer.SideThickness - Milling.DadoHeight))
  CreateLayerFingerToolpath("Side-Fingers", "Side-" .. Milling.LNFingerBox, 0.0, Drawer.SideThickness)
  CreateLayerProfileToolpath("Side-Profile", Milling.LNSideProfile, 0.0, Drawer.SideThickness, "OUT")
  return true
end
-- =====================================================]]
function ProcessFront()
  for _ = 1, Drawer.Count do
    Drawer_Front()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, Drawer.SideWidth + Milling.PartGap)   --  Front Panel
  end
  CreateLayerDadoToolpath("Front Dado", Milling.LNFrontPocket, 0.0, (Drawer.FrontThickness - Milling.DadoHeight))
  CreateLayerFingerToolpath("Front-Fingers", "Front-" .. Milling.LNFingerBox, 0.0, Drawer.FrontThickness)
  CreateLayerProfileToolpath("Front-Profile", Milling.LNFrontProfile, 0.0, Drawer.FrontThickness, "OUT")
  return true
end
-- =====================================================]]
function ProcessBack()
  for _ = 1, Drawer.Count do
    Drawer_Back()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, (Drawer.FrontWidth + Milling.PartGap))   -- Back Panel
  end
  CreateLayerDadoToolpath("Back Dado", Milling.LNBackPocket, 0.0, (Drawer.BackThickness - Milling.DadoHeight))
  CreateLayerProfileToolpath("Back-Profile", Milling.LNBackProfile, 0.0, Drawer.BackThickness, "OUT")
  return true
end
-- =====================================================]]
function ProcessBottom()
  for _ = 1, Drawer.Count do
    Drawer_Bottom()
    Drawer.WP = Polar2D(Drawer.WP, 0.0, (Drawer.BottomPanelWidth + Milling.PartGap))   -- Draw Panel Bottom
  end
  CreateLayerProfileToolpath("Bottom-Profile", Milling.LNBottomProfile, 0.0, Drawer.BottomThickness, "OUT")
  return true
end
-- =====================================================]]
function CutBySheets()
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
    pt2 = Polar2D(pt1,   180.0,    Drawer.BottomThickness + Milling.PocketClearance)
    pt3 = Polar2D(pt1,    90.0,    Drawer.SideLength + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,    90.0,    Drawer.SideLength + Milling.PocketToolDia)
   line = Contour(0.0)
  line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  -- Draw back dato
    pt2 = Polar2D(Drawer.WP,  90.0,    Drawer.SideLength - Drawer.BackDatoInset)
    pt1 = Polar2D(pt2,   180.0,    Milling.PocketToolRadius)
    pt2 = Polar2D(pt1,   270.0,    Drawer.BackThickness + Milling.PocketClearance)
    pt3 = Polar2D(pt1,     0.0,    Drawer.SideWidth + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,     0.0,    Drawer.SideWidth + Milling.PocketToolDia)
   line = Contour(0.0)
  line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  Drawer.WP = Polar2D(Drawer.WP, 0.0, (Drawer.SideWidth + Milling.PartGap))    -- Right Side
-- ====================================
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
    pt2 = Polar2D(pt1,   0.0, Drawer.BottomThickness + Milling.PocketClearance)
    pt3 = Polar2D(pt1,  90.0, Drawer.SideLength + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,  90.0, Drawer.SideLength + Milling.PocketToolDia)
    line = Contour(0.0); line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  -- Draw back dato
    pt2 = Polar2D(Drawer.WP, 90.0, Drawer.SideLength - Drawer.BackDatoInset)
    pt1 = Polar2D(pt2, 180.0, Milling.PocketToolRadius)
    pt2 = Polar2D(pt1, 270.0, Drawer.BackThickness + Milling.PocketClearance)
    pt3 = Polar2D(pt1,   0.0, Drawer.SideWidth + Milling.PocketToolDia)
    pt4 = Polar2D(pt2,   0.0, Drawer.SideWidth + Milling.PocketToolDia)
   line = Contour(0.0); line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  --Drawer.WP = Polar2D(Drawer.WP,  0.0,  Milling.PartGap)
  return true
end
-- =====================================================]]
function Drawer_Front()
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
        pt2 = Polar2D(pt1, 180.0, Drawer.BottomThickness + Milling.PocketClearance)
        pt3 = Polar2D(pt1,  90.0, Drawer.FrontLength + Milling.PocketToolDia)
        pt4 = Polar2D(pt2,  90.0, Drawer.FrontLength + Milling.PocketToolDia)
       line = Contour(0.0); line:AppendPoint(pt1); line:LineTo(pt2); line:LineTo(pt4); line:LineTo(pt3); line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- =====================================================]]
function Drawer_Back()
  local pt1 = Point2D(0,0)
  local pt1Text = pt1
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackProfile)
  local pt2 = Polar2D(Drawer.WP,  90.0,    Drawer.BackLength)
  local pt3 = Polar2D(pt2,     0.0,    Drawer.BackWidth)
  local pt4 = Polar2D(pt3,   270.0,    Drawer.BackLength)

  local line = Contour(0.0)
  line:AppendPoint(Drawer.WP) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(Drawer.WP)
  layer:AddObject(CreateCadContour(line), true)
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
        pt2 = Polar2D(pt1,   0.0, Drawer.BottomThickness + Milling.PocketClearance)
        pt3 = Polar2D(pt1,  90.0, Drawer.BackLength + Milling.PocketToolDia)
        pt4 = Polar2D(pt2,  90.0, Drawer.BackLength + Milling.PocketToolDia)
       line = Contour(0.0)
  line:AppendPoint(pt1) ; line:LineTo(pt2) ; line:LineTo(pt4) ; line:LineTo(pt3) ; line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- =====================================================]]
function Drawer_Bottom()
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
  file:write("================================================================ \n")
  file:write("=====================  Drawer Cut-list  ======================== \n")
  file:write("Run ID = ".. Project.DrawerID .."\n")
  file:write("Drawer Run Count = ".. Drawer.Count .."\n")
  file:write("================================================================ \n")
  file:write("Drawer Opening Size\n")
  file:write("Drawer Opening Height   = ".. Drawer.OpeningHeight .."\n")
  file:write("Drawer Opening Length   = ".. Drawer.OpeningLength .."\n")
  file:write("Drawer Opening Depth    = ".. Drawer.OpeningDepth .."\n")
  file:write("Drawer Opening Diagonal = ".. math.sqrt ((Drawer.OpeningHeight * Drawer.OpeningHeight)+ (Drawer.OpeningLength * Drawer.OpeningLength)) .."\n")
  file:write("Side Gap     .........  = ".. Drawer.SideGap .."\n")
  file:write("Bottom Gap   .........  = ".. Drawer.BottomGap .."\n")
  file:write("Top Gap      .........  = ".. Drawer.TopGap .."\n")
  file:write("----------------------------------------------------------------\n")
  file:write("Finish Depth  .........  = ".. Drawer.Depth .."\n")
  file:write("Finish Height .........  = ".. Drawer.Height .."\n")
  file:write("Finish Length .........  = ".. Drawer.Length .."\n")
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
      pt2 = SideFingerBox(pt1,   0.0)
      pt1 = Polar2D(pt2,   0.0, Drawer.SideFingerWidth)
    else
      pt2 = SideFingerBox(pt1, 180.0)
      pt1 = Polar2D(pt2, 180.0, Drawer.SideFingerWidth)
    end
  end
  return true
end  -- function end
-- =====================================================]]
function SideFingerBox(pta, ang)
  local Bit = math.sin(math.rad(45.0)) * (Milling.PocketToolDia * 0.5)
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
    local Bit = math.sin(math.rad(45.0)) * (Milling.PocketToolDia*0.5)
    local ptAx = Polar2D(pta, 180.0, Milling.FingerClearance * 0.5)
    local pt1 = Polar2D(ptAx,  90.0, Drawer.SideThickness)
    local pt2 = Polar2D(ptAx, 270.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
    local pt3 = Polar2D(pta,   0.0, Drawer.SideFingerWidth)
    local ptCx = Polar2D(pt3,  0, Milling.FingerClearance * 0.5)
    local pt4 = Polar2D(ptCx,  90.0, Drawer.SideThickness)
    local pt5 = Polar2D(ptCx, 270.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
    local ptw = Polar2D(pt1, 270.0, Bit)
    local ptx = Polar2D(pt1,   0.0, Bit)
    local pty = Polar2D(pt4, 180.0, Bit)
    local ptz = Polar2D(pt4, 270.0, Bit)
  if ang == 270.0 then
    ptAx = Polar2D(pta,  0.0, Milling.FingerClearance * 0.5)
    pt1 = Polar2D(ptAx, 270.0, Drawer.SideThickness)
    pt2 = Polar2D(ptAx,  90.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
    pt3 = Polar2D(pta,   0.0, Drawer.SideFingerWidth)
    ptCx = Polar2D(pt3, 180.0, Milling.FingerClearance * 0.5)
    pt4 = Polar2D(ptCx, 270.0, Drawer.SideThickness)
    pt5 = Polar2D(ptCx,  90.0, (Milling.FingerToolDia + Milling.FingerToolRadius))
    ptw = Polar2D(pt1,  90.0, Bit)
    ptx = Polar2D(pt1,   0.0, Bit)
    pty = Polar2D(pt4, 180.0, Bit)
    ptz = Polar2D(pt4,  90.0, Bit)
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
function MakeLayersx()
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackPocket)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackProfile)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBottomProfile)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFrontProfile)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNFrontPocket)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNDrawNotes)
  layer:SetColor (1.0, 0.0, 0.0)
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNPartLabels)
  layer:SetColor (0.0, 0.0, 1.0)
  return true
end
-- =====================================================]]

function MakeLayers()
  local Red, Green, Blue = 0, 0, 0
  -- What = the Cabinet type ("", Wall, or Bass)
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
  return true
end
-- ====================================================]]
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

   if type(Milling.MillTool3) == "userdata" then
   -- we just create a tool twice as large for testing here
--   local jim = Milling.MillTool3
    area_clear_tool = Tool(
                          Milling.MillTool3.Name,
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )
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
          tool.RateUnits    = Milling.MillTool4.RateUnits       -- Tool.MM_SEC     -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Milling.MillTool4.FeedRate        -- 30
          tool.PlungeRate   = Milling.MillTool4.PlungeRate      -- 10
          tool.SpindleSpeed = Milling.MillTool4.SpindleSpeed    -- 20000
          tool.ToolNumber   = Milling.MillTool4.ToolNumber      -- 1
      --  tool.VBitAngle    = Milling.MillTool.VBitAngle          -- 90.0            -- used for vbit only
      --  tool.ClearStepover = Milling.MillTool.ClearStepover   --  tool_dia * (tool_stepover_percent / 100)  -- used for vbit only
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
    if type(Milling.MillTool5) == "userdata" then
   -- we just create a tool twice as large for testing here
    area_clear_tool = Tool(
                          Milling.MillTool5.Name,
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )
     area_clear_tool.InMM         = Milling.MillTool5.InMM       -- tool_in_mm
     area_clear_tool.ToolDia      = Milling.MillTool5.ToolDia    -- tool_dia * 2
     area_clear_tool.Stepdown     = Milling.MillTool5.Stepdown   -- tool_stepdown * 2
     area_clear_tool.Stepover     = Milling.MillTool5.Stepover   -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits    = Milling.MillTool5.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate     = Milling.MillTool5.FeedRate      -- 30
     area_clear_tool.PlungeRate   = Milling.MillTool5.PlungeRate    -- 10
     area_clear_tool.SpindleSpeed = Milling.MillTool5.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber   = Milling.MillTool5.ToolNumber    -- 1
     -- area_clear_tool.VBitAngle     = Carrier.MillTool5.VBitAngle      -- 90.0 -- used for vbit only
     -- area_clear_tool.ClearStepover = Carrier.MillTool5.ClearStepover  -- tool_dia * 2 * (tool_stepover_percent / 100)  -- used for vbit only
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
-- =====================================================]]
function MarkPoint(Note, Pt, Size, LayerName)
  --[[
     | Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
     | Draws mark on the drawing
     | call = MarkPoint("Note: Hi", Pt1, 3, "Jim")
   ]]
      local layer = Milling.job.LayerManager:GetLayerWithName(LayerName)
      local marker1 = CadMarker(Note, Pt, Size)
      layer:AddObject(marker1, true)
      DrawCircle(Pt, 0.25, LayerName)
  return true
  end -- function end
-- =====================================================]]
function DrawCircle(Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- | draws a circle based on user inputs
  -- | job - current validated job unique ID
  -- | Cpt - (2Dpoint) center of the circle
  -- | CircleRadius - radius of the circle
  -- | Layer - layer name to draw circle (make layer if not exist)
  local pa = Polar2D(Cpt, 180.0, CircleRadius)
  local pb = Polar2D(Cpt,   0.0, CircleRadius)
  local line = Contour(0.0)
  line:AppendPoint(pa)
  line:ArcTo(pb,1)
  line:ArcTo(pa,1)
  local layer = Milling.job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
-- =====================================================]]
function HTML()
 -- DialogWindow.StyleButtonColor = "#3a4660"
 DialogWindow.StyleButtonColor = "#663300"
 DialogWindow.StyleButtonTextColor = "#FFFFFF"
 DialogWindow.StyleBackGroundColor = "#3a4660"
 DialogWindow.StyleTextColor = "#FFFFFF"
 -- ]].. Hinge.StyleTextColor .. [[
-- ]].. Hinge.StyleButtonTextColor .. [[
-- ]].. DialogWindow.StyleButtonColor ..[[ --
-- ]].. DialogWindow.StyleBackGroundColor  ..[[ -- #c9af98
-- =========================================================]]
DialogWindow.myBackGround = [[data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDACgcHiMeGSgjISMtKygwPGRBPDc3PHtYXUlkkYCZlo+AjIqgtObDoKrarYqMyP/L2u71////m8H////6/+b9//j/2wBDASstLTw1PHZBQXb4pYyl+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj/wAARCAHUAu4DASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDNApcUop1SUNxS4paWkMbijFOooAZijbT6QUAJto20/FGKAGYo20/FGKAGbaUClxTh0oAZtpdtOxS0hkZWjbTz1pMUxCbeKNtPxxRSGM20hWpKQ0AMxRtp9HemIZijbTwKMUgGbaXbTsUtAxm2jbT8UUAM20bafRQAwLS7aeBS4ouFiPbSbakxRii4WGbaAvNPxQBRcLDdtLtp+KMUrhYjK8Um2pSOKTFO4WGBaNtPA5pcUXCxHto21JijFFwsRbaCtPFBHFADAtG2n4pcUBYi20u2n4pcUXCwzbRtp+KMUBYj20bakpKAI9vNO204U7FFwsRFaNtSEZpMUXCxHto21JikxRcLCbaTbUlGKLhYZtpCtSYpCOaLhYj20u2nYp2KAsR7aNtPxRii4WIytGKeetFAEeKNtPxQKYhm2jbTsUYoAbto20+jFADMUbafSUAM20oXil707HFADNtJipKTFADNtG2n4pMUANApdtOFLQAzbSFafQaAI8UoWnYoFADcUwipaYaABadTRThQAUtFFABRijvS0gEpKWimAtLRSUhi0lLSUAFKKKBQAtFFFACGig0UAL2oo7UUAFBpRSN2oASjvRQaAFoNIKU0AFFFLQAlLijtSigBKQ0pooAFpaFopDFpKWkNABQOppaB1oAWiiigAPSkpT0pKAAUtIKWgAoPSgUvagBlB6UCg9KAAUtNpaAEpe1ApaAEpaO9Hc0AJiilNJQAg606kHUU6gBKKKKAEoNFFAC0UCigApvenUh60AJS0lLQAUUd6KAGnrRQetFMQlLSUUAFHeiigAoo7UUAGKSnUlACGlHSkpR0oAKKKKAEopaSgAFLSCloAKQ0tIaAE7UopKUUAIaYaeelMNMQLTqatOoAWiijvQAd6WkHWlpAJRQaKYDqKKKQwooooASndqbTqACiiigANJSmkoAXtS0gpaACkNKKDQAlIaWigBBSmkFLQAUtJS0AFLSUtIBDSU40hoAUdDS0L3paBiUUGjvQAhzTlpD1oWgB1FHeikAh6UlOPSm0wFHWl7Ug60tABR2ope1IBlFFFMBo606k70tACCloFAoAKBRSigAxTadTaAAdadTR1p5oASkpcUlABSClPSk70AOooNHagBKQ96dTTQAlOptOoASloooAaetJSnrSUxCGgUHpQKAA0UUtACUelLSd6AFpDS0hoASlHSkpw6UAFJS0lABSHrS0lACiigdKKACkNLQaAG0o6UlKKBAelMNPNMNMBBThTRTqAFpaTtS0AIKWjvRSGBpKU0lMQ6iiikMKO1FFAAaWkPSl7UAFFFLQAhpKU0UAFLSUtABQaWkNIBBQaKQ9aYCjpRRRQAUtHelpAFLSUooGBptOPSm+tADl6GlpF6U6gBKO9FFAB60L3ooXqaAFoopaQxOxpKd2ptAgFLQKWgBKXtRQelAxlKRSUHpTEJjml70CloASlFJ2p1ACdqBS0goAWmmnU00AA606m/xU6gApKWkoAQ9qD1pfSkNAC0UppKACkPWlpD1oASig0tACUtFFADT1o7UHrRTENNHajvS0AJS0UCgAooooAKDRQaAG04dKb2pw6UAFJS0lABSdqWjtQADpRQOlFABQaKDQAlAooFAhDTTTzTD1pgIKdTRTqAFpaSloAO9LSClpDENJSmkoEOoNLSUDCjtRRQAUvak7UvagApaSloAQ0UGkoAcOlFFFAC0hpe9IaQCd6DQKD1pgApaSloAKUUlKKQwpR0pKdQAh6UlKaSgBV706mr3p3agBKO9FAoABSr1NAoHU0ALRRRSGHakpx6U2gQClpB3paBhQelL2oPSgBnaj+GilPSmIaODS0gpaAClpKWgAoHWlpBSGLTTTqaaBCd6fTe4p1ACGkpTSUwD0oPaig0AKaSlNFABTT1p1NNACUtJTqAEoopaAGHrSd6caQUxDTSijvRQAUUUUAFFFHegBaQ0tIaAEpR0pKUdKACkpTSUAFFFFAAOlFA6UUALSHpS0hoASgUUCgANMNPNMNMQi06min0AFLSUtIAFLSCloGJSUppKAH0lLSGgAooooAWjtRS9qAEpaKKAENFBooAXtSigdKKQw70hpaGoAaKD1pRSEHNMQDpSmiigBe9AopRSGFLSUtAA1Npx6UlACr3paRe9L2oASgUUtAAKUdaBQOtIYd6WjFFAAelNpx6U2gBV60tC9aWgA7UdqKO1ADKD0opSOKBDB1p1IAfSlpgFFFLSAKBS0AUDDtTT1p1NNACd6fTO4p9ADTSUpooEFBoFBoADRSmigBKaadTTTASnUlOoASjvRR3oAaetIKU9aBQAw9aWjByeKKYg70UUUALSUtFAB3pDS0hoASlHSkpR0oAKSlNJQAUtJS0AIOlFKKKACkNLSGgBKBRSigBDTG6080xqYhFp4pi08UAFOppp1IYUUUd6AENFBooAdSGloNACUopKUUAJ3p3am07tQAUGiigBKKKKAHDpRSClpDFpDS0jUAJ3pwpKUUAIaKDRQAUq9KKFoAdRRRSAQ9KSnHpTaYCrTu1ItLSAb3paKWgBG6Uq0HmlXvQMWiiigBtFKaSgAXrTqQUtAC0dqKO1IBlOFJSimAGm089KZQACgdRSikHUUAOopaSgAppp1NNACd6dTe9PoAa1JSmigAFNHWndqToaAHUlKaSgBDTaeabTEIetOpp60tAC0d6BRQA09aQUrdaSgBaaetOpp60AFBooNMQo6UUDpRSGIaDS0hpiG0o6UlKOlAC02nU2gAoPWl70hoAUdKKB0ooAKbTqbQAUCigUABphp5phpiEFPFMFPFABTqbTqQwooooAQ9aKDRQA6iikoAKUUlKKADtS9qKO1ABRRRQAlFFFACilpBS0hhmg0UGgAFKOlJSigBDSU40lAAe1KtJTloAWiiigAPSkpTTe9ADl70tItKaQw70d6KB1oAXvQvU0ooHWgAoo70tADTRSmkoABS0DrS0AGcUZ4oo7UgG04UgpRTAG6UzvTzTaADsaQdRS9qB1oAdSUtFIA70w06mmmAd6dTR1FOoAQ9KSlpKADtQaX0oNAAaSlNFACGmmndqbQIQ0tBpaYCUZpaSgBD1pKU0UAL2php1IetACUHrRSUxDh0oNA6UUhiUGlpDQIbSjpSU4dKYBSUGigA70UUdqAAdKKBRQAUlLSGgBKKKBQAGmGnmmHrTEItPpopwoAO9OptOpDCiiigBKKDRQA6kpaKACgUUdqACl7UlO7UAIKKWkpDA9aKKKYhRS0nalpDEoNLSHtQAClFIOtOoAQ9aSlNJQAtKtJ2pVoAWiiikMKTvTj0pvrTEKtKaFpTSGJRS0DrQAp6ULRjNC9TQAveiloNIY00ClPSkpiAU6kFKKQBRS96SgY2lpO1OFAhD0pKdTe9MA9KQdaWgdaAHUlLSUhhTTTxTDTEIOtOpP4qd2oAbQaWkoABSU7tSEYoAU0nanUlADaQ9adTaAENLSGlpiCkpaDQA09aKU9aSgBaae9OppoATvR6UUUCFHSigdKKBiUhp1IaAG04dKSlHSmISiiigAoNFFAAOlFA6UUAFIaWkNACUopKUUAIaYetPphpiAU6mCn0AFOptOpDCjvQOtFAAaSlooAWiiigAopaSgBaUdKSigBaKSlpDE70Ud6KYhfSlpO1LSGFJ6UtBoAKKO9FAB2pKU9KSgBaVaSlHSgBaWkp1IYh6UlLjikoEKtOpBS0DCkpRR2oAXoKB1oooAWg0lL2pDA0lKelIKBAKUdqF60tAwpO9LQaAG0tJ2paADvTTTu9NoEFHcUUvemAtFFA6GkMBwaaacRzSUCGjrTqTvTqAEpKXvQaAEFIeaWimAtJRmigBKb3p1N70ABpe9IaWgApD0paTtQAh60lKetJTEB6Uhpe1IaAEoNFFMQo6Ud6O1HekMDSGlNIaAEpR0pKUdKYgpKXtRQAlFLSUAApaSigApDS0hoAKO1FAoADUZqQ1G1MQgp4pi0/tQAU6m06kMB1paSloAQ0UGigBaKKKAFpO9LQetABRRSUAKKWk70tIYho7UGjtQIX0paB0ooGAoNFBoAKKKO1AB2pKU0UAFKvSm+9OWgB1LSUtIYh6UUHpRQAopRzQvelxQACg9KBSnpSAQCj0o60HtQAUvajtR2oGB6UlKelAoAB3paF6ml70AJSnpR3pKAE7UtAooATvSUppKACgdRQfSgdaBDsUCigUDA03vTqb3oAO9Lmk704jmgBKKKWgBh6mg0ueaTtTEJ2oFApR1oASkPWlpD1oAQ0vekNONACGig0lACHrRQetFMQh6UhpaQ0AJRS033oEOHSl70g6UUDFNNNOppoASl7UlOHSgQlFLRTGIaSlNJQIO9JS96KACkNLSGgAoHSigUABqM1IajPWmhCCn0xaeKAA06m9aWkMUUtIKWgBDRQetHagB3aikFLQAUGikPWgBaTvSikoAdRSUtIYhooNLQIOwpaB0ooGFBoooAKKO9FAAaBQaO1AAOlKvSkz0FKKAFp/amYp46UhiHpSd6U9KT+KgBy96UdaaKdQAClPSig9KQxBig0Cg9RQIUcil7U0U4dKBidqBS9qQUAKvU/SigdaWgBKWk70UAAFFHagUAFNp3am0AH8Qo/ioz1NA7UCHd6UUlKKBi0w/1p9MPegA9KU0npS0ABooNFADe/NBHFB60nYimIQUtJS9xQAlJ3p1NPWgANKaQ0tACUlKaSgQh60Ud6O9MBDSGlpD1oAO1J2oNGcmgQo6UUDpRQMWkNLSHtQA2nDpSetA6UCFooooGIaKD0pKYgNFIetHagBaQ0tIaACgdDRRQAhph61IajPWmIRaf2pi0+gApwpuMUtIBaWkFLQMQ0dqO9HagBRS0UUAApD1paQ9aACilFJQAtLSUtIYhpaQ0tACiigdBRQAUlLRQAd6WkpaAEPWk9KU0dqAA96UdaTGcGlWgB1OFMp4pDA9Kb3px6U3vQAop1ItOFABQelAoPSkMaKX0oGTQeooEFOHSkUUo6UDDtQOtHagUAAp1NHX8KWgA70lKaKAE7UtJ2pRQAh6U31p3akoATtR3/GlwMkUgGMCgQ+gUntSigYtMPen0w9DQAd6Wk9KdQAhooNFADD1opT1owcGmIb2pe9J7UuORQAU09adTT1oADS0hpaAENIaWkoEJ3oo70UwDvTT1pxpp60AHekpTSEc5oEKOlLSDpRQMWkalpD2oAT1oHSjvSjpTEFFFFIYhpKU9KSmIO9JSnrR2oAKQ0tIaADtQKKPWgANRnrUhqM9aYhBT+1NFOoADTqbTqQwpaQUtACGig9aKAHdqKTNLQAUHrRQetABSd6WgUAL3opO9LSGIaXtSGl7UCF7CigdKKBgOaDRQaACloo7UAIaBQaKAAdDTl6U3HNOXpQAtOHSm06kMD0popT0pKAHr3pR1pq96UGkAooPSgUHpQMAaDRj0oPagAHAp3ako7UAB6UCg9KBQAq/eNGKB1NLQAlKRSd6WgBBRQKKAEpKX1pKAA/eFH8VHUUDqPegB3egUUCgBaYev406m96ACnGm96UnmgANFFFADeho7UuATSUAIKWkFApiCmnrTqaetAAaUikNKaAENGM0GigBp60Up60lMQGmmnGmmgA7UnalpMfpQAo6UtA6UUAFIaWkNACUo6UlAPFAhaKKKBiGig0mPSmIDRR3ooAKQ0tIaACgd6KB0oADUbdakNRnrTQmApwpop1ABTqbTqQwHWlpBRQAGiiigBaKKKAFpD1paKACiilxQAgpaMUUhiGjtR3ooEO7UUdhRQMUUhpaQ0AFLSd6WgBD0oo7UUALSr0pKVelAC9qdTaWkMD0pKO1FADhSj2pFpaAFFB6Ugpc0hiCl7iilHNACdTTu1JiloAQ9KKD0oFACr1NLTV604UAFBooNAhtLSdqWgYd6bTu9NNABR3FFHegB1KO9JQOhoAU9aYetOPWm0AFLikHWnUAJ3oo70E0ANPU0UtJQITtQKXFGKAEpDS03vTADS0hpaACkpaTtQAh60lKetJTEHakNKelIaAEooooEHalpB0o70DFNIaU000AFHakpw6UCCiko7UABpKWimAneilpMUAFIaWkNABQOlFA6UABqM1IajamIBThTRThQAU6m06kMKO9FFAAaSlNJQA6iiigAooooAWlHSm06kMKKKKAE70UGimAvpS0g6UtIBaT0paQ9qAAUtJ3pRQAHpSd6U0lAC0q0nalFAC0tJS0hgelJSk8U31oActOpq0poAWgUUCkAvUUq9TTaVe9Ax1FFFACGig9KSgBRSjpSLS0ALR3oooAbS0nalFAB3ptPNNPWgBKP4hQKB1/GgB1FFFAAKaadTDQADrTqb3p3agBKDRSGgAoPFHak70CHGkpTSUDEpvenU00xAaO9IadQAlBooNADT1ooPWjvTEFIadTTQAlBoo9KAAdKWgdKDQAhoaikNACUopKUdKYgooNFACUtIKKAFFFA6UUAJSGlpDQAUdqKBQAGozUlRmmIFpw6UwU8UAFOptOpDCiiigApKU0lADqKKKACgUUUALS9qSl7UgAUUUUDENFFFMQopaQUtIYUGig0AApRSClHSgAPWkpTSUALSr0pppy0AOpKKKQwNJ3pTSUAOWlNItLQAUd6KB1oAd1FKtIKB1NIYveijvRQAHpSCg0UAKOtLTRThQAUdqKO1ACClptOFAAelNpxplAC+lA60dqQfeFAElJ1oooASmnvTqaaAAdqdTe4p1ADaDQaKBAKMYo9KDQMU9KTtQaSgQdqaetO7U2mAhpaQ0tAAaSlpKAEPWig0UxBSHqad2pp60AJ3pPSlpDQA4dKDQOlFACUhpe9IaAE70o6UlKOlMQGkpaSgAoNApe1AAKSgUUAFIaWkNABQKSloADUZ61IajbrTQhFp4pi08UAGMU6kpaQwoopaAEPWkpTSUAOoooNABQKKBQAHpTu1Np3agAooopDEooopiFFLSClFIYuKQ0tI1AAKcOlNpRQAh60UNRQAuOhpVpKVaAFpRRRSGIelJSnpSUAOXvTqYtOoATvS96SloAXvSr1NI3FKvekAtFFFAxDSUppKAFFLSLTqADFGOKWjtQAynCm0ooAVulMp56UztQAvWkHBApRQOooAdSUvaigA70ynU00AJ3p9M7inUAI1JStSUxC9qQ9qXtTc5NADzTacaSkAhphp5plMANLSd6WgQUYoFHegY1utFDdaSmId2ph60+mHrQAUEd6KDQADpSmgdKKAEpD2paQ0AJSjpSUo6UxBSUppKACiig9aAAdKKB0paAEpKWkoASlpKUUAIaYakNMNMQ0U8UwU+gAp1JRSGOpKB1ooAKSg0UAOoNFBoASlFJS0AGOad2pKO1AC0GkpaQxKSlNFMQ4dKKQdKWkMWkNFDdaAEHWnZpopD1oAcaKQdKXtQAtKvSm0tADqU02lpDA9KSlPSkoEKtO7U1e9OoGJRSUtACnkUq0CgdaQDqO1N70tAxDRSnpTaBDl6mnU1etLQMXtR2opP4aAGnpTgcU3NDfdoEOJGOtNzTR1p1MAFA+8KKKQDs0tNoFAxaaadTDQAdxTqZ3FPoEI1JQaSmAopAMGlFBoAU0lBooAQ02n0w0AIafTKcaACjvRR3oAa3WkHehutFMQufemnrSHqaXtQAUGj0ooEKOlFJRQMDSGlpDQAlKOlJSjpTEBpKU0lABQRnFFFAAOlFAooAKQ0tIaAEpR0pKUUABphp5qNqYgWnUwU+gApaSlpDAUtIKWgBKKKKAHUUUUAJS0lLQAdqXtSUvagApaSlpDENJSmkpiHdqWkFFIYveg0d6Q0AApD1oFB60CFHSg0gpaBi0opKUUAFOptOFIANNpx6U2gByd6dTU70vagYGgUlKOtACilXqaaKVepoAWlpKWkMD0ptO7U2gQq9aWkFLQMXPFHakpT0oAZQ3SkpT92mIQdadTaWgApaSigBaUUlApAL2pp606mHvQAfxU+mfxCn0wGmkpTSUAFBo9KD2oAU0lKaSgBaYetOpp70AJTjTadQIKTvRRQA1utIKU0gpgNPWnUh60dqBB3ooopgLSUUd6QC96Q0tIaBiGlHSkpR0piCkpTSUAFFFFAAOlFA6UUAFBooNADaUUlKKAENManmmNTEItPpop1ABS0lLSGHelpKWgBDRQaT0oAfRRRQAlL2oo7UAFL2pD0pe1AAKWkpaQCGig0lMBw6UUlLSGLSGlFIaAExzQetLSHrQIBS0CigYo60opB1ooAWlHSm06gAPSkpT0pvc0APXvTqYnSnUhiUveiigAFKvU0nrQvU0AO70UlLSAXtTaXsaSmADrTqaKXNAC0HpSUp6UhjO1HRaKGHFMQg5NLmkHGKWgApaTtS0ALSDrRQKAFppp1MNAB3p9M/iFPoAQ0lLSUAHpSHtS+lIe1ADjSUGkoAWkPWlpp60AIaWkpc0xBRRRQA09aTHNKetJigBp60vSjvR2piCiigUALSGiikAtIaWkNACUo6U3tTh0pgFJS0lABRRSdqAFHSigdKKACkPSlpDQAUCkooADTDTzTDTEIKeKYtPHWgApaSlpAApaQdaWgYlJSmkoEPooooGFHaiigBD0p1Np3agAoo7UUgA0lKetJTAUdKWgUUhiikNLSNQAgoNFBpiAdKO1IKWgBaWkpaQwNO7U2loAU000ppKAHL3p1NXvS0hhR3oNHegA7mlXvTSeaVaAHUtJ3ooAXsabSnpTaAFHWnU0dad2oAKD0ooPSkMaKDSUUxCfxUvek70ue1AAKUdqQUooAO1KKSgUALTadTKAAdakqMdfxp5oAKSjNJQAHoKQ9aU9Kb3oAfSUpooASkPWlpp70CCikp1MBKWiigBp60nalPWkoAaaO1BoFMQGl70lLQAUd6KTvQA6kNFIaAEpw6U2nDpQAUlLSUAFJ2paQ0AKOlFA6UUAFIaWkNACUCigUABphp5phpiEWnU1acKAFooo9KAF70UUUhhSUtJQIdRRRQMWkoooAMYp1NpRQAtFFFACGig0UAL2paO1JSAdSNQKRqBhSGlpD1piFFBoFBoAUUUUUhhTqaOlOoAQ0UGigBV6GlpFpaAFopKDSACM0opKB1oGPzRSUUAB6UlKelJQAo60tItLQAUvamilJ4oAbQaQUp6UANHWndsU2nUCEFLSCloAKB3o70etAxabSmkoAB1p2aYOop9ACUUelFACUYxRQaYhc0ZopKQxaaaWkPWmISnU2nUAJ3ooooAa3WihutJQAhpRSd6BTEB60UGigAo9KD0ooAWkNLSUAJSjpSUo6UAFFFFABSEc0UUAKKKQUtACUGig0AJQOlFKKAEPSmGnmmGmIFpaaKdQAtFFLQAUUUUgCk70tIKYDqKKDSGFFJRQAtKKbTh0oAWikpaAEPWig9aKAF7UtJ2opAKKRu1LSGgBKD1paTuaYCig0Cg0AFL3pKWkMKXmkpaAEoNFFADl6UtIKKAFopM0lACilHWm0q9aAH0UnalpDA9KTtQelJ6UAKtLSDrS0AFKelNpaAGig9KBQelMQUtNpaQCCl7UlKKYBS0lFIAyaKKSmADrTqaOtOpAFJQaSgAoNJRTAdRRRSAKTvS009aYBS02nUAFJRRQAh60lKetJQAnelpKO1MQUUUUAFFFFAAaSlpKAA0o6Unel7UAFFFJQAUUUlACilpBRQAUGig0AJQKO9AoADTDTzUZpiAU6minUALS0lLQAUUUUhhSGlpOtMQ6iiikMSiiigA7U4U2nCgApaSloAQ0UGkoAd2oo7UUAFBooNIAFIaBR3pgLSGgUUALSim06kMKXtSUUAFFFFAAvenUgpaAE70Ud6KAClHWkpR1oAWlpKWkMD0ptOPSm0CFHWlpB1paBhQe9FFACAUGkFBPApiAUtNFLQAlOFNFKKAFNAoNJSAU0lFJTAM/MKdTepFOoAQ0UGkoAKKKSgB1FFFAC009aWkNACU6m0tABRRRQA09aXoKQ9aKAEpabS0xBRSelLQAdqKKKACkpaSgANA6UUDpQAtJS02gANFFFACiikFLQAUGig0AJQKKBQAGozUhqM0xAKdTVp1AC0UUUALSUtFIBKBRRTAdRRRSGGKSlpKAClHSilFABRRRQAHrRQaTvQA7tRR2ooAKRqWkagAo70Uh60AKOtFAoNABS0lLQAtFIKWkMSg0ppDQIcvSikWloGGKKKKACgdaKBQA6iiikAHpSUp6U2mA4daKRaWkAUppKD0oGNBoPSgUHpTEFLTc07tQAlL2pBRQAtFJ3paAEzRS0lAADzTqYOtOoAOtGKM0UAJSGloNAC0UUUAFJ3paaetABS02nUAFFJRQAh60lKetJTEFFJSg0AJS0lFAC0UdqKACkpaSgBO9O7U00o6UALSYoooAKSlpKAAUtIKWgAoNFBoASgUlKKAA1GakNRmmIBThTVpwoAWiiigA70tJ3paAEooooAdRRRSGFFFFABSim07tQAUUUUAIaKU9aSgBe1FHaloAKRu1LSGgApDS0hoAUUUgpaAClpKKAF7UtNp1IBDRQaSmA4dDS0i0tIYUGiigAoFIaVaAFooooAD0pKU9KSgBRS00dad2oABR2oo7UAMFKelFFACClpvenZoAQUtIKWgA70DkmigUAKabTqbQADqKdTBT6AEooooAKKD0pooAfSUtFACUh60tIe9ACU6m0vegA70tJRQAh60lKetJTEIetAoNAoAKWkooAKKKKAFpKWkNACUo6UlKOlABRRRQAUUUh60AKKKBRQAUhpaQ0AJSikpR0oAD0php56Uw0xCCnU0U4UALR3oooAB1paQUtIYlFBopiHUUUUhhR2pKO1ABS0h6U7tQAUUlLQAhooNFACiikpaAFpDS0hoASj1pRSd6AAUUCigBaKKKACnU006kAhpDSmkpgOXvS01elOpDA0d6SigA70L3o9aF70AOopKKAFPSm07tTaAFHWlzTaWgBaD0pKXtQA2g0UGgBP4qWk70tAAKBSUtAC0Ck7UooAKSlppoAB1/Gn0zvT6AEoopKADtSd6X0pD1oAdR2oNJQAtNNOpp60AFLSUUCFopKWgY09aKD1o7UxCHpQKKO1ABRRRQAUd6KKAFpDS0hoASlHSkpR0oAWkoooAKSlpO1AAOlLSDpRQAtIaWkNACUCiigQGmmnGmGmACnUwGnZoAd2opuaXNAC96Wm55pc0ABpKCaM0APopM0hNIYtHakzRnigQp6Uvam5pc8UDFpabmlzQAGikJpM0APFFNzS5oAWg0maQmgBaQ9aTPNBNADqKaDS5oAd3opuaXNAC0opuaXNACnpSUE0maAHL0p1MBpc0ALRTc0ZoAdQOppuaUHk0gHUU3NLmgYvako3U3dQA4UtNBozQA6g9KTNGeKAEoPSm5pc8UxCg0U3PNLntQAvalpuaM0AOoHWkzSA0hj6aaM0hNAhe9OpmeaduoAU0lNJozQMdSGkz0oJpiHmkpM0ZpDFpD1ozSE0CA06mZpc0wFpabmjNAAetJSE80A0AHelppNANADqBTc0ZoAdRSZozQA6kNJmgmgBO1OHSm5pQeKBC0lGaTNAxaKTNGaAFHSikB4ozQA6kPSjNITQAUCkzQDTEKaYacTTSaAGCloopiFooooAKXNFFIBKKKKYC5ooopDDNGaKKADNLmiigAzRmiigAJpKKKAFzRmiigBc0hNFFACUE0UUAFGaKKAFzRmiigAzS5oooACaTNFFACgmlzRRQAmaM0UUAGaATzRRQAuaMmiikAZpM0UUAANLk0UUAGTS5NFFAxuaCeKKKYhM0uaKKADJozRRQAuaAaKKADJpM0UUAGeaXJoooAM0maKKADJoJoooAUk0mTRRSAXNITRRTATNLmiigAzRmiigBCaM0UUAJmiiigAzRmiigBc0meaKKAFzSE0UUAGaUHiiigAzSUUUAGaKKKAAGiiigAzRmiigBKWiigQlIaKKYH//Z]]
-- =======================================================]] -- Style
DialogWindow.Style = [[<style type="text/css">html {overflow:hidden}
.DirectoryPicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}
.FormButton {font-weight:bold;width:75px;font-family:Arial, Helvetica, sans-serif;font-size:12px;white-space:nowrap;background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.LuaButton {font-weight:bold; width:125px; font-family:Arial, Helvetica, sans-serif;font-size:12px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.ToolNameLabel {font-family:Arial, Helvetica, sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}
.ToolPicker {font-weight:bold;text-align:center;font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;width:50px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.alert-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:  ]].. DialogWindow.StyleTextColor .. [[;text-align:center;white-space:nowrap}
.alert-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;text-shadow: 5px 5px 10px #FFF;color:#FF0101 ;text-align:left;white-space:nowrap}
.alert-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}
.error {font-family:Arial, Helvetica, sans-serif;font-size:18px;font-weight:bold;color:#FF0000 ;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px;}
.errorMessage {font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left; white-space:nowrap;padding-right:4px; padding-left:10px; padding-top:4px;padding-bottom:4px;}
.errorTable {background-color:#FFFFFF white-space:nowrap;}
.p1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left}
.p1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center}
.p1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right}
.ver-c {font-family:Arial, Helvetica, sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap color: #ffd9b3 ;}
.h1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap}
.h1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap}
.h1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap}
.h1-rP {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;}
.h1-rPx {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px}
.h2-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:  ]].. DialogWindow.StyleButtonColor .. [[ ;text-align:left;white-space:nowrap;text-shadow: 2px 2px white;}
.h2-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:  ]].. DialogWindow.StyleButtonColor .. [[ ;text-align:center;white-space:nowrap;text-shadow: 2px 2px white;}
.h2-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:  ]].. DialogWindow.StyleButtonColor .. [[ ;text-align:right;white-space:nowrap;text-shadow: 2px 2px white;}
.h3-bc {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}
.h3 {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}
.webLink-c {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;background-color: yellow;text-align:center;white-space:nowrap}
.jsbutton {background-color: ]].. DialogWindow.StyleButtonColor ..[[ ;border:2px solid #999;border-right-color:#000;border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF; 12px;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none; font-size:12px; margin:1px 1px; color:]].. DialogWindow.StyleButtonTextColor .. [[ }
.jsTag-no-vis {font-family:Arial, Helvetica, sans-serif;font-size:10px;display:none; text-align:center; color:#00F; visibility: hidden;}
body {background-color: ]].. DialogWindow.StyleBackGroundColor  ..[[; background-position: center; overflow:hidden;font-family:Arial, Helvetica, sans-serif;font-size:12px; color: ]].. DialogWindow.StyleTextColor .. [[;
background-image: url(]].. DialogWindow.myBackGround ..[[); }html {overflow:hidden;}</style>]]

-- =========================================================]] -- About
  DialogWindow.myHtml5 = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="header1-c" id="SysName">Easy Cabinet Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" id="Version" class="ver-c">Version</td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td> </tr> <tr> <td align="center" class="p1-l"><p class="p1-l">The ]] .. DialogWindow.ProgramName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br> <br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br> <br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td> </tr> <tr> <td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td> </tr> <tr> <td align="center" ><span class="header2-c">James Anderson</span></td> </tr> <tr> <td align="center"><span class="h1-c">Houston, TX.</span></td> </tr> <tr> <td><hr></td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr></table></body>]]
-- =========================================================]] -- Milling
  DialogWindow.myHtml4 = [[<html><head><title>Milling Information</title> ]] .. DialogWindow.Style ..[[ </head><body bgcolor = "#EBEBEB" text = "#000000"><table width="443" border="0"> <tr> <td width="159" nowrap class="h1-rP">Default Finger Bit Diameter</td> <td width="50"><input name="Milling.FingerToolDia" type="text" class="h1-l" id="Milling.FingerToolDia" size="10" maxlength="10" /></td> <td width="166" nowrap class="h1-rP">Default Profile Bit Diameter</td> <td width="50"><input name="Milling.ProfileToolDia" type="text" class="h1-l" id="Milling.ProfileToolDia" size="10" maxlength="10" /></td> </tr> <tr> <td class="h1-rP">Pocket Clearance</td> <td><input name="Milling.PocketClearance" type="text" class="h1-l" id="Milling.PocketClearance" size="10" maxlength="10" /></td> <td class="h1-rP">Dado Height</td> <td><input name="Milling.DadoHeight" type="text" class="h1-l" id="Milling.DadoHeight" size="10" maxlength="10" /></td> </tr> <tr> <td class="h1-rP">Finger Clearance</td> <td><input name="Milling.FingerClearance" type="text" class="h1-l" id="Milling.FingerClearance" size="10" maxlength="10" /></td> <td class="h1-rP">Part Gap</td> <td><input name="Milling.PartGap" type="text" class="h1-l" id="Milling.PartGap" size="10" maxlength="10" /></td> </tr></table><table width="100%" border="0" id="ButtonTable"> <tr> <td height="4" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td> <td width="308" class="alert" id="GadgetName.Alert">.</td> <td width="94" class="h1-c" style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> </tr></table></body></html>]]
-- =========================================================]] -- Project
  DialogWindow.myHtml3 = [[<html><head><meta content="text/html ; charset = iso-8859-1" http-equiv="Content-Type"><title>Layer Setup</title> ]] .. DialogWindow.Style ..[[ </head><body bgcolor="#EBEBEB" text="#000000"><table width="550" border="0" cellpadding="0"> <tr> <td width="224" class="h1-rP">Project Name</td> <td width="312"><input name="Project.ProjectName" type="text" class="h2" id="Project.ProjectName" size="50" maxlength="50" /></td> </tr> <tr> <td class="h1-rP"> Contact Name</td> <td><input name="Project.ProjectContactName" type="text" class="h2" id="Project.ProjectContactName" size="50" maxlength="50" /></td> </tr> <tr> <td class="h1-rP">Contact Email</td> <td><input colspan="4" name="Project.ProjectContactEmail" type="text" class="h2" id="Project.ProjectContactEmail" size="50" maxlength="50" /></td> </tr> <tr> <td class="h1-rP">Phone Number</td> <td><input name="Project.ProjectContactPhoneNumber" type="text" class="h2" id="Project.ProjectContactPhoneNumber" size="50" maxlength="50" /></td> </tr> <tr> <td class="h1-rP">Drawer ID</td> <td ><input name="Project.DrawerID" type="text" class="h1-l" id="Project.DrawerID" size="10" maxlength="12" readonly /></td> </tr></table><table width="550" border="0"> <tr> <td colspan="3"><hr></td> </tr> <tr> <td width="84" class="h1-rP">Project Path </td> <td width="367" > <input name="Project.ProjectPath" type="text" class="h2" id="Project.ProjectPath" size="60" valign="middle" maxlength="250" /></td> <td width="85"> <input id="DirectoryPicker" class="DirectoryPicker" name="DirectoryPicker" type="button" value="Path..."> </td> </tr></table><table width="100%" border="0" id="ButtonTable"> <tr> <td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td> <td width="308" class="alert" id="GadgetName.Alert">.</td> <td width="94" class="h1-c" style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> </tr></table></body></html>]]
-- =========================================================]] -- Layers
  DialogWindow.myHtml2 = [[<html><head><title>Layer Names</title> ]] .. DialogWindow.Style ..[[ </head><body bgcolor="#EBEBEB" text="#000000"> <table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Bottom Panel Profile</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNBottomProfile" type="text" class="h1-l" id="Milling.LNBottomProfile" size="30" maxlength="50"/> </td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNBottomProfileColor" id="Milling.LNBottomProfileColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table><table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Side Panel Pocket (Dado)</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNSidePocket" type="text" class="h1-l" id="Milling.LNSidePocket" size="30" maxlength="50"/> </td>   <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNSidePocketColor" id="Milling.LNSidePocketColor"> <option selected="selected">Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table><table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Side Panel Profile</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNSideProfile" type="text" class="h1-l" id="Milling.LNSideProfile" size="30" maxlength="50"/> </td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNSideProfileColor" id="Milling.LNSideProfileColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table> <table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Front Panel Pocket (Dado)</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNFrontPocket" type="text" class="h1-l" id="Milling.LNFrontPocket" size="30" maxlength="50"/> </td>   <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNFrontPocketColor" id="Milling.LNFrontPocketColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table> <table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Front Panel Profile</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNFrontProfile" type="text" class="h1-l" id="Milling.LNFrontProfile" size="30" maxlength="50"/> </td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNFrontProfileColor" id="Milling.LNFrontProfileColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table><table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Back Panel Pocket (Dado)</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNBackPocket" type="text" class="h1-l" id="Milling.LNBackPocket" size="30" maxlength="50"/> </td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNBackPocketColor" id="Milling.LNBackPocketColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table> <table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Back Panel Profile</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNBackProfile" type="text" class="h1-l" id="Milling.LNBackProfile" size="30" maxlength="50"/> </td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNBackProfileColor" id="Milling.LNBackProfileColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table> <table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Drawer Notes</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable2"><input name="Milling.LNDrawNotes" type="text" class="h1-l" id="Milling.LNDrawNotes" size="30" maxlength="50"/></td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable2"><label for="Milling.LNBottomProfileColor2">Color</label> <select name="Milling.LNDrawNotesColor" id="Milling.LNDrawNotesColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option> <option>Magenta</option> <option>Green</option> </select></td>  </tr></table> <table width="600"> <tr> <td width="275" align="right" valign="middle" nowrap class="h1-rp">Part Labels</td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Milling.LNPartLabels" type="text" class="h1-l" id="Milling.LNPartLabels" size="30" maxlength="50"/> </td> <td width="126"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Milling.LNBottomProfileColor">Color</label> <select name="Milling.LNPartLabelsColor" id="Milling.LNPartLabelsColor"> <option>Black</option> <option>Red</option> <option>Blue</option> <option>Yellow</option> <option>Cyan</option>  <option>Magenta</option> <option>Green</option>  </select></td> </tr></table> <table width="100%" border="0" id="ButtonTable"> <tr> <td height="4" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td> <td width="388" class="alert" id="GadgetName.Alert">.</td> <td width="96" class="h1-c" style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td width="96" class="h1-c" style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> </tr></table></body></html>]]
-- =========================================================]] -- Drawer
 DialogWindow.myHtml1 = [[<html><head><title>Drawer Maker</title>]] .. DialogWindow.Style ..[[</head><body bgcolor="#EBEBEB" text="#000000"><table width="550" border="0"> <tr> <td class="h1-c"><input id="InquiryAbout" class="LuaButton" name="InquiryAbout" type="button" value="About"></td> <td class="h1-c"><input id="InquiryProjectInfo" class="LuaButton" name="InquiryProjectInfo" type="button" value="Project Setup"></td> <td class="h1-c"><input id="InquiryLayers" class="LuaButton" name="InquiryLayers" type="button" value="Layer Names"></td> <td class="h1-c"><input id="InquiryMilling" class="LuaButton" name="InquiryMilling" type="button" value="Milling Defaults"></td> </tr> <tr> <td colspan="4"><hr></td> </tr></table><table width="550" border="0" cellpadding="0"> <tr class="h1-c"> <td colspan="2" nowrap class="h1-c">Drawer Opening</td> <td colspan="2" nowrap><span class="h3-br" style="width: 25%">Materal Thickness</span></td> <td colspan="2"><span class="h3-br" style="width: 25%">Milling Spacing</span></td> </tr> <tr> <td nowrap class="h1-rp">Height</td> <td width="16%"><input name="Drawer.OpeningHeight" type="text" class="h1-l" id="Drawer.OpeningHeight" size="10" maxlength="10" /></td> <td nowrap class="h1-rp">Side</td> <td width="17%"><input name="Drawer.SideThickness" type="text" class="h1-l" id="Drawer.SideThickness" size="10" maxlength="10" /></td> <td nowrap class="h1-rp">Sides</td> <td width="16%"><input name="Drawer.SideGap" type="text" class="h1-l" id="Drawer.SideGap" size="10" maxlength="10" /></td> </tr> <tr> <td nowrap class="h1-rp">Width</td> <td width="16%"><input name="Drawer.OpeningLength" type="text" class="h1-l" id="Drawer.OpeningLength" size="10" maxlength="10" /></td> <td nowrap class="h1-rp">Back</td> <td width="17%" nowrap class="h2"><input name="Drawer.BackThickness" type="text" class="h1-l" id="Drawer.BackThickness" size="10" maxlength="10" /></td> <td nowrap class="h1-rp">Tops</td> <td width="16%"><input name="Drawer.TopGap" type="text" class="h1-l" id="Drawer.TopGap" size="10" maxlength="10" /></td> </tr> <tr> <td class="h1-rp">Depth</td> <td><span class="h2"> <input name="Drawer.OpeningDepth" type="text" class="h1-l" id="Drawer.OpeningDepth" size="10" maxlength="10" /> </span></td> <td nowrap class="h1-rp">Front</td> <td width="17%"><input name="Drawer.FrontThickness" type="text" class="h1-l" id="Drawer.FrontThickness" size="10" maxlength="10" /></td> <td nowrap class="h1-rp">Bottoms</td> <td align="left"><span class="h2"> <input name="Drawer.BottomGap" type="text" class="h1-l" id="Drawer.BottomGap" size="10" maxlength="10" /> </span></td> </tr> <tr> <td width="18%" align="right" nowrap><span class="h1-rp">Count</span></td> <td width="16%" align="left"><input name="Drawer.Count" type="text" class="h1-l" id="Drawer.Count" size="10" maxlength="10" /></td> <td nowrap class="h1-rp">Bottom</td> <td width="17%"><input name="Drawer.BottomThickness" type="text" class="h1-l" id="Drawer.BottomThickness" size="10" maxlength="10" /></td> <td width="16%" nowrap class="h1-rp">Finger Count</td> <td width="16%" align="left"><span class="h2"> <input name="Drawer.SideFingerCount" type="text" class="h1-l" id="Drawer.SideFingerCount" size="10" maxlength="10" /> </span></td> </tr></table><table width="550" border="0"> <tr> <td colspan="3" align="right" nowrap class="h1-r"><hr></td> </tr> <tr> <td width="149" nowrap class="h1-rp">Profile Bit:</td> <td width="315" nowrap="nowrap" bgcolor="#33FFFF" class="ToolNameLabel"><span id = "ToolNameLabel1">-</span></td> <td width="72" nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton1" class = "ToolPicker" name = "ToolChooseButton1" type = "button" value = "Tool"> </strong></td> </tr> <tr> <td align="right" nowrap class="h1-rp" >Dado Pocket Bit:</td> <td width="315" nowrap="nowrap" bgcolor="#FFFF33" class="ToolNameLabel"><span id = "ToolNameLabel2">-</span></td> <td nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton2" class = "ToolPicker" name = "ToolChooseButton2" type = "button" value = "Tool"> </strong></td> </tr> <tr> <td align="right" nowrap class="h1-rp" >Dado Clearing Bit:</td> <td width="315" nowrap="nowrap" bgcolor="#FFFF33" class="ToolNameLabel"><span id = "ToolNameLabel3">-</span></td> <td nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton3" class = "ToolPicker" name = "ToolChooseButton3" type = "button" value = "Tool"> </strong></td> </tr> <tr> <td align="right" nowrap class="h1-rp" >Finger Bit</td> <td width="315" nowrap="nowrap" bgcolor="#00FFCC" class="ToolNameLabel"><span id = "ToolNameLabel4">-</span></td> <td nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton4" class = "ToolPicker" name = "ToolChooseButton4" type = "button" value = "Tool"> </strong></td> </tr> <tr> <td align="right" nowrap class="h1-rp" >Finger Clearing Bit</td> <td width="315" nowrap="nowrap" bgcolor="#00FFCC" class="ToolNameLabel"><span id = "ToolNameLabel5">-</span></td> <td nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton5" class = "ToolPicker" name = "ToolChooseButton5" type = "button" value = "Tool"> </strong></td> </tr></table><table width="550" border="0"><tr> <td width="29%" class="h1-rP">Cabinet Name</td> <td width="60%"><input name="Project.DrawerName" type="text" class="h1-l" id="Project.DrawerName" size="30" maxlength="60" /></td> <td width="11%">&nbsp;</td></tr><table width="100%" border="0" id="ButtonTable"> <tr> <td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td> <td width="308" class="alert" id="GadgetName.Alert">.</td> <td width="94" class="h1-c" style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> </tr></table></body></html>]]
return true
end
-- =====================================================]]