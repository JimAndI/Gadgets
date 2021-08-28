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

--[[-------------------------------------------------------------------------------------------------------
|
|  VCarve Pro / Aspire Lua script to display elevation data for vectors imported from a DXF file
|
| Written By Brian Moran 07/11/2010
|
]]

require "strict"

-- Global default values

g_Version = "Version 1.0"

--[[  ----------- GetDepthsOnLayer --------------------------------------------------  
|
|  Build list of all objects with DXF heights on passed layer
|
|  Parameters:
|     layer         - layer to count objects on
|     layer_data    - returned data on dxf heights found
|
|  Return Values:
|    None
]]

function GetDepthsOnLayer(layer, layer_data)

   if layer.IsEmpty then
     return 0
   end  

   layer_data[layer.Name] = {}
   layer_data[layer.Name]["Count"] = 0;
   layer_data[layer.Name]["Depths"] = {}

   local pos = layer:GetHeadPosition()
   local object
   while pos ~= nil do
      object, pos = layer:GetNext(pos)
      layer_data[layer.Name]["Count"] =  layer_data[layer.Name]["Count"] + 1
      if (object.ClassName == "vcCadContour") then
	    if (object:ParameterExists("DXF_Z", utParameterList.UTP_DOUBLE)) then
		   -- MessageBox("Selected objects elevation set from DXF file is " .. object:GetDouble("DXF_Z", 0.0, false))
		   local z_depth = object:GetDouble("DXF_Z", 0.0, false)
		   if layer_data[layer.Name]["Depths"][z_depth] == nil then
		      layer_data[layer.Name]["Depths"][z_depth] = 1
		   else
		      layer_data[layer.Name]["Depths"][z_depth] = layer_data[layer.Name]["Depths"][z_depth] + 1
		   end
	    end	  
      end
   end  
  
end

--[[  ------------------------------------------ main --------------------------------------------------  
|
|  Entry point for script 
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

    local layer_data = {}
    
    local pos = layer_manager:GetHeadPosition()
	local layer
    while pos ~= nil do
       layer, pos = layer_manager:GetNext(pos)
       if not layer.IsSystemLayer then
          GetDepthsOnLayer(layer, layer_data)
       end   
    end
  
    -- display results  
    
    local msg = "Layer information\n\n"

    for obj_type, obj_data in pairs(layer_data) do
        msg = msg .. "\"" .. obj_type .."\"" ..  " has " .. obj_data["Count"] .." vectors\n"
		local depth_name, depth_data
		for depth_name, depth_data in pairs(obj_data["Depths"]) do
		  msg = msg .. "   " ..  depth_data .." vectors have depth " .. depth_name ..  "\n"
		end
		msg = msg .. "\n"
    end
    MessageBox(msg)

 return true

end