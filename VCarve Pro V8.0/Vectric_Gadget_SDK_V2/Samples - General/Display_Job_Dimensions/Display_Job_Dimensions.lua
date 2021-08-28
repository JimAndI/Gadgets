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

--[[  --------------- DisplayJobDimensions --------------------------------------------------  
|
|   Display information about the size and position of the current job
|
|  Parameters:
|     job         - job we are working with
|
|  Return Values:
|    None
]]
function DisplayJobDimensions(job)
     
    local units, units2
     
    if job.Exists then
         
       if job.InMM then
          units  = " mm"
          units2 = " mm2"
       else
          units  = " inches"
          units2 = " sq inches"
       end   
     
       local area = job.Width * job.Height
       local blc_x = job.MinX
       local blc_y = job.MinY
       local trc_x = blc_x + job.Width
       local trc_y = blc_y + job.Height

       DisplayMessageBox( 
                        "Name = " .. job.Name .. "\n\n" .. 
                        "Width = " .. job.Width .. units .."\n" ..
                        "Height = " .. job.Height .. units .. "\n" ..
                        "Area = " .. area .. units2 .."\n" ..
                        "Bottom Left = (" .. blc_x .. "," .. blc_y .. ")\n" ..
                        "Top Right   = (" .. trc_x .. "," .. trc_y .. ")\n"
                        )
                        
    else
           DisplayMessageBox("No job loaded")
    end    
end

--[[  --------------- DisplayMaterialSettings --------------------------------------------------  
|
|   Display information about the size and position etc of the material block
|
|
|  Return Values:
|    None
]]
function DisplayMaterialSettings()
     
    local mtl_block = MaterialBlock()
    local units
     
    if mtl_block.InMM then
      units  = " mm"
    else
      units  = " inches"
    end   

    -- Display material XY origin
    local xy_origin_text = "invalid"
    local xy_origin = mtl_block.XYOrigin
   
    if     xy_origin == MaterialBlock.BLC then
       xy_origin_text = "Bottom Left Corner"
    elseif xy_origin == MaterialBlock.BRC then
       xy_origin_text = "Bottom Right Corner"
    elseif xy_origin == MaterialBlock.TRC then
       xy_origin_text = "Top Right Corner"
    elseif xy_origin == MaterialBlock.TLC then
       xy_origin_text = "Top Left Corner"
    elseif xy_origin == MaterialBlock.CENTRE then  -- NOTE: English spelling for Centre!
       xy_origin_text = "Centre"
    else
       xy_origin_text = "Unknown XY origin value!"
    end   
        
    local z_origin_text = "invalid"
    local z_origin = mtl_block.ZOrigin
   
    if     z_origin == MaterialBlock.Z_TOP then
       z_origin_text = "Top of Material"
    elseif z_origin == MaterialBlock.Z_CENTRE then -- NOTE: English spelling for Centre!
       z_origin_text = "Centre of Material"
    elseif z_origin == MaterialBlock.Z_BOTTOM then
       z_origin_text = "Bottom of Material"
    else
       z_origin_text = "Unknown Z origin value!"
    end   

    local xy_origin_pos =  mtl_block.ActualXYOrigin  

    -- get 3d box object describing material bounds ....    
    local mtl_box = mtl_block.MaterialBox
    local mtl_box_blc = mtl_box.BLC
    
    -- test methods to conver z values between absolute z and relative depths
    local test_val = 0.125
    local depth = mtl_block:CalcDepthFromAbsoluteZ(test_val)
    local abs_z = mtl_block:CalcAbsoluteZFromDepth(test_val)
    
    DisplayMessageBox( 
                    "Width     = " .. mtl_block.Width     .. units .."\n" ..
                    "Height    = " .. mtl_block.Height    .. units .. "\n" ..
                    "Thickness = " .. mtl_block.Thickness .. units .. "\n" ..
                    "\n" ..
                    "XY Origin = " .. xy_origin_text .. "\n" ..
                    "  Position = (" .. xy_origin_pos.x .. ", " .. xy_origin_pos.y .. ")\n" ..
                    "Z  Origin = " .. z_origin_text .. "\n" ..
                    "\n" ..
                    "Box Width     = " .. mtl_box.XLength  .. units .."\n" ..
                    "Box Height    = " .. mtl_box.YLength  .. units .. "\n" ..
                    "Box Thickness = " .. mtl_box.ZLength  .. units .. "\n" ..
                    "Box Bottom Left Corner = (" .. mtl_box_blc.x  .. ", " .. mtl_box_blc.y  .. ", " ..  mtl_box_blc.z  .. ")\n" ..
                    "\n" ..
                    "Test Value = " .. test_val .. "\n" ..
                    "  Depth from absolute test value = " .. depth .. "\n" ..
                    "  Absolute Z from depth test value = " .. abs_z .. "\n" ..
                    "\n" 
                    )
                
end


--[[  ______________________ main --------------------------------------------------  
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
 
    DisplayJobDimensions( job )

    DisplayMaterialSettings()
    
    return true;
end    