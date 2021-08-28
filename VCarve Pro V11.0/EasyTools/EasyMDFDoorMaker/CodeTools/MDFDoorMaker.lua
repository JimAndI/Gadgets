-- VECTRIC LUA SCRIPT
--[[
-- ========================================================================================================================
--  Gadgets are an entirely optional add-in to Vectric's core software products.
--  They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
--  In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
--  Permission is granted to anyone to use this software for any purpose,
--  including commercial applications, and to alter it and redistribute it freely,
--  subject to the following restrictions:
--  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--  If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
--  2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--  3. This notice may not be removed or altered from any source distribution.
--  MDF Door Maker is written by Jim Anderson of Houston Texas 2020
-- ========================================================================================================================

MDF Door Maker Gadget was written by Steven Godding & Jim Anderson 2021
-- Version Beta A - June 9, 2021

-- ====================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"

local YearNumber    = os.date("%Y")
local VerNumber     = "Beta A"
local AppName       = "MDF Door Maker"
local RegName       = "MDFDoorMaker"
--  Table Names
local Client        = {}
local Project       = {}
local Room          = {}
local Door          = {}
local DialogWindow  = {}   -- Dialog Management
local layer
Project.LoadDate = StartDate(false)
-- ====================================================]]
function IfT(x)                                         --  Converts True and False to Yes or No
  if x then
    return "Yes"
  else
    return "No"
  end
end
-- ====================================================]]
function IfY(x)                                          -- Converts Yes and No to True or False
  if x == "Yes" then
    return true
  else
    return false
  end
end
-- ====================================================]]
function StrIniValue(str, ty)
    if nil == str then
        DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
    else
        if "" == All_Trim(str) then
            DisplayMessageBox("Error in Ini file - looking for a " .. ty .. " value")
        else
            local j = (string.find(str, "=") + 1)
            if ty == "N" then ;
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
function ReadsGroups(xFile, aName)
  --[[Reads INI and returns a list containg the [Headers] as Array
      IniFile = {} Global variables
      xPath = script_path
   ]]
    local filename = xFile
    local file = io.open(filename, "r")
    local fLength = (LengthOfFile(filename) - 1)
    local dat = All_Trim(file:read())
    while (fLength >= 1) do
        if "[" == string.sub(dat, 1, 1) then
            table.insert (aName, string.upper(string.sub(dat, 2, (string.len(dat) - 1))))
        end
        dat = file:read()
        if dat then
            dat = All_Trim(dat)
        else
            return true
        end
        fLength = fLength - 1
    end
    return true
  end
-- ====================================================]]
function AddNewClient(xFile)                            -- Appends a New Client to the Clients.ini
    local filename = xFile
    local file = io.open(filename, "a")
    file:write("[" .. string.upper(All_Trim(Client.Name)) .. "] \n") ;
    file:write("load_data = " .. StartDate(true) ..   " \n") ;
    file:write("contact = "   .. Client.Contact ..    " \n") ;
    file:write("address = "   .. Client.Address ..    " \n") ;
    file:write("city = "      .. Client.City ..       " \n") ;
    file:write("state = "     .. Client.State ..      " \n") ;
    file:write("zip = "       .. Client.Zip ..        " \n") ;
    file:write("phone = "     .. Client.Phone ..      " \n") ;
    file:write("email = "     .. Client.Email ..      " \n") ;
    file:write("#====================================== \n") ;
    file:close()-- closes the open file
    return true
  end
  -- ==================================================]]
function AddNewProject(xFile)                           -- Appends a New Project to the ProjectList.ini
    local filename = xFile
    local file = io.open(filename, "a")
    file:write("[" .. string.upper(All_Trim(Project.Name)) .. "] \n") ;
    file:write("client_name = " .. StartDate(true) .. " \n") ;
    file:write("#====================================== \n") ;
    file:close()-- closes the open file
    return true
  end
  -- ==================================================]]
function AddNewRoom(xFile)                              -- Appends a New Room to the Rooms.ini
    local filename = xFile
    local file = io.open(filename, "a")
    file:write("[" .. string.upper(All_Trim(Room.Name)) .. "] \n") ;
    file:write("load_data = " .. StartDate(true) .. " \n") ;
    file:write("#====================================== \n") ;
    file:close()-- closes the open file
    return true
  end
  -- ==================================================]]
function AddNewDoor(xFile)                              -- Appends a New Door to the Doors.ini
    local filename = xFile
    local file = io.open(filename, "a")
    file:write("[" .. string.upper(All_Trim(Door.Name)) .. "] \n") ;
    file:write("load_data = " .. StartDate(true) .. " \n") ;
    file:write("#====================================== \n") ;
    file:close()-- closes the open file
    return true
  end
  -- ==================================================]]
function DrawBox(p1, p2, p3, p4, Layer)                 -- Draws a box
    local line = Contour(0.0)
    local layer = Milling.job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(p1) ;
    line:LineTo(p2);
    line:LineTo(p3) ;
    line:LineTo(p4);
    line:LineTo(p1);
    layer:AddObject(CreateCadContour(line), true)
    return true
  end -- function end
-- ====================================================]]
function UpdateItem(xPath, xFile, xGroup,  xItem, xValue)
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
            txt = xItem .. "=" .. xValue
            groups = false
         end -- if end
      end -- if end
      fileW:write(txt .. "\n") ;
   end -- for end
   os.remove(OfileName)
   fileR:close() ;
   fileW:close() ;
   return true
 end -- function end
-- ====================================================]]
function All_Trim(s)                                    -- Trims spaces off both ends of a string
 return s:match( "^%s*(.-)%s*$" )
end -- function end
-- ====================================================]]
function MakeFolder(xPath)
    os.execute( "mkdir  " .. xPath)
  return true
end
-- ====================================================]]
function DeleteGroup(xPath, xFile, xGroup)
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
   -- =================================================]]
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
      fileW:write(txt .. "\n") ;
    end -- if end
  end -- for end
   os.remove(OfileName)
   fileR:close() ;
   fileW:close() ;
   return true
 end -- function end
-- ====================================================]]
function LengthOfFile(filename)                         -- Returns file line count
 -- Counts the lines in a file
 -- Returns: number
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
-- ====================================================]]
function Registry_Read()                                -- Read from Registry values
  local RegistryRead            = Registry(RegName)
  DialogWindow.AboutXY          = RegistryRead:GetString("DialogWindow.AboutXY",         "0")
  DialogWindow.ProjectDesignXY  = RegistryRead:GetString("DialogWindow.ProjectDesignXY", "0")
  DialogWindow.ProjectSetupXY   = RegistryRead:GetString("DialogWindow.ProjectSetupXY",  "0")
  DialogWindow.DefaultsXY       = RegistryRead:GetString("DialogWindow.DefaultsXY",      "0")
  DialogWindow.MainXY           = RegistryRead:GetString("DialogWindow.MainXY",          "0")
  DialogWindow.ProjectXY        = RegistryRead:GetString("DialogWindow.ProjectXY",       "0")
  DialogWindow.WallCabinetXY    = RegistryRead:GetString("DialogWindow.WallCabinetXY",   "0")
  Project.ClientAddress         = RegistryRead:GetString("Project.ClientAddress",         "1234 Project Blvd.")
  Project.ProgramCodeBy         = RegistryRead:GetString("Project.ProgramCodeBy",        "Steven Godding & Jim Anderson")
  Project.ProgramName           = RegistryRead:GetString("Project.ProgramName",          "MDF Door Maker")
  Project.ProgramVersion        = RegistryRead:GetString("Project.ProgramVersion",       VerNumber)
  Project.LoadDate              = RegistryRead:GetString("Project.LoadDate",             Project.LoadDate)
  Project.ClientEmail           = RegistryRead:GetString("Project.ClientEmail",           "Default@Email.com")
  Project.ClientName            = RegistryRead:GetString("Project.ClientName",            "Clients Name")
  Project.ContactPhoneNumber    = RegistryRead:GetString("Project.ContactPhoneNumber",   "(123)456-7890")
  Project.ProjectName           = RegistryRead:GetString("Project.ProjectName",          "C:\User")
  Project.ProjectPath           = RegistryRead:GetString("Project.ProjectPath",          "Default")
  return true
end
-- ====================================================]]
function Registry_Update()                              -- Write to Registry values
    local RW = Registry(RegName)
    local RegValue = RW:SetString("BaseQuestion.DadoStyle",            BaseQuestion.DadoStyle)
          RegValue = RW:SetString("DialogWindow.AboutXY",              DialogWindow.AboutXY)
          RegValue = RW:SetString("DialogWindow.InquiryWallOrBaseXY",  DialogWindow.InquiryWallOrBaseXY)
          RegValue = RW:SetString("DialogWindow.LayerXY",              DialogWindow.LayerXY)
          RegValue = RW:SetString("DialogWindow.MillingXY",            DialogWindow.MillingXY)
          RegValue = RW:SetString("DialogWindow.ProjectXY",            DialogWindow.ProjectXY)
          RegValue = RW:SetString("DialogWindow.WallCabinetXY",        DialogWindow.WallCabinetXY)
          RegValue = RW:SetString("Project.CabinetName",               Project.CabinetName)
          RegValue = RW:SetString("Project.Drawing",                   Project.Drawing )
          RegValue = RW:SetString("Project.ProgramCodeBy",             Project.ProgramCodeBy)
          RegValue = RW:SetString("Project.ProgramName",               Project.ProgramName)
          RegValue = RW:SetString("Project.ProgramVersion",            Project.ProgramVersion)
          RegValue = RW:SetString("Project.ProgramYear",               Project.ProgramYear)
          RegValue = RW:SetString("Project.ContactEmail",       Project.ProjectContactEmail)
          RegValue = RW:SetString("Project.ClientName",         Project.ProjectContactName)
          RegValue = RW:SetString("Project.ContactPhoneNumber", Project.ProjectContactPhoneNumber)
          RegValue = RW:SetString("Project.ProjectName",               Project.ProjectName)
          RegValue = RW:SetString("Project.ProjectName",  string.upper(Project.ProjectName))
          RegValue = RW:SetString("Project.ProjectPath",               Project.ProjectPath)

end
-- ====================================================]]
function StartDateTime(LongShort)
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
    return os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p")
  else
    return os.date("%Y%m%d%H%M")
  end
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
function Polar2D(pt, ang, dis)
  local ang1 = ang + Material.Direction
  return Point2D((pt.X + dis * math.cos(math.rad(ang1))), (pt.Y + dis * math.sin(math.rad(ang1))))
end
-- ====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 720, 487, "About")
  dialog:AddLabelField("SysName", AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  REG_UpdateRegistry()
  return  true
end
-- ====================================================]]
function HTML()
-- ====================================================]] -- Style
DialogWindow.Style = [[<style>html{overflow:hidden}.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap;background-color:#696969;color:#FFF}.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px;background-color:#630;color:#FFF}.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}.ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;width:50px;background-color:#630;color:#FFF}.TableSizeMax{border:0;width:100%}.TableSize600{width:600px;border:0}.PathTableSize600{width:600px;border:0}.PathColumn1{width:50px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.PathColumn2{width:300px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.PathColumn3{width:30px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootTableSize600{width:690px;border:0}.FootColumn1{width:45px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn2{width:300px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.FootColumn3{width:25px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn4{width:25px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.Column1{width:100px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.Column2{width:30px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.Column3{width:250px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.alert-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#FFF;text-align:center;white-space:nowrap}.alert-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-shadow:5px 5px 10px #FFF;color:#FF0101;text-align:left;white-space:nowrap}.alert-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}.error{font-family:Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#F00;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorTable{background-color:#FFF;white-space:nowrap}.p1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;color:#000}.p1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;color:#000}.p1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;color:#000}.ver-c{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap;color:#ffd9b3}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;color:#000}.h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px;color:#000}.h2-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:left;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:center;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#000;text-align:right;white-space:nowrap;text-shadow:2px 2px white;color:#8E8D8A}.h3-bc{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h3{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.webLink-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;background-color:yellow;text-align:center;white-space:nowrap}.jsbutton{background-color:#630;border:2px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:1px 1px;color:#FFF}.jsTag-no-vis{font-family:Arial,Helvetica,sans-serif;font-size:10px;display:none;text-align:center;color:#00F;visibility:hidden}body{background-color:#EAE7DC;background-position:center;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#8E8D8A;} html{overflow:hidden}</style>]]
  DialogWindow.myHtml6 = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"><tr><td align="center" nowrap="nowrap" class="header1-c" id="SysName">MDF Door Maker</td></tr><tr><td align="center" nowrap="nowrap" class="h2" id="Version"><span class="h1-c">Version</span></td></tr><tr><td align="center" nowrap="nowrap"><hr></td></tr><tr><td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td></tr><tr><td align="center" class="p1-l"><p class="p1-l">The ]] .. AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br><br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br><br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td></tr><tr><td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td></tr><tr><td align="center" ><span class="header2-c">James Anderson</span></td></tr><tr><td align="center"><span class="h1-c">Houston, TX.</span></td></tr><tr><td><hr></td></tr><tr><td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td></tr></table></body>]]
-- ====================================================]] -- Name
  return true
end -- function end

-- ====================================================]]
function main()
  Project.job = VectricJob()
  if not Project.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end
  Project.MaterialBlock          = MaterialBlock()
  Project.MaterialBlockThickness = Project.MaterialBlock.Thickness
  --local units
  if Project.MaterialBlock.InMM then
    Project.Units = "mm"
    Project.Unit  = true
  else
    Project.Units = "inch"
    Project.Unit  = false
  end
  Project.UnitDisplay  = "Note: Units: (" .. Project.Units ..")"
  GetMaterialSettings()
  REG_ReadRegistry()
  HTML()  -- Load the Dialog data


  Project.job:Refresh2DView()
  return true
end -- function end

-- ====================================================]]
