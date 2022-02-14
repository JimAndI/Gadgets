-- VECTRIC LUA SCRIPT
-- ==============================================================================
--  Gadgets are an entirely optional add-in to Vectric's core software products.
--  They are provided 'as-is', without any express or implied warranty, and you
--  make use of them entirely at your own risk.
--  In no event will the author(s) or Vectric Ltd. be held liable for any damages
--  arising from their use.
--  Permission is granted to anyone to use this software for any purpose,
--  including commercial applications, and to alter it and redistribute it freely,
--  subject to the following restrictions:
--  1. The origin of this software must not be misrepresented;
--     you must not claim that you wrote the original software.
--     If you use this software in a product, an acknowledgement in the product
--     documentation would be appreciated but is not required.
--  2. Altered source versions must be plainly marked as such, and
--     must not be misrepresented as being the original software.
--  3. This notice may not be removed or altered from any source distribution.
-- ==============================================================================
-- MDF Door Maker Gadget was written by JimAndi Gadgets 2021
-- Version Beta A - June 17, 2021
-- Version 1.0    - July  2, 2021
-- Version 2.0    - July  4, 2021
-- Version 3.0    - July  5, 2021
-- Version 4.0    - July  7, 2021
-- Version 5.0    - July  8, 2021  -- Error traps
-- Version 6.0    - July 10, 2021  -- Added BitOffset for Fluting
-- Version 7.0    - July 11, 2021  -- Fix Help File
-- Version 8.0    - July 12, 2021  -- Fixed Errors found in Arched Door
-- Version 9.0    - July 17, 2021  -- Rewrite code to use Door table as all points for door construction
-- Version 10.0   - July 19, 2021  -- Bug fix
-- Version 10.1   - July 20, 2021  -- Bug fix
-- Version 10.5   - Feb  11, 2022  -- Sribe Line Point Change
-- Version 10.6   - Feb  12, 2022  -- Added Raised Panel Milling
-- ====================================================]]
-- Global variables
require("mobdebug").start()
--require "strict"
local Version       = 10.6
local VerNumber     = tostring(Version)
      AppName       = "Easy MDF Door Maker"
      RegName       = "EasyMDFDoorMaker"  .. VerNumber
--  Table Names
local Project       = {}
      Door          = {}
      Milling       = {}
      Panel         = {}
      DialogWindow  = {}   -- Dialog Management
local StyleA        = {}
local StyleB        = {}
local StyleC        = {}
local StyleE        = {}
local StyleF        = {}
local StyleG        = {}
local Tools1, Tools2, Tools3
local dialog
local MyProgressBar
Tool_ID1 = ToolDBId()
Tool_ID2 = ToolDBId()
Tool_ID3 = ToolDBId()
Tool_ID4 = ToolDBId()
Tool_ID5 = ToolDBId()
Tool_ID6 = ToolDBId()
Tool_ID7 = ToolDBId()
Tool_ID8 = ToolDBId()
Tool_ID9 = ToolDBId()
--[[
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
Tool_ID3:LoadDefaults("My Toolpath3", "")
Tool_ID4:LoadDefaults("My Toolpath4", "")
Tool_ID5:LoadDefaults("My Toolpath5", "")
Tool_ID6:LoadDefaults("My Toolpath6", "")
Tool_ID7:LoadDefaults("My Toolpath7", "")
Tool_ID8:LoadDefaults("My Toolpath8", "")
Tool_ID9:LoadDefaults("My Toolpath9", "")
]]
Door.Style          = ""
Door.Height         = 0.0
Door.Width          = 0.0
Door.Row            = 0.0
Door.RowCount       = 1
Door.Records        = 1
Door.pt01 = Point2D(0,0)
DialogWindow.ProjectSDK  = "http://www.jimandi.com/EasyGadgets/EasyMDFDoorMaker/EasyMDFDoorMakerHelp.html"
Milling.MillTool1 = {} -- Profile Bit
Milling.MillTool2 = {} -- Pocketing Bit
Milling.MillTool3 = {} -- Pocketing Clearing Bit
Milling.MillTool4 = {} -- Panel Forming Bit
Milling.MillTool5 = {} -- Inside Edge
Milling.MillTool6 = {} -- Outside Edge
Milling.MillTool7 = {} -- Scribe Lines
Milling.MillTool8 = {} -- Corner Cleaning
Milling.MillTool9 = {} -- Fluting Bit
Milling.Tabs = false   -- User to setup Tabs
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
  Door.ptR  = Polar2D(Door.CTR,    0.0, Door.WidthH  - (StyleA.A + Door.BitRad)) -- Right
  Door.ptL  = Polar2D(Door.CTR,  180.0, Door.WidthH  - (StyleA.A + Door.BitRad)) -- Left
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
  Door.pt05A = Polar2D(Door.pt05, 270.0, StyleA.B + Door.OverCut)
  Door.pt06A = Polar2D(Door.pt06, 270.0, StyleA.B + Door.OverCut)
  Door.pt07A = Polar2D(Door.pt07,  90.0, StyleA.B + Door.OverCut)
  Door.pt08A = Polar2D(Door.pt08,  90.0, StyleA.B + Door.OverCut)
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
    if Door.ScribeLines == "Yes" then
      DrawLine(Door.pt05, Door.pt05A, Door.LayerScribeLines)
      DrawLine(Door.pt06A, Door.pt06, Door.LayerScribeLines)
      DrawLine(Door.pt07, Door.pt07A, Door.LayerScribeLines)
      DrawLine(Door.pt08A, Door.pt08, Door.LayerScribeLines)
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
  Door.pt05A = Polar2D(Door.pt05, 270.0, StyleB.C + Door.OverCut)
  Door.pt06A = Polar2D(Door.pt06, 270.0, StyleB.C + Door.OverCut)
  Door.pt07A = Polar2D(Door.pt07,  90.0, StyleB.B + Door.OverCut)
  Door.pt10A = Polar2D(Door.pt10,  90.0, StyleB.B + Door.OverCut)
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
    if Door.ScribeLines == "Yes" then
      DrawLine(Door.pt05, Door.pt05A, Door.LayerScribeLines)
      DrawLine(Door.pt06A, Door.pt06, Door.LayerScribeLines)
      DrawLine(Door.pt07, Door.pt07A, Door.LayerScribeLines)
      DrawLine(Door.pt10A, Door.pt10, Door.LayerScribeLines)
    end -- if end
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
  Door.pt05A = Polar2D(Door.pt05, 270.0, StyleC.B + Door.OverCut)
  Door.pt06A = Polar2D(Door.pt06, 270.0, StyleC.B + Door.OverCut)
  Door.pt07A = Polar2D(Door.pt07,  90.0, StyleC.B + Door.OverCut)
  Door.pt10A = Polar2D(Door.pt10,  90.0, StyleC.B + Door.OverCut)
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
    if Door.ScribeLines == "Yes" then
      DrawLine(Door.pt05, Door.pt05A, Door.LayerScribeLines)
      DrawLine(Door.pt06A, Door.pt06, Door.LayerScribeLines)
      DrawLine(Door.pt07, Door.pt07A, Door.LayerScribeLines)
      DrawLine(Door.pt10A, Door.pt10, Door.LayerScribeLines)
    end -- if end
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
  Door.pt05A = Polar2D(Door.pt05, 270.0, StyleE.C + Door.OverCut)
  Door.pt06A = Polar2D(Door.pt06, 270.0, StyleE.C + Door.OverCut)
  Door.pt07A = Polar2D(Door.pt07,  90.0, StyleE.B + Door.OverCut)
  Door.pt08A = Polar2D(Door.pt08,  90.0, StyleE.B + Door.OverCut)
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
    if Door.ScribeLines == "Yes" then
      DrawLine(Door.pt05, Door.pt05A, Door.LayerScribeLines)
      DrawLine(Door.pt06A, Door.pt06, Door.LayerScribeLines)
      DrawLine(Door.pt07, Door.pt07A, Door.LayerScribeLines)
      DrawLine(Door.pt08A, Door.pt08, Door.LayerScribeLines)
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
  Door.pt05A = Polar2D(Door.pt05, 270.0, StyleF.B + Door.OverCut)
  Door.pt06A = Polar2D(Door.pt06, 270.0, StyleF.B + Door.OverCut)
  Door.pt07A = Polar2D(Door.pt07,  90.0, StyleF.B + Door.OverCut)
  Door.pt08A = Polar2D(Door.pt08,  90.0, StyleF.B + Door.OverCut)
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
    if Door.ScribeLines == "Yes" then
      DrawLine(Door.pt05, Door.pt05A, Door.LayerScribeLines)
      DrawLine(Door.pt06A, Door.pt06, Door.LayerScribeLines)
      DrawLine(Door.pt07, Door.pt07A, Door.LayerScribeLines)
      DrawLine(Door.pt08A, Door.pt08, Door.LayerScribeLines)
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
  local pt05A = Polar2D(pt12, 270.0, StyleG.B + StyleG.C + Door.OverCut)
  local pt06A = Polar2D(pt7, 270.0, StyleG.B + StyleG.C + Door.OverCut)
  local pt07A = Polar2D(pt11,  90.0, StyleG.B + StyleG.C + Door.OverCut)
  local pt08A = Polar2D(pt8,  90.0, StyleG.B + StyleG.C + Door.OverCut)
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
      if Door.ScribeLines == "Yes" then
        DrawLine(pt12, pt05A, Door.LayerScribeLines)
        DrawLine(pt06A, pt7, Door.LayerScribeLines)
        DrawLine(pt8, pt08A, Door.LayerScribeLines)
        DrawLine(pt07A, pt11,  Door.LayerScribeLines)
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
      CHR = Polar2D(CHR,      0.0, StyleG.FluteSpacing) -- Right
      CHL = Polar2D(CHL,    180.0, StyleG.FluteSpacing) -- Left
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
        DrawLine(Polar2D(CHR, 90.0, Vdis - Hchord), Polar2D(CHR, 270.0, Vdis - Hchord ), Door.LayerFlutes)
        DrawLine(Polar2D(CHL, 90.0, Vdis - Hchord), Polar2D(CHL, 270.0, Vdis - Hchord),  Door.LayerFlutes)
        CHR = Polar2D(CHR,     0.0, StyleG.FluteSpacing) -- Right
        CHL = Polar2D(CHL,   180.0, StyleG.FluteSpacing) -- Left
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
  local ptX  = Polar2D(pt1,    0.0, Door.Width * 0.5) -- Bottom
  local CTR  = Polar2D(ptX,   90.0, Door.Height * 0.5) -- Door Center
  local ptT  = Polar2D(CTR,   90.0, (Door.Height * 0.5) - (StyleG.B + Door.BitRad)) -- Top
  local ptB  = Polar2D(CTR,  270.0, (Door.Height * 0.5) - (StyleG.B + Door.BitRad)) -- Bottom
  local ptR  = Polar2D(CTR,    0.0, (Door.Width * 0.5)  - (StyleG.A + Door.BitRad)) -- Right
  local ptL  = Polar2D(CTR,  180.0, (Door.Width * 0.5)  - (StyleG.A + Door.BitRad)) -- Left
  local ptTc = Polar2D(ptT,  90.0, Door.BitRad) -- Top Rad Ctr
  local ptBc = Polar2D(ptB, 270.0, Door.BitRad) -- Bottom Rad Ctr
  local ptRc = Polar2D(ptR,   0.0, Door.BitRad) -- Right Rad Ctr
  local ptLc = Polar2D(ptL, 180.0, Door.BitRad) -- Left Rad Ctr
  local CHR  = Polar2D(CTR,    0.0, StyleG.FluteSpacing) -- Left
  local CHT  = Polar2D(CTR,   90.0, StyleG.FluteSpacing) -- Top
  local CHL  = Polar2D(CTR,  180.0, StyleG.FluteSpacing) -- Left
  local CHB  = Polar2D(CTR,  270.0, StyleG.FluteSpacing) -- Bottom
  local Adj  = Rad - math.sqrt(Rad^2 - Door.BitRad^2)
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
        DrawLine(Polar2D(CHB, 0.0, Hdis - Hchord), Polar2D(CHB, 180.0, Hdis - Hchord),  Door.LayerFlutes)
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
  local dialog = HTML_Dialog(true, DialogWindow.Main, 535, 614, "Easy MDF Door Maker Ver(" .. Version .. ") " .. Door.Units)
  Door.Alert = ""
  if Door.Count == 0 then Door.Count = 1 end
  Door.RuntimeLog = "CSVImportErrorLog" .. StartDateTime(false)
  dialog:AddLabelField("Door.Alert", Door.Alert)
  dialog:AddDropDownList("DoorStyle", Door.Style)
  dialog:AddDropDownList("Door.ScribeLines",  Door.ScribeLines)
  dialog:AddDropDownListValue("DoorStyle", StyleA.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleB.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleC.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleE.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleF.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleG.Name)
  dialog:AddLabelField("ReadFile", Door.CSVFile)
  dialog:AddIntegerField("Door.Count", Door.Count)
  dialog:AddDoubleField("Door.X", Door.X)
  dialog:AddDoubleField("Door.Y", Door.Y)
  dialog:AddDoubleField("Door.Width", Door.Width)
  dialog:AddDoubleField("Door.Height", Door.Height)
  dialog:AddFilePicker(true, "FilePicker", "ReadFile", false)
  dialog:AddLabelField("ToolNameLabel1",                      Milling.MillTool1.Name) -- Profile Bit
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel2",                      Milling.MillTool2.Name) -- Pocket Bit
  dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
  dialog:AddToolPickerValidToolType("ToolChooseButton2",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel3",                      Milling.MillTool3.Name) -- Pocket Clearing Bit
  dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton3",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel4",                      Milling.MillTool4.Name) -- Raised Panel Bit
  dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID4)
  dialog:AddToolPickerValidToolType("ToolChooseButton4",      Tool.BALL_NOSE)
  dialog:AddLabelField("ToolNameLabel5",                      Milling.MillTool5.Name) -- Inside Edge Bit
  dialog:AddToolPicker("ToolChooseButton5", "ToolNameLabel5", Tool_ID5)
  dialog:AddToolPickerValidToolType("ToolChooseButton5",      Tool.FORM_TOOL)
  dialog:AddLabelField("ToolNameLabel6",                      Milling.MillTool6.Name) -- Outside Edge Bit
  dialog:AddToolPicker("ToolChooseButton6", "ToolNameLabel6", Tool_ID6)
  dialog:AddToolPickerValidToolType("ToolChooseButton6",      Tool.FORM_TOOL)
  dialog:AddLabelField("ToolNameLabel7",                      Milling.MillTool7.Name) -- Scribe Lines Bit
  dialog:AddToolPicker("ToolChooseButton7", "ToolNameLabel7", Tool_ID7)
  dialog:AddToolPickerValidToolType("ToolChooseButton7",      Tool.FORM_TOOL)
  dialog:AddLabelField("ToolNameLabel8",                      Milling.MillTool8.Name) -- Corner Cleaning Bit
  dialog:AddToolPicker("ToolChooseButton8", "ToolNameLabel8", Tool_ID8)
  dialog:AddToolPickerValidToolType("ToolChooseButton8",      Tool.BALL_NOSE)
  dialog:AddLabelField("ToolNameLabel9",                      Milling.MillTool9.Name) -- Fluting Bit
  dialog:AddToolPicker("ToolChooseButton9", "ToolNameLabel9", Tool_ID9)
  dialog:AddToolPickerValidToolType("ToolChooseButton9",      Tool.BALL_NOSE)
  dialog:ShowDialog()
  if dialog:GetTool("ToolChooseButton1") then
    Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile Bit
  end
  if dialog:GetTool("ToolChooseButton2") then
    Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Pocket Bit
  end
  if dialog:GetTool("ToolChooseButton3") then
    Milling.MillTool3 = dialog:GetTool("ToolChooseButton3")  -- Pocket Clearing Bit
  end
  if dialog:GetTool("ToolChooseButton4") then
    Milling.MillTool4 = dialog:GetTool("ToolChooseButton4")  -- Raised Panel Bit
  end
  if dialog:GetTool("ToolChooseButton5") then
    Milling.MillTool5 = dialog:GetTool("ToolChooseButton5")  -- Inside Edge Bit
  end
  if dialog:GetTool("ToolChooseButton6") then
    Milling.MillTool6 = dialog:GetTool("ToolChooseButton6")  -- Outside Edge Bit
  end
  if dialog:GetTool("ToolChooseButton7") then
    Milling.MillTool7 = dialog:GetTool("ToolChooseButton7")  -- Scribe Lines Bit
  end
  if dialog:GetTool("ToolChooseButton8") then
    Milling.MillTool8 = dialog:GetTool("ToolChooseButton8")  -- Corner Cleaning Bit
  end
  if dialog:GetTool("ToolChooseButton9") then
    Milling.MillTool0 = dialog:GetTool("ToolChooseButton9")  -- Fluting Bit
  end
  Door.Style = dialog:GetDropDownListValue("DoorStyle")
  DialogWindow.MainXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
  Door.CSVFile = dialog:GetLabelField("ReadFile")
  Door.CSVPath =  string.sub(Door.CSVFile,1, (string.len(Door.CSVFile) - string.len(GetFilename(Door.CSVFile))))
  Door.ScribeLines = dialog:GetDropDownListValue("Door.ScribeLines")
  RegistryWrite()
  return false
end
-- =====================================================]]
function OnLuaButton_InquiryToolClear(Pdialog)
  Milling.MillTool1.Name = "No Tool Selected"
  Milling.MillTool2.Name = "No Tool Selected"
  Milling.MillTool3.Name = "No Tool Selected"
  Milling.MillTool4.Name = "No Tool Selected"
  Milling.MillTool5.Name = "No Tool Selected"
  Milling.MillTool6.Name = "No Tool Selected"
  Milling.MillTool7.Name = "No Tool Selected"
  Milling.MillTool8.Name = "No Tool Selected"
  Milling.MillTool9.Name = "No Tool Selected"
  Pdialog:UpdateLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  Pdialog:UpdateLabelField("ToolNameLabel2", Milling.MillTool2.Name)
  Pdialog:UpdateLabelField("ToolNameLabel3", Milling.MillTool3.Name)
  Pdialog:UpdateLabelField("ToolNameLabel4", Milling.MillTool4.Name)
  Pdialog:UpdateLabelField("ToolNameLabel5", Milling.MillTool5.Name)
  Pdialog:UpdateLabelField("ToolNameLabel6", Milling.MillTool6.Name)
  Pdialog:UpdateLabelField("ToolNameLabel7", Milling.MillTool7.Name)
  Pdialog:UpdateLabelField("ToolNameLabel8", Milling.MillTool8.Name)
  Pdialog:UpdateLabelField("ToolNameLabel9", Milling.MillTool9.Name)
  RegistryWrite()
  return true
end -- function end

-- ====================================================]]
function InquirySave(Pdialog)

  if Pdialog:GetTool("ToolChooseButton1") then
    Milling.MillTool1 = Pdialog:GetTool("ToolChooseButton1")  -- Profile Bit
  end
  if Pdialog:GetTool("ToolChooseButton2") then
    Milling.MillTool2 = Pdialog:GetTool("ToolChooseButton2")  -- Pocket Bit
  end
  if Pdialog:GetTool("ToolChooseButton3") then
    Milling.MillTool3 = Pdialog:GetTool("ToolChooseButton3")  -- Pocket Clearing Bit
  end
  if Pdialog:GetTool("ToolChooseButton4") then
    Milling.MillTool4 = Pdialog:GetTool("ToolChooseButton4")  -- Raised Panel Bit
  end
  if Pdialog:GetTool("ToolChooseButton5") then
    Milling.MillTool5 = Pdialog:GetTool("ToolChooseButton5")  -- Inside Edge Bit
  end
  if Pdialog:GetTool("ToolChooseButton6") then
    Milling.MillTool6 = Pdialog:GetTool("ToolChooseButton6")  -- Outside Edge Bit
  end
  if Pdialog:GetTool("ToolChooseButton7") then
    Milling.MillTool7 = Pdialog:GetTool("ToolChooseButton7")  -- Scribe Lines Bit
  end
  if Pdialog:GetTool("ToolChooseButton8") then
    Milling.MillTool8 = Pdialog:GetTool("ToolChooseButton8")  -- Corner Cleaning Bit
  end
  return true
end -- function end
-- ====================================================]]
function OnLuaButton_MakeCSV(Pdialog)
  Door.CSVPath = Pdialog:GetTextField("DoorCSVPath")
  Door.ScribeLines = Pdialog:GetDropDownListValue("Door.ScribeLines")
  local filename = Door.CSVPath .. "\\DoorTest.csv"
  local file = io.open(filename, "w")
  file:write("Count,Height,Width\n")
  if Door.Unit then
    file:write("1,110,595\n");          file:write("1,150,75\n");           file:write("1,175,395\n");          file:write("1,140,495\n");
    file:write("1,175,445\n");          file:write("1,175,595\n");          file:write("2,200,100\n");          file:write("3,250,125\n");
    file:write("1,300,150\n");          file:write("2,350,175\n");          file:write("3,400,200\n");          file:write("1,450,225\n");
    file:write("2,500,250\n");          file:write("3,550,275\n");          file:write("1,600,300\n");          file:write("2,650,325\n");
    file:write("3,700,350\n");          file:write("1,750,375\n");          file:write("2,800,400\n");          file:write("3,850,425\n");
    file:write("1,900,450\n");          file:write("2,950,475\n");          file:write("3,1000,500\n");         file:write("1,1050,525\n");
    file:write("2,1100,550\n");         file:write("3,1150,575\n");         file:write("1,1200,600\n");         file:write("2,1250,625\n");
    file:write("3,1300,650\n");         file:write("1,1350,675\n");         file:write("2,1400,700\n");         file:write("3,1450,725\n");
    file:write("1,1500,750\n");         file:write("2,1550,775\n");         file:write("3,1600,800\n");         file:write("1,1650,825\n");
    file:write("2,1700,850\n");         file:write("3,1750,875\n");         file:write("1,1800,900\n");         file:write("2,1850,925\n");
    file:write("3,1900,950\n");         file:write("1,1950,975\n");         file:write("2,2000,1000\n");        file:write("3,2050,1025\n");
    file:write("1,2100,1050\n");        file:write("2,2150,1075\n");        file:write("3,2200,1100\n");        file:write("1,2250,1125\n");
    file:write("2,2300,1150\n");        file:write("3,2350,1175\n");        file:write("1,2400,1200\n");        file:write("2,2450,1225\n")
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
    file:write("2,90.6250,45.2500\n");  file:write("3,92.6250,46.2500\n");  file:write("1,94.4375,47.2500\n");  file:write("2,95.4375,48.2500\n");
  end -- if end
  file:close()-- closes the open file
  RegistryWrite()
  DisplayMessageBox("The File: "..filename.." is complete.")
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 848, 451, "About")
  dialog:AddLabelField("SysName", AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  RegistryWrite()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryPanel()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml3, 846, 472, "Panel Milling Setup")

  dialog:AddDoubleField("Panel.ARadius", Panel.ARadius)
  dialog:AddDoubleField("Panel.BRadius", Panel.BRadius)
  dialog:AddDoubleField("Panel.CRadius", Panel.CRadius)
  dialog:AddDoubleField("Panel.DWidth",  Panel.DWidth)
  dialog:AddDoubleField("Panel.EDepth",  Panel.EDepth)

  if dialog:ShowDialog() then
    Panel.ARadius = math.abs(dialog:GetDoubleField("Panel.ARadius"))
    Panel.BRadius = math.abs(dialog:GetDoubleField("Panel.BRadius"))
    Panel.CRadius = math.abs(dialog:GetDoubleField("Panel.CRadius"))
    Panel.DWidth = math.abs(dialog:GetDoubleField("Panel.DWidth"))
    Panel.EDepth = math.abs(dialog:GetDoubleField("Panel.EDepth"))
    DialogWindow.PanelXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    RegistryWrite()
  end -- If end
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryStyle(Pdialog)
  Door.Style = Pdialog:GetDropDownListValue("DoorStyle")
  Door.ScribeLines = Pdialog:GetDropDownListValue("Door.ScribeLines")
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
    Pdialog:UpdateLabelField("Door.Alert", ErrorText)
  end -- if end
  RegistryWrite()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryRunCSV(Pdialog)
    InquirySave(Pdialog)
    Door.CSVFile = dialog:GetLabelField("ReadFile")
    Door.ScribeLines = dialog:GetDropDownListValue("Door.ScribeLines")
    Door.CSVPath =  string.sub(Door.CSVFile,1, (string.len(Door.CSVFile) - string.len(GetFilename(Door.CSVFile))))
  if string.find(Door.CSVFile, ".csv") then
    RegistryWrite()
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
function OnLuaButton_InquiryDefault(Pdialog)
  local ErrorText = ""
  local dialog = HTML_Dialog(true, DialogWindow.myHtml1, 632, 430, "Default Settings " .. Door.Units)
  dialog:AddLabelField("Door.Alert",      Door.Alert)
  dialog:AddDoubleField("Door.Spacing",   Door.Spacing)
  dialog:AddDoubleField("Door.MaxWide",   Door.MaxWide)
  dialog:AddDoubleField("Door.BitRad",    Door.BitRad)
  dialog:AddDoubleField("Door.OverCut",   Door.OverCut)
  dialog:AddTextField("Door.LayerOFrame", Door.LayerOFrame)
  dialog:AddTextField("Door.LayerIFrame", Door.LayerIFrame)
  dialog:AddTextField("Door.LayerFlutes", Door.LayerFlutes)
  dialog:AddTextField("Door.LayerScribeLines", Door.LayerScribeLines)
  dialog:AddDropDownList("Door.ScribeLines",  Door.ScribeLines)
  dialog:AddTextField("DoorCSVPath", Door.CSVPath )
  dialog:AddDirectoryPicker("DirectoryPicker", "DoorCSVPath",  true)
  if dialog:ShowDialog() then
    DialogWindow.DefaultXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    Door.Spacing           = math.abs(dialog:GetDoubleField("Door.Spacing"))
    Door.MaxWide           = math.abs(dialog:GetDoubleField("Door.MaxWide"))
    Door.BitRad            = math.abs(dialog:GetDoubleField("Door.BitRad"))
    Door.OverCut           = math.abs(dialog:GetDoubleField("Door.OverCut"))
    Door.LayerOFrame       = dialog:GetTextField("Door.LayerOFrame")
    Door.LayerIFrame       = dialog:GetTextField("Door.LayerIFrame")
    Door.LayerFlutes       = dialog:GetTextField("Door.LayerFlutes")
    Door.LayerScribeLines  = dialog:GetTextField("Door.LayerScribeLines")
    Door.ScribeLines       = dialog:GetDropDownListValue("Door.ScribeLines")
    if All_Trim(Door.LayerOFrame) == "" then ErrorText = "Error: The Outer Frame, Layer Name cannot be blank" end
    if All_Trim(Door.LayerIFrame) == "" then ErrorText = "Error: The Inter Frame, Layer Name cannot be blank" end
    if All_Trim(Door.LayerFlutes) == "" then ErrorText = "Error: The Flute Layer Name, cannot be blank" end
    dialog:UpdateLabelField("Door.Alert", ErrorText)
    RegistryWrite()
  end -- if end
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryMakeDoor(Pdialog)
  local runit = true
  InquirySave(Pdialog)
  Door.ScribeLines = Pdialog:GetDropDownListValue("Door.ScribeLines")
  Door.Style = Pdialog:GetDropDownListValue("DoorStyle")
  Door.Count = Pdialog:GetIntegerField("Door.Count")
  Door.Width = Pdialog:GetDoubleField("Door.Width")
  Door.Height = Pdialog:GetDoubleField("Door.Height")
  Door.X = Pdialog:GetDoubleField("Door.X")
  Door.Y = Pdialog:GetDoubleField("Door.Y")
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
    Pdialog:UpdateDoubleField("Door.Y", Door.Y)
    Pdialog:UpdateDoubleField("Door.X", Door.X)
  end -- end if
  RegistryWrite()
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
function RegistryRead()                                -- Read from Registry values
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
  Door.LayerScribeLines         = RegistryRead:GetString("Door.LayerScribeLines",        "Door Scribe Lines")
  Door.ScribeLines              = RegistryRead:GetString("Door.ScribeLines",             "No")
  Door.Fluting                  = RegistryRead:GetString("Door.Fluting",                 "None")
  Door.OverCut                  = RegistryRead:GetDouble("Door.OverCut",                 0.250)

  Panel.ARadius                 = RegistryRead:GetDouble("Panel.ARadius",                1.2500)
  Panel.BRadius                 = RegistryRead:GetDouble("Panel.BRadius",                0.2500)
  Panel.CRadius                 = RegistryRead:GetDouble("Panel.CRadius",                0.1250)
  Panel.DWidth                  = RegistryRead:GetDouble("Panel.DWidth",                 2.1250)
  Panel.EDepth                  = RegistryRead:GetDouble("Panel.EDepth",                 0.3750)

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
  Milling.MillTool1.FeedRate                = RegistryRead:GetDouble("Milling.MillTool1.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool1.InMM                    = RegistryRead:GetBool("Milling.MillTool1.InMM ",                   false)
  Milling.MillTool1.Name                    = RegistryRead:GetString("Milling.MillTool1.Name",                  "No Tool Selected")
  Milling.MillTool1.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool1.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool1.RateUnits               = RegistryRead:GetInt("Milling.MillTool1.RateUnits",                4)
  Milling.MillTool1.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool1.SpindleSpeed",             20000)
  Milling.MillTool1.Stepdown                = RegistryRead:GetDouble("Milling.MillTool1.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool1.Stepover                = RegistryRead:GetDouble("Milling.MillTool1.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool1.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool1.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool1.ToolNumber              = RegistryRead:GetInt("Milling.MillTool1.ToolNumber",               1)
  Milling.MillTool2.FeedRate                = RegistryRead:GetDouble("Milling.MillTool2.FeedRate",              60.000 * Door.Cal)
  Milling.MillTool2.InMM                    = RegistryRead:GetBool("Milling.MillTool2.InMM ",                   false)
  Milling.MillTool2.Name                    = RegistryRead:GetString("Milling.MillTool2.Name",                  "No Tool Selected")
  Milling.MillTool2.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool2.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool2.RateUnits               = RegistryRead:GetInt("Milling.MillTool2.RateUnits",                4)
  Milling.MillTool2.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool2.SpindleSpeed",             20000)
  Milling.MillTool2.Stepdown                = RegistryRead:GetDouble("Milling.MillTool2.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool2.Stepover                = RegistryRead:GetDouble("Milling.MillTool2.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool2.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool2.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool2.ToolNumber              = RegistryRead:GetInt("Milling.MillTool2.ToolNumber",               2)
  Milling.MillTool3.FeedRate                = RegistryRead:GetDouble("Milling.MillTool3.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool3.InMM                    = RegistryRead:GetBool("Milling.MillTool3.InMM ",                   false)
  Milling.MillTool3.Name                    = RegistryRead:GetString("Milling.MillTool3.Name",                  "No Tool Selected")
  Milling.MillTool3.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool3.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool3.RateUnits               = RegistryRead:GetInt("Milling.MillTool3.RateUnits",                4)
  Milling.MillTool3.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool3.SpindleSpeed",             18000)
  Milling.MillTool3.Stepdown                = RegistryRead:GetDouble("Milling.MillTool3.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool3.Stepover                = RegistryRead:GetDouble("Milling.MillTool3.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool3.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool3.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool3.ToolNumber              = RegistryRead:GetInt("Milling.MillTool3.ToolNumber",               3)
  Milling.MillTool4.FeedRate                = RegistryRead:GetDouble("Milling.MillTool4.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool4.InMM                    = RegistryRead:GetBool("Milling.MillTool4.InMM ",                   false)
  Milling.MillTool4.Name                    = RegistryRead:GetString("Milling.MillTool4.Name",                  "No Tool Selected")
  Milling.MillTool4.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool4.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool4.RateUnits               = RegistryRead:GetInt("Milling.MillTool4.RateUnits",                4)
  Milling.MillTool4.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool4.SpindleSpeed",             18000)
  Milling.MillTool4.Stepdown                = RegistryRead:GetDouble("Milling.MillTool4.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool4.Stepover                = RegistryRead:GetDouble("Milling.MillTool4.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool4.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool4.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool4.ToolNumber              = RegistryRead:GetInt("Milling.MillTool4.ToolNumber",               4)
  Milling.MillTool5.FeedRate                = RegistryRead:GetDouble("Milling.MillTool5.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool5.InMM                    = RegistryRead:GetBool("Milling.MillTool5.InMM ",                   false)
  Milling.MillTool5.Name                    = RegistryRead:GetString("Milling.MillTool5.Name",                  "No Tool Selected")
  Milling.MillTool5.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool5.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool5.RateUnits               = RegistryRead:GetInt("Milling.MillTool5.RateUnits",                4)
  Milling.MillTool5.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool5.SpindleSpeed",             18000)
  Milling.MillTool5.Stepdown                = RegistryRead:GetDouble("Milling.MillTool5.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool5.Stepover                = RegistryRead:GetDouble("Milling.MillTool5.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool5.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool5.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool5.ToolNumber              = RegistryRead:GetInt("Milling.MillTool5.ToolNumber",               5)
  Milling.MillTool6.FeedRate                = RegistryRead:GetDouble("Milling.MillTool6.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool6.InMM                    = RegistryRead:GetBool("Milling.MillTool6.InMM ",                   false)
  Milling.MillTool6.Name                    = RegistryRead:GetString("Milling.MillTool6.Name",                  "No Tool Selected")
  Milling.MillTool6.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool6.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool6.RateUnits               = RegistryRead:GetInt("Milling.MillTool6.RateUnits",                4)
  Milling.MillTool6.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool6.SpindleSpeed",             18000)
  Milling.MillTool6.Stepdown                = RegistryRead:GetDouble("Milling.MillTool6.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool6.Stepover                = RegistryRead:GetDouble("Milling.MillTool6.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool6.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool6.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool6.ToolNumber              = RegistryRead:GetInt("Milling.MillTool6.ToolNumber",               6)
  Milling.MillTool7.FeedRate                = RegistryRead:GetDouble("Milling.MillTool7.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool7.InMM                    = RegistryRead:GetBool("Milling.MillTool7.InMM ",                   false)
  Milling.MillTool7.Name                    = RegistryRead:GetString("Milling.MillTool7.Name",                  "No Tool Selected")
  Milling.MillTool7.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool7.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool7.RateUnits               = RegistryRead:GetInt("Milling.MillTool7.RateUnits",                4)
  Milling.MillTool7.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool7.SpindleSpeed",             18000)
  Milling.MillTool7.Stepdown                = RegistryRead:GetDouble("Milling.MillTool7.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool7.Stepover                = RegistryRead:GetDouble("Milling.MillTool7.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool7.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool7.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool7.ToolNumber              = RegistryRead:GetInt("Milling.MillTool7.ToolNumber",               7)

  Milling.MillTool8.FeedRate                = RegistryRead:GetDouble("Milling.MillTool8.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool8.InMM                    = RegistryRead:GetBool("Milling.MillTool8.InMM ",                   false)
  Milling.MillTool8.Name                    = RegistryRead:GetString("Milling.MillTool8.Name",                  "No Tool Selected")
  Milling.MillTool8.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool8.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool8.RateUnits               = RegistryRead:GetInt("Milling.MillTool8.RateUnits",                4)
  Milling.MillTool8.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool8.SpindleSpeed",             18000)
  Milling.MillTool8.Stepdown                = RegistryRead:GetDouble("Milling.MillTool8.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool8.Stepover                = RegistryRead:GetDouble("Milling.MillTool8.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool8.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool8.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool8.ToolNumber              = RegistryRead:GetInt("Milling.MillTool8.ToolNumber",               8)

  Milling.MillTool9.FeedRate                = RegistryRead:GetDouble("Milling.MillTool9.FeedRate",              30.000 * Door.Cal)
  Milling.MillTool9.InMM                    = RegistryRead:GetBool("Milling.MillTool9.InMM ",                   false)
  Milling.MillTool9.Name                    = RegistryRead:GetString("Milling.MillTool9.Name",                  "No Tool Selected")
  Milling.MillTool9.PlungeRate              = RegistryRead:GetDouble("Milling.MillTool9.PlungeRate",            15.000 * Door.Cal)
  Milling.MillTool9.RateUnits               = RegistryRead:GetInt("Milling.MillTool9RateUnits",                4)
  Milling.MillTool9.SpindleSpeed            = RegistryRead:GetInt("Milling.MillTool9.SpindleSpeed",             18000)
  Milling.MillTool9.Stepdown                = RegistryRead:GetDouble("Milling.MillTool9.Stepdown",              0.2000 * Door.Cal)
  Milling.MillTool9.Stepover                = RegistryRead:GetDouble("Milling.MillTool9.Stepover",              0.0825 * Door.Cal)
  Milling.MillTool9.ToolDia                 = RegistryRead:GetDouble("Milling.MillTool9.ToolDia",               0.1250 * Door.Cal)
  Milling.MillTool9.ToolNumber              = RegistryRead:GetInt("Milling.MillTool9.ToolNumber",               9)
  return true
end
-- ====================================================]]
function LogWriter(xText)
-- Writes new xText Line to a log file
  local LogName = Door.CSVPath .. "/" .. Door.RuntimeLog .. ".txt"
  local fileW = io.open(LogName,  "a")
  fileW:write(xText .. "\n")
  fileW:close()
  dialog:UpdateLabelField("Door.Alert", "Note: Errors are logged in the CSF file folder.")
  return true
end -- function end
-- ====================================================]]
function RegistryWrite()                              -- Write to Registry values
  local RegistryWriter = Registry(RegName)
  local RegValue = RegistryWriter:SetString("DialogWindow.HelpXY",               DialogWindow.HelpXY)
        RegValue = RegistryWriter:SetString("DialogWindow.AboutXY",              DialogWindow.AboutXY)
        RegValue = RegistryWriter:SetString("DialogWindow.MainXY",               DialogWindow.MainXY)
        RegValue = RegistryWriter:SetString("DialogWindow.DefaultXY",            DialogWindow.DefaultXY)
        RegValue = RegistryWriter:SetString("DialogWindow.StyleAXY",             DialogWindow.StyleAXY)
        RegValue = RegistryWriter:SetString("DialogWindow.StyleBXY",             DialogWindow.StyleBXY)
        RegValue = RegistryWriter:SetString("DialogWindow.StyleCXY",             DialogWindow.StyleCXY)
        RegValue = RegistryWriter:SetString("DialogWindow.StyleEXY",             DialogWindow.StyleEXY)
        RegValue = RegistryWriter:SetString("DialogWindow.StyleFXY",             DialogWindow.StyleFXY)
        RegValue = RegistryWriter:SetString("DialogWindow.StyleGXY",             DialogWindow.StyleGXY)
        RegValue = RegistryWriter:SetString("DialogWindow.PanelXY",              DialogWindow.PanelXY)
        RegValue = RegistryWriter:SetString("Project.ProgramCodeBy",             Project.ProgramCodeBy)
        RegValue = RegistryWriter:SetString("Project.ProgramName",               Project.ProgramName)
        RegValue = RegistryWriter:SetString("Project.ProgramVersion",            Project.ProgramVersion)
        RegValue = RegistryWriter:SetString("Door.CSVFile",                      Door.CSVFile)
        RegValue = RegistryWriter:SetString("Door.CSVPath",                      Door.CSVPath)
        RegValue = RegistryWriter:SetString("Door.LayerOFrame",                  Door.LayerOFrame)
        RegValue = RegistryWriter:SetString("Door.LayerIFrame",                  Door.LayerIFrame)
        RegValue = RegistryWriter:SetString("Door.LayerFlutes",                  Door.LayerFlutes)
        RegValue = RegistryWriter:SetString("Door.LayerScribeLines",             Door.LayerScribeLines)
        RegValue = RegistryWriter:SetString("Door.Fluting",                      Door.Fluting)
        RegValue = RegistryWriter:SetString("Door.ScribeLines",                  Door.ScribeLines)
        RegValue = RegistryWriter:SetInt("Door.MaxWide",                         Door.MaxWide)
        RegValue = RegistryWriter:SetInt("Door.Count",                           Door.Count)
        RegValue = RegistryWriter:SetDouble("Door.Height",                       Door.Height)
        RegValue = RegistryWriter:SetDouble("Door.Width",                        Door.Width)
        RegValue = RegistryWriter:SetDouble("Door.X",                            Door.X)
        RegValue = RegistryWriter:SetDouble("Door.Y",                            Door.Y)
        RegValue = RegistryWriter:SetDouble("Door.OverCut",                      Door.OverCut)
        RegValue = RegistryWriter:SetString("Door.Style",                        Door.Style)
        RegValue = RegistryWriter:SetDouble("Door.Spacing",                      Door.Spacing)

        RegValue = RegistryWriter:SetDouble("Panel.ARadius",                     Panel.ARadius)
        RegValue = RegistryWriter:SetDouble("Panel.BRadius",                     Panel.BRadius)
        RegValue = RegistryWriter:SetDouble("Panel.CRadius",                     Panel.CRadius)
        RegValue = RegistryWriter:SetDouble("Panel.DWidth",                      Panel.DWidth)
        RegValue = RegistryWriter:SetDouble("Panel.EDepth",                      Panel.EDepth)

        RegValue = RegistryWriter:SetString("StyleA.Fluting",                    StyleA.Fluting)
        RegValue = RegistryWriter:SetString("StyleB.Fluting",                    StyleB.Fluting)
        RegValue = RegistryWriter:SetString("StyleC.Fluting",                    StyleC.Fluting)
        RegValue = RegistryWriter:SetString("StyleE.Fluting",                    StyleE.Fluting)
        RegValue = RegistryWriter:SetString("StyleF.Fluting",                    StyleF.Fluting)
        RegValue = RegistryWriter:SetString("StyleG.Fluting",                    StyleG.Fluting)
        RegValue = RegistryWriter:SetDouble("StyleA.FluteSpacing",               StyleA.FluteSpacing)
        RegValue = RegistryWriter:SetDouble("StyleB.FluteSpacing",               StyleB.FluteSpacing)
        RegValue = RegistryWriter:SetDouble("StyleC.FluteSpacing",               StyleC.FluteSpacing)
        RegValue = RegistryWriter:SetDouble("StyleE.FluteSpacing",               StyleE.FluteSpacing)
        RegValue = RegistryWriter:SetDouble("StyleF.FluteSpacing",               StyleF.FluteSpacing)
        RegValue = RegistryWriter:SetDouble("StyleG.FluteSpacing",               StyleG.FluteSpacing)
        RegValue = RegistryWriter:SetDouble("Door.BitRad",                       Door.BitRad)
        RegValue = RegistryWriter:SetDouble("StyleA.A",                          StyleA.A)
        RegValue = RegistryWriter:SetDouble("StyleA.B",                          StyleA.B)
        RegValue = RegistryWriter:SetDouble("StyleB.A",                          StyleB.A)
        RegValue = RegistryWriter:SetDouble("StyleB.B",                          StyleB.B)
        RegValue = RegistryWriter:SetDouble("StyleB.C",                          StyleB.C)
        RegValue = RegistryWriter:SetDouble("StyleB.D",                          StyleB.D)
        RegValue = RegistryWriter:SetDouble("StyleC.A",                          StyleC.A)
        RegValue = RegistryWriter:SetDouble("StyleC.B",                          StyleC.B)
        RegValue = RegistryWriter:SetDouble("StyleC.C",                          StyleC.C)
        RegValue = RegistryWriter:SetDouble("StyleC.D",                          StyleC.D)
        RegValue = RegistryWriter:SetDouble("StyleE.A",                          StyleE.A)
        RegValue = RegistryWriter:SetDouble("StyleE.B",                          StyleE.B)
        RegValue = RegistryWriter:SetDouble("StyleE.C",                          StyleE.C)
        RegValue = RegistryWriter:SetDouble("StyleF.A",                          StyleF.A)
        RegValue = RegistryWriter:SetDouble("StyleF.B",                          StyleF.B)
        RegValue = RegistryWriter:SetDouble("StyleF.C",                          StyleF.C)
        RegValue = RegistryWriter:SetDouble("StyleG.A",                          StyleG.A)
        RegValue = RegistryWriter:SetDouble("StyleG.B",                          StyleG.B)
        RegValue = RegistryWriter:SetDouble("StyleG.C",                          StyleG.C)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool1.FeedRate" ,               Milling.MillTool1.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool1.InMM",                      Milling.MillTool1.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool1.Name",                    Milling.MillTool1.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool1.PlungeRate" ,             Milling.MillTool1.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool1.RateUnits",                  Milling.MillTool1.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool1.SpindleSpeed",               Milling.MillTool1.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool1.Stepdown" ,               Milling.MillTool1.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool1.Stepover" ,               Milling.MillTool1.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool1.ToolDia" ,                Milling.MillTool1.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool1.ToolNumber",                 Milling.MillTool1.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool2.FeedRate" ,               Milling.MillTool2.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool2.InMM",                      Milling.MillTool2.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool2.Name",                    Milling.MillTool2.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool2.PlungeRate" ,             Milling.MillTool2.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool2.RateUnits",                  Milling.MillTool2.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool2.SpindleSpeed",               Milling.MillTool2.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool2.Stepdown" ,               Milling.MillTool2.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool2.Stepover" ,               Milling.MillTool2.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool2.ToolDia" ,                Milling.MillTool2.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool2.ToolNumber",                 Milling.MillTool2.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool3.FeedRate" ,               Milling.MillTool3.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool3.InMM",                      Milling.MillTool3.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool3.Name",                    Milling.MillTool3.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool3.PlungeRate",              Milling.MillTool3.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool3.RateUnits",                  Milling.MillTool3.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool3.SpindleSpeed",               Milling.MillTool3.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool3.Stepdown" ,               Milling.MillTool3.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool3.Stepover" ,               Milling.MillTool3.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool3.ToolDia" ,                Milling.MillTool3.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool3.ToolNumber",                 Milling.MillTool3.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool4.FeedRate" ,               Milling.MillTool4.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool4.InMM",                      Milling.MillTool4.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool4.Name",                    Milling.MillTool4.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool4.PlungeRate" ,             Milling.MillTool4.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool4.RateUnits",                  Milling.MillTool4.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool4.SpindleSpeed",               Milling.MillTool4.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool4.Stepdown" ,               Milling.MillTool4.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool4.Stepover" ,               Milling.MillTool4.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool4.ToolDia" ,                Milling.MillTool4.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool4.ToolNumber",                 Milling.MillTool4.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool5.FeedRate" ,               Milling.MillTool5.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool5.InMM",                      Milling.MillTool5.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool5.Name",                    Milling.MillTool5.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool5.PlungeRate" ,             Milling.MillTool5.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool5.RateUnits",                  Milling.MillTool5.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool5.SpindleSpeed",               Milling.MillTool5.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool5.Stepdown",                Milling.MillTool5.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool5.Stepover",                Milling.MillTool5.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool5.ToolDia",                 Milling.MillTool5.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool5.ToolNumber",                 Milling.MillTool5.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool6.FeedRate",                Milling.MillTool6.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool6.InMM",                      Milling.MillTool6.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool6.Name",                    Milling.MillTool6.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool6.PlungeRate",              Milling.MillTool6.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool6.RateUnits",                  Milling.MillTool6.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool6.SpindleSpeed",               Milling.MillTool6.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool6.Stepdown",                Milling.MillTool6.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool6.Stepover",                Milling.MillTool6.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool6.ToolDia",                 Milling.MillTool6.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool6.ToolNumber",                 Milling.MillTool6.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool7.FeedRate",                Milling.MillTool7.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool7.InMM",                      Milling.MillTool7.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool7.Name",                    Milling.MillTool7.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool7.PlungeRate",              Milling.MillTool7.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool7.RateUnits",                  Milling.MillTool7.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool7.SpindleSpeed",               Milling.MillTool7.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool7.Stepdown",                Milling.MillTool7.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool7.Stepover",                Milling.MillTool7.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool7.ToolDia",                 Milling.MillTool7.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool7.ToolNumber",                 Milling.MillTool7.ToolNumber)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool8.FeedRate",                Milling.MillTool8.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool8.InMM",                      Milling.MillTool8.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool8.Name",                    Milling.MillTool8.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool8.PlungeRate",              Milling.MillTool8.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool8.RateUnits",                  Milling.MillTool8.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool8.SpindleSpeed",               Milling.MillTool8.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool8.Stepdown",                Milling.MillTool8.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool8.Stepover",                Milling.MillTool8.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool8.ToolDia",                 Milling.MillTool8.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool8.ToolNumber",                 Milling.MillTool8.ToolNumber)

        RegValue = RegistryWriter:SetDouble("Milling.MillTool9.FeedRate",                Milling.MillTool9.FeedRate)
        RegValue = RegistryWriter:SetBool("Milling.MillTool9.InMM",                      Milling.MillTool9.InMM)
        RegValue = RegistryWriter:SetString("Milling.MillTool9.Name",                    Milling.MillTool9.Name)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool9.PlungeRate",              Milling.MillTool9.PlungeRate)
        RegValue = RegistryWriter:SetInt("Milling.MillTool9.RateUnits",                  Milling.MillTool9.RateUnits)
        RegValue = RegistryWriter:SetInt("Milling.MillTool9.SpindleSpeed",               Milling.MillTool9.SpindleSpeed)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool9.Stepdown",                Milling.MillTool9.Stepdown)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool9.Stepover",                Milling.MillTool9.Stepover)
        RegValue = RegistryWriter:SetDouble("Milling.MillTool9.ToolDia",                 Milling.MillTool9.ToolDia)
        RegValue = RegistryWriter:SetInt("Milling.MillTool9.ToolNumber",                 Milling.MillTool9.ToolNumber)
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
  Tools1 = assert(loadfile(script_path .. "\\EasyMDFDoorTools.xlua")) (Tools1)
  Tools2 = assert(loadfile(script_path .. "\\EasyMDFDoorImages.xlua")) (Tools2)
  Tools3 = assert(loadfile(script_path .. "\\EasyMDFDoorDialog.xlua")) (Tools3)
  GetUnits()
  RegistryRead()
  Project.LoadDate = StartDate(false)
  Door.UnitDisplay = "Note: Units: (" .. Door.Units .. ")"
  HTML()           -- Load the Dialog HTML data
  if InquiryMain() then

  end -- if end
  return true
end -- function end
-- ====================================================]]
