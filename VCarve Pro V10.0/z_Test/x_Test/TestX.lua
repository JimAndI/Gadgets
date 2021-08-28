-- VECTRIC LUA SCRIPT
require "strict"

--  =*********************************************= 
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end
    -- DisplayMessageBox(tostring(Trig(12.0, 0.0, 13.897, nil, nil)))
    DisplayMessageBox(tostring(Trig(12.0, 0.0, nil, 30.256437, nil)))
    
    return true 
end
--  ====================================================
function nnill(x)
     if x == nil then 
           return -1
       else
           return x
     end
end
--  ====================================================
function Trig(base, rise, slope, a, b)
local value = 1.0
        DisplayMessageBox("base: = " .. tostring(nnill(base)) .. "\n" ..
                                                    "  rise: = " .. tostring(nnill(rise)) ..  "\n"  ..
                                                    "  slope: = " .. tostring(nnill(slope)) ..  "\n"  ..
                                                    "  a: = " .. tostring(nnill(a)) ..  "\n"  ..
                                                    "  b: = " .. tostring(nnill(b))
                                                  )
                                                 
 -- slope
        if(base > 0.0 and  rise > 0.0 and slope == 0.0 and a == nil and b == nil) then --
                value = math.sqrt( (base ^ 2) + (rise ^ 2) )  -- slope
        end
        if(base > 0.0 and  rise == nil and slope == 0.0 and a > 0.0 and b == nil) then 
                value = base / math.deg(math.cos(math.rad(a))) -- slope
                value = 101.0  
        elseif(base > 0.0 and  rise == nil and slope == 0.0 and a == nil and b > 0.0) then 
                value = base / math.deg(math.sin(math.rad(b))) -- slope
                value = 105.0  
        elseif(base == nil and  rise > 0.0 and slope == 0.0 and a > 0.0 and b == nil) then 
                value = rise / math.deg(math.sin(math.rad(a))) -- slope
                value = 110.0  
        elseif(base == nil and  rise > 0.0 and slope == 0.0 and a == nil and b > 0.0) then 
                value = rise / math.deg(math.cos(math.rad(b))) -- slope
                value = 120.0  
-- base
        elseif(base == 0.0 and  rise > 0.0 and slope > 0.0 and a == nil and b == nil) then  --
               -- value = math.sqrt( (slope ^ 2) - (rise ^ 2) ) -- base
                  value = (slope ^ 2) - (rise ^ 2) -- base
                  value = 130.0  
        elseif(base == 0.0 and  rise == nil and slope > 0.0 and a > 0.0 and b == nil) then 
                value = slope / math.deg(math.sin(math.rad(b))) -- base
                value = 140.0  
        elseif(base == 0.0 and  rise == nil and slope > 0.0 and a == nil and b > 0.0) then 
                value = slope / math.deg(math.sin(math.rad(b))) -- base
                value = 150.0  
        elseif(base == nil and  rise > 0.0 and slope == nil and a > 0.0 and b == nil) then 
                value = rise / math.deg(math.tan(math.rad(a)))  -- base
                value = 160.0  

        elseif(base == nil and  rise > 0.0 and slope == nil and a == nil and b > 0.0) then 
                value = rise / math.deg(math.cos(math.rad(b)))  -- base
                value = 170.0  
-- rise 
  --     elseif(base > 0.0 and rise == 0.0 and slope > 0.0 and a == nil and b == nil) then
  --              value = math.sqrt( (slope ^ 2) - (base ^ 2) )  -- rise 
  --             value = 180.0  -- rise 
               
        elseif(base == nil and  rise == 0.0 and slope > 0.0 and a > 0.0 and b == nil) then 
                value = 190.0  -- rise 
                
        elseif(base == nil and  rise == 0.0 and slope > 0.0 and a == nil and b > 0.0) then
                   value =  200.0-- rise
        elseif(base > 0.0 and  rise == 0.0 and slope == nil and a > 0.0 and b == nil) then 
                value = 300.0   -- rise
        elseif(base > 0.0 and  rise == 0.0 and slope == nil and a == nil and b > 0.0) then 
                value =  400.0  -- rise
-- angle a
        elseif(base > 0.0 and  rise  > 0.0 and slope == nil and a== 0.0 and b == nil) then
                value =  500.0-- angle a
        elseif(base == nil and  rise > 0.0 and slope  > 0.0 and a == 0.0 and b == nil) then 
                value =  600.0 -- angle a
        elseif(base  > 0.0 and  rise == nil and slope > 0.0 and a == 0.0 and b == nil) then 
                value =  700.0 -- angle a
  -- angle b
        elseif(base > 0.0 and  rise  > 0.0 and slope == nil and a == nil and b == 0.0) then 
                value = 800.0  -- angle b
        elseif(base == nil and  rise > 0.0 and slope  > 0.0 and a == nil and b == 0.0) then 
                value =  900.0  -- angle b
        elseif(base  > 0.0 and  rise == nil and slope > 0.0 and a == nil and b == 0.0) then 
                value =  1000.0  -- angle b
        end
        return value   
end
--  =============== End ===============================

