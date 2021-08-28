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
require("mobdebug").start()
-- require "strict"
-- Table Names
local Dovetail = {}
local Tools = {}
Dovetail.AppName = "EasyDovetailMaker"
Dovetail.DovetailSelectedTool = "Make a Slection"
Dovetail.Version = "3.8"
Dovetail.TailCount = 1
Dovetail.MillingApproved = false
Dovetail.DovetailCenterAmount = 0.0
Dovetail.RegName = Dovetail.AppName .. Dovetail.Version
Dovetail.g_pt1 =  Point2D(0, 0)
Dovetail.g_pt2 =  Dovetail.g_pt1
Dovetail.g_pt3 =  Dovetail.g_pt1
Dovetail.g_pt4 =  Dovetail.g_pt1
Dovetail.PinStart =  0.0
Dovetail.ToolDia = 0.250
Dovetail.FingerFit = 0.010
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
  if mtl_block.Height == mtl_block.Width then
      MessageBox("Error! Material block cannot square")
  end
    -- Display material XY origin
    Dovetail.Origin = "invalid"
    local xy_origin = mtl_block.XYOrigin
  if  xy_origin == MaterialBlock.BLC then
      Dovetail.Origin = "Bottom Left Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 90.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 270.0
      Dovetail.Direction4 = 180.0
      Dovetail.Bulge = 1.0
    else
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 90.0
      Dovetail.Direction3 = 180.0
      Dovetail.Direction4 = 270.0
      Dovetail.Bulge = -1.0
    end

  elseif xy_origin == MaterialBlock.BRC then
    Dovetail.Origin = "Bottom Right Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 90.0
      Dovetail.Direction2 = 180.0
      Dovetail.Direction3 = 270.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = -1.0
    else
      Dovetail.Direction1 = 180.0
      Dovetail.Direction2 = 90.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 270.0
      Dovetail.Bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.TRC then
      Dovetail.Origin = "Top Right Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 270.0
      Dovetail.Direction2 = 180.0
      Dovetail.Direction3 = 90.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = 1.0
    else
      Dovetail.Direction1 = 180.0
      Dovetail.Direction2 = 270.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 90.0
      Dovetail.Bulge = -1.0
    end
  elseif xy_origin == MaterialBlock.TLC then
      Dovetail.Origin = "Top Left Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 270.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 90.0
      Dovetail.Direction4 = 180.0
      Dovetail.Bulge = -1.0
    else
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 270.0
      Dovetail.Direction3 = 180.0
      Dovetail.Direction4 = 90.0
      Dovetail.Bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
      Dovetail.Origin = "Center"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = 1.0
    else
      Dovetail.Direction1 = 0.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 0.0
      Dovetail.Direction4 = 0.0
      Dovetail.Bulge = -1.0
    end
      MessageBox("Error! " .. Dovetail.Origin .. " Must be set at a corner of the Material")
  else
      Dovetail.Origin = "Unknown XY origin value!"
      MessageBox("Error! " .. Dovetail.Origin .. " Must be set at a corner of the Material")
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 0
      Dovetail.Direction2 = 0
      Dovetail.Direction3 = 0
      Dovetail.Direction4 = 0
    else
      Dovetail.Direction1 = 0
      Dovetail.Direction2 = 0
      Dovetail.Direction3 = 0
      Dovetail.Direction4 = 0
    end
  end
	return true
end -- function end
-- ===================================================]]
function Dovetail_Math()                                -- All the math for Dovetail
  Dovetail.DovetailToolRadius = Dovetail.DovetailToolDia * 0.500
  Dovetail.StrightToolRadius = Dovetail.StrightToolDia * 0.500
  -- Smallest Clearing Amount for Bit
  Dovetail.PathCount = 0.0
  -- DisplayMessageBox("Count " .. tostring( Dovetail.DovetailCount ))
  if Dovetail.Orantation == "H" then
  Dovetail.g_pt1 = Point2D(0, 0)
  Dovetail.g_pt2 = Polar2D(Dovetail.g_pt1, 90.0, Dovetail.MaterialThickness)
  Dovetail.g_pt3 = Polar2D(Dovetail.g_pt2, 180.0, Dovetail.MaterialLength)
  Dovetail.g_pt4 = Polar2D(Dovetail.g_pt1, 180.0, Dovetail.MaterialLength)

  else -- Dovetail.Orantation == "V"
  Dovetail.g_pt1 = Point2D(0, 0)
  Dovetail.g_pt2 = Polar2D(Dovetail.g_pt1, 90.0, Dovetail.MaterialLength)
  Dovetail.g_pt3 = Polar2D(Dovetail.g_pt2, 180.0, Dovetail.MaterialThickness)
  Dovetail.g_pt4 = Polar2D(Dovetail.g_pt1, 180.0, Dovetail.MaterialThickness)

  end
  RegistryWrite()
  return true
end
-- ===================================================]]
function RegistryRead()                                 -- Read from Registry values
  local RegistryRead = Registry(Dovetail.RegName)
  if not(RegistryRead:StringExists("Dovetail.CodeBy")) then
    RegistryLoad()
  end
  Dovetail.FingerFit             = RegistryRead:GetDouble("Dovetail.FingerFit",             0.010)
  Dovetail.ToolSize              = RegistryRead:GetDouble("Dovetail.ToolSize",              0.250)
  Dovetail.LayerNameFrontBroad   = RegistryRead:GetString("Dovetail.LayerNameFrontBroad",   "Tail Broad")
  Dovetail.LayerNameSideBroad    = RegistryRead:GetString("Dovetail.LayerNameSideBroad",    "Pin Broad")
  Dovetail.LayerNameSidePocket   = RegistryRead:GetString("Dovetail.LayerNameSidePocket",   "Pin Pockets")
  Dovetail.LayerNameDovetailPath = RegistryRead:GetString("Dovetail.LayerNameDovetailPath", "Tail Dovetail Path")
  Dovetail.LayerNameClearing     = RegistryRead:GetString("Dovetail.LayerNameClearing",     "Tail Dovetail Clearing")
  Dovetail.CodeBy                = RegistryRead:GetString("Dovetail.CodeBy",                "James Anderson")
  Dovetail.ProgramName           = RegistryRead:GetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
  Dovetail.Version               = RegistryRead:GetString("Dovetail.Version",               Dovetail.Version)
  Dovetail.ProgramYear           = RegistryRead:GetString("Dovetail.ProgramYear",           "2020")
  Dovetail.ToolPathPins          = RegistryRead:GetString("Dovetail.ToolPathPins",          "Pins")
  Dovetail.ToolPathTail          = RegistryRead:GetString("Dovetail.ToolPathTail",          "Tails")
  Dovetail.TailCount             = RegistryRead:GetInt("Dovetail.TailCount",                1)
  Dovetail.ToolPathClearing      = RegistryRead:GetString("Dovetail.ToolPathClearing",      "Tail_Clearing")
end
-- ===================================================]]
function RegistryWrite()                                -- Write to Registry values
  local RegistryWrite = Registry(Dovetail.RegName)
  local RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontBroad",   Dovetail.LayerNameFrontBroad)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSideBroad",    Dovetail.LayerNameSideBroad)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameDovetailPath", Dovetail.LayerNameDovetailPath)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameClearing",     Dovetail.LayerNameClearing)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSidePocket",   Dovetail.LayerNameSidePocket)
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathPins",          Dovetail.ToolPathPins)
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathTail",          Dovetail.ToolPathTail)
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathClearing",      Dovetail.ToolPathClearing)
        RegValue = RegistryWrite:SetString("Dovetail.CodeBy",                "James Anderson")
        RegValue = RegistryWrite:SetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
        RegValue = RegistryWrite:SetString("Dovetail.Version",               Dovetail.Version)
        RegValue = RegistryWrite:SetString("Dovetail.ProgramYear",           "2020")
        RegValue = RegistryWrite:SetDouble("Dovetail.ToolSize",              Dovetail.ToolSize)
        RegValue = RegistryWrite:SetDouble("Dovetail.FingerFit",             Dovetail.FingerFit)
        RegValue = RegistryWrite:SetInt("Dovetail.TailCount",                Dovetail.TailCount)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryBoxJointX",      Dovetail.InquiryBoxJointX)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryBoxJointY",      Dovetail.InquiryBoxJointY)
 	return true
end
-- ===================================================]]
function RegistryLoad()                                 -- Load Registry with values
  local RegistryWrite = Registry(Dovetail.RegName)
  local RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontBroad",   "Tail Broad")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSideBroad",    "Pin Broad")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameDovetailPath", "Tail Dovetail Path")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameClearing",     "Tail Dovetail Clearing")
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSidePocket",   "Pin Pockets")
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathPins",          "Pins")
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathTail",          "Tails")
        RegValue = RegistryWrite:SetString("Dovetail.ToolPathClearing",      "Tail_Clearing")
        RegValue = RegistryWrite:SetString("Dovetail.CodeBy",                "James Anderson")
        RegValue = RegistryWrite:SetString("Dovetail.ProgramName",           "Easy Dovetail Maker")
        RegValue = RegistryWrite:SetString("Dovetail.Version",               Dovetail.Version)
        RegValue = RegistryWrite:SetString("Dovetail.ProgramYear",           "2020")
        RegValue = RegistryWrite:SetDouble("Dovetail.FingerFit",             0.010)
        RegValue = RegistryWrite:SetDouble("Dovetail.ToolSize",              0.250)
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
function InquiryDovetail(Header)
  if Dovetail.AppValue then
    Dovetail.ToolTable = [[<table width="100%" border="0"><tr><td colspan="3" align="right" nowrap class="h1-r"><hr></td></tr><tr><td width="100" align="right" nowrap class="h1-rPx">Stright Bit:</td><td width="80%" nowrap="nowrap" class="ToolNameLabel"><span class="ToolNameLabel" id = "ToolNameLabel">-</span></td><td width="98" nowrap class="ToolPicker" id="ToolChooseButton"><strong><input name = "ToolChooseButton" id="ToolChooseButton" type = "button" class = "ToolPicker" value = "Tool"></strong></td></tr></table>]]
  else
    Dovetail.ToolTable = [[<table width="100%" border="0"><tr><td align="right" nowrap class="h1-r"><hr></td></tr><tr><td align="right" nowrap class="h1-rPx">Pocket Bit Diameter<input name="Dovetail.ToolDia" type="text" id="Dovetail.ToolDia" size="9"></td></tr></table>]]
  end --if end
  local myHtml = [[<html> <head> <title>Dovetail Toolpath Creator</title> <style type="text/css">html{overflow:hidden} .helpbutton{background-color:#E1E1E1; border:1px solid #999; border-right-color:#000; border-bottom-color:#000; border-top-color:#FFF;  border-left-color:#FFF; padding:2px 12px; font-family:Arial, Helvetica, sans-serif;  text-align:center; text-decoration:none; font-size:12px; margin:4px 2px; color:#000}.helpbuttonx{ background-color:##E1E1E1; border:1px solid #999; font-family:Arial,Helvetica,sans-serif; text-align:center; text-decoration:none;  display:inline-block; font-size:12px; margin:40px 20px; cursor:pointer;  color:#000;  padding:2px 12px} .helpbutton:active{ border-right-color:#FFF;  border-bottom-color:#FFF;  border-top-color:#000; border-left-color:#000} .helpbutton:hover{border-right-color:#000; border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF} .LuaButton{font-weight:bold; font-family:Arial,Helvetica,sans-serif; font-size:12px} .DirectoryPicker{ font-weight:bold; font-family:Arial, Helvetica, sans-serif; font-size:12px} .ToolPicker{font-weight:bold; text-align:center; font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:center;  width:50px} .ToolNameLabel{ font-family:Arial,Helvetica,sans-serif; font-weight:bolder; font-size:14px; text-align:left; color:#0000FF} .FormButton{ font-weight:bold; width:75px; font-family:Arial, Helvetica, sans-serif; font-size:12px; white-space:nowrap} .h1-l{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:left;  white-space:nowrap} .h2-l{ font-family:Arial,Helvetica,sans-serif; font-size:12px; text-align:left} .h1-r{ font-family:Arial,Helvetica, sans-serif; font-size:12px; text-align:right; white-space:nowrap} .h1-rP{ font-family:Arial,Helvetica,sans-serif; font-size:12px; text-align:right; white-space:nowrap; padding-right:4px; padding-left:4px} .h1-rPx{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:right; white-space:nowrap; padding-right:8px; padding-left:8px} .alert{ font-family:Arial,Helvetica,sans-serif; font-size:12px; font-weight:bold; color:#00F; text-align:center; white-space:nowrap} .h1-c{ font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:center; white-space:nowrap} .header1-c{ font-family:Arial, Helvetica, sans-serif; font-size:16px; font-weight:bold; text-align:center; white-space:nowrap} .header2-c{ font-family:Arial, Helvetica, sans-serif; font-size:14px; font-weight:bold; text-align:center; white-space:nowrap} body{ background-color:#CCC; overflow:hidden; font-family:Arial,Helvetica,sans-serif; font-size:12px}</style> </head> <body> <table width="550" border="0" class="h2-l"> <tr> <td class="header2-c" id="Dovetail.AppName">-</td> <td width="28%"" align="right" class="h1-c" style="color: #999999" "width:20%><label id= "Dovetail.Version"> </label> </td> </tr> <tr> <td><p class="h2-l">This gadget creates a series of tool paths for a Dovetail from the material job setup settings.</p> <p class="h2-l">This requires the material to be held in a <strong>vertical position </strong> so that the milling can be performed on the end of the material to receive specified joinery.</p> <p class="h2-l">The gadget assumes that the Dovetail will run in the direction of the longest side of the material job and the material is a rectangle in shape.</p><p class="h2-l">Use the Top of material (top end of material) for the Z value. Set the materialthickness to the length of material.</p><p class="h2-l">For best results in cutting action, use &quot; up-cut&quot;  spiral bits.</p> </td> <td> <img src= data:image/jpeg;base64,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 width="200" height="204"></td></tr></table> <table width="100%" border="0"> <tr> <td colspan="1" align="right" nowrap class="h1-r"><hr></td> </tr> <tr> <th width = "60%" height = "15" align = "center" valign = "middle" id = "Contact2"><select name = "DList" size = "10" class = "h2" id = "ListBox"> <option>Defalt</option> </select> </th> </tr> </table>]] .. Dovetail.ToolTable .. [[<table width="550" border="0"><tr><td colspan="4" class="h1-r"><hr></td></tr> <tr> <td width="25%" class="h1-rP">&nbsp; Material Thickness</td> <td width="15%"><input name="Dovetail.MaterialThickness" type="text" disabled id="Dovetail.MaterialThickness" size="9" readonly></td> <td width="21%" class="h1-rP">&nbsp; Material Width</td> <td class="h1-l"> <input name="Dovetail.MaterialLength" type="text" disabled id="Dovetail.MaterialLength" size="9" readonly> </td> </tr> <tr> <td colspan="4" class="h1-rP"> <hr> </td> </tr> <tr> <td class="h1-rP">Tail Count</td> <td> <span class="h1-l"> <input id="Dovetail.TailCount" name="Dovetail.TailCount" size="9" type="text"> </span> </td> <td width="21%" class="h1-c"><span style="width: 15%"> <input id = "ButtonCalulate" class = "LuaButton" name = "ButtonCalulate" type = "button" value = "Calulate"> </span> </td> <td width="39%" class="h1-l"><label id="Dovetail.Units"> </label> </td> </tr> <tr> <td class="h1-rP">Tail Size</td> <td> <span class="h1-l"> <input name="Dovetail.TailSize" type="text" id="Dovetail.TailSize" size="9" readonly> </span></td> <td width="21%" class="h1-c">&nbsp; </td> <td width="39%" class="h1-l"> <label id="Dovetail.PinNote"> </label> </td> </tr> <tr> <td class="h1-rP">Fit Amount</td> <td><span class="h1-l"> <input name="Dovetail.FingerFit" type="text" id="Dovetail.FingerFit" size="9"> </span> </td> <td class="h1-c">&nbsp; </td> <td width="39%" class="h1-l"> <label id="Dovetail.TailNote"></label></td> </tr> </table> <table width="550" border="0" id="ButtonTable"> <tr><td height="12" colspan="4" align="right" valign="middle" nowrap class="h2"> <hr> </td> </tr> <tr> <td width="57"> <strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_Dovetail_Maker-Page1" target="_blank" class="helpbutton">Help</a> </strong> </td>
  <td width="325"><span class="alert" id="Dovetail.Alert">.</span></td>
  <td width="75" class="FormButton"> <span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td><td width="75" class="FormButton"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span> </td> </tr> </table>  </body> </html>]]



  Dovetail.dialog = HTML_Dialog(true, myHtml, 587, 640, Header)
 --[[
  dialog:AddDoubleField("Dovetail.StrightToolDia", Dovetail.StrightToolDia)
  dialog:AddDoubleField("Dovetail.DovetailToolAngle", Dovetail.DovetailToolAngle)
  dialog:AddDoubleField("Dovetail.DovetailToolDia", Dovetail.DovetailToolDia)
  ]]

  Dovetail.dialog:AddLabelField("Dovetail.Alert", "")
  Dovetail.dialog:AddLabelField("Dovetail.AppName",            Dovetail.AppName)
  Dovetail.dialog:AddLabelField("Dovetail.Version",            "Version: " ..  Dovetail.Version )
  Dovetail.dialog:AddLabelField("Dovetail.Units",              Dovetail.Units)
  Dovetail.dialog:AddLabelField("Dovetail.PinNote",            "")
  Dovetail.dialog:AddLabelField("Dovetail.TailNote",           "")
  Dovetail.dialog:AddIntegerField("Dovetail.TailCount",        Dovetail.TailCount)
  Dovetail.dialog:AddDoubleField("Dovetail.TailSize", 	       Dovetail.DovetailCenterAmount)
  Dovetail.dialog:AddDoubleField("Dovetail.MaterialLength", 	 Dovetail.MaterialLength)
  Dovetail.dialog:AddDoubleField("Dovetail.MaterialThickness", Dovetail.MaterialThickness)
  Dovetail.dialog:AddDoubleField("Dovetail.FingerFit", 	       Dovetail.FingerFit)

  if Dovetail.AppValue then
    Dovetail.dialog:AddLabelField("ToolNameLabel",            "Not Selected")
    Dovetail.dialog:AddToolPicker("ToolChooseButton",         "ToolNameLabel", Tool_ID)
    Dovetail.dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
  else
    Dovetail.dialog:AddDoubleField("Dovetail.ToolDia", 	                   Dovetail.ToolDia)
  end -- if end
  Dovetail.dialog:AddDropDownList("ListBox", Dovetail.DovetailSelectedTool) ;
  -- dialog:AddDropDownListValue("ListBox",  "Add New") ;
  for _, value in pairs(Tools) do
    Dovetail.dialog:AddDropDownListValue("ListBox", value) ;
  end ;
  if  Dovetail.dialog:ShowDialog() then
    Dovetail.DovetailSelectedTool = Dovetail.dialog:GetDropDownListValue("ListBox")
    GetToolData(Dovetail.ToolPath, "DovetailTool.ini", string.upper(Dovetail.DovetailSelectedTool))
    Dovetail.InquiryDovetailX = Dovetail.dialog.WindowWidth
    Dovetail.InquiryDovetailY = Dovetail.dialog.WindowHeight
  --  RegistryWrite()
  end
end
-- ===================================================]]
function OnLuaButton_InquiryAbout()
--[[
    Shows the user program information
    Caller = OnLuaButton_InquiryAbout()
    Dialog Header = "Easy Dovetail Maker"
    Returns = True
]]
    local myHtml = [[<html><head><title>About</title><style type = "text/css"> html{overflow:hidden}body,td,th{font-family:Arial,Helvetica,sans-serif; font-size:12px; color:#000; background-color:#EBEBEB }.FormButton{font-weight:bold; width:40%; font-family:Arial,Helvetica,sans-serif; font-size:12px}.h1{font-size:16px; font-weight:bold; text-align:center; text-wrap:none;  vertical-align:middle}.h2{font-size:10px; text-align:center; text-wrap:none; vertical-align:middle }.h3{font-size:12px; font-weight:bold; text-align:center; text-wrap:none; vertical-align:middle}</style></head><body bgcolor = "#EBEBEB" text = "#000000"><table width="213" border="0" cellpadding="0"><tr><td align="center" nowrap="nowrap" class="h1">Easy Dovetail Maker</td></tr><tr><td align="center" nowrap="nowrap" class="h2" id="Version"><label>-</label></td></tr><tr><td align="center" nowrap="nowrap"><hr></td></tr><tr><td align="center" nowrap="nowrap" class="h3">James Anderson</td></tr><tr><td align="center" nowrap="nowrap"><a href="James.L.Anderson@outlook.com">James.L.Anderson@outlook.com</a></td></tr><tr><td align="center" nowrap="nowrap"><a href="http://www.jimandi.com">www.JimAndi.com</a></td></tr><tr><td align="center" nowrap="nowrap"><span class="h3">(281) 728-3028 </span></td></tr><tr><td align="center" nowrap="nowrap"><span class="h3">Houston, TX.</span></td></tr><tr><td align="center" nowrap="nowrap"><hr></td></tr><tr><td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td></tr></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 250, 255, "About")
  dialog:AddLabelField("Version", Dovetail.Version)
  dialog:ShowDialog()
  Dovetail.InquiryAboutX = dialog.WindowWidth
  Dovetail.InquiryAboutY = dialog.WindowHeight
  RegistryWrite()
  return  true
end
-- ===================================================]]
function OnLuaButton_InquiryError(Message)
  local myHtml = [[<html><head><title>Error</title><style type = "text/css">.FormButton{font-weight:bold; width:75px; font-family:Arial,Helvetica,sans-serif; font-size:12px; white-space:nowrap}.Error{font-family:Arial,Helvetica,sans-serif; font-size:18px; font-weight:bold; color:#F00; text-align:left; white-space:nowrap; padding-right:4px; padding-left:10px; padding-top:4px; padding-bottom:4px}.ErrorMessage{font-family:Arial,Helvetica,sans-serif; font-size:12px; color:#000; font-weight:bold; text-align:left; white-space:nowrap; padding-right:4px; padding-left:10px; padding-top:4px; padding-bottom:4px}.ErrorTable{background-color:#FFF white-space:nowrap}html{overflow:hidden}</style></head><body text = "#000000"><table width="100%" border="0" cellpadding="0" class="ErrorTable"><tr><th align="center" nowrap="nowrap" class="Error">Error!</th></tr><tr><td id="ErrorMessage"><label class="ErrorMessage">-</label></tr><tr><td width="30%" align="right" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "Exit"></td></tr></table></body></html>]]
  local dialogWide =  (#Message + 300)
  local dialog = HTML_Dialog(true, myHtml, 250, dialogWide, "Gadget Error") ;
  dialog:AddLabelField("ErrorMessage", Message)
  dialog:ShowDialog()
  Dovetail.InquiryErrorX = dialog.WindowWidth
  Dovetail.InquiryErrorY = dialog.WindowHeight
  RegistryWrite()
  return  true
end
-- ===================================================]]
function Dovetail_Path()
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameDovetailPath)
  local line = Contour(0.0)
  local LoopOver = false
  Dovetail.pt01 = Polar2D(Dovetail.g_pt1, 0.0, Dovetail.DovetailToolRadius + 0.125 )
  Dovetail.pt02 = Polar2D(Dovetail.pt01, 0.0, 0.125)
  line:AppendPoint(Dovetail.pt01)
  line:LineTo(Dovetail.pt01)
  Dovetail.ptx = Polar2D(Dovetail.pt01, 90.0, Dovetail.DovetailCenters  + Dovetail.PinStart)
  line:LineTo(Dovetail.ptx)
  Dovetail.ptx = Polar2D(Dovetail.ptx, 180.0, (Dovetail.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
  line:LineTo(Dovetail.ptx)
  Dovetail.ptx = Polar2D(Dovetail.ptx, 90.0, Dovetail.DovetailCenters * 2.0 )
  for _ = Dovetail.PathCount-1 , 1 , -1   do
    line:LineTo(Dovetail.ptx)
    if LoopOver == false then
      Dovetail.ptx = Polar2D(Dovetail.ptx, 0.0, (Dovetail.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
      LoopOver = true
    else
      Dovetail.ptx = Polar2D(Dovetail.ptx, 180.0, (Dovetail.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
      LoopOver = false
    end
    line:LineTo(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx, 90.000, Dovetail.DovetailCenters * 2.0 )
  end
  if LoopOver then
    Dovetail.ptx = Polar2D(Polar2D(Dovetail.ptx, 270.000, Dovetail.DovetailCenters * 2.0 ), 0.000, 0.125)
    line:LineTo(Dovetail.ptx)
  else
    Dovetail.ptx = Polar2D(Polar2D(Dovetail.g_pt3, 180.0, Dovetail.DovetailToolRadius  + 0.125), 90.0, (Dovetail.DovetailToolRadius  + 0.125))
    line:LineTo(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Polar2D(Dovetail.g_pt2, 0.0, Dovetail.DovetailToolRadius  + 0.25), 90.0, (Dovetail.DovetailToolRadius  + 0.125))
    line:LineTo(Dovetail.ptx)
  end
  line:LineTo(Dovetail.pt02)
  layer:AddObject(CreateCadContour(line), true)
  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function Dovetail_Tails()
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad)
  local line = Contour(0.0)
  line:AppendPoint(Dovetail.g_pt1)
  line:LineTo(Dovetail.g_pt2)
  line:LineTo(Dovetail.g_pt3)
  line:LineTo(Dovetail.g_pt4)
  line:LineTo(Dovetail.g_pt1)
  layer:AddObject(CreateCadContour(line), true)
  Dovetail.ptx = Polar2D(Dovetail.g_pt1, 90.0, Dovetail.PinStart + Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  for _ = Dovetail.PathCount - 1, 1 , -1     do
    DovetailPockets(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx, 90.0, Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
  DovetailPocketsEnds()
  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function Dovetail_Pins()
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontBroad)
  local line = Contour(0.0)
  line:AppendPoint(Dovetail.g_pt1)
  line:LineTo(Dovetail.g_pt2)
  line:LineTo(Dovetail.g_pt3)
  line:LineTo(Dovetail.g_pt4)
  line:LineTo(Dovetail.g_pt1)
  layer:AddObject(CreateCadContour(line), true)

    local ptx = Polar2D(Dovetail.g_pt1, Dovetail.Direction1, Dovetail.PinStart + Dovetail.DovetailCenterAmount )
    local tx = Dovetail.MaterialLength
    while (tx >= Dovetail.DovetailCenterAmount + Dovetail.DovetailCenterAmount) do
      Dovetails(ptx)
      ptx = Polar2D(ptx, Dovetail.Direction1, Dovetail.DovetailCenterAmount + Dovetail.DovetailCenterAmount )
      tx = tx - (Dovetail.DovetailCenterAmount + Dovetail.DovetailCenterAmount)
    end

  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function DovetailPockets(xpt1)
    local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSidePocket)
    local line = Contour(0.0)
    local pt02 = Polar2D(xpt1, Dovetail.Direction4, Dovetail.MaterialThickness)
    local pt01 = Polar2D(xpt1, Dovetail.Direction1, Dovetail.ClearingTopAmount * 0.5)
    local pt04 = Polar2D(pt01, Dovetail.Direction3, Dovetail.ClearingTopAmount * 0.5)
          pt02 = Polar2D(pt02, Dovetail.Direction1, Dovetail.DovetailToolRadius)
    local pt03 = Polar2D(pt02, Dovetail.Direction3, Dovetail.DovetailToolRadius)
          pt01 = Polar2D(pt01, ((Dovetail.Direction0 + 360.0) - Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
          pt04 = Polar2D(pt04, Dovetail.DovetailToolAngle, Dovetail.StrightToolDia)
          pt02 = Polar2D(pt02, (Dovetail.Direction4 - Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
          pt03 = Polar2D(pt03, (Dovetail.Direction4 + Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
    line:AppendPoint(pt01)
    line:LineTo(pt02)
    line:LineTo(pt03)
    line:LineTo(pt04)
    line:LineTo(pt01)
    layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function Dovetails(pt1)
    Dovetail.PathCount = Dovetail.PathCount + 1
    local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameClearing)
    local line  = Contour(0.0)
    local pt2   = Polar2D(pt1, 180.0, Dovetail.MaterialThickness)
    local pt01  = Polar2D(Polar2D(pt1, 90.0, (Dovetail.ClearingTopAmount * 0.5)), 0.0, Dovetail.StrightToolDia)
    local pt04  = Polar2D(Polar2D(pt1, 270.0, (Dovetail.ClearingTopAmount * 0.5)), 0.0, Dovetail.StrightToolDia)
    local pt02  = Polar2D(Polar2D(pt2, 90.0, (Dovetail.ClearingTopAmount * 0.5)), 180.0, Dovetail.StrightToolDia)
    local pt03  = Polar2D(Polar2D(pt2, 270.0, (Dovetail.ClearingTopAmount * 0.5)), 180.0, Dovetail.StrightToolDia)
    line:AppendPoint(pt01)
    line:LineTo(pt02)
    line:LineTo(pt03)
    line:LineTo(pt04)
    line:LineTo(pt01)
    layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function DovetailPocketsEnds()
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSidePocket)
  local line = Contour(0.0)
  local pt02 = Polar2D(Dovetail.g_pt1, 180.0, Dovetail.FrontThickness)
  local pt01 = Polar2D(Polar2D(Dovetail.g_pt1, 90.0, (Dovetail.ClearingTopAmount * 0.5) + Dovetail.PinStart), (360.0 - Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
  pt02 = Polar2D(Polar2D(pt02, 90.0, Dovetail.DovetailToolRadius + Dovetail.PinStart ), (180.0 - Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
  local pt03 = Polar2D(pt02, 270.0, Dovetail.StrightToolDia + (Dovetail.DovetailToolDia * 0.5) + Dovetail.PinStart)
  local pt04 = Point2D(pt01.X , pt03.Y)
  line:AppendPoint(pt01)
  line:LineTo(pt02)
  line:LineTo(pt03)
  line:LineTo(pt04)
  line:LineTo(pt01)
  layer:AddObject(CreateCadContour(line), true)
  layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSidePocket)
  line = Contour(0.0)
  pt02 = Polar2D(Dovetail.g_pt2, 180.0, Dovetail.FrontThickness)
  pt01 = Polar2D(Polar2D(Dovetail.g_pt2, 270.0, (Dovetail.ClearingWidth * 0.5) + Dovetail.PinStart), Dovetail.DovetailToolAngle, Dovetail.StrightToolDia)
  pt02 = Polar2D(Polar2D(pt02, 270.0, Dovetail.DovetailToolRadius + Dovetail.PinStart), (180.0 + Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
  pt03 = Polar2D(pt02, 90.0, Dovetail.StrightToolDia + (Dovetail.DovetailToolDia * 0.5) + Dovetail.PinStart )
  pt04 = Point2D(pt01.X, pt03.Y)
  line:AppendPoint(pt01)
  line:LineTo(pt02)
  line:LineTo(pt03)
  line:LineTo(pt04)
  line:LineTo(pt01)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================]]
function GetToolData(xPath, xFile, xGroup)
    Dovetail.Brand      = GetIniValue(xPath, xFile, xGroup, "Brand", "S")
    Dovetail.PartNo     = GetIniValue(xPath, xFile, xGroup, "PartNo", "S")
    Dovetail.DovetailToolAngle   = GetIniValue(xPath, xFile, xGroup, "BitAngle", "N")
    Dovetail.ShankDia   = GetIniValue(xPath, xFile, xGroup, "ShankDia", "N")
    Dovetail.DovetailToolDia     = GetIniValue(xPath, xFile, xGroup, "BitDia", "N")
    Dovetail.Flutes     = GetIniValue(xPath, xFile, xGroup, "Flutes", "N")
    Dovetail.Type       = GetIniValue(xPath, xFile, xGroup, "Type", "S")
    Dovetail.BitLength  = GetIniValue(xPath, xFile, xGroup, "BitLength", "N")
    Dovetail.CutDepth   = GetIniValue(xPath, xFile, xGroup, "CutDepth", "N")
    Dovetail.RPM        = GetIniValue(xPath, xFile, xGroup, "RPM", "N")
    Dovetail.FeedRate   = GetIniValue(xPath, xFile, xGroup, "FeedRate", "N")
    Dovetail.PlungRate  = GetIniValue(xPath, xFile, xGroup, "PlungRate", "N")
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
function HeaderReader(xPath)
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
function LengthOfFile(filename)-- Returns file line count
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
function OnLuaButton_ButtonCalulate()                   -- Executes the calculation function from the dialogue

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
          Dovetail.TailCount = Dovetail.dialog:GetIntegerField("Dovetail.TailCount")
          Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
          Dovetail.DovetailBitName = Dovetail.dialog:GetDropDownListValue("ListBox")
          Dovetail.StrightToolDia  = Dovetail.StrightTool.ToolDia
          Dovetail.TailCount       = Dovetail.dialog:GetIntegerField("Dovetail.TailCount")
          if Dovetail.TailCount < 1 then
            Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Finger Count cannot be less than 1")
            Dovetail.MillingApproved = false
          else
            Dovetail.MinClearingWidth = Dovetail.DovetailToolDia - (2 *  Dovetail.MaterialThickness * math.tan(math.rad(Dovetail.DovetailToolAngle)))
            Dovetail.DoveBitOverCut = Dovetail.MaterialThickness * math.tan(math.rad(Dovetail.DovetailToolAngle))
            -- Clearing Amount for Joint
            Dovetail.ClearingTopAmount = (Dovetail.MaterialLength / (Dovetail.TailCount + 1)) - Dovetail.DoveBitOverCut
            Dovetail.ClearingBottomLength = Dovetail.MaterialLength  / ((Dovetail.TailCount + 1) - math.tan(math.rad(Dovetail.DovetailToolAngle)))
            Dovetail.DovetailCenterAmount = Rounder(Dovetail.MaterialLength / (Dovetail.TailCount + 1), 4)
            if Dovetail.ClearingTopAmount < Dovetail.StrightToolDia then
                Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Stright Bit Size")
                Dovetail.MillingApproved = false
            else
              if Dovetail.ClearingTopAmount < Dovetail.MinClearingWidth then
                Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Error: Reduce Tail Count or Dovetail Bit Size")
                Dovetail.MillingApproved = false
              else
                Dovetail.dialog:UpdateDoubleField("Dovetail.TailSize", Dovetail.DovetailCenterAmount)
               -- Dovetail.NoFingers2 = Rounder(Dovetail.TailCount * 0.5,  0)
               -- Dovetail.NoFingers1 = Dovetail.TailCount - Dovetail.NoFingers2
               -- MessageBox("Can Do the Cut");
                Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
                Dovetail.MillingApproved = true
                Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "Tail Size = " .. tostring(Dovetail.DovetailCenterAmount))
                Dovetail.dialog:UpdateLabelField("Dovetail.PinNote", "Pin Size = " .. tostring(Dovetail.DovetailCenterAmount * 0.5))
              end -- if end5
            end -- if end5
          end -- if end6
        end -- if end7
    end -- if end8
  else   --[[ Else if Version is Lower than Version 10
    Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "")
    Dovetail.dialog:UpdateLabelField("Dovetail.PinNote", "")
    Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "")
    Dovetail.TailCount = Dovetail.dialog:GetIntegerField("Dovetail.TailCount")
    Dovetail.ToolDia = Dovetail.dialog:GetDoubleField("Dovetail.ToolDia")
    if Dovetail.ToolDia <= 0.0 then
      dialog:UpdateLabelField("Dovetail.Alert", "Aleart: Enter a Correct Tool Diameter.")
      dialog:UpdateLabelField("Dovetail.PinNote", "")
      dialog:UpdateLabelField("Dovetail.TailNote", "")
    else
      Dovetail.TailCount = dialog:GetIntegerField("Dovetail.TailCount")
      if Dovetail.TailCount < 2 then
        Dovetail.dialog:UpdateLabelField("Dovetail.Alert", "Alert: Finger Count cannot be less than 2.")
        Dovetail.dialog:UpdateLabelField("Dovetail.PinNote", "")
        Dovetail.dialog:UpdateLabelField("Dovetail.TailNote", "")
      else
        Dovetail.ToolSize = Dovetail.ToolDia
        Dovetail.DovetailSize = Rounder(Dovetail.MaterialLength / Dovetail.TailCount, 4)
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
-- ===================================================]]
function main(script_path)                              -- Main Function (script_path)
  Dovetail.job = VectricJob()
  if not Dovetail.job.Exists then
        DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  Dovetail.ToolPath = script_path
  RegistryRead()
-- Read the Material Configuration and set global setting
  GetMaterialSettings()
  HeaderReader(Dovetail.ToolPath)
  InquiryDovetail("Easy Dovetail Maker")

  if  Dovetail.MillingApproved then
  Dovetail_Math()

  Dovetail_Pins()

  Dovetail_Tails()

  Dovetail_Path()
  end
  Dovetail.job:Refresh2DView()
  return true
end
-- ================ End ==============================]]