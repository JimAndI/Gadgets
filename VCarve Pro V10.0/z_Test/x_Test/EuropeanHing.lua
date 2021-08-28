-- VECTRIC LUA SCRIPT
require "strict"

    local HingeCount = 2
    local HingeInset = 200.0
    local HingeHoleD = 35.0  -- mm
     local HingeHoleR = HingeHoleD * 0.5  -- mm
    local HingeScrewHoleBack = 20.5  -- mm
    local HingeScrewD = 8.0  -- mm
     local HingeScrewR = HingeScrewD * 0.5  -- mm
    local HingeScrewSetBack = 11.0  -- mm
    local HingeScrewCenter= 21.0  -- mm
    
        local HingeCount = 2
    local HingeInset = 3.5
    local HingeHoleD =  1.377953
     local HingeHoleR = HingeHoleD * 0.5
    local HingeScrewHoleBack = 0.807087
    local HingeScrewD = 0.314961
     local HingeScrewR = HingeScrewD * 0.5   
    local HingeScrewSetBack = 0.433071
    local HingeScrewCenter=  0.826772
    local side = 0.0
    
-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  =*********************************************= 
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end
        local p1 = Point2D(1.0,1.0)
        local p2 = Point2D(1.0,1.0)
        local p3 = Point2D(1.0,1.0)
        local p4 = Point2D(1.0,1.0)
   local Door = job.Selection
   if Door.IsEmpty then
       MessageBox("Select a single closed vector of the outer door edge")
       return false  
    end
    local Door_pos = Door:GetHeadPosition()
    local objects;   objects, Door_pos = Door:GetNext(Door_pos)
    local contour = objects:GetContour()     
    if (objects.ClassName ~= "vcCadPolyline") then
              DisplayMessageBox("Select a single closed vector of the outer door edge")
              contour = nil
    end
    -- DisplayMessageBox(tostring(objects.ClassName))
    if contour ~= nil then
         local Doorbound = contour.BoundingBox2D
         --DisplayMessageBox(tostring(Doorbound.BRC.X) .. " x " .. tostring(Doorbound.BRC.Y))
         --DisplayMessageBox(tostring(Doorbound.TLC.X) .. " x " .. tostring(Doorbound.TLC.Y))
         if side == 0.0 then
                   p1 = Doorbound.BRC
                   p2 = Doorbound.TRC
                   p3 = Polar2D(p1,  90.0,  HingeInset) 
                   p4 = Polar2D(p2,  270.0,  HingeInset) 
         end
        if side == 90.0 then
                   p1 = Doorbound.TLC
                   p2 = Doorbound.TRC        
                   p3 = Polar2D(p1,  0.0,  HingeInset) 
                   p4 = Polar2D(p2,  180.0,  HingeInset)                   
         end 
        if side == 180.0 then
                   p1 = Doorbound.TLC
                   p2 = Doorbound.BLC
                   p3 = Polar2D(p1,  270.0,  HingeInset) 
                   p4 = Polar2D(p2,  90.0,  HingeInset)          
         end 
         if side == 270.0 then
                   p1 = Doorbound.BLC
                   p2 = Doorbound.BRC
                   p3 = Polar2D(p1,   0.0,  HingeInset) 
                   p4 = Polar2D(p2,  180.0,  HingeInset)     
         end 
    end
     DrawHingeHole(job, p3, side)
     DrawHingeHole(job, p4, side)
    job:Refresh2DView()
    return true 
end
-- ==================================================
function DrawHingeHole(job, pt, ang)
    local phcp = Polar2D(pt,  ang  + 180.0,  HingeScrewHoleBack)          
    local pt1 = Polar2D(phcp,  0.0,  HingeHoleR)  
    local pt2 = Polar2D(phcp,  180.0,  HingeHoleR)  
    local phsp = Polar2D(phcp,  ang  + 180.0, HingeScrewSetBack)   
    local phsp1 = Polar2D(phsp,  ang + 90.0,  HingeScrewCenter)          
    local phsp2 = Polar2D(phsp,  ang + 270.0,  HingeScrewCenter)        
    local line  =  Contour(0.0)  ; 
    local layer  =  job.LayerManager:GetLayerWithName("HingeHole")  ; 
    line:AppendPoint(pt1)   ; 
    line:ArcTo(pt2 , 1)  ; 
    line:ArcTo(pt1 , 1)  ; 
    layer:AddObject(CreateCadContour(line), true)  ;
    local pt1 = Polar2D(phsp1,  0.0,  HingeScrewR)  
    local pt2 = Polar2D(phsp1,  180.0,  HingeScrewR)  
    local line  =  Contour(0.0)  ; 
    local layer  =  job.LayerManager:GetLayerWithName("HingeScrewHole")  ; 
    line:AppendPoint(pt1)   ; 
    line:ArcTo(pt2 , 1)  ; 
    line:ArcTo(pt1 , 1)  ; 
    layer:AddObject(CreateCadContour(line), true)  ; 
    local pt1 = Polar2D(phsp2,  0.0,  HingeScrewR)  
    local pt2 = Polar2D(phsp2,  180.0,  HingeScrewR)  
    local line  =  Contour(0.0)  ; 
    local layer  =  job.LayerManager:GetLayerWithName("HingeScrewHole")  ; 
    line:AppendPoint(pt1)   ; 
    line:ArcTo(pt2 , 1)  ; 
    line:ArcTo(pt1 , 1)  ; 
    layer:AddObject(CreateCadContour(line), true)  ; 
    return true  
end
--  =============== End ===============================

