-- VECTRIC LUA SCRIPT
require "strict"
--Global variables
g_txtPt = Point2D(10.0,10.0)
-- ==============================================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end  -- function end
-- ==============================================================================

function CADLeters(pt, letter, scl, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    scl = (scl * 0.5)
    local pA0 = pt
    local pA1 = Polar2D(pt, 90.0000, (0.2500 * scl)) ;    local pA2 = Polar2D(pt, 90.0000, (0.5000 * scl)) ;    local pA3 = Polar2D(pt, 90.0000, (0.7500 * scl)) ;    local pA4 = Polar2D(pt, 90.0000, (1.0000 * scl)) ;    local pA5 = Polar2D(pt, 90.0000, (1.2500 * scl)) ;    local pA6 = Polar2D(pt, 90.0000, (1.5000 * scl)) ;    local pA7 = Polar2D(pt, 90.0000, (1.7500 * scl)) ;    local pA8 = Polar2D(pt, 90.0000, (2.0000 * scl))
    local pB0 = Polar2D(pt,  0.0000, (0.2500 * scl)) ;    local pB1 = Polar2D(pt, 45.0000, (0.3536 * scl)) ;    local pB3 = Polar2D(pt, 71.5651, (0.7906 * scl)) ;    local pB4 = Polar2D(pt, 75.9638, (1.0308 * scl)) ;    local pB5 = Polar2D(pt, 78.6901, (1.2748 * scl)) ;    local pB7 = Polar2D(pt, 81.8699, (1.7678 * scl)) ;    local pB8 = Polar2D(pt, 82.8750, (2.0156 * scl)) ;    local pB10 = Polar2D(pt, 84.2894, (2.5125 * scl)) 
    local pC0 = Polar2D(pt,  0.0000, (0.5000 * scl)) ;    local pC2 = Polar2D(pt, 45.0000, (0.7071 * scl)) ;    local pC8 = Polar2D(pt, 75.9638, (2.0616 * scl)) ;    local pC10 = Polar2D(pt,78.6901, (2.5125 * scl)) ;    local pD0 = Polar2D(pt,  0.0000, (0.6250 * scl)) ;    local pD1 = Polar2D(pt, 21.8014, (0.6731 * scl)) ;    local pD4 = Polar2D(pt, 57.9946, (1.1792 * scl)) ;    local pD7 = Polar2D(pt, 70.3462, (1.8583 * scl))
    local pD8 = Polar2D(pt, 72.6460, (2.0954 * scl)) ;    local pE0 = Polar2D(pt,  0.0000, (0.7500 * scl)) ;    local pE2 = Polar2D(pt, 33.6901, (0.9014 * scl)) ;    local pE3 = Polar2D(pt, 45.0000, (1.0607 * scl)) ;    local pE8 = Polar2D(pt, 69.4440, (2.1360 * scl)) ;    local pF0 = Polar2D(pt,  0.0000, (1.0000 * scl)) ;    local pF3 = Polar2D(pt, 36.8699, (1.2500 * scl)) ;    local pF4 = Polar2D(pt, 45.0000, (1.4142 * scl))
    local pF7 = Polar2D(pt, 60.2551, (2.0156 * scl)) ;    local pF8 = Polar2D(pt, 63.4349, (2.2361 * scl)) ;    local pF10 = Polar2D(pt,59.0362, (2.9155 * scl)) ;    local pG0 = Polar2D(pt,  0.0000, (1.2500 * scl)) ;    local pG1 = Polar2D(pt, 11.3099, (1.2748 * scl)) ;    local pG2 = Polar2D(pt, 21.8014, (1.3463 * scl)) ;    local pG3 = Polar2D(pt, 30.9638, (1.4577 * scl)) ;    local pG4 = Polar2D(pt, 38.6598, (1.6008 * scl))
    local pG5 = Polar2D(pt, 45.0000, (1.7678 * scl)) ;    local pG6 = Polar2D(pt, 50.1944, (1.9526 * scl)) ;    local pG7 = Polar2D(pt, 54.4623, (2.1506 * scl)) ;    local pG8 = Polar2D(pt, 57.9946, (2.3585 * scl)) ;    local pH0 = Polar2D(pt,  0.0000, (1.5000 * scl)) ;    local pH10 = Polar2D(pt,63.4349, (2.7951 * scl))
    local group = ContourGroup(true)
    local layer = job.LayerManager:GetLayerWithName(lay)
    local line = Contour(0.0) 
    if letter == 65 then  -- A
        line:AppendPoint(pA0) ;        line:LineTo(pD8) ;         line:LineTo(pG0) ;         layer:AddObject(CreateCadContour(line), true) ;        line = Contour(0.0) ;        line:AppendPoint(pF3) ;        line:LineTo(pB3) ;        layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 66 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ;                 layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 67 then
        line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 68 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 69 then
        line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 70 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 71 then
        line:AppendPoint(pG6) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end

    if letter == 72 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 73 then
        line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end
    if letter == 74 then
        line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 75 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == 76 then
        line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 77 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 78 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end
    if letter == 79 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 80 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == 81 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 82 then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 83 then
        line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)    
    end  
    if letter == 84 then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ;         layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 85 then
        line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 86 then
        line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 87 then
        line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end     
    if letter == 88 then
        line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 89 then
        line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 90 then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 48 then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == 49 then
        line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 50 then
        line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 51 then
        line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 52 then
        line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 53 then
        line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 54 then
        line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == 55 then
        line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 56 then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ; 
    end   
    if letter == 57 then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == 47 then
        line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 43 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 61 then
        line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 45 then
       line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == 39 then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0 
    end   
    if letter == 34 then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end   
    if letter == 40 then
        line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end   
    if letter == 41 then
        line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == 60 then
        line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 62 then
        line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 95 then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 58 then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 46 then
        line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == 59 then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
     if letter == 35 then
         line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) 
    end    
    if letter == 32 then
        pH0 = pH0 
    end   
    if letter == 33 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 36 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 37 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 38 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 42 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 63 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 64 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 91 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 92 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 93 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 94 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 96 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 123 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 124 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 125 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == 126 then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end 

    return pH0  
end
-- ==============================================================================
function DrawWriter(what, where, size, lay)
    local strlen = string.len(what)
    local strup = string.upper(what)
    local x = strlen
    local i = 1
    local y = ""
    local g_txtPt = where
    while i <= x do
      y =  string.byte(string.sub(strup, i, i))
      g_txtPt = CADLeters(g_txtPt, y , size, lay)
      i = i + 1
    end
end
-- ==============================================================================
function BuildLine(pt1, pt2)
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
function main()
    local lay = "A"
                                                                                local job = VectricJob()
                                                                                if not job.Exists then
                                                                                    DisplayMessageBox("No job loaded")
                                                                                    return false
                                                                                end
    -- Clear any current selection
   -- local selection = job.Selection
   -- selection:Clear()
                                                                                local layer = job.LayerManager:GetLayerWithName(lay)
                                                                                local a_group = ContourGroup(true) 
                                                                                local b_group = ContourGroup(true) 
                                                                                local pt1 = Point2D(3.0,3.0)
                                                                                a_group:AddTail(BuildBox(pt1, 12, 22))
                                                                                pt1 = Point2D(23.0, 23.0)
                                                                                b_group:AddTail(BuildBox(pt1, 12, 22))
                                                                                b_group:AddTail(BuildLine(Point2D(12.0,31.0), Point2D(12.0,13.0)))
                                                                                b_group:AddTail(BuildLine(Point2D(42.0,22.0), Point2D(13.0,33.0)))
                                                                                pt1 = Point2D(13.0, 13.0)
                                                                                a_group:AddTail(BuildCircle(pt1, 1.5))
                                                                                pt1 = Point2D(23.0, 23.0)
                                                                                b_group:AddTail(BuildCircle(pt1, 1.5))
                                                                                layer:AddObject(CreateCadGroup(a_group), true)  
                                                                                layer:AddObject(CreateCadGroup(b_group), true)  
                                                                                DrawWriter("ABCD", g_txtPt, 0.5000, lay)
                                                                                job:Refresh2DView() 

 --if not SelectVectorsOnLayer(lay, selection, true, true, false) then
 --       DisplayMessageBox("No vectors found on layer " .. lay)
 --       return false
 --   end

                                                                                return true   
end -- function end
-- ==============================================================================
--[[  ---------------- SelectVectorsOnLayer ----------------  
|
|   Add all the vectors on the layer to the selection
|     layer,            -- layer we are selecting vectors on
|     selection         -- selection object
|     select_closed     -- if true  select closed objects
|     select_open       -- if true  select open objects
|     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
|  Return Values:
|     true if selected one or more vectors
|
]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
   local objects_selected = false
   local warning_displayed = false
   local pos = layer:GetHeadPosition()
      while pos ~= nil do
	     local object
         object, pos = layer:GetNext(pos)
         local contour = object:GetContour()
         if contour == nil then
            if (object.ClassName == "vcCadObjectGroup") and select_groups then
               selection:Add(object, true, true)
               objects_selected = true
            else 
               if not warning_displayed then
                  local message = "Object(s) without contour information found on layer - ignoring"
                  if not select_groups then
                     message = message .. 
                               "\r\n\r\n" .. 
                               "If layer contains grouped vectors these must be ungrouped for this script"
                  end
                  DisplayMessageBox(message)
                  warning_displayed = true
               end   
            end
         else  -- contour was NOT nil, test if Open or Closed
            if contour.IsOpen and select_open then
               selection:Add(object, true, true)
               objects_selected = true
            else if select_closed then
               selection:Add(object, true, true)
               objects_selected = true
            end            
         end
         end
      end  
   -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
   -- tell selection we have now finished updating
   if objects_selected then
      selection:GroupSelectionFinished()
   end   
   return objects_selected   
end  