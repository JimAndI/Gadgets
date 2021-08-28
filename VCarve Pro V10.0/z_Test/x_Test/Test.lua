-- VECTRIC LUA SCRIPT
-- require("mobdebug").start()
 -- Global variables   
    function Polar2D(pt, ang, dis)
        return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
    end-- function end
    --  ===================================================
 pt1 = Point2D(1.0, 1.0) 
 pt2 = Point2D(5.0, 1.0) 
 pt3 = Point2D(5.0, 5.0) 
 pt4 = Point2D(1.0, 5.0)  
-- ===============================================
function Arc2Bulge (p1, p2, Rad) 
    local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
    local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
    local bulge = (2 * seg) / chord 
    return bulge
end
--  =*********************************************= 
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end
    local Rad = 0.5
    local Ang = 90.0
    local pt5 = Polar2D(pt4, 0.0, Rad) 
    local pt6= Polar2D(pt4, 270.0, Rad)    
    
    local layer = job.LayerManager:GetLayerWithName("JimAndi")
    local line = Contour(0.0)
    line:AppendPoint(pt1) 
    layer:AddObject(CadMarker("P1", pt1, 3), true)
    line:LineTo(pt2) 
    layer:AddObject(CadMarker("P2", pt2, 3), true)
    line:LineTo(pt3)
    layer:AddObject(CadMarker("P3", pt3, 3), true)
     --[[    line:LineTo(pt4)
    layer:AddObject(CadMarker("P4", pt4, 3), true)
    ]] 
    layer:AddObject(CadMarker("P4", pt4, 3), true)
            line:LineTo(pt5)
            layer:AddObject(CadMarker("P5", pt5, 3), true)
           
            line:ArcTo(pt6,  Arc2Bulge( pt5, pt6, Rad))
            layer:AddObject(CadMarker("P6", pt6, 3), true)

    line:LineTo(pt1)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true 
end
-- ================================================
--[[ ------------------ MarkContourNodes ----------------------------
|
| Insert a marker at each node on the passed contour
|
]]
function MarkContourNodes(contour, layer)
    local num_spans = 0
    local ctr_pos = contour:GetHeadPosition()
    while ctr_pos ~= nil do
        local span
        span, ctr_pos = contour:GetNext(ctr_pos)
        -- create a marker at start of span
        local marker = CadMarker("V:" .. num_spans, span.StartPoint2D, 3)
        layer:AddObject(marker, true)
        num_spans = num_spans + 1;
    end
    -- if contour was open mark last point
    if contour.IsOpen then
        local marker = CadMarker("V:" .. num_spans, contour.EndPoint2D, 3)
        layer:AddObject(marker, true)
    end
end
-- ================================================
function InquiryYesNo(Question)
--[[
Drop list for user to input project info
Caller = local y = InquiryDropList("JimAndi Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
Dialog Header = "JimAndi Cabinet Maker"
User Question = "Select Cabinet Style"
Selection Array = IniFile
Returns = String
]]

local myHtml = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Project Information</title> <style type = "text/css">html { overflow: auto; } body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #000; background-color: #EBEBEB; } .FormButton { font-weight: bold; width: 60%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h2 { font-size: 12px; font-weight: bold; text-align:left; text-wrap:none; vertical-align:middle; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width="400" border="0" align="left" cellpadding="0"> <tr> <td colspan="3" align="left" valign="middle" nowrap class="h2" id="Question2">&nbsp;</td> </tr> <tr> <td colspan="3" align="left" valign="middle" nowrap class="h2" id="Question">Question</td> </tr> <tr> <td align="left" valign="middle" nowrap class="h2">&nbsp;</td> </tr> <tr> <td colspan="3" align="center" valign="middle"> <table width="350" border="0" cellpadding="0"> <tr> <td style="width: 20%" align="center" valign="middle"> <input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="No"> </th> <td style="width: 20%" align="center" valign="middle"> <input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="Yes"> </th> </tr> </table> </td> </tr> </table> </body> </html>]] ; 
local dialog = HTML_Dialog(true, myHtml, 440, 170, "Project Question") ; 
dialog:AddLabelField("Question",Question) ; 
if not dialog:ShowDialog() then ; 
return false 
else 
return true
end 
end
--  =*********************************************= 
function mainq(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end

    local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
    local ZXZX = InquiryDropList("Cabinet Maker", "Select Project", 290, 165, days)
    local ptE = Polar2D(Point2D(1,1),  90, 34.0) ; 
    
     DisplayMessageBox(tostring(ptE.X) .. " x " .. tostring(ptE.Y))
    
    return true 
end
--  =============== End ===============================

function InquiryDropList(Header, Quest, XX, YY, DList)
--[[
Drop list foe user input
Caller: local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
Dialog Header = "Cabinet Maker"
User Question = "Select Cabinet Style"
Selection Array = IniFile
Returns = String
]]

local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto } 
body, td, th { font-family: Arial, Helvetica, sans-serif font-size: 10px color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 { font-size: 10px; font-weight: bold; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "248" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h1" id = "Questions"><strong class = "h2">Message Here</strong></td> </tr> <tr> <th width = "20%" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "Questions2"> </th> <th width = "60%" height = "15" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> <select name = "DList" size = "10" class = "h2" id = "ListBox"> <option>Defalt</option> </select> </th> <th width = "20%" height = "15" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"></th> </tr> <tr> <th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 40%"><span style = "width: 40%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span></td> <td style = "width: 20%"></td> <td style = "width: 40%"><span style = "width: 40%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td> </tr> </table></td> </tr> </table> </body> </html> ]] ; 
local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ; dialog:AddLabelField("Questions", Quest) ; dialog:AddDropDownList("ListBox", "DEFAULT") ; dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
for index, value in pairs(DList) do ; 
dialog:AddDropDownListValue("ListBox", value) ; 
end ; 
if not dialog:ShowDialog() then ; 
return "." ; 
else ; 
return string.upper(dialog:GetDropDownListValue("ListBox")) ; 
end 
end