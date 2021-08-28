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
DialogWindow.NewMexico = [[data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAlgAAAGQBAMAAACAGwOrAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAbUExURf/YAMADLMojJNlZF+eGC/nCAPa7Ae2bBb8DLMNwnR8AAAAJcEhZcwAADsQAAA7EAZUrDhsAAAS9SURBVHja7d1BT9tWAAdwA0ty7TOr6mOcMfXatKLasaBNvdKxD1ANaedQ9Qs49MDHnmPaNQH72Umo1tq/36EI6EPir7+d5xf7kSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOxukp+sPpynC1m0mocwTZLDEI5l0WYcQvg5Sc7KD++l0eKoTClNkrz88EIawhKWsH6EsJbC0izN0izN0izNEpZmaZZmff+uZqf3m3U5ey2XOpOsSC82mzXKQ7GQTI3DELIXm81affJEMjWui1UyG806KP99Jpkaq5Xkp5vNene3xkwkrFRYmqVZmqVZmqVZwtIszdIszdIszRKWZmmWZmmWZmmWsDRLszRLszRLs4SlWZqlWZqlWZolLM3SLM3SLM3SLGFplmZplmZplmYJq3tY4eUsCKtrWEUQVoew/srDF9nyD2HFwjrOivA1rdu5sCJhrUVVpSWsSFiV9FXpv8NRWJGw0rd3n37MhdUW1snFl89H58KKh/V8/SsfhNUkv5/VXVqpZB5azUYfbHo7r/Z6GKiPvzfKy2nD4v7/n5R1WzaPedvnrD6EqF8fjvgzPqLHO2SMsyL2m6cXD4eM8nha73t9WoqY1o05jA7p8Qkt/ovXFau1WtOBhvW0ftC7aLOmAz0MF/WDJtFB/T0Mo4dU4x8WmG996PbDZePhFDn7xA7e0z5PtEb/1JuHbNE0pjwObxqGXSQDNIpeApYH7yBTafBTdC5+HbI3Mlo/LU13/W7vXL2Km0e7U/bupuUH9Gg305bLnBBuo2elUfVqGQYy37oOraJLfHn7+P4sP3T4ZaOLx2d7ht23sJ59y2b2LawnsfEHQwqrw2E03X21ovJpIEsz7a9mR3uG/WM5n0XlLSueZVhp/CecDGoC3xbWkKbwwnrMsN60XGcLa605Lc0a0tvSbSf4ovUwHM4JvjzMiqhwa+rQfVKa7Tsp7c+NSS53XEj/b2F9skTzSM0Y1OJfh1ezlmXlMJxl5dY3LH6LTuHLCfzxcN6w6DIRm+763cFpe5M1fuk4MN6+rzNuvDGk6fas6saQ4yHeGNJ4y1ERueA5jLzH2uNbjqI3s900jYrdzLbsb7fcJrndDOGRb8Ad7N3Kbu3e5rJnusNaVn8Pw3HYvlqDfRxlhwed/o6PeN7niVbsEbq6F8TVS2E60Efo2k5odQ9n9vi0tIeyWpnHfjtaLR7fbj5Qvno+0QPlTWHZqmCrsLKvm2AUwmoJK4RiaXuVzmFV+/VUe/YIKxrW8efVrc8rWLaEioW1vtlYSG02Fg9r7WI7s41dp7Be/mLPv65h3W29qVlbhKVZncJaapZmfcNmCUuzNEuzNEuzNEtYmqVZmqVZmqVZwtIszdIszdIszRKWZmmWZmmWZmmWsDRLszRLszRLs4SlWZqlWZqlWZolLM3SLM36nl1XG+FuNOug33/Qdw8HVT4bzToK9kasN6n2Dtto1jiPbG83bFez02SzWcnl7LVcmm00i/awUmFplmZplmZplmYJS7M0S7M0S1jCElY347uV5LN+75v8WObV4uhhzXa4PDDJq7/seJ4uZAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsId/AanLPN+Nj1PmAAAAAElFTkSuQmCC]]
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
    <td id="QuestionID2"class="myimg" ><img src="]].. DialogWindow.NewMexico ..[[" width="260" height="150">
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
function DrawFlag(job)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("")
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Border")
  line:AppendPoint(   (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (1.5000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(1.0000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.0000000000000000 * Flag.HoistFlag) + 1.0 ,(0.0000000000000000 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("The_4_winds")
  line:AppendPoint(   (0.6928817378168082 * Flag.HoistFlag) + 1.0 ,(0.4338514264709245 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6928884067163668 * Flag.HoistFlag) + 1.0 ,(0.3017559690385598 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7020853200437900 * Flag.HoistFlag) + 1.0 ,(0.2925590557112709 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7112822333712130 * Flag.HoistFlag) + 1.0 ,(0.3017559690386941 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.7112388943632628 * Flag.HoistFlag) + 1.0 ,(0.4216542135002289 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7176927015979070 * Flag.HoistFlag) + 1.0 ,(0.4186870431196052 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7244312476378865 * Flag.HoistFlag) + 1.0 ,(0.4163139454954570 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7244326978546343 * Flag.HoistFlag) + 1.0 ,(0.2605731444969328 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7336296111820575 * Flag.HoistFlag) + 1.0 ,(0.2513762311696439 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7428265245094805 * Flag.HoistFlag) + 1.0 ,(0.2605731444970670 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.7428254632591655 * Flag.HoistFlag) + 1.0 ,(0.4127933600304772 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7499999999999982 * Flag.HoistFlag) + 1.0 ,(0.4125000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7571731314564794 * Flag.HoistFlag) + 1.0 ,(0.4127945174595206 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7571734754905197 * Flag.HoistFlag) + 1.0 ,(0.2605731444970670 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7663703888179430 * Flag.HoistFlag) + 1.0 ,(0.2513762311696439 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7755673021453657 * Flag.HoistFlag) + 1.0 ,(0.2605731444969328 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.7755663624108606 * Flag.HoistFlag) + 1.0 ,(0.4163144154542209 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7823200811251250 * Flag.HoistFlag) + 1.0 ,(0.4186889221112280 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7887620886410276 * Flag.HoistFlag) + 1.0 ,(0.4216505236394339 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7887177666287872 * Flag.HoistFlag) + 1.0 ,(0.3017559690386941 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7979146799562105 * Flag.HoistFlag) + 1.0 ,(0.2925590557112709 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.8071115932836332 * Flag.HoistFlag) + 1.0 ,(0.3017559690385598 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.8071252032545897 * Flag.HoistFlag) + 1.0 ,(0.4338551285019608 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8118574362054148 * Flag.HoistFlag) + 1.0 ,(0.4381473718917420 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8161434857320731 * Flag.HoistFlag) + 1.0 ,(0.4428759582855318 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9482440309614404 * Flag.HoistFlag) + 1.0 ,(0.4428884067163666 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.9574409442887291 * Flag.HoistFlag) + 1.0 ,(0.4520853200437897 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.9482440309613060 * Flag.HoistFlag) + 1.0 ,(0.4612822333712128 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.8283461972760053 * Flag.HoistFlag) + 1.0 ,(0.4612362733457729 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8313144065460428 * Flag.HoistFlag) + 1.0 ,(0.4676878617818245 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8336876676001355 * Flag.HoistFlag) + 1.0 ,(0.4744308757345805 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9894268555030674 * Flag.HoistFlag) + 1.0 ,(0.4744326978546342 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.9986237688303561 * Flag.HoistFlag) + 1.0 ,(0.4836296111820572 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.9894268555029331 * Flag.HoistFlag) + 1.0 ,(0.4928265245094803 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.8372068956440410 * Flag.HoistFlag) + 1.0 ,(0.4928250439963622 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8374999999999984 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8372069614957178 * Flag.HoistFlag) + 1.0 ,(0.5071735544649805 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9894268555029331 * Flag.HoistFlag) + 1.0 ,(0.5071734754905195 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.9986237688303561 * Flag.HoistFlag) + 1.0 ,(0.5163703888179427 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.9894268555030674 * Flag.HoistFlag) + 1.0 ,(0.5255673021453657 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.8336873290188258 * Flag.HoistFlag) + 1.0 ,(0.5255692632159497 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8313150395416522 * Flag.HoistFlag) + 1.0 ,(0.5323089796383622 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8283474800625146 * Flag.HoistFlag) + 1.0 ,(0.5387605229499490 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.9482440309613060 * Flag.HoistFlag) + 1.0 ,(0.5387177666287870 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.9574409442887291 * Flag.HoistFlag) + 1.0 ,(0.5479146799562102 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.9482440309614402 * Flag.HoistFlag) + 1.0 ,(0.5571115932836332 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.8161476248741508 * Flag.HoistFlag) + 1.0 ,(0.5571192430021183 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8118614043559358 * Flag.HoistFlag) + 1.0 ,(0.5618488842530931 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8071249246169452 * Flag.HoistFlag) + 1.0 ,(0.5661451889077915 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.8071115932836332 * Flag.HoistFlag) + 1.0 ,(0.6982440309614402 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7979146799562100 * Flag.HoistFlag) + 1.0 ,(0.7074409442887291 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7887177666287870 * Flag.HoistFlag) + 1.0 ,(0.6982440309613058 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.7887612597371341 * Flag.HoistFlag) + 1.0 ,(0.5783495695911207 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7823198703070413 * Flag.HoistFlag) + 1.0 ,(0.5813103497084399 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7755664156208919 * Flag.HoistFlag) + 1.0 ,(0.5836850862638432 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7755673021453657 * Flag.HoistFlag) + 1.0 ,(0.7394268555030672 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7663703888179425 * Flag.HoistFlag) + 1.0 ,(0.7486237688303561 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7571734754905195 * Flag.HoistFlag) + 1.0 ,(0.7394268555029329 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.7571732702101164 * Flag.HoistFlag) + 1.0 ,(0.5872054711269783 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7499999999999982 * Flag.HoistFlag) + 1.0 ,(0.5874999999999999 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7428253747383435 * Flag.HoistFlag) + 1.0 ,(0.5872056712757510 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7428265245094803 * Flag.HoistFlag) + 1.0 ,(0.7394268555029329 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7336296111820573 * Flag.HoistFlag) + 1.0 ,(0.7486237688303561 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7244326978546343 * Flag.HoistFlag) + 1.0 ,(0.7394268555030672 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.7244326139129755 * Flag.HoistFlag) + 1.0 ,(0.5836818741732710 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7177047609647957 * Flag.HoistFlag) + 1.0 ,(0.5813100076104250 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7112383579046764 * Flag.HoistFlag) + 1.0 ,(0.5783423460782800 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.7112822333712128 * Flag.HoistFlag) + 1.0 ,(0.6982440309613058 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.7020853200437898 * Flag.HoistFlag) + 1.0 ,(0.7074409442887291 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.6928884067163668 * Flag.HoistFlag) + 1.0 ,(0.6982440309614402 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.6928758500878276 * Flag.HoistFlag) + 1.0 ,(0.5661442205484000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6881553840917930 * Flag.HoistFlag) + 1.0 ,(0.5618662832837921 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6838545861198895 * Flag.HoistFlag) + 1.0 ,(0.5571226234347941 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5517559690385598 * Flag.HoistFlag) + 1.0 ,(0.5571115932836332 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5425590557112709 * Flag.HoistFlag) + 1.0 ,(0.5479146799562102 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.5517559690386942 * Flag.HoistFlag) + 1.0 ,(0.5387177666287872 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.6716548061143099 * Flag.HoistFlag) + 1.0 ,(0.5387559062139076 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6686833710034037 * Flag.HoistFlag) + 1.0 ,(0.5322773401481800 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6663187199002736 * Flag.HoistFlag) + 1.0 ,(0.5255674278682347 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5105731444969328 * Flag.HoistFlag) + 1.0 ,(0.5255673021453657 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5013762311696439 * Flag.HoistFlag) + 1.0 ,(0.5163703888179427 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.5105731444970671 * Flag.HoistFlag) + 1.0 ,(0.5071734754905197 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.6627945870999077 * Flag.HoistFlag) + 1.0 ,(0.5071742916721411 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6624999999999983 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6627946500697868 * Flag.HoistFlag) + 1.0 ,(0.4928252563693698 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5105731444970671 * Flag.HoistFlag) + 1.0 ,(0.4928265245094804 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5013762311696439 * Flag.HoistFlag) + 1.0 ,(0.4836296111820573 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.5105731444969328 * Flag.HoistFlag) + 1.0 ,(0.4744326978546343 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.6663178747621188 * Flag.HoistFlag) + 1.0 ,(0.4744309148720230 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6686960610701495 * Flag.HoistFlag) + 1.0 ,(0.4676743235545787 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6716526439899628 * Flag.HoistFlag) + 1.0 ,(0.4612378277446372 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.5517559690386942 * Flag.HoistFlag) + 1.0 ,(0.4612822333712129 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.5425590557112709 * Flag.HoistFlag) + 1.0 ,(0.4520853200437898 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.5517559690385598 * Flag.HoistFlag) + 1.0 ,(0.4428884067163668 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:LineTo(        (0.6838479004455018 * Flag.HoistFlag) + 1.0 ,(0.4428827223410972 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6881462048061274 * Flag.HoistFlag) + 1.0 ,(0.4381426163348556 * Flag.HoistFlag) + 1.0)
  line:LineTo(        (0.6928817378168082 * Flag.HoistFlag) + 1.0 ,(0.4338514264709245 * Flag.HoistFlag) + 1.0)
  layer:AddObject(CreateCadContour(line), true)
  line  = Contour(0.0)
  layer = job.LayerManager:GetLayerWithName("Center")
  line:AppendPoint(   (0.7500000000000000 * Flag.HoistFlag) + 1.0 ,(0.5750000000000000 * Flag.HoistFlag) + 1.0)
  line:ArcTo( Point2D((0.6750000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7500000000000000 * Flag.HoistFlag) + 1.0 ,(0.4250000000000000 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.8250000000000000 * Flag.HoistFlag) + 1.0 ,(0.5000000000000000 * Flag.HoistFlag) + 1.0),0.4142135623730951)
  line:ArcTo( Point2D((0.7500000000000000 * Flag.HoistFlag) + 1.0 ,(0.5750000000000000 * Flag.HoistFlag) + 1.0),0.4142135623730951)
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
    Flag.Inquiry = InquiryNumberBox("US Navy Logo Flag Data", "Enter the Flag Height", Flag.HoistFlag)
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