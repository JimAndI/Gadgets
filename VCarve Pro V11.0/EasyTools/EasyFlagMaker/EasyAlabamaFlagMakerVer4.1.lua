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
DialogWindow.Alabama = [[data:image/png;base64,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]]
--  ===================================================
function FlagMath()
  Flag.Gpt1 =  Point2D(1.0, 1.0) ; Flag.Gpt2 = Polar2D(Flag.Gpt1, 0.00, Flag.H10) ; Flag.Gpt3 = Polar2D(Flag.Gpt2, 90.0, Flag.V10) ; Flag.Gpt4 = Polar2D(Flag.Gpt1, 90.00, Flag.V10) ; Flag.Gpt5 = Polar2D(Flag.Gpt1, 90.0, Flag.V05) ; Flag.Gpt6 = Polar2D(Flag.Gpt1, 0.0, Flag.H05) ; Flag.Gpt7  = Polar2D(Flag.Gpt1, 0.00, Flag.H01) ; Flag.Gpt8 = Polar2D(Flag.Gpt1, 0.00, Flag.H02) ; Flag.Gpt9 =  Polar2D(Flag.Gpt5, 0.0, Flag.H03) ; Flag.Gpt10 = Polar2D(Flag.Gpt5, 0.00, Flag.H04) ; Flag.Gpt11 = Polar2D(Flag.Gpt5, 0.00, Flag.H06) ; Flag.Gpt12 = Polar2D(Flag.Gpt5, 0.00, Flag.H07) ; Flag.Gpt13 = Polar2D(Flag.Gpt1, 0.00, Flag.H08) ; Flag.Gpt14 = Polar2D(Flag.Gpt1, 0.00, Flag.H09) ; Flag.Gpt15 = Polar2D(Flag.Gpt4, 0.00, Flag.H01) ; Flag.Gpt16 = Polar2D(Flag.Gpt4, 0.0, Flag.H02) ; Flag.Gpt17 = Polar2D(Flag.Gpt4,  0.00, Flag.H08) ; Flag.Gpt18 = Polar2D(Flag.Gpt4, 0.00, Flag.H09) ; Flag.Gpt19 =  Polar2D(Flag.Gpt6,  90.0, Flag.V03 ) ; Flag.Gpt20 =  Polar2D(Flag.Gpt6, 90.00, Flag.V04) ; Flag.Gpt21 = Polar2D(Flag.Gpt6, 90.00, Flag.V06) ; Flag.Gpt22 =  Polar2D(Flag.Gpt6, 90.00, Flag.V07) ; Flag.Gpt23 =  Polar2D(Flag.Gpt6, 90.00, Flag.V05) ; Flag.Gpt24 =  Polar2D(Flag.Gpt1, 90.00, Flag.V01) ; Flag.Gpt25 =  Polar2D(Flag.Gpt1, 90.00, Flag.V02) ; Flag.Gpt26 = Polar2D(Flag.Gpt1, 90.0, Flag.V08) ; Flag.Gpt27 =  Polar2D(Flag.Gpt1, 90.0, Flag.V09) ; Flag.Gpt28 =  Polar2D(Flag.Gpt2, 90.0, Flag.V01) ; Flag.Gpt29 =  Polar2D(Flag.Gpt2, 90.0, Flag.V02) ; Flag.Gpt30 = Polar2D(Flag.Gpt2, 90.00, Flag.V08) ; Flag.Gpt31 =  Polar2D(Flag.Gpt2, 90.0, Flag.V09)
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Alabama ..[[" width="260" height="120">
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
function AlabamaFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Alabama Boarder")
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
  local layer = job.LayerManager:GetLayerWithName("Cross Red")
  line:AppendPoint(Flag.Gpt1) ;
  line:LineTo(Flag.Gpt7) ;
  line:LineTo(Flag.Gpt20) ;
  line:LineTo(Flag.Gpt14) ;
  line:LineTo(Flag.Gpt2) ;
  line:LineTo(Flag.Gpt28) ;
  line:LineTo(Flag.Gpt11) ;
  line:LineTo(Flag.Gpt31) ;
  line:LineTo(Flag.Gpt3) ;
  line:LineTo(Flag.Gpt18) ;
  line:LineTo(Flag.Gpt21) ;
  line:LineTo(Flag.Gpt15) ;
  line:LineTo(Flag.Gpt4) ;
  line:LineTo(Flag.Gpt27) ;
  line:LineTo(Flag.Gpt10) ;
  line:LineTo(Flag.Gpt24) ;
  line:LineTo(Flag.Gpt1) ; layer:AddObject(CreateCadContour(line), true)
  return true
end
-- ===================================================
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n")
    return false ;
  end

  local Loops = true

  while Loops do
    Flag.Inquiry = InquiryNumberBox("Alabama Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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
    Flag.H01 = 0.10338 * Flag.HoistFlag ; Flag.H02 = 0.155652 * Flag.HoistFlag ; Flag.H03 = 0.59638 * Flag.HoistFlag ; Flag.H04 = 0.646089 * Flag.HoistFlag ; Flag.H05 = 0.792251 * Flag.HoistFlag ; Flag.H06 = 0.93844 * Flag.HoistFlag ; Flag.H07 = 0.988139 * Flag.HoistFlag ; Flag.H08 = 1.428851 * Flag.HoistFlag ; Flag.H09 = 1.481123 * Flag.HoistFlag ; Flag.H10 = 1.584502 * Flag.HoistFlag ; Flag.V01 = 0.111669 * Flag.HoistFlag ; Flag.V02 = 0.141558 * Flag.HoistFlag ; Flag.V03 = 0.382355 * Flag.HoistFlag ; Flag.V04 = 0.41388 * Flag.HoistFlag ; Flag.V05 = 0.499858 * Flag.HoistFlag ; Flag.V06 = 0.585836 * Flag.HoistFlag ; Flag.V07 = 0.617361 * Flag.HoistFlag ; Flag.V08 = 0.858158 * Flag.HoistFlag ; Flag.V09 =0.888046 * Flag.HoistFlag ; Flag.V10 = 0.999716 * Flag.HoistFlag ; Flag.StarInRadius = 0.019 * Flag.HoistFlag ; Flag.StarOutRadius = 0.05 * Flag.HoistFlag ; Flag.R03 =0.26 * Flag.HoistFlag ; Flag.R04 = 0.52 * Flag.HoistFlag ; Flag.R05 =0.78 * Flag.HoistFlag ;
-- ======

    FlagMath(job)
    AlabamaFlag(job)
    Cross(job)

    ThreePoint(job, Flag.Gpt7,  Flag.Gpt20, Flag.Gpt14, "White1")
    ThreePoint(job, Flag.Gpt28, Flag.Gpt31, Flag.Gpt11, "White2")
    ThreePoint(job, Flag.Gpt21, Flag.Gpt18, Flag.Gpt15, "White3")
    ThreePoint(job, Flag.Gpt10, Flag.Gpt27, Flag.Gpt24, "White4")

  end
  return true
end  -- function end
-- ===================================================