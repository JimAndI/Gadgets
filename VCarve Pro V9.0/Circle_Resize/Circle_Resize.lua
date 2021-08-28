-- VECTRIC LUA SCRIPT
-- Copyright 2013 Vectric Ltd.

-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

require "strict"

-- Global default values - persist via registry

g_version         = "1.0"
g_title           = "Circle Resize"
g_html_file       = "circle_resize.htm"
g_width           = 600
g_height          = 400
g_bulge90         = 0.41421356237309515


g_default_window_width  = 520
g_default_window_height = 420


--[[  -------------- main --------------------------------------------------
|
|  Entry point for the script
|
]]
function main(script_path)

    -- Check we have a job loaded
    local job = VectricJob()

    if not job.Exists then
       DisplayMessageBox("No job loaded.")
       return false
    end
	
  -- Check the selection isn't empty
	local selection = job.Selection
	if selection.IsEmpty then
		DisplayMessageBox("Please select the vectors to be resized before running this gadget.\n\nVectors which don't match the resizing criteria can be selected and will be ignored")
		return false
	end

   -- Declare options.
   local options = 
     {
     tolerance  = 0.01,
     old_diameter = 0.5,
     new_diameter = 0.6,
     units_string = "inches",
     -- Window dimensions
     window_width  = g_default_window_width,
     window_height = g_default_window_height
     
     
     }
     
   -- use different default values for MM  
   if job.InMM then
      options.tolerance = 0.1
      options.old_diameter = 10
      options.new_diameter = 12
      options.units_string = "mm"
   end
  
  if job.InMM then
    
  else
    options.units_string = "inches"
  end
	
 
  -- load defaults we used last time gadget was run
  LoadDefaults(options)
  
  if not DisplayDialog(script_path, options) then
     return false
  end
  
  -- save current values as default for next time gadget is run
  SaveDefaults(options)
  
  -- Collect circles
  local circles = {}
  local circle_count = CollectSelectedCircles(options.old_diameter, options.tolerance, circles, job)
     
  if circle_count == 0 then
    MessageBox("Failed to find any circles with a diameter of " .. options.old_diameter  .. " using a tolerance of " .. options.tolerance)
    return false
  end

  -- For each circle transform
  TransformCirclesToDiameter(circles, options.new_diameter)

  MessageBox("Transformed ".. circle_count .. " circles\nwith a diameter of " .. options.old_diameter  .. " " .. options.units_string ..
             "\nusing a tolerance of " .. options.tolerance .. " " .. options.units_string ..
             "\nto " .. options.new_diameter .. " " .. options.units_string)
  
  -- update the 2d view

  job:Refresh2DView()

  return true
end 

--[[  -------------- LoadDefaults --------------------------------------------------
|
|  Load the values previously used (if any) as defaults
|  Parameters:
|	  options           -- The set of options for the gadget
|
]]
function LoadDefaults(options)
	
	local registry = Registry(g_title)

   options.tolerance     = registry:GetDouble("Tolerance",  options.tolerance)
   options.old_diameter    = registry:GetDouble("OldDiameter",  options.old_diameter)
   options.new_diameter    = registry:GetDouble("NewDiameter",  options.new_diameter)
  	options.window_width  = registry:GetInt("WindowWidth",   options.window_width)
   options.window_height = registry:GetInt("WindowHeight",  options.window_height)
	
end

--[[  -------------- SaveDefaults --------------------------------------------------
|
|  Save the values used as defaults
|  Parameters:
|	  options           -- The set of options for the gadget
|
]]
function SaveDefaults(options)
	
	local registry = Registry(g_title)

   registry:SetDouble("Tolerance",  options.tolerance)
   registry:SetDouble("OldDiameter",  options.old_diameter)
   registry:SetDouble("NewDiameter",  options.new_diameter)
  	registry:SetInt("WindowWidth",   options.window_width)
   registry:SetInt("WindowHeight",  options.window_height)
   
end


--[[  -------------- GetDiameterAndCentre --------------------------------------------------
|
|  Get the diameter of a circle. Assuming we know it is contour made of
|  4 arc spans and that is is definitely a circle.
]]
function GetDiameterAndCentre(cadcontour, point2d)
  local contour = cadcontour:GetContour()
  local arc = contour:GetFirstSpan()
  local point3d = Point3D();
  arc = CastSpanToArcSpan(arc)
  local diameter = arc:RadiusAndCentre(point3d) * 2.0
  point2d = Point2D(point3d.x, point3d.y)
  
  -- MessageBox("Diameter = " .. diameter)
  return diameter, point2d
end


--[[  -------------- CollectSelectedCircles --------------------------------------------------
|
| Get all circles with given diameter and tolerance and with the given selection mode. Returns count
|
]]
function CollectSelectedCircles(diameter, tolerance, circles, job)
  
  local selection = job.Selection
  
  if selection.IsEmpty then
    DisplayMessageBox("No objects found.")
    return 0
  end
 
  local circle_count = 0

  local pos = selection:GetHeadPosition()

  local i = 1
  local obj = nil
  while pos ~= nil do
    obj, pos = selection:GetNext(pos)
    if obj.ClassName == "vcCadContour" then
      local ctr = obj:GetContour()
      if IsCircle(obj) then
        local point2d = Point2D()
        local dia = GetDiameterAndCentre(obj, point2d)
        if math.abs(dia-diameter) < tolerance then
          circles[i] = obj
          i = i + 1;
          circle_count = circle_count + 1
          -- MessageBox("Circle Dia" .. dia .. " matches " .. diameter .. " Circle Count = " .. circle_count)
        else
          -- MessageBox("Circle Dia" .. dia .. " DOES NOT match " .. diameter)
        end
      end
    end
  end
  
  return circle_count
end


--[[  -------------- TransformCirclesToDiameter --------------------------------------------------
|
| Transform the diameter of the passed circles to the new diameter
|
]]

function TransformCirclesToDiameter(circles, new_diameter)
  -- iterate over the circles creating the appropriate scaling matrix and transforming
  local centre_point = Point2D()
  local diameter = 0

  
  for i, circle in ipairs(circles) do
    diameter, centre_point = GetDiameterAndCentre(circle, centre_point)
    local scale_factor = 0
    if diameter ~= 0 then
      scale_factor = new_diameter/diameter
    end
    -- MessageBox("Scale Factor = " .. scale_factor)
    local scaling_vector = Vector2D(scale_factor, scale_factor)
    
    local trans_mat = ScalingMatrix2D(centre_point, scaling_vector)
    circle:Transform(trans_mat)

  end


end
  
--[[  -------------- DisplayDialog --------------------------------------------------
|
| Display the dialog
|
]]

function DisplayDialog(script_path, options)
  
  local html_path = "file:" .. script_path .. "\\" .. g_html_file
  local dialog = HTML_Dialog(false, html_path, options.window_width, options.window_height, "Circle Resize")
  
  -- Add the title
  dialog:AddLabelField("GadgetTitle", g_title)
  dialog:AddLabelField("GadgetVersion", g_version)
  
  -- Add units label
  dialog:AddLabelField("UnitsLabel1", options.units_string)
  dialog:AddLabelField("UnitsLabel2", options.units_string)
  dialog:AddLabelField("UnitsLabel3", options.units_string)
  
  -- Add diameter/tolerance selection
  dialog:AddDoubleField("Tolerance", options.tolerance)
  dialog:AddDoubleField("Diameter", options.old_diameter)
  dialog:AddDoubleField("NewDiameter", options.new_diameter)
  
  -- Add selection mode.
  -- dialog:AddRadioGroup("SelectionMode", options.selection_mode)
  
  -- Display the dialog  
  local success = dialog:ShowDialog()
  
  if not success then
    return false
  end
  
  options.old_diameter = dialog:GetDoubleField("Diameter") 
  options.tolerance = dialog:GetDoubleField("Tolerance")
  options.new_diameter = dialog:GetDoubleField("NewDiameter") 
  -- options.selection_mode = dialog:GetRadioIndex("SelectionMode")
  
   -- we keep the size the user has used for the dialog widnow
   options.window_width  = dialog.WindowWidth
   options.window_height = dialog.WindowHeight
   
  return true
end


--[[  -------------- IsCircle --------------------------------------------------
|
| Check whether a contour is a circle.
|
]]

function IsCircle(cadcontour)
  
  local contour = cadcontour:GetContour()
  -- Does it consist only of arcs?
  if contour.ContainsBeziers then
    return false
  end

  if not contour.ContainsArcs then
    return false
  end

  -- Does is contain 4 contours?
  if contour.Count ~= 4 then
    return false;
  end

  -- Check the arcs end and initial points make a square.
  local arcs = {}
  local count = 1;
  local pos = contour:GetHeadPosition()
  local object
  while pos ~= nil do
    object, pos = contour:GetNext(pos)
    arcs[count] = object
    count = count + 1
  end
  local x_1 =(arcs[1]).StartPoint2D.x 
  local y_1 =(arcs[1]).StartPoint2D.y 
  local x_3 =(arcs[3]).StartPoint2D.x
  local y_3 =(arcs[3]).StartPoint2D.y
  local x_2 =(arcs[2]).StartPoint2D.x 
  local y_2 =(arcs[2]).StartPoint2D.y 
  local x_4 =(arcs[4]).StartPoint2D.x
  local y_4 =(arcs[4]).StartPoint2D.y
  
  local horizontal_distance = (x_1 - x_3)*(x_1 - x_3) + (y_1 - y_3)*(y_1 - y_3)
  local vertical_distance = (x_4 - x_2)*(x_4 - x_2) + (y_2 - y_4)*(y_2 - y_4)


  if math.abs(horizontal_distance - vertical_distance) > 0.04 then
    return false
  end

  -- Check the bulge factor is 90
  local bulge = 0;
  for _, arc_span in ipairs(arcs) do
    bulge = CastSpanToArcSpan(arc_span).Bulge;
    if math.abs(bulge  - g_bulge90) > 0.04 then
      return false
    end
  end

  return true
end
  
