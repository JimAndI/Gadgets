-- VECTRIC LUA SCRIPT
--[[
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--    If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

 -- Easy Dovetail Maker is written by JimAndi Gadgets of Houston Texas May 2020
]]
-- ===================================================]]
-- Global variables
-- require("mobdebug").start()
require "strict"
-- Table Names
local Dovetail = {}
local Tools = {}
local BitNumbers = {}
local DialogWindow = {}   -- Dialog Managment
DialogWindow.AppName = "Easy Dovetail Tool Database"
Dovetail.Version = "2.5"
Dovetail.SchemaVersion = "2.5"
Dovetail.RegBitName = "EasyDovetailToolDatabase" .. Dovetail.SchemaVersion
-- ===================================================]]
function RegistryBitRead(item)                             -- Read from Registry values
  local RegistryRead  = Registry(Dovetail.RegBitName)
  Dovetail.BitName    = RegistryRead:GetString("Bit" .. item .. "-BitName", "Amana Tool 45804 Carbide Tipped Dovetail 14 Deg x 0.5 D x 0.5 CH x 0.25 SHK")
  Dovetail.Brand      = RegistryRead:GetString("Bit" .. item .. "-Brand", "Amana Tool")
  Dovetail.PartNo     = RegistryRead:GetString("Bit" .. item .. "-PartNo", "45804")
  Dovetail.BitAngle   = RegistryRead:GetDouble("Bit" .. item .. "-BitAngle", 14.0)
  Dovetail.ShankDia   = RegistryRead:GetDouble("Bit" .. item .. "-ShankDia", 0.250)
  Dovetail.BitDia     = RegistryRead:GetDouble("Bit" .. item .. "-BitDia",   0.500)
  Dovetail.Flutes     = RegistryRead:GetInt("Bit"    .. item .. "-Flutes",   2)
  Dovetail.Type       = RegistryRead:GetString("Bit" .. item .. "-Type",     "Carbide Tipped")
  Dovetail.BitLength  = RegistryRead:GetDouble("Bit" .. item .. "-BitLength", 1.7500)
  Dovetail.CutDepth   = RegistryRead:GetDouble("Bit" .. item .. "-CutDepth",  0.5000)
  Dovetail.RPM        = RegistryRead:GetInt("Bit"    .. item .. "-RPM",       18000)
  Dovetail.FeedRate   = RegistryRead:GetInt("Bit"    .. item .. "-FeedRate",  24)
  Dovetail.PlungRate  = RegistryRead:GetInt("Bit"    .. item .. "-PlungRate", 12)
  Dovetail.Units      = RegistryRead:GetString("Bit" .. item .. "-Units", "inch")
  Dovetail.Rates      = RegistryRead:GetString("Bit" .. item .. "-Rates", "inches/min")
  Dovetail.Notes      = RegistryRead:GetString("Bit" .. item .. "-Notes", "Test 1")
  return true
end
-- ===================================================]]
function RegistryBitWrite(item)                            -- Write to Registry values
  local RegistryWrite = Registry(Dovetail.RegBitName)
  local RegValue = RegistryWrite:SetString("Bit" .. item .. "-BitName", Dovetail.BitName)
        RegValue = RegistryWrite:SetString("Bit" .. item .. "-Brand", Dovetail.Brand)
        RegValue = RegistryWrite:SetString("Bit" .. item .. "-PartNo" , Dovetail.PartNo)
        RegValue = RegistryWrite:SetDouble("Bit" .. item .. "-BitAngle", Dovetail.BitAngle)
        RegValue = RegistryWrite:SetDouble("Bit" .. item .. "-ShankDia", Dovetail.ShankDia )
        RegValue = RegistryWrite:SetDouble("Bit" .. item .. "-BitDia" , Dovetail.BitDia)
        RegValue = RegistryWrite:SetInt("Bit"    .. item .. "-Flutes" , Dovetail.Flutes)
        RegValue = RegistryWrite:SetString("Bit" .. item .. "-Type"  , Dovetail.Type)
        RegValue = RegistryWrite:SetDouble("Bit" .. item .. "-BitLength", Dovetail.BitLength)
        RegValue = RegistryWrite:SetDouble("Bit" .. item .. "-CutDepth" , Dovetail.CutDepth)
        RegValue = RegistryWrite:SetInt("Bit"    .. item .. "-RPM" , Dovetail.RPM)
        RegValue = RegistryWrite:SetInt("Bit"    .. item .. "-FeedRate" , Dovetail.FeedRate)
        RegValue = RegistryWrite:SetInt("Bit"    .. item .. "-PlungRate"  , Dovetail.PlungRate)
        RegValue = RegistryWrite:SetString("Bit" .. item .. "-Units" , Dovetail.Units)
        RegValue = RegistryWrite:SetString("Bit" .. item .. "-Rates"  , Dovetail.Rates)
        RegValue = RegistryWrite:SetString("Bit" .. item .. "-Notes" , Dovetail.Notes)
  return true
end
-- ===================================================]]
function Writex()                                       -- Write to Registry values
  local RegistryWrite = Registry(Dovetail.RegBitName)
  local RegValue = RegistryWrite:SetString("Bit001-BitName", "Amana Tool 45804 Carbide Tipped Dovetail 14 Deg x 0.5 D x 0.5 CH x 0.25 SHK")
        RegValue = RegistryWrite:SetString("AppInfo", "Easy Dovetail Tool Database Gadget. Data Schema Ver:".. Dovetail.SchemaVersion .. " Application Ver: ".. Dovetail.Version .." (Writen by: JimAndi Gadgets)")
        RegValue = RegistryWrite:SetString("Bit001-Brand", "Amana Tool")
        RegValue = RegistryWrite:SetString("Bit001-PartNo", "45804")
        RegValue = RegistryWrite:SetDouble("Bit001-BitAngle", 14.0000)
        RegValue = RegistryWrite:SetDouble("Bit001-ShankDia", 0.2500)
        RegValue = RegistryWrite:SetDouble("Bit001-BitDia", 0.5000)
        RegValue = RegistryWrite:SetInt("Bit001-Flutes", 2)
        RegValue = RegistryWrite:SetString("Bit001-Type", "Carbide Tipped")
        RegValue = RegistryWrite:SetDouble("Bit001-BitLength", 1.7500)
        RegValue = RegistryWrite:SetDouble("Bit001-CutDepth", 0.5000)
        RegValue = RegistryWrite:SetInt("Bit001-RPM", 18000)
        RegValue = RegistryWrite:SetInt("Bit001-FeedRate", 24)
        RegValue = RegistryWrite:SetInt("Bit001-PlungRate", 18)
        RegValue = RegistryWrite:SetString("Bit001-Units", "inch")
        RegValue = RegistryWrite:SetString("Bit001-Rates", "inches/min")
        RegValue = RegistryWrite:SetString("Bit001-Notes", "System Defalt bit 1 - Edit as needed")
        RegValue = RegistryWrite:SetString("Bit002-BitName", "PorterCable 43776PC Carbide Tipped Dovetail 7 Deg x 0.53125 D x 0.75 CH x 0.5 SHK")
        RegValue = RegistryWrite:SetString("Bit002-Brand", "PorterCable")
        RegValue = RegistryWrite:SetString("Bit002-PartNo", "43776PC")
        RegValue = RegistryWrite:SetDouble("Bit002-BitAngle", 7.0000)
        RegValue = RegistryWrite:SetDouble("Bit002-ShankDia", 0.5000)
        RegValue = RegistryWrite:SetDouble("Bit002-BitDia", 0.53125)
        RegValue = RegistryWrite:SetInt("Bit002-Flutes", 2)
        RegValue = RegistryWrite:SetString("Bit002-Type", "Carbide Tipped")
        RegValue = RegistryWrite:SetDouble("Bit002-BitLength", 2.5000)
        RegValue = RegistryWrite:SetDouble("Bit002-CutDepth", 0.7500)
        RegValue = RegistryWrite:SetInt("Bit002-RPM", 18000)
        RegValue = RegistryWrite:SetInt("Bit002-FeedRate", 24)
        RegValue = RegistryWrite:SetInt("Bit002-PlungRate", 20)
        RegValue = RegistryWrite:SetString("Bit002-Units", "inch")
        RegValue = RegistryWrite:SetString("Bit002-Rates", "inches/min")
        RegValue = RegistryWrite:SetString("Bit002-Notes", "System Defalt bit 2 - Edit as needed")
  return true
end
-- ===================================================]]
function all_trim(s) -- Trims spaces off both ends of a string
 return s:match( "^%s*(.-)%s*$" )
end -- function end
-- ===================================================]]
function OnLuaButton_InquiryAbout()
  local dialog = HTML_Dialog(true, DialogWindow.myHtml6, 720, 474, "About")
  dialog:AddLabelField("SysName", Dovetail.ProgramName)
  dialog:AddLabelField("Version", "Version: " .. Dovetail.Version)
  dialog:ShowDialog()
  -- MessageBox("X=" .. tostring(dialog.WindowWidth) .. "   Y=" .. tostring(dialog.WindowHeight))
  return  true
end
-- ===================================================]]
function pad(s)                                         -- returns a string with leading zeros
  local x = tostring(s)
  if #x == 1 then
    x="00" .. x
  elseif #x == 2 then
    x="0" .. x
  end
  return x
end
-- ===================================================]]
function BitHeaderReader()
  local RegistryRead = Registry(Dovetail.RegBitName)
  local count = 255
  local countx = 1
  for _ = count, 0 , -1   do
    if RegistryRead:StringExists("Bit" .. pad(countx) .. "-BitName") then
      table.insert(BitNumbers, pad(countx))
      table.insert(Tools, RegistryRead:GetString("Bit" .. pad(countx) .. "-BitName", "Error: No Bits Found in Registry"))
    end
    countx = countx + 1
  end
  if #Tools == 0 then
    Writex()
    Write2x()
    return false
  else
    return true
  end
  return true
end
  -- ===================================================]]
function BitReaders(str)
  local RegistryRead = Registry(Dovetail.RegBitName)
  for _, value in pairs(BitNumbers) do
      if string.upper(RegistryRead:GetString("Bit" .. value .. "-BitName", "X")) == str then
        Dovetail.BitNumber = value
        break
      end
  end ;
  return Dovetail.BitNumber
end
-- ===================================================]]
function InquiryBitList(Header, Quest, XX, YY, DList)
local dialog = HTML_Dialog(true, DialogWindow.myHtml1, XX, YY, Header)
   dialog:AddLabelField("Questions", Quest)
   dialog:AddLabelField("Dovetail.Aleart", "") ;
   dialog:AddDropDownList("ListBox", "Make a Slection")
   dialog:AddDropDownListValue("ListBox", "=================================== Add New ======================================")
   for _, value in pairs(DList) do
      dialog:AddDropDownListValue("ListBox", value)
   end
   if not dialog:ShowDialog() then
    return ""
   else
     -- MessageBox("X = " .. tostring(dialog.WindowWidth) .. " and  Y = " .. tostring(dialog.WindowHeight))
    return string.upper(dialog:GetDropDownListValue("ListBox"))
   end
end
-- ===================================================]]
function InquiryTool(Header)
  local dialog = HTML_Dialog(true, DialogWindow.myHtml2, 530, 480,  Header)
  dialog:AddTextField("Dovetail.Brand",       Dovetail.Brand)
  dialog:AddTextField("Dovetail.PartNo",      Dovetail.PartNo)
  dialog:AddTextField("Dovetail.Type",        Dovetail.Type)
  dialog:AddTextField("Dovetail.Notes",       Dovetail.Notes)
  dialog:AddIntegerField("Dovetail.Flutes",   Dovetail.Flutes)
  dialog:AddIntegerField("Dovetail.RPM",      Dovetail.RPM)
  dialog:AddDoubleField("Dovetail.BitAngle",  Dovetail.BitAngle)
  dialog:AddDoubleField("Dovetail.ShankDia",  Dovetail.ShankDia)
  dialog:AddDoubleField("Dovetail.BitDia",   Dovetail.BitDia)
  dialog:AddDoubleField("Dovetail.BitLength", Dovetail.BitLength)
  dialog:AddDoubleField("Dovetail.CutDepth",  Dovetail.CutDepth)
  dialog:AddDoubleField("Dovetail.FeedRate",  Dovetail.FeedRate)
  dialog:AddDoubleField("Dovetail.PlungRate", Dovetail.PlungRate)
  dialog:AddDropDownList("UnitList",          Dovetail.Units)
  dialog:AddDropDownList("RateList",          Dovetail.Rates)
  if  dialog:ShowDialog() then
      Dovetail.Brand     = dialog:GetTextField("Dovetail.Brand")
      Dovetail.PartNo    = dialog:GetTextField("Dovetail.PartNo")
      Dovetail.Type      = dialog:GetTextField("Dovetail.Type")
      Dovetail.Notes     = dialog:GetTextField("Dovetail.Notes")
      Dovetail.RPM       = dialog:GetIntegerField("Dovetail.RPM")
      Dovetail.Flutes    = dialog:GetIntegerField("Dovetail.Flutes")
      Dovetail.BitAngle  = dialog:GetDoubleField("Dovetail.BitAngle")
      Dovetail.ShankDia  = dialog:GetDoubleField("Dovetail.ShankDia")
      Dovetail.BitDia    = dialog:GetDoubleField("Dovetail.BitDia")
      Dovetail.BitLength = dialog:GetDoubleField("Dovetail.BitLength")
      Dovetail.CutDepth  = dialog:GetDoubleField("Dovetail.CutDepth")
      Dovetail.FeedRate  = dialog:GetDoubleField("Dovetail.FeedRate")
      Dovetail.PlungRate = dialog:GetDoubleField("Dovetail.PlungRate")
      Dovetail.Units   =   dialog:GetDropDownListValue("UnitList")
      Dovetail.Rates   =   dialog:GetDropDownListValue("RateList")
 -- MessageBox("X = " .. tostring(dialog.WindowWidth) .. " and  Y = " .. tostring(dialog.WindowHeight))
      return true
    else
      return false
  end
end
-- ===================================================]]
function main() --script_path
 -- Dovetail.ToolPath = script_path
  --Dovetail.Drawing = InquiryDovetail("Easy Dovetail Maker")
  -- Read the Headers from the ini file
  Dovetail.ProgramName = "Easy Dovetail Tool Database"

--CheckMissingBits()
  if not(BitHeaderReader()) then
    BitHeaderReader()
  end
  HTML()
  -- Display dialog and load list in drop down list
  table.sort(Tools)
 local SelTool = InquiryBitList("Dovetail Bit Tool Database", "Select a Bit or Add New Bit", 723, 469, Tools)
 if not(SelTool == "") then
    if not(SelTool == "=================================== ADD NEW ======================================") then
       RegistryBitRead(BitReaders(SelTool))
      -- Dialog to Edit Tools Data
      if InquiryTool("Edit Dovetail Bit") then
        Dovetail.BitName = all_trim(Dovetail.Brand) .. " " .. all_trim(Dovetail.PartNo) .. " " .. all_trim(Dovetail.Type) .. " Dovetail " ..  tostring(Dovetail.BitAngle) .. " Deg x " .. tostring(Dovetail.BitDia) .. " D x " .. tostring(Dovetail.CutDepth) ..  " CH x " ..  tostring(Dovetail.ShankDia) .. " SHK"
        RegistryBitWrite(Dovetail.BitNumber)
      end
      Tools = {}
      BitNumbers = {}
      main()
    else
      -- Dialog New Tools Data
      Dovetail.Brand     = "Enter Brand"
      Dovetail.PartNo    = "Part ID"
      Dovetail.Type      = "Carbide Tipped"
      Dovetail.Notes     = "Enter a New Bit Data"
      Dovetail.RPM       = 10000
      Dovetail.Flutes    = 2
      Dovetail.BitAngle  = 7.000
      Dovetail.ShankDia  = 0.500
      Dovetail.BitDia    = 0.750
      Dovetail.BitLength = 3.0
      Dovetail.CutDepth  = 0.875
      Dovetail.FeedRate  = 20
      Dovetail.PlungRate = 18
      Dovetail.Units     = "inch"
      Dovetail.Rates     = "inches/min"
      if InquiryTool("Enter New Dovetail Bit Data") then
        Dovetail.BitName = all_trim(Dovetail.Brand) .. " " .. all_trim(Dovetail.PartNo) .. " " .. all_trim(Dovetail.Type) .. " Dovetail " ..  tostring(Dovetail.BitAngle) .. " Deg x " .. tostring(Dovetail.BitDia) .. " D x " .. tostring(Dovetail.CutDepth) ..  " CH x " ..  tostring(Dovetail.ShankDia) .. " SHK"
        RegistryBitWrite(pad(#Tools + 1))
        Tools = {}
        main()
      end
    end
  end
  return true
end
-- ===================================================]]
function HTML()
 DialogWindow.StyleButtonColor = "#3a4660"
 DialogWindow.StyleButtonTextColor = "#FFFFFF"
 DialogWindow.StyleBackGroundColor = "#3a4660"
 DialogWindow.StyleTextColor = "#FFFFFF"
 -- ]].. DialogWindow.StyleTextColor .. [[
-- ]].. DialogWindow.Style .. [[
-- =========================================================]]
DialogWindow.myBackGround = [[data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDACgcHiMeGSgjISMtKygwPGRBPDc3PHtYXUlkkYCZlo+AjIqgtObDoKrarYqMyP/L2u71////m8H////6/+b9//j/2wBDASstLTw1PHZBQXb4pYyl+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj/wAARCAHUAu4DASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDNApcUop1SUNxS4paWkMbijFOooAZijbT6QUAJto20/FGKAGYo20/FGKAGbaUClxTh0oAZtpdtOxS0hkZWjbTz1pMUxCbeKNtPxxRSGM20hWpKQ0AMxRtp9HemIZijbTwKMUgGbaXbTsUtAxm2jbT8UUAM20bafRQAwLS7aeBS4ouFiPbSbakxRii4WGbaAvNPxQBRcLDdtLtp+KMUrhYjK8Um2pSOKTFO4WGBaNtPA5pcUXCxHto21JijFFwsRbaCtPFBHFADAtG2n4pcUBYi20u2n4pcUXCwzbRtp+KMUBYj20bakpKAI9vNO204U7FFwsRFaNtSEZpMUXCxHto21JikxRcLCbaTbUlGKLhYZtpCtSYpCOaLhYj20u2nYp2KAsR7aNtPxRii4WIytGKeetFAEeKNtPxQKYhm2jbTsUYoAbto20+jFADMUbafSUAM20oXil707HFADNtJipKTFADNtG2n4pMUANApdtOFLQAzbSFafQaAI8UoWnYoFADcUwipaYaABadTRThQAUtFFABRijvS0gEpKWimAtLRSUhi0lLSUAFKKKBQAtFFFACGig0UAL2oo7UUAFBpRSN2oASjvRQaAFoNIKU0AFFFLQAlLijtSigBKQ0pooAFpaFopDFpKWkNABQOppaB1oAWiiigAPSkpT0pKAAUtIKWgAoPSgUvagBlB6UCg9KAAUtNpaAEpe1ApaAEpaO9Hc0AJiilNJQAg606kHUU6gBKKKKAEoNFFAC0UCigApvenUh60AJS0lLQAUUd6KAGnrRQetFMQlLSUUAFHeiigAoo7UUAGKSnUlACGlHSkpR0oAKKKKAEopaSgAFLSCloAKQ0tIaAE7UopKUUAIaYaeelMNMQLTqatOoAWiijvQAd6WkHWlpAJRQaKYDqKKKQwooooASndqbTqACiiigANJSmkoAXtS0gpaACkNKKDQAlIaWigBBSmkFLQAUtJS0AFLSUtIBDSU40hoAUdDS0L3paBiUUGjvQAhzTlpD1oWgB1FHeikAh6UlOPSm0wFHWl7Ug60tABR2ope1IBlFFFMBo606k70tACCloFAoAKBRSigAxTadTaAAdadTR1p5oASkpcUlABSClPSk70AOooNHagBKQ96dTTQAlOptOoASloooAaetJSnrSUxCGgUHpQKAA0UUtACUelLSd6AFpDS0hoASlHSkpw6UAFJS0lABSHrS0lACiigdKKACkNLQaAG0o6UlKKBAelMNPNMNMBBThTRTqAFpaTtS0AIKWjvRSGBpKU0lMQ6iiikMKO1FFAAaWkPSl7UAFFFLQAhpKU0UAFLSUtABQaWkNIBBQaKQ9aYCjpRRRQAUtHelpAFLSUooGBptOPSm+tADl6GlpF6U6gBKO9FFAB60L3ooXqaAFoopaQxOxpKd2ptAgFLQKWgBKXtRQelAxlKRSUHpTEJjml70CloASlFJ2p1ACdqBS0goAWmmnU00AA606m/xU6gApKWkoAQ9qD1pfSkNAC0UppKACkPWlpD1oASig0tACUtFFADT1o7UHrRTENNHajvS0AJS0UCgAooooAKDRQaAG04dKb2pw6UAFJS0lABSdqWjtQADpRQOlFABQaKDQAlAooFAhDTTTzTD1pgIKdTRTqAFpaSloAO9LSClpDENJSmkoEOoNLSUDCjtRRQAUvak7UvagApaSloAQ0UGkoAcOlFFFAC0hpe9IaQCd6DQKD1pgApaSloAKUUlKKQwpR0pKdQAh6UlKaSgBV706mr3p3agBKO9FAoABSr1NAoHU0ALRRRSGHakpx6U2gQClpB3paBhQelL2oPSgBnaj+GilPSmIaODS0gpaAClpKWgAoHWlpBSGLTTTqaaBCd6fTe4p1ACGkpTSUwD0oPaig0AKaSlNFABTT1p1NNACUtJTqAEoopaAGHrSd6caQUxDTSijvRQAUUUUAFFFHegBaQ0tIaAEpR0pKUdKACkpTSUAFFFFAAOlFA6UUALSHpS0hoASgUUCgANMNPNMNMQi06min0AFLSUtIAFLSCloGJSUppKAH0lLSGgAooooAWjtRS9qAEpaKKAENFBooAXtSigdKKQw70hpaGoAaKD1pRSEHNMQDpSmiigBe9AopRSGFLSUtAA1Npx6UlACr3paRe9L2oASgUUtAAKUdaBQOtIYd6WjFFAAelNpx6U2gBV60tC9aWgA7UdqKO1ADKD0opSOKBDB1p1IAfSlpgFFFLSAKBS0AUDDtTT1p1NNACd6fTO4p9ADTSUpooEFBoFBoADRSmigBKaadTTTASnUlOoASjvRR3oAaetIKU9aBQAw9aWjByeKKYg70UUUALSUtFAB3pDS0hoASlHSkpR0oAKSlNJQAUtJS0AIOlFKKKACkNLSGgBKBRSigBDTG6080xqYhFp4pi08UAFOppp1IYUUUd6AENFBooAdSGloNACUopKUUAJ3p3am07tQAUGiigBKKKKAHDpRSClpDFpDS0jUAJ3pwpKUUAIaKDRQAUq9KKFoAdRRRSAQ9KSnHpTaYCrTu1ItLSAb3paKWgBG6Uq0HmlXvQMWiiigBtFKaSgAXrTqQUtAC0dqKO1IBlOFJSimAGm089KZQACgdRSikHUUAOopaSgAppp1NNACd6dTe9PoAa1JSmigAFNHWndqToaAHUlKaSgBDTaeabTEIetOpp60tAC0d6BRQA09aQUrdaSgBaaetOpp60AFBooNMQo6UUDpRSGIaDS0hpiG0o6UlKOlAC02nU2gAoPWl70hoAUdKKB0ooAKbTqbQAUCigUABphp5phpiEFPFMFPFABTqbTqQwooooAQ9aKDRQA6iikoAKUUlKKADtS9qKO1ABRRRQAlFFFACilpBS0hhmg0UGgAFKOlJSigBDSU40lAAe1KtJTloAWiiigAPSkpTTe9ADl70tItKaQw70d6KB1oAXvQvU0ooHWgAoo70tADTRSmkoABS0DrS0AGcUZ4oo7UgG04UgpRTAG6UzvTzTaADsaQdRS9qB1oAdSUtFIA70w06mmmAd6dTR1FOoAQ9KSlpKADtQaX0oNAAaSlNFACGmmndqbQIQ0tBpaYCUZpaSgBD1pKU0UAL2php1IetACUHrRSUxDh0oNA6UUhiUGlpDQIbSjpSU4dKYBSUGigA70UUdqAAdKKBRQAUlLSGgBKKKBQAGmGnmmHrTEItPpopwoAO9OptOpDCiiigBKKDRQA6kpaKACgUUdqACl7UlO7UAIKKWkpDA9aKKKYhRS0nalpDEoNLSHtQAClFIOtOoAQ9aSlNJQAtKtJ2pVoAWiiikMKTvTj0pvrTEKtKaFpTSGJRS0DrQAp6ULRjNC9TQAveiloNIY00ClPSkpiAU6kFKKQBRS96SgY2lpO1OFAhD0pKdTe9MA9KQdaWgdaAHUlLSUhhTTTxTDTEIOtOpP4qd2oAbQaWkoABSU7tSEYoAU0nanUlADaQ9adTaAENLSGlpiCkpaDQA09aKU9aSgBaae9OppoATvR6UUUCFHSigdKKBiUhp1IaAG04dKSlHSmISiiigAoNFFAAOlFA6UUAFIaWkNACUopKUUAIaYetPphpiAU6mCn0AFOptOpDCjvQOtFAAaSlooAWiiigAopaSgBaUdKSigBaKSlpDE70Ud6KYhfSlpO1LSGFJ6UtBoAKKO9FAB2pKU9KSgBaVaSlHSgBaWkp1IYh6UlLjikoEKtOpBS0DCkpRR2oAXoKB1oooAWg0lL2pDA0lKelIKBAKUdqF60tAwpO9LQaAG0tJ2paADvTTTu9NoEFHcUUvemAtFFA6GkMBwaaacRzSUCGjrTqTvTqAEpKXvQaAEFIeaWimAtJRmigBKb3p1N70ABpe9IaWgApD0paTtQAh60lKetJTEB6Uhpe1IaAEoNFFMQo6Ud6O1HekMDSGlNIaAEpR0pKUdKYgpKXtRQAlFLSUAApaSigApDS0hoAKO1FAoADUZqQ1G1MQgp4pi0/tQAU6m06kMB1paSloAQ0UGigBaKKKAFpO9LQetABRRSUAKKWk70tIYho7UGjtQIX0paB0ooGAoNFBoAKKKO1AB2pKU0UAFKvSm+9OWgB1LSUtIYh6UUHpRQAopRzQvelxQACg9KBSnpSAQCj0o60HtQAUvajtR2oGB6UlKelAoAB3paF6ml70AJSnpR3pKAE7UtAooATvSUppKACgdRQfSgdaBDsUCigUDA03vTqb3oAO9Lmk704jmgBKKKWgBh6mg0ueaTtTEJ2oFApR1oASkPWlpD1oAQ0vekNONACGig0lACHrRQetFMQh6UhpaQ0AJRS033oEOHSl70g6UUDFNNNOppoASl7UlOHSgQlFLRTGIaSlNJQIO9JS96KACkNLSGgAoHSigUABqM1IajPWmhCCn0xaeKAA06m9aWkMUUtIKWgBDRQetHagB3aikFLQAUGikPWgBaTvSikoAdRSUtIYhooNLQIOwpaB0ooGFBoooAKKO9FAAaBQaO1AAOlKvSkz0FKKAFp/amYp46UhiHpSd6U9KT+KgBy96UdaaKdQAClPSig9KQxBig0Cg9RQIUcil7U0U4dKBidqBS9qQUAKvU/SigdaWgBKWk70UAAFFHagUAFNp3am0AH8Qo/ioz1NA7UCHd6UUlKKBi0w/1p9MPegA9KU0npS0ABooNFADe/NBHFB60nYimIQUtJS9xQAlJ3p1NPWgANKaQ0tACUlKaSgQh60Ud6O9MBDSGlpD1oAO1J2oNGcmgQo6UUDpRQMWkNLSHtQA2nDpSetA6UCFooooGIaKD0pKYgNFIetHagBaQ0tIaACgdDRRQAhph61IajPWmIRaf2pi0+gApwpuMUtIBaWkFLQMQ0dqO9HagBRS0UUAApD1paQ9aACilFJQAtLSUtIYhpaQ0tACiigdBRQAUlLRQAd6WkpaAEPWk9KU0dqAA96UdaTGcGlWgB1OFMp4pDA9Kb3px6U3vQAop1ItOFABQelAoPSkMaKX0oGTQeooEFOHSkUUo6UDDtQOtHagUAAp1NHX8KWgA70lKaKAE7UtJ2pRQAh6U31p3akoATtR3/GlwMkUgGMCgQ+gUntSigYtMPen0w9DQAd6Wk9KdQAhooNFADD1opT1owcGmIb2pe9J7UuORQAU09adTT1oADS0hpaAENIaWkoEJ3oo70UwDvTT1pxpp60AHekpTSEc5oEKOlLSDpRQMWkalpD2oAT1oHSjvSjpTEFFFFIYhpKU9KSmIO9JSnrR2oAKQ0tIaADtQKKPWgANRnrUhqM9aYhBT+1NFOoADTqbTqQwpaQUtACGig9aKAHdqKTNLQAUHrRQetABSd6WgUAL3opO9LSGIaXtSGl7UCF7CigdKKBgOaDRQaACloo7UAIaBQaKAAdDTl6U3HNOXpQAtOHSm06kMD0popT0pKAHr3pR1pq96UGkAooPSgUHpQMAaDRj0oPagAHAp3ako7UAB6UCg9KBQAq/eNGKB1NLQAlKRSd6WgBBRQKKAEpKX1pKAA/eFH8VHUUDqPegB3egUUCgBaYev406m96ACnGm96UnmgANFFFADeho7UuATSUAIKWkFApiCmnrTqaetAAaUikNKaAENGM0GigBp60Up60lMQGmmnGmmgA7UnalpMfpQAo6UtA6UUAFIaWkNACUo6UlAPFAhaKKKBiGig0mPSmIDRR3ooAKQ0tIaACgd6KB0oADUbdakNRnrTQmApwpop1ABTqbTqQwHWlpBRQAGiiigBaKKKAFpD1paKACiilxQAgpaMUUhiGjtR3ooEO7UUdhRQMUUhpaQ0AFLSd6WgBD0oo7UUALSr0pKVelAC9qdTaWkMD0pKO1FADhSj2pFpaAFFB6Ugpc0hiCl7iilHNACdTTu1JiloAQ9KKD0oFACr1NLTV604UAFBooNAhtLSdqWgYd6bTu9NNABR3FFHegB1KO9JQOhoAU9aYetOPWm0AFLikHWnUAJ3oo70E0ANPU0UtJQITtQKXFGKAEpDS03vTADS0hpaACkpaTtQAh60lKetJTEHakNKelIaAEooooEHalpB0o70DFNIaU000AFHakpw6UCCiko7UABpKWimAneilpMUAFIaWkNABQOlFA6UABqM1IajamIBThTRThQAU6m06kMKO9FFAAaSlNJQA6iiigAooooAWlHSm06kMKKKKAE70UGimAvpS0g6UtIBaT0paQ9qAAUtJ3pRQAHpSd6U0lAC0q0nalFAC0tJS0hgelJSk8U31oActOpq0poAWgUUCkAvUUq9TTaVe9Ax1FFFACGig9KSgBRSjpSLS0ALR3oooAbS0nalFAB3ptPNNPWgBKP4hQKB1/GgB1FFFAAKaadTDQADrTqb3p3agBKDRSGgAoPFHak70CHGkpTSUDEpvenU00xAaO9IadQAlBooNADT1ooPWjvTEFIadTTQAlBoo9KAAdKWgdKDQAhoaikNACUopKUdKYgooNFACUtIKKAFFFA6UUAJSGlpDQAUdqKBQAGozUlRmmIFpw6UwU8UAFOptOpDCiiigApKU0lADqKKKACgUUUALS9qSl7UgAUUUUDENFFFMQopaQUtIYUGig0AApRSClHSgAPWkpTSUALSr0pppy0AOpKKKQwNJ3pTSUAOWlNItLQAUd6KB1oAd1FKtIKB1NIYveijvRQAHpSCg0UAKOtLTRThQAUdqKO1ACClptOFAAelNpxplAC+lA60dqQfeFAElJ1oooASmnvTqaaAAdqdTe4p1ADaDQaKBAKMYo9KDQMU9KTtQaSgQdqaetO7U2mAhpaQ0tAAaSlpKAEPWig0UxBSHqad2pp60AJ3pPSlpDQA4dKDQOlFACUhpe9IaAE70o6UlKOlMQGkpaSgAoNApe1AAKSgUUAFIaWkNABQKSloADUZ61IajbrTQhFp4pi08UAGMU6kpaQwoopaAEPWkpTSUAOoooNABQKKBQAHpTu1Np3agAooopDEooopiFFLSClFIYuKQ0tI1AAKcOlNpRQAh60UNRQAuOhpVpKVaAFpRRRSGIelJSnpSUAOXvTqYtOoATvS96SloAXvSr1NI3FKvekAtFFFAxDSUppKAFFLSLTqADFGOKWjtQAynCm0ooAVulMp56UztQAvWkHBApRQOooAdSUvaigA70ynU00AJ3p9M7inUAI1JStSUxC9qQ9qXtTc5NADzTacaSkAhphp5plMANLSd6WgQUYoFHegY1utFDdaSmId2ph60+mHrQAUEd6KDQADpSmgdKKAEpD2paQ0AJSjpSUo6UxBSUppKACiig9aAAdKKB0paAEpKWkoASlpKUUAIaYakNMNMQ0U8UwU+gAp1JRSGOpKB1ooAKSg0UAOoNFBoASlFJS0AGOad2pKO1AC0GkpaQxKSlNFMQ4dKKQdKWkMWkNFDdaAEHWnZpopD1oAcaKQdKXtQAtKvSm0tADqU02lpDA9KSlPSkoEKtO7U1e9OoGJRSUtACnkUq0CgdaQDqO1N70tAxDRSnpTaBDl6mnU1etLQMXtR2opP4aAGnpTgcU3NDfdoEOJGOtNzTR1p1MAFA+8KKKQDs0tNoFAxaaadTDQAdxTqZ3FPoEI1JQaSmAopAMGlFBoAU0lBooAQ02n0w0AIafTKcaACjvRR3oAa3WkHehutFMQufemnrSHqaXtQAUGj0ooEKOlFJRQMDSGlpDQAlKOlJSjpTEBpKU0lABQRnFFFAAOlFAooAKQ0tIaAEpR0pKUUABphp5qNqYgWnUwU+gApaSlpDAUtIKWgBKKKKAHUUUUAJS0lLQAdqXtSUvagApaSlpDENJSmkpiHdqWkFFIYveg0d6Q0AApD1oFB60CFHSg0gpaBi0opKUUAFOptOFIANNpx6U2gByd6dTU70vagYGgUlKOtACilXqaaKVepoAWlpKWkMD0ptO7U2gQq9aWkFLQMXPFHakpT0oAZQ3SkpT92mIQdadTaWgApaSigBaUUlApAL2pp606mHvQAfxU+mfxCn0wGmkpTSUAFBo9KD2oAU0lKaSgBaYetOpp70AJTjTadQIKTvRRQA1utIKU0gpgNPWnUh60dqBB3ooopgLSUUd6QC96Q0tIaBiGlHSkpR0piCkpTSUAFFFFAAOlFA6UUAFBooNADaUUlKKAENManmmNTEItPpop1ABS0lLSGHelpKWgBDRQaT0oAfRRRQAlL2oo7UAFL2pD0pe1AAKWkpaQCGig0lMBw6UUlLSGLSGlFIaAExzQetLSHrQIBS0CigYo60opB1ooAWlHSm06gAPSkpT0pvc0APXvTqYnSnUhiUveiigAFKvU0nrQvU0AO70UlLSAXtTaXsaSmADrTqaKXNAC0HpSUp6UhjO1HRaKGHFMQg5NLmkHGKWgApaTtS0ALSDrRQKAFppp1MNAB3p9M/iFPoAQ0lLSUAHpSHtS+lIe1ADjSUGkoAWkPWlpp60AIaWkpc0xBRRRQA09aTHNKetJigBp60vSjvR2piCiigUALSGiikAtIaWkNACUo6U3tTh0pgFJS0lABRRSdqAFHSigdKKACkPSlpDQAUCkooADTDTzTDTEIKeKYtPHWgApaSlpAApaQdaWgYlJSmkoEPooooGFHaiigBD0p1Np3agAoo7UUgA0lKetJTAUdKWgUUhiikNLSNQAgoNFBpiAdKO1IKWgBaWkpaQwNO7U2loAU000ppKAHL3p1NXvS0hhR3oNHegA7mlXvTSeaVaAHUtJ3ooAXsabSnpTaAFHWnU0dad2oAKD0ooPSkMaKDSUUxCfxUvek70ue1AAKUdqQUooAO1KKSgUALTadTKAAdakqMdfxp5oAKSjNJQAHoKQ9aU9Kb3oAfSUpooASkPWlpp70CCikp1MBKWiigBp60nalPWkoAaaO1BoFMQGl70lLQAUd6KTvQA6kNFIaAEpw6U2nDpQAUlLSUAFJ2paQ0AKOlFA6UUAFIaWkNACUCigUABphp5phpiEWnU1acKAFooo9KAF70UUUhhSUtJQIdRRRQMWkoooAMYp1NpRQAtFFFACGig0UAL2paO1JSAdSNQKRqBhSGlpD1piFFBoFBoAUUUUUhhTqaOlOoAQ0UGigBV6GlpFpaAFopKDSACM0opKB1oGPzRSUUAB6UlKelJQAo60tItLQAUvamilJ4oAbQaQUp6UANHWndsU2nUCEFLSCloAKB3o70etAxabSmkoAB1p2aYOop9ACUUelFACUYxRQaYhc0ZopKQxaaaWkPWmISnU2nUAJ3ooooAa3WihutJQAhpRSd6BTEB60UGigAo9KD0ooAWkNLSUAJSjpSUo6UAFFFFABSEc0UUAKKKQUtACUGig0AJQOlFKKAEPSmGnmmGmIFpaaKdQAtFFLQAUUUUgCk70tIKYDqKKDSGFFJRQAtKKbTh0oAWikpaAEPWig9aKAF7UtJ2opAKKRu1LSGgBKD1paTuaYCig0Cg0AFL3pKWkMKXmkpaAEoNFFADl6UtIKKAFopM0lACilHWm0q9aAH0UnalpDA9KTtQelJ6UAKtLSDrS0AFKelNpaAGig9KBQelMQUtNpaQCCl7UlKKYBS0lFIAyaKKSmADrTqaOtOpAFJQaSgAoNJRTAdRRRSAKTvS009aYBS02nUAFJRRQAh60lKetJQAnelpKO1MQUUUUAFFFFAAaSlpKAA0o6Unel7UAFFFJQAUUUlACilpBRQAUGig0AJQKO9AoADTDTzUZpiAU6minUALS0lLQAUUUUhhSGlpOtMQ6iiikMSiiigA7U4U2nCgApaSloAQ0UGkoAd2oo7UUAFBooNIAFIaBR3pgLSGgUUALSim06kMKXtSUUAFFFFAAvenUgpaAE70Ud6KAClHWkpR1oAWlpKWkMD0ptOPSm0CFHWlpB1paBhQe9FFACAUGkFBPApiAUtNFLQAlOFNFKKAFNAoNJSAU0lFJTAM/MKdTepFOoAQ0UGkoAKKKSgB1FFFAC009aWkNACU6m0tABRRRQA09aXoKQ9aKAEpabS0xBRSelLQAdqKKKACkpaSgANA6UUDpQAtJS02gANFFFACiikFLQAUGig0AJQKKBQAGozUhqM0xAKdTVp1AC0UUUALSUtFIBKBRRTAdRRRSGGKSlpKAClHSilFABRRRQAHrRQaTvQA7tRR2ooAKRqWkagAo70Uh60AKOtFAoNABS0lLQAtFIKWkMSg0ppDQIcvSikWloGGKKKKACgdaKBQA6iiikAHpSUp6U2mA4daKRaWkAUppKD0oGNBoPSgUHpTEFLTc07tQAlL2pBRQAtFJ3paAEzRS0lAADzTqYOtOoAOtGKM0UAJSGloNAC0UUUAFJ3paaetABS02nUAFFJRQAh60lKetJTEFFJSg0AJS0lFAC0UdqKACkpaSgBO9O7U00o6UALSYoooAKSlpKAAUtIKWgAoNFBoASgUlKKAA1GakNRmmIBThTVpwoAWiiigA70tJ3paAEooooAdRRRSGFFFFABSim07tQAUUUUAIaKU9aSgBe1FHaloAKRu1LSGgApDS0hoAUUUgpaAClpKKAF7UtNp1IBDRQaSmA4dDS0i0tIYUGiigAoFIaVaAFooooAD0pKU9KSgBRS00dad2oABR2oo7UAMFKelFFACClpvenZoAQUtIKWgA70DkmigUAKabTqbQADqKdTBT6AEooooAKKD0pooAfSUtFACUh60tIe9ACU6m0vegA70tJRQAh60lKetJTEIetAoNAoAKWkooAKKKKAFpKWkNACUo6UlKOlABRRRQAUUUh60AKKKBRQAUhpaQ0AJSikpR0oAD0php56Uw0xCCnU0U4UALR3oooAB1paQUtIYlFBopiHUUUUhhR2pKO1ABS0h6U7tQAUUlLQAhooNFACiikpaAFpDS0hoASj1pRSd6AAUUCigBaKKKACnU006kAhpDSmkpgOXvS01elOpDA0d6SigA70L3o9aF70AOopKKAFPSm07tTaAFHWlzTaWgBaD0pKXtQA2g0UGgBP4qWk70tAAKBSUtAC0Ck7UooAKSlppoAB1/Gn0zvT6AEoopKADtSd6X0pD1oAdR2oNJQAtNNOpp60AFLSUUCFopKWgY09aKD1o7UxCHpQKKO1ABRRRQAUd6KKAFpDS0hoASlHSkpR0oAWkoooAKSlpO1AAOlLSDpRQAtIaWkNACUCiigQGmmnGmGmACnUwGnZoAd2opuaXNAC96Wm55pc0ABpKCaM0APopM0hNIYtHakzRnigQp6Uvam5pc8UDFpabmlzQAGikJpM0APFFNzS5oAWg0maQmgBaQ9aTPNBNADqKaDS5oAd3opuaXNAC0opuaXNACnpSUE0maAHL0p1MBpc0ALRTc0ZoAdQOppuaUHk0gHUU3NLmgYvako3U3dQA4UtNBozQA6g9KTNGeKAEoPSm5pc8UxCg0U3PNLntQAvalpuaM0AOoHWkzSA0hj6aaM0hNAhe9OpmeaduoAU0lNJozQMdSGkz0oJpiHmkpM0ZpDFpD1ozSE0CA06mZpc0wFpabmjNAAetJSE80A0AHelppNANADqBTc0ZoAdRSZozQA6kNJmgmgBO1OHSm5pQeKBC0lGaTNAxaKTNGaAFHSikB4ozQA6kPSjNITQAUCkzQDTEKaYacTTSaAGCloopiFooooAKXNFFIBKKKKYC5ooopDDNGaKKADNLmiigAzRmiigAJpKKKAFzRmiigBc0hNFFACUE0UUAFGaKKAFzRmiigAzS5oooACaTNFFACgmlzRRQAmaM0UUAGaATzRRQAuaMmiikAZpM0UUAANLk0UUAGTS5NFFAxuaCeKKKYhM0uaKKADJozRRQAuaAaKKADJpM0UUAGeaXJoooAM0maKKADJoJoooAUk0mTRRSAXNITRRTATNLmiigAzRmiigBCaM0UUAJmiiigAzRmiigBc0meaKKAFzSE0UUAGaUHiiigAzSUUUAGaKKKAAGiiigAzRmiigBKWiigQlIaKKYH//Z]]
-- =======================================================]] -- Style
DialogWindow.Style = [[<style type="text/css">html {overflow:hidden}
.DirectoryPicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}
.FormButton {font-weight:bold;width:75px;font-family:Arial, Helvetica, sans-serif;font-size:12px;white-space:nowrap;background-color: #3a4660;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.LuaButton {font-weight:bold; width:75px; font-family:Arial, Helvetica, sans-serif;font-size:12px; background-color: #3a4660;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.ToolNameLabel {font-family:Arial, Helvetica, sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#000}
.ToolPicker {font-weight:bold;text-align:center;font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;width:50px; background-color: #3a4660;color: ]].. DialogWindow.StyleButtonTextColor .. [[ }
.alert-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:  ]].. DialogWindow.StyleTextColor .. [[;text-align:center;white-space:nowrap}
.alert-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;text-shadow: 5px 5px 10px #FFF;color:#FF0101 ;text-align:left;white-space:nowrap}
.alert-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;color:#00F;text-align:right;white-space:nowrap}
.error {font-family:Arial, Helvetica, sans-serif;font-size:18px;font-weight:bold;color:#FF0000 ;text-align:left;white-space:nowrap;padding-right:4px;padding-left:10px;padding-top:4px;padding-bottom:4px;}
.errorMessage {font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000;font-weight:bold;text-align:left; white-space:nowrap;padding-right:4px; padding-left:10px; padding-top:4px;padding-bottom:4px;}
.errorTable {background-color:#FFFFFF white-space:nowrap;}
.p1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left}
.p1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center}
.p1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right}
.ver-c {font-family:Arial, Helvetica, sans-serif;font-size:10px;font-weight:bold;text-align:center;white-space:nowrap color: #ffd9b3 ;}
.h1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:center;white-space:nowrap}
.h1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:left;white-space:nowrap}
.h1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap}
.h1-rP {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px;}
.h1-rPx {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px}
.h2-l {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:  ]].. DialogWindow.StyleButtonColor .. [[ ;text-align:left;white-space:nowrap;text-shadow: 2px 2px white;}
.h2-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:  ]].. DialogWindow.StyleButtonColor .. [[ ;text-align:center;white-space:nowrap;text-shadow: 2px 2px white;}
.h2-r {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold; color:  ]].. DialogWindow.StyleButtonColor .. [[ ;text-align:right;white-space:nowrap;text-shadow: 2px 2px white;}
.h3-bc {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}
.h3 {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}
.webLink-c {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;background-color: yellow;text-align:center;white-space:nowrap}
.jsbutton {background-color:#3a4660;border:2px solid #999;border-right-color:#000;border-bottom-color:#000; border-top-color:#FFF; border-left-color:#FFF; 12px;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none; font-size:12px; margin:1px 1px; color:]].. DialogWindow.StyleButtonTextColor .. [[ }
.jsTag-no-vis {font-family:Arial, Helvetica, sans-serif;font-size:10px;display:none; text-align:center; color:#00F; visibility: hidden;}
body {background-color:#c9af98; background-position: center; overflow:hidden;font-family:Arial, Helvetica, sans-serif;font-size:12px; color: ]].. DialogWindow.StyleTextColor .. [[;
background-image: url(]].. DialogWindow.myBackGround ..[[); }html {overflow:hidden;}</style>]]
-- =========================================================]] -- About
  DialogWindow.myHtml6 = [[<html><head><title>About</title>]] .. DialogWindow.Style ..[[</head><body text = "#000000"><table width="680" border="0" cellpadding="0"> <tr> <td align="center" nowrap="nowrap" class="header1-c" id="SysName">Easy Cabinet Maker</td> </tr> <tr> <td align="center" nowrap="nowrap" class="h2" id="Version"><span class="h1-c">Version</span></td> </tr> <tr> <td align="center" nowrap="nowrap"><hr></td> </tr> <tr> <td align="center" nowrap="nowrap" class="header2-c">Disclaimer</td> </tr> <tr> <td align="center" class="p1-l"><p class="p1-l">The ]] .. DialogWindow.AppName .. [[ Gadget is a plugin for Vectric software, V-Carve Pro and Aspire.<br> Gadgets are an entirely optional add-in to Vectric's core software products.<br> They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.<br> In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.<br> <br> Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:<br> 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.<br> * If you use this software in a product, an acknowledgement in the product documentation would be appreciated but is not required.<br> 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.<br> 3. This notice may not be removed or altered from any source distribution.<br> <br>The author heavily utilized the SDK documentation and supplied code samples in addition to the outstanding user community on the Vectric User forum.</p></td> </tr> <tr> <td align="center"><a href="https://forum.vectric.com" class="webLink-c">Vectric User Forum</a></td> </tr> <tr> <td align="center" ><span class="header2-c">JimAndi Gadgets</span></td> </tr> <tr> <td align="center"><span class="h1-c">Houston, TX.</span></td> </tr> <tr> <td><hr></td> </tr> <tr> <td width="30%" align="center" style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr></table></body>]]
-- =========================================================]] -- Name
 DialogWindow.myHtml2 = [[<html><head><title>Dovetail Toolpath Creator</title> ]].. DialogWindow.Style .. [[ </head><body> <table width="530" border="0" summary="Dovetail bit Tool Data"> <tr> <td width="20%" class="h1-rPx"><span class="h1-rP">Tool Brand</span></td> <td width="22%"><span class="h1-l"> <input name="Dovetail.Brand" type="text" id="Dovetail.Brand"> </span></td> <td colspan="2" rowspan="10" ><img src="data:image/jpeg;base64,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" hspace="12" width="180" height="280" class="h1-c"></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Tool Type</span></td> <td><span class="h1-l"> <input name="Dovetail.Type" type="text" id="Dovetail.Type" value="Carbide"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Model Number</span></td> <td><span class="h1-l"> <input name="Dovetail.PartNo" type="text" id="Dovetail.PartNo"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Bit Angle (A)</span></td> <td><span class="h1-l"> <input name="Dovetail.BitAngle" type="text" id="Dovetail.BitAngle"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Cut Depth (I)</span></td> <td><span class="h1-l"> <input name="Dovetail.CutDepth" type="text" id="Dovetail.CutDepth"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Flute Count</span></td> <td><span class="h1-l"> <input name="Dovetail.Flutes" type="text" id="Dovetail.Flutes" value="2"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">RPM</span></td> <td><span class="h1-l"> <input name="Dovetail.RPM" type="text" id="Dovetail.RPM"> </span></td> </tr> <tr> <td class="h1-rPx"><p class="h1-rP">Base Dia (D)</p></td> <td><span class="h1-l"> <input name="Dovetail.BitDia" type="text" id="Dovetail.BitDia"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Shank Dia (S)</span></td> <td><span class="h1-l"> <input name="Dovetail.ShankDia" type="text" id="Dovetail.ShankDia"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Overall Length (L)</span></td> <td><span class="h1-l"> <input name="Dovetail.BitLength" type="text" id="Dovetail.BitLength"> </span></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Feed Rate</span></td> <td><span class="h1-l"> <input name="Dovetail.FeedRate" type="text" id="Dovetail.FeedRate"> </span></td> <td class="h1-rPx">Bit Units</td> <td><select name = "UnitList" class = "h2" id = "UnitList"> <option selected>inch</option> <option>mm</option> </select></td> </tr> <tr> <td class="h1-rPx"><span class="h1-rP">Plunge Rate</span></td> <td><span class="h1-l"> <input name="Dovetail.PlungRate" type="text" id="Dovetail.PlungRate"> </span></td> <td class="h1-rPx">Mill Rate</td> <td><select name = "RateList" class = "h2" id = "RateList"> <option>inches/sec</option> <option selected>inches/min</option> <option>feet/min</option> <option>mm/sec</option> <option>mm/min</option> <option>m/min</option> </select></td> </tr> <tr> <td class="h1-rPx">Note</td> <td colspan="3"><span class="h1-l"> <input name="Dovetail.Notes" type="text" id="Dovetail.Notes" size="55"> </span></td> </tr> </table> <table width="100%" border="0" id="ButtonTable"> <tr> <td height="4" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td>  </tr>  <tr> <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td> <td width="388" class="alert" id="GadgetName.Alert">.</td> <td width="96" class="h1-c" style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td> <td width="96" class="h1-c" style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td>  </tr></table></body></html>]]
-- =========================================================]]
  DialogWindow.myHtml1 = [[<html><head><meta content = "text/html; charset=utf-8" http-equiv = "Content-Type"><title>Cabinet Maker and Tool-path Creator</title> ]].. DialogWindow.Style .. [[ </head><body><table width = "550" border = "0" cellpadding = "0"> <tr> <td colspan="2" align = "center" valign = "middle"><img src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEBLAEsAAD/4QCORXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAABJADAAIAAAAUAAAAXJAEAAIAAAAUAAAAcJKRAAIAAAADNzYAAJKSAAIAAAADNzYAAAAAAAAyMDIwOjA1OjEzIDExOjQwOjM2ADIwMjA6MDU6MTMgMTE6NDA6MzYAAAD/4QGgaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49J++7vycgaWQ9J1c1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCc/Pg0KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyI+PHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj48cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0idXVpZDpmYWY1YmRkNS1iYTNkLTExZGEtYWQzMS1kMzNkNzUxODJmMWIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+PHhtcDpDcmVhdGVEYXRlPjIwMjAtMDUtMTNUMTE6NDA6MzYuNzYwPC94bXA6Q3JlYXRlRGF0ZT48L3JkZjpEZXNjcmlwdGlvbj48L3JkZjpSREY+PC94OnhtcG1ldGE+DQo8P3hwYWNrZXQgZW5kPSd3Jz8+/9sAQwAbEhQXFBEbFxYXHhwbIChCKyglJShROj0wQmBVZWRfVV1baniZgWpxkHNbXYW1hpCeo6utq2eAvMm6pseZqKuk/9sAQwEcHh4oIyhOKytOpG5dbqSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSkpKSk/8AAEQgA4QIGAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A6aiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAEopaKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAGGRAcF1H40ebH/fX86pADFAH76Mf7WajmK5TQphkRTgsAfc06qUigSNx3pt2Elct+bH/fX86PNj/56L+dUsUjDO0erAVPOPlNGmllUZJAHvS1BdAEKferbJJfNj/vr+dHmx/31/OqWBRio5y+UvK6t91gfoadVSyHzSN74q1Vp3IYjOq/eYD6mk82P++v51XuB+9z7CosCpcrFJF3zY/76/nSqysPlIP0qjxViz/1APqTRGVwasWKazqoyxAHvS1Xuh90/UVTdiUTebH/AH1/OjzY/wC+v51SwKMVHOXyl1ZEY4VgT6A0+qVmMzSH0GP8/lV2rTuS9BrOq/eYD60nmx/31/OoLkfMpx2NQ4FS5WGkXfNj/vr+dHmx/wB9fzqlgUqKGmjX3zQpByl+mllAySAPelqC5XKg46GqbJJfNj/vr+dHmx/31/OqWB6UYqOcvlLvnR/31/OlVgwypBHqKoNwpPtVy3GIE+lUpXJasS0UUVQhrOq/eYD6mk82P++v51WuB+9PuM1HiocrFJF3zY/76/nR5sf/AD0X86pYprjICjqxxS5w5TRBBGQeKWkAwAB0FLWhIxpEU4ZgPqaPNj/vr+dVrhcSk+vNR4qHKxSRd82P++v50ebH/fX8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RyoLsrfZm/vj8qPszf3x+VWaKOVBdlb7M398flR9mb+8PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7M394flR9mb++PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7M394flR9mb+8PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7M394flR9mb+8PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7O394flR9mb+8PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7M394flR9mb+8PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7M394flR9mb+8PyqzRRyoLsrfZm/vD8qPszf3h+VWaKOVBdlb7M394flR9mb+8PyqzRRyoLso3Ni08XliQL8ynO3PQg+vtUcmmtJKZC6AkbDgHlSRwf1/OtKinZBczJdMeR5iZVAlVRjb0wSfX3qW3sTDHs3A5Yt06ZOcVeoosguZn9lyD7TiVQJxyNnQ+vWpF09lUDzTnbt77frjNX6KOVBdmYmlssSRvLnYioCoweP8j8qktbBre3SLzA+z+IjrV+iiyC5VNs2MbhU6LsULT6KErA3cKKKKYgooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD/9k=" width="100%" height="300" border="1"></td> </tr> <tr> <td width="90%" align = "left" valign = "middle" class = "h1-l" id = "Questions">Message Here</td> <td width="10%" align="right"><input id = "InquiryAbout" class = "LuaButton" name = "InquiryAbout" type = "button" value = "About"></td> </tr> <tr> <td height = "10" colspan="2" align = "center" id = "QuestionID"> <select name = "DList" align="center" class = "h2" width = "100%" id = "ListBox"> </select> </td> </tr></table><table width="100%" border="0" id="ButtonTable">  <tr>    <td height="4" colspan="4" align="right" valign="middle" nowrap class="h2"><hr></td>  </tr>  <tr>    <td width="75"><input name="help" type="button" class="FormButton" id="help" onClick="myHelp()" value="Help"></td>    <td width="388" class="alert" id="GadgetName.Alert">.</td>    <td width="96" class="h1-c" style="width: 15%"><input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK"></td>    <td width="96" class="h1-c" style="width: 15%"><input id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel"></td>  </tr></table></body></html>  ]]
-- =========================================================]]
return true
end
--  ================ End ===============================