-- src.unit.antivirus.debuggingTower.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Debugging Tower"
hp = 50
range = 4
w = 32
h = 48

effectText = "Damages enemy chips."

effect = function(self, x, y, z, amt)
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team ~= "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp - amount
	end
	local range = self.range * hexMap.cell_size * 2
	spawnLight(self, 100, 50, 50)
end

amount = 10
cost = 150
img = love.graphics.newImage("gfx/units/antivirus/cellDamager.png")
requireText = "1 Chip Damage Booster"
requireFunc = function() return shop.bits >= 150 and virus:getNumber("Chip Damage Booster") >= 1 end

info = "The dream of all\n"..
		"programmers. An\n"..
		"automatic debugger."
 
return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}