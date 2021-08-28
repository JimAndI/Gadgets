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

require "strict"
--require("mobdebug").start()

--[[  ------------------------ main --------------------------------------------------
|
|  Entry point for script
|
]]
function main(script_path)
  
  
  -- Check for the existence of a job
  local job = VectricJob()
  if not job.Exists then
    return false
  end
  
  -- Configuration parameters
  local pixel_size = 500
  local size = 0.5
  
  -- Add the relief to the manager
  local component_manager = job.ComponentManager
  
  -- Create a small blank relief
  local pixel_size = 10
  local size = 0.5
  local blank_relief = Relief(pixel_size, pixel_size, size, size)
  blank_relief:Reset(0.2, false)
  
  -- Insert this relief as a component 
  local blank_id = component_manager:AddRelief(blank_relief, CombineMode.Add, "13 Replace_Component_Relief")
    
  -- Make a list of the components we clone
  local clones = {}
  
  -- Make 12 copies, each smaller than the the last
  local material_block = MaterialBlock()
  for i = 1, 12 do
    -- Compute the scale factor
    local scale_factor = (13.0 - i) / 12.0
    local xform = ScalingMatrix2D(Vector2D(scale_factor, scale_factor))
    -- Move the relief out to 3 pm
    xform = TranslationMatrix2D(Vector2D(2.0, 0)) * xform
    -- Rotate it about the origin
    local origin = Point2D(0, 0)
    xform = RotationMatrix2D(origin, (i - 1) * 360 / 12) * xform
    -- Centre about the job
    local center = material_block.MaterialBox.Center
    local translation_vector = Vector2D(center.x, center.y)
    xform = TranslationMatrix2D(translation_vector) * xform
    -- Clone and transform the object
    local clone = component_manager:CloneObjectWithId(blank_id, false)
    clone:Transform(xform, true)
    -- Make a note of it
    clones[1 + #clones] = clone.Id
  end
  
  -- Delete the original blank relief component
  component_manager:DeleteObjectWithId(blank_id)
  
  -- Create a more interesting relief profile
  pixel_size = 500
  size = 0.5
  local max_z = material_block.Thickness / 5.0

  local relief = Relief(pixel_size, pixel_size, size, size)
  for x = 0, pixel_size - 1 do
    for y = 0, pixel_size - 1 do
      local z = x * y * max_z / ((pixel_size - 1) * (pixel_size - 1))
      relief:Set(x, y, z)
    end
  end
  
  local profile_id = component_manager:AddRelief(relief, CombineMode.Add, "13 Profile")
  
  for _,id in ipairs(clones) do
    component_manager:ReplaceComponentRelief(id, profile_id)
  end
  
  component_manager:DeleteObjectWithId(profile_id)
    
  
   -- Update all the previews now
  component_manager:UpdatePreviews()
  
  -- Update the composite model
  component_manager:UpdateCompositeModel()
  
  
  return true
  
end
