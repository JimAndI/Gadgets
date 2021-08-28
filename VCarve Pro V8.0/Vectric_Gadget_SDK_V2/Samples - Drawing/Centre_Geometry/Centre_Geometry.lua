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

--[[ ---------- CentreObjectInJob --------------------------
|
| Centre passed object in job
|
| The passed point to centre is point which will end up in centre of document
|
]]
function CentreObjectInJob(job, object, point_to_centre_x, point_to_centre_y)
  
  
   -- get coords of centre of document
   local job_centre_x = job.MinX + (job.Width  / 2.0)
   local job_centre_y = job.MinY + (job.Height / 2.0)

     
   -- create transformation matrix to transform object
   local point_to_centre = Point2D(point_to_centre_x, point_to_centre_y)
   local centre_point = Point2D(job_centre_x , job_centre_y)

   local centre_vector =  centre_point - point_to_centre
   
   local xform = TranslationMatrix2D(centre_vector)

   object:Transform(xform) 
   return true   
 
end

function main()
   local job = VectricJob()
   if not job.Exists then
    DisplayMessageBox("No job loaded")
    return false;
   end

   -- Create a star centred on X5, Y5 on layer VCP_Tools

   local layer = job.LayerManager:GetLayerWithName("VCP_Tools")
   local bez_ctrl_1 = Point2D()
   local bez_ctrl_2 = Point2D()
   local end_pt     = Point2D()
   local contour = Contour(0.0)
   contour: AppendPoint( 5.19159 , 5.58966)
   end_pt:Set( 5 , 7)
   contour: LineTo(end_pt)
   end_pt:Set( 4.80841 , 5.58966)
   contour: LineTo(end_pt)
   end_pt:Set( 3.82443 , 6.61803)
   contour: LineTo(end_pt)
   end_pt:Set( 4.49841 , 5.36443)
   contour: LineTo(end_pt)
   end_pt:Set( 3.09789 , 5.61803)
   contour: LineTo(end_pt)
   end_pt:Set( 4.38 , 5)
   contour: LineTo(end_pt)
   end_pt:Set( 3.09789 , 4.38197)
   contour: LineTo(end_pt)
   end_pt:Set( 4.49841 , 4.63557)
   contour: LineTo(end_pt)
   end_pt:Set( 3.82443 , 3.38197)
   contour: LineTo(end_pt)
   end_pt:Set( 4.80841 , 4.41034)
   contour: LineTo(end_pt)
   end_pt:Set( 5 , 3)
   contour: LineTo(end_pt)
   end_pt:Set( 5.19159 , 4.41034)
   contour: LineTo(end_pt)
   end_pt:Set( 6.17557 , 3.38197)
   contour: LineTo(end_pt)
   end_pt:Set( 5.50159 , 4.63557)
   contour: LineTo(end_pt)
   end_pt:Set( 6.90211 , 4.38197)
   contour: LineTo(end_pt)
   end_pt:Set( 5.62 , 5)
   contour: LineTo(end_pt)
   end_pt:Set( 6.90211 , 5.61803)
   contour: LineTo(end_pt)
   end_pt:Set( 5.50159 , 5.36443)
   contour: LineTo(end_pt)
   end_pt:Set( 6.17557 , 6.61803)
   contour: LineTo(end_pt)
   end_pt:Set( 5.19159 , 5.58966)
   contour: LineTo(end_pt)
   local cad_object = CreateCadContour(contour);
   
   CentreObjectInJob(job, cad_object, 5.0, 5.0)
   
   layer:AddObject(cad_object, true)
   job.Selection:Add(cad_object, true, false)
   job:Refresh2DView()
   return true
end
