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

-- Easy USA Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {}
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 3.40)"
Flag.HoistUnion = 0.5385
Flag.FlyFlag = 1.9
Flag.FlyUnion = 0.76
Flag.UnionStarCentersV = 0.054
Flag.UnionStarCentersH = 0.063
Flag.StarDia = 0.0616
Flag.Strip = 0.0769
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  ===================================================
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
function USA_AirForceFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Hoist")
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
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ;
  line:LineTo(p2) ;
  line:LineTo(p3) ;
  line:LineTo(p4) ;
  line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Star(job, pt1)
  local p1 =  Polar2D(pt1,  18.0,  Flag.StarOutRadius) ;
  local p2 =  Polar2D(pt1,  54.0, Flag.StarInRadius) ;
  local p3 =  Polar2D(pt1,  90.0, Flag.StarOutRadius) ;
  local p4 =  Polar2D(pt1,  126.0, Flag.StarInRadius) ;
  local p5 =  Polar2D(pt1,  162.0, Flag.StarOutRadius) ;
  local p6 =  Polar2D(pt1,  198.0, Flag.StarInRadius) ;
  local p7 =  Polar2D(pt1,  234.0,Flag.StarOutRadius) ;
  local p8 =  Polar2D(pt1,  270.0, Flag.StarInRadius) ;
  local p9 =  Polar2D(pt1,  306.0, Flag.StarOutRadius) ;
  local p0 =  Polar2D(pt1,  342.0, Flag.StarInRadius) ;
  local line = Contour(0.0) ;
  local layer = job.LayerManager:GetLayerWithName("Stars") ;
  line:AppendPoint(p1) ;
  line:LineTo(p2) ;
  line:LineTo(p3) ;
  line:LineTo(p4) ;
  line:LineTo(p5) ;
  line:LineTo(p6) ;
  line:LineTo(p7) ;
  line:LineTo(p8) ;
  line:LineTo(p9) ;
  line:LineTo(p0) ;
  line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function DrawUnion(job)
  local pt1 =  Flag.Gpt4
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
function DrawStars(job)
  local pt1 =  Flag.Gpt4
  local pt2 =  Flag.Gpt4
  for _ = 5, 1 , -1     do
    pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV)
    pt2 = Polar2D(pt1,      0.0, Flag.UnionStarCentersH)
    for _ = 6, 1 , -1     do
      Star(job, pt2)
      pt2 =  Polar2D(pt2,  0.0, Flag.UnionStarCentersH * 2.0)
    end
    pt1 =  Polar2D(pt1 ,  270.0, Flag.UnionStarCentersV )
  end
  pt1 = Flag.Gpt4
  pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV )
  for _ = 4, 1 , -1     do
    pt1 = Polar2D(pt1,  270.0, Flag.UnionStarCentersV  )
    pt2 = Polar2D(pt1,      0.0, Flag.UnionStarCentersH * 2.0)
    for _ = 5, 1 , -1     do
      Star(job, pt2)
      pt2 = Polar2D(pt2,  0.0, Flag.UnionStarCentersH * 2.0)
    end
    pt1 = Polar2D(pt1 ,  270.0, Flag.UnionStarCentersV)
  end
  job:Refresh2DView()
  return true
end
-- ===================================================
function DrawStripesX(job)
  local pt1 =  Flag.Gpt5
  local lay = "Stripe-Red"
  for _ = 7, 1 , -1     do
    local pt2 =  Polar2D(pt1,  0.0, Flag.FlyFlag - Flag.FlyUnion)
    local pt3 =  Polar2D(pt2,  270.0, Flag.Stripe)
    local pt4 =  Polar2D(pt1,  270.0, Flag.Stripe)
    Stripe(job, pt1, pt2, pt3, pt4,lay)
    if lay == "Stripe-Red" then
      lay = "Stripe-White"
    else
      lay = "Stripe-Red"
    end
    pt1 = pt4
  end
  pt1 =  Flag.Gpt6
  lay = "Stripe-White"
  for _ = 6, 1 , -1     do
    local pt2 =  Polar2D(pt1,  0.0, Flag.FlyFlag)
    local pt3 =  Polar2D(pt2,  270.0, Flag.Stripe)
    local pt4 =  Polar2D(pt1,  270.0, Flag.Stripe)
    Stripe(job, pt1, pt2, pt3, pt4, lay)
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
function DrawLogo(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.3103018987827546 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((1.284180734823339 * Flag.HoistFlag) + 1.0 ,(0.2550181565625758 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.1997344143423969 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.394748219263696 * Flag.HoistFlag) + 1.0 ,(0.2550181565625758 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.3103018987827546 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.656823581569366 * Flag.HoistFlag) + 1.0 ,(0.6924 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((1.656823581569366 * Flag.HoistFlag) + 1.0 ,(0.6924 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((1.782402143697018 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.843733987910614 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.831693014995266 * Flag.HoistFlag) + 1.0 ,(0.817862090312707  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.659009262184336 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.656823581569418 * Flag.HoistFlag) + 1.0 ,(0.6923999999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.656823581569366 * Flag.HoistFlag) + 1.0 ,(0.6924 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.41897280180579 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.45652270045518 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.563039737383077 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.569424034763024 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.772307652170651 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.854410353878447 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.351180562733786 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8965268103900171 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8351949661764212 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.019919691902579 * Flag.HoistFlag) + 1.0 ,(0.692400000000089  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.222406253631855 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.115889216703958 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.109504919324011 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.201103209927611 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9066213019163839 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8236142101213267 * Flag.HoistFlag) + 1.0 ,(0.8024183544873236  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8245186002085881 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.32774839135325 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.436959434638927 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043517 * Flag.HoistFlag) + 1.0 ,(0.0294235916434862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.241969519448109 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9270110259548129 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.011664112258414 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.1306083608288 * Flag.HoistFlag) + 1.0 ,(0.3229404435871495 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("AirForceLogo")
  line:AppendPoint((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.322978449817563 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.322978449817563  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.751917928132222 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.667264841828621 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.54854433907339 * Flag.HoistFlag) + 1.0 ,(0.323001200286491 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.322978449817563 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()

  return true
end
-- ===================================================
function DrawStripes(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.838013391249596 * Flag.HoistFlag) + 1.0 ,(0.769300000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.854410353878447 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.806226511077266 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7692999999999999  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.843733987910614 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.753701909387158 * Flag.HoistFlag) + 1.0 ,(0.615499999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.772307652170651 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.72902447667468 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.72902447667468 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.72902447667468 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.647858139702922 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.647858139702922 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.686069911889858 * Flag.HoistFlag) + 1.0 ,(0.5386  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.579912413333534 * Flag.HoistFlag) + 1.0 ,(0.4615000000000006  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.5417390936346 * Flag.HoistFlag) + 1.0 ,(0.4615000000000006 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.647858139702922 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.797544247676556 * Flag.HoistFlag) + 1.0 ,(0.9230999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.782402143697018 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.767260039717473 * Flag.HoistFlag) + 1.0 ,(0.9231000000000005  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9116689143695643 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8965268103900171 * Flag.HoistFlag) + 1.0 ,(0.9547316137502122  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8813847064104682 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.190233752062472 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.190233752062472 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.488695202024561 * Flag.HoistFlag) + 1.0 ,(0.5386  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.382576155956235 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.2963527981308 * Flag.HoistFlag) + 1.0 ,(0.4615000000000005 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.190233752062472 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8762801719802885 * Flag.HoistFlag) + 1.0 ,(0.6924000000000017  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9066213019163839 * Flag.HoistFlag) + 1.0 ,(0.6290178633973333  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9252270446998737 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.9928590421971858 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9928590421971858 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.031070814384109 * Flag.HoistFlag) + 1.0 ,(0.5385999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.137189860452254 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.099016540753501 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9928590421971858 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.949904477412351 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9868123704473551 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.534184833885816 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.534184833885816 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.510791555030611 * Flag.HoistFlag) + 1.0 ,(0.1538999999999997  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.563039737383077 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.569424034763024 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.534184833885816 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.257722129190284 * Flag.HoistFlag) + 1.0 ,(0.230800000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.289759576035693 * Flag.HoistFlag) + 1.0 ,(0.230794015592243  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.293577841127102 * Flag.HoistFlag) + 1.0 ,(0.2241784535311492  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.298243108707986 * Flag.HoistFlag) + 1.0 ,(0.2181811605085455  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.303673998609975 * Flag.HoistFlag) + 1.0 ,(0.2128834465630245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.309789130664699 * Flag.HoistFlag) + 1.0 ,(0.2083666217331786  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.316507124703786 * Flag.HoistFlag) + 1.0 ,(0.2047119960576003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.323746600558865 * Flag.HoistFlag) + 1.0 ,(0.2020008795748823  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.331426178061566 * Flag.HoistFlag) + 1.0 ,(0.200314582323617  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.1997344143423969  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.347502776025471 * Flag.HoistFlag) + 1.0 ,(0.2003145823236173  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.355182353528173 * Flag.HoistFlag) + 1.0 ,(0.2020008795748832  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.362421829383254 * Flag.HoistFlag) + 1.0 ,(0.2047119960576021  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.369139823422341 * Flag.HoistFlag) + 1.0 ,(0.2083666217331813  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.375254955477065 * Flag.HoistFlag) + 1.0 ,(0.2128834465630282  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.380685845379055 * Flag.HoistFlag) + 1.0 ,(0.2181811605085502  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.385351112959939 * Flag.HoistFlag) + 1.0 ,(0.2241784535311546  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.389169378051347 * Flag.HoistFlag) + 1.0 ,(0.2307940155922488  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.421206824896839 * Flag.HoistFlag) + 1.0 ,(0.2308000000000008  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.41897280180579 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.44361621626456 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.363465656973078 * Flag.HoistFlag) + 1.0 ,(0.1539000000000004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.171418156562575  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.315463297113959 * Flag.HoistFlag) + 1.0 ,(0.153900000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.235312737822475 * Flag.HoistFlag) + 1.0 ,(0.1539000000000004 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.259956152281245 * Flag.HoistFlag) + 1.0 ,(0.2291843358328294 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.144744120201222 * Flag.HoistFlag) + 1.0 ,(0.2307999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.109504919324011 * Flag.HoistFlag) + 1.0 ,(0.2051972219097862  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.115889216703958 * Flag.HoistFlag) + 1.0 ,(0.1918605264900446  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.168137399056425 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.27398116874066 * Flag.HoistFlag) + 1.0 ,(0.0769999999999982  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043517 * Flag.HoistFlag) + 1.0 ,(0.0294235916434855  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.404947785346376 * Flag.HoistFlag) + 1.0 ,(0.0770000000000011  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.0001000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0001000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.045963222162171 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.1306083608288 * Flag.HoistFlag) + 1.0 ,(0.3229404435871495  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.289764304064542 * Flag.HoistFlag) + 1.0 ,(0.3229638367399057  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.204898663178675 * Flag.HoistFlag) + 1.0 ,(0.3845999999999998  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.243033630136674 * Flag.HoistFlag) + 1.0 ,(0.3845999999999996  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.297533998503133 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.310304173943993 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.368624780143042 * Flag.HoistFlag) + 1.0 ,(0.3846000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.381394955583902 * Flag.HoistFlag) + 1.0 ,(0.3450031645898077  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.435895323950362 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.474030290908362 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.38918477048644 * Flag.HoistFlag) + 1.0 ,(0.3229784498175632  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.54854433907339 * Flag.HoistFlag) + 1.0 ,(0.323001200286491  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.548696910628449 * Flag.HoistFlag) + 1.0 ,(0.3230018953250635  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.548194786879353 * Flag.HoistFlag) + 1.0 ,(0.32285702876759  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.632962477709387 * Flag.HoistFlag) + 1.0 ,(0.3845999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.355974048345025 * Flag.HoistFlag) + 1.0 ,(0.3077445617544825  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.351995768300622 * Flag.HoistFlag) + 1.0 ,(0.3088526571108061  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.347909589755614 * Flag.HoistFlag) + 1.0 ,(0.3096530182203129  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.343728247679935 * Flag.HoistFlag) + 1.0 ,(0.3101384853539724  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.339464477043518 * Flag.HoistFlag) + 1.0 ,(0.3103018987827546  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.335149835947777 * Flag.HoistFlag) + 1.0 ,(0.3101356578482816  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.330925877439079 * Flag.HoistFlag) + 1.0 ,(0.3096436681408907  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.326804842503671 * Flag.HoistFlag) + 1.0 ,(0.3088360293046244  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.322798972127803 * Flag.HoistFlag) + 1.0 ,(0.3077228409835251  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.9484810670855984 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9484810670855984 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.730447887001434 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.693635734285402 * Flag.HoistFlag) + 1.0 ,(0.7692999999999994  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9852932198016325 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9484810670855984 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8445725536944323 * Flag.HoistFlag) + 1.0 ,(0.8461999999999992  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8351949661764212 * Flag.HoistFlag) + 1.0 ,(0.8266103692142681  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9140759222184739 * Flag.HoistFlag) + 1.0 ,(0.7692999999999959  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8727024430097631 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8245186002085881 * Flag.HoistFlag) + 1.0 ,(0.8043076109577858  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8236142101213281 * Flag.HoistFlag) + 1.0 ,(0.802418354487322  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.839468019264266 * Flag.HoistFlag) + 1.0 ,(0.7692999999999963  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-Red")
  line:AppendPoint((0.9785462126940035 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9785462126940035 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.700382741393033 * Flag.HoistFlag) + 1.0 ,(0.6923999999999999  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.594538971708796 * Flag.HoistFlag) + 1.0 ,(0.6155000000000004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.08438998237824 * Flag.HoistFlag) + 1.0 ,(0.6154999999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9785462126940035 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.838013391249593 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.838013391249593 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.801994754397191 * Flag.HoistFlag) + 1.0 ,(0.692399999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.838013391249593 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.806226511077269 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.700382741393029 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.659009262184336 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.764853031868567 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.753701909387162 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.753701909387162 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.729024476674679 * Flag.HoistFlag) + 1.0 ,(0.5386000000000004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.751917928132222 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.68606991188985 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.647858139702928 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.753701909387162 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.632962477709389 * Flag.HoistFlag) + 1.0 ,(0.3845999999999987  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.667264841828621 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.692116583639499 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.541739093634598 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.541739093634598 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.579912413333535 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.474030290908362 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.435895323950364 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.541739093634598 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.9852932198014487 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9852932198014487 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.6936357342854 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.656823581569416 * Flag.HoistFlag) + 1.0 ,(0.6923999999999999  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.022105372517486 * Flag.HoistFlag) + 1.0 ,(0.6923999999999997 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9852932198014487 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8813847064102834 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8445725536942498 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.084389982378054 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.084389982378054 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.594538971708796 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.488695202024562 * Flag.HoistFlag) + 1.0 ,(0.5386  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.19023375206229 * Flag.HoistFlag) + 1.0 ,(0.5386 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.084389982378054 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.872702443009589 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.872702443009589 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9140759222182827 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.019919691902515 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9785462126938206 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.872702443009589 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.296352798130616 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.296352798130616 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.382576155956237 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.351180562733786 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.368624780143041 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.310304173943811 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.327748391353067 * Flag.HoistFlag) + 1.0 ,(0.4386897663319345 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.296352798130616 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.099016540753314 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.099016540753314 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.137189860452254 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.243033630136488 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.204898663178488 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.099016540753314 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9252270446996943 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.031070814383926 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9928590421969968 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9270110259546299 * Flag.HoistFlag) + 1.0 ,(0.5864240550251245  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9499044774121842 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.5386000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6155000000000002 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9868123704473551 * Flag.HoistFlag) + 1.0 ,(0.4615  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.011664112258231 * Flag.HoistFlag) + 1.0 ,(0.4095851076545642  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.045966476377473 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3846000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.4615 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.363465656973077 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.363465656973077 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.443616216264561 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.45652270045518 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.51079155503061 * Flag.HoistFlag) + 1.0 ,(0.1538999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.40494778534638 * Flag.HoistFlag) + 1.0 ,(0.077000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.436959434638927 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.363465656973077 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.322913598076201 * Flag.HoistFlag) + 1.0 ,(0.307744481707503  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.318733548120583 * Flag.HoistFlag) + 1.0 ,(0.3062571638436854  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.31472418508491 * Flag.HoistFlag) + 1.0 ,(0.3044550190142494  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.310899168340366 * Flag.HoistFlag) + 1.0 ,(0.3023538507844633  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.307272157258138 * Flag.HoistFlag) + 1.0 ,(0.2999694627195956  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.30385681120941 * Flag.HoistFlag) + 1.0 ,(0.2973176583849146  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.300666789565367 * Flag.HoistFlag) + 1.0 ,(0.2944142413456888  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.297715751697196 * Flag.HoistFlag) + 1.0 ,(0.2912750151671867  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.29501735697608 * Flag.HoistFlag) + 1.0 ,(0.2879157834146766  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.292585264773206 * Flag.HoistFlag) + 1.0 ,(0.2843523496534268  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.290433134459759 * Flag.HoistFlag) + 1.0 ,(0.280600517448706  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.288574625406923 * Flag.HoistFlag) + 1.0 ,(0.2766760903657823  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.287023396985885 * Flag.HoistFlag) + 1.0 ,(0.2725948719699243  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.285793108567828 * Flag.HoistFlag) + 1.0 ,(0.2683726658264004  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.28489741952394 * Flag.HoistFlag) + 1.0 ,(0.2640252755004789  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.284349989225404 * Flag.HoistFlag) + 1.0 ,(0.2595685045574284  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.284164477043407 * Flag.HoistFlag) + 1.0 ,(0.2550181565625171  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.284533542987333 * Flag.HoistFlag) + 1.0 ,(0.2485947923018626  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.285613413568623 * Flag.HoistFlag) + 1.0 ,(0.242388583274863  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.287363097911538 * Flag.HoistFlag) + 1.0 ,(0.2364410934646564  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.289741605140342 * Flag.HoistFlag) + 1.0 ,(0.2307938868543813  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.257722129190099 * Flag.HoistFlag) + 1.0 ,(0.2308000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.201103209927428 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.144744120201038 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.168137399056242 * Flag.HoistFlag) + 1.0 ,(0.1538999999999995  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.222406253631672 * Flag.HoistFlag) + 1.0 ,(0.1144713692048107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.235312737822289 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.315463297113777 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.241969519447926 * Flag.HoistFlag) + 1.0 ,(0.1002578246026293  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.273981168740472 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0770000000000002 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.1539000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.355841812466592 * Flag.HoistFlag) + 1.0 ,(0.3077732437070635 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.355841812466592 * Flag.HoistFlag) + 1.0 ,(0.3077732437070635  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.3077000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.2308000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.534184833885811 * Flag.HoistFlag) + 1.0 ,(0.2308000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.477825744159424 * Flag.HoistFlag) + 1.0 ,(0.2717472755258918  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.421206824896753 * Flag.HoistFlag) + 1.0 ,(0.2308000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.389187348941953 * Flag.HoistFlag) + 1.0 ,(0.2307938868497543  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.391565856172656 * Flag.HoistFlag) + 1.0 ,(0.2364410934592643  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.393315540516992 * Flag.HoistFlag) + 1.0 ,(0.2423885832703107  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394395411099171 * Flag.HoistFlag) + 1.0 ,(0.2485947922992696  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394764477043406 * Flag.HoistFlag) + 1.0 ,(0.2550181565625171  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394576859570537 * Flag.HoistFlag) + 1.0 ,(0.2595983680874002  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.394023494035761 * Flag.HoistFlag) + 1.0 ,(0.2640804765670942  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.393118610764824 * Flag.HoistFlag) + 1.0 ,(0.2684488464090439  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.391876440083473 * Flag.HoistFlag) + 1.0 ,(0.2726878420206942  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.390311212317453 * Flag.HoistFlag) + 1.0 ,(0.2767818278094899  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.388437157792511 * Flag.HoistFlag) + 1.0 ,(0.2807151681828759  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.386268506834394 * Flag.HoistFlag) + 1.0 ,(0.2844722275482969  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.383819489768848 * Flag.HoistFlag) + 1.0 ,(0.2880373703131979  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.381104336921619 * Flag.HoistFlag) + 1.0 ,(0.2913949608850236  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.378137278618453 * Flag.HoistFlag) + 1.0 ,(0.2945293636712189  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.374932545185098 * Flag.HoistFlag) + 1.0 ,(0.2974249430792286  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.371504366947299 * Flag.HoistFlag) + 1.0 ,(0.3000660635164977  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.367866974230802 * Flag.HoistFlag) + 1.0 ,(0.3024370893904709  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.364034597361355 * Flag.HoistFlag) + 1.0 ,(0.304522385108593  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.360021466664702 * Flag.HoistFlag) + 1.0 ,(0.3063063150783089 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.355841812466592 * Flag.HoistFlag) + 1.0 ,(0.3077732437070635 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.839468019264266 * Flag.HoistFlag) + 1.0 ,(0.7693000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8762801719802865 * Flag.HoistFlag) + 1.0 ,(0.6924000000000019  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.6924000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7600000000000001 * Flag.HoistFlag) + 1.0 ,(0.7693000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((0.9116689143693836 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9116689143693836 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.767260039717482 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.730447887001443 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.948481067085417 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9116689143693836 * Flag.HoistFlag) + 1.0 ,(0.9231000000000003 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stripe-White")
  line:AppendPoint((1.797544247676569 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.797544247676569 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.9231  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.9 * Flag.HoistFlag) + 1.0 ,(0.8462000000000001  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.834356400392603 * Flag.HoistFlag) + 1.0 ,(0.8461999999999998 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.797544247676569 * Flag.HoistFlag) + 1.0 ,(0.9231 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
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
    Flag.Inquiry = InquiryNumberBox("USA Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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
    Flag.HoistUnion = 0.5385 * Flag.HoistFlag ;
    Flag.FlyFlag = 1.9 * Flag.HoistFlag ;
    Flag.FlyUnion = 0.76 * Flag.HoistFlag ;
    Flag.UnionStarCentersV = 0.054 * Flag.HoistFlag ;
    Flag.UnionStarCentersH = 0.063 * Flag.HoistFlag ;
    Flag.StarDia = 0.0616 * Flag.HoistFlag ;
    Flag.StarOutRadius = 0.5 * Flag.StarDia
    Flag.StarInRadius = Flag.StarDia * 0.190983
    Flag.Stripe = 0.0769 * Flag.HoistFlag ;
-- ======
    Flag.Gpt1 = Point2D(1, 1)
    Flag.Gpt2 = Polar2D(Flag.Gpt1,  0.0, Flag.FlyFlag)
    Flag.Gpt3 = Polar2D(Flag.Gpt2,  90.0, Flag.HoistFlag)
    Flag.Gpt4 = Polar2D(Flag.Gpt1,  90.0, Flag.HoistFlag)
    Flag.Gpt5 = Polar2D(Flag.Gpt4,   0.0, Flag.FlyUnion)
    Flag.Gpt6 = Polar2D(Flag.Gpt4,  270.0, Flag.HoistUnion)
    USA_AirForceFlag(job)
    DrawUnion(job)
    DrawStripes(job)
    DrawLogo(job)
    DrawStars(job)
  end
  return true

end  -- function end
-- ===================================================