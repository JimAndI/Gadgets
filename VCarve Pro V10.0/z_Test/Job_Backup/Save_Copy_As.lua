-- VECTRIC LUA SCRIPT

--This script adds a Save Copy As function to Aspire/VCarve
--V1.0 - Created by Adrian Matthews

require "strict"

function main()

	local job = VectricJob()
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

	if file_dialog:FileSave(suffix, file_name .. "." .. suffix , file_filter) then
		if not SaveCurrentJobTo(file_dialog.PathName) then
			MessageBox("Error saving file")
		end
	end

	return true

end
