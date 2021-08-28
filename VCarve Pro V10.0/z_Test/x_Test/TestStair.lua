-- VECTRIC LUA SCRIPT
require "strict"
Steps = {}
Stair = {}

Stair.TriedCount = 1
Stair.StepHeight = 7.000
Stair.StepRun = 12.000
Stair.StairHeight = 63.000
Stair.StairRun = 88.000
Stair.StepNose = 1.000
Stair.StringerNose = 0.000
Stair.StepNoseRadius = 0.500
Stair.StepThickness = 1.000
Stair.RiserThickness = 0.750
Stair.StringerWidth = 10.000
Stair.MaxStepHeight = 8.250
Stair.MinStepHeight = 6.250
Stair.MaxStepRun = 12.000
Stair.MinStepRun = 9.000   

Stair.LayerStringer = "Stair Stringer"
Stair.LayerTreads = "Stair Tread"
Stair.LayerNotes = "Stair Notes"
--  =*********************************************= 
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end
    StepMath()   
    return true 
end
--  ===================================================  
function StepMath()      
        local function roundToNthDecimal(num, n)
                local mult = 10^(n or 0)
                return math.floor(num * mult + 0.5) / mult
        end      
-- =======        
        local XX = 1
        local YY =  1.00
        local ZZ =  1.00
        local xz = true
        while(xz ) do
                YY = Stair.StairHeight / XX
                if  (YY < Stair.MinStepHeight) then
                        xz = false
                else
                        if YY < Stair.MaxStepHeight and YY > Stair.MinStepHeight then
                                ZZ = Stair.StairRun / YY
                                table.insert(Steps,  tostring(YY) .. " Rise having " .. tostring(XX) .. " Risers on ".. tostring(roundToNthDecimal(ZZ,4))  .." Step" )
                                DisplayMessageBox("To the step list YY = " .. tostring(YY) .. "\n" )
                        end
                end 
                XX = XX + 1.0
        end
        table.sort(Steps)
        InquiryDropList("Test", "Values Quest", 500, 300, Steps)
end
--  ====================================================
function InquiryDropList(Header, Quest, XX, YY, DList)
--[[
  Drop list foe user input
  local days = {"Sunday", "Monday", "Tuesday", "Wednesday",    "Thursday", "Friday", "Saturday"}
  Caller: local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, days)
  Dialog Header = "Cabinet Maker"
  User Question = "Select Cabinet Style"
  Selection Array = IniFile
  Returns = String
]]
  local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
 <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> 
<title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto } 
               body, td, th { font-family: Arial, Helvetica, sans-serif font-size: 10px color: #000; } 
.FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif font-size: 12px; } 
.h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 
{ font-size: 10px; font-weight: bold; }
 </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> 
<table width = "248" border = "0" cellpadding = "0"> <tr> 
<td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h1"  id = "Questions">
<strong class = "h2">Message Here</strong></td> </tr> <tr> 
<th width = "20%" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "Questions2"> </th>
 <th width = "60%" height = "15" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> 
<select name = "DList" size = "10" class = "h2" id = "ListBox"> <option>Defalt</option> </select> </th> 
<th width = "20%" height = "15" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2">
</th> </tr> <tr> 
<th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID">
</th> </tr> <tr> 
<td colspan = "3" align = "center"  valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%"> 
<tr align = "right"> 
<td style = "width: 40%"><span style = "width: 40%"> 
<input id = "ButtonCancel" class = "FormButton"  name = "ButtonCancel" type = "button" value = "Cancel"> 
</span></td> <td style = "width: 20%"></td> <td style = "width: 40%"><span style = "width: 40%"> 
<input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td> 
</tr> </table></td> </tr> </table> </body> </html> ]] ; 

local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ;  
dialog:AddLabelField("Questions", Quest) ; 
dialog:AddDropDownList("ListBox", "DEFAULT") ;     
dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
               for index, value in pairs(DList) do ; 
                    dialog:AddDropDownListValue("ListBox", value) ; 
               end ; 
  if not dialog:ShowDialog() then ; 
    return "." ; 
  else ; 
    return string.upper(dialog:GetDropDownListValue("ListBox")) ; 
  end 
end
--  =============== End ===============================

