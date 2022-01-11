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
--  Easy Cabinet Maker is written by JimAndi Gadgets of Houston Texas 2020
-- ========================================================================================================================

Easy Base Cabinet Maker was written by JimAndi Gadgets of Houston Texas 2020
-- Version 10-8.0 - Sept 12, 2020
-- Version 10-8.1 - Jan 21, 2021
-- Version 10-8.2 - Mar 9, 2021
-- Version 10-8.3 - Mar 12, 2021
-- Version 10-9.0 - Mar 13, 2021 - Added sheet layout H or V
-- Version 11-0.0 - July 27, 2021 - Added code to manage the newsheet issue with Version 11
-- =====================================================]]
-- Global variables
require("mobdebug").start()
--require "strict"
local Tools
local YearNumber = "2021"
local VerNumber = "10-9.2"
local AppName = "Easy Base Cabinet Maker"
local RegName = "EasyBaseCabinetMaker" .. VerNumber
--  Table Names
BaseDim           = {}
BaseQuestion      = {}
Milling           = {}
Project           = {}
WallDim           = {}
WallQuestion      = {}
Material          = {}
Cab               = {}            -- Points
DialogWindow      = {}   -- Dialog Managment
local layer
DialogWindow.BaseSDK    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Base.html"
DialogWindow.LayerSDK   = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Layers.html"
DialogWindow.ProjectSDK = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Project.html"
DialogWindow.MillingSDK = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Milling.html"
DialogWindow.MainSDK    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/index.html"
DialogWindow.WallSDK    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Wall.html"
DialogWindow.DialogLoop = true
local Tool_ID1 = ToolDBId()
local Tool_ID2 = ToolDBId()
local Tool_ID3 = ToolDBId()
local Tool_ID4 = ToolDBId()

Material.BaseCabinetBackWidth    = 0.0
Material.BaseCabinetBottomLength = 0.0
Material.BaseCabinetBottomWidth  = 0.0
Material.BaseCabinetSideLength   = 0.0
Material.BaseCabinetSideWidth    = 0.0
Material.BaseShelfLength         = 0.0
Material.BaseShelfWidth          = 0.0
Material.FaceFrameCenterLength1  = 0.0
Material.FaceFrameCenterLength2  = 0.0
Material.FaceFrameCenterLength3  = 0.0
Material.FaceFrameCenterLength4  = 0.0
Material.FaceFrameCenterLength5  = 0.0
Material.FaceFrameRailLength     = 0.0
Material.FaceFrameStileLength    = 0.0
Material.ToeKickLength           = 0.0
Material.ToeKickWidth            = 0.0


--  Table Values --
Project.Drawing = "BOTH"

Milling.Tabs = false           --  User to setup Tabs
-- =====================================================]]
function Base_Math()  --  All the math for Wall Cabinet
  BaseDim.BackPanelWidth       = BaseDim.CabHeight
  BaseDim.SidePanelWidth       = BaseDim.CabDepth - BaseDim.FaceFrameThickness
  BaseDim.SidePanelLength      = BaseDim.CabHeight
  BaseDim.TopBottomPanelWidth  = (BaseDim.CabDepth - BaseDim.FaceFrameThickness) - Milling.DadoBackHeight
  BaseDim.BackPanelLength      = BaseDim.CabLength - ( (Milling.DadoHeight  + BaseDim.FaceFrameSideReveal) * 2.0)
  BaseDim.TopBottomPanelLength = BaseDim.BackPanelLength
  BaseDim.FaceFrameStileLength = BaseDim.CabHeight  - BaseDim.ToeKickHeight
  BaseDim.FaceFrameRailLength  = BaseDim.CabLength - ( BaseDim.FaceFrameStileWidth * 2.0)
  BaseDim.ShelfWidth           = BaseDim.CabDepth - (BaseDim.ThicknessBack + BaseDim.FaceFrameThickness + BaseDim.ShelfFrontClearance )
  BaseDim.ToeKickCoverHeight   = ((BaseDim.ToeKickHeight + BaseDim.FaceFrameBottomRailWidth) - (BaseDim.FaceFrameBottomReveal + BaseDim.MaterialThickness + BaseDim.ToeKickBottomOffsetHeight ))
  Project.DrawerID             = StartDate()

  if BaseQuestion.DrawerRowCount > 3 then
    BaseQuestion.DrawerRowCount = 3
  end
  if BaseQuestion.AddCenterPanel then
    BaseDim.ShelfLength              = (BaseDim.CabLength - ((BaseDim.FaceFrameSideReveal * 2.0) + (BaseDim.MaterialThickness  * 3.0) + (BaseDim.ShelfEndClarence * 4.0)))* 0.5
    BaseDim.ShelfNoseLength          = BaseDim.ShelfLength
    BaseQuestion.NumberDrawersPerRow = 2
    BaseQuestion.AddCenterFaceFrame  = true
    BaseQuestion.AddStrecherPocket   = false
  else
    BaseDim.ShelfLength = (BaseDim.CabLength - (((BaseDim.MaterialThickness  + BaseDim.FaceFrameSideReveal) * 2.0) + (BaseDim.ShelfEndClarence * 2.0)))
    BaseDim.ShelfNoseLength  = BaseDim.ShelfLength
    BaseQuestion.NumberDrawersPerRow = 1
    BaseQuestion.AddCenterFaceFrame = false
    BaseQuestion.AddStrecherPocket = true
  end
  if BaseQuestion.DrawerRowCount == 3 then
    BaseDim.HoleDrop = BaseDim.ShelfHoleFirstRowSpacing + BaseDim.FaceFrameTopRailWidth + BaseDim.FaceFrameDrawerHeight1 + BaseDim.FaceFrameMidRailWidth + BaseDim.FaceFrameDrawerHeight2 + BaseDim.FaceFrameMidRailWidth + BaseDim.FaceFrameDrawerHeight3 + BaseDim.FaceFrameMidRailWidth

  elseif BaseQuestion.DrawerRowCount == 2 then
    BaseDim.HoleDrop = BaseDim.ShelfHoleFirstRowSpacing + BaseDim.FaceFrameTopRailWidth + BaseDim.FaceFrameDrawerHeight1 + BaseDim.FaceFrameMidRailWidth + BaseDim.FaceFrameDrawerHeight2 + BaseDim.FaceFrameMidRailWidth
  elseif BaseQuestion.DrawerRowCount == 1 then
    BaseDim.HoleDrop = BaseDim.ShelfHoleFirstRowSpacing + BaseDim.FaceFrameTopRailWidth + BaseDim.FaceFrameDrawerHeight1 + BaseDim.FaceFrameMidRailWidth
  else
    BaseDim.HoleDrop = BaseDim.ShelfHoleFirstRowSpacing + BaseDim.FaceFrameTopRailWidth + BaseDim.FaceFrameMidRailWidth
  end
  BaseDim.HoleSpace = BaseDim.SidePanelWidth - (BaseDim.ThicknessBack + BaseDim.ShelfPinHoleFront + BaseDim.ShelfPinHoleBack)
  BaseDim.HoleRows = ((BaseDim.CabDepth - (BaseDim.ShelfHoleFirstRowSpacing + BaseDim.ShelfHoleLastRowSpacing + (BaseDim.MaterialThickness * 2.0))) / BaseDim.ShelfHoleSpacing)
  BaseDim.CenterPanelLength = (BaseDim.SidePanelLength + Milling.DadoHeight) - (BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight + (BaseDim.MaterialThickness * 2.0))
  BaseDim.CenterPanelWidth =  BaseDim.TopBottomPanelWidth
  return true
end
-- =====================================================]]
function Mill_Math()  --  All the math for Wall Cabinet
  Milling.ShelfPinRadius    = Milling.ShelfPinDiameter * 0.500
  Milling.ProfileToolRadius = Milling.ProfileToolDia * 0.500
  Milling.PocketToolRadius  = Milling.PocketToolDia * 0.500
  Project.DrawerID  = StartDate()
  return true
end
-- =====================================================]]
function Wall_Math()  --  All the math for Wall Cabinet
  WallQuestion.AddFaceFrame = true
  WallDim.BackPanelWidth = WallDim.CabHeight - Milling.DadoHeight
  WallDim.FaceFrameTopOverlap = WallDim.FaceFrameTopRailWidth - WallDim.FaceFrameTopReveal-WallDim.MaterialThickness
  WallDim.BackPanelLength = WallDim.CabLength - ( (Milling.DadoHeight * 2.0) + (WallDim.FaceFrameSideReveal * 2.0))
  WallDim.SidePanelWidth  = WallDim.CabDepth - WallDim.FaceFrameThickness
  WallDim.SidePanelLength =  WallDim.CabHeight - WallDim.FaceFrameTopOverlap
  WallDim.TopBottomPanelWidth = WallDim.CabDepth - WallDim.FaceFrameThickness
  WallDim.TopBottomPanelLength =  WallDim.CabLength - ( (Milling.DadoHeight * 2.0) + (WallDim.FaceFrameSideReveal * 2.0))
  WallDim.FaceFrameStileLength = WallDim.CabHeight
  Project.DrawerID = StartDate()
  WallDim.FaceFrameRailLength = WallDim.CabLength - ( WallDim.FaceFrameStileWidth * 2.0)
  WallDim.ShelfWidth =  WallDim.CabDepth - (WallDim.ThicknessBack + WallDim.FaceFrameThickness + WallDim.ShelfFrontClearance + WallDim.ShelfFaceFrameThickness)
  if WallQuestion.AddCenterPanel then
    WallDim.ShelfLength =  (((WallDim.CabLength  - ((WallDim.MaterialThickness * 3.0) +  (WallDim.FaceFrameSideReveal * 2.0) ))*0.5000) -(WallDim.ShelfEndClarence * 2.0) )
    WallDim.ShelfNoseLength  = WallDim.ShelfLength
  else
    WallDim.ShelfLength = (WallDim.CabLength  - ((WallDim.MaterialThickness * 2.0)  + (WallDim.FaceFrameSideReveal * 2.0) + (WallDim.ShelfEndClarence * 2)) )
    WallDim.ShelfNoseLength  = WallDim.ShelfLength
  end
  WallDim.HoleSpace = WallDim.SidePanelWidth - (WallDim.ThicknessBack + WallDim.ShelfPinHoleFront + WallDim.ShelfPinHoleBack)
  WallDim.HoleRows = ((WallDim.CabHeight - (WallDim.ShelfHoleFirstRowSpacing + WallDim.ShelfHoleLastRowSpacing + (WallDim.MaterialThickness * 2.0))) / WallDim.ShelfHoleSpacing)
  WallDim.CenterPanelLength = WallDim.SidePanelLength - (WallDim.FaceFrameBottomRailWidth + (Milling.DadoHeight * 2.0))
  WallDim.CenterPanelWidth =  WallDim.CabDepth - (Milling.DadoBackHeight + WallDim.FaceFrameThickness )
  REG_UpdateRegistry()
  return true
end
-- =====================================================]]
function InquiryWallOrBase(Header, Quest, DList)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml7, 500, 481,  Header .. "  " .. Milling.UnitDisplay)
  dialog:AddLabelField("Questions", Quest)
  dialog:AddDropDownList("ListBox", "Wall")
  dialog:AddDropDownList("Project.NewSheet", "Yes")
  dialog:AddDoubleField("WallDim.CabHeight", WallDim.CabHeight)
  dialog:AddDoubleField("WallDim.CabDepth",  WallDim.CabDepth)
  dialog:AddDoubleField("WallDim.CabLength", WallDim.CabLength)
  dialog:AddDoubleField("BaseDim.CabHeight", BaseDim.CabHeight)
  dialog:AddDoubleField("BaseDim.CabDepth",  BaseDim.CabDepth)
  dialog:AddDoubleField("BaseDim.CabLength", BaseDim.CabLength)
  dialog:AddTextField("Project.CabinetName", Project.CabinetName)
  dialog:AddLabelField("ToolNameLabel1",                      Milling.Toolpath1)
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel2",                      Milling.Toolpath2)
  dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
  dialog:AddToolPickerValidToolType("ToolChooseButton2",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel3",                      Milling.Toolpath3)
  dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton3",      Tool.END_MILL)
  dialog:AddLabelField("ToolNameLabel4",                      Milling.Toolpath4)
  dialog:AddToolPicker("ToolChooseButton4", "ToolNameLabel4", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton4",      Tool.THROUGH_DRILL)
  for _, value in pairs(DList) do
    dialog:AddDropDownListValue("ListBox", value)
  end
  if dialog:ShowDialog() then
    WallDim.CabHeight   = dialog:GetDoubleField("WallDim.CabHeight")
    WallDim.CabDepth    = dialog:GetDoubleField("WallDim.CabDepth")
    WallDim.CabLength   = dialog:GetDoubleField("WallDim.CabLength")
    BaseDim.CabHeight   = dialog:GetDoubleField("BaseDim.CabHeight")
    BaseDim.CabDepth    = dialog:GetDoubleField("BaseDim.CabDepth")
    BaseDim.CabLength   = dialog:GetDoubleField("BaseDim.CabLength")
    Project.CabinetName = dialog:GetTextField("Project.CabinetName")
    Project.NewSheet    = string.upper(dialog:GetDropDownListValue("Project.NewSheet"))
    local tool = dialog:GetTool("ToolChooseButton1")
    if not(tool == nil) then
      Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile
      Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Pocketing
      Milling.MillTool3 = dialog:GetTool("ToolChooseButton3")  -- Clearing
      Milling.MillTool4 = dialog:GetTool("ToolChooseButton4")  -- Drilling
      Milling.Tool1 = Milling.MillTool1.Name
      Milling.Tool2 = Milling.MillTool2.Name
      Milling.Tool3 = Milling.MillTool3.Name
      Milling.Tool4 = Milling.MillTool4.Name
    end
    DialogWindow.InquiryWallOrBaseXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    REG_UpdateRegistry()
    return string.upper(dialog:GetDropDownListValue("ListBox"))
  end
end
-- =====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 720, 487, "About")
  dialog:AddLabelField("SysName", AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  REG_UpdateRegistry()
  return  true
end
-- =====================================================]]
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
    REG_UpdateRegistry()
  end
  Base_Math()
  REG_UpdateRegistry()
  return  true
end
-- =====================================================]]
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
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
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
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
function OnLuaButton_InquiryProjectInfo( )
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, 615, 270, "Project Setup")
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
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
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
    REG_UpdateRegistry()
  end
  return  true
end
-- =====================================================]]
function Wall_CabinetShelf(CountX)
  local pt2 = Polar2D(Cab.Wpt5, 0.0, WallDim.ShelfLength)
  local pt3 = Polar2D(pt2, 90.0, WallDim.ShelfWidth)
  local pt4 = Polar2D(pt3,  180.0, WallDim.ShelfLength)
  DrawBox(Cab.Wpt5, pt2, pt3, pt4, Milling.LNShelfProfile .. "-Wall")
  local pt1Text = Polar2D(Cab.Wpt5, 45,  1.5)
  DrawWriter("Cabinet Shelf ".. CountX .." -  Plywood",  pt1Text, 0.350, Milling.LNPartLabels,0.0)
  pt1Text = Polar2D(pt1Text, 270,  0.75, 0.0)
  DrawWriter("( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 0.0)
  CutListfileWriterItem("150", "Wall Cabinet Shelf No:" .. tostring(CountX), "1", WallDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  CutListfileWriterItem("160", "Wall Shelf Nose No:" .. tostring(CountX).. " (Not Shown)", "1", WallDim.ShelfFaceFrameThickness, "Hardwood", WallDim.ShelfFaceFrameWidth, GetDistance(pt3, pt4))
  return true
end
-- =====================================================]]
function Wall_CabinetBack()
  local pt1 = Cab.Wpt8
  local pt2 = Polar2D(Cab.Wpt8, 0.0,  WallDim.BackPanelWidth)
  local ptC = Polar2D(Cab.Wpt8, 90.0,  WallDim.BackPanelLength * 0.5)
  local pt3 = Polar2D(pt2, 90.0,  WallDim.BackPanelLength)
  local pt4 = Polar2D(pt3, 180.0,  WallDim.BackPanelWidth)
  local ptW = Cab.Wpt8
  local ptX = Cab.Wpt8
  local ptY = Cab.Wpt8
  local ptZ = Cab.Wpt8
  ptW = Polar2D(ptC, 270.0, ((WallDim.MaterialThickness + Milling.DadoClearance) * 0.50))
  ptW = Polar2D(ptW, 180.0, Milling.PocketToolDia)
  ptX = Polar2D(ptW,  90.0, (WallDim.MaterialThickness + Milling.DadoClearance))
  ptY = Polar2D(ptX, 0.0, WallDim.BackPanelWidth + (Milling.PocketToolDia * 2.0))
  ptZ = Polar2D(ptW, 0.0, WallDim.BackPanelWidth + (Milling.PocketToolDia * 2.0))
  DrawBox(pt1, pt2, pt3, pt4, Milling.LNBackProfile .. "-Wall")
  if WallQuestion.AddCenterPanel then
    DrawBox(ptW, ptX, ptY, ptZ, Milling.LNBackPocket .. "-Wall")
    local pt1Text = Polar2D(ptX, 10,  1.75 )
    DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoBackHeight , pt1Text, 0.35, Milling.LNPartLabels, 0.0)
  end
  local pt1Text = Polar2D(Cab.Wpt8, 45,  1.5)
  DrawWriter("Wall Cabinet Back - ".. WallDim.ThicknessBack .. " Plywood", pt1Text, 0.35, Milling.LNPartLabels, 0.0)
  pt1Text = Polar2D(pt1Text, 270,  0.75)
  DrawWriter("( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4) .." )", pt1Text, 0.350, Milling.LNPartLabels, 0.0)
  Cab.Wpt9 = Polar2D(pt2,  0.0, Milling.PartGap)
  CutListfileWriterItem("180", "Back Panel", "1", WallDim.ThicknessBack, "Plywood", WallDim.BackPanelWidth, WallDim.BackPanelLength)
  return true
end
-- =====================================================]]
function Wall_CabinetTandB(xx)
  local pt1 = Cab.Wpt1
  local pt2 = Cab.Wpt1
  local ptC = Cab.Wpt1
  local pt3 = Cab.Wpt1
  local pt4 = Cab.Wpt1
  local ptG = Cab.Wpt1
  local ptH = Cab.Wpt1
  local ptE = Cab.Wpt1
  local ptF = Cab.Wpt1
  local ptW = Cab.Wpt1
  local ptX = Cab.Wpt1
  local ptY = Cab.Wpt1
  local ptZ = Cab.Wpt1
  local pt1Text = Cab.Wpt1
  if xx  ==  "T" then
    pt1 = Cab.Wpt3
    pt1Text = Polar2D(pt1, 45,  1.5)
  else
    pt1 = Cab.Wpt4
    pt1Text = Polar2D(pt1, 45,  1.5)
  end
  pt2 = Polar2D(pt1, 0.0, WallDim.TopBottomPanelLength)
  Cab.Wpt8 = Point2D(pt2.X + Milling.PartGap,1)
  ptC = Polar2D(pt1,   0.0, (WallDim.TopBottomPanelLength * 0.5))
  pt3 = Polar2D(pt2,  90.0, WallDim.CabDepth)
  pt4 = Polar2D(pt3, 180.0, WallDim.TopBottomPanelLength)
  ptG = Polar2D(pt3,   0.0, Milling.ProfileToolRadius)
  ptH = Polar2D(ptG, 270.0, WallDim.ThicknessBack)
  ptE = Polar2D(pt4, 180.0, Milling.ProfileToolRadius)
  ptF = Polar2D(ptE, 270.0, WallDim.ThicknessBack)
  ptE = Polar2D(ptE,  90.0, Milling.RabbitClearance)
  ptG = Polar2D(ptG,  90.0, Milling.RabbitClearance)
  ptW = Polar2D(ptC, 180.0, ((WallDim.MaterialThickness + Milling.DadoClearance) * 0.5))
  ptW = Polar2D(ptW, 270.0, Milling.PocketToolDia)
  ptX = Polar2D(ptW,   0.0, (WallDim.MaterialThickness + Milling.DadoClearance))
  ptY = Polar2D(ptX,  90.0, WallDim.CabDepth + (Milling.PocketToolDia * 2))
  ptZ = Polar2D(ptW,  90.0, WallDim.CabDepth + (Milling.PocketToolDia * 2))
  if xx  ==  "T" then
    DrawWriter("Wall Cabinet Top - ".. WallDim.MaterialThickness .. " Plywood  ( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4).." )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
    CutListfileWriterItem("130", "Top Panel", "1", WallDim.MaterialThickness, "Plywood", WallDim.CabDepth, WallDim.BackPanelLength)
  else
    DrawWriter("Wall Cabinet Bottom - ".. WallDim.MaterialThickness .. " Plywood  ( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4).." )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
    CutListfileWriterItem("140", "Bottom Panel", "1", WallDim.MaterialThickness, "Plywood", WallDim.CabDepth, WallDim.BackPanelLength)
  end
  DrawBox(pt1, pt2, pt3, pt4, Milling.LNTopBottomProfile  .. "-Wall")
  if WallQuestion.AddCenterPanel then
    DrawBox(ptW, ptX, ptY, ptZ, Milling.LNTopBottomPocket  .. "-Wall")
    pt1Text = Polar2D(ptW, 100,  1.75 )
    DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels, 90.0)
  end
  DrawBox(ptE, ptF, ptH, ptG, Milling.LNTopBottomPocket  .. "-Wall")
  pt1Text = Polar2D(ptF, 340,  1.75 )
  DrawWriter("Rabbet - ".. WallDim.ThicknessBack .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  0.0)
  Cab.Wpt9 = Point2D(pt2.X + Milling.PartGap,1)
  return true
end
-- =====================================================]]
function Wall_CabinetSide(side)
  local pt2 = Cab.Wpt1
  local pt3 = Cab.Wpt1
  local pt4 = Cab.Wpt1
  local ptA = Cab.Wpt1
  local ptB = Cab.Wpt1
  local ptL = Cab.Wpt1
  local ptK = Cab.Wpt1
  local ptG = Cab.Wpt1
  local ptH = Cab.Wpt1
  local ptI = Cab.Wpt1
  local ptJ = Cab.Wpt1
  local ptD = Cab.Wpt1
  local ptC = Cab.Wpt1
  local ptE = Cab.Wpt1
  local ptF = Cab.Wpt1
  local pt1Text = Polar2D(Cab.Wpt1, 45,  1.5)
  local ptx = Cab.Wpt1
  local anx = 0
  --local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile  .. "-Wall")
-- =====================================================]]
  if side  ==  "L" then --  L side
    pt1Text = Polar2D(Cab.Wpt1, 45,  1.5)
    pt2     = Polar2D(Cab.Wpt1,   0.0, WallDim.CabHeight)
    pt3     = Polar2D(pt2,       90.0, WallDim.CabDepth)
    pt4     = Polar2D(pt3,      180.0, WallDim.CabHeight)
    ptA     = Polar2D(Cab.Wpt1, 270.0, Milling.ProfileToolRadius)
    ptB     = Polar2D(ptA,        0.0, WallDim.MaterialThickness)
    ptL     = Polar2D(pt2,      270.0, Milling.ProfileToolRadius)
    ptK     = Polar2D(ptL,      180.0, WallDim.MaterialThickness)
    ptG     = Polar2D(pt3,        0.0, Milling.ProfileToolRadius)
    ptH     = Polar2D(ptG,      270.0, WallDim.ThicknessBack)
    ptI     = Polar2D(pt3,       90.0, Milling.ProfileToolRadius)
    ptJ     = Polar2D(ptI,      180.0, WallDim.MaterialThickness)
    ptD     = Polar2D(pt4,       90.0, Milling.ProfileToolRadius)
    ptC     = Polar2D(ptD,        0.0, WallDim.MaterialThickness)
    ptE     = Polar2D(pt4,      180.0, Milling.ProfileToolRadius)
    ptF     = Polar2D(ptE,      270.0, WallDim.ThicknessBack)
    ptA     = Polar2D(ptA,      180.0, Milling.RabbitClearance)
    ptL     = Polar2D(ptL,        0.0, Milling.RabbitClearance)
    ptG     = Polar2D(ptG,       90.0, Milling.RabbitClearance)
    ptI     = Polar2D(ptI,        0.0, Milling.RabbitClearance)
    ptE     = Polar2D(ptE,       90.0, Milling.RabbitClearance)
    ptD     = Polar2D(ptD,      180.0, Milling.RabbitClearance)
    DrawWriter("Wall Cabinet Left Side - ".. WallDim.MaterialThickness .." Plywood ( " .. WallDim.CabHeight .. " x " .. WallDim.CabDepth .. " )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
    CutListfileWriterItem("110", "Left Side Panel", "1", WallDim.MaterialThickness, "Plywood", WallDim.CabDepth, WallDim.CabHeight)
    DrawBox(Cab.Wpt1, pt2, pt3, pt4, Milling.LNSideProfile  .. "-Wall")
--  top Dado
    DrawBox(ptA, ptB, ptC, ptD, Milling.LNSidePocket  .. "-Wall")
    pt1Text = Polar2D(ptA, 60,  2.5 )
    DrawWriter("Rabbet - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  90.0)
--  back Dado
    DrawBox(ptE, ptF, ptH, ptG, Milling.LNSidePocket  .. "-Wall")
    pt1Text = Polar2D(ptF, 340,  1.75 )
    DrawWriter("Rabbet - ".. WallDim.ThicknessBack .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  0.0)
--  bottom Dado
    DrawBox(ptI, ptJ, ptK, ptL, Milling.LNSidePocket  .. "-Wall")
    pt1Text = Polar2D(ptL, 120,  1.85 )
    DrawWriter("Rabbet - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  90.0)
    ptx = Cab.Wpt1
    anx = 0
    ptx = Polar2D(Polar2D(Cab.Wpt1, 0.0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 90, ((WallDim.CabDepth - WallDim.ThicknessBack) * WallDim.ShelfPinHoleBack))
-- =====================================================]]
    ptx = Cab.Wpt2
    anx = 0
    ptx = Polar2D(Polar2D(Cab.Wpt2, 0.0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 90, ((WallDim.CabDepth - WallDim.ThicknessBack) * WallDim.ShelfPinHoleBack))
    anx = 90
-- =====================================================]]
  else  --  R side
-- =====================================================]]
    pt1Text = Polar2D(Cab.Wpt2, 45,  1.5)
    pt2 = Polar2D(Cab.Wpt2, 0, WallDim.CabHeight)
    pt3 = Polar2D(pt2, 90, WallDim.CabDepth)
    pt4 = Polar2D(pt3, 180, WallDim.CabHeight)
    ptA = Polar2D(Cab.Wpt2, 270, Milling.ProfileToolRadius)
    ptB = Polar2D(ptA,  0, WallDim.MaterialThickness)
    ptL = Polar2D(pt2, 270, Milling.ProfileToolRadius)
    ptK = Polar2D(ptL, 180, WallDim.MaterialThickness)
    ptI = Polar2D(pt3, 90, Milling.ProfileToolRadius)
    ptJ = Polar2D(ptI, 180, WallDim.MaterialThickness)
    ptD = Polar2D(pt4, 90, Milling.ProfileToolRadius)
    ptC = Polar2D(ptD,  0, WallDim.MaterialThickness)
    ptG = Polar2D(pt2,  0, Milling.ProfileToolRadius)
    ptH = Polar2D(ptG, 90, WallDim.ThicknessBack)
    ptE = Polar2D(Cab.Wpt2, 180, Milling.ProfileToolRadius)
    ptF = Polar2D(ptE, 90, WallDim.ThicknessBack)
--  Right Side
    ptL = Polar2D(ptL,  0, Milling.RabbitClearance)
    ptI = Polar2D(ptI,  0, Milling.RabbitClearance)
--  Back Side
    ptG = Polar2D(ptG, 270, Milling.RabbitClearance)
    ptE = Polar2D(ptE, 270, Milling.RabbitClearance)
--  Left Side
    ptD = Polar2D(ptD, 180, Milling.RabbitClearance)
    ptA = Polar2D(ptA, 180, Milling.RabbitClearance)
    DrawWriter("Wall Cabinet Right Side - ".. WallDim.MaterialThickness .." Plywood ( " .. WallDim.CabHeight .. " x " .. WallDim.CabDepth .. " )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
    CutListfileWriterItem("120", "Right Side Panel", "1", WallDim.MaterialThickness, "Plywood", WallDim.CabDepth, WallDim.CabHeight)
    DrawBox(Cab.Wpt2, pt2, pt3, pt4, Milling.LNSideProfile  .. "-Wall")
--  top Dado
    DrawBox(ptA, ptB, ptC, ptD, Milling.LNSidePocket  .. "-Wall")
    pt1Text = Polar2D(ptB, 70,  1.85 )
    DrawWriter("Rabbet - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  90.0)
--  back Dado
    DrawBox(ptE, ptF, ptH, ptG, Milling.LNSidePocket  .. "-Wall")
    pt1Text = Polar2D(ptG, 175,  8.75 )
    DrawWriter("Rabbet - ".. WallDim.ThicknessBack .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  0.0)
--  bottom Dado
    DrawBox(ptI, ptJ, ptK, ptL, Milling.LNSidePocket  .. "-Wall")
    pt1Text = Polar2D(ptL, 120,  1.85 )
    DrawWriter("Rabbet - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  90.0)
    ptx = Cab.Wpt2
    anx = 0
    ptx = Polar2D(Polar2D(pt4, 0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 270, ((WallDim.CabDepth - WallDim.ThicknessBack) * WallDim.ShelfPinHoleBack))
    anx = 270
  end
  if WallQuestion.ShelfCount >= 1 then
    if side  ==  "L" then --  L side
      ptx = Polar2D(Polar2D(Cab.Wpt1, 0.0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 90.0, WallDim.ShelfPinHoleFront)
      anx = 90
    else
      ptx = Polar2D(Cab.Wpt2, 90.0, WallDim.CabDepth)
      anx = 270.0
      ptx = Polar2D(Polar2D(ptx, 0.0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 270.0, WallDim.ShelfPinHoleFront)
    end
    local  rows = WallDim.HoleRows
    while (rows >0) do
      Holer(ptx, anx, WallDim.HoleSpace, Milling.ShelfPinRadius, Milling.LNSideShelfPinDrill .. "-Wall")
      ptx = Polar2D(ptx, 0, WallDim.ShelfHoleSpacing)
      rows = (rows - 1.0)
    end
  end
  return true
end  --  function end
-- =====================================================]]
function Wall_CenterPanel()
  layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNCenterPanelProfile .. "-Wall")
  local pt1 = Cab.Wpt7
  local pt2 = Polar2D(pt1, 0.0, WallDim.CenterPanelLength)
  local pt3 = Polar2D(pt2, 90.0, WallDim.CenterPanelWidth)
  local pt4 = Polar2D(pt3, 180, WallDim.CenterPanelLength )
  Cab.Wpt8 = Polar2D(pt2, 0.0,  Milling.PartGap)
  local pt1Text = Polar2D(Cab.Wpt7, 45,  1.5)
  DrawWriter("Wall Cabinet Center Panel - ".. WallDim.MaterialThickness .." Plywood  ( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4).." )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
  CutListfileWriterItem("170", "Center Panel", "1", WallDim.MaterialThickness, "Plywood", WallDim.CenterPanelWidth, WallDim.CenterPanelLength)
  DrawBox(pt1, pt2, pt3, pt4, Milling.LNCenterPanelProfile .. "-Wall")
  if WallQuestion.ShelfCount >= 1 then
    local ptx = Cab.Wpt7
    local anx = 90
    ptx = Polar2D(Polar2D(Cab.Wpt7, 0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 90, WallDim.ShelfPinHoleFront )
    local rows = WallDim.HoleRows
    while (rows >0) do
      Holer(ptx, anx, WallDim.HoleSpace, Milling.ShelfPinRadius, Milling.LNCenterPanelShelfPinDrill .. "-Wall")
      ptx = Polar2D(ptx, 0.0, WallDim.ShelfHoleSpacing)
      rows = (rows - 1.0)
    end
  end
  return true
end  --  function end
-- =====================================================]]
function Wall_CabinetFaceFrame()
  -- local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNDrawFaceFrame  .. "-Wall")
  local pt2 = Polar2D(Cab.Wpt9, 0, WallDim.CabHeight)
  local pt3 = Polar2D(pt2,  90, WallDim.CabLength)
  local pt4 = Polar2D(pt3, 180, WallDim.CabHeight)
  local A1 = Polar2D(Cab.Wpt9, 90,  WallDim.FaceFrameStileWidth)
  local B1 = Polar2D(pt2, 90,  WallDim.FaceFrameStileWidth)
  local C1 = Polar2D(pt3,  270, WallDim.FaceFrameStileWidth)
  local D1 = Polar2D(pt4,  270, WallDim.FaceFrameStileWidth)
  -- Draw Stiles

  DrawBox(Cab.Wpt9, pt2, B1, A1, Milling.LNDrawFaceFrame .. "-Wall")
  CutListfileWriterItem("190", "Face Frame Stile L", "1", WallDim.FaceFrameThickness, "Hardwood", WallDim.FaceFrameStileWidth, GetDistance(A1, B1))
  local pt1Text = Polar2D(Cab.Wpt9, 5,  8.75 )
  DrawWriter("Part ID: 190", pt1Text, 0.40, Milling.LNPartLabels,  0.0)

  DrawBox(D1, C1, pt3, pt4, Milling.LNDrawFaceFrame .. "-Wall")
  CutListfileWriterItem("200", "Face Frame Stile R", "1", WallDim.FaceFrameThickness, "Hardwood", WallDim.FaceFrameStileWidth, GetDistance(A1, B1))
  pt1Text = Polar2D(D1, 5,  8.75 )
  DrawWriter("Part ID: 200", pt1Text, 0.40, Milling.LNPartLabels,  0.0)

  local A2 = Polar2D(A1, 0, WallDim.FaceFrameBottomRailWidth)
  local B2 = Polar2D(B1, 180, WallDim.FaceFrameTopRailWidth)
  local C2 = Polar2D(C1, 180,  WallDim.FaceFrameTopRailWidth)
  local D2 = Polar2D(D1, 0, WallDim.FaceFrameBottomRailWidth)
  local pt2c = Polar2D(A2, 90, ((WallDim.CabLength * 0.5) - WallDim.FaceFrameStileWidth) )
  local pt1c = Polar2D(B2,  90, ((WallDim.CabLength * 0.5) - WallDim.FaceFrameStileWidth) )
  -- Draw Top Rail
  DrawBox(A1, A2, D2, D1, Milling.LNDrawFaceFrame .. "-Wall")
  pt1Text = Polar2D(A2, 95,  2.75 )
  DrawWriter("Part ID: 210", pt1Text, 0.40, Milling.LNPartLabels,  90.0)
    -- Draw Top Rail
  DrawBox(B2, B1, C1, C2, Milling.LNDrawFaceFrame .. "-Wall")
  pt1Text = Polar2D(B1, 95,  2.75 )
  DrawWriter("Part ID: 220", pt1Text, 0.40, Milling.LNPartLabels,  90.0)
  CutListfileWriterItem("210", "Face Frame Top", "1", WallDim.FaceFrameThickness, "Hardwood", WallDim.FaceFrameTopRailWidth, GetDistance(A1, B1))
  CutListfileWriterItem("220", "Face Frame Bottom", "1", WallDim.FaceFrameThickness, "Hardwood", WallDim.FaceFrameBottomRailWidth, GetDistance(A1, B1))

  if WallQuestion.AddCenterFaceFrame then
    WallDim.FaceFrameCenterStileLength = (WallDim.CabLength * 0.50) - (WallDim.FaceFrameStileWidth + (WallDim.FaceFrameCenterStileWidth * 0.5))
    local A3 = Polar2D(pt1c, 90.0, (WallDim.FaceFrameCenterStileWidth * 0.5))
    local B3 = Polar2D(pt2c, 90.0, (WallDim.FaceFrameCenterStileWidth * 0.5))
    local C3 = Polar2D(pt1c, 270.0, (WallDim.FaceFrameCenterStileWidth * 0.5))
    local D3 = Polar2D(pt2c, 270.0, (WallDim.FaceFrameCenterStileWidth * 0.5))
    DrawBox(A3, B3, D3, C3, Milling.LNDrawFaceFrame .. "-Wall")
    pt1Text = Polar2D(A3, 185,  8.75 )
    DrawWriter("Part ID: 230", pt1Text, 0.40, Milling.LNPartLabels,  0.0)
    CutListfileWriterItem("230", "Center Face Frame", "1", WallDim.FaceFrameThickness, "Hardwood", WallDim.FaceFrameCenterStileWidth, GetDistance(D3, C3))
  end
  WallDim.FaceFrameStileLength = WallDim.CabHeight
  WallDim.FaceFrameRailLength = WallDim.CabLength - (WallDim.FaceFrameStileWidth * 2.0)
  WallDim.FaceFrameCenterStileLength = WallDim.CabHeight- (WallDim.FaceFrameBottomRailWidth + WallDim.FaceFrameTopRailWidth)
  pt1Text = Polar2D(Cab.Wpt1, 90,  45.0)
  DrawWriter(Project.ProgramName, pt1Text, 1.250, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 1.25)
  DrawWriter("Cabinet ID: " .. Project.DrawerID, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270,1)
  DrawWriter("Cabnet Name: " .. Project.CabinetName, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270,1)
  DrawWriter("Version: " .. Project.ProgramVersion, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270,1)
  DrawWriter("Gadget By: " .. Project.ProgramCodeBy, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  return true
end  --  function end
-- =====================================================]]
function Base_CabinetBottom()
  local pt2 = Polar2D(Cab.Wpt6, 0, BaseDim.TopBottomPanelWidth)
  local ptC = Polar2D(Cab.Wpt6, 90, (BaseDim.TopBottomPanelLength * 0.5))
  local pt3 = Polar2D(pt2, 90, BaseDim.TopBottomPanelLength)
  local pt4 = Polar2D(pt3,  180, BaseDim.TopBottomPanelWidth)
  local ptW = Polar2D(Polar2D(ptC, 270, ((BaseDim.MaterialThickness + Milling.RabbitClearance) * 0.5)), 180, Milling.ProfileToolRadius)
  local ptX = Polar2D(ptW, 90, (BaseDim.MaterialThickness + Milling.RabbitClearance))
  local ptY = Polar2D(ptX,  0, BaseDim.TopBottomPanelWidth + (Milling.ProfileToolRadius * 2))
  local ptZ = Polar2D(ptW,  0, BaseDim.TopBottomPanelWidth + (Milling.ProfileToolRadius * 2))
--  local ptB = Cab.Wpt1
  local pt1Text = Cab.Wpt1
  local line = Contour(0.0)
  if BaseQuestion.AddCenterPanel then
    DrawBox(ptW, ptX, ptY, ptZ, Milling.LNTopBottomPocket .. "-Base")
    pt1Text = Polar2D(ptW, 340,  1.75 )
    DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  0.0)
    line = Contour(0.0)
  end
  DrawBox(Cab.Wpt6, pt2, pt3, pt4, Milling.LNTopBottomProfile .. "-Base")
  pt1Text = Polar2D(Cab.Wpt6, 45,  1.5)
  DrawWriter("Base Cabinet Bottom - ".. BaseDim.MaterialThickness .." Plywood  ( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4).." )", pt1Text, 0.35, Milling.LNPartLabels, 0.0)
  CutListfileWriterItem("360", "Base Cabinet Bottom", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  return true
end
-- =====================================================]]
function Base_CabinetFaceFrame()
  local Dist = 0.0
--  Draw outer frame box
  local pt2 = Polar2D(Cab.Wpt10, 0.0,  BaseDim.FaceFrameStileLength)
  local pt3 = Polar2D(pt2, 90.0,  BaseDim.FaceFrameRailLength+(BaseDim.FaceFrameStileWidth*2.0))
  local pt4 = Polar2D(pt3,  180.0,  BaseDim.FaceFrameStileLength)
  -- DrawBox(Cab.Wpt10, pt2, pt3, pt4, Milling.LNDrawFaceFrame .. "-Base")
  -- Draw Stile Lines
  local A1 = Polar2D(Cab.Wpt10, 90.0,  BaseDim.FaceFrameStileWidth)
  local B1 = Polar2D(pt2, 90.0,  BaseDim.FaceFrameStileWidth)
  local C1 = Polar2D(pt3,  270.0,  BaseDim.FaceFrameStileWidth)
  local D1 = Polar2D(pt4,  270.0,  BaseDim.FaceFrameStileWidth)
  DrawBox(Cab.Wpt10, pt2, B1, A1, Milling.LNDrawFaceFrame .. "-Base")
  local pt1Text = Polar2D(Cab.Wpt10, 5,  8.75 )
  DrawWriter("Part ID: 410", pt1Text, 0.40, Milling.LNPartLabels,  0.0)
  CutListfileWriterItem("410", "Face Frame Stile L", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameStileWidth, BaseDim.FaceFrameStileLength)
  DrawBox(D1, C1,pt3, pt4, Milling.LNDrawFaceFrame .. "-Base")
  pt1Text = Polar2D(pt4, 355,  8.75 )
  DrawWriter("Part ID: 420", pt1Text, 0.40, Milling.LNPartLabels,  0.0)
  CutListfileWriterItem("420", "Face Frame Stile R", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameStileWidth, BaseDim.FaceFrameStileLength)

--  Draw the Top and Bottom rails
  local A2 = Polar2D(A1, 0.0, BaseDim.FaceFrameTopRailWidth)
  local B2 = Polar2D(B1, 180.0, BaseDim.FaceFrameBottomRailWidth)
  local C2 = Polar2D(C1, 180.0, BaseDim.FaceFrameBottomRailWidth)
  local D2 = Polar2D(D1, 0.0, BaseDim.FaceFrameTopRailWidth)
  BaseDim.FaceFrameRailLength = GetDistance(A2, D2)
  local DrawerHeight  = 0.0
  CutListfileWriterItem("430", "Face Frame Top Rail", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameTopRailWidth, BaseDim.FaceFrameRailLength )
  --  Draw the Top rail
  DrawBox(A1, A2, D2, D1, Milling.LNDrawFaceFrame .. "-Base")

  pt1Text = Polar2D(A1, 85,  8.75 )
  DrawWriter("Part ID: 430", pt1Text, 0.40, Milling.LNPartLabels,  90.0)

  --  Draw the Bottom rail
  DrawBox(B2, B1, C1, C2, Milling.LNDrawFaceFrame .. "-Base")
  local B2x = B2
  local C2x = C2
  CutListfileWriterItem("440", "Face Frame Bottom Rail", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameBottomRailWidth, BaseDim.FaceFrameRailLength )
  pt1Text = Polar2D(B2, 85,  8.75 )
  DrawWriter("Part ID: 440", pt1Text, 0.40, Milling.LNPartLabels,  90.0)
  if BaseQuestion.DrawerRowCount >= 1 then
    local DrawerRowCountX = 1
    while DrawerRowCountX <= BaseQuestion.DrawerRowCount do
      if DrawerRowCountX == 3 then
        DrawerHeight = BaseDim.FaceFrameDrawerHeight3
      end
      if DrawerRowCountX == 2 then
        DrawerHeight = BaseDim.FaceFrameDrawerHeight2
      end
      if DrawerRowCountX == 1 then
        DrawerHeight = BaseDim.FaceFrameDrawerHeight1
      end
      A2 = Polar2D(A2,  0, DrawerHeight)
      D2 = Polar2D(D2,  0, DrawerHeight)
      B2 = Polar2D(A2,  0, BaseDim.FaceFrameMidRailWidth)
      C2 = Polar2D(D2,  0, BaseDim.FaceFrameMidRailWidth)
      DrawBox(A2, B2, C2, D2, Milling.LNDrawFaceFrame .. "-Base")
      CutListfileWriterItem("450", "Face Frame Center", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameCenterStileWidth, GetDistance(A2, D2) )
      pt1Text = Polar2D(A2, 85,  8.75 )
      DrawWriter("Part ID: 450", pt1Text, 0.40, Milling.LNPartLabels,  90.0)
      Dist = ((BaseDim.CabLength * 0.5) - (BaseDim.FaceFrameStileWidth + (BaseDim.FaceFrameCenterStileWidth * 0.5) ))
      local B2 = Polar2D(A2,  90, Dist)
      local B2a = Polar2D(B2, 180, DrawerHeight)
      local C2 = Polar2D(D2, 270, Dist)
      local C2a = Polar2D(C2, 180, DrawerHeight)
      if BaseQuestion.AddCenterFaceFrame then
        DrawBox(B2, B2a, C2a, C2, Milling.LNDrawFaceFrame .. "-Base")
        CutListfileWriterItem("460", "Face Frame Center", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameTopRailWidth, DrawerHeight)
        pt1Text = Polar2D(B2a, 25,  0.75 )
        DrawWriter("Part ID: 460", pt1Text, 0.4, Milling.LNPartLabels,  0.0)
      end
      A2 = Polar2D(A2,  0, BaseDim.FaceFrameMidRailWidth)
      D2 = Polar2D(D2,  0, BaseDim.FaceFrameMidRailWidth)
      DrawerRowCountX = DrawerRowCountX + 1
     -- CutListfileWriterItem("470", "Mid Rail Face Frame", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameMidRailWidth, GetDistance(A2, D2) )
    end
  end
  if BaseQuestion.AddCenterFaceFrame then
    Dist = ((BaseDim.CabLength * 0.5) - (BaseDim.FaceFrameStileWidth + (BaseDim.FaceFrameCenterStileWidth * 0.5) ))
    local A3 = Polar2D(A2,  90.0, Dist)
    local B3 = Polar2D(B2x,  90.0, Dist)
    local C3 = Polar2D(C2x, 270.0, Dist)
    local D3 = Polar2D(D2, 270.0, Dist)
    DrawBox(A3, D3, C3, B3, Milling.LNDrawFaceFrame .. "-Base")
    CutListfileWriterItem("470", "Face Frame Center", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameCenterStileWidth, GetDistance(A3, B3) )
    pt1Text = Polar2D(A3, 25,  0.75 )
    DrawWriter("Part ID: 470", pt1Text, 0.4, Milling.LNPartLabels,  0.0)
  end

  BaseDim.FaceFrameStileLength = BaseDim.CabHeight
  BaseDim.FaceFrameRailLength = BaseDim.CabLength - (BaseDim.FaceFrameStileWidth * 2.0)
  BaseDim.FaceFrameCenterStileLength = BaseDim.CabHeight - (BaseDim.FaceFrameBottomRailWidth + BaseDim.FaceFrameTopRailWidth)
  pt1Text = Polar2D(pt2, 0,  (BaseDim.FaceFrameStileWidth * 1.5))
  pt1Text = Polar2D(Cab.Wpt1, 90,  45.0)
  DrawWriter(Project.ProgramName, pt1Text, 1.250, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 1.25)
  DrawWriter("Cabinet ID: " .. Project.DrawerID, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270,1)
  DrawWriter("Cabnet Name: " .. Project.CabinetName, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270,1)
  DrawWriter("Version: " .. Project.ProgramVersion, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  pt1Text = Polar2D(pt1Text, 270,1)
  DrawWriter("Gadget By: " .. Project.ProgramCodeBy, pt1Text, 0.750, Milling.LNDrawNotes, 0.0)
  return true
  end
-- =====================================================]]
function Base_CabinetShelf(CountX)
  if BaseQuestion.AddCenterPanel then
    BaseDim.PartLength = ((BaseDim.CabLength - (BaseDim.MaterialThickness * 2.0) - (BaseDim.ShelfEndClarence * 4.0)) * 0.5)
  else
    BaseDim.PartLength = (BaseDim.CabLength - (BaseDim.MaterialThickness * 2.0) - (BaseDim.ShelfEndClarence * 2))
  end
  local LSD = BaseDim.CabDepth - (BaseDim.ThicknessBack + BaseDim.FaceFrameThickness + BaseDim.ShelfFrontClearance)
  local pt2 = Polar2D(Cab.Wpt3, 0,  BaseDim.ShelfLength)
  local pt3 = Polar2D(pt2, 90,  LSD)
  local pt4 = Polar2D(pt3, 180, BaseDim.ShelfLength)
  DrawBox(Cab.Wpt3, pt2, pt3, pt4, Milling.LNShelfProfile .. "-Base")
  local pt1Text = Polar2D(Polar2D(Cab.Wpt3, 0,  1), 90,  (LSD / 5))
  DrawWriter("Base Cabinet Shelf No:" .. tostring(CountX), pt1Text, 0.35, Milling.LNPartLabels, 0.0)
  pt1Text = Polar2D(pt1Text, 270, 0.7)
  DrawWriter(BaseDim.MaterialThickness .." Plywood (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4)..")", pt1Text, 0.35, Milling.LNPartLabels, 0.0)
  CutListfileWriterItem("330", "Base Cabinet Shelf No:" .. tostring(CountX), "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  CutListfileWriterItem("340", "Base Shelf Nose No:" .. tostring(CountX).. " (Not Shown)", "1", BaseDim.ShelfFaceFrameThickness, "Hardwood", BaseDim.ShelfFaceFrameWidth, GetDistance(pt3, pt4))
  return true
end
-- =====================================================]]
function Base_CabinetToeandRunners()
--  ToeKick
  local pt2 = Polar2D(Cab.Wpt9, 0,  BaseDim.ToeKickCoverHeight)
  local pt3 = Polar2D(pt2, 90,  BaseDim.BackPanelLength )
  local pt4 = Polar2D(pt3, 180, BaseDim.ToeKickCoverHeight)
  DrawBox(Cab.Wpt9, pt2, pt3, pt4, Milling.LNStretcherRailProfile .. "-Base")
  local pt1Text = Polar2D(Cab.Wpt9, 45,  1.25)
  DrawWriter("ToeKick - ".. BaseDim.MaterialThickness .." Plywood  (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4)..")", pt1Text, 0.35,Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("370", "ToeKick", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  --  Top  1
  Cab.Wpt9 = Polar2D(pt2, 0.0,  Milling.PartGap)
  pt2 = Polar2D(Cab.Wpt9, 0.0,  BaseDim.TopFrameWidth)
  pt3 = Polar2D(pt2, 90.0,  BaseDim.BackPanelLength )
  pt4 = Polar2D(pt3, 180.0, BaseDim.StretcherWidth)
  DrawBox(Cab.Wpt9, pt2, pt3, pt4, Milling.LNStretcherRailProfile .. "-Base")
  pt1Text = Polar2D(Cab.Wpt9, 45,  1.25)
  DrawWriter("Top Frame 1 - ".. BaseDim.MaterialThickness .." Plywood  (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4)..")", pt1Text, 0.35, Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("380", "Top Frame 1", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
--  Top  2
  Cab.Wpt9 = Polar2D(pt2, 0,  Milling.PartGap)
  pt2 = Polar2D(Cab.Wpt9, 0, BaseDim.TopFrameWidth)
  pt3 = Polar2D(pt2, 90,  BaseDim.BackPanelLength )
  pt4 = Polar2D(pt3, 180, BaseDim.TopFrameWidth)
  DrawBox(Cab.Wpt9, pt2, pt3, pt4, Milling.LNStretcherRailProfile .. "-Base")
  pt1Text = Polar2D(Cab.Wpt9, 45,  1.25)
  DrawWriter("Top Frame 2  - ".. BaseDim.MaterialThickness .." Plywood  (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4)..")", pt1Text, 0.35, Milling.LNPartLabels, 90.0)
  CutListfileWriterItem("390", "Top Frame 2", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
--  Rail Stretcher
  if not BaseQuestion.AddCenterPanel then
    for i = BaseQuestion.DrawerRowCount, 1 , -1 do
      Cab.Wpt9 = Polar2D(pt2, 0,  Milling.PartGap)
      pt2 = Polar2D(Cab.Wpt9, 0,  BaseDim.StretcherWidth)
      pt3 = Polar2D(pt2, 90,  BaseDim.BackPanelLength )
      pt4 = Polar2D(pt3, 180, BaseDim.StretcherWidth)
      DrawBox(Cab.Wpt9, pt2, pt3, pt4, Milling.LNStretcherRailProfile .. "-Base")
      pt1Text = Polar2D(Cab.Wpt9, 45,  1.25)
      DrawWriter("Face Frame Stretcher " .. tostring(i) .. " - ".. BaseDim.StretcherThickness .." Plywood  (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4)..")", pt1Text, 0.35, Milling.LNPartLabels, 90.0)
      CutListfileWriterItem("400", "Face Frame Stretcher " .. tostring(i), "1", BaseDim.StretcherThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
      pt2 = Polar2D(Cab.Wpt9, 0,  BaseDim.StretcherWidth)
    end
  end
  Cab.Wpt9 = Polar2D(pt2, 0,  Milling.PartGap)
  return true
end
-- =====================================================]]
function Base_CabinetBack()
  local pt2 = Polar2D(Cab.Wpt9, 0, BaseDim.BackPanelWidth)
  local ptC = Polar2D(Cab.Wpt9, 90, (BaseDim.BackPanelLength * 0.5))
  local pt3 = Polar2D(pt2, 90,  BaseDim.BackPanelLength )
  local pt4 = Polar2D(pt3, 180, BaseDim.BackPanelWidth)
  local ptW = Cab.Wpt9
  local ptX = Cab.Wpt9
  local ptY = Cab.Wpt9
  local ptZ = Cab.Wpt9
  ptW = Polar2D(ptC, 270, BaseDim.MaterialThickness  * 0.5)
  ptW = Polar2D(ptW, 180, Milling.PocketToolRadius)
  ptX = Polar2D(ptW, 90, BaseDim.MaterialThickness )
  ptY = Polar2D(ptX, 0,  BaseDim.BackPanelWidth  - (BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight ))
  ptZ = Polar2D(ptW, 0,  BaseDim.BackPanelWidth  - (BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight ))
--  Center Dado
  if BaseQuestion.AddCenterPanel then
     DrawBox(ptW, ptX, ptY, ptZ, Milling.LNBackPocket .. "-Base")
    local pt1Text = Polar2D(ptW, 340,  1.75 )
    DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  0.0)
  end
--  Bottom Dado
  local ptF = Polar2D(pt2, 180, BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight)
  ptF = Polar2D(ptF, 270, Milling.PocketToolRadius)
  local ptG = Polar2D(ptF, 180, BaseDim.MaterialThickness)
  local ptE = Polar2D(ptG, 90, BaseDim.BackPanelLength + Milling.PocketToolRadius)
  local ptH = Polar2D(ptF, 90, BaseDim.BackPanelLength + Milling.PocketToolRadius)
  DrawBox(ptF, ptG, ptE, ptH, Milling.LNBackPocket .. "-Base")
  local pt1Text = Polar2D(ptG, 60,  2.75 )
  DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pt1Text, 0.35, Milling.LNPartLabels,  90.0)
--  Panel Profile
  DrawBox(Cab.Wpt9, pt2, pt3, pt4, Milling.LNBackProfile .. "-Base")
  pt1Text = Polar2D(Cab.Wpt9, 45,  1.5)
  DrawWriter("Base Cabinet Back - ".. BaseDim.ThicknessBack .." Plywood  (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4)..")", pt1Text, 0.35, Milling.LNPartLabels, 0.0)
  CutListfileWriterItem("400", "Base Cabinet Back", "1", BaseDim.ThicknessBack, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  Cab.Wpt10 = Polar2D(pt2, 0,  Milling.PartGap)
  return true
end
-- =====================================================]]
function Base_CabinetSide(side)
  local ptA = Cab.Wpt1
  local ptB = Cab.Wpt1
  local ptL = Cab.Wpt1
  local ptG = Cab.Wpt1
  local ptH = Cab.Wpt1
  local ptI = Cab.Wpt1
  local ptJ = Cab.Wpt1
  local ptD = Cab.Wpt1
  local ptC = Cab.Wpt1
  local ptE = Cab.Wpt1
  local ptF = Cab.Wpt1
  local ptJA = Cab.Wpt1
  local ptJB = Cab.Wpt1
  local ptJC = Cab.Wpt1
  local ptK = Cab.Wpt1
        ptL = Cab.Wpt1
  local ptM = Cab.Wpt1
  local ptN = Cab.Wpt1
  local ptNA = Cab.Wpt1
  local ptNB = Cab.Wpt1
  local ptNC = Cab.Wpt1
  local ptO = Cab.Wpt1
  local ptP = Cab.Wpt1
  local ptS = Cab.Wpt1
  local ptSA = Cab.Wpt1
  local ptSB = Cab.Wpt1
  local ptSC = Cab.Wpt1
  local ptT = Cab.Wpt1
  local ptR = Cab.Wpt1
  local ptQ = Cab.Wpt1
  local pt1Text = Cab.Wpt1
  local pt2 = Cab.Wpt1
  local pt3 = Cab.Wpt1
  local pt4 = Cab.Wpt1
  local pt5 = Cab.Wpt1
  local pt6 = Cab.Wpt1
  local pt7 = Cab.Wpt1
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile .. "-Base")
  local line = Contour(0.0)
  local  DrawerHeight = 0.0
  if side  ==  "R" then
    pt1Text = Polar2D(Cab.Wpt1, 45,  1.5)
    pt2 = Polar2D(Cab.Wpt1, 0, BaseDim.CabHeight)
    pt3 = Polar2D(pt2,  90, BaseDim.CabDepth - BaseDim.FaceFrameThickness )
    pt4 = Polar2D(pt3, 180, BaseDim.CabHeight)
    pt5 = Polar2D(pt3, 270, BaseDim.ToeKickDepth - BaseDim.MaterialThickness)
    pt6 = Polar2D(pt5, 180, BaseDim.ToeKickCoverHeight)
    pt7 = Polar2D(pt3, 180, BaseDim.ToeKickCoverHeight)
    line:AppendPoint(Cab.Wpt1)
    line:LineTo(pt2)
    line:LineTo(pt5)
    line:LineTo(pt6)
    line:LineTo(pt7)
    line:LineTo(pt4)
    line:LineTo(Cab.Wpt1)
    layer:AddObject(CreateCadContour(line), true)
--  Back Dado
    ptA = Polar2D(Cab.Wpt1,  90, BaseDim.ThicknessBack)
    ptD = Polar2D(ptA, 180, Milling.PocketToolRadius)
    ptA = Polar2D(ptD, 270, BaseDim.ThicknessBack + Milling.RabbitClearance)
    ptC = Polar2D(pt2, 90, BaseDim.ThicknessBack)
    ptC = Polar2D(ptC, 0, Milling.PocketToolRadius)
    ptB = Polar2D(ptC, 270, BaseDim.ThicknessBack + Milling.RabbitClearance)
    DrawBox(ptA, ptB, ptC, ptD, Milling.LNSidePocket .. "-Base")
    local pText = Polar2D(ptA, 4,  15.75 )
    DrawWriter("Rabbit - ".. WallDim.ThicknessBack .. " X " ..  Milling.DadoHeight , pText, 0.35, Milling.LNPartLabels,  0.0)
--  Bottom Dado
    ptF = Polar2D(pt2, 180, BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight)
    ptF = Polar2D(ptF, 270, Milling.PocketToolRadius)
    ptG = Polar2D(pt3, 180, BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight)
    ptG = Polar2D(ptG, 90, Milling.PocketToolRadius)
    ptE = Polar2D(ptF, 180, BaseDim.MaterialThickness)
    ptH = Polar2D(ptG, 180, BaseDim.MaterialThickness)
    DrawBox(ptF, ptG, ptH, ptE, Milling.LNSidePocket .. "-Base")
    pText = Polar2D(ptE, 100,  2.75 )
    DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pText, 0.35, Milling.LNPartLabels,  90.0)
--  Top Frame Back Dado
    layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket .. "-Base")
    ptO = Polar2D(Cab.Wpt1,  90, BaseDim.ThicknessBack)
    ptO = Polar2D(ptO,  0, BaseDim.MaterialThickness)
    ptN = Polar2D(ptO, 90, BaseDim.TopFrameWidth)
    ptNA = Polar2D(ptN, 90, Milling.PocketToolRadius)
    ptNB = Polar2D(ptNA, 180, Milling.PocketToolDia + Milling.DadoClearance)
    ptNC = Polar2D(ptNB, 270, Milling.PocketToolRadius)
    ptM = Polar2D(ptN, 180, BaseDim.MaterialThickness + Milling.RabbitClearance)
    ptO = Polar2D(ptO, 270, Milling.RabbitClearance + BaseDim.ThicknessBack + Milling.PocketToolRadius)
    ptP = Polar2D(ptO, 180, BaseDim.MaterialThickness + Milling.RabbitClearance)
    line = Contour(0.0)
    line:AppendPoint(ptO)
    line:LineTo(ptNA)
    line:LineTo(ptNB)
    line:LineTo(ptNC)
    line:LineTo(ptM)
    line:LineTo(ptP)
    line:LineTo(ptO)
    layer:AddObject(CreateCadContour(line), true)
--  Top Frame Front Dado
    ptI = Polar2D(pt4,  0.0, BaseDim.MaterialThickness)
    ptJ = Polar2D(ptI, 270.0, BaseDim.TopFrameWidth)
    ptJA = Polar2D(ptJ,  270.0, Milling.PocketToolRadius)
    ptJB = Polar2D(ptJA, 180.0, Milling.ProfileToolDia + Milling.DadoClearance)
    ptJC = Polar2D(ptJB,  90.0, Milling.PocketToolRadius)
    ptI = Polar2D(ptI, 90.0, Milling.RabbitClearance)
    ptK = Polar2D(ptJ, 180.0, BaseDim.MaterialThickness + Milling.RabbitClearance)
    ptL = Polar2D(ptI, 180.0, BaseDim.MaterialThickness + Milling.RabbitClearance)
    line = Contour(0.0)
    line:AppendPoint(ptI)
    line:LineTo(ptJA)
    line:LineTo(ptJB)
    line:LineTo(ptJC)
    line:LineTo(ptK)
    line:LineTo(ptL)
    line:LineTo(ptI)
    layer:AddObject(CreateCadContour(line), true)
--  Toe Front Dado
    ptR = Polar2D(pt5, 270.0, BaseDim.MaterialThickness)
    ptS = Polar2D(ptR, 180.0, BaseDim.ToeKickCoverHeight)
    ptSA = Polar2D(ptS, 180.0, Milling.PocketToolRadius + BaseDim.ToeKickBottomOffsetHeight)
    ptSB = Polar2D(ptSA, 90.0, BaseDim.MaterialThickness + Milling.DadoClearance)
    ptSC = Polar2D(ptS, 90.0, BaseDim.MaterialThickness + Milling.DadoClearance)
    ptR = Polar2D(ptR, 0.0, Milling.RabbitClearance)
    ptQ = Polar2D(ptR, 90.0, BaseDim.MaterialThickness + Milling.RabbitClearance)
    ptT = Polar2D(ptS, 90.0, BaseDim.MaterialThickness + Milling.RabbitClearance)
    line = Contour(0.0)
    line:AppendPoint(ptR)
    line:LineTo(ptSA)
    line:LineTo(ptSB)
    line:LineTo(ptSC)
    line:LineTo(ptT)
    line:LineTo(ptQ)
    line:LineTo(ptR)
    layer:AddObject(CreateCadContour(line), true)
    if BaseQuestion.AddStrecherPocket then
      if BaseQuestion.DrawerRowCount >= 1 then
        local AX = pt4
        local DrawerRowCountX = 1
        while DrawerRowCountX <= BaseQuestion.DrawerRowCount do
          if DrawerRowCountX == 3 then
            DrawerHeight = BaseDim.FaceFrameDrawerHeight3 + BaseDim.FaceFrameMidRailWidth + (BaseDim.FaceFrameMidRailWidth * 0.5)
          end
          if DrawerRowCountX ==2 then
            DrawerHeight = BaseDim.FaceFrameDrawerHeight2 + BaseDim.FaceFrameMidRailWidth + (BaseDim.FaceFrameMidRailWidth * 0.5)
          end
          if DrawerRowCountX == 1 then
            DrawerHeight = BaseDim.FaceFrameDrawerHeight1 + BaseDim.FaceFrameTopRailWidth + (BaseDim.FaceFrameMidRailWidth * 0.5)
          end
          AX = Polar2D(AX,  0.0, DrawerHeight)
          Base_StrecherPocket(AX, 270)
          DrawerRowCountX = DrawerRowCountX+1
        end
      end
    end
    DrawWriter("Base Cabinet Right Side - ".. BaseDim.MaterialThickness .." Plywood  ( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4).." )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
    CutListfileWriterItem("310", "Base Cabinet Right Side", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
-- =====================================================]]
  else --  side  ==  "L"
-- =====================================================]]
    pt1Text = Polar2D(Cab.Wpt2, 45,  1.5)
    pt2 = Polar2D(Cab.Wpt2, 0, BaseDim.CabHeight)
    pt3 = Polar2D(pt2,  90, BaseDim.CabDepth - BaseDim.FaceFrameThickness)
    pt4 = Polar2D(pt3, 180, BaseDim.CabHeight)
    pt5 = Polar2D(pt2, 90, BaseDim.ToeKickDepth - BaseDim.MaterialThickness)
    pt6 = Polar2D(pt5, 180, BaseDim.ToeKickCoverHeight)
    pt7 = Polar2D(pt2, 180, BaseDim.ToeKickCoverHeight)
    line:AppendPoint(Cab.Wpt2)
    line:LineTo(pt7)
    line:LineTo(pt6)
    line:LineTo(pt5)
    line:LineTo(pt3)
    line:LineTo(pt4)
    line:LineTo(Cab.Wpt2)
    layer:AddObject(CreateCadContour(line), true)
--  Back Dado
    ptA = Polar2D(pt4, 270, BaseDim.ThicknessBack)
    ptA = Polar2D(ptA, 180, Milling.PocketToolRadius)
    ptD = Polar2D(ptA, 90, BaseDim.ThicknessBack + Milling.RabbitClearance)
    ptB = Polar2D(pt3, 270, BaseDim.ThicknessBack)
    ptB = Polar2D(ptB,  0, Milling.PocketToolRadius)
    ptC = Polar2D(ptB, 90, BaseDim.ThicknessBack + Milling.RabbitClearance)
    DrawBox(ptA, ptB, ptC, ptD, Milling.LNSidePocket .. "-Base")
    local pText = Polar2D(ptA, 350,  2.75 )
    DrawWriter("Rabbit - ".. WallDim.ThicknessBack .. " X " ..  Milling.DadoHeight , pText, 0.35, Milling.LNPartLabels,  0.0)
--  Bottom Dado
    ptF = Polar2D(pt2, 180, BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight)
    ptF = Polar2D(ptF, 270, Milling.PocketToolRadius)
    ptG = Polar2D(pt3, 180, BaseDim.ToeKickCoverHeight + BaseDim.ToeKickBottomOffsetHeight)
    ptG = Polar2D(ptG, 90, Milling.PocketToolRadius)
    ptE = Polar2D(ptF, 180, BaseDim.MaterialThickness)
    ptH = Polar2D(ptG, 180, BaseDim.MaterialThickness)
    DrawBox(ptF, ptG, ptH, ptE, Milling.LNSidePocket .. "-Base")
    pText = Polar2D(ptF, 120,  2.75 )
    DrawWriter("Dado - ".. WallDim.MaterialThickness .. " X " ..  Milling.DadoHeight , pText, 0.35, Milling.LNPartLabels,  90.0)
--  Top Frame Front Dado
    layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket .. "-Base")
    ptO = Polar2D(Cab.Wpt2, 0, BaseDim.MaterialThickness)
    ptN = Polar2D(ptO, 90, BaseDim.TopFrameWidth)
    ptNA = Polar2D(ptN, 90, Milling.PocketToolRadius)
    ptNB = Polar2D(ptNA, 180, Milling.ProfileToolDia + Milling.DadoClearance)
    ptNC = Polar2D(ptNB, 270, Milling.PocketToolRadius)
    ptM = Polar2D(ptN, 180, BaseDim.MaterialThickness+ Milling.RabbitClearance)
    ptO = Polar2D(ptO, 270, Milling.RabbitClearance)
    ptP = Polar2D(ptO, 180, BaseDim.MaterialThickness + Milling.RabbitClearance)
    line = Contour(0.0)
    line:AppendPoint(ptO)
    line:LineTo(ptNA)
    line:LineTo(ptNB)
    line:LineTo(ptNC)
    line:LineTo(ptM)
    line:LineTo(ptP)
    line:LineTo(ptO)
    layer:AddObject(CreateCadContour(line), true)
--  Top Frame Back Dado
    ptI = Polar2D(pt4, 270, BaseDim.ThicknessBack)
    ptI = Polar2D(ptI,  0, BaseDim.MaterialThickness)
    ptJ = Polar2D(ptI, 270, BaseDim.TopFrameWidth)
    ptJA = Polar2D(ptJ,  270, Milling.PocketToolRadius)
    ptJB = Polar2D(ptJA, 180, Milling.ProfileToolDia + Milling.DadoClearance)
    ptJC = Polar2D(ptJB,  90, Milling.PocketToolRadius)
    ptI = Polar2D(ptI, 90, Milling.RabbitClearance + BaseDim.ThicknessBack + Milling.PocketToolRadius)
    ptK = Polar2D(ptJ, 180, BaseDim.MaterialThickness + Milling.RabbitClearance)
    ptL = Polar2D(ptI, 180, BaseDim.MaterialThickness + Milling.RabbitClearance)
    line = Contour(0.0)
    line:AppendPoint(ptI)
    line:LineTo(ptJA)
    line:LineTo(ptJB)
    line:LineTo(ptJC)
    line:LineTo(ptK)
    line:LineTo(ptL)
    line:LineTo(ptI)
    layer:AddObject(CreateCadContour(line), true)
--  Toe Front Dado
    ptR = Polar2D(pt5,    90.0, BaseDim.MaterialThickness)
    ptS = Polar2D(ptR,   180.0, BaseDim.ToeKickCoverHeight)
    ptSA = Polar2D(ptS,  180.0, Milling.PocketToolRadius + BaseDim.ToeKickBottomOffsetHeight)
    ptSB = Polar2D(ptSA, 270.0, BaseDim.MaterialThickness + Milling.DadoClearance)
    ptSC = Polar2D(ptS,  270.0, BaseDim.MaterialThickness + Milling.DadoClearance)
    ptR = Polar2D(ptR,     0.0, Milling.RabbitClearance)
    ptQ = Polar2D(ptR,   270.0, BaseDim.MaterialThickness + Milling.RabbitClearance)
    ptT = Polar2D(ptS,   270.0, BaseDim.MaterialThickness + Milling.RabbitClearance)
    line = Contour(0.0)
    line:AppendPoint(ptR)
    line:LineTo(ptSA)
    line:LineTo(ptSB)
    line:LineTo(ptSC)
    line:LineTo(ptT)
    line:LineTo(ptQ)
    line:LineTo(ptR)
    layer:AddObject(CreateCadContour(line), true)
    if BaseQuestion.AddStrecherPocket then
      if BaseQuestion.DrawerRowCount >= 1 then
        local AX = Cab.Wpt2
        local DrawerRowCountX = 1
        while DrawerRowCountX <= BaseQuestion.DrawerRowCount do
          if DrawerRowCountX == 3 then
            DrawerHeight = BaseDim.FaceFrameDrawerHeight3 + BaseDim.FaceFrameMidRailWidth + (BaseDim.FaceFrameMidRailWidth * 0.5)
          end
          if DrawerRowCountX ==2 then
            DrawerHeight = BaseDim.FaceFrameDrawerHeight2 + BaseDim.FaceFrameMidRailWidth + (BaseDim.FaceFrameMidRailWidth * 0.5)
          end
          if DrawerRowCountX == 1 then
            DrawerHeight = BaseDim.FaceFrameDrawerHeight1 + BaseDim.FaceFrameTopRailWidth + (BaseDim.FaceFrameMidRailWidth * 0.5)
          end
          AX = Polar2D(AX,  0.0, DrawerHeight)
          Base_StrecherPocket(AX, 90)
          DrawerRowCountX = DrawerRowCountX+1
        end
      end
    end
    DrawWriter("Base Cabinet Left Side - ".. BaseDim.MaterialThickness .." Plywood  ( " .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4).." )", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
    CutListfileWriterItem("300", "Base Cabinet Left Side ", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  end
  if BaseQuestion.ShelfCount >= 1 then
    local ptx = Cab.Wpt1
    local anx = 0
    if side  ==  "L" then
      ptx = Polar2D(Polar2D(Cab.Wpt2, 0, BaseDim.HoleDrop), 90, BaseDim.ShelfPinHoleFront)
      anx = 90
    else
      ptx = Polar2D(Polar2D(Cab.Wpt1, 0, BaseDim.HoleDrop), 90, ( BaseDim.ThicknessBack + BaseDim.ShelfPinHoleBack))
      anx = 90
    end
    local rows = BaseDim.HoleRows
    while (rows >0) do
      Holer(ptx, anx, BaseDim.HoleSpace, Milling.ShelfPinRadius, Milling.LNSideShelfPinDrill .. "-Base")
      ptx = Polar2D(ptx, 0.0, BaseDim.ShelfHoleSpacing)
      rows = (rows - 1.0)
    end
  end
  return true
end
-- =====================================================]]
function Base_CenterPanel()
  local pt1 = Polar2D(Cab.Wpt4, 0.0, BaseDim.MaterialThickness )
  local pt2 = Polar2D(pt1, 0.0, BaseDim.CenterPanelLength)
  local pt3 = Polar2D(pt2, 90.0, BaseDim.CenterPanelWidth)
  local pt4 = Polar2D(pt3, 180.0, BaseDim.CenterPanelLength)
  DrawBox(pt1, pt2, pt3, pt4, Milling.LNCenterPanelProfile .. "-Base")
  local pt1Text = Polar2D(Cab.Wpt4, 45,  1.5)
  DrawWriter("Base Cabinet Center Panel - ".. BaseDim.MaterialThickness .." Plywood  (" .. GetDistance(pt2, pt3) .. " x " .. GetDistance(pt3, pt4) ..")", pt1Text, 0.35000, Milling.LNPartLabels, 0.0)
  CutListfileWriterItem("350", "Base Cabinet Center Panel", "1", BaseDim.MaterialThickness, "Plywood", GetDistance(pt2, pt3), GetDistance(pt3, pt4))
  if BaseQuestion.ShelfCount >= 1 then
    local ptx = Polar2D(Polar2D(Cab.Wpt4, 0.0, BaseDim.HoleDrop), 90.0, BaseDim.ShelfPinHoleFront)
    local rows = BaseDim.HoleRows
    while (rows >0) do
      Holer(ptx, 90.0, BaseDim.HoleSpace, Milling.ShelfPinRadius, Milling.LNCenterPanelShelfPinDrill .. "-Base")
      ptx = Polar2D(ptx, 0.0, BaseDim.ShelfHoleSpacing)
      rows = (rows - 1.0)
    end
  end
  return true
end
-- =====================================================]]
function Base_StrecherPocket(p1, Ang)
  local X1 = Cab.Wpt1
  local X2 = Cab.Wpt1
  local X3 = Cab.Wpt1
  local X4 = Cab.Wpt1
  local X5 = Cab.Wpt1
  local X6 = Cab.Wpt1
  local X7 = Cab.Wpt1
  local X8 = Cab.Wpt1
  if Ang == 270 then
    X1 = Polar2D(Polar2D(p1, 90.0, Milling.PocketToolRadius ), 180.0, ((BaseDim.StretcherThickness  + Milling.DadoClearance) * 0.5 ))
    X2 = Polar2D(X1, 270.0, BaseDim.StretcherWidth - Milling.PocketToolRadius )
    X3 = Polar2D(X2, 180.0, Milling.PocketToolRadius)
    X4 = Polar2D(X3, 270.0, Milling.PocketToolDia)
    X5 = Polar2D(X4, 0.0, BaseDim.StretcherThickness+ Milling.DadoClearance + Milling.PocketToolDia )
    X6 = Polar2D(X5, 90.0, Milling.PocketToolDia)
    X7 = Polar2D(X6, 180.0, Milling.PocketToolRadius)
    X8 = Polar2D(X1,  0.0, BaseDim.StretcherThickness  + Milling.DadoClearance)
  end
  if Ang == 90 then
    X1 = Polar2D(Polar2D(p1, 270.0, Milling.PocketToolRadius), 0.0, ((BaseDim.StretcherThickness + Milling.DadoClearance) * 0.5 ))
    X2 = Polar2D(X1, 90.0, BaseDim.StretcherWidth - Milling.PocketToolRadius )
    X3 = Polar2D(X2,  0.0, Milling.PocketToolRadius)
    X4 = Polar2D(X3, 90.0, Milling.PocketToolDia)
    X5 = Polar2D(X4, 180.0, BaseDim.StretcherThickness + Milling.DadoClearance + Milling.PocketToolDia )
    X6 = Polar2D(X5, 270.0, Milling.PocketToolDia)
    X7 = Polar2D(X6,  0.0, Milling.PocketToolRadius)
    X8 = Polar2D(X1,  180.0, BaseDim.StretcherThickness  + Milling.DadoClearance)
  end
  local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket .. "-Base")
  local line = Contour(0.0)
  line:AppendPoint(X1)
  line:LineTo(X2)
  line:LineTo(X3)
  line:LineTo(X4)
  line:LineTo(X5)
  line:LineTo(X6)
  line:LineTo(X7)
  line:LineTo(X8)
  line:LineTo(X1)
  layer:AddObject(CreateCadContour(line), true)
  return true
end
-- =====================================================]]
function main(script_path)
  Milling.job = VectricJob()
  if not Milling.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end
  Tools = assert(loadfile(script_path .. "\\EasyCabinetMaker11.0-00.xlua")) (Tools) -- Load Tool Function
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
  GetMaterialSettings()
  REG_ReadRegistry()
  Tool_ID1:LoadDefaults("My Toolpath1", Milling.Tool1)
  Tool_ID2:LoadDefaults("My Toolpath2", Milling.Tool2)
  Tool_ID3:LoadDefaults("My Toolpath3", Milling.Tool3)
  Tool_ID4:LoadDefaults("My Toolpath3", Milling.Tool4)
  HTML()
  Wall_Math()
  Base_Math()
  Mill_Math()
  Project.NewSheet = "YES"
  local Drawing = InquiryWallOrBase("Easy Cabinet Maker", "Select Cabinet Type", {"Wall", "Base", "Both"})
  if Drawing then
    if Project.ProjectPath  ==  "Default" then
        DisplayMessageBox("Alert: The Cabinet Maker is not configured.  \n The Project path must be selected and saved.")
        OnLuaButton_InquiryProjectInfo()
        return false
      -- end  -- if no Project Path
    elseif All_Trim(Project.ProjectPath)  ==  "" then
        DisplayMessageBox("Alert: The Cabinet Maker is Blank.  \n A Project path must be selected and saved.")
        OnLuaButton_InquiryProjectInfo()
        return false
      -- end  -- if no Project Path
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
      REG_ReadRegistry()
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
        Cab.Wpt2 = Polar2D(Cab.Wpt1,  0.0,(WallDim.CabHeight  + Milling.PartGap))
        Cab.Wpt3 = Polar2D(Cab.Wpt1, 90.0, WallDim.CabDepth   + Milling.PartGap - WallDim.FaceFrameThickness)
        Cab.Wpt4 = Polar2D(Cab.Wpt3,  0.0, (WallDim.CabLength - WallDim.MaterialThickness ) + Milling.PartGap)
        Cab.Wpt5 = Polar2D(Cab.Wpt3, 90.0, WallDim.CabDepth   + Milling.PartGap - WallDim.FaceFrameThickness) --  Shelf
        Cab.Wpt6 = Polar2D(Cab.Wpt5, 90.0, WallDim.ShelfWidth + Milling.PartGap) --  Shelf
        Cab.Wpt7 = Polar2D(Cab.Wpt2,  0.0, WallDim.CabHeight  + Milling.PartGap) --  Wall_CenterPanel()
        Cab.Wpt8 = Polar2D(Cab.Wpt2,  0.0, WallDim.CabDepth   + Milling.PartGap) --  Shelf
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
      -- =====================================================]]
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall Side Pockets", Milling.LNSidePocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall TopBottom Pockets", Milling.LNTopBottomPocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
      -- =====================================================]]
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
  -- =====================================================]]
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
-- =====================================================]]
  end
  Milling.job:Refresh2DView()
  return true
end -- function end
-- =================== End ============================]]