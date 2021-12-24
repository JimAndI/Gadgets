-- VECTRIC LUA SCRIPT
-- =====================================================]]
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
-- 2. If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 3. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 4. This notice may not be removed or altered from any source distribution.
-- Easy Seed Gadget Master is written by Jim Anderson of Houston Texas 2020
-- =====================================================]]
-- Mode Settings (mobdebug or strict)
  require("mobdebug").start()  -- For Debuging Mode
--require "strict"             -- For Regular Mode
-- =====================================================]]
function DisplayTest(words)
-- Global Variables --
local Tools

-- Table Names
Customer = {}
Project = {}
Room = {}
Door = {}
DialogWindow = {}
DialogWindow.ProgramName = "Steves Door Maker"
Door.SDK = "https://www.jimandi.com/EasyGadgets/EasyDrawerMaker/EasyDrawerMakerHelp.html"
Door.ProgramVersion = 3.1
Door.WP = Point2D(1, 1)
Door.RegName = "StevesDoorMaker" .. string.format(Door.ProgramVersion)

function InquiryMain()
  dialog = HTML_Dialog(true, DialogWindow.Main, 635, 351, "MDF Door Maker Main Screen (Ver: " .. string.format(Door.ProgramVersion) .. ")")
  Door.Alert = ""
  --Door.Style = StyleA.Name
  if Door.Count == 0 then Door.Count = 1 end
  Door.RuntimeLog = "CSVImportErrorLog" .. StartDateTime(false)
  dialog:AddLabelField("Door.Alert", Door.Alert)
  dialog:AddDropDownList("DoorStyle", Door.Style)
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

-- =====================================================]]
function DisplayTest(words)
  -- test a sub fuction
    DisplayMessageBox(words)
	return true
end -- function end

-- =====================================================]]
function main(script_path)
  Door.job = VectricJob()
  if not Door.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  Tools = assert(loadfile(script_path .. "\\SteveDoorTools.lua")) (Tools)
  HTML()
  GetMaterialSettings()

  GetUnits()
  Registry_Read()
  Project.LoadDate = StartDate(false)
  Door.UnitDisplay = "Note: Units: (" .. Door.Units ..")"
  HTML()           -- Load the Dialog HTML data
  if InquiryMain() then

  end -- if end
  return true
end  -- function end
-- =====================================================]]