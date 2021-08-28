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

-- Easy UK Flag Maker Version 2 is written by Jim Anderson of Houston Texas 2019
]]
require "strict"
       Flag = {} ; 
        local g_pt1 =  Point2D(1.0, 1.0)  ;   
        local g_pt2 =  g_pt1   
        local g_pt3 =  g_pt1    
        local  g_pt4 =  g_pt1    
        local g_pt5 =  g_pt1     
        local  g_pt6 =  g_pt1   
        local g_pt7 =  g_pt1     
        local  g_pt8 =  g_pt1    
        local  g_pt9 =  g_pt1    
        local g_pt10 =  g_pt1     
        local g_pt11 =  g_pt1     
        local g_pt12 =  g_pt1    
        local g_pt13 =  g_pt1     
        local  g_pt14 =  g_pt1   
        local g_pt15 =  g_pt1    
        local  g_pt16 =  g_pt1    
        local g_pt17 =  g_pt1    
        local  g_pt18 =  g_pt1  
        local  g_pt19 =  g_pt1   
        local g_pt20 =  g_pt1  
        local g_pt21 =  g_pt1   
        local g_pt22 =  g_pt1   
        local g_pt23 =  g_pt1    
        local  g_pt24 =  g_pt1    
        local g_pt25 =  g_pt1     
        local  g_pt26 =  g_pt1   
        local g_pt27 =  g_pt1     
        local  g_pt28 =  g_pt1    
        local  g_pt29 =  g_pt1    
        local g_pt30 =  g_pt1     
        local g_pt31 =  g_pt1     
        local g_pt32 =  g_pt1    
        local g_pt33 =  g_pt1     
        local  g_pt34 =  g_pt1   
        local g_pt35 =  g_pt1    
        local  g_pt36 =  g_pt1    
        local g_pt37 =  g_pt1    
        local  g_pt38 =  g_pt1  
        local  g_pt39 =  g_pt1   
        local g_pt40 =  g_pt1  
        local g_pt41 =  g_pt1
        local g_pt42 =  g_pt1   
        local g_pt43 =  g_pt1    
        local  g_pt44 =  g_pt1    
        local g_pt45 =  g_pt1     
        local  g_pt46 =  g_pt1   
        local g_pt47 =  g_pt1     
        local  g_pt48 =  g_pt1    
        local  g_pt49 =  g_pt1    
        local g_pt50 =  g_pt1     
        local g_pt51 =  g_pt1     
        local g_pt52 =  g_pt1    
        local g_pt53 =  g_pt1     
        local  g_pt54 =  g_pt1   
    Flag.XoistFlag = 1.0 ;     
    Flag.FlyFlag = 2.0 ;     
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  ===================================================
function FlagMath()
        g_pt1 =  Point2D(1.0, 1.0)  ;   
        g_pt2 = Polar2D(g_pt1, 0.0,   Flag.X1)
        g_pt3 = Polar2D(g_pt1, 0.0,  Flag.X2)
        g_pt4 = Polar2D(g_pt1, 0.0,   Flag.X8)
        g_pt5 = Polar2D(g_pt1, 0.0,     Flag.X9)
        g_pt6 = Polar2D(g_pt1, 0.0,     Flag.X10)   
        g_pt7  = Polar2D(g_pt1, 0.0,    Flag.X11)      
        g_pt8  = Polar2D(g_pt1, 0.0,    Flag.X16)    
        g_pt9 =  Polar2D(g_pt1, 0.0,    Flag.X18)       
        g_pt10 =  Polar2D(g_pt1, 90.0,    Flag.Y2)         
        g_pt12 = Polar2D(g_pt9,  90.0,    Flag.Y1)    
        g_pt13 = Polar2D(g_pt9,  90.0,    Flag.Y2)              
        g_pt14 = Polar2D(g_pt4,  90.0,    Flag.Y3)        
        g_pt15 = Polar2D(g_pt7, 90.0,    Flag.Y3)          
        g_pt16 = Polar2D(g_pt1, 90.0,    Flag.Y4)         
        g_pt17 = Polar2D(g_pt16,  0.0, Flag.X3)   
        g_pt18 =  Polar2D(g_pt16,  0.0, Flag.X6)     
        g_pt19 =  Polar2D(g_pt16,  0.0, Flag.X7 )    
        g_pt20 =  Polar2D(g_pt16,  0.0, Flag.X13)   
        g_pt21 =  Polar2D(g_pt16,  0.0, Flag.X14)      
        g_pt22 =  Polar2D(g_pt16, 0.0, Flag.X15)            
        g_pt23 =  Polar2D(g_pt16, 0.0,    Flag.X18)          
        g_pt24 =  Polar2D(g_pt1,      90.0,    Flag.Y5)     
        g_pt25 =  Polar2D(g_pt24,      0.0,    Flag.X9)          
             g_pt26 =  Polar2D(g_pt24,      0.0,    Flag.X10)   
        g_pt27 =  Polar2D(g_pt24,      0.0,    Flag.X18)    
 
        g_pt28 =  Polar2D(g_pt1,      90.0,    Flag.Y6)    
        g_pt29 =  Polar2D(g_pt28,     0.0,    Flag.X9)    
        g_pt30 =  Polar2D(g_pt28,      0.0,    Flag.X10)  
        g_pt31 =  Polar2D(g_pt28,       0.0,    Flag.X18) 
        
        g_pt32 =  Polar2D(g_pt1,      90.0,    Flag.Y7)     
        g_pt33 =  Polar2D(g_pt32,      0.0,    Flag.X3)        
        g_pt34 =  Polar2D(g_pt32,      0.0,    Flag.X5)    
        g_pt35 =  Polar2D(g_pt32,      0.0,    Flag.X6)      
        g_pt36 =  Polar2D(g_pt32,      0.0,    Flag.X12)     
        g_pt37  =  Polar2D(g_pt32,        0.0,    Flag.X13)     
        g_pt38 =  Polar2D(g_pt32,      0.0,    Flag.X15)   
        g_pt40 =  Polar2D(g_pt32,      0.0,    Flag.X18)          
       g_pt41 =  Polar2D(g_pt4,      90.0,    Flag.Y8)  
        g_pt42 =  Polar2D(g_pt7,      90.0,    Flag.Y8)          
        g_pt43  =  Polar2D(g_pt1,      90.0,    Flag.Y9)    
        g_pt44  =  Polar2D(g_pt9,      90.0,    Flag.Y9)    
        g_pt45 =  Polar2D(g_pt1,      90.0,    Flag.Y10)    
        
        g_pt46 =  Polar2D(g_pt1,      90.0,    Flag.Y11)       
        g_pt47 =  Polar2D(g_pt46,      0.0,    Flag.X2)         
        g_pt48 =  Polar2D(g_pt46,      0.0,    Flag.X8)     
        g_pt49 = Polar2D(g_pt46,       0.0,    Flag.X9)        
        g_pt50 = Polar2D(g_pt46,       0.0,    Flag.X10)          
        g_pt51 =  Polar2D(g_pt46,       0.0,    Flag.X11)     
        g_pt52 =  Polar2D(g_pt46,      0.0,    Flag.X16)
        g_pt53 =  Polar2D(g_pt46,      0.0,    Flag.X17)   
        g_pt54 =  Polar2D(g_pt46,      0.0,    Flag.X18)  

        return true
end
--  ===================================================
function InquiryNumberBox(Header, Quest, Defaltxt)
--[[
    TextBox for user input with default value
    Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Easy Tools</title> <style type = "text/css">  html {overflow: auto ; } body { background-color: #EBEBEB ; }body, td, th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ; width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <th width = "381" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"> <strong>Message Here</strong></th> <th width = "83" align = "left" valign = "middle" bgcolor = "#EBEBEB"> <input name = "qInput" type = "text" id = "qInput" size = "10"> </th> </tr> <tr> <td colspan = "2" align = "center" valign = "middle" bgcolor = "#EBEBEB"> <table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"> </td> <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td> <td style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </td> </tr> </table> </body>     </html>]] 
    local dialog = HTML_Dialog(true, myHtml, 505, 140, Header) ; 
    dialog:AddLabelField("QuestionID", Quest) ;
    dialog:AddDoubleField("qInput", Defaltxt) ; 
    if not dialog:ShowDialog() then ; return  tonumber("0.0") ; else ; return tonumber(dialog:GetDoubleField("qInput")) ; end    
end
-- ===================================================
function UKFlag()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
-- ======    
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName("UK Boarder")
    line:AppendPoint(g_pt1) 
    line:LineTo(g_pt9)
    line:LineTo(g_pt54)
    line:LineTo(g_pt46)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
-- ======    
    job:Refresh2DView()
    return true  
end
-- ===================================================
function ThreePointBox(p1, p2, p3, Layer)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function FourPointBox(p1, p2, p3, p4, Layer)
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
function Cross()
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName("Cross")
    line:AppendPoint(g_pt5) ; line:LineTo(g_pt6) ; line:LineTo(g_pt26) ; line:LineTo(g_pt27) ; line:LineTo(g_pt31) ; 
    line:LineTo(g_pt30) ; line:LineTo(g_pt50) ; line:LineTo(g_pt49) ; line:LineTo(g_pt29) ;
    line:LineTo(g_pt28) ; line:LineTo(g_pt24) ; line:LineTo(g_pt25) ; line:LineTo(g_pt5) ;
    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function White1(Layer)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(g_pt1) ; line:LineTo(g_pt18) ; line:LineTo(g_pt19) ; 
    line:LineTo(g_pt2) ; line:LineTo(g_pt3) ; line:LineTo(g_pt14) ; 
    line:LineTo(g_pt4) ; line:LineTo(g_pt5) ; line:LineTo(g_pt25) ;
    line:LineTo(g_pt24) ; line:LineTo(g_pt16) ; line:LineTo(g_pt17) ;
    line:LineTo(g_pt10)  ; line:LineTo(g_pt1) ;
    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function White2(Layer)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(g_pt6) ; line:LineTo(g_pt7) ; line:LineTo(g_pt15) ; 
    line:LineTo(g_pt8) ; line:LineTo(g_pt9) ; line:LineTo(g_pt20) ; 
    line:LineTo(g_pt21) ; line:LineTo(g_pt12) ; line:LineTo(g_pt13) ;
    line:LineTo(g_pt22) ; line:LineTo(g_pt23) ; line:LineTo(g_pt27) ;
    line:LineTo(g_pt26) ; line:LineTo(g_pt6) ;
    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function White3(Layer)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(g_pt46) ; line:LineTo(g_pt47) ; line:LineTo(g_pt41) ; 
    line:LineTo(g_pt48) ; line:LineTo(g_pt49) ; line:LineTo(g_pt29) ; 
    line:LineTo(g_pt28) ; line:LineTo(g_pt32) ; line:LineTo(g_pt33) ;
    line:LineTo(g_pt43) ; line:LineTo(g_pt45) ; line:LineTo(g_pt34) ;
    line:LineTo(g_pt35) ;  line:LineTo(g_pt46) ;
    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function White4(Layer)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("Error: No job loaded")
        return false ; 
    end
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(g_pt50) ; line:LineTo(g_pt30) ; line:LineTo(g_pt31) ; 
    line:LineTo(g_pt40) ; line:LineTo(g_pt38) ; line:LineTo(g_pt44) ; 
    line:LineTo(g_pt54) ; line:LineTo(g_pt37) ; line:LineTo(g_pt36) ;
    line:LineTo(g_pt53) ; line:LineTo(g_pt52) ; line:LineTo(g_pt42) ;
    line:LineTo(g_pt51) ; line:LineTo(g_pt50) ;
    layer:AddObject(CreateCadContour(line), true)
    return true  
end
-- ===================================================
function main(script_path)
        Flag.HoistFlag = tonumber(InquiryNumberBox("UK Flag Data", "Enter the Flag Height", 30.0) ); 
        Flag.X0=1.0000   ;  
        Flag.X1=0.147047 * Flag.HoistFlag   ;  
        Flag.X2=0.220571 * Flag.HoistFlag   ;  
        Flag.X3=0.446797 * Flag.HoistFlag   ;  
        Flag.X4=0.514415 * Flag.HoistFlag   ;  
        Flag.X5=0.520321 * Flag.HoistFlag   ;  
        Flag.X6=0.667368 * Flag.HoistFlag   ;  
        Flag.X7=0.814415 * Flag.HoistFlag   ;  
        Flag.X8=0.832781 * Flag.HoistFlag   ;  
        Flag.X9=0.898867 * Flag.HoistFlag   ;  
        Flag.X10=1.101133 * Flag.HoistFlag   ;  
        Flag.X11=1.167219 * Flag.HoistFlag   ;  
        Flag.X12=1.185585 * Flag.HoistFlag   ;  
        Flag.X13=1.332632 * Flag.HoistFlag   ;  
        Flag.X14=1.479679 * Flag.HoistFlag   ;  
        Flag.X15=1.553203 * Flag.HoistFlag   ;  
        Flag.X16=1.779429 * Flag.HoistFlag   ;  
        Flag.X17=1.852953 * Flag.HoistFlag   ;  
        Flag.X18=2.00000 * Flag.HoistFlag   ;  

        Flag.Y0=1.000000   ;  
        Flag.Y1=0.073524 * Flag.HoistFlag   ;  
        Flag.Y2=0.110285 * Flag.HoistFlag   ;  
        Flag.Y3=0.306105 * Flag.HoistFlag   ;  
        Flag.Y4=0.333684 * Flag.HoistFlag   ;  
        Flag.Y5=0.400227 * Flag.HoistFlag   ;  
        Flag.Y6=0.599773 * Flag.HoistFlag   ;  
        Flag.Y7=0.666316 * Flag.HoistFlag   ;  
        Flag.Y8=0.693895 * Flag.HoistFlag   ;  
        Flag.Y9=0.889715 * Flag.HoistFlag   ;  
        Flag.Y10=0.926476 * Flag.HoistFlag   ;  
        Flag.Y11=1.00000 * Flag.HoistFlag   ;  

    
-- ======

    FlagMath()
    UKFlag()
    Cross()
    ThreePointBox(g_pt3, g_pt4, g_pt14, "Blue1")
    ThreePointBox(g_pt7, g_pt8, g_pt15, "Blue2")
    
    ThreePointBox(g_pt13, g_pt23, g_pt22, "Blue3")
    ThreePointBox(g_pt40, g_pt44, g_pt38, "Blue4")
    
    ThreePointBox(g_pt52, g_pt51, g_pt42, "Blue5")
    ThreePointBox(g_pt48, g_pt47, g_pt41, "Blue6")

    ThreePointBox(g_pt43, g_pt32, g_pt33, "Blue7")
    ThreePointBox(g_pt16 ,g_pt17, g_pt10, "Blue8")
     
     FourPointBox(g_pt1, g_pt2, g_pt19, g_pt18, "Red1")
     FourPointBox(g_pt9, g_pt12, g_pt21, g_pt20, "Red2")
     
     FourPointBox(g_pt36, g_pt37, g_pt54, g_pt53, "Red3")
     FourPointBox(g_pt46, g_pt35, g_pt34, g_pt45, "Red4")

     White1("White 1")
     White2("White 2")
     White3("White 3")
     White4("White 4")

    return true 
end  -- function end
-- ===================================================