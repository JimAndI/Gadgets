-- VECTRIC LUA SCRIPT

--require("mobdebug").start()
--require "strict"

g_HALFPI = 1.57079632679
g_THREEPIBYTWO = 4.71238898038
g_version = "1.0"
g_html_file = "DetectDoveTails.htm"
g_title = "Dovetail Joint Detector"
g_width = 800
g_height = 600

--[[  -------------- AddGroupToJob --------------------------------------------------  
|
|  Adds a group of contours to a job
|
]]
function AddGroupToJob(vectric_job, group, layer_name, create_group)

   --  create a CadObject to represent the  group 
   local layer = vectric_job.LayerManager:GetLayerWithName(layer_name)
   layer:SetColour(1.0, 0.5, 0.0)
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


--[[  -------------- GetNextFiveSpans --------------------------------------------------  
|
| Get the next five spans starting at given pos 
|
]]
function GetNextFiveSpans(contour, pos)


  -- First check if the contour has at least 5 spans
  if contour.Count < 5 then
    return false
  end

  local spans = {}
  local span
  local num_spans = 0;
  while pos ~= nil and num_spans < 5 do
    span, pos = contour:GetNext(pos);
    spans[num_spans] = span
    num_spans = num_spans  + 1
    if pos == nil then
      pos = contour:GetHeadPosition()
    end
  end

  return spans
end




--[[  -------------- ConvertListToContourGroup --------------------------------------------------  
|
|  Convert a lua list of contours into a contour group
|
]]
function ConvertListToContourGroup
  (
    contour_list
  )
  local contour_group = ContourGroup(true)
  for i= 1, #contour_list do
    contour_group:AddTail(contour_list[i])
  end
  return contour_group
end


--[[  -------------- IsOrthogonal --------------------------------------------------  
|
|  return true if the angle  <ABC is a right angle
|
]]
function IsOrthogonal
  (
  a,
  b,
  c
  )
--local angle = AngleCCWBetween( b - a, c - b)
local prod = (b.x -a.x)* (b.x - c.x) + (b.y - a.y)* ( b.y - c.y)
local signed_area = a.x*b.y - b.x*a.y + b.x*c.y - c.x*b.y + c.x*a.y - a.x*c.y-- if signed area +ve then ccw 
return (math.abs(prod - 0) < 0.1 and (signed_area > 0));

end


--[[  -------------- CollectLinesOnLayer --------------------------------------------------  
|
|  collect all the vectors on layer with given name
|
]]
function CollectLinesOnLayer
  (
  layer_name, -- name of layer on which collect all vectors which are straight lines
  job        -- vectric job which is assumed to exist
  )

  local layer_manager = job.LayerManager
  local layer  = layer_manager:GetLayerWithName(layer_name)
  local vectors = {}
  local pos = layer:GetHeadPosition()
  local cad_object
  while (pos ~= nil) do
    cad_object, pos = layer:GetNext(pos)
    local contour = cad_object:GetContour()
    if (contour ~= nil) then
      if (contour.Count == 1 and contour:GetFirstSpan().IsLineType) then
        vectors[#vectors + 1] = contour:Clone()
      end
    end
  end
  return vectors
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

--[[  -------------- GetSelectedVectors --------------------------------------------------  
|
|  Get Selected vectors off the job
|
]]
function GetSelectedVectors(job)
  
  local selection_list = job.Selection
  local ret_contours = ContourGroup(true)
  
  local pos = selection_list:GetHeadPosition()
  local cad_obj
  while (pos ~= nil) do
    cad_obj, pos = selection_list:GetNext(pos)
    
    local contour = cad_obj:GetContour()
    if contour == nil then
      DisplayMessageBox("Found objects with no contour data. Ignoring")
    else
      ret_contours:AddTail(contour:Clone())
    end
  end
  return ret_contours
end



--[[  -------------- DetectAllDoveTails --------------------------------------------------  
|
|  Detect and return a list of all possible joining dovetail vectors. Assume on left
|
]]
function DetectAllDoveTails
  (
  layer_name,
  job,
  depth
  )
  local vectors = {}
  local cad_object

  local selected_vectors = GetSelectedVectors(job);
  local pos = selected_vectors :GetHeadPosition();
  local contour
  while (pos ~= nil) do
    contour,pos = selected_vectors:GetNext(pos):Clone()

    if contour.IsClockwise and contour.IsClosed then
      contour:Reverse()
    end
    
    if (contour ~= nil) then
      -- iterate over the spans looking forward to see if a span forms
      -- part of a suspected dovetail
      local span_pos = contour:GetHeadPosition()
      local span
      while (span_pos ~= nil) do
        local start_pt = Point2D()
        local end_pt = Point2D()
        local spans = GetNextFiveSpans(contour, span_pos)
        
        if spans then
          if IsSpanDoveTail(spans, start_pt, end_pt, depth) then
            vectors[#vectors + 1] = MakeLine(start_pt, end_pt)
          end          
        end
        
 
       span, span_pos = contour:GetNext(span_pos)
       end
    end  
  end
  return vectors
end

--[[  -------------- IsSpanDoveTail --------------------------------------------------  
|
|  Determine whether a given span is the first span in a dovetail:
|
|                     c_________________d
|                     |                 |
|                     |                 |} Depth    
|                a_____|                 |______f
|                span  b               e       
|
|  Returns the start and endpoint of the line which bridges the gap if it is.
|  Assumption is that all dovetails must appear on the left
]]
function IsSpanDoveTail
  (
    spans,
    start_pt,
    end_pt,
    depth
  )


if math.abs(spans[1]:GetLength(0.0) - depth) > 0.001 then
  return false
end

if math.abs(spans[3]:GetLength(0.0) - depth) > 0.001 then
  return false
end




-- We check that we form a rectangle
local a = spans[0].StartPoint2D
local b = spans[1].StartPoint2D
local c = spans[2].StartPoint2D
local d = spans[3].StartPoint2D
local e = spans[4].StartPoint2D
local f = spans[4].EndPoint2D

if not IsOrthogonal(a, b, c) then
  return false
end

  
if not IsOrthogonal(d, c,b) then
  return false;
end 

if not IsOrthogonal(e, d, c) then
  return false;
end

if not IsOrthogonal(d, e, f) then
  return false;
end
  
if not IsOrthogonal(b, e, d) then
  return false 
end

if not IsOrthogonal(c, b, e) then
  return false;
end

start_pt:Set(b.x, b.y)
end_pt:Set(e.x, e.y)

return true
-- end of function
end




--[[  -------------- CalculateRails --------------------------------------------------  
|
|  Calculate a list of rails along which we will run our tool
|
]]
function CalculateRails
    (
    side_rail,   -- contour which represents side of dovetial
    angle,       -- angle
    on_left,     -- if true then we create rails to left of side_rail
    offset,      -- 
    tool,        -- tool used
    start_z,     -- depth start cutting
    cut_z        -- depth finish cutting 
    )
    
  local num_stripes = math.ceil(side_rail.Length/ tool.Stepover)
  local stripe_shift = (side_rail.Length) / num_stripes
  local horizontal_distance = (math.abs(start_z - cut_z) / math.tan(angle))
  local along_rail = (side_rail.EndPoint2D - side_rail.StartPoint2D):Normalize()
  local contours = {}
  
  -- The normal vector points along the direction we expect
  local normal_vec = (side_rail.EndPoint2D - side_rail.StartPoint2D):NormalTo()
  normal_vec:Normalize()
  normal_vec = horizontal_distance*normal_vec
  if (on_left) then
    normal_vec = -normal_vec
  end
  
  -- iterate over the stripes getting start and end points
  for i = 1, num_stripes do
    local start_pt = Point3D(side_rail.StartPoint2D  + (i - 1)*stripe_shift*along_rail, start_z)
    local end_pt = Point3D(start_pt.x + normal_vec.x, start_pt.y + normal_vec.y, cut_z)
    local contour = Contour(0.0)
    contour:AppendPoint(start_pt)
    contour:LineTo(end_pt)
    contours[i] = contour
  end
 
  return contours
end




--[[  -------------- CalculateToolpathContour --------------------------------------------------  
|
|  From a list of rails calculate the toolpath contour
|
]]
function CalculateToolpathContour
  (
  rails,        -- a lua list of rail contours
  rad_angle,    -- angle in radians
  z_depth,      -- z height of cut depth
  pass_depth    -- pass depth
  )
  
  local toolpath_contour = Contour(0.0)

  local safe_z =  1;
  toolpath_contour:AppendPoint(0,0,safe_z)
  for i=1, #rails do
    local rail = rails[i]
    
    -- Determine max distance to travel along rail in order to not
    -- exceed the pass depth.
    local pass_distance_along = pass_depth / math.sin(rad_angle)
    local num_passes = math.ceil(math.abs(z_depth)/pass_depth)
    local vec_along_rail = (rail.EndPoint3D - rail.StartPoint3D):Normalize()
    local rail_length =( rail.EndPoint3D - rail.StartPoint3D).Length -- Don't use rail.Length!
    local pass_distance_along = rail_length / num_passes

    local const_z_rail = Vector3D(vec_along_rail.x, vec_along_rail.y, 0)
    local end_point_2d = rail.EndPoint2D
    
    toolpath_contour:LineTo(rail.StartPoint3D)
    local current_pos = rail.StartPoint3D
    for j=1, num_passes do
      
        -- Move along rail
        current_pos = rail.StartPoint3D + j*pass_distance_along*vec_along_rail
        toolpath_contour:LineTo(current_pos)
        
        -- Move with fixed z to end point 
        current_pos:Set(end_point_2d.x, end_point_2d.y, current_pos.z)
        toolpath_contour:LineTo(current_pos)
        
        -- Move with fixed x and y to the safe z
        current_pos.z = safe_z
        toolpath_contour:LineTo(current_pos)
    end  
  end
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
  thickness
 )

  for i=1, #vectors do
    local contour = vectors[i]
    local left_contour_normal = contour:GetFirstSpan():StartVector(true):NormalTo()
    local contour_vec = contour:GetFirstSpan():StartVector(true)
    local horizontal_offset = thickness/ math.tan(rad_angle)
    
    local start_start_point = vectors[i].StartPoint2D - horizontal_offset*contour_vec + 0.5*tool_diam*contour_vec
    local start_end_point = start_start_point  - depth*left_contour_normal
    local start_contour = Contour(0.0)
    start_contour:AppendPoint(start_start_point)
    start_contour:LineTo(start_end_point)
    side_rails[#side_rails + 1] = start_contour
    is_on_left[#is_on_left +1] = false -- the start side rail has its dove tail on its right
    
    local end_start_point = vectors[i].EndPoint2D - 0.5*tool_diam*contour_vec + horizontal_offset*contour_vec
    local end_end_point = end_start_point - depth*left_contour_normal
    local end_contour = Contour(0.0)
    end_contour:AppendPoint(end_start_point)
    end_contour:LineTo(end_end_point)
    side_rails[#side_rails + 1] = end_contour
    is_on_left[#is_on_left +1] = true -- the end side rail has its dove tail on its left  
  end
  
  
end

--[[  -------------- main --------------------------------------------------  
|
|  Start point of script
|
]]
function main(script_path)


    -- Check if there is an existing job if not then quit
    local job = VectricJob()
    if not job.Exists then
      DisplayMessageBox("No job loaded")
      return false
    end
    
    -- Create initial default data
    local layer_name = "Dovetails"
    local tool = Tool("DoveTail End Mill", Tool.END_MILL)
    tool.InMM = false
    tool.ToolDia = 0.0625
    tool.Stepover = 0.2*tool.ToolDia
    tool.Stepdown = 0.47
    
    local options = {}
    options.layer_name = "Search layer ..."
    options.marker_layer_name = "Marker layer ..."
    options.angle = math.rad(45)
    options.start_z = 0
    options.cut_z = -0.47
    options.toolpath_name = "doves"
    options.depth = 0.4702
    options.allowance = 0
    options.in_mm = job.InMM
    options.units_string = "Inches"
    if options.in_mm then
      options.units_string = "MM"
    end
    options.windowWidth = g_width
    options.windowHeight = g_height
    
    
    local material_block = MaterialBlock()
    local material_thickness = material_block.Thickness
    ReadFromRegistry(options, material_thickness)
    

    -- Display the dialog
    local displayed_dialog = -1
    while displayed_dialog == -1 do
      displayed_dialog = DisplayDialog(script_path, options)
    end
    
    if not displayed_dialog then
      return false
    end
    
    
    
    -- Collect all lines
    local vecs = DetectAllDoveTails( options.layer_name, job, options.depth)
    if #vecs == 0 then
      DisplayMessageBox("No dovetails found!")
      return false
    end

    local cg = ConvertListToContourGroup(vecs)
    if cg.IsEmpty then
      DisplayMessageBox("There was a problem creating contours.")
      return false
    end

    AddGroupToJob(job, cg, options.marker_layer_name, false)
  
    SaveToRegistry(options)
    job:Refresh2DView()
    return true
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

  -- Add depth field
  dialog:AddDoubleField("DoveTailDepth", options.depth)
  -- dialog:AddTextField("SearchLayerName", options.layer_name)
  dialog:AddTextField("MarkerLayerName", options.marker_layer_name)
  dialog:AddTextField("UnitsLabel", options.units_string)

  -- Display the dialog
  local success = dialog:ShowDialog()
  if not success then
    return false
  end

  -- Read back from the form
  options.depth = dialog:GetDoubleField("DoveTailDepth")
  -- options.layer_name = dialog:GetTextField("SearchLayerName")
  options.marker_layer_name = dialog:GetTextField("MarkerLayerName")

  options.windowWidth = dialog.WindowWidth
  options.windowHeight = dialog.WindowHeight

  -- Check that the layer names are non-empty and that the depth >0
  if (options.depth <=0 ) then
    DisplayMessageBox("The dovetail depth must be positive.")
    return -1
  end

  if (options.layer_name == "" or options.layer_name == "") then
    DisplayMessageBox("You must enter geometry and marker layers")
    return -1
  end

  return success


end    
    
--[[  -------------- SaveToRegistry --------------------------------------------------  
|
|  Save settings to registry
|
]]
function SaveToRegistry( options )
  -- Save options to registry
  local registry = Registry("DoveTailGadget")
  registry:SetString("LayerName", options.layer_name)
  registry:SetString("MarkerLayerName", options.marker_layer_name)
  registry:SetDouble("Thickness", options.depth)

  local detect_registry = Registry("DoveTailDetectGadget")
  detect_registry:SetInt("WindowWidth", options.windowWidth)
  detect_registry:SetInt("windowHeight", options.windowHeight)
end

--[[  -------------- ReadFromRegistry --------------------------------------------------  
|
|  Read settings from registry
|
]]
function ReadFromRegistry( options, material_thickness )
  -- Save options to registry
  local registry = Registry("DoveTailGadget")
  options.layer_name = registry:GetString("LayerName", "Search layer name ...")
  options.marker_layer_name = registry:GetString("MarkerLayerName", "Marker layer name ...")
  options.depth = registry:GetDouble("Thickness", material_thickness)

  local detect_registry = Registry("DoveTailDetectGadget")
  options.windowWidth = detect_registry:GetInt("WindowWidth", g_width)
  options.windowHeight = detect_registry:GetInt("WindowHeight", g_height)
end
