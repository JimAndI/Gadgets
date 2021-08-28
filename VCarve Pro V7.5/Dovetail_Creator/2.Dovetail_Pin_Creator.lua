-- VECTRIC LUA SCRIPT

--require("mobdebug").start()
--require "strict"

g_version = "1.0"
g_title = "Dovetail Pin/Tail Creator"
g_width = 650
g_height = 655
g_html_file = "Dovetail_Pin_Creator.html"

--[[--------------------Main Function------------------------------------
|
|     Checks if job exists, checks if objects have been selected on job, sets dialog.
|
|
--]]

function main(path)
 job = VectricJob() 
 if not job.Exists then
   MessageBox("No job created, please start a new job and run the gadget")
   return false
 end
 selection = job.Selection
 if selection.IsEmpty then
    MessageBox("No objects selected, please select the line/s you wish to add the pins or tails to and re-run the gadget")
    return false
  end
  local matblock = MaterialBlock()
  layer = job.LayerManager:GetActiveLayer()  
  
  --Set options
  options = {}
  options.Number = 2
  options.PinWidth = 1
  options.PinDepth = matblock.Thickness
  options.Angle = 20
  options.CutType = 1
  options.windowWidth = g_width
  options.windowHeight = g_height
  options.delmarkers = false
  --load options from registry
  LoadDefaults(options)
  
local success = DisplayDialog(path, options)
if not success then
  return false
end

local result = GetSelectedObjects()
if result then
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
  local html_path = "file:" ..path .. "\\" .. g_html_file
  dialog = HTML_Dialog(false, 
                             html_path, 
                             options.windowWidth, 
                             options.windowHeight,
                             g_title)
  --Add preset values
  dialog:AddIntegerField("Number", options.Number)
  dialog:AddDoubleField("PinDepth", options.PinDepth)
  dialog:AddDoubleField("PinWidth", options.PinWidth)
  dialog:AddDoubleField("Angle", options.Angle)
  dialog:AddRadioGroup("type", options.CutType)
  dialog:AddCheckBox("delmarkers", false)
  
  -- Display the dialog
  local success = dialog:ShowDialog()

  if not success then 
  	return false
  end
    --load options from dialog
  options.Number = dialog:GetIntegerField("Number")
  options.PinWidth = dialog:GetDoubleField("PinWidth")
  options.PinDepth = dialog:GetDoubleField("PinDepth")
  options.Angle = dialog:GetDoubleField("Angle")
  options.CutType = dialog:GetRadioIndex("type")
    options.windowWidth  = dialog.WindowWidth
  options.windowHeight = dialog.WindowHeight
  options.delmarkers = dialog:GetCheckBox("delmarkers")
  --save options selected for future use
  SaveDefaults(options)  
  --get selected objects from job
  

  return true
end

--[[  -------------- LoadDefaults --------------------------------------------------  
|
|  Load defaults from the registry
|
]]    
function LoadDefaults(options)
  local registry = Registry("DovetailPinCreator")
  options.Number = registry:GetInt("Number", 2)
  options.PinWidth = registry:GetDouble("PinWidth", 1)

  options.Angle = registry:GetDouble("Angle",20)
  options.CutType = registry:GetInt("CutType",1)
  options.windowWidth = registry:GetInt("WindowWidth",  g_width)
  options.windowHeight = registry:GetInt("WindowHeight", g_height)
  end

  --[[-- Check the window dimensions
  if window_width < 0 then
     window_width = options.windowWidth
  end
  if window_height < 0 then
     window_height = options.windowHeight
  end

  options.windowWidth  = window_width
  options.windowHeight = window_height
end--]]


--[[  -------------- SaveDefaults --------------------------------------------------  
|
| Save defaults to registry
|
]]
function SaveDefaults(options)
  local registry = Registry("DovetailPinCreator")
  registry:SetInt("Number",options.Number)
  registry:SetDouble("PinWidth",options.PinWidth)
  registry:SetDouble("Angle",options.Angle)
  registry:SetInt("CutType",options.CutType)
  registry:SetInt("WindowWidth",options.windowWidth)
  registry:SetInt("WindowHeight",options.windowHeight)  
  local CreatorReg= Registry("DoveTailGadget")
    CreatorReg:SetString("MarkerLayerName", "MarkerLayer")
    CreatorReg:SetDouble("Angle",math.rad(options.Angle))
    CreatorReg:SetDouble("Thickness",options.PinDepth)
    CreatorReg:SetDouble("CutDepth",options.PinDepth)
end





--[[  -------------- MakeLine --------------------------------------------------  
|
|  Make a straight line contour between two points
|
]]
function MakeLine
  (
  start_pt, -- start point
  end_pt    -- end point
  )
  local contour = Contour(0.0)
  contour:AppendPoint(start_pt)
  contour:LineTo(end_pt)
  return contour
end

--[[ ----------------------Create Pins----------------------------------------------
|
|         Creates pins with equal spacing between the whole length of the line, either
|          90 degree angles going out to the left or right.
|
|--]]

function CreatePins(spanlength,spanstart,spanend,spandir,PinWidth,PinDepth,Number,Splits)  
  --check to see with the given parameters if the is going to be enough room to create the specified amount of pins  
  if Splits <= 0 then 
    MessageBox("Pins could not fit to line, please reduce the pin settings")
    return false
  end   
   Marker_Group = ContourGroup(true) -- cad group with dovetail markers
  local contour = Contour(0.0) -- contour for the pins
  local marker = Contour(0.0) -- contour for the markers  
      contour:AppendPoint(spanstart) -- first point of contour appended before for loop
  local firstspan = spanstart   
  for i = 1, Number do -- create pins in a for loop to the amount specified on dialog
      firstspan = firstspan + Splits * spandir
      contour:LineTo(firstspan)
      marker:AppendPoint(firstspan)
      local lvector = spandir:NormalTo() 
      lvector:Normalize()
      local lspan = firstspan + (PinDepth * -lvector)
      contour:LineTo(lspan)
      local tspan = lspan + (PinWidth * spandir)
      contour:LineTo(tspan)
      local rspan = tspan + (PinDepth * lvector)
      contour:LineTo(rspan)
      Marker_Group:AddTail(MakeLine(firstspan, rspan))--create line that puts a marker for the create toolpath gadget 
      firstspan = rspan      --set the firstspan to the end span so the start point is where the loop left off to continue the contour
  end
  local endspan = firstspan + (Splits * spandir) -- create the last span to finish off the contour outside of the loop
    contour:LineTo(endspan)
    selection:Clear() 
    --
    --Add contours from contour group for the markers to the markers layer
   local pos = Marker_Group:GetHeadPosition()
   local marker_layer = job.LayerManager:GetLayerWithName("MarkerLayer")
   while pos ~= nil do
     mcontour, pos = Marker_Group:GetNext(pos)
     cad_contour = CreateCadContour(mcontour)
     cad_contour:SetDouble("DovetailMarkerStartX",spanstart.x)
     cad_contour:SetDouble("DovetailMarkerStartY", spanstart.y)
     cad_contour:SetDouble("DovetailMarkerEndX",  spanend.x)
     cad_contour:SetDouble("DovetailMarkerEndY",  spanend.y)
     marker_layer:AddObject(cad_contour, true)
   end
  -----------------------------------------------
  --Add pins to the original layer
    line_object = CreateCadContour(contour)
    line_object:SetBool("DovetailPinCreator", true)
    line_object:SetString("DovetailPinCreatorType","Pin")
    line_object:SetDouble("DovetailPinCreatorStartX",spanstart.x)
    line_object:SetDouble("DovetailPinCreatorStartY",spanstart.y)
    line_object:SetDouble("DovetailPinCreatorEndX",spanend.x)
    line_object:SetDouble("DovetailPinCreatorEndY",spanend.y)
    layer:AddObject(line_object,true)
    
   -------------------------------------
    job:Refresh2DView() 
    job.LayerManager:SetActiveLayer(layer)
 return true
  end

--[[ --------------Create Dovetails------------------------------------------
|
|           Create Dovetails equally spaced to the angle set by the user
|
--]]

function CreateTails(spanlength,spanstart,spanend,spandir,PinWidth,PinDepth,Number,Splits,Angle)     
  local contour = Contour(0.0)
  local lvector = spandir:NormalTo() 
      lvector:Normalize() 
     local offsetstart = spanstart + PinDepth * -lvector
      contour:AppendPoint(offsetstart) 
      local firstspan = offsetstart
  for i = 1, Number do     
      firstspan = firstspan + Splits * spandir
      contour:LineTo(firstspan)          
      local lspan = firstspan + (PinDepth * lvector)
      local offset = PinDepth * math.tan(Angle)
      ------------check to see if there will be enough room for the specified amount of tails
      if offset > Splits / 2 then
        MessageBox("At this angle your Dovetails are going to overlap. Consider less Dovetails, smaller depth, smaller width or a steeper angle.")
        return false
      end
      local stangle = lspan - (offset * spandir)
      contour:LineTo(stangle)
      local tspan = lspan + (PinWidth * spandir)
      --contour:LineTo(tspan)
      local endangle = tspan + (offset * spandir)
      contour:LineTo(endangle)
      local rspan = tspan + (PinDepth * -lvector)
      contour:LineTo(rspan)
      firstspan = rspan  
   
    
  end
  local endspan = firstspan + (Splits * spandir)
    contour:LineTo(endspan)
    selection:Clear()
    line_object = CreateCadContour(contour)
    line_object:SetString("DovetailPinCreatorType","Tail")
    line_object:SetBool("DovetailPinCreator", true)
     line_object:SetDouble("DovetailPinCreatorOffsetX",offsetstart.x)
    line_object:SetDouble("DovetailPinCreatorOffsetY",offsetstart.y)
    line_object:SetDouble("DovetailPinCreatorStartX",spanstart.x)
    line_object:SetDouble("DovetailPinCreatorStartY",spanstart.y)
    line_object:SetDouble("DovetailPinCreatorEndX",spanend.x)
    line_object:SetDouble("DovetailPinCreatorEndY",spanend.y)
    layer:AddObject(line_object,true)
    job:Refresh2DView() 
    job.LayerManager:SetActiveLayer(layer)
 return true
end

--[[--------------------Get Selected Objects----------------
|
|     Get selected objects,
|
|
--]]

function GetSelectedObjects()   
  ret_contours = ContourGroup(true) 
  local to_delete = {}
  local pos = selection:GetHeadPosition()
  local cad_obj
  while (pos ~= nil) do
    cad_obj, pos = selection:GetNext(pos)
    local contouredit = cad_obj:ParameterExists("DovetailPinCreator",ParameterList.UTP_BOOL) and cad_obj:GetBool("DovetailPinCreator",false,false)     
    local contour = cad_obj:GetContour()
    if contour == nil then
      DisplayMessageBox("Found objects with no contour data. Ignoring")
    else
      

        if contouredit then
        local layer = job.LayerManager:GetLayerWithName("MarkerLayer")
        local stpt
        local enpt
        if options.CutType == 1 and cad_obj:GetString("DovetailPinCreatorType","",false) == "Pin" or options.CutType == 2 and cad_obj:GetString("DovetailPinCreatorType","",false) == "Pin"  then
        local pos = layer:GetHeadPosition()
        local marker_obj
        while (pos ~= nil) do
        marker_obj, pos = layer:GetNext(pos)
          if marker_obj:ParameterExists("DovetailMarkerStartX",ParameterList.UTP_DOUBLE) then
            if marker_obj:GetDouble("DovetailMarkerStartX",0.00,false) == cad_obj:GetDouble("DovetailPinCreatorStartX",0.00,false) and marker_obj:GetDouble("DovetailMarkerStartY",0.00,false) == cad_obj:GetDouble("DovetailPinCreatorStartY",0.00,false) and cad_obj:GetDouble("DovetailPinCreatorEndX",0.00,false) == marker_obj:GetDouble("DovetailMarkerEndX",0.00,false) and cad_obj:GetDouble("DovetailPinCreatorEndY",0.00,false) == marker_obj:GetDouble("DovetailMarkerEndY",0.00,false) then
              
            layer:RemoveObject(marker_obj)
          end
        end
      end
      stpt =  contour.StartPoint2D
     enpt =  contour.EndPoint2D
      
     
      
    else
      local startpt = contour.StartPoint2D
      if cad_obj:GetDouble("DovetailPinCreatorOffsetX",0.00,false) == startpt.x and cad_obj:GetDouble("DovetailPinCreatorOffsetY",0.00,false) == startpt.y then
      stpt = Point2D(cad_obj:GetDouble("DovetailPinCreatorStartX",0.00,false),cad_obj:GetDouble("DovetailPinCreatorStartY",0.00,false))
      enpt = Point2D(cad_obj:GetDouble("DovetailPinCreatorEndX",0.00,false),cad_obj:GetDouble("DovetailPinCreatorEndY",0.00,false)) 
    else
      stpt =  contour.StartPoint2D
     enpt =  contour.EndPoint2D
      
        end      
      end
          
          local newcontpt= Contour(0.0)
          newcontpt:AppendPoint(stpt)
          newcontpt:LineTo(enpt)
          ret_contours:AddTail(newcontpt)
          to_delete[#to_delete + 1]= cad_obj.RawId
        else  
          if (IsLine(contour)) then 
          ret_contours:AddTail(contour:Clone())
          to_delete[#to_delete + 1]= cad_obj.RawId 
        end
      end
      
    end
  end
  if ret_contours.IsEmpty then
  MessageBox("No single line spans were found, please ensure you select single lines and re-run the gadget")
else
  local success  = GetSpanStats()
  if success then
    selection:Clear()
    RemoveAllObjects(to_delete)
  end
  
  
end
  return ret_contours
end



    


--[[  -------------- RemoveAllObject --------------------------------------------------  
|
|  Remove all objects in the list of ids.
|
]]
function RemoveAllObjects(to_delete)
  for i=1,#to_delete do
    local current_id = to_delete[i]
    local position  = layer:Find(current_id)
    if position then
      layer:RemoveAt(position)
    end  
  end
end
 
 
  
--[[  -------------- IsLine --------------------------------------------------  
|
|  Returns true if the contour is a line with just the one span.
|
]]
function IsLine(contour,contouredit)
   
  if contour.Count ~=  1 then
    return false
  end
  
  local first_span = contour:GetFirstSpan()
  if first_span == nil then
    return false
  end
  
  return first_span.IsLineType
end

--[[-------------Get Span Stats--------------------------------
|
|       Get data from each span, start points end points length etc
|
|
--]]

function GetSpanStats()
local pos = ret_contours:GetHeadPosition()
local contour
local result = true 
  while (pos ~= nil and result) do
    contour, pos = ret_contours:GetNext(pos)   
    span = contour:GetFirstSpan()
    local spanlength = span:GetLength(0.0)
    local spanstart = span.StartPoint2D
    local spanend= span.EndPoint2D
   --[[ if spanstart.y < spanend.y then
      span:Reverse()
      end   --]]
    local spandir = span:StartVector(true)
    local PinWidth = options.PinWidth
    local PinDepth = options.PinDepth
    local Number = options.Number 
    local Splits =  (spanlength - (PinWidth * Number)) / (Number +1)
    local Angle = math.rad(options.Angle)
      if options.CutType == 1 then
      result = CreatePins(spanlength,spanstart,spanend,spandir,PinWidth,PinDepth,Number,Splits)
      else
      result =  CreateTails(spanlength,spanstart,spanend,spandir,PinWidth,PinDepth,Number,Splits,Angle)
      end
  end

return result

end

