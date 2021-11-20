-- VECTRIC LUA SCRIPT
-- =====================================================]]
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
-- =====================================================]]
-- Run State
require("mobdebug").start()
-- require "strict"
-- =====================================================]]
-- Global Variables --
YearNumber = "2021"
VerNumber = "3.5" -- Version 1: Aug 2021 - Code Setup
AppName = "Easy Zank Toolpath Maker"
RegName = "EasyZankToolpathMaker" .. VerNumber
Tool_ID1 = ToolDBId()
Tool_ID2 = ToolDBId()
Tool_ID1:LoadDefaults("My Toolpath1", "")
Tool_ID2:LoadDefaults("My Toolpath2", "")
-- Table Names
DialogWindow      = {}
Material          = {}
Milling           = {}
Milling.MillTool1 = {}
Milling.MillTool2 = {}
DialogWindow.MainHelp = "http://www.jimandi.com/EasyGadgets/EasyZankMaker/Help/index.html"
DialogWindow.AppName  = "Easy Zank Toolpath Maker"
local Tool0, Tool1
-- =====================================================]]
function InquiryMain(Header)
  local dialog = HTML_Dialog(true, DialogWindow.Main, 607, 506,  Header .. "  " .. Milling.UnitDisplay)
  dialog:AddDoubleField("Milling.InlayThickness", Milling.InlayThickness)
  dialog:AddDoubleField("Milling.GlueGap", Milling.GlueGap)
  dialog:AddDoubleField("Milling.BaseDepth", Milling.BaseDepth)
  dialog:AddDoubleField("Milling.InlayWaste", Milling.InlayWaste)
  dialog:AddLabelField("ToolNameLabel1",                      Milling.MillTool1.Name)
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",      Tool.VBIT)
  dialog:AddLabelField("ToolNameLabel2",                      Milling.MillTool2.Name)
  dialog:AddToolPicker("ToolChooseButton2", "ToolNameLabel2", Tool_ID2)
  dialog:AddToolPickerValidToolType("ToolChooseButton2",      Tool.END_MILL)
  if dialog:ShowDialog() then
    Milling.InlayThickness = dialog:GetDoubleField("Milling.InlayThickness")
    Milling.GlueGap        = dialog:GetDoubleField("Milling.GlueGap")
    Milling.BaseDepth      = dialog:GetDoubleField("Milling.BaseDepth")
    Milling.InlayWaste     = dialog:GetDoubleField("Milling.InlayWaste")
    if dialog:GetTool("ToolChooseButton1") then
      Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Vcarve
    end
    if dialog:GetTool("ToolChooseButton2") then
      Milling.MillTool2 = dialog:GetTool("ToolChooseButton2")  -- Pocket
    end
    DialogWindow.MainXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryWrite()
    DisplayMessageBox("Alert! Due to the known issue with the SDK, \n YOU MUST EDIT EACH TOOLPATH AND \n ADD A CLEARING TOOL. \n See help for details")
    return true
  else
    return false
  end
end
-- =====================================================]]
function main(script_path)
  local loopIt = true
  Tool0 = assert(loadfile(script_path .. "\\EasyZankTool0Ver".. VerNumber .. ".xlua")) (Tool0) -- Load Tool Function
  Tool1 = assert(loadfile(script_path .. "\\EasyZankTool1Ver".. VerNumber .. ".xlua")) (Tool1) -- Load Tool Function
  ValidJob()
  GetMaterialSettings()
  Milling.Selection = Milling.job.Selection
  if Milling.Selection.IsEmpty  then
    DisplayMessageBox("This Gadget Requires one or more vectors to be selected")
    return false
  end
  RegistryRead()
  HTML()
  while loopIt do
    DialogWindow.Main = InquiryMain(DialogWindow.AppName)
    if DialogWindow.Main then
      if Milling.MillTool1.Name == "No Tool Selected" then
        DisplayMessageBox("A Carving Tool Must be Selected.")
        loopIt = true
      elseif Milling.GlueGap == 0 then
        DisplayMessageBox("The Glue Gap cannot equal zero.")
        loopIt = true
      elseif Milling.InlayThickness == 0 then
        DisplayMessageBox("The Inlay Thickness cannot equal zero.")
        loopIt = true
      elseif Milling.BaseDepth == 0 then
        DisplayMessageBox("The Inlay Thickness cannot equal zero.")
        loopIt = true
      else
        loopIt = false
        Mill_Math()
        MakeToolpaths()
      end -- if end
    else
      loopIt = false
    end
  end -- while end
  return true
end  -- function end
-- =====================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.About, 720, 487, "About")
  dialog:AddLabelField("SysName", DialogWindow.AppName)
  dialog:AddLabelField("Version", "Version: " .. VerNumber)
  dialog:ShowDialog()
  DialogWindow.AboutXY = tostring(dialog.WindowWidth) .. " x " .. tostring(dialog.WindowHeight)
  RegistryWrite()
  return  true
end
-- =====================================================]]
function OnLuaButton_InquiryToolClear(dialog)
  Milling.MillTool1.Name = "No Tool Selected"
  Milling.MillTool2.Name = "No Tool Selected"
  dialog:UpdateLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  dialog:UpdateLabelField("ToolNameLabel2", Milling.MillTool2.Name)
  RegistryWrite()
  return true
end
-- ==================== End ============================]]