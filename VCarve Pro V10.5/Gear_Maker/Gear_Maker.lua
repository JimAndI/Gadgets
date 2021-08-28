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

--[[-------------------------------------------------------------------------------------------------------
|
| VCarve Pro / Aspire Lua script to create gears
|
| Written By Ryan Patterson
|
]]

require "strict"

-- Global default values - overwritten with last values used if any
g_version = "1.1 by Ryan Patterson"
g_NoTeeth = 20
g_DiaPitch = 5
g_PressureAngle = 14.5
g_Bore = 0.5
g_LineRes = 20

g_XY_OriginIndex = 0
g_OriginX  = 0
g_OriginY  = 0		
g_ShowData = false

function UpdateOptionsFromDialog(dialog)

	g_NoTeeth        = dialog:GetIntegerField("txtNoTeeth")
	g_DiaPitch       = dialog:GetDoubleField("txtDiaPitch")
	g_PressureAngle  = dialog:GetDoubleField("txtPressureAngle")
	g_Bore           = dialog:GetDoubleField("txtBore")
	g_LineRes        = dialog:GetIntegerField("txtLineRes")

	g_XY_OriginIndex = dialog:GetRadioIndex("DrawingOrigin")
	g_OriginX        = dialog:GetDoubleField("OriginX")
	g_OriginY        = dialog:GetDoubleField("OriginY")


return true



end

function SaveOptionsToObject(object)
    object:SetInt("luaGM_GearMakerOptionsVersion", 1)
	object:SetInt("luaGM_txtNoTeeth", g_NoTeeth)
	object:SetDouble("luaGM_txtDiaPitch", g_DiaPitch)
	object:SetDouble("luaGM_txtPressureAngle", g_PressureAngle)
	object:SetDouble("luaGM_txtBore", g_Bore)
	object:SetInt("luaGM_txtLineRes", g_LineRes)

	object:SetInt("luaGM_DrawingOrigin", g_XY_OriginIndex)
	object:SetDouble("luaGM_OriginX", g_OriginX)
	object:SetDouble("luaGM_OriginY", g_OriginY)
	
    return true
end

function LoadOptionsFromObject(object)
    if object == nil then
	   return false
	end
	
	-- check this object had the settings we want ....
	if not object:ParameterExists("luaGM_GearMakerOptionsVersion", ParameterObject.UTP_INT) then
       return false
	end  
	
	g_NoTeeth	     = object:GetInt("luaGM_txtNoTeeth", g_NoTeeth, false)
	g_DiaPitch	     = object:GetDouble("luaGM_txtDiaPitch", g_DiaPitch, false)
	g_PressureAngle  = object:GetDouble("luaGM_txtPressureAngle", g_PressureAngle, false)
	g_Bore	         = object:GetDouble("luaGM_txtBore", g_Bore, false)
	g_LineRes	     = object:GetInt("luaGM_txtLineRes", g_LineRes, false)

	g_XY_OriginIndex = object:GetInt("luaGM_DrawingOrigin", g_XY_OriginIndex, false)
	g_OriginX	     = object:GetDouble("luaGM_OriginX", g_OriginX, false)
	g_OriginY	     = object:GetDouble("luaGM_OriginY", g_OriginY, false)
	
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

    return LoadOptionsFromObject(firstItem)
	
end


function OnLuaButton_CreateGear(dialog)

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
	SetCircles(job)
	job:Refresh2DView()
	
	
	return true
end

function main(script_path)

	local job = VectricJob()
	if not job.Exists then
		DisplayMessageBox("No Job Loaded")
		return false;
	end
	--------------------

	local registry = Registry("GearMaker")
	
	-- load default values fromm last time gadget was run
	g_NoTeeth = registry:GetInt("NoTeeth", g_NoTeeth)
	g_DiaPitch = registry:GetDouble("DiaPitch", g_DiaPitch) 
	g_PressureAngle = registry:GetDouble("PressureAngle", g_PressureAngle)
	g_Bore = registry:GetDouble("Bore", g_Bore)
	g_LineRes = registry:GetInt("LineRes", g_LineRes)
	
	g_XY_OriginIndex = registry:GetInt("xy_origin_index", g_XY_OriginIndex)
	g_OriginX = registry:GetDouble("OriginX", g_OriginX)
	g_OriginY = registry:GetDouble("OriginY", g_OriginY)
	
	-- if user is running gadget with a previously selected gear, pick settings up from that
	LoadOptionsFromSelection(job.Selection)

	local html_path = "file:" .. script_path .. "\\Gear_Maker\\Gear_Maker.htm"

	local frmMain = HTML_Dialog(true, g_DialogHtml, 490, 550, "Gear Maker")

	-- set default values fromm last time gadget was run
	frmMain:AddIntegerField("txtNoTeeth", g_NoTeeth)
	frmMain:AddDoubleField("txtDiaPitch", g_DiaPitch)
	frmMain:AddDoubleField("txtPressureAngle", g_PressureAngle)
	frmMain:AddDoubleField("txtBore", g_Bore)
	frmMain:AddIntegerField("txtLineRes", g_LineRes)

	frmMain:AddRadioGroup("DrawingOrigin", g_XY_OriginIndex)
	frmMain:AddDoubleField("OriginX", g_OriginX)
	frmMain:AddDoubleField("OriginY", g_OriginY)
	frmMain:AddLabelField("GadgetVersion", g_version)

    -- Display dialog, we create a gear every time the user presses the 'Create Gear' button
	frmMain:ShowDialog() 
	

    -- Save current values as defaults for next time
	registry:SetInt("NoTeeth", g_NoTeeth)
	registry:SetDouble("DiaPitch", g_DiaPitch)
	registry:SetDouble("PressureAngle", g_PressureAngle)
	registry:SetDouble("Bore", g_Bore)
	registry:SetInt("LineRes", g_LineRes)
	
	registry:SetDouble("OriginX", g_OriginX)
	registry:SetDouble("OriginY", g_OriginY)
	registry:SetInt("xy_origin_index", g_XY_OriginIndex)
	

	return true; 
end 

function SetCircles(job)
	local Radians 
	local Dpitch 
	local PAngle 
	
	local Pitch_Diameter 
	local Pitch_RadiUS 
	local Base_Circle_Dia 
	local Base_Circle_Rad 
	local Addendum 
	local Dedendum 
	local Outside_Diameter 
	local Outside_RadiUS 
	local Root_Diameter 
	local Root_RadiUS 
	local Base_Circle_Cir 
	local FCB 
	local NCB 
	local ACB 
	local Gear_T_Spacing 
	local MetriC =1

	Dpitch = g_DiaPitch
	PAngle = g_PressureAngle
	
	if job.InMM == true then
		MetriC =25.4
	end
	
	Pitch_Diameter = g_NoTeeth / Dpitch * MetriC
	Pitch_RadiUS = Pitch_Diameter / 2
	
	Radians = (PAngle * math.pi) / 180
	Base_Circle_Dia = Pitch_Diameter * math.cos(Radians) 
	Base_Circle_Rad = Base_Circle_Dia / 2
	
	Addendum = (1 * MetriC) / Dpitch
	
	Dedendum = (1.157 * MetriC) / Dpitch --This changed based on presure angle
	
	Outside_Diameter = Pitch_Diameter + 2 * Addendum 
	Outside_RadiUS = Outside_Diameter / 2 
	
	Root_Diameter = Pitch_Diameter - 2 * Dedendum 
	Root_RadiUS = Root_Diameter / 2 
	
	Base_Circle_Cir = Base_Circle_Dia * math.pi 

	FCB = Base_Circle_Rad / g_LineRes 
	NCB = Base_Circle_Cir / FCB
	ACB = 360 / NCB
	Gear_T_Spacing = 360 / g_NoTeeth 
	
    local origin_off = Point2D(0,0)
	if g_XY_OriginIndex == 1 then --"TLC 
		origin_off.x = g_OriginX + (Outside_Diameter / 2)
		origin_off.y = g_OriginY - (Outside_Diameter / 2)
   	elseif g_XY_OriginIndex == 2 then  --TRC 
		origin_off.x = g_OriginX  - Outside_Diameter + (Outside_Diameter/2)
		origin_off.y = g_OriginY - Outside_Diameter + (Outside_Diameter/2)
   	elseif g_XY_OriginIndex == 3 then --CENTRE 
		origin_off.x = g_OriginX --- (Outside_Diameter / 2)
		origin_off.y = g_OriginY --- (Outside_Diameter/ 2)
   	elseif g_XY_OriginIndex == 4 then --BLC  
		origin_off.x = g_OriginX + (Outside_Diameter / 2)
		origin_off.y = g_OriginY + (Outside_Diameter / 2)
   	elseif g_XY_OriginIndex == 5 then --BRC 
		origin_off.x = g_OriginX  - Outside_Diameter + (Outside_Diameter/2)
		origin_off.y = g_OriginY + (Outside_Diameter / 2)
  	end
	
	--DrawCircle(job,Root_Diameter/2,Point2D(origin_off.x,origin_off.y),"Root_Diameter")
	--DrawCircle(job,Base_Circle_Dia/2,Point2D(0,0),"Base_Circle_Dia")
	DrawCircle(job, Pitch_Diameter/2, Point2D(origin_off.x,origin_off.y), "Pitch_Diameter")
	--DrawCircle(job,Outside_Diameter/2,Point2D(0,0),"Outside_Diameter")
	DrawCircle(job, g_Bore/2, Point2D(origin_off.x,origin_off.y), "Gear")
	
	if g_ShowData then
	
		MessageBox ("Root_Diameter " .. Root_Diameter .. "\nBase_Circle_Dia " .. Base_Circle_Dia .. "\nPitch_Diameter " .. Pitch_Diameter .. 
				"\nOutside_Diameter " .. Outside_Diameter .. "\nAddendum " .. Addendum ..
				"\nDedendum " .. Dedendum .. "\nGear_T_Spacing " .. Gear_T_Spacing)

	end
---------------------------------------------------------------------------------------------------------------------------------

		local NewX --= 0
        local NewY -- = 0
        local Deg-- = 0
        local NewAcb-- = 0
        local i-- = 0

        local cenX--  = 0
        local cenY-- = 0
        local Xoff-- = 0
        local Yoff-- = 0

        local x1 = {} 
        local y1 = {}
        local z1 = {}
        local Spr = 0
        local desPoints-- = 0
		local desPoints2-- = 0
        local NoInsecPoints-- = 0
        local insecX1-- = 0 
        local insexY1-- = 0 
        local insecX2-- = 0 
        local insexY2-- = 0 
        local Mirrorangle-- = 0 

        Mirrorangle = 9999
        Spr = 1000
        NewAcb = ACB
		
		for i=0,Spr,1 do
            Deg = 180 / NewAcb
            NewAcb = ACB + NewAcb
            NewX, NewY = RotatePoint(Deg, Base_Circle_Rad)
            Xoff, Yoff = Perpendicular(0, 0, NewX, NewY, FCB * i, true, "OUT", cenX, cenY)
			x1[i + 1] = NewX - Xoff
            y1[i + 1] = NewY - Yoff
            z1[i] = 0
			--MessageBox ("Xoff " .. Xoff .. " Yoff " .. Yoff)
            desPoints = Distance2Points(0, 0, x1[i + 1], y1[i + 1])
			
            if desPoints > Outside_RadiUS then
                NoInsecPoints,insecX1, insexY1, insecX2, insexY2 = FindLineCircleIntersections(0, 0, Outside_RadiUS, x1[i], y1[i], x1[i + 1], y1[i + 1])
                x1[i + 1] = insecX1
                y1[i + 1] = insexY1
                break
            end
            desPoints = Distance2Points(0, 0, x1[i + 1], y1[i + 1])
            if desPoints > Pitch_RadiUS and Mirrorangle == 9999.0 then
                NoInsecPoints,insecX1, insexY1, insecX2, insexY2 = FindLineCircleIntersections(0, 0, Pitch_RadiUS, x1[i], y1[i], x1[i + 1], y1[i + 1])
                Mirrorangle = GetAngle2(insecX1, insexY1, 0, 0) - 90
				
            end
			
        end

		NoInsecPoints,insecX1, insexY1, insecX2, insexY2 = FindLineCircleIntersections(0, 0, Root_RadiUS, 0, 0, x1[1], y1[1])
		
		desPoints = Distance2Points(0, 0, insecX1, insexY1)
		desPoints2 = Distance2Points(0, 0, x1[1], y1[1])
        if desPoints > desPoints2 then
			NoInsecPoints,insecX1, insexY1, insecX2, insexY2 = FindLineCircleIntersections(0, 0, desPoints2  , 0, 0, x1[1], y1[1])
		end 
		x1[0] = insecX1
		y1[0] = insexY1		
	
		local MyContour = Draw_Line(job,x1, y1,origin_off)
		
		local MyMirrorContour =   MyContour:Clone()
		local ArcSpan  = Contour(0.0)
		local Tooth  = Contour(0.0) 
		local ctr_pos = MyContour:GetTailPosition()
		local span2
		span2, ctr_pos = MyContour:GetNext(ctr_pos)

		--Mirroring the tooth profile
        Deg = 180 / ((Gear_T_Spacing / 4) + Mirrorangle)
        NewX, NewY = RotatePoint(Deg, Pitch_RadiUS)
		local Angle = GetAngle2(NewX, NewY, 0, 0) - 90
		local Angle2 = GetAngle2(x1[0], y1[0], 0, 0) - 90
		Angle = (Angle - Angle2) * 2
		
		MyMirrorContour = Mirror (job, MyMirrorContour, Point2D(origin_off.x,origin_off.y),Angle)
		
		
		local ctr_pos = MyMirrorContour:GetTailPosition()
		local span
		span, ctr_pos = MyMirrorContour:GetNext(ctr_pos)
		
		
		ArcSpan = DrawArC(job, span.EndPoint2D, span2.EndPoint2D, Point2D(origin_off.x,origin_off.y), "Gear")
		local test
		test = MyMirrorContour:AppendContour(ArcSpan)
		test = MyContour:Reverse ()
		test = MyMirrorContour:AppendContour(MyContour)
		test = MyMirrorContour:Reverse ()
		if test == false then
			MessageBox (" Arc Span Is nil ")
		end
		local Rotation =  360/g_NoTeeth
		local Teeth = {}
		local TeethA = {}
		Teeth[1] =   MyMirrorContour
		--Refresh (job,Teeth[1],"Tooth")

		for i=2,g_NoTeeth do
			Teeth[i] =   MyMirrorContour:Clone()
			Rotate (job, Teeth[i], Point2D(origin_off.x,origin_off.y), Rotation)
			Rotation = (360/g_NoTeeth) * i
			--Refresh (job,Teeth[i],"Tooth")
		end
		for i=0, #Teeth-2 do
			TeethA[i] = DrawArC(job, Point2D(Teeth[i+2].StartPoint2D.x, Teeth[i+2].StartPoint2D.y), Point2D(Teeth[i+1].EndPoint2D.x,Teeth[i+1].EndPoint2D.y), Point2D(origin_off.x,origin_off.y), "Tooth")
			test = TeethA[i]:Reverse ()
			--Refresh (job,TeethA[i],"Tooth")
		end
		TeethA[#TeethA+1] = DrawArC(job, Point2D(Teeth[1].StartPoint2D.x, Teeth[1].StartPoint2D.y), Point2D(Teeth[#Teeth].EndPoint2D.x,Teeth[#Teeth].EndPoint2D.y),Point2D(origin_off.x,origin_off.y), "Tooth")
		test = TeethA[#TeethA]:Reverse ()
		--Refresh (job,TeethA[table.getn(TeethA)],"Tooth")
		
		for i=1,#Teeth do
			test = Teeth[i]:AppendContour(TeethA[i-1])
			--Refresh (job,Teeth[i],"Tooth")
		end
		local FinishedGear = Contour(0.0)
		for i=1,#Teeth do
			test = FinishedGear:AppendContour(Teeth[i])
			
		end		
		Refresh (job,FinishedGear,"Gear")
		--Refresh (job,MyMirrorContour,"Tooth")
		--DrawArC(job                       ,STPoint            ,EPPoint        ,PTCenter    ,LayerName)
		--job:Refresh2DView()
------------------------------------------------------------------------------------------------------------------------------------
	return true
end

function Rotate (job, MyContour, CenterM, Angle)
	local rotate_90_xform = RotationMatrix2D(CenterM, Angle)
    MyContour:Transform(rotate_90_xform)
	return MyContour; 
end

function Mirror (job, MyContour, CenterM, Angle)

  	local mirror_X_xform = ScalingMatrix2D (CenterM, Vector2D(1.0, -1.0))
	MyContour:Transform(mirror_X_xform)
	
	local rotate_90_xform = RotationMatrix2D(CenterM, Angle)
    MyContour:Transform(rotate_90_xform)

	
	--local cad_object = CreateCadContour(MyContour)
	--local cur_layer = job.LayerManager:GetActiveLayer()
	--local layer = job.LayerManager:GetLayerWithName("Tooth")-- and add our object to it - on active sheet
	--layer:AddObject(cad_object, true)
	--layer.Colour = 0 
	--layer.Visible = true 
	--job.LayerManager:SetActiveLayer(cur_layer)
	
	
	--job:Refresh2DView()
	
	
	return MyContour; 
end

function Draw_Line(job,X,Y,Origin)

	local MyContour = Contour(0.0)

	local p1 = Point2D(X[0] + Origin.x,Y[0] + Origin.y)
	local Angle

   
   	MyContour:AppendPoint(p1)
	for i=1, #X do
		local p2 = Point2D(X[i] + Origin.x,Y[i] + Origin.y)
		MyContour:LineTo(p2)
	end
	
	Angle = GetAngle2(X[0]+ Origin.x, Y[0] + Origin.y, Origin.x, Origin.y) - 90
   	local rotate_90_xform = RotationMatrix2D(Origin,-1 * Angle)
    MyContour:Transform(rotate_90_xform)
	--MessageBox("Angle " .. Angle)
	
	--local cad_object = CreateCadContour(MyContour)
	--local cur_layer = job.LayerManager:GetActiveLayer()
	--local layer = job.LayerManager:GetLayerWithName("Tooth")-- and add our object to it - on active sheet
	--layer:AddObject(cad_object, true)
	--layer.Colour = 0 
	--layer.Visible = true 
	--job.LayerManager:SetActiveLayer(cur_layer)
	
	--job:Refresh2DView()
	
	return MyContour; 
end

function DrawCircle(job,RadiUS,PTCenter,LayerName)
	local MyContour = Contour(0.0)
	--local p1 = Point2D(RadiUS + PTCenter.x,0)
	--local p2 = Point2D((-1*RadiUS) + PTCenter.x,0)
	
	local p1 = Point2D(RadiUS + PTCenter.x, PTCenter.y)
	local p2 = Point2D(PTCenter.x, (-1*RadiUS) + PTCenter.y)
	local p3 = Point2D((-1*RadiUS) + PTCenter.x, PTCenter.y)
	local p4 = Point2D(PTCenter.x, RadiUS + PTCenter.y)

	
	--MessageBox("Radius = " .. RadiUS .. " Center Point =  " .. PTCenter.x .. "," .. PTCenter.y) 
	MyContour:AppendPoint(p1)
	MyContour:ArcTo(p2,PTCenter, false)
	MyContour:ArcTo(p3,PTCenter, false)
	MyContour:ArcTo(p4,PTCenter, false)
	MyContour:ArcTo(p1,PTCenter, false)
	
	--------------------------------------------------------
	local cad_object = CreateCadContour(MyContour)
	SaveOptionsToObject(cad_object)
	local cur_layer = job.LayerManager:GetActiveLayer()
	local layer = job.LayerManager:GetLayerWithName(LayerName)-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 0 
	layer.Visible = true 
	job.LayerManager:SetActiveLayer(cur_layer)
	job:Refresh2DView()	
	
	return true
end

function DrawArC(job,STPoint,EPPoint,PTCenter,LayerName)
	local MyContour = Contour(0.0)
	--local p1 = Point2D(STPoint.x,STPoint.y)
	--local p2 = Point2D(EPPoint.x,STPoint.y)
	--local PTCenter = Point2D(0,0)
	MyContour:AppendPoint(STPoint)
	MyContour:ArcTo(EPPoint,PTCenter, false)
	--------------------------------------------------------
	--local cad_object = CreateCadContour(MyContour)
	--local cur_layer = job.LayerManager:GetActiveLayer()
	--local layer = job.LayerManager:GetLayerWithName(LayerName)-- and add our object to it - on active sheet
	--layer:AddObject(cad_object, true)
	--layer.Colour = 0 
	--layer.Visible = true 
	--job.LayerManager:SetActiveLayer(cur_layer)
	--job:Refresh2DView()	
	
	return MyContour
end

-------------------------------------------------------------
function RotatePoint(Deg, Rad)
	local theta
	local dtheta 
	local cx 
	local cy 
	
	cx = Rad
	cy = 0
	theta = 0
	dtheta = math.pi / Deg 
	theta = theta + dtheta
	local New_X = math.cos(theta) * cx - math.sin(theta) * cy
	local New_Y = math.sin(theta) * cx + math.cos(theta) * cy
	
	local cenX 
	local cenY 
	local Xoff 
	local Yoff 
	
	Xoff, Yoff = Perpendicular(0, 0, New_X, New_Y, 2, true, "OUT", cenX, cenY)
	--Console.WriteLine(Xoff & "," & Yoff)
	return  New_X,New_Y
end 
	
	
function Perpendicular( X1  ,  Y1  ,  X2  ,  Y2  ,  BitRad  ,  DirC  ,  Profile  ,  CenX  ,  CenY  )
	local RUN
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
	
	
	angle = (GetAngle(points1, points2) - 180) * (math.pi / 180)
	RUN = math.cos(angle) * BitRad
	Raise = math.sin(angle) * BitRad
	
	
	
	--top right of circle
	if RUN < 0 and Raise > 0 then
		if Quad == "BL" then
			RUN = math.abs(RUN)
		else
			Raise = -1 * Raise
		end 
	--Top Left of circle
	elseif RUN > 0 and Raise > 0 then
		if Quad == "BR" then
			RUN = -1 * RUN
		else
			Raise = -1 * Raise
		end 
	--Bttom Left of circle
	elseif RUN > 0 and Raise < 0 then
		if Quad == "TR" then
			RUN = -1 * RUN
		else
			--Raise = Abs(Raise)
			--RUN = -1 * RUN 'I added the run = for DC Cabinets may not be right
		end 
	--Bttom right of circle
	elseif RUN < 0 and Raise < 0 then
		if Quad == "TL" then
			RUN = math.abs(RUN)
		else
			Raise = math.abs(Raise)
			--MessageBox ("Raise " .. Raise )
		end 

	elseif Raise == 0 and RUN > 0 and Profile == "InSide" and DirC == true then
		RUN = -1 * RUN
	elseif Raise == 0 and RUN < 0 and Profile == "InSide" and DirC == true then
		RUN = math.abs(RUN)
	elseif RUN == 0 and Raise > 0 and Profile == "InSide" and DirC == false then
		Raise = -1 * Raise
	elseif RUN == 0 and Raise < 0 and Profile == "InSide" and DirC == false then
		Raise = math.abs(Raise)
	elseif RUN < 0 and Raise == 0 and Profile == "OUT" and DirC == true then
		RUN = math.abs(RUN)
	elseif RUN > 0 and Raise == 0 and Profile == "OUT" and DirC == true then
		RUN = -1 * RUN
	elseif RUN == 0 and Raise < 0 and Profile == "OUT" and DirC == false then
		Raise = math.abs(Raise)
	elseif RUN == 0 and Raise > 0 and Profile == "OUT" and DirC == false then
		Raise = -1 * Raise
	--ElseIf RUN > 0 And Raise > 0 And Profile = "OUT" And DirC = True Then 'I added hoping it would help May screw somthing else up
	--    Raise = -1 * Raise
	--    RUN = -1 * RUN
	end 
	
	local Xoff = RUN
	local Yoff = Raise
	--MessageBox ("Run " .. RUN .. " Raise " .. Raise)
	return Xoff,Yoff
end

function GetAngle2( X1  ,  Y1  ,  X2  ,  Y2  )  
   local a 
   a = MyTan(X2 - X1, Y1 - Y2)
   return a * (180 / math.pi) - 90
end
	
	
function GetAngle(points1 , points2)  
	local a  
	a = MyTan(points2[0] - points1[0], points2[1] - points1[1])
	return a * (180 / math.pi) - 90
end 

function MyTan(d1,d2)  
	
	if  d2 < 0 then
		return (math.pi / 2) + math.atan(d1 / d2)
	elseif d2 > 0 then
		return (math.pi * 1.5) + math.atan(d1 / d2)
	elseif d2 == 0 then
		if d1 < 0 then
			return math.pi
		else
			return math.pi * 2
		end
	end
	return false
end 	
	
function Distance2Points(X1 , Y1 , X2 ,  Y2 )
    return math.sqrt(((X1 - X2) * (X1 - X2)) + ((Y1 - Y2) * (Y1 - Y2)))
end 
	
function FindLineCircleIntersections( cx   ,  cy  ,  radiUS  ,  x1  ,  y1  ,  x2  ,  y2)  
--ix1,iy1,ix2,iy2    
   local dx
   local dy  
   local A   
   local B  
   local C  
   local det  
   local t 
   local ix1
   local iy1
   local ix2
   local iy2


   dx = x2 - x1
   dy = y2 - y1

   A = dx * dx + dy * dy
   B = 2 * (dx * (x1 - cx) + dy * (y1 - cy))
   C = (x1 - cx) * (x1 - cx) + (y1 - cy) * (y1 - cy) - radiUS * radiUS

   det = B * B - 4 * A * C
   if (A <= 0.0000001) or (det < 0) then
       -- No real solutions.
       return 0,ix1,iy1,ix2,iy2
   elseif det == 0 then
       -- One solution.
       t = -B / (2 * A)
       ix1 = x1 + t * dx
       iy1 = y1 + t * dy
       return 1,ix1,iy1,ix2,iy2
   else
       -- Two solutions.
       t = (-B + math.sqrt(det)) / (2 * A)
       ix1 = x1 + t * dx
       iy1 = y1 + t * dy
       t = (-B - math.sqrt(det)) / (2 * A)
       ix2 = x1 + t * dx
       iy2 = y1 + t * dy
       return 2,ix1,iy1,ix2,iy2
   end 
end 	
	
	
function Refresh (job,Contour,LayerName)

	local cad_object = CreateCadContour(Contour)
	SaveOptionsToObject(cad_object)
	local cur_layer = job.LayerManager:GetActiveLayer()
	local layer = job.LayerManager:GetLayerWithName(LayerName)-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 0 
	layer.Visible = true 
	job.LayerManager:SetActiveLayer(cur_layer)
	
	job:Refresh2DView()
end

-- =========== HTML for Dialog ============================================
g_DialogHtml = [[
	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta content="en-us" http-equiv="Content-Language" />
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<title>Size material</title>
<style type="text/css">
html {
	overflow: auto;
}
body {
	background-color: #F0F0F0;
}
body, td, th {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.FormButton {
	font-weight: bold;
	width: 100%;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.LuaButton {
	font-weight: bold;
	width: 100%;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.h1 {
	font-size: 14px;
	font-weight: bold;
}
.h2 {
	font-size: 12px;
	font-weight: bold;
}
.Title {
	font-size: 24px;
	font-weight: bold;
}
.ToolNameLabel {
	color: #555;
}
</style>
</head>

<body bgcolor="#CCCCFF" class="newStyle1" style="height: 177px">

<p style="height: 160px" class="Title">
<label id="Label1" visible="true">Gear Maker</label>&nbsp;

<img align="center" alt="" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAALkAAACnCAMAAAB6rw2FAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAwBQTFRF5Ihcu2xhajcqzpmO03pp5dza4MO9i0k5vGpcj3Nt2n1d3INq3INcllJDdVVO8+rpznhkxXBcvXFk6oxjznVhpVlJ18vI1nlhq4N46+blynFhVjAp/fz82X1hUSQa7JJqynFdzHRo0XVhzXVl3oFhtWli6o1p4YVp0nlhx7q23oJk65Ny2IdzcEI4xnBg1KOY0nhlznpp2X1pznRd2X1lynRh0XVdORML9fLy1nxh1XlkxHJq5rmrxW1hyXFlxm1d1nldwG1g4YZlzXJdyW1b0nld5srD8pVruaqnxod4+Pb1ynRl2oFhQxsRwm1d2oFlqGFX1nxmwnBh5opl1n1d1oFk0nVl3oVlhWJb3oVhq5qXtWlcxXFk5o1y3tbU7JFj2Xlg4YZf2LSr7OHeznBZ3n1hynFZzXJW27u1znhdwnFk3YpiwWlcwmtUtaKd5olhx6ihznFgt2ZL5opp3n1l8ply1oJr462d3ohqsmZh4X5k0nVZ5tPOxW1ZxnRm4YllynRd1KyjwmxZvWZa1HZgsmRc1nVd5ZFs4olo0nVV2ZJ75o5p0XZpqHNnym5h2Xpl1nhZvZWLunxzp5GL8dzWznVZqImCuZuUym1V03tW4YJmrmFKxW1k0nhZ44lhxLKu9/DvzXJlwG1lrmVgu2VU4IJf5oZl4puHvWlWxn1wx3Rg5YZh0nxhuoyA5o1ls2BRxnhr1Hxv4opt0nxnvG1n0HJZonxzwWlZ3Ylc0HJc545t1n1ZxnFTm4aAwWph2oVm4o1t79bQYCwf1IJc1XZl4o5oz8PA2tDOw21n5optwXVn2oRg541fyXRZvnBc+/j49aB3umZgyoJw0n1e1nRZ6ohgxWphtmpU5YNm8I1m4Y1m0HJi2Xdc3Xpf2n1Uwmpk8szAxGZb34NWz3pUtmpm2HZixmpXxGpey49/4IxgxHpbfz8wyW5p0HJlvmxNxndnwnRg0m9V03taxGpm6ZBl5INg23pl6Idp8JltwGdQx3BMwWZi24FMoG5h1HJX////R1X+egAAAQB0Uk5T////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////AFP3ByUAADlxSURBVHja7J0NWBNnuvdNGktIACdh6NTBCUlmgGmUab4mOKH5hlrNlwmBSEkrVKENUi0FWZQaKEalNTX2w61FtIXW1saUCsFatAUWqVpQ3Na11Vp39+3S2i7twnHtuu+es4f3Ae1+nLNn33YPdneva+fqdTmmKdePe+77f//v53mSzpr8Z71m/Yv8X+T/Iv8X+Z9dSx74/NaF1+/n/VOQr7j+571DvZeOXb9/YM6Kf3TyeU8u2H7ftdvX6DbO4mu3d3rMv7vlH5z8+OtqIuGRqbs5WTTdpnxg+tXF/TbZTf/Y5POWJTr3XqmdC24fYdM46rx96tW5E81niMev5/odd8z5RyJfcccr04E+nRpX1tDQ/CS4vXtAjOZij0+9+sMG72UCuZbpN7mYgjn/OORzhfyCgz+ainnqmDd/1fCrpycnbxVxUUvpFPkL7DeHsZZTs6feeZ+4gFf2D0T+dFxBXrnyTkCexd5RWoQ13rnkhVvZh6pc5k/u+Pkdt469yVO3TEf/heIYgxH/OOSAt4/5SjkCohpvHysdZiyKWsxvwauca04uL4KjR99k1C2KZ4C4P2uN5m0v+0ciF70lrQpZgXw8NPbwm7w8WMswEZySZiYvv+Lcxk+wVdVgQVp4052JsaiHUFwjn/P4Kz+a93cjv/Om6cJ8W8QWV+Fo72uPk6WfFOWVy0nGBeEoScw6maaUOhNc28owV22ENeSOengtn18D7yK+Jlb/nciX3KQQb3gUxO14anacso3aFhrUEHuG/WJA7qdRi9M862SHihxOkOeux1yxfawRKOo5Uj2t7Cv6jbyyj2f/nciPxbmaaOXieycnl2UPhGjdtpBq+95mpwWVaxkxdUklu3JyltdiS0iQ9hAaJeQWUtAZHo/QPP4MaE5EfVnZ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" />
</p>

<hr />
<table border="0" style="width: 100%">
	<tr>
		<td class="auto-style9" style="width: 295px">Anchor Point</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td style="width: 295px">
                  <table width="150" border="0" cellpadding="0" cellspacing="0" align="center">
                     <tr>
                        <td><div align="center">
							<input type="radio" name="DrawingOrigin" checked="checked" value="V1"></div></td>
                        <td  width="75px"><div align="center" ><hr size="1" width="100%" /></div></td>
                        <td valign="top"><div align="center">
							<input type="radio" name="DrawingOrigin" checked="checked" value="V1"></div></td>
                     </tr>
                     <tr>
                        <td class="auto-style9"><div align="center">|</div></td>
                        <td><div align="center">
							<input type="radio" name="DrawingOrigin" checked="checked" value="V1"></div></td>
                        <td valign="top"><div align="center">|</div></td>
                     </tr>
                     <tr>
                        <td><div align="center">
							<input type="radio" name="DrawingOrigin" checked="checked" value="V1"></div></td>
                        <td><div align="center"><hr size="1" width="100%" /></div></td>
                        <td valign="top"><div align="center">
							<input type="radio" name="DrawingOrigin" value="V1"></div></td>
                     </tr>
                  </table>
                </td>
		<td class="auto-style8">
                  <table style="width: 100%">
					  <tr>
						  <td class="auto-style5" style="width: 10px">X</td>
						  <td>
                  <input name="OriginX0" type="text" id="OriginX" size="8" maxlength="8" style="width: 72px; height: 16px;"></td>
					  </tr>
					  <tr>
						  <td class="auto-style5">Y</td>
						  <td>
                  <input name="OriginY0" type="text" id="OriginY" size="8" maxlength="8" style="width: 73px; height: 16px;"></td>
					  </tr>
				  </table>
               </td>
	</tr>
</table>
<hr />
<br />
<table style="width: 100%">
	<tr>
		<td style="width: 114px; height: 52px">Number of Teeth</td>
		<td style="width: 70px; height: 52px">
                  <input name="Lenght0" type="text" id="txtNoTeeth" size="8" maxlength="8" style="width: 62px"></td>
		<td style="width: 55px; height: 52px">Diametral Pitch</td>
		<td style="width: 79px; height: 52px">
                  <input name="Height0" type="text" id="txtDiaPitch" size="8" maxlength="8" style="width: 62px"></td>
		<td style="width: 64px; height: 52px">Pressure Angle</td>
		<td style="height: 52px">
                  <input name="Lenght1" type="text" id="txtPressureAngle" size="8" maxlength="8" style="width: 62px"></td>
	</tr>
	<tr>
		<td style="width: 114px">Bore Diameter</td>
		<td style="width: 70px">
                  <input name="Lenght3" type="text" id="txtBore" size="8" maxlength="8" style="width: 62px"></td>
		<td style="width: 55px">&nbsp;</td>
		<td style="width: 79px">&nbsp;</td>
		<td style="width: 64px">Line Resolution</td>
		<td>
                  <input name="Lenght2" type="text" id="txtLineRes" size="8" maxlength="8" style="width: 62px"></td>
	</tr>
	</table>
<table style="width: 100%; height: 62px;">
    <tr>
		<td colspan="5"><hr></td>
	</tr>
	<tr>
	    <td style="width: 20%"></td>
		<td style="width: 20%">
			<input width="100%" id="CreateGear" class="LuaButton" name="CreateGear" type="button" value="Create Gear">
		</td>
		<td style="width: 20%"></td>
		<td style="width: 20%">
			<input width="100%" id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Close">
		</td>	
		<td style="width: 20%"></td>
	</tr>
	<tr><td><br></td></tr>
	<tr>
		<td colspan="3"><a href="http://www.cabinetpartspro.com">www.cabinetpartspro.com</a> </td>
		<td colspan="2" align = "right" style="color: #999999" >Version <span align="right" id=GadgetVersion value ="GadgetVersion"></span></td>

	</tr>
</table>

</body>

</html>

	
]]
	
	
	
	