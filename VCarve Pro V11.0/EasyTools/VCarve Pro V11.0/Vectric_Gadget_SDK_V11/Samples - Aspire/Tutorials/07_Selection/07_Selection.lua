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

--[[  ------------------------ ToggleAddSubtract --------------------------------------------------
|
| Toggle an object's combine mode between add and subtract
|
]]
function ToggleAddSubtract(object)
  if object then
    -- Swap the add and subtract combine modes around
    if object.CombineMode == CombineMode.Add then
      object.CombineMode = CombineMode.Subtract
    elseif object.CombineMode == CombineMode.Subtract then
      object.CombineMode = CombineMode.Add
    end
  end
end

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
  
  -- Get a list of selected components
  local component_manager = job.ComponentManager
  local selected_object_ids = component_manager:GetSelectedObjectIds(true) -- We want a list of all selected nodes, not just the top level ones
  
  if not selected_object_ids or selected_object_ids.IsEmpty then
    DisplayMessageBox("Nothing Selected!")
	return false
  end
  
  -- Loop over the returned list and toggle the combine modes
  local pos = selected_object_ids:GetHeadPosition()
  while pos ~= nil do
    local id = nil
    id, pos = selected_object_ids:GetNext(pos)
    local object = component_manager:FindObjectWithId(id)
    ToggleAddSubtract(object)
  end
  
   -- Update all the previews now
  component_manager:UpdatePreviews()
  
  -- Update the composite model
  component_manager:UpdateCompositeModel()
  
  return true
  
end
