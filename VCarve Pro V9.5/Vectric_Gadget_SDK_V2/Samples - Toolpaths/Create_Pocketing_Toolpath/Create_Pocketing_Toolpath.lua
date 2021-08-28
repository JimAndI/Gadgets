-- VECTRIC LUA SCRIPT
-- Copyright 2013 Vectric Ltd.

-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

require "strict"

--[[  -------------- CreatePocketingToolpath --------------------------------------------------
|
|   Create a Pocketing toolpath within the program for the currently selected vectors
|  Parameters:
|     name,                 -- Name for toolpath
|     start_depth           -- Start depth for toolpath below surface of material
|     cut_depth             -- cut depth for pocket toolpath
|     tool_dia              -- diameter of end mill to use
|     tool_stepdown         -- stepdown for tool
|     tool_stepover_percent -- percentage stepover for tool
|     tool_in_mm            -- true if tool size and stepdown are in mm
|
|  Return Values:
|     true if toolpath created OK else false
|
]]

function CreatePocketingToolpath(name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_stepover_percent, tool_in_mm)

   -- Create tool we will use to machine vectors
   local tool = Tool(
                    "Lua End Mill",
                    Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                    )

   tool.InMM = tool_in_mm
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
   pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
   pos_data.SafeZGap = mtl_block.Thickness * 0.1

   -- Create  object used to pass pocketing options
   local pocket_data = PocketParameterData()
      -- start depth for toolpath
      pocket_data.StartDepth = start_depth

      -- cut depth for toolpath this is depth below start depth
      pocket_data.CutDepth = cut_depth

      -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
      pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION

      -- Allowance to leave on when machining
      pocket_data.Allowance = 0.0

      -- if true use raster clearance strategy , else use offset area clearance
      pocket_data.DoRasterClearance = true
      -- angle for raster if using raster clearance
      pocket_data.RasterAngle = 0
      -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
      pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST

      -- if true we ramp into pockets (always zig-zag)
      pocket_data.DoRamping = false
      --  if ramping, distance to ramp over
      pocket_data.RampDistance = 10.0

      -- if true in Aspire, project toolpath onto composite model
      pocket_data.ProjectToolpath = false

   -- Create object which can used to automatically select geometry on layers etc
  local geometry_selector = GeometrySelector()

   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
   local create_2d_previews = true

   -- if this is true we will display errors and warning to the user
   local display_warnings = true

   -- if we are doing two tool pocketing define tool to use for area clearance
   local area_clear_tool = nil

   -- we just create a tool twice as large for testing here
   area_clear_tool = Tool(
                          "Lua Clearance End Mill",
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )

   area_clear_tool.InMM = tool_in_mm
   area_clear_tool.ToolDia = tool_dia * 2
   area_clear_tool.Stepdown = tool_stepdown * 2
   area_clear_tool.Stepover = tool_dia * 2 *(tool_stepover_percent / 100)
   area_clear_tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
   area_clear_tool.FeedRate = 30
   area_clear_tool.PlungeRate = 10
   area_clear_tool.SpindleSpeed = 20000
   area_clear_tool.ToolNumber = 1
   area_clear_tool.VBitAngle = 90.0                -- used for vbit only
   area_clear_tool.ClearStepover = tool_dia * 2 * (tool_stepover_percent / 100)  -- used for vbit only

   -- Create our toolpath

   local toolpath_manager = ToolpathManager()

   local toolpath_id = toolpath_manager:CreatePocketingToolpath(
                                              name,
                                              tool,
                                              area_clear_tool,
                                              pocket_data,
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


--[[  ----------- main --------------------------------------------------
|
|  Entry point for script
|
]]

function main()

    -- Check we have a job loaded
    local job = VectricJob()

    if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;
    end

   local selection = job.Selection
   if selection.IsEmpty  then
       MessageBox("Please select one or more closed vectors to pocket")
       return false
    end

	local mtl_block = MaterialBlock()

    local start_depth = 0.0
    local cut_depth = mtl_block.Thickness * 0.25
    local tool_dia = 12.0
    local tool_stepdown = 2.5
    local tool_stepover_percent = 50.0
    local tool_in_mm = true

    local success = CreatePocketingToolpath(
                                           "Lua Pocketing Toolpath",
                                           start_depth,
                                           cut_depth,
                                           tool_dia,
                                           tool_stepdown,
                                           tool_stepover_percent,
                                           tool_in_mm
                                           )


    return success;
end