-- VECTRIC LUA SCRIPT
local M = {}

  M.printhello = function()
    print("hello")
  end
  -- =================================
  M.james = function()
    return "{3,4,6,2,3,5}" 
  end
  -- =================================
  M.bob = function (a,b)
    return a+b
    end
  -- =================================
  M.jim = function()
    -- print("Jim Anderson") 
    DisplayMessageBox("Jim")
  end
-- =================================
return M