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

-- Easy Canada Flag Maker is written by JimAndI Gadgets of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {}
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 3.40)"
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
function CanadaFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Flag Border")
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
function DrawLeaf(job, CenPt)

  local a01 = 1.17221300 ;  local a02 = 3.98617300 ; local a03 = 20.8344840 ; local a04 = 24.3281950 ; local a05 = 27.1614030 ;
  local a06 = 31.4367280 ;  local a07 = 38.3876000 ; local a08 = 39.8681370 ; local a09 = 63.5592310 ; local a10 = 72.2388230 ;
  local a11 = 76.1539700 ;  local a12 = 90.0000000 ; local a13 = 103.846030 ; local a14 = 107.761177 ; local a15 = 116.440769 ;
  local a16 = 140.131863 ;  local a17 = 141.612400 ; local a18 = 148.563272 ; local a19 = 152.838569 ; local a20 = 155.671805 ;
  local a21 = 159.165516 ;  local a22 = 176.013827 ; local a23 = 178.827787 ; local a24 = 182.003274 ; local a25 = 222.088190 ;
  local a26 = 225.121680 ;  local a27 = 230.242742 ; local a28 = 261.699768 ; local a29 = 267.461466 ; local a30 = 267.791944 ;
  local a31 = 272.208056 ;  local a32 = 272.538534 ; local a33 = 278.300232 ; local a34 = 310.113402 ; local a35 = 314.878320 ;
  local a36 = 317.911810 ;  local a37 = 357.996726 ;
-- =====
  local dis03 = 0.146681 * Flag.HoistFlag ; local dis04 = 0.160178 * Flag.HoistFlag ; local dis05 = 0.224861 * Flag.HoistFlag ;
  local dis07 = 0.243306 * Flag.HoistFlag ; local dis08 = 0.257412 * Flag.HoistFlag ; local dis09 = 0.265903 * Flag.HoistFlag ;
  local dis11 = 0.277288 * Flag.HoistFlag ; local dis13 = 0.287796 * Flag.HoistFlag ; local dis14 = 0.289006 * Flag.HoistFlag ;
  local dis15 = 0.289258 * Flag.HoistFlag ; local dis17 = 0.337059 * Flag.HoistFlag ; local dis18 = 0.344182 * Flag.HoistFlag ;
  local dis19 = 0.351250 * Flag.HoistFlag ; local dis20 = 0.387645 * Flag.HoistFlag ; local dis21 = 0.401197 * Flag.HoistFlag ;
  local dis22 = 0.416666 * Flag.HoistFlag ; local dis23 = 0.423332 * Flag.HoistFlag ;
-- =====
  local p1 =  Polar2D(CenPt,  a29, dis23) ; local p2 =  Polar2D(CenPt,  a30, dis07) ; local p3 =  Polar2D(CenPt,  a28, dis05) ;
  local p4 =  Polar2D(CenPt,  a27, dis17) ; local p5 =  Polar2D(CenPt,  a26, dis09) ; local p6 =  Polar2D(CenPt,  a25, dis08) ;
  local p7 =  Polar2D(CenPt,  a24, dis20) ; local p8 =  Polar2D(CenPt,  a23, dis18) ; local p9 =  Polar2D(CenPt,  a22, dis17) ;
  local p10 =  Polar2D(CenPt, a21, dis21) ; local p11 =  Polar2D(CenPt,  a20, dis15) ; local p12 =  Polar2D(CenPt,  a19, dis11) ;
  local p13 =  Polar2D(CenPt,  a17, dis13) ; local p14 =  Polar2D(CenPt,  a18, dis04) ; local p15 =  Polar2D(CenPt,  a16, dis03) ;
  local p16 =  Polar2D(CenPt,  a15, dis19) ; local p17 =  Polar2D(CenPt,  a14, dis15) ; local p18 =  Polar2D(CenPt,  a13, dis14) ;
  local p19 =  Polar2D(CenPt,  a12, dis22) ; local p20 =  Polar2D(CenPt,  a11, dis14) ; local p21 =  Polar2D(CenPt,  a10, dis15) ;
  local p22 =  Polar2D(CenPt,  a09, dis19) ; local p23 =  Polar2D(CenPt,  a08, dis03) ; local p24 =  Polar2D(CenPt,  a06, dis04) ;
  local p25 =  Polar2D(CenPt,  a07, dis13) ; local p26 =  Polar2D(CenPt,  a05, dis11) ; local p27 =  Polar2D(CenPt,  a04, dis15) ;
  local p28 =  Polar2D(CenPt,  a03, dis21) ; local p29 =  Polar2D(CenPt,  a02, dis17) ; local p30 =  Polar2D(CenPt,  a01, dis18) ;
  local p31 =  Polar2D(CenPt,  a37, dis20) ; local p32 =  Polar2D(CenPt,  a36, dis08) ; local p33 =  Polar2D(CenPt,  a35, dis09) ;
  local p34 =  Polar2D(CenPt,  a34, dis17) ; local p35 =  Polar2D(CenPt,  a33, dis05) ; local p36 =  Polar2D(CenPt,  a31, dis07) ;
  local p37 =  Polar2D(CenPt,  a32, dis23) ;
-- =====
  local line = Contour(0.0) ; local layer = job.LayerManager:GetLayerWithName("Canada Leaf") ; line:AppendPoint(p1) ;
  line:LineTo(p2) ; line:ArcTo(p3, 0.5) ; line:LineTo(p4) ; line:LineTo(p5) ; line:ArcTo(p6,0.35 ) ; line:LineTo(p7) ;
  line:LineTo(p8) ; line:ArcTo(p9, 0.35 ) ; line:LineTo(p10) ; line:LineTo(p11) ; line:ArcTo(p12,0.25 ) ; line:LineTo(p13) ;
  line:LineTo(p14) ; line:ArcTo(p15, 0.6) ; line:LineTo(p16) ; line:LineTo(p17) ; line:ArcTo(p18, 0.5 ) ; line:LineTo(p19) ;
  line:LineTo(p20) ; line:ArcTo(p21, 0.5) ; line:LineTo(p22) ; line:LineTo(p23) ; line:ArcTo(p24, 0.6) ; line:LineTo(p25) ;
  line:LineTo(p26) ; line:ArcTo(p27, 0.25 ) ; line:LineTo(p28) ; line:LineTo(p29) ; line:ArcTo(p30, 0.35 ) ; line:LineTo(p31) ;
  line:LineTo(p32) ; line:ArcTo(p33, 0.35) ; line:LineTo(p34) ; line:LineTo(p35) ; line:ArcTo(p36, 0.5 ) ; line:LineTo(p37) ;
  line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function DrawRedBands(job)

  local pt1 =  Flag.Gpt1
  local pt2 =  Polar2D(pt1,  0.0, Flag.RedBand)
  local pt3 =  Polar2D(pt2,  90.0, Flag.HoistFlag)
  local pt4 =  Polar2D(pt3,  180.0, Flag.RedBand)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Red Bands")
  line:AppendPoint(pt1)
  line:LineTo(pt2)
  line:LineTo(pt3)
  line:LineTo(pt4)
  line:LineTo(pt1)
  layer:AddObject(CreateCadContour(line), true)
-- ======
  pt1 =  Flag.Gpt2
  pt2 =  Polar2D(pt1,  180.0, Flag.RedBand)
  pt3 =  Polar2D(pt2,  90.0, Flag.HoistFlag)
  pt4 =  Polar2D(pt3,  0.0, Flag.RedBand)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Red Bands")
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
function main()
-- create a layer with passed name if it doesn't already exist
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
    Flag.Inquiry = InquiryNumberBox("Canada Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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


    Flag.FlyFlag = 2.0 * Flag.HoistFlag ;
    Flag.RedBand = 0.5 * Flag.HoistFlag ;
-- ======
    Flag.Gpt1 = Point2D(1, 1)
    Flag.Gpt2 = Polar2D(Flag.Gpt1,    0.0, Flag.FlyFlag)
    Flag.Gpt3 = Polar2D(Flag.Gpt2,  90.0, Flag.HoistFlag)
    Flag.Gpt4 = Polar2D(Flag.Gpt1,  90.0, Flag.HoistFlag)
    Flag.Gpt5 = Polar2D(Polar2D(Flag.Gpt1, 0.0, Flag.FlyFlag * 0.5), 90.0, Flag.HoistFlag * 0.5)
    CanadaFlag(job)
    DrawRedBands(job)
    DrawLeaf(job, Flag.Gpt5)
  end
  return true
end  -- function end
-- ===================================================