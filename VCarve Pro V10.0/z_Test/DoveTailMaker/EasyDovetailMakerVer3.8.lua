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

 -- Easy Dovetail Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ===================================================]]
-- Global variables
require("mobdebug").start()
-- require "strict"

-- Table Names
local Dovetail = {}
Dovetail.RegName = "EasyDovetailMaker3.8"
Dovetail.g_pt1 =  Point2D(0, 0)
Dovetail.g_pt2 =  Dovetail.g_pt1
Dovetail.g_pt3 =  Dovetail.g_pt1
Dovetail.g_pt4 =  Dovetail.g_pt1


-- ===================================================]]
function Dovetail_Math()  -- All the math for Wall Cabinet
  Dovetail.ClearingWidth = Dovetail.DovetailToolDia - (2 *  Dovetail.SideThickness * math.tan(math.rad(Dovetail.DovetailToolAngle)))
  Dovetail.DovetailCenters = Dovetail.DovetailToolDia - (2 *  (Dovetail.SideThickness*0.5) * math.tan(math.rad(Dovetail.DovetailToolAngle)))
  Dovetail.ClearingLength = Dovetail.FrontThickness + (2.0 *  Dovetail.StrightToolDia)
  Dovetail.DovetailCount = math.floor(Dovetail.MaterialWidth / Dovetail.DovetailCenters)
  Dovetail.PathCount = 0.0
  --DisplayMessageBox("Count " .. tostring( Dovetail.DovetailCount ))
  if Dovetail.DovetailCount % 2 == 0 then
    Dovetail.DovetailCount = Dovetail.DovetailCount
    Dovetail.PinCount = math.floor(Dovetail.DovetailCount * 0.5) - 1
    Dovetail.TailCount = Dovetail.DovetailCount - Dovetail.PinCount
    Dovetail.PinStart = ((Dovetail.MaterialWidth - (Dovetail.DovetailCount * Dovetail.DovetailCenters)) * 0.5)
  else
    Dovetail.PinCount = math.floor(Dovetail.DovetailCount * 0.5)
    Dovetail.TailCount = Dovetail.DovetailCount  - Dovetail.PinCount
    Dovetail.PinStart = ((Dovetail.MaterialWidth - (Dovetail.DovetailCount * Dovetail.DovetailCenters)) * 0.5) + (Dovetail.DovetailCenters *0.5)
  end
--[[
     DisplayMessageBox("Count " .. tostring( Dovetail.DovetailCount ))
     DisplayMessageBox("Pin " .. tostring( Dovetail.PinCount ))
     DisplayMessageBox("Tail " .. tostring( Dovetail.TailCount ))
     DisplayMessageBox("Start " .. tostring( Dovetail.PinStart ))
      ]]
  Dovetail.g_pt1 =  Point2D(0, 0)
  Dovetail.g_pt2 = Polar2D(Dovetail.g_pt1,   90.0,   Dovetail.MaterialWidth)
  Dovetail.g_pt3 = Polar2D(Dovetail.g_pt2, 180.0,   Dovetail.SideThickness)
  Dovetail.g_pt4 = Polar2D(Dovetail.g_pt1, 180.0,   Dovetail.SideThickness)
  WriteRegistry()
  return true
end
-- ===================================================]]
function Mill_Math()  -- All the math for Wall Cabinet
    Dovetail.DovetailToolRadius = Dovetail.DovetailToolDia * 0.500
    Dovetail.StrightToolRadius = Dovetail.StrightToolDia * 0.500
    return true
end
-- ===================================================]]
function ReadRegistry()  -- Read from Registry values
  local RegistryRead = Registry(Dovetail.RegName)
  Dovetail.LayerNameFrontBroad = RegistryRead:GetString("Dovetail.LayerNameFrontBroad", "Tail Broad")
  Dovetail.LayerNameSideBroad = RegistryRead:GetString("Dovetail.LayerNameSideBroad", "Pin Broad")
  Dovetail.LayerNameSidePocket = RegistryRead:GetString("Dovetail.LayerNameSidePocket", "Pin Pockets")
  Dovetail.LayerNameDovetailPath = RegistryRead:GetString("Dovetail.LayerNameDovetailPath", "Tail Dovetail Path")
  Dovetail.LayerNameClearing = RegistryRead:GetString("Dovetail.LayerNameClearing", "Tail Dovetail Clearing")
  Dovetail.StrightToolDia = RegistryRead:GetDouble("Dovetail.StrightToolDia", 0.3750)
  Dovetail.StrightToolRadius = RegistryRead:GetDouble("Dovetail.StrightToolRadius", 0.1875)
  Dovetail.DovetailToolDia = RegistryRead:GetDouble("Dovetail.DovetailToolDia", 0.7500)
  Dovetail.DovetailToolRadius = RegistryRead:GetDouble("Dovetail.DovetailToolRadius", 0.37500)
  Dovetail.DovetailToolAngle = RegistryRead:GetDouble("Dovetail.DovetailToolAngle", 14.0)
  Dovetail.DovetailCount = RegistryRead:GetInt("Dovetail.DovetailCount", 6)
  Dovetail.CodeBy = RegistryRead:GetString("Dovetail.CodeBy", "James Anderson")
  Dovetail.ProgramName = RegistryRead:GetString("Dovetail.ProgramName", "Easy Dovetail Maker")
  Dovetail.ProgramVersion = RegistryRead:GetString("Dovetail.ProgramVersion", 3.7)
  Dovetail.ProgramYear = RegistryRead:GetString("Dovetail.ProgramYear", "2019")
  Dovetail.MaterialWidth = RegistryRead:GetDouble("Dovetail.MaterialWidth", 7.0)
  Dovetail.SideThickness = RegistryRead:GetDouble("Dovetail.SideThickness", 0.500)
  Dovetail.FrontThickness = RegistryRead:GetDouble("Dovetail.FrontThickness", 0.500)
end
-- ===================================================]]
function WriteRegistry() -- Write to Registry values
  local RegistryWrite = Registry(Dovetail.RegName)
  local RegValue = RegistryWrite:SetString("Dovetail.LayerNameFrontBroad", Dovetail.LayerNameFrontBroad)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSideBroad", Dovetail.LayerNameSideBroad)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameDovetailPath", Dovetail.LayerNameDovetailPath)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameClearing", Dovetail.LayerNameClearing)
        RegValue = RegistryWrite:SetString("Dovetail.LayerNameSidePocket", Dovetail.LayerNameSidePocket)
        RegValue = RegistryWrite:SetDouble("Dovetail.StrightToolDia", Dovetail.StrightToolDia)
        RegValue = RegistryWrite:SetDouble("Dovetail.StrightToolRadius", Dovetail.StrightToolRadius)
        RegValue = RegistryWrite:SetDouble("Dovetail.DovetailToolDia", Dovetail.DovetailToolDia)
        RegValue = RegistryWrite:SetDouble("Dovetail.DovetailToolRadius", Dovetail.DovetailToolRadius)
        RegValue = RegistryWrite:SetDouble("Dovetail.DovetailToolAngle", Dovetail.DovetailToolAngle)
        RegValue = RegistryWrite:SetInt("Dovetail.DovetailCount", Dovetail.DovetailCount)
        RegValue = RegistryWrite:SetDouble("Dovetail.MaterialWidth",Dovetail.MaterialWidth)
        RegValue = RegistryWrite:SetDouble("Dovetail.SideThickness", Dovetail.SideThickness)
        RegValue = RegistryWrite:SetDouble("Dovetail.FrontThickness", Dovetail.FrontThickness)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryDovetailX", Dovetail.InquiryDovetailX)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryDovetailY", Dovetail.InquiryDovetailY)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryLayerX", Dovetail.InquiryLayerX)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryLayerY", Dovetail.InquiryLayerY)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryAboutX", Dovetail.InquiryAboutX)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryAboutY", Dovetail.InquiryAboutY)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryErrorX", Dovetail.InquiryErrorX)
        RegValue = RegistryWrite:SetString("Dovetail.InquiryErrorY", Dovetail.InquiryErrorY)
 	return true
end
-- ===================================================]]
function GetMaterialSettings()
  local mtl_block = MaterialBlock()
  --local units
  if mtl_block.InMM then
    Dovetail.Units  = "Drawing Units: mm"
    Dovetail.Unit = true
  else
    Dovetail.Units  = "Drawing Units: inches"
    Dovetail.Unit = false
  end
-- =============]]
	if mtl_block.Width > mtl_block.Height then
		Dovetail.MaterialThickness = mtl_block.Height
		Dovetail.MaterialLength = mtl_block.Width
    Dovetail.Orantation = "H"
	else
		Dovetail.MaterialThickness = mtl_block.Width
		Dovetail.MaterialLength = mtl_block.Height
    Dovetail.Orantation = "V"
	end
-- =============]]
  if mtl_block.Height == mtl_block.Width then
      MessageBox("Error! Material block cannot square")
  end
-- =============]]
    -- Display material XY origin
    local xy_origin_text = "invalid"
    local xy_origin = mtl_block.XYOrigin

  if  xy_origin == MaterialBlock.BLC then
      xy_origin_text = "Bottom Left Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 90.0
      Dovetail.Direction2 = 0.0
      Dovetail.Direction3 = 90.0
      Dovetail.Direction4 = 180.0
      Dovetail.Bulge      = 1.000
    else
      Dovetail.Direction1 = 0.000
      Dovetail.Direction2 = 90.000
      Dovetail.Direction3 = 0.000
      Dovetail.Direction4 = 270.000
      Dovetail.Bulge      = -1.000
    end
   -- =============]]
  elseif xy_origin == MaterialBlock.BRC then
    xy_origin_text = "Bottom Right Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 90.000
      Dovetail.Direction2 = 180.000
      Dovetail.Direction3 = 90.000
      Dovetail.Direction4 = 0.000
      Dovetail.Bulge      = -1.000
    else
      Dovetail.Direction1 = 180.000
      Dovetail.Direction2 = 90.000
      Dovetail.Direction3 = 180.000
      Dovetail.Direction4 = 270.000
      Dovetail.Bulge      = 1.000
    end
  elseif xy_origin == MaterialBlock.TRC then
      xy_origin_text = "Top Right Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 270.000
      Dovetail.Direction2 = 180.000
      Dovetail.Direction3 = 270.000
      Dovetail.Direction4 = 0.000
      Dovetail.Bulge      = 1.000
    else
      Dovetail.Direction1 = 180.000
      Dovetail.Direction2 = 270.000
      Dovetail.Direction3 = 180.000
      Dovetail.Direction4 = 90.000
      Dovetail.Bulge      = -1.000
    end
  elseif xy_origin == MaterialBlock.TLC then
      xy_origin_text = "Top Left Corner"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 270.000
      Dovetail.Direction2 = 0.000
      Dovetail.Direction3 = 270.000
      Dovetail.Direction4 = 180.000
      Dovetail.Bulge      = -1.000
    else
      Dovetail.Direction1 = 0.000
      Dovetail.Direction2 = 270.000
      Dovetail.Direction3 = 0.000
      Dovetail.Direction4 = 90.000
      Dovetail.Bulge      = 1.000
    end
  elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
      xy_origin_text = "Center"
    if Dovetail.Orantation == "V" then
      Dovetail.Direction1 = 0.000
      Dovetail.Direction2 = 0.000
      Dovetail.Direction3 = 0.000
      Dovetail.Direction4 = 0.000
      Dovetail.Bulge      = 1.000
    else
      Dovetail.Direction1 = 0.000
      Dovetail.Direction2 = 0.000
      Dovetail.Direction3 = 0.000
      Dovetail.Direction4 = 0.000
      Dovetail.Bulge      = -1.000
    end
      MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
  else
      xy_origin_text = "Unknown XY origin value!"
      MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
      Dovetail.Direction1 = 0.000
      Dovetail.Direction2 = 0.000
      Dovetail.Direction3 = 0.000
      Dovetail.Direction4 = 0.000
  end
  -- Setup Fingers and Gaps
  Dovetail.NoFingers0 = 1 + (Rounder(Dovetail.MaterialLength / Dovetail.MaterialThickness, 0))
  Dovetail.NoFingers2 = Rounder(Dovetail.NoFingers0 / 2, 0)
  Dovetail.FingerSize = Dovetail.MaterialLength /  Dovetail.NoFingers0
  Dovetail.NoFingers1 = Dovetail.NoFingers0 - Dovetail.NoFingers2
	return true
end -- function end
-- ===================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end-- function end
-- ===================================================]]
function Rounder(num, idp)                              -- reduce the size of the fraction to idp places
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
-- ===================================================]]
function InquiryDovetail(Header)
  local myHtml = [[<html> <head> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css">html{overflow:hidden}body{background-color:#EBEBEB}body,td,th{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000}.FormButton{font-weight:bold;width:50px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton-c{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton2{font-weight:bold;width:40%;font-family:Arial,Helvetica,sans-serif;font-size:12px}body{background-color:#EBEBEB}.h2{font-size:12px;font-weight:bold;text-wrap:none}.h21{font-size:12px;font-weight:bold;text-align:right;text-wrap:none;vertical-align:middle}</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "445" border = "0" cellpadding = "0"> <tr> <td colspan="5" align="center" bgcolor="#EBEBEB"> <span style="width: 33%"> <input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Layer Names" style = "width: 50%"> <strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_Bottle_Carrier-Page1" target="_blank" class="helpbutton">Help</a> </strong> </span> </td> </tr> <tr> <td width="29%" align="right" nowrap bgcolor="#EBEBEB"> <span style="width: 25%"> <span class="h2" style="width: 25%">Side Thickness</span> </span> </td> <td width="18%" align="left" bgcolor="#EBEBEB"> <span class="h2"> <span style="width: 25%"> <input name="Dovetail.SideThickness" type="text" class="h2" id="Dovetail.SideThickness" size="10" maxlength="10" /> </span> </span> </td> <td width="30%" align="right" nowrap bgcolor="#EBEBEB" > <span class="h2"> <span class="h21" style="width: 25%">Material Width</span> </span> </td> <td width="21%" align="right" nowrap bgcolor="#EBEBEB" > <span class="h21"> <span class="h2"> <input name="Dovetail.MaterialWidth" type="text" class="h2" id="Dovetail.MaterialWidth" size="10" maxlength="10" /> </span> </span> </td> </tr> <tr> <td align="right" nowrap bgcolor="#EBEBEB" > <span class="h2" style="width: 25%">Front Thickness</span> </td> <td align="left" bgcolor="#EBEBEB" > <span class="h2"> <input name="Dovetail.FrontThickness" type="text" class="h2" id="Dovetail.FrontThickness" size="10" maxlength="10" /> </span> </td> <td align="right" nowrap bgcolor="#EBEBEB" class="h21" >Dovetail Tool Angle:</td> <td align="right" nowrap bgcolor="#EBEBEB" class="h21" > <input name="Dovetail.DovetailToolAngle" type="text" class="h2" id="Dovetail.DovetailToolAngle" size="10" maxlength="10" /> </td> </tr> <tr> <td align="right" nowrap bgcolor="#EBEBEB" > <span class="h21">Tail Tool Diameter: </span> </td> <td align="left" bgcolor="#EBEBEB" > <span class="h2"> <input name="Dovetail.StrightToolDia" type="text" class="h2" id="Dovetail.StrightToolDia" size="10" maxlength="10" /> </span> </td> <td align="right" nowrap bgcolor="#EBEBEB" class="h21" >Dovetail Tool Diameter:</td> <td align="right" nowrap bgcolor="#EBEBEB" class="h21" > <span class="h2"> <input name="DovetailToolDia" type="text" class="h2" id="Dovetail.DovetailToolDia" size="10" maxlength="10" /> </span> </td> </tr> </table> <table width="100%" border="0"> <tr> <td colspan="3"> <hr> </td> </tr> <tr> <td width="268"> <span style="width: 20%"> <span style="width: 25%"> <input id = "InquiryAbout" class = "FormButton" name = "InquiryAbout" type = "button" value = "About" > </span> </span> </td> <td width="90" align="center" class="FormButton"> <span class="H1-c"> <input id = "ButtonOK" class = "FormButton-c" name = "ButtonOK" type = "button" value = "OK"> </span> </td> <td width="75" align="center" class="FormButton"> <span class="H1-c"> <input id = "ButtonCancel" class = "FormButton-c" name = "ButtonCancel" type = "button" value = "Cancel"> </span> </td> </tr> </table> </body> </html>]]
  local dialog = HTML_Dialog(true, myHtml, 475, 250,  Header)
  dialog:AddDoubleField("Dovetail.StrightToolDia",    Dovetail.StrightToolDia)
  dialog:AddDoubleField("Dovetail.DovetailToolAngle", Dovetail.DovetailToolAngle)
  dialog:AddDoubleField("Dovetail.DovetailToolDia",   Dovetail.DovetailToolDia)
  dialog:AddDoubleField("Dovetail.MaterialWidth",     Dovetail.MaterialWidth)
  dialog:AddDoubleField("Dovetail.SideThickness",     Dovetail.SideThickness)
  dialog:AddDoubleField("Dovetail.FrontThickness",    Dovetail.FrontThickness)
  dialog:AddDoubleField("Dovetail.DovetailCount",     Dovetail.DovetailCount)
  if  dialog:ShowDialog() then
    Dovetail.MaterialWidth = dialog:GetDoubleField("Dovetail.MaterialWidth")
    Dovetail.SideThickness = dialog:GetDoubleField("Dovetail.SideThickness")
    Dovetail.FrontThickness = dialog:GetDoubleField("Dovetail.FrontThickness")
    Dovetail.StrightToolDia =  dialog:GetDoubleField("Dovetail.StrightToolDia")
    Dovetail.DovetailToolAngle = dialog:GetDoubleField("Dovetail.DovetailToolAngle")
    Dovetail.DovetailToolDia = dialog:GetDoubleField("Dovetail.DovetailToolDia")

    Dovetail.InquiryDovetailX = dialog.WindowWidth
    Dovetail.InquiryDovetailY = dialog.WindowHeight
    Mill_Math()
    WriteRegistry()
  end
end
-- ===================================================]]
function OnLuaButton_InquiryLayers()
  local myHtml = [[<html> <head> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css">.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap}.ErrorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.H1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;white-space:nowrap}.H1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px}.H2-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}.Helpbutton{background-color:#E1E1E1;border:1pxsolid#999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px2px;color:#000}.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}body{overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}html{overflow:hidden}</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "514" border = "0" cellpadding = "0"> <tr> <td width="36%" align="right" nowrap bgcolor="#EBEBEB" class="H1-rP"> <span style="width: 25%"> <span class="h2" style="width: 25%">Side Thickness</span> </span> </td> <td width="12%" align="left" bgcolor="#EBEBEB"> <span class="h2"> <span style="width: 25%"> <input name="Dovetail.SideThickness" type="text" class="h2" id="Dovetail.SideThickness" size="10" maxlength="10" /> </span> </span> </td> <td width="39%" align="right" nowrap bgcolor="#EBEBEB" class="H1-rP"> <span class="h2" style="width: 25%">Material Width</span> </span> </td> <td width="13%" align="right" nowrap bgcolor="#EBEBEB" class="H1-l"> <span class="h21"> <span class="h2"> <input name="Dovetail.MaterialWidth" type="text" class="h2" id="Dovetail.MaterialWidth" size="10" maxlength="10" /> </span> </span> </td> </tr> <tr> <td align="right" nowrap bgcolor="#EBEBEB" class="H1-rP" > <span class="h2" style="width: 25%">Front Thickness</span> </td> <td align="left" bgcolor="#EBEBEB" > <span class="h2"> <input name="Dovetail.FrontThickness" type="text" class="h2" id="Dovetail.FrontThickness" size="10" maxlength="10" /> </span> </td> <td align="right" nowrap bgcolor="#EBEBEB" class="H1-rP" >Dovetail Tool Angle:</td> <td align="right" nowrap bgcolor="#EBEBEB" class="H1-l" > <input name="Dovetail.DovetailToolAngle" type="text" class="h2" id="Dovetail.DovetailToolAngle" size="10" maxlength="10" /> </td> </tr> <tr> <td align="right" nowrap bgcolor="#EBEBEB" class="H1-rP" > <span class="h21">Tail Tool Diameter: </span> </td> <td align="left" bgcolor="#EBEBEB" > <span class="h2"> <input name="Dovetail.StrightToolDia" type="text" class="h2" id="Dovetail.StrightToolDia" size="10" maxlength="10" /> </span> </td> <td align="right" nowrap bgcolor="#EBEBEB" class="H1-rP" >Dovetail Tool Diameter:</td> <td align="right" nowrap bgcolor="#EBEBEB" class="H1-l" > <span class="h2"> <input name="DovetailToolDia" type="text" class="h2" id="Dovetail.DovetailToolDia" size="10" maxlength="10" /> </span> </td> </tr> </table> <table width="100%" border="0"> <tr> <td colspan="3"> <hr> </td> </tr> <tr> <td width="51" height="31" align="center"> <span style="width: 33%"> <strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_Bottle_Carrier-Page1" target="_blank" class="Helpbutton">Help</a> </strong> </span> </td> <td width="306" class="Alert"> <label class="H1-l">-</label> </td> <td width="143" align="center" > <span style="width: 33%"> <input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Set Layer Names"> </span> </td> </tr> </table> <table width="100%" border="0"> <tr> <td colspan="3"> <hr> </td> </tr> <tr> <td width="268"> <span style="width: 25%"> <input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About" > </span> </td> <td width="90" align="center" class="FormButton"> <span class="H1-c"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span> </td> <td width="75" align="center" class="FormButton"> <span class="H1-c"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span> </td> </tr> </table> </body> </html>]]
  local dialog = HTML_Dialog(true, myHtml, 590, 250, "Layer Setup") ;
  dialog:AddTextField("Dovetail.LayerNameClearing",     Dovetail.LayerNameClearing)
  dialog:AddTextField("Dovetail.LayerNameSideBroad",    Dovetail.LayerNameSideBroad)
  dialog:AddTextField("Dovetail.LayerNameSidePocket",   Dovetail.LayerNameSidePocket)
  dialog:AddTextField("Dovetail.LayerNameDovetailPath", Dovetail.LayerNameDovetailPath)
  dialog:AddTextField("Dovetail.LayerNameFrontBroad",   Dovetail.LayerNameFrontBroad)
  if  dialog:ShowDialog() then
    Dovetail.LayerNameClearing     = dialog:GetTextField("Dovetail.LayerNameClearing")
    Dovetail.LayerNameSidePocket   = dialog:GetTextField("Dovetail.LayerNameSidePocket")
    Dovetail.LayerNameSideBroad    = dialog:GetTextField("Dovetail.LayerNameSideBroad")
    Dovetail.LayerNameDovetailPath = dialog:GetTextField("Dovetail.LayerNameDovetailPath")
    Dovetail.LayerNameFrontBroad   = dialog:GetTextField("Dovetail.LayerNameFrontBroad")
    Dovetail.InquiryLayersX        = dialog.WindowWidth
    Dovetail.InquiryLayersY        = dialog.WindowHeight
    WriteRegistry()
  end
  return true
end
-- ===================================================]]
function OnLuaButton_InquiryAbout()
--[[
    Shows the user program information
    Caller = OnLuaButton_InquiryAbout()
    Dialog Header = "Easy Dovetail Maker"
    Returns = True
]]
    local myHtml = [[<html> <head> <title>About</title> <style type = "text/css"> html{overflow:hidden}body,td,th{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;background-color:#EBEBEB }.FormButton{font-weight:bold;width:40%;font-family:Arial,Helvetica,sans-serif;font-size:12px }.h1{font-size:16px;font-weight:bold;text-align:center;text-wrap:none; vertical-align:middle }.h2{font-size:10px;text-align:center;text-wrap:none;vertical-align:middle }.h3{font-size:12px;font-weight:bold;text-align:center;text-wrap:none;vertical-align:middle }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width="213" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="h1">Easy Dovetail Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" class="h2" id="Version"> <label>-</label> </td> </tr> <tr> <td align="center" nowrap="nowrap"> <hr> </td> </tr> <tr> <td align="center" nowrap="nowrap" class="h3">James Anderson</td> </tr> <tr> <td align="center" nowrap="nowrap"> <a href="James.L.Anderson@outlook.com">James.L.Anderson@outlook.com</a> </td> </tr> <tr> <td align="center" nowrap="nowrap"> <a href="http://www.jimandi.com">www.JimAndi.com</a> </td> </tr> <tr> <td align="center" nowrap="nowrap"> <span class="h3">(281) 728-3028 </span> </td> </tr> <tr> <td align="center" nowrap="nowrap"> <span class="h3">Houston, TX.</span> </td> </tr> <tr> <td align="center" nowrap="nowrap"> <hr> </td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </body> </html>]]
  local dialog = HTML_Dialog(true, myHtml, 250, 255, "About")
  dialog:AddLabelField("Version", Dovetail.Version)
  dialog:ShowDialog()
  Dovetail.InquiryAboutX = dialog.WindowWidth
  Dovetail.InquiryAboutY = dialog.WindowHeight
  WriteRegistry()
  return  true
end
-- ===================================================]]
function OnLuaButton_InquiryError(Message)
  local myHtml = [[<html> <head> <title>Error</title> <style type = "text/css">.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap}.Error{font-family:Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#F00;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.ErrorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.ErrorTable{background-color:#FFF white-space:nowrap}html{overflow:hidden}</style> </head> <body text = "#000000"> <table width="100%" border="0" cellpadding="0" class="ErrorTable"> <tr> <th align="center" nowrap="nowrap" class="Error">Error!</th> </tr> <tr> <td id="ErrorMessage"> <label class="ErrorMessage">-</label> </tr> <tr> <td width="30%" align="right" style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "Exit"> </td> </tr> </table> </body> </html>]]

  local dialogWide =  (#Message + 300)
  local dialog = HTML_Dialog(true, myHtml, 250, dialogWide, "Gadget Error") ;
  dialog:AddLabelField("ErrorMessage",   Message)
  dialog:ShowDialog()
  Dovetail.InquiryErrorX = dialog.WindowWidth
  Dovetail.InquiryErrorY = dialog.WindowHeight
  WriteRegistry()
  return  true
end
-- ===================================================]]
function main()  -- script_path
  Dovetail.job = VectricJob()
  if not Dovetail.job.Exists then
    DisplayMessageBox("Error: No job loaded")
    return false ;
  end
  ReadRegistry()
-- Read the Material Configuration and set global setting
  GetMaterialSettings()
  Dovetail_Math()
  Mill_Math()
  Dovetail.Drawing = InquiryDovetail("Easy Dovetail Maker")
  Dovetail_Math()
  Mill_Math()
  ReadRegistry()
  Dovetail_Front()
  Dovetail_Side()
  Dovetail_Path()
  Dovetail.job:Refresh2DView()
  return true
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
  Dovetail.ptx = Polar2D(Dovetail.pt01,  90.0,   Dovetail.DovetailCenters  + Dovetail.PinStart)
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
      Dovetail.ptx = Polar2D(Dovetail.ptx,    180.0, (Dovetail.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
      LoopOver = false
    end
    line:LineTo(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx, 90.000, Dovetail.DovetailCenters * 2.0 )
  end
  if LoopOver then
    Dovetail.ptx = Polar2D(Polar2D(Dovetail.ptx, 270.000, Dovetail.DovetailCenters * 2.0 ), 0.000, 0.125)
    line:LineTo(Dovetail.ptx)
  else
    Dovetail.ptx = Polar2D(Polar2D(Dovetail.g_pt3,    180.0, Dovetail.DovetailToolRadius  + 0.125),  90.0, (Dovetail.DovetailToolRadius  + 0.125))
    line:LineTo(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Polar2D(Dovetail.g_pt2,    0.0, Dovetail.DovetailToolRadius  + 0.25),  90.0, (Dovetail.DovetailToolRadius  + 0.125))
    line:LineTo(Dovetail.ptx)
  end
  line:LineTo(Dovetail.pt02)
  layer:AddObject(CreateCadContour(line), true)
  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function Dovetail_Side()
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSideBroad)
  local line = Contour(0.0)
  line:AppendPoint(Dovetail.g_pt1)
  line:LineTo(Dovetail.g_pt2)
  line:LineTo(Dovetail.g_pt3)
  line:LineTo(Dovetail.g_pt4)
  line:LineTo(Dovetail.g_pt1)
  layer:AddObject(CreateCadContour(line), true)
  Dovetail.ptx = Polar2D(Dovetail.g_pt1,  90.0,    Dovetail.PinStart + Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  for _ = Dovetail.PathCount - 1, 1 , -1     do
    DovetailPockets(Dovetail.ptx)
    Dovetail.ptx = Polar2D(Dovetail.ptx,  90.0, Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
  DovetailPocketsEnds()
  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function Dovetail_Front()
  local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameFrontBroad)
  local line = Contour(0.0)
  line:AppendPoint(Dovetail.g_pt1)
  line:LineTo(Dovetail.g_pt2)
  line:LineTo(Dovetail.g_pt3)
  line:LineTo(Dovetail.g_pt4)
  line:LineTo(Dovetail.g_pt1)
  layer:AddObject(CreateCadContour(line), true)
  local ptx = Polar2D(Dovetail.g_pt1, 90.0, Dovetail.PinStart + Dovetail.DovetailCenters )
  local tx = Dovetail.MaterialWidth
  while (tx > Dovetail.DovetailCenters + Dovetail.DovetailCenters) do
    Dovetails(ptx)
    ptx = Polar2D(ptx,  90.0, Dovetail.DovetailCenters + Dovetail.DovetailCenters )
    tx = tx - (Dovetail.DovetailCenters + Dovetail.DovetailCenters)
  end
  Dovetail.job:Refresh2DView()
  return true
end
-- ===================================================]]
function DovetailPockets(xpt1)
    local layer = Dovetail.job.LayerManager:GetLayerWithName(Dovetail.LayerNameSidePocket)
    local line = Contour(0.0)
    local pt02 = Polar2D(xpt1,  180.0,  Dovetail.FrontThickness)
    local pt01 = Polar2D(xpt1,   90.0,  Dovetail.ClearingWidth * 0.5)
    local pt04 = Polar2D(pt01,  270.0,  Dovetail.ClearingWidth * 0.5)
          pt02 = Polar2D(pt02,   90.0,  Dovetail.DovetailToolRadius)
    local pt03 = Polar2D(pt02,  270.0,  Dovetail.DovetailToolRadius)
          pt01 = Polar2D(pt01, (360.0 - Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
          pt04 = Polar2D(pt04, Dovetail.DovetailToolAngle, Dovetail.StrightToolDia)
          pt02 = Polar2D(pt02, (180.0 - Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
          pt03 = Polar2D(pt03, (180.0 + Dovetail.DovetailToolAngle), Dovetail.StrightToolDia)
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
    local pt2   = Polar2D(pt1, 180.0, Dovetail.SideThickness)
    local pt01  = Polar2D(Polar2D(pt1,  90.0, (Dovetail.ClearingWidth * 0.5)), 0.0, Dovetail.StrightToolDia)
    local pt04  = Polar2D(Polar2D(pt1, 270.0, (Dovetail.ClearingWidth * 0.5)), 0.0, Dovetail.StrightToolDia)
    local pt02  = Polar2D(Polar2D(pt2,  90.0, (Dovetail.ClearingWidth * 0.5)), 180.0, Dovetail.StrightToolDia)
    local pt03  = Polar2D(Polar2D(pt2, 270.0, (Dovetail.ClearingWidth * 0.5)), 180.0, Dovetail.StrightToolDia)
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
  local pt01 = Polar2D(Polar2D(Dovetail.g_pt1, 90.0, (Dovetail.ClearingWidth * 0.5) + Dovetail.PinStart), (360.0 - Dovetail.DovetailToolAngle),   Dovetail.StrightToolDia)
  pt02 = Polar2D(Polar2D(pt02, 90.0, Dovetail.DovetailToolRadius + Dovetail.PinStart ), (180.0 - Dovetail.DovetailToolAngle),   Dovetail.StrightToolDia)
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
  pt02 = Polar2D(Polar2D(pt02, 270.0, Dovetail.DovetailToolRadius + Dovetail.PinStart),   (180.0 + Dovetail.DovetailToolAngle),   Dovetail.StrightToolDia)
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
--  ================ End ===============================