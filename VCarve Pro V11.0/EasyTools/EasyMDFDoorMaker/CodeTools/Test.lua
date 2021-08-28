-- VECTRIC LUA SCRIPT
-- ==================================================]]
-- Global Variables --
require("mobdebug").start()
-- require "strict"
local Test         = {}
local DialogWindow = {}
local ClientList   = {}
local Client       = {}
      Test.Version = 1.0
local test
local dialog
DialogWindow.ClientHelp = "https://forum.vectric.com/search.php?search_id=unreadposts"
--  ===================================================]]
function INI_UpdateItem(xPath, xFile, xGroup,  xItem, xValue)
  -- Deletes old ini (.bak) file
  -- Copys the .ini to a backup (.bak) new file
  -- Reads the new backup file and writes a new file to the xGroup
  -- Writes new xValue for the for the xItem
  -- Reads and writes a new file to end of file
  local NfileName = xPath .. "/" .. xFile .. ".ini"
  local OfileName = xPath .. "/" .. xFile .. ".bak"
  os.remove(OfileName)
  os.rename(NfileName, OfileName) -- makes backup file
  local fileR = io.open(OfileName)
  local fileW = io.open(NfileName,  "w")
  local groups = false
  local txt = ""
  for Line in fileR:lines() do
    txt = Line
    if All_Trim(Line) == "[" .. All_Trim(xGroup) .. "]" then
      groups = true
    end -- if end
    if xItem == string.sub(Line, 1, string.len(xItem))  then
      if groups then
        txt = xItem .. " = " .. xValue
        groups = false
      end -- if end
    end -- if end
    fileW:write(txt .. "\n")
    txt = ""
  end -- for end
  os.remove(OfileName)
  fileR:close() ;
  fileW:close() ;
  return true
end -- function end
-- ====================================================]]
function INI_ValidateItem(xFile, xGroup, xItem)
  -- Reads INI file and returns true if group is found
  local fileR = io.open(xFile)
  local group = false
  local item = false
  for Line in fileR:lines() do
    if string.upper(All_Trim(Line)) == "[" .. string.upper(All_Trim(xGroup)) .. "]" then
    group = true
    end -- if end
    if group then
      if xItem == string.sub(Line, 1, string.len(xItem))  then  -- Item
        item = true
      end -- if end
    end -- if end
  end -- for end
   fileR:close()
   return group
end -- function end
-- ====================================================]]
function Polar2D(pt, ang, dis)
  -- returns new point based on provided Point, Angle, and Distance
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ====================================================]]
function StartDate(LongShort)
--[[ Date Value Codes
--  |   %a  abbreviated weekday name (e.g., Wed)
--  |    %A  full weekday name (e.g., Wednesday)
--  |    %b  abbreviated month name (e.g., Sep)
--  |    %B  full month name (e.g., September)
--  |    %c  date and time (e.g., 09/16/98 23:48:10)
--  |    %d  day of the month (16) [01-31]
--  |    %H  hour, using a 24-hour clock (23) [00-23]
--  |    %I  hour, using a 12-hour clock (11) [01-12]
--  |    %M  minute (48) [00-59]
--  |    %m  month (09) [01-12]
--  |    %p  either "am" or "pm" (pm)
--  |    %S  second (10) [00-61]
--  |    %w  weekday (3) [0-6 = Sunday-Saturday]
--  |    %x  date (e.g., 09/16/98)
--  |    %X  time (e.g., 23:48:10)
--  |    %Y  full year (e.g., 1998)
--  |    %y  two-digit year (98) [00-99]
--  |    %%  the character `%´ ]]
    if LongShort then
      return os.date("%b %d, %Y")
    else
      return os.date("%Y%m%d")
    end
end
-- ====================================================]]
function All_Trim(s)
  -- Trims spaces off both ends of a string
 return s:match( "^%s*(.-)%s*$" )
end -- function end
-- ====================================================]]
function INI_AddNewProject(xPath, xGroup)
  -- Appends a New Project to CabinetProjectQuestion.ini
  -- ==AddNewProject(xPath)==
  -- Appends a New Project to CabinetProjectQuestion.ini
    local filename = xPath .. "/ProjectList.ini"
    local file = io.open(filename, "a")
    file:write("[" .. All_Trim(xGroup) .. "] \n") ;
    file:write("load_date = " .. StartDate(true) .. " \n") ;
    file:write("# =========================== \n") ;
    file:close()-- closes the open file
    return true
  end -- function end
-- ====================================================]]
function INI_AddNewClient(xPath, xGroup)
  -- Appends a New Project to CabinetProjectQuestion.ini
  -- ==AddNewProject(xPath)==
  -- Appends a New Project to CabinetProjectQuestion.ini
    local filename = xPath .. "/ProjectList.ini"
    local file = io.open(xPath, "a")
    file:write("[" .. All_Trim(xGroup) .. "] \n") ;
    file:write("load_date = " .. StartDate(true) .. " \n") ;
    file:write("client.contact = " .. All_Trim(Client.Address) .. " \n")
    file:write("client.address = " .. All_Trim(Client.Address) .. " \n")
    file:write("client.city = City Name
    file:write("client.state = Name
    file:write("client.zip = 45456
    file:write("client.phone = (123)456-7890
    file:write("client.email = John.Doe@gmail.com
    file:write("# =========================== \n") ;
    file:close()-- closes the open file
    return true
  end -- function end
-- ====================================================]]
function INI_DeleteGroup(xPath, xFile, xGroup)
  -- Deletes old ini (.bak) file
  -- Copys the .ini to a backup (.bak) new file
  -- Reads the new backup file and writes a new file to the xGroup value
  -- Stops Writing lines until next Group is found
  -- Writes to end of file
  local NfileName = xPath .. "/" .. xFile .. ".ini"
  local OfileName = xPath .. "/" .. xFile .. ".bak"
  os.remove(OfileName)
  os.rename(NfileName, OfileName) -- makes backup copy file
  local fileR = io.open(OfileName)
  local fileW = io.open(NfileName,  "w")
  local groups = false
  local writit = true
  local txt = ""
  for Line in fileR:lines() do
    txt = Line
    if All_Trim(Line) == "[" .. All_Trim(xGroup) .. "]" then
      groups = true
      txt = ""
    end -- if end
    if groups then
      writit = false
      if "[" == string.sub(All_Trim(txt), 1, 1) then
        groups = false
        writit = true
      else
        writit = false
      end -- if end
    end -- if end
    if writit then
      fileW:write(txt .. "\n")
      txt = ""
    end -- if end
  end -- for end
   os.remove(OfileName)
   fileR:close()
   fileW:close()
   return true
 end -- function end
-- ====================================================]]
function INI_ValidateGroup(xFile, xGroup)
  -- Reads INI file and returns true if group is found
  local fileR = io.open(xFile)
  local group = false
  for Line in fileR:lines() do
    if string.upper(All_Trim(Line)) == "[" .. string.upper(All_Trim(xGroup)) .. "]" then
      group = true
    end -- if end
  end -- for end
   fileR:close()
   return group
 end -- function end
-- ====================================================]]
function test(Header, xPath, xFile, xGroup)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
  local myHtml = [[<html><head> <title>Test</title> <style type="text/css"> html {overflow: hidden;} .LuaButton {	font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;font-size: 12px;} .FormButton { font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;} .h1-l {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:left;} .h1-r {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:right;} .h1-c { font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:center;}    body {	background-color: #CCC;	overflow:hidden;} </style></head><body><table border="0" width="296" cellpadding="0"><tbody>
  <tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here</td>
    <th class="h1-l" align="left" valign="middle" width="120"><input id="qInput" name="qInput" size="100" type="text" /></td> </tr>
  <tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID2">Message Here2</td>
    <th class="h1-l" align="left" valign="middle" width="120"><input id="qInput2" name="qInput2" size="100" type="text" /></td>  </tr>
  <tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID3">Message Here3</td>
    <th class="h1-l" align="left" valign="middle" width="120"><input id="qInput3" name="qInput3" size="100" type="text" /></td>  </tr>
  <tr><td colspan="2" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td style="width: 20%;">&nbsp;</td><td style="width: 20%;">&nbsp;</td><td style="width: 25%;">&nbsp;</td><td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 730, 200, Header .. " " .. Test.Version) ;
  dialog:AddLabelField("QuestionID", "Path") ;
  dialog:AddLabelField("QuestionID2", "File") ;
  dialog:AddLabelField("QuestionID3", "Group") ;
  dialog:AddTextField("qInput", xPath) ;
  dialog:AddTextField("qInput2", xFile) ;
  dialog:AddTextField("qInput3", xGroup) ;
  if not dialog:ShowDialog() then
    Test.path = dialog:GetTextField("qInput")
    Test.file = dialog:GetTextField("qInput2")
    Test.group = dialog:GetTextField("qInput3")
    return false
  else
    Test.path = dialog:GetTextField("qInput")
    Test.file = dialog:GetTextField("qInput2")
    Test.group = dialog:GetTextField("qInput3")
    return true
  end
end
-- ====================================================]]
function OnLuaButton_SelectClient()
  Client.Name = dialog:GetDropDownListValue("Client.List")
  INI_ReadClientInfo(Client.Path, Client.Name)
  dialog:UpdateTextField("Client.Name", Client.Name)
  dialog:UpdateTextField("Client.Contact", Client.Contact)
  dialog:UpdateTextField("Client.Email", Client.Email)
  dialog:UpdateTextField("Client.Address", Client.Address)
  dialog:UpdateTextField("Client.State", Client.State)
  dialog:UpdateTextField("Client.City", Client.City)
  dialog:UpdateTextField("Client.Zip", Client.Zip)
  dialog:UpdateTextField("Client.Phone", Client.Phone)
  return  true
end
-- ====================================================]]
function OnLuaButton_ClientUpdate()
  Client.Name    = dialog:GetTextFeild("Client.Name")
  Client.Contact = dialog:GetTextFeild("Client.Contact")
  Client.Email   = dialog:GetTextFeild("Client.Email")
  Client.Address = dialog:GetTextFeild("Client.Address")
  Client.State   = dialog:GetTextFeild("Client.State")
  Client.City    = dialog:GetTextFeild("Client.City")
  Client.Zip     = dialog:GetTextFeild("Client.Zip")
  Client.Phone   = dialog:GetTextFeild("Client.Phone")
  INI_UpdateClientInfo(Client.Name)
  return  true
end
-- ====================================================]]
function OnLuaButton_NewClient()
  Client.Name =  "New Client"
  Client.Contact = ""
  Client.Email = ""
  Client.Address = ""
  Client.State = ""
  Client.City = ""
  Client.Zip = ""
  Client.Phone = ""
  dialog:UpdateTextField("Client.Name", Client.Name)
  dialog:UpdateTextField("Client.Contact", Client.Contact)
  dialog:UpdateTextField("Client.Email", Client.Email)
  dialog:UpdateTextField("Client.Address", Client.Address)
  dialog:UpdateTextField("Client.State", Client.State)
  dialog:UpdateTextField("Client.City", Client.City)
  dialog:UpdateTextField("Client.Zip", Client.Zip)
  dialog:UpdateTextField("Client.Phone", Client.Phone)
  return  true
end
-- =====================================================]]
function INI_GetValue(xFile, xGroup, xItem, ValueType)
    -- ==GetIniValue(xFile, xGroup, xItem, ValueType)==
-- Returns a value from a file, group, and Item
-- Usage: XX.YY = GetIniValue(xPath, FileName, GroupName, "XX.YY", "N") ''
    local fileR = io.open(xFile)
    local dat = "."
    local ItemNameLen = string.len(xItem)
    for Line in fileR:lines() do
      if string.upper(All_Trim(Line)) == "[" .. string.upper(xGroup) .. "]" then
        break
      end -- if end
    end -- while end
    for Line in fileR:lines() do
      dat = string.upper(All_Trim(Line))
      if string.upper(xItem) == string.sub(dat, 1, ItemNameLen)  then
        break
      end -- if end
    end -- while end
    fileR:close()-- closes the open file
    local XX = INI_StrValue(dat, ValueType)
    return XX
  end -- function end
-- =====================================================]]
function INI_StrValue(str, ty)
-- Convert string to the correct data type
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
-- =====================================================]]
function INI_UpdateItem(xPath, xFile, xGroup,  xItem, xValue)
-- Deletes old ini (.bak) file
-- Copys the .ini to a backup (.bak) new file
-- Reads the new backup file and writes a new file to the xGroup
-- Writes new xValue for the for the xItem
-- Reads and writes a new file to end of file
  local NfileName = xPath .. "/" .. xFile .. ".ini"
  local OfileName = xPath .. "/" .. xFile .. ".bak"
  os.remove(OfileName)
  os.rename(NfileName, OfileName) -- makes backup file
  local fileR = io.open(OfileName)
  local fileW = io.open(NfileName,  "w")
  local groups = false
  local txt = ""
  for Line in fileR:lines() do
    txt = Line
    if All_Trim(Line) == "[" .. All_Trim(xGroup) .. "]" then -- Group
      groups = true
    end -- if end
    if xItem == string.sub(Line, 1, string.len(xItem))  then  -- Item
      if groups then
        txt = xItem .. " = " .. xValue
        groups = false
      end -- if end
    end -- if end
    fileW:write(txt .. "\n")
    txt = ""
  end -- for end
  os.remove(OfileName)
  fileR:close() ;
  fileW:close() ;
  return true
end -- function end
-- =====================================================]]
function INI_UpdateClientInfo(xGroup)
  if INI_ValidateGroup(Client.Path, xGroup)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.Contact", Client.Contact)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.Email", Client.Email)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.Address", Client.Address)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.State", Client.State)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.City", Client.City)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.Zip", Client.Zip)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "Client.Phone", Client.Phone)
else

  end
end -- function end
-- =====================================================]]
function INI_ReadClientInfo(xFile, xGroup)
  Client.Contact = make_proper_case(INI_GetValue(xFile, xGroup, "Client.Contact", "S"))
  Client.Email   = make_proper_case(INI_GetValue(xFile, xGroup, "Client.Email", "S"))
  Client.Address = make_proper_case(INI_GetValue(xFile, xGroup, "Client.Address", "S"))
  Client.State   = INI_GetValue(xFile, xGroup, "Client.State", "S")
  Client.City    = make_proper_case(INI_GetValue(xFile, xGroup, "Client.City", "S"))
  Client.Zip     = INI_GetValue(xFile, xGroup, "Client.Zip", "S")
  Client.Phone   = INI_GetValue(xFile, xGroup, "Client.Phone", "S")
end -- function end
-- ====================================================]]
function InquiryClient(Header)
--[[
  -- ClientName = InquiryClient("Cabinet Maker", "Select Cabinets", 290, 165, Cabinets)
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
  local myHtml = [[<!DOCTYPE html><html lang="en"><head><title>Client Data</title><style>html{overflow:hidden}.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap;background-color:#630;color:#FFF}.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px;background-color:#630;color:#FFF}.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}.ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;width:50px;background-color:#630;color:#FFF}.TableSizeMax{border:0;width:100%}.TableSize600{width:600px;border:0}.FootTableSize600{width:600px;border:0}.FootColumn1{width:45px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn2{width:350px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.FootColumn3{width:15px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn4{width:15px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.Column1{width:150px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.Column2{width:175px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.Column3{width:250px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.alert-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#FFF;text-align:center;white-space:nowrap}.alert-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-shadow:5px 5px 10px #FFF;color:#FF0101;text-align:left;white-space:nowrap}.alert-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}.error{font-family:Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#F00;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorTable{background-color:#FFF;white-space:nowrap}.p1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;color:#000}.p1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;color:#000}.p1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;color:#000}.label-l{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;font-style:oblique;text-align:left;white-space:nowrap;color:#000}.label-r{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;font-style:oblique;text-align:right;white-space:nowrap;color:#000}.label-c{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;font-style:oblique;text-align:center;white-space:nowrap;color:#000}.ver-c{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap;color:#ffd9b3}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;color:#000}.h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px;color:#000}.h2-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:left;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:center;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#000;text-align:right;white-space:nowrap;text-shadow:2px 2px white;color:#8E8D8A}.h3-bc{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h3{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.webLink-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;background-color:yellow;text-align:center;white-space:nowrap}.jsbutton{background-color:#630;border:2px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:1px 1px;color:#FFF}.jsTag-no-vis{font-family:Arial,Helvetica,sans-serif;font-size:10px;display:none;text-align:center;color:#00F;visibility:hidden}body{background-color:#EAE7DC;background-position:center;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#8E8D8A}html{overflow:hidden}</style></head><body><table class="TableSize600" id="NextAction4"><tr><td colspan="7" class="label-l">Client Selection</td></tr><tr><td rowspan="7" align="center" valign="top" class="h1-l"><select name="Client.List" id="Client.List"></select></td><td class="h1-r">Client Name</td><td colspan="5" class="FootColumn2"><input name="Client.Name" type="text" id="Client.Name" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">Contact</td><td colspan="5" class="FootColumn2"><input name="Client.Contact" type="text" id="Client.Contact" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">Email</td><td colspan="5" class="FootColumn2"><input name="Client.Email" type="text" id="Client.Email" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">Phone</td><td colspan="5" class="FootColumn2"><input name="Client.Phone" type="text" id="Client.Phone" size="16" maxlength="16" /></td></tr><tr><td class="h1-r">Address</td><td colspan="5" class="FootColumn2"><input name="Client.Address" type="text" id="Client.Address" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">City</td><td class="h1-l"><input name="Client.City" type="text" class="h1-l" id="Client.City" size="10" maxlength="30" /></td><td class="h1-r">State</td><td class="h1-l"> <input name="Client.State" type="text" class="h1-l" id="Client.State" size="4" maxlength="4" /></td><td class="h1-r">Zip</td><td class="h1-l"> <input name="Client.Zip" type="text" class="h1-l" id="Client.Zip" size="12" maxlength="12" /></td></tr></table><table class="TableSize600" id="NextAction3"><tr><td colspan="4" class="label-l">Client Action</td></tr><tr><td class="h1-c"><input name="SelectClient" type="button" class="LuaButton" id="SelectClient" value="Select Client"></td><td class="h1-c"><input name="NewClient" type="button" class="LuaButton" id="NewClient" value="New Client"></td><td class="h1-c"><input name="ClientUpdate" type="button" class="LuaButton" id="ClientUpdate" value="Update Data"></td><td class="h1-c"><input name="Client.Delete" type="button" class="LuaButton" id="Client.Delete" value="Delete Client"></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ClientHelp .. [[');">Help</button></td><td class="FootColumn2" id="Client.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]
        dialog = HTML_Dialog(true, myHtml, 636, 344, Header .. " (Ver: " .. Test.Version .. ")") ;
        --dialog:AddDropDownList("Client.List", "Select Client")
        --dialog:AddDropDownListValue("Client.List", "")
    local x1 = true

    for _, value in pairs(ClientList) do
        if x1 then
          dialog:AddDropDownList("Client.List", value)
          dialog:AddDropDownListValue("Client.List", value)
          x1 = false
        else
          dialog:AddDropDownListValue("Client.List", value)
        end
    end
    dialog:AddTextField("Client.Name", "") ;
    dialog:AddTextField("Client.Contact", "") ;
    dialog:AddTextField("Client.Email", "") ;
    dialog:AddTextField("Client.Address", "") ;
    dialog:AddTextField("Client.State", "") ;
    dialog:AddTextField("Client.City", "") ;
    dialog:AddTextField("Client.Zip", "") ;
    dialog:AddTextField("Client.Phone", "") ;
--  dialog:AddTextField("qInput2", xFile) ;
--  dialog:AddTextField("qInput3", xGroup) ;

  if not dialog:ShowDialog() then
     DialogWindow.InquiryXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    return false
  else
     DialogWindow.InquiryXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    return true
  end
end
-- =====================================================]]
function make_proper_case(str)
    local str=string.gsub(string.lower(str),"^(%w)", string.upper)
    return string.gsub(str,"([^%w]%w)", string.upper)
  end
-- =====================================================]]
function INI_ReadsGroups(xFile)
--[[Reads INI and returns a list containg the [Headers] as Array
IniFile = {} Global variables
xPath = script_path
]]
  local fileR = io.open(xFile)
  local xLine =""
  for Line in fileR:lines() do
    xLine = make_proper_case(Line)
    if "[" == string.sub(All_Trim(xLine), 1, 1) then
      xLine = string.sub(xLine, 2, (string.len(xLine) - 1))
      table.insert (ClientList, xLine)
    end
  end
  fileR:close()
  return true
end
-- ====================================================]]
function INI_ReadClients(xFile)
--[[Reads INI and returns a list containg the [Headers] as Array
IniFile = {} Global variables
xPath = script_path
]]
  local fileR = io.open(xFile)
  local xLine =""
  for Line in fileR:lines() do
    xLine = make_proper_case(Line)
    if "[" == string.sub(All_Trim(xLine), 1, 1) then
      xLine = string.sub(xLine, 2, (string.len(xLine) - 1))
      if xLine ~= "Client Path" then
        table.insert (ClientList, xLine)
      end
    end
  end
  fileR:close()
  return true
end
-- ====================================================]]
function INI_DeleteItem(xPath, xFile, xGroup, xItem)
-- Deletes old ini (.bak) file
-- Copys the .ini to a backup (.bak) new file
-- Reads the new backup file and writes a new file to the xGroup value
-- Stops Writing lines until next Group is found
-- Writes to end of file
-- DeleteGroup("C:\\Users\\James\\OneDrive\\Documents\\DoorGadget\\Clients\\Marcin", "ProjectList", "Boston")
  local NfileName = xPath .. "/" .. xFile .. ".ini"
  local OfileName = xPath .. "/" .. xFile .. ".bak"
  os.remove(OfileName)
  os.rename(NfileName, OfileName) -- makes backup copy file
  local fileR = io.open(OfileName)
  local fileW = io.open(NfileName,  "w")
  local groups = false
  local writit = true
  local txt = ""
  for Line in fileR:lines() do
    txt = Line
    if All_Trim(Line) == "[" .. All_Trim(xGroup) .. "]" then  -- Group found
      groups = true
    end -- if end
    if groups then
-- ========================================================<>=
      if xItem == string.sub(Line, 1, string.len(xItem))  then  -- Item found
        writit = false
        groups = false
      end -- if end
    end -- if end
-- ========================================================<>=
    if writit then
      fileW:write(txt .. "\n")
    end -- if end
    writit = true
  end -- for end
  os.remove(OfileName)
  fileR:close()
  fileW:close()
  return true
end -- function end
-- ====================================================]]
function main(script_path)
  local job  =  VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
      "specify the material dimensions")
    return false
  end
--  ======
    --local X = make_proper_case("BOSTONS TOM Bill jim")
    -- Test.Inquiry = test("Test Tools", "C:\\Users\\James\\OneDrive\\Documents\\DoorGadget\\Clients\\Marcin", "ProjectList", X)
    Client.xFile = "Clients"
    Client.xPath = script_path
    Client.Path = script_path .. "\\" .. "Clients.ini"

    INI_ReadClients(Client.Path)
    InquiryClient("Client List")
    -- if Test.Inquiry then
      -- DisplayMessageBox(Test.path)
      -- DisplayMessageBox(Test.folder)
      -- DisplayMessageBox("mkdir  " .. Test.path .. "\\" .. Test.folder)
      -- os.execute( "mkdir  " .. Test.path .. "\\" .. Test.folder)
      -- DeleteGroup(Test.path, Test.file, Test.group)
      -- AddNewProject(Test.path, "Superman")
     -- DisplayMessageBox(DialogWindow.InquiryXY)
      -- if ValidateGroup("C:\\Users\\James\\OneDrive\\Documents\\DoorGadget\\Clients\\Marcin\\ProjectList.ini", "BostonS") then
      --   UpdateItem(Test.path, Test.file, Test.group, "test", "Jim4")
      -- end

      --if INI_ValidateItem("C:\\Users\\James\\OneDrive\\Documents\\DoorGadget\\Clients\\Marcin\\ProjectList.ini", "BostonS", "TEST" ) then
        --INI_UpdateItem(Test.path, Test.file, Test.group, "test", "Bob")
        --INI_DeleteItem(xPath, xFile, xGroup, Item)
       -- INI_DeleteItem(Test.path, Test.file, Test.group, "tesT")
      --end
    -- end



  return true
end  -- function end
--  ===================================================]]