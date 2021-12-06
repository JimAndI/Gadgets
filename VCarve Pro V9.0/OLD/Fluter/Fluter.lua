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

g_Version = "1.0 by Ryan Patterson"

f_Length  = 30
f_Height  = 3
f_NoFluts  = 3

f_StartFlute  = 3
f_StopFlute  = 3
f_CutterWidth  = .375
xy_origin_index = 0

OriginX  = 0
OriginY  = 0
		
function main(script_path)

	local doc = VectricJob()
	if not doc.Exists then
	DisplayMessageBox("No job loaded")
		return false;
	end
	
	
	--------------------
	local retry_dialog = true
	local ret_value = 1
	

		local origin_off = Point2D(0,0)
		
		local registry = Registry("Fluter")
		f_Length = registry:GetDouble("f_Length",     f_Length) 
		f_Height = registry:GetDouble("f_Height",     f_Height)
		f_NoFluts = registry:GetInt("f_NoFluts",     f_NoFluts)
		
		f_StartFlute = registry:GetDouble("f_StartFlute",     f_StartFlute)
		f_StopFlute = registry:GetDouble("f_StopFlute",     f_StopFlute)
		f_CutterWidth = registry:GetDouble("f_CutterWidth",     f_CutterWidth)

		OriginX = registry:GetDouble("OriginX",     OriginX)
		OriginY = registry:GetDouble("OriginY",     OriginY)
		xy_origin_index = registry:GetInt("xy_origin_index",     xy_origin_index)
		
	
		
	while retry_dialog == true do
		ret_value = 1
		local html_path = "file:" .. script_path .. "\\Fluter\\Fluter.htm"
		
		local frmMain = HTML_Dialog(false, html_path, 490, 610, "Fluter")
		frmMain:AddLabelField("GadgetVersion", g_Version)
		frmMain:AddDoubleField("txtLenght", f_Length)
		frmMain:AddDoubleField("txtHeight", f_Height)
		frmMain:AddDoubleField("txtNoFluts", f_NoFluts)
		
		
		frmMain:AddDoubleField("txtStartFlute", f_StartFlute)
		frmMain:AddDoubleField("txtStopFlute", f_StopFlute)
		frmMain:AddDoubleField("txtSpacing", f_CutterWidth)
		
		frmMain:AddRadioGroup("DrawingOrigin", xy_origin_index)
		frmMain:AddDoubleField("OriginX", OriginX)
		frmMain:AddDoubleField("OriginY", OriginY)
		
		if  not frmMain:ShowDialog() then
		-- DisplayMessageBox("User canceled dialog")
			return false
		end   
	
		f_Length  = frmMain:GetDoubleField("txtLenght")
		f_Height  = frmMain:GetDoubleField("txtHeight")
		f_NoFluts  = frmMain:GetDoubleField("txtNoFluts")
		
		f_StartFlute  = frmMain:GetDoubleField("txtStartFlute")
		f_StopFlute  = frmMain:GetDoubleField("txtStopFlute")
		f_CutterWidth  = frmMain:GetDoubleField("txtSpacing")
		xy_origin_index = frmMain:GetRadioIndex("DrawingOrigin")
		
		OriginX  = frmMain:GetDoubleField("OriginX")
		OriginY  = frmMain:GetDoubleField("OriginY")
		origin_off = Point2D(0,0)
		
		if f_Length < (f_StartFlute + f_StopFlute) then
			ret_value = -1
			DisplayMessageBox("Length has to be greater than the sum of the start and the stop " .. f_StartFlute + f_StopFlute .. "  " .. f_Length)
		end
	
		if ret_value == 1 then
			retry_dialog = false  -- we got valid values
		end   
		--DisplayMessageBox("origin_off.x = " .. origin_off.x)
	end

	 
	if xy_origin_index == 1 then --"TLC"
		origin_off.x = OriginX 
		origin_off.y = OriginY - f_Height
   	elseif xy_origin_index == 2 then  --TRC 
		origin_off.x = OriginX - f_Length
		origin_off.y = OriginY  - f_Height
   	elseif xy_origin_index == 3 then --CENTRE 
		origin_off.x = OriginX - (f_Length / 2)
		origin_off.y = OriginY - (f_Height/ 2)
   	elseif xy_origin_index == 4 then --BLC  
		origin_off.x = OriginX
		origin_off.y = OriginY
   	elseif xy_origin_index == 5 then --BRC 
		origin_off.x = OriginX - f_Length
		origin_off.y = OriginY
  	 end
   
	Draw_FluteBoarder(doc,origin_off,f_Length,f_Height)
	
	local cnt = 2
	local TotalFluteWidth = 0
	local FluteY = 0
	local Spacing = 0
	local FirstPlace = 0
	local FixedSpace = 0
	TotalFluteWidth = f_NoFluts * f_CutterWidth
	
	FluteY = ((f_Height-TotalFluteWidth) / (f_NoFluts + 1)) + (f_CutterWidth /2)
	
	--FluteY = FluteY + (f_Spacing /4 )
	Draw_Line(doc,origin_off.x + f_StartFlute ,origin_off.y + (FluteY)  ,origin_off.x + f_Length - f_StopFlute  ,origin_off.y + (FluteY))
	FirstPlace = origin_off.y + (FluteY)
	Spacing = FluteY  + (f_CutterWidth /2)
	FixedSpace = Spacing
	
	for var=0,f_NoFluts -2 do
      Draw_Line(doc,origin_off.x + f_StartFlute ,Spacing + FirstPlace  ,origin_off.x + f_Length - f_StopFlute  ,Spacing  + FirstPlace )
	  Spacing = Spacing + FixedSpace
	  cnt = cnt + 1
    end

	registry:SetDouble("f_Length",     f_Length)
	registry:SetDouble("f_Height",     f_Height)
	registry:SetDouble("f_NoFluts",     f_NoFluts)

	registry:SetDouble("f_StartFlute",     f_StartFlute)
	registry:SetDouble("f_StopFlute",     f_StopFlute)
	registry:SetDouble("f_CutterWidth",     f_CutterWidth)

	registry:SetDouble("OriginX",     OriginX)
	registry:SetDouble("OriginY",     OriginY)
	registry:SetInt("xy_origin_index",     xy_origin_index)
	return true; 
end 

function Draw_FluteBoarder(doc,origin_off,f_Length,f_Height)

	local Contour = Contour(0.0)
 	local p1 = Point2D(origin_off.x, origin_off.y)
  	local p2 = Point2D(f_Length + origin_off.x, origin_off.y)
   	local p3 = Point2D(f_Length + origin_off.x,origin_off.y + f_Height)
   	local p4 = Point2D(origin_off.x,origin_off.y + f_Height)
	
	Contour:AppendPoint(p1)
   	Contour:LineTo(p2)
	Contour:LineTo(p3)
	Contour:LineTo(p4)
	Contour:LineTo(p1)
	
	--------------------------------------------------------
	local cad_object = CreateCadContour(Contour)
	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName("Flut_Cut")-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 255255255 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	doc:Refresh2DView()	
	-----------------------------------------------------------------
	return true; 
end

function Draw_Line(doc,sp1,sp2,ep1,ep2)

	local Contour = Contour(0.0)

	local p1 = Point2D(sp1,sp2)
	local p2 = Point2D(ep1,ep2)

   
   	Contour:AppendPoint(p1)
   	Contour:LineTo(p2)
   
	local cad_object = CreateCadContour(Contour)
	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName("Flutes")-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 255255255 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	
    doc:Refresh2DView()
    return true; 
end