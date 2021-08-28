-- VECTRIC LUA SCRIPT
require "Strict"
--[[ ****************************************************************
* This gadget will generate vectors to build the front/back and		*
* the ends for a box with box joints. It can be used by either		*
* Vcarve Pro or Aspire.												*
*																	*
* This is my first attempt at writing a gadget and I've never used  *
* the Lua language before (hell, I've never heard of it before),    *
* and I have had a bit of trouble understanding the Vectric Lua		*
* Interface document, so please excuse me if you find this code		*
* difficult to follow. Regardless, I think the end result is worth	*
* looking at.														*
*																	*
*	Written by Art Steburg, March 2020								*
*		Questions or comments: astebur@gmail.com					*
****************************************************************** ]] 

local job = VectricJob()
local MyMaterial = MaterialBlock()
	 
function main(script_path)
	
	--> We'll start of with some default values, first the imperial values
		local BoxWidth = 10		--> Overall width of box
		local BoxDepth = 5		--> Depth of box
		local BoxHeight = 4.5	--> Height of box
		
		local PinCount = 5		--> Number of pins for front/back
		local BottomStyle = 1	--> How to draw bottom of box
		local LegSize = .75		--> Default Leg Height
		local BottomPointCount = 4		--> Default number of drapes for bottom option 4
		local ToolDiameter = .125
		local BoxAllowance = .01
		local Border = .25
		local RailHeight = .25	--> default for height of bottom rails
		local RailPosition = .125
		local LidStyle = 2
		
	--> But if the job is in metric units we need to set different defaults
	if MyMaterial.InMM then							--> I guess I gotta try metric
		BoxWidth = 250		--> Overall width of box
		BoxDepth = 125		--> Depth of box
		BoxHeight = 115	--> Height of box
		LegSize = 19
		ToolDiameter = 3
		BoxAllowance = .255
		Border = 6
		RailHeight = 6
		RailPosition = 3
	end
	
	local xyorigin = MyMaterial.XYOrigin
	if xyorigin == MaterialBlock.BLC then
	else
		job:SetXY_Origin(0,0,0)
	end

	local WidthofPin = MyMaterial.Thickness + BoxAllowance  	--> Pins slightly longer that thickness
											
	local html_path = "file:" .. script_path .. "\\Box_Joints.htm"
	local myHTML = HTML_Dialog(false, html_path, 750, 800, "Box Joints")
	
	local LayerName = "Box Joints"
	
	local myGadget = "Box Joints by the Old Geezer"
	local myRegistry = Registry(myGadget)
	if myRegistry:DoubleExists("BoxHeight") then		--> Oh, we have to reset defaults to user's values
		BoxHeight = myRegistry:GetDouble("BoxHeight",BoxHeight)
		BoxWidth = myRegistry:GetDouble("BoxWidth",BoxWidth)
		BoxDepth = myRegistry:GetDouble("BoxDepth",BoxDepth)
		PinCount = myRegistry:GetDouble("PinCount",PinCount)
		ToolDiameter = myRegistry:GetDouble("ToolDiameter",ToolDiameter)
		BoxAllowance = myRegistry:GetDouble("BoxAllowance",BoxAllowance)
		Border = myRegistry:GetDouble("Border",Border)
		BottomStyle = myRegistry:GetInt("BottomStyle",BottomStyle)
		LidStyle = myRegistry:GetInt("LidStyle",LidStyle)
		LegSize = myRegistry:GetDouble("LegSize",LegSize)
		RailHeight = myRegistry:GetDouble("RailHeight",RailHeight)
		BottomPointCount = myRegistry:GetInt("BottomPointCount",BottomPointCount)
		LayerName = myRegistry:GetString("LayerName",LayerName)
	end

	myHTML:AddDoubleField("BoxHeight", BoxHeight)
	myHTML:AddDoubleField("BoxWidth", BoxWidth)
	myHTML:AddDoubleField("BoxDepth", BoxDepth)
	myHTML:AddIntegerField("PinCount", PinCount)
	myHTML:AddDoubleField("ToolDiameter", ToolDiameter)
	myHTML:AddDoubleField("BoxAllowance", BoxAllowance)
	myHTML:AddDoubleField("Border", Border)	
	myHTML:AddRadioGroup("BottomStyle",BottomStyle)
	myHTML:AddRadioGroup("LidStyle",LidStyle)
	myHTML:AddDoubleField("LegSize", LegSize)
	myHTML:AddDoubleField("RailHeight", RailHeight)
	myHTML:AddIntegerField("BottomPointCount", BottomPointCount)
	myHTML:AddTextField("LayerName", LayerName)	
	myHTML:AddLabelField("Script_Path", script_path)		--> Just used to pass information

	local success = myHTML:ShowDialog()

-->    if not success then:
-->		MessageBox("not success")
-->		return false;
-->    end
	local z = process(myHTML)
	
	job:Refresh2DView()
	LayerName = myHTML:GetTextField("LayerName")
	LayerName = LayerName .. " FB"

	return true
end
	
function process(myHTML)

--> This routine pulls the box dimensions from the HTML display, then calculates
--> a couple other variables. Finally it calls the BuildSide routine to 
--> build the box.

	local BoxHeight = myHTML:GetDoubleField ("BoxHeight")
	local BoxWidth = myHTML:GetDoubleField("BoxWidth")
	local BoxDepth = myHTML:GetDoubleField("BoxDepth")
	local PinCount = myHTML:GetIntegerField("PinCount")
	local ToolDiameter = myHTML:GetDoubleField("ToolDiameter")
	local RailHeight = myHTML:GetDoubleField("RailHeight")
	local BoxAllowance = myHTML:GetDoubleField("BoxAllowance")
	local Border = myHTML:GetDoubleField("Border")	
	local LegSize = myHTML:GetDoubleField("LegSize")	
	local BottomStyle = myHTML:GetRadioIndex("BottomStyle")
	local LidStyle = myHTML:GetRadioIndex("LidStyle")
	local BottomPointCount = myHTML:GetIntegerField("BottomPointCount")
	local LayerName = myHTML:GetTextField("LayerName")
	
	local myGadget = "Box Joints by the Old Geezer"
	local myRegistry = Registry(myGadget)
	myRegistry:SetDouble("BoxHeight", BoxHeight)
	myRegistry:SetDouble("BoxWidth", BoxWidth)
	myRegistry:SetDouble("BoxDepth", BoxDepth)
	myRegistry:SetDouble("PinCount", PinCount)
	myRegistry:SetDouble("ToolDiameter", ToolDiameter)
	myRegistry:SetDouble("BoxAllowance", BoxAllowance)
	myRegistry:SetDouble("Border", Border)	
	myRegistry:SetInt("BottomStyle",BottomStyle)
	myRegistry:SetInt("LidStyle",LidStyle)
	myRegistry:SetDouble("LegSize", LegSize)
	myRegistry:SetDouble("RailHeight", RailHeight)
	myRegistry:SetInt("BottomPointCount", BottomPointCount)
	myRegistry:SetString("LayerName", LayerName)	
	

	local beginX = Border		--> Location of left side of box
	local beginY 				--> Location of top of the box
	local BottomY = Border
		
	local WidthofPin 		--> Length of pins, will be material thickness + BoxAllowance
	local HeightofPin = BoxHeight / (PinCount+PinCount-1)
	
	local FrontBack = true
	
	local z

	WidthofPin = MyMaterial.Thickness + BoxAllowance  	--> Pins slightly longer that thickness
	beginY = BottomY + BoxHeight 
	if BottomStyle == 1 then
	else
		beginY = beginY + LegSize
	end
	
--> Build the front/back of the box
	z = BuildSide(myHTML, BoxWidth, BoxHeight, LegSize, FrontBack, beginX, beginY, WidthofPin, HeightofPin)

--> Now set up and build the sides of the box
	BoxWidth = BoxDepth			--> Set size of second side
	FrontBack = false
	
	z = BuildSide(myHTML, BoxWidth, BoxHeight, LegSize, FrontBack, beginX, beginY, WidthofPin, HeightofPin)
	return true
end

function BuildSide (myHTML, BoxWidth, BoxHeight, LegSize, FrontBack, beginX, beginY, WidthofPin, HeightofPin)

--> This routine will calculate the points and arcs needed to draw the box. It will
--> call on various other subroutines to perform the calls to Vectric to actually
--> draw the lines.

	local MyContour = Contour(0.0)
	
	local EarHeight = .25			--> default size for the ears
	if MyMaterial.InMM then
		EarHeight = 6
	end
		
	local LayerName = myHTML:GetTextField("LayerName")
	local BottomStyle = myHTML:GetRadioIndex("BottomStyle")
	local LidStyle = myHTML:GetRadioIndex("LidStyle")
	local BottomPointCount = myHTML:GetIntegerField("BottomPointCount")
	local PinCount = myHTML:GetIntegerField("PinCount")
	local ToolDiameter = myHTML:GetDoubleField("ToolDiameter")
	local RailHeight = myHTML:GetDoubleField("RailHeight")
	local BoxAllowance = myHTML:GetDoubleField("BoxAllowance")
	local Border = myHTML:GetDoubleField("Border")	
	
	local ToolRadius = ToolDiameter/2 	
	
	local linePTs = {}
	
	local startX 		
	local startY
	local midX
	local endX
	
    local MyLine
	local SaveLayerName
	
	local BoxCenterSpan = BoxWidth - (WidthofPin*2)
	local PinHeight = HeightofPin
	local PinWidth = WidthofPin	
	
	local TopLeftX
	local TopLeftY
	local TopRightX
	local TopRightY
	local BottomLeftX
	local BottomLeftY
	local BottomRightX
	local BottomRightY
	local BoxDepth
	
	local CenterPoint
	local EndofArc
	local secant 
	local ChordLenSq
	local ChordHeight
	local ChordHeightx4 
	local ChordRadius 
	local StartofArc 
	local MidPoint
	local Direction
	local PinsComplete	
	local zWork						--> Work field
	local yWork						--> Work field
	
	if not job.Exists then
		DisplayMessageBox("No job loaded")
		return false;
	end
	

	
--> Available variables from calling routine:
--> myHTML, BoxWidth, BoxHeight, LegSize, FrontBack, beginX, beginY, WidthofPin, HeightofPin
--> 
--> And variables obtained from HTML calls:
--> BottomStyle, BottomPointCount, ToolRadius(generated from ToolDiameter), PinCount
 
	PinWidth = WidthofPin - (ToolDiameter)		--> Note: ToolRadius=0 means no filets
	zWork = (PinCount*2)-1
	HeightofPin = BoxHeight/zWork					

	startX = beginX + WidthofPin	--> Start point for left pins
	startY = beginY

	PinHeight = HeightofPin	--> For first pin each side		
	PinsComplete = 0
	if FrontBack then			--> front/back pins
		SaveLayerName = LayerName .. " FB"
		TopLeftX = startX
		TopLeftY = startY
		MyContour:AppendPoint(startX,startY)
		startX = startX - WidthofPin
		MyContour:LineTo(startX,startY)
		startX = beginX
		while PinsComplete < PinCount do
			--> doing left side pins
			startY = startY - PinHeight
			MyContour:LineTo(startX,startY)
			PinsComplete = PinsComplete + 1		--> Yup, already completed a pin
			if PinsComplete == PinCount then
				BottomLeftX = startX
				BottomLeftY = startY					
			break
			end

			PinHeight = HeightofPin + BoxAllowance	--> Do this every time, gap needs it
			startX = startX + PinWidth
			MyContour:LineTo(startX,startY)
			if ToolRadius == 0 then
			else
				endX = startX + (ToolDiameter)
				midX = startX + ToolRadius
				-->MyLine = BuildArc(job,startX,startY,endX,startY,midX,startY,false)
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX + (ToolDiameter)
			end

			--> Pin started, now finish pin and start gap
			if ToolRadius == 0 then		--> No filets wanted
				startY = startY - PinHeight
				MyContour:LineTo(startX,startY)
				PinHeight = HeightofPin - BoxAllowance	--> Do this every time, pin needs it

				startX = startX - PinWidth
				MyContour:LineTo(startX,startY)
				
			else						--> Gotta draw it with filets
				startY = startY - PinHeight
				MyContour:LineTo(startX,startY)
				PinHeight = HeightofPin - BoxAllowance	--> Do this every time, pin needs it
				endX = startX - (ToolDiameter)
				midX = startX - ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX - (ToolDiameter)
				startX = startX - PinWidth
				MyContour:LineTo(startX,startY)
			end	
		end							--> ends while PinsComplete < PinCount
				
		--> Done with left side pins, now do bottom

		if BottomStyle == 1 then		--> Option 1 is a straight line
			startX = startX + BoxWidth
			MyContour:LineTo(startX,startY)
		end
		if BottomStyle == 2 then 	--> Option 2 is square legs
			local LegWidth = LegSize * 1.5
			startY = startY - LegSize
			MyContour:LineTo(startX,startY)		--> Line down
			startX = startX + LegWidth
			MyContour:LineTo(startX,startY)		--> Bottom of leg
			startY = startY + LegSize
			MyContour:LineTo(startX,startY)		--> Line up
			startX = startX+BoxWidth-(LegWidth*2)
			MyContour:LineTo(startX,startY)		--> Line to right side
			startY = startY - LegSize
			MyContour:LineTo(startX,startY)		--> Line down
			startX = startX + LegWidth
			MyContour:LineTo(startX,startY)		--> Bottom of leg
			startY = startY + LegSize
			MyContour:LineTo(startX,startY)		--> Line up
		end

		if BottomStyle == 3 then 	--> Option 3 is an arc between legs
			local LegWidth = LegSize * 1.5
			MyContour:AppendPoint(startX,startY)
			startY = startY - LegSize
			MyContour:LineTo(startX,startY)		--> Line down
			startX = startX + LegWidth
			MyContour:LineTo(startX,startY)		--> Bottom of leg

		--[[ I learned from a google search that you could determine the radius
		of an arc if you know the secant and chord height. Calling the secant 's' 
		and the chord height 'h' the formula is:
			radius = (((s^2)/(h*4))+h)/2
		I know the secant (s) is the distance between the legs and the height (h) 
		is the leg height, so I should be able to determin the radius of the arcwe want.
		]]
		
			secant = BoxWidth-(LegWidth*2)
			ChordLenSq = secant*secant	--> square the secant
			ChordHeightx4 = LegSize*4		--? Height * 4
			ChordRadius = ((ChordLenSq/ChordHeightx4)+LegSize)/2
			StartofArc = Point2D(startX,startY)
			MidPoint = startX+(secant/2)
			CenterPoint = Point2D(MidPoint,(startY+LegSize)-ChordRadius)
			EndofArc=Point2D(startX+secant, startY)
			MyContour:ArcTo(EndofArc,CenterPoint,false)
			
			startX = startX + secant + LegWidth
			MyContour:LineTo(startX,startY)
			startY = startY+LegSize
			MyContour:LineTo(startX,startY)
		end
		
		if BottomStyle == 4 then 	--> Option 4 is what I call drapes
									--> It will draw a series of half circles
									--> along the bottom edge of the box.
			local LegWidth = LegSize * 1.5

			MyContour:AppendPoint(startX,startY)
			startY = startY - LegSize
			MyContour:LineTo(startX,startY)		--> Line down
			startX = startX + LegWidth
			secant = (BoxWidth-(LegWidth*2))/BottomPointCount			
			MyContour:LineTo(startX,startY)		--> Bottom of leg
			startY = startY + LegSize
			MyContour:LineTo(startX,startY)		--> Line up
	-- radius = (((s^2)/(h*4))+h)/2		

			ChordLenSq = secant*secant	--> square the secant
			ChordHeight = (LegSize*.75)
			ChordHeightx4 = (ChordHeight)*4		
			ChordRadius = ((ChordLenSq/ChordHeightx4)+(ChordHeight))/2
			
			zWork = 0			--> reuse old work variable			
			while zWork < BottomPointCount do
				StartofArc = Point2D(startX,startY)
				MidPoint = (startX+(secant/2))
				CenterPoint = Point2D(MidPoint,startY+ChordRadius)
				EndofArc = Point2D(startX+secant,startY)
				startX = startX+secant
				MyContour:ArcTo(EndofArc,CenterPoint,true)
				zWork = zWork+1
			end
			startY = startY - LegSize
			MyContour:LineTo(startX,startY)		--> Line down
			startX = startX + LegWidth
			MyContour:LineTo(startX,startY)
			startY = startY + LegSize
			MyContour:LineTo(startX,startY)
		end


		--> start building right side pins
		PinsComplete = 0
		while PinsComplete < PinCount do
			PinsComplete = PinsComplete + 1		--> Yup, this will complete a pin
			if PinsComplete == PinCount then	--> If we are building the last right side pin
				PinHeight = HeightofPin
			end
			startY = startY + PinHeight
			MyContour:LineTo(startX,startY)		--> Up

			if PinsComplete == PinCount then
				break
			end
			
			PinHeight = HeightofPin + BoxAllowance	--> Do this every time, gap needs it
			startX = startX - PinWidth
			MyContour:LineTo(startX,startY)			--> Left
			if ToolRadius == 0 then
			else
				endX = startX - (ToolDiameter)
				midX = startX - ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX - (ToolDiameter)
			end
			
			--> gap finished, now start the pin
			startY = startY + PinHeight				--> Up
			MyContour:LineTo(startX,startY)
			PinHeight = HeightofPin - BoxAllowance	--> Do this every time, pin needs it
			
			if ToolRadius == 0 then		--> No filets wanted
				startX = startX + PinWidth
				MyContour:LineTo(startX,startY)		--> Right
			else						--> Gotta draw it with filets
				endX = startX + (ToolDiameter)
				midX = startX + ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX + (ToolDiameter)
				startX = startX + PinWidth
				MyContour:LineTo(startX,startY)
			end	
			 				--> end of right side pins
		end	
		startX = beginX + WidthofPin
		MyContour:LineTo(startX,startY)				
		FinishUp(job,MyContour,SaveLayerName)
		MyContour = nil
		MyContour = Contour(0.0)
								--> ends if FrontBack

	else							--> Sides are somewhat different
		SaveLayerName = LayerName .. " End"
		TopLeftX = startX
		TopLeftY = startY
		MyContour:AppendPoint(startX,startY)		--> Start a new contour
		PinsComplete = 0
		while PinsComplete < PinCount do
			
			PinsComplete = PinsComplete + 1		--> Yup, this will complete a gap
			startY = startY - PinHeight
			MyContour:LineTo(startX,startY)		--> Down
			if PinsComplete == PinCount then
				break
			end
			
			PinHeight = HeightofPin - BoxAllowance	--> Do this every time, gap needs it
			if ToolRadius == 0 then
			else
				endX = startX - (ToolDiameter)
				midX = startX - ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX - (ToolDiameter)
			end
			
			startX = startX - PinWidth				
			MyContour:LineTo(startX,startY)				--> Left
			--> gap finished, now start the pin
			startY = startY - PinHeight
			MyContour:LineTo(startX,startY)				-- Down
			PinHeight = HeightofPin + BoxAllowance	--> Do this every time, pin needs it

			if ToolRadius == 0 then		--> No filets wanted
				startX = startX + PinWidth
				MyContour:LineTo(startX,startY)
			
			else						--> Gotta draw it with filets
				startX = startX + PinWidth
				MyContour:LineTo(startX,startY)				--> Right
				endX = startX + (ToolDiameter)
				midX = startX + ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX + (ToolDiameter)
			end	
		end					--> ends while PinsComplete < PinCount
		startX = beginX + BoxWidth - WidthofPin
		MyContour:LineTo(startX,startY)

		
		PinsComplete = 0
		while PinsComplete < PinCount do	--> start building right side pins
			PinsComplete = PinsComplete + 1		--> we're going to complete a gap soon
			if PinsComplete == PinCount then	--> if it is then this is last gap
				PinHeight = HeightofPin
			end
			startY = startY + PinHeight
			MyContour:LineTo(startX,startY)			--> Up

			if PinsComplete == PinCount then
				break
			end
			
			PinHeight = HeightofPin - BoxAllowance	--> Do this every time, gap needs it
			if ToolRadius == 0 then
			else
				endX = startX + (ToolDiameter)
				midX = startX + ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX + (ToolDiameter)
			end
			startX = startX + PinWidth
			MyContour:LineTo(startX,startY)			--> Right
		
			--> Gap finished, now start the pin
			startY = startY + PinHeight
			MyContour:LineTo(startX,startY)			--> Up
			PinHeight = HeightofPin + BoxAllowance	--> Do this every time, pin needs it
			startX = startX - PinWidth
			MyContour:LineTo(startX,startY)
			if ToolRadius == 0 then		--> No filets wanted

			else						--> Gotta draw it with filets
				endX = startX - (ToolDiameter)
				midX = startX - ToolRadius
				MyContour:ArcTo(Point2D(endX,startY),Point2D(midX,startY),false)
				startX = startX - (ToolDiameter)
			end	
		end					--> ends while PinsComplete < PinCount

		startX = beginX + WidthofPin
		MyContour:LineTo(startX,startY)
		FinishUp(job,MyContour,SaveLayerName)
		MyContour = nil
		MyContour = Contour(0.0)
	end									--> Boxes are complete
	
	--> Pins are done, let's do rails if they are wanted
	if RailHeight == 0 then			--> if zero no rails needed
	else				--> We;ll get started on the Sides
		RailHeight = RailHeight + BoxAllowance
		startX = beginX + (WidthofPin*.75)
		startY = beginY - BoxHeight +(WidthofPin*.5)
	
		zWork = BoxWidth - (WidthofPin*2) + (WidthofPin*.5)
		MyContour:AppendPoint(startX,startY)
		startX = startX + zWork
		MyContour:LineTo(startX,startY)
		startY = startY + RailHeight
		MyContour:LineTo(startX,startY)
		startX = startX - zWork
		MyContour:LineTo(startX,startY)
		startY = startY - RailHeight
		MyContour:LineTo(startX,startY)
		
		FinishUp(job,MyContour,SaveLayerName)
		MyContour = nil
		MyContour = Contour(0.0)
	end	
	if FrontBack then
	else
		local layer = job.LayerManager:GetLayerWithName(SaveLayerName)
		layer.Visible = false
	end
	
--> Now let's build a lid (but only once, after sides have been built)

	if FrontBack then
	else

		BoxWidth = myHTML:GetDoubleField("BoxWidth")
		BoxDepth = myHTML:GetDoubleField("BoxDepth")
		SaveLayerName = LayerName .. " Lid"
		startX = beginX
		startY = beginX							--> Here's lazy again
		if LidStyle == 2 then
			startX = beginX + EarHeight
		end
		if LidStyle == 3 then
			startY = beginX + EarHeight
		end
			
		MyContour:AppendPoint(startX,startY)
		if LidStyle == 2 then
			startY = startY+(BoxDepth*.25)
			MyContour:LineTo(startX,startY)
			
			secant = BoxDepth*.5
			ChordLenSq = secant*secant	--> square the secant
			ChordHeight = EarHeight
			ChordHeightx4 = ChordHeight*4		
			ChordRadius = ((ChordLenSq/ChordHeightx4)+(ChordHeight))/2

			CenterPoint = Point2D(startX+ChordRadius-ChordHeight,startY+(secant/2))
			EndofArc = Point2D(startX,startY+secant)
			startY = startY+(BoxDepth*.75)
			MyContour:ArcTo(EndofArc,CenterPoint,false)
		else
			startY = startY + BoxDepth
		end
		MyContour:LineTo(startX,startY)				--> Finish the left side
		startX = startX + BoxWidth
		MyContour:LineTo(startX,startY)				--> Line across the top
		
		if LidStyle == 2 then
			startY = startY-(BoxDepth*.25)
			MyContour:LineTo(startX,startY)				--> Line part way down right side
			CenterPoint = Point2D(startX-ChordRadius+ChordHeight,startY-(secant/2))
			EndofArc = Point2D(startX,startY-secant)
			startY = startY-(BoxDepth*.75)
			MyContour:ArcTo(EndofArc,CenterPoint,false)
		else
			startY = startY - BoxDepth
		end
		MyContour:LineTo(startX,startY)				--> Finish right side
		
		if LidStyle == 3 then				--> Ear on Front
			startX = startX-(BoxWidth*.4)
			MyContour:LineTo(startX,startY)
			
			secant = BoxWidth*.2
			ChordLenSq = secant*secant	--> square the secant
			ChordHeight = EarHeight
			ChordHeightx4 = ChordHeight*4		
			ChordRadius = ((ChordLenSq/ChordHeightx4)+(ChordHeight))/2

			CenterPoint = Point2D(startX-(secant/2),startY+ChordRadius-ChordHeight)
			EndofArc = Point2D(startX-secant,startY)
			startX = startX-(BoxWidth*.6)
			MyContour:ArcTo(EndofArc,CenterPoint,false)
		else
			startX = startX - BoxWidth
		end
		MyContour:LineTo(startX,startY)				--> Line across left
		
		FinishUp(job,MyContour,SaveLayerName)
		MyContour = nil
		MyContour = Contour(0.0)
		
		startX = startX + WidthofPin + BoxAllowance
		startY = startY - WidthofPin - BoxAllowance + BoxDepth
		MyContour:AppendPoint(startX,startY)		--> Start a new contour	
		zWork = startX + BoxWidth - (WidthofPin*2) - (BoxAllowance*2)
		MyContour:LineTo(zWork,startY)
		yWork = startY - BoxDepth + (WidthofPin*2) + (BoxAllowance*2)
		MyContour:LineTo(zWork,yWork)
		MyContour:LineTo(startX,yWork)
		MyContour:LineTo(startX,startY)
		FinishUp(job,MyContour,SaveLayerName)
		MyContour = nil
		MyContour = Contour(0.0)
		local layer = job.LayerManager:GetLayerWithName(SaveLayerName)
		layer.Visible = false
		
--> Close to done. If they included bottom rails lets build a simple vector they can use to cut out a bottom piece
		if RailHeight == 0 then	
		else
			BoxWidth = myHTML:GetDoubleField("BoxWidth")
			BoxDepth = myHTML:GetDoubleField("BoxDepth")
			startX = beginX
			startY = beginX				--> Looks wierd, but I did it because I'm lazy
			zWork = BoxWidth - (WidthofPin*2) + (WidthofPin*.5) - (BoxAllowance*4)
			yWork = BoxDepth - (WidthofPin*2) + (WidthofPin*.5) - (BoxAllowance*4) 
			MyContour:AppendPoint(startX,startY)		--> Start a new contour	
			startX = startX + zWork
			MyContour:LineTo(startX,startY)
			startY = startY + yWork
			MyContour:LineTo(startX,startY)
			startX = beginX
			MyContour:LineTo(startX,startY)
			startY = beginX				--> Looks wierd, but I did it because I'm lazy (still)
			MyContour:LineTo(startX,startY)
			
			SaveLayerName = LayerName.." Bottom"
			FinishUp(job,MyContour,SaveLayerName)
			MyContour = nil
			MyContour = Contour(0.0)
			local layer = job.LayerManager:GetLayerWithName(SaveLayerName)
			layer.Visible = false
		end
	end
	return
end


function FinishUp(doc,Contour,LayerName)
	local cad_object = CreateCadContour(Contour)
	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName(LayerName)-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 0 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	
	doc:Refresh2DView()
	return true
end
--[[
function HideLayer(job,LayerName)
	local layer = job.LayerManager:GetLayerWithName(LayerName)
	layer.Visible = false
	return 
end
	

function OnLuaButton_BuildBox(myHTML)
	return true
end
]]
