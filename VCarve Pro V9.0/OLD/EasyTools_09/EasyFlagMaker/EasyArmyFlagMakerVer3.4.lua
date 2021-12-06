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

-- Easy USA Flag Maker is written by Jim Anderson of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
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
-- ===================================================]]
function DrawFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.9779670902853840 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9982142913077119 * Flag.HoistFlag) + 1.0 ,(0.1680010153299374 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9982142913077119 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0235232925856210 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0235232925856210 * Flag.HoistFlag) + 1.0 ,(0.1680010153299374 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0437704936079490 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0193051257059700 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0103311327121850 * Flag.HoistFlag) + 1.0 ,(0.1908549116661738 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0024324581873640 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9779670902853840 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.7844513076975494 * Flag.HoistFlag) + 1.0 ,(0.1391170472941495 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7965448097941956 * Flag.HoistFlag) + 1.0 ,(0.1391170472941494 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7984285424766936 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8218047660557858 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8086229945568749 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7726812463908680 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7594994748919571 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7825675750150511 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7844513076975494 * Flag.HoistFlag) + 1.0 ,(0.1391170472941495 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.7863439958392516 * Flag.HoistFlag) + 1.0 ,(0.1597624081431182 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7946521216524931 * Flag.HoistFlag) + 1.0 ,(0.1597624081431176 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7904980587458724 * Flag.HoistFlag) + 1.0 ,(0.2050747476706238 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7863439958392516 * Flag.HoistFlag) + 1.0 ,(0.1597624081431182 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.7298404890194078 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7529085891425018 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7529085891425018 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7298404890194078 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7298404890194078 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.6606361886501259 * Flag.HoistFlag) + 1.0 ,(0.2093911187479413 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6756333537198667 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7028178574466386 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7173336242212413 * Flag.HoistFlag) + 1.0 ,(0.2093911187479413 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7173336242212413 * Flag.HoistFlag) + 1.0 ,(0.1908549116661740 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6935906173974028 * Flag.HoistFlag) + 1.0 ,(0.1908549116661740 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6935906173974028 * Flag.HoistFlag) + 1.0 ,(0.2050747476706239 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6853520102105836 * Flag.HoistFlag) + 1.0 ,(0.2050747476706239 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6853520102105836 * Flag.HoistFlag) + 1.0 ,(0.1824185779068710 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7028178574466387 * Flag.HoistFlag) + 1.0 ,(0.1824185779068710 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7173336242212410 * Flag.HoistFlag) + 1.0 ,(0.1680010153299374 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7173336242212410 * Flag.HoistFlag) + 1.0 ,(0.1344764749653327 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7028178574466386 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6756333537198665 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6606361886501259 * Flag.HoistFlag) + 1.0 ,(0.1344764749653327 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6606361886501259 * Flag.HoistFlag) + 1.0 ,(0.1537742136303020 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6853520102105836 * Flag.HoistFlag) + 1.0 ,(0.1537742136303020 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6853520102105836 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6935906173974028 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6935906173974028 * Flag.HoistFlag) + 1.0 ,(0.1618220599398231 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6756333537198667 * Flag.HoistFlag) + 1.0 ,(0.1618220599398231 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6606361886501256 * Flag.HoistFlag) + 1.0 ,(0.1775592496615127 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6606361886501259 * Flag.HoistFlag) + 1.0 ,(0.2093911187479413 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.5957250696448580 * Flag.HoistFlag) + 1.0 ,(0.1185693722090222 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6114183589651891 * Flag.HoistFlag) + 1.0 ,(0.1342626615293535 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6112045455292100 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5881364454061160 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5881364454061160 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5782501167819328 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5782501167819328 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5551820166588389 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5551820166588388 * Flag.HoistFlag) + 1.0 ,(0.1344764749653327 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5710891194151492 * Flag.HoistFlag) + 1.0 ,(0.1185693722090222 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.5957250696448580 * Flag.HoistFlag) + 1.0 ,(0.1185693722090222 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.6243863170281209 * Flag.HoistFlag) + 1.0 ,(0.1185693722090222 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6474544171512149 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6474544171512149 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6243863170281209 * Flag.HoistFlag) + 1.0 ,(0.1412255419727750 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6243863170281209 * Flag.HoistFlag) + 1.0 ,(0.1185693722090222 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.9305988689478260 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9392847072780489 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9505551219096234 * Flag.HoistFlag) + 1.0 ,(0.1824185779068710 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9505551219096234 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9703277791579900 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9703277791579900 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9435028741577006 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9351657787720676 * Flag.HoistFlag) + 1.0 ,(0.1775592496615125 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9263807020681744 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8995557970678850 * Flag.HoistFlag) + 1.0 ,(0.2256712656376719 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8995557970678850 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9193284543162514 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9193284543162514 * Flag.HoistFlag) + 1.0 ,(0.1824185779068735 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9305988689478260 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.8287037752612392 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8287037752612392 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8682336543394655 * Flag.HoistFlag) + 1.0 ,(0.2256712656376720 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8863740255689742 * Flag.HoistFlag) + 1.0 ,(0.2093911187479413 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8863740255689746 * Flag.HoistFlag) + 1.0 ,(0.1844794215428988 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8728555454262454 * Flag.HoistFlag) + 1.0 ,(0.1718134770901880 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8863740255689744 * Flag.HoistFlag) + 1.0 ,(0.1582949969474586 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8863740255689742 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8616582040085164 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8616582040085164 * Flag.HoistFlag) + 1.0 ,(0.1618220599398230 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8517718753843333 * Flag.HoistFlag) + 1.0 ,(0.1618220599398230 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8517718753843333 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8287037752612392 * Flag.HoistFlag) + 1.0 ,(0.1185693722090221 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Letters")
  line:AppendPoint(   (0.8517718753843333 * Flag.HoistFlag) + 1.0 ,(0.1824185779068710 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8517718753843333 * Flag.HoistFlag) + 1.0 ,(0.2050747476706238 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8616582040085167 * Flag.HoistFlag) + 1.0 ,(0.2050747476706238 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8616582040085164 * Flag.HoistFlag) + 1.0 ,(0.1824185779068710 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8517718753843333 * Flag.HoistFlag) + 1.0 ,(0.1824185779068710 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Star")
  line:AppendPoint(   (0.6049922942493898 * Flag.HoistFlag) + 1.0 ,(0.6772307448375502 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7265971586633974 * Flag.HoistFlag) + 1.0 ,(0.5892850907471244 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6799099152313709 * Flag.HoistFlag) + 1.0 ,(0.4466580160969701 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8011291723364989 * Flag.HoistFlag) + 1.0 ,(0.5351344131157391 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9223484294416269 * Flag.HoistFlag) + 1.0 ,(0.4466580160969703 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8756611860096004 * Flag.HoistFlag) + 1.0 ,(0.5892850907471244 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9972660504236086 * Flag.HoistFlag) + 1.0 ,(0.6772307448375497 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8471924900364478 * Flag.HoistFlag) + 1.0 ,(0.6769027276685445 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8011291723364989 * Flag.HoistFlag) + 1.0 ,(0.8197325280780366 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7550658546365504 * Flag.HoistFlag) + 1.0 ,(0.6769027276685445 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6049922942493898 * Flag.HoistFlag) + 1.0 ,(0.6772307448375502 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Star")
  line:AppendPoint(   (0.5383590493327066 * Flag.HoistFlag) + 1.0 ,(0.6988811985348911 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7012765255950577 * Flag.HoistFlag) + 1.0 ,(0.5810579183421347 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6387283050921647 * Flag.HoistFlag) + 1.0 ,(0.3899763924454743 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8011291723364989 * Flag.HoistFlag) + 1.0 ,(0.5085107239505816 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9635300395808337 * Flag.HoistFlag) + 1.0 ,(0.3899763924454747 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9009818190779403 * Flag.HoistFlag) + 1.0 ,(0.5810579183421347 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0638992953402910 * Flag.HoistFlag) + 1.0 ,(0.6988811985348908 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8628415018893460 * Flag.HoistFlag) + 1.0 ,(0.6984417446561131 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8011291723364989 * Flag.HoistFlag) + 1.0 ,(0.8897948679863465 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7394168427836518 * Flag.HoistFlag) + 1.0 ,(0.6984417446561131 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.5383590493327066 * Flag.HoistFlag) + 1.0 ,(0.6988811985348911 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Star")
  line:AppendPoint(   (0.8341516468256989 * Flag.HoistFlag) + 1.0 ,(0.6589535468455707 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8011291723364989 * Flag.HoistFlag) + 1.0 ,(0.7613472448211132 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7681066978472990 * Flag.HoistFlag) + 1.0 ,(0.6589535468455707 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6605199983466257 * Flag.HoistFlag) + 1.0 ,(0.6591887000897649 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7476976862203470 * Flag.HoistFlag) + 1.0 ,(0.5961410677512827 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7142279236807095 * Flag.HoistFlag) + 1.0 ,(0.4938927024732171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8011291723364989 * Flag.HoistFlag) + 1.0 ,(0.5573208207533704 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8880304209922885 * Flag.HoistFlag) + 1.0 ,(0.4938927024732171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8545606584526510 * Flag.HoistFlag) + 1.0 ,(0.5961410677512827 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9417383463263725 * Flag.HoistFlag) + 1.0 ,(0.6591887000897649 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8341516468256989 * Flag.HoistFlag) + 1.0 ,(0.6589535468455707 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Box")
  line:AppendPoint(   (0.5031842196476488 * Flag.HoistFlag) + 1.0 ,(0.3941824960347965 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5479858059602846 * Flag.HoistFlag) + 1.0 ,(0.3493809097221609 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0512615273896630 * Flag.HoistFlag) + 1.0 ,(0.3493809097221609 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0960631137022990 * Flag.HoistFlag) + 1.0 ,(0.3941824960347965 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0960631137022990 * Flag.HoistFlag) + 1.0 ,(0.8633624943003317 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0512615273896630 * Flag.HoistFlag) + 1.0 ,(0.9081640806129674 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.5479858059602846 * Flag.HoistFlag) + 1.0 ,(0.9081640806129674 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5031842196476488 * Flag.HoistFlag) + 1.0 ,(0.8633624943003317 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((0.5031842196476488 * Flag.HoistFlag) + 1.0 ,(0.3941824960347965 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Box")
  line:AppendPoint(   (0.4852635851225946 * Flag.HoistFlag) + 1.0 ,(0.3762618615097423 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5300651714352304 * Flag.HoistFlag) + 1.0 ,(0.3314602751971066 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0691821619147170 * Flag.HoistFlag) + 1.0 ,(0.3314602751971066 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.1139837482273530 * Flag.HoistFlag) + 1.0 ,(0.3762618615097423 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.1139837482273530 * Flag.HoistFlag) + 1.0 ,(0.8812831288253860 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0691821619147170 * Flag.HoistFlag) + 1.0 ,(0.9260847151380214 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.5300651714352304 * Flag.HoistFlag) + 1.0 ,(0.9260847151380214 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4852635851225946 * Flag.HoistFlag) + 1.0 ,(0.8812831288253860 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((0.4852635851225946 * Flag.HoistFlag) + 1.0 ,(0.3762618615097423 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Box")
  line:AppendPoint(   (0.4680919279614699 * Flag.HoistFlag) + 1.0 ,(0.3583412269846881 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5128935142741056 * Flag.HoistFlag) + 1.0 ,(0.3135396406720524 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0863538190758420 * Flag.HoistFlag) + 1.0 ,(0.3135396406720524 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.1311554053884780 * Flag.HoistFlag) + 1.0 ,(0.3583412269846881 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.1311554053884780 * Flag.HoistFlag) + 1.0 ,(0.8992037633504402 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0863538190758420 * Flag.HoistFlag) + 1.0 ,(0.9440053496630758 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.5128935142741056 * Flag.HoistFlag) + 1.0 ,(0.9440053496630758 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4680919279614699 * Flag.HoistFlag) + 1.0 ,(0.8992037633504402 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((0.4680919279614699 * Flag.HoistFlag) + 1.0 ,(0.3583412269846881 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Box")
  line:AppendPoint(   (0.4688445946115221 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5270866568179485 * Flag.HoistFlag) + 1.0 ,(0.0559946503369242 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0736660098321040 * Flag.HoistFlag) + 1.0 ,(0.0559946503369242 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.1319080720385300 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.1319080720385300 * Flag.HoistFlag) + 1.0 ,(0.2337643931071731 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0736660098321040 * Flag.HoistFlag) + 1.0 ,(0.2920064553135995 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.5270866568179485 * Flag.HoistFlag) + 1.0 ,(0.2920064553135995 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4688445946115221 * Flag.HoistFlag) + 1.0 ,(0.2337643931071731 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((0.4688445946115221 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Box")
  line:AppendPoint(   (1.0769237835602300 * Flag.HoistFlag) + 1.0 ,(0.0739152848619785 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.1172452112416020 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0),0.4142135623730954)
  line:LineTo(        (1.1172452112416020 * Flag.HoistFlag) + 1.0 ,(0.2337643931071731 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0769237835602300 * Flag.HoistFlag) + 1.0 ,(0.2740858207885452 * Flag.HoistFlag) + 1.0),0.4142135623730948)
  line:LineTo(        (0.5238288830898221 * Flag.HoistFlag) + 1.0 ,(0.2740858207885452 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4835074554084500 * Flag.HoistFlag) + 1.0 ,(0.2337643931071731 * Flag.HoistFlag) + 1.0),0.4142135623730954)
  line:LineTo(        (0.4835074554084500 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5238288830898221 * Flag.HoistFlag) + 1.0 ,(0.0739152848619785 * Flag.HoistFlag) + 1.0),0.4142135623730948)
  line:LineTo((1.0769237835602300 * Flag.HoistFlag) + 1.0 ,(0.0739152848619785 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Box")
  line:AppendPoint(   (0.5014280899335042 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5238288830898221 * Flag.HoistFlag) + 1.0 ,(0.0918359193870327 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0769237835602300 * Flag.HoistFlag) + 1.0 ,(0.0918359193870327 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0993245767165480 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (1.0993245767165480 * Flag.HoistFlag) + 1.0 ,(0.2337643931071731 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0769237835602300 * Flag.HoistFlag) + 1.0 ,(0.2561651862634909 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.5238288830898221 * Flag.HoistFlag) + 1.0 ,(0.2561651862634909 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5014280899335042 * Flag.HoistFlag) + 1.0 ,(0.2337643931071731 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((0.5014280899335042 * Flag.HoistFlag) + 1.0 ,(0.1142367125433505 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Border")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
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
    Flag.Inquiry = InquiryNumberBox("ARMY Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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