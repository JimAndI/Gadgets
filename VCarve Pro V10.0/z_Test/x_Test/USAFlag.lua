-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy US Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
require "strict"
    local g_pt1 =  Point2D(1, 1)  ;    local g_pt2 =  g_pt1 ;    local g_pt3 =  g_pt1 ;    local  g_pt4 =  g_pt1;    local g_pt5 =  g_pt1 ;    local  g_pt6 =  g_pt1
    Flag = {} ; 
    Flag.HoistFlag = 1.0 ;     Flag.HoistUnion = 0.5385 ;     Flag.FlyFlag = 1.9 ;     Flag.FlyUnion = 0.76 ;     Flag.UnionStarCentersV = 0.054 ;
    Flag.UnionStarCentersH = 0.063 ;    Flag.StarDia = 0.0616 ;        Flag.Strip = 0.0769 ; 
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  =================================================== 
function NowName()
--[[
    %a  abbreviated weekday name (e.g., Wed)
    %A  full weekday name (e.g., Wednesday)
    %b  abbreviated month name (e.g., Sep)
    %B  full month name (e.g., September)
    %c  date and time (e.g., 09/16/98 23:48:10)
    %d  day of the month (16) [01-31]
    %H  hour, using a 24-hour clock (23) [00-23]
    %I  hour, using a 12-hour clock (11) [01-12]
    %M  minute (48) [00-59]
    %m  month (09) [01-12]
    %p  either "am" or "pm" (pm)
    %S  second (10) [00-61]
    %w  weekday (3) [0-6 = Sunday-Saturday]
    %x  date (e.g., 09/16/98)
    %X  time (e.g., 23:48:10)
    %Y  full year (1998)
    %y  two-digit year (98) [00-99]
    %%  the character `%´

    DeBug(9370,4, "NowName")
]]
    return os.date("%d").. os.date("%H").. os.date("%M").. os.date("%S")
end
-- ===================================================
function ProjectBackup()
    local filename = "C:/Users/Public/Documents/Vectric Files/Gadgets/CabinetBackup.cmd"
    local file = io.open(filename, "w")
    file:write("echo ================================================================================ \n") ;
    file:write("echo CabinetMaker \n") ;
    file:write("echo on \n") ;
    file:write("C:\n") ;
    file:write("cd Vcarve \n") ;
    file:write("mkdir " .. NowName() .." \n") ;
    file:write("xcopy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5" .. string.char(34) .. " " .. string.char(34) .. "C:\\Vcarve\\" .. NowName() ..  "\\" .. string.char(34) .. " /d/e/y \n") ; 
    file:write("echo ================================================================================= \n") ;
    file:write("pause \n") ;
    file:close()-- closes the open file 
    return true  
end
-- ===================================================
function InquiryTextBox(Header, Quest, Defaltxt)
--[[
    TextBox for user input with default value
    Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[ <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css">  html {overflow: auto ; } body { background-color: #EBEBEB ; }body, td, th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ; width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Questions"> <strong> Message Here</strong> </td> </tr> <tr> <th width = "48" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th> <th width = "416" colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"> <input name = "qInput" type = "text" id = "qInput" size = "65"> </th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle" bgcolor = "#EBEBEB"> <table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"></td> <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td> <td style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </td> </tr> </table> </body> 
    </html>]] 
    local dialog = HTML_Dialog(true, myHtml, 525, 160, Header) ; 
    dialog:AddLabelField("Questions", Quest) ;
    dialog:AddTextField("qInput", Defaltxt) ; 
    if not dialog:ShowDialog() then ; return "" ; else ; return dialog:GetTextField("qInput") ; end    
end
-- ===================================================
function USAFlag()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
-- ======    
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName("Hoist")
    line:AppendPoint(g_pt1) 
    line:LineTo(g_pt2)
    line:LineTo(g_pt3)
    line:LineTo(g_pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
-- ======    
    job:Refresh2DView()
    return true  
end
-- ===================================================
function Stripe(p1, p2, p3, p4, Layer)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(p1) ;    line:LineTo(p2);    line:LineTo(p3);    line:LineTo(p4);    line:LineTo(p1);    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function Star(pt1)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local p1 =  Polar2D(pt1,  18.0,  Flag.StarOutRadius) 
    local p2 =  Polar2D(pt1,  54.0, Flag.StarInRadius) 
    local p3 =  Polar2D(pt1,  90.0, Flag.StarOutRadius)   
    local p4 =  Polar2D(pt1,  126.0, Flag.StarInRadius)
    local p5 =  Polar2D(pt1,  162.0, Flag.StarOutRadius) 
    local p6 =  Polar2D(pt1,  192.0, Flag.StarInRadius)   
    local p7 =  Polar2D(pt1,  234.0,Flag.StarOutRadius)
    local p8 =  Polar2D(pt1,  270.0, Flag.StarInRadius) 
    local p9 =  Polar2D(pt1,  306.0, Flag.StarOutRadius)   
    local p0 =  Polar2D(pt1,  342.0, Flag.StarInRadius)
    

    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName("Stars")
    line:AppendPoint(p1) ;    
    line:LineTo(p2);    
    line:LineTo(p3);    
    line:LineTo(p4);   
    line:LineTo(p5);    
    line:LineTo(p6);    
    line:LineTo(p7);   
    line:LineTo(p8);    
    line:LineTo(p9);    
    line:LineTo(p0);   
    line:LineTo(p1);    
    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function DrawUnion()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
-- ======
    local pt1 =  g_pt4
    local pt2 =  Polar2D(pt1,  0.0, Flag.FlyUnion) 
    local pt3 =  Polar2D(pt2,  270.0, Flag.HoistUnion)   
    local pt4 =  Polar2D(pt1,  270.0, Flag.HoistUnion)
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName("Fly")
    line:AppendPoint(pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(pt1)
    layer:AddObject(CreateCadContour(line), true)
    job:Refresh2DView()
    return true  
end
-- ===================================================
function DrawStars()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
-- ======
    local pt1 =  g_pt4    
    local pt2 =  g_pt4   
    for i = 5, 1 , -1     do 
       pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV) 
       pt2 = Polar2D(pt1,      0.0, Flag.UnionStarCentersH) 
        for i = 6, 1 , -1     do 
            Star(pt2) 
            pt2 =  Polar2D(pt2,  0.0, Flag.UnionStarCentersH * 2.0) 
        end 
        pt1 =  Polar2D(pt1 ,  270.0, Flag.UnionStarCentersV ) 
    end
    pt1 =  g_pt4   
    local pt1 =  g_pt4    
    pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV ) 
  for i = 4, 1 , -1     do 
       pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV  ) 
       pt2 = Polar2D(pt1,      0.0, Flag.UnionStarCentersH * 2.0) 
        for i = 5, 1 , -1     do 
            Star(pt2) 
            pt2 =  Polar2D(pt2,  0.0, Flag.UnionStarCentersH * 2.0) 
        end 
        pt1 =  Polar2D(pt1 ,  270.0, Flag.UnionStarCentersV) 
    end
    job:Refresh2DView()
    return true  
end
-- ===================================================
function DrawStripes()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
-- ======
    local pt1 =  g_pt5    
    local lay = "Stripe-Red"
    for i = 7, 1 , -1     do 
        local pt2 =  Polar2D(pt1,  0.0, Flag.FlyFlag - Flag.FlyUnion) 
        local pt3 =  Polar2D(pt2,  270.0, Flag.Stripe)   
        local pt4 =  Polar2D(pt1,  270.0, Flag.Stripe)
        Stripe(pt1, pt2, pt3, pt4,lay)
        if lay == "Stripe-Red" then
             lay = "Stripe-White"
        else
             lay = "Stripe-Red"
        end
        pt1 = pt4
    end
    pt1 =  g_pt6   
    lay = "Stripe-White"
    for i = 6, 1 , -1     do 
        local pt2 =  Polar2D(pt1,  0.0, Flag.FlyFlag) 
        local pt3 =  Polar2D(pt2,  270.0, Flag.Stripe)   
        local pt4 =  Polar2D(pt1,  270.0, Flag.Stripe)
        Stripe(pt1, pt2, pt3, pt4, lay)
        pt1 = pt4
       if lay == "Stripe-Red" then
             lay = "Stripe-White"
        else
             lay = "Stripe-Red"
        end
    end
    job:Refresh2DView()
    return true  
end
-- ===================================================
function main(script_path)
-- create a layer with passed name if it doesn't already exist
    --ProjectBackup() 
        Flag.HoistFlag = InquiryTextBox("USA Flag Data", "Enter the Flag Height", "30") ; 
    Flag.HoistUnion = 0.5385 * Flag.HoistFlag; 
    Flag.FlyFlag = 1.9 * Flag.HoistFlag; 
    Flag.FlyUnion = 0.76 * Flag.HoistFlag; 
    Flag.UnionStarCentersV = 0.054 * Flag.HoistFlag;
    Flag.UnionStarCentersH = 0.063 * Flag.HoistFlag;
    Flag.StarDia = 0.0616 * Flag.HoistFlag;    
    Flag.StarOutRadius = 0.5 * Flag.StarDia
    Flag.StarInRadius = Flag.StarDia * 0.190983
    Flag.Stripe = 0.0769 * Flag.HoistFlag; 
-- ======
    g_pt1 = Point2D(1, 1) 
    g_pt2 = Polar2D(g_pt1,  0.0, Flag.FlyFlag) 
    g_pt3 = Polar2D(g_pt2,  90.0, Flag.HoistFlag)   
    g_pt4 = Polar2D(g_pt1,  90.0, Flag.HoistFlag)
    g_pt5 = Polar2D(g_pt4,   0.0, Flag.FlyUnion)   
    g_pt6 = Polar2D(g_pt4,  270.0, Flag.HoistUnion)
        
    USAFlag()
    DrawUnion()
    DrawStripes()
    DrawStars()
    return true 
end  -- function end
-- ===================================================