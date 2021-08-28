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

-- Easy USA Flag Maker is written by JimAndI Gadgets of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
require("mobdebug").start()
-- require "strict"
local Flag = {}
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 3.40)"
Flag.HoistUnion = 0.5385
Flag.FlyFlag = 1.6
Flag.FlyUnion = 0.76
Flag.UnionStarCentersV = 0.054
Flag.UnionStarCentersH = 0.063
Flag.StarDia = 0.0616
Flag.Strip = 0.0769
-- ===================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end

-- ====================================================]]
function DebugMarkPoint(Note, Pt, Size, LayerName)
--[[-- ==MarkPoint==
| Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
| Draws mark on the drawing
| call = DebugMarkPoint("Note: Hi", Pt1, 3, "Jim")
]]
  local function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
-- | draws a circle based on user inputs
-- | job - current validated job unique ID
-- | Cpt - (2Dpoint) center of the circle
-- | CircleRadius - radius of the circle
-- | Layer - layer name to draw circle (make layer if not exist)
    local pa = Polar2D(Cpt, 180.0, CircleRadius)
    local pb = Polar2D(Cpt,   0.0, CircleRadius)
    local line = Contour(0.0)
    line:AppendPoint(pa); line:ArcTo(pb,1);   line:ArcTo(pa,1)
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true
  end -- function end
-- ====]]
  local job = VectricJob()
  local layer = job.LayerManager:GetLayerWithName(LayerName)
  local marker1 = CadMarker(Note, Pt, Size)
  layer:AddObject(marker1, true)
  DrawCircle(job, Pt, 0.25, LayerName)
  return true
end -- function end
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
  local myHtml = [[<html><head> <title>Easy Flag Maker</title> <style type="text/css"> html {overflow: hidden;} .LuaButton {	font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;font-size: 12px;} .FormButton { font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;} .h1-l {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:left;} .h1-r {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:right;} .h1-c { font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:center;}    body {	background-color: #CCC;	overflow:hidden;} </style></head><body><table border="0" width="296" cellpadding="0"><tbody><tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here</td><th class="h1-l" align="left" valign="middle" width="83"><input id="qInput" name="qInput" size="10" type="text" /></td></tr><tr><td colspan="2" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td style="width: 20%;">&nbsp;</td><td style="width: 20%;">&nbsp;</td><td style="width: 25%;">&nbsp;</td><td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]
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
-- ===================================================]]
function DrawStar(job, pt1, ang, InRadius ,OutRadius, layers)
    ang = ang + 270.00
    local p1 =  Polar2D(pt1,  18.0 + ang,  OutRadius)
    local p2 =  Polar2D(pt1,  54.0 + ang,  InRadius)
    local p3 =  Polar2D(pt1,  90.0 + ang,  OutRadius)
    local p4 =  Polar2D(pt1,  126.0 + ang, InRadius)
    local p5 =  Polar2D(pt1,  162.0 + ang, OutRadius)
    local p6 =  Polar2D(pt1,  198.0 + ang, InRadius)
    local p7 =  Polar2D(pt1,  234.0 + ang, OutRadius)
    local p8 =  Polar2D(pt1,  270.0 + ang, InRadius)
    local p9 =  Polar2D(pt1,  306.0 + ang, OutRadius)
    local p0 =  Polar2D(pt1,  342.0 + ang, InRadius)
    local line = Contour(0.0)
    local layer = job.LayerManager:GetLayerWithName(layers)
    line:AppendPoint(p1);
    line:LineTo(p2);  line:LineTo(p3);
    line:LineTo(p4);  line:LineTo(p5);
    line:LineTo(p6);  line:LineTo(p7);
    line:LineTo(p8);  line:LineTo(p9);
    line:LineTo(p0);  line:LineTo(p1);
    layer:AddObject(CreateCadContour(line), true)
    return true
  end -- function end
-- =====================================================]]
function OhioFlag(job)
  local line = Contour(0.0) ;
  local layer = job.LayerManager:GetLayerWithName("Stars") ;
  Flag.pt01 =  Point2D(1,1)
  Flag.pt02 =  Polar2D(Flag.pt01,   6.5819, 1.6358 * Flag.HoistFlag) ;
  Flag.pt03 =  Polar2D(Flag.pt01,  11.2934, 1.5218 * Flag.HoistFlag) ;
  Flag.pt04 =  Polar2D(Flag.pt01,  18.2726, 1.3954 * Flag.HoistFlag) ;
  Flag.pt05 =  Polar2D(Flag.pt01,  21.8014, 1.3463 * Flag.HoistFlag) ;
  Flag.pt06 =  Polar2D(Flag.pt01,  23.0028, 1.4395 * Flag.HoistFlag) ;
  Flag.pt07 =  Polar2D(Flag.pt01,  25.1914, 1.6492 * Flag.HoistFlag) ;
  Flag.pt08 =  Polar2D(Flag.pt01,  26.5651, 1.8168 * Flag.HoistFlag) ;
  Flag.pt09 =  Polar2D(Flag.pt01,  90.0000, 1.0000 * Flag.HoistFlag) ;
  Flag.pt10 =  Polar2D(Flag.pt01,  26.5651, 0.3658 * Flag.HoistFlag) ;
  Flag.pt11 =  Polar2D(Flag.pt01,  26.5651, 0.9783 * Flag.HoistFlag) ;
  Flag.pt12 =  Polar2D(Flag.pt01,  26.5651, 1.1180 * Flag.HoistFlag) ;
  Flag.pt13 =  Polar2D(Flag.pt01,  32.7352, 1.0402 * Flag.HoistFlag) ;
  Flag.pt14 =  Polar2D(Flag.pt01,  68.6376, 0.8981 * Flag.HoistFlag) ;
  Flag.pt15 =  Polar2D(Flag.pt01,  58.2844, 0.5967 * Flag.HoistFlag) ;

  layer = job.LayerManager:GetLayerWithName("Border") ;
  line:AppendPoint(Flag.pt01 ) ;
  line:LineTo(Flag.pt02) ;
  line:LineTo(Flag.pt05) ;
  line:LineTo(Flag.pt08) ;
  line:LineTo(Flag.pt09) ;
  line:LineTo(Flag.pt01) ;
  layer:AddObject(CreateCadContour(line), true)

  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("Red1") ;
  line:AppendPoint(Flag.pt01 ) ;
  line:LineTo(Flag.pt02) ;
  line:LineTo(Flag.pt03) ;
  line:LineTo(Flag.pt10) ;
  line:LineTo(Flag.pt01) ;
  layer:AddObject(CreateCadContour(line), true)

  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("Red3") ;
  line:AppendPoint(Flag.pt09 ) ;
  line:LineTo(Flag.pt08) ;
  line:LineTo(Flag.pt07) ;
  line:LineTo(Flag.pt14) ;
  line:LineTo(Flag.pt09) ;
  layer:AddObject(CreateCadContour(line), true)

  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("White1") ;
  line:AppendPoint(Flag.pt10 ) ;
  line:LineTo(Flag.pt03) ;
  line:LineTo(Flag.pt04) ;
  line:LineTo(Flag.pt11) ;
  line:LineTo(Flag.pt10) ;
  layer:AddObject(CreateCadContour(line), true)

  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("White2") ;
  line:AppendPoint(Flag.pt14 ) ;
  line:LineTo(Flag.pt13) ;
  line:LineTo(Flag.pt06) ;
  line:LineTo(Flag.pt07) ;
  line:LineTo(Flag.pt14) ;
  layer:AddObject(CreateCadContour(line), true)

  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("Blue1") ;
  line:AppendPoint(Flag.pt01 ) ;
  line:LineTo(Flag.pt12) ;
  line:LineTo(Flag.pt09) ;
  line:LineTo(Flag.pt01) ;
  layer:AddObject(CreateCadContour(line), true)

  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("Red2") ;
  line:AppendPoint(Flag.pt11 ) ;
  line:LineTo(Flag.pt04) ;
  line:LineTo(Flag.pt05) ;
  line:LineTo(Flag.pt06) ;
  line:LineTo(Flag.pt13) ;
  line:LineTo(Flag.pt12) ;
  line:LineTo(Flag.pt11) ;
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0) ;
  layer = job.LayerManager:GetLayerWithName("White") ;
  line:AppendPoint(Flag.pt10 ) ;
  line:LineTo(Flag.pt03) ;
  line:LineTo(Flag.pt04) ;
  line:LineTo(Flag.pt11) ;
  layer:AddObject(CreateCadContour(line), true)
  DrawCircle(Flag.pt15, 0.1281 * Flag.HoistFlag, "RedCenter")
  DrawCircle(Flag.pt15, 0.1281 * Flag.HoistFlag, "WhiteRing")
  DrawCircle(Flag.pt15, 0.1875 * Flag.HoistFlag, "WhiteRing")
  Flag.pt16 =  Polar2D(Flag.pt15,  0.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16,  0.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 60.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 60.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 90.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 90.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 122.50, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 122.500, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 150.00, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 150.00, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 180.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 180.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 210.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 212.500, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 238.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 238.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 270.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 270.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 300.000, 0.2500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 300.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 0.000, 0.500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 0.000, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 9.6777, 0.37500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 9.6777, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 350.3223, 0.37500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 350.3223, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 112.8198, 0.37500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 112.8198, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 132.1627, 0.37500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 132.1627, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 228.5845, 0.37500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 228.5845, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  Flag.pt16 =  Polar2D(Flag.pt15, 248.9994, 0.37500 * Flag.HoistFlag)
  DrawStar(job, Flag.pt16, 248.9994, 0.0157 * Flag.HoistFlag, 0.0414 * Flag.HoistFlag, "Stars")
  return true
end -- function end
-- =====================================================]]
function  DrawCircle(Pt1, CenterRadius, Layer)
  --[[ ==Draw Circle==
  function main(script_path)
  local MyPt1 = Point2D(1.0,1.0)
  local MyRad = 3.0
  local layer = "My Box"
  DrawCircle(MyPt1, MyRad, Layer)
  return true
  end -- function end
-- -----------------------------------------------------]]
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: No job loaded")
    return false ;
  end -- if end
  local pa = Polar2D(Pt1,   180.0, CenterRadius)
  local pb = Polar2D(Pt1,     0.0, CenterRadius)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(pa) ;
  line:ArcTo(pb,1);
  line:ArcTo(pa,1);
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
-- =====================================================]]
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
    Flag.Inquiry = InquiryNumberBox("Ohio Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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
   OhioFlag(job)
   job:Refresh2DView()
  end
  return true

end  -- function end
-- ===================================================]]