-- VECTRIC LUA SCRIPT

function CreateGrid(side_length)

	triangle_height = side_length * math.cos(math.rad(30))
	triangle_tip = Point2D(triangle_height, side_length / 2)

	local shape_option = dialog:GetRadioIndex("ShapeOption")
	
	local shape

	if (shape_option == 1) then
		shape = CreateTriangle(side_length)
	end

	if (shape_option == 2) then
		local radius = 0.5 * side_length * math.tan(math.rad(30))
		shape = CreateCircle(radius, 0.5 * side_length, radius,0,0)
	end

	local hexagon = CreateHexagon(shape)
	local bottom_row = CreateBottomRow(hexagon)
	local grid = CreateMultipleRows(bottom_row)

	return grid

end

function CreateTriangle(side_length)

	local triangle = Contour(0.0)
	
	local point_1 = Point2D(0,0)
	local point_2 = Point2D(0, side_length)
	local point_3 = triangle_tip
	
	triangle:AppendPoint(point_1)
	triangle:LineTo(point_2)
	triangle:LineTo(point_3)
	triangle:LineTo(point_1)
	
	return triangle

end

function CreateHexagon(triangle)

	local rotation_matrix = RotationMatrix2D(triangle_tip, 60)
	
	local hexagon_group = ContourGroup(true)
	
	for i = 1, 6 do
		local triangle_copy = triangle:Clone()
		hexagon_group:AddTail(triangle_copy)
		triangle:Transform(rotation_matrix)
	end
	
	return hexagon_group

end

function CreateBottomRow(hexagon)

	local hexagon_width = 2 * triangle_height
	local translation_vector = Vector2D(hexagon_width, 0)
	local translation_matrix = TranslationMatrix2D(translation_vector)
	
	local num_hexagons = math.ceil(job.Width / hexagon_width)
	
	local row_group = ContourGroup(true)
	
	for i = 1, num_hexagons do
		local hexagon_copy = hexagon:Clone()
		row_group:AppendGroup(hexagon_copy)
		hexagon:Transform(translation_matrix)
	end
	
	return row_group

end

function CreateMultipleRows(row)

	local translation_vector = Vector2D(-triangle_height, 1.5 * side_length)
	local translation_matrix = TranslationMatrix2D(translation_vector)
	
	local num_rows = math.ceil(job.Height / (1.5 * side_length))
	
	local grid_group = ContourGroup(true)
	
	for i = 1, num_rows do
	
		local row_copy = row:Clone()
		grid_group:AppendGroup(row_copy)
	
		row:Transform(translation_matrix)
		
		translation_vector.x = -translation_vector.x
		translation_matrix = TranslationMatrix2D(translation_vector)
		
	end

	return grid_group

end

function OnLuaButton_ApplyButton()

	job = VectricJob()
	
	if not job.Exists then
		MessageBox("No job is open")
		return false
	end

	layer_manager = job.LayerManager
	active_layer = layer_manager:GetActiveLayer()
	
	side_length = dialog:GetDoubleField("SizeInput")
	
	if(side_length <= 0) then 
		MessageBox("Size must be greater than zero")
		return false
	end
	
	grid = CreateGrid(side_length)
	
	cad_grid = CreateCadGroup(grid)
	
	active_layer:AddObject(cad_grid, true)
	
	job:Refresh2DView()

	return true

end

function main(path)

	dialog = HTML_Dialog(false, path .. "\\Tiling_Creator.html", 450, 200, "Tiling Creator")
	dialog:AddDoubleField("SizeInput", 0.5)
	dialog:AddRadioGroup("ShapeOption", 1)
	dialog:ShowDialog()



	return true
end







