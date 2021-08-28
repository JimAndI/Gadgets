-- VECTRIC LUA SCRIPT
-- Copyright 2014 Vectric Ltd.

-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

--- ATTENTION ---
-- Chamfer In & Out - is a modified version of the Vectric Chamfer Gadget v1.1
-- Chamfer Radius is modified version of Chamfer In & Out
-- The major modification was done to provide the ability to chamfer inside of a contour as well as the outside a contour.
-- The various modifications were done by me - Jeff Elliott. If you would like to contact me I can be reached via the Vectric forum.
-- In no event will the author. be held liable for any damages arising from use of this gadget.
-- -- Small changes by Adrian Matthews 29/09/2019 to work with latest versions of Vectric software.
-- Modified by Adrian Matthews on the 12th of Oct 2019 to work with V10.

require "strict"
g_debug = true
--require("mobdebug").start()
g_HALFPI = 1.57079632679
g_version = "12th Oct 2019"
g_title = "Create Chamfer Toolpath Radius"
g_width = 800
g_height = 625
g_html_file = "Chamfer Radius.htm"
g_outside_of_contour = true
g_chamfer_angle_offset = 0

--[[  -------------- main --------------------------------------------------
|
|  Entrance point of the program
|
]]
function main(script_path)
-- set up html form defaults
  local job = VectricJob()
  local options = {}
  options.tool = GetTestTool()
  options.angle = math.rad(45);
  options.chamfer_in = true
  options.depth = 1
  options.start_depth = 0
  options.radius = .125
  options.toolpath_name = "Radius Chamfer"
  options.in_mm = job.InMM
  LoadDefaults(options)
-- load user selected contours
  local selected_contours =(GetSelectedContours(job))
  if (selected_contours.IsEmpty) then
    DisplayMessageBox("Please select at least one contour.")
    return false
  end
  -- Display the dialog
  local dialog_displayed = -1
  while dialog_displayed == -1 do
    dialog_displayed = DisplayDialog(script_path, options)
  end
  if not dialog_displayed then
    return false
  end
  -- Get local safe z
  local material_block = MaterialBlock()
  options.start_z = material_block:CalcAbsoluteZ(-options.start_depth);
  options.finish_z = material_block:CalcAbsoluteZ(-options.start_depth - options.radius)
-- check for inch/millimeter misfits and scale if necessary
  local scale = 1
  if options.in_mm and (not options.tool.InMM) then
    -- App is in mm and tool is in inches
    scale = 25.4
  end
  if (not options.in_mm) and options.tool.InMM then
    scale = 0.0393700787
  end
  -- Compute number of contour offsets
  local total_offset = options.radius
  g_chamfer_angle_offset = total_offset
  local num_offsets = math.ceil(total_offset / (scale*options.tool.Stepover))
  -- single_dist = single offset distance
  local single_dist = total_offset / num_offsets;
  -- contours for total cut
  local cut_contours = ContourGroup(true)
  -- Return a POSITION object pointing to the first Contour in the group
  -- which can be used to iterate through the group contents
  local p_selected = selected_contours:GetHeadPosition()
  local current_contour
  --
  -- iterate through contours creating new contour groups for each selected cut-able contour
  --
  while p_selected ~= nil do
    current_contour, p_selected = selected_contours:GetNext(p_selected)
    -- Create a contour group containing single contour
    local current_group = ContourGroup(true)
    current_group:AddTail(current_contour:Clone())
    local signed_offset_dist = -1 * single_dist
    -- ?? not required ??
    if options.chamfer_in then
      signed_offset_dist  = -1 * signed_offset_dist
    end
    -- if the current contour is open post an error
    local offset_contours = ContourGroup(true)
    if current_contour.IsOpen then
      MessageBox("An open contour was encountered.\n Insure your contour/s are closed and try again.\n")
      return false
    else
      -- the contour is CLOSED so do regular offset
       offset_contours = current_group:Offset(signed_offset_dist, single_dist, num_offsets-1 , false)
      if not options.chamfer_in then
        offset_contours:MakeOffsetsSquare(single_dist , true, 0.5*options.tool.ToolDia,true)
      else
        offset_contours:MakeOffsetsSquare(single_dist , false, 0.5*options.tool.ToolDia,true)
      end
    end
    -- iterate over the offsets for each individual contour
    local p_cntr = offset_contours:GetHeadPosition()
    local total_contour = Contour(0.0)
    local cntr
    local current_z = options.start_z
    local temp = current_z
    local lowest_z = options.finish_z
    -- Calculate the depth of cut for each horizontal step over point
    -- and save in array
    --
    local zdepth
    local xposition = single_dist * 1
    local radius = options.radius
    zdepth = math.sqrt (radius*radius - xposition * xposition )
    local depthArray = {}    -- new array
    for i=1, num_offsets do
      xposition = single_dist * i
      zdepth = math.sqrt (radius*radius - xposition * xposition )
      depthArray[i] = zdepth
    end
    -- Calculate the horizontal and vertical (z) offsets
    local ballMill_H_offsetArray = {}    -- new array
    local ballMill_Z_offsetArray = {}    -- new array
    local ballMillRadius = scale*0.5*options.tool.ToolDia
    local singleBallMillOffset = ballMillRadius/num_offsets
    local currentBallMill_H_Offset = 0
    local currentBallMill_Z_Offset = 0
    for i=1, num_offsets do
      currentBallMill_H_Offset = singleBallMillOffset * i
      ballMill_H_offsetArray[i] = currentBallMill_H_Offset
      currentBallMill_Z_Offset = math.sqrt (ballMillRadius * ballMillRadius - currentBallMill_H_Offset * currentBallMill_H_Offset )
      ballMill_Z_offsetArray[i] = currentBallMill_Z_Offset
    end
     local zcounter = 0
    local ballOffset = 0
    while p_cntr ~= nil do
      cntr, p_cntr = offset_contours:GetNext(p_cntr)
      zcounter = zcounter + 1
      current_z = 0
      current_z = -radius + depthArray[zcounter]
      ballOffset = ballMill_H_offsetArray[zcounter]
      currentBallMill_Z_Offset  =  -ballMillRadius + ballMill_Z_offsetArray[zcounter]
      local pass_contour = (ComputeOffsetPassForGivenZ(currentBallMill_Z_Offset, options.start_z,
          current_z,
          options.tool,
          cntr,
          ballOffset,
          scale,
          lowest_z,
          options.chamfer_in)):GetHead():Clone()
      if total_contour.IsEmpty then
        total_contour:AppendPoint(pass_contour.StartPoint3D)
      else
        total_contour:LineTo(pass_contour.StartPoint3D)
      end
      total_contour:AppendContour(pass_contour)
    end
    cut_contours:AddTail(total_contour)
  end -- end of iteration through selection vectors
  -- get ready to create tool paths
  --
  local toolpath_options = ExternalToolpathOptions()
  toolpath_options.CreatePreview = true
  local pos_data = ToolpathPosData()
  cut_contours:OffsetInZ(0)
-- create tool paths
  local toolpath = ExternalToolpath(
    options.toolpath_name,
    options.tool,
    pos_data,
    toolpath_options,
    cut_contours
  )
  if toolpath:Error() then
    DisplayMessageBox("Error creating toolpath")
    return false
  end
  local toolpath_manager = ToolpathManager()
  local success = toolpath_manager:AddExternalToolpath(toolpath)
  if success then
    SaveDefaults(options)
  end
  return success
end
function ComputeOffsetPassForGivenZ( currentBallMill_Z_Offset, start_z, current_z, tool, contour, ballOffset, scale, lowest_z)
  local r = scale*0.5*tool.ToolDia
  local z_offset = 0
  local horizontal_offset = r
  -- if the tool is a ball nose then we have more complicated offset
  if (tool.ToolType == Tool.BALL_NOSE) then
    z_offset = currentBallMill_Z_Offset
    horizontal_offset = ballOffset
  end
  local single_contour_group = ContourGroup(true)
  single_contour_group:AddTail(contour:Clone())
  local horizontalOff = horizontal_offset
  if not g_outside_of_contour then
    -- inside of the contour chamfer
    horizontalOff  =  g_chamfer_angle_offset-horizontal_offset
  else
    -- outside of the contour chamfer
    horizontalOff  =  -g_chamfer_angle_offset+horizontal_offset
  end
  local offset_group = single_contour_group:Offset(horizontalOff, horizontal_offset, 1, false)
  offset_group:SetZHeight(current_z)
  offset_group:OffsetInZ(z_offset)

  return offset_group;
end


--[[  -------------- GetTestTool --------------------------------------------------
|
|  Get tool for testing
|
]]
function GetTestTool()
  local tool = Tool("Chamfer ball Nose", Tool.BALL_NOSE)
  tool.InMM = false
  tool.ToolDia = 0.125
  tool.Stepover = 0.2*tool.ToolDia
  tool.Stepdown = 0.125
  return tool
end
--[[  -------------- GetSelectedContours --------------------------------------------------
|
|  Get group of selected contours
|
]]
function GetSelectedContours(job)
  local selection_list = job.Selection
  local contour_group = ContourGroup(true)
  local pos = selection_list:GetHeadPosition()
  local cad_obj
  while pos ~= nil do
    cad_obj, pos = selection_list:GetNext(pos)
    local cad_contour = CastCadObjectToCadContour(cad_obj)
    local contour = cad_contour:GetContour()
    contour_group:AddTail(contour:Clone())
  end
  return contour_group
end
--[[  -------------- DisplayDialog --------------------------------------------------
|
|  Display the dialog
|
]]
function DisplayDialog( script_path, options )
  local html_path = "file:" .. script_path .. "\\" .. g_html_file
  local dialog = HTML_Dialog(false,
    html_path,
    options.windowWidth,
    options.windowHeight,
    g_title)
  -- Add fields to the dialog
  dialog:AddLabelField("GadgetTitle", g_title)
  dialog:AddLabelField("GadgetVersion", g_version)
  dialog:AddDoubleField("StartDepth", options.start_depth)
  dialog:AddDoubleField("Radius", options.radius)
  dialog:AddRadioGroup("ChamferType", 1)
  -- Add toolpath button
  dialog:AddLabelField("ToolNameField", "")
  dialog:AddToolPicker("ToolChooseButton", "ToolNameField", options.default_toolid)
  dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
  dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.BALL_NOSE)
  -- Add toolpath name field
  dialog:AddTextField("ToolpathNameField", options.toolpath_name)
  -- Add units fields
  local units_string = "Inches"
  if options.in_mm then
    units_string  = "MM"
  end
  dialog:AddLabelField("UnitsLabel1", units_string)
  dialog:AddLabelField("UnitsLabel2", units_string)
  -- Display the dialog
  local success = dialog:ShowDialog()
  if not success then
    return false
  end
  -- Read back from the html form
  options.tool = dialog:GetTool("ToolChooseButton")
  if options.tool == nil then
    DisplayMessageBox("No Tool Selected.")
    return false
  end
  -- Make sure that the start depth is positive
  options.start_depth = dialog:GetDoubleField("StartDepth")
  if (options.start_depth < 0) then
    DisplayMessageBox("Start depth must be positive")
    return -1
  end
  -- Make sure that cut depth is positive
  options.radius = dialog:GetDoubleField("Radius")
  if (options.radius < 0) then
    DisplayMessageBox("Cut depth must be positive")
    return -1
  end
  options.chamfer_in = g_outside_of_contour
  local ChamferType = dialog:GetRadioIndex("ChamferType")
  -- Get the toolpath name
  options.toolpath_name = dialog:GetTextField("ToolpathNameField")
  if (options.toolpath_name == "") then
    DisplayMessageBox("You must specify a toolpath name")
    return -1
  end
  options.windowWidth = dialog.WindowWidth
  options.windowHeight = dialog.WindowHeight
  return true
end


function SaveDefaults(options)
  local registry = Registry("ChamferRadiusGadget")
  registry:SetString("ToolpathName", options.toolpath_name)
  registry:SetDouble("Depth", options.depth)
  registry:SetDouble("StartDepth", options.start_depth)
  registry:SetDouble("Radius", options.radius)
  registry:SetString("ToolName", options.tool.Name);
  registry:SetInt("WindowWidth", options.windowWidth);
  registry:SetInt("WindowHeight", options.windowHeight);
end
function LoadDefaults(options)
  local registry = Registry("ChamferRadiusGadget")
  options.toolpath_name = registry:GetString("ToolpathName", "Radius Chamfer")
  options.depth = registry:GetDouble("Depth", .125)
  options.start_depth  = registry:GetDouble("StartDepth", 0)
  options.radius = registry:GetDouble("Radius", .125)
  --options.default_toolname = registry:GetString("ToolName", "")
  options.default_toolid = ToolDBId("ChamferRadiusGadget", "")
  options.windowWidth = registry:GetInt("WindowWidth", g_width);
  options.windowHeight = registry:GetInt("WindowHeight", g_height);
end
--[[  -------------- Round --------------------------------------------------
|
|  ROUND FUNCTION -- LUA does not provide a math function for rounding
|  This one is very versatile, feed in the number and decide on the number of
|  decimal points via the precision entry
]]

function round(what, precision)
  return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end
-- currently not used
function adjustFloat(value)									-- result has 4 decimals
  if value then
    return tonumber(string.format("%.4f", value))
  else
    return nil
  end
end
function DebugMessage(message)
  if g_debug then
    DisplayMessageBox(message)
  end
end
-- Callbacks


function OnLuaButton_XXXX(button_name, dialog)

  local chamfer_type_index = dialog:GetRadioIndex("ChamferType")
  dialog:UpdateRadioIndex("ChamferType",chamfer_type_index)
  g_outside_of_contour = false
  if chamfer_type_index == 1 then
    g_outside_of_contour = true
  end

  return true;
end
