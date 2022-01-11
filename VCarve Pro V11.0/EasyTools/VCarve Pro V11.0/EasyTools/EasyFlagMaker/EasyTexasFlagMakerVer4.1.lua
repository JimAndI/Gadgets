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
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 4.10)"
Flag.FlyFlag = 1.5
Flag.FlyLone = 0.5
Flag.LoneStarCentersV = 0.5
Flag.LoneStarCentersH = 0.25
Flag.LoneStarDia = 0.37
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.Texas = [[data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAABDgAAALQCAYAAAB118BaAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N1plNX1ne/7b1GgKIqiGHAeUMQBKBAnMCrKFEeg0HRM1HVje7Rzzz3Qvc46uta9awW6GbSjSYOQnKN9TxKIt9eF9DkrBjKYbkhsk6BJNB0xzlFoBQVBwyAFVLHvgxO9nTgx1N6//d31ej2KUrX/H1Llg3rX/v3/TTHo9koAUHcqz3yt9AQAAEijW+kBAAAAAPtL4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2BAwAAAEhP4AAAAADSEzgAAACA9AQOAAAAID2Bg4YxsuWUuLDllNIzAAAAKKB76QHQWf63ySNjd6US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']]
-- ===================================================]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Texas ..[[" width="260" height="140">
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
  local dialog = HTML_Dialog(true, myHtml, 300, 270, Header .. " " .. Flag.Version) ;
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
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ;
  line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p9) ; line:LineTo(p0) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
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