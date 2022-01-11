-- VECTRIC LUA SCRIPT
-- ========================================================================================================================
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
--  Easy Cabinet Maker is written by JimAndi Gadgets of Houston Texas 2020
-- ========================================================================================================================
-- Easy Base Cabinet Maker was written by JimAndi Gadgets of Houston Texas 2020
-- Version 12.4   - Dec  7, 2021 - Ready for Posting
-- =====================================================]]
-- require("mobdebug").start()
require "strict"
-- =====================================================]]
-- Global variables
local Tooler1, Tooler2, Tooler3, Tooler4
YearNumber = "2021"
VerNumber = "12.4"
AppName = "Easy Base Cabinet Maker"
RegName = "EasyBaseCabinetMaker" .. VerNumber
-- Table Names

BaseDim           = {}
BaseQuestion      = {}
Milling           = {}
Project           = {}
WallDim           = {}
BOM               = {}
WallQuestion      = {}
Hardwere          = {}
Material          = {}
Cab               = {}    -- Points
DialogWindow      = {}    -- Dialog Managment

layer = ""
Project.Debugger =  false -- true --
Project.Rest     =  false
DialogWindow.BaseHelp    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Base.html"
DialogWindow.LayerHelp   = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Layers.html"
DialogWindow.ProjectHelp = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Project.html"
DialogWindow.MillingHelp = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Milling.html"
DialogWindow.MainHelp    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/index.html"
DialogWindow.WallHelp    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Wall.html"
DialogWindow.PartDrawing = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/PartDrawing.html"
DialogWindow.ExportHelp  = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/ImportExport.html"
DialogWindow.DialogLoop  = true

Tool_ID1 = ToolDBId()
Tool_ID2 = ToolDBId()
Tool_ID3 = ToolDBId()
Tool_ID4 = ToolDBId()
Tool_ID5 = ToolDBId()
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
Tool_ID3:LoadDefaults("My Toolpath3", "")
Tool_ID4:LoadDefaults("My Toolpath4", "")
Tool_ID5:LoadDefaults("My Toolpath5", "")
Material.BaseCabinetBackWidth      = 0.0
Material.BaseCabinetBottomLength   = 0.0
Material.BaseCabinetBottomWidth    = 0.0
Material.BaseCabinetSideLength     = 0.0
Material.BaseCabinetSideWidth      = 0.0
Material.BaseShelfLength           = 0.0
Material.BaseShelfWidth            = 0.0
Material.FaceFrameCenterLength1    = 0.0
Material.FaceFrameCenterLength2    = 0.0
Material.FaceFrameCenterLength3    = 0.0
Material.FaceFrameCenterLength4    = 0.0
Material.FaceFrameCenterLength5    = 0.0
Material.FaceFrameRailLength       = 0.0
Material.FaceFrameStileLength      = 0.0
Material.ToeKickLength             = 0.0
Material.ToeKickWidth              = 0.0
BOM.WallShelfBOM                   = true
BOM.BaseShelfBOM                   = true
BOM.PID                            = 10
-- Table Values --
Milling.MillTool1 = {} -- Profile Bit
Milling.MillTool2 = {} -- Pocketing Bit
Milling.MillTool3 = {} -- Pocketing Clearing Bit
Milling.MillTool4 = {} -- Shelf Pins Drilling
Milling.MillTool5 = {} -- Assembly pilot holes
Milling.Tabs = false   -- User to setup Tabs

-- =====================================================]]
function InquiryWallOrBase(Header)
  local Wx, Wy = DialogSize(DialogWindow.InquiryWallOrBaseXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml7, Wx, Wy,  Header .. "  " .. Milling.UnitDisplay)
  dialog:AddDropDownList("Project.Drawing",  Project.Drawing)
  if DialogWindow.Sheets == "" then
    dialog:AddDropDownList("Project.NewSheet", "Yes")
  else
    dialog:AddDropDownList("Project.NewSheet", "No")
  end -- if end
  dialog:AddDoubleField("WallDim.CabHeight", WallDim.CabHeight)
  dialog:AddDoubleField("WallDim.CabDepth",  WallDim.CabDepth)
  dialog:AddDoubleField("WallDim.CabLength", WallDim.CabLength)
  dialog:AddDoubleField("BaseDim.CabHeight", BaseDim.CabHeight)
  dialog:AddDoubleField("BaseDim.CabDepth",  BaseDim.CabDepth)
  dialog:AddDoubleField("BaseDim.CabLength", BaseDim.CabLength)
  dialog:AddTextField("Project.CabinetName", Project.CabinetName)
  dialog:AddLabelField("ToolNameLabel1",                      Milling.MillTool1.Name)
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel2",                      Milling.MillTool2.Name)
  dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
  dialog:AddToolPickerValidToolType("ToolChooseButton2",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel3",                      Milling.MillTool3.Name)
  dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton3",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel4",                      Milling.MillTool4.Name)
  dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID4)
  dialog:AddToolPickerValidToolType("ToolChooseButton4",      Tool.THROUGH_DRILL)
  dialog:AddLabelField("ToolNameLabel5",                      Milling.MillTool5.Name)
  dialog:AddToolPicker("ToolChooseButton5", "ToolNameLabel5", Tool_ID5)
  dialog:AddToolPickerValidToolType("ToolChooseButton5",      Tool.THROUGH_DRILL)

  if dialog:ShowDialog() then
    WallDim.CabHeight   = dialog:GetDoubleField("WallDim.CabHeight")
    WallDim.CabDepth    = dialog:GetDoubleField("WallDim.CabDepth")
    WallDim.CabLength   = dialog:GetDoubleField("WallDim.CabLength")
    BaseDim.CabHeight   = dialog:GetDoubleField("BaseDim.CabHeight")
    BaseDim.CabDepth    = dialog:GetDoubleField("BaseDim.CabDepth")
    BaseDim.CabLength   = dialog:GetDoubleField("BaseDim.CabLength")
    Project.CabinetName = dialog:GetTextField("Project.CabinetName")
    Project.NewSheet    = dialog:GetDropDownListValue("Project.NewSheet")
    Project.Drawing     = dialog:GetDropDownListValue("Project.Drawing")
    if dialog:GetTool("ToolChooseButton1") then
      Tool_ID1:SaveDefaults("ToolChooseButton1", "")
      Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile
    end
    if dialog:GetTool("ToolChooseButton2") then
      Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Pocket
    end
    if dialog:GetTool("ToolChooseButton3") then
      Milling.MillTool3 = dialog:GetTool("ToolChooseButton3")  -- Pocket Clearing
    end
    if dialog:GetTool("ToolChooseButton4") then
      Milling.MillTool4 = dialog:GetTool("ToolChooseButton4")  -- Drilling
    end
    if dialog:GetTool("ToolChooseButton5") then
      Milling.MillTool5 = dialog:GetTool("ToolChooseButton5")  -- Assembly Hole
    end
    DialogWindow.InquiryWallOrBaseXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    RegistryWrite()
    return true
  else
    return false
  end
end
-- =====================================================]]
function OnLuaButton_ImportSettings(dialog)
  local Test = true
  local Wx, Wy = DialogSize(DialogWindow.ImportSettings)
  local dialogx = HTML_Dialog(true, DialogWindow.myHtml0, Wx, Wy, "Import Settings")
  dialogx:AddTextField("ReadFile", Project.ProjectPath .. "\\")
  dialogx:AddFilePicker(true, "FilePickerButton", "ReadFile", true)
  local DTest = dialogx:ShowDialog()
  DialogWindow.ImportSettings = tostring(dialogx.WindowWidth) .. " x " .. tostring(dialogx.WindowHeight)
  RegistryWrite()
  local fName = dialogx:GetTextField("ReadFile")
  local strlen = string.len(fName)
  if not DTest then
    Test = false
  elseif string.sub(fName, strlen - 3) ~= ".ini" then
    MessageBox("Error: You must select a .ini file")
  elseif string.len(Project.ProjectPath .. "\\") < strlen then
    Importer(dialogx:GetTextField("ReadFile"))
    RegistryWrite()
    dialog:UpdateDoubleField("BaseDim.CabDepth",  BaseDim.CabDepth)
    dialog:UpdateDoubleField("WallDim.CabDepth",  WallDim.CabDepth)
    dialog:UpdateDoubleField("BaseDim.CabLength", BaseDim.CabLength)
    dialog:UpdateDoubleField("WallDim.CabLength", WallDim.CabLength)
    dialog:UpdateDoubleField("BaseDim.CabHeight", BaseDim.CabHeight)
    dialog:UpdateDoubleField("WallDim.CabHeight", WallDim.CabHeight)
    dialog:UpdateLabelField("ToolNameLabel1",     Milling.MillTool1.Name)
    dialog:UpdateLabelField("ToolNameLabel2",     Milling.MillTool2.Name)
    dialog:UpdateLabelField("ToolNameLabel3",     Milling.MillTool3.Name)
    dialog:UpdateLabelField("ToolNameLabel4",     Milling.MillTool4.Name)
    dialog:UpdateLabelField("ToolNameLabel5",     Milling.MillTool5.Name)
    DialogWindow.ImportSettings = tostring(dialogx.WindowWidth) .. " x " .. tostring(dialogx.WindowHeight)
  end -- if end
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_ExportSettings(dialogx)
  local Wx, Wy = DialogSize(DialogWindow.ExportSettings)
  Project.CabinetName = dialogx:GetTextField("Project.CabinetName")
  local dialog = HTML_Dialog(true, DialogWindow.myHtml9, Wx, Wy, "Export Settings")
  dialog:AddTextField("Project.ExportName", Project.CabinetName)
  if dialog:ShowDialog() then
    Project.ExportName = All_Trim(dialog:GetTextField("Project.ExportName"))
    if Project.ExportName ~= "" then
      DialogWindow.ExportSettings = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
      RegistryWrite()
      if NameValidater(Project.ExportName) then
        ExportWriter(Project.ExportName)
      else
        MessageBox("Error: The File Name is Incorrect.")
      end -- if end
    end -- if end
  end -- if end
  return true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryAbout()
  local Wx, Wy = DialogSize(DialogWindow.AboutXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, Wx, Wy, "About")
  dialog:AddLabelField("SysName", AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:AddCheckBox("RegistryReset", false)
  dialog:ShowDialog()
  Project.Rest = dialog:GetCheckBox("RegistryReset")
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  RegistryWrite()
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryBaseQuestion()
  local Wx, Wy = DialogSize(DialogWindow.BaseCabinetXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml5, Wx, Wy, "Base Cabinet Setup")
  dialog:AddDoubleField("BaseDim.FaceFrameBottomRailWidth",    BaseDim.FaceFrameBottomRailWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameBottomReveal",       BaseDim.FaceFrameBottomReveal)
  dialog:AddDoubleField("BaseDim.FaceFrameCenterStileWidth",   BaseDim.FaceFrameCenterStileWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameDrawerHeight1",      BaseDim.FaceFrameDrawerHeight1)
  dialog:AddDoubleField("BaseDim.FaceFrameDrawerHeight2",      BaseDim.FaceFrameDrawerHeight2)
  dialog:AddDoubleField("BaseDim.FaceFrameDrawerHeight3",      BaseDim.FaceFrameDrawerHeight3)
  dialog:AddDoubleField("BaseDim.FaceFrameMidRailWidth",       BaseDim.FaceFrameMidRailWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameSideReveal",         BaseDim.FaceFrameSideReveal)
  dialog:AddDoubleField("BaseDim.FaceFrameStileWidth",         BaseDim.FaceFrameStileWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameThickness",          BaseDim.FaceFrameThickness)
  dialog:AddDoubleField("BaseDim.FaceFrameTopRailWidth",       BaseDim.FaceFrameTopRailWidth)
  dialog:AddDoubleField("BaseDim.MaterialThickness",           BaseDim.MaterialThickness)
  dialog:AddDoubleField("BaseDim.ShelfEndClarence",            BaseDim.ShelfEndClarence)
  dialog:AddDoubleField("BaseDim.ShelfFrontClearance",         BaseDim.ShelfFrontClearance)
  dialog:AddDoubleField("BaseDim.ShelfHoleFirstRowSpacing",    BaseDim.ShelfHoleFirstRowSpacing)
  dialog:AddDoubleField("BaseDim.ShelfHoleLastRowSpacing",     BaseDim.ShelfHoleLastRowSpacing)
  dialog:AddDoubleField("BaseDim.ShelfHoleSpacing",            BaseDim.ShelfHoleSpacing)
  dialog:AddDoubleField("BaseDim.ShelfMaterialThickness",      BaseDim.ShelfMaterialThickness)
  dialog:AddDoubleField("BaseDim.ShelfNosingThickness",        BaseDim.ShelfNosingThickness)
  dialog:AddDoubleField("BaseDim.ShelfNosingWidth",            BaseDim.ShelfNosingWidth)
  dialog:AddDoubleField("BaseDim.ShelfPinHoleBack",            BaseDim.ShelfPinHoleBack)
  dialog:AddDoubleField("BaseDim.ShelfPinHoleFront",           BaseDim.ShelfPinHoleFront)
  dialog:AddDoubleField("BaseDim.StretcherThickness",          BaseDim.StretcherThickness)
  dialog:AddDoubleField("BaseDim.StretcherWidth",              BaseDim.StretcherWidth)
  dialog:AddDoubleField("BaseDim.ThicknessBack",               BaseDim.ThicknessBack)
  dialog:AddDoubleField("BaseDim.ToeKickBottomOffsetHeight",   BaseDim.ToeKickBottomOffsetHeight)
  dialog:AddDoubleField("BaseDim.ToeKickDepth",                BaseDim.ToeKickDepth)
  dialog:AddDoubleField("BaseDim.ToeKickHeight",               BaseDim.ToeKickHeight)
  dialog:AddDoubleField("BaseDim.TopFrameWidth",               BaseDim.TopFrameWidth)
  dialog:AddDropDownList("BaseQuestion.AddCenterPanel",        ifT(BaseQuestion.AddCenterPanel))
  dialog:AddDropDownList("BaseQuestion.DrawerRowCount",        tostring(BaseQuestion.DrawerRowCount))
  dialog:AddDropDownList("BaseQuestion.ShelfCount",            tostring(BaseQuestion.ShelfCount))
  if dialog:ShowDialog() then
    BaseDim.FaceFrameBottomRailWidth  = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameBottomRailWidth"))
    BaseDim.FaceFrameBottomReveal     = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameBottomReveal"))
    BaseDim.FaceFrameCenterStileWidth = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameCenterStileWidth"))
    BaseDim.FaceFrameDrawerHeight1    = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameDrawerHeight1"))
    BaseDim.FaceFrameDrawerHeight2    = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameDrawerHeight2"))
    BaseDim.FaceFrameDrawerHeight3    = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameDrawerHeight3"))
    BaseDim.FaceFrameMidRailWidth     = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameMidRailWidth"))
    BaseDim.FaceFrameSideReveal       = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameSideReveal"))
    BaseDim.FaceFrameStileWidth       = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameStileWidth"))
    BaseDim.FaceFrameThickness        = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameThickness"))
    BaseDim.FaceFrameTopRailWidth     = math.abs(dialog:GetDoubleField("BaseDim.FaceFrameTopRailWidth"))
    BaseDim.MaterialThickness         = math.abs(dialog:GetDoubleField("BaseDim.MaterialThickness"))
    BaseDim.ShelfEndClarence          = math.abs(dialog:GetDoubleField("BaseDim.ShelfEndClarence"))
    BaseDim.ShelfFrontClearance       = math.abs(dialog:GetDoubleField("BaseDim.ShelfFrontClearance"))
    BaseDim.ShelfHoleFirstRowSpacing  = math.abs(dialog:GetDoubleField("BaseDim.ShelfHoleFirstRowSpacing"))
    BaseDim.ShelfHoleLastRowSpacing   = math.abs(dialog:GetDoubleField("BaseDim.ShelfHoleLastRowSpacing"))
    BaseDim.ShelfHoleSpacing          = math.abs(dialog:GetDoubleField("BaseDim.ShelfHoleSpacing"))
    BaseDim.ShelfMaterialThickness    = math.abs(dialog:GetDoubleField("BaseDim.ShelfMaterialThickness"))
    BaseDim.ShelfNosingThickness      = math.abs(dialog:GetDoubleField("BaseDim.ShelfNosingThickness"))
    BaseDim.ShelfNosingWidth          = math.abs(dialog:GetDoubleField("BaseDim.ShelfNosingWidth"))
    BaseDim.ShelfPinHoleBack          = math.abs(dialog:GetDoubleField("BaseDim.ShelfPinHoleBack"))
    BaseDim.ShelfPinHoleFront         = math.abs(dialog:GetDoubleField("BaseDim.ShelfPinHoleFront"))
    BaseDim.StretcherThickness        = math.abs(dialog:GetDoubleField("BaseDim.StretcherThickness"))
    BaseDim.StretcherWidth            = math.abs(dialog:GetDoubleField("BaseDim.StretcherWidth"))
    BaseDim.ThicknessBack             = math.abs(dialog:GetDoubleField("BaseDim.ThicknessBack"))
    BaseDim.ToeKickBottomOffsetHeight = math.abs(dialog:GetDoubleField("BaseDim.ToeKickBottomOffsetHeight"))
    BaseDim.ToeKickDepth              = math.abs(dialog:GetDoubleField("BaseDim.ToeKickDepth"))
    BaseDim.ToeKickHeight             = math.abs(dialog:GetDoubleField("BaseDim.ToeKickHeight"))
    BaseDim.TopFrameWidth             = math.abs(dialog:GetDoubleField("BaseDim.TopFrameWidth"))
    BaseQuestion.AddCenterPanel       = ifY(dialog:GetDropDownListValue("BaseQuestion.AddCenterPanel"))
    BaseQuestion.DrawerRowCount       = tonumber(dialog:GetDropDownListValue("BaseQuestion.DrawerRowCount"))
    BaseQuestion.ShelfCount           = tonumber(dialog:GetDropDownListValue("BaseQuestion.ShelfCount"))
    DialogWindow.BaseCabinetXY        = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    RegistryWrite()
  end
  Base_Math()
  RegistryWrite()
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryLayers( )
  local Wx, Wy = DialogSize(DialogWindow.LayerXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml4, Wx, Wy, "Layer Setup")
  dialog:AddTextField("Milling.LNBackPocket", Milling.LNBackPocket)
  dialog:AddTextField("Milling.LNBackProfile", Milling.LNBackProfile)
  dialog:AddTextField("Milling.LNCenterPanelProfile", Milling.LNCenterPanelProfile)
  dialog:AddTextField("Milling.LNCenterPanelShelfPinDrill", Milling.LNCenterPanelShelfPinDrill)
  dialog:AddTextField("Milling.LNDrawFaceFrame", Milling.LNDrawFaceFrame)
  dialog:AddTextField("Milling.LNShelfProfile", Milling.LNShelfProfile)
  dialog:AddTextField("Milling.LNSideProfile", Milling.LNSideProfile)
  dialog:AddTextField("Milling.LNSidePocket", Milling.LNSidePocket)
  dialog:AddTextField("Milling.LNSideShelfPinDrill", Milling.LNSideShelfPinDrill)
  dialog:AddTextField("Milling.LNTopBottomProfile", Milling.LNTopBottomProfile)
  dialog:AddTextField("Milling.LNTopBottomPocket", Milling.LNTopBottomPocket)
  dialog:AddTextField("Milling.LNStretcherRailProfile", Milling.LNStretcherRailProfile)
  dialog:AddTextField("Milling.LNPartLabels", Milling.LNPartLabels)
  dialog:AddTextField("Milling.LNDrawNotes", Milling.LNDrawNotes)
  dialog:AddDropDownList("Milling.LNBackPocketColor", Milling.LNBackPocketColor)
  dialog:AddDropDownList("Milling.LNBackProfileColor", Milling.LNBackProfileColor)
  dialog:AddDropDownList("Milling.LNCenterPanelProfileColor", Milling.LNCenterPanelProfileColor)
  dialog:AddDropDownList("Milling.LNCenterPanelShelfPinDrillColor", Milling.LNCenterPanelShelfPinDrillColor)
  dialog:AddDropDownList("Milling.LNDrawFaceFrameColor", Milling.LNDrawFaceFrameColor)
  dialog:AddDropDownList("Milling.LNShelfProfileColor", Milling.LNShelfProfileColor)
  dialog:AddDropDownList("Milling.LNSideProfileColor", Milling.LNSideProfileColor)
  dialog:AddDropDownList("Milling.LNSidePocketColor", Milling.LNSidePocketColor)
  dialog:AddDropDownList("Milling.LNSideShelfPinDrillColor", Milling.LNSideShelfPinDrillColor)
  dialog:AddDropDownList("Milling.LNTopBottomProfileColor", Milling.LNTopBottomProfileColor)
  dialog:AddDropDownList("Milling.LNTopBottomPocketColor", Milling.LNTopBottomPocketColor)
  dialog:AddDropDownList("Milling.LNStretcherRailProfileColor", Milling.LNStretcherRailProfileColor)
  dialog:AddDropDownList("Milling.LNPartLabelsColor", Milling.LNPartLabelsColor)
  dialog:AddDropDownList("Milling.LNDrawNotesColor", Milling.LNDrawNotesColor)
  if  dialog:ShowDialog() then
    Milling.LNBackPocket                    = All_Trim(dialog:GetTextField("Milling.LNBackPocket"))
    Milling.LNBackProfile                   = All_Trim(dialog:GetTextField("Milling.LNBackProfile"))
    Milling.LNCenterPanelProfile            = All_Trim(dialog:GetTextField("Milling.LNCenterPanelProfile"))
    Milling.LNCenterPanelShelfPinDrill      = All_Trim(dialog:GetTextField("Milling.LNCenterPanelShelfPinDrill"))
    Milling.LNDrawFaceFrame                 = All_Trim(dialog:GetTextField("Milling.LNDrawFaceFrame"))
    Milling.LNShelfProfile                  = All_Trim(dialog:GetTextField("Milling.LNShelfProfile"))
    Milling.LNSideProfile                   = All_Trim(dialog:GetTextField("Milling.LNSideProfile"))
    Milling.LNSidePocket                    = All_Trim(dialog:GetTextField("Milling.LNSidePocket"))
    Milling.LNSideShelfPinDrill             = All_Trim(dialog:GetTextField("Milling.LNSideShelfPinDrill"))
    Milling.LNTopBottomProfile              = All_Trim(dialog:GetTextField("Milling.LNTopBottomProfile"))
    Milling.LNTopBottomPocket               = All_Trim(dialog:GetTextField("Milling.LNTopBottomPocket"))
    Milling.LNStretcherRailProfile          = All_Trim(dialog:GetTextField("Milling.LNStretcherRailProfile"))
    Milling.LNPartLabels                    = All_Trim(dialog:GetTextField("Milling.LNPartLabels"))
    Milling.LNDrawNotes                     = All_Trim(dialog:GetTextField("Milling.LNDrawNotes"))
    Milling.LNBackPocketColor               = dialog:GetDropDownListValue("Milling.LNBackPocketColor")
    Milling.LNBackProfileColor              = dialog:GetDropDownListValue("Milling.LNBackProfileColor")
    Milling.LNCenterPanelProfileColor       = dialog:GetDropDownListValue("Milling.LNCenterPanelProfileColor")
    Milling.LNCenterPanelShelfPinDrillColor = dialog:GetDropDownListValue("Milling.LNCenterPanelShelfPinDrillColor")
    Milling.LNDrawFaceFrameColor            = dialog:GetDropDownListValue("Milling.LNDrawFaceFrameColor")
    Milling.LNShelfProfileColor             = dialog:GetDropDownListValue("Milling.LNShelfProfileColor")
    Milling.LNSideProfileColor              = dialog:GetDropDownListValue("Milling.LNSideProfileColor")
    Milling.LNSidePocketColor               = dialog:GetDropDownListValue("Milling.LNSidePocketColor")
    Milling.LNSideShelfPinDrillColor        = dialog:GetDropDownListValue("Milling.LNSideShelfPinDrillColor")
    Milling.LNTopBottomProfileColor         = dialog:GetDropDownListValue("Milling.LNTopBottomProfileColor")
    Milling.LNTopBottomPocketColor          = dialog:GetDropDownListValue("Milling.LNTopBottomPocketColor")
    Milling.LNStretcherRailProfileColor     = dialog:GetDropDownListValue("Milling.LNStretcherRailProfileColor")
    Milling.LNPartLabelsColor               = dialog:GetDropDownListValue("Milling.LNPartLabelsColor")
    Milling.LNDrawNotesColor                = dialog:GetDropDownListValue("Milling.LNDrawNotesColor")
    DialogWindow.LayerXY                    = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryWrite()
  end
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryMilling()
  local Wx, Wy = DialogSize(DialogWindow.MillingXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml3 , Wx, Wy, "Milling Setting ")
  dialog:AddDoubleField("Milling.DadoBackHeight",        Milling.DadoBackHeight)
  dialog:AddDoubleField("Milling.DadoHeight",            Milling.DadoHeight)
  dialog:AddDoubleField("Milling.DadoClearance",         Milling.DadoClearance)
  dialog:AddDoubleField("Milling.ShelfPinLen",           Milling.ShelfPinLen)
  dialog:AddDoubleField("Milling.PartGap",               Milling.PartGap)
  dialog:AddDoubleField("Milling.ShelfPinDiameter",      Milling.ShelfPinDiameter)
  dialog:AddDropDownList("Milling.AddJointNotes",        ifT(Milling.AddJointNotes))
  dialog:AddDoubleField("Milling.AssemblyHoleStartEnd",  Milling.AssemblyHoleStartEnd)
  dialog:AddDropDownList("Milling.AddAssemblyHolesBase", ifT(Milling.AddAssemblyHolesBase))
  dialog:AddDropDownList("Milling.AddAssemblyHolesWall", ifT(Milling.AddAssemblyHolesWall))
  dialog:AddDoubleField("Milling.AssemblyHoleMaxSpace",  Milling.AssemblyHoleMaxSpace)
  dialog:AddDoubleField("Milling.AssemblyHoleMinSpace",  Milling.AssemblyHoleMinSpace)
  dialog:AddDoubleField("Milling.ProfileToolDia",        Milling.ProfileToolDia)
  dialog:AddDoubleField("Milling.PocketToolDia",         Milling.PocketToolDia)
  dialog:AddDropDownList("Milling.DadoType",             Milling.DadoType)
  dialog:AddDoubleField("Milling.DadoBlindAmount",        Milling.DadoBlindAmount)
  if dialog:ShowDialog() then
    Milling.DadoBackHeight       = math.abs(dialog:GetDoubleField("Milling.DadoBackHeight"))
    Milling.DadoHeight           = math.abs(dialog:GetDoubleField("Milling.DadoHeight"))
    Milling.DadoClearance        = dialog:GetDoubleField("Milling.DadoClearance")
    Milling.PartGap              = math.abs(dialog:GetDoubleField("Milling.PartGap"))
    Milling.ShelfPinDiameter     = math.abs(dialog:GetDoubleField("Milling.ShelfPinDiameter"))
    Milling.AddJointNotes        = ifY(dialog:GetDropDownListValue("Milling.AddJointNotes"))
    Milling.AssemblyHoleStartEnd = math.abs(dialog:GetDoubleField("Milling.AssemblyHoleStartEnd"))
    Milling.AddAssemblyHolesBase = ifY(dialog:GetDropDownListValue("Milling.AddAssemblyHolesBase"))
    Milling.AddAssemblyHolesWall = ifY(dialog:GetDropDownListValue("Milling.AddAssemblyHolesWall"))
    Milling.DadoType             = dialog:GetDropDownListValue("Milling.DadoType")
    Milling.AssemblyHoleMaxSpace = math.abs(dialog:GetDoubleField("Milling.AssemblyHoleMaxSpace"))
    Milling.AssemblyHoleMinSpace = math.abs(dialog:GetDoubleField("Milling.AssemblyHoleMinSpace"))
    Milling.ProfileToolDia       = math.abs(dialog:GetDoubleField("Milling.ProfileToolDia"))
    Milling.PocketToolDia        = math.abs(dialog:GetDoubleField("Milling.PocketToolDia"))
    Milling.DadoBlindAmount      = math.abs(dialog:GetDoubleField("Milling.DadoBlindAmount"))
    DialogWindow.MillingXY       = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryWrite()
  end
  return true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryPartDrawing()
  local Wx, Wy = DialogSize(DialogWindow.PartDrawingXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml8 , Wx, Wy, "Part Selection")
  dialog:AddCheckBox("BaseQuestion.DrawBackPanel",      BaseQuestion.DrawBackPanel)
  dialog:AddCheckBox("BaseQuestion.DrawBottomPanel",    BaseQuestion.DrawBottomPanel)
  dialog:AddCheckBox("BaseQuestion.DrawCenterPanel",    BaseQuestion.DrawCenterPanel)
  dialog:AddCheckBox("BaseQuestion.DrawFaceFrame",      BaseQuestion.DrawFaceFrame)
  dialog:AddCheckBox("BaseQuestion.DrawShelfPanel",     BaseQuestion.DrawShelfPanel)
  dialog:AddCheckBox("BaseQuestion.DrawSidePanels",     BaseQuestion.DrawSidePanels)
  dialog:AddCheckBox("BaseQuestion.DrawTopToe",         BaseQuestion.DrawTopToe)
  dialog:AddCheckBox("WallQuestion.DrawBackPanel",      WallQuestion.DrawBackPanel)
  dialog:AddCheckBox("WallQuestion.DrawBottomTopPanel", WallQuestion.DrawBottomTopPanel)
  dialog:AddCheckBox("WallQuestion.DrawCenterPanel",    WallQuestion.DrawCenterPanel)
  dialog:AddCheckBox("WallQuestion.DrawFaceFrame",      WallQuestion.DrawFaceFrame)
  dialog:AddCheckBox("WallQuestion.DrawShelfPanel",     WallQuestion.DrawShelfPanel)
  dialog:AddCheckBox("WallQuestion.DrawSidePanels",     WallQuestion.DrawSidePanels)
  if dialog:ShowDialog() then
    BaseQuestion.DrawBackPanel       = dialog:GetCheckBox("BaseQuestion.DrawBackPanel")
    BaseQuestion.DrawBottomPanel     = dialog:GetCheckBox("BaseQuestion.DrawBottomPanel")
    BaseQuestion.DrawCenterPanel     = dialog:GetCheckBox("BaseQuestion.DrawCenterPanel")
    BaseQuestion.DrawFaceFrame       = dialog:GetCheckBox("BaseQuestion.DrawFaceFrame")
    BaseQuestion.DrawShelfPanel      = dialog:GetCheckBox("BaseQuestion.DrawShelfPanel")
    BaseQuestion.DrawSidePanels      = dialog:GetCheckBox("BaseQuestion.DrawSidePanels")
    BaseQuestion.DrawTopToe          = dialog:GetCheckBox("BaseQuestion.DrawTopToe")
    WallQuestion.DrawBackPanel       = dialog:GetCheckBox("WallQuestion.DrawBackPanel")
    WallQuestion.DrawBottomTopPanel  = dialog:GetCheckBox("WallQuestion.DrawBottomTopPanel")
    WallQuestion.DrawCenterPanel     = dialog:GetCheckBox("WallQuestion.DrawCenterPanel")
    WallQuestion.DrawFaceFrame       = dialog:GetCheckBox("WallQuestion.DrawFaceFrame")
    WallQuestion.DrawShelfPanel      = dialog:GetCheckBox("WallQuestion.DrawShelfPanel")
    WallQuestion.DrawSidePanels      = dialog:GetCheckBox("WallQuestion.DrawSidePanels")
    DialogWindow.PartDrawingXY       = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryWrite()
  end
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryProjectInfo()
  local Wx, Wy = DialogSize(DialogWindow.ProjectXY)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, Wx, Wy, "Project Setup")
  dialog:AddTextField("Project.ProjectName",             Project.ProjectName)
  dialog:AddTextField("Project.ProjectContactEmail",     Project.ProjectContactEmail)
  dialog:AddTextField("Project.ProjectContactName",      Project.ProjectContactName)
  dialog:AddTextField("Project.PhoneNumber",             Project.PhoneNumber)
  dialog:AddTextField("Project.DrawerID",                StartDate())
  dialog:AddTextField("Project.ProjectPath",             Project.ProjectPath )
  dialog:AddDoubleField("Project.TextHeight",            Project.TextHeight)
  dialog:AddDropDownList("Project.CabinetStyle",         Project.CabinetStyle)
  dialog:AddDirectoryPicker("DirectoryPicker", "Project.ProjectPath",  true)
  dialog:AddDropDownList("BOM.WallCabinetMateralType",   BOM.WallCabinetMateralType)
  dialog:AddDropDownList("BOM.BaseCabinetMateralType",   BOM.BaseCabinetMateralType)
  dialog:AddDropDownList("BOM.WallFaceFrameMateralType", BOM.WallFaceFrameMateralType)
  dialog:AddDropDownList("BOM.BaseFaceFrameMateralType", BOM.BaseFaceFrameMateralType)
  dialog:AddDropDownList("BOM.WallCabinetFinish",        BOM.WallCabinetFinish)
  dialog:AddDropDownList("BOM.BaseCabinetFinish",        BOM.BaseCabinetFinish)
  dialog:AddDropDownList("BOM.WallFaceFrameFinish",      BOM.WallFaceFrameFinish)
  dialog:AddDropDownList("BOM.BaseFaceFrameFinish",      BOM.BaseFaceFrameFinish)
  if dialog:ShowDialog() then
    Project.ProjectName          = string.upper(All_Trim(dialog:GetTextField("Project.ProjectName")))
    Project.ProjectContactEmail  = All_Trim(dialog:GetTextField("Project.ProjectContactEmail"))
    Project.ProjectContactName   = All_Trim(dialog:GetTextField("Project.ProjectContactName"))
    BOM.WallCabinetMateralType   = dialog:GetDropDownListValue("BOM.WallCabinetMateralType")
    BOM.BaseCabinetMateralType   = dialog:GetDropDownListValue("BOM.BaseCabinetMateralType")
    BOM.WallFaceFrameMateralType = dialog:GetDropDownListValue("BOM.WallFaceFrameMateralType")
    BOM.BaseFaceFrameMateralType = dialog:GetDropDownListValue("BOM.BaseFaceFrameMateralType")
    BOM.WallCabinetFinish        = dialog:GetDropDownListValue("BOM.WallCabinetFinish")
    BOM.BaseCabinetFinish        = dialog:GetDropDownListValue("BOM.BaseCabinetFinish")
    BOM.WallFaceFrameFinish      = dialog:GetDropDownListValue("BOM.WallFaceFrameFinish")
    BOM.BaseFaceFrameFinish      = dialog:GetDropDownListValue("BOM.BaseFaceFrameFinish")
    Project.CabinetStyle         = dialog:GetDropDownListValue("Project.CabinetStyle")
    Project.PhoneNumber          = All_Trim(dialog:GetTextField("Project.PhoneNumber"))
    Project.DrawerID             = dialog:GetTextField("Project.DrawerID")
    Project.ProjectPath          = dialog:GetTextField("Project.ProjectPath")
    Project.TextHeight           = math.abs(dialog:GetDoubleField("Project.TextHeight"))
    DialogWindow.ProjectXY       = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    FaceFrameManiagement()
    RegistryWrite()
  end
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryWallQuestion()
  local Wx, Wy = DialogSize(DialogWindow.WallCabinetXY)
  local dialog = HTML_Dialog(true,  DialogWindow.myHtml1, Wx, Wy, "Wall Cabinet Setup")
  dialog:AddDoubleField("WallDim.FaceFrameBottomRailWidth",  WallDim.FaceFrameBottomRailWidth)
  dialog:AddDoubleField("WallDim.FaceFrameBottomReveal",     WallDim.FaceFrameBottomReveal)
  dialog:AddDoubleField("WallDim.FaceFrameCenterStileWidth", WallDim.FaceFrameCenterStileWidth)
  dialog:AddDoubleField("WallDim.FaceFrameSideReveal",       WallDim.FaceFrameSideReveal)
  dialog:AddDoubleField("WallDim.FaceFrameStileWidth",       WallDim.FaceFrameStileWidth)
  dialog:AddDoubleField("WallDim.FaceFrameThickness",        WallDim.FaceFrameThickness)
  dialog:AddDoubleField("WallDim.FaceFrameTopRailWidth",     WallDim.FaceFrameTopRailWidth)
  dialog:AddDoubleField("WallDim.FaceFrameTopReveal",        WallDim.FaceFrameTopReveal)
  dialog:AddDoubleField("WallDim.MaterialThickness",         WallDim.MaterialThickness)
  dialog:AddDoubleField("WallDim.ShelfEndClarence",          WallDim.ShelfEndClarence)
  dialog:AddDoubleField("WallDim.ShelfFrontClearance",       WallDim.ShelfFrontClearance)
  dialog:AddDoubleField("WallDim.ShelfHoleFirstRowSpacing",  WallDim.ShelfHoleFirstRowSpacing)
  dialog:AddDoubleField("WallDim.ShelfHoleLastRowSpacing",   WallDim.ShelfHoleLastRowSpacing)
  dialog:AddDoubleField("WallDim.ShelfHoleSpacing",          WallDim.ShelfHoleSpacing)
  dialog:AddDoubleField("WallDim.ShelfMaterialThickness",    WallDim.ShelfMaterialThickness)
  dialog:AddDoubleField("WallDim.ShelfNosingThickness",      WallDim.ShelfNosingThickness)
  dialog:AddDoubleField("WallDim.ShelfNosingWidth",          WallDim.ShelfNosingWidth)
  dialog:AddDoubleField("WallDim.ShelfPinHoleBack",          WallDim.ShelfPinHoleBack)
  dialog:AddDoubleField("WallDim.ShelfPinHoleFront",         WallDim.ShelfPinHoleFront)
  dialog:AddDoubleField("WallDim.ThicknessBack",             WallDim.ThicknessBack)
  dialog:AddDropDownList("WallQuestion.AddCenterFaceFrame",  ifT(WallQuestion.AddCenterFaceFrame))
  dialog:AddDropDownList("WallQuestion.AddCenterPanel",      ifT(WallQuestion.AddCenterPanel))
  dialog:AddDropDownList("WallQuestion.ShelfCount",          tostring(WallQuestion.ShelfCount))
  if dialog:ShowDialog() then
    WallDim.FaceFrameBottomRailWidth    = math.abs(dialog:GetDoubleField("WallDim.FaceFrameBottomRailWidth"))
    WallDim.FaceFrameBottomReveal       = math.abs(dialog:GetDoubleField("WallDim.FaceFrameBottomReveal"))
    WallDim.FaceFrameCenterStileWidth   = math.abs(dialog:GetDoubleField("WallDim.FaceFrameCenterStileWidth"))
    WallDim.FaceFrameSideReveal         = math.abs(dialog:GetDoubleField("WallDim.FaceFrameSideReveal"))
    WallDim.FaceFrameStileWidth         = math.abs(dialog:GetDoubleField("WallDim.FaceFrameStileWidth"))
    WallDim.FaceFrameThickness          = math.abs(dialog:GetDoubleField("WallDim.FaceFrameThickness"))
    WallDim.FaceFrameTopRailWidth       = math.abs(dialog:GetDoubleField("WallDim.FaceFrameTopRailWidth"))
    WallDim.FaceFrameTopReveal          = math.abs(dialog:GetDoubleField("WallDim.FaceFrameTopReveal"))
    WallDim.MaterialThickness           = math.abs(dialog:GetDoubleField("WallDim.MaterialThickness"))
    WallDim.ShelfEndClarence            = math.abs(dialog:GetDoubleField("WallDim.ShelfEndClarence"))
    WallDim.ShelfFrontClearance         = math.abs(dialog:GetDoubleField("WallDim.ShelfFrontClearance"))
    WallDim.ShelfHoleFirstRowSpacing    = math.abs(dialog:GetDoubleField("WallDim.ShelfHoleFirstRowSpacing"))
    WallDim.ShelfHoleLastRowSpacing     = math.abs(dialog:GetDoubleField("WallDim.ShelfHoleLastRowSpacing"))
    WallDim.ShelfHoleSpacing            = math.abs(dialog:GetDoubleField("WallDim.ShelfHoleSpacing"))
    WallDim.ShelfMaterialThickness      = math.abs(dialog:GetDoubleField("WallDim.ShelfMaterialThickness"))
    WallDim.ShelfNosingThickness        = math.abs(dialog:GetDoubleField("WallDim.ShelfNosingThickness"))
    WallDim.ShelfNosingWidth            = math.abs(dialog:GetDoubleField("WallDim.ShelfNosingWidth"))
    WallDim.ShelfPinHoleBack            = math.abs(dialog:GetDoubleField("WallDim.ShelfPinHoleBack"))
    WallDim.ShelfPinHoleFront           = math.abs(dialog:GetDoubleField("WallDim.ShelfPinHoleFront"))
    WallDim.ThicknessBack               = math.abs(dialog:GetDoubleField("WallDim.ThicknessBack"))
    WallQuestion.AddCenterFaceFrame     = ifY(dialog:GetDropDownListValue("WallQuestion.AddCenterFaceFrame"))
    WallQuestion.AddCenterPanel         = ifY(dialog:GetDropDownListValue("WallQuestion.AddCenterPanel"))
    WallQuestion.ShelfCount             = tonumber(dialog:GetDropDownListValue("WallQuestion.ShelfCount"))
    DialogWindow.WallCabinetXY          = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    Wall_Math()
    RegistryWrite()
  end
  return  true
end -- function end
-- =====================================================]]
function OnLuaButton_InquiryToolClear(dialog)
  Milling.MillTool1.Name = "No Tool Selected"
  Milling.MillTool2.Name = "No Tool Selected"
  Milling.MillTool3.Name = "No Tool Selected"
  Milling.MillTool4.Name = "No Tool Selected"
  Milling.MillTool5.Name = "No Tool Selected"
  dialog:UpdateLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  dialog:UpdateLabelField("ToolNameLabel2", Milling.MillTool2.Name)
  dialog:UpdateLabelField("ToolNameLabel3", Milling.MillTool3.Name)
  dialog:UpdateLabelField("ToolNameLabel4", Milling.MillTool4.Name)
  dialog:UpdateLabelField("ToolNameLabel5", Milling.MillTool5.Name)
  RegistryWrite()
  return true
end -- function end
-- =====================================================]]
function main(script_path)
  local CabLoop = true
  local Drawing = false
  Milling.job = VectricJob()
  if GetAppVersion() >= 11.0 then
    DialogWindow.Sheets = "disabled"
  else
    DialogWindow.Sheets = ""
  end -- if end
  if not Milling.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false
  end -- if end
  Tooler1 = assert(loadfile(script_path .. "\\EasyCabinetToolVer".. VerNumber .. ".xlua")) (Tooler1) -- Load Tool Function
  Tooler2 = assert(loadfile(script_path .. "\\EasyCabinetWallVer".. VerNumber .. ".xlua")) (Tooler2) -- Load Tool Function
  Tooler3 = assert(loadfile(script_path .. "\\EasyCabinetBaseVer".. VerNumber .. ".xlua")) (Tooler3) -- Load Tool Function
  Tooler4 = assert(loadfile(script_path .. "\\EasyCabinetLibVer" .. VerNumber .. ".xlua")) (Tooler4) -- Load Tool Function
GetMaterialSettings()
  RegistryRead()
  HTML()
  Base_Math()
  Wall_Math()
  Mill_Math()
  RegistryWrite()
  while CabLoop do
    Drawing = InquiryWallOrBase("Easy Cabinet Maker")
    if Drawing and (Project.ProjectPath  ==  "Default") then
      DisplayMessageBox("Alert: The Cabinet Maker is not configured." ..
                        "\n The Project path must be selected and saved.")
      OnLuaButton_InquiryProjectInfo()
      CabLoop = true
      -- loop  -- if no Project Path
    elseif Drawing and (not MillingValidater()) then
        CabLoop = true
    elseif Drawing and (not BaseValidater()) then
        CabLoop = true
    elseif Drawing and (not WallValidater()) then
        CabLoop = true
    elseif Drawing and (All_Trim(Project.ProjectPath)  ==  "") then
        DisplayMessageBox("Alert: The Cabinet Maker is Blank." ..
                          "\n A Project path must be selected and saved.")
        OnLuaButton_InquiryProjectInfo()
        CabLoop = true
      -- end  -- if no Project Path
    elseif Drawing and (not(os.rename(Project.ProjectPath, Project.ProjectPath))) then
        DisplayMessageBox("Error: Cannot find the Project Path or Access is blocked. \n" ..
                          "Check the full path is made and no application have open files in the folder. \n" ..
                          "\nUse the Project Setup menu to set the correct Project location")
        CabLoop = true
    elseif Project.Rest then
      RegistryReset()
      Drawing = false
      CabLoop = false
    else
      CabLoop = false
    end -- if end
  end -- while end
  -- =============================================
  if Drawing then
    if Project.NewSheet == "Yes" then
      Milling.Sheet = "1-"
      NewSheet()
    else
      Milling.Sheet = ""
    end
    LayerMake("")
    Mill_Math()
    MillingTools()
    CutListfileWriterHeader(Project.Drawing)
    if Project.Drawing == "Wall" then
      Project.Drawingx = "Wall"
    elseif Project.Drawing == "Base" then
      Project.Drawingx = "Base"
    elseif Project.Drawing == "Both" then
      Project.Drawingx = "Wall"
    end -- if end
    if Project.Drawingx == "Wall" then   --  Wall Cabinet Start
      if Project.Drawing == "Both" then
        Project.Drawingx = "Base"
      end -- if end
      Base_Math()
      Wall_Math()
      LayerMake("-Wall")
      Wall_CabinetSide("L")
      Wall_CabinetSide("R")
      Wall_CabinetTandB("T")
      Wall_CabinetTandB("B")
      -- Wall Tool Paths
      if WallQuestion.DrawSidePanels then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall Side Pockets", Milling.LNSidePocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        if WallQuestion.ShelfCount > 0 then
          CreateLayerDrillingToolpath(Milling.LNSideShelfPinDrill .."-Wall", Milling.Sheet .. "Wall Side Panel Pin Drilling", 0.0,  Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        end -- if end
      end
      if WallQuestion.DrawBottomTopPanel then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall TopBottom Pockets", Milling.LNTopBottomPocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
      end
      if WallQuestion.AddCenterPanel then
        Wall_CenterPanel()
        if WallQuestion.DrawCenterPanel then
          CreateLayerProfileToolpath(Milling.LNCenterPanelProfile .. "-Wall", Milling.Sheet .. "Wall Center Panel Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
          if WallQuestion.ShelfCount > 0 then
            CreateLayerDrillingToolpath(Milling.LNCenterPanelShelfPinDrill .."-Wall", Milling.Sheet .. "Wall Center Panel Pin Drilling", 0.0,  WallDim.MaterialThickness, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
          end -- if end
        end -- if end
      end -- if end
    -- ====
      if Project.NewSheet == "Yes" then
        NewSheet()
        NextSheet()
       -- Cab.Wpt8 = Cab.Wpt1
      end -- if end
      Wall_CabinetBack()
      if WallQuestion.AddCenterPanel and WallQuestion.DrawBackPanel  then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall Back Pockets", Milling.LNBackPocket .. "-Wall", 0.0, Milling.DadoBackHeight)
      end -- if end
      if WallQuestion.ShelfCount >= 1 then
        local CountX = WallQuestion.ShelfCount
        BOM.PID = BOM.PID + 10
        while (CountX >0) do
          Wall_CabinetShelf(CountX)
          Cab.Wpt8 = Polar2D(Cab.Wpt8, 0.0, WallDim.ShelfLength + Milling.PartGap)
          CountX = CountX - 1
        end -- while end
        BOM.PID = BOM.PID + 10
        if WallQuestion.DrawShelfPanel then
          CreateLayerProfileToolpath(Milling.LNShelfProfile .. "-Wall", Milling.Sheet .. "Wall Shelf Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        end
      end -- if end
        -- ====
       Wall_CabinetFaceFrame()
        -- ====
      if WallQuestion.DrawNotes then
        if Project.ProjectPath  ==  "Default" then
            DisplayMessageBox("Alert: The Cabinet Maker Project has not configured.  \nOpen Project dialog and set the Project path and saved.")
            return false
          else
            if not(os.rename(Project.ProjectPath, Project.ProjectPath)) then
              DisplayMessageBox("Error: Cannot find Project Path! \n Use the Project Setup menu to set the correct Project location")
              return false
            end -- if end
          end -- if end
      end -- if end
      if WallQuestion.DrawSidePanels then
        CreateLayerProfileToolpath(Milling.LNSideProfile .. "-Wall", Milling.Sheet .. "Wall Side Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end
      if WallQuestion.DrawBottomTopPanel then
        CreateLayerProfileToolpath(Milling.LNTopBottomProfile .. "-Wall", Milling.Sheet .. "Wall Top Bottom Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end
      if WallQuestion.DrawBackPanel then
        CreateLayerProfileToolpath(Milling.LNBackProfile .. "-Wall", Milling.Sheet .. "Wall Back Panel Profile", 0.0, WallDim.ThicknessBack, "OUT", Milling.Tabs)
      end
      if Project.Drawing == "Wall" then
        CutListfileWriterFooter()
      end -- if end
    end -- if end
    -- =====================================================
    if Project.Drawingx == "Base" then
      LayerMake("-Base")
      Wall_Math()
      Base_Math()
      if Project.Drawing == "Both" then
        if Project.NewSheet == "Yes" then
          NewSheet()
          NextSheet()
        else
          if Material.Orantation == "V" then
            Cab.Wpt1 = Polar2D(Cab.Wpt1,90, Milling.MaterialBlockWidth)
          else
            Cab.Wpt1 = Polar2D(Cab.Wpt1,90, Milling.MaterialBlockHeight)
          end -- if end
        end -- if end
      end -- if end
      Base_Math()
      Base_CabinetSide("L")
      Base_CabinetSide("R")
      -- Base Tool Paths
      if BaseQuestion.ShelfCount > 0 and BaseQuestion.DrawSidePanels then
        CreateLayerDrillingToolpath(Milling.LNSideShelfPinDrill .."-Base", Milling.Sheet .. "Base Side Drilling", 0.0, Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
      end -- if end
      -- ====
       if (BaseQuestion.ShelfCount >= 1) and BaseQuestion.DrawShelfPanel then
        local CountX = BaseQuestion.ShelfCount
        BOM.PID = BOM.PID + 10
        while (CountX > 0) do
          Base_CabinetShelf()
          Cab.Wpt9 = Polar2D(Cab.Wpt9, 0.0, (BaseDim.ShelfLength + Milling.PartGap))
          CountX = CountX - 1
        end -- while end
        BOM.PID = BOM.PID + 10
        -- Base Tool Paths
     --   if BaseQuestion.DrawShelfPanel then
          CreateLayerProfileToolpath(Milling.LNShelfProfile .. "-Base", Milling.Sheet .. "Base Shelf Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
     --   end -- if end
      end -- if end
      -- ====
      if BaseQuestion.AddCenterPanel and BaseQuestion.DrawCenterPanel then
        Base_CenterPanel()
      -- Base Tool Paths
        CreateLayerProfileToolpath(Milling.LNCenterPanelProfile .. "-Base", Milling.Sheet .. "Base Center Panel Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        if BaseQuestion.ShelfCount > 0 then
          CreateLayerDrillingToolpath(Milling.LNCenterPanelShelfPinDrill .. "-Base", Milling.Sheet .. "Base Center Drilling", 0.0, BaseDim.MaterialThickness, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        end -- if end
      end -- if end
      -- ====
      Base_CabinetBottom()
      -- Base Tool Paths
      if BaseQuestion.AddCenterPanel and BaseQuestion.DrawBottomPanel then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base TopBottom Pockets", Milling.LNTopBottomPocket .. "-Base", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
      end
      -- ====
      if Project.NewSheet == "Yes" then
        NewSheet()
        NextSheet()
        Cab.Wpt9 = Cab.Wpt1
      end -- if end
      -- ====
      Base_CabinetToeandRunners()
      -- Base Tool Paths
      if Project.NewSheet == "Yes" then
        NewSheet()
        NextSheet()
        Cab.Wpt9 = Cab.Wpt1
      end -- if end
      Base_CabinetBack()
      -- Base Tool Paths
      if BaseQuestion.DrawSidePanels then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base Side Pockets", Milling.LNSidePocket .. "-Base", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        CreateLayerProfileToolpath(Milling.LNSideProfile .. "-Base", Milling.Sheet .. "Base Side Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end
      if BaseQuestion.DrawBackPanel then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base Back Pockets", Milling.LNBackPocket .. "-Base", 0.0, Milling.DadoBackHeight)
        CreateLayerProfileToolpath(Milling.LNBackProfile .. "-Base", Milling.Sheet .. "Base Back Panel Profile", 0.0, BaseDim.ThicknessBack, "OUT", Milling.Tabs)
      end -- if end
      if BaseQuestion.DrawTopToe then
        CreateLayerProfileToolpath(Milling.LNStretcherRailProfile .. "-Base", Milling.Sheet .. "Base Stretcher Rails Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end -- if end
      if BaseQuestion.DrawBottomPanel then
        CreateLayerProfileToolpath(Milling.LNTopBottomProfile .. "-Base", Milling.Sheet .. "Base Top Bottom Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end -- if end
      -- ====
      Base_CabinetFaceFrame()
      -- ====
      CutListfileWriterFooter()
      end
  end -- if end
  LayerClear()
  Milling.job:Refresh2DView()
  return true
end -- function end
-- =================== End ============================]]