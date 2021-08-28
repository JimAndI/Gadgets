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

-- Easy Stair Gadget Master is written by Jim Anderson of Houston Texas 2019
-- ===================================================]]
-- Global Variables --
-- require("mobdebug").start()
Stair = {}    -- builds table

Stair.StepCount = 6  -- number of steps
Stair.StepRise = 7.25 -- height of the step
Stair.StepRun = 11.25 -- horizontal length of the step

local Wpt0 = Point2D(6.0, 6.0)  -- lower left Basepoint
local Wpt1 = Wpt0  -- lower workpoint
local Wpt2 = Wpt0  -- Upper Right workpoint
local Wpt3 = Wpt0  -- Lower Right workpoint

local WptS = Wpt0  -- Step Loop calculation workpoint
local WptR = Wpt0  -- Rise Loop calculation workpoint

-- ===================================================]]
function  DrawCircle(job, Cpt, CircleRadius, LayerName)
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
function Polar2D(pt, ang, dis)     
  -- returns the 2D point based on user's inputs.
  -- pt  - (2Dpoint) reference 2Dpoint
  -- ang - (double) projection angle in degrees for new point
  -- dis - (double) projection distance in current drawing units
    return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))  
end -- function end
-- ===================================================]]
function DrawStep(job, Pt1, LayerName)
  -- draws a Step based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Layer - (String) layer name to draw circle (make layer if not exist)
    WptR = Polar2D(Pt1, 0.0, Stair.StepRun) 
    local line = Contour(0.0)
    line:AppendPoint(Pt1)     
    line:LineTo(WptR)     
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true 
end -- function end
-- ===================================================]]
function DrawRiser(job, Pt1, LayerName)
  -- draws a Riser based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Layer - (String) layer name to draw circle (make layer if not exist)
    WptS = Polar2D(Pt1, 90.0, Stair.StepRise) -- establishes the
    local line = Contour(0.0)
    line:AppendPoint(Pt1)     
    line:LineTo(WptS)     
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true 
end -- function end
-- ===================================================]]
function DrawLine(job, Pt1, Pt2, LayerName)
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
function main(script_path)
--[[
	Gadget Notes: 
    Video 01: Dec 2019 - My New Gadget
    Video 02: Dec 2019 - My Stair Gadget
    Video 03: Dec 2019 - Added Steps and Risers sub functions to My Stair Gadget
  
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

  Stair.RunDim = Stair.StepCount * Stair.StepRun  -- calculate the stair run (horizontal) dimension
  Stair.RiseDim = (Stair.StepCount + 1) * Stair.StepRise  -- calculate the stair rise (vertical) dimension
  
  Wpt1 = Polar2D(Wpt0,90.0,Stair.StepRise) -- establish a work point vertical of the Basepoint
  Wpt3 = Polar2D(Wpt0, 0.0,Stair.RunDim) -- establish working point horizontal to the Basepoint
  Wpt2 = Polar2D(Wpt3,90.0,Stair.RiseDim)  -- establish working point vertical of previous point (Wpt3)

-- Do Something --

  Layer = "Circle Layer"  -- set layer to Circle layer
  WPrad = 0.25            -- set WorkPoint identification circle radius
  
  DrawCircle(job, Wpt0, WPrad, Layer) -- draw circles
  DrawCircle(job, Wpt1, WPrad, Layer)
  DrawCircle(job, Wpt2, WPrad, Layer)
  DrawCircle(job, Wpt3, WPrad, Layer)
  
  --[[
  Layer = "Line Layer"   -- set layer to Line
  DrawLine(job, Wpt0, Wpt1, Layer) -- draw a line
  DrawLine(job, Wpt1, Wpt2, Layer)
  DrawLine(job, Wpt2, Wpt3, Layer)
  DrawLine(job, Wpt3, Wpt0, Layer)
  ]]
  
  local Steper = 0  -- establishes a variable called Steper and sets it to zero (0)

  -- draw the lower riser
  Layer = "Stair riser"   -- set layer to draw the riser
  DrawRiser(job, WptR, Layer) -- draw the lower riser
  
  while Stair.StepCount > Steper  do

    -- draw the step  
    Layer = "Stair Tread"   -- set layer to draw the stair tread
    DrawStep(job, WptS, Layer) 
  
    -- draw the riser
    Layer = "Stair riser"   -- set layer to draw the riser
    DrawRiser(job, WptR, Layer)
    
    Steper = Steper + 1  -- increment the loop to the next vertical step
    
  end

  job:Refresh2DView()  -- refresh the graphics to display the new objects.

  return true

end  -- function end
-- ===================================================]]