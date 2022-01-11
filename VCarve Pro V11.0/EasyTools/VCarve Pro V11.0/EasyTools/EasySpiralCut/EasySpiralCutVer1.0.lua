-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- Easy Sprial Cut Maker is written by JimAndI Gadgets of Houston Texas 2021.

]]
-- ==================================================]]
-- Global Variables --
require("mobdebug").start()
-- require "strict"
local Spiral    = {}
Spiral.Version  = "(Ver: 1.0)"
Spiral.StockDia = 8.000
Spiral.FinshDIa = 7.500
Spiral.Length   = 24.000
Spiral.RapOn    = "X Axis"
Spiral.Serface  = "Center"
Spiral.SDK      = "https://jimandi.com/SDKWiki/index.php?title=Easy_SpiralCut-Page1"
Spiral.FileExt  = ".ncc"
Spiral.LinNum   = 190
local Tool_ID1 = ToolDBId()
Spiral.File = io.open(Spiral.Path .. "\\" "SpiralCut-" .. os.date("%Y%m%d%H%M") .. Spiral.FileExt, "w")
-- ====================================================]]
function InquiryPathBox(Header, Quest, DefaltPath)
--[[
    Number Box for user input with default value
    Caller: local X = InquiryPathBox("Select Path", "Where is the file location?", "C:\\")
    Dialog Header = "Tool Name"
    User Question = "Path name?"
    Default Value = "C:\\"
    Returns = String
  ]]
  local myHtml = [[ <html> <head> <title>Easy Tools</title> <style type = "text/css"> html {overflow: hidden; } body {
             background-color: #EBEBEB; overflow:hidden; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } body, td,
             th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ;
             width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }
             </style></head><body bgcolor = "#EBEBEB" text = "#000000"><table width = "470" border = "0" cellpadding = "0">
             <tr><th align = "left" valign = "top" bgcolor = "#EBEBEB" id = "QuestionID"><strong>Message Here</strong></th>
             <th align = "left" valign = "middle" bgcolor = "#EBEBEB"></th></tr><tr>
             <th width = "381" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID">
             <input name = "DInput" type = "text" id = "DInput" size = "60"></th>
             <th width = "83" align = "center" valign = "middle" bgcolor = "#EBEBEB"><span style="width: 15%">
             <input id = "DirectoryPicker" class = "DirectoryPicker" name = "DirectoryPicker" type = "button" value = "Path">
             </span></th></tr><tr><td colspan = "2" align = "center" valign = "middle" bgcolor = "#EBEBEB">
             <table border = "0" width = "100%"><tr align = "right"><td style = "width: 20%"></td>
             <td style = "width: 20%"></td><td style = "width: 25%"></td><td style = "width: 15%">
             <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td>
             <td style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK">
             </td></tr></table></td></tr></table></body></html>]]
  -- =============================================
  local dialog = HTML_Dialog(true, myHtml, 505, 150, Header)
    dialog:AddLabelField("QuestionID", Quest)
    dialog:AddTextField("DInput", DefaltPath )
    dialog:AddDirectoryPicker("DirectoryPicker",  "DInput",  true)
    if not dialog:ShowDialog() then
      return ""
    else
      return dialog:GetTextField("DInput")
    end -- if end
 end -- function end

-- ====================================================]]
function LineCount()
    Spiral.LinNum   = Spiral.LinNum  + 10
end
-- ====================================================]]
function StartDate(LongShort)
--[[
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
--  |    %Y  full year (1998)
--  |    %y  two-digit year (98) [00-99]
--  |    %%  the character `%´
]]
  if LongShort then
    return os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p")
  else
    return os.date("%Y%m%d%H%M")
  end
end
-- ====================================================]]
function GCodeWriterHeader(Cab)
  local file = io.open(Spiral.File, "a")
  file:write("=============================================================================================== \n")
  file:write("  Base Cabinet size\n")
 --[[
 file:write("( 6Handles )\n")
  file:write("( File created: Saturday November 21 2020 - 02:18 PM)\n")
  file:write("( for Mach2/3 from Vectric )\n")
  file:write("( Material Size)\n")
  file:write("( X= 76.000, Y= 5.500, Z= 1.000)\n")
  file:write("( Note: )\n")
  file:write("(Toolpaths used in this file:)\n")
  file:write("(Profile 1)\n")
  file:write("(Tools used in this file: )\n")
  file:write("(5 = End Mill {0.2500 inch} UpDown)\n")
  file:write("N100G00G20G17G90G40G49G80\n")
  file:write("N110G70G91.1\n")
  file:write("N120T5M06\n")
  file:write("N130 (Tool: End Mill {0.2500 inch} UpDown)\n")
  file:write("N140G00G43Z2.0000H5\n")
  file:write("N150S24000M03\n")
  file:write("N160(Toolpath:- Profile 1)\n")
  file:write("N170() \n")
  file:write("N180G94\n")
  file:write("N190X0.0000Y0.0000F90.0\n")
  --]]
  file:write("=============================================================================================== \n")
  file:close()
end
-- ====================================================]]
function GCodeWriterLineItem(ID, Num, Count, Thick, Material, Width, Length)
  local file = io.open(Spiral.File, "a")
  local sID = " " .. ID .. " "
  local sName     = string.sub("| ".. Num .. "                 ", 1, 6)
  local sCount    = string.sub("| ".. Count .."                                     ",1, 6)
  local sThick    = string.sub("| ".. Thick .."                                     ",1, 12)
  local sMaterial = string.sub("| ".. Material .."                                  ",1, 18)
  local sWidth    = string.sub("| ".. Width .."                                     ",1, 10)
  local sLength   = string.sub("| ".. Length .."                                    ",1, 9)
  file:write(sID .. sName .. sCount .. sThick .. sMaterial .. sWidth .. sLength .. "\n")
  file:close()
end
-- ====================================================]]
function GCodeWriterFooter()
  local file = io.open(Spiral.File, "a")
  file:write("=============================================================================================== \n")
  file:write("EOF \n")
  file:close()
end
--  ===================================================
function InquirySprialCutData(Header)
  local myHtml = [[<html><head><title>Easy Stair Maker</title><style type="text/css">html{overflow:hidden}.helpbutton{background-color:#E1E1E1;border:1px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:#000}.helpbutton:active{border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000}.helpbutton:hover{border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}.ToolPicker{font-weight:bold;text-align:center;font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center;width:50px}.ToolNameLabel{font-family:Arial,Helvetica,sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#00F}.LuaButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.FormButton{font-weight:bold;width:75px;font-family:Arial,Helvetica,sans-serif;font-size:12px}.h1-r{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:right}.h1-c{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:center}.h1-l{font-family:Arial,Helvetica,sans-serif;font-size:12px;text-align:left}body{background-color:#CCC;overflow:hidden}</style></head><body><table width="523" border="0" cellpadding="0"><tbody><tr><td width="107" class="h1-r" style="width: 20%;"><strong><span class="h1-r">Z Equals </span></strong></td><th width="360" valign="middle" class="h1-r" id="QuestionID1"><span class="h1-l"> <select name="Spiral.Serface" id="Spiral.Serface"><option>Serface</option><option selected>Center</option> </select> </span><th class="h1-l" align="left" valign="middle" width="53"></tr><tr><td class="h1-r" style="width: 20%;"><strong><span class="h1-r">Rap On </span></strong></td><th valign="middle" class="h1-r" id="QuestionID2"><span class="h1-l"> <select name="Spiral.RapOn" id="Spiral.RapOn"><option selected>X Axis</option><option>Y Axis</option> </select> </span><th class="h1-l" align="left" valign="middle" width="53"></td></tr><tr><td class="h1-r" style="width: 20%;"><strong><span class="h1-r">Stock Diameter </span></strong></td><th valign="middle" class="h1-r" id="QuestionID3"><span class="h1-l"> <input id="Spiral.StockDia" name="Spiral.StockDia" size="10" type="text" /> </span><th class="h1-l" align="left" valign="middle" width="53"></td></tr><tr><td class="h1-r" style="width: 20%;"><strong><span class="h1-r">Finsh Diameter </span></strong></td><th valign="middle" class="h1-r" id="QuestionID4"><span class="h1-l"> <input id="Spiral.FinshDia" name="Spiral.FinshDia" size="10" type="text" /> </span><th class="h1-l" align="left" valign="middle"></td></tr><tr><td class="h1-r" style="width: 20%;"><strong><span class="h1-r">Finsh Length </span></strong></td><th valign="middle" class="h1-r" id="QuestionID4"><span class="h1-l"> <input id="Spiral.Length" name="Spiral.Length" size="10" type="text" /> </span><th class="h1-l" align="left" valign="middle"></td></tr><tr><td colspan="3" align="center" valign="middle"><table border="0" width="100%"><tbody><tr align="right"><td width="15"><strong> <a href="]].. Spiral.SDK .. [[" target="_blank" class="helpbutton">Help</a></strong></td><td width="27%" style="width: 48%;">&nbsp;</td><td width="29%" style="width: 25%;"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel" /></td><td width="17%" style="width: 15%;"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK" /></td></tr></tbody></table></td></tr></tbody></table></body></html>]]
  local dialog = HTML_Dialog(true, myHtml, 330, 190, Header .. " " .. Spiral.Version)
  local diaValue = false
    dialog:AddDoubleField("Spiral.StockDia", Spiral.StockDia)
    dialog:AddDoubleField("Spiral.FinshDIa", Spiral.FinshDIa)
    dialog:AddDoubleField("Spiral.Length",   Spiral.Length)
    dialog:AddDropDownList("Spiral.Serface", Spiral.Serface)
    dialog:AddDropDownList("Spiral.RapOn",   "X Axis")

  if dialog:ShowDialog() then
    diaValue = true
  else
    diaValue = false
  end
  Spiral.StockDia = dialog:GetDoubleField("Spiral.StockDia")
  Spiral.FinshDIa = dialog:GetDoubleField("Spiral.FinshDIa")
  Spiral.Length   = dialog:GetDoubleField("Spiral.Length")
  Spiral.Serface  = dialog:GetDropDownListValue("Spiral.Serface")
  Spiral.RapOn    = dialog:GetDropDownListValue("Spiral.RapOn")
  Spiral.Tool     = dialog:GetTool("ToolChooseButton1")
  return diaValue
end

-- ===================================================
function main()
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n" )
    return false ;
  end
  local Loops = true     -- trap the while loop
  local Error = false    -- flag true if an error is found

  while Loops do
    Spiral.Inquiry = InquirySprialCutData("Sprial Cut Data")
    if Spiral.Inquiry then
      if Spiral.FinshDIa <= 0 then
        DisplayMessageBox("Error: The Finsh Diameter must be larger than '0.00'")
        Error = true
      end -- if end

      if Spiral.StockDia <= 0 then
        DisplayMessageBox("Error: The Stock Diameter must be larger than '0.00'")
        Error = true
      end -- if end

      if Spiral.FinshDIa > Spiral.StockDia then
        DisplayMessageBox("Error: The Finsh Diameter must be smaller than Stock Diameter")
        Error = true
      end -- if end

      if Spiral.FinshDIa == Spiral.StockDia then
        DisplayMessageBox("Error: The Cone Diameters cannot be equal")
        Error = true
      end -- if end

      if Spiral.Length <= 2 then
        DisplayMessageBox("Error: The Length value must be larger than '2.00'")
        Error = true
      end -- if end

      if not Spiral.Tool then
        DisplayMessageBox("Error: The No Milling Tool selected")
        Error = true
      end -- if end

      if not Spiral.Path then
        DisplayMessageBox("Error: The No Milling Tool selected")
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

  if Spiral.Inquiry then
    -- Do the math
    -- Write Gcode
  end

  return true
end  -- function end
-- ===================================================