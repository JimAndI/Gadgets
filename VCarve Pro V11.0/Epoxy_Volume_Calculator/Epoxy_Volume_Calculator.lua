-- VECTRIC LUA SCRIPT
-- Copyright 2013 Vectric Ltd.
-- Gadgets are an entirely optional add-in to Vectric's core software products.
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it freely,
-- subject to the following restrictions:
-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.
-- This gadget is supplied as a 'template' for user to build their own gadgets
require "strict"

g_version = "1.2"
g_title = "Epoxy Volume Calculator"
g_convert_to_fluid_inches = 0.554113
g_convert_to_fluid_mm = 0.001

--[[  ------------------------ CalculateLayerSize --------------------------------------------------
|
|  Walks all contours on a layer and calculates area of all objects
|
]]
function CalculateLayerSize(layer)
    local contours = {}
    local count = 1
    local pos = layer:GetHeadPosition()
    -- calculate total area
    while pos ~= nil do
        local object
        object, pos = layer:GetNext(pos)
        if object.ClassName ~= "vcCadBitmap" then
            contours[count] = object
            count = count + 1
        end
    end
   -- MessageBox("Contour Count: " .. count - 1)

    -- figure out nested countours
    local outerContours = {}
    local innerContours = {}
    local outerContourIndex = 1
    local innerContourIndex = 1
    -- walk each contour and see if it is inside the other contours
    -- if the count is even then it is a nested contour and should be included 
    -- in the total area. If it is odd then it should be subtracted from the 
    -- total area. If it is not inside any other contour it is a separate
    -- contout and should be included in the total area
    for index = 1, (count - 1) do
        local innerCount = 0
        local object = contours[index]
        local contour = object:GetContour()
        local bounds = contour.BoundingBox2D
       -- MessageBox("Checking Contour " .. object.Id)
        -- walk each contour and see if this contour is inside an of them
        for innerIndex = 1, count - 1 do
            local innerObject = contours[innerIndex]
            local innerContour = innerObject:GetContour()
            local innerBounds = innerContour.BoundingBox2D
            -- make sure this is not the same object
            -- check to see if it is inside the contour
            if object.Id ~= innerObject.Id and innerBounds:IsInside(bounds) then
                -- increment the count 
                innerCount = innerCount + 1
         --       MessageBox("Contour " .. object.Id .. " is inside contour " .. innerObject.Id)
            end
        end
        -- if it is not inside any countour add it to the
        -- outer contours so we include its area
        if innerCount == 0 then
            outerContours[outerContourIndex] = object
            outerContourIndex = outerContourIndex + 1
          --  MessageBox(object.Id .. " is an outer contour")
        else
            -- if the count is odd then that means this contour
            -- is an indes contour and its area needs to be
            -- subtracted from the total area
            if (innerCount % 2 ~= 0) then
                innerContours[innerContourIndex] = object
                innerContourIndex = innerContourIndex + 1
           --     MessageBox(object.Id .. " is an inner contour")
            else
                -- if the count is even then that means this is
                -- an outer contour that inside other contours
                -- and its area needs to be included in the total area
                outerContours[outerContourIndex] = object
                outerContourIndex = outerContourIndex + 1
          --      MessageBox(object.Id .. " is an outer contour")
            end
        end
    end

    local Area = 0
    local msg = "Outer Contours\n"
    -- add the area of all the outer contours
    for index = 1, outerContourIndex - 1 do
        local object = outerContours[index]
        local contour = object:GetContour()
        Area = Area + contour.Area
        msg = msg .. object.Id .. " - " .. contour.Area .. "\n"
    end
    
    msg = msg .. "\nInner Countours\n"
    -- subtract the area of the inner contours
    for index = 1, innerContourIndex - 1 do
        local object = innerContours[index]
        local contour = object:GetContour()
        Area = Area - contour.Area
        msg = msg .. object.Id .. " - " .. contour.Area .. "\n"
    end
  
    msg = msg .. "\nArea: " .. Area .. "\n"
   -- MessageBox(msg)
    return Area
end

--[[  ------------------------ OnLuaButton_ApplyButton --------------------------------------------------
|
|  Apply Button handler
|
]]
function OnLuaButton_ButtonCalculate(dialog)
    local mtl_block = MaterialBlock()
    local units = ""
    local weights = ""
    local convert_to_fluid
    -- determine the units which determines 
    -- the calculation values we need to use
    if mtl_block.InMM then
        units = " mm"
        weights = " grams"
        convert_to_fluid = g_convert_to_fluid_mm
    else
        units = " inches"
        weights = " ounces"
        convert_to_fluid = g_convert_to_fluid_inches
    end

    local job = VectricJob()
    local layer_manager = job.LayerManager
    -- Pull values from dialog
    local layerName = dialog:GetDropDownListValue("DropDownList")
    local depth = dialog:GetDoubleField("CutDepth")
    local hardnerPercentage = dialog:GetDoubleField("HardnerPercentage")
    -- Calculate area for the contours on a layer
    local layer = layer_manager:GetLayerWithName(layerName)
    local area = CalculateLayerSize(layer)
    -- cubic volume is the area multiplied by the depth of cut
    local cubicVolume = area * depth
    -- convert to fluid volume
    local fluid = cubicVolume * convert_to_fluid
    -- figure out how much resin by multplying by 1 + the percentage of hardner to resin
    -- and dividing it into the total amount of fluid
    local resinPercentage = hardnerPercentage + 1
    local resin = fluid / resinPercentage
    -- get the hardner amount by multipling the resin by the percentage of harder 
    local harnder = resin * hardnerPercentage
    -- Update results
    local msg = tostring(area) .. " square " .. units 
    dialog:UpdateLabelField("AreaLabel", msg)
    msg = tostring(cubicVolume) .. " cubic" .. units
    dialog:UpdateLabelField("VolumeLabel", msg)
    msg = tostring(fluid) .. weights
    dialog:UpdateLabelField("FluidLabel", msg)
    msg = tostring(resin) .. weights
    dialog:UpdateLabelField("ResinLabel", msg)
    msg = tostring(harnder) .. weights
    dialog:UpdateLabelField("HardnerLabel", msg)
    
    return true
end

function OnLuaButton_ApplyButton(dialog)
    local depth = dialog:GetDoubleField("CutDepth")
    local hardnerPercentage = dialog:GetDoubleField("HardnerPercentage")

    local registry = Registry("Epoxy_Volume_Calculator")
    registry:SetDouble("CutDepth", depth)
    registry:SetDouble("HardnerPercentage", hardnerPercentage)
    return true
end


--[[  ------------------------ main --------------------------------------------------
|
|  Entry point for script
|
]]
function main(script_path)
    
    -- Check we have a job loaded
    local job = VectricJob()
    
    if not job.Exists then
        DisplayMessageBox("No job open.")
        return false
    end
    
    local script_html = "file:" .. script_path .. "\\Epoxy_Volume_Calculator.htm"
    local dialog = HTML_Dialog(false, script_html, 510, 485, g_title)

    local registry = Registry("Epoxy_Volume_Calculator")
    local cutDepth = 0.125
    local percentCoverage = 0.9
    local hardnerPercentage = 0.83

    if registry:DoubleExists("CutDepth") then
        cutDepth = registry:GetDouble("CutDepth", 0.125)
    end
    if registry:DoubleExists("HardnerPercentage") then
        hardnerPercentage = registry:GetDouble("HardnerPercentage", 0.83)
    end
    
    dialog:AddLabelField("GadgetTitle", g_title)
    dialog:AddLabelField("GadgetVersion", "Version :" .. g_version)
    dialog:AddDoubleField("CutDepth", cutDepth)
    dialog:AddDoubleField("HardnerPercentage", hardnerPercentage)
    dialog:AddLabelField("AreaLabel", tostring(0.0))
    dialog:AddLabelField("VolumeLabel", tostring(0.0))
    dialog:AddLabelField("FluidLabel", tostring(0.0))
    dialog:AddLabelField("ResinLabel", tostring(0.0))
    dialog:AddLabelField("HardnerLabel", tostring(0.0))
    
    -- populate layer drop down
    local layer_manager = job.LayerManager
    local pos = layer_manager:GetHeadPosition()
    local isFirst = true
    while pos ~= nil do
        local layer
        layer, pos = layer_manager:GetNext(pos)
        if not layer.IsSystemLayer then
            if isFirst then
                dialog:AddDropDownList("DropDownList", layer.Name)
                dialog:AddDropDownListValue("DropDownList", layer.Name)
                isFirst = false
            else
                dialog:AddDropDownListValue("DropDownList", layer.Name)
            end
        end
    end -- end of for each layer
    
    -- Show the dialog
    if dialog:ShowDialog() then
      
    else 
      
      return false            
    end
    return true
end
