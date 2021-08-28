-- VECTRIC LUA SCRIPT
-- ===================================================]]
--[[Header and Disclamer
--  Gadgets are an entirely optional add-in to Vectric's core software products.
--  They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
--  In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

--  Permission is granted to anyone to use this software for any purpose,
--  including commercial applications, and to alter it and redistribute it freely,
--  subject to the following restrictions:
--  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--  2. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
--  3. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--  4. This notice may not be removed or altered from any source distribution.

-- Easy Stair Gadget Master is written by Jim Anderson of Houston Texas 2020

-- ===================================================]]
-- The mobdebug is to activate the debug capability in ZeroBrane Studio within the Vectric solution
-- require("mobdebug").start()
-- ===================================================]]
-- Global Variables --

  local Stair = {}    -- builds table
  local Trig = {}     -- Triangle function table

  Stair.AppName     = "Easy Stair Maker"                 -- Application Name
  Stair.Version     = "11.0"                              -- Application Build Version
  Stair.RegistryTag = "EasyStairMaker-" .. Stair.Version -- Registry Name with Versioning

  local Wpt0 = Point2D(6.0, 6.0)  -- lower left Basepoint
  local Wpt1 = Wpt0               -- lower workpoint
  local Wpt2 = Wpt0               -- Upper Right workpoint
  local Wpt3 = Wpt0               -- Lower Right workpoint
  local Wpt4 = Wpt0               -- Stringer Stock WP length
  local WptS = Wpt0               -- Step Loop calculation workpoint
  local WptR = Wpt0               -- Rise Loop calculation workpoint
  local Tool_ID = ToolDBId()
  local lead_in_out_data = LeadInOutData() -- Create object used to control lead in/out
  Stair.DialogLoop = true
  Tool_ID:LoadDefaults("My Toolpath", "")
-- ===================================================]]
function ReadRegistry()                                 -- Reads data from the Registry
  -- Reg Path: Computer\HKEY_CURRENT_USER\SOFTWARE\Vectric\VCarve ProV10\EasyStairMaker-6.0
  local RegistryRead     = Registry(Stair.RegistryTag)
  Stair.StepCount        = RegistryRead:GetInt("Stair.StepCount", 6)     -- number of steps
  Stair.StepRise         = RegistryRead:GetDouble("Stair.StepRise", 7.250)  -- height of the step
  Stair.StepRun          = RegistryRead:GetDouble("Stair.StepRun", 11.250)   -- horizontal length of the step
  Stair.TreadRun         = RegistryRead:GetDouble("Stair.TreadRun", 0.0000)  -- Horizontal length of the step
  Stair.TreadThickness   = RegistryRead:GetDouble("Stair.TreadThickness", 1.1250) -- Material thickness of the tread stock
  Stair.TreadNoseing     = RegistryRead:GetDouble("Stair.TreadNoseing", 0.7500)   -- Step noseing amount allocated for the tread hange over
  Stair.RiserThickness   = RegistryRead:GetDouble("Stair.RiserThickness", 0.5000) -- Material thickness of the riser stock
  Stair.StringerWidth    = RegistryRead:GetDouble("Stair.StringerWidth", 11.500)  -- Material Width of the String stock
  Stair.StringerAngle    = RegistryRead:GetDouble("Stair.StringerAngle", 0.000)    -- Stair Angle to clim
  Stair.CrossStringAngle = RegistryRead:GetDouble("Stair.CrossStringAngle", 0.000) -- Invers stair Angle
  Stair.StringerLayer    = RegistryRead:GetString("Stair.StringerLayer", "Stringer Profile")  -- Stringer Layer
  Stair.DrawWorkPoints   = RegistryRead:GetBool("Stair.DrawWorkPoints", false)   -- true = Turns on and false turns off all workpoints
  Stair.TreadLayer       = RegistryRead:GetString("Stair.TreadLayer", "Tread Profile")  --* Tread Layer
  Stair.RiserLayer       = RegistryRead:GetString("Stair.RiserLayer", "Riser Profile")  --* Riser Layer
  Stair.RunDim           = RegistryRead:GetDouble("Stair.RunDim", 0.000)                --* Stair Run dimension
  Stair.RiseDim          = RegistryRead:GetDouble("Stair.RiseDim", 0.000)               --* Stair Rise dimension
  Stair.RiserRun         = RegistryRead:GetDouble("Stair.RiserRun", 0.000)               --* Stair Rise Material dimension
  Stair.StringStockLength = RegistryRead:GetDouble("Stair.StringStockLength", 69.5000) -- String Material Stock Length
  Stair.Decimals        = RegistryRead:GetInt("Stair.Decimals", 4)     -- number of decimal places to display in dialogue
  Stair.WriteBOM        = RegistryRead:GetBool("Stair.WriteBOM", false)   -- true = Turns on and false turns off Bill of materials
  Stair.BOMWritePath    = RegistryRead:GetString("Stair.BOMWritePath", "C:\\temp\\")  --* Riser Layer

end -- function end
-- ===================================================]]
function WriteRegistry()                                -- Writes data to the Registry
  -- Reg Path: Computer\HKEY_CURRENT_USER\SOFTWARE\Vectric\VCarve ProV10\EasyStairMaker-6.0
  local RegistryWrite = Registry(Stair.RegistryTag)
  local RegValue = RegistryWrite:SetInt("Stair.StepCount", Stair.StepCount)
        RegValue = RegistryWrite:SetDouble("Stair.StepRise", Stair.StepRise)
        RegValue = RegistryWrite:SetDouble("Stair.StepRun", Stair.StepRun)
        RegValue = RegistryWrite:SetDouble("Stair.TreadRun", Stair.TreadRun)
        RegValue = RegistryWrite:SetDouble("Stair.TreadThickness", Stair.TreadThickness)
        RegValue = RegistryWrite:SetDouble("Stair.TreadNoseing", Stair.TreadNoseing)
        RegValue = RegistryWrite:SetDouble("Stair.RiserThickness", Stair.RiserThickness)
        RegValue = RegistryWrite:SetDouble("Stair.StringerWidth", Stair.StringerWidth)
        RegValue = RegistryWrite:SetDouble("Stair.StringerAngle",  Stair.StringerAngle)
        RegValue = RegistryWrite:SetDouble("Stair.CrossStringAngle",  Stair.CrossStringAngle)
        RegValue = RegistryWrite:SetString("Stair.StringerLayer", Stair.StringerLayer)
        RegValue = RegistryWrite:SetBool("Stair.DrawWorkPoints", Stair.DrawWorkPoints)
        RegValue = RegistryWrite:SetString("Stair.TreadLayer", Stair.TreadLayer)
        RegValue = RegistryWrite:SetString("Stair.RiserLayer", Stair.RiserLayer)
        RegValue = RegistryWrite:SetDouble("Stair.RunDim",  Stair.RunDim)
        RegValue = RegistryWrite:SetDouble("Stair.RiseDim",  Stair.RiseDim)
        RegValue = RegistryWrite:SetDouble("Stair.RiserRun",  Stair.RiserRun)
        RegValue = RegistryWrite:SetDouble("Stair.StringStockLength",  Stair.StringStockLength)
        RegValue = RegistryWrite:SetInt("Stair.Decimals", Stair.Decimals)
        RegValue = RegistryWrite:SetBool("Stair.WriteBOM", Stair.WriteBOM)
        RegValue = RegistryWrite:SetString("Stair.BOMWritePath", Stair.BOMWritePath)
end -- function end
-- ===================================================]]
function TrigClear()                                    -- Clears and resets Trig Table
  Trig.A   =  0.0  -- Angle
  Trig.B   =  0.0  -- Angle
  Trig.C   = 90.00
  Trig.Opp =  0.0  -- Rise  or (B2C)
  Trig.Adj =  0.0  -- Base  or (A2C)
  Trig.Hyp =  0.0  -- Slope or (A2B)
  Trig.Slope =  0.0  -- Angle based on run over rise ie-(6 on 12 angle)
  return true
end -- function end
-- ===================================================]]
function TrigIt()                                       -- Calulates Right Triangle
  --[[ Testing and Usage
    TrigClear()
  -- Trig.A   =  0.0
  -- Trig.B   =  0.0
  Trig.Opp =  3.0  -- Rise  or (B2C)
  Trig.Adj =  4.0  -- Base  or (A2C)
  -- Trig.Hyp =  0.0  -- Slope or (A2B)
  -- Trig.Slope =  0.0

  TrigIt() -- calculate right triangle
    DisplayMessageBox("Test 1: \n" ..
                      " Trig.A   =  " .. tostring(Trig.A) .. " \n" ..
                      " Trig.B   =  " .. tostring(Trig.B) .. " \n" ..
                      " Trig.C   =  " .. tostring(Trig.C) .. " \n" ..
                      " Trig.Opp = * " .. tostring(Trig.Opp) .. " \n" ..
                      " Trig.Adj = * " .. tostring(Trig.Adj) .. " \n" ..
                      " Trig.Hyp =  " .. tostring(Trig.Hyp) .. " \n" ..
                      " Trig.Slope =  " .. tostring(Trig.Slope) .. " \n" ..
                      " Trig.Area =  " .. tostring(Trig.Area) .. " \n" ..
                      " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
                      " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
                      " Trig.InRadius =  " .. tostring(Trig.InRadius) .. " \n"
                    )
  ]]
  -- =========================================================]]
  local function BSA()
    Trig.B   = (Trig.C - Trig.A)
    Trig.Slope = math.tan(math.rad(Trig.A)) * 12.0
    Trig.Area =  (Trig.Opp * Trig.Adj) * 0.5
    Trig.Inscribing = ((Trig.Opp + Trig.Adj) - Trig.Hyp) * 0.5
    Trig.Circumscribing =  Trig.Hyp * 0.5
    Trig.Parameter = Trig.Opp + Trig.Adj + Trig.Hyp
  end
  -- =========================================================]]
  if Trig.A == 0.0 and Trig.B > 0.0 and Trig.Slope ==  0.0 then
      Trig.A = Trig.C - Trig.B
    elseif Trig.A == 0.0 and Trig.B == 0.0 and Trig.Slope > 0.0 then
      Trig.A = math.deg(math.atan(Trig.Slope / 12.0))
  end -- if end
  -- =========================================================]]
  if (Trig.A > 0.0) and (Trig.Opp >  0.0) then -- A and Rise or (B2C)
    Trig.Adj =  Trig.Opp / (math.tan(math.rad(Trig.A)))
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    BSA()
    return true
  elseif (Trig.A > 0.0) and (Trig.Hyp >  0.0)  then -- A and Bevel or (A2B)
    Trig.Adj = math.cos(math.rad(Trig.A)) * Trig.Hyp
    Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
    BSA()
    return true
  elseif (Trig.A > 0.0) and (Trig.Adj >  0.0)  then -- A and Base or (A2C)
    Trig.Opp = math.tan(math.rad(Trig.A)) * Trig.Adj
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    BSA()
    return true
  elseif (Trig.Opp >  0.0) and (Trig.Adj >  0.0) then -- Rise and Base
    Trig.Hyp = math.sqrt((Trig.Opp * Trig.Opp ) + ( Trig.Adj * Trig.Adj))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()
    return true
  elseif (Trig.Adj >  0.0) and (Trig.Hyp >  0.0) then -- Rise and Bevel
    Trig.Opp = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Adj * Trig.Adj))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()
    return true
  elseif (Trig.Opp >  0.0) and (Trig.Hyp >  0.0) then -- Base and Bevel
    Trig.Adj = math.sqrt((Trig.Hyp * Trig.Hyp ) - ( Trig.Opp * Trig.Opp))
    Trig.A   = math.deg(math.atan(Trig.Opp / Trig.Adj))
    BSA()
    return true
  else -- Error: Falure to find a match
    DisplayMessageBox("Error: Right Triangle values did not match requirements: \n" ..
        " Trig.A     =  " .. tostring(Trig.A) .. " \n" ..
        " Trig.B     =  " .. tostring(Trig.B) .. " \n" ..
        " Trig.C     =  " .. tostring(Trig.C) .. " \n" ..
        " Trig.Opp   =  " .. tostring(Trig.Opp) .. " \n" ..
        " Trig.Adj   =  " .. tostring(Trig.Adj) .. " \n" ..
        " Trig.Hyp   =  " .. tostring(Trig.Hyp) .. " \n" ..
        " Trig.Slope =  " .. tostring(Trig.Slope) .. " on 12 inch \n" ..
        " Trig.Area  =  " .. tostring(Trig.Area) .. " \n" ..
        " Trig.Parameter =  " .. tostring(Trig.Parameter) .. " \n" ..
        " Trig.OutRadius =  " .. tostring(Trig.OutRadius) .. " \n" ..
        " Trig.InRadius  =  " .. tostring(Trig.InRadius) .. " \n"
    )
    return false
  end
end -- function end
-- ===================================================]]
function GetAngle(p1, p2)                               -- Returns the Angle from two, 2D points
  return math.deg(math.atan((p2.Y - p1.Y) / (p2.X - p1.X)))
end
-- ===================================================]]
function MarkAPoint(job, Note, Pt, Size, LayerName)     -- Draws mark on the drawing
-- MarkPoint(job, "Note: Hi", Pt1, 3, "Jim")

  local layer = job.LayerManager:GetLayerWithName(LayerName)
  local marker1 = CadMarker(Note, Pt, Size)
  layer:AddObject(marker1, true)
  DrawCircle(job,  Pt, 0.25, LayerName)
end -- function end
-- ===================================================]]
function TheDate(LongDate)                             -- Returns the current date and time
--[[
%a  abbreviated weekday name (e.g., Wed)
%A  full weekday name (e.g., Wednesday)
%b  abbreviated month name (e.g., Sep)
%B  full month name (e.g., September)
%c  date and time (e.g., 09/16/98 23:48:10)
%d  day of the month (16) [01-31]
%H  hour, using a 24-hour clock (23) [00-23]
%I  hour, using a 12-hour clock (11) [01-12]
%M  minute (48) [00-59]
%m  month (09) [01-12]
%p  either "am" or "pm" (pm)
%S  second (10) [00-61]
%w  weekday (3) [0-6 = Sunday-Saturday]
%x  date (e.g., 09/16/98)
%X  time (e.g., 23:48:10)
%Y  full year (1998)
%y  two-digit year (98) [00-99]
%%  the character `%´
]]
if LongDate then
    return os.date("%b %d, %Y") .. " - " .. os.date("%I") .. ":" .. os.date("%m") .. os.date("%p")  -- Long Date Format
  else
    return os.date("%Y%m%d%H%M")   -- Short Date Format
  end
end
-- ===================================================]]
function GetDistance(objA, objB)                        -- Returns the distance between two points
   local xDist = objB.x - objA.x
   local yDist = objB.y - objA.y
   return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end -- End Fuction
-- ===================================================]]
function CutListFileWriterHeader()                      -- Writes a file Header for a Bill of Miterials
  if Stair.WriteBOM then
    Stair.DatFile = Stair.BOMWritePath .. "\\BOM-" .. TheDate(false) .. ".dat"
    Stair.CsvFile = Stair.BOMWritePath .. "\\BOM-" .. TheDate(false) .. ".txt"
    local file = io.open(Stair.DatFile, "w")
    file:write("=============================================================================================== \n")
    file:write("====================================   Stair Cut-list   ======================================= \n")
    file:write("  Run Date = ".. TheDate(true) .."\n")
    file:write("=============================================================================================== \n")
    file:write("  Stair Dimensions \n")
    file:write("  Stair Height        = ".. tostring(Stair.RiseDim)  .."\n")
    file:write("  Stair Length        = ".. tostring(Stair.RunDim)  .."\n")
    file:write("  Stair Step Depth    = ".. tostring(Stair.StepRun)  .."\n")
    file:write("  Stair Step Height   = ".. tostring(Stair.StepRise)  .."\n")
    file:write("  Stair Steps         = ".. tostring(Stair.StepCount)  .."\n")
    file:write("  WP to WP Diagonal   = ".. tostring(Rounder(GetDistance(Wpt1, Wpt2), Stair.Decimals))  .."\n")
    file:write("=============================================================================================== \n")
    file:write(" ID  | Part Name                       |Count| Thickness | Material        | Width   | Length\n")
    file:write("=============================================================================================== \n")
    file:close()
    file = io.open(Stair.CsvFile, "w")
    file:write("ID, Name, Count, Thick, Material, Width, Length\n")
    file:close()
  end --if end
end -- function end
-- ===================================================]]
function CutListFileWriterItem(ID, Name, Count, Thick, Material, Width, Length)-- Writes a Line Item to the Bill of Miterials file
  -- Call = CutListFileWriterItem("W-H", "Center Panel", "1", Stair.MaterialThickness, "Plywood", Stair.CenterPanelWidth, Stair.CenterPanelLength)
  if Stair.WriteBOM then
    local file = io.open(Stair.DatFile, "a")
    local sID = " " .. ID .. " "
    local sName = string.sub("| ".. Name .."                                      ",1, 34)
    local sCount = string.sub("| ".. Count .."                                      ",1, 6)
    local sThick = string.sub("|    ".. Thick .."                                     ",1, 12)
    local sMaterial = string.sub("| ".. Material .."                              ",1, 18)
    local sWidth = string.sub("| ".. Width .."                                      ",1, 10)
    local sLength = string.sub("| ".. Length .."                                  ",1, 9)
    file:write(sID .. sName .. sCount .. sThick .. sMaterial .. sWidth .. sLength .. "\n")
    file:close()
    file = io.open(Stair.CsvFile, "a")
    file:write(ID .. "," .. Name .. "," .. Count .. "," .. Thick .. "," .. Material .. "," .. Width .. "," .. Length  .. "     \n")
    file:close()
  end --if end
end -- function end
-- ===================================================]]
function CutListFileWriterFooter()                      -- Writes a file footer of the Bill of Miterials file
  if Stair.WriteBOM then
    local file = io.open(Stair.DatFile, "a")
    file:write("======================================  Then End  ============================================= \n")
    file:close()
  end --if end
end -- function end
-- ===================================================]]
function DrawStringer(job)                              -- Draws a Open string
  -- Open
--    local Wp1 = Polar2D(Wpt1,  0.0, Stair.RiserThickness + Stair.TreadNoseing)    -- Establishes p1
    local Wp2 = Polar2D(Wpt0,  0.0, Stair.RiserThickness + Stair.TreadNoseing)    -- Establishes p2
    local Wp3 = Polar2D(Wp2,  90.0, Stair.StepRise - Stair.TreadThickness)        -- Establishes p3
    local Wp4 = Polar2D(Wp3, 360.0 - Stair.CrossStringAngle, Stair.StringerWidth) -- Establishes p4

    TrigClear()

    Trig.A    = Stair.StringerAngle
    Trig.Adj  = Stair.StringerWidth
    TrigIt()

    Stair.Hold = Trig.Hyp - (Stair.StepRise - Stair.TreadThickness)

    local Wp5 = Polar2D(Wp4,  180.0 + Stair.StringerAngle, Trig.Opp) -- Establishes p5

    TrigClear()
    Trig.A    = Stair.StringerAngle
    Trig.Opp  = Stair.Hold
    TrigIt()

    local Wp6 = Polar2D(Wp5,  Stair.StringerAngle, Trig.Hyp)         -- Establishes p6
    Stair.Hold = Trig.Adj

    TrigClear()
    Trig.A    = Stair.StringerAngle
    Trig.Adj  = Stair.RunDim - Stair.Hold
    TrigIt()

    local Wp7 = Polar2D(Wp6,  Stair.StringerAngle, Trig.Hyp)         -- Establishes p7

  if Stair.DrawWorkPoints then     --* Controls if the work point is shown

    MarkAPoint(job, "Wpt0", Wpt0, 3, "WP: Note String")
    MarkAPoint(job, "Wpt1", Wpt1, 3, "WP: Note String")
    MarkAPoint(job, "Wpt2", Wpt2, 3, "WP: Note String")
    MarkAPoint(job, "Wp2" , Wp2,  3, "WP: Note String")
    MarkAPoint(job, "Wp3" , Wp3,  3, "WP: Note String")
    MarkAPoint(job, "Wp4" , Wp4,  3, "WP: Note String")
    MarkAPoint(job, "Wp5" , Wp5,  3, "WP: Note String")
    MarkAPoint(job, "Wp6" , Wp6,  3, "WP: Note String")
    MarkAPoint(job, "Wp7" , Wp7,  3, "WP: Note String")
  end
    -- draw a line Wp2 and Wp3
    local line = Contour(0.0)
    line:AppendPoint(Wp2)

    -- Loop the steps on the stringer
      Stair.StringerMin = Wp3
      local Wpx = Wp2 -- Establishes the starting point for each cycle
      local Wpy = Polar2D(Wpx, 90.0, Stair.StepRise - Stair.TreadThickness)       -- Establishes p4
      local Wpz = Polar2D(Wpy,  0.0, Stair.StepRun)        -- Establishes p3

    for i = Stair.StepCount, 1, -1  do
      if Stair.DrawWorkPoints then  --* Controls if the work point is shown
        MarkAPoint(job, "Wpy" .. "-" .. tostring(i), Wpy, 3, "WP: Note Stringer")
        MarkAPoint(job, "Wpz" .. "-" .. tostring(i), Wpz, 3, "WP: Note Stringer")
      end  --if end
      line:LineTo(Wpy)
      line:LineTo(Wpz)
      Wpx = Wpz
      Wpy = Polar2D(Wpx, 90.0, Stair.StepRise)
      Wpz = Polar2D(Wpy,  0.0, Stair.StepRun)
      Stair.StringerMax = Wpz
    end --for end
      line:LineTo(Wp7)
      line:LineTo(Wp6)
      line:LineTo(Wp2)
    -- Draw the last step (no riser)

    -- Close the stringer line to Wp2

    local layer = job.LayerManager:GetLayerWithName(Stair.StringerLayer)
    layer:AddObject(CreateCadContour(line), true)

end -- function end
-- ===================================================]]
function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- draws a circle based on user inputs
  -- job - current validated job unique ID
  -- Cpt - (2Dpoint) center of the circle
  -- CircleRadius - radius of the circle
  -- Layer - layer name to draw circle (make layer if not exist)
  local pa = Polar2D(Cpt, 180.0, CircleRadius)
  local pb = Polar2D(Cpt,   0.0, CircleRadius)
  local line = Contour(0.0)
  line:AppendPoint(pa)
  line:ArcTo(pb,1)
  line:ArcTo(pa,1)
  local layer = job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
--===================================================]]
function OnLuaButton_ButtonCalulate(dialog)             -- Executes the calculation function from the dialogue
    dialog:UpdateLabelField("Alerts", "")
    Stair.StepCount      = dialog:GetIntegerField("Stair.StepCount")
    Stair.RunDim         = dialog:GetDoubleField("Stair.RunDim")
    Stair.RiseDim        = dialog:GetDoubleField("Stair.RiseDim")
    Stair.Decimals       = dialog:GetIntegerField("Stair.Decimals")
    if (Stair.StepCount <= 0.0 or Stair.RunDim <= 0.0 or Stair.RiseDim <= 0.0) then
        dialog:UpdateLabelField("Alerts", "These Numbers Will Not Work!")
    else
        -- perform calculations
        Stair.StepRun = Rounder(Stair.RunDim / Stair.StepCount, Stair.Decimals)          -- calculate the stair run (horizontal) dimension
        Stair.StepRise = Rounder(Stair.RiseDim / (Stair.StepCount + 1), Stair.Decimals)  -- calculate the stair rise (vertical) dimension
        -- update the dialogue with the new values
        dialog:UpdateDoubleField("Stair.StepRun", Stair.StepRun)
        dialog:UpdateDoubleField("Stair.StepRise", Stair.StepRise)
    end
    return  true
end
-- ===================================================]]
function InquiryBox(Header)                             -- Displays a dialog box for user inputs
  local myHtml = [[<html><head><title>Easy Stair Maker</title><style type="text/css">html{overflow:hidden}.LuaButton{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.DirectoryPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.ToolPicker{font-weight:bold;font-family:Arial,Helvetica,sans-serif;font-size:12px}.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right}.alert { font-family: Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold; color:#00F; text-align:center;} .h1-c{font-family:Arial, Helvetica, sans-serif; font-size:12px; text-align:center}body{background-color:#CCC;overflow:hidden;font-family:Arial,Helvetica,sans-serif; font-size:12px}</style></head><body><table width="480" border="0"><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Stair Rise:</td><td width="111" nowrap="nowrap"><input name = "Stair.RiseDim" type = "text" id = "Stair.RiseDim" size = "10" /></td><td width="22" nowrap="nowrap">&nbsp;</td><td width="109" align="center" nowrap="nowrap">&nbsp;</td><td width="107" align="center" nowrap="nowrap">&nbsp;</td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Stair Run:</td><td width="111" nowrap="nowrap"><input name = "Stair.RunDim" type = "text" id = "Stair.RunDim" size = "10" /></td><td colspan="3" align="center" nowrap="nowrap"><span style="width: 20%"> <input id = "ButtonCalulate" class = "LuaButton" name = "ButtonCalulate" type = "button" value = "Calulate"/> </span></td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Tread Count:</td><td width="111" nowrap="nowrap"><input name = "Stair.StepCount" type = "text" id = "Stair.StepCount" size = "10" /></td><td align="center" nowrap="nowrap">&nbsp;</td><td align="center" nowrap="nowrap" class="h1-r">Decimals:</td><td align="left" nowrap="nowrap" class="h1-l"><input name = "Stair.Decimals" type = "text" id = "Stair.Decimals" value="4" size = "10" /></td></tr><tr><td height="4" colspan="5" align="right" nowrap="nowrap" class="alert" id="Alerts">&nbsp;</td></tr><tr><td height="4" colspan="5" align="right" nowrap="nowrap" class="h1-r"><hr></td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r"><span class="h1-c">Riser Higth</span>:</td><td width="111" nowrap="nowrap"><input name = "Stair.StepRise" type = "text" id = "Stair.StepRise" size = "10" readonly /></td><td width="22" align="center" nowrap="nowrap" class="h1-c">&nbsp;</td><td width="109" align="center" nowrap="nowrap" class="h1-r">Tread Width:</td><td width="107" nowrap="nowrap"><input name = "Stair.StepRun" type = "text" id = "Stair.StepRun" size = "10" readonly /></td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Riser Thickness:</td><td width="111" nowrap="nowrap"><input name = "Stair.RiserThickness" type = "text" id = "Stair.RiserThickness" size = "10" /></td><td width="22" nowrap="nowrap">&nbsp;</td><td width="109" align="right" nowrap="nowrap" class="h1-r">Tread Thickness:</td><td width="107" nowrap="nowrap"><input name = "Stair.TreadThickness" type = "text" id = "Stair.TreadThickness" size = "10" /></td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Stringer Width:</td><td width="111" nowrap="nowrap"><input name = "Stair.StringerWidth" type = "text" id = "Stair.StringerWidth" size = "10" /></td><td width="22" nowrap="nowrap">&nbsp;</td><td width="109" align="center" nowrap="nowrap" class="h1-r">Noseing:</td><td width="107" nowrap="nowrap"><input name = "Stair.TreadNoseing" type = "text" id = "Stair.TreadNoseing" size = "10" /></td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Tread Layer:</td><td nowrap="nowrap"><input name = "Stair.TreadLayer" type = "text" id = "Stair.TreadLayer" size = "15" maxlength="25" /></td><td width="22" nowrap="nowrap">&nbsp;</td><td width="109" align="center" nowrap="nowrap" class="h1-r">Stringer Layer:</td><td width="107" nowrap="nowrap"><input name = "Stair.StringerLayer" type = "text" id = "Stair.StringerLayer" size = "15" maxlength="25" /></td></tr><tr><td width="109" align="right" nowrap="nowrap" class="h1-r">Riser Layer:</td><td nowrap="nowrap"><input name = "Stair.RiserLayer" type = "text" id = "Stair.RiserLayer" size = "15" maxlength="25" /></td><td width="22" nowrap="nowrap">&nbsp;</td><td width="109" align="center" nowrap="nowrap" class="h1-r">BOM:</td><td width="107" nowrap="nowrap"><input type="checkbox" name="Stair.WriteBOM" id="Stair.WriteBOM"></td></tr><tr><td width = "109" align = "right" nowrap = "nowrap" class = "h1-r">Stringer Layer:</td><td colspan = "4" nowrap = "nowrap"><input name = "Stair.BOMWritePath" type = "text" id = "Stair.BOMWritePath" size = "52" readonly/> <span style = "width: 20%"> <input id = "ButtonBOMPath" class = "DirectoryPicker" name = "ButtonBOMPath" type = "button" value = "Path"/> </span></td></tr><tr><td colspan="5" nowrap="nowrap" class="ToolNameLabel"><hr></td></tr><tr><td colspan="4" nowrap="nowrap" class="ToolNameLabel"><span id = "ToolNameLabel">Tool Name</span></td><td align="center"><input type = "button" name = "ToolChooseButton" id = "ToolChooseButton" value = "Select" class = "ToolPicker"/></td></tr><tr><td colspan="5" nowrap="nowrap"><hr></td></tr><tr><td width="109" align="center" nowrap="nowrap"><strong><a href="https://www.youtube.com/channel/UCSM4fWwTIvVI91nTzIe554Q" target="_blank" class="h1-c">Video</a></strong></td><td width="111" align="right" nowrap="nowrap"><span class="h1-r">Show WPs'</span></td><td width="22" nowrap="nowrap"><input type="checkbox" name="Stair.DrawWorkPoints" id="Stair.DrawWorkPoints"></td><td width="109" align="center" nowrap="nowrap"><span style="width: 20%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel" /> </span></td><td width="107" align="center" nowrap="nowrap"><span style="width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK" /> </span></td></tr></table></body></html>]]
    local dialog = HTML_Dialog(true, myHtml, 550, 460, Header)
    dialog:AddDoubleField("Stair.TreadNoseing", Stair.TreadNoseing)
    dialog:AddDoubleField("Stair.RiserThickness", Stair.RiserThickness)
    dialog:AddDoubleField("Stair.TreadThickness", Stair.TreadThickness)
    dialog:AddDoubleField("Stair.StringerWidth", Stair.StringerWidth)
    dialog:AddIntegerField("Stair.Decimals", Stair.Decimals)
    dialog:AddDoubleField("Stair.RunDim", Stair.RunDim)
    dialog:AddDoubleField("Stair.RiseDim", Stair.RiseDim)
    dialog:AddDoubleField("Stair.StepRise", Stair.StepRise)
    dialog:AddDoubleField("Stair.StepRun", Stair.StepRun)
    dialog:AddCheckBox("Stair.DrawWorkPoints", Stair.DrawWorkPoints)
    dialog:AddTextField("Stair.TreadLayer", Stair.TreadLayer)
    dialog:AddTextField("Stair.RiserLayer", Stair.RiserLayer)
    dialog:AddTextField("Stair.StringerLayer", Stair.StringerLayer)
    dialog:AddIntegerField("Stair.StepCount", Stair.StepCount)
    dialog:AddCheckBox("Stair.WriteBOM", Stair.WriteBOM)
    dialog:AddTextField("Stair.BOMWritePath", Stair.BOMWritePath)
    dialog:AddDirectoryPicker("ButtonBOMPath", "Stair.BOMWritePath", true)
    dialog:AddLabelField("Alerts", "")
    dialog:AddLabelField("ToolNameLabel", "Not Selected")
    dialog:AddToolPicker("ToolChooseButton", "ToolNameLabel", Tool_ID)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
--[[
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.BALL_NOSE)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.RADIUSED_END_MILL)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.VBIT)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.ENGRAVING)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.RADIUSED_ENGRAVING)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.THROUGH_DRILL)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.FORM_TOOL)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.DIAMOND_DRAG)
    dialog:AddToolPickerValidToolType("ToolChooseButton", Tool.RADIUSED_FLAT_ENGRAVING)
  ]]
    if dialog:ShowDialog() then
      Stair.TreadNoseing   = dialog:GetDoubleField("Stair.TreadNoseing")
      Stair.RiserThickness = dialog:GetDoubleField("Stair.RiserThickness")
      Stair.TreadThickness = dialog:GetDoubleField("Stair.TreadThickness")
      Stair.StepCount      = dialog:GetIntegerField("Stair.StepCount")
      Stair.StringerWidth  = dialog:GetDoubleField("Stair.StringerWidth")
      Stair.RunDim         = dialog:GetDoubleField("Stair.RunDim")
      Stair.RiseDim        = dialog:GetDoubleField("Stair.RiseDim")
      Stair.StepRise       = dialog:GetDoubleField("Stair.StepRise")
      Stair.StepRun        = dialog:GetDoubleField("Stair.StepRun")
      Stair.DrawWorkPoints = dialog:GetCheckBox("Stair.DrawWorkPoints")
      Stair.TreadLayer     = dialog:GetTextField("Stair.TreadLayer")
      Stair.RiserLayer     = dialog:GetTextField("Stair.RiserLayer")
      Stair.StringerLayer  = dialog:GetTextField("Stair.StringerLayer")
      Stair.Decimals       = dialog:GetIntegerField("Stair.Decimals")
      Stair.WriteBOM       = dialog:GetCheckBox("Stair.WriteBOM")
      Stair.BOMWritePath   = dialog:GetTextField("Stair.BOMWritePath")
      Stair.MillTool       = dialog:GetTool("ToolChooseButton")
      return true
    else
      return false
    end -- if end
end

-- ===================================================]]
function DMBox(XX, str)
  if XX then
    DisplayMessageBox(str)
  end -- if end
end -- function end
-- ===================================================]]

function CheckDialogValues(mesage)
  Stair.DialogLoop = false
 -- if Stair.TreadNoseing  == 0.0 then
 --   DialogLoop = true
 -- end
  if Stair.RiserThickness  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Riser Thickness value")
  end
  if Stair.TreadThickness  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Tread Thickness value")
  end
  if Stair.StepCount  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Step Count value")
  end
  if Stair.StringerWidth  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Stringer Width value")
  end
  if Stair.RunDim  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Stair Run value")
  end
  if Stair.RiseDim  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Stair Rise value")
  end
  if Stair.StepRise  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Riser alue")
  end
  if Stair.StepRun  == 0.0 then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Step value")
  end
   if  AllTrim(Stair.TreadLayer)  == "" then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Riser Tread Layer value")
  end
  if AllTrim(Stair.RiserLayer)  == "" then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Riser Riser Layer value")
  end
  if  AllTrim(Stair.StringerLayer)  == "" then
    Stair.DialogLoop = true
    DMBox(mesage,"Error: Incorrect Stringer Layer value")
  end
  if Stair.WriteBOM  == 1 then
    if Stair.BOMWritePath  == 0.0 then
       Stair.DialogLoop = true
       DMBox(mesage,"Error: Incorrect BOM Path value")
    end
  end
end -- function end
-- ===================================================]]
function AllTrim(s) -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function CreateLayerProfileToolpath(job,layer_name, name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_in_mm)
--  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
  local selection = job.Selection  -- clear current selection
        selection:Clear()
-- get layer
  local layer = job.LayerManager:FindLayerWithName(layer_name)
  if layer == nil then
    DisplayMessageBox("No layer found with name = " .. layer_name)
    return false
  end
-- select all closed vectors on the layer
  if not SelectVectorsOnLayer(layer, selection, true, false, true) then
    DisplayMessageBox("No closed vectors found on layer " .. layer_name)
    return false
  end
-- Create tool we will use to machine vectors
  local tool = Tool(Stair.MillTool.Name, Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
        tool.InMM = tool_in_mm
        tool.ToolDia = tool_dia
        tool.Stepdown = tool_stepdown
        tool.Stepover = tool_dia * 0.25
        tool.RateUnits = Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
        tool.FeedRate = 30
        tool.PlungeRate = 10
        tool.SpindleSpeed = 20000
        tool.ToolNumber = 1
        tool.VBitAngle = 90.0 -- used for vbit only
        tool.ClearStepover = tool_dia * 0.5 -- used for vbit only
-- Create object used to set home position and safez gap above material surface
  local pos_data = ToolpathPosData()
        pos_data:SetHomePosition(0, 0, 5.0)
        pos_data.SafeZGap = 5.0
-- Create object used to pass profile options
  local profile_data = ProfileParameterData()
-- start depth for toolpath
  profile_data.StartDepth = start_depth
  profile_data.CutDepth = cut_depth -- cut depth for toolpath this is depth below start depth
  profile_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION -- direction of cut - ProfileParameterData. CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
  profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE -- side we machine on - ProfileParameterData. PROFILE_OUTSIDE, ProfileParameterData.PROFILE_INSIDE or ProfileParameterData.PROFILE_ON
  profile_data.Allowance = 0.0 -- Allowance to leave on when machining
  profile_data.KeepStartPoints = false -- true to preserve start point positions, false to reorder start points to minimise toolpath length
  profile_data.CreateSquareCorners = false -- true if want to create 'square' external corners on toolpath
  profile_data.CornerSharpen = false -- true to perform corner sharpening on internal corners (only with v-bits)
  profile_data.UseTabs = false -- true to use tabs (position of tabs must already have been defined on vectors)
  profile_data.TabLength = 5.0 -- length for tabs if being used
  profile_data.TabThickness = 1.0
  profile_data.Use3dTabs = true -- if true then create 3d tabs else 2d tabs
  profile_data.ProjectToolpath = false -- if true in Aspire, project toolpath onto composite model
  local ramping_data = RampingData() -- Create object used to control ramping
  ramping_data.DoRamping = false -- if true we do ramping into toolpath
  ramping_data.RampType = RampingData.RAMP_ZIG_ZAG -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG or RampingData.RAMP_SPIRAL
  ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE or RampingData.CONSTRAIN_ANGLE
  ramping_data.RampDistance = 100.0 -- if we are constraining ramp by distance, distance to ramp over
  ramping_data.RampAngle = 25.0 -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
  ramping_data.RampMaxAngleDist = 15 -- if we are contraining ramp by angle, max distance to travel before 'zig zaging' if zig zaging
  ramping_data.RampOnLeadIn = false -- if true we restrict our ramping to lead in section of toolpath

        lead_in_out_data.DoLeadIn = false -- if true we create lead ins on profiles (not for profile on)
        lead_in_out_data.DoLeadOut = false -- if true we create lead outs on profiles (not for profile on)
        lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
        lead_in_out_data.LeadLength = 10.0 -- length of lead to create
        lead_in_out_data.LinearLeadAngle = 45 -- Angle for linear leads
        lead_in_out_data.CirularLeadRadius = 5.0 -- Radius for circular arc leads
        lead_in_out_data.OvercutDistance = 0.0 -- distance to 'overcut' (travel past start point) when profiling
  local geometry_selector = GeometrySelector() -- Create object which can be used to automatically select geometry
  local create_2d_previews = true -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
  local display_warnings = true -- if this is true we will display errors and warning to the user
  local toolpath_manager = ToolpathManager() -- Create our toolpath
  local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data, ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
  if toolpath_id == nil then
    DisplayMessageBox("Error creating toolpath")
    return false
  end
  return true
end
-- ===================================================]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
--  Please Note: SelectVectorsOnLayer is provided by Vectric and can be found in the SDK and Sample Gadget files.
--[[  ---------------- SelectVectorsOnLayer ----------------
|   SelectVectorsOnLayer("Stringer Profile", selection, true, falus, falus)
|   Add all the vectors on the layer to the selection
|     layer,            -- layer we are selecting vectors on
|     selection         -- selection object
|     select_closed     -- if true  select closed objects
|     select_open       -- if true  select open objects
|     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
|  Return Values:
|     true if selected one or more vectors|
]]
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
      end -- if end
      end
    end -- while end
    -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
    -- tell selection we have now finished updating
    if objects_selected then
        selection:GroupSelectionFinished()
    end
    return objects_selected
end
-- ===================================================]]
function Rounder(num, idp)                              -- reduce the size of the fraction to 6 places
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
-- ===================================================]]
function Polar2D(pt, ang, dis)                          -- calulates a 2D point in space
  -- returns the 2D point based on user's inputs.
  -- pt  - (2Dpoint) reference 2Dpoint
  -- ang - (double) projection angle in degrees for new point
  -- dis - (double) projection distance in current drawing units
    return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end -- function end
-- ===================================================]]
function DrawStep(job, Pt1, LayerName)                  -- Draws step
  -- draws a Step based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Layer - (String) layer name to draw circle (make layer if not exist)
        WptR = Polar2D(Pt1, 0.0,  Stair.TreadRun - Stair.RiserThickness )
    local p1 = Polar2D(Pt1,270.0, Stair.TreadThickness) -- Establishes p1
    local p2 = Polar2D(p1,   0.0, Stair.TreadRun)       -- Establishes p2
    local p3 = Polar2D(p2,  90.0, Stair.TreadThickness) -- Establishes p3
    Wpt4 = p3
    local line = Contour(0.0)
    line:AppendPoint(Pt1)
    line:LineTo(p1)     -- Draws p-line from Pt1
    line:LineTo(p2)     -- Draws p-line from p1
    line:LineTo(p3)     -- Draws p-line from p2
    line:LineTo(Pt1)    -- Draws p-line from p3 and closes p-line
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true
end -- function end
-- ===================================================]]
function DrawRiser(job, Pt1, LayerName)                 -- Draws risers
  -- draws a Riser based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Layer - (String) layer name to draw circle (make layer if not exist)
    local p0 = Polar2D(Pt1, 90.0, Stair.StepRise)                        -- Establishes p0
        WptS = Polar2D(p0, 180.0, Stair.TreadNoseing)                    -- Establishes WptS
    local p1 = Polar2D(Pt1,  0.0, Stair.RiserThickness)                  -- Establishes p1
    local p2 = Polar2D(p1,  90.0, Stair.RiserRun) -- Establishes p2
    local p3 = Polar2D(p2, 180.0, Stair.RiserThickness)                  -- Establishes p3

    local line = Contour(0.0)
    line:AppendPoint(Pt1)
    line:LineTo(p1)      -- Draws p-line from Pt1
    line:LineTo(p2)      -- Draws p-line from p1
    line:LineTo(p3)      -- Draws p-line from p21
    line:LineTo(Pt1)     -- Draws p-line from p3 and closes p-line
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true
end -- function end
-- ===================================================]]
function DrawLine(job, Pt1, Pt2, LayerName)             -- Draws a line between 2 points
  -- draws a line based on user inputs
  -- job - current validated job unique ID
  -- Pt1 - (2Dpoint) Starting point of Line
  -- Pt2 - (2Dpoint) Ending point of Line
  -- Layer - layer name to draw Line (make layer if not exist)
    local line = Contour(0.0)
    line:AppendPoint(Pt1)
    line:LineTo(Pt2)
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    layer:AddObject(CreateCadContour(line), true)
    return true
end -- function end
-- ===================================================]]
function main()                              -- Gadget starting point
--[[
	Gadget Notes:
    Video 01: Dec 2019 - My New Gadget
    Video 02: Dec 2019 - My Stair Gadget
    Video 03: Dec 2019 - Added Steps and Risers sub functions to My Stair Gadget
    Video 04: Dec 2019 - Added Steps and Risers thickness and address the edits to shapes
    Video 05: Dec 2019 - Added Stringer Open and Closed shapes
    Video 06: Jan 2020 - Added variable storage and recall
    Video 07: Jan 2020 - Added a Dialogue for user inputes
    Video 08: Jan 2020 - Added Bill of materials capabilities
    Video 09: Jan 2020 - Added Toolpaths and Tool Database capabilities
    Video 10: Jan 2020 - Debug code
    Video 11: Jan 2020 - Building Error Traps

  ]]
-- Localized Variables --


  local Layer = ""  -- establishes a variable called layer
  local WPrad = 0.0  -- establishes a variable called WPrad


-- Job Validation --
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n"
                    )
    return false ;
  end

-- Get Data --
  ReadRegistry()             -- First thing: Get/Reads all data values from the Registry
  -- User input Dialogue --
  DisplayMessageBox("WARNING: Use this Gadget at your own risk! \n" ..
                    "This Gadget creates a toolpath; the toolpath MUST \n" ..
                    "be fully validated before using on your equipment (mill, lathe, etc...) \n" ..
                    "It is extremely important to realize the danger \n"..
                    "to you and/or your equipment."
    )

  while Stair.DialogLoop do
    Stair.Inquiry = InquiryBox(Stair.AppName .. " Version " .. Stair.Version)
    if Stair.Inquiry then
      Stair.DialogLoop = false
      CheckDialogValues(true)
    else
      Stair.DialogLoop = false
    end -- if end
  end -- while end

  if Stair.Inquiry then
  -- Calculation --
    Stair.TreadRun = Stair.StepRun + Stair.RiserThickness + Stair.TreadNoseing --* horizontal Material length of the step
    Stair.RunDim = Stair.StepCount * Stair.StepRun  -- calculate the stair run (horizontal) dimension
    Stair.RiseDim = (Stair.StepCount + 1) * Stair.StepRise  -- calculate the stair rise (vertical) dimension
    Stair.RiserRun = Stair.StepRise - Stair.TreadThickness -- calculate the stair rise material dimension
    Wpt1 = Polar2D(Wpt0, 90.0, Stair.StepRise)     -- establish a work point vertical of the Basepoint
    Wpt3 = Polar2D(Wpt0,  0.0, Stair.RunDim)       -- establish working point horizontal to the Basepoint
    Wpt2 = Polar2D(Wpt3, 90.0, Stair.RiseDim)      -- establish working point vertical of previous point (Wpt3)
    WptR = Polar2D(WptR,  0.0, Stair.TreadNoseing) -- establishes the new WP base on tread nosing
    Stair.StringerAngle = GetAngle(Wpt1, Wpt2)
    Stair.CrossStringAngle = 90.0 - Stair.StringerAngle

    TrigClear()
    Trig.A    = Stair.StringerAngle
    Trig.Hyp  = Stair.TreadThickness
    TrigIt()

    Stair.StringStockLength = GetDistance(Wpt1, Wpt2) - Trig.Opp

    WriteRegistry()     -- Last Thing: after Calculations, Writes data values to the Registry
  -- Do Something --

    Layer = "WP Circle Layer"             -- set layer to Circle layer
    WPrad = 0.25                          -- set WorkPoint identification circle radius
    DrawCircle(job, Wpt1, WPrad, Layer)   -- draw circle to Work Point
    DrawCircle(job, Wpt2, WPrad, Layer)   -- draw circle to Work Point

    CutListFileWriterHeader()             -- Write a new BOM files with Header info

    if Stair.DrawWorkPoints then          -- Controls if the work point is shown
      DrawCircle(job, Wpt0, WPrad, Layer) -- draw circles
      DrawCircle(job, Wpt3, WPrad, Layer)

      Layer = "WP Line Layer"             -- set layer to Line
      DrawLine(job, Wpt1, Wpt2, Layer)    -- draw a line
      DrawLine(job, Wpt1, Wpt2, Layer)
      DrawLine(job, Wpt2, Wpt3, Layer)
      DrawLine(job, Wpt3, Wpt0, Layer)
    end --if end


    DrawStringer(job) -- Draws the stringer
    CutListFileWriterItem("SS1", "Stair Stringer", "TBD", "TBD", "Wood", Stair.StringerWidth, Stair.StringStockLength)             -- Add Item to the BOM Files

    local Steper = 0  -- establishes a variable called Steper and sets it to zero (0)
    -- draw the lower riser
    DrawRiser(job, WptR, Stair.RiserLayer ) -- draw the lower riser
    while Stair.StepCount > Steper  do
      -- draw the step
      DrawStep(job, WptS, Stair.TreadLayer)
      -- draw the riser
      DrawRiser(job, WptR, Stair.RiserLayer)
      Steper = Steper + 1     -- increment the loop to the next vertical step
    end -- while end

    CutListFileWriterItem("SR2", "Stair Risers", Stair.StepCount + 1, Stair.RiserThickness, "Wood", Stair.TreadRun, "TBD")      -- Add Item to the BOM Files
    CutListFileWriterItem("ST3", "Stair Treads", Stair.StepCount, Stair.TreadThickness, "Wood", Stair.RiserRun, "TBD")          -- Add Item to the BOM Files
    CutListFileWriterFooter()                     -- Write the the Footer to the BOM File
    Stair.MaterialBlock = MaterialBlock()
    Stair.MaterialBlockThickness = Stair.MaterialBlock.Thickness
    if Stair.DrawWorkPoints then
      MarkAPoint(job, "Wpt4" , Wpt4,  3, "WP: Note String")
    end --if end
    job:Refresh2DView()       -- refresh the graphics to display the new objects.
    -- Tool Path

    if type(Stair.MillTool) == "userdata" then
   -- CreateLayerProfileToolpath(job, layer_name, name, start_depth, cut_depth, tool_dia, tool_stepdown, tool_in_mm)
      CreateLayerProfileToolpath(job,
                 Stair.StringerLayer,
                  "Profile Stringer",
                                 0.0,
        Stair.MaterialBlockThickness,
              Stair.MillTool.ToolDia,
             Stair.MillTool.Stepdown,
             false)
    end
  end
  return true

end  -- function end
-- ===================================================]]