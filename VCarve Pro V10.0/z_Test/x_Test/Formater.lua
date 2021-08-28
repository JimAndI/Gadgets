-- VECTRIC LUA SCRIPT
require("mobdebug").start()

local InFile = ""
local OutFile = ""
-- ===================================================]]
function LengthOfFile(filename)-- Returns file line count
  local len = 0
  if FileExists(filename) then
    local file = io.open(filename)
    for _ in file:lines() do
      len = len + 1
    end
    file:close() ;
  end
  return len
end
-- ===================================================]]
function FileExists(name)
-- DisplayMessageBox(name)
  local f = io.open(name,"r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
-- ===================================================]]
function all_trim(s) -- Trims spaces off both ends of a string
  return s:match( "^%s*(.-)%s*$" )
end
-- ===================================================]]
function Readfile()
--local FL = LengthOfFile(filename)
  local file1 = io.open(OutFile, "a")
  local file2 = io.open(InFile, "r")
  local FL = LengthOfFile(InFile)
  local dat = " "

  while (FL >= 1) do
    dat = all_trim(file2:read()) ;
    if #dat > 2 then
      if string.sub(dat, -1) == ";" then
          dat = all_trim(string.sub(dat, 1, (#dat - 1)))
          file1:write(dat .. "\n")
      else
          file1:write(dat .. "\n")
      end
    end
    FL = FL - 1
  end
  file1:close()-- closes the open file
  file2:close()-- closes the open file

  return
end
-- ===================================================]]
--[[
function Writefile(str)
  if Stair.WriteBOM then
    local file = io.open(OutFile, "a")
    file:write(str)
    file:close()
  end --if end
end -- function end
-- ===================================================]]
function main()
--[[
DisplayMessageBox("Path: " .. InFile .. "\n " ..
"File Length: " .. tostring(XX) .. "\n "  )
]]
  InFile = "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V10.0\\EasyTools\\EasyCabinetMaker\\60.lua"
  OutFile = "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V10.0\\EasyTools\\EasyCabinetMaker\\61.lua"
  Readfile()

  return true

end  -- function end
-- ===================================================]]