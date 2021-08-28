-- VECTRIC LUA SCRIPT
-- ===================================================]]
-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:
-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
-- 2. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 3. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 4. This notice may not be removed or altered from any source distribution.

-- Right Triangle TrigFunction is written by Jim Anderson of Houston Texas 2020
-- ===================================================]]
-- Global Variables --
-- require("mobdebug").start()

Trig = {}
-- ===================================================]]
function TrigClear()   -- Clears and resets Trig Table  
  Trig.A   =  0.0
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  return true
end -- function end
-- ===================================================]]
function TrigIt()   -- Calulates Right Angle   
  local function BSA()
    Trig.B   = (Trig.C - Trig.A)
    Trig.Slope = math.tan(math.rad(Trig.A)) * 12.0
    Trig.Area =  (Trig.Opp * Trig.Adj) * 0.5
    Trig.Inscribing = ((Trig.Opp + Trig.Adj) - Trig.Hyp) * 0.5
    Trig.Circumscribing =  Trig.Hyp * 0.5
    Trig.Parameter = Trig.Opp + Trig.Adj + Trig.Hyp
  end
  if Trig.A == 0.0 and Trig.B > 0.0 and Trig.Slope ==  0.0 then
      Trig.A = Trig.C - Trig.B
    elseif Trig.A == 0.0 and Trig.B == 0.0 and Trig.Slope > 0.0 then
      Trig.A = math.deg(math.atan(Trig.Slope / 12.0))
  end -- if end
  
  if (Trig.A > 0.0) and (Trig.Opp >  0.0) then -- A and Rise or (B2C)
    -- test 4
    Trig.Adj =  Trig.Opp / (math.tan(math.rad(Trig.A))) 
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    BSA()  
    return true
  elseif (Trig.A > 0.0) and (Trig.Hyp >  0.0)  then -- A and Slope or (A2B)
    -- test 6
    Trig.Adj = math.cos(math.rad(Trig.A)) * Trig.Hyp
    Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
    BSA()    
    return true
  elseif (Trig.A > 0.0) and (Trig.Adj >  0.0)  then -- A and Base or (A2C)
    -- test 5
    Trig.Opp = math.tan(math.rad(Trig.A)) * Trig.Adj
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    BSA()    
    return true
  elseif (Trig.Opp >  0.0) and (Trig.Adj >  0.0) then -- Rise and Base 
  -- test 1
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()    
    return true
  elseif (Trig.Adj >  0.0) and (Trig.Hyp >  0.0) then -- Rise and Slope 
    -- test 2
    Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()   
    return true
  elseif (Trig.Opp >  0.0) and (Trig.Hyp >  0.0) then -- Base and Slope 
    -- test 3
    Trig.Adj = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Opp * Trig.Opp))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()   
    return true
  else
    DisplayMessageBox("Error: Trig Values did not match requirements: \n" .. 
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp =  " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..    
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"                       
                    )
    return false
  end
end -- function end
-- ===================================================]]
function main() -- Test the Right Angle 
  TrigClear() 
  Trig.A   =  0.0
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  3.0  -- Rise  or (B2C)
  Trig.Adj =  4.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0  
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 1: \n" .. 
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..    
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"   
                    )
  TrigClear() 
  Trig.A   =  0.0
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  4.0  -- Base  or (A2C)
  Trig.Hyp =  5.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0  
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 2: \n" .. 
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..    
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"   
                    )                    
  TrigClear() 
  Trig.A   =  0.0
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  3.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  5.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 3: \n" .. 
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp = * " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"   
                    )                    
  TrigClear() 
  Trig.A   =  36.86897645844
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  3.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 4: \n" .. 
                      " Trig.A   = * " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"   
                    )
  TrigClear() 
  Trig.A   =  36.86897645844
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  4.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 5: \n" .. 
                      " Trig.A   = * " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp =  " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"   
                    )
  TrigClear() 
  Trig.A   =  36.86897645844
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  5.0  -- Slope or (A2B)
  Trig.Slope =  0.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 6: \n" .. 
                      " Trig.A   = * " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp =  " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp = * " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..    
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"   
                    )
  TrigClear() 
  Trig.A   =  0.0
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  3.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  9.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test 7: \n" .. 
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope = * " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..    
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.Circumscribing  =  " .. tostring(Trig.Circumscribing) .. " \n" ..    
                      " Trig.Inscribing =  " .. tostring(Trig.Inscribing) .. " \n"   
                    )
                    
  TrigClear() 
  Trig.A   =  0.0
  Trig.B   =  0.0
  Trig.C   = 90.0
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  9.0  
  Trig.Area  =  0.0  
  Trig.OutRadius =  0.0  
  Trig.InRadius  =  0.0
  Trig.Parameter =  0.0
  TrigIt()
    DisplayMessageBox("Test Error: \n" .. 
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" .. 
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..  
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" .. 
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..  
                      " Trig.Adj =  " .. tostring(Trig.Adj) .. " \n" .. 
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" .. 
                      " Trig.Slope = * " .. tostring(Trig.Slope) .. " on 12 inch \n" .. 
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..    
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..  
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.Circumscribing  =  " .. tostring(Trig.Circumscribing) .. " \n" ..    
                      " Trig.Inscribing =  " .. tostring(Trig.Inscribing) .. " \n"   
                    )
  return true  
end -- function end
-- ===================================================]]