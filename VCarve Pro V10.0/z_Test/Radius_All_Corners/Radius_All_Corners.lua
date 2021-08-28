-- VECTRIC LUA SCRIPT
--require("mobdebug").start()
require "strict"

--[[--------------------Main Function------------------------------------
|
|
--]]

Options = {}
Options.GlobalGadgetNum = 0
Options.DisplayDialog = true
Options.ReplaceSelected = false
Options.SeparateLayer = true
Options.LayerName = "Radius All Corners"
Options.GadgetName = "Radius All Corners"
Options.HTMLName = "Radius_All_Corners.html"
Options.LuaName = "Radius_All_Corners.lua"
Options.RegistryName = "RadiusAllCorners"
Options.InnerRad = 0
Options.OuterRad = 0

function LoadSettings(Options,path)
 local registry = Registry(Options.RegistryName)
Options.ReplaceSelected = registry:GetBool("ReplaceSelected", Options.ReplaceSelected)
Options.SeparateLayer = registry:GetBool("SeparateLayer",Options.SeparateLayer)
Options.LayerName = registry:GetString("LayerName",Options.LayerName)
Options.InnerRad = registry:GetDouble("InnerRad", Options.InnerRad)
Options.OuterRad = registry:GetDouble("OuterRad", Options.OuterRad)
--Add the following to get the gadgets number held within the global gadgets settings app,
--what this does first is to check to see if the app itself has a stored number, if not it goes ahead and creates one
--stores it in its own registry and the ggs registry settings. then goes on to check whether to turn on the display of the form,
--if no registry is found because of first run, it will default to open the form.
Options.GlobalGadgetNum = registry:GetInt("GlobalGadgetNum",  Options.GlobalGadgetNum)

local GGS = Registry("GlobalGadgetSettings")
  if (Options.GlobalGadgetNum == 0) then
      local ggstotal = GGS:GetInt("Total", 0)
      local ggsnum = ggstotal +1
      GGS:SetInt("Total",ggsnum)
      GGS:SetBool(tostring(ggsnum), true)
      GGS:SetString(tostring(ggsnum).."_Name", Options.GadgetName)
      GGS:SetString(tostring(ggsnum).."_Path", path.."\\"..Options.LuaName)
      registry:SetInt("GlobalGadgetNum",ggsnum)
      Options.GlobalGadgetNum = ggsnum
  end
Options.DisplayDialog = GGS:GetBool(tostring(Options.GlobalGadgetNum), true)  
--End of Loading settings for ggs--------------------------------------
end

function SaveSettings(Options)
  local registry = Registry(Options.RegistryName)
  local GGS = Registry("GlobalGadgetSettings")
  registry:SetDouble("InnerRad",Options.InnerRad)
  registry:SetDouble("OuterRad",Options.OuterRad)
  registry:SetBool("ReplaceSelected", Options.ReplaceSelected)
  registry:SetBool("SeparateLayer",Options.SeparateLayer)
  registry:SetString("LayerName",Options.LayerName)
  --save latest setting for displaying the dialog
  GGS:SetBool(tostring(Options.GlobalGadgetNum),Options.DisplayDialog)  
end

function main(path)
 -- set job variable and check if job exists, which it should
 local job = VectricJob() 
 if not job.Exists then
   MessageBox("No job created, please start a new job and run the gadget")
   return false
 end
 --ensure there is a vector selection
 local selection = job.Selection
 if selection.IsEmpty then
    MessageBox("No objects selected, please select the vectors you wish to use this gadget with and re-run")
    return false
  end
  --set material block and layer manager variables
  local matblock = MaterialBlock()
  local LayerManager = job.LayerManager
-- load default options
 LoadSettings(Options,path)
 
--check options loaded to see whether to display dialog--
    if Options.DisplayDialog then
        -- Display the dialog
        local displayed_dialog = -1
        while displayed_dialog == -1 do
            displayed_dialog = DisplayDialog(path)
        end    
        if not displayed_dialog then 
            return false
        end
    end  
    
  --go through all selections whether groups of vectors or other types of object and radius each vector individually, for the purpose of
  --being able to manage all vectors as an individual case to place on original layers etc.
   local pos = selection:GetHeadPosition()
 local originalselection
 local to_delete = {}
    while (pos ~= nil) do 
        originalselection,pos = selection:GetNext(pos)
            if originalselection.ClassName == "vcCadModelPreview" then
              MessageBox("This gadget has detected a 3D model in the selection, the gadget will skip and proceed....")
            elseif originalselection.ClassName == "txtBlock" then
              MessageBox("This gadget has detected Text in the selection, please 'Convert To Curves' first, skipping and proceeding through selection....")
            elseif originalselection.ClassName == "vcCadBitmap" then
              MessageBox("This gadget has detected a Bitmap Image in the selection, skipping and proceeding through selection....")
            elseif originalselection.ClassName == "vcCadObjectGroup" then
                 local pos1 = originalselection:GetHeadPosition()
                 local cadcontour
                     while (pos1 ~= nil) do 
                         cadcontour,pos1 = selection:GetNext(pos1)
                         local contour = cadcontour:GetContour()
                         --to_delete[#to_delete + 1]= cadcontour.RawId
                             if not contour.IsEmpty then 
                                 local rawlayerid = cadcontour.RawLayerId
                                 --start work with the contour
                                 --create copy and put in a new group 
                                 local ContourCopy =  ContourGroup(true) 
                                 ContourCopy:AddTail(contour:Clone())
                                 --create radiused corners
                                 local NewRadVectors = CreateRadiusedCorners(ContourCopy)
                                 --add to existing or new layer dependant on user choice
                                 if not AddContourGroupToJob(job,rawlayerid,NewRadVectors) then
                                    MessageBox("Failed to add Radiused Vectors to layer")
                                 end
                                 if Options.ReplaceSelected then
                                    RemoveFromLayer(job,originalselection)
                                 end
                             end
                     end  
            else
                local contour = originalselection:GetContour()
                      if not contour.IsEmpty then 
                           local rawlayerid = originalselection.RawLayerId
                          --start work with the contour
                           --create copy and put in a new group 
                           local ContourCopy =  ContourGroup(true) 
                           ContourCopy:AddTail(contour:Clone())
                           --create radiused corners
                           local NewRadVectors = CreateRadiusedCorners(ContourCopy)
                           --add to existing or new layer dependant on user choice
                           if not AddContourGroupToJob(job,rawlayerid,NewRadVectors) then
                              MessageBox("Failed to add Radiused Vectors to layer")
                           end
                           if Options.ReplaceSelected then
                              RemoveFromLayer(job,originalselection)
                           end 
                      end
            end
    end
 job.Selection:Clear()
 job:Refresh2DView()
return true    
end   
  ----------------------------------------------------------------------------------------------



function CreateRadiusedCorners(ContourCopy)
  if Options.InnerRad ~= "" and Options.InnerRad ~= 0 and Options.InnerRad > 0 then
    ContourCopy = ContourCopy:Offset(Options.InnerRad,0.0,1, true)
    ContourCopy = ContourCopy:Offset(-Options.InnerRad,0.0,1, true)
  --else
  --MessageBox("No inner radius has been added because either no value was entered or the value was less than 0")
  end
  if Options.OuterRad ~= "" and Options.OuterRad ~= 0 and Options.OuterRad > 0 then
      ContourCopy = ContourCopy:Offset(-Options.OuterRad,0.0,1, true)
      ContourCopy =  ContourCopy:Offset(Options.OuterRad,0.0,1, true)
  --else
  --MessageBox("No outer radius has been added because either no value was entered or the value was less than 0")
  end
return ContourCopy
end


function AddContourGroupToJob(job,rawlayerid,contourgroup)
  --Set layer to add vector too
   local layer
   if Options.SeparateLayer then
      if Options.LayerName == "" then
          layer = job.LayerManager:GetLayerWithName(tostring(Options.GadgetName))
      else
          layer = job.LayerManager:GetLayerWithName(tostring(Options.LayerName))
      end
 else
   --MessageBox(rawlayerid)
    layer = job.LayerManager:GetLayerWithId(rawlayerid)
 end
 if (contourgroup ~= nil) then 
    local pos = contourgroup:GetHeadPosition()
    local contour
    while (pos ~= nil) do
      contour, pos = contourgroup:GetNext(pos)
      local cadcontour = CreateCadContour(contour)
      layer:AddObject(cadcontour,true)
    end
    return true
 else 
    return false
 end
end

function RemoveFromLayer(job,object)
 local layerid = object.RawLayerId
 local objlayer = job.LayerManager:GetLayerWithId(layerid)
       if objlayer:RemoveObject(object) then
            return true
       else
            return false
       end
end
--[[  -------------- DisplayDialog --------------------------------------------------  
|
|  Display the dialog
|
]]
function DisplayDialog(path, options)
local html_path = "file:" ..path .. "\\"..Options.HTMLName
local dialog = HTML_Dialog(false,html_path,300,580,Options.GadgetName)
  --Add preset values
dialog:AddDoubleField("InnerRad", Options.InnerRad)
dialog:AddDoubleField("OuterRad", Options.OuterRad)
dialog:AddCheckBox("NewLayer", Options.SeparateLayer)
dialog:AddCheckBox("ReplaceSelected", Options.ReplaceSelected)
dialog:AddCheckBox("DisplayDialog", Options.DisplayDialog)
dialog:AddTextField("LayerName",Options.LayerName)
-- Display the dialog
local success = dialog:ShowDialog()
  if not success then 
       return false;
  end

    
    --load options from dialog
Options.InnerRad = dialog:GetDoubleField("InnerRad")
Options.OuterRad = dialog:GetDoubleField("OuterRad")
Options.SeparateLayer = dialog:GetCheckBox("NewLayer")
Options.ReplaceSelected = dialog:GetCheckBox("ReplaceSelected")
Options.DisplayDialog = dialog:GetCheckBox("DisplayDialog")
Options.LayerName = dialog:GetTextField("LayerName")
SaveSettings(Options)  
--get selected objects from job
  return true
end
