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

--[[  -------------- Digital Elevation Importer --------------------------------------------------
|
|  A Lua script to demonstrate the capabilities of the Lua 3D API
|  It reads in the height fields from the following formats
|  USGS DEM,
|  NASA SRTM,
|  ArcInfo ASCII
|  Please note this doesn't attempt to deal with the projections
]]

require "strict"
--require("mobdebug").start()

--[[  -------------- Trim --------------------------------------------------
|
|  Trims whitespace from both ends of a string
|  http://snippets.luacode.org/snippets/trim_whitespace_from_string_76
|  Parameters:
|	  s          -- The string to trim
|     
|  Return Values:
|  A trimmed version of the passed string
]]
function Trim(s)
  return s:find('^%s*$') and '' or s:match('^%s*(.*%S)')
end

--[[  -------------- EndsWith --------------------------------------------------
|
|  Checks to see if a string ends with a suffix
|  http://lua-users.org/wiki/StringRecipes
|  Parameters:
|	  s          -- The string to test
|   suffix     -- The suffix to find
|     
|  Return Values:
|  True if the suffix matches
]]
function EndsWith(s, suffix)
   return suffix == '' or string.sub(s, -string.len(suffix)) == suffix
end

--[[  -------------- FileSize --------------------------------------------------
|
|  Returns the size of the file
|  http://www.lua.org/pil/21.3.html
|  Parameters:
|	  file            -- The file whose size we are to compute
|
|  Return Values:
|	 The size of the file
|
]]
function FileSize(file)
local current = file:seek()
local size = file:seek("end")
file:seek("set", current)
return size
end


--[[  -------------- Read --------------------------------------------------
|
|  Reads a substring from a buffer starting at index with a given length
|  Parameters:
|	  buffer          -- The memory buffer to read from
|   index           -- The start index of the substring
|   length          -- The length of the substring
|     
|  Return Values:
|	 Substring of the desired length
|
]]
function Read(buffer, index, length)
  -- The lua substring indices are both inclusive
  -- So the number of bytes extracted in a call to
  -- buffer:sub(start_index, end_index) is equal to 
  -- 1 + (end_index - start_index)
  return buffer:sub(index, index + length - 1)
end

--[[  -------------- ReadString --------------------------------------------------
|
|  Reads a string from the buffer
|  Parameters:
|	  buffer          -- The memory buffer to read from
|   start_index     -- The start index of the substring (inclusive)
|   end_index       -- The end index (inclusive)
|     
|  Return Values:
|	 A string
|
]]
function ReadString(buffer, start_index, end_index)
  return buffer:sub(start_index, end_index)
end

--[[  -------------- ReadShort --------------------------------------------------
|
|  Reads an big endian unsigned short from the buffer
|
|  Parameters:
|	  buffer            -- The buffer to read the short from
|   index             -- The index to read the short from
|
|  Return Values:
|	 The unsigned short at that address
|
]]
function ReadShort(buffer, index)
local s = buffer:sub(index, 1 + index)
local high, low = s:byte(1, 2)
return low + 256 * high
end

--[[  -------------- ParseDEMInt --------------------------------------------------
|
|  Reads a DEM integer from the buffer
|  Parameters:
|	  buffer          -- The memory buffer to read from
|   index           -- The start index of the substring
|     
|  Return Values:
|	 A number
|
]]
function ParseDEMInt(buffer, index)
  return tonumber(Read(buffer, index, 6))
end

--[[  -------------- ParseDEMFloat --------------------------------------------------
|
|  Reads a DEM float from the buffer
|  Parameters:
|	  buffer          -- The memory buffer to read from
|   index           -- The start index of the substring
|     
|  Return Values:
|	 A number
|
]]
function ParseDEMFloat(buffer, index)
  return tonumber(Read(buffer, index, 12))
end

--[[  -------------- ParseDEMDouble --------------------------------------------------
|
|  Reads a DEM double from the buffer
|  Parameters:
|	  buffer          -- The memory buffer to read from
|   index           -- The start index of the substring
|     
|  Return Values:
|	 A number
|
]]
function ParseDEMDouble(buffer, index)
  return tonumber(Read(buffer, index, 24))
end


--[[ -------------- ReadDEMARecord --------------------------------------------------
|
|  Reads in a DEM File A Record
|
|  Parameters:
|	  file          -- The file to load the A Record from
|
|  Return Values:
|	 A record table on success, nil on failure
|
]]
function ReadDEMARecord(file)
  
  -- Read in the binary block that represents the A record
  local buffer = file:read(1024)
  if not buffer then
    return nil
  end

  -- Parse the A record from the binary block
  -- Please note that both FORTRAN (the language used to define DEM files) and Lua
  -- start their array indices at 1 so the indices passed into the various
  -- ParseXXX methods should match those in the specification exactly
  local record = {}
  record.filename = ReadString(buffer, 1, 40)
  record.free_text_format = ReadString(buffer, 41, 80)
  record.se_corner = {}
  record.se_corner.s = ReadString(buffer, 110, 122)
  record.se_corner.e = ReadString(buffer, 123, 135)
  record.process_code = ReadString(buffer, 136, 136)
  record.sectional_indicator = ReadString(buffer, 138, 140)
  record.origin_code = ReadString(buffer, 141, 144)
  record.dem_level_code = ParseDEMInt(buffer, 145)
  record.elevation_pattern = ParseDEMInt(buffer, 151)
  record.ground_ref_system = ParseDEMInt(buffer, 157)
  record.ground_ref_zone = ParseDEMInt(buffer, 163)
  record.projection = {}
  for i = 1, 15 do
    record.projection[i] = ParseDEMDouble(buffer, 169 + 24 * (i - 1))
  end
  record.ground_unit = ParseDEMInt(buffer, 529)
  record.elevation_unit = ParseDEMInt(buffer, 535)
  record.side_count = ParseDEMInt(buffer, 541)
  record.bounds = {SW = {}, NW = {}, NE = {}, SE = {}}
  record.bounds.SW.x = ParseDEMDouble(buffer, 547)
  record.bounds.SW.y = ParseDEMDouble(buffer, 571)
  record.bounds.NW.x = ParseDEMDouble(buffer, 595)
  record.bounds.NW.y = ParseDEMDouble(buffer, 619)
  record.bounds.NE.x = ParseDEMDouble(buffer, 643)
  record.bounds.NE.y = ParseDEMDouble(buffer, 667)
  record.bounds.SE.x = ParseDEMDouble(buffer, 691)
  record.bounds.SE.y = ParseDEMDouble(buffer, 715)
  record.min_elevation = ParseDEMDouble(buffer, 739)
  record.max_elevation = ParseDEMDouble(buffer, 763)
  record.ccw_angle = ParseDEMDouble(buffer, 787)
  record.elevation_accurarcy = ParseDEMInt(buffer, 811)
  record.xyz_resolution = {}
  record.xyz_resolution.x = ParseDEMFloat(buffer, 817)
  record.xyz_resolution.y = ParseDEMFloat(buffer, 829)
  record.xyz_resolution.z = ParseDEMFloat(buffer, 841)
  record.northings_rows = ParseDEMInt(buffer, 853)
  record.eastings_cols = ParseDEMInt(buffer, 859) 

  -- Return the record 
  return record
end

--[[ -------------- ReadDEMBRecordHeader --------------------------------------------------
|
|  Reads in a DEM File B Record Header
|
|  Parameters:
|	  file          -- The file to load the B Record header from
|
|  Return Values:
|	 DEM record table on success, nil on failure
|
]]
function ReadDEMBRecordHeader(file)
  
  -- Read in the next block
  local buffer = file:read(1024)
  if not buffer then
    return nil
  end
  
  -- Set up the next record (also known as a profile)
  local record = {}
  record.row_id = ParseDEMInt(buffer, 1)
  record.col_id = ParseDEMInt(buffer, 7)
  record.rows = ParseDEMInt(buffer, 13)
  record.cols = ParseDEMInt(buffer, 19)
  record.x_ground_planimetric = ParseDEMDouble(buffer, 25)
  record.y_ground_planimetric = ParseDEMDouble(buffer, 49)
  record.local_datum = ParseDEMDouble(buffer, 73)
  record.min_elevation = ParseDEMDouble(buffer, 97)
  record.max_elevation = ParseDEMDouble(buffer, 121)
  -- Simulate reading in the elevation data
  local index = 146
  -- Compute the number of subsequent blocks required to read the entire record
  local blocks = 0 
  for row = 1, record.rows do
    -- To read in an int we need to be able to read in 6 bytes
    -- So if the current index/position plus 6 goes over the end 
    -- then another block is needed
    if (index + 6 > 1024) then
      blocks = blocks + 1
      index = 1
    end
    -- Move our pointer along as if we were reading in DEM ints
    index = index + 6
  end
  
  -- Now try and seek to the start of the next record/profile
  if blocks > 0 then
    local pos = file:seek("cur", blocks * 1024)
    if not pos then
      return nil
    end
  end
  
  -- Return the record
  return record
end

--[[ -------------- ReadDEMBRecordData--------------------------------------------------
|
|  Reads in DEM File B Record Data
|
|  Parameters:
|	  file          -- The file to load the B Record data from
|   relief        -- The relief to write the elevation data into
|
|  Return Values:
|	 If the read was as successful
|
]]
function ReadDEMBRecordData(file, relief)
  
  -- Read in the next block
  local buffer = file:read(1024)
  if not buffer then
    return false
  end
  
  -- Read in the relevant header data
  local col_id = ParseDEMInt(buffer, 7)
  local rows = ParseDEMInt(buffer, 13)
  local index = 146
  for row = 1, rows do
    -- If trying to read the next int would go off the end of the buffer
    -- then read in the next 1024 byte block
    -- TODO Seek for the first int in the block as per specification rather than 
    -- assume it is to be found at index 1
    if (index + 6 > 1024) then
      buffer = file:read(1024)
      if not buffer then
        return false
      end
      index = 1
    end
    -- Read in the data
    local elevation = ParseDEMInt(buffer, index)
    if elevation and elevation ~= -32768 then
      relief:Set(col_id - 1, row - 1, elevation)
    end
    -- Move our pointer along
    index = index + 6
  end
  
  -- Success
  return true
end

--[[  -------------- ReadDEMElevationData --------------------------------------------------
|
|  Reads in a DEM File
|
|  Complete specification http://nationalmap.gov/standards/pdf/2DEM0198.PDF
|  Parameters:
|   options           -- The set of options to use
|
|  Return Values:
|	 DEM record table on success, nil on failure
|
]]
function ReadDEMElevationData(options)

-- Open the DEM File
local file = io.open(options.filename, "rb")
if not file then
  return nil
end

-- Load in the a record
local a_record = ReadDEMARecord(file)
if not a_record then
  return nil
end

-- Need to actually compute our dimensions
local cols = a_record.eastings_cols
local rows = 0

-- Remember where the b records started (should be constant)
local mark = file:seek()

-- Load all in the b record headers and compute our dimensions
local b_record = {}
for col = 1, cols do
  local profile = ReadDEMBRecordHeader(file)
  if not profile then
    return nil
  end
  if profile.rows > rows then
    rows = profile.rows
  end
  table.insert(b_record, profile)
end

-- Create our relief here
local relief = Relief(cols, rows, options.relief_real_width, options.relief_real_height)
if not relief then
  return nil
end

-- Return the start of the records and read in the actual data
file:seek("set", mark)

-- Read in the height data
for col = 1, cols do
  if not ReadDEMBRecordData(file, relief) then
    return nil
  end
end

-- Prepare and return the elevation data
local elevation_data = {}
elevation_data.a_record = a_record
elevation_data.b_record = b_record
elevation_data.c_record = {} -- We don't support the DEM spec fully so we return an empty C record
elevation_data.relief = relief
return elevation_data
end


--[[  -------------- ReadHGTElevationData --------------------------------------------------
|
|  Reads in a HGT File (SRTM data)
|
|  http://stackoverflow.com/questions/357415/how-to-read-nasa-hgt-binary-files
|  http://www2.jpl.nasa.gov/srtm/faq.html
|
|  Parameters:
|	  options           -- The set of options to use
|
|  Return Values:
|	 HGT Elevation Data on success, nil on failure
|
]]
function ReadHGTElevationData(options)

-- Open the HGT File
local file = io.open(options.filename, "rb")
if not file then
  return nil
end

-- Get the size of the file and check if it's valid
local file_size = FileSize(file)
local supported_square_sizes = {1201, 3601}
local square_size = -1
for _, size in pairs(supported_square_sizes) do
  if (file_size == 2 * size * size) then
    square_size = size
    break
  end
end
 
-- If we didn't find a valid size then return nothing
if square_size < 0 then
  return nil
end

-- Create our relief
local relief = Relief(square_size, square_size, options.relief_real_width, options.relief_real_height)
if not relief then
  return nil
end

-- Set up the maximum and minimum elevation
local max_elevation = -999999999
local min_elevation = -max_elevation

-- Read in the file
for col = 1, square_size do
  local buffer = file:read(2 * square_size)
  local index = 1
  for row = 1, square_size do
    local elevation = ReadShort(buffer, index) - 32768
    -- Non void value?
    if elevation ~= -32768 then
      -- Update max elevation
      if elevation > max_elevation then
        max_elevation = elevation
      end
      -- Update min elevation
      if elevation < min_elevation then
        min_elevation = elevation
      end
      -- Set the relief height
      -- NB the data needs to be rotated by 90 degrees clockwise
      -- So do this by transposing and then flipping y
      -- We can do this by changing the locations we write to because
      -- these maps are square
      relief:Set(row - 1, square_size - col , elevation)
    end
    index = 2 + index
  end
end

-- Is the data nonsensical then return nothing
if min_elevation > max_elevation then
  return nil
end

-- Prepare and return the elevation data
local elevation_data = {}
elevation_data.a_record = { filename = "HGT File", max_elevation = max_elevation, min_elevation = min_elevation}
elevation_data.b_record = {}
elevation_data.c_record = {}
elevation_data.relief = relief
return elevation_data
end

--[[  -------------- ReadASCElevationData --------------------------------------------------
|
|  Loads in a ArcInfo ASCII Files
|  http://docs.codehaus.org/display/GEOTOOLS/ArcInfo+ASCII+Grid+format#ASCIIGrid
|
|  Parameters:
|	  options           -- The set of options to use
|
|  Return Values:
|	 ASC Elevation Data on success, nil on failure
|
]]
function ReadASCElevationData(options)

-- Open the ASC File
local file = io.open(options.filename, "r")
if not file then
  return nil
end

-- What we know about the file
local header = { nodata_value = -9999 }

-- Attempt to read in the first six line of the file
for i = 1, 6 do
  -- Remember our current position
  local current = file:seek()
  -- Read in the line
  local line = file:read("*line")
  if not line then
    return nil
  end
  -- Try and match our pattern with the answer
  local field, value = line:match("^([%a_]+)%s+([^%s]+)$") -- Start of line, one or more letters and _, some whitespace, one or more non-whitespace characters
  -- Store the values
  if field and value then
    header[field:lower()] = tonumber(value)
  else
    -- In this case we've most likely hit the start of the data so reset the file position 
    asc_file:seek("set", current)
  end
end

-- Did we get the row and column information from the file?
if not (header.ncols and header.nrows) then
  return nil
end

-- Create our relief
local relief = Relief(header.ncols, header.nrows, options.relief_real_width, options.relief_real_height)
if not relief then
  return nil
end

-- Set up the maximum and minimu elevation
local max_elevation = -999999999
local min_elevation = -max_elevation

-- Read in the file
for row = 1, header.nrows do
  -- Read in the line
  local line = file:read("*line")
  if not line then
    return nil
  end
  -- Set up the column to write to
  local col = 1
  -- Callback function for gsub
  local InsertData = function(token)
    local value = tonumber(token)
    if value and value ~= header.nodata_value then
      if value > max_elevation then
        max_elevation = value
      end
      if value < min_elevation then
        min_elevation = value
      end
      relief:Set(col - 1, header.nrows - row, value)
    end
    col = 1 + col -- Move the column along
  end
  line:gsub("[^%s]+", InsertData)
end

-- Is the data nonsensical then return nothing
if min_elevation > max_elevation then
  return nil
end

-- Prepare and return the elevation data
local elevation_data = {}
elevation_data.a_record = { filename = "ASC File", max_elevation = max_elevation, min_elevation = min_elevation}
elevation_data.b_record = {}
elevation_data.c_record = {}
elevation_data.relief = relief
return elevation_data
end

--[[  -------------- LoadRecords --------------------------------------------------
|
|  Switches on the extension to load the correct record type
|
|  Parameters:
|	  options          -- The set of options to use to load the file
|
|  Return Values:
|	 Record table on success, nil on failure
|
]]
function ReadElevationData(options)
  if EndsWith(options.filename, ".dem") then
    return ReadDEMElevationData(options)
  elseif EndsWith(options.filename, ".hgt") then
    return ReadHGTElevationData(options)
  elseif EndsWith(options.filename, ".asc") then
    return ReadASCElevationData(options)
  end
  return nil
end


--[[  -------------- DisplayDialog --------------------------------------------------
|
|  Displays the options dialog
|  Parameters:
|	options           -- The set of options
|   script_path       -- Where to locate the html pages
|   job            	  -- The job
|     
|
|  Return Values:
|	 1 on success,
|  0 if the user cancelled
|
]]
function DisplayDialog(options, script_path, job)

	-- Prepare the dialog
	local script_html = "file:" .. script_path .. "\\Digital_Elevation_Importer.htm"
	local dialog_name = "Digital Elevation Importer"
  local dialog = HTML_Dialog(false, script_html, options.window_width, options.window_height, dialog_name)
  
  -- Add file picker
  dialog:AddTextField("FileNameEdit", "")
  dialog:AddFilePicker(true, "ChooseFileButton", "FileNameEdit", true)
  
	-- Show the dialog
  if not dialog:ShowDialog() then
	return 0
  end
	
	-- Update the options from this dialog
	options.filename = dialog:GetTextField("FileNameEdit")
  if not options.filename then
    return 0
  end
  
	return 1
end


--[[  ------------------------ main --------------------------------------------------
|
|  Entry point for script
|
]]
function main(script_path)
  
  -- Check for the existence of a job
  local job = VectricJob()
  if not job.Exists then
    return false
  end
  
  -- Set up our options and display the dialog
  local options = {
    window_width = 500,
    window_height = 200,
    relief_real_width = 5.0,
    relief_real_height = 5.0,
    filename = ""
  }
  if DisplayDialog(options, script_path, job) == 0 then
    return false
  end
  
  -- Load in our elevation data
  local elevation_data = ReadElevationData(options)
  if not elevation_data then
    return false
  end
    
  -- Post scale the elevation data
  local material_block = MaterialBlock()
  local bounding_box = material_block.MaterialBox
  local z_length = bounding_box.ZLength
  local min_elevation = elevation_data.a_record.min_elevation
  local max_elevation = elevation_data.a_record.max_elevation
   
  -- Manipulate the returned relief here
  elevation_data.relief:Subtract(min_elevation)
  elevation_data.relief:Multiply(z_length / (max_elevation - min_elevation))
    
  -- Add the relief to the manager
  local component_manager = job.ComponentManager
  local component_name = Trim(elevation_data.a_record.filename)
  component_manager:AddRelief(elevation_data.relief, CombineMode.Add, component_name)
  
  return true
  
end
