-- VECTRIC LUA SCRIPT

--[[ This script adds a Save Copy As function to Aspire/VCarve
you can use it so save the current job to a new name and/or location
without affecting the name and location of the current job
v1.0 - Created by Adrian Matthews
]]

require "strict"
g_folder = "c:\\"

function main()

	local job = VectricJob()
	local registry = Registry("SaveCopyAs")
	local curr_folder = registry:GetString("Folder", g_folder)
	local suffix = "crv3d"
	local file_filter = "Aspire Files (*." .. suffix .. ")|*." .. suffix .. "||"

	if not job.IsAspire then
		suffix = "crv"
		file_filter = "VCarve Files (*." .. suffix .. ")|*." .. suffix .. "||"
	end

	local file_dialog = FileDialog()
	local file_name = job.Name

	if file_name == "" then
		MessageBox("Job must be saved first.")
		return false
	end

	if file_dialog:FileSave(suffix, curr_folder .. file_name .. "." .. suffix , file_filter) then
		if not SaveCurrentJobTo(file_dialog.PathName) then
			MessageBox("Error saving file")
		else
			curr_folder = string.match(file_dialog.PathName, "(.-)([^\\]-([^%.]+))$")
			registry:SetString("Folder",curr_folder)
		end
	end

	return true

end
