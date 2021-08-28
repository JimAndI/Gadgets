-- VECTRIC LUA SCRIPT
require "strict"
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
]]
    return os.date("%A") .. ", " .. os.date("%B") .. " " .. os.date("%d") .. ", " .. os.date("%Y") .. " - " .. os.date("%I") .. ":" .. os.date("%M") .. ":" .. os.date("%S") .. " " .. os.date("%p")
	-- Sunday April 14, 2019 - 01:39 PM)
end

-- ===================================================
function main(script_path)
-- create a Toolpath to round a blank

   local SquareStockDimension = 4.2500
   local StockStartDimension = 0.0000
   local Stock = 0.0000
   local StockEndDimension = 36.0000
   local BitDiameter = 0.5000
   local FeedRate = 75.000
   local SpindleSpeed = 20000 
   local BitCutDepth = 0.2500
   local BitStepOver = 0.125
   local FinishedDiameter = 3.0000
   local FinishedRadus = 2.0
   local StepOver = BitDiameter * 0.2500
   local RowCount = 190
-- =============================================================
   local SquairToRoundDiameter = math.sqrt((SquareStockDimension * SquareStockDimension) + (SquareStockDimension * SquareStockDimension))
   local SquairToRoundRadus = SquairToRoundDiameter * 0.5
   local SquairToRoundRadusClear = SquairToRoundRadus + 0.5
   local PassCount = math.floor((SquairToRoundRadus - FinishedRadus) / BitCutDepth)
   BitCutDepth = (SquairToRoundRadus - FinishedRadus) / PassCount
   local RevolutionAngle = (StockEndDimension / StepOver) * 360
   local RevolutionAngle1 = 360
   local RevolutionAngle2 = RevolutionAngle + RevolutionAngle1 + 360
   local RevolutionAngle3 = RevolutionAngle2 + 360
   local RevolutionAngle4 = 0.0
   local RevolutionAngle5 = RevolutionAngle - 360
   local RevolutionAngle6 = RevolutionAngle5 - 360

-- =============================================================

    local filename = "C:\\Users\\CNC\\Documents\\_Toolpaths\\BlankRounding.txt"
    --local filename = "C:\\Users\\JimAnderson\\Documents\\_Toolpaths\\BlankRounding.txt"
    local file = io.open(filename, "w")
    file:write("( Blank Rounding Toolpath )\n") ;
	file:write("( ------------------------------------------------ ) \n")
    file:write("( File created: " .. NowName() .. ") \n") ; -- ( File created: Sunday April 14 2019 - 01:39 PM)
    file:write("( for Mach3 from Vectric ) \n") ;
    file:write("( Material Size) \n") ;
	file:write("( X Length = "  .. StockEndDimension .. ", Z  = " .. SquairToRoundRadus .. ") \n")
	file:write("( Stock Diameter = " .. SquairToRoundDiameter .. " Inches) \n")
	file:write("( Y Values are wrapped around the X axis ) \n")
	file:write("( Y Values are output as A ) \n")
	file:write("( ------------------------------------------------ ) \n")
	file:write("( Toolpaths used in this file: ) \n")
	file:write("( Rounding Toolpath ) \n")
	file:write("( Tools used in this file: ) \n")
	file:write("( 11 = End Mill {" .. BitDiameter .." inch} Up ) \n")
	file:write("( 11 = End Mill Cut Depth = " .. BitCutDepth .." inch \n")
	file:write("( ================================================ ) \n")
	file:write("N100 G00G20G17G90G40G49G80 \n")
	file:write("N110 G70G91.1 \n")
	file:write("N120 T11M06 \n")
	file:write("N130 G00G43Z3.0455H11 \n")
	file:write("N140 S" .. SpindleSpeed .. "M03 \n")
	file:write("N150( Toolpath: Blank Rounding Toolpath ) \n")
	file:write("N160( --------------------------------- ) \n")
	file:write("N170 G94 \n")
--	file:write("N180 A0.0000 X0.0000 Z" .. SquairToRoundRadusClear .. " F" .. FeedRate .." \n")
	file:write("N180 G00 X0.0000 A0.0000 Z" .. SquairToRoundRadusClear .. "  \n")
    
	local end_index = PassCount
	local CutRadus = SquairToRoundRadus - BitCutDepth
	for i = 1, end_index do
	
		CutRadus = CutRadus - BitCutDepth
	
	if (Stock == StockStartDimension) then
	
	-- Ring the end
        file:write("N" .. RowCount .. " G01 Z" .. CutRadus .. " F" .. (FeedRate * 0.75) .." \n")
		RowCount = RowCount + 10		
		
		file:write("N" .. RowCount .. " G01 X" .. StockStartDimension .. " A" .. RevolutionAngle1 .. " Z" .. CutRadus .. " F" .. (FeedRate * 0.75) .." \n")
		RowCount = RowCount + 10
		
	-- Round to end
		file:write("N" .. RowCount .. " G01 X" .. StockEndDimension .. " A" .. RevolutionAngle2 .. " Z" .. CutRadus .. " F" .. FeedRate .." \n")
		RowCount = RowCount + 10
 
	-- Round the end
		file:write("N" .. RowCount .. " G01 X" .. StockEndDimension .. " A" .. RevolutionAngle3 .. " Z" .. CutRadus .. " F" .. FeedRate .." \n")
		RowCount = RowCount + 10
		Stock = StockEndDimension
	else
 -- Ring the end
		file:write("N" .. RowCount .. " G01 Z" .. CutRadus .. " F" .. (FeedRate * 0.75) .." \n")
		RowCount = RowCount + 10		
		
		file:write("N" .. RowCount .. " G01 X" .. StockEndDimension .. " A" .. RevolutionAngle2 .. " Z" .. CutRadus .. " F" .. (FeedRate * 0.75) .." \n")
		RowCount = RowCount + 10
		
	-- Round to end
		file:write("N" .. RowCount .. " G01 X" .. StockStartDimension .. " A" .. RevolutionAngle1 .. " Z" .. CutRadus .. " F" .. FeedRate .." \n")
		RowCount = RowCount + 10


	-- Round the end
		file:write("N" .. RowCount .. " G01 X" .. StockStartDimension .. " A" .. RevolutionAngle4 .. " Z" .. CutRadus .. " F" .. FeedRate .." \n")
		RowCount = RowCount + 10
		Stock = StockStartDimension
	end

       

    end

	file:write("N" .. RowCount .. " G01 Z" .. SquairToRoundRadusClear .. "  \n")
	RowCount = RowCount + 10
	file:write("N" .. RowCount .. " G01 A0.0000 X0.0000 \n")
	RowCount = RowCount + 10
	file:write("N" .. RowCount .. " M09 \n")
	RowCount = RowCount + 10
	file:write("N" .. RowCount .. " M30 \n")
	file:write("% \n")

    return true 
end  -- function end
-- ===================================================