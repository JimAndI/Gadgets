-- VECTRIC LUA SCRIPT
------------------------------------------
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented;  you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
--
-- This Gadget was writen by JimAndi Gadgets of Houston, Texas. (January 2021) It supports all Vectric version to create both the Vectors and Toolpaths.
--
-- Please Note: The Easy Fence Post Cap Maker with Toolpaths is very heavily based on code from Vectric's core software SDK, Brian Moran and many other great developers.
-- ===================================================]]
require "strict"
-- require("mobdebug").start()
-- ===================================================]]
-- Global variables

--  Table Values --
Milling.MillTool1 = {}
Milling.MillTool2 = {}
Milling.MillTool3 = {}
Milling.MillTool4 = {}
PostCap           = {}
DialogWindow      = {}
Milling           = {}

local Tooler1
PostCap.AppName       = "Easy Fence Post Cap Maker"                -- Application Name
PostCap.Version       = "1.0"                                      -- Application Build Version
PostCap.RegistryTag   = "EasyFencePostCapMaker" .. PostCap.Version -- Registry Name with Versioning
PostCap.DialogLoop    = true
DialogWindow.MainHelp = "http://www.jimandi.com/EasyGadgets/EasyFencePostCapMaker/Help/index.html"
Tool_ID1 = ToolDBId()
Tool_ID2 = ToolDBId()
Tool_ID3 = ToolDBId()
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
Tool_ID3:LoadDefaults("My Toolpath3", "")

Milling.Tabs = false           --  User to setup Tabs
-- =====================================================]]
function OnLuaButton_InquiryToolClear(dialog)
  Milling.MillTool1.Name = "Not Selected"
  Milling.MillTool2.Name = "Not Selected"
  Milling.MillTool3.Name = "Not Selected"
  dialog:UpdateLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  dialog:UpdateLabelField("ToolNameLabel2", Milling.MillTool2.Name)
  dialog:UpdateLabelField("ToolNameLabel3", Milling.MillTool3.Name)
  RegistryWriter()
  return true
end
-- ===================================================]]
function InquiryPostCap()
  local dialog = HTML_Dialog(true, DialogWindow.Main, 585, 548, PostCap.AppName)
  dialog:AddLabelField("PostCap.Alert",                       "")
  dialog:AddLabelField("PostCap.AppName",                     PostCap.AppName)
  dialog:AddLabelField("PostCap.Version",                     "Version: " ..  PostCap.Version )
  dialog:AddLabelField("PostCap.Units",                       PostCap.Units)
  dialog:AddDoubleField("PostCap.MaterialLength", 	          PostCap.MaterialLength)
  dialog:AddDoubleField("PostCap.MaterialThickness",          PostCap.MaterialThickness)
  dialog:AddDoubleField("PostCap.SlopAmount", 	              PostCap.SlopAmount)
  dialog:AddDoubleField("PostCap.FlatAmount", 	              PostCap.FlatAmount)
  dialog:AddDoubleField("PostCap.CapSizeX",                   PostCap.CapSizeX)
  dialog:AddDoubleField("PostCap.CapSizeY",                   PostCap.CapSizeY)
  dialog:AddLabelField("ToolNameLabel1",                      Milling.MillTool1.Name)
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",      Tool.END_MILL)

  dialog:AddLabelField("ToolNameLabel2",                      Milling.MillTool2.Name)
  dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
  dialog:AddToolPickerValidToolType("ToolChooseButton2",      Tool.BALL_NOSE)

  dialog:AddLabelField("ToolNameLabel3",                      Milling.MillTool3.Name)
  dialog:AddToolPicker("ToolChooseButton3", "ToolNameLabel3", Tool_ID3)
  dialog:AddToolPickerValidToolType("ToolChooseButton3",      Tool.END_MILL)

	if dialog:ShowDialog() then
    PostCap.InquiryPostCapXY = tostring(dialog.WindowWidth) .. " X " .. tostring(dialog.WindowHeight)

    PostCap.CapSizeY    = dialog:GetDoubleField("PostCap.CapSizeY")
    PostCap.CapSizeX    = dialog:GetDoubleField("PostCap.CapSizeX")
    PostCap.FlatAmount  = dialog:GetDoubleField("PostCap.FlatAmount")
    PostCap.SlopAmount  = dialog:GetDoubleField("PostCap.SlopAmount")
    if dialog:GetTool("ToolChooseButton1") then
      Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile
    end
    if dialog:GetTool("ToolChooseButton2") then
      Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Carve
    end
    if dialog:GetTool("ToolChooseButton3") then
      Milling.MillTool3 = dialog:GetTool("ToolChooseButton3")  -- Clearing
    end
    RegistryWriter()
    return true
  else
    return false
	end
end  -- function end
-- ===================================================]]
function main(script_path)

Tooler1 = assert(loadfile(script_path .. "\\EasyFencePostCapToolsVer".. PostCap.Version .. ".xlua")) (Tooler1) -- Load Tool Function
-- Job Validation --
  PostCap.Job = VectricJob()
  if not PostCap.Job.Exists then
    DisplayMessageBox("Error: The Gadget cannot run without a job being setup.\n" ..
                      "Select: 'Create a new file' under 'Startup Tasks' and \n" ..
                      "specify the material dimensions \n")
    return false
  end

-- Get Data --
  RegistryReader()             -- First thing: Get/Reads all data values from the Registry
  HTML()
	-- Read the Material Configuration and set global setting
	GetMaterialSettings()

--| ========================]]
  while PostCap.DialogLoop do
    PostCap.Inquiry = InquiryPostCap(PostCap.AppName .. " Version " .. PostCap.Version)
    if PostCap.Inquiry then
      PostCap.DialogLoop = false
      CheckDialogValues()
    else
      PostCap.DialogLoop = false
    end -- if end
  end -- while end
  --| ========================]]
  if PostCap.Inquiry then
    PostCapMath()
    DrawCap()
    PostCap.Job:Refresh2DView()
    ToolPaths()
  end -- if end
  -- Regenerate the drawing display
  PostCap.Job:Refresh2DView()
  return true
end  -- function end
-- ===================================================]]