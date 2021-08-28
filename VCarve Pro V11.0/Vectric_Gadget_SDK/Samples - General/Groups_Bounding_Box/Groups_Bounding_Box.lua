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

--[[-------------------------------------------------------------------------------------------------------
|
|  VCarve Pro / Aspire Lua script to display bounding boxes for selected groups
|
|  Written By Brian Moran 22/02/2012
|
]]
-- Global default values

g_Version = "Version 1.0"

--[[  -------------------------------------------------- GetSizeOfGroupsOnLayer --------------------------------------------------
|
|  Build list of all groups on passed layer along with bounds
|
|  Parameters:
|     layer         - layer to size objects on
|
|  Return Values:
|    None
]]
function GetSizeOfGroupsOnLayer(layer, layer_data)

  if layer.IsEmpty then
    return 0
  end

  layer_data[layer.Name] = {}
  layer_data[layer.Name]["Count"] = 0;
  layer_data[layer.Name]["BoundingBox"] = {}

  local pos = layer:GetHeadPosition()
  local object
  local index = 0;
  while pos ~= nil do
    object, pos = layer:GetNext(pos)
    if (object.ClassName == "vcCadObjectGroup") then
      layer_data[layer.Name]["Count"] =  layer_data[layer.Name]["Count"] + 1
	    local bounding_box = object:GetBoundingBox()
	    layer_data[layer.Name]["BoundingBox"][index] = bounding_box
		 -- MessageBox("   Group " .. index ..  " is " .. bounding_box.XLength .. " x " ..  bounding_box.YLength .. " \n")
		  index = index + 1
	  end
	end
end

--[[  ------------------------------------------ main --------------------------------------------------
|
|  Entry point for script - Lua implementation unwrapper
|
]]
function main(script_path)

 -- Check we have a document loaded
  local job = VectricJob()

  if not job.Exists then
     MessageBox("No job loaded")
     return false;
  end
	local layer_manager = job.LayerManager
  -- count all Groups on all layers
  local layer_data = {}
  local pos = layer_manager:GetHeadPosition()
	local layer

  while pos ~= nil do
    layer, pos = layer_manager:GetNext(pos)
    if not layer.IsSystemLayer then
      GetSizeOfGroupsOnLayer(layer, layer_data)
    end
  end
  -- display results
	local job_bounds = Box2D()
	local msg = "Layer information\n\n"

  for obj_type, obj_data in pairs(layer_data) do
        msg = msg .. obj_type ..  " has " .. obj_data["Count"] .." Groups\n"
		local layer_bounds = Box2D()
		local bounds_index, bounds_data
		for bounds_index, bounding_box in pairs(obj_data["BoundingBox"]) do
		  msg = msg .. "   Group " .. bounds_index ..  " is " .. bounding_box.XLength .. " x " ..  bounding_box.YLength .. " \n"
		  layer_bounds:Merge(bounding_box)
		end
		msg = msg .. "Layer Bounds = " .. layer_bounds.XLength .. " x " ..  layer_bounds.YLength .. "\n"
		msg = msg .. "\n"
		job_bounds:Merge(layer_bounds)
  end

  msg = msg .. "\n\nTotal Bounds = " .. job_bounds.XLength .. " x " ..  job_bounds.YLength .. "\n"
  MessageBox(msg)

  return true
end