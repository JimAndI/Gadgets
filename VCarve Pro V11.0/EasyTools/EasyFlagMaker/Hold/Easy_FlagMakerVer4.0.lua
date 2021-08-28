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
-- =====================================================]]
-- Global Variables --
-- require("mobdebug").start()
require "strict"
local Flag = {}
local DialogWindow = {}
Flag.Gpt1 =  Point2D(1, 1)
Flag.HoistFlag = 30.0
Flag.Name = "Flag Name"
Flag.Version = "(Ver: 4.0)"
Flag.FlyFlag = 2.0
DialogWindow.FlagImage = [[]]
-- =====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- =====================================================]]
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
-- =====================================================]]
function DrawFlag(job)

Flag.States = {"Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Marshall Islands", "Massachusetts", "Michigan", "Micronesia", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Northern Mariana Islands", "Ohio", "Oklahoma", "Oregon", "Palau", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Virgin Islands", "Washington", "West Virginia", "Wisconsin", "Wyoming",}



  Flag.Name00001     = "Alabama"
  Flag.Name00002     = "Alaska"
  Flag.Name00003     = "American Samoa"
  Flag.Name00004     = "Arizona"
  Flag.Name00005     = "Arkansas"
  Flag.Name00006     = "California"
  Flag.Name00007     = "Colorado"
  Flag.Name00008     = "Connecticut"
  Flag.Name00009     = "Delaware"
  Flag.Name00010     = "District of Columbia"
  Flag.Name00011     = "Florida"
  Flag.Name00012     = "Georgia"
  Flag.Name00013     = "Guam"
  Flag.Name00014     = "Hawaii"
  Flag.Name00015     = "Idaho"
  Flag.Name00016     = "Illinois"
  Flag.Name00017     = "Indiana"
  Flag.Name00018     = "Iowa"
  Flag.Name00019     = "Kansas"
  Flag.Name00020     = "Kentucky"
  Flag.Name00021     = "Louisiana"
  Flag.Name00022     = "Maine"
  Flag.Name00023     = "Maryland"
  Flag.Name00024     = "Marshall Islands"
  Flag.Name00025     = "Massachusetts"
  Flag.Name00026     = "Michigan"
  Flag.Name00027     = "Micronesia"
  Flag.Name00028     = "Minnesota"
  Flag.Name00029     = "Mississippi"
  Flag.Name00030     = "Missouri"
  Flag.Name00031     = "Montana"
  Flag.Name00032     = "Nebraska"
  Flag.Name00033     = "Nevada"
  Flag.Name00034     = "New Hampshire"
  Flag.Name00035     = "New Jersey"
  Flag.Name00036     = "New Mexico"
  Flag.Name00037     = "New York"
  Flag.Name00038     = "North Carolina"
  Flag.Name00039     = "North Dakota"
  Flag.Name00040     = "Northern Mariana Islands"
  Flag.Name00041     = "Ohio"
  Flag.Name00042     = "Oklahoma"
  Flag.Name00043     = "Oregon"
  Flag.Name00044     = "Palau"
  Flag.Name00045     = "Pennsylvania"
  Flag.Name00046     = "Puerto Rico"
  Flag.Name00047     = "Rhode Island"
  Flag.Name00048     = "South Carolina"
  Flag.Name00049     = "South Dakota"
  Flag.Name00050     = "Tennessee"
  Flag.Name00051     = "Texas"
  Flag.Name00052     = "Utah"
  Flag.Name00053     = "Vermont"
  Flag.Name00054     = "Virginia"
  Flag.Name00055     = "Virgin Islands"
  Flag.Name00056     = "Washington"
  Flag.Name00057     = "West Virginia"
  Flag.Name00058     = "Wisconsin""
  Flag.Name00059     = "Wyoming


end -- function end
-- =====================================================]]
function RegistryWrite()                                -- Write to Registry values
  local RegistryWrite = Registry("RegName")
  local RegValue
  --[[
  RegValue = RegistryWrite:SetBool("ProjectQuestion.CabinetName", true)
  RegValue = RegistryWrite:SetDouble("BaseDim.CabDepth", 23.0000)
  RegValue = RegistryWrite:SetInt("BaseDim.CabHeight", 35)
  RegValue = RegistryWrite:SetString("BaseDim.CabLength", "Words")
  ]]


  RegValue = RegistryWrite:SetString("Flag.Name00001", Flag.Name00001)
  RegValue = RegistryWrite:SetString("Flag.Name00002", Flag.Name00002)
  RegValue = RegistryWrite:SetString("Flag.Name00003", Flag.Name00003)
  RegValue = RegistryWrite:SetString("Flag.Name00004", Flag.Name00004)
  RegValue = RegistryWrite:SetString("Flag.Name00005", Flag.Name00005)
  RegValue = RegistryWrite:SetString("Flag.Name00006", Flag.Name00006)
  RegValue = RegistryWrite:SetString("Flag.Name00007", Flag.Name00007)
  RegValue = RegistryWrite:SetString("Flag.Name00008", Flag.Name00008)
  RegValue = RegistryWrite:SetString("Flag.Name00009", Flag.Name00009)
  RegValue = RegistryWrite:SetString("Flag.Name00010", Flag.Name00010)
  RegValue = RegistryWrite:SetString("Flag.Name00011", Flag.Name00011)
  RegValue = RegistryWrite:SetString("Flag.Name00012", Flag.Name00012)
  RegValue = RegistryWrite:SetString("Flag.Name00013", Flag.Name00013)
  RegValue = RegistryWrite:SetString("Flag.Name00014", Flag.Name00014)
  RegValue = RegistryWrite:SetString("Flag.Name00015", Flag.Name00015)
  RegValue = RegistryWrite:SetString("Flag.Name00016", Flag.Name00016)
  RegValue = RegistryWrite:SetString("Flag.Name00017", Flag.Name00017)
  RegValue = RegistryWrite:SetString("Flag.Name00018", Flag.Name00018)
  RegValue = RegistryWrite:SetString("Flag.Name00019", Flag.Name00019)
  RegValue = RegistryWrite:SetString("Flag.Name00020", Flag.Name00020)
  RegValue = RegistryWrite:SetString("Flag.Name00021", Flag.Name00021)
  RegValue = RegistryWrite:SetString("Flag.Name00022", Flag.Name00022)
  RegValue = RegistryWrite:SetString("Flag.Name00023", Flag.Name00023)
  RegValue = RegistryWrite:SetString("Flag.Name00024", Flag.Name00024)
  RegValue = RegistryWrite:SetString("Flag.Name00025", Flag.Name00025)
  RegValue = RegistryWrite:SetString("Flag.Name00026", Flag.Name00026)
  RegValue = RegistryWrite:SetString("Flag.Name00027", Flag.Name00027)
  RegValue = RegistryWrite:SetString("Flag.Name00028", Flag.Name00028)
  RegValue = RegistryWrite:SetString("Flag.Name00029", Flag.Name00029)
  RegValue = RegistryWrite:SetString("Flag.Name00030", Flag.Name00030)





end -- function end
-- =====================================================]]
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n")
    return false ;
  end
  local Loops = true
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
-- =====================================================]]