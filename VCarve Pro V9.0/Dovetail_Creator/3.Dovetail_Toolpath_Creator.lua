-- VECTRIC LUA SCRIPT

--require("mobdebug").start()
--require "strict"

g_HALFPI = 1.57079632679
g_THREEPIBYTWO = 4.71238898038
g_version = "1.0"
g_title = "Dovetail Toolpath Creator"
g_width = 800
g_height = 600
g_html_file = "CreateDovetails.htm"
g_debug = true




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
     layer:AddObject(cad_contour)
   end
   

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

--[[  -------------- FilterByLines --------------------------------------------------  
|
|  collect all the vectors on layer with given name
|
]]
function FilterByLines
  (
  selected_vecs
  )

  local vectors = {}
  local pos = selected_vecs:GetHeadPosition()
  local contour
  while (pos ~= nil) do
    contour, pos = selected_vecs:GetNext(pos)
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
  local layer_manager = job.LayerManager
  local layer  = layer_manager:GetLayerWithName(layer_name)
  local vectors = {}
  local pos = layer:GetHeadPosition()
  local cad_object
  while (pos ~= nil) do
    cad_object, pos = layer:GetNext(pos)
    local contour = cad_object:GetContour():Clone()
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
        if IsSpanDoveTail(contour,span_pos, start_pt, end_pt, depth) then
          vectors[#vectors + 1] = MakeLine(start_pt, end_pt)
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
|                      c_________________d
|                      |                 |
|                      |                 |} Depth    
|                a_____|                 |______f
|                span  b               e       
|
|  Returns the start and endpoint of the line which bridges the gap if it is.
|  Assumption is that all dovetails must appear on the left
]]
function IsSpanDoveTail
  (
    contour, 
    span_pos,
    start_pt,
    end_pt,
    depth
  )

 local start_span
start_span, span_pos = contour:GetNext(span_pos)
start_pt:Set(start_span.EndPoint2D.x, start_span.EndPoint2D.y)
local spans = {}
spans[0] = start_span

-- Collect next 4 spans returning false if lengths are wrong
local span
local span_index = 0;
while(span_pos and span_index < 4) do
  span, span_pos = contour:GetNext(span_pos)
  span_index = span_index + 1
  
  if (not span.IsLineType) then
    return false
  end
  
  
  if (span_index % 2) == 1 and (math.abs(span:GetLength(0.0) - depth) > 0.001) then
    return false;
  end
  
  
  spans[span_index] = span
end

if #spans < 4 then
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

end_pt:Set(e.x, e.y)

return true
-- end of function
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

  local side_length = side_rail.Length
  if side_rail.StartPoint2D:IsCoincident(Point2D(17.1,18.8), 0.25) then
    local is_dodgy = true
  end
  local num_stripes = math.ceil(side_length/ tool.Stepover)
  local stripe_shift = (side_length) / num_stripes
  local horizontal_distance = (math.abs(start_z - cut_z) / math.tan(0.5*math.pi -angle))
  
  local along_rail = (side_rail.EndPoint2D - side_rail.StartPoint2D)
  along_rail:Normalize()
  --local memtest = luaMemTest(along_rail)
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
  local last_start_point = Point2D()
  local last_end_point = Point2D()
  local shown_box = false
  for i = 1, num_stripes do
    local start_pt = Point3D(side_rail.StartPoint2D  + (i - 1)*stripe_shift*along_rail, start_z)
    local end_pt = Point3D(start_pt.x + normal_vec.x, start_pt.y + normal_vec.y, cut_z)
    
    if (not last_start_point.IsInvalid) then
      if (last_start_point - start_pt).Length > 1.1*stripe_shift then
        if not shown_box then
          DisplayMessageBox("Bad Stripe : \n" ..
                            "RailStartPoint : " .. side_rail.StartPoint2D.x .. ", " .. side_rail.StartPoint2D.y .. "\n" ..
                            "StartPoint : " .. start_pt.x .. ", " .. start_pt.y .. "\n" ..
                            "EndPoint : " .. end_pt.x .. ", " .. end_pt.y .. "\n" ..
                            "i =" .. i .. "\n" ..
                            "StripeShift" .. stripe_shift .. "\n" ..
                            "Along  :" .. along_rail.x .. ", " .. along_rail.y .. "\n"
                          )
          shown_box = true
        end
      end
      if (last_end_point - end_pt).Length > 1.1*stripe_shift then
        if not shown_box then
          DisplayMessageBox("Bad Stripe : \n" ..
                            "RailStartPoint : " .. side_rail.StartPoint2D.x .. ", " .. side_rail.StartPoint2D.y .. "\n" ..
                            "StartPoint : " .. start_pt.x .. ", " .. start_pt.y .. "\n" ..
                            "EndPoint : " .. end_pt.x .. ", " .. end_pt.y .. "\n" ..
                            "i =" .. i .. "\n" ..
                            "StripeShift" .. stripe_shift .. "\n" ..
                            "Along  :" .. along_rail.x .. ", " .. along_rail.y .. "\n"
                          )
          shown_box = true
        end  
      end
    end
    last_start_point = start_pt
    last_end_point = end_pt
    
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
  pos_data,
  max_dist
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
    local horizontal_offset = thickness/ math.tan(0.5*math.pi - rad_angle)

    
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
    local material_block = MaterialBlock()
    local material_thickness = material_block.Thickness

    -- Set global options
    local options = {}
    options.layer_name = "Search layer ..."
    options.marker_layer_name = "Marker layer ..."
    options.angle = math.rad(30)
    options.start_depth = 0
    options.cut_depth = material_thickness
    options.start_z = material_block:CalcAbsoluteZFromDepth(0)
    options.cut_z = material_block:CalcAbsoluteZFromDepth(material_thickness)
    options.toolpath_name = "Doves"
    options.depth = material_thickness
    options.allowance = 0.0
    options.WindowWidth = g_width
    options.WindowHeight = g_height

    ReadFromRegistry(options, material_thickness)

    -- Display the dialog
    local displayed_dialog = -1
    while displayed_dialog == -1 do
      displayed_dialog = DisplayDialog(script_path, options)
    end
    
    if not displayed_dialog then 
      return false
    end


    -- Recalculate start_z and cut_z
    options.start_z = material_block:CalcAbsoluteZFromDepth(options.start_depth)
    options.cut_z = material_block:CalcAbsoluteZFromDepth(options.depth)
    

    -- Collect all lines on given layer    
    local vecs = CollectLinesOnLayer(options.marker_layer_name, job)
    --local selected_vecs = GetSelectedVectors(job)
    --local vecs = FilterByLines(selected_vecs)

    if (#vecs == 0 ) then
      DisplayMessageBox("No markers found")
      return false
    end

    -- Calculate side rails
    local side_rails = {}
    local is_on_left = {}
    CalculateSideRails(vecs, 
                       options.depth, 
                       side_rails, 
                       is_on_left, 
                       options.tool.ToolDia, 
                       options.angle, 
                       math.abs(options.cut_z - options.start_z),
                       options.allowance
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
                                     options.angle, 
                                     is_on_left[i], 
                                     options.allowance, 
                                     options.tool, 
                                     options.start_z,
                                     options.cut_z)

       -- Calculate a single contour from this set of rails                              
      local contour = CalculateToolpathContour(rails, 
                                               options.angle, 
                                               options.cut_z, 
                                               pos_data)

      -- Add the contour to the contour group
      contour_group:AddTail(contour)
    end
    
    

    -- object used to pass data on toolpath settings
    local toolpath_options = ExternalToolpathOptions()
    toolpath_options.StartDepth = options.start_z
    toolpath_options.CreatePreview = true

    if (contour_group.IsEmpty) then 
      DisplayMessageBox("No dove tails created")
      return false
    end
    
    local toolpath = ExternalToolpath(
                                      options.toolpath_name,
                                      options.tool,
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
    if success then
      SaveToRegistry(options)
    end
    return success
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

      -- Add geometry fields
      dialog:AddDoubleField("ThicknessField", options.depth)

      local human_angle = tonumber(string.format("%.3f", math.deg(options.angle)))
      dialog:AddDoubleField("AngleField", human_angle)
      dialog:AddDoubleField("StartDepthField", options.start_depth)
      dialog:AddDoubleField("CutDepthField", options.cut_depth)
      dialog:AddDoubleField("CutAllowanceField", options.allowance)
      dialog:AddTextField("MarkerLayerField", options.marker_layer_name)

      -- Add toolpath button
      dialog:AddLabelField("ToolNameField", "")
      dialog:AddToolPicker("ToolChooseButton", "ToolNameField", options.default_toolname)
      dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
      
      -- Add toolpath name field
      dialog:AddTextField("ToolpathNameField", options.toolpath_name)
      

 

      -- Add units labels
      local units_string = "Inches"
      if (options.in_mm) then
        units_string = "MM"
      end

      dialog:AddTextField("UnitsLabel1", units_string)
      dialog:AddTextField("UnitsLabel2", units_string)
      dialog:AddTextField("UnitsLabel3", units_string)
      dialog:AddTextField("UnitsLabel4", units_string)
      dialog:AddTextField("UnitsLabel5", units_string)

      -- Display the dialog
      local success = dialog:ShowDialog()

      if not success then 
        return false;
      end

      -- Read back from the form
      options.tool = dialog:GetTool("ToolChooseButton")
      if options.tool == nil then
        DisplayMessageBox("No Tool Selected.")
        return false
      end

      options.depth = dialog:GetDoubleField("ThicknessField")
      if (options.depth <= 0 ) then
          DisplayMessageBox("You must set a positive thickness")
          return -1
        end

      options.angle = math.rad(dialog:GetDoubleField("AngleField"))
      if (options.angle < 0 or options.angle > g_HALFPI) then
        DisplayMessageBox("You must choose an angle between 0 and 90 degrees")
        return -1
      end

      options.start_depth = dialog:GetDoubleField("StartDepthField")
      options.cut_depth = dialog:GetDoubleField("CutDepthField")
      if (options.start_depth <0 or options.cut_depth <= 0) then
        DisplayMessageBox("Start and cut depth must be positive")
        return -1
      end

      options.allowance = dialog:GetDoubleField("CutAllowanceField")
      if (options.allowance < 0) then
        DisplayMessageBox("Cut allowance must be positive")
        return -1
      end

      options.marker_layer_name = dialog:GetTextField("MarkerLayerField")
      if (options.marker_layer_name == "") then
        DisplayMessageBox("You must specify a marker layer.")
        return -1
      end

      options.toolpath_name = dialog:GetTextField("ToolpathNameField")
      if (options.toolpath_name == "") then
        DisplayMessageBox("You must specify a toolpath name")
        return -1
      end

      options.windowWidth = dialog.WindowWidth
      options.windowHeight = dialog.WindowHeight

      return success
  end    
  
  
--[[  -------------- SaveToRegistry --------------------------------------------------  
|
|  Save settings to registry
|
]]
function SaveToRegistry(options)
  local registry = Registry("DoveTailGadget")
  registry:SetString("LayerName", options.layer_name)
  registry:SetString("MarkerLayerName", options.marker_layer_name)
  registry:SetDouble("Angle", options.angle)
  registry:SetString("ToolpathName", options.toolpath_name)
  registry:SetDouble("Thickness", options.depth)
  registry:SetDouble("Allowance", options.allowance)
  registry:SetDouble("StartDepth", options.start_depth)
  registry:SetDouble("CutDepth", options.cut_depth)
  registry:SetString("ToolName", options.tool.Name)

  local detect_registry = Registry("DoveTailCreateGadget")
  detect_registry:SetInt("WindowWidth", options.windowWidth)
  detect_registry:SetInt("windowHeight", options.windowHeight)

end



--[[  -------------- ReadFromRegistry --------------------------------------------------  
|
|  Read settings from registry
|
]]
function ReadFromRegistry(options, material_thickness)
  -- Read Settings from the registry
  local registry = Registry("DoveTailGadget")
  options.layer_name  = registry:GetString("LayerName", "Search layer name ... ")
  options.marker_layer_name = registry:GetString("MarkerLayerName", "Marker layer name ...")
  options.angle = registry:GetDouble("Angle", options.angle)
  options.toolpath_name = registry:GetString("ToolpathName", "Name of toolpath ...")
  options.depth =  registry:GetDouble("Thickness", material_thickness)
  options.allowance = registry:GetDouble("Allowance", 0)
  options.start_depth = registry:GetDouble("StartDepth", 0 )
  options.cut_depth = registry:GetDouble("CutDepth", material_thickness)
  options.default_toolname = registry:GetString("ToolName", "")

  local detect_registry = Registry("DoveTailCreateGadget")
  options.windowWidth = detect_registry:GetInt("WindowWidth", g_width)
  options.windowHeight = detect_registry:GetInt("WindowHeight", g_height)
end




    
    