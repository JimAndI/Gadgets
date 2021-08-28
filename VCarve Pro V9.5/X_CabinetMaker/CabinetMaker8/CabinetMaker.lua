-- VECTRIC LUA SCRIPT
require "strict"
--Global variables
g_millClearnaceOffset = 0.010  -- can be + or - number, used for dato over sizing
g_pinShelfClarence = 0.1800
g_shelfPinDiameter = 0.194
g_shelfCount = 2.0
g_shelfFaceFrameWidth = 1.500
g_shelfWidthClearance = 0.25
g_materialThicknessBack = 0.5000
g_materialThickness = 0.7500
g_drawingUnits = 0.0
g_millingTool = 0.0
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
g_upperCabinetLenght = 36.0000
g_upperCabinetHeight = 28.0000
g_upperCabinetDepth = 12.0000
g_pinOuter = 0.7000
g_pinInter = 0.1600
g_pt1 = Point2D(2,2)
g_faceFrameSideGap = 0.25
g_faceFrameSideWidth = 2.25
g_faceFrameBottomWidth = 1.25
g_faceFrameThickness = 0.7500
g_faceFrameTopWidth = 1.75
g_faceFrameCenterWidth = 1.7500
g_faceFrameCenter = "Y"          -- Insert Center Face Frame
g_centerPanel = "Y"              -- Insert Panel in Cabinet
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
g_lowerBoxHight = 0.0000
g_lowerBoxLength = 0.0000
g_lowerBoxDepth = 0.0000
g_lowerBackHight = 0.0000
g_lowerBackWidth = 0.0000
g_lowerStileLenght = 0.0000
g_lowerRailLenght = 0.0000
g_shelfLength = 0.0000
g_shelfDepth = 0.0000
g_drawerShelfCount = 0
g_stile = 0.0
g_rails = 0.0
g_centerStile = 0.0
g_toeKickDepth = 4.0000
g_toeKickHight = 3.5000
g_toeKickBottomOffsetHight = 0.5000
g_toeKickCoverHight = 0.00
g_lowerHoleSpacing = 2.0
g_lowerShelfFaceFrameWidth = 2.25
g_lowerCabinetLenght = 36.0000
g_lowerCabinetHeight = 32.0000
g_lowerCabinetDepth = 24.0000
g_lowerAddCenterPanel = "Y"
g_lowerAddCenterFaceFrame = "Y"
g_lowerShelfCount = 2.0
g_lowerAddDrawers = "Y"
g_lowerDrawerHeight = 6.0
g_lowerDrawerRowCount = 1.0
g_lowerNumberDrawersPerRow = 2.0
g_lowerPinOuter = 0.7000
g_lowerPinInter = 0.1600
g_lowerShelfClarence = 0.25
g_lowerFaceFrameSideGap = 0.25
g_lowerFaceFrameStileWidth = 3.25
g_lowerFaceFrameBottomWidth  = 1.75
g_lowerFaceFrameThickness = 0.75
g_lowerFaceFrameTopWidth = 2.25
g_lowerTopFrameWidth = 4.0
g_lowerCenterFaceFrameWidth = 2.0
g_lowerBottomFaceFrameOverlap = 0.0625
g_lowerFirstRowSpacingForHole = 8.0
g_lowerLastHoleRowSpacing = 2.0
g_shelfOverlap = 0.0196
g_lowerAddCenterFaceFrameLen = 0.0
g_shelfPinDiameter = 0.192
-- g_jobPath = "C://Users//JimAnderson//Documents//______"

g_jobPath = "C://Users//CNC//Documents//AAA"
g_lowerCenterPanelx = 0.0
g_lowerCenterPanely = 0.0

-- ==============================================================================
function AddGroupToJob(job, group, layer_name)
   local cad_object = CreateCadGroup(group) ; 
   local layer = job.LayerManager:GetLayerWithName(layer_name)
   layer:AddObject(cad_object, true)
   return cad_object 
end
-- ==============================================================================
function fileWriter(datFile) 
    local file = io.open(datFile .."//Job.dat", "w")
    -- write line of the file
        file:write("==============================================================================\n")
        file:write("==================== Job Data File for Cabinet Maker 2018 ====================\n")
        file:write("------------------------------------------------------------------------------\n")
        file:write("g_millClearnaceOffset        = "..  g_millClearnaceOffset      .."   \n")
        file:write("g_pinShelfClarence           = "..  g_pinShelfClarence   .."   \n")
        file:write("g_shelfPinDiameter           = "..  g_shelfPinDiameter   .."   \n")
        file:write("g_shelfCount                 = "..  g_shelfCount   .."   \n")
        file:write("g_shelfFaceFrameWidth        = "..  g_shelfFaceFrameWidth   .."   \n")
        file:write("g_shelfWidthClearance        = "..  g_shelfWidthClearance   .."   \n")
        file:write("g_materialThicknessBack      = "..  g_materialThicknessBack   .."   \n")
        file:write("g_materialThickness          = "..  g_materialThickness   .."   \n")
        file:write("g_millOffset                 = "..  g_millOffset   .."   \n")
        file:write("g_drawingUnits               = "..  g_drawingUnits   .."   \n")
        file:write("g_defaultToolName            = "..  g_defaultToolName   .."   \n")
        file:write("g_toolNameLabel              = "..  g_toolNameLabel   .."   \n")
        file:write("g_programTitle               = "..  g_programTitle   .."   \n")
        file:write("g_programVersion             = "..  g_programVersion   .."   \n")
        file:write("g_codeBy                     = "..  g_codeBy   .."   \n")
        file:write("g_toolSizeDia                = "..  g_toolSizeDia   .."   \n")
        file:write("g_toolSizeRadus              = "..  g_toolSizeRadus   .."   \n")
        file:write("g_datoDeep                   = "..  g_datoDeep   .."   \n")
        file:write("g_pinRadus                   = "..  g_pinRadus   .."   \n")
        file:write("g_upperCabinetLenght         = "..  g_upperCabinetLenght   .."   \n")
        file:write("g_upperCabinetHeight         = "..  g_upperCabinetHeight   .."   \n")
        file:write("g_upperCabinetDepth          = "..  g_upperCabinetDepth   .."   \n")
        file:write("g_pinOuter                   = "..  g_pinOuter   .."   \n")
        file:write("g_pinInter                   = "..  g_pinInter   .."   \n")
        file:write("g_faceFrameSideGap           = "..  g_faceFrameSideGap   .."   \n")
        file:write("g_faceFrameSideWidth         = "..  g_faceFrameSideWidth   .."   \n")
        file:write("g_faceFrameBottomWidth       = "..  g_faceFrameBottomWidth   .."   \n")
        file:write("g_faceFrameThickness         = "..  g_faceFrameThickness   .."   \n")
        file:write("g_faceFrameTopWidth          = "..  g_faceFrameTopWidth   .."   \n")
        file:write("g_faceFrameCenterWidth       = "..  g_faceFrameCenterWidth   .."   \n")
        file:write("g_faceFrameCenter            = "..  g_faceFrameCenter   .."   \n")
        file:write("g_centerPanel                = "..  g_centerPanel   .."   \n")
        file:write("g_faceFrameBottomOverlap     = "..  g_faceFrameBottomOverlap   .."   \n")
        file:write("g_faceFrameTopOverlap        = "..  g_faceFrameTopOverlap   .."   \n")
        file:write("g_holeSpacing                = "..  g_holeSpacing   .."   \n")
        file:write("g_holeFirstRowSpacing        = "..  g_holeFirstRowSpacing   .."   \n")
        file:write("g_holeLastRowSpacing         = "..  g_holeLastRowSpacing   .."   \n")
        file:write("g_boxHight                   = "..  g_boxHight   .."   \n")
        file:write("g_boxLength                  = "..  g_boxLength   .."   \n")
        file:write("g_boxDepth                   = "..  g_boxDepth   .."   \n")
        file:write("g_backHight                  = "..  g_backHight   .."   \n")
        file:write("g_backWidth                  = "..  g_backWidth   .."   \n")
        file:write("g_shelfLength                = "..  g_shelfLength   .."   \n")
        file:write("g_shelfDepth                 = "..  g_shelfDepth   .."   \n")
        file:write("g_stile                      = "..  g_stile   .."   \n")
        file:write("g_rails                      = "..  g_rails   .."   \n")
        file:write("g_centerStile                = "..  g_centerStile   .."   \n")
        file:write("g_toeKickDepth               = "..  g_toeKickDepth   .."   \n")
        file:write("g_toeKickHight               = "..  g_toeKickHight   .."   \n")
        file:write("g_toeKickBottomOffsetHight   = "..  g_toeKickBottomOffsetHight   .."   \n")
        file:write("g_lowerHoleSpacing           = "..  g_lowerHoleSpacing   .."   \n")
        file:write("g_lowerShelfFaceFrameWidth   = "..  g_lowerShelfFaceFrameWidth   .."   \n")
        file:write("g_lowerCabinetLenght         = "..  g_lowerCabinetLenght   .."   \n")
        file:write("g_lowerCabinetHeight         = "..  g_lowerCabinetHeight   .."   \n")
        file:write("g_lowerCabinetDepth          = "..  g_lowerCabinetDepth   .."   \n")
        file:write("g_lowerAddCenterPanel        = "..  g_lowerAddCenterPanel   .."   \n")
        file:write("g_lowerAddCenterFaceFrame    = "..  g_lowerAddCenterFaceFrame   .."   \n")
        file:write("g_lowerShelfCount            = "..  g_lowerShelfCount   .."   \n")
        file:write("g_lowerAddDrawers            = "..  g_lowerAddDrawers   .."   \n")
        file:write("g_lowerDrawerHeight          = "..  g_lowerDrawerHeight   .."   \n")
        file:write("g_lowerDrawerRowCount        = "..  g_lowerDrawerRowCount   .."   \n")
        file:write("g_lowerNumberDrawersPerRow   = "..  g_lowerNumberDrawersPerRow   .."   \n")
        file:write("g_lowerPinOuter              = "..  g_lowerPinOuter   .."   \n")
        file:write("g_lowerPinInter              = "..  g_lowerPinInter   .."   \n")
        file:write("g_lowerShelfClarence         = "..  g_lowerShelfClarence   .."   \n")
        file:write("g_lowerFaceFrameSideGap      = "..  g_lowerFaceFrameSideGap   .."   \n")
        file:write("g_lowerFaceFrameStileWidth   = "..  g_lowerFaceFrameStileWidth   .."   \n")
        file:write("g_lowerFaceFrameBottomWidth  = "..  g_lowerFaceFrameBottomWidth   .."   \n")
        file:write("g_lowerFaceFrameThickness    = "..  g_lowerFaceFrameThickness   .."   \n")
        file:write("g_lowerFaceFrameTopWidth     = "..  g_lowerFaceFrameTopWidth   .."   \n")
        file:write("g_lowerCenterFaceFrameWidth  = "..  g_lowerCenterFaceFrameWidth   .."   \n")
        file:write("g_lowerBottomFaceFrameOverlap= "..  g_lowerBottomFaceFrameOverlap   .."   \n")
        file:write("g_lowerFirstRowSpacingForHole= "..  g_lowerFirstRowSpacingForHole   .."   \n")
        file:write("g_lowerLastHoleRowSpacing    = "..  g_lowerLastHoleRowSpacing   .."   \n")
        file:write("g_shelfOverlap               = "..  g_shelfOverlap   .."   \n")
        file:write("g_shelfPinDiameter           = "..  g_shelfPinDiameter   .."   \n")
        file:write("g_jobPath                    = "..  g_jobPath   .."   \n")
        file:write("------------------------------------------------------------------------------")
    -- closes the open file
    file:close()
end
-- ==============================================================================================
-- Upper Cabinet boxHight = (g_upperCabinetHeight – (g_faceFrameTopWidth + g_faceFrameBottomWidth)) + ((g_faceFrameBottomOverlap + g_materialThickness) + ( g_materialThickness + g_faceFrameTopOverlap))
-- Upper Cabinet Box Hight = 27.8125 = (30.00 – (2.25 + 2.25)) + ((0.0625 + 0.75) + ( 0.75 + 0.75))
-- Upper Cabinet Back Hight = (boxHight – (g_materialThickness 2.0))
-- Upper Cabinet Back Hight = 27.0625 = (27.8125 – (0.375 * 2.0)) 
-- ==============================================================================================
-- Upper Cabinet boxLength = (g_upperCabinetLenght – (g_faceframeSideGap * 2.0))
-- Upper Cabinet boxLenght = 35.50 = (36.00 – (0.25 * 2.0)) 
-- Upper Cabinet Back Width = (boxLength  – (g_datoDeep * 2.0))
-- Upper Cabinet Back Width = 34.75 = (35.50 – (0.375 * 2.0)) 
-- ==============================================================================
function Polar2D(pt, ang, dis)
  local y_ = dis * math.sin(math.rad(ang))
  local x_ = dis * math.cos(math.rad(ang))
  return Point2D((pt.X + x_), (pt.Y + y_))
end  -- function end
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
    if letter == 65 then
        line:AppendPoint(pA0) ; 
        line:LineTo(pD8) ; 
        line:LineTo(pG0) ;
        layer:AddObject(CreateCadContour(line) true) ; 
        line = Contour(0.0) ; 
        line:AppendPoint(pB3) ; 
        line:LineTo(pF3) ; 
        layer:AddObject(CreateCadContour(line), true)
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
    local file = io.open(datFile .. "//CutList" .. dY .. dM .. dD .. dMin ..".dat", "w")
    -- Get the file open for writing lines to the file
        file:write("================================================================\n")
        file:write("===================== Upper Cabinet Cut-list ===================\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Run Date = ".. A1 .."\n")
        file:write("================================================================\n")
        file:write("Wall Cabinet size\n")
        file:write("Cabinet Hight       = ".. g_upperCabinetHeight .."\n")
        file:write("Cabinet Lenght      = ".. g_upperCabinetLenght .."\n")
        file:write("Cabinet Depth       = ".. g_upperCabinetDepth .."\n")
        file:write("Face Frame Diagonal = ".. math.sqrt ((g_upperCabinetHeight * g_upperCabinetHeight)+ (g_upperCabinetLenght * g_upperCabinetLenght)) .."\n")
        file:write("----------------------------------------------------------------\n")
        -- Shelf info

        if g_shelfCount >= 1 then
            file:write("Face Frame Shelf       - ".. g_shelfCount .." pcs of ".. g_faceFrameThickness .." Hardwood ".. g_shelfFaceFrameWidth .." X ".. g_shelfLength .."     \n")
        end
        if g_shelfCount >= 1 then
            file:write("Shelf Panel            - ".. g_shelfCount .." pcs of ".. g_materialThickness .." Plywood ".. g_shelfDepth  .." X ".. g_shelfLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameTopWidth .." X ".. g_rails .."     \n")
        file:write("Face Frame Stiles      - 2 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameSideWidth .." X ".. g_stile .."     \n")
        file:write("Face Frame Bottom Rail - 1 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameBottomWidth .." X ".. g_rails .."     \n")
        if g_faceFrameCenter == "Y" then
            file:write("Face Frame Center      - 1 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameCenterWidth .." X ".. g_centerStile .."     \n")
        end
        if g_centerPanel == "Y" then
            file:write("Center Panel           - 1 pcs of ".. g_materialThickness .." Plywood ".. (g_boxDepth + (g_materialThicknessBack * 0.5))  .." X ".. g_boxHight - g_materialThickness .."     \n")
        end
        file:write("Sides Panels           - 2 pcs of ".. g_materialThickness .." Plywood ".. g_boxDepth .." X ".. g_boxHight .."\n")
        file:write("Top and Bottom Panels  - 2 pcs of ".. g_materialThickness .." Plywood ".. g_boxDepth .." X ".. g_boxLength .."\n")
        file:write("Back Panel             - 1 pcs of ".. g_materialThicknessBack .." Plywood ".. g_backHight .." X ".. g_backWidth .."\n")
        file:write("----------------------------------------------------------------\n")
        file:write("Base Cabinet size\n")
        file:write("Cabinet Hight               = ".. g_lowerCabinetHeight .."\n")
        file:write("Cabinet Lenght              = ".. g_lowerCabinetLenght .."\n")
        file:write("Cabinet Depth               = ".. g_lowerCabinetDepth .."\n")
        file:write("Cabinet Face Frame Diagonal = ".. math.sqrt ((g_lowerStileLenght * g_lowerStileLenght)+ (g_lowerCabinetLenght * g_lowerCabinetLenght)) .."\n")
        file:write("Cabinet Back Diagonal       = ".. math.sqrt ((g_lowerCabinetHeight * g_lowerCabinetHeight)+ (g_lowerCabinetLenght * g_lowerCabinetLenght)) .."\n")
        file:write("----------------------------------------------------------------\n")
        if g_lowerShelfCount >= 1 then
            file:write("Face Frame Shelf       - ".. g_shelfCount .." pcs of ".. g_faceFrameThickness .." Hardwood ".. g_shelfFaceFrameWidth .." X ".. g_shelfLength .."     \n")
        end
        if g_lowerShelfCount >= 1 then
            file:write("Shelf Panel            - ".. g_shelfCount .." pcs of ".. g_materialThickness .." Plywood ".. g_shelfDepth  .." X ".. g_shelfLength .." \n")
        end
        file:write("Face Frame Top Rail    - 1 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameTopWidth .." X ".. g_rails .."     \n")
        file:write("Face Frame Stiles      - 2 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameSideWidth .." X ".. g_lowerStileLenght .."     \n")
        file:write("Face Frame Bottom Rail - 1 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_faceFrameBottomWidth .." X ".. g_rails .."     \n")
        if g_lowerAddDrawers == "Y" then
            file:write("Drawer Rails           - "..  g_lowerDrawerRowCount  .." pcs of ".. g_faceFrameThickness .." Hardwood ".. g_lowerFaceFrameTopWidth .." X ".. g_lowerStileLenght .."     \n")
            if g_lowerNumberDrawersPerRow >= 2 then
                file:write("Drawer Center Rails    - " .. g_lowerDrawerRowCount .." pcs of ".. g_faceFrameThickness .." Hardwood ".. g_lowerFaceFrameTopWidth .." X ".. g_lowerDrawerHeight .."     \n")
            end
        end
       
        if g_lowerAddCenterFaceFrame == "Y" then
            file:write("Face Frame Center      - 1 pcs of ".. g_faceFrameThickness .." Hardwood ".. g_lowerCenterFaceFrameWidth .." X ".. g_lowerAddCenterFaceFrameLen .."     \n")
        end
        if g_lowerAddCenterPanel == "Y" then
            file:write("Center Panel           - 1 pcs of ".. g_materialThickness .." Plywood ".. g_lowerCenterPanelx  .." X ".. g_lowerCenterPanely .."     \n")
        end
        file:write("Sides Panels           - 2 pcs of ".. g_materialThickness .." Plywood ".. g_boxDepth .." X ".. g_boxHight .."\n")
        file:write("Bottom Panel           - 1 pcs of ".. g_materialThickness .." Plywood ".. g_lowerBoxDepth .." X ".. g_lowerBoxLength - g_materialThickness .."\n")
        file:write("Back Panel             - 1 pcs of ".. g_materialThicknessBack .." Plywood ".. g_backHight .." X ".. g_backWidth .."\n")
        file:write("Toe Kick Panel         - 1 Pcs of ".. g_materialThickness .. " Plywood " .. g_toeKickCoverHight .. " X " .. g_lowerBoxLength - g_materialThickness .."\n")
        file:write("----------------------------------------------------------------\n")
        file:write("\n")
        file:write("================================================================\n")
        file:write("============== Job Data Values Cabinet Maker 2018 ==============\n")
        file:write("----------------------------------------------------------------\n")
        file:write("g_millClearnaceOffset         = "..  g_millClearnaceOffset      .."   \n")
        file:write("g_pinShelfClarence            = "..  g_pinShelfClarence   .."   \n")
        file:write("g_shelfPinDiameter            = "..  g_shelfPinDiameter   .."   \n")
        file:write("g_shelfCount                  = "..  g_shelfCount   .."   \n")
        file:write("g_shelfFaceFrameWidth         = "..  g_shelfFaceFrameWidth   .."   \n")
        file:write("g_shelfWidthClearance         = "..  g_shelfWidthClearance   .."   \n")
        file:write("g_materialThicknessBack       = "..  g_materialThicknessBack   .."   \n")
        file:write("g_materialThickness           = "..  g_materialThickness   .."   \n")
        file:write("g_millOffset                  = "..  g_millOffset   .."   \n")
        file:write("g_drawingUnits                = "..  g_drawingUnits   .."   \n")
        file:write("g_defaultToolName             = "..  g_defaultToolName   .."   \n")
        file:write("g_toolNameLabel               = "..  g_toolNameLabel   .."   \n")
        file:write("g_programTitle                = "..  g_programTitle   .."   \n")
        file:write("g_programVersion              = "..  g_programVersion   .."   \n")
        file:write("g_codeBy                      = "..  g_codeBy   .."   \n")
        file:write("g_toolSizeDia                 = "..  g_toolSizeDia   .."   \n")
        file:write("g_toolSizeRadus               = "..  g_toolSizeRadus   .."   \n")
        file:write("g_datoDeep                    = "..  g_datoDeep   .."   \n")
        file:write("g_pinRadus                    = "..  g_pinRadus   .."   \n")
        file:write("g_upperCabinetLenght          = "..  g_upperCabinetLenght   .."   \n")
        file:write("g_upperCabinetHeight          = "..  g_upperCabinetHeight   .."   \n")
        file:write("g_upperCabinetDepth           = "..  g_upperCabinetDepth   .."   \n")
        file:write("g_pinOuter                    = "..  g_pinOuter   .."   \n")
        file:write("g_pinInter                    = "..  g_pinInter   .."   \n")
        file:write("g_faceFrameSideGap            = "..  g_faceFrameSideGap   .."   \n")
        file:write("g_faceFrameSideWidth          = "..  g_faceFrameSideWidth   .."   \n")
        file:write("g_faceFrameBottomWidth        = "..  g_faceFrameBottomWidth   .."   \n")
        file:write("g_faceFrameThickness          = "..  g_faceFrameThickness   .."   \n")
        file:write("g_faceFrameTopWidth           = "..  g_faceFrameTopWidth   .."   \n")
        file:write("g_faceFrameCenterWidth        = "..  g_faceFrameCenterWidth   .."   \n")
        file:write("g_faceFrameCenter             = "..  g_faceFrameCenter   .."   \n")
        file:write("g_centerPanel                 = "..  g_centerPanel   .."   \n")
        file:write("g_faceFrameBottomOverlap      = "..  g_faceFrameBottomOverlap   .."   \n")
        file:write("g_faceFrameTopOverlap         = "..  g_faceFrameTopOverlap   .."   \n")
        file:write("g_holeSpacing                 = "..  g_holeSpacing   .."   \n")
        file:write("g_holeFirstRowSpacing         = "..  g_holeFirstRowSpacing   .."   \n")
        file:write("g_holeLastRowSpacing          = "..  g_holeLastRowSpacing   .."   \n")
        file:write("g_boxHight                    = "..  g_boxHight   .."   \n")
        file:write("g_boxLength                   = "..  g_boxLength   .."   \n")
        file:write("g_boxDepth                    = "..  g_boxDepth   .."   \n")
        file:write("g_backHight                   = "..  g_backHight   .."   \n")
        file:write("g_backWidth                   = "..  g_backWidth   .."   \n")
        file:write("g_lowerBoxHight               = "..  g_boxHight   .."   \n")
        file:write("g_lowerBoxLength              = "..  g_lowerBoxLength   .."   \n")
        file:write("g_lowerBoxDepth               = "..  g_lowerBoxDepth   .."   \n")
        file:write("g_lowerBackHight              = "..  g_lowerBackHight   .."   \n")
        file:write("g_lowerBackWidth              = "..  g_lowerBackWidth   .."   \n")       
        file:write("g_shelfLength                 = "..  g_shelfLength   .."   \n")
        file:write("g_shelfDepth                  = "..  g_shelfDepth   .."   \n")
        file:write("g_lowerTopFrameWidth          = "..  g_lowerTopFrameWidth   .."   \n")
        file:write("g_stile                       = "..  g_stile   .."   \n")
        file:write("g_rails                       = "..  g_rails   .."   \n")
        file:write("g_centerStile                 = "..  g_centerStile   .."   \n")
        file:write("g_toeKickDepth                = "..  g_toeKickDepth   .."   \n")
        file:write("g_toeKickHight                = "..  g_toeKickHight   .."   \n")
        file:write("g_toeKickBottomOffsetHight    = "..  g_toeKickBottomOffsetHight   .."   \n")
        file:write("g_lowerHoleSpacing            = "..  g_lowerHoleSpacing   .."   \n")
        file:write("g_lowerShelfFaceFrameWidth    = "..  g_lowerShelfFaceFrameWidth   .."   \n")
        file:write("g_lowerCabinetLenght          = "..  g_lowerCabinetLenght   .."   \n")
        file:write("g_lowerCabinetHeight          = "..  g_lowerCabinetHeight   .."   \n")
        file:write("g_lowerCabinetDepth           = "..  g_lowerCabinetDepth   .."   \n")
        file:write("g_lowerAddCenterPanel         = "..  g_lowerAddCenterPanel   .."   \n")
        file:write("g_lowerAddCenterFaceFrame     = "..  g_lowerAddCenterFaceFrame   .."   \n")
        file:write("g_lowerShelfCount             = "..  g_lowerShelfCount   .."   \n")
        file:write("g_lowerAddDrawers             = "..  g_lowerAddDrawers   .."   \n")
        file:write("g_lowerDrawerHeight           = "..  g_lowerDrawerHeight   .."   \n")
        file:write("g_lowerDrawerRowCount         = "..  g_lowerDrawerRowCount   .."   \n")

        file:write("g_lowerNumberDrawersPerRow    = "..  g_lowerNumberDrawersPerRow   .."   \n")
        file:write("g_lowerPinOuter               = "..  g_lowerPinOuter   .."   \n")
        file:write("g_lowerPinInter               = "..  g_lowerPinInter   .."   \n")
        file:write("g_lowerShelfClarence          = "..  g_lowerShelfClarence   .."   \n")
        file:write("g_lowerFaceFrameSideGap       = "..  g_lowerFaceFrameSideGap   .."   \n")
        file:write("g_lowerFaceFrameStileWidth    = "..  g_lowerFaceFrameStileWidth   .."   \n")
        file:write("g_lowerFaceFrameBottomWidth   = "..  g_lowerFaceFrameBottomWidth   .."   \n")
        file:write("g_lowerFaceFrameThickness     = "..  g_lowerFaceFrameThickness   .."   \n")
        file:write("g_lowerFaceFrameTopWidth      = "..  g_lowerFaceFrameTopWidth   .."   \n")
        file:write("g_lowerCenterFaceFrameWidth   = "..  g_lowerCenterFaceFrameWidth   .."   \n")
        file:write("g_lowerBottomFaceFrameOverlap = "..  g_lowerBottomFaceFrameOverlap   .."   \n")
--     file:write("g_lowerTopFrameOverlap        = "..  g_lowerTopFrameOverlap   .."   \n")
        file:write("g_lowerFirstRowSpacingForHole = "..  g_lowerFirstRowSpacingForHole   .."   \n")
        file:write("g_lowerLastHoleRowSpacing     = "..  g_lowerLastHoleRowSpacing   .."   \n")
        file:write("g_shelfOverlap                = "..  g_shelfOverlap   .."   \n")
        file:write("g_shelfPinDiameter            = "..  g_shelfPinDiameter   .."   \n")
        file:write("g_jobPath                     = "..  g_jobPath   .."   \n")
        file:write("-----------------------------END-------------------------------")
 -- closes the the door on the open file
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
      y =  string.byte(string.sub(strup, i, i))
      ptx = CADLeters(ptx, y , size, lay)
      i = i + 1
    end
end
-- ==============================================================================
function UpperCabinetFaceFrame(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0,   g_upperCabinetHeight)
    local pt3 = Polar2D(pt2,  90,   g_upperCabinetLenght)
    local pt4 = Polar2D(pt3, 180,   g_upperCabinetHeight)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    
    local A1 = Polar2D(g_pt1, 90,  g_faceFrameSideWidth)
    local B1 = Polar2D(pt2,   90,  g_faceFrameSideWidth)
    local C1 = Polar2D(pt3,  270,  g_faceFrameSideWidth)
    local D1 = Polar2D(pt4,  270,  g_faceFrameSideWidth)
    line = Contour(0.0)
    line:AppendPoint(A1) 
    line:LineTo(B1)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(C1) 
    line:LineTo(D1)
    layer:AddObject(CreateCadContour(line), true)
    
    local A2 = Polar2D(A1, 0,   g_faceFrameBottomWidth)
    local B2 = Polar2D(B1, 180,   g_faceFrameTopWidth)
    local C2 = Polar2D(C1, 180,  g_faceFrameTopWidth)
    local D2 = Polar2D(D1, 0, g_faceFrameBottomWidth)
    line = Contour(0.0)
    line:AppendPoint(A2) 
    line:LineTo(D2)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(B2)
    line:LineTo(C2)
    layer:AddObject(CreateCadContour(line), true)
    
    
    if g_faceFrameCenter == "Y" then
        
        g_lowerAddCenterFaceFrameLen = (g_upperCabinetLenght * 0.5) - (g_faceFrameSideWidth + (g_faceFrameCenterWidth * 0.5))
        local A3 = Polar2D(A2, 90,   g_lowerAddCenterFaceFrameLen)
        local B3 = Polar2D(B2, 90,  g_lowerAddCenterFaceFrameLen)
        local C3 = Polar2D(C2, 270,  g_lowerAddCenterFaceFrameLen)
        local D3 = Polar2D(D2, 270,   g_lowerAddCenterFaceFrameLen)
        line = Contour(0.0)
        line:AppendPoint(A3) 
        line:LineTo(B3)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
        line:AppendPoint(D3)
        line:LineTo(C3)
        layer:AddObject(CreateCadContour(line), true)
    end
    
    
    
    g_stile = g_upperCabinetHeight
    g_rails = g_upperCabinetLenght - (g_faceFrameSideWidth * 2.0)
    g_centerStile = g_upperCabinetHeight - (g_faceFrameBottomWidth + g_faceFrameTopWidth) 
    
    local pt1Text = Polar2D(g_pt1, 0,  4)
    local pt1Text = Polar2D(pt1Text, 90,  ((g_upperCabinetLenght * 0.5) + 8))
    DrawWriter(g_programTitle, pt1Text, 0.750, lay)
        pt1Text = Polar2D(pt1Text, 270, 1)
    DrawWriter("Version: " .. g_programVersion, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("By: " .. g_codeBy, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("= Stiles and g_rails Cut list =", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Stiles: 2 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameSideWidth) .. " - " .. g_stile .. "'' long", pt1Text, 0.5, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Top Rile: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameTopWidth) .. " - " .. g_rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Bottom Rail: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameBottomWidth) .. " - " .. g_rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Pull a ruller twice and cut cut and cut some more :)", pt1Text, 0.50, lay)
    if g_faceFrameCenter == "Y" then
        pt1Text = Polar2D(pt1Text, 270, 0.75)
        DrawWriter("Center Stile: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. g_faceFrameCenterWidth .. " - " .. g_centerStile .. " long", pt1Text, 0.50, lay) 
    end
  return true   
end
-- ==============================================================================
function UpperCabinetShelf(lay, CountX)   
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
function UpperCabinetBack(lay)   -- Add Dato for the UpperCab-CenterPanel
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
    if g_centerPanel == "Y" then
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
function UpperCabinetTandB(top, lay) -- Add Dato for the UpperCab-CenterPanel
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
        ptG = Polar2D(pt3, 0,   g_toolSizeRadus)
        ptH = Polar2D(ptG, 270, g_materialThicknessBack)
        ptE = Polar2D(pt4, 180, g_toolSizeRadus)
        ptF = Polar2D(ptE, 270, g_materialThicknessBack)
        ptE = Polar2D(ptE, 90, g_millOffset)
        ptG = Polar2D(ptG, 90, g_millOffset)
        DrawWriter("Cabinet Top - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    else
        ptG = Polar2D(pt2, 0,     g_toolSizeRadus)
        ptH = Polar2D(ptG, 90,    g_materialThicknessBack)
        ptE = Polar2D(g_pt1, 180, g_toolSizeRadus)
        ptF = Polar2D(ptE, 90,    g_materialThicknessBack)
        ptE = Polar2D(ptE, 270, g_millOffset)
        ptG = Polar2D(ptG, 270, g_millOffset)
        DrawWriter("Cabinet BOTTOM - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    end
        ptW = Polar2D(ptC, 180,   ((g_materialThickness + g_millOffset) * 0.5))
        ptW = Polar2D(ptW, 270,   g_toolSizeRadus)
        ptX = Polar2D(ptW, 0,     (g_materialThickness + g_millOffset))
        ptY = Polar2D(ptX, 90,    g_boxDepth + (g_toolSizeRadus * 2))
        ptZ = Polar2D(ptW, 90,    g_boxDepth + (g_toolSizeRadus * 2))
        local line = Contour(0.0)
        if g_centerPanel == "Y" then
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
function UpperCabinetSide(side, lay)
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
-- Upper dato
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
function UpperCenterPanel(lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt1 = Polar2D(g_pt1, 0, (g_materialThickness * 0.5))
    local pt2 = Polar2D(pt1, 0, g_boxHight - g_materialThickness)
    local pt3 = Polar2D(pt2, 90, g_boxDepth - (g_materialThicknessBack * 0.5))
    local pt4 = Polar2D(pt3, 180, g_boxHight - g_materialThickness)
    local pt1Text = Polar2D(g_pt1, 45,  4)
    DrawWriter("Cabinet Center Panel - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    local line = Contour(0.0) ; line:AppendPoint(pt1) ; line:LineTo(pt2) ;  line:LineTo(pt3) ; line:LineTo(pt4) ; line:LineTo(pt1) 
    layer:AddObject(CreateCadContour(line), true) 
    local ptx = g_pt1
    local anx = 90
    ptx = Polar2D(Polar2D(g_pt1, 0, (g_holeFirstRowSpacing + g_materialThickness)), 90, ((g_boxDepth - g_materialThicknessBack) * g_pinInter))
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
function LowerCabinetBottom(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local BD = g_lowerBoxDepth - g_materialThicknessBack
    local BL = g_lowerBoxLength - g_materialThickness
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, BD)
    local ptC = Polar2D(g_pt1, 90, (BL * 0.5))
    local pt3 = Polar2D(pt2, 90,  BL)
    local pt4 = Polar2D(pt3, 180, BD)
    local ptW = g_pt1
    local ptX = g_pt1
    local ptY = g_pt1
    local ptZ = g_pt1
    ptW = Polar2D(ptC, 270,   ((g_materialThickness + g_millOffset) * 0.5))
    ptW = Polar2D(ptW, 180,   g_toolSizeRadus)
    ptX = Polar2D(ptW, 90,    (g_materialThickness + g_millOffset))
    ptY = Polar2D(ptX, 0,     BD + (g_toolSizeRadus * 2))
    ptZ = Polar2D(ptW, 0,     BD + (g_toolSizeRadus * 2))
    local line = Contour(0.0)
    if g_lowerAddCenterPanel == "Y" then
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
    DrawWriter("Cabinet Bottom - ".. g_materialThicknessBack .." Plywood", pt1Text, 0.5, lay)
    return true   
end
-- ==============================================================================
function LowerCabinetFaceFrame(lay)   
    local job = VectricJob()
    local Dist = 0.0
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
--    g_lowerStileLenght = ((g_lowerCabinetHeight - g_toeKickHight - g_lowerBottomFaceFrameOverlap - g_materialThickness - g_toeKickBottomOffsetHight) + g_lowerFaceFrameBottomWidth)
    g_lowerStileLenght = (g_lowerCabinetHeight - g_toeKickHight)
    g_lowerRailLenght = g_lowerCabinetLenght - (g_lowerFaceFrameStileWidth * 2)
-- Draw outer frame box  
    local pt2 = Polar2D(g_pt1, 0,  g_lowerStileLenght)
    local pt3 = Polar2D(pt2,  90,  g_lowerCabinetLenght)
    local pt4 = Polar2D(pt3, 180,  g_lowerStileLenght)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    
-- Draw Stile Lines 
    local A1 = Polar2D(g_pt1, 90,  g_lowerFaceFrameStileWidth)
    local B1 = Polar2D(pt2,   90,  g_lowerFaceFrameStileWidth)
    local C1 = Polar2D(pt3,  270,  g_lowerFaceFrameStileWidth)
    local D1 = Polar2D(pt4,  270,  g_lowerFaceFrameStileWidth)
    line = Contour(0.0)
    line:AppendPoint(A1) 
    line:LineTo(B1)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(C1) 
    line:LineTo(D1)
    layer:AddObject(CreateCadContour(line), true)
-- Draw the Top and Bottom rails    
    local A2 = Polar2D(A1,   0,   g_lowerFaceFrameTopWidth)
    local B2 = Polar2D(B1, 180,   g_lowerFaceFrameBottomWidth)
    local C2 = Polar2D(C1, 180,   g_lowerFaceFrameBottomWidth)
    local D2 = Polar2D(D1,   0,   g_lowerFaceFrameTopWidth)
    line = Contour(0.0)
    line:AppendPoint(A2) 
    line:LineTo(D2)
    layer:AddObject(CreateCadContour(line), true)
    line = Contour(0.0)
    line:AppendPoint(B2)
    line:LineTo(C2)
    layer:AddObject(CreateCadContour(line), true)
    


    if g_lowerAddDrawers == "Y" then
        
        local g_lowerDrawerRowCountX = g_lowerDrawerRowCount

        while g_lowerDrawerRowCountX >= 1 do
            A2 = Polar2D(A2,  0,   g_lowerDrawerHeight)
            D2 = Polar2D(D2,  0,   g_lowerDrawerHeight)
            line = Contour(0.0)
            line:AppendPoint(A2) 
            line:LineTo(D2)
            layer:AddObject(CreateCadContour(line), true)
            if g_lowerNumberDrawersPerRow >=2 then
                Dist = ((g_lowerCabinetLenght * 0.5) - (g_lowerFaceFrameStileWidth + (g_lowerCenterFaceFrameWidth * 0.5) ))
                local B2 = Polar2D(A2,  90,   Dist)
                local C2 = Polar2D(D2, 270,   Dist)
                line = Contour(0.0)
                line:AppendPoint(B2) 
                line:LineTo(Polar2D(B2, 180, g_lowerDrawerHeight))
                layer:AddObject(CreateCadContour(line), true)
                line = Contour(0.0)
                line:AppendPoint(C2)
                line:LineTo(Polar2D(C2, 180, g_lowerDrawerHeight))
                layer:AddObject(CreateCadContour(line), true)
            end
            A2 = Polar2D(A2,  0,   g_lowerFaceFrameTopWidth)
            D2 = Polar2D(D2,  0,   g_lowerFaceFrameTopWidth)
            line = Contour(0.0)
            line:AppendPoint(A2) 
            line:LineTo(D2)
            layer:AddObject(CreateCadContour(line), true)
            g_lowerDrawerRowCountX = g_lowerDrawerRowCountX -1
        end
    end
    if g_faceFrameCenter == "Y" then
        Dist = ((g_lowerCabinetLenght * 0.5) - (g_lowerFaceFrameStileWidth + (g_lowerCenterFaceFrameWidth * 0.5) ))
        local A3 = Polar2D(A2, 90,   Dist)
        local B3 = Polar2D(B2, 90,  Dist)
        local C3 = Polar2D(C2, 270,  Dist)
        local D3 = Polar2D(D2, 270,   Dist)
        line = Contour(0.0)
        line:AppendPoint(A3) 
        line:LineTo(B3)
        layer:AddObject(CreateCadContour(line), true)
        line = Contour(0.0)
        line:AppendPoint(D3)
        line:LineTo(C3)
        layer:AddObject(CreateCadContour(line), true)
    end
    
    
    
    
    g_stile = g_lowerCabinetHeight
    g_rails = g_lowerCabinetLenght - (g_lowerFaceFrameStileWidth * 2.0)
    g_centerStile = g_lowerCabinetHeight - (g_lowerFaceFrameBottomWidth + g_lowerFaceFrameTopWidth) 
    
    local pt1Text = Polar2D(g_pt1, 0,  4)
    local pt1Text = Polar2D(pt1Text, 90,  ((g_lowerCabinetLenght * 0.5) + 8))
    DrawWriter(g_programTitle, pt1Text, 0.750, lay)
        pt1Text = Polar2D(pt1Text, 270, 1)
    DrawWriter("Version: " .. g_programVersion, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("By: " .. g_codeBy, pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("= Stiles and g_rails Cut list =", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Stiles: 2 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_lowerFaceFrameStileWidth) .. " - " .. g_stile .. "'' long", pt1Text, 0.5, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Top Rile: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameTopWidth) .. " - " .. g_rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Bottom Rail: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. tostring(g_faceFrameBottomWidth) .. " - " .. g_rails .. " long", pt1Text, 0.50, lay)
        pt1Text = Polar2D(pt1Text, 270, 0.75)
    DrawWriter("Pull a ruller twice and cut cut and cut some more :)", pt1Text, 0.50, lay)
    if g_faceFrameCenter == "Y" then
        pt1Text = Polar2D(pt1Text, 270, 0.75)
        DrawWriter("Center Stile: 1 pcs " .. tostring(g_faceFrameThickness)  .. " x " .. g_lowerCenterFaceFrameWidth .. " - " .. g_centerStile .. " long", pt1Text, 0.50, lay) 
    end
  return true   
end
-- ==============================================================================
function LowerCabinetShelf(lay, CountX)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local LSL = (g_lowerBoxLength - (g_materialThickness * 2) + (g_pinShelfClarence * 2))
    local LSD = g_lowerBoxDepth - (g_materialThicknessBack + g_lowerFaceFrameThickness + g_lowerShelfClarence)
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0,  LSL)
    local pt3 = Polar2D(pt2, 90,  LSD)
    local pt4 = Polar2D(pt3, 180, LSL)
    local line = Contour(0.0)
    line:AppendPoint(g_pt1) 
    line:LineTo(pt2)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(g_pt1)
    layer:AddObject(CreateCadContour(line), true)
    local pt1Text = Polar2D(Polar2D(g_pt1, 0,  3), 90,  (LSD / 2))
    DrawWriter("Cabinet Shelf".. CountX .." - ".. g_materialThickness .." Plywood", pt1Text, 0.5, lay)
  return true   
end
-- ==============================================================================
function LowerCabinetBack(lay)   
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt2 = Polar2D(g_pt1, 0, g_lowerBoxDepth)
    local ptC = Polar2D(g_pt1, 90, ((g_lowerBoxLength - g_materialThickness) * 0.5))
    local pt3 = Polar2D(pt2, 90,  g_lowerBoxLength - g_materialThickness)
    local pt4 = Polar2D(pt3, 180, g_lowerBoxDepth)
    local ptW = g_pt1
    local ptX = g_pt1
    local ptY = g_pt1
    local ptZ = g_pt1
    ptW = Polar2D(ptC, 270,   ((g_materialThickness + g_millOffset) * 0.5))
    ptW = Polar2D(ptW, 180,   g_toolSizeRadus)
    ptX = Polar2D(ptW, 90,    (g_materialThickness + g_millOffset))
    ptY = Polar2D(ptX, 0,     g_lowerBoxDepth + (g_toolSizeRadus * 2))
    ptZ = Polar2D(ptW, 0,     g_lowerBoxDepth + (g_toolSizeRadus * 2))
    local line = Contour(0.0)
    if g_lowerAddCenterPanel == "Y" then
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
function LowerCabinetSide(side, lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end
    local ptA = g_pt1 ;    local ptB = g_pt1 ;    local ptL = g_pt1 ;    local ptK = g_pt1 ;    local ptG = g_pt1 ;    local ptH = g_pt1 ;
    local ptI = g_pt1 ;    local ptJ = g_pt1 ;    local ptD = g_pt1 ;    local ptC = g_pt1 ;    local ptE = g_pt1 ;    local ptF = g_pt1 ;
    local ptG = g_pt1 ;    local ptH = g_pt1 ;    local ptI = g_pt1 ;    local ptJ = g_pt1 ;    local ptJA = g_pt1 ;    local ptJB = g_pt1 ;
    local ptJC = g_pt1 ;    local ptK = g_pt1 ;    local ptL = g_pt1 ;    local ptM = g_pt1 ;    local ptMA = g_pt1 ;    local ptMB = g_pt1 ;
    local ptMC = g_pt1 ;    local ptN = g_pt1 ;    local ptNA = g_pt1 ;    local ptNB = g_pt1 ;    local ptNC = g_pt1 ;    local ptO = g_pt1 ;    local ptP = g_pt1 ;
    local ptS = g_pt1 ;    local ptSA = g_pt1 ;    local ptSB = g_pt1 ;    local ptSC = g_pt1 ;    local ptT = g_pt1 ;    local ptR = g_pt1 ;
    local ptQ = g_pt1 ;        local pt1Text = g_pt1  ;        local pt2 = g_pt1 ;        local pt3 = g_pt1 ;        local pt4 = g_pt1 ;        local pt5 = g_pt1 ;        local pt6 = g_pt1 ;        local pt7 = g_pt1 ;    
    local layer = job.LayerManager:GetLayerWithName(lay)    
    local line = Contour(0.0)
    g_toeKickCoverHight = ((g_toeKickHight + g_lowerFaceFrameBottomWidth) - (g_lowerBottomFaceFrameOverlap + g_materialThickness + g_toeKickBottomOffsetHight))
    if side == "R" then
        pt1Text = Polar2D(g_pt1, 45,  6)
        pt2 = Polar2D(g_pt1, 0, g_lowerCabinetHeight)
        pt3 = Polar2D(pt2,  90, g_lowerBoxDepth)
        pt4 = Polar2D(pt3, 180, g_lowerCabinetHeight)
        pt5 = Polar2D(pt3, 270, g_toeKickDepth)

        pt6 = Polar2D(pt5, 180, g_toeKickCoverHight)
        pt7 = Polar2D(pt3, 180, g_toeKickCoverHight)
        line:AppendPoint(g_pt1) ;
        line:LineTo(pt2) ;       
        line:LineTo(pt5) ;       
        line:LineTo(pt6) ;       
        line:LineTo(pt7) ;       
        line:LineTo(pt4) ;       
        line:LineTo(g_pt1) ;     
        layer:AddObject(CreateCadContour(line), true) ;      
--Back Dato    
        ptA = Polar2D(g_pt1,  90, g_materialThicknessBack) ;
        ptD = Polar2D(ptA,   180, g_toolSizeRadus) ;
        ptA = Polar2D(ptD,   270, g_materialThicknessBack + g_millOffset)
        ptC = Polar2D(pt2,   90, g_materialThicknessBack) ;
        ptC = Polar2D(ptC,    0, g_toolSizeDia) ;
        ptB = Polar2D(ptC,   270, g_materialThicknessBack + g_millOffset)

        line = Contour(0.0)
        line:AppendPoint(ptA) ;
        line:LineTo(ptB) ;       
        line:LineTo(ptC) ;       
        line:LineTo(ptD) ;       
        line:LineTo(ptA) ;     
        layer:AddObject(CreateCadContour(line), true) ;      
        
--Bottom Dato (g_toeKickHight + g_lowerFaceFrameBottomWidth) - (g_lowerBottomFaceFrameOverlap + g_materialThickness + g_toeKickBottomOffsetHight)
        ptF = Polar2D(pt2,   180, g_toeKickCoverHight + g_toeKickBottomOffsetHight) ;
        ptF = Polar2D(ptF,   270, g_toolSizeRadus) ;
        ptG = Polar2D(pt3,   180, g_toeKickCoverHight + g_toeKickBottomOffsetHight) ;
        ptG = Polar2D(ptG,    90, g_toolSizeRadus) ;
        ptE = Polar2D(ptF,   180, g_materialThickness)
        ptH = Polar2D(ptG,   180, g_materialThickness) ;

        line = Contour(0.0)
        line:AppendPoint(ptF) ;
        line:LineTo(ptG) ;       
        line:LineTo(ptH) ;       
        line:LineTo(ptE) ;       
        line:LineTo(ptF) ;     
        layer:AddObject(CreateCadContour(line), true) ;

-- Top Frame Back Dato
        ptO = Polar2D(g_pt1,  90, g_materialThicknessBack)
        ptO = Polar2D(ptO,     0, g_materialThickness)
        ptN = Polar2D(ptO,    90, g_lowerTopFrameWidth) ; 
        ptNA = Polar2D(ptN,   90, g_toolSizeRadus) ; 
        ptNB = Polar2D(ptNA, 180, g_toolSizeDia + g_millClearnaceOffset) ; 
        ptNC = Polar2D(ptNB, 270, g_toolSizeRadus) ; 
        ptM = Polar2D(ptN,   180, g_materialThickness + g_millOffset) ; 
        ptO = Polar2D(ptO,   270, g_millOffset)
        ptP = Polar2D(ptO,   180, g_materialThickness + g_millOffset) ; 

        line = Contour(0.0)
        line:AppendPoint(ptO) ;
        line:LineTo(ptNA) ;       
        line:LineTo(ptNB) ;       
        line:LineTo(ptNC) ;       
        line:LineTo(ptM) ;       
        line:LineTo(ptP) ;       
        line:LineTo(ptO) ;     
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Top Frame Front Dato
        ptI = Polar2D(pt4,     0, g_materialThickness)
        ptJ = Polar2D(ptI,   270, g_lowerTopFrameWidth) ; 
        ptJA = Polar2D(ptJ,  270, g_toolSizeRadus) ; 
        ptJB = Polar2D(ptJA, 180, g_toolSizeDia + g_millClearnaceOffset) ; 
        ptJC = Polar2D(ptJB,  90, g_toolSizeRadus) ; 
        ptI = Polar2D(ptI,    90, g_millOffset)
        ptK = Polar2D(ptJ,   180, g_materialThickness + g_millOffset) ; 
        ptL = Polar2D(ptI,   180, g_materialThickness + g_millOffset) ; 

        line = Contour(0.0)
        line:AppendPoint(ptI) ;
        line:LineTo(ptJA) ;       
        line:LineTo(ptJB) ;       
        line:LineTo(ptJC) ;       
        line:LineTo(ptK) ;       
        line:LineTo(ptL) ;       
        line:LineTo(ptI) ;     
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Toe Front Dato
        ptR = Polar2D(pt5,   270, g_materialThickness)
        ptS = Polar2D(ptR,   180, g_toeKickCoverHight) ; 
        ptSA = Polar2D(ptS,  180, g_toolSizeRadus) ; 
        ptSB = Polar2D(ptSA,  90, g_toolSizeDia + g_millClearnaceOffset) ; 
        ptSC = Polar2D(ptSB,   0, g_toolSizeRadus) ; 
        ptR = Polar2D(ptR,     0, g_millOffset)
        ptQ = Polar2D(ptR,    90, g_materialThickness + g_millOffset)
        ptT = Polar2D(ptS,    90, g_materialThickness + g_millOffset) ; 
        line = Contour(0.0)
        line:AppendPoint(ptR) ;
        line:LineTo(ptSA) ;       
        line:LineTo(ptSB) ;       
        line:LineTo(ptSC) ;       
        line:LineTo(ptT) ;       
        line:LineTo(ptQ) ;       
        line:LineTo(ptR) ;     
        layer:AddObject(CreateCadContour(line), true) ;
        DrawWriter("Base Cabinet Right Side - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    else
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        pt1Text = Polar2D(g_pt1, 45,  6)
        pt2 = Polar2D(g_pt1, 0, g_lowerCabinetHeight)
        pt3 = Polar2D(pt2,  90, g_lowerBoxDepth)
        pt4 = Polar2D(pt3, 180, g_lowerCabinetHeight)
        pt5 = Polar2D(pt2, 90, g_toeKickDepth)
        pt6 = Polar2D(pt5, 180, g_toeKickCoverHight)
        pt7 = Polar2D(pt2, 180, g_toeKickCoverHight)
        
        line:AppendPoint(g_pt1) ;
        line:LineTo(pt7) ;       
        line:LineTo(pt6) ;       
        line:LineTo(pt5) ;       
        line:LineTo(pt3) ; 
        line:LineTo(pt4) ;
        line:LineTo(g_pt1) ;     
        layer:AddObject(CreateCadContour(line), true) ;      

--Back Dato    
        ptA = Polar2D(pt4,   270, g_materialThicknessBack) ;
        ptA = Polar2D(ptA,   180, g_toolSizeRadus) ;
        ptD = Polar2D(ptA,    90, g_materialThicknessBack + g_millOffset)
        ptB = Polar2D(pt3,   270, g_materialThicknessBack) ;
        ptB = Polar2D(ptB,     0, g_toolSizeRadus) ;
        ptC = Polar2D(ptB,    90, g_materialThicknessBack + g_millOffset)

        line = Contour(0.0)
        line:AppendPoint(ptA) ;
        line:LineTo(ptB) ;       
        line:LineTo(ptC) ;       
        line:LineTo(ptD) ;       
        line:LineTo(ptA) ;     
        layer:AddObject(CreateCadContour(line), true) ;      
        
--Bottom Dato
        ptF = Polar2D(pt2,   180, g_toeKickCoverHight + g_toeKickBottomOffsetHight) ;
        ptF = Polar2D(ptF,   270, g_toolSizeRadus) ;
        ptG = Polar2D(pt3,   180, g_toeKickCoverHight + g_toeKickBottomOffsetHight) ;
        ptG = Polar2D(ptG,    90, g_toolSizeRadus) ;
        ptE = Polar2D(ptF,   180, g_materialThickness)
        ptH = Polar2D(ptG,   180, g_materialThickness) ;

        line = Contour(0.0)
        line:AppendPoint(ptF) ;
        line:LineTo(ptG) ;       
        line:LineTo(ptH) ;       
        line:LineTo(ptE) ;       
        line:LineTo(ptF) ;     
        layer:AddObject(CreateCadContour(line), true) ;

-- Top Frame Front Dato
        ptO = Polar2D(g_pt1,   0, g_materialThickness)
        ptN = Polar2D(ptO,    90, g_lowerTopFrameWidth) ; 
        ptNA = Polar2D(ptN,   90, g_toolSizeRadus) ; 
        ptNB = Polar2D(ptNA, 180, g_toolSizeDia + g_millClearnaceOffset) ; 
        ptNC = Polar2D(ptNB, 270, g_toolSizeRadus) ; 
        ptM = Polar2D(ptN,   180, g_materialThickness + g_millOffset) ; 
        ptO = Polar2D(ptO,   270, g_millOffset)
        ptP = Polar2D(ptO,   180, g_materialThickness + g_millOffset) ; 

        line = Contour(0.0)
        line:AppendPoint(ptO) ;
        line:LineTo(ptNA) ;       
        line:LineTo(ptNB) ;       
        line:LineTo(ptNC) ;       
        line:LineTo(ptM) ;       
        line:LineTo(ptP) ;       
        line:LineTo(ptO) ;     
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Top Frame Back Dato
        ptI = Polar2D(pt4,   270, g_materialThicknessBack)
        ptI = Polar2D(ptI,     0, g_materialThickness)
        ptJ = Polar2D(ptI,   270, g_lowerTopFrameWidth) ; 
        ptJA = Polar2D(ptJ,  270, g_toolSizeRadus) ; 
        ptJB = Polar2D(ptJA, 180, g_toolSizeDia + g_millClearnaceOffset) ; 
        ptJC = Polar2D(ptJB,  90, g_toolSizeRadus) ; 
        ptI = Polar2D(ptI,    90, g_millOffset)
        ptK = Polar2D(ptJ,   180, g_materialThickness + g_millOffset) ; 
        ptL = Polar2D(ptI,   180, g_materialThickness + g_millOffset) ; 

        line = Contour(0.0)
        line:AppendPoint(ptI) ;
        line:LineTo(ptJA) ;       
        line:LineTo(ptJB) ;       
        line:LineTo(ptJC) ;       
        line:LineTo(ptK) ;       
        line:LineTo(ptL) ;       
        line:LineTo(ptI) ;     
        layer:AddObject(CreateCadContour(line), true) ;
        
-- Toe Front Dato
        ptR = Polar2D(pt5,    90, g_materialThickness)
        ptS = Polar2D(ptR,   180, g_toeKickCoverHight) ; 
        ptSA = Polar2D(ptS,  180, g_toolSizeRadus) ; 
        ptSB = Polar2D(ptSA, 270, g_toolSizeDia + g_millClearnaceOffset) ; 
        ptSC = Polar2D(ptSB,   0, g_toolSizeRadus) ; 
        ptR = Polar2D(ptR,     0, g_millOffset)
        ptQ = Polar2D(ptR,    270, g_materialThickness + g_millOffset)
        ptT = Polar2D(ptS,    270, g_materialThickness + g_millOffset) ; 
          
        line = Contour(0.0)
        line:AppendPoint(ptR) ;
        line:LineTo(ptSA) ;       
        line:LineTo(ptSB) ;       
        line:LineTo(ptSC) ;       
        line:LineTo(ptT) ;       
        line:LineTo(ptQ) ;       
        line:LineTo(ptR) ;     
        layer:AddObject(CreateCadContour(line), true) ;
        DrawWriter("Base Cabinet Left Side - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    end
    if g_lowerShelfCount >= 1 then
        local ptx = g_pt1 ;         local anx = 0
        if side == "L" then
                ptx = Polar2D(Polar2D(g_pt1, 0, (g_holeFirstRowSpacing + g_materialThickness)), 90, ((g_lowerBoxDepth - g_materialThicknessBack) * g_pinInter)) ;            anx = 90
            else
                ptx = Polar2D(Polar2D(pt4, 0, (g_holeFirstRowSpacing + g_materialThickness)), 270, ((g_lowerBoxDepth - g_materialThicknessBack) * g_pinInter)) ;            anx = 270
        end
        local spc = ((g_lowerBoxDepth - g_materialThickness) * g_pinOuter)
        local rows = ((g_lowerBoxDepth - (g_holeFirstRowSpacing + g_holeLastRowSpacing + (g_materialThickness * 2.0))) / g_holeSpacing)
        while (rows > 0) do
            Holer (ptx, anx, spc, g_pinRadus, lay)
             ptx = Polar2D(ptx, 0, g_holeSpacing)
            rows = (rows - 1.0)
        end
    end
  return true   
end
-- ==============================================================================
function LowerCenterPanel(lay)
    local job = VectricJob()
    if not job.Exists then
        DisplayMessageBox("No job loaded")
        return false;
    end

    g_lowerCenterPanelx = g_lowerCabinetDepth - ((g_materialThicknessBack * 0.5) + g_lowerFaceFrameThickness)
    g_lowerCenterPanely = g_lowerCabinetHeight - ((g_materialThickness * 0.5) + (g_toeKickHight + (g_materialThickness * 0.5)))
    local layer = job.LayerManager:GetLayerWithName(lay)
    local pt1 = Polar2D(g_pt1, 0, (g_materialThickness * 0.5))
    local pt1 = Polar2D(pt1, 90, (g_materialThicknessBack * 0.5))
    local pt2 = Polar2D(pt1, 0, g_lowerCenterPanely)
    local pt3 = Polar2D(pt2, 90, g_lowerCenterPanelx)
    local pt4 = Polar2D(pt3, 180, g_lowerCenterPanely)
    local line = Contour(0.0)
    line:AppendPoint(pt1) ;
    line:LineTo(pt2) ;       
    line:LineTo(pt3) ;       
    line:LineTo(pt4) ;       
    line:LineTo(pt1) ;     
    layer:AddObject(CreateCadContour(line), true) 
    local pt1Text = Polar2D(g_pt1, 45,  8)
    DrawWriter("Base Cabinet Center Panel - ".. g_materialThickness .." Plywood", pt1Text, 0.5000, lay)
    
     if g_lowerShelfCount >= 1 then
        local ptx = g_pt1 ;         local anx = 0
        ptx = Polar2D(Polar2D(pt4, 0, (g_holeFirstRowSpacing + (g_materialThickness * 0.5))), 270, ((g_lowerBoxDepth - g_materialThicknessBack) * g_pinInter)) ;            anx = 270

        local spc = ((g_lowerBoxDepth - g_materialThickness) * g_pinOuter)
        local rows = ((g_lowerBoxDepth - (g_holeFirstRowSpacing + g_holeLastRowSpacing + (g_materialThickness * 2.0))) / g_holeSpacing)
        while (rows > 0) do
            Holer (ptx, anx, spc, g_pinRadus, lay)
             ptx = Polar2D(ptx, 0, g_holeSpacing)
            rows = (rows - 1.0)
        end
    end 
  return true   
end
-- ==============================================================================
function LoadDialog(job, script_path)
    local registry = Registry("CabinetMaker")
	local html_path = "file:" .. script_path .. "\\CabinetMaker.htm"
    local dialog = HTML_Dialog(false, html_path, 850, 600,      g_programTitle)
    dialog:AddDoubleField("g_millOffset",                       g_millOffset)  
    dialog:AddDoubleField("g_millClearnaceOffset",              g_millClearnaceOffset)
    dialog:AddDoubleField("g_materialThickness",                g_materialThickness)   
    dialog:AddDoubleField("g_shelfPinDiameter",                 g_shelfPinDiameter)    
    dialog:AddDoubleField("g_upperCabinetLenght",               g_upperCabinetLenght)      
    dialog:AddDoubleField("g_upperCabinetHeight",               g_upperCabinetHeight)
    dialog:AddDoubleField("g_upperCabinetDepth",                g_upperCabinetDepth)      
    dialog:AddDoubleField("g_lowerCabinetLenght",               g_lowerCabinetLenght)      
    dialog:AddDoubleField("g_lowerCabinetHeight",               g_lowerCabinetHeight)
    dialog:AddDoubleField("g_lowerCabinetDepth",                g_lowerCabinetDepth)      
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
    dialog:AddLabelField("g_programVersion",                    g_programVersion)
    dialog:AddLabelField("g_programTitle",                      g_programTitle)   
    dialog:AddLabelField("g_codeBy",                            g_codeBy)  
    dialog:AddDoubleField("g_faceFrameBottomOverlap",           g_faceFrameBottomOverlap)
    dialog:AddDoubleField("g_faceFrameTopOverlap",              g_faceFrameTopOverlap)
    dialog:AddDoubleField("g_lowerShelfFaceFrameWidth",         g_lowerShelfFaceFrameWidth)
    dialog:AddDoubleField("g_shelfOverlap",                     g_shelfOverlap)
    dialog:AddDoubleField("g_lowerHoleSpacing",                 g_lowerHoleSpacing)
    dialog:AddDoubleField("g_shelfWidthClearance",              g_shelfWidthClearance)
    dialog:AddDoubleField("g_toeKickDepth",                     g_toeKickDepth)
    dialog:AddDoubleField("g_toeKickHight",                     g_toeKickHight)
    dialog:AddDoubleField("g_lowerTopFrameWidth",               g_lowerTopFrameWidth)
    dialog:AddDoubleField("g_toeKickBottomOffsetHight",         g_toeKickBottomOffsetHight)
    dialog:AddDoubleField("g_lowerShelfCount",                  g_lowerShelfCount)
    dialog:AddDoubleField("g_lowerDrawerHeight",                g_lowerDrawerHeight)   
    dialog:AddDoubleField("g_lowerDrawerRowCount",              g_lowerDrawerRowCount)
    dialog:AddDoubleField("g_lowerNumberDrawersPerRow",         g_lowerNumberDrawersPerRow)
    dialog:AddDoubleField("g_lowerPinOuter",                    g_lowerPinOuter)
    dialog:AddDoubleField("g_lowerPinInter",                    g_lowerPinInter)
    dialog:AddDoubleField("g_lowerShelfClarence",               g_lowerShelfClarence)
    dialog:AddDoubleField("g_lowerFaceFrameSideGap",            g_lowerFaceFrameSideGap)
    dialog:AddDoubleField("g_lowerFaceFrameStileWidth",         g_lowerFaceFrameStileWidth)
    dialog:AddDoubleField("g_lowerFaceFrameBottomWidth",        g_lowerFaceFrameBottomWidth)
    dialog:AddDoubleField("g_lowerFaceFrameThickness",          g_lowerFaceFrameThickness)
    dialog:AddDoubleField("g_lowerFaceFrameTopWidth",           g_lowerFaceFrameTopWidth)
    dialog:AddDoubleField("g_lowerCenterFaceFrameWidth",        g_lowerCenterFaceFrameWidth)
    dialog:AddDoubleField("g_lowerBottomFaceFrameOverlap",      g_lowerBottomFaceFrameOverlap)
    dialog:AddDoubleField("g_holeSpacing",                      g_holeSpacing)
    dialog:AddDoubleField("g_holeFirstRowSpacing",              g_holeFirstRowSpacing)
    dialog:AddDoubleField("g_lowerFirstRowSpacingForHole",      g_lowerFirstRowSpacingForHole)
    dialog:AddDoubleField("g_holeLastRowSpacing",               g_holeLastRowSpacing)
    dialog:AddDoubleField("g_lowerLastHoleRowSpacing",          g_lowerLastHoleRowSpacing)
    dialog:AddLabelField("ToolNameLabel",                       g_defaultToolName)
	dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", 	g_defaultToolName)
	dialog:AddToolPickerValidToolType("ToolChooseButton",     	Tool.END_MILL)
    dialog:AddTextField("g_jobPath",                            g_jobPath);
    dialog:AddTextField("g_lowerAddCenterPanel",                g_lowerAddCenterPanel)
    dialog:AddTextField("g_lowerAddCenterFaceFrame",            g_lowerAddCenterFaceFrame)
    dialog:AddTextField("g_lowerAddDrawers",                    g_lowerAddDrawers)
    dialog:AddTextField("g_centerPanel",                        g_centerPanel)
    dialog:AddTextField("g_faceFrameCenter",                    g_faceFrameCenter)
    dialog:AddDirectoryPicker("g_selectJobPath",  "g_jobPath", true);
	if not dialog:ShowDialog() then
		return false
		-- Done and run ;-)
	end
	local tool = dialog:GetTool("ToolChooseButton")
-- Get the data from the Dialog and update my global variables
	g_millingTool                   = tool
	g_pinOuter                      = tonumber(dialog:GetDoubleField("g_pinOuter"))
    g_pinInter                      = tonumber(dialog:GetDoubleField("g_pinInter"))
    g_pinShelfClarence              = tonumber(dialog:GetDoubleField("g_pinShelfClarence"))
    g_materialThicknessBack         = tonumber(dialog:GetDoubleField("g_materialThicknessBack"))
    g_faceFrameSideGap              = tonumber(dialog:GetDoubleField("g_faceFrameSideGap"))
    g_faceFrameSideWidth            = tonumber(dialog:GetDoubleField("g_faceFrameSideWidth"))
    g_faceFrameBottomWidth          = tonumber(dialog:GetDoubleField("g_faceFrameBottomWidth"))
    g_millClearnaceOffset           = tonumber(dialog:GetDoubleField("g_millClearnaceOffset"))
    g_millOffset                    = tonumber(dialog:GetDoubleField("g_millOffset"))
    g_materialThickness             = tonumber(dialog:GetDoubleField("g_materialThickness"))
    g_shelfPinDiameter              = tonumber(dialog:GetDoubleField("g_shelfPinDiameter"))
    g_upperCabinetLenght            = tonumber(dialog:GetDoubleField("g_upperCabinetLenght"))
    g_upperCabinetHeight            = tonumber(dialog:GetDoubleField("g_upperCabinetHeight"))
    g_upperCabinetDepth             = tonumber(dialog:GetDoubleField("g_upperCabinetDepth"))
    g_lowerCabinetLenght            = tonumber(dialog:GetDoubleField("g_lowerCabinetLenght"))
    g_lowerCabinetHeight            = tonumber(dialog:GetDoubleField("g_lowerCabinetHeight"))
    g_lowerCabinetDepth             = tonumber(dialog:GetDoubleField("g_lowerCabinetDepth"))
    g_shelfCount                    = tonumber(dialog:GetDoubleField("g_shelfCount"))
    g_shelfFaceFrameWidth           = tonumber(dialog:GetDoubleField("g_shelfFaceFrameWidth"))
    g_faceFrameThickness            = tonumber(dialog:GetDoubleField("g_faceFrameThickness"))
    g_lowerTopFrameWidth            = tonumber(dialog:GetDoubleField("g_lowerTopFrameWidth"))
    g_faceFrameTopWidth             = tonumber(dialog:GetDoubleField("g_faceFrameTopWidth"))
    g_faceFrameCenterWidth          = tonumber(dialog:GetDoubleField("g_faceFrameCenterWidth"))
    g_faceFrameBottomOverlap        = tonumber(dialog:GetDoubleField("g_faceFrameBottomOverlap"))
    g_faceFrameTopOverlap           = tonumber(dialog:GetDoubleField("g_faceFrameTopOverlap"))
    g_lowerHoleSpacing              = tonumber(dialog:GetDoubleField("g_lowerHoleSpacing"))
    g_shelfWidthClearance           = tonumber(dialog:GetDoubleField("g_shelfWidthClearance"))
    g_toeKickDepth                  = tonumber(dialog:GetDoubleField("g_toeKickDepth"))
    g_toeKickHight                  = tonumber(dialog:GetDoubleField("g_toeKickHight"))
    g_toeKickBottomOffsetHight      = tonumber(dialog:GetDoubleField("g_toeKickBottomOffsetHight"))
    g_lowerShelfFaceFrameWidth      = tonumber(dialog:GetDoubleField("g_lowerShelfFaceFrameWidth"))
    g_shelfOverlap                  = tonumber(dialog:GetDoubleField("g_shelfOverlap"))
    g_lowerAddCenterPanel           =          dialog:GetTextField("g_lowerAddCenterPanel")
    g_lowerAddCenterFaceFrame       =          dialog:GetTextField("g_lowerAddCenterFaceFrame")
    g_lowerAddDrawers               =          dialog:GetTextField("g_lowerAddDrawers")
    g_lowerShelfCount               = tonumber(dialog:GetDoubleField("g_lowerShelfCount"))
    g_lowerDrawerHeight             = tonumber(dialog:GetDoubleField("g_lowerDrawerHeight"))
    g_lowerDrawerRowCount           = tonumber(dialog:GetDoubleField("g_lowerDrawerRowCount"))
    g_lowerNumberDrawersPerRow      = tonumber(dialog:GetDoubleField("g_lowerNumberDrawersPerRow"))
    g_lowerPinOuter                 = tonumber(dialog:GetDoubleField("g_lowerPinOuter"))
    g_lowerPinInter                 = tonumber(dialog:GetDoubleField("g_lowerPinInter"))
    g_lowerShelfClarence            = tonumber(dialog:GetDoubleField("g_lowerShelfClarence"))
    g_lowerFaceFrameSideGap         = tonumber(dialog:GetDoubleField("g_lowerFaceFrameSideGap"))
    g_lowerFaceFrameStileWidth      = tonumber(dialog:GetDoubleField("g_lowerFaceFrameStileWidth"))
    g_lowerFaceFrameBottomWidth     = tonumber(dialog:GetDoubleField("g_lowerFaceFrameBottomWidth"))
    g_lowerFaceFrameThickness       = tonumber(dialog:GetDoubleField("g_lowerFaceFrameThickness"))
    g_lowerFaceFrameTopWidth        = tonumber(dialog:GetDoubleField("g_lowerFaceFrameTopWidth"))
    g_lowerCenterFaceFrameWidth     = tonumber(dialog:GetDoubleField("g_lowerCenterFaceFrameWidth"))
    g_lowerBottomFaceFrameOverlap   = tonumber(dialog:GetDoubleField("g_lowerBottomFaceFrameOverlap"))
    g_holeSpacing                   = tonumber(dialog:GetDoubleField("g_holeSpacing"))
    g_holeFirstRowSpacing           = tonumber(dialog:GetDoubleField("g_holeFirstRowSpacing"))
    g_lowerFirstRowSpacingForHole   = tonumber(dialog:GetDoubleField("g_lowerFirstRowSpacingForHole"))
    g_holeLastRowSpacing            = tonumber(dialog:GetDoubleField("g_holeLastRowSpacing"))
    g_lowerLastHoleRowSpacing       = tonumber(dialog:GetDoubleField("g_lowerLastHoleRowSpacing"))
    --g_centerPanel                   = dialog:GetTextField("g_centerPanel")
    --g_faceFrameCenter               = dialog:GetTextField("g_faceFrameCenter")
    --g_jobPath                       = dialog:GetTextField("g_jobPath")
    --g_defaultToolName               = tool.Name
   -- g_toolSizeDia = tool.ToolDia
    --g_toolSizeRadus = g_toolSizeDia * 0.50 
    g_pinRadus = g_shelfPinDiameter * 0.5
    
    g_toolSizeDia = 0.25
    g_toolSizeRadus = g_toolSizeDia * 0.50 
--[[	if g_millingTool == nil then
		MessageBox("No tool selected!")
		return 2		-- 2 value will get the user back to the Cabinet dialog
	end
	
    if g_jobPath == "C://" then
		MessageBox("No Job Path selected!")
		return 2 		-- 2 value will get the user back to the Cabinet dialog
	end
    ]]
    return true
end  -- function end
-- ==============================================================================
function main(script_path)
    -- create a layer with passed name if it doesn't already exist
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
    -- g_boxHight =  g_upperCabinetHeight - (g_faceFrameTopWidth + g_faceFrameBottomWidth + g_faceFrameBottomOverlap + g_faceFrameTopOverlap + (g_materialThickness * 2.0))
    g_boxHight =  (g_upperCabinetHeight - (g_faceFrameTopWidth + g_faceFrameBottomWidth)) + (g_faceFrameBottomOverlap + g_faceFrameTopOverlap + (g_materialThickness * 2.0))
    g_boxLength = g_upperCabinetLenght - (g_faceFrameSideGap * 2.0) ;     g_backHight = g_boxHight - g_materialThickness ;     g_backWidth = g_boxLength - g_materialThickness ;     g_boxDepth  = g_upperCabinetDepth - g_faceFrameThickness
    g_lowerBoxDepth = g_lowerCabinetDepth - g_lowerFaceFrameThickness
    g_lowerBoxLength = g_lowerCabinetLenght - (g_lowerFaceFrameSideGap * 2)
    UpperCabinetSide("L", g_materialThickness .. "-WallCab-LeftSide")
    UpperCabinetSide("R", g_materialThickness .. "-WallCab-RightSide")
    UpperCabinetTandB("T", g_materialThickness .. "-WallCab-Top" )
    UpperCabinetTandB("B", g_materialThickness .. "-WallCab-Bottom")
    UpperCabinetBack(g_materialThicknessBack .. "-WallCab-Back") 
    if g_shelfCount >= 1 then
        local g_shelfCountX = g_shelfCount
        while (g_shelfCountX > 0) do
        --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
            lay = g_materialThickness .. "-WallCab-Shelf".. g_shelfCountX        
            UpperCabinetShelf(lay, g_shelfCountX)
            g_shelfCountX = g_shelfCountX - 1
        end
    end
    if g_centerPanel ==  "Y" then
        UpperCenterPanel(g_materialThickness ..  "-WallCab-CenterPanel")
    end
    UpperCabinetFaceFrame("WallCab-FaceFrame")
    LowerCabinetSide("L", g_materialThickness .. "-BaseCab-LeftSide")
    LowerCabinetSide("R", g_materialThickness .. "-BaseCab-RightSide")
    LowerCabinetBottom(g_materialThickness ..    "-BaseCab-Bottom" )
    LowerCabinetBack(g_materialThicknessBack ..  "-BaseCab-Back") 
    if g_lowerShelfCount >= 1 then
        local g_lowerShelfCountX = g_lowerShelfCount
        while (g_lowerShelfCountX > 0) do
        --Loop here, draw each Shelf on it own Layer and the Lay name will number per count
            lay = g_materialThickness .. "-BaseCab-Shelf".. g_lowerShelfCountX        
            LowerCabinetShelf(lay, g_lowerShelfCountX)
            g_lowerShelfCountX = g_lowerShelfCountX - 1
        end
    end
    if g_lowerAddCenterFaceFrame ==  "Y" then
        LowerCenterPanel(g_materialThickness .. "-BaseCab-CenterPanel")
    end
    LowerCabinetFaceFrame("BaseCab-FaceFrame")
    CutListfileWriter(g_jobPath)
-- Regenerate the drawing display
	job:Refresh2DView()
    return true 
end