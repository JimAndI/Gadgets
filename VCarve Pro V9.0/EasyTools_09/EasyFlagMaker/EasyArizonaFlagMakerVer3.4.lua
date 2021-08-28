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

-- Easy  Arizona Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag  =  {}
Flag.Gpt1  =   Point2D(1.0, 1.0)
Flag.HoistFlag  =  30.0 ;
Flag.Version = "(Ver: 3.40)"

--  ===================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--   ===================================================]]
function FlagMath()
  Flag.Gpt1  = Point2D(Flag.X0, Flag.Y0)
  Flag.Gpt2  = Polar2D(Flag.Gpt1,  0.0,  Flag.X10) ;
  Flag.Gpt3  = Polar2D(Flag.Gpt2, 90.0,  Flag.Y4) ;
  Flag.Gpt4  = Polar2D(Flag.Gpt1, 90.0,  Flag.Y4) ;
  Flag.Gpt5  = Polar2D(Flag.Gpt1, 90.0,  Flag.Y1) ;
  Flag.Gpt6  = Polar2D(Flag.Gpt4,  0.0,  Flag.X5) ;
  Flag.Gpt7  = Polar2D(Flag.Gpt2, 90.0,  Flag.Y1) ;
  Flag.Gpt8  = Polar2D(Flag.Gpt2, 90.0,  Flag.Y2) ;
  Flag.Gpt9  = Polar2D(Flag.Gpt2, 90.0,  Flag.Y3) ;
  Flag.Gpt10 = Polar2D(Flag.Gpt4,  0.0,  Flag.X9) ;
  Flag.Gpt11 = Polar2D(Flag.Gpt4,  0.0,  Flag.X8) ;
  Flag.Gpt12 = Polar2D(Flag.Gpt4,  0.0,  Flag.X7) ;
  Flag.Gpt13 = Polar2D(Flag.Gpt4,  0.0,  Flag.X6) ;
  Flag.Gpt14 = Polar2D(Flag.Gpt4,  0.0,  Flag.X4) ;
  Flag.Gpt15 = Polar2D(Flag.Gpt4,  0.0,  Flag.X3) ;
  Flag.Gpt16 = Polar2D(Flag.Gpt4,  0.0,  Flag.X2) ;
  Flag.Gpt17 = Polar2D(Flag.Gpt4,  0.0,  Flag.X1) ;
  Flag.Gpt18 = Polar2D(Flag.Gpt1, 90.0,  Flag.Y3) ;
  Flag.Gpt19 = Polar2D(Flag.Gpt1, 90.0,  Flag.Y2) ;
  Flag.Gpt20 = Polar2D(Flag.Gpt5,  0.0,  Flag.X5) ;
  return true
end
--   ===================================================]]
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
--  ===================================================]]
function ArizonaFlag(job)
  local line  =  Contour(0.0) ;
  local layer  =  job.LayerManager:GetLayerWithName("Arizona Boarder") ;
  line:AppendPoint(Flag.Gpt1) ;
  line:LineTo(Flag.Gpt2) ;
  line:LineTo(Flag.Gpt3) ;
  line:LineTo(Flag.Gpt4) ;
  line:LineTo(Flag.Gpt1) ;
  layer:AddObject(CreateCadContour(line), true)
--  ======
  job:Refresh2DView()
  return true
end
--  ===================================================]]
function ArizonaFlagBase(job)
  local line  =  Contour(0.0) ;
  local layer  =  job.LayerManager:GetLayerWithName("Arizona Boarder") ;
  line:AppendPoint(Flag.Gpt1) ;
  line:LineTo(Flag.Gpt2) ;
  line:LineTo(Flag.Gpt7) ;
  line:LineTo(Flag.Gpt25) ;
  line:LineTo(Flag.Gpt24) ;
  line:LineTo(Flag.Gpt23) ;
  line:LineTo(Flag.Gpt22) ;
  line:LineTo(Flag.Gpt21) ;
  line:LineTo(Flag.Gpt20) ;
  line:LineTo(Flag.Gpt43) ;
  line:LineTo(Flag.Gpt5) ;
  line:LineTo(Flag.Gpt1) ;
  layer:AddObject(CreateCadContour(line), true)
--  ======
  job:Refresh2DView()
  return true
end
--  ===================================================]]
function FourPointBox(job,p1, p2, p3, p4, Layer)
  local line  =  Contour(0.0) ;
  local layer  =  job.LayerManager:GetLayerWithName(Layer) ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
--  ===================================================]]
function FivePointBox(job, p1, p2, p3, p4, p5, Layer)
  local line  =  Contour(0.0) ;
  local layer  =  job.LayerManager:GetLayerWithName(Layer) ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ; line:LineTo(p4) ; line:LineTo(p5) ; line:LineTo(p1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
--  ===================================================]]
function Star(job, pt1)
  local p1  =   Polar2D(pt1,  18.0,  Flag.StarOutRadius) ;
  local p2  =   Polar2D(pt1,  54.0, Flag.StarInRadius) ;
  local p3  =   Polar2D(pt1,  90.0, Flag.StarOutRadius) ;
  local p4  =   Polar2D(pt1,  126.0, Flag.StarInRadius) ;
  local p5  =   Polar2D(pt1,  162.0, Flag.StarOutRadius) ;
  local p6  =   Polar2D(pt1,  198.0, Flag.StarInRadius) ;
  local p7  =   Polar2D(pt1,  234.0,Flag.StarOutRadius) ;
  local p8  =   Polar2D(pt1,  270.0, Flag.StarInRadius) ;
  local p9  =   Polar2D(pt1,  306.0, Flag.StarOutRadius) ;
  local p0  =   Polar2D(pt1,  342.0, Flag.StarInRadius) ;

  Flag.Gpt20   = Polar2D(pt1,  198.0, Flag.StarInRadius) ;
  Flag.Gpt21   = Polar2D(pt1,  234.0,Flag.StarOutRadius) ;
  Flag.Gpt22  = Polar2D(pt1,  270.0, Flag.StarInRadius) ;
  Flag.Gpt23  =  Polar2D(pt1,  306.0, Flag.StarOutRadius) ;
  Flag.Gpt24  =  Polar2D(pt1,  342.0, Flag.StarInRadius) ;
  Flag.Gpt25  = Polar2D(pt1,  0.00, Flag.R3) ;
  Flag.Gpt26  = Polar2D(pt1,  Flag.A1, Flag.R6) ;
  Flag.Gpt27  = Polar2D(pt1,  18.0,  Flag.StarOutRadius) ;
  Flag.Gpt28  = Polar2D(pt1,  Flag.A2, Flag.R7) ;
  Flag.Gpt29  = Polar2D(pt1,  Flag.A3, Flag.R4) ;
  Flag.Gpt30  = Polar2D(pt1,  54.0, Flag.StarInRadius) ;
  Flag.Gpt31  = Polar2D(pt1,  Flag.A4, Flag.R1) ;
  Flag.Gpt32  = Polar2D(pt1,  Flag.A5, Flag.R2) ;
  Flag.Gpt33  = Polar2D(pt1,  Flag.A6, Flag.R5) ;
  Flag.Gpt34  = Polar2D(pt1,  90.0, Flag.StarOutRadius) ;
  Flag.Gpt35  = Polar2D(pt1,  Flag.A7, Flag.R5) ;
  Flag.Gpt36  = Polar2D(pt1,  Flag.A8, Flag.R2) ;
  Flag.Gpt37  = Polar2D(pt1,  Flag.A9, Flag.R1) ;
  Flag.Gpt38  = Polar2D(pt1,  126.0, Flag.StarInRadius) ;
  Flag.Gpt39  = Polar2D(pt1,  Flag.A10, Flag.R4) ;
  Flag.Gpt40  = Polar2D(pt1,  Flag.A11, Flag.R7) ;
  Flag.Gpt41  = Polar2D(pt1,  162.0, Flag.StarOutRadius) ;
  Flag.Gpt42  = Polar2D(pt1,  Flag.A12, Flag.R6) ;
  Flag.Gpt43  = Polar2D(pt1,  180.0, Flag.R3) ;

  local line  =  Contour(0.0) ;
  local layer  =  job.LayerManager:GetLayerWithName("Stars") ;
  line:AppendPoint(p1) ; line:LineTo(p2) ; line:LineTo(p3) ;
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
--  ===================================================]]
function ArizonaFlag(job)
  local line  =  Contour(0.0) ;
  local layer  =  job.LayerManager:GetLayerWithName("Arizona Boarder") ;
  line:AppendPoint(Flag.Gpt1) ;
  line:LineTo(Flag.Gpt2) ;
  line:LineTo(Flag.Gpt3) ;
  line:LineTo(Flag.Gpt4) ;
  line:LineTo(Flag.Gpt1) ;
  layer:AddObject(CreateCadContour(line), true) ;
--  ======
  job:Refresh2DView()
  return true
end
--  ===================================================]]
function main()
  local job  =  VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
      "specify the material dimensions \n"
    )
    return false
  end
--  ======


  local Loops = true

  while Loops do
    Flag.Inquiry = InquiryNumberBox("Arizona Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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

    --  ======
    Flag.X0=1.000000 ;
    Flag.X1=0.009551 * Flag.HoistFlag ;
    Flag.X2=0.298564 * Flag.HoistFlag ;
    Flag.X3=0.480223 * Flag.HoistFlag ;
    Flag.X4=0.629172 * Flag.HoistFlag ;
    Flag.X5=0.750000 * Flag.HoistFlag ;
    Flag.X6=0.870828 * Flag.HoistFlag ;
    Flag.X7=1.019777 * Flag.HoistFlag ;
    Flag.X8=1.201436 * Flag.HoistFlag ;
    Flag.X9=1.490450 * Flag.HoistFlag ;
    Flag.X10=1.50000 * Flag.HoistFlag ;

    Flag.Y0=1.000000 ;
    Flag.Y1=0.500000 * Flag.HoistFlag ;
    Flag.Y2=0.579123 * Flag.HoistFlag ;
    Flag.Y3=0.779236 * Flag.HoistFlag ;
    Flag.Y4=1.000000 * Flag.HoistFlag ;

    Flag.StarInRadius   =  0.1026 * Flag.HoistFlag ;
    Flag.StarOutRadius  =  0.2700 * Flag.HoistFlag ;

    Flag.R1 =   0.111876 * Flag.HoistFlag ;
    Flag.R2 =   0.114774 * Flag.HoistFlag ;
    Flag.R3 =   0.141418 * Flag.HoistFlag ;
    Flag.R4 =   0.148569 * Flag.HoistFlag ;
    Flag.R5 =   0.158786 * Flag.HoistFlag ;
    Flag.R6 =   0.166487 * Flag.HoistFlag ;
    Flag.R7 =   0.238926 * Flag.HoistFlag ;

    Flag.A1 =   6.0218000 ; Flag.A2 =   20.42044 ;
    Flag.A3 =   34.029560 ; Flag.A4 =   47.92157 ;
    Flag.A5 =   61.650150 ; Flag.A6 =   76.41393 ;
    Flag.A7 =   103.58607 ; Flag.A8 =  118.34985 ;
    Flag.A9 =   132.07843 ; Flag.A10 = 145.97044 ;
    Flag.A11 =  159.57956 ; Flag.A12 = 173.97837 ;

    FlagMath()

    ArizonaFlag(job)
    Star(job, Flag.Gpt20)
    ArizonaFlagBase(job)

    FourPointBox(job, Flag.Gpt25, Flag.Gpt26, Flag.Gpt8, Flag.Gpt7, "Ray1") ;
    FivePointBox(job, Flag.Gpt26, Flag.Gpt27, Flag.Gpt28, Flag.Gpt9, Flag.Gpt8, "Ray2") ;
    FivePointBox(job, Flag.Gpt28, Flag.Gpt29, Flag.Gpt10, Flag.Gpt3, Flag.Gpt9, "Ray3") ;
    FourPointBox(job, Flag.Gpt31, Flag.Gpt29, Flag.Gpt10, Flag.Gpt11, "Ray4") ;
    FivePointBox(job, Flag.Gpt31, Flag.Gpt30, Flag.Gpt32, Flag.Gpt12, Flag.Gpt11, "Ray5") ;
    FourPointBox(job, Flag.Gpt33, Flag.Gpt34, Flag.Gpt6, Flag.Gpt13, "Ray7") ;
    FourPointBox(job, Flag.Gpt32, Flag.Gpt33, Flag.Gpt13, Flag.Gpt12, "Ray6") ;
    FourPointBox(job, Flag.Gpt34, Flag.Gpt35, Flag.Gpt14, Flag.Gpt6, "Ray8") ;
    FourPointBox(job, Flag.Gpt35, Flag.Gpt36, Flag.Gpt15, Flag.Gpt14, "Ray9") ;
    FivePointBox(job, Flag.Gpt36, Flag.Gpt38, Flag.Gpt37, Flag.Gpt16, Flag.Gpt15, "Ray10") ;
    FourPointBox(job, Flag.Gpt39, Flag.Gpt37, Flag.Gpt16, Flag.Gpt17, "Ray11") ;
    FivePointBox(job, Flag.Gpt40, Flag.Gpt39, Flag.Gpt17, Flag.Gpt4, Flag.Gpt18, "Ray12") ;
    FivePointBox(job, Flag.Gpt40, Flag.Gpt41, Flag.Gpt42, Flag.Gpt19, Flag.Gpt18, "Ray13") ;
    FourPointBox(job, Flag.Gpt42, Flag.Gpt43, Flag.Gpt5, Flag.Gpt19, "Ray14") ;

  end
  return true
end  -- function end
--  ===================================================]]