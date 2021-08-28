-- ==============================================================================
function ReadRegistry(ObjName)
    local RegistryRead = Registry(ObjName.RegistryName)
    ObjName.ProgramTitle = RegistryRead:GetString("ProgramTitle", ObjName.ProgramTitle)
    ObjName.ProgramName = RegistryRead:GetString("ProgramName",ObjName.ProgramName)
    ObjName.ProgramVersion = RegistryRead:GetString("ProgramVersion",ObjName.ProgramVersion)
    ObjName.CodeBy = RegistryRead:GetString("CodeBy", ObjName.CodeBy)
    ObjName.Contact = RegistryRead:GetString("Contact", ObjName.Contact)
    ObjName.Year = RegistryRead:GetString("Year",  ObjName.Year)
    ObjName.JobPath = RegistryRead:GetString("JobPath",  ObjName.JobPath)
end
-- ==============================================================================
function Save2Registry(ObjName)
    local RegistryWrite = Registry(ObjName.RegistryName)
    RegistryWrite:SetString("ProgramTitle", ObjName.ProgramTitle) 
    RegistryWrite:SetString("ProgramName", ObjName.ProgramName) 
    RegistryWrite:SetString("ProgramVersion", ObjName.ProgramVersion) 
    RegistryWrite:SetString("CodeBy", ObjName.CodeBy) 
    RegistryWrite:SetString("Contact", ObjName.Contact) 
    RegistryWrite:SetString("Year", ObjName.Year) 
    RegistryWrite:SetString("JobPath", ObjName.JobPath)
end
-- ==============================================================================