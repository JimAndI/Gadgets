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


--[[  ------------------------------------------ main --------------------------------------------------  
|
|  Entry point for script - test point and vector funtions
|
]]

function main()

    --2D points and vectors
  
    local p1 = Point2D(10 ,10)
    local p2 = Point2D(20, 10)

	-- create a Vector2D by subtractin one point from another
    local v1 = p2 - p1
 
    DisplayMessageBox("Vector from p2 - p1 = " .. v1.X .. " , " .. v1.Y)
    
	-- add a vector to a point to return a point displaced along the vector
	local p3 = p1 + v1
    if p3:IsCoincident(p2, 0.00001) then
       DisplayMessageBox("Correct - P1 == P3")
    else
       DisplayMessageBox("ERROR - P1 != P3")
    end
    
   local len = v1.Length;
   DisplayMessageBox("Distance between points = " .. len) 

   MessageBox("v1 = " .. v1.X .. " , " .. v1.Y)
   
   local v2 = -v1
   
   MessageBox("v2 = " .. v2.X .. " , " .. v2.Y)
   
   v2:Normalize()
    
   MessageBox("v2 = " .. v2.X .. " , " .. v2.Y)
   
   local v3 = v2:NormalTo()

   MessageBox("v3 = " .. v3.X .. " , " .. v3.Y)
   
   -- test a bit of Matrix maths
   local xform = TranslationMatrix2D(Vector2D(5.0, 10.0))
   
   local p3 = xform * p1
   DisplayMessageBox("Transformed p1 = " .. p3.X .. " , " .. p3.Y)
   
   
   return true;
end    