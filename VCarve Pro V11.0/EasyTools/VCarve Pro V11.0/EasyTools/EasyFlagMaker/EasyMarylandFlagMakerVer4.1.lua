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
local AR           = {}
local CR           = {}
Flag.HoistFlag = 30.0
Flag.Gpt1 =  Point2D(1.0, 1.0)
Flag.Version = "(Ver: 4.10)"
Flag.FlyFlag = 1.5
Flag.CrossRadius = 0.125
Flag.Rad = 0.033171
Flag.LL  = 0.064125
Flag.H1  = 0.229771
Flag.H2  = 0.295875
Flag.H3  = 0.326829
Flag.A0  = 0.083320
Flag.A1  = 0.125000
Flag.A2  = 0.166650
Flag.A3  = 0.250000
Flag.A4  = 0.333000
Flag.A5  = 0.416660
Flag.V1  = 0.102844
Flag.V2  = 0.169059
Flag.V3  = 0.183702
Flag.V4  = 0.183702 + (Flag.Rad * 0.5)
AR.a00 = Point2D(0, 0)
CR.a00 = Point2D(0, 0)
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.Maryland = [[data:image/png;base64,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]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Maryland ..[[" width="260" height="150">
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
-- ===================================================]]
function MarylandFlag(job)                         -- Flag Boarder
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Hoist")
  line:AppendPoint(Flag.pt1)
  line:LineTo(Flag.pt2)
  line:LineTo(Flag.pt3)
  line:LineTo(Flag.pt4)
  line:LineTo(Flag.pt1)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function CrossMath(pt1)
  CR.a06 = pt1
  CR.a04 = Polar2D(CR.a06, 90.0, Flag.HoistFlag * 0.5)
  CR.a05 = Polar2D(CR.a06, 90.0, Flag.HoistFlag * 0.25)
  CR.a00 = Polar2D(CR.a05,  0.0, Flag.FlyFlag * 0.25)
  CR.a01 = Polar2D(CR.a00,  0.0, Flag.FlyFlag * 0.25)
  CR.a07 = Polar2D(CR.a06,  0.0, Flag.FlyFlag * 0.25)
  CR.a08 = Polar2D(CR.a06,  0.0, Flag.FlyFlag * 0.5)
  CR.a03 = Polar2D(CR.a07, 90.0, Flag.HoistFlag * 0.5)
  CR.a02 = Polar2D(CR.a08, 90.0, Flag.HoistFlag * 0.5)
-- ===============
  CR.c56 = Polar2D(CR.a00,   0.0, Flag.Rad)
  CR.c57 = Polar2D(CR.a00,   0.0, Flag.H1)
  CR.c58 = Polar2D(CR.a00,   0.0, Flag.H2)
  CR.c59 = Polar2D(CR.a00,   0.0, Flag.H3)
  CR.c60 = Polar2D(CR.a00,  90.0, Flag.V1)
  CR.c61 = Polar2D(CR.a00,  90.0, Flag.V2)
  CR.c62 = Polar2D(CR.a00,  90.0, Flag.V3)
  CR.c63 = Polar2D(CR.a00, 270.0, Flag.V1)
  CR.c64 = Polar2D(CR.a00, 270.0, Flag.V2)
  CR.c65 = Polar2D(CR.a00, 270.0, Flag.V3)
  CR.c66 = Polar2D(CR.a00, 180.0, Flag.Rad)
  CR.c67 = Polar2D(CR.a00, 180.0, Flag.H1)
  CR.c68 = Polar2D(CR.a00, 180.0, Flag.H2)
  CR.c69 = Polar2D(CR.a00, 180.0, Flag.H3)
-- ===============
  CR.a09 = Polar2D(CR.c59,  90.0,  Flag.Rad)
  CR.a10 = Polar2D(CR.c58,  90.0,  Flag.Rad)
  CR.a11 = Polar2D(CR.c58,  90.0,  Flag.LL)
  CR.a12 = Polar2D(CR.c57,  90.0,  Flag.LL)
  CR.a13 = Polar2D(CR.c57,  90.0,  Flag.Rad)
  CR.a14 = Polar2D(CR.c56,  90.0,  Flag.Rad)
  CR.a15 = Polar2D(CR.c60,   0.0,  Flag.Rad)
  CR.a16 = Polar2D(CR.c60,   0.0,  Flag.LL)
  CR.a17 = Polar2D(CR.c61,   0.0,  Flag.LL)
  CR.a18 = Polar2D(CR.c61,   0.0,  Flag.Rad)
  CR.a19 = Polar2D(CR.c62,   0.0,  Flag.Rad)
  CR.a19a = Polar2D(CR.c62, 90.0,  Flag.Rad)
  CR.a20 = Polar2D(CR.c62, 180.0,  Flag.Rad)
  CR.a21 = Polar2D(CR.c61, 180.0,  Flag.Rad)
  CR.a22 = Polar2D(CR.c61, 180.0,  Flag.LL)
  CR.a23 = Polar2D(CR.c60, 180.0,  Flag.LL)
  CR.a24 = Polar2D(CR.c60, 180.0,  Flag.Rad)
  CR.a25 = Polar2D(CR.c66,  90.0,  Flag.Rad)
  CR.a26 = Polar2D(CR.c67,  90.0,  Flag.Rad)
  CR.a27 = Polar2D(CR.c67,  90.0,  Flag.LL)
  CR.a28 = Polar2D(CR.c68,  90.0,  Flag.LL)
  CR.a29 = Polar2D(CR.c68,  90.0,  Flag.Rad)
  CR.a30 = Polar2D(CR.c69,  90.0,  Flag.Rad)
  CR.a31 = Polar2D(CR.c69, 180.0,  Flag.Rad)
  CR.a32 = Polar2D(CR.c69, 270.0,  Flag.Rad)
  CR.a33 = Polar2D(CR.c68, 270.0,  Flag.Rad)
  CR.a34 = Polar2D(CR.c68, 270.0,  Flag.LL)
  CR.a35 = Polar2D(CR.c67, 270.0,  Flag.LL)
  CR.a36 = Polar2D(CR.c67, 270.0,  Flag.Rad)
  CR.a37 = Polar2D(CR.c66, 270.0,  Flag.Rad)
  CR.a38 = Polar2D(CR.c63, 180.0,  Flag.Rad)
  CR.a39 = Polar2D(CR.c63, 180.0,  Flag.LL)
  CR.a40 = Polar2D(CR.c64, 180.0,  Flag.LL)
  CR.a41 = Polar2D(CR.c64, 180.0,  Flag.Rad)
  CR.a42 = Polar2D(CR.c65, 180.0,  Flag.Rad)
  CR.a43 = Polar2D(CR.c65, 270.0,  Flag.Rad)
  CR.a44 = Polar2D(CR.c65,   0.0,  Flag.Rad)
  CR.a45 = Polar2D(CR.c64,   0.0,  Flag.Rad)
  CR.a46 = Polar2D(CR.c64,   0.0,  Flag.LL)
  CR.a47 = Polar2D(CR.c63,   0.0,  Flag.LL)
  CR.a48 = Polar2D(CR.c63,   0.0,  Flag.Rad)
  CR.a49 = Polar2D(CR.c56, 270.0,  Flag.Rad)
  CR.a50 = Polar2D(CR.c57, 270.0,  Flag.Rad)
  CR.a51 = Polar2D(CR.c57, 270.0,  Flag.LL)
  CR.a52 = Polar2D(CR.c58, 270.0,  Flag.LL)
  CR.a53 = Polar2D(CR.c58, 270.0,  Flag.Rad)
  CR.a54 = Polar2D(CR.c59, 270.0,  Flag.Rad)
  CR.a55 = Polar2D(CR.c59,   0.0,  Flag.Rad)
-- =========
  return true
end
-- ==================================================]]
function DrawBox(job, p1, p2, p3, p4, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1);
  line:LineTo(p2);
  line:LineTo(p3);
  line:LineTo(p4);
  line:LineTo(p1);
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ==================================================]]
function DrawTriangle(job, p1, p2, p3, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1);
  line:LineTo(p2);
  line:LineTo(p3);
  line:LineTo(p1);
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ==================================================]]
function HatchMath(pt1)
  AR.a01 = pt1
  AR.a02 = Polar2D(AR.a01,   0.0,  Flag.A1)
  AR.a03 = Polar2D(AR.a01,   0.0,  Flag.A1 * 2.0)
  AR.a04 = Polar2D(AR.a01,   0.0,  Flag.A1 * 3.0)
  AR.a05 = Polar2D(AR.a01,   0.0,  Flag.A1 * 4.0)
  AR.a06 = Polar2D(AR.a01,   0.0,  Flag.A1 * 5.0)
  AR.a07 = Polar2D(AR.a01,   0.0,  Flag.A1 * 6.0)
  AR.a09 = Polar2D(AR.a07,  90.0,  Flag.HoistFlag * 0.5)
  AR.a08 = Polar2D(AR.a09, 270.0,  Flag.A5)
  AR.a10 = Polar2D(AR.a09, 180.0,  Flag.A1)
  AR.a11 = Polar2D(AR.a09, 180.0,  Flag.A1 * 2.0)
  AR.a12 = Polar2D(AR.a09, 180.0,  Flag.A1 * 3.0)
  AR.a13 = Polar2D(AR.a09, 180.0,  Flag.A1 * 4.0)
  AR.a14 = Polar2D(AR.a09, 180.0,  Flag.A1 * 5.0)
  AR.a15 = Polar2D(AR.a09, 180.0,  Flag.A1 * 6.0)
  AR.a16 = Polar2D(AR.a13, 270.0,  Flag.A0)
  AR.a17 = Polar2D(AR.a12, 270.0,  Flag.A2)
  AR.a18 = Polar2D(AR.a11, 270.0,  Flag.A3)
  AR.a19 = Polar2D(AR.a10, 270.0,  Flag.A4)
  AR.a20 = Polar2D(AR.a05,  90.0,  Flag.A0)
  AR.a21 = Polar2D(AR.a04,  90.0,  Flag.A2)
  AR.a22 = Polar2D(AR.a03,  90.0,  Flag.A3)
  AR.a23 = Polar2D(AR.a02,  90.0,  Flag.A4)
  AR.a24 = Polar2D(AR.a01,  90.0,  Flag.A5)
  return true
end
-- ==================================================]]
function DrawCrossA(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Red A")
  line:AppendPoint(CR.a06)
  line:LineTo(CR.a07)
  line:LineTo(CR.a43)
  line:ArcTo(CR.a42, (-1 * Arc2Bulge(CR.a43, CR.a42, Flag.Rad)))
  line:LineTo(CR.a41)
  line:LineTo(CR.a40)
  line:ArcTo(CR.a39, -1)
  line:LineTo(CR.a38)
  line:LineTo(CR.a37)
  line:LineTo(CR.a36)
  line:LineTo(CR.a35)
  line:ArcTo(CR.a34, -1)
  line:LineTo(CR.a33)
  line:LineTo(CR.a32)
  line:ArcTo(CR.a31, (-1 * Arc2Bulge (CR.a32, CR.a31, Flag.Rad)))
  line:LineTo(CR.a05)
  line:LineTo(CR.a06)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function Arc2Bulge (p1, p2, rad)
  local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
  local seg = (rad - (0.5 * (math.sqrt((4.0 * rad^2) - chord^2))))
  local bulge = (2 * seg) / chord
  return bulge
end
-- ==================================================]]
function DrawCrossB(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("White B")
  line:AppendPoint(CR.a07)

  line:LineTo(CR.a08)
  line:LineTo(CR.a01)
  line:LineTo(CR.a55)
  line:ArcTo(CR.a54, (-1 * Arc2Bulge (CR.a32, CR.a31, Flag.Rad)))
  line:LineTo(CR.a53)
  line:LineTo(CR.a52)
  line:ArcTo(CR.a51, -1)
  line:LineTo(CR.a50)
  line:LineTo(CR.a49)
  line:LineTo(CR.a48)
  line:LineTo(CR.a47)
  line:ArcTo(CR.a46, -1)
  line:LineTo(CR.a45)
  line:LineTo(CR.a44)
  line:ArcTo(CR.a43, (-1 * Arc2Bulge (CR.a32, CR.a31, Flag.Rad)))
  line:LineTo(CR.a07)

  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawCrossC(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Red C")
  line:AppendPoint(CR.a02)

  line:LineTo(CR.a03)
  line:LineTo(CR.a19a)
  line:ArcTo(CR.a19, (-1 * Arc2Bulge (CR.a19a, CR.a19, Flag.Rad)))
  line:LineTo(CR.a18)
  line:LineTo(CR.a17)
  line:ArcTo(CR.a16, -1)
  line:LineTo(CR.a15)
  line:LineTo(CR.a14)
  line:LineTo(CR.a13)
  line:LineTo(CR.a12)
  line:ArcTo(CR.a11, -1)
  line:LineTo(CR.a10)
  line:LineTo(CR.a09)
  line:ArcTo(CR.a55, (-1 * Arc2Bulge (CR.a09, CR.a55, Flag.Rad)))
  line:LineTo(CR.a01)
  line:LineTo(CR.a02)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawCrossD(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("White D")
  line:AppendPoint(CR.a03)
  line:LineTo(CR.a04)
  line:LineTo(CR.a05)
  line:LineTo(CR.a31)
  line:ArcTo(CR.a30, (-1 * Arc2Bulge (CR.a31, CR.a30, Flag.Rad )))
  line:LineTo(CR.a29)
  line:LineTo(CR.a28)
  line:ArcTo(CR.a27, -1)
  line:LineTo(CR.a26)
  line:LineTo(CR.a25)
  line:LineTo(CR.a24)
  line:LineTo(CR.a23)
  line:ArcTo(CR.a22, -1)
  line:LineTo(CR.a21)
  line:LineTo(CR.a20)
  line:ArcTo(CR.a19a, (-1 * Arc2Bulge (CR.a20, CR.a19a, Flag.Rad)))
  line:LineTo(CR.a03)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawCrossE(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("White E")
  line:AppendPoint(CR.a00)
  line:LineTo(CR.a31)
  line:ArcTo(CR.a32, (1 * Arc2Bulge (CR.a31, CR.a32, Flag.Rad)))
  line:LineTo(CR.a33)
  line:LineTo(CR.a34)
  line:ArcTo(CR.a35, 1)
  line:LineTo(CR.a36)
  line:LineTo(CR.a37)
  line:LineTo(CR.a38)
  line:LineTo(CR.a39)
  line:ArcTo(CR.a40, 1)
  line:LineTo(CR.a41)
  line:LineTo(CR.a42)
  line:ArcTo(CR.a43, (1 * Arc2Bulge (CR.a42, CR.a43, Flag.Rad)))
  line:LineTo(CR.a00)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawCrossF(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Red F")
  line:AppendPoint(CR.a00)
  line:LineTo(CR.a43)
  line:ArcTo(CR.a44, (1 * Arc2Bulge (CR.a43, CR.a44, Flag.Rad)))
  line:LineTo(CR.a45)
  line:LineTo(CR.a46)
  line:ArcTo(CR.a47, 1)
  line:LineTo(CR.a48)
  line:LineTo(CR.a49)
  line:LineTo(CR.a50)
  line:LineTo(CR.a51)
  line:ArcTo(CR.a52, 1)
  line:LineTo(CR.a53)
  line:LineTo(CR.a54)
  line:ArcTo(CR.a55, (1 * Arc2Bulge (CR.a54, CR.a55, Flag.Rad)))
  line:LineTo(CR.a00)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawCrossG(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("White G")
  line:AppendPoint(CR.a00)
  line:LineTo(CR.a55)
  line:ArcTo(CR.a09 , (1 * Arc2Bulge (CR.a55, CR.a09, Flag.Rad)))
  line:LineTo(CR.a10)
  line:LineTo(CR.a11)
  line:ArcTo(CR.a12, 1)
  line:LineTo(CR.a13)
  line:LineTo(CR.a14)
  line:LineTo(CR.a15)
  line:LineTo(CR.a16)
  line:ArcTo(CR.a17, 1)
  line:LineTo(CR.a18)
  line:LineTo(CR.a19)
  line:ArcTo(CR.a19a, (1 * Arc2Bulge (CR.a19, CR.a19a, Flag.Rad)))
  line:LineTo(CR.a00)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawCrossH(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Red H")
  line:AppendPoint(CR.a00)
  line:LineTo(CR.a19a)
  line:ArcTo(CR.a20, (1 * Arc2Bulge (CR.a19a, CR.a20, Flag.Rad)))
  line:LineTo(CR.a21)
  line:LineTo(CR.a22)
  line:ArcTo(CR.a23, 1)
  line:LineTo(CR.a24)
  line:LineTo(CR.a25)
  line:LineTo(CR.a26)
  line:LineTo(CR.a27)
  line:ArcTo(CR.a28, 1)
  line:LineTo(CR.a29)
  line:LineTo(CR.a30)
  line:ArcTo(CR.a31, (1 * Arc2Bulge (CR.a30, CR.a31, Flag.Rad)))
  line:LineTo(CR.a00)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function DrawHatch(job)
  local Layer = "Gold Hatch"
  DrawBox(job, AR.a01, AR.a02, AR.a23, AR.a24, Layer)
  DrawBox(job, AR.a03, AR.a04, AR.a21, AR.a22, Layer)
  DrawTriangle(job, AR.a05, AR.a06, AR.a20, Layer)
  DrawBox(job, AR.a06, AR.a07, AR.a08, AR.a19, Layer)
  DrawBox(job, AR.a13, AR.a16, AR.a17, AR.a12, Layer)
  DrawBox(job, AR.a11, AR.a18, AR.a19, AR.a10, Layer)
  DrawBox(job, AR.a17, AR.a21, AR.a20, AR.a18, Layer)
  DrawBox(job, AR.a14, AR.a23, AR.a22, AR.a16, Layer)

  Layer = "Black Hatch"
  DrawBox(job, AR.a02, AR.a03, AR.a22, AR.a23, Layer)
  DrawBox(job, AR.a04, AR.a05, AR.a20, AR.a21, Layer)
  DrawBox(job, AR.a24, AR.a23, AR.a14, AR.a15, Layer)
  DrawTriangle(job, AR.a14, AR.a16, AR.a13, Layer)
  DrawBox(job, AR.a12, AR.a17, AR.a18, AR.a11, Layer)
  DrawBox(job, AR.a16, AR.a22, AR.a21, AR.a17, Layer)
  DrawBox(job, AR.a10, AR.a19, AR.a08, AR.a09, Layer)
  DrawBox(job, AR.a18, AR.a20, AR.a06, AR.a19, Layer)
  return true
end
-- ==================================================]]
function DrawX(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Fly")
  line:AppendPoint(Flag.pt5)
  line:LineTo(Flag.pt6)
  line:LineTo(Flag.pt0)
  line:LineTo(Flag.pt7)
  line:LineTo(Flag.pt8)
  line:LineTo(Flag.pt0)
  line:LineTo(Flag.pt5)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ==================================================]]
function FlagMath()
  Flag.FlyFlag =    Flag.FlyFlag * Flag.HoistFlag
  Flag.CrossRadius = Flag.CrossRadius * Flag.HoistFlag
  Flag.Rad =   Flag.Rad * Flag.HoistFlag
  Flag.LL =    Flag.LL  * Flag.HoistFlag
  Flag.H1 =    Flag.H1  * Flag.HoistFlag
  Flag.H2 =    Flag.H2  * Flag.HoistFlag
  Flag.H3 =    Flag.H3  * Flag.HoistFlag
  Flag.A0 =    Flag.A0  * Flag.HoistFlag
  Flag.A1 =    Flag.A1  * Flag.HoistFlag
  Flag.A2 =    Flag.A2  * Flag.HoistFlag
  Flag.A3 =    Flag.A3  * Flag.HoistFlag
  Flag.A4 =    Flag.A4  * Flag.HoistFlag
  Flag.A5 =    Flag.A5  * Flag.HoistFlag
  Flag.V1 =    Flag.V1  * Flag.HoistFlag
  Flag.V2 =    Flag.V2  * Flag.HoistFlag
  Flag.V3 =    Flag.V3  * Flag.HoistFlag
  Flag.V4 =    Flag.V4  * Flag.HoistFlag
end -- function end
-- ==================================================]]
function main()
-- create a layer with passed name if it doesn't already exist
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
      "specify the material dimensions \n"
    )
    return false;
  end
  local Loops = true
  while Loops do
    Flag.Inquiry = InquiryNumberBox("Maryland Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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
    FlagMath()
    Flag.pt1 = Point2D(1, 1)
    Flag.pt2 = Polar2D(Flag.pt1,   0.0, Flag.FlyFlag)
    Flag.pt3 = Polar2D(Flag.pt2,  90.0, Flag.HoistFlag)
    Flag.pt4 = Polar2D(Flag.pt1,  90.0, Flag.HoistFlag)
    Flag.pt5 = Polar2D(Flag.pt1,  90.0, Flag.HoistFlag * 0.5)
    Flag.pt6 = Polar2D(Flag.pt1,   0.0, Flag.FlyFlag   * 0.5)
    Flag.pt7 = Polar2D(Flag.pt2,  90.0, Flag.HoistFlag * 0.5)
    Flag.pt8 = Polar2D(Flag.pt4,   0.0, Flag.FlyFlag * 0.5)
    Flag.pt0 = Polar2D(Flag.pt6,  90.0, Flag.HoistFlag * 0.5)
    MarylandFlag(job)
    CrossMath(Flag.pt1)
    DrawCrossA(job);DrawCrossB(job);DrawCrossC(job);DrawCrossD(job)
    DrawCrossE(job);DrawCrossF(job);DrawCrossG(job);DrawCrossH(job)
    CrossMath(Flag.pt0)
    DrawCrossA(job);DrawCrossB(job);DrawCrossC(job);DrawCrossD(job)
    DrawCrossE(job);DrawCrossF(job);DrawCrossG(job);DrawCrossH(job)
    HatchMath(Flag.pt5)
    DrawHatch(job)
    HatchMath(Flag.pt6)
    DrawHatch(job)
  end -- if end
  return true
end  -- function end
-- ==================================================]]