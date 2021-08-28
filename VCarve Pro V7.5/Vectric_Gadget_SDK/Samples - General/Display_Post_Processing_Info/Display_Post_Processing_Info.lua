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

--[[  ------------------------------------------ ListFilesSaved --------------------------------------------------  
|
|  This sample script is meant to be run automatically after a toolpath has
|  been post-processed. This sample just lists the files which have been created and the
|  associated data
|
|  The standard 'variables' which can be accessed from the post data are
|
|   Notes - the notes associated with the job
|   FileName - the name the user choose to save the toolpath as WITHOUT extension
|   FilePath - the full path to the post-processed file including filename and extension
|
|   ppPostProcessor - name of the post processor which was run before this script
|
|   ppNumFilesOutput  - number of files output (always 1 unless doing tape spliting)
|   ppFirstFileOutput - name of first file which was ouput (name + extension - not including path)
|   ppLastFileOutput - name of last file which was output - same as ppFirstFileOutput unless tape spliting used
|   ppOutputDirectory - directory that the post-processed files were written to , no trailing slash
|   ppBaseName - base name for output file (without extension)
|   ppFileExtension - extension for filename
|   ppFilePathOutput_1 - full path to first file output (only file if not tape splitting)
|
|   -----------   Information about the job size and origins ------------------------------
|   ppHomePositionX - home position (in output file units - NOT model units)
|   ppHomePositionY - home position (in output file units - NOT model units)
|   ppHomePositionZ - home position (in output file units - NOT model units)
|   ppSafeZ - Safe Z value (in output file units - NOT model units)
|
|   ppMaterialZOrigin - Z origin for material ("Material Surface", "Center of Material" or "Table Surface")
|   ppMaterialXYOrigin - XY origin for material ("Bottom Left Corner",  "Bottom Right Corner" ... "Center")
|   ppMaterialXOriginPos - x position of origin (in output file units - NOT model units)
|   ppMaterialYOriginPos - y position of origin (in output file units - NOT model units)|
|
|   ppMaterialMinX - minimum X value of material / job (in output file units - NOT model units)
|   ppMaterialMinY - minimum Y value of material / job (in output file units - NOT model units)
|   ppMaterialMinZ - minimum Z value of material / job (in output file units - NOT model units)
|   ppMaterialMaxX - maximum X value of material / job (in output file units - NOT model units)
|   ppMaterialMaxY - maximum Y value of material / job (in output file units - NOT model units)
|   ppMaterialMaxZ - maximum Z value of material / job (in output file units - NOT model units)
|
|   ppMaterialLengthX - length of material / job in X  (in output file units - NOT model units)
|   ppMaterialLengthY - length of material / job in Y  (in output file units - NOT model units)
|   ppMaterialLengthZ - length of material / job in Z  (in output file units - NOT model units)
|
|   ppOutputUnits - output units from post - "MM" or "INCHES"
|   ppJobUnits - input units to post - oriignal job units ("MM" or "INCHES")
|
|   For a tool changing post (or if all toolpaths use the same tool) we can output multiple toolpaths to a single file
|  (they trigger the NEW_SEGMENT section in the post p) - we can access the settings for each of these.
|
|   ppToolsUsed - list of tools used in file in order they are used
|
|   ppNumToolpathsOutput - total number of toolpaths which were postprocessed in one go
|
|   For each toolpath...  (where %d is an integer in range 1 .. number of toolpaths)
|
|      ppToolpathName_%d - name of toolpath displayed in program toolpath list
|      ppToolpathNotes_%d - notes for this toolpath
|      ppToolpathToolNo_%d - tool number for this toolpath
|      ppToolpathToolName_%d - name of tool for this toolpath
|      ppToolpathSpindleSpeed_%d - spindle speed for this toolpath
|      ppToolpathPlungeRate_%d - plunge rate for this toolpath  NOTE: in units used by machine (not Tool DB / Form)!
|      ppToolpathFeedRate_%d - feed rate for this toolpath  NOTE: in units used by machine (not Tool DB / Form)!
|
|
|   For each tape split file ...  (where %d is an integer in range 1 .. number of files)
|      ppFileNameOutput_%d - filename (including extension but not path) of file written
|      ppFilePathOutput_%d - full pathname of file written
|
|
]]


-- Global Variables 

gOutputInMM = true
gUnitsText  = "mm"
gCreateLogFile = false
gLogFileExtension = ".log"



--[[  ------------------------------------------ Main --------------------------------------------------  
|
|  Entry point for script
|
]]

function main(script_path)

    -- Check we have a job loaded
    job = VectricJob()
 
    if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false
    end

    
    -- get the paramater object from the post processor which has just been run ... 
    local postp_params = job.PostProcessorParameters
    
    -- Get the output units - we use this for formating numbers
    if postp_params:GetString("ppOutputUnits", "") == "INCHES" then
       gOutputInMM = false
       gUnitsText = '"'
    end
    
    local text = "\r\n"
    local text_indent = "   "
    
    text = text .. "PostProccesor Used = '" .. postp_params:GetString("ppPostProcessor", "")  .. "'\r\n"
    text = text .. "PostProccesor Units = " .. postp_params:GetString("ppOutputUnits", "") .. "\r\n"
    
    text = text .. "\r\nJOB / FILE INFO\r\n\r\n"
    text = text .. BuildFileInfo(postp_params, text_indent)
    
    text = text .. "\r\nMATERIAL - In Post Processor Units\r\n\r\n"
    text = text .. BuildMaterialInfo(postp_params, text_indent)
    
    text = text .. "\r\nORIGIN - In Post Processor Units\r\n\r\n"
    text = text .. BuildOriginInfo(postp_params, text_indent)
    
    text = text .. "\r\nHOME POSITION and SAFE Z - In Post Processor Units\r\n\r\n"
    text = text .. BuildHomePositionInfo(postp_params, text_indent)
    
    text = text .. "\r\nOUTPUT DATA\r\n\r\n"
    text = text .. BuildOutputInfo(postp_params, text_indent)
    
    -- now output data for each toolpath we ouput through the post processor
    local num_toolpaths = postp_params:GetInt("ppNumToolpathsOutput", 0)
    local toolpath_indent = "      "
    
    for toolpath_index = 1, num_toolpaths, 1 do
         text = text .. "\r\n   TOOLPATH " .. toolpath_index .. "\r\n"
         text = text .. BuildToolpathInfo(postp_params, toolpath_index, toolpath_indent)
    end
    
    -- was the file tape split?
    local num_files = postp_params:GetInt("ppNumFilesOutput", 0)
    if  num_files > 1 then
      -- Yes ...
      text = text .. "\r\nThe output file was tape split into " .. num_files .. " separate files\r\n" 
      for file_index = 1, num_files, 1 do
         text = text .. "\r\n   File " .. file_index .. "\r\n"
         text = text .. "         File Name = " ..  postp_params:GetString("ppFileNameOutput_" .. file_index, "") .. "\r\n"
         text = text .. "         File Path = " ..  postp_params:GetString("ppFilePathOutput_" .. file_index, "") .. "\r\n"
       end
    else
      -- text = text .. "\r\nThe output file was NOT tape split\r\n" 
    end
    
    -- do we want to create a log file?
    if gCreateLogFile then
       -- Yes - we create it in the same directory as our output post-processed file with same name but a 'gLogFileExtension' extension
       local logfile_path = ""
       logfile_path = logfile_path .. postp_params:GetString("ppOutputDirectory", "")
       logfile_path = logfile_path .. "\\"
       logfile_path = logfile_path .. postp_params:GetString("ppBaseName", "")
       logfile_path = logfile_path .. gLogFileExtension
       
       local log_file = io.open(logfile_path, "wb")
       if log_file == nill then
          DisplayMessageBox("Failed to open log file ...\r\n" .. logfile_path)
       else
          log_file:write(text)
          log_file:close()
          DisplayMessageBox("Wrote toolpath summary to \r\n" .. logfile_path)
       end
    else
       -- DisplayMessageBox(text)
       job:CopyToClipboard(text)
       DisplayMessageBox("Copied file information to clipboard")
    end
    
    return true;
end    

--[[ ---------- Split -------------------------------------------------------
|
| Split passed line into an array with a line for each segment
|
| Array.n = number of lines
|
]]

function Split(text, sep, plain)
   local res={}
   local searchPos=1
   while true do
	   local matchStart, matchEnd=string.find(text, sep, searchPos, plain)
	   if matchStart and matchEnd >= matchStart then
	      -- insert string up to separator into result
	      table.insert(res, string.sub(text, searchPos, matchStart-1))
	      -- continue search after separator
	      searchPos=matchEnd+1
	   else
	      -- insert whole reminder as result
	      table.insert(res, string.sub(text, searchPos))
	      break
	   end
   end

   return res

end

--[[  ------------------------------------------ GetFormatedDouble --------------------------------------------------  
|
|  Return a formated string representation of passed parameter
|
|  If output was in mm returns 3 decimal places, else 4 unless actual num_dp specified
|
]]
function GetFormatedDouble(params, var_name, num_dp)

   local value = params:GetDouble(var_name, 0.0);

   local string_val

   if num_dp == nill then 
      -- caller wants to use default number of decimal places based on output units
      if gOutputInMM then
         string_val = string.format('%1.3f', value)
      else
         string_val = string.format('%1.4f', value)
      end   
   else
     -- caller specified number of decimal places
     string_val = string.format('%1.' .. num_dp .. 'f', value)
   end
   
   return string_val
   
end

--[[  ------------------------------------------ BuildFileInfo --------------------------------------------------  
|
|  Build string describing file / job we created toolpaths for
|
]]

function BuildFileInfo(params, prefix)
   local info = ""
   -- has caller passed us in a prefix for line?
   if prefix == nill then
      prefix = ""  -- NO - use empty string
   end
   
   info = info .. prefix .. "Job / File Name  = " .. params:GetString("FileName", "Unknown").. "\r\n"
   info = info .. prefix .. "JoB / File Path  = " .. params:GetString("FilePath", "Unknown").. "\r\n"
   info = info .. prefix .. "Job / File Units = " .. params:GetString("ppJobUnits", "") .. "\r\n"
   -- Notes can be multiple lines, we mark boundaries 
   info = info .. prefix .. "Job / File Notes = \r\n" 
   local notes = params:GetString("Notes", "")
   if string.len(notes) > 0 then
      local lines = Split(notes, "\r\n", true)
      info = info .. prefix .. prefix .. "-------------------------------------------------\r\n" 
      for n = 1, table.maxn(lines) do
         info = info .. prefix .. prefix .. lines[n] .. "\r\n"
      end   
      info = info .. prefix .. prefix .. "-------------------------------------------------\r\n" 
   end                             

   return info
   
end

--[[  ------------------------------------------ BuildMaterialInfo --------------------------------------------------  
|
|  Build string describing material setup when post was run
|
]]

function BuildMaterialInfo(params, prefix)
   local info = ""
   -- has caller passed us in a prefix for line?
   if prefix == nill then
      prefix = ""  -- NO - use empty string
   end
   
   info = info .. prefix .. "Material Thickness  = " .. GetFormatedDouble(params, 'ppMaterialLengthZ') .. gUnitsText .. "\r\n"
   info = info .. prefix .. "Material Length (X) = " .. GetFormatedDouble(params, 'ppMaterialLengthX') .. gUnitsText .. "\r\n"
   info = info .. prefix .. "Material Width (Y)  = " .. GetFormatedDouble(params, 'ppMaterialLengthY') .. gUnitsText .. "\r\n"
   info = info .. prefix .. "Material Limits     = " ..
                                "(" .. 
                                GetFormatedDouble(params, 'ppMaterialMinX') .. " ," ..  
                                GetFormatedDouble(params, 'ppMaterialMinY') .. " ," ..  
                                GetFormatedDouble(params, 'ppMaterialMinZ') .. 
                                ") -> (" ..
                                GetFormatedDouble(params, 'ppMaterialMaxX') .. " ," ..  
                                GetFormatedDouble(params, 'ppMaterialMaxY') .. " ," ..  
                                GetFormatedDouble(params, 'ppMaterialMaxZ') .. 
                                ")\r\n"
                                
   return info
   
end

--[[  ------------------------------------------ BuildOriginInfo --------------------------------------------------  
|
|  Build string describing origin setup
|
]]

function BuildOriginInfo(params, prefix)
   local info = ""
   -- has caller passed us in a prefix for line?
   if prefix == nill then
      prefix = ""  -- NO - use empty string
   end
   
   info = info .. prefix .. "Z Origin   = " .. params:GetString("ppMaterialZOrigin", "").. "\r\n"
   info = info .. prefix .. "XY Origin  = " .. params:GetString("ppMaterialXYOrigin", "").. "\r\n"
   info = info .. prefix .. "   Origin Offset  = " .. GetFormatedDouble(params, 'ppMaterialXOriginPos') .. ", " 
                                           .. GetFormatedDouble(params, 'ppMaterialYOriginPos') .. "\r\n"
   return info
   
end


--[[  ------------------------------------------ BuildHomePositionInfo --------------------------------------------------  
|
|  Build string describing home position and safe z values
|
]]

function BuildHomePositionInfo(params, prefix)
   local info = ""
   
   -- has caller passed us in a prefix for line?
   if prefix == nill then
      prefix = ""  -- NO - use empty string
   end
   
   info = info .. prefix .. "Home Position X  = " .. GetFormatedDouble(params, 'ppHomePositionX') .. gUnitsText .. "\r\n"
   info = info .. prefix .. "Home Position Y  = " .. GetFormatedDouble(params, 'ppHomePositionY') .. gUnitsText .. "\r\n"
   info = info .. prefix .. "Home Position Z  = " .. GetFormatedDouble(params, 'ppHomePositionZ') .. gUnitsText .. "\r\n"
   info = info .. prefix .. "Safe Z = " .. GetFormatedDouble(params, 'ppSafeZ') .. gUnitsText .. "\r\n"

   return info
   
end

--[[  ------------------------------------------ BuildOutputInfo --------------------------------------------------  
|
|  Build string describing general output file info
|
]]

function BuildOutputInfo(params, prefix)
   local info = ""
   
   -- has caller passed us in a prefix for line?
   if prefix == nill then
      prefix = ""  -- NO - use empty string
   end
   
   info = info .. prefix .. "Post Processed File  = " .. params:GetString("ppFirstFileOutput", "")  .. "\r\n"
   info = info .. prefix .. "Post Processed Dir   = " .. params:GetString("ppOutputDirectory", "")  .. "\r\n"
   info = info .. prefix .. "Post Processed Path  = " .. params:GetString("ppFilePathOutput_1", "")  .. "\r\n"
   info = info .. "\r\n"
   info = info .. prefix .. "Number of Toolpaths output to file  = " .. params:GetInt("ppNumToolpathsOutput", 1)  .. "\r\n"
   -- ToolsUsed can be multiple lines, we dont indent them so mark boundaries 
   local notes = params:GetString("ppToolsUsed", "")
   if string.len(notes) > 0 then
      local lines = Split(notes, "\r\n", true)
      info = info .. prefix .. "Tools Used (in order used) = \r\n" 
      info = info .. prefix .. prefix .. "-------------------------------------------------\r\n" 
      for n = 1, table.maxn(lines) do
         info = info .. prefix .. prefix .. lines[n] .. "\r\n"
      end   
      info = info .. prefix .. prefix .. "-------------------------------------------------\r\n" 
   end     
   
   
   return info
   
end

--[[  ------------------------------------------ BuildToolpathInfo --------------------------------------------------  
|
|  Build string describing toolpath
|
]]

function BuildToolpathInfo(params, toolpath_index, prefix)
   local info = ""
   
   -- has caller passed us in a prefix for line?
   if prefix == nill then
      prefix = ""  -- NO - use empty string
   end
   
   info = info .. prefix .. "Toolpath Name = " .. params:GetString("ppToolpathName_" .. toolpath_index, "")  .. "\r\n"

   -- Notes can be multiple lines, we mark boundaries 
   info = info .. prefix .. "Toolpath Notes = \r\n" 
   local notes = params:GetString("ppToolpathNotes_" .. toolpath_index, "")
   if string.len(notes) > 0 then
      local lines = Split(notes, "\r\n", true)
      info = info .. prefix .. prefix .. "-------------------------------------------------\r\n" 
      for n = 1, table.maxn(lines) do
         info = info .. prefix .. prefix .. lines[n] .. "\r\n"
      end   
      info = info .. prefix .. prefix .. "-------------------------------------------------\r\n" 
   end                             

   
   -- tool info
   info = info .. prefix .. "Tool Number  = " .. params:GetInt("ppToolpathToolNo_" .. toolpath_index, 0)  .. "\r\n"
   info = info .. prefix .. "Tool Name = "    .. params:GetString("ppToolpathToolName_" .. toolpath_index, "")  .. "\r\n"
   
   -- Speeds and Feeds           NOTE: in units used by machine (not Tool DB / Form)!
   info = info .. prefix .. "Feed Rate     = " .. GetFormatedDouble(params, 'ppToolpathFeedRate_' .. toolpath_index, 1).. "\r\n"
   info = info .. prefix .. "Plunge Rate   = " .. GetFormatedDouble(params, 'ppToolpathPlungeRate_' .. toolpath_index, 1).. "\r\n"
   info = info .. prefix .. "Spindle Speed = " .. GetFormatedDouble(params, 'ppToolpathSpindleSpeed_' .. toolpath_index, 1).. "\r\n"
                            
   return info
   
end



