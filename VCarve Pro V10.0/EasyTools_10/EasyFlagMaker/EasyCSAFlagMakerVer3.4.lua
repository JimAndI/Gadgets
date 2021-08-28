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

-- Easy  CSA Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {} ;
Flag.Gpt1 =  Point2D(1.0, 1.0)
Flag.HoistFlag = 30.0 ;
Flag.Version = "(Ver: 3.40)"

-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  ===================================================
function FlagMath()
  Flag.Gpt1 =  Point2D(1.0, 1.0) ;
  Flag.Gpt2 = Polar2D(Flag.Gpt1,    0.0,   Flag.H10) ; Flag.Gpt3 = Polar2D(Flag.Gpt2, 90.0,  Flag.V10) ; Flag.Gpt4 = Polar2D(Flag.Gpt1, 90.0,   Flag.V10) ; Flag.Gpt5 = Polar2D(Flag.Gpt1, 90.0,     Flag.V05) ; Flag.Gpt6 = Polar2D(Flag.Gpt1, 0.0,     Flag.H05) ; Flag.Gpt7  = Polar2D(Flag.Gpt1, 0.0,    Flag.H01) ; Flag.Gpt8  = Polar2D(Flag.Gpt1, 0.0,    Flag.H02) ; Flag.Gpt9 =  Polar2D(Flag.Gpt5, 0.0,    Flag.H03) ; Flag.Gpt10 =  Polar2D(Flag.Gpt5, 0.0,    Flag.H04) ; Flag.Gpt11  = Polar2D(Flag.Gpt5, 0.0,    Flag.H06) ; Flag.Gpt12 = Polar2D(Flag.Gpt5, 0.0,    Flag.H07) ; Flag.Gpt13 = Polar2D(Flag.Gpt1, 0.0,    Flag.H08) ; Flag.Gpt14 = Polar2D(Flag.Gpt1, 0.0,    Flag.H09) ; Flag.Gpt15  = Polar2D(Flag.Gpt4, 0.0,    Flag.H01) ;
  Flag.Gpt16  = Polar2D(Flag.Gpt4, 0.0,    Flag.H02) ; Flag.Gpt17 = Polar2D(Flag.Gpt4,  0.0,    Flag.H08) ; Flag.Gpt18 = Polar2D(Flag.Gpt4,  0.0,    Flag.H09) ; Flag.Gpt19 =  Polar2D(Flag.Gpt6,  90.0,     Flag.V03 ) ; Flag.Gpt20 =  Polar2D(Flag.Gpt6,  90.0,    Flag.V04) ; Flag.Gpt21 =  Polar2D(Flag.Gpt6,  90.0,    Flag.V06) ; Flag.Gpt22 =  Polar2D(Flag.Gpt6, 90.0,    Flag.V07) ;
  Flag.Gpt23 =  Polar2D(Flag.Gpt6, 90.0,    Flag.V05) ; Flag.Gpt24 =  Polar2D(Flag.Gpt1, 90.0,    Flag.V01) ; Flag.Gpt25 =  Polar2D(Flag.Gpt1, 90.0,    Flag.V02) ; Flag.Gpt26 =  Polar2D(Flag.Gpt1, 90.0,    Flag.V08) ; Flag.Gpt27 =  Polar2D(Flag.Gpt1, 90.0,    Flag.V09) ; Flag.Gpt28 =  Polar2D(Flag.Gpt2, 90.0,    Flag.V01) ; Flag.Gpt29 =  Polar2D(Flag.Gpt2, 90.0,    Flag.V02) ; Flag.Gpt30 =  Polar2D(Flag.Gpt2, 90.0,    Flag.V08) ; Flag.Gpt31 =  Polar2D(Flag.Gpt2, 90.0,    Flag.V09)

  return true
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
function CSAFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("CSA Boarder")
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
function ThreePoint(job, p1, p2, p3, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Cross(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Cross Blue")
  line:AppendPoint(Flag.Gpt1) ; line:LineTo(Flag.Gpt7) ; line:LineTo(Flag.Gpt20) ; line:LineTo(Flag.Gpt14) ; line:LineTo(Flag.Gpt2) ; line:LineTo(Flag.Gpt28) ; line:LineTo(Flag.Gpt11) ; line:LineTo(Flag.Gpt31) ; line:LineTo(Flag.Gpt3) ; line:LineTo(Flag.Gpt18) ; line:LineTo(Flag.Gpt21) ; line:LineTo(Flag.Gpt15) ; line:LineTo(Flag.Gpt4) ; line:LineTo(Flag.Gpt27) ; line:LineTo(Flag.Gpt10) ; line:LineTo(Flag.Gpt24) ; line:LineTo(Flag.Gpt1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Star(job, pt1)
  local p1 =  Polar2D(pt1,  18.0,  Flag.StarOutRadius) ; local p2 =  Polar2D(pt1,  54.0, Flag.StarInRadius) ; local p3 =  Polar2D(pt1,  90.0, Flag.StarOutRadius) ; local p4 =  Polar2D(pt1,  126.0, Flag.StarInRadius) ; local p5 =  Polar2D(pt1,  162.0, Flag.StarOutRadius) ; local p6 =  Polar2D(pt1,  192.0, Flag.StarInRadius) ; local p7 =  Polar2D(pt1,  234.0,Flag.StarOutRadius) ; local p8 =  Polar2D(pt1,  270.0, Flag.StarInRadius) ; local p9 =  Polar2D(pt1,  306.0, Flag.StarOutRadius) ; local p0 =  Polar2D(pt1,  342.0, Flag.StarInRadius) ; local line = Contour(0.0) ; local layer = job.LayerManager:GetLayerWithName("Stars") ; line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p6) ; line:LineTo(p7) ; line:LineTo(p8) ; line:LineTo(p9) ; line:LineTo(p0) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function DrawStars(job)
  Star(job, Flag.Gpt23)
  Star(job, Polar2D(Flag.Gpt23,   31.5, Flag.R03) ) ; Star(job, Polar2D(Flag.Gpt23, 148.5, Flag.R03) ) ; Star(job, Polar2D(Flag.Gpt23,  211.5, Flag.R03) ) ; Star(job, Polar2D(Flag.Gpt23, 328.5, Flag.R03) ) ;
  Star(job, Polar2D(Flag.Gpt23,   31.5, Flag.R04) ) ; Star(job, Polar2D(Flag.Gpt23, 148.5, Flag.R04) ) ; Star(job, Polar2D(Flag.Gpt23, 211.5, Flag.R04) ) ; Star(job, Polar2D(Flag.Gpt23, 328.5, Flag.R04) ) ;
  Star(job, Polar2D(Flag.Gpt23,   31.5, Flag.R05) ) ; Star(job, Polar2D(Flag.Gpt23, 148.5, Flag.R05) ) ; Star(job, Polar2D(Flag.Gpt23, 211.5, Flag.R05) ) ; Star(job, Polar2D(Flag.Gpt23, 328.5, Flag.R05) ) ;
  job:Refresh2DView()
  return true
end
-- ===================================================
function White1(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt7) ; line:LineTo(Flag.Gpt8) ; line:LineTo(Flag.Gpt19) ; line:LineTo(Flag.Gpt13) ; line:LineTo(Flag.Gpt14) ; line:LineTo(Flag.Gpt20) ; line:LineTo(Flag.Gpt7) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White2(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt15) ; line:LineTo(Flag.Gpt16) ; line:LineTo(Flag.Gpt22) ; line:LineTo(Flag.Gpt17) ; line:LineTo(Flag.Gpt18) ; line:LineTo(Flag.Gpt21) ; line:LineTo(Flag.Gpt15) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White3(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt28) ; line:LineTo(Flag.Gpt29) ; line:LineTo(Flag.Gpt12) ; line:LineTo(Flag.Gpt30) ; line:LineTo(Flag.Gpt31) ; line:LineTo(Flag.Gpt11) ; line:LineTo(Flag.Gpt28) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White4(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt24) ; line:LineTo(Flag.Gpt10) ; line:LineTo(Flag.Gpt27) ; line:LineTo(Flag.Gpt26) ; line:LineTo(Flag.Gpt9) ; line:LineTo(Flag.Gpt25) ; line:LineTo(Flag.Gpt24) ; layer:AddObject(CreateCadContour(line), true)
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
    Flag.Inquiry = InquiryNumberBox("CSA Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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

    Flag.H01 = 0.10338 * Flag.HoistFlag ; Flag.H02 = 0.155652 * Flag.HoistFlag ; Flag.H03 = 0.59638 * Flag.HoistFlag ; Flag.H04 = 0.646089 * Flag.HoistFlag ; Flag.H05 = 0.792251 * Flag.HoistFlag ; Flag.H06 = 0.93844 * Flag.HoistFlag ; Flag.H07 = 0.988139 * Flag.HoistFlag ; Flag.H08 = 1.428851 * Flag.HoistFlag ; Flag.H09 = 1.481123 * Flag.HoistFlag ; Flag.H10 = 1.584502 * Flag.HoistFlag ; Flag.V01 = 0.111669 * Flag.HoistFlag ; Flag.V02 = 0.141558 * Flag.HoistFlag ; Flag.V03 =0.382355 * Flag.HoistFlag ; Flag.V04 =0.41388 * Flag.HoistFlag ; Flag.V05 =0.499858 * Flag.HoistFlag ; Flag.V06 =0.585836 * Flag.HoistFlag ; Flag.V07 =0.617361 * Flag.HoistFlag ; Flag.V08 =0.858158 * Flag.HoistFlag ; Flag.V09 =0.888046 * Flag.HoistFlag ; Flag.V10 =0.999716 * Flag.HoistFlag ;

    Flag.StarInRadius = 0.019 * Flag.HoistFlag ; Flag.StarOutRadius = 0.05 * Flag.HoistFlag ; Flag.R03 =0.26 * Flag.HoistFlag ;
    Flag.R04 = 0.52 * Flag.HoistFlag ; Flag.R05 =0.78 * Flag.HoistFlag ;
-- ======

    FlagMath(job)
    CSAFlag(job)
    Cross(job)
    DrawStars(job)

    ThreePoint(job, Flag.Gpt8, Flag.Gpt19, Flag.Gpt13, "Red1")
    ThreePoint(job, Flag.Gpt29, Flag.Gpt30, Flag.Gpt12, "Red2")
    ThreePoint(job, Flag.Gpt25, Flag.Gpt9, Flag.Gpt26, "Red3")
    ThreePoint(job, Flag.Gpt16, Flag.Gpt22, Flag.Gpt17, "Red4")

    White1(job, "White 1")
    White2(job, "White 2")
    White3(job, "White 3")
    White4(job, "White 4")
  end
  return true
end  -- function end
-- ===================================================