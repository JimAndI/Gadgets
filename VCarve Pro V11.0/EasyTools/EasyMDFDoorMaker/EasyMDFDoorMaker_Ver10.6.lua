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
      Project       = {}
      Door          = {}
      Milling       = {}
      Panel         = {}
      DialogWindow  = {}   -- Dialog Management
      StyleA        = {}
      StyleB        = {}
      StyleC        = {}
      StyleE        = {}
      StyleF        = {}
      StyleG        = {}
local Tools1, Tools2, Tools3, Tools4, Tools5
-- local dialog

Tool_ID1 = ToolDBId()
Tool_ID2 = ToolDBId()
Tool_ID3 = ToolDBId()
Tool_ID4 = ToolDBId()
Tool_ID5 = ToolDBId()
Tool_ID6 = ToolDBId()
Tool_ID7 = ToolDBId()
Tool_ID8 = ToolDBId()
Tool_ID9 = ToolDBId()
local MyProgressBar
--[[
Tool_ID1:LoadDefaults(RegName, "Tool1")
Tool_ID2:LoadDefaults(RegName, "Tool2")
Tool_ID3:LoadDefaults(RegName, "Tool3")
Tool_ID4:LoadDefaults(RegName, "Tool4")
Tool_ID5:LoadDefaults(RegName, "Tool5")
Tool_ID6:LoadDefaults(RegName, "Tool6")
Tool_ID7:LoadDefaults(RegName, "Tool7")
Tool_ID8:LoadDefaults(RegName, "Tool8")
Tool_ID9:LoadDefaults(RegName, "Tool9")
]]
Door.Style          = ""
Door.Height         = 0.0
Door.Width          = 0.0
Door.Row            = 0.0
Door.RowCount       = 1
Door.Records        = 1
Door.pt01 = Point2D(0,0)
DialogWindow.ProjectSDK = "http://www.jimandi.com/EasyGadgets/EasyMDFDoorMaker/EasyMDFDoorMakerHelp.html"
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
function InquiryMain()
  local dialog = HTML_Dialog(true, DialogWindow.Main, 535, 614, "Easy MDF Door Maker Ver(" .. Version .. ") " .. Door.Units)
  Door.Alert = ""
  if Door.Count == 0 then Door.Count = 1 end
  Door.RuntimeLog = "CSVImportErrorLog" .. StartDateTime(false)
  dialog:AddLabelField("Door.Alert",  Door.Alert)
  dialog:AddDropDownList("DoorStyle", Door.Style)
  dialog:AddDropDownList("Door.ScribeLines",  Door.ScribeLines)
  dialog:AddDropDownListValue("DoorStyle", StyleA.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleB.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleC.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleE.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleF.Name)
  dialog:AddDropDownListValue("DoorStyle", StyleG.Name)
  dialog:AddLabelField("ReadFile",     Door.CSVFile)
  dialog:AddIntegerField("Door.Count", Door.Count)
  dialog:AddDoubleField("Door.X",      Door.X)
  dialog:AddDoubleField("Door.Y",      Door.Y)
  dialog:AddDoubleField("Door.Width",  Door.Width)
  dialog:AddDoubleField("Door.Height", Door.Height)
  dialog:AddFilePicker(true, "FilePicker",  "ReadFile", false)
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
  dialog:AddToolPickerValidToolType("ToolChooseButton7",      Tool.END_MILL)

  dialog:AddLabelField("ToolNameLabel8",                      Milling.MillTool8.Name) -- Corner Cleaning Bit
  dialog:AddToolPicker("ToolChooseButton8", "ToolNameLabel8", Tool_ID8)
  dialog:AddToolPickerValidToolType("ToolChooseButton8",      Tool.BALL_NOSE)

  dialog:AddLabelField("ToolNameLabel9",                      Milling.MillTool9.Name) -- Fluting Bit
  dialog:AddToolPicker("ToolChooseButton9", "ToolNameLabel9", Tool_ID9)
  dialog:AddToolPickerValidToolType("ToolChooseButton9",      Tool.FORM_TOOL)
  dialog:ShowDialog()
  if dialog:GetTool("ToolChooseButton1") then
    -- Tool_ID1:SaveDefaults(RegName, "Tool1")
    Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile Bit
    DisplayMessageBox("Name "  .. Milling.MillTool1.ToolTypeText)
  end
  if dialog:GetTool("ToolChooseButton2") then
    -- Tool_ID2:SaveDefaults(RegName, "Tool2")
    Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Pocket Bit
  end
  if dialog:GetTool("ToolChooseButton3") then
    -- Tool_ID3:SaveDefaults(RegName, "Tool3")
    Milling.MillTool3 = dialog:GetTool("ToolChooseButton3")  -- Pocket Clearing Bit
  end
  if dialog:GetTool("ToolChooseButton4") then
    -- Tool_ID4:SaveDefaults(RegName, "Tool4")
    Milling.MillTool4 = dialog:GetTool("ToolChooseButton4")  -- Raised Panel Bit
  end
  if dialog:GetTool("ToolChooseButton5") then
    -- Tool_ID5:SaveDefaults(RegName, "Tool5")
    Milling.MillTool5 = dialog:GetTool("ToolChooseButton5")  -- Inside Edge Bit
  end
  if dialog:GetTool("ToolChooseButton6") then
    -- Tool_ID6:SaveDefaults(RegName, "Tool6")
    Milling.MillTool6 = dialog:GetTool("ToolChooseButton6")  -- Outside Edge Bit
  end
  if dialog:GetTool("ToolChooseButton7") then
    -- Tool_ID7:SaveDefaults(RegName, "Tool7")
    Milling.MillTool7 = dialog:GetTool("ToolChooseButton7")  -- Scribe Lines Bit
  end
  if dialog:GetTool("ToolChooseButton8") then
    -- Tool_ID8:SaveDefaults(RegName, "Tool8")
    Milling.MillTool8 = dialog:GetTool("ToolChooseButton8")  -- Corner Cleaning Bit
  end
  if dialog:GetTool("ToolChooseButton9") then
    -- Tool_ID9:SaveDefaults(RegName, "Tool9")
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
  if dialog:GetTool("ToolChooseButton1") then
    -- Tool_ID1:SaveDefaults(RegName, "Tool1")
    Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile Bit
  end
  if dialog:GetTool("ToolChooseButton2") then
    -- Tool_ID2:SaveDefaults(RegName, "Tool2")
    Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Pocket Bit
  end
  if dialog:GetTool("ToolChooseButton3") then
    -- Tool_ID3:SaveDefaults(RegName, "Tool3")
    Milling.MillTool3 = dialog:GetTool("ToolChooseButton3")  -- Pocket Clearing Bit
  end
  if dialog:GetTool("ToolChooseButton4") then
    -- Tool_ID4:SaveDefaults(RegName, "Tool4")
    Milling.MillTool4 = dialog:GetTool("ToolChooseButton4")  -- Raised Panel Bit
  end
  if dialog:GetTool("ToolChooseButton5") then
    -- Tool_ID5:SaveDefaults(RegName, "Tool5")
    Milling.MillTool5 = dialog:GetTool("ToolChooseButton5")  -- Inside Edge Bit
  end
  if dialog:GetTool("ToolChooseButton6") then
    -- Tool_ID6:SaveDefaults(RegName, "Tool6")
    Milling.MillTool6 = dialog:GetTool("ToolChooseButton6")  -- Outside Edge Bit
  end
  if dialog:GetTool("ToolChooseButton7") then
    -- Tool_ID7:SaveDefaults(RegName, "Tool7")
    Milling.MillTool7 = dialog:GetTool("ToolChooseButton7")  -- Scribe Lines Bit
  end
  if dialog:GetTool("ToolChooseButton8") then
    -- Tool_ID8:SaveDefaults(RegName, "Tool8")
    Milling.MillTool8 = dialog:GetTool("ToolChooseButton8")  -- Corner Cleaning Bit
  end
  if dialog:GetTool("ToolChooseButton9") then
    -- Tool_ID9:SaveDefaults(RegName, "Tool9")
    Milling.MillTool0 = dialog:GetTool("ToolChooseButton9")  -- Fluting Bit
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
function OnLuaButton_InquiryPanel(Pdialog)
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
    Panel.DWidth  = math.abs(dialog:GetDoubleField("Panel.DWidth"))
    Panel.EDepth  = math.abs(dialog:GetDoubleField("Panel.EDepth"))
    DialogWindow.PanelXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    Validater(Pdialog)
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
  Validater(Pdialog)
  RegistryWrite()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryRunCSV(Pdialog)
    InquirySave(Pdialog)
    Door.CSVFile     = Pdialog:GetLabelField("ReadFile")
    Door.ScribeLines = Pdialog:GetDropDownListValue("Door.ScribeLines")
    Door.CSVPath     = string.sub(Door.CSVFile, 1, (string.len(Door.CSVFile) - string.len(GetFilename(Door.CSVFile))))
  if string.find(Door.CSVFile, ".csv") then
    RegistryWrite()
    Door.Records  = LengthOfFile(Door.CSVFile)
    Door.Record   = 1
    MyProgressBar = ProgressBar("Working", ProgressBar.LINEAR)
    MyProgressBar:SetPercentProgress(0)
    Read_CSV(Door.CSVFile, true)
    Door.job:Refresh2DView()
    Pdialog:UpdateLabelField("Door.Alert", "Process Compete! Any Errors are logged in the CSF file folder")
    if Door.Count == 0 then
      Door.X = 50.0 * Door.Cal
      Door.Y = 50.0 * Door.Cal
      Door.Count = 1
    end
    MyProgressBar:SetText("Compete")
    MyProgressBar:Finished()
  else
    Pdialog:UpdateLabelField("Door.Alert", "Error: Unable to run without CSV file selected.")
  end -- if end
  return true
end -- Function end
-- ====================================================]]
function OnLuaButton_InquiryDefault(Pdialog)
  local ErrorText = ""
  local dialog = HTML_Dialog(true, DialogWindow.myHtml1, 458, 505, "Default Settings " .. Door.Units)
  dialog:AddDoubleField("Door.BitRad",          Door.BitRad)
  dialog:AddDoubleField("Door.FluteDepth",      Door.FluteDepth)
  dialog:AddDoubleField("Door.MaxWide",         Door.MaxWide) -- Doors per row
  dialog:AddDoubleField("Door.OverCut",         Door.OverCut)
  dialog:AddDoubleField("Door.ScribeDepth",     Door.ScribeDepth)
  dialog:AddDoubleField("Door.Spacing",         Door.Spacing)
  dialog:AddDropDownList("Door.ScribeLines",    Door.ScribeLines)
  dialog:AddLabelField("Door.Alert",            Door.Alert)
  dialog:AddTextField("Door.LayerFlutes",       Door.LayerFlutes)
  dialog:AddTextField("Door.LayerIFrame",       Door.LayerIFrame)
  dialog:AddTextField("Door.LayerOFrame",       Door.LayerOFrame)
  dialog:AddTextField("Door.LayerScribeLines",  Door.LayerScribeLines)
  dialog:AddTextField("DoorCSVPath",            Door.CSVPath)
  dialog:AddDirectoryPicker("DirectoryPicker", "DoorCSVPath",  true)
  if dialog:ShowDialog() then
    DialogWindow.DefaultXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    Door.Spacing           = math.abs(dialog:GetDoubleField("Door.Spacing"))
    Door.MaxWide           = math.abs(dialog:GetDoubleField("Door.MaxWide"))
    Door.BitRad            = math.abs(dialog:GetDoubleField("Door.BitRad"))
    Door.OverCut           = math.abs(dialog:GetDoubleField("Door.OverCut"))
    Door.ScribeDepth       = math.abs(dialog:GetDoubleField("Door.ScribeDepth"))
    Door.FluteDepth        = math.abs(dialog:GetDoubleField("Door.FluteDepth"))
    Door.LayerOFrame       = All_Trim(dialog:GetTextField("Door.LayerOFrame"))
    Door.LayerIFrame       = All_Trim(dialog:GetTextField("Door.LayerIFrame"))
    Door.LayerFlutes       = All_Trim(dialog:GetTextField("Door.LayerFlutes"))
    Door.LayerScribeLines  = All_Trim(dialog:GetTextField("Door.LayerScribeLines"))
    Door.ScribeLines       = dialog:GetDropDownListValue("Door.ScribeLines")
    Validater(Pdialog)
    RegistryWrite()
  end -- if end
  return  true
end
-- ====================================================]]
function Validater(dialog)
  Door.ErrorText = ""
  if Door.LayerOFrame == "" or Door.LayerIFrame == "" or Door.LayerFlutes  == "" or Door.LayerFlutes  == "" then
    Door.ErrorText = "Defaults Error: Layer names cannot be blank"
  elseif Door.LayerFlutes == Door.LayerIFrame      or Door.LayerFlutes == Door.LayerOFrame or
         Door.LayerFlutes == Door.LayerScribeLines or Door.LayerOFrame == Door.LayerIFrame or
         Door.LayerOFrame == Door.LayerScribeLines or Door.LayerScribeLines == Door.LayerIFrame then
    Door.ErrorText = "Defaults Error: Layers cannot have same name"
  elseif Door.Spacing == 0.0 then
    Door.ErrorText = "Defaults Error: Door spacing cannot be zero"
  elseif Door.MaxWide == 0.0 then
    Door.ErrorText = "Defaults Error: Doors per row cannot be zero"
  elseif Panel.DWidth == 0.0 then
    Door.ErrorText = "Panel Error: Cut width cannot be zero"
  elseif Panel.EDepth == 0.0 then
    Door.ErrorText = "Panel Error: Cut depth cannot be zero"
  elseif Panel.ARadius == 0.0 then
    Door.ErrorText = "Panel Error: Rised panel radius cannot be zero"
  elseif StyleA.FluteSpacing == 0.0 or StyleB.FluteSpacing == 0.0 or StyleC.FluteSpacing == 0.0 or
         StyleE.FluteSpacing == 0.0 or StyleF.FluteSpacing == 0.0 or StyleG.FluteSpacing == 0.0 then
    Door.ErrorText = "Style Error: Flute spacing cannot be zero"
  elseif StyleA.A == 0.0 or StyleA.B == 0.0 then
    Door.ErrorText = "Style Error: " .. StyleA.Name .. " Value cannot be zero"
  elseif StyleB.A == 0.0 or StyleB.B == 0.0 or StyleB.C == 0.0 or StyleB.D == 0.0 then
    Door.ErrorText = "Style Error: " .. StyleB.Name .. " Value cannot be zero"
  elseif StyleC.A == 0.0 or StyleC.B == 0.0 or StyleC.C == 0.0 or StyleC.D == 0.0 then
    Door.ErrorText = "Style Error: " .. StyleC.Name .. " Value cannot be zero"
  elseif StyleE.A == 0.0 or StyleE.B == 0.0  or StyleE.C == 0.0then
    Door.ErrorText = "Style Error: " .. StyleE.Name .. " Value cannot be zero"
  elseif StyleF.A == 0.0 or StyleF.B == 0.0  or StyleF.C == 0.0then
    Door.ErrorText = "Style Error: " .. StyleF.Name .. " Value cannot be zero"
  elseif StyleG.A == 0.0 or StyleG.B == 0.0  or StyleG.C == 0.0then
    Door.ErrorText = "Style Error: " .. StyleG.Name .. " Value cannot be zero"
  end
  dialog:UpdateLabelField("Door.Alert", Door.ErrorText)
  return true
end -- Function End
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
    Pdialog:UpdateLabelField("Door.Alert","Error: Door Count Requird")
    end -- if end
  if Door.Count < 1 then
    runit = false
    Pdialog:UpdateLabelField("Door.Alert","Error: No Door Count Provided")
    end -- if end
  if Door.Width < 1.0 then
    runit = false
    Pdialog:UpdateLabelField("Door.Alert","Error: Door Width is too small")
  end -- if end
  if Door.Height < 1.0 then
    runit = false
    Pdialog:UpdateLabelField("Door.Alert","Error: Door Height is too small")
  end -- if end
  if runit then
    Pdialog:UpdateLabelField("Door.Alert","")
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
function main(script_path)
  Door.job = VectricJob()
  if not Door.job.Exists then
    DisplayMessageBox("Error: This Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end

  Tools1 = assert(loadfile(script_path .. "\\EasyMDFDoorTools_Ver"    .. VerNumber .. ".xlua")) (Tools1)
  Tools2 = assert(loadfile(script_path .. "\\EasyMDFDoorImages_Ver"   .. VerNumber .. ".xlua")) (Tools2)
  Tools3 = assert(loadfile(script_path .. "\\EasyMDFDoorDialog_Ver"   .. VerNumber .. ".xlua")) (Tools3)
  Tools4 = assert(loadfile(script_path .. "\\EasyMDFDoorStyles_Ver"   .. VerNumber .. ".xlua")) (Tools4)
  Tools5 = assert(loadfile(script_path .. "\\EasyMDFDoorRegistry_Ver" .. VerNumber .. ".xlua")) (Tools5)

  GetUnits()
  RegistryRead()
  Project.LoadDate = StartDate(false)
  Door.UnitDisplay = "Note: Units: (" .. Door.Units .. ")"
  HTML()           -- Load the Dialog HTML data
  if InquiryMain() then

  end -- if end
  return true
end -- function end
-- ==================== End ===========================]]
