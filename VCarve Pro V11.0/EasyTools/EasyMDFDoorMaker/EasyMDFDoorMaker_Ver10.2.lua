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
--require("mobdebug").start()
require "strict"
local VerNumber     = "10.2"
      AppName       = "Easy MDF Door Maker"
      RegName       = "EasyMDFDoorMaker"  .. VerNumber
local Version       = 10.2
--  Table Names
local Project       = {}
      Door          = {}
      DialogWindow  = {}   -- Dialog Management
local StyleA        = {}
local StyleB        = {}
local StyleC        = {}
local StyleE        = {}
local StyleF        = {}
local StyleG        = {}
local Tools
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
  if (WidthCheck) and (HeightCheck) then
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Flutes")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Flutes")
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
  if (WidthCheck) and (HeightCheck) then
    if (RadCheck) and (ArchCheck1) and (ArchCheck2) and (LegCheck1) and (LegCheck2) and (LegCheck3) then
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
      LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Arch panel")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
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
  if (1.0 < fltCount) and (LegCheck1) then
    while fltCount > 1 do
      if (chord < Door.Chord) and (Door.Arch) then
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Fluting")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
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

  if (WidthCheck) and (HeightCheck) then
    if (RadCheck) and (ArchCheck1) and (ArchCheck2) and (LegCheck1) and (LegCheck2) and (LegCheck3) then
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
      LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Arch panel")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
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
  if (1.0 < fltCount) and (LegCheck1) then
    while fltCount > 1 do
      if (chord < Door.Chord) and (Door.Arch) then
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Fluting")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
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
  local RadCheck1 = Door.Rad * 2.0 > Door.Seg
  local RadCheck2 =  (Door.pt04.y - StyleE.C) < (Door.pt07.y + Door.Seg) + (0.05 * Door.Cal)
  local SegCheck = (Door.Rad > (Door.ptT.y - Door.pt07.y))
  local LegCheck1 = (Door.pt05.x < Door.pt06.x)
  local LegCheck2 = (Door.pt05.y < Door.pt08.y)

 if (WidthCheck) and (HeightCheck) and (SegCheck) and (RadCheck2) then
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
    if  (LegCheck1) and (LegCheck2) then
      DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt08, Door.LayerIFrame)
    else
      DrawLine(Door.ptL, Door.ptR, Door.LayerFlutes)
    end --if end
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Fluting")
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
    if (1.0 < fltCount1 + fltCount2) and (LegCheck1) then
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
      LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
    end -- if end
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
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
  local RadCheck1 = Door.Rad * 2.0 > Door.Seg
  local RadCheck2 =  (Door.pt04.y - StyleF.C) == (Door.pt07.y + Door.Seg)
  local SegCheck = (Door.Rad > (Door.ptT.y - Door.pt07.y))
  local LegCheck1 = (Door.pt05.x < Door.pt06.x)
  local LegCheck2 = (Door.pt05.y < Door.pt08.y)
  if (RadCheck1) and (RadCheck2) and (WidthCheck) and (HeightCheck) and (SegCheck) and (LegCheck1) and (LegCheck2) then
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
    if  (LegCheck1) and (LegCheck2) then
      DrawBox(Door.pt05, Door.pt06, Door.pt07, Door.pt08, Door.LayerIFrame)
    else
      DrawLine(Door.ptL, Door.ptR, Door.LayerFlutes)
    end --if end
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
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
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Fluting")
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
    if (1.0 < fltCount) and (LegCheck1) then
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
      LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
    end -- if end
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
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
      LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
    end -- if end
  else
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the inter panel")
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
    LogWriter("Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Vertical Fluting")
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
    local LineCheck = true
    if (1.0 < ArcCount) then
      while (ArcCount > 0) and (LineCheck) do
        LineCheck = (Polar2D(CHT, 0.0, Hdis - Hchord).x)  > (Polar2D(CHT, 180.0, Hdis - Hchord ).x)
        DrawLine(Polar2D(CHT, 0.0, Hdis - Hchord), Polar2D(CHT, 180.0, Hdis - Hchord ), Door.LayerFlutes)
        DrawLine(Polar2D(CHB, 0.0, Hdis - Hchord), Polar2D(CHB, 180.0, Hdis - Hchord), Door.LayerFlutes)
        CHT = Polar2D(CHT,   90.0, StyleG.FluteSpacing) -- Right
        CHB = Polar2D(CHB,  270.0, StyleG.FluteSpacing) -- Left
        Hchord = RadSeg2Chord(Rad, (Rad - GetDistance(CHT, ptTc))) * 0.5 - Door.BitRad
        ArcCount = ArcCount - 1
      end -- while end
    end -- if end
  else
    LogWriter( "Error - Door: " .. Dubble2String(Door.Height) .. " X " .. Dubble2String(Door.Width) .. " Failed to Draw the Horizontal Fluting")
  end -- if end
  return true
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
    file:write("1,04.5000,23.2500\n");  file:write("1,06.0000,03.3125\n");  file:write("1,06.5000,15.5000\n");  file:write("1,05.3750,19.5000\n");
    file:write("1,07.1875,17.5000\n");  file:write("1,06.1875,23.5000\n");  file:write("2,07.8750,03.8750\n");  file:write("3,09.8750,05.0000\n");
    file:write("1,11.7500,05.8750\n");  file:write("2,13.7500,06.6750\n");  file:write("3,15.7500,07.8750\n");  file:write("1,17.1250,08.8250\n");
    file:write("2,19.5000,09.5000\n");  file:write("3,21.1250,10.3750\n");  file:write("1,23.6250,11.1250\n");  file:write("2,25.5000,12.1250\n");
    file:write("3,27.6250,13.7500\n");  file:write("1,29.5000,14.7500\n");  file:write("2,31.4375,15.7500\n");  file:write("3,33.4375,16.7500\n");
    file:write("1,35.4375,17.7500\n");  file:write("2,37.4375,18.6250\n");  file:write("3,39.3750,19.6250\n");  file:write("1,41.3750,20.6250\n");
    file:write("2,43.3750,21.6250\n");  file:write("3,45.1875,22.6250\n");  file:write("1,47.2500,23.6250\n");  file:write("2,49.1875,24.6250\n");
    file:write("3,51.1250,25.5000\n");  file:write("1,53.1250,26.5000\n");  file:write("2,55.1250,27.5000\n");  file:write("3,57.1250,28.5000\n");
    file:write("1,59.1250,29.5000\n");  file:write("2,61.2500,30.5000\n");  file:write("3,62.9375,31.4375\n");  file:write("1,64.9375,32.4375\n");
    file:write("2,66.9375,33.4375\n");  file:write("3,68.8125,34.4375\n");  file:write("1,70.8750,35.3750\n");  file:write("2,72.9375,36.4375\n");
    file:write("3,74.8750,37.4375\n");  file:write("1,76.9375,38.3750\n");  file:write("2,78.7500,39.3750\n");  file:write("3,80.7500,40.3750\n");
    file:write("1,82.6250,41.3750\n");  file:write("2,84.6250,42.3750\n");  file:write("3,86.6250,43.3750\n");  file:write("1,88.5000,44.2500\n");
    file:write("2,90.6250,45.2500\n");  file:write("3,92.6250,46.2500\n");  file:write("1,94.4375,47.2500\n");  file:write("2,95.4375,48.2500\n")
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
function main(script_path)
  Door.job = VectricJob()
  if not Door.job.Exists then
    DisplayMessageBox("Error: This Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end
  Tools = assert(loadfile(script_path .. "\\SubFunction.lua")) (Tools)
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
