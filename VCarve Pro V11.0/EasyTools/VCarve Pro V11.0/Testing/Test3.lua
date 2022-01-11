-- VECTRIC LUA SCRIPT
require "strict"
-- require("mobdebug").start()
--Global variables
function DrawTextWriter(what, where, size, lay, ang)
  local group
--[[ How to use:
|    local TextMessage = "Your Text Here"
|    local TextPt = Point2D(3.5,3.8)
|    local TextHight = 0.5
|    local TextLayer = "Jim Anderson"
|    local TextAng = 20.0
|    DrawTextWriter(TextMessage ,local TextPt , TextHight , TextLayer,TextAng )
|    -- ==Draw Writer==
|    -- Utilizing a provided string of text, the program walks the string and reproduces each letter (parametrically) on the drawing using vectors.
function main()
    -- create a layer with passed name if it doesn't already exist
  local job = VectricJob()
  if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;
  end
  local TextMessage = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0 ! @ # $ % & * ( ) { } [ ] ? , . : ; '' ' _ - + = ~ ^ < > |"
  local TextPt = Point2D(0.1, 2.0)
  local TextHight = 0.25
  local TextLayer = "Gadget Text"
  local TextAng = 10.0
  DrawTextWriter(TextMessage, TextPt, TextHight, TextLayer, TextAng)
	job:Refresh2DView()
  return true
end
-- -----------------------------------------------------]]
-- ==============================================================================
local function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ==============================================================================
local function MonoFont(job, pt, letter, scl, lay, ang)
  scl = (scl * 0.5) ;
  local pA0 = pt ;
  local pA1 = Polar2D(pt, ang + 90.0000, (0.2500 * scl)) ;
  local pA2 = Polar2D(pt, ang + 90.0000, (0.5000 * scl)) ;
  local pA3 = Polar2D(pt, ang + 90.0000, (0.7500 * scl)) ;
  local pA4 = Polar2D(pt, ang + 90.0000, (1.0000 * scl)) ;
  local pA5 = Polar2D(pt, ang + 90.0000, (1.2500 * scl)) ;
  local pA6 = Polar2D(pt, ang + 90.0000, (1.5000 * scl)) ;
  local pA7 = Polar2D(pt, ang + 90.0000, (1.7500 * scl)) ;
  local pA8 = Polar2D(pt, ang + 90.0000, (2.0000 * scl)) ;
  local pA9 = Polar2D(pt, ang + 90.0000, (2.2500 * scl)) ;
  local pA10 = Polar2D(pt, ang + 90.0000, (2.5000 * scl)) ;
  local pB0 = Polar2D(pt, ang +  0.0000, (0.2500 * scl)) ;
  local pB1 = Polar2D(pt, ang + 45.0000, (0.3536 * scl)) ;
  local pB2 = Polar2D(pt, ang + 63.4352, (0.5590 * scl)) ;
  local pB3 = Polar2D(pt, ang + 71.5651, (0.7906 * scl)) ;
  local pB4 = Polar2D(pt, ang + 75.9638, (1.0308 * scl)) ;
  local pB5 = Polar2D(pt, ang + 78.6901, (1.2748 * scl)) ;
  local pB6 = Polar2D(pt, ang + 80.5376, (1.5207 * scl)) ;
  local pB7 = Polar2D(pt, ang + 81.8699, (1.7678 * scl)) ;
  local pB8 = Polar2D(pt, ang + 82.8750, (2.0156 * scl)) ;
  local pB10 = Polar2D(pt, ang + 84.2894, (2.5125 * scl)) ;
  local pC0 = Polar2D(pt, ang +  0.0000, (0.5000 * scl)) ;
  local pC1 = Polar2D(pt, ang + 26.5650, (0.5590 * scl)) ;
  local pC2 = Polar2D(pt, ang + 45.0000, (0.7071 * scl)) ;
  local pC3 = Polar2D(pt, ang + 56.3099, (0.9014 * scl)) ;
  local pC4 = Polar2D(pt, ang + 63.4342, (1.1180 * scl)) ;
  local pC5 = Polar2D(pt, ang + 68.1993, (1.3463 * scl)) ;
  local pC6 = Polar2D(pt, ang + 71.5650, (1.5811 * scl)) ;
  local pC7 = Polar2D(pt, ang + 63.4342, (1.1180 * scl)) ;
  local pC8 = Polar2D(pt, ang + 75.9640, (2.0616 * scl)) ;
  local pC10 = Polar2D(pt, ang + 78.6899, (2.5495 * scl)) ;
  local pD0 = Polar2D(pt, ang +  0.0000, (0.6250 * scl)) ;
  local pD1 = Polar2D(pt, ang + 21.8014, (0.6731 * scl)) ;
  local pD2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ;
  local pD4 = Polar2D(pt, ang + 57.9946, (1.1792 * scl)) ;
  local pD7 = Polar2D(pt, ang + 70.3462, (1.8583 * scl)) ;
  local pD8 = Polar2D(pt, ang + 72.6460, (2.0954 * scl)) ;
  local pE0 = Polar2D(pt, ang +  0.0000, (0.7500 * scl)) ;
  local pE1 = Polar2D(pt, ang + 18.4346, (0.7906 * scl)) ;
  local pE2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl)) ;
  local pE3 = Polar2D(pt, ang + 45.0000, (1.0607 * scl)) ;
  local pE5 = Polar2D(pt, ang + 59.0371, (1.4578 * scl)) ;
  local pE6 = Polar2D(pt, ang + 63.4349, (1.6771 * scl)) ;
  local pE7 = Polar2D(pt, ang + 66.4349, (1.9039 * scl)) ;
  local pE8 = Polar2D(pt, ang + 69.4440, (2.1360 * scl)) ;
  local pF0 = Polar2D(pt, ang +  0.0000, (1.0000 * scl)) ;
  local pF1 = Polar2D(pt, ang + 14.0360, (1.0308 * scl)) ;
  local pF2 = Polar2D(pt, ang + 26.5651, (1.1180 * scl)) ;
  local pF3 = Polar2D(pt, ang + 36.8699, (1.2500 * scl)) ;
  local pF4 = Polar2D(pt, ang + 45.0000, (1.4142 * scl)) ;
  local pF5 = Polar2D(pt, ang + 51.3425, (1.6006 * scl)) ;
  local pF6 = Polar2D(pt, ang + 56.3099, (1.8025 * scl)) ;
  local pF7 = Polar2D(pt, ang + 60.2551, (2.0156 * scl)) ;
  local pF8 = Polar2D(pt, ang + 63.4349, (2.2361 * scl)) ;
  local pG0 = Polar2D(pt, ang +  0.0000, (1.2500 * scl)) ;
  local pG1 = Polar2D(pt, ang + 11.3099, (1.2748 * scl)) ;
  local pG2 = Polar2D(pt, ang + 21.8014, (1.3463 * scl)) ;
  local pG3 = Polar2D(pt, ang + 30.9638, (1.4577 * scl)) ;
  local pG4 = Polar2D(pt, ang + 38.6598, (1.6008 * scl)) ;
  local pG5 = Polar2D(pt, ang + 45.0000, (1.7678 * scl)) ;
  local pG6 = Polar2D(pt, ang + 50.1944, (1.9526 * scl)) ;
  local pG7 = Polar2D(pt, ang + 54.4623, (2.1506 * scl)) ;
  local pG8 = Polar2D(pt, ang + 57.9946, (2.3585 * scl)) ;
  local pG10 = Polar2D(pt,59.0362, (2.9155 * scl)) ;
  local pH0 = Polar2D(pt, ang +  0.0000, (1.5000 * scl)) ;
  local pH10 = Polar2D(pt,63.4349, (2.7951 * scl)) ;
  local layer = job.LayerManager:GetLayerWithName(lay) ;
  local line = Contour(0.0) ;
 -- ------------------------------------------------------------------
  if letter == 32 then ;
    pH0 = pH0 ;
  end ;

  if letter == 33 then ;
    line:AppendPoint(pB0) ;
    line:LineTo(pE0) ;
    line:LineTo(pE2) ;
    line:LineTo(pB2) ;
    line:LineTo(pB0) ;
    group:AddTail(line) ;
    line = Contour(0.0) line:AppendPoint(pB3) ;
    line:LineTo(pE3) ;
    line:LineTo(pE8) ;
    line:LineTo(pB8) ;
    line:LineTo(pB3) ;
    group:AddTail(line) ;
  end ;

  if letter == 34 then ;
    line:AppendPoint(pA7) ;
    line:LineTo(pB10) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pB7) ;
    line:LineTo(pC10) ;
    group:AddTail(line) ;
    pH0 = pE0 ;
  end ;

  if letter == 35 then ;
    line:AppendPoint(pA2) ;
    line:LineTo(pG2) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA6) ;
    line:LineTo(pG6) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pB0) ;
    line:LineTo(pB8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pF0) ;
    line:LineTo(pF8) ;
    group:AddTail(line) ;
  end ;

  if letter == 36 then ;
    line:AppendPoint(pA1) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG1) ;
    line:LineTo(pG3) ;
    line:LineTo(pF4) ;
    line:LineTo(pB4) ;
    line:LineTo(pA5) ;
    line:LineTo(pA7) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG7) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pC0) ;
    line:LineTo(pE0) ;
    line:LineTo(pE8) ;
    line:LineTo(pC8) ;
    line:LineTo(pC0) ;
    group:AddTail(line) ;
  end ;

  if letter == 37 then ;
    line:AppendPoint(pC6) ;
    line:LineTo(pC8) ;
    line:LineTo(pA8) ;
    line:LineTo(pA6) ;
    line:LineTo(pE6) ;
    line:LineTo(pG8) ;
    line:LineTo(pA0) ;
    line:LineTo(pC2) ;
    line:LineTo(pG2) ;
    line:LineTo(pG0) ;
    line:LineTo(pE0) ;
    line:LineTo(pE2) ;
    group:AddTail(line) ;
  end ;

  if letter == 38 then ;
    line:AppendPoint(pG2) ;
    line:LineTo(pG1) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    line:LineTo(pA1) ;
    line:LineTo(pA3) ;
    line:LineTo(pE6) ;
    line:LineTo(pE7) ;
    line:LineTo(pD8) ;
    line:LineTo(pB8) ;
    line:LineTo(pA7) ;
    line:LineTo(pA6) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 39 then ;
    line:AppendPoint(pA7) ;
    line:LineTo(pB10) ;
    group:AddTail(line) ;
    pH0 = pC0 ;
  end ;

  if letter == 40 then ;
    line:AppendPoint(pB8) ;
    line:LineTo(pA5) ;
    line:LineTo(pA3) ;
    line:LineTo(pB0) ;
    group:AddTail(line) ;
    pH0 = pD0 ;
  end ;

  if letter == 41 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pB5) ;
    line:LineTo(pB3) ;
    line:LineTo(pA0) ;
    group:AddTail(line) ;
    pH0 = pG0 ;
  end ;


  if letter == 42 then ;
    line:AppendPoint(pA2) ;
    line:LineTo(pG6) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA6) ;
    line:LineTo(pG2) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA4) ;
    line:LineTo(pG4) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pD7) ;
    line:LineTo(pD1) ;
    group:AddTail(line) ;
  end ;


  if letter == 43 then ;
    line:AppendPoint(pA4) ;
    line:LineTo(pG4) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pD1) ;
    line:LineTo(pD7) ;
    group:AddTail(line) ;
  end ;


  if letter == 44 then ;
    line:AppendPoint(pC0) ;
    line:LineTo(pE2) ;
    line:LineTo(pC2) ;
    line:LineTo(pC4) ;
    line:LineTo(pF4) ;
    line:LineTo(pF2) ;
    line:LineTo(pD0) ;
    line:LineTo(pC0) ;
    group:AddTail(line) ;
  end ;

  if letter == 45 then ;
    line:AppendPoint(pA4) ;
    line:LineTo(pG4) ;
    group:AddTail(line) ;
  end ;

  if letter == 46 then ;
    line:AppendPoint(pA1) ;
    line:LineTo(pB1) ;
    line:LineTo(pB0) ;
    line:LineTo(pA0) ;
    line:LineTo(pA1) ;
    group:AddTail(line) ;
    pH0 = pD0 ;
  end ;

  if letter == 47 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pF8) ;
    group:AddTail(line) ;
    pH0 = pG0 ;
  end ;

  if letter == 48 then ;
    line:AppendPoint(pB0) ;
    line:LineTo(pA2) ;
    line:LineTo(pA6) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG6) ;
    line:LineTo(pG2) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pG8) ;
    line:LineTo(pA0) ;

    group:AddTail(line) ;
  end ;

  if letter == 49 then ;
    line:AppendPoint(pA6) ;
    line:LineTo(pD8) ;
    line:LineTo(pD0) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA0) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 50 then ;
    line:AppendPoint(pA6) ;
    line:LineTo(pA7) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG7) ;
    line:LineTo(pG5) ;
    line:LineTo(pA2) ;
    line:LineTo(pA0) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 51 then ;
    line:AppendPoint(pA7) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG7) ;
    line:LineTo(pG5) ;
    line:LineTo(pF4) ;
    line:LineTo(pG3) ;
    line:LineTo(pG1) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    line:LineTo(pA1) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pF4) ;
    line:LineTo(pB4) ;
    group:AddTail(line) ;
  end ;

  if letter == 52 then ;
    line:AppendPoint(pF0) ;
    line:LineTo(pF8) ;
    line:LineTo(pA2) ;
    line:LineTo(pG2) ;
    group:AddTail(line) ;
  end ;

  if letter == 53 then ;
    line:AppendPoint(pG8) ;
    line:LineTo(pA8) ;
    line:LineTo(pA5) ;
    line:LineTo(pF4) ;
    line:LineTo(pG3) ;
    line:LineTo(pG1) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    line:LineTo(pA1) ;
    line:LineTo(pA2) ;
    group:AddTail(line) ;
  end ;

  if letter == 54 then ;
    line:AppendPoint(pG7) ;
    line:LineTo(pF8) ;
    line:LineTo(pB8) ;
    line:LineTo(pA7) ;
    line:LineTo(pA1) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG1) ;
    line:LineTo(pG3) ;
    line:LineTo(pF4) ;
    line:LineTo(pB4) ;
    line:LineTo(pA2) ;
    group:AddTail(line) ;
  end ;

  if letter == 55 then ;
    line:AppendPoint(pB0) ;
    line:LineTo(pG8) ;
    line:LineTo(pA8) ;
    group:AddTail(line) ;
  end ;

  if letter == 56 then ;
    line:AppendPoint(pA1) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG1) ;
    line:LineTo(pG3) ;
    line:LineTo(pF4) ;
    line:LineTo(pG5) ;
    line:LineTo(pG7) ;
    line:LineTo(pF8) ;
    line:LineTo(pB8) ;
    line:LineTo(pA7) ;
    line:LineTo(pA5) ;
    line:LineTo(pB4) ;
    line:LineTo(pA3) ;
    line:LineTo(pA1) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pB4) ;
    line:LineTo(pF4) ;
    group:AddTail(line) ;
  end ;

  if letter == 57 then ;
    line:AppendPoint(pA1) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG3) ;
    line:LineTo(pG7) ;
    line:LineTo(pF8) ;
    line:LineTo(pB8) ;
    line:LineTo(pA7) ;
    line:LineTo(pA5) ;
    line:LineTo(pB4) ;
    line:LineTo(pF4) ;
    line:LineTo(pG5) ;
    group:AddTail(line) ;
  end ;

  if letter == 58 then ;
    line:AppendPoint(pB8) ;
    line:LineTo(pA8) ;
    line:LineTo(pA7) ;
    line:LineTo(pB7) ;
    line:LineTo(pB8) ;
    line:LineTo(pA8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA1) ;
    line:LineTo(pB1) ;
    line:LineTo(pB0) ;
    line:LineTo(pA0) ;
    line:LineTo(pA1) ;
    group:AddTail(line) ;
    pH0 = pD0 ;
  end ;

  if letter == 59 then ;
    line:AppendPoint(pB8) ;
    line:LineTo(pA8) ;
    line:LineTo(pA7) ;
    line:LineTo(pB7) ;
    line:LineTo(pB8) ;
    line:LineTo(pA8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pB3) ;
    line:LineTo(pB4) ;
    line:LineTo(pA4) ;
    line:LineTo(pA3) ;
    line:LineTo(pB3) ;
    line:LineTo(pA0) ;
    group:AddTail(line) ;
    pH0 = pD0 ;
  end ;

  if letter == 60 then ;
    line:AppendPoint(pF8) ;
    line:LineTo(pA4) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 61 then ;
    line:AppendPoint(pA2) ;
    line:LineTo(pG2) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA6) ;
    line:LineTo(pG6) ;
    group:AddTail(line) ;
  end ;

  if letter == 62 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pF4) ;
    line:LineTo(pA0) ;
    group:AddTail(line) ;
  end ;

  if letter == 63 then ;
    line:AppendPoint(pB5) ;
    line:LineTo(pA6) ;
    line:LineTo(pA7) ;
    line:LineTo(pB8) ;
    line:LineTo(pE8) ;
    line:LineTo(pF7) ;
    line:LineTo(pF5) ;
    line:LineTo(pC3) ;
    line:LineTo(pC2) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pB0) ;
    line:LineTo(pE0) ;
    line:LineTo(pE1) ;
    line:LineTo(pB1) ;
    line:LineTo(pB0) ;
    group:AddTail(line) ;
  end ;

  if letter == 64 then ;
    line:AppendPoint(pG0) ;
    line:LineTo(pB0) ;
    line:LineTo(pA2) ;
    line:LineTo(pA6) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG6) ;
    line:LineTo(pG3) ;
    line:LineTo(pE2) ;
    line:LineTo(pB2) ;
    line:LineTo(pB5) ;
    line:LineTo(pE5) ;
    line:LineTo(pE2) ;
    group:AddTail(line) ;
  end ;

  if letter == 65 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pD8) ;
    line:LineTo(pG0) ;
    line:LineTo(pF3) ;
    line:LineTo(pB3) ;
    line:LineTo(pA0) ;
    group:AddTail(line) ;
  end ;

  if letter == 66 then ;
    line:AppendPoint(pA4) ;
    line:LineTo(pF4) ;
    line:LineTo(pG5) ;
    line:LineTo(pG7) ;
    line:LineTo(pF8) ;
    line:LineTo(pA8) ;
    line:LineTo(pA0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG1) ;
    line:LineTo(pG3) ;
    line:LineTo(pF4) ;
    group:AddTail(line) ;
  end ;

  if letter == 67 then ;
    line:AppendPoint(pG2) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    line:LineTo(pA2) ;
    line:LineTo(pA6) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG6) ;
    group:AddTail(line) ;
  end ;

  if letter == 68 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG2) ;
    line:LineTo(pG6) ;
    line:LineTo(pF8) ;
    line:LineTo(pA8) ;
    line:LineTo(pA0) ;
    group:AddTail(line) ;
  end ;

  if letter == 69 then ;
    line:AppendPoint(pG0) ;
    line:LineTo(pA0) ;
    line:LineTo(pA8) ;
    line:LineTo(pF8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA4) ;
    line:LineTo(pD4) ;
    group:AddTail(line) ;
  end ;

  if letter == 70 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA4) ;
    line:LineTo(pF4) ;
    group:AddTail(line) ;
  end ;

  if letter == 71 then ;
    line:AppendPoint(pG6) ;
    line:LineTo(pG7) ;
    line:LineTo(pF8) ;
    line:LineTo(pB8) ;
    line:LineTo(pA6) ;
    line:LineTo(pA2) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG2) ;
    line:LineTo(pG3) ;
    line:LineTo(pE3) ;
    line:LineTo(pE2) ;
    group:AddTail(line) ;
  end ;

  if letter == 72 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pG0) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA4) ;
    line:LineTo(pG4) ;
    group:AddTail(line) ;
  end ;

  if letter == 73 then ;
    line:AppendPoint(pB0) ;
    line:LineTo(pB8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA0) ;
    line:LineTo(pC0) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA8) ;
    line:LineTo(pC8) ;
    group:AddTail(line) ;
    pH0 = pE0 ;
  end ;

  if letter == 74 then ;
    line:AppendPoint(pA2) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG2) ;
    line:LineTo(pG8) ;
    line:LineTo(pC8) ;
    group:AddTail(line) ;
  end ;

  if letter == 75 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA2) ;
    line:LineTo(pG7) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pD4) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 76 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pA0) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 77 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    line:LineTo(pD4) ;
    line:LineTo(pG8) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 78 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    line:LineTo(pF0) ;
    line:LineTo(pF8) ;
    group:AddTail(line) ;
    pH0 = pG0 ;
  end ;

  if letter == 79 then ;
    line:AppendPoint(pB0) ;
    line:LineTo(pA2) ;
    line:LineTo(pA6) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG6) ;
    line:LineTo(pG2) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    group:AddTail(line) ;
  end ;

  if letter == 80 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG7) ;
    line:LineTo(pG5) ;
    line:LineTo(pF4) ;
    line:LineTo(pA4) ;
    group:AddTail(line) ;
  end ;

  if letter == 81 then ;
    line:AppendPoint(pB0) ;
    line:LineTo(pA2) ;
    line:LineTo(pA6) ;
    line:LineTo(pB8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG6) ;
    line:LineTo(pG2) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pG0) ;
    line:LineTo(pD4) ;
    group:AddTail(line) ;
  end ;

  if letter == 82 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA8) ;
    line:LineTo(pF8) ;
    line:LineTo(pG7) ;
    line:LineTo(pG5) ;
    line:LineTo(pF4) ;
    line:LineTo(pA4) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pD4) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 83 then ;
    line:AppendPoint(pG5) ;
    line:LineTo(pG6) ;
    line:LineTo(pF8) ;
    line:LineTo(pB8) ;
    line:LineTo(pA6) ;
    line:LineTo(pA5) ;
    line:LineTo(pG3) ;
    line:LineTo(pG2) ;
    line:LineTo(pF0) ;
    line:LineTo(pB0) ;
    line:LineTo(pA2) ;
    line:LineTo(pA3) ;
    group:AddTail(line) ;
  end ;

  if letter == 84 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pD8) ;
    line:LineTo(pD0) ;
    group:AddTail(line) ;
  end ;

  if letter == 85 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pA2) ;
    line:LineTo(pB0) ;
    line:LineTo(pF0) ;
    line:LineTo(pG2) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
  end ;

  if letter == 86 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pD0) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
  end ;

  if letter == 87 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pB0) ;
    line:LineTo(pD4) ;
    line:LineTo(pF0) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
  end ;

  if letter == 88 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pA8) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 89 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pD4) ;
    line:LineTo(pG8) ;
    group:AddTail(line) ;
    line = Contour(0.0) ;
    line:AppendPoint(pD0) ;
    line:LineTo(pD4) ;
    group:AddTail(line) ;
  end ;

  if letter == 90 then ;
    line:AppendPoint(pA8) ;
    line:LineTo(pG8) ;
    line:LineTo(pA0) ;
    line:LineTo(pG0) ;
    group:AddTail(line) ;
  end ;

  if letter == 91 then ;
    line:AppendPoint(pC0) ;
    line:LineTo(pB0) ;
    line:LineTo(pB8) ;
    line:LineTo(pC8) ;
    group:AddTail(line) ;
  end ;

  if letter == 92 then ;
    line:AppendPoint(pA4) ;
    line:LineTo(pG4) ;
    group:AddTail(line) ;
  end ;

  if letter == 93 then ;
    line:AppendPoint(pE0) ;
    line:LineTo(pF0) ;
    line:LineTo(pF8) ;
    line:LineTo(pE8) ;
    group:AddTail(line) ;
  end ;

  if letter == 94 then ;
    line:AppendPoint(pD8) ;
    line:LineTo(pG6) ;
    line:LineTo(pG5) ;
    line:LineTo(pD7) ;
    line:LineTo(pA5) ;
    line:LineTo(pA6) ;
    line:LineTo(pD8) ;
    group:AddTail(line) ;
  end ;

  if letter == 95 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pF0) ;
    group:AddTail(line) ;
  end ;

  if letter == 96 then ;
    line:AppendPoint(pA4) ;
    line:LineTo(pG4) ;
    group:AddTail(line) ;
  end ;

  if letter == 123 then ;
    line:AppendPoint(pD0) ;
    line:LineTo(pC0) ;
    line:LineTo(pB1) ;
    line:LineTo(pB2) ;
    line:LineTo(pC3) ;
    line:LineTo(pA4) ;
    line:LineTo(pC5) ;
    line:LineTo(pB6) ;
    line:LineTo(pB7) ;
    line:LineTo(pC8) ;
    line:LineTo(pD8) ;
    group:AddTail(line) ;
  end ;

  if letter == 124 then ;
    line:AppendPoint(pA0) ;
    line:LineTo(pA10) ;
    line:LineTo(pC10) ;
    line:LineTo(pC0) ;
    line:LineTo(pA0) ;
    group:AddTail(line) ;
  end ;

  if letter == 125 then ;
    line:AppendPoint(pD0) ;
    line:LineTo(pE0) ;
    line:LineTo(pF1) ;
    line:LineTo(pF2) ;
    line:LineTo(pE3) ;
    line:LineTo(pG4) ;
    line:LineTo(pE5) ;
    line:LineTo(pF6) ;
    line:LineTo(pF7) ;
    line:LineTo(pE8) ;
    line:LineTo(pD8) ;
    group:AddTail(line) ;
  end ;

  if letter == 126 then ;
    line:AppendPoint(pA2) ;
    line:LineTo(pA3) ;
    line:LineTo(pB5) ;
    line:LineTo(pF3) ;
    line:LineTo(pG5) ;
    line:LineTo(pG4) ;
    line:LineTo(pF2) ;
    line:LineTo(pB4) ;
    line:LineTo(pA2) ;
    group:AddTail(line) ;
  end ;
  return pH0
end ; -- function end ;

-- ==============================================================================
local function AddGroupToJob(job, group, layer_name)
   --  create a CadObject to represent the  group
  local cad_object = CreateCadGroup(group);
   -- create a layer with passed name if it doesnt already exist
  local layer = job.LayerManager:GetLayerWithName(layer_name)
   -- and add our object to it
  layer:AddObject(cad_object, true)
  return cad_object
end
-- =========================================================================
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: Not finding a job loaded")
    return false
  end ;
  local strlen = string.len(what)
  local strup = string.upper(what)
  local x = strlen
  local i = 1
  local y = ""
  local ptx = where
  group = ContourGroup(true)
  while i <=  x do
    y = string.byte(string.sub(strup, i, i))
    ptx = MonoFont(job, ptx, y, size, lay, ang)
    i = i + 1
  end -- while end;
  AddGroupToJob(job, group, lay)
  job:Refresh2DView()
  return true ;
end ; -- function end ;
-- ==============================================================================
function main()
    -- create a layer with passed name if it doesn't already exist
  local job = VectricJob()
  if not job.Exists then
       DisplayMessageBox("No job loaded")
       return false;
  end
  local TextMessage = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0 ! @ # $ % & * ( ) { } [ ] ? , . : ; '' ' _ - + = ~ ^ < > |"
  local TextPt = Point2D(0.1, 2.0)
  local TextHight = 0.25
  local TextLayer = "Gadget Text"
  local TextAng = 10.0
  DrawTextWriter(TextMessage, TextPt, TextHight, TextLayer, TextAng)
	job:Refresh2DView()
  return true
end