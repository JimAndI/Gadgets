-- VECTRIC LUA SCRIPT
--[[
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
--  Easy Cabinet Maker is written by Jim Anderson of Houston Texas 2020
-- ========================================================================================================================

Easy Cabinet Maker was written by JimAndi of Houston Texas 2019

-- Version 01 - Nov 29, 2021

-- ====================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
local Tooler1, Tooler2, Tooler3, Tooler4,  Tooler5
BaseDim = {}
BaseQuestion = {}
Milling = {}
Project = {}
WallDim = {}
WallQuestion = {}
Cab = {}            -- Points
DialogWindow = {}   -- Dialog Managment
local YearNumber = "2021"
local VerNumber = "01"
DialogWindow.AppName = "Easy Cabinet Maker"
RegName = "EasyCabinetMaker09-" .. VerNumber
--  Table Names
-- local layer
DialogWindow.BaseSDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Cabinet_Maker-Page8"
DialogWindow.LayerSDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Cabinet_Maker-Page7"
DialogWindow.ProjectSDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Cabinet_Maker-Page10"
DialogWindow.MillingSDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Cabinet_Maker-Page9"
DialogWindow.MainSDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Cabinet_Maker-Page12"
DialogWindow.WallSDK = "https://jimandi.com/SDKWiki/index.php?title=Easy_Cabinet_Maker-Page11"
DialogWindow.DialogLoop = true
local Tool_ID1 = ""
local Tool_ID2 = ""
local Tool_ID3 = ""
local Tool_ID4 = ""
--  Table Values --
Milling.MillTool1 = {} -- Profile Bit
Milling.MillTool2 = {} -- Pocketing Bit
Milling.MillTool3 = {} -- Pocketing Clearing Bit
Milling.MillTool4 = {} -- Shelf Pins Drilling
-- ====================================================]]
function InquiryWallOrBase(Header, Quest, DList)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml7, 500, 481,  Header .. "  " .. Milling.UnitDisplay)
  dialog:AddLabelField("Questions", Quest)
  dialog:AddDropDownList("ListBox", "Wall")
  dialog:AddDropDownList("Project.NewSheet", "Yes")
  dialog:AddDoubleField("WallDim.CabHeight", WallDim.CabHeight)
  dialog:AddDoubleField("WallDim.CabDepth", WallDim.CabDepth)
  dialog:AddDoubleField("WallDim.CabLength", WallDim.CabLength)
  dialog:AddDoubleField("BaseDim.CabHeight", BaseDim.CabHeight)
  dialog:AddDoubleField("BaseDim.CabDepth", BaseDim.CabDepth)
  dialog:AddDoubleField("BaseDim.CabLength", BaseDim.CabLength)
  dialog:AddTextField("Project.CabinetName", Project.CabinetName)

  dialog:AddLabelField("ToolNameLabel1", "Not Selected")
-- dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
--  dialog:AddToolPickerValidToolType("ToolChooseButton1",     Tool.END_MILL)
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", g_default_tool_name)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",     Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel2", "Not Selected")
  dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
  dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel3", "Not Selected")
  dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton3", Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel4", "Not Selected")
  dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton4", Tool.THROUGH_DRILL)
  for _, value in pairs(DList) do
    dialog:AddDropDownListValue("ListBox", value)
  end
  if  dialog:ShowDialog() then
    WallDim.CabHeight                 = dialog:GetDoubleField("WallDim.CabHeight")
    WallDim.CabDepth                  = dialog:GetDoubleField("WallDim.CabDepth")
    WallDim.CabLength                 = dialog:GetDoubleField("WallDim.CabLength")
    BaseDim.CabHeight                 = dialog:GetDoubleField("BaseDim.CabHeight")
    BaseDim.CabDepth                  = dialog:GetDoubleField("BaseDim.CabDepth")
    BaseDim.CabLength                 = dialog:GetDoubleField("BaseDim.CabLength")
    Project.CabinetName               = dialog:GetTextField("Project.CabinetName")
    Project.NewSheet                  = string.upper(dialog:GetDropDownListValue("Project.NewSheet"))
    Milling.MillTool1                 = dialog:GetTool("ToolChooseButton1")  -- Profile
    Milling.MillTool2                 = dialog:GetTool("ToolChooseButton2")  -- Pocketing
    Milling.MillTool3                 = dialog:GetTool("ToolChooseButton3")  -- Clearing
    Milling.MillTool4                 = dialog:GetTool("ToolChooseButton4")  -- Drilling
    DialogWindow.InquiryWallOrBaseXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryUpdate()
    return string.upper(dialog:GetDropDownListValue("ListBox"))
  end
end
-- ====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 720, 487, "About")
  dialog:AddLabelField("SysName", DialogWindow.AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  RegistryUpdate()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryBaseQuestion()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml5, 597, 525, "Base Cabinet Setup")
  dialog:AddDropDownList("BaseQuestion.AddCenterPanel",       ifT(BaseQuestion.AddCenterPanel))
  dialog:AddDropDownList("BaseQuestion.DrawerRowCount",       tostring(BaseQuestion.DrawerRowCount))
  dialog:AddDropDownList("BaseQuestion.ShelfCount",           tostring(BaseQuestion.ShelfCount))
  dialog:AddDoubleField("BaseDim.FaceFrameBottomRailWidth",   BaseDim.FaceFrameBottomRailWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameBottomReveal",      BaseDim.FaceFrameBottomReveal)
  dialog:AddDoubleField("BaseDim.FaceFrameCenterStileWidth",  BaseDim.FaceFrameCenterStileWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameMidRailWidth",      BaseDim.FaceFrameMidRailWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameSideReveal",        BaseDim.FaceFrameSideReveal)
  dialog:AddDoubleField("BaseDim.FaceFrameStileWidth",        BaseDim.FaceFrameStileWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameThickness",         BaseDim.FaceFrameThickness)
  dialog:AddDoubleField("BaseDim.FaceFrameTopRailWidth",      BaseDim.FaceFrameTopRailWidth)
  dialog:AddDoubleField("BaseDim.FaceFrameDrawerHeight1",     BaseDim.FaceFrameDrawerHeight1)
  dialog:AddDoubleField("BaseDim.FaceFrameDrawerHeight2",     BaseDim.FaceFrameDrawerHeight2)
  dialog:AddDoubleField("BaseDim.FaceFrameDrawerHeight3",     BaseDim.FaceFrameDrawerHeight3)
  dialog:AddDoubleField("BaseDim.ShelfEndClarence",           BaseDim.ShelfEndClarence)
  dialog:AddDoubleField("BaseDim.ShelfFaceFrameThickness",    BaseDim.ShelfFaceFrameThickness)
  dialog:AddDoubleField("BaseDim.ShelfFaceFrameWidth",        BaseDim.ShelfFaceFrameWidth)
  dialog:AddDoubleField("BaseDim.ShelfFrontClearance",        BaseDim.ShelfFrontClearance)
  dialog:AddDoubleField("BaseDim.ShelfHoleFirstRowSpacing",   BaseDim.ShelfHoleFirstRowSpacing)
  dialog:AddDoubleField("BaseDim.ShelfHoleLastRowSpacing",    BaseDim.ShelfHoleLastRowSpacing)
  dialog:AddDoubleField("BaseDim.ShelfHoleSpacing",           BaseDim.ShelfHoleSpacing)
  dialog:AddDoubleField("BaseDim.ShelfMaterialThickness",     BaseDim.ShelfMaterialThickness)
  dialog:AddDoubleField("BaseDim.ShelfPinHoleBack",           BaseDim.ShelfPinHoleBack)
  dialog:AddDoubleField("BaseDim.ShelfPinHoleFront",          BaseDim.ShelfPinHoleFront)
  dialog:AddDoubleField("BaseDim.StretcherThickness",         BaseDim.StretcherThickness)
  dialog:AddDoubleField("BaseDim.StretcherWidth",             BaseDim.StretcherWidth)
  dialog:AddDoubleField("BaseDim.MaterialThickness",          BaseDim.MaterialThickness)
  dialog:AddDoubleField("BaseDim.ThicknessBack",              BaseDim.ThicknessBack)
  dialog:AddDoubleField("BaseDim.ToeKickBottomOffsetHeight",  BaseDim.ToeKickBottomOffsetHeight)
  dialog:AddDoubleField("BaseDim.ToeKickDepth",               BaseDim.ToeKickDepth)
  dialog:AddDoubleField("BaseDim.ToeKickHeight",              BaseDim.ToeKickHeight)
  dialog:AddDoubleField("BaseDim.TopFrameWidth",              BaseDim.TopFrameWidth)
  if dialog:ShowDialog() then
    BaseQuestion.AddCenterPanel       = ifY(dialog:GetDropDownListValue("BaseQuestion.AddCenterPanel"))
    BaseQuestion.ShelfCount           = tonumber(dialog:GetDropDownListValue("BaseQuestion.ShelfCount"))
    BaseQuestion.DrawerRowCount       = tonumber(dialog:GetDropDownListValue("BaseQuestion.DrawerRowCount"))
    BaseDim.FaceFrameBottomRailWidth  = dialog:GetDoubleField("BaseDim.FaceFrameBottomRailWidth")
    BaseDim.FaceFrameBottomReveal     = dialog:GetDoubleField("BaseDim.FaceFrameBottomReveal")
    BaseDim.FaceFrameCenterStileWidth = dialog:GetDoubleField("BaseDim.FaceFrameCenterStileWidth")
    BaseDim.FaceFrameMidRailWidth     = dialog:GetDoubleField("BaseDim.FaceFrameMidRailWidth")
    BaseDim.FaceFrameSideReveal       = dialog:GetDoubleField("BaseDim.FaceFrameSideReveal")
    BaseDim.FaceFrameStileWidth       = dialog:GetDoubleField("BaseDim.FaceFrameStileWidth")
    BaseDim.FaceFrameThickness        = dialog:GetDoubleField("BaseDim.FaceFrameThickness")
    BaseDim.FaceFrameTopRailWidth     = dialog:GetDoubleField("BaseDim.FaceFrameTopRailWidth")
    BaseDim.FaceFrameDrawerHeight1    = dialog:GetDoubleField("BaseDim.FaceFrameDrawerHeight1")
    BaseDim.FaceFrameDrawerHeight2    = dialog:GetDoubleField("BaseDim.FaceFrameDrawerHeight2")
    BaseDim.FaceFrameDrawerHeight3    = dialog:GetDoubleField("BaseDim.FaceFrameDrawerHeight3")
    BaseDim.ShelfEndClarence          = dialog:GetDoubleField("BaseDim.ShelfEndClarence")
    BaseDim.ShelfFaceFrameThickness   = dialog:GetDoubleField("BaseDim.ShelfFaceFrameThickness")
    BaseDim.ShelfFaceFrameWidth       = dialog:GetDoubleField("BaseDim.ShelfFaceFrameWidth")
    BaseDim.ShelfFrontClearance       = dialog:GetDoubleField("BaseDim.ShelfFrontClearance")
    BaseDim.ShelfHoleFirstRowSpacing  = dialog:GetDoubleField("BaseDim.ShelfHoleFirstRowSpacing")
    BaseDim.ShelfHoleLastRowSpacing   = dialog:GetDoubleField("BaseDim.ShelfHoleLastRowSpacing")
    BaseDim.ShelfHoleSpacing          = dialog:GetDoubleField("BaseDim.ShelfHoleSpacing")
    BaseDim.ShelfMaterialThickness    = dialog:GetDoubleField("BaseDim.ShelfMaterialThickness")
    BaseDim.ShelfPinHoleBack          = dialog:GetDoubleField("BaseDim.ShelfPinHoleBack")
    BaseDim.ShelfPinHoleFront         = dialog:GetDoubleField("BaseDim.ShelfPinHoleFront")
    BaseDim.StretcherThickness        = dialog:GetDoubleField("BaseDim.StretcherThickness")
    BaseDim.StretcherWidth            = dialog:GetDoubleField("BaseDim.StretcherWidth")
    BaseDim.MaterialThickness         = dialog:GetDoubleField("BaseDim.MaterialThickness")
    BaseDim.ThicknessBack             = dialog:GetDoubleField("BaseDim.ThicknessBack")
    BaseDim.ToeKickBottomOffsetHeight = dialog:GetDoubleField("BaseDim.ToeKickBottomOffsetHeight")
    BaseDim.ToeKickDepth              = dialog:GetDoubleField("BaseDim.ToeKickDepth")
    BaseDim.ToeKickHeight             = dialog:GetDoubleField("BaseDim.ToeKickHeight")
    BaseDim.TopFrameWidth             = dialog:GetDoubleField("BaseDim.TopFrameWidth")
    DialogWindow.BaseCabinetXY        = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    RegistryUpdate()
  end
  Base_Math()
  RegistryUpdate()
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryLayers( )
  local dialog = HTML_Dialog(true, DialogWindow.myHtml4, 647, 460, "Layer Setup")
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
    Milling.LNBackPocket               = dialog:GetTextField("Milling.LNBackPocket")
    Milling.LNBackProfile              = dialog:GetTextField("Milling.LNBackProfile")
    Milling.LNCenterPanelProfile       = dialog:GetTextField("Milling.LNCenterPanelProfile")
    Milling.LNCenterPanelShelfPinDrill = dialog:GetTextField("Milling.LNCenterPanelShelfPinDrill")
    Milling.LNDrawFaceFrame            = dialog:GetTextField("Milling.LNDrawFaceFrame")
    Milling.LNShelfProfile             = dialog:GetTextField("Milling.LNShelfProfile")
    Milling.LNSideProfile              = dialog:GetTextField("Milling.LNSideProfile")
    Milling.LNSidePocket               = dialog:GetTextField("Milling.LNSidePocket")
    Milling.LNSideShelfPinDrill        = dialog:GetTextField("Milling.LNSideShelfPinDrill")
    Milling.LNTopBottomProfile         = dialog:GetTextField("Milling.LNTopBottomProfile")
    Milling.LNTopBottomPocket          = dialog:GetTextField("Milling.LNTopBottomPocket")
    Milling.LNStretcherRailProfile     = dialog:GetTextField("Milling.LNStretcherRailProfile")
    Milling.LNPartLabels               = dialog:GetTextField("Milling.LNPartLabels")
    Milling.LNDrawNotes                = dialog:GetTextField("Milling.LNDrawNotes")
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
    DialogWindow.LayerXY                      = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryUpdate()
  end
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryMilling()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml3 , 498, 215, "Milling Setting ")
  dialog:AddDoubleField("Milling.ShelfPinDiameter", Milling.ShelfPinDiameter)
  dialog:AddDoubleField("Milling.ShelfPinLen",      Milling.ShelfPinLen)
  dialog:AddDoubleField("Milling.DadoClearance",    Milling.DadoClearance)
  dialog:AddDoubleField("Milling.DadoHeight",       Milling.DadoHeight)
  dialog:AddDoubleField("Milling.RabbitClearance",  Milling.RabbitClearance)
  dialog:AddDoubleField("Milling.DadoBackHeight",   Milling.DadoBackHeight)
  dialog:AddDoubleField("Milling.PartGap",          Milling.PartGap)
  if dialog:ShowDialog() then
    Milling.ShelfPinDiameter       = dialog:GetDoubleField("Milling.ShelfPinDiameter")
    Milling.ShelfPinLen            = dialog:GetDoubleField("Milling.ShelfPinLen")
    Milling.DadoClearance          = dialog:GetDoubleField("Milling.DadoClearance")
    Milling.DadoBackHeight         = dialog:GetDoubleField("Milling.DadoBackHeight")
    Milling.PartGap                = dialog:GetDoubleField("Milling.PartGap")
    Milling.RabbitClearance        = dialog:GetDoubleField("Milling.RabbitClearance")
    DialogWindow.MillingXY         = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryUpdate()
  end
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryProjectInfo( )
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, 561, 270, "Project Setup")
  dialog:AddTextField("Project.ProjectName", Project.ProjectName)
  dialog:AddTextField("Project.ProjectContactEmail", Project.ProjectContactEmail)
  dialog:AddTextField("Project.ProjectContactName", Project.ProjectContactName)
  dialog:AddTextField("Project.ProjectContactPhoneNumber", Project.ProjectContactPhoneNumber)
  dialog:AddTextField("Project.DrawerID", StartDate())
  dialog:AddTextField("Project.ProjectPath", Project.ProjectPath )
  dialog:AddDirectoryPicker("DirectoryPicker", "Project.ProjectPath",  true)
  if dialog:ShowDialog() then
    Project.ProjectName = dialog:GetTextField("Project.ProjectName")
    Project.ProjectContactEmail = dialog:GetTextField("Project.ProjectContactEmail")
    Project.ProjectContactName = dialog:GetTextField("Project.ProjectContactName")
    Project.ProjectContactPhoneNumber = dialog:GetTextField("Project.ProjectContactPhoneNumber")
    Project.DrawerID = dialog:GetTextField("Project.DrawerID")
    Project.ProjectPath = dialog:GetTextField("Project.ProjectPath")
    DialogWindow.ProjectXY = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryUpdate()
  end
  return  true
end
-- ====================================================]]
function OnLuaButton_InquiryWallQuestion()
  local dialog = HTML_Dialog(true,  DialogWindow.myHtml1, 619, 417, "Wall Cabinet Setup")
  dialog:AddDropDownList("WallQuestion.AddCenterPanel",      ifT(WallQuestion.AddCenterPanel))
  dialog:AddDropDownList("WallQuestion.AddCenterFaceFrame",  ifT(WallQuestion.AddCenterFaceFrame))
  dialog:AddDropDownList("WallQuestion.ShelfCount",          tostring(WallQuestion.ShelfCount))
  dialog:AddDoubleField("WallDim.FaceFrameBottomRailWidth",  WallDim.FaceFrameBottomRailWidth)
  dialog:AddDoubleField("WallDim.FaceFrameBottomReveal",     WallDim.FaceFrameBottomReveal)
  dialog:AddDoubleField("WallDim.FaceFrameCenterStileWidth", WallDim.FaceFrameCenterStileWidth)
  dialog:AddDoubleField("WallDim.FaceFrameSideReveal",       WallDim.FaceFrameSideReveal)
  dialog:AddDoubleField("WallDim.FaceFrameStileWidth",       WallDim.FaceFrameStileWidth)
  dialog:AddDoubleField("WallDim.FaceFrameThickness",        WallDim.FaceFrameThickness)
  dialog:AddDoubleField("WallDim.FaceFrameTopReveal",        WallDim.FaceFrameTopReveal)
  dialog:AddDoubleField("WallDim.FaceFrameTopRailWidth",     WallDim.FaceFrameTopRailWidth)
  dialog:AddDoubleField("WallDim.ShelfEndClarence",          WallDim.ShelfEndClarence)
  dialog:AddDoubleField("WallDim.ShelfFaceFrameThickness",   WallDim.ShelfFaceFrameThickness)
  dialog:AddDoubleField("WallDim.ShelfFaceFrameWidth",       WallDim.ShelfFaceFrameWidth)
  dialog:AddDoubleField("WallDim.ShelfFrontClearance",       WallDim.ShelfFrontClearance)
  dialog:AddDoubleField("WallDim.ShelfHoleFirstRowSpacing",  WallDim.ShelfHoleFirstRowSpacing)
  dialog:AddDoubleField("WallDim.ShelfHoleLastRowSpacing",   WallDim.ShelfHoleLastRowSpacing)
  dialog:AddDoubleField("WallDim.ShelfHoleSpacing",          WallDim.ShelfHoleSpacing)
  dialog:AddDoubleField("WallDim.ShelfMaterialThickness",    WallDim.ShelfMaterialThickness)
  dialog:AddDoubleField("WallDim.ShelfPinHoleBack",          WallDim.ShelfPinHoleBack)
  dialog:AddDoubleField("WallDim.ShelfPinHoleFront",         WallDim.ShelfPinHoleFront)
  dialog:AddDoubleField("WallDim.MaterialThickness",         WallDim.MaterialThickness)
  dialog:AddDoubleField("WallDim.ThicknessBack",             WallDim.ThicknessBack)
  if dialog:ShowDialog() then
    WallQuestion.AddCenterPanel         = ifY(dialog:GetDropDownListValue("WallQuestion.AddCenterPanel"))
    WallQuestion.AddCenterFaceFrame     = ifY(dialog:GetDropDownListValue("WallQuestion.AddCenterFaceFrame"))
    WallQuestion.ShelfCount             = tonumber(dialog:GetDropDownListValue("WallQuestion.ShelfCount"))
    WallDim.FaceFrameBottomRailWidth    = dialog:GetDoubleField("WallDim.FaceFrameBottomRailWidth")
    WallDim.FaceFrameBottomReveal       = dialog:GetDoubleField("WallDim.FaceFrameBottomReveal")
    WallDim.FaceFrameCenterStileWidth   = dialog:GetDoubleField("WallDim.FaceFrameCenterStileWidth")
    WallDim.FaceFrameSideReveal         = dialog:GetDoubleField("WallDim.FaceFrameSideReveal")
    WallDim.FaceFrameStileWidth         = dialog:GetDoubleField("WallDim.FaceFrameStileWidth")
    WallDim.FaceFrameThickness          = dialog:GetDoubleField("WallDim.FaceFrameThickness")
    WallDim.FaceFrameTopReveal          = dialog:GetDoubleField("WallDim.FaceFrameTopReveal")
    WallDim.FaceFrameTopRailWidth       = dialog:GetDoubleField("WallDim.FaceFrameTopRailWidth")
    WallDim.ShelfEndClarence            = dialog:GetDoubleField("WallDim.ShelfEndClarence")
    WallDim.ShelfFaceFrameThickness     = dialog:GetDoubleField("WallDim.ShelfFaceFrameThickness")
    WallDim.ShelfFaceFrameWidth         = dialog:GetDoubleField("WallDim.ShelfFaceFrameWidth")
    WallDim.ShelfFrontClearance         = dialog:GetDoubleField("WallDim.ShelfFrontClearance")
    WallDim.ShelfHoleFirstRowSpacing    = dialog:GetDoubleField("WallDim.ShelfHoleFirstRowSpacing")
    WallDim.ShelfHoleLastRowSpacing     = dialog:GetDoubleField("WallDim.ShelfHoleLastRowSpacing")
    WallDim.ShelfHoleSpacing            = dialog:GetDoubleField("WallDim.ShelfHoleSpacing")
    WallDim.ShelfMaterialThickness      = dialog:GetDoubleField("WallDim.ShelfMaterialThickness")
    WallDim.ShelfPinHoleBack            = dialog:GetDoubleField("WallDim.ShelfPinHoleBack")
    WallDim.ShelfPinHoleFront           = dialog:GetDoubleField("WallDim.ShelfPinHoleFront")
    WallDim.MaterialThickness           = dialog:GetDoubleField("WallDim.MaterialThickness")
    WallDim.ThicknessBack               = dialog:GetDoubleField("WallDim.ThicknessBack")
    DialogWindow.WallCabinetXY          = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    Wall_Math()
    RegistryUpdate()
  end
  return  true
end
-- ====================================================]]
function main(script_path)
  Milling.job = VectricJob()
  if not Milling.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end

  Tooler1 = assert(loadfile(script_path .. "\\EasyCabinetBase09-".. VerNumber .. ".xlua")) (Tooler1) -- Load Tool Function
  Tooler2 = assert(loadfile(script_path .. "\\EasyCabinetWall09-".. VerNumber .. ".xlua")) (Tooler2) -- Load Tool Function
  Tooler3 = assert(loadfile(script_path .. "\\EasyCabinetTools09-".. VerNumber .. ".xlua")) (Tooler3) -- Load Tool Function
  Tooler4 = assert(loadfile(script_path .. "\\EasyCabinetDialog09-" .. VerNumber .. ".xlua")) (Tooler4) -- Load Tool Function
  Tooler5 = assert(loadfile(script_path .. "\\EasyCabinetLibrary09-" .. VerNumber .. ".xlua")) (Tooler5) -- Load Tool Function

  Milling.MaterialBlock          = MaterialBlock()
  Milling.MaterialBlockThickness = Milling.MaterialBlock.Thickness
  --local units
  if Milling.MaterialBlock.InMM then
    Milling.Units = "mm"
    Milling.Unit  = true
  else
    Milling.Units = "inch"
    Milling.Unit  = false
  end
  Milling.UnitDisplay  = "Note: Units: (" .. Milling.Units ..")"
  RegistryRead()
  HTML()
  Wall_Math()
  Base_Math()
  Mill_Math()
  Project.NewSheet = "YES"
  local Drawing = InquiryWallOrBase("Easy Cabinet Maker", "Select Cabinet Type", {"Wall", "Base", "Both"})
  if Drawing then
    if Project.ProjectPath  ==  "Default" then
      DisplayMessageBox("Alert: The Cabinet Maker is not configured.  \n The Project path must be selected and saved.")
      return false
    else
      if not(os.rename(Project.ProjectPath, Project.ProjectPath)) then
        DisplayMessageBox("Error: Cannot find the Project Path or Access is blocked. \nCheck the full path is made and no application have open files in the folder. \n\nUse the Project Setup menu to set the correct Project location")
        return false
      end -- if rename
      if Project.NewSheet == "YES" then
        Milling.Sheet = "1-"
        NewSheet()
      else
        Milling.Sheet = ""
      end
      MakeLayers("")
      Wall_Math()
      Base_Math()
      Mill_Math()
      RegistryRead()
      if type(Milling.MillTool1) == "userdata"  then
        Milling.Profile = true
      else
        Milling.Profile = false
      end  -- if end
      if type(Milling.MillTool2) == "userdata" then -- and type(Milling.MillTool3) == "userdata") then
        Milling.Pocket = true
      else
        Milling.Pocket = false
      end  -- if end
      if type(Milling.MillTool4) == "userdata"  then
        Milling.Drilling = true
      else
        Milling.Drilling = false
      end  -- if end
      if (type(Milling.MillTool1) == "userdata" and type(Milling.MillTool2) == "userdata" and type(Milling.MillTool3) == "userdata") then
        Milling.Tools = true
      else
        Milling.Tools = false
      end  -- if end
      Milling.MaterialBlock = MaterialBlock()
      Milling.MaterialBlockThickness = Milling.MaterialBlock.Thickness
      Milling.Toolpath_Mgr = ToolpathManager()
      if Milling.Toolpath_Mgr.Count >0 then
        Milling.Toolpath_Mgr:DeleteAllToolpaths()
      end -- if end
      CutListfileWriterHeader(Drawing)
      if Drawing == "WALL" then
        Project.Drawing = "WALL"
      end -- if end
      if Drawing == "BASE" then
        Project.Drawing = "BASE"
      end -- if end
      if Drawing == "BOTH" then
        Project.Drawing = "WALL"
      end -- if end
      if Project.Drawing == "WALL" then
        if Drawing == "BOTH" then
          Project.Drawing = "BASE"
        end -- if end
        MakeLayers("-Wall")
        Cab.Wpt2 = Polar2D(Cab.Wpt1, 0.0,(WallDim.CabHeight + Milling.PartGap))
        Cab.Wpt3 = Polar2D(Cab.Wpt1, 90.0, WallDim.CabDepth + Milling.PartGap - WallDim.FaceFrameThickness)
        Cab.Wpt4 = Polar2D(Cab.Wpt3, 0.0, (WallDim.CabLength - WallDim.MaterialThickness ) + Milling.PartGap)
        Cab.Wpt5 = Polar2D(Cab.Wpt3, 90.0, WallDim.CabDepth + Milling.PartGap - WallDim.FaceFrameThickness) --  Shelf
        Cab.Wpt6 = Polar2D(Cab.Wpt5, 90.0, WallDim.ShelfWidth + Milling.PartGap) --  Shelf
        Cab.Wpt7 = Polar2D(Cab.Wpt2, 0.0, WallDim.CabHeight + Milling.PartGap) --  Wall_CenterPanel()
        Cab.Wpt8 = Polar2D(Cab.Wpt2, 0.0, WallDim.CabDepth + Milling.PartGap) --  Shelf
        if WallQuestion.AddFaceFrame then
          WallDim.CabDepth  = WallDim.CabDepth - WallDim.FaceFrameThickness
        else
          WallDim.FaceFrameTopRailWidth = 0.0
          WallDim.FaceFrameBottomRailWidth = 0.0
          WallDim.FaceFrameBottomReveal = 0.0
          WallDim.FaceFrameTopOverlap = 0.0
        end
        -- ====
        Wall_CabinetSide("L")
        -- ====
        Wall_CabinetSide("R")
        -- ====
        Wall_CabinetTandB("T")
        -- ====
        Wall_CabinetTandB("B")
        -- Wall Tool Paths
      -- ====================]]
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall Side Pockets", Milling.LNSidePocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall TopBottom Pockets", Milling.LNTopBottomPocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
      -- ====================]]
        CreateLayerProfileToolpath(Milling.LNSideProfile .. "-Wall", Milling.Sheet .. "Wall Side Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        CreateLayerProfileToolpath(Milling.LNTopBottomProfile .. "-Wall", Milling.Sheet .. "Wall Top Bottom Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        CreateLayerDrillingToolpath(Milling.LNSideShelfPinDrill .."-Wall", Milling.Sheet .. "Wall Pin Drilling", 0.0,  Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
      -- ====
        if WallQuestion.ShelfCount >= 1 then
          local CountX = WallQuestion.ShelfCount
          while (CountX >0) do
            Wall_CabinetShelf(CountX)
            Cab.Wpt5 = Polar2D(Cab.Wpt5, 0.0, WallDim.ShelfLength + Milling.PartGap)
            CountX = CountX - 1
          end -- while end
          CreateLayerProfileToolpath(Milling.LNShelfProfile .. "-Wall", Milling.Sheet .. "Wall Shelf Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        end -- if end
        -- ====
        if WallQuestion.AddCenterPanel then
          Wall_CenterPanel()
          CreateLayerProfileToolpath(Milling.LNCenterPanelProfile .. "-Wall", Milling.Sheet .. "Center Panel Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
          CreateLayerDrillingToolpath( Milling.LNCenterPanelShelfPinDrill .."-Wall", Milling.Sheet .. "Wall Pin Drilling", 0.0,   Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        end -- if end
        -- ====
        if Project.NewSheet == "YES" then
          NewSheet()
          NextSheet()
          Cab.Wpt8 = Cab.Wpt1
        end -- if end
        Wall_CabinetBack()
        if WallQuestion.AddCenterPanel then
          CreateLayerPocketingToolpath(Milling.Sheet .. "Wall Back Pockets", Milling.LNBackPocket .. "-Wall", 0.0, Milling.DadoBackHeight)
        end -- if end
        CreateLayerProfileToolpath(Milling.LNBackProfile .. "-Wall", Milling.Sheet .. "Wall Back Panel Profile", 0.0, WallDim.ThicknessBack, "OUT", Milling.Tabs)
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
            end -- if rename
            if not Drawing == "BOTH" then
              CutListfileWriterFooter()
            end -- if end
          end -- if end
        end -- if end
      end -- if end
  -- ====================================================]]
      if Project.Drawing == "BASE" then
        MakeLayers("-Base")
        if Drawing == "BOTH" then
          if Project.NewSheet == "YES" then
            NewSheet()
            NextSheet()
          else
            Cab.Wpt1 = Point2D(1, 50)
          end -- if end
        end -- if end
        Base_Math()
        -- ====
        Cab.Wpt2 = Polar2D(Cab.Wpt1, 0.0,(BaseDim.CabHeight +  Milling.PartGap)) --  Side
        Cab.Wpt3 = Polar2D(Cab.Wpt1, 90,(BaseDim.CabDepth + Milling.PartGap - BaseDim.FaceFrameThickness)) --  Shelves
        Cab.Wpt4 = Polar2D(Cab.Wpt3, 0.0, (((BaseDim.ShelfLength + Milling.PartGap) * BaseQuestion.ShelfCount) - BaseDim.FaceFrameThickness) )
        Cab.Wpt5 = Polar2D(Cab.Wpt3, 90,(BaseDim.CabDepth  +  Milling.PartGap)) --  Shelf
        Cab.Wpt6 = Polar2D(Cab.Wpt2, 0.0, BaseDim.CabHeight +  Milling.PartGap) --  Center
        Cab.Wpt7 = Point2D(((BaseDim.CabLength * 2.0) + (3.0 * Milling.PartGap) - (BaseDim.FaceFrameThickness * 1.0)),1.0) --  Back
        Cab.Wpt8 = Point2D(((BaseDim.CabLength * 2.0) + (3.0 * Milling.PartGap) + (BaseDim.BackPanelWidth * 1.0)),1.0) --  FaceFrame
        Cab.Wpt9 = Polar2D(Cab.Wpt6, 0.0, BaseDim.CabDepth +  Milling.PartGap)  --  Toe
        -- ====
        if BaseQuestion.AddFaceFrame == false then
          BaseDim.FaceFrameTopRailWidth = 0.0
          BaseDim.FaceFrameBottomRailWidth = 0.0
          BaseDim.FaceFrameBottomReveal = 0.0
          BaseDim.FaceFrameTopOverlap = 0.0
        end -- if end
        -- ====
        Base_CabinetSide("L")
        -- ====
        Base_CabinetSide("R")
        -- Base Tool Paths
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base Side Pockets", Milling.LNSidePocket .. "-Base", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        CreateLayerProfileToolpath(Milling.LNSideProfile .. "-Base", Milling.Sheet .. "Base Side Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        CreateLayerDrillingToolpath(Milling.LNSideShelfPinDrill .."-Base", Milling.Sheet .. "Base Center Drilling", 0.0, Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        -- ====
        if BaseQuestion.ShelfCount >= 1 then
          local CountX = BaseQuestion.ShelfCount
          while (CountX >0) do
            Base_CabinetShelf(CountX)
            Cab.Wpt3 = Polar2D(Cab.Wpt3, 0.0, (BaseDim.ShelfLength + Milling.PartGap))
            CountX = CountX - 1
          end -- while end
          -- Base Tool Paths
          CreateLayerProfileToolpath(Milling.LNShelfProfile .. "-Base", Milling.Sheet .. "Base Shelf Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        end -- if end
        -- ====
        if BaseQuestion.AddCenterPanel then
          Base_CenterPanel()
        -- Base Tool Paths
          CreateLayerProfileToolpath(Milling.LNCenterPanelProfile .. "-Base", Milling.Sheet .. "Base Center Panel Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
         CreateLayerDrillingToolpath(Milling.LNCenterPanelShelfPinDrill .. "-Base", Milling.Sheet .. "Base Side Drilling", 0.0, Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        end -- if end
        -- ====
        Base_CabinetBottom()
        -- Base Tool Paths
        if BaseQuestion.AddCenterPanel then
          CreateLayerPocketingToolpath(Milling.Sheet .. "Base TopBottom Pockets", Milling.LNTopBottomPocket .. "-Base", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        end
          CreateLayerProfileToolpath(Milling.LNTopBottomProfile .. "-Base", Milling.Sheet .. "Base Top Bottom Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        -- ====
        if Project.NewSheet == "YES" then
          NewSheet()
          NextSheet()
          Cab.Wpt9 = Cab.Wpt1
        end -- if end
        -- ====
        Base_CabinetToeandRunners()
        -- Base Tool Paths
        CreateLayerProfileToolpath(Milling.LNStretcherRailProfile .. "-Base", Milling.Sheet .. "Base Stretcher Rails Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        -- ====
        if Project.NewSheet == "YES" then
          NewSheet()
          NextSheet()
          Cab.Wpt9 = Cab.Wpt1
        end -- if end
        Base_CabinetBack()
        -- Base Tool Paths
          if BaseQuestion.AddCenterPanel then
            CreateLayerPocketingToolpath(Milling.Sheet .. "Base Back Pockets", Milling.LNBackPocket .. "-Base", 0.0, Milling.DadoBackHeight)
          end -- if end
          CreateLayerProfileToolpath(Milling.LNBackProfile .. "-Base", Milling.Sheet .. "Base Back Panel Profile", 0.0, BaseDim.ThicknessBack, "OUT", Milling.Tabs)
        -- ====
        Base_CabinetFaceFrame()
        -- ====
        CutListfileWriterFooter()
      end -- if end
    end -- if end
-- ====================]]
  end
  Milling.job:Refresh2DView()
  return true
end -- function end
-- =================== End ============================]]