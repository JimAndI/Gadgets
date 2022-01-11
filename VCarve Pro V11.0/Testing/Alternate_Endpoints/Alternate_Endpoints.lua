-- VECTRIC LUA SCRIPT
--[[
Gadgets are an entirely optional add-in to Vectric's core software products.

They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.

In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
]]

--[[

The Alternate Endpoints gadget swaps the start and end points of every second vectors in a selection. It works under both Aspire or VCarve Pro.

The gadget removes selected items from their layer and re-adds the altered items into the active layer.

This gadget uses the idea of removing selected items from their layer before swapping the endpoints and then re-adding those lines to the job from Paul Rowntree's "Green Squares" gadget.

The AddMarkers() and MarkContourNodes() functions were copied and adapted from the Vectric gadget SDK,.

2021-12-07: created by Steven Hall
2021-12-08: posted to the Vectric "Gadgets > Gadgets - User Submission" forum

--]]

-- require("mobdebug").start() -- developer only: used with ZeroBrane Studio's debugging tools
require "strict"

CodeVersion = "1.0"
strNewLayer = "Alternating Endpoints"

job={}

function MarkContourNodes(contour, layer, intVectorCount)

   local num_spans = 0
  
   local ctr_pos = contour:GetHeadPosition()
   while ctr_pos ~= nil do
      local span
      span, ctr_pos = contour:GetNext(ctr_pos) 
      -- create a marker at start of span only if it is an open contour
      if contour.IsOpen then
        local marker = CadMarker("v: " .. intVectorCount, span.StartPoint2D, 3)
        layer:AddObject(marker, true)
        num_spans = num_spans + 1;
      end
   end
end

function AddMarkers(selection)
  local ctr_count = 1   

  -- create a layer with passed name if it doesnt already exist
  local layer = job.LayerManager:GetLayerWithName("Alternating Markers")
   
  local pos = selection:GetHeadPosition()
  while pos ~= nil do
    local object
    object , pos = selection:GetNext(pos)
    if (object.ClassName == "vcCadContour") or (object.ClassName == "vcCadPolyline") then
      local contour = object:GetContour()
      MarkContourNodes(contour, layer, ctr_count)
      ctr_count = ctr_count + 1
    end
  end
end


function AddContourToJob(layer,contour)

  local cad_object = CreateCadContour(contour)
  layer:AddObject(cad_object, true)

  return cad_object
end

function CopyThenRemoveSelectedVectors(selList)
	local listVectors={}
	if (not selList) or selList.IsEmpty then		-- this should never happen
		return listVectors
	end

	local pos = selList:GetHeadPosition()
	local object
	while pos ~= nil do
		object, pos = selList:GetNext(pos)
		if object:GetContour() then
			listVectors[#listVectors+1] = object:GetContour():Clone()
			selList:Remove(object, false)
		end
	end

	return listVectors
end

function main(gadget_path)

  job = VectricJob()
  
  if not job.Exists then
    MessageBox("No document loaded...")
    return false
  end
  
	local selCopy = CopyThenRemoveSelectedVectors(job.Selection)

	if #selCopy<2 then
		MessageBox("You must select at least two vectors.")
		return false
	end

	job.Selection:Clear()
  local new_layer = job.LayerManager:GetLayerWithName(strNewLayer)
  local swap = 0 -- when swap == 1 then we exchange endpoints

	for i=1, #selCopy do
    if selCopy[i].IsOpen then -- ignore closed vectors
      if swap == 1 then
        selCopy[i]:Reverse()
      end
      swap = 1 - swap -- toggle between 0 and 1 instead of using if/then group
    end
		job.Selection:Add(AddContourToJob(new_layer,selCopy[i]), true, true)
	end
  
	job.Selection:GroupSelectionFinished()
  AddMarkers(job.Selection)  
  
	job:Refresh2DView()
  
  MessageBox("Alternate Endpoints v".. CodeVersion .."\n\nEvery other line's endpoint has been swapped.\n\nLines have been copied to layer: " .. strNewLayer)

	return true
end