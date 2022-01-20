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
-- ========================================================================================================================
-- Easy Cabinet Maker was written by JimAndi Gadgets of Houston Texas 2020
-- ========================================================================================================================
-- Version 12.4 - Dec  7, 2021 - Ready for Posting
-- Version 12.5 - Dec 10, 2021 - Ready for Posting
-- Version 13.0 - Jan  4, 2022 - Added New Sheet Management
-- =====================================================]]
-- require("mobdebug").start()
require "strict"
-- =====================================================]]
-- Global variables
local AppFile1, AppFile2, AppFile3, AppFile4, AppFile5, AppFile6, AppFile7, AppFile8 -- AppFiles
AQ = 0.0
YearNumber = "2022"
VerNumber = "13.5"
AppName = "Easy Base Cabinet Maker"
RegName = "EasyBaseCabinetMaker" .. VerNumber
-- Table Names
BaseDim              = {}
BaseQuestion         = {}
Milling              = {}
Project              = {}
WallDim              = {}
BOM                  = {}
WallQuestion         = {}
Hardware             = {}
Material             = {}
Cab                  = {}   -- Points
DialogWindow         = {}   -- Dialog Managment
Hardware.Slides      = {}
Material.Faceframe   = {"Hardwood",  "Cedar",    "Maple",       "Oak",     "Pine",      "Poplar",     "Walnut"}
Material.SheetGoods  = {"Plywood",   "Melamine", "Birch ply",   "Oak ply", "Maple ply", "Walnut ply", "Poplar ply", "Piano Ply"}
Material.Finshes     = {"Unfinshed", "Paint",    "Primer Only", "Stain"}
layer                = ""
Project.Debugger          = false -- true -- used to desplay error numbers, points, and window X/Y values
Project.Rest              = false
DrawerHeight              = 0.0
DrawerCounts              = 0.0
BaseDim.BottomRail        = false
BaseDim.BottomPocket      = true
DialogWindow.AboutHelp    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/About.html"
DialogWindow.BaseHelp     = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Base.html"
DialogWindow.ExportHelp   = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/ImportExport.html"
DialogWindow.HardwareHelp = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Hardware.html"
DialogWindow.LayerHelp    = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Layers.html"
DialogWindow.MainHelp     = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Milling.html"
-- DialogWindow.MainHelp     = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Slide29.htm"
--DialogWindow.MainHelp     = "file:///C:/Users/James/Documents/JimAndi/www/EasyGadgets/EasyCabinetMaker/Help/Slide05.html"
DialogWindow.MillingHelp  = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Milling.html"
DialogWindow.PartDrawing  = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/PartDrawing.html"
DialogWindow.ProjectHelp  = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Project.html"
DialogWindow.WallHelp     = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Wall.html"
-- DialogWindow.WallHelp     = "file:///C:/Users/James/Documents/JimAndi/www/EasyGadgets/EasyCabinetMaker/Help/Slide05.html"

DialogWindow.DialogLoop   = true
Tool_ID1 = ToolDBId()
Tool_ID2 = ToolDBId()
Tool_ID3 = ToolDBId()
Tool_ID4 = ToolDBId()
Tool_ID5 = ToolDBId()
Tool_ID6 = ToolDBId()
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
Tool_ID3:LoadDefaults("My Toolpath3", "")
Tool_ID4:LoadDefaults("My Toolpath4", "")
Tool_ID5:LoadDefaults("My Toolpath5", "")
Tool_ID6:LoadDefaults("My Toolpath6", "")
Material.BaseCabinetBackWidth       = 0.0
Material.BaseCabinetBottomLength    = 0.0
Material.BaseCabinetBottomWidth     = 0.0
Material.BaseCabinetSideLength      = 0.0
Material.BaseCabinetSideWidth       = 0.0
Material.BaseShelfLength            = 0.0
Material.BaseShelfWidth             = 0.0
Material.FaceFrameCenterLength1     = 0.0
Material.FaceFrameCenterLength2     = 0.0
Material.FaceFrameCenterLength3     = 0.0
Material.FaceFrameCenterLength4     = 0.0
Material.FaceFrameCenterLength5     = 0.0
Material.FaceFrameRailLength        = 0.0
Material.FaceFrameStileLength       = 0.0
Material.ToeKickLength              = 0.0
Material.ToeKickWidth               = 0.0
BOM.WallShelfBOM                    = true
BOM.BaseShelfBOM                    = true
BOM.PID                             = 10
-- Table Values --
Milling.MillTool1 = {} -- Profile Bit
Milling.MillTool2 = {} -- Pocketing Bit
Milling.MillTool3 = {} -- Pocketing Clearing Bit
Milling.MillTool4 = {} -- Shelf Pins Drilling
Milling.MillTool5 = {} -- Assembly pilot holes
Milling.MillTool6 = {} -- Hardware pilot holes
Milling.Tabs = false   -- User to setup Tabs
Milling.Sheet = 1      -- Sheet Count ID
-- =====================================================]]
function main(script_path)
  local CabLoop = true
  local Drawing = false
  Hardware.Action = "HOLD"
  Project.AppPath = script_path
  Milling.job = VectricJob()
  DialogWindow.Sheets = ""

--  if GetAppVersion() >= 11.0 then
--    DialogWindow.Sheets = "disabled"
--  else
    DialogWindow.Sheets = ""
--  end -- if end

  if not Milling.job.Exists then
    StatusMessage("Error", "Project Path", "The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions", "(1300)")
    return false
  end -- if end
  DialogWindow.MainHelp = script_path .. "\\" .. DialogWindow.MainHelp

  AppFile1 = assert(loadfile(script_path .. "\\EasyCabinetToolVer"     .. VerNumber .. ".xlua")) (AppFile1) -- Load Tooll Function
  AppFile2 = assert(loadfile(script_path .. "\\EasyCabinetLibraryVer"  .. VerNumber .. ".xlua")) (AppFile2) -- Load Tool4 Function
  AppFile3 = assert(loadfile(script_path .. "\\EasyCabinetWallVer"     .. VerNumber .. ".xlua")) (AppFile3) -- Load Tool2 Function
  AppFile4 = assert(loadfile(script_path .. "\\EasyCabinetBaseVer"     .. VerNumber .. ".xlua")) (AppFile4) -- Load Tool3 Function
  AppFile5 = assert(loadfile(script_path .. "\\EasyCabinetHardwareVer" .. VerNumber .. ".xlua")) (AppFile5) -- Load Tool5 Function
  AppFile6 = assert(loadfile(script_path .. "\\EasyCabinetImagesVer"   .. VerNumber .. ".xlua")) (AppFile6) -- Load Tool6 Function
  AppFile7 = assert(loadfile(script_path .. "\\EasyCabinetDialogVer"   .. VerNumber .. ".xlua")) (AppFile7) -- Load Tool7 Function
  AppFile8 = assert(loadfile(script_path .. "\\EasyCabinetRegistryVer" .. VerNumber .. ".xlua")) (AppFile8) -- Load Tool8 Function

  Images()
  HTML()
  GetMaterialSettings()
  RegistryRead()
  Base_Math()
  Wall_Math()
  Mill_Math()
  INI_ReadGroups()
  RegistryWrite()
  while CabLoop do
    Drawing = InquiryWallOrBase("Easy Cabinet Maker")
    if Drawing and (Project.ProjectPath  ==  "Default") then
      StatusMessage("Alert", "Project Path", "The Project path must be selected and saved.", "(1410)")
      OnLuaButton_InquiryProjectInfo()
      CabLoop = true
    elseif Drawing and (not MillingValidater()) then
        CabLoop = true
    elseif Drawing and (not BaseValidater()) then
        CabLoop = true
    elseif Drawing and (not WallValidater()) then
        CabLoop = true
    elseif Drawing and (not MainValidate()) then
        CabLoop = true
    elseif Drawing and (All_Trim(Project.ProjectPath)  ==  "") then
        OnLuaButton_InquiryProjectInfo()
        CabLoop = true
    elseif Drawing and (not(os.rename(Project.ProjectPath, Project.ProjectPath))) then
        StatusMessage("Error", "Project Path", "Cannot find the Project Path or Access is blocked. \n" ..
                          "Check the full path is made and no application have open files in the folder. \n" ..
                          "\nUse the Project Setup menu to set the correct Project location" , "(1400)")
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
    INI_GetValues(Hardware.Name)
    LayerMake("")
    Mill_Math()
    MillingTools()
    Sheetlabel(Cab.Wpt1, Double2Fraction(WallDim.MaterialThickness), BOM.WallCabinetMateralType .. " - Wall: Side Panels")
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
          CreateLayerDrillingToolpath(Milling.LNSideShelfPinDrill .. "-Wall", Milling.Sheet .. "Wall Side Panel Pin Drilling", 0.0,  Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        end -- if end
      end
      -- ====
      if WallQuestion.DrawBottomTopPanel then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall TopBottom Pockets", Milling.LNTopBottomPocket .. "-Wall", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
      end
      -- ====
      if WallQuestion.AddCenterPanel then
        Wall_CenterPanel()
        if WallQuestion.DrawCenterPanel then
          CreateLayerProfileToolpath(Milling.LNCenterPanelProfile .. "-Wall", Milling.Sheet .. "Wall Center Panel Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
          if WallQuestion.ShelfCount > 0 then
            CreateLayerDrillingToolpath(Milling.LNCenterPanelShelfPinDrill .. "-Wall", Milling.Sheet .. "Wall Center Panel Pin Drilling", 0.0,  WallDim.MaterialThickness, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
          end -- if end
        end -- if end
      end -- if end
      -- ====
      if WallQuestion.DrawSidePanels then
        CreateLayerProfileToolpath(Milling.LNSideProfile .. "-Wall", Milling.Sheet .. "Wall Side Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end
      if WallQuestion.DrawBottomTopPanel then
        CreateLayerProfileToolpath(Milling.LNTopBottomProfile .. "-Wall", Milling.Sheet .. "Wall Top Bottom Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end
      -- ====
      if (Project.NewSheet == "Yes") and (WallDim.ShelfMaterialThickness ~= WallDim.MaterialThickness) then
        NextSheet((WallDim.ShelfLength + Milling.PartGap) * WallQuestion.ShelfCount, WallDim.ShelfWidth )
        Sheetlabel(Cab.Wpt1, Double2Fraction(WallDim.ShelfMaterialThickness), BOM.WallCabinetMateralType .. " - Wall: Shelf Panels", WallDim.ShelfWidth)
        Cab.Wpt8 = Cab.Wpt1
      else
        Cab.Wpt8 = Polar2D(Cab.Wpt5, 90.0, Milling.PartGap + WallDim.TopBottomPanelWidth)
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

      if Project.NewSheet == "Yes" then  -- Sheet 2
        if Material.Orantation == "V" then
          NextSheet(WallDim.BackPanelLength, WallDim.BackPanelWidth)
          Sheetlabel(Cab.Wpt1, Double2Fraction(WallDim.ThicknessBack), BOM.WallCabinetMateralType .. " - Wall: Back Panel", WallDim.BackPanelWidth)
          Cab.Wpt3 = Polar2D(Cab.Wpt1, 90.0, 10.0 * Milling.Cal)
        else
          NextSheet(WallDim.BackPanelWidth, WallDim.BackPanelLength)
          Sheetlabel(Cab.Wpt1, Double2Fraction(WallDim.ThicknessBack), BOM.WallCabinetMateralType .. " - Wall: Back Panel", WallDim.BackPanelLength)
          Cab.Wpt3 = Cab.Wpt1
        end
      end -- if end
      Wall_CabinetBack()
      -- ==
      if WallQuestion.AddCenterPanel and WallQuestion.DrawBackPanel  then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Wall Back Pockets", Milling.LNBackPocket .. "-Wall", 0.0, Milling.DadoBackHeight)
      end -- if end
      if WallQuestion.DrawBackPanel then
        CreateLayerProfileToolpath(Milling.LNBackProfile .. "-Wall", Milling.Sheet .. "Wall Back Panel Profile", 0.0, WallDim.ThicknessBack, "OUT", Milling.Tabs)
      end
      if Project.CabinetStyle == "Face Frame" then
        if Project.NewSheet == "Yes" then -- Sheet 3
          if Material.Orantation == "V" then
            NextSheet(WallDim.CabLength, WallDim.CabHeight)
            Sheetlabel(Cab.Wpt1, Double2Fraction(WallDim.FaceFrameThickness), BOM.WallFaceFrameMateralType .. " - Wall: Face Frame", WallDim.CabHeight)
            Cab.Wpt4 = Polar2D(Cab.Wpt1, 90.0, 10.0 * Milling.Cal)
          else
            NextSheet(WallDim.CabHeight, WallDim.CabLength)
            Sheetlabel(Cab.Wpt1, Double2Fraction(WallDim.FaceFrameThickness), BOM.WallFaceFrameMateralType .. " - Wall: Face Frame", WallDim.CabLength)
            Cab.Wpt4 = Cab.Wpt1
          end
          -- Cab.Wpt4 = Cab.Wpt1
        end -- if end
        -- ====
        Wall_CabinetFaceFrame()
      end -- if end
      -- ====
      if WallQuestion.DrawNotes then
        if Project.ProjectPath  ==  "Default" then
            StatusMessage("Alert", "Project Path", "The Cabinet Maker Project has not configured.\n" ..
                                   "Open Project dialog and set the Project path and saved.", "(1510)")
            return false
          else
            if not(os.rename(Project.ProjectPath, Project.ProjectPath)) then
              StatusMessage("Error", "Project Path", "Cannot find Project Path! \n" ..
                                     "Use the Project Setup menu to set the correct Project location", "(12500)")
              return false
            end -- if end
          end -- if end
      end -- if end
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
          NextSheet()
          Sheetlabel(Cab.Wpt1, Double2Fraction(BaseDim.MaterialThickness), BOM.BaseCabinetMateralType .. " - Base: Side Panels")
        else
          if Material.Orantation == "V" then
            Cab.Wpt1 = Polar2D(Cab.Wpt1, 90.0, Milling.MaterialBlockWidth)
          else
            Cab.Wpt1 = Polar2D(Cab.Wpt1, 90.0, Milling.MaterialBlockHeight)
          end -- if end
        end -- if end
      end -- if end
      Base_Math()
      Base_CabinetSide("L")
      Base_CabinetSide("R")
      -- Base Tool Paths
      if BaseQuestion.ShelfCount > 0 and BaseQuestion.DrawSidePanels then
        CreateLayerDrillingToolpath(Milling.LNSideShelfPinDrill .. "-Base", Milling.Sheet .. "Base Shelf Pin Drilling", 0.0, Milling.ShelfPinLen, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
      end -- if end
      -- ====
      if (Project.NewSheet == "Yes") and (BaseDim.ShelfMaterialThickness ~= BaseDim.MaterialThickness) then
        Cab.Wpt10 = Cab.Wpt9
      elseif BaseQuestion.ShelfCount == 0 and BaseQuestion.DrawSidePanels and BaseQuestion.AddCenterPanel and BaseQuestion.DrawCenterPanel then
        Cab.Wpt10 = Polar2D(Cab.Wpt1, 90.0, BaseDim.SidePanelWidth + Milling.PartGap) --  Shelves
      end -- if end

      if BaseQuestion.AddCenterPanel and BaseQuestion.DrawCenterPanel then
        Base_CenterPanel()
        CreateLayerProfileToolpath(Milling.LNCenterPanelProfile .. "-Base", Milling.Sheet .. "Base Center Panel Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      -- Base Tool Paths
        if BaseQuestion.ShelfCount > 0 then
          CreateLayerDrillingToolpath(Milling.LNCenterPanelShelfPinDrill .. "-Base", Milling.Sheet .. "Base Center Pin Drilling", 0.0, BaseDim.MaterialThickness, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.35)
        end -- if end
      end -- if end
      -- ====
      if Milling.AddAssemblyHolesBase then
        CreateLayerDrillingToolpath(Milling.LNAssemblyHole .. "-Base", Milling.Sheet .. "Base Assembly Drilling", 0.0, Milling.ShelfPinLen, BaseDim.MaterialThickness, Milling.ShelfPinLen * 0.25)
      end -- if end
      if (Hardware.Name ~= "No Drawer Slide") then
        CreateLayerDrillingToolpath(Milling.LNDrawerSlideHole .. "-Base", Milling.Sheet .. "Base Slide Pilot Drilling", 0.0, Milling.PilotHoleDepth, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.25)
      end -- if end
      if BaseQuestion.DrawSidePanels then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base Side Pockets", Milling.LNSidePocket .. "-Base", 0.0, (Milling.MaterialBlockThickness - Milling.DadoHeight))
        CreateLayerProfileToolpath(Milling.LNSideProfile .. "-Base", Milling.Sheet .. "Base Side Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end
      -- sheet 2 -- Base Shelfs
      if BaseQuestion.ShelfCount > 0 and (Project.NewSheet == "Yes") and (BaseDim.ShelfMaterialThickness ~= BaseDim.MaterialThickness) then
        NextSheet((BaseDim.ShelfLength + Milling.PartGap) * BaseQuestion.ShelfCount, BaseDim.CabDepth + (4.0 * Milling.Cal))
        Sheetlabel(Cab.Wpt1, Double2Fraction(BaseDim.ShelfMaterialThickness), BOM.BaseCabinetMateralType .. " - Base: Shelf Panels", BaseDim.CabDepth + (4.0 * Milling.Cal))
        Cab.Wpt9 = Cab.Wpt1
      end -- if end
        if (BaseQuestion.ShelfCount >= 1) and BaseQuestion.DrawShelfPanel then
          local CountX = BaseQuestion.ShelfCount
          BOM.PID = BOM.PID + 10
          while (CountX > 0) do
            Base_CabinetShelf()
            Cab.Wpt9 = Polar2D(Cab.Wpt9, 0.0, (BaseDim.ShelfLength + Milling.PartGap))
            CountX = CountX - 1
          end -- while end
          BOM.PID = BOM.PID + 10
          CreateLayerProfileToolpath(Milling.LNShelfProfile .. "-Base", Milling.Sheet .. "Base Shelf Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
        end -- if end

      -- ====

      -- ===============================================================================================
      if Project.NewSheet == "Yes" then -- Sheet 2
        BaseQuestion.DrawerRowCountSpace = 0
        for _ = 1, BaseQuestion.DrawerRowCount, 1 do
          BaseQuestion.DrawerRowCountSpace = BaseQuestion.DrawerRowCountSpace + BaseDim.StretcherWidth  + Milling.PartGap
	      end
        NextSheet(BaseDim.CabHeight +  BaseQuestion.DrawerRowCountSpace, BaseDim.CabLength)
        Sheetlabel(Cab.Wpt1, Double2Fraction(BaseDim.MaterialThickness), BOM.BaseCabinetMateralType  .. " - Base: Bottom Panel and Toe Kick", BaseDim.CabLength)
        if Material.Orantation == "V" then
          Cab.Wpt3 = Polar2D(Cab.Wpt1, 90.0, 10.0 * Milling.Cal)
        else
          Cab.Wpt3 = Cab.Wpt1
        end
      end -- if end
      -- ====
      Base_CabinetBottom()
      -- Base Tool Paths
      if BaseQuestion.AddCenterPanel and BaseQuestion.DrawBottomPanel then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base Bottom Pockets", Milling.LNTopBottomPocket .. "-Base", 0.0, (BaseDim.MaterialThickness - Milling.DadoHeight))
      end
      -- ====
      Base_CabinetToeandRunners()
      if Milling.AddAssemblyHolesBase and BaseQuestion.AddCenterFaceFrame then
        CreateLayerDrillingToolpath(Milling.LNAssemblyHole .. "Bottom-Base", Milling.Sheet .. "Base Assy Drilling Bottom", 0.0, Milling.ShelfPinLen, BaseDim.MaterialThickness, Milling.ShelfPinLen * 0.25)
        CreateLayerDrillingToolpath(Milling.LNAssemblyHole .. "Top-Base", Milling.Sheet .. "Base Assy Drilling Top", 0.0, Milling.ShelfPinLen, BaseDim.MaterialThickness, Milling.ShelfPinLen * 0.25)
      end -- if end

      if BaseQuestion.DrawTopToe then
        CreateLayerProfileToolpath(Milling.LNStretcherRailProfile .. "-Base", Milling.Sheet .. "Base Stretcher Rails Profile", 0.0, BaseDim.MaterialThickness, "OUT", Milling.Tabs)
      end -- if end

      if BaseQuestion.DrawBottomPanel then
        CreateLayerProfileToolpath(Milling.LNTopBottomProfile .. "-Base", Milling.Sheet .. "Base Top Bottom Profile", 0.0, Milling.MaterialBlockThickness, "OUT", Milling.Tabs)
      end -- if end

      -- Base Tool Paths
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if Project.NewSheet == "Yes" then -- sheet 3
        NextSheet(BaseDim.CabHeight, BaseDim.CabLength)
        Sheetlabel(Cab.Wpt1, Double2Fraction(BaseDim.ThicknessBack), BOM.BaseCabinetMateralType .. " - Base: Back Panel", BaseDim.CabLength)
        if Material.Orantation == "V" then
          Cab.Wpt7 = Polar2D(Cab.Wpt1, 90.0, 10.0 * Milling.Cal)
        else
          Cab.Wpt7 = Cab.Wpt1
        end
      end -- if end
      -- ====
      Base_CabinetBack()
      -- Base Tool Paths

      if BaseQuestion.DrawBackPanel then
        CreateLayerPocketingToolpath(Milling.Sheet .. "Base Back Pockets", Milling.LNBackPocket .. "-Base", 0.0, Milling.DadoBackHeight)
        CreateLayerProfileToolpath(Milling.LNBackProfile .. "-Base", Milling.Sheet .. "Base Back Panel Profile", 0.0, BaseDim.ThicknessBack, "OUT", Milling.Tabs)
        CreateLayerDrillingToolpath(Milling.LNAssemblyHole .. "Back-Base", Milling.Sheet .. "Base Back Assembly Drilling", 0.0, Milling.ShelfPinLen, BaseDim.ThicknessBack, Milling.ShelfPinLen * 0.25)
      end -- if end

      if (Hardware.Name ~= "No Drawer Slide") then
        CreateLayerDrillingToolpath(Milling.LNDrawerSlideHole .. "Back-Base", Milling.Sheet .. "Base Slide Pilot Drilling", 0.0, Milling.PilotHoleDepth, Milling.ShelfPinLen * 0.25, Milling.ShelfPinLen * 0.25)
      end -- if end
      -- ====
      if Project.CabinetStyle == "Face Frame" then
        if Project.NewSheet == "Yes" then
          NextSheet(BaseDim.CabHeight, BaseDim.CabLength)
          Sheetlabel(Cab.Wpt1, Double2Fraction(BaseDim.FaceFrameThickness), BOM.BaseFaceFrameMateralType .. " Base: - Face Frame", BaseDim.CabLength)
          if Material.Orantation == "V" then
            Cab.Wpt8 = Polar2D(Cab.Wpt1, 90.0, 10.0 * Milling.Cal)
          else
            Cab.Wpt8 = Cab.Wpt1
          end
        end -- if end

        Base_CabinetFaceFrame()
      end -- if end
      -- ====
      CutListfileWriterFooter()
    end
  end -- if end
  if Milling.Profile or  Milling.Pocket or Milling.Clearning or Milling.Drilling or Milling.AddAssemblyHolesToolpath or  Milling.AddSlideHolesToolpath then
    if Project.NewSheet == "Yes" then
      StatusMessage("Alert", "Project Sheet", "All Sheet are replicated from the initial sheet configuration. \n " ..
                                      "Therefore, you will need to manually adjust material thickness to \n" ..
                                      "to match varying part thicknesses", "(1492)")
    else
      StatusMessage("Alert", "Project Sheet", "All Parts have been drawn on the same. \n " ..
                                      "Therefore, you will need to check the material thickness for \n" ..
                                      "the Base and Wall Cabinet back material thickness to be correct", "(1493)")
    end -- if end
  end -- if end
  LayerClear()
  Milling.job:Refresh2DView()
  return true
end -- function end
-- ==================== End ============================]]