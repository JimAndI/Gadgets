-- VECTRIC LUA SCRIPT

require("mobdebug").start()
--  =*********************************************= 
local XX = require("TestZ")


function InquiryTextBox(Header, QuestionID, DInput)
--[[
  Number Box for user input with default value
  Caller: local X = InquiryPathBox("Select Path", "What image to use?", "C:\\")
  Dialog Header = "Tool Name"
  User QuestionID = "Path name?"
  Default Value = "C:\\"
  Returns = String
]]
  local myHtml = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head><meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"><title>Easy Tools</title><style type = "text/css">html {	overflow: auto;}body {background-color: #EBEBEB;}body, td,  th {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	color: #000;}.FormButton {	font-weight: bold;	width: 100%;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;}body {	background-color: #EBEBEB;}</style></head><body bgcolor = "#EBEBEB" text = "#000000"><table width = "470" border = "0" cellpadding = "0"><tr> <td width=2%>?:&nbsp;<span id="QuestionID"></span></td></tr><tr><th align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"> <input name = "DInput" type = "text" id = "DInput" size = "80"></th></tr> <tr><td align = "center" valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%"><tr align = "right">  <td style = "width: 20%"></td> <td style = "width: 20%"></td> <td style = "width: 25%"></td><td style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td><td style = "width: 15%"><span style="width: 25%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></span></td></tr></table></td></tr></table></body></html>]] 
    local dialog = HTML_Dialog(true, myHtml, 550, 150, Header) ; 
               dialog:AddTextField("QuestionID", QuestionID) ;               
               dialog:AddTextField("DInput", DInput) ;
    if not dialog:ShowDialog() then ; 
            return "DInput"  ; 
    else ;
            return dialog:GetTextField("DInput")  ; 
    end 
end

function main()
    
  -- DisplayMaterialSettings()
  XX.JJ()
    
end
-- =================================================
function maina()
-- Check we have a job loaded
        local job = VectricJob()
                if not job.Exists then
                DisplayMessageBox("No job loaded")
                return false;
        end
       local jim = InquiryTextBox("Enter Text", "Question", "The default")
    return true;
end
-- =================================================
function mainx()
-- Check we have a job loaded
  local job = VectricJob()
  if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
        DisplayMaterialSettings()
    return true;
end