-- VECTRIC LUA SCRIPT
--[[====================================================================================================================
--  Gadgets are an entirely optional add-in to Vectric's core software products.
--  They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
--  In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
--  Permission is granted to anyone to use this software for any purpose,
--  including commercial applications, and to alter it and redistribute it freely,
--  subject to the following restrictions:
--  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--  If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
--  2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--  3. This notice may not be removed or altered from any source distribution.
--  MDF Door Maker is written by JimAndi Gadgets of Houston Texas 2020
-- ========================================================================================================================

MDF Door Maker Gadget was written by JimAndi Gadgets 2021
-- Version Beta A - June 17, 2021
-- Version 1.0    - July 2, 2021
-- Version 2.0    - July 4, 2021
-- Version 3.0    - July 5, 2021
-- Version 4.0    - July 7, 2021
-- Version 5.0    - July 8, 2021   -- Error traps
-- Version 6.0    - July 10, 2021  -- Added BitOffset for Fluting
-- Version 7.0    - July 11, 2021  -- Fix Help File
-- Version 8.0    - July 12, 2021  -- Fixed Errors found in Arched Door
-- Version 9.0    - July 17, 2021  -- Rewrite code to use Door table as all points for door construction
-- Version 10.0   - July 19, 2021  -- Bug fix
-- Version 10.1   - July 20, 2021  -- Bug fix
-- ====================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
local VerNumber     = "10.2"
local AppName       = "Easy MDF Door Maker"
local RegName       = "EasyMDFDoorMaker"  .. VerNumber
local Version       = 10.2
--  Table Names
local Project       = {}
local Door          = {}
local DialogWindow  = {}   -- Dialog Management
local StyleA        = {}
local StyleB        = {}
local StyleC        = {}
local StyleE        = {}
local StyleF        = {}
local StyleG        = {}
local Maindialog
local MyProgressBar
Door.Style          = ""
Door.Height         = 0.0
Door.Width          = 0.0
Door.Row            = 0.0
Door.RowCount       = 1
Door.Records        = 1
Door.pt01 = Point2D(0,0)
DialogWindow.ProjectSDK  = "http://www.jimandi.com/EasyGadgets/EasyMDFDoorMaker/EasyMDFDoorMakerHelp.html"
-- ====================================================]]
function LengthOfFile(filename)-- Returns file line count
--[[
Counts the lines in a file
Returns: number
]]
    local len = 0
    if FileExists(filename) then
      local file = io.open(filename)
      for Line in file:lines() do
        len = len + 1
      end
      file:close() ;
    end
    return len
end -- function end
-- =====================================================]]
function FileExists(name)
-- FileExists(name
-- DisplayMessageBox(name)
    local f=io.open(name,"r")
    if f~=nil then
      io.close(f)
      return true
    else
      return false
    end
end -- Function end
-- ====================================================]]
function All_Trim(s)                                    -- Trims spaces off both ends of a string
 return s:match( "^%s*(.-)%s*$" )
end -- function end
-- ====================================================]]
function D2S(s)
  return string.format("%.4f", s)
end -- function end
-- ====================================================]]
function ProgressAmount(Record)
  local X1 = (100.0 / Door.Records)
  local X2 = X1 * Record
  local X3 = math.abs(X2)
  local X4 = (math.floor(X3))
  return (math.floor(math.abs((100.0 / Door.Records) * Record)))
end -- function end
-- ====================================================]]
function StartDateTime(LongShort)
--[[ Date Value Codes
--  |   %a  abbreviated weekday name (e.g., Wed)
--  |    %A  full weekday name (e.g., Wednesday)
--  |    %b  abbreviated month name (e.g., Sep)
--  |    %B  full month name (e.g., September)
--  |    %c  date and time (e.g., 09/16/98 23:48:10)
--  |    %d  day of the month (16) [01-31]
--  |    %H  hour, using a 24-hour clock (23) [00-23]
--  |    %I  hour, using a 12-hour clock (11) [01-12]
--  |    %M  minute (48) [00-59]
--  |    %m  month (09) [01-12]
--  |    %p  either "am" or "pm" (pm)
--  |    %S  second (10) [00-61]
--  |    %w  weekday (3) [0-6 = Sunday-Saturday]
--  |    %x  date (e.g., 09/16/98)
--  |    %X  time (e.g., 23:48:10)
--  |    %Y  full year (e.g., 1998)
--  |    %y  two-digit year (98) [00-99]
--  |    %%  the character `%´ ]]
  if LongShort then
    return os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p")
  else
    return os.date("%Y%m%d%H%M")
  end
end
-- ====================================================]]
function ChordSeg2Radius (Chr, Seg)
  local rad = ((((Chr * Chr)/(Seg * 4)) + Seg) / 2.0)
  return rad
end
-- ====================================================]]
function RadSeg2Chord(Rad, Seg)
  local Ang = 2 * math.acos(1 - (Seg/Rad))
  local Chord = (2 * Rad) * math.sin(Ang * 0.5)
  return Chord
end
-- ====================================================]]
function RadChord2Segment (Rad, Chord)
  local segment = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - Chord^2))))
  return segment
end
-- ====================================================]]
function DrawLine(Pt1, Pt2, Layer)
--[[Draws a line from Pt1 to Pt2 on the layer name.
function main(script_path)
local MyPt1 = Point2D(3.5,3.8)
local MyPt2 = Point2D(3.5,6.8)
local layer = "My Line"
DrawLine(MyPt1 , MyPt2, MyPt3, Layer)
return true
end -- function end
-- -----------------------------------------------------]]
  local line = Contour(0.0)
  local layer = Door.job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(Pt1) ;
  line:LineTo(Pt2) ;
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
-- ====================================================]]
function DrawBox(p1, p2, p3, p4, Layer)                -- Draws a box
  local line = Contour(0.0)
  local layer = Door.job.LayerManager:GetLayerWithName(Layer)
  line:AppendPoint(p1)
  line:LineTo(p2)
  line:LineTo(p3)
  line:LineTo(p4)
  line:LineTo(p1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
  -- ====================================================]]
function DoorSetUp(style)
  Door.HeightH = Door.Height * 0.5
  Door.WidthH  = Door.Width  * 0.5
  Door.CTR  = Point2D(Door.pt01.X + (Door.Width * 0.5), Door.pt01.Y + (Door.Height * 0.5)) -- Door Center
  Door.pt02 = Polar2D(Door.pt01,   0.0, Door.Width)
  Door.pt03 = Polar2D(Door.pt02,  90.0, Door.Height)
  Door.pt04 = Polar2D(Door.pt01,  90.0, Door.Height)
  DrawBox(Door.pt01, Door.pt02, Door.pt03, Door.pt04, Door.LayerOFrame)
  Door.Bctr = Polar2D(Door.CTR,  270.0, Door.HeightH) -- Bottom Outer Center
  Door.Tctr = Polar2D(Door.CTR,   90.0, Door.HeightH) -- Top Outer Center
  Door.Lctr = Polar2D(Door.CTR,  180.0, Door.WidthH) -- Left Outer Center
  Door.Rctr = Polar2D(Door.CTR,    0.0, Door.WidthH) -- Right Outer Center
  Door.CHR  = Polar2D(Door.CTR,    0.0, style.FluteSpacing) -- Left
  Door.CHT  = Polar2D(Door.CTR,   90.0, style.FluteSpacing) -- Top
  Door.CHL  = Polar2D(Door.CTR,  180.0, style.FluteSpacing) -- Left
  Door.CHB  = Polar2D(Door.CTR,  270.0, style.FluteSpacing) -- Bottom
  return true
end -- function end
  -- ==================================================]]
  function DoorStyleA()                                  -- Draws a Shaker Style Door
  DoorSetUp(StyleA)
  Door.ptT  = Polar2D(Door.CTR,   90.0, Door.HeightH - (StyleA.B + Door.BitRad)) -- Top
  Door.ptB  = Polar2D(Door.CTR,  270.0, Door.HeightH - (StyleA.B + Door.BitRad)) -- Bottom
  Door.ptR  = Polar2D(Door.CTR,    0.0, Door.WidthH - (StyleA.A + Door.BitRad)) -- Right
  Door.ptL  = Polar2D(Door.CTR,  180.0, Door.WidthH - (StyleA.A + Door.BitRad)) -- Left
  Door.VDist = GetDistance(Door.ptT, Door.ptB)
  Door.HDist = GetDistance(Door.ptR, Door.ptL)
  Door.VDistH = (Door.VDist * 0.5)
  Door.HDistH = (Door.HDist * 0.5)
  Door.ptTc = Polar2D(Door.ptT,   90.0, Door.BitRad) -- Top Rad Ctr
  Door.ptBc = Polar2D(Door.ptB,  270.0, Door.BitRad) -- Bottom Rad Ctr
  Door.ptRc = Polar2D(Door.ptR,    0.0, Door.BitRad) -- Right Rad Ctr
  Door.ptLc = Polar2D(Door.ptL,  180.0, Door.BitRad) -- Left Rad Ctr
  Door.pt05 = Polar2D(Polar2D(Door.pt01,   0.0, StyleA.A), 90.0, StyleA.B)
  Door.pt06 = Polar2D(Door.pt05,   0.0, (Door.Width - (StyleA.A * 2.0)))
  Door.pt07 = Polar2D(Door.pt06,  90.0, (Door.Height - (StyleA.B * 2.0)))
  Door.pt08 = Polar2D(Door.pt05,  90.0, (Door.Height - (StyleA.B * 2.0)))
  local WidthCheck = (Door.Width > (StyleA.A  * 2.0))
  local HeightCheck = (Door.Height > (StyleA.B * 2.0))
  if WidthCheck and HeightCheck then
    DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt08, Door.LayerIFrame)
    if StyleA.Fluting == "Vertical" then
      DoorStyleAVertical()
    elseif StyleA.Fluting == "Horizontal" then
      DoorStyleAHorizontal()
    elseif StyleA.Fluting == "Crossing" then
      DoorStyleAHorizontal()
      DoorStyleAVertical()
    end -- if end
  else
    DrawLine(Door.ptT, Door.ptB, Door.LayerIFrame)
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
  end
  RowPoint()
  return true
end -- function end
-- ====================================================]]
function DoorStyleAVertical()
  local fltCount = (GetDistance(Door.ptL, Door.ptR) / StyleA.FluteSpacing) - 1
  DrawLine(Door.ptT, Door.ptB, Door.LayerFlutes)
  if (1.0 < fltCount) then
    while fltCount > 1 do
      DrawLine(Polar2D(Door.CHR, 90.0, Door.VDistH), Polar2D(Door.CHR, 270.0, Door.VDistH), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHL, 90.0, Door.VDistH), Polar2D(Door.CHL, 270.0, Door.VDistH), Door.LayerFlutes)
      Door.CHR = Polar2D(Door.CHR,   0.0, StyleA.FluteSpacing)
      Door.CHL = Polar2D(Door.CHL, 180.0, StyleA.FluteSpacing)
      fltCount = fltCount - 2
    end -- while end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Flutes")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleAHorizontal()
  local fltCount = (GetDistance(Door.ptT, Door.ptB) / StyleA.FluteSpacing) - 1
  DrawLine(Door.ptL, Door.ptR, Door.LayerFlutes)
  if (1.0 < fltCount) then
    while fltCount > 1 do
      DrawLine(Polar2D(Door.CHT, 0.0, Door.HDistH), Polar2D(Door.CHT, 180.0, Door.HDistH), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHB, 0.0, Door.HDistH), Polar2D(Door.CHB, 180.0, Door.HDistH), Door.LayerFlutes)
      Door.CHT = Polar2D(Door.CHT,  90.0, StyleA.FluteSpacing)
      Door.CHB = Polar2D(Door.CHB, 270.0, StyleA.FluteSpacing)
      fltCount = fltCount - 2
    end -- while end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Flutes")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleB()                                  -- Draws a Cathedral Style Door
  DoorSetUp(StyleB)
  Door.ptT  = Polar2D(Door.CTR,   90.0, Door.HeightH - (StyleB.B + Door.BitRad)) -- Top
  Door.ptB  = Polar2D(Door.CTR,  270.0, Door.HeightH - (StyleB.C + Door.BitRad)) -- Bottom
  Door.ptR  = Polar2D(Door.CTR,    0.0, Door.WidthH - (StyleB.A + Door.BitRad)) -- Right
  Door.ptL  = Polar2D(Door.CTR,  180.0, Door.WidthH - (StyleB.A + Door.BitRad)) -- Left
  Door.VDist = GetDistance(Door.ptT, Door.ptB)
  Door.HDist = GetDistance(Door.ptR, Door.ptL)
  Door.VDistH = (Door.VDist * 0.5)
  Door.VDistHB = GetDistance(Door.CTR, Door.ptB)
  Door.VDistHT = GetDistance(Door.CTR, Door.ptT)
  Door.HDistH = (Door.HDist * 0.5)
  Door.ptTc = Polar2D(Door.ptT,   90.0, Door.BitRad) -- Top Rad Ctr
  Door.ptBc = Polar2D(Door.ptB,  270.0, Door.BitRad) -- Bottom Rad Ctr
  Door.ptRc = Polar2D(Door.ptR,    0.0, Door.BitRad) -- Right Rad Ctr
  Door.ptLc = Polar2D(Door.ptL,  180.0, Door.BitRad) -- Left Rad Ctr
  Door.pt05 = Polar2D(Polar2D(Door.pt01, 0.0, StyleB.A), 90.0, StyleB.C)
  Door.pt06 = Polar2D(Door.pt05,   0.0, (Door.Width - (StyleB.A * 2.0)))
  Door.pt07 = Polar2D(Door.pt06,  90.0, (Door.Height - (StyleB.B + StyleB.C)))
  Door.pt08 = Polar2D(Door.pt07, 180.0, StyleB.D)
  Door.pt10 = Polar2D(Door.pt05,  90.0, (Door.Height - (StyleB.B + StyleB.C)))
  Door.pt09 = Polar2D(Door.pt10,   0.0, StyleB.D)
  Door.pt11 = Polar2D(Door.Tctr, 270.0, StyleB.C)
  Door.pt12 = Polar2D(Door.pt11, 270.0, Door.BitRad)
  Door.Chor = GetDistance(Door.pt08, Door.pt09)
  Door.Seg = GetDistance(Door.ptTc, Door.pt11)
  Door.Rad = ChordSeg2Radius (Door.Chor, Door.Seg)
  Door.Seg = RadChord2Segment(Door.Rad, Door.Chor)
  local bulge =  Radius2Bulge (Door.pt09, Door.pt08, Door.Rad)
  local Flutes = true
  local WidthCheck = (Door.Width > (StyleB.A * 2.0))
  local ArchCheck1 = (Door.Width > (StyleB.A * 2.0) + (StyleB.D * 2.0))
  local ArchCheck2 = (Door.pt08.y + Door.Seg) == Door.pt11.y
  local HeightCheck = (Door.Height > (StyleB.A * 2.0))
  local RadCheck = Door.Rad * 2.0 > Door.Seg
  local LegCheck1 = (Door.pt08.x > Door.pt09.x)
  local LegCheck2 = (Door.pt05.y < Door.pt10.y)
  local LegCheck3 = (Door.CTR.y < Door.pt10.y)
  if WidthCheck and HeightCheck then
    if RadCheck and ArchCheck1 and ArchCheck2 and LegCheck1 and LegCheck2 and LegCheck3 then
      Door.Arch = true
      local line = Contour(0.0)
      local layer = Door.job.LayerManager:GetLayerWithName(Door.LayerIFrame)
      line:AppendPoint(Door.pt05)
      line:LineTo(Door.pt06)
      line:LineTo(Door.pt07)
      line:LineTo(Door.pt08)
      line:ArcTo(Door.pt09, bulge)
      line:LineTo(Door.pt10)
      line:LineTo(Door.pt05)
      layer:AddObject(CreateCadContour(line), true)
    else
      Door.Arch = false
      if LegCheck2 then
      DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt10, Door.LayerIFrame)
    else
      DrawLine(Door.ptL, Door.ptR, Door.LayerIFrame)
      Flutes = false
      end
      LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Arch panel")
    end
    Door.Rad = Door.Rad - Door.BitRad
    if Flutes then
      if StyleB.Fluting == "Vertical" then
        DoorStyleBVertical()
      elseif StyleB.Fluting == "Horizontal" then
        DoorStyleBHorizontal()
      elseif StyleB.Fluting == "Crossing" then
        DoorStyleBHorizontal()
        DoorStyleBVertical()
      end -- if end
    end
  else
    Door.Arch = false
    DrawLine(Door.ptL, Door.ptR, Door.LayerIFrame)
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
  end -- if end
  RowPoint()
  return true
end -- function end
-- ====================================================]]
function DoorStyleBVertical()
  local fltCount = (Door.HDist / StyleB.FluteSpacing) - 1
  local Seg   = GetDistance(Door.pt12, Door.ptT)
  Door.Chord = RadSeg2Chord(Door.Rad, Seg)
  local chord = (StyleB.FluteSpacing * 2.0)
  local seq = Seg

  local LegCheck1 = (Door.CTR.y < Door.pt10.y)
  if Door.Arch then
    DrawLine(Door.pt12, Door.ptB, Door.LayerFlutes)
  else
    DrawLine(Door.ptT,  Door.ptB, Door.LayerFlutes)
  end
  if (1.0 < fltCount) and LegCheck1 then
    while fltCount > 1 do
      if chord < Door.Chord and Door.Arch then
        seq = Seg - (Door.Rad - (0.5 * (math.sqrt((4.0 * Door.Rad^2) - chord^2))))
      else
        seq = 0.0
      end
      DrawLine(Polar2D(Door.CHR,  90.0, Door.VDistHT + seq), Polar2D(Door.CHR, 270.0, Door.VDistHB), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHL,  90.0, Door.VDistHT + seq), Polar2D(Door.CHL, 270.0, Door.VDistHB), Door.LayerFlutes)
      Door.CHR = Polar2D(Door.CHR,    0.0, StyleB.FluteSpacing) -- Right
      Door.CHL = Polar2D(Door.CHL,  180.0, StyleB.FluteSpacing) -- Left
      if Door.Arch then
        chord = chord + (StyleB.FluteSpacing * 2.0)
      end -- if end
      fltCount = fltCount - 2
    end -- while end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleBHorizontal()
 local seg, chord
  Door.PanelCTR = Polar2D(Door.ptB, 90.0, (GetDistance(Door.ptT, Door.ptB) * 0.5))
  Door.CHT = Polar2D(Door.PanelCTR,  90.0, StyleB.FluteSpacing)
  Door.CHB = Polar2D(Door.PanelCTR, 270.0, StyleB.FluteSpacing)
  Door.ptLx = Polar2D(Door.PanelCTR, 180.0, Door.HDistH)
  Door.ptRx = Polar2D(Door.PanelCTR,   0.0, Door.HDistH)
  DrawLine(Door.ptLx, Door.ptRx, Door.LayerFlutes)
  local fltCount = (GetDistance(Door.ptT, Door.ptB) / StyleB.FluteSpacing) - 1
  if (1.0 < fltCount) then
    while fltCount > 1 do
      DrawLine(Polar2D(Door.CHT,  0.0, Door.HDistH), Polar2D(Door.CHT, 180.0, Door.HDistH), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHB,  0.0, Door.HDistH), Polar2D(Door.CHB, 180.0, Door.HDistH), Door.LayerFlutes)
      Door.CHT = Polar2D(Door.CHT,   90.0, StyleB.FluteSpacing) -- Move Up
      Door.CHB = Polar2D(Door.CHB,  270.0, StyleB.FluteSpacing) -- Move Down
      fltCount = fltCount - 2
    end -- while end
    if Door.Arch then
      local ArchCount = (GetDistance(Polar2D(Door.CHT,  270.0, StyleB.FluteSpacing), Door.pt12) / StyleB.FluteSpacing)
      seg = GetDistance(Door.CHT, Door.pt12)
      chord = RadSeg2Chord(Door.Rad, seg)
      while ArchCount > 1 do
        DrawLine(Polar2D(Door.CHT,  0.0, (chord * 0.5)), Polar2D(Door.CHT, 180.0, (chord * 0.5)), Door.LayerFlutes)
        Door.CHT = Polar2D(Door.CHT, 90.0, StyleB.FluteSpacing)
        seg = GetDistance(Door.CHT, Door.pt12)
        chord = RadSeg2Chord(Door.Rad, seg)
        ArchCount = ArchCount - 1.0
      end -- while end
    end -- if end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleC()                                  -- Draws a Double Cathedral Style Door
  DoorSetUp(StyleC)
  Door.ptT  = Polar2D(Door.CTR,   90.0, Door.HeightH - (StyleC.B + Door.BitRad)) -- Top
  Door.ptB  = Polar2D(Door.CTR,  270.0, Door.HeightH - (StyleC.B + Door.BitRad)) -- Bottom
  Door.ptR  = Polar2D(Door.CTR,    0.0, Door.WidthH - (StyleC.A + Door.BitRad)) -- Right
  Door.ptL  = Polar2D(Door.CTR,  180.0, Door.WidthH - (StyleC.A + Door.BitRad)) -- Left
  Door.VDist = GetDistance(Door.ptT, Door.ptB)
  Door.HDist = GetDistance(Door.ptR, Door.ptL)
  Door.VDistH = (Door.VDist * 0.5)
  Door.VDistHB = GetDistance(Door.CTR, Door.ptB)
  Door.VDistHT = GetDistance(Door.CTR, Door.ptT)
  Door.HDistH = (Door.HDist * 0.5)
  Door.ptTc = Polar2D(Door.ptT,   90.0, Door.BitRad) -- Top Rad Ctr
  Door.ptBc = Polar2D(Door.ptB,  270.0, Door.BitRad) -- Bottom Rad Ctr
  Door.ptRc = Polar2D(Door.ptR,    0.0, Door.BitRad) -- Right Rad Ctr
  Door.ptLc = Polar2D(Door.ptL,  180.0, Door.BitRad) -- Left Rad Ctr
  Door.pt05 = Polar2D(Polar2D(Door.pt01, 0.0, StyleC.A), 90.0, StyleC.B)
  Door.pt06 = Polar2D(Door.pt05,   0.0, (Door.Width - (StyleC.A * 2.0)))
  Door.pt07 = Polar2D(Door.pt06,  90.0, (Door.Height - (StyleC.B * 2.0)))
  Door.pt08 = Polar2D(Door.pt07, 180.0, StyleC.D)
  Door.pt10 = Polar2D(Door.pt05,  90.0, (Door.Height - (StyleC.B * 2.0)))
  Door.pt09 = Polar2D(Door.pt10,   0.0, StyleC.D)
  Door.pt11 = Polar2D(Door.Tctr, 270.0, StyleC.C)
  Door.pt12 = Polar2D(Door.pt11, 270.0, Door.BitRad)
  Door.pt13 = Polar2D(Door.pt09, 270.0, (Door.Height - (StyleC.B * 2.0)))
  Door.pt14 = Polar2D(Door.pt08, 270.0, (Door.Height - (StyleC.B * 2.0)))
  Door.pt15 = Polar2D(Door.Bctr,  90.0, StyleC.C)
  Door.pt16 = Polar2D(Door.pt15,  90.0, Door.BitRad)
  Door.Chor = GetDistance(Door.pt08, Door.pt09)
  Door.Seg = GetDistance(Door.ptTc, Door.pt11)
  Door.Rad = ChordSeg2Radius (Door.Chor, Door.Seg)
  Door.Seg = RadChord2Segment(Door.Rad, Door.Chor)
  local bulge =  Radius2Bulge (Door.pt09, Door.pt08, Door.Rad)
  local Flutes = true
  local WidthCheck = (Door.Width > (StyleC.A * 2.0))
  local ArchCheck1 = (Door.Width > (StyleC.A * 2.0) + (StyleC.D * 2.0))
  local ArchCheck2 = (Door.pt08.y + Door.Seg) == Door.pt11.y
  local HeightCheck = (Door.Height > (StyleC.A * 2.0))
  local RadCheck = Door.Rad * 2.0 > Door.Seg
  local LegCheck1 = (Door.pt08.x > Door.pt09.x)
  local LegCheck2 = (Door.pt05.y < Door.pt10.y)
  local LegCheck3 = (Door.CTR.y < Door.pt10.y)

  if WidthCheck and HeightCheck then
    if RadCheck and ArchCheck1 and ArchCheck2 and LegCheck1 and LegCheck2 and LegCheck3 then
      Door.Arch = true
      local line = Contour(0.0)
      local layer = Door.job.LayerManager:GetLayerWithName(Door.LayerIFrame)
      line:AppendPoint(Door.pt05)
      line:LineTo(Door.pt13)
      line:ArcTo(Door.pt14, bulge)
      line:LineTo(Door.pt06)
      line:LineTo(Door.pt07)
      line:LineTo(Door.pt08)
      line:ArcTo(Door.pt09, bulge)
      line:LineTo(Door.pt10)
      line:LineTo(Door.pt05)
      layer:AddObject(CreateCadContour(line), true)
    else
      Door.Arch = false
      if LegCheck2 then
      DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt10, Door.LayerIFrame)
    else
      DrawLine(Door.ptL, Door.ptR, Door.LayerIFrame)
      Flutes = false
      end
      LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Arch panel")
    end
    Door.Rad = Door.Rad - Door.BitRad
    if Flutes then
      if StyleC.Fluting == "Vertical" then
        DoorStyleCVertical()
      elseif StyleC.Fluting == "Horizontal" then
        DoorStyleCHorizontal()
      elseif StyleC.Fluting == "Crossing" then
        DoorStyleCHorizontal()
        DoorStyleCVertical()
      end -- if end
    end
  else
    Door.Arch = false
    DrawLine(Door.ptL, Door.ptR, Door.LayerIFrame)
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
  end -- if end
  RowPoint()
  return true
end -- function end
-- ====================================================]]
function DoorStyleCVertical()
  local fltCount = (Door.HDist / StyleC.FluteSpacing) - 1
  local Seg   = GetDistance(Door.pt12, Door.ptT)
  Door.Chord = RadSeg2Chord(Door.Rad, Seg)
  local chord = (StyleC.FluteSpacing * 2.0)
  local seq = Seg
  local LegCheck1 = (Door.CTR.y < Door.pt10.y)
  if Door.Arch then
    DrawLine(Door.pt12, Door.pt16, Door.LayerFlutes)
  else
    DrawLine(Door.ptT,  Door.ptB, Door.LayerFlutes)
  end
  if (1.0 < fltCount) and LegCheck1 then
    while fltCount > 1 do
      if chord < Door.Chord and Door.Arch then
        seq = Seg - (Door.Rad - (0.5 * (math.sqrt((4.0 * Door.Rad^2) - chord^2))))
      else
        seq = 0.0
      end
      DrawLine(Polar2D(Door.CHR,  90.0, Door.VDistHT + seq), Polar2D(Door.CHR, 270.0, Door.VDistHB + seq), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHL,  90.0, Door.VDistHT + seq), Polar2D(Door.CHL, 270.0, Door.VDistHB + seq), Door.LayerFlutes)
      Door.CHR = Polar2D(Door.CHR,    0.0, StyleC.FluteSpacing) -- Right
      Door.CHL = Polar2D(Door.CHL,  180.0, StyleC.FluteSpacing) -- Left
      if Door.Arch then
        chord = chord + (StyleC.FluteSpacing * 2.0)
      end -- if end
      fltCount = fltCount - 2
    end -- while end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleCHorizontal()
 local seg, chord
  Door.PanelCTR = Polar2D(Door.ptB, 90.0, (GetDistance(Door.ptT, Door.ptB) * 0.5))
  Door.CHT = Polar2D(Door.PanelCTR,  90.0, StyleC.FluteSpacing)
  Door.CHB = Polar2D(Door.PanelCTR, 270.0, StyleC.FluteSpacing)
  Door.ptLx = Polar2D(Door.PanelCTR, 180.0, Door.HDistH)
  Door.ptRx = Polar2D(Door.PanelCTR,   0.0, Door.HDistH)
  DrawLine(Door.ptLx, Door.ptRx, Door.LayerFlutes)
  local fltCount = (GetDistance(Door.ptT, Door.ptB) / StyleC.FluteSpacing) - 1
  if (1.0 < fltCount) then
    while fltCount > 1 do
      DrawLine(Polar2D(Door.CHT,  0.0, Door.HDistH), Polar2D(Door.CHT, 180.0, Door.HDistH), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHB,  0.0, Door.HDistH), Polar2D(Door.CHB, 180.0, Door.HDistH), Door.LayerFlutes)
      Door.CHT = Polar2D(Door.CHT,   90.0, StyleC.FluteSpacing) -- Move Up
      Door.CHB = Polar2D(Door.CHB,  270.0, StyleC.FluteSpacing) -- Move Down
      fltCount = fltCount - 2
    end -- while end
    if Door.Arch then
      local ArchCount = (GetDistance(Polar2D(Door.CHT,  270.0, StyleC.FluteSpacing), Door.pt12) / StyleC.FluteSpacing)
      seg = GetDistance(Door.CHT, Door.pt12)
      chord = RadSeg2Chord(Door.Rad, seg)
      while ArchCount > 1 do
        DrawLine(Polar2D(Door.CHT,  0.0, (chord * 0.5)), Polar2D(Door.CHT, 180.0, (chord * 0.5)), Door.LayerFlutes)
        Door.CHT = Polar2D(Door.CHT, 90.0, StyleC.FluteSpacing)
        DrawLine(Polar2D(Door.CHB,  0.0, (chord * 0.5)), Polar2D(Door.CHB, 180.0, (chord * 0.5)), Door.LayerFlutes)
        Door.CHB = Polar2D(Door.CHB, 270.0, StyleC.FluteSpacing)
        seg = GetDistance(Door.CHT, Door.pt12)
        chord = RadSeg2Chord(Door.Rad, seg)
        ArchCount = ArchCount - 1.0
      end -- while end
    end -- if end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleE()                                 -- Draws a Arched Style Door
  DoorSetUp(StyleE)
  Door.ptT  = Polar2D(Door.CTR,   90.0, Door.HeightH - (StyleE.C + Door.BitRad)) -- Top
  Door.ptB  = Polar2D(Door.CTR,  270.0, Door.HeightH - (StyleE.C + Door.BitRad)) -- Bottom
  Door.ptR  = Polar2D(Door.CTR,    0.0, Door.WidthH  - (StyleE.A + Door.BitRad)) -- Right
  Door.ptL  = Polar2D(Door.CTR,  180.0, Door.WidthH  - (StyleE.A + Door.BitRad)) -- Left
  Door.VDist = GetDistance(Door.ptT, Door.ptB)
  Door.HDist = GetDistance(Door.ptR, Door.ptL)
  Door.VDistH = (Door.VDist * 0.5)
  Door.VDistHB = GetDistance(Door.CTR, Door.ptB)
  Door.VDistHT = GetDistance(Door.CTR, Door.ptT)
  Door.HDistH = (Door.HDist * 0.5)
  Door.ptTc = Polar2D(Door.ptT,   90.0, Door.BitRad) -- Top Rad Ctr
  Door.ptBc = Polar2D(Door.ptB,  270.0, Door.BitRad) -- Bottom Rad Ctr
  Door.ptRc = Polar2D(Door.ptR,    0.0, Door.BitRad) -- Right Rad Ctr
  Door.ptLc = Polar2D(Door.ptL,  180.0, Door.BitRad) -- Left Rad Ctr
  Door.pt05 = Polar2D(Polar2D(Door.pt01, 0.0, StyleE.A), 90.0, StyleE.C)
  Door.pt06 = Polar2D(Door.pt05,   0.0, (Door.Width  - (StyleE.A * 2.0)))
  Door.pt07 = Polar2D(Door.pt06,  90.0, (Door.Height - (StyleE.B + StyleE.C)))
  Door.pt08 = Polar2D(Door.pt05,  90.0, (Door.Height - (StyleE.B + StyleE.C)))
  Door.Chor = GetDistance(Door.pt07, Door.pt08)
  Door.Seg = StyleE.B - StyleE.C
  Door.Rad = ChordSeg2Radius (Door.Chor, Door.Seg)
  Door.Seg = RadChord2Segment(Door.Rad, Door.Chor)
  local bulge =  Radius2Bulge (Door.pt07, Door.pt08, ChordSeg2Radius (Door.Chor, Door.Seg))
  local Flutes = true
  local WidthCheck = (Door.Width > (StyleE.A * 2.0))
  local HeightCheck = (Door.Height > (StyleE.B + StyleE.C))
  local RadCheck = Door.Rad * 2.0 > Door.Seg
  local SegCheck = (Door.Rad > (Door.ptT.y - Door.pt07.y))
  local LegCheck1 = (Door.pt05.x < Door.pt06.x)
  local LegCheck2 = (Door.pt05.y < Door.pt08.y)
 if WidthCheck and HeightCheck and SegCheck then
    local line = Contour(0.0)
    local layer = Door.job.LayerManager:GetLayerWithName(Door.LayerIFrame)
    line:AppendPoint(Door.pt05)
    line:LineTo(Door.pt06)
    line:LineTo(Door.pt07)
    line:ArcTo(Door.pt08, bulge)
    line:LineTo(Door.pt05)
    layer:AddObject(CreateCadContour(line), true)
    Door.Rad = Door.Rad  - Door.BitRad
    if StyleE.Fluting == "Vertical" then
      DoorStyleEVertical()
    elseif StyleE.Fluting == "Horizontal" then
      DoorStyleEHorizontal()
    elseif StyleE.Fluting == "Crossing" then
      DoorStyleEHorizontal()
      DoorStyleEVertical()
    end -- if end
  else
    if  LegCheck1 and LegCheck2 then
      DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt08, Door.LayerIFrame)
    else
      DrawLine(Door.ptL, Door.ptR, Door.LayerFlutes)
    end --if end
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
  end -- if end
  RowPoint()
  return true
end -- function end
-- ====================================================]]
function DoorStyleEVertical()
  local fltCount = (Door.HDist / StyleE.FluteSpacing) - 1
  Door.Chord = StyleE.FluteSpacing * 2.0
  Door.Seg  = RadChord2Segment (Door.Rad, Door.Chord)
  local seq = Door.Seg
  DrawLine(Door.ptT, Door.ptB, Door.LayerFlutes)
  if (1.0 < fltCount)  then
    while fltCount > 1 do
      DrawLine(Polar2D(Door.CHR,  90.0, Door.VDistHT - Door.Seg), Polar2D(Door.CHR, 270.0, Door.VDistHB), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHL,  90.0, Door.VDistHT - Door.Seg), Polar2D(Door.CHL, 270.0, Door.VDistHB), Door.LayerFlutes)
      Door.CHR = Polar2D(Door.CHR,    0.0, StyleE.FluteSpacing) -- Right
      Door.CHL = Polar2D(Door.CHL,  180.0, StyleE.FluteSpacing) -- Left
      Door.Chord = Door.Chord + (StyleE.FluteSpacing * 2.0)
      Door.Seg  = RadChord2Segment (Door.Rad, Door.Chord)
      fltCount = fltCount - 2
    end -- while end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleEHorizontal()
 local seg, chord
  Door.PanelCTR = Polar2D(Door.ptB, 90.0, (GetDistance(Door.ptT, Door.ptB) * 0.5))
  Door.CHT = Polar2D(Door.PanelCTR,  90.0, StyleE.FluteSpacing)
  Door.CHB = Polar2D(Door.PanelCTR, 270.0, StyleE.FluteSpacing)
  Door.ptLx = Polar2D(Door.PanelCTR, 180.0, Door.HDistH)
  Door.ptRx = Polar2D(Door.PanelCTR,   0.0, Door.HDistH)

  local LegCheck1 = (Door.ptL.y < Door.pt08.y)
  local fltCount1 = ((GetDistance(Door.ptT, Door.CTR) - RadChord2Segment(Door.Rad, GetDistance(Door.ptL, Door.ptR))) / StyleE.FluteSpacing)
  local fltCount2 = (GetDistance(Door.CTR, Door.ptB) / StyleE.FluteSpacing)
  if LegCheck1 then
    DrawLine(Door.ptLx, Door.ptRx, Door.LayerFlutes)
    if (1.0 < fltCount1 + fltCount2) and LegCheck1 then
      while fltCount2 > 1 do
        DrawLine(Polar2D(Door.CHB,  0.0, Door.HDistH), Polar2D(Door.CHB, 180.0, Door.HDistH), Door.LayerFlutes)
        Door.CHB = Polar2D(Door.CHB,  270.0, StyleE.FluteSpacing) -- Move Down
        fltCount2 = fltCount2 - 1
      end -- while end
      while fltCount1 > 1 do
        DrawLine(Polar2D(Door.CHT,  0.0, Door.HDistH), Polar2D(Door.CHT, 180.0, Door.HDistH), Door.LayerFlutes)
        Door.CHT = Polar2D(Door.CHT,   90.0, StyleE.FluteSpacing) -- Move Up
        fltCount1 = fltCount1 - 1
      end -- while end
      local ArchCount = (GetDistance(Polar2D(Door.CHT,  270.0, StyleE.FluteSpacing), Door.ptT) / StyleE.FluteSpacing)
      seg = GetDistance(Door.CHT, Door.ptT)
      chord = RadSeg2Chord(Door.Rad, seg)
      while ArchCount > 1 do
        DrawLine(Polar2D(Door.CHT,  0.0, (chord * 0.5)), Polar2D(Door.CHT, 180.0, (chord * 0.5)), Door.LayerFlutes)
        Door.CHT = Polar2D(Door.CHT, 90.0, StyleE.FluteSpacing)
        seg = GetDistance(Door.CHT, Door.ptT)
        chord = RadSeg2Chord(Door.Rad, seg)
        ArchCount = ArchCount - 1.0
      end -- while end
    else
      LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
    end -- if end
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleF()                                 -- Draws a Arched Style Door
  DoorSetUp(StyleF)
  Door.ptT  = Polar2D(Door.CTR,   90.0, Door.HeightH - (StyleF.C + Door.BitRad)) -- Top
  Door.ptB  = Polar2D(Door.CTR,  270.0, Door.HeightH - (StyleF.C + Door.BitRad)) -- Bottom
  Door.ptR  = Polar2D(Door.CTR,    0.0, Door.WidthH  - (StyleF.A + Door.BitRad)) -- Right
  Door.ptL  = Polar2D(Door.CTR,  180.0, Door.WidthH  - (StyleF.A + Door.BitRad)) -- Left
  Door.VDist = GetDistance(Door.ptT, Door.ptB)
  Door.HDist = GetDistance(Door.ptR, Door.ptL)
  Door.VDistH = (Door.VDist * 0.5)
  Door.VDistHB = GetDistance(Door.CTR, Door.ptB)
  Door.VDistHT = GetDistance(Door.CTR, Door.ptT)
  Door.HDistH = (Door.HDist * 0.5)
  Door.ptTc = Polar2D(Door.ptT,   90.0, Door.BitRad) -- Top Rad Ctr
  Door.ptBc = Polar2D(Door.ptB,  270.0, Door.BitRad) -- Bottom Rad Ctr
  Door.ptRc = Polar2D(Door.ptR,    0.0, Door.BitRad) -- Right Rad Ctr
  Door.ptLc = Polar2D(Door.ptL,  180.0, Door.BitRad) -- Left Rad Ctr
  Door.pt05 = Polar2D(Polar2D(Door.pt01, 0.0, StyleF.A), 90.0, StyleF.B )
  Door.pt06 = Polar2D(Door.pt05,   0.0, (Door.Width  - (StyleF.A * 2.0)))
  Door.pt07 = Polar2D(Door.pt06,  90.0, (Door.Height - (StyleF.B + StyleF.B )))
  Door.pt08 = Polar2D(Door.pt05,  90.0, (Door.Height - (StyleF.B + StyleF.B )))
  Door.Chor = GetDistance(Door.pt07, Door.pt08)
  Door.Seg = StyleF.B - StyleF.C
  Door.Rad = ChordSeg2Radius (Door.Chor, Door.Seg)
  Door.Seg = RadChord2Segment(Door.Rad, Door.Chor)
  local bulge =  Radius2Bulge (Door.pt07, Door.pt08, ChordSeg2Radius(Door.Chor, Door.Seg))
  local Flutes = true
  local WidthCheck = (Door.Width > (StyleF.A * 2.0))
  local HeightCheck = (Door.Height > (StyleF.B + StyleF.C))
  local RadCheck = Door.Rad * 2.0 > Door.Seg
  local SegCheck = (Door.Rad > (Door.ptT.y - Door.pt07.y))
  local LegCheck1 = (Door.pt05.x < Door.pt06.x)
  local LegCheck2 = (Door.pt05.y < Door.pt08.y)
  if RadCheck and  WidthCheck and HeightCheck and SegCheck and LegCheck1 and LegCheck2 then
    local line = Contour(0.0)
    local layer = Door.job.LayerManager:GetLayerWithName(Door.LayerIFrame)
    line:AppendPoint(Door.pt05)
    line:ArcTo(Door.pt06, bulge)
    line:LineTo(Door.pt07)
    line:ArcTo(Door.pt08, bulge)
    line:LineTo(Door.pt05)
    layer:AddObject(CreateCadContour(line), true)
    Door.Rad = Door.Rad  - Door.BitRad
    if StyleF.Fluting == "Vertical" then
      DoorStyleFVertical()
    elseif StyleF.Fluting == "Horizontal" then
      DoorStyleFHorizontal()
    elseif StyleF.Fluting == "Crossing" then
      DoorStyleFHorizontal()
      DoorStyleFVertical()
    end -- if end
  else
    if  LegCheck1 and LegCheck2 then
      DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt08, Door.LayerIFrame)
    else
      DrawLine(Door.ptL, Door.ptR, Door.LayerFlutes)
    end --if end
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
  end -- if end
  RowPoint()
  return true
end -- function end
-- ====================================================]]
function DoorStyleFVertical()
  local fltCount = (Door.HDist / StyleF.FluteSpacing) - 1
  Door.Chord = StyleF.FluteSpacing * 2.0
  Door.Seg  = RadChord2Segment (Door.Rad, Door.Chord)
  local seq = Door.Seg
  DrawLine(Door.ptT, Door.ptB, Door.LayerFlutes)
  if (1.0 < fltCount)  then
    while fltCount > 1 do
      DrawLine(Polar2D(Door.CHR,  90.0, Door.VDistHT - Door.Seg), Polar2D(Door.CHR, 270.0, Door.VDistHB - Door.Seg), Door.LayerFlutes)
      DrawLine(Polar2D(Door.CHL,  90.0, Door.VDistHT - Door.Seg), Polar2D(Door.CHL, 270.0, Door.VDistHB - Door.Seg), Door.LayerFlutes)
      Door.CHR = Polar2D(Door.CHR,    0.0, StyleF.FluteSpacing) -- Right
      Door.CHL = Polar2D(Door.CHL,  180.0, StyleF.FluteSpacing) -- Left
      Door.Chord = Door.Chord + (StyleF.FluteSpacing * 2.0)
      Door.Seg  = RadChord2Segment (Door.Rad, Door.Chord)
      fltCount = fltCount - 2
    end -- while end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleFHorizontal()
 local seg, chord
  Door.PanelCTR = Polar2D(Door.ptB, 90.0, (GetDistance(Door.ptT, Door.ptB) * 0.5))
  Door.CHT = Polar2D(Door.PanelCTR,  90.0, StyleF.FluteSpacing)
  Door.CHB = Polar2D(Door.PanelCTR, 270.0, StyleF.FluteSpacing)
  Door.ptLx = Polar2D(Door.PanelCTR, 180.0, Door.HDistH)
  Door.ptRx = Polar2D(Door.PanelCTR,   0.0, Door.HDistH)
  local LegCheck1 = (Door.ptL.y < Door.pt08.y)
  local fltCount = ((GetDistance(Door.ptT, Door.CTR) - RadChord2Segment(Door.Rad, GetDistance(Door.ptL, Door.ptR))) / StyleF.FluteSpacing)
  if LegCheck1 then
    DrawLine(Door.ptLx, Door.ptRx, Door.LayerFlutes)
    if (1.0 < fltCount) and LegCheck1 then
      while fltCount > 1 do
        DrawLine(Polar2D(Door.CHB,  0.0, Door.HDistH), Polar2D(Door.CHB, 180.0, Door.HDistH), Door.LayerFlutes)
        DrawLine(Polar2D(Door.CHT,  0.0, Door.HDistH), Polar2D(Door.CHT, 180.0, Door.HDistH), Door.LayerFlutes)
        Door.CHB = Polar2D(Door.CHB,  270.0, StyleF.FluteSpacing) -- Move Down
        Door.CHT = Polar2D(Door.CHT,   90.0, StyleF.FluteSpacing) -- Move Up
      fltCount = fltCount - 1
      end -- while end
      local ArchCount = (GetDistance(Polar2D(Door.CHT,  270.0, StyleF.FluteSpacing), Door.ptT) / StyleF.FluteSpacing)
      seg = GetDistance(Door.CHT, Door.ptT)
      chord = RadSeg2Chord(Door.Rad, seg)
      while ArchCount > 1 do
        DrawLine(Polar2D(Door.CHT,  0.0, (chord * 0.5)), Polar2D(Door.CHT, 180.0, (chord * 0.5)), Door.LayerFlutes)
        DrawLine(Polar2D(Door.CHB,  0.0, (chord * 0.5)), Polar2D(Door.CHB, 180.0, (chord * 0.5)), Door.LayerFlutes)
        Door.CHT = Polar2D(Door.CHT,  90.0, StyleF.FluteSpacing)
        Door.CHB = Polar2D(Door.CHB, 270.0, StyleF.FluteSpacing)
        seg = GetDistance(Door.CHT, Door.ptT)
        chord = RadSeg2Chord(Door.Rad, seg)
        ArchCount = ArchCount - 1.0
      end -- while end
    else
      LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
    end -- if end
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleG()                                  -- Draws a Corner Radius Style Door
  local pt2 = Polar2D(Door.pt01,   0.0, Door.Width)
  local pt3 = Polar2D(pt2,      90.0, Door.Height)
  local pt4 = Polar2D(Door.pt01,  90.0, Door.Height)
  DrawBox(Door.pt01, pt2, pt3, pt4, Door.LayerOFrame)
  local ptA = Polar2D(Polar2D(Door.pt01, 0.0, StyleG.A), 90.0, StyleG.B)
  local ptB = Polar2D(ptA,    0.0, (Door.Width - (StyleG.A * 2.0)))
  local ptC = Polar2D(ptB,   90.0, (Door.Height - (StyleG.B * 2.0)))
  local ptD = Polar2D(ptA,   90.0, (Door.Height - (StyleG.B * 2.0)))
  local pt5 = Polar2D(ptA,    0.0, StyleG.C)
  local pt6 = Polar2D(ptB,  180.0, StyleG.C)
  local pt7 = Polar2D(ptB,   90.0, StyleG.C)
  local pt8 = Polar2D(ptC,  270.0, StyleG.C)
  local pt9 = Polar2D(ptC,  180.0, StyleG.C)
  local pt10 = Polar2D(ptD,   0.0, StyleG.C)
  local pt11 = Polar2D(ptD, 270.0, StyleG.C)
  local pt12 = Polar2D(ptA,  90.0, StyleG.C)
  local chr = GetDistance(pt7, pt6)
  local bulge =  (Radius2Bulge (pt7, pt6, StyleG.C) * -1.0)
  if (Door.Width > (StyleG.A * 2.0) + (StyleG.C * 2.0)) and  (Door.Height > (StyleG.B * 2.0) + (StyleG.C * 2.0)) then
    if (Door.Width > (StyleG.A * 2.0) + (StyleG.C * 2.0)) then
      local line = Contour(0.0)
      local layer = Door.job.LayerManager:GetLayerWithName(Door.LayerIFrame)
      line:AppendPoint(pt5)
      line:LineTo(pt6)
      line:ArcTo(pt7, bulge)
      line:LineTo(pt8)
      line:ArcTo(pt9, bulge)
      line:LineTo(pt10)
      line:ArcTo(pt11, bulge)
      line:LineTo(pt12)
      line:ArcTo(pt5, bulge)
      layer:AddObject(CreateCadContour(line), true)
      if StyleG.Fluting == "Vertical" then
        DoorStyleGVertical(Door.pt01)
      elseif StyleG.Fluting == "Horizontal" then
        DoorStyleGHorizontal(Door.pt01, pt11, pt12, pt7, chr)
      elseif StyleG.Fluting == "Crossing" then
        DoorStyleGVertical(Door.pt01)
        DoorStyleGHorizontal(Door.pt01, pt11, pt12, pt7, chr)
      end -- if end
    else
      DrawBox(pt5, pt6, pt7, pt8, Door.LayerIFrame)
      LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
    end -- if end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the inter panel")
  end -- if end
  RowPoint()
  return true
end -- function end
-- ====================================================]]
function DoorStyleGVertical(pt1)
  local Rad  = StyleG.C + Door.BitRad
  local ptX = Polar2D(pt1,    0.0, Door.Width * 0.5) -- Bottom
  local CTR = Polar2D(ptX,   90.0, Door.Height * 0.5) -- Door Center
  local ptT = Polar2D(CTR,   90.0, (Door.Height * 0.5) - (StyleG.B + Door.BitRad)) -- Top
  local ptB = Polar2D(CTR,  270.0, (Door.Height * 0.5) - (StyleG.B + Door.BitRad)) -- Bottom
  local ptR = Polar2D(CTR,    0.0, (Door.Width * 0.5)  - (StyleG.A + Door.BitRad)) -- Right
  local ptL = Polar2D(CTR,  180.0, (Door.Width * 0.5)  - (StyleG.A + Door.BitRad)) -- Left
  local ptTc = Polar2D(ptT,  90.0, Door.BitRad) -- Top Rad Ctr
  local ptBc = Polar2D(ptB, 270.0, Door.BitRad) -- Bottom Rad Ctr
  local ptRc = Polar2D(ptR,   0.0, Door.BitRad) -- Right Rad Ctr
  local ptLc = Polar2D(ptL, 180.0, Door.BitRad) -- Left Rad Ctr
  local Adj = Rad - math.sqrt(Rad^2 - Door.BitRad^2)
  local ptBl = Polar2D(ptB,   0.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptBr = Polar2D(ptB, 180.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptTl = Polar2D(ptT,   0.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptTr = Polar2D(ptT, 180.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptRl = Polar2D(ptR,   0.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local ptRr = Polar2D(ptR, 180.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local ptLl = Polar2D(ptL,   0.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local ptLr = Polar2D(ptL, 180.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local CHR = Polar2D(CTR,    0.0, StyleG.FluteSpacing) -- Left
  local CHL = Polar2D(CTR,  180.0, StyleG.FluteSpacing) -- Left
  local Vdis = GetDistance(ptT, ptB) * 0.5
  local Hdis = GetDistance(ptR, ptL) * 0.5
  local fltCount = (GetDistance(ptBl, ptBr) / StyleG.FluteSpacing) -1
  DrawLine(ptT, ptB, Door.LayerFlutes)
  CHR = Polar2D(CHR,  180.0, StyleG.FluteSpacing) -- Right
  CHL = Polar2D(CHL,    0.0, StyleG.FluteSpacing) -- Left
  if (1.0 < fltCount) then
    while fltCount > 1 do
      CHR = Polar2D(CHR,    0.0, StyleG.FluteSpacing) -- Right
      CHL = Polar2D(CHL,  180.0, StyleG.FluteSpacing) -- Left
      DrawLine(Polar2D(CHR,  90.0, Vdis), Polar2D(CHR, 270.0, Vdis), Door.LayerFlutes)
      DrawLine(Polar2D(CHL,  90.0, Vdis), Polar2D(CHL, 270.0, Vdis), Door.LayerFlutes)
      fltCount = fltCount - 2
    end -- while end
    local Adis = GetDistance(CHR, ptR)
           CHR = Polar2D(CHR,   0.0, StyleG.FluteSpacing) -- Next Step
           CHL = Polar2D(CHL, 180.0, StyleG.FluteSpacing) -- Next Step
    local Hchord = RadSeg2Chord(Rad, (Rad - GetDistance(CHR, ptRc))) * 0.5 - Door.BitRad
    local ArcCount = (GetDistance(CHR, ptR) / StyleG.FluteSpacing)
    if (ArcCount > 0.0) then
      while ArcCount > 0 do
        DrawLine(Polar2D(CHR,  90.0, Vdis - Hchord), Polar2D(CHR, 270.0, Vdis - Hchord ), Door.LayerFlutes)
        DrawLine(Polar2D(CHL,  90.0, Vdis - Hchord), Polar2D(CHL, 270.0, Vdis - Hchord), Door.LayerFlutes)
        CHR = Polar2D(CHR,    0.0, StyleG.FluteSpacing) -- Right
        CHL = Polar2D(CHL,  180.0, StyleG.FluteSpacing) -- Left
        Hchord = RadSeg2Chord(Rad, (Rad - GetDistance(CHR, ptRc))) * 0.5 - Door.BitRad
        ArcCount = ArcCount - 1
      end -- while end
    end -- if end
  else
    LogWriter("Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Vertical Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function DoorStyleGHorizontal(pt1)
  local Rad  = StyleG.C + Door.BitRad
  local ptX = Polar2D(pt1,    0.0, Door.Width * 0.5) -- Bottom
  local CTR = Polar2D(ptX,   90.0, Door.Height * 0.5) -- Door Center
  local ptT = Polar2D(CTR,   90.0, (Door.Height * 0.5) - (StyleG.B + Door.BitRad)) -- Top
  local ptB = Polar2D(CTR,  270.0, (Door.Height * 0.5) - (StyleG.B + Door.BitRad)) -- Bottom
  local ptR = Polar2D(CTR,    0.0, (Door.Width * 0.5)  - (StyleG.A + Door.BitRad)) -- Right
  local ptL = Polar2D(CTR,  180.0, (Door.Width * 0.5)  - (StyleG.A + Door.BitRad)) -- Left
  local ptTc = Polar2D(ptT,  90.0, Door.BitRad) -- Top Rad Ctr
  local ptBc = Polar2D(ptB, 270.0, Door.BitRad) -- Bottom Rad Ctr
  local ptRc = Polar2D(ptR,   0.0, Door.BitRad) -- Right Rad Ctr
  local ptLc = Polar2D(ptL, 180.0, Door.BitRad) -- Left Rad Ctr
  local CHR = Polar2D(CTR,    0.0, StyleG.FluteSpacing) -- Left
  local CHT = Polar2D(CTR,   90.0, StyleG.FluteSpacing) -- Top
  local CHL = Polar2D(CTR,  180.0, StyleG.FluteSpacing) -- Left
  local CHB = Polar2D(CTR,  270.0, StyleG.FluteSpacing) -- Bottom
  local Adj = Rad - math.sqrt(Rad^2 - Door.BitRad^2)
  local ptBl = Polar2D(ptB,   0.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptBr = Polar2D(ptB, 180.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptTl = Polar2D(ptT,   0.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptTr = Polar2D(ptT, 180.0, ((GetDistance(ptR, ptL) * 0.5) - StyleG.C) + Adj)
  local ptRl = Polar2D(ptR,   0.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local ptRr = Polar2D(ptR, 180.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local ptLl = Polar2D(ptL,   0.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local ptLr = Polar2D(ptL, 180.0, ((GetDistance(ptT, ptB) * 0.5) - StyleG.C) + Adj)
  local Vdis = GetDistance(ptT, ptB) * 0.5
  local Hdis = GetDistance(ptR, ptL) * 0.5
  local fltCount = (GetDistance(ptRl, ptRr) / StyleG.FluteSpacing) -1
  DrawLine(ptR, ptL, Door.LayerFlutes)
  CHT = Polar2D(CHT,  270.0, StyleG.FluteSpacing) -- Top SetBack
  CHB = Polar2D(CHB,   90.0, StyleG.FluteSpacing) -- Bottom SetBack
  if (1.0 < fltCount) then
    while fltCount > 1 do
      CHT = Polar2D(CHT,   90.0, StyleG.FluteSpacing) -- Move Up
      CHB = Polar2D(CHB,  270.0, StyleG.FluteSpacing) -- Move Down
      DrawLine(Polar2D(CHT,  0.0, Hdis), Polar2D(CHT, 180.0, Hdis), Door.LayerFlutes)
      DrawLine(Polar2D(CHB,  0.0, Hdis), Polar2D(CHB, 180.0, Hdis), Door.LayerFlutes)
      fltCount = fltCount - 2
    end -- while end
    local Adis = GetDistance(CHT, ptT)
           CHT = Polar2D(CHT,  90.0, StyleG.FluteSpacing) -- Next Step
           CHB = Polar2D(CHB, 270.0, StyleG.FluteSpacing) -- Next Step
    local Hchord = RadSeg2Chord(Rad, (Rad - GetDistance(CHT, ptTc))) * 0.5 - Door.BitRad
    local ArcCount = (GetDistance(CHT, ptT) / StyleG.FluteSpacing)
    if (1.0 < ArcCount) then
      while ArcCount > 0 do
        DrawLine(Polar2D(CHT, 0.0, Hdis - Hchord), Polar2D(CHT, 180.0, Hdis - Hchord ), Door.LayerFlutes)
        DrawLine(Polar2D(CHB, 0.0, Hdis - Hchord), Polar2D(CHB, 180.0, Hdis - Hchord), Door.LayerFlutes)
        CHT = Polar2D(CHT,   90.0, StyleG.FluteSpacing) -- Right
        CHB = Polar2D(CHB,  270.0, StyleG.FluteSpacing) -- Left
        Hchord = RadSeg2Chord(Rad, (Rad - GetDistance(CHT, ptTc))) * 0.5 - Door.BitRad
        ArcCount = ArcCount - 1
      end -- while end
    end -- if end
  else
    LogWriter( "Error - Door: " .. D2S(Door.Height) .. " X " .. D2S(Door.Width) .. " Failed to Draw the Horizontal Fluting")
  end -- if end
  return true
end -- function end
-- ====================================================]]
function GetFilename(path)
    local start, _ = path:find('[%w%s!-={-|]+[_%.].+')
    return path:sub(start,#path)
end
-- ====================================================]]
function GetUnits()
  local mtl_block = MaterialBlock()
  if mtl_block.InMM then
    Door.Units  = "Drawing Units: mm"
    Door.Unit = true
    Door.Cal = 25.4
  else
    Door.Units  = "Drawing Units: inches"
    Door.Unit = false
    Door.Cal = 1.0
  end
end -- end function
-- ====================================================]]
function GetDistance(pt1, pt2)
  -- ===GetDistance(objA, objB)===
  local xDist = pt2.x - pt1.x
  local yDist = pt2.y - pt1.y
  return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end -- function end
-- ====================================================]]
function InquiryMain()
  Maindialog = HTML_Dialog(true, DialogWindow.Main, 635, 351, "MDF Door Maker Main Screen (Ver: " .. Version .. ")")
  Door.Alert = ""
  --Door.Style = StyleA.Name
  if Door.Count == 0 then Door.Count = 1 end
  Door.RuntimeLog = "CSVImportErrorLog" .. StartDateTime(false)
  Maindialog:AddLabelField("Door.Alert", Door.Alert)
  Maindialog:AddDropDownList("DoorStyle", Door.Style)
  Maindialog:AddDropDownListValue("DoorStyle", StyleA.Name)
  Maindialog:AddDropDownListValue("DoorStyle", StyleB.Name)
  Maindialog:AddDropDownListValue("DoorStyle", StyleC.Name)
  Maindialog:AddDropDownListValue("DoorStyle", StyleE.Name)
  Maindialog:AddDropDownListValue("DoorStyle", StyleF.Name)
  Maindialog:AddDropDownListValue("DoorStyle", StyleG.Name)
  Maindialog:AddLabelField("ReadFile", Door.CSVFile)
  Maindialog:AddIntegerField("Door.Count", Door.Count)
  Maindialog:AddDoubleField("Door.X", Door.X)
  Maindialog:AddDoubleField("Door.Y", Door.Y)
  Maindialog:AddDoubleField("Door.Width", Door.Width)
  Maindialog:AddDoubleField("Door.Height", Door.Height)
  Maindialog:AddFilePicker(true, "FilePicker", "ReadFile", false)
  if not Maindialog:ShowDialog() then
     Door.StyleName = ""
     DialogWindow.MainXY  = tostring(Maindialog.WindowWidth) .. " x " ..  tostring(Maindialog.WindowHeight)
     Door.CSVFile = Maindialog:GetLabelField("ReadFile")
     Door.CSVPath =  string.sub(Door.CSVFile,1, (string.len(Door.CSVFile) - string.len(GetFilename(Door.CSVFile))))
     Registry_Update()
    return false
  else
     Door.Style = Maindialog:GetDropDownListValue("DoorStyle")
     DialogWindow.MainXY  = tostring(Maindialog.WindowWidth) .. " x " ..  tostring(Maindialog.WindowHeight)
     Door.CSVFile = Maindialog:GetLabelField("ReadFile")
     Door.CSVPath =  string.sub(Door.CSVFile,1, (string.len(Door.CSVFile) - string.len(GetFilename(Door.CSVFile))))
     Registry_Update()
    return true
  end
end
-- ====================================================]]
function OnLuaButton_MakeCSV(dialog)
  Door.CSVPath = dialog:GetTextField("DoorCSVPath")
  local filename = Door.CSVPath .. "\\DoorTest.csv"
  local file = io.open(filename, "w")
  file:write("Count,Height,Width\n")
  if Door.Unit then
    file:write("1,110,595\n");    file:write("1,150,75\n");     file:write("1,175,395\n");     file:write("1,140,495\n")
    file:write("1,175,445\n");    file:write("1,175,595\n");    file:write("2,200,100\n");     file:write("3,250,125\n")
    file:write("1,300,150\n");    file:write("2,350,175\n");    file:write("3,400,200\n");     file:write("1,450,225\n")
    file:write("2,500,250\n");    file:write("3,550,275\n");    file:write("1,600,300\n");     file:write("2,650,325\n")
    file:write("3,700,350\n");    file:write("1,750,375\n");    file:write("2,800,400\n");     file:write("3,850,425\n");
    file:write("1,900,450\n");    file:write("2,950,475\n");    file:write("3,1000,500\n");    file:write("1,1050,525\n");
    file:write("2,1100,550\n");   file:write("3,1150,575\n");   file:write("1,1200,600\n");    file:write("2,1250,625\n");
    file:write("3,1300,650\n");   file:write("1,1350,675\n");   file:write("2,1400,700\n");    file:write("3,1450,725\n");
    file:write("1,1500,750\n");   file:write("2,1550,775\n");   file:write("3,1600,800\n");    file:write("1,1650,825\n");
    file:write("2,1700,850\n");   file:write("3,1750,875\n");   file:write("1,1800,900\n");    file:write("2,1850,925\n");
    file:write("3,1900,950\n");   file:write("1,1950,975\n");   file:write("2,2000,1000\n");   file:write("3,2050,1025\n");
    file:write("1,2100,1050\n");  file:write("2,2150,1075\n");  file:write("3,2200,1100\n");   file:write("1,2250,1125\n");
    file:write("2,2300,1150\n");  file:write("3,2350,1175\n");  file:write("1,2400,1200\n");   file:write("2,2450,1225\n")
  else
    file:write("1,4.330708661,23.42519685\n");    file:write("1,5.905511811,2.952755906\n");
    file:write("1,6.88976378,15.5511811\n");      file:write("1,5.511811024,19.48818898\n");
    file:write("1,6.88976378,17.51968504\n");     file:write("1,6.88976378,23.42519685\n");
    file:write("2,7.874015748,3.937007874\n");    file:write("3,9.842519685,4.921259843\n");
    file:write("1,11.81102362,5.905511811\n");    file:write("2,13.77952756,6.88976378\n");
    file:write("3,15.7480315,7.874015748\n");     file:write("1,17.71653543,8.858267717\n");
    file:write("2,19.68503937,9.842519685\n");    file:write("3,21.65354331,10.82677165\n");
    file:write("1,23.62204724,11.81102362\n");    file:write("2,25.59055118,12.79527559\n");
    file:write("3,27.55905512,13.77952756\n");    file:write("1,29.52755906,14.76377953\n");
    file:write("2,31.49606299,15.7480315\n");     file:write("3,33.46456693,16.73228346\n");
    file:write("1,35.43307087,17.71653543\n");    file:write("2,37.4015748,18.7007874\n");
    file:write("3,39.37007874,19.68503937\n");    file:write("1,41.33858268,20.66929134\n");
    file:write("2,43.30708661,21.65354331\n");    file:write("3,45.27559055,22.63779528\n");
    file:write("1,47.24409449,23.62204724\n");    file:write("2,49.21259843,24.60629921\n");
    file:write("3,51.18110236,25.59055118\n");    file:write("1,53.1496063,26.57480315\n");
    file:write("2,55.11811024,27.55905512\n");    file:write("3,57.08661417,28.54330709\n");
    file:write("1,59.05511811,29.52755906\n");    file:write("2,61.02362205,30.51181102\n");
    file:write("3,62.99212598,31.49606299\n");    file:write("1,64.96062992,32.48031496\n");
    file:write("2,66.92913386,33.46456693\n");    file:write("3,68.8976378,34.4488189\n");
    file:write("1,70.86614173,35.43307087\n");    file:write("2,72.83464567,36.41732283\n");
    file:write("3,74.80314961,37.4015748\n");     file:write("1,76.77165354,38.38582677\n");
    file:write("2,78.74015748,39.37007874\n");    file:write("3,80.70866142,40.35433071\n");
    file:write("1,82.67716535,41.33858268\n");    file:write("2,84.64566929,42.32283465\n");
    file:write("3,86.61417323,43.30708661\n");    file:write("1,88.58267717,44.29133858\n");
    file:write("2,90.5511811,45.27559055\n");     file:write("3,92.51968504,46.25984252\n");
    file:write("1,94.48818898,47.24409449\n");    file:write("2,96.45669291,48.22834646\n")
  end -- if end
  file:close()-- closes the open file
  Registry_Update()
  DisplayMessageBox("The File: "..filename.." is complete.")
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 720, 467, "About")
  dialog:AddLabelField("SysName", AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  Registry_Update()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryStyle()
  Door.Style = Maindialog:GetDropDownListValue("DoorStyle")
  local InquiryStyledialog
  local ErrorText = ""
  if      Door.Style == StyleA.Name then
    InquiryStyledialog = HTML_Dialog(true, DialogWindow.myHtmlA, 342, 326, StyleA.Name)
    InquiryStyledialog:AddDoubleField("Door.A", StyleA.A)
    InquiryStyledialog:AddDoubleField("Door.B", StyleA.B)
    InquiryStyledialog:AddDoubleField("Door.FluteSpacing", StyleA.FluteSpacing)
    InquiryStyledialog:AddDropDownList("Door.Fluting", StyleA.Fluting)
  elseif  Door.Style == StyleB.Name then
    InquiryStyledialog = HTML_Dialog(true, DialogWindow.myHtmlB, 342, 327, StyleB.Name)
    InquiryStyledialog:AddDoubleField("Door.A", StyleB.A)
    InquiryStyledialog:AddDoubleField("Door.B", StyleB.B)
    InquiryStyledialog:AddDoubleField("Door.C", StyleB.C)
    InquiryStyledialog:AddDoubleField("Door.D", StyleB.D)
    InquiryStyledialog:AddDoubleField("Door.FluteSpacing", StyleB.FluteSpacing)
    InquiryStyledialog:AddDropDownList("Door.Fluting", StyleB.Fluting)
  elseif  Door.Style == StyleC.Name then
    InquiryStyledialog = HTML_Dialog(true, DialogWindow.myHtmlC, 342, 329, StyleC.Name)
    InquiryStyledialog:AddDoubleField("Door.A", StyleC.A)
    InquiryStyledialog:AddDoubleField("Door.B", StyleC.B)
    InquiryStyledialog:AddDoubleField("Door.C", StyleC.C)
    InquiryStyledialog:AddDoubleField("Door.D", StyleC.D)
    InquiryStyledialog:AddDoubleField("Door.FluteSpacing", StyleC.FluteSpacing)
    InquiryStyledialog:AddDropDownList("Door.Fluting", StyleC.Fluting)
  elseif  Door.Style == StyleE.Name then
    InquiryStyledialog = HTML_Dialog(true, DialogWindow.myHtmlE, 342, 329, StyleE.Name)
    InquiryStyledialog:AddDoubleField("Door.A", StyleE.A)
    InquiryStyledialog:AddDoubleField("Door.B", StyleE.B)
    InquiryStyledialog:AddDoubleField("Door.C", StyleE.C)
    InquiryStyledialog:AddDoubleField("Door.FluteSpacing", StyleE.FluteSpacing)
    InquiryStyledialog:AddDropDownList("Door.Fluting", StyleE.Fluting)
  elseif  Door.Style == StyleF.Name then
    InquiryStyledialog = HTML_Dialog(true, DialogWindow.myHtmlF, 342, 328, StyleF.Name)
    InquiryStyledialog:AddDoubleField("Door.A", StyleF.A)
    InquiryStyledialog:AddDoubleField("Door.B", StyleF.B)
    InquiryStyledialog:AddDoubleField("Door.C", StyleF.C)
    InquiryStyledialog:AddDoubleField("Door.FluteSpacing", StyleF.FluteSpacing)
    InquiryStyledialog:AddDropDownList("Door.Fluting", StyleF.Fluting)
  else    --  Door.Style == StyleG.Name then
    InquiryStyledialog = HTML_Dialog(true, DialogWindow.myHtmlG, 342, 329, StyleG.Name)
    InquiryStyledialog:AddDoubleField("Door.A", StyleG.A)
    InquiryStyledialog:AddDoubleField("Door.B", StyleG.B)
    InquiryStyledialog:AddDoubleField("Door.C", StyleG.C)
    InquiryStyledialog:AddDoubleField("Door.FluteSpacing", StyleG.FluteSpacing)
    InquiryStyledialog:AddDropDownList("Door.Fluting", StyleG.Fluting)
  end --if end
  InquiryStyledialog:AddDropDownListValue("Door.Fluting", "None")
  InquiryStyledialog:AddDropDownListValue("Door.Fluting", "Vertical")
  InquiryStyledialog:AddDropDownListValue("Door.Fluting", "Horizontal")
  InquiryStyledialog:AddDropDownListValue("Door.Fluting", "Crossing")
    if InquiryStyledialog:ShowDialog() then
      if      Door.Style == StyleA.Name then
        StyleA.A = math.abs(InquiryStyledialog:GetDoubleField("Door.A"))
        StyleA.B = math.abs(InquiryStyledialog:GetDoubleField("Door.B"))
        StyleA.FluteSpacing = math.abs(InquiryStyledialog:GetDoubleField("Door.FluteSpacing"))
        if StyleA.A == 0 then  ErrorText = "Error: The A Value cannot be zero" end
        if StyleA.B == 0 then  ErrorText = "Error: The B Value cannot be zero" end
        if StyleA.FluteSpacing< 0 then   ErrorText = "Error: Flute Spacing must larger than zero" end
        StyleA.Fluting = InquiryStyledialog:GetDropDownListValue("Door.Fluting")
        DialogWindow.StyleAXY = tostring(InquiryStyledialog.WindowWidth) .. " x " .. tostring(InquiryStyledialog.WindowHeight)
      elseif  Door.Style == StyleB.Name then
        StyleB.A = math.abs(InquiryStyledialog:GetDoubleField("Door.A"))
        StyleB.B = math.abs(InquiryStyledialog:GetDoubleField("Door.B"))
        StyleB.C = math.abs(InquiryStyledialog:GetDoubleField("Door.C"))
        StyleB.D = math.abs(InquiryStyledialog:GetDoubleField("Door.D"))
        StyleB.FluteSpacing = math.abs(InquiryStyledialog:GetDoubleField("Door.FluteSpacing"))
        if StyleB.A == 0 then  ErrorText = "Error: The A Value cannot be zero" end
        if StyleB.B == 0 then  ErrorText = "Error: The B Value cannot be zero" end
        if StyleB.C == 0 then  ErrorText = "Error: The C Value cannot be zero" end
        if StyleB.D == 0 then  ErrorText = "Error: The D Value cannot be zero" end
        if StyleB.FluteSpacing <= 0 then   ErrorText = "Error: Flute Spacing must larger than zero" end
        if StyleB.C >= StyleB.B then   ErrorText = "Error: The C Value cannot be larger than B Value" end
        StyleB.Fluting = InquiryStyledialog:GetDropDownListValue("Door.Fluting")
        DialogWindow.StyleBXY = tostring(InquiryStyledialog.WindowWidth) .. " x " .. tostring(InquiryStyledialog.WindowHeight)
      elseif  Door.Style == StyleC.Name then
        StyleC.A = math.abs(InquiryStyledialog:GetDoubleField("Door.A"))
        StyleC.B = math.abs(InquiryStyledialog:GetDoubleField("Door.B"))
        StyleC.C = math.abs(InquiryStyledialog:GetDoubleField("Door.C"))
        StyleC.D = math.abs(InquiryStyledialog:GetDoubleField("Door.D"))
        StyleC.FluteSpacing =math.abs( InquiryStyledialog:GetDoubleField("Door.FluteSpacing"))
        if StyleC.A == 0 then  ErrorText = "Error: The A Value cannot be zero" end
        if StyleC.B == 0 then  ErrorText = "Error: The B Value cannot be zero" end
        if StyleC.C == 0 then  ErrorText = "Error: The C Value cannot be zero" end
        if StyleC.D == 0 then  ErrorText = "Error: The D Value cannot be zero" end
        if StyleC.C >= StyleC.B then   ErrorText = "Error: The C Value cannot be larger than B Value" end
        if StyleC.FluteSpacing <= 0 then   ErrorText = "Error: Flute Spacing must larger than zero" end
        StyleC.Fluting = InquiryStyledialog:GetDropDownListValue("Door.Fluting")
        DialogWindow.StyleCXY = tostring(InquiryStyledialog.WindowWidth) .. " x " .. tostring(InquiryStyledialog.WindowHeight)
      elseif  Door.Style == StyleE.Name then
        StyleE.A = math.abs(InquiryStyledialog:GetDoubleField("Door.A"))
        StyleE.B = math.abs(InquiryStyledialog:GetDoubleField("Door.B"))
        StyleE.C = math.abs(InquiryStyledialog:GetDoubleField("Door.C"))
        StyleE.FluteSpacing = math.abs(InquiryStyledialog:GetDoubleField("Door.FluteSpacing"))
        if StyleE.A == 0 then  ErrorText = "Error: The A Value cannot be zero" end
        if StyleE.B == 0 then  ErrorText = "Error: The B Value cannot be zero" end
        if StyleE.C == 0 then  ErrorText = "Error: The C Value cannot be zero" end
        if StyleE.C >= StyleE.B then   ErrorText = "Error: The C Value cannot be larger than B Value" end
        if StyleE.FluteSpacing <= 0 then   ErrorText = "Error: Flute Spacing must larger than zero" end
        StyleE.Fluting = InquiryStyledialog:GetDropDownListValue("Door.Fluting")
        DialogWindow.StyleEXY = tostring(InquiryStyledialog.WindowWidth) .. " x " .. tostring(InquiryStyledialog.WindowHeight)
      elseif  Door.Style == StyleF.Name then
        StyleF.A = math.abs(InquiryStyledialog:GetDoubleField("Door.A"))
        StyleF.B = math.abs(InquiryStyledialog:GetDoubleField("Door.B"))
        StyleF.C = math.abs(InquiryStyledialog:GetDoubleField("Door.C"))
        StyleF.FluteSpacing = math.abs(InquiryStyledialog:GetDoubleField("Door.FluteSpacing"))
        if StyleF.A == 0 then  ErrorText = "Error: The A Value cannot be zero" end
        if StyleF.B == 0 then  ErrorText = "Error: The B Value cannot be zero" end
        if StyleF.C == 0 then  ErrorText = "Error: The C Value cannot be zero" end
        if StyleF.C >= StyleF.B then   ErrorText = "Error: The C Value cannot be larger than B Value" end
        if StyleF.FluteSpacing <= 0 then   ErrorText = "Error: Flute Spacing must larger than zero" end
        StyleF.Fluting = InquiryStyledialog:GetDropDownListValue("Door.Fluting")
        DialogWindow.StyleFXY = tostring(InquiryStyledialog.WindowWidth) .. " x " .. tostring(InquiryStyledialog.WindowHeight)
      else    --  Door.Style == StyleG.Name then
        StyleG.A = math.abs(InquiryStyledialog:GetDoubleField("Door.A"))
        StyleG.B = math.abs(InquiryStyledialog:GetDoubleField("Door.B"))
        StyleG.C = math.abs(InquiryStyledialog:GetDoubleField("Door.C"))
        StyleG.FluteSpacing = math.abs(InquiryStyledialog:GetDoubleField("Door.FluteSpacing"))
        if StyleG.A == 0 then  ErrorText = "Error: The A Value cannot be zero" end
        if StyleG.B == 0 then  ErrorText = "Error: The B Value cannot be zero" end
        if StyleG.C == 0 then  ErrorText = "Error: The C Value cannot be zero" end
        if StyleG.FluteSpacing <= 0 then  ErrorText = "Error: Flute Spacing must larger than zero" end
        StyleG.Fluting = InquiryStyledialog:GetDropDownListValue("Door.Fluting")
        DialogWindow.StyleGXY = tostring(InquiryStyledialog.WindowWidth) .. " x " .. tostring(InquiryStyledialog.WindowHeight)
      end --if end
    Maindialog:UpdateLabelField("Door.Alert", ErrorText)
  end -- if end
  Registry_Update()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryRunCSV()
    Door.CSVFile = Maindialog:GetLabelField("ReadFile")
    Door.CSVPath =  string.sub(Door.CSVFile,1, (string.len(Door.CSVFile) - string.len(GetFilename(Door.CSVFile))))
  if string.find(Door.CSVFile, ".csv") then
    Registry_Update()
    Door.Records = LengthOfFile(Door.CSVFile)
    Door.Record  = 1
    MyProgressBar = ProgressBar("Working", ProgressBar.LINEAR)
    MyProgressBar:SetPercentProgress(0)
    Read_CSV(Door.CSVFile, true)
    Door.job:Refresh2DView()
    DisplayMessageBox("Process Compete!! \nNote: Any Errors are logged in the CSF file folder.")
    if Door.Count == 0 then
      Door.X = 50.0
      Door.Y = 50.0
      Door.Count = 1
    end
    MyProgressBar:SetText("Compete")
    MyProgressBar:Finished()
  else
    DisplayMessageBox("Error: Process Cannot Start! \nUnable to run without CSV file selected.")
  end -- if end
  return true
end -- Function end
-- ====================================================]]
function OnLuaButton_InquiryDefault()
  local ErrorText = ""
  local dialog = HTML_Dialog(true, DialogWindow.myHtml1, 632, 375, "Default Settings")
  dialog:AddLabelField("Door.Alert", Door.Alert)
  dialog:AddDoubleField("Door.Spacing", Door.Spacing)
  dialog:AddDoubleField("Door.MaxWide", Door.MaxWide)
  dialog:AddDoubleField("Door.BitRad", Door.BitRad)
  dialog:AddTextField("Door.LayerOFrame", Door.LayerOFrame)
  dialog:AddTextField("Door.LayerIFrame", Door.LayerIFrame)
  dialog:AddTextField("Door.LayerFlutes", Door.LayerFlutes)
  dialog:AddTextField("DoorCSVPath", Door.CSVPath )
  dialog:AddDirectoryPicker("DirectoryPicker", "DoorCSVPath",  true)
  if dialog:ShowDialog() then
    DialogWindow.DefaultXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    Door.Spacing           = math.abs(dialog:GetDoubleField("Door.Spacing"))
    Door.MaxWide           = math.abs(dialog:GetDoubleField("Door.MaxWide"))
    Door.BitRad            = math.abs(dialog:GetDoubleField("Door.BitRad"))
    Door.LayerOFrame       = dialog:GetTextField("Door.LayerOFrame")
    Door.LayerIFrame       = dialog:GetTextField("Door.LayerIFrame")
    Door.LayerFlutes       = dialog:GetTextField("Door.LayerFlutes")
    if All_Trim(Door.LayerOFrame) == "" then ErrorText = "Error: The Outer Frame, Layer Name cannot be blank" end
    if All_Trim(Door.LayerIFrame) == "" then ErrorText = "Error: The Inter Frame, Layer Name cannot be blank" end
    if All_Trim(Door.LayerFlutes) == "" then ErrorText = "Error: The Flute Layer Name, cannot be blank" end
    Maindialog:UpdateLabelField("Door.Alert", ErrorText)
    Registry_Update()
  end -- if end
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryMakeDoor(dialog)
  local runit = true
  Door.Style = dialog:GetDropDownListValue("DoorStyle")
  Door.Count = dialog:GetIntegerField("Door.Count")
  Door.Width = dialog:GetDoubleField("Door.Width")
  Door.Height = dialog:GetDoubleField("Door.Height")
  Door.X = dialog:GetDoubleField("Door.X")
  Door.Y = dialog:GetDoubleField("Door.Y")
  if Door.Count < 1 then
    runit = false
    DisplayMessageBox("Door Count Requird")
    end -- if end
  if Door.Count < 1 then
    runit = false
    DisplayMessageBox("No Door Count Provided")
    end -- if end
  if Door.Width < 1.0 then
    runit = false
    DisplayMessageBox("Door Width is too small")
  end -- if end
  if Door.Height < 1.0 then
    runit = false
    DisplayMessageBox("Door Height is too small")
    end -- if end
  if   runit then
    Door.pt01 = Point2D(Door.X, Door.Y)
    local Count = Door.Count
    while Count > 0 do
      if      Door.Style == StyleA.Name then
        DoorStyleA()
      elseif  Door.Style == StyleB.Name then
        DoorStyleB()
      elseif  Door.Style == StyleC.Name then
        DoorStyleC()
      elseif  Door.Style == StyleE.Name then
        DoorStyleE()
      elseif  Door.Style == StyleF.Name then
        DoorStyleF()
      elseif  Door.Style == StyleG.Name then
        DoorStyleG()
      else
        DisplayMessageBox("No Style Select!")
      end --if end
      Count = Count - 1
    end -- end While
    Door.job:Refresh2DView()
    Door.X = Door.pt01.x
    Door.Y = Door.pt01.y
    dialog:UpdateDoubleField("Door.Y", Door.Y)
    dialog:UpdateDoubleField("Door.X", Door.X)
  end -- end if
  Registry_Update()
  return  true
end
-- ====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ====================================================]]
function Read_CSV(xFile, Header)
  local fileR = io.open(xFile)
  local xLine = ""
  local result = {}
  for Line in fileR:lines() do
    xLine = Line
    if Header then
      Header = false
    else
      xLine = All_Trim(Line)
      for match in (xLine..","):gmatch("(.-)"..",") do
        table.insert(result, match);
      end -- for end
      Door.Count     = tonumber(result[1])
      Door.Height    = tonumber(result[2])
      Door.Width     = tonumber(result[3])
      result = {}
      while Door.Count > 0 do
        if      Door.Style == StyleA.Name then
          DoorStyleA()
        elseif  Door.Style == StyleB.Name then
          DoorStyleB()
        elseif  Door.Style == StyleC.Name then
          DoorStyleC()
        elseif  Door.Style == StyleE.Name then
          DoorStyleE()
        elseif  Door.Style == StyleF.Name then
          DoorStyleF()
        elseif  Door.Style == StyleG.Name then
          DoorStyleG()
        else
          DisplayMessageBox("No Style Select!")
        end --if end
        Door.Count =  Door.Count - 1
      end -- for end
    end --if end
    Door.Record = Door.Record + 1
    MyProgressBar:SetPercentProgress(ProgressAmount(Door.Record))
  end --for end
  return true
end
-- ====================================================]]
function LogWriter(xText)
-- Writes new xText Line to a log file
  local LogName = Door.CSVPath .. "/" .. Door.RuntimeLog .. ".txt"
  local fileW = io.open(LogName,  "a")
  fileW:write(xText .. "\n")
  fileW:close()
  Maindialog:UpdateLabelField("Door.Alert", "Note: Errors are logged in the CSF file folder.")
  return true
end -- function end
-- ====================================================]]
function Registry_Read()                                -- Read from Registry values
  local RegistryRead            = Registry(RegName)
  DialogWindow.AboutXY          = RegistryRead:GetString("DialogWindow.AboutXY",         "0,0")
  DialogWindow.DefaultsXY       = RegistryRead:GetString("DialogWindow.DefaultsXY",      "0,0")
  DialogWindow.MainXY           = RegistryRead:GetString("DialogWindow.MainXY",          "0,0")
  DialogWindow.StyleAXY         = RegistryRead:GetString("DialogWindow.StyleAXY",        "0,0")
  DialogWindow.StyleBXY         = RegistryRead:GetString("DialogWindow.StyleBXY",        "0,0")
  DialogWindow.StyleCXY         = RegistryRead:GetString("DialogWindow.StyleCXY",        "0,0")
  DialogWindow.StyleEXY         = RegistryRead:GetString("DialogWindow.StyleEXY",        "0,0")
  DialogWindow.StyleFXY         = RegistryRead:GetString("DialogWindow.StyleFXY",        "0,0")
  DialogWindow.StyleGXY         = RegistryRead:GetString("DialogWindow.StyleGXY",        "0,0")
  Project.ProgramCodeBy         = RegistryRead:GetString("Project.ProgramCodeBy",        "JimAndi Gadgets")
  Project.ProgramName           = RegistryRead:GetString("Project.ProgramName",          "MDF Door Maker")
  Project.ProgramVersion        = RegistryRead:GetString("Project.ProgramVersion",       VerNumber)
  Door.Style                    = RegistryRead:GetString("Door.Style",                   "Shaker Style")
  Door.CSVFile                  = RegistryRead:GetString("Door.CSVFile",                 "C:\\Temp\\YouMustPickAFile.CSVFile")
  Door.CSVPath                  = RegistryRead:GetString("Door.CSVPath",                 "C:\\Temp\\")
  Door.LayerOFrame              = RegistryRead:GetString("Door.LayerOFrame",             "Door Outer Frame")
  Door.LayerIFrame              = RegistryRead:GetString("Door.LayerIFrame",             "Door Inter Frame")
  Door.LayerFlutes              = RegistryRead:GetString("Door.LayerFlutes",             "Door Flutes")
  Door.Fluting                  = RegistryRead:GetString("Door.Fluting",                 "None")
  StyleA.Name                   = RegistryRead:GetString("StyleA.Name",                  "Shaker Style")
  StyleB.Name                   = RegistryRead:GetString("StyleB.Name",                  "Cathedral Style")
  StyleC.Name                   = RegistryRead:GetString("StyleC.Name",                  "Double Cathedral Style")
  StyleE.Name                   = RegistryRead:GetString("StyleE.Name",                  "Arched Style")
  StyleF.Name                   = RegistryRead:GetString("StyleF.Name",                  "Double Arched Style")
  StyleG.Name                   = RegistryRead:GetString("StyleG.Name",                  "Corner Radius Style")
  StyleA.Fluting                = RegistryRead:GetString("StyleA.Fluting",               "None")
  StyleB.Fluting                = RegistryRead:GetString("StyleB.Fluting",               "None")
  StyleC.Fluting                = RegistryRead:GetString("StyleC.Fluting",               "None")
  StyleE.Fluting                = RegistryRead:GetString("StyleE.Fluting",               "None")
  StyleF.Fluting                = RegistryRead:GetString("StyleF.Fluting",               "None")
  StyleG.Fluting                = RegistryRead:GetString("StyleG.Fluting",               "None")
  Door.MaxWide                  = RegistryRead:GetInt("Door.MaxWide",                     10)
  Door.Spacing                  = RegistryRead:GetDouble("Door.Spacing",                  96.00 * Door.Cal)
  Door.Count                    = RegistryRead:GetInt("Door.Count",                       1)
  Door.BitRad                   = RegistryRead:GetDouble("Door.BitRad",                   0.750 * Door.Cal)
  Door.Width                    = RegistryRead:GetDouble("Door.Width",                    18.50 * Door.Cal)
  Door.Height                   = RegistryRead:GetDouble("Door.Height",                   28.75 * Door.Cal)
  StyleA.FluteSpacing           = RegistryRead:GetDouble("StyleA.FluteSpacing",           2.750 * Door.Cal)
  StyleB.FluteSpacing           = RegistryRead:GetDouble("StyleB.FluteSpacing",           2.750 * Door.Cal)
  StyleC.FluteSpacing           = RegistryRead:GetDouble("StyleC.FluteSpacing",           2.750 * Door.Cal)
  StyleE.FluteSpacing           = RegistryRead:GetDouble("StyleE.FluteSpacing",           2.750 * Door.Cal)
  StyleF.FluteSpacing           = RegistryRead:GetDouble("StyleF.FluteSpacing",           2.750 * Door.Cal)
  StyleG.FluteSpacing           = RegistryRead:GetDouble("StyleG.FluteSpacing",           2.750 * Door.Cal)
  Door.X                        = RegistryRead:GetDouble("Door.X",                        0.000)
  Door.Y                        = RegistryRead:GetDouble("Door.Y",                        0.000)
  StyleA.A                      = RegistryRead:GetDouble("StyleA.A",                      2.000 * Door.Cal)
  StyleA.B                      = RegistryRead:GetDouble("StyleA.B",                      2.250 * Door.Cal)
  StyleB.A                      = RegistryRead:GetDouble("StyleA.A",                      2.000 * Door.Cal)
  StyleB.B                      = RegistryRead:GetDouble("StyleB.B",                      5.500 * Door.Cal)
  StyleB.C                      = RegistryRead:GetDouble("StyleB.C",                      2.250 * Door.Cal)
  StyleB.D                      = RegistryRead:GetDouble("StyleB.D",                      2.250 * Door.Cal)
  StyleC.A                      = RegistryRead:GetDouble("StyleC.A",                      2.000 * Door.Cal)
  StyleC.B                      = RegistryRead:GetDouble("StyleC.B",                      5.500 * Door.Cal)
  StyleC.C                      = RegistryRead:GetDouble("StyleC.C",                      2.500 * Door.Cal)
  StyleC.D                      = RegistryRead:GetDouble("StyleC.D",                      2.250 * Door.Cal)
  StyleE.A                      = RegistryRead:GetDouble("StyleE.A",                      2.000 * Door.Cal)
  StyleE.B                      = RegistryRead:GetDouble("StyleE.B",                      3.500 * Door.Cal)
  StyleE.C                      = RegistryRead:GetDouble("StyleE.C",                      2.250 * Door.Cal)
  StyleF.A                      = RegistryRead:GetDouble("StyleF.A",                      2.000 * Door.Cal)
  StyleF.B                      = RegistryRead:GetDouble("StyleF.B",                      7.500 * Door.Cal)
  StyleF.C                      = RegistryRead:GetDouble("StyleF.C",                      2.500 * Door.Cal)
  StyleG.A                      = RegistryRead:GetDouble("StyleG.A",                      2.250 * Door.Cal)
  StyleG.B                      = RegistryRead:GetDouble("StyleG.B",                      2.500 * Door.Cal)
  StyleG.C                      = RegistryRead:GetDouble("StyleG.C",                      3.500 * Door.Cal)
  return true
end
-- ====================================================]]
function Registry_Update()                              -- Write to Registry values
    local RW = Registry(RegName)
    local RegValue = RW:SetString("DialogWindow.HelpXY",               DialogWindow.HelpXY)
          RegValue = RW:SetString("DialogWindow.AboutXY",              DialogWindow.AboutXY)
          RegValue = RW:SetString("DialogWindow.MainXY",               DialogWindow.MainXY)
          RegValue = RW:SetString("DialogWindow.DefaultXY",            DialogWindow.DefaultXY)
          RegValue = RW:SetString("DialogWindow.StyleAXY",             DialogWindow.StyleAXY)
          RegValue = RW:SetString("DialogWindow.StyleBXY",             DialogWindow.StyleBXY)
          RegValue = RW:SetString("DialogWindow.StyleCXY",             DialogWindow.StyleCXY)
          RegValue = RW:SetString("DialogWindow.StyleEXY",             DialogWindow.StyleEXY)
          RegValue = RW:SetString("DialogWindow.StyleFXY",             DialogWindow.StyleFXY)
          RegValue = RW:SetString("DialogWindow.StyleGXY",             DialogWindow.StyleGXY)
          RegValue = RW:SetString("Project.ProgramCodeBy",             Project.ProgramCodeBy)
          RegValue = RW:SetString("Project.ProgramName",               Project.ProgramName)
          RegValue = RW:SetString("Project.ProgramVersion",            Project.ProgramVersion)
          RegValue = RW:SetString("Door.CSVFile",                      Door.CSVFile)
          RegValue = RW:SetString("Door.CSVPath",                      Door.CSVPath)
          RegValue = RW:SetString("Door.LayerOFrame",                  Door.LayerOFrame)
          RegValue = RW:SetString("Door.LayerIFrame",                  Door.LayerIFrame)
          RegValue = RW:SetString("Door.LayerFlutes",                  Door.LayerFlutes)
          RegValue = RW:SetString("Door.Fluting",                      Door.Fluting)
          RegValue = RW:SetInt("Door.MaxWide",                         Door.MaxWide)
          RegValue = RW:SetInt("Door.Count",                           Door.Count)
          RegValue = RW:SetDouble("Door.Height",                       Door.Height)
          RegValue = RW:SetDouble("Door.Width",                        Door.Width)
          RegValue = RW:SetDouble("Door.X",                            Door.X)
          RegValue = RW:SetDouble("Door.Y",                            Door.Y)
          RegValue = RW:SetString("Door.Style",                        Door.Style)
          RegValue = RW:SetDouble("Door.Spacing",                      Door.Spacing)
          RegValue = RW:SetString("StyleA.Fluting",                    StyleA.Fluting)
          RegValue = RW:SetString("StyleB.Fluting",                    StyleB.Fluting)
          RegValue = RW:SetString("StyleC.Fluting",                    StyleC.Fluting)
          RegValue = RW:SetString("StyleE.Fluting",                    StyleE.Fluting)
          RegValue = RW:SetString("StyleF.Fluting",                    StyleF.Fluting)
          RegValue = RW:SetString("StyleG.Fluting",                    StyleG.Fluting)
          RegValue = RW:SetDouble("StyleA.FluteSpacing",               StyleA.FluteSpacing)
          RegValue = RW:SetDouble("StyleB.FluteSpacing",               StyleB.FluteSpacing)
          RegValue = RW:SetDouble("StyleC.FluteSpacing",               StyleC.FluteSpacing)
          RegValue = RW:SetDouble("StyleE.FluteSpacing",               StyleE.FluteSpacing)
          RegValue = RW:SetDouble("StyleF.FluteSpacing",               StyleF.FluteSpacing)
          RegValue = RW:SetDouble("StyleG.FluteSpacing",               StyleG.FluteSpacing)
          RegValue = RW:SetDouble("Door.BitRad",                       Door.BitRad)
          RegValue = RW:SetDouble("StyleA.A",                          StyleA.A)
          RegValue = RW:SetDouble("StyleA.B",                          StyleA.B)
          RegValue = RW:SetDouble("StyleB.A",                          StyleB.A)
          RegValue = RW:SetDouble("StyleB.B",                          StyleB.B)
          RegValue = RW:SetDouble("StyleB.C",                          StyleB.C)
          RegValue = RW:SetDouble("StyleB.D",                          StyleB.D)
          RegValue = RW:SetDouble("StyleC.A",                          StyleC.A)
          RegValue = RW:SetDouble("StyleC.B",                          StyleC.B)
          RegValue = RW:SetDouble("StyleC.C",                          StyleC.C)
          RegValue = RW:SetDouble("StyleC.D",                          StyleC.D)
          RegValue = RW:SetDouble("StyleE.A",                          StyleE.A)
          RegValue = RW:SetDouble("StyleE.B",                          StyleE.B)
          RegValue = RW:SetDouble("StyleE.C",                          StyleE.C)
          RegValue = RW:SetDouble("StyleF.A",                          StyleF.A)
          RegValue = RW:SetDouble("StyleF.B",                          StyleF.B)
          RegValue = RW:SetDouble("StyleF.C",                          StyleF.C)
          RegValue = RW:SetDouble("StyleG.A",                          StyleG.A)
          RegValue = RW:SetDouble("StyleG.B",                          StyleG.B)
          RegValue = RW:SetDouble("StyleG.C",                          StyleG.C)
end
-- ====================================================]]
function Radius2Bulge (p1, p2, Rad)
  local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
  local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
  local bulge = (2 * seg) / chord
  return bulge
end
-- ====================================================]]
function RowPoint()
  -- Move Right 10 times then move Up 1 and move right
  -- Door.pt01 = last point door was drawn (0.0, 96.0)
  -- Door.MaxWide = how many columns can be drawn (10)
  -- Door.Row = is the Y value of Door Row
  -- Door.Spacing = Step amount (96.0)
  -- Door.RowCount = column position 1 - 10
  if Door.RowCount < Door.MaxWide then
    Door.pt01 = Polar2D(Door.pt01,  0.0, Door.Spacing)
    Door.RowCount = Door.RowCount + 1
  else
    Door.Row = Door.Row + Door.Spacing
    Door.pt01 = Point2D(0.0, Door.Row)
    Door.RowCount = 1
  end
  return true
end
-- ====================================================]]
function StartDate(LongShort)
--[[ Date Value Codes
--  |   %a  abbreviated weekday name (e.g., Wed)
--  |    %A  full weekday name (e.g., Wednesday)
--  |    %b  abbreviated month name (e.g., Sep)
--  |    %B  full month name (e.g., September)
--  |    %c  date and time (e.g., 09/16/98 23:48:10)
--  |    %d  day of the month (16) [01-31]
--  |    %H  hour, using a 24-hour clock (23) [00-23]
--  |    %I  hour, using a 12-hour clock (11) [01-12]
--  |    %M  minute (48) [00-59]
--  |    %m  month (09) [01-12]
--  |    %p  either "am" or "pm" (pm)
--  |    %S  second (10) [00-61]
--  |    %w  weekday (3) [0-6 = Sunday-Saturday]
--  |    %x  date (e.g., 09/16/98)
--  |    %X  time (e.g., 23:48:10)
--  |    %Y  full year (e.g., 1998)
--  |    %y  two-digit year (98) [00-99]
--  |    %%  the character `%´ ]]
  if LongShort then
    return os.date("%b %d, %Y")
  else
    return os.date("%Y%m%d")
  end
end
-- ====================================================]]
function HTML()
-- ====================================================]] -- Style
DialogWindow.Style = [[<style>html{overflow:hidden}.DirectoryPicker{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap;background-color:#696969;color:#FFF}
.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap;background-color:#696969;color:#FFF}
.FormButtonWide{font-weight:bold;width:100px;font-family:Arial,Helvetica,sans-serif;font-size:12px;white-space:nowrap;background-color:#696969;color:#FFF}
.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px;background-color:#696969;color:#FFF}
.FilePicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px;background-color:#696969;color:#FFF}
.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}
.ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;width:50px;background-color:#696969;color:#FFF}.TableSizeMax{border:0;width:100%}.TableSize600{width:600px;border:0}.PathTableSize600{width:600px;border:0}.PathColumn1{width:50px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.PathColumn2{width:300px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.PathColumn3{width:30px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootTableSize600{width:690px;border:0}.FootColumn1{width:45px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn2{width:300px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.FootColumn3{width:25px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.FootColumn4{width:25px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.Column1{width:100px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.Column2{width:30px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.Column3{width:250px;font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.alert-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#FFF;text-align:center;white-space:nowrap}.alert-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;text-shadow:5px 5px 10px #FFF;color:#FF0101;text-align:left;white-space:nowrap}.alert-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}.error{font-family:Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#F00;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorMessage{font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px}.errorTable{background-color:#FFF;white-space:nowrap}.p1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left;color:#000}.p1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;color:#000}.p1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right;color:#000}.ver-c{font-family:Arial,Helvetica,sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap;color:#ffd9b3}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap;color:#000}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;color:#000}.h1-rP{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;color:#000}.h1-rPx{font-family:Arial,Helvetica,sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px;color:#000}.h2-l{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:left;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-c{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#630;text-align:center;white-space:nowrap;text-shadow:2px 2px white;color:#000}.h2-r{font-family:Arial,Helvetica,sans-serif;font-size:14px;font-weight:bold;color:#000;text-align:right;white-space:nowrap;text-shadow:2px 2px white;color:#8E8D8A}.h3-bc{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.h3{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap;color:#000}.webLink-c{font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;background-color:yellow;text-align:center;white-space:nowrap}.jsbutton{background-color:#630;border:2px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:1px 1px;color:#FFF}.jsTag-no-vis{font-family:Arial,Helvetica,sans-serif;font-size:10px;display:none;text-align:center;color:#00F;visibility:hidden}body{background-color:#EAE7DC;background-position:center;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#8E8D8A;} html{overflow:hidden}</style>]]

DialogWindow.Aimage = [[<img src='data:image/jpeg;base64,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' width="175"/>]]

DialogWindow.Bimage = [[<img src='data:image/jpeg;base64,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' width="175"/>]]

DialogWindow.Cimage = [[<img src='data:image/jpeg;base64,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' width="175"/>]]


DialogWindow.Eimage = [[<img src='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCAFoAV4DASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9U6KKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAK+dbHWvAXwg+P3xN8W/EnXNH8KeIdbms7Xw9q/ijU0t1m0SOxtd1vZyTOI1Vb4XjywxYfc8Ukq4kgZvoqigAooooAKKKKACiiigAooooAKKKKAPH/2utPab9m34janb6lrGkalofh/UtY0+80TV7rTporqGzmaJi9vIhdQ3PluWQkAlTgY+YP8AhXOoeCfBep/EuL40/ED7fH4z1jSbHwvrPi68u4riG01m7gjtdKgeZTc6kbe0/cQ3RuoZpAUlhZX3R/Sn7aHizQ/Cf7LPxS/tvWdP0b+0vDOq6bY/2hdJB9qupLGfy7eLeRvlbadqLljg4HFfMHifxR+zv4P+DPxa1PxH4h8L+HfiUniDxdHcSaS0Emv3LvrV+lvBc2aSRvfwMGgJtLom2kRUMoEa7lAPr/8AZ78fzfEf4dnU31a38S21tqd/ptn4kszGYNZt7e5kijulKBQWKoEkZY442mjmaFfIaF29LrxT9lPV7jUPBOvWcdp9n8N6drTw+H5YhM1rLYy21vdFbKaSKIT2MNxc3NtbSxRpG1vbQBAQNze10AFFFFABRRRQAUUUUAFeP/FT9oCbwd4m0jwn4R8K3HjjxZqepw6QEW9jstNsLh4Huil3dMGZGFnDcXHlxRTSBUj3Kn2iAyewV8q/s9/6R+0t47vvEfHiS6/tj7Ar/LKvlasbe63xrjy86ZB4PK+YB5kZjlj3GWd2AOgsf2mvGuhfG3TPh54++Ftv4Xt9SmgW18U2HiVL3TJYpIZvnUyQQS7hdLaWm0xgCS9hDMpltluPoquK+JPgPwV4rk8P6n4wgt1fR9TtJtOvJb17QrdG6ga3hLo6eYr3MdoRA5ZJJYoCUZkTHa0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAc/42+HvhX4laVFpni7wzo/irTYZhcx2et2EV5CkoVlEgSRWAYK7jdjOGI7mvFbX4I/DrwB+1f8O7jwx4A8L+HLgeEvEdyJdJ0a2tWEq3WjxLJmNAdwjuJ0DdQs0g6OwP0VXlXiP/AJOm+Hn/AGJnib/0u0GgD1WiiigAooooAKKKKACiiigAr5//AGoPhB4Yk8E+KviI+p+IPC2p6BZTeILm88N3ksZuWtLZyS0KyxjzXhQQNPDJb3TwD7OLmOJmWvoCvKv2sf8Ak1n4yf8AYmaz/wCkM1AHP/CH9l+bwf4yj8e/EPx3rHxa+IsUMlva6tq8MdrY6UrjZIdOsI/3do0sSQpK6lmfy2OVEjq3utFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFfNXwS/Z7+Fnjjwv4h1vxJ8NPB/iDWrrxn4q8/UdU0G1ubibbr9+i75HjLNhVVRk8BQOgr0D/hk74If9Eb+H/8A4S9j/wDGqAPVa8q8R/8AJ03w8/7EzxN/6XaDR/wyd8EP+iN/D/8A8Jex/wDjVfOut/A34ZR/tOW2oQfDHwPD4E0vU7bwHqOm3PhiwS0hvbrT5dSa9bbCAWeR9Cs4Hkf7891EsYaZHcA+36K8q/4ZO+CH/RG/h/8A+EvY/wDxqj/hk74If9Eb+H//AIS9j/8AGqAPVaK8q/4ZO+CH/RG/h/8A+EvY/wDxqj/hk74If9Eb+H//AIS9j/8AGqAPVaK8q/4ZO+CH/RG/h/8A+EvY/wDxqj/hk74If9Eb+H//AIS9j/8AGqAPVaK8q/4ZO+CH/RG/h/8A+EvY/wDxqj/hk74If9Eb+H//AIS9j/8AGqAPVa8q/ax/5NZ+Mn/Ymaz/AOkM1H/DJ3wQ/wCiN/D/AP8ACXsf/jVeafHr9mX4PQ+GdC0DSPhR4Hs9Y8T+INO0eEWnhyzgmltTOJ9SVJljBhYadb37iRWRwUHlsJTHkA+oKK+avgL+zv8ACTxd8J9CuNe+Evw/vvElh5+i61eL4T09EudSsZ5LK8mjVYQBE9xbyunyr8jLlEOVHoH/AAyd8EP+iN/D/wD8Jex/+NUAeq0V5V/wyd8EP+iN/D//AMJex/8AjVH/AAyd8EP+iN/D/wD8Jex/+NUAeq0V5V/wyd8EP+iN/D//AMJex/8AjVH/AAyd8EP+iN/D/wD8Jex/+NUAeq0V5V/wyd8EP+iN/D//AMJex/8AjVH/AAyd8EP+iN/D/wD8Jex/+NUAeq0V5V/wyd8EP+iN/D//AMJex/8AjVH/AAyd8EP+iN/D/wD8Jex/+NUAeq0V5V/wyd8EP+iN/D//AMJex/8AjVH/AAyd8EP+iN/D/wD8Jex/+NUAeq0V5V/wyd8EP+iN/D//AMJex/8AjVcV4v8Agj8Ovhr8WvgdqfhHwB4X8K6lN4turaS80TRrazmeI+H9XYxl40UlSyIducZUHsKAPoqiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA8q/Zp/5J1q//Y5+LP8A1IdRr1WvKv2af+Sdav8A9jn4s/8AUh1GvVaACvjW90T4w2OgaN8IpPCXgc+J9VmvvHsGtL4vvPsS6ha63aalJug/sreIDe3sW2AOWMKuhnDgSH7KryrxH/ydN8PP+xM8Tf8ApdoNAHqtFFFABRRRQAUUUUAFFFFABXhX7T174q8FR6T8TNK0bR/E/h74f6ZrGv3uj6lq0umzfaltQkVxA8drN5jLbNqMXlOUQm6VicopX3WvKv2sf+TWfjJ/2Jms/wDpDNQAfBvwv440Txd8QtX8V6X4f0e08SXtpqkNro2sz6m4uktI7SctJJaWwSIw2lnsQK7b/PJfDIqeq0UUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V8ZP8AkovwJ/7HO5/9R7Wa9Vryr4yf8lF+BP8A2Odz/wCo9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB5V+zT/yTrV/+xz8Wf8AqQ6jXqteVfs0/wDJOtX/AOxz8Wf+pDqNeq0AFeVeI/8Ak6b4ef8AYmeJv/S7Qa9VryrxH/ydN8PP+xM8Tf8ApdoNAHqtFFFABRRRQAUUUUAFFFef+Kf2hPhZ4H1660TxJ8S/B/h/WrXb5+napr1rbXEO5Q6743kDLlWVhkchgehoA9Arwr9ovwPp3jrxx8MtG8R3OsXfhPxFNqnhi/0HTdbvdMhuWmsJLxZ5zbSoZ1SPTZ4PJfKkXrNkbNr9B/w0t4R/6BHxA/8ADceIf/kGvNPHHxU8YfG74VW03h34EfEizuF1PTtZsoPEC6RpjSy6fqMN2sE0c2oLNAsr2vl+YYmKrJ5ipIMKwB2v7O3h1LHXviRqun6r4gvvDba1/YukR6z4gvtUQpYr5V1Mv2yaWSOX7c19A+CqOlnAypj95L7XXz/8KvHt58H/AIceHPDvin4dfEDTY9Pso7e58QNpFvqr6pfkbp7iS30q6vbhZZ5DNO8si7S7NvlLuu/q/wDhpbwj/wBAj4gf+G48Q/8AyDQB6rRXn/hb9oT4WeONetdE8N/Evwf4g1q63eRp2l69a3NxNtUu2yNJCzYVWY4HAUnoK9AoAKKKKACiiigAooooAKKKKACvKvjJ/wAlF+BP/Y53P/qPazXqteVfGT/kovwJ/wCxzuf/AFHtZoA9VooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPKv2af+Sdav8A9jn4s/8AUh1GvVa8q/Zp/wCSdav/ANjn4s/9SHUa9VoAK8q8R/8AJ03w8/7EzxN/6XaDXqteVeI/+Tpvh5/2Jnib/wBLtBoA9VooooAKKK8q/wCFga58Wf8ARfh2v2Hw3J+7uvHF9FJFhTyH0qCWEpfZQZW5Yi1HnRSIbwLLCADtfG3j/wAPfDnSotQ8R6tb6XbzzC1tUkJaa8uGVmS3t4lBeedwjbIYlaRyMKpPFcV/wmHxL8dfN4U8Laf4P0WbiHXPGrSveED5lmTSYdrGKRdqhZ7q1njZnMkAMYSToPBPwh8PeCdVl1xI7jWvFlxCbe68T63MbvUpo2ZXeIStxDAZF8z7NAI7dGJKRJnFdrQB5V/wzroevc+O9c8QfE/+E2vim7T+zpIxyscum2scFjPtfLq81u8gbad/7uPZ3/hbwnofgfQbXRPDejaf4f0W13eRp2l2qW1vDuYu2yNAFXLMzHA5LE9TWtRQAUUUUAFFFFAGT4p8J6H440G60TxJo2n+INFutvn6dqlqlzbzbWDrvjcFWwyqwyOCoPUVwH/DOuh6Dz4E1zxB8MP4Ra+FrtP7OjjPLRxabdRz2MG58Ozw26SFtx3/ALyTf6rRQB5V/wAJh8S/AvzeK/C2n+MNFh4m1zwU0qXgB+Zpn0mbcwijXcpWC6up5GVDHATIUj7XwT4/8PfEbSpdQ8Oatb6pbwTG1ukjJWazuFVWe3uImAeCdA674ZVWRCcMoPFdBXFeNvhD4e8barFrjx3Gi+LLeEW9r4n0SY2mpQxqzOkRlXiaASN5n2acSW7sAXifGKAO1oryr/hYGufCb/RfiIv27w3H+7tfHFjFJLlRyX1WCKEJY4Q5a5Um1PkyyObMNFCfVaACiiigAooooAK8q+Mn/JRfgT/2Odz/AOo9rNeq15V8ZP8AkovwJ/7HO5/9R7WaAPVaKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigDyr9mn/AJJ1q/8A2Ofiz/1IdRr1WvKv2af+Sdav/wBjn4s/9SHUa9VoAK+P9S+KnxT1Cfw98Zv+Ff8Ag+OHSLLU/CP/AAjv/CZXRvJdTu9UsLX7Jv8A7K8pZUvLD7Nu3mFml3+cIl3t9gV8v63pN9b/ALRVt8M47K4n8Max4gtviNJGImgtI7WC3lE8MTY27otZttJvZBG4eR9VJeMp5zyAH1BWT4p8U6X4L0G61jWLr7JYW+0MyxvK7u7BI4o40BeWV3ZESNAzu7qqqzMAberatY6DpV5qep3lvp2m2UL3N1eXcqxQwRIpZ5HdiAqqoJLE4ABJrz/wHpN94+1WDx34osrizeGa4HhvQ7uJoxptqWeJL143Af7XcwnefMVHt4pjbhEY3LTgFX/hBdU+Mn734naDp9t4WX5rTwPLMt/FcE8rPqfyeVJKgIC2qGWCKRWl824byHt/VaKKACiiigAooooAKKKKACiiigAooooAKKKKACvKv+EF1T4N/vfhjoOn3PhZvmu/A8Uy2EVuRy0+mfJ5UcrgENauYoJZGWXzbdvPe49VooAyfC3inS/Gmg2usaPdfa7C43BWaN4nR0YpJFJG4DxSo6ujxuFdHRlZVZSBrV5p420m+8B+JovHHhyyuLizuJgPFulWMTTyXtqsDIl7BbqMyXcLLAp2fPLbLJHsnkitET0DSdWsde0qz1PTLy31HTb2FLm1vLSVZYZ4nUMkiOpIZWUghgcEEEUAW6KKKACvKvjJ/wAlF+BP/Y53P/qPazXqteVfGT/kovwJ/wCxzuf/AFHtZoA9VooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPKv2af+Sdav8A9jn4s/8AUh1GvVa8q/Zp/wCSdav/ANjn4s/9SHUa9VoA5Tx18J/BHxQ+w/8ACZeDfD/i37Dv+yf27pcF79n37d/l+ajbd2xM4xnauegrlf8Ahk74If8ARG/h/wD+EvY//Gq9VooA+avjb+z38LPA/hfw9rfhv4aeD/D+tWvjPwr5Go6XoNrbXEO7X7BG2SJGGXKsynB5DEdDX0rXlX7S3/JOtI/7HPwn/wCpDp1eq0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V+zT/wAk61f/ALHPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/6kOo0Aeq0UUUAFeVfGT/AJKL8Cf+xzuf/Ue1mvVa8q+Mn/JRfgT/ANjnc/8AqPazQB6rRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAeVfs0/8k61f/sc/Fn/AKkOo16rXlX7NP8AyTrV/wDsc/Fn/qQ6jXqtABRRRQB5V+0t/wAk60j/ALHPwn/6kOnV6rXlX7S3/JOtI/7HPwn/AOpDp1eq0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V+zT/AMk61f8A7HPxZ/6kOo16rXlX7NP/ACTrV/8Asc/Fn/qQ6jQB6rRRRQAV5V8ZP+Si/An/ALHO5/8AUe1mvVa8q+Mn/JRfgT/2Odz/AOo9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFc/wCP/G1j8OfBureI9QiuLq3sITItnZKr3N5KSFitrdGZRJPNIyRRx5BeSRFHLCjwB42sfiN4N0nxHp8Vxa29/CJGs71VS5s5QSsttcIrMI54ZFeKSPJKSRup5U0AdBRRRQB5V+zT/wAk61f/ALHPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/6kOo16rQAUUUUAeVftLf8k60j/sc/Cf/AKkOnV6rXlX7S3/JOtI/7HPwn/6kOnV6rQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXlX7NP/JOtX/7HPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/wCpDqNAHqtFFFABXlXxk/5KL8Cf+xzuf/Ue1mvVa8q+Mn/JRfgT/wBjnc/+o9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAfCv8AwUO+Lnw5k+I/wx+EvxO8Xf8ACOfD2687xP4ttYI9QFxfwQny9PtA1tG4aKW4EzyKQCBahg8biPf2v7CfxosfHelXFsniC38RPr8La3HfWiLDC+oWy29nrSJbKo+zq9z9n1IGRIWlGuBvJVllNav7NHwZ+MPgX40eNfG/xGbwPK/jDTIF1m48N3l5LNcahbXM/wBjeOOWGNIYEsp1tyuXZjaxOWLPITz/AIs+Dv7Rd58WPEfjHR4fhf5ketQal4ZSbU9Rt7ePyYNQsvtGo2q2z/aLmWyv0id4posGztuXSIIQD3XVtf8AjDDqt5HpngXwPeaaszra3F340vIJpYgx2O8a6S4RiuCVDuASQGbGTV/4ST43/wDRPPh//wCF5ff/ACmr1WigD4q+GPjb4v6T4Xv45dM/4RvwhJ4m8S/2hrHhfQm8T3FrI+v6gJvJIuIrgSrISkeNMuowBHNJ8rSww6upeKfN8afDTUPh78UNQ+KvjP8A4SZ9L1PSPEXif+yore2fRtVmFpqFhY2qx28qS2zSDz7I3AkhMbMoQCP2v9mn/knWr/8AY5+LP/Uh1Gu/1Hwnoesa9pGt3+jafe61o/nf2bqNxapJcWXmqEl8mQjdHvUBW2kbgMHIoA4D/hJPjf8A9E8+H/8A4Xl9/wDKavFNN8U+V40+JeofEL4oah8KvGf/AAkyaXpmkeHfE/8AasVxbJo2lTG00+wvrVo7iV5blZD5FkLgyTCNWYORJ9gVk6d4T0PR9e1fW7DRtPsta1jyf7S1G3tUjuL3ylKRedIBuk2KSq7idoOBgUAfJfjjxl8Udc03Q7e+tbjWPh8PFvhdYfEGueGv+EfvpQviHTgjvG9200k+8bXVtPson/eSxsqrFFN9lV5V+0t/yTrSP+xz8J/+pDp1eq0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V+zT/yTrV/+xz8Wf+pDqNeq15V+zT/yTrV/+xz8Wf8AqQ6jQB6rRRRQAV5V8ZP+Si/An/sc7n/1HtZr1WvKvjJ/yUX4E/8AY53P/qPazQB6rRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAeVfs0/wDJOtX/AOxz8Wf+pDqNeq15V+zT/wAk61f/ALHPxZ/6kOo16rQAUUUUAeVftLf8k60j/sc/Cf8A6kOnV6rXlX7S3/JOtI/7HPwn/wCpDp1eq0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V+zT/wAk61f/ALHPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/6kOo0Aeq0UUUAFeVfGT/AJKL8Cf+xzuf/Ue1mvVa8q+Mn/JRfgT/ANjnc/8AqPazQB6rRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAeVfs0/8k61f/sc/Fn/AKkOo16rXlX7NP8AyTrV/wDsc/Fn/qQ6jXqtABRRRQB5V+0t/wAk60j/ALHPwn/6kOnV6rXlX7S3/JOtI/7HPwn/AOpDp1eq0AFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V+zT/AMk61f8A7HPxZ/6kOo16rXlX7NP/ACTrV/8Asc/Fn/qQ6jQB6rRRRQAV5V8ZP+Si/An/ALHO5/8AUe1mvVa8q+Mn/JRfgT/2Odz/AOo9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB5V+zT/yTrV/+xz8Wf+pDqNeq15V+zT/yTrV/+xz8Wf8AqQ6jXqtABRRRQB5V+0t/yTrSP+xz8J/+pDp1eq15V+0t/wAk60j/ALHPwn/6kOnV6rQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXlX7NP/JOtX/7HPxZ/wCpDqNeq15V+zT/AMk61f8A7HPxZ/6kOo0Aeq0UUUAFeVfGT/kovwJ/7HO5/wDUe1mvVa8q+Mn/ACUX4E/9jnc/+o9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB5V+zT/wAk61f/ALHPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/6kOo16rQAUUUUAeVftLf8k60j/sc/Cf/AKkOnV6rXlX7S3/JOtI/7HPwn/6kOnV6rQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXlX7NP/JOtX/7HPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/wCpDqNAHqtFFFABXlXxk/5KL8Cf+xzuf/Ue1mvVa8q+Mn/JRfgT/wBjnc/+o9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB5V+zT/AMk61f8A7HPxZ/6kOo16rXlX7NP/ACTrV/8Asc/Fn/qQ6jXqtABRRRQB5V+0t/yTrSP+xz8J/wDqQ6dXqteaftDaHrOvfDeKPQNHuPEGpWXiDQdVGm2k0EU08Vpq9ndTKjTyRx7vKhkIDOoJAGeaq/8AC5PF3/RCfiB/4HeHv/lrQB6rRXlX/C5PF3/RCfiB/wCB3h7/AOWtH/C5PF3/AEQn4gf+B3h7/wCWtAHqtFeFa9+1HeeGfE3hnw7qfwf8cWmu+JZp4NI09r/w8ZrtoYHnmKqNVJCpGhLOcKCyKTudA3Qf8Lk8Xf8ARCfiB/4HeHv/AJa0Aeq0V5V/wuTxd/0Qn4gf+B3h7/5a0f8AC5PF3/RCfiB/4HeHv/lrQB6rRXlX/C5PF3/RCfiB/wCB3h7/AOWtH/C5PF3/AEQn4gf+B3h7/wCWtAHqtFeVf8Lk8Xf9EJ+IH/gd4e/+WtH/AAuTxd/0Qn4gf+B3h7/5a0Aeq0V5V/wuTxd/0Qn4gf8Agd4e/wDlrR/wuTxd/wBEJ+IH/gd4e/8AlrQB6rRXlX/C5PF3/RCfiB/4HeHv/lrR/wALk8Xf9EJ+IH/gd4e/+WtAHqtFeVf8Lk8Xf9EJ+IH/AIHeHv8A5a0f8Lk8Xf8ARCfiB/4HeHv/AJa0Aeq15V+zT/yTrV/+xz8Wf+pDqNH/AAuTxd/0Qn4gf+B3h7/5a1a/Z50PWdB+G8sev6PceH9SvfEGvaqdNu5oJZoIrvV7y6hV2gkkj3eVNGSFdgCSM8UAel0UUUAFeVfGT/kovwJ/7HO5/wDUe1mvVa8q+Mn/ACUX4E/9jnc/+o9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB5V+zT/wAk61f/ALHPxZ/6kOo16rXlX7NP/JOtX/7HPxZ/6kOo16rQAUUUUAFFFFABRRRQB8q/Hr/iprz4t+OZP3tp8JbLTZLG0k+R5LqymtPEWoRKV48q6hg0aESvuaJ4ZSseM+d9VV81fE74H+HfD/xA+G0Oj6l4w0W08VeM7/8Atez0vxrrNpbz+dpmrX8uyGK7VId11Ekp8pV5BHRmB9/8J+FtL8D+FdG8N6Ja/YtF0eyh0+xtvMeTyYIo1jjTc5LNhVAyxJOOSTQBrUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXlXxk/5KL8Cf+xzuf/Ue1mvVa8q+Mn/JRfgT/wBjnc/+o9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB5V+zT/AMk61f8A7HPxZ/6kOo16rXlX7NP/ACTrV/8Asc/Fn/qQ6jXqtABRRRQAUUUUAFFFFAHzV8Tvjh4d8QfED4bTaPpvjDWrTwr4zv8A+17zS/BWs3dvB5OmatYS7JorRkm23UqRHymbkk9FYj3/AMJ+KdL8ceFdG8SaJdfbdF1iyh1CxufLePzoJY1kjfa4DLlWBwwBGeQDXzX8ev8Aimbz4t+BpP3Np8WrLTY7G7k+d47q9mtPDuoSqF48q1hn0aYRPtaV5pQsmM+T9VUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV5V8ZP+Si/An/ALHO5/8AUe1mvVa8q+Mn/JRfgT/2Odz/AOo9rNAHqtFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB4/p/7P8AqugyalHoHxe8ceH9NvdTvtVGm2lvoksMEt3dS3Uyo0+mySbfNmkIDOxAIGeKt/8ACm/F3/RdviB/4A+Hv/lVXqtFAHlX/Cm/F3/RdviB/wCAPh7/AOVVH/Cm/F3/AEXb4gf+APh7/wCVVeq0UAeVf8Kb8Xf9F2+IH/gD4e/+VVH/AApvxd/0Xb4gf+APh7/5VV6rRQB5V/wpvxd/0Xb4gf8AgD4e/wDlVR/wpvxd/wBF2+IH/gD4e/8AlVXqtFAHyr8XPgjrUfxR+B9/cfFvxhf6r/wk15Y2mpXGnaB9osEk0TUpZTC66YMb/s6KyvuQjnbvWN09V/4U34u/6Lt8QP8AwB8Pf/Kqj4yf8lF+BP8A2Odz/wCo9rNeq0AeVf8ACm/F3/RdviB/4A+Hv/lVR/wpvxd/0Xb4gf8AgD4e/wDlVXqtFAHlX/Cm/F3/AEXb4gf+APh7/wCVVH/Cm/F3/RdviB/4A+Hv/lVXqtFAHlX/AApvxd/0Xb4gf+APh7/5VUf8Kb8Xf9F2+IH/AIA+Hv8A5VV6rRQB5V/wpvxd/wBF2+IH/gD4e/8AlVR/wpvxd/0Xb4gf+APh7/5VV6rRQB5V/wAKb8Xf9F2+IH/gD4e/+VVH/Cm/F3/RdviB/wCAPh7/AOVVeq0UAeVf8Kb8Xf8ARdviB/4A+Hv/AJVUf8Kb8Xf9F2+IH/gD4e/+VVeq0UAeVf8ACm/F3/RdviB/4A+Hv/lVR/wpvxd/0Xb4gf8AgD4e/wDlVXqtFAHlX/Cm/F3/AEXb4gf+APh7/wCVVH/Cm/F3/RdviB/4A+Hv/lVXqtFAHlX/AApvxd/0Xb4gf+APh7/5VUaf8C7/AP4S7wxr2vfE/wAYeLf+EdvZdQstP1SDSIrfz3tLi0LubWwhkOIrqXA3gZIJBxXqtFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFc/4/wDG1j8OfBureI9QiuLq3sITItnZKr3N5KSFitrdGZRJPNIyRRx5BeSRFHLCgDivjJ/yUX4E/wDY53P/AKj2s16rXyVp/wAJ/Hv7UkmpeIPE3xZ8UeBNCt9TvtNs9F+H+ovp81rcWd1LaXGLoKBNA0kLrieKSRzCk8b2izy2SdB+zD4P+K/gn4yfFrT/AIk+KfEHje0ay0ObTPEWorHb6dfOReCdrKzh/dWewLBFJECzs0QmY4nQAA+laKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigArivjJ4JvvH/w71DTNJlt4ddgmtdV0lr1mW2OoWdzFeWi3BVS3kGe3iEgQbjGXCkNgjtaKAPn/APZD+Jmh+JPBd1ozT/2R4quNa1/XpPC+pukWp21rc6zdTo0kIY52faEhlKFlinSWByssUiL6X8OfjF4V+LlxrjeDtUt/EekaRNHaTa5ptxFPYy3TRiV4IpEcl2jjkgZ2A2fvlUMzpKsfP/Ej9ln4UfFzXrfWPFvgnT9Wv472DUJmzJCl9PCuyB7yONlS88tNyILgSBUkkUALI4bv/C3hPQ/A+g2uieG9G0/w/otru8jTtLtUtreHcxdtkaAKuWZmOByWJ6mgDWooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA8f8N/ETxl4M+Imm+DPib/AGPqD+JZp18M+IfC+m3dtbTtBbLNNaXkMjzC2nKrcSRETusscEuRGyBZPYKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAP/2dpZfS6KKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAP/2Q==' width="175"/>]]

DialogWindow.Fimage = [[<img src='data:image/jpeg;base64,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b/0u0GgD1WiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA8q/ZO/5NZ+Df/YmaN/6Qw16rXlX7J3/JrPwb/wCxM0b/ANIYa9VoAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAK8q8R/8nTfDz/sTPE3/AKXaDXqteVeI/wDk6b4ef9iZ4m/9LtBoA9VooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPKv2Tv+TWfg3/2Jmjf+kMNeq15V+yd/yaz8G/8AsTNG/wDSGGvVaACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACvKvEf/J03w8/7EzxN/wCl2g16rXlXiP8A5Om+Hn/YmeJv/S7QaAPVaKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigDx/Sf2U/Aeg6VZ6Zpl34407TbKFLa1s7T4heIIoYIkUKkaIt8AqqoACgYAAAq3/wAM0+Ef+gv8QP8Aw4/iH/5Or1WigDyr/hmnwj/0F/iB/wCHH8Q//J1H/DNPhH/oL/ED/wAOP4h/+Tq9VooA8q/4Zp8I/wDQX+IH/hx/EP8A8nUf8M0+Ef8AoL/ED/w4/iH/AOTq9VooA8q/4Zp8I/8AQX+IH/hx/EP/AMnUf8M0+Ef+gv8AED/w4/iH/wCTq9VooA8q/wCGafCP/QX+IH/hx/EP/wAnUf8ADNPhH/oL/ED/AMOP4h/+Tq9VooA8q/4Zp8I/9Bf4gf8Ahx/EP/ydR/wzT4R/6C/xA/8ADj+If/k6vVaKAPKv+GafCP8A0F/iB/4cfxD/APJ1H/DNPhH/AKC/xA/8OP4h/wDk6vVaKAPKv+GafCP/AEF/iB/4cfxD/wDJ1H/DNPhH/oL/ABA/8OP4h/8Ak6vVaKAPKv8Ahmnwj/0F/iB/4cfxD/8AJ1H/AAzT4R/6C/xA/wDDj+If/k6vVaKAPKv+GafCP/QX+IH/AIcfxD/8nUf8M0+Ef+gv8QP/AA4/iH/5Or1WigDyr/hmnwj/ANBf4gf+HH8Q/wDydR/wzT4R/wCgv8QP/Dj+If8A5Or1WigDyr/hmnwj/wBBf4gf+HH8Q/8AydR/wzT4R/6C/wAQP/Dj+If/AJOr1WigDyr/AIZp8I/9Bf4gf+HH8Q//ACdR/wAM0+Ef+gv8QP8Aw4/iH/5Or1WigDyr/hmnwj/0F/iB/wCHH8Q//J1avg74F+FPA/ipPElg3iC91qOym0+K513xPqereTBLJFJKka3dxKqbmt4SSoBPlrzivQKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPFPAvxi1yx+Pt98GvGU2n614kHhlPF1prWhaZJp9mbU3TWr28kMtzcOJVdUcOHKusjAqhjBl9roooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA//9k='width="175"/>]]


DialogWindow.Gimage = [[<img src='data:image/jpeg;base64,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iaNbWczxFlYxl40UlSyIducZUHsK7WigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoor41/ai1L40eE/jHaWvhj4z3Hh7QvFMNsuk6VD4a0+ddIl/tfQtMkeSSaN3uVYapPNt3RFWVV3FaAPdf2af+Sdav8A9jn4s/8AUh1GvVa+P/Dvjf4v/sz+JG8KeOb/AMH+O/DreXqdnqmnaW2i6pqcdzqUaandGCDzIXubee+t9tpHEJL37WhjkecPE/2BQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXx/+3NoH/CWeOPh9on9paho39pWX2L+0dJn8i8tfM8WeEk82CTB2Sru3K2DhgDjivsCvH/it+yZ8M/jfqt3f+NtL1jXHuofs0ls3ibVIbQRboWMa20dysSKz21vIyqgDPCjnLAGgD5K+Nnwl8Ifs3eNtK8R6p8RPEHxO8SeEtGuvGVnD8SPEY1O60kWtzaFPISTZBFFfESWPmNHNOtxLZyW6E28zJ+iteP/AAh/ZC+DXwHuI7vwR8PdH0nUoZpLiHVJo2vL6Fnj8pxHczs8qKUyuxXC/M3HzNn2CgAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigArxQeKPin4++Jnj7SvCmqeD/C3hvwpe2ukLNrGjXWrXl/dPZQXs0hEd3apBEqXluirmRmZJGJUbRRRQB//2Q=='width="175"/>]]


DialogWindow.myHtmlA = [[<!DOCTYPE html><head><title>Door Style</title> ]] .. DialogWindow.Style ..[[</head><body><table><tr><td><span class="h1-c">]] .. DialogWindow.Aimage ..[[</span></td><td colspan="2" valign="top"><table><tr><td colspan="2" class="h2-l" id="Door.Style">Door Style Name</td></tr>
<tr><td class="h2-r">A</td><td class="h1-l"><input type="text" id="Door.A" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">B</td><td class="h1-l"><input type="text" id="Door.B" size="10" maxlength="10" /></td></tr>
</table></td></tr></table><table><tr><td><span class="h1-l"> <select name="Door.Fluting" id="Door.Fluting"> </select> </span></td><td><span class="h2-r">Flute Spacing</span></td><td><span class="h1-l"> <input type="text" id="Door.FluteSpacing" size="10" /> </span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td align="center" class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td align="center" class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtmlB = [[<!DOCTYPE html><head><title>Door Style</title> ]] .. DialogWindow.Style ..[[</head><body><table><tr><td><span class="h1-c">]] .. DialogWindow.Bimage ..[[</span></td><td colspan="2" valign="top"><table><tr><td colspan="2" class="h2-l" id="Door.Style">Door Style Name</td></tr>
<tr><td class="h2-r">A</td><td class="h1-l"><input type="text" id="Door.A" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">B</td><td class="h1-l"><input type="text" id="Door.B" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">C</td><td class="h1-l"><input type="text" id="Door.C" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">D</td><td class="h1-l"><input type="text" id="Door.D" size="10" maxlength="10" /></td></tr>
</table></td></tr></table><table><tr><td><span class="h1-l"> <select name="Door.Fluting" id="Door.Fluting"> </select> </span></td><td><span class="h2-r">Flute Spacing</span></td><td><span class="h1-l"> <input type="text" id="Door.FluteSpacing" size="10" /> </span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td align="center" class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td align="center" class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtmlC = [[<!DOCTYPE html><head><title>Door Style</title> ]] .. DialogWindow.Style ..[[</head><body><table><tr><td><span class="h1-c">]] .. DialogWindow.Cimage ..[[</span></td><td colspan="2" valign="top"><table><tr><td colspan="2" class="h2-l" id="Door.Style">Door Style Name</td></tr>
<tr><td class="h2-r">A</td><td class="h1-l"><input type="text" id="Door.A" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">B</td><td class="h1-l"><input type="text" id="Door.B" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">C</td><td class="h1-l"><input type="text" id="Door.C" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">D</td><td class="h1-l"><input type="text" id="Door.D" size="10" maxlength="10" /></td></tr>
</table></td></tr></table><table><tr><td><span class="h1-l"> <select name="Door.Fluting" id="Door.Fluting"> </select> </span></td><td><span class="h2-r">Flute Spacing</span></td><td><span class="h1-l"> <input type="text" id="Door.FluteSpacing" size="10" /> </span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td align="center" class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td align="center" class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtmlE = [[<!DOCTYPE html><head><title>Door Style</title> ]] .. DialogWindow.Style ..[[
</head><body><table><tr><td><span class="h1-c">]] .. DialogWindow.Eimage ..[[</span></td><td colspan="2" valign="top"><table><tr><td colspan="2" class="h2-l" id="Door.Style">Door Style Name</td></tr><tr><td class="h2-r">A</td><td class="h1-l"><input type="text" id="Door.A" size="10" maxlength="10" /></td></tr><tr><td class="h2-r">B</td><td class="h1-l"><input type="text" id="Door.B" size="10" maxlength="10" /></td></tr><tr><td class="h2-r">C</td><td class="h1-l"><input type="text" id="Door.C" size="10" maxlength="10" /></td></tr></table></td></tr></table><table><tr><td><span class="h1-l"> <select name="Door.Fluting" id="Door.Fluting"> </select> </span></td><td><span class="h2-r">Flute Spacing</span></td><td><span class="h1-l"> <input type="text" id="Door.FluteSpacing" size="10" /> </span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td align="center" class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td align="center" class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtmlF = [[<!DOCTYPE html><head><title>Door Style</title> ]] .. DialogWindow.Style ..[[
</head><body><table><tr><td><span class="h1-c">]] .. DialogWindow.Fimage ..[[</span></td><td colspan="2" valign="top"><table><tr><td colspan="2" class="h2-l" id="Door.Style">Door Style Name</td></tr><tr><td class="h2-r">A</td><td class="h1-l"><input type="text" id="Door.A" size="10" maxlength="10" /></td></tr><tr><td class="h2-r">B</td><td class="h1-l"><input type="text" id="Door.B" size="10" maxlength="10" /></td></tr><tr><td class="h2-r">C</td><td class="h1-l"><input type="text" id="Door.C" size="10" maxlength="10" /></td></tr></table></td></tr></table><table><tr><td><span class="h1-l"> <select name="Door.Fluting" id="Door.Fluting"> </select> </span></td><td><span class="h2-r">Flute Spacing</span></td><td><span class="h1-l"> <input type="text" id="Door.FluteSpacing" size="10" /> </span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td align="center" class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td align="center" class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtmlG = [[<!DOCTYPE html><head><title>Door Style</title> ]] .. DialogWindow.Style ..[[</head><body><table><tr><td><span class="h1-c">]] .. DialogWindow.Gimage ..[[</span></td><td colspan="2" valign="top"><table><tr><td colspan="2" class="h2-l" id="Door.Style">Door Style Name</td></tr>
<tr><td class="h2-r">A</td><td class="h1-l"><input type="text" id="Door.A" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">B</td><td class="h1-l"><input type="text" id="Door.B" size="10" maxlength="10" /></td></tr>
<tr><td class="h2-r">C</td><td class="h1-l"><input type="text" id="Door.C" size="10" maxlength="10" /></td></tr>
</table></td></tr></table><table><tr><td><span class="h1-l"> <select name="Door.Fluting" id="Door.Fluting"> </select> </span></td><td><span class="h2-r">Flute Spacing</span></td><td><span class="h1-l"> <input type="text" id="Door.FluteSpacing" size="10" /> </span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td align="center" class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td align="center" class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtml6 = [[<!DOCTYPE html><html><head><title>About</title>]] .. DialogWindow.Style ..[[
</head><body text = "#000000"><table width="680" border="0" cellpadding="0"><tr><td align="center" nowrap="nowrap" class="h3" id="SysName">MDF Door Maker</td></tr><tr><td align="center" nowrap="nowrap" class="h2-c" id="Version"><span class="h1-c">Version</span></td></tr><tr><td align="center" nowrap="nowrap"><hr></td></tr><tr><td align="center" nowrap="nowrap" class="h2-c">Disclaimer</td></tr><tr><td align="center" class="p1-l"><p class="p1-l">The ]] .. AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br><br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br><br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td></tr><tr><td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td></tr><tr><td align="center" ><span class="h2-c">JimAndI Gadgets</span></td></tr><tr><td align="center"><span class="h1-c">Houston, TX.</span></td></tr><tr><td><hr></td></tr><tr><td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td></tr></table></body>]]


DialogWindow.myHtml2 = [[<!DOCTYPE HTML><html lan><head><title>Easy Tools</title>]] .. DialogWindow.Style ..[[
  </head><body bgcolor = "#EBEBEB" text = "#000000"><table><tr><td class="h1-c"><input type="image" name="imageField2" id="imageField2" src="Left.png" /></td><td rowspan="2"><table ><tr><td colspan="2" class="h2-l" id="Door.StyleName">Door Style Name</td></tr><tr><td class="h2-r">A</td><td class="h1-l"><input id="Door.A" size="10" type="text" /></td></tr><tr><td class="h2-r">B</td><td class="h1-l"><input id="Door.B" size="10" type="text" /></td></tr><tr><td class="h2-r">C</td><td class="h1-l"><input type="text" id="Door.C" size="10" /></td></tr><tr><td class="h2-r" id="Door.D">D</td><td class="h1-l"><input type="text" disabled id="Door.D" size="10" /></td></tr><tr><td class="h2-r" id="Door.E">E</td><td class="h1-l"><input type="text" disabled id="Door.E" size="10" /></td></tr><tr><td class="h2-r" id="Door.F">F</td><td class="h1-l"><input type="text" disabled id="Door.F" size="10" /></td></tr></table></td></tr><tr><td height="27" class="h1-c"></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "Close Help"></td><td class="FootColumn2" id="Door.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.myHtml1 = [[<!DOCTYPE html><html lang="en"><head><title>Default Settings</title> ]] .. DialogWindow.Style ..[[
  </head></head><body bgcolor = "#EBEBEB" text = "#000000"><table width="600" border="0"><tr><td colspan="2" class="h1-l">Manage Default Settings</td></tr><tr><td class="h1-r">Door Spacing</td><td class="h1-l"><input id="Door.Spacing" size="10" type="text" /></td></tr><tr><td class="h1-r">Doors Per Row</td><td class="h1-l"><input id="Door.MaxWide" size="10" type="text" /></td></tr><tr><td class="h1-r">Bit Clearance Radius</td><td class="h1-l"><input id="Door.BitRad" size="10" type="text" /></td></tr><tr><td class="h1-r">Layer Name: Outer Frame</td><td class="h1-l"><input type="text" id="Door.LayerOFrame" size="35" maxlength="35" /></td></tr><tr><td class="h1-r">Layer Name: Inter Frame</td><td class="h1-l"><input type="text" id="Door.LayerIFrame" size="35" maxlength="35" /></td></tr><tr><td class="h1-r">Layer Name: Flutes</td><td class="h1-l"><input type="text" id="Door.LayerFlutes" size="35" maxlength="35" /></td></tr></table><table class="TableSize600"><tr><td colspan="5"><hr></td></tr><tr><td align="left" nowrap><input id="MakeCSV" class="LuaButton" name="MakeCSV" type="button" value=" Make CSV File "></td><td align="right" nowrap></td></tr><tr><td colspan="4" nowrap><input id="DirectoryPicker" class="DirectoryPicker" name="DirectoryPicker" type="button" value=" CSV Path "> <input type="text" class="h1-l" id="DoorCSVPath" size="70" maxlength="200" /></td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="4"><hr></td></tr><tr><td class="FootColumn1" ><button class="FormButton" onClick="window.open(']].. DialogWindow.ProjectSDK .. [[');"> Help </button></td><td class="FootColumn2" id="Door.Alert">.</td><td class="FootColumn3" ><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td><td class="FootColumn4" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td></tr></table></body></html>]]


DialogWindow.Main =[[<!DOCTYPE html><html lang="en"><head><title>Main</title>]] .. DialogWindow.Style ..[[
  </head><body><table class="TableSize600"><tr><td colspan="4"><p>This Gadget draws cabinet doors based on user imputs (Height, Width, style, etc...) Doors are produced by Batch Mode (Reads a CSV file) or Manunal Mode.</p></td></tr><tr><td colspan="4"><hr></td></tr><tr><td><span class="h1-c"><select name="DoorStyle" id="DoorStyle">

</select></span></td><td><span class="h1-l"><span class="h1-c"><input name="InquiryStyle" type="button" class="LuaButton" id="InquiryStyle" value="Edit Style"></span></span></td><td><input id="InquiryAbout" class="LuaButton" name="InquiryAbout" type="button" value=" About ">
</td><td class="h2-r"><input name="InquiryDefault" type="button" class="LuaButton" id="InquiryDefault" value="Default Settings"></td></tr></table><table class="TableSize600"><tr><td colspan="6" nowrap><hr></td></tr><tr><td colspan="6" class="1abel-l">Manual Mode</td></tr><tr>
<td class="h1-c">X Value</td><td class="h1-c">Y Value</td><td class="h1-c">Count</td><td class="h1-c">Height</td><td class="h1-c">Width</td><td class="h1-c">&nbsp;</td></tr><tr><td class="h1-c"><input type="text" id="Door.X" size="10" maxlength="10" /></td><td class="h1-c"><input type="text" id="Door.Y" size="10" maxlength="10" /></td><td class="h1-c"><input type="text" id="Door.Count" size="10" maxlength="10" /></td><td class="h1-c"><input type="text" id="Door.Height" size="10" maxlength="10" /></td><td class="h1-c"><input type="text" id="Door.Width" size="10" maxlength="10" /></td><td align="right" ><span class="h2-r"><input name="InquiryMakeDoor" type="button" class="LuaButton" id="InquiryMakeDoor" value="Build"></span></td></tr></table><table><tr><td colspan="3"><hr></td></tr><tr><td colspan="3" class="lable-l">Batch Mode</td></tr><tr><td width="10"><span class="h1-r"><input name="FilePicker" type="button" class="FilePicker" id="FilePicker" value="File"></span></td><td width="100%" nowrap class="h1-l"><span id="ReadFile"></span></td><td width="15" align="right"><input name="InquiryRunCSV" type="button" class="LuaButton" id="InquiryRunCSV" value="Run CSV">
</td></tr></table><table class="TableSize600" id="HelpMessageOKCancel"><tr><td colspan="3"><hr></td></tr><tr><td class="FootColumn1"> <button class="FormButton" onClick="window.open(']] .. DialogWindow.ProjectSDK .. [[');"> Help </button> </td><td class="FootColumn2" id="Door.Alert">.</td><td class="h1-rPx" ><input id="ButtonCancel" class="FormButton" name="ButtonCancel2" type="button" value="Close"></td></tr></table></body></html>]]
-- ====================================================]] -- Name
  return true
end -- function end
-- ====================================================]]
function main()
  Door.job = VectricJob()
  if not Door.job.Exists then
    DisplayMessageBox("Error: This Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end
  GetUnits()
  Registry_Read()
  Project.LoadDate = StartDate(false)
  Door.UnitDisplay = "Note: Units: (" .. Door.Units ..")"
  HTML()           -- Load the Dialog HTML data
  if InquiryMain() then

  end -- if end
  return true
end -- function end
-- ====================================================]]
