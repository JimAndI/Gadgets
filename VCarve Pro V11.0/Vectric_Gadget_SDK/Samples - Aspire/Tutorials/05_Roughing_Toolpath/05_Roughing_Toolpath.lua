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
  
  -- Get the material block
  local material_block = MaterialBlock()
  local bounding_box = material_block.MaterialBox
  
  -- Extract some relevant dimensions
  local x_length = bounding_box.XLength
  local y_length = bounding_box.YLength
  local z_length = bounding_box.ZLength
  
  -- Try and create a relief
  local pixel_width = 1000
  local pixel_height = 1000
  local relief = Relief(pixel_width, pixel_height, x_length, y_length)
  
  -- Set its data - max(0, sin(x)sin(y))
  for y = 0, pixel_height - 1 do
    -- Compute and cache the y sine term
    local sin_y = math.sin(5 * 2 * math.pi * y / (pixel_height - 1)) 
    for x = 0, pixel_width - 1 do
      -- Compute the x sine term
      local sin_x = math.sin(5 * 2 * math.pi * x / (pixel_width - 1))
      local z = 0.2 * z_length * math.max(0, sin_x * sin_y)
      relief:Set(x, y, z)
    end
  end
  
  -- Add the relief to the manager
  local component_manager = job.ComponentManager
  component_manager:AddRelief(relief, CombineMode.Add, "05 Roughing Toolpath")
    
  -- Create the roughing toolpath
  CreateRoughingToolpath()
  
  return true
  
end

function CreateRoughingToolpath()
  
  -- Toolpath name
  local name = "Lua Roughing Toolpath"
  
  -- Metric unit parameters
  local tool_dia = 6.35 -- Quarter of an inch
  local tool_stepdown = 5
  local tool_stepover_percent = 40
  
  -- Create tool we will use to machine vectors
  local tool = Tool("Lua End Mill", Tool.END_MILL)
   
  tool.InMM = true
  tool.ToolDia = tool_dia
  tool.Stepdown = tool_stepdown
  tool.Stepover = tool_dia * (tool_stepover_percent / 100)
  tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
  tool.FeedRate = 30
  tool.PlungeRate = 10
  tool.SpindleSpeed = 20000
  tool.ToolNumber = 1
  tool.VBitAngle = 90.0                -- used for vbit only
  tool.ClearStepover = tool_dia * (tool_stepover_percent / 100)  -- used for vbit only
  
  -- we will set home position and safe z relative to material block size  
  local mtl_block = MaterialBlock()  
  local mtl_box = mtl_block.MaterialBox
  local mtl_box_blc = mtl_box.BLC
  
   -- Create object used to set home position and safez gap above material surface
  local pos_data = ToolpathPosData()
  pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2))
  pos_data.SafeZGap = mtl_block.Thickness * 0.1
  
  -- Pocketing parameters
  local start_depth = 0
  local cut_depth = mtl_box.ZLength
  
  -- Create object used to pass roughing options
  local roughing_data = RoughingParameterData()
  -- start depth for toolpath
  roughing_data.StartDepth = start_depth
  
  -- cut depth for toolpath this is depth below start depth
  roughing_data.CutDepth = cut_depth
   
  -- Machining allowance
  roughing_data.MachiningAllowance = 0.0
   
  -- Allowance to leave on when machining - (this is different from machining allowance)
  roughing_data.Allowance = 0.0
  
  -- if true use z level roughing
  roughing_data.DoZLevelRoughing = true
  -- z level clearance strategy
  roughing_data.ZLevelStrategy = RoughingParameterData.RASTER_X
  roughing_data.ZLevelProfile = RoughingParameterData.LAST
  -- angle for raster if using raster clearance
  roughing_data.RasterAngle = 0
  
  -- if true we ramp into pockets (always zig-zag)
  roughing_data.DoRamping = false
  --  if ramping, distance to ramp over
  roughing_data.RampDistance = 10.0
  
  -- Create object which can used to automatically select geometry on layers etc
  local geometry_selector = GeometrySelector() 
     
  -- if this is true we will display errors and warning to the user
  local display_warnings = true
  
  -- Create our toolpath
  local toolpath_manager = ToolpathManager()
  local toolpath_id = toolpath_manager:CreateRoughingToolpath(
                                              name,
                                              tool,
                                              roughing_data,
                                              pos_data,
                                              geometry_selector,
                                              display_warnings
                                              )
   
  if not toolpath_id then
    DisplayMessageBox("Error creating toolpath")
  end

end

