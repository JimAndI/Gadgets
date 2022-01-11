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
-- Easy Seed Gadget Master is written by JimAndI Gadgets of Houston Texas 2020
-- =====================================================]]
require("mobdebug").start()
-- require "strict"
-- =====================================================]]
-- Global Variables --
local Tools1, Tools2
--  Table Values --
Milling           = {}
Project           = {}
Gear              = {}
DialogWindow      = {}
Milling.MillTool1 = {}
Gear.YearNumber = "2021"
Gear.VerNumber = "1.0"
Gear.AppName = "Easy Gear Maker"
Gear.RegName = "EasyGearMaker" .. Gear.VerNumber
Tool_ID1 = ToolDBId()
Tool_ID1:LoadDefaults("My Toolpath1", "")
DialogWindow.GearHelp = "http://www.jimandi.com/EasyGadgets/EasyCabinetMaker/Help/Base.html"
Milling.MillTool1.BitType = "END_MILL"
Gear.Calulated = false
-- =====================================================]]
function OnLuaButton_InquiryGearCalulate(dialog)
  if dialog:GetLabelField("ToolNameLabel1") == "No Tool Selected" then
    DisplayMessageBox("Error! You Must Select a Profile Tool First")
  else
    Gear.Calulated        = true
    Gear.Addendum         = dialog:GetDoubleField("Gear.Addendum")
    Gear.Dedendum         = dialog:GetDoubleField("Gear.Dedendum")
    Gear.AddendumDiameter = dialog:GetDoubleField("Gear.AddendumDiameter")
    Gear.DedendumDiameter = dialog:GetDoubleField("Gear.DedendumDiameter")
    Gear.ToothTickness    = dialog:GetDoubleField("Gear.ToothTickness")
    Gear.Slotwidth        = dialog:GetDoubleField("Gear.Slotwidth")
    Gear.PitchDiameter    = dialog:GetDoubleField("Gear.PitchDiameter")
    Gear.FilletRadius     = dialog:GetDoubleField("Gear.FilletRadius")
    Gear.ToothAngle       = dialog:GetDoubleField("Gear.ToothAngle")
    Gear.ToplandAmount    = dialog:GetDoubleField("Gear.ToplandAmount")
    Gear.FaceFlankRadius  = dialog:GetDoubleField("Gear.FaceFlankRadius")
    Gear.ToothCount       = dialog:GetDropDownListValue("Gear.ToothCount")
    Gear.ToothCountNum    = string.format("%.0f", Gear.ToothCount)
    Gear.PitchRadius      = dialog:GetDoubleField("Gear.PitchRadius")
    Gear.PitchChord       = dialog:GetDoubleField("Gear.PitchChord")
    GearMath()
    dialog:UpdateDoubleField("Gear.Addendum",                   Gear.Addendum)
    dialog:UpdateDoubleField("Gear.Dedendum",                   Gear.Dedendum)
    dialog:UpdateDoubleField("Gear.AddendumDiameter",           Gear.AddendumDiameter)
    dialog:UpdateDoubleField("Gear.DedendumDiameter",           Gear.DedendumDiameter)
    dialog:UpdateDoubleField("Gear.ToothTickness",              Gear.ToothTickness)
    dialog:UpdateDoubleField("Gear.Slotwidth",                  Gear.Slotwidth)
    dialog:UpdateDoubleField("Gear.ToothAngle",                 Gear.ToothAngle)
    dialog:UpdateDoubleField("Gear.PitchDiameter",              Gear.PitchDiameter)
    dialog:UpdateDoubleField("Gear.PitchChord",                 Gear.PitchChord)
    dialog:UpdateDoubleField("Gear.PitchRadius",                Gear.PitchRadius)
    dialog:UpdateDoubleField("Gear.FilletRadius",               Gear.FilletRadius)
    dialog:UpdateDoubleField("Gear.ToplandAmount",              Gear.ToplandAmount)
    dialog:UpdateDoubleField("Gear.FaceFlankRadius",            Gear.FaceFlankRadius)
    RegistryWrite(Gear.RegName)
  end -- if end
  return true
end -- function end
-- =====================================================]]
function InquiryMain(Header)
  local dialog = HTML_Dialog(true, DialogWindow.GearMain, 530, 631,  Header .. "  " .. DialogWindow.UnitDisplay)

  dialog:AddDropDownList("Gear.ToothCount",                   Gear.ToothCount)
  dialog:AddDropDownList("Gear.ShowLines",                    Gear.ShowLines)
  dialog:AddDoubleField("Gear.Addendum",                      Gear.Addendum)
  dialog:AddDoubleField("Gear.Dedendum",                      Gear.Dedendum)
  dialog:AddDoubleField("Gear.PitchChord",                    Gear.PitchChord)
  dialog:AddDoubleField("Gear.PitchRadius",                   Gear.PitchRadius)
  dialog:AddDoubleField("Gear.AddendumDiameter",              Gear.AddendumDiameter)
  dialog:AddDoubleField("Gear.DedendumDiameter",              Gear.DedendumDiameter)
  dialog:AddDoubleField("Gear.ToothTickness",                 Gear.ToothTickness)
  dialog:AddDoubleField("Gear.Slotwidth",                     Gear.Slotwidth)
  dialog:AddDoubleField("Gear.PitchDiameter",                 Gear.PitchDiameter)
  dialog:AddDoubleField("Gear.FilletRadius",                  Gear.FilletRadius)
  dialog:AddDoubleField("Gear.ToplandAmount",                 Gear.ToplandAmount)
  dialog:AddDoubleField("Gear.FaceFlankRadius",               Gear.FaceFlankRadius)
  dialog:AddDoubleField("Gear.ToothAngle",                    Gear.ToothAngle)
  dialog:AddLabelField("ToolNameLabel1",                      Milling.MillTool1.Name)
  dialog:AddToolPicker("ToolChooseButton1", "ToolNameLabel1", Tool_ID1)
  dialog:AddToolPickerValidToolType("ToolChooseButton1",      Tool.END_MILL)

  if dialog:ShowDialog() then
    Gear.Addendum         = dialog:GetDoubleField("Gear.Addendum")
    Gear.Dedendum         = dialog:GetDoubleField("Gear.Dedendum")
    Gear.PitchChord       = dialog:GetDoubleField("Gear.PitchChord")
    Gear.PitchRadius      = dialog:GetDoubleField("Gear.PitchRadius")
    Gear.AddendumDiameter = dialog:GetDoubleField("Gear.AddendumDiameter")
    Gear.DedendumDiameter = dialog:GetDoubleField("Gear.DedendumDiameter")
    Gear.ToothTickness    = dialog:GetDoubleField("Gear.ToothTickness")
    Gear.Slotwidth        = dialog:GetDoubleField("Gear.Slotwidth")
    Gear.PitchDiameter    = dialog:GetDoubleField("Gear.PitchDiameter")
    Gear.FilletRadius     = dialog:GetDoubleField("Gear.FilletRadius")
    Gear.ToplandAmount    = dialog:GetDoubleField("Gear.ToplandAmount")
    Gear.FaceFlankRadius  = dialog:GetDoubleField("Gear.FaceFlankRadius")
    Gear.ToothCount       = dialog:GetDropDownListValue("Gear.ToothCount")
    Gear.ShowLines        = dialog:GetDropDownListValue("Gear.ShowLines")
    Gear.ToothAngle       = dialog:GetDoubleField("Gear.ToothAngle")

    if dialog:GetTool("ToolChooseButton1") then
      Milling.MillTool1 = dialog:GetTool("ToolChooseButton1")  -- Profile
    end
    DialogWindow.InquiryMainXY  = tostring(dialog.WindowWidth) .. " x " ..  tostring(dialog.WindowHeight)
    RegistryWrite(Gear.RegName)
    return true
  else
    return false
  end
end
-- =====================================================]]
function OnLuaButton_InquiryToolClear(dialog)
  Milling.MillTool1.Name = "No Tool Selected"
  dialog:UpdateLabelField("ToolNameLabel1", Milling.MillTool1.Name)
  RegistryWrite(Gear.RegName)
  return true
end
-- =====================================================]]
function main(script_path)
  Gear.Loop = true
  Gear.Drawing = false
  Tools1 = assert(loadfile(script_path .. "\\EasyGearToolsVer" .. Gear.VerNumber .. ".xlua")) (Tools1) -- Load Tool Function
  Tools2 = assert(loadfile(script_path .. "\\EasyGearDialogVer" .. Gear.VerNumber .. ".xlua")) (Tools2) -- Load Tool Function
  HTML()
  ValidJob()
  RegistryRead(Gear.RegName)
  GetUnits()

 while Gear.Loop do
    Gear.Drawing = InquiryMain(Gear.AppName)
    if Drawing and (Milling.MillTool1.Name == "No Tool Selected") then
      DisplayMessageBox("Alert: The Gear Maker is not configured." ..
                        "\n A Profile bit must be selected.")
      CabLoop = true
      -- loop  -- if no Project Path
    elseif Gear.Calulated then
      DisplayMessageBox("Alert: The Calulate Gear button has not ran." ..
                        "\n Select the Calulate Gear button.")
      CabLoop = true
    else
      CabLoop = false
    end -- if end
  end -- while end

  return true
end  -- function end
-- ==================== End ============================]]