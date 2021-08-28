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

--[[  -------------- AddBorder --------------------------------------------------  
|
|  Add a border passed distance in from edges of job to passed group
|
|  Parameters:
|    job                  -- job we are working with, we get size info from this
|    border_offset        -- offset from job edges for border
|    border_group         -- group we add border contour to
|
|  Return Values:
|    None
]]

function AddBorder(job, border_offset, border_group)

   -- get limits for document
   local blc_x = job.MinX
   local blc_y = job.MinY
   local trc_x = blc_x + job.Width
   local trc_y = blc_y + job.Height
   
   -- create 'Point2D' objects for corners of our border
   local blc = Point2D(blc_x + border_offset, blc_y + border_offset)
   local brc = Point2D(trc_x - border_offset, blc_y + border_offset)
   local trc = Point2D(trc_x - border_offset, trc_y - border_offset)
   local tlc = Point2D(blc_x + border_offset, trc_y - border_offset)

   -- create a contour for border
   local contour = Contour(0.0)
   contour:AppendPoint(blc)
   contour:LineTo(brc)
   contour:LineTo(trc)
   contour:LineTo(tlc)
   contour:LineTo(blc)
 
   -- add it to the border group
   border_group:AddTail(contour)
   
 
end


--[[  -------------- CreateToolpath --------------------------------------------------  
|
|   Create an 'imported' toolpath within the program.
|  Parameters:
|     name              -- Name for toolpath
|     vectors           -- Vectors representing the toolpath
|     start_depth       -- Start depth for toolpath below surface of material
|
|  Return Values:
|     true if toolpath created OK else false
|
]]

function CreateToolpath(name, vectors, start_depth)

   -- Create tool we will use to machine vectors
   local tool = Tool(
                    "Lua End Mill", 
                    Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                    )
                     
   tool.InMM = true
   tool.ToolDia = 3.0
   tool.Stepdown = 2.0
   tool.Stepover = 1.0
   tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
   tool.FeedRate = 30
   tool.PlungeRate = 10
   tool.SpindleSpeed = 20000
   tool.ToolNumber = 1
   tool.VBitAngle = 90.0     -- used for vbit only
   tool.ClearStepover = 1.0  -- used for vbit only


   -- we will set home position and safe z relative to material block size  
   local mtl_block = MaterialBlock()  
   local mtl_box = mtl_block.MaterialBox
   local mtl_box_blc = mtl_box.BLC
  
   -- Create object used to set home position and safez gap above material surface
   local pos_data = ToolpathPosData()
   pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
   pos_data.SafeZGap = mtl_block.Thickness * 0.1
  
   -- object used to pass data on toolpath settings
   local toolpath_options = ExternalToolpathOptions()
      toolpath_options.StartDepth = start_depth
      toolpath_options.CreatePreview = true
   
   -- Create our toolpath
   local toolpath = ExternalToolpath(
                                    name,
                                    tool,
                                    pos_data,
                                    toolpath_options,
                                    vectors
                                    )
 
   if toolpath:Error() then
      DisplayMessageBox("Error creating toolpath")
      return
   end

   local toolpath_manager = ToolpathManager()
  
   local success = toolpath_manager:AddExternalToolpath(toolpath)

   return success  

end


--[[  -------------- main --------------------------------------------------  
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
 
    local mtl_block = MaterialBlock()
 
    -- create a group to hold our contours we wil use as a toolpath
    local border_group = ContourGroup(true)

    AddBorder( job, job.Width * 0.04, border_group )
    AddBorder( job, job.Width * 0.07, border_group )
   
    
    CreateToolpath( "Lua Simple Border Toolpath", border_group, mtl_block.Thickness )
    
    
    return true;
end    