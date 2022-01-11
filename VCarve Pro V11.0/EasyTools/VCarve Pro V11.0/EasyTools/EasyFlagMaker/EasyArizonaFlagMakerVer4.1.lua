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
Flag.Gpt1 =  Point2D(1.0, 1.0)
Flag.HoistFlag = 30.0 ;
Flag.Version = "(Ver: 4.10)"
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.Arizona = [[data:image/png;base64,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]]
--  ===================================================
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Arizona ..[[" width="260" height="120">
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