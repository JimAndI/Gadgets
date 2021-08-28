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

g_version = "1.0 by Ryan Patterson"

local txtOffsetX  = .5
local txtOffsetY  = .5

function main(script_path)
	--
	local registry = Registry("Square_Around")
	local retry_dialog = true
	
	txtOffsetX = registry:GetDouble("txtOffsetX",txtOffsetX)
	txtOffsetY = registry:GetDouble("txtOffsetY",txtOffsetY)
	
	while retry_dialog == true do
		local ret_value = 1
		local html_path = "file:" .. script_path .. "\\Square_Around\\Square_Around.htm"
		local frmMain = HTML_Dialog(true, g_DialogHtml, 500, 470, "Square_Around")
			
		frmMain:AddDoubleField("txtOffsetX", txtOffsetX)
		frmMain:AddDoubleField("txtOffsetY", txtOffsetY)
		frmMain:AddLabelField("GadgetVersion", g_version)
		
		if  not frmMain:ShowDialog() then
		-- DisplayMessageBox("User canceled dialog")
			return false
		end   
			
		txtOffsetX  = frmMain:GetDoubleField("txtOffsetX")
		txtOffsetY  = frmMain:GetDoubleField("txtOffsetY")
		
		if ret_value == 1 then
			retry_dialog = false  -- we got valid values
		end   
	end
		
	registry:SetDouble("txtOffsetX",txtOffsetX)
	registry:SetDouble("txtOffsetY",txtOffsetY)
	
	Box_Around(txtOffsetX,txtOffsetY)
	return true
end

function Box_Around(txtOffsetX,txtOffsetY)
	local mydoc = VectricJob()
	local linePTs = {}
	local MyLine 
	local minXY = Point2D(0,0)
	local maxXY = Point2D(0,0)
	local cnt = 0
	if not mydoc.Exists then
		MessageBox("There is not existing doc loaded")
		return false;
	end
	
 	local selection = mydoc.Selection
	if selection.IsEmpty then
       MessageBox("Please select one or more vectors")
       return false  
   end
 	local pos = selection:GetHeadPosition()
	local myContour
	local bounds
	local object
	
    while pos ~= nil do
     object , pos = selection:GetNext(pos)
       	-- iterate through each span in the contour
      	if (object.ClassName == "vcCadContour") or (object.ClassName == "vcCadPolyline") or (object.ClassName == "vcCadObjectGroup") then

				if (object.ClassName == "vcCadObjectGroup") then
					
					bounds =  object:GetBoundingBox()
					
				else
					myContour = object:GetContour()
					bounds = myContour.BoundingBox2D
				end
				if cnt == 0 then
					minXY.x = bounds.MinX
					minXY.y = bounds.MinY
					maxXY.x = bounds.MinX + bounds.XLength
					maxXY.y = bounds.MinY + bounds.YLength
				else
					if minXY.x > bounds.MinX then minXY.x = bounds.MinX end
					if minXY.y > bounds.MinY then minXY.y = bounds.MinY end
					if maxXY.x < bounds.MinX + bounds.XLength then maxXY.x = bounds.MinX + bounds.XLength end
					if maxXY.y < bounds.MinY + bounds.YLength then maxXY.y = bounds.MinY + bounds.YLength end
				end
			
         	cnt = cnt + 1
      	end
    end
	--MessageBox (" " .. txtOffsetX)
	linePTs[0] = Point2D(minXY.x - txtOffsetX,minXY.y - txtOffsetY)
	linePTs[1] = Point2D(maxXY.x + txtOffsetX,minXY.y - txtOffsetY)
	linePTs[2] = Point2D(maxXY.x + txtOffsetX ,maxXY.y + txtOffsetY)
	linePTs[3] = Point2D(minXY.x - txtOffsetX,maxXY.y + txtOffsetY)
	linePTs[4] = Point2D(minXY.x - txtOffsetX,minXY.y - txtOffsetY)
	MyLine = Draw_Line(mydoc,linePTs)
	--local bounds2 = MyLine.BoundingBox2D
	--bounds2 = MyLine.BoundingBox2D

	Refreash(mydoc,MyLine,"Square_Around")

	return true
end

-----Draw Line 
-----Aguments ... CadDocument .. array of X,Y points
-----Returns Contour
function Draw_Line(doc,XYPoints)

	local MyContour = Contour(0.0)
	local p1 = XYPoints[0]
	local Angle
   	MyContour:AppendPoint(p1)
	for i=1,table.getn(XYPoints) do
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
	for i=1,table.getn(XYPoints) do
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
	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName(LayerName)-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 0 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	
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
</style>
</head>

<body bgcolor="#CCCCFF" class="newStyle1" style="height: 177px">

<p style="height: 180px" class="Title">
<label id="Label1" visible="true">Square Around</label>&nbsp;
<img align="center"  src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQQAAADCCAMAAACYEEwlAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAADT9pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+Cjx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDQuMi4yLWMwNjMgNTMuMzUyNjI0LCAyMDA4LzA3LzMwLTE4OjEyOjE4ICAgICAgICAiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgeG1sbnM6eG1wUmlnaHRzPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvcmlnaHRzLyIKICAgIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIKICAgIHhtbG5zOklwdGM0eG1wQ29yZT0iaHR0cDovL2lwdGMub3JnL3N0ZC9JcHRjNHhtcENvcmUvMS4wL3htbG5zLyIKICAgeG1wUmlnaHRzOk1hcmtlZD0iVHJ1ZSIKICAgeG1wUmlnaHRzOldlYlN0YXRlbWVudD0iIgogICBwaG90b3Nob3A6QXV0aG9yc1Bvc2l0aW9uPSIiPgogICA8ZGM6cmlnaHRzPgogICAgPHJkZjpBbHQ+CiAgICAgPHJkZjpsaSB4bWw6bGFuZz0ieC1kZWZhdWx0Ii8+CiAgICA8L3JkZjpBbHQ+CiAgIDwvZGM6cmlnaHRzPgogICA8ZGM6Y3JlYXRvcj4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkvPgogICAgPC9yZGY6U2VxPgogICA8L2RjOmNyZWF0b3I+CiAgIDxkYzp0aXRsZT4KICAgIDxyZGY6QWx0PgogICAgIDxyZGY6bGkgeG1sOmxhbmc9IngtZGVmYXVsdCIvPgogICAgPC9yZGY6QWx0PgogICA8L2RjOnRpdGxlPgogICA8eG1wUmlnaHRzOlVzYWdlVGVybXM+CiAgICA8cmRmOkFsdD4KICAgICA8cmRmOmxpIHhtbDpsYW5nPSJ4LWRlZmF1bHQiLz4KICAgIDwvcmRmOkFsdD4KICAgPC94bXBSaWdodHM6VXNhZ2VUZXJtcz4KICAgPElwdGM0eG1wQ29yZTpDcmVhdG9yQ29udGFjdEluZm8KICAgIElwdGM0eG1wQ29yZTpDaUFkckV4dGFkcj0iIgogICAgSXB0YzR4bXBDb3JlOkNpQWRyQ2l0eT0iIgogICAgSXB0YzR4bXBDb3JlOkNpQWRyUmVnaW9uPSIiCiAgICBJcHRjNHhtcENvcmU6Q2lBZHJQY29kZT0iIgogICAgSXB0YzR4bXBDb3JlOkNpQWRyQ3RyeT0iIgogICAgSXB0YzR4bXBDb3JlOkNpVGVsV29yaz0iIgogICAgSXB0YzR4bXBDb3JlOkNpRW1haWxXb3JrPSIiCiAgICBJcHRjNHhtcENvcmU6Q2lVcmxXb3JrPSIiLz4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Pqd7HJcAAAIHUExURZKSkuPj43d3d3JyctnZ2UxMTP93///9///6///0///y///8///3///o///s///O///7///r///g///k///1///u///5///S///v///2///i//+y///p//+r///c//+6///z///4///U//+z///R///Y///b//98///h///K///T///x///l///V///w///N///D///W//+i///F//+S///C//+C//+O///t///j//+d///Q///m///n//+1///+///I//+J//+v//+g//+w//9M//+M//+9///X///f//+I//+Z//+0///q//+j//99//+Y//+////G//+e//+2//+E//+t//+n//+U//+q//+B///Z///M///E//+o//++//+m//+c///A//95//+f///e///a///P///J//+u//+7//+h//+H///H//+T//+A//+D//+K///d///L//+Q//+b//9y///B//+F//+P//+p//97//+5//9///+R//9q//+N//+x//+a//+8//+l//+4//91//+L//+W//9+//9w//+3//+k//+s//9t//9f//9b//9m//9X//+V//9c//9h//9P/6ampv9z/2lpaf9x//9a//90//96/8HBwUhISJaWlv9g//94//+X/29vb/9u/8PDw/9i//9R//9l//9Y//9n/////1tiolEAAAqTSURBVHja7J3lYxs5FsB7JDNT7LhhBsd2EoexabBhpgYa5hS2jFvctrt7S8fMd++PPCfZNHZiGEFmMvA+JGNbGsk/60nv6UmaS6AIXFIQKBAUCAkg/Oan0pe//zkJhF/I4Lf/+c8UCAoEBYL4IOROKxCcLftm2UPQeb7RyB5CKXTqZA/hKoBV9hDmDjnIG4I6rAupcofwZlGxE2AuDSBvz6FYjDBvkDWEtmuK2Qw3jv59pqgDwD/kDCFYoniR8DDv6H/JR0UdwPJ4WbYQrGugqMNc+/HVar1sIbh9x1cpX8sWQtnJZZpcIextn1yb02QKoVB9cu34Tp4Q9PqIF5mL8oTw8mXkK5VKlhBycqIs6AcSg6Ct2MHOY76iTpomNRUMzWKBYPyyBSCE6qEW3QJTcA2swcwziTKecrlVX1ADjU+yYB2lQ7PfMtZeLBp1MGadXBuKSsBXtABG9BDgfbYWhrJrDt6v9ZzKdABlNrsEirI74RaqhXoUAsgqUkOa7agjzTaIrk8IDceILG377eDye+Eaunbms38jI9T5LZDm74p5wx6/UXwdY2cxw15mwSfa0aH2BaM44yhJ6PqiDJF5peCkNAB0mlrx2wkd/dlU+RtCNgkYS2qK9QdtY9KxGF2ojczFKk+RktlsA00d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" />
</p>
<hr />
<hr />
<table style="width: 100%">
	<tr>
		<td class="auto-style5" style="width: 605px">&nbsp;</td>
	</tr>
	<tr>
		<td class="auto-style5" style="width: 605px; height: 64px">
		<table style="width: 100%">
			<tr>
				<td class="auto-style8" style="width: 64px">
							Offset X</td>
				<td class="auto-style8" style="width: 79px">
                  <input name="txtFocus" type="text" id="txtOffsetX" size="8" maxlength="8" style="width: 72px; height: 19px;"></td>
				<td class="auto-style8">
							Offset Y</td>
				<td class="auto-style8">
                  <input name="txtDistance" type="text" id="txtOffsetY" size="8" maxlength="8" style="width: 72px; height: 19px;"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="width: 605px">
<hr />
		</td>
	</tr>
</table>
<table style="width: 100%; height: 62px;">
    <tr>
		<td colspan="5"><hr></td>
	</tr>
	<tr>
	    <td style="width: 20%"></td>
		<td style="width: 20%">
			<input width="100%" id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="OK">
		</td>
		<td style="width: 20%"></td>
		<td style="width: 20%">
			<input width="100%" id="ButtonCancel" class="FormButton" name="ButtonCancel" type="button" value="Cancel">
		</td>	
		<td style="width: 20%"></td>
	</tr>
	<tr>
		<td colspan="3"><a href="http://www.cabinetpartspro.com">www.cabinetpartspro.com</a> </td>
		<td colspan="2" align = "right" style="color: #999999" >Version <span align="right" id=GadgetVersion>0.0</span></td>

	</tr>
</table>

</body>

</html>

]]




