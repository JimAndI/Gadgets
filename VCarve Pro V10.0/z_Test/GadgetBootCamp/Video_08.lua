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

  Stair = {}    -- builds table
  Trig = {}     -- Triangle function table

  Stair.AppName     = "Easy Stair Maker"                 -- Application Name
  Stair.Version     = "8.0"                              -- Application Build Version
  Stair.RegistryTag = "EasyStairMaker-" .. Stair.Version -- Registry Name with Versioning

  local Wpt0 = Point2D(6.0, 6.0)  -- lower left Basepoint
  local Wpt1 = Wpt0               -- lower workpoint
  local Wpt2 = Wpt0               -- Upper Right workpoint
  local Wpt3 = Wpt0               -- Lower Right workpoint
  local Wpt4 = Wpt0               -- Stringer Stock WP length
  local WptS = Wpt0               -- Step Loop calculation workpoint
  local WptR = Wpt0               -- Rise Loop calculation workpoint
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
    local Wp1 = Polar2D(Wpt1,  0.0, Stair.RiserThickness + Stair.TreadNoseing)    -- Establishes p1
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
-- ===================================================]]
function OnLuaButton_ButtonCalulate(dialog)             -- Executes the calculation function from the dialogue
  Stair.TreadNoseing = dialog:GetDoubleField("Stair.TreadNoseing")  
  Stair.RiserThickness = dialog:GetDoubleField("Stair.RiserThickness")  
  Stair.TreadThickness = dialog:GetDoubleField("Stair.TreadThickness")   
  Stair.StepCount = dialog:GetIntegerField("Stair.StepCount") 
  Stair.StringerWidth = dialog:GetDoubleField("Stair.StringerWidth")  
  Stair.RunDim = dialog:GetDoubleField("Stair.RunDim")  
  Stair.RiseDim = dialog:GetDoubleField("Stair.RiseDim") 
  --Stair.StepRise = dialog:GetDoubleField("Stair.StepRise")   
  --Stair.StepRun = dialog:GetDoubleField("Stair.StepRun")    
  Stair.DrawWorkPoints = dialog:GetCheckBox("Stair.DrawWorkPoints")    
  Stair.TreadLayer = dialog:GetTextField("Stair.TreadLayer")  
  Stair.RiserLayer    = dialog:GetTextField("Stair.RiserLayer")  
  Stair.StringerLayer = dialog:GetTextField("Stair.StringerLayer")
  
  Stair.Decimals = dialog:GetIntegerField("Stair.Decimals") 
  Stair.WriteBOM = dialog:GetCheckBox("Stair.WriteBOM") 
  Stair.BOMWritePath = dialog:GetTextField("Stair.BOMWritePath")
  -- perform calculations
  Stair.StepRun = Rounder(Stair.RunDim / Stair.StepCount, Stair.Decimals)          -- calculate the stair run (horizontal) dimension
  Stair.StepRise = Rounder(Stair.RiseDim / (Stair.StepCount + 1), Stair.Decimals)  -- calculate the stair rise (vertical) dimension
  
  -- update the dialogue with the new values
  dialog:UpdateDoubleField("Stair.StepRun", Stair.StepRun)
  dialog:UpdateDoubleField("Stair.StepRise", Stair.StepRise)
  return  true
end
-- ===================================================]]
function InquiryBox(Header)                             -- Displays a dialog box for user inputs
    local myHtml = [[<! ===========================================================>
    <! Jim Anderson Standard HTML Header>
    <! ===========================================================>
<html><head>
    <title>Easy Stair Maker</title>
    <style type="text/css">
    html {overflow: hidden;}
    .LuaButton {	font-weight: bold;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;}
    .FormButton {	font-weight: bold;	width: 75px;	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;}
    .h1-l {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:left;}
    .h1-r {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:right;}
    .h1-c {	font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	text-align:center;}
    body {	background-color: #CCC;	overflow:hidden;}
    </style></head><body>
    <! ===========================================================>
<table width="480" border="0">
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Stair Rise:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.RiseDim" type = "text" id = "Stair.RiseDim" size = "10" /></td>
    <td width="20" nowrap="nowrap">&nbsp;</td>
    <td width="102" align="right" nowrap="nowrap">&nbsp;</td>
    <td width="102" nowrap="nowrap">&nbsp;</td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Stair Run:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.RunDim" type = "text" id = "Stair.RunDim" size = "10" /></td>
    <td colspan="3" align="center" nowrap="nowrap"><span style="width: 20%">
      <input id = "ButtonCalulate"                    
          class = "LuaButton" 
          name = "ButtonCalulate" 
          type = "button" 
          value = "Calulate"/>
    </span></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Tread Count:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.StepCount" type = "text" id = "Stair.StepCount" size = "10" /></td>
    <td align="center" nowrap="nowrap">&nbsp;</td>
    <td align="center" nowrap="nowrap" class="h1-r">Decimals:</td>
    <td align="left" nowrap="nowrap" class="h1-l"><input name = "Stair.Decimals" type = "text" id = "Stair.Decimals" value="4" size = "10" /></td>
  </tr>
  <tr>
    <td colspan="5" align="right" nowrap="nowrap" class="h1-r"><hr></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r"><span class="h1-c">Riser Higth</span>:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.StepRise" type = "text" id = "Stair.StepRise" size = "10" readonly /></td>
    <td width="20" align="center" nowrap="nowrap" class="h1-c">&nbsp;</td>
    <td width="102" align="center" nowrap="nowrap" class="h1-r">Tread Width:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.StepRun" type = "text" id = "Stair.StepRun" size = "10" readonly /></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Riser Thickness:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.RiserThickness" type = "text" id = "Stair.RiserThickness" size = "10" /></td>
    <td width="20" nowrap="nowrap">&nbsp;</td>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Tread Thickness:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.TreadThickness" type = "text" id = "Stair.TreadThickness" size = "10" /></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Stringer Width:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.StringerWidth" type = "text" id = "Stair.StringerWidth" size = "10" /></td>
    <td width="20" nowrap="nowrap">&nbsp;</td>
    <td width="102" align="center" nowrap="nowrap" class="h1-r">Noseing:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.TreadNoseing" type = "text" id = "Stair.TreadNoseing" size = "10" /></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Tread Layer:</td>
    <td nowrap="nowrap"><input name = "Stair.TreadLayer" type = "text" id = "Stair.TreadLayer" size = "15" maxlength="25" /></td>
    <td width="20" nowrap="nowrap">&nbsp;</td>
    <td width="102" align="center" nowrap="nowrap" class="h1-r">Stringer Layer:</td>
    <td width="102" nowrap="nowrap"><input name = "Stair.StringerLayer" type = "text" id = "Stair.StringerLayer" size = "15" maxlength="25" /></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Riser Layer:</td>
    <td nowrap="nowrap"><input name = "Stair.RiserLayer" type = "text" id = "Stair.RiserLayer" size = "15" maxlength="25" /></td>
    <td width="20" nowrap="nowrap">&nbsp;</td>
    <td width="102" align="center" nowrap="nowrap" class="h1-r">BOM:</td>
    <td width="102" nowrap="nowrap"><input type="checkbox" name="Stair.WriteBOM" id="Stair.WriteBOM"></td>
  </tr>
  <tr>
    <td width="102" align="right" nowrap="nowrap" class="h1-r">Stringer Layer:</td>
    <td colspan="4" nowrap="nowrap"><input name = "Stair.BOMWritePath" type = "text" id = "Stair.BOMWritePath" size = "52" readonly />
      <span style="width: 20%">
      <input id = "ButtonBOMPath"                    
          class = "DirectoryPicker" 
          name = "ButtonBOMPath" 
          type = "button" 
          value = "Path"/>
    </span></td>
  </tr>
  <tr>
    <td colspan="5" nowrap="nowrap"><hr></td>
  </tr>  
  <tr>
    <td width="102" align="center" nowrap="nowrap"><strong><a href="https://www.youtube.com/channel/UCSM4fWwTIvVI91nTzIe554Q" target="_blank" class="h1-c">Video</a></strong></td>
    <td width="102" align="right" nowrap="nowrap"><span class="h1-r">Show WPs'</span></td>
    <td width="20" nowrap="nowrap"><input type="checkbox" name="Stair.DrawWorkPoints" id="Stair.DrawWorkPoints"></td>
    <td width="102" align="center" nowrap="nowrap"><span style="width: 20%">
      <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel" />
      </span></td>
    <td width="102" align="center" nowrap="nowrap"><span style="width: 15%">
      <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK" />
      </span></td>
  </tr> </table>
  <! ==============================================>
</body></html>]] 
    local dialog = HTML_Dialog(true, myHtml, 530, 390, Header)  ; 
    dialog:AddDoubleField("Stair.TreadNoseing", Stair.TreadNoseing)  ; 
    dialog:AddDoubleField("Stair.RiserThickness", Stair.RiserThickness)  ; 
    dialog:AddDoubleField("Stair.TreadThickness", Stair.TreadThickness)  ; 
    dialog:AddDoubleField("Stair.StringerWidth", Stair.StringerWidth)  ; 
    dialog:AddIntegerField("Stair.Decimals", Stair.Decimals)  ; 
    dialog:AddDoubleField("Stair.RunDim", Stair.RunDim)  ; 
    dialog:AddDoubleField("Stair.RiseDim", Stair.RiseDim)  ; 
    dialog:AddDoubleField("Stair.StepRise", Stair.StepRise)  ; 
    dialog:AddDoubleField("Stair.StepRun", Stair.StepRun)  ;  
    dialog:AddCheckBox("Stair.DrawWorkPoints", Stair.DrawWorkPoints)
    dialog:AddTextField("Stair.TreadLayer", Stair.TreadLayer)  ; 
    dialog:AddTextField("Stair.RiserLayer", Stair.RiserLayer)  ; 
    dialog:AddTextField("Stair.StringerLayer", Stair.StringerLayer)  ; 
    
    dialog:AddIntegerField("Stair.StepCount", Stair.StepCount)  ;
    dialog:AddCheckBox("Stair.WriteBOM", Stair.WriteBOM) ;
    dialog:AddTextField("Stair.BOMWritePath", Stair.BOMWritePath)  ; 
    dialog:AddDirectoryPicker("ButtonBOMPath", "Stair.BOMWritePath", true);
    
    if dialog:ShowDialog() then
      Stair.TreadNoseing = dialog:GetDoubleField("Stair.TreadNoseing")  
      Stair.RiserThickness = dialog:GetDoubleField("Stair.RiserThickness")  
      Stair.TreadThickness = dialog:GetDoubleField("Stair.TreadThickness")   
      Stair.StepCount = dialog:GetIntegerField("Stair.StepCount") 
      Stair.StringerWidth = dialog:GetDoubleField("Stair.StringerWidth")  
      Stair.RunDim = dialog:GetDoubleField("Stair.RunDim")  
      Stair.RiseDim = dialog:GetDoubleField("Stair.RiseDim") 
      Stair.StepRise = dialog:GetDoubleField("Stair.StepRise")   
      Stair.StepRun = dialog:GetDoubleField("Stair.StepRun")    
      Stair.DrawWorkPoints = dialog:GetCheckBox("Stair.DrawWorkPoints")    
      Stair.TreadLayer = dialog:GetTextField("Stair.TreadLayer")  
      Stair.RiserLayer    = dialog:GetTextField("Stair.RiserLayer")  
      Stair.StringerLayer = dialog:GetTextField("Stair.StringerLayer")       
      
      Stair.Decimals     = dialog:GetIntegerField("Stair.Decimals")  
      Stair.WriteBOM     = dialog:GetCheckBox("Stair.WriteBOM") 
      Stair.BOMWritePath = dialog:GetTextField("Stair.BOMWritePath")  
      return true
    else
      return false
    end
    
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
function main(script_path)                              -- Gadget starting point
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
  ]]
-- Localized Variables --
 
  local Layer = ""  -- establishes a variable called layer
  local WPrad = 0.0  -- establishes a variable called WPrad
  
-- Job Validation --
  local job = VectricJob()  -- searches for instance validate a job has been set up
  if not job.Exists then    -- validates if a setup has been performed
    DisplayMessageBox("Error: No job loaded") -- tell the user they have not set the job
    return false ; -- stop the program
  end  -- if end

-- Get Data --
  ReadRegistry()             -- First thing: Get/Reads all data values from the Registry
  -- User input Dialogue --
  
  if InquiryBox(Stair.AppName .. " Version " .. Stair.Version) then
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
    
    if Stair.DrawWorkPoints then  
      MarkAPoint(job, "Wpt4" , Wpt4,  3, "WP: Note String")      
    end --if end
    job:Refresh2DView()       -- refresh the graphics to display the new objects.
  end
  return true

end  -- function end
-- ===================================================]]