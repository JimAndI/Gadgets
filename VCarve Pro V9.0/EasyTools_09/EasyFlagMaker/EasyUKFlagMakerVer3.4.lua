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

-- Easy UK Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {} ;
Flag.Gpt1 =  Point2D(1.0, 1.0) ;
Flag.Version = "(Ver: 3.40)"
Flag.HoistFlag = 30.0 ;
Flag.HoistUnion = 0.5385 ;
Flag.FlyFlag = 1.9 ;
Flag.FlyUnion = 0.76 ;
Flag.UnionStarCentersV = 0.054 ;
Flag.UnionStarCentersH = 0.063 ;
Flag.StarDia = 0.0616 ;
Flag.Strip = 0.0769 ;
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  ===================================================
function FlagMath()
  Flag.Gpt1 =  Point2D(1.0, 1.0) ;
  Flag.Gpt2 = Polar2D(Flag.Gpt1,    0.0,   Flag.H19)
  Flag.Gpt3 = Polar2D(Flag.Gpt2,    90.0,  Flag.HoistFlag)
  Flag.Gpt4 = Polar2D(Flag.Gpt1,     90.0,   Flag.HoistFlag)
  Flag.Gpt5 = Polar2D(Flag.Gpt1,       0.0,     Flag.H09)
  Flag.Gpt6 = Polar2D(Flag.Gpt1,      0.0,     Flag.H10)
  Flag.Gpt7  = Polar2D(Flag.Gpt2,      90.0,    Flag.V08)
  Flag.Gpt8  = Polar2D(Flag.Gpt2,      90.0,    Flag.V16)
  Flag.Gpt9 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H10)
  Flag.Gpt10 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H09)
  Flag.Gpt11  = Polar2D(Flag.Gpt1,      90.0,    Flag.V16)
  Flag.Gpt12 = Polar2D(Flag.Gpt1,  90.0,    Flag.V08)
  Flag.Gpt13 = Polar2D(Flag.Gpt12,  0.0,    Flag.H09)
  Flag.Gpt14 = Polar2D(Flag.Gpt12,  0.0,    Flag.H10)
  Flag.Gpt15 = Polar2D(Flag.Gpt11,  0.0,    Flag.H10)
  Flag.Gpt16 = Polar2D(Flag.Gpt11,  0.0,    Flag.H09)
  Flag.Gpt17 = Polar2D(Flag.Gpt1,  90.0,    Flag.V04)
  Flag.Gpt18 =  Polar2D(Flag.Gpt1,  90.0,    Flag.V07)
  Flag.Gpt19 =  Polar2D(Flag.Gpt1,  90.0,     Flag.V09 )
  Flag.Gpt20 =  Polar2D(Flag.Gpt1,  90.0,    Flag.V13)
  Flag.Gpt21 =  Polar2D(Flag.Gpt1,  90.0,    Flag.V15)
  Flag.Gpt22 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H02)
  Flag.Gpt23 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H08)
  Flag.Gpt24 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H11)
  Flag.Gpt25 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H17)
  Flag.Gpt26 =  Polar2D(Flag.Gpt4,      0.0,    Flag.H18)
  Flag.Gpt27 =  Polar2D(Flag.Gpt2,      90.0,    Flag.V14)
  Flag.Gpt28 =  Polar2D(Flag.Gpt2,      90.0,    Flag.V09)
  Flag.Gpt29 =  Polar2D(Flag.Gpt2,      90.0,    Flag.V07)
  Flag.Gpt30 =  Polar2D(Flag.Gpt2,      90.0,    Flag.V03)
  Flag.Gpt31 =  Polar2D(Flag.Gpt2,      90.0,    Flag.V01)
  Flag.Gpt32 =  Polar2D(Flag.Gpt1,      0.0,    Flag.H17)
  Flag.Gpt33 =  Polar2D(Flag.Gpt1,      0.0,    Flag.H11)
  Flag.Gpt34 =  Polar2D(Flag.Gpt1,      0.0,    Flag.H08)
  Flag.Gpt35 =  Polar2D(Flag.Gpt1,      0.0,    Flag.H20)
  Flag.Gpt36 =  Polar2D(Flag.Gpt1,      0.0,    Flag.H01)
  Flag.Gpt37 = Polar2D(Flag.Gpt18,      0.0,    Flag.H04)
  Flag.Gpt38 =  Polar2D(Flag.Gpt18,      0.0,    Flag.H07)
  Flag.Gpt39 =  Polar2D(Flag.Gpt18,      0.0,    Flag.H08)
  Flag.Gpt40 =  Polar2D(Flag.Gpt34,      90.0,    Flag.V06)
  Flag.Gpt41 =  Polar2D(Flag.Gpt34,      90.0,    Flag.V17)
  Flag.Gpt42 =  Polar2D(Flag.Gpt33,      90.0,    Flag.V05)
  Flag.Gpt43  =  Polar2D(Flag.Gpt18,      0.0,    Flag.H12)
  Flag.Gpt44  =  Polar2D(Flag.Gpt18,      0.0,    Flag.H13)
  Flag.Gpt45 =  Polar2D(Flag.Gpt18,      0.0,    Flag.H14)
  Flag.Gpt46 =  Polar2D(Flag.Gpt19,      0.0,    Flag.H15)
  Flag.Gpt47 =  Polar2D(Flag.Gpt19,      0.0,    Flag.H21)
  Flag.Gpt48 =  Polar2D(Flag.Gpt19,      0.0,    Flag.H11)
  Flag.Gpt49 = Polar2D(Flag.Gpt33,      90.0,    Flag.V10)
  Flag.Gpt50 = Polar2D(Flag.Gpt33,      90.0,    Flag.V12)
  Flag.Gpt51 =  Polar2D(Flag.Gpt34,      90.0,    Flag.V11)
  Flag.Gpt52 =  Polar2D(Flag.Gpt19,      0.0,    Flag.H06)
  Flag.Gpt53 =  Polar2D(Flag.Gpt19,      0.0,    Flag.H05)
  Flag.Gpt54 =  Polar2D(Flag.Gpt19,      0.0,    Flag.H03)
  return true
end
--  ===================================================
function InquiryNumberBox(Header, Quest, Defaltxt)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Flag Maker", "Enter the Flag height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the Flag height"
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
-- ===================================================
function UKFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("UK Boarder")
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
function ThreePointBox(job, p1, p2, p3, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function FourPointBox(job, p1, p2, p3, p4, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function FivePointBox(job, p1, p2, p3, p4, p5, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function Cross(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Cross")
  line:AppendPoint(Flag.Gpt5) ; line:LineTo(Flag.Gpt6) ; line:LineTo(Flag.Gpt14) ; line:LineTo(Flag.Gpt7) ; line:LineTo(Flag.Gpt8) ;
  line:LineTo(Flag.Gpt15) ; line:LineTo(Flag.Gpt9) ; line:LineTo(Flag.Gpt10) ; line:LineTo(Flag.Gpt16) ;
  line:LineTo(Flag.Gpt11) ; line:LineTo(Flag.Gpt12) ; line:LineTo(Flag.Gpt13) ; line:LineTo(Flag.Gpt5) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White1(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt1) ; line:LineTo(Flag.Gpt17) ; line:LineTo(Flag.Gpt37) ;
  line:LineTo(Flag.Gpt18) ; line:LineTo(Flag.Gpt12) ; line:LineTo(Flag.Gpt13) ;
  line:LineTo(Flag.Gpt5) ; line:LineTo(Flag.Gpt34) ; line:LineTo(Flag.Gpt41) ;
  line:LineTo(Flag.Gpt35) ; line:LineTo(Flag.Gpt36) ; line:LineTo(Flag.Gpt40) ;
  line:LineTo(Flag.Gpt39) ; line:LineTo(Flag.Gpt38) ; line:LineTo(Flag.Gpt1) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White2(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt2) ; line:LineTo(Flag.Gpt32) ; line:LineTo(Flag.Gpt42) ;
  line:LineTo(Flag.Gpt33) ; line:LineTo(Flag.Gpt6) ; line:LineTo(Flag.Gpt14) ;
  line:LineTo(Flag.Gpt7) ; line:LineTo(Flag.Gpt29) ; line:LineTo(Flag.Gpt45) ;
  line:LineTo(Flag.Gpt30) ; line:LineTo(Flag.Gpt31) ; line:LineTo(Flag.Gpt44) ;
  line:LineTo(Flag.Gpt43) ; line:LineTo(Flag.Gpt2) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White3(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt3) ; line:LineTo(Flag.Gpt47) ; line:LineTo(Flag.Gpt48) ;
  line:LineTo(Flag.Gpt49) ; line:LineTo(Flag.Gpt26) ; line:LineTo(Flag.Gpt25) ;
  line:LineTo(Flag.Gpt50) ; line:LineTo(Flag.Gpt24) ; line:LineTo(Flag.Gpt9) ;
  line:LineTo(Flag.Gpt15) ; line:LineTo(Flag.Gpt8) ; line:LineTo(Flag.Gpt28) ;
  line:LineTo(Flag.Gpt46) ; line:LineTo(Flag.Gpt27) ; line:LineTo(Flag.Gpt3) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function White4(job, Layer)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Flag.Gpt4) ; line:LineTo(Flag.Gpt22) ; line:LineTo(Flag.Gpt51) ;
  line:LineTo(Flag.Gpt23) ; line:LineTo(Flag.Gpt10) ; line:LineTo(Flag.Gpt16) ;
  line:LineTo(Flag.Gpt11) ; line:LineTo(Flag.Gpt19) ; line:LineTo(Flag.Gpt54) ;
  line:LineTo(Flag.Gpt20) ; line:LineTo(Flag.Gpt21) ; line:LineTo(Flag.Gpt53) ;
  line:LineTo(Flag.Gpt52) ; line:LineTo(Flag.Gpt4) ;
  layer:AddObject(CreateCadContour(line), true)
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
    Flag.Inquiry = InquiryNumberBox("UK Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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

    Flag.H01 = 0.116883 * Flag.HoistFlag ; Flag.H02 = 0.169001 * Flag.HoistFlag ;
    Flag.H03 = 0.398509 * Flag.HoistFlag ; Flag.H04 = 0.407320 * Flag.HoistFlag ;
    Flag.H05 = 0.465912 * Flag.HoistFlag ; Flag.H06 = 0.576712 * Flag.HoistFlag ;
    Flag.H07 = 0.583400 * Flag.HoistFlag ; Flag.H08 = 0.681931 * Flag.HoistFlag ;
    Flag.H09 = 0.742599 * Flag.HoistFlag ; Flag.H10 = 0.922859 * Flag.HoistFlag ;
    Flag.H11 = 0.983527 * Flag.HoistFlag ; Flag.H12 = 1.076387 * Flag.HoistFlag ;
    Flag.H13 = 1.189529 * Flag.HoistFlag ; Flag.H14 = 1.250594 * Flag.HoistFlag ;
    Flag.H15 = 1.264349 * Flag.HoistFlag ; Flag.H16 = 1.481473 * Flag.HoistFlag ;
    Flag.H17 = 1.488912 * Flag.HoistFlag ; Flag.H18 = 1.549977 * Flag.HoistFlag ;
    Flag.H19 = 1.665458 * Flag.HoistFlag ; Flag.H20 = 0.178588 * Flag.HoistFlag ;
    Flag.H21 = 1.084715 * Flag.HoistFlag ; Flag.V01 = 0.06479 * Flag.HoistFlag ;
    Flag.V02 = 0.58896 * Flag.HoistFlag ; Flag.V03 =0.101445 * Flag.HoistFlag ;
    Flag.V04 =0.105974 * Flag.HoistFlag ; Flag.V05 =0.298899 * Flag.HoistFlag ;
    Flag.V06 =0.339178 * Flag.HoistFlag ; Flag.V07 =0.350474 * Flag.HoistFlag ;
    Flag.V08 =0.411464 * Flag.HoistFlag ; Flag.V09 =0.652521 * Flag.HoistFlag ;
    Flag.V10 =0.659696 * Flag.HoistFlag ; Flag.V11 =0.691543 * Flag.HoistFlag ;
    Flag.V12 =0.696351 * Flag.HoistFlag ; Flag.V13 =0.888997 * Flag.HoistFlag ;
    Flag.V14 =0.892516 * Flag.HoistFlag ; Flag.V15 =0.929867 * Flag.HoistFlag ;
    Flag.V16 =0.588960 * Flag.HoistFlag ; Flag.V17 =0.302139 * Flag.HoistFlag ;

-- ======

    FlagMath(job)
    UKFlag(job)
    Cross(job)
    ThreePointBox(job, Flag.Gpt17, Flag.Gpt37, Flag.Gpt18, "Blue1")
    ThreePointBox(job, Flag.Gpt35, Flag.Gpt34, Flag.Gpt41, "Blue2")

    ThreePointBox(job, Flag.Gpt19, Flag.Gpt54, Flag.Gpt20, "Blue3")
    ThreePointBox(job, Flag.Gpt22, Flag.Gpt51, Flag.Gpt23, "Blue4")

    ThreePointBox(job, Flag.Gpt33, Flag.Gpt32, Flag.Gpt42, "Blue5")
    ThreePointBox(job, Flag.Gpt30, Flag.Gpt45, Flag.Gpt29, "Blue6")

    ThreePointBox(job, Flag.Gpt28, Flag.Gpt27, Flag.Gpt46, "Blue7")
    ThreePointBox(job, Flag.Gpt25 ,Flag.Gpt24, Flag.Gpt50, "Blue8")

    FourPointBox(job, Flag.Gpt2, Flag.Gpt31, Flag.Gpt44, Flag.Gpt43, "Red1")
    FourPointBox(job, Flag.Gpt4, Flag.Gpt52, Flag.Gpt53, Flag.Gpt21, "Red2")

    FivePointBox(job, Flag.Gpt1, Flag.Gpt38, Flag.Gpt39, Flag.Gpt40, Flag.Gpt36, "Red3")
    FivePointBox(job, Flag.Gpt3, Flag.Gpt47, Flag.Gpt48, Flag.Gpt49, Flag.Gpt26, "Red4")
    White1(job, "White 1")
    White2(job, "White 2")
    White3(job, "White 3")
    White4(job, "White 4")
  end
  return true
end  -- function end
-- ===================================================