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

local doc = VectricJob()


function main()
	local center0 = Point2D(3,3)
	local radius0 = 2
	local center1 = Point2D(6,6)
	local radius1 = 6
	local StartP = Point2D(-1,-1)
	local intersection1 = Point2D(0,0)
	local intersection2 = Point2D(0,0)
	
	local outer1_p1 = Point2D(0,0)
    local outer1_p2 = Point2D(0,0)
    local outer2_p1 = Point2D(0,0)
    local outer2_p2 = Point2D(0,0)
    local inner1_p1 = Point2D(0,0)
    local inner1_p2 = Point2D(0,0)
    local inner2_p1 = Point2D(0,0)
    local inner2_p2 = Point2D(0,0)
	local NumerOfTangents = 0
	local CircleTest = true
	
	if not doc.Exists then
		DisplayMessageBox("There is not existing doc loaded")
		return false;
	end
	local selection = doc.Selection
   	if selection.IsEmpty then
    	MessageBox("Please select one or more vectors to label")
       	return false  
   	end
	local ctr_count = 0
	local pos = selection:GetHeadPosition()
	while pos ~= nil do
	--for var=0,1 do
		local object
		object , pos = selection:GetNext(pos)
		-- iterate through each span in the contour
		if (object.ClassName == "vcCadContour") or (object.ClassName == "vcCadPolyline") then
			local Contour = object:GetContour()
			if ctr_count == 0 then
				CircleTest,center0,radius0 = MarkContourNodes(Contour)
			else
				CircleTest,center1,radius1 = MarkContourNodes(Contour)
			end
			if CircleTest == false then
				return false
			end
			
			ctr_count = ctr_count + 1
			if ctr_count == 2 then break end
		end
	end
	if ctr_count < 2 then 
		MessageBox ("Two circles must be selected")
		return false 
	end
	
	
	intersection1,intersection2 =FindCircleCircleIntersections(center0,radius0,center1,radius1)
	
	NumerOfTangents,outer1_p1,outer1_p2, outer2_p1,outer2_p2, inner1_p1,inner1_p2, inner2_p1,inner2_p2 = FindCircleCircleTangents(center0,radius0,center1,radius1)
	--MessageBox ("NumerOfTangents  " .. NumerOfTangents  .. "  " .. outer1_p1.x .. " " ..  outer1_p1.y .. " " ..  outer1_p2.x  .. " " ..  outer1_p2.y  .. " " ..  outer2_p1.x .. " " ..  outer2_p1.y .. " " .. outer2_p2.x .. " " .. outer2_p2.y)
	--MessageBox ("inter1 X " .. intersection2.x .. "inter1 Y " .. intersection2.y)
	if NumerOfTangents > 0 then
		if NumerOfTangents > 1 then
			Draw_Line(doc,outer1_p1.x, outer1_p1.y,    outer1_p2.x, outer1_p2.y)
			Draw_Line(doc,outer2_p1.x, outer2_p1.y,    outer2_p2.x, outer2_p2.y)
		end 
		if NumerOfTangents == 4 then
			Draw_Line(doc,inner1_p1.x, inner1_p1.y,    inner1_p2.x, inner1_p2.y)
			Draw_Line(doc,inner2_p1.x, inner2_p1.y,    inner2_p2.x, inner2_p2.y)
		end
	end 
	
	return true
end


function Draw_Line(doc,sp1,sp2,ep1,ep2)


	local Contour = Contour(0.0)

	local p1 = Point2D(sp1,sp2)
	local p2 = Point2D(ep1,ep2)

   
   	Contour:AppendPoint(p1)
   	Contour:LineTo(p2)
   
	local cad_object = CreateCadContour(Contour)
	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName("Tangents")-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 255255255 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	
doc:Refresh2DView()
return true; 
end


-- Find the points where the two circles intersect.
function FindCircleCircleIntersections(center0, radius0,center1,radius1)--,intersection1,intersection2)
	local dx --As Single
	local dy --As Single
	local dist --As Double
	local a --As Double
	local h --As Double
	local cx2 --As Double
	local cy2 --As Double
	local intersection1 = Point2D(0,0)
	local intersection2 = Point2D(0,0)
	
		-- Find the distance between the centers.
		dx = center0.X - center1.X
		dy = center0.Y - center1.Y
		dist = math.sqrt(dx * dx + dy * dy)

         -- Find a and h.
        a = (radius0 * radius0 - radius1 * radius1 + dist * dist) / (2 * dist)
        h = math.sqrt(radius0 * radius0 - a * a)

        -- Find P2.
        cx2 = center0.X + a * (center1.X - center0.X) / dist
        cy2 = center0.Y + a * (center1.Y - center0.Y) / dist

        -- Get the points P3.
       -- Set intersection1 = New PointF
       -- Set intersection2 = New PointF
		
        intersection1.X = (cx2 + h * (center1.Y - center0.Y) / dist)
        intersection1.Y = (cy2 - h * (center1.X - center0.X) / dist)
        intersection2.X = (cx2 - h * (center1.Y - center0.Y) / dist)
        intersection2.Y = (cy2 + h * (center1.X - center0.X) / dist)

        -- See if we have 1 or 2 solutions.
        if dist == radius0 + radius1 then
            --FindCircleCircleIntersections = 1
			--MessageBox ("Line 100 " .. dist )
        else
            --FindCircleCircleIntersections = 2

			--return intersection1,intersection2
			--MessageBox ("Line 103 " .. dist )
        end
		--MessageBox("intersection1_X " .. intersection1.x .." intersection1_Y " .. intersection1.y .." intersection2_X " .. intersection2.x .." intersection2_Y " .. intersection2.y ) 
		--Draw_Line(doc,intersection1.x, intersection1.y,    intersection2.x, intersection2.y)
		return intersection1,intersection2
end

-- Find the tangent points for this circle and external point.
-- Return true if we find the tangents, false if the point is
-- inside the circle.
function FindTangents(center,radius, pt)
    local pt1 = Point2D(0,0) --returned
	local pt2 = Point2D(0,0) --returned
	
	local dx --As Double
	local dy --As Double
	local D_squared --As Double
	local L --As Double

    -- Find the distance squared from the
    -- external point to the circle--s center.
    dx = center.X - pt.X
    dy = center.Y - pt.Y
    D_squared = dx * dx + dy * dy
    if (D_squared < radius * radius) then
        pt1.X = -1
		return false,pt1,pt2
    end

    -- Find the distance from the external point
    -- to the tangent points.
    L = math.sqrt(D_squared - radius * radius)

    -- Find the points of intersection between
    -- the original circle and the circle with
    -- center external_point and radius dist.
    pt1, pt2 = FindCircleCircleIntersections (center, radius, pt, L) 
	
	return true,pt1,pt2
end 

  

-- Find the tangent points for these two circles.
-- Return the number of tangents: 4, 2, or 0.
function FindCircleCircleTangents(c1, radius1 , c2 , radius2 )

	
	local radius2a --As Single
	local v1x --As Single
	local v1y --As Single
	local v1_length --As Single
	local v2x --As Single
	local v2y --As Single
	local v2_length --As Single
	local dx --As Single
	local dy --As Single
	local dist --As Double
	local radius1a --As Single
	local outer1_p1 = Point2D(0,0)
	local outer1_p2 = Point2D(0,0)

    local outer2_p1 = Point2D(0,0)
    local outer2_p2 = Point2D(0,0)
	
    local inner1_p1 = Point2D(0,0)
    local inner1_p2 = Point2D(0,0)
	
    local inner2_p1 = Point2D(0,0)
    local inner2_p2 = Point2D(0,0)
    -- Make sure radius1 <= radius2.
    if (radius1 > radius2) then
        -- Call this method switching the circles.
		local noTangs
        noTangs,outer1_p2, outer1_p1,outer2_p2, outer2_p1,inner1_p2, inner1_p1,inner2_p2, inner2_p1 = FindCircleCircleTangents(c2, radius2, c1, radius1)
        --MessageBox ("Line 202 There are no tangents " .. noTangs)
		return noTangs,outer1_p2, outer1_p1,outer2_p2, outer2_p1,inner1_p2, inner1_p1,inner2_p2, inner2_p1
    end

    -- Initialize the return values in case
    -- some tangents are missing.
	

    -- ***************************
    -- * Find the outer tangents *
    -- ***************************
    radius2a = radius2 - radius1
	--MessageBox ("Line 219 " .. c2.x)
	local test
	test,outer1_p2, outer2_p2 = FindTangents(c2, radius2a, c1)
    --if (not FindTangents(c2, radius2a, c1, outer1_p2, outer2_p2)) then
	if test == false then
        -- There are no tangents.
		MessageBox "There are no tangents "
        return 0,outer1_p1, outer1_p2,outer2_p1, outer2_p2,inner1_p1, inner1_p2,inner2_p1, inner2_p2
    end

	--MessageBox ("line 223  " .. outer1_p1.x .. " , " ..  outer1_p1.y .. " , " ..  outer1_p2.x  .. " , " ..  outer1_p2.y  .. " , " ..  outer2_p1.x .. " , " ..  outer2_p1.y .. " , " .. outer2_p2.x .. " , " .. outer2_p2.y)

    -- Get the vector perpendicular to the
    -- first tangent with length radius1.
    v1x = -(outer1_p2.Y - c1.Y)
    v1y = outer1_p2.X - c1.X
    v1_length = (math.sqrt(v1x * v1x + v1y * v1y))
    v1x = v1x * radius1 / v1_length
    v1y = v1y * radius1 / v1_length
    -- Offset the tangent vector--s points.
    outer1_p1.X = c1.X + v1x
    outer1_p1.Y = c1.Y + v1y
    outer1_p2.X = outer1_p2.X + v1x
    outer1_p2.Y = outer1_p2.Y + v1y
    -- Get the vector perpendicular to the
    -- second tangent with length radius1.
    v2x = outer2_p2.Y - c1.Y
    v2y = -(outer2_p2.X - c1.X)
    v2_length = (math.sqrt(v2x * v2x + v2y * v2y))
    v2x = v2x * radius1 / v2_length
    v2y = v2y * radius1 / v2_length
    -- Offset the tangent vector--s points.
    outer2_p1.X = c1.X + v2x
    outer2_p1.Y = c1.Y + v2y
    outer2_p2.X = outer2_p2.X + v2x
    outer2_p2.Y = outer2_p2.Y + v2y

    -- If the circles intersect, then there are no inner tangents.
    dx = c2.X - c1.X
    dy = c2.Y - c1.Y
    dist = math.sqrt(dx * dx + dy * dy)
    if (dist <= radius1 + radius2) then
        return 2,outer1_p1, outer1_p2,outer2_p1, outer2_p2,inner1_p1, inner1_p2,inner2_p1, inner2_p2
    end

    -- ***************************
    -- * Find the inner tangents *
    -- ***************************
    radius1a = radius1 + radius2
    test,inner1_p2, inner2_p2 = FindTangents (c1, radius1a, c2) 
    -- Get the vector perpendicular to the
    -- first tangent with length radius2.
    v1x = inner1_p2.Y - c2.Y
    v1y = -(inner1_p2.X - c2.X)
    v1_length = (math.sqrt(v1x * v1x + v1y * v1y))
    v1x = v1x * radius2 / v1_length
    v1y = v1y * radius2 / v1_length
    -- Offset the tangent vector--s points.
    inner1_p1.X = c2.X + v1x
    inner1_p1.Y = c2.Y + v1y
    inner1_p2.X = inner1_p2.X + v1x
    inner1_p2.Y = inner1_p2.Y + v1y

    -- Get the vector perpendicular to the
    -- second tangent with length radius2.
    v2x = -(inner2_p2.Y - c2.Y)
    v2y = inner2_p2.X - c2.X
    v2_length = (math.sqrt(v2x * v2x + v2y * v2y))
    v2x = v2x * radius2 / v2_length
    v2y = v2y * radius2 / v2_length
    -- Offset the tangent vector--s points.
    inner2_p1.X = c2.X + v2x
    inner2_p1.Y = c2.Y + v2y
    inner2_p2.X = inner2_p2.X + v2x
    inner2_p2.Y = inner2_p2.Y + v2y

    return 4,outer1_p1, outer1_p2,outer2_p1, outer2_p2,inner1_p1, inner1_p2,inner2_p1, inner2_p2
end


function MarkContourNodes(Contour)

	local num_spans = 0
	
	local ctr_pos = Contour:GetHeadPosition()
	local Center = Point2D (0,0)
	local TotalX = 0
	local TotalY = 0
	local Nodes = Point2D(0,0)
	local cnt = 0
	local Radius = 0
	--local CheckPoint = Point2D(0,0)
	while ctr_pos ~= nil do
	
		local span
		span, ctr_pos = Contour:GetNext(ctr_pos) 
		num_spans = num_spans + 1;
		
		--Center = span.EndPoint2D
		Nodes.x =span.StartPoint2D.x
		Nodes.y =span.StartPoint2D.y
		TotalX = TotalX + Nodes.x
		TotalY = TotalY + Nodes.y
		cnt = cnt + 1      	--local end_pt   = span.EndPoint2D
	end
	Center.x = TotalX / cnt
	Center.y = TotalY / cnt
	Radius = Nodes.x - Center.x
	local bounds = Contour.BoundingBox2D
   	--local Center = bounds.Centre
	Radius = bounds.XLength  /2
	if Radius < 0 then Radius = (-1 * Radius) end
	
	local cursor = ContourCarriage(0, 0.0)
	local num_steps = 6
	local contour_length = Contour.Length
   	local step_dist = contour_length / num_steps
	local end_index = num_steps
	local DisCheck = 0
	local NotCircle = true
	
	for i = 1, end_index do
		local ctr_pos = cursor:Position(Contour)
		local CheckPoint =  (step_dist * (i - 1)), ctr_pos 
		cursor:Move(Contour, step_dist)
		--DisCheck = Center - ctr_pos
		DisCheck = math.sqrt(((Center.x - ctr_pos.x) * (Center.x - ctr_pos.x)) + ((Center.y - ctr_pos.y) * (Center.y - ctr_pos.y)))
		--MessageBox ("Length " .. DisCheck.Length  .. " X " .. (step_dist * (i - 1)) .. " y " .. ctr_pos.y)
		--MessageBox ("Radius = " .. Radius .. "Distance = " .. DisCheck)
		if (Radius - DisCheck) > .004 or (Radius - DisCheck) < -.004 then
			MessageBox ("Only circles can be selected " .. Radius - DisCheck)
			
			NotCircle = false
			break
			--MessageBox ("Only circles can be selected Radius = " .. Radius .. " dis " .. DisCheck.Length)
		end
	end



	--MessageBox ("Center X " .. Center.x .. "Center Y " .. Center.y .. " Radius " .. Radius)
	-- if contour was open mark last point
	if Contour.IsOpen then
	-- local marker = CadMarker("V:" .. num_spans, Contour.EndPoint2D, 3)
	-- layer:AddObject(marker, true)
	end
	
	return NotCircle,Center,Radius		

end

