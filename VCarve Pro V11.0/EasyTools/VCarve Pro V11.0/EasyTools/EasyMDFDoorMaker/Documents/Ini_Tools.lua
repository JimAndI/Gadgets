-- ===========]]
function All_Trim(s) -- Trims spaces off both ends of a string
 return s:match( "^%s*(.-)%s*$" )
end -- function end
-- ===========]]
local function LengthOfFile(filename)                         -- Returns file line count
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
-- ===========]]
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


-- GetIniValue(xPath, FileName, GroupName, ItemName, ValueType)==
-- Returns a value from a file, group, and Item
-- ''Usage: XX.YY = GetIniValue(xPath, FileName, GroupName, "XX.YY", "N") ''
function GetIniValue(xPath, FileName, GroupName, ItemName, ValueType)
   local filenameR = xPath .. "/" .. FileName .. ".ini"
   local FL = LengthOfFile(filenameR)
   local file = io.open(filenameR, "r")
   local dat = "."
   local ItemNameLen = string.len(ItemName) ;
   while (FL >= 1) do
      dat = All_Trim(file:read()) ;
      if dat == "[" .. string.upper(GroupName) .. "]" then

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

-- NameStrip(str, var)==
-- Notes: Convert string to the correct data type
-- ''Usage: Local Words = NameStrip("KPSDFKSPSK - 34598923", "-") and will return "KPSDFKSPSK" ''

function NameStrip(str, var) -- convert string to the correct data type
   if "" == str then
      DisplayMessageBox("Error in string")
   else
      if string.find(str, var) then
          local j = assert(string.find(str, var) - 1)
          return All_Trim(string.sub(str, 1, j)) ;
      else
          return str
      end
   end
  end

-- ProjectHeaderReader(xPath)==
-- Gets the INI Header values of a ini file and uploads to "IniFile" Array
function ProjectHeaderReader(xPath)
  --[[
      Gets the INI Header values of a ini file and uploads to "IniFile" Array
      IniFile = {} Global variables
      xPath = script_path
   ]]
    local filename = xPath .. "/CabinetProjects.ini"
    local file = io.open(filename, "r")
    local Cabing = (LengthOfFile(filename) - 1)
    local dat = All_Trim(file:read())
    while (Cabing >= 1) do
        if "[" == string.sub(dat, 1, 1) then
            table.insert (Projects, string.upper(string.sub(dat, 2, (string.len(dat) - 1))))
        end
        dat = file:read()
        if dat then
            dat = All_Trim(dat)
        else
            return true
        end
        Cabing = Cabing - 1
    end
    return true
  end

-- AddNewProject(xPath)==
-- Appends a New Project to CabinetProjectQuestion.ini
function AddNewProject(xPath)-- Appends a New Project to CabinetProjectQuestion.ini
    local filename = xPath .. "/CabinetProjects.ini"
    local file = io.open(filename, "a")
    file:write("[" .. string.upper(All_Trim(ProjectQuestion.ProjectName)) .. "] \n") ;
    file:write("ProjectQuestion.ProjectPath = " .. ProjectQuestion.ProjectPath .. " \n") ;
    file:write("ProjectQuestion.StartDate = " .. ProjectQuestion.StartDate .. " \n") ;
    file:write("ProjectQuestion.ProjectContactName = " .. ProjectQuestion.ProjectContactName .. " \n") ;
    file:write("ProjectQuestion.ProjectContactEmail = " .. ProjectQuestion.ProjectContactEmail .. " \n") ;
    file:write("ProjectQuestion.ProjectContactPhoneNumber = " .. ProjectQuestion.ProjectContactPhoneNumber .. " \n") ;
    file:write("ProjectQuestion.ProjectName = " .. string.upper(ProjectQuestion.ProjectName) .. " \n") ;
    file:write("#====================================== \n") ;
    file:close()-- closes the open file
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
-- StdHeaderReader(xPath, Fname)==
-- Gets the INI Header values of a ini file and uploads to "IniFile" Array

function ReadHeaders(xPath, Fname)
 --[[
      Reads INI file for Header values and uploads to "IniFile" Array
      IniFile = {} Global variables
      xPath = script_path
   ]]
    local filename = xPath .. "/" .. Fname .. ".ini"
    local file = io.open(filename, "r")
    local WallMilling = (LengthOfFile(filename) - 1)
    local dat = All_Trim(file:read())
    while (WallMilling >= 0) do
       if "[" == string.sub(dat, 1, 1) then
           table.insert (IniFile, string.upper(string.sub(dat, 2, (string.len(dat) - 1))))
       end -- if end
       dat = file:read()
       if dat then
           dat = All_Trim(dat)
       else
           return true
       end -- if end
       WallMilling = WallMilling - 1
    end -- while end
    file:close() ;
    return true
  end  -- function end

-- ReadProjectinfo(xPath, xGroup, xFile)==
-- Reads an ini files group and sets the table.names

function ReadProjectinfo(xPath, xGroup, xFile)
 -- ProjectQuestion = {}
   ProjectQuestion.ProjectContactEmail       = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactEmail", "S")
   ProjectQuestion.ProjectContactName        = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactName", "S")
   ProjectQuestion.ProjectContactPhoneNumber = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactPhoneNumber", "S")
   ProjectQuestion.ProjectName               = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectName", "S")
   ProjectQuestion.ProjectPath               = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectPath", "S")
   ProjectQuestion.StartDate                 = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.StartDate", "S")
 end

-- IniUpdateFile(xPath, xGroup, xFile, xItem, xValue)==
-- Updates values in a ini file

function IniUpdateFile(xPath, xGroup, xFile, xItem, xValue)
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
 end -- function end

-- ReadINIProject(xPath, xFile, xGroup)==

function ReadINIProject(xPath, xFile, xGroup)
    -- Milling = {}
    Milling.LayerNameBackPocket          = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameBackPocket", "S")
    Milling.LayerNameTopBottomCenterDado = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameTopBottomCenterDado", "S")
    Milling.LayerNameDrawNotes           = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawNotes", "S")
    Milling.LayerNameDrawFaceFrame       = GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawFaceFrame", "S")
    Milling.BackPocketDepthWall          = GetIniValue(xPath, xFile, xGroup, "Milling.BackPocketDepthWall", "N")
    Milling.BlindDadoSetbackWall         = GetIniValue(xPath, xFile, xGroup, "Milling.BlindDadoSetbackWall", "N")
    Milling.CabDepthWall                 = GetIniValue(xPath, xFile, xGroup, "Milling.CabDepthWall", "N")
    return true
  end