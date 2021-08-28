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

--[[  ---------------- SelectVectorsOnLayer ----------------  
|
|   Add all the vectors on the layer to the selection
|     layer,            -- layer we are selecting vectors on
|     selection         -- selection object
|     select_closed     -- if true  select closed objects
|     select_open       -- if true  select open objects
|     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
|  Return Values:
|     true if selected one or more vectors
|
]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
    
   local objects_selected = false
   local warning_displayed = false
   
   local pos = layer:GetHeadPosition()
      while pos ~= nil do
	     local object
         object, pos = layer:GetNext(pos)
         local contour = object:GetContour()
         if contour == nil then
            if (object.ClassName == "vcCadObjectGroup") and select_groups then
               selection:Add(object, true, true)
               objects_selected = true
            else 
               if not warning_displayed then
                  local message = "Object(s) without contour information found on layer - ignoring"
                  if not select_groups then
                     message = message .. 
                               "\r\n\r\n" .. 
                               "If layer contains grouped vectors these must be ungrouped for this script"
                  end
                  DisplayMessageBox(message)
                  warning_displayed = true
               end   
            end
         else  -- contour was NOT nil, test if Open or Closed
            if contour.IsOpen and select_open then
               selection:Add(object, true, true)
               objects_selected = true
            else if select_closed then
               selection:Add(object, true, true)
               objects_selected = true
            end            
         end
         end
      end  
   -- to avoid excessive redrawing etc  we added vectors to the selection in 'batch' mode
   -- tell selection we have now finished updating
   if objects_selected then
      selection:GroupSelectionFinished()
   end   
   return objects_selected   
end   

--[[  ---------------- CreateLayerProfileToolpath ----------------  
|
|   Create an outside Profile toolpath within the program for vectors on the passed layer
|  Parameters:
|     job               -- Job we are working with
|     layer_name        -- Name of layer we will profile vectors for
|     name              -- Name for toolpath
|     start_depth       -- Start depth for toolpath below surface of material
|     cut_depth         -- cut depth for profile toolpath
|     tool_dia          -- diameter of end mill to use
|     tool_stepdown     -- stepdown for tool
|     tool_in_mm        -- true if tool size and stepdown are in mm
|
|  Return Values:
|     true if toolpath created OK else false
|
]]

function CreateLayerProfileToolpath( job, layer_name, name , start_depth, cut_depth, tool_dia, tool_stepdown, tool_in_mm)


   -- clear current selection
   local selection = job.Selection
   selection:Clear()
   
   -- get layer
   local layer = job.LayerManager:FindLayerWithName(layer_name)
   
   if layer == nil then
      DisplayMessageBox("No layer found with name = " .. "\"" ..  layer_name .. "\"")
      return false
   end

   
   -- select all closed vectors on the layer
   if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. "\"" .. layer_name .. "\"")
      return false
   end
   
   -- Create tool we will use to machine vectors
   local tool = Tool(
                    "Lua End Mill", 
                    Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                    )
                     
   tool.InMM = tool_in_mm
   tool.ToolDia = tool_dia
   tool.Stepdown = tool_stepdown
   tool.Stepover = tool_dia * 0.25
   tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
   tool.FeedRate = 30
   tool.PlungeRate = 10
   tool.SpindleSpeed = 20000
   tool.ToolNumber = 1
   tool.VBitAngle = 90.0                -- used for vbit only
   tool.ClearStepover = tool_dia * 0.5  -- used for vbit only
  

   -- we will set home position and safe z relative to material block size  
   local mtl_block = MaterialBlock()  
   local mtl_box = mtl_block.MaterialBox
   local mtl_box_blc = mtl_box.BLC
  
   -- Create object used to set home position and safez gap above material surface
   local pos_data = ToolpathPosData()
   pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
   pos_data.SafeZGap = mtl_block.Thickness * 0.1
  
  
   -- Create  object used to pass profile options
   local profile_data = ProfileParameterData()
      -- start depth for toolpath
      profile_data.StartDepth = start_depth
      
      -- cut depth for toolpath this is depth below start depth
      profile_data.CutDepth = cut_depth
      
      -- direction of cut - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
      profile_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
      
      -- side we machine on - ProfileParameterData.PROFILE_OUTSIDE,  ProfileParameterData.PROFILE_INSIDE or ProfileParameterData.PROFILE_ON
      profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE
      
      -- Allowance to leave on when machining
      profile_data.Allowance = 0.0
   
      -- true to preserve start point positions, false to reorder start points to minimise toolpath length   
      profile_data.KeepStartPoints = false
      
      -- true if want to create 'square' external corners on toolpath
      profile_data.CreateSquareCorners = false
      
      -- true to perform corner sharpening on internal corners (only with v-bits)
      profile_data.CornerSharpen = false
      
      -- true to use tabs (position of tabs must already have been defined on vectors)
      profile_data.UseTabs = false
      -- length for tabs if being used
      profile_data.TabLength = 5.0
      -- Thickness for tabs if being used
      profile_data.TabThickness = 1.0
      -- if true then create 3d tabs else 2d tabs
      profile_data.Use3dTabs  = true
      
      -- if true in Aspire, project toolpath onto composite model
      profile_data.ProjectToolpath = false
      
   -- Create object used to control ramping
   local ramping_data = RampingData()
      -- if true we do ramping into toolpath
      ramping_data.DoRamping = false
      -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG or RampingData.RAMP_SPIRAL
      ramping_data.RampType = RampingData.RAMP_ZIG_ZAG
      -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE or RampingData.CONSTRAIN_ANGLE
      ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE
      -- if we are constraining ramp by distance, distance to ramp over
      ramping_data.RampDistance = 100.0
      -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
      ramping_data.RampAngle = 25.0
      -- if we are contraining ramp by angle, max distance to travel before 'zig zaging' if zig zaging
      ramping_data.RampMaxAngleDist = 15
      -- if true we restrict our ramping to lead in section of toolpath
      ramping_data.RampOnLeadIn = false
      
   
   -- Create object used to control lead in/out
   local lead_in_out_data = LeadInOutData()
      -- if true we create lead ins on profiles (not for profile on) 
      lead_in_out_data.DoLeadIn = false
      -- if true we create lead outs on profiles (not for profile on) 
      lead_in_out_data.DoLeadOut = false
      -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
      lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD
      -- length of lead to create
      lead_in_out_data.LeadLength = 10.0
      -- Angle for linear leads
      lead_in_out_data.LinearLeadAngle = 45
      -- Radius for circular arc leads
      lead_in_out_data.CirularLeadRadius = 5.0
      -- distance to 'overcut' (travel past start point) when profiling
      lead_in_out_data.OvercutDistance = 0.0

   -- Create object which can used to automatically select geometry on layers etc
   local geometry_selector = GeometrySelector() 
   
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
   local create_2d_previews = true
   
   -- if this is true we will display errors and warning to the user
   local display_warnings = true
   
   -- Create our toolpath

   local toolpath_manager = ToolpathManager()
 
   local toolpath_id = toolpath_manager:CreateProfilingToolpath(
                                              name,
                                              tool,
                                              profile_data,
                                              ramping_data,
                                              lead_in_out_data,
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
 
    local layer_name = "Layer 1"
    
    local mtl_block = MaterialBlock()
	
    local start_depth = 0.0
    local cut_depth = mtl_block.Thickness
	
    local tool_dia = 3.0
    local tool_stepdown = 1.0
    local tool_in_mm = true
    
    local success = CreateLayerProfileToolpath(
	                                          job,
                                              layer_name,                                          
                                              "Lua Profile Toolpath", 
                                              start_depth, 
                                              cut_depth, 
                                              tool_dia, 
                                              tool_stepdown, 
                                              tool_in_mm 
                                              )
    
    
    return success;
end    