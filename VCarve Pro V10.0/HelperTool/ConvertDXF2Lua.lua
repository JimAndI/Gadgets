-- VECTRIC LUA SCRIPT
-- Global Variables --
-- require("mobdebug").start()
require "strict"
-- local dxf = {}
local ReadFile = ""
local Writefile = ""
local AppName = "DXF to Gadget Code"
-- ===================================================]]
function SF(NumberValue)
  return NumberValue * 100
end
-- ===================================================]]
function REG_ReadRegistry()  --  Read from Registry values
    local RR = Registry("DXF2LUA")
    Writefile = RR:GetString("Writefile", "C:/Users/James/Documents/TestingLua/MyNewObjects.lua")
    ReadFile = RR:GetString("ReadFile", "C:/Users/James/Documents/TestingLua/POW.dxf")
end
-- ===================================================]]
function REG_UpdateRegistry() --  Write to Registry values
  local RW = Registry("DXF2LUA")
  local RegValue = RW:SetString("Writefile",  Writefile)
        RegValue = RW:SetString("ReadFile",  ReadFile)
end
-- ===================================================]]
function LengthOfFile(filename)                         -- Returns file line count
  --[[
     Counts the lines in a file
     Returns: number
    ]]
    local len = 0
    if FileExists(filename) then
      local file = io.open(filename)
      for _ in file:lines() do
        len = len + 1
      end
      file:close() ;
    end
   return len
 end
 -- ===================================================]]
function FileExists(name)
-- DisplayMessageBox(name)
    local f = io.open(name,"r")
    if f ~= nil then
      io.close(f)
      return true
    else
      return false
    end
end
-- ===================================================]]
function ReadDXF()
  local dat = ""
  local XValue = ""
  local YValue = ""
  local BulgeC = ""
  local BulgeN = ""
  local LayerName = ""
  local StartPoint = ""

  if FileExists(ReadFile) then
    FileHead(LayerName)
    local file = io.open(ReadFile, "r")
    while not(dat == "EOF") do  -- Get to the first PAPER_SPACE
      dat = AllTrim(file:read())
      if dat == "$PAPER_SPACE" then
        break
      end -- if end
    end -- while end
    while not(dat == "EOF")  do  -- Get to the first PAPER_SPACE
      dat = AllTrim(file:read())
      if dat == "ENDSEC" then
        break
      end -- if end
    end -- while end
    while not(dat == "8") do
      dat = AllTrim(file:read())
      if dat == "8" then
        LayerName = string.lower(AllTrim(file:read()))
        LayerName = LayerName:gsub("^%l", string.upper)
        break
      end -- if end
    end -- while end
    while not(dat == "EOF")  do
      while not(dat == "VERTEX") do  -- Get to the first VERTEX
        dat = AllTrim(file:read())
        if dat == "EOF" then
          break
        end
      end -- while end
      if dat == "EOF" then
          break
      end
      while not(dat == "8") do
        dat = AllTrim(file:read()) ;
        if dat == "8" then
          LayerName = string.lower(AllTrim(file:read()))
          LayerName = LayerName:gsub("^%l", string.upper)
          break
        end -- if end
      end -- while end
      while not(dat == "10") do  -- Get to the first X - Value
        dat = AllTrim(file:read())
      end -- while end
      XValue = pad(AllTrim(file:read()))
      while not(dat == "20") do  -- Get to the first X - Value
        dat = AllTrim(file:read())
      end -- while end
      YValue = pad(AllTrim(file:read()))
      while not(dat == "VERTEX") do  -- Get to the first X - Value
        dat = AllTrim(file:read())
        if dat == "42" then
          BulgeC = pad(AllTrim(file:read()))
        end -- if end
      end -- while end
      StartPoint =  "(" .. XValue .. " * Flag.HoistFlag) + 1.0 ,(" .. YValue .. " * Flag.HoistFlag) + 1.0"
      ContureHead(StartPoint, LayerName)
      -- =================
      while not(dat == "SEQEND") do  -- Get to the first Y - Value
        dat = AllTrim(file:read())
        BulgeN = ""
        while not(dat == "VERTEX") and not(dat == "SEQEND") do  -- Get to the first X - Value
          dat = AllTrim(file:read())
          if dat == "8" then
          LayerName = AllTrim(file:read())
          end -- if end
          if dat == "10" then
            XValue = pad(AllTrim(file:read()))
          end -- if end
          if dat == "20" then
            YValue = pad(AllTrim(file:read()))
          end -- if end
          if dat == "42" then
            BulgeN = pad(AllTrim(file:read()))
          end -- if end
        end
        -- =====
        if dat == "VERTEX" or dat == "SEQEND"  then
          if not(BulgeC == "") then
            AddVertex("line:ArcTo( Point2D((" .. XValue .. " * Flag.HoistFlag) + 1.0 ,(" .. YValue .. " * Flag.HoistFlag) + 1.0)," .. BulgeC .. ")")
            BulgeC = ""
          else
            AddVertex("line:LineTo(        (" .. XValue .. " * Flag.HoistFlag) + 1.0 ,(" .. YValue .. " * Flag.HoistFlag) + 1.0)")
            BulgeC = ""
          end
          if not(BulgeN == "") then
            BulgeC = BulgeN
          end
        end -- if end VERTEX
      end -- while end SEQEND
      if dat == "SEQEND" then
        ContureTail(StartPoint, BulgeC )
      end
      dat = AllTrim(file:read())
      if dat == "EOF" then
        break
      end
    end -- while end EOF
    file:close()-- closes the open read file
    FileTail()
  else
    MessageBox("Alert: No File found.")
  end
end -- function end
-- ===================================================]]
function InquiryFile()
  local myHtml=[[<html><head><title>Easy Tools</title><style type="text/css">html {overflow:hidden}.helpbutton {background-color:#E1E1E1;border:1px solid #999;border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF;padding:2px 12px;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none;font-size:12px;margin:4px 2px;color:#000}.helpbuttonx {background-color:##E1E1E1;border:1px solid #999;font-family:Arial, Helvetica, sans-serif;text-align:center;text-decoration:none;display:inline-block;font-size:12px;margin:40px 20px;cursor:pointer;color:#000;padding:2px 12px}.helpbutton:active {border-right-color:#FFF;border-bottom-color:#FFF;border-top-color:#000;border-left-color:#000}.helpbutton:hover {border-right-color:#000;border-bottom-color:#000;border-top-color:#FFF;border-left-color:#FFF}.LuaButton {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}.DirectoryPicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}.FilePicker {font-weight:bold;font-family:Arial, Helvetica, sans-serif;font-size:12px}.ToolPicker {font-weight:bold;text-align:center;font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;width:50px}.ToolNameLabel {font-family:Arial, Helvetica, sans-serif;font-weight:bolder;font-size:12px;text-align:left;color:#FF0}.FormButton {font-weight:bold;width:75px;font-family:Arial, Helvetica, sans-serif;font-size:12px;white-space:nowrap}.h1-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left;white-space:nowrap}.h2-l {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:left}.h1-r {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right;white-space:nowrap}.h1-rP {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right;white-space:nowrap;padding-right:4px;padding-left:4px}.h1-rPx {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:right;white-space:nowrap;padding-right:8px;padding-left:8px}.alert {font-family:Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold;color:#00F;text-align:center;white-space:nowrap}.h1-c {font-family:Arial, Helvetica, sans-serif;font-size:12px;text-align:center;white-space:nowrap}.header1-c {font-family:Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold;text-align:center;white-space:nowrap}.header2-c {font-family:Arial, Helvetica, sans-serif;font-size:14px;font-weight:bold;text-align:center;white-space:nowrap}body {overflow:hidden;font-family:Arial, Helvetica, sans-serif;font-size:12px}</style><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body bgcolor="#D6D6D6" text = "#000000"><table width = "498" border = "0" cellpadding = "0"> <tr> <th width="305" height="22" align = "left" ><strong class="header2-c">Output File</strong></th> <th align = "left" valign = "middle" > </th> </tr> <tr> <th align = "right" valign = "middle" id = "QuestionID"><input name = "WritePath" type = "text" id = "WritePath" size = "70" readonly bgcolor="#D6D6D6"></th> <th width = "56" align = "left" valign = "middle"><span style="width: 15%"> <input name = "FilePickerButton2" type = "button" class="FilePicker" id = "FilePickerButton2" value = "File"> </span></th> </tr> <tr> <th height="19" colspan="2" align = "right" valign = "middle" id = "QuestionID4"><hr></th> </tr> <tr> <th height="22" align = "left"><strong class="header2-c">Input DXF File</strong></th> <th align = "left" valign = "middle">&nbsp;</th> </tr> <tr> <th align = "right" valign = "middle" id = "QuestionID3"><input name = "ReadFile"type = "text" id = "ReadFile" size = "70" readonly bgcolor="#D6D6D6"></th> <th align = "left" valign = "middle"><span style="width: 15%"> <input name = "FilePickerButton" type = "button" class="FilePicker" id = "FilePickerButton" value = "File"> </span></th> </tr> <tr> <th colspan="2" align = "right" valign = "middle"><hr></th> </tr> <tr> <td colspan = "2" align = "center" valign = "middle"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"></td> <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> <td style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr> </table></td> </tr></table></body></html>]]

  local dialog = HTML_Dialog(true, myHtml, 528, 230, AppName)
  dialog:AddTextField("WritePath", Writefile) ;
  dialog:AddFilePicker(false, "FilePickerButton2", "WritePath", true)
  dialog:AddTextField("ReadFile", ReadFile)
  dialog:AddFilePicker(true, "FilePickerButton", "ReadFile", true)

	if dialog:ShowDialog() then
    ReadFile = dialog:GetTextField("ReadFile")
    Writefile = dialog:GetTextField("WritePath")
    return true
  else
    return false
	end
end  -- function end
-- ===================================================]]
function AllTrim(s)                                    -- Trims spaces off both ends of a string
      return s:match( "^%s*(.-)%s*$" )
  end -- function end
-- ===================================================]]
function pad(s)                                    -- Pads Zeros to the end of a string
    while string.len(string.sub(s, string.find(s, ".") + 1)) < 17 do
      s = s .. "0"
    end
    return s
  end -- function end
-- ===================================================]]
function main()
  REG_ReadRegistry()
  if InquiryFile() then
    ReadDXF()
    REG_UpdateRegistry()
    MessageBox("DXF to LUA: " .. ReadFile .. " \n Done")
  end
  return true
end
-- ===================================================]]
function FileHead(Layer) -- Starts New Object
  -- ContureHead(C:\Temp\, "23.3,12.5", "TestLayer")
    local file = io.open(Writefile, "w")
    file:write("local line = Contour(0.0) \n")
    file:write("local layer = job.LayerManager:GetLayerWithName("  ..  string.char(34) .. Layer .. string.char(34) .. ") \n")
    file:close()-- closes the open file
    return true
  end
-- ===================================================]]
function ContureHead(PT, Layer) -- Starts New Object
  -- ContureHead(C:\Temp\, "23.3,12.5", "TestLayer")
    local file = io.open(Writefile, "a")
    file:write("line = Contour(0.0) \n")
    file:write("layer = job.LayerManager:GetLayerWithName("  ..  string.char(34) .. Layer .. string.char(34) .. ") \n")
    file:write("line:AppendPoint(   ".. PT ..") \n")
    file:close()-- closes the open file
    return true
  end
-- ===================================================]]
function AddVertex(PT) -- Appends a Vertex to Object
  local file = io.open(Writefile, "a")
  file:write(PT .. " \n")
  file:close()-- closes the open file
  return true
end
-- ===================================================]]
function ContureClose(PT) -- Ends Object
  local file = io.open(Writefile, "a")
  file:write("line:LineTo(".. PT ..") \n")
  return true
end
  -- ===================================================]]
function ContureTail(PT, Bulge) -- Ends Object
  local file = io.open(Writefile, "a")
  if not(Bulge == "") then
    file:write("line:ArcTo( Point2D(" .. PT ..")," .. Bulge .. ")\n")
  else
    file:write("line:LineTo(".. PT ..") \n")
  end
  file:write("layer:AddObject(CreateCadContour(line), true) \n")
  file:close()-- closes the open file
  return true
end
    -- ===================================================]]
function FileTail() -- Ends Object
    local file = io.open(Writefile, "a")
    file:write("job:Refresh2DView() \n")
    file:close()-- closes the open file
    return true
  end
  -- ===================================================]]
