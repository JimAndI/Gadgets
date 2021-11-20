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
Flag.HoistUnion = 0.5385
Flag.FlyFlag = 1.6
Flag.FlyUnion = 0.76
Flag.UnionStarCentersV = 0.054
Flag.UnionStarCentersH = 0.063
Flag.StarDia = 0.0616
Flag.Strip = 0.0769
-- ==================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==================================================]]
DialogWindow.Sweden = [[data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAABLAAAALuAgMAAADDGwfhAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACVBMVEUAaqf+zAD///9Dh+PyAAAAAWJLR0QCZgt8ZAAAAAd0SU1FB+EICQQgFNTjPs8AAAOlSURBVHja7dBBCQBACABBbWYJ+1e5Cn5EOGYTLBOxWfakCsGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFintcbBggULFixYggULFixYsAQLFixYsGAJFixYsGDBEixYsGDBgiVYsGDBggVLsGDBggULlmDBggULFizBggULFixYggULFixYsAQLFixYsGAJFixYsGDBEixYsGDBgiVYsGDBggVLsGDBggULlmDBggULFizBggULFixYggULFixYsAQLFixYsGAJFixYsGDBEixYsGDBgiVYsGDBggVLsGDBggULlmDBggULFizBggULFqxfsVbL0UOFYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWLFiCBQsWLFiwBAsWLFiwYAkWLFiwYMESLFiwYMGCJViwYMGCBUuwYMGCBQuWYMGCBQsWLMGCBQsWrMsetJvF8jcf48MAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTctMDgtMDlUMDQ6MzI6MjArMDA6MDDU8akDAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE3LTA4LTA5VDA0OjMyOjIwKzAwOjAwpawRvwAAAABJRU5ErkJggg==]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Sweden ..[[" width="260" height="140">
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
  local dialog = HTML_Dialog(true, myHtml, 300, 270, Header .. " " .. Flag.Version) ;
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
function DrawFlag(job)
 local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Yelow")
  line:AppendPoint(   (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.6000000000000001 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7000000000000001 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.4000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Border")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ===================================================]]
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
    Flag.Inquiry = InquiryNumberBox("Sweden Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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
    DrawFlag(job)
  end
  return true

end  -- function end
-- ===================================================]]