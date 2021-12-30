-- VECTRIC LUA SCRIPT
-- ===========================================================================================
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

-- Easy CenterLine Gadget is written by JimAndi Gadgets of Houston Texas 2020
-- ===========================================================================================
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local CenterLine = {}
CenterLine.Ver = "1.0"  -- Version 1.0 : Dec 2021
--====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                 (pt.Y + dis * math.sin(math.rad(ang)))
                )
end -- function end
-- ===================================================]]
function GetDistance(objA, objB)
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end -- function end
-- ===================================================]]
local function AddGroupToJob(job, group, layer_name)
   --  create a CadObject to represent the  group
  local cad_object = CreateCadGroup(group);
   -- create a layer with passed name if it doesnt already exist
  local layer = job.LayerManager:GetLayerWithName(layer_name)
   -- and add our object to it
  layer:AddObject(cad_object, true)
  return cad_object
end
-- ===================================================]]
function GetAngle(points1, points2)
  local x = math.deg(math.atan((points2.Y - points1.Y) / (points2.X - points1.X)))
  local XX = 32.0
  return x
end -- function end
-- ===================================================]]
function main()
--[[
	Gadget Notes: Easy CenterLine Gadget
                 Version 1.0 : Dec 2021
  ]]
-- Localized Variables --
  local Layer
  local MaterialBlock = MaterialBlock()
  local job = VectricJob()
  local line = Contour(0.0)
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false
  end
  local selection = job.Selection
  if selection.IsEmpty then
      MessageBox("Select one (1) Open Line to create a Dashed Line")
      return false
  end
  if selection.Count > 1 then
      MessageBox("Select one (1) Open Line to make a Dashed Line")
      return false
  end
  local pos   = selection:GetHeadPosition()
  local object
  object, pos = selection:GetNext(pos)
  local pos1  = object:GetContour()
  local Ang   = GetAngle(pos1.StartPoint2D,pos1.EndPoint2D)
  CenterLine.Angle = math.abs(Ang)
  if Ang == 0.0 and (pos1.StartPoint2D.X < pos1.EndPoint2D.X) then
    pt1a = pos1.StartPoint2D
    pt2a = pos1.EndPoint2D
    CenterLine.Angle = CenterLine.Angle
    CenterLine.RAngle = 180.00
  elseif Ang == 0.0 and (pos1.StartPoint2D.X > pos1.EndPoint2D.X) then
    pt2a = pos1.StartPoint2D
    pt1a = pos1.EndPoint2D
    CenterLine.Angle  = 0.0
    CenterLine.RAngle = 180.00
  elseif CenterLine.Angle == Ang and (pos1.StartPoint2D.X > pos1.EndPoint2D.X) then
    pt2a = pos1.StartPoint2D
    pt1a = pos1.EndPoint2D
    CenterLine.RAngle = CenterLine.Angle + 180.00
  elseif CenterLine.Angle == Ang then
    pt1a = pos1.StartPoint2D
    pt2a = pos1.EndPoint2D
    CenterLine.RAngle = CenterLine.Angle + 180.00
  elseif (Ang < CenterLine.Angle) and (pos1.StartPoint2D.X > pos1.EndPoint2D.X) then
    pt1a = pos1.StartPoint2D
    pt2a = pos1.EndPoint2D
    CenterLine.Angle = 180.0 - CenterLine.Angle
    CenterLine.RAngle = CenterLine.Angle + 180.00
  else
    pt1a = pos1.StartPoint2D
    pt2a = pos1.EndPoint2D
    CenterLine.Angle = 360.00 - CenterLine.Angle
    CenterLine.RAngle = CenterLine.Angle + 180.00
  end -- if end
  CenterLine.length = GetDistance(pt1a, pt2a)
  local DashCount   = 16.0
  local SpaceCount  = 15.0
  local DashLength  = CenterLine.length / (DashCount + SpaceCount)
  local SpaceLength = (CenterLine.length - (DashLength * DashCount)) / SpaceCount
  local pt1 = pt1a
  local pt2 = Polar2D(pt1a, CenterLine.Angle, DashLength)
  local group = ContourGroup(true)
  local layer = job.LayerManager:GetLayerWithName("DashLine")
  for _= 1, SpaceCount + 1 do
    line = Contour(0.0)
    line:AppendPoint(pt1)
    line:LineTo(pt2)
    group:AddTail(line)
 --   layer:AddObject(CreateCadContour(line), true)
    pt1 = Polar2D(pt2, CenterLine.Angle, DashLength)
    pt2 = Polar2D(pt1, CenterLine.Angle, SpaceLength)
  end -- for end
  AddGroupToJob(job, group, "DashLine")
  job:Refresh2DView()
  return true
end  -- function end
-- ===================================================]]