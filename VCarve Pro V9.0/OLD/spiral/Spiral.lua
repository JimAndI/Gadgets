-- VECTRIC LUA SCRIPT
-- Gadgets are an entirely optional add-in to Vectric's core software products. 
-- They are provided 'as-is', without any express or implied warranty, and you make use of them entirely at your own risk.
-- In no event will the author(s) or Vectric Ltd. be held liable for any damages arising from their use.

-- Permission is granted to anyone to use this software for any purpose, 
-- including commercial applications, and to alter it and redistribute it freely, 
-- subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

require "strict"

g_version = "1.0"

local xy_origin_index = 0
local OriginX  = 0
local  OriginY  = 0	

local optSprial = 0
local txtwidth = 12
local txtTimesAround = 3
local txtArbitrary = 2

function UpdateOptionsFromDialog(dialog)

	xy_origin_index = dialog:GetRadioIndex("DrawingOrigin")
	OriginX  = dialog:GetDoubleField("OriginX")
	OriginY  = dialog:GetDoubleField("OriginY")

	optSprial  = dialog:GetRadioIndex("optSprial")
	txtwidth  = dialog:GetDoubleField("txtwidth")
	txtTimesAround = dialog:GetDoubleField("txtTimesAround")
	txtArbitrary = dialog:GetDoubleField("txtArbitrary")



    return true

end


function SaveOptionsToObject(object)
    object:SetInt("luaSG_SpiralOptionsVersion", 1)
	object:SetInt("luaSG_txtoptSprial", optSprial)
	object:SetDouble("luaSG_txtwidth", txtwidth)
	object:SetDouble("luaSG_txtTimesAround", txtTimesAround)
	object:SetDouble("luaSG_txtArbitrary", txtArbitrary)
	
	object:SetInt("luaSG_DrawingOrigin", xy_origin_index)
	object:SetDouble("luaSG_OriginX", OriginX)
	object:SetDouble("luaSG_OriginY", OriginY)
	
    return true
end

function LoadOptionsFromObject(object)
    if object == nil then
	   return false
	end
	
	-- check this object had the settings we want ....
	if not object:ParameterExists("luaSG_SpiralOptionsVersion", ParameterObject.UTP_INT) then
	
       return false
	end  
	

	optSprial 		 = object:GetInt("luaSG_txtoptSprial", optSprial, false)
	txtwidth         = object:GetDouble("luaSG_txtwidth", txtwidth, false)
	txtTimesAround   = object:GetDouble("luaSG_txtTimesAround", txtTimesAround, false)
	txtArbitrary     = object:GetDouble("luaSG_txtArbitrary", txtArbitrary, false)

	xy_origin_index  = object:GetInt("luaSG_DrawingOrigin", xy_origin_index, false)
	OriginX          = object:GetDouble("luaSG_OriginX", OriginX, false)
	OriginY          = object:GetDouble("luaSG_OriginY", OriginY, false)
	
    return true
	
end


function LoadOptionsFromSelection(selection)

-- Check the selection isn't empty
	if selection.IsEmpty then
	
		return false
	end

	-- Get the first item in the selection
	local pos = selection:GetHeadPosition()
	local firstItem = selection:GetAt(pos)

	
    local got_options =  LoadOptionsFromObject(firstItem)

	
	return got_options
	
end


function OnLuaButton_CreateSpiral(dialog)

	-- Get the current job
	local job = VectricJob()
	if not job.Exists then
		return true
	end

	-- Update the options from the dialog
	if not UpdateOptionsFromDialog(dialog) then
		return true
	end
	
	-- Create the cross section
	DrawSprial(optSprial,txtwidth,txtTimesAround,txtArbitrary,Point2D(OriginX,OriginY),xy_origin_index)
	job:Refresh2DView()
	
	
	return true
end





function main(script_path)
	--
	local registry = Registry("Spiral")
	local retry_dialog = true
	local job = VectricJob()

	if not job.Exists then
		DisplayMessageBox("There is no existing job open")
		return false;
	end
	

	
	xy_origin_index = registry:GetInt("xy_origin_index",     xy_origin_index)
	OriginX = registry:GetDouble("OriginX",     OriginX)
	OriginY = registry:GetDouble("OriginY",     OriginY)
	
	optSprial = registry:GetInt("optSprial",     optSprial)
	txtwidth = registry:GetDouble("txtwidth",     txtwidth)
	txtTimesAround = registry:GetDouble("txtTimesAround",     txtTimesAround)
	txtArbitrary = registry:GetDouble("txtArbitrary",     txtArbitrary)


    -- if user is running gadget with a previously selected gear, pick settings up from that
	local got_options =  LoadOptionsFromSelection(job.Selection)
	
	-- does user want to replace existing spiral?
	if got_options then
	   -- we only replace a single selected spiral
	   if job.Selection.Count > 1 then
	      job.Selection:Clear()
	   end	  
	else
	   -- clear selection as new spiral we be sdelected
	   job.Selection:Clear()
	end
	job:Refresh2DView()
	-- when we reach here, if anything is selected it should be a spiral we will replace

	local html_path = "file:" .. script_path .. "\\Spiral\\Spiral.htm"
	local frmMain = HTML_Dialog(false, html_path, 490, 610, "Spiral")
	
	frmMain:AddRadioGroup("DrawingOrigin", xy_origin_index)
	frmMain:AddDoubleField("OriginX", OriginX)
	frmMain:AddDoubleField("OriginY", OriginY)
	
	frmMain:AddRadioGroup("optSprial", optSprial)
	frmMain:AddDoubleField("txtwidth", txtwidth)
	frmMain:AddDoubleField("txtTimesAround", txtTimesAround)
	frmMain:AddDoubleField("txtArbitrary", txtArbitrary)
	frmMain:AddLabelField("WebSite", "www.cabinetpartspro.com")
	frmMain:AddLabelField("WebSite2", "www.cabinetpartspro.com")
	frmMain:AddLabelField("GadgetVersion", g_version)
	
	frmMain:ShowDialog() 
		
	registry:SetDouble("OriginX",     OriginX)
	registry:SetDouble("OriginY",     OriginY)
	registry:SetInt("xy_origin_index",     xy_origin_index)
	
	registry:SetInt("optSprial",     optSprial)
	registry:SetDouble("txtwidth",     txtwidth)
	registry:SetDouble("txtTimesAround",     txtTimesAround)
	registry:SetDouble("txtArbitrary",     txtArbitrary)
	

	return true
end

function DrawSprial(SprialType,Size,Times_Around,Arbitrary,origin_off,xy_origin_index)
	local mydoc = VectricJob()
	local linePTs = {}
	local MyLine 
	local Angle = 0
	--local Times_Around =3
	--local Size = 24
	local SaleFacter = 0
	local strSprialType = "test"
	if not mydoc.Exists then
		MessageBox("There is not existing doc loaded")
		return false;
	end
	
    if 	txtTimesAround <= 0 then
		MessageBox("Please enter a number greater than 0")
		return false
	end

 --MessageBox(" " .. SprialType)
	local i = 0
	local x = 1
	local y = 1
	
	local Sizeinc = Size/360/Times_Around
	--MessageBox("Sizeinc " .. Sizeinc)
	Size = 0
	local e = 2.718281828
	local cX = 0
    local cy = 0
	local a = .5/10
    local b = Arbitrary/10
	
	--linePTs[0] = Point2D(cX,cX)
	Angle = math.rad(360*Times_Around)+ math.rad(1)
	--MessageBox("Angle " .. Angle)
	while math.rad(i) < math.rad(360*Times_Around) do
	
    --while Angle < math.rad(360*Times_Around)+ math.rad(1) do
		--logarithmic
		if SprialType == 1 then
			strSprialType = "logarithmic"
			x = (a * (math.cos(Angle)) * (e ^ (b * Angle)))
			y = (a * (math.sin(Angle)) * (e ^ (b * Angle)))
		elseif SprialType == 2 then
			--Involute 
			strSprialType = "Involute"
			x = Angle *(a *(math.cos(Angle) + Angle * math.sin(Angle)))
			y = Angle *(a *(math.sin(Angle) - Angle * math.cos(Angle)))
	
		elseif SprialType == 3 then
			--Archimedes
			strSprialType = "Archimedes"
			x = Size*math.cos(Angle)
			y = Size*math.sin(Angle)
		elseif SprialType == 4 then
			--Golden
			strSprialType = "Golden"
			x = math.cos (Angle) * 2 ^ ((2 / math.pi) * Angle)
			y = math.sin (Angle) * 2 ^ ((2 / math.pi) * Angle)
		end
		linePTs[i] = Point2D(1*x,y)
		--linePTs[i] = Point2D(-1*x,y)
		Angle = Angle + math.rad(1)
		 i= i + 1
		Size = Size + Sizeinc
	end
	MyLine = Draw_Line(mydoc,linePTs)
	local bounds2 = MyLine.BoundingBox2D
	
	SaleFacter =Size / bounds2.XLength 
	MyLine = Scale (mydoc,MyLine,Point2D(0,0),Vector2D(SaleFacter,SaleFacter))
	bounds2 = MyLine.BoundingBox2D
	
	--local origin_off = Point2D(0,0)
	if xy_origin_index == 1 then --"TLC 
		origin_off.x = OriginX -- (bounds2.XLength )
		origin_off.y = OriginY - (bounds2.YLength )
   	elseif xy_origin_index == 2 then  --TRC 
		origin_off.x = OriginX  - bounds2.XLength -- (bounds2.XLength)
		origin_off.y = OriginY - bounds2.YLength -- (bounds2.YLength)
   	elseif xy_origin_index == 3 then --CENTRE 
		origin_off.x = OriginX - (bounds2.XLength / 2)
		origin_off.y = OriginY - (bounds2.YLength/ 2)
   	elseif xy_origin_index == 4 then --BLC  
		origin_off.x = OriginX  - bounds2.XLength + (bounds2.XLength)
		origin_off.y = OriginY - bounds2.YLength + (bounds2.YLength)
   	elseif xy_origin_index == 5 then --BRC 
		origin_off.x = OriginX  - bounds2.XLength
		origin_off.y = OriginY - bounds2.YLength + (bounds2.YLength)
  	end
	origin_off.x = origin_off.x+(-1*bounds2.MinX)
	origin_off.y = origin_off.y+(-1*bounds2.MinY)
		
	MyLine = Move(mydoc,MyLine,Vector2D(origin_off.x,origin_off.y))
	Refreash(mydoc,MyLine,"Sprial")
	
	
	--MessageBox(" Miny " .. round(bounds2.MinY,3) .. " MinX " .. bounds2.MinX)
	return true
end


-----CoTangent 
-----Aguments ...number
-----Returns Contour

function CoTangent(X )
   return  1 / math.tan(X)
end 

-----Draw Line 
-----Aguments ... CadDocument .. array of X,Y points
-----Returns Contour
function Draw_Line(doc,XYPoints)

	local MyContour = Contour(0.0)
	local p1 = XYPoints[0]
	local Angle
   	MyContour:AppendPoint(p1)
	for i=1, #XYPoints do
		local p2 = XYPoints[i]
		MyContour:LineTo(p2)
	end
	return MyContour; 
end

-----Draw Arc 
-----Aguments ... CadDocument .. array of X,Y points
-----Returns Contour
function Draw_Arc(doc,XYPoints,PTCenter,LayerName)

	local MyContour = Contour(0.0)
	local p1 = XYPoints[0]
	local Angle
   	MyContour:AppendPoint(p1)
	for i=1,#XYPoints do
		local p2 = XYPoints[i]
		MyContour:ArcTo(p2,PTCenter, false)
	end
	return MyContour; 
end
-----Refreash 
-----Aguments ... CadDocument .. Contour .. Layername
-----Returns
function Refreash (doc,Contour,LayerName)

	local cad_object = CreateCadContour(Contour)
	-- add parameters
	SaveOptionsToObject(cad_object)

	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName(LayerName)-- and add our object to it - on active sheet
	
	-- if we have any objects selecte we need to delete it as we are replacing it with our new spiral
	if not doc.Selection.IsEmpty then
		local pos = doc.Selection:GetHeadPosition()
		local old_spiral = doc.Selection:GetAt(pos)
		doc.Selection:Clear()
		local layer_id = luaUUID()
		layer_id:Set(old_spiral.LayerId)
		layer = doc.LayerManager:GetLayerWithId(layer_id.RawId)
		layer:RemoveObject(old_spiral)
	end
	
	layer:AddObject(cad_object, true)
	layer.Colour = 0 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	
	doc.Selection:Add(cad_object, true, false)
	
	doc:Refresh2DView()
	return true
end

-----Scale 
-----Aguments ... CadDocument .. Contour .. Center of Mirror 2D point
-----Returns Contour
function Scale (doc,MyContour,CenterM,ScaleVec)
  	local mirror_X_xform = ScalingMatrix2D (CenterM, ScaleVec)
	MyContour:Transform(mirror_X_xform)
	return MyContour; 
end

-----Move 
-----Aguments ... CadDocument .. Contour .. Move Distance
-----Returns Contour
function Move(doc,Con,MoveDis)
   	local MoveThis = TranslationMatrix2D(MoveDis)
	Con:Transform(MoveThis)
	return Con;
end
-----SelectVectorsOnLayer 
-----Aguments ...CadDocument.. LayerName .. Contour .. Layername
-----Returns Selected objects..Closed as boolean ..Open as boolean..Grouped as boolean
function SelectVectorsOnLayer(doC,Layer_Name,select_closed, select_open, select_groups)
     -- clear current selection
   local selection = doC.Selection
   selection:Clear()
   
   local objects_selected = false
   local warning_displayed = false
   local layer = doC.LayerManager:FindLayerWithName(Layer_Name)
   if layer == nil then
   		MessageBox("Layer name not found")
   		return false
   end 
   
   local pos = layer:GetHeadPosition()
      while pos ~= nil do
         object, pos = layer:GetNext(pos)
         local Contour = object:GetContour()
         if Contour == nill then
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
         else  -- contour was NOT nill, test if Open or Closed
            if Contour.IsOpen and select_open then
               selection:Add(object, true, true)
               objects_selected = true
            else if select_closed then
               selection:Add(object, true, true)
               objects_selected = true
            end            
         end
         end
      end  
   -- to avoid excessive redrawing etc  we added vectors to the selection in 'batch' mode
   -- tell selection we have now finished updating
   if objects_selected then
      selection:GroupSelectionFinished()
   end   
   return objects_selected   
end  

-----GetAngle 
-----Aguments ... Startpoint and Endpoint
-----Returns angle between the two points
function GetAngle(points1 , points2)  
	local a  
	a = MyTan(points2.x - points1.x, points2.y - points1.y)
	return a * (180 / math.pi) - 90
end 
function MyTan(d1,d2) 
	if  d2 < 0 then
		return (math.pi / 2) + math.atan(d1 / d2)
	elseif d2 > 0 then
		return (math.pi * 1.5) + math.atan(d1 / d2)
	elseif d2 == 0 then
		--return iif(d1 < 0, math.pi, math.pi * 2)
		if d1 < 0 then
			return math.pi
		else
			return math.pi * 2
		end
	end
	return false
end 	

-----FindLineCircleIntersections 
-----Aguments ... Circle CenterPoints.. radius.. startpoint and endpoint of line
-----Returns intersecting points
function FindLineCircleIntersections( CenterPT  ,  radius  , line1  , line2 )  
--ix1,iy1,ix2,iy2    
   local dx
   local dy  
   local A   
   local B  
   local C  
   local det  
   local t 
	local Interec1
	local interec2
	
   dx = line2.x - line1.x
   dy = line2.y - line1.y

   A = dx * dx + dy * dy
   B = 2 * (dx * (line1.x - CenterPT.x) + dy * (line1.y - CenterPT.y))
   C = (line1.x - CenterPT.x) * (line1.x - CenterPT.x) + (line1.y - CenterPT.y) * (line1.y - CenterPT.y) - radius * radius

   det = B * B - 4 * A * C
   if (A <= 0.0000001) or (det < 0) then
       -- No real solutions.
       return 0,ix1,iy1,ix2,iy2
   elseif det == 0 then
       -- One solution.
       t = -B / (2 * A)
       ix1 = line1.x + t * dx
       iy1 = line1.y + t * dy
	   Interec1 = Point2D(ix1,iy1)
	   Interec1 = Point2D(ix2,iy2)
       return 1,Interec1,Interec1
   else
       -- Two solutions.
       t = (-B + math.sqrt(det)) / (2 * A)
       ix1 = line1.x + t * dx
       iy1 = line1.y + t * dy
       t = (-B - math.sqrt(det)) / (2 * A)
       ix2 = line1.x + t * dx
       iy2 = line1.y + t * dy
	   Interec1 = Point2D(ix1,iy1)
	   Interec1 = Point2D(ix2,iy2)
       return 2,Interec1,Interec1
   end 
end 	

-----RotatePoint 
-----Aguments ... Degree .. radius
-----Returns new x y points
function RotatePoint(Deg, Rad)
	local theta
	local dtheta 
	local cx 
	local cy 
	--MessageBox (" Deg " .. Deg .. " Rad " ..Rad)
	cx = Rad
	cy = 0
	theta = 0
	dtheta = math.pi / Deg 
	theta = theta + dtheta
	New_X = math.cos(theta) * cx - math.sin(theta) * cy
	New_Y = math.sin(theta) * cx + math.cos(theta) * cy
	
	
	--Console.WriteLine(Xoff & "," & Yoff)
	return  New_X,New_Y
end 

-----Perpendicular 
-----Aguments ... 
-----Returns 
function Perpendicular( X1  ,  Y1  ,  X2  ,  Y2  ,  BitRad  ,  Dirc  ,  Profile  ,  CenX  ,  CenY  )
	local Run
	local angle
	local Raise
	local points1 = {}
	local points2 = {}
	local Center = {}
	local First 
	local Second 
	local Quad 
	local Amid = {}
	local Rad 
	
	points1[0] = X2
	points1[1] = Y2
	
	points2[0] = X1
	points2[1] = Y1
	
	if Profile == "InSide" then
		if points1[0] > points2[0] and points1[1] < points2[1] then
			Quad = "BL" 
		elseif points1[0] > points2[0] and points1[1] > points2[1] then
			Quad = "BR"
		elseif points1[0] < points2[0] and points1[1] > points2[1] then
			Quad = "TR" 
		elseif points1[0] < points2[0] and points1[1] < points2[1] then
			Quad = "TL" 
		end 
	elseif Profile == "OUT" then
		if points1[0] > points2[0] and points1[1] < points2[1] then
			Quad = "BL" 
		elseif points1[0] > points2[0] and points1[1] > points2[1] then
			Quad = "BR"
			
		elseif points1[0] < points2[0] and points1[1] > points2[1] then
			Quad = "TR" 
		elseif points1[0] < points2[0] and points1[1] < points2[1] then
			Quad = "TL" 
		end 
	end 
	
	--MessageBox ("Line 224 " .. points1.x)
	angle = (GetAngle(Point2D(points1[0],points1[1]), Point2D(points2[0],points2[1])) - 180) * (math.pi / 180)
	Run = math.cos(angle) * BitRad
	Raise = math.sin(angle) * BitRad
	--top right of circle
	if Run < 0 and Raise > 0 then
		if Quad == "BL" then
			Run = math.abs(Run)
		else
			Raise = -1 * Raise
		end 
	--Top Left of circle
	elseif Run > 0 and Raise > 0 then
		if Quad == "BR" then
			Run = -1 * Run
		else
			Raise = -1 * Raise
		end 
	--Bttom Left of circle
	elseif Run > 0 and Raise < 0 then
		if Quad == "TR" then
			Run = -1 * Run
		else
			--Raise = Abs(Raise)
			--Run = -1 * Run 'I added the run = for DC Cabinets may not be right
		end 
	--Bttom right of circle
	elseif Run < 0 and Raise < 0 then
		if Quad == "TL" then
			Run = math.abs(Run)
		else
			Raise = math.abs(Raise)
			--MessageBox ("Raise " .. Raise )
		end 

	elseif Raise == 0 and Run > 0 and Profile == "InSide" and Dirc == true then
		Run = -1 * Run
	elseif Raise == 0 and Run < 0 and Profile == "InSide" and Dirc == true then
		Run = math.abs(Run)
	elseif Run == 0 and Raise > 0 and Profile == "InSide" and Dirc == false then
		Raise = -1 * Raise
	elseif Run == 0 and Raise < 0 and Profile == "InSide" and Dirc == false then
		Raise = math.abs(Raise)
	elseif Run < 0 and Raise == 0 and Profile == "OUT" and Dirc == true then
		Run = math.abs(Run)
	elseif Run > 0 and Raise == 0 and Profile == "OUT" and Dirc == true then
		Run = -1 * Run
	elseif Run == 0 and Raise < 0 and Profile == "OUT" and Dirc == false then
		Raise = math.abs(Raise)
	elseif Run == 0 and Raise > 0 and Profile == "OUT" and Dirc == false then
		Raise = -1 * Raise
	--ElseIf Run > 0 And Raise > 0 And Profile = "OUT" And Dirc = True Then 'I added hoping it would help May screw somthing else up
	--    Raise = -1 * Raise
	--    Run = -1 * Run
	end 
	
	Xoff = Run
	Yoff = Raise
	--MessageBox ("Run " .. Run .. " Raise " .. Raise)
	return Xoff,Yoff
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end


