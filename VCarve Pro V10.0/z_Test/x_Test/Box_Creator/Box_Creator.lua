-- VECTRIC LUA SCRIPT
require("mobdebug").start()
g_version = "1.3"
g_title = "Box Creator"
g_width = 900
g_height = 800
g_html_file = "BoxCreator2.html"

-- ========================================================
function Face(contour, dovetails, tabs, name)
	local obj ={}
	obj.contour = contour
	obj.dovetail_list = dovetails
	obj.name = name
	obj.tabs = tabs
  obj.is_lid = false
  return obj
end
-- ========================================================
function Lid(outer_contour, inner_contour, dovetails, tabs, name)
  local obj = {}
  obj.contour = outer_contour
  obj.is_lid = true
  obj.inner_contour = inner_contour
  obj.tabs = tabs
  obj.name = name
  obj.dovetail_list = dovetails
  return obj
end
-- ========================================================

function TransformFace(face, xform)
	face.contour:Transform(xform)

	if (face.is_lid) then
		face.inner_contour:Transform(xform)
	end

	-- Transform dovetail markers
	local dovetails = face.dovetail_list
	for i=1,#dovetails do
		local marker = dovetails[i]
		marker:Transform(xform)
	end
  
  -- Transform the tabs
  local tabs = face.tabs
  for i=1,#tabs do
    face.tabs[i] =  xform * face.tabs[i]
  end
  

end
-- ========================================================

function CloneFace(face)
	local clone = {}
	clone.contour = face.contour:Clone()
	clone.dovetail_list = face.dovetail_list
	clone.tabs = face.tabs
	clone.is_lid = face.is_lid
	if (clone.is_lid) then
		clone.inner_contour = face.inner_contour:Clone()
	end
	return clone
end
-- ========================================================

function GetAllProfileContours(faces)
	local contour_group = ContourGroup(true)
	for i=1,#faces do
		contour_group:AddTail(faces[i].contour:Clone())
	end
	return contour_group
end
-- ========================================================
function GetAllProfileCadContours(faces)
	local cad_object_list = CadObjectList(true)	
	for i=1,#faces do
		local cur_face = faces[i]
		local cad_contour = MakeCadAndAddTabs(cur_face.contour, cur_face.tabs)
		cad_object_list:AddTail(cad_contour)
	end
	return cad_object_list
end
-- ========================================================
function GetAllMarkers(faces)
	local markers = {}
	for i=1,#faces do
		local cur_markers = faces[i].dovetail_list
		for j=1,#cur_markers do
			markers[#markers+1] = cur_markers[j]
		end
	end
	return markers;
end
-- ========================================================

function CreateLidPocketToolpath(job, options, faces, tool, layer_name)

	-- first we must create cad contours from any face which has a lid and select all on that layer
	local cad_object_list = CadObjectList(true)
	for i=1,#faces do
		local cur_face = faces[i]
		if cur_face.is_lid then
			local inner = CreateCadContour(cur_face.inner_contour)
			local outer = CreateCadContour(cur_face.contour)
			cad_object_list:AddTail(inner)
			cad_object_list:AddTail(outer)
		end
	end

	AddCadListToJob(job, cad_object_list, layer_name)
	local layer = job.LayerManager:FindLayerWithName(layer_name)
	local selection = job.Selection
	selection:Clear()
	SelectVectorsOnLayer(layer, selection, true, true, true)



	local pos_data = ToolpathPosData()
	local pocket_data = PocketParameterData()
	pocket_data.start_depth = 0
	pocket_data.CutDepth = 0.5*options.thickness
	pocket_data.Allowance = -options.allowance
	pocket_data.DoRaster = false
	pocket_data.DoRamping = true
	pocket_data.RampDistance = 0.3*options.height

	local geometry_selector = GeometrySelector()

	local area_clear_tool = nil

	local toolpath_manager = ToolpathManager()
	toolpath_manager:CreatePocketingToolpath(
		"Pocket",
		tool,
		area_clear_tool,
		pocket_data,
		pos_data,
		geometry_selector,
		true,
		true)
end
-- ========================================================

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


--[[  -------------- AddCadContourToJob --------------------------------------------------  
|
|  Adds a group of contours to a job
|
]]
function AddCadContourToJob(vectric_job, cad_contour, layer_name)

	--  create a CadObject to represent the  group
	local layer = vectric_job.LayerManager:GetLayerWithName(layer_name)
	if cad_contour and layer then
		layer:AddObject(cad_contour, true)
	end
end   

--[[  -------------- AddCadContourToJob --------------------------------------------------  
|
|  Adds a group of contours to a job
|
]]
function AddCadListToJob(vectric_job, cad_list, layer_name)

	--  create a CadObject to represent the  group
	local pos = cad_list:GetHeadPosition()
	local layer = vectric_job.LayerManager:GetLayerWithName(layer_name)
	while (pos) do
		local obj
		obj, pos = cad_list:GetNext(pos)
		layer:AddObject(obj:Clone(), true)
	end
end



--[[  -------------- MakeBottomFace --------------------------------------------------  
|
|  Make the bottom face of the box
|  Returns the contour for the profile and a list of dovetails
|
]]
function MakeBottomFaceContour(width, height, thickness, start_point, dovetail, use_dovetails,name)

	local dovetail_markers = {}
	local tablist = {}
	local outer_blc = start_point
	local outer_brc = start_point  + width*Vector2D(1,0)
	local outer_trc = outer_brc + height*Vector2D(0,1)
	local outer_tlc = start_point + height*Vector2D(0, 1)

	-- // Width and height of interior rectangle
	local inner_width = width - 2*thickness
	local inner_height = height - 2*thickness

	-- Calculate number of flaps needed. In this case
	-- then each "flap" represents a piece of the outer 
	-- contour then goes inwards
	local num_flaps_w = math.floor((0.5*inner_width) / dovetail.min_width )
	local num_flaps_h = math.floor((0.5*inner_height) / dovetail.min_width)

	local tab_space_w = (inner_width - num_flaps_w*dovetail.min_width)/ (num_flaps_w + 1)
	local tab_space_h = (inner_height - num_flaps_h*dovetail.min_width)/ (num_flaps_h + 1)


	-- Create the contour
	local contour = Contour(0.0)
	contour:AppendPoint(start_point)

	-- Create blc -> brc
	-- Create the internal flaps. 

	local unit_x = Vector2D(1,0)
	local unit_y = Vector2D(0,1)

	-- line to first
	LineToVector(contour, (thickness + tab_space_w)*unit_x)
	AddMiddleOfLastSpanToList(contour, tablist)
	AddFemaleDoveTailsAlongLine(thickness, dovetail, unit_x, unit_y, contour, num_flaps_w, tab_space_w, dovetail_markers)
	contour:LineTo(outer_brc)
	AddMiddleOfLastSpanToList(contour, tablist)


	-- Create brc -> trc
	LineToVector(contour, (thickness + tab_space_h)*unit_y)
	AddMiddleOfLastSpanToList(contour, tablist)
	AddFemaleDoveTailsAlongLine(thickness, dovetail, unit_y, -unit_x, contour, num_flaps_h, tab_space_h, dovetail_markers)
	contour:LineTo(outer_trc)
	AddMiddleOfLastSpanToList(contour, tablist)

	-- Create trc -> tlc
	LineToVector(contour, (thickness + tab_space_w)*(-unit_x))
	AddMiddleOfLastSpanToList(contour, tablist)
	AddFemaleDoveTailsAlongLine(thickness, dovetail, -unit_x, -unit_y, contour, num_flaps_w, tab_space_w, dovetail_markers)
	contour:LineTo(outer_tlc)
	AddMiddleOfLastSpanToList(contour, tablist)

	-- Create tlc -> blc
	LineToVector(contour, (thickness + tab_space_h)*(-unit_y))
	AddMiddleOfLastSpanToList(contour, tablist)
	AddFemaleDoveTailsAlongLine(thickness, dovetail, -unit_y, unit_x, contour, num_flaps_h, tab_space_h, dovetail_markers)
	contour:LineTo(outer_blc)
	AddMiddleOfLastSpanToList(contour, tablist)

	return Face(contour, dovetail_markers, tablist, name)
end

-- Make the side faces
function MakeSideFace(width, height, thickness, start_point, dovetail, with_tails, flat_lid, name)

	local dovetail_markers = {}
	local tablist = {}
	local inner_start_point = start_point + Vector2D(thickness, thickness)
	local inner_width  = width - 2*thickness
	local inner_height = height - 2*thickness
	-- DisplayMessageBox("inner_width " .. inner_width)

	local unit_x = Vector2D(1,0)
	local unit_y = Vector2D(0,1)

	local inner_blc = inner_start_point
	local inner_brc = inner_start_point + inner_width * unit_x
	local inner_trc = inner_brc + inner_height*unit_y
	local inner_tlc = inner_blc + inner_height*unit_y

	local num_flaps_w = math.floor((0.5*inner_width) / dovetail.min_width )
	local num_flaps_h = math.floor((0.5*inner_height) / dovetail.min_width)

	local tab_space_w = (inner_width - num_flaps_w*dovetail.min_width)/ (num_flaps_w + 1)
	local tab_space_h = (inner_height - num_flaps_h*dovetail.min_width)/ (num_flaps_h + 1)


	-- Create the contour
	local contour = Contour(0.0)
	contour:AppendPoint(inner_start_point)

	--  blc ->brc
	LineToVector(contour, tab_space_w*unit_x)
	AddMiddleOfLastSpanToList(contour, tablist)
	if (with_tails) then
		AddMaleDoveTailsAlongLine(thickness, dovetail, unit_x, -unit_y, contour,  num_flaps_w, tab_space_w)
	else
		AddFlapsAlongLine(thickness, dovetail.min_width, tab_space_w, unit_x, -unit_y, contour, num_flaps_w)
	end
	contour:LineTo(inner_brc)
	AddMiddleOfLastSpanToList(contour, tablist)


	-- -- brc -> trc
	LineToVector(contour, tab_space_h*unit_y)
	AddMiddleOfLastSpanToList(contour, tablist)
	if with_tails then
		AddMaleDoveTailsAlongLine(thickness, dovetail, unit_y, unit_x, contour, num_flaps_h, tab_space_h )
	else
		AddFlapsAlongLine(thickness, dovetail.min_width, tab_space_h, unit_y, unit_x, contour, num_flaps_h)
	end
	contour:LineTo(inner_trc)
	AddMiddleOfLastSpanToList(contour, tablist)

	-- trc -> tlc (top line so has flaps for lid)
  if flat_lid then
    LineToVector(contour, 0.5*thickness*unit_y)
    LineToVector(contour, -inner_width*unit_x)
    AddMiddleOfLastSpanToList(contour, tablist)
    contour:LineTo(inner_tlc)
  else 
    LineToVector(contour, -tab_space_w*unit_x)
    AddMiddleOfLastSpanToList(contour, tablist)
    AddFlapsAlongLine(thickness, dovetail.min_width, tab_space_w, -unit_x, unit_y, contour, num_flaps_w)
    contour:LineTo(inner_tlc)
    AddMiddleOfLastSpanToList(contour, tablist)
  end

	-- tlc -> blc
	LineToVector(contour, -tab_space_h*unit_y)
	AddMiddleOfLastSpanToList(contour, tablist)
	if (with_tails) then
		AddMaleDoveTailsAlongLine(thickness, dovetail, -unit_y, -unit_x, contour, num_flaps_h, tab_space_h)
	else
		AddFlapsAlongLine(thickness, dovetail.min_width, tab_space_h, -unit_y, -unit_x, contour, num_flaps_h)
	end

	contour:LineTo(inner_blc)
	AddMiddleOfLastSpanToList(contour, tablist)

	return Face(contour, dovetail_markers, tablist, name)
end



-- Make an end face
function MakeEndFace(width, height, thickness, start_point, dovetail, with_tails, flat_lid, name)


	local tablist = {}
	local dovetail_markers = {}
	local unit_x = Vector2D(1,0)
	local unit_y = Vector2D(0,1)
	local inner_start_point = start_point + thickness*unit_y
	local inner_width = width - 2*thickness;
	local inner_height  = height - 2*thickness


	local inner_blc = inner_start_point
	local inner_brc = inner_start_point + width * unit_x
	local inner_trc = inner_brc + inner_height*unit_y
	local inner_tlc = inner_blc + inner_height*unit_y

	local num_flaps_w = math.floor((0.5*inner_width)/ dovetail.min_width)
	local num_flaps_h = math.floor((0.5*inner_height) / dovetail.min_width)

	local tab_space_w = (inner_width - num_flaps_w*dovetail.min_width) / (num_flaps_w + 1)
	local tab_space_h = (inner_height - num_flaps_h*dovetail.min_width) / (num_flaps_h + 1)

	local contour = Contour(0.0)
	contour:AppendPoint(inner_start_point)

	-- blc --> brc
	LineToVector(contour, (tab_space_w + thickness)*unit_x)
	AddMiddleOfLastSpanToList(contour, tablist)
	if (with_tails) then
		AddMaleDoveTailsAlongLine(thickness, dovetail, unit_x, -unit_y, contour, num_flaps_w, tab_space_w)
	else
		AddFlapsAlongLine(thickness, dovetail.min_width, tab_space_w, unit_x, -unit_y, contour, num_flaps_w)
	end
	contour:LineTo(inner_brc)
	AddMiddleOfLastSpanToList(contour, tablist)

	-- brc --> trc
	LineToVector(contour,  tab_space_h*unit_y)
	AddMiddleOfLastSpanToList(contour, tablist)
	AddFemaleDoveTailsAlongLine(thickness, dovetail, unit_y, -unit_x, contour, num_flaps_h, tab_space_h, dovetail_markers)
	contour:LineTo(inner_trc)
	AddMiddleOfLastSpanToList(contour, tablist)



	-- if the lid is flat then we go up by half thickness and then across
	if flat_lid then
		LineToVector(contour, (0.5*thickness) * (unit_y));
		LineToVector(contour, (width)*(-unit_x))
		AddMiddleOfLastSpanToList(contour, tablist)
		contour:LineTo(inner_tlc)
	else
		-- trc -> tlc (top line so has flaps for lid)
		LineToVector(contour, (tab_space_w + thickness) * (-unit_x))
		AddMiddleOfLastSpanToList(contour, tablist)
		AddFlapsAlongLine(thickness, dovetail.min_width, tab_space_w, -unit_x, unit_y, contour, num_flaps_w)
		-- AddMaleDoveTailsAlongLine(thickness, dovetail, -unit_x, unit_y, contour, num_flaps_w, tab_space_w)
		contour:LineTo(inner_tlc)
		AddMiddleOfLastSpanToList(contour, tablist)
	end

	-- tlc -> brc
	LineToVector(contour, (tab_space_h*-unit_y))
	AddMiddleOfLastSpanToList(contour, tablist)
	AddFemaleDoveTailsAlongLine(thickness, dovetail, -unit_y, unit_x, contour, num_flaps_h, tab_space_h, dovetail_markers)
	AddMiddleOfLastSpanToList(contour, tablist)


	return Face(contour, dovetail_markers, tablist, name)
end


function AddFemaleDoveTailsAlongLine(thickness, dovetail, along, out, contour, num_tails, space_dist, markers)
	for i=1,num_tails do
		local start_pos = contour.EndPoint2D
		AddFemaleDoveTail(thickness, dovetail.min_width, out, along, contour)
		if (markers) then
			markers[#markers + 1] = MakeLine(start_pos, contour.EndPoint2D) 
		end
		LineToVector(contour, space_dist*along)
	end
end



-- Add male dovetails along this line
function AddMaleDoveTailsAlongLine(thickness, dovetail, along, out, contour, num_tails, space_dist)
	for i=1,num_tails do
		AddMaleDoveTail(thickness, dovetail.max_width, out, along, dovetail.angle, contour)
		LineToVector(contour, space_dist*along)
	end

end

function AddFlapsAlongLine(flap_height, flap_width, space_dist, along, out, contour, num_flaps)
	for i=1,num_flaps do
		AddFemaleDoveTail(flap_height, flap_width, out, along, contour)
		LineToVector(contour, space_dist*along)
	end
end





function AddMaleDoveTail(thickness, max_dovetail_width, out, along, angle, contour)
	local along_dist  = (thickness/ math.tan(angle))
	local diag_vector = (-along_dist)*along + thickness*out
	LineToVector(contour, diag_vector)
	LineToVector(contour, max_dovetail_width*along)
	local and_back = (-along_dist)*along  - thickness*out
	LineToVector(contour, and_back)
end



-- Extend the end point of the contour by the given vector
function LineToVector(contour, vector)
	local current_pos = contour.EndPoint2D
	contour:LineTo(current_pos + vector)
end


-- Add a flap
function AddFemaleDoveTail(thickness, tab_width, perp_vec, along_vec, contour)
	LineToVector(contour, thickness*perp_vec)
	LineToVector(contour, tab_width*along_vec)
	LineToVector(contour, thickness*(-perp_vec))
end




function MakeLid(width, height, thickness, tab_width, start_point, flat_lid, name)

	local tablist = {}
	local unit_x = Vector2D(1,0)
	local unit_y = Vector2D(0,1)
	local inner_width = width - 2*thickness
	local inner_height = height - 2*thickness

	local inner_start_point = start_point + Vector2D(thickness, thickness)

	-- Get corners of box
	local outer_blc = start_point
	local outer_brc = start_point + width*unit_x
	local outer_trc = start_point + width*unit_x + height* unit_y
	local outer_tlc = start_point + height*unit_y

	-- Get the corners of the box offset by the thickness
	local inner_blc = inner_start_point
	local inner_brc = inner_start_point + inner_width*unit_x
	local inner_trc = inner_start_point + inner_height*unit_y + inner_width*unit_x
	local inner_tlc = inner_start_point + inner_height*unit_y

	local num_flaps_w = math.floor( (0.5*inner_width)/tab_width)
	local num_flaps_h = math.floor( (0.5*inner_height)/tab_width)

	local tab_space_w = (inner_width - num_flaps_w*tab_width) / (num_flaps_w + 1)
	local tab_space_h = (inner_height - num_flaps_h*tab_width) / (num_flaps_h + 1)

	local contour = Contour(0.0)
	if (not flat_lid) then
		contour:AppendPoint(start_point)

		--- blc -> brc
		LineToVector(contour, (thickness + tab_space_w)*unit_x)
		AddMiddleOfLastSpanToList(contour, tablist)
		AddFlapsAlongLine(thickness, tab_width, tab_space_w, unit_x, unit_y, contour, num_flaps_w)
		contour:LineTo(outer_brc)
		AddMiddleOfLastSpanToList(contour, tablist)

		-- brc --> trc
		LineToVector(contour, (thickness + tab_space_h) * unit_y)
		AddMiddleOfLastSpanToList(contour, tablist)
		AddFlapsAlongLine(thickness, tab_width, tab_space_h, unit_y, -unit_x, contour, num_flaps_h)
		contour:LineTo(outer_trc)
		AddMiddleOfLastSpanToList(contour, tablist)

		-- trc --> tlc
		LineToVector(contour, (thickness + tab_space_w)*-unit_x)
		AddMiddleOfLastSpanToList(contour, tablist)
		AddFlapsAlongLine(thickness, tab_width, tab_space_w, -unit_x, -unit_y, contour, num_flaps_w)
		contour:LineTo(outer_tlc)
		AddMiddleOfLastSpanToList(contour, tablist)


		-- tlc --> trc
		LineToVector(contour, (thickness + tab_space_h)* -unit_y)
		AddMiddleOfLastSpanToList(contour, tablist)
		AddFlapsAlongLine(thickness, tab_width, tab_space_h, -unit_y, unit_x, contour, num_flaps_h)
		contour:LineTo(outer_blc)
		AddMiddleOfLastSpanToList(contour, tablist)


	else -- No tabs so just create outer profile contour
		contour:AppendPoint(start_point)
		LineToVector(contour, width*unit_x)
		AddMiddleOfLastSpanToList(contour, tablist)
		LineToVector(contour, height*unit_y)
		AddMiddleOfLastSpanToList(contour, tablist)
		LineToVector(contour, -width*unit_x)
		AddMiddleOfLastSpanToList(contour, tablist)
		LineToVector(contour, -height*unit_y)
		AddMiddleOfLastSpanToList(contour, tablist)
	end

	local inner_contour = Contour(0.0)
	inner_contour:AppendPoint(inner_blc)
	inner_contour:LineTo(inner_brc)
	inner_contour:LineTo(inner_trc)
	inner_contour:LineTo(inner_tlc)
	inner_contour:LineTo(inner_blc)




	return Lid(contour, inner_contour, {}, tablist, name)
end




function MakeLidPocketContours(width, height, thickness, start_point)
	local cad_object_list = CadObjectList(true)

	local unit_x = Vector2D(1,0)
	local unit_y = Vector2D(0,1)

	local inner_width = width - 2*thickness
	local inner_height = height - 2*thickness
	local inner_start_point = start_point + Vector2D(thickness, thickness)

	-- Get corners of box
	local outer_blc = start_point
	local outer_brc = start_point + width*unit_x
	local outer_trc = start_point + width*unit_x + height* unit_y
	local outer_tlc = start_point + height*unit_y

	-- Get the corners of the box offset by the thickness
	local inner_blc = inner_start_point
	local inner_brc = inner_start_point + inner_width*unit_x
	local inner_trc = inner_start_point + inner_height*unit_y + inner_width*unit_x
	local inner_tlc = inner_start_point + inner_height*unit_y


	local cad_object_list = CadObjectList(true);
	local outer_contour = Contour(0.0)
	outer_contour:AppendPoint(outer_blc)
	outer_contour:LineTo(outer_brc)
	outer_contour:LineTo(outer_trc)
	outer_contour:LineTo(outer_tlc)
	outer_contour:LineTo(outer_blc)


	local inner_contour = Contour(0.0)
	inner_contour:AppendPoint(inner_blc)
	inner_contour:LineTo(inner_brc)
	inner_contour:LineTo(inner_trc)
	inner_contour:LineTo(inner_tlc)
	inner_contour:LineTo(inner_blc)


	local outer_cad_contour = CreateCadContour(outer_contour)
	cad_object_list:AddTail(outer_cad_contour)
	local inner_cad_contour = CreateCadContour(inner_contour)
	cad_object_list:AddTail(inner_cad_contour)

	return cad_object_list
end



--[[  -------------- ArrangeContours --------------------------------------------------  
|
| Arrange the contours 
|
]]
function ArrangeContours(faces, clearance_gap, job_width, job_height)

	-- Assumption: Contours come in ordered largest to smallest
	-- Place the elements of the contour group into a lua list
	-- we do this because cad object lists don't have a remove
	local transformed_faces = {}

	local to_place = {}
	for i=1,#faces do
		to_place[i] = faces[i]
	end

	local num_contours = #to_place

	local first_face = to_place[1]
	local trans = TranslationMatrix2D(Vector2D(clearance_gap, clearance_gap))
	TransformFace(first_face,trans)
	transformed_faces[1] = first_face 


	local current_bounds = Box2D()
	local y_below = clearance_gap
	local x_below = first_face.contour.BoundingBox2D.MaxX + clearance_gap
  	current_bounds:Merge(first_face.contour.BoundingBox2D)
  	to_place[1] = 0

	local  arranging = true;
	local timeout = 10
	while (arranging and timeout >= 0) do
		for i=1,#to_place do
			face = to_place[i]
			if (face ~= 0) then
				local contour_bounds = face.contour.BoundingBox2D

				if (contour_bounds.XLength + x_below + 2*clearance_gap < job_width) then
					-- Place this contour
					local xform = TranslationMatrix2D(Vector2D(x_below + clearance_gap, y_below))
					TransformFace(face, xform)
					transformed_faces[#transformed_faces + 1] = face

				    current_bounds:Merge(face.contour.BoundingBox2D)
			          x_below = x_below + contour_bounds.XLength + 2*clearance_gap
			        -- Remove this contour and set contour_list[i] = 0
				    to_place[i] = 0
			    end
			end
		end -- End of for loop. If we got here we exhausted all objects so new row

		x_below = 0
		y_below = current_bounds.MaxY + 2*clearance_gap

		if #transformed_faces== num_contours then
			arranging = false
		end


		timeout = timeout - 1
	end -- End of arrangement process

	if timeout < 0 then
		DisplayMessageBox("Couldn't arrange quick enough")
	end

	return transformed_faces
end


--[[  -------------- ComputeDogBones --------------------------------------------------  
|
| Compute the markers for where dog bones should be placed on preradiused contours
|
]]
function ComputeDogBones(contour_group, radius, do_ccw)
  circles = {}
  line_markers = {}
  local ctr_pos = contour_group:GetHeadPosition()
  local contour
  while ctr_pos ~= nil do
    contour, ctr_pos = contour_group:GetNext(ctr_pos)
    if (contour.IsCCW == do_ccw) then
      local span
      local span_pos = contour:GetHeadPosition()
      local prev_span = contour:GetLastSpan()
      while span_pos ~= nil do
        span, span_pos = contour:GetNext(span_pos)
        
        if (SpanIsArc(span, radius)) then
            local centre = Point3D()
            local arc_span = CastSpanToArcSpan(span)
            arc_span:RadiusAndCentre(centre)
            circles[#circles + 1]  = centre
            local span_out_end = GetEndPointArcBisector(arc_span, radius, centre, arc_span:ArcMidPoint() )
            line_markers[#line_markers + 1] = MakeLine(centre, span_out_end)
        end
        prev_span = span
      end
    end
  end
  
  return circles, line_markers
end

--[[  -------------- CreateDogboneProfile --------------------------------------------------  
|
| Create the dogboned profile
| offset_radius = tool_radius - allowance
]]
function CreateDogboneProfile(contour_group, offset_radius)

  local rounded_contours = OffsetOutIn(contour_group, offset_radius)
  local circles, markers = ComputeDogBones(rounded_contours, offset_radius, true)

  -- Fill bins with markers
  local bounding_box = rounded_contours.BoundingBox2D
  local box_xlength = bounding_box.XLength
  local min_x  = bounding_box.MinX - 0.1*box_xlength
  local max_x =  bounding_box.MaxX  + 0.1*box_xlength
  box_xlength = max_x - min_x

  local box_ylength = bounding_box.YLength
  local min_y  = bounding_box.MinY - 0.1*box_ylength
  local max_y =  bounding_box.MaxY  + 0.1*box_ylength
  box_ylength = max_y - min_y


  local bin_data = {}
  bin_data.min_x = min_x
  bin_data.min_y = min_y
  bin_data.dim = math.ceil(math.sqrt(#markers))
  bin_data.grid_x = box_xlength / bin_data.dim
  bin_data.grid_y = box_ylength /bin_data.dim
  local bin_array = InitializeBins(bin_data.dim)
  FillBins(markers, bin_data, bin_array)


  -- Offset the contours out
  local offset_contours = contour_group:Offset(offset_radius, offset_radius, 1, true)
  local filleted_contour_group = ContourGroup(true)
  local current_contour
  local pos = offset_contours:GetHeadPosition()
  while pos~= nil do
  	current_contour, pos = offset_contours:GetNext(pos)
  	local filleted_contour = AddFillets(current_contour, markers, offset_radius, bin_array, bin_data, true)
  	if filleted_contour ~= nil then
  		filleted_contour_group:AddTail(filleted_contour)
  	end
  end

  return filleted_contour_group
end


--[[  -------------- BinKey --------------------------------------------------  
|
| Return which bin the point should be in
|
]]
function BinKey(point,bin_data)
  local i = math.floor((point.x - bin_data.min_x) / bin_data.grid_x)
  local j = math.floor((point.y - bin_data.min_y) / bin_data.grid_y)

  if ( (i+1 > bin_data.dim) or  (j+1 > bin_data.dim)) then
    return nil
  end
  return i + 1, j + 1 -- We add 1 because using lua-style 0 index matrices 
end


--[[  -------------- InitializeBins --------------------------------------------------  
|
| Initialize the bins
|
]]
function InitializeBins(dim)
  local mt = {}
  for i = 1, dim do
    mt[i] = {}
    for j = 1, dim do
      mt[i][j] = {}
    end
  end
  return mt
end

--[[  -------------- PlaceMarkerInbin --------------------------------------------------  
|
| Place a marker in its rightful bin
|
]]
function PlaceMarkerInBin(marker, bin_data, bin_array)
  local i, j = BinKey(marker.StartPoint2D, bin_data)
  if i ~= nil and j ~= nil then
    (bin_array[i][j])[#(bin_array[i][j]) + 1] = marker
  end
end


--[[  -------------- FillBins --------------------------------------------------  
|
| Fill all bins
|
]]
function FillBins(markers, bin_data, bin_array)
  for i= 1, #markers do
    if IsSpan(markers[i]) then
      PlaceMarkerInBin(markers[i], bin_data, bin_array)
    end
  end
end



--[[  -------------- HasMatchingMarker --------------------------------------------------  
|
| Has matrching marker
|
]]
function HasMatchingMarker(point, bin_data, bin_array)
  local i,j = BinKey(point, bin_data)
  if (i == nil) then
    return nil
  end
  local this_bin = bin_array[i][j] 
  if this_bin == nil then 
    return nil
  end

  for m = 1, #this_bin do
    local marker = this_bin[m]
    if marker.StartPoint2D:IsCoincident(point, 0.01) then
      return marker
    end
  end
  return nil
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


--[[  -------------- OffsetOutIn --------------------------------------------------  
|
| Return the result of offsetting the contour group out and then back in again
|
]]
function OffsetOutIn(contour_group, radius)
  local out_group = contour_group:Offset(radius, radius, 1, true)
  local in_group = out_group:Offset(-radius, -radius, 1, true)
  return in_group
end


--[[  -------------- SpanIsArc --------------------------------------------------  
|
| Return true if span is arc
|
]]
function SpanIsArc(span, radius)
  if not span.IsArcType then
    return false
  end
  local centre = Point3D()
  local arc_span = CastSpanToArcSpan(span)
  local span_radius = arc_span:RadiusAndCentre(centre)
  if math.abs(span_radius - radius) > 0.005 then
    return false
  end
  return true
end

-- ========================================================




--[[  -------------- utAngleRad2d --------------------------------------------------  
|
| utility function computing angle swept out by rays 
|
]]
 function utAngleRad2d( x1, y1, x2, y2, x3, y3)
  local value;
  local x = ( x1 - x2 ) * ( x3 - x2 ) + ( y1 - y2 ) * ( y3 - y2 )
  local y = ( x1 - x2 ) * ( y3 - y2 ) - ( y1 - y2 ) * ( x3 - x2 )

  if ( x == 0.0 and y == 0.0 ) then
     value = 0.0
  else
     value = math.atan2 ( y, x )
     if ( value < 0.0 ) then
        value = value + 2.0 * math.pi
     end
  end 
  return value;
end



--[[  -------------- GetInternalAngleArc --------------------------------------------------  
|
| Get the internal angle arc
|
]]
function GetInternalAngleArc(arc_span, arc_centre)

  local start_pt = arc_span.StartPoint2D
  local end_pt   = arc_span.EndPoint2D

  -- get included angle of arc, function assumes CCW arc so reverse direction if CW ...
  local  arc_angle
  if arc_span.IsClockwise then
     arc_angle = utAngleRad2d(end_pt.x,end_pt.y, arc_centre.x, arc_centre.y,start_pt.x, start_pt.y)
  else
     arc_angle = utAngleRad2d(start_pt.x,start_pt.y, arc_centre.x, arc_centre.y, end_pt.x, end_pt.y)
  end

  return arc_angle
end


--[[  -------------- GetEndPointArcBisector --------------------------------------------------  
|
| Get the end point of the bisector which cuts arc in half and meets at point on tangents
|
]]
function GetEndPointArcBisector(arc_span, radius, start_point, mid_point)
  local internal_angle = GetInternalAngleArc(arc_span, start_point)
  local corner_angle =  math.pi - internal_angle 
  local offset_distance = (radius / math.sin(0.5*corner_angle)) - radius
  local offset_vector = mid_point - start_point
  offset_vector:Normalize()
  
  local offset_point = start_point  + offset_distance*offset_vector
  return offset_point
end



--[[  -------------- IsSpan --------------------------------------------------  
|
| Return true if the contour is just a single line span
|
]]
  function IsSpan(ctr)
    if (ctr.Count == 1) and ctr:GetFirstSpan().IsLineType then
      return true
    else
      return false
    end
  end
  
 

 --[[  -------------- CloneSpan --------------------------------------------------  
|
| Clone the given span
|
]] 
function CloneSpan(span)
  if span.IsLineType then
    return LineSpan(span.StartPoint2D, span.EndPoint2D)
  elseif span.IsArcType then
    local arc_span = CastSpanToArcSpan(span)
    return ArcSpan(span.StartPoint2D, span.EndPoint2D, arc_span.Bulge)
  elseif span.IsBezierType then
    local bspan = CastSpanToBezierSpan(span)
    return BezierSpan(bspan.StartPoint2D, 
                      bspan.EndPoint2D, 
                      span:GetControlPointPosition(0), 
                      span:GetControlPointPosition(1))
  end
end


--[[  -------------- AddFillets --------------------------------------------------  
|
| Add filletes to the given contour
|
]]
function AddFillets(contour, markers, radius, bin_array, bin_data, is_ccw)
  if contour.IsCCW == is_ccw then
    local return_contour = Contour(0.0)
    local span_pos = contour:GetHeadPosition()
    local span
    while span_pos ~= nil do
      span, span_pos = contour:GetNext(span_pos)
      return_contour:AppendSpan(CloneSpan(span))
      local marker_line  = HasMatchingMarker(span.EndPoint2D, bin_data, bin_array)
      if marker_line ~= nil then
        return_contour:LineTo(marker_line.EndPoint2D)
        return_contour:LineTo(marker_line.StartPoint2D)    
      end
        
    end
    return return_contour
  else
    return nil
  end
  
end




-- Transfer tabs from one cad contour to another
-- Only want to do this if for example have offset
-- one cad contour from another
function TransferTabs(cad_contour_a, cad_contour_b)
  -- clone because problem with constness on tabs

	local tabs_a = cad_contour_a:GetToolpathTabs()
	local contour_a = cad_contour_a:GetContour()
	local pos = tabs_a:GetHeadPosition()
	while pos do
		local tab
		tab, pos = tabs_a:GetNext(pos)
		local point = tab:Position(contour_a)
		cad_contour_b:InsertToolpathTabAtPoint(point)
	end
end


function AddMiddleOfLastSpanToList(contour, pt_list)
	local last_span = contour:GetLastSpan()
	pt_list[#pt_list + 1] = last_span.StartPoint2D + 0.5*(last_span.EndPoint2D - last_span.StartPoint2D)
end


function AddTabsToContour(cad_contour, pt_list)
	if (pt_list) then
		for i=1,#pt_list do
			cad_contour:InsertToolpathTabAtPoint(pt_list[i])
		end
	else
		DisplayMessageBox("No tabs to Add")
	end
end


function MakeCadAndAddTabs(contour, tab_list)
	local cad_contour = CreateCadContour(contour)
	AddTabsToContour(cad_contour, tab_list)
	return cad_contour
end



function GetContours(cad_object_list)
	local vdcontours = ContourGroup(true)
	local pos, obj
	pos = cad_object_list:GetHeadPosition()
	while (pos) do
		obj, pos = cad_object_list:GetNext(pos)
		local ctr = obj:GetContour()
		if ctr then
			vdcontours:AddTail(ctr:Clone())
		end
	end
	return vdcontours
end


-- Create tabbed versions of the vdcontours by creating 
-- a cad contour version of each contour and transferring all
-- tabs
function CreateTabbedCadContours(vdcontours, cadcontours)
	local cad_obj_list = CadObjectList(true)
	local pos, vdctr, cdctr
	vcpos = cadcontours:GetHeadPosition()
	while vcpos do
		vcctr, vcpos = cadcontours:GetNext(vcpos)
		local vcbox = vcctr:GetBoundingBox()

		-- find the vd contour whose bounding centre is nearest ours
		vdpos = vdcontours:GetHeadPosition()
		while vdpos do
			vdctr, vdpos = vdcontours:GetNext(vdpos)
			local vdbox = vdctr.BoundingBox2D
			if (vdbox:IsInside(vcbox)) then
				local cad_ctr = CreateCadContour(vdctr)
				TransferTabs(CastCadObjectToCadContour(vcctr), cad_ctr)
				cad_obj_list:AddTail(cad_ctr)
			end
		end

	end
	return cad_obj_list
end


function AddToSelection(cadobjlist, job)
	local selection_list = job.Selection
	selection_list:Clear()
	local pos = cadobjlist:GetHeadPosition()
	local obj
	while (pos) do
		obj, pos = cadobjlist:GetNext(pos)
		selection_list:Add(obj, true, false)
	end
end


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
   -- to avoid excessive redrawing etc  we added vectors to the selection in 'batch' mode
   -- tell selection we have now finished updating
   if objects_selected then
      selection:GroupSelectionFinished()
   end   
   return objects_selected   
end   


function CreateCutoutToolpath(cad_contours, tool, job, thickness, tab_length, layer_name)

	local profile_data = ProfileParameterData()
	profile_data.CutDepth = thickness
	profile_data.StartDepth = 0.0
	profile_data.ProfileSide = ProfileParameterData.PROFILE_ON
	profile_data.UseTabs = true
	profile_data.TabThickness = math.min(0.25*thickness, 0.25)
	profile_data.TabLength = tab_length


	local ramping_data = RampingData()
	ramping_data.DoRamping = true
	ramping_data.RampAngle = 30.0
	ramping_data.RampConstaint = RampingData.CONSTRAIN_ANGLE


	local lead_data = LeadInOutData()

	local pos_data = ToolpathPosData()

	local geometry_selector = GeometrySelector()

	-- AddToSelection(cad_contours, job)
  
  -- Select all on a layer
  local selection = job.Selection
  selection:Clear()
  local layer = job.LayerManager:FindLayerWithName(layer_name)
  SelectVectorsOnLayer(layer, selection, true, true, true)


  
  
  local toolpath_manager = ToolpathManager()
	local toolpath = toolpath_manager:CreateProfilingToolpath(
		"Cut out",
		tool,
		profile_data,
		ramping_data,
		lead_data,
		pos_data,
		geometry_selector,
		true,
		true
		)

	if toolpath == nil then
		DisplayMessageBox("Error Creating toolpath")
	end
end




--[[  -------------- CalculateRails --------------------------------------------------  
|
|  Calculate a list of rails along which we will run our tool
|  Returns a ContourGroup corresponding to this rail
|
]]
function CalculateRails
    (
    side_rail,   -- contour which represents side of dovetial
    angle,       -- angle
    on_left,     -- if true then we create rails to left of side_rail
    offset,      -- Allowance
    tool,        -- tool used
    start_z,     -- depth start cutting
    cut_z        -- depth finish cutting 
    )
  local is_dodgy = false
  if side_rail.StartPoint2D:IsCoincident(Point2D(53, 25), 1) then
    is_dodgy = true
  end
  local side_length = side_rail.Length
  local num_stripes = math.ceil(side_length/ tool.Stepover)
  local stripe_shift = (side_length) / num_stripes
  local horizontal_distance = (math.abs(start_z - cut_z) / math.tan(angle))
  local along_rail = (side_rail.EndPoint2D - side_rail.StartPoint2D):Normalize()
  local contours = {}
  
  -- The normal vector points along the direction we expect
  local normal_vec = (side_rail.EndPoint2D - side_rail.StartPoint2D):NormalTo()
  normal_vec:Normalize()
  normal_vec = (horizontal_distance)*normal_vec
  if (on_left) then
    normal_vec = -normal_vec
  end
  
  -- iterate over the stripes getting start and end points
  local contour_group = ContourGroup(true)
  for i = 1, num_stripes do
    local start_pt = Point3D(side_rail.StartPoint2D  + (i - 1)*stripe_shift*along_rail, start_z)
    local end_pt = Point3D(start_pt.x + normal_vec.x, start_pt.y + normal_vec.y, cut_z)
    local contour = MakeLine(start_pt, end_pt)
    contour_group:AddTail(contour)
  end

  return contour_group
end




--[[  -------------- CalculateToolpathContour --------------------------------------------------  
|
|  From a list of rails calculate the toolpath contour
|
]]
function CalculateToolpathContour
  (
  rails,        -- a contour group corresponding to one set of rails
  rad_angle,    -- angle in radians
  z_depth,      -- z height of cut depth
  pos_data
  )
  
  local toolpath_contour = Contour(0.0)

  if rails.IsEmpty then 
    return
  end

  -- Add start point at safe z height above start point of first rail
  local start_pt = Point3D(rails:GetHead().StartPoint2D, pos_data.SafeZ)
  local lift_z = rails:GetHead().StartPoint3D.z + pos_data.StartZGap
  toolpath_contour:AppendPoint(start_pt)


  local do_backwards = false
  local contour_pos = rails:GetHeadPosition()
  local rail
  while contour_pos ~= nil do
    rail, contour_pos = rails:GetNext(contour_pos)

    if do_backwards then
      toolpath_contour:LineTo(rail.EndPoint3D)
      toolpath_contour:LineTo(rail.StartPoint3D)
    else
      toolpath_contour:LineTo(rail.StartPoint3D)
      toolpath_contour:LineTo(rail.EndPoint3D)
    end
    do_backwards = not do_backwards
  end

-- lift to safe z
  local current_pos = toolpath_contour.EndPoint2D
  toolpath_contour:LineTo(Point3D(current_pos, pos_data.SafeZ))

  return toolpath_contour
end



--[[  -------------- CalculateSideRails --------------------------------------------------  
|
|  Calculate the side rails of our contours
|
]]
function CalculateSideRails
  (
  vectors,    -- vectors for which we hope to construct side rails
  depth,      -- depth of the dovetial
  side_rails, -- side rails
  is_on_left,  -- list indexing whether a given side rail has its dove tail on its right
  tool_diam,
  rad_angle,
  thickness,
  allowance
 )

  for i=1, #vectors do
    local contour = vectors[i]
    local right_contour_normal = contour:GetFirstSpan():StartVector(true):NormalTo()
    local contour_vec = contour:GetFirstSpan():StartVector(true)
    local horizontal_offset = thickness/ math.tan(rad_angle)

    
    local start_start_point = vectors[i].StartPoint2D 
                              - (horizontal_offset + allowance)*contour_vec + 
                              0.5*tool_diam*contour_vec 
                              + allowance*right_contour_normal
                              
    local start_end_point = start_start_point  - (depth+ 2*allowance)*right_contour_normal
    local start_contour = Contour(0.0)
    start_contour:AppendPoint(start_start_point)
    start_contour:LineTo(start_end_point)
    side_rails[#side_rails + 1] = start_contour
    is_on_left[#is_on_left +1] = false -- the start side rail has its dove tail on its right
    
    local end_start_point = vectors[i].EndPoint2D 
                            - 0.5*tool_diam*contour_vec 
                            + (horizontal_offset + allowance)*contour_vec +
                            allowance*right_contour_normal
    local end_end_point = end_start_point - (depth + 2*allowance)*right_contour_normal
    local end_contour = Contour(0.0)
    end_contour:AppendPoint(end_start_point)
    end_contour:LineTo(end_end_point)
    side_rails[#side_rails + 1] = end_contour
    is_on_left[#is_on_left +1] = true -- the end side rail has its dove tail on its left  
  end
 
 end




function CreateDoveTailToolpath(markers, dovetail, tool, allowance)

	-- Calculate side rails
    local side_rails = {}
    local is_on_left = {}
    CalculateSideRails(markers, 
                       dovetail.depth, 
                       side_rails, 
                       is_on_left, 
                       tool.ToolDia, 
                       dovetail.angle, 
                       math.abs(dovetail.cut_z - dovetail.start_z),
                       allowance
                       )

    if (#side_rails == 0 ) then 
      DisplayMessageBox("Unable to create dovetails")
      return false
    end
   
   -- Calculate rails 
    local contour_group = ContourGroup(true)
    local pos_data = ToolpathPosData()
    for i=1, #side_rails do

      -- Returns a contour group for this side rail
      local rails = CalculateRails(side_rails[i], 
                                     dovetail.angle, 
                                     is_on_left[i], 
                                     allowance, 
                                     tool, 
                                     dovetail.start_z,
                                     dovetail.cut_z)

       -- Calculate a single contour from this set of rails                              
      local contour = CalculateToolpathContour(rails, 
                                               dovetail.angle, 
                                               dovetail.cut_z, 
                                               pos_data)

      -- Add the contour to the contour group
      contour_group:AddTail(contour)
    end
    
    

    -- object used to pass data on toolpath settings
    local toolpath_options = ExternalToolpathOptions()
    toolpath_options.StartDepth = dovetail.start_z
    toolpath_options.CreatePreview = true

    if (contour_group.IsEmpty) then 
      DisplayMessageBox("No dove tails created")
      return false
    end
    
    local toolpath = ExternalToolpath(
                                      "Dovetail",
                                      tool,
                                      pos_data,
                                      toolpath_options,
                                      contour_group
                                      )

    if toolpath:Error() then
      DisplayMessageBox("Error creating toolpath")
      return true
    end
  
    local toolpath_manager = ToolpathManager()
    local success = toolpath_manager:AddExternalToolpath(toolpath)
end



function main(script_path)
	local job = VectricJob()
	local mtl_block = MaterialBlock()
    
	local options = {}
	options.width = 18
	options.height = 12
	options.depth = 14
	options.start_point = Point2D(0,0)
	options.thickness = mtl_block.Thickness;
	options.tabwidth = 0.3
	options.cut_layer_name  = "CutOut"
	options.allowance = 0.0
	options.cut_dovetails = false
	options.flat_lid = true
	options.window_width = g_width
	options.window_height = g_height

	options.make_lid = true
	options.make_bottom = true
	options.make_side1 = true
	options.make_side2 = true
	options.make_end1 =  true
	options.make_end2 = true


	local dovetails = ContourGroup(true)
	local dovetail = {}
	dovetail.angle = math.rad(60)
	dovetail.min_width = 1.5
	dovetail.depth = options.thickness
	LoadDefaults(options, dovetail)

	local tool = Tool("0.25 Inch End Mill", Tool.END_MILL)
	tool.ToolDia = 0.25
	tool.InMM = false

	options.tool = tool

	local dialog_displayed = DisplayDialog(script_path, options, dovetail)
	if (not dialog_displayed) then 
		return false
	end
	dovetail.depth = options.thickness
	dovetail.start_z = mtl_block:CalcAbsoluteZFromDepth(0)
	dovetail.start_depth = 0
	dovetail.cut_z = mtl_block:CalcAbsoluteZFromDepth(options.thickness)



	-- Make the bottom face
	local cad_list = CadObjectList(true)
	local dovetail_markers = {}
	local faces = {}

	if options.make_bottom then
		local bottom_face = MakeBottomFaceContour(options.width, 
													options.depth, 
													options.thickness, 
													options.start_point, 
													dovetail, 
													options.cut_dovetails,  -- if true then create dovetails
													"BottomFace" )
		faces[#faces + 1] = bottom_face
	end


	-- -- -- Make sides
	if options.make_side1 then
		local sideface1 = MakeSideFace(options.width,
									  options.height, 
									  options.thickness, 
									  options.start_point, 
									  dovetail, 
									  options.cut_dovetails, 
									  options.flat_lid,
									  "SideFace1")
		faces[#faces + 1] = sideface1
	end

	if options.make_side2 then
		local sideface2 = MakeSideFace(options.width,
									  options.height, 
									  options.thickness, 
									  options.start_point, 
									  dovetail, 
									  options.cut_dovetails, 
									  options.flat_lid,
									  "SideFace2")
		faces[#faces + 1] = sideface2
	end




	-- -- -- Make ends
	if options.make_end1 then
		local endface1 = MakeEndFace(options.depth, 
											   options.height, 
											   options.thickness,
											   options.start_point, 
											   dovetail,
											   options.cut_dovetails, 
											   options.flat_lid,
											   "EndFace1")
		faces[#faces + 1] = endface1
	end

	if options.make_end2 then
		local endface2 = MakeEndFace(options.depth, 
											   options.height, 
											   options.thickness,
											   options.start_point, 
											   dovetail,
											   options.cut_dovetails, 
											   options.flat_lid,
											   "EndFace2")
		faces[#faces + 1] = endface2
	end

	-- Make lid
	if options.make_lid then
		local lid = MakeLid(options.width,
												   options.depth,
												   options.thickness,
												   dovetail.min_width,
												   options.start_point,
												   options.flat_lid,
												   "Lid"
	                       )
		faces[#faces + 1] = lid
	end

	-- Arrange the contours
	faces = ArrangeContours(faces, 2*options.tool.ToolDia, job.XLength, job.YLength)


	-- Get at the actual contours and dogbone them. Then transfer the tabs
	local vdcontours = GetAllProfileContours(faces)
	local cdcontours = GetAllProfileCadContours(faces)
	local offset_radius = 0.5*options.tool.ToolDia - options.allowance
	local dogboned_contours = CreateDogboneProfile(vdcontours, offset_radius)
	local dogboned_cadcontours = CreateTabbedCadContours(dogboned_contours, cdcontours)



	-- -- AddCadContourToJob(job, cad_contour, "Box")
	AddCadListToJob(job, cdcontours, "Box")
	AddCadListToJob(job, dogboned_cadcontours, options.cut_layer_name)

	if options.make_lid then
		if options.flat_lid then 
			CreateLidPocketToolpath(job, options, faces, options.tool, "Pockets" )
		end
	end

    -- if we are doing dovetails make toolpath for them
	local dovetail_markers = GetAllMarkers(faces)
	if options.cut_dovetails and (#dovetail_markers > 0) then
		CreateDoveTailToolpath(dovetail_markers, dovetail, options.tool, options.allowance)
	end

	CreateCutoutToolpath(dogboned_cadcontours, options.tool, job, options.thickness, options.tabwidth, options.cut_layer_name)
	SaveDefaults(options, dovetail)
	job:Refresh2DView()
	return true

end



function DisplayDialog(script_path, options, dovetail)
	local html_path = "file:" .. script_path .. "\\" .. g_html_file
	local dialog = HTML_Dialog(false, html_path, options.window_width, options.window_height, string.format("%s - v%s", g_title, g_version))

	dialog:AddLabelField("GadgetTitle", g_title)
	dialog:AddLabelField("GadgetVersion", g_version)

	-- Add Geometry fields
	dialog:AddDoubleField("WidthField", options.width)
	dialog:AddDoubleField("DepthField", options.depth)
	dialog:AddDoubleField("HeightField", options.height)
	dialog:AddDoubleField("TabWidthField", dovetail.min_width)
	dialog:AddDoubleField("AllowanceField", options.allowance)

	-- dialog:AddDoubleField("DovetailAngleField", dovetail.angle)
	dialog:AddCheckBox("MakeLid", options.make_lid)
	dialog:AddCheckBox("MakeBottom", options.make_bottom)
	dialog:AddCheckBox("MakeSide1", options.make_side1)
	dialog:AddCheckBox("MakeSide2", options.make_side2)
	dialog:AddCheckBox("MakeEnd1", options.make_end1)
	dialog:AddCheckBox("MakeEnd2", options.make_end2)


	-- Add Tool picker
	-- Add toolpath name field
   dialog:AddLabelField("ToolNameField", "")
	dialog:AddToolPicker("ToolChooseButton", "ToolNameField", options.default_toolid)
	dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)

	dialog:AddRadioGroup("TabTypeRadio", 2)
	dialog:AddRadioGroup("LidTypeRadio", 1)

	-- Add units label
	local units_string = "Inches"
	if options.tool.InMM then
		units_string = "MM"
	end

	dialog:AddTextField("UnitsLabel", units_string)

  local validator = function(dialog)
    ReadOptions(dialog, options, dovetail)
    local double_thickness = options.thickness * 2
    if options.width <= double_thickness then
      DisplayMessageBox(string.format("The box width %f is too small for material thickness %f", options.width, options.thickness))
      return false
    end
    if options.depth <= double_thickness then
      DisplayMessageBox(string.format("The box depth %f is too small for material thickness %f", options.depth, options.thickness))
      return false
    end
    if options.height <= double_thickness then
      DisplayMessageBox(string.format("The box height %f is too small for material thickness %f", options.height, options.thickness))
      return false
    end
    local inner_width = options.width - double_thickness
    local inner_depth = options.depth - double_thickness
    local inner_height = options.height - double_thickness
    local num_flaps_w = math.floor((0.5*inner_width) / dovetail.min_width)
    local total_tab_space_w = (inner_width - num_flaps_w*dovetail.min_width)
    local num_flaps_d = math.floor((0.5*inner_depth) / dovetail.min_width)
    local total_tab_space_d = (inner_depth - num_flaps_d*dovetail.min_width)
    local num_flaps_h = math.floor((0.5*inner_height) / dovetail.min_width)
    local total_tab_space_h = (inner_height - num_flaps_h*dovetail.min_width)
    if (num_flaps_w < 1) or (total_tab_space_w < 0) then
      DisplayMessageBox(string.format("The joint width %f is too big given box inner width is %f", dovetail.min_width, inner_width))
      return false
    end
    if (num_flaps_d < 1) or (total_tab_space_d < 0) then
      DisplayMessageBox(string.format("The joint width %f is too big given box inner depth is %f", dovetail.min_width, inner_depth))
      return false
    end
    if (num_flaps_h < 1) or (total_tab_space_h < 0) then
      DisplayMessageBox(string.format("The joint width %f is too big given box inner height is %f", dovetail.min_width, inner_height))
      return false
    end
    
    -- Check if tool will fit
    local tab_space_w = total_tab_space_w / (num_flaps_w + 1)
    local tab_space_d = total_tab_space_d / (num_flaps_d + 1)
    local tab_space_h = total_tab_space_h / (num_flaps_h + 1)
    local dia = options.tool.ToolDia
    if options.allowance > 0 then
      dia = dia - 2 * options.allowance
    end
      
    if options.cut_dovetails then
      local min_space = dovetail.max_width - dovetail.min_width

      -- make sure dovetails don't overlap
      if (tab_space_w <= min_space) or (tab_space_d <= min_space) or (tab_space_h <= min_space) then        
        DisplayMessageBox("The joint width is too small")
        return false
      end      

      min_space = min_space + dia
      if (tab_space_w <= min_space) or (tab_space_d <= min_space) or (tab_space_h <= min_space) then        
        DisplayMessageBox("The selected tool will not fit between the joints")
        return false
      end  
    else
      tab_space_w = math.min(tab_space_w, dovetail.min_width)
      tab_space_d = math.min(tab_space_d, dovetail.min_width)
      tab_space_h = math.min(tab_space_h, dovetail.min_width)
      if (tab_space_w <= dia) or (tab_space_d <= dia) or (tab_space_h <= dia) then        
        DisplayMessageBox("The selected tool will not fit between the joints")
        return false
      end
    end
    
    return true
  end

  if GetBuildVersion() >= 9.513 then
    dialog:OnValidate(validator)  
    local success = dialog:ShowDialog()

    if not success then
      return false
    end
  else  
    repeat
      local success = dialog:ShowDialog()

      if not success then
        return false
      end
    until validator(dialog)    
  end
  
  ReadOptions(dialog, options, dovetail)

	return true

end

function OnLuaButton_TabTypeRadio1()
  return true
end

function OnLuaButton_TabTypeRadio2()
  return true
end

function OnLuaButton_LidTypeRadio2()
  return true
end

function OnLuaButton_LidTypeRadio1()
  return true
end

function OnLuaButton_MakeLid()
  return true
end
function OnLuaButton_MakeBottom()
  return true
end
function OnLuaButton_MakeSide1()
  return true
end
function OnLuaButton_MakeSide2()
  return true
end
function OnLuaButton_MakeEnd1()
  return true
end
function OnLuaButton_MakeEnd2()
  return true
end
-- ========================================================
function ReadOptions(dialog, options, dovetail)
	-- Read back data from the form
	options.width = dialog:GetDoubleField("WidthField")
	options.depth = dialog:GetDoubleField("DepthField")
	options.height = dialog:GetDoubleField("HeightField")
	options.tabwidth = dialog:GetDoubleField("TabWidthField")
    dovetail.min_width = options.tabwidth
	options.allowance = dialog:GetDoubleField("AllowanceField")
	options.make_lid = dialog:GetCheckBox("MakeLid")
	options.make_bottom = dialog:GetCheckBox("MakeBottom")
	options.make_side1 = dialog:GetCheckBox("MakeSide1")
	options.make_side2 = dialog:GetCheckBox("MakeSide2")
	options.make_end1 = dialog:GetCheckBox("MakeEnd1")
	options.make_end2 = dialog:GetCheckBox("MakeEnd2")
	--dovetail.angle = dialog:GetDoubleField("DovetailAngleField")
	dovetail.max_width = dovetail.min_width + (2*options.thickness / math.tan(dovetail.angle))

	local tab_index = dialog:GetRadioIndex("TabTypeRadio")
	if tab_index == 1 then
		options.cut_dovetails = false
	else
		options.cut_dovetails = true
	end

	local lid_index = dialog:GetRadioIndex("LidTypeRadio")
	if lid_index == 1 then
		options.flat_lid = true
	else
		options.flat_lid = false
	end

	-- Get from tool picker
	options.tool = dialog:GetTool("ToolChooseButton")

	options.window_width = dialog.WindowWidth
	options.window_height = dialog.WindowHeight
end
-- ========================================================
function SaveDefaults(options, dovetail)
  local registry = Registry("BoxCreatorGadget")
  registry:SetDouble("WindowWidth", options.window_width)
  registry:SetDouble("WindowHeight", options.window_height)

  registry:SetDouble("Width", options.width)
  registry:SetDouble("Height", options.height)
  registry:SetDouble("Depth", options.depth)
  registry:SetDouble("JointWidth", options.tabwidth)
  registry:SetBool("CutDovetails", options.cut_dovetails)
  registry:SetBool("FlatLid", options.flat_lid)
  registry:SetDouble("DoveTailWidth", dovetail.min_width)
  if options.tool ~= nil then
   options.tool.ToolDBId:SaveDefaults("BoxCreatorGadget", "")
  end

  registry:SetBool("MakeLid", options.make_lid)
  registry:SetBool("MakeBottom", options.make_bottom)
  registry:SetBool("MakeSide1", options.make_side1)
  registry:SetBool("MakeSide2", options.make_side2)
  registry:SetBool("MakeEnd1", options.make_end1)
  registry:SetBool("MakeEnd2", options.make_end2)

end

-- ========================================================
function LoadDefaults(options, dovetail)
  local registry = Registry("BoxCreatorGadget")
  options.window_width = registry:GetDouble("WindowWidth", options.window_width)
  options.window_height = registry:GetDouble("WindowHeight", options.window_height)

  options.width = registry:GetDouble("Width", options.width)
  options.height = registry:GetDouble("Height", options.height)
  options.depth = registry:GetDouble("Depth", options.depth)
  options.tabwidth = registry:GetDouble("JointWidth", options.tabwidth)
  dovetail.min_width = options.tabwidth
  options.cut_dovetails = registry:GetBool("CutDovetails", options.cut_dovetails)
  options.flat_lid = registry:GetBool("FlatLid", options.flat_lid)
  options.default_toolid = ToolDBId("BoxCreatorGadget", "")

  options.make_lid = registry:GetBool("MakeLid", options.make_lid)
  options.make_bottom = registry:GetBool("MakeBottom", options.make_bottom)
  options.make_side1 = registry:GetBool("MakeSide1", options.make_side1)
  options.make_side2 = registry:GetBool("MakeSide2", options.make_side2)
  options.make_end1 = registry:GetBool("MakeEnd1", options.make_end1)
  options.make_end2 = registry:GetBool("MakeEnd2", options.make_end2)
end
