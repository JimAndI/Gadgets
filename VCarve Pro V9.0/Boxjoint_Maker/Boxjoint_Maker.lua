-- VECTRIC LUA SCRIPT
--require("mobdebug").start()

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

]]

require "strict"

--[[
Create Boxjoint Vectors and Toolpaths by Jim Anderson of Houston, Texas. (Mar 2015)
Boxjoint Toolpaths program is very heavily based on 
code from Vectric's core software SDK, Brian Moran and many other great developers.
]]

--Global variables
g_MaterialThickness = 0.75
g_MaterialLength = 4.0
g_offset = 0
g_ToolSize = 0.125
g_layer_name1 = "BoxJoint_Lefthand"
g_layer_name2 = "BoxJoint_Righthand"
g_units  = " inches"
g_NoFingers0 = 7
g_NoFingers1 = 4
g_NoFingers2 = 3
g_FingerSize =  g_MaterialLength / g_NoFingers0
g_toolpath_name1 = "Boxjoint toolpath left"
g_toolpath_name2 = "Boxjoint toolpath right"
g_tool = nil
g_orantation = "Y"
g_direction1 = 0
g_direction2 = 0
g_direction3 = 0
g_direction4 = 0
g_bulge = 1.0
g_default_tool_name = ""
g_title = "Boxjoint Toolpath Creator"
g_version = "1.1 by Jim Anderson"

-- ______________________________________________________________________________

function Round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end  -- function end

-- ______________________________________________________________________________
-- Polar2D(point2D, radians - angle, number - distance) 
-- the Polar function is an AutoCAD & AutoLisp function to set a 2D point 
-- from a know point with angle and distance. do not have to pull the 
-- 2D point apart and push back together
-- ==============================================================================
function Polar2D(pt, ang, dis)
  local y_ = dis * math.sin(ang)
  local x_ = dis * math.cos(ang)
  return Point2D((pt.X + x_), (pt.Y + y_))
end  -- function end

-- ______________________________________________________________________________

function GetMaterialSettings()
  local mtl_block = MaterialBlock()
  local units
  if mtl_block.InMM then
    g_units  = " mm"
  else
    g_units  = " inches"
  end			
	if mtl_block.Width > mtl_block.Height then
		g_MaterialThickness = mtl_block.Height
		g_MaterialLength = mtl_block.Width
    g_orantation = "H"
	else
		g_MaterialThickness = mtl_block.Width
		g_MaterialLength = mtl_block.Height
    g_orantation = "V"
	end
  
  if mtl_block.Height == mtl_block.Width then
      MessageBox("Error! Material block cannot square")
  end
    -- Display material XY origin
    local xy_origin_text = "invalid"
    local xy_origin = mtl_block.XYOrigin
   
  if  xy_origin == MaterialBlock.BLC then
      xy_origin_text = "Bottom Left Corner"
    if g_orantation == "V" then
      g_direction1 = 90.0
      g_direction2 = 0.0
      g_direction3 = 90.0
      g_direction4 = 180.0
      g_bulge = 1.0
    else
      g_direction1 = 0.0
      g_direction2 = 90.0
      g_direction3 = 0.0
      g_direction4 = 270.0
      g_bulge = -1.0
    end
       
  elseif xy_origin == MaterialBlock.BRC then
    xy_origin_text = "Bottom Right Corner"
    if g_orantation == "V" then
      g_direction1 = 90.0
      g_direction2 = 180.0
      g_direction3 = 90.0
      g_direction4 = 0.0
      g_bulge = -1.0
    else
      g_direction1 = 180.0
      g_direction2 = 90.0
      g_direction3 = 180.0
      g_direction4 = 270.0
      g_bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.TRC then
      xy_origin_text = "Top Right Corner"
    if g_orantation == "V" then
      g_direction1 = 270.0
      g_direction2 = 180.0
      g_direction3 = 270.0
      g_direction4 = 0.0
      g_bulge = 1.0
    else
      g_direction1 = 180.0
      g_direction2 = 270.0
      g_direction3 = 180.0
      g_direction4 = 90.0
      g_bulge = -1.0
    end
  elseif xy_origin == MaterialBlock.TLC then
      xy_origin_text = "Top Left Corner"
    if g_orantation == "V" then
      g_direction1 = 270.0
      g_direction2 = 0.0
      g_direction3 = 270.0
      g_direction4 = 180.0
      g_bulge = -1.0
    else
      g_direction1 = 0.0
      g_direction2 = 270.0
      g_direction3 = 0.0
      g_direction4 = 90.0
      g_bulge = 1.0
    end
  elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
      xy_origin_text = "Center"
    if g_orantation == "V" then
      g_direction1 = 0.0
      g_direction2 = 0.0
      g_direction3 = 0.0
      g_direction4 = 0.0
      g_bulge = 1.0
    else
      g_direction1 = 0.0
      g_direction2 = 0.0
      g_direction3 = 0.0
      g_direction4 = 0.0
      g_bulge = -1.0
    end
      MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
  else
      xy_origin_text = "Unknown XY origin value!"
      MessageBox("Error! " .. xy_origin_text .. " Must be set at a corner of the Material")
    if g_orantation == "V" then
      g_direction1 = 0
      g_direction2 = 0
      g_direction3 = 0
      g_direction4 = 0
    else
      g_direction1 = 0
      g_direction2 = 0
      g_direction3 = 0
      g_direction4 = 0
    end
  end  
  -- Setup Fingers and Gaps
  g_NoFingers0 = Round(g_MaterialLength /  g_MaterialThickness, 0)
  g_NoFingers2 = Round(g_NoFingers0 / 2)
  g_FingerSize = g_MaterialLength /  g_NoFingers0   
  g_NoFingers1 = g_NoFingers0 - g_NoFingers2
	return true                
end -- function end

-- ______________________________________________________________________________

-- Build the finger box points
function BoxPoints(pt1, LayerName)
  
  local line = Contour(0.0)
  local job = VectricJob()
	local layer_manager = job.LayerManager
	local layer =  job.LayerManager:GetLayerWithName(LayerName)
	if layer == nil then
		DisplayMessageBox("Unable to create layer - " .. LayerName)
		return false
	end
		   
  line:AppendPoint(pt1) 
   
  -- Draw line from pt1 to pt2
  local pt2 = Polar2D(pt1, math.rad(g_direction2),   g_MaterialThickness )
  
  line:LineTo(pt2)
    
  -- Draw arc from pt2 to pt3
  local pt3 = Polar2D(pt2, math.rad(g_direction3),   g_FingerSize )
  line:ArcTo(pt3, g_bulge)
  
  -- Draw line from pt3 to pt4
  local pt4 = Polar2D(pt3, math.rad(g_direction4),   g_MaterialThickness )
  line:LineTo(pt4)
    
  -- Draw arc from pt4 to pt1
  line:ArcTo(pt1, g_bulge)
    
  layer:AddObject(CreateCadContour(line),true)
  
  return pt4
  
end -- function end

-- ______________________________________________________________________________


-- Build the fingers joints
function CreatFingerCutPaths()

  local BasePoint = Point2D(0,0)
  BasePoint = Polar2D(BasePoint, math.rad(g_direction1), g_FingerSize )  
  
  -- Loop the BoxPoints for each fingers on part 1  
  for n=1, g_NoFingers1 do
    BasePoint = BoxPoints(BasePoint, g_layer_name1)
  
    -- Move the BasePoint 
    BasePoint = Polar2D(BasePoint, math.rad(g_direction1),   g_FingerSize )
  end
  
  -- Loop the BoxPoints for each fingers on part 2
  BasePoint = Point2D(0,0)
  for n=1, g_NoFingers2 do
    BasePoint = BoxPoints(BasePoint, g_layer_name2)

    -- Move the BasePoint 
    BasePoint = Polar2D(BasePoint, math.rad(g_direction1),   g_FingerSize )    
	end
  
  return true
end  -- function end


-- ______________________________________________________________________________

--[[  ---------------- SelectVectorsOnLayer ----------------  
|
|   Add all the vectors on the layer to the selection
|     layer,            -- layer we are selecting vectors on
|     selection         -- selection object
|     select_closed     -- if true  select closed objects
|     select_open       -- if true  select open objects
|     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
|  Return Values:
|     true if selected one or more vectors
|
]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
    
   local objects_selected = false
   local warning_displayed = false
   
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
               if not warning_displayed then
                  local message = "Object(s) without contour information found on layer - ignoring"
                  if not select_groups then
                     message = message .. 
                               "\r\n\r\n" .. 
                               "If layer contains grouped vectors these must be ungrouped for this script"
                  end
                  DisplayMessageBox(message)
                  warning_displayed = true
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
-- ______________________________________________________________________________
function CreateBoxjointToolpath(job, layer_name, toolpath_name)
  
  -- Clear any current selection
  local selection = job.Selection
  selection:Clear()
  
  -- Get layer by name
  local layer = job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
  -- Select all closed vectors on the layer
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
  -- Create object used to set home position and safe z gap above material surface
  local pocket_data                 = PocketParameterData()
        pocket_data.StartDepth      = 0
        pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
        pocket_data.CutDirection    = ProfileParameterData.CLIMB_DIRECTION
        pocket_data.CutDepth        = g_MaterialThickness
        pocket_data.RasterAngle     = 0
        pocket_data.Allowance       = 0.0
  
  local create_2d_previews          = true
  local ramping_data                = RampingData()
  local lead_in_out_data            = LeadInOutData()
  local pos_data                    = ToolpathPosData()
  local geometry_selector           = GeometrySelector() 
  local toolpath_manager            = ToolpathManager()
  local area_clear_tool             = nil

  local toolpath = toolpath_manager:CreatePocketingToolpath(
                                              toolpath_name,
                                              g_tool,
                                              area_clear_tool,
                                              pocket_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              true
                                              )
  if toolpath == nil then
    MessageBox("Error creating toolpath")
    return false
  end
   return true
end  -- function end

-- ______________________________________________________________________________
function LoadDialog(job, script_path)
	local registry = Registry("BoxjointToolpath")
	local html_path = "file:" .. script_path .. "\\Boxjoint_Maker.htm"
	local dialog = HTML_Dialog(false, html_path, 675, 600, g_title)
	dialog:AddLabelField("GadgetVersion",                   	g_version)
	dialog:AddDoubleField("NoFingers0",                    		g_NoFingers0)
	dialog:AddDoubleField("MaterialThickness",                	g_MaterialThickness)
	dialog:AddDoubleField("MaterialLength", 	       			g_MaterialLength)
    dialog:AddLabelField("DrawingUntsLabel",                    g_units)
	dialog:AddLabelField("ToolNameLabel",                     	"No Tool Selected")
	dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", 	g_default_tool_name)
	dialog:AddToolPickerValidToolType("ToolChooseButton",     	Tool.END_MILL)

	if not dialog:ShowDialog() then
		return false
		-- Quit and return
	end

	local tool = dialog:GetTool("ToolChooseButton")
	if tool == nil then
		MessageBox("No tool selected!")
		return 2
		-- 2 value will return user to Boxjoint dialog
	end

	-- Collect the Dialog values and update global variables
	g_tool =				tool
	--g_MaterialThickness =   tonumber(dialog:GetDoubleField("MaterialThickness"))
	--g_MaterialLength =   	tonumber(dialog:GetDoubleField("MaterialLength"))
	g_NoFingers0 =   	    tonumber(dialog:GetDoubleField("NoFingers0"))
	g_default_tool_name = 	tool.Name

  
	-- Recalculate finger and joint dimensions
	g_ToolSize = tool.ToolDia
  	g_NoFingers2 = Round(g_NoFingers0 / 2)
	g_FingerSize = g_MaterialLength /  g_NoFingers0   
	g_NoFingers1 = g_NoFingers0 - g_NoFingers2
	
	-- Validate the bit diameter can cut the slot gap
	if tool.ToolDia > g_FingerSize then
	    MessageBox("The bit is too larger for the number of Fingers")
		return 2
		-- 2 value will return user to Boxjoint dialog
	end

	return true
end  -- function end

-- ______________________________________________________________________________
function main(script_path)

	-- Load Job information
	local job = VectricJob()
	
	-- No Job? tell user and jump out
	if not job.Exists then
		MessageBox("No new or existing file loaded")
		return false
	end

	-- Read the Material Configuration and set global setting
	GetMaterialSettings()

	-- Keep looping the Dialog to get all user inputs
	repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == false then
			return false
		end		
	until ret_value == true
	
	-- Building the vectors for the finger joints
	CreatFingerCutPaths() 
	
	-- Build the tool paths for left hand joint
	CreateBoxjointToolpath(job, g_layer_name1, g_toolpath_name1)
	
	-- Build the tool paths for right hand joint
	CreateBoxjointToolpath(job, g_layer_name2, g_toolpath_name2)
	
	-- Regenerate the drawing display
	job:Refresh2DView()
	
    return true
end  -- function end
