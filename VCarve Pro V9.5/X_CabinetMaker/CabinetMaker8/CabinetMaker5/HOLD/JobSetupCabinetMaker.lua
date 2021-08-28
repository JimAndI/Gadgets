-- VECTRIC LUA SCRIPT
require "strict"
--Global variables

g_millClearnaceOffset = 0.010  -- can be + or - number, used for dato over sizing
g_pinShelfClarence = 0.1800
g_materialThicknessBack = 0.5000
g_materialThickness = 0.7500

g_drawingUnits = 0
g_millingTool = 0.250 
g_millOffset = 0.050  -- used for dato clearing the edge of dato 
g_defaultToolName = "No Tool Selected" 
g_toolNameLabel = "No Tool Selected" 
g_programTitle = "Cabinet Creator"
g_programVersion = "Version 1.1"
g_codeBy = "Coded by Jim Anderson 2018"
g_toolSizeDia = 0.0
g_toolSizeRadus = 0.0 

g_datoDeep = g_materialThickness * 0.5000
g_pinRadus = 0.0970
g_cabinetLenght = 36.0000
g_cabinetHeight = 28.0000
g_cabinetDepth = 12.0000
g_cabinetBottomLenght = 48.0000
g_cabinetBottomHeight = 34.0000
g_cabinetBottomDepth = 22.0000
g_pinOuter = 0.7000
g_pinInter = 0.1600

g_pt1 = Point2D(2,2)

g_faceFrameSideGap = 0.2500
g_faceFrameSideWidth = 2.7500
g_faceFrameBottomWidth = 2.7500
g_faceFrameThickness = 0.7500
g_faceFrameTopWidth = 2.7500
g_faceFrameCenterWidth = 2.7500
g_faceFrameCenter = "Y"
g_faceFrameShelfOverlap = 0.0625
g_faceFrameBottomOverlap = 0.0625
g_faceFrameTopOverlap = 0.7500
g_holeSpacing = 2.0000
g_holeFirstRowSpacing = 4.0000
g_holeLastRowSpacing = 3.0000
g_boxHight = 0.0000
g_boxLength = 0.0000
g_backHight = 0.0000
g_backWidth = 0.0000
g_boxDepth = 0.0000
g_toeKickDepth = 4.0000
g_toeKickHight = 3.5000
g_toeKickBottomOffsetHight = 0.5000

-- ==============================================================================
function fileReader(pt, ang, dis)
    -- Opens a file in read
    file = io.open("test.lua", "r")

    -- sets the default input file as test.lua
    io.input(file)

    -- prints the first line of the file
    print(io.read())

    -- closes the open file
    io.close(file)
end

-- ==============================================================================
function fileWriter(datFile) -- "G:\Job.dat"
    local file = io.open(datFile, "w")
    -- write line of the file
        file:write("==============================================================================\n")
        file:write("==================== Job Data Fime for Cabinet Maker 2018 ====================\n")
        file:write("------------------------------------------------------------------------------\n")
        file:write("g_millClearnaceOffset            =              "..    g_millClearnaceOffset  .."        -- can be + or - number, used for dato over sizing \n")
        file:write("g_pinShelfClarence               =              "..    g_pinShelfClarence  .."        \n")
        file:write("g_materialThicknessBack          =              "..    g_materialThicknessBack  .."        \n")
        file:write("g_materialThickness              =              "..    g_materialThickness  .."        \n")
        file:write("g_drawingUnits                   =              "..    g_drawingUnits   .."        \n")
        file:write("g_millingTool                    =              "..    g_millingTool  .."        \n")
        file:write("g_millOffset                     =              "..    g_millOffset  .."        -- used for dato clearing the edge of dato \n")
        file:write("g_pinRadus                       =              "..    g_pinRadus  .."        \n")
        file:write("g_cabinetLenght                  =              "..    g_cabinetLenght  .."        \n")
        file:write("g_cabinetHeight                  =              "..    g_cabinetHeight  .."        \n")
        file:write("g_cabinetDepth                   =              "..    g_cabinetDepth  .."        \n")
        file:write("g_cabinetBottomLenght            =              "..    g_cabinetBottomLenght  .."        \n")
        file:write("g_cabinetBottomHeight            =              "..    g_cabinetBottomHeight  .."        \n")
        file:write("g_cabinetBottomDepth             =              "..    g_cabinetBottomDepth  .."        \n")
        file:write("g_pinOuter                       =              "..    g_pinOuter  .."        \n")
        file:write("g_pinInter                       =              "..    g_pinInter  .."        \n")
        file:write("g_faceFrameSideGap               =              "..    g_faceFrameSideGap  .."        \n")
        file:write("g_faceFrameSideWidth             =              "..    g_faceFrameSideWidth  .."        \n")
        file:write("g_faceFrameBottomWidth           =              "..    g_faceFrameBottomWidth  .."        \n")
        file:write("g_faceFrameThickness             =              "..    g_faceFrameThickness  .."        \n")
        file:write("g_faceFrameTopWidth              =              "..    g_faceFrameTopWidth  .."        \n")
        file:write("g_faceFrameCenterWidth           =              "..    g_faceFrameCenterWidth  .."        \n")
        file:write("g_faceFrameCenter                =              "..    g_faceFrameCenter        .."        \n")
        file:write("g_faceFrameShelfOverlap          =              "..    g_faceFrameShelfOverlap  .."        \n")
        file:write("g_faceFrameBottomOverlap         =              "..    g_faceFrameBottomOverlap  .."        \n")
        file:write("g_faceFrameTopOverlap            =              "..    g_faceFrameTopOverlap  .."        \n")
        file:write("g_holeSpacing                    =              "..    g_holeSpacing  .."        \n")
        file:write("g_holeFirstRowSpacing            =              "..    g_holeFirstRowSpacing  .."        \n")
        file:write("g_holeLastRowSpacing             =              "..    g_holeLastRowSpacing  .."        \n")
        file:write("g_toeKickDepth                   =              "..    g_toeKickDepth  .."        \n")
        file:write("g_toeKickHight                   =              "..    g_toeKickHight  .."        \n")
        file:write("g_toeKickBottomOffsetHight       =              "..    g_toeKickBottomOffsetHight  .."        \n")
    -- closes the open file
    file:close()
end
-- ==============================================================================
function LoadDialog(job, script_path)
    local registry = Registry("CabinetMaker")
	local html_path = "file:" .. script_path .. "\\JobSetupCabinetMaker.htm"
    local dialog = HTML_Dialog(false, html_path, 1000, 600,      g_programTitle)
    dialog:AddDoubleField("g_pinOuter",                         g_pinOuter)
    dialog:AddDoubleField("g_pinInter",                         g_pinInter)
    dialog:AddDoubleField("g_pinShelfClarence",                 g_pinShelfClarence)
    dialog:AddDoubleField("g_materialThicknessBack",            g_materialThicknessBack)
    dialog:AddDoubleField("g_faceFrameSideGap",                 g_faceFrameSideGap)
    dialog:AddDoubleField("g_faceFrameSideWidth",               g_faceFrameSideWidth)
    dialog:AddDoubleField("g_faceFrameBottomWidth",             g_faceFrameBottomWidth)
    dialog:AddDoubleField("g_millClearnaceOffset",              g_millClearnaceOffset)
    dialog:AddDoubleField("g_millOffset",                       g_millOffset)
    dialog:AddLabelField("g_programVersion",                    g_programVersion)
    dialog:AddLabelField("g_programTitle",                      g_programTitle)
    dialog:AddDoubleField("g_materialThickness",                g_materialThickness)
    dialog:AddDoubleField("g_pinRadus",                         g_pinRadus)
    dialog:AddDoubleField("g_cabinetLenght",                    g_cabinetLenght)
    dialog:AddDoubleField("g_cabinetHeight",                    g_cabinetHeight)
    dialog:AddDoubleField("g_cabinetDepth",                     g_cabinetDepth)
    dialog:AddDoubleField("g_cabinetBottomLenght",              g_cabinetBottomLenght)
    dialog:AddDoubleField("g_cabinetBottomHeight",              g_cabinetBottomHeight)
    dialog:AddDoubleField("g_cabinetBottomDepth",               g_cabinetBottomDepth)
    dialog:AddDoubleField("g_faceFrameThickness",               g_faceFrameThickness)
    dialog:AddDoubleField("g_faceFrameTopWidth",                g_faceFrameTopWidth)
    dialog:AddDoubleField("g_faceFrameCenterWidth",             g_faceFrameCenterWidth)
    dialog:AddDoubleField("g_faceFrameShelfOverlap",            g_faceFrameShelfOverlap)
    dialog:AddDoubleField("g_faceFrameBottomOverlap",           g_faceFrameBottomOverlap)
    dialog:AddDoubleField("g_faceFrameTopOverlap",              g_faceFrameTopOverlap)
    dialog:AddDoubleField("g_holeSpacing",                      g_holeSpacing)
    dialog:AddDoubleField("g_holeFirstRowSpacing",              g_holeFirstRowSpacing)
    dialog:AddDoubleField("g_holeLastRowSpacing",               g_holeLastRowSpacing)
    dialog:AddDoubleField("g_toeKickDepth",                     g_toeKickDepth)
    dialog:AddDoubleField("g_toeKickHight",                     g_toeKickHight)
    dialog:AddDoubleField("g_toeKickBottomOffsetHight",         g_toeKickBottomOffsetHight)
    dialog:AddTextField("g_programTitle",                       g_programTitle)
    dialog:AddTextField("g_programVersion",                     g_programVersion)
    dialog:AddTextField("g_faceFrameCenter",                    g_faceFrameCenter)
    dialog:AddLabelField("g_codeBy",                            g_codeBy)    
	if not dialog:ShowDialog() then
		return false
		-- Quit and return
	end
	-- Collect the Dialog values and update global variables
	g_pinOuter =                tonumber(dialog:GetDoubleField("g_pinOuter"))
    g_pinInter =                tonumber(dialog:GetDoubleField("g_pinInter"))
    g_pinShelfClarence =        tonumber(dialog:GetDoubleField("g_pinShelfClarence"))
    g_materialThicknessBack =   tonumber(dialog:GetDoubleField("g_materialThicknessBack"))
    g_faceFrameSideGap =        tonumber(dialog:GetDoubleField("g_faceFrameSideGap"))
    g_faceFrameSideWidth =      tonumber(dialog:GetDoubleField("g_faceFrameSideWidth"))
    g_faceFrameBottomWidth =    tonumber(dialog:GetDoubleField("g_faceFrameBottomWidth"))
    g_millClearnaceOffset =     tonumber(dialog:GetDoubleField("g_millClearnaceOffset"))
    g_millOffset =              tonumber(dialog:GetDoubleField("g_millOffset"))
    g_materialThickness =       tonumber(dialog:GetDoubleField("g_materialThickness"))
    g_pinRadus =                tonumber(dialog:GetDoubleField("g_pinRadus"))
    g_cabinetLenght =           tonumber(dialog:GetDoubleField("g_cabinetLenght"))
    g_cabinetHeight =           tonumber(dialog:GetDoubleField("g_cabinetHeight"))
    g_cabinetDepth =            tonumber(dialog:GetDoubleField("g_cabinetDepth"))
    g_cabinetBottomLenght =     tonumber(dialog:GetDoubleField("g_cabinetBottomLenght"))
    g_cabinetBottomHeight =     tonumber(dialog:GetDoubleField("g_cabinetBottomHeight"))
    g_cabinetBottomDepth =      tonumber(dialog:GetDoubleField("g_cabinetBottomDepth"))
    g_faceFrameThickness =      tonumber(dialog:GetDoubleField("g_faceFrameThickness"))
    g_faceFrameTopWidth =       tonumber(dialog:GetDoubleField("g_faceFrameTopWidth"))
    g_faceFrameCenterWidth =    tonumber(dialog:GetDoubleField("g_faceFrameCenterWidth"))
    g_faceFrameShelfOverlap =   tonumber(dialog:GetDoubleField("g_faceFrameShelfOverlap"))
    g_faceFrameBottomOverlap =  tonumber(dialog:GetDoubleField("g_faceFrameBottomOverlap"))
    g_faceFrameTopOverlap =     tonumber(dialog:GetDoubleField("g_faceFrameTopOverlap"))
    g_holeSpacing =             tonumber(dialog:GetDoubleField("g_holeSpacing"))
    g_holeFirstRowSpacing =     tonumber(dialog:GetDoubleField("g_holeFirstRowSpacing"))
    g_holeLastRowSpacing =      tonumber(dialog:GetDoubleField("g_holeLastRowSpacing"))
    g_toeKickDepth =            tonumber(dialog:GetDoubleField("g_toeKickDepth"))
    g_toeKickHight =            tonumber(dialog:GetDoubleField("g_toeKickHight"))
    g_toeKickBottomOffsetHight = tonumber(dialog:GetDoubleField("g_toeKickBottomOffsetHight"))
    g_programTitle =            dialog:GetTextField("g_programTitle")
    g_programVersion =          dialog:GetTextField("g_programVersion")
    g_faceFrameCenter =         dialog:GetTextField("g_faceFrameCenter")
    return true
end  -- function end

-- ______________________________________________________________________________


-- ==============================================================================

function main(script_path)
    -- create a layer with passed name if it doesnt already exist
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false;
    end
    
    	-- Keep looping the Dialog to get all user inputs
	repeat
		local ret_value = LoadDialog(job, script_path)
		if ret_value == false then
			return false
		end		
	until ret_value == true

    fileWriter("G://Job.dat") -- "G://Job.dat"
    return true 
end