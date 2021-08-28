-- VECTRIC LUA SCRIPT
require("mobdebug").start()
--  =*********************************************= 
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end

    --MessageBox ("JIM")
  DisplayMessageBox(tostring(GetBuildVersion()))
    
    return true 
end
--  =============== End ===============================

