-- VECTRIC LUA SCRIPT
require "strict"
-- ===================================================
function NowName()
--[[
    %a  abbreviated weekday name (e.g., Wed)
    %A  full weekday name (e.g., Wednesday)
    %b  abbreviated month name (e.g., Sep)
    %B  full month name (e.g., September)
    %c  date and time (e.g., 09/16/98 23:48:10)
    %d  day of the month (16) [01-31]
    %H  hour, using a 24-hour clock (23) [00-23]
    %I  hour, using a 12-hour clock (11) [01-12]
    %M  minute (48) [00-59]
    %m  month (09) [01-12]
    %p  either "am" or "pm" (pm)
    %S  second (10) [00-61]
    %w  weekday (3) [0-6 = Sunday-Saturday]
    %x  date (e.g., 09/16/98)
    %X  time (e.g., 23:48:10)
    %Y  full year (1998)
    %y  two-digit year (98) [00-99]
    %%  the character `%´

    DeBug(9370,4, "NowName")
]]
    return os.date("%d").. os.date("%H").. os.date("%M").. os.date("%S")
end
-- ===================================================
function ProjectBackup()
    local filename = "C:/Users/Public/Documents/Vectric Files/Gadgets/CabinetBackup.cmd"
    local file = io.open(filename, "w")
    file:write("echo ================================================================================ \n") ;
    file:write("echo CabinetMaker \n") ;
    file:write("echo on \n") ;
    file:write("Z:\n") ;
    file:write("cd Vcarve \n") ;
    file:write("mkdir " .. NowName() .." \n") ;
    file:write("xcopy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5" .. string.char(34) .. " " .. string.char(34) .. "Z:\\Vcarve\\" .. NowName() ..  "\\" .. string.char(34) .. " /d/e/y \n") ; 
    file:write("echo ================================================================================= \n") ;
    file:write("pause \n") ;
    file:close()-- closes the open file 
    return true  
end
-- ===================================================
function main(script_path)
-- create a layer with passed name if it doesn't already exist
    ProjectBackup() 
    return true 
end  -- function end
-- ===================================================