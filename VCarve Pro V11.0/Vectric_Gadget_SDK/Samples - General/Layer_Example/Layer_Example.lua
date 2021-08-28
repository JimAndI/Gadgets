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

--[[  -------------------------------------------------- CountObjectsOnLayer --------------------------------------------------  
|
|   Display information about all the layers in the current job
|
|  Parameters:
|     layer              - layer to count objects on
|     count_table        - info on layers in doc - updated by this method for current layer
|     active_sheet_index - index of currently active sheet
|    None
]]

function CountObjectsOnLayer(layer, count_table, active_sheet_index)

   if layer.IsEmpty then
     return 0
   end  

   local pos = layer:GetHeadPosition()
   while pos ~= nil do
      local object
      object, pos = layer:GetNext(pos)
	  if object.SheetIndex == active_sheet_index then
		  if count_table[object.ClassName] == nil then
			 count_table[object.ClassName] = 1
		  else
			 count_table[object.ClassName] =  count_table[object.ClassName] + 1
		  end
       end 
    end  
  
end


--[[  -------------------------------------------------- SetBitmapBrightness --------------------------------------------------  
|
|   Find all bitmaps and set their brightness
|
|  Parameters:
|    job          - job we are working with
|    brightness   - brightness value in range 0 -255
|
|  Return Values:
|    None
]]

function SetBitmapBrightness(job, brightness)

    if not job.Exists then
          DisplayMessageBox("No job loaded")
          return false 
     end

    local layer_manager = job.LayerManager
  

    local pos = layer_manager:GetHeadPosition()
    while pos ~= nil do
       local layer	
       layer, pos = layer_manager:GetNext(pos)
       if not layer.IsSystemLayer then
       local layer_pos = layer:GetHeadPosition()
       while layer_pos ~= nil do
	      local object
          object, layer_pos = layer:GetNext(layer_pos)
          if object.ClassName == "vcCadBitmap" then
             local cad_bitmap = CastCadObjectToCadBitmap(object)
             MessageBox("Found bitmap - brightess = " .. cad_bitmap.Brightness)
             cad_bitmap.Brightness = brightness
             end
          end
       end  -- end of for each object on layer
    end  -- end of for each layer 
    
    job:Refresh2DView()
end




--[[  ----------------------- main -----------------------------
|
|  Entry point for script
|
]]

function main()

    -- Check we have a document loaded
    local job = VectricJob()
    if not job.Exists then
          DisplayMessageBox("No job loaded")
          return false 
     end
  
    local layer_manager = job.LayerManager
  
    -- SetBitmapBrightness(job, 20)
  
    -- count all objects on layers
    local object_counts = {}
	object_counts["Num Layers"] = 0
    local active_sheet_index = layer_manager.ActiveSheetIndex
	
    local pos = layer_manager:GetHeadPosition()
    while pos ~= nil do
	   local layer
       layer, pos = layer_manager:GetNext(pos)
       if not layer.IsSystemLayer then
          CountObjectsOnLayer(layer, object_counts, active_sheet_index)
		  object_counts["Num Layers"] = object_counts["Num Layers"] + 1;
       end   
    end
  
    -- display results  
    
    local msg = "Type of objects and number on sheet " .. active_sheet_index .. "\n\n"
    local obj_type
	local obj_count
    for obj_type, obj_count in pairs(object_counts) do
        msg = msg .. obj_type .. " = " .. obj_count .."\n"
    end
    MessageBox(msg)

    return true
end    