-- VECTRIC LUA SCRIPT
require "strict"
--  Go Here.

--[[ 
    mylist = "\"New\",\"Obj\",\"Name\",\"Program\",\"Title\""  -- String
    days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"} -- Array
    work = {}  -- table
    work.a = day
    work.b = mylist
]]    
    g_boxHight = 0.0000
    g_boxLength = 0.0000
    g_boxDepth = 0.0000
    g_backHight = 0.0000
    g_backWidth = 0.0000
    g_pt1 = Point2D(2,2)
-- ==============================================================================
    IniFile = {} 
    Global = {}
    Global.ProgramTitle = "Wall Cabinet Creator"
    Global.ProgramName = "Wall-Cabinet"
    Global.ProgramVersion = "Version 1.1"
    Global.CodeBy = "James Anderson"
    Global.Contact = "James.L.Anderson@outlook.com"
    Global.Year = "2018"
    Global.JobPath = "G://Tester"

    Milling = {} 
    Milling.MillClearnace = 0.010 -- can be + or - number, used for dato over sizing
    Milling.ToolNameLabel = "No Tool Selected" 
    Milling.ToolSizeDia = 0.25
    Milling.ToolSizeRadus = 0.125 
    Milling.RabbitClearnace = 0.050
    Milling.Tool = 0.0
    
    StandardCabs = {} 
    StandardCabs.Name  = "None"  
    StandardCabs.New  = false

    Wall = {} -- Wall Cabinet
    Wall.ThicknessBack = 0.5000
    Wall.CabLength = 36.0000
    Wall.CabHeight = 28.0000
    Wall.CabDepth = 12.0000
    Wall.Thickness = 0.750
    Wall.DatoSetback =  1.375
    Wall.DatoDeep =  0.375
    Wall.DatoType = "Through"           -- Half, Full, or Through
    Wall.AddFaceFrame = true
    Wall.AddShelf = true
    Wall.AddCenterFaceFrame = true
    Wall.AddCenterPanel = true           -- Insert Panel in Cabinet
    Wall.AddBackNailer = true
    Wall.NailerThickness = 0.500
    Wall.NailerWidth = 3.500

    FaceFrame = {} -- FaceFrame
    FaceFrame.FFThickness = 0.7500
    FaceFrame.StileWidth = 2.25
    FaceFrame.BottomRailWidth = 1.25
    FaceFrame.TopRailWidth = 1.75
    FaceFrame.CenterStileWidth = 1.7500
    FaceFrame.StileLength = 0.0000
    FaceFrame.RailLength = 0.0000
    FaceFrame.CenterStileLength = 0.0000   
    FaceFrame.FFReveal = 0.25
    FaceFrame.BottomFFReveal = 0.0625 
    FaceFrame.TopOverlap = 0.7500

    Drawing = {}
    Drawing.DrawFaceFrame = true
    Drawing.DrawBack = true
    Drawing.DrawSideR = true
    Drawing.DrawSideL = true
    Drawing.DrawTop = true
    Drawing.DrawBottom = true
    Drawing.DrawCenter = true 
    Drawing.DrawNotes = true  
    Drawing.DrawShelf = true
 
    Shelf = {}
    Shelf.WidthClearance = 0.25
    Shelf.FaceFrameWidth = 1.500
    Shelf.FaceFrameThickness = 0.7500
    Shelf.EndClarence = 0.1800
    Shelf.PinDiameter = 0.194
    Shelf.PinRadus = 0.0970
    Shelf.Count = 2.0
    Shelf.PartThickness = 0.7500
    Shelf.PartLength = 30.0000
    Shelf.PartDepth = 10.0000
    Shelf.PinOuter = 0.7000
    Shelf.PinInter = 0.1600
    Shelf.FaceFrameReveal = 0.0625
    Shelf.HoleSpacing = 2.0000
    Shelf.HoleFirstRowSpacing = 4.0000
    Shelf.HoleLastRowSpacing = 3.0000 
    
-- ==============================================================================
function StrIniValue(str, ty) -- convert string to the correct data type
--    DisplayMessageBox("<> " .. str)
    local j = (string.find(str, "=") + 1)
--    DisplayMessageBox(string.sub(str, j))
    if ty == "N" then ;  return tonumber(string.sub(str, j)); end
    if ty == "S" then ;  return string.sub(str, j);  end
    if ty == "B" then ;  
       if "TRUE" == string.upper(string.sub(str, j)) then ;  
          return true ;  
        else ;  
          return false ; 
       end
    end
    return nil
end
-- ==============================================================================
function StdLoader(Pxather, SectionName) 
    local filename = Pxather .. "/WallCab.ini"
    local file = io.open(filename, "r")
    local dat = "."
    local Name =  "[" .. SectionName .. "]"
    repeat
      dat = all_trim(file:read())
    until dat == Name
    Wall.ThicknessBack =  StrIniValue(all_trim(file:read()) , "N") 
    Wall.Thickness =  StrIniValue(all_trim(file:read()) , "N") 
    Wall.CabLength =   StrIniValue(all_trim(file:read()) , "N")
    Wall.CabHeight =   StrIniValue(all_trim(file:read()) , "N")
    Wall.CabDepth =  StrIniValue(all_trim(file:read()) , "N")
    Wall.DatoDeep =   StrIniValue(all_trim(file:read()) , "N")
    Wall.DatoType =   StrIniValue(all_trim(file:read()) , "S")
    Wall.AddFaceFrame =   StrIniValue(all_trim(file:read()) , "B")
    Wall.AddShelf =   StrIniValue(all_trim(file:read()) , "B")
    Wall.AddCenterFaceFrame =   StrIniValue(all_trim(file:read()) , "B")
    Wall.AddCenterPanel =   StrIniValue(all_trim(file:read()) , "B")
    Wall.AddBackNailer =   StrIniValue(all_trim(file:read()) , "B")
    Wall.NailerThickness =   StrIniValue(all_trim(file:read()) , "N")
    Wall.NailerWidth =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.EndClarence =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.PinDiameter =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.PinRadus =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.Count =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.FaceFrameReveal =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.WidthClearance =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.FaceFrameWidth =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.FaceFrameThickness =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.PinOuter =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.PinInter =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.HoleSpacing =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.HoleFirstRowSpacing =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.HoleLastRowSpacing =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.PartLength =   StrIniValue(all_trim(file:read()) , "N")
    Shelf.PartDepth =  StrIniValue(all_trim(file:read()) , "N")
    Shelf.PartThickness =   StrIniValue(all_trim(file:read()) , "N")
    Milling.MillClearnace =   StrIniValue(all_trim(file:read()) , "N")
    Milling.ToolNameLabel =   StrIniValue(all_trim(file:read()) , "S")
    Milling.ToolSizeDia =   StrIniValue(all_trim(file:read()) , "N")
    Milling.ToolSizeRadus =   StrIniValue(all_trim(file:read()) , "N")
    Milling.RabbitClearnace =   StrIniValue(all_trim(file:read()) , "N")
    Global.ProgramTitle =   StrIniValue(all_trim(file:read()) , "S")
    Global.ProgramVersion =   StrIniValue(all_trim(file:read()) , "S")
    Global.CodeBy =    StrIniValue(all_trim(file:read()) , "S")
    Global.JobPath =   StrIniValue(all_trim(file:read()) , "S")
    Global.ProgramName =   StrIniValue(all_trim(file:read()) , "S")
    Global.Contact =   StrIniValue(all_trim(file:read()) , "S")
    Global.Year =   StrIniValue(all_trim(file:read()) , "S") 
    Drawing.DrawFaceFrame =    StrIniValue(all_trim(file:read()) , "B")    
    Drawing.DrawBack =    StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawSideR =   StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawSideL =   StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawTop =   StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawBottom =   StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawCenter =   StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawNotes =   StrIniValue(all_trim(file:read()) , "B")
    Drawing.DrawShelf =   StrIniValue(all_trim(file:read()) , "B")
    FaceFrame.FFReveal =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.FFThickness =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.StileWidth =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.BottomRailWidth =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.TopRailWidth =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.CenterStileWidth =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.BottomFFReveal =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.TopOverlap =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.StileLength =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.RailLength =   StrIniValue(all_trim(file:read()) , "N")
    FaceFrame.CenterStileLength =   StrIniValue(all_trim(file:read()) , "N")
    file:close()-- closes the open file
      return true
end
-- ==============================================================================
function InquiryDropList(Header, Quest, DList)
--[[
    Drop list foe user input
    Caller = local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", IniFile)
    Dialog Header = "Cabinet Maker"
    User Question = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = String
]]
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd"><html><head><meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"><title>Cabinet Maker and Tool-path Creator</title><style type="text/css">html {overflow: auto;}HoleFirstRowSpacing body {background-color: #D7E4F2;}.ToolPicker {width: 69px;}body, td, th {font-family: Arial, Helvetica, sans-serif;font-size: 10px;color: #000;}.FormButton {font-weight: bold;width: 100%;font-family: Arial, Helvetica, sans-serif;font-size: 12px;}.h1 {font-size: 14px; font-weight: bold;}.h2 {font-size: 10px;font-weight: bold;}.ToolNameLabel {color: #555;}</style></head><body><table width="150" border="0" cellpadding="0"><tr><td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" id="Questions"><strong>Message Here</strong></td></tr><tr><th width="33%" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID">&nbsp;</th><th width="147" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact"><select name="ListBox" size="10" id="ListBox"><option>Defalt</option></select></th><th width="33%" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact">&nbsp;</th></tr><tr><td colspan="3" align="center" valign="middle"><table border="0" width="100%"><tr align="right"><td style="width: 25%">&nbsp;</td><td style="width: 25%"><span style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></span></td><td style="width: 25%"><span style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></span></td><td style="width: 25%">&nbsp;</td></tr></table></td></tr></table></body></html>]]
    local dialog = HTML_Dialog(true, myHtml, 180, 150, Header)
    dialog:AddLabelField("Questions", Quest)
    dialog:AddDropDownList("ListBox", "Default")
    dialog:AddDropDownListValue("ListBox", "Default")
    for index, value in pairs(DList) do
        dialog:AddDropDownListValue("ListBox", value)
    end
    if not dialog:ShowDialog() then
        return ""
    else
        return dialog:GetDropDownListValue("ListBox")
	end    
end
-- ==============================================================================
function InquiryTextBox(Header, Quest, Defaltxt)
--[[
    TaxtBox for user input with default value
    Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[ <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"><title>Cabinet Maker and Tool-path Creator</title> <style type="text/css">  html {overflow: auto;} body { background-color: #FFFFFF; }body, td, th {font-family: Arial, Helvetica, sans-serif;font-size: 12px; color: #000;} .FormButton {font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px;}</style></head><body><table width="470" border="0" cellpadding="0"><tr><td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" id="Questions">0.0<strong>0.0Message Here</strong></td></tr><tr><th width="48" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID">&nbsp;</th><th width="416" colspan="2" align="left" valign="middle"><input name="qInput" type="text" id="qInput" size="65"></th></tr><tr><td colspan="3" align="center" valign="middle"><table border="0" width="100%"><tr align="right"><td style="width: 20%">&nbsp;</td><td style="width: 20%">&nbsp;</td><td style="width: 25%">&nbsp;</td><td style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td><td style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td></tr></table></td></tr></table></body></html>]]
    local dialog = HTML_Dialog(true, myHtml, 525, 160, Header)
    dialog:AddLabelField("Questions", Quest)
    dialog:AddTextField("qInput", Defaltxt)
    if not dialog:ShowDialog() then
        return ""
    else
        return dialog:GetTextField("qInput")
	end    
end
-- ==============================================================================
function InquiryPathBox(Header, Quest, Defaltxt)
--[[
    TaxtBox for user input with default value
    Caller: local z = InquiryPathBox("Cabinet Maker", "Job Path", Global.JobPath)
    DisplayMessageBox(z) 
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type="text/css"> html {overflow: auto; } HoleFirstRowSpacing body {background-color: #D7E4F2; } .ToolPicker {  width: 69px;} body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton {font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 10px; font-weight: bold; } .ToolNameLabel { color: #555; } </style> </head> <body> <table width="470" border="0" cellpadding="0"> <tr> <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" id="Questions">0.0<strong>0.0Message Here</strong></td> </tr> <tr> <th width="48" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID"><input id="DirectoryPicker" class="DirectoryPicker" name="DirectoryPicker" type="button" value="Path..."></th> <th width="416" colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact"><input name="DInput" type="text" id="DInput" size="65"></th></tr> <tr> <td colspan="3" align="center" valign="middle"><table border="0" width="100%"> <tr align="right"> <td style="width: 20%">&nbsp;</td> <td style="width: 20%">&nbsp;</td> <td style="width: 25%">&nbsp;</td> <td style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> <td style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> </tr> </table></td> </tr> </table> </body> </html> ]]
    local dialog = HTML_Dialog(true, myHtml, 525, 160, Header)
    dialog:AddLabelField("Questions", Quest)
    dialog:AddTextField("DInput", Defaltxt)
    dialog:AddDirectoryPicker("DirectoryPicker",  "DInput", true);
    if not dialog:ShowDialog() then
        return ""
    else
        return dialog:GetTextField("DInput")
    end    
end
-- ==============================================================================
function SaveRegistry(RegistryName, ObjName, Val)
    local RegistryWrite = Registry(RegistryName)
    RegistryWrite:SetString(ObjName, Val) 
    return true 
end  -- function end  
-- ==============================================================================
function ReadRegistry(RegistryName, ObjName)
    local RegistryRead = Registry(RegistryName)
    local Val = RegistryRead:GetString(ObjName, "")
    return Val 
end  -- function end  
-- ==============================================================================
-- The function looks like table.concat(yourArray, "delimiter") so:
-- table.concat({ "one", "two", "three", "four", "five" }, ",") will produce a string "one,two,three,four,five"
-- Assuming we pass in the array to our saveData() function, it will look like:
-- ==============================================================================  
function Array2String(mArray)
    local saveString = table.concat(mArray, ",")
    saveGlobalData("dataKey", saveString)
end
-- ==============================================================================
function explode(div, str) 
    if (div=='') then return false end
    local pos,arr = 0,{}
    -- for each divider found
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
        pos = sp + 1 -- Jump past current divider
    end
    table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
    return arr
end
-- ==============================================================================   
-- Using the above function the loadData() function is trivial, and will return your original array:
-- ==============================================================================
function BuildCircle(pt1, rad)
    local line = Contour(0.0)
    -- DisplayMessageBox(tostring(rad))
    line:AppendPoint(Polar2D(pt1, 0, rad))    
    line:ArcTo(Polar2D(pt1, 180, rad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, rad), 1.0)   
    
    return line
end -- function end 
-- ==============================================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end  -- function end
-- ==============================================================================
function BtoS(x)
--[[
    Converts a boolean to a string
    Returns = String
]]
    local Z = ""
    if x then
        Z = "true"
    else
        Z = "false"
    end
    return Z
end
-- ==============================================================================
function StdFileWriter(Pxather, Names) 
--[[
    Adds Standard Upper Wall Cabinet to the INI file 
    Pxather = script_path
    Names  =  Group Name
    Returns = true
]]
    local file = io.open(Pxather .. "/WallCab.ini", "a")
    file:write("#======================================================================\n")
    file:write("# Standard Upper Wall Cabinet Configuration Data\n")
    file:write("#======================================================================\n")
    file:write("[" .. Names .. "]\n")
    file:write("Wall.ThicknessBack="..          Wall.ThicknessBack   .."   \n")
    file:write("Wall.Thickness="..              Wall.Thickness   .."   \n")
    file:write("Wall.CabLength="..              Wall.CabLength   .."   \n")
    file:write("Wall.CabHeight="..              Wall.CabHeight   .."   \n")
    file:write("Wall.CabDepth="..               Wall.CabDepth   .."   \n")
    file:write("Wall.DatoDeep="..               Wall.DatoDeep   .."   \n")
    file:write("Wall.DatoType="..               Wall.DatoType   .."   \n")
    file:write("Wall.AddFaceFrame="..           BtoS(Wall.AddFaceFrame)   .."   \n")
    file:write("Wall.AddShelf="..               BtoS(Wall.AddShelf)   .."   \n")
    file:write("Wall.AddCenterFaceFrame="..     BtoS(Wall.AddCenterFaceFrame)   .."   \n")
    file:write("Wall.AddCenterPanel="..         BtoS(Wall.AddCenterPanel)   .."   \n")
    file:write("Wall.AddBackNailer="..          BtoS(Wall.AddBackNailer)   .."   \n")
    file:write("Wall.NailerThickness="..        Wall.NailerThickness   .."   \n")
    file:write("Wall.NailerWidth="..            Wall.NailerWidth   .."   \n")        
    file:write("Shelf.EndClarence="..           Shelf.EndClarence   .."   \n")
    file:write("Shelf.PinDiameter="..           Shelf.PinDiameter   .."   \n")
    file:write("Shelf.PinRadus="..              Shelf.PinRadus   .."   \n")
    file:write("Shelf.Count="..                 Shelf.Count   .."   \n")
    file:write("Shelf.FaceFrameReveal="..       Shelf.FaceFrameReveal   .."   \n")
    file:write("Shelf.WidthClearance="..        Shelf.WidthClearance   .."   \n")
    file:write("Shelf.FaceFrameWidth="..        Shelf.FaceFrameWidth   .."   \n")
    file:write("Shelf.FaceFrameThickness="..    Shelf.FaceFrameThickness   .."   \n")
    file:write("Shelf.PinOuter="..              Shelf.PinOuter   .."   \n")
    file:write("Shelf.PinInter="..              Shelf.PinInter   .."   \n")
    file:write("Shelf.HoleSpacing="..           Shelf.HoleSpacing   .."   \n")
    file:write("Shelf.HoleFirstRowSpacing="..   Shelf.HoleFirstRowSpacing   .."   \n")
    file:write("Shelf.HoleLastRowSpacing="..    Shelf.HoleLastRowSpacing   .."   \n")
    file:write("Shelf.PartLength="..            Shelf.PartLength   .."   \n")
    file:write("Shelf.PartDepth="..             Shelf.PartDepth   .."   \n")
    file:write("Shelf.PartThickness="..         Shelf.PartThickness   .."   \n")        
    file:write("Milling.MillClearnace="..       Milling.MillClearnace .."   \n")
    file:write("Milling.ToolNameLabel="..       Milling.ToolNameLabel .."   \n")
    file:write("Milling.ToolSizeDia="..         Milling.ToolSizeDia .."   \n")
    file:write("Milling.ToolSizeRadus="..       Milling.ToolSizeRadus .."   \n")
    file:write("Milling.RabbitClearnace="..     Milling.RabbitClearnace .."   \n")
    file:write("Global.ProgramTitle="..         Global.ProgramTitle   .."   \n")
    file:write("Global.ProgramVersion="..       Global.ProgramVersion   .."   \n")
    file:write("Global.CodeBy="..               Global.CodeBy   .."   \n")
    file:write("Global.JobPath="..              Global.JobPath   .."   \n")
    file:write("Global.ProgramName="..          Global.ProgramName   .."   \n")
    file:write("Global.Contact="..              Global.Contact   .."   \n")
    file:write("Global.Year="..                 Global.Year   .."   \n") 
    file:write("Drawing.DrawFaceFrame="..       BtoS(Drawing.DrawFaceFrame)   .."   \n")
    file:write("Drawing.DrawBack="..            BtoS(Drawing.DrawBack)   .."   \n")
    file:write("Drawing.DrawSideR="..           BtoS(Drawing.DrawSideR)   .."   \n")
    file:write("Drawing.DrawSideL="..           BtoS(Drawing.DrawSideL)   .."   \n")
    file:write("Drawing.DrawTop="..             BtoS(Drawing.DrawTop)   .."   \n")
    file:write("Drawing.DrawBottom="..          BtoS(Drawing.DrawBottom)   .."   \n")
    file:write("Drawing.DrawCenter="..          BtoS(Drawing.DrawCenter)   .."   \n")
    file:write("Drawing.DrawNotes="..           BtoS(Drawing.DrawNotes)   .."   \n")
    file:write("Drawing.DrawShelf="..           BtoS(Drawing.DrawShelf)   .."   \n")
    file:write("FaceFrame.FFReveal="..          FaceFrame.FFReveal   .."   \n")
    file:write("FaceFrame.FFThickness="..       FaceFrame.FFThickness   .."   \n")
    file:write("FaceFrame.StileWidth="..        FaceFrame.StileWidth   .."   \n")
    file:write("FaceFrame.BottomRailWidth="..   FaceFrame.BottomRailWidth   .."   \n")
    file:write("FaceFrame.TopRailWidth="..      FaceFrame.TopRailWidth   .."   \n")
    file:write("FaceFrame.CenterStileWidth="..  FaceFrame.CenterStileWidth   .."   \n")
    file:write("FaceFrame.BottomFFReveal="..    FaceFrame.BottomFFReveal   .."   \n")
    file:write("FaceFrame.TopOverlap="..        FaceFrame.TopOverlap   .."   \n")
    file:write("FaceFrame.StileLength="..       FaceFrame.StileLength   .."   \n")
    file:write("FaceFrame.RailLength="..        FaceFrame.RailLength   .."   \n")
    file:write("FaceFrame.CenterStileLength=".. FaceFrame.CenterStileLength   .."   \n")
    file:write("Variables.g_boxHight="..        g_boxHight .."   \n")
    file:write("Variables.g_boxLength="..       g_boxLength  .."   \n")
    file:write("Variables.g_boxDepth="..        g_boxDepth .."   \n")
    file:write("Variables.g_backHight="..       g_backHight  .."   \n")
    file:write("Variables.g_backWidth="..       g_backWidth  .."   \n")
    file:close()-- closes the open file
    return true
end
-- ============================================================================== 
function all_trim(s)
    return s:match( "^%s*(.-)%s*$" )
end
-- ==============================================================================
function StdHeaderReader(Pxather) 
--[[
    Fills in INI Headers to "IniFile" Array 
    IniFile = {} Global variables
    Pxather = script_path
]]
    local filename = Pxather .. "/WallCab.ini"
    local file = io.open(filename, "r")
    local XX = (length_of_file(filename) - 1)
    local dat = all_trim(file:read())
    while (XX >= 0) 
    do
        if "[" == string.sub(dat, 1, 1) then
            table.insert (IniFile, string.sub(dat, 2, (string.len(dat) - 1))) 
        end       
        dat = file:read()
        if dat then
             dat = all_trim(dat)
          else
             return true 
        end
        XX = XX - 1
    end
    return true
end
-- ==============================================================================
function length_of_file(filename)
--[[
Counts the lines in a file
returns a number
]]
  local fh = assert(io.open(filename, "rb"))
  local len = assert(fh:seek("end"))
  fh:close()
  return len
end 
-- ==============================================================================
function loadData()
    local stringArray = readGlobalData("dataKey")
    return explode(",", stringArray)
end
-- ==============================================================================
function all_trim(s)
--[[
Trims spaces off both ends of a string
]]
   return s:match( "^%s*(.-)%s*$" )
end
-- ==============================================================================
function directory_exists(path)
--[[
print(directory_exists("C:\\Users")
print(directory_exists("C:\\ThisFolder\\IsNotHere"))

  local f  = io.popen("cd " .. path)
  local ff = f:read("*all")
  if (ff:find("ItemNotFoundException")) then
    return false
  else
    return true
  end  
  
  function is_dir(path)
]]
    local f = io.open(path, "r")
    local ok, err, code = f:read(1)
    f:close()
    return code == 21
-- end  
end
-- ==============================================================================
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
--[[ 
 
    SaveRegistry("CabinetMaker" , "StandardWallCabinets", "C:/Users/JimAnderson/Documents/CNC-Data/Testing/StandardWallCabinets.ini")
    SaveRegistry("CabinetMaker" , "StandardBaseCabinets", "C:\\Users\\JimAnderson\\Documents\\CNC-Data\\Testing\\StandardBaseCabinets.ini")
    local z = ReadRegistry ("AllJim" , "StandardWallCabinets" )

    for index for arrays    
        for index, value in pairs(IniFile) do
        DisplayMessageBox(tostring(value))
    end

    StdFileWriter(script_path, "Default") 
    StdFileWriter(script_path, "Jim") 
    StdFileWriter(script_path, "Cat") 
    StdFileWriter(script_path, "Zoo") 
    StdFileWriter(script_path, "Ass") 

    local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    DisplayMessageBox(x) 
    StdHeaderReader(script_path)
    local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", IniFile)
    DisplayMessageBox(y)     
    StdLoader(script_path, y) 
    
    local z = InquiryPathBox("Cabinet Maker", "Job Path", Global.JobPath)
    DisplayMessageBox(z) 

]]
DisplayMessageBox(tostring(directory_exists("C:\\JIM") )) 


	job:Refresh2DView()  -- Regenerate the drawing display
    return true 
end  -- function end  
-- ==============================================================================
