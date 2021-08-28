-- VECTRIC LUA SCRIPT

require "strict"
--[[
This script wil save a copy of the current active job to a file of the
same name with the current date and time appended to it.
The folder it saved the files to is set in the companion script.
V1.0 - Created by Adrian Matthews
]]

function main()

	-- Check we have a document loaded
    local job = VectricJob()
    if not job.Exists then
          MessageBox("No job loaded")
          return false
    end

	--[[
	Check that there is a name to use for this file
	could change this to default to New if not saved
	already but doesn't seem right to do that.
	]]

	local file_name = job.Name
	if file_name == "" then
		MessageBox("Job must be saved first.")
		return false
	end

	--[[
	Get the backup folder from the registry
	this value is set in the companion script.
	Saving without specifying a folder places the file
	in the current working directory which may be
	completely different to what the user is expecting
	hence the need for the backup folder.
	]]

	local registry = Registry("BackupFolderChooser")
	local folder = registry:GetString("Folder", "NOTSET")

	if folder == "NOTSET" then
		MessageBox("Please run the Backup Folder Chooser script first to set the backup folder.")
		return false
	end

	file_name = folder .. file_name

	--[[
	Add a suffix of the year in reverse format (YYYYMMDD)
	with the time in HHMMSS format.
	]]
	local suffix = os.date("%Y%m%d-%H%M%S")
	file_name = file_name .. "-" .. suffix

	-- Make sure we have the right suffix as it's not automatically added
	if job.IsAspire then
		file_name = file_name .. ".crv3d"
	else
		file_name = file_name .. ".crv"
	end

	if SaveCurrentJobTo(file_name) then
		--MessageBox("Saved a copy of the file to " .. file_name)
	else
		MessageBox("Error occured while trying to save the file to " .. file_name)
	end

	return true

end
