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

--[[  ------------- CreateVCarvingToolpath --------------------------------------------------
|
|   Create a VCarving toolpath within the program for the currently selected vectors
|  Parameters:
|    name,                 -- name for toolpath
|    start_depth           -- start depth for toolpath below surface of material
|    flat_depth            -- flat depth - if 0.0 assume not doing flat bottom
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

function CreateVCarvingToolpath( name , start_depth, flat_depth, vbit_angle, vbit_dia, vbit_stepdown, tool_stepover_percent, tool_in_mm)

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

   -- Create  object used to pass vcarving options
   local vcarve_data = VCarveParameterData()
      -- start depth for toolpath
      vcarve_data.StartDepth = start_depth

      -- flag indicating if we are creating a flat bottomed toolpath
      vcarve_data.DoFlatBottom = flat_depth > 0.0

      -- cut depth for toolpath this is depth below start depth
      vcarve_data.FlatDepth = flat_depth

      -- if true in Aspire, project toolpath onto composite model
      vcarve_data.ProjectToolpath = false

      -- set flag indicating we are using flat tool
	  vcarve_data.UseAreaClearTool = true

   -- Create  object used to pass pocketing options - used for area clearance only
   local pocket_data = PocketParameterData()
      -- start depth for toolpath
      pocket_data.StartDepth = start_depth

      -- cut depth for toolpath this is depth below start depth
      pocket_data.CutDepth = flat_depth

      -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
      pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION

      -- if true use raster clearance strategy , else use offset area clearance
      pocket_data.DoRasterClearance = false

      -- set flag indicating we are using flat tool
      pocket_data.UseAreaClearTool = true

      -- angle for raster if using raster clearance
      pocket_data.RasterAngle = 0
      -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
      pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST

   -- Create object which can used to automatically select geometry on layers etc
   local geometry_selector = GeometrySelector()

   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
   local create_2d_previews = true

   -- if this is true we will display errors and warning to the user
   local display_warnings = true

   -- if we are doing two tool pocketing define tool to use for area clearance
   local area_clear_tool = nil

   -- we just create a 10mm end mill

   area_clear_tool = Tool(
                          "Lua Clearance End Mill",
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )

   area_clear_tool.InMM = true
   area_clear_tool.ToolDia = 10
   area_clear_tool.Stepdown = 3
   area_clear_tool.Stepover = 3
   area_clear_tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
   area_clear_tool.FeedRate = 30
   area_clear_tool.PlungeRate = 10
   area_clear_tool.SpindleSpeed = 20000
   area_clear_tool.ToolNumber = 2

   -- Create our toolpath

   local toolpath_manager = ToolpathManager()

   local toolpath_id = toolpath_manager:CreateVCarvingToolpath(
                                              name,
                                              tool,
                                              area_clear_tool,
                                              vcarve_data,
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


--[[  ------------- main --------------------------------------------------
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
       MessageBox("Please select one or more vectors to VCarve")
       return false
    end

	local mtl_block = MaterialBlock()

    local start_depth = 0.0
    local flat_depth = mtl_block.Thickness * 0.5
    local vbit_angle = 90.0
    local tool_dia = 32.0
    local tool_stepdown = 2.5
    local tool_stepover_percent = 2.0
    local tool_in_mm = true

    local success = CreateVCarvingToolpath(
                                           "Lua VCarving Toolpath",
                                           start_depth,
                                           flat_depth,
                                           vbit_angle,
                                           tool_dia,
                                           tool_stepdown,
                                           tool_stepover_percent,
                                           tool_in_mm
                                           )


    return success;
end