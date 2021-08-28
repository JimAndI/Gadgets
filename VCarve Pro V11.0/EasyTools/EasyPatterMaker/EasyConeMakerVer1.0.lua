-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy Truncated Cone Maker is written by JimAndI Gadgets of Houston Texas 2021. The website templatemaker.nl (COPYRIGHT 2019 by: 
   M. H. van der Velde) was referenced in the development of this gadget. 
]]
-- ==================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Cone = {}
Cone.Version  = "(Ver: 1.1)"
Cone.Gpt0     = Point2D(1, 1)
Cone.BaseDia  = 6.000
Cone.TopDia   = 3.000
Cone.TopAngle = 90.000
Cone.Height   = 9.000
Cone.FlapSize = 0.500

-- ===================================================
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  ===================================================
function InquiryConeData(Header)
  local myHtml = [[<html><head><title>Easy Stair Maker</title><style type="text/css">html{overflow:hidden}.LuaButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center}body{background-color:#CCC;overflow:hidden}</style></head><body><table border="0" width="296" cellpadding="0"><tbody><tr><th width="381" align="right" valign="middle" class="h1-r" id="QuestionID1">Top Diameter</td><th class="h1-l" align="left" valign="middle" width="83"><input id="Cone.TopDia" name="Cone.TopDia" size="10" type="text" /></td></tr><tr> <th align="right" valign="middle" class="h1-r" id="QuestionID2">Base Diameter</td><th class="h1-l" align="left" valign="middle"><input id="Cone.BaseDia" name="Cone.BaseDia" size="10" type="text" /></td></tr><tr><th align="right" valign="middle" class="h1-r" id="QuestionID4">Cone Height <th class="h1-l" align="left" valign="middle"><input id="Cone.Height" name="Cone.Height" size="10" type="text" /></td></tr><tr><th align="right" valign="middle" class="h1-r" id="QuestionID5">Flap Size<th class="h1-l" align="left" valign="middle"><input id="Cone.FlapSize" name="Cone.FlapSize" size="10" type="text" /></td></tr><tr><td colspan="2" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td style="width: 20%;">&nbsp;</td><td style="width: 20%;">&nbsp;</td><td style="width: 25%;">&nbsp;</td><td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 330, 190, Header .. " " .. Cone.Version) ;

    dialog:AddDoubleField("Cone.BaseDia",  Cone.BaseDia)
    dialog:AddDoubleField("Cone.TopDia",   Cone.TopDia)
    dialog:AddDoubleField("Cone.Height",   Cone.Height)
    dialog:AddDoubleField("Cone.FlapSize", Cone.FlapSize)

  if not dialog:ShowDialog() then
    Cone.BaseDia  = dialog:GetDoubleField("Cone.BaseDia")
    Cone.TopDia   = dialog:GetDoubleField("Cone.TopDia")
    Cone.Height   = dialog:GetDoubleField("Cone.Height")
    Cone.FlapSize = dialog:GetDoubleField("Cone.FlapSize")
    return false
  else
    Cone.BaseDia  = dialog:GetDoubleField("Cone.BaseDia")
    Cone.TopDia   = dialog:GetDoubleField("Cone.TopDia")
    Cone.Height   = dialog:GetDoubleField("Cone.Height")
    Cone.FlapSize = dialog:GetDoubleField("Cone.FlapSize")
    return true
  end
end
-- ===================================================
function DrawConeNoFlap(job)
  local line  = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Truncated Cone")
  line:AppendPoint(Cone.Gpt1)
  line:LineTo(Cone.Gpt3)
  line:ArcTo(Cone.Gpt4, Cone.BottomRadusBulge)
  line:LineTo(Cone.Gpt2)
  line:ArcTo(Cone.Gpt1, Cone.TopRadusBulge * -1)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ===================================================
function DrawConeFlap(job)
  local line  = Contour(0.0)
  local layer = job.LayerManager:GetLayerWithName("Truncated Cone")
  line:AppendPoint(Cone.Gpt1)
  line:LineTo(Cone.Gpt5)
  line:LineTo(Cone.Gpt6)
  line:LineTo(Cone.Gpt3)
  line:ArcTo(Cone.Gpt4, Cone.BottomRadusBulge)
  line:LineTo(Cone.Gpt2)
  line:ArcTo(Cone.Gpt1, Cone.TopRadusBulge * -1)
  layer:AddObject(CreateCadContour(line), true)
  job:Refresh2DView()
  return true
end
-- ===================================================
function Arc2Bulge(p1, p2, Rad)
    local chord = math.sqrt(((p2.x - p1.x) ^ 2) + ((p2.y - p1.y) ^ 2))
    local seg = (Rad - (0.5 * (math.sqrt((4.0 * Rad^2) - chord^2))))
    local bulge = (2 * seg) / chord
    return bulge
  end -- function end
-- ===================================================
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n"
    )
    return false ;
  end
  local Loops = true     -- trap the while loop 
  local Error = false    -- flag true if an error is found
  while Loops do
    Cone.Inquiry = InquiryConeData("Truncated Cone Data")
    if Cone.Inquiry then
      if Cone.TopDia <= 0 then
        DisplayMessageBox("Error: The Top Diameter must be larger than '0.00'")
        Error = true
      end -- if end
      
      if Cone.BaseDia <= 0 then
        DisplayMessageBox("Error: The Base Diameter must be larger than '0.00'")
        Error = true
      end -- if end
      
      if Cone.Height <= 0 then
        DisplayMessageBox("Error: The Cone Height must be larger than '0.00'")
        Error = true
      end -- if end
      
      if Cone.FlapSize > (Cone.Height * 0.25) then
        DisplayMessageBox("Error: The Flap Size must be smaller than 1/4 Height")
        Error = true
      end -- if end
      
      if Error then
        Loops = true    -- stay in the while loop
        Error = false   -- reset the error trap
      else
        Loops = false   -- exit while loop
      end -- if end
    else
      Loops = false
    end -- if end
  end -- while end

  if Cone.Inquiry then
    Cone.TopRadus = math.sqrt(((0.5 * Cone.BaseDia) - (0.5 * Cone.TopDia)) ^ 2 + (Cone.Height * Cone.Height))
    Cone.L = math.pi * Cone.TopDia
    Cone.M = math.pi * Cone.BaseDia
    Cone.P = (Cone.L * Cone.TopRadus) / (Cone.M - Cone.L)
    Cone.Angle = math.deg(Cone.L / Cone.P)
    Cone.BottomRadus = Cone.P + Cone.TopRadus
    Cone.FlapSlope = Cone.FlapSize / math.sin(math.rad(45.0))
-- == Points =====
    Cone.Gpt1 = Polar2D(Cone.Gpt0,         0.0, Cone.TopRadus)
    Cone.Gpt2 = Polar2D(Cone.Gpt0,  Cone.Angle, Cone.TopRadus)
    Cone.Gpt3 = Polar2D(Cone.Gpt0,         0.0, Cone.BottomRadus)
    Cone.Gpt4 = Polar2D(Cone.Gpt0,  Cone.Angle, Cone.BottomRadus)
    Cone.Gpt5 = Polar2D(Cone.Gpt1,       315.0, Cone.FlapSlope)
    Cone.Gpt6 = Polar2D(Cone.Gpt3,       225.0, Cone.FlapSlope)
    Cone.TopRadusBulge    = Arc2Bulge(Cone.Gpt1, Cone.Gpt2, Cone.TopRadus)
    Cone.BottomRadusBulge = Arc2Bulge(Cone.Gpt3, Cone.Gpt4, Cone.BottomRadus)
-- == Drawing =====
    if Cone.FlapSize > 0.0 then
      DrawConeFlap(job)
    else
      DrawConeNoFlap(job)
    end
  end
  return true
end  -- function end
-- ===================================================