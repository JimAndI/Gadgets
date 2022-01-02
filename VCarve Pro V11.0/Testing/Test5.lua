-- VECTRIC LUA SCRIPT
-- require "strict"
require("mobdebug").start()
--Global variables
-- =====================================================]]
function main()
  local job = VectricJob()
  local sheet_manager = job.SheetManager
  local sheet_ids = sheet_manager:GetSheetIds()
for id in sheet_ids do
    DisplayMessageBox("Sheet Name: " .. sheet_manager:GetSheetName(id))
    if(sheet_manager:GetSheetName(id) == "Sheet 1") then
      sheet_manager:CreateSheets(5, id)
      -- sheet_manager.ActiveSheetId = id
    end

  end
  --]]
  return true
end