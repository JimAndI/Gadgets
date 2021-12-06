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

Easy Cabinet Maker was written by Jim Anderson of Houston Texas 2019

-- Version 09-7.2 - July 24,2020
--         09-7.2 - Changed to support Vectric 7.5-9.9

-- Version 7.1 - July 7,2020
--         7.1 - Added Layer Colors
--         7.1 - ?
-- ====================================================]]
-- Global variables
require("mobdebug").start()
-- require "strict"
local Tooler1, Tooler2, Tooler3, Tooler4,  Tooler5
local YearNumber = "2020"
local VerNumber = "09-7.2"
local AppName = "Easy Cabinet Maker"
local RegName = "EasyCabinetMaker" .. VerNumber
--  Table Names
local BaseDim = {}
local BaseQuestion = {}
local Milling = {}
local Project = {}
local WallDim = {}
local WallQuestion = {}
local Cab = {}            -- Points
local DialogWindow = {}   -- Dialog Managment
local layer
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
Project.Drawing = "BOTH"
Cab.Wpt1     = Point2D(1, 1)   --  Left Side Panel
Cab.Wpt2     = Point2D(20, 1)  --  Right Side Panel
Cab.Wpt3     = Point2D(40, 1)  --  Base_CabinetShelf
Cab.Wpt4     = Point2D(14, 1)  --  Base_CenterPanel
Cab.Wpt5     = Point2D(14, 34) --  Wall_CabinetShelf
Cab.Wpt6     = Point2D(30, 1)  --  Base_CabinetBottom
Cab.Wpt7     = Point2D(30, 1)  --  Wall_CenterPanel
Cab.Wpt8     = Point2D(45, 1)  --  No Call = Polar2D(Cab.Wpt5, 0.0, WallDim.CabLength + Milling.PartGap) --  Shelf
Cab.Wpt9     = Cab.Wpt1        --  Stretcher Parts
Cab.Wpt10    = Cab.Wpt1        --  Stretcher Parts
Milling.Tabs = false           --  User to setup Tabs
-- ====================================================]]
function AddGroupToJob(group, layer_name)
  local cad_object = CreateCadGroup(group)
  local layer = Milling.job.LayerManager:GetLayerWithName(layer_name)
  layer:AddObject(cad_object, true)
  return cad_object
end
-- ====================================================]]
function ifT(x) --  Converts True and False to Yes or No
  if x then
    return "Yes"
  else
    return "No"
  end
end
-- ====================================================]]
function ifY(x) --  Converts Yes and No to True or False
  if x == "Yes" then
    return true
  else
    return false
  end
end
-- ====================================================]]
function DrawBox(p1, p2, p3, p4, Layer)
    local line = Contour(0.0)
    local layer = Milling.job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(p1) ;
    line:LineTo(p2);
    line:LineTo(p3) ;
    line:LineTo(p4);
    line:LineTo(p1);
    layer:AddObject(CreateCadContour(line), true)
    return true
  end -- function end
-- ====================================================]]
function DrawLine(Pt1, Pt2, Layer)
    local line = Contour(0.0)
    local layer = Milling.job.LayerManager:GetLayerWithName(Layer)
    line:AppendPoint(Pt1) ;
    line:LineTo(Pt2) ;
    layer:AddObject(CreateCadContour(line), true)
    return true
  end
-- ====================================================]]
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
  Project.DrawerID     = StartDate()
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
-- ====================================================]]
function Mill_Math()  --  All the math for Wall Cabinet
  Milling.ShelfPinRadius    = Milling.ShelfPinDiameter * 0.500
  Milling.ProfileToolRadius = Milling.ProfileToolDia * 0.500
  Milling.PocketToolRadius  = Milling.PocketToolDia * 0.500
  Project.DrawerID  = StartDate()
  return true
end
-- ====================================================]]
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
-- ====================================================]]
function REG_ReadRegistry()  --  Read from Registry values
  local RegistryRead                        = Registry(RegName)
  BaseDim.CabDepth                          = RegistryRead:GetDouble("BaseDim.CabDepth", 23.0000)
  BaseDim.CabHeight                         = RegistryRead:GetDouble("BaseDim.CabHeight", 35.500)
  BaseDim.CabLength                         = RegistryRead:GetDouble("BaseDim.CabLength", 36.0000)
  BaseDim.FaceFrameBottomRailWidth          = RegistryRead:GetDouble("BaseDim.FaceFrameBottomRailWidth", 1.5000)
  BaseDim.FaceFrameBottomReveal             = RegistryRead:GetDouble("BaseDim.FaceFrameBottomReveal", 0.0625)
  BaseDim.FaceFrameCenterStileWidth         = RegistryRead:GetDouble("BaseDim.FaceFrameCenterStileWidth", 1.7500)
  BaseDim.FaceFrameDrawerHeight1            = RegistryRead:GetDouble("BaseDim.FaceFrameDrawerHeight1", 5.0000)
  BaseDim.FaceFrameDrawerHeight2            = RegistryRead:GetDouble("BaseDim.FaceFrameDrawerHeight2", 6.0000)
  BaseDim.FaceFrameDrawerHeight3            = RegistryRead:GetDouble("BaseDim.FaceFrameDrawerHeight3", 6.0000)
  BaseDim.FaceFrameMidRailWidth             = RegistryRead:GetDouble("BaseDim.FaceFrameMidRailWidth", 1.5000)
  BaseDim.FaceFrameSideReveal               = RegistryRead:GetDouble("BaseDim.FaceFrameSideReveal", 0.2500)
  BaseDim.FaceFrameStileWidth               = RegistryRead:GetDouble("BaseDim.FaceFrameStileWidth", 2.2500)
  BaseDim.FaceFrameThickness                = RegistryRead:GetDouble("BaseDim.FaceFrameThickness", 0.7500)
  BaseDim.FaceFrameTopOverlap               = RegistryRead:GetDouble("BaseDim.FaceFrameTopOverlap", 0.7500)
  BaseDim.FaceFrameTopRailWidth             = RegistryRead:GetDouble("BaseDim.FaceFrameTopRailWidth", 1.7500)
  BaseDim.MaterialThickness                 = RegistryRead:GetDouble("BaseDim.MaterialThickness", 0.750)
  BaseDim.ShelfEndClarence                  = RegistryRead:GetDouble("BaseDim.ShelfEndClarence", 0.1800)
  BaseDim.ShelfFaceFrameThickness           = RegistryRead:GetDouble("BaseDim.ShelfFaceFrameThickness", 0.750)
  BaseDim.ShelfFaceFrameWidth               = RegistryRead:GetDouble("BaseDim.ShelfFaceFrameWidth", 1.2500)
  BaseDim.ShelfFrontClearance               = RegistryRead:GetDouble("BaseDim.ShelfFrontClearance", 0.2500)
  BaseDim.ShelfHoleFirstRowSpacing          = RegistryRead:GetDouble("BaseDim.ShelfHoleFirstRowSpacing", 4.00)
  BaseDim.ShelfHoleLastRowSpacing           = RegistryRead:GetDouble("BaseDim.ShelfHoleLastRowSpacing", 3.000)
  BaseDim.ShelfHoleSpacing                  = RegistryRead:GetDouble("BaseDim.ShelfHoleSpacing", 2.000)
  BaseDim.ShelfMaterialThickness            = RegistryRead:GetDouble("BaseDim.ShelfMaterialThickness", 0.7500)
  BaseDim.ShelfPinHoleBack                  = RegistryRead:GetDouble("BaseDim.ShelfPinHoleBack", 3.0000)
  BaseDim.ShelfPinHoleFront                 = RegistryRead:GetDouble("BaseDim.ShelfPinHoleFront", 2.75)
  BaseDim.StretcherThickness                = RegistryRead:GetDouble("BaseDim.StretcherThickness", 0.50)
  BaseDim.StretcherWidth                    = RegistryRead:GetDouble("BaseDim.StretcherWidth", 3.500)
  BaseDim.ThicknessBack                     = RegistryRead:GetDouble("BaseDim.ThicknessBack", 0.50)
  BaseDim.ToeKickBottomOffsetHeight         = RegistryRead:GetDouble("BaseDim.ToeKickBottomOffsetHeight", 0.500)
  BaseDim.ToeKickCoverHeight                = RegistryRead:GetDouble("BaseDim.ToeKickCoverHeight", 3.6875)
  BaseDim.ToeKickDepth                      = RegistryRead:GetDouble("BaseDim.ToeKickDepth", 3.0000)
  BaseDim.ToeKickHeight                     = RegistryRead:GetDouble("BaseDim.ToeKickHeight", 3.5000)
  BaseDim.TopFrameWidth                     = RegistryRead:GetDouble("BaseDim.TopFrameWidth", 3.7500)
  BaseQuestion.AddCenterFaceFrame           = RegistryRead:GetBool("BaseQuestion.AddCenterFaceFrame", true)
  BaseQuestion.AddCenterPanel               = RegistryRead:GetBool("BaseQuestion.AddCenterPanel", true)
  BaseQuestion.AddStrecherPocket            = RegistryRead:GetBool("BaseQuestion.AddStrecherPocket", true)
  BaseQuestion.DadoStyle                    = RegistryRead:GetString("BaseQuestion.DadoStyle", "Through")
  BaseQuestion.DrawerRowCount               = RegistryRead:GetInt("BaseQuestion.DrawerRowCount", 1)
  BaseQuestion.ShelfCount                   = RegistryRead:GetInt("BaseQuestion.ShelfCount", 2.0000)
  DialogWindow.AboutXY                      = RegistryRead:GetString("DialogWindow.AboutXY", "0")
  DialogWindow.BaseCabinetXY                = RegistryRead:GetString("DialogWindow.BaseCabinetXY", "0")
  DialogWindow.InquiryWallOrBaseXY          = RegistryRead:GetString("DialogWindow.InquiryWallOrBaseXX0", "0")
  DialogWindow.LayerXY                      = RegistryRead:GetString("DialogWindow.LayerXY", "0")
  DialogWindow.MillingXY                    = RegistryRead:GetString("DialogWindow.MillingXY", "0")
  DialogWindow.ProjectXY                    = RegistryRead:GetString("DialogWindow.ProjectSetupXX0", "0")
  DialogWindow.WallCabinetXY                = RegistryRead:GetString("DialogWindow.WallCabinetSetupXX0", "0")
  Milling.DadoBackHeight                    = RegistryRead:GetDouble("Milling.DadoBackHeight", 0.2500)
  Milling.DadoClearance                     = RegistryRead:GetDouble("Milling.DadoClearance", 0.0100)
  Milling.DadoHeight                        = RegistryRead:GetDouble("Milling.DadoHeight", 0.3750)

  Milling.LNBackPocketColor               = RegistryRead:GetString("Milling.LNBackPocketColor",               "Red")
  Milling.LNBackProfileColor              = RegistryRead:GetString("Milling.LNBackProfileColor",              "Black")
  Milling.LNCenterPanelProfileColor       = RegistryRead:GetString("Milling.LNCenterPanelProfileColor",       "Cyan")
  Milling.LNCenterPanelShelfPinDrillColor = RegistryRead:GetString("Milling.LNCenterPanelShelfPinDrillColor", "Black")
  Milling.LNDrawFaceFrameColor            = RegistryRead:GetString("Milling.LNDrawFaceFrameColor",            "Black")
  Milling.LNDrawNotesColor                = RegistryRead:GetString("Milling.LNDrawNotesColor",                "Blue")
  Milling.LNPartLabelsColor               = RegistryRead:GetString("Milling.LNPartLabelsColor",               "Green")
  Milling.LNShelfProfileColor             = RegistryRead:GetString("Milling.LNShelfProfileColor",             "Black")
  Milling.LNSidePocketColor               = RegistryRead:GetString("Milling.LNSidePocketColor",               "Cyan")
  Milling.LNSideProfileColor              = RegistryRead:GetString("Milling.LNSideProfileColor",              "Black")
  Milling.LNSideShelfPinDrillColor        = RegistryRead:GetString("Milling.LNSideShelfPinDrillColor",        "Red")
  Milling.LNStretcherRailProfileColor     = RegistryRead:GetString("Milling.LNStretcherRailProfileColor",     "Black")
  Milling.LNTopBottomPocketColor          = RegistryRead:GetString("Milling.LNTopBottomPocketColor",          "Blue")
  Milling.LNTopBottomProfileColor         = RegistryRead:GetString("Milling.LNTopBottomProfileColor",         "Green")

  Milling.LNBackPocket               = RegistryRead:GetString("Milling.LNBackPocket",               "BackPocketProfile")
  Milling.LNBackProfile              = RegistryRead:GetString("Milling.LNBackProfile",              "BackPanelProfile")
  Milling.LNCenterPanelProfile       = RegistryRead:GetString("Milling.LNCenterPanelProfile",       "CenterPanelProfile")
  Milling.LNCenterPanelShelfPinDrill = RegistryRead:GetString("Milling.LNCenterPanelShelfPinDrill", "PinHoles")
  Milling.LNDrawFaceFrame            = RegistryRead:GetString("Milling.LNDrawFaceFrame",            "FaceFrameProfile")
  Milling.LNDrawNotes                = RegistryRead:GetString("Milling.LNDrawNotes",                "NotesProfile")
  Milling.LNPartLabels               = RegistryRead:GetString("Milling.LNPartLabels",               "PartLabels")
  Milling.LNShelfProfile             = RegistryRead:GetString("Milling.LNShelfProfile",             "ShelfPanelProfile")
  Milling.LNSidePocket               = RegistryRead:GetString("Milling.LNSidePocket",               "SidePanelPocket")
  Milling.LNSideProfile              = RegistryRead:GetString("Milling.LNSideProfile",              "SidePanelProfile")
  Milling.LNSideShelfPinDrill        = RegistryRead:GetString("Milling.LNSideShelfPinDrill",        "DrillShelfPinProfile")
  Milling.LNStretcherRailProfile     = RegistryRead:GetString("Milling.LNStretcherRailProfile",     "StretcherProfile")
  Milling.LNTopBottomPocket          = RegistryRead:GetString("Milling.LNTopBottomPocket",          "TopBottomPocket")
  Milling.LNTopBottomProfile         = RegistryRead:GetString("Milling.LNTopBottomProfile",         "TopBottomPanelProfile")
  Milling.PartGap                           = RegistryRead:GetDouble("Milling.PartGap", 0.5000)
  Milling.PocketToolDia                     = RegistryRead:GetDouble("Milling.PocketToolDia", 0.2500)
  Milling.ProfileToolDia                    = RegistryRead:GetDouble("Milling.ProfileToolDia", 0.2500)
  Milling.ProfileToolRadius                 = RegistryRead:GetDouble("Milling.ProfileToolRadius", 0.1250)
  Milling.RabbitClearance                   = RegistryRead:GetDouble("Milling.RabbitClearance", 0.0500)
  Milling.ShelfPinDiameter                  = RegistryRead:GetDouble("Milling.ShelfPinDiameter", 0.1940)
  Milling.ShelfPinLen                       = RegistryRead:GetDouble("Milling.ShelfPinLen", 0.5000)
  Milling.ShelfPinRadius                    = RegistryRead:GetDouble("Milling.ShelfPinRadius", 0.0970)
  Project.CabinetName                       = RegistryRead:GetString("Project.CabinetName", "Default")
  Project.ProgramCodeBy                     = RegistryRead:GetString("Project.ProgramCodeBy", "James Anderson")
  Project.ProgramName                       = RegistryRead:GetString("Project.ProgramName", "Easy Cabinet Maker")
  Project.ProgramVersion                    = RegistryRead:GetString("Project.ProgramVersion", VerNumber)
  Project.ProgramYear                       = RegistryRead:GetString("Project.ProgramYear", YearNumber)
  Project.ProjectContactEmail               = RegistryRead:GetString("Project.ProjectContactEmail", "Default@Email.com")
  Project.ProjectContactName                = RegistryRead:GetString("Project.ProjectContactName", "Who")
  Project.ProjectContactPhoneNumber         = RegistryRead:GetString("Project.ProjectContactPhoneNumber", "(123)456-7890")
  Project.ProjectName                       = RegistryRead:GetString("Project.ProjectName", "CABINET PROJECTS")
  Project.ProjectPath                       = RegistryRead:GetString("Project.ProjectPath", "Default")
  WallDim.CabDepth                          = RegistryRead:GetDouble("WallDim.CabDepth", 12.0000)
  WallDim.CabHeight                         = RegistryRead:GetDouble("WallDim.CabHeight", 28.000)
  WallDim.CabLength                         = RegistryRead:GetDouble("WallDim.CabLength", 36.000)
  WallDim.FaceFrameBottomRailWidth          = RegistryRead:GetDouble("WallDim.FaceFrameBottomRailWidth", 1.2500)
  WallDim.FaceFrameBottomReveal             = RegistryRead:GetDouble("WallDim.FaceFrameBottomReveal", 0.0625)
  WallDim.FaceFrameCenterStileWidth         = RegistryRead:GetDouble("WallDim.FaceFrameCenterStileWidth", 1.7500)
  WallDim.FaceFrameSideReveal               = RegistryRead:GetDouble("WallDim.FaceFrameSideReveal", 0.0625)
  WallDim.FaceFrameStileWidth               = RegistryRead:GetDouble("WallDim.FaceFrameStileWidth", 2.2500)
  WallDim.FaceFrameThickness                = RegistryRead:GetDouble("WallDim.FaceFrameThickness", 0.7500)
  WallDim.FaceFrameTopOverlap               = RegistryRead:GetDouble("WallDim.FaceFrameTopOverlap", 0.7500)
  WallDim.FaceFrameTopRailWidth             = RegistryRead:GetDouble("WallDim.FaceFrameTopRailWidth", 1.7500)
  WallDim.FaceFrameTopReveal                = RegistryRead:GetDouble("WallDim.FaceFrameTopReveal", 0.2500)
  WallDim.MaterialThickness                 = RegistryRead:GetDouble("WallDim.MaterialThickness", 0.7500)
  WallDim.ShelfEndClarence                  = RegistryRead:GetDouble("WallDim.ShelfEndClarence", 0.1800)
  WallDim.ShelfFaceFrameThickness           = RegistryRead:GetDouble("WallDim.ShelfFaceFrameThickness", 0.7500)
  WallDim.ShelfFaceFrameWidth               = RegistryRead:GetDouble("WallDim.ShelfFaceFrameWidth", 1.2500)
  WallDim.ShelfFrontClearance               = RegistryRead:GetDouble("WallDim.ShelfFrontClearance", 0.2500)
  WallDim.ShelfHoleFirstRowSpacing          = RegistryRead:GetDouble("WallDim.ShelfHoleFirstRowSpacing", 4.0000)
  WallDim.ShelfHoleLastRowSpacing           = RegistryRead:GetDouble("WallDim.ShelfHoleLastRowSpacing", 3.0000)
  WallDim.ShelfHoleSpacing                  = RegistryRead:GetDouble("WallDim.ShelfHoleSpacing", 2.0000)
  WallDim.ShelfMaterialThickness            = RegistryRead:GetDouble("WallDim.ShelfMaterialThickness", 0.7500)
  WallDim.ShelfPinHoleBack                  = RegistryRead:GetDouble("WallDim.ShelfPinHoleBack", 2.0)
  WallDim.ShelfPinHoleFront                 = RegistryRead:GetDouble("WallDim.ShelfPinHoleFront", 1.75)
  WallDim.ThicknessBack                     = RegistryRead:GetDouble("WallDim.ThicknessBack", 0.5000)
  WallQuestion.AddCenterFaceFrame           = RegistryRead:GetBool("WallQuestion.AddCenterFaceFrame", true)
  WallQuestion.AddCenterPanel               = RegistryRead:GetBool("WallQuestion.AddCenterPanel", false)
  WallQuestion.DadoBackPanelForCenterPanel  = RegistryRead:GetBool("WallQuestion.DadoBackPanelForCenterPanel", true)
  WallQuestion.DadoStyle                    = RegistryRead:GetString("WallQuestion.DadoStyle", "Through")
  WallQuestion.ShelfCount                   = RegistryRead:GetInt("WallQuestion.ShelfCount", 2.0000)
  return true
end
-- ====================================================]]
function CreateLayerPocketingToolpath(name, layer_name, start_depth, cut_depth)
  if Milling.Pocket then
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
   -- Create tool we will use to machine vectors
    local tool = Tool(Milling.MillTool2.Name, Tool.END_MILL)    -- BALL_NOSE, END_MILL, VBIT
          tool.InMM         = Milling.MillTool2.InMM            -- tool_in_mm
          tool.ToolDia      = Milling.MillTool2.ToolDia         -- tool_dia
          tool.Stepdown     = Milling.MillTool2.Stepdown        -- tool_stepdown
          tool.Stepover     = Milling.MillTool2.Stepover        -- tool_dia * (tool_stepover_percent / 100)
          tool.RateUnits    = Milling.MillTool2.RateUnits       -- Tool.MM_SEC     -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Milling.MillTool2.FeedRate        -- 30
          tool.PlungeRate   = Milling.MillTool2.PlungeRate      -- 10
          tool.SpindleSpeed = Milling.MillTool2.SpindleSpeed    -- 20000
          tool.ToolNumber   = Milling.MillTool2.ToolNumber      -- 1
      --  tool.VBitAngle    = Milling.MillTool.VBitAngle          -- 90.0            -- used for vbit only
      --  tool.ClearStepover = Milling.MillTool.ClearStepover   --  tool_dia * (tool_stepover_percent / 100)  -- used for vbit only
   -- we will set home position and safe z relative to material block size
    local mtl_block = MaterialBlock()
    local mtl_box = mtl_block.MaterialBox
    local mtl_box_blc = mtl_box.BLC
   -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
          pos_data.SafeZGap = mtl_block.Thickness * 0.1
   -- Create  object used to pass pocketing options
    local pocket_data = PocketParameterData()
          -- start depth for toolpath
          pocket_data.StartDepth = start_depth
          -- cut depth for toolpath this is depth below start depth
          pocket_data.CutDepth = cut_depth
          -- direction of cut for offet clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
          pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
          -- Allowance to leave on when machining
          pocket_data.Allowance = 0.0
          -- if true use raster clearance strategy , else use offset area clearance
          pocket_data.DoRasterClearance = false --true
          -- angle for raster if using raster clearance
          pocket_data.RasterAngle = 0
          -- type of profile pass to perform  PocketParameterData.PROFILE_NONE , PocketParameterData.PROFILE_FIRST orPocketParameterData.PROFILE_LAST
          pocket_data.ProfilePassType = PocketParameterData.PROFILE_LAST
          -- if true we ramp into pockets (always zig-zag)
          pocket_data.DoRamping = false
          --  if ramping, distance to ramp over
          pocket_data.RampDistance = 1.0
          -- if true in Aspire, project toolpath onto composite model
          pocket_data.ProjectToolpath = false
   -- Create object which can used to automatically select geometry on layers etc
    local geometry_selector = GeometrySelector()
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local create_2d_previews = true
   -- if this is true we will display errors and warning to the user
    local display_warnings = false -- true
   -- if we are doing two tool pocketing define tool to use for area clearance
    local area_clear_tool = nil
    if type(Milling.MillTool3) == "userdata" then
   -- we just create a tool twice as large for testing here
   local jim = Milling.MillTool3
    area_clear_tool = Tool(
                          Milling.MillTool3.Name,
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )
     area_clear_tool.InMM         = Milling.MillTool3.InMM       -- tool_in_mm
     area_clear_tool.ToolDia      = Milling.MillTool3.ToolDia    -- tool_dia * 2
     area_clear_tool.Stepdown     = Milling.MillTool3.Stepdown   -- tool_stepdown * 2
     area_clear_tool.Stepover     = Milling.MillTool3.Stepover   -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits    = Milling.MillTool3.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate     = Milling.MillTool3.FeedRate      -- 30
     area_clear_tool.PlungeRate   = Milling.MillTool3.PlungeRate    -- 10
     area_clear_tool.SpindleSpeed = Milling.MillTool3.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber   = Milling.MillTool3.ToolNumber    -- 1
    end
     -- area_clear_tool.VBitAngle     = Carrier.MillTool3.VBitAngle      -- 90.0 -- used for vbit only
     -- area_clear_tool.ClearStepover = Carrier.MillTool3.ClearStepover  -- tool_dia * 2 * (tool_stepover_percent / 100)  -- used for vbit only
   -- Create our toolpath
    local toolpath_manager = ToolpathManager()
    local toolpath_id = toolpath_manager:CreatePocketingToolpath(
                                              name,
                                              tool,
                                              area_clear_tool,
                                              pocket_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
    if toolpath_id  == nil  then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
  end
  return true
end
-- ====================================================]]
function CreateLayerDrillingToolpath(layer_name, name, start_depth, cut_depth, retract_gap)
  if Milling.Drilling then
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No Drilling layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed Drilling vectors found on layer " .. layer_name)
      return false
    end
     -- Create tool we will use to machine vectors
      local tool = Tool(Milling.MillTool4.Name, Tool.THROUGH_DRILL)       -- BALL_NOSE, END_MILL, VBIT, THROUGH_DRILL

      tool.InMM = Milling.MillTool4.InMM -- tool_in_mm
      tool.ToolDia = Milling.MillTool4.ToolDia -- tool_dia
      tool.Stepdown = Milling.MillTool4.Stepdown -- tool_stepdown
      tool.Stepover = Milling.MillTool4.ToolDia * 0.25
      tool.RateUnits = Milling.MillTool4.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
      tool.FeedRate = Milling.MillTool4.FeedRate  -- 30
      tool.PlungeRate = Milling.MillTool4.PlungeRate   -- 10
      tool.SpindleSpeed = Milling.MillTool4.SpindleSpeed    -- 20000
      tool.ToolNumber = Milling.MillTool4.ToolNumber       -- 1
  --    tool.VBitAngle = 90.0                -- used for vbit only
  --    tool.ClearStepover = tool_dia * 0.5  -- used for vbit only
      -- we will set home position and safe z relative to material block size
      local mtl_block = MaterialBlock()
      local mtl_box = mtl_block.MaterialBox
      local mtl_box_blc = mtl_box.BLC
      -- Create object used to set home position and safez gap above material surface
      local pos_data = ToolpathPosData()
      pos_data:SetHomePosition(mtl_box_blc.x, mtl_box_blc.y, mtl_box.TRC.z + (mtl_block.Thickness * 0.2) )
      pos_data.SafeZGap = mtl_block.Thickness * 0.1
      -- Create  object used to pass drilling options
      local drill_data = DrillParameterData()
      -- start depth for toolpath
      drill_data.StartDepth = start_depth
      -- cut depth for toolpath this is depth below start depth
      drill_data.CutDepth = cut_depth
      -- if true perform peck drilling
      drill_data.DoPeckDrill = retract_gap > 0.0
      -- distance to retract above surface when peck drilling
      drill_data.PeckRetractGap = retract_gap
      -- if true in Aspire, project toolpath onto composite model
      drill_data.ProjectToolpath = false
      -- Create object which can used to automatically select geometry on layers etc
      local geometry_selector = GeometrySelector()
      -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
      local create_2d_previews = true
      -- if this is true we will display errors and warning to the user
      local display_warnings = false -- = true
      -- Create our toolpath
      local toolpath_manager = ToolpathManager()
      local toolpath_id = toolpath_manager:CreateDrillingToolpath(
                                              name,
                                              tool,
                                              drill_data,
                                              pos_data,
                                              geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
      if toolpath_id  == nil  then
        DisplayMessageBox("Error creating toolpath")
        return false
      end
     end

   return true

end
-- ====================================================]]
function CreateLayerProfileToolpath(layer_name, name, start_depth, cut_depth, InOrOut, UseTab)
  if Milling.Profile then
  --  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
    local selection = Milling.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Milling.job.LayerManager:FindLayerWithName(layer_name)
    if layer == nil then
      DisplayMessageBox("No layer found with name = " .. layer_name)
      return false
    end
  -- select all closed vectors on the layer
    if not SelectVectorsOnLayer(layer, selection, true, false, true) then
      DisplayMessageBox("No closed vectors found on layer " .. layer_name)
      return false
    end
  -- Create tool we will use to machine vectors
    local tool               = Tool(Milling.MillTool1.Name, Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
          tool.InMM          = Milling.MillTool1.InMM         -- tool_in_mm
          tool.ToolDia       = Milling.MillTool1.ToolDia      -- tool_dia
          tool.Stepdown      = Milling.MillTool1.Stepdown     -- tool_stepdown
          tool.Stepover      = Milling.MillTool1.Stepover     -- tool_dia * 0.25
          tool.RateUnits     = Milling.MillTool1.RateUnits    -- Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
          tool.FeedRate      = Milling.MillTool1.FeedRate     -- 30
          tool.PlungeRate    = Milling.MillTool1.PlungeRate   -- 10
          tool.SpindleSpeed  = Milling.MillTool1.SpindleSpeed -- 20000
          tool.ToolNumber    = Milling.MillTool1.ToolNumber   -- 1
       -- tool.VBitAngle     = Carrier.MillTool.VBitAngle     -- 90.0 -- used for vbit only
       -- tool.ClearStepover = tool_dia * 0.5                 -- used for vbit only
  -- Create object used to set home position and safez gap above material surface
    local pos_data = ToolpathPosData()
          pos_data:SetHomePosition(0, 0, 5.0)
          pos_data.SafeZGap    = 5.0
  -- Create object used to pass profile options
    local profile_data = ProfileParameterData()
  -- start depth for toolpath
    profile_data.StartDepth    = start_depth
    profile_data.CutDepth      = cut_depth -- cut depth for toolpath this is depth below start depth
    profile_data.CutDirection  = ProfileParameterData.CLIMB_DIRECTION -- direction of cut - ProfileParameterData. CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
    if InOrOut == "IN" then
      profile_data.ProfileSide = ProfileParameterData.PROFILE_INSIDE
    elseif InOrOut == "OUT" then
      profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE
    else  -- InOrOut == "ON"
      profile_data.ProfileSide = ProfileParameterData.PROFILE_ON
    end
    profile_data.Allowance = 0.0 -- Allowance to leave on when machining
    profile_data.KeepStartPoints = false -- true to preserve start point positions, false to reorder start points to minimise toolpath length
    profile_data.CreateSquareCorners = false -- true if want to create 'square' external corners on toolpath
    profile_data.CornerSharpen = false -- true to perform corner sharpening on internal corners (only with v-bits)
    profile_data.UseTabs = UseTab -- true to use tabs (position of tabs must already have been defined on vectors)
    profile_data.TabLength = 0.5 -- length for tabs if being used
    profile_data.TabThickness = 0.25
    profile_data.Use3dTabs = true -- if true then create 3d tabs else 2d tabs
    profile_data.ProjectToolpath = false -- if true in Aspire, project toolpath onto composite model
    local ramping_data = RampingData() -- Create object used to control ramping
    local lead_in_out_data = LeadInOutData()
    ramping_data.DoRamping = false -- if true we do ramping into toolpath
    ramping_data.RampType = RampingData.RAMP_ZIG_ZAG -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG or RampingData.RAMP_SPIRAL
    ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE or RampingData.CONSTRAIN_ANGLE
    ramping_data.RampDistance = 100.0 -- if we are constraining ramp by distance, distance to ramp over
    ramping_data.RampAngle = 25.0 -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
    ramping_data.RampMaxAngleDist = 15 -- if we are contraining ramp by angle, max distance to travel before 'zig zaging' if zig zaging
    ramping_data.RampOnLeadIn = false -- if true we restrict our ramping to lead in section of toolpath
    lead_in_out_data.DoLeadIn = false -- if true we create lead ins on profiles (not for profile on)
    lead_in_out_data.DoLeadOut = false -- if true we create lead outs on profiles (not for profile on)
    lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
    lead_in_out_data.LeadLength = 5.0 -- length of lead to create
    lead_in_out_data.LinearLeadAngle = 45 -- Angle for linear leads
    lead_in_out_data.CirularLeadRadius = 5.0 -- Radius for circular arc leads
    lead_in_out_data.OvercutDistance = 0.0 -- distance to 'overcut' (travel past start point) when profiling
    local geometry_selector = GeometrySelector() -- Create object which can be used to automatically select geometry
    local create_2d_previews = true -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
    local display_warnings =  false --true -- if this is true we will display errors and warning to the user
    local toolpath_manager = ToolpathManager() -- Create our toolpath
    local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data,
                        ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating toolpath")
      return false
    end
  end
  return true
end
-- ====================================================]]
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
  -- Please Note: SelectVectorsOnLayer is provided by Vectric and can be found in the SDK and Sample Gadget files.
  --[[  ---------------- SelectVectorsOnLayer ----------------
  -- |   SelectVectorsOnLayer("Stringer Profile", selection, true, falus, falus)
  -- |   Add all the vectors on the layer to the selection
  -- |     layer,            -- layer we are selecting vectors on
  -- |     selection         -- selection object
  -- |     select_closed     -- if true  select closed objects
  -- |     select_open       -- if true  select open objects
  -- |     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
  -- |  Return Values:
  -- |     true if selected one or more vectors|
  --]]
  local objects_selected = false
  local warning_displayed = false
  local pos = layer:GetHeadPosition()
  while pos ~= nil do
    local object
    object, pos = layer:GetNext(pos)
    local contour = object:GetContour()
    if contour == nil then
      if (object.ClassName == "vcCadObjectGroup") and select_groups then
        selection:Add(object, true, true)
        objects_selected = true
      else
        if not warning_displayed then
          local message = "Object(s) without contour information found on layer - ignoring"
          if not select_groups then
            message = message ..  "\r\n\r\n" ..
            "If layer contains grouped vectors these must be ungrouped for this script"
          end -- if end
          DisplayMessageBox(message)
          warning_displayed = true
        end -- if end
      end -- if end
    else  -- contour was NOT nil, test if Open or Closed
      if contour.IsOpen and select_open then
        selection:Add(object, true, true)
        objects_selected = true
      elseif select_closed then
        selection:Add(object, true, true)
        objects_selected = true
      end -- if end
    end -- if end
  end -- while end
  -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
  -- tell selection we have now finished updating
  if objects_selected then
    selection:GroupSelectionFinished()
  end -- if end
  return objects_selected
end -- function end
-- ====================================================]]
function REG_UpdateRegistry() --  Write to Registry values
local RW = Registry(RegName)
local
RegValue = RW:SetBool("BaseQuestion.AddCenterFaceFrame",  BaseQuestion.AddCenterFaceFrame)
RegValue = RW:SetBool("BaseQuestion.AddCenterPanel",  BaseQuestion.AddCenterPanel)
RegValue = RW:SetBool("WallQuestion.AddCenterFaceFrame",  WallQuestion.AddCenterFaceFrame)
RegValue = RW:SetBool("WallQuestion.AddCenterPanel",  WallQuestion.AddCenterPanel)
RegValue = RW:SetBool("WallQuestion.DadoBackPanelForCenterPanel",  WallQuestion.DadoBackPanelForCenterPanel)
RegValue = RW:SetDouble("BaseDim.CabDepth",   BaseDim.CabDepth)
RegValue = RW:SetDouble("BaseDim.CabHeight",  BaseDim.CabHeight)
RegValue = RW:SetDouble("BaseDim.CabLength",                 BaseDim.CabLength)
RegValue = RW:SetDouble("BaseDim.FaceFrameBottomRailWidth",  BaseDim.FaceFrameBottomRailWidth)
RegValue = RW:SetDouble("BaseDim.FaceFrameBottomReveal",     BaseDim.FaceFrameBottomReveal)
RegValue = RW:SetDouble("BaseDim.FaceFrameCenterStileWidth", BaseDim.FaceFrameCenterStileWidth)
RegValue = RW:SetDouble("BaseDim.FaceFrameDrawerHeight1", BaseDim.FaceFrameDrawerHeight1)
RegValue = RW:SetDouble("BaseDim.FaceFrameDrawerHeight2", BaseDim.FaceFrameDrawerHeight2)
RegValue = RW:SetDouble("BaseDim.FaceFrameDrawerHeight3", BaseDim.FaceFrameDrawerHeight3)
RegValue = RW:SetDouble("BaseDim.FaceFrameMidRailWidth", BaseDim.FaceFrameMidRailWidth)
RegValue = RW:SetDouble("BaseDim.FaceFrameSideReveal", BaseDim.FaceFrameSideReveal)
RegValue = RW:SetDouble("BaseDim.FaceFrameStileWidth", BaseDim.FaceFrameStileWidth)
RegValue = RW:SetDouble("BaseDim.FaceFrameThickness", BaseDim.FaceFrameThickness)
RegValue = RW:SetDouble("BaseDim.FaceFrameTopOverlap",  BaseDim.FaceFrameTopOverlap)
RegValue = RW:SetDouble("BaseDim.FaceFrameTopRailWidth",  BaseDim.FaceFrameTopRailWidth)
RegValue = RW:SetDouble("BaseDim.MaterialThickness",  BaseDim.MaterialThickness)
RegValue = RW:SetDouble("BaseDim.ShelfEndClarence",  BaseDim.ShelfEndClarence)
RegValue = RW:SetDouble("BaseDim.ShelfFaceFrameThickness",  BaseDim.ShelfFaceFrameThickness)
RegValue = RW:SetDouble("BaseDim.ShelfFaceFrameWidth",  BaseDim.ShelfFaceFrameWidth)
RegValue = RW:SetDouble("BaseDim.ShelfFrontClearance",  BaseDim.ShelfFrontClearance)
RegValue = RW:SetDouble("BaseDim.ShelfHoleFirstRowSpacing",  BaseDim.ShelfHoleFirstRowSpacing)
RegValue = RW:SetDouble("BaseDim.ShelfHoleLastRowSpacing",  BaseDim.ShelfHoleLastRowSpacing)
RegValue = RW:SetDouble("BaseDim.ShelfHoleSpacing",  BaseDim.ShelfHoleSpacing)
RegValue = RW:SetDouble("BaseDim.ShelfMaterialThickness",  BaseDim.ShelfMaterialThickness)
RegValue = RW:SetDouble("BaseDim.ShelfPinHoleBack",  BaseDim.ShelfPinHoleBack)
RegValue = RW:SetDouble("BaseDim.ShelfPinHoleFront",  BaseDim.ShelfPinHoleFront)
RegValue = RW:SetDouble("BaseDim.StretcherThickness",  BaseDim.StretcherThickness)
RegValue = RW:SetDouble("BaseDim.StretcherWidth",  BaseDim.StretcherWidth)
RegValue = RW:SetDouble("BaseDim.ThicknessBack",  BaseDim.ThicknessBack)
RegValue = RW:SetDouble("BaseDim.ToeKickBottomOffsetHeight",  BaseDim.ToeKickBottomOffsetHeight)
RegValue = RW:SetDouble("BaseDim.ToeKickCoverHeight",   BaseDim.ToeKickCoverHeight)
RegValue = RW:SetDouble("BaseDim.ToeKickDepth",  BaseDim.ToeKickDepth)
RegValue = RW:SetDouble("BaseDim.ToeKickHeight",  BaseDim.ToeKickHeight)
RegValue = RW:SetDouble("BaseDim.TopFrameWidth",  BaseDim.TopFrameWidth)
RegValue = RW:SetDouble("Milling.DadoClearance",  Milling.DadoClearance)
RegValue = RW:SetDouble("Milling.DadoHeight",  Milling.DadoHeight)
RegValue = RW:SetDouble("Milling.PartGap",  Milling.PartGap)
RegValue = RW:SetDouble("Milling.ProfileToolDia",  Milling.ProfileToolDia)
RegValue = RW:SetDouble("Milling.ProfileToolRadius",  Milling.ProfileToolRadius)
RegValue = RW:SetDouble("Milling.RabbitClearance",  Milling.RabbitClearance)
RegValue = RW:SetDouble("Milling.ShelfPinDiameter",  Milling.ShelfPinDiameter)
RegValue = RW:SetDouble("Milling.ShelfPinLen",  Milling.ShelfPinLen)
RegValue = RW:SetDouble("Milling.ShelfPinRadius",  Milling.ShelfPinRadius)
RegValue = RW:SetDouble("WallDim.BackPanelLength",  WallDim.BackPanelLength)
RegValue = RW:SetDouble("WallDim.BackPanelWidth",  WallDim.BackPanelWidth)
RegValue = RW:SetDouble("WallDim.CabDepth",  WallDim.CabDepth)
RegValue = RW:SetDouble("WallDim.CabHeight",  WallDim.CabHeight)
RegValue = RW:SetDouble("WallDim.CabLength",  WallDim.CabLength)
RegValue = RW:SetDouble("WallDim.CenterPanelLength",  WallDim.CenterPanelLength)
RegValue = RW:SetDouble("WallDim.CenterPanelWidth",  WallDim.CenterPanelWidth)
RegValue = RW:SetDouble("WallDim.FaceFrameBottomRailWidth",  WallDim.FaceFrameBottomRailWidth)
RegValue = RW:SetDouble("WallDim.FaceFrameBottomReveal",  WallDim.FaceFrameBottomReveal)
RegValue = RW:SetDouble("WallDim.FaceFrameCenterStileWidth",  WallDim.FaceFrameCenterStileWidth)
RegValue = RW:SetDouble("WallDim.FaceFrameRailLength",  WallDim.FaceFrameRailLength)
RegValue = RW:SetDouble("WallDim.FaceFrameSideReveal",  WallDim.FaceFrameSideReveal)
RegValue = RW:SetDouble("WallDim.FaceFrameStileLength",  WallDim.FaceFrameStileLength)
RegValue = RW:SetDouble("WallDim.FaceFrameStileWidth",  WallDim.FaceFrameStileWidth)
RegValue = RW:SetDouble("WallDim.FaceFrameThickness",  WallDim.FaceFrameThickness)
RegValue = RW:SetDouble("WallDim.FaceFrameTopOverlap",  WallDim.FaceFrameTopOverlap)
RegValue = RW:SetDouble("WallDim.FaceFrameTopRailWidth",  WallDim.FaceFrameTopRailWidth)
RegValue = RW:SetDouble("WallDim.FaceFrameTopReveal",  WallDim.FaceFrameTopReveal)
RegValue = RW:SetDouble("WallDim.MaterialThickness",  WallDim.MaterialThickness)
RegValue = RW:SetDouble("WallDim.ShelfEndClarence",  WallDim.ShelfEndClarence)
RegValue = RW:SetDouble("WallDim.ShelfFaceFrameThickness",  WallDim.ShelfFaceFrameThickness)
RegValue = RW:SetDouble("WallDim.ShelfFaceFrameWidth",  WallDim.ShelfFaceFrameWidth)
RegValue = RW:SetDouble("WallDim.ShelfFrontClearance",  WallDim.ShelfFrontClearance)
RegValue = RW:SetDouble("WallDim.ShelfHoleFirstRowSpacing",  WallDim.ShelfHoleFirstRowSpacing)
RegValue = RW:SetDouble("WallDim.ShelfHoleLastRowSpacing",  WallDim.ShelfHoleLastRowSpacing)
RegValue = RW:SetDouble("WallDim.ShelfHoleSpacing",  WallDim.ShelfHoleSpacing)
RegValue = RW:SetDouble("WallDim.ShelfLength",  WallDim.ShelfLength)
RegValue = RW:SetDouble("WallDim.ShelfMaterialThickness",  WallDim.ShelfMaterialThickness)
RegValue = RW:SetDouble("WallDim.ShelfNoseLength",  WallDim.ShelfNoseLength)
RegValue = RW:SetDouble("WallDim.ShelfPinHoleBack",  WallDim.ShelfPinHoleBack)
RegValue = RW:SetDouble("WallDim.ShelfPinHoleFront",  WallDim.ShelfPinHoleFront)
RegValue = RW:SetDouble("WallDim.ShelfWidth",  WallDim.ShelfWidth)
RegValue = RW:SetDouble("WallDim.SidePanelLength",  WallDim.SidePanelLength)
RegValue = RW:SetDouble("WallDim.SidePanelWidth",  WallDim.SidePanelWidth)
RegValue = RW:SetDouble("WallDim.ThicknessBack",  WallDim.ThicknessBack)
RegValue = RW:SetDouble("WallDim.TopBottomPanelLength",  WallDim.TopBottomPanelLength)
RegValue = RW:SetDouble("WallDim.TopBottomPanelWidth",  WallDim.TopBottomPanelWidth)
RegValue = RW:SetInt("BaseQuestion.DrawerRowCount",  BaseQuestion.DrawerRowCount)
RegValue = RW:SetInt("BaseQuestion.ShelfCount",  BaseQuestion.ShelfCount)
RegValue = RW:SetInt("WallQuestion.ShelfCount",  WallQuestion.ShelfCount)
RegValue = RW:SetString("BaseQuestion.DadoStyle",  BaseQuestion.DadoStyle)
RegValue = RW:SetString("DialogWindow.AboutXY",  DialogWindow.AboutXY)
RegValue = RW:SetString("DialogWindow.InquiryWallOrBaseXY",  DialogWindow.InquiryWallOrBaseXY)
RegValue = RW:SetString("DialogWindow.LayerXY",  DialogWindow.LayerXY)
RegValue = RW:SetString("DialogWindow.MillingXY",  DialogWindow.MillingXY)
RegValue = RW:SetString("DialogWindow.ProjectXY",  DialogWindow.ProjectXY)
RegValue = RW:SetString("DialogWindow.WallCabinetXY",  DialogWindow.WallCabinetXY)
RegValue = RW:SetString("Milling.LNBackPocket",  Milling.LNBackPocket)
RegValue = RW:SetString("Milling.LNBackProfile",  Milling.LNBackProfile)
RegValue = RW:SetString("Milling.LNCenterPanelProfile",  Milling.LNCenterPanelProfile)
RegValue = RW:SetString("Milling.LNCenterPanelShelfPinDrill",  Milling.LNCenterPanelShelfPinDrill)
RegValue = RW:SetString("Milling.LNDrawFaceFrame",  Milling.LNDrawFaceFrame)
RegValue = RW:SetString("Milling.LNDrawNotes",  Milling.LNDrawNotes)
RegValue = RW:SetString("Milling.LNPartLabels",  Milling.LNPartLabels)
RegValue = RW:SetString("Milling.LNShelfProfile",  Milling.LNShelfProfile)
RegValue = RW:SetString("Milling.LNSidePocket",  Milling.LNSidePocket)
RegValue = RW:SetString("Milling.LNSideProfile",  Milling.LNSideProfile)
RegValue = RW:SetString("Milling.LNSideShelfPinDrill",  Milling.LNSideShelfPinDrill)
RegValue = RW:SetString("Milling.LNStretcherRailProfile",  Milling.LNStretcherRailProfile)
RegValue = RW:SetString("Milling.LNTopBottomPocket",  Milling.LNTopBottomPocket)
RegValue = RW:SetString("Milling.LNTopBottomProfile",  Milling.LNTopBottomProfile)

RegValue = RW:SetString("Milling.LNBackPocketColor",                Milling.LNBackPocketColor)
RegValue = RW:SetString("Milling.LNBackProfileColor",               Milling.LNBackProfileColor)
RegValue = RW:SetString("Milling.LNCenterPanelProfileColor",        Milling.LNCenterPanelProfileColor)
RegValue = RW:SetString("Milling.LNCenterPanelShelfPinDrillColor",  Milling.LNCenterPanelShelfPinDrillColor)
RegValue = RW:SetString("Milling.LNDrawFaceFrameColor",             Milling.LNDrawFaceFrameColor)
RegValue = RW:SetString("Milling.LNDrawNotesColor",                 Milling.LNDrawNotesColor)
RegValue = RW:SetString("Milling.LNPartLabelsColor",                Milling.LNPartLabelsColor)
RegValue = RW:SetString("Milling.LNShelfProfileColor",              Milling.LNShelfProfileColor)
RegValue = RW:SetString("Milling.LNSidePocketColor",                Milling.LNSidePocketColor)
RegValue = RW:SetString("Milling.LNSideProfileColor",               Milling.LNSideProfileColor)
RegValue = RW:SetString("Milling.LNSideShelfPinDrillColor",         Milling.LNSideShelfPinDrillColor)
RegValue = RW:SetString("Milling.LNStretcherRailProfileColor",      Milling.LNStretcherRailProfileColor)
RegValue = RW:SetString("Milling.LNTopBottomPocketColor",           Milling.LNTopBottomPocketColor)
RegValue = RW:SetString("Milling.LNTopBottomProfileColor",          Milling.LNTopBottomProfileColor)

RegValue = RW:SetString("Project.CabinetName",  Project.CabinetName)
RegValue = RW:SetString("Project.Drawing",  Project.Drawing )
RegValue = RW:SetString("Project.ProgramCodeBy",  Project.ProgramCodeBy)
RegValue = RW:SetString("Project.ProgramName",  Project.ProgramName)
RegValue = RW:SetString("Project.ProgramVersion",  Project.ProgramVersion)
RegValue = RW:SetString("Project.ProgramYear",  Project.ProgramYear)
RegValue = RW:SetString("Project.ProjectContactEmail",  Project.ProjectContactEmail)
RegValue = RW:SetString("Project.ProjectContactName",  Project.ProjectContactName)
RegValue = RW:SetString("Project.ProjectContactPhoneNumber",  Project.ProjectContactPhoneNumber)
RegValue = RW:SetString("Project.ProjectName",  Project.ProjectName)
RegValue = RW:SetString("Project.ProjectName",  string.upper(Project.ProjectName))
RegValue = RW:SetString("Project.ProjectPath",  Project.ProjectPath)
RegValue = RW:SetString("WallQuestion.DadoStyle",  WallQuestion.DadoStyle)
RegValue = RW:SetString("DialogWindow.BaseCabinetXY",  DialogWindow.BaseCabinetXY)
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
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end
-- ====================================================]]
function NewSheet()
  local layer_manager = Milling.job.LayerManager
  --  get current sheet count - note sheet 0 the default sheet counts as one sheet
  -- local orig_num_sheets = layer_manager.NumberOfSheets
  --  get current active sheet index
  -- local orig_active_sheet_index = layer_manager.ActiveSheetIndex
  --  set active sheet to last sheet
  local num_sheets = layer_manager.NumberOfSheets
  layer_manager.ActiveSheetIndex = num_sheets - 1
  Milling.job:Refresh2DView()
  --  Add a new sheet
  layer_manager:AddNewSheet()
  --  set active sheet to last sheet we just added
  num_sheets = layer_manager.NumberOfSheets
  layer_manager.ActiveSheetIndex = num_sheets - 1
  Milling.job:Refresh2DView()
end
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
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",     Tool.END_MILL)



--  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", g_default_tool_name)
--  dialog:AddToolPickerValidToolType("ToolChooseButton1",     Tool.END_MILL)


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
    REG_UpdateRegistry()
    return string.upper(dialog:GetDropDownListValue("ListBox"))
  end
end
-- ====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 720, 487, "About")
  dialog:AddLabelField("SysName", AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  REG_UpdateRegistry()
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
    REG_UpdateRegistry()
  end
  Base_Math()
  REG_UpdateRegistry()
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
    REG_UpdateRegistry()
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
    REG_UpdateRegistry()
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
    REG_UpdateRegistry()
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
    REG_UpdateRegistry()
  end
  return  true
end
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
function Wall_CabinetSide(side)
 -- local line = Contour(0.0)
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
-- ====================================================]]
  if side  ==  "L" then --  L side
    pt1Text = Polar2D(Cab.Wpt1, 45,  1.5)
    pt2 = Polar2D(Cab.Wpt1, 0.0, WallDim.CabHeight)
    pt3 = Polar2D(pt2,  90.0, WallDim.CabDepth)
    pt4 = Polar2D(pt3,  180.0, WallDim.CabHeight)
    ptA = Polar2D(Cab.Wpt1, 270.0, Milling.ProfileToolRadius)
    ptB = Polar2D(ptA,  0.0, WallDim.MaterialThickness)
    ptL = Polar2D(pt2,  270.0, Milling.ProfileToolRadius)
    ptK = Polar2D(ptL, 180.0, WallDim.MaterialThickness)
    ptG = Polar2D(pt3, 0.0, Milling.ProfileToolRadius)
    ptH = Polar2D(ptG, 270.0, WallDim.ThicknessBack)
    ptI = Polar2D(pt3, 90.0, Milling.ProfileToolRadius)
    ptJ = Polar2D(ptI, 180.0, WallDim.MaterialThickness)
    ptD = Polar2D(pt4, 90.0, Milling.ProfileToolRadius)
    ptC = Polar2D(ptD,  0.0, WallDim.MaterialThickness)
    ptE = Polar2D(pt4,  180.0, Milling.ProfileToolRadius)
    ptF = Polar2D(ptE,  270.0, WallDim.ThicknessBack)
    ptA = Polar2D(ptA, 180.0, Milling.RabbitClearance)
    ptL = Polar2D(ptL,  0.0, Milling.RabbitClearance)
    ptG = Polar2D(ptG, 90.0, Milling.RabbitClearance)
    ptI = Polar2D(ptI,  0.0, Milling.RabbitClearance)
    ptE = Polar2D(ptE,  90.0, Milling.RabbitClearance)
    ptD = Polar2D(ptD,  180.0, Milling.RabbitClearance)
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
-- ====================================================]]
    ptx = Cab.Wpt2
    anx = 0
    ptx = Polar2D(Polar2D(Cab.Wpt2, 0.0, (WallDim.ShelfHoleFirstRowSpacing + WallDim.MaterialThickness)), 90, ((WallDim.CabDepth - WallDim.ThicknessBack) * WallDim.ShelfPinHoleBack))
    anx = 90
-- ====================================================]]
  else  --  R side
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
function CutListfileWriterHeader(Cab)
  local file = io.open(Project.ProjectPath .. "\\" .. Project.CabinetName .. "-".. Project.DrawerID.. ".dat", "w")
  file:write("=============================================================================================== \n")
  file:write("====================================  Cabinet Cut-list  ======================================= \n")
  file:write("  Run Date = ".. StartDate() .."\n")
  file:write("  Cabinet Style = ".. Project.ProgramName .."\n")
  file:write("=============================================================================================== \n")
  if Cab == "BOTH" then
    file:write("  Base Cabinet size\n")
    file:write("  Cabinet Height = ".. BaseDim.CabHeight .."\n")
    file:write("  Cabinet Length = ".. BaseDim.CabLength .."\n")
    file:write("  Cabinet Depth  = ".. BaseDim.CabDepth .."\n")
    file:write("  Face Frame Diagonal = ".. math.sqrt ((BaseDim.CabHeight * BaseDim.CabHeight)+ (BaseDim.CabLength * BaseDim.CabLength)) .."\n")
    file:write("=============================================================================================== \n")
    file:write("  Wall Cabinet size\n")
    file:write("  Cabinet Height = ".. WallDim.CabHeight .."\n")
    file:write("  Cabinet Length = ".. WallDim.CabLength .."\n")
    file:write("  Cabinet Depth  = ".. WallDim.CabDepth .."\n")
    file:write("  Face Frame Diagonal = ".. math.sqrt ((WallDim.CabHeight * WallDim.CabHeight)+ (WallDim.CabLength * WallDim.CabLength)) .."\n")
  elseif Cab == "WALL" then
    file:write("  Wall Cabinet size\n")
    file:write("  Cabinet Height = ".. WallDim.CabHeight .."\n")
    file:write("  Cabinet Length = ".. WallDim.CabLength .."\n")
    file:write("  Cabinet Depth  = ".. WallDim.CabDepth .."\n")
    file:write("  Face Frame Diagonal = ".. math.sqrt ((WallDim.CabHeight * WallDim.CabHeight)+ (WallDim.CabLength * WallDim.CabLength)) .."\n")
  else
    file:write("  Base Cabinet size\n")
    file:write("  Cabinet Height = ".. BaseDim.CabHeight .."\n")
    file:write("  Cabinet Length = ".. BaseDim.CabLength .."\n")
    file:write("  Cabinet Depth  = ".. BaseDim.CabDepth .."\n")
    file:write("  Face Frame Diagonal = ".. math.sqrt ((BaseDim.CabHeight * BaseDim.CabHeight)+ (BaseDim.CabLength * BaseDim.CabLength)) .."\n")
  end -- if Both
  file:write("=============================================================================================== \n")
  file:write(" ID  | Part Name                       |Count| Thickness | Material        | Width   | Length\n")
  file:write("=============================================================================================== \n")
  file:close()
  file = io.open(Project.ProjectPath .. "\\" .. Project.CabinetName .."-".. Project.DrawerID..  ".csv", "w")
  file:write("ID, Name, Count, Thick, Material, Width, Length\n")
  file:close()
end
-- ====================================================]]
function CutListfileWriterItem(ID, Name, Count, Thick, Material, Width, Length)
  local file = io.open(Project.ProjectPath .. "\\" .. Project.CabinetName .. "-".. Project.DrawerID.. ".dat", "a")
  local sID = " " .. ID .. " "
  local sName     = string.sub("| ".. Name .. "                                     ",1, 34)
  local sCount    = string.sub("| ".. Count .."                                     ",1, 6)
  local sThick    = string.sub("| ".. Thick .."                                     ",1, 12)
  local sMaterial = string.sub("| ".. Material .."                                  ",1, 18)
  local sWidth    = string.sub("| ".. Width .."                                     ",1, 10)
  local sLength   = string.sub("| ".. Length .."                                    ",1, 9)
  file:write(sID .. sName .. sCount .. sThick .. sMaterial .. sWidth .. sLength .. "\n")
  file:close()
  file = io.open(Project.ProjectPath .. "\\" .. Project.CabinetName ..  "-".. Project.DrawerID.. ".csv", "a")
  file:write(ID .. "," .. Name .. "," .. Count .. "," .. Thick .. "," .. Material .. "," .. Width .. "," .. Length  .. "  \n")
  file:close()
end
-- ====================================================]]
function CutListfileWriterFooter()
  local file = io.open(Project.ProjectPath .. "\\" .. Project.CabinetName .. "-".. Project.DrawerID.. ".dat", "a")
  file:write("=============================================================================================== \n")
  file:write("EOF \n")
  file:close()
  file = io.open(Project.ProjectPath .. "\\" .. Project.CabinetName ..  "-".. Project.DrawerID.. ".csv", "a")
  file:write("\n")
  file:write("\n")file:write("\n")
  file:write("\n")
  file:write("\n")
  file:write("\n")
  file:write("\n")
  file:write("[SETTINGS]\n")
  file:close()
end
-- ====================================================]]
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
-- ====================================================]]
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
      CutListfileWriterItem("450", "Center Face Frame", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameCenterStileWidth, GetDistance(A2, D2) )
      pt1Text = Polar2D(A2, 85,  8.75 )
      DrawWriter("Part ID: 450", pt1Text, 0.40, Milling.LNPartLabels,  90.0)
      Dist = ((BaseDim.CabLength * 0.5) - (BaseDim.FaceFrameStileWidth + (BaseDim.FaceFrameCenterStileWidth * 0.5) ))
      local B2 = Polar2D(A2,  90, Dist)
      local B2a = Polar2D(B2, 180, DrawerHeight)
      local C2 = Polar2D(D2, 270, Dist)
      local C2a = Polar2D(C2, 180, DrawerHeight)
      if BaseQuestion.AddCenterFaceFrame then
        DrawBox(B2, B2a, C2a, C2, Milling.LNDrawFaceFrame .. "-Base")
        CutListfileWriterItem("460", "Center Face Frame", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameTopRailWidth, DrawerHeight)
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
    CutListfileWriterItem("470", "Center Face Frame", "1", BaseDim.FaceFrameThickness, "Hardwood", BaseDim.FaceFrameCenterStileWidth, GetDistance(A3, B3) )
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
-- ====================================================]]
function MarkPoint(Note, Pt, Size, LayerName)
  --[[
     | Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
     | Draws mark on the drawing
     | call = MarkPoint("Note: Hi", Pt1, 3, "Jim")
   ]]
      local layer = Milling.job.LayerManager:GetLayerWithName(LayerName)
      local marker1 = CadMarker(Note, Pt, Size)
      layer:AddObject(marker1, true)
      DrawCircle(Pt, 0.25, LayerName)
  return true
  end -- function end
-- ====================================================]]
function DrawCircle(Cpt, CircleRadius, LayerName)  -- Draws a circle
  -- | draws a circle based on user inputs
  -- | job - current validated job unique ID
  -- | Cpt - (2Dpoint) center of the circle
  -- | CircleRadius - radius of the circle
  -- | Layer - layer name to draw circle (make layer if not exist)
  local pa = Polar2D(Cpt, 180.0, CircleRadius)
  local pb = Polar2D(Cpt,   0.0, CircleRadius)
  local line = Contour(0.0)
  line:AppendPoint(pa)
  line:ArcTo(pb,1)
  line:ArcTo(pa,1)
  local layer = Milling.job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
  else --  side  ==  "L"
-- ====================================================]]
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
-- ====================================================]]
function Holer(pt, ang, dst, dia, lay)
  local group = ContourGroup(true)
  group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))
  pt = Polar2D(pt, ang, dst)
  group:AddTail(CreateCircle(pt.x,pt.y,dia,0.0,0.0))
  AddGroupToJob(group, lay)
  return true
end  --  function end
-- ====================================================]]
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
-- ====================================================]]
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
-- ====================================================]]
function MakeLayers(What)
  local Red, Green, Blue = 0, 0, 0
  -- What = the Cabinet type ("", Wall, or Bass)
  local function GetColor(str) -- returns color value for a Color Name
    local sx = str
    local Red, Green, Blue = 0
    local Colors = {}
    Colors.Black = "0,0,0"; Colors.Red = "255,0,0"; Colors.Blue = "0,0,255"; Colors.Yellow = "255,255,0"; Colors.Cyan = "0,255,255"; Colors.Magenta = "255,0,255"; Colors.Green = "0,128,0";
    if "" == str then
      DisplayMessageBox("Error: Empty string passed")
    else
      str = Colors[str]
      if "string" == type(str) then
        if string.find(str, ",") then
          Red   = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          str  = string.sub(str, assert(string.find(str, ",") + 1))
          Green = tonumber(string.sub(str, 1, assert(string.find(str, ",") - 1)))
          Blue  = tonumber(string.sub(str, assert(string.find(str, ",") + 1)))
        end
      else
        DisplayMessageBox("Error: Color " .. sx .. " not Found" )
        Red = 0
        Green = 0
        Blue = 0
      end
    end
    return Red, Green, Blue
  end
  if #What > 0 then
    local layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackPocket .. What)
          Red, Green, Blue = GetColor(Milling.LNBackPocketColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNBackProfile .. What)
          Red, Green, Blue = GetColor(Milling.LNBackProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNCenterPanelProfile .. What)
          Red, Green, Blue = GetColor(Milling.LNBackProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNCenterPanelShelfPinDrill .. What)
          Red, Green, Blue = GetColor(Milling.LNCenterPanelProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNDrawFaceFrame .. What)
          Red, Green, Blue = GetColor(Milling.LNDrawFaceFrameColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNShelfProfile .. What)
          Red, Green, Blue = GetColor(Milling.LNShelfProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideProfile .. What)
          Red, Green, Blue = GetColor(Milling.LNSideProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSidePocket .. What)
          Red, Green, Blue = GetColor(Milling.LNSideProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNSideShelfPinDrill .. What)
          Red, Green, Blue = GetColor(Milling.LNSideShelfPinDrillColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNTopBottomProfile .. What)
          Red, Green, Blue = GetColor(Milling.LNTopBottomProfileColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNTopBottomPocket .. What)
          Red, Green, Blue = GetColor(Milling.LNTopBottomPocketColor)
          layer:SetColor (Red, Green, Blue)
          layer = Milling.job.LayerManager:GetLayerWithName(Milling.LNStretcherRailProfile .. What)
          Red, Green, Blue = GetColor(Milling.LNStretcherRailProfileColor)
          layer:SetColor (Red, Green, Blue)
  else -- "" For all Cabinet types
    local layerx = Milling.job.LayerManager:GetLayerWithName(Milling.LNDrawNotes)
          Red, Green, Blue = GetColor(Milling.LNDrawNotesColor)
          layerx:SetColor (Red, Green, Blue)
          layerx = Milling.job.LayerManager:GetLayerWithName(Milling.LNPartLabels)
          Red, Green, Blue = GetColor(Milling.LNPartLabelsColor)
          layerx:SetColor (Red, Green, Blue)
  end -- if end
  return true
end
-- ====================================================]]
function DrawWriter(what, where, size, lay, ang)
--  [[
--  How to use:
--  local TextMessage = "Your Text Here"
--  local TextPt = Point2D(3.5,3.8)
--  local TextHight = 0.5
--  local TextLayer = "Jim Anderson"
--  local TextAng = 20.0
--  DrawWriter(TextMessage, TextPt, TextHight, TextLayer, TextAng )
  local function DrawCADLeters(pt, letter, scl, lay, ang)
    scl = (scl * 0.5)
    local pA0 = pt
    local pA1 = Polar2D(pt, ang + 90.0000, (0.2500 * scl))
    local pA2 = Polar2D(pt, ang + 90.0000, (0.5000 * scl))
    local pA3 = Polar2D(pt, ang + 90.0000, (0.7500 * scl))
    local pA4 = Polar2D(pt, ang + 90.0000, (1.0000 * scl))
    local pA5 = Polar2D(pt, ang + 90.0000, (1.2500 * scl))
    local pA6 = Polar2D(pt, ang + 90.0000, (1.5000 * scl))
    local pA7 = Polar2D(pt, ang + 90.0000, (1.7500 * scl))
    local pA8 = Polar2D(pt, ang + 90.0000, (2.0000 * scl))
    local pB0 = Polar2D(pt, ang +  0.0000, (0.2500 * scl))
    local pB1 = Polar2D(pt, ang + 45.0000, (0.3536 * scl))
    local pB3 = Polar2D(pt, ang + 71.5651, (0.7906 * scl))
    local pB4 = Polar2D(pt, ang + 75.9638, (1.0308 * scl))
    local pB5 = Polar2D(pt, ang + 78.6901, (1.2748 * scl))
    local pB7 = Polar2D(pt, ang + 81.8699, (1.7678 * scl))
    local pB8 = Polar2D(pt, ang + 82.8750, (2.0156 * scl))
    local pB10 = Polar2D(pt, ang + 84.2894, (2.5125 * scl))
    local pC0 = Polar2D(pt, ang +  0.0000, (0.5000 * scl))
    -- local pC2 = Polar2D(pt, ang + 45.0000, (0.7071 * scl))
    local pC8 = Polar2D(pt, ang + 75.9638, (2.0616 * scl))
    local pC10 = Polar2D(pt,78.6901, (2.5125 * scl))
    local pD0 = Polar2D(pt, ang +  0.0000, (0.6250 * scl))
    local pD1 = Polar2D(pt, ang + 21.8014, (0.6731 * scl))
    local pD4 = Polar2D(pt, ang + 57.9946, (1.1792 * scl))
    local pD7 = Polar2D(pt, ang + 70.3462, (1.8583 * scl))
    local pD8 = Polar2D(pt, ang + 72.6460, (2.0954 * scl))
    local pE0 = Polar2D(pt, ang +  0.0000, (0.7500 * scl))
    local pE2 = Polar2D(pt, ang + 33.6901, (0.9014 * scl))
    local pE3 = Polar2D(pt, ang + 45.0000, (1.0607 * scl))
    -- local pE8 = Polar2D(pt, ang + 69.4440, (2.1360 * scl))
    local pF0 = Polar2D(pt, ang +  0.0000, (1.0000 * scl))
    local pF3 = Polar2D(pt, ang + 36.8699, (1.2500 * scl))
    local pF4 = Polar2D(pt, ang + 45.0000, (1.4142 * scl))
    -- local pF7 = Polar2D(pt, ang + 60.2551, (2.0156 * scl))
    local pF8 = Polar2D(pt, ang + 63.4349, (2.2361 * scl))
    -- local pF10 = Polar2D(pt,59.0362, (2.9155 * scl))
    local pG0 = Polar2D(pt, ang +  0.0000, (1.2500 * scl))
    local pG1 = Polar2D(pt, ang + 11.3099, (1.2748 * scl))
    local pG2 = Polar2D(pt, ang + 21.8014, (1.3463 * scl))
    local pG3 = Polar2D(pt, ang + 30.9638, (1.4577 * scl))
    local pG4 = Polar2D(pt, ang + 38.6598, (1.6008 * scl))
    local pG5 = Polar2D(pt, ang + 45.0000, (1.7678 * scl))
    local pG6 = Polar2D(pt, ang + 50.1944, (1.9526 * scl))
    local pG7 = Polar2D(pt, ang + 54.4623, (2.1506 * scl))
    local pG8 = Polar2D(pt, ang + 57.9946, (2.3585 * scl))
    local pH0 = Polar2D(pt, ang +  0.0000, (1.5000 * scl))
    -- local pH10 = Polar2D(pt,63.4349, (2.7951 * scl))
    -- local group = ContourGroup(true)
    local layer = Milling.job.LayerManager:GetLayerWithName(lay)
    local line = Contour(0.0)
    if letter  == 65 then
      line:AppendPoint(pA0)
      line:LineTo(pD8)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pB3)
      line:LineTo(pF3)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 66 then
      line:AppendPoint(pA0)
      line:LineTo(pF0)
      line:LineTo(pG1)
      line:LineTo(pG3)
      line:LineTo(pF4)
      line:LineTo(pG5)
      line:LineTo(pG7)
      line:LineTo(pF8)
      line:LineTo(pA8)
      line:LineTo(pA0)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pF4)
      line:LineTo(pA4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 67 then
      line:AppendPoint(pG2)
      line:LineTo(pF0)
      line:LineTo(pB0)
      line:LineTo(pA2)
      line:LineTo(pA6)
      line:LineTo(pB8)
      line:LineTo(pF8)
      line:LineTo(pG6)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 68 then
      line:AppendPoint(pA0)
      line:LineTo(pF0)
      line:LineTo(pG2)
      line:LineTo(pG6)
      line:LineTo(pF8)
      line:LineTo(pA8)
      line:LineTo(pA0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 69 then
      line:AppendPoint(pG0)
      line:LineTo(pA0)
      line:LineTo(pA8)
      line:LineTo(pF8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA4)
      line:LineTo(pD4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 70 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA4)
      line:LineTo(pF4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 71 then
      line:AppendPoint(pG6)
      line:LineTo(pG7)
      line:LineTo(pF8)
      line:LineTo(pB8)
      line:LineTo(pA6)
      line:LineTo(pA2)
      line:LineTo(pB0)
      line:LineTo(pF0)
      line:LineTo(pG2)
      line:LineTo(pG3)
      line:LineTo(pE3)
      line:LineTo(pE2)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 72 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pG0)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 73 then
      line:AppendPoint(pB0)
      line:LineTo(pB8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA0)
      line:LineTo(pC0)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA8)
      line:LineTo(pC8)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pE0
    end
    if letter  == 74 then
      line:AppendPoint(pA2)
      line:LineTo(pB0)
      line:LineTo(pF0)
      line:LineTo(pG2)
      line:LineTo(pG8)
      line:LineTo(pC8)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 75 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA2)
      line:LineTo(pG7)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pD4)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 76 then
      line:AppendPoint(pA8)
      line:LineTo(pA0)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 77 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      line:LineTo(pD4)
      line:LineTo(pG8)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 78 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      line:LineTo(pF0)
      line:LineTo(pF8)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pG0
    end
    if letter  == 79 then
      line:AppendPoint(pB0)
      line:LineTo(pA2)
      line:LineTo(pA6)
      line:LineTo(pB8)
      line:LineTo(pF8)
      line:LineTo(pG6)
      line:LineTo(pG2)
      line:LineTo(pF0)
      line:LineTo(pB0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 80 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      line:LineTo(pF8)
      line:LineTo(pG7)
      line:LineTo(pG5)
      line:LineTo(pF4)
      line:LineTo(pA4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 81 then
      line:AppendPoint(pB0)
      line:LineTo(pA2)
      line:LineTo(pA6)
      line:LineTo(pB8)
      line:LineTo(pF8)
      line:LineTo(pG6)
      line:LineTo(pG2)
      line:LineTo(pF0)
      line:LineTo(pB0)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pG0)
      line:LineTo(pD4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 82 then
      line:AppendPoint(pA0)
      line:LineTo(pA8)
      line:LineTo(pF8)
      line:LineTo(pG7)
      line:LineTo(pG5)
      line:LineTo(pF4)
      line:LineTo(pA4)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pD4)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 83 then
      line:AppendPoint(pG5)
      line:LineTo(pG6)
      line:LineTo(pF8)
      line:LineTo(pB8)
      line:LineTo(pA6)
      line:LineTo(pA5)
      line:LineTo(pG3)
      line:LineTo(pG2)
      line:LineTo(pF0)
      line:LineTo(pB0)
      line:LineTo(pA2)
      line:LineTo(pA3)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 84 then
      line:AppendPoint(pA8)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pD8)
      line:LineTo(pD0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 85 then
      line:AppendPoint(pA8)
      line:LineTo(pA2)
      line:LineTo(pB0)
      line:LineTo(pF0)
      line:LineTo(pG2)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 86 then
      line:AppendPoint(pA8)
      line:LineTo(pD0)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 87 then
      line:AppendPoint(pA8)
      line:LineTo(pB0)
      line:LineTo(pD4)
      line:LineTo(pF0)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 88 then
      line:AppendPoint(pA0)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA8)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 89 then
      line:AppendPoint(pA8)
      line:LineTo(pD4)
      line:LineTo(pG8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pD0)
      line:LineTo(pD4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 90 then
      line:AppendPoint(pA8)
      line:LineTo(pG8)
      line:LineTo(pA0)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 48 then
      line:AppendPoint(pB0)
      line:LineTo(pA2)
      line:LineTo(pA6)
      line:LineTo(pB8)
      line:LineTo(pF8)
      line:LineTo(pG6)
      line:LineTo(pG2)
      line:LineTo(pF0)
      line:LineTo(pB0)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pG8)
      line:LineTo(pA0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 49 then
      line:AppendPoint(pA6)
      line:LineTo(pD8)
      line:LineTo(pD0)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA0)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 50 then
      line:AppendPoint(pA6)
      line:LineTo(pA7)
      line:LineTo(pB8)
      line:LineTo(pF8)
      line:LineTo(pG7)
      line:LineTo(pG5)
      line:LineTo(pA2)
      line:LineTo(pA0)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 51 then
      line:AppendPoint(pA7)
      line:LineTo(pB8)
      line:LineTo(pF8)
      line:LineTo(pG7)
      line:LineTo(pG5)
      line:LineTo(pF4)
      line:LineTo(pG3)
      line:LineTo(pG1)
      line:LineTo(pF0)
      line:LineTo(pB0)
      line:LineTo(pA1)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pF4)
      line:LineTo(pB4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 52 then
      line:AppendPoint(pF0)
      line:LineTo(pF8)
      line:LineTo(pA2)
      line:LineTo(pG2)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 53 then
      line:AppendPoint(pG8)
      line:LineTo(pA8)
      line:LineTo(pA5)
      line:LineTo(pF4)
      line:LineTo(pG3)
      line:LineTo(pG1)
      line:LineTo(pF0)
      line:LineTo(pB0)
      line:LineTo(pA1)
      line:LineTo(pA2)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 54 then
      line:AppendPoint(pG7)
      line:LineTo(pF8)
      line:LineTo(pB8)
      line:LineTo(pA7)
      line:LineTo(pA1)
      line:LineTo(pB0)
      line:LineTo(pF0)
      line:LineTo(pG1)
      line:LineTo(pG3)
      line:LineTo(pF4)
      line:LineTo(pB4)
      line:LineTo(pA2)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 55 then
      line:AppendPoint(pB0)
      line:LineTo(pG8)
      line:LineTo(pA8)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 56 then
      line:AppendPoint(pA1)
      line:LineTo(pB0)
      line:LineTo(pF0)
      line:LineTo(pG1)
      line:LineTo(pG3)
      line:LineTo(pF4)
      line:LineTo(pG5)
      line:LineTo(pG7)
      line:LineTo(pF8)
      line:LineTo(pB8)
      line:LineTo(pA7)
      line:LineTo(pA5)
      line:LineTo(pB4)
      line:LineTo(pA3)
      line:LineTo(pA1)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pB4)
      line:LineTo(pF4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 57 then
      line:AppendPoint(pA1)
      line:LineTo(pB0)
      line:LineTo(pF0)
      line:LineTo(pG3)
      line:LineTo(pG7)
      line:LineTo(pF8)
      line:LineTo(pB8)
      line:LineTo(pA7)
      line:LineTo(pA5)
      line:LineTo(pB4)
      line:LineTo(pF4)
      line:LineTo(pG5)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 47 then
      line:AppendPoint(pA0)
      line:LineTo(pF8)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pG0
    end
    if letter  == 43 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pD1)
      line:LineTo(pD7)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 61 then
      line:AppendPoint(pA2)
      line:LineTo(pG2)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA6)
      line:LineTo(pG6)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 45 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 39 then
      line:AppendPoint(pA7)
      line:LineTo(pB10)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pC0
    end
    if letter  == 34 then
      line:AppendPoint(pA7)
      line:LineTo(pB10)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pB7)
      line:LineTo(pC10)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pE0
    end
    if letter  == 40 then
      line:AppendPoint(pB8)
      line:LineTo(pA5)
      line:LineTo(pA3)
      line:LineTo(pB0)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pD0
    end
    if letter  == 41 then
      line:AppendPoint(pA8)
      line:LineTo(pB5)
      line:LineTo(pB3)
      line:LineTo(pA0)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pG0
    end
    if letter  == 60 then
      line:AppendPoint(pF8)
      line:LineTo(pA4)
      line:LineTo(pG0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 62 then
      line:AppendPoint(pA8)
      line:LineTo(pF4)
      line:LineTo(pA0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 95 then
      line:AppendPoint(pA0)
      line:LineTo(pF0)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 58 then
      line:AppendPoint(pB8)
      line:LineTo(pA8)
      line:LineTo(pA7)
      line:LineTo(pB7)
      line:LineTo(pB8)
      line:LineTo(pA8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA1)
      line:LineTo(pB1)
      line:LineTo(pB0)
      line:LineTo(pA0)
      line:LineTo(pA1)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pD0
    end
    if letter  == 46 then
      line:AppendPoint(pA1)
      line:LineTo(pB1)
      line:LineTo(pB0)
      line:LineTo(pA0)
      line:LineTo(pA1)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pD0
    end
    if letter  == 59 then
      line:AppendPoint(pB8)
      line:LineTo(pA8)
      line:LineTo(pA7)
      line:LineTo(pB7)
      line:LineTo(pB8)
      line:LineTo(pA8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pB3)
      line:LineTo(pB4)
      line:LineTo(pA4)
      line:LineTo(pA3)
      line:LineTo(pB3)
      line:LineTo(pA0)
      layer:AddObject(CreateCadContour(line), true)
      pH0 = pD0
    end
    if letter  == 35 then
      line:AppendPoint(pA2)
      line:LineTo(pG2)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pA6)
      line:LineTo(pG6)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pB0)
      line:LineTo(pB8)
      layer:AddObject(CreateCadContour(line), true)
      line = Contour(0.0)
      line:AppendPoint(pF0)
      line:LineTo(pF8)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 32 then
      pH0 = pH0
    end
    if letter  == 33 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 36 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 37 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 38 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 42 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 63 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 64 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 91 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 92 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 93 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 94 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 96 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 123 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 124 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 125 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    if letter  == 126 then
      line:AppendPoint(pA4)
      line:LineTo(pG4)
      layer:AddObject(CreateCadContour(line), true)
    end
    return pH0
  end --  function end
  local strlen = string.len(what)
  local strup = string.upper(what)
  local i = 1
  local y = ""
  local ptx = where
  while i <=  strlen do
    y = string.byte(string.sub(strup, i, i))
    ptx = DrawCADLeters(ptx, y , size, lay, ang)
    i = i + 1
  end
  return true
end --  function end
-- ====================================================]]
function GetDistance(objA, objB)
  local xDist = objB.x - objA.x
  local yDist = objB.y - objA.y
  return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end
-- ====================================================]]
function NextSheet()
  if not(Milling.Sheet == "") then
    Milling.Sheet = tostring(tonumber(string.sub(Milling.Sheet,0,(string.len(Milling.Sheet) - 1))) + 1) .. "-"
  end
  return true
end
-- ====================================================]]
function main()
  Milling.job = VectricJob()
  if not Milling.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end -- if end

  Tooler1 = assert(loadfile(script_path .. "\\EasyCabinetBase09-".. VerNumber .. ".xlua")) (Tooler1) -- Load Tool Function
  Tooler2 = assert(loadfile(script_path .. "\\EasyCabinetWall09".. VerNumber .. ".xlua")) (Tooler2) -- Load Tool Function
  Tooler3 = assert(loadfile(script_path .. "\\EasyCabinetTools09-".. VerNumber .. ".xlua")) (Tooler3) -- Load Tool Function
  Tooler4 = assert(loadfile(script_path .. "\\EasyCabinetDialog09" .. VerNumber .. ".xlua")) (Tooler4) -- Load Tool Function
  Tooler5 = assert(loadfile(script_path .. "\\EasyCabinetibrary09" .. VerNumber .. ".xlua")) (Tooler5) -- Load Tool Function

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
  REG_ReadRegistry()
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