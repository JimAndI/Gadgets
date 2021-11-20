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


-- This gadget is supplied as a 'template' for user to build their own gadgets


require "strict"

g_version = "1.0"
g_title   = "Sample Gadget"

--[[  ------------------------ OnLuaButton_ApplyButton --------------------------------------------------
|
|  Apply Button handler
|
]]
function OnLuaButton_ApplyButton(dialog)

	local title   = dialog:GetLabelField("GadgetTitle")
	local version = dialog:GetLabelField("GadgetVersion")

	MessageBox("User pressed Apply button for Gadget \"" .. title .. "\"  Version = " .. version)
	
	return true
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

    local script_html = "file:" .. script_path .. "\\User_Gadget_Template.htm"
    local dialog = HTML_Dialog(false, script_html, 640, 400, g_title)
	
	dialog:AddLabelField("GadgetTitle", g_title)
	dialog:AddLabelField("GadgetVersion", g_version)
	
    -- Show the dialog
    if not dialog:ShowDialog() then
		return false
    end
	
	return true
end
	