-- VECTRIC LUA SCRIPT
require "strict"
--Global variables
-- ==============================================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                 (pt.Y + dis * math.sin(math.rad(ang)))
                )
end  -- function end
-- ==============================================================================
function BuildLine(lc, pt1, pt2)
    local line = Contour(0.0);     -- use default tolerance
    line:AppendPoint(pt1) 
    line:LineTo(pt2) 
    return line
end  -- function end
-- ==============================================================================
function BuildBox(pt1, xx, yy)
    local line = Contour(0.0);     -- use default tolerance
    line:AppendPoint(pt1) 
    line:LineTo(Polar2D(pt1, 0, xx)) 
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) 
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) 
    line:LineTo(pt1) 
    return line
end -- function end
-- ==============================================================================
function BuildCircle(pt1, rad)
    local line = Contour(0.0)
    line:AppendPoint(Polar2D(pt1, 0, rad))    
    line:ArcTo(Polar2D(pt1, 180, rad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, rad), 1.0)
    return line
end -- function end
-- ==============================================================================
function main(script_path)
    local lay = "A"
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local a_group = ContourGroup(true) 
    local pt1 = Point2D(3.0,3.0)
    a_group:AddTail(BuildBox(pt1, 12, 22))
          pt1 = Point2D(23.0,23.0)
    a_group:AddTail(BuildBox(pt1, 12, 22))
          pt1 = Point2D(13.0,13.0)
    a_group:AddTail(BuildCircle(pt1, 1.5) )
    layer:AddObject(CreateCadGroup(a_group), true)  
    job:Refresh2DView()
    return true   
end -- function end
-- ==============================================================================
