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

--[[  ------------------------------------------ CreateSawTooth --------------------------------------------------  
|
|  Create a 'Saw Tooth' vector with passed parameters
|
|  Parameters:
|     start_pt      - a Point2D object holding the starting point for the vector
|     tooth_length  - length of each tooth
|     num_teeth     - number of teeth to create 
]]

function CreateSawTooth(start_pt, tooth_length, num_teeth)

   local contour = Contour(0.0)
   
   -- create a vector which represent the displacement between the bottom and top of a tooth
   local disp_vector = Vector2D(tooth_length, tooth_length)
   
   local cur_point = start_pt
   
   contour:AppendPoint(cur_point)
   -- create a 'saw tooth' vector - we go 'up' then 'down' for each tooth - hence 2 x num_teeth
   for n = 1, num_teeth * 2 do
      cur_point = cur_point + disp_vector
      contour:LineTo(cur_point)
	  -- reverse our displacement vector so if we were going 'up' we go 'down' and vice versa
      disp_vector.Y = disp_vector.Y * -1.0
   end
   
   return contour;
end

--[[  --------------- AddGroupToJob --------------------------------------------------  
|
|   Add passed group to the job - returns object created
|
|  Parameters:
|     job              -- job we are working with
|     group            -- group of contours to   add to document
|     layer_name       -- name of layer group will be created on
|
|  Return Values:
|     object created to represent group in document

]]

function AddGroupToJob(job, group, layer_name)

   --  create a CadObject to represent the  group
   local cad_object = CreateCadGroup(group);
   
   -- create a layer with passed name if it doesn't already exist
   local layer = job.LayerManager:GetLayerWithName(layer_name)

   -- and add our object to it
   layer:AddObject(cad_object, true)
   
   return cad_object
end

--[[  --------------- main --------------------------------------------------  
|
| Entry point for script
|
]]
function main()

 -- Check we have a document loaded
    local job = VectricJob()
 
    if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;  
    end

   local group = ContourGroup(true)

   local start_pos = Point2D(0,0)
 
   group:AddTail(CreateSawTooth(start_pos, 0.5, 5))
   
   start_pos:Set(0, 2)
   group:AddTail(CreateSawTooth(start_pos, 0.25, 10))
   
   -- iterate through the group and contours in group just for demonstration purposes ...
   local count = 0
   local num_spans = 0
   local span_length = 0.0
   local tolerance = 0.0001

   local pos = group:GetHeadPosition()
   while pos ~= nil do
      local contour
      contour , pos = group:GetNext(pos)
    
      -- iterate through each span in the contour
      local ctr_pos = contour:GetHeadPosition()
      while ctr_pos ~= nil do
	     local span
         span, ctr_pos = contour:GetNext(ctr_pos) 
         num_spans = num_spans + 1;
         span_length = span_length + span:GetLength(0.0001)
      end
    
      count = count + 1
   end

   MessageBox(
             "Number of contours = " .. count .. "\n" ..
             "Number of spans = " .. num_spans .. "\n" ..
             "Length of spans = " .. span_length 
             )

   AddGroupToJob(job, group, "Contour Creation Example")        

   job:Refresh2DView()
    
   return true

end