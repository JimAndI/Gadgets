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
g_default_tool_name  = "No Tool Selected"
g_tool = nil
g_toolpath_name = "Valance_Toolpath"

create_ToolPath     = false
Length  = 30
Height  = 6
start  = 4
ArcHeight  = 5
xy_origin_index = 0
OriginX  = 0
OriginY  = 0
cutting_Depth = 0

function main(script_path)

local registry = Registry("Valance")
 local mtl_block = MaterialBlock()
 --cutting_Depth = mtl_block.Thickness 


Length 					= registry:GetDouble("Valance_Lenth",     Length) 
Height 					= registry:GetDouble("Valance_Height",     Height)
start 					= registry:GetDouble("Valance_start",     start)
ArcHeight 				= registry:GetDouble("Valance_ArcHeight",     ArcHeight)
xy_origin_index 		= registry:GetInt("xy_origin_index",     xy_origin_index)
OriginX 				= registry:GetDouble("OriginX",     OriginX)
OriginY 				= registry:GetDouble("OriginY",     OriginY)

g_default_tool_name  	= registry:GetString("DefaultToolName",  g_default_tool_name)
g_toolpath_name      	= registry:GetString("ToolpathName",     g_toolpath_name)
create_ToolPath     	= registry:GetBool("create_ToolPath", create_ToolPath)
cutting_Depth      		= registry:GetDouble("CuttingDepth", mtl_block.Thickness)
	  
local doc = VectricJob()
if not doc.Exists then
   DisplayMessageBox("There is not existing doc loaded")
    return false;
end


--------------------
	local retry_dialog 	= true
	local ret_value 	= 1
	local origin_off 	= Point2D(0,0)
	local tool
while retry_dialog == true do
	ret_value = 1
    local html_path = "file:" .. script_path .. "\\Valance\\Valance.htm"
	local frmMain = HTML_Dialog(false, html_path, 490, 700, "Create Valance")
	frmMain:AddDoubleField("Lenght", Length)
	frmMain:AddDoubleField("Height", Height)
	frmMain:AddDoubleField("Start", start)
	frmMain:AddDoubleField("ArcHeight", ArcHeight)
	frmMain:AddRadioGroup("DrawingOrigin", xy_origin_index)
	frmMain:AddDoubleField("OriginX", OriginX)
	frmMain:AddDoubleField("OriginY", OriginY)
	frmMain:AddLabelField("ToolNameLabel", "No Tool Selected")
	frmMain:AddToolPicker("ToolChooseButton", "ToolNameLabel", g_default_tool_name); 
   -- add allowed tool types - we only support end mills as a 'proxy' for a key hole cutter
   	frmMain:AddToolPickerValidToolType("ToolChooseButton", Tool.END_MILL)
	-- toolpath name
	frmMain:AddTextField("ToolpathName",  g_toolpath_name)
	frmMain:AddDoubleField("CuttingDepth",  cutting_Depth)
	frmMain:AddCheckBox("CheckToolPath", create_ToolPath)
	frmMain:AddLabelField("GadgetVersion", g_version)
	
	if  not frmMain:ShowDialog() then
	-- DisplayMessageBox("User canceled dialog")
		return false
	end
	
   tool = frmMain:GetTool("ToolChooseButton");
   	if create_ToolPath == true then
		if tool == nil then
			DisplayMessageBox("No tool selected!")
			ret_value = -1
			--return false
		else
			g_default_tool_name = tool.Name
		end   
	end
   g_tool = tool
   
	 Length  = frmMain:GetDoubleField("Lenght")
	 Height  = frmMain:GetDoubleField("Height")
	 start  = frmMain:GetDoubleField("Start")
	 ArcHeight  = frmMain:GetDoubleField("ArcHeight")
	 xy_origin_index = frmMain:GetRadioIndex("DrawingOrigin") 
	 OriginX  = frmMain:GetDoubleField("OriginX")
	 OriginY  = frmMain:GetDoubleField("OriginY")
	 cutting_Depth  = frmMain:GetDoubleField("CuttingDepth")
	 create_ToolPath     = frmMain:GetCheckBox("CheckToolPath")
	 origin_off = Point2D(0,0)
	 
	 

	 
	g_toolpath_name = frmMain:GetTextField("ToolpathName")
	if create_ToolPath == true then
		if string.len(g_toolpath_name) < 1 then
			DisplayMessageBox("A name must be entered for the toolpath")
			ret_value = -1
		end
	end 
	if Length < (start * 2) then
		ret_value = -1
		DisplayMessageBox("Length has to be greater than the double start setting " .. start * 2)
	end
	if ArcHeight > Height then
		ret_value = -1
		DisplayMessageBox("Arc Height has to be less than the height " .. Height)
	end
	if ArcHeight < .00000001 then
		ret_value = -1
		DisplayMessageBox("Arc Height has to be greater than zero " .. ArcHeight)
	end
	
	
	
	if ret_value == 1 then
    	retry_dialog = false  -- we got valid values
    end   
	--DisplayMessageBox("origin_off.x = " .. origin_off.x)
end 
-- while end

registry:SetDouble("Valance_Lenth",     Length)
registry:SetDouble("Valance_Height",     Height)
registry:SetDouble("Valance_start",     start)
registry:SetDouble("Valance_ArcHeight",     ArcHeight)
registry:SetInt("xy_origin_index",     xy_origin_index)
registry:SetDouble("OriginX",     OriginX)
registry:SetDouble("OriginY",     OriginY)
registry:SetDouble("CuttingDepth",     cutting_Depth) 
registry:SetString("DefaultToolName",  g_default_tool_name)
registry:SetString("ToolpathName",     g_toolpath_name)
registry:SetBool("create_ToolPath", create_ToolPath)
	
	if xy_origin_index == 1 then --"TLC"
		origin_off.x = OriginX 
		origin_off.y = OriginY - Height
   	elseif xy_origin_index == 2 then  --TRC 
		origin_off.x = OriginX - Length
		origin_off.y = OriginY  - Height
   	elseif xy_origin_index == 3 then --CENTRE 
		origin_off.x = OriginX - (Length / 2)
		origin_off.y = OriginY - (Height/ 2)
   	elseif xy_origin_index == 4 then --BLC  
		origin_off.x = OriginX
		origin_off.y = OriginY
   	elseif xy_origin_index == 5 then --BRC 
		origin_off.x = OriginX - Length
		origin_off.y = OriginY
  	 end
   
	Draw_Valance(doc,origin_off,Length,Height,start,ArcHeight)
	
	

    if create_ToolPath == true then
   	 local success = CreateProfileToolpath(g_toolpath_name, 0,cutting_Depth ,tool )
	end
	--CreateProfileToolpath("Test",tool)
	return true; 
end 


----------------------------------------------------------------------------------------------------
function Draw_Valance(doc,origin_off,Length,Height,start,ArcHeight)

local center = Point2D(0,0)

center = FindCenCircle(start + origin_off.x, origin_off.y, (Length / 2)+ origin_off.x, ArcHeight +  origin_off.y, Length - start + origin_off.x, origin_off.y)

	local C_group = ContourGroup(true)  
	local Contour = Contour(0.0)
 	local p1 = Point2D(origin_off.x,origin_off.y)
  	local p2 = Point2D(start + origin_off.x,origin_off.y)
   	local p3 = Point2D(Length - start + origin_off.x ,origin_off.y)
   	local p4 = Point2D(Length + origin_off.x,origin_off.y)
   	local p5 = Point2D(Length + origin_off.x,Height + origin_off.y)
	local p6 = Point2D(origin_off.x,Height + origin_off.y)
	
	Contour:AppendPoint(p1)
   	Contour:LineTo(p2)
   	Contour:ArcTo(p3,center, false)
	Contour:LineTo(p4)
	Contour:LineTo(p5)
	Contour:LineTo(p6)
	Contour:LineTo(p1)
	C_group:AddTail(Contour)
	
	--------------------------------------------------------
	local cad_object = CreateCadContour(Contour)
	local cur_layer = doc.LayerManager:GetActiveLayer()
	local layer = doc.LayerManager:GetLayerWithName("Valance")-- and add our object to it - on active sheet
	layer:AddObject(cad_object, true)
	layer.Colour = 255255255 
	layer.Visible = true 
	doc.LayerManager:SetActiveLayer(cur_layer)
	doc:Refresh2DView()	
	
	local selection = doc.Selection
	selection:Clear()
	selection:Add(cad_object, true, true)
	-----------------------------------------------------------------
	return true; 
end

function FindCenCircle(p1X, p1Y, p2X, p2Y, P3X, p3Y)
local X1
local Y1 
local dx1 
local dy1 
local X2 
local Y2 
local dx2 
local dy2 
local dx 
local dy 
local radius
local center = Point2D(0,0)
    -- Get the perpendicular bisector of (x1, y1) and (x2,
    -- y2).
    X1 = (p2X + p1X) / 2
    Y1 = (p2Y + p1Y) / 2
    dy1 = p2X - p1X
    dx1 = -(p2Y - p1Y)
	
    -- Get the perpendicular bisector of (x2, y2) and (x3,y3).
    X2 = (P3X + p2X) / 2
    Y2 = (p3Y + p2Y) / 2
    dy2 = P3X - p2X
    dx2 = -(p3Y - p2Y)
	
     -- See where the lines intersect.
    center.x = (Y1 * dx1 * dx2 + X2 * dx1 * dy2 - X1 * dy1 * dx2 - Y2 * dx1 * dx2)/ (dx1 * dy2 - dy1 * dx2)
    center.y = (center.x - X1) * dy1 / dx1 + Y1
    
	dx = center.x - p1X
    dy = center.y - p1Y
    radius = math.sqrt(dx * dx + dy * dy)

	return center;
end


function CreateProfileToolpath( Name , start_depth, cut_depth, tool)

	
   --tool.RateUnits = Tool.MM_SEC  -- MM_SEC, MM_MIN, METRES_MIN, INCHES_SEC, INCHES_MIN, FEET_MIN

   -- Create object used to set home position and safez gap above material surface
   local pos_data = ToolpathPosData()
   
   --pos_data:SetHomePosition(0, 0, 5.0)
   --pos_data.SafeZGap = 5.0
  
   -- Create  object used to pass profile options
   local profile_data = ProfileParameterData()
      -- start depth for toolpath
      profile_data.StartDepth = start_depth
      
      -- cut depth for toolpaht this is depth below start depth
      profile_data.CutDepth = cut_depth
      
      -- direction of cut - ProfileParameterData.CLIMB_DIRECTION or ProfileParameterData.CONVENTIONAL_DIRECTION
      profile_data.CutDirection = ProfileParameterData.CLIMB_DIRECTION
      
      -- side we machine on - ProfileParameterData.PROFILE_OUTSIDE,  ProfileParameterData.PROFILE_INSIDE or ProfileParameterData.PROFILE_ON
      profile_data.ProfileSide = ProfileParameterData.PROFILE_OUTSIDE
      
      -- Allowance to leave on when machining
      profile_data.Allowance = 0.0
   
      -- true to preserve start point positions, false to reorder start points to minimise toolpaht length   
      profile_data.KeepStartPoints = false
      
      -- true if want to create 'square' external corners on toolpath
      profile_data.CreateSquareCorners = false
      
      -- true to perform corner sharpening on internal corners (only with v-bits)
      profile_data.CornerSharpen = false
      
      -- true to use tabs (position of tabs must already have been defined on vectors)
      profile_data.UseTabs = false
      -- length for tabs if being used
      profile_data.TabLength = 5.0
      -- Thickness for tabs if being used
      profile_data.TabThickness = 1.0
      -- if true then create 3d tabs else 2d tabs
      profile_data.Use3dTabs  = true
      
      -- if true in Aspire, project toolpath onto composite model
      profile_data.ProjectToolpath = false
      
   -- Create object used to control ramping
   local ramping_data = RampingData()
      -- if true we do ramping into toolpath
      ramping_data.DoRamping = false
      -- type of ramping to perform RampingData.RAMP_LINEAR , RampingData.RAMP_ZIG_ZAG or RampingData.RAMP_SPIRAL
      ramping_data.RampType = RampingData.RAMP_ZIG_ZAG
      -- how ramp is contrained - either by angle or distance RampingData.CONSTRAIN_DISTANCE or RampingData.CONSTRAIN_ANGLE
      ramping_data.RampConstraint = RampingData.CONSTRAIN_ANGLE
      -- if we are constraining ramp by distance, distance to ramp over
      ramping_data.RampDistance = 100.0
      -- if we are contraining ramp by angle , angle to ramp in at (in degrees)
      ramping_data.RampAngle = 25.0
      -- if we are contraining ramp by angle, max distance to travel before 'zig zaging' if zig zaging
      ramping_data.RampMaxAngleDist = 15
      -- if true we restrict our ramping to lead in section of toolpath
      ramping_data.RampOnLeadIn = false
      
   
   -- Create object used to control lead in/out
   local lead_in_out_data = LeadInOutData()
      -- if true we create lead ins on profiles (not for profile on) 
      lead_in_out_data.DoLeadIn = false
      -- if true we create lead outs on profiles (not for profile on) 
      lead_in_out_data.DoLeadOut = false
      -- type of leads to create LeadInOutData.LINEAR_LEAD or LeadInOutData.CIRCULAR_LEAD
      lead_in_out_data.LeadType = LeadInOutData.CIRCULAR_LEAD
      -- length of lead to create
      lead_in_out_data.LeadLength = 10.0
      -- Angle for linear leads
      lead_in_out_data.LinearLeadAngle = 45
      -- Radius for circular arc leads
      lead_in_out_data.CirularLeadRadius = 5.0
      -- distance to 'overcut' (travel past start point) when profiling
      lead_in_out_data.OvercutDistance = 0.0
      
   -- if this is true we create 2d toolpaths previews in 2d view, if false we dont
   local create_2d_previews = true
   
   -- if this is true we will display errors and warning to the user
   local display_warnings = true
   
   local geometry_selector = GeometrySelector()
   -- Create our toolpath

   local toolpath_manager = ToolpathManager()
 
   local toolpath_id = toolpath_manager:CreateProfilingToolpath(
                                              Name,
                                              tool,
                                              profile_data,
                                              ramping_data,
                                              lead_in_out_data,
                                              pos_data,
											  geometry_selector,
                                              create_2d_previews,
                                              display_warnings
                                              )
   
   if toolpath_id  == nil  then
      DisplayMessageBox("Error creating toolpath")
      return false
   end                                                    

   return true  

end
