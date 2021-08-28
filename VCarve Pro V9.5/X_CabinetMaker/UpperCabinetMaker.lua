-- VECTRIC LUA SCRIPT
require "strict"
--Global variables

g_millClearnaceOffset = 0.010  -- can be + or - number, used for dato over sizing
g_pinShelfClarence = 0.1800
g_shelfCount = 2
g_shelfFaceFrameWidth = 1.500
g_materialThicknessBack = 0.5000
g_materialThickness = 0.7500
g_drawingUnits = 0
g_millingTool = 0
g_millOffset = 0.050  -- used for dato clearing the edge of dato 
g_defaultToolName = "No Tool Selected" 
g_toolNameLabel = "No Tool Selected" 
g_programTitle = "Cabinet Creator"
g_programVersion = "Version 1.1"
g_codeBy = "Coded by Jim Anderson 2018"
g_toolSizeDia = 0.0
g_toolSizeRadus = 0.0 
g_datoDeep = g_materialThickness * 0.5000
g_pinRadus = 0.0970
g_cabinetLenght = 36.0000
g_cabinetHeight = 28.0000
g_cabinetDepth = 12.0000
g_pinOuter = 0.7000
g_pinInter = 0.1600
g_pt1 = Point2D(2,2)
g_faceFrameSideGap = 0.2500
g_faceFrameSideWidth = 2.7500
g_faceFrameBottomWidth = 2.7500
g_faceFrameThickness = 0.7500
g_faceFrameTopWidth = 2.7500
g_faceFrameCenterWidth = 2.7500
g_faceFrameCenter = "Y"          -- Insert Center Face Frame
g_faceFrameCenter2 = "Y"         -- Insert Panel in Cabinet
g_faceFrameShelfOverlap = 0.0625
g_faceFrameBottomOverlap = 0.0625
g_faceFrameTopOverlap = 0.7500
g_holeSpacing = 2.0000
g_holeFirstRowSpacing = 4.0000
g_holeLastRowSpacing = 3.0000
g_boxHight = 0.0000
g_boxLength = 0.0000
g_boxDepth = 0.0000
g_backHight = 0.0000
g_backWidth = 0.0000
g_shelfLength = 0.0000
g_shelfDepth = 0.0000
g_stile = 0.0
g_Rails = 0.0
g_centerStile = 0.0
g_jobPath = "C://Users//CNC//Documents//Cabinet"

-- ==============================================================================================
-- Top Cabinet boxHight = (g_cabinetHeight – (g_faceFrameTopWidth + g_faceFrameBottomWidth)) + ((g_faceFrameBottomOverlap + g_materialThickness) + ( g_materialThickness + g_faceFrameTopOverlap))
-- Top Cabinet Box Hight = 27.8125 = (30.00 – (2.25 + 2.25)) + ((0.0625 + 0.75) + ( 0.75 + 0.75))
-- Top Cabinet Back Hight = (boxHight – (g_materialThickness 2.0))
-- Top Cabinet Back Hight = 27.0625 = (27.8125 – (0.375 * 2.0)) 
-- ==============================================================================================
-- Top Cabinet boxLength = (g_cabinetLenght – (g_faceframeSideGap * 2.0))
-- Top Cabinet boxLenght = 35.50 = (36.00 – (0.25 * 2.0)) 
-- Top Cabinet Back Width = (boxLength  – (g_datoDeep * 2.0))
-- Top Cabinet Back Width = 34.75 = (35.50 – (0.375 * 2.0)) 
-- ==============================================================================
function Polar2D(pt, ang, dis)
  local y_ = dis * math.sin(math.rad(ang))
  local x_ = dis * math.cos(math.rad(ang))
  return Point2D((pt.X + x_), (pt.Y + y_))
end  -- function end
-- ==============================================================================
function AddGroupToJob(job, group, layer_name)
   local cad_object = CreateCadGroup(group) ; 
   local layer = job.LayerManager:GetLayerWithName(layer_name)
   layer:AddObject(cad_object, true)
   return cad_object 
end
-- ==============================================================================
function Holer(pt, ang, dst, dia, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local group = ContourGroup(true)
    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   
    pt = Polar2D(pt, ang, dst)
    group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))   
    AddGroupToJob(job, group, lay)        
    job:Refresh2DView()
    return true   
end
-- ==============================================================================
function Alphabet(pt, letter, scl, lay)
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
    if letter == "A" then
        line:AppendPoint(pA0) ; line:LineTo(pD8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pF3) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "B" then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ;                 layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "C" then
        line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "D" then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "E" then
        line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "F" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "G" then
        line:AppendPoint(pG6) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "H" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "I" then
        line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end
    if letter == "J" then
        line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "K" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter == "L" then
        line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == "M" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == "N" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end
    if letter == "O" then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == "P" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter == "Q" then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == "R" then
        line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == "S" then
        line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)    
    end  
    if letter == "T" then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ;         layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "U" then
        line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "V" then
        line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "W" then
        line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end     
    if letter == "X" then
        line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "Y" then
        line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == "Z" then
        line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "0" then
        line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter == "1" then
        line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "2" then
        line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "3" then
        line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == "4" then
        line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "5" then
        line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "6" then
        line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter == "7" then
        line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "8" then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ; 
    end   
    if letter == "9" then
        line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter == "/" then
        line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == "+" then
        line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == "=" then
        line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == "-" then
       line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter == "'" then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0 
    end   
    if letter == "''" then
        line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end   
    if letter == "(" then
        line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end   
    if letter == ")" then
        line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter == "<" then
        line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == ">" then
        line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == "_" then
        line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter == ":" then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == "." then
        line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter == ";" then
        line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8);layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
     if letter == "#" then
         line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) 
    end    
    if letter == " " then
        pH0 = pH0 
    end   
    return pH0  
end
-- ==============================================================================
function CutListfileWriter(datFile)
    local A1 = os.date("%B %d, %Y")
    local dY = os.date("%Y")
    local dM = os.date("%m")
    local dD = os.date("%d")
    local dH = os.date("%I")
    local dMin = os.date("%M")
    if g_shelfLength == 0 then
        g_shelfLength = (g_boxLength - (g_materialThickness * 2) + (g_pinShelfClarence * 2))
        g_shelfDepth = (g_boxDepth - (g_materialThicknessBack * 0.5))
    end
    local file = io.open(datFile.. "//UpperCutList" .. dY .. dM .. dD .. dMin ..".dat", "w")
    -- write line of the file
        file:write("================================================================\n")
        file:write("===================== Upper Cabinet Cut-list ===================\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Run Date = ".. A1 .."\n")
        file:write("================================================================\n")
        file:write("Upper Cabinet size\n")
        file:write("Cabinet Hight       = ".. g_cabinetHeight .."\n")
        file:write("Cabinet Length      = ".. g_cabinetLenght .."\n")
        file:write("Cabinet Depth       = ".. g_cabinetDepth .."\n")
        file:write("Face Frame Diagonal = ".. math.sqrt ((g_cabinetHeight * g_cabinetHeight)+ (g_cabinetLenght * g_cabinetLenght)) .."\n")
        file:write("----------------------------------------------------------------")
        -- Shelf info

        if g_shelfCount >= 1 then
            file:write("Shelf Face Frame       - ".. g_shelfCount .." Pcs of ".. g_faceFrameThickness .." Hardwood ".. g_shelfFaceFrameWidth .." X ".. g_shelfLength .."     \n")
        end
        if g_shelfCount >= 1 then
            file:write("Shelf Panel            - ".. g_shelfCount .." Pcs of ".. g_materialThickness .." Plywood ".. g_shelfDepth  .." X ".. g_shelfLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 Pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameTopWidth .." X ".. g_Rails .."     \n")
        file:write("Face Frame Stiles      - 2 Pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameSideWidth .." X ".. g_stile .."     \n")
        file:write("Face Frame Bottom Rail - 1 Pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameBottomWidth .." X ".. g_Rails .."     \n")
        if g_faceFrameCenter == "Y" then
            file:write("Center Face Frame      - 1 Pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameCenterWidth .." X ".. g_centerStile .."     \n")
        end
        if g_faceFrameCenter2 == "Y" then
            file:write("Center Panel           - 1 Pcs of ".. g_materialThickness .." Plywood ".. (g_boxDepth + (g_materialThicknessBack * 0.5))  .." X ".. g_boxHight - g_materialThickness .."     \n")
        end
        file:write("Sides Panels           - 2 Pcs of ".. g_materialThickness .." Plywood ".. g_boxDepth .." X ".. g_boxHight .."\n")
        file:write("Top and Bottom Panels  - 2 Pcs of ".. g_materialThickness .." Plywood ".. g_boxDepth .." X ".. g_boxLength .."\n")
        file:write("Back Panel             - 1 Pcs of ".. g_materialThicknessBack .." Plywood ".. g_backHight .." X ".. g_backWidth .." \n") 
        if g_faceFrameCenter == "Y" then
                file:write("Center Panel           - 1 Pcs of ".. g_materialThickness .." Plywood ".. g_boxDepth - g_materialThicknessBack  .." X ".. g_boxLength - g_materialThickness .."\n")
        end
        
        file:write("----------------------------------------------------------------\n")
    -- closes the open file
    file:close()
end
-- ==============================================================================
function DrawWriter(what, where, size, lay)
    local strlen = string.len(what)
    local strup = string.upper(what)
    local x = strlen
    local i = 1
    local y = ""
    local ptx = where
    while i <= x do
      y =  string.sub(strup, i, i)
      ptx = Alphabet(ptx, y , size, lay)
      i = i + 1
    end
end
-- ==============================================================================
function TopCabinetFaceFrame(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0,   g_cabinetHeight)
    local pt3 = Polar2D(pt2, 90,  g_cabinetLenght)
    local pt4 = Polar2D(pt3, 180, g_cabinetHeight)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    g_stile = g_cabinetHeight
    g_Rails = g_cabinetLenght - (g_faceFrameSideWidth * 2.0)
    g_centerStile = g_cabinetHeight - (g_faceFrameBottomWidth + g_faceFrameTopWidth) 
    
    local pt1Text = Polar2D(g_pt1, 0,  4)
    local pt1Text = Polar2D(pt1Text, 90,  ((g_cabinetLenght * 0.5) + 8))
    DrawWriter(g_programTitle, pt1Text, 0.750, lay)
        pt1Text = Polar2D(pt1Text, 270, 1)
    DrawWriter("Version: " .. g_programVersion, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("By: " .. g_codeBy, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("= Stiles and g_Rails Cut list =", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Stiles: 2 Pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameSideWidth) .. " - " .. g_stile .. "'' long", pt1Text, 0.5, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Top Rile: 1 Pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameTopWidth) .. " - " .. g_Rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Bottom Rail: 1 Pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameBottomWidth) .. " - " .. g_Rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Pull a ruler twice and cut cut and cut some more :)", pt1Text, 0.50, lay)
    if g_faceFrameCenter == "Y" then
        pt1Text = Polar2D(pt1Text, 270, 0.75)
        DrawWriter("Center Stile: 1 Pcs " .. tostring(g_faceFrameThickness)  .. " x " .. g_faceFrameCenterWidth .. " - " .. g_centerStile .. " long", pt1Text, 0.50, lay) 
    end
  return true   
end
-- ==============================================================================
function TopCabinetShelf(lay, CountX)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    if g_shelfLength == 0 then
        g_shelfLength = (g_boxLength - (g_materialThickness * 2) + (g_pinShelfClarence * 2))
        g_shelfDepth = (g_boxDepth - (g_materialThicknessBack * 0.5))
    end

    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0,  g_shelfLength)
    local pt3 = Polar2D(pt2, 90,  g_shelfDepth)
    local pt4 = Polar2D(pt3, 180, g_shelfLength)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)

--    local pt1Text = Point2D((g_shelfLength / 2),(g_shelfDepth / 2))

    local pt1Text = Polar2D(Polar2D(g_pt1, 0,  3), 90,  (g_shelfDepth / 2))
    DrawWriter("Cabinet Shelf".. CountX .." - ".. g_materialThickness .." Plywood", pt1Text, 0.5, lay)
  return true   
end
-- ==============================================================================
function TopCabinetBack(lay)   -- Add Dato for the TopCab-CenterPanel
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, g_backHight)
    local ptC = Polar2D(g_pt1, 90, g_backWidth * 0.5)
    local pt3 = Polar2D(pt2, 90,  g_backWidth)
    local pt4 = Polar2D(pt3, 180, g_backHight)
    local ptW = g_pt1
    local ptX = g_pt1
    local ptY = g_pt1
    local ptZ = g_pt1
    ptW = Polar2D(ptC, 270,   ((g_materialThickness + g_millOffset) * 0.5))
    ptW = Polar2D(ptW, 180,   g_toolSizeDia)
    ptX = Polar2D(ptW, 90,    (g_materialThickness + g_millOffset))
    ptY = Polar2D(ptX, 0,     g_backHight + (g_toolSizeDia * 2))
    ptZ = Polar2D(ptW, 0,     g_backHight + (g_toolSizeDia * 2))
    local line = Contour(0.0)
    if g_faceFrameCenter == "Y" then
        line:AppendPoint(ptW) 
        line:LineTo(ptX)
        line:LineTo(ptY)
        line:LineTo(ptZ)
        line:LineTo(ptW)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
    end
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    
    local pt1Text = Polar2D(g_pt1, 45,  4)
    DrawWriter("Cabinet Back - ".. g_materialThicknessBack .." Plywood", pt1Text, 0.5, lay)
    return true   
end
-- ==============================================================================
function TopCabinetTandB(top, lay) -- Add Dato for the TopCab-CenterPanel
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, (g_boxLength - (g_datoDeep * 2)))
    local ptC = Polar2D(g_pt1, 0, ((g_boxLength - (g_datoDeep * 2)) * 0.5))
    local pt3 = Polar2D(pt2, 90, g_boxDepth)
    local pt4 = Polar2D(pt3, 180, (g_boxLength - (g_datoDeep * 2)))
    local ptG = g_pt1
    local ptH = g_pt1
    local ptE = g_pt1
    local ptF = g_pt1
    local ptW = g_pt1
    local ptX = g_pt1
    local ptY = g_pt1
    local ptZ = g_pt1
    local pt1Text = Polar2D(g_pt1, 45,  4)
    if top == "T" then
        ptG = Polar2D(pt3, 0,   g_toolSizeDia)
        ptH = Polar2D(ptG, 270, g_materialThicknessBack)
        ptE = Polar2D(pt4, 180, g_toolSizeDia)
        ptF = Polar2D(ptE, 270, g_materialThicknessBack)
        
        ptE = Polar2D(ptE, 90, g_millOffset)
        ptG = Polar2D(ptG, 90, g_millOffset)
        
        DrawWriter("Cabinet Top - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    else
        ptG = Polar2D(pt2, 0,     g_toolSizeDia)
        ptH = Polar2D(ptG, 90,    g_materialThicknessBack)
        ptE = Polar2D(g_pt1, 180, g_toolSizeDia)
        ptF = Polar2D(ptE, 90,    g_materialThicknessBack)
        
        ptE = Polar2D(ptE, 270, g_millOffset)
        ptG = Polar2D(ptG, 270, g_millOffset)
      
        DrawWriter("Cabinet BOTTOM - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    end
        
        ptW = Polar2D(ptC, 180,   ((g_materialThickness + g_millOffset) * 0.5))
        ptW = Polar2D(ptW, 270,   g_toolSizeDia)
        ptX = Polar2D(ptW, 0,     (g_materialThickness + g_millOffset))
        ptY = Polar2D(ptX, 90,    g_boxDepth + (g_toolSizeDia * 2))
        ptZ = Polar2D(ptW, 90,    g_boxDepth + (g_toolSizeDia * 2))
        local line = Contour(0.0)
        if g_faceFrameCenter == "Y" then
            line:AppendPoint(ptW) 
            line:LineTo(ptX)
            line:LineTo(ptY)
            line:LineTo(ptZ)
            line:LineTo(ptW)
            layer:AddObject(CreateCadContour(line), true)
            line = Contour(0.0)
        end
        line:AppendPoint(g_pt1) 
        line:LineTo(pt2)
        line:LineTo(pt3)
        line:LineTo(pt4)
        line:LineTo(g_pt1)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
        line:AppendPoint(ptE) 
        line:LineTo(ptF)
        line:LineTo(ptH)
        line:LineTo(ptG)
        line:LineTo(ptE)
        layer:AddObject(CreateCadContour(line), true)
  return true   
end
-- ==============================================================================
function TopCabinetSide(side, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, g_boxHight)
    local pt3 = Polar2D(pt2, 90, g_boxDepth)
    local pt4 = Polar2D(pt3, 180, g_boxHight)
    local ptA = g_pt1 ; local ptB = g_pt1 ;     local ptL = g_pt1 ;    local ptK = g_pt1 ;    local ptG = g_pt1 ;     local ptH = g_pt1 ;     local ptI = g_pt1 ;     local ptJ = g_pt1 ;     local ptD = g_pt1 ;    local ptC = g_pt1 ;    local ptE = g_pt1 ;    local ptF = g_pt1
    
    local pt1Text = Polar2D(g_pt1, 45,  6)
    if side == "L" then
        ptA = Polar2D(g_pt1, 270, g_toolSizeDia) ;        ptB = Polar2D(ptA,     0, g_materialThickness)
        ptL = Polar2D(pt2,   270, g_toolSizeDia) ;        ptK = Polar2D(ptL,   180, g_materialThickness)
        ptG = Polar2D(pt3,     0, g_toolSizeDia) ;        ptH = Polar2D(ptG,   270, g_materialThicknessBack)
        ptI = Polar2D(pt3,    90, g_toolSizeDia) ;        ptJ = Polar2D(ptI,   180, g_materialThickness)
        ptD = Polar2D(pt4,    90, g_toolSizeDia) ;        ptC = Polar2D(ptD,     0, g_materialThickness)
        ptE = Polar2D(pt4,   180, g_toolSizeDia) ;        ptF = Polar2D(ptE,   270, g_materialThicknessBack)
        ptA = Polar2D(ptA,   180, g_millOffset) ;        ptL = Polar2D(ptL,     0, g_millOffset)
        ptG = Polar2D(ptG,    90, g_millOffset) ;         ptI = Polar2D(ptI,     0, g_millOffset)
        ptE = Polar2D(ptE,    90, g_millOffset) ;         ptD = Polar2D(ptD,   180, g_millOffset)    
        DrawWriter("Cabinet Left Side - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    else
        ptA = Polar2D(g_pt1, 270, g_toolSizeDia) ;         ptB = Polar2D(ptA,     0, g_materialThickness)
        ptL = Polar2D(pt2,   270, g_toolSizeDia) ;         ptK = Polar2D(ptL,   180, g_materialThickness)
        ptI = Polar2D(pt3,    90, g_toolSizeDia) ;         ptJ = Polar2D(ptI,   180, g_materialThickness)
        ptD = Polar2D(pt4,    90, g_toolSizeDia) ;         ptC = Polar2D(ptD,     0, g_materialThickness)
        ptG = Polar2D(pt2,     0, g_toolSizeDia) ;         ptH = Polar2D(ptG,    90, g_materialThicknessBack)
        ptE = Polar2D(g_pt1, 180, g_toolSizeDia) ;         ptF = Polar2D(ptE,    90, g_materialThicknessBack)
   -- Right Side
        ptL = Polar2D(ptL,     0, g_millOffset) ;         ptI = Polar2D(ptI,     0, g_millOffset)
   -- Back Side
        ptG = Polar2D(ptG,   270, g_millOffset) ;         ptE = Polar2D(ptE,   270, g_millOffset)
   -- Left Side
        ptD = Polar2D(ptD,   180, g_millOffset)   ;        ptA = Polar2D(ptA,   180, g_millOffset)
        DrawWriter("Cabinet Right Side - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    end
        local line = Contour(0.0)
        line:AppendPoint(g_pt1) ;         line:LineTo(pt2) ;         line:LineTo(pt3) ;         line:LineTo(pt4) ;         line:LineTo(g_pt1) ;         layer:AddObject(CreateCadContour(line), true) ;         line = Contour(0.0)
-- top dato
        line:AppendPoint(ptA) ;         line:LineTo(ptB) ;         line:LineTo(ptC) ;         line:LineTo(ptD) ;         line:LineTo(ptA) ;        layer:AddObject(CreateCadContour(line), true)
-- back dato
        line = Contour(0.0) ;         line:AppendPoint(ptE)  ;         line:LineTo(ptF) ;         line:LineTo(ptH) ;         line:LineTo(ptG) ;         line:LineTo(ptE) ;        layer:AddObject(CreateCadContour(line), true)
-- bottom dato
        line = Contour(0.0) ;         line:AppendPoint(ptI)  ;         line:LineTo(ptJ) ;         line:LineTo(ptK) ;          line:LineTo(ptL) ;        line:LineTo(ptI) ;         layer:AddObject(CreateCadContour(line), true)
        local ptx = g_pt1 ;         local anx = 0
    if side == "L" then
            ptx = Polar2D(Polar2D(g_pt1, 0, (g_holeFirstRowSpacing + g_materialThickness)), 90, ((g_boxDepth - g_materialThicknessBack) * g_pinInter)) ;            anx = 90
        else
            ptx = Polar2D(Polar2D(pt4, 0, (g_holeFirstRowSpacing + g_materialThickness)), 270, ((g_boxDepth - g_materialThicknessBack) * g_pinInter)) ;            anx = 270
    end
    local spc = ((g_boxDepth - g_materialThickness) * g_pinOuter)
    local rows = ((g_boxHight - (g_holeFirstRowSpacing + g_holeLastRowSpacing + (g_materialThickness * 2.0))) / g_holeSpacing)
    while (rows > 0) do
        Holer (ptx, anx, spc, g_pinRadus, lay)
         ptx = Polar2D(ptx, 0, g_holeSpacing)
        rows = (rows - 1.0)
    end
    
  return true   
end
-- ==============================================================================
function TopCenterPanel(lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, g_boxHight)
    local pt3 = Polar2D(pt2, 90, g_boxDepth)
    local pt4 = Polar2D(pt3, 180, g_boxHight)
    local ptA = g_pt1 ;
    local ptB = g_pt1 ;
    local ptL = g_pt1 ;
    local ptK = g_pt1 ;
    local ptG = g_pt1 ;
    local ptH = g_pt1 ;
    local ptI = g_pt1 ;
    local ptJ = g_pt1 ;
    local ptD = g_pt1 ;
    local ptC = g_pt1 ;
    local ptE = g_pt1 ;
    local ptF = g_pt1
    
    local pt1Text = Polar2D(g_pt1, 45,  4)
    ptA = Polar2D(g_pt1, 270, g_toolSizeDia) ;        ptB = Polar2D(ptA,     0, g_materialThickness)
    ptL = Polar2D(pt2,   270, g_toolSizeDia) ;        ptK = Polar2D(ptL,   180, g_materialThickness)
    ptG = Polar2D(pt3,     0, g_toolSizeDia) ;        ptH = Polar2D(ptG,   270, g_materialThicknessBack)
    ptI = Polar2D(pt3,    90, g_toolSizeDia) ;        ptJ = Polar2D(ptI,   180, g_materialThickness)
    ptD = Polar2D(pt4,    90, g_toolSizeDia) ;        ptC = Polar2D(ptD,     0, g_materialThickness)
    ptE = Polar2D(pt4,   180, g_toolSizeDia) ;        ptF = Polar2D(ptE,   270, g_materialThicknessBack)
    ptA = Polar2D(ptA,   180, g_millOffset) ;        ptL = Polar2D(ptL,     0, g_millOffset)
    ptG = Polar2D(ptG,    90, g_millOffset) ;         ptI = Polar2D(ptI,     0, g_millOffset)
    ptE = Polar2D(ptE,    90, g_millOffset) ;         ptD = Polar2D(ptD,   180, g_millOffset)    
    DrawWriter("Cabinet Center Panel - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) ;         line:LineTo(pt2) ;         line:LineTo(pt3) ;         line:LineTo(pt4) ;         line:LineTo(g_pt1) ;         layer:AddObject(CreateCadContour(line), true) ;         line = Contour(0.0)
-- top dato
        line:AppendPoint(ptA) ;         line:LineTo(ptB) ;         line:LineTo(ptC) ;         line:LineTo(ptD) ;         line:LineTo(ptA) ;        layer:AddObject(CreateCadContour(line), true)
-- back dato
        line = Contour(0.0) ;         line:AppendPoint(ptE)  ;         line:LineTo(ptF) ;         line:LineTo(ptH) ;         line:LineTo(ptG) ;         line:LineTo(ptE) ;        layer:AddObject(CreateCadContour(line), true)
-- bottom dato
        line = Contour(0.0) ;         line:AppendPoint(ptI)  ;         line:LineTo(ptJ) ;         line:LineTo(ptK) ;          line:LineTo(ptL) ;        line:LineTo(ptI) ;         layer:AddObject(CreateCadContour(line), true)
        local ptx = g_pt1 ;         local anx = 0
    ptx = Polar2D(Polar2D(g_pt1, 0, (g_holeFirstRowSpacing + g_materialThickness)), 90, ((g_boxDepth - g_materialThicknessBack) * g_pinInter)) ;            anx = 90
    local spc = ((g_boxDepth - g_materialThickness) * g_pinOuter)
    local rows = ((g_boxHight - (g_holeFirstRowSpacing + g_holeLastRowSpacing + (g_materialThickness * 2.0))) / g_holeSpacing)

    while (rows > 0) do
        Holer (ptx, anx, spc, g_pinRadus, lay)
         ptx = Polar2D(ptx, 0, g_holeSpacing)
        rows = (rows - 1.0)
    end
    
  return true   
end
-- ==============================================================================
function LoadDialog(job, script_path)
    local registry = Registry("UpperCabinetMaker")
	local html_path = "file:" .. script_path .. "\\UpperCabinetMaker.htm"
    local dialog = HTML_Dialog(false, html_path, 850, 600,     g_programTitle)
    dialog:AddLabelField("g_programVersion",                    g_programVersion)
    dialog:AddLabelField("g_programTitle",                      g_programTitle)   
    dialog:AddLabelField("g_codeBy",                            g_codeBy)   
    dialog:AddDoubleField("g_millOffset",                       g_millOffset)  
    dialog:AddDoubleField("g_millClearnaceOffset",              g_millClearnaceOffset)
    dialog:AddDoubleField("g_materialThickness",                g_materialThickness)    
    dialog:AddDoubleField("g_pinRadus",                         g_pinRadus)    
    dialog:AddDoubleField("g_cabinetLenght",                    g_cabinetLenght)      
    dialog:AddDoubleField("g_cabinetHeight",                    g_cabinetHeight)
    dialog:AddDoubleField("g_cabinetDepth",                     g_cabinetDepth)      
    dialog:AddDoubleField("g_materialThicknessBack",            g_materialThicknessBack)      
    dialog:AddDoubleField("g_pinOuter",                         g_pinOuter)
    dialog:AddDoubleField("g_pinInter",                         g_pinInter)     
    dialog:AddDoubleField("g_pinShelfClarence",                 g_pinShelfClarence)
    dialog:AddDoubleField("g_shelfCount",                       g_shelfCount)
    dialog:AddDoubleField("g_faceFrameSideGap",                 g_faceFrameSideGap)     
    dialog:AddDoubleField("g_faceFrameSideWidth",               g_faceFrameSideWidth)      
    dialog:AddDoubleField("g_faceFrameBottomWidth",             g_faceFrameBottomWidth)
    dialog:AddDoubleField("g_shelfFaceFrameWidth",              g_shelfFaceFrameWidth)
    dialog:AddDoubleField("g_faceFrameThickness",               g_faceFrameThickness)    
    dialog:AddDoubleField("g_faceFrameTopWidth",                g_faceFrameTopWidth)
    dialog:AddDoubleField("g_faceFrameCenterWidth",             g_faceFrameCenterWidth)
    dialog:AddTextField("g_faceFrameCenter2",                   g_faceFrameCenter2)
    dialog:AddTextField("g_faceFrameCenter",                    g_faceFrameCenter)
    dialog:AddDoubleField("g_faceFrameShelfOverlap",            g_faceFrameShelfOverlap)
    dialog:AddDoubleField("g_faceFrameBottomOverlap",           g_faceFrameBottomOverlap)
    dialog:AddDoubleField("g_faceFrameTopOverlap",              g_faceFrameTopOverlap)
    dialog:AddDoubleField("g_holeSpacing",                      g_holeSpacing)
    dialog:AddDoubleField("g_holeFirstRowSpacing",              g_holeFirstRowSpacing)
    dialog:AddDoubleField("g_holeLastRowSpacing",               g_holeLastRowSpacing)
    dialog:AddLabelField("ToolNameLabel",                       g_defaultToolName)
	dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", 	g_defaultToolName)
	dialog:AddToolPickerValidToolType("ToolChooseButton",     	Tool.END_MILL)
    dialog:AddTextField("g_jobPath", g_jobPath);
    dialog:AddDirectoryPicker("g_selectJobPath",  "g_jobPath", true);
	if not dialog:ShowDialog() then
		return false
		-- Quit and return
	end
	local tool = dialog:GetTool("ToolChooseButton")
-- Collect the Dialog values and update global variables
	g_millingTool =				tool
	g_pinOuter =                tonumber(dialog:GetDoubleField("g_pinOuter"))
    g_pinInter =                tonumber(dialog:GetDoubleField("g_pinInter"))
    g_pinShelfClarence =        tonumber(dialog:GetDoubleField("g_pinShelfClarence"))
    g_materialThicknessBack =   tonumber(dialog:GetDoubleField("g_materialThicknessBack"))
    g_faceFrameSideGap =        tonumber(dialog:GetDoubleField("g_faceFrameSideGap"))
    g_faceFrameSideWidth =      tonumber(dialog:GetDoubleField("g_faceFrameSideWidth"))
    g_faceFrameBottomWidth =    tonumber(dialog:GetDoubleField("g_faceFrameBottomWidth"))
    g_millClearnaceOffset =     tonumber(dialog:GetDoubleField("g_millClearnaceOffset"))
    g_millOffset =              tonumber(dialog:GetDoubleField("g_millOffset"))
    g_materialThickness =       tonumber(dialog:GetDoubleField("g_materialThickness"))
    g_pinRadus =                tonumber(dialog:GetDoubleField("g_pinRadus"))
    g_cabinetLenght =           tonumber(dialog:GetDoubleField("g_cabinetLenght"))
    g_cabinetHeight =           tonumber(dialog:GetDoubleField("g_cabinetHeight"))
    g_shelfCount   =            tonumber(dialog:GetDoubleField("g_shelfCount"))
    g_cabinetDepth =            tonumber(dialog:GetDoubleField("g_cabinetDepth"))
    g_shelfFaceFrameWidth =     tonumber(dialog:GetDoubleField("g_shelfFaceFrameWidth"))
    g_faceFrameThickness =      tonumber(dialog:GetDoubleField("g_faceFrameThickness"))
    g_faceFrameTopWidth =       tonumber(dialog:GetDoubleField("g_faceFrameTopWidth"))
    g_faceFrameCenterWidth =    tonumber(dialog:GetDoubleField("g_faceFrameCenterWidth"))
    g_faceFrameShelfOverlap =   tonumber(dialog:GetDoubleField("g_faceFrameShelfOverlap"))
    g_faceFrameBottomOverlap =  tonumber(dialog:GetDoubleField("g_faceFrameBottomOverlap"))
    g_faceFrameTopOverlap =     tonumber(dialog:GetDoubleField("g_faceFrameTopOverlap"))
    g_holeSpacing =             tonumber(dialog:GetDoubleField("g_holeSpacing"))
    g_holeFirstRowSpacing =     tonumber(dialog:GetDoubleField("g_holeFirstRowSpacing"))
    g_holeLastRowSpacing =      tonumber(dialog:GetDoubleField("g_holeLastRowSpacing"))
    g_faceFrameCenter2 =                 dialog:GetTextField("g_faceFrameCenter2")
    g_faceFrameCenter =                  dialog:GetTextField("g_faceFrameCenter")
    g_jobPath =                          dialog:GetTextField("g_jobPath")
    g_defaultToolName =         tool.Name

	-- Recalculate finger and joint dimensions
    g_toolSizeDia = tool.ToolDia
    g_toolSizeRadus = g_toolSizeDia * 0.50 
    
	if g_millingTool == nil then
		MessageBox("No tool selected!")
		return 2
		-- 2 value will return user to Boxjoint dialog
	end
	
    if g_jobPath == "C://" then
		MessageBox("No Job Path selected!")
		return 2
		-- 2 value will return user to Boxjoint dialog
	end
    return true
end  -- function end
-- ==============================================================================
function main(script_path)
    -- create a layer with passed name if it doesnt already exist
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    local lay = "A"
    	-- loop the Dialog to get all user inputs
	repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == false then
			return false
		end		
	until ret_value == true
    g_boxHight =  g_cabinetHeight - (g_faceFrameTopWidth + g_faceFrameBottomWidth + g_faceFrameBottomOverlap + g_faceFrameTopOverlap + (g_materialThickness * 2.0))
    g_boxLength = g_cabinetLenght - (g_faceFrameSideGap * 2.0) ;     g_backHight = g_boxHight - g_materialThickness ;     g_backWidth = g_boxLength - g_materialThickness ;     g_boxDepth  = g_cabinetDepth - g_faceFrameThickness
    lay = "UpperCab-LeftSide"     ;     TopCabinetSide("L", lay)
    lay = "UpperCab-RightSide"    ;     TopCabinetSide("R", lay)
    lay = "UpperCab-Top"          ;     TopCabinetTandB("T", lay)
    lay = "UpperCab-Bottom"       ;     TopCabinetTandB("B", lay)
    lay = "UpperCab-Back"         ;     TopCabinetBack(lay) 
    local g_shelfCountX =g_shelfCount
    while (g_shelfCountX > 0) do
    --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
        lay = "UpperCab-Shelf".. g_shelfCountX        
        TopCabinetShelf(lay, g_shelfCountX)
        g_shelfCountX = g_shelfCountX - 1
    end
    lay = "UpperCab-CenterPanel"  ;     TopCenterPanel(lay)
    lay = "UpperCab-FaceFrame"    ;     TopCabinetFaceFrame(lay)
    
    CutListfileWriter(g_jobPath)
    
-- Regenerate the drawing display
	job:Refresh2DView()
    return true 
end