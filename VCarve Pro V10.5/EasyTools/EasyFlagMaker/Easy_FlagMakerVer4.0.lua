-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented ; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy Flag Maker is written by JimAndi Gadgets of Houston Texas 2019
]]
-- ==================================================]]
-- Global Variables --
require("mobdebug").start()
-- require "strict"
local Flag = {}
local DialogWindow = {}
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Name = "Flag Name"
Flag.Version = "(Ver: 4.0)"
Flag.FlyFlag = 2.0
DialogWindow.FlagImage = [[]]
-- ===================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
--  ===================================================
function InquiryFlagSize(Header, Quest, Defaltxt)
--[[
-- nquiryNumberBox for user input with default number value
-- Caller: local x = InquiryNumberBox("Cabinet Maker", "Enter the cabinet height", 30.0)
-- Dialog Header: "Cabinet Maker"
-- User Question: "Enter the cabinet height"
-- Default value = 30.0
-- Returns = double
]]
  local myHtml = [[<html><head><title>Easy Stair Maker</title><style type="text/css">html {overflow: hidden;}.FormButton {font-weight: bold;width: 75px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;}.h1-r {font-family: Arial, Helvetica, sans-serif;font-size: 12px;text-align:right;}body {overflow:hidden;}</style><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body bgcolor="#CCCCCC"><table border="0" width="259" cellpadding="0"> <tbody> <tr> <td height="132" colspan="2" align="left" valign="top" id="QuestionID2"><img src="]].. DialogWindow.FlagImage ..[[" width="260" height="120"> </tr> <tr> <td width="199" height="22" align="right" valign="middle" class="h1-r" id="QuestionID">Message Here </td> <td class="h1-l" align="left" valign="middle" width="113"><input id="qInput" name="qInput" size="10" type="text" /> </td> </tr> <tr> <td colspan="2" align="center" valign="middle"><table border="0" width="100%"> <tbody> <tr align="right"> <td height="25" style="width: 10%;">&nbsp;</td> <td>&nbsp;</td> <td style="width: 10%;">&nbsp;</td> <td style="width: 15%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td> <td style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td> </tr> </tbody> </table></td> </tr> </tbody></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 300, 260, Header .. " " .. Flag.Version) ;
  dialog:AddLabelField("QuestionID", Quest) ;
  dialog:AddDoubleField("qInput", Defaltxt) ;
  if not dialog:ShowDialog() then
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return false
  else
    Flag.HoistFlag = dialog:GetDoubleField("qInput")
    return true
  end
end
-- ===================================================]]
function DrawFlag(job)

  return true
end
-- ===================================================]]
function main(script_path)
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n")
    return false ;
  end
  local Loops = true
  Jim = assert(loadfile(script_path .. "\\Jim.lua")); Jim()
  DisplayMessageBox( Bob("Tim"))
  DisplayMessageBox( Will("Tim2"))
  while Loops do
    Flag.Inquiry = InquiryFlagSize(Flag.Name .. " Flag Maker", "Enter the " .. Flag.Name .. " Flag Height", Flag.HoistFlag)
    if Flag.Inquiry then
      if Flag.HoistFlag > 0 then
        Loops = false
      else
        DisplayMessageBox("Error: The Flag hight must be larger than '0.00'")
        Loops = true
      end -- if end
    else
      Loops = false
    end -- if end
  end -- while end
  if (Flag.Inquiry and (Flag.HoistFlag > 0)) then
    DrawFlag(job)
  end
  return true
end  -- function end
-- ===================================================]]