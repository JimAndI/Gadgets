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

-- Easy Flag Maker is written by JimAndI Gadgets of Houston Texas 2019
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
DialogWindow.myBackGround = [[data:image/png;base64,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]]
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
  local myHtml = [[<html><head><title>Easy Stair Maker</title><style type="text/css">html {overflow: hidden;}.FormButton {font-weight: bold;width: 75px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;}.h1-r {font-family: Arial, Helvetica, sans-serif;font-size: 12px;text-align:right;}body {overflow:hidden;}</style><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body bgcolor="#CCCCCC"><table border="0" width="259" cellpadding="0"> <tbody> <tr> <td height="132" colspan="2" align="left" valign="top" id="QuestionID2"><img src="]].. DialogWindow.myBackGround ..[[" width="260" height="120"> </tr> <tr> <td width="199" height="22" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here </td> <td class="h1-l" align="left" valign="middle" width="113"><input id="qInput" name="qInput" size="10" type="text" /> </td> </tr> <tr> <td colspan="2" align="center" valign="middle"><table border="0" width="100%"> <tbody> <tr align="right"> <td height="25" style="width: 10%;">&nbsp;</td> <td>&nbsp;</td> <td style="width: 10%;">&nbsp;</td> <td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td> <td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td> </tr> </tbody> </table></td> </tr> </tbody></table></body></html>]]
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