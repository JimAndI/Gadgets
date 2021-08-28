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

-- Easy Stair Gadget Master is written by Jim Anderson of Houston Texas 2020
-- ===================================================]]
-- The mobdebug is to activate the debug capability in ZeroBrane Studio within the Vectric solution
-- require("mobdebug").start()
-- ===================================================]]
-- Global Variables --

Stair = {}    -- builds table
Trig = {}     --* Triangle function table

Stair.StepCount        =  6     -- number of steps
Stair.StepRise         =  7.25  -- height of the step
Stair.StepRun          = 11.25  -- horizontal length of the step
Stair.TreadRun         = 0.000  -- Horizontal length of the step
Stair.TreadThickness   = 1.125  -- Material thickness of the tread stock
Stair.TreadNoseing     = 0.750  -- Step noseing amount allocated for the tread hange over
Stair.RiserThickness   = 0.500  -- Material thickness of the riser stock

Stair.StringerWidth    = 11.50  --* Material Width of the String stock
Stair.StringerAngle    = 0.0    --* Stair Angle to clim 
Stair.CrossStringAngle = 0.0    --* Invers stair Angle
Stair.StringerLayer    = "Stringer Profile" --* Stringer Layer 

local DrawWorkPoints = false     --* true = Turns on and false turns off all workpoints 

local Wpt0 = Point2D(6.0, 6.0)  -- lower left Basepoint
local Wpt1 = Wpt0               -- lower workpoint
local Wpt2 = Wpt0               -- Upper Right workpoint
local Wpt3 = Wpt0               -- Lower Right workpoint
local WptS = Wpt0               -- Step Loop calculation workpoint
local WptR = Wpt0               -- Rise Loop calculation workpoint
-- ===================================================]]
function TrigClear()                                    --* Clears and resets Trig Table  
  Trig.A   =  0.0  -- Angle
  Trig.B   =  0.0  -- Angle
  Trig.C   = 90.00
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  0.0  -- Angle based on run over rise ie-(6 on 12 angle)
  return true
end -- function end
-- ===================================================]]
function TrigIt()                                       --* Calulates Right Triangle   
  --[[ Testing and Usage
    TrigClear() 
  -- Trig.A   =  0.0
  -- Trig.B   =  0.0
  Trig.Opp =  3.0  -- Rise  or (B2C)
  Trig.Adj =  4.0  -- Base  or (A2C)
  -- Trig.Hyp =  0.0  -- Slope or (A2B)
  -- Trig.Slope =  0.0  

  TrigIt() -- calculate right triangle
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
  ]]
  -- =========================================================]]
  local function BSA()    
    Trig.B   = (Trig.C - Trig.A)
    Trig.Slope = math.tan(math.rad(Trig.A)) * 12.0
    Trig.Area =  (Trig.Opp * Trig.Adj) * 0.5
    Trig.Inscribing = ((Trig.Opp + Trig.Adj) - Trig.Hyp) * 0.5
    Trig.Circumscribing =  Trig.Hyp * 0.5
    Trig.Parameter = Trig.Opp + Trig.Adj + Trig.Hyp
  end
  -- =========================================================]]
  if Trig.A == 0.0 and Trig.B > 0.0 and Trig.Slope ==  0.0 then
      Trig.A = Trig.C - Trig.B
    elseif Trig.A == 0.0 and Trig.B == 0.0 and Trig.Slope > 0.0 then
      Trig.A = math.deg(math.atan(Trig.Slope / 12.0))
  end -- if end
  -- =========================================================]]
  if (Trig.A > 0.0) and (Trig.Opp >  0.0) then -- A and Rise or (B2C)
    Trig.Adj =  Trig.Opp / (math.tan(math.rad(Trig.A))) 
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    BSA()  
    return true
  elseif (Trig.A > 0.0) and (Trig.Hyp >  0.0)  then -- A and Bevel or (A2B)
    Trig.Adj = math.cos(math.rad(Trig.A)) * Trig.Hyp
    Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
    BSA()    
    return true
  elseif (Trig.A > 0.0) and (Trig.Adj >  0.0)  then -- A and Base or (A2C)
    Trig.Opp = math.tan(math.rad(Trig.A)) * Trig.Adj
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    BSA()    
    return true
  elseif (Trig.Opp >  0.0) and (Trig.Adj >  0.0) then -- Rise and Base 
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()    
    return true
  elseif (Trig.Adj >  0.0) and (Trig.Hyp >  0.0) then -- Rise and Bevel 
    Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()   
    return true
  elseif (Trig.Opp >  0.0) and (Trig.Hyp >  0.0) then -- Base and Bevel 
    Trig.Adj = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Opp * Trig.Opp))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()   
    return true
  else -- Error: Falure to find a match
    DisplayMessageBox("Error: Right Triangle values did not match requirements: \n" ..
        " Trig.A     =  " .. tostring(Trig.A) .. " \n" ..
        " Trig.B     =  " .. tostring(Trig.B) .. " \n" ..
        " Trig.C     =  " .. tostring(Trig.C) .. " \n" ..
        " Trig.Opp   =  " .. tostring(Trig.Opp) .. " \n" ..
        " Trig.Adj   =  " .. tostring(Trig.Adj) .. " \n" ..
        " Trig.Hyp   =  " .. tostring(Trig.Hyp) .. " \n" ..
        " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
        " Trig.Area  =  " .. tostring(Trig.Area) .. " \n" ..
        " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
        " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
        " Trig.InRadius  =  " .. tostring(Trig.InRadius) .. " \n"
    )
    return false
  end
end -- function end
-- ===================================================]]
function GetAngle(p1, p2)                               --* Returns the Angle from two, 2D points 
  return math.deg(math.atan((p2.Y - p1.Y) / (p2.X - p1.X)))
end 
-- ===================================================]]
function MarkAPoint(job, Note, Pt, Size, LayerName)     -- *Draws mark on the drawing
-- MarkPoint(job, "Note: Hi", Pt1, 3, "Jim")  
  local layer = job.LayerManager:GetLayerWithName(LayerName)
  local marker1 = CadMarker(Note, Pt, Size)
  layer:AddObject(marker1, true)
end -- function end

-- ===================================================]]
function DrawStringer(job)                              --* Draws a Open string   
  -- Open
    local Wp1 = Polar2D(Wpt1,  0.0, Stair.RiserThickness + Stair.TreadNoseing)    -- Establishes p1
    local Wp2 = Polar2D(Wpt0,  0.0, Stair.RiserThickness + Stair.TreadNoseing)    -- Establishes p2
    local Wp3 = Polar2D(Wp2,  90.0, Stair.StepRise - Stair.TreadThickness)        -- Establishes p3
    local Wp4 = Polar2D(Wp3, 360.0 - Stair.CrossStringAngle, Stair.StringerWidth) -- Establishes p4
    
    TrigClear() 
    Trig.A    = Stair.StringerAngle
    Trig.Adj  = Stair.StringerWidth    
    TrigIt()
    
    Stair.Hold = Trig.Hyp - (Stair.StepRise - Stair.TreadThickness) 
    
    local Wp5 = Polar2D(Wp4,  180.0 + Stair.StringerAngle, Trig.Opp) -- Establishes p5
    
    TrigClear() 
    Trig.A    = Stair.StringerAngle
    Trig.Opp  = Stair.Hold
    TrigIt()
    
    local Wp6 = Polar2D(Wp5,  Stair.StringerAngle, Trig.Hyp)         -- Establishes p6
    Stair.Hold = Trig.Adj
    
    TrigClear() 
    Trig.A    = Stair.StringerAngle
    Trig.Adj  = Stair.RunDim - Stair.Hold
    TrigIt()    
    
    local Wp7 = Polar2D(Wp6,  Stair.StringerAngle, Trig.Hyp)         -- Establishes p7

  if DrawWorkPoints then     --* Controls if the work point is shown
    
    MarkAPoint(job, "Wpt0", Wpt0, 3, "WP: Closed String")  
    DrawCircle(job,  Wpt0, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wpt1", Wpt1, 3, "WP: Closed String")  
    DrawCircle(job,  Wpt1, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wpt2", Wpt2, 3, "WP: Closed String")  
    DrawCircle(job,  Wpt2, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wp2" , Wp2,  3, "WP: Closed String")  
    DrawCircle(job,  Wp2, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wp3" , Wp3,  3, "WP: Closed String")  
    DrawCircle(job,  Wp3, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wp4" , Wp4,  3, "WP: Closed String")  
    DrawCircle(job,  Wp4, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wp5" , Wp5,  3, "WP: Closed String")  
    DrawCircle(job,  Wp5, 0.125, "WP: Closed String")
    
    MarkAPoint(job, "Wp6" , Wp6,  3, "WP: Closed String")  
    DrawCircle(job,  Wp6, 0.125, "WP: Closed String")

    MarkAPoint(job, "Wp7" , Wp7,  3, "WP: Closed String")  
    DrawCircle(job,  Wp7, 0.125, "WP: Closed String")
  end
    -- draw a line Wp2 and Wp3
    local line = Contour(0.0)
    line:AppendPoint(Wp2)     
    
    -- Loop the steps on the stringer
      local Wpx = Wp2 -- Establishes the starting point for each cycle
      local Wpy = Polar2D(Wpx, 90.0, Stair.StepRise - Stair.TreadThickness)       -- Establishes p4
      local Wpz = Polar2D(Wpy,  0.0, Stair.StepRun)        -- Establishes p3
    
    for i = Stair.StepCount, 1, -1  do
      if DrawWorkPoints then  --* Controls if the work point is shown
        MarkAPoint(job, "Wpy" , Wpy,  3, "WP: Closed String")  
        DrawCircle(job,  Wpy, 0.125, "WP: Closed String")
        
        MarkAPoint(job, "Wpz" , Wpz,  3, "WP: Closed String")  
        DrawCircle(job,  Wpz, 0.125, "WP: Closed String")
      end  --if end
      line:LineTo(Wpy)         
      line:LineTo(Wpz)         
      Wpx = Wpz
      Wpy = Polar2D(Wpx, 90.0, Stair.StepRise)       -- Establishes p4
      Wpz = Polar2D(Wpy,  0.0, Stair.StepRun)        -- Establishes p3
     
    end --for end
      line:LineTo(Wp7)         
      line:LineTo(Wp6)         
      line:LineTo(Wp2)         
    -- Draw the last step (no riser)
    
    -- Close the stringer line to Wp2
    
    local layer = job.LayerManager:GetLayerWithName(Stair.StringerLayer)
    layer:AddObject(CreateCadContour(line), true)
    
end -- function end
-- ===================================================]]
function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- draws a circle based on user inputs
  -- job - current validated job unique ID
  -- Cpt - (2Dpoint) center of the circle
  -- CircleRadius - radius of the circle
  -- Layer - layer name to draw circle (make layer if not exist)
  local pa = Polar2D(Cpt, 180.0, CircleRadius) 
  local pb = Polar2D(Cpt,   0.0, CircleRadius)
  local line = Contour(0.0)
  line:AppendPoint(pa)     
  line:ArcTo(pb,1)  
  line:ArcTo(pa,1)    
  local layer = job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true 
end -- function end
-- ===================================================]]
function Polar2D(pt, ang, dis)                          -- calulates a 2D point in space
  -- returns the 2D point based on user's inputs.
  -- pt  - (2Dpoint) reference 2Dpoint
  -- ang - (double) projection angle in degrees for new point
  -- dis - (double) projection distance in current drawing units
    return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))  
end -- function end
-- ===================================================]]
function DrawStep(job, Pt1, LayerName)                  -- Draws step
  -- draws a Step based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Layer - (String) layer name to draw circle (make layer if not exist)
        WptR = Polar2D(Pt1, 0.0,  Stair.TreadRun - Stair.RiserThickness ) 
    local p1 = Polar2D(Pt1,270.0, Stair.TreadThickness) -- Establishes p1
    local p2 = Polar2D(p1,   0.0, Stair.TreadRun)       -- Establishes p2
    local p3 = Polar2D(p2,  90.0, Stair.TreadThickness) -- Establishes p3
    
    local line = Contour(0.0)
    line:AppendPoint(Pt1)     
    line:LineTo(p1)     -- Draws p-line from Pt1                                 
    line:LineTo(p2)     -- Draws p-line from p1 
    line:LineTo(p3)     -- Draws p-line from p2 
    line:LineTo(Pt1)    -- Draws p-line from p3 and closes p-line
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true 
end -- function end
-- ===================================================]]
function DrawRiser(job, Pt1, LayerName)                 -- Draws risers
  -- draws a Riser based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Layer - (String) layer name to draw circle (make layer if not exist)
    local p0 = Polar2D(Pt1, 90.0, Stair.StepRise)                        -- Establishes p0
        WptS = Polar2D(p0, 180.0, Stair.TreadNoseing)                    -- Establishes WptS
    local p1 = Polar2D(Pt1,  0.0, Stair.RiserThickness)                  -- Establishes p1
    local p2 = Polar2D(p1,  90.0, Stair.StepRise - Stair.TreadThickness) -- Establishes p2
    local p3 = Polar2D(p2, 180.0, Stair.RiserThickness)                  -- Establishes p3
    
    local line = Contour(0.0)
    line:AppendPoint(Pt1)     
    line:LineTo(p1)      -- Draws p-line from Pt1 
    line:LineTo(p2)      -- Draws p-line from p1 
    line:LineTo(p3)      -- Draws p-line from p21 
    line:LineTo(Pt1)     -- Draws p-line from p3 and closes p-line
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true 
end -- function end
-- ===================================================]]
function DrawLine(job, Pt1, Pt2, LayerName)             -- Draws a line between 2 points
  -- draws a line based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Pt2 - (2Dpoint) Ending point of Line
  -- Layer - layer name to draw Line (make layer if not exist)
    local line = Contour(0.0)
    line:AppendPoint(Pt1)     
    line:LineTo(Pt2)     
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true 
end -- function end
-- ===================================================]]
function main(script_path)                              -- Gadget starting point
--[[
	Gadget Notes: 
    Video 01: Dec 2019 - My New Gadget
    Video 02: Dec 2019 - My Stair Gadget
    Video 03: Dec 2019 - Added Steps and Risers sub functions to My Stair Gadget
    Video 04: Dec 2019 - Added Steps and Risers thickness and address the edits to shapes
    Video 05: Dec 2019 - Added Stringer Open and Closed shapes
    
  ]]
-- Localized Variables --
  local Layer = ""  -- establishes a variable called layer
  local WPrad = 0.0  -- establishes a variable called WPrad
  
-- Job Validation --
  local job = VectricJob()  -- searches for instance validate a job has been set up
  if not job.Exists then    -- validates if a setup has been performed
    DisplayMessageBox("Error: No job loaded") -- tell the user they have not set the job
    return false ; -- stop the program
  end  -- if end

-- Get Data --

-- Calculation --
  Stair.TreadRun = Stair.StepRun + Stair.RiserThickness + Stair.TreadNoseing --* horizontal Material length of the step
  
  Stair.RunDim = Stair.StepCount * Stair.StepRun  -- calculate the stair run (horizontal) dimension
  Stair.RiseDim = (Stair.StepCount + 1) * Stair.StepRise  -- calculate the stair rise (vertical) dimension
  
  Wpt1 = Polar2D(Wpt0,90.0, Stair.StepRise)     -- establish a work point vertical of the Basepoint
  Wpt3 = Polar2D(Wpt0, 0.0, Stair.RunDim)       -- establish working point horizontal to the Basepoint
  Wpt2 = Polar2D(Wpt3,90.0, Stair.RiseDim)      -- establish working point vertical of previous point (Wpt3)
  WptR = Polar2D(WptR, 0.0, Stair.TreadNoseing) -- establishes the new WP base on tread nosing
  
  Stair.StringerAngle = GetAngle(Wpt1, Wpt2)
  Stair.CrossStringAngle = 90.0 - Stair.StringerAngle

-- Do Something --
  if DrawWorkPoints then                --* Controls if the work point is shown
    Layer = "WP Circle Layer"           -- set layer to Circle layer
    WPrad = 0.25                        -- set WorkPoint identification circle radius
    DrawCircle(job, Wpt0, WPrad, Layer) -- draw circles
    DrawCircle(job, Wpt1, WPrad, Layer)
    DrawCircle(job, Wpt2, WPrad, Layer)
    DrawCircle(job, Wpt3, WPrad, Layer)
    
    Layer = "WP Line Layer"             -- set layer to Line
    DrawLine(job, Wpt1, Wpt2, Layer)    -- draw a line
    DrawLine(job, Wpt1, Wpt2, Layer)
    DrawLine(job, Wpt2, Wpt3, Layer)
    DrawLine(job, Wpt3, Wpt0, Layer)
  end --if end
  
  DrawStringer(job) --* Draws the stringer 

  local Steper = 0  -- establishes a variable called Steper and sets it to zero (0)

  -- draw the lower riser
  Layer = "Stair riser"     -- set layer to draw the riser
  DrawRiser(job, WptR, Layer) -- draw the lower riser
  
  while Stair.StepCount > Steper  do

    -- draw the step  
    Layer = "Stair Tread"   -- set layer to draw the stair tread
    DrawStep(job, WptS, Layer) 
  
    -- draw the riser
    Layer = "Stair riser"   -- set layer to draw the riser
    DrawRiser(job, WptR, Layer)
    
    Steper = Steper + 1     -- increment the loop to the next vertical step
    
  end -- while end

  job:Refresh2DView()       -- refresh the graphics to display the new objects.

  return true

end  -- function end
-- ===================================================]]