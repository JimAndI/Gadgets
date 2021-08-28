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

-- Easy USA Flag Maker is written by JimAndI Gadgets of Houston Texas 2019
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
  layer = job.LayerManager:GetLayerWithName("Navy")
  line:AppendPoint(   (0.9921981923861378 * Flag.HoistFlag) + 1.0 ,(0.6837701287074873 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9859234840084121 * Flag.HoistFlag) + 1.0 ,(0.6538132734289783 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9314564744111240 * Flag.HoistFlag) + 1.0 ,(0.6538132734289783 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9689025435092593 * Flag.HoistFlag) + 1.0 ,(0.8449664138003242 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0506030579051920 * Flag.HoistFlag) + 1.0 ,(0.8449664138003242 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0880491270033280 * Flag.HoistFlag) + 1.0 ,(0.6538132734289783 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0335821174060390 * Flag.HoistFlag) + 1.0 ,(0.6538132734289783 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0273074090283130 * Flag.HoistFlag) + 1.0 ,(0.6837701287074873 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9921981923861378 * Flag.HoistFlag) + 1.0 ,(0.6837701287074873 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Navy")
  line:AppendPoint(   (0.9988213807531676 * Flag.HoistFlag) + 1.0 ,(0.7322457672490746 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0097528007072250 * Flag.HoistFlag) + 1.0 ,(0.8008741993416593 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0206842206612830 * Flag.HoistFlag) + 1.0 ,(0.7322457672490746 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9988213807531676 * Flag.HoistFlag) + 1.0 ,(0.7322457672490746 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Navy")
  line:AppendPoint(   (1.3527253219394370 * Flag.HoistFlag) + 1.0 ,(0.7795528865823652 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3692201135230560 * Flag.HoistFlag) + 1.0 ,(0.8449664138003304 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4208090839360520 * Flag.HoistFlag) + 1.0 ,(0.8449664138003302 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3799588267380820 * Flag.HoistFlag) + 1.0 ,(0.7273437363853257 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3799588267380820 * Flag.HoistFlag) + 1.0 ,(0.6538132734289854 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3254918171407910 * Flag.HoistFlag) + 1.0 ,(0.6538132734289854 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3254918171407910 * Flag.HoistFlag) + 1.0 ,(0.7273437363853257 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2846415599428220 * Flag.HoistFlag) + 1.0 ,(0.8449664138003302 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3362305303558180 * Flag.HoistFlag) + 1.0 ,(0.8449664138003304 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.3527253219394370 * Flag.HoistFlag) + 1.0 ,(0.7795528865823652 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Navy")
  line:AppendPoint(   (1.1473866933266770 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1046876624219560 * Flag.HoistFlag) + 1.0 ,(0.8449662974462279 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1552330473422600 * Flag.HoistFlag) + 1.0 ,(0.8449662974462279 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1813772119349400 * Flag.HoistFlag) + 1.0 ,(0.6992621779283311 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2075213765276180 * Flag.HoistFlag) + 1.0 ,(0.8449662974462279 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2580667614479220 * Flag.HoistFlag) + 1.0 ,(0.8449662974462279 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2153677305432030 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.1473866933266770 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Navy")
  line:AppendPoint(   (0.7508699680779505 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7996724086771239 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7996724086771239 * Flag.HoistFlag) + 1.0 ,(0.7767656824327389 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8362742391265034 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8972772898754704 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8972772898754704 * Flag.HoistFlag) + 1.0 ,(0.8449664138003133 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8484748492762972 * Flag.HoistFlag) + 1.0 ,(0.8449664138003133 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8484748492762972 * Flag.HoistFlag) + 1.0 ,(0.7214055798031709 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8083871302126904 * Flag.HoistFlag) + 1.0 ,(0.8449664138003133 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7508699680779505 * Flag.HoistFlag) + 1.0 ,(0.8449664138003133 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7508699680779505 * Flag.HoistFlag) + 1.0 ,(0.6538132734289684 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Army")
  line:AppendPoint(   (0.8625302464883969 * Flag.HoistFlag) + 1.0 ,(0.1836881174441656 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8562555381106712 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8017885285133827 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8392345976115184 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9209351120074510 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9583811811055863 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9039141715082982 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8976394631305725 * Flag.HoistFlag) + 1.0 ,(0.1836881174441656 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8625302464883969 * Flag.HoistFlag) + 1.0 ,(0.1836881174441656 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Army")
  line:AppendPoint(   (0.8691534348554267 * Flag.HoistFlag) + 1.0 ,(0.2321637559857528 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8800848548094852 * Flag.HoistFlag) + 1.0 ,(0.3007921880783369 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8910162747635418 * Flag.HoistFlag) + 1.0 ,(0.2321637559857528 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8691534348554267 * Flag.HoistFlag) + 1.0 ,(0.2321637559857528 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Army")
  line:AppendPoint(   (0.9909337298102129 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0454007394075020 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0454007394075020 * Flag.HoistFlag) + 1.0 ,(0.2190916736824033 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0550834948725500 * Flag.HoistFlag) + 1.0 ,(0.2190916736824033 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0828468085056380 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1407180062027600 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1056048269439110 * Flag.HoistFlag) + 1.0 ,(0.2321637559857528 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0828468085056490 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0),0.7203939590839940)
  line:LineTo(        (0.9909337298102129 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9909337298102129 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Army")
  line:AppendPoint(   (1.4641158756866790 * Flag.HoistFlag) + 1.0 ,(0.2794708753190364 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4806106672702990 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5321996376832950 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4913493804853260 * Flag.HoistFlag) + 1.0 ,(0.2272617251219970 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4913493804853260 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4368823708880340 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4368823708880340 * Flag.HoistFlag) + 1.0 ,(0.2272617251219970 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3960321136900650 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4476210841030610 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.4641158756866790 * Flag.HoistFlag) + 1.0 ,(0.2794708753190364 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Army")
  line:AppendPoint(   (1.3653944207915880 * Flag.HoistFlag) + 1.0 ,(0.3448844025370005 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3653944207915880 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3109274111942960 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3109274111942960 * Flag.HoistFlag) + 1.0 ,(0.2856627865837109 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2870980944954820 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2462478372975130 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2224185205986970 * Flag.HoistFlag) + 1.0 ,(0.2856627865837091 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2224185205986970 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1679515110014060 * Flag.HoistFlag) + 1.0 ,(0.1537312621656567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1679515110014060 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2462478372975130 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2666729658964970 * Flag.HoistFlag) + 1.0 ,(0.2321637559857528 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2870980944954820 * Flag.HoistFlag) + 1.0 ,(0.3448844025370012 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.3653944207915880 * Flag.HoistFlag) + 1.0 ,(0.3448844025370005 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Army")
  line:AppendPoint(   (1.0609644143634430 * Flag.HoistFlag) + 1.0 ,(0.3007921880783369 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0454007394075020 * Flag.HoistFlag) + 1.0 ,(0.3007921880783371 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0454007394075020 * Flag.HoistFlag) + 1.0 ,(0.2626652813602346 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0610015156565460 * Flag.HoistFlag) + 1.0 ,(0.2626652813602346 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((1.0609644143634430 * Flag.HoistFlag) + 1.0 ,(0.3007921880783369 * Flag.HoistFlag) + 1.0),1.0000000000000000)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.2485215278274409 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3540513589221883 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3540513589221883 * Flag.HoistFlag) + 1.0 ,(0.1979647039204033 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3029885374247299 * Flag.HoistFlag) + 1.0 ,(0.1979647039204032 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3029885374247299 * Flag.HoistFlag) + 1.0 ,(0.2279215591989123 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3438387946226966 * Flag.HoistFlag) + 1.0 ,(0.2279215591989123 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3438387946226966 * Flag.HoistFlag) + 1.0 ,(0.2742185173566078 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3029885374247299 * Flag.HoistFlag) + 1.0 ,(0.2742185173566078 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3029885374247299 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3540513589221883 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3540513589221883 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2485215278274409 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.2485215278274409 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.1225665681337101 * Flag.HoistFlag) + 1.0 ,(0.2742185173566078 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1416300214927622 * Flag.HoistFlag) + 1.0 ,(0.2742185173566078 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.1416300214927669 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0),0.9104575975062623)
  line:LineTo(        (0.1225665681337101 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.1225665681337101 * Flag.HoistFlag) + 1.0 ,(0.2742185173566078 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.1225665681337101 * Flag.HoistFlag) + 1.0 ,(0.1979647039204032 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1225665681337101 * Flag.HoistFlag) + 1.0 ,(0.2328235900626681 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1416300214927613 * Flag.HoistFlag) + 1.0 ,(0.2328235900626681 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.1470767224524903 * Flag.HoistFlag) + 1.0 ,(0.1979647039204033 * Flag.HoistFlag) + 1.0),-0.8053455374806343)
  line:LineTo((0.1225665681337101 * Flag.HoistFlag) + 1.0 ,(0.1979647039204032 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.4486497700628781 * Flag.HoistFlag) + 1.0 ,(0.2328235900626681 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4595811900169358 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4705126099709937 * Flag.HoistFlag) + 1.0 ,(0.2328235900626681 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.4486497700628781 * Flag.HoistFlag) + 1.0 ,(0.2328235900626681 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.4420265816958477 * Flag.HoistFlag) + 1.0 ,(0.1843479515210809 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4357518733181219 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3812848637208330 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4187309328189691 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5004314472149025 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5378775163130387 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4834105067157499 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4771357983380241 * Flag.HoistFlag) + 1.0 ,(0.1843479515210809 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.4420265816958477 * Flag.HoistFlag) + 1.0 ,(0.1843479515210809 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.6740450403062617 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5514942687123610 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5514942687123610 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5855361497106668 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5855361497106668 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6400031593079557 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6400031593079557 * Flag.HoistFlag) + 1.0 ,(0.3014520221552526 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6740450403062614 * Flag.HoistFlag) + 1.0 ,(0.3014520221552524 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6740450403062617 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Beat")
  line:AppendPoint(   (0.1850591245318554 * Flag.HoistFlag) + 1.0 ,(0.2546103939154392 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.1661401758115432 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0),-0.8366246568988599)
  line:LineTo(        (0.0680995585364208 * Flag.HoistFlag) + 1.0 ,(0.1543910962425721 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0680995585364208 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1606934748518125 * Flag.HoistFlag) + 1.0 ,(0.3455442366139171 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.1850591245318554 * Flag.HoistFlag) + 1.0 ,(0.2546103939154392 * Flag.HoistFlag) + 1.0),-0.8097087900559788)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Go")
  line:AppendPoint(   (0.2682281047383657 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2682045600921377 * Flag.HoistFlag) + 1.0 ,(0.7641895814217237 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2708163306583983 * Flag.HoistFlag) + 1.0 ,(0.7717817488138503 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2737437813954802 * Flag.HoistFlag) + 1.0 ,(0.7785026135372630 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2769903179906938 * Flag.HoistFlag) + 1.0 ,(0.7843629966834609 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2805593461313501 * Flag.HoistFlag) + 1.0 ,(0.7893737193439427 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2844542715047597 * Flag.HoistFlag) + 1.0 ,(0.7935456026102076 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2886784997982333 * Flag.HoistFlag) + 1.0 ,(0.7968894675737540 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2932354366990816 * Flag.HoistFlag) + 1.0 ,(0.7994161353260810 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2981284878946153 * Flag.HoistFlag) + 1.0 ,(0.8011364269586875 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3029573130280937 * Flag.HoistFlag) + 1.0 ,(0.8023499225134306 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3074704755570360 * Flag.HoistFlag) + 1.0 ,(0.8032090106957732 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3119717316514248 * Flag.HoistFlag) + 1.0 ,(0.8035238130886453 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3167648374812426 * Flag.HoistFlag) + 1.0 ,(0.8031044512749766 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3221535492164720 * Flag.HoistFlag) + 1.0 ,(0.8017610468376974 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3284416230270953 * Flag.HoistFlag) + 1.0 ,(0.7993037213597374 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3359328150830953 * Flag.HoistFlag) + 1.0 ,(0.7955425964240266 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3449308815544543 * Flag.HoistFlag) + 1.0 ,(0.7902877936134948 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3449176542513503 * Flag.HoistFlag) + 1.0 ,(0.8374955240180406 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3397376641871883 * Flag.HoistFlag) + 1.0 ,(0.8405239018291600 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3343394417805096 * Flag.HoistFlag) + 1.0 ,(0.8426952472808991 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3287473156378368 * Flag.HoistFlag) + 1.0 ,(0.8441492603000070 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3229856143656921 * Flag.HoistFlag) + 1.0 ,(0.8450256408132333 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3110508008590773 * Flag.HoistFlag) + 1.0 ,(0.8456043040290375 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2987296301128444 * Flag.HoistFlag) + 1.0 ,(0.8455488363423067 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.2178929018520290 * Flag.HoistFlag) + 1.0 ,(0.7642011873191035 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.2173819810896410 * Flag.HoistFlag) + 1.0 ,(0.7358783423285120 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.2987296301128444 * Flag.HoistFlag) + 1.0 ,(0.6545306933053087 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.3064478481647098 * Flag.HoistFlag) + 1.0 ,(0.6547323278975945 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3135923452879747 * Flag.HoistFlag) + 1.0 ,(0.6553448254783978 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3201791437858746 * Flag.HoistFlag) + 1.0 ,(0.6563795767536381 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3262242659616450 * Flag.HoistFlag) + 1.0 ,(0.6578479724292351 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3317437341185213 * Flag.HoistFlag) + 1.0 ,(0.6597614032111080 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3367535705597389 * Flag.HoistFlag) + 1.0 ,(0.6621312598051763 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3412697975885333 * Flag.HoistFlag) + 1.0 ,(0.6649689329173594 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3453084375081398 * Flag.HoistFlag) + 1.0 ,(0.6682858132535767 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3488855126217939 * Flag.HoistFlag) + 1.0 ,(0.6720932915197476 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3520170452327311 * Flag.HoistFlag) + 1.0 ,(0.6764027584217915 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3547190576441869 * Flag.HoistFlag) + 1.0 ,(0.6812256046656280 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3570075721593965 * Flag.HoistFlag) + 1.0 ,(0.6865732209571762 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3588986110815955 * Flag.HoistFlag) + 1.0 ,(0.6924569980023558 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3604081967140194 * Flag.HoistFlag) + 1.0 ,(0.6988883265070861 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3615523513599034 * Flag.HoistFlag) + 1.0 ,(0.7058785971772865 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3623470973224832 * Flag.HoistFlag) + 1.0 ,(0.7134392007188766 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3623470973224832 * Flag.HoistFlag) + 1.0 ,(0.7642011873191035 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2996011022664049 * Flag.HoistFlag) + 1.0 ,(0.7642011873191035 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2996011022664049 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3187734896446510 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3187734896446510 * Flag.HoistFlag) + 1.0 ,(0.7136558024127652 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.2996011022664049 * Flag.HoistFlag) + 1.0 ,(0.6944834150345703 * Flag.HoistFlag) + 1.0),-0.4142135623730951)
  line:ArcTo( Point2D((0.2682281047383657 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0),-0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Go")
  line:AppendPoint(   (0.4554294764608751 * Flag.HoistFlag) + 1.0 ,(0.7716344484237005 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4554294764608675 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4860961431275268 * Flag.HoistFlag) + 1.0 ,(0.6986756345101699 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.5167628097941933 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.5167628097941933 * Flag.HoistFlag) + 1.0 ,(0.7716344484237005 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4860961431275268 * Flag.HoistFlag) + 1.0 ,(0.8023011150903673 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.4554294764608751 * Flag.HoistFlag) + 1.0 ,(0.7716344484237005 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Go")
  line:AppendPoint(   (0.4041777606932022 * Flag.HoistFlag) + 1.0 ,(0.7293423011768222 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4041777606932022 * Flag.HoistFlag) + 1.0 ,(0.7641895444608868 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.4860961431275268 * Flag.HoistFlag) + 1.0 ,(0.8455488363423067 * Flag.HoistFlag) + 1.0),-0.4142135623730951)
  line:ArcTo( Point2D((0.5680145255618514 * Flag.HoistFlag) + 1.0 ,(0.7642011873191035 * Flag.HoistFlag) + 1.0),-0.4142135623730951)
  line:LineTo(        (0.5680145255618514 * Flag.HoistFlag) + 1.0 ,(0.7293423011768366 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5670142517427443 * Flag.HoistFlag) + 1.0 ,(0.7216030983625253 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5652892575023268 * Flag.HoistFlag) + 1.0 ,(0.7141080906172432 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5628771364999356 * Flag.HoistFlag) + 1.0 ,(0.7068924783496935 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5598154823949075 * Flag.HoistFlag) + 1.0 ,(0.6999914619685799 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5561418888465794 * Flag.HoistFlag) + 1.0 ,(0.6934402418826059 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5518939495142885 * Flag.HoistFlag) + 1.0 ,(0.6872740185004751 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5471092580573714 * Flag.HoistFlag) + 1.0 ,(0.6815279922308908 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5418254081351650 * Flag.HoistFlag) + 1.0 ,(0.6762373634825567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5360799934070062 * Flag.HoistFlag) + 1.0 ,(0.6714373326641762 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5299106075322320 * Flag.HoistFlag) + 1.0 ,(0.6671631001844527 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5233548441701792 * Flag.HoistFlag) + 1.0 ,(0.6634498664520900 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5164502969801845 * Flag.HoistFlag) + 1.0 ,(0.6603328318757914 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5092345596215851 * Flag.HoistFlag) + 1.0 ,(0.6578471968642605 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5017452257537178 * Flag.HoistFlag) + 1.0 ,(0.6560281618262007 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4940198890359194 * Flag.HoistFlag) + 1.0 ,(0.6549109271703156 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4860961431275268 * Flag.HoistFlag) + 1.0 ,(0.6545306933053087 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4781723972191342 * Flag.HoistFlag) + 1.0 ,(0.6549109271703157 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4704470605013358 * Flag.HoistFlag) + 1.0 ,(0.6560281618262007 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4629577266334685 * Flag.HoistFlag) + 1.0 ,(0.6578471968642605 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4557419892748691 * Flag.HoistFlag) + 1.0 ,(0.6603328318757915 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4488374420848745 * Flag.HoistFlag) + 1.0 ,(0.6634498664520900 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4422816787228215 * Flag.HoistFlag) + 1.0 ,(0.6671631001844529 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4361122928480473 * Flag.HoistFlag) + 1.0 ,(0.6714373326641763 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4303668781198885 * Flag.HoistFlag) + 1.0 ,(0.6762373634825567 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4250830281976821 * Flag.HoistFlag) + 1.0 ,(0.6815279922308908 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4202983367407649 * Flag.HoistFlag) + 1.0 ,(0.6872740185004751 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4160503974084738 * Flag.HoistFlag) + 1.0 ,(0.6934402418826059 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4123768038601459 * Flag.HoistFlag) + 1.0 ,(0.6999914619685799 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4093151497551177 * Flag.HoistFlag) + 1.0 ,(0.7068924783496935 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4069030287527264 * Flag.HoistFlag) + 1.0 ,(0.7141080906172432 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4051780345123088 * Flag.HoistFlag) + 1.0 ,(0.7216030983625253 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.4041777606932022 * Flag.HoistFlag) + 1.0 ,(0.7293423011768222 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Upper")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Lower")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
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
    Flag.Inquiry = InquiryNumberBox("GO NAVY BEAT ARMY Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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