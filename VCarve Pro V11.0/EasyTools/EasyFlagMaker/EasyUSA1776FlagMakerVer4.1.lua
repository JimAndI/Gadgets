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

-- Easy Flag Maker is written by JimAndi Gadgets of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag         = {}
local DialogWindow = {}
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 4.10)"
Flag.HoistUnion = 0.5385
Flag.FlyFlag = 1.9
Flag.FlyUnion = 0.76
Flag.UnionStarCentersV = 0.054
Flag.UnionStarCentersH = 0.063
Flag.StarDia = 0.0616
Flag.Strip = 0.0769 ;
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.US1776 = [[data:image/png;base64,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]]
-- =====================================================]]
function InquiryNumberBox(Header, Quest, Defaltxt)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
  local myHtml = [[<!DOCTYPE html>
<html lang="en">
<title>Easy Flag Maker</title>
<style>
html {
	overflow: hidden;
}
.FormButton {
	font-weight: bold;
	width: 75px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.h1-r {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	text-align: right;
}
.mypush {
	text-align: right;
	width:100%;
}
.myimg {
	text-align: center;
  white-space: nowrap;

}
body {
	overflow: hidden;
	background-color: #CCC;
}
table {
	width: 100%;
	border: 0;
}
</style>
</head>
<body>
<table>
  <tr>
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.US1776 ..[[" width="260" height="150">
  </tr>
  <tr>
    <td class="h1-r"><label id="QuestionID" for="qInput">Your Message</label>
      <input type="text" id="qInput"  size="10" maxlength="10"  /></td>
</table>
<table>
  <tr>
    <td class="mypush">&nbsp;</td>
    <td><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td>
    <td><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td>
  </tr>
</table>
</body>
</html>]]
  local dialog = HTML_Dialog(true, myHtml, 300, 280, Header .. " " .. Flag.Version) ;
  dialog:AddLabelField("QuestionID", Quest) ;
  dialog:AddDoubleField("qInput", Defaltxt) ;
  if not dialog:ShowDialog() then
  -- DisplayMessageBox(tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight))
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return false
  else
  -- DisplayMessageBox(tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight))
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return true
  end

end
-- =====================================================]]

-- ===================================================
function USAFlag(job)
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
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Draw1776(job)
  local pt  = Polar2D(Flag.Gpt1, 90.0,   Flag.UnionStarCentersV ) ;
  pt  = Polar2D(pt, 0.0,   Flag.UnionStarCentersH ) ;
-- One
  local p1 = Polar2D(pt, 157.59675030,  0.103424545 * Flag.HoistFlag) ;
  local p2 = Polar2D(pt, 158.94801600, 0.10582824320 * Flag.HoistFlag) ;
  local p3 = Polar2D(pt, 164.34495690, 0.1117612657 * Flag.HoistFlag) ;
  local p5 = Polar2D(pt, 166.36014330,  0.1065955712 * Flag.HoistFlag) ;
  local p4 = Polar2D(pt, 165.47720521,  0.1113054336 * Flag.HoistFlag) ;
  local p8 = Polar2D(pt, 193.81529840, 0.095299000 * Flag.HoistFlag) ;
  local p6 = Polar2D(pt, 194.76268020, 0.107472000 * Flag.HoistFlag) ;
  local p7 = Polar2D(pt, 194.14279560, 0.101076000 * Flag.HoistFlag) ;
  local line = Contour(0.0) ;
  local layer = job.LayerManager:GetLayerWithName("Layer 1776") ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ;
  line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ; line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
-- 7
   pt  = Polar2D(Flag.Gpt1, 90.0,   Flag.UnionStarCentersV ) ;
  pt  = Polar2D(pt, 0.0,   Flag.UnionStarCentersH ) ;
   p1 = Polar2D(pt, 104.2757660,  0.0438120932 * Flag.HoistFlag) ;
   p2 = Polar2D(pt, 110.0590067, 0.0441714166 * Flag.HoistFlag) ;
   p3 = Polar2D(pt, 116.8165261, 0.0416502729 * Flag.HoistFlag) ;
   p4 = Polar2D(pt, 140.9312220,  0.0589779582 * Flag.HoistFlag) ;
   p5 = Polar2D(pt, 153.1843685,  0.0639054076 * Flag.HoistFlag) ;
   p6 = Polar2D(pt, 154.6983519, 0.0591756975 * Flag.HoistFlag) ;
   p7 = Polar2D(pt, 148.6776939, 0.0554563398 * Flag.HoistFlag) ;
   p8 = Polar2D(pt, 131.3526538, 0.0384051077 * Flag.HoistFlag) ;
  local p9 = Polar2D(pt, 215.3195795, 0.0767201098 * Flag.HoistFlag) ;
  local p0 = Polar2D(pt, 218.7877929, 0.0707847163 * Flag.HoistFlag) ;
   line = Contour(0.0) ;
   layer = job.LayerManager:GetLayerWithName("Layer 1776") ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ;
  line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ; line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p9) ; line:LineTo(p0) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
-- 7
  pt  = Polar2D(pt, 0.0,   0.06 * Flag.HoistFlag) ;
   p1 = Polar2D(pt, 104.2757660,  0.0438120932 * Flag.HoistFlag) ;
   p2 = Polar2D(pt, 110.0590067, 0.0441714166 * Flag.HoistFlag) ;
   p3 = Polar2D(pt, 116.8165261, 0.0416502729 * Flag.HoistFlag) ;
   p4 = Polar2D(pt, 140.9312220,  0.0589779582 * Flag.HoistFlag) ;
   p5 = Polar2D(pt, 153.1843685,  0.0639054076 * Flag.HoistFlag) ;
   p6 = Polar2D(pt, 154.6983519, 0.0591756975 * Flag.HoistFlag) ;
   p7 = Polar2D(pt, 148.6776939, 0.0554563398 * Flag.HoistFlag) ;
   p8 = Polar2D(pt, 131.3526538, 0.0384051077 * Flag.HoistFlag) ;
   p9 = Polar2D(pt, 215.3195795, 0.0767201098 * Flag.HoistFlag) ;
   p0 = Polar2D(pt, 218.7877929, 0.0707847163 * Flag.HoistFlag) ;
   line = Contour(0.0) ;
   layer = job.LayerManager:GetLayerWithName("Layer 1776") ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ;
  line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ;
  line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p9) ;
  line:LineTo(p0) ; line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true) ;
-- 6

  pt  = Polar2D(Flag.Gpt1, 90.0,   Flag.UnionStarCentersV ) ;
  pt  = Polar2D(pt, 0.0,   Flag.UnionStarCentersH ) ;
   p1 = Polar2D(pt, 26.5171269,  0.11785664462 * Flag.HoistFlag) ;
   p2 = Polar2D(pt, 359.7189667, 0.0640478017 * Flag.HoistFlag) ;
   p3 = Polar2D(pt, 338.582975, 0.0753565933 * Flag.HoistFlag) ;
   p4 = Polar2D(pt, 345.0368666, 0.1008551051 * Flag.HoistFlag) ;
   p5 = Polar2D(pt, 356.8710637,  0.1063975830 * Flag.HoistFlag) ;
   p6 = Polar2D(pt, 5.2691694, 0.09872315 * Flag.HoistFlag) ;
   p7 = Polar2D(pt, 4.5829818, 0.075643736 * Flag.HoistFlag) ;
   p8 = Polar2D(pt, 1.9487271, 0.0774209866* Flag.HoistFlag) ;
   p9 = Polar2D(pt, 353.9353459, 0.09677705316 * Flag.HoistFlag) ;
  local p10 = Polar2D(pt, 349.519816, 0.0739631966 * Flag.HoistFlag) ;
  local p11 = Polar2D(pt, 2.8612958,  0.0728759141 * Flag.HoistFlag) ;
  local p12 = Polar2D(pt, 23.3642826, 0.1152680889 * Flag.HoistFlag) ;
   line = Contour(0.0) ;
   layer = job.LayerManager:GetLayerWithName("Layer 1776") ;
  line:AppendPoint(p1) ;
  line:ArcTo(p2, 0.004 * Flag.HoistFlag) ;
  line:ArcTo(p3, 0.01 * Flag.HoistFlag) ;
  line:ArcTo(p4,  0.008 * Flag.HoistFlag) ;
  line:ArcTo(p5,  0.008 * Flag.HoistFlag) ;
  line:ArcTo(p6, 0.008 * Flag.HoistFlag) ;
  line:ArcTo(p7, 0.008 * Flag.HoistFlag) ;
  line:ArcTo(p8, 0.025 * Flag.HoistFlag) ;
  line:ArcTo(p9, -0.025 * Flag.HoistFlag) ;
  line:ArcTo(p10, -0.02 * Flag.HoistFlag) ;
  line:ArcTo(p11, -0.008 * Flag.HoistFlag) ;
  line:ArcTo(p12,  -0.004 * Flag.HoistFlag) ;
  line:ArcTo(p1, 0.02 * Flag.HoistFlag) ;
  layer:AddObject(CreateCadContour(line), true)

  return true
end
-- ===================================================
function Star(job, pt1, ang)
  local p1 = Polar2D(pt1, (ang + 0.0), Flag.StarOutRadius) ;
  local p2 = Polar2D(pt1, (ang + 36.0), Flag.StarInRadius) ;
  local p3 = Polar2D(pt1, (ang + 72.0), Flag.StarOutRadius) ;
  local p4 = Polar2D(pt1, (ang + 108.0), Flag.StarInRadius) ;
  local p5 = Polar2D(pt1, (ang + 144.0), Flag.StarOutRadius) ;
  local p6 = Polar2D(pt1,(ang +  180.0), Flag.StarInRadius) ;
  local p7 = Polar2D(pt1, (ang + 216.0), Flag.StarOutRadius) ;
  local p8 = Polar2D(pt1, (ang + 252.0),  Flag.StarInRadius) ;
  local p9 = Polar2D(pt1, (ang + 288.0), Flag.StarOutRadius) ;
  local p0 = Polar2D(pt1, (ang + 324.0),  Flag.StarInRadius) ;
  local line = Contour(0.0) ;
  local layer = job.LayerManager:GetLayerWithName("Stars") ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ;
  line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ;
  line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p9) ;
  line:LineTo(p0) ; line:LineTo(p1) ;
  layer:AddObject(CreateCadContour(line), true) ;
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
  local StepAng =  27.692307 ;
  local StartAng = 6.92308 ;
  local StarAng = 11.57398 ;

  local   pt1  = Polar2D(Flag.Gpt1, 90.0,   Flag.UnionStarCentersV ) ;
  pt1  = Polar2D(pt1, 0.0,   Flag.UnionStarCentersH ) ;

  for _ = 13, 1 , -1     do
    Star(job, Polar2D(pt1, StartAng, Flag.StarsRadius) , StartAng) ;
    StartAng = StartAng + StepAng
    StarAng = StarAng + StarAng
  end

  job:Refresh2DView()
  return true
end
-- ===================================================
function DrawStripes(job)
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
    Flag.UnionStarCentersV = 0.731297 * Flag.HoistFlag ;
    Flag.UnionStarCentersH = 0.380914 * Flag.HoistFlag ;
    Flag.StarsRadius = (0.169363 * Flag.HoistFlag )
    Flag.StarDia = 0.064 * Flag.HoistFlag ;
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

    USAFlag(job)
    DrawUnion(job)
    DrawStripes(job)
    DrawStars(job)
    Draw1776(job)
  end
  return true
end  -- function end
-- ===================================================