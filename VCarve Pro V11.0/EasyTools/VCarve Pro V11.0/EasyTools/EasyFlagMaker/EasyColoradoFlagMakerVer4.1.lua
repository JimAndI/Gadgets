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
local Flag = {}
local DialogWindow = {}
Flag.HoistFlag = 30.0
Flag.Gpt1 =  Point2D(1.0, 1.0)
Flag.Version = "(Ver: 4.10)"
Flag.FlyFlag = 1.5
Flag.Fly = 0.3333
Flag.CentersV = 0.5
Flag.CentersH = 0.635
Flag.CenterEnd1 = 0.346393
Flag.CenterEnd2 = 0.576408
Flag.CenterInRadius = 0.165
Flag.CenterOutRadius = 0.3333
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.Colorado = [[data:image/png;base64,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]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Colorado ..[[" width="260" height="130">
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
  local dialog = HTML_Dialog(true, myHtml, 300, 260, Header .. " " .. Flag.Version) ;
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
-- ===================================================]]
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
function GetDistance(objA, objB)
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt( (xDist ^ 2) + (yDist ^ 2))
end
-- ===================================================
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
"Select: 'Create a new file' under 'Startup Tasks' and \n" ..
"specify the material dimensions \n"
    )
    return false
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
    Flag.FlyFlag = Flag.FlyFlag * Flag.HoistFlag
    Flag.Fly = Flag.Fly * Flag.HoistFlag
    Flag.CentersV = Flag.CentersV * Flag.HoistFlag
    Flag.CentersH = Flag.CentersH * Flag.HoistFlag
    Flag.CenterInRadius = Flag.CenterInRadius * Flag.HoistFlag
    Flag.CenterOutRadius = Flag.CenterOutRadius * Flag.HoistFlag
    Flag.CenterEnd1 = Flag.CenterEnd1 * Flag.HoistFlag
    Flag.CenterEnd2 = Flag.CenterEnd2 * Flag.HoistFlag
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