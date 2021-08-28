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

-- require "strict"
require("mobdebug").start()
--[[  ---- Display Dialog Data ---------------------------------------------  
|
| Display data from passed dialog
|
]]

g_default_tool_id = ToolDBId()
g_default_tool_id:LoadDefaults("MyToolpath", "")

function DisplayDialogData(dialog)

    local machine_name        = dialog:GetTextField("MachineName")
    local machine_cost        = dialog:GetDoubleField("MachineCost")
    local machine_count       = dialog:GetIntegerField("MachineCount")
    local do_preview          = dialog:GetCheckBox("CreatePreviewCheck")
    local machine_type        = dialog:GetRadioIndex("MachineType")
    local machine_colour      = dialog:GetRadioIndex("MachineColour")
    local directory_name      = dialog:GetTextField("DirNameEdit");
	local new_file_name       = dialog:GetTextField("FileNameEdit");
	local existing_file_name  = dialog:GetLabelField("FileNameLabel");
	local list_selection      = dialog:GetDropDownListValue("DropDownList");
	
    local preview_text = "Do preview = false"
    if do_preview then
       preview_text = "Do preview = true"
    end
    
    DisplayMessageBox(
                     "Machine name = " .. machine_name .. "\n" .. 
                     "Machine cost = " .. machine_cost .. "\n" .. 
                     "Number of machines = " .. machine_count .. "\n" .. 
                     preview_text .. "\n" .. 
                     "Selected Machine Type = " .. machine_type .. "\n" ..
                     "Selected Machine Colour = " .. machine_colour  .. "\n" ..
					 "Selected Directory = " .. directory_name   .. "\n" ..
					 "Selected New File = " .. new_file_name   .. "\n" ..
					 "Selected Existing File = " .. existing_file_name .. "\n" ..
					 "Selection from list = " .. list_selection
                     )

end

function OnDirectoryPicker_ChooseDirButton1(dialog)

  local dir_name = dialog:GetTextField("DirNameEdit");
  MessageBox("User picked directory ...\n" .. dir_name)
  
  return true
end

function OnDirectoryPicker_ChooseDirButton2(dialog)

  local dir_name = dialog:GetLabelField("DirNameLabel");
  MessageBox("User picked directory ...\n" .. dir_name)
  
  return true
end
function OnFilePicker_ChooseFileButton1(dialog)

  local file_name = dialog:GetTextField("FileNameEdit");
  MessageBox("User picked file ...\n" .. file_name)
  
  return true
end

function OnFilePicker_ChooseFileButton2(dialog)

  local file_name = dialog:GetLabelField("FileNameLabel");
  MessageBox("User picked file ...\n" .. file_name)
  
  return true
end

function OnToolPicker_ToolChooseButton(dialog)

  local tool_name = dialog:GetLabelField("ToolNameLabel");
  
  local tool = dialog:GetTool("ToolChooseButton")
  if tool == nil then
		MessageBox("No tool selected!")
		return true
  end
  
  MessageBox("User picked tool ...\n" .. tool_name .. " Diameter = " .. tool.ToolDia)
  
  return true
end

function OnLuaButton_XXXX(button_name, dialog)

   MessageBox("User pressed a LuaButton with out an explicit handler - " .. button_name)
   
   return true;
end

function OnLuaButton_TestButton1(dialog)

   -- MessageBox("User pressed TestButton1")
   
   -- DisplayDialogData(dialog)
   
   local press_count = dialog:GetLabelField("ButtonTestLabel");
   local new_press_count = tonumber(press_count) + 1
   dialog:UpdateLabelField("ButtonTestLabel", tostring(new_press_count));
   
   local cur_name = dialog:GetTextField("MachineName");
   dialog:UpdateTextField("MachineName", cur_name .. ":" ..tostring(new_press_count));

   local cur_cost = dialog:GetDoubleField("MachineCost");
   dialog:UpdateDoubleField("MachineCost", cur_cost * 1.1);

   local cur_num_machines = dialog:GetIntegerField("MachineCount");
   dialog:UpdateIntegerField("MachineCount", cur_num_machines + 1);

   local do_preview = dialog:GetCheckBox("CreatePreviewCheck")   
   dialog:UpdateCheckBox("CreatePreviewCheck", not do_preview);

   local machine_type_index = dialog:GetRadioIndex("MachineType")
   machine_type_index = machine_type_index + 1
   if machine_type_index > 3 then 
      machine_type_index = 1
   end  
   dialog:UpdateRadioIndex("MachineType", machine_type_index)
   
   dialog:SetInnerHtml("MachineNameTD", "<b>Name</b> - updated via Lua") 
   
   return true;
   
end

--[[  -------------- main --------------------------------------------------  
|
|  Entry point for script
|
]]

function main(script_path)


    
    -- DisplayMessageBox("Script Path = " .. script_path)
    
    local html_path = "file:" .. script_path .. "\\Dialog_Simple_Example.htm"
    local dialog = HTML_Dialog(false, html_path, 500, 780, "Dialog Simple Example")
    
    dialog:AddLabelField("WelcomeText", "Welcome to my <b>Lua</b> HTML dialog")
    dialog:AddTextField("MachineName", "Rosy")
    dialog:AddDoubleField("MachineCost", 6495.12)
    dialog:AddIntegerField("MachineCount", 1)
    dialog:AddCheckBox("CreatePreviewCheck", false)
    dialog:AddRadioGroup("MachineType", 2)
    dialog:AddRadioGroup("MachineColour", 1)
    
    -- two controls used to pick a directory
    dialog:AddTextField("DirNameEdit", "c:\\temp");
    dialog:AddDirectoryPicker("ChooseDirButton1", "DirNameEdit", true);

    dialog:AddLabelField("DirNameLabel", "c:\\");
    dialog:AddDirectoryPicker("ChooseDirButton2", "DirNameLabel", false);

    -- two controls used to pick a file
	
	-- first picker picks a file to SAVE to, can be a new file - and uses an edit box
    dialog:AddTextField("FileNameEdit", "c:\\temp\\temp.txt");
    dialog:AddFilePicker(false, "ChooseFileButton1", "FileNameEdit", true);

	-- second picker picks an EXISTING file to OPEN - and uses a label field in this case
    dialog:AddLabelField("FileNameLabel", "c:\\temp");
    dialog:AddFilePicker(true, "ChooseFileButton2", "FileNameLabel", false);

	-- Text field used to demonstrate event handling
    dialog:AddLabelField("ButtonTestLabel", "0");

    -- Tool picker (new)
    dialog:AddLabelField("ToolNameLabel", "No Tool Selected");
    dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", g_default_tool_id)
    
    --[[ Tool picker  (old)
    dialog:AddLabelField("ToolNameLabel", "");
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
    ]]
    -- Tool Editor
	dialog:AddToolEditor("ToolEditButton", "ToolChooseButton")
	
	-- Drop Down List
    dialog:AddDropDownList("DropDownList","Aspire")
    dialog:AddDropDownListValue("DropDownList", "Cut2D")
    dialog:AddDropDownListValue("DropDownList", "VCarve Pro")
    dialog:AddDropDownListValue("DropDownList", "Aspire")
    dialog:AddDropDownListValue("DropDownList", "Cut3D")
    dialog:AddDropDownListValue("DropDownList", "PhotoVCarve")
    
    if  not dialog:ShowDialog() then
       -- DisplayMessageBox("User canceled dialog")
       return false
    end   

   DisplayDialogData(dialog)
    
    return true

end    