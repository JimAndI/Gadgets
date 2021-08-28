-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

Easy Lock Joints Maker is written by JimAndI Gadgets of Houston Texas 2019
]]
-- require("mobdebug").start() -- remove to publish
require "strict"
-- Global variables
-- Table Names
local Joint = {}
-- ======================================================
local function ReadRegistry() -- Read from Registry values
  local RegistryRead      = Registry(Joint.RegName)
    Joint.TailCount       = RegistryRead:GetInt("Joint.TailCount",          3)
    Joint.ClearanceEnd    = RegistryRead:GetDouble("Joint.ClearanceEnd",    0.01)
    Joint.FingerDiameter  = RegistryRead:GetDouble("Joint.FingerDiameter",  0.250)
    Joint.StockThickness  = RegistryRead:GetDouble("Joint.StockThickness",  0.750 )
    Joint.StockWidth      = RegistryRead:GetDouble("Joint.StockWidth",      5.250)
    Joint.MateralOrgPoint = RegistryRead:GetString("Joint.MateralOrgPoint", "Right")
    Joint.MateralAng      = RegistryRead:GetString("Joint.MateralAng",      "0.0")
    Joint.StockLayerSide  = RegistryRead:GetString("Joint.StockLayerSide",  "Stock Layer End")
    Joint.StockLayerEnd   = RegistryRead:GetString("Joint.StockLayerEnd",   "Stock Layer Side")
    Joint.JointLayerEnd   = RegistryRead:GetString("Joint.JointLayerEnd",   "Joint Layer End")
    Joint.JointLayerSide  = RegistryRead:GetString("Joint.JointLayerSide",  "Joint Layer Side")
    Joint.WriteSettings   = RegistryRead:GetBool("Joint.WriteSettings",      false)

end --function end
-- ======================================================
local function WriteRegistry() -- Write to Registry values
  local RegistryWrite = Registry(Joint.RegName)
  local RegValue = RegistryWrite:SetInt("Joint.TailCount", Joint.TailCount)
        RegValue = RegistryWrite:SetDouble("Joint.ClearanceEnd", Joint.ClearanceEnd)
        RegValue = RegistryWrite:SetDouble("Joint.FingerDiameter", Joint.FingerDiameter)
        RegValue = RegistryWrite:SetDouble("Joint.StockThickness", Joint.StockThickness)
        RegValue = RegistryWrite:SetDouble("Joint.StockWidth", Joint.StockWidth)
        RegValue = RegistryWrite:SetString("Joint.MateralOrgPoint", Joint.MateralOrgPoint)
        RegValue = RegistryWrite:SetString("Joint.MateralAng", Joint.MateralAng)
        RegValue = RegistryWrite:SetString("Joint.StockLayerEnd", Joint.StockLayerEnd)
        RegValue = RegistryWrite:SetString("Joint.StockLayerSide", Joint.StockLayerSide)
        RegValue = RegistryWrite:SetString("Joint.JointLayerEnd", Joint.JointLayerEnd)
        RegValue = RegistryWrite:SetString("Joint.JointLayerSide", Joint.JointLayerSide)
        RegValue = RegistryWrite:SetBool("Joint.WriteSettings", Joint.WriteSettings)
        RegValue = RegistryWrite:SetString("Joint.SetupX" , Joint.SetupX)
        RegValue = RegistryWrite:SetString("Joint.SetupY" , Joint.SetupY)
  end --function end
-- ======================================================
local function Polar2D(pt, ang, dis)
    return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end  -- end of function
-- ======================================================
local function InquiryJoint(Header)
    local myHtml = [[<html><head><title>Cabinet Maker and Tool-path Creator</title><style type = "text/css">body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}html{overflow:hidden}.Alert{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;color:#00F;text-align:center;white-space:nowrap}.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap}.H1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;white-space:nowrap}.H1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;white-space:nowrap}.H1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px}.H1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;white-space:nowrap}.H2-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}.Header1-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}.Header2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-align:center;white-space:nowrap}.Helpbutton:active{border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000}.Helpbutton:hover{border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}.Helpbuttonx{background-color:##E1E1E1;border:1pxsolid#999;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;display:inline-block;font-size:12px;margin:40px20px;cursor:pointer;color:#000;padding:2px12px}.Helpbutton{background-color:#E1E1E1;border:1pxsolid#999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px2px;color:#000}.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#FF0}.ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;width:50px}</style></head><body bgcolor = "#EBEBEB" text = "#000000"><table width="500" border="0" cellpadding="0"><tr><td rowspan="14" align="center" valign="middle" nowrap bgcolor="#EBEBEB"><img src= data:image/jpeg;base64,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 width="194" height="295"></td><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Stock Side</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.StockLayerSide" type="text" class="h2" id="Joint.StockLayerSide" size="30" maxlength="20" /> </span></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Stock End</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.StockLayerEnd" type="text" class="h2" id="Joint.StockLayerEnd" size="30" maxlength="20" /> </span></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21">Joint Side</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.JointLayerSide" type="text" class="h2" id="Joint.JointLayerSide" size="30" maxlength="20" /> </span></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Joint End</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.JointLayerEnd" type="text" class="h2" id="Joint.JointLayerEnd" size="30" maxlength="20" /> </span></td></tr><tr><td colspan="2" align="right" valign="middle" nowrap><hr></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Finger Diameter</span></td><td width="190" align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.FingerDiameter" type="text" class="h2" id="Joint.FingerDiameter" size="10" maxlength="10" /> </span></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Joint Clearance</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.ClearanceEnd" type="text" class="h2" id="Joint.ClearanceEnd" size="10" maxlength="10" /> </span></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Stock Width</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.StockWidth" type="text" class="h2" id="Joint.StockWidth" size="10" maxlength="10" /> </span></td></tr><tr><td height="22" align="right" valign="middle" nowrap class="H1-rP"><span class="h21" style="width: 25%">Stock Thickness</span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.StockThickness" type="text" class="h21" id="Joint.StockThickness" size="10" maxlength="10" /> </span></td></tr><tr><td height="7" colspan="2" align="right" valign="middle" nowrap><hr></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21">Org Placement</span></td><td align="left" valign="middle" nowrap><select name = "Joint.MateralOrgPoint" size = "1" class = "h22" id = "Joint.MateralOrgPoint"><option value="0" selected>Right</option><option value="180">Left</option> </select></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21">Placement Angle</span></td><td align="left" valign="middle" nowrap><select name = "Joint.MateralAng" size = "1" class = "h22" id = "Joint.MateralAng"><option value="0" selected>0.0</option><option value="90.0">90.0</option><option value="180.0">180.0</option><option value="270.0">270.0</option> </select></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP"><span class="h21">Tail Count </span></td><td align="left" valign="middle" nowrap><span style="width: 25%"> <input name="Joint.TailCount" type="text" class="h21" id="Joint.TailCount" value="3" size="10" maxlength="10" /> </span></td></tr><tr><td align="right" valign="middle" nowrap class="H1-rP">Write Setting</td><td align="left" valign="middle" nowrap><input name="Joint.WriteSettings" type="checkbox" align="center" id="Joint.WriteSettings" checked></td></tr></table><table width="100%" border="0"><tr><td colspan="3"><hr></td></tr><tr><td width="60%" class="H1-l"><span class="h21" style="width: 55%"><span class="h3" id="Version">Version</span></span></td><td width="20%" class="H1-c"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td><td width="20%" class="H1-c"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td></tr></table></body>]]
      local dialog = HTML_Dialog(true, myHtml, 555, 450,  Header ) ;
      dialog:AddIntegerField("Joint.TailCount", Joint.TailCount) ;
      dialog:AddLabelField("Version", Joint.Version) ;
      dialog:AddDoubleField("Joint.ClearanceEnd", Joint.ClearanceEnd) ;
      dialog:AddDoubleField("Joint.FingerDiameter", Joint.FingerDiameter) ;
      dialog:AddDoubleField("Joint.StockThickness", Joint.StockThickness) ;
      dialog:AddDoubleField("Joint.StockWidth", Joint.StockWidth) ;
      dialog:AddDropDownList("Joint.MateralOrgPoint", Joint.MateralOrgPoint) ;
      dialog:AddDropDownList("Joint.MateralAng", Joint.MateralAng) ;
      dialog:AddTextField("Joint.StockLayerSide", Joint.StockLayerSide) ;
      dialog:AddTextField("Joint.StockLayerEnd", Joint.StockLayerEnd) ;
      dialog:AddTextField("Joint.JointLayerEnd", Joint.JointLayerEnd) ;
      dialog:AddTextField("Joint.JointLayerSide", Joint.JointLayerSide) ;
      dialog:AddCheckBox("Joint.WriteSettings", Joint.WriteSettings) ;
    if  dialog:ShowDialog() then
      Joint.TailCount       = dialog:GetIntegerField("Joint.TailCount") ;
      Joint.ClearanceEnd    = dialog:GetDoubleField("Joint.ClearanceEnd") ;
      Joint.FingerDiameter  = dialog:GetDoubleField("Joint.FingerDiameter") ;
      Joint.StockThickness  = dialog:GetDoubleField("Joint.StockThickness") ;
      Joint.StockWidth      = dialog:GetDoubleField("Joint.StockWidth") ;
      Joint.MateralOrgPoint = dialog:GetDropDownListValue("Joint.MateralOrgPoint") ;
      Joint.MateralAng      = dialog:GetDropDownListValue("Joint.MateralAng") ;
      Joint.StockLayerSide  = dialog:GetTextField("Joint.StockLayerSide")
      Joint.StockLayerEnd   = dialog:GetTextField("Joint.StockLayerEnd")
      Joint.JointLayerEnd   = dialog:GetTextField("Joint.JointLayerEnd")
      Joint.JointLayerSide  = dialog:GetTextField("Joint.JointLayerSide")
      Joint.WriteSettings   = dialog:GetCheckBox("Joint.WriteSettings") ;
      Joint.SetupX          = tostring(dialog.WindowWidth)
      Joint.SetupY          = tostring(dialog.WindowHeight)
      if Joint.TailCount < 1 then
          Joint.TailCount = 1
      end
      WriteRegistry()
      return true
    else
      return false
    end
   end  -- end of function
-- ======================================================
local function JointMath()
  Joint.TailCenters = Joint.StockWidth / Joint.TailCount
  Joint.FingerRadius = Joint.FingerDiameter * 0.5
  Joint.HalfClearanceEnd = Joint.ClearanceEnd * 0.5
  return true
end  -- end of function
-- ======================================================
local function DrawTail(job, pt) --  Draw the joint path on the end jount Layer
    Joint.p11 = Polar2D(pt, Joint.OrgAng2b, Joint.FingerRadius + Joint.FingerDiameter + Joint.HalfClearanceEnd) ;
    Joint.p16 = Polar2D(pt, Joint.OrgAng1b, Joint.FingerRadius + Joint.FingerDiameter + Joint.HalfClearanceEnd) ;
    Joint.p12 = Polar2D(Joint.p11, Joint.OrgAng1a, Joint.FingerDiameter - Joint.HalfClearanceEnd) ;
    Joint.p18 = Polar2D(Joint.p11, Joint.OrgAng2a, Joint.FingerDiameter + Joint.HalfClearanceEnd) ;
    Joint.p13 = Polar2D(Joint.p12, Joint.OrgAng1a, Joint.FingerDiameter + Joint.ClearanceEnd) ;
    Joint.p15 = Polar2D(Joint.p16, Joint.OrgAng1a, Joint.FingerDiameter - Joint.HalfClearanceEnd) ;
    Joint.p14 = Polar2D(Joint.p15, Joint.OrgAng1a, Joint.FingerDiameter + Joint.ClearanceEnd) ;
    Joint.p17 = Polar2D(Joint.p16, Joint.OrgAng2a, Joint.FingerDiameter + Joint.HalfClearanceEnd) ;
    local line = Contour(0.0) ;
    local layer = job.LayerManager:GetLayerWithName(Joint.JointLayerEnd) ;

    if Joint.MateralOrgPoint == "Right" then
      line:AppendPoint(Joint.p11) ;    line:LineTo(Joint.p11) ;
      line:ArcTo(Joint.p12, 1) ;       line:ArcTo(Joint.p13, -1) ;
      line:LineTo(Joint.p14) ;         line:ArcTo(Joint.p15, -1) ;
      line:ArcTo(Joint.p16, 1) ;       line:ArcTo(Joint.p17, -1) ;
      line:LineTo(Joint.p18) ;         line:ArcTo(Joint.p11, -1) ;
    else
      line:AppendPoint(Joint.p11) ;    line:LineTo(Joint.p11) ;
      line:ArcTo(Joint.p12, -1) ;      line:ArcTo(Joint.p13, 1) ;
      line:LineTo(Joint.p14) ;         line:ArcTo(Joint.p15, 1) ;
      line:ArcTo(Joint.p16, -1) ;      line:ArcTo(Joint.p17, 1) ;
      line:LineTo(Joint.p18) ;         line:ArcTo(Joint.p11, 1) ;
    end
    -- ==================
    layer:AddObject(CreateCadContour(line), true)
    return true
end  -- end of function
-- ======================================================
local function DrawPins(pt, line) --  Draw the pin box on the joint side Layer  ;
    Joint.p11 = Polar2D(pt, Joint.OrgAng2b, Joint.FingerRadius + Joint.FingerDiameter) ;
    Joint.p16 = Polar2D(pt, Joint.OrgAng1b, Joint.FingerRadius + Joint.FingerDiameter) ;
    Joint.p12 = Polar2D(Joint.p11, Joint.OrgAng1a, Joint.FingerDiameter) ;
    Joint.p13 = Polar2D(Joint.p12, Joint.OrgAng1a, Joint.FingerDiameter) ;
    Joint.p15 = Polar2D(Joint.p16, Joint.OrgAng1a, Joint.FingerDiameter) ;
    Joint.p14 = Polar2D(Joint.p15, Joint.OrgAng1a, Joint.FingerDiameter) ;

    -- ==================
    if Joint.MateralOrgPoint == "Right" then
      line:LineTo(Joint.p11) ;           line:ArcTo(Joint.p12, 1) ;
      line:ArcTo(Joint.p13, -1) ;        line:LineTo(Joint.p14);
      line:ArcTo(Joint.p15, -1) ;        line:ArcTo(Joint.p16, 1) ;
    else
      line:LineTo(Joint.p11) ;           line:ArcTo(Joint.p12, -1) ;
      line:ArcTo(Joint.p13, 1) ;         line:LineTo(Joint.p14);
      line:ArcTo(Joint.p15, 1) ;         line:ArcTo(Joint.p16, -1) ;
    end
end  -- end of function
-- ======================================================
local function DrawStock(job) --  Draw the stock objects on the Stock Layer
  -- ======================================================
    local function AngleDeg(p1, p2) -- setup stock base on user dialog inputs
        local angx = math.atan2(p2.Y - p1.Y, p2.X - p1.X) * 180.0 / math.pi
        return angx
    end  -- end of function

    Joint.p01 = Point2D(0.0, 0.0) ;
    Joint.p01S= Polar2D(Joint.p01, Joint.OrgAng2a, Joint.StockThickness) ;
    Joint.p02 = Polar2D(Joint.p01, Joint.OrgAng1a, Joint.StockThickness) ;
    Joint.p03 = Polar2D(Joint.p02, Joint.OrgAng1b, Joint.StockWidth) ;
    Joint.p04 = Polar2D(Joint.p01, Joint.OrgAng1b, Joint.StockWidth) ;
    Joint.p04S= Polar2D(Joint.p01S,Joint.OrgAng1b, Joint.StockWidth) ;
    Joint.p05 = Polar2D(Joint.p01, Joint.OrgAng2a, Joint.StockThickness * 6.0) ;
    Joint.p06 = Polar2D(Joint.p04, Joint.OrgAng2a, Joint.StockThickness * 8.0) ;
    Joint.SlashAng1 = AngleDeg(Joint.p05, Joint.p06) ;
    Joint.SlashAng2 = AngleDeg(Joint.p06, Joint.p05) ;
    Joint.p07 = Polar2D(Joint.p05, Joint.SlashAng1,(Joint.StockWidth * 0.5)) ;
    Joint.p08 = Polar2D(Joint.p06, Joint.SlashAng2,(Joint.StockWidth * 0.5)) ;
    Joint.p09 = Polar2D(Joint.p07, Joint.OrgAng1a, (Joint.StockThickness * 0.5)) ;
    Joint.p10 = Polar2D(Joint.p08, Joint.OrgAng2a, (Joint.StockThickness * 0.5)) ;
    local line = Contour(0.0) ;
    local layer = job.LayerManager:GetLayerWithName(Joint.StockLayerEnd)  ;
    line:AppendPoint(Joint.p01) ;
    line:LineTo(Joint.p02) ; line:LineTo(Joint.p03) ;
    line:LineTo(Joint.p04) ; line:LineTo(Joint.p01) ;
    layer:AddObject(CreateCadContour(line), true)
    -- =======
    line = Contour(0.0) ;
    layer = job.LayerManager:GetLayerWithName(Joint.StockLayerSide)  ;
    line:AppendPoint(Joint.p01) ;
    line:LineTo(Joint.p05) ;    line:LineTo(Joint.p07);
    line:LineTo(Joint.p09) ;    line:LineTo(Joint.p10);
    line:LineTo(Joint.p08) ;    line:LineTo(Joint.p06);
    line:LineTo(Joint.p04) ;    line:LineTo(Joint.p01);
    layer:AddObject(CreateCadContour(line), true)
    return true
end  -- end of function
-- ======================================================
local function DrawSideTails(job) -- Setup joint data
  local pt  = Polar2D(Joint.p01S, Joint.OrgAng1b, (Joint.TailCenters * 0.5)) ;
  Joint.p21 = Polar2D(Joint.p01S, Joint.OrgAng2b, Joint.FingerRadius) ;
  Joint.p22 = Polar2D(Joint.p21, Joint.OrgAng1a, Joint.StockThickness + Joint.FingerRadius) ;
  Joint.p24 = Polar2D(Joint.p04S, Joint.OrgAng1b, Joint.FingerRadius) ;
  Joint.p23 = Polar2D(Joint.p24, Joint.OrgAng1a, Joint.StockThickness + Joint.FingerRadius) ;
-- ================
  Joint.p11 = Polar2D(pt, Joint.OrgAng2b, Joint.FingerRadius + Joint.FingerDiameter) ;
  Joint.p11x = Joint.p11 ;
  local line = Contour(0.0) ;
  local layer = job.LayerManager:GetLayerWithName(Joint.JointLayerSide)  ;
  line:AppendPoint(Joint.p11x) ;
  for _ = Joint.TailCount, 1, -1 do
    DrawPins(pt, line)
    pt = Polar2D(pt, Joint.OrgAng1b, Joint.TailCenters) ;
  end
  -- ================
  line:LineTo(Joint.p16) ;    line:LineTo(Joint.p24);
  line:LineTo(Joint.p23) ;    line:LineTo(Joint.p22);
  line:LineTo(Joint.p21) ;    line:LineTo(Joint.p11x);
  layer:AddObject(CreateCadContour(line), true)
end  -- end of function
-- ======================================================
local function WriteSettings(job) -- Read from Registry values
        local  layer = job.LayerManager:GetLayerWithName("Joint Settings Notes")  ;
        local px = Joint.p05
        px = Polar2D(px, 270.0 ,Joint.FingerDiameter)
        local marker = CadMarker("Joint.TailCount:" .. tostring(Joint.TailCount),px, 0)
        layer:AddObject(marker, true)
        px = Polar2D(px, 270.0 ,Joint.FingerDiameter)
         marker = CadMarker("Joint.FingerDiameter:" .. tostring(Joint.FingerDiameter),px, 0)
        layer:AddObject(marker, true)
        px = Polar2D(px, 270.0 ,Joint.FingerDiameter)
         marker = CadMarker("Joint.ClearanceEnd:" .. tostring(Joint.ClearanceEnd),px, 0)
        layer:AddObject(marker, true)
        px = Polar2D(px, 270.0 ,Joint.FingerDiameter)
         marker = CadMarker("Joint.StockThickness:" .. tostring(Joint.StockThickness),px, 0)
        layer:AddObject(marker, true)
        px = Polar2D(px, 270.0 ,Joint.FingerDiameter)
         marker = CadMarker("Joint.MateralOrgPoint:" .. tostring(Joint.MateralOrgPoint),px, 0)
        layer:AddObject(marker, true)
        px = Polar2D(px, 270.0 ,Joint.FingerDiameter)
         marker = CadMarker("Joint.MateralAng:" .. tostring(Joint.MateralAng),px, 0)
layer:AddObject(marker, true)

end --function end
-- ======================================================
local function DrawEndPockets(job) -- Setup joint data
  local pt = Polar2D(Joint.p01, Joint.OrgAng1b, (Joint.TailCenters * 0.5)) ;
  for _ = Joint.TailCount, 1, -1 do
    DrawTail(job, pt)
    pt = Polar2D(pt, Joint.OrgAng1b, Joint.TailCenters) ;
  end
end  -- end of function
-- ======================================================
local function StockSetup() -- setup stock base on user dialog inputs
    Joint.p01 = Point2D(1.0, 1.0) ;    Joint.p02 = Point2D(1.0, 1.0) ;     Joint.p03 = Point2D(1.0, 1.0) ;    Joint.p04 = Point2D(1.0, 1.0) ;     Joint.p05 = Point2D(1.0, 1.0) ;    Joint.p06 = Point2D(1.0, 1.0) ;    Joint.p07 = Point2D(1.0, 1.0) ;    Joint.p08 = Point2D(1.0, 1.0) ;    Joint.p09 = Point2D(1.0, 1.0) ;    Joint.p10 = Point2D(1.0, 1.0) ;    Joint.p11 = Point2D(1.0, 1.0) ;    Joint.p12 = Point2D(1.0, 1.0) ;     Joint.p13 = Point2D(1.0, 1.0) ;    Joint.p14 = Point2D(1.0, 1.0) ;     Joint.p15 = Point2D(1.0, 1.0) ;    Joint.p16 = Point2D(1.0, 1.0) ;    Joint.p17 = Point2D(1.0, 1.0) ;    Joint.p18 = Point2D(1.0, 1.0) ;    Joint.p19 = Point2D(1.0, 1.0) ;    Joint.p20 = Point2D(1.0, 1.0) ;        Joint.p21 = Point2D(1.0, 1.0) ;    Joint.p22 = Point2D(1.0, 1.0) ;    Joint.p23 = Point2D(1.0, 1.0) ;    Joint.p24 = Point2D(1.0, 1.0) ;        Joint.p25 = Point2D(1.0, 1.0) ;    Joint.p26 = Point2D(1.0, 1.0) ;

  if Joint.MateralAng       ==   "0.0" and Joint.MateralOrgPoint == "Right" then
        Joint.OrgAng1a =   0.0 ;         Joint.OrgAng1b = 270.0 ;        Joint.OrgAng2a = 180.0 ;         Joint.OrgAng2b =  90.0
    elseif Joint.MateralAng ==  "90.0" and Joint.MateralOrgPoint == "Right" then
        Joint.OrgAng1a =  90.0 ;         Joint.OrgAng1b =   0.0 ;        Joint.OrgAng2a = 270.0 ;         Joint.OrgAng2b = 180.0
    elseif Joint.MateralAng == "180.0" and Joint.MateralOrgPoint == "Right" then
        Joint.OrgAng1a = 180.0 ;         Joint.OrgAng1b =  90.0 ;        Joint.OrgAng2a =   0.0 ;         Joint.OrgAng2b = 270.0
    elseif Joint.MateralAng == "270.0" and Joint.MateralOrgPoint == "Right" then
        Joint.OrgAng1a = 270.0 ;         Joint.OrgAng1b = 180.0 ;        Joint.OrgAng2a =  90.0 ;         Joint.OrgAng2b =   0.0
    elseif Joint.MateralAng ==   "0.0" and Joint.MateralOrgPoint ~= "Right" then
        Joint.OrgAng1a =   0.0 ;         Joint.OrgAng1b =  90.0 ;        Joint.OrgAng2a = 180.0 ;         Joint.OrgAng2b = 270.0
    elseif Joint.MateralAng ==  "90.0" and Joint.MateralOrgPoint ~= "Right" then
        Joint.OrgAng1a =  90.0 ;         Joint.OrgAng1b = 180.0 ;        Joint.OrgAng2a = 270.0 ;         Joint.OrgAng2b =   0.0
    elseif Joint.MateralAng == "180.0" and Joint.MateralOrgPoint ~= "Right" then
        Joint.OrgAng1a = 180.0 ;         Joint.OrgAng1b = 270.0 ;        Joint.OrgAng2a =   0.0 ;         Joint.OrgAng2b =  90.0
    elseif Joint.MateralAng == "270.0" and Joint.MateralOrgPoint ~= "Right" then
        Joint.OrgAng1a = 270.0 ;         Joint.OrgAng1b =   0.0 ;        Joint.OrgAng2a =  90.0 ;         Joint.OrgAng2b = 180.0
    else
        DisplayMessageBox("Error: StockSetup values test errored: /n"
                       .. "  Joint.MateralOrgPoint = " .. tostring(Joint.MateralOrgPoint) .. "/n"
                       .. "  Joint.MateralAng = " .. Joint.MateralAng)
    end
end  -- end of function
-- ======================================================
local function SystemSetup() -- setup stock base on user dialog inputs
  local RegistryRead = Registry(Joint.RegName)
  if RegistryRead:DoubleExists("Joint.FingerDiameter") then
    ReadRegistry()
  else
    Joint.TailCount = 3
    Joint.ClearanceEnd = 0.01
    Joint.FingerDiameter = 0.250
    Joint.StockThickness = 0.75
    Joint.StockWidth = 5.25
    Joint.MateralOrgPoint = "Right"
    Joint.MateralAng = "0.0"
    Joint.StockLayerSide = "material Stock Side"
    Joint.StockLayerEnd = "material Stock End"
    Joint.JointLayerEnd = "Milling The End Joint"
    Joint.JointLayerSide = "Milling The Side Joint"
    Joint.WriteSettings =  true
    WriteRegistry()
  end
  JointMath()
end  -- end of function
-- ======================================================
function main()
        Joint.Name = "Easy Lock Joint Maker"
        Joint.VersionNumber = "1.3"
        Joint.Version = "Version " .. Joint.VersionNumber
        Joint.RegName = "EasyLockJoint" .. Joint.VersionNumber
        local job = VectricJob()
        if not job.Exists then
                DisplayMessageBox("Error: No job loaded")
                return false ;
        end
        SystemSetup() -- Get default values
        if InquiryJoint("Easy Lock Joint Settings") then
                StockSetup()
                JointMath()
                DrawStock(job)
                if  Joint.WriteSettings  then
                        WriteSettings(job)
                end
                DrawEndPockets(job)
                DrawSideTails(job)
                job:Refresh2DView()
        end
  return true
end  -- end of function
--  =============== End of Program ======================