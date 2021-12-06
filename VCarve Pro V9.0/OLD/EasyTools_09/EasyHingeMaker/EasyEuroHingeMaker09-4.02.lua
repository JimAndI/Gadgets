-- VECTRIC LUA SCRIPT
--[[
--| Gadgets are an entirely optional add-in to Vectric's core software products.
--| They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
--| In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
--|
--| Permission is granted to anyone to use this software for any purpose,
--| including commercial applications, and to alter it and redistribute it freely,
--| subject to the following restrictions:
--|
--| 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--|    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
--| 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--| 3. This notice may not be removed or altered from any source distribution.
--|
--| Easy Euro Hinge Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ===================================================]]
--[[
Do List:
3. Make clearing path optional
4. Add Units (mm's and inchs) to All Easy Gadgets
5. Ask User if center drill or pocket for Hinge Screws
6. Error Trap:
  a. door length and number of hinges hinge
  b. corner to hinge (48mm)

-- ===================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
local Hinge = {}
local DialogWindow = {}
Hinge.VerNumber = "09-4.02"
DialogWindow.AppName = "Easy Euro Door and Hinge Maker"
Hinge.RegName = "EasyEuroHingeMaker" .. Hinge.VerNumber
Hinge.DialogLoop = true
Hinge.Tool_ID1 = ""
Hinge.Tool_ID2 = ""
Hinge.Tool_ID3 = ""
Hinge.Tool_ID4 = ""

DialogWindow.SDK         = "https://jimandi.com/SDKWiki/index.php?title=Easy_Door_and_Hinge_Maker"
DialogWindow.SDKLayer    = "https://jimandi.com/SDKWiki/index.php?title=Easy_Door_and_Hinge_Maker-Layers"
DialogWindow.SDKMilling  = "https://jimandi.com/SDKWiki/index.php?title=Easy_Door_and_Hinge_Maker-Milling"
DialogWindow.SDKHardware = "https://jimandi.com/SDKWiki/index.php?title=Easy_Door_and_Hinge_Maker-Hardware"

-- ===================================================]]
function REG_ReadRegistry() -- Read from Registry values
  local RegistryRead     = Registry(Hinge.RegName)
  --[[if not(RegistryRead:StringExists("Hinge.ScrewHoleSetBack")) then
    REG_LoadRegistry()
  end]]
  Hinge.CornerDistance         = RegistryRead:GetDouble("Hinge.CornerDistance",         3.5)
  Hinge.Count                  = RegistryRead:GetInt("Hinge.Count",                     2)
  Hinge.DoorSets               = RegistryRead:GetInt("Hinge.DoorSets",                  1)
  Hinge.DoorsPer               = RegistryRead:GetInt("Hinge.DoorsPer",                  2)
  Hinge.EdgeMinDistance        = RegistryRead:GetDouble("Hinge.EdgeMinDistance",        0.433071)
  Hinge.FrameHeight            = RegistryRead:GetDouble("Hinge.FrameHeight",            0.0)
  Hinge.FrameWidth             = RegistryRead:GetDouble("Hinge.FrameWidth",             0.0)
  Hinge.HingeCupDepth          = RegistryRead:GetDouble("Hinge.HingeCupDepth",          0.511811)
  Hinge.HingeCupDiameter       = RegistryRead:GetDouble("Hinge.HingeCupDiameter",       1.377953)
  Hinge.HingeCupSetBack        = RegistryRead:GetDouble("Hinge.HingeCupSetBack",        0.250)
  Hinge.LNameDoorProfile       = RegistryRead:GetString("Hinge.LNameDoorProfile",       "Door Profile")
  Hinge.LNameHingePocket       = RegistryRead:GetString("Hinge.LNameHingePocket",       "Hinge Hole")
  Hinge.LNameScrewHole         = RegistryRead:GetString("Hinge.LNameScrewHole",         "Screw Hole")
  Hinge.OverlapBottom          = RegistryRead:GetDouble("Hinge.OverlapBottom",          0.0)
  Hinge.OverlapSide            = RegistryRead:GetDouble("Hinge.OverlapSide",            0.0)
  Hinge.OverlapTop             = RegistryRead:GetDouble("Hinge.OverlapTop",             0.0)
  Hinge.ScrewCenter            = RegistryRead:GetDouble("Hinge.ScrewCenter",            1.771654)
  Hinge.PartGap                = RegistryRead:GetDouble("Hinge.PartGap",                1.500)
  Hinge.ScrewHoleDepth         = RegistryRead:GetDouble("Hinge.ScrewHoleDepth",         0.511811)
  Hinge.ScrewHoleDiameter      = RegistryRead:GetDouble("Hinge.ScrewHoleDiameter",      0.314961)
  Hinge.ScrewHoleSetBack       = RegistryRead:GetDouble("Hinge.ScrewHoleSetBack",       0.374016)
  Hinge.Side                   = RegistryRead:GetDouble("Hinge.Side",                   0.0)
  Hinge.Placement              = RegistryRead:GetString("Hinge.Placement",              "Left")
  Hinge.DrillOrMillScrews      = RegistryRead:GetString("Hinge.DrillOrMillScrews",      "Pocketing")
  Hinge.ProfileBitDiameter     = RegistryRead:GetDouble("Hinge.ProfileBitDiameter",     0.2500)
  Hinge.CupPocketBitDiameter   = RegistryRead:GetDouble("Hinge.CupPocketBitDiameter",   0.2500)
  Hinge.CupClearingBitDiameter = RegistryRead:GetDouble("Hinge.CupClearingBitDiameter", 0.2500)
  Hinge.ScrewPocketingDiameter = RegistryRead:GetDouble("Hinge.ScrewPocketingDiameter", 0.1250)
  Hinge.DoorKerf               = RegistryRead:GetDouble("Hinge.DoorKerf",               0.1250)
  Hinge.ScrewDrillingDiameter  = RegistryRead:GetDouble("Hinge.ScrewDrillingDiameter",  0.0625)
  Hinge.ProfileBitDiameter     = RegistryRead:GetDouble("Hinge.ProfileBitDiameter",     0.2500)
  Hinge.InquiryAboutXY         = RegistryRead:GetString("Hinge.InquiryAboutXY",         "x")
  Hinge.InquiryHardwareXY      = RegistryRead:GetString("Hinge.InquiryHardwareXY",      "x")
  Hinge.InquiryHingeXY         = RegistryRead:GetString("Hinge.InquiryHingeXY",         "x")
  Hinge.InquiryLayersXY        = RegistryRead:GetString("Hinge.InquiryLayersXY",        "x")
  Hinge.InquiryMillingXY       = RegistryRead:GetString("Hinge.InquiryMillingXY",       "x")
  return true
end --function end
-- ===================================================]]
function GetDistance(objA, objB)
   local xDist = objB.x - objA.x
   local yDist = objB.y - objA.y
   return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end
-- ===================================================]]
function REG_WriteRegistry()                            -- Write to Registry values
  local RegistryWrite = Registry(Hinge.RegName)
  local RegValue = RegistryWrite:SetDouble("Hinge.CornerDistance",         Hinge.CornerDistance)
        RegValue = RegistryWrite:SetDouble("Hinge.Count",                  Hinge.Count)
        RegValue = RegistryWrite:SetDouble("Hinge.EdgeMinDistance",        Hinge.EdgeMinDistance)
        RegValue = RegistryWrite:SetDouble("Hinge.HingeCupSetBack",        Hinge.HingeCupSetBack)
        RegValue = RegistryWrite:SetDouble("Hinge.HingeCupDepth",          Hinge.HingeCupDepth)
        RegValue = RegistryWrite:SetDouble("Hinge.HingeCupDiameter",       Hinge.HingeCupDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewCenter",            Hinge.ScrewCenter)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleDiameter",      Hinge.ScrewHoleDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleDepth",         Hinge.ScrewHoleDepth)
        RegValue = RegistryWrite:SetDouble("Hinge.DoorKerf",               Hinge.DoorKerf)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleSetBack",       Hinge.ScrewHoleSetBack)
        RegValue = RegistryWrite:SetDouble("Hinge.Side",                   Hinge.Side)
        RegValue = RegistryWrite:SetInt("Hinge.Count",                     Hinge.Count)
        RegValue = RegistryWrite:SetString("Hinge.InquiryAboutXY",         Hinge.InquiryAboutXY)
        RegValue = RegistryWrite:SetString("Hinge.InquiryHardwareXY",      Hinge.InquiryHardwareXY)
        RegValue = RegistryWrite:SetString("Hinge.InquiryHingeXY",         Hinge.InquiryHingeXY)
        RegValue = RegistryWrite:SetString("Hinge.InquiryLayersXY",        Hinge.InquiryLayersXY)
        RegValue = RegistryWrite:SetString("Hinge.InquiryMillingXY",       Hinge.InquiryMillingXY)
        RegValue = RegistryWrite:SetString("Hinge.LNameDoorProfile",       Hinge.LNameDoorProfile)
        RegValue = RegistryWrite:SetString("Hinge.LNameHingePocket",       Hinge.LNameHingePocket)
        RegValue = RegistryWrite:SetString("Hinge.LNameScrewHole",         Hinge.LNameScrewHole)
        RegValue = RegistryWrite:SetString("Hinge.Placement",              Hinge.Placement)
        RegValue = RegistryWrite:SetDouble("Hinge.FrameWidth",             Hinge.FrameWidth)
        RegValue = RegistryWrite:SetDouble("Hinge.PartGap",                Hinge.PartGap)
        RegValue = RegistryWrite:SetDouble("Hinge.FrameHeight",            Hinge.FrameHeight)
        RegValue = RegistryWrite:SetDouble("Hinge.OverlapSide",            Hinge.OverlapSide)
        RegValue = RegistryWrite:SetDouble("Hinge.OverlapTop",             Hinge.OverlapTop)
        RegValue = RegistryWrite:SetDouble("Hinge.OverlapBottom",          Hinge.OverlapBottom)
        RegValue = RegistryWrite:SetInt("Hinge.DoorsPer",                  Hinge.DoorsPer)
        RegValue = RegistryWrite:SetInt("Hinge.DoorSets",                  Hinge.DoorSets)
        RegValue = RegistryWrite:SetString("Hinge.DrillOrMillScrews",      Hinge.DrillOrMillScrews)
        RegValue = RegistryWrite:SetDouble("Hinge.ProfileBitDiameter",     Hinge.ProfileBitDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.CupPocketBitDiameter",   Hinge.CupPocketBitDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.CupClearingBitDiameter", Hinge.CupClearingBitDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewPocketingDiameter", Hinge.ScrewPocketingDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewDrillingDiameter",  Hinge.ScrewDrillingDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.ProfileBitDiameter",     Hinge.ProfileBitDiameter)
  return true
end -- function end
-- ===================================================]]
function REG_LoadRegistry()                             -- Load Registry with defalut values
  local RegistryWrite = Registry(Hinge.RegName)
  local RegValue = RegistryWrite:SetDouble("Hinge.CornerDistance",    2.750)
        RegValue = RegistryWrite:SetDouble("Hinge.Count",             2)
        RegValue = RegistryWrite:SetDouble("Hinge.EdgeMinDistance",   2.559055)
        RegValue = RegistryWrite:SetDouble("Hinge.HingeCupSetBack",   0.250)
        RegValue = RegistryWrite:SetDouble("Hinge.HingeCupDepth",     0.511811)
        RegValue = RegistryWrite:SetDouble("Hinge.HingeCupDiameter",  1.377953)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewCenter",       1.771654)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleDiameter", 0.314961)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleDepth",    0.511811)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleSetBack",  0.374016)
        RegValue = RegistryWrite:SetDouble("Hinge.Side",            180.000)  -- Angle in degrees
        RegValue = RegistryWrite:SetInt("Hinge.Count",                2)
        RegValue = RegistryWrite:SetString("Hinge.LNameDoorProfile", "Door Profile")
        RegValue = RegistryWrite:SetString("Hinge.LNameHingePocket", "Hinge Pocket")
        RegValue = RegistryWrite:SetString("Hinge.LNameScrewHole",   "Screw Pocket")
        RegValue = RegistryWrite:SetString("Hinge.Placement",             "Left")
        RegValue = RegistryWrite:SetDouble("Hinge.FrameWidth",       16.500)
        RegValue = RegistryWrite:SetDouble("Hinge.FrameHeight",      22.000)
        RegValue = RegistryWrite:SetDouble("Hinge.OverlapSide",       0.500)
        RegValue = RegistryWrite:SetDouble("Hinge.OverlapTop",        0.500)
        RegValue = RegistryWrite:SetDouble("Hinge.OverlapBottom",     0.500)
        RegValue = RegistryWrite:SetDouble("Hinge.PartGap",           1.500)
        RegValue = RegistryWrite:SetString("Hinge.InquiryAboutXY",    "x")
        RegValue = RegistryWrite:SetString("Hinge.InquiryHardwareXY", "x")
        RegValue = RegistryWrite:SetString("Hinge.InquiryHingeXY",    "x")
        RegValue = RegistryWrite:SetString("Hinge.InquiryLayersXY",   "x")
        RegValue = RegistryWrite:SetString("Hinge.InquiryMillingXY",  "x")
        RegValue = RegistryWrite:SetInt("Hinge.DoorsPer",             1)
        RegValue = RegistryWrite:SetInt("Hinge.DoorSets",             1)
        RegValue = RegistryWrite:SetString("Hinge.DrillOrMillScrews",      "Pocketing")
        RegValue = RegistryWrite:SetDouble("Hinge.ProfileBitDiameter",      0.2500)
        RegValue = RegistryWrite:SetDouble("Hinge.CupPocketBitDiameter",    0.2500)
        RegValue = RegistryWrite:SetDouble("Hinge.CupClearingBitDiameter",  0.5000)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewPocketingDiameter",  0.1250)
        RegValue = RegistryWrite:SetDouble("Hinge.DoorKerf",                0.1250)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewDrillingDiameter",   0.0625)
        RegValue = RegistryWrite:SetDouble("Hinge.ProfileBitDiameter",      0.2500)
  return true
end -- function end
--====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ===================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml5, 720, 478, "About")
  dialog:AddLabelField("SysName", DialogWindow.AppName)
  dialog:AddLabelField("Version", "Version: " .. Hinge.VerNumber)
  dialog:ShowDialog()
  Hinge.InquiryAboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  return  true
end
-- ===================================================]]
function OnLuaButton_InquiryLayers()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml4, 497, 188, "Layer Setup")
  dialog:AddTextField("Hinge.LNameHingePocket", Hinge.LNameHingePocket)
  dialog:AddTextField("Hinge.LNameDoorProfile", Hinge.LNameDoorProfile)
  dialog:AddTextField("Hinge.LNameScrewHole",   Hinge.LNameScrewHole)
  if  dialog:ShowDialog() then
    Hinge.LNameHingePocket = dialog:GetTextField("Hinge.LNameHingePocket")
    Hinge.LNameDoorProfile = dialog:GetTextField("Hinge.LNameDoorProfile")
    Hinge.LNameScrewHole   = dialog:GetTextField("Hinge.LNameScrewHole")
    Hinge.InquiryLayersXY  = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    REG_WriteRegistry()
  end
  return  true
end
-- ===================================================]]
function OnLuaButton_InquiryMilling()
  local dialog = HTML_Dialog(true, DialogWindow.myHtmlMilling, 655, 220, "Milling Setting ")
  dialog:AddDoubleField("Hinge.ProfileBitDiameter",     Hinge.ProfileBitDiameter)
  dialog:AddDoubleField("Hinge.CupPocketBitDiameter",   Hinge.CupPocketBitDiameter)
  dialog:AddDropDownList("Hinge.DrillOrMillScrews",     Hinge.DrillOrMillScrews)
  dialog:AddDoubleField("Hinge.CupClearingBitDiameter", Hinge.CupClearingBitDiameter)
  dialog:AddDoubleField("Hinge.ScrewPocketingDiameter", Hinge.ScrewPocketingDiameter)
  dialog:AddDoubleField("Hinge.ScrewDrillingDiameter",  Hinge.ScrewDrillingDiameter)
  dialog:AddDoubleField("Hinge.DoorKerf",               Hinge.DoorKerf)
  dialog:AddDoubleField("Hinge.PartGap",                Hinge.PartGap)
  if dialog:ShowDialog() then
    Hinge.ProfileBitDiameter     = dialog:GetDoubleField("Hinge.ProfileBitDiameter")
    Hinge.DrillOrMillScrews      = dialog:GetDropDownListValue("Hinge.DrillOrMillScrews")
    Hinge.CupPocketBitDiameter   = dialog:GetDoubleField("Hinge.CupPocketBitDiameter")
    Hinge.CupClearingBitDiameter = dialog:GetDoubleField("Hinge.CupClearingBitDiameter")
    Hinge.ScrewPocketingDiameter = dialog:GetDoubleField("Hinge.ScrewPocketingDiameter")
    Hinge.ScrewDrillingDiameter  = dialog:GetDoubleField("Hinge.ScrewDrillingDiameter")
    Hinge.DoorKerf               = dialog:GetDoubleField("Hinge.DoorKerf")
    Hinge.PartGap                = dialog:GetDoubleField("Hinge.PartGap")
    Hinge.InquiryMillingXY       = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    if Hinge.DrillOrMillScrews == "Drilling" then
      Hinge.dialog:UpdateTextField("DrillState",  "Drilling")
    else
      Hinge.dialog:UpdateTextField("DrillState",  "Pocketing")
    end
    REG_WriteRegistry()
  end
  return  true
end
-- ===================================================]]
function OnLuaButton_InquiryHardware( )
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, 463, 315,  "Hardware Settings") ;
        dialog:AddDoubleField("Hinge.EdgeMinDistance",   Hinge.EdgeMinDistance)
        dialog:AddDoubleField("Hinge.HingeCupSetBack",   Hinge.HingeCupSetBack)
        dialog:AddDoubleField("Hinge.HingeCupDepth",     Hinge.HingeCupDepth)
        dialog:AddDoubleField("Hinge.HingeCupDiameter",  Hinge.HingeCupDiameter)
        dialog:AddDoubleField("Hinge.ScrewCenter",       Hinge.ScrewCenter)
        dialog:AddDoubleField("Hinge.ScrewHoleDiameter", Hinge.ScrewHoleDiameter)
        dialog:AddDoubleField("Hinge.ScrewHoleDepth",    Hinge.ScrewHoleDepth)
        dialog:AddDoubleField("Hinge.ScrewHoleSetBack",  Hinge.ScrewHoleSetBack)
  if  dialog:ShowDialog() then
    Hinge.EdgeMinDistance        = dialog:GetDoubleField("Hinge.EdgeMinDistance")
    Hinge.HingeCupSetBack        = dialog:GetDoubleField("Hinge.HingeCupSetBack")
    Hinge.HingeCupDepth          = dialog:GetDoubleField("Hinge.HingeCupDepth")
    Hinge.HingeCupDiameter       = dialog:GetDoubleField("Hinge.HingeCupDiameter")
    Hinge.ScrewCenter            = dialog:GetDoubleField("Hinge.ScrewCenter")
    Hinge.ScrewHoleDiameter      = dialog:GetDoubleField("Hinge.ScrewHoleDiameter")
    Hinge.ScrewHoleDepth         = dialog:GetDoubleField("Hinge.ScrewHoleDepth")
    Hinge.ScrewHoleSetBack       = dialog:GetDoubleField("Hinge.ScrewHoleSetBack")
    Hinge.InquiryHardwareXY      = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    REG_WriteRegistry()
  end -- if end

  return true
end
-- ===================================================]]
function InquiryHinge(Header)
    Hinge.dialog = HTML_Dialog(true, DialogWindow.myHtml1, 605, 546,  Header .. " (Ver:" .. Hinge.VerNumber.. ")  " .. Hinge.UnitDisplay) ;
    Hinge.dialog:AddDoubleField("Hinge.FrameWidth",     Hinge.FrameWidth)
    if Hinge.DrillOrMillScrews == "Drilling" then
      Hinge.dialog:AddTextField("DrillState",  "Drilling")
    else
      Hinge.dialog:AddTextField("DrillState",  "Pocketing")
    end
    Hinge.dialog:AddDoubleField("Hinge.FrameHeight",    Hinge.FrameHeight)
    Hinge.dialog:AddDoubleField("Hinge.OverlapSide",    Hinge.OverlapSide)
    Hinge.dialog:AddDoubleField("Hinge.OverlapTop",     Hinge.OverlapTop)
    Hinge.dialog:AddDoubleField("Hinge.OverlapBottom",  Hinge.OverlapBottom)
    Hinge.dialog:AddDropDownList("Hinge.DoorsPer",      tostring(Hinge.DoorsPer))
    Hinge.dialog:AddDropDownList("Hinge.Count",         tostring(Hinge.Count))
    Hinge.dialog:AddIntegerField("Hinge.DoorSets",      Hinge.DoorSets)
    Hinge.dialog:AddDoubleField("Hinge.CornerDistance", Hinge.CornerDistance)
    Hinge.dialog:AddTextField("Hinge.Placement",        "Left")
    Hinge.dialog:AddLabelField("ToolNameLabel1", "Not Selected")
    Hinge.dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Hinge.Tool_ID1)
    Hinge.dialog:AddToolPickerValidToolType("ToolChooseButton1", Tool.END_MILL)
    Hinge.dialog:AddLabelField("ToolNameLabel2", "Not Selected")
    Hinge.dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Hinge.Tool_ID2)
    Hinge.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
    Hinge.dialog:AddLabelField("ToolNameLabel3", "Not Selected")
    Hinge.dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Hinge.Tool_ID3)
    Hinge.dialog:AddToolPickerValidToolType("ToolChooseButton3", Tool.END_MILL)
    Hinge.dialog:AddLabelField("ToolNameLabel4", "Not Selected")
    Hinge.dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Hinge.Tool_ID3)
    Hinge.dialog:AddToolPickerValidToolType("ToolChooseButton4", Tool.THROUGH_DRILL)
    if  Hinge.dialog:ShowDialog() then
      Hinge.FrameWidth     = Hinge.dialog:GetDoubleField("Hinge.FrameWidth")
      Hinge.FrameHeight    = Hinge.dialog:GetDoubleField("Hinge.FrameHeight")
      Hinge.OverlapSide    = Hinge.dialog:GetDoubleField("Hinge.OverlapSide")
      Hinge.OverlapTop     = Hinge.dialog:GetDoubleField("Hinge.OverlapTop")
      Hinge.OverlapBottom  = Hinge.dialog:GetDoubleField("Hinge.OverlapBottom")
      Hinge.DoorsPer       = tonumber(Hinge.dialog:GetDropDownListValue("Hinge.DoorsPer"))
      Hinge.CornerDistance = Hinge.dialog:GetDoubleField("Hinge.CornerDistance")
      Hinge.Count          = tonumber(Hinge.dialog:GetDropDownListValue("Hinge.Count"))
      Hinge.DoorSets       = Hinge.dialog:GetIntegerField("Hinge.DoorSets")
      Hinge.Placement      = Hinge.dialog:GetTextField("Hinge.Placement")
      Hinge.MillTool1      = Hinge.dialog:GetTool("ToolChooseButton1")  -- Profile
      Hinge.MillTool2      = Hinge.dialog:GetTool("ToolChooseButton2")  -- Pocketing
      Hinge.MillTool3      = Hinge.dialog:GetTool("ToolChooseButton3")  -- Clearing
      Hinge.MillTool4      = Hinge.dialog:GetTool("ToolChooseButton4")  -- Drilling
      Hinge.InquiryHingeXY = tostring(Hinge.dialog.WindowWidth) .. " x " .. tostring(Hinge.dialog.WindowHeight)
      if not REG_WriteRegistry() then
        DisplayMessageBox("Error: Writting Registry")
        return false
      end -- if end
      if Hinge.Count < 2 then
          Hinge.Count = 2
      end
      return true
    else
      return false
    end
 end
-- ===================================================]]
function AllTrim(s)                                     -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function CheckHingeValues()                             -- Look at what the User inputed.
  if Hinge.FrameWidth <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Openning Width value. \nMust be greater than zero (0.0)")
  end
  if Hinge.FrameHeight <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Openning Height value. \nMust be greater than zero (0.0)")
  end

  if Hinge.FrameWidth < (Hinge.EdgeMinDistance * 5) then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Openning Width value is too small \n Value must be larger than " .. tostring(Hinge.EdgeMinDistance * 5))
  end

  if Hinge.CornerDistance < Hinge.EdgeMinDistance then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Corner Distance value is smaller the Hinge Spec.")
  end
end -- function end
-- ===================================================]]
function CheckHardwareValues()                          -- Look at what the User inputed.
  if Hinge.HingeCupSetBack <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Hinge Hole Set Back value (A)")
  end
  if Hinge.HingeCupDepth <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Hinge Cup Depth value (B) ")
  end
  if Hinge.HingeCupDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Hinge Cup Diameter value (B)")
  end
  if Hinge.ScrewCenter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Screw Centers value (C)")
  end
  if Hinge.ScrewHoleSetBack <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Screw Hole Set Back value (D)")
  end
  if Hinge.ScrewHoleDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Screw Hole Diameter value (E)")
  end
  if Hinge.ScrewHoleDepth <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Screw Hole Depth value (E) ")
  end
  if Hinge.EdgeMinDistance <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Edge Min Distance value (F)")
  end
end -- function end
-- ===================================================]]
function DrawDoor(pt1)
  Hinge.DoorH = Hinge.FrameHeight +  Hinge.OverlapBottom +  Hinge.OverlapTop
  Hinge.DoorW = Hinge.FrameWidth + Hinge.OverlapSide + Hinge.OverlapSide
  local pt2 = Polar2D(pt1,   0.0, Hinge.DoorW)
  local pt3 = Polar2D(pt2,  90.0, Hinge.DoorH)
  local pt4 = Polar2D(pt3, 180.0, Hinge.DoorW)
  local ptx = pt1
  local line = Contour(0.0)
  local layer = Hinge.job.LayerManager:GetLayerWithName(Hinge.LNameDoorProfile)
  line:AppendPoint(pt1) ;
  line:LineTo(pt2);
  line:LineTo(pt3) ;
  line:LineTo(pt4);
  line:LineTo(pt1);
  layer:AddObject(CreateCadContour(line), true)
  if  Hinge.Placement  == "Right"  or  Hinge.Placement  == "Left" then
    Hinge.HingeCenters =   (Hinge.DoorH - (Hinge.CornerDistance * 2.0))/ (Hinge.Count - 1)
  else
    Hinge.HingeCenters =   (Hinge.DoorW - (Hinge.CornerDistance * 2.0))/ (Hinge.Count - 1)
  end
  if Hinge.Placement  == "Right" then
    Hinge.Side = 0.0
    ptx  = Polar2D(pt2,  90.0,  Hinge.CornerDistance)
    for _ = Hinge.Count, 1, -1 do
      DrawHingeHole(ptx, Hinge.Side)
      ptx  = Polar2D(ptx,  90.0,  Hinge.HingeCenters)
    end
  elseif Hinge.Placement  == "Top" then
    Hinge.Side = 90.0
    ptx = Polar2D(pt3,  180.0,  Hinge.CornerDistance)
    for _ = Hinge.Count, 1, -1 do
      DrawHingeHole(ptx, Hinge.Side)
      ptx  = Polar2D(ptx,  180.0,  Hinge.HingeCenters)
    end
  elseif Hinge.Placement  == "Left" then
    Hinge.Side = 180.0
    ptx  = Polar2D(pt1,  90.0,  Hinge.CornerDistance)
    for _ = Hinge.Count, 1, -1 do
      DrawHingeHole(ptx, Hinge.Side)
      ptx  = Polar2D(ptx,  90.0,  Hinge.HingeCenters)
    end
  else
    Hinge.Side = 270.0
    ptx  = Polar2D(pt1,   0.0,  Hinge.CornerDistance)
    for _ = Hinge.Count, 1, -1 do
      DrawHingeHole(ptx, Hinge.Side)
      ptx  = Polar2D(ptx,  0.0,  Hinge.HingeCenters)
    end
  end
  return Polar2D(pt2, 0.0, Hinge.PartGap)
end -- function end
-- ===================================================]]
function CheckLayerValues()                             -- Look at what the User inputed.
  if  AllTrim(Hinge.LNameHingePocket) == "" then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Hinge hole layer name cannot be blank")
  end
  if AllTrim(Hinge.LNameScrewHole) == "" then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Screw hole layer name cannot be blank")
  end
  if AllTrim(Hinge.LNameDoorProfile) == "" then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Door profile layer name cannot be blank")
  end
end -- function end
-- ===================================================]]
function CheckMillingValues()                           -- Look at what the User inputed.
  if Hinge.ProfileBitDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Profile Bit Diameter value")
  end
  if Hinge.ScrewDrillingDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Hole Set Back value")
  end
  if Hinge.CupClearingBitDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Cup Clearing Bit Diameter value")
  end
  if Hinge.CupPocketBitDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Cup Pocket Bit Diameter value")
  end
  if Hinge.ScrewPocketingDiameter <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Screw Pocketing Diameter value")
  end
  if Hinge.DoorKerf < 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Door spacing Kerf value")
  end
  if Hinge.PartGap <= 0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Part Spacing value")
  end
end -- function end
-- ===================================================]]
function main()
  Hinge.job = VectricJob()
  if not Hinge.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  -- Hinge.Door                   = Hinge.job.Selection
  Hinge.MaterialBlock          = MaterialBlock()
  Hinge.MaterialBlockThickness = Hinge.MaterialBlock.Thickness
  --local units
  if Hinge.MaterialBlock.InMM then
    Hinge.Units = "mm"
    Hinge.Unit  = true
  else
    Hinge.Units = "inch"
    Hinge.Unit  = false
  end
  Hinge.UnitDisplay  = " Units: (" .. Hinge.Units ..")"
  Hinge.Toolpath_Mgr = ToolpathManager()
  HTML()
  if not REG_ReadRegistry() then
      DisplayMessageBox("Error: Reading from Registry")
    return false
  end
-- ===================================================]]
  while Hinge.DialogLoop do
    Hinge.Inquiry = InquiryHinge(DialogWindow.AppName)
    if Hinge.Inquiry == true then
      Hinge.DialogLoop = false
      CheckHingeValues()
      CheckLayerValues()
      CheckHardwareValues()
      CheckMillingValues()
    else
      Hinge.DialogLoop = false
    end -- if end
  end -- while end
-- ===================================================]]
  if Hinge.Inquiry then
    --local  objects
    Hinge.HingeCupRadius  = Hinge.HingeCupDiameter * 0.5
    Hinge.ScrewHoleRadius = Hinge.ScrewHoleDiameter * 0.5
    local pt1 = Point2D(0, 0)
    if Hinge.Unit then
      pt1 = Point2D(18.0, 18.0)
    else
      pt1 = Point2D(1.0, 1.0)
    end
    if Hinge.DoorsPer == 1 then
      for _ = Hinge.DoorSets, 1, -1 do
        pt1 = DrawDoor(pt1)
      end
    else
      Hinge.FrameWidthX = Hinge.FrameWidth
      Hinge.FrameWidth = (Hinge.FrameWidth * 0.5) - (Hinge.OverlapSide + (Hinge.DoorKerf * 0.5))
      for _ = Hinge.DoorSets, 1, -1 do
        Hinge.Placement = "Left"
        pt1 = DrawDoor(pt1)
        Hinge.Placement = "Right"
        pt1 = DrawDoor(pt1)
      end
      Hinge.FrameWidth = Hinge.FrameWidthX
    end
    if type(Hinge.MillTool1) == "userdata"  then
      Hinge.Profile = true
    else
      Hinge.Profile = false
    end  -- if end
    if type(Hinge.MillTool2) == "userdata" then
      Hinge.Pocket = true
    else
      Hinge.Pocket = false
    end  -- if end
    if type(Hinge.MillTool4) == "userdata"  then
      Hinge.Drilling = true
    else
      Hinge.Drilling = false
    end  -- if end

    CreateLayerProfileToolpath("Door Profile",        Hinge.LNameDoorProfile, 0.0, Hinge.MaterialBlockThickness, "OUT")
    CreateLayerPocketToolpath("Hinge Hole Pocket", Hinge.LNameHingePocket, 0.0, Hinge.HingeCupDepth)

    if Hinge.DrillOrMillScrews == "Pocketing" then
      CreateLayerPocketToolpath("Milled Screw Holes", Hinge.LNameScrewHole, 0.0, Hinge.HingeCupDepth)
    else
      CreateLayerDrillingToolpath("Drilled Screw Holes", Hinge.LNameScrewHole, 0.0, Hinge.ScrewHoleDepth, Hinge.ScrewHoleDepth * 0.15)
    end
    if not REG_WriteRegistry() then
      DisplayMessageBox("Error: Writting Registry")
      return false
    end
    Hinge.job:Refresh2DView()
  end
  return true
end
-- ===================================================]]
function CreateLayerDrillingToolpath(name, layer_name, start_depth, cut_depth, retract_gap)
  if Hinge.Drilling then
    local selection = Hinge.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Hinge.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No Drilling layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed Drilling vectors found on layer " .. layer_name)
      return false
    end
     -- Create tool we will use to machine vectors
      local tool = Tool(Hinge.MillTool4.Name, Tool.THROUGH_DRILL)       -- BALL_NOSE, END_MILL, VBIT, THROUGH_DRILL

      tool.InMM = Hinge.MillTool4.InMM -- tool_in_mm
      tool.ToolDia = Hinge.MillTool4.ToolDia -- tool_dia
      tool.Stepdown = Hinge.MillTool4.Stepdown -- tool_stepdown
      tool.Stepover = Hinge.MillTool4.ToolDia * 0.25
      tool.RateUnits = Hinge.MillTool4.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
      tool.FeedRate = Hinge.MillTool4.FeedRate  -- 30
      tool.PlungeRate = Hinge.MillTool4.PlungeRate   -- 10
      tool.SpindleSpeed = Hinge.MillTool4.SpindleSpeed    -- 20000
      tool.ToolNumber = Hinge.MillTool4.ToolNumber       -- 1
  --    tool.VBitAngle = 90.0                -- used for vbit only
  --    tool.ClearStepover = tool_dia * 0.5  -- used for vbit only
      -- we will set home position and safe z relative to material block size
      local mtl_block = MaterialBlock()
      local mtl_box = mtl_block.MaterialBox
      local mtl_box_blc = mtl_box.BLC
      -- Create object used to set home position and safez gap above material surface
      local pos_data = ToolpathPosData()
      pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
      pos_data.SafeZGap = mtl_block.Thickness * 0.1
      -- Create  object used to pass drilling options
      local drill_data = DrillParameterData()
      -- start depth for toolpath
      drill_data.StartDepth = start_depth
      -- cut depth for toolpath this is depth below start depth
      drill_data.CutDepth = cut_depth
      -- if true perform peck drilling
      drill_data.DoPeckDrill = retract_gap > 0.0
      -- distance to retract above surface when peck drilling
      drill_data.PeckRetractGap = retract_gap
      -- if true in Aspire, project toolpath onto composite model
      drill_data.ProjectToolpath = false
      -- Create object which can used to automatically select geometry on layers etc
      local geometry_selector = GeometrySelector()
      -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
      local create_2d_previews = true
      -- if this is true we will display errors and warning to the user
      local display_warnings = false -- = true
      -- Create our toolpath
      local toolpath_manager = ToolpathManager()
      local toolpath_id = toolpath_manager:CreateDrillingToolpath(
                                              name,
                                              tool,
                                              drill_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
      if toolpath_id  == nil  then
        DisplayMessageBox("Error creating toolpath")
        return false
      end
     end
  return true
end
-- ===================================================]]
function CreateLayerPocketToolpath(name, layer_name, start_depth, cut_depth)
  if Hinge.Pocket then
    local selection = Hinge.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Hinge.job.LayerManager:FindLayerWithName(layer_name)
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
    local tool              = Tool(Hinge.MillTool2.Name, Tool.END_MILL)    -- BALL_NOSE, END_MILL, VBIT
          tool.InMM         = Hinge.MillTool2.InMM            -- tool_in_mm
          tool.ToolDia      = Hinge.MillTool2.ToolDia         -- tool_dia
          tool.Stepdown     = Hinge.MillTool2.Stepdown        -- tool_stepdown
          tool.Stepover     = Hinge.MillTool2.Stepover        -- tool_dia * (tool_stepover_percent / 100)
          tool.RateUnits    = Hinge.MillTool2.RateUnits       -- Tool.MM_SEC     -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Hinge.MillTool2.FeedRate        -- 30
          tool.PlungeRate   = Hinge.MillTool2.PlungeRate      -- 10
          tool.SpindleSpeed = Hinge.MillTool2.SpindleSpeed    -- 20000
          tool.ToolNumber   = Hinge.MillTool2.ToolNumber      -- 1
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
    if type(Hinge.MillTool3) == "userdata" then
   -- we just create a tool twice as large for testing here
    area_clear_tool = Tool(
                          Hinge.MillTool3.Name,
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )
     area_clear_tool.InMM         = Hinge.MillTool3.InMM       -- tool_in_mm
     area_clear_tool.ToolDia      = Hinge.MillTool3.ToolDia    -- tool_dia * 2
     area_clear_tool.Stepdown     = Hinge.MillTool3.Stepdown   -- tool_stepdown * 2
     area_clear_tool.Stepover     = Hinge.MillTool3.Stepover   -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits    = Hinge.MillTool3.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate     = Hinge.MillTool3.FeedRate      -- 30
     area_clear_tool.PlungeRate   = Hinge.MillTool3.PlungeRate    -- 10
     area_clear_tool.SpindleSpeed = Hinge.MillTool3.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber   = Hinge.MillTool3.ToolNumber    -- 1
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
-- ===================================================]]
function CreateLayerProfileToolpath(name, layer_name, start_depth, cut_depth, InOrOut)
  if Hinge.Profile then
  --  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
    local selection = Hinge.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Hinge.job.LayerManager:FindLayerWithName(layer_name)
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
    local tool               = Tool(Hinge.MillTool1.Name, Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
          tool.InMM          = Hinge.MillTool1.InMM         -- tool_in_mm
          tool.ToolDia       = Hinge.MillTool1.ToolDia      -- tool_dia
          tool.Stepdown      = Hinge.MillTool1.Stepdown     -- tool_stepdown
          tool.Stepover      = Hinge.MillTool1.Stepover     -- tool_dia * 0.25
          tool.RateUnits     = Hinge.MillTool1.RateUnits    -- Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
          tool.FeedRate      = Hinge.MillTool1.FeedRate     -- 30
          tool.PlungeRate    = Hinge.MillTool1.PlungeRate   -- 10
          tool.SpindleSpeed  = Hinge.MillTool1.SpindleSpeed -- 20000
          tool.ToolNumber    = Hinge.MillTool1.ToolNumber   -- 1
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
    local lead_in_out_data   = LeadInOutData() -- Create object used to control lead in/out
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
-- ===================================================]]
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
-- ===================================================]]
function DrawHingeHole(pt, ang)
  local phcp = Point2D(0,0)
  if  Hinge.Placement  == "Right"  or  Hinge.Placement  == "Left" then
    phcp   = Polar2D(pt,   ang  + 180.0,  Hinge.HingeCupSetBack + Hinge.HingeCupRadius + Hinge.OverlapSide)
  elseif  Hinge.Placement  == "Top" then
    phcp   = Polar2D(pt,   ang  + 180.0,  Hinge.HingeCupSetBack + Hinge.HingeCupRadius + Hinge.OverlapTop)
    else --  Hinge.Placement  == "Bottom" then
    phcp   = Polar2D(pt,   ang  + 180.0,  Hinge.HingeCupSetBack + Hinge.HingeCupRadius + Hinge.OverlapBottom)
  end
  local pt1    = Polar2D(phcp,   0.0,  Hinge.HingeCupRadius)
  local pt2    = Polar2D(phcp, 180.0,  Hinge.HingeCupRadius)
  local phsp   = Polar2D(phcp, ang + 180.0, Hinge.ScrewHoleSetBack + Hinge.HingeCupRadius)
  local phsp1  = Polar2D(phsp, ang + 90.0,  Hinge.ScrewCenter * 0.5)
  local phsp2  = Polar2D(phsp, ang + 270.0,  Hinge.ScrewCenter * 0.5)
  local line   = Contour(0.0)
  local layer  = Hinge.job.LayerManager:GetLayerWithName(Hinge.LNameHingePocket)
  line:AppendPoint(pt1)
  line:ArcTo(pt2, 1)
  line:ArcTo(pt1, 1)
  layer:AddObject(CreateCadContour(line), true)
  pt1   = Polar2D(phsp1,   0.0,  Hinge.ScrewHoleRadius)
  pt2   = Polar2D(phsp1, 180.0,  Hinge.ScrewHoleRadius)
  line  = Contour(0.0)
  layer = Hinge.job.LayerManager:GetLayerWithName(Hinge.LNameScrewHole)
  line:AppendPoint(pt1)
  line:ArcTo(pt2 , 1)
  line:ArcTo(pt1 , 1)
  layer:AddObject(CreateCadContour(line), true)
  pt1   = Polar2D(phsp2,   0.0,  Hinge.ScrewHoleRadius)
  pt2   = Polar2D(phsp2, 180.0,  Hinge.ScrewHoleRadius)
  line  = Contour(0.0)
  --layer = Hinge.job.LayerManager:GetLayerWithName(Hinge.LNameScrewHole)
  line:AppendPoint(pt1)
  line:ArcTo(pt2 , 1)
  line:ArcTo(pt1 , 1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
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
DialogWindow.myBackGround = [[data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDACgcHiMeGSgjISMtKygwPGRBPDc3PHtYXUlkkYCZlo+AjIqgtObDoKrarYqMyP/L2u71////m8H////6/+b9//j/2wBDASstLTw1PHZBQXb4pYyl+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj/wAARCAHUAu4DASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDNApcUop1SUNxS4paWkMbijFOooAZijbT6QUAJto20/FGKAGYo20/FGKAGbaUClxTh0oAZtpdtOxS0hkZWjbTz1pMUxCbeKNtPxxRSGM20hWpKQ0AMxRtp9HemIZijbTwKMUgGbaXbTsUtAxm2jbT8UUAM20bafRQAwLS7aeBS4ouFiPbSbakxRii4WGbaAvNPxQBRcLDdtLtp+KMUrhYjK8Um2pSOKTFO4WGBaNtPA5pcUXCxHto21JijFFwsRbaCtPFBHFADAtG2n4pcUBYi20u2n4pcUXCwzbRtp+KMUBYj20bakpKAI9vNO204U7FFwsRFaNtSEZpMUXCxHto21JikxRcLCbaTbUlGKLhYZtpCtSYpCOaLhYj20u2nYp2KAsR7aNtPxRii4WIytGKeetFAEeKNtPxQKYhm2jbTsUYoAbto20+jFADMUbafSUAM20oXil707HFADNtJipKTFADNtG2n4pMUANApdtOFLQAzbSFafQaAI8UoWnYoFADcUwipaYaABadTRThQAUtFFABRijvS0gEpKWimAtLRSUhi0lLSUAFKKKBQAtFFFACGig0UAL2oo7UUAFBpRSN2oASjvRQaAFoNIKU0AFFFLQAlLijtSigBKQ0pooAFpaFopDFpKWkNABQOppaB1oAWiiigAPSkpT0pKAAUtIKWgAoPSgUvagBlB6UCg9KAAUtNpaAEpe1ApaAEpaO9Hc0AJiilNJQAg606kHUU6gBKKKKAEoNFFAC0UCigApvenUh60AJS0lLQAUUd6KAGnrRQetFMQlLSUUAFHeiigAoo7UUAGKSnUlACGlHSkpR0oAKKKKAEopaSgAFLSCloAKQ0tIaAE7UopKUUAIaYaeelMNMQLTqatOoAWiijvQAd6WkHWlpAJRQaKYDqKKKQwooooASndqbTqACiiigANJSmkoAXtS0gpaACkNKKDQAlIaWigBBSmkFLQAUtJS0AFLSUtIBDSU40hoAUdDS0L3paBiUUGjvQAhzTlpD1oWgB1FHeikAh6UlOPSm0wFHWl7Ug60tABR2ope1IBlFFFMBo606k70tACCloFAoAKBRSigAxTadTaAAdadTR1p5oASkpcUlABSClPSk70AOooNHagBKQ96dTTQAlOptOoASloooAaetJSnrSUxCGgUHpQKAA0UUtACUelLSd6AFpDS0hoASlHSkpw6UAFJS0lABSHrS0lACiigdKKACkNLQaAG0o6UlKKBAelMNPNMNMBBThTRTqAFpaTtS0AIKWjvRSGBpKU0lMQ6iiikMKO1FFAAaWkPSl7UAFFFLQAhpKU0UAFLSUtABQaWkNIBBQaKQ9aYCjpRRRQAUtHelpAFLSUooGBptOPSm+tADl6GlpF6U6gBKO9FFAB60L3ooXqaAFoopaQxOxpKd2ptAgFLQKWgBKXtRQelAxlKRSUHpTEJjml70CloASlFJ2p1ACdqBS0goAWmmnU00AA606m/xU6gApKWkoAQ9qD1pfSkNAC0UppKACkPWlpD1oASig0tACUtFFADT1o7UHrRTENNHajvS0AJS0UCgAoooo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]]
-- =======================================================]] -- Style
DialogWindow.Style = [[<style type="text/css">html {overflow:hidden}
.DirectoryPicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}
.FormButton {font-weight:bold;width:75px;font-family:Arial, Helvetica, sans-serif;font-size:12px;white-space:nowrap;background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.LuaButton {font-weight:bold; width:120px; font-family:Arial, Helvetica, sans-serif;font-size:12px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.ToolNameLabel {font-family:Arial, Helvetica, sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}
.ToolPicker {font-weight:bold;text-align:center;font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;width:50px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.alert-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:  ]].. DialogWindow.StyleTextColor .. [[;text-align:center;white-space:nowrap}
.alert-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;text-shadow: 5px 5px 10px #FFF;color:#FF0101 ;text-align:left;white-space:nowrap}
.alert-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}
.error {font-family:Arial, Helvetica, sans-serif;font-size:18px;font-weight:bold;color:#FF0000 ;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px;}
.errorMessage {font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left; white-space:nowrap;padding-right:4px; padding-left:10px; padding-top:4px;padding-bottom:4px;}
.errorTable {background-color:#FFFFFF white-space:nowrap;}
.helpbutton{background-color:]].. DialogWindow.StyleButtonColor .. [[;border-style: ridge;border:2px solid #999;border-right-color:#666666;border-bottom-color:#666666;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:]].. DialogWindow.StyleButtonTextColor .. [[}
.helpbutton:active{border-right-color:#FFF; border-bottom-color:#FFF;border-top-color:#000; border-left-color:#000}
.helpbuttoni:hover{border-right-color:#000; border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}
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
.jsbutton {background-color: ]].. DialogWindow.StyleButtonColor ..[[ ;width:60px; border:2px solid #999;border-right-color:#000;border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF; 12px;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none; font-size:12px; margin:1px 1px; color:]].. DialogWindow.StyleButtonTextColor .. [[ }
.jsTag-no-vis {font-family:Arial, Helvetica, sans-serif;font-size:10px;display:none; text-align:center; color:#00F; visibility: hidden;}
body {background-color: ]].. DialogWindow.StyleBackGroundColor  ..[[; background-position: center; overflow:hidden;font-family:Arial, Helvetica, sans-serif;font-size:12px; color: ]].. DialogWindow.StyleTextColor .. [[;
background-image: url(]].. DialogWindow.myBackGround ..[[); }html {overflow:hidden;}</style>]]
-- =========================================================]] -- About
DialogWindow.myHtml5 = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="header1-c" id="SysName">Easy Cabinet Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" class="ver-c" id="Version">Version</td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td> </tr> <tr> <td align="center" class="p1-l"><p class="p1-l">The ]] .. DialogWindow.AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br> <br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br> <br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td> </tr> <tr> <td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td> </tr> <tr> <td align="center" ><span class="header2-c">James Anderson</span></td> </tr> <tr> <td align="center"><span class="h1-c">Houston, TX.</span></td> </tr> <tr> <td><hr></td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr></table></body>]]
-- =========================================================]] -- Layers
DialogWindow.myHtml4 =[[<html><head> <title>Layer Names</title> ]] .. DialogWindow.Style ..[[</head><body  text="#000000"> <table width="450" border="0" cellpadding="0" id="ValueTable"> <tr> <td width="125" align="right" valign="middle" nowrap class="h1-rp">Door <span class="h1-r"> Panel Profile</span></td> <td width="419" align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><span class="h1-r"> <input name="Hinge.LNameDoorProfile" type="text" class="h1-l" id="Hinge.LNameDoorProfile" size="50" maxlength="50" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp"><span class="h1-rp">Hinge Hole Layer</span></td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><span class="h1-r"> <input name="Hinge.LNameHingePocket" type="text" class="h1-l" id="Hinge.LNameHingePocket" size="50" maxlength="50" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp"><span class="h1-rp">Screw Hole Layer</span></td> <td align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><span class="h1-r"> <input name="Hinge.LNameScrewHole" type="text" class="h1-l" id="Hinge.LNameScrewHole" size="50" maxlength="50"/> </span></td> </tr> </table> <table width="100%" border="0" id="ButtonTable"> <tr> <td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"> <hr> </td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDKLayer .. [[" target="_blank" class="helpbutton">Help</a> </strong> </td> <td width="308" class="alert" id="GadgetName.Alert">.</td> <td width="94" class="h1-c" style="width: 15%"> <input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td width="89" class="h1-c" style="width: 15%"> <input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"> </td> </tr> </table></body></html>]]
-- =========================================================]] -- Milling
DialogWindow.myHtmlMilling = [[<html><head><title>Milling Information</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="560" border="0" cellpadding="0"> <tr> <td width="200" nowrap class="h1-rP">Profile Bit Diameter </td> <td width="60" nowrap class="h1-l"><input name="Hinge.ProfileBitDiameter " type="text" id="Hinge.ProfileBitDiameter" size="10" maxlength="10" /></td> <td width="220" nowrap class="h1-rP">Screw Pocketing Diameter</td> <td width="60" nowrap class="h1-l"><input name="Hinge.ScrewPocketingDiameter" type="text" id="Hinge.ScrewPocketingDiameter" size="10" maxlength="10" /></td> </tr> <tr> <td class="h1-rP">Cup Clearing Bit Diameter </td> <td class="h1-l"><input name="Hinge.CupClearingBitDiameter" type="text" id="Hinge.CupClearingBitDiameter" size="10" maxlength="10" /></td> <td class="h1-rP">Screw Drilling Diameter</td> <td class="h1-l"><input name="Hinge.ScrewDrillingDiameter" type="text" id="Hinge.ScrewDrillingDiameter" size="10" maxlength="10" /></td> </tr> <tr> <td class="h1-rP">Cup Pocket Bit Diameter</td> <td class="h1-l"><input name="Hinge.CupPocketBitDiameter" type="text" id="Hinge.CupPocketBitDiameter" size="10" maxlength="10" /></td> <td class="h1-rP">Part Layout Spacing </td> <td class="h1-l"><input name="Hinge.PartGap" type="text" id="Hinge.PartGap" size="10" maxlength="10" /></td> </tr> <tr> <td class="h1-rP">Door Spacing Kerf Amount</td> <td class="h1-l"><input name="Hinge.DoorKerf" type="text" id="Hinge.DoorKerf" size="10" maxlength="10" /></td> <td class="h1-rP">Milling of Screw Holes</td> <td class="h1-l"><select name = "Hinge.DrillOrMillScrews" size = "1" id = "Hinge.DrillOrMillScrews"> <option>Pocketing</option> <option>Drilling</option> </select></td> </tr></table><table width="100%" border="0" id="ButtonTable"> <tr> <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDKMilling .. [[" target="_blank" class="helpbutton">Help</a> </strong></td> <td width="328" class="alert" id="GadgetName.Alert">.</td> <td width="" class="h1-c" style="width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> </tr></table></body></html>]]
-- =========================================================]]
DialogWindow.myHtml2 = [[<html><head><title>Hinge Settings</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="450" height="206" border="0" cellpadding="0" id="ValueTable"> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Hinge Hole Setback (A)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable"><span class="h1-r" id="Hinge.HoleSetback"> <input name="Hinge.HingeCupSetBack" type="text" class="h1-l" id="Hinge.HingeCupSetBack" size="10" maxlength="10" /> </span></td> <td width="222" rowspan="9" valign="top" nowrap class="h1-l" id="ValueTable"><img src="data:image/jpeg;base64,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AJUH8gK6Kveo1FWpRqL7ST+8+axFF4etOk3dxbX3MKKKK2OcKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiimtwIv2Uf+TW/g5/2Jujf+kMNep15Z+yj/ya38HP+xN0b/0hhr1OvqjxzzGiiivlD2AooooAKKKKACiiuUvf+E2+2T/ZBoItfMbyvO87fsz8u7HGcYzisK1X2KT5W/RXOijR9q2uZK3d2Oa+PWjy3mh6fqUXMdjMfOUsBhHwu78Dj868z1DUbfxpZwg211qfiq4ulc3UYVIwiqFCbR1+UDjavPJOBg+s6z4d8X6+bb7fB4duEt2Z0jZrjZuxjJXOG4z1Bxk461dS18dx52f8I8uepAmr5LE4WWIxEqtmouyta/z8muh95gcfTwmGhSck5Rbad7Wv0v1T67HQaHpMlj4T0/TJmAmhso7Z2XkbhGFJHrzXC2Pwd1LTYjHZ+Lbq0jZtxWCJkUnAGcCTrwPyre2+P/73h/8A8jUu3x//AHvD/wD5Gr1K0aOIcXUpSbjtuvyseJRqYjD86p1oJTd3s/zT7nWWkL29rDE8hmdEVWkbqxAxk/Wua8a+Irm18nR9HKya5fcR+kCd5W9AOce474xVfb4//veH/wDyNV/wj4Xl0mS51DUpI7vW7xiZriPJVUz8saZ6KMD6984FdUqlSuvZU4uKe7ell5eZxQp0cNJ16slJrZLq/PyRe8M+HbfwzpSWcHzvnfLM33pZD95j7n+QFatFFenTpxpRUIKyR5FWrKtUc5u7e7CiiirMgooooAKKKKACiiigDjfiZ4NvfGWm2dvZSW8ckMpkY3DMBjaRxgGsG4+HPinxNLFH4i16GSyRtxjtR1/Daoz7nNeoUV5VXLKFerKpO/vWurtJ22ulue5QzfE4alGlTt7t7NpNq+9m9iGys4dOs4bW3QRwQoERB2AGBU1FFeokoqy2PElJyfNLVsKKKKYgooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKa3Ai/ZR/wCTW/g5/wBibo3/AKQw16nXln7KP/Jrfwc/7E3Rv/SGGvU6+qPHPMaKKK+UPYCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiimtwIv2Uf8Ak1v4Of8AYm6N/wCkMNep15Z+yj/ya38HP+xN0b/0hhr1OvqjxzzGiiivlD2AooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoooprcCL9lH/AJNb+Dn/AGJujf8ApDDXqdeWfso/8mt/Bz/sTdG/9IYa9Tr6o8c//9k=" alt="" name="Hinge" width="180" height="200" border="1" align="top"></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Hinge Cup Diameter (B)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable"><span class="h1-r" id="Hinge.LNameHingeHolePocket"> <input name="Hinge.HingeCupDiameter" type="text" class="h1-l" id="Hinge.HingeCupDiameter" size="10" maxlength="10" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Hinge Cup Depth (B)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable11"><span class="h1-r"> <input name="Hinge.HingeCupDepth" type="text" class="h1-l" id="Hinge.HingeCupDepth" size="10" maxlength="10" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Screw Centers (C)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable10"><span class="h1-r"> <input name="Hinge.ScrewCenter" type="text" class="h1-l" id="Hinge.ScrewCenter" size="10" maxlength="10" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Screw Hole Setback (D)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable7"><span class="h1-r"> <input name="Hinge.ScrewHoleSetBack" type="text" class="h1-l" id="Hinge.ScrewHoleSetBack" size="10" maxlength="10" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Screw Diameter (E)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable6"><span class="h1-r"> <input name="Hinge.ScrewHoleDiameter" type="text" class="h1-l" id="Hinge.ScrewHoleDiameter" size="10" maxlength="10" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Screw Hole Depth (E)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable6"><span class="h1-r"> <input name="Hinge.ScrewHoleDepth" type="text" class="h1-l" id="Hinge.ScrewHoleDepth" size="10" maxlength="10" /> </span></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h1-rp">Edge Min Distance (F)</td> <td valign="middle" nowrap class="h1-l" id="ValueTable6"><span class="h1-r"> <input name="Hinge.EdgeMinDistance" type="text" class="h1-l" id="Hinge.EdgeMinDistance" size="10" maxlength="10" /> </span></td> </tr> </table><table width="100%" border="0" id="ButtonTable"> <tr> <td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDKHardware .. [[" target="_blank" class="helpbutton">Help</a> </strong></td> <td width="279" class="alert" id="Hinge.Alert">.</td> <td width="75" class="h1-c" style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> <td width="75" class="h1-c" style="width: 15%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> </tr></table></body></html>]]
-- =========================================================]]
DialogWindow.myHtml1 = [[<html><head><title>Cabinet Door Hinge Creator</title>]] .. DialogWindow.Style ..[[<script> function myDrillDisplay() { var x = document.getElementById("DrillTable"); var text=document.getElementById("DrillState").value; if (text == "Drilling"){ x.style.visibility = "visible"; } else { x.style.visibility = "hidden"; }}function myFunctionTop() { document.getElementById("Hinge.Placement").value = "Top"; document.getElementById('myImage').src='data:image/png;base64,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5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJAn5wCQJ+cAkCfnAJD3crfbjYeLu3n98c3b8RgAOl69f/fi5sN4soR15Xw8AIAcOQcALuGzcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAMiTcwDIk3MAyJNzAIh78eJfBruO7KnhqCgAAAAASUVORK5CYII=';}function myFunctionBottom() { document.getElementById("Hinge.Placement").value = "Bottom"; document.getElementById('myImage').src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAApwAAAO7CAIAAAB298PIAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABKlSURBVHhe7d2/jhP3GoBhOBItVSrKVIg6bZQKKdfDFewVcD2RqCLa1IiKkoqKlsJncma04uwa47Vn1uN3nqfYjJtdW/p93+s/Wfbpbrd7AgBcv/9M/wUArpyoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAxNPdbjddXtzNy+kCAK7Ozcfp4nLWFfWvr99M1wBwPZ6/eyvq/+9/Uf/24tV0EwCuwbPPH1YSdZ+pA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQMTT3W43XV7czcuvr998e/FqurlVv/z6+3R1tC+f3k9XAOexgk7w7POH5+/ePrn5ON2+HFFfi9tB+uPPf8aL4/3912/jhdECTmMFnUPU99lq1MdZOmGQ7htHS9qB41lB5xP1fbYX9Rln6XvSDhzDCpqLqO+z+qjfvj01OufILjRL3zt/rmZ8vMD5rKDpan1EfZ91R304XncGYDiypx2y+99qOTPeyZO/FXA+K2jNK0jU91lr1IezNXzdOwPDIRu+PuicPeY4jR46CfM+XuBMVtCt1a4gUd9nlVE/ZgCOPLIHTurSjp+EGR8vcD4r6L4VrqD1RN0/PjOD4QiO03LAeFIvMk6D8UcfeSenGz92zLcCzjfjSI7f6pjvtoTxRx95J6cbnETUD5nrhK3kpB4zVEBPbAVZZQeI+jwOHLKVjNPoWu4n8CBWECNRX9YKj+mBoQJilHJrRH2LdB22YJ1Ft38WJeoLWvNzZHMFbfbPNon6PMZf2PjemifqR+4/CuAq3Bne9e+fvV23gs4n6od8+fT++EP2/e9NXkXR7wzV2n7vE3iQax/h4+//sJbtqx8R9RlkTtjwKI55EmOi4HGcNpLX8jbh/RfrRz5eDhD1n/jpIbtfuGuZqMEJQ3X/8QLLaY+kFTQ7Uf+5A4fs/vG6oqL/yIMeL7A0K+iWFfRT/u33Y915Ojm6f7yucaL2zsmRjxd4HFbQYLUryB902Wf1f0/9p65xnAae/EKDFXQp/qALKzJsgb1PigEegRU0I1EHgAhRn82VvvEFNFhBDESdf3n7C7ggK2guog4AEaIOABGiPg+fZgEXZAUxEnUmPtMCLsgKmoWoA0CEqANAhKgDQISoA0CEqANAhKgDQISoA0CEqANAhKgDQISoM/n7r9++fHo/3QB4XFbQLER9HsNZHE7kdAPgcVlBjEQdACJEHQAiRJ1/+TQLuCAraC6iPhufaQEXZAUxEHUAiBB1vPEFXJIVNCNRn5O3v4ALsoIQ9a3zHBm4ICtoXqI+M8+UgQuygjZO1OdnqACO4WX67ER900wU9HhdsWWivghDBXCYFxVLEPXtMlFQ5XXFZon6UgwVwI94UbEQUV/QmrtuoqDN/tkmUd8iEwVbsM6u2z+LEvVlrXCoTBRsxzq7znJEfXGrGipFh62xgjZF1B/DOFSXnavxDhgn2CAraDue7na76fLibl5+ff3m24tX082iX379ffj6x5//jDcfxzjJZgmwghby7POH5+/ePrn5ON2+HK/UH9VwrMenzNPt5Y1PjRUdGFhBeaJ+AeNQLT1X448wS8AdVlCYt98vaaG3wsZZNUvAYVbQXNbz9ruoX96McyXnwENZQecT9X22GvXROFeDE0ZrHKSBnAOnsYLOIer7bDvqt25Ha7R3wG5HaKTlwFysoBOI+j6ivs+dARsZIeBxWEHHEPV9RB2AK7SeqPuVNgCIEHUAiBB1AIhY3Wfq0zUAXA//o9w9Ny+nCwC4OqIOAMzFZ+oAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAECHqABAh6gAQIeoAkPDkyX8BqYnTnHP400sAAAAASUVORK5CYII=';} function myFunctionLeft() { document.getElementById("Hinge.Placement").value = "Left"; document.getElementById('myImage').src='data:image/png;base64,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OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8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';} function myFunctionRight() { document.getElementById("Hinge.Placement").value = "Right"; document.getElementById('myImage').src='data:image/png;base64,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aNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IAaNNyAGjTcgBo03IA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';} function myFunction2Door() { var x = document.getElementById("Door2"); var y = document.getElementById("Door1"); var z = document.getElementById("Hinge.DoorsPer"); var text = z.options[z.selectedIndex].text; if (text == "1") { y.style.display = "block"; x.style.display = "none"; } else { y.style.display = "none"; x.style.display = "block"; }}function codeAddress() { var x = document.getElementById("Door2"); var y = document.getElementById("Door1"); var z = document.getElementById("Hinge.DoorsPer"); var texta = z.options[z.selectedIndex].text; if (texta == "1"){ y.style.display = "block"; x.style.display = "none"; } else { y.style.display = "none"; x.style.display = "block"; } var aa = document.getElementById("DrillTable"); var textb=document.getElementById("DrillState").value; if (textb == "Drilling"){ aa.style.visibility = "visible"; } else { aa.style.visibility = "hidden"; }}</script></head><body "text = "#000000" onload = "codeAddress()" onFocus="myDrillDisplay()"><table width="570" border="0"> <tr> <td width="25%" align="center" ><span class="FormButton"> <input id = "InquiryHardware" class = "LuaButton" name = "InquiryHardware" type = "button" value = "Hardware"> </span></td> <td width="25%" align="center"> <input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Layers"> </td> <td width="25%" align="center"> <input id = "InquiryMilling" class = "LuaButton" name = "InquiryMilling" type = "button" value = "Milling"> </td> <td width="25%" align="center"> <input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About"> </td> </tr> <tr> <td colspan="4"><hr></td> </tr></table><table width="570" border="0"> <tr> <td align="right"><table width="214" border="0"> <tr> <td width="121" nowrap class="h1-rp">Opening Width</td> <td width="83"><input name = "Hinge.FrameWidth" type = "text" id = "Hinge.FrameWidth" size = "10" maxlength = "10" /></td> </tr> <tr> <td nowrap class="h1-rp">Opening Height</td> <td><input name = "Hinge.FrameHeight" type = "text" id = "Hinge.FrameHeight" size = "10" maxlength = "10"  /></td> </tr> <tr> <td nowrap class="h1-rp">Side Over Lap</td> <td><input name = "Hinge.OverlapSide" type = "text" id = "Hinge.OverlapSide" size = "10" maxlength = "10"   /></td> </tr> <tr> <td nowrap class="h1-rp">Top Over Lap</td> <td><input name = "Hinge.OverlapTop" type = "text" id = "Hinge.OverlapTop" size = "10" maxlength = "10"   /></td> </tr> <tr> <td nowrap class="h1-rp">Bottom Over Lap</td> <td><input name = "Hinge.OverlapBottom" type = "text" id = "Hinge.OverlapBottom" size = "10" maxlength = "10"   /></td> </tr> <tr> <td nowrap class="h1-rp">Doors Per Opening</td> <td><span class="h1-l"> <select name = "Hinge.DoorsPer" size = "1" id = "Hinge.DoorsPer" onChange="myFunction2Door();"> <option value="1">1</option> <option value="2">2</option> </select> </span></td> </tr> <tr> <td nowrap class="h1-rp">Hinge to Corner</td> <td><span class="h1-l"> <input name = "Hinge.CornerDistance" type = "text" class = "h2" id = "Hinge.CornerDistance" size = "10" maxlength = "10"   /> </span></td> </tr> <tr> <td nowrap class="h1-rp">Hinge Count</td> <td><span class="h1-l"> <select name = "Hinge.Count" size = "1" id = "Hinge.Count"  > <option selected>2</option> <option>3</option> <option>4</option> <option>5</option> <option>6</option> <option>7</option> </select> </span></td> </tr> <tr> <td nowrap class="h1-rp">Door Sets</td> <td><input name = "Hinge.DoorSets" type = "text" id = "Hinge.DoorSets" value="1" size = "10" maxlength = "10"   /></td> </tr> </table></td> <td align="left" valign="middle"><table width="209" height="235" border="0" align="center" id="Door2" display:none> <tr> <td width="394" height="246"><img src='data:image/png;base64,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AQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAAMqIUAACAjCgFAAAgI0oBAADIiFIAAAAyohQAAICMKAUAACAjSgEAAMiIUgAAADKiFAAAgIwoBQAAICNKAQAAyIhSAAAA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' alt="" name="Doors2" width="180" height="170" hspace="0" vspace="0"></td> </tr> </table></td> <td align="left"><table width="209" height="235" border="0" align="center" id="Door1"> <tr> <td width="44" ><input name = "Hinge.Placement" type = "text" class="jsTag-no-vis" id = "Hinge.Placement" value="Left" size = "10" maxlength = "10" /></td> <td width="100" align="center" class="h1-c"><button class="jsbutton" onClick="myFunctionTop()"><strong>Top</strong></button></td> <td width="51">&nbsp;</td> </tr> <tr> <td width="44" ><input name = "DrillState" type = "text" class="jsTag-no-vis" id = "DrillState" onChange="myDrillDisplay()" value="Drilling" size = "10" maxlength = "10" /></td> <td rowspan="7" align="center"><img id="myImage" src='data:image/png;base64,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OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8OQeAPDkHgDw5B4A8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' style="width:100px"></td> <td>&nbsp;</td> </tr> <tr> <td align="right">&nbsp;</td> <td>&nbsp;</td> </tr> <tr> <td height="20">&nbsp;</td> <td>&nbsp;</td> </tr> <tr> <td height="20" align="right"><button class="jsbutton" onClick="myFunctionLeft()"><strong>Left</strong></button></td> <td><button class="jsbutton" onClick="myFunctionRight()"> <strong>Right</strong></button></td> </tr> <tr> <td height="20">&nbsp;</td> <td>&nbsp;</td> </tr> <tr> <td height="20" align="right"></td> <td></td> </tr> <tr> <td height="20">&nbsp;</td> <td>&nbsp;</td> </tr> <tr> <td>&nbsp;</td> <td align="center"><button class="jsbutton" onClick="myFunctionBottom()"><strong>Bottom</strong></button></td> <td>&nbsp;</td> </tr> </table></td> </tr> <tr> <td height="4" colspan="3"><hr></td> </tr></table><table width="570" border="0" id="ProfileTable"> <tr> <td width="140" class="h1-rp">Profile Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#00FFFF" class = "ToolNameLabel"><span id = "ToolNameLabel1">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton1" class = "ToolPicker" name = "ToolChooseButton1" type = "button" value = "Tool" onClick="myDrillDisplay()" > </strong></td> </tr></table><table width="570" border="0" id="PocketTable"> <tr> <td width="140" class="h1-rp">Pocket Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#FFFF00" class = "ToolNameLabel"><span id = "ToolNameLabel2">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton2" class = "ToolPicker" name = "ToolChooseButton2" type = "button" value = "Tool" onClick="myDrillDisplay()" > </strong></td> </tr></table><table width="570" border="0" id="ClearingTable"> <tr> <td width="140" class="h1-rp">Pocket Clearing Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#FFFF00" class = "ToolNameLabel"><span id = "ToolNameLabel3">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton3" class = "ToolPicker" name = "ToolChooseButton3" type = "button" value = "Tool" onClick="myDrillDisplay()" > </strong></td> </tr></table><table width="570" border="0" id="DrillTable"> <tr> <td width="140" class="h1-rp">Drilling Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#66FF00" class = "ToolNameLabel"><span id = "ToolNameLabel4">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton4" class = "ToolPicker" name = "ToolChooseButton4" type = "button" value = "Tool" onClick="myDrillDisplay()" > </strong></td> </tr></table><table width="570" border="0" id="ButtonTable"> <tr> <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDK .. [[" target="_blank" class="helpbutton">Help</a> </strong></td> <td width="328" class="alert" id="GadgetName.Alert">.</td> <td width="" class="h1-c" style="width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> </tr></table></body></html>]]
-- =========================================================]]
  return true
end
-- ==================== End ==========================]]