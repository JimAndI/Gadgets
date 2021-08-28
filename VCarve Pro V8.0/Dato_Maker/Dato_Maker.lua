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

-- Additions by Adrian Matthews to save each sheets' toolpath

require "strict"

g_version     = "1.2"
g_title       = "Apply Template To All Sheets"
g_gadget_name = "ApplyTemplateToAllSheets"

g_default_window_width  = 800
g_default_window_height = 600

g_options =
   {
   -- Template options
   templatePath        = "",
   -- Window options
   windowWidth         = g_default_window_width,
   windowHeight        = g_default_window_height,
   postOutputFolder    = "",
   autoSaveToolpaths   = false
   }


--[[  -------------- SaveDefaults --------------------------------------------------
|
|  Save gadget options to the registry
|  Parameters:
|     options           -- The set of options for the gadget
|
]]
function SaveDefaults(options)

   local registry = Registry(g_gadget_name)

   registry:SetString("templatePath",  options.templatePath)
   registry:SetString("postOutputFolder", options.postOutputFolder)

   -- Save options
   registry:SetInt("WindowWidth", options.windowWidth)
   registry:SetInt("WindowHeight", options.windowHeight)
   registry:SetBool("autoSaveToolpaths", options.autoSaveToolpaths)

end

--[[  -------------- LoadDefaults --------------------------------------------------
|
|  Load the gadget options from the registry
|  Parameters:
|     options           -- The set of options for the gadget
|
]]
function LoadDefaults(options)

   local registry = Registry(g_gadget_name)

   options.templatePath = registry:GetString("templatePath", options.templatePath)
   options.postOutputFolder = registry:GetString("postOutputFolder", options.postOutputFolder)
   local window_width  = registry:GetInt("WindowWidth",  options.windowWidth)
   local window_height = registry:GetInt("WindowHeight", options.windowHeight)

   -- Check the window dimensions
   if window_width < 0 then
      window_width = options.windowWidth
   end
   if window_height < 0 then
      window_height = options.windowHeight
   end

   options.windowWidth  = window_width
   options.windowHeight = window_height

   options.autoSaveToolpaths = registry:GetBool("autoSaveToolpaths", options.autoSaveToolpaths)
end

--[[  -------------- UpdateOptionsFromDialog --------------------------------------------------
|
|  Updates our options from the dialog
|  Parameters:
|     dialog            -- The dialog to update the options from
|     options           -- The set of options for the gadget
|
]]
function UpdateOptionsFromDialog(dialog, options)

   -- Update the window dimensions - this only works for dialogs with an OK button in VCP 7.012 and Aspire 4.012 and earlier
   options.windowWidth  = dialog.WindowWidth
   options.windowHeight = dialog.WindowHeight

   local template_path = dialog:GetLabelField("TemplateFileNameLabel")
   if template_path == "" then
      MessageBox("No template file selected!");
      return false
   end

   options.templatePath = template_path;

   g_options.autoSaveToolpaths = dialog:GetCheckBox("SaveToolpathsCheck")
   
   local postOutputFolder = dialog:GetTextField("PostOutputFolderEdit")
   if postOutputFolder == "" then
      MessageBox("No toolpath output folder set!");
      return false
   end

   options.postOutputFolder = postOutputFolder

   -- Update successful
   return true

end

--[[  ------------------------ DisplayDialog --------------------------------------------------
|
|  Display dialog we use to select toolpath template etc
|
]]
function DisplayDialog(script_path)

   local script_html = "file:" .. script_path .. "\\Apply_Template_To_All_Sheets.htm"
    local dialog = HTML_Dialog(false, script_html, g_options.windowWidth, g_options.windowHeight, g_title)

   -- Standard title and version fields
   dialog:AddLabelField("GadgetTitle", g_title)
   dialog:AddLabelField("GadgetVersion", g_version)

    -- Label used to display path to template file
    dialog:AddLabelField("TemplateFileNameLabel", g_options.templatePath);
    dialog:AddFilePicker(true, "ChooseTemplateFileButton", "TemplateFileNameLabel", false);

    -- Controls for toolpath output
    dialog:AddCheckBox("SaveToolpathsCheck", g_options.autoSaveToolpaths)
    dialog:AddTextField("PostOutputFolderEdit", g_options.postOutputFolder)
    dialog:AddDirectoryPicker("ChooseDirButton", "PostOutputFolderEdit", true)

    -- populate the drop down list with the list of posts in the program
    PopulatePostDropDownList(dialog, "PostNameSelector", "")

    -- Show the dialog
   if not dialog:ShowDialog() then
      return false
   end

   -- Update the options from this dialog
   UpdateOptionsFromDialog(dialog, g_options)

    -- Process our toolpaths
   ProcessTemplate(dialog)

   -- Save values as defaults for next time
   SaveDefaults(g_options);

   return true

end

--[[  ------------------------ OnLuaButton_ChooseTemplateFileButton --------------------------------------------------
|
|  Choose a toolpath template file
|
]]
function OnLuaButton_ChooseTemplateFileButton(dialog)

   local file_dialog = FileDialog()
   if not file_dialog:FileOpen(
                              "ToolpathTemplate",
                              g_options.templatePath,
                              "Toolpath Templates (*.ToolpathTemplate)|*.ToolpathTemplate|"
                              ) then
       MessageBox("No template to use selected")
       return false
    end

   g_options.templatePath = file_dialog.PathName
   dialog:UpdateLabelField("TemplateFileNameLabel", g_options.templatePath);

   return true
end

--[[  ------------------------ OnLuaButton_SaveToolpathsCheck --------------------------------------------------
|
|  Called when user toggles saveing toolpaths check - we pick up the value when we close form
|
]]
function OnLuaButton_SaveToolpathsCheck(dialog)
   return true
end
--[[  ------------------------ RenameToolpathsForSheet --------------------------------------------------
|
|  Renames all the toolpaths loaded from a template for the current sheet. Each toolpath is prefixed with "Sn-"
|  where 'n' = the sheet number. This function also returns the id of the toolpaths so they can be calculated
|
]]
function RenameToolpathsForSheet(sheet_index, sheet_toolpath_start_index, sheet_toolpath_ids, toolpath_manager)

   -- skip over any toolpaths from previous sheets
   local toolpath_index = 0
   local toolpath = nil

   local pos = toolpath_manager:GetHeadPosition()
   while (pos ~= nil) and (toolpath_index < sheet_toolpath_start_index) do
        toolpath, pos = toolpath_manager:GetNext(pos)
      toolpath_index = toolpath_index + 1
   end
   -- we should now be pointing at the first toolpath associated with template for this sheet ...
   while (pos ~= nil) do
      toolpath, pos = toolpath_manager:GetNext(pos)
      local new_name = "S" .. sheet_index .. "-" .. toolpath.Name
      toolpath.Name = new_name
      toolpath_manager:ToolpathModified(toolpath)
      table.insert(sheet_toolpath_ids, toolpath.Id)
   end

   return true

end


--[[  ------------------------ DoAllToolpathsUseSameTool --------------------------------------------------
|
| Check if all the toolpaths in the passed list use the same tool. If they do, we can save all the 
| toolpaths to the same file, regardles of whether the post supports toolchanging. If the toolpaths
| use different tools and the post does not support tool changing, the toolpaths will need to be saved individually
|
]]
function DoAllToolpathsUseSameTool(sheet_toolpath_ids, toolpath_manager)

   local tool = nil
	
	for i,toolpath_id in ipairs(sheet_toolpath_ids) do
		local pos = toolpath_manager:Find(toolpath_id)
		if pos == nil then
		   MessageBox("Failed to find toolpath " .. i )
		   return false
		end
		local toolpath = toolpath_manager:GetAt(pos)
		-- do we have an existing tool to check against?
		if tool == nil then
		   -- no this is first toolpath - save a copy of tool to check against
		   tool = toolpath.Tool
		else
		   -- check if this tool is compatible with previous tools
		   if not tool:IsCompatibleTool(toolpath.Tool) then
		      return false  -- we have a mixture of tools 
		   end 	  
		end
	end  
	  
   return true
end

--[[  ------------------------ CheckDifferentToolsHaveUniqueToolNumbers --------------------------------------------------
|
| Check if all the toolpaths in the passed list which use a different tool have a unique tool number
|
]]
function CheckDifferentToolsHaveUniqueToolNumbers(toolpath_ids, toolpath_manager)

   local tools = {}
   local tool_count = 0
	
	for i,toolpath_id in ipairs(toolpath_ids) do
		local pos = toolpath_manager:Find(toolpath_id)
		if pos == nil then
		   MessageBox("Failed to find toolpath " .. i )
		   return false
		end
		local toolpath = toolpath_manager:GetAt(pos)
		-- do we have one or more tools to check against?
		if tool_count > 1 then
		   -- Yes - check if this tool is compatible with previous tools
         for i = 1, tool_count do
            if not toolpath.Tool:IsCompatibleTool(tools[i]) then
               -- this is a different tool, check tools have different tool numbers ...
               if toolpath.Tool.ToolNumber == tools[i].ToolNumber then
                  -- Error! We have two toolpaths with tools with the same tool number but different geometry,
                  -- if thess toolpaths are to be saved with a toolchanger post processor this is invalid!
                  return false
               end
            end
         end           
		end
      -- add tool to our list 
  	   tool_count = tool_count + 1
      tools[tool_count] = toolpath.Tool
	end  
	  
   return true
end

--[[  ------------------------ SaveSingleToolpath --------------------------------------------------
|
| Check if all the toolpaths in the passed list use the same tool. If they do, we can save all the 
| toolpaths to the same file, regardles of whether the post supports toolchanging. If the toolpaths
| use different tools and the post does not support tool changing, the toolpaths will need to be saved individually
|
]]
function SaveSingleToolpath(toolpath, output_folder, post, sheet_msg_list)
   
   local toolpath_saver = ToolpathSaver();
   toolpath_saver:AddToolpath(toolpath)

   local toolpath_file = toolpath.Name .. "." .. post.Extension
   local output_path = output_folder .. "\\" .. toolpath_file

   sheet_msg_list = sheet_msg_list .. "<tr><td></td><td>" .. toolpath.Name .. "</td><td>"

   if toolpath_saver:SaveToolpaths(post, output_path, false) then
      sheet_msg_list = sheet_msg_list .. "&nbsp;&nbsp;&nbsp;SAVED"
   else
      sheet_msg_list = sheet_msg_list .. "&nbsp;&nbsp;&nbsp;SAVE FAILED"
   end
   sheet_msg_list = sheet_msg_list .. "</td></tr>"
    
   return sheet_msg_list

end

--[[  ------------------------ LoadTemplateAndCalculateForSheet --------------------------------------------------
|
|  Load the passed toolpath template, and calculate its toolpaths for the passed sheet
|
]]
function LoadTemplateAndCalculateForSheet(post, dialog, sheet_index, toolpath_template, toolpath_manager, save_toolpaths, toolpath_saver, job, message_array)

   -- save the number of toolpaths already loaded - our toolpaths from template will be loaded after these
   local sheet_toolpath_start_index = toolpath_manager.Count

   -- load the toolpath template for this sheet
   if not toolpath_manager:LoadToolpathTemplate(toolpath_template) then
      MessageBox("Failed to load template " .. toolpath_template)
      return false
   end

   -- rename the toolpaths just loaded to have the sheet number as a prefix ...
   local sheet_toolpath_ids = {}

   RenameToolpathsForSheet(sheet_index, sheet_toolpath_start_index, sheet_toolpath_ids, toolpath_manager)

    -- Check if all the toolpaths use the same tool ...
   local all_toolpaths_use_same_tool = DoAllToolpathsUseSameTool(sheet_toolpath_ids, toolpath_manager)
   local can_save_to_single_file = all_toolpaths_use_same_tool or post.SupportsToolchange
   
   -- If we are saving the toolpaths AND we are usign a toolchanging post, check all toolpaths with
   -- different tool geometry are using different tool numbers - only check for first sheet ...
   if save_toolpaths and post.SupportsToolchange and sheet_index == 1 then
      if not CheckDifferentToolsHaveUniqueToolNumbers(sheet_toolpath_ids, toolpath_manager) then
         MessageBox("ERROR:\n" ..
                    "Some of the tools in the template have the\n" ..
                    "same tool number but different types/geometry.\n\n" ..
                    "To output the toolpaths using a tool changing post processor\n" ..
                    "each tool must have a unique tool number")
         return false           
      end
   end
               
   -- now calculate each toolpath ...
   local sheet_msg_list = ""

   for i,toolpath_id in ipairs(sheet_toolpath_ids) do
      local pos = toolpath_manager:Find(toolpath_id)
      if pos == nil then
         MessageBox("Failed to find toolpath " .. i .. " with id for sheet " .. sheet_index .. " after rename")
         return false
      end
      local toolpath = toolpath_manager:GetAt(pos)
      sheet_msg_list = sheet_msg_list .. "<tr><td></td><td>" .. toolpath.Name .. "</td><td>"
      
      -- when we recalculate a toolpath it is recreated but with the same id - save the id here
      -- so we can find the toolpath again after it is recalculated
      local orig_id = luaUUID()
      orig_id:SetId(toolpath_id)
  
      if toolpath_manager:RecalculateToolpath(toolpath) then
         sheet_msg_list = sheet_msg_list .. "&nbsp;&nbsp;&nbsp;Calculated O.K"
         -- MessageBox("Finding recalculated toolpath with same id - " .. orig_id:AsString())
         local calced_pos = toolpath_manager:Find(orig_id.RawId)
         if calced_pos == nil then
            MessageBox("Failed to find toolpath " .. i .. " with id for sheet " .. sheet_index .. " after calculation")
            return false
         else
            local toolpath = toolpath_manager:GetAt(calced_pos)
            if can_save_to_single_file then
               toolpath_saver:AddToolpath(toolpath)
            else
               -- this file needs to be saved with its own name as post doesnt support toolchanging
               if save_toolpaths then
                  sheet_msg_list = SaveSingleToolpath(toolpath, g_options.postOutputFolder, post, sheet_msg_list)
               end   
            end            
         end
      else
         sheet_msg_list = sheet_msg_list .. "&nbsp;&nbsp;&nbsp;FAILED"
         toolpath_manager:DeleteToolpathWithId(toolpath_id)
      end
      sheet_msg_list = sheet_msg_list .. "</td></tr>"
   end
   
    
   -- Save toolpaths for this sheet to the output folder, IF they all use the same tool or the post supported tool changing...
   if save_toolpaths and can_save_to_single_file then
   
      local toolpath_file = "Sheet" .. sheet_index .. "." .. post.Extension
      local output_path = g_options.postOutputFolder .. "\\" .. toolpath_file
      local toolpath_count = toolpath_saver.NumberOfToolpaths

      sheet_msg_list = sheet_msg_list .. "<tr><td></td><td>" .. toolpath_file .. " (" .. toolpath_count .." toolpaths)</td><td>"

      if toolpath_count > 0 then
         local success = toolpath_saver:SaveToolpaths(post, output_path, false)
         if success then
            sheet_msg_list = sheet_msg_list .. "&nbsp;&nbsp;&nbsp;SAVED OK"
         else
            sheet_msg_list = sheet_msg_list .. "&nbsp;&nbsp;&nbsp;FAILED"
         end
      else
         sheet_msg_list = sheet_msg_list .. "no toolpaths saved"
      end
      sheet_msg_list = sheet_msg_list .. "</td></tr>"
   end
   
   table.insert(message_array, sheet_msg_list)
   return true

end

--[[  ------------------------ OnLuaButton_ApplyButton --------------------------------------------------
|
|  Apply Button handler
|
]]
function OnLuaButton_ApplyButton(dialog)

   ProcessTemplate(dialog)
   return true

end

--[[  ------------------------ ProcessTemplate --------------------------------------------------
|
|  Process the toolpath template for each sheet
|
]]
function ProcessTemplate(dialog)

   -- Get the current job
   local job = VectricJob()
   if not job.Exists then
      return true
   end

   -- Update the options from the dialog
   if not UpdateOptionsFromDialog(dialog, g_options) then
      return true
   end

   -- Create our toolpaths ...
   local toolpath_manager = ToolpathManager()

    -- get initial toolpath count - we will ignore these ...
   local initial_toolpath_count = toolpath_manager.Count
   local layer_manager = job.LayerManager

   -- get sheet count - note sheet 0 the default sheet counts as one sheet
   local num_sheets = layer_manager.NumberOfSheets
   -- get current active sheet index
   local orig_active_sheet_index = layer_manager.ActiveSheetIndex

   -- we need 1 or more sheets for this gadget ....
   if num_sheets < 2 then
      MessageBox("This gadget only works with 1 or more sheets")
      return false
   end

   -- get post processor to use for saving ...
   local post_name = dialog:GetDropDownListValue("PostNameSelector");
   local toolpath_saver = ToolpathSaver();
   local post = toolpath_saver:GetPostWithName(post_name)
   if post == nil then
      MessageBox("Failed to load Post Processor with name " .. post_name)
      return false
   end

   local sheet_index
   local message_array = {}
   for sheet_index = 1, num_sheets - 1 do
      layer_manager.ActiveSheetIndex = sheet_index
      job:Refresh2DView();
      toolpath_saver:ClearToolpathList()
      -- load the toolpath template for this sheet
      if not LoadTemplateAndCalculateForSheet(
									         post,
                                    dialog,
                                    sheet_index,
                                    g_options.templatePath,
                                    toolpath_manager,
                                    g_options.autoSaveToolpaths,
                                    toolpath_saver,
                                    job,
                                    message_array,
                                    toolpath_saver
									         ) then
         MessageBox("Failed to load toolpath template for sheet " .. sheet_index)
         break
      end

   end

   -- display messages ...
   DisplayStatusReport(message_array, job, g_options.templatePath)

   -- set active sheet to last sheet

   layer_manager.ActiveSheetIndex = orig_active_sheet_index

   job:Refresh2DView();



   return true

end

--[[  ------------------------ DisplayStatusReport --------------------------------------------------
|
|  Display a status report for toolpaths on each sheet
|
]]
function DisplayStatusReport(message_array, job, template_path)

  local page_html = g_ReportHeaderHtml

   page_html = page_html .. "<p><b>Job: </b>" .. job.Name .. "</p>"
   page_html = page_html .. "<p><b>Template: </b>" .. template_path .. "</p>"

   page_html = page_html .. "<table>"

   for i,sheet_msgs in ipairs(message_array) do
      page_html = page_html .. "<tr><td colspan=3><b>Sheet " .. i .. "</b></td></tr>"
      page_html = page_html .. sheet_msgs
      page_html = page_html .. "</p>"
   end
   page_html = page_html .. "</table>"

   page_html = page_html .. g_ReportFooterHtml

   local dialog = HTML_Dialog(true, page_html, g_options.windowWidth, g_options.windowHeight, g_title .. " - Status Report")

   dialog:ShowDialog()

   return true

end

--[[  --- PopulatePostDropDownList --------------------------------------------------
|
| Populate a drop down list selector with the list of post processors
|
|  Parameters:
|     dialog               - Dialog ofr post-processor list
|     drop_down_html_id    - id of html element for drop down list selector
|     default_post_name    - name of default pos - if nil use default from program

]]
function PopulatePostDropDownList(dialog, drop_down_html_id, default_post)

    -- Create object used to access post processors (and save toolpaths)
   local toolpath_saver = ToolpathSaver()

   -- if user hasn't supplied a default post name use the programs ...
   if (default_post == nil) or (default_post == "") then
      local default_pp = toolpath_saver.DefaultPost
      if default_pp ~= nil then
          default_post = default_pp.Name
      else
         default_post = ""
      end
    end

   -- link up to the <select> control on the dialog
   dialog:AddDropDownList(drop_down_html_id,default_post)

   -- and add our posts as options
   local num_posts = toolpath_saver:GetNumPosts()
   local post_index = 0

   while post_index < num_posts do
      local post = toolpath_saver:GetPostAtIndex(post_index)
      dialog:AddDropDownListValue(drop_down_html_id, post.Name)
      post_index = post_index + 1
   end

end


--[[  ------------------------ main --------------------------------------------------
|
|  Entry point for script
|
]]
function main(script_path)

    -- Check we have a job loaded
    local job = VectricJob()

    if not job.Exists then
       DisplayMessageBox("No job open.")
       return false
    end

   -- Load our default values from the registry
   LoadDefaults(g_options);

   -- Display the dialog
   DisplayDialog(script_path)

   return true
end

g_ReportHeaderHtml = [[
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
    "http://www.w3.org/TR/html4/strict.dtd">

<html>
<head>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">

<style type="text/css">
html {
   overflow: auto;
}
body {
   background-color: #F0F0F0;
}
body, td, th {
   font-family: Arial, Helvetica, sans-serif;
   font-size: 12px;
}
.FormButton {
   font-weight: bold;
   width: 100%;
   font-family: Arial, Helvetica, sans-serif;
   font-size: 12px;
}
.h1 {
   font-size: 14px;
   font-weight: bold;
}
.h2 {
   font-size: 10px;
   font-weight: bold;
}
.ToolNameLabel {
   color: #555;
}

.ParameterDescription {
   color: #555;
}
.Warning {
   color: #955;
   font-size: 20px;
   font-weight: bold;
   text-align:center
}

</style>
<title>Vectric Gadget</title>
</head>
<body bgcolor="#efefef">
]]


g_ReportFooterHtml = [[
<table border="0" width="100%">
   <tr>
      <td style="width: 40%">&nbsp;</td>
      <td align = "center"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Close"></td>
      <td style="width: 40%">&nbsp;</td>
   </tr>
</table>
</body>
</html>
]]
