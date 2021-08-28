-- VECTRIC LUA SCRIPT
require "strict"
   IniFile = {} ; 
    Global = {} ; 
    Projects = {} ; -- List of Projects
    Cabinets = {} ; -- List of Cabinets
    Hardware = {} ; 
    Project = {} ; 
    WallCab = {} ; 
    WallDwg = {} ; 
    WallFaceFrame = {} ; 
    WallNailer = {} ; 
    WallShelf = {} ; 
    WallStretcher = {} ; 
    WallStyle = {} ; 
    Milling = {} ; 
 
 -- loaded Registry Values
    Global.ProgramTitle = "" ; 
    Global.ProgramName = "" ; 
    Global.ProgramVersion = "" ; 
    Global.CodeBy = "" ; 
    Global.Contact = "" ; 
    Global.Year = "" ; 
    Global.JobPath = "C:/Users/CNC/Documents/Testing" ; 
    Global.New  = false ; 
    Global.INI = "CabinetMaker.ini"
 
   
    WallDwg.DrawFaceFrame = true ; 
    WallDwg.DrawBack = true ; 
    WallDwg.DrawSideR = true ; 
    WallDwg.DrawSideL = true ; 
    WallDwg.DrawTop = true ; 
    WallDwg.DrawBottom = true ; 
    WallDwg.DrawCenter = true ; 
    WallDwg.DrawNotes = true ; 
    WallDwg.DrawShelf = true ; 
    WallDwg.Stretcher = true ; 
    WallDwg.DrawShelf = true ; 
    WallDwg.DrawShelf = true ; 

    Project.AddCabinetSettingsToProject = true
    Project.CabinetName="Default"
    Project.ProjectName="Default"
    Project.ProjectPath="C:/Test"
    Project.StartDate="Default"
    Project.ContactName="Default"
    Project.ContactEmail="Default"
    Project.PhoneNumber="Default"    
    
    Hardware.PinDiameter=0.194
    Hardware.HingHoleCenters=2.1
    Hardware.HingTopClearnace=0.75
    Hardware.HingBottomClearnace=0.75
    Hardware.HingCount=2
    Milling.BackDadoDepth=0.375
    Milling.BlindDadoSetback=1.375
    Milling.DadoToolDia=0.25
    Milling.HalfDadoWidth=0.375
    Milling.DadoClearnace=0.01
    Milling.PilotBitDia=0.125
    Milling.PocketToolDia=0.25
    Milling.ProfileToolDia=0.25
    Milling.RabbitClearing=0.05
    Milling.SideDadoDepth=0.375
    WallCab.CabDepth=12
    WallCab.CabHeight=28
    WallCab.CabWidth=36
    WallCab.NailerThickness=0.5
    WallCab.NailerWidth=1.5
    WallCab.Thickness=0.75
    WallCab.ThicknessBack=0.5
    WallDwg.DrawBackPanel=true
    WallDwg.DrawBackPanelOnNewSheet=true
    WallDwg.DrawBottomPanel=true
    WallDwg.DrawCenterPanel=true
    WallDwg.DrawFaceFrame=true
    WallDwg.DrawFaceFrameOnNewSheet=true
    WallDwg.DrawLeftSidePanel=true
    WallDwg.DrawRightSidePanel=true
    WallDwg.DrawShelfPanel=true
    WallDwg.DrawTopPanel=true
    WallDwg.ProvideCabinetNotesOnDrawing=true
    WallDwg.ProvideCabinetNotesOnNewSheet=true
    WallFaceFrame.TopRailWidth=1.75
    WallFaceFrame.BottomReveal=0.0625
    WallFaceFrame.BottomRailWidth=1.25
    WallFaceFrame.CenterStileWidth=1.75
    WallFaceFrame.Reveal=0.25
    WallFaceFrame.TopOverlap=0.75
    WallFaceFrame.Thickness=0.75
    WallFaceFrame.StileWidth=2.25
    WallNailer.Location="Inside"
    WallShelf.EndClarence=0.18
    WallShelf.FaceFrameReveal=0.0625
    WallShelf.FaceFrameThickness=0.75
    WallShelf.FaceFrameWidth=1.5
    WallShelf.FrontClearance=0.25
    WallShelf.HoleFirstRowSpacing=4
    WallShelf.HoleLastRowSpacing=3
    WallShelf.HoleSpacing=2
    WallShelf.PinHoleBack=1
    WallShelf.PinHoleFront=1.25
    WallShelf.ShelfMaterialThickness=0.75
    WallStretcher.Thickness=0.5
    WallStretcher.Width=1.75
    WallStyle.DadoStyle="Through"
    WallStyle.DadoType="Full"
    WallStyle.AddBackNailer=true
    WallStyle.AddCenterPanel=true
    WallStyle.AddShelfHoles=true
    WallStyle.AddHingPilotHoles=true
    WallStyle.AddShelfing=true
    WallStyle.BackDadoOrOverlap="Dado"
    WallStyle.FaceFrameOrStretchers="FaceFrame"
    WallStyle.WallShelfCount=2   
    
-- Calculated Values
    Hardware.PinRadus = Hardware.PinDiameter * 0.5 
    Milling.DadoToolRadus = Milling.DadoToolDia * 0.5 
    Milling.PocketToolRadus = Milling.PocketToolDia * 0.5 
    Milling.ProfileToolRadus = Milling.ProfileToolDia * 0.5 
     
    
    
--Global variables
    g_boxHight = 0.0000 ; g_boxLength = 0.0000 ; g_boxDepth = 0.0000 ; g_backHight = 0.0000 ; g_backWidth = 0.0000 ; g_PartGap = 0.5 ; g_pt1 = Point2D(1,1) ; g_pt2 = Point2D(20,1) ; g_pt3 = Point2D(40,1) ; g_pt4 = Point2D(14,1) ; g_pt5 = Point2D(14,34) ; g_pt6 = Point2D(30,1) ;     g_pt7 = Point2D(30,34) ; g_pt8 = Point2D(45,1) ; 
-- ===================================================
function NowName()
--[[
%a  abbreviated weekday name (e.g., Wed)
%A  full weekday name (e.g., Wednesday)
%b  abbreviated month name (e.g., Sep)
%B  full month name (e.g., September)
%c  date and time (e.g., 09/16/98 23:48:10)
%d  day of the month (16) [01-31]
%H  hour, using a 24-hour clock (23) [00-23]
%I  hour, using a 12-hour clock (11) [01-12]
%M  minute (48) [00-59]
%m  month (09) [01-12]
%p  either "am" or "pm" (pm)
%S  second (10) [00-61]
%w  weekday (3) [0-6 = Sunday-Saturday]
%x  date (e.g., 09/16/98)
%X  time (e.g., 23:48:10)
%Y  full year (1998)
%y  two-digit year (98) [00-99]
%%  the character `%´

       DeBug(9370,4, "NowName")]]
    return os.date("%d").. os.date("%H").. os.date("%M").. os.date("%S")
end
-- ===================================================
function file_exists(name)
   -- Debug(7521, 2, "file_exists - " .. name) 
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end
-- ===================================================
function DrawDado(pt, ort, lay, wide, len, rads, cle)
--[[
    pt = 2D point
    ort = ordination ("X" or "Y")
    lay = layer to be draw on
    wide = wide distance
    len = len distance
    rads = bit radius
    cle = milling clearance
    Call = DrawDado(Point2D(2,12),    0, "Jim", 0.75, 20, 0.125, 0.01)
    Call = DrawDado(Point2D(12,2),   90, "Jim", 0.75, 20, 0.125, 0.01)
    Call = DrawDado(Point2D(22,10), 180, "Jim", 0.75, 20, 0.125, 0.01)
    Call = DrawDado(Point2D(10,22), 270, "Jim", 0.75, 20, 0.125, 0.01)
]]
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    local cpt = pt ; local pt1 = pt ; local pt2 = pt ; local pt3 = pt ; local pt4 = pt
        
    if ort == 0 then
         cpt = Polar2D( pt, 180, rads)
         pt1 = Polar2D(cpt, 270, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,  90, (wide + cle))
         pt3 = Polar2D(pt2,   0, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1,   0, (len + (rads * 2.0)))
    elseif ort == 90 then
         cpt = Polar2D( pt, 270, rads)
         pt1 = Polar2D(cpt, 180, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,   0, (wide + cle))
         pt3 = Polar2D(pt2,  90, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1,  90, (len + (rads * 2.0)))
    elseif ort == 180 then
         cpt = Polar2D( pt,   0, rads)
         pt1 = Polar2D(cpt, 270, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,  90, (wide + cle))
         pt3 = Polar2D(pt2, 180, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1, 180, (len + (rads * 2.0)))
    else -- 270
         cpt = Polar2D( pt,  90, rads)
         pt1 = Polar2D(cpt, 180, ((wide * 0.5) + (cle * 0.5)))
         pt2 = Polar2D(pt1,  00, (wide + cle))
         pt3 = Polar2D(pt2, 270, (len + (rads * 2.0)))
         pt4 = Polar2D(pt1, 270, (len + (rads * 2.0)))
    end
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ; 
    line:LineTo(pt3) ; 
    line:LineTo(pt4) ; 
    line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function ProjectBackup()

    local filename = "C:/Users/Public/Documents/Vectric Files/Gadgets/CabinetBackup.cmd"
    local file = io.open(filename, "w")
    file:write("echo ================================================================================ \n") ;
    file:write("echo CabinetMaker \n") ;
    file:write("echo on \n") ;
    file:write("Z:\n") ;
    file:write("cd Vcarve \n") ;
    file:write("mkdir " .. NowName() .." \n") ;
    file:write("xcopy " .. string.char(34) .. "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5" .. string.char(34) .. " " .. string.char(34) .. "Z:\\Vcarve\\" .. NowName() ..  "\\" .. string.char(34) .. " /d/e/y \n") ; 
    file:write("echo ================================================================================= \n") ;
    file:write("pause \n") ;

    file:close()-- closes the open file 
    return true  

end
-- ===================================================
function Polar2D(pt, ang, dis)
  --     DeBug(9330, 9, "Polar2D")
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end-- function end
-- ===================================================
function DrawPocket(pt, l, x, y, d, c, a)
--function DrawPocket(pt, o, l, x, y, d, c, a)
--[[
    pt = 2D point
    o = ordination (0, 90, 180, 270)
    l = layer to be draw on
    x = distance
    y = distance
    d = bit diamitor
    c = milling clearance
    a = array of bones {"A", "B", "F", "E"} or { "I", "K"} or {"I", "E", "G"}
    call DrawPocket((2,2) "X" ,"Layer-jim" , 0.75, 20.0, 0.125, 0.01, a)
]]
   local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
        local pt1 = pt ; local pt2 = pt ; local pt3 = pt ; local pt4 = pt ;
        local r = d * 0.5
        pt2 = Polar2D(pt , 270, (y * 0.5)+(c * 0.5))
        pt3 = Polar2D(pt2, 180, (x * 0.5)+(c * 0.5))
        pt1 = pt3
        pt2 = Polar2D(pt1,   0, (x + c))
        pt3 = Polar2D(pt2,  90, (y + c))
        pt4 = Polar2D(pt1,  90, (y + c))
    local layer = job.LayerManager:GetLayerWithName(l) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    -- A ---------------------------------------  
    if CheckArray("A", a) then
    --     DisplayMessageBox("A - " .. tostring(CheckArray("A", a)))
        line:LineTo(Polar2D(pt1, 270, r)) --pta
        line:LineTo(Polar2D(Polar2D(pt1, 270, r), 0, d)) --ptb
        line:LineTo(Polar2D(pt1, 0, d)) --ptc
    end
    -- B ---------------------------------------
    if CheckArray("B", a) then    
        line:LineTo(Polar2D(pt2, 180, d)) --ptd
        line:LineTo(Polar2D(Polar2D(pt2, 180, d), 270, r)) --pte
        line:LineTo(Polar2D(pt2, 270, r)) --ptf
        line:LineTo(pt2) 
    else
        line:LineTo(pt2)         
    end
    -- C ---------------------------------------   
    if CheckArray("C", a) then
    --     DisplayMessageBox("C - " .. tostring(CheckArray("C", a)))
        line:LineTo(Polar2D(pt2, 0, r)) --ptg
        line:LineTo(Polar2D(Polar2D(pt2,  0, r), 90, d)) --pth
        line:LineTo(Polar2D(pt2,  90, d)) --pti
    end
    -- D ---------------------------------------   
    if CheckArray("D", a) then
    --     DisplayMessageBox("D - " .. tostring(CheckArray("D", a)))
        line:LineTo(Polar2D(pt3, 270, d)) --ptj
        line:LineTo(Polar2D(Polar2D(pt3, 270, d), 0, r)) --ptk
        line:LineTo(Polar2D(pt3,  0, r)) --ptl
        line:LineTo(pt3) 
    else
        line:LineTo(pt3)        
    end
    -- E ---------------------------------------   
   if CheckArray("E", a) then
   --  DisplayMessageBox("E - " .. tostring(CheckArray("E", a)))
        line:LineTo(Polar2D(pt3,  90, r)) --ptm
        line:LineTo(Polar2D(Polar2D(pt3,  90, r), 180, d)) --ptn
        line:LineTo(Polar2D(pt3, 180, d)) --pto
    end
    -- F ---------------------------------------   
    if CheckArray("F", a) then
     -- DisplayMessageBox("F - " .. tostring(CheckArray("F", a)))
        line:LineTo(Polar2D(pt4, 0, d)) --ptp
        line:LineTo(Polar2D(Polar2D(pt4, 0, d),  90, r)) --ptq
        line:LineTo(Polar2D(pt4, 90, r)) --ptp
        line:LineTo(pt4) 
    else
        line:LineTo(pt4)  
    end
    -- G ---------------------------------------   
    if CheckArray("G", a) then
     -- DisplayMessageBox("G - " .. tostring(CheckArray("G", a)))
        line:LineTo(Polar2D(pt4, 180, r)) --pts
        line:LineTo(Polar2D(Polar2D(pt4, 180, r), 270, d)) --ptt
        line:LineTo(Polar2D(pt4, 270, d)) --ptu
    end
    -- H ---------------------------------------   
    if CheckArray("H", a) then
     -- DisplayMessageBox("H - " .. tostring(CheckArray("H", a)))
        line:LineTo(Polar2D(pt1,  90, d)) --ptv
        line:LineTo(Polar2D(Polar2D(pt1,  90, d), 180, r)) --ptw
        line:LineTo(Polar2D(pt1,  180, r)) --ptv
    end
    line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function CheckArray(StrValue, DList)
       --DeBug(9120,1, CheckArray)
    local found = false
    for index, value in pairs(DList) do 
        --DeBug(9121,5, value)    
        if StrValue == value then
            found = true
            break
        end
    end 
    return found
end
-- ===================================================
function DrawRabbit(job, pt, ang, wide, long, lay, Clear)
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    local pt1 = pt ;     local pt2 = pt ;    local pt3 = pt ;    local pt4 = pt
    -- + Milling.RabbitClearing))
    if ang == 0 then
        pt1 = Polar2D(pt,   90, wide) ; 
        pt4 = Polar2D(pt1, 180, Clear) ; 
        pt1 = Polar2D(pt4, 270, wide + Clear) ; 
        pt2 = Polar2D(pt1,   0, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4,   0, long + (Clear * 2)) ; 
    elseif ang == 90 then
        pt1 = Polar2D( pt, 180, wide) ; 
        pt4 = Polar2D(pt1, 270, Clear) ; 
        pt1 = Polar2D(pt4,   0, wide + Clear) ; 
        pt2 = Polar2D(pt1,  90, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4,  90, long + (Clear * 2)) ; 
    elseif ang == 180 then
        pt1 = Polar2D( pt, 270, wide) ; 
        pt4 = Polar2D(pt1,   0, Clear) ; 
        pt1 = Polar2D(pt4,  90, wide + Clear) ; 
        pt2 = Polar2D(pt1, 180, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4, 180, long + (Clear * 2)) ; 
    else -- 270
        pt1 = Polar2D( pt,   0, wide) ; 
        pt4 = Polar2D(pt1,  90, Clear) ; 
        pt1 = Polar2D(pt4, 180, wide + Clear) ; 
        pt2 = Polar2D(pt1, 270, long + (Clear * 2)) ; 
        pt3 = Polar2D(pt4, 270, long + (Clear * 2)) ; 
    end
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ;  line:LineTo(pt3) ;  line:LineTo(pt4) ; line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function BuildBox(job, pt1, lay, xx, yy)
--    DeBug(9410,1, "BuildBox")
--[[
pt1 = 2Dpoint (2,2) 
lay = "Jim" 
xx = 22
yy = 24
]]
--[[ -- makes object in a Group
    local line = Contour(0.0) ;-- use default tolerance
    line:AppendPoint(pt1) ; 
    line:LineTo(Polar2D(pt1, 0, xx)) ; 
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) ; 
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) ; 
    line:LineTo(pt1) ; 
    return line
    ]]  
    
    -- makes closed rectangle object in a non-Group    
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    line:LineTo(Polar2D(pt1, 0, xx)) ; 
    line:LineTo(Polar2D(Polar2D(pt1, 0, xx), 90, yy)) ; 
    line:LineTo(Polar2D(Polar2D(Polar2D(pt1, 0, xx), 90, yy), 180, xx)) ;  
    line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
    
end-- function end
-- ===================================================
function all_trim(s) -- Trims spaces off both ends of a string
    return s:match( "^%s*(.-)%s*$" )
end
-- ===================================================
function G_IniUpdateFile(xPath, xGroup, xFile, xItem, xValue)
-- DeBug(9450, 1, "G_IniUpdateFile" )
-- G_IniUpdateFile("E:/Test", "Wall", "Bob", "Cabinet Depth", "22")
-- xItem = "Cabinet Depth" 
-- xValue = "22"
    local NfileName = xPath .. "/" .. xFile .. ".ini"
    local OfileName = xPath .. "/" .. xFile .. ".bak"
    os.remove(OfileName)
    DisplayMessageBox(NfileName)
    DisplayMessageBox(OfileName)
    os.rename(NfileName, OfileName) -- makes backup file
    local fileR = io.open(OfileName)
    local fileW = io.open(NfileName,  "w")
    local groups = false
    local txt = ""
	for Line in fileR:lines() do
		txt = Line
        if all_trim(Line) == "[" .. all_trim(xGroup) .. "]" then
            groups = true
        end
        if xItem ==  string.sub(Line, 1, string.len(xItem))  then
            if groups then
            txt = xItem .. "=" .. xValue 
             groups = false
            end
        end
        fileW:write(txt .. "\n") ;
	end
    os.remove(OfileName)
    --DeBug(9271,5, "File length = " .. tostring(len)) 
    fileR:close() ; 
    fileW:close() ; 
end
  -- ===================================================  
function NewSheet(job)
    local layer_manager = job.LayerManager
    -- get current sheet count - note sheet 0 the default sheet counts as one sheet
	local orig_num_sheets = layer_manager.NumberOfSheets
    DisplayMessageBox("NumberOfSheets" .. tostring(orig_num_sheets))
	 -- get current active sheet index
	local orig_active_sheet_index = layer_manager.ActiveSheetIndex
	-- set active sheet to last sheet
	local num_sheets = layer_manager.NumberOfSheets
    DisplayMessageBox("NumberOfSheets" .. tostring(orig_num_sheets))
    DisplayMessageBox(tostring(num_sheets))
	layer_manager.ActiveSheetIndex = 3
	job:Refresh2DView();
	-- Add a new sheet
    layer_manager:AddNewSheet()
    layer_manager.ActiveSheetIndex = 3
	job:Refresh2DView();
 end
 -- ===================================================
function NameStrip(str, var)-- convert string to the correct data type
-- Local  Words = NameStrip("KPSDFKSPSK - 34598923", "-")
    if "" == str then
          DisplayMessageBox("Error in string")
    else
        if string.find(str, var)  then
            local j = assert(string.find(str, var) - 1) 
            return all_trim(string.sub(str, 1, j)) ;
        else
            return str
        end
    end    
end
-- ======================================================
function BuildCircle(job, pt1, lay, crad)
    -- DeBug(9420,1, "BuildCircle")

    --[[ --BuildCircle
        pt1 = 2Dpoint (2,2) 
        lay = "Jim" 
        crad = 0.125
    ]]
--[[    -- makes Circle object in a Group
    local line = Contour(0.0)
    DeBug(9425,5, tostring(crad))
    line:AppendPoint(Polar2D(pt1, 0, crad))    
    line:ArcTo(Polar2D(pt1, 180, crad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, crad), 1.0)
    return line
    ]]
    
    -- makes Circle object in a non-Group    
    local layer = job.LayerManager:GetLayerWithName(lay) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(Polar2D(pt1, 0, crad)) ; 
   
    -- line:LineTo(Polar2D(pt1, 0, xx)) ; 
    line:ArcTo(Polar2D(pt1, 180, crad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, crad), 1.0)
    layer:AddObject(CreateCadContour(line), true)    
end -- function end 
-- =================================================== 
function main(script_path)
    -- create a layer with passed name if it doesn't already exist
 
    local lay = ""
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end

  --   G_IniUpdateFile("E:/Test", "Wall", "Bob", "Cabinet Depth", "34")
  --   G_IniUpdateFile("E:/Test", "Walls", "Bob", "Cabinet Depth", "44")
  --  os.rename("E:/test/BOB.BAT", "E:/test/BOB.BAK")
    
    --os.remove("E:/test/BOB.BAK")
--  NewSheet(job) 
--  local Words = "KPSDFKSPSK - 34598923"
--  DisplayMessageBox( Words )

--  Words = NameStrip("KPSDFKSPSK - 34598923", "-")
--  DisplayMessageBox( Words )
--[[
  DrawRabbit(job, pt, ang, wide, long, lay, clear)
    BuildBox(job, Point2D(3.75,3.75), "JIM", 0.5, 0.5)
    DrawRabbit(job, Point2D(4,4),   0, 0.75, 20, "JIM", 0.125)
    BuildBox(job, Point2D(3.75,3.75), "JIM", 0.5, 0.5)
    DrawRabbit(job, Point2D(6, 6),  90, 0.75, 20, "JIM", 0.125)
    BuildBox(job, Point2D(5.75,5.75), "JIM", 0.5, 0.5)
    DrawRabbit(job, Point2D(8,8), 180, 0.75, 20, "JIM", 0.125)
    BuildBox(job, Point2D(7.75,7.75), "JIM", 0.5, 0.5)
    DrawRabbit(job, Point2D(2,2), 270, 0.75, 20, "JIM", 0.125)
    BuildBox(job, Point2D(1.75,1.75), "JIM", 0.5, 0.5)
	job:Refresh2DView()  -- Regenerate the drawing display
 ProjectBackup() 
 ]]
 local name = "C:\\Temp\\Cabinet-Walxl.log"
-- DisplayMessageBox(tostring(file_exists(name)))
-- BuildBox(job, Point2D(2, 2), "Jim", 20, 20)
-- DrawDado(Point2D(2,12),    0, "Jim", 0.75, 20, 0.125, 0.01)
-- DrawDado(Point2D(12,2),   90, "Jim", 0.75, 20, 0.125, 0.01)
-- DrawDado(Point2D(22,10), 180, "Jim", 0.75, 20, 0.125, 0.01)
-- DrawDado(Point2D(10,22), 270, "Jim", 0.75, 20, 0.125, 0.01)
local aa = {"X" , "A" , "B" , "C"}
local bb = {"X" , "D" , "E"}
local cc = {"X" , "F" , "G"}
local dd = {"X" , "H" , "I"}
local jj = {"X" , "A" , "B" , "C" , "D" , "E","F" , "G" , "H" , "I"}

    BuildCircle(job, Point2D(4, 4), "JIM", 0.25)
    DrawPocket(Point2D(4, 4), "Layer-Jim" , 4.0, 0.75, 0.25, 0.01, jj)

    BuildCircle(job, Point2D(10, 10), "JIM", 0.25)
    DrawPocket(Point2D(10, 10), "Layer-Jim" ,  4.0, 0.75, 0.25, 0.01, bb)

    BuildCircle(job, Point2D(14, 14), "JIM", 0.25)
    DrawPocket(Point2D(14, 14), "Layer-Jim" ,  4.0, 0.75, 0.25, 0.01, cc)

    BuildCircle(job, Point2D(18, 18), "JIM", 0.25)
    DrawPocket(Point2D(18, 18), "Layer-Jim" ,  4.0, 0.75, 0.25, 0.01, dd)

 
    return true 
end  -- function end
-- ==============================================================================