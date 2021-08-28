-- VECTRIC LUA SCRIPT
require "strict"
--Global variables

ProjectQuestion = {}
--[[
ProjectQuestion.ProgramCodeBy="James Anderson"
ProjectQuestion.ProgramContact="James.L.Anderson@outlook.com"
ProjectQuestion.ProgramName="Cabinet Maker"
ProjectQuestion.ProgramVersion="Version 2.4"
ProjectQuestion.ProgramYear="2019"
ProjectQuestion.ProjectCabinetBase="Default"  
ProjectQuestion.ProjectCabinetWall="Default"   
ProjectQuestion.ProjectName="Default"
ProjectQuestion.ProjectPath="C:/test"
]]
    x_DebugPlay = "C:\\Users\\Public\\Documents\\Vectric Files\\Gadgets\\VCarve Pro V9.5\\CabinetMaker\\Projects\\CabinetMaker.log"
   
    x_DebugMsg = 99 -- (0 = off), (1,2,3,4,5,6,7,8,9 = will show that value and any lesser), (-1,-2,-3,-4... will only show that number value)
    x_DebugLog = true
    x_DebugClear = true
    x_ShowMe = true   
    x_LogPath = ""
-- ===================================================
-- <>================ Debug Tools ==================<>
-- <>================================================<>
    function DeBug(id, lev, txt) -- Debugger tool
        local NowX = "[" .. os.date("%b %d, %Y") .. " - " ..os.date("%H") .. ":" .. os.date("%m") ..":".. os.date("%S") .. "]"
        if x_DebugClear then 
            local file = io.open(x_DebugPath, "w") ; 
            file:write("=============================================\n") ; 
            file:write("=========== " .. os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p") .. " ============\n") ; 
            file:write("=============================================\n") ; 
            file:close() -- closes the open file 
            x_DebugClear = false
        end
        -- return true
        if x_DebugLog then
            local file = io.open(x_DebugPath, "a") ; 
                if x_DebugMsg >= 1 then   
                    if lev <= x_DebugMsg then   
                       --DisplayMessageBox(tostring(txt))
                       file:write( NowX .." [" .. tostring(lev) .. "] [" .. tostring(id) .. "] ".. tostring(txt) .. "\n") ;
                    end
                else 
                    if lev == math.abs(g_DebugMsg) then   
                        --DisplayMessageBox(tostring(txt))
                         file:write( NowX .." [" .. tostring(id) .. "]  " .. tostring(txt) .. "\n") ;
                    end
                end
            file:close()-- closes the open file 
        else
            if x_DebugMsg >= -1 then   
                if lev <= x_DebugMsg then   
                   DisplayMessageBox(tostring(id) .. "-" .. tostring(txt))
                end
            else 
                if lev == math.abs(g_DebugMsg) then   
                    DisplayMessageBox(tostring(id) .. "-" .. tostring(txt))
                end
            end
        end
    end
-- ===================================================

-- ===================================================
function UpdateRegistryStandardCabinetList()-- Write to Registry values
       DeBug(9170,1, "UpdateRegistryStandardCabinetList")
    local RegistryWrite = Registry("CabinetMaker") ;  
    local RegValue      = RegistryWrite:SetString("ProjectCabinetBase", ProjectQuestion.ProjectCabinetBase) ;    
          RegValue      = RegistryWrite:SetString("ProjectCabinetWall", ProjectQuestion.ProjectCabinetWall) ;     
          RegValue      = RegistryWrite:SetString("ProjectName",        string.upper(ProjectQuestion.ProjectName)) ;
          RegValue      = RegistryWrite:SetString("ProjectPath",        ProjectQuestion.ProjectPath) ;
end
-- ===================================================
--[[ function WriteRegistryStandardCabinetList()-- Write to Registry values
    local RegistryWrite = Registry("CabinetMaker") ;  
    local RegValue  = RegistryWrite:SetString("ProgramCodeBy",      ProjectQuestion.ProgramCodeBy) ; 
    RegValue        = RegistryWrite:SetString("ProgramContact",     ProjectQuestion.ProgramContact) ; 
    RegValue        = RegistryWrite:SetString("ProgramName",        ProjectQuestion.ProgramName) ;
    RegValue        = RegistryWrite:SetString("ProgramVersion",     ProjectQuestion.ProgramVersion) ; 
    RegValue        = RegistryWrite:SetString("ProgramYear",        ProjectQuestion.ProgramYear) ; 
    RegValue        = RegistryWrite:SetString("ProjectCabinetBase", ProjectQuestion.ProjectCabinetBase) ;    
    RegValue        = RegistryWrite:SetString("ProjectCabinetWall", ProjectQuestion.ProjectCabinetWall) ;     
    RegValue        = RegistryWrite:SetString("ProjectName",        ProjectQuestion.ProjectName) ;
    RegValue        = RegistryWrite:SetString("ProjectName",        ProjectQuestion.ProjectPath) ;
end
]]
-- ==================================================== 
function ReadRegistryStandardCabinetList()-- Read from Registry values
       DeBug(9180,1, "ReadRegistryStandardCabinetList")
    local RegistryRead = Registry("CabinetMaker") ; 
    ProjectQuestion.ProgramCodeBy       = RegistryRead:GetString("ProgramCodeBy",       ProjectQuestion.CodeBy) ; 
    ProjectQuestion.ProgramContact      = RegistryRead:GetString("ProgramContact",      ProjectQuestion.Contact) ; 
    ProjectQuestion.ProgramName         = RegistryRead:GetString("ProgramName",         ProjectQuestion.ProgramName) ;
    ProjectQuestion.ProgramVersion      = RegistryRead:GetString("ProgramVersion",      ProjectQuestion.ProgramVersion ) ; 
    ProjectQuestion.ProgramYear         = RegistryRead:GetString("ProgramYear",         ProjectQuestion.Year) ; 
    ProjectQuestion.ProjectCabinetBase  = RegistryRead:GetString("ProjectCabinetBase",  ProjectQuestion.ProjectCabinetBase) ;    
    ProjectQuestion.ProjectCabinetWall  = RegistryRead:GetString("ProjectCabinetWall",  ProjectQuestion.ProjectCabinetWall) ;     
    ProjectQuestion.ProjectName         = RegistryRead:GetString("ProjectName",         string.upper(ProjectQuestion.ProjectName)) ;
    ProjectQuestion.ProjectPath         = RegistryRead:GetString("ProjectPath",        ".") ;
    if ProjectQuestion.ProjectPath == "." then
        DisplayMessageBox("Error: The CabinetMaker program Setup this computer. \n Run CabinetMaker Gadget")
    end
end
-- ===================================================
function InquiryDropList(Header, Quest, XX, YY, DList)
--[[
    Drop list foe user input
    Caller = local y = InquiryDropList("Cabinet Maker", "Select Cabinet Style", 290, 165, IniFile)
    Dialog Header = "Cabinet Maker"
    User Question = "Select Cabinet Style"
    Selection Array = IniFile
    Returns = String
]]
       DeBug(9190,1, "InquiryDropList")
    local myHtml = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto } 
    body, td, th { font-family: Arial, Helvetica, sans-serif font-size: 10px color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 { font-size: 10px; font-weight: bold; } </style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "248" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h1"  id = "Questions"><strong class = "h2">Message Here</strong></td> </tr> <tr> <th width = "20%" height = "15" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "Questions2"> </th> <th width = "60%" height = "15" align = "center" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"> <select name = "DList" size = "10" class = "h2" id = "ListBox"> <option>Defalt</option> </select> </th> <th width = "20%" height = "15" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact2"></th> </tr> <tr> <th height = "10" colspan = "3" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th> </tr> <tr> <td colspan = "3" align = "center"  valign = "middle" bgcolor = "#EBEBEB"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 40%"><span style = "width: 40%"> <input id = "ButtonCancel" class = "FormButton"  name = "ButtonCancel" type = "button" value = "Cancel"> </span></td> <td style = "width: 20%"></td> <td style = "width: 40%"><span style = "width: 40%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </span></td> </tr> </table></td> </tr> </table> </body> </html> ]] ; 
    local dialog = HTML_Dialog(true, myHtml, XX, YY, Header) ;  dialog:AddLabelField("Questions", Quest) ; dialog:AddDropDownList("ListBox", "DEFAULT") ;     dialog:AddDropDownListValue("ListBox", "DEFAULT") ; 
    for index, value in pairs(DList) do ; 
        dialog:AddDropDownListValue("ListBox", value) ; 
    end ; 
    if not dialog:ShowDialog() then ; 
    return "." ; 
    else ; 
    return string.upper(dialog:GetDropDownListValue("ListBox")) ;   
    end    
end
-- ===================================================
function NameStrip(str, var)-- convert string to the correct data type
-- Local  Words = NameStrip("KPSDFKSPSK - 34598923", "-")
   DeBug(9840,1, "NameStrip - " .. str)
   
    if "" == str then
          DisplayMessageBox("Error in string")
    else
        if string.find(str, var) then
            local j = assert(string.find(str, var) - 1) 
            return all_trim(string.sub(str, 1, j)) ;
        else
            return str
        end
    end    
end
-- ===================================================
function ShowMe()
       DeBug(9250,1, "ShowMe")
    if g_ShowMe then
       DeBug(9250, 2, "BaseDim.BackPocketDepthBase  = " .. tostring(BaseDim.BackPocketDepthBase ))
       DeBug(9250, 2, "BaseDim.BlindDadoSetbackBase  = " .. tostring(BaseDim.BlindDadoSetbackBase ))
       DeBug(9250, 2, "BaseDim.CabDepthBase  = " .. tostring(BaseDim.CabDepthBase ))
       DeBug(9250, 2, "BaseDim.CabHeightBase  = " .. tostring(BaseDim.CabHeightBase ))
       DeBug(9250, 2, "BaseDim.CabWidthBase  = " .. tostring(BaseDim.CabWidthBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameBottomRailWidthBase  = " .. tostring(BaseDim.FaceFrameBottomRailWidthBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameBottomRevealBase  = " .. tostring(BaseDim.FaceFrameBottomRevealBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameCenterStileWidthBase  = " .. tostring(BaseDim.FaceFrameCenterStileWidthBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameRevealBase  = " .. tostring(BaseDim.FaceFrameRevealBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameStileWidthBase  = " .. tostring(BaseDim.FaceFrameStileWidthBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameThicknessBase  = " .. tostring(BaseDim.FaceFrameThicknessBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameTopOverlapBase  = " .. tostring(BaseDim.FaceFrameTopOverlapBase ))
       DeBug(9250, 2, "BaseDim.FaceFrameTopRailWidthBase  = " .. tostring(BaseDim.FaceFrameTopRailWidthBase ))
       DeBug(9250, 2, "BaseDim.NailerThicknessBase  = " .. tostring(BaseDim.NailerThicknessBase ))
       DeBug(9250, 2, "BaseDim.NailerWidthBase  = " .. tostring(BaseDim.NailerWidthBase ))
       DeBug(9250, 2, "BaseDim.RevealBase  = " .. tostring(BaseDim.RevealBase ))
       DeBug(9250, 2, "BaseDim.ShelfCountBase  = " .. tostring(BaseDim.ShelfCountBase ))
       DeBug(9250, 2, "BaseDim.ShelfEndClarenceBase  = " .. tostring(BaseDim.ShelfEndClarenceBase ))
       DeBug(9250, 2, "BaseDim.ShelfFaceFrameThicknessBase  = " .. tostring(BaseDim.ShelfFaceFrameThicknessBase ))
       DeBug(9250, 2, "BaseDim.ShelfFaceFrameWidthBase  = " .. tostring(BaseDim.ShelfFaceFrameWidthBase ))
       DeBug(9250, 2, "BaseDim.ShelfFrontClearanceBase  = " .. tostring(BaseDim.ShelfFrontClearanceBase ))
       DeBug(9250, 2, "BaseDim.ShelfHoleFirstRowSpacingBase  = " .. tostring(BaseDim.ShelfHoleFirstRowSpacingBase ))
       DeBug(9250, 2, "BaseDim.ShelfHoleLastRowSpacingBase  = " .. tostring(BaseDim.ShelfHoleLastRowSpacingBase ))
       DeBug(9250, 2, "BaseDim.ShelfHoleSpacingBase  = " .. tostring(BaseDim.ShelfHoleSpacingBase ))
       DeBug(9250, 2, "BaseDim.ShelfMaterialThicknessBase  = " .. tostring(BaseDim.ShelfMaterialThicknessBase ))
       DeBug(9250, 2, "BaseDim.ShelfPinHoleBackBase  = " .. tostring(BaseDim.ShelfPinHoleBackBase ))
       DeBug(9250, 2, "BaseDim.ShelfPinHoleFrontBase  = " .. tostring(BaseDim.ShelfPinHoleFrontBase ))
       DeBug(9250, 2, "BaseDim.StretcherThicknessBase  = " .. tostring(BaseDim.StretcherThicknessBase ))
       DeBug(9250, 2, "BaseDim.StretcherWidthBase  = " .. tostring(BaseDim.StretcherWidthBase ))
       DeBug(9250, 2, "BaseDim.ThicknessBackBase  = " .. tostring(BaseDim.ThicknessBackBase ))
       DeBug(9250, 2, "BaseDim.ThicknessBase  = " .. tostring(BaseDim.ThicknessBase ))
       DeBug(9250, 2, "BaseDim.ToeKickBottomOffsetHightBase  = " .. tostring(BaseDim.ToeKickBottomOffsetHightBase ))
       DeBug(9250, 2, "BaseDim.ToeKickDepthBase  = " .. tostring(BaseDim.ToeKickDepthBase ))
       DeBug(9250, 2, "BaseDim.ToeKickHightBase  = " .. tostring(BaseDim.ToeKickHightBase ))
       DeBug(9250, 2, "BaseQuestion.AddBackNailerBase  = " .. tostring(BaseQuestion.AddBackNailerBase ))
       DeBug(9250, 2, "BaseQuestion.AddCenterPanelBase  = " .. tostring(BaseQuestion.AddCenterPanelBase ))
       DeBug(9250, 2, "BaseQuestion.AddFaceFrameBase  = " .. tostring(BaseQuestion.AddFaceFrameBase ))
       DeBug(9250, 2, "BaseQuestion.AddShelfHingPilotHolesBase  = " .. tostring(BaseQuestion.AddShelfHingPilotHolesBase ))
       DeBug(9250, 2, "BaseQuestion.AddShelfHolesBase  = " .. tostring(BaseQuestion.AddShelfHolesBase ))
       DeBug(9250, 2, "BaseQuestion.AddShelfingBase  = " .. tostring(BaseQuestion.AddShelfingBase ))
       DeBug(9250, 2, "BaseQuestion.AddStretchersBase  = " .. tostring(BaseQuestion.AddStretchersBase ))
       DeBug(9250, 2, "BaseQuestion.AddToeKickBase  = " .. tostring(BaseQuestion.AddToeKickBase ))
       DeBug(9250, 2, "BaseQuestion.BackDadoOrOverlapBase  = " .. tostring(BaseQuestion.BackDadoOrOverlapBase ))
       DeBug(9250, 2, "BaseQuestion.DadoStyleBase  = " .. tostring(BaseQuestion.DadoStyleBase ))
       DeBug(9250, 2, "BaseQuestion.DadoTypeBase  = " .. tostring(BaseQuestion.DadoTypeBase ))
       DeBug(9250, 2, "BaseQuestion.DrawBackPanelBase  = " .. tostring(BaseQuestion.DrawBackPanelBase ))
       DeBug(9250, 2, "BaseQuestion.DrawBackPanelOnNewSheetBase  = " .. tostring(BaseQuestion.DrawBackPanelOnNewSheetBase ))
       DeBug(9250, 2, "BaseQuestion.DrawBottomPanelBase  = " .. tostring(BaseQuestion.DrawBottomPanelBase ))
       DeBug(9250, 2, "BaseQuestion.DrawCenterPanelBase  = " .. tostring(BaseQuestion.DrawCenterPanelBase ))
       DeBug(9250, 2, "BaseQuestion.DrawFaceFrameBase  = " .. tostring(BaseQuestion.DrawFaceFrameBase ))
       DeBug(9250, 2, "BaseQuestion.DrawFaceFrameOnNewSheetBase  = " .. tostring(BaseQuestion.DrawFaceFrameOnNewSheetBase ))
       DeBug(9250, 2, "BaseQuestion.DrawLeftSidePanelBase  = " .. tostring(BaseQuestion.DrawLeftSidePanelBase ))
       DeBug(9250, 2, "BaseQuestion.DrawRightSidePanelBase  = " .. tostring(BaseQuestion.DrawRightSidePanelBase ))
       DeBug(9250, 2, "BaseQuestion.DrawShelfPanelBase  = " .. tostring(BaseQuestion.DrawShelfPanelBase ))
       DeBug(9250, 2, "BaseQuestion.DrawTopPanelBase  = " .. tostring(BaseQuestion.DrawTopPanelBase ))
       DeBug(9250, 2, "BaseQuestion.FaceFrameOrStretchersBase  = " .. tostring(BaseQuestion.FaceFrameOrStretchersBase ))
       DeBug(9250, 2, "BaseQuestion.NailerLocationBase  = " .. tostring(BaseQuestion.NailerLocationBase ))
       DeBug(9250, 2, "BaseQuestion.ProvideCabinetNotesOnDrawingBase  = " .. tostring(BaseQuestion.ProvideCabinetNotesOnDrawingBase ))
       DeBug(9250, 2, "BaseQuestion.ProvideCabinetNotesOnNewSheetBase  = " .. tostring(BaseQuestion.ProvideCabinetNotesOnNewSheetBase ))
       DeBug(9250, 2, "Hardware.HingBottomClearnace  = " .. tostring(Hardware.HingBottomClearnace ))
       DeBug(9250, 2, "Hardware.HingCountBase  = " .. tostring(Hardware.HingCountBase ))
       DeBug(9250, 2, "Hardware.HingCountWall  = " .. tostring(Hardware.HingCountWall ))
       DeBug(9250, 2, "Hardware.HingHoleCenters  = " .. tostring(Hardware.HingHoleCenters ))
       DeBug(9250, 2, "Hardware.HingTopClearnace  = " .. tostring(Hardware.HingTopClearnace ))
       DeBug(9250, 2, "Hardware.ShelfPinDiameter  = " .. tostring(Hardware.ShelfPinDiameter ))
       DeBug(9250, 2, "Milling.DadoClearnace  = " .. tostring(Milling.DadoClearnace ))
       DeBug(9250, 2, "Milling.DadoToolDia  = " .. tostring(Milling.DadoToolDia ))
       DeBug(9250, 2, "Milling.HalfDadoWidth  = " .. tostring(Milling.HalfDadoWidth ))
       DeBug(9250, 2, "Milling.PilotBitDia  = " .. tostring(Milling.PilotBitDia ))
       DeBug(9250, 2, "Milling.PocketToolDia  = " .. tostring(Milling.PocketToolDia ))
       DeBug(9250, 2, "Milling.ProfileToolDia  = " .. tostring(Milling.ProfileToolDia ))
       DeBug(9250, 2, "Milling.RabbitClearing  = " .. tostring(Milling.RabbitClearing ))
       DeBug(9250, 2, "Milling.SidePocketDepth  = " .. tostring(Milling.SidePocketDepth ))
       
       DeBug(9250, 2, "Milling.LayerNameSideProfile  = " .. tostring(Milling.LayerNameSideProfile ))       
       DeBug(9250, 2, "Milling.LayerNameShelfProfile  = " .. tostring(Milling.LayerNameShelfProfile ))       
       DeBug(9250, 2, "Milling.LayerNameBackProfile  = " .. tostring(Milling.LayerNameBackProfile ))       
       DeBug(9250, 2, "Milling.LayerNameTopBottomProfile  = " .. tostring(Milling.LayerNameTopBottomProfile ))       
       DeBug(9250, 2, "Milling.LayerNameCenterPanleProfile  = " .. tostring(Milling.LayerNameCenterPanleProfile ))       
       DeBug(9250, 2, "Milling.LayerNameSideTopBottomPocket  = " .. tostring(Milling.LayerNameSideTopBottomPocket ))              
       DeBug(9250, 2, "Milling.LayerNameSideBackPocket  = " .. tostring(Milling.LayerNameSideBackPocket ))       
       DeBug(9250, 2, "Milling.LayerNameSideStretcherPocket  = " .. tostring(Milling.LayerNameSideStretcherPocket ))       
       DeBug(9250, 2, "Milling.LayerNameSideNailerPocket  = " .. tostring(Milling.LayerNameSideNailerPocket ))       
       DeBug(9250, 2, "Milling.LayerNameSideShelfPinDrill  = " .. tostring(Milling.LayerNameSideShelfPinDrill ))       
       DeBug(9250, 2, "Milling.LayerNameSideHingCentersDrill  = " .. tostring(Milling.LayerNameSideHingCentersDrill ))       
       DeBug(9250, 2, "Milling.LayerNameCenterPanleShelfPinDrill  = " .. tostring(Milling.LayerNameCenterPanleShelfPinDrill ))                
       DeBug(9250, 2, "Milling.LayerNameBackPocket  = " .. tostring(Milling.LayerNameBackPocket ))       
       DeBug(9250, 2, "Milling.LayerNameTopBottomCenterDado  = " .. tostring(Milling.LayerNameTopBottomCenterDado ))       
       DeBug(9250, 2, "Milling.LayerNameDrawNotes  = " .. tostring(Milling.LayerNameDrawNotes ))       
       DeBug(9250, 2, "Milling.LayerNameDrawFaceFrame  = " .. tostring(Milling.LayerNameDrawFaceFrame ))       
--     DeBug(9250, 2, "ProjectQuestion.AddCabinetSettingsToProject  = " .. tostring(ProjectQuestion.AddCabinetSettingsToProject ))
       DeBug(9250, 2, "ProjectQuestion.CabinetName  = " .. tostring(ProjectQuestion.CabinetName ))
       DeBug(9250, 2, "ProjectQuestion.ProjectContactEmail  = " .. tostring(ProjectQuestion.ProjectContactEmail ))
       DeBug(9250, 2, "ProjectQuestion.ProjectContactName  = " .. tostring(ProjectQuestion.ProjectContactName ))
       DeBug(9250, 2, "ProjectQuestion.ProjectContactPhoneNumber  = " .. tostring(ProjectQuestion.ProjectContactPhoneNumber ))
       DeBug(9250, 2, "ProjectQuestion.ProjectName  = " .. tostring(ProjectQuestion.ProjectName ))
       DeBug(9250, 2, "ProjectQuestion.ProjectPath  = " .. tostring(ProjectQuestion.ProjectPath ))
       DeBug(9250, 2, "ProjectQuestion.StartDate  = " .. tostring(ProjectQuestion.StartDate ))
       DeBug(9250, 2, "WallDim.BackPocketDepthWall  = " .. tostring(WallDim.BackPocketDepthWall ))
       DeBug(9250, 2, "WallDim.BlindDadoSetbackWall  = " .. tostring(WallDim.BlindDadoSetbackWall ))
       DeBug(9250, 2, "WallDim.CabDepthWall  = " .. tostring(WallDim.CabDepthWall ))
       DeBug(9250, 2, "WallDim.CabHeightWall  = " .. tostring(WallDim.CabHeightWall ))
       DeBug(9250, 2, "WallDim.CabLengthWall  = " .. tostring(WallDim.CabLengthWall ))
       DeBug(9250, 2, "WallDim.FaceFrameBottomRailWidthWall  = " .. tostring(WallDim.FaceFrameBottomRailWidthWall ))
       DeBug(9250, 2, "WallDim.FaceFrameBottomRevealWall  = " .. tostring(WallDim.FaceFrameBottomRevealWall ))
       DeBug(9250, 2, "WallDim.FaceFrameCenterStileWidthWall  = " .. tostring(WallDim.FaceFrameCenterStileWidthWall ))
       DeBug(9250, 2, "WallDim.FaceFrameRevealWall  = " .. tostring(WallDim.FaceFrameRevealWall ))
       DeBug(9250, 2, "WallDim.FaceFrameStileWidthWall  = " .. tostring(WallDim.FaceFrameStileWidthWall ))
       DeBug(9250, 2, "WallDim.FaceFrameThicknessWall  = " .. tostring(WallDim.FaceFrameThicknessWall ))
       DeBug(9250, 2, "WallDim.FaceFrameTopOverlapWall  = " .. tostring(WallDim.FaceFrameTopOverlapWall ))
       DeBug(9250, 2, "WallDim.FaceFrameTopRailWidthWall  = " .. tostring(WallDim.FaceFrameTopRailWidthWall ))
       DeBug(9250, 2, "WallDim.NailerThicknessWall  = " .. tostring(WallDim.NailerThicknessWall ))
       DeBug(9250, 2, "WallDim.NailerWidthWall  = " .. tostring(WallDim.NailerWidthWall ))
       DeBug(9250, 2, "WallDim.RevealWall  = " .. tostring(WallDim.RevealWall ))
       DeBug(9250, 2, "WallDim.ShelfCountWall  = " .. tostring(WallDim.ShelfCountWall ))
       DeBug(9250, 2, "WallDim.ShelfEndClarenceWall  = " .. tostring(WallDim.ShelfEndClarenceWall ))
       DeBug(9250, 2, "WallDim.ShelfFaceFrameRevealWall  = " .. tostring(WallDim.ShelfFaceFrameRevealWall ))
       DeBug(9250, 2, "WallDim.ShelfFaceFrameThicknessWall  = " .. tostring(WallDim.ShelfFaceFrameThicknessWall ))
       DeBug(9250, 2, "WallDim.ShelfFaceFrameWidthWall  = " .. tostring(WallDim.ShelfFaceFrameWidthWall ))
       DeBug(9250, 2, "WallDim.ShelfFrontClearanceWall  = " .. tostring(WallDim.ShelfFrontClearanceWall ))
       DeBug(9250, 2, "WallDim.ShelfHoleFirstRowSpacingWall  = " .. tostring(WallDim.ShelfHoleFirstRowSpacingWall ))
       DeBug(9250, 2, "WallDim.ShelfHoleLastRowSpacingWall  = " .. tostring(WallDim.ShelfHoleLastRowSpacingWall ))
       DeBug(9250, 2, "WallDim.ShelfHoleSpacingWall  = " .. tostring(WallDim.ShelfHoleSpacingWall ))
       DeBug(9250, 2, "WallDim.ShelfMaterialThicknessWall  = " .. tostring(WallDim.ShelfMaterialThicknessWall ))
       DeBug(9250, 2, "WallDim.ShelfPinHoleBackWall  = " .. tostring(WallDim.ShelfPinHoleBackWall ))
       DeBug(9250, 2, "WallDim.ShelfPinHoleFrontWall  = " .. tostring(WallDim.ShelfPinHoleFrontWall ))
       DeBug(9250, 2, "WallDim.StretcherThicknessWall  = " .. tostring(WallDim.StretcherThicknessWall ))
       DeBug(9250, 2, "WallDim.StretcherWidthWall  = " .. tostring(WallDim.StretcherWidthWall ))
       DeBug(9250, 2, "WallDim.ThicknessBackWall  = " .. tostring(WallDim.ThicknessBackWall ))
       DeBug(9250, 2, "WallDim.ThicknessWall  = " .. tostring(WallDim.ThicknessWall ))
       DeBug(9250, 2, "WallQuestion.AddBackNailerWall  = " .. tostring(WallQuestion.AddBackNailerWall ))
       DeBug(9250, 2, "WallQuestion.AddCenterPanelWall  = " .. tostring(WallQuestion.AddCenterPanelWall ))
       DeBug(9250, 2, "WallQuestion.AddFaceFrameWall  = " .. tostring(WallQuestion.AddFaceFrameWall ))
       DeBug(9250, 2, "WallQuestion.AddShelfHingPilotHolesWall  = " .. tostring(WallQuestion.AddShelfHingPilotHolesWall ))
       DeBug(9250, 2, "WallQuestion.AddShelfHolesWall  = " .. tostring(WallQuestion.AddShelfHolesWall ))
       DeBug(9250, 2, "WallQuestion.AddShelfingWall  = " .. tostring(WallQuestion.AddShelfingWall ))
       DeBug(9250, 2, "WallQuestion.AddStretchersWall  = " .. tostring(WallQuestion.AddStretchersWall ))
       DeBug(9250, 2, "WallQuestion.BackDadoOrOverlapWall  = " .. tostring(WallQuestion.BackDadoOrOverlapWall ))
       DeBug(9250, 2, "WallQuestion.DadoStyleWall  = " .. tostring(WallQuestion.DadoStyleWall ))
       DeBug(9250, 2, "WallQuestion.DadoTypeWall  = " .. tostring(WallQuestion.DadoTypeWall ))
       DeBug(9250, 2, "WallQuestion.DrawBackPanelOnNewSheetWall  = " .. tostring(WallQuestion.DrawBackPanelOnNewSheetWall ))
       DeBug(9250, 2, "WallQuestion.DrawBackPanelWall  = " .. tostring(WallQuestion.DrawBackPanelWall ))
       DeBug(9250, 2, "WallQuestion.DrawBottomPanelWall  = " .. tostring(WallQuestion.DrawBottomPanelWall ))
       DeBug(9250, 2, "WallQuestion.DrawCenterPanelWall  = " .. tostring(WallQuestion.DrawCenterPanelWall ))
       DeBug(9250, 2, "WallQuestion.DrawFaceFrameOnNewSheetWall  = " .. tostring(WallQuestion.DrawFaceFrameOnNewSheetWall ))
       DeBug(9250, 2, "WallQuestion.DrawFaceFrameWall  = " .. tostring(WallQuestion.DrawFaceFrameWall ))
       DeBug(9250, 2, "WallQuestion.DrawLeftSidePanelWall  = " .. tostring(WallQuestion.DrawLeftSidePanelWall ))
       DeBug(9250, 2, "WallQuestion.DrawRightSidePanelWall  = " .. tostring(WallQuestion.DrawRightSidePanelWall ))
       DeBug(9250, 2, "WallQuestion.DrawShelfPanelWall  = " .. tostring(WallQuestion.DrawShelfPanelWall ))
       DeBug(9250, 2, "WallQuestion.DrawTopPanelWall  = " .. tostring(WallQuestion.DrawTopPanelWall ))
       DeBug(9250, 2, "WallQuestion.FaceFrameOrStretchersWall  = " .. tostring(WallQuestion.FaceFrameOrStretchersWall ))
       DeBug(9250, 2, "WallQuestion.NailerLocationWall  = " .. tostring(WallQuestion.NailerLocationWall ))
       DeBug(9250, 2, "WallQuestion.ProvideCabinetNotesOnDrawingWall  = " .. tostring(WallQuestion.ProvideCabinetNotesOnDrawingWall ))
       DeBug(9250, 2, "WallQuestion.ProvideCabinetNotesOnNewSheetWall = " .. tostring(WallQuestion.ProvideCabinetNotesOnNewSheetWall))

    end
end 
-- ===================================================
function G_ReadINICabinetMaker(xPath, xGroup, xFile)
       DeBug(9280,1, "G_ReadINICabinetMaker")
    local filename = xPath .. "/" .. xFile 
       DeBug(9281,1, "G_ReadINICabinetMaker - " .. filename)
    BaseDim.BackPocketDepthBase                         =    GetIniValue(xPath, xFile, xGroup, "BaseDim.BackPocketDepthBase", "N")
    BaseDim.BlindDadoSetbackBase                        =    GetIniValue(xPath, xFile, xGroup, "BaseDim.BlindDadoSetbackBase", "N")
    BaseDim.CabDepthBase                                =    GetIniValue(xPath, xFile, xGroup, "BaseDim.CabDepthBase", "N")
    BaseDim.CabHeightBase                               =    GetIniValue(xPath, xFile, xGroup, "BaseDim.CabHeightBase", "N")
    BaseDim.CabWidthBase                                =    GetIniValue(xPath, xFile, xGroup, "BaseDim.CabWidthBase", "N")
    BaseDim.FaceFrameBottomRailWidthBase                =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRailWidthBase", "N")
    BaseDim.FaceFrameBottomRevealBase                   =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRevealBase", "N")
    BaseDim.FaceFrameCenterStileWidthBase               =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameCenterStileWidthBase", "N")
    BaseDim.FaceFrameRevealBase                         =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameRevealBase", "N")
    BaseDim.FaceFrameStileWidthBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameStileWidthBase", "N")
    BaseDim.FaceFrameThicknessBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameThicknessBase", "N")
    BaseDim.FaceFrameTopOverlapBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopOverlapBase", "N")
    BaseDim.FaceFrameTopRailWidthBase                   =    GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopRailWidthBase", "N")
    BaseDim.NailerThicknessBase                         =    GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerThicknessBase", "N")
    BaseDim.NailerWidthBase                             =    GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerWidthBase", "N")
    BaseDim.RevealBase                                  =    GetIniValue(xPath, xFile, xGroup, "BaseDim.RevealBase", "N")
    BaseDim.ShelfCountBase                              =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfCountBase", "N")
    BaseDim.ShelfEndClarenceBase                        =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfEndClarenceBase", "N")
    BaseDim.ShelfFaceFrameThicknessBase                 =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameThicknessBase", "N")
    BaseDim.ShelfFaceFrameWidthBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameWidthBase", "N")
    BaseDim.ShelfFrontClearanceBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFrontClearanceBase", "N")
    BaseDim.ShelfHoleFirstRowSpacingBase                =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleFirstRowSpacingBase", "N")
    BaseDim.ShelfHoleLastRowSpacingBase                 =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleLastRowSpacingBase", "N")
    BaseDim.ShelfHoleSpacingBase                        =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleSpacingBase", "N")
    BaseDim.ShelfMaterialThicknessBase                  =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfMaterialThicknessBase", "N")
    BaseDim.ShelfPinHoleBackBase                        =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleBackBase", "N")
    BaseDim.ShelfPinHoleFrontBase                       =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleFrontBase", "N")
    BaseDim.StretcherThicknessBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherThicknessBase", "N")
    BaseDim.StretcherWidthBase                          =    GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherWidthBase", "N")
    BaseDim.ThicknessBackBase                           =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBackBase", "N")
    BaseDim.ThicknessBase                               =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBase", "N")
    BaseDim.ToeKickBottomOffsetHightBase                =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickBottomOffsetHightBase", "N")
    BaseDim.ToeKickDepthBase                            =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickDepthBase", "N")
    BaseDim.ToeKickHightBase                            =    GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickHightBase", "N")
    BaseQuestion.AddBackNailerBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddBackNailerBase", "B")
    BaseQuestion.AddCenterPanelBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddCenterPanelBase", "B")
    BaseQuestion.AddFaceFrameBase                       =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddFaceFrameBase", "B")
    BaseQuestion.AddShelfHingPilotHolesBase             =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHingPilotHolesBase", "B")
    BaseQuestion.AddShelfHolesBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHolesBase", "B")
    BaseQuestion.AddShelfingBase                        =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfingBase", "B")
    BaseQuestion.AddStretchersBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddStretchersBase", "B")
    BaseQuestion.AddToeKickBase                         =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddToeKickBase", "B")
    BaseQuestion.BackDadoOrOverlapBase                  =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.BackDadoOrOverlapBase", "S")
    BaseQuestion.DadoStyleBase                          =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoStyleBase", "S")
    BaseQuestion.DadoTypeBase                           =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoTypeBase", "S")
    BaseQuestion.DrawBackPanelBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelBase", "B")
    BaseQuestion.DrawBackPanelOnNewSheetBase            =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelOnNewSheetBase", "B")
    BaseQuestion.DrawBottomPanelBase                    =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBottomPanelBase", "B")
    BaseQuestion.DrawCenterPanelBase                    =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawCenterPanelBase", "B")
    BaseQuestion.DrawFaceFrameBase                      =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameBase", "B")
    BaseQuestion.DrawFaceFrameOnNewSheetBase            =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameOnNewSheetBase", "B")
    BaseQuestion.DrawLeftSidePanelBase                  =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawLeftSidePanelBase", "B")
    BaseQuestion.DrawRightSidePanelBase                 =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawRightSidePanelBase", "B")
    BaseQuestion.DrawShelfPanelBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawShelfPanelBase", "B")
    BaseQuestion.DrawTopPanelBase                       =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawTopPanelBase", "B")
    BaseQuestion.FaceFrameOrStretchersBase              =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.FaceFrameOrStretchersBase", "S")
    BaseQuestion.NailerLocationBase                     =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.NailerLocationBase", "S")
    BaseQuestion.ProvideCabinetNotesOnDrawingBase       =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnDrawingBase", "B")
    BaseQuestion.ProvideCabinetNotesOnNewSheetBase      =    GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnNewSheetBase", "B")
    Hardware.HingBottomClearnace                        =    GetIniValue(xPath, xFile, xGroup, "Hardware.HingBottomClearnace", "N")
    Hardware.HingCountBase                              =    GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountBase", "N")
    Hardware.HingCountWall                              =    GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountWall", "N")
    Hardware.HingTopClearnace                           =    GetIniValue(xPath, xFile, xGroup, "Hardware.HingTopClearnace", "N")
    Hardware.ShelfPinDiameter                           =    GetIniValue(xPath, xFile, xGroup, "Hardware.ShelfPinDiameter", "N")
    Hardware.HingHoleCenters                            =    GetIniValue(xPath, xFile, xGroup, "Hardware.HingHoleCenters", "N")
    Milling.DadoClearnace                               =    GetIniValue(xPath, xFile, xGroup, "Milling.DadoClearnace", "N")
    Milling.DadoToolDia                                 =    GetIniValue(xPath, xFile, xGroup, "Milling.DadoToolDia", "N")
    Milling.HalfDadoWidth                               =    GetIniValue(xPath, xFile, xGroup, "Milling.HalfDadoWidth", "N")
    Milling.PilotBitDia                                 =    GetIniValue(xPath, xFile, xGroup, "Milling.PilotBitDia", "N")
    Milling.PocketToolDia                               =    GetIniValue(xPath, xFile, xGroup, "Milling.PocketToolDia", "N")
    Milling.ProfileToolDia                              =    GetIniValue(xPath, xFile, xGroup, "Milling.ProfileToolDia", "N")
    Milling.RabbitClearing                              =    GetIniValue(xPath, xFile, xGroup, "Milling.RabbitClearing", "N")
    Milling.SidePocketDepth                             =    GetIniValue(xPath, xFile, xGroup, "Milling.SidePocketDepth", "N")
    Milling.LayerNameSideProfile                        =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideProfile", "N")
    Milling.LayerNameShelfProfile                       =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameShelfProfile", "S")
    Milling.LayerNameBackProfile                        =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameBackProfile", "S")
    Milling.LayerNameTopBottomProfile                   =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameTopBottomProfile", "S")
    Milling.LayerNameCenterPanleProfile                 =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameCenterPanleProfile", "S")
    Milling.LayerNameSideTopBottomPocket                =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideTopBottomPocket", "S")
    Milling.LayerNameSideBackPocket                     =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideBackPocket", "S")
    Milling.LayerNameSideStretcherPocket                =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideStretcherPocket", "S")
    Milling.LayerNameSideNailerPocket                   =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideNailerPocket", "S")
    Milling.LayerNameSideShelfPinDrill                  =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideShelfPinDrill", "S")
    Milling.LayerNameSideHingCentersDrill               =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameSideHingCentersDrill", "S")
    Milling.LayerNameCenterPanleShelfPinDrill           =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameCenterPanleShelfPinDrill", "S")
    Milling.LayerNameBackPocket                         =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameBackPocket", "S")
    Milling.LayerNameTopBottomCenterDado                =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameTopBottomCenterDado", "S")
    Milling.LayerNameDrawNotes                          =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawNotes", "S")
    Milling.LayerNameDrawFaceFrame                      =    GetIniValue(xPath, xFile, xGroup, "Milling.LayerNameDrawFaceFrame", "S")
--  ProjectQuestion.AddCabinetSettingsToProject         =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.AddCabinetSettingsToProject", "B")
    ProjectQuestion.ProjectName                         =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectName", "S")
    ProjectQuestion.CabinetName                         =    NameStrip(GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.CabinetName", "S"), "-")
    ProjectQuestion.ProjectPath                         =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectPath", "S")
    ProjectQuestion.StartDate                           =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.StartDate", "S")
    ProjectQuestion.ProjectContactEmail                 =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactEmail", "S")
    ProjectQuestion.ProjectContactName                  =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactName", "S")
    ProjectQuestion.ProjectContactPhoneNumber           =    GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactPhoneNumber", "S")
    WallDim.BackPocketDepthWall                         =    GetIniValue(xPath, xFile, xGroup, "WallDim.BackPocketDepthWall", "N")
    WallDim.BlindDadoSetbackWall                        =    GetIniValue(xPath, xFile, xGroup, "WallDim.BlindDadoSetbackWall", "N")
    WallDim.CabDepthWall                                =    GetIniValue(xPath, xFile, xGroup, "WallDim.CabDepthWall", "N")
    WallDim.CabHeightWall                               =    GetIniValue(xPath, xFile, xGroup, "WallDim.CabHeightWall", "N")
    WallDim.CabLengthWall                                =    GetIniValue(xPath, xFile, xGroup, "WallDim.CabLengthWall", "N")
    WallDim.FaceFrameBottomRailWidthWall                =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRailWidthWall", "N")
    WallDim.FaceFrameBottomRevealWall                   =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRevealWall", "N")
    WallDim.FaceFrameCenterStileWidthWall               =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameCenterStileWidthWall", "N")
    WallDim.FaceFrameRevealWall                         =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameRevealWall", "N")
    WallDim.FaceFrameStileWidthWall                     =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameStileWidthWall", "N")
    WallDim.FaceFrameThicknessWall                      =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameThicknessWall", "N")
    WallDim.FaceFrameTopOverlapWall                     =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopOverlapWall", "N")
    WallDim.FaceFrameTopRailWidthWall                   =    GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopRailWidthWall", "N")
    WallDim.NailerThicknessWall                         =    GetIniValue(xPath, xFile, xGroup, "WallDim.NailerThicknessWall", "N")
    WallDim.NailerWidthWall                             =    GetIniValue(xPath, xFile, xGroup, "WallDim.NailerWidthWall", "N")
    WallDim.RevealWall                                  =    GetIniValue(xPath, xFile, xGroup, "WallDim.RevealWall", "N")
    WallDim.ShelfCountWall                              =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfCountWall", "N")
    WallDim.ShelfEndClarenceWall                        =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfEndClarenceWall", "N")
    WallDim.ShelfFaceFrameRevealWall                    =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameRevealWall", "N")
    WallDim.ShelfFaceFrameThicknessWall                 =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameThicknessWall", "N")
    WallDim.ShelfFaceFrameWidthWall                     =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameWidthWall", "N")
    WallDim.ShelfFrontClearanceWall                     =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFrontClearanceWall", "N")
    WallDim.ShelfHoleFirstRowSpacingWall                =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleFirstRowSpacingWall", "N")
    WallDim.ShelfHoleLastRowSpacingWall                 =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleLastRowSpacingWall", "N")
    WallDim.ShelfHoleSpacingWall                        =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleSpacingWall", "N")
    WallDim.ShelfMaterialThicknessWall                  =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfMaterialThicknessWall", "N")
    WallDim.ShelfPinHoleBackWall                        =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleBackWall", "N")
    WallDim.ShelfPinHoleFrontWall                       =    GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleFrontWall", "N")
    WallDim.StretcherThicknessWall                      =    GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherThicknessWall", "N")
    WallDim.StretcherWidthWall                          =    GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherWidthWall", "N")
    WallDim.ThicknessBackWall                           =    GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessBackWall", "N")
    WallDim.ThicknessWall                               =    GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessWall", "N")
    WallQuestion.AddBackNailerWall                      =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddBackNailerWall", "B")
    WallQuestion.AddCenterPanelWall                     =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddCenterPanelWall", "B")
    WallQuestion.AddFaceFrameWall                       =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddFaceFrameWall", "B")
    WallQuestion.AddShelfHingPilotHolesWall             =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHingPilotHolesWall", "B")
    WallQuestion.AddShelfHolesWall                      =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHolesWall", "B")
    WallQuestion.AddShelfingWall                        =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfingWall", "B")
    WallQuestion.AddStretchersWall                      =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddStretchersWall", "B")
    WallQuestion.BackDadoOrOverlapWall                  =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.BackDadoOrOverlapWall", "S")
    WallQuestion.DadoStyleWall                          =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoStyleWall", "S")
    WallQuestion.DadoTypeWall                           =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoTypeWall", "S")
    WallQuestion.DrawBackPanelOnNewSheetWall            =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelOnNewSheetWall", "B")
    WallQuestion.DrawBackPanelWall                      =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelWall", "B")
    WallQuestion.DrawBottomPanelWall                    =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBottomPanelWall", "B")
    WallQuestion.DrawCenterPanelWall                    =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawCenterPanelWall", "B")
    WallQuestion.DrawFaceFrameOnNewSheetWall            =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameOnNewSheetWall", "B")
    WallQuestion.DrawFaceFrameWall                      =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameWall", "B")
    WallQuestion.DrawLeftSidePanelWall                  =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawLeftSidePanelWall", "B")
    WallQuestion.DrawRightSidePanelWall                 =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawRightSidePanelWall", "B")
    WallQuestion.DrawShelfPanelWall                     =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawShelfPanelWall", "B")
    WallQuestion.DrawTopPanelWall                       =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawTopPanelWall", "B")
    WallQuestion.FaceFrameOrStretchersWall              =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.FaceFrameOrStretchersWall", "S")
    WallQuestion.NailerLocationWall                     =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.NailerLocationWall", "S")
    WallQuestion.ProvideCabinetNotesOnDrawingWall       =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnDrawingWall", "B")
    WallQuestion.ProvideCabinetNotesOnNewSheetWall      =    GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnNewSheetWall", "B")
    return true
end
-- ===================================================
function G_ReadProjectinfo(xPath, xGroup, xFile)
    DeBug(9400,1, "G_ReadProjectinfo" )
    ProjectQuestion.ProjectContactEmail         = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactEmail", "S") 
    ProjectQuestion.ProjectContactName          = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactName", "S") 
    ProjectQuestion.ProjectContactPhoneNumber   = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectContactPhoneNumber", "S") 
    ProjectQuestion.ProjectName                 = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectName", "S") 
    ProjectQuestion.ProjectPath                 = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.ProjectPath", "S") 
    ProjectQuestion.StartDate                   = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.StartDate", "S") 
end
-- ===================================================
function G_IniUpdateFile(xPath, xGroup, xFile, xItem, xValue)
--    DeBug(9450, 1, "G_IniUpdateFile" )
-- G_IniUpdateFile("E:/Test", "Wall", "Bob", "Cabinet Depth", "22")
-- xItem = "Cabinet Depth" 
-- xValue = "22"
    local NfileName = xPath .. "/" .. xFile .. ".ini"
    local OfileName = xPath .. "/" .. xFile .. ".bak"
    os.remove(OfileName)
    --DisplayMessageBox(NfileName)
    --DisplayMessageBox(OfileName)
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
    --   DeBug(9271,5, "File length = " .. tostring(len)) 
    fileR:close() ; 
    fileW:close() ; 
end
-- ===================================================
function CADLeters(job, pt, letter, scl, lay)
       DeBug(9350,7, "CADLeters")
    scl = (scl * 0.5)
    local pA0 = pt ; local pA1 = Polar2D(pt, 90.0000, (0.2500 * scl)) ; local pA2 = Polar2D(pt, 90.0000, (0.5000 * scl)) ; local pA3 = Polar2D(pt, 90.0000, (0.7500 * scl)) ; local pA4 = Polar2D(pt, 90.0000, (1.0000 * scl)) ; local pA5 = Polar2D(pt, 90.0000, (1.2500 * scl)) ; local pA6 = Polar2D(pt, 90.0000, (1.5000 * scl)) ; local pA7 = Polar2D(pt, 90.0000, (1.7500 * scl)) ; local pA8 = Polar2D(pt, 90.0000, (2.0000 * scl)) ; local pB0 = Polar2D(pt,  0.0000, (0.2500 * scl)) ; local pB1 = Polar2D(pt, 45.0000, (0.3536 * scl)) ; local pB3 = Polar2D(pt, 71.5651, (0.7906 * scl)) ; local pB4 = Polar2D(pt, 75.9638, (1.0308 * scl)) ; local pB5 = Polar2D(pt, 78.6901, (1.2748 * scl)) ; local pB7 = Polar2D(pt, 81.8699, (1.7678 * scl)) ; local pB8 = Polar2D(pt, 82.8750, (2.0156 * scl)) ; local pB10 = Polar2D(pt, 84.2894, (2.5125 * scl)) ; local pC0 = Polar2D(pt,  0.0000, (0.5000 * scl)) ; local pC2 = Polar2D(pt, 45.0000, (0.7071 * scl)) ; local pC8 = Polar2D(pt, 75.9638, (2.0616 * scl)) ; local pC10 = Polar2D(pt,78.6901, (2.5125 * scl)) ; local pD0 = Polar2D(pt,  0.0000, (0.6250 * scl)) ; local pD1 = Polar2D(pt, 21.8014, (0.6731 * scl)) ; local pD4 = Polar2D(pt, 57.9946, (1.1792 * scl)) ; local pD7 = Polar2D(pt, 70.3462, (1.8583 * scl)) ; local pD8 = Polar2D(pt, 72.6460, (2.0954 * scl)) ; local pE0 = Polar2D(pt,  0.0000, (0.7500 * scl)) ; local pE2 = Polar2D(pt, 33.6901, (0.9014 * scl)) ; local pE3 = Polar2D(pt, 45.0000, (1.0607 * scl)) ; local pE8 = Polar2D(pt, 69.4440, (2.1360 * scl)) ; local pF0 = Polar2D(pt,  0.0000, (1.0000 * scl)) ; local pF3 = Polar2D(pt, 36.8699, (1.2500 * scl)) ; local pF4 = Polar2D(pt, 45.0000, (1.4142 * scl)) ; local pF7 = Polar2D(pt, 60.2551, (2.0156 * scl)) ; local pF8 = Polar2D(pt, 63.4349, (2.2361 * scl)) ; local pF10 = Polar2D(pt,59.0362, (2.9155 * scl)) ; local pG0 = Polar2D(pt,  0.0000, (1.2500 * scl)) ; local pG1 = Polar2D(pt, 11.3099, (1.2748 * scl)) ; local pG2 = Polar2D(pt, 21.8014, (1.3463 * scl)) ; local pG3 = Polar2D(pt, 30.9638, (1.4577 * scl)) ; local pG4 = Polar2D(pt, 38.6598, (1.6008 * scl)) ; local pG5 = Polar2D(pt, 45.0000, (1.7678 * scl)) ; local pG6 = Polar2D(pt, 50.1944, (1.9526 * scl)) ; local pG7 = Polar2D(pt, 54.4623, (2.1506 * scl)) ; local pG8 = Polar2D(pt, 57.9946, (2.3585 * scl)) ; local pH0 = Polar2D(pt,  0.0000, (1.5000 * scl)) ; local pH10 = Polar2D(pt,63.4349, (2.7951 * scl)) ; local group = ContourGroup(true) ; local layer = job.LayerManager:GetLayerWithName(lay) ; local line = Contour(0.0) ; 
    if letter ==  65 then ; line:AppendPoint(pA0) ; line:LineTo(pD8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pF3) ; layer:AddObject(CreateCadContour(line), true) ; end
    if letter ==  66 then ; line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; end
    if letter ==  67 then ; line:AppendPoint(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  68 then ; line:AppendPoint(pA0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pA8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  69 then ; line:AppendPoint(pG0) ; line:LineTo(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  70 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  71 then ; line:AppendPoint(pG6) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG3) ; line:LineTo(pE3) ; line:LineTo(pE2) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  72 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  73 then ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pC0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end
    if letter ==  74 then ; line:AppendPoint(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; line:LineTo(pC8) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  75 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA2) ; line:LineTo(pG7) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end
    if letter ==  76 then ; line:AppendPoint(pA8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter ==  77 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter ==  78 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end
    if letter ==  79 then ; line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter ==  80 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true)    
    end
    if letter ==  81 then ; line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter ==  82 then ; line:AppendPoint(pA0) ; line:LineTo(pA8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pA4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  83 then ; line:AppendPoint(pG5) ; line:LineTo(pG6) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA6) ; line:LineTo(pA5) ; line:LineTo(pG3) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA2) ; line:LineTo(pA3) ; layer:AddObject(CreateCadContour(line), true)    
    end  
    if letter ==  84 then ; line:AppendPoint(pA8) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  85 then ; line:AppendPoint(pA8) ; line:LineTo(pA2) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG2) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  86 then ; line:AppendPoint(pA8) ; line:LineTo(pD0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  87 then ; line:AppendPoint(pA8) ; line:LineTo(pB0) ; line:LineTo(pD4) ; line:LineTo(pF0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true)    
    end     
    if letter ==  88 then ; line:AppendPoint(pA0) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA8) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  89 then ; line:AppendPoint(pA8) ; line:LineTo(pD4) ; line:LineTo(pG8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD0) ; line:LineTo(pD4) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter ==  90 then ; line:AppendPoint(pA8) ; line:LineTo(pG8) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  48 then ; line:AppendPoint(pB0) ; line:LineTo(pA2) ; line:LineTo(pA6) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG6) ; line:LineTo(pG2) ; line:LineTo(pF0) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pG8) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)    
    end    
    if letter ==  49 then ; line:AppendPoint(pA6) ; line:LineTo(pD8) ; line:LineTo(pD0) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  50 then ; line:AppendPoint(pA6) ; line:LineTo(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pA2) ; line:LineTo(pA0) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  51 then ; line:AppendPoint(pA7) ; line:LineTo(pB8) ; line:LineTo(pF8) ; line:LineTo(pG7) ; line:LineTo(pG5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF4) ; line:LineTo(pB4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter ==  52 then ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; line:LineTo(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  53 then ; line:AppendPoint(pG8) ; line:LineTo(pA8) ; line:LineTo(pA5) ; line:LineTo(pF4) ; line:LineTo(pG3) ; line:LineTo(pG1) ; line:LineTo(pF0) ; line:LineTo(pB0) ; line:LineTo(pA1) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  54 then ; line:AppendPoint(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pB4) ; line:LineTo(pA2) ; layer:AddObject(CreateCadContour(line), true)        
    end   
    if letter ==  55 then ; line:AppendPoint(pB0) ; line:LineTo(pG8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  56 then ; line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG1) ; line:LineTo(pG3) ; line:LineTo(pF4) ; line:LineTo(pG5) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pA3) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB4) ; line:LineTo(pF4) ; layer:AddObject(CreateCadContour(line), true) ; 
    end   
    if letter ==  57 then ; line:AppendPoint(pA1) ; line:LineTo(pB0) ; line:LineTo(pF0) ; line:LineTo(pG3) ; line:LineTo(pG7) ; line:LineTo(pF8) ; line:LineTo(pB8) ; line:LineTo(pA7) ; line:LineTo(pA5) ; line:LineTo(pB4) ; line:LineTo(pF4) ; line:LineTo(pG5) ; layer:AddObject(CreateCadContour(line), true)    
    end   
    if letter ==  47 then ; line:AppendPoint(pA0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter ==  43 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pD1) ; line:LineTo(pD7) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter ==  61 then ; line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter ==  45 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true) 
    end   
    if letter ==  39 then ; line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pC0 
    end   
    if letter ==  34 then ; line:AppendPoint(pA7) ; line:LineTo(pB10) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB7) ; line:LineTo(pC10) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pE0 
    end   
    if letter ==  40 then ; line:AppendPoint(pB8) ; line:LineTo(pA5) ; line:LineTo(pA3) ; line:LineTo(pB0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end   
    if letter ==  41 then ; line:AppendPoint(pA8) ; line:LineTo(pB5) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pG0 
    end   
    if letter ==  60 then ; line:AppendPoint(pF8) ; line:LineTo(pA4) ; line:LineTo(pG0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  62 then ; line:AppendPoint(pA8) ; line:LineTo(pF4) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  95 then ; line:AppendPoint(pA0) ; line:LineTo(pF0) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  58 then ; line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter ==  46 then ; line:AppendPoint(pA1) ; line:LineTo(pB1) ; line:LineTo(pB0) ; line:LineTo(pA0) ; line:LineTo(pA1) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
    if letter ==  59 then ; line:AppendPoint(pB8) ; line:LineTo(pA8) ; line:LineTo(pA7) ; line:LineTo(pB7) ; line:LineTo(pB8) ; line:LineTo(pA8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB3) ; line:LineTo(pB4) ; line:LineTo(pA4) ; line:LineTo(pA3) ; line:LineTo(pB3) ; line:LineTo(pA0) ; layer:AddObject(CreateCadContour(line), true) ; pH0 = pD0 
    end  
     if letter ==  35 then ; line:AppendPoint(pA2) ; line:LineTo(pG2) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pA6) ; line:LineTo(pG6) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pB0) ; line:LineTo(pB8) ; layer:AddObject(CreateCadContour(line), true) ; line = Contour(0.0) ; line:AppendPoint(pF0) ; line:LineTo(pF8) ; layer:AddObject(CreateCadContour(line), true) 
    end    
    if letter ==  32 then ; pH0 = pH0 
    end   
    if letter ==  33 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  36 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  37 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  38 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  42 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  63 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  64 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  91 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  92 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  93 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  94 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  96 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  123 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  124 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  125 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    if letter ==  126 then ; line:AppendPoint(pA4) ; line:LineTo(pG4) ; layer:AddObject(CreateCadContour(line), true)
    end   
    return pH0  
end-- function end
-- ===================================================
function StartDate()
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

       DeBug(9360,4, "StartDate")
    return os.date("%b %d, %Y") .. " - " ..os.date("%I") .. ":" ..os.date("%m")..os.date("%p")
end
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
       DeBug(9370,4, "NowName")
    return os.date("%d").. os.date("%H").. os.date("%M").. os.date("%S")
end
-- ===================================================
function ProjectBackup()

    local filename = "C:/Users/Public/Documents/Vectric Files/Gadgets/CabinetBackup.cmd"
    local FolderName = NowName()
    local file = io.open(filename, "a")
    file:write("echo ================================================================================ \n") ;
    file:write("echo CabinetMaker \n") ;
    file:write("echo on \n") ;
    file:write("Z:\n") ;
    file:write("cd Vcarve \n") ;
    file:write("mkdir " .. FolderName .." \n") ;
    file:write("xcopy " .. string.char(34) .. "C:/Users/Public/Documents/Vectric Files/Gadgets/VCarve Pro V9.5/CabinetMaker" .. string.char(34) .. " " .. string.char(34) .. "Z:/Vcarve/" .. string.char(34) .. FolderName .. "/ /d/e/y \n") ; 
    file:write("xcopy C:/Temp/Cabinet  Z:/Vcarve/" .. FolderName .. "/Temp/Cabinet /d/e/y")
    file:write("echo ================================================================================= \n") ;
    file:write("pause \n") ;

    file:close()-- closes the open file 
    return true  

end
-- ==============================================================================
function RestoreABackup()

    local filename = "C:/Users/Public/Documents/Vectric Files/Gadgets/CabinetBackup.cmd"
    local FolderName = NowName()
    local file = io.open(filename, "a")
    file:write("echo ================================================================================ \n") ;
    file:write("echo CabinetMaker \n") ;
    file:write("echo on \n") ;
    file:write("Z:\n") ;
    file:write("cd Vcarve \n") ;
    file:write("mkdir " .. FolderName .." \n") ;
    file:write("xcopy " .. string.char(34) .. "C:/Users/Public/Documents/Vectric Files/Gadgets/VCarve Pro V9.5/CabinetMaker" .. string.char(34) .. " " .. string.char(34) .. "Z:/Vcarve/" .. string.char(34) .. FolderName .. "/ /d/e/y \n") ; 
    file:write("xcopy C:/Temp/Cabinet  Z:/Vcarve/".. FolderName .. "/Temp/Cabinet /d/e/y")
    file:write("echo ================================================================================= \n") ;
    file:write("pause \n") ;

    file:close()-- closes the open file 
    return true  

end
-- ===================================================
function BuildLine(pt1, pt2)
       DeBug(9390,1, "BuildLine")
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ; 
    return line
end-- function end
-- ===================================================
function BuildBox(job, pt1, lay, xx, yy)
    DeBug(9410,1, "BuildBox")
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
function BuildCircle(pt1, lay, crad)
    DeBug(9420,1, "BuildCircle")

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
    line:LineTo(Polar2D(pt1, 0, xx)) ; 
    line:ArcTo(Polar2D(pt1, 180, crad), 1.0)
    line:ArcTo(Polar2D(pt1, 0, crad), 1.0)
    layer:AddObject(CreateCadContour(line), true)    
    
    
end-- function end
-- ===================================================
function DrawWriter(what, where, size, lay)
       DeBug(9430,3, "DrawWriter")
    local job = VectricJob()
    if not job.Exists then
         DisplayMessageBox("No job loaded")
         return false ; 
    end
    local strlen = string.len(what) ; 
    local strup = string.upper(what) ; 
    local x = strlen ; 
    local i = 1 ; 
    local y = "" ; 
    local ptx = where ; 
    while i <=  x do ; 
      y =  string.byte(string.sub(strup, i, i)) ; 
      ptx = CADLeters(job, ptx, y , size, lay) ; 
      i = i + 1 ; 
    end ; 
end-- function end
-- ===================================================
function LoadDialog(job, script_path)
    local registry = Registry("CabinetMaker")
	local html_path = "file:" .. script_path .. "\\CabinetMaker.htm"
    local dialog = HTML_Dialog(false, html_path, 850, 600,      Global.ProgramTitle)
    dialog:AddDoubleField("Milling.RabbitClearnace",                       Milling.RabbitClearnace)  
    dialog:AddDoubleField("Milling.MillClearnace",              Milling.MillClearnace)
    dialog:AddDoubleField("Base.Thickness",                Base.Thickness)   
    dialog:AddDoubleField("Shelf.PinDiameter",                 Shelf.PinDiameter)    
    dialog:AddDoubleField("Base.CabLength",               Base.CabLength)      
    dialog:AddDoubleField("Base.CabHeight",               Base.CabHeight)
    dialog:AddDoubleField("Base.CabDepth",                Base.CabDepth)      
    dialog:AddDoubleField("Base.CabLength",               Base.CabLength)      
    dialog:AddDoubleField("Base.CabHeight",               Base.CabHeight)
    dialog:AddDoubleField("Base.CabDepth",                Base.CabDepth)      
    dialog:AddDoubleField("Base.ThicknessBack",            Base.ThicknessBack)      
    dialog:AddDoubleField("Shelf.PinOuter",                         Shelf.PinOuter)
    dialog:AddDoubleField("Shelf.PinInter",                         Shelf.PinInter)     
    dialog:AddDoubleField("Shelf.EndClarence",                 Shelf.EndClarence)
    dialog:AddDoubleField("Shelf.Count",                       Shelf.Count)
    dialog:AddDoubleField("FaceFrame.StileWidth",                 FaceFrame.StileWidth)     
    dialog:AddDoubleField("FaceFrame.StileWidth",               FaceFrame.StileWidth)      
    dialog:AddDoubleField("FaceFrame.BottomRailWidth",             FaceFrame.BottomRailWidth)
    dialog:AddDoubleField("Shelf.FaceFrameWidth",              Shelf.FaceFrameWidth)
    dialog:AddDoubleField("FaceFrame.FFThickness",               FaceFrame.FFThickness)    
    dialog:AddDoubleField("FaceFrame.TopRailWidth",                FaceFrame.TopRailWidth)
    dialog:AddDoubleField("FaceFrame.CenterStileWidth",             FaceFrame.CenterStileWidth)
    dialog:AddLabelField("Global.ProgramVersion",                    Global.ProgramVersion)
    dialog:AddLabelField("Global.ProgramTitle",                      Global.ProgramTitle)   
    dialog:AddLabelField("Global.CodeBy",                            Global.CodeBy)  
    dialog:AddDoubleField("FaceFrame.BottomFFReveal",           FaceFrame.BottomFFReveal)
    dialog:AddDoubleField("FaceFrame.TopOverlap",              FaceFrame.TopOverlap)
    dialog:AddDoubleField("Shelf.FaceFrameWidth",               Shelf.FaceFrameWidth)
    dialog:AddDoubleField("Shelf.FaceFrameReveal",                     Shelf.FaceFrameReveal)
    dialog:AddDoubleField("Shelf.HoleSpacing",                 Shelf.HoleSpacing)
    dialog:AddDoubleField("Shelf.WidthClearance",              Shelf.WidthClearance)
    dialog:AddDoubleField("Base.ToeKickDepth",                     Base.ToeKickDepth)
    dialog:AddDoubleField("Base.ToeKickHight",                     Base.ToeKickHight)
    dialog:AddDoubleField("FaceFrame.DrawerFrameWidth",               FaceFrame.DrawerFrameWidth)
    dialog:AddDoubleField("Base.ToeKickBottomOffsetHight",         Base.ToeKickBottomOffsetHight)
    dialog:AddDoubleField("Shelf.Count",                        Shelf.Count)
    dialog:AddDoubleField("FaceFrame.DrawerHeight",                FaceFrame.DrawerHeight)   
    dialog:AddDoubleField("FaceFrame.DrawerRowCount",              FaceFrame.DrawerRowCount)
    dialog:AddDoubleField("FaceFrame.NumberDrawersPerRow",         FaceFrame.NumberDrawersPerRow)
    dialog:AddDoubleField("Shelf.PinOuter",                    Shelf.PinOuter)
    dialog:AddDoubleField("Shelf.PinInter",                    Shelf.PinInter)
    dialog:AddDoubleField("Shelf.WidthClearance",               Shelf.WidthClearance)
    dialog:AddDoubleField("FaceFrame.FFReveal",            FaceFrame.FFReveal)
    dialog:AddDoubleField("FaceFrame.StileWidth",         FaceFrame.StileWidth)
    dialog:AddDoubleField("FaceFrame.BottomRailWidth",        FaceFrame.BottomRailWidth)
    dialog:AddDoubleField("FaceFrame.FFThickness",          FaceFrame.FFThickness)
    dialog:AddDoubleField("FaceFrame.TopRailWidth",           FaceFrame.TopRailWidth)
    dialog:AddDoubleField("FaceFrame.CenterStileWidth",        FaceFrame.CenterStileWidth)
    dialog:AddDoubleField("FaceFrame.BottomFFReveal",      FaceFrame.BottomFFReveal)
    dialog:AddDoubleField("Shelf.HoleSpacing",                      Shelf.HoleSpacing)
    dialog:AddDoubleField("Shelf.HoleFirstRowSpacing",              Shelf.HoleFirstRowSpacing)
    dialog:AddDoubleField("Shelf.HoleFirstRowSpacing",      Shelf.HoleFirstRowSpacing)
    dialog:AddDoubleField("Shelf.HoleLastRowSpacing",               Shelf.HoleLastRowSpacing)
    dialog:AddDoubleField("Shelf.HoleLastRowSpacing",          Shelf.HoleLastRowSpacing)
    dialog:AddTextField("Base.AddCenterPanel",                Base.AddCenterPanel)
    dialog:AddTextField("Base.AddCenterFaceFrame",            Base.AddCenterFaceFrame)
    dialog:AddTextField("FaceFrame.AddDrawers",                    FaceFrame.AddDrawers)
    dialog:AddTextField("Base.AddCenterPanel",                        Base.AddCenterPanel)
    dialog:AddTextField("Base.AddCenterFaceFrame",                    Base.AddCenterFaceFrame)
    dialog:AddDirectoryPicker("g_selectJobPath",  "Global.JobPath", true);
	if not dialog:ShowDialog() then
		return false
		-- Done and run ;-)
	end
	local tool = dialog:GetTool("ToolChooseButton")
-- Get the data from the Dialog and update my global variables
    Shelf.PinOuter                      = tonumber(dialog:GetDoubleField("Shelf.PinOuter"))
    Shelf.PinInter                      = tonumber(dialog:GetDoubleField("Shelf.PinInter"))
    Shelf.EndClarence                   = tonumber(dialog:GetDoubleField("Shelf.EndClarence"))
    Base.ThicknessBack                  = tonumber(dialog:GetDoubleField("Base.ThicknessBack"))
    FaceFrame.StileWidth                = tonumber(dialog:GetDoubleField("FaceFrame.StileWidth"))
    FaceFrame.StileWidth                = tonumber(dialog:GetDoubleField("FaceFrame.StileWidth"))
    FaceFrame.BottomRailWidth           = tonumber(dialog:GetDoubleField("FaceFrame.BottomRailWidth"))
    Milling.MillClearnace               = tonumber(dialog:GetDoubleField("Milling.MillClearnace"))
    Milling.RabbitClearnace             = tonumber(dialog:GetDoubleField("Milling.RabbitClearnace"))
    Base.Thickness                      = tonumber(dialog:GetDoubleField("Base.Thickness"))
    Shelf.PinDiameter                   = tonumber(dialog:GetDoubleField("Shelf.PinDiameter"))
    Base.CabLength                      = tonumber(dialog:GetDoubleField("Base.CabLength"))
    Base.CabHeight                      = tonumber(dialog:GetDoubleField("Base.CabHeight"))
    Base.CabDepth                       = tonumber(dialog:GetDoubleField("Base.CabDepth"))
    Base.CabLength                      = tonumber(dialog:GetDoubleField("Base.CabLength"))
    Base.CabHeight                      = tonumber(dialog:GetDoubleField("Base.CabHeight"))
    Base.CabDepth                       = tonumber(dialog:GetDoubleField("Base.CabDepth"))
    Shelf.Count                         = tonumber(dialog:GetDoubleField("Shelf.Count"))
    Shelf.FaceFrameWidth                = tonumber(dialog:GetDoubleField("Shelf.FaceFrameWidth"))
    FaceFrame.FFThickness               = tonumber(dialog:GetDoubleField("FaceFrame.FFThickness"))
    FaceFrame.DrawerFrameWidth          = tonumber(dialog:GetDoubleField("FaceFrame.DrawerFrameWidth"))
    FaceFrame.TopRailWidth              = tonumber(dialog:GetDoubleField("FaceFrame.TopRailWidth"))
    FaceFrame.CenterStileWidth          = tonumber(dialog:GetDoubleField("FaceFrame.CenterStileWidth"))
    FaceFrame.BottomFFReveal            = tonumber(dialog:GetDoubleField("FaceFrame.BottomFFReveal"))
    FaceFrame.TopOverlap                = tonumber(dialog:GetDoubleField("FaceFrame.TopOverlap"))
    Shelf.HoleSpacing                   = tonumber(dialog:GetDoubleField("Shelf.HoleSpacing"))
    Shelf.WidthClearance                = tonumber(dialog:GetDoubleField("Shelf.WidthClearance"))
    Base.ToeKickDepth                   = tonumber(dialog:GetDoubleField("Base.ToeKickDepth"))
    Base.ToeKickHight                   = tonumber(dialog:GetDoubleField("Base.ToeKickHight"))
    Base.ToeKickBottomOffsetHight       = tonumber(dialog:GetDoubleField("Base.ToeKickBottomOffsetHight"))
    Shelf.FaceFrameWidth                = tonumber(dialog:GetDoubleField("Shelf.FaceFrameWidth"))
    Shelf.FaceFrameReveal               = tonumber(dialog:GetDoubleField("Shelf.FaceFrameReveal"))
    Base.AddCenterPanel                 =          dialog:GetTextField("Base.AddCenterPanel")
    Base.AddCenterFaceFrame             =          dialog:GetTextField("Base.AddCenterFaceFrame")
    FaceFrame.AddDrawers                =          dialog:GetTextField("FaceFrame.AddDrawers")
    Shelf.Count                         = tonumber(dialog:GetDoubleField("Shelf.Count"))
    FaceFrame.DrawerHeight              = tonumber(dialog:GetDoubleField("FaceFrame.DrawerHeight"))
    FaceFrame.DrawerRowCount            = tonumber(dialog:GetDoubleField("FaceFrame.DrawerRowCount"))
    FaceFrame.NumberDrawersPerRow       = tonumber(dialog:GetDoubleField("FaceFrame.NumberDrawersPerRow"))
    Shelf.PinOuter                      = tonumber(dialog:GetDoubleField("Shelf.PinOuter"))
    Shelf.PinInter                      = tonumber(dialog:GetDoubleField("Shelf.PinInter"))
    Shelf.WidthClearance                = tonumber(dialog:GetDoubleField("Shelf.WidthClearance"))
    FaceFrame.FFReveal                  = tonumber(dialog:GetDoubleField("FaceFrame.FFReveal"))
    FaceFrame.StileWidth                = tonumber(dialog:GetDoubleField("FaceFrame.StileWidth"))
    FaceFrame.BottomRailWidth           = tonumber(dialog:GetDoubleField("FaceFrame.BottomRailWidth"))
    FaceFrame.FFThickness               = tonumber(dialog:GetDoubleField("FaceFrame.FFThickness"))
    FaceFrame.TopRailWidth              = tonumber(dialog:GetDoubleField("FaceFrame.TopRailWidth"))
    FaceFrame.CenterStileWidth          = tonumber(dialog:GetDoubleField("FaceFrame.CenterStileWidth"))
    FaceFrame.BottomFFReveal            = tonumber(dialog:GetDoubleField("FaceFrame.BottomFFReveal"))
    Shelf.HoleSpacing                   = tonumber(dialog:GetDoubleField("Shelf.HoleSpacing"))
    Shelf.HoleFirstRowSpacing           = tonumber(dialog:GetDoubleField("Shelf.HoleFirstRowSpacing"))
    Shelf.HoleFirstRowSpacing           = tonumber(dialog:GetDoubleField("Shelf.HoleFirstRowSpacing"))
    Shelf.HoleLastRowSpacing            = tonumber(dialog:GetDoubleField("Shelf.HoleLastRowSpacing"))
    Shelf.HoleLastRowSpacing            = tonumber(dialog:GetDoubleField("Shelf.HoleLastRowSpacing"))
    Base.AddCenterPanel                   = dialog:GetTextField("Base.AddCenterPanel")
    Base.AddCenterFaceFrame               = dialog:GetTextField("Base.AddCenterFaceFrame")

    Shelf.PinRadus = Shelf.PinDiameter * 0.5
    
    Milling.ToolSizeDia = 0.25
    Milling.ToolSizeRadus = Milling.ToolSizeDia * 0.50 
    return true
end  -- function end
-- ==============================================================================
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
function DrawNailer(pt, l_r)
end
-- ===================================================
function DrawStretcherPocket(pt, l_r)

end
-- ===================================================
function DrawPinHoles(pt, l_r)

end
-- ===================================================
function DrawDado(pt, o, l, x, y, r, c)
--[[
    pt = 2D point
    o = ordination ("X" or "Y")
    l = layer to be draw on
    x = distance
    y = distance
    r = bit radius
    c = milling clearance
    Call = DrawDado((2,2), "X", "Jim", 0.75, 22.5, 0.125, 0.01)
]]
    if o <= "Y" then
        local cpt = Polar2D( pt, 180, r)
        local pt1 = Polar2D(cpt, 270, ((y * 0.5) + (c * 0.5)))
        local pt2 = Polar2D(pt1,   0, (x + (r * 2.0)))
        local pt3 = Polar2D(pt2,  90, (y + c))
        local pt4 = Polar2D(pt3, 270, (x + (r * 2.0)))
    else
        local cpt = Polar2D( pt, 270, r)
        local pt1 = Polar2D(cpt,   0, ((x * 0.5)+(c * 0.5)))
        local pt2 = Polar2D(pt1,   0, (y + (r * 2.0)))
        local pt3 = Polar2D(pt2,  90, (x + c))
        local pt4 = Polar2D(pt3, 270, (y + (r * 2.0)))
    end
    local layer = job.LayerManager:GetLayerWithName(l) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(pt1) ; 
    line:LineTo(pt2) ; 
    line:LineTo(pt3) ; 
    line:LineTo(pt4) ; 
    line:LineTo(pt1) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function DrawPocket(pt, o, l, x, y, r, c, a)
--[[
    pt = 2D point
    o = ordination ("X" or "Y")
    l = layer to be draw on
    x = distance
    y = distance
    r = bit radius
    c = milling clearance
    a = array of bones {"A", "B", "F", "E"} or { "I", "K"} or {"I", "E", "G"}
    call DrawDado((2,2) "X" ,"Layer-jim" , 0.75, 20.0, 0.125, 0.01)
]]
    if o <= "Y" then
        local cpt = Polar2D( pt, 180, r)
        local pt1 = Polar2D(cpt, 270, ((y * 0.5) + (c * 0.5)))
        local pt2 = Polar2D(pt1,   0, (x + (r * 2.0)))
        local pt3 = Polar2D(pt2,  90, (y + c))
        local pt4 = Polar2D(pt3, 270, (x + (r * 2.0)))
    else
        local cpt = Polar2D( pt, 270, r)
        local pt1 = Polar2D(cpt,   0, ((x * 0.5)+(c * 0.5)))
        local pt2 = Polar2D(pt1,   0, (y + (r * 2.0)))
        local pt3 = Polar2D(pt2,  90, (x + c))
        local pt4 = Polar2D(pt3, 270, (y + (r * 2.0)))
    end
    local layer = job.LayerManager:GetLayerWithName(l) ; 
    local line = Contour(0.0) ; 
    line:AppendPoint(cpt) ; 
    -- A ---------------------------------------  
    if CheckArray("A", a) then
        line:LineTo(Polar2D(pt1, 270, r)) --pta
        line:LineTo(Polar2D(pta,   0, r)) --ptb
        line:LineTo(Polar2D(pt1,  90, r)) --ptc
    end
    -- B ---------------------------------------
    if CheckArray("B", a) then    
        line:LineTo(Polar2D(pt2, 180, r)) --ptd
        line:LineTo(Polar2D(ptd, 270, r)) --pte
        line:LineTo(Polar2D(pte,   0, r)) --ptf
    end
    -- C ---------------------------------------   
    if CheckArray("C", a) then
        line:LineTo(Polar2D(pt2,   0, r)) --ptg
        line:LineTo(Polar2D(ptg,  90, r)) --pth
        line:LineTo(Polar2D(pth, 180, r)) --pti
    end
    -- D ---------------------------------------   
    if CheckArray("D", a) then
        line:LineTo(Polar2D(ct3, 270, r)) --ptj
        line:LineTo(Polar2D(ptj,   0, r)) --ptk
        line:LineTo(Polar2D(ptk,  90, r)) --ptl
    end
    -- E ---------------------------------------   
    if CheckArray("E", a) then
        line:LineTo(Polar2D(pt3,  90, r)) --ptm
        line:LineTo(Polar2D(ptm, 180, r)) --ptn
        line:LineTo(Polar2D(ptn,   0, r)) --pto
    end
    -- F ---------------------------------------   
    if CheckArray("F", a) then
        line:LineTo(Polar2D(pt4, 180, r)) --ptp
        line:LineTo(Polar2D(cpt, 270, r)) --ptq
        line:LineTo(Polar2D(pt1,   0, r)) --ptr
    end
    -- G ---------------------------------------   
    if CheckArray("G", a) then
        line:LineTo(Polar2D(pt4, 180, r)) --pts
        line:LineTo(Polar2D(pt3, 270, r)) --ptt
        line:LineTo(Polar2D(pt1,   0, r)) --ptu
    end
    -- H ---------------------------------------   
    if CheckArray("H", a) then
        line:LineTo(Polar2D(pt1,  90, r)) --ptv
        line:LineTo(Polar2D(ptv, 180, r)) --ptw
        line:LineTo(Polar2D(ptw, 270, r)) --ptx
    end
    -- I ---------------------------------------   
    if CheckArray("I", a) then
        line:LineTo(Polar2D(pt1, 270, r)) --ptaa
        line:LineTo(Polar2D(pt2, 270, r)) --ptbb
    end
    -- J ---------------------------------------   
    if CheckArray("J", a) then
        line:LineTo(Polar2D(pt2,   0, r)) --ptcc
        line:LineTo(Polar2D(pt3,   0, r)) --ptdd
    end
    -- K ---------------------------------------   
    if CheckArray("K", a) then
        line:LineTo(Polar2D(pt3,  90, r)) --ptee
        line:LineTo(Polar2D(pt4,  90, r)) --ptff
    end
    -- L --------------------------------------- 
    if CheckArray("L", a) then    
        line:LineTo(Polar2D(pt1, 180, r)) --ptgg
        line:LineTo(Polar2D(ptv, 180, r)) --pthh
    end
    line:LineTo(cpt) ; 
    layer:AddObject(CreateCadContour(line), true)
end
-- ===================================================
function DrawNailer()

end
-- ===================================================

-- ===================================================
function Polar2D(pt, ang, dis)
       DeBug(9330, 9, "Polar2D")
  return Point2D((pt.X + dis * math.cos(math.rad(ang))), (pt.Y + dis * math.sin(math.rad(ang))))
end-- function end
-- ===================================================
function G_ReadINIProject(xPath, xGroup, xFile)
    DeBug(9290,1, "G_ReadINIProject" )
    BaseDim.BackPocketDepthBase             =  GetIniValue(xPath, xFile, xGroup, "BaseDim.BackPocketDepthBase", "N")
    BaseDim.BlindDadoSetbackBase            =  GetIniValue(xPath, xFile, xGroup, "BaseDim.BlindDadoSetbackBase", "N") 
    BaseDim.CabDepthBase                    =  GetIniValue(xPath, xFile, xGroup, "BaseDim.CabDepthBase", "N") 
    BaseDim.CabHeightBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.CabHeightBase", "N")
    BaseDim.CabWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.CabWidthBase", "N")
    BaseDim.FaceFrameBottomRailWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRailWidthBase", "N") 
    BaseDim.FaceFrameBottomRevealBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameBottomRevealBase", "N")
    BaseDim.FaceFrameCenterStileWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameCenterStileWidthBase", "N")
    BaseDim.FaceFrameRevealBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameRevealBase", "N")
    BaseDim.FaceFrameStileWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameStileWidthBase", "N")
    BaseDim.FaceFrameThicknessBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameThicknessBase", "N")
    BaseDim.FaceFrameTopOverlapBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopOverlapBase", "N")
    BaseDim.FaceFrameTopRailWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.FaceFrameTopRailWidthBase", "N") 
    BaseDim.NailerThicknessBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerThicknessBase", "N")
    BaseDim.NailerWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.NailerWidthBase", "N")
    BaseDim.RevealBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.RevealBase", "N")
    BaseDim.ShelfCountBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfCountBase", "N")
    BaseDim.ShelfEndClarenceBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfEndClarenceBase", "N")
    BaseDim.ShelfFaceFrameThicknessBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameThicknessBase", "N") 
    BaseDim.ShelfFaceFrameWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFaceFrameWidthBase", "N") 
    BaseDim.ShelfFrontClearanceBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfFrontClearanceBase", "N")
    BaseDim.ShelfHoleFirstRowSpacingBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleFirstRowSpacingBase", "N")
    BaseDim.ShelfHoleLastRowSpacingBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleLastRowSpacingBase", "N")
    BaseDim.ShelfHoleSpacingBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfHoleSpacingBase", "N")
    BaseDim.ShelfMaterialThicknessBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfMaterialThicknessBase", "N")
    BaseDim.ShelfPinHoleBackBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleBackBase", "N")
    BaseDim.ShelfPinHoleFrontBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ShelfPinHoleFrontBase", "N")
    BaseDim.StretcherThicknessBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherThicknessBase", "N")
    BaseDim.StretcherWidthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.StretcherWidthBase", "N")
    BaseDim.ThicknessBackBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBackBase", "N")
    BaseDim.ThicknessBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ThicknessBase", "N")
    BaseDim.ToeKickBottomOffsetHightBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickBottomOffsetHightBase", "N")
    BaseDim.ToeKickDepthBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickDepthBase", "N")
    BaseDim.ToeKickHightBase =  GetIniValue(xPath, xFile, xGroup, "BaseDim.ToeKickHightBase", "N") 
    BaseQuestion.AddBackNailerBase =  GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddBackNailerBase",  "B") 
    BaseQuestion.AddCenterPanelBase =  GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddCenterPanelBase",  "B") 
    BaseQuestion.AddFaceFrameBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddFaceFrameBase",  "B") 
    BaseQuestion.AddShelfHingPilotHolesBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHingPilotHolesBase",  "B") 
    BaseQuestion.AddShelfHolesBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfHolesBase",  "B") 
    BaseQuestion.AddShelfingBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddShelfingBase",  "B") 
    BaseQuestion.AddStretchersBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddStretchersBase",  "B") 
    BaseQuestion.AddToeKickBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.AddToeKickBase",  "B") 
    BaseQuestion.BackDadoOrOverlapBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.BackDadoOrOverlapBase", "S") 
    BaseQuestion.DadoStyleBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoStyleBase", "S") 
    BaseQuestion.DadoTypeBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DadoTypeBase", "S") 
    BaseQuestion.DrawBackPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelBase",  "B") 
    BaseQuestion.DrawBackPanelOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBackPanelOnNewSheetBase",  "B") 
    BaseQuestion.DrawBottomPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawBottomPanelBase",  "B") 
    BaseQuestion.DrawCenterPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawCenterPanelBase",  "B") 
    BaseQuestion.DrawFaceFrameBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameBase",  "B") 
    BaseQuestion.DrawFaceFrameOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawFaceFrameOnNewSheetBase",  "B") 
    BaseQuestion.DrawLeftSidePanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawLeftSidePanelBase",  "B") 
    BaseQuestion.DrawRightSidePanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawRightSidePanelBase",  "B") 
    BaseQuestion.DrawShelfPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawShelfPanelBase",  "B") 
    BaseQuestion.DrawTopPanelBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.DrawTopPanelBase",  "B") 
    BaseQuestion.FaceFrameOrStretchersBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.FaceFrameOrStretchersBase",  "B") 
    BaseQuestion.NailerLocationBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.NailerLocationBase", "S") 
    BaseQuestion.ProvideCabinetNotesOnDrawingBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnDrawingBase",  "B") 
    BaseQuestion.ProvideCabinetNotesOnNewSheetBase = GetIniValue(xPath, xFile, xGroup, "BaseQuestion.ProvideCabinetNotesOnNewSheetBase",  "B")  
--    ProjectQuestion.AddCabinetSettingsToProject = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.AddCabinetSettingsToProject",  "B") 
    ProjectQuestion.CabinetName             = GetIniValue(xPath, xFile, xGroup, "ProjectQuestion.CabinetName", "S") 
    Hardware.HingBottomClearnace            =  GetIniValue(xPath, xFile, xGroup, "Hardware.HingBottomClearnace",  "N")  
    Hardware.HingCountBase                  =  GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountBase",  "N")  
    Hardware.HingCountWall                  =  GetIniValue(xPath, xFile, xGroup, "Hardware.HingCountWall",  "N")  
    Hardware.HingTopClearnace               =  GetIniValue(xPath, xFile, xGroup, "Hardware.HingTopClearnace",  "N")  
    Hardware.ShelfPinDiameter               =  GetIniValue(xPath, xFile, xGroup, "Hardware.ShelfPinDiameter",  "N")  
    Hardware.HingHoleCenters                =  GetIniValue(xPath, xFile, xGroup, "Hardware.HingHoleCenters",  "N")  
    Milling.DadoClearnace                   =  GetIniValue(xPath, xFile, xGroup, "Milling.DadoClearnace", "N") 
    Milling.DadoToolDia                     =  GetIniValue(xPath, xFile, xGroup, "Milling.DadoToolDia", "N")  
    Milling.HalfDadoWidth                   =  GetIniValue(xPath, xFile, xGroup, "Milling.HalfDadoWidth", "N") 
    Milling.PilotBitDia                     =  GetIniValue(xPath, xFile, xGroup, "Milling.PilotBitDia", "N")  
    Milling.PocketToolDia                   =  GetIniValue(xPath, xFile, xGroup, "Milling.PocketToolDia", "N") 
    Milling.ProfileToolDia                  =  GetIniValue(xPath, xFile, xGroup, "Milling.ProfileToolDia", "N") 
    Milling.RabbitClearing                  =  GetIniValue(xPath, xFile, xGroup, "Milling.RabbitClearing", "N") 
    Milling.SidePocketDepth                 =  GetIniValue(xPath, xFile, xGroup, "Milling.SidePocketDepth", "N") 
    DeBug(9290,5, "X - 1")    
    WallDim.BackPocketDepthWall             =  GetIniValue(xPath, xFile, xGroup, "WallDim.BackPocketDepthWall", "N")  
    DeBug(9290, 5, "X - 2") 
    WallDim.BlindDadoSetbackWall            =  GetIniValue(xPath, xFile, xGroup, "WallDim.BlindDadoSetbackWall", "N") 
    WallDim.CabDepthWall                    =  GetIniValue(xPath, xFile, xGroup, "WallDim.CabDepthWall", "N") 
    WallDim.CabHeightWall                   =  GetIniValue(xPath, xFile, xGroup, "WallDim.CabHeightWall", "N") 
    WallDim.CabLengthWall                    =  GetIniValue(xPath, xFile, xGroup, "WallDim.CabLengthWall", "N") 
    WallDim.FaceFrameBottomRailWidthWall    =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRailWidthWall", "N") 
    WallDim.FaceFrameBottomRevealWall       =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameBottomRevealWall", "N") 
    WallDim.FaceFrameCenterStileWidthWall   =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameCenterStileWidthWall", "N") 
    WallDim.FaceFrameRevealWall             =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameRevealWall", "N") 
    WallDim.FaceFrameStileWidthWall         =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameStileWidthWall", "N") 
    WallDim.FaceFrameThicknessWall          =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameThicknessWall", "N") 
    WallDim.FaceFrameTopOverlapWall         =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopOverlapWall", "N") 
    WallDim.FaceFrameTopRailWidthWall       =  GetIniValue(xPath, xFile, xGroup, "WallDim.FaceFrameTopRailWidthWall", "N")
    WallDim.NailerThicknessWall             =  GetIniValue(xPath, xFile, xGroup, "WallDim.NailerThicknessWall", "N") 
    WallDim.NailerWidthWall                 =  GetIniValue(xPath, xFile, xGroup, "WallDim.NailerWidthWall", "N") 
    WallDim.RevealWall                      =  GetIniValue(xPath, xFile, xGroup, "WallDim.RevealWall", "N") 
       DeBug(9290,5, " X - 31" )
    WallDim.ShelfCountWall                  =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfCountWall", "N") 
       DeBug(9290,5, " X - 3A1" )
    WallDim.ShelfEndClarenceWall            =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfEndClarenceWall", "N") 
       DeBug(9290,5, " X - 3B1" )
    WallDim.ShelfFaceFrameRevealWall        =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameRevealWall", "N") 
       DeBug(9290,5, " X - 3B2" )
    WallDim.ShelfFaceFrameThicknessWall     =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameThicknessWall", "N") 
       DeBug(9290,5, " X - 3C" )
    WallDim.ShelfFaceFrameWidthWall         =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFaceFrameWidthWall", "N") 
       DeBug(9290,5, " X - 3D" )
    WallDim.ShelfFrontClearanceWall         =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfFrontClearanceWall", "N") 
       DeBug(9290,5, " X - 3E" )
    WallDim.ShelfHoleFirstRowSpacingWall    =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleFirstRowSpacingWall", "N") 
       DeBug(9290,5, " X - 3F" )
    WallDim.ShelfHoleLastRowSpacingWall     =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleLastRowSpacingWall", "N") 
       DeBug(9290,5, " X - 3G" )
    WallDim.ShelfHoleSpacingWall            =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfHoleSpacingWall", "N") 
       DeBug(9290,5, " X - 3H" )
    WallDim.ShelfMaterialThicknessWall      =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfMaterialThicknessWall", "N") 
       DeBug(9290,5, " X - 3I" )
    WallDim.ShelfPinHoleBackWall            =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleBackWall", "N") 
       DeBug(9290,5, " X - 40" )
    WallDim.ShelfPinHoleFrontWall           =   GetIniValue(xPath, xFile, xGroup, "WallDim.ShelfPinHoleFrontWall", "N") 
       DeBug(9290,5, " X - 41" )
    WallDim.StretcherThicknessWall          =   GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherThicknessWall", "N") 
    WallDim.StretcherWidthWall              =   GetIniValue(xPath, xFile, xGroup, "WallDim.StretcherWidthWall", "N") 
       DeBug(9290,5, " X - 42" )
    WallDim.ThicknessBackWall               =   GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessBackWall", "N") 
    WallDim.ThicknessWall                   =   GetIniValue(xPath, xFile, xGroup, "WallDim.ThicknessWall", "N") 
    WallQuestion.AddBackNailerWall          =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddBackNailerWall",  "B") 
       DeBug(9290,5, " X - 43" )
    WallQuestion.AddCenterPanelWall         =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddCenterPanelWall",  "B") 
    WallQuestion.AddFaceFrameWall           =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddFaceFrameWall",  "B") 
       DeBug(9290,5, " X - 44" )
    WallQuestion.AddShelfHingPilotHolesWall =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHingPilotHolesWall",  "B") 
    WallQuestion.AddShelfHolesWall          =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfHolesWall",  "B") 
       DeBug(9290,5, " X - 45" )
    WallQuestion.AddShelfingWall            =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddShelfingWall",  "B") 
    WallQuestion.AddStretchersWall          =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.AddStretchersWall",  "B") 
       DeBug(9290,5, " X - 51" )
    WallQuestion.BackDadoOrOverlapWall      =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.BackDadoOrOverlapWall", "S")
       DeBug(9290,5, " X - 52" )
    WallQuestion.DadoStyleWall              =   GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoStyleWall", "S")
       DeBug(9290,5, " X - 53" )
    WallQuestion.DadoTypeWall               = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DadoTypeWall", "S")
       DeBug(9290,5, " X - 54" )
    WallQuestion.DrawBackPanelOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelOnNewSheetWall",  "B") 
    WallQuestion.DrawBackPanelWall          = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBackPanelWall",  "B") 
       DeBug(9290,5, " X - 55" )
    WallQuestion.DrawBottomPanelWall        = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawBottomPanelWall",  "B") 
       DeBug(9290,5, " X - 56" )
    WallQuestion.DrawCenterPanelWall        = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawCenterPanelWall",  "B") 
       DeBug(9290,5, " X - 57" )
    WallQuestion.DrawFaceFrameOnNewSheetWall = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameOnNewSheetWall",  "B") 
       DeBug(9290,5, " X - 58" )
    WallQuestion.DrawFaceFrameWall          = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawFaceFrameWall",  "B") 
       DeBug(9290,5, " X - 59" )
    WallQuestion.DrawLeftSidePanelWall      = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawLeftSidePanelWall",  "B") 
       DeBug(9290,5, " X - 6" )
    WallQuestion.DrawRightSidePanelWall     = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawRightSidePanelWall",  "B") 
    WallQuestion.DrawShelfPanelWall         = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawShelfPanelWall",  "B") 
    WallQuestion.DrawTopPanelWall           = GetIniValue(xPath, xFile, xGroup, "WallQuestion.DrawTopPanelWall",  "B") 
    WallQuestion.FaceFrameOrStretchersWall  = GetIniValue(xPath, xFile, xGroup, "WallQuestion.FaceFrameOrStretchersWall", "S")
       DeBug(9290,5, " X - 7" )
    WallQuestion.NailerLocationWall         = GetIniValue(xPath, xFile, xGroup, "WallQuestion.NailerLocationWall", "S")
    WallQuestion.ProvideCabinetNotesOnDrawingWall   = GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnDrawingWall",  "B") 
    WallQuestion.ProvideCabinetNotesOnNewSheetWall  = GetIniValue(xPath, xFile, xGroup, "WallQuestion.ProvideCabinetNotesOnNewSheetWall",  "B") 
       DeBug(9290,5, " X - 8" )
    return true
end
-- ===================================================
function all_trim(s) -- Trims spaces off both ends of a string
       DeBug(9300, 9, "G_ReadINIProject" )
    return s:match( "^%s*(.-)%s*$" )
end
-- ===================================================
function length_of_file(filename)-- Returns file line count
--[[
Counts the lines in a file
returns a number
]]
       DeBug(9270,5, "length_of_file " .. filename)
    local len = 0
    local file = io.open(filename)
    for Line in file:lines() do
        len = len + 1
    end
       DeBug(9271,5, "File length = " .. tostring(len)) 
    file:close() ; 
    return len 
end 
-- ===================================================
function NewSheet(job)
    local layer_manager = job.LayerManager
    -- get current sheet count - note sheet 0 the default sheet counts as one sheet
	local orig_num_sheets = layer_manager.NumberOfSheets
	 -- get current active sheet index
	local orig_active_sheet_index = layer_manager.ActiveSheetIndex
	-- set active sheet to last sheet
	local num_sheets = layer_manager.NumberOfSheets
	layer_manager.ActiveSheetIndex = num_sheets - 1
	job:Refresh2DView();
	-- Add a new sheet
    layer_manager:AddNewSheet()
	-- set active sheet to last sheet we just added
	num_sheets = layer_manager.NumberOfSheets
	layer_manager.ActiveSheetIndex = num_sheets - 1
    job:Refresh2DView();
 end
-- ===================================================
function GetIniValue(xPath, FileName, GroupName, ItemName, ValueType) 
--  XX.YY =  GetIniValue(xPath, FileName, GroupName, "XX.YY", "N") 
       DeBug(9220,3, "GetIniValu")
       DeBug(9221, 3, "FileName ".. FileName)
       DeBug(9222, 3, "GroupName ".. string.upper(GroupName))
       DeBug(9223, 3, "ItemName ".. ItemName)
       DeBug(9224, 3, "ValueType ".. ValueType)
    local filenameR = xPath .. "/" .. FileName .. ".ini"
    local FL = length_of_file(filenameR)
    local file = io.open(filenameR, "r")  
    local dat = "."  
    local ItemNameLen = string.len(ItemName) ; 
       DeBug(9225, 6, "--1 Length of = " .. tostring(FL))
    while (FL >=  1) do        
        dat = all_trim(file:read()) ; 
        if dat ==  "[" .. string.upper(GroupName) .. "]" then
           DeBug(9226, 4, "------------ Found Group ------------")
            break
        else
            FL = FL - 1
        end        
    end
       DeBug(9227,6, "--2")
    
    while (FL >=  1) do        
        dat = all_trim(file:read()) ; 
                DeBug(9227, 9, tostring(FL))
        if ItemName ==  string.sub(dat, 1, ItemNameLen)  then
               DeBug(9226, 4, "------------ Found Item ------------")
            break
        else
            FL = FL - 1
            if FL == 0 then
                dat = "Error - item not  found                                                                    "
                break
            end
        end        
    end  
       DeBug(9228,5, "--3")
    file:close()-- closes the open file
    local XX = StrIniValue(dat, ValueType)
    return XX
end
-- ===================================================
function InquiryTextBox(Header, Quest, Defaltxt)
--[[
    TextBox for user input with default value
    Caller = local x = InquiryTextBox("Cabinet Maker", "Enter your last name?", "Anderson")
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    Default Question = Anderson
    Returns = String
]]
    local myHtml = [[ <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css">  html {overflow: auto ; } body { background-color: #EBEBEB ; }body, td, th {font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; color: #000 ; } .FormButton {font-weight: bold ; width: 100% ; font-family: Arial, Helvetica, sans-serif ; font-size: 12px ; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Questions"> <strong> Message Here</strong> </td> </tr> <tr> <th width = "48" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"></th> <th width = "416" colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB"> <input name = "qInput" type = "text" id = "qInput" size = "65"> </th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle" bgcolor = "#EBEBEB"> <table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%"></td> <td style = "width: 20%"></td> <td style = "width: 25%"></td> <td style = "width: 15%"> <input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"> </td> <td style = "width: 15%"> <input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"> </td> </tr> </table> </td> </tr> </table> </body> 
    </html>]] ; local dialog = HTML_Dialog(true, myHtml, 525, 160, Header) ; dialog:AddLabelField("Questions", Quest) ; dialogAddTextField("qInput", Defaltxt) ; if not dialog:ShowDialog() then ; return "" ; else ; return dialog:GetTextField("qInput") ; end    
end
-- ===================================================
function InquiryPathBox(Header, Quest, Defaltxt)
       DeBug(9230,1, "InquiryPathBox")
--[[
    PathBox for user input with DEFAULT path value
    Caller: local z = InquiryPathBox("Cabinet Maker", "Job Path", ProjectQuestion.JobPath)
    DisplayMessageBox(z) 
    Dialog Header = "Cabinet Maker"
    User Question = "Enter your last name?"
    DEFAULT Question = Anderson
    Returns = String
]]
    local myHtml  = [[<!DOCTYPE HTML PUBLIC"-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> <html> <head> <meta content = "text/html; charset = iso-8859-1" http-equiv = "Content-Type"> <title>Cabinet Maker and Tool-path Creator</title> <style type = "text/css"> html { overflow: auto; } body, td, th { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #000; } .FormButton { font-weight: bold; width: 100%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; } .h1 { font-size: 14px; font-weight: bold; } .h2 { font-size: 12px; font-weight: bold; } .h3 { font-size: 10px; font-weight: bold; } body { background-color: #EBEBEB; }</style> </head> <body bgcolor = "#EBEBEB" text = "#000000"> <table width = "470" border = "0" cellpadding = "0"> <tr> <td colspan = "3" align = "left" valign = "middle" bgcolor = "#EBEBEB" class = "h2" id = "Questions">Message Here</strong></td> </tr> <tr> <th width = "48" align = "right" valign = "middle" bgcolor = "#EBEBEB" id = "QuestionID"> <input id = "DirectoryPicker" class = "DirectoryPicker" name = "DirectoryPicker" type = "button" value = "Path..."> </th> <th width = "416" colspan = "2" align = "left" valign = "middle" bgcolor = "#EBEBEB" id = "Contact"> <input name = "DInput" type = "text" id = "DInput" size = "65"> </th> </tr> <tr> <td colspan = "3" align = "center" valign = "middle"><table border = "0" width = "100%"> <tr align = "right"> <td style = "width: 20%">&nbsp ; </td> <td style = "width: 20%">&nbsp ; </td> <td style = "width: 25%">&nbsp ; </td> <td style = "width: 15%"><input id = "ButtonCancel" class = "FormButton" name = "ButtonCancel" type = "button" value = "Cancel"></td> <td style = "width: 15%"><input id = "ButtonOK" class = "FormButton" name = "ButtonOK" type = "button" value = "OK"></td> </tr> </table></td> </tr> </table> </body> </html>]]
    local dialog = HTML_Dialog(true, myHtml, 525, 160, Header) ;     dialog:AddLabelField("Questions", Quest) ;     dialog:AddTextField("DInput", Defaltxt) ;     dialog:AddDirectoryPicker("DirectoryPicker",  "DInput", true) ;     if not dialog:ShowDialog() then ; return "" ;     else ;         return dialog:GetTextField("DInput") ;    end    
end
-- ===================================================
function StdFileWriter(xPath, Fname, CabNames) 
       DeBug(9240,1, "StdFileWriter")
--[[
    Adds Standard Upper Wall Cabinet to the INI file 
    xPath = script_path
    Names  =  Group Name
    Returns = true
]]
    local file = io.open(xPath .. "/" .. Fname .. ".ini", "a") ; 
    file:write("[" .. string.upper(CabNames) .. "]\n") ; 
        DeBug(9240,1, "StdFileWriter 1")
    file:write("BaseDim.BackPocketDepthBase  = "..           tostring(BaseDim.BackPocketDepthBase )   .. "   \n") ;
    file:write("BaseDim.BlindDadoSetbackBase  = "..           tostring(BaseDim.BlindDadoSetbackBase )   .. "   \n") ;
    file:write("BaseDim.CabDepthBase  = "..           tostring(BaseDim.CabDepthBase )   .. "   \n") ;
    file:write("BaseDim.CabHeightBase  = "..           tostring(BaseDim.CabHeightBase )   .. "   \n") ;
    file:write("BaseDim.CabWidthBase  = "..           tostring(BaseDim.CabWidthBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameBottomRailWidthBase  = "..           tostring(BaseDim.FaceFrameBottomRailWidthBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameBottomRevealBase  = "..           tostring(BaseDim.FaceFrameBottomRevealBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameCenterStileWidthBase  = "..           tostring(BaseDim.FaceFrameCenterStileWidthBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameRevealBase  = "..           tostring(BaseDim.FaceFrameRevealBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameStileWidthBase  = "..           tostring(BaseDim.FaceFrameStileWidthBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameThicknessBase  = "..           tostring(BaseDim.FaceFrameThicknessBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameTopOverlapBase  = "..           tostring(BaseDim.FaceFrameTopOverlapBase )   .. "   \n") ;
    file:write("BaseDim.FaceFrameTopRailWidthBase  = "..           tostring(BaseDim.FaceFrameTopRailWidthBase )   .. "   \n") ;
    file:write("BaseDim.NailerThicknessBase  = "..           tostring(BaseDim.NailerThicknessBase )   .. "   \n") ;
    file:write("BaseDim.NailerWidthBase  = "..           tostring(BaseDim.NailerWidthBase )   .. "   \n") ;
    file:write("BaseDim.RevealBase  = "..           tostring(BaseDim.RevealBase )   .. "   \n") ;
    file:write("BaseDim.ShelfCountBase  = "..           tostring(BaseDim.ShelfCountBase )   .. "   \n") ;
    file:write("BaseDim.ShelfEndClarenceBase  = "..           tostring(BaseDim.ShelfEndClarenceBase )   .. "   \n") ;
    file:write("BaseDim.ShelfFaceFrameThicknessBase  = "..           tostring(BaseDim.ShelfFaceFrameThicknessBase )   .. "   \n") ;
    file:write("BaseDim.ShelfFaceFrameWidthBase  = "..           tostring(BaseDim.ShelfFaceFrameWidthBase )   .. "   \n") ;
    file:write("BaseDim.ShelfFrontClearanceBase  = "..           tostring(BaseDim.ShelfFrontClearanceBase )   .. "   \n") ;
    file:write("BaseDim.ShelfHoleFirstRowSpacingBase  = "..           tostring(BaseDim.ShelfHoleFirstRowSpacingBase )   .. "   \n") ;
    file:write("BaseDim.ShelfHoleLastRowSpacingBase  = "..           tostring(BaseDim.ShelfHoleLastRowSpacingBase )   .. "   \n") ;
    file:write("BaseDim.ShelfHoleSpacingBase  = "..           tostring(BaseDim.ShelfHoleSpacingBase )   .. "   \n") ;
    file:write("BaseDim.ShelfMaterialThicknessBase  = "..           tostring(BaseDim.ShelfMaterialThicknessBase )   .. "   \n") ;
    file:write("BaseDim.ShelfPinHoleBackBase  = "..           tostring(BaseDim.ShelfPinHoleBackBase )   .. "   \n") ;
    file:write("BaseDim.ShelfPinHoleFrontBase  = "..           tostring(BaseDim.ShelfPinHoleFrontBase )   .. "   \n") ;
    file:write("BaseDim.StretcherThicknessBase  = "..           tostring(BaseDim.StretcherThicknessBase )   .. "   \n") ;
    file:write("BaseDim.StretcherWidthBase  = "..           tostring(BaseDim.StretcherWidthBase )   .. "   \n") ;
    file:write("BaseDim.ThicknessBackBase  = "..           tostring(BaseDim.ThicknessBackBase )   .. "   \n") ;
    file:write("BaseDim.ThicknessBase  = "..           tostring(BaseDim.ThicknessBase )   .. "   \n") ;
    file:write("BaseDim.ToeKickBottomOffsetHightBase  = "..     tostring(BaseDim.ToeKickBottomOffsetHightBase )   .. "   \n") ;
    file:write("BaseDim.ToeKickDepthBase  = "..                 tostring(BaseDim.ToeKickDepthBase )   .. "   \n") ;
    file:write("BaseDim.ToeKickHightBase  = "..                 tostring(BaseDim.ToeKickHightBase )   .. "   \n") ;
    file:write("BaseQuestion.AddBackNailerBase  = "..           tostring(BaseQuestion.AddBackNailerBase )   .. "   \n") ;
    file:write("BaseQuestion.AddCenterPanelBase  = "..          tostring(BaseQuestion.AddCenterPanelBase )   .. "   \n") ;
    file:write("BaseQuestion.AddFaceFrameBase  = "..            tostring(BaseQuestion.AddFaceFrameBase )   .. "   \n") ;
    file:write("BaseQuestion.AddShelfHingPilotHolesBase  = "..  tostring(BaseQuestion.AddShelfHingPilotHolesBase )   .. "   \n") ;
    file:write("BaseQuestion.AddShelfHolesBase  = "..           tostring(BaseQuestion.AddShelfHolesBase )   .. "   \n") ;
    file:write("BaseQuestion.AddShelfingBase  = "..             tostring(BaseQuestion.AddShelfingBase )   .. "   \n") ;
    file:write("BaseQuestion.AddStretchersBase  = "..           tostring(BaseQuestion.AddStretchersBase )   .. "   \n") ;
    file:write("BaseQuestion.AddToeKickBase  = "..              tostring(BaseQuestion.AddToeKickBase )   .. "   \n") ;
    file:write("BaseQuestion.BackDadoOrOverlapBase  = "..       tostring(BaseQuestion.BackDadoOrOverlapBase )   .. "   \n") ;
    file:write("BaseQuestion.DadoStyleBase  = "..               tostring(BaseQuestion.DadoStyleBase )   .. "   \n") ;
    file:write("BaseQuestion.DadoTypeBase  = "..                tostring(BaseQuestion.DadoTypeBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawBackPanelBase  = "..           tostring(BaseQuestion.DrawBackPanelBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawBackPanelOnNewSheetBase  = ".. tostring(BaseQuestion.DrawBackPanelOnNewSheetBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawBottomPanelBase  = "..         tostring(BaseQuestion.DrawBottomPanelBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawCenterPanelBase  = "..         tostring(BaseQuestion.DrawCenterPanelBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawFaceFrameBase  = "..           tostring(BaseQuestion.DrawFaceFrameBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawFaceFrameOnNewSheetBase  = ".. tostring(BaseQuestion.DrawFaceFrameOnNewSheetBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawLeftSidePanelBase  = "..       tostring(BaseQuestion.DrawLeftSidePanelBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawRightSidePanelBase  = "..      tostring(BaseQuestion.DrawRightSidePanelBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawShelfPanelBase  = "..          tostring(BaseQuestion.DrawShelfPanelBase )   .. "   \n") ;
    file:write("BaseQuestion.DrawTopPanelBase  = "..            tostring(BaseQuestion.DrawTopPanelBase )   .. "   \n") ;
    file:write("BaseQuestion.FaceFrameOrStretchersBase  = "..   tostring(BaseQuestion.FaceFrameOrStretchersBase )   .. "   \n") ;
    file:write("BaseQuestion.NailerLocationBase  = "..          tostring(BaseQuestion.NailerLocationBase )   .. "   \n") ;
    file:write("BaseQuestion.ProvideCabinetNotesOnDrawingBase  = "..    tostring(BaseQuestion.ProvideCabinetNotesOnDrawingBase )   .. "   \n") ;
    file:write("BaseQuestion.ProvideCabinetNotesOnNewSheetBase  = "..   tostring(BaseQuestion.ProvideCabinetNotesOnNewSheetBase )   .. "   \n") ;
    file:write("Hardware.HingBottomClearnace  = "..           tostring(Hardware.HingBottomClearnace )   .. "   \n") ;
    file:write("Hardware.HingCountBase  = "..           tostring(Hardware.HingCountBase )   .. "   \n") ;
    file:write("Hardware.HingCountWall  = "..           tostring(Hardware.HingCountWall )   .. "   \n") ;
    file:write("Hardware.HingHoleCenters  = "..           tostring(Hardware.HingHoleCenters )   .. "   \n") ;
    file:write("Hardware.HingTopClearnace  = "..           tostring(Hardware.HingTopClearnace )   .. "   \n") ;
    file:write("Hardware.ShelfPinDiameter  = "..           tostring(Hardware.ShelfPinDiameter )   .. "   \n") ;
    file:write("Milling.DadoClearnace  = "..           tostring(Milling.DadoClearnace )   .. "   \n") ;
    file:write("Milling.DadoToolDia  = "..           tostring(Milling.DadoToolDia )   .. "   \n") ;
    file:write("Milling.HalfDadoWidth  = "..           tostring(Milling.HalfDadoWidth )   .. "   \n") ;
    file:write("Milling.PilotBitDia  = "..           tostring(Milling.PilotBitDia )   .. "   \n") ;
    file:write("Milling.PocketToolDia  = "..           tostring(Milling.PocketToolDia )   .. "   \n") ;
    file:write("Milling.ProfileToolDia  = "..           tostring(Milling.ProfileToolDia )   .. "   \n") ;
    file:write("Milling.RabbitClearing  = "..           tostring(Milling.RabbitClearing )   .. "   \n") ;
    file:write("Milling.SidePocketDepth  = "..           tostring(Milling.SidePocketDepth )   .. "   \n") ;
    file:write("Milling.LayerNameSideProfile  = "..           tostring(Milling.LayerNameSideProfile )   .. "   \n") ;   
    file:write("Milling.LayerNameShelfProfile  = "..           tostring(Milling.LayerNameShelfProfile )   .. "   \n") ;   
    file:write("Milling.LayerNameBackProfile  = "..           tostring(Milling.LayerNameBackProfile )   .. "   \n") ;   
    file:write("Milling.LayerNameTopBottomProfile  = "..           tostring(Milling.LayerNameTopBottomProfile )   .. "   \n") ;   
    file:write("Milling.LayerNameCenterPanleProfile  = "..           tostring(Milling.LayerNameCenterPanleProfile )   .. "   \n") ;   
    file:write("Milling.LayerNameSideTopBottomPocket  = "..           tostring(Milling.LayerNameSideTopBottomPocket )   .. "   \n") ;   
    file:write("Milling.LayerNameSideBackPocket  = "..           tostring(Milling.LayerNameSideBackPocket )   .. "   \n") ;   
    file:write("Milling.LayerNameSideStretcherPocket  = "..           tostring(Milling.LayerNameSideStretcherPocket )   .. "   \n") ;   
    file:write("Milling.LayerNameSideNailerPocket  = "..           tostring(Milling.LayerNameSideNailerPocket )   .. "   \n") ;   
    file:write("Milling.LayerNameSideShelfPinDrill  = "..           tostring(Milling.LayerNameSideShelfPinDrill )   .. "   \n") ;   
    file:write("Milling.LayerNameSideHingCentersDrill  = "..           tostring(Milling.LayerNameSideHingCentersDrill )   .. "   \n") ;   
    file:write("Milling.LayerNameCenterPanleShelfPinDrill  = "..           tostring(Milling.LayerNameCenterPanleShelfPinDrill )   .. "   \n") ;   
    file:write("Milling.LayerNameBackPocket  = "..           tostring(Milling.LayerNameBackPocket )   .. "   \n") ;   
    file:write("Milling.LayerNameTopBottomCenterDado  = "..           tostring(Milling.LayerNameTopBottomCenterDado )   .. "   \n") ;   
    file:write("Milling.LayerNameDrawNotes  = "..           tostring(Milling.LayerNameDrawNotes )   .. "   \n") ;   
    file:write("Milling.LayerNameDrawFaceFrame  = "..           tostring(Milling.LayerNameDrawFaceFrame )   .. "   \n") ;   
--     file:write("ProjectQuestion.AddCabinetSettingsToProject  = "..           tostring(ProjectQuestion.AddCabinetSettingsToProject )   .. "   \n") ;
    file:write("ProjectQuestion.CabinetName  = "..           tostring(ProjectQuestion.CabinetName )   .. "   \n") ;
    file:write("ProjectQuestion.ProjectContactEmail  = "..           tostring(ProjectQuestion.ProjectContactEmail )   .. "   \n") ;
    file:write("ProjectQuestion.ProjectContactName  = "..           tostring(ProjectQuestion.ProjectContactName )   .. "   \n") ;
    file:write("ProjectQuestion.ProjectContactPhoneNumber  = "..           tostring(ProjectQuestion.ProjectContactPhoneNumber )   .. "   \n") ;
    file:write("ProjectQuestion.ProjectName  = "..           tostring(ProjectQuestion.ProjectName )   .. "   \n") ;
    file:write("ProjectQuestion.ProjectPath  = "..           tostring(ProjectQuestion.ProjectPath )   .. "   \n") ;
    file:write("ProjectQuestion.StartDate  = "..           tostring(ProjectQuestion.StartDate )   .. "   \n") ;
    file:write("WallDim.BackPocketDepthWall  = "..           tostring(WallDim.BackPocketDepthWall )   .. "   \n") ;
    file:write("WallDim.BlindDadoSetbackWall  = "..           tostring(WallDim.BlindDadoSetbackWall )   .. "   \n") ;
    file:write("WallDim.CabDepthWall  = "..           tostring(WallDim.CabDepthWall )   .. "   \n") ;
    file:write("WallDim.CabHeightWall  = "..           tostring(WallDim.CabHeightWall )   .. "   \n") ;
    file:write("WallDim.CabLengthWall  = "..           tostring(WallDim.CabLengthWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameBottomRailWidthWall  = "..           tostring(WallDim.FaceFrameBottomRailWidthWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameBottomRevealWall  = "..           tostring(WallDim.FaceFrameBottomRevealWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameCenterStileWidthWall  = "..           tostring(WallDim.FaceFrameCenterStileWidthWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameRevealWall  = "..           tostring(WallDim.FaceFrameRevealWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameStileWidthWall  = "..           tostring(WallDim.FaceFrameStileWidthWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameThicknessWall  = "..           tostring(WallDim.FaceFrameThicknessWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameTopOverlapWall  = "..           tostring(WallDim.FaceFrameTopOverlapWall )   .. "   \n") ;
    file:write("WallDim.FaceFrameTopRailWidthWall  = "..           tostring(WallDim.FaceFrameTopRailWidthWall )   .. "   \n") ;
    file:write("WallDim.NailerThicknessWall  = "..           tostring(WallDim.NailerThicknessWall )   .. "   \n") ;
    file:write("WallDim.NailerWidthWall  = "..           tostring(WallDim.NailerWidthWall )   .. "   \n") ;
    file:write("WallDim.RevealWall  = "..           tostring(WallDim.RevealWall )   .. "   \n") ;
    file:write("WallDim.ShelfCountWall  = "..           tostring(WallDim.ShelfCountWall )   .. "   \n") ;
    file:write("WallDim.ShelfEndClarenceWall  = "..           tostring(WallDim.ShelfEndClarenceWall )   .. "   \n") ;
    file:write("WallDim.ShelfFaceFrameRevealWall  = "..           tostring(WallDim.ShelfFaceFrameRevealWall )   .. "   \n") ;
    file:write("WallDim.ShelfFaceFrameThicknessWall  = "..           tostring(WallDim.ShelfFaceFrameThicknessWall )   .. "   \n") ;
    file:write("WallDim.ShelfFaceFrameWidthWall  = "..           tostring(WallDim.ShelfFaceFrameWidthWall )   .. "   \n") ;
    file:write("WallDim.ShelfFrontClearanceWall  = "..           tostring(WallDim.ShelfFrontClearanceWall )   .. "   \n") ;
    file:write("WallDim.ShelfHoleFirstRowSpacingWall  = "..           tostring(WallDim.ShelfHoleFirstRowSpacingWall )   .. "   \n") ;
    file:write("WallDim.ShelfHoleLastRowSpacingWall  = "..           tostring(WallDim.ShelfHoleLastRowSpacingWall )   .. "   \n") ;
    file:write("WallDim.ShelfHoleSpacingWall  = "..           tostring(WallDim.ShelfHoleSpacingWall )   .. "   \n") ;
    file:write("WallDim.ShelfMaterialThicknessWall  = "..           tostring(WallDim.ShelfMaterialThicknessWall )   .. "   \n") ;
    file:write("WallDim.ShelfPinHoleBackWall  = "..           tostring(WallDim.ShelfPinHoleBackWall )   .. "   \n") ;
    file:write("WallDim.ShelfPinHoleFrontWall  = "..           tostring(WallDim.ShelfPinHoleFrontWall )   .. "   \n") ;
    file:write("WallDim.StretcherThicknessWall  = "..           tostring(WallDim.StretcherThicknessWall )   .. "   \n") ;
    file:write("WallDim.StretcherWidthWall  = "..           tostring(WallDim.StretcherWidthWall )   .. "   \n") ;
    file:write("WallDim.ThicknessBackWall  = "..           tostring(WallDim.ThicknessBackWall )   .. "   \n") ;
    file:write("WallDim.ThicknessWall  = "..           tostring(WallDim.ThicknessWall )   .. "   \n") ;
    file:write("WallQuestion.AddBackNailerWall  = "..           tostring(WallQuestion.AddBackNailerWall )   .. "   \n") ;
    file:write("WallQuestion.AddCenterPanelWall  = "..           tostring(WallQuestion.AddCenterPanelWall )   .. "   \n") ;
    file:write("WallQuestion.AddFaceFrameWall  = "..                    tostring(WallQuestion.AddFaceFrameWall )   .. "   \n") ;
    file:write("WallQuestion.AddShelfHingPilotHolesWall  = "..          tostring(WallQuestion.AddShelfHingPilotHolesWall )   .. "   \n") ;
    file:write("WallQuestion.AddShelfHolesWall  = "..                   tostring(WallQuestion.AddShelfHolesWall )   .. "   \n") ;
    file:write("WallQuestion.AddShelfingWall  = "..                     tostring(WallQuestion.AddShelfingWall )   .. "   \n") ;
    file:write("WallQuestion.AddStretchersWall  = "..                   tostring(WallQuestion.AddStretchersWall )   .. "   \n") ;
    file:write("WallQuestion.BackDadoOrOverlapWall  = "..               tostring(WallQuestion.BackDadoOrOverlapWall )   .. "   \n") ;
    file:write("WallQuestion.DadoStyleWall  = "..                       tostring(WallQuestion.DadoStyleWall )   .. "   \n") ;
    file:write("WallQuestion.DadoTypeWall  = "..                        tostring(WallQuestion.DadoTypeWall )   .. "   \n") ;
    file:write("WallQuestion.DrawBackPanelOnNewSheetWall  = "..         tostring(WallQuestion.DrawBackPanelOnNewSheetWall )   .. "   \n") ;
    file:write("WallQuestion.DrawBackPanelWall  = "..                   tostring(WallQuestion.DrawBackPanelWall )   .. "   \n") ;
    file:write("WallQuestion.DrawBottomPanelWall  = "..                 tostring(WallQuestion.DrawBottomPanelWall )   .. "   \n") ;
    file:write("WallQuestion.DrawCenterPanelWall  = "..                 tostring(WallQuestion.DrawCenterPanelWall )   .. "   \n") ;
    file:write("WallQuestion.DrawFaceFrameOnNewSheetWall  = "..         tostring(WallQuestion.DrawFaceFrameOnNewSheetWall )   .. "   \n") ;
    file:write("WallQuestion.DrawFaceFrameWall  = "..                   tostring(WallQuestion.DrawFaceFrameWall )   .. "   \n") ;
    file:write("WallQuestion.DrawLeftSidePanelWall  = "..               tostring(WallQuestion.DrawLeftSidePanelWall )   .. "   \n") ;
    file:write("WallQuestion.DrawRightSidePanelWall  = "..              tostring(WallQuestion.DrawRightSidePanelWall )   .. "   \n") ;
    file:write("WallQuestion.DrawShelfPanelWall  = "..                  tostring(WallQuestion.DrawShelfPanelWall )   .. "   \n") ;
    file:write("WallQuestion.DrawTopPanelWall  = "..                    tostring(WallQuestion.DrawTopPanelWall )   .. "   \n") ;
    file:write("WallQuestion.FaceFrameOrStretchersWall  = "..           tostring(WallQuestion.FaceFrameOrStretchersWall )   .. "   \n") ;
    file:write("WallQuestion.NailerLocationWall  = "..                  tostring(WallQuestion.NailerLocationWall )   .. "   \n") ;
    file:write("WallQuestion.ProvideCabinetNotesOnDrawingWall  = "..    tostring(WallQuestion.ProvideCabinetNotesOnDrawingWall )   .. "   \n") ;
    file:write("WallQuestion.ProvideCabinetNotesOnNewSheetWall = "..    tostring(WallQuestion.ProvideCabinetNotesOnNewSheetWall)   .. "   \n") ;
        DeBug(9240,1, "StdFileWriter 5")   
    file:write("#============================ \n") ; 
    file:close()-- closes the open file 
       DeBug(9240,1, "StdFileWriter 6")
    return true
end
-- ==============================================================================
function WriteRegistryStandardCabinetList() -- Write to Registry values
    local RegistryWrite = Registry("CabinetMaker") ;  
    local RegValue  = RegistryWrite:SetString("ProgramCodeBy",      "James Anderson") ; 
    RegValue        = RegistryWrite:SetString("ProgramContact",     "James.L.Anderson@outlook.com") ; 
    RegValue        = RegistryWrite:SetString("ProgramName",        "Cabinet Maker") ;
    RegValue        = RegistryWrite:SetString("ProgramVersion",     "Version 1.3") ; 
    RegValue        = RegistryWrite:SetString("ProgramYear",        "2019") ; 
    RegValue        = RegistryWrite:SetString("ProjectCabinetBase", "Default" ) ;    
    RegValue        = RegistryWrite:SetString("ProjectCabinetWall", "Default" ) ;     
    RegValue        = RegistryWrite:SetString("ProjectName",        "Default" ) ;
    RegValue        = RegistryWrite:SetString("ProjectPath",        "C:/test") ;
end
-- ==============================================================================
function ReadRegistryStandardCabinetList() -- Read from Registry values
    local RegistryRead = Registry("CabinetMaker") ; 
    ProjectQuestion.ProgramCodeBy       = RegistryRead:GetString("ProgramCodeBy",       ".") ; 
    ProjectQuestion.ProgramContact      = RegistryRead:GetString("ProgramContact",      ".") ; 
    ProjectQuestion.ProgramName         = RegistryRead:GetString("ProgramName",         ".") ;
    ProjectQuestion.ProgramVersion      = RegistryRead:GetString("ProgramVersion",      ".") ; 
    ProjectQuestion.ProgramYear         = RegistryRead:GetString("ProgramYear",         ".") ; 
    ProjectQuestion.ProjectCabinetBase  = RegistryRead:GetString("ProjectCabinetBase",  ".") ;    
    ProjectQuestion.ProjectCabinetWall  = RegistryRead:GetString("ProjectCabinetWall",  ".") ;     
    ProjectQuestion.ProjectName         = RegistryRead:GetString("ProjectName",         ".") ;
    ProjectQuestion.ProjectPath         = RegistryRead:GetString("ProjectPath",         ".") ;
end
-- ==============================================================================
function main(script_path)
    -- create a layer with passed name if it doesn't already exist
    ReadRegistryStandardCabinetList()
    DisplayMessageBox(ProjectQuestion.ProjectName)
    if "." == ProjectQuestion.ProjectName then
        WriteRegistryStandardCabinetList()
        ReadRegistryStandardCabinetList()
    end
    DisplayMessageBox(ProjectQuestion.ProjectName)
    DisplayMessageBox("Done")
    return true 
end
-- ==============================================================================