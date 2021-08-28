-- VECTRIC LUA SCRIPT
-- Global Variables --
require("mobdebug").start()
-- require "strict"
-- local dxf = {}
-- ===================================================]]
function MarkPoint(Note, Pt, Size, LayerName)
  --[[
     | Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
     | Draws mark on the drawing
     | call = MarkPoint("Note: Hi", Pt1, 3, "Jim")
   ]]
      local layer = Milling.job.LayerManager:GetLayerWithName(LayerName)
      local marker1 = CadMarker(Note, Pt, Size)
      layer:AddObject(marker1, true)
      DrawCircle(Pt, 0.25, LayerName)
  return true
  end -- function end
-- ===================================================]]
function DrawCircle(Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- | draws a circle based on user inputs
  -- | job - current validated job unique ID
  -- | Cpt - (2Dpoint) center of the circle
  -- | CircleRadius - radius of the circle
  -- | Layer - layer name to draw circle (make layer if not exist)
  local pa = Polar2D(Cpt, 180.0, CircleRadius)
  local pb = Polar2D(Cpt,   0.0, CircleRadius)
  local line = Contour(0.0)
  line:AppendPoint(pa)
  line:ArcTo(pb,1)
  line:ArcTo(pa,1)
  local layer = Milling.job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
--  ===================================================]]
function main()
  local job = VectricJob()                             -- Get the currect Job ID
  if not(job.Exists) then                         -- Validate the user has setup a Job
        DisplayMessageBox("Error: The Gadget cannot proceed without a job setup.\n" ..
                          "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                          "specify the material dimensions")
    return false;
  end
-- =====================================================]]



-- =================================================]]



  return true
end