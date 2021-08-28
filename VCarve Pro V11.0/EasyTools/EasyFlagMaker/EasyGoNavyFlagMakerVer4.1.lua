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
DialogWindow.GONAVY = [[data:image/png;base64,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]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.GONAVY ..[[" width="260" height="140">
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