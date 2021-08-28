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
  
  -- Try and create a relief
  local pixel_width = 1000
  local pixel_height = 1000
  local width = 5.0
  local height = 5.0
  local relief = Relief(pixel_width, pixel_height, width, height)
  
  -- Set its data
  local max_r = 0.5 * math.sqrt(pixel_width * pixel_width + pixel_height * pixel_height)
  for y = 0, pixel_height - 1 do
    -- We want our waves to eminate from the centre
    local y_r = (2 * y - pixel_height) / 2
    for x = 0, pixel_width - 1 do
      -- We want our waves to eminate from the centre
      local x_r = (2 * x - pixel_width) / 2
      -- Compute our normalized radial position from the model centre
      local r = math.sqrt(x_r * x_r + y_r * y_r) / max_r
      -- Our amplitude is a gaussian function of our radial position
      local amp = math.exp(-10.0 * (r - 0.3) * (r - 0.3))
      --Set the height from a cos function
      local z = 0.5 + 0.2 * amp * math.cos(2 * math.pi * 5 * r) 
      relief:Set(x, y, z)
    end
  end
  
  -- Add the relief to the manager
  local component_manager = job.ComponentManager
  component_manager:AddRelief(relief, CombineMode.Add, "01 Creation")
  
  return true
  
end
