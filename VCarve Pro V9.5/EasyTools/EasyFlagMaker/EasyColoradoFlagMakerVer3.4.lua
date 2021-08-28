-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented ; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy Colorado Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {}
Flag.Gpt1 = Point2D(1.0, 1.0)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 3.40)"
Flag.FlyFlag = 1.5
Flag.Fly = 0.3333
Flag.CentersV = 0.5
Flag.CentersH = 0.635
Flag.CenterEnd1 = 0.346393
Flag.CenterEnd2 = 0.576408
Flag.CenterInRadius = 0.165
Flag.CenterOutRadius = 0.3333
-- ===================================================
function InquiryNumberBox(Header, Quest, Defaltxt)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
  local myHtml = [[<html><head> <title>Easy Stair Maker</title> <style type="text/css"> html {overflow: hidden;} .LuaButton {	font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;font-size: 12px;} .FormButton { font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;} .h1-l {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:left;} .h1-r {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:right;} .h1-c { font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:center;}    body {	background-color: #CCC;	overflow:hidden;} </style></head><body><table border="0" width="296" cellpadding="0"><tbody><tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here</td><th class="h1-l" align="left" valign="middle" width="83"><input id="qInput" name="qInput" size="10" type="text" /></td></tr><tr><td colspan="2" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td style="width: 20%;">&nbsp;</td><td style="width: 20%;">&nbsp;</td><td style="width: 25%;">&nbsp;</td><td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 330, 120, Header .. " " .. Flag.Version) ;
  dialog:AddLabelField("QuestionID", Quest) ;
  dialog:AddDoubleField("qInput", Defaltxt) ;
  if not dialog:ShowDialog() then
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return false
  else
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return true
  end
end
-- ===================================================
function Boxer0(job, p1, p2, p3, p4, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Boxer1(job, p1, p2, p3, p4, p5, p6, Layer)
  local xarc =  -1 * GetDistance(p4, p5)/(Flag.CenterOutRadius  * 3.0 )
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:ArcTo(p5, xarc) ; line:LineTo(p6) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Boxer2(job, p1, p2, p3, p4, Layer)
  local xarc = -1 * GetDistance(p2, p3)/(Flag.CenterOutRadius  * 3.7310)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:ArcTo(p3, xarc) ; line:LineTo(p4) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Boxer3(job, p1, p2, p3, p4, p5, p6, Layer)
  local xarc = -1 * GetDistance(p2, p3)/(Flag.CenterOutRadius  * 3.0 )
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:ArcTo(p3, xarc) ; line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Boxer4(job, p1, p2, p3, p4, p5, p6, p7, p8, Layer)
  local xarc1 = -1 * GetDistance(p4, p5)/(Flag.CenterOutRadius  * 3.94 )
  local xarc2 = -1 * GetDistance(p6, p7)/(Flag.CenterOutRadius  * 1.905)
  local xarc3 = -1 * GetDistance(p8, p1)/(Flag.CenterOutRadius  * 3.94)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ;
  line:LineTo(p2) ;
  line:LineTo(p3) ;
  line:LineTo(p4) ;
  line:ArcTo(p5, xarc1) ;
  line:LineTo(p6) ;
  line:ArcTo(p7, xarc2) ;
  line:LineTo(p8) ;
  line:ArcTo(p1, xarc3) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Cers(job, p1)
  local p2 = Polar2D(p1,   180.0, Flag.CenterInRadius)
  local p3 = Polar2D(p1,    22.5, Flag.CenterInRadius)
  local p4 = Polar2D(p1,   22.5, Flag.CenterOutRadius)
  local p5 = Polar2D(p1,    180.0, Flag.CenterOutRadius)
  local p6 = Polar2D(p1,    337.5, Flag.CenterOutRadius)
  local p7 = Polar2D(p1,     337.5, Flag.CenterInRadius)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Colorado")
  line:AppendPoint(p7) ;
  line:ArcTo(p2,-0.82068) ;
  line:ArcTo(p3,-0.82068) ;
  line:LineTo(p4) ;
  line:ArcTo(p5,0.82068) ;
  line:ArcTo(p6,0.82068) ;
  line:LineTo(p7) ;
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ===================================================
function Doters(job, p1)
  local p2 = Polar2D(p1,   180.0, Flag.CenterInRadius)
  local p3 = Polar2D(p1,     0.0, Flag.CenterInRadius)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Dot")
  line:AppendPoint(p2) ; line:ArcTo(p3,1) ; line:ArcTo(p2,1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function  DrawCircle(job, Pt1, CenterRadius, Layer)
  local pa = Polar2D(Pt1,   180.0, CenterRadius)
  local pb = Polar2D(Pt1,     0.0, CenterRadius)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(pa) ; line:ArcTo(pb,1) ; line:ArcTo(pa,1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ===================================================
function GetDistance(objA, objB)
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end
-- ===================================================
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
"Select: 'Create a new file' under 'Startup Tasks' and \n" ..
"specify the material dimensions \n"
    )
    return false ;
  end

  local Loops = true

  while Loops do
    Flag.Inquiry = InquiryNumberBox("Colorado Flag Data", "Enter the Flag Height", Flag.HoistFlag)
    if Flag.Inquiry then
      if Flag.HoistFlag > 0 then
        Loops = false
      else
        DisplayMessageBox("Error: The Flag hight must be larger than '0.00'")
        Loops = true
      end -- if end
    else
      Loops = false
    end -- if end
  end -- while end

  if (Flag.Inquiry and (Flag.HoistFlag > 0)) then

    Flag.FlyFlag = Flag.FlyFlag * Flag.HoistFlag ;
    Flag.Fly = Flag.Fly * Flag.HoistFlag ;
    Flag.CentersV = Flag.CentersV* Flag.HoistFlag ;
    Flag.CentersH = Flag.CentersH * Flag.HoistFlag ;
    Flag.CenterInRadius = Flag.CenterInRadius * Flag.HoistFlag ;
    Flag.CenterOutRadius = Flag.CenterOutRadius * Flag.HoistFlag ;
    Flag.CenterEnd1 = Flag.CenterEnd1 * Flag.HoistFlag ;
    Flag.CenterEnd2 = Flag.CenterEnd2 * Flag.HoistFlag ;

    Flag.Gpt1 = Point2D(1.0, 1.0)
    Flag.Gpt2 = Polar2D(Flag.Gpt1,     0.0, Flag.FlyFlag)
    Flag.Gpt3 = Polar2D(Flag.Gpt2,    90.0, Flag.HoistFlag)
    Flag.Gpt4 = Polar2D(Flag.Gpt1,    90.0, Flag.HoistFlag)
    Flag.Gpt5 = Polar2D(Flag.Gpt4,   270.0, Flag.Fly)
    Flag.Gpt6 = Polar2D(Flag.Gpt1,    90.0, Flag.Fly)
    Flag.Gpt7 = Polar2D(Flag.Gpt3,   270.0, Flag.Fly)
    Flag.Gpt8 = Polar2D(Flag.Gpt2,    90.0, Flag.Fly)
    Flag.Gpt9 = Polar2D(Polar2D(Flag.Gpt1, 90.0,Flag.CentersV), 0.0, Flag.CentersH)

    Flag.Gpt10 =  Polar2D(Flag.Gpt6,   0.0, Flag.CenterEnd1)
    Flag.Gpt11 =  Polar2D(Flag.Gpt8, 180.0, Flag.CenterEnd2)
    Flag.Gpt12 =  Polar2D(Flag.Gpt5,   0.0, Flag.CenterEnd1)
    Flag.Gpt13 =  Polar2D(Flag.Gpt7, 180.0, Flag.CenterEnd2)

    Flag.Gpt14 = Polar2D(Flag.Gpt9,     22.5, Flag.CenterOutRadius)
    Flag.Gpt15 = Polar2D(Flag.Gpt9,     22.5, Flag.CenterInRadius)
    Flag.Gpt16 = Polar2D(Flag.Gpt9,    337.5, Flag.CenterInRadius)
    Flag.Gpt17 = Polar2D(Flag.Gpt9,    337.5, Flag.CenterOutRadius)
    Boxer0(job, Flag.Gpt1, Flag.Gpt2, Flag.Gpt3, Flag.Gpt4, "Colorado Flag Border")
    Boxer1(job, Flag.Gpt1, Flag.Gpt2, Flag.Gpt8, Flag.Gpt11, Flag.Gpt10, Flag.Gpt6, "Blue Stripe Bottom")
    Boxer2(job, Flag.Gpt6, Flag.Gpt10, Flag.Gpt12, Flag.Gpt5, "White Stripe Left")
    Boxer3(job, Flag.Gpt5, Flag.Gpt12, Flag.Gpt13, Flag.Gpt7, Flag.Gpt3, Flag.Gpt4, "Blue Stripe Top")

    Boxer4(job, Flag.Gpt11, Flag.Gpt8, Flag.Gpt7, Flag.Gpt13, Flag.Gpt14, Flag.Gpt15, Flag.Gpt16, Flag.Gpt17,  "White Stripe Right")
    Doters(job, Flag.Gpt9)
    Cers(job, Flag.Gpt9)
  end
  return true
end  -- function end
-- ===================================================