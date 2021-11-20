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

--[[
A script demonstrating the capabilities of making unique clones of components 
and then modifying their reliefs via GetRelief.

The script creates a pyramidal shaped component and then creates twelve clones
in a circle around the job centre.

Every other clone is created uniquely and has its profile rounded the strength of
the rounding increasing as you go round counterclockwise.

Finally the original relief is obtained and inverted before the original pyramidal
component is deleted.
]]

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
  local material_block = MaterialBlock()
  local max_z = material_block.Thickness / 5.0
  
  -- Add the relief to the manager
  local component_manager = job.ComponentManager
  local id = AddPyramidShapedRelief(component_manager, pixel_size, size, max_z, "12 Get Relief")
  
  for i = 1, 12 do
    -- Move the relief out to 3 pm
    local xform = TranslationMatrix2D(Vector2D(2.0, 0))
    -- Rotate it about the origin
    local origin = Point2D(0, 0)
    xform = RotationMatrix2D(origin, (i - 1) * 360 / 12) * xform
    -- Centre about the job
    local translation = material_block.MaterialBox.Center
    local translation_vector = Vector2D(translation.x, translation.y)
    xform = TranslationMatrix2D(translation_vector) * xform
    -- Clone and transform the object
    -- We make each odd one unique
    local make_unique = (i % 2) == 1
    local clone = component_manager:CloneObjectWithId(id, make_unique)
    clone:Transform(xform, true)
    -- We bend each unique relief
    if make_unique then
      local relief = clone:GetRelief()
      BendRelief(relief, max_z, (i - 1) / 11.0)
    end
  end

  -- Recover the original component, get its relief and invert it
  local component = component_manager:FindObjectWithId(id)
  local relief = component:GetRelief()
  InvertRelief(relief, max_z)
  
  -- Delete the original
  component_manager:DeleteObjectWithId(id)
  
  
  -- Update all the previews now
  component_manager:UpdatePreviews()
  
  -- Update the composite model
  component_manager:UpdateCompositeModel()
  
  return true
  
end

--[[  ------------------------ AddPyramidShapedRelief --------------------------------------------------
|
|  Adds a pyramid shaped component to the component manager
|  and for demonstration purposes returns its id
|
|  Parameters
|  component_manager   -- the component manager to add the computed relief to
|  pixel_size          -- the width and height in pixels of the relief
|  real_size           -- the width and height in mm/inches of the relief
|  max_z               -- the height of the pyramid
|  name                -- the name to give to the component
|
|  Returns
|  The id of the created component
]]
function AddPyramidShapedRelief(component_manager, pixel_size, real_size, max_z, name)
  
  -- Set up the relief
  local relief = Relief(pixel_size, pixel_size, real_size, real_size)
  
  -- Fill the relief with a pyramid shape
  -- This works by filling in ever smaller squares starting
  -- inwards from the relief boundary with a constant z value
  for t = 0, (pixel_size + 1) / 2 do
    -- Compute the z value for this square
    local z = 2 * max_z * t / (pixel_size + 1)
    -- Set the top and bottom edges
    for x = t, pixel_size - 1 - t do
      relief:Set(x, t, z)
      relief:Set(x, pixel_size - 1 - t, z)
    end
    -- Set the left and right edges
    for y = t, pixel_size - 1 - t do
      relief:Set(t, y, z)
      relief:Set(pixel_size - 1 - t, y, z) 
    end
  end
  
  -- Add it to the component manager
  return component_manager:AddRelief(relief, CombineMode.Add, name)
end

--[[  ------------------------ InvertRelief --------------------------------------------------
|
|  Inverts the passed relief
|  Loops over each pixel in the relief and subtracts its z value from the passed max_z
|
|  Parameters
|  relief              -- the relief to modify
|  max_z               -- the maximum z value of the relief
|
]]
function InvertRelief(relief, max_z)
  
  -- Get the dimensions of the relief
  local pixel_width = relief.PixelWidth
  local pixel_height = relief.PixelHeight
  
  -- For each non transparent pixel in the relief subract the z value from max_z
  -- inverting the relief's appearance
  for x = 0, pixel_width - 1 do
    for y = 0, pixel_height - 1 do
      local z = relief:Get(x, y)
      if not IsTransparent(z) then
        relief:Set(x, y, max_z - z)
      end
    end
  end
  
end

--[[  ------------------------ BendRelief --------------------------------------------------
|
|  Bends the passed relief
|  Loops over each pixel in the relief and distorts the z value
|
|  Parameters
|  relief              -- the relief to modify
|  max_z               -- the maximum z value of the relief
|  bend_factor         -- How much to bend the z values by
]]
function BendRelief(relief, max_z, bend_factor)
  
  -- Get the dimensions of the relief
  local pixel_width = relief.PixelWidth
  local pixel_height = relief.PixelHeight
  
  -- For each non transparent pixel the result is
  -- z = (1 - bend_factor) * z + bend_factor * f(z)
  -- where f(z) = sqrt(2*z - z*z) has the property that on the 
  -- range z=0..1 f(z) > z
  for x = 0, pixel_width - 1 do
    for y = 0, pixel_height - 1 do
      local z = relief:Get(x, y)
      if not IsTransparent(z) then
        z = z / max_z -- Rescale z into the range 0..1
        z = (1.0 - bend_factor) * z + bend_factor * math.sqrt(z * (2 - z))
        z = z * max_z -- Rescale back to the original range
        relief:Set(x, y, z)
      end
    end
  end
  
end

