-- src.unit.antivirus.chipHealer.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Real Time Protector"
hp = 50
range = 4
w = 32
h = 48

effectText = "Damages enemy\n"..
				"malwares with\n"..
				"2 damage per tick."

effect = function(self, x, y, z, amt)
	for k, v in pairs(virus.troop) do
		local tx, ty, tz = hexMap:pixelToHex(v.x, v.y)
		if tx == x and ty == y and tz == z then
			v.hp = v.hp - amount
		end
	end
end

amount = 2
cost = 25
img = love.graphics.newImage("gfx/units/antivirus/CellHealer.png")
requireText = "1 AntiVirus Client"
requireFunc = function() return shop.bits >= 25 and immuneSystem:getNumber("AntiVirus Client") >= 1 end

info = "This is what you should\n"..
		"have on your PC. Ingame\n"..
		"As well as in real life."

maxTroops = 10
 
return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}