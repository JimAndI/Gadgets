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
Cycloid.Ver = "2.0"  -- Version 2.0 : Aug 2021
--====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                 (pt.Y + dis * math.sin(math.rad(ang)))
                )
end -- function end
-- =====================================================]]
function GetDistance(objA, objB)
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end -- function end
-- =====================================================]]
function GetAngle(points1 , points2)
    return math.deg(math.atan((points2.Y - points1.Y) / (points2.X - points1.X)))
end -- function end
-- ===================================================]]
function main()
--[[
	Gadget Notes: Easy Cycloid Gadget
                 Version 1.0 : July 2020
                 Version 2.0 :  Aug 2021
  ]]
-- Localized Variables --
  Cycloid.job = VectricJob()
  if not Cycloid.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  local selection = Cycloid.job.Selection
  if selection.IsEmpty then
      MessageBox("Select one (1) vector to use aa Cycloid base")
      return false
  end
  local pos = selection:GetHeadPosition()
  local object
  object, pos = selection:GetNext(pos)
  local pos1 = object:GetContour()
  Cycloid.BaceAngle = GetAngle(pos1.StartPoint2D , pos1.EndPoint2D)
  Cycloid.Angle = 270.0 + Cycloid.BaceAngle
  Cycloid.length = GetDistance(pos1.StartPoint2D , pos1.EndPoint2D)
  Cycloid.Radius = (Cycloid.length/math.pi) * 0.5
  Cycloid.Segments = 180.0 * Cycloid.length
  local pt0 = pos1.StartPoint2D
  pt0 = Polar2D(pt0, Cycloid.BaceAngle + 90.0 , Cycloid.Radius)
  local pt1 = Point2D(0.0, 0.0)
  Cycloid.SegmentAngle = 360.0 / Cycloid.Segments
  Cycloid.Circumference = Cycloid.Radius * (math.pi * 2)
  Cycloid.XPoints = 0.0
  Cycloid.SegmentLength = Cycloid.Circumference/Cycloid.Segments
  -- Do Something --
  local line = Contour(0.0)
  local layer = Cycloid.job.LayerManager:GetLayerWithName("Cycloid-Arc")
  pt1 = Polar2D(pt0, Cycloid.Angle, Cycloid.Radius)
  line:AppendPoint(pt1) ;
  for _= Cycloid.Segments, 1, -1 do
    line:LineTo(pt1) ;
    Cycloid.XPoints = Cycloid.XPoints + Cycloid.SegmentLength
    Cycloid.Angle = Cycloid.Angle - Cycloid.SegmentAngle
    pt0 = Polar2D(pt0, Cycloid.BaceAngle, Cycloid.SegmentLength)
    pt1 = Polar2D(pt0, Cycloid.Angle, Cycloid.Radius)
  end
    layer:AddObject(CreateCadContour(line), true)
  Cycloid.job:Refresh2DView()
  return true
end  -- function end
-- ===================================================]]