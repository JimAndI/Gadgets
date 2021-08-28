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
--=================================================== ]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
local Hinge = {}
local Milling = {}
Hinge.VerNumber = "3.4"
Hinge.AppName = "Easy Euro Hinge Maker"
Hinge.RegName = "EasyEuroHingeMaker" .. Hinge.VerNumber
Hinge.DialogLoop = true
local Tool_ID1 = ToolDBId()
local Tool_ID2 = ToolDBId()
local Tool_ID3 = ToolDBId()
local Tool_ID4 = ToolDBId()
local lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
Tool_ID1:LoadDefaults("My Profile1",   "")
Tool_ID2:LoadDefaults("My Pocket2",    "")
Tool_ID3:LoadDefaults("My Clearing3",  "")
Tool_ID4:LoadDefaults("My DrillPath4", "")
--=================================================== ]]
function REG_ReadRegistry() -- Read from Registry values
  local RegistryRead     = Registry(Hinge.RegName)
  Hinge.Count            = RegistryRead:GetInt("Hinge.Count", 2)
  Hinge.Side             = RegistryRead:GetDouble("Hinge.Side", 0.0)
  Hinge.HoleDiameter     = RegistryRead:GetDouble("Hinge.HoleDiameter", 1.377953)
  Hinge.HoleSetBack      = RegistryRead:GetDouble("Hinge.HoleSetBack", 0.807087)
  Hinge.ScrewDiameter    = RegistryRead:GetDouble("Hinge.ScrewDiameter", 0.314961)
  Hinge.ScrewHoleSetBack = RegistryRead:GetDouble("Hinge.ScrewHoleSetBack", 0.433071)
  Hinge.ScrewCenter      = RegistryRead:GetDouble("Hinge.ScrewCenter", 0.826772)
  Hinge.CornerDistance   = RegistryRead:GetDouble("Hinge.CornerDistance", 3.5)
  Hinge.HoleLayer        = RegistryRead:GetString("Hinge.HoleLayer", "Hinge Hole Layer")
  Hinge.ScrewHoleLayer   = RegistryRead:GetString("Hinge.ScrewHoleLayer", "Screw Hole Layer")
  Hinge.Placement        = RegistryRead:GetString("Hinge.Placement", "Right")
  Hinge.HoleDepth        = RegistryRead:GetDouble("Hinge.HoleDepth", 0.5125)
  Hinge.ScrewDepth       = RegistryRead:GetDouble("Hinge.ScrewDepth", 0.5125)
  return true
end --function end
--=================================================== ]]
function GetDistance(objA, objB)
   local xDist = objB.x - objA.x
   local yDist = objB.y - objA.y
   return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end
--=================================================== ]]
function REG_WriteRegistry() -- Write to Registry values
  local RegistryWrite = Registry(Hinge.RegName)
  local RegValue = RegistryWrite:SetInt("Hinge.Count", Hinge.Count)
        RegValue = RegistryWrite:SetDouble("Hinge.Side", Hinge.Side)
        RegValue = RegistryWrite:SetDouble("Hinge.HoleDiameter", Hinge.HoleDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.HoleSetBack", Hinge.HoleSetBack)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewDiameter", Hinge.ScrewDiameter)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewHoleSetBack", Hinge.ScrewHoleSetBack)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewCenter", Hinge.ScrewCenter)
        RegValue = RegistryWrite:SetDouble("Hinge.CornerDistance", Hinge.CornerDistance)
        RegValue = RegistryWrite:SetString("Hinge.HoleLayer", Hinge.HoleLayer)
        RegValue = RegistryWrite:SetString("Hinge.ScrewHoleLayer", Hinge.ScrewHoleLayer)
        RegValue = RegistryWrite:SetString("Hinge.Placement", Hinge.Placement)
        RegValue = RegistryWrite:SetDouble("Hinge.InquiryHingeX", Hinge.InquiryHingeX)
        RegValue = RegistryWrite:SetDouble("Hinge.InquiryHingeY", Hinge.InquiryHingeY)
        RegValue = RegistryWrite:SetDouble("Hinge.HoleDepth", Hinge.HoleDepth)
        RegValue = RegistryWrite:SetDouble("Hinge.ScrewDepth", Hinge.ScrewDepth)
        RegValue = RegistryWrite:SetDouble("Hinge.InquiryHelpX", Hinge.InquiryHelpX)
        RegValue = RegistryWrite:SetDouble("Hinge.InquiryHelpY", Hinge.InquiryHelpY)
        RegValue = RegistryWrite:SetDouble("Hinge.InquiryAboutX", Hinge.InquiryAboutX)
        RegValue = RegistryWrite:SetDouble("Hinge.InquiryAboutY", Hinge.InquiryAboutY)
  return true
end -- function end
--=================================================== ]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ================================================== ]]
function InquiryHinge(Header)
    local myHtml = [[<html> <head> <title>Cabinet Door Hinge Creator</title> <style type = "text/css">html{overflow:hidden}
.LuaButton{font-weight:bold; font-family:Arial,Helvetica,sans-serif; font-size:12px; alignment-adjust:middle; }
.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.ToolPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right}
.h1-rp{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;padding-right:4px;padding-left:4px}
.alert{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;color:#00F;text-align:center}
.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center} body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style>
</head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "100%" border = "0" cellpadding = "0"> <tr> <td nowrap class = "h1-r"> <span class = "h1-rp">Hinge Hole Layer</span> <input name = "Hinge.HoleLayer" type = "text" class = "h1-l" id = "Hinge.HoleLayer" size = "75" maxlength = "160" /> </td> </tr> <tr> <td nowrap class = "h1-r"> <span class = "h1-rp">Screw Hole Layer</span> <input name = "Hinge.ScrewHoleLayer" type = "text" class = "h1-l" id = "Hinge.ScrewHoleLayer" size = "75" maxlength = "160" /> </td> </tr> </table> <table width = "100%" border = "0" cellpadding = "0"> <tr> <td colspan = "11" align = "right" nowrap class = "h1-r"> <hr> </td> </tr> <tr> <td colspan = "2" align = "right" nowrap class = "h1-c"> <span class = "h1-c"> <strong>Diameters</strong> </span> </td> <td width = "3" rowspan = "4" align = "right" nowrap bgcolor = "#FFFFFF">&nbsp;</td> <td colspan = "2" align = "right" nowrap class = "h1-c"> <strong>Setbacks</strong> </td> <td width = "3" rowspan = "4" align = "right" nowrap bgcolor = "#FFFFFF">&nbsp;</td> <td colspan = "2" align = "right" nowrap class = "h1-c"> <strong>Distance</strong> </td> <td width = "3" rowspan = "4" align = "right" nowrap bgcolor = "#FFFFFF" class = "h1-c">&nbsp;</td> <td colspan = "2" align = "right" nowrap class = "h1-c"> <strong>Depth</strong> </td> </tr> <tr> <td width = "10%" align = "right" nowrap class = "h1-rp">Hinge Hole</td> <td width = "10%" nowrap> <input name = "Hinge.HoleDiameter" type = "text" id = "Hinge.HoleDiameter" size = "10" maxlength = "10" /> </td> <td width = "10%" nowrap class = "h1-rp">Hinge Hole</td> <td width = "10%" align = "right" nowrap class = "h1-r"> <span class = "h1-l"> <input name = "Hinge.HoleSetBack" type = "text" id = "Hinge.HoleSetBack" size = "10" maxlength = "10" /> </span> </td> <td width = "10%" nowrap class = "h1-rp">Hinge to Corner</td> <td width = "10%" nowrap class = "h1-l"> <input name = "Hinge.CornerDistance" type = "text" class = "h2" id = "Hinge.CornerDistance" size = "10" maxlength = "10" /> </td> <td width = "10%" align = "right" nowrap class = "h1-rp">Hinge Hole</td> <td width = "10%" nowrap> <input name = "Hinge.HoleDepth" type = "text" id = "Hinge.HoleDepth" size = "10" maxlength = "10" /> </td> </tr> <tr> <td width = "10%" align = "right" nowrap class = "h1-rp">Screw Hole</td> <td width = "10%" nowrap> <input name = "Hinge.ScrewDiameter" type = "text" id = "Hinge.ScrewDiameter" size = "10" maxlength = "10" /> </td> <td width = "10%" nowrap class = "h1-rp">Screw Hole</td> <td width = "10%" align = "right" nowrap class = "h1-r"> <span class = "h1-l"> <input name = "Hinge.ScrewHoleSetBack" type = "text" id = "Hinge.ScrewHoleSetBack" size = "10" maxlength = "10" /> </span> </td> <td width = "10%" nowrap class = "h1-rp">Screw Center</td> <td width = "10%" nowrap > <input name = "Hinge.ScrewCenter" type = "text" id = "Hinge.ScrewCenter" size = "10" maxlength = "10" /> </td> <td width = "10%" align = "right" nowrap class = "h1-rp">Screw Hole</td> <td width = "10%" nowrap> <input name = "Hinge.ScrewDepth" type = "text" id = "Hinge.ScrewDepth" size = "10" maxlength = "10" /> </td> </tr> <tr> <td width = "10%" align = "right" nowrap>&nbsp;</td> <td width = "10%" nowrap>&nbsp;</td> <td width = "10%" nowrap class = "h1-rp">Placement</td> <td width = "10%" class = "h1-l"> <select name = "Hinge.Placement" size = "1" id = "Hinge.Placement"> <option value = "0" selected>Right</option> <option value = "180">Left</option> <option value = "90">Top</option> <option value = "270">Bottom</option> </select> </td> <td width = "10%" nowrap class = "h1-rp">Hinge Count</td> <td width = "10%" nowrap class = "h1-l"> <select name = "Hinge.Count" size = "1" id = "Hinge.Count"> <option>2</option> <option>3</option> <option>4</option> </select> </td> <td colspan = "2" nowrap class = "h1-c"> <input id = "InquiryHelp" class = "LuaButton" name = "InquiryHelp" type = "button" value = "Help" > </td> </tr> </table> <table width = "100%" border = "0"> <tr> <td colspan = "3" align = "right" nowrap class = "h1-r"> <hr> </td> </tr> <tr> <td width = "120" align = "right" nowrap class = "h1-r">Profile Tool:</td> <td nowrap = "nowrap" class = "ToolNameLabel"> <span id = "ToolNameLabel1">-</span> </td> <td width = "49" nowrap class = "ToolPicker"> <strong> <input id = "ToolChooseButton1" class = "ToolPicker" name = "ToolChooseButton1" type = "button" value = "Tool"> </strong> </td> </tr> <tr> <td align = "right" nowrap class = "h1-r" >Pocket Tool:</td> <td nowrap = "nowrap" class = "ToolNameLabel"> <span id = "ToolNameLabel2">-</span> </td> <td nowrap class = "ToolPicker"> <strong> <input id = "ToolChooseButton2" class = "ToolPicker" name = "ToolChooseButton2" type = "button" value = "Tool"> </strong> </td> </tr> <tr> <td align = "right" nowrap class = "h1-r" >Pocket Clearing Tool:</td> <td nowrap = "nowrap" class = "ToolNameLabel"> <span id = "ToolNameLabel3">-</span> </td> <td nowrap class = "ToolPicker"> <strong> <input id = "ToolChooseButton3" class = "ToolPicker" name = "ToolChooseButton3" type = "button" value = "Tool"> </strong> </td> </tr> <tr> <td align = "right" nowrap class = "h1-r" >Drilling Tool:</td> <td nowrap = "nowrap" class = "ToolNameLabel"> <span id = "ToolNameLabel4">-</span> </td> <td nowrap class = "ToolPicker"> <strong> <input id = "ToolChooseButton4" class = "ToolPicker" name = "ToolChooseButton4" type = "button" value = "Tool"> </strong> </td> </tr> <tr> <td align = "right" nowrap class = "h1-r" >&nbsp;</td> <td nowrap = "nowrap" class = "h1-r"> <strong>Add Holding Tabs</strong> <input type = "checkbox" name = "Milling.Tabs2" id = "Milling.Tabs2"> </td> <td nowrap class = "h1-c">&nbsp;</td> </tr> </table> <table width = "100%" border = "0" cellpadding = "0"> <tr> <td colspan = "3"> <hr> </td> </tr> <tr> <td> <input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout2" type = "button" value = "About" > </td> <td class = "FormButton"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> <td class = "FormButton"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td> </tr> </table> </body> </html>]]
    local dialog = HTML_Dialog(true, myHtml, 762, 425,  Header .. " (Ver:" .. Hinge.VerNumber.. ")") ;
    dialog:AddTextField("Hinge.HoleLayer", Hinge.HoleLayer)
    dialog:AddTextField("Hinge.ScrewHoleLayer",     Hinge.ScrewHoleLayer)
    dialog:AddDoubleField("Hinge.HoleDiameter",     Hinge.HoleDiameter)
    dialog:AddDoubleField("Hinge.HoleDepth",        Hinge.HoleDepth)
    dialog:AddDoubleField("Hinge.HoleSetBack",      Hinge.HoleSetBack)
    dialog:AddDoubleField("Hinge.CornerDistance",   Hinge.CornerDistance)
    dialog:AddDoubleField("Hinge.ScrewDiameter",    Hinge.ScrewDiameter)
    dialog:AddDoubleField("Hinge.ScrewDepth",       Hinge.ScrewDepth)
    dialog:AddDoubleField("Hinge.ScrewCenter",      Hinge.ScrewCenter)
    dialog:AddDropDownList("Hinge.Placement",       Hinge.Placement)
    dialog:AddDropDownList("Hinge.Count",           tostring(Hinge.Count))
    dialog:AddDoubleField("Hinge.ScrewHoleSetBack", Hinge.ScrewHoleSetBack)
    dialog:AddLabelField("ToolNameLabel1", "Not Selected")
    dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
    dialog:AddToolPickerValidToolType("ToolChooseButton1", Tool.END_MILL)
    dialog:AddLabelField("ToolNameLabel2", "Not Selected")
    dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
    dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
    dialog:AddLabelField("ToolNameLabel3", "Not Selected")
    dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
    dialog:AddToolPickerValidToolType("ToolChooseButton3", Tool.END_MILL)
    dialog:AddLabelField("ToolNameLabel4", "Not Selected")
    dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID3)
    dialog:AddToolPickerValidToolType("ToolChooseButton4", Tool.THROUGH_DRILL)
    if  dialog:ShowDialog() then
      Hinge.HoleDiameter     = dialog:GetDoubleField("Hinge.HoleDiameter")
      Hinge.HoleSetBack      = dialog:GetDoubleField("Hinge.HoleSetBack")
      Hinge.CornerDistance   = dialog:GetDoubleField("Hinge.CornerDistance")
      Hinge.ScrewDiameter    = dialog:GetDoubleField("Hinge.ScrewDiameter")
      Hinge.HoleDepth        = dialog:GetDoubleField("Hinge.HoleDepth")
      Hinge.ScrewDepth       = dialog:GetDoubleField("Hinge.ScrewDepth")
      Hinge.ScrewHoleSetBack = dialog:GetDoubleField("Hinge.ScrewHoleSetBack")
      Hinge.ScrewCenter      = dialog:GetDoubleField("Hinge.ScrewCenter")
      Hinge.Placement        = dialog:GetDropDownListValue("Hinge.Placement")
      Hinge.Count            = tonumber(dialog:GetDropDownListValue("Hinge.Count"))
      Hinge.HoleLayer        = dialog:GetTextField("Hinge.HoleLayer")
      Hinge.ScrewHoleLayer   = dialog:GetTextField("Hinge.ScrewHoleLayer")
      Milling.MillTool1      = dialog:GetTool("ToolChooseButton1")  -- Profile
      Milling.MillTool2      = dialog:GetTool("ToolChooseButton2")  -- Pocketing
      Milling.MillTool3      = dialog:GetTool("ToolChooseButton3")  -- Clearing
      Milling.MillTool4      = dialog:GetTool("ToolChooseButton4")  -- Drilling
      Hinge.InquiryHingeX    = tostring(dialog.WindowWidth)
      Hinge.InquiryHingeY    = tostring(dialog.WindowHeight)
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
--=================================================== ]]
function AllTrim(s)                                     -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
--=================================================== ]]
function CheckDialogValues()                            -- Look at what the User inputed.
  Hinge.DialogLoop = false
  if Hinge.HoleDiameter    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Hole Diameter value")
  end
  if Hinge.HoleSetBack    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Hole Set Back value")
  end
  if Hinge.CornerDistance    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Corner Distance value")
  end
  if Hinge.ScrewDiameter    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Screw Diameter value")
  end
  if Hinge.ScrewHoleSetBack    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Screw Hole Set Back value")
  end
  if Hinge.ScrewCenter    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Screw Center value")
  end
  if Hinge.Placement    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Placement value")
  end
    if Hinge.HoleDepth    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Hole Depth value")
  end
    if Hinge.ScrewDepth    ==    0.0 then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Screw Depth value")
  end
  if  AllTrim(Hinge.HoleLayer)    ==    "" then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Hole Layer value")
  end
  if AllTrim(Hinge.ScrewHoleLayer)    ==    "" then
    Hinge.DialogLoop = true
    DisplayMessageBox("Error: Screw Hole Layer value")
  end
end -- function end
--=================================================== ]]
function main()

  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a Job being setup.\n" ..
      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
      "specify the material dimensions")
    return false ;
  end
  local Door                     = job.Selection
  Milling.MaterialBlock          = MaterialBlock()
  Milling.MaterialBlockThickness = Milling.MaterialBlock.Thickness
  Milling.Toolpath_Mgr           = ToolpathManager()

  if Door.IsEmpty then
    DisplayMessageBox("Error: Select a single closed vector of the outer door edge")
    return false
  end
  if not REG_ReadRegistry() then
      DisplayMessageBox("Error: Reading from Registry")
    return false
  end
  Hinge.HoleRadius  = Hinge.HoleDiameter * 0.5
  Hinge.ScrewRadius = Hinge.ScrewDiameter * 0.5
  local p1 = Point2D(1.0,1.0) ;
  local p2 = Point2D(1.0,1.0) ;
  local p3 = Point2D(1.0,1.0) ;
  local p4 = Point2D(1.0,1.0) ;
  local p5 = Point2D(1.0,1.0) ; -- H3 pt
  local p6 = Point2D(1.0,1.0) ; -- H4 pt
  local p7 = Point2D(1.0,1.0)
--=================================================== ]]
  while Hinge.DialogLoop do
    Hinge.Inquiry = InquiryHinge(Hinge.AppName .. " setting" )
    if Hinge.Inquiry    ==    true then
      Hinge.DialogLoop = false
      CheckDialogValues()
    else
      Hinge.DialogLoop = false
    end -- if end
  end -- while end
--=================================================== ]]
  if Hinge.Inquiry  then
    if Hinge.Placement     ==    "Right" then
      Hinge.Side = 0.0
    end
    if Hinge.Placement     ==    "Top" then
      Hinge.Side = 90.0
    end
    if Hinge.Placement     ==    "Left" then
      Hinge.Side = 180.0
    end
    if Hinge.Placement     ==    "Bottom" then
      Hinge.Side = 270.0
    end
    local  objects
    local Door_pos = Door:GetHeadPosition()
    objects, Door_pos = Door:GetNext(Door_pos)
    local pLine = objects:GetContour()
    if (objects.ClassName ~ =  "vcCadPolyline") then
      DisplayMessageBox("Select a single closed vector of the outer door edge")
      pLine = nil
    end
    if pLine ~ =  nil then
      local Doorbound = pLine.BoundingBox2D
      if Hinge.Side    ==    0.0 then
        p1 = Doorbound.BRC
        p2 = Doorbound.TRC
        p3 = Polar2D(p1,  90.0,  Hinge.CornerDistance)
        p4 = Polar2D(p2,  270.0,  Hinge.CornerDistance)
        p5 = Polar2D(p1,  90.0,  GetDistance(p1 , p2) * 0.5)  -- center pt
        p6 = Polar2D(p3,  90.0,  GetDistance(p3 , p4) * 0.3333)
        p7 = Polar2D(p4,  270.0,  GetDistance(p3 , p4) * 0.3333)
      end
      if Hinge.Side    ==    90.0 then
        p1 = Doorbound.TLC
        p2 = Doorbound.TRC
        p3 = Polar2D(p1,  0.0,  Hinge.CornerDistance)
        p4 = Polar2D(p2,  180.0,  Hinge.CornerDistance)
        p5 = Polar2D(p1,   0.0,  GetDistance(p1 , p2) * 0.5)  -- center pt
        p6 = Polar2D(p3,   0.0,  GetDistance(p3 , p4)  * 0.3333)
        p7 = Polar2D(p4,  180.0,  GetDistance(p3 , p4)  * 0.3333)
      end
      if Hinge.Side    ==    180.0 then
        p1 = Doorbound.TLC
        p2 = Doorbound.BLC
        p3 = Polar2D(p1,  270.0,  Hinge.CornerDistance)
        p4 = Polar2D(p2,  90.0,  Hinge.CornerDistance)
        p5 = Polar2D(p1,   270.0,  GetDistance(p1 , p2) * 0.5)  -- center pt
        p6 = Polar2D(p3,   270.0,  GetDistance(p3 , p4)  * 0.3333)
        p7 = Polar2D(p4,  90.0,  GetDistance(p3 , p4)  * 0.3333)
      end
      if Hinge.Side    ==    270.0 then
        p1 = Doorbound.BLC
        p2 = Doorbound.BRC
        p3 = Polar2D(p1,   0.0,  Hinge.CornerDistance)
        p4 = Polar2D(p2,  180.0,  Hinge.CornerDistance)
        p5 = Polar2D(p1,    0.0,  GetDistance(p1 , p2) * 0.5)  -- center pt
        p6 = Polar2D(p3,    0.0,  GetDistance(p3 , p4)  * 0.3333)
        p7 = Polar2D(p4,  180.0,  GetDistance(p3 , p4)  * 0.3333)
      end
    end
    if Hinge.Count    ==    2 then
      DrawHingeHole(job, p3, Hinge.Side)
      DrawHingeHole(job, p4, Hinge.Side)
    elseif Hinge.Count    ==    3 then
      DrawHingeHole(job, p3, Hinge.Side)
      DrawHingeHole(job, p4, Hinge.Side)
      DrawHingeHole(job, p5, Hinge.Side)
    elseif Hinge.Count    ==    4 then
      DrawHingeHole(job, p4, Hinge.Side)
      DrawHingeHole(job, p3, Hinge.Side)
      DrawHingeHole(job, p6, Hinge.Side)
      DrawHingeHole(job, p7, Hinge.Side)
    end
--[[
    CreateLayerProfileToolpath(Hinge.LayerNameBackProfile .. "Door", Hinge.Sheet .. "Wall Back Panel Profile", 0.0, Hinge.MaterialBlockThickness, "OUT", Hinge.Tabs)

    CreateLayerPocketingToolpath(Hinge.HoleLayer, "Hinge Hole Layer", 0.0, (Hinge.MaterialBlockThickness - Hinge.DadoHeight))

    CreateLayerDrillingToolpath(Hinge.ScrewHoleLayer, "Screw Hole Layer", 0.0, Hinge.ScrewDepth, Hinge.ScrewDepth * 0.25, Hinge.ScrewDepth * 0.35)
]]
    if not REG_WriteRegistry() then
      DisplayMessageBox("Error: Writting Registry")
      return false
    end
    job:Refresh2DView()
  end
  return true
end
-- =================================================== ]]
function OnLuaButton_InquiryAbout()
    local myHtml = [[<html> <head> <title>About</title> <style type = "text/css">html{overflow:hidden}
.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.ToolPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}
.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right}
.h1-rp{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;padding-right:4px;padding-left:4px}
.alert{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;color:#00F;text-align:center}
.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center}
.h1-cw{font-family:Arial,Helvetica,sans-serif;font-size:16px;text-align:center}
body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style> </head>
<body bgcolor = "#EBEBEB" text = "#000000"> <table width = "213" border = "0" cellpadding = "0"> <tr> <td align = "center" nowrap = "nowrap" class = "h1-cw" id = "SysName"> <strong>Easy Cabinet Maker</strong> </td> </tr> <tr> <td align = "center" nowrap = "nowrap" class = "h1-c" id = "Version">-</td> </tr> <tr> <td align = "center" nowrap = "nowrap"> <hr> </td> </tr> <tr> <td align = "center" nowrap = "nowrap" class = "h3"> <span class = "h1-c"> <strong>James Anderson</strong> </span> </td> </tr> <tr> <td align = "center" nowrap = "nowrap"> <span class = "h1-c"> <a href = "http://www.jimandi.com/EasyCabinetMaker/index.html">www.JimAndi.com</a> </span> </td> </tr> <tr> <td align = "center" nowrap = "nowrap"> <span class = "h1-c">(281) 728-3028</span> </td> </tr> <tr> <td align = "center" nowrap = "nowrap"> <span class = "h1-c">Houston, TX.</span> </td> </tr> <tr> <td align = "center" nowrap = "nowrap"> <hr> </td> </tr> <tr> <td width = "30%" align = "center" style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </body> </html>]]
    local dialog = HTML_Dialog(true, myHtml, 250, 230, "About")
    dialog:AddLabelField("SysName", Hinge.AppName)
    dialog:AddLabelField("Version", "Version: " .. Hinge.VerNumber)
    dialog:ShowDialog()
    Hinge.InquiryAboutX = dialog.WindowWidth
    Hinge.InquiryAboutY = dialog.WindowHeight
    return  true
  end

  -- =================================================== ]]
function OnLuaButton_InquiryHelp()
    local myHtml = [[<html> <head> <title>Help</title>
    <style type = "text/css">html{overflow:hidden}
    .LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
    .DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
    .ToolPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
    .ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
    .FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}
    .h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
    .h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right}
    .h1-rp{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;padding-right:4px;padding-left:4px}
    .alert{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;color:#00F;text-align:center}
    .h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center}
    .h1-cw{font-family:Arial,Helvetica,sans-serif;font-size:16px;text-align:center}
    body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style> </head>
    <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "213" border = "0" cellpadding = "0"> <tr> <td align = "center" nowrap = "nowrap" class = "h1-cw" id = "SysName"> <strong>Easy Hinge Maker Help</strong> </td> </tr> <tr> <td align = "center" nowrap = "nowrap" class = "h1-c" id = "Version"> <img src =  data:image/jpeg;base64,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 width = "500" > </td> </tr> <tr> <td align = "center" nowrap = "nowrap"> <hr> </td> </tr> <tr> <td width = "30%" align = "center" style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </body> </html>]]
    local dialog = HTML_Dialog(true, myHtml, 542, 621, "Hinge Help")
    dialog:ShowDialog()
    Hinge.InquiryHelpX = dialog.WindowWidth
    Hinge.InquiryHelpY = dialog.WindowHeight
    return  true
  end
-- =================================================== ]]
function DrawHingeHole(job, pt, ang)
  local phcp   = Polar2D(pt,   ang  + 180.0,  Hinge.HoleSetBack)
  local pt1    = Polar2D(phcp,   0.0,  Hinge.HoleRadius)
  local pt2    = Polar2D(phcp, 180.0,  Hinge.HoleRadius)
  local phsp   = Polar2D(phcp, ang + 180.0, Hinge.ScrewHoleSetBack)
  local phsp1  = Polar2D(phsp, ang + 90.0,  Hinge.ScrewCenter)
  local phsp2  = Polar2D(phsp, ang + 270.0,  Hinge.ScrewCenter)
  local line   = Contour(0.0) ;
  local layer  = job.LayerManager:GetLayerWithName(Hinge.HoleLayer)
  line:AppendPoint(pt1)
  line:ArcTo(pt2, 1)
  line:ArcTo(pt1, 1)
  layer:AddObject(CreateCadContour(line), true)
  pt1   = Polar2D(phsp1,   0.0,  Hinge.ScrewRadius)
  pt2   = Polar2D(phsp1, 180.0,  Hinge.ScrewRadius)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName(Hinge.ScrewHoleLayer)
  line:AppendPoint(pt1)
  line:ArcTo(pt2 , 1)
  line:ArcTo(pt1 , 1)
  layer:AddObject(CreateCadContour(line), true)
  pt1   = Polar2D(phsp2,   0.0,  Hinge.ScrewRadius)
  pt2   = Polar2D(phsp2, 180.0,  Hinge.ScrewRadius)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName(Hinge.ScrewHoleLayer)
  line:AppendPoint(pt1)
  line:ArcTo(pt2 , 1)
  line:ArcTo(pt1 , 1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ======================= End ========================= ]]