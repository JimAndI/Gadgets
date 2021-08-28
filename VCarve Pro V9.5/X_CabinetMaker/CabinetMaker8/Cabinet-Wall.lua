-- VECTRIC LUA SCRIPT
require "strict"
--Global variables
    g_boxHight = 0.0000
    g_boxLength = 0.0000
    g_boxDepth = 0.0000
    g_backHight = 0.0000
    g_backWidth = 0.0000
    g_PartGap = 0.5
    g_pt1 = Point2D(1,1)
    g_pt2 = Point2D(20,1)
    g_pt3 = Point2D(40,1)
    g_pt4 = Point2D(14,1)
    g_pt5 = Point2D(14,34)
    g_pt6 = Point2D(30,1)
    g_pt7 = Point2D(30,34)
    g_pt8 = Point2D(45,1)
-- ==============================================================================
    IniFile = {} 
    Global = {}
    Global.ProgramTitle = "Wall Cabinet Creator"
    Global.ProgramName = "Wall-Cabinet"
    Global.ProgramVersion = "Version 1.2"
    Global.CodeBy = "James Anderson"
    Global.Contact = "James.L.Anderson@outlook.com"
    Global.Year = "2018"
    Global.JobPath = "G://Tester"

    Milling = {} 
    Milling.MillClearnace = 0.010 -- can be + or - number, used for dato over sizing
    Milling.ToolSizeDia = 0.25
    Milling.ToolSizeRadus = 0.125 
    Milling.RabbitClearnace = 0.050
    Milling.Tool = 0.0
    
    StandardCabs = {} 
    StandardCabs.New  = false

    Wall = {} -- Wall Cabinet
    Wall.ThicknessBack = 0.5000
    Wall.CabLength = 36.0000
    Wall.CabHeight = 28.0000
    Wall.CabDepth = 12.0000
    Wall.Thickness = 0.750
    Wall.DatoSetback =  1.375
    Wall.DatoDeep =  0.375
    Wall.DatoType = "Through"           -- Half, Full
    Wall.AddFaceFrame = true
    Wall.AddShelf = true
    Wall.AddCenterFaceFrame = true
    Wall.AddCenterPanel = true           -- Insert Panel in Cabinet
    Wall.AddBackNailer = true
    Wall.NailerThickness = 0.500
    Wall.NailerWidth = 3.500

    FaceFrame = {}
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
function AddGroupToJob(job, group, layer_name)
   local cad_object = CreateCadGroup(group) ; 
   local layer = job.LayerManager:GetLayerWithName(layer_name)
   layer:AddObject(cad_object, true)
   return cad_object 
end
-- ==============================================================================
function WriteStandardCabnetList(ObjName) -- Write to Registry values
    local RegistryWrite = Registry(ObjName.RegistryName)
    ObjName.ProgramTitle = RegistryWrite:GetString("ProgramTitle", ObjName.ProgramTitle)
    ObjName.ProgramName = RegistryWrite:GetString("ProgramName",ObjName.ProgramName)
    ObjName.ProgramVersion = RegistryWrite:GetString("ProgramVersion",ObjName.ProgramVersion)
    ObjName.CodeBy = RegistryWrite:GetString("CodeBy", ObjName.CodeBy)
    ObjName.Contact = RegistryWrite:GetString("Contact", ObjName.Contact)
    ObjName.Year = RegistryWrite:GetString("Year",  ObjName.Year)
    ObjName.JobPath = RegistryWrite:GetString("JobPath",  ObjName.JobPath) 
end
-- ==============================================================================
function ReadRegistryStandardCabinetList(ObjName) -- Read from Registry values
    local RegistryRead = Registry(ObjName.RegistryName)
    ObjName.ProgramTitle = RegistryRead:GetString("ProgramTitle", ObjName.ProgramTitle)
    ObjName.ProgramName = RegistryRead:GetString("ProgramName",ObjName.ProgramName)
    ObjName.ProgramVersion = RegistryRead:GetString("ProgramVersion",ObjName.ProgramVersion)
    ObjName.CodeBy = RegistryRead:GetString("CodeBy", ObjName.CodeBy)
    ObjName.Contact = RegistryRead:GetString("Contact", ObjName.Contact)
    ObjName.Year = RegistryRead:GetString("Year",  ObjName.Year)
    ObjName.JobPath = RegistryRead:GetString("JobPath",  ObjName.JobPath)
end
-- ==============================================================================
function StrIniValue(str, ty) -- convert string to the correct data type
--    DisplayMessageBox("<> " .. str)
    local j = (string.find(str, "=") + 1)
--    DisplayMessageBox(string.sub(str, j))
    if ty == "N" then ; return tonumber(string.sub(str, j)); end
    if ty == "S" then ; return string.sub(str, j);  end
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
    local filename = Pxather .. "/Cabinet-Wall.ini"
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
    Wall.DatoSetback = StrIniValue(all_trim(file:read()) , "N") 
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
    Drawing.DrawFaceFrame =   StrIniValue(all_trim(file:read()) , "B")
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
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type="text/css"> html { overflow: auto; } HoleFirstRowSpacing  body { background-color: #D7E4F2; } body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 10px; font-weight: bold; } .ToolNameLabel { color: #555; } </style> </head>  <body> <table width="248" border="0" cellpadding="0"> <tr> <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" id="Questions"><strong>Message Here</strong></td> </tr> <tr> <th width="20%" height="15" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID2">&nbsp;</th> <th width="60%" height="15" align="center" valign="middle" bgcolor="#FFFFFF" id="Contact2"><select name="DList" size="10" id="ListBox"> <option>Defalt</option> </select></th> <th width="20%" height="15" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact2">&nbsp;</th> </tr> <tr> <th height="10" colspan="3" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID">&nbsp;</th> </tr> <tr> <td colspan="3" align="center" valign="middle"><table border="0" width="100%"> <tr align="right"> <td style="width: 40%"><span style="width: 40%"> <input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"> </span></td> <td style="width: 20%">&nbsp;</td> <td style="width: 40%"><span style="width: 40%"> <input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"> </span></td> </tr> </table></td> </tr> </table> </body> </html> ]]
    local dialog = HTML_Dialog(true, myHtml, 280, 155, Header)
    dialog:AddLabelField("Questions", Quest)
    dialog:AddDropDownList("ListBox", "Default")
    dialog:AddDropDownListValue("ListBox", "Default")
    for index, value in pairs(DList) do
        dialog:AddDropDownListValue("ListBox", value)
    end
    if not dialog:ShowDialog() then
        return "."
    else
        return dialog:GetDropDownListValue("ListBox")
	end    
end
-- ==============================================================================
function InquiryTextBox(Header, Quest, Defaltxt)
--[[
    TextBox for user input with default value
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
    PathBox for user input with default value
    Caller: local z = InquiryPathBox("Cabinet Maker", "Job Path", Global.JobPath)
    DisplayMessageBox(z) 
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type="text/css"> html {overflow: auto; } HoleFirstRowSpacing body {background-color: #D7E4F2; } .ToolPicker {  width: 69px;} body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton {font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 10px; font-weight: bold; } .ToolNameLabel { color: #555; } </style> </head> <body> <table width="470" border="0" cellpadding="0"> <tr> <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" id="Questions">0.0<strong>0.0Message Here</strong></td> </tr> <tr> <th width="48" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID"><input id="DirectoryPicker" class="DirectoryPicker" name="DirectoryPicker" type="button" value="Path..."></th> <th width="416" colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact"><input name="DInput" type="text" id="DInput" size="65"></th></tr> <tr> <td colspan="3" align="center" valign="middle"><table border="0" width="100%"> <tr align="right"> <td style="width: 20%">&nbsp;</td> <td style="width: 20%">&nbsp;</td> <td style="width: 25%">&nbsp;</td> <td style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> <td style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> </tr> </table></td> </tr> </table> </body> </html>]]
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
function BtoS(x)   -- Returns String of a boolean
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
    local file = io.open(Pxather .. "/Cabinet-Wall.ini", "a")
    file:write("#======================================================================\n")
    file:write("# Standard Upper Wall Cabinet Configuration Data\n")
    file:write("#======================================================================\n")
    file:write("[" .. Names .. "]\n")
    file:write("Wall.ThicknessBack="..          Wall.ThicknessBack   .."   \n")
    file:write("Wall.Thickness="..              Wall.Thickness   .."   \n")
    file:write("Wall.CabLength="..              Wall.CabLength   .."   \n")
    file:write("Wall.CabHeight="..              Wall.CabHeight   .."   \n")
    file:write("Wall.CabDepth="..               Wall.CabDepth   .."   \n")
    file:write("Wall.DatoSetback="..            Wall.DatoSetback   .."   \n")
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
function StdHeaderReader(Pxather) 
--[[
    Fills in INI Headers to "IniFile" Array 
    IniFile = {} Global variables
    Pxather = script_path
]]
    local filename = Pxather .. "/Cabinet-Wall.ini"
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
function length_of_file(filename) -- Returns file line count
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
function all_trim(s) -- Trims string
--[[
Trims spaces off both ends of a string
]]
   return s:match( "^%s*(.-)%s*$" )
end
-- ==============================================================================
function fileWriter(datFile) -- Not used - Writes values a InI style file
    local file = io.open(datFile, "w")
    -- write line of the file
    file:write("#======================================================================\n")
    file:write("# Standard Cabinet Configuration File \n")
    file:write("#======================================================================\n")
    file:write("[Defalt]\n")
    file:write("Wall.ThicknessBack="..          Wall.ThicknessBack   .."   \n")
    file:write("Wall.Thickness="..              Wall.Thickness   .."   \n")
    file:write("Wall.CabLength="..              Wall.CabLength   .."   \n")
    file:write("Wall.CabHeight="..              Wall.CabHeight   .."   \n")
    file:write("Wall.CabDepth="..               Wall.CabDepth   .."   \n")
    file:write("Wall.DatoSetback="..            Wall.DatoSetback   .."   \n")
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
    file:write("Variables.g_boxHight="..  g_boxHight .."   \n")
    file:write("Variables.g_boxLength=".. g_boxLength  .."   \n")
    file:write("Variables.g_boxDepth="..  g_boxDepth .."   \n")
    file:write("Variables.g_backHight=".. g_backHight  .."   \n")
    file:write("Variables.g_backWidth=".. g_backWidth  .."   \n")
    file:close()-- closes the open file
      return true
end
-- ==============================================================================
function fileWriterX(datFile) -- Not used - Writes values a InI style file
    local file = io.open(datFile, "w")
    -- write line of the file
    file:write("#======================================================================\n")
    file:write("# Standard Cabinet Configuration File \n")
    file:write("#======================================================================\n")
    file:write("[Wall]\n")
    file:write("ThicknessBack="..          Wall.ThicknessBack   .."   \n")
    file:write("Thickness="..              Wall.Thickness   .."   \n")
    file:write("CabLength="..              Wall.CabLength   .."   \n")
    file:write("CabHeight="..              Wall.CabHeight   .."   \n")
    file:write("CabDepth="..               Wall.CabDepth   .."   \n")
    file:write("DatoSetback="..            Wall.DatoSetback   .."   \n")
    file:write("DatoDeep="..               Wall.DatoDeep   .."   \n")
    file:write("DatoType="..               Wall.DatoType   .."   \n")
    file:write("AddFaceFrame="..           BtoS(Wall.AddFaceFrame)   .."   \n")
    file:write("AddShelf="..               BtoS(Wall.AddShelf)   .."   \n")
    file:write("AddCenterFaceFrame="..     BtoS(Wall.AddCenterFaceFrame)   .."   \n")
    file:write("AddCenterPanel="..         BtoS(Wall.AddCenterPanel)   .."   \n")
    file:write("AddBackNailer="..          BtoS(Wall.AddBackNailer)   .."   \n")
    file:write("NailerThickness="..        Wall.NailerThickness   .."   \n")
    file:write("NailerWidth="..            Wall.NailerWidth   .."   \n")        
    file:write("#======================================================================\n")
        
    file:write("[Shelf]\n")   
    file:write("EndClarence="..           Shelf.EndClarence   .."   \n")
    file:write("PinDiameter="..           Shelf.PinDiameter   .."   \n")
    file:write("PinRadus="..              Shelf.PinRadus   .."   \n")
    file:write("Count="..                 Shelf.Count   .."   \n")
    file:write("FaceFrameReveal="..       Shelf.FaceFrameReveal   .."   \n")
    file:write("WidthClearance="..        Shelf.WidthClearance   .."   \n")
    file:write("FaceFrameWidth="..        Shelf.FaceFrameWidth   .."   \n")
    file:write("FaceFrameThickness="..    Shelf.FaceFrameThickness   .."   \n")
    file:write("PinOuter="..              Shelf.PinOuter   .."   \n")
    file:write("PinInter="..              Shelf.PinInter   .."   \n")
    file:write("HoleSpacing="..           Shelf.HoleSpacing   .."   \n")
    file:write("HoleFirstRowSpacing="..   Shelf.HoleFirstRowSpacing   .."   \n")
    file:write("HoleLastRowSpacing="..    Shelf.HoleLastRowSpacing   .."   \n")
    file:write("PartLength="..            Shelf.PartLength   .."   \n")
    file:write("PartDepth="..             Shelf.PartDepth   .."   \n")
    file:write("PartThickness="..         Shelf.PartThickness   .."   \n")        
    file:write("#======================================================================\n")

    file:write("[Milling]\n")   
    file:write("MillClearnace="..       Milling.MillClearnace .."   \n")
    file:write("ToolSizeDia="..         Milling.ToolSizeDia .."   \n")
    file:write("ToolSizeRadus="..       Milling.ToolSizeRadus .."   \n")
    file:write("RabbitClearnace="..     Milling.RabbitClearnace .."   \n")
    file:write("#======================================================================\n")    

    file:write("[Global]\n") 
    file:write("ProgramTitle="..         Global.ProgramTitle   .."   \n")
    file:write("ProgramVersion="..       Global.ProgramVersion   .."   \n")
    file:write("CodeBy="..               Global.CodeBy   .."   \n")
    file:write("JobPath="..              Global.JobPath   .."   \n")
    file:write("ProgramName="..          Global.ProgramName   .."   \n")
    file:write("Contact="..              Global.Contact   .."   \n")
    file:write("Year="..                 Global.Year   .."   \n")
    file:write("#======================================================================\n")

    file:write("[Drawing]\n") 
    file:write("DrawFaceFrame="..       BtoS(Drawing.DrawFaceFrame)   .."   \n")
    file:write("DrawBack="..            BtoS(Drawing.DrawBack)   .."   \n")
    file:write("DrawSideR="..           BtoS(Drawing.DrawSideR)   .."   \n")
    file:write("DrawSideL="..           BtoS(Drawing.DrawSideL)   .."   \n")
    file:write("DrawTop="..             BtoS(Drawing.DrawTop)   .."   \n")
    file:write("DrawBottom="..          BtoS(Drawing.DrawBottom)   .."   \n")
    file:write("DrawCenter="..          BtoS(Drawing.DrawCenter)   .."   \n")
    file:write("DrawNotes="..           BtoS(Drawing.DrawNotes)   .."   \n")
    file:write("DrawShelf="..           BtoS(Drawing.DrawShelf)   .."   \n")
    file:write("#======================================================================\n")

    file:write("[FaceFrame]\n") 
    file:write("FFReveal="..          FaceFrame.FFReveal   .."   \n")
    file:write("FFThickness="..       FaceFrame.FFThickness   .."   \n")
    file:write("StileWidth="..        FaceFrame.StileWidth   .."   \n")
    file:write("BottomRailWidth="..   FaceFrame.BottomRailWidth   .."   \n")
    file:write("TopRailWidth="..      FaceFrame.TopRailWidth   .."   \n")
    file:write("CenterStileWidth="..  FaceFrame.CenterStileWidth   .."   \n")
    file:write("BottomFFReveal="..    FaceFrame.BottomFFReveal   .."   \n")
    file:write("TopOverlap="..        FaceFrame.TopOverlap   .."   \n")
    file:write("StileLength="..       FaceFrame.StileLength   .."   \n")
    file:write("RailLength="..        FaceFrame.RailLength   .."   \n")
    file:write("CenterStileLength=".. FaceFrame.CenterStileLength   .."   \n")
    file:write("#======================================================================\n")

    file:write("[Variables]\n") 
    file:write("g_boxHight="..  g_boxHight .."   \n")
    file:write("g_boxLength=".. g_boxLength  .."   \n")
    file:write("g_boxDepth="..  g_boxDepth .."   \n")
    file:write("g_backHight=".. g_backHight  .."   \n")
    file:write("g_backWidth=".. g_backWidth  .."   \n")
    file:write("#======================================================================\n")   


    file:close()-- closes the open file
      return true
end
-- ==============================================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end  -- function end
-- ==============================================================================
function Holer(pt, ang, dst, dia, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
   
    local group = ContourGroup(true)
    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   

--    BuildCircle(pt, dia)
    pt = Polar2D(pt, ang, dst)
    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   
    AddGroupToJob(job, group, lay)  
--    BuildCircle(pt, dia)    
--    job:Refresh2DView()
    return true   
end  -- function end
-- ==============================================================================
function CADLeters(pt, letter, scl, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    scl = (scl * 0.5)
    local pA0 = pt
    local pA1 = Polar2D(pt, 90.0000, (0.2500 * scl)) ; local pA2 = Polar2D(pt, 90.0000, (0.5000 * scl)) ; local pA3 = Polar2D(pt, 90.0000, (0.7500 * scl)) ; local pA4 = Polar2D(pt, 90.0000, (1.0000 * scl)) ; local pA5 = Polar2D(pt, 90.0000, (1.2500 * scl)) ; local pA6 = Polar2D(pt, 90.0000, (1.5000 * scl)) ; local pA7 = Polar2D(pt, 90.0000, (1.7500 * scl)) ; local pA8 = Polar2D(pt, 90.0000, (2.0000 * scl))
    local pB0 = Polar2D(pt,  0.0000, (0.2500 * scl)) ; local pB1 = Polar2D(pt, 45.0000, (0.3536 * scl)) ; local pB3 = Polar2D(pt, 71.5651, (0.7906 * scl)) ; local pB4 = Polar2D(pt, 75.9638, (1.0308 * scl)) ; local pB5 = Polar2D(pt, 78.6901, (1.2748 * scl)) ; local pB7 = Polar2D(pt, 81.8699, (1.7678 * scl)) ; local pB8 = Polar2D(pt, 82.8750, (2.0156 * scl)) ; local pB10 = Polar2D(pt, 84.2894, (2.5125 * scl)) 
    local pC0 = Polar2D(pt,  0.0000, (0.5000 * scl)) ; local pC2 = Polar2D(pt, 45.0000, (0.7071 * scl)) ; local pC8 = Polar2D(pt, 75.9638, (2.0616 * scl)) ; local pC10 = Polar2D(pt,78.6901, (2.5125 * scl)) ; local pD0 = Polar2D(pt,  0.0000, (0.6250 * scl)) ; local pD1 = Polar2D(pt, 21.8014, (0.6731 * scl)) ; local pD4 = Polar2D(pt, 57.9946, (1.1792 * scl)) ; local pD7 = Polar2D(pt, 70.3462, (1.8583 * scl))
    local pD8 = Polar2D(pt, 72.6460, (2.0954 * scl)) ; local pE0 = Polar2D(pt,  0.0000, (0.7500 * scl)) ; local pE2 = Polar2D(pt, 33.6901, (0.9014 * scl)) ; local pE3 = Polar2D(pt, 45.0000, (1.0607 * scl)) ; local pE8 = Polar2D(pt, 69.4440, (2.1360 * scl)) ; local pF0 = Polar2D(pt,  0.0000, (1.0000 * scl)) ; local pF3 = Polar2D(pt, 36.8699, (1.2500 * scl)) ; local pF4 = Polar2D(pt, 45.0000, (1.4142 * scl))
    local pF7 = Polar2D(pt, 60.2551, (2.0156 * scl)) ; local pF8 = Polar2D(pt, 63.4349, (2.2361 * scl)) ; local pF10 = Polar2D(pt,59.0362, (2.9155 * scl)) ; local pG0 = Polar2D(pt,  0.0000, (1.2500 * scl)) ; local pG1 = Polar2D(pt, 11.3099, (1.2748 * scl)) ; local pG2 = Polar2D(pt, 21.8014, (1.3463 * scl)) ; local pG3 = Polar2D(pt, 30.9638, (1.4577 * scl)) ; local pG4 = Polar2D(pt, 38.6598, (1.6008 * scl))
    local pG5 = Polar2D(pt, 45.0000, (1.7678 * scl)) ; local pG6 = Polar2D(pt, 50.1944, (1.9526 * scl)) ; local pG7 = Polar2D(pt, 54.4623, (2.1506 * scl)) ; local pG8 = Polar2D(pt, 57.9946, (2.3585 * scl)) ; local pH0 = Polar2D(pt,  0.0000, (1.5000 * scl)) ; local pH10 = Polar2D(pt,63.4349, (2.7951 * scl))
    local group = ContourGroup(true)
    local layer = job.LayerManager:GetLayerWithName(lay)
    local line = Contour(0.0) 
    if letter == 65 then
        line:AppendPoint(pA0) ;
        line:LineTo(pD8) ; 
        line:LineTo(pG0) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
        line = Contour(0.0) ; 
        line:AppendPoint(pB3) ; 
        line:LineTo(pF3) ; 
        layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 66 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 67 then
        line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 68 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 69 then
        line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 70 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 71 then
        line:AppendPoint(pG6) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 72 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 73 then
        line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end
    if letter == 74 then
        line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 75 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 76 then
        line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 77 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 78 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end
    if letter == 79 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 80 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 81 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 82 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 83 then
        line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)    
    end  
    if letter == 84 then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 85 then
        line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 86 then
        line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 87 then
        line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end     
    if letter == 88 then
        line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 89 then
        line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 90 then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 48 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 49 then
        line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 50 then
        line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 51 then
        line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 52 then
        line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 53 then
        line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 54 then
        line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 55 then
        line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 56 then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ; 
    end   
    if letter == 57 then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 47 then
        line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 43 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 61 then
        line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 45 then
       line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 39 then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0 
    end   
    if letter == 34 then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end   
    if letter == 40 then
        line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end   
    if letter == 41 then
        line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 60 then
        line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 62 then
        line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 95 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 58 then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 46 then
        line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 59 then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
     if letter == 35 then
         line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) 
    end    
    if letter == 32 then
        pH0 = pH0 
    end   
    if letter == 33 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 36 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 37 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 38 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 42 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 63 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 64 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 91 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 92 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 93 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 94 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 96 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 123 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 124 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 125 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 126 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    return pH0  
end  -- function end
-- ==============================================================================
function CutListfileWriter(datFile)
    local A1 = os.date("%B %d, %Y")
    local dY = os.date("%Y")
    local dM = os.date("%m")
    local dD = os.date("%d")
    local dH = os.date("%I")
    local dMin = os.date("%M")
    local datFile = InquiryPathBox("Cabinet Maker", "Job Path", datFile)
    
    if Shelf.PartLength == 0 then
        Shelf.PartLength = (g_boxLength - (Wall.Thickness * 2) + (Shelf.EndClarence * 2))
        Shelf.PartDepth = (g_boxDepth - (Wall.ThicknessBack * 0.5))
    end
    local file = io.open(datFile .. "//CutList" .. dY .. dM .. dD .. dMin ..".dat", "w")
    -- Get the file open for writing lines to the file
        file:write("================================================================\n")
        file:write("===================== Upper Cabinet Cut-list ===================\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Run Date = ".. A1 .."\n")
        file:write("Cabinet Style = ".. Global.ProgramName .."\n")
        file:write("================================================================\n")
        file:write("Wall Cabinet size\n")
        file:write("Cabinet Hight       = ".. Wall.CabHeight .."\n")
        file:write("Cabinet Length      = ".. Wall.CabLength .."\n")
        file:write("Cabinet Depth       = ".. Wall.CabDepth .."\n")
        file:write("Face Frame Diagonal = ".. math.sqrt ((Wall.CabHeight * Wall.CabHeight)+ (Wall.CabLength * Wall.CabLength)) .."\n")
        file:write("----------------------------------------------------------------\n")
        -- Shelf info
        if Wall.AddBackNailer then
            file:write("Nailer Frames          - 2 pcs of ".. Wall.NailerThickness .." Plywood ".. Wall.NailerWidth  .." X "..  g_backWidth .."     \n")
        end
        if Shelf.Count >= 1 then
            file:write("Shelf Face Frame       - ".. Shelf.Count .." pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. Shelf.FaceFrameThickness .." X ".. Shelf.PartLength .."     \n")
        end
        if Shelf.Count >= 1 then
            file:write("Shelf Panel            - ".. Shelf.Count .." pcs of ".. Wall.Thickness .." Plywood ".. Shelf.PartDepth  .." X ".. Shelf.PartLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.TopRailWidth .." X ".. FaceFrame.RailLength .."     \n")
        file:write("Face Frame Stiles      - 2 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.StileWidth .." X ".. FaceFrame.StileLength .."     \n")
        file:write("Face Frame Bottom Rail - 1 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.BottomRailWidth .." X ".. FaceFrame.RailLength .."     \n")
        if Wall.AddCenterFaceFrame then
            file:write("Face Frame Center      - 1 pcs of ".. FaceFrame.BottomRailWidth .." Hardwood ".. FaceFrame.CenterStileWidth .." X ".. FaceFrame.CenterStileLength .."     \n")
        end
        if Wall.AddCenterPanel then
            file:write("Center Panel           - 1 pcs of ".. Wall.Thickness .." Plywood ".. (g_boxDepth + (Wall.ThicknessBack * 0.5))  .." X ".. g_boxHight - Wall.Thickness .."     \n")
        end
        file:write("Sides Panels           - 2 pcs of ".. Wall.Thickness .." Plywood ".. g_boxDepth .." X ".. g_boxHight .."\n")
        file:write("Top and Bottom Panels  - 2 pcs of ".. Wall.Thickness .." Plywood ".. g_boxDepth .." X ".. g_boxLength .."\n")
        file:write("Back Panel             - 1 pcs of ".. Wall.ThicknessBack .." Plywood ".. g_backHight .." X ".. g_backWidth .."\n")
        file:write("----------------------------------------------------------------\n")
    file:close()-- closes the the door on the open file
end  -- function end
-- ==============================================================================
function BuildLine(pt1, pt2)
    local line = Contour(0.0);     -- use default tolerance
    line:AppendPoint(pt1) 
    line:LineTo(pt2) 
    return line
end  -- function end
-- ==============================================================================
function BuildBox(pt1, xx, yy)
    local line = Contour(0.0);     -- use default tolerance
    line:AppendPoint(pt1) 
    line:LineTo(Polar2D(pt1, 0, xx)) 
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) 
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) 
    line:LineTo(pt1) 
    return line
end -- function end
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
function DrawWriter(what, where, size, lay)
    local strlen = string.len(what)
    local strup = string.upper(what)
    local x = strlen
    local i = 1
    local y = ""
    local ptx = where
    while i <= x do
      y =  string.byte(string.sub(strup, i, i))
      ptx = CADLeters(ptx, y , size, lay)
      i = i + 1
    end
end  -- function end
-- ==============================================================================
function UpperCabinetFaceFrame(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt8, 0,   Wall.CabHeight)
    local pt3 = Polar2D(pt2,  90,   Wall.CabLength)
    local pt4 = Polar2D(pt3, 180,   Wall.CabHeight)
    local line = Contour(0.0)
    line:AppendPoint(g_pt8) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt8)
    layer:AddObject(CreateCadContour(line), true)
    
    local A1 = Polar2D(g_pt8, 90,  FaceFrame.StileWidth)
    local B1 = Polar2D(pt2,   90,  FaceFrame.StileWidth)
    local C1 = Polar2D(pt3,  270,  FaceFrame.StileWidth)
    local D1 = Polar2D(pt4,  270,  FaceFrame.StileWidth)
    line = Contour(0.0)
    line:AppendPoint(A1) 
    line:LineTo(B1)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(C1) 
    line:LineTo(D1)
    layer:AddObject(CreateCadContour(line), true)
    
    local A2 = Polar2D(A1, 0,   FaceFrame.BottomRailWidth)
    local B2 = Polar2D(B1, 180,   FaceFrame.TopRailWidth)
    local C2 = Polar2D(C1, 180,  FaceFrame.TopRailWidth)
    local D2 = Polar2D(D1, 0, FaceFrame.BottomRailWidth)
    line = Contour(0.0)
    line:AppendPoint(A2) 
    line:LineTo(D2)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(B2)
    line:LineTo(C2)
    layer:AddObject(CreateCadContour(line), true)
    
    
    if Wall.AddCenterFaceFrame then
        
        FaceFrame.CenterStileLength = (Wall.CabLength * 0.5) - (FaceFrame.StileWidth + (FaceFrame.CenterStileWidth * 0.5))
        local A3 = Polar2D(A2, 90,   FaceFrame.CenterStileLength)
        local B3 = Polar2D(B2, 90,  FaceFrame.CenterStileLength)
        local C3 = Polar2D(C2, 270,  FaceFrame.CenterStileLength)
        local D3 = Polar2D(D2, 270,   FaceFrame.CenterStileLength)
        line = Contour(0.0)
        line:AppendPoint(A3) 
        line:LineTo(B3)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
        line:AppendPoint(D3)
        line:LineTo(C3)
        layer:AddObject(CreateCadContour(line), true)
    end
    
    
    
    FaceFrame.StileLength = Wall.CabHeight
    FaceFrame.RailLength = Wall.CabLength - (FaceFrame.StileWidth * 2.0)
    FaceFrame.CenterStileLength = Wall.CabHeight - (FaceFrame.BottomRailWidth + FaceFrame.TopRailWidth) 
    
    local pt1Text = Polar2D(g_pt8, 0,  4)
    local pt1Text = Polar2D(pt1Text, 90,  ((Wall.CabLength * 0.5) + 8))
    DrawWriter(Global.ProgramTitle, pt1Text, 0.750, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 1)
    DrawWriter("Version: " .. Global.ProgramVersion, pt1Text, 0.50, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("By: " .. Global.CodeBy, pt1Text, 0.50, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("= Stiles and FaceFrame.RailLength Cut list =", pt1Text, 0.50, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Stiles: 2 pcs " .. tostring(FaceFrame.BottomRailWidth)  .. " x " .. tostring(FaceFrame.StileWidth) .. " - " .. FaceFrame.StileLength .. "'' long", pt1Text, 0.5, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Top Rile: 1 pcs " .. tostring(FaceFrame.BottomRailWidth)  .. " x " .. tostring(FaceFrame.TopRailWidth) .. " - " .. FaceFrame.RailLength .. " long", pt1Text, 0.50, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Bottom Rail: 1 pcs " .. tostring(FaceFrame.BottomRailWidth)  .. " x " .. tostring(FaceFrame.BottomRailWidth) .. " - " .. FaceFrame.RailLength .. " long", pt1Text, 0.50, "Notes")
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Pull a ruler twice and cut cut and cut some more :)", pt1Text, 0.50, "Notes")
    if Wall.AddCenterFaceFrame then
        pt1Text = Polar2D(pt1Text, 270, 0.75)
        DrawWriter("Center Stile: 1 pcs " .. tostring(FaceFrame.BottomRailWidth)  .. " x " .. FaceFrame.CenterStileWidth .. " - " .. FaceFrame.CenterStileLength .. " long", pt1Text, 0.50, "Notes") 
    end
  return true   
end  -- function end
-- ==============================================================================
function UpperCabinetShelf(lay, CountX)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    if Drawing.DrawCenter then
        Shelf.PartLength = ((g_boxLength - (Wall.Thickness * 2.0) - (Shelf.EndClarence * 4.0)) * 0.5)
    else
        Shelf.PartLength = (g_boxLength - (Wall.Thickness * 2) - (Shelf.EndClarence * 2))
    end
    Shelf.PartDepth = (g_boxDepth - (Wall.ThicknessBack * 0.5))
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt5, 0,  Shelf.PartLength)
    local pt3 = Polar2D(pt2, 90,  Shelf.PartDepth)
    local pt4 = Polar2D(pt3, 180, Shelf.PartLength)
    local line = Contour(0.0)
    line:AppendPoint(g_pt5) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt5)
    layer:AddObject(CreateCadContour(line), true)
    local pt1Text = Polar2D(Polar2D(g_pt5, 0,  3), 90,  (Shelf.PartDepth / 2))
    DrawWriter("Cabinet Shelf".. CountX .." - ".. Wall.Thickness .." Plywood", pt1Text, 0.5, "Notes")
  return true   
end  -- function end
-- ==============================================================================
function UpperCabinetBack(lay)   -- Add Dato for the UpperCab-CenterPanel
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt7, 0, g_backHight)
    local ptC = Polar2D(g_pt7, 90, g_backWidth * 0.5)
    local pt3 = Polar2D(pt2, 90,  g_backWidth)
    local pt4 = Polar2D(pt3, 180, g_backHight)
    local ptW = g_pt7
    local ptX = g_pt7
    local ptY = g_pt7
    local ptZ = g_pt7
    ptW = Polar2D(ptC, 270.0, ((Wall.Thickness + Milling.MillClearnace) * 0.5))
    ptW = Polar2D(ptW, 180.0, Milling.ToolSizeDia)
    ptX = Polar2D(ptW,  90.0, (Wall.Thickness + Milling.MillClearnace))
    ptY = Polar2D(ptX,   0.0, g_backHight + (Milling.ToolSizeDia * 2.0))
    ptZ = Polar2D(ptW,   0.0, g_backHight + (Milling.ToolSizeDia * 2.0))
    local line = Contour(0.0)
    line:AppendPoint(g_pt7) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt7)
    layer:AddObject(CreateCadContour(line), true)
    if Wall.AddCenterPanel then
        layer = job.LayerManager:GetLayerWithName("BackPocket")
        line = Contour(0.0)
        line:AppendPoint(ptW) 
        line:LineTo(ptX)
        line:LineTo(ptY)
        line:LineTo(ptZ)
        line:LineTo(ptW)
        layer:AddObject(CreateCadContour(line), true)
    end    
    local pt1Text = Polar2D(g_pt7, 45,  4)
    DrawWriter("Cabinet Back - ".. Wall.ThicknessBack .." Plywood", pt1Text, 0.5, "Notes")
    return true   
end  -- function end
-- ==============================================================================
function UpperCabinetTandB(top, lay) -- Add Dato for the UpperCab-CenterPanel
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local pt1 = g_pt1 ; local pt2 = g_pt1 ; local ptC = g_pt1 ; local pt3 = g_pt1 ; local pt4 = g_pt1 ; local ptG = g_pt1 ; local ptH = g_pt1 ; local ptE = g_pt1 ; local ptF = g_pt1 ; local ptW = g_pt1 ; local ptX = g_pt1 ; local ptY = g_pt1 ; local ptZ = g_pt1 ; local pt1Text = g_pt1
    if top == "T" then
        pt1 = g_pt3
        pt1Text = Polar2D(pt1, 45,  4)
        DrawWriter("Cabinet Top - ".. Wall.Thickness .." Plywood", pt1Text, 0.5000, "Notes")
    else
        pt1 = g_pt4
        pt1Text = Polar2D(pt1, 45,  4)
        DrawWriter("Cabinet BOTTOM - ".. Wall.Thickness .." Plywood", pt1Text, 0.5000, "Notes")
    end
        pt2 = Polar2D(pt1,   0, (g_boxLength - (Wall.DatoDeep * 2))) ;        ptC = Polar2D(pt1,   0, ((g_boxLength - (Wall.DatoDeep * 2)) * 0.5)) ;        pt3 = Polar2D(pt2,  90, g_boxDepth) ;        pt4 = Polar2D(pt3, 180, (g_boxLength - (Wall.DatoDeep * 2))) ;        ptG = Polar2D(pt3,   0, Milling.ToolSizeRadus) ;
        ptH = Polar2D(ptG, 270, Wall.ThicknessBack) ;        ptE = Polar2D(pt4, 180, Milling.ToolSizeRadus) ;
        ptF = Polar2D(ptE, 270, Wall.ThicknessBack) ;        ptE = Polar2D(ptE,  90, Milling.RabbitClearnace) ;
        ptG = Polar2D(ptG,  90, Milling.RabbitClearnace) ;        ptW = Polar2D(ptC, 180, ((Wall.Thickness + Milling.MillClearnace) * 0.5)) ;        ptW = Polar2D(ptW, 270, Milling.ToolSizeDia) ;        ptX = Polar2D(ptW,   0, (Wall.Thickness + Milling.MillClearnace)) ;        ptY = Polar2D(ptX,  90, g_boxDepth + (Milling.ToolSizeDia * 2)) ;        ptZ = Polar2D(ptW,  90, g_boxDepth + (Milling.ToolSizeDia * 2)) ;        
        local layer = job.LayerManager:GetLayerWithName(lay) ;        
        local line = Contour(0.0) ;        
        if Wall.DatoType == "Through" then 
            layer = job.LayerManager:GetLayerWithName(lay) ;        
            line = Contour(0.0) ;  
            line:AppendPoint(pt1)  ;        
            line:LineTo(pt2) ;        
            line:LineTo(pt3) ;        
            line:LineTo(pt4) ;        
            line:LineTo(pt1) ;        
            layer:AddObject(CreateCadContour(line), true)
        end        
        if Wall.DatoType == "Half" then
            layer = job.LayerManager:GetLayerWithName(lay) ;        
            line = Contour(0.0) ;         
            line:AppendPoint(Polar2D(pt1, 90, Wall.DatoSetback)) ; 
            line:LineTo(Polar2D(Polar2D(pt1, 90, Wall.DatoSetback), 0, Wall.DatoDeep)) ; 
            line:LineTo(Polar2D(pt1, 0, Wall.DatoDeep)) ;            
            
            line:LineTo(Polar2D(pt2, 180, Wall.DatoDeep))     ;         
            line:LineTo(Polar2D(Polar2D(pt2, 90, Wall.DatoSetback), 180, Wall.DatoDeep)) ; 
            line:LineTo(Polar2D(pt2, 90, Wall.DatoSetback)) ; 

            line:LineTo(pt3) ; 
            line:LineTo(pt4) ; 
            line:LineTo(Polar2D(pt1, 90, Wall.DatoSetback)) ;
            layer:AddObject(CreateCadContour(line), true)
        end  
        
        
    if Wall.AddCenterPanel then
        if Wall.DatoType == "Half" then 
            layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato") ; ptW = Polar2D(ptW,  90, (Milling.ToolSizeDia + Wall.DatoSetback)) ; ptX = Polar2D(ptX,  90, (Milling.ToolSizeDia + Wall.DatoSetback)) ; line = Contour(0.0) ; line:AppendPoint(ptW)  ; line:LineTo(ptX) ; line:LineTo(ptY) ; line:LineTo(ptZ) ; line:LineTo(ptW) ; layer:AddObject(CreateCadContour(line), true)  
        else   
            layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato") ; line = Contour(0.0) ; line:AppendPoint(ptW)  ; line:LineTo(ptX) ; line:LineTo(ptY) ; line:LineTo(ptZ) ; line:LineTo(ptW) ; layer:AddObject(CreateCadContour(line), true)              
        end             
    end
    if Wall.AddBackNailer then
    --    Wall.NailerThickness = 0.0
         layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato") ; 
         pt4 = Polar2D(pt4, 270, Wall.NailerThickness)
         pt3 = Polar2D(pt3, 270, Wall.NailerThickness)
         ptE = Polar2D(pt4, 180, Milling.ToolSizeRadus)
         ptH = Polar2D(pt3,   0, Milling.ToolSizeRadus)         
         ptG = Polar2D(ptE, 270, (Wall.ThicknessBack + Milling.MillClearnace))
         ptF = Polar2D(ptH, 270, (Wall.ThicknessBack + Milling.MillClearnace))
         
         line = Contour(0.0) ; 
         line:AppendPoint(ptE)  ; 
         line:LineTo(ptH) ; 
         line:LineTo(ptF) ; 
         line:LineTo(ptG) ; 
         line:LineTo(ptE)  ; 
         layer:AddObject(CreateCadContour(line), true)
    else
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato") ; line = Contour(0.0) ; line:AppendPoint(ptE)  ; line:LineTo(ptF) ; line:LineTo(ptH) ; line:LineTo(ptG) ; line:LineTo(ptE)  ; layer:AddObject(CreateCadContour(line), true)
    end
  return true   
end  -- function end
-- ==============================================================================
function UpperCabinetSide(side, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local line = Contour(0.0)
    local pt2 = g_pt1 ; local pt3 = g_pt1 ; local pt4 = g_pt1 ; local ptA = g_pt1 ; local ptB = g_pt1 ; local ptL = g_pt1 ; local ptK = g_pt1 ; local ptG = g_pt1 ; local ptH = g_pt1 ; local ptI = g_pt1 ; local ptJ = g_pt1 ; local ptD = g_pt1 ; local ptC = g_pt1 ; local ptE = g_pt1 ; local ptF = g_pt1 ; local ptM = g_pt1 ; local ptN = g_pt1
    local pt1Text = Polar2D(g_pt1, 45,  6)
    local ptx = g_pt1 ; local anx = 0
    
    if side == "L" then -- L side
        pt1Text = Polar2D(g_pt1, 45,  6)
        pt2 = Polar2D(g_pt1,   0, g_boxHight) ;         pt3 = Polar2D(pt2,    90, g_boxDepth) ;
        pt4 = Polar2D(pt3,   180, g_boxHight) ;        ptA = Polar2D(g_pt1, 270, Milling.ToolSizeRadus) ; ptB = Polar2D(ptA,     0, Wall.Thickness) ; 
        ptL = Polar2D(pt2,   270, Milling.ToolSizeRadus) ; ptK = Polar2D(ptL,   180, Wall.Thickness) ; 
        ptG = Polar2D(pt3,     0, Milling.ToolSizeRadus) ; ptH = Polar2D(ptG,   270, Wall.ThicknessBack) ; 
        ptI = Polar2D(pt3,    90, Milling.ToolSizeRadus) ; ptJ = Polar2D(ptI,   180, Wall.Thickness) ; 
        ptD = Polar2D(pt4,    90, Milling.ToolSizeRadus) ; ptC = Polar2D(ptD,     0, Wall.Thickness) ; 
        ptE = Polar2D(pt4,   180, Milling.ToolSizeRadus) ; ptF = Polar2D(ptE,   270, Wall.ThicknessBack) ; 
        ptA = Polar2D(ptA,   180, Milling.RabbitClearnace) ; ptL = Polar2D(ptL,     0, Milling.RabbitClearnace) ; 
        ptG = Polar2D(ptG,    90, Milling.RabbitClearnace) ; ptI = Polar2D(ptI,     0, Milling.RabbitClearnace) ; 
        ptE = Polar2D(ptE,    90, Milling.RabbitClearnace) ; ptD = Polar2D(ptD,   180, Milling.RabbitClearnace)   ;   
        DrawWriter("Cabinet Left Side - ".. Wall.Thickness .." Plywood", pt1Text, 0.5000, "Notes") ; 
        line:AppendPoint(g_pt1) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(g_pt1) ; layer:AddObject(CreateCadContour(line), true)

-- top dato - Through
    if Wall.DatoType == "Through" then   
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        line = Contour(0.0)
        line:AppendPoint(ptA) ; 
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; 
        layer:AddObject(CreateCadContour(line), true)
    end
    if Wall.DatoType == "Half" then   
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        ptA = Polar2D(ptA,  90, (Milling.ToolSizeDia + Wall.DatoSetback))
        ptB = Polar2D(ptB,  90, (Milling.ToolSizeDia + Wall.DatoSetback - Milling.ToolSizeRadus))   
        ptM = Polar2D(ptB,  180, (Milling.ToolSizeDia + Milling.MillClearnace)) 
        ptN = Polar2D(ptM,  90, Milling.ToolSizeRadus) 
        line = Contour(0.0)
        line:AppendPoint(ptA) ; 
        line:LineTo(ptN) ; 
        line:LineTo(ptM) ; 
        
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; 
        layer:AddObject(CreateCadContour(line), true)
    end
    if Wall.DatoType == "Full" then   
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        ptB = Polar2D(ptB,  90, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptA = Polar2D(ptA,  90, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptD = Polar2D(ptD, 270, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptC = Polar2D(ptC, 270, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        line = Contour(0.0)
        line:AppendPoint(ptA) ; line:LineTo(ptB) ; line:LineTo(ptC) ; line:LineTo(ptD) ; line:LineTo(ptA) ; layer:AddObject(CreateCadContour(line), true)
    end
-- back dato
    if Wall.AddBackNailer then 
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        ptE = Polar2D(pt4, 90, Milling.ToolSizeRadus)
        ptF = Polar2D(pt3, 90, Milling.ToolSizeRadus)
        local x1 = Polar2D(ptE,180, Milling.ToolSizeRadus) ;
        local x2 = Polar2D(x1, 270, (Milling.ToolSizeRadus + Wall.NailerThickness + Wall.ThicknessBack + Milling.MillClearnace)) ;
        local x4 = Polar2D(ptF,  0, Milling.ToolSizeRadus) ;
        local x3 = Polar2D(x4, 270, (Milling.ToolSizeRadus + Wall.NailerThickness + Wall.ThicknessBack + Milling.MillClearnace)) ;
        local x5 = Polar2D(x4, 180, (Milling.ToolSizeRadus + Wall.NailerWidth + Wall.Thickness)) ;
        local x6 = Polar2D(x5, 270, (Milling.ToolSizeRadus + Wall.NailerThickness)) ;
        local x8 = Polar2D(x1,   0, (Milling.ToolSizeRadus + Wall.NailerWidth + Wall.Thickness)) ;
        local x7 = Polar2D(x8, 270, (Milling.ToolSizeRadus + Wall.NailerThickness)) ;   
        line = Contour(0.0) ; 
        line:AppendPoint(x1) ;     
        line:LineTo(x2) ; 
        line:LineTo(x3) ; 
        line:LineTo(x4) ;
        line:LineTo(x5) ; 
        line:LineTo(x6) ; 
        line:LineTo(x7) ; 
        line:LineTo(x8) ;            
        line:LineTo(x1) ; 
        layer:AddObject(CreateCadContour(line), true)
    else  -- No Back Nailer
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        line = Contour(0.0) ; 
        line:AppendPoint(ptE)  ; 
        line:LineTo(ptF) ; 
        line:LineTo(ptH) ; 
        line:LineTo(ptG) ; 
        line:LineTo(ptE) ; 
        layer:AddObject(CreateCadContour(line), true)
    end
-- bottom dato
    if Wall.DatoType == "Through" then   
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        line = Contour(0.0) ; 
        line:AppendPoint(ptI)  ; 
        line:LineTo(ptJ) ; 
        line:LineTo(ptK) ; 
        line:LineTo(ptL) ; 
        line:LineTo(ptI) ; 
        layer:AddObject(CreateCadContour(line), true)
        ptx = g_pt1 ; anx = 0
        ptx = Polar2D(Polar2D(g_pt1, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 90, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter)) ; anx = 90
    end
    if Wall.DatoType == "Half" then   
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")  ; 
        ptL = Polar2D(ptL,  90, (Milling.ToolSizeDia + Wall.DatoSetback)) ; 
        ptK = Polar2D(ptK,  90, (Milling.ToolSizeDia + Wall.DatoSetback - Milling.ToolSizeRadus)) ; 
        ptM = Polar2D(ptK,  0,  (Milling.ToolSizeDia + Milling.MillClearnace))  ; 
        ptN = Polar2D(ptM,  90, Milling.ToolSizeRadus)  ; 
        line = Contour(0.0) ; 
        line:AppendPoint(ptI)  ; 
        line:LineTo(ptJ) ; 
        line:LineTo(ptK) ; 
        line:LineTo(ptM) ; 
        line:LineTo(ptN) ; 
        line:LineTo(ptL) ; 
        line:LineTo(ptI) ; 
        layer:AddObject(CreateCadContour(line), true)
        ptx = g_pt1 ; anx = 0
        ptx = Polar2D(Polar2D(g_pt1, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 90, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter)) ; anx = 90
    end
    if Wall.DatoType == "Full" then   
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        ptK = Polar2D(ptK,  90, (Milling.ToolSizeRadus + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptL = Polar2D(ptL,  90, (Milling.ToolSizeRadus + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptJ = Polar2D(ptJ,  270, (Milling.ToolSizeRadus + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptI = Polar2D(ptI,  270, (Milling.ToolSizeRadus + Wall.DatoSetback + Milling.ToolSizeRadus))
        line = Contour(0.0) ; line:AppendPoint(ptI)  ; line:LineTo(ptJ) ; line:LineTo(ptK) ; line:LineTo(ptL) ; line:LineTo(ptI) ; layer:AddObject(CreateCadContour(line), true)
        ptx = g_pt1 ; anx = 0
        ptx = Polar2D(Polar2D(g_pt1, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 90, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter)) ; anx = 90
    end
    else  -- R side 
        
        pt1Text = Polar2D(g_pt2, 45,  6)
        pt2 = Polar2D(g_pt2,   0, g_boxHight)
        pt3 = Polar2D(pt2,    90, g_boxDepth)
        pt4 = Polar2D(pt3,   180, g_boxHight)
        ptA = Polar2D(g_pt2, 270, Milling.ToolSizeRadus) ; ptB = Polar2D(ptA,     0, Wall.Thickness)
        ptL = Polar2D(pt2,   270, Milling.ToolSizeRadus) ; ptK = Polar2D(ptL,   180, Wall.Thickness)
        ptI = Polar2D(pt3,    90, Milling.ToolSizeRadus) ; ptJ = Polar2D(ptI,   180, Wall.Thickness)
        ptD = Polar2D(pt4,    90, Milling.ToolSizeRadus) ; ptC = Polar2D(ptD,     0, Wall.Thickness)
        ptG = Polar2D(pt2,     0, Milling.ToolSizeRadus) ; ptH = Polar2D(ptG,    90, Wall.ThicknessBack)
        ptE = Polar2D(g_pt2, 180, Milling.ToolSizeRadus) ; ptF = Polar2D(ptE,    90, Wall.ThicknessBack)

   -- Right Side
        ptL = Polar2D(ptL,     0, Milling.RabbitClearnace) ; ptI = Polar2D(ptI,     0, Milling.RabbitClearnace)
   -- Back Side
        ptG = Polar2D(ptG,   270, Milling.RabbitClearnace) ; ptE = Polar2D(ptE,   270, Milling.RabbitClearnace)
   -- Left Side
        ptD = Polar2D(ptD,   180, Milling.RabbitClearnace)   ; ptA = Polar2D(ptA,   180, Milling.RabbitClearnace)
        DrawWriter("Cabinet Right Side - ".. Wall.Thickness .." Plywood", pt1Text, 0.5000, "Notes")
        line:AppendPoint(g_pt2) ; line:LineTo(pt2) ; line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(g_pt2) ; layer:AddObject(CreateCadContour(line), true) 
-- top dato
    if Wall.DatoType == "Through" then 
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        line = Contour(0.0) ; 
        line:AppendPoint(ptA) ;
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; 
        layer:AddObject(CreateCadContour(line), true)
    end
    if Wall.DatoType == "Half" then 
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        ptD = Polar2D(ptD, 270, (Milling.ToolSizeDia + Wall.DatoSetback))
        ptC = Polar2D(ptC, 270, (Milling.ToolSizeDia + Wall.DatoSetback - Milling.ToolSizeRadus))
        
        ptM = Polar2D(ptC,  180,  (Milling.ToolSizeDia + Milling.MillClearnace)) 
        ptN = Polar2D(ptM,  270, Milling.ToolSizeRadus) 
        
        line = Contour(0.0) ;
        line:AppendPoint(ptA) ; 
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptM) ; 
        line:LineTo(ptN) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; layer:AddObject(CreateCadContour(line), true)
    end    
    if Wall.DatoType == "Full" then 
        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        ptC = Polar2D(ptC, 270, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptD = Polar2D(ptD, 270, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptA = Polar2D(ptA, 90, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        ptB = Polar2D(ptB, 90, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
        line = Contour(0.0) ;
        line:AppendPoint(ptA) ; 
        line:LineTo(ptB) ; 
        line:LineTo(ptC) ; 
        line:LineTo(ptD) ; 
        line:LineTo(ptA) ; layer:AddObject(CreateCadContour(line), true)
    end  
-- back dato
if Wall.AddBackNailer then 
            layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
            ptE = Polar2D(g_pt2, 270, Milling.ToolSizeRadus)
            ptF = Polar2D(pt2, 270, Milling.ToolSizeRadus)
local y1 = Polar2D(ptE, 180, Milling.ToolSizeRadus) ;
local y2 = Polar2D(y1, 90, (Milling.ToolSizeRadus + Wall.NailerThickness + Wall.ThicknessBack + Milling.MillClearnace)) ;
local y4 = Polar2D(ptF,  0, Milling.ToolSizeRadus) ;
local y3 = Polar2D(y4,  90, (Milling.ToolSizeRadus + Wall.NailerThickness + Wall.ThicknessBack + Milling.MillClearnace)) ;
local y5 = Polar2D(y4, 180, (Milling.ToolSizeRadus + Wall.NailerWidth + Wall.Thickness)) ;
local y6 = Polar2D(y5, 90, (Milling.ToolSizeRadus + Wall.NailerThickness)) ;
local y8 = Polar2D(y1,   0, (Milling.ToolSizeRadus + Wall.NailerWidth + Wall.Thickness)) ;
local y7 = Polar2D(y8, 90, (Milling.ToolSizeRadus + Wall.NailerThickness)) ;   
            line = Contour(0.0) ; 
            line:AppendPoint(y1) ;     
            line:LineTo(y2) ; 
            line:LineTo(y3) ; 
            line:LineTo(y4) ;
            line:LineTo(y5) ; 
            line:LineTo(y6) ; 
            line:LineTo(y7) ; 
            line:LineTo(y8) ;            
            line:LineTo(y1) ; 
            layer:AddObject(CreateCadContour(line), true)

else -- No Back Nailer

        layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
        line = Contour(0.0) ; line:AppendPoint(ptE)  ; line:LineTo(ptF) ; line:LineTo(ptH) ; line:LineTo(ptG) ; line:LineTo(ptE) ; layer:AddObject(CreateCadContour(line), true)
        
end
-- bottom dato
        if Wall.DatoType == "Through" then
            layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
            line = Contour(0.0) ; line:AppendPoint(ptI)  ; line:LineTo(ptJ) ; line:LineTo(ptK) ; line:LineTo(ptL) ; line:LineTo(ptI) ; layer:AddObject(CreateCadContour(line), true)
            ptx = g_pt2 ; anx = 0
            ptx = Polar2D(Polar2D(pt4, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 270, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter)) ; anx = 270
        end
        if Wall.DatoType == "Half" then
            layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
            ptI = Polar2D(ptI, 270, (Milling.ToolSizeDia + Wall.DatoSetback))
            ptJ = Polar2D(ptJ, 270, (Milling.ToolSizeDia + Wall.DatoSetback - Milling.ToolSizeRadus))
            ptM = Polar2D(ptJ,  0,  (Milling.ToolSizeDia + Milling.MillClearnace)) 
            ptN = Polar2D(ptM,  270, Milling.ToolSizeRadus) 
            line = Contour(0.0) ; line:AppendPoint(ptI)  ; 
            line:LineTo(ptN) ; 
            line:LineTo(ptM) ; 
            line:LineTo(ptJ) ; 
            line:LineTo(ptK) ; 
            line:LineTo(ptL) ; 
            line:LineTo(ptI) ; 
            layer:AddObject(CreateCadContour(line), true)
            ptx = g_pt2 ; anx = 0
            ptx = Polar2D(Polar2D(pt4, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 270, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter)) ; anx = 270
        end        
        if Wall.DatoType == "Full" then
            layer = job.LayerManager:GetLayerWithName(tostring(Wall.DatoDeep) .. "-Dato")
            ptI = Polar2D(ptI, 270, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
            ptJ = Polar2D(ptJ, 270, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
            ptK = Polar2D(ptK,   90, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
            ptL = Polar2D(ptL,   90, (Milling.ToolSizeDia + Wall.DatoSetback + Milling.ToolSizeRadus))
            line = Contour(0.0) ; line:AppendPoint(ptI)  ; line:LineTo(ptJ) ; line:LineTo(ptK) ; line:LineTo(ptL) ; line:LineTo(ptI) ; layer:AddObject(CreateCadContour(line), true)
            ptx = g_pt2 ; anx = 0
            ptx = Polar2D(Polar2D(pt4, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 270, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter)) ; anx = 270
        end          
 
    end

    if Wall.AddShelf then
        local spc = ((g_boxDepth - Wall.Thickness) * Shelf.PinOuter)
        local rows = ((g_boxHight - (Shelf.HoleFirstRowSpacing + Shelf.HoleLastRowSpacing + (Wall.Thickness * 2.0))) / Shelf.HoleSpacing)

        while (rows > 0) do
            Holer (ptx, anx, spc, Shelf.PinRadus, "PinHoles")
             ptx = Polar2D(ptx, 0, Shelf.HoleSpacing)
            rows = (rows - 1.0)
        end
    end
  return true   
end  -- function end
-- ==============================================================================
function UpperCenterPanel(lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt1 = Polar2D(g_pt6, 0, (Wall.Thickness * 0.5))
    local pt2 = Polar2D(pt1, 0, g_boxHight - Wall.Thickness)
    local pt3 = Polar2D(pt2, 90, (g_boxDepth - (Wall.ThicknessBack * 0.5) - Wall.NailerThickness))
    local pt4 = Polar2D(pt3, 180, g_boxHight - Wall.Thickness)
    local pt1Text = Polar2D(g_pt6, 45,  4)
    DrawWriter("Cabinet Center Panel - ".. Wall.Thickness .." Plywood", pt1Text, 0.5000, "Notes")
    local line = Contour(0.0) ; 
    if Wall.DatoType == "Through" then
        layer = job.LayerManager:GetLayerWithName(lay) ;        
        line = Contour(0.0) ; 
        line:AppendPoint(pt1) ; 
        line:LineTo(pt2) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(pt1) ; 
        layer:AddObject(CreateCadContour(line), true) ; 
    end
    if Wall.DatoType == "Half" then
        layer = job.LayerManager:GetLayerWithName(lay) ;        
        line = Contour(0.0) ;         
        line:AppendPoint(Polar2D(pt1, 90, Wall.DatoSetback)) ; 
        line:LineTo(Polar2D(Polar2D(pt1, 90, Wall.DatoSetback), 0, Wall.DatoDeep)) ; 
        line:LineTo(Polar2D(pt1, 0, Wall.DatoDeep)) ;            
        line:LineTo(Polar2D(pt2, 180, Wall.DatoDeep))     ;         
        line:LineTo(Polar2D(Polar2D(pt2, 90, Wall.DatoSetback), 180, Wall.DatoDeep)) ; 
        line:LineTo(Polar2D(pt2, 90, Wall.DatoSetback)) ; 
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ; 
        line:LineTo(Polar2D(pt1, 90, Wall.DatoSetback)) ;
        layer:AddObject(CreateCadContour(line), true)
    end 
    local ptx = g_pt6 ; local anx = 90 ; ptx = Polar2D(Polar2D(g_pt6, 0, (Shelf.HoleFirstRowSpacing + Wall.Thickness)), 90, ((g_boxDepth - Wall.ThicknessBack) * Shelf.PinInter))
if Wall.AddShelf then
    local spc = ((g_boxDepth - Wall.Thickness) * Shelf.PinOuter)
    local rows = ((g_boxHight - (Shelf.HoleFirstRowSpacing + Shelf.HoleLastRowSpacing + (Wall.Thickness * 2.0))) / Shelf.HoleSpacing)

    while (rows > 0) do
        Holer (ptx, anx, spc, Shelf.PinRadus, "PinHoles")
        ptx = Polar2D(ptx, 0, Shelf.HoleSpacing)
        rows = (rows - 1.0)
    end
end     
  return true   
end  -- function end
-- ==============================================================================
function LoadDialog(job, script_path)
   -- local registry = Registry("CabinetMaker")
   local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type="text/css"> html { 	overflow: auto; } HoleFirstRowSpacing body { 	background-color: #D7E4F2; } body, td, th { font-family: Arial, Helvetica, sans-serif; 	font-size: 10px; color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 {  font-size: 14px; font-weight: bold; } .h2 { font-size: 10px; font-weight: bold; } </style> </head> <body> <table width="730" border="1" cellpadding="0"> <tr> <th colspan="4" align="center" valign="middle" bgcolor="#FFFFFF" id="ProgramTitle">0.0</th> <th align="right" valign="middle" bgcolor="#FFFFFF" id="codeBy"><strong>0.0</strong></th> </tr> <tr> <th align="left" valign="middle" bgcolor="#FFFFFF" id="Message">Version</th> <th align="center" valign="middle" bgcolor="#FFFFFF" id="ProgramVersion">0.0</th> <th align="center" valign="middle" bgcolor="#FFFFFF" id="Year">0.0</th> <th align="center" valign="middle" bgcolor="#FFFFFF" id="ProgramName">0.0</th> <th align="right" valign="middle" bgcolor="#FFFFFF" id="Contact">0.0</th> </tr> <tr> <th width="68" align="center" valign="middle" bgcolor="#FFFFFF"><strong>Object Name</strong></th> <th width="129" align="center" valign="middle" bgcolor="#FFFFFF"><strong>Item</strong></th> <th width="108" align="center" valign="middle" bgcolor="#FFFFFF">Value</th> <th width="75" align="center" valign="middle" bgcolor="#FFFFFF"><strong>Default Value</strong></th> <th width="326" align="center" valign="middle" bgcolor="#FFFFFF"><strong>Information</strong></th> </tr> <tr> <td align="center" valign="middle">Milling</td> <td align="right" valign="middle">Rabbit Clearnace</td> <td align="center" valign="middle"><input name="RabbitClearnace" type="text" class="h2" id="RabbitClearnace" size="10" maxlength="10"></td> <td align="center" valign="middle">0.05</td> <td align="left" valign="middle">Milling Offset Amount To Mill Over The Edge of Material</td> </tr> <tr> <td align="center" valign="middle">Milling</td> <td align="right" valign="middle">Mill Clearance</td> <td align="center" valign="middle"><input name="MillClearnace" type="text" class="h2" id="MillClearnace" size="10" maxlength="10"></td> <td align="center" valign="middle">0.01</td> <td align="left" valign="middle">Amount To Mill Dato Clearnace</td> </tr> <tr> <td align="center" valign="middle">Milling</td> <td align="right" valign="middle">Tool Size Dia</td> <td align="center" valign="middle"><input name="ToolSizeDia" type="text" class="h2" id="ToolSizeDia" size="10" maxlength="10"></td> <td align="center" valign="middle">0.25</td> <td align="left" valign="middle">Amount To Mill over for Dato</td> </tr> <tr> <td align="center" valign="middle">Milling</td> <td align="right" valign="middle">Tool Size Radus</td> <td align="center" valign="middle"><input name="Tool Size Radus" type="text" class="h2" id="ToolSizeRadus" size="10" maxlength="10" readonly></td> <td align="center" valign="middle">0.125</td> <td align="left" valign="middle">Amount To Mill over for Dato</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Material Thickness</td> <td align="center" valign="middle"><input name="Thickness" type="text" class="h2" id="Thickness" size="10" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Material Thickness for Cabinet Sides</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Material Thickness Back</td> <td align="center" valign="middle"><input name="ThicknessBack" type="text" class="h2" id="ThicknessBack" size="10" maxlength="10"></td> <td align="center" valign="middle">0.5</td> <td align="left" valign="middle">Material Thickness Used On The Back</td> </tr> <tr> <td align="center" valign="middle" bgcolor="#D7E4F2">Wall</td> <td align="right" valign="middle" nowrap bgcolor="#D7E4F2">Wall Cabinet Length</td> <td align="center" valign="middle" bgcolor="#D7E4F2"><input name="CabLength" type="text" class="h2" id="CabLength" size="10" maxlength="10"></td> <td align="center" valign="middle" bgcolor="#D7E4F2">36</td> <td align="left" valign="middle" bgcolor="#D7E4F2">Wall Cabinet Length (wide / left to right)</td> </tr> <tr> <td align="center" valign="middle" bgcolor="#D7E4F2">Wall</td> <td align="right" valign="middle" nowrap bgcolor="#D7E4F2">Wall Cabinet Height</td> <td align="center" valign="middle" bgcolor="#D7E4F2"><input name="CabHeight" type="text" class="h2" id="CabHeight" size="10" maxlength="10"></td> <td align="center" valign="middle" bgcolor="#D7E4F2">28</td> <td align="left" valign="middle" bgcolor="#D7E4F2">Wall Cabinet Height (floor to ceiling)</td> </tr> <tr> <td align="center" valign="middle" bgcolor="#D7E4F2">Wall</td> <td align="right" valign="middle" nowrap bgcolor="#D7E4F2">Wall Cabinet Depth</td> <td align="center" valign="middle" bgcolor="#D7E4F2"><input name="CabDepth" type="text" class="h2" id="CabDepth" size="10" maxlength="10"></td> <td align="center" valign="middle" bgcolor="#D7E4F2">12</td> <td align="left" valign="middle" bgcolor="#D7E4F2">Wall Cabinet Depth (from wall out)</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Add Center Panel</td> <td align="center" valign="middle"><input type="checkbox" name="AddCenterPanel" id="AddCenterPanel"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Frame Panel In The Opening</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Add Center Face Frame</td> <td align="center" valign="middle"><input type="checkbox" name="AddCenterFaceFrame" id="AddCenterFaceFrame"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Face Frame In The Opening</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Add Shelfs</td> <td align="center" valign="middle"><input type="checkbox" name="AddShelf" id="AddShelf"></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Frame Panel In The Opening</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Add Face Frame</td> <td align="center" valign="middle"><input type="checkbox" name="AddFaceFrame" id="AddFaceFrame"> <label for="xxxx"></label></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Face Frame</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Add Back Nailer</td> <td align="center" valign="middle"><input type="checkbox" name="AddBackNailer" id="AddBackNailer"> <label for="xxxx5"></label></td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Center Face Frame In The Opening</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Nailer Thickness</td> <td align="center" valign="middle"><input name="NailerThickness" type="text" class="h2" id="NailerThickness" size="10" maxlength="1"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Cabinet Has A Nailer Thickness</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Nailer Width</td> <td align="center" valign="middle"><input name="NailerWidth" type="text" class="h2" id="NailerWidth" size="10" maxlength="1"></td> <td align="center" valign="middle">3</td> <td align="left" valign="middle">Cabinet Has A Center Frame Panel In The Opening</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Dato Type</td> <td align="center" valign="middle"><select name="DatoType" id="DatoType"> <option value="1">Through</option> <option value="2">Half</option> </select></td> <td align="center" valign="middle">0.25</td> <td align="left" valign="middle">Type Of Dato To Cut</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Dato Deep</td> <td align="center" valign="middle"><input name="DatoDeep" type="text" class="h2" id="DatoDeep" size="10" maxlength="10"></td> <td align="center" valign="middle">1.375</td> <td align="left" valign="middle">Amount To Cut Dato Depth</td> </tr> <tr> <td align="center" valign="middle">Wall</td> <td align="right" valign="middle" nowrap>Dato Setback</td> <td align="center" valign="middle"><input name="DatoSetback" type="text" class="h2" id="DatoSetback" size="10" maxlength="10"></td> <td align="center" valign="middle">1.375</td> <td align="left" valign="middle">Amount Setback For Blind Dato</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>New Standard Cabinet</td> <td align="center" valign="middle"><input name="New" type="checkbox" id="New"></td> <td align="center" valign="middle">Not Checked</td> <td align="left" valign="middle">Make This A Standard Cabinet</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Face Frame Drawing</td> <td align="center" valign="middle"><input type="checkbox" name="DrawFaceFrame" id="DrawFaceFrame"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Draw Cabinet Face Frame</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Back Drawing</td> <td align="center" valign="middle"><input type="checkbox" name="DrawBack" id="DrawBack"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A DrawBack</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Right Side Panel</td> <td align="center" valign="middle"><input type="checkbox" name="DrawSideR" id="DrawSideR"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A DrawSideR</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Left Side Panel</td> <td align="center" valign="middle"><input type="checkbox" name="DrawSideL" id="DrawSideL"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Face DrawSideL</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Top Part</td> <td align="center" valign="middle"><input type="checkbox" name="DrawTop" id="DrawTop"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A FaceDrawTop</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Bottom Part</td> <td align="center" valign="middle"><input type="checkbox" name="DrawBottom" id="DrawBottom"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A FaceDrawBottom</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Center Panel</td> <td align="center" valign="middle"><input type="checkbox" name="DrawCenter" id="DrawCenter"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Face DrawCenter</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Notes Sheet</td> <td align="center" valign="middle"><input type="checkbox" name="DrawNotes" id="DrawNotes"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Face DrawNotes</td> </tr> <tr> <td align="center" valign="middle">Drawing</td> <td align="right" valign="middle" nowrap>Draw Shelfs Drawing</td> <td align="center" valign="middle"><input type="checkbox" name="DrawShelf" id="DrawShelf"> </td> <td align="center" valign="middle">Checked</td> <td align="left" valign="middle">Cabinet Has A Face DrawNotes</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle" nowrap>Side Reveal</td> <td align="center" valign="middle"><input name="FFReveal" type="text" class="h2" id="FFReveal" size="10" maxlength="10"></td> <td align="center" valign="middle">0.25</td> <td align="left" valign="middle">Amount Face Frame Extends The Face Frame Passed The Cabinet Side</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle" nowrap>Face Frame Stile Width</td> <td align="center" valign="middle"><input name="StileWidth" type="text" class="h2" id="StileWidth" size="10" maxlength="10"></td> <td align="center" valign="middle">2.75</td> <td align="left" valign="middle">Face Frame Stile Face Width</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle" nowrap> Bottom Rail Width</td> <td align="center" valign="middle"><input name="BottomRailWidth" type="text" class="h2" id="BottomRailWidth" size="10" maxlength="10"></td> <td align="center" valign="middle">2.75</td> <td align="left" valign="middle">Face Frame Bottom Rail Face Width</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle" nowrap>Face Frame Thickness</td> <td align="center" valign="middle"><input name="FFThickness" type="text" class="h2" id="FFThickness" size="10" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Face Frame Thickness</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle" nowrap>Top Face Frame Width</td> <td align="center" valign="middle"><input name="TopRailWidth" type="text" class="h2" id="TopRailWidth" size="10" maxlength="10"></td> <td align="center" valign="middle">2.75</td> <td align="left" valign="middle">Top Face Frame Width</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle" nowrap>Center Stile Width</td> <td align="center" valign="middle"><input name="CenterStileWidth" type="text" class="h2" id="CenterStileWidth" size="10" maxlength="10"></td> <td align="center" valign="middle">2.25</td> <td align="left" valign="middle">Center Face Frame Width</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle">Bottom Rail Reveal</td> <td align="center" valign="middle"><input name="BottomFFReveal" type="text" class="h2" id="BottomFFReveal" size="10" maxlength="10"></td> <td align="center" valign="middle">0.0625</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Bottom Of The Cabinet</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle">Top Frame Overlap</td> <td align="center" valign="middle"><input name="TopOverlap" type="text" class="h2" id="TopOverlap" size="10" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Amount Face Frame Is Lowered Below The Inside Cabinet Top</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle">Stile Length</td> <td align="center" valign="middle"><input name="StileLength" type="text" class="h2" id="StileLength" size="10" maxlength="10" readonly></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Length Of Stile</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle">Rail Length</td> <td align="center" valign="middle"><input name="RailLength" type="text" class="h2" id="RailLength" size="10" maxlength="10" readonly></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Length Of Rail</td> </tr> <tr> <td align="center" valign="middle">FaceFrame</td> <td align="right" valign="middle">Center Stile Length</td> <td align="center" valign="middle"><input name="CenterStileLength" type="text" class="h2" id="CenterStileLength" size="10" maxlength="10" readonly></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Amount Face Frame Is Lowered Below The Inside Cabinet Top</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Shelf Count</td> <td align="center" valign="middle"><input name="Count" type="text" class="h2" id="Count" size="10" maxlength="10"></td> <td align="center" valign="middle">2</td> <td align="left" valign="middle">Number of Shelves In The Cabnet</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Pin Outer Percent</td> <td align="center" valign="middle"><input name="PinOuter" type="text" class="h2" id="PinOuter" size="10" maxlength="10"></td> <td align="center" valign="middle">0.7</td> <td align="left" valign="middle">Shelf Pin Outer Hole Offset</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Pin Inter Percent</td> <td align="center" valign="middle"><input name="PinInter" type="text" class="h2" id="PinInter" size="10" maxlength="10"></td> <td align="center" valign="middle">0.16</td> <td align="left" valign="middle">Shelf Pin Inter Hole Offset </td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Shelf Width Clearance</td> <td align="center" valign="middle"><input name="WidthClearance" type="text" class="h2" id="WidthClearance" size="10" maxlength="10"></td> <td align="center" valign="middle">0.18</td> <td align="left" valign="middle">Shelf Face Clarence.</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Shelf End Clarence</td> <td align="center" valign="middle"><input name="EndClarence" type="text" class="h2" id="EndClarence" size="10" maxlength="10"></td> <td align="center" valign="middle">0.18</td> <td align="left" valign="middle">Shelf End Clarence, To Clear The Pin Plate (amount applied to each end)</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle">Shelf Hole Spacing</td> <td align="center" valign="middle"><input name="HoleSpacing" type="text" class="h2" id="HoleSpacing" size="10" maxlength="10"></td> <td align="center" valign="middle">2</td> <td align="left" valign="middle">Distance Of Hole Spacing</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>First Row Spacing For Hole</td> <td align="center" valign="middle"><input name="HoleFirstRowSpacing" type="text" class="h2" id="HoleFirstRowSpacing" size="10" maxlength="10"></td> <td align="center" valign="middle">4</td> <td align="left" valign="middle">Amount Offset Befor First Row Hole Spacing</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle">Top Hole Row Spacing</td> <td align="center" valign="middle"><input name="HoleLastRowSpacing" type="text" class="h2" id="HoleLastRowSpacing" size="10" maxlength="10"></td> <td align="center" valign="middle">3</td> <td align="left" valign="middle">Amount g_holeLastRowSpacing</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>ShelfFaceFrameReveal</td> <td align="center" valign="middle"><input name="FaceFrameReveal" type="text" class="h2" id="FaceFrameReveal" size="10" maxlength="10"></td> <td align="center" valign="middle">0.0625</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Shelf</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Part Length</td> <td align="center" valign="middle"><input name="PartLength" type="text" class="h2" id="PartLength" size="10" maxlength="10"></td> <td align="center" valign="middle">32</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Shelf</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Part Depth</td> <td align="center" valign="middle"><input name="PartDepth" type="text" class="h2" id="PartDepth" size="10" maxlength="10"></td> <td align="center" valign="middle">12</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Shelf</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Part Thickness</td> <td align="center" valign="middle"><input name="PartThickness" type="text" class="h2" id="PartThickness" size="10" maxlength="10"></td> <td align="center" valign="middle">12</td> <td align="left" valign="middle">Amount Face Frame Is Raised Above The Shelf</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Shelf Pin Diameter</td> <td align="center" valign="middle"><input name="PinDiameter" type="text" class="h2" id="PinDiameter" size="10" maxlength="10"></td> <td align="center" valign="middle">0.194</td> <td align="left" valign="middle">Sheilf Pin Diameter</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Shelf Pin Radus</td> <td align="center" valign="middle"><input name="PinRadus" type="text" class="h2" id="PinRadus" size="10" maxlength="10"></td> <td align="center" valign="middle">0.0164</td> <td align="left" valign="middle">Sheilf Pin Radius</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Face Frame Thickness</td> <td align="center" valign="middle"><input name="FaceFrameThickness" type="text" class="h2" id="FaceFrameThickness" size="10" maxlength="10"></td> <td align="center" valign="middle">0.75</td> <td align="left" valign="middle">Face Frame Thickness</td> </tr> <tr> <td align="center" valign="middle">Shelf</td> <td align="right" valign="middle" nowrap>Shelf Face Frame Width</td> <td align="center" valign="middle"><input name="FaceFrameWidth" type="text" class="h2" id="FaceFrameWidth" size="10" maxlength="10"></td> <td align="center" valign="middle">1.5</td> <td align="left" valign="middle">Shelf Face Frame Width</td> </tr> <tr> <td colspan="5" align="center" valign="middle"><table border="0" width="82%"> <tr> <td style="width: 20%">&nbsp;</td> <td style="width: 20%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td style="width: 20%">&nbsp;</td> <td style="width: 20%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td> <td style="width: 20%">&nbsp;</td> </tr> </table></td> </tr> </table> </body> </html>]]
	--local html_path = "file:" .. script_path .. "\\Cabinet-Wall.htm"
    local dialog = HTML_Dialog(true, myHtml, 780, 600,      Global.ProgramTitle)
    
    dialog:AddLabelField("ProgramVersion",               Global.ProgramVersion)
    dialog:AddLabelField("ProgramTitle",                 Global.ProgramTitle)   
    dialog:AddLabelField("CodeBy",                       Global.CodeBy)  
    dialog:AddLabelField("ProgramName",                  Global.ProgramName)
    dialog:AddLabelField("Contact",                      Global.Contact)   
    dialog:AddLabelField("Year",                         Global.Year)      
    dialog:AddDoubleField("PinDiameter",                  Shelf.PinDiameter)    
    dialog:AddDoubleField("PinOuter",                     Shelf.PinOuter)
    dialog:AddDoubleField("PinInter",                     Shelf.PinInter)     
    dialog:AddDoubleField("EndClarence",                  Shelf.EndClarence)
    dialog:AddDoubleField("Count",                        Shelf.Count)
    dialog:AddDoubleField("WidthClearance",               Shelf.WidthClearance)
    dialog:AddDoubleField("HoleSpacing",                  Shelf.HoleSpacing)
    dialog:AddDoubleField("HoleFirstRowSpacing",          Shelf.HoleFirstRowSpacing)
    dialog:AddDoubleField("HoleLastRowSpacing",           Shelf.HoleLastRowSpacing)    
    dialog:AddDoubleField("FaceFrameThickness",           Shelf.FaceFrameThickness) 
    dialog:AddDoubleField("FaceFrameWidth",               Shelf.FaceFrameWidth)
    dialog:AddDoubleField("PinRadus",                     Shelf.PinRadus)    
    dialog:AddDoubleField("PartLength",                   Shelf.PartLength)
    dialog:AddDoubleField("PartDepth",                    Shelf.PartDepth)    
    dialog:AddDoubleField("PartThickness",                Shelf.PartThickness)
    dialog:AddDoubleField("FaceFrameReveal",              Shelf.FaceFrameReveal)
    dialog:AddDoubleField("FFThickness",              FaceFrame.FFThickness)     
    dialog:AddDoubleField("StileLength",              FaceFrame.StileLength) 
    dialog:AddDoubleField("RailLength",               FaceFrame.RailLength)     
    dialog:AddDoubleField("CenterStileLength",        FaceFrame.CenterStileLength)     
    dialog:AddDoubleField("FFReveal",                 FaceFrame.FFReveal)     
    dialog:AddDoubleField("StileWidth",               FaceFrame.StileWidth)      
    dialog:AddDoubleField("BottomRailWidth",          FaceFrame.BottomRailWidth)
    dialog:AddDoubleField("TopRailWidth",             FaceFrame.TopRailWidth)
    dialog:AddDoubleField("CenterStileWidth",         FaceFrame.CenterStileWidth)
    dialog:AddDoubleField("BottomFFReveal",           FaceFrame.BottomFFReveal)
    dialog:AddDoubleField("TopOverlap",               FaceFrame.TopOverlap)
    dialog:AddDoubleField("MillClearnace",                      Milling.MillClearnace)  
    dialog:AddDoubleField("RabbitClearnace",                    Milling.RabbitClearnace)
    dialog:AddDoubleField("ToolSizeDia",                        Milling.ToolSizeDia)
    dialog:AddDoubleField("ToolSizeRadus",                      Milling.ToolSizeRadus) 
    dialog:AddCheckBox("DrawFaceFrame",                 Drawing.DrawFaceFrame)
    dialog:AddCheckBox("DrawBack",                      Drawing.DrawBack)
    dialog:AddCheckBox("DrawSideR",                     Drawing.DrawSideR)
    dialog:AddCheckBox("DrawSideL",                     Drawing.DrawSideL)
    dialog:AddCheckBox("DrawTop",                       Drawing.DrawTop)
    dialog:AddCheckBox("DrawBottom",                    Drawing.DrawBottom)
    dialog:AddCheckBox("DrawCenter",                    Drawing.DrawCenter)
    dialog:AddCheckBox("DrawNotes",                     Drawing.DrawNotes)
    dialog:AddCheckBox("DrawShelf",                     Drawing.DrawShelf)
    dialog:AddCheckBox("AddFaceFrame",                     Wall.AddFaceFrame)    
    dialog:AddCheckBox("AddCenterPanel",                   Wall.AddCenterPanel)
    dialog:AddCheckBox("AddCenterFaceFrame",               Wall.AddCenterFaceFrame)
    dialog:AddCheckBox("AddShelf",                         Wall.AddShelf)
    dialog:AddCheckBox("AddBackNailer",                    Wall.AddBackNailer)
    dialog:AddCheckBox("New",                      StandardCabs.New)
    dialog:AddDoubleField("DatoSetback",                   Wall.DatoSetback)   
    dialog:AddDoubleField("NailerThickness",               Wall.NailerThickness)    
    dialog:AddDoubleField("NailerWidth",                   Wall.NailerWidth)
    dialog:AddDoubleField("DatoDeep",                      Wall.DatoDeep)     
    dialog:AddDoubleField("Thickness",                     Wall.Thickness)   
    dialog:AddDoubleField("CabLength",                     Wall.CabLength)      
    dialog:AddDoubleField("CabHeight",                     Wall.CabHeight)
    dialog:AddDoubleField("CabDepth",                      Wall.CabDepth)      
    dialog:AddDoubleField("ThicknessBack",                 Wall.ThicknessBack)
    dialog:AddDropDownList("DatoType",                     Wall.DatoType )
    dialog:AddDropDownListValue("DatoType",                "Through")
    dialog:AddDropDownListValue("DatoType",                "Half")
--    dialog:AddDropDownListValue("DatoType",                "Full")
--    dialog:AddToolPickerValidToolType("ToolChooseButton",  	Tool.END_MILL)    
--    dialog:AddTextField("JobPath",                       Global.JobPath);
--    dialog:AddDirectoryPicker("DirectoryPicker1",  "JobPath", true);

  
	if not dialog:ShowDialog() then
		return false
		-- Done and run ;-)
	end

-- Get the data from the Dialog and update my global variables
--    Global.JobPath                  =          dialog:GetTextField("JobPath")
    Wall.DatoType                   =          dialog:GetDropDownListValue("DatoType");    
    Wall.AddCenterPanel             =          dialog:GetCheckBox("AddCenterPanel")
    Wall.AddCenterFaceFrame         =          dialog:GetCheckBox("AddCenterFaceFrame")
    Wall.AddShelf                   =          dialog:GetCheckBox("AddShelf")
    Wall.AddBackNailer              =          dialog:GetCheckBox("AddBackNailer") 
    Wall.AddFaceFrame               =          dialog:GetCheckBox("AddFaceFrame")      
    Wall.Thickness                  = tonumber(dialog:GetDoubleField("Thickness"))
    Wall.CabLength                  = tonumber(dialog:GetDoubleField("CabLength"))
    Wall.CabHeight                  = tonumber(dialog:GetDoubleField("CabHeight"))
    Wall.CabDepth                   = tonumber(dialog:GetDoubleField("CabDepth"))
    Wall.ThicknessBack              = tonumber(dialog:GetDoubleField("ThicknessBack"))
    Wall.DatoSetback                = tonumber(dialog:GetDoubleField("DatoSetback"))
    Wall.NailerThickness            = tonumber(dialog:GetDoubleField("NailerThickness")) 
    Wall.NailerWidth                = tonumber(dialog:GetDoubleField("NailerWidth")) 
    Wall.DatoDeep                   = tonumber(dialog:GetDoubleField("DatoDeep"))

   
    Drawing.DrawFaceFrame           =          dialog:GetCheckBox("DrawFaceFrame") 
    Drawing.DrawBack                =          dialog:GetCheckBox("DrawBack") 
    Drawing.DrawSideR               =          dialog:GetCheckBox("DrawSideR") 
    Drawing.DrawSideL               =          dialog:GetCheckBox("DrawSideL") 
    Drawing.DrawTop                 =          dialog:GetCheckBox("DrawTop") 
    Drawing.DrawBottom              =          dialog:GetCheckBox("DrawBottom") 
    Drawing.DrawCenter              =          dialog:GetCheckBox("DrawCenter") 
    Drawing.DrawNotes               =          dialog:GetCheckBox("DrawNotes") 
    Drawing.DrawShelf               =          dialog:GetCheckBox("DrawShelf") 

    StandardCabs.New                =          dialog:GetCheckBox("New") 
    
    FaceFrame.FFThickness           = tonumber(dialog:GetDoubleField("FFThickness"))
    FaceFrame.BottomRailWidth       = tonumber(dialog:GetDoubleField("BottomRailWidth"))
    FaceFrame.TopRailWidth          = tonumber(dialog:GetDoubleField("TopRailWidth"))
    FaceFrame.CenterStileWidth      = tonumber(dialog:GetDoubleField("CenterStileWidth"))
    FaceFrame.BottomFFReveal        = tonumber(dialog:GetDoubleField("BottomFFReveal"))
    FaceFrame.TopOverlap            = tonumber(dialog:GetDoubleField("TopOverlap"))
    FaceFrame.FFReveal              = tonumber(dialog:GetDoubleField("FFReveal"))
    FaceFrame.StileWidth            = tonumber(dialog:GetDoubleField("StileWidth"))
  
    Shelf.PinDiameter               = tonumber(dialog:GetDoubleField("PinDiameter"))
    Shelf.PartLength                = tonumber(dialog:GetDoubleField("PartLength"))
    Shelf.PartDepth                 = tonumber(dialog:GetDoubleField("PartDepth"))
    Shelf.Count                     = tonumber(dialog:GetDoubleField("Count"))
    Shelf.FaceFrameThickness        = tonumber(dialog:GetDoubleField("FaceFrameThickness"))
    Shelf.WidthClearance            = tonumber(dialog:GetDoubleField("WidthClearance"))
    Shelf.FaceFrameWidth            = tonumber(dialog:GetDoubleField("FaceFrameWidth"))
    Shelf.HoleSpacing               = tonumber(dialog:GetDoubleField("HoleSpacing"))
    Shelf.HoleFirstRowSpacing       = tonumber(dialog:GetDoubleField("HoleFirstRowSpacing"))
    Shelf.HoleLastRowSpacing        = tonumber(dialog:GetDoubleField("HoleLastRowSpacing"))
    Shelf.PartThickness             = tonumber(dialog:GetDoubleField("PartThickness"))
	Shelf.PinOuter                  = tonumber(dialog:GetDoubleField("PinOuter"))
    Shelf.PinInter                  = tonumber(dialog:GetDoubleField("PinInter"))
    Shelf.FaceFrameReveal           = tonumber(dialog:GetDoubleField("FaceFrameReveal"))
    Shelf.EndClarence               = tonumber(dialog:GetDoubleField("EndClarence"))
    Shelf.PinRadus                  = Shelf.PinDiameter * 0.5 
    Milling.ToolSizeDia             = tonumber(dialog:GetDoubleField("ToolSizeDia"))
    Milling.ToolSizeRadus           = tonumber(dialog:GetDoubleField("ToolSizeRadus"))
    Milling.RabbitClearnace         = tonumber(dialog:GetDoubleField("RabbitClearnace"))

    return true
end  -- function end
-- ==============================================================================
function main(script_path)
    -- create a layer with passed name if it doesn't already exist
    local lay = ""
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    -- Pop-up Dialog message for Cabinet Style
    StdHeaderReader(script_path) -- Read Default Cabinets
    Global.ProgramName = InquiryDropList("Cabinet Maker", "Select Cabinet Style", IniFile)
    -- DisplayMessageBox(" A - " .. Global.ProgramName)    
    if Global.ProgramName ~= "." then
        -- DisplayMessageBox(" T - " .. Global.ProgramName)    
        StdLoader(script_path, Global.ProgramName) -- Load per selection 
    else
        -- DisplayMessageBox(" F - " .. Global.ProgramName)    
        goto exit; -- when timing of want to finish script.
    end
        -- DisplayMessageBox(" z - " .. Global.ProgramName)    
    repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == 2 then
			-- DisplayMessageBox("No Tool Selected")
            goto exit; -- when timing of want to finish script.
		end	

		if ret_value == false then
			return false
		end	        
	until ret_value == true
    -- DisplayMessageBox(BtoS(Wall.AddFaceFrame))  
    if Wall.AddFaceFrame then
        g_boxHight =  (Wall.CabHeight - (FaceFrame.TopRailWidth + FaceFrame.BottomRailWidth)) + (FaceFrame.BottomFFReveal + FaceFrame.TopOverlap + (Wall.Thickness * 2.0))   
        g_boxLength = Wall.CabLength - (FaceFrame.FFReveal * 2.0) 
        g_boxDepth  = Wall.CabDepth - FaceFrame.FFThickness
    else 
        g_boxLength = Wall.CabLength 
        g_boxDepth  = Wall.CabDepth
        g_boxHight =  Wall.CabHeight
        FaceFrame.TopRailWidth = 0.0
        FaceFrame.BottomRailWidth = 0.0
        FaceFrame.BottomFFReveal = 0.0
        FaceFrame.TopOverlap = 0.0  
    end

    g_backHight = g_boxHight - Wall.Thickness
    g_backWidth = g_boxLength - Wall.Thickness 
  
    g_pt2 = Point2D((g_boxHight + (3 * g_PartGap)),1)
    g_pt3 = Point2D(1.0,(g_boxDepth + (3 * g_PartGap)))
    g_pt4 = Polar2D(g_pt3, 0, ((g_boxLength - (Wall.Thickness * 1.0) ) + (1.0 * g_PartGap)))
    g_pt5 = Point2D(1.0,((g_boxDepth * 2.0) + (4.0 * g_PartGap))) -- Shelf
    g_pt6 = Point2D(1.0,((g_boxDepth * 3.0) + (5.0 * g_PartGap))) -- Center
    g_pt7 = Point2D(((g_boxLength * 2.0) + (3.0 * g_PartGap) - (Wall.Thickness * 1.0)) ,1.0) -- Back
    g_pt8 = Point2D(((g_boxLength * 2.0) + (3.0 * g_PartGap) + (g_backHight * 1.0)),1.0) -- FaceFrame
   
    if StandardCabs.New then
        local xa = InquiryTextBox("Cabinet Maker", "Standard Cabinet Name", "Style-0001")
        if xa ~= "" then
            StdFileWriter(script_path, xa) 
        end
    end
 
    if Drawing.DrawSideL then 
        UpperCabinetSide("L",  Wall.Thickness .. "-Profile")
    end
    if Drawing.DrawSideR then
        UpperCabinetSide("R",  Wall.Thickness .. "-Profile")
    end
    if Drawing.DrawTop then
        UpperCabinetTandB("T", Wall.Thickness .. "-Profile" )
    end
    if Drawing.DrawBottom then
        UpperCabinetTandB("B", Wall.Thickness .. "-Profile")
    end
    if Drawing.DrawBack then
        UpperCabinetBack(  Wall.ThicknessBack .. "-Profile") 
    end 
    if Drawing.DrawShelf then
        if Shelf.Count >= 1 then
            local CountX = Shelf.Count
            while (CountX > 0) do
            --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
                lay = Wall.Thickness .. "-Profile"                                 
                UpperCabinetShelf(lay, CountX)
                g_pt5 = Polar2D(g_pt5, 0, (Shelf.PartLength + (2 * g_PartGap))) -- (g_boxHight + (Wall.Thickness * 3.0) + (2 * g_PartGap)))  
                CountX = CountX - 1
            end
        end
    end
    if Drawing.DrawCenter then
        UpperCenterPanel(Wall.Thickness ..  "-Profile")
    end
    if Drawing.DrawFaceFrame then 
        UpperCabinetFaceFrame("FaceFrame")
    end 
    if Drawing.DrawNotes then 
        CutListfileWriter(Global.JobPath)
    end 
    ::exit::
	job:Refresh2DView()  -- Regenerate the drawing display
    return true 
end  -- function end