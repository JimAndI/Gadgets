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
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Version = "(Ver: 4.0)"
Flag.FlyFlag = 2.0
DialogWindow.Texad = [[data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgdmVyc2lvbj0iMS4wIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMTA4MCIgaGVpZ2h0PSI3MjAiPg0KCTxyZWN0IHdpZHRoPSIxMDgwIiBoZWlnaHQ9IjcyMCIgZmlsbD0iI2ZmZiIvPg0KCTxyZWN0IHk9IjM2MCIgd2lkdGg9IjEwODAiIGhlaWdodD0iMzYwIiBmaWxsPSIjYmYwYTMwIi8+DQoJPHJlY3Qgd2lkdGg9IjM2MCIgaGVpZ2h0PSI3MjAiIGZpbGw9IiMwMDI4NjgiLz4NCgk8ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxODAsMzYwKSIgZmlsbD0iI2ZmZiI+DQoJCTxnIGlkPSJjIj4NCgkJCTxwYXRoIGlkPSJ0IiBkPSJNIDAsLTEzNSB2IDEzNSBoIDY3LjUiIHRyYW5zZm9ybT0icm90YXRlKDE4IDAsLTEzNSkiLz4NCgkJCTx1c2UgeGxpbms6aHJlZj0iI3QiIHRyYW5zZm9ybT0ic2NhbGUoLTEsMSkiLz4NCgkJPC9nPg0KCQk8dXNlIHhsaW5rOmhyZWY9IiNjIiB0cmFuc2Zvcm09InJvdGF0ZSg3MikiLz4NCgkJPHVzZSB4bGluazpocmVmPSIjYyIgdHJhbnNmb3JtPSJyb3RhdGUoMTQ0KSIvPg0KCQk8dXNlIHhsaW5rOmhyZWY9IiNjIiB0cmFuc2Zvcm09InJvdGF0ZSgyMTYpIi8+DQoJCTx1c2UgeGxpbms6aHJlZj0iI2MiIHRyYW5zZm9ybT0icm90YXRlKDI4OCkiLz4NCgk8L2c+DQo8L3N2Zz4=]]

DialogWindow.Australia = [[data:image/png;base64,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']]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.Australia ..[[" width="260" height="120">
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
function DrawFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint(   (0.5000000000000004 * Flag.HoistFlag) + 1.0 ,(0.3999999999999990 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5289255102938863 * Flag.HoistFlag) + 1.0 ,(0.3100644410320138 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6172554893482860 * Flag.HoistFlag) + 1.0 ,(0.3435175798960579 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5649964977532730 * Flag.HoistFlag) + 1.0 ,(0.2648282669944529 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6462054302840062 * Flag.HoistFlag) + 1.0 ,(0.2166167026635173 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5521219685259576 * Flag.HoistFlag) + 1.0 ,(0.2084341171243882 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5650825608676338 * Flag.HoistFlag) + 1.0 ,(0.1148546698146376 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.1833335000000015 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4349447383062585 * Flag.HoistFlag) + 1.0 ,(0.1148798980448367 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4478815712645610 * Flag.HoistFlag) + 1.0 ,(0.2084368615942312 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3537945697159915 * Flag.HoistFlag) + 1.0 ,(0.2166167026635173 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4350049683425308 * Flag.HoistFlag) + 1.0 ,(0.2648346918436002 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3827445106517141 * Flag.HoistFlag) + 1.0 ,(0.3435175798960575 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4710865015620997 * Flag.HoistFlag) + 1.0 ,(0.3100394981560753 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.5000000000000004 * Flag.HoistFlag) + 1.0 ,(0.3999999999999990 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint(   (1.6000001633074130 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6108754447236500 * Flag.HoistFlag) + 1.0 ,(0.4733015411968826 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6396276718644770 * Flag.HoistFlag) + 1.0 ,(0.4712088111046210 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6176034085344640 * Flag.HoistFlag) + 1.0 ,(0.4526133592964546 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6244605167599420 * Flag.HoistFlag) + 1.0 ,(0.4246461193156996 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6000000000000070 * Flag.HoistFlag) + 1.0 ,(0.4398219999999933 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5755207362632840 * Flag.HoistFlag) + 1.0 ,(0.4246603005174638 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5823949928268670 * Flag.HoistFlag) + 1.0 ,(0.4526127864171277 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5603723281355370 * Flag.HoistFlag) + 1.0 ,(0.4712088111046210 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5891317872841920 * Flag.HoistFlag) + 1.0 ,(0.4732918114898911 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.6000001633074130 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint(   (1.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.9047329999999425 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5137496513959310 * Flag.HoistFlag) + 1.0 ,(0.8618881217620930 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5558227678482000 * Flag.HoistFlag) + 1.0 ,(0.8778501718526973 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5309163036148470 * Flag.HoistFlag) + 1.0 ,(0.8403931011380775 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5696098529297650 * Flag.HoistFlag) + 1.0 ,(0.8174450053155029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5248266280600340 * Flag.HoistFlag) + 1.0 ,(0.8135217996454116 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5309792989729770 * Flag.HoistFlag) + 1.0 ,(0.7690038228317510 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.8015445000000510 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4690207010269890 * Flag.HoistFlag) + 1.0 ,(0.7690038228317510 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4751596500272460 * Flag.HoistFlag) + 1.0 ,(0.8135272616812604 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4303901470702010 * Flag.HoistFlag) + 1.0 ,(0.8174450053155028 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4690820584548950 * Flag.HoistFlag) + 1.0 ,(0.8403861329869828 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4441827741323180 * Flag.HoistFlag) + 1.0 ,(0.8778405282447730 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4862474345636740 * Flag.HoistFlag) + 1.0 ,(0.8618867956069998 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.9047329999999425 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint(   (1.7084602451483050 * Flag.HoistFlag) + 1.0 ,(0.6577435784039636 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7222220000000200 * Flag.HoistFlag) + 1.0 ,(0.7005955000000356 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7359837548517280 * Flag.HoistFlag) + 1.0 ,(0.6577435784039636 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7780596608289910 * Flag.HoistFlag) + 1.0 ,(0.6736959690162418 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7531411252832680 * Flag.HoistFlag) + 1.0 ,(0.6362240885797579 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7918596383752900 * Flag.HoistFlag) + 1.0 ,(0.6132726634689039 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7470349300761760 * Flag.HoistFlag) + 1.0 ,(0.6093793485640650 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7532112390606210 * Flag.HoistFlag) + 1.0 ,(0.5648239204041348 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.7222220000000050 * Flag.HoistFlag) + 1.0 ,(0.5974170000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6912324583227580 * Flag.HoistFlag) + 1.0 ,(0.5648166961445836 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6974034208399200 * Flag.HoistFlag) + 1.0 ,(0.6093749989539603 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6525892013324570 * Flag.HoistFlag) + 1.0 ,(0.6132738256806689 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6913028747167350 * Flag.HoistFlag) + 1.0 ,(0.6362240885797621 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.6664016460959740 * Flag.HoistFlag) + 1.0 ,(0.6736695862617822 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.7084602451483050 * Flag.HoistFlag) + 1.0 ,(0.6577435784039636 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint(   (1.2500000000000050 * Flag.HoistFlag) + 1.0 ,(0.6339285000000079 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2637617548517170 * Flag.HoistFlag) + 1.0 ,(0.5910765784039590 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3058450500454730 * Flag.HoistFlag) + 1.0 ,(0.6070349413120671 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2809191252832520 * Flag.HoistFlag) + 1.0 ,(0.5695570885797541 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.3196327986675530 * Flag.HoistFlag) + 1.0 ,(0.5466068256806703 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2748185791600950 * Flag.HoistFlag) + 1.0 ,(0.5427079989539682 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2809895416772590 * Flag.HoistFlag) + 1.0 ,(0.4981496961445869 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2500000000000070 * Flag.HoistFlag) + 1.0 ,(0.5307500000000224 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2190104583227540 * Flag.HoistFlag) + 1.0 ,(0.4981496961445857 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2251814208399190 * Flag.HoistFlag) + 1.0 ,(0.5427079989539629 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1803672013324570 * Flag.HoistFlag) + 1.0 ,(0.5466068256806695 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2190808747167310 * Flag.HoistFlag) + 1.0 ,(0.5695570885797601 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.1941623391710220 * Flag.HoistFlag) + 1.0 ,(0.6070289690162459 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.2362382451482990 * Flag.HoistFlag) + 1.0 ,(0.5910765784039557 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.2500000000000050 * Flag.HoistFlag) + 1.0 ,(0.6339285000000079 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint(   (1.5000000000000020 * Flag.HoistFlag) + 1.0 ,(0.2380954999999972 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5137641387777510 * Flag.HoistFlag) + 1.0 ,(0.1952485286773872 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5558450500454610 * Flag.HoistFlag) + 1.0 ,(0.2112019413120608 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5309244813521960 * Flag.HoistFlag) + 1.0 ,(0.1737253110675369 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5696327986675470 * Flag.HoistFlag) + 1.0 ,(0.1507738256806687 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5248172283789760 * Flag.HoistFlag) + 1.0 ,(0.1468759207819470 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5309916646595550 * Flag.HoistFlag) + 1.0 ,(0.1023121452190400 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.1349115000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4690083353404460 * Flag.HoistFlag) + 1.0 ,(0.1023121452190399 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4751827716210240 * Flag.HoistFlag) + 1.0 ,(0.1468759207819469 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4303960378712310 * Flag.HoistFlag) + 1.0 ,(0.1507719477859740 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4690755186477950 * Flag.HoistFlag) + 1.0 ,(0.1737253110675386 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4441796460959750 * Flag.HoistFlag) + 1.0 ,(0.2111695862617671 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.4862358612222460 * Flag.HoistFlag) + 1.0 ,(0.1952485286773952 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.5000000000000020 * Flag.HoistFlag) + 1.0 ,(0.2380954999999972 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.5631179150295813 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000062 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2090209776069151 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.5631179150295813 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.9381845276285187 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2090209776069216 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.8740921454623232 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862359 * Flag.HoistFlag) + 1.0 ,(0.8596979219341390 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862357 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8740921454623232 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.6679006416707158 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7909790223931014 * Flag.HoistFlag) + 1.0 ,(0.6679006416707120 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5631179150295907 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8740921454623143 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862357 * Flag.HoistFlag) + 1.0 ,(0.6416045207239656 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862357 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137839 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137839 * Flag.HoistFlag) + 1.0 ,(0.6416045207239656 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1259078545377048 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(-0.0013024426581092 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (2.0000000000000000 * Flag.HoistFlag) + 1.0 ,(-0.0013024426581092 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.9999999999999960 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.9381845276285143 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7909790223930991 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.6679006416707158 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Blue")
  line:AppendPoint(   (0.1259078545377066 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137837 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137836 * Flag.HoistFlag) + 1.0 ,(0.8596979219341390 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.1259078545377066 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Red")
  line:AppendPoint(   (0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000066 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4545752784675030 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325164 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325164 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325168 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325168 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Red")
  line:AppendPoint(   (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.9999999999999951 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3349288321446238 * Flag.HoistFlag) + 1.0 ,(0.8334018009873840 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2789697856834130 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.9732500359782851 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.9999999999999951 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Red")
  line:AppendPoint(   (0.9230563111158566 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6650711678553914 * Flag.HoistFlag) + 1.0 ,(0.8334018009873795 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5881274789712632 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.9230563111158566 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Red")
  line:AppendPoint(   (0.6650711678554054 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7420148567395556 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5385720591847510 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6650711678554054 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Red")
  line:AppendPoint(   (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0559590464612040 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3908878786058440 * Flag.HoistFlag) + 1.0 ,(0.6679006416707299 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3349288321446146 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("White")
  line:AppendPoint(   (0.4545752784675019 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137839 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137839 * Flag.HoistFlag) + 1.0 ,(0.6416045207239656 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1259078545377048 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0559590464612109 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3908878786058520 * Flag.HoistFlag) + 1.0 ,(0.6679006416707299 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3349288321446146 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000034 * Flag.HoistFlag) + 1.0 ,(0.5631179150295813 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2090209776069151 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000034 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000034 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.4545752784675019 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("White")
  line:AppendPoint(   (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2090209776069216 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000114 * Flag.HoistFlag) + 1.0 ,(0.9381845276285187 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000004 * Flag.HoistFlag) + 1.0 ,(0.9732500359782900 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.2789697856834130 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.3349288321446238 * Flag.HoistFlag) + 1.0 ,(0.8334018009873840 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000001 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.1259078545377066 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137836 * Flag.HoistFlag) + 1.0 ,(0.8596979219341390 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4083810856137837 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.4545752784675027 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("White")
  line:AppendPoint(   (0.5454247215325168 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325159 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.7948297418026422 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7909790223930991 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.9381845276285140 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6650711678554068 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5881274789712657 * Flag.HoistFlag) + 1.0 ,(0.8334018009873886 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9230563111158566 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8740921454623232 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862345 * Flag.HoistFlag) + 1.0 ,(0.8596979219341390 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862357 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.5454247215325168 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("White")
  line:AppendPoint(   (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325168 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5454247215325164 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862357 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5916189143862357 * Flag.HoistFlag) + 1.0 ,(0.6416045207239656 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8740921454623143 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5000000000000029 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6650711678554054 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7420148567395556 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5385720591847510 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.5631179150295907 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7909790223931034 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.6679006416707159 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.0000000000000100 * Flag.HoistFlag) + 1.0 ,(0.7064727008554623 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Border")
  line:AppendPoint(   (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(-0.0013024426581092 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.9999999999999960 * Flag.HoistFlag) + 1.0 ,(-0.0013024426581092 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.9999999999999960 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0000000000000099 * Flag.HoistFlag) + 1.0 ,(-0.0013024426581092 * Flag.HoistFlag) + 1.0)
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
    Flag.Inquiry = InquiryNumberBox("Australia Flag Maker", "Enter the Flag Height", Flag.HoistFlag)
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