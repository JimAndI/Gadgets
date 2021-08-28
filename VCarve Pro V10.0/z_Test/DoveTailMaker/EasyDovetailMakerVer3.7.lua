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
-- require("mobdebug").start()
require "strict"
    local RegName = "EasyDovetailMaker3.7"
    local g_pt1 =  Point2D(0, 0)  ;    local g_pt2 =  g_pt1 ;    local g_pt3 =  g_pt1 ;    local  g_pt4 =  g_pt1
-- Table Names
    Milling = {} ; Dovetail = {} ; Application = {}
--  ===================================================
function Dovetail_Math()  -- All the math for Wall Cabinet
    Milling.ClearingWidth = Milling.DovetailToolDia - (2 *  Dovetail.SideThickness * math.tan(math.rad(Milling.DovetailToolAngle)))
    Milling.DovetailCenters = Milling.DovetailToolDia - (2 *  (Dovetail.SideThickness*0.5) * math.tan(math.rad(Milling.DovetailToolAngle)))
    Milling.ClearingLength = Dovetail.FrontThickness + (2.0 *  Milling.StrightToolDia)
    Milling.DovetailCount = math.floor(Dovetail.MaterialWidth / Milling.DovetailCenters)
    Milling.PathCount = 0.0
    --DisplayMessageBox("Count " .. tostring( Milling.DovetailCount ))
    if Milling.DovetailCount % 2 == 0 then
        Milling.DovetailCount = Milling.DovetailCount
        Milling.PinCount = math.floor(Milling.DovetailCount * 0.5) - 1
        Milling.TailCount = Milling.DovetailCount - Milling.PinCount
        Milling.PinStart = ((Dovetail.MaterialWidth - (Milling.DovetailCount * Milling.DovetailCenters)) * 0.5)
     else
        Milling.PinCount = math.floor(Milling.DovetailCount * 0.5)
        Milling.TailCount = Milling.DovetailCount  - Milling.PinCount
        Milling.PinStart = ((Dovetail.MaterialWidth - (Milling.DovetailCount * Milling.DovetailCenters)) * 0.5) + (Milling.DovetailCenters *0.5)
    end

--[[
     DisplayMessageBox("Count " .. tostring( Milling.DovetailCount ))
     DisplayMessageBox("Pin " .. tostring( Milling.PinCount ))
     DisplayMessageBox("Tail " .. tostring( Milling.TailCount ))
     DisplayMessageBox("Start " .. tostring( Milling.PinStart ))
      ]]
    g_pt1 =  Point2D(0, 0)
    g_pt2 = Polar2D(g_pt1,   90.0,   Dovetail.MaterialWidth)
    g_pt3 = Polar2D(g_pt2, 180.0,   Dovetail.SideThickness)
    g_pt4 = Polar2D(g_pt1, 180.0,   Dovetail.SideThickness)

    REG_UpdateRegistry()
    return true
end
--  ===================================================
function Mill_Math()  -- All the math for Wall Cabinet
    Milling.DovetailToolRadius = Milling.DovetailToolDia * 0.500
    Milling.StrightToolRadius = Milling.StrightToolDia * 0.500
    return true
end
--  ===================================================
function REG_LoadRegistry() -- Write to Registry values
    local RegistryWrite = Registry(RegName)
    local RegValue = RegistryWrite:SetString("Milling.LayerNameFrontBroad", "Tail Broad")
    RegValue = RegistryWrite:SetString("Milling.LayerNameSideBroad", "Pin Broad")
    RegValue = RegistryWrite:SetString("Milling.LayerNameDovetailPath", "Tail Dovetail Path")
    RegValue = RegistryWrite:SetString("Milling.LayerNameClearing", "Tail Dovetail Clearing")
    RegValue = RegistryWrite:SetString("Milling.LayerNameSidePocket", "Pin Pockets")
    RegValue = RegistryWrite:SetString("Milling.StrightToolDia", "0.3750")
    RegValue = RegistryWrite:SetString("Milling.StrightToolRadius", "0.1875")
    RegValue = RegistryWrite:SetString("Milling.DovetailToolDia", "0.7500")
    RegValue = RegistryWrite:SetString("Milling.DovetailToolRadius", "0.3750")
    RegValue = RegistryWrite:SetString("Milling.DovetailToolAngle", "14.0")
    RegValue = RegistryWrite:SetString("Milling.DovetailCount", "6")
    RegValue = RegistryWrite:SetString("Application.CodeBy", "James Anderson")
    RegValue = RegistryWrite:SetString("Application.ProgramName", "Easy Dovetail Maker")
    RegValue = RegistryWrite:SetString("Application.ProgramVersion", "3.7")
    RegValue = RegistryWrite:SetString("Application.ProgramYear", "2019")
    RegValue = RegistryWrite:SetString("Dovetail.MaterialWidth", "7.000")
    RegValue = RegistryWrite:SetString("Dovetail.SideThickness", "0.500")
    RegValue = RegistryWrite:SetString("Dovetail.FrontThickness", "0.500")
end
--  ===================================================
function REG_ReadRegistry()  -- Read from Registry values
    local RegistryRead = Registry(RegName)
    Milling.LayerNameFrontBroad = RegistryRead:GetString("Milling.LayerNameFrontBroad", "Tail Broad")
    Milling.LayerNameSideBroad = RegistryRead:GetString("Milling.LayerNameSideBroad", "Pin Broad")
    Milling.LayerNameSidePocket = RegistryRead:GetString("Milling.LayerNameSidePocket", "Pin Pockets")
    Milling.LayerNameDovetailPath = RegistryRead:GetString("Milling.LayerNameDovetailPath", "Tail Dovetail Path")
    Milling.LayerNameClearing = RegistryRead:GetString("Milling.LayerNameClearing", "Tail Dovetail Clearing")
    Milling.StrightToolDia = RegistryReadGetNumber("Milling.StrightToolDia", "0.3750")
    Milling.StrightToolRadius = RegistryReadGetNumber("Milling.StrightToolRadius", "0.1875")
    Milling.DovetailToolDia = RegistryReadGetNumber("Milling.DovetailToolDia", "0.7500")
    Milling.DovetailToolRadius = RegistryReadGetNumber("Milling.DovetailToolRadius", "0.37500")
    Milling.DovetailToolAngle = RegistryReadGetNumber("Milling.DovetailToolAngle", "14.0")
    Milling.DovetailCount = RegistryReadGetNumber("Milling.DovetailCount", "6")
    Application.CodeBy = RegistryRead:GetString("Application.CodeBy", "James Anderson")
    Application.ProgramName = RegistryRead:GetString("Application.ProgramName", "Easy Dovetail Maker")
    Application.ProgramVersion = RegistryRead:GetString("Application.ProgramVersion", "3.7")
    Application.ProgramYear = RegistryRead:GetString("Application.ProgramYear", "2019")
    Dovetail.MaterialWidth = RegistryReadGetNumber("Dovetail.MaterialWidth", "7.0")
    Dovetail.SideThickness = RegistryReadGetNumber("Dovetail.SideThickness", "0.500")
    Dovetail.FrontThickness = RegistryReadGetNumber("Dovetail.FrontThickness", "0.500")
end
--  ===================================================
function REG_UpdateRegistry() -- Write to Registry values
    local RegistryWrite = Registry(RegName)
    local RegValue = RegistryWrite:SetString("Milling.LayerNameFrontBroad", Milling.LayerNameFrontBroad)
    RegValue = RegistryWrite:SetString("Milling.LayerNameSideBroad", Milling.LayerNameSideBroad)
    RegValue = RegistryWrite:SetString("Milling.LayerNameDovetailPath", Milling.LayerNameDovetailPath)
    RegValue = RegistryWrite:SetString("Milling.LayerNameClearing", Milling.LayerNameClearing)
    RegValue = RegistryWrite:SetString("Milling.LayerNameSidePocket", Milling.LayerNameSidePocket)
    RegValue = RegistryWrite:SetString("Milling.StrightToolDia", tostring(Milling.StrightToolDia))
    RegValue = RegistryWrite:SetString("Milling.StrightToolRadius", tostring(Milling.StrightToolRadius))
    RegValue = RegistryWrite:SetString("Milling.DovetailToolDia", tostring(Milling.DovetailToolDia))
    RegValue = RegistryWrite:SetString("Milling.DovetailToolRadius", tostring(Milling.DovetailToolRadius))
    RegValue = RegistryWrite:SetString("Milling.DovetailToolAngle", tostring(Milling.DovetailToolAngle))
    RegValue = RegistryWrite:SetString("Milling.DovetailCount", tostring(Milling.DovetailCount))
    RegValue = RegistryWrite:SetString("Dovetail.MaterialWidth",tostring(Dovetail.MaterialWidth))
    RegValue = RegistryWrite:SetString("Dovetail.SideThickness", tostring(Dovetail.SideThickness))
    RegValue = RegistryWrite:SetString("Dovetail.FrontThickness", tostring(Dovetail.FrontThickness))
end
--  ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end-- function end
--  ===================================================
function RegistryReadGetNumber(str1, str2) -- convert string to the correct data type
     local RegistryReadc = Registry(RegName)
    return tonumber(RegistryReadc:GetString(str1,  str2))
end
--  ===================================================
function InquiryDovetail(Header)
    local myHtml = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html ; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow:hidden } body { 	background-color: #EBEBEB; } body, td, th { 	font-family: Arial, Helvetica, sans-serif; 	font-size: 12px; 	color: #000; } .FormButton { 	font-weight: bold; 	width: 60%; 	font-family: Arial, Helvetica, sans-serif; 	font-size: 12px; } .FormButton2 { 	font-weight: bold; 	width: 40%; 	font-family: Arial, Helvetica, sans-serif; 	font-size: 12px; } body { 	background-color: #EBEBEB; } .h2 { 	font-size: 12px; 	font-weight: bold; 	text-wrap:none; } .h21 { 	font-size: 12px; 	font-weight: bold; 	text-align:right; 	text-wrap:none; 	vertical-align:middle; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "445" border = "0" cellpadding = "0">   <tr>     <td colspan="5" align="center" bgcolor="#EBEBEB"><span style="width: 33%">       <input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Layer Names" style = "width: 50%">       </span></td>   </tr>   <tr>     <td width="29%" align="right" nowrap bgcolor="#EBEBEB"><span style="width: 25%"><span class="h2" style="width: 25%">Side Thickness</span></span></td>     <td width="18%" align="left" bgcolor="#EBEBEB"><span class="h2"><span style="width: 25%">       <input name="Dovetail.SideThickness" type="text" class="h2" id="Dovetail.SideThickness" size="10" maxlength="10" />       </span> </span></td>     <td width="30%" align="right" nowrap bgcolor="#EBEBEB" ><span class="h2"> <span class="h21" style="width: 25%">Material Width</span> </span></td>     <td width="21%" align="right" nowrap bgcolor="#EBEBEB" ><span class="h21"><span class="h2">       <input name="Dovetail.MaterialWidth" type="text" class="h2" id="Dovetail.MaterialWidth" size="10" maxlength="10" />       </span></span></td>     <td width="2%" align="left" bgcolor="#EBEBEB" >&nbsp;</td>   </tr>   <tr>     <td align="right" nowrap bgcolor="#EBEBEB" ><span class="h2" style="width: 25%">Front Thickness</span></td>     <td align="left" bgcolor="#EBEBEB" ><span class="h2">       <input name="Dovetail.FrontThickness" type="text" class="h2" id="Dovetail.FrontThickness" size="10" maxlength="10" />       </span></td>     <td align="right" nowrap bgcolor="#EBEBEB" class="h21" >Dovetail Tool Angle: </td>     <td align="right" nowrap bgcolor="#EBEBEB" class="h21" ><input name="Milling.DovetailToolAngle" type="text" class="h2" id="Milling.DovetailToolAngle" size="10" maxlength="10" /></td>   </tr>   <tr>     <td align="right" nowrap bgcolor="#EBEBEB" ><span class="h21">Tail Tool Diameter: </span></td>     <td align="left" bgcolor="#EBEBEB" ><span class="h2">       <input name="Milling.StrightToolDia" type="text" class="h2" id="Milling.StrightToolDia" size="10" maxlength="10" />       </span></td>     <td align="right" nowrap bgcolor="#EBEBEB" class="h21" >Dovetail Tool Diameter: </td>     <td align="right" nowrap bgcolor="#EBEBEB" class="h21" ><span class="h2">       <input name="DovetailToolDia" type="text" class="h2" id="Milling.DovetailToolDia" size="10" maxlength="10" />       </span></td>   </tr>   <tr>     <th height="15" colspan="6" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"> <hr>     </th>   </tr>   <tr>     <td colspan="6" align = "center" valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%">         <tr align = "right">           <td width="46%" align="center" style = "width: 20%"><span style="width: 25%">             <input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About" style = "width: 40%">             </span></td>           <td width="22%" align="center" style = "width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel">             </span></td>           <td width="32%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td>         </tr>       </table></td>   </tr> </table> </body> ]]
    local dialog = HTML_Dialog(true, myHtml, 475, 250,  Header) ;
    dialog:AddDoubleField("Milling.StrightToolDia",  Milling.StrightToolDia)
    dialog:AddDoubleField("Milling.DovetailToolAngle",  Milling.DovetailToolAngle)
    dialog:AddDoubleField("Milling.DovetailToolDia",  Milling.DovetailToolDia)
    dialog:AddDoubleField("Dovetail.MaterialWidth", Dovetail.MaterialWidth) ;
    dialog:AddDoubleField("Dovetail.SideThickness", Dovetail.SideThickness) ;
    dialog:AddDoubleField("Dovetail.FrontThickness", Dovetail.FrontThickness) ;
    --dialog:AddDoubleField("Milling.DovetailCount", Milling.DovetailCount) ;
    if  dialog:ShowDialog() then ;
        Dovetail.MaterialWidth=tonumber(dialog:GetDoubleField("Dovetail.MaterialWidth")) ;
        Dovetail.SideThickness=tonumber(dialog:GetDoubleField("Dovetail.SideThickness")) ;
        Dovetail.FrontThickness=tonumber(dialog:GetDoubleField("Dovetail.FrontThickness")) ;
        Milling.StrightToolDia = tonumber(dialog:GetDoubleField("Milling.StrightToolDia"))
        Milling.DovetailToolAngle = tonumber(dialog:GetDoubleField("Milling.DovetailToolAngle"))
        Milling.DovetailToolDia = tonumber(dialog:GetDoubleField("Milling.DovetailToolDia"))
        Mill_Math()
        REG_UpdateRegistry()
    end
 end
--  ===================================================
function OnLuaButton_InquiryLayers()

    local myHtml = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html ; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Layer Names</title> <style type = "text/css"> html { overflow:hidden } body, td, th { 	font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; background-color: #EBEBEB ; } .FormButton { font-weight: bold ; width: 60% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } .h2 { font-size: 12px ; font-weight: bold ; text-align:right ; text-wrap:none ; vertical-align:middle ; } .h21 { font-size: 12px ; font-weight: bold ; text-align:left ; text-wrap:none ; vertical-align:middle ; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width="550" border="0" align="left" cellpadding="0"> <tr> <td align="right" valign="middle" nowrap class="h2">Front Broad: <input name="Milling.LayerNameFrontBroad" type="text" class="h21" id="Milling.LayerNameFrontBroad" size="50" maxlength="50" /> </td> </tr> <tr> <td align="right" valign="middle" nowrap class="h2">Front - Dovetail Clearing: <input name="Milling.LayerNameClearing" type="text" class="h21" id="Milling.LayerNameClearing" size="50" maxlength="50" /></td> </tr> <tr> <td align="right" valign="middle" nowrap class="h2">Front - Dovetail Path:      <input name="Milling.LayerNameDovetailPath" type="text" class="h21" id="Milling.LayerNameDovetailPath" size="50" maxlength="50" /></td>  </tr>  <tr> <td align="right" valign="middle" nowrap class="h2">Side Broad: <input name="Milling.LayerNameSideBroad" type="text" class="h21" id="Milling.LayerNameSideBroad" size="50" maxlength="50" /> </td> </tr> <tr> <td align="right" valign="middle" nowrap class="h2">Side -  Pockets:  <input name="Milling.LayerNameSidePocket" type="text" class="h21" id="Milling.LayerNameSidePocket" size="50" maxlength="50" /> </td> </tr> <tr> <td align="right" valign="middle" nowrap class="h2"> <hr> </td> </tr> <tr> <td align="center" valign="middle" nowrap> <table width="450" border="0" cellpadding="0"> <tr> <td height="20" align="center" valign="middle" style="width: 30%"><input id="ButtonCancel"  class="FormButton" name="ButtonCancel" type="button" value="Cancel"> </th> <td height="20" style="width: 30%" align="center" valign="middle"> <input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"> </th> </tr> </table></td> </tr> </table> </body> </html>]]
    local dialogL = HTML_Dialog(true, myHtml, 590, 250, "Layer Setup") ;
    dialogL:AddTextField("Milling.LayerNameClearing", Milling.LayerNameClearing)
    dialogL:AddTextField("Milling.LayerNameSideBroad", Milling.LayerNameSideBroad)
    dialogL:AddTextField("Milling.LayerNameSidePocket", Milling.LayerNameSidePocket)
    dialogL:AddTextField("Milling.LayerNameDovetailPath", Milling.LayerNameDovetailPath)
    dialogL:AddTextField("Milling.LayerNameFrontBroad", Milling.LayerNameFrontBroad)
    if  dialogL:ShowDialog() then ;
        Milling.LayerNameClearing= dialogL:GetTextField("Milling.LayerNameClearing")
        Milling.LayerNameSidePocket= dialogL:GetTextField("Milling.LayerNameSidePocket")
        Milling.LayerNameSideBroad= dialogL:GetTextField("Milling.LayerNameSideBroad")
        Milling.LayerNameDovetailPath= dialogL:GetTextField("Milling.LayerNameDovetailPath")
        Milling.LayerNameFrontBroad= dialogL:GetTextField("Milling.LayerNameFrontBroad")
        REG_UpdateRegistry()
      end
    return  true
end
--  ===================================================
function OnLuaButton_InquiryAbout()
--[[
    Drop list for user to input project info
    Caller = local y = InquiryDropList("Easy Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
    Dialog Header = "Easy Cabinet Maker"
    User Question = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = True
]]
    local myHtml = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html ; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Layer Names</title> <style type = "text/css"> html { overflow:hidden } body, td, th { 	font-family: Arial, Helvetica, sans-serif ; 	font-size: 12px ; 	color: #000 ; background-color: #EBEBEB ; } .FormButton { font-weight: bold ; width: 40% ; 	font-family: Arial, Helvetica, sans-serif ; 	font-size: 12px ; } .h1 { font-size: 16px ; font-weight: bold ; text-align:center ; 	text-wrap:none ; 	vertical-align:middle ; } .h2 { font-size: 10px ; text-align:center ; 	text-wrap:none ; vertical-align:middle ; } .h3 { font-size: 12px ; font-weight: bold ; 	text-align:center ; text-wrap:none ; vertical-align:middle ; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width="213" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="h1">Easy  Dovetail Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" class="h2"> Version 3.7.1</td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="h3">James Anderson</td> </tr> <tr> <td align="center" nowrap="nowrap"><a href="James.L.Anderson@outlook.com">James.L.Anderson@outlook.com</a></td>   </tr> <tr> <td align="center" nowrap="nowrap"><a href="http://www.jimandi.com">www.JimAndi.com</a> </td> </tr> <tr> <td align="center" nowrap="nowrap"> <span class="h3">(281) 728-3028  </span> </td> </tr>  <tr> <td align="center" nowrap="nowrap"> <span class="h3">Houston, TX.</span></td> </tr> <tr> <td align="center" nowrap="nowrap"> <hr> </td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </body> </html>]] ;
    local dialogA = HTML_Dialog(true, myHtml, 250, 255, "About") ;
    dialogA:ShowDialog()
    return  true
end
--  =*********************************************=
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ;
    end
   REG_ReadRegistry()
    Dovetail_Math()
    Mill_Math()
    local Drawing = InquiryDovetail("Easy Dovetail Maker")
    Dovetail_Math()
    Mill_Math()
    REG_ReadRegistry()
    MakeLayers()
    Dovetail_Front()
    Dovetail_Side()
    Dovetail_Path()
    job:Refresh2DView()
    return true
end
--  =*********************************************=
function Dovetail_Path()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameDovetailPath)
    local line = Contour(0.0)
    local LoopOver = false
    local pt01 = Polar2D(g_pt1,   0.0,    Milling.DovetailToolRadius + 0.125 )
     local pt02 = Polar2D(pt01,   0.0,     0.125)
    line:AppendPoint(pt01) ;
    line:LineTo(pt01)
    local ptx = Polar2D(pt01,  90.0,   Milling.DovetailCenters  + Milling.PinStart)
    line:LineTo(ptx)
    ptx = Polar2D(ptx, 180.0, (Milling.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
   line:LineTo(ptx)
   ptx = Polar2D(ptx, 90.0, Milling.DovetailCenters * 2.0 )
    for i = Milling.PathCount-1 , 1 , -1   do
        line:LineTo(ptx)
        if LoopOver == false then
              ptx = Polar2D(ptx, 0.0, (Milling.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
              LoopOver = true
        else
              ptx = Polar2D(ptx,    180.0, (Milling.DovetailToolDia  + 0.25 + Dovetail.SideThickness))
              LoopOver = false
        end
        line:LineTo(ptx)
       ptx = Polar2D(ptx, 90.000, Milling.DovetailCenters * 2.0 )
    end
        if LoopOver then
                ptx = Polar2D(Polar2D(ptx, 270.000, Milling.DovetailCenters * 2.0 ), 0.000, 0.125)
                line:LineTo(ptx)
        else
                ptx = Polar2D(Polar2D(g_pt3,    180.0, Milling.DovetailToolRadius  + 0.125),  90.0, (Milling.DovetailToolRadius  + 0.125))
                line:LineTo(ptx)
                ptx = Polar2D(Polar2D(g_pt2,    0.0, Milling.DovetailToolRadius  + 0.25),  90.0, (Milling.DovetailToolRadius  + 0.125))
                line:LineTo(ptx)
        end
        line:LineTo( pt02)
        layer:AddObject(CreateCadContour(line), true)
        job:Refresh2DView()
  return true
end
--  ===================================================
function Dovetail_Side()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameSideBroad)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) ; line:LineTo(g_pt2) ; line:LineTo(g_pt3) ; line:LineTo(g_pt4) ; line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    local ptx = Polar2D(g_pt1,  90.0,    Milling.PinStart + Milling.DovetailCenters + Milling.DovetailCenters)
   for i = Milling.PathCount - 1, 1 , -1     do
        DovetailPockets(ptx)
        ptx = Polar2D(ptx,  90.0, Milling.DovetailCenters + Milling.DovetailCenters)
    end
    DovetailPocketsEnds()
    job:Refresh2DView()
  return true
end
--  ===================================================
function Dovetail_Front()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameFrontBroad)
    local line = Contour(0.0);    line:AppendPoint(g_pt1) ; line:LineTo(g_pt2) ; line:LineTo(g_pt3) ; line:LineTo(g_pt4) ; line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    local ptx = Polar2D(g_pt1,  90.0,   Milling.PinStart + Milling.DovetailCenters )
    local tx = Dovetail.MaterialWidth
    while (tx > Milling.DovetailCenters + Milling.DovetailCenters) do
  --  for i = Milling.PinCount , 1 , -1 ;  do
        Dovetails(ptx)
        ptx = Polar2D(ptx,  90.0, Milling.DovetailCenters + Milling.DovetailCenters )
        tx = tx - (Milling.DovetailCenters + Milling.DovetailCenters)
    end
    job:Refresh2DView()
    return true
end
--  ===================================================
function MakeLayers()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameFrontBroad)
    layer = job.LayerManager:GetLayerWithName(Milling.LayerNameDovetailPath)
    layer = job.LayerManager:GetLayerWithName(Milling.LayerNameClearing)
    layer = job.LayerManager:GetLayerWithName(Milling.LayerNameSideBroad)
    layer = job.LayerManager:GetLayerWithName(Milling.LayerNameSidePocket)
  return true
end
--  ===================================================
function DovetailPockets(pt1)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameSidePocket)
    local line = Contour(0.0)
    local pt2 = Polar2D(pt1, 180,       Dovetail.FrontThickness)
    local pt01 = Polar2D(pt1,   90.0,    (Milling.ClearingWidth * 0.5))
    local pt04 = Polar2D(pt1, 270.0,   (Milling.ClearingWidth * 0.5))
    local pt02 = Polar2D(pt2,   90.0,   Milling.DovetailToolRadius)
    local pt03 = Polar2D(pt2, 270.0,   Milling.DovetailToolRadius)
    local pt01 = Polar2D(pt01,   (360.0 - Milling.DovetailToolAngle),   Milling.StrightToolDia)
    local pt04 = Polar2D(pt04,   Milling.DovetailToolAngle,   Milling.StrightToolDia)
    local pt02 = Polar2D(pt02,   (180.0 - Milling.DovetailToolAngle),   Milling.StrightToolDia)
    local pt03 = Polar2D(pt03,   (180.0 + Milling.DovetailToolAngle),   Milling.StrightToolDia)
    line:AppendPoint(pt01) ; line:LineTo(pt02) ; line:LineTo(pt03) ; line:LineTo(pt04) ; line:LineTo(pt01)
    layer:AddObject(CreateCadContour(line), true)
  return true
end
--  ===================================================
function Dovetails(pt1)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    Milling.PathCount = Milling.PathCount + 1
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameClearing)
    local line = Contour(0.0)
    local pt2 = Polar2D(pt1,      180.0,    Dovetail.SideThickness)
    local pt01 = Polar2D(Polar2D(pt1,      90.0,    (Milling.ClearingWidth * 0.5)),      0.0,    Milling.StrightToolDia)
    local pt04 = Polar2D(Polar2D(pt1,    270.0,    (Milling.ClearingWidth * 0.5)),      0.0,  Milling.StrightToolDia)
    local pt02 = Polar2D(Polar2D(pt2,      90.0,    (Milling.ClearingWidth * 0.5)),  180.0,    Milling.StrightToolDia)
    local pt03 = Polar2D(Polar2D(pt2,    270.0,    (Milling.ClearingWidth * 0.5)), 180.0,  Milling.StrightToolDia)
    line:AppendPoint(pt01) ; line:LineTo(pt02) ; line:LineTo(pt03) ; line:LineTo(pt04) ; line:LineTo(pt01)
    layer:AddObject(CreateCadContour(line), true)
  return true
end
--  ===================================================
function DovetailPocketsEnds()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ;
    end
    local layer = job.LayerManager:GetLayerWithName(Milling.LayerNameSidePocket)
    local line = Contour(0.0)
    local pt2 = Polar2D(g_pt1, 180.0, Dovetail.FrontThickness)
    local pt01 = Polar2D(Polar2D(g_pt1,   90.0,    (Milling.ClearingWidth * 0.5) + Milling.PinStart),   (360.0 - Milling.DovetailToolAngle),   Milling.StrightToolDia)
    local pt02 = Polar2D(Polar2D(pt2,       90.0,   Milling.DovetailToolRadius + Milling.PinStart ),   (180.0 - Milling.DovetailToolAngle),   Milling.StrightToolDia)
    local pt03 = Polar2D(pt02,  270.0,   Milling.StrightToolDia + (Milling.DovetailToolDia * 0.5) + Milling.PinStart)
    local pt04 = Point2D(pt01.X , pt03.Y)
    line:AppendPoint(pt01) ; line:LineTo(pt02) ; line:LineTo(pt03) ; line:LineTo(pt04) ; line:LineTo(pt01)
    layer:AddObject(CreateCadContour(line), true)
    layer = job.LayerManager:GetLayerWithName(Milling.LayerNameSidePocket)
    line = Contour(0.0)
    pt2 = Polar2D(g_pt2, 180.0, Dovetail.FrontThickness)
    pt01 = Polar2D(Polar2D(g_pt2,   270.0,    (Milling.ClearingWidth * 0.5) + Milling.PinStart),   Milling.DovetailToolAngle,   Milling.StrightToolDia)
    pt02 = Polar2D(Polar2D(pt2,        270.0,   Milling.DovetailToolRadius + Milling.PinStart),   (180.0 + Milling.DovetailToolAngle),   Milling.StrightToolDia)
    pt03 = Polar2D(pt02,  90.0,   Milling.StrightToolDia + (Milling.DovetailToolDia * 0.5) + Milling.PinStart )
    pt04 = Point2D(pt01.X , pt03.Y)
    line:AppendPoint(pt01) ; line:LineTo(pt02) ; line:LineTo(pt03) ; line:LineTo(pt04) ; line:LineTo(pt01)
    layer:AddObject(CreateCadContour(line), true)
  return true
end
--  ================ End ===============================