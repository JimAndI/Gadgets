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

--[[  ------------------------ DisplayFadeData --------------------------------------------------
|
|  Displays the fade data for an object
|
]]
function DisplayFadeData(object)
  if object and object.IsFaded then
    local anchor_pt = Point2D()
    local direction_pt = Point2D()
    local end_val = object:GetFadeData(anchor_pt, direction_pt)
    local message = string.format("Fade Anchor: (%f, %f), Fade Direction: (%f, %f), Fade End: %f",
      anchor_pt.X, anchor_pt.Y, direction_pt.X, direction_pt.Y, end_val)
    DisplayMessageBox(message)
  end
end

--[[  ------------------------ DisplayTiltData --------------------------------------------------
|
|  Displays the fade data for an object
|
]]
function DisplayTiltData(object)
   if object and object.IsTilted then
	local anchor_pt = Point2D()
    local direction_pt = Point2D()
    local tilt_angle = object:GetTiltData(anchor_pt, direction_pt)
    local message = string.format("Tilt Anchor: (%f, %f), Tilt Direction: (%f, %f), Tilt Angle: %f",
      anchor_pt.X, anchor_pt.Y, direction_pt.X, direction_pt.Y, tilt_angle)
    DisplayMessageBox(message)
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
  
  -- Get the material block and extract dimensions
  local material_block = MaterialBlock()
  local bounding_box = material_block.MaterialBox
  local z_length = bounding_box.ZLength
  
  -- Try and create a square relief
  local pixel_width = 1000
  local pixel_height = 1000
  local relief = Relief(pixel_width, pixel_height, 5.0, 5.0)
  
  -- Set its data - half the z length of the bounding box for a 'flat topped' model
  for y = 0, pixel_height - 1 do
    for x = 0, pixel_width - 1 do
      relief:Set(x, y, 0.5 * z_length)
    end
  end
  
  -- Add the relief to the manager
  local component_manager = job.ComponentManager
  local component_id = component_manager:AddRelief(relief, CombineMode.Add, "06 Tilt And Fade")
  
  -- Retrieve the component
  local object = component_manager:FindObjectWithId(component_id)
  if not object then
    return false
  end
  
  -- Set up the fade
  local fade_anchor_pt = Point2D(2.5, 0.0)
  local fade_direction_pt = Point2D(2.5, 5.0)
  local fade_end_val = 0.5
  local fade_changes_object = object:FadeWouldChange(fade_anchor_pt, fade_direction_pt, fade_end_val, true)
  if fade_changes_object then
    object:SetFadeData(fade_anchor_pt, fade_direction_pt, fade_end_val)
    object.UseFade = true
  end
  
  -- Set up a tilt at 90 degrees to the fade
  local tilt_anchor_pt = Point2D(0, 2.5)
  local tilt_direction_pt = Point2D(2.5, 2.5)
  local tilt_angle = 15.0 -- degrees
  local tilt_changes_object = object:TiltWouldChange(tilt_anchor_pt, tilt_direction_pt, tilt_angle, true)
  if tilt_changes_object then
    object:SetTiltData(tilt_anchor_pt, tilt_direction_pt, tilt_angle)
    object.UseTilt = true
  end
    
  -- If either of these changes change the object then we have to update the composite model
  if fade_changes_object or tilt_changes_object then
    component_manager:UpdateCompositeModel()
  end
  
  -- Display some information back to the user
  DisplayFadeData(object)
  DisplayTiltData(object)
  
  return true
  
end
