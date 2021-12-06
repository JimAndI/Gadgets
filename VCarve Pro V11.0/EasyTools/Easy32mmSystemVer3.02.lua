-- VECTRIC LUA SCRIPT
--[[
--| Gadgets are an entirely optional add-in to Vectric's core software products.
--| They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
--| In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
--|
--| Permission is granted to anyone to use this software for any purpose,
--| including commercial applications, and to alter it and redistribute it freely,
--| subject to the following restrictions:
--|
--| 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--|    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
--| 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--| 3. This notice may not be removed or altered from any source distribution.
--|
--| Easy Euro Hinge Maker is written by JimAndi Gadgets of Houston Texas 2020
]]
-- ===================================================]]
--[[
Do List:

-- ===================================================]]
-- Global variables
require("mobdebug").start()
-- require "strict"
-- Table Names
local Panel = {}
local DialogWindow = {}
Panel.VerNumber = "3.0"
DialogWindow.AppName = "Easy 32mm System"
Panel.RegName = "Easy32mmSystem" .. Panel.VerNumber
Panel.DialogLoop = true
Panel.Tool_ID1 = ToolDBId()
Panel.Tool_ID2 = ToolDBId()
--Panel.Tool_ID3 = ToolDBId()
local lead_in_out_data   = LeadInOutData() -- Create object used to control lead in/out
DialogWindow.SDK         = "http://www.jimandi.com/EasyGadgets/Easy32mmSystem/Help/index.html"
DialogWindow.SDKLayer    = "http://www.jimandi.com/EasyGadgets/Easy32mmSystem/Help/Layers.html"
DialogWindow.SDKMilling  = "http://www.jimandi.com/EasyGadgets/Easy32mmSystem/Help/Milling.html"

Panel.Tool_ID1:LoadDefaults("My Profile1",   "")
Panel.Tool_ID2:LoadDefaults("My Pocket2",    "")
-- Panel.Tool_ID3:LoadDefaults("My DrillPath3", "")
-- ===================================================]]
function REG_ReadRegistry() -- Read from Registry values
  local RegistryRead         = Registry(Panel.RegName)
  Panel.Length               = RegistryRead:GetDouble("Panel.Length",               24.0000)
  Panel.Width                = RegistryRead:GetDouble("Panel.Width",                12.0000)
  Panel.HoleDia              = RegistryRead:GetDouble("Panel.HoleDia",              0.19685)
  Panel.HoleDepth            = RegistryRead:GetDouble("Panel.HoleDepth",            0.5000)
  Panel.Sets                 = RegistryRead:GetInt("Panel.Sets",                    1)
  Panel.DrillOrMill          = RegistryRead:GetString("Panel.DrillOrMill",          "Pocketing")
  Panel.EndOption1           = RegistryRead:GetString("Panel.EndOption1",          "Yes")
  Panel.EndOption2           = RegistryRead:GetString("Panel.EndOption2",          "Yes")
  Panel.ProfileBitDiameter   = RegistryRead:GetDouble("Panel.ProfileBitDiameter",   0.250)
  Panel.PartGap              = RegistryRead:GetDouble("Panel.PartGap",              0.750)
  Panel.LayerNPinHole        = RegistryRead:GetString("Panel.LayerNPinHole",        "Pin Hole")
  Panel.LayerNProfile        = RegistryRead:GetString("Panel.LayerNProfile",        "Panel Profile")
  Panel.Orientation          = RegistryRead:GetString("Panel.Orientation",          "Horizontal")
  Panel.LayerNProfileColor   = RegistryRead:GetString("Panel.LayerNProfileColor",   "Black")
  Panel.LayerNPinHoleColor   = RegistryRead:GetString("Panel.LayerNPinHoleColor",   "Black")
  Panel.InquiryAboutXY       = RegistryRead:GetString("Panel.InquiryAboutXY",       "x")
  Panel.InquiryPanelXY       = RegistryRead:GetString("Panel.InquiryPanelXY",       "x")
  Panel.InquiryLayersXY      = RegistryRead:GetString("Panel.InquiryLayersXY",      "x")
  Panel.InquiryMillingXY     = RegistryRead:GetString("Panel.InquiryMillingXY",     "x")
  return true
end --function end
-- ===================================================]]
function GetDistance(objA, objB)
   local xDist = objB.x - objA.x
   local yDist = objB.y - objA.y
   return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end
-- ===================================================]]
function REG_WriteRegistry()                            -- Write to Registry values
  local RegistryWrite = Registry(Panel.RegName)
  local RegValue = RegistryWrite:SetString("Panel.InquiryAboutXY",         Panel.InquiryAboutXY)
        RegValue = RegistryWrite:SetString("Panel.InquiryPanelXY",         Panel.InquiryPanelXY)
        RegValue = RegistryWrite:SetString("Panel.InquiryLayersXY",        Panel.InquiryLayersXY)
        RegValue = RegistryWrite:SetString("Panel.InquiryMillingXY",       Panel.InquiryMillingXY)
        RegValue = RegistryWrite:SetString("Panel.Orientation",            Panel.Orientation)
        RegValue = RegistryWrite:SetString("Panel.EndOption1",             Panel.EndOption1)
        RegValue = RegistryWrite:SetString("Panel.EndOption2",             Panel.EndOption2)
        RegValue = RegistryWrite:SetString("Panel.LayerNProfile",          Panel.LayerNProfile)
        RegValue = RegistryWrite:SetString("Panel.LayerNPinHole",          Panel.LayerNPinHole)
        RegValue = RegistryWrite:SetDouble("Panel.HoleDia",                Panel.HoleDia)
        RegValue = RegistryWrite:SetDouble("Panel.HoleDepth",              Panel.HoleDepth)
        RegValue = RegistryWrite:SetString("Panel.DrillOrMill",            Panel.DrillOrMill)
        RegValue = RegistryWrite:SetDouble("Panel.PartGap",                Panel.PartGap)
        RegValue = RegistryWrite:SetDouble("Panel.Width",                  Panel.Width)
        RegValue = RegistryWrite:SetDouble("Panel.Length",                 Panel.Length)
        RegValue = RegistryWrite:SetInt("Panel.Sets",                      Panel.Sets)
        RegValue = RegistryWrite:SetString("Panel.LayerNProfileColor",     Panel.LayerNProfileColor)
        RegValue = RegistryWrite:SetString("Panel.LayerNPinHoleColor",     Panel.LayerNPinHoleColor)
  return true
end -- function end
--====================================================]]
function Polar2D(pt, ang, dis)
  return Point2D((pt.X + dis * math.cos(math.rad(ang))),
                 (pt.Y + dis * math.sin(math.rad(ang)))
                )
end -- function end
-- ===================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtmlAbout, 720, 478, "About System 32mm")
  dialog:AddLabelField("SysName", DialogWindow.AppName)
  dialog:AddLabelField("Version", "Version: " .. Panel.VerNumber)
  dialog:ShowDialog()
  Panel.InquiryAboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  return  true
end -- function end
-- ===================================================]]
function OnLuaButton_InquiryLayers()
  local dialog = HTML_Dialog(true, DialogWindow.myHtmlLayer, 692, 169, "Layer Settings")
  dialog:AddTextField("Panel.LayerNProfile",           Panel.LayerNProfile)
  dialog:AddTextField("Panel.LayerNPinHole",           Panel.LayerNPinHole)
  dialog:AddDropDownList("Panel.LayerNProfileColor",   Panel.LayerNProfileColor)
  dialog:AddDropDownList("Panel.LayerNPinHoleColor",   Panel.LayerNPinHoleColor)
  if dialog:ShowDialog() then
    Panel.LayerNProfileColor = dialog:GetDropDownListValue("Panel.LayerNProfileColor")
    Panel.LayerNPinHoleColor = dialog:GetDropDownListValue("Panel.LayerNPinHoleColor")
    Panel.LayerNPinHole = dialog:GetTextField("Panel.LayerNPinHole")
    Panel.LayerNPinHole = dialog:GetTextField("Panel.LayerNPinHole")
    Panel.InquiryLayersXY  = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    REG_WriteRegistry()
  end
  return  true
end -- function end
-- ===================================================]]
function OnLuaButton_InquiryMilling()
  local dialog = HTML_Dialog(true, DialogWindow.myHtmlMilling, 658, 137, "Milling Settings")
  dialog:AddDropDownList("Panel.DrillOrMill", Panel.DrillOrMill)
  dialog:AddDoubleField("Panel.PartGap",      Panel.PartGap)
  if dialog:ShowDialog() then
    Panel.DrillOrMill      = dialog:GetDropDownListValue("Panel.DrillOrMill")
    Panel.PartGap          = dialog:GetDoubleField("Panel.PartGap")
    Panel.InquiryMillingXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
    Panel.dialog:UpdateLabelField("ToolNameLabel2", "Not Selected")

 if Panel.DrillOrMill == "Drilling" then
      Panel.dialog:UpdateLabelField("DrillState",  "Pin Hole Drilling Tool")
      Panel.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.THROUGH_DRILL)
    else
      Panel.dialog:UpdateLabelField("DrillState",  "Pin Hole Pocketing Tool")
      Panel.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
    end
    REG_WriteRegistry()
  end
  return  true
end -- function end
-- ===================================================]]
function InquiryPanel(Header)
    Panel.dialog = HTML_Dialog(true, DialogWindow.myHtmlPanel, 650, 540,  Header .. " (Ver:" .. Panel.VerNumber.. ")  " .. Panel.UnitDisplay) ;
    if Panel.DrillOrMill == "Drilling" then
      Panel.dialog:AddLabelField("DrillState",  "Pin Hole Drilling Tool")
    else
      Panel.dialog:AddLabelField("DrillState",  "Pin Hole Pocketing Tool")
    end
    Panel.dialog:AddDoubleField("Panel.Length",       Panel.Length)
    Panel.dialog:AddDoubleField("Panel.Width",        Panel.Width)
    Panel.dialog:AddDoubleField("Panel.HoleDia",      Panel.HoleDia)
    Panel.dialog:AddDoubleField("Panel.HoleDepth",    Panel.HoleDepth)
    Panel.dialog:AddDropDownList("Panel.EndOption1",  Panel.EndOption1)
    Panel.dialog:AddDropDownList("Panel.EndOption2",  Panel.EndOption2)
    Panel.dialog:AddDropDownList("Panel.Orientation", Panel.Orientation)
    Panel.dialog:AddIntegerField("Panel.Sets",        Panel.Sets)
    Panel.dialog:AddLabelField("ToolNameLabel1", "Not Selected")
    Panel.dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Panel.Tool_ID1)
    Panel.dialog:AddToolPickerValidToolType("ToolChooseButton1", Tool.END_MILL)
    Panel.dialog:AddLabelField("ToolNameLabel2", "Not Selected")
    Panel.dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Panel.Tool_ID2)
    if Panel.DrillOrMill == "Drilling" then
      Panel.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.THROUGH_DRILL)
    else
      Panel.dialog:AddToolPickerValidToolType("ToolChooseButton2", Tool.END_MILL)
    end -- if end
    if  Panel.dialog:ShowDialog() then
      Panel.Width       = Panel.dialog:GetDoubleField("Panel.Width")
      Panel.Length      = Panel.dialog:GetDoubleField("Panel.Length")
      Panel.HoleDia     = Panel.dialog:GetDoubleField("Panel.HoleDia")
      Panel.HoleDepth   = Panel.dialog:GetDoubleField("Panel.HoleDepth")
      Panel.Orientation = Panel.dialog:GetDropDownListValue("Panel.Orientation")
      Panel.EndOption1  = Panel.dialog:GetDropDownListValue("Panel.EndOption1")
      Panel.EndOption2  = Panel.dialog:GetDropDownListValue("Panel.EndOption2")
      Panel.Sets        = Panel.dialog:GetIntegerField("Panel.Sets")
      Panel.MillTool1   = Panel.dialog:GetTool("ToolChooseButton1")  -- Profile
      Panel.MillTool2   = Panel.dialog:GetTool("ToolChooseButton2")  -- Pin holes are made by Milling or Drilling
      Panel.InquiryPanelXY = tostring(Panel.dialog.WindowWidth) .. " x " .. tostring(Panel.dialog.WindowHeight)
      if not REG_WriteRegistry() then
        DisplayMessageBox("Error: Writting Registry")
        return false
      end -- if end
      if Panel.Sets < 1 then
          Panel.Sets = 1
      end
      return true
    else
      return false
    end
 end -- function end
-- ===================================================]]
function AllTrim(s)                                     -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function DrawPanel(pt1)
  if Panel.Orientation == "Horizontal" then
    Panel.WAng = 90.0
    Panel.HAng =  0.0
  else
    Panel.WAng =  0.0
    Panel.HAng = 90.0
  end
  local pt2   = Polar2D(pt1, Panel.WAng, Panel.Width)
  local pt3   = Polar2D(pt2, Panel.HAng, Panel.Length)
  local pt4   = Polar2D(pt3, Panel.WAng + 180.0, Panel.Width)
  local pt5   = Polar2D(pt2, Panel.WAng, Panel.PartGap)
  local line  = Contour(0.0)
  local layer = Panel.job.LayerManager:GetLayerWithName(Panel.LayerNProfile)
  line:AppendPoint(pt1); line:LineTo(pt2); line:LineTo(pt3); line:LineTo(pt4); line:LineTo(pt1); layer:AddObject(CreateCadContour(line), true)
  return pt5
end -- function end
-- ===================================================]]
function CheckLayerValues()                             -- Look at what the User inputed.
  if AllTrim(Panel.LayerNPinHole) == "" then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Pin hole layer name cannot be blank")
  end
  if AllTrim(Panel.LayerNProfile) == "" then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Panel profile layer name cannot be blank")
  end
end -- function end
-- ===================================================]]
function CheckMillingValues()                           -- Look at what the User inputed.
  if Panel.LayerNProfileBitDiameter <= 0.0 then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Profile Bit Diameter value")
  end
  if Panel.ScrewDrillingDiameter <= 0.0 then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Incorrect Hole Set Back value")
  end
  if Panel.CupClearingBitDiameter <= 0.0 then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Cup Clearing Bit Diameter value")
  end
  if Panel.CupPocketBitDiameter <= 0.0 then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Cup Pocket Bit Diameter value")
  end
  if Panel.ScrewPocketingDiameter <= 0.0 then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Screw Pocketing Diameter value")
  end
  if Panel.PartGap <= 0.0 then
    Panel.DialogLoop = true
    DisplayMessageBox("Error: Part Spacing value")
  end
end -- function end
-- ===================================================]]
function main()
  Panel.job = VectricJob()
  if not Panel.job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions")
    return false ;
  end
  -- Panel.Door                   = Panel.job.Selection
  Panel.MaterialBlock          = MaterialBlock()
  Panel.MaterialBlockThickness = Panel.MaterialBlock.Thickness
  --local units
  if Panel.MaterialBlock.InMM then
    Panel.Units       = "mm"
    Panel.Unit        = true
    Panel.HoleSpacing = 32
    Panel.PinHoleDia  = 5
    Panel.FrontDist   = 37
  else
    Panel.Units       = "inch"
    Panel.Unit        = false
    Panel.HoleSpacing = 1.259843
    Panel.PinHoleDia  = 0.19685
    Panel.FrontDist   = 1.4566933858268
  end
  Panel.UnitDisplay  = " Units: (" .. Panel.Units ..")"
  Panel.Toolpath_Mgr = ToolpathManager()
  HTML() -- Reads the Html function
  if not REG_ReadRegistry() then
      DisplayMessageBox("Error: Reading from Registry")
    return false
  end
-- ===================================================]]
  while Panel.DialogLoop do
    Panel.Inquiry = InquiryPanel(DialogWindow.AppName)
    if Panel.Inquiry == true then
      Panel.DialogLoop = false
      CheckLayerValues()
      -- CheckMillingValues()
    else
      Panel.DialogLoop = false
    end -- if end
  end -- while end
-- ===================================================]]
  if Panel.Inquiry then
    --local  objects
    local pt1 = Point2D(0, 0)
    if Panel.Unit then
      pt1 = Point2D(18.0, 18.0)
    else
      pt1 = Point2D(1.0, 1.0)
    end
    MakeLayers()
    for _ = Panel.Sets, 1, -1 do
      DrawHoles(pt1, "R")
      pt1 = DrawPanel(pt1)
      DrawHoles(pt1, "L")
      pt1 = DrawPanel(pt1)
      pt1 = Polar2D(pt1, Panel.WAng, Panel.PartGap)
    end
    CreateLayerProfileToolpath("Panel Profile",        Panel.LayerNProfile, 0.0, Panel.MaterialBlockThickness, "OUT")
    if Panel.DrillOrMill == "Pocketing" then
      Panel.Drilling = false
      CreateLayerPocketToolpath("Pocketed Pin Holes",  Panel.LayerNPinHole, 0.0, Panel.HoleDepth)
    else
      Panel.Drilling = true
      CreateLayerDrillingToolpath("Drilled Pin Holes", Panel.LayerNPinHole, 0.0, Panel.HoleDepth, Panel.HoleDepth * 0.15)
    end
    if not REG_WriteRegistry() then
      DisplayMessageBox("Error: Writting Registry")
      return false
    end
  end
  Panel.job:Refresh2DView()
  return true
end
-- ===================================================]]
function CreateLayerDrillingToolpath(name, layer_name, start_depth, cut_depth, retract_gap)
  if Panel.Drilling then
    local selection = Panel.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Panel.job.LayerManager:FindLayerWithName(layer_name)
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
      local tool = Tool(Panel.MillTool2.Name, Tool.THROUGH_DRILL)       -- BALL_NOSE, END_MILL, VBIT, THROUGH_DRILL
      tool.InMM = Panel.MillTool2.InMM -- tool_in_mm
      tool.ToolDia = Panel.MillTool2.ToolDia -- tool_dia
      tool.Stepdown = Panel.MillTool2.Stepdown -- tool_stepdown
      tool.Stepover = Panel.MillTool2.ToolDia * 0.25
      tool.RateUnits = Panel.MillTool2.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
      tool.FeedRate = Panel.MillTool2.FeedRate  -- 30
      tool.PlungeRate = Panel.MillTool2.PlungeRate   -- 10
      tool.SpindleSpeed = Panel.MillTool2.SpindleSpeed    -- 20000
      tool.ToolNumber = Panel.MillTool2.ToolNumber       -- 1
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
-- ===================================================]]
function CreateLayerPocketToolpath(name, layer_name, start_depth, cut_depth)
  if Panel.Pocket then
    local selection = Panel.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Panel.job.LayerManager:FindLayerWithName(layer_name)
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
    local tool              = Tool(Panel.MillTool2.Name, Tool.END_MILL)    -- BALL_NOSE, END_MILL, VBIT
          tool.InMM         = Panel.MillTool2.InMM            -- tool_in_mm
          tool.ToolDia      = Panel.MillTool2.ToolDia         -- tool_dia
          tool.Stepdown     = Panel.MillTool2.Stepdown        -- tool_stepdown
          tool.Stepover     = Panel.MillTool2.Stepover        -- tool_dia * (tool_stepover_percent / 100)
          tool.RateUnits    = Panel.MillTool2.RateUnits       -- Tool.MM_SEC     -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
          tool.FeedRate     = Panel.MillTool2.FeedRate        -- 30
          tool.PlungeRate   = Panel.MillTool2.PlungeRate      -- 10
          tool.SpindleSpeed = Panel.MillTool2.SpindleSpeed    -- 20000
          tool.ToolNumber   = Panel.MillTool2.ToolNumber      -- 1
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
          -- direction of cut for offet Clearance - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION - NOTE: enum from ProfileParameterData
          pocket_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
          -- Allowance to leave on when machining
          pocket_data.Allowance = 0.0
          -- if true use raster Clearance strategy , else use offset area Clearance
          pocket_data.DoRasterClearance = false --true
          -- angle for raster if using raster Clearance
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
    local display_warnings = false  -- true
   -- if we are doing two tool pocketing define tool to use for area Clearance
    local area_clear_tool = nil
    if type(Panel.MillTool3) == "userdata" then
   -- we just create a tool twice as large for testing here
    area_clear_tool = Tool(
                          Panel.MillTool3.Name,
                          Tool.END_MILL       -- BALL_NOSE, END_MILL, VBIT
                          )
     area_clear_tool.InMM         = Panel.MillTool3.InMM       -- tool_in_mm
     area_clear_tool.ToolDia      = Panel.MillTool3.ToolDia    -- tool_dia * 2
     area_clear_tool.Stepdown     = Panel.MillTool3.Stepdown   -- tool_stepdown * 2
     area_clear_tool.Stepover     = Panel.MillTool3.Stepover   -- tool_dia * 2 *(tool_stepover_percent / 100)
     area_clear_tool.RateUnits    = Panel.MillTool3.RateUnits  -- Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN
     area_clear_tool.FeedRate     = Panel.MillTool3.FeedRate      -- 30
     area_clear_tool.PlungeRate   = Panel.MillTool3.PlungeRate    -- 10
     area_clear_tool.SpindleSpeed = Panel.MillTool3.SpindleSpeed  -- 20000
     area_clear_tool.ToolNumber   = Panel.MillTool3.ToolNumber    -- 1
   -- Create our toolpath
    end
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
      DisplayMessageBox("Error creating Finger Toolpath")
      return false
    end
  end
  return true
end
-- ===================================================]]
function CreateLayerProfileToolpath(name, layer_name, start_depth, cut_depth, InOrOut)
  if Panel.LayerNProfile then
  --  Please Note: CreateLayerProfileToolpath is provided by Vectric and can be found in the SDK and Sample Gadget files.
    local selection = Panel.job.Selection  -- clear current selection
          selection:Clear()
  -- get layer
    local layer = Panel.job.LayerManager:FindLayerWithName(layer_name)
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
    local tool               = Tool(Panel.MillTool1.Name, Tool.END_MILL) -- BALL_NOSE, END_MILL, VBIT
          tool.InMM          = Panel.MillTool1.InMM         -- tool_in_mm
          tool.ToolDia       = Panel.MillTool1.ToolDia      -- tool_dia
          tool.Stepdown      = Panel.MillTool1.Stepdown     -- tool_stepdown
          tool.Stepover      = Panel.MillTool1.Stepover     -- tool_dia * 0.25
          tool.RateUnits     = Panel.MillTool1.RateUnits    -- Tool.MM_SEC -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC ...
          tool.FeedRate      = Panel.MillTool1.FeedRate     -- 30
          tool.PlungeRate    = Panel.MillTool1.PlungeRate   -- 10
          tool.SpindleSpeed  = Panel.MillTool1.SpindleSpeed -- 20000
          tool.ToolNumber    = Panel.MillTool1.ToolNumber   -- 1
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
    profile_data.UseTabs = false -- UseTab -- true to use tabs (position of tabs must already have been defined on vectors)
    profile_data.TabLength = 0.5 -- length for tabs if being used
    profile_data.TabThickness = 0.25
    profile_data.Use3dTabs = true -- if true then create 3d tabs else 2d tabs
    profile_data.ProjectToolpath = false -- if true in Aspire, project toolpath onto composite model
    local ramping_data = RampingData() -- Create object used to control ramping
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
    local display_warnings = false  --true -- if this is true we will display errors and warning to the user
    local toolpath_manager = ToolpathManager() -- Create our toolpath
    local toolpath_id = toolpath_manager:CreateProfilingToolpath(name, tool, profile_data,
                        ramping_data, lead_in_out_data, pos_data, geometry_selector, create_2d_previews, display_warnings)
    if toolpath_id == nil then
      DisplayMessageBox("Error creating Profile Toolpath")
      return false
    end
  end
  return true
end
-- ===================================================]]
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
-- ===================================================]]
function MakeLayers()
  local function GetColor(str) -- returns color value for a Color Name
  -- str = "Purple"
  -- returns = 128 0 128
  local sx = str
  local Colors = {}
  Colors.Black   = "0,0,0";     Colors.White   = "255,255,255"; Colors.Red     = "255,0,0"
  Colors.Blue    = "0,0,255";   Colors.Yellow  = "255,255,0";   Colors.Cyan    = "0,255,255"
  Colors.Magenta = "255,0,255"; Colors.Green   = "0,128,0";

  local Red, Green, Blue = 0
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
  local layer = Panel.job.LayerManager:GetLayerWithName(Panel.LayerNProfile)
  local Red, Green, Blue = 0, 0, 0
  Red, Green, Blue = GetColor(Panel.LayerNProfileColor)
  layer:SetColor (Red, Green, Blue)
  layer = Panel.job.LayerManager:GetLayerWithName(Panel.LayerNPinHole)
  Red, Green, Blue = GetColor(Panel.LayerNPinHoleColor)
  layer:SetColor (Red, Green, Blue)
  return true
end
-- ===================================================]]
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
  local layer = Panel.job.LayerManager:GetLayerWithName(LayerName)
  layer:AddObject(CreateCadContour(line), true)
  return true
end -- function end
-- ===================================================]]
function MarkPoint(Note, Pt, Size, LayerName)
  --[[
     |Code sourced from Vectric Lua Interface for Gadgets, version 2.05, published September 12, 2018. by Vectric Ltd.
     |Draws mark on the drawing
     |call = MarkPoint("Note: Hi", Pt1, 3, "Jim")
   ]]
      local function DrawCircle(job, Cpt, CircleRadius, LayerName)  -- Draws a circle
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
        local layer = job.LayerManager:GetLayerWithName(LayerName)
        layer:AddObject(CreateCadContour(line), true)
        return true
      end -- function end
    local job = VectricJob()
    local layer = job.LayerManager:GetLayerWithName(LayerName)
    local marker1 = CadMarker(Note, Pt, Size)
    layer:AddObject(marker1, true)
    DrawCircle(job, Pt, 0.25, LayerName)
  return true
end -- function end
-- ====================================================]]

function DrawHoles(pt, hand)
  -- Panel.WAng == 90.0
  -- Panel.HAng ==  0.0
  local wpt0, wpt1, wpt2, wpt3 = Point2D(0,0)
  Panel.HoleCount = math.floor(Panel.Length / Panel.HoleSpacing)
  Panel.HoleDist  = (Panel.Length - (Panel.HoleSpacing * Panel.HoleCount)) * 0.500
  Panel.BackHoleDist = (7 * Panel.HoleSpacing)
  if hand == "L" then
    if Panel.Orientation == "Horizontal" then
      wpt3 = Polar2D(pt, Panel.WAng, Panel.Width)
      wpt0 = Polar2D(wpt3, 270.00, Panel.FrontDist)
      wpt1 = Polar2D(wpt0,   0.00, Panel.HoleDist)
      wpt2 = Polar2D(wpt1, 270.00, Panel.BackHoleDist)
      for x = Panel.HoleCount + 1, 1, -1 do
        DrawCircle(wpt1, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
--        MarkPoint("X " .. x, wpt1, 3, "Jim")
        DrawCircle(wpt2, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
--        MarkPoint("Y " .. x, wpt2, 3, "Jim")
        wpt1 = Polar2D(wpt1,   0.00, Panel.HoleSpacing)
        wpt2 = Polar2D(wpt1, 270.00, Panel.BackHoleDist)
      end
    else -- Vertical
      wpt3 = Polar2D(pt, Panel.WAng, Panel.Width)
      wpt0 = Polar2D(wpt3, 180.00, Panel.FrontDist)
      wpt1 = Polar2D(wpt0,  90.00, Panel.HoleDist)
      wpt2 = Polar2D(wpt1, 180.00, Panel.BackHoleDist)
      for _ = Panel.HoleCount + 1, 1, -1 do
        DrawCircle(wpt1, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
        DrawCircle(wpt2, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
        wpt1 = Polar2D(wpt1, 90.00, Panel.HoleSpacing)
        wpt2 = Polar2D(wpt1, 180.00, Panel.BackHoleDist)
      end
    end
  else -- Right hand
    if Panel.Orientation == "Horizontal" then
      wpt0 = Polar2D(pt,   90.00, Panel.FrontDist)
      wpt1 = Polar2D(wpt0,  0.00, Panel.HoleDist)
      wpt2 = Polar2D(wpt1, 90.00, Panel.BackHoleDist)
      for _ = Panel.HoleCount + 1, 1, -1 do
        DrawCircle(wpt1, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
        DrawCircle(wpt2, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
        wpt1 = Polar2D(wpt1,  0.00, Panel.HoleSpacing)
        wpt2 = Polar2D(wpt1, 90.00, Panel.BackHoleDist)
      end
    else
      wpt0 = Polar2D(pt,    0.00, Panel.FrontDist)
      wpt1 = Polar2D(wpt0, 90.00, Panel.HoleDist)
      wpt2 = Polar2D(wpt1,  0.00, Panel.BackHoleDist)
      for _ = Panel.HoleCount + 1, 1, -1 do
        DrawCircle(wpt1, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
        DrawCircle(wpt2, Panel.PinHoleDia * 0.500, Panel.LayerNPinHole)
        wpt1 = Polar2D(wpt1, 90.00, Panel.HoleSpacing)
        wpt2 = Polar2D(wpt1,  0.00, Panel.BackHoleDist)
      end
    end
  end
  return true
end
-- ===================================================]]
function HTML()
 -- DialogWindow.StyleButtonColor = "#3a4660"
 DialogWindow.StyleButtonColor = "#663300"
 DialogWindow.StyleButtonTextColor = "#FFFFFF"
 DialogWindow.StyleBackGroundColor = "#3a4660"
 DialogWindow.StyleTextColor = "#FFFFFF"
-- =========================================================]]
DialogWindow.myBackGround = [[data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDACgcHiMeGSgjISMtKygwPGRBPDc3PHtYXUlkkYCZlo+AjIqgtObDoKrarYqMyP/L2u71////m8H////6/+b9//j/2wBDASstLTw1PHZBQXb4pYyl+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj/wAARCAHUAu4DASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDNApcUop1SUNxS4paWkMbijFOooAZijbT6QUAJto20/FGKAGYo20/FGKAGbaUClxTh0oAZtpdtOxS0hkZWjbTz1pMUxCbeKNtPxxRSGM20hWpKQ0AMxRtp9HemIZijbTwKMUgGbaXbTsUtAxm2jbT8UUAM20bafRQAwLS7aeBS4ouFiPbSbakxRii4WGbaAvNPxQBRcLDdtLtp+KMUrhYjK8Um2pSOKTFO4WGBaNtPA5pcUXCxHto21JijFFwsRbaCtPFBHFADAtG2n4pcUBYi20u2n4pcUXCwzbRtp+KMUBYj20bakpKAI9vNO204U7FFwsRFaNtSEZpMUXCxHto21JikxRcLCbaTbUlGKLhYZtpCtSYpCOaLhYj20u2nYp2KAsR7aNtPxRii4WIytGKeetFAEeKNtPxQKYhm2jbTsUYoAbto20+jFADMUbafSUAM20oXil707HFADNtJipKTFADNtG2n4pMUANApdtOFLQAzbSFafQaAI8UoWnYoFADcUwipaYaABadTRThQAUtFFABRijvS0gEpKWimAtLRSUhi0lLSUAFKKKBQAtFFFACGig0UAL2oo7UUAFBpRSN2oASjvRQaAFoNIKU0AFFFLQAlLijtSigBKQ0pooAFpaFopDFpKWkNABQOppaB1oAWiiigAPSkpT0pKAAUtIKWgAoPSgUvagBlB6UCg9KAAUtNpaAEpe1ApaAEpaO9Hc0AJiilNJQAg606kHUU6gBKKKKAEoNFFAC0UCigApvenUh60AJS0lLQAUUd6KAGnrRQetFMQlLSUUAFHeiigAoo7UUAGKSnUlACGlHSkpR0oAKKKKAEopaSgAFLSCloAKQ0tIaAE7UopKUUAIaYaeelMNMQLTqatOoAWiijvQAd6WkHWlpAJRQaKYDqKKKQwooooASndqbTqACiiigANJSmkoAXtS0gpaACkNKKDQAlIaWigBBSmkFLQAUtJS0AFLSUtIBDSU40hoAUdDS0L3paBiUUGjvQAhzTlpD1oWgB1FHeikAh6UlOPSm0wFHWl7Ug60tABR2ope1IBlFFFMBo606k70tACCloFAoAKBRSigAxTadTaAAdadTR1p5oASkpcUlABSClPSk70AOooNHagBKQ96dTTQAlOptOoASloooAaetJSnrSUxCGgUHpQKAA0UUtACUelLSd6AFpDS0hoASlHSkpw6UAFJS0lABSHrS0lACiigdKKACkNLQaAG0o6UlKKBAelMNPNMNMBBThTRTqAFpaTtS0AIKWjvRSGBpKU0lMQ6iiikMKO1FFAAaWkPSl7UAFFFLQAhpKU0UAFLSUtABQaWkNIBBQaKQ9aYCjpRRRQAUtHelpAFLSUooGBptOPSm+tADl6GlpF6U6gBKO9FFAB60L3ooXqaAFoopaQxOxpKd2ptAgFLQKWgBKXtRQelAxlKRSUHpTEJjml70CloASlFJ2p1ACdqBS0goAWmmnU00AA606m/xU6gApKWkoAQ9qD1pfSkNAC0UppKACkPWlpD1oASig0tACUtFFADT1o7UHrRTENNHajvS0AJS0UCgAoooo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]]
-- =======================================================]]
DialogWindow.myHImage = [[data:image/png;base64,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]]
-- =======================================================]]
DialogWindow.myVImage = [[data:image/png;base64,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]]
-- =========================================================]]
DialogWindow.Script = [[function myOrientation() {
  var e = document.getElementById("Panel.Orientation");
  var result = e.options[e.selectedIndex].text;
  if (result == "Horizontal"){
  document.getElementById('MyImage').src=']].. DialogWindow.myHImage ..[[';}
  else {
  document.getElementById('MyImage').src=']].. DialogWindow.myVImage ..[[';}
}

function codeAddress() {
  var e = document.getElementById("Panel.Orientation");
  var result = e.options[e.selectedIndex].text;
  if (result == "Horizontal"){
  document.getElementById('MyImage').src=']].. DialogWindow.myHImage ..[[';}
  else {
  document.getElementById('MyImage').src=']].. DialogWindow.myVImage ..[[';}
}
]]

-- =======================================================]] -- Style
DialogWindow.Style = [[<style type="text/css">html {overflow:hidden}
.DirectoryPicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}
.FormButton {font-weight:bold;width:75px;font-family:Arial, Helvetica, sans-serif;font-size:12px;white-space:nowrap;background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.LuaButton {font-weight:bold; width:120px; font-family:Arial, Helvetica, sans-serif;font-size:12px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.ToolNameLabel {font-family:Arial, Helvetica, sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}
.ToolPicker {font-weight:bold;text-align:center;font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;width:50px; background-color:  ]].. DialogWindow.StyleButtonColor ..[[ ;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.alert-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:  ]].. DialogWindow.StyleTextColor .. [[;text-align:center;white-space:nowrap}
.alert-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;text-shadow: 5px 5px 10px #FFF;color:#FF0101 ;text-align:left;white-space:nowrap}
.alert-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}
.error {font-family:Arial, Helvetica, sans-serif;font-size:18px;font-weight:bold;color:#FF0000 ;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px;}
.errorMessage {font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left; white-space:nowrap;padding-right:4px; padding-left:10px; padding-top:4px;padding-bottom:4px;}
.errorTable {background-color:#FFFFFF white-space:nowrap;}
.helpbutton{background-color:]].. DialogWindow.StyleButtonColor .. [[;border-style: ridge;border:2px solid #999;border-right-color:#666666;border-bottom-color:#666666;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial,Helvetica,sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:]].. DialogWindow.StyleButtonTextColor .. [[}
.helpbutton:active{border-right-color:#FFF; border-bottom-color:#FFF;border-top-color:#000; border-left-color:#000}
.helpbuttoni:hover{border-right-color:#000; border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}
.p1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left}
.p1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center}
.p1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right}
.ver-c {font-family:Arial, Helvetica, sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap color: #ffd9b3 ;}
.h1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap}
.h1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap}
.h1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap}
.h1-rp {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;}
.h1-rpx {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px}
.h2-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:]].. DialogWindow.StyleButtonColor .. [[ ;text-align:left;white-space:nowrap;text-shadow: 2px 2px white;}
.h2-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:]].. DialogWindow.StyleButtonColor .. [[ ;text-align:center;white-space:nowrap;text-shadow: 2px 2px white;}
.h2-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:]].. DialogWindow.StyleButtonColor .. [[ ;text-align:right;white-space:nowrap;text-shadow: 2px 2px white;}
.h3-bc {font-family:Arial, Helvetica, sans-serif; font-size:16px; font-weight:bold; text-align:center; white-space:nowrap}
.webLink-c {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;background-color: yellow;text-align:center;white-space:nowrap}
.jsbutton {background-color: ]].. DialogWindow.StyleButtonColor ..[[ ;width:60px; border:2px solid #999;border-right-color:#000;border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF; 12px;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none; font-size:12px; margin:1px 1px; color:]].. DialogWindow.StyleButtonTextColor .. [[ }
.jsTag-no-vis {font-family:Arial, Helvetica, sans-serif;font-size:10px;display:none; text-align:center; color:#00F; visibility: hidden;}
body {background-color: ]].. DialogWindow.StyleBackGroundColor  ..[[; background-position: center; overflow:hidden;font-family:Arial, Helvetica, sans-serif;font-size:12px; color: ]].. DialogWindow.StyleTextColor .. [[;
background-image: url(]].. DialogWindow.myBackGround ..[[); }html {overflow:hidden;}</style>]]
-- =========================================================]] -- About
DialogWindow.myHtmlAbout = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="header1-c" id="SysName">Easy Cabinet Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" id="Version" class="ver-c">Version</td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td> </tr> <tr> <td align="center" class="p1-l"><p class="p1-l">The ]] .. DialogWindow.AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br> <br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br> <br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td> </tr> <tr> <td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td> </tr> <tr> <td align="center" ><span class="header2-c">JimAndi Gadgets</span></td> </tr> <tr> <td align="center"><span class="h1-c">Houston, TX.</span></td> </tr> <tr> <td><hr></td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr></table></body></html>]]
-- =========================================================]] -- Layers
DialogWindow.myHtmlLayer =[[<html><head> <title>Layer Names</title> ]] .. DialogWindow.Style ..[[</head><body  text="#000000"> <table border="0" cellpadding="0" id="ValueTable"> <table> <tr> <td width="200" align="right" valign="middle" nowrap class="h1-rp"><span class="h1-r">Panel Profile Layer</span></td> <td width="300" align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Panel.LayerNProfile" type="text" class="h1-l" id="Panel.LayerNProfile" size="50" maxlength="50" /></td> <td width="150" align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Panel.LayerNProfileColor">Color</label> <select name="Color01" id="Panel.LayerNProfileColor"><option>Black</option><option>Red</option><option>Blue</option> <option>Yellow</option> <option>Cyan</option> <option>Magenta</option> <option>Green</option> </select></td></tr></table><table> <tr> <td width="200" align="right" valign="middle" nowrap class="h1-rp">Pin Hole Layer</td> <td width="300" align="right" valign="middle" nowrap class="h1-l" id="ValueTable"> <input name="Panel.LayerNPinHole" type="text" class="h1-l" id="Panel.LayerNPinHole" size="50" maxlength="50"/> </td> <td width="150"align="right" valign="middle" nowrap class="h1-l" id="ValueTable"><label for="Panel.LayerNPinHoleColor">Color</label> <select name="Panel.LayerNPinHoleColor" id="Panel.LayerNPinHoleColor"><option>Black</option><option>Red</option><option>Blue</option><option>Yellow</option><option>Cyan</option> <option>Magenta</option><option>Green</option></select></td> </tr></table><table width="100%" border="0" id="ButtonTable"> <tr> <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDK .. [[" target="_blank" class="helpbutton">Help</a> </strong></td> <td width="328" class="alert" id="GadgetName.Alert">.</td> <td width="" class="h1-c" style="width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> </tr></table></body></html>]]
-- =========================================================]] -- Milling
DialogWindow.myHtmlMilling = [[<html><head><title>Milling Information</title>]] .. DialogWindow.Style ..[[<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> </head> <body text = "#000000"><table width="560" border="0" cellpadding="0"> <tr> <td width="200" class="h1-rp">Part Layout Spacing</td> <td width="60" class="h1-l"><input name="Panel.PartGap" type="text" id="Panel.PartGap" size="10" maxlength="10" /></td> <td width="220" class="h1-rp">Milling or Drilling Holes</td> <td width="60" class="h1-l"><select name = "Panel.DrillOrMill" size = "1" id = "Panel.DrillOrMill">
  <option>Pocketing</option>  <option>Drilling</option> </select></td> </tr> </table> <table width="100%" border="0" id="ButtonTable"> <tr> <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDKMilling .. [[" target="_blank" class="helpbutton">Help</a> </strong> </td> <td width="328" class="alert" id="GadgetName.Alert">.</td> <td width="" class="h1-c" style="width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> <td width="89" class="h1-c" style="width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td>  </tr></table></body> </html>]]
-- =========================================================]] onload = "codeAddress()" onFocus="myDrillDisplay()"
DialogWindow.myHtmlPanexl = [[<html><head><title>Easy 32mm System</title>]] .. DialogWindow.Style ..[[<script> ]] .. DialogWindow.Script .. [[</script><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body background="" "text = "#000000" onload = "codeAddress()"><table width="570" border="0"> <tr> <td width="33%" align="center" ><input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Layers"></td> <td width="33%" align="center"><input id = "InquiryMilling" class = "LuaButton" name = "InquiryMilling" type = "button" value = "Milling"></td> <td width="33%" align="center"><input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About"></td> </tr> <tr> <td colspan="3"><hr></td> </tr></table> <table width="570" border="0"><tr> <td width="246" align="right"><table width="253" border="0"> <tr> <tr> <td nowrap class="h1-rp">Panel Width</td> <td><input name = "Panel.Width" type = "text" id = "Panel.Width" size = "10" maxlength = "10" /></td> </tr><tr> <td nowrap class="h1-rp">Panel Length</td> <td><input name = "Panel.Length" type = "text" id = "Panel.Length" size = "10" maxlength = "10" /></td> </tr> <tr> <td nowrap class="h1-rp">Hole Diameter</td> <td><input name = "Panel.HoleDia" type = "text" id = "Panel.HoleDia" size = "10" maxlength = "10" /></td> </tr> <tr> <td nowrap class="h1-rp">Hole Depth</td> <td><input name = "Panel.HoleDepth" type = "text" id = "Panel.HoleDepth" size = "10" maxlength = "10" /></td> </tr> <tr> <td nowrap class="h1-rp">Panel Sets</td> <td><input name = "Panel.Sets" type = "text" id = "Panel.Sets" value="1" size = "10" maxlength = "10" /></td> </tr> <tr> <td nowrap class="h1-rp"><label for="Panel.Orientation"> Drawing Orientation</label></td> <td><span class="h1-l"><select name="Panel.Orientation" id="Panel.Orientation" onchange = "myOrientation();"> <option selected>Horizontal</option> <option>Vertical</option> </select> </span></td> </tr> <tr> <td nowrap class="h1-rp">&nbsp;</td> <td>&nbsp;</td> </tr> <tr> <td nowrap class="h1-rp">&nbsp;</td> <td>&nbsp;</td> </tr> </table></td> <td width="314" align="center" valign="middle"><img name="MyImage" src=]].. DialogWindow.myHImage .. [[ width="300" height="300" alt=""></td> </tr> <tr> <td height="4" colspan="2"><hr></td> </tr></table>

<table width="570" border="0" id="ProfileTable"> <tr> <td width="140" class="h1-rp">Profile Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#00FFFF" class = "ToolNameLabel"><span id = "ToolNameLabel1">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton1" class = "ToolPicker" name = "ToolChooseButton1" type = "button" value = "Tool"> </strong></td> </tr></table><table width="570" border="0" id="PocketTable"> <tr> <td width="140" class="h1-rp">Pin Hole Tool Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#FFFF00" class = "ToolNameLabel"><span id = "ToolNameLabel2">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton2" class = "ToolPicker" name = "ToolChooseButton2" type = "button" value = "Tool"> </strong></td> </tr></table>

<table width="570" border="0" id="DrillTable1"> <tr> <td width="140" class="h1-rp">Pin Drilling Tool</td> <td width="328" nowrap = "nowrap" bgcolor="#66FF00" class = "ToolNameLabel"><span id = "ToolNameLabel3">-</span></td> <td width="69"><strong> <input id = "ToolChooseButton3" class = "ToolPicker" name = "ToolChooseButton3" type = "button" value = "Tool"> </strong></td> </tr></table>

<table width="570" border="0" id="ButtonTable"> <tr> <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td> </tr> <tr> <td width="75"><strong> <a href="]].. DialogWindow.SDK .. [[" target="_blank" class="helpbutton">Help</a> </strong></td> <td width="328" class="alert" id="GadgetName.Alert">.</td> <td width="" class="h1-c" style="width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> <td width="89" class="h1-c" style="width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> </tr></table></body></html>]]

-- =========================================================]] onload = "codeAddress()" onFocus="myDrillDisplay()"
DialogWindow.myHtmlPanel = [[<html>
<head>
<title>Easy 32mm System</title>
]] .. DialogWindow.Style ..[[<script> ]] .. DialogWindow.Script .. [[</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head><body background="" "text = "#000000" onload = "codeAddress()">
<table width="570" border="0">
  <tr>
    <td width="33%" align="center" ><input id = "InquiryLayers" class = "LuaButton" name = "InquiryLayers" type = "button" value = "Layers"></td>
    <td width="33%" align="center"><input id = "InquiryMilling" class = "LuaButton" name = "InquiryMilling" type = "button" value = "Milling"></td>
    <td width="33%" align="center"><input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About"></td>
  </tr>
  <tr>
    <td colspan="3"><hr></td>
  </tr>
</table>
<table width="570" border="0">
  <tr>
    <td width="246" align="right"><table width="253" border="0">
        <tr>
        <tr>
          <td nowrap class="h1-rp">Panel Width</td>
          <td><input name = "Panel.Width" type = "text" id = "Panel.Width" size = "10" maxlength = "10" /></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp">Panel Length</td>
          <td><input name = "Panel.Length" type = "text" id = "Panel.Length" size = "10" maxlength = "10" /></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp">Hole Diameter</td>
          <td><input name = "Panel.HoleDia" type = "text" id = "Panel.HoleDia" size = "10" maxlength = "10" /></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp">Hole Depth</td>
          <td><input name = "Panel.HoleDepth" type = "text" id = "Panel.HoleDepth" size = "10" maxlength = "10" /></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp">Panel Sets</td>
          <td><input name = "Panel.Sets" type = "text" id = "Panel.Sets" value="1" size = "10" maxlength = "10" /></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp"><label for="Panel.EndOption1"> Place 8mm construction dowels</label></td>
          <td><span class="h1-l">
            <select name="Panel.EndOption1" id="Panel.EndOption1">
              <option selected>Yes</option>
              <option>No</option>
            </select>
            </span></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp"><label for="Panel.EndOption2"> Place 5mm Top & Bottom holes</label></td>
          <td><span class="h1-l">
            <select name="Panel.EndOption2" id="Panel.EndOption2">
              <option selected>Yes</option>
              <option>No</option>
            </select>
            </span></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp"><label for="Panel.Orientation"> Drawing Orientation</label></td>
          <td><span class="h1-l">
            <select name="Panel.Orientation" id="Panel.Orientation" onchange = "myOrientation();">
              <option selected>Horizontal</option>
              <option>Vertical</option>
            </select>
            </span></td>
        </tr>
        <tr>
          <td nowrap class="h1-rp">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td width="314" align="center" valign="middle"><img name="MyImage" src=]].. DialogWindow.myHImage .. [[ width="300" height="300" alt=""></td>
  </tr>
  <tr>
    <td height="4" colspan="2"><hr></td>
  </tr>
</table>
<table width="100%" id="ProfileTable">
  <tr>
    <td width="140" class="h1-rp">Profile Tool</td>
    <td width="328" bgcolor="#00FFFF" class = "ToolNameLabel"><span id = "ToolNameLabel1">-</span></td>
    <td width="69"><strong>
      <input id = "ToolChooseButton1" class = "ToolPicker" name = "ToolChooseButton1" type = "button" value = "Tool">
      </strong></td>
  </tr>
</table>
<table width="570" border="0" id="PocketTable">
  <tr>
    <td width="140" class="h1-rp"><label id="DrillState">Pin Hole Tool</label></td>
    <td width="328" bgcolor="#FFFF00" class = "ToolNameLabel"><span id = "ToolNameLabel2">-</span></td>
    <td width="69"><strong>
      <input id = "ToolChooseButton2" class = "ToolPicker" name = "ToolChooseButton2" type = "button" value = "Tool">
      </strong></td>
  </tr>
</table>
<table width="100%" id="ButtonTable">
  <tr>
    <td colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td>
  </tr>
  <tr>
    <td width="75"><strong> <a href="]].. DialogWindow.SDK .. [[" target="_blank" class="helpbutton">Help</a> </strong></td>
    <td width="328" class="alert" id="GadgetName.Alert">.</td>
    <td width="" class="h1-c" style="width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td>
    <td width="89" class="h1-c" style="width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td>
  </tr>
</table>
</body>
</html>]]
-- =========================================================]]
  return true
end
-- ==================== End ==========================]]