-- VECTRIC LUA SCRIPT
------------------------------------------
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented;  you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
--
-- This Gadget was writen by JimAndi Gadgets of Houston, Texas. (January 2020) It supports all Vectric version to create both the Vectors and Toolpaths.
--
-- Please Note: The Boxjoint Toolpaths programming is very heavily based on code from Vectric's core software SDK, Brian Moran and many other great developers.
require "strict"
-- require("mobdebug").start()

-- Global variables
local BoxJoint = {}

  if GetAppVersion() >= 10.0 then
    BoxJoint.AppValue = true
    -- lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
    Tool_ID = ToolDBId()
    Tool_ID:LoadDefaults("My Toolpath1", "")
  else
    BoxJoint.AppValue = false
    BoxJoint.ToolDia = 0.250
    BoxJoint.Tool = Tool("Lua End Mill", Tool.END_MILL)
  end --if end
-- ===================================================]]
function ifX(x) --  Converts x to True-False or Yes-No
  if type(x) == "string"  then
    if x == "Yes" then
      return true
    else
      return false
    end
  else
    if x then
      return "Yes"
    else
      return "No"
    end
  end
end
-- ===================================================]]
function ReadRegistry()                                 -- Reads data from the Registry
  local RegistryRead         = Registry(BoxJoint.RegistryTag)
  BoxJoint.LayerName1        = RegistryRead:GetString("BoxJoint.LayerName1",    "BoxJoint_Lefthand")
  BoxJoint.LayerName2        = RegistryRead:GetString("BoxJoint.LayerName2",    "BoxJoint_Righthand")
  BoxJoint.ToolPathName1     = RegistryRead:GetString("BoxJoint.ToolPathName1", "Left BoxJoint")
  BoxJoint.ToolPathName2     = RegistryRead:GetString("BoxJoint.ToolPathName2", "Right BoxJoint")
  BoxJoint.AppName           = RegistryRead:GetString("BoxJoint.AppName",       "Easy BoxJoint Maker")
  BoxJoint.By                = RegistryRead:GetString("BoxJoint.By",            "By: JimAndi Gadgets")
  BoxJoint.Year              = RegistryRead:GetString("BoxJoint.Year",          "2020")
  BoxJoint.Direction1        = RegistryRead:GetInt("BoxJoint.Direction1",       0)
  BoxJoint.Direction2        = RegistryRead:GetInt("BoxJoint.Direction2",       0)
  BoxJoint.Direction3        = RegistryRead:GetInt("BoxJoint.Direction3",       0)
  BoxJoint.Direction4        = RegistryRead:GetInt("BoxJoint.Direction4",       0)
  BoxJoint.NoFingers0        = RegistryRead:GetInt("BoxJoint.NoFingers0",       7)
  BoxJoint.NoFingers1        = RegistryRead:GetInt("BoxJoint.NoFingers1",       4)
  BoxJoint.NoFingers2        = RegistryRead:GetInt("BoxJoint.NoFingers2",       3)
  BoxJoint.Offset            = RegistryRead:GetInt("BoxJoint.Offset",           0)
  BoxJoint.ToolSize          = RegistryRead:GetDouble("BoxJoint.ToolSize",      0.250)
  BoxJoint.FingerFit         = RegistryRead:GetDouble("BoxJoint.FingerFit",     0.015)
  return true
end -- function end
-- ===================================================]]
function WriteRegistry()                                -- Writes data to the Registry
  local RegistryWrite = Registry(BoxJoint.RegistryTag)
  local RegValue = RegistryWrite:SetString("BoxJoint.LayerName1",       BoxJoint.LayerName1)
        RegValue = RegistryWrite:SetString("BoxJoint.LayerName2",       BoxJoint.LayerName2)
        RegValue = RegistryWrite:SetString("BoxJoint.ToolPathName1",    BoxJoint.ToolPathName1)
        RegValue = RegistryWrite:SetString("BoxJoint.ToolPathName2",    BoxJoint.ToolPathName2)
        RegValue = RegistryWrite:SetString("BoxJoint.AppName",          BoxJoint.AppName)
        RegValue = RegistryWrite:SetString("BoxJoint.By",               BoxJoint.By)
        RegValue = RegistryWrite:SetString("BoxJoint.Year",             BoxJoint.Year)
        RegValue = RegistryWrite:SetInt("BoxJoint.Direction1",          BoxJoint.Direction1)
        RegValue = RegistryWrite:SetInt("BoxJoint.Direction2",          BoxJoint.Direction2)
        RegValue = RegistryWrite:SetInt("BoxJoint.Direction3",          BoxJoint.Direction3)
        RegValue = RegistryWrite:SetInt("BoxJoint.Direction4",          BoxJoint.Direction4)
        RegValue = RegistryWrite:SetInt("BoxJoint.NoFingers0",          BoxJoint.NoFingers0)
        RegValue = RegistryWrite:SetInt("BoxJoint.NoFingers1",          BoxJoint.NoFingers1)
        RegValue = RegistryWrite:SetInt("BoxJoint.NoFingers2",          BoxJoint.NoFingers2)
        RegValue = RegistryWrite:SetInt("BoxJoint.Offset",              BoxJoint.Offset)
        RegValue = RegistryWrite:SetDouble("BoxJoint.ToolSize",         BoxJoint.ToolSize)
        RegValue = RegistryWrite:SetDouble("BoxJoint.FingerFit",        BoxJoint.FingerFit)
        RegValue = RegistryWrite:SetString("BoxJoint.InquiryBoxJointX", BoxJoint.InquiryBoxJointX)
        RegValue = RegistryWrite:SetString("BoxJoint.InquiryBoxJointY", BoxJoint.InquiryBoxJointY)
  return true
end -- function end
-- ===================================================]]
function Polar2D(pt, ang, dis)
  local y_ = dis * math.sin(ang)
  local x_ = dis * math.cos(ang)
  return Point2D((pt.X + x_), (pt.Y + y_))
end  -- function end
-- ===================================================]]
function GetMaterialSettings()
  local mtl_block = MaterialBlock()
  --local units
  if mtl_block.InMM then
    BoxJoint.Units  = "Drawing Units: mm"
    BoxJoint.Unit = true
  else
    BoxJoint.Units  = "Drawing Units: inches"
    BoxJoint.Unit = false
  end
	if mtl_block.Width > mtl_block.Height then
		BoxJoint.MaterialThickness = mtl_block.Height
		BoxJoint.MaterialLength = mtl_block.Width
    BoxJoint.Orantation = "H"
	else
		BoxJoint.MaterialThickness = mtl_block.Width
		BoxJoint.MaterialLength = mtl_block.Height
    BoxJoint.Orantation = "V"
	end

  if mtl_block.Height == mtl_block.Width then
      MessageBox("Error! Material block cannot square")
  end
    -- Display material XY origin
    local xy_origin_text = "invalid"
    local xy_origin = mtl_block.XYOrigin

  if  xy_origin == MaterialBlock.BLC then
      xy_origin_text = "Bottom Left Corner"
    if BoxJoint.Orantation == "V" then
      BoxJoint.Direction1 = 90.0
      BoxJoint.Direction2 = 0.0
      BoxJoint.Direction3 = 270.0
      BoxJoint.Direction4 = 180.0
      BoxJoint.Bulge = 1.0
    else
      BoxJoint.Direction1 = 0.0
      BoxJoint.Direction2 = 90.0
      BoxJoint.Direction3 = 180.0
      BoxJoint.Direction4 = 270.0
      BoxJoint.Bulge = -1.0
    end

  elseif xy_origin == MaterialBlock.BRC then
    xy_origin_text = "Bottom Right Corner"
    if BoxJoint.Orantation == "V" then
      BoxJoint.Direction1 = 90.0
      BoxJoint.Direction2 = 180.0
      BoxJoint.Direction3 = 270.0
      BoxJoint.Direction4 = 0.0
      BoxJoint.Bulge = -1.0
    else
      BoxJoint.Direction1 = 180.0
      BoxJoint.Direction2 = 90.0
      BoxJoint.Direction3 = 0.0
      BoxJoint.Direction4 = 270.0
      BoxJoint.Bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.TRC then
      xy_origin_text = "Top Right Corner"
    if BoxJoint.Orantation == "V" then
      BoxJoint.Direction1 = 270.0
      BoxJoint.Direction2 = 180.0
      BoxJoint.Direction3 = 90.0
      BoxJoint.Direction4 = 0.0
      BoxJoint.Bulge = 1.0
    else
      BoxJoint.Direction1 = 180.0
      BoxJoint.Direction2 = 270.0
      BoxJoint.Direction3 = 0.0
      BoxJoint.Direction4 = 90.0
      BoxJoint.Bulge = -1.0
    end
  elseif xy_origin == MaterialBlock.TLC then
      xy_origin_text = "Top Left Corner"
    if BoxJoint.Orantation == "V" then
      BoxJoint.Direction1 = 270.0
      BoxJoint.Direction2 = 0.0
      BoxJoint.Direction3 = 90.0
      BoxJoint.Direction4 = 180.0
      BoxJoint.Bulge = -1.0
    else
      BoxJoint.Direction1 = 0.0
      BoxJoint.Direction2 = 270.0
      BoxJoint.Direction3 = 180.0
      BoxJoint.Direction4 = 90.0
      BoxJoint.Bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
      xy_origin_text = "Center"
    if BoxJoint.Orantation == "V" then
      BoxJoint.Direction1 = 0.0
      BoxJoint.Direction2 = 0.0
      BoxJoint.Direction3 = 0.0
      BoxJoint.Direction4 = 0.0
      BoxJoint.Bulge = 1.0
    else
      BoxJoint.Direction1 = 0.0
      BoxJoint.Direction2 = 0.0
      BoxJoint.Direction3 = 0.0
      BoxJoint.Direction4 = 0.0
      BoxJoint.Bulge = -1.0
    end
      MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
  else
      xy_origin_text = "Unknown XY origin value!"
      MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
    if BoxJoint.Orantation == "V" then
      BoxJoint.Direction1 = 0
      BoxJoint.Direction2 = 0
      BoxJoint.Direction3 = 0
      BoxJoint.Direction4 = 0
    else
      BoxJoint.Direction1 = 0
      BoxJoint.Direction2 = 0
      BoxJoint.Direction3 = 0
      BoxJoint.Direction4 = 0
    end
  end
  -- Setup Fingers and Gaps
  BoxJoint.NoFingers0 = 1 + (Rounder(BoxJoint.MaterialLength / BoxJoint.MaterialThickness, 0))
  BoxJoint.NoFingers2 = Rounder(BoxJoint.NoFingers0 / 2, 0)
  BoxJoint.FingerSize = BoxJoint.MaterialLength /  BoxJoint.NoFingers0
  BoxJoint.NoFingers1 = BoxJoint.NoFingers0 - BoxJoint.NoFingers2
	return true
end -- function end
-- ===================================================]]
function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- | draws a circle based on user inputs
  -- | job - current validated job unique ID
  -- | Cpt - (2Dpoint) center of the circle
  -- | CircleRadius - radius of the circle
  -- | Layer - layer name to draw circle (make layer if not exist)
  local pa   = Polar2D(Cpt, math.rad(180.0), CircleRadius)
  local pb   = Polar2D(Cpt, math.rad(0.0), CircleRadius)
  local line = Contour(0.0)
  line:AppendPoint(pa)
  line:ArcTo(pb,1)
  line:ArcTo(pa,1)
  local layer = job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
--===================================================]]
function DrawBoxPoints(pts, LayerName)
  local line  = Contour(0.0)
  local layer = BoxJoint.Job.LayerManager:GetLayerWithName(LayerName)
  local ptA   = Polar2D(pts,  math.rad(BoxJoint.Direction1), BoxJoint.FingerSize * 0.5)

  -- Slot Points
  local pt1   = Polar2D(ptA,  math.rad(BoxJoint.Direction3), (BoxJoint.FingerSize + BoxJoint.FingerFit) * 0.5)
  local pt2   = Polar2D(pt1,  math.rad(BoxJoint.Direction2),  BoxJoint.MaterialThickness)
  local pt3   = Polar2D(pt2,  math.rad(BoxJoint.Direction1),  BoxJoint.FingerSize + BoxJoint.FingerFit)
  local pt4   = Polar2D(pt3,  math.rad(BoxJoint.Direction4),  BoxJoint.MaterialThickness)

  -- Circle Points
  local pt1A  = ptA
  local pt2A  = Polar2D(ptA,  math.rad(BoxJoint.Direction2),  BoxJoint.MaterialThickness)
  local pt1B  = Polar2D(pt1A, math.rad(BoxJoint.Direction4), (BoxJoint.FingerSize + BoxJoint.FingerFit) * 0.5)
  local pt2B  = Polar2D(pt2A, math.rad(BoxJoint.Direction2), (BoxJoint.FingerSize + BoxJoint.FingerFit) * 0.5)

  local pt4a = Polar2D(pts, math.rad(BoxJoint.Direction1),   BoxJoint.FingerSize)

	if layer == nil then
		DisplayMessageBox("Unable to create layer - " .. LayerName)
		return false
	end
  line:AppendPoint(pt1)
  -- Draw line from pt1 to pt2
  line:LineTo(pt2)
  -- Draw arc from pt2 to pt3
  line:ArcTo(pt3, BoxJoint.Bulge)
  -- Draw line from pt3 to pt4
  line:LineTo(pt4)
  -- Draw arc from pt4 to pt1
  line:ArcTo(pt1, BoxJoint.Bulge)
  layer:AddObject(CreateCadContour(line),true)

  -- What is the Max releif circle
  local maxDia = GetDistance(pt1B, pt1)
  -- Draw the Circles
  DrawCircle(BoxJoint.Job, pt1B, maxDia, LayerName .. "-ReliefCuts")
  DrawCircle(BoxJoint.Job, pt2B, maxDia, LayerName .. "-ReliefCuts")
  -- Return the lat point
  return pt4a
end -- function end
-- ===================================================]]
function GetDistance(objA, objB)                        -- Returns the distance between two points
   local xDist = objB.x - objA.x
   local yDist = objB.y - objA.y
   return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end -- End Fuction
-- ===================================================]]
function CreatFingerCutPaths()
  local BasePoint = Point2D(0,0)
  BasePoint = Polar2D(BasePoint, math.rad(BoxJoint.Direction1), BoxJoint.FingerSize)
  -- Loop the DrawBoxPoints for each fingers on part 1
  for _ = 1, BoxJoint.NoFingers1 do
    BasePoint = DrawBoxPoints(BasePoint, BoxJoint.LayerName1)
    -- Move the BasePoint
    BasePoint = Polar2D(BasePoint, math.rad(BoxJoint.Direction1), BoxJoint.FingerSize)
  end
  -- Loop the DrawBoxPoints for each fingers on part 2
  BasePoint = Point2D(0,0)
  for _ = 1, BoxJoint.NoFingers2 do
    BasePoint = DrawBoxPoints(BasePoint, BoxJoint.LayerName2)
    -- Move the BasePoint
    BasePoint = Polar2D(BasePoint, math.rad(BoxJoint.Direction1), BoxJoint.FingerSize)
	end
  return true
end  -- function end
-- ===================================================]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
 --[[
|   Add all the vectors on the layer to the selection
|     layer,            -- layer we are selecting vectors on
|     selection         -- selection object
|     select_closed     -- if true  select closed objects
|     select_open       -- if true  select open objects
|     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
|  Return Values:
|     true if selected one or more vectors
]]
   local objects_selected = false
   local WarningDisplayed = false
   local pos = layer:GetHeadPosition()
      while pos ~= nil do
	     local object
         object, pos = layer:GetNext(pos)
         local contour = object:GetContour()
         if contour == nil then
            if (object.ClassName == "vcCadObjectGroup") and select_groups then
               selection:Add(object, true, true)
               objects_selected = true
            else
               if not WarningDisplayed then
                  local message = "Object(s) without contour information found on layer - ignoring"
                  if not select_groups then
                     message = message ..
                               "\r\n\r\n" ..
                               "If layer contains grouped vectors these must be ungrouped for this script"
                  end
                  DisplayMessageBox(message)
                  WarningDisplayed = true
               end
            end
         else  -- contour was NOT nil, test if Open or Closed
            if contour.IsOpen and select_open then
               selection:Add(object, true, true)
               objects_selected = true
            else if select_closed then
               selection:Add(object, true, true)
               objects_selected = true
            end
         end
         end
      end
   -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
   -- tell selection we have now finished updating
   if objects_selected then
      selection:GroupSelectionFinished()
   end
   return objects_selected
end
-- ===================================================]]
function CreateBoxjointToolpath2(layer_name, toolpath_name)
  local selection = BoxJoint.Job.Selection
  selection:Clear()
  local layer = BoxJoint.Job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
  local tool = Tool("Lua End Mill", Tool.END_MILL)
       tool.InMM = BoxJoint.Unit
       tool.ToolDia = BoxJoint.ToolSize
       tool.Stepdown = BoxJoint.ToolSize * 0.33
       tool.Stepover = BoxJoint.ToolSize * 0.10
       tool.RateUnits = Tool.INCHES_MIN
       tool.FeedRate = 40
       tool.PlungeRate = 20
       tool.SpindleSpeed = 20000
       tool.ToolNumber = 2
  local mtl_block = MaterialBlock()
  local mtl_box = mtl_block.MaterialBox
  local mtl_box_blc = mtl_box.BLC
  local pos_data = ToolpathPosData()
       pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
       pos_data.SafeZGap = mtl_block.Thickness * 0.1
  local pocket_data = PocketParameterData()
       pocket_data.StartDepth = 0
       pocket_data.CutDepth = BoxJoint.MaterialThickness
       pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
       pocket_data.Allowance = 0.0
       pocket_data.DoRasterClearance = true
       pocket_data.RasterAngle = 0
       pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
       pocket_data.DoRamping = false
       pocket_data.RampDistance = 1.0
       pocket_data.ProjectToolpath = false
  local geometry_selector = GeometrySelector()
  local create_2d_previews = true
  local display_warnings = true
  local area_clear_tool = nil
  local toolpath_manager = ToolpathManager()
  local toolpath_id = toolpath_manager:CreatePocketingToolpath(toolpath_name, tool, area_clear_tool, pocket_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
  if toolpath_id  == nil  then
    DisplayMessageBox("Error Creating Toolpath")
    return false
  end
  return true
end
-- ===================================================]]
function CreateBoxjointToolpath1(layer_name, toolpath_name)
  local selection = BoxJoint.Job.Selection
  selection:Clear()
  local layer = BoxJoint.Job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
  local pocket_data                 = PocketParameterData()
        pocket_data.StartDepth      = 0
        pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
        pocket_data.CutDirection    = ProfileParameterData.CLIMB_DIRECTION
        pocket_data.CutDepth        = BoxJoint.MaterialThickness
        pocket_data.RasterAngle     = 0
        pocket_data.Allowance       = 0.0
  local pos_data                    = ToolpathPosData()
  local geometry_selector           = GeometrySelector()
  local toolpath_manager            = ToolpathManager()
  local toolpath = toolpath_manager:CreatePocketingToolpath(toolpath_name, BoxJoint.Tool, nil, pocket_data, pos_data, geometry_selector, true , true )
  if toolpath == nil then
    MessageBox("Error creating toolpath")
    return false
  end
   return true
end  -- function end
-- ===================================================]]
function InquiryBoxJoint()
    if BoxJoint.AppValue then
    BoxJoint.ToolTable = [[<table width="100%" border="0"><tr><td colspan="3" align="right" nowrap class="h1-r"><hr></td></tr><tr><td width="77" align="right" nowrap class="h1-rPx">Profile Tool:</td><td width="358" nowrap="nowrap" class="ToolNameLabel"><span id = "ToolNameLabel">-</span></td><td width="101" nowrap class="ToolPicker" id="ToolChooseButton"><strong><input name = "ToolChooseButton" id="ToolChooseButton" type = "button" class = "ToolPicker" value = "Tool"></strong></td></tr><tr><td colspan="3" nowrap><label class="alert" id="BoxJoint.Alert"></label></td></tr></table>]]
  else
    BoxJoint.ToolTable =  [[<table width="100%" border="0"><tr><td align="right" nowrap class="h1-r"><hr></td></tr><tr><td align="right" nowrap class="h1-rPx">Pocket Bit Diameter<input name="BoxJoint.ToolDia" type="text" id="BoxJoint.ToolDia" size="9"></td></tr><tr><td nowrap><label class="alert" id="BoxJoint.Alert"></label></td></tr></table>]]
  end --if end

  local myHtml=[[<html><head><title>Boxjoint Toolpath Creator</title><style type="text/css">html{overflow:hidden}
  .helpbutton{background-color:#E1E1E1;border:1px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:#000}.helpbuttonx{background-color:##E1E1E1;border:1px solid #999;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;display:inline-block;font-size:12px;margin:40px 20px;cursor:pointer;color:#000;padding:2px 12px}
  .helpbutton:active{border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000}
  .helpbutton:hover{border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}
  .LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
  .DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}
  .ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;  font-size:12px;text-align:center;width:50px}
  .ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#FF0}
  .FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap}
  .h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;white-space:nowrap}
  .h2-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}
  .h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;white-space:nowrap}
  .h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right; white-space:nowrap;padding-right:4px;padding-left:4px}
  .h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right; white-space:nowrap;padding-right:8px;padding-left:8px}
  .alert{font-family:Arial,Helvetica,sans-serif;font-size:12px; font-weight:bold;color:#00F;text-align:center;white-space:nowrap}
  .h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;white-space:nowrap}
  .header1-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}
  .header2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-align:center;white-space:nowrap}
  body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style>
</head><body><table width="550" border="0" class="h2-l"><tr><td class="header2-c" id="BoxJoint.AppName">-</td><td width="28%"" align="right" class="h1-c" style="color: #999999" "width:20%><label id= "BoxJoint.Version"></label></td></tr><tr><td><p class="h2-l">This gadget creates a series of tool paths for a boxjoint from the material job setup settings.</p><p class="h2-l">This requires the material to be held in a <strong>vertical position</strong> so that the milling can be performed on the end of the material to receive specified joinery.</p><p class="h2-l">The gadget assumes that the Boxjoint will run in the direction of the longest side of the material job and the material is a rectangle in shape.</p><p class="h2-l">Use the Top of material (top end of material) for the Z value. Set the materialthickness to the length of material.</p><p class="h2-l">For best results in cutting action, use &quot;up-cut&quot; spiral bits.</p></td><td align="center" valign="middle"><img name="BoxJointxfw" src=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAACgCAYAAADuIpVSAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEgAACxIB0t1+/AAAABx0RVh0U29mdHdhcmUAQWRvYmUgRmlyZXdvcmtzIENTNui8sowAAAAWdEVYdENyZWF0aW9uIFRpbWUAMDMvMTcvMjHKs77gAAAgAElEQVR4nOydd6BlZXX2f2/Z9ZRbpzLDzNBBqiCCgmANIIqGYi8YjSIW0M8WNTFBhSiCgtFoELFQjAgWkChWioIgIAwMZYCB6TN3bjl1l7d8f+xzLyDGkpAvXwzvH/dMOefsvc9+zlrPetaz3iu89zy5nlxP9JL/3Sfw5PrzXE8C63/xEkLsKoS4WAhRe6LfWz/Rb/jk+v9/CSFGgbcDhwCXAsUTfYwnI9b/oiWEqO+62+6nxknyo92esvuzr73uBw/Z3tqdulvufJOZvus59O9djtsQPyHHepK8/+9YQoj9h0ZGzh+fP3/FX7/5DfrkN74miQPod9so6XwUqIl+1ntQOHdXGOjbkepupdSa6X5vy1U33zDzyiNPMn/S8Z4E1p/3EkIsBD4aJ8mr33bKO6K/ec87GRkZwnYnKcsCY0uUAmdLJA4tIdDaZWUxZY3b5Lx7SAfBA3EQPCi8X4cUm5BqEsQEUm0l3tH+zuM+Caw/zyWEaAKv1GF4yrMOf9aSz37mrNruu+0MZYtuewYpJVqCtYbSltRCCc5gPXSyDCUE9TTBO4+SEvAeRNd737betxBMaB38mtqCT8HIw487/pPA+vNaQogQeLaQ6qQ9997z0L/92/eOHvfSo8D0Mf0ueZZRmgKlFFoHCOHQwpJlPfIixziI44RmmiCEAMTgnT1FURIEIcYagiQF67nu1jtOPOSQ4y747fN4sir8M1pCiJ2B09I03f7cc89cfuKrjx0V0tKf3EhZ5kgJoRKEWoN39LIWed7D2wIvYKTRIAg0HoX3HiEl1hqc9eRlQaA1QgmCtMa1v/g1H/jw2ey4247LDjnkuMedy+OAtWrVKnbffff/F5/Dk+sJWkKIceAk4CXPPvzQ63581TefLoRZhOnR6rQR3pHEYRWRjGdbq0WsBc5k1JOQUNfRWs4FJy8kxnq8KTDWEGpNoBRRvUa/3eHtp57GNdfezKEH7ccHTn3T7zynxwHrvwpUQohdgU8CFwJXeO+7/yUH+l+0hBB14KXAXwJ33vqrq7+/z167f7DIO8LYElyJEI5QK/AOHGxrt9ASmqkmkCkCQWEszguEDDFOkhsL3hCHAYEOCEKNT0Ku+N7PeM8HzySOIy78wkfZd6/d2DI9U6OC5GM41f9LHeth4FzgcOB7QohPCSEOEUI8IbrJ/6YlhJBCiGcBnwaed+xLX/jPvr9+93333O1DzhSi020RKocSDrwjK3OKsmTL9CTCW0brmlB68GA9aB2CDMlLi3OONNKkkQbhCRsJD6/fzIHPfBkvf827OPaY53Hzj7/ODiuWMDnTZnxoeDnZ6scp9/815N3OjGCKYY+PBF6B9ghlvVQZUnWPfvHxzR/96MfPK/L82UAI3Ky0/pYpy3uf+JP581pCiAZwNnDIzjvv+Il7V167oMzzd1lnxos8xzlDHEiMs0gpyPo5/bzAeUstCRiOJd5meBQ6iMmKEus9xjiSJEJJibWOMA7J8pwPffyLnHf+pey//1O48IsfoxZHTLc7DDebpHGMkvJ2pDyexp6PuXdPGLDcTX8v2fWE/YVKXiRk8HQv9AIgFAKBFyCEQ8gM1KQXcitCt4wju/Ty74x+4bzzdrjzjpXL03p9evc99vjNW05684UvOfLoHwJ/kij357yEEAnwGiHlO//iBc9Ze+kl53WTUD+73++NlGVJGmmcKylNSRho8qKk1enR6XYYHW4yPpTgiw5lWaCCEKlCsrzEOUctibHOY60lCCSqXuMz536Ns//pIoaadT7+4ZM55Ol7I4VAK41UikBrQCCE7AgpD6W5122POd8nAljeTO4krHsdPn+Vt/mKKt0qEAohqseKGM6WrxKkqp6jNM55Ov2C8y74Kpdc8g3uvftuOzZv3saddt3la58668x/3HPHXWb+0yf5P3QJITTwTOC07ZcvnXfuZ87Y4YjnHhpqKcn6PZwrSKKAPOvjcCip6WY596/dwJIFo4w36yhfIH2OEBJkQGE9eVESBJokjDDWUpqCpJmy7qGNHHfiB1i16gE+8O4TefUJR1JPQrTU6CBAK42SsiJUQoKQE867nfXIftOPOe//DLB8ObUIwVHeuzcKxEHVPzpwJfiKAHrvEUiECiqAefGINMIs6BRoBSLCmoK77r2P87/yNb57+XdozcwUS5Ytu/PQww89/5xPfOoSYOI/fML/w5YQYgWIM5tDjWed/PY3jb/v1LcwNNzEZhnT0y1qcUgcK7ZObCaOYxqNJkjBbSvvoVmvsWT+KNK00MLjRIgXmrwwOO+I4ggpBGWeEQQCpQRvf/9ZnPeV77Dvvrtx+Zc/TppEOC/QSiGlIgqCSoLwvtK4hEBJ/SMxvM/zH3fufzKw7MwQ1uzokM8UQhzt8YcAqXjMk/wAWA68RTiD9646oAxAajwgKtgPkK/wQiCUBhkDml6vxZU//BH/+s1LufXXv0ZIWQRRdNGq237zd977x6m9fy5LCFGL4uTD1pSnvOJVx6szTnufXrx0KbbbodvroLXCmJJYecoyJzOOWlqn1enQ6WV455g/UkP7HkkUUxBSFAatJc56lNbgDFEARJILL7qSv/34vyC14sy/O4lnHPgUpqY7bL9oPqX14CW1NMV6j/ce6z1BEFJaR27Ks4cXP+Ndj7uGPwZYH/uHdz/19X/18qdst93O22P7+/rS7Y3QKxAyQCgeKS79LFrACwQevMPjwBlwBu8NAoFQER41eA0ILyuAIfFCghQIFYIIAcnGTev5zhVXcelll3H3XXc9uP6hh38C/Ctwg/e+9YTc0f/mJYSIgGPiOD71iCOet+fHPvLu+h577YbLc7J+hrElYRAghSPP2kxMTmGcxsuARhpSGkMtjhipR0hfYB14EVAUJVprSudQeAJlUbWIO27+DSe992weWruJl77wWbznrSfQTKtI5oQijmKEkHgUDoGUAq0DnIeyNGSlIYqiM2sLnvaex13LHwLWh07/UHj+575801CzvsfTn7aPftfbX8+e++2FdAqcwHsxSGcDYPjHSRoDlcMPIliJtwXClYNwGuGFAiEGLQTwFSkEBqCVAnQARIDnNytXcsHXLmx9+1vfWrP24bWbbFn+ArgMWOW9/x9H+IUQCngacPLyFctXfOofP7z3S1/47IbQmm67h8eihKAwJa1Wm37WYbrVol4fZbtF8xDOVcRaSwJhkN6QWU9hJbUoxDuPVApjM6JGgG21efv7P83XvnEVhx36VD7992+hnkQoqbB4xpsNvJT0C4sUEi8DlNJ4IehnOUEQopUmiUOE4CwxvN+7H3dNfwhY27beN3b7HbdcfMnl//b8X930G+5ZeQ8rli/hbW95LSedfCIgwYC3HoQckPVB5JkFmKjCaQU4X4HMZuB6VRQTGlSElEH1Cg9CCDwSUVWUeKEGQFQDkCmmZ6a55rob/Ze/csGGa39+jcryYmMcJz/YtnnTx7z3nSfy5v9XLSHEfODDtXr9Baf9w/s7b//rVz1VS4kpS4wzFGVJoCVKau5+YA3GOdIoYsni+dTjiLwowDm0Bmn71XdYxXTzEi01UaCrzzP24Hqcdc5FnHXuxYSB5pwz3sFB++6MsA7rPfU0ATzeCywgZUDhPFIGSKVx3iGQNGq16k56D5J/1KMHvP9x1/WHgNXadOMOzeGRS7N+tt9Mu8fV197IP513CQ/c8yAzk9O85Jjnc+rJJ/L0Qw+C0oGTFVeiQvocUxcVx6oimgTvEBi8y/A2RzgLQlcpUmgeG/VEBdg51q/xcpaPRXhbsGXbJOdd8DUuvezbrLzlNhPG8T2LttvuM6tXrfoy/5/KFkKIk4Mw/PBzn3t4cvHXP9cciqseXWFKvLMgPMaUKBT3rt2EKQvmjQ2zaGwUgScvc7RSBNKhXAFSY5F4LyitIwkjCBTEjh9/74ec+uF/YmJimhNf/gJOft2LsNaQRAF40LoKBFJWWaJvHVEQYxF4J6gnKUkcYZwnKwsCHSCVQin5TTmy/wmPu7Y/BCzbumN/hbjM4bbPcoMOFN7Dmg1buOjyH/LdK37M5JYJ5o+N8KoTXsRfnnAM22+/AsqC6q0fkRsEsopWFXUfHKEi+t7lVRTzrnq+ikA80nESePzcaySC2fQ7IP8DkJl+mzUbN3HGmZ/h2muu8xvXrrPbLdv+V3ffsfJk7/1jtJb/riWEOAx4/zOe8fT6Z88+/ZD99tsNbIHJC5x35KZASYmWEu896yem2DY9w9P23p0i6+Otw3uPUoJAAa7E+wDjQeAQUqKUgnrEujtX8oZTTmfVqgfYa48dOeODb2CkmVKagvkjQ1hrEEj6eU4cR+Sm+vxL65k3MoTzCq0lhanuWr801JKIQAXoIMA6f70a3f+Qx13jHwJWd+vNRwZKXgxiSAgQCLSSWA9KazZvm+b8b1zJZVf8GNPPcWXJ7rvsyImvPZ6DD30mzXoNihLnPVJWolqVKmc1LT/34J0BX8xVlF4IhAirFPsYYDH3WjH3XgOgzfExTXtmiit//FPO+9LXuO3mWx7atmXLPcB3gR9471f/5yHypy0hxHbAp5rNxqIvfPYTxXF/edTzpLcIHM5ZnIeiyHHeEWhFXjo2bN0GeHZYugicpyxL4jBACCo9yVtK65CA9R4tNaqm6W7bzN+e8QW+cuH3GWqkfO4fT2HZ9vMJ8Iw0EsqyAAHOgdYKLSWFcwRhSBrHSBlgnScrPVprcmsJdEAaJQRaQRAyOd3m3ofXrTv13Mt3/OU3/vUxvvk/CCzfuv2NRVl+3hir4yigKA1aqkrLALwQRFHMXasf4vpb7+TaX97CbbfehctzhpsNnnPYQbzyhGPYebdd0dbj8XgpEUL/Vnqj+rOflSYcwtsBTxtEqNlzms2uePBi8PdHotkscIVSoBPAcNOvb+Hy733//q9++aKV6x9e64AtwFXAtd77yf8YVP74laTpWaYs33za37//lvee+uYDnDWxKXMCLXCuoglZkRMGIZESICXrt06xdWqGPXZahs0LokDjBpEKPDiPd57MlkRhjAoluJwvffVSPv6pC8h7Oae8+VhOfPnz6XW6gGcoDSmMJQ41pbVkpaUsHWGoqSUxYaBxKFq9AqkCPJ4oCInCiDAMkEFIWVpuv38t1sEeOyyx9Vr9QBp73fLo6/29wPLtNQhmPgb8Dc5TlAWFKUFIvPOkcYRzkBUFjUaDyekWRVmy+uFN/Oj6m/nBT37B9NZtFN0+OyxfyitOOJrXvOY4giCCwlZcSupBWmMQk0TFrpwFHGAH0oWcPeO5yCWARwlij4pos5XpAGBCQhRAadi4aRP33P/g2s9/8aurr7ziB77bbneAVcDlwK3e+ydsYuW+1fefcM65577l8m998xnPPvwQdc7ZH9VxpFAw4JQOITzGWrxzRGGE1IoyL9i0bZoNW7axeN4Ii+aPIrxHSQ2y0vtKY8iznCgM0YFDioIf/OAaTj/nq6x9eBOHHrQX737LccwbrjMxOclYMyWNQ4wtQWjavR5JHBFIRT2NsXgK4+mXFiEkYRBSixJQsuJdQqGjkImZHnfdv5ZF46PsvP3iKupZ/3E5uv8HH33tvz9ide+qe2e+jHfHCQ/eOzwVocyLklCpucymhaJflEgBpS2x1jHd7nLDLXfx8OZJvvWdn9CZmmHVnas54di/4NR3nshBzzgIjACvQOiBzDB3atWDN+Crb+asodEjKkVfCGYFiuqn+K0LeFS6ZSBnSABDv9Nl3aYJfnXjr0969YnvEMDxVPrGVcCXvfeb/6OAWrO+U//8Zz924S+uu/bF8+aN8qEPvJO99tgFU+Zo6dBSUBQlQgrCQOGBsrQUhaHV6bK11WLByBDjI020UtW1q6D6jIRipt0hiQKcMyTDKXfedD1//8kv8bOf/5odly3iQ6e+mn2fspwi7xMHikBLQq0oSkdWVr3Efp6xZGyU3FjaeY5QEu8kSiqiKCKOYpRQeAEOidYxd61Zz6bJFnvttIz580ZwuQEl8Yh1HnbTo/vPWaF+P7A6dy73zlzqnd9f4OdSlBQeaz29LCPL+zTqCdILhJQESpDlGUVekcgo0mybbjPVyfj1yvv44XW3csuvV2L7GUpIXveKF3H8K17CimU7gFN4oRHMIYhHkObmlHyPn+P/vw2lR8Dl536KxzxLDCpSB0rgS+OE9++jvuJMIcQewOuAtwC/AL4MXOW9b/+xoBJC7Dk6Pnb1yPDQwo+d9kFecvTzKPIciSEJFVIKitKSlSXOWrZMTuM8GFMS6ACtJOOjQwzV0yrVCY3QIcaCswa8xZiCdCRlZvMmPnHu+Vzyje+T93NO+8AbOOzgvdk6Ocmy+UO0uj3qaVRFwyBgqtMlTSJGagmFcRTGYGylcYWRRsuQKAzQKsB5gfOCwnqSNOWXK1dTTxL22WUHpFK4woCsOK1H3Oe92FuPPTX744DVXvk0cJfh3BLrLN57nHXVt8wbwGGto5/nSATOOySOWhKBEHR7lYc6z3McgswYsI7b713Dz264ndvvepAtGzbjCsPuuyzj5ccdwXOPeB7DzTFwAc7LR0UlqPgTgypowMN+z02evbJHoPaoZwse0da8wztzo/DuLG86/6ZG9u4BfwEcB+wNXANc4r2/8fcAKgK+ALzufe97B2ec8Xds2bCBNFKkkUIK6OYF/cywdtNmNm6eADy77LicUEpqacLYaANbFIPrVCAjlFJ4V5IXfYoyp16LkdJzwdcv5zP/9BWmJtsc9byn896TT2BiahopHYtH6yRhwJaZDkkcYo2hmcbUkoiydLT7fbLS0qgleCfwwjFUqyGRGAfGAVKSJikzPcv9G7ewYHSEpYvnY4uS3FgCqRFCUHpHoMPP67H93/qYz+MPAOv54L7hvRsRA2HTWUtpDEJAOODTlQnf4l3VS+rnOVEYoAaNyjgM6ecZxjmMcdRrKcY6HnhoPbfcvYFb793MDTfchM96KGc5+MC9eM3LXsReBx5AIFK81wOO5QfywixqbFVJzkJmjtU/9poeDSjx76ZNqhLJ5Zvw5jeg7yJM+MHPbljysU9+9pl33HZ7bPJ8Ytmy5T990dEv/N4ZZ5zxAMA9d9+366tf/9pXrb737hfuusuOyZXfvYhaEmDKAiVB4vDWoYOArVMz3PXAwzRrCYvHxxhq1KgPpVAaSmsH1yQRKkTpEDwYW5D3Z6gnESSKn/34Gj5xzle57541bL94Ph9+92uYN9ZAScBbRusx1ju883TznEAJli4Ypd3LKUpLp58jlWS4niKFRCCQWg24rUBKjR7YaqZ7BQ9vmWLJ+CgjjRrZ4Dyz0jDWHCIrCoyzjDSbJ4nhp/7znwKsF3tnLkT4esVzHAKP8x7nDDg3V+FLPM45SmuZ6fTo5TmLxsZodzvEUUCkAwpjafcz8qIkCjTzx5p0eyUqTLjzwS1c9fNb+Nn1t7Fx/Tp6k5MsX7qAVx53BC9/5XEMjS8GK6jEmorYeSEGPchyUCFW0HkMsAZuit8WKx6FzsHPWU5Xcbm5/pgQ9HPD3WvWcck3L+O6a3/JpnXrWbRoITvssAO/ue024kjx8dP+hsMPPZhet0OoQamqn4YUTE636XQzplstVixdzHAjRWuFNY7SlDjrQEmCoEYYRoDEe4c1Jc4XxDXB3Xfezdmf/zrXXnMzmzdt49OnvZUDD9gNhSOJFHlZUosCwrCiHmkcMX8oBQSdfs76bTOkcUgShxVhj2OkVDgBeWmQQqKDgNIpuoVnupsThiEjjRreO9IwxvkqfTrvqSUJxjmUVCgp3xjMe/qX/nhgtW7/S7z7Cvi6p/oWCO+qSgBLUeRzNwMgCnSFeyXJ+hlZaSp9pCxxzpPEIUkUYa2lnxd4L+j2+yitaaYxXih8kPDrlWv4+S338Z3v/JCpzZvoTE+z3z67cfKbX8uL/vIlgKqii2XQnwTvCoQ3PI51DaKYF78zRj0KWLOfiEaoAO+r2Ca9B+krWw8pUPKhj36Cj3/ko0RhyF+94VWc8Q/vQ2tFnvcZaqYUWZ+J6Q4Tk9OkScy2yRY7LNsOIWGolmBKU/Gq2WowSQjDGkoHOGvo9LoEypM0YlqTWznz3Au44vs/Y/OGLRz/4sM4+fUvppFoHti0lcVjQ3R7PaIwoJ4GtPs5C4cbhFrRzXImW31UIKjHMaHWxEFAoBT5QDfrFwaPoJsZuoUjjus0a02MswRKkiYxeZ4R6AAvPJEOCJWgcI5OvyRNEuIoOpHhp17wRwPLt37zMrz7EvgaOHAecDjvwHskA5B5R1EarK2aodYZanFCXhZVJenAWEde5tTSGByEgabTy/GAc46pVpc4DnGuutCh5hATMznX3baGm39zHz/72XVsXPMQoVa89CVH8uY3vop999+3imC+amOArSLYb6VGj5ubkfvtyPVoHuaRoMJHiRmDKBgGgOS+e+/mo2d8miu/dxVHHvFcPve5T6KdxZqSehpiTcmmiUnWb5mgKAw7LVuMFIIkjtCq4g1JHDHT6tDPCxppQq05BCKsqkQcnfYUI8MpBJLvXvEjPv3ZC5jYvI3tF43z7rcex/aLxmj3M6JA0kginLd0+xmjzZR6FGK9p1dWUXDrVJuRZo1AaYbrCVJKulmBlgoVSCZbfdZNtEiTGvPHxoiTOt5BFGra/ZxaFBFoQVZUoqz3Dikl7X6fKIyJopANW6eZ7mV/v+8BL/3IHw0s2r95Pd59Hm9j7wfNY1xVZTmHHdxEpauo4VwFsKqR7AgCRT+vTtAYS2YMrXaHkaEmnV6fMAhIo5AoDml1umS5IVCKzBjqSUhZlERRTKfwrNvSZstkj0u++1N++qNr6bZa7LRiKSe9+bW8+OgXMDpvIZgCBkWGeMx1VSCpnBiPB9acZDEgzHNwkxJUgwcfWMXHPnkWP/3Rz1mxbAlnfvKj7LHzUpwpURICCVlZsnVymoc2bGH++DC1OAHhGKrXkaJKqc45elmODhS1uIHQIbmpigdbZmhlSYdqrLrzXj712fO55abf4K3jPW97Oc86cDcmJmeo12K0EhRldWwtBDrQLBxp0O9ndMuSTj8j0Lrq54kKgMY5nPNVYYXkx7fcgxchh+y7K1KF5KVDBQHeOpTWlWjrKxtUoBXGWIz1WBzD9Ro6iFi9diOdfs7ShfN/OL7ssL/4E4B12yl4/ylw0g/UYT+IVkJUN6+wBuMsColWEiXBO4+xBus9ZWnQShIFGjNIgUkYsGW6TRKHKFE5FAtj8JWYTKAkpakil7GWWhwShZpuZvEy5MFN09y+aj1fvfA7bN60mU67zQH77cm73v4mDjrkoIqnlDnelMwJpHMoeuz1ulnKNkCYHyj3IkoxZcHZn/0XLr7oEkKl+MD7TuHIFx6B7bVQlISBAgkbN0+wedsUY8MNhoeGER6ywpDGEWkcYL2l3e7ikTTqDXSckudVpJv1VqVJiHeO8y/5Ll++4BLuv28tLzvmMN72hqMZadZYt3WKoSSikYYI4bHO4pxntFEjK0sksGWmC8LTSCKGGzW6WdVzxHuCQFNPU7a1Mq66YSUrlixi3112IDeCwjiSKCAOQ3JrsMaSxiFSQC8vyEtDPYkIgwCEYN2WbUy0ulWluGgBWN8y1u6kx5+29Q8CK5u4XUShP13g31fdEVdZqmZ9VTzCt7yvbBfWDDqVg/8PtEYKKIylLAu0HrgWPMhqPwAmWx1avYzt5o0iBLQ7HaQKGG7U6PVzZro9aklMEoUYY5lqd6inEfW0wUwhyFzKeV//Hhd8+WJMkTM6MsRRRzyHU056PYuXLweXQ9bDe1m5IR418TZr/ajSZHVeItCgNTfccCPvfd8/cMftq3jfu/6Kd5xyEsJJhPfEicKXOQ+s3UBZGjr9jF1WLK1svGFKWXpGhppY52jNbMO5nCBISGsNnK8ay9PT26jHCq0c0VCDe1et5l3v/wSr7rqHQw7Yg7ed+GIazYQk0kjhmZhus3C0yWS7w7yhOlpIMlMNk3rvKayl1e2xaLRJksSUpaEwVaU5VE9QScpdq9dz2+oNHLTXriwYG6GbWYbqdTxuLqNoKRlKYya7ffp5Tj2OaaYxUita7S6tfsZkq8OKRQtpNOoUhcELYaSQ+wbjT7vzDwLLzdyRem//2Tr7GqVEJR3M3hDv5vpb1lqUrFRt5xzGVt8e6xzWllXodVVFWTqLdY6iLEmikKIsKY0liSL6RY6WiiQKaXWzKo1mBWkcIYSg1e3RSBPCQFEUJe1ehtYSKSVjY9uxrQu/vvNhLrrsKq792TVs3bCep+y5B8cfezTvfOvr0LGGog9FFRkRejDQMWhmSwlxyuaNazntjHP59mXf55kHPZVzzv4QI2kdIQRKCmSgWbt+E+u2TqGV5ik7bo/3jtJrECGNWjr3Rcv6faJAEEUpXmhKU9LptMD10UIwNNpgatsU53zxQi6++HuMNGu86ZVH8NxD9sI6Rz8vGKknIDxTnS6NOMI6x5LxEba2O9SjkH5haPf6xFHIcC2lHEQy72B0KEHKkIe2THL97Q+gg4BD9tuDJEpBKMIgwLuq0gu1xAmQQmAcZHnOcC0lChWdXs4DGydQWrLT4kWEYQB4enmJVgFK60xLtZcYfepcY//fT4XtOxZ47y8ytnyO845AqUFaeWzd5T0457HWoHVlNZ7t9RWmxFqLFoIw0OAtzlmMqx6dddV+AFKwbbqFlII0jrG2ah3lpak4WBiQl4Y8L4mCAOtd5WQMNe1OjzQMEEpTqw8j41G2tix33vMQ//wvX+G6n19L3utx4MEH8K63/zUvOvrZIA3kPXw/x3lQaYy3hk/+09e45JIrqaUJp5/+fg7e9ylYU6IlyCgi63S58/61rN86wSH77sZIPSIrHZM9GG6OkkYB1jnyokQHARIItMY6z7aZKUJhibRDB5JASy797tWcfuZ5TG6b5pUvOZy3vvZIWv0+SRSQBIpOliGoZIuRRlqJnQMdqTSW0XrKZKtDHISAzjIAACAASURBVEU00ph2N0MHkpGhIZy1PLx1hgc3TtLulywYG2aPFctAVL0/Y6seZRQo4jBgutMDKTHWooSkkUZ0+hkbt01iSk+znrJs0Tys9RTWEQbhoHADKVUx3W7vv2DH5638w8DqrNzDO/dNcHu4gfA5+xiFlZUY92iAeaxzOKrnaKWQQtDN+oDAWwMCokASKoVzZcUTrEMO+o3GuOo9nCXUwaCqHJTlHpSqelmFMQSBIlKa0list1jrwEMYhnRzQVwfpjE0jw0TPS781+/y/at+zO233kqSxBxzzFG87uXHcPChBwKG22+5mXe+5ww2rt/Me//PW3jlK15CaEqkUhAoeq0WazZuZe2mraxYNMYuS4bxzjDVLiEZZ6gxghDQ6WUEOiIIqs0zOp0eWnranSkiJUgjQdQMuekXt/CRT57P6nvXsN2CUT75wROpDyUsHK4z0+2hlWLL9AzzhurEgcZ6R6Q1rX6BEJ5AaTr9Ps1aghSKMNR4V1lthNTcvno9D22ZZt7oCPNG6iwcHWGkOURZWtp5SSAFWmtmbVBbZzpEUUAjqVKewnPv2g14L1g4OsxQI0VITVGUlNYRhSEgaPUymmmKE9iZTu/5i3Z63k//mIh1mPf+G967BbOuFO89ZWlBSKyzRIFGycFABB4zkBuMMwgvUFrhvCcrSpSUSAHGWEpToqWglkS0Oy28t0RhZerzzhFpQaefUZqqx9XLs4o4enB42t0+o8MN2u0ezVpakVcx0NS9p5EkGOvoFgYnIuL6fOKkwZ33reOrF32L73z7Cqampthx+VLG541y4w03c+xLj+Qz5/wtdecqPhaH9LpdbrnzPvKyZNHYMEsXLaBRTyn6Pbp5SRhESKUqK1GQInVEHEYYU7J1aoKhNCGQll5vhuH5TdqbNvHxz17Mv172I+aPNHjjK17AQQfsShxWPCkMJL1+ThgoYl1JBOsmZwi0Iho0/BECayxaKRq1mF5WMtasYa3gprsf5oZVa1g8NszB++7CwtFhMuOJgggB9PIcpSS1KKLVz/Aeprt9Rhs16kmMHTgu7npwA800ZvsF4zjvKY3HCYnWCucFxji0lOgwINCaXl6WSukTagsP+vYfA6xjga9472qVTXbgPBCSsqzmBZ2vKq4o0Ii56ZzKuGetH+geAjlwQjpn6fSrvZnyIifSikhrtBaVYa3IsNagRNU2isMIvMP5qgqanQzBOYaaDeygd5kXljAMmGq1GW7WKv1KCpT3hKHCekm75xC6wfjiJaBrvPglr+WKK3+AVooFCxfywqOey9teewR77rMCpGTlXeu5aeUD7L/nzuy1y3KEFJT9qo9nnENIgZodOAhqJEkNaw151sPkPWqJQniD8DlaWb79wxs4/eyv0Zqa4ajD9+f1L3suQaQZrkWkUcjW6RbGeuJQUhrPcD0hN4a8yBlt1Il0wHSvj/cwVEvpZjlRoEnTmI3bOlxx/R2kccRh++/O0vnz2TLTRQhJEGgCLXGlpZZG5GWJFJJ2VpCGGoRDK0lRZIBg47ZpnJfsvGQ+xoGSGqklM52cvLTU4gilQ7TWcxpgGIS5R7wqGD/gW7Pw+X37Y42Dj+dcmt4PSO8g5AqBc57cOPp5RcaFoCq6vEcpsFZUXMqVSKlQSjFUS7HOEWqNda6qRLzEO0cSxhib4wwkkSY3BokgDhTOCbCGOAkw3tNut0iTCIEkiSTCO0YbMd5XOtbMTJfRRgNjQIqSec2IyfZW7ln5MEvmL2CkEbPXPnty/udO45JvXsnVP72Biy76FjvttD2vf9Ux7H/A3hz7gmfQHB/Ct3uUrhqDCrVGeUdmCryFWhyjAkWeTdJuTZFGAXEoCUQOAaxevZYPnn4B1153M7usWMQ5Z72DJI2J44A4UBRlwZapaYZqKd5X2WC0GTHZ7lJPYrYfH6M0hpksp5eXjDVq9PKSKIjw0nPvukm+/4s7OPLg/dhhySJKY2nnjjROkQoipRB4WkXJ+m3TBDog1AolQFCicQgHgbSs2zaDEJKl85rkxiBEVSi5ouqahEFIoBTlYL5QysoUMNPtIQZbMf8xwFoAqDnZR4g5HiVFNfaltSYJFaWtKgsQeOeIo6pqkBIYmPu99xRFZaURQKAV0glKa6qek5D0couWAqU0pTFIoXHO0istgaRqwAmBsJZ6LSEvzJyb0lWox1mLkBU3sNbR7WcIIWn3DWEQMlr34HO63Ta9fka7s4nXnHAo73/bcTy0aYbPfOGb/N3H/5ms2+VZhz6Nj3zgrzn4wF0JXDUY4m1BLy8IdUgYKvrdzZipHt47mkmINT2CeoOJjVs58wuXcel3f04k4EPvfBkveNY+bJycRpmSsTDGuUrJlkojhSSJNTPtHlIImmlCM43pFrNtMUugNc4LpFRIrUnihBtW3sGLDjuI7eaPs2WmUwEUUKLy3VpvMcaRW89QLWWolpDlPbJ+H6zACsjLkq0zHXQQMtqoV9nGmWr7IxxaBngPeVmggxqxVPTyksIakihCCiGGhxqPAc/vBlb7nhDEEj/QqaASEKUUSKphCo8gL4qKqA60IDdIEeVAmNSq8mgJX204oZTEeoexDqisJM0kIi+yKjUGEWVZUnpDqCSlrT7UzBR4Jwh0JVGEQQjeEUcah6umdaHiKs5TWksnKwl0xQGdkCgBWmvCQBM1UqamW9TqdfbZdQW3rbyXjVunmD86youPOpgP/p/XcvXPbuFz/3IJRx9/Cs1mnVec8ELe9lfHsXjRMHVrsM7Qaxu6vYyheh2lLCoIwHm+cvHVnP6ZC6HIOOSpu/PWNxzFaCOlKHMakWb7haOESjLR6pFnBYGU9I2hJiMWj40MGvsC52Z7AJJQSeppQpzUmGpnTLQKbr5pNbvvsAM7LtmOrTMthhu1QXspwbrKFOC8xAGjjYSp6WnWbFjPWD3EWocb+OWDMKCWJjSThF5uGB9qYDyU1g0scR5rq8IK5+iXlulOl0Xjo3Pj985Yrx4Fod8NLGGbeL/skVbIQDx8VBdNCI9WAmcNQgikF2itEKIyrXkPFoVwvtJ/BmFTiQAnLUVZIoVHWUskIUoHFysFRelwsgKKMYYk0Hgqa7QQ1UZhQoiqnSErDlEYQzcrCFXlRA3DkEBLkjAcbHYjqnaTF7iiwFpLs1EjiQLqsUIFCdaWzBtJKfptdt91EZd//XRuX/UQV/zb9Vxy+Q/54pcvZccdl/FXrzmW17z8KEKZEYUhKo4Bx9U/v5EvfvU73HTjbSyaN8pHPvQ6xscaIDzdXp+x4ZR0uEmsQzZMTiOlrAZBcYw3atU4vKmcuVIKullOZi0ikqRpnW3tnFV33ctku+oz7rf7Luy4aB7bWi0aSUSoFCqOmGp36ReGkXrK5skZulmXXrfLUE0TS0ctUniv0EFaOUuNw1hPFATEURVJ21lB6TyRDpHSkZeOkXqNflHx3EXjI0SBqpxG3nk/a1mahdDvJO/tu3b3vvwW+N0FA7P/bOSaNd75yjHgBz1CADfgYUoJpFCUZYkQEqUkQgzU9oHNGOFxrqTIukTBQCMbHN57R6vTRSpJFFS8ppv1q00phKBfGPKiQEpJHAaVUCpEtR+J9/SLovI3WUcSxSBAqmo/zSgMCesxz3j+OzAq4ZzT30ISOGbafaIwIqkltNsZ3X5OLU1p1uskScLdD27kvvvXcfn3fsLqex+kliS88Kjn8dYTj6Uspjj/ku9z7TU3s3HdRt7ztuN58V8cyEyrRTqo+MaadWpxyGSny3QvwxlHEmuk1CwcbhJpxUy/Tyg1pfO0ej3SNCGNE+5bu5UN2zqEQcxQs8H2C+eRxiECT1FalBJEOqB0lslWlzgMMaZqOd1+333ssGCIQAvGh2pYC6W19PKCKKyGJSrHKAgpyDKLDnSlIcYJQRhgfXU/q/srqceVNz8vLVWyEEVRlK8aXX74pb8/YuEXCiHmMZgEmS3lZyebra1SnmTgHB7wJpzFOIc1AhUqgqBqZjpbVGlSCJSqdBK8Q+GIAlWFWDzeVs/RSjLcrFGUJcY6OllOXjqEtIP9MDVRrbJxmNJUEoj3c5VaqKsiwTlPlhd0swwhBfUkxLkSfESW5Ywtms9Qo0G7PUmjVmPhWJN1W6exrmTZ4vkIqckNrF4/idIhL3rBITzr4L2wpuT7V9/Alf92PV+/8JvEoaKRxhz5nKfzso++BY9lcrrN0nlDeCfQqupnT7S7bJ1qs2C0ST2JSJMYaxyBFOSFwRrHlKmsSEsWLGDtlhl+teoBpID9d9+RRpricXT7OUVhiKOIMFAIIDd98sIQBZI00qyZ3MLaTZvYe/lC5o/UKEyJ8JJ+kVOYai+HQCmkkFhvyYoqLYZBiHWOOAhopDHT3QytA2QgScOqV5gVFmcMeWkYqtdx1ouwVnsMlv498r4IaD7aDCdmIxIeh0f6ClBVipxNjQqtq/Q169VSSgIWJT2mtFjjBlyo2ndeCoFQVSSzg+MYZxEWQq0JdaUQp6HGeE9eVpbkSAXYsupfJlFIt19NBXf6lebV6mbU05g0SQgChfOOTj+nNIaGg6I0DI+MMt3NaXcyFozGrFqzmYc3buWAPXchL01lUAwVxhhWbLeAu1avYY8Vi2jWhznhmMMwecZ3Ss+z9t+dw5++CzvtvIQ0EARSIYQjjlPyPMcjaGeGdq9gpNlkfGwMb+EnN6xkn123p5YEdPKCwngaScpws8GNdz3AxHSLg/bckWYS4r0lz6dwzlLTAUkQ4nzGVL+Pd45aFDDRahFoTSIitmzdzDP32J4oVBV1QNHKMrr9PkvGx8nKgry0VQtOVXObVQun2gMrM45+UVCPq+azlwpjLTOdyj+ntaKexNVQrUA5eMyWn78bWFItBh/O+sEZAEoMRNJqO0ELeKSQlQI/y9ycQ6nqW+S9r1yQzla/8UBV1tcszwe2mgDrPVhXDU2qqgrECfygg68EaFn1kcpytlLRFMbMTQcVZfXthcq7bb0nKwp6g3SmdYBzjpG6RilJiZxzVGy/eCFq0TBbt83ghWT/PXchKywT0y3ycoL5Y0PMHwqZPxwz3Urp9Pt0sgwt4YH7HybQglcc/0KWjnt6/T5JGBJoQS2qYayn8ApTVprcwvERgmaTG25cyVlfvJwf/fxmzvzIm3j50YeQErBwJMJLyVe+fw07LJrHs/fbGYHH2pLSGsrZFpdWdPMc5xy2KCruaDWBKBmvh1x3+z08ZYelJGHAVLdfedNLSxhomrWUXl4w0+/P3e5EBYw2ajDYH6NXFGSFoZ6mBErhPPR6GblxhIFmqJ5iXZV9SmtwSGmtSx8NpscB6+xzzpEvPWrfJc16QiAh1oogrEh4NX9QSQpCVNwqtyWh1JXnSA5G3gcah/fVDnMITd6vdpwLRDV1C4KyrNomQlRtGynlYNcUgfAe4xyZsSgpUVIS69m9IBTWzaZlT2lKYiEH5XBQOR+jCA9MTE+jdYAOdGU2LiXpcB2859pf3Mw7/uYs9t9nR57xtL3YZYel3LxyNc00ZcXi+bT6Bd12m6WL5/Pg2nVIbwlVyLrNExx+4J7MG2mwZksbY0ump3uMDNVRsuqzFaVjptcHDwtGm6T1lDUPb+F97zmXW2+9m8ltM0ghaHf6pCNDkBdMbJ3i8mtuZvmiMZ61zwo6/RxH5XGrRRFJGuO9YLLTq4YsvAPhSSNJqDzzh4a5bfUGFo6PUUsiWv0cax1JNNCfnKUwnsLm5EXJguE6Suqqn+mhl/XRutIJR5pN8IJ2VgxsNSHNWoxWFbfyXpAbi9IKJSWB0unvjVhHPv/AxoLxxvKp6WlmyoKiLJg3XGe4XqvSlq+cAFL4uSRpbbWds8fMRSspK6P+bOQKoxBnSnoDEu4ZEH1Z+bGsqXbsrUTzanC1AlTl/DTO44TA2WoyJwljKm8yQOXADHRAaastf2Yr0UY9BV/t7VRaQV4WiFaHpdstIBkq6bcN//bTlXzju9eyfNEoT9lzFw45cC/CJGZBGrK+zNiwdStlWTBvpIm1GdvNG2JiYhtFWeId5FmfPfZYQreXAZ4st/SLgrFGSnO0ycaNE5x62pf43g9/SRqFvO7453LMC5/JYcf8H8ZHGnR7PX5+7a1s2DbD03Zfzr47LSHLC/KyIuCNOEEpSVYa1GDKOy9ypPAEwlMLA6Ik4f51W2j1DXvvMJ/CWOpJUvngjK3aNQwoQD1hfCgdFGSyApy1lZNEaYSpJoq8g8wYhtKEOIyqSau8xDhPFIWEUqFUQJYXIFXyaGQ9Dlgrlo6NCFMuWzg2isfQ6+dsnNjGtuk288eGibQmDKoOufCeQEkK/8hJB77SPOI4qqw2TiKkG0yDaGoyAe8GG9PLSreyBu88oa5+nYaScrCfpphT/fWsOKg83lUflJR+rpYMoxDtPIGv3AS5NWAgUIowCnCukkzCJKG0jm999aP86tbVXHn1jfzg6usZHxvFmYjrf3kvP7l+JSuWjHPEcw5gyYJhViyZhxSC2+55kJ2XzqcoSiamSjZPzJD1+wzVa5S2KsOlrCrZ8fEF3Pvgek75h/O48uobiQLN/2XszePtvMr73u9a77znfSbNkm15nm1sgw2OYwhhMCQEUqCkUCAkpJSbJmlL2ty2IbltSW97W9pwSXJvQpoEEggphJYwBDDUxhiMsY3BGA+yLMmSLJ1xz++01rp/PGsfyWDTez72x7Kko7N19nqf9Ty/5zf80t97BW97/UspTc2eHcvEUcg3Hz5Mf6lDuxHz1utfgA4Vg8mUOAhoJjFRGFJbR1GLEW1Zl4wnE3YttlE4AqUJlGJ1c8RDR1a57Lw9ZHFMU2lGsylBGKEDzeZkRitN2NXrADKIWefpTc6JOl1HTHKZ5C2OOAhZbAtlqDSGorYEeIDW3zpbozHNRkYQRD+6YpVFvmRNtYSTBXC71aTdaWHKkhOn1oniCGvn4CMsdFqeEiO9kNKyypnOZoSB0EOoxXjCOet9r8QkzDkFtUEjPgvOg5gW4bEb5wi2GaDaDwKAC6nrktrMJ00hDepAoZVGG4e28nNlWREEIbUF5xRZFBOFUi2ff/UFXHvVQf7Zr7yRu+75Hp/6zFe542Nf4cd+7IU4E/JfP/ZlynzCFZft58ZrL+YlL7iCZhryxPGnWeo0CAKonUOHETpI6HczklbK9x8/ypt/9f18/d6H0Dj+0S++njf+zK2EWhbysimQ/+5Z6vDKF12BKStmsxxVK7IowhdqrBXlubGi6FEKlroZkZ/Gi6rGEvDIU+sc2LHEQrvJpKwwtfTEo9GELIlY8QILv6knrwxOKYrK0W42KcqKvJqgtKbXagJyxRmgqK1/MB1plpFXllleYRWkceypQbZVbzytwoWd7lkPVruZdeo6yPK8YDTLGU+naK3otJrs2bnMrCiYFQGT2YzBZMqsrNm12EMjqx6UIww0zSxmWuSYEqIgZjqZkkRKuE1+qaiUIktTUMK9Et5XSFEUAhIqJW+cF0FoJwcHJTo968DUFVUtYEgURZjaCr0mUN7qJ6IyTvwOUNgCYQfEEUkckSlNmsBNN1zGjc+7mP/wm+/gU5+5iy/deT9bTz3F8o4Vjh4bcc99n+Ojn7qLV9x6LW969Qup6oq6luq6d+cO0pUWk9UhP/8P3sd//8wdtJoZv/auN/Lut/0Mp1fXUcBoklPbnJVOhnYCLL/wmgtxdc1kMiPUWhihgHUGjbA5FIba1Gjl6DdTCDSmMjzx9CalseSlo99pcd6uJcazHOMsgQqY5BW9VoMsDn2P5TBWbMwqo0jTlEQZhuMpxkosSiOVcKa8KtE6EIZJLFSgyjhmRc2sKOi0WoRhSBAEGJmyO82dLsKntf7wVGhdHKhAt7KEJNQYLwDYHI7pd1qEQchiN2Ox12FWlGxsbbG6OaDbTEkiTV3XRIHQaZuJMB5xTkBQByiNdbIqEBxMKlicpNKPWUcjTXFG0PkojnBKo3W4baw6r2BiixWAElFoWbszvPlIiy4wDAmVIwhCMqWpaoONDMY6aguRnzh7nQ6urpnlE15z2/N5xU9cQ1lUfOXu7/K5L97DLHCoWvNf/+puPv7Z+3jDq15EbTXdTpswjvknv/6f+IM/+gStZoNf/Ydv5J+8641MRjO+/8RRQg3tNKQoxyx1GjTjkCjQMtVVMl034sh/+60HdIShuTWc0GtlgKXXbHByc8ypzSFFZYiihB39Lmk/xDnL6a0h7WYmQiUFuxY7hFpTOycrrjhmWlXCvc9SalOTlzlxFNNqNFFKMytraofoDIOA0BsRT/KCLEmJwoDWfGGOYzCasjYck2VZ5zt33xm94KbXl/BsyPv0sVfi7Idxpg9Cc1VKUxnD5nBEGMpCstdpynVmDKsbm2xsbbLSb7M+HMldvtzHw/NesSBwgXHOL1+VJE05O8/D2270RfNgMTjq2hCF8bZoK1DKCyC0fyNkZaSQBbkTRqMwMbR4ojoUxkgl00qjQ6H+1MYIbIF4TWWJuAkrZ7A4yrJAI8LRjdGUT3/5AT7/ua9z7OQ6Udbm2NFjbK6vE4UB7VbGS265jt/5zX9IWRQEODZGQ0IUYWCoqoKd/ZZc+0rR7TZZvvqtfPwP/ik//oLLqKe5pyUpZlXBJC8ZzUp6jZhuu8mjx07z6LFTLPW6RGHENQf3EvrG/Km1TVqtlABFGkgrEXmDvNooLKA8SRIj1HCtHTNPN+o0faaOdeSlSPcCFVA5S17WYhQSRyRJxqwoOHJylShOGExnZHFEq9Gk2+l80Rn9+u7eGzaftWKdkUP5S97rBuMwZKnXBSVf/MTpdXqtJs0sZmWhS7+VMJlOWep2GIzHHD7xtGzKa/EICLQmikMCYzBOgZMQRpBNehiEfmUgTIUwCAgVuED5Rl17dF2qoVIGa+fXqheXar396q0FW9WeRyZbeuu1h7aSazuJIhSIuHM2YzTOZVuPItCQRDEgDIQss7zuZdfx86+9mUOnB3z2S9/ive99gCAI+K33/ipv+akbqa2hmBUMxzMC5Yi1ItA1uJo9ix0qI8vbxU6LtU2hYrcasUjWMLKqqg3WWQKg30iZFAUPPPYoQRhx3SXnstzuYrGMy4rJYCTTc6DpZRl2viVx4hAzKSthe9qaNAwoqhJbW/KqpN1s0opi4ijydGOp4mkUobViVhbMqop+s0kUJ6wPJjz4+HHQinajQRyGnLOywkKv7cW3NovbzWh+jv6XeYVaKZxSWC/6NNaSxTG7VxYZDkesbs2oq4osVix2m4CjmQTezcQwyUvyWujH7UZKI0mIAsd0lm9TaExdYQJLEIiKR2tPKnSOKFDbh9xY8edU/gq1snon1JwhGvrfq7VH/ZVUK6woUawTOonS3gdVQVGIvKkymqKs5AEzNa1GTF2Ls04ax0RBisJx8a5FLn7HK/n6V+/j1DTgF9/0WurxSTZGOaEWVkczTRhOBvSzBKVCnt4Y0GmlLLQz2o2QzXFBUZQsLiwwGU8ZzWTV0m6kNKOYrJlx+Oga33z0KJedu4cL9uygrCtqYDIT6k4YKBY7TUKl0YgIorAOpQNCrWglEcbWzPIZpg6w1hDoiE6zLdoBa8mLSlY2Tsk+1Rpmo5w0S+g1Mqq65v7HjrM+GrN3aYFz9uyilWWUVib9sqqYljXWuriclMHO1nMcLOWriVw9GuUdXZSTyhUoRV3mhFHAQkcowFOf2rm6MWS53yZOEuIYrDFkceTpGYb1wYhBMKHTSsmimCAUAzcz7zesIdQy/ZVl5SEN3495AFb5BaU9iwZtnEX7a07WAEqmKmRxoFBEoUYZ66m9TkxdowBTlJhKzGTjICJuhEzzHKcDZpUBI0wKZy2VqcXg1VlChOioUCjlWBuM2BrN2LPQQScB03xCEiqG0xnGVGRpSCuLCaKILz9wmN/8j5+g1eoSpB2m+ZAkCskSweHiKObBR09w5NQGr7rpKhpJwrQomZY1UDOazVjoNMnimEBpZkUNQYAFGmlMgKKsS6YzeZ9Ek1nRajbEcts68qoiDEKSWEStpa2o6po4CKQlQPqqsnZ899Axbrv5eexYXmQ2K5lVFUVVszmcMJzMWB9NOXfvTpVFyTbF4X9Rsc6iQijv9+IMUShMAeP7m04joTYBeVFzanMgdJUoIksjsjAEJ+ZhmZ8sJtMZW2ZCFEYstBuSh1eLDZIQ9kXkaqwhDsSYzForfZdzaCv4jTpLIGutI68L0TJq7R8CYVUEfoUeB5IBEzZj/vSjn+Xehx7n1ltv5WU//gLiDKgmmLIgTeSbbWpxInbOoMKQshKpVRwGhHGA0lBWJZPplCjU7F1uY0xJXkyIcCicvLHNiH6vy1fu/j7/+nf/G488cZLdKwvc8vxLydyIdiNjVomR4Nak5LHj6+DgZddfRhQGbI4mDGcFDkczTdjR65ClKbVxDDzVu+UdfYqqQFlLXpZkSYpFJsEoimUL4jw+CIQ4yrpmlJdEQSAETaWorWI6K3HAYqfHJefuJQwjhp45cWpzyOrWiFObAw7s2sE1F+5kod+jKMz/34N11se8qUaBUv7k2+3UKOsszUaM8nz18SynKEviOCSNRLiaJBEJ0lcMJzMBGgdj+u0GaRIROC0VwRgcyI7MCYwQ+gOGk1W1U8ovsgXn0ggYWntgNAgCnBJ34UjP00ONVN804wN/8DEefOhxvvSlb/CvO32uv+5afuxF1/DCaw5yYHefKh9hq5I41DjZUhGHgbgYerbqfNBwtqIRy/U9KSoi7WjEUnmTNOa+7x7mP/7xn/LVu79LK435z7/9D7jt5gsoi5EQJo2srR44dILxrOTqC/azq99mkhec3BQufDONWey00FpTVJZZJUFLzTShEYVsjYfkZUm32UBHmjBsMM6Fo99IUtJA2LWB1kRauGnjMseh6LRSnHWMZmL+YRyEOqDbbhHogDgKOXF6g70ri0zykm8/fpSVfpeXXH8lQRCwORwzGAyZGcvOpR95sBRqtWVw4wAAIABJREFU7qDnex0A5cy2WEIEnNrv7OTf8SSnmSU0GxnO1AzGE7ZG8jS3GzIyh4HyVS7DJTGz2rA+GNJpiEemQ8BULESJLFurPCeOYzTOq4LwV6fdXivNp8QwEEMw/BAgvZg0tdb/PbSpufzScyEMeNvP3caf/Nn/4PbPfJpvf+ub/OZwxhWXXcTf+ekXc+sLLmJnr4WaTXG1n0v95EYUMRiOaWXLZI2U0Sj3e01HMw3ptpvcff9j/NsPfoqHHz2BKQt+6z1v5ZdefxPT0Tp1MfH4U8JwkvPl+x/n2vP3c+CSBWpPtBvlUnXSJCGJIkprsUY2G600QTtDXResFyOq2rHQblEZy3gqkILWofg2GIMpxdO9NoaysozzXFLqHczyUqwPkpgg0MQ+MKAyim8+/ATNLGX38gJpGnHnA4/w/MsuoNeWhXwcJcRhTJamdJN4+wQ9y8Fyz/yxn9S2JehnEwWV8pxzRYDs9SpjoBZ1dK/TEk2aUpxaG4gELHC0s1SenkDRiCOyxUVObw1YH4yJw4Clfoc4CjDG0Ww2qMuKsiqx1vksGeXZl2cEsgrkkLszsvnAL7VFoW28r5clKaSpL2rLS2+9np96xYt4+NEjfPpv7uQvPv45vldO+MCpVf70E0vccsPl/MLf/UkWV3owHUBRbKuAZOmuSaOQY8MBk9Jy6cF9bA0nvOM3PsQX/ucD7Fxa4Jff8Vre9robqYsxp9fWCIPAy9YNDx46yanNMTddcZClXpO8NBS1YVzIji5LRBEzmMxoJTEaQ1EXTPOa0WxKK0lpxAlBqhnPStABtQ3otVPpT22NMbVYeJalbzNCOo0Gpam3IZpuM0PrgDTNmJSWp9aGrA+m7N+xxJ5di6AjPnfnt1jsd4lDxdTTlBqJQEFVbVlf32Kx/aMOlmeGqh/4eYmIw0+IUiHmvHhlnbAWnHDO67qmKOUNjsKApYW2+JTXhtFUjPKtMaRxTJZG7FjoiXFbbdgYjqmM7N2wjuV+h4anzM4nI1vJItTVRhbfCiKfo+fYLqxYZ8X6EPyOK0AFIXUtX3/HUo9DR0+yOZ3xlje/ip9/+0/zt1+4mzvu+jb33vVVjj/2KH/z+Tu5+eYX8LpX3MjzLtoJYQXKDwyxQBIXHtjF1szyf3zgE/zZX32ZOAj4x+/6Of7+a66nERTk1QyLotNqg7OcHkx5+Mmn0YHihVedT6ADNkaek9Vs0tKGZqOBNTV5UZAEEKiawXRCHAnAuthugZNKPMxrZqWVHaKzFFVJVddEWvj+eVkRh5HsAa1ldTwiCgOiMKCZJqRxzLSCBw6doDKOlV6Hay86hyhJ2BhMePDRJ+k0G1y4b6c4NXtlfF7VlLW0HNVZMUY/fLCUrE+eUbiUXI7KS7u25WBwxlAD8QsIdSB+4wi3qjaiEokICEJNGoQkYSRouVNM8pzRNCcKNEkcozSs9LsUpUwphTcC6bQaBEr7LbswR+tKIGZrpCEN5tQdJ5AFTuCMUP/gX1KTpTGbW0Nuv/s77Nm5yDUXn0tZGYbjnNf99E9wy83P4/jJNe655zvc+bUH+PhHPsoXPn8719zwfF790ufzwhsuRKsQrCFoL/K7f/hh/ssffprV1XV+8W2v55f+3q30MkuejyiShMo4WlnGY8dPc2p9RJpE9LstrrzgAINJwdrmhOVeh4VIepppkWOtcNkC5ZjkM6pabDebnvS4NclpJAnokFBb+s2A6WziV0GWaVWRRjGJZ4saZ/zkF9LKIj+Ziz3B0bUhJzbGpEnMVQf3eGcZzaNPnuCBx45w7cXnce4ugTy0FlgmCAPyQqb3RprS63ef+2C5bYT0zMlSZzFJPWZ6ZlJT3r3yB25QQGwEg4CqNtReIhYGsg/DyZjebmRCJMvzbXeUSjmyOCRLxatqmpfMcrkKjRUIwzloZMm2XfUkFw58GFgP+omtpfYK7GeeK401lpXlBU6ubfHI4RP8xE1XcuL0JmkasbouquQrLtrP5Rft56Uvvo7vP/ok937rEe6743Ye+PrXuO6mF3L4+BatVsUVz3s1j37/Uf7BO9/Cv/jVN6DKDVnIE6IizWMn10VYW20QKsUl5+2j32oQhAFHTg/IooA9Sz2accyoyHGlQTuHqUpKUxEFAc00FnsnY5mWNXlpaKYCUJ9cEzp1mgTEWnuquCKNQpqJ8N+3JhM6WYLGEgWKLMkojGNzUnB8Xa7nS8/ZRafZoK4dFsWX7vkulbG85PrLWOx1yfOKqrIYJ/vChk5RGhqJvA/ldEbc/BEVC69wdswNzNzZ5wXn9XCBVzhv9zke61JzM2L/CVEoC+WyVhjjmNmKyC+K/VmlmaVYJ+b1+axgOCtEMKCUlN4w2F69lFXNrKwZzypwoi1spInXLp7hHgUBhCiCswYQbzCKUhpTW37iBVczGE347mNHeOzJEyhlueHKC+i3Wzxx7CRRFPD06hbnnX+AW190DceOn+ZrX3+Ir9x1N088+hhKKX72Z1/N7X/9QajGxLYgSpsMp1NOrQ957MhJDu5bYWW5RTNNKGsjNgNGVjHLvQ5LrQbTqmRaSoXSynm7bks7S0SpXNdMixqlA6IophUFjGdjAm04tbXB7n6XRhyKlKysqaylESeMpzOmZc5iu0kYKBoqobaKI6tDrJfr71/usrjYJZ9VnNoYUhnLfY8codNq8eLrLqKqLVVpmBQFYSDIfBRGOAvNRMx0J5MJ7VbnuSvWM0qX3/HNqcnMK5MXr/7AJ/hNPNtT2HxBJPs7RZaGOAujyRRnFYHVKK389SrOLM5ZGo2UzDkms4LxrCBLQpkqHehAkaiINE4pazHdV1rJOibNZE+mAtIspioNVW1wofaTojjrzak2VW3Ii5wohIVugx+/4VJW1zfY2Bpy5MRpsI6X3ngFV5+/h8pAVVmWFvv87Gtu5cprL+HU6TXOv/hK/vh3f5vNU4eJ44RpXkJe8o2HnsQpuO7Sc1jpd3DO8sjRp2llKYvtjG6rSZYkYIRbLuwFwNYUztJJIs8ccMyKitpBp9mirmE4naCV2ETZWnHujkXiMDhrSgacZVLk1LVhpdsmDBRFBVvjGeujMSsLHRbbbSoLw+mMb3znkPRKCAng4J5lLj1vH7NCSJyVKXHWQuCY5QWNNJVATL+CytL0GT35syDvlnnPNOe4K3dm1HbMfx3mPusy1p/5/UJjN55pqs7YNnr2Z6eZUtW1d5tBGKTWgJcyzU0vWllGq5FIGPk0RyvBkBpJggoUsd914cTOcOJtiSZ5TlbXIn/XocjQfHVVzgl4qRRRHDLNC0aTMYGC5W7G+bvP5/jGFlVpyIuSu+77PnlR0W03aDUzLj53DwrN1RefR6/fRQcBOgh9VQ2xtuThIyfZudDjioO7QMHJ9Q3SOGXfcp+llQVQAW/95X/Pn/z5Z1j93l/SSjTOVjglB7+ZpjgrWr9JWZEmKbEKyMuKrdGYbiMhjWIskX/YpSEvygobhAzzXHzdk5iydqwNZwymOVVlSOOIc3Yuk8Uh9z5ylEkhxsNJFHLu7mUajZROo0VRWcbTkryqcU5jrdgJNNKMzfFouw2KoohACxBt3Rn7oR9RsdjutZwnh+EP0Dzf2TkHykoVm+NbvrkX4NBRmtJ7PcxXxfJHRYHa7o9qK8BlbWqqWpTSSSw8baVlPdPMEvKiwqIYznKiICSOI6JIXFjiKCCOxFCsKCpObQwEQMwaRJFY/dQ+hcxhycuCI0ee4vav3s9tP3Ed/VYDnMWammMn1ji4d4XBaMyOxQ5lbVjstnjiqVXuvPchDu7bxfXXXSESsoUFqrri6KlVNgYzxrMxV1+whyyEWVEQhhGRjsT8Y2WRP/jDv+Ffvu+PaLTbLK0s0oyktQBZilsrjj61dT41Xsx2N0ZbpGHIYislDubWBIL/jKY5nUaMw1LbisV2i2lRc2IyZjgtMNaxd7lHFocorYmDkC/c+zBhFHLh/l0kYcBKv0Ppw0xHkxnjwmCcppUltLKUysqNNKsKojAg0AEqOEM9txZKUzOnkT4ru4F5hcLzpdSZA1Eb53noUrE4+0r016TCHzIcBEgwEOLlEKi5c/Gc/iLmsOBwGqwTXGiS55RKk8QhYRASaE2zIcasVW2YzkryWQ0TJ8lUkSb0fPkkUuzftch0ljMYDSgqQ6uRsNRvbzs///Wnvsz55+3lY5/8Infd8wCL/R4/duNlXHXpQXYv9xlNZyRhwKyoOHf3EsNpwZUX7uO7jx/jE1/4OodPbpBmKZujAQ987xGageXi/X2CoI+rjQ82UqxvDTjv4H6+/b3jvOONv8XhI8d59zvfyNv/zi1c95JfYJyXtLKEZpKSV5WsyZSWiassqesaZQPasXiECkXYbEvx6towLQpaWSSbjSDm8RMbzMqaxV6TxXaDfrvpbxNDHGq+eN8jnN4a8+bbbmI0EupLXlZYpxgVOYNxyb4dS4RhjNZCzdFaUxshY4ZhiNbeFMZUGOvk9gjPHKcfvgq18hqFefc99+gUdqjmzNU3j+iVSmT9VYP/HPncQMmBMqbG1hbj7DYG4pz1PdYZqk6gFNbWtJIQY6Gu5clUCKlPYYi0ottKwEpVMLZkMhH5vVIiT4uDkEYc01hoMitKhtOCY0+fZqnbJA1D7v7bD/LHH/tb/vpTXyHe0aOVBHzt3u/xkY9/iRfdeCUvftHlXHHxAYbDMc7CuXs7PHbkBD9+3aVcev5+4iTj/eMJxWzG1ZdfgNl4krzMwToJsgwjWq02jx/f5Ffe+m/52t33c97Bfdz9md+lGZXc+93vUNY1VWXJOhGTogYnE3NRlUynY3qNhDASNLuylllZePzQYp2YeQQaVnptsjRhVhgePbFBHAYcXOoQejdr5w9hHIbc88hRisrwE9dfhC1r0lCT1wIJDaaCvu9dXhCtZlHjsBSVX9mlGZW1AhcBW6MJjSwlDiNvH3mmy/rhq/DZJPdnfWi/K3NYrD0bx1JnXZP+QCLXofKrHGsMFiirAo1fv2x7sfu713n7WWcJlKcUl5VU0hKSeB6eLTBCFsuBNLWoegvP8arqAutq+UtHiuV+k83hhBOrGyRRwJ4dC7zv1/8+//zdr+cjn/gSX7v3YagNV16wj2PHTvHPf+se9u1a4idffB0333AJG6MxjTSmmUTsWGjR63bptpt0uz0CJd7qVW1pJpp2p8vhY1u859//Cf/tU1+k127yH9/3y7zkhgOcPH2S43nF3pVlFJBXlpqQGonRG49Flt9PIzFGqWtKY0giEZJOy9ITFUuaSYJz0Go0GI6nPP70GvtWFug0UrCWcVHQb2XUxnFifcDhk2skUcSNlx2gkUYi4s1LJkWJtYoszVjqdQDNcJpjnSavCrQKJFhcK5xxlFXFaJaTpjFZmvgAz4q1wYi9vec4WHP44AehH3xFkXdYoQi8ts1hEbBTKeepLsb7VFm/A1LbUn1hAvtVjLMYr+BS/orUnpGA/9xIO8IkwKEkraqucChMXfrDKU/5/IpNQ6mGNnDkVc1kNiOvaqIwYKGdsdBuMC0KVreGDGYzVnpt3vWW23jLz9zCV+/5Hn/+qTsw1vGyF17Jrl0rHD2xwW/8zp8RBppLLjmA/vFQJGXBROzFZ1O0EnOPXqvJeFrxvg98hk9/7i7qMufX/uGb+KU33cpgc53HjpzCWMWl5+5hbWNMGIb0uy3KsqCqcvKipJ8lpJGEVE5LQc8lnkSxPprIHrUWhXAzyzDWcnxti/XhmF1LHW+kIpBFGkY8fmKN9eEE5eCifTvZvaNPlVecHkxIk5jKiiCilTVJkoRpWTMrKoZ5yVKvS0pMp5ExrWRw6HU6YB1LvS6VqRnlU7CKJE5YWOg9d8VSSryvzsZE/ZE78yOlzhwYBRrtpUSe/ahCz2SsPYovkIPyE2J4Futz7lvqTzU6OHOklXM+XEJ6sjQMqb39ThJHVJUhLwpq7zUwh6sUIsBoRBEmtGRxxHg24/jqBq0spdVosH/HMoPxmIcOPcWepS5L/TYvf+kNvOzW67j/wUP85d/cye/90Sd52UtfwNt/9iWMSsPffP5rvP2v/yc3v+BKfuOfvMUHfWtUI0UnLT70yTv4o498lvFwix+/8Sr+zmtu4sCOLg9873G67ZThtOKmKy8giQKOntoQMxMqpnlJGsd04ia1MUzKCmtr0iQmjVJqaykrIzhU4l1lwpCN8YS1wZAwDNm51CWLJGn+6OlNbzgsQ8Cl+3dui3hHwxmDWUEcRqRRQmCh3WpirWVjPAGnKKqanf02WmsqB7OqYjIr6bWaBEpRYRlOJLG11RQdhByY4Oz37geuvtljr3TWfhhX95WPbvvhoqX8xeWpwPrML1or6RDGFCgr2Mwcn3HOMv8ztydJz52y1qJVgPHJF9svU6kzR3q+BFfzIEx5LopK5FGRzzaW0Ewl/dtZL7ysLaNpzniWkyQx/WYDtOLYydOc3hzSa2dces5uecEGRuMZ/++HP8MffuRz7N23g198209x/sEDfOxTX+H22+/h8JETvOyVr+CnX3UrH/n4Z7nnrrs5b/8u3vuet7F3d48njj9NK42YzkqiUCpGWdd865EnmY5n/Npv/D7f+tz/xZ6lLsZKjK41hkYSyy1gIVBaIk5icY+Ow5DhNGfLu9YkYcjuhS5OOTZGM8bTGVprdnRbNNKYOAxEQubJfRvjnF6rBSqk2xSPd2Gv1kRRRBoGomvQilObE3rNltCWoohIBzzt84FaWVPeJa2oraEy7t7S8Zr+rucff/aDNX38ldaaD+NMX/uF9A9upJ1S2wXM4bbdZpxDgpJsJVeV91+QoiMhllpJ8IA6G7JgPn2yHc0RakVdG4Ig9IdzDsrOTyrbu0CUXJPGGkIlVB4LomlE9pfz3ydV0pEXNevDMQD9doM4hCMnVzEO+p0muxb7cootFHXNF27/Fv/t03fy4PcP89a3/jTXX3s5b3vnb1G4iMVeh8H6Ku/5336ON77mFr7x4GOcWt/ionP20kg01ubEPoPmmw89wc6FFtdeuI/rbnsPd37yfezf0ScvhKQYAMZZQGLV6nruWxUymM7YHE4Zzqbs8nu5VpYwnZWc3BqxPhxz1YE99NrCr6qsLNprBVVtGc1q2o0mjTSl9pbn41khBnjNlFkpHhPr4yntRhNQNNIGRV37vW5BlmUCP1SG0greWBtHGIT3Zq32a1Tr0uc+WHVdfVhh+4GHAc5+6n2LNS9ebGPyzlOCnQQlKcQAt65rWVMECqxBOev9L711kZMK5cAndJ1p5sX+W77OXCr2rAfLHxqQQAOtNbUV1Y5CIlTm1U6mULXtlLM2GLMxGhIFIQudBuPpjNPrA1Sg6babrPS7NLMG6ABTw0OPHOHjn7qd7z95km9849voMOG1r7qV97z7tTzyxAlObo4IleLC/bvIy5xmFrGxucHq1gBwrHTbXLh3ERWEXP7iX+abn30/S91MaD+18N2cEjl9HAUEytFKYw4/vc7a1pjlhQ5ZEkqoZWmYeTJgp5Fywe6Vbf98g9pewQzyik7WIE0ScUgsK8azqczyzrLUabI6GAEhLW/40Wk2GeclxggKkCaZxAWjvM+DcOTSKPLaTXuvQ70mXX7ecXgOgDTQ6qyNzhxuOOuQbR9Gt817k5QvSabwGgYvwVcQCCXWKjlOlZPQTNkhnvmjn3lxqW1ZmPOyfZwjCDS18YEGygcvyRMir91PrZFWRIG3jqwlf1mhCbwfqq1F1rTUa7PUb3Po+GmeeGqNTivjvL27KWvL5mTMsdUtNoenOHfvHhb6i1x2+WVcedUVPDUY8vJX/DyXXHoFv/CON/D+D32chcU+N15zEQd27CAvc75z6AShssyKnEvP3cvOfpNOK6O3cxef+PQ3qV3A1MYesNEof21VdUW7kWGMIdaOk5tbPHZilfN3L3Fgpc+J9QGbgymrA8mCvOKc3cRhtJ0/pHTIpKxQQYwKQtppQKeRkVclk9KwPhqx3G0RIMleJzcGNLKURpqKHaenLpWVpdcWKKM0EkY+nk3IsoyFTscHN1km5RTQhMkZlf2PhBtElSPYlVZnFsbzrBz5Z95xyUpnDiuUxhCFSq48D08o5YUZiEmHNaIvnH/ds0N6zzgPCuVX1iXiBugs1DixMULjzq6q7pk/FrKncLmtsRgzh0a8L5c1WOM4uH8n1IZTG0MOnVwjCiV5YbHbZufKHjZGJSefPEkjiSiKnP0HdtHrdTh+eo3f/5NP8KpbruKKSw5SFRWzYsaDjx5C2ZLnXXKeWAdo2LW8wuMnR/zyv/t/uOPLX+U1L7+R/QsNalMxms1oxCGVEasmZw1RIGKMbx86wWXn7WJHp82x05ucWN9isd3i/F3LdLzFdl7JtIwOGM9Kkcpn4rjjQhhMxtSmIosTltsNpnnhVzGKfruFsTArDevDIShNr91ioZOgVMBwOiPwzNxOs0kcRwy9NfhwPKPVymhm8VkF6DkZpEI3qWuv+wMRmvrlcqCecQlur3jmB+/MkrcW8UWgtw+NAu+Y4qiM3UbyjRU6h0jjn9l7CZjqvbhQJCHbfPtKGTHOVdrHspz9Mf+a8hBIKrv0jT/3rv+TG1/0fC659CAvuvogqdKgLTsWu+xY6rE5mjIY52yOckoT4lTIubtXCJVjNpswG24yGE157Wteynt/9e8yXD/OsdMbFHnJdw4/wTk7lzh/935Wt4ZcdM5enjo94u3/4kPcedd9ZCH8zq+/mdfc9nzKWeHzAMVsRYz8YW0wJAk13zt6iov2rrBvxzKPP/k0Tw9GPO/8vWRxzDQvWRvNaGQpgVIYJyZ1YaDoZBmVqdgaTchiWe63khinHONpSW0M3W6bvLRM8pKiNPS7LbI4pt9uUYMPGZB2I04CtBYLycFs5vMWG+L5FcpUqJIfgbyfOV/Wr27Eg90pT/N1oo6eX1OeIeP7JDlq2n+e0iHGSEMuf55It633toqjEAtYYwkjIQYabxAmBeeZ1RM/TDgnbjcaJz4FoewcrWAa24fbN27bBwylZBpNE+7/7uPc9cAhrHXs2beH1/7Ui3nXm19Gq6GhKul3WvRbLay1DCcFpwZDvvfocfbvWmbvjmVop6RJRBqHFEXOfQ8/zurWiOV+k0v27+TcnQtkWUZpNe/+rT/hy3c8QD4Z8ZvveSu/9OafZGN9g7W1TRpJQjuR5jwvS1YHE46vDciyEO0cF+xeYaXf5LEnTzIrS55/0QHJ5hnNpMdJQmIdMilLf91LrJwxFWtbPtUi0igVMCkrZnlJv92iqAyzomZa1iRhwNJiCxVoWo2QSV6wNZrRbTeJ4oAkThlMCspyQtbIyPOSvctLUiSkYaaoDI8cPsqV1172HAfLv39CQ5ZVjbxT8tSHWompqTGeeOapwZ5devaHRjzMnTZywOoah/EgqCyrtXJoP705FVA7cWSJvLFY8ENVyL8Wv3Ka+2fZQJpf6yAMtZ8QA29Ucua6FT1YSJpEvPDmK3ndq1/Cv3n/R3j/+z/E7/3+n3Pzj93Ae//pW9nZDWk0YrS19FqKXm+B8aTB6c0JJ0+fZmewTBJHrG2NePyppzHO8byLz0Grip0LPaZlzb/9/f/Bn338SwTO8cu/8Dre+aYXY6ucrY0tqtqy0G5ijWV9PGH1qRFJFDCc5py3s0+/1eSJk6sM85ytp6aUxrBjoc+sdmgV0EgFFFZaUXkXxUDLgLQxGhLqgH6zgVMw9rmFSimfuiaRc8ZnOncaqdiL5xV57URO1kxpNxJqI+Hxg9GIJI6xxrBvpe/hHPGfP76+xtrWGNVYfO6KVRQ1SeIlTj6tVA6JdNfOQewFFHUtYlFjLNqKAlhWf257YhT9qJZf0xpjJPfGGEnsRMliWnkgNIqEjy6FRksVcj4F4Uw5PfMQ+P/VQOCz+4wVnwacXLHKU5ad9hVLyTdvPJnygqv288H3vZO00eWvP3c3H/rwpzl4ycs4/5KLePWrb+FX3/5q9u3qgq1oNVOUhWFeMtwaUvqMv307V0jJaWYBK/0F/ujjX+Z9H/gEGsVb3/ByfuXtL0fVBZPpmGaSyIQbhhx9ep2jaxus9FrsXmyTxjFLdUmoFEdOr1OUFXtW+hgrZMc4DEnCgNpY8qpmagzNNBX5nTHMqop2GsviOoTKP1OpXzJHQcioKGSS09I/GuNYH09wQBxEdBoJWZJSVIZJXjDJa4zT9NoNojgiDmRPqLTiyZOnWB2M2L20xMUH9tLeufe5D9bx1XXyYsbOpR79dia+B/PASz++z8MCwlCh/R08K0oqo9BKhKH4q/NMPy6HLdTioyCWkw6lgu2EBkmxcN5Ly2fxgDTeXmGzbUn5LB9zdc48f1kmJPGYss5fm16OniQxx546hfPT52hrjTfcdh0v+7HLsCrjAx/673z+83fz0Y98mquvvYxffPOrufm681jc2adZ1Rgt/mBJGNGIA87Z1eM7jz7FK9/8XlZXB7z2Vbfyz9/1M6x0NU+vDYiThMVWA+tgOM2577EjdJspFx/YwWK7wenNEeujCVhHoCBJEs7btyBxMmlEGkXyPa5qJmVJM0npNlKcc0yrgkBBM41AIah6EhF4fG9SiK+9cNwSn3sIm6Mpo2lBGocsdtsyYeuQ4XRGUVpCn/LVThOaaeoZFfJerG8NefLkaa696AI63Rautmwcf5KFfXuf/WDtXlliazBgOis5fnqNbiNh9/ICdV2TxJFgSNb6Rhpfl+Y8dEtla6wTs/8oDAnmGczqDNY6h6JU6EHPQCqYk+0PgZu7Lc9r01lQgrVn9IFKqpLi7AN85mN+AwaBGIgp59dV/puThiGnNyc8vT4kiwNwNVmkWBus8o/e/lL+8Tt/hs/f9RBfuv3r/Nq//L+Jo5Bbb7mOd73lFVxxw4UkUcgsz9koat709/4Fd9x1P6973av47EfeQTMqMabi9MDQabeIQ8GPTm2OefjJE+zd0eeSAzs5sb7B6taIsqpLfpyjAAAgAElEQVRZ6bYpjdu2FE/jhCSK2RiOqWvRDLSzjH4cEWthgQwnUxyOdqNJWdcMZ2LF2Ywi8rpiVlY0kwSF3CgWxSAvmOUF7SylvdAmCkPGRUXtNI1MMnOsMmit6DUbOCXoujGGIIwIw5iHDx/j3F07aTUS8mkOSlOeNZ3/0MFK05id0QJVLeDeYDji6bVNmQg96W7nUh8daWGEelYoSiCFOFDeLUZj/WZehKrS74hkfj7pya+BjONOySEpawnL1L6Ua9/0C1IqkjBB17VXZIsroN7+i6ntwzj//8CvouS0WdrtJifXB5xaG7JnxyJprCnKmvXhjDhqSMiBmfDyGw/yvEv3MMw1d379Ie644xvc9nf/GZddegEnTm5w+Ojn+eiHP8qll1/MA3d+lMsuXmK0uspkamg1YrIkIEsSHnziGCdWh6Sx5vrLzqXTSHn0qVMESnFw9wqTogKlSLSj38pwzjGaTpmWRuTvcUQWx4RarAi2xiPw2snKWkazKVEQ0W9JRvTqcIxSiqqsiRoNiferDOM8p99skjQbMs1pzaSyrA9nrCwugHFMi5IsTUijSAh+zqLREmAehdSVbC6W+h3yoqSsDWmSstw/E9P0w+wGr2yOwpB+r023kbE+GEiJjULWNgacXF3HeIOMhU5D3jSPGSnUNt+9chDpkLl3VV5VWCeemQJ2BiifNY3noiuliOPQo+ayEjJWqtocA1OBJgoU1u8qtQ4EQNXz1y+TqXrGQZuXTUCJT0GjlTGcTrj/4UPs37XEnh2LbI5yqnrCJefuZjLN0RoW2xF7lkP2LFzFddech3MJf/oXn+LQoSMsLi1y5xf+lMsvWGa89jQbJ0+jlKKRRpRVzeFTaxw6tkYzTXjexQdopjGjyYzN0YhL9u+irA1bM8kHSgN5wOraCJMh0CRhQLeZYWorDXZVk1clQaBxtXhDuFqss4MwYGsyBaSdCJQmTWKmRcXmZEI7y1hpt9GBwvrY4o1xTitL2bnY5/RgRKuZEYTy/ZzYCuMQ4FSHKC1mt0+d3mT3cp8o0OggwKLJyxLibHsN/awqHeUhBlXX6ACWFzqAw9aG7r6dbAyGTGYWYwxHTq6yc6lHEkq9CHwTDrKrE/77XEyRMJ1N0YEmVAF1Zba1hOJ1Nf/6eDjDbmcdFt44VqjK/kApva0mCpTPRPSIv7GegqPPgl09ERCg3Wxgw4jdyz26zYzVjRGHj53iyosOcPzUBqfWBkRRwDQv2LOywDSvqcsZV5/TwqqI//yv3sTpo4d4xctfxeWX7GN0/ElqpckabfJ8Ql6WfOfQU1TGcOXBPSwudLHWsTEYsGdHn7WNKX/66a9z0QX7eP5lB3F1jTGlBAmUNa00ksbcWYaTqcDAPv+xEQt4Oy4LmmFAGjWojWFrOKO2lsV2U9I8TE1dGMIwYKnTohEnlKYmzy06FHFImiRkcczWZEYrS5F5SxJdk0hWOHP6t1IB3z98jCDQXLx/L7Ux5FVFbWS4SKNte6xnw7E8qLiNA52BHnSgcdaw0G2y0GthTcVwFnJqY5NmEhPHIb1OE1NWnlngY0gUaCeTXyPLtv3dq8owmhUEoRb/zSjy7NT515fDpUCEqv4lyaERXWMg5XK72mmtUU4WubWz3pZJXoea7x2NIctivvv4MfJZyXK/LSTBquKr932P2jguO28/SRzy1Ol1vvndx7jxqotpNyO2xjknV49z2y3XgZLUUjOZ4ZRDY8FWBEHAZ77+HXb22tx0xYVih21qlrpN9FKXT33xft79v/8eTz3xJGuP/jUBjkE+80ELin6rQRiGbIzGBMqRhIFvG5SsVsqCOIpZ6rRwODYnM0IFWeoFHc4xK2uiUJElIdZBlkQY6xiXhkaSyqMfwOrmgA0tudzdZoMwCGkksQxfWhOGIcNJwWCaszGaEIchB3btYFoWlGXFYrcHSgxb6jwnfC5doXM+dMkJp0kgrGfuCuW6MSgFvXaGxpEXFXlZceT4KZb7HQKtSOIzfOk53B9ohU6EBerCgABp3JVSVHVNVdcyIns5kXPeJM03/4JCSC9mrEj55zIpWdXIYKGVMEqdc1hjcFZGcnDESUqv22ZWVNz70BPcdO3FTPKcXqvBvh1LPHV6g28/cginFAudJtdfcT7djpDqrDNccGA3g/EUUMzyGWhLI7SMC8uwmPHN7x1lod3g+kvPJS8rlvstiGL+8tN38zsf/CSHHn2Cq664iNNPHWehFbIxGklgZSgTa2Us02KKVpY0lFXK2mgm2ktj6fqeaZzngk1FIY04JK9r1rYG9JoNjKnpNBqSKY3m9GBKFErSvUHM5JxyXrcZ0s5SoigkDjyfHcdgMqNy8OTJNZZ7fXrNFisLXW+RlBFFMU4pyrIErUjiH7ErnJvNWie9TyiJij9A+pNDZn1+XaeZ+nznMc5GnNwYECAZN8s9sd5xyI4PPH1Lg9aS5mVdKHs8KxTcoqoYDEckUUwYBdRVRZIk2wJZrb0jcjiPVpGHYb5tNFi/HUDQ/jn9R2scFlfVXHfVBXz2S9/gdz/wF/z5ziV27lrhludfzguuvohdO/qEgaYqKo6cWuexI09z4tQGva6EKCz3xX+1zHMacUxd1Tx8+CSnhlOGk4Irz9vL+XtXCEJFbeCO+5/k3/znv+SBBx/h3AO7+MaXPoiZDLnmJfcxy3OacegfLLMNHYRKvCamZUFdi7tMFGqCKER5DDHUAVkivdzmZIZxllYWk0aa3UtdpnlNaSSbaKHTxiFgKQrKuqbXaLLYhmaa+L2wYW0wwRIwmBaAuATuWl7AWVjudrDWkiZyZZZVSagDwlAkcEr/iKlQgQu0dlqFWFNTVdVZ180zf6fyOIK10kb32i16bak8W6MJJ9Y2KWrxhO81G0RRuC29mDc+sgME5Z385pGwrSyTMAGlcV4pUlnRB0r4ok++8Ndm5F+c+JFbHx1str3gnbOEWtQ+tqp542tfwk++4mY+++n/ye/+4Sd58J4HOfToYW7/2re56MJ9vOYlN7B7uc+OuiYIIAlDvvXwYVqNlM2tIZedv4fKwrGTT/O333iQBgUHd+9gqdOkt9gBFXDPA4/z2//l43zt7gfZvdLnQ+//p9x0zT7KMufRk1NAktSSRLM5liV0N43JK1HnTMvSc92DbbaDtZZJXqACTRwq1sdjytKw0M7EdE7JoFRWlqI2ZGGM1jDOc3CaaVFsV7IwhNgGrG0NGM4k8zlNMuI4oZkmNLMM0GRZQm3k+1wbg60KWo0G3bglPa3HK+emMc96sJxzSjmnZLKf9zl40p2nsjjDnEHqV9TCcfCgZhhoFrtNlhc7rG+OOLUxAAvLvTYGKxG0xp1p9v0VZ33FTGOpZKGfTgR5DzC+ga1qcE6u2Cg4A5ZKcT3DepWhQHwylRaqdGAh1BpblvRDxc+99sX83Jtv476vf4c//Mhn+Mpd3+beu+/n6OGT7NuzTL/X5A2vfCFlVRHoc1leaPPlbz7MQ4eOU9c1vW6Xm66+mKQaEkcRca/DE4dO8pv/6c/57BfvpRiP+EfvfhO//s5XMRxsceTEGs1GzHA8RSlFu9VgfWtIK8vA1EyLSg5UENBrNcUiQGufTCG0oUaWoBVsjaac2hxxyb4doh+wFgPklQMlJitlVUn/6R/CxZYkfOEc48mUBw8dY+/OZclTzESQuj6aUBlZ3yVx5LE/yTZSTkmS63w3C9RWBBZZ2nruiuV/blu8LJXBEscxxtZi7DEny21P8WfeXKXmVUhwrm6zSa/ZZG0w5PTWiE6zwdZoSKfZ8JFkanvHuA25KkR8IS8AFcLZ9tvOQWVqlLU4O+/dRLUWyKeAB2aDQJEFkWdMyBVZzSPtkKR7hiOuveI8PvgffoWnN0f85cc+z3/6vb/ijllB1m3z+NFT3HbLlfzkzddw+OjT3HrdJRzYv4Pf/4NPEocBiysLMKyobMS/+ncf5o8/djvldMpb3/AK3vr6W9gaDnjq6VVG3r6602yeWbA7STgry1wS5rUmjYSCHCCMBWvEjyLynP+1zRFRHBEouPzALqx1DPOKvKppZRmjWUm/JcZoIAxU5QztLGU8LRhPxxxfG9BpZRzcvczelUWstYyrmsFkxtQLKazTTEuDw9JqZL6oiKFKZQTRb2UNrPODU3hmr/ssPRaJc/OfV9tvpsL7MWi9vX8zvtGOggDHXJEj6x8hCSpJK1eKHQtdTm0NOb01QHl2aK/dwBnBswI/1bGtTWT7sM1XOEEYUHpANgxinHMSSq7xlQ2Mk2oWhWJaMl+eo2SAmJMY54e4qgUvk2mxYOX/Y+69wy2r6vv/19p979Nuv9P7DAzMMEjvICiigIoCEsVuUEksiRpM+QpJTIyxJhI1iooiKNjoICIwSEeatAFmmMK020/dfe/1+2Ptc+4MouYXjcl+Hh7muXPnnnPu/uy1Puv9eRfP4oPveR0f/MDZ/PTWB/jK137MLdfczv13Pcw1hzzAAWtWcNRBqwnaKrGjE4SgGXz/hge46AtXMTM1w2tecSTnvfUU4sTHDwP6KmUc0yIyMhaODCA0aAURIOl0fJI4oVpySdMMxzSL36dKQo1SlRloS0VN8WM1gil7NqahIvWiLCPLYbBaKYgCEEQBui4o28osxY9Sto1N0miH9JcdVi0YoerZSKksiZphpNwShbJKynJBmueUbVdhVVKFiqZS9qDoqucVJAGFZ5HFv23FEhWBsGbnL7K3VcmiuLQiuyaXAg1NxYtpKhlVdreh7upT/FlKyWhfldBV29LkTIttY5MM9VWpuCqsMU4SqoXUveuaR2F00f0ZXR67zNXcytQtkF1uvSxWJU31ZDLDsnWyrDiEFL+SPTUWGirNLM9Vg69WxAzRSnjVEfvxqmMOYHfT55vfvJabbn2QB+9/nJt+dh8nHL2OIEp5+tmNvOKMj/LYI4+zYsk8PvOJj7FsYT/T9Q5lr4Rnm+yYmu65vTT9ELKEMIgRCGzb7OVYq4hjrQCS1crrmupWdOKkCLLSqXkOSZzhBxG5EFiGRsuP2D0TMVQp0QkChvuq2KaBH8U8vXkH1bLLnL4KK+aOKOKlEIVhWsZ4vUOtUsKxbDpRqpI9DIEjTIQGSZrQiRMMTcOxXQxNn+2tmA2aj7Mc9zcXFsMgzdmy2GPH6wka1JZi6gVvqrghrTDAs7omES8+RiqveNtWgU6jQzWyvEq77fPcC7sxTRVSGUQJuqFM6v12RMWzMUwDmSqTEQl0ifAKClHvUteUjzko413T1kgySRgqXCnJC7fgPU4uCohVvxy1KAoM0RUzKNCWJGXUtfibD57D+847g1tvfZDLrryFH1z1M7Zs3UWew/BQH1/51J9x9GH7sm33FFONjjLlcGzqbeU07HkWaZww3WyyYKjKdKOh+kjPwZ9uE8QprmMVHqGZEuQimG4FlFyLIIqpei6agCBS1pntUA2joyLpw0YxHxYM9yOExnPbx6i3AxaODLBgpB8yRY4UqM/YDCKmmz4j/VWSJCVIMizDYqhaQkpBkqe0/QBd1+kreeoxlCoJTC/mba0oJslySrZLBi9dWFnSMXTkfARC5l2hQ3eY22V00mvmslxJ5BVjQWJoDlmekcRpETgu6B0CACFncQsVeKkhSp5yF7Yt8lxSb3VoNiManQgplde4rmsM1irkSUqcJHiOU8wQCxgDNb7RNZV2n+eqLzAMTWneCp/NXMhe0ymEclOeHfwU/DMh0FGMSzX/VBulzHJqhsHZpx7N2W84gYc37uS00z7MkuUr+O5XLyDtzLBzokGa5lQ8ly27JpnTXyHJc6pFUcVJRNmzGJo7wMRUq0cryhG4Re7QTMfHsy3CKFJtrCgsz8uuymHOUkzNwDB1SjgkmVqBXdsECa5l4och6x/bxOI5/Ry8SrFN0yQt2gR1T2c6PlII+ssOmczoRAmj/X1ouqKAt8JQ+cYbDpajeFlRHOG5LhI1W9R0nSxPGe7v7wWedq+9CktkraqEJb3OXe6BSu6xAHVDw/OiGc4LnKgLhHatjJIkV0PLrOhhun1UQdLLpVrarapKPM1zSWl4QOE5YYxhaPhBSJikzLTaWIaJzHM6QUiOxDFt1eQqs/diFSpWH9lloMoCm1NNskpfyNEtdSPoxqJ0P1yXftH7WlfhI5BaUX5RxkFrV7B8xSLWrjuA4doAY0ETx4Q5g308v3Oc+UM1qmWXielpkILdUy32XzaPXRMN3vWRr3P73U9iGgZhq00QK9+JJMnUlqlpNPIUmQv6qi5REpEl6vMEUUIziXrsVtPQcEy1ogkpCaOIe57YzOolo6xaMKq8L4rPGERKLq9S0RTpDwmmaVBxPdIckjilEysdo2spHnvb91GxvhqNjs9MSyW8zh0qKxupAnJCZL3ede/CIh0BFkOXY85LXILe2Af1NCmTekmeZBimgWXYSpKnF6tHMVJRs+bumEapbyQUDjCzW61p6NQqLqCiQ9DUlF5x1xWFI05VZl6sZ7i2jWWbRYBOEX2FhhCqh9hzcCCR6JbBdT+7n1KpzImvPAwRBhAnyGyPj6g+HSB6772Lv4mCrhP4kdoOgg6OYdFotxmfmqHd7rBg0QiPPrcN04C5A3PpW1jm01+7iZvXP4WRp7zi8P355wsuZGy6jm7alGybcsWhHQSFSbDANARpGtFqB0ghqJZUeJLh2IBy1dM1nWang2eblB2Hx7fuZsFIP6sWjihEXKqHIY4TLMMgiJUsr2s9GUQK6wsCX+UuoitmSmFEbBrKebHeDplstBgd6mfeUF/hoKj84kVxute138x5X4AU87o3GdldqkRvu3mpS5HvVJBlEETYtsJZNE3roeTdYvUDxdXWesCaoKf66S0aRePU/VqmaDhAAcYqvnt/tayYAs0OQhOUHJeSq0OWvOhBeNEfHYdrb3mUq2+8k4PX7cObzzyRM151GJXBKoQRMuvqGdXwtVtUohh+qw+tVuw4irFNm91+gCCn0/EJAp+O73P4fgtpRRnX37WBy398N36rxWFrlvEX7zmFuYMWYRhgWU4RNJnR6MSkaUa54qjhvczoRMqCXBc69XYEMqPqKa6VlCpttmRbVFybThjRaHXYb/FcoigmzxUsk+WSKFZ5QYYQ2I6JBjSDSPWRBYPEFRZQwDzkxFnGxu1jxJlkzkA/a5bMRzdNwiQlTSWdOMTQDVzLKhaGWdjpRSsW80H07fWVPa4uNebFX+9uFUKAYzvkMidJFWEtL/CXon3BMm2SLOn1Nwh6TNPZ8n3pAoZusWpYpkWWqdXKNNWAdbLRJIxtBmvdk6VC4WU+uz2qxcxibGyKRUuX0IxyPnbh1/j4RV/j1NcczV+edyar912MIIcoIUpyTMNUboKarn7tMgNhYtsWQRwzXW/iBx2yLKNatlk6dxG7Gj5X3v40N936CBufeZ7hvhL//o/vYsmoQ8V11EhLV6FTNdcGmVNxTOptxaUquQ6GUAnyaZ5h2xppLgAVrpQkUUFZsmi2QzZMNah3OqyYP0TJUW7GCKUmd2274MIJpFZYaBfuif0Vj6YfEiQpfSVBnmt4JZentu5mfKbNvJFB5g8P4Fo2YZqSJ4Ww1rBwDBNdN/ZQVP0GRz8J/cXBSN2BfBabErLYwLo36TdcQhQUllzRagDCKC4Epmo/N9CKnkrZGxqGOkWqVSLv0W1e9JNn32UBK+i6jq4LzGKP90YHabZDGu0Iy1IiWccy0TQ5u+wAaEodVC2X+PoXP8K2nRP8fP0jfP/KG/j2pVez9qC1fOC9b+INrzlGwR9CFACZQo5V013MJoUginwqnkmzHaObBjvqOZ/+6i08+dRGOjNTXPTRc/mTU1/G5p3jSAklx2Kq2aLiOTimMu6d8QOySKWZNjohcSIxikg9z7YLOCal5Fq4tkmj7bNp+xRRosiU8wbKHDA8D9exemm1ulDUF2RKnqXkmlJYJ5nEsdStr3cCsiyj5qnwcGEaPPbcVqIM9l00ypzhQfJUZRwGSYZtFkbCKIhHaSbNIqQB7JcqLCFweje0+3TvdWtFD1nsBVa+ZHmpEHKpqwJKM7Ws5wU7QLklq2QJzxWFdCsr8CRlFalpXX6X6L1e8R7ZS9JVvJ6mKeZqtewyUW8W3vAlclk0qcXhQlWv3qPZ9PdV0Uk46fh1nPLKI9i8bZxvXPoj/upvvsBfX/glTj3tFXzsA29nnyVzwTJUGljQgVyBgYODA5Qdg7HxAMsd4HPfuY37H3gcK49440kH8qF3nESaxTTbASP9NWZabRrtNn0lB8eyiNKMiWmVl4OmM2+whB+rbc4ydOIEWr4PEhYM1Zhodnhww1bGZ9ocsGI+I30lBqoehiaQUsePEtI8xzYsBKo4/TgnlZJOFBGlhT2U1JUDjabheA6abdFqh2zYtp1mEHLUmpWYpkmrCIiqlsuYmiCTRR5RQVHK84w8Vx6llmv37siLeizRQxa6do+9paM4IKq/Lg7oRSpC91T26wQI9RW1WqlVLElT4oLionCwrvm/gixyIcgyhaQLDUQRazKrK5wtql4LuPe7Z3RQ7eZtP8QPI6LCuEynCNiUOqZhsHXTNnZNNpk/2M9SYdP0Aw5as5hlF72fnWN17rrzEa6/6TauvfqnLFm2hLPe9FpOPvZlrNtnIZiCdrvDcK3GRDvjrscm+NENP6ExsYuD91/CR//0NfRVTWzTpBmG9Hs6miYZrVWoByGmbjHVDgjilKrn0OgE1DyFvg9WVFxfOwjVyqwJHNvi9sc2Um8HDFXLnHbUGmxDV2Z2EvJcJ8pUMqxt6j1DYj9OiOKUwapHkCQgUgzDwNYU3TlME4IkYcOmnUy02qyYN8rLViwEoTHT7uCYNkma4hiGatALu4QkyUjpRtBooAvSKKabpvPiwtprJShwyNmb2Puuojcq+qG8YBDsiXftVV/dYi1ox0jluaCiUTJcx6RbN4ampGLKY6SYphe+oeopEbyU1HCv4ioKuuy5uMU2kqQpUZ7gCg0DNUaqVcrkGPzsvsdxHY9lS+YT+BHj9Zi58xdzxlnzOe997+C+ex/k29++kou/+DUuvthk9f778IH3nIlEZ9OWbXz07+9lctd2qq7G5/72LRx14HIaYcRItUzH76AJ8Fw1IQjiTGVeF+9VbdUafZUKll4ckCQqAKpkU3JcNmwd59kdE2R5zuuPWottmWTF1qjuhiDOUzphSNWzEUAnjslytdpVSy5BklLvhIxUyxi6TjuMaTWVn34Qp0zUm7xsn0UM18qEsRKyFn5AzB2okUvVsCdZSstPKHklLNNEaBpREmPoRi7zvHuuflFh9eYxAik0RNbd7MRe9SLp9kOiAD+Vfq/LgeoWZXc/nZXJ53vNAY0iA8ePYizD7FkVCVGodKRUczMdkiRDF0o40QX5NKEXTNVuUcNeW6RUyh5X17DMAr8p0sMMUw10o1RQqQyycME8MimohzHLl63E0DR2j03QbNQ55oi1HHP4Gnbu3MX3r7qBn1z9U85/7EnGd+9maqqOZ+n87UffwlmvWEcrSBGmh4gVW9NPYU7fABrQCsPCw1OnE8XUyi7kSikuENiGgZ9ESk/gmui6xv1PbibMMpbPHWDNkvkYukYUZ72WUUWiqKBO1zIxhM54o4ljmVRdmzhNcU0DgcZQucR0O1DZkY5FK0x4fPMuDtt3EQuGamTATCtUzFuh018qIRGkSUyOhmmapBJKnkNORpqCTHMM0yRN05ZZqvkvXVjQ6SpohCyKS84Wl+r6Z70VcpkXCpqu1k+dwlQ6hdZbqnqHAU1TiHYXg0T5kOq6TidQaeqQE0WxMhoz1eomAMsqTh+5pqRiojgY5wUUscdKtYcTXAFl5CoMU1C8fqYM9zNFsx6seWzdPcVMMyCJE/IsIwxCli0cIc9SxicnWTRniGULh7jwgnfwjnNP5o47H+ITF32ZQ44/hu9c/JfIcJow0XBdowj9NDE1Dcsw1Zyv4O+bmk5fVXHs7310I8e8bJ9eLEsnigr6i+T+p7ZS8mw0DY5fswpTVy7KSZL3Zn26oPDFQKlp8pxGmClluVDOfEiKNImcHVPtnqxuy65pdF1wwLL5DJQ9OqGSirmuQ7/rITTRM9NNcommmSQFwJqjRk7C0LBN9Vq6YWw0awvbL11Ygk0gfKTwioWLXqH1WvViJKN1NXqF1aMEmWfohoYmC1S+oHzoohCw6iqrmXzvZAuBijxRlkkGhq6GyFGcqvmeUOKK7mxP100kUnnCJ2oFy2VemOXSG/fseRRU4KZC/EkTPNdWCWWdFpatU3ItOi2fVcsX4boWzUaTialppFQ9z+6JSYIoZN6Q8st68xtezqXfvZE3nvE68iTBtSwySRGMrpDtOEuolTySLCGIYob6a4RpxlW3PMC/X34b2zfvYtMvvoqWdYhjxZvaMtbk6c27WDy3n4NWLELXBFEaK14VShBs6DppMa/tikziJMU2FRPXMU2Mgs1Rch3GGk3qrZAwyZFZxmCthGkIls8dYsd0g90zTfrLZWoVBQsFUUyYJspDQ9NJM9BlUugVcqTMqTqu8gyTOXESp7bt3gu1Ht7wIrhBfwTy+4Sun6g6Qnq9j9rD8sLsnl4zLSXkWZFKISAt+Ot64cuAJkiSHF3L1bKfMZtI39u/tO5EDqRUKV6mqSJJCtN/21KnHGvPVaxIPE0LGk9erIaaUGEElmEoK/ruPt6FzqViaVimSScMlBi0kzDS79JszbBpa4M8T1k2fy5+4PPC7nEGaxUGKmV2jtfpK3vsmmrh+z5BFDDU30dzZowoUWGTUipDM8d2iRLVLA/3l7j1gSe4+Ir1bHp+guefeZowCDFEymTbZ/dkgx3TTfI04+UHrWR0sI9OxydKZx+OsmUWJ2vliJhk6sCka6I3OrMNlQG9dWyGdpjQDkIcU4GYc/tdap5H2TEJ04yGH1HzSlRLDqZh0ArCIkhL7SJl12Wq6YMA13Rotzu4rkfVdR6jyMUAACAASURBVImzjCTJEJqB0Kxnwzi+d5bm92K4wR7dXZ985juC/FBd5JWSayE0E/JM/VcUg5oFFiuXEGh6scUIocxnsww00Vt2LVMjlxlZpvAQ0zR7SfKzQU97XwKJZWhYhhpfxImy5E7TbktZ9GiaVpjlqu05Lei7AHGcFtt0lw1Lb1yzcdNWxnfv5h8/fxmvO+UIVi+dw4LhQV4Yn0HIhGXzR4iTkGa7iWNbrF6+gIeeeBbLMGj5HYJQueWVXJcsEyS5juu4xFmCbegIKchyqA0N8uDDG/jct27g2c2TxO02B69bySH7DvPdq37GIxueZ/vEDCXP4tBVixisejQDn3pTScgGK6XeaC3Jsl5UDJpGWkSYxIla2W3TQErBwxt3YOkGI/0Vls4ZwNQ1HMNQAgk/ZKaTEyTKZaav5JKRsXN6BteyMQuVTsOPGJ9uYlkGnm1jGgaOaROkOe0gIkhzTMNSwQ26fqdV6d+05/37NdqMYZk3d9rtn0dR9Ppmu4NA4rm2SmBXe+MsfUZmqpHvxvzmuZqu6YI4jkAaipNeNNeGBoZtFv0R5KnKMzS7gQJiDxfIbg0UfZpl6j1nZlmYfUgJURzgOY7iMlHwtaQajMdJqvSKuUp66K5oei75z3+7gB9cex/f/9HNfOYzGxCWzUGH7MtB+y/iiIPWkCYxQuaMDvYzNd3k8We3oBsqQrxWKbHPkhqaoZFmGbpuYpo2SZ6iaxqObVIqueyYmOGfPvVdfnTzA7i64JC1Kzn3zGPYf8Uwn/zileqUbBscu245tZJDkiQ0OgG5hIpr4tpqq0lyZbwSJTGmpuOYFhmSOFFNvGubZJnENHWe2LKbPM1Zs3xU5eDkEpnnxLnywcpSgWZo9FdcHEOjHcYkudplPNdmYqZDJqEdKCtI2zSUcCTNlHGuZeBaHkLTivwg089yeQvuqmyvOnpxYZWry8bK3q5r/HbjFUkSlzu+T6vdptFMGR2sYmmFYlmm5DJRvqK9f533oAVDU2HhXeeXLM8Liuxsn60VMq5cZsXEXVM01z2n33usZppAufBJtSVGcYphaoRRhGHoxSlTFj8XbEsHqVa5OI6QgKkbZKlk0dxhPvbnp/Oxj5zNXfc8zTe+dS3XX30LD949yg/n3MvKFaO8+oTDWbJkEZ5nYRgm7XaAMJRcbeMLO1WYlKYXB5aM/koJhGTDlp1ccc2d/PjGBwjDgP1XLuZP3ngsB6wYQhOKtVpvBggBK5fNJQ9iZjoRhhAYmoZrq/FJECU4pq7idjWBbZjq0ASEUYJtqNWk3upQ7yje1PaxOutWzqPe8dEQWKbCn1p+TJYLKiVlTBtFCTLXaQYRjmVRcT3Gp1sqv0jAcF8NTVOr7nRD4W1zh4cIEhW34pgOCIM0k4+EmbzPefEC9eLCAiCT93mu8xSudVitUoIsJYoiOn6Ldp5gmwaWUWBSZIqd0J0bFyuYCgsQGEIvviLJ0qSn9VPbpCqgbnpdWoQT2Vb3bYleSEFX29gbVRbFJYRAmiqTOE5VdKypKzCyywPrRtR2pwV5rp5+khwt8Dly/xGO+ffz4ZK/5Yor7+Bzn7+E637wKx57eBP7r13F4Yes5rC1K1i7ahFTM3VA8sKuXaSF+S469FU9tu6c4Bs//DlXXncvOzZv4fCD1/L+d53DkgVlWm2fdhjTXymRZd3YPYFtWNTzWBmA6HrByQpJ84z+kkOcKZmXoStLpzTLCOOYsqeMPhqdDqapMzpQ5fHNu1g6d4C5fUozaeg6E60OtmGh6wblwp0mK/JwWmGM6ygefCuMcC0TchQomuU0/BBd13EcGzSdOM3xo5SSaxMlKWmUyZJbuaF/4RG7XlxCL11YhvZCHotfCclhKs0eFQBkVvH9Fs1OhyRJiOOEBXP6MbukvgKxnz2Hdf0cwNbVthHEMbouUPZIopfuVfBR0HVBEiujMAlEUYzjWPQgjy7qLmfBUNXIa4BOkmXEBQ/eMnW0PUSR3fciNIEwNPKssKuUoGUhZriTs16xgj953VfZUZd885Ifc831t3LXHfdRHRrglFccxSEHLGPf5fM5/pA1GJqijaRoXHLFzXzpOz9lZmKKlSsW849/cQFr95nDk89vY6YpmDNQpeRY9JVdPMcijBUDQwqdkuUop5gwQmgS19IwNEPx+VG9ZJAmaEKlplm6VegoVcbOtskmrXbIUJ/HPvOGVUClY6vVyLSpljyyXOUXIsFz7OJQoQxxPcckimL6PI8gSWlHKvih7LkYmomfZJS9Eq7tkcoIQzeQucZQrboZzbrpJUvoJQtLn9MRYvuTyDwFDFksK0JKPNfDMtSYZaJe54WxGQxdMNxXxjI1TKEVprH5rw2SdV3DFsp5Ls9z0kT9cgxTfU1HYSKi8AmVSNAhz7rSJ2PWZLc32umufIp6YxoaWaaCz+NUIsiUe7OpzEl6vluaQBNqJcuyDD8Mu/Ie4kadUVPjEx8+lb/6yJv45S+f59tXXM8tN/6C66+/g5E5/bzzzaeg6xoP/eoJvn/1NTz91LMsXTjKX1/4Po5at4CG32H3VJ2RvhrLFw4TxwmuVZx0E+WmB0CuVqA0z7B1gWN2Ay3V6djUNdpRBFJSchTLtBOn7J5p4jkWOycblB2LfRcOU/UK6bwG4802aSqZM9hPM4joTugc26YdKA9+zzIY68T0lRyGajVaYYRlmcgsU/HHaArbshziVBKmEYnUKJU8bMMkkmL9E5t2PXXowJpfK6Ff93kvLhnueDUy+Q+RJ0ulzAr34xSZp8g8Q2gSoSksJQgimh2fXKZ4plVUu41ldvuP3qv1Rha915H0UHuzaLD3ZJpKlEJY6EZhHKIsJE3TQoiudF8HMQscylwURFBRWPBIojhGShXnq2vqQdEKXwmZK+m9lCqEKogS1eSbBnEYU/JshOUwEWrccuP9XHr51YyN7eKZZzYidIPV+yznz97zRk48Yhnbd0/SVy3x3AtjHLbvIoSmEYTKsyqTKt965aI5nPNnn+PGW+4n3PJjmvVmkd+oXFu6gKlAafk0TcMQWrENpkx1fKabAYYuqLgOqxYOIzOlK1RSehXmXi2VyDIYm1En21q5xI6JaTzbYKDikeWSLFORJrquF+Myi3orYHSgH103qPshQjOIEyiXy5S9MhONNjeufzC6+sY7P3jdj667RO7pbvy7C2vnWvLwU+TJMUKmNcVvUk0qMifPU4RQyV5a4YIsyQiCiDBO6URKQ9df8ZSFY67YnC/NhqCXINVdiSyzGD6r5QlQrjWKqqLkSGoAbqqC01TapwKuNKTUCm8CVb0yV+87y1LyPC+KWfmomrrahrXZUwVSCjp+BF2fiDRD18DzXES5yoaNWzjsqLdy+GGHceXXLmBybCtBlNMKI/o8m2YYsmhkgB1jMywY7aPVCdF1jbJjU62WOPFNf8cjjz5HsPmHJKHfO+HlWY5rmyRZikaOputKxSMlO6YbjE23sAydJaODuLZSduugvFsLQUTVdRFoTHcCTEOn6nlsn5zGsUxqnsriyYqH0A8V8KocPZVUPoxyXMcmTBQWZxgmrlei3o6499Fn+PGt9/DIQ0/uevLhR8Mkjk+QUm578f38ja7JEjGBzB8XUs5B5muQmQ0qrkQWoxzVtEsymaJ8PdUU3nMt+nKXyUaLRicowEgDz7HY2yN+9tI1gWkVPZFUtFhkN7ZEfaeaH2oF10gVQpYruVIaA4iePKxHOitepLdxGjpSagRRTLlShTwlixVIauim0scVHmFlzwUhSJKEtHgi4iTF7jRZ0O8xd94c3viG1/LCzt3oecZM26daspWTcqIzPt1gZLBCo+3jeS65hGvXP8bl19zD7kkfQ9dJ/A5R0euVbQthyMJlWuLaNjmSqUabbRMNwjhh1cJhBiqe6hylJEpT4jjDsEziRKHuUaKCyQ3DwNR1/CjCMoTKPyyYJkmWEsWp0odKiJKcoX7l9x6nKa7jksiULNcwdZtr1z/E16+4LgyC1J/aOVYeGhiYXrRw4RkbN278taL6rYWlmVYzDJuPGiJfoAuGkXLRbENeMD2l8n9XqHcG2ewpDiQjA31MzDRohxGaiAijBKFJSq6DXsTHdUXVuZSF/7vqlroQRabaLYRGzwN1Nsi8i3tJhGkSRCFpphc237JIISskY0JT+JnM0CoeH7/wK0yFLuefdy77Lx6kr5RCHqFy7oo5gBqKYpqKZqMsMBOSNKXZbJMkCY5lMt1qM1QWzBmsoAFlz2L3dIN5QzXGphuMDNYYn2rzjxf/hCee2sboQJW/et9ZvOGV+xGmmfJMsAzqHZ+Ko8IOZtoBSZqzeWxaKXCQHLrvYuVUnSSkoJp7XUczDCWAFWALCLOcvrJHkmfkMiMMEyXSMDTSTDLTbquwd12n3gkY6euj37Pxo4xWkNBXqRBl0IklfhBy7dW3Zzfe/suZpN7M4zCS55x11vde8+rX/c2BB63d+Zvq5zcWVp7roWEYz4g8X5HncqmQzJMyNwpHoYJdOstFF7nqfdJCEyeKiftQrQJ9SoEz0+pAJtg12VB0EYEy+wJ0Q8MyVHJXl6qs60ZBDQEt1/fQNcoeqq8Vyzh5imOqLZJM+aCiSdDUEyp6abCAbvKVr16FYRhsfu4ZFqxYzX777cNRByzlZSuHGR4pIdIIijjboiIBxXVSM+4cw1BhkqP9VWTawbNM4jhh52QdISSphE07Z7jq5kf50TV3kQYdPnTeWbzj9YeiazFCV4Vv2xBFCULArqkmrSjC0g2mmh3yPGfJ6ICKbskS0lj2SJBCV95X0802nmOTyQxdUzEyk406JcfBtUxKVRPTsBivd5QvWaqEMp5lMc8r4Zg2E80OruPguSYpOgibR59+ji9/91oMjN2P3XVfdd26dTd+4C8//M9vfsubfvWb6uZ3FpZm9uVE07uEpj0n0damcbpGE7KW5ZIkiXFMveiH8h7VRQiNtKvKKbaObs+kC8lgtYwfRpRdm8IChKQYwWSx4mY7ptGjKVOwKEGZraVpjq6rTD6Zzlp+a3rhOkPecxQ0RTdZXSWOdWVdAg2EgeM6HHfsQazZdyk/v+Menrz/F9w0PId1hx7JoWtXcOxBS9h32TBaHkMckScKHijKGA1FqhMITE0nRRb+WcrmZ8d4g0uvfpC77n2KLc8+y7vf9nou+ovXYUklmHBct5iJ5/hJxqYdE1RK6iEb7SvTX/FIMqUIz/OcOE2U6Yhl9A5DfhiT55JqyVFFL8wiACvFNjQGyg5ZlhMkGZPNRpHuZeBZOrVyCc2w2TnZwDAzPLeEpps4tsu2ndN8++rrefLZF7Lnn3xuS7PRfL7ZbF5w5513PvK7Cup3FhaAZtjNJIq3p2m+Q9O0Vp7nNaRKU00zMAwx63klBAiJaRkKY5GKfaCa4q6/g8S2zEKYUzgXa0ZxGpS0/YgoUYzK2Yidor/SdHSrMM4VetGqSWWaUfhMdvlhvfCDgrdFQRSUBctCFIFS1WqF8//0TM464xVs3LiV29Y/xOPrb+LBn8NXvCrHHHc0b3j1caxdXGVwpAp+CxmlxRauKNVZnuFHIbaAsmfzwIZJvva929i2dZJ2fYYTj17HrZd+DF0L0dII27UxDeU5YRg6W3fPIIVkpL9MpWRj6AamJmj7EY6ttvQoyejzPHVKlDl1P8TQ1GquC2V7KVCuL/VOBxCM9FXwI+Ve0wojZC6ZO9hfkAtt6p2A7VNT9FWq6JqFbZdIpeB716zne9fdzviuyYe3b9nanJmZ+QbwYyml/+L6+G8XFmYlNrJoWtfFWBgFnTzN0YTEtRyyLCkCHpV1tNrvtUIBrRTKWiF2zfOcvBgFGYUHVgp0Y3rTVBmJVEsOQZTQ9iMlGTeNQlgxO+FXsjHVdCn4QKVQqAg6SZ7mRapYd4WCrnJboBXbWkqeS+bNGVLmsh2fFfssZcGSedSnGzy9YTN33v0r7vnpDdx1689wB+bw+tNezpmvOoylC4Yha5LuVpz3pt9h3sAcUunyucvu4MbbH0NEIUcdtIr3nPMOlswtIbSMmlstsCtJGEdMNNpomsZEo83BKxfQCSMsw8C1DOqdQJ20c0nFsRGOCssK0xw/jgiSBFvL8QoyX5plRGlKw1dgctm2aIcxTT+hEfgsGBrELmwf635II0iYrHcYHRzCNF10p8RYvcNFX/gOTzy9ufXsE09ubLdaDwCfeqkT3+9dWJvH/GxJv9HWZD7tOW6YmyZB2MFPUnRNpWpJKQkSlUkocomeC4XEoxQ5arNSrnxdxz3T6Jr8F6dKKDAVRcATQvkTqNGPtRfduEs0REg0Q20lChTNFbyQq5VEFriPaZq97YtCYSNy1bfNNJtMzjSYOzxAFCfsmGgggNe85kROPvkEOu0O199wB9f/9C6+8OlHueTrwxx51OF8+Lwz0RMbwzBYOHcOP1i/gW9dcTPTu8dYt+8Szn/H63nZqhGkEHiOhVlQgcMkIYgi/ED5HZimzn6LR5Sa2VYWjZ1QJUe4lhKjpnlG0w+Lg4w6LbumTs11sQxFCw6SFNs0qZZtskywc7pFX9klzTLmD/TjWbYabkeSLIdGJ2Le6Cj9fUO0Yrjy+vVcec0d+C0/evbxJ7a32+2PSilv++8UVPf6jThW9+rUt42YenaiqWUfQWaHIDOSJCYMQzRNYhldOnGGQMMPQxxLcYL24m5JqajASVzk5GSzeYXFIS/JFCaWF/trECekaUatXOqZd/ymt9utvW6Dn2bKQ1UWeJemKfqMEAJRLeHVjue004/nvHe/noFKiSDOqHoeQ4P9PL15B+1OxD5L5tLq+NTKNhs3buHSy2/glp8/gOl4LNt3NWMvbGXFypU8u2EDC+cO8tkL38U+iyo0Wz5DfVVMXQ2Q6+2QHVMzjPZXaPsRg1WPqmdhGsqdPoxTsuJUrOmKoowU1P0Aw9CYafo9uZZrm5QtizTPiNKEOMmVN0MOjY5fECoNRmslZJHVvWumSctPWTQ6iK7rNIMUr9TPVDPkH798BRs2bMcRWjwzM33J448//jdSysbvU1Swx4olhKgCu4DbgY9IKZ8BMKxSGsXtOErSPAxC+qouiBzLdtBEjswz0jRB1zV0TVCrlImjiFYnKkh3AstSrAPlVekU5rlK9m0YRmEVSRFPJtFkEbVra4TEdIKQNMuollwM0+hRaWQ+W2Xdgus+KEYRWp5lik+OVNJAXUgUxCWZnKkzPl0njlXYd+oY7BobR9dylszt56lNW5hu+gxWHA7cZxH/8S/no2vn8/2r1/Of37mJrc9vwXMdvvzJ93LsQQtohRFhnDFQq2CZGq0gYsvuSaSEJSMDVD2HqmtjGALXtXl+V4P+kotrqr7PNgyiLKcdxrQDdcixNJ3hvpKa7WkaOirEqhNHeLaNZxu0AsVV8xwXBJRthywTtMKYHVN1VswfpeLltKMMzTApVUe59rb7ueTy62nV24wMDUfr1qx5579+9rPf+30L6tcKC2gD5wL/D/iVEOIF4OuXXnX51w5du5+2YvE86XpV6jOTaJrE0Azq9RmGByoYpqbc/uIU0NAMCxM158ryhLYf4Lk2oIj/RgF0agjiTHkyaFJHpcmJ3qnQ1ASm59DyQyzTpNHyQQi10mnKoaXLkpB59uLPBqjgpi5BsUuV1qQ6XAwN9iNkzt2PbGD/pfOpt1pIlBN0oxWRJSGrFw8xOTPDxm07MIXEsjROOG4dparNp75wHZ/8hws5+SCTielJqp6rshelZLzeZtv4DHMGKozWyggh6IQhlqVRGRjmi99Zz52PvMB3P/k2HDlNJpXzc5wqnGyg5GCaKm+52VZTjChWxrT9ZY8g0Wl0QsUEEerg4toWjm3SDlSouGMaDPbVaAQpnlPCdits3Lqb/7j0Cn750FNM7d7NhZ/4RHzaa057+ZLlS+/9QxXVXoVVzHt+AvxECDEf+Bjw3ne+6dyPl6vVTW9599u8t/3JWSxfOI9a1SPw2/T1D9Pw2+gC9fR4Lh2/g2WAphkqFEk3qVZ04jglimJc28TUTGSmUF+7kMrDbJ5zt9nu0mMqZY84itA1mzjJQAr8IKbZUQ2vZepUq57C1uTsqlV8sO7nU1SeIuYjK5LHXnXMy1gyd4if3v0Yuq5TLVlkw32EcYwpBFNTmTLzd3W27ZpkZKBKq+0zOd1G1zRMkTDZSBjpqyIl+EnKdKNDqxOyYu4gJdcmTRI8z2KwNMA9T47zb/98Gffc/QAHrVmKJdq0QmXUEcQJtqYx4LlIBOP1FpqmUbIthKbhWiZhmjLdDkhSRdc2ilNwyXXRdYPJhs9ko0N/rUZ/tcqOqQ5BYpCaHpdeeT0/vu42JndNyOOOOWbbBd/5zuWarn9ryfKlG/+QRbVXYe15SSl3AB8GPnzA2gPePD0zfdEVl3x72U++90NWr92fV596Mq8/7RQWDvcxWq4wPjVJ04+plh0yNMIMjFwW9o86SRyTS0mppJx/G+0OlqE4RoaufLIAsjQnSRWX2rG7KQeCLEmVXY4A11Yoveeopr7e7hAmCdFUC8dSGFjJUVwlKWDPpqybDkamTmcPP/IMX/jWdZz9qiN4/UmHsHn7OK5tctcjT2FqOkvmDbJwzih5lnPPY89x1AErMUyNSqnUk7lFSULZ8YpoFhifaVBvBuy/ZA6mrqiP3kAfjzy9m89951p++csnKZk5Lz9oGVPtFnESEcUppi6oOSrdIcpy2oGPoWlUXYcoVe7VfqDGPX4UM9rfRzsIsUselqkRxhlbxycZqlXpq/YT5xpTgUY7s3nk8ef41vdv4IWtO3LXsraeeMIJf3XZZZf98A9dTHte+kUXXfRbv+G444/b+q53vevGdWvW3PbUU0/pDz34y6FbbryFy6/4wcSOejOIMq28ZOFCRucvJo0j5W6cK/BOaBrNjo9u6Bi6os8maao4WIZGnCSEURHSiOJm6YVvuNAEWVbEweXK8L7bs4mC55XlEs+xeyOeroAzCJPC7lBNAH5t8J2meJ5Dvd7kjtsf5Ls//jnbdtdZuniUimdywKoFDFU9to9NsXnHJJ0wYuHoINWKw3S9zUBfiWYr4NZfPMFRhx/Mfosq+GHIRKODZ9usnD+CJMeulGiFFl+66kE+dOElNMZ288qjVvOR951Kp9Ph7gc28NbXH0N/ycU2NDShUfcDJhttSraFUyTN+nGCaeoFwGkrpkSWM1irqVDLLCeIJa5bRjNL+InAqfTz/LZxvnLZT7j6+vU899Sz4dLFi//14YcfPuexxx77ncj573v9zlPhS/4jIV4J/DVwjKbrwZqDDpRve/tbai8/+lD2Wb4YmccEnRZZGtFfc5manKZSdmm1Wug6DNXK5GTIIikiz7MCcFRbomGoIE4VyTvLyEhT1YjrumIuFESEAqiUhfxbEhQUmUxmOIZZBBZBV6Gj3GIEuBZPPbuNi//jKn5x3xNEWc7i5fM48qBVnP6KgwnDmJlGW6mGOz6GbtJXLXHkmqVcfs16vnXFPXz2n/+OQ5YJxqYmmDtQw7MtvFqZMNH5zvWP8PmvXMnkzh0ccfA+fOhdJzM8VGHxnCG+edXtfOW7P+NXN3wKx1Lhn+PNFp5lUrItOnFMnOaFwsZkuh1SzBnwLAvbtphq+Zi6TZgJplohtl2iVqtR8sp8/Xs3cPlPbiVtB5RL3obx8YkjN2/eXP8D1Mx/rUb+O4W11w8Q4tPAuxBioG9wMHvla0423/DaUzjxqEMZrHkkSUij2STPIwZrFZI0UrJzJGEU0l/2lGReSoyCTRomCd0oOkMTzPouSfJMbQey4M4bBSjb9ZEIorhwujOI4qSw2cnUjE8WR3nRlbGpIhOGzmQQ8N1v38gll99CvdVheHSIdS9bzhmnHIaQgoVz+3lh5xStToiUkpvveJiHHtrGX3/sz3nZco3hssmc0SGSGH54x9N86bKfMbljOwNliw++59WsXjEHlTRr4EchN/78IS698g6euvnT6JqK0gvipJd9kxQOypapUiLavlJO25bNzskmhmFRLldAqNne+HSbZYsX8szzO/jEZ77Bpk3bWb5kCSuWL//Piy+++INSyvg33sT/gev3LiwAoQaCB+q6/q9Znh+m67q+eu3a0nnnvYPVqxZz5CFrCEOfRr2OqQuyPKFWckiTGNsysE01sdeE4iIFYVTItfKe2b1andR7zQpJutAESZL2nE8ocKw8z9F0QRIrQzHTUAb8UZRim4X1kS4U30kTIDPyNEPTAdfilp8+wBf/81puv/txDjxwJUNzhzho7VLe8KrDiOOUh57awsNPbOQX65/lHy78KGcdPwKaxv1PjPPpS27imcefplbSedNpR3DoQcsolxw6fsjWsRmazYC5I/1sem47F3/rRh694dOYuurVojgt8qwFho5SxgQxhmEyWK1gmSY7Z9rkUmfe0BDbJ1s8t2uS5QsW0Fet8fmvX8V1P70HW9M5/LDD4jPPeOOHT3zlSV/5vW/wf6cm/hCFtdcPFGIe8F7btt/uOO78gcEB4/QzTuPsN76WFUvnMtxfxm83UezlDD/s0Gq1MXWwLQNd5AxUvaKnUpZGeZ4CaqpvGtoe1kZq5ZLqW3uiDUPX1c/P1BbZHSshpcrVI8MobKYVVTmjZJlYprIA0BBgGYw1O/zDP3ybB3/1PH4YMzJ/mLedfQKvPHINdzzwJH/2F1/lAx84n7e/fh2f+toNPPjQU2RBi7NPO4LDDl7O/JE+ZRskJVff/jBzh/tZu2Ie+y2byxXX3M0Xv349G37+eeI4KfzqVXi3YrKq026Y5hiajmmY7JzuUCuV6eur8ey2MeaNjDDWiLj7gUf58c338tyGTQwPDHDhJz6xZdWqlW9esWLlHxRC+P9VB3/owtrzWrhw4esGBwe//Mwzz4yWSqXkwJcd6J/3/neW1u630h7sK9PxW9iGIE5C+koezVaDsmMWMR05FcdB664uAoIwUi7NuuqrTF0v0lE5FgAADstJREFU7LULaguquKRUNB1RkAFzqfAh09CI4xhL14mTGClyWu0OMpfYphpgl1xLRXNomhLp6oJ6mHDTbQ9zxVXrefKZbQyP9DNv/iDrb3+co449hslmk8fue4C3nH0SbznjKOYMVXlhooGuaQRRyj2PPcPJR+zPinnD1Ds+qxaO8Jlv3Mi3vncrGx/8T2Z2TSKlIEwUg0ElxBtoQieRSurV9DMqJZdOmIHQsdwyrU7EJ790Obu3T7Frx/b41FNPffDP33/+v+yc3HXLCcec8Efd+l58/Y8W1l4vJMTfAe8G5nolb8cbzzmT897ztmVrVy2h7BnM1GdwTI0sjWgHPo6hE4Yhhi5wLRPHUk9wlmekSUwUJ2q+VmjxlIHurNVNV62tRjxdg11UpnShFrJMjSSJMQ2V9BolOWEYKsqyaVBzrT0cmQXYFo8+t52vfO06bl3/KJs376ZWq3HyiYfw3rccz9IFgzSDhJYfcdt9T1H2HBIpOW7dchaM1MgKU7nBmsf5F13Kgw88w8aHv04w2WDndIOhalUdWKQgiDKafkxfrYxl2Ey1QqJcKIl7ZYB/++aP+NF1t+HoZloplR70PO8D119//UN/lJv5X7j+aIXVe0EhDgc+DRwphIjXrFtrXXjRBda6/VfRV3HxbANNZExOzSBErm5OHBEnMbauUfYshR25FnmekSRqmzRU6DN5PtuXQYFdUfiRomjVoE6MQqooOyEgDCPF/RJqiw0C5fwiULiYZXUzFSTUPO687RFOf+unedfbzubc163Bs0A3bYIo5se3PEi57HLqMQcQJynzhmrU2x38MKKv4jEyNMgZ7/0iz27cwQM3fw4tbpOjUiomZtqYpkOWK8Ngx3ZIMsF4y8d1K+zaNc0Xv301zz21idj3/f333/9D11577SV/1Jv4X7h+O23mf+CSUt4PnCCE8KSUH3r80V/96VlnnDtvcHjYP+ucM/tPP+0VzBkZYNnCOdgG7Nw9jucYlMs18ixl13SDoWoJP8qwTQPHNkizVNntpIn6f5YrynM3ibWXHk0PzTcK+249LXw+HYc0S5AyReY5JUdHSuWh5ScpncLNxbMtiDNKJYulyxaz/5rVSkJGzq33PMnUTIu+vjJvO/VI4jTlsWd3UO/4LBquUa2WufvhzXz3xmvpW7iSkZk2Io2RAkq2w3jDp+TVeGF8Gt0wWTAyRBBLHK9MObP40mXXcttt97Nr6zZOOumkh37wgx8cA4R/7Hv4X7n+6CvWS74JIQ4G/p+m6ccaplFZud9q8x3veDMnHHUwi+bPoeQYtNpN8jzFsQ0qrkmj1VTshVwJLl3HKTJKcqI4IslSTKH6sSxT3G/L0NFkBrrGE8++wEBfiXlzB9XjFYTkcYws+FK6ptEJYyUOsS2iJKMTxWRZRn+1xJbtY7zmrZ/nnD95A6vmwaYXdjNvpJ/5o4McsGI+nTDmhbEphvtKDA1UaLZSLvry9Ty3rcHKuTXuuft+DjtwBV/6p/eqqBDbYdd0mzSXlDyPLBM4jgOaw49uuYefrX+EyZ1jzJ83b+Itb37zX55zzjnf/d+9a7/9+j9RWN1LCFErlUrvdz3vr9I07R8ZHeGNZ76RE15+JMsXz2X5onlMz0zj+z6eYyBz5bJiFX4KFH6dShWdQpYihJJ8UcjWDA2EYzO66o3kUrB69WLeevbLectpR1MaLkPbh7S7XeZFBJ0oZpgocqOpMVlvc/RrL+TY447itOOW4ZZsDtlvMX4Yk6UZk40WWZ6xaHSIm+55nm/98BdYWUwStDnl5es4+7QjmTdnuLAJ0rEti5m2T9krY5kWgwP9jNcjPvvVq7j1tgeYOzzE0UceddWnP/Ovb/1jY1K/7Xr66aeN1atXpy/++v+pwtrzOv+9733PfQ8++LfPPPPMYsdxxL77react76JYw49kGWL5lEp2bQ6bWbqdTzHwrV1bNMgSRPSJMbUJIaWg0zQhVRBaN3oCUPjpDM/zrzhPnZPTHPvfU/guDYHrlvB33/0HI454UCIE4hilXWTK7+DoEh3cBybsckZTjj7n/j4X7yP4w/so9luMtRX5Zltuyk5OvOGB1n/4BY++aUfEXYC9lsxn1NOOIBTjlvLvNFhto5PU/U8to5NMWewDykMmu2QBXNGQDP5wc33cuU1t/P4Q4/z2tNPD88+88y3n3r66Vf9796Vva+nn356KfAvwCWrV6/+2Z5/93+2sLrXE48/0XfBxy+4+JGHHz5r1+7dluN56TEnHMuFF37c2G/FQsquRRxHpGlKHMVYhsSxNJIoxLE0hMyIogBDVwBrliY4ZY81R7+TQw5cyWf//jzGZ5rcevtDXPa9W9iydTe6Ljjp2HW8+9yTOfHYdWCZECWQFrQbHaYaLV5+1j/zzre/iZMPHyFPVTCV0AX3P7qFL33zpzSbPquWzefdbzqeQ9YsUgnzQue5F8ZYODrITMtH0w1Wzp/DWL3DyNAgT2zaxcWXXseTj2+kXPKyv/roR354/JHHX9A/Orj1f/tedK+nn35aAAcCHwSOBN60evXqx/b8nv/zhbXnde65586/6qqr/j1JkuOEEPbiZUvH/t8nPr7gtFNOcob7q9Qb0+giRyMjTkIcAyxdQxM5eabA0DQNsEs2Bx73bpYunMOFf/MuXtg1zqK5w/RVbKam6nzzilu4674n2bFjHE3AgetWcv47T+fVpxyJU3Egidm+6QVOOPMfuOAj7+fotTVG+mwu+8m9fON7P2fTpu2c8PIj+cs/PZ19lvSTpSnVcoVtY9PUKh4TMy36a7X/r71z/62yvuP46/s85/ac51x62p7eOL1QZNBuGStmEwKjBAyitow7js11IJAic6tli7hFHVEHTpKtATM1JkthIQwySDbjJlsWwVY6G2i5aJWLFE9vcC7t6fXcv/vhdAnZ0LkFLZS+/oLv88k7n+/zfJ739/0lnpBE45KvTSvmUk8fL+39I03NHxIZHE7MmTW7YcG88pqlq1a0jnXdr6etrU0BHIAHGAEul5SUfPYj9rcyo27Xh4DNwCS706kuWb4kvWbLeooL8zAZBAaSjISHMBoVNIPCSDhl1TGZVBIiwT0LNpCTlc6zz2yk+1oA3Zy6lPuqv5fMNJ28nExOtl7keNM5Gt5ppbvbjyKhqDCH5ZVzWffte5lT8STbtm4mOehl554/4A8OsmjxQuq2b0BNhFBlktBQKqg35XePo1ktqRx7CRaTmSmFBbxx/CS/fu0I3suduNMzOsvKytbX1dUdHeMy35C2tjZRUlLyX0VzWwrreoQQXwVqhKKs1KyaXjilWHnsB5tYu+J+VCVBNDKSsv2aVJLxaKp7uJ3MX1iF0Wzg2ac309vfj1Uz88FFbypMNhLF39fPrBlTyc/LxGQ00NEZ4PDrxzl27CTeTh9GVTA8HEXTNNLdGcz+5lx+uO4BJqUJLCLJ2fZuHLoOQtDpC/HlKfkAtLV3U1rkISvTRXtPkF2vHOLEu22E/P6+2bNm7zh48OAvx7aiN4fbXljXk52bu9Xv822WyaTH7nQML1tWMfTjrVsmZWc6hGZWMSkQi0Wx2jQWVa5HKPDy7qeIRcKcvdCO3arhtGnEk0mSsRiReIwLl71oJguKCovn3U2Gy0HrmQ/Z/mI9b/6lidnlc3ns0e9QVmSjtzdIUqg4dT0VkWQ2jLowFAaHIoRjUaZP9hAcCPPehSvs3H2AgC+Ey+H4e0NDwyopZXCsa3izGFfC+hdCiBzgeWCNEAKPZ9L539bv6ZxzT9kclaTLaHWyaPFyXC4HtbXr8Hb5MKkKudmZXPMHEUJgVFPTeZlIjA5ZFVrPfYBmNjD37mlkZ7qY/+DjrF27gnXLZhKNxglHkqM5qgppdp3hcIx4IoFTt6WinWw2+gbD/GTna5w59T7uDHd8zapVz9XU1Gwf65rdbD7lHq/bFyllj5TyEcAppXzU6+0w37tg6UKbo9j/3Ue2Hr10pSs5OBTGYtbIyykgMz0Lo0nnwpUernT66fL1ohgtDIcl/cMJVJMNs1kjOyubqUUFXA0MoggDVt1Kms2ObtHp8oUYCEfxBUPo1lSwrT80gK5pWCxmQiNR6v90jJWbnuLPR95kfVWV90Rj44zxKCoYg186XyRSygSwF9grhChIJBI/O3jg8H2Hfn9kwKRZzLrTYflbYwvu9DQyXOkEQkOku9LJz8viYrsXh1NHHR2KBvsGcTrSMFkMdPdcTZ0QMhgI9PUTGgpjsZgwGc1cC/ShCoWuQAiPO4NIHDo+9vHMC6+2Nr7drOu69XR9ff1zq1evPk/qq2pcMi63wk9DCGEElgohtiFEgaqqw9O+UtL1vaq1WWUzSovtNo32jztIS7PzUbuXdJedSDhCqH8QT24WZpNAFQlystxsrP4536q8n9Lp2UyfXJBK2wsN4NQ1NIsZoRj5x6m2pid+usMb8AdNwK+ARinlf0yqxxvjumPdCCllDDgEHBJClMaTydr3Ws5UPtFyJqnb7cc2/ai6peK+hfOiscjM4sIi4tEY/kAnToeTeFwQ7B9CVSAr20oyIQlHYhR6JmO3O7nW2YPV6sLjyaX57Hme37H7aHPTu1nACeBlKeW47VD/zh3XsT4JIcRaoBYoA7x3femutzbXbpmWn5s3q2RqEYlYnPaOTvzBIHk5bkqnTqZy6fd5+KFVLK8sJxwOIxSFgZEob73dzIu7dl8I+PwfARuklB1j+3RfPHdcx/okpJT7gf0AQoj6i+cvVmytftzqyshof3BZRVH5/HLyc7PJz9NIJuIE+wYZHg4zMBROHVvXjVzyXmXb07/wnW45fT4WjuwD6qWUt6St5fNmQlg3QEpZNfoutrg3EHjyQP3+zDeOvK7N/MbXleVrVgpPjpucHA+6VUvFASg2Gt9ppm7Pb7ynTrUcTibiu+7ELnU9E1vhZ0AIUWSz2WojkcgSIYTdZLFc3Vhd/dcDv9s3Y375PO+5c+9P6+npcft8voellA1jvd5bgQlh/Y8IIZaQih+YCRgBH/ASUHcr+aTGmglh/Z8IIazAUWCflPKVsV7PrcaEsCb4XPgn5qWlXcTz5AAAAAAASUVORK5CYII= width="150" height="160" alt="BoxJoint"></td></tr></table>]] .. BoxJoint.ToolTable .. [[<table width="550" border="0"><tr><td colspan="4" class="h1-r"><hr></td></tr>  <tr>    <td width="25%" class="h1-rP">&nbsp;Material Thickness</td>    <td width="15%"><input name="BoxJoint.MaterialThickness" type="text" disabled id="BoxJoint.MaterialThickness" size="9" readonly></td>    <td width="21%" class="h1-rP">&nbsp;Material Width</td>    <td class="h1-l"><input name="BoxJoint.MaterialLength" type="text" disabled id="BoxJoint.MaterialLength" size="9" readonly></td>  </tr>  <tr>    <td colspan="4" class="h1-rP"><hr></td>  </tr><tr><td class="h1-rP">Finger Count</td><td><span class="h1-l"> <input id="BoxJoint.NoFingers0" name="BoxJoint.NoFingers0" size="9" type="text"> </span></td>      <td width="21%" class="h1-c"><span style="width: 15%">        <input id = "ButtonCalulate" class = "LuaButton" name = "ButtonCalulate" type = "button" value = "Calulate">      </span></td>      <td width="39%" class="h1-l"><label id="BoxJoint.Units"></label></td>    </tr>  <tr><td class="h1-rP">Finger Size</td><td><span class="h1-l"> <input name="BoxJoint.FingerSize" type="text" id="BoxJoint.FingerSize" size="9" readonly> </span></td>      <td width="21%" class="h1-c">&nbsp;</td>  <td width="39%" class="h1-l"><label id="BoxJoint.Left"></label></td></tr>    <tr>      <td class="h1-rP">Fit Amount</td>      <td><span class="h1-l">        <input name="BoxJoint.FingerFit" type="text" id="BoxJoint.FingerFit" size="9">      </span></td>      <td class="h1-c">&nbsp;</td>      <td width="39%" class="h1-l"><label id="BoxJoint.Right"></label></td>    </tr></table>    <table width="550" border="0" id="ButtonTable"><tr><td height="12" colspan="3" align="right" valign="middle" nowrap class="h2"><hr></td></tr><tr><td><strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_BoxJoint_Maker-Page1" target="_blank" class="helpbutton">Help</a></strong></td><td class="FormButton"><span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td><td class="FormButton"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span></td></tr></table></body></html>]]

  BoxJoint.Dialog = HTML_Dialog(true, myHtml, 585, 586, BoxJoint.AppName)
  BoxJoint.Dialog:AddLabelField("BoxJoint.Alert", "")
  BoxJoint.Dialog:AddLabelField("BoxJoint.AppName",                  BoxJoint.AppName)
  BoxJoint.Dialog:AddLabelField("BoxJoint.Version",                  "Version: " ..  BoxJoint.Version )
  BoxJoint.Dialog:AddLabelField("BoxJoint.Units",                    BoxJoint.Units)
  BoxJoint.Dialog:AddLabelField("BoxJoint.Left",                     "")
  BoxJoint.Dialog:AddLabelField("BoxJoint.Right",                    "")
  BoxJoint.Dialog:AddIntegerField("BoxJoint.NoFingers0",           	 BoxJoint.NoFingers0)
  BoxJoint.Dialog:AddDoubleField("BoxJoint.MaterialLength", 	       BoxJoint.MaterialLength)
  BoxJoint.Dialog:AddDoubleField("BoxJoint.MaterialThickness", 	     BoxJoint.MaterialThickness)

  BoxJoint.Dialog:AddDoubleField("BoxJoint.FingerSize", 	           BoxJoint.FingerSize)
  BoxJoint.Dialog:AddDoubleField("BoxJoint.FingerFit", 	             BoxJoint.FingerFit)

  if BoxJoint.AppValue then
    BoxJoint.Dialog:AddLabelField("ToolNameLabel",                     "Not Selected")
    BoxJoint.Dialog:AddToolPicker("ToolChooseButton",                  "ToolNameLabel", Tool_ID)
    BoxJoint.Dialog:AddToolPickerValidToolType("ToolChooseButton",     Tool.END_MILL)
  else
    BoxJoint.Dialog:AddDoubleField("BoxJoint.ToolDia", 	             BoxJoint.ToolDia)
  end -- if end
	if BoxJoint.Dialog:ShowDialog() then
    BoxJoint.NoFingers0       = BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0")
    BoxJoint.InquiryBoxJointX = tostring(BoxJoint.Dialog.WindowWidth)
    BoxJoint.InquiryBoxJointY = tostring(BoxJoint.Dialog.WindowHeight)
    BoxJoint.FingerFit        = BoxJoint.Dialog:GetDoubleField("BoxJoint.FingerFit")
    WriteRegistry()
    return true
  else
    return false
	end
end  -- function end
-- ===================================================]]
function OnLuaButton_ButtonCalulate()                   -- Executes the calculation function from the dialogue
  if BoxJoint.AppValue then
    -- Version 10 or Higher
    BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "")
    BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "")
    BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
    BoxJoint.NoFingers0 = BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0")
    BoxJoint.Tool       = BoxJoint.Dialog:GetTool("ToolChooseButton")
    if BoxJoint.Tool == nil then
      BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "Aleart: Please Select Tool First")
      BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "")
      BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
    else
      BoxJoint.NoFingers0 = BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0")
      if BoxJoint.NoFingers0 < 2 then
        BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "Alert: Finger Count cannot be less than 2")
        BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "")
        BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
      else
        BoxJoint.ToolSize = BoxJoint.Tool.ToolDia
        BoxJoint.FingerSize = Rounder(BoxJoint.MaterialLength / BoxJoint.NoFingers0, 4)
        if BoxJoint.FingerSize < BoxJoint.ToolSize then
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "Error: Mill Bit Diamenter is smaller than Finger Size")
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left",  "")
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
        else
          BoxJoint.Dialog:UpdateDoubleField("BoxJoint.FingerSize", BoxJoint.FingerSize)
          BoxJoint.NoFingers2 = Rounder(BoxJoint.NoFingers0 * 0.5,  0)
	    	  BoxJoint.NoFingers1 = BoxJoint.NoFingers0 - BoxJoint.NoFingers2
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "Right has " .. tostring(BoxJoint.NoFingers2) .. " fingers")
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right","Left has "  .. tostring(BoxJoint.NoFingers1) .. " fingers")
        end -- if end
      end -- if end
    end -- if end
  else
    -- Lower than Version 10
    BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "")
    BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "")
    BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
    BoxJoint.NoFingers0 = BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0")
    BoxJoint.ToolDia = BoxJoint.Dialog:GetDoubleField("BoxJoint.ToolDia")
    if BoxJoint.ToolDia <= 0.0 then
      BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "Aleart: Enter a Correct Tool Diameter.")
      BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "")
      BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
    else
      BoxJoint.NoFingers0 = BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0")
      if BoxJoint.NoFingers0 < 2 then
        BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "Alert: Finger Count cannot be less than 2.")
        BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "")
        BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
      else
        BoxJoint.ToolSize = BoxJoint.ToolDia
        BoxJoint.FingerSize = Rounder(BoxJoint.MaterialLength / BoxJoint.NoFingers0, 4)
        if BoxJoint.FingerSize < BoxJoint.ToolSize then
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Alert", "Error: Mill Bit Diamenter is larger than Finger Size")
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left",  "")
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right", "")
        else
          BoxJoint.Dialog:UpdateDoubleField("BoxJoint.FingerSize", BoxJoint.FingerSize)
          BoxJoint.NoFingers2 = Rounder(BoxJoint.NoFingers0 * 0.5,  0)
	    	  BoxJoint.NoFingers1 = BoxJoint.NoFingers0 - BoxJoint.NoFingers2
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Left", "Right has " .. tostring(BoxJoint.NoFingers2) .. " fingers")
          BoxJoint.Dialog:UpdateLabelField("BoxJoint.Right","Left has "  .. tostring(BoxJoint.NoFingers1) .. " fingers")
          BoxJoint.Tool = Tool("Lua End Mill", Tool.END_MILL)
        end -- if end
      end -- if end
    end -- if end
  end -- if end
  return  true
end
-- ===================================================]]
function CheckDialogValues()                            -- Look at what the User inputed.
  BoxJoint.DialogLoop = false
  if BoxJoint.AppValue then
    if BoxJoint.Dialog:GetTool("ToolChooseButton") == nil then
      BoxJoint.DialogLoop = true
      DisplayMessageBox("Error: No Tool Selected")
    end
    if BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0") < 3 then
      BoxJoint.DialogLoop = true
      DisplayMessageBox("Error: Finger Count is below 3")
    end
  else
    if BoxJoint.Dialog:GetDoubleField("BoxJoint.ToolDia") == nil then
      BoxJoint.DialogLoop = true
      DisplayMessageBox("Error: No Tool Selected")
    end
    if BoxJoint.Dialog:GetIntegerField("BoxJoint.NoFingers0") < 3 then
      BoxJoint.DialogLoop = true
      DisplayMessageBox("Error: Finger Count is below 3")
    end
  end -- if end
end -- function end
-- ===================================================]]
function Rounder(num, idp)                              -- reduce the size of the fraction to idp places
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
-- ===================================================]]
function main()
  BoxJoint.AppName     = "Easy BoxJoint Maker"                    -- Application Name
  BoxJoint.Version     = "4.0"                                    -- Application Build Version
  BoxJoint.RegistryTag = "EasyBoxJointMaker" .. BoxJoint.Version  -- Registry Name with Versioning
  BoxJoint.DialogLoop = true
-- Job Validation --
  BoxJoint.Job = VectricJob()
  if not BoxJoint.Job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n")
    return false
  end
-- Get Data --
  ReadRegistry()             -- First thing: Get/Reads all data values from the Registry
	-- Read the Material Configuration and set global setting
	GetMaterialSettings()
--| ========================]]
  while BoxJoint.DialogLoop do
    BoxJoint.Inquiry = InquiryBoxJoint(BoxJoint.AppName .. " Version " .. BoxJoint.Version)
    if BoxJoint.Inquiry then
      BoxJoint.DialogLoop = false
      CheckDialogValues()
    else
      BoxJoint.DialogLoop = false
    end -- if end
  end -- while end
  --| ========================]]
  if BoxJoint.Inquiry then
    if BoxJoint.AppValue then
      BoxJoint.Tool       = BoxJoint.Dialog:GetTool("ToolChooseButton")
      BoxJoint.ToolSize   = BoxJoint.Tool.ToolDia
    else
      -- BoxJoint.Tool       = "Lua Tool"
      BoxJoint.ToolSize   = BoxJoint.Dialog:GetDoubleField("BoxJoint.ToolDia")
    end -- if end
    BoxJoint.NoFingers2   = Rounder(BoxJoint.NoFingers0 * 0.5,  0)
  	BoxJoint.FingerSize   = BoxJoint.MaterialLength /  BoxJoint.NoFingers0
	  BoxJoint.NoFingers1   = BoxJoint.NoFingers0 - BoxJoint.NoFingers2

    -- Building the vectors for the finger joints
    CreatFingerCutPaths(BoxJoint.FingerFit)

   if BoxJoint.AppValue then
      -- Build the tool paths for left hand joint
      CreateBoxjointToolpath1(BoxJoint.LayerName1 .. "-ReliefCuts", BoxJoint.ToolPathName1 .. "-ReliefCuts")
      CreateBoxjointToolpath1(BoxJoint.LayerName1, BoxJoint.ToolPathName1)
      -- Build the tool paths for right hand joint
      CreateBoxjointToolpath1(BoxJoint.LayerName2 .. "-ReliefCuts", BoxJoint.ToolPathName2 .. "-ReliefCuts")
      CreateBoxjointToolpath1(BoxJoint.LayerName2, BoxJoint.ToolPathName2)
    else
      -- Build the tool paths for left hand joint
      CreateBoxjointToolpath2(BoxJoint.LayerName1 .. "-ReliefCuts", BoxJoint.ToolPathName1 .. "-ReliefCuts")
      CreateBoxjointToolpath2(BoxJoint.LayerName1, BoxJoint.ToolPathName1)
      -- Build the tool paths for right hand joint
      CreateBoxjointToolpath2(BoxJoint.LayerName2 .. "-ReliefCuts", BoxJoint.ToolPathName2 .. "-ReliefCuts")
      CreateBoxjointToolpath2(BoxJoint.LayerName2, BoxJoint.ToolPathName2)
    end -- if end
end -- if end

  -- Regenerate the drawing display
  BoxJoint.Job:Refresh2DView()
  return true
end  -- function end
-- ===================================================]]