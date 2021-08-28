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

 -- Easy Dovetail Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ===================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
local Dovetail = {}
local Tools = {}
local lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
if GetAppVersion() >= 10.0 then
  Dovetail.AppValue = true
  -- lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
  Tool_ID = ToolDBId()
  Tool_ID:LoadDefaults("My Toolpath1", "")
else
  Dovetail.AppValue = false
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
function RegistryRead()                                 -- Read from Registry values
  local RegistryRead = Registry(Dovetail.RegName)
  if not(RegistryRead:StringExists("Dovetail.CodeBy")) then
    RegistryLoad()
  end
  Dovetail.FingerFit             = RegistryRead:GetDouble("Dovetail.FingerFit",             0.010)
  Dovetail.User                  = RegistryRead:GetDouble("Dovetail.User",                  2)
  Dovetail.ToolDia               = RegistryRead:GetDouble("Dovetail.ToolDia",               0.2500)
  Dovetail.LayerNameFrontBroad   = RegistryRead:GetString("Dovetail.LayerNameFrontBroad",   "Front - Broad")
  Dovetail.LayerNameSideBroad    = RegistryRead:GetString("Dovetail.LayerNameSideBroad",    "Side - Broad")
  Dovetail.LayerNameFrontPocket  = RegistryRead:GetString("Dovetail.LayerNameFrontPocket",  "Front - Pockets")
  Dovetail.LayerNameDovetailPath = RegistryRead:GetString("Dovetail.LayerNameDovetailPath", "Side - Tail Dovetail Path")
  Dovetail.LayerNameClearing     = RegistryRead:GetString("Dovetail.LayerNameClearing",     "Side - Tail Clearing")
  Dovetail.CodeBy                = RegistryRead:GetString("Dovetail.CodeBy",                "James Anderson")
  Dovetail.ProgramName           = RegistryRead:GetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
  Dovetail.Version               = RegistryRead:GetString("Dovetail.Version",               "0.0")
  Dovetail.ProgramYear           = RegistryRead:GetString("Dovetail.ProgramYear",           "2020")
  Dovetail.ToolPathPins          = RegistryRead:GetString("Dovetail.ToolPathPins",          "Pins")
  Dovetail.ToolPathTail          = RegistryRead:GetString("Dovetail.ToolPathTail",          "Tails")
  Dovetail.ToolPathClearing      = RegistryRead:GetString("Dovetail.ToolPathClearing",      "Tail_Clearing")
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
        RegValue = RegistryWrite:SetString("Dovetail.CodeBy",                "James Anderson")
        RegValue = RegistryWrite:SetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
        RegValue = RegistryWrite:SetString("Dovetail.Version",               Dovetail.Version)
        RegValue = RegistryWrite:SetString("Dovetail.ProgramYear",           "2020")
        RegValue = RegistryWrite:SetString("Dovetail.Units",                 Dovetail.Units)
        RegValue = RegistryWrite:SetDouble("Dovetail.FingerFit",             Dovetail.FingerFit)
        RegValue = RegistryWrite:SetDouble("Dovetail.User",                  Dovetail.User)
        RegValue = RegistryWrite:SetDouble("Dovetail.ToolDia",               Dovetail.ToolDia)
 	return true
end
-- ===================================================]]
function RegistryLoad()                                 -- Load Registry with values
  local RegistryWrite = Registry(Dovetail.RegName)
  local RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontBroad",   "Front - Tail Broad")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSideBroad",    "Side - Pin Broad")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameDovetailPath", "Side - Tail Dovetail Path")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameClearing",     "Side - Dovetail Clearing")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontPocket",  "Front - Pin Pockets")
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathPins",          "Front - Pins")
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathTail",          "Side - Tails")
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathClearing",      "Side - Tail Clearing")
        RegValue = RegistryWrite:SetString("Dovetail.CodeBy",                "James Anderson")
        RegValue = RegistryWrite:SetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
        RegValue = RegistryWrite:SetString("Dovetail.Version",               Dovetail.Version)
        RegValue = RegistryWrite:SetString("Dovetail.ProgramYear",           "2020")
        RegValue = RegistryWrite:SetDouble("Dovetail.FingerFit",             0.010)
        RegValue = RegistryWrite:SetDouble("Dovetail.User",                  3.0)
        RegValue = RegistryWrite:SetDouble("Dovetail.ToolDia",               0.2500)
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
    Dovetail.ToolTable = [[<table width="550" border="0"> <tr> <td height="20" align="right" nowrap class="titles"><strong>Select Stright Bit</strong></td>  <td height="20" colspan="2" align="right" nowrap class="h1-l"><hr></td> </tr> <tr><td width="89" align="right" nowrap class="h1-l">Stright Bit:</td><td width="100%" nowrap="nowrap" class="ToolNameLabel"><span class="ToolNameLabel" id = "ToolNameLabel">-</span></td><td width="51" nowrap class="ToolPicker" id="ToolChooseButton"><strong><input name = "ToolChooseButton" id="ToolChooseButton" type = "button" class = "ToolPicker" value = "Tool"></strong></td></tr></table>]]
  else
    Dovetail.ToolTable = [[<table width="550" border="0"><tr>  <td width="18%" height="17" align="right" nowrap class="titles"><strong>Enter Stright Bit</strong></td>  <td width="82%" align="right" nowrap class="h1-l"><hr></td></tr><tr><td align="right" nowrap class="h1-rP"> <p>Bit Diameter</p></td> <td align="right" nowrap class="h1-l"><input name="Dovetail.ToolDia" type="text" id="Dovetail.ToolDia" size="12"></td></tr></table>]]
  end --if end

local myHtml = [[<html> <head> <title>Dovetail Toolpath Creator</title> <style type="text/css">html{overflow:hidden} .helpbutton{background-color:#E1E1E1; border:1px solid #999; border-right-color:#000; border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF; padding:2px 12px; font-family:Arial, Helvetica, sans-serif; text-align:center; text-decoration:none; font-size:12px; margin:4px 2px; color:#000}.helpbuttonx{ background-color:##E1E1E1; border:1px solid #999; font-family:Arial,Helvetica,sans-serif; text-align:center; text-decoration:none; display:inline-block; font-size:12px; margin:40px 20px; cursor:pointer; color:#000; padding:2px 12px} .helpbutton:active{ border-right-color:#FFF; border-bottom-color:#FFF; border-top-color:#000; border-left-color:#000} .helpbutton:hover{border-right-color:#000; border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF} .LuaButton{font-weight:bold; font-family:Arial,Helvetica,sans-serif; font-size:12px} .DirectoryPicker{ font-weight:bold; font-family:Arial, Helvetica, sans-serif; font-size:12px} .ToolPicker{font-weight:bold; text-align:center; font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:center; width:50px} .ToolNameLabel{ font-family:Arial,Helvetica,sans-serif; font-weight:bolder; font-size:14px; text-align:left; color:#0000FF} .FormButton{ font-weight:bold; width:75px; font-family:Arial, Helvetica, sans-serif; font-size:12px; white-space:nowrap} .h1-l{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:left; white-space:nowrap} .h2-l{ font-family:Arial,Helvetica,sans-serif; font-size:12px; text-align:left} .h1-r{ font-family:Arial,Helvetica, sans-serif; font-size:12px; text-align:right; white-space:nowrap} .h1-rP{ font-family:Arial,Helvetica,sans-serif; font-size:12px; text-align:right; white-space:nowrap; padding-right:4px; padding-left:4px}.h1-rPx{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:right; white-space:nowrap; padding-right:8px; padding-left:8px}.titles{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:left; white-space:nowrap; padding-right:12px; padding-left:4px}.alert{ font-family:Arial,Helvetica,sans-serif; font-size:12px; font-weight:bold; color:#00F; text-align:center; white-space:nowrap} .h1-c{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:center; white-space:nowrap} .header1-c{ font-family:Arial, Helvetica, sans-serif; font-size:16px; font-weight:bold; text-align:center; white-space:nowrap} .header2-c{ font-family:Arial, Helvetica, sans-serif; font-size:14px; font-weight:bold; text-align:center; white-space:nowrap} body{ background-color:#CCC; overflow:hidden; font-family:Arial,Helvetica,sans-serif; font-size:12px}</style> </head> <body><table width="550" border="0" class="h2-l"> <tr> <td rowspan="2"><p class="h2-l">This gadget creates a drawing and tool paths for a Dovetail joint from the material job settings and user inputs.</p> <p class="h2-l">This requires the material to be held in the <strong>vertical position </strong> so that the milling can be performed on the end of the stock to receive the specified joinery.</p> <p class="h2-l">The gadget uses the Job Setup Seeting to deturmen the stock oreintation. Milling will run in the direction of the longest side of the material job and the material is a rectangle in shape.</p> <p class="h2-l">Use the Top of material (top end of material) for the Z value. Set the materialthickness to the length of material.</p> <p class="h2-l">For best results in cutting Pins and Clearing path, use &quot; up-cut&quot; spiral bits.</p></td> <td width="28%" class="h1-rPx" id="Dovetail.Version">-</td> </tr> <tr> <td><img src= data:image/jpeg;base64,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 width="200" height="204"></td> </tr></table><table width="550" border="0"><tr> <td width="110" class="titles"><strong>Select Dovetail Bit</strong></td> <td width="440"><hr></td></tr><tr> <th height = "20" colspan="2"><select name = "ListBox" class = "h1-c" id = "ListBox"> <option>Defalt</option> </select> </th></tr></table>]] .. Dovetail.ToolTable .. [[<table width="550" border="0"> <tr> <td width="55" class="titles"><strong>Job Data</strong></td> <td width="485"><hr></td> </tr></table><table width="550" border="0"> <tr> <td width="100%" id="Dovetail.DrawingData" class="h1-c">-</td> </tr> <tr> <td class="h1-c"><hr></td> </tr></table><table width="550" border="0"> <tr> <td width="146" class="h1-rP">Pocket Material Thickness</td> <td width="112"><span class="h1-l"> <input name="Dovetail.FrontThickness" type="text" id="Dovetail.FrontThickness" size="9"> </span></td> <td colspan="2" class="h1-c"><input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Edit Layers"></td>   </tr> <tr> <td class="h1-rP">Socket Material Thickness</td> <td><span class="h1-l"> <input name="Dovetail.SideThickness" type="text" id="Dovetail.SideThickness" size="9"> </span></td> <td colspan="2" align="center"><span class="h1-c"> DrawingUnits </span></td> </tr> <tr> <td class="h1-rP">Dovetail Deptht</td> <td><span class="h1-l"> <input id="Dovetail.User" name="Dovetail.User" size="9" type="text"> </span></td> <td width="58"><span class="h1-l"><span class="h1-c"><span style="width: 15%"> <input id = "ButtonCalulate" class = "LuaButton" name = "ButtonCalulate" type = "button" value = "Calulate"> </span></span></span></td> <td width="216">&nbsp;</td> </tr> <tr> <td class="h1-rP">Fit Amount</td> <td><span class="h1-l"> <input name="Dovetail.FingerFit" type="text" id="Dovetail.FingerFit" size="9"> </span></td> <td colspan="2" id="Dovetail.TailNote" class="h1-c">TailNote</td> </tr> <tr> <td class="h1-rP" id="Dovetail.Tail">Centerlines selected</td> <td><span class="h1-l"> <input name="Dovetail.TailValue" type="text" disabled id="Dovetail.TailValue" size="9" readonly> </span></td> <td colspan="2" id="Dovetail.PinNote" class="h1-c">PinNote </td> </tr></table><table width="550" border="0" id="ButtonTable"><tr><td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"> <hr> </td> </tr><tr> <td width="57"> <strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_Dovetail_Maker-Page1" target="_blank" class="helpbutton">Help</a> </strong> </td> <td width="325"><span class="alert" id="Dovetail.Alert">.</span></td><td width="75" class="FormButton"> <span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td><td width="75" class="FormButton"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span> </td> </tr> </table> </body> </html>]]
  Dovetail.MatLine = "Material = " .. Dovetail.MaterialThickness .." x " .. Dovetail.MaterialLength .. " | Drawn in the " .. Dovetail.OrantationX .. " | XY Datum Position = " .. Dovetail.Origin
  Dovetail.dialog = HTML_Dialog(true, myHtml, 587, 680, "Easy Dovetail Maker")
  Dovetail.dialog:AddLabelField("Dovetail.Alert", "")
  Dovetail.dialog:AddLabelField("Dovetail.PinNote",            "Dovetail Size = " )
  Dovetail.dialog:AddLabelField("Dovetail.TailNote",           "Dovetail Centers = ")
  Dovetail.dialog:AddLabelField("Dovetail.AppName",            Dovetail.AppName)
  Dovetail.dialog:AddLabelField("Dovetail.Version",            "Version: " ..  Dovetail.Version )
  Dovetail.dialog:AddLabelField("Dovetail.Units",              Dovetail.Units)
  Dovetail.dialog:AddLabelField("Dovetail.DrawingData",        Dovetail.MatLine)
  Dovetail.dialog:AddLabelField("Dovetail.Tail",               "Tail Size")
  Dovetail.dialog:AddDoubleField("Dovetail.TailValue", 	       Dovetail.DovetailCenters)
  Dovetail.dialog:AddDoubleField("Dovetail.FingerFit", 	       Dovetail.FingerFit)
  Dovetail.dialog:AddDoubleField("Dovetail.User",              Dovetail.User)
  Dovetail.dialog:AddDoubleField("Dovetail.FrontThickness",    Dovetail.FrontThickness)
  Dovetail.dialog:AddDoubleField("Dovetail.SideThickness",     Dovetail.SideThickness)

  if Dovetail.AppValue then
    Dovetail.dialog:AddLabelField("ToolNameLabel",            "Not Selected")
    Dovetail.dialog:AddToolPicker("ToolChooseButton",         "ToolNameLabel", Tool_ID)
    Dovetail.dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
  else
    Dovetail.dialog:AddDoubleField("Dovetail.ToolDia", 	         Dovetail.ToolDia)
  end -- if end
  Dovetail.dialog:AddDropDownList("ListBox", Dovetail.DovetailSelectedTool) ;
  for _, value in pairs(Tools) do
    Dovetail.dialog:AddDropDownListValue("ListBox", value) ;
  end ;
  if  Dovetail.dialog:ShowDialog() then
    --Dovetail.DovetailSelectedTool = Dovetail.dialog:GetDropDownListValue("ListBox")
    --GetToolData(Dovetail.ToolPath, "DovetailTool.ini", string.upper(Dovetail.DovetailSelectedTool))
    Dovetail.InquiryDovetailX = Dovetail.dialog.WindowWidth
    Dovetail.InquiryDovetailY = Dovetail.dialog.WindowHeight
    RegistryWrite()
    MyReturn = true
  end
  return MyReturn
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
function Dovetail_MillingPath()
  local A, B, C, D = Point2D(0, 0)
  local MillDepth = Dovetail.SideThickness + Dovetail.DovetailToolDia + 0.125
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameDovetailPath)
  local line = Contour(0.0)
  -- Starting Point
  Dovetail.pt01 = Polar2D(Dovetail.g_pt1, Dovetail.Direction4, Dovetail.DovetailToolRadius + 0.125 )
  -- Ending Point
  Dovetail.pt02 = Polar2D(Dovetail.pt01, Dovetail.Direction4, 0.125)
  -- Startup Path building
  line:AppendPoint(Dovetail.pt01); line:LineTo(Dovetail.pt01)
  Dovetail.ptx = Polar2D(Dovetail.pt01, Dovetail.Direction1,  Dovetail.DovetailCenters)
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
function Dovetail_Tails()                               -- Side Borad
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad)
  local xpt2 = Polar2D(Dovetail.g_pt1,  Dovetail.Direction2,  Dovetail.SideThickness)
  local xpt3 = Polar2D(xpt2,  Dovetail.Direction1, Dovetail.MaterialLength)
  local xpt4 = Polar2D(Dovetail.g_pt1,  Dovetail.Direction1,  Dovetail.MaterialLength)
  local line = Contour(0.0)
  line:AppendPoint(Dovetail.g_pt1); line:LineTo(xpt2); line:LineTo(xpt3); line:LineTo(xpt4); line:LineTo(Dovetail.g_pt1)
  layer:AddObject(CreateCadContour(line), true)
  Dovetail.ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  for _ = Dovetail.PathCount - 1, 1 , -1     do
    DovetailPockets(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
 DovetailPocketsEnds()
  return true
end
-- ===================================================]]
function Dovetail_Pins()                                -- Front Borad
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontBroad)
  local xpt2 = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.FrontThickness)
  local xpt3 = Polar2D(xpt2, Dovetail.Direction1, Dovetail.MaterialLength)
  local xpt4 = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.MaterialLength)
  local line = Contour(0.0); line:AppendPoint(Dovetail.g_pt1); line:LineTo(xpt2); line:LineTo(xpt3); line:LineTo(xpt4)
  line:LineTo(Dovetail.g_pt1);  layer:AddObject(CreateCadContour(line), true)
  local ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.DovetailCenters )
  local tx = Dovetail.MaterialLength
  for _ = Dovetail.TailCount , 1 , -1   do
    Dovetails(ptx)
    ptx = Polar2D(ptx, Dovetail.Direction1, Dovetail.DovetailCenters + Dovetail.DovetailCenters )
    tx = tx - (Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
  return true
end
-- ===================================================]]
function DovetailPockets(xpt1)                          -- Front Borad
    local xpt2  = Polar2D(xpt1,   Dovetail.Direction2,  Dovetail.FrontThickness)
    local xpt3  = Polar2D(xpt2,   Dovetail.Direction1,  Dovetail.ClearingTopAmount * 0.5)
    local xpt4  = Polar2D(xpt2,   Dovetail.Direction3,  Dovetail.ClearingTopAmount * 0.5)
    local xpt3a = Polar2D(xpt3,   Dovetail.Mider1,  Dovetail.Dist1)
    local xpt4a = Polar2D(xpt4,   Dovetail.Mider2,  Dovetail.Dist1)
    local xpt3b = Polar2D(xpt3a,  Dovetail.Mider3,  Dovetail.Dist2)
    local xpt4b = Polar2D(xpt4a,  Dovetail.Mider4,  Dovetail.Dist2)
    local layera = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontPocket)
    local linea = Contour(0.0)
    linea:AppendPoint(xpt3a); linea:LineTo(xpt3b); linea:LineTo(xpt4b); linea:LineTo(xpt4a); linea:LineTo(xpt3a)
    layera:AddObject(CreateCadContour(linea), true)
  return true
end
-- ===================================================]]
function Dovetails(pt1)                                 -- Side Borad
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
function DovetailPocketsEnds()                          -- Front Borad
    local pt01  = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.FrontThickness * 0.5)
  local pt01a = Polar2D(pt01,          Dovetail.Direction1, Dovetail.ClearingTopAmount * 0.5)
  local pt01b = Polar2D(pt01a,          Dovetail.Direction2, Dovetail.FrontThickness * 0.5)
  local pt02  = Polar2D(Dovetail.g_pt1, Dovetail.Direction2, Dovetail.FrontThickness)
  local pt02a = Polar2D(pt02,           Dovetail.Direction2, Dovetail.StrightToolDia)
  local pt02b = Polar2D(Dovetail.g_pt1, Dovetail.Direction4, Dovetail.StrightToolDia)
  local pt02x = Polar2D(pt01b, Dovetail.Mider1,  Dovetail.Dist1)
  local pt03x = Polar2D(pt02a, Dovetail.Direction3, Dovetail.StrightToolDia)
  local pt04x = Polar2D(pt02b, Dovetail.Direction3, Dovetail.StrightToolDia)
  local pt01x = Polar2D(pt02x, Dovetail.Mider3,  Dovetail.Dist2)

  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontPocket)
  local line = Contour(0.0)
  line:AppendPoint(pt01x); line:LineTo(pt02x); line:LineTo(pt03x); line:LineTo(pt04x); line:LineTo(pt01x); layer:AddObject(CreateCadContour(line), true)

  pt01  = Polar2D(Dovetail.g_pt2, Dovetail.Direction2, Dovetail.FrontThickness * 0.5)
  pt02  = Polar2D(Dovetail.g_pt2, Dovetail.Direction2, Dovetail.FrontThickness)
  pt01a = Polar2D(pt01,          Dovetail.Direction3, Dovetail.ClearingTopAmount * 0.5)
  pt01b = Polar2D(pt01a,          Dovetail.Direction2, Dovetail.FrontThickness * 0.5)
  pt02a = Polar2D(pt02,           Dovetail.Direction2, Dovetail.StrightToolDia)
  pt02b = Polar2D(Dovetail.g_pt2, Dovetail.Direction4, Dovetail.StrightToolDia)
  pt02x = Polar2D(pt01b, Dovetail.Mider2,  Dovetail.Dist1)
  pt03x = Polar2D(pt02a, Dovetail.Direction1, Dovetail.StrightToolDia)
  pt04x = Polar2D(pt02b, Dovetail.Direction1, Dovetail.StrightToolDia)
  pt01x = Polar2D(pt02x, Dovetail.Mider4,  Dovetail.Dist2)
  layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontPocket)
  line = Contour(0.0); line:AppendPoint(pt01x); line:LineTo(pt02x); line:LineTo(pt03x); line:LineTo(pt04x); line:LineTo(pt01x)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function GetToolData(xPath, xFile, xGroup)
    Dovetail.Brand      = GetIniValue(xPath, xFile, xGroup, "Brand", "S")
    Dovetail.PartNo     = GetIniValue(xPath, xFile, xGroup, "PartNo", "S")
    Dovetail.DovetailToolAngle = GetIniValue(xPath, xFile, xGroup, "BitAngle", "N")
    Dovetail.ShankDia          = GetIniValue(xPath, xFile, xGroup, "ShankDia", "N")
    Dovetail.DovetailToolDia   = GetIniValue(xPath, xFile, xGroup, "BitDia", "N")
    Dovetail.Flutes     = GetIniValue(xPath, xFile, xGroup, "Flutes", "N")
    Dovetail.Type       = GetIniValue(xPath, xFile, xGroup, "Type", "S")
    Dovetail.BitLength  = GetIniValue(xPath, xFile, xGroup, "BitLength", "N")
    Dovetail.CutDepth   = GetIniValue(xPath, xFile, xGroup, "CutDepth", "N")
    Dovetail.RPM        = GetIniValue(xPath, xFile, xGroup, "RPM", "N")
    Dovetail.FeedRate   = GetIniValue(xPath, xFile, xGroup, "FeedRate", "N")
    Dovetail.PlungRate  = GetIniValue(xPath, xFile, xGroup, "PlungRate", "N")
    Dovetail.Units      = GetIniValue(xPath, xFile, xGroup, "Units", "S")
    Dovetail.Rates      = GetIniValue(xPath, xFile, xGroup, "Rates", "S")
    Dovetail.Notes      = GetIniValue(xPath, xFile, xGroup, "Notes", "S")
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
function GetIniValue(xPath, FileName, GroupName, ItemName, ValueType)
   local filenameR = xPath .. "/" .. FileName
   local FL = LengthOfFile(filenameR)
   local file = io.open(filenameR, "r")
   local dat = "."
   local ItemNameLen = string.len(ItemName) ;
   local sad = "[" .. string.upper(GroupName) .. "]"
   while (FL >= 1) do
      dat = string.upper(All_Trim(file:read())) ;
      if dat == sad then
         break
      else
         FL = FL - 1
      end -- if end
   end -- while end
   while (FL >= 1) do
      dat = All_Trim(file:read()) ;
      if ItemName == string.sub(dat, 1, ItemNameLen)  then
         break
      else
         FL = FL - 1
         if FL == 0 then
            dat = "Error - item not  found"
            break
         end -- if end
      end -- if end
   end -- while end
   file:close()-- closes the open file
   local XX = StrIniValue(dat, ValueType)
   return XX
  end -- function end
-- ===================================================]]
function All_Trim(s)                                    -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function FileExists(name)
  -- DisplayMessageBox(name)
    local f = io.open(name,"r")
    if f ~= nil then
       io.close(f)
       return true
    else
       return false
    end
  end
-- ===================================================]]
function ToolHeaderReader(xPath)
  --[[
      Reads the INI Header values of a ini file and loads values to Array
      Tools = {} Global variables
      xPath = script_path
   ]]
    -- ===========]]
    local filename = xPath .. "/DovetailTool.ini"
    local file = io.open(filename, "r")
    local FileLen = (LengthOfFile(filename) - 1)
    local dat = All_Trim(file:read())
    while (FileLen >= 1) do
      if "[" == string.sub(dat, 1, 1) then
        table.insert (Tools, string.sub(dat, 2, (string.len(dat) - 1)))
      end
      dat = file:read()
      if dat then
        dat = All_Trim(dat)
      else
        return true
      end
      FileLen = FileLen - 1
    end
    file:close()-- closes the open file
    return true
end
-- ===================================================]]
function LengthOfFile(filename)                         -- Returns file line count
  --[[
     Counts the lines in a file
     Returns: number
    ]]
    local len = 0
    if FileExists(filename) then
      local file = io.open(filename)
      for _ in file:lines() do
        len = len + 1
      end
      file:close() ;
    end
   return len
 end
-- ===================================================]]
function OnLuaButton_ButtonCalulate()                   -- Executes the Validation and some calculations from the dialogue
  --Dovetail.TailCalc = Dovetail.dialog:GetDropDownListValue("Dovetail.List")
  Dovetail.FrontThickness = Dovetail.dialog:GetDoubleField("Dovetail.FrontThickness")
  Dovetail.SideThickness = Dovetail.dialog:GetDoubleField("Dovetail.SideThickness")
  Dovetail.FingerFit  = Dovetail.dialog:GetDoubleField("Dovetail.FingerFit")
  Dovetail.dialog:UpdateLabelField("Dovetail.Tail", "Tail Size")
  Dovetail.TailCount = math.floor(Dovetail.dialog:GetDoubleField("Dovetail.User"))
  Dovetail.DovetailCount = Dovetail.TailCount + Dovetail.TailCount
  Dovetail.dialog:UpdateDoubleField("Dovetail.User", Dovetail.TailCount)
  Dovetail.TailSize = Dovetail.MaterialLength / Dovetail.DovetailCount
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
          GetToolData(Dovetail.ToolPath, "DovetailTool.ini", string.upper(Dovetail.DovetailBitName))
          Dovetail.StrightToolDia = Dovetail.StrightTool.ToolDia
          Dovetail.User = Dovetail.dialog:GetDoubleField("Dovetail.User")
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
         -- Dovetail.DovetailBitName = Dovetail.dialog:GetDropDownListValue("ListBox")
          Dovetail.StrightToolDia  = Dovetail.StrightTool.ToolDia
          Dovetail.Dist1 = Dovetail.StrightToolDia / math.cos(math.rad(Dovetail.DovetailToolAngle ))
          Dovetail.Dist2 = (Dovetail.FrontThickness+(Dovetail.StrightToolDia * 2)) / math.cos(math.rad(Dovetail.DovetailToolAngle ))
          if Dovetail.CutDepth < Dovetail.FrontThickness then
            Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Dovetail Cutdepth is less than Front Thickness")
            Dovetail.MillingApproved = false
          else
            if Dovetail.User < 1 then
              Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Finger Count cannot be less than 1")
              Dovetail.MillingApproved = false
            else
              Dovetail.DoveBitOverCut = Dovetail.FrontThickness * math.tan(math.rad(Dovetail.DovetailToolAngle))
              -- Clearing Amount for Joint
              Dovetail.ClearingTopAmount = (Dovetail.MaterialLength / (Dovetail.DovetailCount)) - Dovetail.DoveBitOverCut
              Dovetail.MinClearingWidth = Dovetail.DovetailToolDia - (2 *  Dovetail.FrontThickness * math.tan(math.rad(Dovetail.DovetailToolAngle)))
              Dovetail.ClearingBottomLength = Dovetail.MaterialLength  / ((Dovetail.DovetailCount + 1) - math.tan(math.rad(Dovetail.DovetailToolAngle)))
              Dovetail.MillGap = (0.5 *  (Dovetail.FingerFit + (Dovetail.ClearingTopAmount - Dovetail.MinClearingWidth)))
              -- MessageBox("Dovetail.MillGap = " .. tostring(Dovetail.MillGap))
              if Dovetail.ClearingTopAmount < Dovetail.StrightToolDia then
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Stright Bit Size")
                  Dovetail.MillingApproved = false
              else
                if Dovetail.MinClearingWidth > Dovetail.ClearingTopAmount then
                  Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Tail Count or Dovetail Bit Size")
                  Dovetail.MillingApproved = false
                else
                  Dovetail.PinCount =  Dovetail.TailCount
                  Dovetail.DovetailCount =  Dovetail.TailCount + Dovetail.PinCount
                  Dovetail.DovetailCenters = Rounder(Dovetail.MaterialLength / Dovetail.DovetailCount, 4)
                  Dovetail.PinStart =  Dovetail.DovetailCenters * 0.5
                  Dovetail.dialog:UpdateDoubleField("Dovetail.TailValue", Dovetail.DovetailCenters)
                   Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
                  Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "Dovetail Center = " .. Rounder(Dovetail.DovetailCenters * 2.0, 4))
                  Dovetail.dialog:UpdateLabelField("Dovetail.PinNote",  "Dovetail Top = "    .. Rounder(Dovetail.ClearingTopAmount + (Dovetail.DoveBitOverCut * 2), 4) .. "...")
                  Dovetail.MillingApproved = true
                end -- if end min clear fault
              end -- if end stright bit dia fault
            end -- if end fingers less than 1
          end -- Bit too short
        end -- if end no end mill
    end -- if end no dovetail bit
else -- else if Version is Lower than Version 10
    --[[
    Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
    Dovetail.dialog:UpdateLabelField("Dovetail.PinNote", "")
    Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "")
    Dovetail.DovetailCount = Dovetail.dialog:GetIntegerField("Dovetail.DovetailCount")
    Dovetail.ToolDia = Dovetail.dialog:GetDoubleField("Dovetail.ToolDia")
    if Dovetail.ToolDia <= 0.0 then
      dialog:UpdateLabelField("Dovetail.Alert", "Aleart: Enter a Correct Tool Diameter.")
      dialog:UpdateLabelField("Dovetail.PinNote", "")
      dialog:UpdateLabelField("Dovetail.TailNote", "")
    else
      Dovetail.DovetailCount = dialog:GetIntegerField("Dovetail.DovetailCount")
      if Dovetail.DovetailCount < 2 then
        Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Finger Count cannot be less than 2.")
        Dovetail.dialog:UpdateLabelField("Dovetail.PinNote", "")
        Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "")
      else
        Dovetail.ToolSize = Dovetail.ToolDia
        Dovetail.DovetailSize = Rounder(Dovetail.MaterialLength / Dovetail.DovetailCount, 4)
        if Dovetail.DovetailSize < Dovetail.ToolSize then
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Clearing End Mill Bit Diamenter is larger than Dovetail gap Size")
        else
          Dovetail.dialog:UpdateDoubleField("Dovetail.DovetailSize", Dovetail.DovetailSize)
          Dovetail.Tool = Tool("Lua End Mill", Tool.END_MILL)
        end -- if end1
      end -- if end2
    end -- if end3
  ]]
  end -- if end4

  return true
end
--  ===================================================
function OnLuaButton_InquiryLayers()

    local myHtml = [[<html><head><title>Dovetail Toolpath Creator</title><style type="text/css">html {overflow:hidden}body, td, th {font-family: Arial, Helvetica, sans-serif;font-size: 12px;color: #000;overflow:hidden;}.FormButton {font-weight: bold;width: 60%;font-family: Arial, Helvetica, sans-serif;font-size: 12px;}.h2 {font-size: 12px;font-weight: bold;text-align:right;text-wrap:none;vertical-align:middle;}.h21 {font-size: 12px;font-weight: bold;text-align:left;text-wrap:none;vertical-align:middle;}</style></head><body bgcolor = "#EBEBEB" text = "#000000"><table width="550" border="0" align="left" cellpadding="0"> <tr> <td width="18%" valign="middle" nowrap class="h2">Layer Names</td> <td width="82%" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Side - Broad: <input name="Dovetail.LayerNameSideBroad" type="text" class="h21" id="Dovetail.LayerNameSideBroad" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Side- Dovetail Clearing: <input name="Dovetail.LayerNameClearing" type="text" class="h21" id="Dovetail.LayerNameClearing" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Side - Dovetail Path: <input name="Dovetail.LayerNameDovetailPath" type="text" class="h21" id="Dovetail.LayerNameDovetailPath" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Front - Broad: <input name="Dovetail.LayerNameFrontBroad" type="text" class="h21" id="Dovetail.LayerNameFrontBroad" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Front - Pockets: <input name="Dovetail.LayerNameFrontPocket" type="text" class="h21" id="Dovetail.LayerNameFrontPocket" size="50" maxlength="50" /></td> </tr> <tr> <td width="18%" nowrap class="h2">Tool Path Names</td> <td align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Side - Dovetail Path: <input name="Dovetail.ToolPathTail" type="text" class="h21" id="Dovetail.ToolPathTail" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Side - Clearing: <input name="Dovetail.ToolPathClearing" type="text" class="h21" id="Dovetail.ToolPathClearing" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2">Front - Pins: <input name="Dovetail.ToolPathPins" type="text" class="h21" id="Dovetail.ToolPathPins" size="50" maxlength="50" /></td> </tr> <tr> <td colspan="2" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td colspan="2" align="center" valign="middle" nowrap><table width="450" border="0" cellpadding="0"> <tr> <td height="20" align="center" valign="middle" style="width: 30%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"> </th> <td height="20" style="width: 30%" align="center" valign="middle"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"> </th> </tr> </table></td> </tr></table></body></html>]]
    local dialogL = HTML_Dialog(true, myHtml, 590, 350, "Layer Setup") ;
    dialogL:AddTextField("Dovetail.LayerNameClearing",     Dovetail.LayerNameClearing)
    dialogL:AddTextField("Dovetail.LayerNameSideBroad",    Dovetail.LayerNameSideBroad)
    dialogL:AddTextField("Dovetail.LayerNameFrontPocket",  Dovetail.LayerNameFrontPocket)
    dialogL:AddTextField("Dovetail.LayerNameDovetailPath", Dovetail.LayerNameDovetailPath)
    dialogL:AddTextField("Dovetail.LayerNameFrontBroad",   Dovetail.LayerNameFrontBroad)
    dialogL:AddTextField("Dovetail.ToolPathPins",          Dovetail.ToolPathPins)
    dialogL:AddTextField("Dovetail.ToolPathTail",          Dovetail.ToolPathTail)
    dialogL:AddTextField("Dovetail.ToolPathClearing",      Dovetail.ToolPathClearing)
    if  dialogL:ShowDialog() then
        Dovetail.LayerNameClearing     = dialogL:GetTextField("Dovetail.LayerNameClearing")
        Dovetail.LayerNameFrontPocket  = dialogL:GetTextField("Dovetail.LayerNameFrontPocket")
        Dovetail.LayerNameSideBroad    = dialogL:GetTextField("Dovetail.LayerNameSideBroad")
        Dovetail.LayerNameDovetailPath = dialogL:GetTextField("Dovetail.LayerNameDovetailPath")
        Dovetail.LayerNameFrontBroad   = dialogL:GetTextField("Dovetail.LayerNameFrontBroad")
        Dovetail.ToolPathPins          = dialogL:GetTextField("Dovetail.ToolPathPins")
        Dovetail.ToolPathTail          = dialogL:GetTextField("Dovetail.ToolPathTail")
        Dovetail.ToolPathClearing      = dialogL:GetTextField("Dovetail.ToolPathClearing")
        RegistryWrite()
      end
    return  true
end
-- ===================================================]]
function main(script_path)                              -- Main Function (script_path)
  Dovetail.AppName = "EasySlidingDovetailMaker"
  Dovetail.Version = "1.0"
  Dovetail.MillingApproved = false
  Dovetail.DovetailCenters = 0.0
  Dovetail.RegName = Dovetail.AppName .. Dovetail.Version
  Dovetail.TailCalc = "Tail Count"
  Dovetail.job = VectricJob()                             -- Get the currect Job ID
  if not Dovetail.job.Exists then                         -- Validate the user has setup a Job
        DisplayMessageBox("Error: The Gadget cannot proceed without a job setup.\n" ..
                          "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                          "specify the material dimensions")
    return false;
  end
  if GetMaterialSettings() then                           -- Read the Material Configuration and set global setting
    Dovetail.ToolPath = script_path                       -- Validate the user has setup a Job
    RegistryRead()                                        -- Read the registry for last use values
    ToolHeaderReader(Dovetail.ToolPath)                   -- Read the Dovetail Tool List
    if InquiryDovetail("Easy Sliding Dovetail Maker") then-- Show the the main dialog
      if Dovetail.MillingApproved then                    -- Proceed if user pressed OK
        Dovetail_Math()                                   -- Do the Math
        Dovetail_Pins()                                   -- Draw Pins
        Dovetail_Tails()                                  -- Draw Tails
        Dovetail_MillingPath()                            -- DDraw the Dovetail paths
        if Dovetail.AppValue then
          CreatePocketToolpath1(Dovetail.LayerNameFrontPocket,  Dovetail.ToolPathPins)
          CreatePocketToolpath1(Dovetail.LayerNameClearing,     Dovetail.ToolPathClearing)
          CreateProfileToolpath(Dovetail.LayerNameDovetailPath, Dovetail.ToolPathTail, Dovetail.FrontThickness, "ON", false)
        else
          CreatePocketToolpath2(Dovetail.LayerNameFrontPocket,  Dovetail.ToolPathPins)
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
  local selection = Dovetail.Job.Selection
  selection:Clear()
  local layer = Dovetail.Job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
  local tool = Tool("Lua End Mill", Tool.END_MILL)
       tool.InMM = Dovetail.Unit
       tool.ToolDia = Dovetail.ToolSize
       tool.Stepdown = Dovetail.ToolSize * 0.33
       tool.Stepover = Dovetail.ToolSize * 0.10
       tool.RateUnits = Tool.INCHES_MIN
       tool.FeedRate = 40
       tool.PlungeRate = 20
       tool.SpindleSpeed = 20000
       tool.ToolNumber = 2
  local mtl_block = MaterialBlock()
  local mtl_box = mtl_block.MaterialBox
  local mtl_box_blc = mtl_box.BLC
  local pos_data = ToolpathPosData()
       pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
       pos_data.SafeZGap = mtl_block.Thickness * 0.1
  local pocket_data = PocketParameterData()
       pocket_data.StartDepth = 0
       pocket_data.CutDepth = Dovetail.MaterialThickness
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
-- ================ End ==============================]]