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

--[[  ------------------- CreatePrismToolpath -------------------  
|
|   Create a prism toolpath within the program for the currently selected vectors
|  Parameters:
|    name,                 -- Name for toolpath
|    start_depth           -- start depth for toolpath below surface of material
|    cut_depth             -- cut depth for drilling toolpath
     vbit_angle            -- angle of vbit to use
|    vbit_dia              -- diameter of VBit  to use
|    vbit_stepdown         -- stepdown for tool
|    tool_stepover_percent -- percentage stepover for tool
|    tool_in_mm            -- true if tool size and stepdown are in mm
|
|  Return Values:
|     true if toolpath created OK else false
|
]]

function CreatePrismToolpath( name , start_depth, cut_depth, vbit_angle, vbit_dia, vbit_stepdown, tool_stepover_percent, tool_in_mm)

   -- Create tool we will use to machine vectors
   local tool = Tool(
                    "Lua VBit", 
                    Tool.VBIT       -- BALL_NOSE, END_MILL, VBIT
                    )
                     
   tool.InMM = tool_in_mm
   tool.ToolDia = vbit_dia
   tool.Stepdown = vbit_stepdown
   tool.Stepover = vbit_dia * (tool_stepover_percent / 100)
   tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
   tool.FeedRate = 30
   tool.PlungeRate = 10
   tool.SpindleSpeed = 20000
   tool.ToolNumber = 1
   tool.VBitAngle = 90.0                -- used for vbit only
   tool.ClearStepover = vbit_dia * (tool_stepover_percent / 100) * 2  -- used for vbit only
  

   -- we will set home position and safe z relative to material block size  
   local mtl_block = MaterialBlock()  
   local mtl_box = mtl_block.MaterialBox
   local mtl_box_blc = mtl_box.BLC
  
   -- Create object used to set home position and safez gap above material surface
   local pos_data = ToolpathPosData()
   pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
   pos_data.SafeZGap = mtl_block.Thickness * 0.1
  
   -- Create  object used to pass toolpath options
   local prism_data = PrismCarveParameterData()
      -- start depth for toolpath
      prism_data.StartDepth = start_depth
      
      -- cut depth for toolpath this is depth below start depth
      prism_data.CutDepth = cut_depth
      
      -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
      prism_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
      
   -- calculate the minimum cut depth to fully form the bevel on the current selection with the current tool
   local min_bevel_depth = prism_data:CalculateMinimumBevelDepth(tool, true)
   if min_bevel_depth > cut_depth then
      DisplayMessageBox("A prism will not be fully formed with a depth of " .. cut_depth .. "\r\n" ..
                       "A depth of " .. min_bevel_depth .. " is required to fully form the prism"
                       )
   end

   -- Create object which can used to automatically select geometry on layers etc
   local geometry_selector = GeometrySelector() 
 
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
   local create_2d_previews = true
   
   -- if this is true we will display errors and warning to the user
   local display_warnings = true
   
   -- Create our toolpath

   local toolpath_manager = ToolpathManager()
 
   local toolpath_id = toolpath_manager:CreatePrismCarvingToolpath(
                                              name,
                                              tool,
                                              prism_data,
                                              pos_data,
											  geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
   
   if toolpath_id  == nil  then
      DisplayMessageBox("Error creating toolpath")
      return false
   end                                                    

   return true  

end


--[[  ------------------- main -------------------  
|
|  Entry point for script
|
]]

function main()

    -- Check we have a document loaded
    local job = VectricJob()
 
    if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;  
    end
 
   local selection = job.Selection
   if selection.IsEmpty  then
       MessageBox("Please select one or more vectors to bevel carve")
       return false  
    end
    
	local mtl_block = MaterialBlock()
	
    local start_depth = 0.0
    local cut_depth = mtl_block.Thickness * 0.9
    local vbit_angle = 90.0
    local tool_dia = 1.0
    local tool_stepdown = 0.1
    local tool_stepover_percent = 2.0
    local tool_in_mm = false
    
    local success = CreatePrismToolpath( 
                                           "Lua Prism Toolpath", 
                                           start_depth, 
                                           cut_depth, 
                                           vbit_angle,
                                           tool_dia, 
                                           tool_stepdown, 
                                           tool_stepover_percent,
                                           tool_in_mm 
                                           )    
    
    
    return success;
end    