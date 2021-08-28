-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented;  you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

 -- Easy Dovetail Maker is written by JimAndi Gadgets of Houston Texas 2019
]]
-- ===================================================]]
-- Global variables
require("mobdebug").start()
-- require "strict"
-- Table Names
local Dovetail = {}
local Tools = {}
local DialogWindow = {}   -- Dialog Managment
if GetAppVersion() >= 10.0 then
  Dovetail.AppValue = true
  Tool_ID = ToolDBId()
  lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
  Tool_ID:LoadDefaults("My Toolpath1", "")
else
  Dovetail.AppValue = false
  lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
  Dovetail.Tool = Tool("Lua End Mill", Tool.END_MILL)
end --if end
-- ===================================================]]
function GetMaterialSettings()                          -- Get the Material Dims
  local myreturn = true
  local mtl_block = MaterialBlock()
  --local units
  if mtl_block.InMM then
    Dovetail.Units  = "Drawing Units: mm"
    Dovetail.Unit = true
  else
    Dovetail.Units  = "Drawing Units: inches"
    Dovetail.Unit = false
  end
	if mtl_block.Width> mtl_block.Height then
		Dovetail.MaterialThickness = mtl_block.Height
		Dovetail.MaterialLength = mtl_block.Width
    Dovetail.Orantation = "H"
	else
		Dovetail.MaterialThickness = mtl_block.Width
		Dovetail.MaterialLength = mtl_block.Height
    Dovetail.Orantation = "V"
	end
  Dovetail.FrontThickness = Dovetail.MaterialThickness
  Dovetail.SideThickness  = Dovetail.MaterialThickness
  if mtl_block.Height == mtl_block.Width then
      MessageBox("Error! Material block cannot square")
  end
    -- Display material XY origin
    Dovetail.Origin = "invalid"
    local xy_origin = mtl_block.XYOrigin
  if  xy_origin == MaterialBlock.BLC then
      Dovetail.Origin = "Bottom Left Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.OrantationX = "Y Orantation"
      Dovetail.Direction1 = 90.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 270.0
      Dovetail.Direction4 = 180.0
      Dovetail.Bulge = 1.0
    else -- Dovetail.Orantation == "H"
      Dovetail.OrantationX = "X Orantation"
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 90.0
      Dovetail.Direction3 = 180.0
      Dovetail.Direction4 = 270.0
      Dovetail.Bulge = -1.0
    end
  elseif xy_origin == MaterialBlock.BRC then
    Dovetail.Origin = "Bottom Right Corner"
    if Dovetail.Orantation == "V" then
      -- Validated
      Dovetail.OrantationX = "Y Orantation"
      Dovetail.Direction1 = 90.0
      Dovetail.Direction2 = 180.0
      Dovetail.Direction3 = 270.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = -1.0
    else -- Dovetail.Orantation == "H"
      Dovetail.OrantationX = "X Orantation"
      Dovetail.Direction1 = 180.0
      Dovetail.Direction2 = 90.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 270.0
      Dovetail.Bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.TRC then
      Dovetail.Origin = "Top Right Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.OrantationX = "Y Orantation"
      Dovetail.Direction1 = 270.0
      Dovetail.Direction2 = 180.0
      Dovetail.Direction3 = 90.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = 1.0
    else -- Dovetail.Orantation == "H"
      Dovetail.OrantationX = "X Orantation"
      Dovetail.Direction1 = 180.0
      Dovetail.Direction2 = 270.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 90.0
      Dovetail.Bulge = -1.0
    end
  elseif xy_origin == MaterialBlock.TLC then
      Dovetail.Origin = "Top Left Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.OrantationX = "Y Orantation"
      Dovetail.Direction1 = 270.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 90.0
      Dovetail.Direction4 = 180.0
      Dovetail.Bulge = -1.0
    else -- Dovetail.Orantation == "H"
      Dovetail.OrantationX = "X Orantation"
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 270.0
      Dovetail.Direction3 = 180.0
      Dovetail.Direction4 = 90.0
      Dovetail.Bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
      Dovetail.Origin = "Center"
      myreturn = false
    if Dovetail.Orantation == "V" then
      Dovetail.OrantationX = "Error"
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = 1.0
    else
      Dovetail.OrantationX = "Error"
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = -1.0
    end
      MessageBox("Error! " .. Dovetail.Origin .. " Must be set at a corner of the Material")
  else
      Dovetail.Origin = "Unknown XY origin value!"
      myreturn = false
      MessageBox("Error! " .. Dovetail.Origin .. " Must be set at a corner of the Material")
    if Dovetail.Orantation == "V" then
      Dovetail.OrantationX = "Error"
      Dovetail.Direction1 = 0
      Dovetail.Direction2 = 0
      Dovetail.Direction3 = 0
      Dovetail.Direction4 = 0
    else
      Dovetail.OrantationX = "Error"
      Dovetail.Direction1 = 0
      Dovetail.Direction2 = 0
      Dovetail.Direction3 = 0
      Dovetail.Direction4 = 0
    end
  end
	return myreturn
end -- function end
-- ===================================================]]
function RegistryBitRead(item)                          -- Read from Registry values
  local RegistryRead  = Registry(Dovetail.RegBitName)
  Dovetail.BitName    = RegistryRead:GetString("Bit" .. tostring(item) .. "-BitName", "Amana Tool 45804 Carbide Tipped Dovetail 14 Deg x 0.5 D x 0.5 CH x 0.25 SHK")
  Dovetail.Brand      = RegistryRead:GetString("Bit" .. tostring(item) .. "-Brand", "Amana Tool")
  Dovetail.PartNo     = RegistryRead:GetString("Bit" .. tostring(item) .. "-PartNo" , "45804")
  Dovetail.DovetailToolAngle   = RegistryRead:GetDouble("Bit" .. tostring(item) .. "-BitAngle", 14.0)
  Dovetail.ShankDia   = RegistryRead:GetDouble("Bit" .. tostring(item) .. "-ShankDia", 0.250)
  Dovetail.DovetailToolDia     = RegistryRead:GetDouble("Bit" .. tostring(item) .. "-BitDia" , 0.500)
  Dovetail.Flutes     = RegistryRead:GetInt("Bit"    .. tostring(item) .. "-Flutes" , 2)
  Dovetail.Type       = RegistryRead:GetString("Bit" .. tostring(item) .. "-Type"  , "Carbide Tipped")
  Dovetail.BitLength  = RegistryRead:GetDouble("Bit" .. tostring(item) .. "-BitLength", 1.7500)
  Dovetail.CutDepth   = RegistryRead:GetDouble("Bit" .. tostring(item) .. "-CutDepth" , 0.5000)
  Dovetail.RPM        = RegistryRead:GetInt("Bit"    .. tostring(item) .. "-RPM" , 18000)
  Dovetail.FeedRate   = RegistryRead:GetInt("Bit"    .. tostring(item) .. "-FeedRate" , 24)
  Dovetail.PlungRate  = RegistryRead:GetInt("Bit"    .. tostring(item) .. "-PlungRate"  , 12)
  Dovetail.Units      = RegistryRead:GetString("Bit" .. tostring(item) .. "-Units" , "inch")
  Dovetail.Rates      = RegistryRead:GetString("Bit" .. tostring(item) .. "-Rates"  , "inches/min")
  Dovetail.Notes      = RegistryRead:GetString("Bit" .. tostring(item) .. "-Notes" , "Test 1")
  return true
end
-- ===================================================]]
function RegistryRead()                                 -- Read from Registry values
  local RegistryRead = Registry(Dovetail.RegName)
  Dovetail.TailFitAdjustment     = RegistryRead:GetDouble("Dovetail.TailFitAdjustment",     0.010)
  Dovetail.PinFitAdjustment      = RegistryRead:GetDouble("Dovetail.PinFitAdjustment",      0.00)
  Dovetail.TailCount             = RegistryRead:GetInt("Dovetail.TailCount",                2)
  Dovetail.LayerNameFrontBroad   = RegistryRead:GetString("Dovetail.LayerNameFrontBroad",   "Front - Broad")
  Dovetail.LayerNameSideBroad    = RegistryRead:GetString("Dovetail.LayerNameSideBroad",    "Side - Broad")
  Dovetail.LayerNameFrontPocket  = RegistryRead:GetString("Dovetail.LayerNameFrontPocket",  "Front - Pockets")
  Dovetail.LayerNameDovetailPath = RegistryRead:GetString("Dovetail.LayerNameDovetailPath", "Side - Tail Dovetail Path")
  Dovetail.LayerNameClearing     = RegistryRead:GetString("Dovetail.LayerNameClearing",     "Side - Tail Clearing")
  Dovetail.CodeBy                = RegistryRead:GetString("Dovetail.CodeBy",                "JimAndi Gadgets")
  Dovetail.ProgramName           = RegistryRead:GetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
  Dovetail.AboutDovetailXY       = RegistryRead:GetString("Dovetail.AboutDovetailXY",       " x ")
  Dovetail.InquiryDovetailXY     = RegistryRead:GetString("Dovetail.InquiryDovetailXY",     " x ")
  Dovetail.InquiryLayerXY        = RegistryRead:GetString("Dovetail.InquiryLayerXY",        " x ")
  Dovetail.Version               = RegistryRead:GetString("Dovetail.Version",               "5.5")
  Dovetail.ProgramYear           = RegistryRead:GetString("Dovetail.ProgramYear",           "2020")
  Dovetail.ToolPathPins          = RegistryRead:GetString("Dovetail.ToolPathPins",          "Pins")
  Dovetail.ToolPathTail          = RegistryRead:GetString("Dovetail.ToolPathTail",          "Tails")
  Dovetail.ToolPathClearing      = RegistryRead:GetString("Dovetail.ToolPathClearing",      "Tail_Clearing")
  Dovetail.Units                 = RegistryRead:GetString("Dovetail.Units",                 "inch")
  Dovetail.StrightToolRates      = RegistryRead:GetString("Dovetail.StrightToolRates",      "inches/min")
  Dovetail.StrightToolDia        = RegistryRead:GetDouble("Dovetail.ToolDia",               0.2500)
  Dovetail.StrightToolUnits      = RegistryRead:GetString("Dovetail.StrightToolUnits",      "inch")
  Dovetail.StrightToolRPM        = RegistryRead:GetInt("Dovetail.StrightToolRPM",           20000)
  Dovetail.StrightToolFeedRate   = RegistryRead:GetDouble("Dovetail.StrightToolFeedRate",   50)
  Dovetail.StrightToolPlungRate  = RegistryRead:GetDouble("Dovetail.StrightToolPlungRate",  20)
  Dovetail.FrontThickness        = RegistryRead:GetDouble("Dovetail.FrontThickness",        0.75)
  Dovetail.SideThickness         = RegistryRead:GetDouble("Dovetail.SideThickness",         0.75)
  Dovetail.FrontBackerThickness  = RegistryRead:GetDouble("Dovetail.FrontBackerThickness",  0.0)
  Dovetail.BackBackerThickness   = RegistryRead:GetDouble("Dovetail.BackBackerThickness",   0.0)
  return true
end
-- ===================================================]]
function RegistryWrite()                                -- Write to Registry values
  local RegistryWrite = Registry(Dovetail.RegName)
  local RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontBroad",   Dovetail.LayerNameFrontBroad)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSideBroad",    Dovetail.LayerNameSideBroad)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameDovetailPath", Dovetail.LayerNameDovetailPath)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameClearing",     Dovetail.LayerNameClearing)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontPocket",  Dovetail.LayerNameFrontPocket)
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathPins",          Dovetail.ToolPathPins)
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathTail",          Dovetail.ToolPathTail)
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathClearing",      Dovetail.ToolPathClearing)
        RegValue = RegistryWrite:SetString("Dovetail.AboutDovetailXY",       Dovetail.AboutDovetailXY)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryDovetailXY",     Dovetail.InquiryDovetailXY)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryLayerXY",        Dovetail.InquiryLayerXY)
        RegValue = RegistryWrite:SetString("Dovetail.CodeBy",                "JimAndi Gadgets")
        RegValue = RegistryWrite:SetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
        RegValue = RegistryWrite:SetString("Dovetail.Version",               Dovetail.Version)
        RegValue = RegistryWrite:SetString("Dovetail.ProgramYear",           "2020")
        RegValue = RegistryWrite:SetString("Dovetail.Units",                 Dovetail.Units)
        RegValue = RegistryWrite:SetDouble("Dovetail.TailFitAdjustment",     Dovetail.TailFitAdjustment)
        RegValue = RegistryWrite:SetDouble("Dovetail.PinFitAdjustment",      Dovetail.PinFitAdjustment)
        RegValue = RegistryWrite:SetInt("Dovetail.TailCount",                Dovetail.TailCount)
        RegValue = RegistryWrite:SetString("Dovetail.StrightToolUnits",      Dovetail.StrightToolUnits)
        RegValue = RegistryWrite:SetDouble("Dovetail.StrightToolDia",        Dovetail.StrightToolDia)
        RegValue = RegistryWrite:SetInt("Dovetail.StrightToolRPM",           Dovetail.StrightToolRPM)
        RegValue = RegistryWrite:SetDouble("Dovetail.StrightToolFeedRate",   Dovetail.StrightToolFeedRate)
        RegValue = RegistryWrite:SetDouble("Dovetail.StrightToolPlungRate",  Dovetail.StrightToolPlungRate)
        RegValue = RegistryWrite:SetString("Dovetail.StrightToolRates",      Dovetail.StrightToolRates)
        RegValue = RegistryWrite:SetDouble("Dovetail.FrontThickness",        Dovetail.FrontThickness)
        RegValue = RegistryWrite:SetDouble("Dovetail.SideThickness",         Dovetail.SideThickness)
        RegValue = RegistryWrite:SetDouble("Dovetail.FrontBackerThickness",  Dovetail.FrontBackerThickness)
        RegValue = RegistryWrite:SetDouble("Dovetail.BackBackerThickness",   Dovetail.BackBackerThickness)
 	return true
end
-- ===================================================]]
function Polar2D(pt, ang, dis)                          -- Provides a new point from a point, angle and distance
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end-- function end
-- ===================================================]]
function Rounder(num, idp)                              -- Reduce the size of the fraction to idp places
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
-- ===================================================]]
function InquiryDovetail()
  local MyReturn = false
  if Dovetail.AppValue then
    Dovetail.dialog = HTML_Dialog(true, DialogWindow.myHtml1, 587, 707, "Easy Dovetail Maker")
  else
    Dovetail.dialog = HTML_Dialog(true, DialogWindow.myHtml1, 587, 747, "Easy Dovetail Maker")
  end
  Dovetail.dialog:AddLabelField("Dovetail.Alert",                 "")
  Dovetail.dialog:AddLabelField("Dovetail.PinNote",     	        "Dovetail Size = " )
  Dovetail.dialog:AddLabelField("Dovetail.TailNote",        	    "Dovetail Centers = ")
  Dovetail.dialog:AddLabelField("Dovetail.AppName", 	            Dovetail.AppName)
  Dovetail.dialog:AddLabelField("Dovetail.Version",     	        "Version: " ..  Dovetail.Version )
  Dovetail.dialog:AddLabelField("Dovetail.Units",          	      Dovetail.Units)
  Dovetail.dialog:AddLabelField("Dovetail.Tail",             	    "Tail Size")
  Dovetail.dialog:AddDoubleField("Dovetail.TailValue", 	       	  Dovetail.DovetailCenters)
  Dovetail.dialog:AddDoubleField("Dovetail.TailFitAdjustment", 	  Dovetail.TailFitAdjustment)
  Dovetail.dialog:AddDoubleField("Dovetail.PinFitAdjustment", 	  Dovetail.PinFitAdjustment)
  Dovetail.dialog:AddIntegerField("Dovetail.TailCount",           Dovetail.TailCount)
  Dovetail.dialog:AddDoubleField("Dovetail.FrontThickness",       Dovetail.FrontThickness)
  Dovetail.dialog:AddDoubleField("Dovetail.SideThickness",        Dovetail.SideThickness)
  Dovetail.dialog:AddDoubleField("Dovetail.FrontBackerThickness", Dovetail.FrontBackerThickness)
  Dovetail.dialog:AddDoubleField("Dovetail.BackBackerThickness",  Dovetail.BackBackerThickness)

  if Dovetail.AppValue then
    Dovetail.dialog:AddLabelField("ToolNameLabel",            "Not Selected")
    Dovetail.dialog:AddToolPicker("ToolChooseButton",         "ToolNameLabel", Tool_ID)
    Dovetail.dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
  else
    Dovetail.dialog:AddDoubleField("Dovetail.StrightToolDia",        Dovetail.StrightToolDia)
    Dovetail.dialog:AddIntegerField("Dovetail.StrightToolRPM",       Dovetail.StrightToolRPM)
    Dovetail.dialog:AddDoubleField("Dovetail.StrightToolFeedRate",   Dovetail.StrightToolFeedRate)
    Dovetail.dialog:AddDoubleField("Dovetail.StrightToolPlungRate",  Dovetail.StrightToolPlungRate)
    Dovetail.dialog:AddDropDownList("UnitList",                      Dovetail.StrightToolUnits)
    Dovetail.dialog:AddDropDownList("RateList",                      Dovetail.StrightToolRates)
  end -- if end
  Dovetail.dialog:AddDropDownList("ListBox", Dovetail.DovetailSelectedTool) ;
  for _, value in pairs(Tools) do
    Dovetail.dialog:AddDropDownListValue("ListBox", value) ;
  end ;
  if  Dovetail.dialog:ShowDialog() then
    Dovetail.InquiryDovetailXY = tostring(Dovetail.dialog.WindowWidth) .. " x " .. tostring(Dovetail.dialog.WindowHeight)

    MyReturn = true
  end
  return MyReturn
end
-- ===================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml5, 718, 485, "About")
  dialog:AddLabelField("SysName", Dovetail.ProgramName)
  dialog:AddLabelField("Version", "Version: " .. Dovetail.Version)
  dialog:ShowDialog()
  Dovetail.AboutDovetailXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  return  true
end
-- ===================================================]]
function Dovetail_Math()                                -- All the math for Dovetail for Count
  Dovetail.DovetailToolRadius = Dovetail.DovetailToolDia * 0.500
  Dovetail.StrightToolRadius  = Dovetail.StrightToolDia  * 0.500
  -- Smallest Clearing Amount for Bit
  Dovetail.PathCount = 0.0
  Dovetail.ClearingLength = Dovetail.FrontThickness + (2.0 *  Dovetail.StrightToolDia)
  if Dovetail.Orantation == "H" then
    Dovetail.g_pt1 = Point2D(0, 0)
    Dovetail.g_pt2 = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.MaterialLength)
    Dovetail.g_pt3 = Polar2D(Dovetail.g_pt2, Dovetail.Direction2, Dovetail.MaterialThickness)
    Dovetail.g_pt4 = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.MaterialThickness)
  else -- Dovetail.Orantation == "V"
    Dovetail.g_pt1 = Point2D(0, 0)
    Dovetail.g_pt2 = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.MaterialLength)
    Dovetail.g_pt3 = Polar2D(Dovetail.g_pt2, Dovetail.Direction2, Dovetail.MaterialThickness)
    Dovetail.g_pt4 = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.MaterialThickness)
  end
  if  Dovetail.Origin == "Bottom Left Corner" then
    if Dovetail.Orantation == "V" then
      Dovetail.Mider1 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
    else -- Dovetail.Orantation == "H"
      Dovetail.Mider1 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
    end
  elseif Dovetail.Origin == "Bottom Right Corner" then
    if Dovetail.Orantation == "V" then
      Dovetail.Mider1 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
      Dovetail.Direction4 = 0.0
    else -- Dovetail.Orantation == "H"
      Dovetail.Mider1 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
    end
  elseif Dovetail.Origin == "Top Right Corner" then
    if Dovetail.Orantation == "V" then
      Dovetail.Mider1 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
    else -- Dovetail.Orantation == "H"
      Dovetail.Mider1 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
    end
  elseif Dovetail.Origin == "Top Left Corner" then
    if Dovetail.Orantation == "V" then
      Dovetail.Mider1 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
    else -- Dovetail.Orantation == "H"
      Dovetail.Mider1 =  Dovetail.Direction2 - Dovetail.DovetailToolAngle
      Dovetail.Mider2 =  Dovetail.Direction2 + Dovetail.DovetailToolAngle
      Dovetail.Mider3 =  Dovetail.Direction4 - Dovetail.DovetailToolAngle
      Dovetail.Mider4 =  Dovetail.Direction4 + Dovetail.DovetailToolAngle
    end
  end

  RegistryWrite()
  return true
end
-- ===================================================]]
function Dovetail_MillingPath()                         -- Dovetail.BackBackerThickness Dovetail.FrontBackerThickness
  local A, B, C, D = Point2D(0, 0)
  local MillDepth = Dovetail.SideThickness + Dovetail.DovetailToolDia + Dovetail.BackBackerThickness +  0.125
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameDovetailPath)
  local line = Contour(0.0)
  -- Starting Point
  Dovetail.pt01 = Polar2D(Dovetail.g_pt1, Dovetail.Direction3, Dovetail.DovetailToolRadius + 0.125)
  Dovetail.pt01 = Polar2D(Dovetail.pt01, Dovetail.Direction4, Dovetail.DovetailToolRadius + 0.125)
  -- Ending Point
  Dovetail.pt02 = Polar2D(Dovetail.pt01, Dovetail.Direction4, 0.125)
  -- Startup Path building
  line:AppendPoint(Dovetail.pt01); line:LineTo(Dovetail.pt01)
  Dovetail.ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction4, Dovetail.DovetailToolRadius + 0.125)
  A = Polar2D(Dovetail.ptx, Dovetail.Direction3, Dovetail.MillGap)
  B = Polar2D(A,  Dovetail.Direction2, MillDepth)
  D = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.MillGap)
  C = Polar2D(D,  Dovetail.Direction2, MillDepth)
  line:LineTo(A);  line:LineTo(B);  line:LineTo(C);  line:LineTo(D)
  Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters +  Dovetail.DovetailCenters)
  for _ = Dovetail.PathCount-1 , 1 , -1   do
    A = Polar2D(Dovetail.ptx, Dovetail.Direction3, Dovetail.MillGap)
    B = Polar2D(A,  Dovetail.Direction2, MillDepth)
    D = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.MillGap)
    C = Polar2D(D,  Dovetail.Direction2, MillDepth)
    line:LineTo(A); line:LineTo(B); line:LineTo(C); line:LineTo(D)
    Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters +  Dovetail.DovetailCenters)
  end
  Dovetail.ptx = Polar2D(D, Dovetail.Direction4, 0.125)
  line:LineTo(Dovetail.ptx)
  line:LineTo(Dovetail.pt02)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function Dovetail_MillingPathOld()
  local A, B, C, D = Point2D(0, 0)
  local MillDepth = Dovetail.SideThickness + Dovetail.DovetailToolDia + 0.125
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameDovetailPath)
  local line = Contour(0.0)
  -- Starting Point
  Dovetail.pt01 = Polar2D(Dovetail.g_pt1, Dovetail.Direction3, Dovetail.DovetailToolRadius + 0.125)
  Dovetail.pt01 = Polar2D(Dovetail.pt01, Dovetail.Direction4, Dovetail.DovetailToolRadius + 0.125)
  -- Ending Point
  Dovetail.pt02 = Polar2D(Dovetail.pt01, Dovetail.Direction4, 0.125)
  -- Startup Path building
  line:AppendPoint(Dovetail.pt01); line:LineTo(Dovetail.pt01)
  Dovetail.ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction4, Dovetail.DovetailToolRadius + 0.125)
  A = Polar2D(Dovetail.ptx, Dovetail.Direction3, Dovetail.MillGap)
  B = Polar2D(A,  Dovetail.Direction2, MillDepth)
  D = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.MillGap)
  C = Polar2D(D,  Dovetail.Direction2, MillDepth)
  line:LineTo(A);  line:LineTo(B);  line:LineTo(C);  line:LineTo(D)
  Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters +  Dovetail.DovetailCenters)
  for _ = Dovetail.PathCount-1 , 1 , -1   do
    A = Polar2D(Dovetail.ptx, Dovetail.Direction3, Dovetail.MillGap)
    B = Polar2D(A,  Dovetail.Direction2, MillDepth)
    D = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.MillGap)
    C = Polar2D(D,  Dovetail.Direction2, MillDepth)
    line:LineTo(A); line:LineTo(B); line:LineTo(C); line:LineTo(D)
    Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters +  Dovetail.DovetailCenters)
  end
  Dovetail.ptx = Polar2D(D, Dovetail.Direction4, 0.125)
  line:LineTo(Dovetail.ptx)
  line:LineTo(Dovetail.pt02)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function Dovetail_PinPockets()                          -- Front Right and Left Pin Pockets
  -- Draw the Front Board
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontBroad)
  local xpt2 = Polar2D(Dovetail.g_pt1,  Dovetail.Direction2,  Dovetail.SideThickness)
  local xpt3 = Polar2D(xpt2,  Dovetail.Direction1, Dovetail.MaterialLength)
  local xpt4 = Polar2D(Dovetail.g_pt1,  Dovetail.Direction1,  Dovetail.MaterialLength)
  local line = Contour(0.0)
  line:AppendPoint(Dovetail.g_pt1); line:LineTo(xpt2); line:LineTo(xpt3); line:LineTo(xpt4); line:LineTo(Dovetail.g_pt1)
  layer:AddObject(CreateCadContour(line), true)
  -- Draw Right Hand Pins
  Dovetail.ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.DovetailCenters)
  Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction2, Dovetail.PinFitAdjustment)
  for _ = Dovetail.PathCount - 1, 1 , -1     do
    DovetailPinPocketsRight(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end


-- Draw Left Hand Pins
  Dovetail.ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.DovetailCenters)
  Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction4, Dovetail.PinFitAdjustment)

  for _ = Dovetail.PathCount - 1, 1 , -1     do
    DovetailPinPocketsLeft(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end


  return true
end
-- ===================================================]]
function DovetailPinPocketsRight(xpt1)                  -- Front Borad Lefthand
    local xpt2  = Polar2D(xpt1,   Dovetail.Direction2,  Dovetail.SideThickness)
    local xpt3  = Polar2D(xpt2,   Dovetail.Direction1,  Dovetail.ClearingTopAmount * 0.5)
    local xpt4  = Polar2D(xpt2,   Dovetail.Direction3,  Dovetail.ClearingTopAmount * 0.5)
    local xpt3a = Polar2D(xpt3,   Dovetail.Mider1,  Dovetail.Dist1)
    local xpt4a = Polar2D(xpt4,   Dovetail.Mider2,  Dovetail.Dist1)
    local xpt3b = Polar2D(xpt3a,  Dovetail.Mider3,  Dovetail.Dist2)
    local xpt4b = Polar2D(xpt4a,  Dovetail.Mider4,  Dovetail.Dist2)
    local layera = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontPocket .. "-Lefthand")
    local linea = Contour(0.0)
    linea:AppendPoint(xpt3a); linea:LineTo(xpt3b); linea:LineTo(xpt4b); linea:LineTo(xpt4a); linea:LineTo(xpt3a)
    layera:AddObject(CreateCadContour(linea), true)
  return true
end
-- ===================================================]]
function DovetailPinPocketsLeft(xpt1)                   -- Front Borad Righthand
    local xpt3  = Polar2D(xpt1,   Dovetail.Direction1,  Dovetail.ClearingTopAmount * 0.5)
    local xpt4  = Polar2D(xpt1,   Dovetail.Direction3,  Dovetail.ClearingTopAmount * 0.5)
    local xpt3a = Polar2D(xpt3,   Dovetail.Mider4,  Dovetail.Dist1)
    local xpt4a = Polar2D(xpt4,   Dovetail.Mider3,  Dovetail.Dist1)
    local xpt3b = Polar2D(xpt3a,  Dovetail.Mider2,  Dovetail.Dist2)
    local xpt4b = Polar2D(xpt4a,  Dovetail.Mider1,  Dovetail.Dist2)
    local layera = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontPocket .. "-Righthand")
    local linea = Contour(0.0)
    linea:AppendPoint(xpt3a); linea:LineTo(xpt3b); linea:LineTo(xpt4b); linea:LineTo(xpt4a); linea:LineTo(xpt3a)
    layera:AddObject(CreateCadContour(linea), true)
  return true
end
-- ===================================================]]
function Dovetail_TailClearing()                        -- Side Borad

  -- Dovetail.BackBackerThickness
  local WPX = Point2D(0,0)

  if Dovetail.BackBackerThickness > 0.0 then
    local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad .. " Back-Backer")
    local xpt2 = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.BackBackerThickness)
    local xpt3 = Polar2D(xpt2, Dovetail.Direction1, Dovetail.MaterialLength)
    local xpt4 = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.MaterialLength)
    local line = Contour(0.0); line:AppendPoint(Dovetail.g_pt1); line:LineTo(xpt2); line:LineTo(xpt3); line:LineTo(xpt4)
    line:LineTo(Dovetail.g_pt1);  layer:AddObject(CreateCadContour(line), true)
    WPX = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.BackBackerThickness)
  end

  local layer1 = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad)
  local xpt21  = Polar2D(WPX, Dovetail.Direction2, Dovetail.FrontThickness)
  local xpt31  = Polar2D(xpt21, Dovetail.Direction1, Dovetail.MaterialLength)
  local xpt41  = Polar2D(WPX, Dovetail.Direction1, Dovetail.MaterialLength)
  -- Side Board
  local line1 = Contour(0.0); line1:AppendPoint(WPX); line1:LineTo(xpt21); line1:LineTo(xpt31); line1:LineTo(xpt41) line1:LineTo(WPX)
        layer1:AddObject(CreateCadContour(line1), true)
     WPX = Polar2D(WPX, Dovetail.Direction2, Dovetail.FrontThickness)

  if Dovetail.FrontBackerThickness > 0.0 then
    local layer2 = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad .. " Front-Backer")
    local xpt22 = Polar2D(WPX, Dovetail.Direction2, Dovetail.BackBackerThickness)
    local xpt32 = Polar2D(xpt22, Dovetail.Direction1, Dovetail.MaterialLength)
    local xpt42 = Polar2D(WPX, Dovetail.Direction1, Dovetail.MaterialLength)
    local line2 = Contour(0.0); line2:AppendPoint(WPX); line2:LineTo(xpt22); line2:LineTo(xpt32); line2:LineTo(xpt42)
    line2:LineTo(WPX);  layer2:AddObject(CreateCadContour(line2), true)
  end
  local ptx = Point2D(0.0,0.0)
  local tx = Dovetail.MaterialLength
  for _ = Dovetail.TailCount , 0 , -1   do
    DovetailClearing(ptx)
    ptx = Polar2D(ptx, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters )
    tx = tx - (Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
  return true
end
-- ===================================================]]
function DovetailClearing(pt1)                          -- Side Borad
    Dovetail.PathCount = Dovetail.PathCount + 1
    local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameClearing)
    local line  = Contour(0.0)
    -- if Dovetail.OrantationX == "Y" then
    local pt2   = Polar2D(pt1, Dovetail.Direction2, Dovetail.SideThickness + (Dovetail.FrontBackerThickness * 0.5) + Dovetail.BackBackerThickness)
    local pt01  = Polar2D(Polar2D(pt1, Dovetail.Direction1, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction4, Dovetail.StrightToolDia)
    local pt04  = Polar2D(Polar2D(pt1, Dovetail.Direction3, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction4, Dovetail.StrightToolDia)
    local pt02  = Polar2D(Polar2D(pt2, Dovetail.Direction1, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction2, Dovetail.StrightToolDia)
    local pt03  = Polar2D(Polar2D(pt2, Dovetail.Direction3, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction2, Dovetail.StrightToolDia)
    line:AppendPoint(pt01); line:LineTo(pt02); line:LineTo(pt03); line:LineTo(pt04); line:LineTo(pt01); layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function Dovetail_TailClearingOld()                     -- Side Borad
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad)
  local xpt2 = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.FrontThickness)
  local xpt3 = Polar2D(xpt2, Dovetail.Direction1, Dovetail.MaterialLength)
  local xpt4 = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.MaterialLength)
  local line = Contour(0.0); line:AppendPoint(Dovetail.g_pt1); line:LineTo(xpt2); line:LineTo(xpt3); line:LineTo(xpt4)
  line:LineTo(Dovetail.g_pt1);  layer:AddObject(CreateCadContour(line), true)
  local ptx = Point2D(0.0,0.0)
  local tx = Dovetail.MaterialLength
  for _ = Dovetail.TailCount , 0 , -1   do
    DovetailClearing(ptx)
    ptx = Polar2D(ptx, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters )
    tx = tx - (Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
  return true
end
-- ===================================================]]
function DovetailClearingOld(pt1)                       -- Side Borad
    Dovetail.PathCount = Dovetail.PathCount + 1
    local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameClearing)
    local line  = Contour(0.0)
    -- if Dovetail.OrantationX == "Y" then
    local pt2   = Polar2D(pt1, Dovetail.Direction2, Dovetail.SideThickness)
    local pt01  = Polar2D(Polar2D(pt1, Dovetail.Direction1, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction4, Dovetail.StrightToolDia)
    local pt04  = Polar2D(Polar2D(pt1, Dovetail.Direction3, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction4, Dovetail.StrightToolDia)
    local pt02  = Polar2D(Polar2D(pt2, Dovetail.Direction1, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction2, Dovetail.StrightToolDia)
    local pt03  = Polar2D(Polar2D(pt2, Dovetail.Direction3, (Dovetail.ClearingTopAmount * 0.5)), Dovetail.Direction2, Dovetail.StrightToolDia)
    line:AppendPoint(pt01); line:LineTo(pt02); line:LineTo(pt03); line:LineTo(pt04); line:LineTo(pt01); layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function StrIniValue(str, ty)
    if nil == str then
        DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
    else
        if "" == All_Trim(str) then
            DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
        else
            local j = (string.find(str, "=") + 1)
            if ty == "N" then
                return tonumber(string.sub(str, j))
            end -- if end
            if ty == "S" then
                return All_Trim(string.sub(str, j))
            end -- if end
            if ty == "B" then
                if "TRUE" == All_Trim(string.upper(string.sub(str, j))) then
                    return true
                else
                    return false
                end -- if end
            end -- if end
        end -- if end
    end -- if end
    return nil
  end -- function end
-- ===================================================]]
function All_Trim(s)                                    -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function OnLuaButton_ButtonCalulate()                   -- Executes the Validation and some calculations from the dialogue
  Dovetail.TailFitAdjustment    = Dovetail.dialog:GetDoubleField("Dovetail.TailFitAdjustment")
  Dovetail.PinFitAdjustment     = Dovetail.dialog:GetDoubleField("Dovetail.PinFitAdjustment")
  Dovetail.FrontThickness       = Dovetail.dialog:GetDoubleField("Dovetail.FrontThickness")
  Dovetail.SideThickness        = Dovetail.dialog:GetDoubleField("Dovetail.SideThickness")
  Dovetail.FrontBackerThickness = Dovetail.dialog:GetDoubleField("Dovetail.FrontBackerThickness")
  Dovetail.BackBackerThickness  = Dovetail.dialog:GetDoubleField("Dovetail.BackBackerThickness")
  Dovetail.TailFitAdjustment    = Dovetail.dialog:GetDoubleField("Dovetail.TailFitAdjustment")
  Dovetail.TailCount            = math.floor(Dovetail.dialog:GetIntegerField("Dovetail.TailCount"))
  Dovetail.PinCount             = Dovetail.TailCount
  Dovetail.DovetailCount        = Dovetail.TailCount + Dovetail.TailCount
  Dovetail.TailSize             = Dovetail.MaterialLength / Dovetail.DovetailCount
  Dovetail.dialog:UpdateLabelField("Dovetail.Tail", "Tail Size")
  -- ===================
  if Dovetail.AppValue then
    -- Version 10 or Higher
    Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
    Dovetail.DovetailBitName = Dovetail.dialog:GetDropDownListValue("ListBox")
    if Dovetail.DovetailBitName == "" then
      Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Select Dovetail Tool")
      Dovetail.MillingApproved = false
    else
      Dovetail.StrightTool  = Dovetail.dialog:GetTool("ToolChooseButton")
      if Dovetail.StrightTool == nil then
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Aleart: Select End Mill")
          Dovetail.MillingApproved = false
        else
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
          RegistryBitRead(BitReaders(string.upper(Dovetail.DovetailBitName)))
          Dovetail.StrightToolDia  = Dovetail.StrightTool.ToolDia
          Dovetail.Dist1 = Dovetail.StrightToolDia / math.cos(math.rad(Dovetail.DovetailToolAngle ))
          Dovetail.Dist2 = (Dovetail.FrontThickness+(Dovetail.StrightToolDia * 2)) / math.cos(math.rad(Dovetail.DovetailToolAngle ))
          if Dovetail.CutDepth < Dovetail.FrontThickness then
            Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Dovetail Cutdepth is less than Front Thickness")
            Dovetail.MillingApproved = false
          else
            if Dovetail.TailCount < 1 then
              Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Finger Count cannot be less than 1")
              Dovetail.MillingApproved = false
            else
              Dovetail.DoveBitOverCut       = Dovetail.FrontThickness * math.tan(math.rad(Dovetail.DovetailToolAngle))
              Dovetail.ClearingTopAmount    = (Dovetail.MaterialLength / (Dovetail.DovetailCount)) - Dovetail.DoveBitOverCut
              Dovetail.MinClearingWidth     = Dovetail.DovetailToolDia - (2 *  Dovetail.FrontThickness * math.tan(math.rad(Dovetail.DovetailToolAngle)))
              Dovetail.ClearingBottomLength = Dovetail.MaterialLength  / ((Dovetail.DovetailCount + 1) - math.tan(math.rad(Dovetail.DovetailToolAngle)))
              Dovetail.MillGap              = (0.5 *  (Dovetail.TailFitAdjustment + (Dovetail.ClearingTopAmount - Dovetail.MinClearingWidth)))
              if Dovetail.ClearingTopAmount < Dovetail.StrightToolDia then
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Stright Bit Size")
                  Dovetail.MillingApproved = false
              else
                if Dovetail.MinClearingWidth > Dovetail.ClearingTopAmount then
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Tail Count or Dovetail Bit Size")
                  Dovetail.MillingApproved = false
                else
                  Dovetail.DovetailCenters = Rounder(Dovetail.MaterialLength / Dovetail.DovetailCount, 4)
                  Dovetail.PinStart        =  Dovetail.DovetailCenters * 0.5
                  Dovetail.MillingApproved = true
                  Dovetail.dialog:UpdateDoubleField("Dovetail.TailValue", Dovetail.DovetailCenters)
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
                  Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "Dovetail Center = " .. Rounder(Dovetail.DovetailCenters * 2.0, 4))
                  Dovetail.dialog:UpdateLabelField("Dovetail.PinNote",  "Dovetail Top = "    .. Rounder(Dovetail.ClearingTopAmount + (Dovetail.DoveBitOverCut * 2), 4) .. "...")
                end -- if end min clear fault
              end -- if end stright bit dia fault
            end -- if end fingers less than 1
          end -- Bit too short
        end -- if end no end mill
    end -- if end no dovetail bit
else -- else if Version is Lower than Version 10
    Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
    Dovetail.DovetailBitName = Dovetail.dialog:GetDropDownListValue("ListBox")
    Dovetail.StrightToolRPM             = Dovetail.dialog:GetIntegerField("Dovetail.StrightToolRPM")
    Dovetail.StrightToolFeedRate        = Dovetail.dialog:GetDoubleField("Dovetail.StrightToolFeedRate")
    Dovetail.StrightToolPlungRate       = Dovetail.dialog:GetDoubleField("Dovetail.StrightToolPlungRate")
    Dovetail.StrightToolBitUnits        = Dovetail.dialog:GetDropDownListValue("UnitList")
    Dovetail.StrightToolRates           = Dovetail.dialog:GetDropDownListValue("RateList")
    Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
    if Dovetail.DovetailBitName == "" then
      Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Select Dovetail Tool")
      Dovetail.MillingApproved = false
    else
      Dovetail.StrightToolDia  = Dovetail.dialog:GetDoubleField("Dovetail.StrightToolDia")
      if Dovetail.StrightToolDia == nil then
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Aleart: Select End Mill")
          Dovetail.MillingApproved = false
        else
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
          RegistryBitRead(BitReaders(string.upper(Dovetail.DovetailBitName)))
          Dovetail.Dist1 = Dovetail.StrightToolDia / math.cos(math.rad(Dovetail.DovetailToolAngle ))
          Dovetail.Dist2 = (Dovetail.FrontThickness+(Dovetail.StrightToolDia * 2)) / math.cos(math.rad(Dovetail.DovetailToolAngle ))
          if Dovetail.CutDepth < Dovetail.FrontThickness then
            Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Dovetail Cutdepth is less than Front Thickness")
            Dovetail.MillingApproved = false
          else
            if Dovetail.TailCount < 1 then
              Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Finger Count cannot be less than 1")
              Dovetail.MillingApproved = false
            else
              Dovetail.DoveBitOverCut       = Dovetail.FrontThickness * math.tan(math.rad(Dovetail.DovetailToolAngle))
              Dovetail.ClearingTopAmount    = (Dovetail.MaterialLength / (Dovetail.DovetailCount)) - Dovetail.DoveBitOverCut
              Dovetail.MinClearingWidth     = Dovetail.DovetailToolDia - (2 *  Dovetail.FrontThickness * math.tan(math.rad(Dovetail.DovetailToolAngle)))
              Dovetail.ClearingBottomLength = Dovetail.MaterialLength  / ((Dovetail.DovetailCount + 1) - math.tan(math.rad(Dovetail.DovetailToolAngle)))
              Dovetail.MillGap              = (0.5 *  (Dovetail.TailFitAdjustment + (Dovetail.ClearingTopAmount - Dovetail.MinClearingWidth)))
              if Dovetail.ClearingTopAmount < Dovetail.StrightToolDia then
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Stright Bit Size")
                  Dovetail.MillingApproved = false
              else
                if Dovetail.MinClearingWidth > Dovetail.ClearingTopAmount then
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Tail Count or Dovetail Bit Size")
                  Dovetail.MillingApproved = false
                else
                  Dovetail.DovetailCenters = Rounder(Dovetail.MaterialLength / Dovetail.DovetailCount, 4)
                  Dovetail.PinStart        =  Dovetail.DovetailCenters * 0.5
                  Dovetail.MillingApproved = true
                  Dovetail.dialog:UpdateDoubleField("Dovetail.TailValue", Dovetail.DovetailCenters)
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
                  Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "Dovetail Center = " .. Rounder(Dovetail.DovetailCenters * 2.0, 4))
                  Dovetail.dialog:UpdateLabelField("Dovetail.PinNote",  "Dovetail Top = "    .. Rounder(Dovetail.ClearingTopAmount + (Dovetail.DoveBitOverCut * 2), 4) .. "...")

                end -- if end min clear fault
              end -- if end stright bit dia fault
            end -- if end fingers less than 1
          end -- Bit too short
        end -- if end no end mill
    end -- if end no dovetail bit
  end -- if end4
  return true
end
-- ===================================================]]
function OnLuaButton_InquiryLayers()
    local dialog = HTML_Dialog(true, DialogWindow.myHtml3, 587, 377, "Layer Setup") ;
    dialog:AddTextField("Dovetail.LayerNameClearing",     Dovetail.LayerNameClearing)
    dialog:AddTextField("Dovetail.LayerNameSideBroad",    Dovetail.LayerNameSideBroad)
    dialog:AddTextField("Dovetail.LayerNameFrontPocket",  Dovetail.LayerNameFrontPocket)
    dialog:AddTextField("Dovetail.LayerNameDovetailPath", Dovetail.LayerNameDovetailPath)
    dialog:AddTextField("Dovetail.LayerNameFrontBroad",   Dovetail.LayerNameFrontBroad)
    dialog:AddTextField("Dovetail.ToolPathPins",          Dovetail.ToolPathPins)
    dialog:AddTextField("Dovetail.ToolPathTail",          Dovetail.ToolPathTail)
    dialog:AddTextField("Dovetail.ToolPathClearing",      Dovetail.ToolPathClearing)
    if  dialog:ShowDialog() then
        Dovetail.LayerNameClearing     = dialog:GetTextField("Dovetail.LayerNameClearing")
        Dovetail.LayerNameFrontPocket  = dialog:GetTextField("Dovetail.LayerNameFrontPocket")
        Dovetail.LayerNameSideBroad    = dialog:GetTextField("Dovetail.LayerNameSideBroad")
        Dovetail.LayerNameDovetailPath = dialog:GetTextField("Dovetail.LayerNameDovetailPath")
        Dovetail.LayerNameFrontBroad   = dialog:GetTextField("Dovetail.LayerNameFrontBroad")
        Dovetail.ToolPathPins          = dialog:GetTextField("Dovetail.ToolPathPins")
        Dovetail.ToolPathTail          = dialog:GetTextField("Dovetail.ToolPathTail")
        Dovetail.ToolPathClearing      = dialog:GetTextField("Dovetail.ToolPathClearing")
        Dovetail.InquiryLayerXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
        RegistryWrite()
      end
    return  true
end
-- ===================================================]]
function main(script_path)                              -- Main Function (script_path)
  Dovetail.AppName = "Easy Dovetail Maker"
  Dovetail.AppNameReg = "EasyDovetailMaker"
  Dovetail.Version = "5.5"
  Dovetail.MillingApproved = false
  Dovetail.DovetailCenters = 0.0
  Dovetail.InquiryDovetailX = "0"
  Dovetail.InquiryDovetailY = "0"
  Dovetail.RegName = Dovetail.AppNameReg .. Dovetail.Version
  Dovetail.RegBitName = "EasyDovetailToolDatabase2.5"
  Dovetail.TailCalc = "Tail Count"
  Dovetail.job = VectricJob()                             -- Get the currect Job ID
  if not Dovetail.job.Exists then                         -- Validate the user has setup a Job
        DisplayMessageBox("Error: The Gadget cannot proceed without a job setup.\n" ..
                          "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                          "specify the material dimensions")
    return false;
  end
  HTML()
  if GetMaterialSettings() then                           -- Read the Material Configuration and set global setting
    Dovetail.ToolPath = script_path                       -- Validate the user has setup a Job
    RegistryRead()                                        -- Read the registry for last use values
    BitHeaderReader()                                     -- Read the Dovetail Tool List
    if InquiryDovetail("Easy Dovetail Maker") then        -- Show the the main dialog
      if Dovetail.MillingApproved then                    -- Proceed if user pressed OK
        Dovetail_Math()                                   -- Do the Math
        Dovetail_TailClearing()                           -- Draw Side Clearing Path
        Dovetail_PinPockets()                             -- Draw Right and Left Front Pins
        Dovetail_MillingPath()                            -- DDraw the Dovetail Bit paths
     if Dovetail.AppValue then
          CreatePocketToolpath1(Dovetail.LayerNameFrontPocket .. "-Lefthand",  Dovetail.ToolPathPins .. "-Lefthand")
          CreatePocketToolpath1(Dovetail.LayerNameFrontPocket .. "-Righthand",   Dovetail.ToolPathPins .. "-Righthand")
          CreatePocketToolpath1(Dovetail.LayerNameClearing,     Dovetail.ToolPathClearing)
          CreateProfileToolpath(Dovetail.LayerNameDovetailPath, Dovetail.ToolPathTail, Dovetail.FrontThickness, "ON", false)
        else
          CreatePocketToolpath2(Dovetail.LayerNameFrontPocket .. "-Lefthand",  Dovetail.ToolPathPins .. "-Lefthand")
          CreatePocketToolpath2(Dovetail.LayerNameFrontPocket .. "-Righthand",   Dovetail.ToolPathPins .. "-Righthand")
          CreatePocketToolpath2(Dovetail.LayerNameClearing,     Dovetail.ToolPathClearing)
          CreateProfileToolpath(Dovetail.LayerNameDovetailPath, Dovetail.ToolPathTail, Dovetail.FrontThickness, "ON", false)
        end
      end
    end-- if end MillingApproved
  end -- if end GetMaterialSettings
-- ====================]]
  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function pad(s)                                         -- returns a string with leading zeros
  local x = tostring(s)
  if #x == 1 then
    x="00" .. x
  elseif #x == 2 then
    x="0" .. x
  end
  return x
end
-- ===================================================]]
function BitHeaderReader()
  local RegistryRead = Registry(Dovetail.RegBitName)
  Dovetail.HeaderCount = 0
  while(RegistryRead:StringExists("Bit" .. pad(Dovetail.HeaderCount + 1) .. "-BitName")) do
    table.insert(Tools, RegistryRead:GetString("Bit" .. pad(Dovetail.HeaderCount + 1) .. "-BitName", "Error: No Bits Found in Registry"))
    Dovetail.HeaderCount = Dovetail.HeaderCount + 1
  end
  return true
end
-- ===================================================]]
function BitReaders(str)
  local RegistryRead = Registry(Dovetail.RegBitName)
  Dovetail.Count = Dovetail.HeaderCount
  while(not(Dovetail.Count == 0)) do
    if string.upper(RegistryRead:GetString("Bit" .. tostring(Dovetail.Count) .. "-BitName", "X")) == str then
      break
    end
    Dovetail.Count = Dovetail.Count - 1
  end
  return Dovetail.Count
end
-- ===================================================]]
function CreatePocketToolpath1(layer_name, toolpath_name) -- Front Borad
  local selection = Dovetail.job.Selection
  selection:Clear()
  local layer = Dovetail.job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
  local pocket_data                 = PocketParameterData()
        pocket_data.StartDepth      = 0
        pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
        pocket_data.CutDirection    = ProfileParameterData.CLIMB_DIRECTION
        pocket_data.CutDepth        = Dovetail.SideThickness
        pocket_data.RasterAngle     = 0
        pocket_data.Allowance       = 0.0
  local pos_data                    = ToolpathPosData()
  local geometry_selector           = GeometrySelector()
  local toolpath_manager            = ToolpathManager()
  local toolpath = toolpath_manager:CreatePocketingToolpath(toolpath_name, Dovetail.StrightTool, nil, pocket_data, pos_data, geometry_selector, true , true )
  if toolpath == nil then
    MessageBox("Error creating toolpath")
    return false
  end
   return true
end  -- function end
-- ===================================================]]
function CreatePocketToolpath2(layer_name, toolpath_name)
  local selection = Dovetail.job.Selection
  selection:Clear()
  local layer = Dovetail.job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
  local tool = Tool("Lua End Mill", Tool.END_MILL)
      if Dovetail.BitUnits == "mm" then
        tool.InMM        = true
      else
        tool.InMM        = false
      end
      tool.ToolDia = Dovetail.StrightToolDia
      tool.Stepdown = Dovetail.StrightToolDia * 0.75
      tool.Stepover = Dovetail.StrightToolDia * 0.45
      if Dovetail.StrightToolUnits == "inches/sec" then  -- tool.RateUnits  =  MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
        tool.RateUnits   = INCHES_SEC
      elseif Dovetail.Units == "inches/min" then
        tool.RateUnits  =  INCHES_MIN
      elseif Dovetail.Units == "feet/min" then
        tool.RateUnits  =  FEET_MIN
      elseif Dovetail.Units == "mm/sec" then
        tool.RateUnits  =  MM_SEC
      elseif Dovetail.Units == "mm/min" then
        tool.RateUnits  =  MM_MIN
      elseif Dovetail.Units == "metres/min" then
        tool.RateUnits  =  METRES_MIN
      end
      tool.FeedRate = Dovetail.StrightToolFeedRate   -- 40
      tool.PlungeRate = Dovetail.StrightToolPlungRate -- 20
      tool.SpindleSpeed = Dovetail.StrightToolRPM    -- 20000
      tool.ToolNumber = 251
  local mtl_block = MaterialBlock()
  local mtl_box = mtl_block.MaterialBox
  local mtl_box_blc = mtl_box.BLC
  local pos_data = ToolpathPosData()
       pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
       pos_data.SafeZGap = mtl_block.Thickness * 0.1
  local pocket_data = PocketParameterData()
       pocket_data.StartDepth = 0
       pocket_data.CutDepth = Dovetail.SideThickness
       pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
       pocket_data.Allowance = 0.0
       pocket_data.DoRasterClearance = true
       pocket_data.RasterAngle = 0
       pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
       pocket_data.DoRamping = false
       pocket_data.RampDistance = 1.0
       pocket_data.ProjectToolpath = false
  local geometry_selector = GeometrySelector()
  local create_2d_previews = true
  local display_warnings = true
  local area_clear_tool = nil
  local toolpath_manager = ToolpathManager()
  local toolpath_id = toolpath_manager:CreatePocketingToolpath(toolpath_name, tool, area_clear_tool, pocket_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
  if toolpath_id  == nil  then
    DisplayMessageBox("Error Creating Toolpath")
    return false
  end
  return true
end
-- ===================================================]]
function CreateProfileToolpath(layer_name, name, cut_depth, InOrOut, UseTab)
--  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
  local selection = Dovetail.job.Selection  -- clear current selection
        selection:Clear()
-- get layer
  local layer = Dovetail.job.LayerManager:FindLayerWithName(layer_name)
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
  local tool = Tool("Dovetail Mill", Tool.END_MILL)
        if Dovetail.Units == "mm" then
          tool.InMM        = true
        else
          tool.InMM        = false
        end
        tool.ToolDia       = Dovetail.DovetailToolDia       -- tool_dia
        tool.Stepdown      = Dovetail.BitLength             -- tool_stepdown
        tool.Stepover      = Dovetail.DovetailToolDia       -- tool_dia * 0.25
        if Dovetail.Units == "inches/sec" then  -- tool.RateUnits  =  MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.RateUnits   = INCHES_SEC
        elseif Dovetail.Units == "inches/min" then
          tool.RateUnits  =  INCHES_MIN
        elseif Dovetail.Units == "feet/min" then
          tool.RateUnits  =  FEET_MIN
        elseif Dovetail.Units == "mm/sec" then
          tool.RateUnits  =  MM_SEC
        elseif Dovetail.Units == "mm/min" then
          tool.RateUnits  =  MM_MIN
        elseif Dovetail.Units == "metres/min" then
          tool.RateUnits  =  METRES_MIN
        end
        tool.FeedRate      = Dovetail.FeedRate              -- 30
        tool.PlungeRate    = Dovetail.PlungRate             -- 10
        tool.SpindleSpeed  = Dovetail.RPM                   -- 20000
        tool.ToolNumber    = 250                            -- 1
-- Create object used to set home position and safez gap above material surface
  local pos_data = ToolpathPosData()
        pos_data:SetHomePosition(0, 0, 0.25)
        pos_data.SafeZGap    = 0.25
-- Create object used to pass profile options
  local profile_data = ProfileParameterData()
-- start depth for toolpath
  profile_data.StartDepth    = 0.0
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
  profile_data.UseTabs = UseTab  -- UseTab -- true to use tabs (position of tabs must already have been defined on vectors)
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
  local display_warnings = true -- if this is true we will display errors and warning to the user
  local toolpath_manager = ToolpathManager() -- Create our toolpath
  local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data,
                      ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
  if toolpath_id == nil then
    DisplayMessageBox("Error creating toolpath")
    return false
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
.LuaButton {font-weight:bold;  font-family:Arial, Helvetica, sans-serif;font-size:12px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
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
DialogWindow.myHtml5 = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="header1-c" id="SysName">Easy Cabinet Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" id="Version" class="ver-c">Version</td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td> </tr> <tr> <td align="center" class="p1-l"><p class="p1-l">The ]] .. Dovetail.AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br> <br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br> <br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td> </tr> <tr> <td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td> </tr> <tr> <td align="center" ><span class="header2-c">JimAndi Gadgets</span></td> </tr> <tr> <td align="center"><span class="h1-c">Houston, TX.</span></td> </tr> <tr> <td><hr></td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr></table></body></html>]]
-- =========================================================]] -- Dovetail
  if Dovetail.AppValue then
    Dovetail.ToolTable = [[<table width="550" border="0"> <tr> <td height="20" align="right" nowrap class="h1-l"><strong>Select Stright Bit</strong></td>  <td height="20" colspan="2" align="right" nowrap class="h1-l"><hr></td> </tr> <tr><td width="89" align="right" nowrap class="h1-l">Stright Bit:</td><td width="100%" nowrap="nowrap"  bgcolor="#00FFFF" class="ToolNameLabel"><span class="ToolNameLabel" id = "ToolNameLabel">-</span></td><td width="51"><strong><input name = "ToolChooseButton" id="ToolChooseButton" type = "button" class = "ToolPicker" value = "Tool"></strong></td></tr></table>]]
  else
    Dovetail.ToolTable = [[</table><table width="550" border="0"> <tr> <td class="h1-rPx">Bit Diameter</td> <td class="h1-l"> <input name="Dovetail.StrightToolDia" type="text" id="Dovetail.StrightToolDia" size="10"> </td> <td><span class="h1-rPx">Bit Units</span></td> <td> <select name = "UnitList" class = "h1-l" id = "UnitList"> <option selected>inch</option> <option>mm</option> </select></td> <td class="h1-rP">Mill Rate</td> <td><select name = "RateList" class = "h2" id = "RateList"> <option>inches/sec</option> <option selected>inches/min</option> <option>feet/min</option> <option>mm/sec</option> <option>mm/min</option> <option>m/min</option> </select></td> </tr> <tr> <td class="h1-rPx">Bit RPM</td> <td class="h1-l"> <input name="Dovetail.StrightToolRPM" type="text" id="Dovetail.StrightToolRPM" size="10"> </td> <td class="h1-rP">Feed Rate</td> <td> <input name="Dovetail.StrightToolFeedRate" type="text" id="Dovetail.StrightToolFeedRate" size="10"> </td> <td class="h1-r">Plunge Rate</td> <td class="h1-l"> <input name="Dovetail.StrightToolPlungRate" type="text" id="Dovetail.StrightToolPlungRate" size="10"> </td> </tr></table>]]
  end --if end
  DialogWindow.myHtml1 = [[<html><head><title>Dovetail Toolpath Creator</title>]] .. DialogWindow.Style ..[[</head><body><table width="550" border="0"> <tr> <td width="360"><p class="p1-l">This gadget creates a drawing and tool paths for a Dovetail joint from the material job settings and user inputs.</p> <p class="p1-l">This requires the material to be held in the <strong>vertical position </strong> so that the milling can be performed on the end of the stock to receive the specified joinery.</p> <p class="p1-l">The gadget uses the Job Setup Seeting to deturmen the stock oreintation. Milling will run in the direction of the longest side of the material job and the material is a rectangle in shape.</p> <p class="p1-l">Use the Top of material (top end of material) for the Z value. Set the materialthickness to the length of material.</p> <p class="p1-l">For best results in cutting Pins and Clearing path, use &quot; up-cut&quot; spiral bits.</p></td> <td width="180" align="left" valign="top"><table width="100" border="0"> <tr> <td width="68" class="h1-rP"> <input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About"></td> <td class="ver-c"> <label  id="Dovetail.Version">-</label></td> </tr> <tr> <td colspan="2"><img src= data:image/jpeg;base64,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 width="200" height="220"></td> </tr> </table></td> </tr></table><table width="550" border="0"> <tr> <td width="110" class="h1-l"><strong>Select Dovetail Bit</strong></td> <td width="440"><hr></td> </tr> <tr> <td height = "20" colspan="2"><select name = "ListBox" class = "h1-c" id = "ListBox"> <option>Defalt</option> </select></td> </tr></table>]].. Dovetail.ToolTable .. [[<table width="550" border="0"> <tr> <td class="h1-c"><hr></td> </tr></table><table width="550" border="0"> <tr> <td width="195" class="h1-rP">Front Material Thickness</td> <td width="85"><span class="h1-l"> <input name="Dovetail.FrontThickness" type="text" id="Dovetail.FrontThickness" size="9"> </span></td> <td colspan="2" class="h1-c"><input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Edit Layers"></td> </tr> <tr> <td class="h1-rP">Side Material Thickness</td> <td><span class="h1-l"> <input name="Dovetail.SideThickness" type="text" id="Dovetail.SideThickness" size="9"> </span></td> <td colspan="2" align="center"><span class="h1-c"> DrawingUnits </span></td> </tr> <tr> <td class="h1-rP">Front Backer Thickness</td> <td class="h1-l"><input name="Dovetail.FrontBackerThickness" type="text" id="Dovetail.FrontBackerThickness" size="9"></td> <td class="h1-rP">Back Backer Thickness</td> <td class="h1-l"><input name="Dovetail.BackBackerThickness" type="text" id="Dovetail.BackBackerThickness" size="9"></td> </tr> <tr> <td class="h1-rP">Dovetail Count</td> <td><span class="h1-l"> <input id="Dovetail.TailCount" name="Dovetail.TailCount" size="9" type="text"> </span></td> <td width="163"><span class="h1-l"><span class="h1-c"><span style="width: 15%"> <input id = "ButtonCalulate" class = "LuaButton" name = "ButtonCalulate" type = "button" value = "Calulate"> </span></span></span></td> <td width="89">&nbsp;</td> </tr> <tr> <td class="h1-rP">Pin Fit Amount</td> <td><span class="h1-l"> <input name="Dovetail.PinFitAdjustment" type="text" id="Dovetail.PinFitAdjustment" size="9"> </span></td> <td colspan="2" id="Dovetail.TailNote2" class="h1-c">&nbsp;</td> </tr> <tr> <td class="h1-rP">Tail Fit Amount</td> <td><span class="h1-l"> <input name="Dovetail.TailFitAdjustment" type="text" id="Dovetail.TailFitAdjustment" size="9"> </span></td> <td colspan="2" id="Dovetail.TailNote" class="h1-c">TailNote</td> </tr> <tr> <td class="h1-rP" id="Dovetail.Tail">Tail Size</td> <td><span class="h1-l"> <input name="Dovetail.TailValue" type="text" disabled id="Dovetail.TailValue" size="9" readonly> </span></td> <td colspan="2" id="Dovetail.PinNote" class="h1-c">PinNote </td> </tr></table><table width="100%" border="0" id="ButtonTable"> <tr> <td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"> <hr> </td> </tr> <tr> <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"> </td> <td width="308" class="alert-l" id="Dovetail.Alert">.</td> <td width="94" class="h1-c" style="width: 15%"> <input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"> </td> <td width="89" class="h1-c" style="width: 15%"> <input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"> </td> </tr> </table></body></html>]]
-- =========================================================]] -- Layers
  DialogWindow.myHtml3 = [[<html><head><title>Dovetail Layer Names</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"> <table width="550" border="0"> <tr> <td height="20" class="h2-r">ToolPaths</td>  <td height="20"><hr></td>   </tr> <td width="198" class="h1-rP"><span class="h2">Side - Broad</span></td> <td width="342"><span class="h2"> <input name="Dovetail.LayerNameSideBroad" type="text" class="h21" id="Dovetail.LayerNameSideBroad" size="50" maxlength="50" /> </span></td> </tr> <tr> <td class="h1-rP"><span class="h2">Side- Dovetail Clearing</span></td> <td><span class="h2"> <input name="Dovetail.LayerNameClearing" type="text" class="h21" id="Dovetail.LayerNameClearing" size="50" maxlength="50" /> </span></td> </tr> <tr> <td class="h1-rP"><span class="h2">Side - Dovetail Path</span></td> <td><span class="h2"> <input name="Dovetail.LayerNameDovetailPath" type="text" class="h21" id="Dovetail.LayerNameDovetailPath" size="50" maxlength="50" /> </span></td> </tr> <tr> <td class="h1-rP"><span class="h2">Front - Broad</span></td> <td><span class="h2"> <input name="Dovetail.LayerNameFrontBroad" type="text" class="h21" id="Dovetail.LayerNameFrontBroad" size="50" maxlength="50" /> </span></td> </tr> <tr> <td class="h1-rP"><span class="h1-rP">Front - Pockets</span></td> <td><span class="h2"> <input name="Dovetail.LayerNameFrontPocket" type="text" class="h21" id="Dovetail.LayerNameFrontPocket" size="50" maxlength="50" /> </span></td> </tr> </table> <table width="550" border="0"> <tr> <td height="19" class="h2-r">Layers</td> <td height="19"><hr></td> </tr> <tr> <td width="199" class="h1-rP"><span class="h2">Side - Dovetail Path</span></td> <td width="341"><span class="h2"> <input name="Dovetail.ToolPathTail" type="text" class="h21" id="Dovetail.ToolPathTail" size="50" maxlength="50" /> </span></td> </tr> <tr> <td class="h1-rP"><span class="h2">Side - Clearing</span></td> <td><span class="h2"> <input name="Dovetail.ToolPathClearing" type="text" class="h21" id="Dovetail.ToolPathClearing" size="50" maxlength="50" /> </span></td> </tr> <tr> <td class="h1-rP"><span class="h2">Front - Pins</span></td> <td><span class="h2"> <input name="Dovetail.ToolPathPins" type="text" class="h21" id="Dovetail.ToolPathPins" size="50" maxlength="50" /> </span></td> </tr> </table> <table width="100%" border="0" id="ButtonTable"> <tr> <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"> <input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td> <td width="308" class="alert-l" id="GadgetName.Alert">.</td> <td width="80" class="h1-c" style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> <td width="80" class="h1-c" style="width: 15%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> </tr></table></body></html>]]
end
-- ================ End ==============================]]