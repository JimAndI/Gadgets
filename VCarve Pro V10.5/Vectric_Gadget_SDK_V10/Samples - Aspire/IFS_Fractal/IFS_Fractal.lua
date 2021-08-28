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

--[[  -------------- LoadTransforms --------------------------------------------------
|
|  Loads a set of transforms from a text file
|  Parameters:
|	  filename           -- The filename of a file containing and IFS definition
|
|  Return Values:
|	 A table of transforms
|
]]
function LoadTransforms(filename)
   -- Helper function to create the transforms
  local function CreateTransform(a, b, c, d, e, f, p)
    local transform = {}
    transform.a = a
    transform.b = b
    transform.c = c
    transform.d = d
    transform.e = e
    transform.f = f
    transform.p = p
    return transform
  end
  -- Helper function to split strings up
  local function Split(line)
    local fields = {}
    line:gsub("([^%s]+)", function(c) fields[#fields+1] = c end)
    for i, value in ipairs(fields) do
      fields[i] = tonumber(fields[i])
    end
    return fields
  end
  -- Set up the resultant IFS system
  local transforms = {}
  -- Open the file and parse it
  local file = io.input(filename)
  if file then
    local line = file:read("*line")
    while line do
      local fields = Split(line)
      transforms[#transforms+1] = CreateTransform(unpack(fields))
      line = file:read("*line")
    end
    file:close()
  end
  -- Return the answer
  return transforms
end


--[[  -------------- IterateFractal --------------------------------------------------
|
|  Iterates a function system and calls a handler for each point
|  Parameters:
|	  transforms        -- The set of transforms
|   seed              -- The seed value for the random number generator
|   iterations        -- The total number of iterations
|   discard           -- The number of iterations to discard at the start
|   handler           -- Function to call for each accepted point
|
]]
function IterateFractal(transforms, seed, iterations, discard, handler)
  -- Set up the random seed
  math.randomseed(seed)
  -- Start this system at the origin
  local x = 0
  local y = 0
  local x0 = 0
  -- Iterate
  for iter = 1, iterations do
    -- Random number
    local r = math.random()
    -- Loop over the transforms and when
    -- r is less than the total probability
    -- apply the transform
    local p_total = 0
    for index = 1, #transforms do
      local transform = transforms[index]
      p_total = p_total + transform.p
      if r < p_total then
        x0 = transform.a * x + transform.b * y + transform.e
        y = transform.c * x + transform.d * y + transform.f
        x = x0
        if iter > discard then
          handler(x, y)
        end
        break
      end
    end
  end
end


--[[  -------------- Main --------------------------------------------------
|
|  Iterates a function system and calls a handler for each point
|  Parameters:
|	  script_path     -- The script path
|
]]
function main(script_path)
  
  -- Check job existence
  local job = VectricJob()
  if not job.Exists then
    return false
  end
  
  -- Display a file dialog
  local file_dialog = FileDialog()
  file_dialog.InitialDirectory = script_path .. "\\Fractals\\"
  if not file_dialog:FileOpen("*.txt", "", "Text Files|*.txt;||") then
    return false
  end
  
  -- Filename
  local filename = file_dialog.FileName
  if not filename then
    return false
  end
  
  -- Load in the transforms
  local transforms = LoadTransforms(filename)
    
  -- Set up the seed
  local seed = os.time()
  
   -- The number of points in the mesh
  local num_points = 1000 * 1000
    
  -- Decide upon the number of iterations/ points we're going to use
  local iterations = 10 * num_points
  
  -- Decide how many iterations we want to ignore at the start
  local discard = 100
  
  -- First compute the bounds of the fractal
  local x_min = 99999999
  local x_max = -99999999
  local y_min = 99999999
  local y_max = -99999999
  local function MergeBounds(x, y)
    x_min = math.min(x_min, x)
    x_max = math.max(x_max, x)
    y_min = math.min(y_min, y)
    y_max = math.max(y_max, y)
  end
  IterateFractal(transforms, seed, iterations, discard, MergeBounds)
  
  -- Given the fractal bounds compute the real and pixel dimensions
  local width = 5.0 -- 5 inches
  if job.InMM then
    width = 25.4 * width
  end
  local height = (y_max - y_min) * width / (x_max - x_min) -- Preserve aspect ratio
  local pixel_width = math.ceil(math.sqrt(width * num_points / height))
  local pixel_height = math.ceil(num_points / pixel_width)
  
  -- Create the relief
  local relief = Relief(pixel_width, pixel_height, width, height)
  if not relief then
	return false
  end
  
  -- Decide on the height to set
  local z_height = 0.125 -- 8th of an inch
  if job.InMM then
    z_height = 25.4 * z_height
  end
  
  -- Given a point on the fractal set it on the model
  local function SetPoint(x, y)
    local pixel_x = (pixel_width - 1) * (x - x_min) / (x_max - x_min)
    local pixel_y = (pixel_height - 1) * (y - y_min) / (y_max - y_min)
    relief:Set(pixel_x, pixel_y, z_height)
  end
  IterateFractal(transforms, seed, iterations, discard, SetPoint)
  
  -- Add the relief to the document
  local component_manager = job.ComponentManager
  component_manager:AddRelief(relief, CombineMode.Add, "Fractal Component")
  
  return true
end
--