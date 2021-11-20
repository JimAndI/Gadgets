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


--[[  ------------------------ TreeWalk--------------------------------------------------
|
|  General purpose function to walk a component manager tree
|
]]
function TreeWalk(component_manager, object_ids, visit)
  
  if not object_ids or object_ids.IsEmpty then
    DisplayMessageBox("Empty id list!")
  end
  
  -- Walk the tree 
  while not object_ids.IsEmpty do
    local object_id = object_ids:RemoveHead()
    local object = component_manager:FindObjectWithId(object_id)
    if object then
      -- Attempt to cast this to a group object
      local group = CastComponentToComponentGroup(object)
      -- If the object is a group then add its children to the visit list
      if group then
        local group_pos = group:GetHeadPosition()
        while group_pos do
          local grouped_object = nil
          grouped_object, group_pos = group:GetNext(group_pos)
          object_ids:AddTail(grouped_object.Id)
        end
      else
        -- Otherwise visit the object
        visit(object)
      end
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
  local selected_object_ids = component_manager:GetSelectedObjectIds(false) -- We just want the top level nodes
  
  if not selected_object_ids or selected_object_ids.IsEmpty then
    DisplayMessageBox("Nothing Selected!")
    return false
  end
  
  -- Walk the tree
  TreeWalk(component_manager, selected_object_ids, ToggleAddSubtract)
  
   -- Update all the previews now
  component_manager:UpdatePreviews()
  
  -- Update the composite model
  component_manager:UpdateCompositeModel()
  
  return true
  
end
