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

DialogWindow.Australia = [[data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iMTI4MCIgaGVpZ2h0PSI2NDAiIHZpZXdCb3g9IjAgMCAxMDA4MCA1MDQwIj4KPGRlZnM+CjxjbGlwUGF0aCBpZD0iYzEiPjxwYXRoIGQ9Ik0wLDBINlYzSDB6Ii8+PC9jbGlwUGF0aD4KPGNsaXBQYXRoIGlkPSJjMiI+PHBhdGggZD0iTTAsMFYxLjVINlYzSDZ6TTYsMEgzVjNIMFYzeiIvPjwvY2xpcFBhdGg+CjxwYXRoIGlkPSJTdGFyNyIgZD0iTTAsLTM2MCA2OS40MjEzOTgsLTE0NC4xNTUwMTkgMjgxLjQ1OTMzNCwtMjI0LjQ1NjMyOSAxNTUuOTg4NDY2LC0zNS42MDMzNDkgMzUwLjk3NDA0OCw4MC4xMDc1MzYgMTI1LjA5MzAzNyw5OS43NTgzNjggMTU2LjE5ODE0NiwzMjQuMzQ4NzkyIDAsMTYwIC0xNTYuMTk4MTQ2LDMyNC4zNDg3OTIgLTEyNS4wOTMwMzcsOTkuNzU4MzY4IC0zNTAuOTc0MDQ4LDgwLjEwNzUzNiAtMTU1Ljk4ODQ2NiwtMzUuNjAzMzQ5IC0yODEuNDU5MzM0LC0yMjQuNDU2MzI5IC02OS40MjEzOTgsLTE0NC4xNTUwMTl6Ii8+CjxwYXRoIGlkPSJTdGFyNSIgZD0iTTAsLTIxMCA1NC44NTk5NTcsLTc1LjUwODI1MyAxOTkuNzIxODY4LC02NC44OTM1NjkgODguNzY1Mjc1LDI4Ljg0MTU4NiAxMjMuNDM0OTAzLDE2OS44OTM1NjkgMCw5My4zMzMzMzMgLTEyMy40MzQ5MDMsMTY5Ljg5MzU2OSAtODguNzY1Mjc1LDI4Ljg0MTU4NiAtMTk5LjcyMTg2OCwtNjQuODkzNTY5IC01NC44NTk5NTcsLTc1LjUwODI1M3oiLz4KPHVzZSBpZD0iQ3N0YXIiIHhsaW5rOmhyZWY9IiNTdGFyNyIgdHJhbnNmb3JtPSJzY2FsZSgyLjEpIi8+CjwvZGVmcz4KPGcgdHJhbnNmb3JtPSJzY2FsZSg4NDApIj4KPHJlY3Qgd2lkdGg9IjEyIiBoZWlnaHQ9IjYiIGZpbGw9IiMwMDAwOGIiLz4KPHBhdGggZD0iTTAsMCA2LDNNNiwwIDAsMyIgc3Ryb2tlPSIjZmZmIiBzdHJva2Utd2lkdGg9IjAuNiIgY2xpcC1wYXRoPSJ1cmwoI2MxKSIvPgo8cGF0aCBkPSJNMCwwIDYsM002LDAgMCwzIiBzdHJva2U9IiNmMDAiIHN0cm9rZS13aWR0aD0iMC40IiBjbGlwLXBhdGg9InVybCgjYzIpIi8+CjxwYXRoIGQ9Ik0zLDBWM00wLDEuNUg2IiBzdHJva2U9IiNmZmYiLz4KPHBhdGggZD0iTTMsMFYzTTAsMS41SDYiIHN0cm9rZT0iI2YwMCIgc3Ryb2tlLXdpZHRoPSIwLjYiLz4KPC9nPgo8ZyBmaWxsPSIjZmZmIj4KPHVzZSBpZD0iQ29td2x0aCIgeGxpbms6aHJlZj0iI0NzdGFyIiB4PSIyNTIwIiB5PSIzNzgwIi8+Cjx1c2UgaWQ9Is6xQ3J1Y2lzIiB4bGluazpocmVmPSIjU3RhcjciIHg9Ijc1NjAiIHk9IjQyMDAiLz4KPHVzZSBpZD0izrJDcnVjaXMiIHhsaW5rOmhyZWY9IiNTdGFyNyIgeD0iNjMwMCIgeT0iMjIwNSIvPgo8dXNlIGlkPSLOs0NydWNpcyIgeGxpbms6aHJlZj0iI1N0YXI3IiB4PSI3NTYwIiB5PSI4NDAiLz4KPHVzZSBpZD0izrRDcnVjaXMiIHhsaW5rOmhyZWY9IiNTdGFyNyIgeD0iODY4MCIgeT0iMTg2OSIvPgo8dXNlIGlkPSLOtUNydWNpcyIgeGxpbms6aHJlZj0iI1N0YXI1IiB4PSI4MDY0IiB5PSIyNzMwIi8+CjwvZz4KPC9zdmc+Cg==]]
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
  local dialog = HTML_Dialog(true, myHtml, 300, 260, Header .. " " .. Flag.Version) ;
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