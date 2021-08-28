-- VECTRIC LUA SCRIPT
--require("mobdebug").start()
require("strict")

function Trig(A, B, AB, AC, BC)
  -- Call = A, B, AB, AC, BC = Trig(A, B, AB, AC, BC)
  -- returns all values
  if (B > 0.0) and (A == 0.0) then
    A = math.deg(math.rad(90) - math.rad(B))
  end
  if (A > 0.0) and (B == 0.0) then
    B = math.deg(math.rad(90) - math.rad(A))
  end
  if  (AC > 0.0) and (BC > 0.0) then
    AB = math.sqrt((AC ^ 2) + (BC ^ 2))
     A = math.deg(math.atan(BC/AC))
     B = math.deg(math.rad(90) - math.rad(A))
  elseif (AB > 0.0) and (BC > 0.0) then
    AB = math.sqrt((AB ^ 2) - (BC ^ 2))
    A = math.deg(math.atan(BC/AC))
    B = math.deg(math.rad(90) - math.rad(A))
  elseif (AB > 0.0) and (AC > 0.0) then
    AB = math.sqrt((AB ^ 2) - (AC ^ 2))
    A = math.deg(math.atan(BC/AC))
    B = math.deg(math.rad(90) - math.rad(A))
  elseif (A > 0.0) and (AC > 0.0) then
    AB = AC / math.cos(math.rad(A))
    BC = AB * math.sin(math.rad(A))
  elseif (A > 0.0) and (BC > 0.0) then
    AB = BC / math.sin(math.rad(A))
    AC = AB * math.cos(math.rad(A))
  elseif (A > 0.0) and (AB > 0.0) then
    BC = AB * math.sin(math.rad(A))
    AC = AB * math.cos(math.rad(A))
  else
    MessageBox("Error: No Missing Value")
  end
  return A, B, AB, AC, BC
end


function main()
  local A, B, AB, AC, BC = 0 ,0 ,0 ,0 ,0
   -- A, B, AB, AC, BC = Trig(A, B, AB, AC, BC)
  -- A = 30.0
   B = 60.0
 -- AB = 25.25
 -- AC = 21.867141
 -- BC = 12.625

  MessageBox( "Value of A = " .. tostring(A) .. "\n" ..
              "Value of B = " .. tostring(B) .. "\n" ..
              "Value of AB = " .. tostring(AB) .. "\n" ..
              "Value of AC = " .. tostring(AC) .. "\n" ..
              "Value of BC = " .. tostring(BC) .. "\n" )

  A, B, AB, AC, BC = Trig(A, B, AB, AC, BC)

    MessageBox( "Value of A = " .. tostring(A) .. "\n" ..
              "Value of B = " .. tostring(B) .. "\n" ..
              "Value of AB = " .. tostring(AB) .. "\n" ..
              "Value of AC = " .. tostring(AC) .. "\n" ..
              "Value of BC = " .. tostring(BC) .. "\n" )

  return true
end
