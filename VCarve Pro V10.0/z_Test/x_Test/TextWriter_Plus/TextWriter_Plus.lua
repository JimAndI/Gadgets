-- VECTRIC LUA SCRIPT

-- Gadget 'TextWriter Plus'
-- Created, edited and enhancemented by B0XA (Sevastopol-2019)

-- 08.01.2019 first version of the gadget (based on code TextWriter (Test3.lua) by Jim Anderson)
-- creation process moved in the right direction with the presence of enthusiasm and free time :)

require "strict"

g_var = {}		-- global variable
g_var.edit = false	-- character editing mode (true-on/false-off)
g_var.test = false	-- font test mode (true-on/false-off)

function Editchar()
	local chr = "s"		-- editable symbol
	local fnt = 2		-- font type (1-normal/2-modern)
	local lay = SetLayer("grid")
	local txt = string.char(1) .. chr		-- grid and editable symbol
	if lay.IsEmpty ~= true then txt = chr end	-- if the layer is not empty then only the editable symbol
	local lay = SetLayer("symbol")
	lay.Colour = 11999911
	lay.Visible = true
	g_var.lay = lay
	DrawWriter(txt, Point2D(0, 0), 2, 1, fnt)
end

function CADLeters(pt, let, plus, tfont)
	local line = nil
	local scl = g_var.scl
	local A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, G0, G1, G2, G3, G4, G5, G6, G7, G8, G9, G10, H0, H1, I1 = Polar2D(pt, -90.0, (0.25 * scl)), pt, Polar2D(pt, 90.0, (0.25 * scl)), Polar2D(pt, 90.0, (0.5 * scl)), Polar2D(pt, 90.0, (0.75 * scl)), Polar2D(pt, 90.0, (1.0 * scl)), Polar2D(pt, 90.0, (1.25 * scl)), Polar2D(pt, 90.0, (1.5 * scl)), Polar2D(pt, 90.0, (1.75 * scl)), Polar2D(pt, 90.0, (2.0 * scl)), Polar2D(pt, 90.0, (2.25 * scl)), Polar2D(pt, -45.0, (0.353553 * scl)), Polar2D(pt, 0.0, (0.25 * scl)), Polar2D(pt, 45.0, (0.353553 * scl)), Polar2D(pt, 63.434949, (0.559017 * scl)), Polar2D(pt, 71.565051, (0.790569 * scl)), Polar2D(pt, 75.963757, (1.030776 * scl)), Polar2D(pt, 78.690068, (1.274755 * scl)), Polar2D(pt, 80.537678, (1.520691 * scl)), Polar2D(pt, 81.869898, (1.767767 * scl)), Polar2D(pt, 82.874984, (2.015564 * scl)), Polar2D(pt, 83.659808, (2.263846 * scl)), Polar2D(pt, -26.565051, (0.559017 * scl)), Polar2D(pt, 0.0, (0.5 * scl)), Polar2D(pt, 26.565051, (0.559017 * scl)), Polar2D(pt, 45.0, (0.707107 * scl)), Polar2D(pt, 56.309932, (0.901388 * scl)), Polar2D(pt, 63.434949, (1.118034 * scl)), Polar2D(pt, 68.198591, (1.346291 * scl)), Polar2D(pt, 71.565051, (1.581139 * scl)), Polar2D(pt, 74.054604, (1.820027 * scl)), Polar2D(pt, 75.963757, (2.061553 * scl)), Polar2D(pt, 77.471192, (2.304886 * scl)), Polar2D(pt, -21.801409, (0.673146 * scl)), Polar2D(pt, 0.0, (0.625 * scl)), Polar2D(pt, 21.801409, (0.673146 * scl)), Polar2D(pt, 38.659808, (0.800391 * scl)), Polar2D(pt, 50.194429, (0.976281 * scl)), Polar2D(pt, 57.994617, (1.179248 * scl)), Polar2D(pt, 63.434949, (1.397542 * scl)), Polar2D(pt, 67.380135, (1.625 * scl)), Polar2D(pt, 70.346176, (1.858259 * scl)), Polar2D(pt, 72.645975, (2.095382 * scl)), Polar2D(pt, 74.475889, (2.335193 * scl)), Polar2D(pt, -18.434949, (0.790569 * scl)), Polar2D(pt, 0.0, (0.75 * scl)), Polar2D(pt, 18.434949, (0.790569 * scl)), Polar2D(pt, 33.690068, (0.901388 * scl)), Polar2D(pt, 45.0, (1.06066 * scl)), Polar2D(pt, 53.130102, (1.25 * scl)), Polar2D(pt, 59.036243, (1.457738 * scl)), Polar2D(pt, 63.434949, (1.677051 * scl)), Polar2D(pt, 66.801409, (1.903943 * scl)), Polar2D(pt, 69.443955, (2.136001 * scl)), Polar2D(pt, 71.565051, (2.371708 * scl)), Polar2D(pt, -14.036243, (1.030776 * scl)), Polar2D(pt, 0.0, (1.0 * scl)), Polar2D(pt, 14.036243, (1.030776 * scl)), Polar2D(pt, 26.565051, (1.118034 * scl)), Polar2D(pt, 36.869898, (1.25 * scl)), Polar2D(pt, 45.0, (1.414214 * scl)), Polar2D(pt, 51.340192, (1.600781 * scl)), Polar2D(pt, 56.309932, (1.802776 * scl)), Polar2D(pt, 60.255119, (2.015564 * scl)), Polar2D(pt, 63.434949, (2.236068 * scl)), Polar2D(pt, 66.037511, (2.462214 * scl)), Polar2D(pt, -11.309932, (1.274755 * scl)), Polar2D(pt, 0.0, (1.25 * scl)), Polar2D(pt, 11.309932, (1.274755 * scl)), Polar2D(pt, 21.801409, (1.346291 * scl)), Polar2D(pt, 30.963757, (1.457738 * scl)), Polar2D(pt, 38.659808, (1.600781 * scl)), Polar2D(pt, 45.0, (1.767767 * scl)), Polar2D(pt, 50.194429, (1.952562 * scl)), Polar2D(pt, 54.462322, (2.150581 * scl)), Polar2D(pt, 57.994617, (2.358495 * scl)), Polar2D(pt, 60.945396, (2.573908 * scl)), Polar2D(pt, -9.462322, (1.520691 * scl)), Polar2D(pt, 0.0, (1.5 * scl)), Polar2D(pt, 0.0, (1.75 * scl))
	local gapX = (I1.x - H1.x)
	local n = {}	-- normal (regular font type)
	local m = {}	-- modern (smooth font type)

	if let == 0 then -- size separation sign (XxY)
		n = {"P", A3, "L", F7, "C", "P", A7, "L", F3, "C"}; H1 = G1
	end
	if let == 1 then -- grid for character editing
		local lay = SetLayer("grid")
		local var = {A0, "A", A1, "1", A2, "2", A3, "3", A4, "4", A5, "5", A6, "6", A7, "7", A8, "8", A9, "9", A10, "10", B0, "B", B1, "", B2, "", B3, "", B4, "", B5, "", B6, "", B7, "", B8, "", B9, "", B10, "", C0, "C", C1, "", C2, "", C3, "", C4, "", C5, "", C6, "", C7, "", C8, "", C9, "", C10, "", D0, "D", D1, "", D2, "", D3, "", D4, "", D5, "", D6, "", D7, "", D8, "", D9, "", D10, "", E0, "E", E1, "", E2, "", E3, "", E4, "", E5, "", E6, "", E7, "", E8, "", E9, "", E10, "", F0, "F", F1, "", F2, "", F3, "", F4, "", F5, "", F6, "", F7, "", F8, "", F9, "", F10, "", G0, "G", G1, "", G2, "", G3, "", G4, "", G5, "", G6, "", G7, "", G8, "", G9, "", G10, "", H0, "H", H1, "", I1, ""}
		for i = 1, #var, 2 do
			local setka = CadMarker(var[i + 1], var[i], 1)
			setka:SetColor(1.0, 0.0, 0.0)
			lay:AddObject(setka, true)
		end
		lay.Locked = true; H1 = A1
	end
	if let == 32 then H1 = F1 end -- space
	if let == 33 then -- !
		n = {"P", A10, "L", A3, "C", "P", A2, "L", A1, "C"}; H1 = B1
	end
	if let == 34 then -- "
		n = {"P", A7, "L", B10, "C", "P", E10, "L", C7, "C"}; m = {"P", A7, "A0", -1.73, B10, "C", "P", E10, "A0", 1.73, C7, "C"}; H1 = F1
	end
	if let == 35 then -- #
		n = {"P", A3, "L", G3, "C", "P", A7, "L", G7, "C", "P", B1, "L", B9, "C", "P", F1, "L", F9, "C"}
	end
	if let == 36 then -- $
		n = {"P", G6, "L", G7, "L", F9, "L", B9, "L", A7, "L", A6, "L", G4, "L", G3, "L", F1, "L", B1, "L", A3, "L", A4, "C", "P", D10, "L", D0, "C"}; m = {"P", G7, "A0", -0.65, C9, "A0", -0.45, B6, "A0", -0.75, E5, "A0", 0.5, E1, "A0", 0.75, A3, "C", "P", D10, "L", D0, "C"}
	end
	if let == 37 then -- %
		n = {"P", A7, "L", A8, "L", B8, "L", B7, "L", A7, "C", "P", E9, "L", A1, "C", "P", C2, "L", C3, "L", E3, "L", E2, "L", C2, "C"}; m = {"P", A7, "A0", 0.3, A8, "A0", 0.14, B8, "A0", 0.3, B7, "A0", 0.14, A7, "C", "P", E9, "L", A1, "C", "P", C2, "A0", 0.3, C3, "A0", 0.14, E3, "A0", 0.3, E2, "A0", 0.14, C2, "C"}; H1 = F1
	end
	if let == 38 then -- &
		n = {"P", G1, "L", B7, "L", B8, "L", C9, "L", E9, "L", F8, "L", F7, "L", A3, "L", A2, "L", B1, "L", E1, "L", G4, "C"}; m = {"P", G1, "L", B6, "A1", -0.35, E6, "L", B4, "A0", -0.44, C1, "A0", -0.66, G3, "C"}
	end
	if let == 39 then -- '
		n = {"P", A8, "L", B10, "C"}; n = {"P", A8, "L", B10, "C"};H1 = C1
	end
	if let == 40 then -- (
		n = {"P", B10, "L", A7, "L", A3, "L", B0, "C"}; m = {"P", B10, "A0", -2.8, B0, "C"}; H1 = C1
	end
	if let == 41 then -- )
		n = {"P", A10, "L", B7, "L", B3, "L", A0, "C"}; m = {"P", A10, "A0", 2.8, A0, "C"}; H1 = C1
	end
	if let == 42 then -- *
		n = {"P", A3, "L", F7, "C", "P", C8, "L", C2, "C", "P", F3, "L", A7, "C"}; H1 = G1
	end
	if let == 43 then -- +
		n = {"P", A5, "L", F5, "C", "P", C3, "L", C7, "C"}; H1 = G1
	end
	if let == 44 or let == 130 then -- ,
		n = {"P", B2, "L", B1, "L", A0, "C"}; m = {"P", B2, "L", B1, "A0", 0.4, A0, "C"}; H1 = D1
	end
	if let == 45 then -- -
		n = {"P", A5, "L", F5, "C"}; H1 = G1
	end
	if let == 46 then -- .
		n = {"P", B2, "L", B1, "C"}; H1 = D1
	end
	if let == 47 then -- /
		n = {"P", A1, "L", E9, "C"}; H1 = F1
	end
	if let == 48 then -- 0
		n = {"P", B1, "L", A3, "L", A7, "L", B9, "L", F9, "L", G7, "L", G3, "L", F1, "L", B1, "C", "P", G9, "L", A1, "C"}; m = {"P", A3, "A0", 12, A7, "A", -0.8, G7, "A0", 12, G3, "A", -0.8, A3, "C", "P", G9, "L", A1, "C"}
	end
	if let == 49 then -- 1
		n = {"P", A7, "L", C9, "L", C1, "C", "P", A1, "L", F1, "C"}; m = {"P", A7, "A0", -1.1, C9, "L", C1, "C", "P", A1, "L", F1, "C"}; H1 = G1
	end
	if let == 50 then -- 2
		n = {"P", A7, "L", A8, "L", B9, "L", F9, "L", G8, "L", G6, "L", A3, "L", A1, "L", G1, "C"}; m = {"P", A7, "A0", 0.5, C9, "L", E9, "A0", 0.545, F5, "A0", 1.6, C4, "A0", -0.6, A2, "L", A1, "L", G1, "C"}
	end
	if let == 51 or let == 199 then -- 3
		n = {"P", A8, "L", B9, "L", F9, "L", G8, "L", G6, "L", F5, "L", G4, "L", G2, "L", F1, "L", B1, "L", A2, "C", "P", F5, "L", C5, "C"}; m = {"P", A8, "A0", 0.6, C9, "L", E9, "A", -1.0, E5, "A", -1.0, E1, "L", C1, "A0", 0.6, A2, "C", "P", E5, "L", C5, "C"}
	end
	if let == 52 then -- 4
		n = {"P", F1, "L", F9, "L", A3, "L", G3, "C"}
	end
	if let == 53 then -- 5
		n = {"P", G9, "L", A9, "L", A6, "L", F6, "L", G5, "L", G2, "L", F1, "L", B1, "L", A2, "L", A3, "C"}; m = {"P", G9, "L", A9, "L", A6, "A1", -0.72, C1, "A0", 0.643, A2, "C"}
	end
	if let == 54 then -- 6
		n = {"P", G8, "L", F9, "L", B9, "L", A8, "L", A2, "L", B1, "L", F1, "L", G2, "L", G5, "L", F6, "L", B6, "L", A5, "C"}; m = {"P", G8, "A0", -0.71, A6, "L", A3, "A0", -0.64, G3, "A0", -0.682, A5, "C"}
	end
	if let == 55 then -- 7
		n = {"P", A8, "L", A9, "L", G9, "L", G8, "L", B1, "C"}; m = {"P", A8, "L", A9, "L", G9, "L", G8, "A0", -3, B1, "C"}
	end
	if let == 56 then -- 8
		n = {"P", B5, "L", F5, "L", G6, "L", G8, "L", F9, "L", B9, "L", A8, "L", A6, "L", B5, "L", A4, "L", A2, "L", B1, "L", F1, "L", G2, "L", G4, "L", F5, "C"}; m = {"P", C5, "L", E5, "A1", 0.53, C5, "A0", -0.501, C1, "L", E1, "A0", -0.501, E5, "C"}
	end
	if let == 57 then -- 9
		n = {"P", A2, "L", B1, "L", F1, "L", G2, "L", G8, "L", F9, "L", B9, "L", A8, "L", A6, "L", B5, "L", F5, "L", G6, "C"}; m = {"P", A2, "A0", -0.71, G4, "L", G7, "A0", -0.64, A7, "A0", -0.64, G6, "C"}
	end
	if let == 58 then -- :
		n = {"P", B2, "L", B3, "C", "P", B6, "L", B7, "C"}; H1 = D1
	end
	if let == 59 then --;
		n = {"P", A0, "L", B2, "L", B3, "C", "P", B6, "L", B7, "C"}; m = {"P", A0, "A0", -1.1, B2, "L", B3, "C", "P", B6, "L", B7, "C"}; H1 = D1
	end
	if let == 60 then -- <
		n = {"P", F8, "L", A5, "L", F2, "C"}; H1 = G1
	end
	if let == 61 then -- =
		n = {"P", A3, "L", G3, "C", "P", A6, "L", G6, "C"}
	end
	if let == 62 then -- >
		n = {"P", A8, "L", F5, "L", A2, "C"}; H1 = G1
	end
	if let == 63 then -- ?
		n = {"P", A8, "L", A9, "L", B10, "L", F10, "L", G9, "L", G7, "L", D4, "L", D3, "C", "P", D2, "L", D1, "C"}; m = {"P", A8, "A0", 0.625, E10, "A0", 0.57, F6, "A0", -0.86, D3, "C", "P", D2, "L", D1, "C"}
	end
	if let == 64 then -- @
		n = {"P", F6, "L", E7, "L", C7, "L", B6, "L", B4, "L", C3, "L", E3, "L", F5, "L", F3, "L", G4, "L", G8, "L", F9, "L", B9, "L", A7, "L", A3, "L", B1, "L", F1, "L", G2, "C"}; m = {"P", F5, "L", F6, "A", 0.9, B6, "L", B4, "A", 0.8, F4, "L", F3, "A0", -0.65, G5, "L", G7, "A", 0.8, A7, "A0", -3.5, A3, "A0", -0.72, G2, "C"}
	end
	if let == 65 or let == 192 then -- A
		n = {"P", A1, "L", D9, "L", G1, "C", "P", B4, "L", F4, "C"}
	end
	if let == 66 or let == 194 then -- B
		n = {"P", A5, "L", F5, "L", G4, "L", G2, "L", F1, "L", A1, "L", A9, "L", F9, "L", G8, "L", G6, "L", F5, "C"}; m = {"P", A5, "L", E5, "A", -1.0, E1, "L", A1, "L", A9, "L", E9, "A", -0.9, E5, "C"}
	end
	if let == 67 or let == 209 then -- C
		n = {"P", G3, "L", F1, "L", B1, "L", A3, "L", A7, "L", B9, "L", F9, "L", G7, "C"}; m = {"P", G7, "A", 0.8, A7, "A0", -12, A3, "A", 0.8, G3, "C"}
	end
	if let == 68 then -- D
		n = {"P", A1, "L", F1, "L", G3, "L", G7, "L", F9, "L", A9, "L", A1, "C"}; m = {"P", A1, "L", E1, "A", 0.4, G3, "L", G7, "A", 0.4, E9, "L", A9, "L", A1, "C"}
	end
	if let == 69 or let == 197 then -- E
		n = {"P", F1, "L", A1, "L", A9, "L", F9, "C", "P", A5, "L", D5, "C"}; H1 = G1
	end
	if let == 70 then -- F
		n = {"P", A1, "L", A9, "L", G9, "C", "P", A5, "L", F5, "C"}
	end
	if let == 71 then -- G
		n = {"P", G7, "L", G8, "L", F9, "L", B9, "L", A7, "L", A3, "L", B1, "L", F1, "L", G3, "L", G4, "L", E4, "L", E3, "C"}; m = {"P", G7, "A", 0.8, A7, "A0", -12, A3, "A", 0.8, G3, "L", G3, "L", G4, "L", E4, "L", E3, "C"}
	end
	if let == 72 or let == 205 then -- H
		n = {"P", A1, "L", A9, "C", "P", G1, "L", G9, "C", "P", A5, "L", G5, "C"}
	end
	if let == 73 then -- I
		n = {"P", B1, "L", B9, "C", "P", A1, "L", C1, "C", "P", A9, "L", C9, "C"}; H1 = E1
	end
	if let == 74 then -- J
		n = {"P", A3, "L", B1, "L", F1, "L", G3, "L", G9, "L", C9, "C"}; m = {"P", A3, "A", 0.8, G3, "L", G9, "L", C9, "C"}
	end
	if let == 75 or let == 202 then -- K
		n = {"P", A1, "L", A9, "C", "P", A5, "L", C5, "C", "P", F1, "L", C5, "L", F9, "C"}; H1 = G1
	end
	if let == 76 then -- L
		n = {"P", A9, "L", A1, "L", G1, "C"}
	end
	if let == 77 or let == 204 then -- M
		n = {"P", A1, "L", A9, "L", D4, "L", G9, "L", G1, "C"}
	end
	if let == 78 then -- N
		n = {"P", A1, "L", A9, "L", F1, "L", F9, "C"}; H1 = G1
	end
	if let == 79 or let == 206 then -- O
		n = {"P", B1, "L", A3, "L", A7, "L", B9, "L", F9, "L", G7, "L", G3, "L", F1, "L", B1, "C"}; m = {"P", A3, "A0", 12, A7, "A", -0.8, G7, "A0", 12, G3, "A", -0.8, A3, "C"}
	end
	if let == 80 or let == 208 then -- P
		n = {"P", A1,"L", A9, "L", F9, "L", G8, "L", G6, "L", F5, "L", A5, "C"}; m = {"P", A1, "L", A9, "L", E9, "A", -1.0, E5, "L", A5, "C"}
	end
	if let == 81 then -- Q
		n = {"P", B1, "L", A3, "L", A7, "L", B9, "L", F9, "L", G7, "L", G3, "L", F1, "L", B1, "C", "P", G1, "L", D5, "C"}; m = {"P", A3, "A0", 12, A7, "A", -0.8, G7, "A0", 12, G3, "A", -0.8, A3, "C", "P", G1, "L", D5, "C"}
	end
	if let == 82 then -- R
		n = {"P", A1, "L", A9, "L", F9, "L", G8, "L", G6, "L", F5, "L", A5, "C", "P", D5, "L", G1, "C"}; m = {"P", A1, "L", A9, "L", E9, "A", -1.0, E5, "L", A5, "C", "P", C5, "L", F1, "C"}
	end
	if let == 83 then -- S
		n = {"P", G6, "L", G7, "L", F9, "L", B9, "L", A7, "L", A6, "L", G4, "L", G3, "L", F1, "L", B1, "L", A3, "L", A4, "C"}; m = {"P", A3, "A", 0.4, C1, "L", E1, "A", 0.9, E5, "A0", 0.72, B6, "A", -0.64, D9, "L", E9, "A0", 0.5, G7, "C"}
	end
	if let == 84 or let == 210 then -- T
		n = {"P", A9, "L", G9, "C", "P", D9, "L", D1, "C"}
	end
	if let == 85 then -- U
		n = {"P", A9, "L", A3, "L", B1, "L", F1, "L", G3, "L", G9, "C"}; m = {"P", A9, "L", A3, "A", 0.8, G3, "L", G9, "C"}
	end
	if let == 86 then -- V
		n = {"P", A9, "L", D1, "L", G9, "C"}
	end
	if let == 87 then -- W
		n = {"P", A9, "L", B1, "L", D5, "L", F1, "L", G9, "C"}
	end
	if let == 88 or let == 213 then -- X
		n = {"P", A1, "L", G9, "C", "P", A9, "L", G1, "C"}
	end
	if let == 89 then -- Y
		n = {"P", A9, "L", D5, "L", G9, "C", "P", D1, "L", D5, "C"}
	end
	if let == 90 then -- Z
		n = {"P", A9, "L", G9, "L", A1, "L", G1, "C"}
	end
	if let == 91 then -- [
		n = {"P", C10, "L", A10, "L", A0, "L", C0, "C"}; H1 = E1
	end
	if let == 92 then -- \
		n = {"P", A9, "L", E1, "C"}; H1 = F1
	end
	if let == 93 then -- ]
		n = {"P", A10, "L", C10, "L", C0, "L", A0, "C"}; H1 = E1
	end
	if let == 94 then -- ^
		n = {"P", A7, "L", C10, "L", F7, "C"}; H1 = G1
	end
	if let == 95 then -- _
		n = {"P", A1, "L", G1, "C"}
	end
	if let == 96 then -- `
		n = {"P", A10, "L", B7, "C"}; H1 = C1
	end
	if let == 123 then -- {
		n = {"P", C10, "L", B9, "L", B6, "L", A5, "L", B4, "L", B1, "L", C0, "C"}; m = {"P", C10, "A0", -0.263, B9, "L", B7, "A0", 0.595, A5, "A0", 0.595, B3, "L", B1, "A0", -0.263, C0, "C"}; H1 = E1
	end
	if let == 124 then -- |
		n = {"P", B1, "L", B9, "C"}; H1 = E1
	end
	if let == 125 then -- }
		n = {"P", A10, "L", B9, "L", B6, "L", C5, "L", B4, "L", B1, "L", A0, "C"}; m = {"P", A10, "A0", 0.263, B9, "L", B7, "A0", -0.595, C5, "A0", -0.595, B3, "L", B1, "A0", 0.263, A0, "C"}; H1 = E1
	end
	if let == 126 then -- ~
		n = {"P", A4, "L", B6, "L", F4, "L", G6, "C"}; m = {"P", A5, "A", -0.7, D5, "A", 0.7, G5, "C"}
	end
	if let == 136 then -- ˆ
		n = {"P", G7, "L", F9, "L", B9, "L", A7, "L", A3, "L", B1, "L", F1, "L", G3, "C", "P", A6, "L", E6, "C", "P", A4, "L", E4, "C"}; m = {"P", G7, "A0", -0.641, A7, "L", A3, "A0", -0.641, G3, "C", "P", A6, "L", E6, "C", "P", A4, "L", E4, "C"}
	end

	if let == 161 then -- ¡ (bel)
		n = {"P", B10, "L", D9, "L", F10, "C", "P", A2, "L", B1, "L", F1, "L", G3, "L", G9, "C", "P", G5, "L", B5, "L", A6, "L", A9, "C"}; m = {"P", B10, "A0", -0.41, F10, "C", "P", A3, "A", 0.8, G3, "L", G9, "C", "P", G5, "L", D5, "A", -0.36, A7, "L", A9, "C"}
	end
	if let == 165 then -- ¥ (ukr)
		n = {"P", A1, "L", A9, "L", F9, "L", F10, "C"}; H1 = G1
	end
	if let == 167 then -- §
		n = {"P", A1, "L", B1, "L", C2, "L", C3, "L", A5, "L", A6, "L", B7, "C", "P", C3, "L", E4, "L", E5, "L", B7, "L", B8, "L", C9, "L", E9, "C"}; m = {"P", A1, "A", 0.5, C2, "L", C3, "A0", 1.0, A5, "A", -0.4, B7, "C", "P", C3, "A", 0.4, E5, "A0", -1.0, B7, "L", B8, "A", -0.5, E9, "C"}; H1 = F1
	end
	if let == 168 then -- ¨
		n = {"P", F1, "L", A1, "L", A9, "L", F9, "C", "P", F10, "L", E10, "C", "P", B10, "L", A10, "C", "P", A5, "L", D5, "C"}; H1 = G1
	end
	if let == 170 then -- ª (ukr)
		n = {"P", G7, "L", F9, "L", B9, "L", A7, "L", A3, "L", B1, "L", F1, "L", G3, "C", "P", A5, "L", E5, "C"}; m = {"P", G7, "A0", -0.641, A7, "L", A3, "A0", -0.641, G3, "C", "P", A5, "L", E5, "C"}
	end
	if let == 171 then -- «
		n = {"P", C7, "L", A5, "L", C3, "C", "P", F7, "L", C5, "L", F3, "C"}; H1 = G1
	end
	if let == 176 then -- °
		n = {"P", A9, "L", A8, "L", B7, "L", C7, "L", E8, "L", E9, "L", C10, "L", B10, "L", A9, "C"}; m = {"P", A9, "A", 1.0, E8, "A", 1.0, A9, "C"}; H1 = F1
	end
	if let == 177 then -- ±
		n = {"P", A6, "L", F6, "C", "P", C8, "L", C4, "C", "P", A3, "L", F3, "C"}; H1 = G1
	end
	if let == 182 then -- ¶
		n = {"P", C9, "L", C1, "C", "P", F1, "L", F9, "L", B9, "L", A8, "L", A6, "L", B5, "L", B8, "C"}; m = {"P", C9, "L", C1, "C", "P", F1, "L", F9, "L", C9, "A0", -0.538, B5, "L", B8, "C"}; H1 = G1
	end
	if let == 185 then -- ¹
		n = {"P", A1, "L", A9, "L", E1, "L", E9, "L", G9, "C", "P", F7, "L", F6, "L", G6, "L", G7, "L", F7, "C", "P", F4, "L", G4, "C"}; m = {"P", A1, "L", A9, "L", E1, "L", E9, "L", G9, "C", "P", F7, "A0", -0.233, F6, "A0", -0.163, G6, "A0", -0.233, G7, "A0", -0.163, F7, "C", "P", F4, "L", G4, "C"}
	end
	if let == 187 then -- »
		n = {"P", A7, "L", C5, "L", A3, "C", "P", C7, "L", F5, "L", C3, "C"}; H1 = G1
	end
	if let == 193 then -- Á
		n = {"P", G9, "L", A9, "L", A1, "L", F1, "L", G2, "L", G5, "L", F6, "L", A6, "C"}; m = {"P", G9, "L", A9, "L", A1, "L", E1, "A0", -0.632, E6, "L", A6, "C"}
	end
	if let == 195 then -- Ã
		n = {"P", A1, "L", A9, "L", F9, "L", F8, "C"}; H1 = G1
	end
	if let == 196 then -- Ä
		n = {"P", A0, "L", A1, "L", H1, "L", H0, "C", "P", B1, "L", B6, "L", D9, "L", G9, "L", G1, "C"}; m = {"P", A0, "L", A1, "L", H1, "L", H0, "C", "P", B1, "L", B5, "A0", 1.377, C8, "A0", 0.845, G9, "L", G1, "C"}; H1 = I1
	end
	if let == 198 then -- Æ
		n = {"P", A1, "L", G9, "C", "P", D9, "L", D1, "C", "P", G1, "L", A9, "C"}; m = {"P", A1, "A0", 2.0, D5, "A0", -2.0, G9, "C", "P", D9, "L", D1, "C", "P", G1, "A0", -2.0, D5, "A0", 2.0, A9, "C"}
	end
	if let == 200 then -- È
		n = {"P", A9, "L", A1, "L", G9, "L", G1, "C"}
	end
	if let == 201 then -- É
		n = {"P", B10, "L", D9, "L", F10, "C", "P", A9, "L", A1, "L", G9, "L", G1, "C"}; m = {"P", B10, "A0", -0.41, F10, "C", "P", A9, "L", A1, "L", G9, "L", G1, "C"}
	end
	if let == 203 then -- Ë
		n = {"P", A1, "L", D9, "L", G1, "C"}
	end
	if let == 207 then -- Ï
		n = {"P", A1, "L", A9, "L", G9, "L", G1, "C"}
	end
	if let == 211 then -- Ó
		n = {"P", A2, "L", B1, "L", F1, "L", G3, "L", G9, "C", "P", G5, "L", B5, "L", A6, "L", A9, "C"}; m = {"P", A3, "A", 0.8, G3, "L", G9, "C", "P", G5, "L", D5, "A", -0.36, A7, "L", A9, "C"}
	end
	if let == 212 then -- Ô
		n = {"P", E1, "L", E9, "L", G9, "L", Point2D(G8.x + gapX, G8.y), "L", Point2D(G5.x + gapX, G5.y), "L", G4, "L", B4, "L", A5, "L", A8, "L", B9, "L", E9, "C"}; m = {"P", E1, "L", E9, "L", F9, "A0", 0.5, Point2D(G7.x + gapX, G7.y), "L", Point2D(G6.x + gapX, G6.y), "A0", 0.5, F4, "L", C4, "A0", 0.5, A6, "L", A7, "A0", 0.5, C9, "L", E9, "C"}; H1 = I1
	end
	if let == 214 then -- Ö
		n = {"P", A9, "L", A1, "L", G1, "L", G0, "C", "P", F1, "L", F9, "C"}
	end
	if let == 215 then -- ×
		n = {"P", A9, "L", A6, "L", B4, "L", F4, "C", "P", F9, "L", F1, "C"}; m = {"P", A9, "L", A6, "A0", -0.53, C4, "L", F4, "C", "P", F9, "L", F1, "C"}; H1 = G1
	end
	if let == 216 then -- Ø
		n = {"P", A9, "L", A1, "L", G1, "L", G9, "C", "P", D8, "L", D1, "C"}
	end
	if let == 217 then -- Ù
		n = {"P", A9, "L", A1, "L", G1, "L", G9, "C", "P", D8, "L", D1, "C", "P", G1, "L", H1, "L", H0, "C"}; H1 = I1
	end
	if let == 218 then -- Ú
		n = {"P", A9, "L", B9, "L", B1, "L", F1, "L", G2, "L", G5, "L", F6, "L", B6, "C"}; m = {"P", A9, "L", B9, "L", B1, "L", D1, "A", 1.0, D6, "L", B6, "C"}
	end
	if let == 219 then -- Û
		n = {"P", A9, "L", A1, "L", E1, "L", F2, "L", F5, "L", E6, "L", A6, "C", "P", G1, "L", G9, "C"}; m = {"P", A9, "L", A1, "L", C1, "A0", -0.632, C6, "L", A6, "C", "P", G1, "L", G9, "C"}
	end
	if let == 220 then -- Ü
		n = {"P", A9, "L", A1, "L", E1, "L", F2, "L", F5, "L", E6, "L", A6, "C"}; m = {"P", A9, "L", A1, "L", C1, "A0", -0.632, C6, "L", A6, "C"}; H1 = G1
	end
	if let == 221 then -- Ý
		n = {"P", A7, "L", B9, "L", F9, "L", G7, "L", G3, "L", F1, "L", B1, "L", A3, "C", "P", C5, "L", G5, "C"}; m = {"P", A7, "A0", 0.641, G7, "L", G3, "A0", 0.641, A3, "C", "P", C5, "L", G5, "C"}
	end
	if let == 222 then -- Þ
		n = {"P", A1, "L", A9, "C", "P", A5, "L", B5, "L", B3, "L", C1, "L", F1, "L", G3, "L", G7, "L", F9, "L", C9, "L", B7, "L", B5, "C"}; m = {"P", A1, "L", A9, "C", "P", A5, "L", B5, "L", B3, "A", 1.0, G3, "L", G7, "A", 1.0, B7, "L", B5, "C"}
	end
	if let == 223 then -- ß
		n = {"P", G1, "L", G9, "L", B9, "L", A8, "L", A6, "L", B5, "L", G5, "C", "P", E5, "L", B1, "C"}; m = {"P", G1, "L", G9, "L", C9, "A", 1.0, C5, "L", G5, "C", "P", E5, "L", B1, "C"}
	end
	if #m ~= 0 and tfont == 2 then n = m end
	if g_var.draw == true then
	    for i = 1, #n do
		if tostring(n[i]) == "P" then		-- point (start point of contour) {"P", G0}
			line = Contour(0.0)
			line:AppendPoint(n[i + 1])
		end
		if tostring(n[i]) == "L" then		-- line {"L", G1}
			line:LineTo(n[i + 1])
		end
		if tostring(n[i]) == "A" then		-- arc {"A", 1.0, G1} 0-line;1.0-halfcircle
			line:ArcTo(n[i + 2], n[i + 1])
		end
		if tostring(n[i]) == "A0" and tonumber(n[i + 1]) < 0 then	-- arc {"A0", -7.5, G1} -radius
			line:ArcTo(n[i + 2], CenterArc(n[i + 2], n[i - 1], n[i + 1]), true)
			elseif tostring(n[i]) == "A0" then			-- arc {"A0", 7.5, G1} radius
			line:ArcTo(n[i + 2], CenterArc(n[i - 1], n[i + 2], n[i + 1]), false)
		end
		if tostring(n[i]) == "A1" and tonumber(n[i + 1]) < 0 then	-- arc {"A1", -7.5, G1} -radius
			line:ArcTo(n[i + 2], CenterArc(n[i + 2], n[i - 1], n[i + 1]), false)
			elseif tostring(n[i]) == "A1" then			-- arc {"A1", 7.5, G1} radius
			line:ArcTo(n[i + 2], CenterArc(n[i - 1], n[i + 2], n[i + 1]), true)
		end
		if tostring(n[i]) == "C" then		-- create contour {"C"}
			local cad = CreateCadContour(line)
			g_var.lay:AddObject(cad, true)
		end
	    end
	end
	return Point2D(H1.x + gapX * (plus - 1), H1.y)
end

function Test()
	local lay = SetLayer("sample")
	lay.Colour = 00002200
	lay.Visible = true
	g_var.lay = lay
	for i = 1, 2 do
		DrawWriter("1234567890_", Point2D(0, 120 * (i - 1) + 90), 20, 1, i)
		DrawWriter("$ˆ;:'-+*=±" .. string.char(34) .. string.char(92) .. string.char(124) .. string.char(47) .. "«»¶§,.<>&!?@#¹%^°(){}[]`~", Point2D(0, 120 * (i - 1) + 60), 20, 1, i)
		DrawWriter("abcdefghijklmnopqrstuvwxyz ¢´º¿", Point2D(0, 120 * (i - 1) + 30), 20, 1, i)
		DrawWriter("àáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ", Point2D(0, 120 * (i - 1)), 20, 1, i)
	end
end

function Round(num, idp)
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function Polar2D(pt, ang, dist)
	return Point2D((pt.x + dist * math.cos(math.rad(ang))), (pt.y + dist * math.sin(math.rad(ang))))
end

function CenterArc(A, B, radius)
	local radius = ((tonumber(radius) or 0) * g_var.scl)
	local horda = (A - B).Length
	if math.abs(radius) < (horda / 2) and radius ~= 0 then
		--D("Too small radius " .. radius .. "\nreplaced by the smallest possible " .. (horda / 2))
		radius = (horda / 2)
	end
	return Point2D(((A.x + B.x) / 2 + (B.y - A.y) * math.sqrt(math.abs(radius) ^ 2 - (horda / 2) ^ 2) / horda), ((A.y + B.y) / 2 + (A.x - B.x) * math.sqrt(math.abs(radius) ^ 2 - (horda / 2) ^ 2) / horda))
end

function DrawWriter(what, where, size, gap, fnt)
	local strup = String2Upper(what) --string.upper(what)
	local a = ""
	local i = 1
	g_var.scl = (size * 0.5)
	local ptx = where
	while i <= string.len(what) do
		a = string.byte(string.sub(strup, i, i))
		ptx = CADLeters(ptx, a, gap, fnt)
		i = i + 1
	end
	return ptx
end

function String2Upper(s)
	local r, b = ''
	local s = s:upper()
	for i = 1, s:len() do
		b = s:byte(i)
		if b > 223 then
		b = b - 32
		elseif b == 162 then	-- if ¢ (belarus)
		b = 161			-- to ¡ (belarus)
		elseif b == 180 then	-- if ´ (ukraine)
		b = 165			-- to ¥ (ukraine)
		elseif b == 184 then	-- if ¸ (russia)
		b = 168			-- to ¨ (russia)
		elseif b == 186 then	-- if º (ukraine)
		b = 170			-- to ª (ukraine)
		elseif b == 175 or b == 191 or b == 178 or b == 179 then	-- if ¯ or ¿ or ² or ³ (ukraine)
		b = 73			-- to I
		end
		r = r .. _G.string.char(b)
	end
	return r
end

function D(s)
	MessageBox(s)
	return false
end

function SetLayer(name)
	local lay = g_var.job.LayerManager:GetLayerWithName(name)
	if lay == nil then return D("Failed to create layer - " .. lay) end
	return lay
end

function DateTime(flag)
	if flag ~= nil then
		if flag == true then return os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y") end
		if flag == false then return os.date("%H") .. ":" .. os.date("%M") end
	end
	return os.date("%x") .. " " .. os.date("%X")
end

function MarkContourNodes(kontur, onoff)
	local num = 0
	local pos = kontur:GetHeadPosition()
	while pos ~= nil do
		local span
		span, pos = kontur:GetNext(pos)
		if onoff == true then
			local marker = CadMarker("", span.StartPoint2D, 2)
			if num == 0 then marker:SetColor(1.0, 0.0, 0.0) else marker:SetColor(0.0, 0.0, 1.0) end
			g_var.lay:AddObject(marker, true)
		end
		num = num + 1 -- number nodes of contour
	end
	return num
end

function main(path)
	local job = VectricJob()
	if not job.Exists then return D("No job loaded.") end
	g_var.job = job
	g_var.draw = true
	g_var.scl = 1
	local lay = "TextMark"
	local text = "Part"
	local str = ""
	local size = 10			-- size text
	local interval = 1		-- text spacing (1-single/2-double/3-triple)
	local font = 1			-- font type (1-regular/2-smooth)
	local count = 1			-- initial number of numbering
	local check = true		-- numbering (on/off)
	local checkname = false		-- name layer contour(on/off)
	local checkdate = false		-- date DD/MM/YYYY (on/off)
	local checktime = false		-- time HH:MM (on/off)
	local checkauto = false		-- autosize text (on/off)
	local checksize = false		-- size contour (on/off)
	local checklength = false	-- length contour (on/off)
	local checkarea = false		-- area contour (on/off)
	local checknodes = false	-- number nodes (on/off)
	local centr = 1			-- location text (1-center of gravity/2-center of bounding box)
	local selection = job.Selection
	local selcount = selection.Count
	local cur_layer = job.LayerManager:GetActiveLayer()

	if g_var.edit == true then -- when editing character
		Editchar()
		job.LayerManager:SetActiveLayer(cur_layer)
		job:Refresh2DView()
		return false
		elseif g_var.test == true then -- when testing font
		Test()
		job.LayerManager:SetActiveLayer(cur_layer)
		job:Refresh2DView()
		return false
	end

	if selection.IsEmpty then return D("Select one or more closed vectors.") end
	
	local registry = Registry("TextWriterPlus")
	local dialog = HTML_Dialog(false, "file:" .. path .. "\\TextWriter_Plus.html", 350, 500, "TextWriter Plus")

	local text = registry:GetString("Text", text)
	local size = registry:GetDouble("Size", size)
	local interval = registry:GetInt("Interval", interval)
	local font = registry:GetInt("Font", font)
	local count = registry:GetInt("Count", count)
	local check = registry:GetBool("CheckNum", check)
	local checkname = registry:GetBool("CheckName", checkname)
	local checkdate = registry:GetBool("CheckDate", checkdate)
	local checktime = registry:GetBool("CheckTime", checktime)
	local checkauto = registry:GetBool("CheckAuto", checkauto)
	local checksize = registry:GetBool("CheckSize", checksize)
	local checklength = registry:GetBool("CheckLength", checklength)
	local checkarea = registry:GetBool("CheckArea", checkarea)
	local checknodes = registry:GetBool("CheckNodes", checknodes)
	local centr = registry:GetInt("Centr", centr)

	dialog:AddTextField("TextInput", text)
	dialog:AddIntegerField("CountInput", count)
	dialog:AddDoubleField("SizeInput", size)
	dialog:AddRadioGroup("Interval", interval)
	dialog:AddRadioGroup("Font", font)
	dialog:AddCheckBox("CheckNum", check)
	dialog:AddCheckBox("CheckName", checkname)
	dialog:AddCheckBox("CheckDate", checkdate)
	dialog:AddCheckBox("CheckTime", checktime)
	dialog:AddCheckBox("CheckAuto", checkauto)
	dialog:AddCheckBox("CheckSize", checksize)
	dialog:AddCheckBox("CheckLength", checklength)
	dialog:AddCheckBox("CheckArea", checkarea)
	dialog:AddCheckBox("CheckNodes", checknodes)
	dialog:AddRadioGroup("Centr", centr)
	if not dialog:ShowDialog() then
		return false
	end

	local layer = SetLayer(lay)
	layer.Colour = 11111199
	layer.Visible = true
	g_var.lay = layer
	local text = dialog:GetTextField("TextInput")
	local count = math.abs(dialog:GetIntegerField("CountInput"))
	local size = dialog:GetDoubleField("SizeInput")
	local interval = dialog:GetRadioIndex("Interval")
	local font = dialog:GetRadioIndex("Font")
	local check = dialog:GetCheckBox("CheckNum")
	local checkname = dialog:GetCheckBox("CheckName")
	local checkdate = dialog:GetCheckBox("CheckDate")
	local checktime = dialog:GetCheckBox("CheckTime")
	local checkauto = dialog:GetCheckBox("CheckAuto")
	local checksize = dialog:GetCheckBox("CheckSize")
	local checklength = dialog:GetCheckBox("CheckLength")
	local checkarea = dialog:GetCheckBox("CheckArea")
	local checknodes = dialog:GetCheckBox("CheckNodes")
	local centr = dialog:GetRadioIndex("Centr")

	if size == 0 then return D("Size text must be not 0.") end

	--registry:SetInt("Count", count)
	local date, time = DateTime(true), DateTime(false)
	local Alien, OpenV, kf = 0, 0, 0
	local minXY, maxXY, Center = Point2D(), Point2D(), Point2D()
	local sel, bounds, cengrav, myContour = nil, nil, nil, nil
	local pos = selection:GetHeadPosition()
	local progress = ProgressBar("Processing", ProgressBar.LINEAR)
	while pos ~= nil do
		kf = kf + 1
		sel, pos = selection:GetNext(pos)
		if (sel.ClassName ~= "vcCadContour") and (sel.ClassName ~= "vcCadPolyline") then --if object not contour
			Alien = Alien + 1				-- add it
			job.Selection:Remove(sel, false)		-- and remove from selected objects
			else
			myContour = sel:GetContour()
			bounds = myContour.BoundingBox2D		-- bounds object
			cengrav = myContour.CentreOfGravity		-- center object
			if centr == 1 then
				Center.x = cengrav.x
				Center.y = cengrav.y
				else
				minXY.x = bounds.MinX
				minXY.y = bounds.MinY
				maxXY.x = bounds.MinX + bounds.XLength
				maxXY.y = bounds.MinY + bounds.YLength
				Center.x = minXY.x + (maxXY.x - minXY.x) / 2
				Center.y = minXY.y + (maxXY.y - minXY.y) / 2
			end
			str = text
			if check == true then str = str .. count end
			if checksize == true then str = str .. ((#str == 0) and "" or " ") .. tostring(Round(bounds.XLength, 2)):gsub("[.]", ",") .. string.char(0) .. tostring(Round(bounds.YLength, 2)):gsub("[.]", ",") end
			if checklength == true then str = str .. ((#str == 0) and "" or " ") .. tostring(Round(myContour.Length, 2)):gsub("[.]", ",") end
			if checkarea == true and myContour.IsClosed then str = str .. ((#str == 0) and "" or " ") .. tostring(Round(myContour.Area, 2)):gsub("[.]", ",") end
			if checknodes == true then str = str .. ((#str == 0) and "" or " ") .. MarkContourNodes(myContour, false) end
			if checkname == true then local layer_id = luaUUID(); layer_id:Set(sel.LayerId); str = str .. ((#str == 0) and "" or " ") .. string.match(job.LayerManager:GetLayerWithId(layer_id.RawId).Name, "^%s*(.-)%s*$") end	-- str+name layer without starting and ending spaces
			if checkdate == true then str = (str .. ((#str == 0) and "" or " ") .. date) end
			if checktime == true then str = (str .. ((#str == 0) and "" or " ") .. time) end

			if myContour.IsOpen then	-- if contour not closed
				OpenV = OpenV + 1			-- add it
				job.Selection:Remove(sel, false)	-- and remove from selected objects
				else
				-- if no symbols to draw
				if string.len(str) == 0 then
					local la = SetLayer("NodesContour")
					la.Visible = true
					g_var.lay = la
					MarkContourNodes(myContour, true)	-- mark nodes
					str = string.char(0)			-- and mark the center 'x'
					g_var.lay = layer
				end
				g_var.draw = false
				if checkauto == true then --and #str ~= 0
					size = 0
					local pnt = Point2D(0, 0)
					while pnt.x < (bounds.XLength - bounds.XLength / 10) do
						size = size + 1
						local pt = DrawWriter(str, Point2D(0, 0), size, interval, font)
						pnt = Point2D(pt.x - 0.25 * g_var.scl * interval, pt.y)
					end
					while pnt.x > (bounds.XLength - bounds.XLength / 10) do
						size = size - 0.1
						local pt = DrawWriter(str, Point2D(0, 0), size, interval, font)
						pnt = Point2D(pt.x - 0.25 * g_var.scl * interval, pt.y)
					end
					while size >= (bounds.YLength - bounds.YLength / 5) do
						size = size - 0.5
					end
					size = (size > 0.1) and size or 0.1	--if size<0.1 then size=0.1
				end
				local pt = DrawWriter(str, Point2D(0, 0), size, interval, font)
				g_var.draw = true
				local point = Point2D((Center.x - (pt.x - 0.25 * g_var.scl * interval) / 2), (Center.y - size / 2))
				DrawWriter(str, point, size, interval, font)
				count = count + 1
				if count > 2147483647 then
					count = 1
					registry:SetInt("Count", count)
					job:Refresh2DView()
					return false
				end
			end
		end
		progress:SetPercentProgress(100 * kf / selcount)
	end
	progress:Finished()

	registry:SetString("Text", text)
	if check == true then registry:SetInt("Count", count) end
	if checkauto == false then registry:SetDouble("Size", size) end
	registry:SetInt("Interval", interval)
	registry:SetInt("Font", font)
	registry:SetBool("CheckNum", check)
	registry:SetBool("CheckName", checkname)
	registry:SetBool("CheckDate", checkdate)
	registry:SetBool("CheckTime", checktime)
	registry:SetBool("CheckAuto", checkauto)
	registry:SetBool("CheckSize", checksize)
	registry:SetBool("CheckLength", checklength)
	registry:SetBool("CheckArea", checkarea)
	registry:SetBool("CheckNodes", checknodes)
	registry:SetInt("Centr", centr)

	job.LayerManager:SetActiveLayer(cur_layer)
	--job.Selection:Clear()
	job:Refresh2DView()
	if (Alien + OpenV) == selcount and (Alien + OpenV) == 1 then D("1 selected object is skipped.")
		elseif (Alien + OpenV) == selcount then D("" .. selcount .. " selected objects is skipped.")
		elseif (Alien + OpenV) < selcount and (Alien + OpenV) ~= 0 then D("" .. (Alien + OpenV) .. " from " .. selcount .. " selected objects is skipped.")
	end
	return true
end
