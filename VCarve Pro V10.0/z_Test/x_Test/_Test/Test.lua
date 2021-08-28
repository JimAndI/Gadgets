-- VECTRIC LUA SCRIPT
require("mobdebug").start()
local xy = "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V10.0\\_Test\\Lib.lua"
local xx = require(xy) -- test 1
--local tl = require("Lib")                           -- test 2

--  =*********************************************= 

function main()
    DisplayMessageBox("Jim")
    DisplayMessageBox(xx.jim)
    
  return true 
end
--  =============== End ===============================

