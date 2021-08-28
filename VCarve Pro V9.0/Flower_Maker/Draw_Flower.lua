-- VECTRIC LUA SCRIPT
function drawflower(size, rotation)
	 local line = Contour(0.0)
	 local sides = 5
	 local angle_step = (math.pi * 2)/ sides
	 local rotation_radians = math.rad(rotation)
	 
	 local start_point = Point2D(math.sin(angle_step + rotation_radians) * size, math.cos(angle_step + rotation_radians) * size)
	 line:AppendPoint(start_point)
	
	for n=1, sides do
		local end_point = Point2D(math.sin(angle_step * n + rotation_radians) * size, math.cos(angle_step * n + rotation_radians) * size)
		line:ArcTo(end_point, -1.0)
	end
	--line:ArcTo(start_point, -1.0)
  line:LineTo(start_point)
	line_object = CreateCadContour(line)
	return line_object
end

function main ()
	 job = VectricJob()
	 layer = job.LayerManager:GetActiveLayer()
	 local repeats = 7
	 local rotation_step = 360/repeats
	 for index =0, repeats do
		layer:AddObject(drawflower(2, rotation_step * index), true)
	 end
	 job:Refresh2DView()
	 return true
end