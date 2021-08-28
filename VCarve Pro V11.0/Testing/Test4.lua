-- VECTRIC LUA SCRIPT
-- require "strict"
require("mobdebug").start()
--Global variables
-- =====================================================]]
local function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==============================================================================
function DrawCircle(Pt1, CenterRadius, Layer)
  --[[ ==Draw Circle==
  function main(script_path)
  local MyPt1 = Point2D(1.0,1.0)
  local MyRad = 3.0
  local layer = "My Box"
  DrawCircle(MyPt1, MyRad, Layer)
  return true
  end -- function end
-- -----------------------------------------------------]]
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: No job loaded")
    return false ;
  end -- if end
  local pa = Polar2D(Pt1,   180.0, CenterRadius)
  local pb = Polar2D(Pt1,     0.0, CenterRadius)
  local line = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(pa) ;
  line:ArcTo(pb,1);
  line:ArcTo(pa,1);
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
-- ==============================================================================
function main()
    -- create a layer with passed name if it doesn't already exist
  local job = VectricJob()
  if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;
  end
  local selection = job.Selection
  local pos = selection:GetHeadPosition()
  local object
  object, pos = selection:GetNext(pos)
  local pos1 = object:GetContour()
  DrawCircle(pos1.StartPoint2D, 0.25, "Jim")
  DrawCircle(pos1.EndPoint2D, 0.5, "Jim")
	job:Refresh2DView()
  return true
end