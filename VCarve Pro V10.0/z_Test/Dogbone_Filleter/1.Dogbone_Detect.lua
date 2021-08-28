-- VECTRIC LUA SCRIPT
-- Copyright 2014 Vectric Ltd.

-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.


--require("mobdebug").start()

local str = debug.getinfo(1).source:sub(2)
local ustr = str:match("(.*\\)")
dofile(ustr .. "DBCore.lua.shared")


g_version = "1.1"
g_title = "Dogbone Detect Gadget"
g_width = 800
g_height = 600
g_html_file = "Dogbone_Detect.htm"

--require "strict"







--[[  -------------- main --------------------------------------------------  
|
| Entrance point for script
|
]]
function main(script_path)
  -- options

  local job = VectricJob()
  if not job.Exists then
    MessageBox("No job created, Please create a job, select your vectors and re-run the gadget")
    return false
  end

  if job.Selection.IsEmpty then
    DisplayMessageBox("You must select the vectors you want filleting.")
    return false
  end


  local options = {}
  options.tool_diam = 0.25
  options.inner_allowance = 0
  options.outer_allowance = 0
  options.marker_layer_name = "DogBoneMarkers"
  options.vector_layer_name = "FilletedContours"
  options.do_tbones = false
  options.WindowWidth = g_width
  options.WindowHeight = g_height

  LoadDefaults(options)

  local displayed_dialog = -1 
  while displayed_dialog == -1 do
    displayed_dialog = DisplayDialog(script_path, options)
  end

  if not displayed_dialog then
    return false
  end

  MarkDogBones(job, options)
  

  SaveDefaults(options)
  job:Refresh2DView()
  return true
end







--[[  -------------- DisplayDialog --------------------------------------------------  
|
| Display the dialog
|
]]
function DisplayDialog(script_path, options)
  local html_path = "file:" .. script_path .. "\\" .. g_html_file
  local dialog = HTML_Dialog(false, 
                             html_path, 
                             g_width, 
                             g_height,
                             g_title)

  -- Add fields to the dialog
  dialog:AddLabelField("GadgetTitle", g_title)
  dialog:AddLabelField("GadgetVersion", g_version)

  -- Add depth and angle fields
  dialog:AddDoubleField("ToolDiam", options.tool_diam)
  dialog:AddDoubleField("InnerAllowance", options.inner_allowance)
  dialog:AddDoubleField("OuterAllowance", options.outer_allowance)
  dialog:AddTextField("MarkerLayer", options.marker_layer_name)

  local fillet_index = 1
  if (options.do_tbones) then
    fillet_index = 2
  end
  dialog:AddRadioGroup("FilletType", fillet_index)



  -- Display the dialog
  local success = dialog:ShowDialog()

  if not success then 
    return false
  end

  -- Read back from the form
  options.tool_diam = dialog:GetDoubleField("ToolDiam")
  options.inner_allowance = dialog:GetDoubleField("InnerAllowance")
  options.outer_allowance = dialog:GetDoubleField("OuterAllowance")
  options.marker_layer_name = dialog:GetTextField("MarkerLayer")

  fillet_index = dialog:GetRadioIndex("FilletType")
  options.do_tbones = (fillet_index == 2)
  
  if options.tool_diam <= 0 then 
    DisplayMessageBox("Tool diameter must be positive")
    return -1
  end


  options.windowWidth  = dialog.WindowWidth
  options.windowHeight = dialog.WindowHeight
  

  return true
end


--[[  -------------- LoadDefaults --------------------------------------------------  
|
| Load defaults from registry
|
]]
function LoadDefaults(options)
  local registry = Registry("DogboneGadget")
  options.tool_diam = registry:GetDouble("ToolDiam", 0.25)
  options.inner_allowance = registry:GetDouble("InnerAllowance", 0)
  options.outer_allowance = registry:GetDouble("OuterAllowance", 0)
  options.marker_layer_name = registry:GetString("MarkerLayer", "DogBoneMarkers")
end


--[[  -------------- SaveDefaults --------------------------------------------------  
|
| Save defaults to the registry
|
]]
function SaveDefaults(options)
  local registry = Registry("DogboneGadget")
  registry:SetDouble("ToolDiam", options.tool_diam)
  registry:SetDouble("InnerAllowance", options.inner_allowance)
  registry:SetDouble("OuterAllowance", options.outer_allowance)
  registry:SetString("MarkerLayer", options.marker_layer_name)
end
    
