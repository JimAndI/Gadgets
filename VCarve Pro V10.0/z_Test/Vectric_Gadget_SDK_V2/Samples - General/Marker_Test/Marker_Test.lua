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

--[[  ------------------------------------------ MarkContourNodes --------------------------------------------------  
|
|  Insert a marker at each node on the passed contour
|
]]
function MarkContourNodes(contour, layer)

   local num_spans = 0
  
   local ctr_pos = contour:GetHeadPosition()
   while ctr_pos ~= nil do
      local span
      span, ctr_pos = contour:GetNext(ctr_pos) 
      -- create a marker at start of span
      local marker = CadMarker("V:" .. num_spans, span.StartPoint2D, 3)
      layer:AddObject(marker, true)
      num_spans = num_spans + 1;
   end
   -- if contour was open mark last point
   if contour.IsOpen then
      local marker = CadMarker("V:" .. num_spans, contour.EndPoint2D, 3)
      layer:AddObject(marker, true)
   end


end


--[[  ------------------------------------------ MarkContourParameterSteps --------------------------------------------------  
|
|  Insert a marker at each parameter step around the contour and display the distance from the start point
|
]]
function MarkContourParameterSteps(num_steps, contour, layer)

   local cursor = ContourCarriage(0, 0.0)
   
   local contour_length = contour.Length
   local step_dist = contour_length / num_steps
   
   local end_index = num_steps
   if contour.IsOpen then
      end_index = end_index + 1  
   end
   
   
   for i = 1, end_index do
     local ctr_pos = cursor:Position(contour)
     local marker = CadMarker("D:" .. (step_dist * (i - 1)), ctr_pos, 3)     
     layer:AddObject(marker, true)
     cursor:Move(contour, step_dist)

     end

end

--[[  ------------------------------------------ MarkContourParameter --------------------------------------------------  
|
|  Insert a marker at  parameter step around the contour
|
]]
function MarkContourParameter(parameter, text, contour, layer)
  
   local contour_length = contour.Length
   local parameter_dist = contour_length * parameter

   local cursor = ContourCarriage(0, 0.0)
   cursor:Move(contour, parameter_dist)
   local ctr_pos = cursor:Position(contour)

   local marker = CadMarker(text, ctr_pos, 3)     

   layer:AddObject(marker, true)

end




--[[  ------------------------------------------ main --------------------------------------------------  
|
|  Entry point for script - mark node indexes on selected contours
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
   if selection.IsEmpty then
       MessageBox("Please select one or more vectors to label")
       return false  
   end

   local ctr_count = 0;   

 -- create a layer with passed name if it doesnt already exist
   local layer = job.LayerManager:GetLayerWithName("Markers")
   
   local pos = selection:GetHeadPosition()
   while pos ~= nil do
      local object
      object , pos = selection:GetNext(pos)
      -- MessageBox(object.ClassName)
      -- iterate through each span in the contour
      if (object.ClassName == "vcCadContour") or (object.ClassName == "vcCadPolyline") then
       
         local contour = object:GetContour()
         MarkContourNodes(contour, layer)
         -- MarkContourParameterSteps(10, contour, layer)
         -- MarkContourParameter(0.5, "MidPoint", contour, layer)
         
         ctr_count = ctr_count + 1
   
      end
    
   end

   -- MessageBox( "Number of contours = " .. ctr_count .. "\n" )

   
   job:Refresh2DView()
    
   return true

end