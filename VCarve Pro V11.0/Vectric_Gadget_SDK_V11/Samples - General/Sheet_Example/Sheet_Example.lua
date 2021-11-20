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
require("mobdebug").start()
--require "strict"


--[[  -------------- AddBorder --------------------------------------------------
|
|  Add a border passed distance in from edges of job to passed group
|
|  Parameters:
|    job                  -- job we are working with, we get size info from this
|    border_offset        -- offset from document edges for border
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

--[[  --------------- AddGroupToJob --------------------------------------------------
|
|   Add passed group to the job - returns object created
|
|  Parameters:
|     job              -- Job we are working with
|     group            -- group of contours to   add to document
|     layer_name       -- name of layer group will be created on
|
|  Return Values:
|     object created to represent group in document

]]

function AddGroupToJob(job, group, layer_name)

  --  create a CadObject to represent the  group
   local cad_object = CreateCadGroup(group);


   -- create a layer with passed name if it doesnt already exist
   local layer = job.LayerManager:GetLayerWithName(layer_name)

   -- and add our object to it
   layer:AddObject(cad_object, true)

   return cad_object
end



--[[  ----------------------- main -----------------------------
|
|  Entry point for script
|
]]

function main()

    -- Check we have a document loaded
    local job = VectricJob()
    if not job.Exists then
          DisplayMessageBox("No job loaded")
          return false
     end

    local layer_manager = job.CadLayerManager

    -- get current sheet count - note sheet 0 the default sheet counts as one sheet
	local orig_num_sheets = layer_manager.NumberOfSheets
	 -- get current active sheet index
	local orig_active_sheet_index = layer_manager.ActiveSheetIndex

    -- display original sheet info
    MessageBox(
	          "Original Sheet Info\n\n" ..
	          "Number of Sheets = " .. orig_num_sheets .. "\n" ..
	          "Active Sheet Index = " .. orig_active_sheet_index .. "\n"
              )


	-- set active sheet to last sheet
	local num_sheets = layer_manager.NumberOfSheets
	layer_manager.ActiveSheetIndex = num_sheets - 1

	job:Refresh2DView();

	-- display new sheet data
	local active_sheet_index = layer_manager.ActiveSheetIndex
     MessageBox(
	           "New Sheet Info\n\n" ..
	           "Number of Sheets = " .. num_sheets .. "\n" ..
	           "Active Sheet Index = " .. active_sheet_index .. "\n"
			   )

	-- Add a new sheet
    layer_manager:AddNewSheet()

	-- set active sheet to last sheet we just added
	num_sheets = layer_manager.NumberOfSheets
	layer_manager.ActiveSheetIndex = num_sheets - 1

    job:Refresh2DView();

    MessageBox(
              "New Sheet Info after adding a sheet\n\n" ..
	          "Number of Sheets = " .. num_sheets .. "\n" ..
	          "Active Sheet Index = " .. active_sheet_index .. "\n"
	          )

    -- now create a border contour on our sheet ...
    local border_group = ContourGroup(true)
    AddBorder(job, job.Width * 0.04, border_group )

	AddGroupToJob(job, border_group, "Sheet Example")

    -- set active sheet back to default ..
	layer_manager.ActiveSheetIndex = 0

	job:Refresh2DView()

    return true
end