-- VECTRIC LUA SCRIPT
-- ==================================================]]
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
-- 2. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 3. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 4. This notice may not be removed or altered from any source distribution.

-- Easy Maryland Flag Maker is written by Jim Anderson of Houston Texas 2019
-- ==================================================]]
-- Global Variables --
require("mobdebug").start()
-- ==================================================]]
require "strict"
  local  Flag = {}
    Flag.pt1 =  Point2D(1, 1)

  local   AR = {}
    AR.a00 = Point2D(0, 0)

  local    CR = {}
    CR.a00 = Point2D(0, 0)

    Flag.HoistFlag = 1.0
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
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
function InquiryNumberBox(Header, Quest, Defaltxt)
--[[
    TextBox for user input with default value
    Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[<html><head> <title>Easy Stair Maker</title> <style type="text/css"> html {overflow: hidden;} .LuaButton {	font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif; font-size: 12px;} .FormButton { font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;} .h1-l {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:left;} .h1-r {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:right;} .h1-c { font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:center;}    body {	background-color: #CCC;	overflow:hidden;} </style></head><body><table border="0" width="296" cellpadding="0"><tbody><tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here</th><th class="h1-l" align="left" valign="middle" width="83"><input id="qInput" name="qInput" size="10" type="text" /></th></tr><tr><td colspan="2" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td style="width: 20%;">&nbsp;</td><td style="width: 20%;">&nbsp;</td><td style="width: 25%;">&nbsp;</td><td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]
    local dialog = HTML_Dialog(true, myHtml, 330, 120, Header)
    dialog:AddLabelField("QuestionID", Quest)
    dialog:AddDoubleField("qInput", Defaltxt)
    if not dialog:ShowDialog() then
      return  0.0  -- Pressed Cancel
    else
      return dialog:GetDoubleField("qInput") -- Pressed Okay
    end
end
-- ==================================================]]
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
    line:AppendPoint(p1) ;
    line:LineTo(p2);
    line:LineTo(p3) ;
    line:LineTo(p4);
    line:LineTo(p1);
    layer:AddObject(CreateCadContour(line), true)
    return true
end
-- ==================================================]]
function DrawTriangle(job, p1, p2, p3, Layer)
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(p1) ;
    line:LineTo(p2);
    line:LineTo(p3) ;
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
        DisplayMessageBox("Error: No Job found")
        return false  ;
    end

    Flag.HoistFlag = InquiryNumberBox("Maryland Flag Data", "Enter the Flag Height", 30.0)

    FlagMath()

-- ======
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
    DrawCrossA(job) ;    DrawCrossB(job) ;    DrawCrossC(job) ;    DrawCrossD(job)
    DrawCrossE(job) ;    DrawCrossF(job) ;    DrawCrossG(job) ;    DrawCrossH(job)

    CrossMath(Flag.pt0)
    DrawCrossA(job) ;    DrawCrossB(job) ;    DrawCrossC(job) ;    DrawCrossD(job)
    DrawCrossE(job) ;    DrawCrossF(job) ;    DrawCrossG(job) ;    DrawCrossH(job)

    HatchMath(Flag.pt5)
    DrawHatch(job)

    HatchMath(Flag.pt6)
    DrawHatch(job)

    return true
end  -- function end
-- ==================================================]]