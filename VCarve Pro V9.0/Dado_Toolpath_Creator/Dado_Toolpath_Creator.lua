-- VECTRIC LUA SCRIPT
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

--[[
Create Dado Toolpaths by Adrian Matthews
from an original idea by Tim Merrill
very heavily based on code from Brian Moran
]]

g_dado_depth = 0.25
g_offset = 0
g_allowance = ""
g_layer_name = "dadoes"
g_toolpath_name = "dado toolpath"
g_tool = nil
g_default_tool_name = ""
g_create_toolpath = true
g_title = "Dado Toolpath Creator"
g_version = "1.1 by Adrian Matthews"

function CreateDadoCentreLine(dummy_dado)

	local end_point
	local start_point
	local mid_x
	local mid_y

--[[
First work out which direction is the long direction
assume that the longest direction is the one on which the dado
will run.
]]
	if dummy_dado.MaxLength == dummy_dado.XLength then
		mid_y = dummy_dado.Centre.y
		start_point = Point2D(dummy_dado.MinX - g_offset, mid_y)
		end_point = Point2D(dummy_dado.MaxX + g_offset, mid_y)
	else
		mid_x = dummy_dado.Centre.x
		start_point = Point2D(mid_x, dummy_dado.MinY - g_offset)
		end_point = Point2D(mid_x, dummy_dado.MaxY + g_offset)
	end

	local contour = Contour(0.0)
	contour:AppendPoint(start_point)
	contour:LineTo(end_point)
	contour:LineTo(start_point)

	return contour

end

function CreateDadoLines(job, selection)

	local dado_centre_line_coll = ContourGroup(true)
	local selection_pos = selection:GetHeadPosition()


	while selection_pos ~= nil do
	    local object
		object, selection_pos = selection:GetNext(selection_pos)

		local contour = object:GetContour()
		if contour == nil then
			if (object.ClassName == "vcCadObjectGroup") then
				MessageBox("Grouped vectors cannot be used - please ungroup")
			end
		else
			local bounds = contour.BoundingBox2D
			local dado_centre_line = CreateDadoCentreLine(bounds)

			if not (dado_centre_line == nil) then
				dado_centre_line_coll:AddTail(dado_centre_line)
			end
		end
	end

-- when we reach here we have processed all the selected vectors - have we created some dado centrelines?
   if dado_centre_line_coll.IsEmpty then
      MessageBox("No dadoes created for current vector selection")
      return false
   end

	selection:Clear()

	local layer_manager = job.LayerManager
	local layer =  job.LayerManager:GetLayerWithName(g_layer_name)

		if layer == nil then
			DisplayMessageBox("Unable to create layer - " .. g_layer_name)
			return false
		end

		local cad_object = CreateCadGroup(dado_centre_line_coll);
		layer:AddObject(cad_object, true)
		selection:Add(cad_object,true,true)
		job:Refresh2DView()

return true

end

function CreateDadoToolpath()

   -- Create object used to set home position and safez gap above material surface
  local profile_data = ProfileParameterData()

  profile_data.StartDepth = 0
  profile_data.CutDepth = g_dado_depth
  profile_data.CutDirection = ProfileParameterData.CONVENTIONAL_DIRECTION
  profile_data.ProfileSide = ProfileParameterData.PROFILE_ON

	local ramping_data = RampingData()
	local lead_in_out_data = LeadInOutData()
	local pos_data = ToolpathPosData()
  local geometry_selector = GeometrySelector()

	local toolpath_manager = ToolpathManager()
	local toolpath = toolpath_manager:CreateProfilingToolpath(
                                              g_toolpath_name,
                                              g_tool,
                                              profile_data,
                                              ramping_data,
                                              lead_in_out_data,
                                              pos_data,
									                            geometry_selector,
                                              true,
                                              true
                                              )

   if toolpath == nil then
      MessageBox("Error creating toolpath")
      return false
   end

   return true
end

function LoadDialog(job, script_path, first_pass)

	local registry = Registry("DadoToolpath")

	if first_pass then
		g_dado_depth = registry:GetDouble("DadoDepth",              g_dado_depth)
		g_create_toolpath = registry:GetBool("CreateToolpath",      g_create_toolpath)
		g_layer_name = registry:GetString("LayerName",              g_layer_name)
		g_default_tool_name = registry:GetString("DefaultToolName", g_default_tool_name)
		g_toolpath_name = registry:GetString("ToolPathName",        g_toolpath_name)
		g_allowance = registry:GetString("Allowance",				g_allowance)
	end

	local html_path = "file:" .. script_path .. "\\Dado_Toolpath_Creator.htm"

	local dialog = HTML_Dialog(false, html_path, 500, 675, g_title)

	dialog:AddLabelField("GadgetVersion",                     g_version)
	dialog:AddTextField("Allowance",                          g_allowance)
	dialog:AddCheckBox("CreateToolpath",                      g_create_toolpath)
	dialog:AddDoubleField("DadoDepth",                        g_dado_depth)
	dialog:AddTextField("LayerName",                          g_layer_name)
	dialog:AddLabelField("ToolNameLabel",                     "No Tool Selected")
	dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", g_default_tool_name)
	dialog:AddToolPickerValidToolType("ToolChooseButton",     Tool.END_MILL)
	dialog:AddTextField("ToolPathName",                       g_toolpath_name)

	if not dialog:ShowDialog() then
		return false
		-- quit and return
	end

	local tool = dialog:GetTool("ToolChooseButton")
	if tool == nil then
		MessageBox("No tool selected!")
		return 2
		-- will return to display dialog
	end

	g_tool =			tool
	g_dado_depth =        dialog:GetDoubleField("DadoDepth")
	g_allowance =         dialog:GetTextField("Allowance")
	g_create_toolpath =   dialog:GetCheckBox("CreateToolpath")
	g_layer_name =        dialog:GetTextField("LayerName")
	g_default_tool_name = tool.Name

	local multiplier = 1
	if tool.InMM and job.InMM == false then
		multiplier = 0.0254
	end
	if tool.InMM == false and job.inMM then
		multiplier = 25.4
	end

	local numtest = tonumber(g_allowance)

	if numtest == nil then
		g_offset = (tool.ToolDia * multiplier) / 2
		g_allowance = ""
	else
		g_offset = numtest
	end

	g_toolpath_name = 	  dialog:GetTextField("ToolPathName")

	if string.len(g_toolpath_name) < 1 then
		MessageBox("A name must be entered for the toolpath")
		return 2
		-- will return to display dialog
	end

	registry:SetDouble("DadoDepth",         g_dado_depth)
	registry:SetString("Allowance",			g_allowance)
	registry:SetString("LayerName",         g_layer_name)
	registry:SetBool("CreateToolpath",      g_create_toolpath)
	registry:SetString("DefaultToolName",   g_default_tool_name)
	registry:SetString("ToolPathName",      g_toolpath_name)
	return true

end

function main(script_path)

	local first_pass = true

	local job = VectricJob()
	local selection = job.Selection

	if not job.Exists then
		MessageBox("No new or existing file loaded")
		return false
	end

	if selection.IsEmpty then
		MessageBox("Please select one or more rectangular vectors")
		return false
	end

	repeat
		local ret_value = LoadDialog(job, script_path, first_pass)
		if ret_value == false then
			return false
		end
		first_pass = false
	until ret_value == true

   if CreateDadoLines(job, selection) then
		if g_create_toolpath then
			if CreateDadoToolpath() then
			end
		end
	end

    return true

end
