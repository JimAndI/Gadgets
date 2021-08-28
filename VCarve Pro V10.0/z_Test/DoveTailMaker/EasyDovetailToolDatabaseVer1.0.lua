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

 -- Easy Dovetail Maker is written by Jim Anderson of Houston Texas May 2020
]]
-- ===================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
local Dovetail = {}
local Tools = {}
Dovetail.RegName = "EasyDovetailToolDatabase1.0"
-- ===================================================]]
function GetToolData(xPath, xFile, xGroup)
    Dovetail.Brand      = GetIniValue(xPath, xFile, xGroup, "Brand", "S")
    Dovetail.PartNo     = GetIniValue(xPath, xFile, xGroup, "PartNo", "S")
    Dovetail.BitAngle   = GetIniValue(xPath, xFile, xGroup, "BitAngle", "N")
    Dovetail.ShankDia   = GetIniValue(xPath, xFile, xGroup, "ShankDia", "N")
    Dovetail.BitDia     = GetIniValue(xPath, xFile, xGroup, "BitDia", "N")
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
    -- ===========]]
    function all_trim(s) -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
    end -- function end
    -- ===========]]
    if nil == str then
        DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
    else
        if "" == all_trim(str) then
            DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
        else
            local j = (string.find(str, "=") + 1)
            if ty == "N" then ;
                return tonumber(string.sub(str, j))
            end -- if end
            if ty == "S" then
                return all_trim(string.sub(str, j))
            end -- if end
            if ty == "B" then
                if "TRUE" == all_trim(string.upper(string.sub(str, j))) then
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
    -- ===========]]
   function all_trim(s) -- Trims spaces off both ends of a string
     return s:match( "^%s*(.-)%s*$" )
   end -- function end
    -- ===========]]
   local filenameR = xPath .. "/" .. FileName
   local FL = LengthOfFile(filenameR)
   local file = io.open(filenameR, "r")
   local dat = "."
   local ItemNameLen = string.len(ItemName) ;
   local sad = "[" .. string.upper(GroupName) .. "]"
   while (FL >= 1) do
      dat = string.upper(all_trim(file:read())) ;
      if dat == sad then
         break
      else
         FL = FL - 1
      end -- if end
   end -- while end
   while (FL >= 1) do
      dat = all_trim(file:read()) ;
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
function All_Trim(s) -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function IniUpdateFile(xPath, xGroup, xFile, xItem, xValue)
   local NfileName = xPath .. "/" .. xFile .. ".ini"
   local OfileName = xPath .. "/" .. xFile .. ".bak"
   os.remove(OfileName)                 -- Deletes the old file
   os.rename(NfileName, OfileName)      -- Makes backup file
   local fileR = io.open(OfileName)
   local fileW = io.open(NfileName,  "w")
   local groups = false
   local txt = ""
   local cop = ""
   for Line in fileR:lines() do
      txt = Line
      cop = "[" .. string.upper(All_Trim(xGroup)) .. "]"
      if string.upper(All_Trim(Line)) == cop then
         groups = true
      end -- if end
      if xItem == string.sub(Line, 1, string.len(xItem))  then
         if groups then
            txt = xItem .. "=" .. xValue
            groups = false
         end -- if end
      end -- if end
      fileW:write(txt .. "\n") ;
   end -- for end
   os.remove(OfileName)
   fileR:close() ;
   fileW:close() ;
 end -- function end
-- ===================================================]]
function AddNewBit(xPath) -- Appends a New Bit to DovetailTool.ini
    local filename = xPath .. "/DovetailTool.ini"
    local file = io.open(filename, "a")
    file:write("[" .. All_Trim(Dovetail.Brand) .. " " .. All_Trim(Dovetail.PartNo) .. " " .. All_Trim(Dovetail.Type) .. " Dovetail " ..  tostring(Dovetail.BitAngle) .. " Deg x " .. tostring(Dovetail.BitDia) .. " D x " .. tostring(Dovetail.CutDepth) ..  " CH x " ..  tostring(Dovetail.ShankDia) .. " SHK] \n");
    file:write("Brand = "     .. Dovetail.Brand .. " \n");
    file:write("PartNo = "    .. Dovetail.PartNo .. " \n");
    file:write("BitAngle = "  .. Dovetail.BitAngle .. " \n");
    file:write("ShankDia = "  .. Dovetail.ShankDia .. " \n");
    file:write("BitDia = "    .. Dovetail.BitDia .. " \n");
    file:write("Flutes = "    .. Dovetail.Flutes .. " \n");
    file:write("Type = "      .. Dovetail.Type .. " \n");
    file:write("BitLength = " .. Dovetail.BitLength .. " \n");
    file:write("CutDepth = "  .. Dovetail.CutDepth .. " \n");
    file:write("RPM = "       .. Dovetail.RPM .. " \n");
    file:write("FeedRate = "  .. Dovetail.FeedRate .. " \n");
    file:write("PlungRate = " .. Dovetail.PlungRate .. " \n");
    file:write("Notes = "     .. Dovetail.Notes .. " \n");
    file:write("#====================================== \n");
    file:close()-- closes the open file
    return true
  end
-- ===================================================]]
function FileExists(name)
  -- DisplayMessageBox(name)
    local f=io.open(name,"r")
    if f~=nil then
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
        table.insert (Tools, string.upper(string.sub(dat, 2, (string.len(dat) - 1))))
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
      for Line in file:lines() do
        len = len + 1
      end
      file:close() ;
    end
   return len
 end
-- ===================================================]]
function UpdateBit(xGroup)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "Brand", Dovetail.Brand)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "PartNo", Dovetail.PartNo)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "BitAngle", Dovetail.BitAngle)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "ShankDia", Dovetail.ShankDia)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "BitDia", Dovetail.BitDia)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "Flutes", Dovetail.Flutes)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "Type", Dovetail.Type)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "BitLength", Dovetail.BitLength)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "CutDepth", Dovetail.CutDepth)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "RPM", Dovetail.RPM)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "FeedRate", Dovetail.FeedRate)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "PlungRate", Dovetail.PlungRate)
  IniUpdateFile(Dovetail.ToolPath, xGroup, "DovetailTool", "Notes", Dovetail.Notes)
end
-- ===================================================]]
function InquiryDropList(Header, Quest, XX, YY, DList)
  --[[
  Drop list foe user input
  local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
  Caller: local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, days)
  Dialog Header = "Cabinet Maker"
  User Question = "Select Cabinet Style"
  Selection Array = IniFile
  Returns = String
]]
  local myHtml = [[<html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type">
               <title>Cabinet Maker and Tool-path Creator</title> <style type="text/css">html{overflow:hidden} .helpbutton{background-color:#E1E1E1;border:1px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:#000}.helpbuttonx{background-color:##E1E1E1;border:1px solid #999;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;display:inline-block;font-size:12px;margin:40px 20px;cursor:pointer;color:#000;padding:2px 12px} .helpbutton:active{border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000} .helpbutton:hover{border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF} .LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px} .DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px} .ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif; font-size:12px;text-align:center;width:50px} .ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:14px;text-align:left;color:#0000FF} .FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap} .h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;white-space:nowrap} .h2-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left} .h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;white-space:nowrap} .h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right; white-space:nowrap;padding-right:4px;padding-left:4px} .h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right; white-space:nowrap;padding-right:8px;padding-left:8px} .alert{font-family:Arial,Helvetica,sans-serif;font-size:12px; font-weight:bold;color:#00F;text-align:center;white-space:nowrap} .h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;white-space:nowrap} .header1-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap} .header2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-align:center;white-space:nowrap} body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style> </head> <body bgcolor = "#EBEBEB" text = "#000000">

<table width = "248" border = "0" cellpadding = "0"> <tr>
<td colspan = "3" align = "left" valign = "middle" class = "h1"  id = "Questions"><strong class = "h2">Message Here</strong></td> </tr> <tr><th width = "20%" height = "15" align = "right" valign = "middle" id = "Questions2"> </th><th width = "60%" height = "15" align = "center" valign = "middle" id = "Contact2"><select name = "DList" size = "10" class = "h2" id = "ListBox"><option>Defalt</option> </select> </th><th width = "20%" height = "15" align = "left" valign = "middle" id = "Contact2"></th> </tr> <tr> <th height = "10" colspan = "3" align = "right" valign = "middle" id = "QuestionID"> </th> </tr> <tr><td colspan = "3" align = "center"  valign = "middle"><table border = "0" width = "100%"><tr align = "right"> <td align="center" valign="middle" style = "width: 40%"><span style = "width: 40%"><input id = "ButtonCancel" class = "FormButton"  name = "ButtonCancel" type = "button" value = "Cancel"></span></td> <td align="center" valign="middle" style = "width: 20%"></td> <td align="center" valign="middle" style = "width: 40%"><span style = "width: 40%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK">
</span></td>
</tr> </table></td> </tr> </table> </body> </html>]] ;
-- =========================================================================
local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ;
   dialog:AddLabelField("Questions", Quest) ;
   dialog:AddDropDownList("ListBox", "Make a Slection") ;
   dialog:AddDropDownListValue("ListBox", "Add New") ;
   for index, value in pairs(DList) do ;
      dialog:AddDropDownListValue("ListBox", value) ;
   end ;
   if not dialog:ShowDialog() then ;
    return "" ;
   else ;
    Dovetail.X = dialog.WindowWidth
    Dovetail.Y = dialog.WindowHeight
    return string.upper(dialog:GetDropDownListValue("ListBox")) ;
   end
end
-- ===================================================]]
function InquiryTool(Header)
  local myHtml = [[<html><head><title>Dovetail Toolpath Creator</title><style type="text/css">html{overflow:hidden} .helpbutton{background-color:#E1E1E1;border:1px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:#000}.helpbuttonx{background-color:##E1E1E1;border:1px solid #999;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;display:inline-block;font-size:12px;margin:40px 20px;cursor:pointer;color:#000;padding:2px 12px} .helpbutton:active{border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000} .helpbutton:hover{border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF} .LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px} .DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px} .ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif; font-size:12px;text-align:center;width:50px} .ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:14px;text-align:left;color:#0000FF} .FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap} .h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;white-space:nowrap} .h2-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left} .h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;white-space:nowrap} .h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right; white-space:nowrap;padding-right:4px;padding-left:4px} .h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right; white-space:nowrap;padding-right:8px;padding-left:8px} .alert{font-family:Arial,Helvetica,sans-serif;font-size:12px; font-weight:bold;color:#00F;text-align:center;white-space:nowrap} .h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;white-space:nowrap} .header1-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap} .header2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-align:center;white-space:nowrap} body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style></head><body> <table width="100%" border="0" summary="Dovetail bit Tool Data"> <tr> <td class="h1-rPx"><span class="h1-rP">Tool Brand</span></td> <td><span class="h1-l"> <input name="Dovetail.Brand" type="text" id="Dovetail.Brand"> </span></td> <td class="h1-rPx"><span class="h1-rP">Model Number</span></td> <td><span class="h1-l"> <input name="Dovetail.PartNo" type="text" id="Dovetail.PartNo"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Tool Type</span></td> <td><span class="h1-l"> <input name="Dovetail.Type" type="text" id="Dovetail.Type"> </span></td> <td class="h1-rPx"><span class="h1-rP">Bit Angle</span></td> <td><span class="h1-l"> <input name="Dovetail.BitAngle" type="text" id="Dovetail.BitAngle"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Base Dia</span></td> <td><span class="h1-l"> <input name="Dovetail.BitDia" type="text" id="Dovetail.BitDia"> </span></td> <td class="h1-rPx"><span class="h1-rP">Cut Depth</span></td> <td><span class="h1-l"> <input name="Dovetail.CutDepth" type="text" id="Dovetail.CutDepth"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Shank Dia</span></td> <td><span class="h1-l"> <input name="Dovetail.ShankDia" type="text" id="Dovetail.ShankDia"> </span></td> <td class="h1-rPx"><span class="h1-rP">Flute Count</span></td> <td><span class="h1-l"> <input name="Dovetail.Flutes" type="text" id="Dovetail.Flutes"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Overall Length </span></td> <td><span class="h1-l"> <input name="Dovetail.BitLength" type="text" id="Dovetail.BitLength"> </span></td> <td class="h1-rPx"><span class="h1-rP">RPM</span></td> <td><span class="h1-l"> <input name="Dovetail.RPM" type="text" id="Dovetail.RPM"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Plunge Rate</span></td> <td><span class="h1-l"> <input name="Dovetail.PlungRate" type="text" id="Dovetail.PlungRate"> </span></td> <td class="h1-rPx"><span class="h1-rP">Feed Rate</span></td> <td><span class="h1-l"> <input name="Dovetail.FeedRate" type="text" id="Dovetail.FeedRate"> </span></td> </tr> <tr> <td class="h1-rPx">Note</td> <td colspan="3"><span class="h1-l"> <input name="Dovetail.Notes" type="text" id="Dovetail.Notes" size="70"> </span></td> </tr> </table>
  <table width="570" border="0" id="ButtonTable"> <tr><td height="12" colspan="3" align="right" valign="middle" nowrap class="h2"><hr></td></tr><tr><td><strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_Dovetail_Maker-Page1" target="_blank" class="helpbutton">Help</a></strong></td><td class="FormButton"><span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td><td class="FormButton"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span></td></tr></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 620, 310,  Header)
  dialog:AddTextField("Dovetail.Brand",       Dovetail.Brand)
  dialog:AddTextField("Dovetail.PartNo",      Dovetail.PartNo)
  dialog:AddTextField("Dovetail.Type",        Dovetail.Type)
  dialog:AddTextField("Dovetail.Notes",       Dovetail.Notes)
  dialog:AddIntegerField("Dovetail.Flutes",   Dovetail.Flutes)
  dialog:AddIntegerField("Dovetail.RPM",      Dovetail.RPM)
  dialog:AddDoubleField("Dovetail.BitAngle",  Dovetail.BitAngle)
  dialog:AddDoubleField("Dovetail.ShankDia",  Dovetail.ShankDia)
  dialog:AddDoubleField("Dovetail.BitDia",   Dovetail.BitDia)
  dialog:AddDoubleField("Dovetail.BitLength", Dovetail.BitLength)
  dialog:AddDoubleField("Dovetail.CutDepth",  Dovetail.CutDepth)
  dialog:AddDoubleField("Dovetail.FeedRate",  Dovetail.FeedRate)
  dialog:AddDoubleField("Dovetail.PlungRate", Dovetail.PlungRate)

  if  dialog:ShowDialog() then
      Dovetail.Brand     = dialog:GetTextField("Dovetail.Brand")
      Dovetail.PartNo    = dialog:GetTextField("Dovetail.PartNo")
      Dovetail.Type      = dialog:GetTextField("Dovetail.Type")
      Dovetail.Notes     = dialog:GetTextField("Dovetail.Notes")
      Dovetail.RPM       = dialog:GetIntegerField("Dovetail.RPM")
      Dovetail.Flutes    = dialog:GetIntegerField("Dovetail.Flutes")
      Dovetail.BitAngle  = dialog:GetDoubleField("Dovetail.BitAngle")
      Dovetail.ShankDia  = dialog:GetDoubleField("Dovetail.ShankDia")
      Dovetail.BitDia    = dialog:GetDoubleField("Dovetail.BitDia")
      Dovetail.BitLength = dialog:GetDoubleField("Dovetail.BitLength")
      Dovetail.CutDepth  = dialog:GetDoubleField("Dovetail.CutDepth")
      Dovetail.FeedRate  = dialog:GetDoubleField("Dovetail.FeedRate")
      Dovetail.PlungRate = dialog:GetDoubleField("Dovetail.PlungRate")
      Dovetail.InquiryDovetailX = dialog.WindowWidth
      Dovetail.InquiryDovetailY = dialog.WindowHeight
      return true
    else
      return false
  end
end
-- ===================================================]]
function main(script_path)
  Dovetail.ToolPath = script_path
  --Dovetail.Drawing = InquiryDovetail("Easy Dovetail Maker")
  -- Read the Headers from the ini file
  HeaderReader(Dovetail.ToolPath)
  -- Display dialog and load list in drop down list
 local SelTool = InquiryDropList("Dovetail Bit Tool Database", "Selections", 593, 147, Tools)
 if not(SelTool == "") then
    if not(SelTool == "ADD NEW") then
      GetToolData( Dovetail.ToolPath, "DovetailTool.ini", SelTool)
      -- Dialog to Edit Tools Data
      if InquiryTool("Edit Dovetail Bit") then
        UpdateBit(SelTool)
      end
    else
      -- Dialog New Tools Data
      Dovetail.Brand     = ""
      Dovetail.PartNo    = ""
      Dovetail.Type      = ""
      Dovetail.Notes     = ""
      Dovetail.RPM       = 0
      Dovetail.Flutes    = 0
      Dovetail.BitAngle  = 0.0
      Dovetail.ShankDia  = 0.0
      Dovetail.BitDia    = 0.0
      Dovetail.BitLength = 0.0
      Dovetail.CutDepth  = 0.0
      Dovetail.FeedRate  = 0.0
      Dovetail.PlungRate = 0.0
      if InquiryTool("Enter New Dovetail Bit Data") then
        AddNewBit(Dovetail.ToolPath)
      end
    end
  end
  return true
end
--  ================ End ===============================