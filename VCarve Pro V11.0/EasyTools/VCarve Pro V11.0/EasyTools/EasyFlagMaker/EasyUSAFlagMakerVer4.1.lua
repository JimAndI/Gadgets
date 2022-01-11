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
Flag.Strip = 0.0769
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.USA = [[data:image/png;base64,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]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.USA ..[[" width="260" height="150">
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
  local p1 =  Polar2D(pt1,   18.0, Flag.StarOutRadius) ;
  local p2 =  Polar2D(pt1,   54.0, Flag.StarInRadius) ;
  local p3 =  Polar2D(pt1,   90.0, Flag.StarOutRadius) ;
  local p4 =  Polar2D(pt1,  126.0, Flag.StarInRadius) ;
  local p5 =  Polar2D(pt1,  162.0, Flag.StarOutRadius) ;
  local p6 =  Polar2D(pt1,  198.0, Flag.StarInRadius) ;
  local p7 =  Polar2D(pt1,  234.0, Flag.StarOutRadius) ;
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

    USAFlag(job)
    DrawUnion(job)
    DrawStripes(job)
    DrawStars(job)
  end
  return true

end  -- function end
-- ===================================================