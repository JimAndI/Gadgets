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
-- This Gadget was writen by Jim Anderson of Houston, Texas. (January 2020) It supports all Vectric version to create both the Vectors and Toolpaths.
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
  BoxJoint.By                = RegistryRead:GetString("BoxJoint.By",            "By: James Anderson")
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
  body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px}</style></head><body><table width="550" border="0" class="h2-l"><tr><td class="header2-c" id="BoxJoint.AppName">-</td><td width="28%"" align="right" class="h1-c" style="color: #999999" "width:20%><label id= "BoxJoint.Version"></label></td></tr><tr><td><p class="h2-l">This gadget creates a series of tool paths for a boxjoint from the material job setup settings.</p><p class="h2-l">This requires the material to be held in a <strong>vertical position</strong> so that the milling can be performed on the end of the material to receive specified joinery.</p><p class="h2-l">The gadget assumes that the Boxjoint will run in the direction of the longest side of the material job and the material is a rectangle in shape.</p><p class="h2-l">Use the Top of material (top end of material) for the Z value. Set the materialthickness to the length of material.</p><p class="h2-l">For best results in cutting action, use &quot;up-cut&quot; spiral bits.</p></td><td><img src= data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCADPAMgDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD6pooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoorK1PW7ezm+yxB7q/27hbQ4LAdix6IPdiPbJ4oYGrmjNYVrHe3Ey3GpTBNpylrAxEaf7zcFz9cD/Z71qrNn7vPvWftFcrlZYopFOaWtCQooooAKKbKWWNjGodwOFJxn8axZfEllazCHU/M0+QtsU3K7Y3PX5X+6eB60mwNiQkqQCVPYjtVXzruHO+NLhR3Q7Wx9DwfzFTRzRyrujdWB6EHIoYHtWXO+hXKNt7+CdxGr7JsZ8pxtYfgatVRuYIrmPy7mJZEznDDOD6iqTWN1Av/ABK794+4iuQZk/MkMPzqo1ExOLRt0Vhf2ze2ZC6rpcoTHNxZnzox9Rw4/wC+T9a0tO1Oy1KPfY3MU47hW5X6jqD9a0Fct0UUUAFFFFABRRRQAUUVFdXMFpbvPdzRwQoMtJIwVVHuTQBLVHVNVtNMVPtUh8yQ4ihRS8kh9FUcn+nesqbV73Uvl0iL7Nakf8ft0hy3/XOLgn/ebA6EBhUdvawacJZw0k91JgSXErb5ZTxgZ4AGf4VAUZ4ArOdVRKUWx80uo6krC4ZtMtTx5ULgzuP9pxwn0XJ7hhT7OG1so/KsoVjXOSEGST3LHuT6k5NO2vIoMpAHXaD1+tVtU1Oz0qAS3syxKx2ooBZnP91VHLH2AJrjnWlLQ2jBLU0uv3zx/dzVSXWIVujaWqtdXa/eji6R+7t0X6dT2BrAin1XXcEb9JsSchVINxKv+0ekf0GT7g8Vv6ZZW+n26xW6hI1JIA9SeSfU+pPJqE7Ds2bNu5ZRnGe+DkVYFVITnGKtLXbSd0YzVhaKKK2IA1UvI0miaOVFkRhhlYZBHuKtmq81ZVXoVDc5G48LQW0zz6Fc3GkzsQWFucxN9Y2yv5AH3qOPW9e0WMf25ZJqNuvW605TvA9WhJJ/75LfSuokqq64Py4B9Oxri9q1ubci6Bo/iHStZDf2fewzOpw0ecOv1U8j8q0iAfunFchrHh/TNSkV7yzQTR/cmHyuv0YciqcUPiHSWzYakl7bjH7jUATge0qjP5g1SrRYuRo7sMR1qjf6TYX7+ZcW6icfdnjJSRfowwa5+LxvFa7U8QWF1pnZp2Akt8/9dF6D6gV09leWt/AJrK4iniPR43DD8xW0ZNbEuz3M7yNasObK8i1CEDHk3o2OPpIo5/Ffxp6+KbOCUQ6vHNpUpwAbsARsfQSAlD+efatXpTZEWWNkkVXRhgqwyCKtVX1J5OxajkSVA8bq6HoynINOrkm8J2lszyaDPc6NMx3H7G2ImPvEcofyz704X/ibSz/ptjb6xbL/AMtbJvJnxnvG52nj0YZPatI1EyWmjq6RmCqWYgADJJ7Vy8fjWxvfPh0e3u73UIX8uW1aJoTC3/TRnACj8yR0BqtLZveMJfEtwlwSQy2SZFvH0429ZDnu4PTIVaJTUdwSbNKXxA15lNAgW7HQ3chK26/Rusn/AAHI4wWFV/7OUS/bNVna/uossryLiOE/9M4+Qp9+W7ZNTia5kYeUkcUIOAzgliB6KPp61YFsCo+1OZBj7rABfy/xzXPKo5aGiikV/LmuWYuzpEeAqnBIHcnqKfcNa2MElxcSRwRRqWeWRsBR6knt0rB1TxcjNJb6FAL+VSVabdtt4iM53Sc7iOflUE56461jrpsl/dR3OsXBvrhG3KpG2KLp/q48kAj+8dzf7WDXPOSW5pFN7F678SXepMIvDltiA9b+6QhCMdY04L/U7V5BBajTtKhguvtNw8l5qDDDXExy5B5wOgUZHRQB+tW4kIG1RubPOwDAx6mrKBUwsjqB0AziuZ1G9jZQS3LcLHOMgdeFGasLMEfaqmSbuq8kfU9B/nFVNzSfJETGndgMH6DP8z/+q1CUgjwqhFHJLN+pP9TWsfMhmjbbzy+AfQdqvL0rNtJPM5UHb/eNaKdK76GxzzHUUUV0GYhqvNUzuqthjg1BLzWFbYuG5WY+tRsuRxUrUzGOR+lcDSZ0XK7Jj0Az2qB4j1T6j0q/kHrj6jpTHQZJIGfWpcUO5lvCDuygyQVPyj/OKw7zwvp0szT2iyWF2T/r7GQwuT6nHDfRga6mQeuPr2qF0BOcDj0qVNxegOKluYsd54l0532yW2sW/VUnAt5x7blBRvxVauw+NdNjkWLV0uNImZtqi+TZGx7ASgmM59mzVtkI5HpwQOlI8QlVkYIysMFSudw7gg8VtHEfzIh07bMu3WsWltHC28zPOMwxwje0v+6B1Hv0Hcis28S7vlL6xcfYbHta28pV2/35Bg5/2Ux9WFeY+EtO+yx6hf6Rcy2NzLe3efIf5MLcShFZHyu3A7bcAda6iw8Q32ns82saeL/c2Bd2OdxHTiJzkD2Rmz1xWzetoszv3Ous0EUKwWFslnbqflRVCnGeSF6DPqeeelWY7SKDLgje3ViTz/jzWPb+K9HntHukvoIlT/WLOfLkQnoCjYbJ7ZHPasW/13VdUcxabDJYWp4N1Mg85+n3Iz93r1f/AL5qHK3xFpX2Oh1bXbPS3SNt81467o7eIbpnHqF7D1JIA7mudvRfawf+Js3k2rfdsIZDhh/01cY3/wC6ML1zu60WOnRWXmeWm+eQ5d2O93bB5dzkseeM9O2K04rbYx8wjLDkAcn1rnnWb0RrGn3K8FuiAKFVUACoijG0dBgdh1qyzJFHumkWGEHJLNgHnuTUazoz5to2n7AouFH/AAI4HX0yafb6ekbi4vSs1z13HnZ7IOw/U981moOWrLulsEbSSr5dpEUj7zOuAPZVPJP1GPr0q7bQR267VBZyPmJOWb6n/P0qL7SGbECuyqcZGMenU9fwo3OyAfLGh6sCRnH+feqVo6C3LKygsVjUvg4JBwB9T/hU0cKFszYkIOQuOBz6evuagix5YRB8oGBjirkf+18vPA6k1cWS0X7Y5q+nSqFqMYwPzq+nSu+hsc1QdRRRXSZiMMjBqhcRFCTGzLnnA5Ga0KrzVlV2KjuZvmuGO5Qw7lOo/A05JUdiI3ViOSvepnjVjkjnse4qtMhPTkjoc4YfjXns31JGIPXKmomDDp09qYvmchXD852uMEU7zMYDKUPTnp+dZPUtC5z7Uhjz2x7ipCc/eFKDipsVcrmL0wR+tIyFuuCe3Y/nVn5e/BoOe2D9aaQmzzNdA8SaPFcx29vYahavPPJEkc7QzKskruB83yNgMMjK5/DJDrttFcJa6mtxp906lRDfJ5eScg7G+63UdGI5967ax8Q6Tf3c9rZ6laSXELtG8IlG8MpII29eCMVZvLSC7t2hubeGaFuGSRA6n8DxW8p2+JGKhfZnDajElx4s8PjYTclbo78cBdo6D8ue+c1dv9csdPunsrWOa+1EDLW1om9x6b2ztQe7EZ7Vl6x4VsrfxXpEGnXOo2Ns1pdMYbe5ZQcNCNqk5KA56KV6DHStix0y00q1W1soEt7aPnagxk8EsxPUnuT9eaU3FpN/1qXC6ujB1S41tJdLu5JRbI9/BGbKzO7KseQ7kZdsDttUe/Wuvjtprly9yqxw44hB3bvdz3+g469eMc7Lex65eabFpCtcW1reC4nulGIflUjarn75yR93IHOSMYPST3LPvii+aUDhUOAPdj2H+RWE21ZWsaxt3LWdrAR8kdTjAFUpmMsohV2IxmRs8Af3fqf5fWlS3aTmWQy+3IjHXt3H1zVuOJEH64Ax37AVmrl7jEUtgJjYPbAGMVNGiqRltzdiR/KkyzcDp61ICFzg5J6mmgZMgIHJxx+NTQ4x8o+v/wCuqE08iyRLEqjzCRvbouBnp3pY5t0hXdNcFW2sQQqKec8jH5c9q3ijKTNm0kVnKr8xXg46D2rSTpWXYBsZYKoPIC/4961E6V6FDY5qg6iiiugzCq81WDVeasq2xUNys1Mb3GaeeaaVNedI6UQvGGxkBsdARmmbP4QxHs3NSsMVGXPcVk5JblJEexlX5W2j3+Yf/WpVLY+6T7qcinZ7gkUhPOSCD6rSugsxVcHipMZ6HFQt8452uPcYNRs5RsfeB7NwfwNO6DU8ttRbT2F9Dqtil3brqN6EzGJetxJnjqp6nI/ma0tNe7sWH/CP6hK1uDtNtcq88SgAn7xwynp0YgenSr8nhW5tri8n0HVArzSyTm0vohIgdyWO1hhlBYk87vpWRdJcWKvLrukXULKNongH2mMAZ5DIN6jnksq9K3509EY8rWpYv9XvbrxZp4XSS94NPuoisdwvlqTJbnLOQCo6dFJ+YYB5xZbSPtM0f9vzC/kPzJYxgi3TnqV/j+rkjI4Cmqmhzw3Xie0ltNTS7tjptyVnXb0EsORkcY6ds8cmr82uIxK6JCl5ubD3Msu2Ef8AAzkvj/ZyO2RxTktFyoqL3cjVRJplCJ+5iBCjb8zfT0XHTv8AWrkNusUYQDjrtXp36nqee9cPNHetrXh27vbqS4me/KEAmOJF8mUkJGCRgFR8zEscdcV3u7PTIH6muWa5djeGoE4zzgdsGmgjc3BwOMnjP9aU57ZzjkntVeSQHpIqqDzI3Qc9B/jWZZY3/LnICjqegqKSbywuWRDjh5eAPovU/pUBO8H7Om5/+e0v3V+mev4fnU1rbJCqlV3Pgb55fvE46/jVRJYqKbksYiyx4Kmdxhj67B2Hv+XrWnbosaKkYCqowO/5VAgHGAfXLdfy7VajJBOB+XWuhGTL1qMev41fTpVG2/zznNX16V30NjnqC0UUV0GYjEKOelQTH0qwao3FrHndHmNvVOP06VlV+EqO4zODRu9KrkXEZxlZR6n5T+NN85WOHDRt/tDH6157OhEshz1H4ioj+dPJYehFR5BPofyrCWpaE4NHI96dtJ54NGP8mosVcbgE+9BXIwfmHoaeV9RRt9Kdh3Oci1XSdSvGtbS+g+1RsyiN+OVYq2zODwwxxxxWjHJdW/8ArxuUdyCf1A/mK860fyXsL221KBZVF9eJkhSDm5lIGc/Kcnj8/pr273dioOl3zIGUyfZ7omVSOD8uTkenBxz9K6HTV9DDnZD4o0azuPGEV3HpVgJDYu9xLM+1H/eIAzhf9btAPDY6jkVJdSeVGZ7m4jht1G2Se4XYozgYVTjHB/Hgc9o2vNTvvFEUcOlwRSiwmUzSTfuR86fMAPmznIxgd/mrUXTrazuUub5pNQ1LBKMyjMfXPlp92Mc4z155Y1U3ZJMUVe7RmQWEupahptzFbvFDbXH2h7i7G2SXEbqEjjwCBl85bb7A5rrJJkRsM3zf3V5P5Vn3Vyomt4rueKBrhtkMPm4MjdSB0LHHYcepq6toq8N8w/uKoA79a556m8dCFTLOxDBfUrn5UyOAfU1ajgVGDt88nYngL9B2/nThtjXC9PRRj1pGOfvevT/P4VmWhSVP+0QeMjjP0pIyxfKktgA8Ece1NXDknGRn14/z0qQYVlB+b27fgKaEyeMgLktweCQcA9uvep42+XPAjA5LHAGPQVDGgxuk7DOWPAog/wBIleVhujyBEDyMYB3Y9c/yroiZSNSzcOBtyw/vEYFaS9Ko23+c1eXpXfQ2OeoLRRRXQZhUEtT1DNWdXYqO5Ufg1E4VuGGR6GpWpjDNebI6UVWhkj5gkP8AuvyP8aUToTtkBVumGGM1NjHfHsaGCsCGHHrWdhjdoP3SRSZYds0z7LH/AAF09QrYp3lyKOJC3+8BSsApce4puSfQil3ZO11Knsexo2egpO5SOL1TwRmWWbRdTnsWlkeaS3lHnQyMxJbg8jJJ6HHPSsC4tNT0qQf2jp32aNUwbyyAmgLHqWTG5RgYzgdetdTZ+N9NkaRb2O5sgk0kPnSxkxMVdlzvHA+73xXTWskV1CsttIksTDKujblI9iK0vUjpJGfLCXws8wstWhTWYbu41eyitBp8v7/PUCWLueAxyPXnPFW21O/vmH9jR/Y4XIDX96uZpFzj5IuNo9N+Ov3DVvxFpWmRePrS6NhbC5+wSv5qxqGLCSMZzjrgnmql1qMcF0kIV5bmUhktoh5jsuRk47DPdjgY7VbtpZaiV1dXIm062s9e8OzIHlunvXLXUz+ZK4+zTcZ7Ln+EYA7Cu5bJBHQd/wD9Vcvpun3s+oWl9qDxxm1LGG2iO4hmXaS7/wAR2seFGAT1auhLbuDkHH/6xXPUld7m1NWRPjacAEsepphZQv7zBPGQDxzx+NRPIQDkYXHI4pjP5w227Hk4eRedq89D0z29qyNCYzAOq5+fHQDceo7Dt70qB927aIcgdQGc/wBB+tLGFiXbEu0dSx6n3PrRGB5nygsTzkmqTE0TRwCQB52L9xuPAq/CAOgJ9+lZ0Nw0jHylLY4Mh4Uf59vzq/CnP7xix5PPAH4V0RZkzRg7VdXpVKDtV1elehQ2OapuLRRRXQZhUMxHTPNTVFMiuuGAI96zqaocdyowphoeHYcxuy+2ciq7TOpxIhx/eXkf41509DpjqT5pMf3TiolkDfdYe+KNxHUfiKx5kVYkPqRj3BoBz0INND/jS5VvY0XQCsFdcOAQeoYUgjCn5SQPSlwQOPmHvSZA7ke1UI830NWS0vEP7wx6leoqEA4JuJCOecDB6D/Gi30e0t5DLpc9zp0znPmWbY34yDlQNjckdQa6nUfDGl3k0k6wPa3MhLNPZuYmYnqWA+Vif9oGsWbQ9YsifIlj1aA5DLlbecKe391vzQV1RqxlsYOm1uYsNtrGr+K5IL/VonggsVYzQwqJZFaRgB3QdOTjkAYA611Gn6TaabC0dnEI953yPuLO59WYnLHjHOa5W219NM8WXiTWF+17Np0ey0+zlZCVkkJJY4Xbgj5s47Ak8VZnXV9YkaPU5o4bdjj7HaSFQFzyJJeGbpjC7Qec54znWi3a7sjWm0vNmsdf05dah02KUyXM8piJhUskbBGfDt0BIQ8deOnerzTqSIrJDMy5yVICrx3bt246+1c5c2MEeqeGLRIoxAtzI3lpGFVQLeUYwOO9diiKiqqBVCjAAGMD2HauOajG3KdEW5blWCxGd92/nEHKoeEXHt3PufSrTuFXgAKB9AKZPIkYzK3XjHUn8Kr7XuWRpMxQA7gpx85xxx6d+eeB0rPcvbYcZ1ZsKGlJP8KkgD64poWa4P73Kwgj92OM9Op79+BVjdjhvyx09KaQxbHRQOOMY6VSJZYjZU2jHQcDGABj0q7CxP3uP6VnxjoQdobkkck596hGrxC4azsIzqGorjdbwH/V5xzI/RB9eTjgGuilGUnZGc2ludTanIq8OlZ+mWtyke+/kjaU87IhhE9hnk/U/kK0K9WlBxWpxyldhRRRWhJFczrbxmSQOVHXYhYj8BzUUN5BdKTbypIAcHa2dp9D6VaqhqGlW198zh4pgcrNA5jcH6jqPY5HtSauGok5I5HIqtuB9qo3Nvr2n/NCYtWtwOVJENx36H7jHp12VTt/EFlLdi1uGayvScfZrtPKc47jPyt/wEn61w1aEt0bQqrZmvJGrYJyD/eXrTQJFP3gy+45o8wAkAkH0HNKHU9Ouecc1xyi1ubpphuB+9gH17Gnc/WkIDDBGfcU35x90hvZhUDJFODxxT92RzUIl7OpU/TIp4x1FVcLHnuia/rX2JbiWeyukaWUmOZfJdUEjKoDKSCcAcFR7mugtfFenSNHFqSS6bO52qt2oVWP+zIMofzz7V57a3F7oBkttQVrOWS6ndY7tCImDSuylJASjHDj5evtWpDqDTnZcRrh8KIp8NGwJBBJIORyejE5/CuiXL1RgpSRtaxJGPFd+7yBVXTrY7ycAKZJ889gcD8qzIbm91GQDQ7XFtkAXdwNsZ91XO58564A6/MOar+G9G04eKNVZrfbDFaWjxQ7iYUy1wdwT7vGOOw5I9a6nULuCyt3nvrhbW2zjc7YaQnsO/0A5PYVnUklZJX0NIJtNvQp2OjWtjcpd3sz3uo5JSWbny93BEaDhBzjjk9ya1ENy4ABWLrgY3Edq5uLXbqTV9JFtYi20+6uDEzz8TSfupHXC5O0fJ/Fzz0FdWzbeOh9M/zNc9Tmv7xtC1tBiRpCxYktM3c8n6e1OJbJJOD2Gen1qINtJEY+Y+gxSPIobs5HOc8L/nH61CTb0KbSRMCOsYAA43twB9Kp6hqdrpkAnvJGQu22JdhaSVj0VEAyxOOgyaoWt9fa7cGLw3aiePcQ2o3HFsgB6Aj/AFhznhOOOWFdd4f8K2mlXH264d77VmTY95MPmA/uovRF9h17knmu+jhG9ZHNUrraJh2mgarr+H1WSXStMYAi0hfFxIPR3B+QEY4Uk/7Q6V2WmadZ6XaLbafbx28C8hI1xk+p9T7mrdFelGCirI5m29WFFFFUIKKKKACiiigAqrqWn2ep2j2uo2sN1bv96OZA6n8DVqigDkJvB0lmS3h7VbizTIP2S5zc2+MfdCsdyD/dYfSqFxqeoaSP+J/pcsMa4BvbVzPB9SAN6/iuB3Nd9RUSpxlugTa2OT0/Ura/t0nsrm3u4W5WSGQEH8uP8O9XlkV8YIOenal1TwppOozPcG3NretjN3aMYZuDkZZcEj2ORWVJpXiDSyzQTw6zbZJMUoEFxjsAw+R/xC/WuWeEX2TWNZrc18A9fyIphjx9w4+lZdpr1nJcJZzmWzvGO0W95GYnY+i5G1/qpPStY46jHpXJOjKBtGakVLqPz43iuYo5YXGGR1BB9j2rlrrwZp5O7SpJNNkzu8tVDwseOqNxjA6KV6mua8O6nqsOlw3UWrSl9ziWG9HnRMVcqQCDvXO09yBnoeg3bXxuqxk6po93FEBhriyH2uLP0UeZ37pxWbpzi/dGpwktTF0+11PR/EWtwC3s45Jba2cXLymSMYM+CI8A54PBOBjqc4p0a+dqDzRbr25Rthvbl8rGx5IXkADBHCAZxg8mkvtW8P6xr13eQXq3EC2UEWEkfJbfP8hi6lsHO1hnnpVuK3vr4oHzpNoGyoBVpipboByqD3+Y8/w81s+ayvpoQrXsiE7F8S+HrVriS4uI55LmbuY0W3kUEqPugs+M47da7MsA2GJDHsPwrEtbaw0Wyl8tYrS2Dbp55HIJbuzscndjHJOeRz0q9pumaprjb7YPptg3/L1NGPOlGB/q4yPlHfc4/wCAkciVQdVqxftORakF9q0VtdLaQxPe6g+DHaQLukkGRljngLyfmbCj1rQ0vwZd6kFl8WTo8PB/s63c+W3/AF2frJz24X1BrqdA0HT9BtPI06HZnmSVyXklPq7Hlj9a1K9Glh40zmnUlLcbFGkMaRxIqRoAqqowAB0AFOoorcgKKKKACiiigAooooAKKKKACiiigAooooAKKKKAK99ZWuoW7QX1vFcQt1SVAwP51z7+FZbL5vD+p3FmAOLa4zcwH0GGO5R7KwHtXUUUmk9wPHJtE1zQbJIL+ya4hQvI13p+ZVBZizExHDL1PIzVC3uU1INLYut0V+UyxNl4/XoMg9OMg98dK9yrE1rwro2syCW9sk+0KMLPGTHIBnP3lwe3SodKLFr0PMLC1ifXmulhUXUlmA0zqA2A7YY9zjcPXpWvbSXk1y1npsAurraSUztjiyTt8xx93twMk9hXRQeBY4dS+0Lqd2YfL8srtQSY3bsBwBgfhu6YYV1VjZ29hbLBZwpDCvRUGPxPqfeo+rxvqWpuxzujeEYoLhLzWJ/7QvEO6MFNkMJ5wUjyRnk/McnntXU0UVsoqKsiQooopgFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB//Z width="200" height="204"></td></tr></table>]] .. BoxJoint.ToolTable .. [[<table width="550" border="0"><tr><td colspan="4" class="h1-r"><hr></td></tr>
  <tr>
    <td width="25%" class="h1-rP">&nbsp;Material Thickness</td>
    <td width="15%"><input name="BoxJoint.MaterialThickness" type="text" disabled id="BoxJoint.MaterialThickness" size="9" readonly></td>
    <td width="21%" class="h1-rP">&nbsp;Material Width</td>
    <td class="h1-l"><input name="BoxJoint.MaterialLength" type="text" disabled id="BoxJoint.MaterialLength" size="9" readonly></td>
  </tr>
  <tr>
    <td colspan="4" class="h1-rP"><hr></td>
  </tr><tr><td class="h1-rP">Finger Count</td><td><span class="h1-l"> <input id="BoxJoint.NoFingers0" name="BoxJoint.NoFingers0" size="9" type="text"> </span></td>
      <td width="21%" class="h1-c"><span style="width: 15%">
        <input id = "ButtonCalulate" class = "LuaButton" name = "ButtonCalulate" type = "button" value = "Calulate">
      </span></td>
      <td width="39%" class="h1-l"><label id="BoxJoint.Units"></label></td>
    </tr>
  <tr><td class="h1-rP">Finger Size</td><td><span class="h1-l"> <input name="BoxJoint.FingerSize" type="text" id="BoxJoint.FingerSize" size="9" readonly> </span></td>
      <td width="21%" class="h1-c">&nbsp;</td>
  <td width="39%" class="h1-l"><label id="BoxJoint.Left"></label></td></tr>
    <tr>
      <td class="h1-rP">Fit Amount</td>
      <td><span class="h1-l">
        <input name="BoxJoint.FingerFit" type="text" id="BoxJoint.FingerFit" size="9">
      </span></td>
      <td class="h1-c">&nbsp;</td>
      <td width="39%" class="h1-l"><label id="BoxJoint.Right"></label></td>
    </tr>
</table>
      <table width="550" border="0" id="ButtonTable"><tr><td height="12" colspan="3" align="right" valign="middle" nowrap class="h2"><hr></td></tr><tr><td><strong> <a href="https://jimandi.com/SDKWiki/index.php?title=Easy_BoxJoint_Maker-Page1" target="_blank" class="helpbutton">Help</a></strong></td><td class="FormButton"><span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td><td class="FormButton"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </span></td></tr></table></body></html>]]

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
  BoxJoint.Version     = "3.3"                                    -- Application Build Version
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