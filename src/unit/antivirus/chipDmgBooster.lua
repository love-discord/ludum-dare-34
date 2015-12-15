-- src.unit.antivirus.chipHealer.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Chip Damage Booster"
hp = 50
range = 2
w = 32
h = 48

effectText = "Boosts damage of friendly\n"..
				"chips."

effect = function(self, x, y, z, amt)
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).dmg = hexMap:getCell(x, y, z).dmg + amount
	end
	spawnLight(self, 100, 80, 80)
end

amount = 2
cost = 60
img = love.graphics.newImage("gfx/units/antivirus/cellDamageBooster.png")
requireText = "2 Chip Healers"
requireFunc = function() return immuneSystem:getNumber("Chip Healer") >= 2 and shop.bits >= 60 end

info = "Warning:// malware\n"..
		"detected.\n"..
		"Upgrading hardware..."
 
return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}
