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
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint((0.8669834687114362 * Flag.HoistFlag) + 1.0 ,(0.4937773038237486 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8669834687114362 * Flag.HoistFlag) + 1.0 ,(0.4937773038237486  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.783185930212797 * Flag.HoistFlag) + 1.0 ,(0.5023159205214395  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.855915912992159 * Flag.HoistFlag) + 1.0 ,(0.544604042674564  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8365690896130845 * Flag.HoistFlag) + 1.0 ,(0.6334525621148892  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9034610580141941 * Flag.HoistFlag) + 1.0 ,(0.5722486924276007  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9769441175926934 * Flag.HoistFlag) + 1.0 ,(0.6149746835648167  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9419668178289857 * Flag.HoistFlag) + 1.0 ,(0.5370172354642933  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.00454496389721 * Flag.HoistFlag) + 1.0 ,(0.4797603660855163  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9201362583896906 * Flag.HoistFlag) + 1.0 ,(0.4883612581306771  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8851449165880775 * Flag.HoistFlag) + 1.0 ,(0.4103725131190477 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8669834687114362 * Flag.HoistFlag) + 1.0 ,(0.4937773038237486 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint((0.6431877679603938 * Flag.HoistFlag) + 1.0 ,(0.57802016164783 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6431877679603938 * Flag.HoistFlag) + 1.0 ,(0.57802016164783  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.5694444444444443 * Flag.HoistFlag) + 1.0 ,(0.6202953624220087  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6544462247955574 * Flag.HoistFlag) + 1.0 ,(0.6289828563211153  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6727430551846345 * Flag.HoistFlag) + 1.0 ,(0.7118055552273201  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7074988169320726 * Flag.HoistFlag) + 1.0 ,(0.6344050259346711  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.792534722222222 * Flag.HoistFlag) + 1.0 ,(0.6430960075277821  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7293847786129481 * Flag.HoistFlag) + 1.0 ,(0.5856653369447509  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7638888888888886 * Flag.HoistFlag) + 1.0 ,(0.5088252314814815  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6909013094362623 * Flag.HoistFlag) + 1.0 ,(0.5506671831086513  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6236296462018421 * Flag.HoistFlag) + 1.0 ,(0.48948808285968 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6431877679603938 * Flag.HoistFlag) + 1.0 ,(0.57802016164783 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint((0.7185619573754567 * Flag.HoistFlag) + 1.0 ,(0.3339999082145894 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7185619573754567 * Flag.HoistFlag) + 1.0 ,(0.3339999082145894  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6376869809181553 * Flag.HoistFlag) + 1.0 ,(0.3084340786871631  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6873399246782302 * Flag.HoistFlag) + 1.0 ,(0.3772337159346518  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6372953611897003 * Flag.HoistFlag) + 1.0 ,(0.4465314793531695  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7186067526756187 * Flag.HoistFlag) + 1.0 ,(0.420557359231499  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7679001808983144 * Flag.HoistFlag) + 1.0 ,(0.4888588479970783  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7681577775715773 * Flag.HoistFlag) + 1.0 ,(0.404728774216785  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8547762641850731 * Flag.HoistFlag) + 1.0 ,(0.3770593550254303  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7683261740254143 * Flag.HoistFlag) + 1.0 ,(0.3497311459245679  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7685864379628624 * Flag.HoistFlag) + 1.0 ,(0.2647299540131738 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7185619573754567 * Flag.HoistFlag) + 1.0 ,(0.3339999082145894 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint((0.7716544935537968 * Flag.HoistFlag) + 1.0 ,(0.7703560111601206 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((0.501298482393676 * Flag.HoistFlag) + 1.0 ,(0.5 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((0.7716544935537968 * Flag.HoistFlag) + 1.0 ,(0.2296439888398794 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.042010504713917 * Flag.HoistFlag) + 1.0 ,(0.5 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((0.7716544935537968 * Flag.HoistFlag) + 1.0 ,(0.7703560111601206 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Stars")
  line:AppendPoint((0.7716544935647338 * Flag.HoistFlag) + 1.0 ,(0.7495554792996512 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((0.5220990142650825 * Flag.HoistFlag) + 1.0 ,(0.5 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((0.7716544935647338 * Flag.HoistFlag) + 1.0 ,(0.2504445207003488 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.021209972864385 * Flag.HoistFlag) + 1.0 ,(0.5 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((0.7716544935647338 * Flag.HoistFlag) + 1.0 ,(0.7495554792996512 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("RedBackGround")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((0.0 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((1.541223914730236 * Flag.HoistFlag) + 1.0 ,(0.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.541223914730236 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("WhiteBar")
  line:AppendPoint((1.541223914730236 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.541223914730236 * Flag.HoistFlag) + 1.0 ,(0.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.562098950649554 * Flag.HoistFlag) + 1.0 ,(0.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.562098950649554 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.541223914730236 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.541223914730236 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("BlueBar")
  line:AppendPoint((1.562098950649554 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.562098950649554 * Flag.HoistFlag) + 1.0 ,(0.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.666666666666667 * Flag.HoistFlag) + 1.0 ,(0.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.666666666666667 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.562098950649554 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((1.562098950649554 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("WhiteRing")
  line:AppendPoint((0.8669834687114362 * Flag.HoistFlag) + 1.0 ,(0.4937773038237486 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8669834687114362 * Flag.HoistFlag) + 1.0 ,(0.4937773038237486  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.783185930212797 * Flag.HoistFlag) + 1.0 ,(0.5023159205214395  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.855915912992159 * Flag.HoistFlag) + 1.0 ,(0.544604042674564  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8365690896130845 * Flag.HoistFlag) + 1.0 ,(0.6334525621148892  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9034610580141941 * Flag.HoistFlag) + 1.0 ,(0.5722486924276007  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9769441175926934 * Flag.HoistFlag) + 1.0 ,(0.6149746835648167  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9419668178289857 * Flag.HoistFlag) + 1.0 ,(0.5370172354642933  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.00454496389721 * Flag.HoistFlag) + 1.0 ,(0.4797603660855163  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.9201362583896906 * Flag.HoistFlag) + 1.0 ,(0.4883612581306771  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8851449165880775 * Flag.HoistFlag) + 1.0 ,(0.4103725131190477 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.8669834687114362 * Flag.HoistFlag) + 1.0 ,(0.4937773038237486 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("WhiteRing")
  line:AppendPoint((0.6431877679603938 * Flag.HoistFlag) + 1.0 ,(0.57802016164783 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6431877679603938 * Flag.HoistFlag) + 1.0 ,(0.57802016164783  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.5694444444444443 * Flag.HoistFlag) + 1.0 ,(0.6202953624220087  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6544462247955574 * Flag.HoistFlag) + 1.0 ,(0.6289828563211153  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6727430551846345 * Flag.HoistFlag) + 1.0 ,(0.7118055552273201  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7074988169320726 * Flag.HoistFlag) + 1.0 ,(0.6344050259346711  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.792534722222222 * Flag.HoistFlag) + 1.0 ,(0.6430960075277821  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7293847786129481 * Flag.HoistFlag) + 1.0 ,(0.5856653369447509  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7638888888888886 * Flag.HoistFlag) + 1.0 ,(0.5088252314814815  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6909013094362623 * Flag.HoistFlag) + 1.0 ,(0.5506671831086513  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6236296462018421 * Flag.HoistFlag) + 1.0 ,(0.48948808285968 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.6431877679603938 * Flag.HoistFlag) + 1.0 ,(0.57802016164783 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("WhiteRing")
  line:AppendPoint((0.7185619573754567 * Flag.HoistFlag) + 1.0 ,(0.3339999082145894 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7185619573754567 * Flag.HoistFlag) + 1.0 ,(0.3339999082145894  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6376869809181553 * Flag.HoistFlag) + 1.0 ,(0.3084340786871631  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6873399246782302 * Flag.HoistFlag) + 1.0 ,(0.3772337159346518  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.6372953611897003 * Flag.HoistFlag) + 1.0 ,(0.4465314793531695  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7186067526756187 * Flag.HoistFlag) + 1.0 ,(0.420557359231499  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7679001808983144 * Flag.HoistFlag) + 1.0 ,(0.4888588479970783  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7681577775715773 * Flag.HoistFlag) + 1.0 ,(0.404728774216785  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.8547762641850731 * Flag.HoistFlag) + 1.0 ,(0.3770593550254303  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7683261740254143 * Flag.HoistFlag) + 1.0 ,(0.3497311459245679  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.7685864379628624 * Flag.HoistFlag) + 1.0 ,(0.2647299540131738 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.7185619573754567 * Flag.HoistFlag) + 1.0 ,(0.3339999082145894 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("WhiteRing")
  line:AppendPoint((0.7716544935647338 * Flag.HoistFlag) + 1.0 ,(0.7495554792996512 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((0.5220990142650825 * Flag.HoistFlag) + 1.0 ,(0.5 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((0.7716544935647338 * Flag.HoistFlag) + 1.0 ,(0.2504445207003488 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((1.021209972864385 * Flag.HoistFlag) + 1.0 ,(0.5 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo(Point2D((0.7716544935647338 * Flag.HoistFlag) + 1.0 ,(0.7495554792996512 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  layer:AddObject(CreateCadContour(line), true)
  line = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("FlagBorder")
  line:AppendPoint((0.0 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
  line:ArcTo(Point2D((0.0 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo((1.666666666666667 * Flag.HoistFlag) + 1.0 ,(0.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((1.666666666666667 * Flag.HoistFlag) + 1.0 ,(1.0  * Flag.HoistFlag) + 1.0 )
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(1.0 * Flag.HoistFlag) + 1.0)
  line:LineTo((0.0 * Flag.HoistFlag) + 1.0 ,(0.0 * Flag.HoistFlag) + 1.0)
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
    Flag.Inquiry = InquiryNumberBox("Tennessee Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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