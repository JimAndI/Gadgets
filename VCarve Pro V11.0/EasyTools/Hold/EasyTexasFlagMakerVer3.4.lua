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

-- Easy Texas Flag Maker is written by JimAndI Gadgets of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {}
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 3.40)"
Flag.FlyFlag = 1.5
Flag.FlyLone = 0.5
Flag.LoneStarCentersV = 0.5
Flag.LoneStarCentersH = 0.25
Flag.LoneStarDia = 0.37
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
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
function TexasFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("TexasFlagBorder")
  line:AppendPoint(Flag.Gpt1)
  line:LineTo(Flag.Gpt2)
  line:LineTo(Flag.Gpt3)
  line:LineTo(Flag.Gpt4)
  line:LineTo(Flag.Gpt1)
  layer:AddObject(CreateCadContour(line), true)
-- ======
  job:Refresh2DView()
  return true
end
-- ===================================================
function Stripe(job, p1, p2, p3, p4, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer) ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ;
  line:LineTo(p4) ; line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true) ;
  return true
end
-- ===================================================
function DrawStar(job, pt1)

  local p1 =  Polar2D(pt1,  18.0,  Flag.StarOutRadius)
  local p2 =  Polar2D(pt1,  54.0,  Flag.StarInRadius)
  local p3 =  Polar2D(pt1,  90.0,  Flag.StarOutRadius)
  local p4 =  Polar2D(pt1,  126.0, Flag.StarInRadius)
  local p5 =  Polar2D(pt1,  162.0, Flag.StarOutRadius)
  local p6 =  Polar2D(pt1,  198.0, Flag.StarInRadius)
  local p7 =  Polar2D(pt1,  234.0, Flag.StarOutRadius)
  local p8 =  Polar2D(pt1,  270.0, Flag.StarInRadius)
  local p9 =  Polar2D(pt1,  306.0, Flag.StarOutRadius)
  local p0 =  Polar2D(pt1,  342.0, Flag.StarInRadius)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("LoneStar")
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ; line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p9) ; line:LineTo(p0) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function DrawLone(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Lone")
  line:AppendPoint(Flag.Gpt1)
  line:LineTo(Flag.Gpt5)
  line:LineTo(Flag.Gpt6)
  line:LineTo(Flag.Gpt4)
  line:LineTo(Flag.Gpt1)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ===================================================
function DrawStripes(job)
  Stripe(job, Flag.Gpt6, Flag.Gpt3, Flag.Gpt8, Flag.Gpt7,"Stripe-White")
  Stripe(job, Flag.Gpt5, Flag.Gpt2, Flag.Gpt8, Flag.Gpt7, "Stripe-Red")
  job:Refresh2DView()
  return true
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
    Flag.Inquiry = InquiryNumberBox("Texas Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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
    Flag.FlyLone = Flag.FlyLone * Flag.HoistFlag ;
    Flag.LoneStarCentersV = Flag.LoneStarCentersV * Flag.HoistFlag ;
    Flag.LoneStarCentersH = Flag.LoneStarCentersH * Flag.HoistFlag ;
    Flag.LoneStarDia = Flag.LoneStarDia * Flag.HoistFlag ;
    Flag.StarOutRadius = 0.5 * Flag.LoneStarDia
    Flag.StarInRadius = Flag.LoneStarDia * 0.190983
-- ======
    Flag.Gpt1 = Point2D(1, 1)
    Flag.Gpt2 = Polar2D(Flag.Gpt1,    0.0, Flag.FlyFlag)
    Flag.Gpt3 = Polar2D(Flag.Gpt2,   90.0, Flag.HoistFlag)
    Flag.Gpt4 = Polar2D(Flag.Gpt1,   90.0, Flag.HoistFlag)
    Flag.Gpt5 = Polar2D(Flag.Gpt1,    0.0, Flag.FlyLone)
    Flag.Gpt6 = Polar2D(Flag.Gpt4,    0.0, Flag.FlyLone)
    Flag.Gpt7 = Polar2D(Flag.Gpt5,   90.0, Flag.LoneStarCentersV)
    Flag.Gpt8 = Polar2D(Flag.Gpt2,   90.0, Flag.LoneStarCentersV)
    Flag.Gpt9 = Polar2D(Flag.Gpt7,  180.0, Flag.LoneStarCentersH)
    TexasFlag(job)
    DrawLone(job)
    DrawStripes(job)
    DrawStar(job, Flag.Gpt9)
  end
  return true
end  -- function end
-- ===================================================