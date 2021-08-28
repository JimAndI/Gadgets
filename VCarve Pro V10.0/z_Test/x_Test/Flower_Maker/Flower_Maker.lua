-- VECTRIC LUA SCRIPT
require("mobdebug").start()
function DrawFlower(size, sides, rotation)
	local line = Contour(0.0)
	local angle_step = (math.pi * 2) / sides
	local rotation_radians = math.rad(rotation)
	
	local start_point = Point2D(math.sin(angle_step + rotation_radians) * size, math.cos(angle_step + rotation_radians) * size)
	line:AppendPoint(start_point)
	
	for n=1, sides do
		local end_point = Point2D(math.sin(angle_step * n + rotation_radians) * size, math.cos(angle_step * n + rotation_radians) * size)	
		line:ArcTo(end_point, -1.0)
	end
	
	line:ArcTo(start_point, -1.0)
	line_object = CreateCadContour(line)
	return line_object
end

function OnLuaButton_MakeShape()
	DrawPattern()
	return true
end

function DrawPattern()
	local sides = dialog:GetIntegerField("SidesInput")
	local repeats = dialog:GetIntegerField("RepeatsInput")
	local size = dialog:GetDoubleField("SizeInput")
	
	job = VectricJob()
	layer = job.LayerManager:GetActiveLayer()
	
	local rotation_step = 360/repeats
	
	for index = 0, repeats do
		layer:AddObject(DrawFlower(size, sides, rotation_step * index), true)
	end
	
	job:Refresh2DView()
end

function main(path)
	dialog = HTML_Dialog(false, "file:" ..path.. "\\Flower_Maker.htm", 300, 300, "Flower Maker")
	dialog:AddIntegerField("SidesInput", 5)
	dialog:AddIntegerField("RepeatsInput", 6)
	dialog:AddDoubleField("SizeInput", 2.5)
	dialog:ShowDialog()
	return true
end