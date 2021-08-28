-- VECTRIC LUA SCRIPT
require "strict"
-- Global variables Go Here.
    mylist = "\"New\",\"Obj\",\"Name\",\"Program\",\"Title\""
    days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
-- =================================================================================
function InquiryDropList(Header, Quest, DList)
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd"><html><head><meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type"><title>Cabinet Maker and Tool-path Creator</title><style type="text/css">html {overflow: auto;}HoleFirstRowSpacing body {background-color: #D7E4F2;}.ToolPicker {width: 69px;}body, td, th {font-family: Arial, Helvetica, sans-serif;font-size: 10px;color: #000;}.FormButton {font-weight: bold;width: 100%;font-family: Arial, Helvetica, sans-serif;font-size: 12px;}.h1 {font-size: 14px; font-weight: bold;}.h2 {font-size: 10px;font-weight: bold;}.ToolNameLabel {color: #555;}</style></head><body><table width="150" border="0" cellpadding="0"><tr><td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" id="Questions"><strong>Message Here</strong></td></tr><tr><th width="33%" align="right" valign="middle" bgcolor="#FFFFFF" id="QuestionID">&nbsp;</th><th width="147" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact"><select name="ListBox" size="10" id="ListBox"><option>Defalt</option></select></th><th width="33%" align="left" valign="middle" bgcolor="#FFFFFF" id="Contact">&nbsp;</th></tr><tr><td colspan="3" align="center" valign="middle"><table border="0" width="100%"><tr align="right"><td style="width: 25%">&nbsp;</td><td style="width: 25%"><span style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></span></td><td style="width: 25%"><span style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></span></td><td style="width: 25%">&nbsp;</td></tr></table></td></tr></table></body></html>]]
    local dialog = HTML_Dialog(true, myHtml, 180, 160, Header)
    dialog:AddLabelField("Questions", Quest)
    dialog:AddDropDownList("ListBox", "Default")
    dialog:AddDropDownListValue("ListBox", "Default")

    for index, value in pairs(DList) do
--        DisplayMessageBox(tostring(value))
        dialog:AddDropDownListValue("ListBox", value)
    end
--        DisplayMessageBox(dialog:GetDropDownListValue("ListBox"))  
    if not dialog:ShowDialog() then
        return ""
    else
        return dialog:GetDropDownListValue("ListBox")
	end    
end
-- =================================================================================
function InquiryTextBox(Header, Quest, Defaltxt)
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
-- =================================================================================
function SaveRegistry(RegistryName, ObjName, Val)
    local RegistryWrite = Registry(RegistryName)
    RegistryWrite:SetString(ObjName, Val) 
    return true 
end  -- function end  
-- =================================================================================
function ReadRegistry(RegistryName, ObjName)
    local RegistryRead = Registry(RegistryName)
    local Val = RegistryRead:GetString(ObjName, "")
    return Val 
end  -- function end  
-- =================================================================================
-- The function looks like table.concat(yourArray, "delimiter") so:
-- table.concat({ "one", "two", "three", "four", "five" }, ",") will produce a string "one,two,three,four,five"
-- Assuming we pass in the array to our saveData() function, it will look like:
-- =================================================================================  
function Arrat2String(mArray)
    local saveString = table.concat(mArray, ",")
    saveGlobalData("dataKey", saveString)
end
-- =================================================================================
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
-- =================================================================================   
-- Using the above function the loadData() function is trivial, and will return your original array:
-- =================================================================================   
function loadData()
    local stringArray = readGlobalData("dataKey")
    return explode(",", stringArray)
end

-- =================================================================================
function main(script_path)
    SaveRegistry("AllJim" , "StandardWallCabinets", mylist)
    local z = ReadRegistry ("AllJim" , "StandardWallCabinets" )
--    for index for arrays    
--     for index, value in pairs(days) do
--         DisplayMessageBox(tostring(value))
--     end
    local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", z)
    DisplayMessageBox(x) 
    DisplayMessageBox(y)     
    return true 
end  -- function end  
-- =================================================================================