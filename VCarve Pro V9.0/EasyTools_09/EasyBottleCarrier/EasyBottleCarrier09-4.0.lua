-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented ; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy Bottle Carrier Maker is written by Jim Anderson of Houston Texas 2019
]]
-- =====================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"

local Carrier = {}
local Tool_ID1 = ""
local Tool_ID2 = ""
local Tool_ID3 = ""
-- =====================================================]]
  function Polar2D(pt, ang, dis)
    return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                   (pt.Y + dis * math.sin(math.rad(ang))))
  end
-- =====================================================]]
  function GetDistance(objA, objB)
     local xDist = objB.x - objA.x
     local yDist = objB.y - objA.y
     return math.sqrt((xDist ^ 2) + (yDist ^ 2))
  end -- End Fuction
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
function StampIt(Thick)
  local mtl_block = MaterialBlock()
  local mtl_box = mtl_block.MaterialBox
  local pt1Text = Point2D(0.5, mtl_box.TLC.Y - 1.25)
  DrawWriter("Alert: Material Thinkness = " .. Thick, pt1Text, 0.750, Milling.LayerNameDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.5)
  DrawWriter(Project.ProgramName, pt1Text, 0.3, Milling.LayerNameDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.35)
  DrawWriter("Project ID: " .. Project.DrawerID, pt1Text, 0.25, Milling.LayerNameDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.25)
  DrawWriter("Version: " .. Project.ProgramVersion, pt1Text, 0.20, Milling.LayerNameDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.25)
  DrawWriter("Gadget By: " .. Project.CodeBy, pt1Text, 0.20, Milling.LayerNameDrawNotes, 0.0)
  return true
end
-- =====================================================]]
  function CheckDialogValues()
    if Carrier.BottleCount == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Bottle Count cannot be zero" )
    end -- if end
    if Carrier.BottleDia == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Bottle Diamiture cannot be zero" )
    end -- if end
    if Carrier.BottleHeight == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Bottle Height cannot be zero" )
    end -- if end
    if Carrier.DadoAllowance == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Milling Clearance cannot be zero" )
    end -- if end
    if Carrier.BottleClearance == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Bottle Clearance cannot be zero" )
    end -- if end
    if Carrier.HandleTop == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Handle Top cannot be zero" )
    end -- if end
    if Carrier.BottleGap == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Bottle Gap cannot be zero" )
    end -- if end
    if Carrier.PartGap == 0.0 then
      Carrier.DialogLoop = true
      DisplayMessageBox("Error: Part gap cannot be zero" )
    end -- if end
    return true
  end -- function end
-- =====================================================]]
  function CarrierMath()
    Carrier.BottleRad     = Carrier.BottleDia * 0.5
    Carrier.SideHeight     = Carrier.BottleHeight * 0.4
    Carrier.MaterialBlock = MaterialBlock()
    Carrier.MaterialBlockThickness = Carrier.MaterialBlock.Thickness
    Carrier.Clearing = 0.125000  -- Math use only

    local EndAmount       = (Carrier.BottleDia + (Carrier.BottleClearance * 2.0)) * 2.0
    local EndGapAmount    = (Carrier.BottleGap * 4) + Carrier.MaterialBlockThickness
    Carrier.EndLenght     = Carrier.MaterialBlockThickness + EndAmount + EndGapAmount
    Carrier.EndHeight     = Carrier.BottleHeight
    -- ============]]
    Carrier.OneSide       = Carrier.BottleCount * 0.5
    local DiaAmount       = Carrier.OneSide * (Carrier.BottleDia + (Carrier.BottleClearance * 2.0))
    local GapAmount       = (Carrier.BottleGap * Carrier.OneSide) + Carrier.BottleGap
    Carrier.TopLenght     = Carrier.MaterialBlockThickness + DiaAmount + GapAmount
    Carrier.SideLenght    = Carrier.TopLenght + Carrier.MaterialBlockThickness
    -- ============]]
    Carrier.HandleHoleLenght =  Carrier.TopLenght * 0.65 -- is equal to 65% of the handle length
    Carrier.TopWidht      = Carrier.EndLenght
    Carrier.HandleLenght  = Carrier.TopLenght
    Carrier.HandleHeight   = (Carrier.EndHeight - Carrier.SideHeight ) + (Carrier.MaterialBlockThickness * 0.5)
    Carrier.HandleRad     = Carrier.TopLenght     * 2.0
    Carrier.MillingBitRad = Carrier.Clearing + Carrier.DadoAllowance
    Carrier.BottleHole    = Carrier.BottleDia + (Carrier.BottleClearance * 2.0)
    Carrier.BottleCenterH = Carrier.BottleGap + (Carrier.BottleHole * 0.5)
    -- ==================]]
    Carrier.g_pt1a =  Polar2D(Point2D(0.0, 0.0), 270.0,   Carrier.EndHeight + (Carrier.SideHeight * 0.5) + Carrier.PartGap)
    Carrier.g_pt1  =  Polar2D(Carrier.g_pt1a,            180.0,   Carrier.EndLenght + (Carrier.HandleLenght * 0.5) + Carrier.PartGap)
    Carrier.g_pt2  =  Polar2D(Carrier.g_pt1a,            180.0,   Carrier.HandleLenght * 0.5)
    Carrier.g_pt3  =  Polar2D(Carrier.g_pt2,               0.0,   Carrier.HandleLenght + Carrier.PartGap)
    Carrier.g_pt4a =  Polar2D(Point2D(0.0, 0.0), 270.0,   Carrier.SideHeight * 0.5)
    Carrier.g_pt4  =  Polar2D(Carrier.g_pt4a,            180.0,   Carrier.SideLenght + Carrier.PartGap)
    Carrier.g_pt5  =  Polar2D(Carrier.g_pt4,               0.0,   Carrier.SideLenght + Carrier.PartGap + Carrier.PartGap)
    Carrier.g_pt6a =  Polar2D(Point2D(0.0, 0.0),  90.0,   (Carrier.SideHeight * 0.5) + Carrier.PartGap)
    Carrier.g_pt6  =  Polar2D(Carrier.g_pt6a,            180.0,   Carrier.PartGap + Carrier.TopLenght)
    Carrier.g_pt7  =  Polar2D(Carrier.g_pt6a,              0.0,   Carrier.PartGap)
    return true
  end
  -- =====================================================]]
function CarrierDialog(Header)
  --[[
      TextBox for user input with default value
      Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
      Dialog Header = "Cabinet Maker"
      User Question = "Enter your last name?"
      Default Question = Anderson
      Returns = String
  ]]
    local SDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Bottle_Carrier-Page1"
    local function IsNumberEven(x)
      if x % 2 == 0 then
        return true
      else
        return false
      end
    end
    local myHtml = [[<html><head><title>Easy Bottle Carrier</title><style type="text/css">html {overflow:hidden}.helpbutton {background-color:#E1E1E1;border:1px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:#000}.helpbutton:active {border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000}.helpbutton:hover {border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}.LuaButton {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}.DirectoryPicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}.ToolPicker {font-weight:bold;text-align:center;font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;width:50px}.ToolNameLabel {font-family:Arial, Helvetica, sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#0000FF}.FormButton {font-weight:bold;width:75px;font-family:Arial, Helvetica, sans-serif;font-size:12px;white-space:nowrap}.h1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left;white-space:nowrap}.h2-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left}.h1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right;white-space:nowrap}.h1-rP {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px}.h1-rPx {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px}.alert {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;color:#00F;text-align:center;white-space:nowrap}.h1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;white-space:nowrap}.header1-c {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}.header2-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;text-align:center;white-space:nowrap}body {margin-top: 10px;margin-left: 10px;margin-right: 0px;background-color: #efefef;overflow:hidden;font-family:Arial, Helvetica, sans-serif;font-size:12px}</style></head><body bgcolor = "#EBEBEB" text = "#000000"><table width = "450" border = "0" cellpadding = "0"> <tr> <td width = "120" rowspan="6" align = "center" valign = "middle" bgcolor = "#CCCCCC"><img src=data:image/jpeg;base64,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> </td> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottle Count </strong> <input name = "Carrier.BottleCount" type = "text" id = "Carrier.BottleCount" size = "10"></td> </tr> <tr> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottle Height </strong> <input name = "Carrier.BottleHeight" type = "text" id = "Carrier.BottleHeight" size = "10"></td> </tr> <tr> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottle Diameter </strong> <input name = "Carrier.BottleDia" type = "text" id = "Carrier.BottleDia" size = "10"></td> </tr> <tr> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottle Gap <input name = "Carrier.BottleGap" type = "text" id = "Carrier.BottleGap" size = "10"> </strong></td> </tr> <tr> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r" ><strong>Part Spacing Gap </strong> <input name = "Carrier.PartGap" type = "text" id = "Carrier.PartGap" size = "10"></td> </tr> <tr> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottle Side Clearance</strong> <input name = "Carrier.BottleClearance" type = "text" id = "Carrier.BottleClearance" size = "10"></td> </tr> <tr> <td width="120" align = "center" valign = "middle" nowrap class="h1-r">&nbsp;</td> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Hand Grip Size </strong> <input name = "Carrier.HandleTop" type = "text" id = "Carrier.HandleTop" size = "10"></td> </tr> <tr> <td width="120" align = "center" valign = "middle" nowrap class="h1-r"><span class="h1-r1">Holding Tabs <input type="checkbox" name="Carrier.Tabs" id="Carrier.Tabs"> </span> </td> <td colspan="2" align = "right" valign = "middle" nowrap class="h1-r"><strong>Dado Allowance </strong> <input name = "Carrier.DadoAllowance" type = "text" id = "Carrier.DadoAllowance" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottle Side Height</strong></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.BottleSideHeight" type = "text" id = "Carrier.BottleSideHeight" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td width="212" align = "right" valign = "middle" nowrap class="h1-r"><strong>Handle Length</strong></td> <td width="114" align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.HandleLength" type = "text" id = "Carrier.HandleLength" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><p><strong>Handle Hole Size</strong></p></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.HandleHoleSize" type = "text" id = "Carrier.HandleHoleSize" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><strong>Top Thickness</strong></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.ThicknessTop" type = "text" id = "Carrier.ThicknessTop" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><strong>Bottom Thickness</strong></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.ThicknessBottom" type = "text" id = "Carrier.ThicknessBottom" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><strong>Side Thickness</strong></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.ThicknessSide" type = "text" id = "Carrier.ThicknessSide" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><strong>End Thickness</strong></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.ThicknessEnd" type = "text" id = "Carrier.ThicknessEnd" size = "10"></td> </tr> <tr> <td align = "center" valign = "middle" nowrap class="h1-r"> <td align = "right" valign = "middle" nowrap class="h1-r"><strong>Handle Thickness</strong></td> <td align = "right" valign = "middle" nowrap class="h1-l"><input name = "Carrier.ThicknessHandle" type = "text" id = "Carrier.ThicknessHandle" size = "10"></td> </tr> <tr> <td colspan="3"><hr> </tr></table><table width="450" border="0"> <tr> <td width="120" align="right" nowrap class="h1-r"><strong>Profile Tool:</strong></td> <td width="216" nowrap="nowrap" class="ToolNameLabel"><span id = "ToolNameLabel1">-</span></td> <td width="78" nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton1" class = "ToolPicker" name = "ToolChooseButton1" type = "button" value = "Tool"> </strong></td> </tr> <tr> <td align="right" nowrap class="h1-r" ><strong>Pocket Tool:</strong></td> <td nowrap="nowrap" class="ToolNameLabel"><span id = "ToolNameLabel2">-</span></td> <td nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton2" class = "ToolPicker" name = "ToolChooseButton2" type = "button" value = "Tool"> </strong></td> </tr> <tr> <td align="right" nowrap class="h1-r" ><strong>Pocket Clearing Tool:</strong></td> <td nowrap="nowrap" class="ToolNameLabel"><span id = "ToolNameLabel3">-</span></td> <td nowrap class="ToolPicker"><strong> <input id = "ToolChooseButton3" class = "ToolPicker" name = "ToolChooseButton3" type = "button" value = "Tool"> </strong></td> </tr></table><table width="450" border="0" id="ButtonTable"> <tr> <td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="45"><strong> <a href="]].. SDK .. [[" target="_blank" class="helpbutton">Help</a></strong></td> <td width="236" class="alert" id="Carrier.Alert">.</td> <td width="75" class="FormButton"><span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td> <td width="75" class="FormButton"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span></td> </tr></table></body></html>]]
      local dialog = HTML_Dialog(true, myHtml, 489, 623, Header)
      dialog:AddIntegerField("Carrier.BottleCount",      Carrier.BottleCount)
      dialog:AddDoubleField("Carrier.BottleDia",         Carrier.BottleDia)
      dialog:AddDoubleField("Carrier.BottleHeight",      Carrier.BottleHeight)
      dialog:AddDoubleField("Carrier.BottleSideHeight",  Carrier.BottleSideHeight)
      dialog:AddDoubleField("Carrier.DadoAllowance",     Carrier.DadoAllowance)
      dialog:AddDoubleField("Carrier.BottleClearance",   Carrier.BottleClearance)
      dialog:AddDoubleField("Carrier.HandleTop",         Carrier.HandleTop)
      dialog:AddDoubleField("Carrier.BottleGap",         Carrier.BottleGap)
      dialog:AddDoubleField("Carrier.HandleLength",      Carrier.HandleLength)
      dialog:AddDoubleField("Carrier.HandleHoleSize",    Carrier.HandleHoleSize)
      dialog:AddDoubleField("Carrier.ThicknessTop",      Carrier.ThicknessTop)
      dialog:AddDoubleField("Carrier.ThicknessHandle",   Carrier.ThicknessHandle)
      dialog:AddDoubleField("Carrier.ThicknessBottom",   Carrier.ThicknessBottom)
      dialog:AddDoubleField("Carrier.ThicknessSide",     Carrier.ThicknessSide)
      dialog:AddDoubleField("Carrier.ThicknessEnd",      Carrier.ThicknessEnd)
      dialog:AddDoubleField("Carrier.PartGap",           Carrier.PartGap)
      dialog:AddCheckBox("Carrier.Tabs",                 Carrier.Tabs)
      dialog:AddLabelField("ToolNameLabel1", "Not Selected")
      dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
      dialog:AddToolPickerValidToolType("ToolChooseButton1", Tool.END_MILL)
      dialog:AddLabelField("ToolNameLabel2", "Not Selected")
      dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
      dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
      dialog:AddLabelField("ToolNameLabel3", "Not Selected")
      dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
      dialog:AddToolPickerValidToolType("ToolChooseButton3", Tool.END_MILL)
      if dialog:ShowDialog() then
        Carrier.BottleCount       = dialog:GetIntegerField("Carrier.BottleCount")
        Carrier.BottleDia         = dialog:GetDoubleField("Carrier.BottleDia")
        Carrier.BottleHeight      = dialog:GetDoubleField("Carrier.BottleHeight")
        Carrier.BottleSideHeight  = dialog:GetDoubleField("Carrier.BottleSideHeight")
        Carrier.DadoAllowance     = dialog:GetDoubleField("Carrier.DadoAllowance")
        Carrier.BottleClearance   = dialog:GetDoubleField("Carrier.BottleClearance")
        Carrier.HandleTop         = dialog:GetDoubleField("Carrier.HandleTop")
        Carrier.BottleGap         = dialog:GetDoubleField("Carrier.BottleGap")
        Carrier.PartGap           = dialog:GetDoubleField("Carrier.PartGap")
        Carrier.HandleLength      = dialog:GetDoubleField("Carrier.HandleLength")
        Carrier.HandleHoleSize    = dialog:GetDoubleField("Carrier.HandleHoleSize")
        Carrier.ThicknessTop      = dialog:GetDoubleField("Carrier.ThicknessTop")
        Carrier.ThicknessHandle   = dialog:GetDoubleField("Carrier.ThicknessHandle")
        Carrier.ThicknessBottom   = dialog:GetDoubleField("Carrier.ThicknessBottom")
        Carrier.ThicknessSide     = dialog:GetDoubleField("Carrier.ThicknessSide")
        Carrier.ThicknessEnd      = dialog:GetDoubleField("Carrier.ThicknessEnd")
        Carrier.Tabs              = dialog:GetCheckBox("Carrier.Tabs")
        Carrier.MillTool1         = dialog:GetTool("ToolChooseButton1")  -- Profile
        Carrier.MillTool2         = dialog:GetTool("ToolChooseButton2")  -- Pocketing
        Carrier.MillTool3         = dialog:GetTool("ToolChooseButton3")  -- Clearing
        if not IsNumberEven(Carrier.BottleCount) then
          Carrier.BottleCount = Carrier.BottleCount + 1
        end
        Carrier.Dialog_X = tostring(dialog.WindowWidth)
        Carrier.Dialog_Y = tostring(dialog.WindowHeight)
        return true
      end
      return false
  end
  -- =====================================================]]
  function DrawEnd(job, pt0, Layer)
    -- ======= Calulate Points
    local pt1a  = Polar2D(pt0, 180.0, Carrier.MillingBitRad)
    local pt14  = Polar2D(pt0,   0.0, Carrier.EndLenght)
    local pt14a = Polar2D(pt14,  0.0, Carrier.MillingBitRad)
    local pt2  = Polar2D(pt0,   90.0, Carrier.MaterialBlockThickness + (Carrier.DadoAllowance * 0.5))
    local pt2a = Polar2D(pt2,  180.0, Carrier.MillingBitRad)
    local pt3  = Polar2D(pt0,   90.0, Carrier.SideHeight -(Carrier.MaterialBlockThickness + Carrier.DadoAllowance))
    local pt3a = Polar2D(pt3,  180.0, Carrier.MillingBitRad)
    local pt4  = Polar2D(pt0,   90.0, Carrier.SideHeight)
    local pt4a = Polar2D(pt4,  180.0, Carrier.MillingBitRad)
    local pt13  = Polar2D(pt14, 90.0, Carrier.MaterialBlockThickness + (Carrier.DadoAllowance * 0.5))
    local pt13a = Polar2D(pt13,  0.0, Carrier.MillingBitRad)
    local pt12  = Polar2D(pt14, 90.0, Carrier.SideHeight -  (Carrier.MaterialBlockThickness + Carrier.DadoAllowance))
    local pt12a = Polar2D(pt12,  0.0, Carrier.MillingBitRad)
    local pt11  = Polar2D(pt14, 90.0, Carrier.SideHeight)
    local pt11a = Polar2D(pt11,  0.0, Carrier.MillingBitRad)
    local BC  = Polar2D(pt0,     0.0, Carrier.EndLenght  * 0.5)
    local TC  = Polar2D(BC,     90.0, Carrier.EndHeight)
    local pt5 = Polar2D(TC,    180.0, (Carrier.HandleTop * 0.5))
    local pt6 = Polar2D(TC,    180.0, (Carrier.MaterialBlockThickness * 0.5) + (Carrier.DadoAllowance * 0.5))
    local pt7 = Polar2D(TC,      0.0, (Carrier.MaterialBlockThickness * 0.5) + (Carrier.DadoAllowance * 0.5))
    local pt8 = Polar2D(TC,      0.0, (Carrier.HandleTop * 0.5))
    local pt6a  = Polar2D(pt6,  90.0, Carrier.MillingBitRad)
    local pt7a  = Polar2D(pt7,  90.0, Carrier.MillingBitRad)
    local pt9   = Polar2D(pt4,   0.0, (Carrier.EndLenght * 0.5) - ((Carrier.MaterialBlockThickness * 0.5) + (Carrier.DadoAllowance * 0.5)))
    local pt10  = Polar2D(pt11,180.0, (Carrier.EndLenght * 0.5) - ((Carrier.MaterialBlockThickness * 0.5) + (Carrier.DadoAllowance * 0.5)))
    -- ======= Draw Part
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName("Pocket")
    line:AppendPoint(pt3a)  -- Top and Handle Dato's
    line:LineTo(pt4a)
    line:LineTo(pt9)
    line:LineTo(pt6a)
    line:LineTo(pt7a)
    line:LineTo(pt10)
    line:LineTo(pt11a)
    line:LineTo(pt12a)
    line:LineTo(pt3a)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0) -- Bottom Dato
    layer = job.LayerManager:GetLayerWithName("Pocket")
    line:AppendPoint(Polar2D(pt1a, 225.0,0.1))
    line:LineTo(Polar2D(pt2a,  180.0,0.1))
    line:LineTo(Polar2D(pt13a, 0.0,0.1))
    line:LineTo(Polar2D(pt14a, 315.0,0.1))
    line:LineTo(Polar2D(pt1a,  225.0,0.1))
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0) -- Outer Line
    layer = job.LayerManager:GetLayerWithName("Profile")
    line:AppendPoint(pt0)
    line:LineTo(pt4)
    line:LineTo(pt5)
    line:LineTo(pt8)
    line:LineTo(pt11)
    line:LineTo(pt14)
    line:LineTo(pt0)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true
  end
  -- =====================================================]]
  function DrawHandle(job, pt0, Layer)
      local function Segment (p1, p2, Rad)
      local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
      local segment = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
      return segment
    end
    local function Radius2Bulge (p1, p2, Rad)
      local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
      local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
      local bulge = (2 * seg) / chord
      return bulge
    end
      -- ======= Calulate Points

    local ArcBasePt = Carrier.HandleRad
    local pt2 = Polar2D(pt0,   90.0, Carrier.HandleHeight)
    local pt4 = Polar2D(pt0,    0.0, Carrier.HandleLenght)
    local pt3 = Polar2D(pt4,   90.0, Carrier.HandleHeight)
    local UpDist = Carrier.HandleHeight + Segment(pt2, pt3, Carrier.HandleRad) - (Carrier.HandleTop + Carrier.HandleHoleSize)
    local ptCen = Polar2D(pt0,   0.0,  Carrier.HandleLenght * 0.5)
    local ptUp =  Polar2D(ptCen, 90.0, UpDist)
    local pt5 = Polar2D(ptUp,   0.0, Carrier.HandleHoleLenght * 0.5)
    local pt6 = Polar2D(ptUp, 180.0, Carrier.HandleHoleLenght * 0.5)
    local pt7 = Polar2D(pt5,   75.0, 0.75)
    local pt8 = Polar2D(pt6,  105.0, 0.75)

   --[[ MarkPoint("pt0", pt0, 3, "PointLayer")
    MarkPoint("pt2", pt2, 3, "PointLayer")
    MarkPoint("pt3", pt3, 3, "PointLayer")
    MarkPoint("pt4", pt4, 3, "PointLayer")
    MarkPoint("pt5",   pt5, 3, "PointLayer")
    MarkPoint("pt6",   pt6, 3, "PointLayer")
    MarkPoint("pt7",   pt7, 3, "PointLayer")
    MarkPoint("pt8",   pt8, 3, "PointLayer")
    MarkPoint("ptCen", ptCen, 3, "PointLayer")
    MarkPoint("ptUp",  ptUp,  3, "PointLayer")

   --MarkPoint(tostring(Segment(Point2D(0.0,0.0),Point2D(0.0,20.0),11.18034)), Point2D(0,0), 3,   "PointLayer")

]]
    Carrier.HandleRad2 = Carrier.HandleRad + (Carrier.HandleTop * 8.0)
    -- ======= Draw Part
    local line = Contour(0.0) -- Outside line
    local layer = job.LayerManager:GetLayerWithName("Profile")
    line:AppendPoint(pt0)
    line:LineTo(pt2)
    line:ArcTo(pt3, -1.0 * Radius2Bulge (pt2, pt3, Carrier.HandleRad))
    line:LineTo(pt4)
    line:LineTo(pt0)
    layer:AddObject(CreateCadContour(line), true)

    line = Contour(0.0) -- Hand hole
    layer = job.LayerManager:GetLayerWithName("Hole")
    line:AppendPoint(pt5)
    line:LineTo(pt6)
    line:LineTo(pt8)
    line:ArcTo(pt7, -1.0 * Radius2Bulge (pt2, pt3, Carrier.HandleRad2))
    line:LineTo(pt5)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true
  end
  -- =====================================================]]
  function DrawSide(job, pt0, Layer)
  -- ======= Calulate Points
    local pt2 = Polar2D(pt0,   90.0, Carrier.SideHeight)
    local pt4 = Polar2D(pt0,    0.0, Carrier.SideLenght)
    local pt3 = Polar2D(pt4,   90.0, Carrier.SideHeight)
    local pt5 = Polar2D(Polar2D(pt0,   0.0, Carrier.MaterialBlockThickness + (Carrier.DadoAllowance * 0.5)),  90.0, Carrier.MaterialBlockThickness + (Carrier.DadoAllowance * 0.5))
    local pt6 = Polar2D(pt5,   90.0, Carrier.SideHeight - (Carrier.MaterialBlockThickness  * 2) - Carrier.DadoAllowance)
    local pt7 = Polar2D(pt5,    0.0, Carrier.SideLenght - (Carrier.MaterialBlockThickness * 2) - Carrier.DadoAllowance)
    local pt8 = Polar2D(pt7,   90.0, Carrier.SideHeight - (Carrier.MaterialBlockThickness  * 2) - Carrier.DadoAllowance)
    local function DrawBox(job,p1, p2, p3, p4, Layer)
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName(Layer)
      line:AppendPoint(p1)
      line:LineTo(p2)
      line:LineTo(p3)
      line:LineTo(p4)
      line:LineTo(p1)
      layer:AddObject(CreateCadContour(line), true)
      return true
    end -- function end
    -- ======= Draw Part
      DrawBox(job,pt0, pt2, pt3, pt4, "Profile")
      DrawBox(job,Polar2D(pt0, 225.0,0.1), Polar2D(pt2, 135.0,0.1), Polar2D(pt3, 45.0,0.1), Polar2D(pt4, 315.0,0.1), "Pocket")
      DrawBox(job,pt5, pt6, pt8, pt7, "Pocket")
      job:Refresh2DView()
      return true
  end
  -- =====================================================]]
  function DrawTopBottom(job, pt0, Layer)
    local function DrawBox(job,p1, p2, p3, p4, Layer)
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName(Layer)
      line:AppendPoint(p1)
      line:LineTo(p2)
      line:LineTo(p3)
      line:LineTo(p4)
      line:LineTo(p1)
      layer:AddObject(CreateCadContour(line), true)
      return true
    end -- function end

    local function  DrawCircle(Pt1, CenterRadius, Layer, job)
      local pa = Polar2D(Pt1,   180.0, CenterRadius)
      local pb = Polar2D(Pt1,     0.0, CenterRadius)
      local line = Contour(0.0)
      local layer = job.LayerManager:GetLayerWithName(Layer)
      line:AppendPoint(pa)
      line:ArcTo(pb,1)
      line:ArcTo(pa,1)
      layer:AddObject(CreateCadContour(line), true)
      return true
    end
      -- =======]] Calulate Points
    local pt2 = Polar2D(pt0,   90.0, Carrier.TopWidht)
    local pt4 = Polar2D(pt0,    0.0, Carrier.TopLenght)
    local pt3 = Polar2D(pt4,   90.0, Carrier.TopWidht)
    local pt5 = Polar2D(pt0,   90.0, ((Carrier.TopWidht * 0.5) - (Carrier.MaterialBlockThickness * 0.5)) - (Carrier.DadoAllowance * 0.5))
    local pt6 = Polar2D(pt0,   90.0, ((Carrier.TopWidht * 0.5) + (Carrier.MaterialBlockThickness * 0.5)) + (Carrier.DadoAllowance * 0.5))
    local pt7 = Polar2D(pt4,   90.0, ((Carrier.TopWidht * 0.5) - (Carrier.MaterialBlockThickness * 0.5)) - (Carrier.DadoAllowance * 0.5))
    local pt8 = Polar2D(pt4,   90.0, ((Carrier.TopWidht * 0.5) + (Carrier.MaterialBlockThickness * 0.5)) + (Carrier.DadoAllowance * 0.5))
    local pt5a = Polar2D(pt5, 180.0, Carrier.MillingBitRad)
    local pt6a = Polar2D(pt6, 180.0, Carrier.MillingBitRad)
    local pt7a = Polar2D(pt7,   0.0, Carrier.MillingBitRad)
    local pt8a = Polar2D(pt8,   0.0, Carrier.MillingBitRad)

    -- =======]] Draw Part
        DrawBox(job,pt0, pt2, pt3, pt4, "Profile")
      if Layer == "Carrier Top" then -- determine if this drawing requires a dato
        DrawBox(job,pt5a, pt6a, pt8a, pt7a, "Pocket")
      end

      local pta = Polar2D(pt0,  90.0, Carrier.BottleCenterH)
      local ptb = Polar2D(pt2, 270.0, Carrier.BottleCenterH)
      local ptH1 = Polar2D(pta,  0.0, Carrier.BottleGap + (0.5 * Carrier.MaterialBlockThickness) + (0.5 * Carrier.BottleHole))
      local ptH2 = Polar2D(ptb,  0.0, Carrier.BottleGap + (0.5 * Carrier.MaterialBlockThickness) + (0.5 * Carrier.BottleHole))

      for _ = Carrier.OneSide, 1 , -1 do
          if Layer == "Carrier Top" then
            DrawCircle(ptH1, Carrier.BottleHole * 0.5, "Hole", job)
            DrawCircle(ptH2, Carrier.BottleHole * 0.5, "Hole", job)
          else
            DrawCircle(ptH1, Carrier.BottleHole * 0.5, "Pocket", job)
            DrawCircle(ptH2, Carrier.BottleHole * 0.5, "Pocket", job)
          end
        ptH1 = Polar2D(ptH1,  0.0,  Carrier.BottleGap + Carrier.BottleHole)
        ptH2 = Polar2D(ptH2,  0.0,  Carrier.BottleGap + Carrier.BottleHole)
      end
       job:Refresh2DView()
      return true
  end -- function end
  -- =====================================================]]
  function CreateLayerPocketingToolpath(job, name, layer_name, start_depth, cut_depth)
     local selection = job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = job.LayerManager:FindLayerWithName(layer_name)
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
   local tool = Tool(
                    Carrier.MillTool2.Name,
                    Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                    )
   tool.InMM = Carrier.MillTool2.InMM -- tool_in_mm
   tool.ToolDia = Carrier.MillTool2.ToolDia -- tool_dia
   tool.Stepdown = Carrier.MillTool2.Stepdown -- tool_stepdown
   tool.Stepover = Carrier.MillTool2.Stepover -- tool_dia * (tool_stepover_percent / 100)
   tool.RateUnits = Carrier.MillTool2.RateUnits -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
   tool.FeedRate = Carrier.MillTool2.FeedRate -- 30
   tool.PlungeRate = Carrier.MillTool2.PlungeRate -- 10
   tool.SpindleSpeed = Carrier.MillTool2.SpindleSpeed -- 20000
   tool.ToolNumber = Carrier.MillTool2.ToolNumber -- 1
   --tool.VBitAngle = Carrier.MillTool.VBitAngle -- 90.0                -- used for vbit only
   --tool.ClearStepover = Carrier.MillTool.ClearStepover --  tool_dia * (tool_stepover_percent / 100)  -- used for vbit only

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

      -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
      pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION

      -- Allowance to leave on when machining
      pocket_data.Allowance = 0.0

      -- if true use raster clearance strategy , else use offset area clearance
      pocket_data.DoRasterClearance = false --true
      -- angle for raster if using raster clearance
      pocket_data.RasterAngle = 0
      -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
      pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST

      -- if true we ramp into pockets (always zig-zag)
      pocket_data.DoRamping = false
      --  if ramping, distance to ramp over
      pocket_data.RampDistance = 10.0

      -- if true in Aspire, project toolpath onto composite model
      pocket_data.ProjectToolpath = false

   -- Create object which can used to automatically select geometry on layers etc
  local geometry_selector = GeometrySelector()

   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
   local create_2d_previews = true

   -- if this is true we will display errors and warning to the user
   local display_warnings = true

   -- if we are doing two tool pocketing define tool to use for area clearance
   local area_clear_tool = nil

   -- we just create a tool twice as large for testing here
   area_clear_tool = Tool(
                          Carrier.MillTool3.Name,
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )

     area_clear_tool.InMM = Carrier.MillTool3.InMM  -- tool_in_mm
     area_clear_tool.ToolDia = Carrier.MillTool3.ToolDia  -- tool_dia * 2
     area_clear_tool.Stepdown = Carrier.MillTool3.Stepdown  -- tool_stepdown * 2
     area_clear_tool.Stepover = Carrier.MillTool3.Stepover  -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits = Carrier.MillTool3.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate = Carrier.MillTool3.FeedRate  -- 30
     area_clear_tool.PlungeRate = Carrier.MillTool3.PlungeRate  -- 10
     area_clear_tool.SpindleSpeed = Carrier.MillTool3.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber = Carrier.MillTool3.ToolNumber  -- 1
     --area_clear_tool.VBitAngle = Carrier.MillTool3.VBitAngle  -- 90.0                -- used for vbit only
     --area_clear_tool.ClearStepover = Carrier.MillTool3.ClearStepover  -- tool_dia * 2 * (tool_stepover_percent / 100)  -- used for vbit only

   -- Create our toolpath

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
      DisplayMessageBox("Error creating toolpath")
      return false
   end
   return true
end

  -- =====================================================]]
  function CreateLayerProfileToolpath(job,layer_name, name, start_depth, cut_depth, InOrOut, UseTab)
  --  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
    local selection = job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = job.LayerManager:FindLayerWithName(layer_name)
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
    local tool = Tool(Carrier.MillTool1.Name, Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
          tool.InMM =  Carrier.MillTool1.InMM -- tool_in_mm
          tool.ToolDia = Carrier.MillTool1.ToolDia -- tool_dia
          tool.Stepdown = Carrier.MillTool1.Stepdown -- tool_stepdown
          tool.Stepover = Carrier.MillTool1.Stepover --  tool_dia * 0.25
          tool.RateUnits = Carrier.MillTool1.RateUnits -- Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
          tool.FeedRate =  Carrier.MillTool1.FeedRate -- 30
          tool.PlungeRate = Carrier.MillTool1.PlungeRate -- 10
          tool.SpindleSpeed = Carrier.MillTool1.SpindleSpeed -- 20000
          tool.ToolNumber = Carrier.MillTool1.ToolNumber -- 1
          -- tool.VBitAngle = Carrier.MillTool.VBitAngle -- 90.0 -- used for vbit only
          -- tool.ClearStepover = tool_dia * 0.5 -- used for vbit only
  -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(0, 0, 5.0)
          pos_data.SafeZGap = 5.0
  -- Create object used to pass profile options
    local profile_data = ProfileParameterData()
  -- start depth for toolpath
    profile_data.StartDepth = start_depth
    profile_data.CutDepth = cut_depth -- cut depth for toolpath this is depth below start depth
    profile_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION -- direction of cut - ProfileParameterData. CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
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
    profile_data.UseTabs = UseTab -- true to use tabs (position of tabs must already have been defined on vectors)
    profile_data.TabLength = 0.5 -- length for tabs if being used
    profile_data.TabThickness = 0.25
    profile_data.Use3dTabs = true -- if true then create 3d tabs else 2d tabs
    profile_data.ProjectToolpath = false -- if true in Aspire, project toolpath onto composite model
    local ramping_data = RampingData() -- Create object used to control ramping
    local lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
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
  -- =====================================================]]
  function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
  --  Please Note: SelectVectorsOnLayer is provided by Vectric and can be found in the SDK and Sample Gadget files.
  --[[  ---------------- SelectVectorsOnLayer ----------------
  |   SelectVectorsOnLayer("Stringer Profile", selection, true, falus, falus)
  |   Add all the vectors on the layer to the selection
  |     layer,            -- layer we are selecting vectors on
  |     selection         -- selection object
  |     select_closed     -- if true  select closed objects
  |     select_open       -- if true  select open objects
  |     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
  |  Return Values:
  |     true if selected one or more vectors|
  ]]
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
          message = message ..
          "\r\n\r\n" ..
          "If layer contains grouped vectors these must be ungrouped for this script"
          end
          DisplayMessageBox(message)
          warning_displayed = true
        end
        end
        else  -- contour was NOT nil, test if Open or Closed
          if contour.IsOpen and select_open then
            selection:Add(object, true, true)
            objects_selected = true
            else if select_closed then
            selection:Add(object, true, true)
            objects_selected = true
          end
        end -- if end
        end
      end -- while end
      -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
      -- tell selection we have now finished updating
      if objects_selected then
          selection:GroupSelectionFinished()
      end
      return objects_selected
  end
  -- =====================================================]]
  function REG_ReadRegistry(RegName)   -- Read Registry values
    local RegistryRead             = Registry(RegName)
    Carrier.BottleCount            = RegistryRead:GetInt("Carrier.BottleCount",               6.00000)
    Carrier.BottleDia              = RegistryRead:GetDouble("Carrier.BottleDia",              2.50000)
    Carrier.BottleHeight           = RegistryRead:GetDouble("Carrier.BottleHeight",          11.00000)
    Carrier.BottleSideHeight       = RegistryRead:GetDouble("Carrier.BottleSideHeight",       4.00000)
    Carrier.MaterialBlockThickness = RegistryRead:GetDouble("Carrier.MaterialBlockThickness", 0.75000)
    Carrier.DadoAllowance          = RegistryRead:GetDouble("Carrier.DadoAllowance",          0.06125)
    Carrier.BottleClearance        = RegistryRead:GetDouble("Carrier.BottleClearance",        0.12500)
    Carrier.HandleTop              = RegistryRead:GetDouble("Carrier.HandleTop",              1.50000)
    Carrier.BottleGap              = RegistryRead:GetDouble("Carrier.BottleGap",              0.50000)
    Carrier.HandleLength           = RegistryRead:GetDouble("Carrier.HandleLength",           6.00000)
    Carrier.HandleHoleSize         = RegistryRead:GetDouble("Carrier.HandleHoleSize",         1.25000)
    Carrier.PartGap                = RegistryRead:GetDouble("Carrier.PartGap",                1.00000)
    Carrier.ThicknessTop           = RegistryRead:GetDouble("Carrier.ThicknessTop)",          0.50000)
    Carrier.ThicknessEnd           = RegistryRead:GetDouble("Carrier.ThicknessEnd)",          0.75000)
    Carrier.ThicknessSide          = RegistryRead:GetDouble("Carrier.ThicknessSide)",         0.50000)
    Carrier.ThicknessBottom        = RegistryRead:GetDouble("Carrier.ThicknessBottom)",       0.50000)
    Carrier.ThicknessHandle        = RegistryRead:GetDouble("Carrier.ThicknessHandle)",       0.50000)
    Carrier.Tabs                   = RegistryRead:GetBool("Carrier.Tabs",                     true)
  end
-- =====================================================]]
  function REG_UpdateRegistry(RegName) -- Write Registry values
    local RegistryWrite = Registry(RegName)
    local RegValue = RegistryWrite:SetInt("Carrier.BottleCount",                Carrier.BottleCount)
          RegValue = RegistryWrite:SetBool("Carrier.Tabs",                      Carrier.Tabs)
          RegValue = RegistryWrite:SetDouble("Carrier.BottleDia",               Carrier.BottleDia)
          RegValue = RegistryWrite:SetDouble("Carrier.BottleHeight",            Carrier.BottleHeight)
          RegValue = RegistryWrite:SetDouble("Carrier.BottleSideHeight",        Carrier.BottleSideHeight)
          RegValue = RegistryWrite:SetDouble("Carrier.MaterialBlockThickness",  Carrier.MaterialBlockThickness)
          RegValue = RegistryWrite:SetDouble("Carrier.DadoAllowance",           Carrier.DadoAllowance)
          RegValue = RegistryWrite:SetDouble("Carrier.BottleClearance",         Carrier.BottleClearance)
          RegValue = RegistryWrite:SetDouble("Carrier.HandleLength",            Carrier.HandleLength)
          RegValue = RegistryWrite:SetDouble("Carrier.HandleHoleSize",          Carrier.HandleHoleSize)
          RegValue = RegistryWrite:SetDouble("Carrier.HandleTop",               Carrier.HandleTop)
          RegValue = RegistryWrite:SetDouble("Carrier.BottleGap",               Carrier.BottleGap)
          RegValue = RegistryWrite:SetDouble("Carrier.PartGap",                 Carrier.PartGap)
          RegValue = RegistryWrite:SetDouble("Carrier.ThicknessTop",            Carrier.ThicknessTop)
          RegValue = RegistryWrite:SetDouble("Carrier.ThicknessEnd",            Carrier.ThicknessEnd)
          RegValue = RegistryWrite:SetDouble("Carrier.ThicknessSide",           Carrier.ThicknessSide)
          RegValue = RegistryWrite:SetDouble("Carrier.ThicknessBottom",         Carrier.ThicknessBottom)
          RegValue = RegistryWrite:SetDouble("Carrier.ThicknessHandle",         Carrier.ThicknessHandle)
  --        RegValue = RegistryWrite:SetString("Carrier.ProfileBit",              Carrier.ProfileBit)
          RegValue = RegistryWrite:SetString("Carrier.Dialog_X",                Carrier.Dialog_X)
          RegValue = RegistryWrite:SetString("Carrier.Dialog_Y",                Carrier.Dialog_Y)


    return true
  end

  -- =====================================================]]
function main()

  Carrier.Name = "Easy Bottle Carrier Maker"
  Carrier.Version = "09-4.0"
  Carrier.AppVersion = "Version " .. Carrier.Version
  Carrier.RegName = "EasyBottleCarrierMaker" .. Carrier.Version
  Carrier.g_pt1 = Point2D(1.0, 1.0)
  Carrier.DialogLoop = true
  Carrier.AppVer = GetAppVersion()

  -- Job Validation --
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n"
                    )
    return false
  end
  Carrier.DoubleSided = job.IsDoubleSided
  if not Carrier.DoubleSided then  --
    DisplayMessageBox("Error: The Job must be a double sided job /n" ..
                      " to alow V-Carving on both faces /n")
    return false
  end
-- =====================================================]]
--  Call Read registry  --
  REG_ReadRegistry(Carrier.RegName)
  -- =====================================================]]
--  Call Display dialogue --
  while Carrier.DialogLoop do
    Carrier.Inquiry = CarrierDialog(Carrier.Name .. " (Ver: " .. Carrier.Version .. ")") -- If the user selects the OK button
    if Carrier.Inquiry then
      Carrier.DialogLoop = false
      CheckDialogValues(true)
    else
      Carrier.DialogLoop = false
    end -- if end
  end -- while end
  if Carrier.Inquiry then
    -- =====================================================]]
    --  Call Calculate values --
    CarrierMath()
    -- =====================================================]]
    --  Call Write registry  --
    REG_UpdateRegistry(Carrier.RegName)
    -- =====================================================]]
    --  Draw the components  --
    -- =====================================================]]
    --  Call Draw ends function --
    DrawEnd(job, Carrier.g_pt1, "Carrier End 1")
    DrawEnd(job, Carrier.g_pt3, "Carrier End 2")
    --  ====================]]
    --  Call Draw handle function --
    DrawHandle(job, Carrier.g_pt2, "Carrier Handle")
    --  ====================]]
    --  Call Draw sides function --
    DrawSide(job, Carrier.g_pt4, "Carrier Side 1")
    DrawSide(job, Carrier.g_pt5, "Carrier Side 2")
    --  ====================]]
    --  Call Draw top & bottom function --
    DrawTopBottom(job, Carrier.g_pt6, "Carrier Top")
    DrawTopBottom(job, Carrier.g_pt7, "Carrier Bottom")
    --  ====================]]
    -- Tool Path
    local toolpath_mgr = ToolpathManager()
    if toolpath_mgr.Count >0 then
      toolpath_mgr:DeleteAllToolpaths()
    end
    if (type(Carrier.MillTool2) == "userdata" and type(Carrier.MillTool3) == "userdata") then
      CreateLayerPocketingToolpath(job, "Pocket" , "Pocket" , 0.0, (Carrier.MaterialBlockThickness * 0.5))
    end -- if end
    if type(Carrier.MillTool1) == "userdata" then
      CreateLayerProfileToolpath(job,   "Hole"   , "Hole"   , 0.0, Carrier.MaterialBlockThickness        , "IN" , Carrier.Tabs)
      CreateLayerProfileToolpath(job,   "Profile", "Profile", 0.0, Carrier.MaterialBlockThickness        , "OUT", Carrier.Tabs)
    end -- if end
  end -- if end
    job:Refresh2DView()       -- refresh the graphics to display the new objects.
  return true
end  -- function end
-- =====================================================]]
function MarkPoint(Note, Pt, Size, LayerName)
  --[[
     |Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
     |Draws mark on the drawing
     |call = MarkPoint("Note: Hi", Pt1, 3, "Jim")
   ]]
      local function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
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
        local layer = job.LayerManager:GetLayerWithName(LayerName)
        layer:AddObject(CreateCadContour(line), true)
        return true
      end -- function end
    local job = VectricJob()
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    local marker1 = CadMarker(Note, Pt, Size)
    layer:AddObject(marker1, true)
    DrawCircle(job, Pt, 0.25, LayerName)
  return true
end -- function end
-- =====================================================]]

-- =====================================================]]