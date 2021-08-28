-- VECTRIC LUA SCRIPT
-- Copyright 2014 Vectric Ltd.

-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.


--require("mobdebug").start()
require "strict"
g_HALFPI = 1.57079632679
g_THREEPIBYTWO = 4.71238898038
g_version = "1.1"
g_title = "Create Chamfer Toolpath"
g_width = 800
g_height = 625
g_html_file = "Chamfer.htm"


--[[  -------------- geDistBetweenPtsSq ------------------------------------------
|
|  Return the square distance getween points
|
]]
function geDistBetweenPtsSq(pt1, pt2)
  return (pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y  - pt2.y)*(pt1.y - pt2.y)
end



--[[  -------------- BetterToReverse ------------------------------------------
|
|  Return true if the contour's end point is closer target than the contour
|  start point
|
]]
function BetterToReverse(contour, target)
  return geDistBetweenPtsSq(contour.StartPoint2D, target) >
         geDistBetweenPtsSq(contour.EndPoint2D, target) 
end


--[[  -------------- AddGroupToJob --------------------------------------------------  
|
|  Adds a group of contours to a job
|
]]
function AddGroupToJob(vectric_job, group, layer_name, create_group)

   --  create a CadObject to represent the  group 
   local layer = vectric_job.LayerManager:GetLayerWithName(layer_name)
   if create_group then
    local cad_object = CreateCadGroup(group);   -- and add our object to it
    layer:AddObject(cad_object, true)
    return
   end
  
   
   local cad_contour
   local contour
   local pos = group:GetHeadPosition()
   while pos ~= nil do
     contour, pos = group:GetNext(pos)
     cad_contour = CreateCadContour(contour)
     layer:AddObject(cad_contour, true)
   end
   

end




--[[  -------------- DetermineToolCentre --------------------------------------------------  
|
| Given a point want to cut return where the centre of tool should be 
]]
function DetermineToolCentre(point, normal_3d, normal_2d, tool, lowest_Z)

	-- if tool is an end mill then just offset outwards
	if tool.ToolType == Tool.END_MILL then
    local out = 0.5*tool.ToolDia*normal_2d
		return point + Vector3D(out.x, out.y, 0)
	end

	if tool.ToolType == Tool.BALL_NOSE then
		local return_pt = point + 0.5*tool.ToolDia*normal_3d
		if (return_pt.z < lowest_Z) then
			return_pt.z = lowest_Z
		end
		return return_pt
	end
end


--[[  -------------- ComputePassForGivenZ  --------------------------------------------------  
|
| Given a point want to cut return where the centre of tool should be 
]]
function ComputePassForGivenZ(current_z, corner_vecs, safe_z, tool, chamfer_in)

	-- Corner vecs is a list of the flat corner line Contours
	local pass_contour = Contour(0.0)
	for i = 1,#corner_vecs do
		local corner = corner_vecs[i]
		local index
		local param
		local s_pos
		index, param, s_pos = GetSpanIndexParam(corner, current_z)
		local point = GetXYFromIndexParam(corner, index, param)
		local offset = GetPositiveNormalVector(corner, s_pos)

		-- Compute the machine tool centre
		local machine_pt = DetermineToolCentre(Point3D(point, current_z), 
											     offset,
											     Vector2D(offset.x, offset.y),
											     tool,
											     -100 )


		if (pass_contour.IsEmpty) then
			pass_contour:AppendPoint(machine_pt)
		else
			pass_contour:LineTo(machine_pt)
		end

	end
	local end_point = Point3D(pass_contour.StartPoint3D)
	pass_contour:LineTo(end_point)
	end_point.z = safe_z
	pass_contour:LineTo(end_point)
	return pass_contour
end

--[[  -------------- ComputeOffsetPassForGivenZ  --------------------------------------------------  
|
| Given a point want to cut return where the centre of tool should be 
| 
| Parameter:
|  current_z = z we are cutting at
|  offset_vector = inward offset of our original vector
|  
]]
function ComputeOffsetPassForGivenZ(start_z, current_z, tool, contour, chamfer_angle, scale, lowest_z)

	-- We take the contour and do a "3d offset" in a direction normal to chamfer
	local r = scale*0.5*tool.ToolDia
	local z_offset = 0
	local horizontal_offset = r

	-- if the tool is a ball nose then we have more complicated offset
	if (tool.ToolType == Tool.BALL_NOSE) then
		z_offset = math.max(lowest_z, r*(math.cos(chamfer_angle) - 1));
		horizontal_offset = r*math.sin(chamfer_angle)
	end


	local single_contour_group = ContourGroup(true)
	single_contour_group:AddTail(contour:Clone())
	local offset_group = single_contour_group:OffsetWithOpenVectors(horizontal_offset, horizontal_offset, 1, false)
	offset_group:SetZHeight(current_z)
	offset_group:OffsetInZ(z_offset)

	return offset_group;
end


--[[  -------------- MakeLine --------------------------------------------------  
|
|  Return the index and parameter of the span of the contour where cross cur_z.
| Assumes that cur_z > EndPoint3D.z
|
]]
function GetSpanIndexParam(contour, cur_z)
	-- First we fins the span and position of our z
	-- Assuming that our conotur has been smashed.

	local cursor = ContourCarriage(0, 0.0)
	
	-- Step through the contour trying to find which span contains
	-- a given z value
	local span_index = 0
	local correct_span = -1
	local pos = contour:GetHeadPosition()
	local index, param, s_pos
	while pos ~= nil do
    local this_pos = pos
		span, pos = contour:GetNext(pos)

		-- Get the Z value of the span
		if span.EndPoint3D.z <= cur_z then
			correct_span = span_index
			s_pos = this_pos
			break;
		end
		span_index = span_index + 1
	end

	if (correct_span == -1) then
		return false
	end

	-- At this point we have found our span so now compute the 
	-- parameter at z
	local start_point_z = span.StartPoint3D.z
	local end_point_z = span.EndPoint3D.z
	local denom = math.abs(start_point_z - end_point_z)
	if (denom == 0) then
		return false;
	end
  index = correct_span
	param  = math.abs(start_point_z - cur_z)/ denom
  return index, param, s_pos
end

--[[  -------------- GetXYFromIndexParam --------------------------------------------------  
|
|  Return the position from index/param
|
]]
function GetXYFromIndexParam(contour, index, param)
	local cursor = ContourCarriage(index, param)
	return cursor:Position(contour)
end



--[[  -------------- GetPositiveNormalVector --------------------------------------------------  
|
| Get the normal vector to the contour at the
| given span. Assums that the contour has
| been smashed together.
|
]]
function GetPositiveNormalVector(contour, span_pos)
	local span = contour:GetNext(span_pos)
	local nhat = span.EndPoint3D - span.StartPoint3D
	if (nhat.z < 0) then 
		return -nhat
	else
		return nhat
	end
end


--[[  -------------- CalculateStraightCornerVectors --------------------------------------------------  
|
|  Make a straight line contour between two points
|
]]
function CalculateStraightCornerVectors(contour, angle, depth, start_z, tool)
	-- We run through the contour
	-- We find all the corners.
	-- we construct a straigh line back at given angle
	local corners = {}
	local pos =  contour:GetHeadPosition()
	local span
	while  pos ~= nil do
		span, pos = contour:GetNext(pos)
    
    -- Create start span corner
		local normal = -span:StartVector(true):NormalTo()
		local offset = depth/math.tan(angle)
		start_point = span.StartPoint2D + offset*normal
		local corner = MakeLine(Point3D(start_point, start_z), 
								 Point3D(span.StartPoint2D, start_z - depth))
		corners[#corners + 1] = corner
	
    -- Create end span corner
    local end_normal = -span:EndVector(true):NormalTo()
    start_point = span.EndPoint2D + offset*normal
    corner = MakeLine(Point3D(start_point, start_z), 
								 Point3D(span.EndPoint2D, start_z - depth))
    corners[#corners + 1] = corner
  end
	return corners
end

--[[  -------------- MakeLine --------------------------------------------------  
|
|  Make a straight line contour between two points
|
]]
function MakeLine
  (
  start_pt, -- start point
  end_pt    -- end point
  )
  local contour = Contour(0.0)
  contour:AppendPoint(start_pt)
  contour:LineTo(end_pt)
  return contour
end


--[[  -------------- main --------------------------------------------------  
|
|  Entrance point of the contour
|
]]
function main(script_path)

	local options = {}

	local job = VectricJob()
	options.tool = GetTestTool()
	options.angle = math.rad(45);
  options.chamfer_in = true
	options.depth = 1
	options.start_depth = 0
    options.toolpath_name = "Chamfer"
    options.in_mm = job.InMM
    LoadDefaults(options)


	local selected_contours =(GetSelectedContours(job))

	if (selected_contours.IsEmpty) then
		DisplayMessageBox("Please select at least one contour.")
		return false
	end

	-- Display the dialog
	local dialog_displayed = -1
	while dialog_displayed == -1 do
		dialog_displayed = DisplayDialog(script_path, options)
	end

	if not dialog_displayed then 
		return false
	end


  -- Get local safe z  
	local material_block = MaterialBlock()
  options.start_z = material_block:CalcAbsoluteZ(-options.start_depth);
  options.finish_z = material_block:CalcAbsoluteZ(-options.start_depth - options.depth)
  

  local scale = 1
  if options.in_mm and (not options.tool.InMM) then
  	-- App is in mm and tool is in inches
  	
  	scale = 25.4
  end
  if (not options.in_mm) and options.tool.InMM then
  	scale = 0.0393700787
  end
  
  -- Compute number of offsets
  local total_offset = options.depth / math.tan(options.angle)
  local num_offsets = math.ceil(total_offset / (scale*options.tool.Stepover))
  local single_dist = total_offset / num_offsets;
  
  

  
  -- contours for total cut
  local cut_contours = ContourGroup(true)
  
  
  local p_selected = selected_contours:GetHeadPosition()
  local current_contour
  while p_selected ~= nil do
    current_contour, p_selected = selected_contours:GetNext(p_selected)
    
    -- Create a contour group containing single contour
    local current_group = ContourGroup(true)
    current_group:AddTail(current_contour:Clone())


    local signed_offset_dist = -single_dist
    if not options.chamfer_in then
      signed_offset_dist  = -1* signed_offset_dist
    end

    -- if the current contour is open then do a series of offset
    local offset_contours = ContourGroup(true)
    if current_contour.IsOpen then
      -- offset inwards once
      local inner_offset = current_group:OffsetWithOpenVectors(signed_offset_dist, 0.0, 1, false)
      local prev_offset = inner_offset
      offset_contours:AppendGroup(prev_offset:Clone())
      for offset_count =1, num_offsets do
        local lone_offset = prev_offset:OffsetWithOpenVectors(signed_offset_dist, 0.0, 1, false)
        if lone_offset then
          prev_offset = lone_offset:Clone()
          offset_contours:AppendGroup(lone_offset)
        else
          MessageBox("Offsetting failed\n")
          return true
        end
      end
    else 
      -- the contour is closed so do regular offsetin
      offset_contours = current_group:OffsetWithOpenVectors(signed_offset_dist, single_dist, num_offsets , false)
      offset_contours:MakeOffsetsSquare(single_dist , false, 0.5*options.tool.ToolDia)
    end


    
    
    -- iterate over the offsets for each individual contour
    local p_cntr = offset_contours:GetTailPosition()

    -- if we  are chamfering away from the line then reverse
    -- the order we iterate over the contours
    if not options.chamfer_in then
      p_cntr = offset_contours:GetHeadPosition()
    end

    local total_contour = Contour(0.0)
    local cntr
    
    local current_z = options.start_z
    local lowest_z = options.finish_z

    local pass_depth = options.depth / num_offsets
    while p_cntr ~= nil do
        if options.chamfer_in then
          cntr, p_cntr = offset_contours:GetPrev(p_cntr)
        else
          cntr, p_cntr = offset_contours:GetNext(p_cntr)
        end

        current_z = current_z - pass_depth
        local pass_contour = (ComputeOffsetPassForGivenZ(options.start_z, 
                                                        current_z, 
                                                        options.tool, 
                                                        cntr, 
                                                        options.angle,
                                                        scale,
                                                        lowest_z,
                                                        options.chamfer_in)):GetHead():Clone()
        if total_contour.IsEmpty then
          total_contour:AppendPoint(pass_contour.StartPoint3D)
        else
          if BetterToReverse(pass_contour, total_contour.EndPoint2D) then
            pass_contour:Reverse()
          end
          total_contour:LineTo(pass_contour.StartPoint3D)
        end
        total_contour:AppendContour(pass_contour)
    end
    cut_contours:AddTail(total_contour)
  end -- end of iteration through selection vectors
  


	--AddGroupToJob(job, cut_contours, "Chamfer", false)
  
	local toolpath_options = ExternalToolpathOptions()
	toolpath_options.CreatePreview = true
	local pos_data = ToolpathPosData()


  cut_contours:OffsetInZ(-1* math.abs(options.start_z))

	local toolpath = ExternalToolpath(
	                                  options.toolpath_name,
	                                  options.tool,
	                                  pos_data,
	                                  toolpath_options,
	                                  cut_contours
	                                  )

	if toolpath:Error() then
	  DisplayMessageBox("Error creating toolpath")
	  return true
	end

	local toolpath_manager = ToolpathManager()
	local success = toolpath_manager:AddExternalToolpath(toolpath)
	if success then
		SaveDefaults(options)
	end
	return success
end



--[[  -------------- GetTestTool --------------------------------------------------  
|
|  Get tool for testing
|
]]
function GetTestTool()
    local tool = Tool("Chamfer ball Nose", Tool.BALL_NOSE)
    tool.InMM = false
    tool.ToolDia = 0.125
    tool.Stepover = 0.2*tool.ToolDia
    tool.Stepdown = 0.125
    return tool
end


--[[  -------------- AddGroupToJob --------------------------------------------------  
|
|  Add a group to the job
|
]]
function AddGroupToJob(vectric_job, group, layer_name, create_group)

   --  create a CadObject to represent the  group 
   local layer = vectric_job.LayerManager:GetLayerWithName(layer_name)
   if create_group then
    local cad_object = CreateCadGroup(group);   -- and add our object to it
    layer:AddObject(cad_object, true)
    return
   end
  
   
   local cad_contour
   local contour
   local pos = group:GetHeadPosition()
   while pos ~= nil do
     contour, pos = group:GetNext(pos)
     cad_contour = CreateCadContour(contour)
     layer:AddObject(cad_contour, true)
   end
   
end


--[[  -------------- GetSelectedContour --------------------------------------------------  
|
|  Get the selected contour
|
]]
function GetSelectedContour(job)
	local selection_list = job.Selection
	local pos = selection_list:GetHeadPosition()
	local cad_obj = selection_list:GetAt(pos)
	local cad_contour = CastCadObjectToCadContour(cad_obj)
	local contour = cad_contour:GetContour()
	return contour
end

--[[  -------------- GetSelectedContours --------------------------------------------------  
|
|  Get group of  selected contours
|
]]
function GetSelectedContours(job)
	local selection_list = job.Selection
	local contour_group = ContourGroup(true)
	local pos = selection_list:GetHeadPosition()
	local cad_obj
	while pos ~= nil do
		cad_obj, pos = selection_list:GetNext(pos)
		local cad_contour = CastCadObjectToCadContour(cad_obj)
		local contour = cad_contour:GetContour()
		contour_group:AddTail(contour:Clone())
	end
	return contour_group
end




--[[  -------------- DisplayDialog --------------------------------------------------  
|
|  Display the dialog
|
]]
function DisplayDialog( script_path, options )
  local html_path = "file:" .. script_path .. "\\" .. g_html_file
  local dialog = HTML_Dialog(false, 
                             html_path, 
                             options.windowWidth, 
                             options.windowHeight,
                             g_title)

  -- Add fields to the dialog
  dialog:AddLabelField("GadgetTitle", g_title)
  dialog:AddLabelField("GadgetVersion", g_version)

  -- Add depth and angle fields
  dialog:AddDoubleField("StartDepth", options.start_depth)
  dialog:AddDoubleField("CutDepth", options.depth)
  dialog:AddDoubleField("ChamferAngle", math.deg(options.angle))

  -- Add chamfer direction check
  dialog:AddCheckBox("ChamferTowardsCheck", options.chamfer_in);

  -- Add toolpath button
  dialog:AddLabelField("ToolNameField", "")
  dialog:AddToolPicker("ToolChooseButton", "ToolNameField", options.default_toolname)
  dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
  dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.BALL_NOSE)
  
  -- Add toolpath name field
  dialog:AddTextField("ToolpathNameField", options.toolpath_name)

  -- Add units fields
  local units_string = "Inches"
  if options.in_mm then
  	units_string  = "MM"
  end
  dialog:AddLabelField("UnitsLabel1", units_string)
  dialog:AddLabelField("UnitsLabel2", units_string)


  -- Display the dialog
  local success = dialog:ShowDialog()

  if not success then 
  	return false
  end

  -- Read back from the form
  options.tool = dialog:GetTool("ToolChooseButton")
  if options.tool == nil then
    DisplayMessageBox("No Tool Selected.")
    return false
  end


  -- Make sure angle between 0 and 90
  options.angle = math.rad(dialog:GetDoubleField("ChamferAngle"))
  if (options.angle <0 or options.angle > g_HALFPI) then
  	DisplayMessageBox("You must choose and angle between 0 and 90 degrees")
  	return -1 
  end

  -- Make sure that the depth is positive
  options.start_depth = dialog:GetDoubleField("StartDepth")
  if (options.start_depth < 0) then
  	DisplayMessageBox("Start depth must be positive")
  	return -1 
  end

  -- Make sure that cut depth is positive
  options.depth = dialog:GetDoubleField("CutDepth")
  if (options.depth < 0) then
  	DisplayMessageBox("Cut depth must be positive")
  	return -1 
  end

  options.chamfer_in = dialog:GetCheckBox("ChamferTowardsCheck")

  -- Get the toolpath name
  options.toolpath_name = dialog:GetTextField("ToolpathNameField")
  if (options.toolpath_name == "") then
    DisplayMessageBox("You must specify a toolpath name")
    return -1
  end

  options.windowWidth = dialog.WindowWidth
  options.windowHeight = dialog.WindowHeight


  return true

end    


function SaveDefaults(options)
	local registry = Registry("ChamferGadget")
	registry:SetString("ToolpathName", options.toolpath_name)
	registry:SetDouble("Depth", options.depth)
	registry:SetDouble("StartDepth", options.start_depth)
	registry:SetDouble("Angle", options.angle)
  registry:SetString("ToolName", options.tool.Name);
  registry:SetInt("WindowWidth", options.windowWidth);
  registry:SetInt("WindowHeight", options.windowHeight);
end


function LoadDefaults(options)
	local registry = Registry("ChamferGadget")
	options.toolpath_name = registry:GetString("ToolpathName", "Chamfer")
	options.depth = registry:GetDouble("Depth", 1)
	options.start_depth  = registry:GetDouble("StartDepth", 0)
	options.angle = registry:GetDouble("Angle", math.rad(45))
  options.default_toolname = registry:GetString("ToolName", "")
  options.windowWidth = registry:GetInt("WindowWidth", g_width);
  options.windowHeight = registry:GetInt("WindowHeight", g_height);
end





-- Callbacks

function OnLuaButton_ChamferTowardsCheck()
  return true
end
