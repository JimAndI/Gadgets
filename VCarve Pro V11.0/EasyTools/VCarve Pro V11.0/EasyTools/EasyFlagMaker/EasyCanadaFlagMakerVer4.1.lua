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
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.Canada = [[data:image/png;base64,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]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Canada ..[[" width="260" height="120">
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
  local dialog = HTML_Dialog(true, myHtml, 300, 250, Header .. " " .. Flag.Version) ;
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