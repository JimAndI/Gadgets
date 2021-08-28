-- VECTRIC LUA SCRIPT
-- Copyright 2013 Vectric Ltd.

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

-- global variables


g_inches_text  = " inches"
g_mm_text      = " mm"
-- number of decimal places for inch / mm values
g_inch_dp = 4
g_mm_dp   = 3

g_job_in_mm  = false
g_job_units  = g_inches_text
g_job_num_dp = g_inch_dp
g_feed_dp = 2

g_post_table = {}

-- Html used at top of page

g_HtmlHeader = [[
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Toolpath Report</title>
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

.LuaButton {
	font-weight: bold;
	width: 100%;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	text-align: left;
}
.h1 {
	font-size: 14px;
	font-weight: bold;
}
.h2 {
	font-size: 10px;
	font-weight: bold;
}

</style>
</head>

<body>

<p><h2><span id="ToolpathParametersTitle">Post Processor Parameters</span></h2></p>
]]

g_Html_PostTableHeader = [[
<table width='100%'  border='0' >
]]


g_HtmlSaveToolpaths = [[
<br>
<b>Change toolpath order</b>
<br>
<table border="0">
	<tr>
		<td >&nbsp;&nbsp;&nbsp;<input id="SaveToolpathsButton" class="LuaButton" name="SaveToolpathsButton" type="button" value="Save Toolpaths"></td>
	</tr>

</table>	
]]


-- Html at bottom of page
g_HtmlFooter = [[
<hr>
<table border="0" width="100%">
	<tr>
		<td style="width: 40%">&nbsp;</td>
		<td style="width: 20%">
		<input id="ButtonOK" class="FormButton" name="ButtonOK" type="button" value="Close"></td>
		<td style="width: 40%">&nbsp;</td>
	</tr>
</table>

</body>
</html>

]]


--[[  --- CreatePostInfoRow --------------------------------------------------  
|
|   Create a HTML header row for information about post
|
]]

function CreatePostHeaderRow()

	local html_row = "   <tr>\n"

	html_row = html_row .. "      <td> <b>No</b> </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortNameButton'       class='LuaButton' type='button' value= 'Post Name'     > </td>\n"
    html_row = html_row .. "      <td> <input id= 'SortFileButton'       class='LuaButton' type='button' value= 'File Name'     > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortExtButton'        class='LuaButton' type='button' value= 'Ext'           > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortToolChangeButton' class='LuaButton' type='button' value= 'Tool Change'   > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortArcsButton'       class='LuaButton' type='button' value= 'Arcs'          > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortWrapXButton'      class='LuaButton' type='button' value= 'Wrap X'        > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortWrapYButton'      class='LuaButton' type='button' value= 'Wrap Y'        > </td>\n"
    html_row = html_row .. "      <td> <input id= 'SortDO_Button'        class='LuaButton' type='button' value= 'Direct Output' > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortRunExeButton'     class='LuaButton' type='button' value= 'Run Exe After' > </td>\n"
    html_row = html_row .. "      <td> <input id= 'SortDO_ParamsButton'  class='LuaButton' type='button' value= 'D.O Params'    > </td>\n"
	html_row = html_row .. "      <td> <input id= 'SortExeParamsButton'  class='LuaButton' type='button' value= 'Exe Params'    > </td>\n"
	
	html_row = html_row .. "   </tr>\n"

	return html_row
end

--[[ --- BoolToYesNo -------------------------------------------------------
|
| Return Yes / No for a bool value
]]

function BoolToYesNo(value)

  if value then
     return "Yes"
  else
     return "No"
  end
  
end

--[[  --- CreatePostInfoRow --------------------------------------------------  
|
|   Create a HTML row for information about posts. We give each <td> separate
|   id so we can update fields (via Dialog:SetInnerHtml) if we change values
|
|  Parameters:
|     post               - post to get properties for
|     row_index          - index of row in table
|
]]

function CreatePostInfoRow(post, row_index)

	local html_row = "   <tr id='PostParameterRow_" .. row_index .. "'>\n"
	
	html_row = html_row .. "      <td id='row_" .. row_index .. "_PostIndex'>"    .. row_index .. "</td>\n"
	html_row = html_row .. "      <td id='row_" .. row_index .. "_PostName'>"     .. post.Name .. "</td>\n"
	html_row = html_row .. "      <td id='row_" .. row_index .. "_FileName'>"     .. post.FileName   .. "</td>\n"
	html_row = html_row .. "      <td id='row_" .. row_index .. "_Extension'>"    .. "." .. post.Extension   .. "</td>\n"
	html_row = html_row .. "      <td id='row_" .. row_index .. "_ToolChange'>"   .. BoolToYesNo(post.SupportsToolchange)   .. "</td>\n"
    html_row = html_row .. "      <td id='row_" .. row_index .. "_Arcs'>"         .. BoolToYesNo(post.SupportsArcs)   .. "</td>\n"
    html_row = html_row .. "      <td id='row_" .. row_index .. "_WrapX'>"        .. BoolToYesNo(post.Wrap_X_Axis)   .. "</td>\n"
    html_row = html_row .. "      <td id='row_" .. row_index .. "_WrapY'>"        .. BoolToYesNo(post.Wrap_Y_Axis)   .. "</td>\n"
    html_row = html_row .. "      <td id='row_" .. row_index .. "_DirectOutput'>" .. BoolToYesNo(post.SupportsDirectOutput)   .. "</td>\n"
    html_row = html_row .. "      <td id='row_" .. row_index .. "_RunExeAfter'>"  .. BoolToYesNo(post.RunExeAfter)   .. "</td>\n"
	html_row = html_row .. "      <td id='row_" .. row_index .. "_DO_Params'>"    .. post.DirectOutputParams .. "</td>\n"
	html_row = html_row .. "      <td id='row_" .. row_index .. "_Exe_Params'>"   .. post.RunExeAfterParams .. "</td>\n"

	html_row = html_row .. "   </tr>\n"

	return html_row

end

--[[  --- UpdatePostInfoRow --------------------------------------------------  
|
|   Update a HTML rowwith information about posts We give each <td> separate
|   id so we can update fields (via Dialog:SetInnerHtml) if we change values
|
|  Parameters:
|     post               - post to get properties for
|     row_index          - index of row in table
|
]]

function UpdatePostInfoRow(post, row_index, dialog)

	dialog:SetInnerHtml("row_" .. row_index .. "_PostIndex"   ,  tostring(row_index))
	dialog:SetInnerHtml("row_" .. row_index .. "_PostName"    ,  post.Name)
	dialog:SetInnerHtml("row_" .. row_index .. "_FileName"    ,  post.FileName)
	dialog:SetInnerHtml("row_" .. row_index .. "_Extension"   , "." .. post.Extension)
	dialog:SetInnerHtml("row_" .. row_index .. "_ToolChange"  ,  BoolToYesNo(post.SupportsToolchange))
    dialog:SetInnerHtml("row_" .. row_index .. "_Arcs"        ,  BoolToYesNo(post.SupportsArcs))
    dialog:SetInnerHtml("row_" .. row_index .. "_WrapX"       ,  BoolToYesNo(post.Wrap_X_Axis))
    dialog:SetInnerHtml("row_" .. row_index .. "_WrapY"       ,  BoolToYesNo(post.Wrap_Y_Axis))
    dialog:SetInnerHtml("row_" .. row_index .. "_DirectOutput",  BoolToYesNo(post.SupportsDirectOutput))
    dialog:SetInnerHtml("row_" .. row_index .. "_RunExeAfter" ,  BoolToYesNo(post.RunExeAfter))
	dialog:SetInnerHtml("row_" .. row_index .. "_DO_Params"   ,  post.DirectOutputParams)
	dialog:SetInnerHtml("row_" .. row_index .. "_Exe_Params"  ,  post.RunExeAfterParams)


end

--[[  --- CreatePostTable --------------------------------------------------  
|
|   Create a HTML table for information about post processors
|
|  Parameters:
|     toolpath_saver   - ToolpathSaver object 
|    
]]

function CreatePostTable(toolpath_saver)

	local html_table = g_Html_PostTableHeader

    html_table = html_table .. CreatePostHeaderRow()
	
	local num_posts = toolpath_saver:GetNumPosts()
	local post_index = 0
	
	while post_index < num_posts do
        local post = toolpath_saver:GetPostAtIndex(post_index)
		table.insert(g_post_table, post)
	    html_table = html_table .. CreatePostInfoRow(post, post_index + 1)
		post_index = post_index + 1
    end
	
	html_table = html_table .. "</table>\n"
	
	return html_table;
end

--[[  --- UpdatePostTable --------------------------------------------------  
|
|   Update a HTML table for information about posts
|
|  Parameters:
|     dialog              - dialog holding an existing table
|     
|    
]]
function UpdatePostTable(dialog)

    local index = 1;

	for i,post in ipairs(g_post_table) 
	   do UpdatePostInfoRow(post, index, dialog)
       index = index + 1	   
	end
	
   return true

end

--[[ --- CompareName-----------------------------------
]]
function CompareName(a,b)
	return a.Name < b.Name
end

--[[ --- CompareFile-----------------------------------
]]
function CompareFile(a,b)
	return a.FileName < b.FileName
end

--[[ --- CompareExtension -------------------------------------
]]
function CompareExtension(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.Extension == b.Extension then
	   return a.Name < b.Name
	end
	
	return a.Extension < b.Extension

end

--[[ --- CompareToolChange -------------------------------------
]]
function CompareToolChange(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.SupportsToolchange == b.SupportsToolchange then
	   return a.Name < b.Name
	end
	return a.SupportsToolchange
end

--[[ --- CompareArcs -------------------------------------
]]
function CompareArcs(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.SupportsArcs == b.SupportsArcs then
	   return a.Name < b.Name
	end
	return a.SupportsArcs
end


--[[ --- CompareWrapX -------------------------------------
]]
function CompareWrapX(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.Wrap_X_Axis == b.Wrap_X_Axis then
	   return a.Name < b.Name
	end
	return a.Wrap_X_Axis
end

--[[ --- CompareWrapY -------------------------------------
]]
function CompareWrapY(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.Wrap_Y_Axis == b.Wrap_Y_Axis then
	   return a.Name < b.Name
	end
	return a.Wrap_Y_Axis
end

--[[ --- CompareDO -------------------------------------
]]
function CompareDO(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.SupportsDirectOutput == b.SupportsDirectOutput then
	   return a.Name < b.Name
	end
	return a.SupportsDirectOutput
end

--[[ --- CompareRunExe -------------------------------------
]]
function CompareRunExe(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.RunExeAfter == b.RunExeAfter then
	   return a.Name < b.Name
	end
	return a.RunExeAfter
end

--[[ --- CompareDO_Params -------------------------------------
]]
function CompareDO_Params(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.DirectOutputParams == b.DirectOutputParams then
	   return a.Name < b.Name
	end
	return a.DirectOutputParams > b.DirectOutputParams
end

--[[ --- CompareExeParams -------------------------------------
]]
function CompareExeParams(a,b)
	-- if the toolpaths have the same main type sort based on name
	if a.RunExeAfterParams == b.RunExeAfterParams then
	   return a.Name < b.Name
	end
	return a.RunExeAfterParams > b.RunExeAfterParams
end




--[[ --- OnLuaButton_SortNameButton --------------------------
]]
function OnLuaButton_SortNameButton(dialog)
    table.sort(g_post_table, CompareName)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortFileButton --------------------------
]]
function OnLuaButton_SortFileButton(dialog)
    table.sort(g_post_table, CompareFile)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortExtButton --------------------------
]]
function OnLuaButton_SortExtButton(dialog)
    table.sort(g_post_table, CompareExtension)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortToolChangeButton --------------------------
]]
function OnLuaButton_SortToolChangeButton(dialog)
    table.sort(g_post_table, CompareToolChange)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortArcsButton --------------------------
]]
function OnLuaButton_SortArcsButton(dialog)
    table.sort(g_post_table, CompareArcs)
    UpdatePostTable(dialog)
	return true
end


--[[ --- OnLuaButton_SortWrapXButton --------------------------
]]
function OnLuaButton_SortWrapXButton(dialog)
    table.sort(g_post_table, CompareWrapX)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortWrapYButton --------------------------
]]
function OnLuaButton_SortWrapYButton(dialog)
    table.sort(g_post_table, CompareWrapY)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortDO_Button --------------------------
]]
function OnLuaButton_SortDO_Button(dialog)
    table.sort(g_post_table, CompareDO)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortRunExeButton --------------------------
]]
function OnLuaButton_SortRunExeButton(dialog)
    table.sort(g_post_table, CompareRunExe)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortDO_ParamsButton --------------------------
]]
function OnLuaButton_SortDO_ParamsButton(dialog)
    table.sort(g_post_table, CompareDO_Params)
    UpdatePostTable(dialog)
	return true
end

--[[ --- OnLuaButton_SortExeParamsButton --------------------------
]]
function OnLuaButton_SortExeParamsButton(dialog)
    table.sort(g_post_table, CompareExeParams)
    UpdatePostTable(dialog)
	return true
end

--[[  ----------------------- main -----------------------------
|
|  Entry point for script
|
]]

function main()

    -- Create object used to access post processors (and save toolpaths)    
	local toolpath_saver = ToolpathSaver()

	-- create html for post processors
	
	-- Standard header ...
	local html = g_HtmlHeader;
	
	-- table with data on posts
	html = html .. CreatePostTable(toolpath_saver)
	
	-- add on standard footer
	html = html .. g_HtmlFooter

    -- Create dialog for html
	local dialog = HTML_Dialog(true, html, 1000, 675, "Post Processor Properties")
	
	-- display dialog  - we will receive call backs when user presses buttons etc
	dialog:ShowDialog() 
	

    return true
end    