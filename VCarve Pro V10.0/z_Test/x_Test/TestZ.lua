 Tester = {}
function DisplayMaterialSettings()
--[[ ------------------- DisplayMaterialSettings ------------------------------
  |
  | Display information about the size and position etc of the material block
  |
  |
  | Return Values:
  | None
  ]]
  local mtl_block = MaterialBlock()
  local units
  if mtl_block.InMM then
      units = " mm"
  else
      units = " inches"
  end
-- Display material XY origin
  local xy_origin_text = "invalid"
  local xy_origin = mtl_block.XYOrigin
  if xy_origin == MaterialBlock.BLC then
  xy_origin_text = "Bottom Left Corner"
  elseif xy_origin == MaterialBlock.BRC then
  xy_origin_text = "Bottom Right Corner"
  elseif xy_origin == MaterialBlock.TRC then
  xy_origin_text = "Top Right Corner"
  elseif xy_origin == MaterialBlock.TLC then
  xy_origin_text = "Top Left Corner"
  elseif xy_origin == MaterialBlock.CENTRE then -- NOTE: British spelling for Centre!
  xy_origin_text = "Centre"
  else
  xy_origin_text = "Unknown XY origin value!"
  end
  local z_origin_text = "invalid"
  local z_origin = mtl_block.ZOrigin
  if z_origin == MaterialBlock.Z_TOP then
  z_origin_text = "Top of Material"
  elseif z_origin == MaterialBlock.Z_CENTRE then -- NOTE: British spelling for Centre!
  z_origin_text = "Centre of Material"
  elseif z_origin == MaterialBlock.Z_BOTTOM then
  z_origin_text = "Bottom of Material"
  else
  z_origin_text = "Unknown Z origin value!"
  end
  local xy_origin_pos = mtl_block.ActualXYOrigin

  -- get 3d box object describing material bounds ....
  local mtl_box = mtl_block.MaterialBox
  local mtl_box_blc = mtl_box.BLC
  -- test methods to conver z values between absolute z and relative depths
  local test_val = 0.125
  local depth = mtl_block:CalcDepthFromAbsoluteZ(test_val)
  local abs_z = mtl_block:CalcAbsoluteZFromDepth(test_val)
  DisplayMessageBox(
  "Width = " .. mtl_block.Width .. units .."\n" ..
  "Height = " .. mtl_block.Height .. units .. "\n" ..
  "Thickness = " .. mtl_block.Thickness .. units .. "\n" ..
  "\n" ..
  "XY Origin = " .. xy_origin_text .. "\n" ..
  " Position = (" .. xy_origin_pos.x .. ", " .. xy_origin_pos.y .. ")\n" ..
  "Z Origin = " .. z_origin_text .. "\n" ..
  "\n" ..
  "Box Width = " .. mtl_box.XLength .. units .."\n" ..
  "Box Height = " .. mtl_box.YLength .. units .. "\n" ..
  "Box Thickness = " .. mtl_box.ZLength .. units .. "\n" ..
  "Box Bottom Left Corner = (" .. mtl_box_blc.x ..
  "," .. mtl_box_blc.y ..
  "," .. mtl_box_blc.z ..
  ")\n" ..
  "\n" ..
  "Test Value = " .. test_val .. "\n" ..
  " Depth from absolute test value = " .. depth .. "\n" ..
  " Absolute Z from depth test value = " .. abs_z .. "\n" ..
  "\n"
  )
end
-- ================================================
Tester.JJ=   DisplayMessageBox("Jim")

return Tester