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


--[[  -------------- main ---------------------
|
|  Entry point for script
|
]]

function main()

    -- Check we have a job loaded
    local job = VectricJob()
 
    if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;  
    end
 
    local template_path = "c:\\temp\\TestToolpathTemplate.ToolpathTemplate"
	
    local toolpath_manager = ToolpathManager()

    if not toolpath_manager:LoadToolpathTemplate(template_path) then
       MessageBox("Failed to load template " .. template_path)
	   return false
    end
	
    MessageBox("Loaded template " .. template_path)
    
	local calc_result = toolpath_manager:RecalculateAllToolpaths()
	if calc_result == nil then
	   MessageBox("Recalculate all toolpaths failed")
	else
	   MessageBox("Results from recalculate all\n" .. calc_result)
	end
	
    return true;
end    