-- VECTRIC LUA SCRIPT
require("mobdebug").start()
--  =*********************************************= 
function main(script_path)
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("Error: No job loaded")
         return false ; 
    end
    --MessageBox ("JIM")
  DisplayMessageBox(tostring(GetBuildVersion()))
    local selection = job.Selection
    selection:Clear()
	-- get layer
    local layer = job.LayerManager:FindLayerWithName("Jim")
    local X = SelectVectorsOnLayer(layer, selection, true, true, true)
	selection.CopySelectionToOppositeSide()
	DisplayMessageBox(tostring(X))
    return true 
end
-- ===============================================
function SelectVectorsOnLayer(layer, selection, select_closed, select_open, select_groups)
--[[  ---------------- SelectVectorsOnLayer ---------------- 
|
|   Add all the vectors on the layer to the selection
|     layer,            -- layer we are selecting vectors on
|     selection         -- selection object
|     select_closed     -- if true  select closed objects
|     select_open       -- if true  select open objects
|     select_groups     -- if true select grouped vectors (irrespective of open / closed state of member objects)
|  Return Values:
|     true if selected one or more vectors
]]
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
    message = message .. 
    "\r\n\r\n" .. 
    "If layer contains grouped vectors these must be ungrouped for this script"
    end
    DisplayMessageBox(message)
    warning_displayed = true
    end 
    end
    else  -- contour was NOT nil, test if Open or Closed
    if contour.IsOpen and select_open then
    selection:Add(object, true, true)
    objects_selected = true
    else if select_closed then
    selection:Add(object, true, true)
    objects_selected = true
    end 
    end
    end
    end 
    -- to avoid excessive redrawing etc we added vectors to the selection in 'batch' mode
    -- tell selection we have now finished updating
    if objects_selected then
        selection:GroupSelectionFinished()
    end 
    return objects_selected 
end 
-- ======================= End ===============================

