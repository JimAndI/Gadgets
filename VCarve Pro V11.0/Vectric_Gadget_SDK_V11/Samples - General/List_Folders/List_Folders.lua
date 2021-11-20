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

g_version = "1.0"
g_title   = "List Folders Sample"

g_default_window_width  = 800
g_default_window_height = 350

g_options = 
   {
   -- Folder options
   folder           = "c:\\temp",
   log_file_path    = "c:\\temp\\lua_filelist.txt",
   wildcard         = "*.*"
   }

   
--[[  -------------- LoadDefaults --------------------------------------------------
|
|  Load the gadget options from the registry
|  Parameters:
|     options           -- The set of options for the gadget
|
]]
function LoadDefaults(options)

   local registry = Registry("ListFolders")
   
   g_options.folder        = registry:GetString("folder",        g_options.folder)
   g_options.log_file_path = registry:GetString("log_file_path", g_options.log_file_path)
   g_options.wildcard      = registry:GetString("wildcard",      g_options.wildcard)

   
end   

--[[  -------------- SaveDefaults --------------------------------------------------
|
|  Save the gadget options to the registry
|  Parameters:
|     options           -- The set of options for the gadget
|
]]
function SaveDefaults(options)

   local registry = Registry("ListFolders")
   
   registry:SetString("folder",        g_options.folder)
   registry:SetString("log_file_path", g_options.log_file_path)
   registry:SetString("wildcard",      g_options.wildcard)
   
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

   g_options.folder        = dialog:GetLabelField("FolderNameLabel")
   g_options.log_file_path = dialog:GetLabelField("LogFileNameLabel")
   g_options.wildcard      = dialog:GetTextField("WildCard")

   if  g_options.wildcard == "" then
       g_options.wildcard = "*.*"
   end
   
   -- Update successful
   return true
end

--[[  ------------------------ OnLuaButton_ChooseLogFileButton --------------------------------------------------
|
|  Choose a log file
|
]]
function OnLuaButton_ChooseLogFileButton(dialog)


   local file_dialog = FileDialog()
   if not file_dialog:FileSave(
                              "txt",
                              g_options.log_file_path,
                              "Log Files (*.txt)|*.txt|"
                              ) then
       MessageBox("No log file to save to selected")
       return false
    end

   g_options.log_file_path = file_dialog.PathName
   dialog:UpdateLabelField("LogFileNameLabel", g_options.log_file_path);
   
   return true
end
--[[  ------------------------ DisplayDialog --------------------------------------------------
|
|  Display dialog we use to select toolpath template etc
|
]]
function DisplayDialog(script_path)

    

    local dialog = HTML_Dialog(true, g_DialogHtml, g_default_window_width, g_default_window_height, g_title)
   
   -- Standard title and version fields
   dialog:AddLabelField("GadgetTitle", g_title)
   dialog:AddLabelField("GadgetVersion", g_version)

   -- Wildcard for search
   dialog:AddTextField("WildCard", g_options.wildcard)
   
    -- Label and button used to display path to folder
    dialog:AddLabelField("FolderNameLabel", g_options.folder);
    dialog:AddDirectoryPicker("ChooseFolderButton", "FolderNameLabel", false);

    -- Label used to display path to log file
    dialog:AddLabelField("LogFileNameLabel", g_options.log_file_path);
	
    -- Show the dialog
    if not dialog:ShowDialog() then
      return false
   end   
 
   UpdateOptionsFromDialog(dialog, g_options)
 
   -- Save values as defaults for next time
   SaveDefaults(g_options)
   
   return true
end
   
--[[  ----------------------- main -----------------------------
|
|  Entry point for script
|
]]

function main(script_path)


    -- Load our default values from the registry
    LoadDefaults(g_options);
   
    -- Display the dialog
    if not DisplayDialog(script_path) then
      return true
	end  

    local number_of_files = 0
    local directory_list = "Directories ...\n"
    local output_filname = g_options.log_file_path
    local out_file = io.open(output_filname, "w")
    if out_file == nil then
	   MessageBox("Failed to open file " .. output_filname)
	   return false
	end
	
	out_file:write("Files ...\n")
    
    local directory_reader = DirectoryReader()

    directory_reader:BuildDirectoryList(g_options.folder, true)
    directory_reader:SortDirs()

    local dir_reader = DirectoryReader()
    
    local number_of_directories = directory_reader:NumberOfDirs()
    
    
    -- for cur_directory in directory_reader.Directories do
    for i=1, number_of_directories do

        local cur_directory = directory_reader:DirAtIndex(i)
        
        -- get contents of current directory - dont include sub-dirs 
        dir_reader:BuildDirectoryList(cur_directory.Name, false)
     
        dir_reader:GetFiles(g_options.wildcard, true, false)
        
        directory_list = directory_list .. cur_directory.Name .. "\n"   
        
        out_file:write("\r\n" .. cur_directory.Name .. "\n\n")
        
        local num_files_in_dir = dir_reader:NumberOfFiles()
    
        for j=1, num_files_in_dir  do
           local file_info = dir_reader:FileAtIndex(j)
           out_file:write("  " .. file_info.Name .. "\n")
           number_of_files = number_of_files + 1
        end
        -- empty out our directory object ready for next go 
        dir_reader:ClearDirs()
        dir_reader:ClearFiles()
    end

    out_file:write("Number of files = " .. number_of_files .. "\r\n")
    out_file:write("Number of directories = " .. number_of_directories .. "\r\n")
      
    MessageBox(
	          "Processed folder: " .. g_options.folder .. "\n" ..
			  "Wildcard: " .. g_options.wildcard .. "\n" ..
	          "Wrote file list to log file: " .. g_options.log_file_path .."\n" ..
              "Number of files = " .. number_of_files .. "\n" ..
              "Number of directories = " .. number_of_directories .. "\n" ..
              "\n" 
              )  
    
    out_file:close()
    return true    
end


g_DialogHtml = [[
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
	font-size: 12px;
	font-weight: bold;
}

</style>
<title>Vectric Gadget</title>
</head>
<body bgcolor="#efefef">

<!-- 
####################################################################################
#
# Standard Vectric Gadget Header 
#
#  use dialog:AddLabelField("GadgetTitle", g_title) in script to set title string 
#
#                                                                                   
#################################################################################### 
-->
<table border="0" align="center"  bgcolor="#efefef" cellspacing="0" width="100%">
  <tr align="center" >
    <td height="52" align="center" 
	    style="
	    background-image:url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA5wAAAAyCAYAAAAwTNTSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAYNJREFUeNrs2kEKwjAQQNFWFMWt4M2K1/N6rtwVBO2YQMBdW6Ei0fdgoKAukmLjB9uIaAAAAGBpK1sAAACA4AQAAEBwAgAAIDgBAABAcAIAACA4AQAAEJwAAAAgOAEAABCcAAAACE4AAAAQnAAAAAhOAAAABCcAAAAITgAAAAQnAAAAghMAAAAEJwAAAIITAAAAwQkAAACCEwAAAMEJAACA4AQAAADBCQAAgOAEAABAcAIAAIDgBAAAQHACAAAgOAEAAEBwAgAAIDgBAAAQnAAAACA4AQAAEJwAAAAITgAAABCcAAAACE4AAAAEJwAAAAhOAAAABCcAAACCEwAAAAQnAAAAghMAAADBCQAAAIITAAAAwQkAAIDgBAAAgJnarju9/6mwcQBftk6zi+kncn69t11Ud5CHu2LVlotb/Aurzj9Yzmm2vgIA1RjS7NMcyvXUey+2bFFt8/qH0OD8BIDx4NyUcWAC1OFRgvNYrsfC6J7m6hn/kbMzu82IfgD4W08BBgBeqSAQmx0J3wAAAABJRU5ErkJggg==');
		background-position:right; background-repeat:repeat-x; ">
	   <h1 style = "color: #2E2E30; font-size: 24pt;text-align: left" >
	      <span id="GadgetTitle">Gadget Title</span>
		</h1>
	</td>
	<td width="170" align="center" 
	    style="
		background-image:url('data:image/png;base64,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'); 
		background-position:right; background-repeat:repeat-x; ">
    </td>
  </tr>
</table>
<br>
<p> 
This gadget will list all the files in the selected folder and it sub folders.<br>
The list of files is written to the selected log file.
</p>
<table width="100%"  border="0" >
   <tr>
    <td><b>Folder:&nbsp;</b><span id="FolderNameLabel" width="100%"></span></td>
    <td width="150px"><BUTTON style='FONT-WEIGHT:bold; WIDTH:100%' CLASS="DirectoryPicker" ID="ChooseFolderButton" type=button>Select Folder ...</BUTTON></td>
    <td></td>
  </tr>  
   <tr>
    <td colspan = 2><b>Wildcard:&nbsp;</b><input name="textfield" type="text" size="10" maxlength="20" ID="WildCard"></td>
    <td></td>
  </tr>  
   <tr>
    <td><b>Log File:&nbsp;</b><span id="LogFileNameLabel" width="100%"></span></td>
    <td width="150px"><BUTTON style='FONT-WEIGHT:bold; WIDTH:100%' CLASS="LuaButton" ID="ChooseLogFileButton" type=button>Select Log File ...</BUTTON></td>
    <td></td>
  </tr>  

  </table>
<table border="0" bgcolor="#efefef" style="width: 100%; margin-left: 0px; margin-right: 0px; font-family:'Lucida Sans Unicode', 'Lucida Grande', sans-serif;">
    <tr>
		<td colspan="5"><hr width="100%"></td>
	</tr>
	<tr>
	    <td style="width: 20%"></td>
		<td style="width: 20%">
			<input  class="FormButton" type="button"  id="ButtonOK"  value="OK" > 
		</td>
		<td style="width: 20%"></td>
		<td style="width: 20%">
			<input   class="FormButton"  type="button"  id="ButtonCancel"  value="Cancel" >
		</td>	
		<td align="right" valign="bottom" style="width: 20%; color: #999999; font-size: 10px;" >Version <span align="right" id=GadgetVersion>0.0</span</td>
	</tr>

</table>
</body>
</html>
]]