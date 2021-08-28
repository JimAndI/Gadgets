-- VECTRIC LUA SCRIPT
require "strict"
--Global variables

g_millClearnaceOffset = 0.010  -- can be + or - number, used for dato over sizing
g_millOffset = 0.050  -- used for dato clearing the edge of dato 
g_toolSizeRadus = 0.125 
g_drawingUnits  = " inches"
g_millingTool = nil 
g_defaultToolName = "" 
g_programTitle = "Cabinet Creator"
g_programVersion = "1.1"
g_codeBy = "Jim Anderson 2018"
g_toolSizeDia = (g_toolSizeRadus * 2.0000)
g_materialThickness = 0.7500
g_datoDeep = g_materialThickness * 0.5000
g_pinRadus = 0.0970
g_cabinetLenght = 36.0000
g_cabinetHeight = 28.0000
g_cabinetDepth = 12.0000
g_cabinetBottomLenght = 48.0000
g_cabinetBottomHeight = 34.0000
g_cabinetBottomDepth = 22.0000
g_pinOuter = 0.7000
g_pinInter = 0.1600
g_pinShelfClarence = 0.1800
g_pt1 = Point2D(2,2)
g_materialThicknessBack = 0.5000
g_faceFrameSideGap = 0.2500
g_faceFrameSideWidth = 2.7500
g_faceFrameBottomWidth = 2.7500
g_faceFrameThickness = 0.7500
g_faceFrameTopWidth = 2.7500
g_faceFrameCenterWidth = 2.7500
g_faceFrameCenter = "Y"
g_faceFrameShelfOverlap = 0.0625
g_faceFrameBottomOverlap = 0.0625
g_faceFrameTopOverlap = 0.7500

g_holeSpacing = 2.0000
g_holeFirstRowSpacing = 4.0000
g_holeLastRowSpacing = 3.0000
g_boxHight = 0.0000
g_boxLength = 0.0000
g_backHight = 0.0000
g_backWidth = 0.0000
g_boxDepth = 0.0000
g_toeKickDepth = 4.0000
g_toeKickHight = 3.5000
g_toeKickBottomOffsetHight = 0.5000

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
    local stile = g_cabinetHeight
    local rails = g_cabinetLenght - (g_faceFrameSideWidth * 2.0)
    local cRail = g_cabinetHeight - (g_faceFrameBottomWidth + g_faceFrameTopWidth) 
    local pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 8))
    DrawWriter(g_programTitle, pt1Text, 0.750, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 7))
    DrawWriter("Version: " .. g_programVersion, pt1Text, 0.50, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 6))
    DrawWriter("By: " .. g_codeBy, pt1Text, 0.50, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 5))
    DrawWriter("= Stiles and Rails Cut list =", pt1Text, 0.50, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 4))
    DrawWriter("Stiles: 2 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameSideWidth) .. " - " .. tostring(g_cabinetHeight) .. "'' long", pt1Text, 0.5, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 3))
    DrawWriter("Top Rile: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameTopWidth) .. " - " .. rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 2))
    DrawWriter("Bottom Rail: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameBottomWidth) .. " - " .. rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Point2D((g_cabinetHeight * 0.5),((g_cabinetLenght * 0.5) + 1))
    DrawWriter("Pull a ruller twice and cut cut and cut some more :)", pt1Text, 0.50, lay)
    if g_faceFrameCenter == "Y" then
        pt1Text = Point2D((g_cabinetHeight * 0.5),(g_cabinetLenght * 0.5))
        DrawWriter("Center Stile: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. g_faceFrameCenterWidth .. " - " .. cRail .. " long", pt1Text, 0.50, lay) 
    end
  return true   
end
-- ==============================================================================
    function  TopCabinetShelf(lay)   
        local job = VectricJob()
        if not job.Exists then
            DisplayMessageBox("No job loaded")
            return false;
        end
        local layer = job.LayerManager:GetLayerWithName(lay)
        local pt2 = Polar2D(g_pt1, 0,   (g_boxHight - (g_datoDeep * 2)))
        local pt3 = Polar2D(pt2, 90,  (g_boxLength -  (g_datoDeep * 2)))
        local pt4 = Polar2D(pt3, 180, (g_boxHight - (g_datoDeep * 2)))
        local line = Contour(0.0)
        line:AppendPoint(g_pt1) 
        line:LineTo(pt2)
        line:LineTo(pt3)
        line:LineTo(pt4)
        line:LineTo(pt1)
        layer:AddObject(CreateCadContour(line), true)
        (g_boxHight / 2)
        local pt1Text = Point2D((g_boxHight / 2),(g_boxDepth / 2))
        DrawWriter("Cabinet Shilf", pt1Text, 0.5, lay)
      return true   
    end
-- ==============================================================================
    function  TopCabinetBack(lay)   
        local job = VectricJob()
        if not job.Exists then
            DisplayMessageBox("No job loaded")
            return false;
        end
        local layer = job.LayerManager:GetLayerWithName(lay)
        local pt2 = Polar2D(g_pt1, 0,   g_backHight)
        local pt3 = Polar2D(pt2, 90,  g_backWidth)
        local pt4 = Polar2D(pt3, 180, g_backHight)
        local line = Contour(0.0)
        line:AppendPoint(g_pt1) 
        line:LineTo(pt2)
        line:LineTo(pt3)
        line:LineTo(pt4)
        line:LineTo(g_pt1)
        layer:AddObject(CreateCadContour(line), true)
        local pt1Text = Point2D((g_boxHight / 2),(g_boxLength / 2))
        DrawWriter("Cabinet Back", pt1Text, 0.5, lay)
        return true   
    end
-- ==============================================================================
function TopCabinetTandB(top, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, (g_boxLength - (g_datoDeep * 2)))
    local pt3 = Polar2D(pt2, 90, g_boxDepth)
    local pt4 = Polar2D(pt3, 180, (g_boxLength - (g_datoDeep * 2)))
    local ptG = g_pt1
    local ptH = g_pt1
    local ptE = g_pt1
    local ptF = g_pt1
    local pt1Text = Point2D((g_boxLength / 2),(g_boxDepth / 2))
    if top == "T" then
        ptG = Polar2D(pt3, 0,   g_toolSizeDia)
        ptH = Polar2D(ptG, 270, g_materialThicknessBack)
        ptE = Polar2D(pt4, 180, g_toolSizeDia)
        ptF = Polar2D(ptE, 270, g_materialThicknessBack)
        
        ptE = Polar2D(ptE, 90, g_millOffset)
        ptG = Polar2D(ptG, 90, g_millOffset)
        
        DrawWriter("Cabinet Top", pt1Text, 0.5000, lay)
    else
        ptG = Polar2D(pt2, 0,     g_toolSizeDia)
        ptH = Polar2D(ptG, 90,    g_materialThicknessBack)
        ptE = Polar2D(g_pt1, 180, g_toolSizeDia)
        ptF = Polar2D(ptE, 90,    g_materialThicknessBack)
        
        ptE = Polar2D(ptE, 270, g_millOffset)
        ptG = Polar2D(ptG, 270, g_millOffset)
      
        DrawWriter("Cabinet BOTTOM", pt1Text, 0.5000, lay)
    end
        local line = Contour(0.0)
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
    local pt1Text = Point2D((g_boxHight * 0.5),(g_boxDepth * 0.5))
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
        
        DrawWriter("Cabinet Left Side", pt1Text, 0.5000, lay)
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
        DrawWriter("Cabinet Right Side", pt1Text, 0.5000, lay)
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
    -- MessageBox(tostring(rows))
    while (rows > 0) do
        Holer (ptx, anx, spc, g_pinRadus, lay)
         ptx = Polar2D(ptx, 0, g_holeSpacing)
        rows = (rows - 1.0)
    end
    
  return true   
end
-- ==============================================================================
function BottomCabinetSide(side, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    
    local pt2 = Polar2D(g_pt1, 0, g_boxHight)
    local pt3 = Polar2D(pt2, 90, g_boxDepth)
    local pt4 = Polar2D(pt3, 180, g_boxHight)
    local pt5 = Polar2D(pt4, g_boxHight)
    local ptA = g_pt1 ; local ptB = g_pt1 ;     local ptL = g_pt1 ;    local ptK = g_pt1 ;    local ptG = g_pt1 ;     local ptH = g_pt1 ;     local ptI = g_pt1 ;     local ptJ = g_pt1 ;     local ptD = g_pt1 ;    local ptC = g_pt1 ;    local ptE = g_pt1 ;    local ptF = g_pt1
    local pt1Text = Point2D((g_boxHight * 0.5),(g_boxDepth * 0.5))
    
    if side == "L" then
        ptA = Polar2D(g_pt1, 270, g_toolSizeDia)
        ptB = Polar2D(ptA,     0, g_materialThickness)
        ptL = Polar2D(pt2,   270, g_toolSizeDia) 
        ptK = Polar2D(ptL,   180, g_materialThickness)
        ptG = Polar2D(pt3,     0, g_toolSizeDia) 
        ptH = Polar2D(ptG,   270, g_materialThicknessBack)
        ptI = Polar2D(pt3,    90, g_toolSizeDia)
        ptJ = Polar2D(ptI,   180, g_materialThickness)
        ptD = Polar2D(pt4,    90, g_toolSizeDia) 
        ptC = Polar2D(ptD,     0, g_materialThickness)
        ptE = Polar2D(pt4,   180, g_toolSizeDia) 
        ptF = Polar2D(ptE,   270, g_materialThicknessBack)
        ptA = Polar2D(ptA,   180, g_millOffset) 
        ptL = Polar2D(ptL,     0, g_millOffset)
        ptG = Polar2D(ptG,    90, g_millOffset) 
        ptI = Polar2D(ptI,     0, g_millOffset)
        ptE = Polar2D(ptE,    90, g_millOffset)
        ptD = Polar2D(ptD,   180, g_millOffset)    
        
        DrawWriter("Base Cabinet Left Side", pt1Text, 0.5000, lay)
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
        DrawWriter("Base Cabinet Right Side", pt1Text, 0.5000, lay)
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
    -- MessageBox(tostring(rows))
    while (rows > 0) do
        Holer (ptx, anx, spc, g_pinRadus, lay)
         ptx = Polar2D(ptx, 0, g_holeSpacing)
        rows = (rows - 1.0)
    end
    
  return true   
end
-- ==============================================================================
function LoadDialog(job, script_path)
	local registry = Registry("BoxjointToolpath")
	local html_path = "file:" .. script_path .. "\\Boxjoint_Maker.htm"
	local dialog = HTML_Dialog(false, html_path, 675, 600, g_title)
	dialog:AddLabelField("GadgetVersion",                   	g_version)
	dialog:AddDoubleField("NoFingers0",                    		g_NoFingers0)
	dialog:AddDoubleField("MaterialThickness",                	g_MaterialThickness)
	dialog:AddDoubleField("MaterialLength", 	       			g_MaterialLength)
    dialog:AddLabelField("DrawingUntsLabel",                    g_units)
	dialog:AddLabelField("ToolNameLabel",                     	"No Tool Selected")
	dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", 	g_default_tool_name)
	dialog:AddToolPickerValidToolType("ToolChooseButton",     	Tool.END_MILL)

	if not dialog:ShowDialog() then
		return false
		-- Quit and return
	end

	local tool = dialog:GetTool("ToolChooseButton")
	if tool == nil then
		MessageBox("No tool selected!")
		return 2
		-- 2 value will return user to Boxjoint dialog
	end

	-- Collect the Dialog values and update global variables
	g_tool =				tool
	--g_MaterialThickness =   tonumber(dialog:GetDoubleField("MaterialThickness"))
	--g_MaterialLength =   	tonumber(dialog:GetDoubleField("MaterialLength"))
	g_NoFingers0 =   	    tonumber(dialog:GetDoubleField("NoFingers0"))
	g_default_tool_name = 	tool.Name

  
	-- Recalculate finger and joint dimensions
	g_ToolSize = tool.ToolDia
  	g_NoFingers2 = Round(g_NoFingers0 / 2)
	g_FingerSize = g_MaterialLength /  g_NoFingers0   
	g_NoFingers1 = g_NoFingers0 - g_NoFingers2
	
	-- Validate the bit diameter can cut the slot gap
	if tool.ToolDia > g_FingerSize then
	    MessageBox("The bit is too larger for the number of Fingers")
		return 2
		-- 2 value will return user to Boxjoint dialog
	end

	return true
end  -- function end

-- ______________________________________________________________________________

-- ==============================================================================

function main(script_path)
    -- create a layer with passed name if it doesnt already exist
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    local lay = "A"
    
    	-- Keep looping the Dialog to get all user inputs
	repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == false then
			return false
		end		
	until ret_value == true
    
    
    g_boxHight =  g_cabinetHeight - (g_faceFrameTopWidth + g_faceFrameBottomWidth + g_faceFrameBottomOverlap + g_faceFrameTopOverlap + (g_materialThickness * 2.0))
    g_boxLength = g_cabinetLenght - (g_faceFrameSideGap * 2.0) ;     g_backHight = g_boxHight - (g_materialThickness * 2.0) ;     g_backWidth = g_boxLength - (g_datoDeep * 2.0) ;     g_boxDepth  = g_cabinetDepth - g_faceFrameThickness

    lay = "TopCab-LeftSide"    ;    TopCabinetSide("L", lay)

    --[[    DO NOT DELETE

    lay = "TopCab-RightSide"   ;    TopCabinetSide("R", lay)
    lay = "TopCab-Top"    ;     TopCabinetTandB("T", lay)
    lay = "TopCab-Bottom"   ;     TopCabinetTandB("B", lay)
    lay = "TopCab-Back"    ;     TopCabinetBack(lay)  
    lay = "TopCab-FaceFrame" ;     TopCabinetFaceFrame (lay)

    
    lay = "BottomCab-RightSide"   ;     BottomCabinetSide("R", lay)

    lay = "BottomCab-LeftSide"   ;     BottomCabinetSide("L", lay)
    lay = "BottomCab-Bottom"   ;     BottomCabinetBottom(lay)
    lay = "BottomCab-Toe"   ;     BottomCabinetToe(lay)
    lay = "BottomCab-Back"   ;     BottomCabinetBack(lay)
    lay = "BottomCab-TopFrame"   ;     BottomCabinetTopFrame(lay)
    lay = "BottomCab-FaceFrame" ;     BottomCabinetFaceFrame (lay)
]]
    
-- Regenerate the drawing display
	job:Refresh2DView()
    return true 
end