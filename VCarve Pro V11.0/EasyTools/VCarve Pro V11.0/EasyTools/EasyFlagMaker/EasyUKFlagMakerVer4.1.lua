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
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.UK = [[data:image/png;base64,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]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.UK ..[[" width="260" height="150">
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

function FlagMath()
  Flag.Gpt1  = Point2D(1.0, 1.0) ;
  Flag.Gpt2  = Polar2D(Flag.Gpt1,   0.0, Flag.H19)
  Flag.Gpt3  = Polar2D(Flag.Gpt2,  90.0, Flag.HoistFlag)
  Flag.Gpt4  = Polar2D(Flag.Gpt1,  90.0, Flag.HoistFlag)
  Flag.Gpt5  = Polar2D(Flag.Gpt1,   0.0, Flag.H09)
  Flag.Gpt6  = Polar2D(Flag.Gpt1,   0.0, Flag.H10)
  Flag.Gpt7  = Polar2D(Flag.Gpt2,  90.0, Flag.V08)
  Flag.Gpt8  = Polar2D(Flag.Gpt2,  90.0, Flag.V16)
  Flag.Gpt9  = Polar2D(Flag.Gpt4,   0.0, Flag.H10)
  Flag.Gpt10 = Polar2D(Flag.Gpt4,   0.0, Flag.H09)
  Flag.Gpt11 = Polar2D(Flag.Gpt1,  90.0, Flag.V16)
  Flag.Gpt12 = Polar2D(Flag.Gpt1,  90.0, Flag.V08)
  Flag.Gpt13 = Polar2D(Flag.Gpt12,  0.0, Flag.H09)
  Flag.Gpt14 = Polar2D(Flag.Gpt12,  0.0, Flag.H10)
  Flag.Gpt15 = Polar2D(Flag.Gpt11,  0.0, Flag.H10)
  Flag.Gpt16 = Polar2D(Flag.Gpt11,  0.0, Flag.H09)
  Flag.Gpt17 = Polar2D(Flag.Gpt1,  90.0, Flag.V04)
  Flag.Gpt18 = Polar2D(Flag.Gpt1,  90.0, Flag.V07)
  Flag.Gpt19 = Polar2D(Flag.Gpt1,  90.0, Flag.V09)
  Flag.Gpt20 = Polar2D(Flag.Gpt1,  90.0, Flag.V13)
  Flag.Gpt21 = Polar2D(Flag.Gpt1,  90.0, Flag.V15)
  Flag.Gpt22 = Polar2D(Flag.Gpt4,   0.0, Flag.H02)
  Flag.Gpt23 = Polar2D(Flag.Gpt4,   0.0, Flag.H08)
  Flag.Gpt24 = Polar2D(Flag.Gpt4,   0.0, Flag.H11)
  Flag.Gpt25 = Polar2D(Flag.Gpt4,   0.0, Flag.H17)
  Flag.Gpt26 = Polar2D(Flag.Gpt4,   0.0, Flag.H18)
  Flag.Gpt27 = Polar2D(Flag.Gpt2,  90.0, Flag.V14)
  Flag.Gpt28 = Polar2D(Flag.Gpt2,  90.0, Flag.V09)
  Flag.Gpt29 = Polar2D(Flag.Gpt2,  90.0, Flag.V07)
  Flag.Gpt30 = Polar2D(Flag.Gpt2,  90.0, Flag.V03)
  Flag.Gpt31 = Polar2D(Flag.Gpt2,  90.0, Flag.V01)
  Flag.Gpt32 = Polar2D(Flag.Gpt1,   0.0, Flag.H17)
  Flag.Gpt33 = Polar2D(Flag.Gpt1,   0.0, Flag.H11)
  Flag.Gpt34 = Polar2D(Flag.Gpt1,   0.0, Flag.H08)
  Flag.Gpt35 = Polar2D(Flag.Gpt1,   0.0, Flag.H20)
  Flag.Gpt36 = Polar2D(Flag.Gpt1,   0.0, Flag.H01)
  Flag.Gpt37 = Polar2D(Flag.Gpt18,  0.0, Flag.H04)
  Flag.Gpt38 = Polar2D(Flag.Gpt18,  0.0, Flag.H07)
  Flag.Gpt39 = Polar2D(Flag.Gpt18,  0.0, Flag.H08)
  Flag.Gpt40 = Polar2D(Flag.Gpt34, 90.0, Flag.V06)
  Flag.Gpt41 = Polar2D(Flag.Gpt34, 90.0, Flag.V17)
  Flag.Gpt42 = Polar2D(Flag.Gpt33, 90.0, Flag.V05)
  Flag.Gpt43 = Polar2D(Flag.Gpt18,  0.0, Flag.H12)
  Flag.Gpt44 = Polar2D(Flag.Gpt18,  0.0, Flag.H13)
  Flag.Gpt45 = Polar2D(Flag.Gpt18,  0.0, Flag.H14)
  Flag.Gpt46 = Polar2D(Flag.Gpt19,  0.0, Flag.H15)
  Flag.Gpt47 = Polar2D(Flag.Gpt19,  0.0, Flag.H21)
  Flag.Gpt48 = Polar2D(Flag.Gpt19,  0.0, Flag.H11)
  Flag.Gpt49 = Polar2D(Flag.Gpt33, 90.0, Flag.V10)
  Flag.Gpt50 = Polar2D(Flag.Gpt33, 90.0, Flag.V12)
  Flag.Gpt51 = Polar2D(Flag.Gpt34, 90.0, Flag.V11)
  Flag.Gpt52 = Polar2D(Flag.Gpt19,  0.0, Flag.H06)
  Flag.Gpt53 = Polar2D(Flag.Gpt19,  0.0, Flag.H05)
  Flag.Gpt54 = Polar2D(Flag.Gpt19,  0.0, Flag.H03)
  return true
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