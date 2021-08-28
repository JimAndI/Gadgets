-- VECTRIC LUA SCRIPT
-- Script to renumber all tools in toolpaths starting from user defined number (Must be >0)
-- by Gary Singer (DVE2000 on camheads.org and forum.vectric.com)
--
require "strict"

------------------------------
function WriteToolInfoToTextFile(crv_file_name, tool_list)

  local file_dialog = FileDialog()
  local file_name = crv_file_name .. " -- Tool Numbers"
  local file_types = "text (*.txt)|*.txt||"
  if not file_dialog:FileSave(".txt", file_name, file_types) then
    return
  end

  local file = io.open(file_dialog.PathName, "w")
  if file ~= nil then
    file:write(tool_list)
    io.close(file)
  end
end

------------------------------
function main(script_path)
  --  Starting default tool number
  local current_tool_number = 1 
  local window_width = 190
  local window_height = 210
  local save_file = true
  local version = 1.3
  local saved_version

  -- Check for the existence of a job
  local job = VectricJob()
  if not job.Exists then
    return false
  end

  local registry = Registry("Tool_Renumber")
   
  -- ---------------- Get default values from last run -------------------
  current_tool_number = registry:GetInt("Number", current_tool_number)
  window_width        = registry:GetInt("WindowWidth", window_width)
  window_height       = registry:GetInt("WindowHeight", window_height)
  save_file           = registry:GetBool("SaveFile", save_file)
  if not registry:DoubleExists("Version") then
    window_height = 210
  end
  version = registry:GetDouble("Version", version)
  
  --DisplayMessageBox(string.format("Window Width: %d Window Height: %d\n", window_width, window_height))
  
  local html_path = "file:" .. script_path .. "\\Tool_Renumber.htm"
  local dialog = HTML_Dialog(false, html_path, window_width, window_height, "Tool Renumber")
    
  dialog:AddIntegerField("Number", current_tool_number)
  dialog:AddCheckBox("SaveFile", save_file)

  if not dialog:ShowDialog() then
    return false -- User hit cancel
  end   
  
  current_tool_number = dialog:GetIntegerField("Number")
  save_file = dialog:GetCheckBox("SaveFile")

  if current_tool_number < 1 then
    DisplayMessageBox("Starting tool number has to be 1 or greater!!")
    return false
  end

  window_width = dialog.WindowWidth
  window_height = dialog.WindowHeight

  registry:SetDouble("Version", version)
  registry:SetInt("Number", current_tool_number) -- Set default for next time
  registry:SetInt("WindowWidth", window_width)
  registry:SetInt("WindowHeight", window_height)
  registry:SetBool("SaveFile", save_file)

  --------------------------------------------------------------------------------   
  local toolpath_manager = ToolpathManager()
  local pos = toolpath_manager:GetHeadPosition()
  local toolpath
  local tool
  local tools = {}
  local tool_list = ""
  local updated_tools = false
  local min_spindle_speed = -1
  local min_speed_tool_number
  local min_speed_tool_name
  
  
  -- Iterate through all the toolpaths
  while pos ~= nil do
    toolpath, pos = toolpath_manager:GetNext(pos)
    tool = toolpath.Tool
    if tools[tool.Name] == nil then
      if tool.ToolNumber ~= current_tool_number then
        updated_tools = true
      end
      tools[tool.Name] = current_tool_number
      tool_list = tool_list .. string.format("%2d : %s\n", current_tool_number, tool.Name)
      current_tool_number = current_tool_number + 1
    end
    if tool.ToolNumber ~= tools[tool.Name] then
       tool.ToolNumber = tools[tool.Name]
       updated_tools = true
    end
    --toolpath:ReplaceTool(tool)
    tool:UpdateParameters()
    toolpath_manager:ToolpathModified(toolpath)
    if min_spindle_speed < 0  or min_spindle_speed > tool.SpindleSpeed then
      min_spindle_speed = tool.SpindleSpeed
      min_speed_tool_number = tool.ToolNumber
      min_speed_tool_name = tool.Name
    end
  end
    if (updated_tools) then
      DisplayMessageBox("Tool numbers were updated!\n" .. tool_list .. string.format("\n\nMinimum Spindle Speed: %d rpm for %2d: %s \n", min_spindle_speed, min_speed_tool_number, min_speed_tool_name) )
    else
      DisplayMessageBox("Tool numbers were unchanged!" .. string.format("\n\nMinimum Spindle Speed: %2d rpm for %d: %s \n", min_spindle_speed, min_speed_tool_number, min_speed_tool_name) )
    end
    if (save_file) then
      WriteToolInfoToTextFile(job.Name, tool_list)
    end
  return true
 end


