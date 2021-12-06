-- VECTRIC LUA SCRIPT
--V1.0 - Created by Adrian Matthews

require "strict"
g_window_height = 145
g_window_width = 520
g_folder = "c:\\"

function main()

    local first_pass = true
	local job = VectricJob()
	local html_header = [[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Backup Folder Chooser</title>
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
.FolderLabel {
font.size:14px;
font-weight:bold;
text-transform:uppercase;
</style>
</head>

]]

	local html_folder = [[
<table border="0" width="100%">
	<tr>
		<td style="width=80%">
			Backup Folder:&nbsp
			<span class="FolderLabel"id="Folder"><span>
		</td>
		<td style="width:20%">
			<button style='font-weight:bold; width:100%' class="DirectoryPicker" ID="ChooseFolder" type=button>
				Choose...
			</button>
		</td>
	</tr>
</table>
</br>
  ]]

	local html_footer = [[
<table border="0" width="100%">
	<tr>
		<td style="width: 20%">
			&nbsp;
		</td>
		<td style="width: 20%">
			<input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK">
		</td>
		<td style="width: 20%">
			&nbsp;
		</td>
		<td style="width: 20%">
			<input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel">
		</td>
		<td style="width: 20%">
			&nbsp;
		</td>
	</tr>
</table>
</html>
]]

	local html = html_header .. html_folder .. html_footer

	local registry = Registry("BackupFolderChooser")

	local window_width  = registry:GetInt("WindowWidth",  g_window_width)
    local window_height = registry:GetInt("WindowHeight", g_window_height)
	local curr_folder = registry:GetString("Folder", g_folder)

	local dialog = HTML_Dialog(
	                          true,
							  html,
							  window_width,
							  window_height,
							  "Set Backup Folder"
							  )


	dialog:AddLabelField("Folder", curr_folder);
    dialog:AddDirectoryPicker("ChooseFolder", "Folder", false);

	if dialog:ShowDialog() then
		curr_folder = dialog:GetLabelField("Folder")
		if string.sub(curr_folder,-1,-1) ~= "\\" then
			curr_folder = curr_folder .. "\\"
		end
		registry:SetString("Folder", curr_folder)
		registry:SetInt("WindowWidth", dialog.WindowWidth)
		registry:SetInt("WindowHeight", dialog.WindowHeight)
	end
	return true

end
