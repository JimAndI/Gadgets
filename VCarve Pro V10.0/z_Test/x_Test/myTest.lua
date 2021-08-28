-- VECTRIC LUA SCRIPT

require("mobdebug").start()

--  =*********************************************= 
local function AngleDeg(pt1, pt2) -- setup stock base on user dialog inputs
    local anglex = (math.atan2(pt2.Y - pt1.Y, pt2.X - pt1.X) * 180.0)/ math.pi
    return anglex 
end  -- end of function

function main(script_path)
    local p1 = Point2D(0.0, 0.0)
    local p2 = Point2D(2.0, 2.0)
	  DisplayMessageBox(tostring(AngleDeg(p1, p2)))    
  return true 
end -- end of function

