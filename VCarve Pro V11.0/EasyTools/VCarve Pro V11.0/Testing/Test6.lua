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
    if(sheet_manager:GetSheetName(id) == "Sheet 1") then
      --sheet_manager:CreateSheets(1, id)
      sheet_manager:CreateSheets(1, id, Box2D(Point2D(0, 0), Point2D(48, 48)))
    end
  end
  return true
end