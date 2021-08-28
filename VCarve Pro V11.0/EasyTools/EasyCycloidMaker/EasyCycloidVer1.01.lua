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

-- Easy Seed Gadget Master is written by JimAndi Gadgets of Houston Texas 2020
-- ===================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Cycloid = {}
Cycloid.Ver = "1.01"  -- Version 6: Jan 2020 - Clean Up and added Ver to Dialog
-- ===================================================]]
function DisplayTest(words)
  -- test a sub fuction
    DisplayMessageBox(words)
	return true
end -- function end
--====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                 (pt.Y + dis * math.sin(math.rad(ang)))
                )
end -- function end
-- ===================================================]]
function main()
--[[
	Gadget Notes: July 2020 - Easy Cycloid Gadget

  ]]
-- Localized Variables --
  local pt0 = Point2D(0.0, 0.0)
  local pt1 = Point2D(0.0, 0.0)
  local pt2 = Point2D(0.0, 0.0)
  -- Get Data --
  Cycloid.Radius = 6.0
  Cycloid.Segments = 360.0
  -- Calculation --
  Cycloid.Angle = 270.0
  Cycloid.SegmentAngle = 360.0 / Cycloid.Segments
  Cycloid.Circumference = Cycloid.Radius * (math.pi * 2)
  Cycloid.XPoints = 0.0
  Cycloid.SegmentLength = Cycloid.Circumference/Cycloid.Segments
  pt2 = Point2D(Cycloid.Circumference, 0.0)
-- Job Validation --
  Cycloid.job = VectricJob()
  if not Cycloid.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  -- Do Something --
  pt1 = Polar2D(pt0, Cycloid.Angle, Cycloid.Radius)
  local line = Contour(0.0)
  local layer = Cycloid.job.LayerManager:GetLayerWithName("Cycloid-Arc")
  line:AppendPoint(pt1) ;
  for _= Cycloid.Segments, 1, -1 do
    line:LineTo(pt1) ;
    Cycloid.XPoints = Cycloid.XPoints + Cycloid.SegmentLength
    Cycloid.Angle = Cycloid.Angle - Cycloid.SegmentAngle
    pt0 = Polar2D(pt0, 0.0, Cycloid.SegmentLength)
    pt1 = Polar2D(pt0, Cycloid.Angle, Cycloid.Radius)
  end
    layer:AddObject(CreateCadContour(line), true)
  Cycloid.job:Refresh2DView()
  return true
end  -- function end
-- ===================================================]]