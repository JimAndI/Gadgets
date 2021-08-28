-- VECTRIC LUA SCRIPT
-- ====================================================]]
-- Global Variables --
require("mobdebug").start()
-- require "strict"
local Test         = {}
local DialogWindow = {}
local ClientList   = {}
local ProjectList  = {}
local Project       = {}
local Client       = {}
local Selection    = {}

local Version      = 1.0
local VersionDate  = ""
local test
local Clientdialog
local MainNewdialog
local Selectiondialog
DialogWindow.ClientHelp = "https://forum.vectric.com/search.php?search_id=unreadposts"
DialogWindow.ProjectHelp = "https://forum.vectric.com/search.php?search_id=unreadposts"
DialogWindow.RoomsHelp = "https://forum.vectric.com/search.php?search_id=unreadposts"
DialogWindow.DoorsHelp = "https://forum.vectric.com/search.php?search_id=unreadposts"
DialogWindow.ClientXY   = "Not Used"
DialogWindow.MainNewXY  = "Not Used"
DialogWindow.MainXY     = "Not Used"
DialogWindow.SelectionXY     = "Not Used"

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
function INI_AddNewClient(xGroup)
  -- Appends a New Project to CabinetProjectQuestion.ini
  -- ==AddNewProject(xPath)==
  -- Appends a New Project to CabinetProjectQuestion.ini
    local file = io.open(Client.FullPath, "a")
    file:write("[" .. All_Trim(xGroup) .. "]\n") ;
    file:write("load_date = " .. StartDate(true) .. "\n") ;
    file:write("client.contact = " .. All_Trim(Client.Contact) .. "\n")
    file:write("client.address = " .. All_Trim(Client.Address) .. "\n")
    file:write("client.city = " .. All_Trim(Client.City) .. "\n")
    file:write("client.state = " .. All_Trim(Client.State) .. "\n")
    file:write("client.zip = " .. All_Trim(Client.Zip) .. "\n")
    file:write("client.phone = " .. All_Trim(Client.Phone) .. "\n")
    file:write("client.email = " .. All_Trim(Client.Email) .. "\n")
    file:write("#======================================\n") ;
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
  local dialog = HTML_Dialog(true, DialogWindow.Test, 730, 200, Header .. " " .. Test.Version) ;
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
function OnLuaButton_AddProject()
  Client.Name = Clientdialog:GetDropDownListValue("Client.List")
  Clientdialog:UpdateLabelField("Client.Alert", "")
  INI_ReadClientInfo(Client.FullPath, Client.Name)
  Clientdialog:UpdateTextField("Client.Name", Client.Name)
  Clientdialog:UpdateTextField("Client.Contact", Client.Contact)
  Clientdialog:UpdateTextField("Client.Email", Client.Email)
  Clientdialog:UpdateTextField("Client.Address", Client.Address)
  Clientdialog:UpdateTextField("Client.State", string.upper(Client.State))
  Clientdialog:UpdateTextField("Client.City", Client.City)
  Clientdialog:UpdateTextField("Client.Zip", Client.Zip)
  Clientdialog:UpdateTextField("Client.Phone", Client.Phone)
  Clientdialog:UpdateLabelField("Client.LoadDate", Client.LoadDate)
  Clientdialog:UpdateLabelField("Client.Alert", Client.Name .. " is the selected client.")
  return  true
end
-- ====================================================]]
function OnLuaButton_SelectClient()
  Client.Name = Clientdialog:GetDropDownListValue("Client.List")
  Clientdialog:UpdateLabelField("Client.Alert", "")
  INI_ReadClientInfo(Client.FullPath, Client.Name)
  Clientdialog:UpdateTextField("Client.Name", Client.Name)
  Clientdialog:UpdateTextField("Client.Contact", Client.Contact)
  Clientdialog:UpdateTextField("Client.Email", Client.Email)
  Clientdialog:UpdateTextField("Client.Address", Client.Address)
  Clientdialog:UpdateTextField("Client.State", string.upper(Client.State))
  Clientdialog:UpdateTextField("Client.City", Client.City)
  Clientdialog:UpdateTextField("Client.Zip", Client.Zip)
  Clientdialog:UpdateTextField("Client.Phone", Client.Phone)
  Clientdialog:UpdateLabelField("Client.LoadDate", Client.LoadDate)
  Clientdialog:UpdateLabelField("Client.Alert", Client.Name .. " is the selected client.")
  return  true
end
-- ====================================================]]
function OnLuaButton_ClientUpdate()
  Clientdialog:UpdateLabelField("Client.Alert", "")
  Client.Name    = Clientdialog:GetTextField("Client.Name")
  Client.Contact = Clientdialog:GetTextField("Client.Contact")
  Client.Email   = Clientdialog:GetTextField("Client.Email")
  Client.Address = Clientdialog:GetTextField("Client.Address")
  Client.State   = string.upper(Clientdialog:GetTextField("Client.State"))
  Client.City    = Clientdialog:GetTextField("Client.City")
  Client.Zip     = Clientdialog:GetTextField("Client.Zip")
  Client.Phone   = Clientdialog:GetTextField("Client.Phone")

  INI_UpdateClientInfo(Client.Name)
  Clientdialog:UpdateLabelField("Client.Alert", Client.Name .. " has been updated.")
  return  true
end
-- ====================================================]]
function OnLuaButton_ClientDelete()
  Clientdialog:UpdateLabelField("Client.Alert", "")
  INI_DeleteGroup(Client.xPath, "Clients", Client.Name)
  Clientdialog:UpdateLabelField("Client.Alert", Client.Name .. " has been deleted.")
  return  true
end
-- ====================================================]]
function OnLuaButton_Selector()
  Selectiondialog = HTML_Dialog(true, DialogWindow.Selection, 630, 174, "Selection Test Dialog (Ver: " .. Version .. ")") ;
  return  true
end
-- ====================================================]]
function OnLuaButton_GetDropDownProject()

  local GetSelectiondialog:AddDropDownList("Selection.Client", "Superman")
  -- Selectiondialog:AddDropDownListValue("Selection.Client", "Super")
  table.insert (ClientList, "Superman")
  for _, value in pairs(ClientList) do
    Selectiondialog:UpdateDropDownListValue("Selection.Client", value)

  end



--[[  local ProjectINI = Project.Path .. "\\".. Client.Name .. "\\ProjectList.ini"
  INI_ReadProjects(ProjectINI)
  local x1 = true
  for _, value in pairs(ProjectList) do
      if x1 then
        Selectiondialog:AddDropDownList("Selection.Project", value)
        Selectiondialog:AddDropDownListValue("Selection.Project", value)
        Client.Name = value
        x1 = false
      else
        Selectiondialog:AddDropDownListValue("Selection.Project", value)
      end
  end]]
  return  true
end
-- ====================================================]]
function OnLuaButton_GetDropDownRoom()

  local GetSelectiondialog:AddDropDownList("Selection.Client", "Superman")
  -- Selectiondialog:AddDropDownListValue("Selection.Client", "Super")
  table.insert (ClientList, "Superman")
  for _, value in pairs(ClientList) do
    Selectiondialog:UpdateDropDownListValue("Selection.Client", value)
  end
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
  Clientdialog:UpdateTextField("Client.Name", Client.Name)
  Clientdialog:UpdateTextField("Client.Contact", Client.Contact)
  Clientdialog:UpdateTextField("Client.Email", Client.Email)
  Clientdialog:UpdateTextField("Client.Address", Client.Address)
  Clientdialog:UpdateTextField("Client.State", string.upper(Client.State))
  Clientdialog:UpdateTextField("Client.City", Client.City)
  Clientdialog:UpdateTextField("Client.Zip", Client.Zip)
  Clientdialog:UpdateTextField("Client.Phone", Client.Phone)
  Clientdialog:UpdateLabelField("Client.LoadDate", Client.LoadDate)
  Clientdialog:UpdateLabelField("Client.Alert", Client.Name .. " has been added to the Client List. Select Update to save.")
  return  true
end
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
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
    if string.upper(All_Trim(Line)) == string.upper("[" .. All_Trim(xGroup) .. "]") then -- Group
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
-- ====================================================]]
function INI_WriteClientFile(xPath)
  local NfileName = xPath .. "\\Clients.ini"
  local fileW = io.open(NfileName,  "w")
  fileW:write("#======================================\n")
  fileW:write("# MDF Door Maker Program\n")
  fileW:write("# Code By Steven Steven Godding & Jim Anderson\n")
  fileW:write("# Build Date    = " .. VersionDate .. "\n")
  fileW:write("# Build Version = " .. Version .. "\n")
  fileW:write("#--------------------------------------\n")
  fileW:write("# Client Informaction List\n")
  fileW:write("#======================================\n")
  fileW:write("[Client Path]\n")
  fileW:write("path = " .. xPath .. "\n")
  fileW:write("#======================================\n")
  fileW:close() ;
end -- function end
-- ====================================================]]
function INI_UpdateClientInfo(xGroup)
  if INI_ValidateGroup(Client.FullPath, xGroup) then
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.contact", Proper(Client.Contact))
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.email", Proper(Client.Email))
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.address", Proper(Client.Address))
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.state", string.upper(Client.State))
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.city", Proper(Client.City))
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.zp", Client.Zip)
  INI_UpdateItem(Client.xPath, Client.xFile, xGroup, "client.phone", Client.Phone)
else
  INI_AddNewClient(Client.Name)
  end
end -- function end
-- ====================================================]]
function HTML()
  DialogWindow.Style = [[<style>html{overflow:hidden}.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica, sans-serif;font-size:12px}.FormButton{font-weight:bold;width:75px; font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap;background-color:#630;color:#FFF}.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px; background-color:#630;color:#FFF}.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}.ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;width:50px;background-color:#630;color:#FFF}.TableSizeMax{border:0;width:100%}.TableSize600{width:600px;border:0}.FootTableSize600{width:600px;border:0}.FootColumn1{width:45px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn2{width:350px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.FootColumn3{width:15px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn4{width:15px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.Column1{width:150px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.Column2{width:175px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.Column3{width:250px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.alert-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#FFF;text-align:center;white-space:nowrap}.alert-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-shadow:5px 5px 10px #FFF;color:#FF0101;text-align:left;white-space:nowrap}.alert-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}.error{font-family:Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#F00;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorTable{background-color:#FFF;white-space:nowrap}.p1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;color:#000}.p1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;color:#000}.p1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;color:#000}.label-l{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;font-style:oblique;text-align:left;white-space:nowrap;color:#000}.label-r{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;font-style:oblique;text-align:right;white-space:nowrap;color:#000}.label-c{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;font-style:oblique;text-align:center;white-space:nowrap;color:#000}.ver-c{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap;color:#ffd9b3}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;color:#000}.h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px;color:#000}.h2-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:left;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:center;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#000;text-align:right;white-space:nowrap;text-shadow:2px 2px white;color:#8E8D8A}.h3-bc{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h3{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.webLink-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;background-color:yellow;text-align:center;white-space:nowrap}.jsbutton{background-color:#630;border:2px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:1px 1px;color:#FFF}.jsTag-no-vis{font-family:Arial,Helvetica,sans-serif;font-size:10px;display:none;text-align:center;color:#00F;visibility:hidden}body{background-color:#EAE7DC;background-position:center;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#8E8D8A}html{overflow:hidden}</style>]]

DialogWindow.Main = [[<!DOCTYPE html><html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Untitled Document</title> ]] .. DialogWindow.Style .. [[</head><body><table class="TableSize600" id="NextAction"><tr><td colspan="3" class="label-l">Select Next Action</td></tr><td colspan="3"><hr></td><tr><td class="h1-c"><input name="InquiryClient" type="button" class="LuaButton" id="InquiryClient" value="Manage Clients"></td><td class="h1-c"><input name="MainTBD" type="button" class="LuaButton" id="MainTBD" value="TBD"></td><td class="h1-c"><input name="MainSetting" type="button" class="LuaButton" id="MainSetting" value="Manage System"></td></tr><td colspan="3"><hr></td><tr><td class="h1-c"><input name="MainNewProject" type="button" class="LuaButton" id="MainNewProject" value="New Project"></td><td class="h1-c"><input name="MainOpenProject" type="button" class="LuaButton" id="MainOpenProject" value="Open Project"></td><td class="h1-c"><input name="MainCloneProject" type="button" class="LuaButton" id="MainCloneProject" value="Clone Project"></td></tr></table><table class="TableSize600" id="HelpMessageCancel"><tr><td colspan="3"><hr></td></tr><tr><td width="45" class="FootColumn1" ><button class="FormButton" id="MainHelp" onClick="window.open(']].. DialogWindow.ClientHelp .. [[');"> Help </button></td><td width="444" class="FootColumn2" id="MainAlert">.</td><td width="95" class="FootColumn4" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td></tr></table></body></html>]]

DialogWindow.Selection = [[<!DOCTYPE html><html lang="en"><head> ]] .. DialogWindow.Style .. [[<title>Selection</title></head><body><table width="700" border="0" class="TableSize600"><tr><td colspan="6" class="label-c"><hr></td></tr><tr><td colspan="2" class="label-c">Select Client</td><td colspan="2" class="label-c">Select Project</td><td colspan="2" class="label-c">Select Room</td></tr><tr class="h1-c"><td><select name="Selection.Client" id="Selection.Client"><option>Clients 1</option><option>Clients 2</option><option>Clients 3</option><option selected>Clients 1</option> </select></td><td><input name="GetProject" type="button" class="LuaButton" id="GetProject" value="Go"></td><td><select name="Selection.Project" id="Selection.Project"><option>Projects 1</option><option>Projects 2</option><option>Projects 3</option><option selected>Projects 1</option> </select></td><td><input name="GetRoom" type="button" class="LuaButton" id="GetRoom" value="Go"></td><td><select name="Selection.Room" id="Selection.Room"><option>Room 1</option><option>Room 2</option><option>Room 3</option><option selected>Room 1</option> </select></td><td><input name="GetDoor" type="button" class="LuaButton" id="GetDoor" value="Go"></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ClientHelp .. [[');"> Help </button></td><td class="FootColumn2" id="Gadget.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]

DialogWindow.Test = [[<!DOCTYPE html><html lang="en"><head> <title>Test</title> ]] .. DialogWindow.Style .. [[</head><body><table border="0" width="296" cellpadding="0"><tbody>
  <tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here</td>
    <th class="h1-l" align="left" valign="middle" width="120"><input id="qInput" name="qInput" size="100" type="text" /></td> </tr>
  <tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID2">Message Here2</td>
    <th class="h1-l" align="left" valign="middle" width="120"><input id="qInput2" name="qInput2" size="100" type="text" /></td>  </tr>
  <tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID3">Message Here3</td>
    <th class="h1-l" align="left" valign="middle" width="120"><input id="qInput3" name="qInput3" size="100" type="text" /></td>  </tr>
  <tr><td colspan="2" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td style="width: 20%;">&nbsp;</td><td style="width: 20%;">&nbsp;</td><td style="width: 25%;">&nbsp;</td><td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]

DialogWindow.MainNewProject = [[<!DOCTYPE html><html lang="en"><head>]] .. DialogWindow.Style .. [[<title>Select the Client</title><table class="TableSize600" id="NextAction5"><tr><td colspan="2" class="label-l">Selected Client</td></tr><tr><td class="h1-l">Client Name:</td><td width="100%" class="h1-l" id="Gadget.ClientName">Selected Clients Name</td></tr></table><table class="TableSize600" id="NextAction4"><tr><td colspan="3" class="label-l">Client Selection</td></tr><tr><td rowspan="9" align="center" valign="top" class="h1-l"><select name="1232" size="10" id="1232"><option selected>Client Name 1</option><option>Client Name 2</option><option>Client Name 3</option><option>Client Name 4</option><option>Client Name 5</option><option>Client Name 6</option><option>Client Name 7</option><option>Client Name 8</option><option>Client Name 9</option><option>Client Name 10</option><option>Client Name 11</option><option>Client Name 12</option> </select></td><td class="h1-r">Name</td><td class="FootColumn2"><td class="FootColumn2" id="Client.Name">.</td></td></tr><tr><td class="h1-r">Contact</td><td class="FootColumn2"><td class="FootColumn2" id="Client.Contact">.</td></td></tr><tr><td class="h1-r">Email</td><td class="FootColumn2"><td class="FootColumn2" id="Client.Email">.</td></td></tr><tr><td class="h1-r">Phone</td><td class="FootColumn2"><td class="FootColumn2" id="Client.Phone">.</td></td></tr><tr><td class="h1-r">Address</td><td class="FootColumn2"><td class="FootColumn2" id="Client.Address">.</td></td></tr><tr><td class="h1-r">City</td><td class="FootColumn2"><td class="FootColumn2" id="Client.City">.</td></td></tr><tr><td class="h1-r">State</td><td class="FootColumn2"><td class="FootColumn2" id="Client.State">.</td></td></tr><tr><td class="h1-r">Zip</td><td class="FootColumn2"><td class="FootColumn2" id="Client.Zip">.</td></td></tr><tr><td class="FootColumn1">&nbsp;</td><td class="FootColumn2">&nbsp;</td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ClientHelp .. [[');"> Help </button></td><td class="FootColumn2" id="Selection.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]

DialogWindow.InquirySelectRoom = [[<!DOCTYPE html><html lang="en"><head><title>Untitled Document</title> ]] .. DialogWindow.Style .. [[</head><body><table class="TableSize600" id="NextAction"><tr><td colspan="3" class="label-l">Room Selection</td></tr><tr><td class="h1-c" id="Gadget.Alert">Client:</td><td class="h1-c" id="Gadget.Alert">Project:</td><td class="h1-c" id="Gadget.Alert">Room:</td></tr><tr><td class="h1-c"><input name="ShowSelecter" type="button" class="LuaButton" id="ShowSelecter" value="Select Client"></td><td class="h1-c"><input name="ShowSelecter" type="button" class="LuaButton" id="ShowSelecter" value="Select Project"></td><td class="h1-c"><input name="ShowSelecter" type="button" class="LuaButton" id="ShowSelecter" value="Select Room"></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ProjectSDK .. [[');"> Help </button></td><td class="FootColumn2" id="Gadget.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]

DialogWindow.InquirySelect = [[<!DOCTYPE html><html lang="en"><head><title>Untitled Document</title> ]] .. DialogWindow.Style .. [[</head><body><table class="TableSize600"><tr><td colspan="2"><hr></td></tr><tr><td class="h1-r" id="Gadget.Name">Message:</td><td><select name="Clients2" id="Clients2"><option>Clients 1</option><option>Clients 2</option><option>Clients 3</option><option selected>Clients 1</option> </select></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ProjectSDK .. [[');"> Help </button></td><td class="FootColumn2" id="Gadget.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]

DialogWindow.InquiryClient = [[<!DOCTYPE html><html lang="en"><head><title>Client Data</title>]] .. DialogWindow.Style .. [[</head><body><table class="TableSize600" id="NextAction4"><tr><td colspan="7" class="label-l">Client Selection</td></tr><tr><td rowspan="7" align="center" valign="top" class="h1-l"><select name="Client.List" id="Client.List"></select></td><td class="h1-r">Client Name</td><td colspan="4" class="FootColumn2"><input name="Client.Name" type="text" id="Client.Name" size="30" maxlength="65" /></td><td class="label-c" id="Client.LoadDate">.</td></tr>  <tr><td class="h1-r">Contact</td><td colspan="5" class="FootColumn2"><input name="Client.Contact" type="text" id="Client.Contact" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">Email</td><td colspan="5" class="FootColumn2"><input name="Client.Email" type="text" id="Client.Email" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">Phone</td><td colspan="5" class="FootColumn2"><input name="Client.Phone" type="text" id="Client.Phone" size="16" maxlength="16" /></td></tr><tr><td class="h1-r">Address</td><td colspan="5" class="FootColumn2"><input name="Client.Address" type="text" id="Client.Address" size="35" maxlength="65" /></td></tr><tr><td class="h1-r">City</td><td class="h1-l"><input name="Client.City" type="text" class="h1-l" id="Client.City" size="10" maxlength="30" /></td><td class="h1-r">State</td><td class="h1-l"> <input name="Client.State" type="text" class="h1-l" id="Client.State" size="4" maxlength="4" /></td><td class="h1-r">Zip</td><td class="h1-l"> <input name="Client.Zip" type="text" class="h1-l" id="Client.Zip" size="12" maxlength="12" /></td></tr></table><table class="TableSize600" id="NextAction3"><tr><td colspan="4" class="label-l">Client Action</td></tr><tr><td class="h1-c"><input name="SelectClient" type="button" class="LuaButton" id="SelectClient" value="Select Client"></td><td class="h1-c"><input name="NewClient" type="button" class="LuaButton" id="NewClient" value="New Client"></td><td class="h1-c"><input name="ClientUpdate" type="button" class="LuaButton" id="ClientUpdate" value="Update Data"></td><td class="h1-c"><input name="ClientDelete" type="button" class="LuaButton" id="ClientDelete" value="Delete Client"></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ClientHelp .. [[');">Help</button></td><td class="FootColumn2" id="Client.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]
end
-- ====================================================]]
function INI_ReadClientInfo(xFile, xGroup)
  Client.Contact = Proper(INI_GetValue(xFile, xGroup, "Client.Contact", "S"))
  Client.Email   = Proper(INI_GetValue(xFile, xGroup, "Client.Email", "S"))
  Client.Address = Proper(INI_GetValue(xFile, xGroup, "Client.Address", "S"))
  Client.State   = INI_GetValue(xFile, xGroup, "Client.State", "S")
  Client.City    = Proper(INI_GetValue(xFile, xGroup, "Client.City", "S"))
  Client.Zip     = INI_GetValue(xFile, xGroup, "Client.Zip", "S")
  Client.Phone   = INI_GetValue(xFile, xGroup, "Client.Phone", "S")
  Client.LoadDate = "Entry Date: " .. INI_GetValue(xFile, xGroup, "load_date", "S")
end -- function end
-- ====================================================]]
function OnLuaButton_InquiryClient()
  Clientdialog = HTML_Dialog(true, DialogWindow.InquiryClient, 636, 333, "Client Management Screen (Ver: " .. Version .. ")") ;
  Clientdialog:AddLabelField("Client.Alert", "")
  local x1 = true
  for _, value in pairs(ClientList) do
      if x1 then
        Clientdialog:AddDropDownList("Client.List", value)
        Clientdialog:AddDropDownListValue("Client.List", value)
        x1 = false
      else
        Clientdialog:AddDropDownListValue("Client.List", value)
      end
  end
  Clientdialog:AddTextField("Client.Name", "")
  Clientdialog:AddTextField("Client.Contact", "")
  Clientdialog:AddTextField("Client.Email", "")
  Clientdialog:AddTextField("Client.Address", "")
  Clientdialog:AddTextField("Client.State", "")
  Clientdialog:AddTextField("Client.City", "")
  Clientdialog:AddTextField("Client.Zip", "")
  Clientdialog:AddTextField("Client.Phone", "")
  Clientdialog:AddLabelField("Client.LoadDate", "")
  if not Clientdialog:ShowDialog() then
     DialogWindow.ClientXY  = tostring(Clientdialog.WindowWidth) .. " x " ..  tostring(Clientdialog.WindowHeight)
     REG_WriteRegistry()
    return false
  else
     DialogWindow.ClientXY  = tostring(Clientdialog.WindowWidth) .. " x " ..  tostring(Clientdialog.WindowHeight)
     REG_WriteRegistry()
    return true
  end
end
-- ====================================================]]
function OnLuaButton_MainNewProject()
  MainNewdialog = HTML_Dialog(true, DialogWindow.MainNewdialog, 636, 333, "Client Management Screen (Ver: " .. Version .. ")") ;
  MainNewdialog:AddLabelField("Client.Alert", "")
  local x1 = true
  for _, value in pairs(ClientList) do
      if x1 then
        MainNewdialog:AddDropDownList("Client.List", value)
        MainNewdialog:AddDropDownListValue("Client.List", value)
        x1 = false
      else
        MainNewdialog:AddDropDownListValue("Client.List", value)
      end
  end
  MainNewdialog:AddTextField("Client.Name", "")
  MainNewdialog:AddTextField("Client.Contact", "")
  MainNewdialog:AddTextField("Client.Email", "")
  MainNewdialog:AddTextField("Client.Address", "")
  MainNewdialog:AddTextField("Client.State", "")
  MainNewdialog:AddTextField("Client.City", "")
  MainNewdialog:AddTextField("Client.Zip", "")
  MainNewdialog:AddTextField("Client.Phone", "")
  MainNewdialog:AddLabelField("Client.LoadDate", "")
  if not Clientdialog:ShowDialog() then
     DialogWindow.MainNewXY  = tostring(MainNewdialog.WindowWidth) .. " x " ..  tostring(MainNewdialog.WindowHeight)
     REG_WriteRegistry()
    return false
  else
     DialogWindow.MainNewXY  = tostring(MainNewdialog.WindowWidth) .. " x " ..  tostring(MainNewdialog.WindowHeight)
     REG_WriteRegistry()
    return true
  end
end
-- ====================================================]]
function InquiryMain()
  local dialog = HTML_Dialog(true, DialogWindow.Main, 622, 218, "MDF Door Maker Main Screen (Ver: " .. Version .. ")") ;
  dialog:AddLabelField("Client.Alert", "")

  if not dialog:ShowDialog() then
     DialogWindow.MainXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
     REG_WriteRegistry()
    return false
  else
     DialogWindow.MainXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
     REG_WriteRegistry()
    return true
  end
end
-- ====================================================]]
function InquiryRoomSelecter()
  Selectiondialog = HTML_Dialog(true, DialogWindow.Selection, 630, 174, "Selection Test Dialog (Ver: " .. Version .. ")") ;
  Selectiondialog:AddLabelField("Selection.Alert", "")
  local x1 = true
  for _, value in pairs(ClientList) do
      if x1 then
        Selectiondialog:AddDropDownList("Selection.Client", value)
        Selectiondialog:AddDropDownListValue("Selection.Client", value)
        Client.Name = value
        x1 = false
      else
        Selectiondialog:AddDropDownListValue("Selection.Client", value)
      end
  end
  Selectiondialog:AddDropDownList("Selection.Project", "---")
  Selectiondialog:AddDropDownList("Selection.Room", "---")

  if not Selectiondialog:ShowDialog() then
     DialogWindow.SelectionXY  = tostring(Selectiondialog.WindowWidth) .. " x " ..  tostring(Selectiondialog.WindowHeight)
     REG_WriteRegistry()
    return false
  else
     DialogWindow.SelectionXY  = tostring(Selectiondialog.WindowWidth) .. " x " ..  tostring(Selectiondialog.WindowHeight)
     REG_WriteRegistry()
    return true
  end
end
-- ====================================================]]
function InquirySelection()
  Selectiondialog = HTML_Dialog(true, DialogWindow.Selection, 630, 174, "Selection Test Dialog (Ver: " .. Version .. ")") ;
  Selectiondialog:AddLabelField("Selection.Alert", "")
  local x1 = true
  for _, value in pairs(ClientList) do
      if x1 then
        Selectiondialog:AddDropDownList("Selection.Client", value)
        Selectiondialog:AddDropDownListValue("Selection.Client", value)
        Client.Name = value
        x1 = false
      else
        Selectiondialog:AddDropDownListValue("Selection.Client", value)
      end
  end
  Selectiondialog:AddDropDownList("Selection.Project", "---")
  Selectiondialog:AddDropDownList("Selection.Room", "---")

  if not Selectiondialog:ShowDialog() then
     DialogWindow.SelectionXY  = tostring(Selectiondialog.WindowWidth) .. " x " ..  tostring(Selectiondialog.WindowHeight)
     REG_WriteRegistry()
    return false
  else
     DialogWindow.SelectionXY  = tostring(Selectiondialog.WindowWidth) .. " x " ..  tostring(Selectiondialog.WindowHeight)
     REG_WriteRegistry()
    return true
  end
end
-- ====================================================]]
function Proper(str)
    local str=string.gsub(string.lower(str),"^(%w)", string.upper)
    return string.gsub(str,"([^%w]%w)", string.upper)
  end
-- ====================================================]]
function INI_ReadsGroups(xFile)
--[[Reads INI and returns a list containg the [Headers] as Array
IniFile = {} Global variables
xPath = script_path
]]
  local fileR = io.open(xFile)
  local xLine =""
  for Line in fileR:lines() do
    xLine = Proper(Line)
    if "[" == string.sub(All_Trim(xLine), 1, 1) then
      xLine = string.sub(xLine, 2, (string.len(xLine) - 1))
      table.insert (ClientList, xLine)
    end
  end
  fileR:close()
  return true
end
-- ====================================================]]
function INI_ReadProjects(xFile)
--[[Reads INI and returns a list containg the [Headers] as Array
IniFile = {} Global variables
xPath = script_path
]]
  local fileR = io.open(xFile)
  local xLine =""
  for Line in fileR:lines() do
    xLine = Line
    if "[" == string.sub(All_Trim(xLine), 1, 1) then
      xLine = string.sub(xLine, 2, (string.len(xLine) - 1))
      table.insert (ProjectList, xLine)
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
    xLine = Line
    if string.sub(xLine, 1, 9) == "data_path" then
        Project.Path = INI_StrValue(xLine, "S")
    end
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
 --[[ function REG_ReadRegistry()
    -- Read from Registry values
    -- ===REG_ReadRegistry()===
    local RegistryRead = Registry("DoorMaker")
    local Yes_No = RegistryRead:GetBool("BaseDim.Yes_No", ture)
    local CabHeight = RegistryRead:GetDouble("BaseDim.CabHeight", 35.500)
    local CabCount = RegistryRead:GetInt("BaseDim.CabCount", 36)
    local Name = RegistryRead:GetString("BaseDim.Name", "Words")
  end --function end
-- =====================================================]]
  function REG_WriteRegistry()
    -- Writes Values to Registry
    local RegistryWrite = Registry("DoorMaker")
    local RegValue = RegistryWrite:SetString("DialogWindow.ClientXY", DialogWindow.ClientXY)
          RegValue = RegistryWrite:SetString("DialogWindow.MainXY", DialogWindow.MainXY)
          RegValue = RegistryWrite:SetString("DialogWindow.MainNewXY", DialogWindow.MainNewXY)
          RegValue = RegistryWrite:SetString("DialogWindow.SelectionXY", DialogWindow.SelectionXY)

    --[[local RegValue = RegistryWrite:SetBool("ProjectQuestion.CabinetName", true)
          RegValue = RegistryWrite:SetDouble("DialogWindow.CabDepth", 23.0000)
          RegValue = RegistryWrite:SetInt("BaseDim.CabHeight", 35)
          RegValue = RegistryWrite:SetString("DialogWindow.InquiryXY", DialogWindow.InquiryXY)]]
  end --function end
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
    HTML()
    Client.xFile = "Clients"
    Client.xPath = script_path
    Client.FullPath = script_path .. "\\" .. "Clients.ini"
    VersionDate = StartDate(true)
    INI_ReadClients(Client.FullPath)
    -- InquirySelection("Client List")
    -- InquiryRoomSelecter()
    --InquiryMain()
    -- InquirySelection()
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