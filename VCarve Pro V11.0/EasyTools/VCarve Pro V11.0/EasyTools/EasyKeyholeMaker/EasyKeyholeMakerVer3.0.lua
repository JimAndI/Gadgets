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
-- ======================================================]]
-- Note: This version of the EasyKeyhole is a rewrite of the Keyhole_Toolpath gadget produced and provided by Vectric Ltd.
-- At no point should anyone believe that I (Jimandi) did anything but add some functionality.
-- This is and always will be a Gadget delived and write by Vectric Ltd team.
-- ======================================================]]
-- require("mobdebug").start()
require "strict"
-- Global default values - persist via registry

g_slot_orientation   = 1
g_slot_depth         = 0.25
g_slot_length        = 1.0

g_create_preview     = true
g_entry_hole_dia     = 0.5
g_slot_dia           = 0.25
g_slope_down         = 0.050 -- JimAndi
g_preview_layer_name = "Keyhole Preview"

g_default_tool_id  = ToolDBId()
g_tool = nil
g_toolpath_name = "Keyhole Toolpath"

g_window_width       = 659
g_window_height      = 767
g_slot_angle         = 90.0  -- JimAndi

g_dialog_title = "Keyhole Toolpath Creator"

g_version = "3.0"

g_note = "Version 3.0 Note: The EasyKeyhole version of the EasyKeyhole is a rewrite of the Keyhole_Toolpath gadget produced and provided by Vectric Ltd. At no point should anyone believe that I (Jimandi) did anything but add some functionality. This is and always will be a Gadget delived and write by Vectric Ltd team."

-- BrianM 10/11/2010 V1.1 Had DisplayMesageBox incorrect spelling for error if user used grouped start points

-- JimAndi 10/12/2021 V2.0 Added User Rotation Angle functionality. Clean up the HTML File
-- JimAndi 10/14/2021 V3.0 Added slope amount to the keyway
-- =====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- =====================================================]]
--[[ ----------- GetUserChoices -------------------------------------
|
| Display a dialog prompting user for options for processing
|
|  job                   - job we are working with
|  script_path           - pathname to this script
|  load_default_values   - if true load default values from registry rather than using script values
|
| Returns 1 if Ok, 0 if user cancelled -1 if error in data (retry)
|
--]]
function GetUserChoices(job, script_path, load_default_values)

-- load our default values from the registry
   local registry = Registry("KeyholeToolpath")
   if load_default_values then
      g_slot_orientation   = registry:GetInt("HoleOrientation",     g_slot_orientation)
      g_slot_depth         = registry:GetDouble("SlotDepth",        g_slot_depth)
      g_slot_length        = registry:GetDouble("SlotLength",       g_slot_length)
      g_create_preview     = registry:GetBool("CreatePreviewCheck", g_create_preview)
      g_entry_hole_dia     = registry:GetDouble("EntryHoleDia",     g_entry_hole_dia)
      g_slope_down         = registry:GetDouble("SlopeDownAmount",  g_slope_down)  -- JimAndi
      g_slot_dia           = registry:GetDouble("SlotDiameter",     g_slot_dia)
      g_slot_angle         = registry:GetDouble("SlotAngle",        g_slot_angle)  -- JimAndi
      g_preview_layer_name = registry:GetString("PreviewLayerName", g_preview_layer_name)
      g_default_tool_id:LoadDefaults("KeyholeToolpath", "")
      g_toolpath_name      = registry:GetString("ToolpathName",     g_toolpath_name)

      g_window_width       = registry:GetInt("WindowWidth",         g_window_width)
      g_window_height      = registry:GetInt("WindowHeight",        g_window_height)
   end

   local html_path = "file:" .. script_path .. "\\Keyhole_Toolpath2.htm"
   local dialog = HTML_Dialog(
                             false,
                             html_path,
                             g_window_width,g_window_height,
                             g_dialog_title
                             )

   -- Gadget Version
   dialog:AddLabelField("GadgetVersion",    g_version)

   dialog:AddRadioGroup("HoleOrientation",  g_slot_orientation)
   dialog:AddDoubleField("SlotDepth",       g_slot_depth)
   dialog:AddDoubleField("SlotLength",      g_slot_length)
   dialog:AddDoubleField("SlotAngle",       g_slot_angle)  -- JimAndi
   dialog:AddCheckBox("CreatePreviewCheck", g_create_preview)
   dialog:AddDoubleField("EntryHoleDia",    g_entry_hole_dia)
   dialog:AddDoubleField("SlopeDownAmount", g_slope_down)  -- JimAndi
   dialog:AddDoubleField("SlotDiameter",    g_slot_dia)
   dialog:AddTextField("PreviewLayerName",  g_preview_layer_name)
   dialog:AddLabelField("ToolNameLabel", "No Tool Selected")
   dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", g_default_tool_id);
   -- add allowed tool types - we only support end mills as a 'proxy' for a key hole cutter
   dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)

   -- toolpath name
   dialog:AddTextField("ToolpathName",  g_toolpath_name)

   -- ========== Display Dialog ========================================

   if not dialog:ShowDialog() then
       -- DisplayMessageBox("User canceled dialog")
       return 0
   end
    -- get tool user selected
   local tool = dialog:GetTool("ToolChooseButton");
   if tool == nil then
      DisplayMessageBox("No tool selected!")
      return -1
   end
   g_tool = tool

   -- get values user has entered on dialog
   g_slot_orientation   = dialog:GetRadioIndex("HoleOrientation")
   g_slot_angle         = dialog:GetDoubleField("SlotAngle")  -- JimAndi
   g_slot_depth         = dialog:GetDoubleField("SlotDepth")
   g_slot_length        = dialog:GetDoubleField("SlotLength")
   g_slope_down         = math.abs(dialog:GetDoubleField("SlopeDownAmount"))  -- JimAndi
   g_create_preview     = dialog:GetCheckBox("CreatePreviewCheck")
   g_entry_hole_dia     = dialog:GetDoubleField("EntryHoleDia")
   g_slot_dia           = dialog:GetDoubleField("SlotDiameter")
   g_preview_layer_name = dialog:GetTextField("PreviewLayerName")
   g_default_tool_id = tool.ToolDBId

   -- we keep the size the user has used for the dialog widnow
   g_window_width       = dialog.WindowWidth
   g_window_height      = dialog.WindowHeight

   -- toolpath name
   g_toolpath_name = dialog:GetTextField("ToolpathName")
   if string.len(g_toolpath_name) < 1 then
      DisplayMessageBox("A name must be entered for the toolpath")
      return -1
   end

   if g_slot_length < 0.000001 then
      DisplayMessageBox("The Slot length must be greater than zero!")
      return -1
   end

   if g_slot_depth < 0.000001 then
      DisplayMessageBox("The Slot depth must be greater than zero!")
      return -1
   end

   if g_create_preview and (g_entry_hole_dia < 0.000001) then
      DisplayMessageBox("The Entry Hole diameter must be greater than zero!")
      return -1
   end

   if g_create_preview and (g_slot_dia < 0.000001) then
      DisplayMessageBox("The Slot diameter must be greater than zero!")
      return -1
   end

   if g_create_preview and (g_entry_hole_dia <= g_slot_dia) then
      DisplayMessageBox("The Slot diameter must be less than the Entry Hole diameter!")
      return -1
   end

   -- save values as defaults for next time
   registry:SetInt("HoleOrientation",     g_slot_orientation)
   registry:SetDouble("SlotDepth",        g_slot_depth)
   registry:SetDouble("SlotLength",       g_slot_length)
   registry:SetDouble("SlotAngle",        g_slot_angle) -- JimAndi
   registry:SetBool("CreatePreviewCheck", g_create_preview)
   registry:SetDouble("EntryHoleDia",     g_entry_hole_dia)
   registry:SetDouble("SlopeDownAmount",  g_slope_down) -- JimAndi
   registry:SetDouble("SlotDiameter",     g_slot_dia)
   registry:SetString("PreviewLayerName", g_preview_layer_name)
   registry:SetString("JimAndI_Note", g_note)
   g_default_tool_id:SaveDefaults("KeyholeToolpath", "")
   registry:SetString("ToolpathName",     g_toolpath_name)
   registry:SetInt("WindowWidth",         g_window_width)
   registry:SetInt("WindowHeight",        g_window_height)
   return 1

end

--[[  ------------------ CreateSlotVector--------------------------------------------------
|
|   Create a slot vector with entry at passed point - this is simply a line from the point in the
|   slot direction of the specified slot length
|
|  slot_direction    - integer indicating direction for slot
|  slot_length       - length of the slot toolpath
|  start_point       - Start point of slot - tool plunges here
|
]]

function CreateSlotVector(slot_direction, slot_length, start_point)

   -- DisplayMessageBox("CreateSlotVector")

   local end_point
   if slot_direction == 1 then
      -- vertical slot - Bottom to Top
      -- end_point = Point2D(start_point.x, start_point.y + slot_length)
      end_point = Point3D(start_point.x, start_point.y + slot_length, -0.1 * g_slope_down)
   elseif slot_direction == 2 then
      -- vertical slot - Top to Bottom
      --end_point = Point2D(start_point.x, start_point.y - slot_length)
      end_point = Point3D(start_point.x, start_point.y - slot_length, -0.1 * g_slope_down)
   elseif slot_direction == 3 then
      -- horizontal slot - Left to Right
      -- end_point = Point2D(start_point.x + slot_length, start_point.y)
      end_point = Point3D(start_point.x + slot_length, start_point.y, -0.1 * g_slope_down)
   elseif slot_direction == 4 then
      -- horizontal slot - Rigth to Left
      -- end_point = Point2D(start_point.x - slot_length, start_point.y)
      end_point = Point3D(start_point.x - slot_length, start_point.y, -0.1 * g_slope_down)
   elseif slot_direction == 5 then  -- JimAndI
      -- User input angle
      -- end_point = Polar2D(start_point, g_slot_angle, slot_length)
      end_point = Polar2D(start_point, g_slot_angle, slot_length)
      end_point = Point3D(end_point.X, end_point.Y,  -0.1 * g_slope_down)
   else
      DisplayMessageBox("Invalid slot direction! - " .. slot_direction)
      return nil
   end

   -- create a contour for slot from start out to end and then back again
   local contour = Contour(0.0)
   contour:AppendPoint(start_point)
   contour:LineTo(end_point)
   contour:LineTo(start_point)

   return contour
end


 --[[  ------------------ CreateKeyholeToolpath --------------------------------------------------
|
|   Create a toolpath to machine keyhole slots with the specified parameters
| The centers of the currently selected vecotrs represent the start / plunge point for the keyhole slots
|
|  toolpath_name   - name to use for toolpath we create
|  selection       - list of currently selected objects in the program
|  slot_direction  - integer indicating direction for slot
|  slot_length     - length of the slot toolpath
|  tool            - tool to use for toolpath
|
| This function returns the contour group representing the slot centre lines
|
]]

function CreateKeyholeToolpath(toolpath_name, selection, slot_direction, slot_depth, slot_length, tool)


   local keyhole_centre_lines = ContourGroup(true)

   local selection_pos = selection:GetHeadPosition()
   while selection_pos ~= nil do
      local object
      object, selection_pos = selection:GetNext(selection_pos)
      -- get the contour for the object (if it has one)
      local contour = object:GetContour()
      if contour == nil then
         if (object.ClassName == "vcCadObjectGroup") then
            DisplayMessageBox("Grouped vectors can not be used to indicate start points - please ungroup")
         end
      else
         local bounds = contour.BoundingBox2D
         local centre_pt = bounds.Centre
         -- create a vector representing slot from this point
         local keyhole_centreline = CreateSlotVector(slot_direction, slot_length, centre_pt)
         if not (keyhole_centreline == nil) then
            keyhole_centre_lines:AddTail(keyhole_centreline)
         end
      end

   end

   -- when we reach here we have processed all the selected vectors - have we created some slot centrelines?
   if keyhole_centre_lines.IsEmpty then
      -- NO - report error and return
      DisplayMessageBox("No slots created for current selection")
      return nil
   end

   -- Create object used to set home position and safez gap above material surface
   local pos_data = ToolpathPosData()

    -- object used to pass data on toolpath settings
   local toolpath_options = ExternalToolpathOptions()
   toolpath_options.StartDepth = slot_depth
   toolpath_options.CreatePreview = true

   -- Create our toolpath
   local toolpath = ExternalToolpath(
                                    toolpath_name,
                                    tool,
                                    pos_data,
                                    toolpath_options,
                                    keyhole_centre_lines
                                    )

   if toolpath:Error() then
      DisplayMessageBox("Error creating toolpath")
      return nil
   end

   local toolpath_manager = ToolpathManager()
   toolpath_manager:AddExternalToolpath(toolpath)

   -- we return the slot vectors to caller so can create previews if necessary
   return keyhole_centre_lines
end

 --[[  ------------------ CreateKeyholeVector --------------------------------------------------
|
|   Create vector reresenting the otuline of a keyhole slot on the material surface
|
| start_point       - start (plunge point) for slot
| end_point         - end point of slot - end poit for centre of tool
| entry_hole_dia    - diameter of entry hole
| slot_dia          - diameter of slot
| layer             - layer to create vectors on
|
]]

function CreateKeyholeVector(start_point, end_point, entry_hole_dia, slot_dia, layer)

   -- calculate point at which 'slot' intersects entry hole circle - this is relative to slot direction
   local entry_rad = entry_hole_dia * 0.5
   local slot_rad = slot_dia * 0.5;
   local dx = math.sqrt((entry_rad * entry_rad) - (slot_rad * slot_rad))
   local dy = slot_rad


   local slot_dir = end_point - start_point
   local vector_length = slot_dir.Length
   local slot_len = vector_length - dx

   slot_dir:Normalize()

   local side_vec = slot_len * slot_dir
   local intersect_pt = start_point + (dx * slot_dir)

   -- calculate 'points' around perimeter of slot, we start
   --[[
        |   For a horizontal slot this is .... (excuse rubbish art ...)
        |              p8
        |           ---+----\                                    p2
        |         /          +-----------------------------------+-
        |        |           p1                                    \
        |  p7   +      + start_point                   end_point +  +  p3
        |        |           p5                                    /
        |         \          +-----------------------------------+-
        |          ----+----/                                    p4
        |               p6
        |
        |  As we work entirely with relative vectors we dont need to worry about orientation
     ]]

   -- points on top edge of slot
   local p1 = intersect_pt - (dy * slot_dir:NormalTo())
   local p2 = p1 + side_vec
   -- centre point at end of slot
   local p3 = start_point + ((vector_length + slot_rad) * slot_dir)
   -- points on bottom edge of slot
   local p5 = intersect_pt + (dy * slot_dir:NormalTo())
   local p4 = p5 + side_vec
   -- 'quadrant' points on entry circle
   local p6 = start_point + (entry_rad * slot_dir:NormalTo())
   local p7 = start_point - (entry_rad * slot_dir)
   local p8 = start_point - (entry_rad * slot_dir:NormalTo())


   local contour = Contour(0.0)
   contour:AppendPoint(p1)
   contour:LineTo(p2)
   contour:ArcTo(p3, end_point, false)
   contour:ArcTo(p4, end_point, false)
   contour:LineTo(p5)
   contour:ArcTo(p6, start_point, false)
   contour:ArcTo(p7, start_point, false)
   contour:ArcTo(p8, start_point, false)
   contour:ArcTo(p1, start_point, false)


   local cad_object = CreateCadContour(contour);

   layer:AddObject(cad_object, true)

   return true

end

 --[[  ------------------ CreateKeyholePreviews --------------------------------------------------
|
|   Create vectors representing the outlines of the keyhole slots on the material surface
|
| job                    - job we are creating vector in
| keyhole_centrelines    - group iof vectors representing keyhole centrelines
| layer_name             - name of layer to create previews on
| entry_hole_dia         - diameter of entry hole
| slot_dia               - diameter of slot
|
]]

function CreateKeyholePreviews(job, keyhole_centrelines, layer_name, entry_hole_dia, slot_dia)

   -- get layer we will create previews on
   local layer_manager = job.LayerManager

   local layer =  job.LayerManager:GetLayerWithName(layer_name)
   if layer == nil then
      DisplayMessageBox("Unable to create layer for previews - " .. layer_name)
      return false
   end

   local pos = keyhole_centrelines:GetHeadPosition()
   while pos ~= nil do
      local contour
      contour, pos = keyhole_centrelines:GetNext(pos)
      -- get first span - this will give us start and end points for slot ...
      local span = contour:GetAt(contour:GetHeadPosition())
      local start_pt = span.StartPoint2D
      local end_pt   = span.EndPoint2D

      CreateKeyholeVector(start_pt, end_pt, entry_hole_dia, slot_dia, layer)
   end

   job:Refresh2DView()

   return true
end

--[[  ------------------ main --------------------------------------------------
|
|  Entry point for script
|
]]

function main(script_path)

   -- DisplayMessageBox("Script Path = " .. script_path)

   -- Check we have a job loaded
   local job = VectricJob()

   if not job.Exists then
       MessageBox("No job loaded")
       return false;
    end

   local selection = job.Selection
   if selection.IsEmpty then
       MessageBox(
                  "Please select one or more circular vectors\r\n\r\n" ..
                  "The centers of the vectors will indicate the ENTRY point(s) for the keyhole slots"
                  )
       return false
    end

   -- Get user choices, if return -1 user entered an invalid value - try again
   local load_default_values = true
   local retry_dialog = true

   while retry_dialog do
      local ret_value = GetUserChoices(job, script_path, load_default_values)
      if ret_value == 0 then
         return false -- user cancelled dialog
      end
      load_default_values = false  -- we only load default values first time we display dialog
      if ret_value == 1 then
         retry_dialog = false  -- we got valid values
      end
   end

   -- we are now ready to create our keyholes ...
   local vectors = CreateKeyholeToolpath(
                                         g_toolpath_name,
                                         selection,
                                         g_slot_orientation,
                                         g_slot_depth,
                                         g_slot_length,
                                         g_tool
                                         )

   if not (vectors == nil) then
      if g_create_preview then
         -- check user has specified the entry hole as bigger than the slot diameter
         if g_entry_hole_dia <= g_slot_dia then
            DisplayMessageBox("The entry hole diameter must be greater than the slot diameter")
            return false
         else
            CreateKeyholePreviews(
                                 job,
                                 vectors,
                                 g_preview_layer_name,
                                 g_entry_hole_dia,
                                 g_slot_dia
                                 )
         end
      end
   end

   return true

end
