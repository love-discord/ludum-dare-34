-- src.unit.antivirus.chipHealer.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Chip Healer"
hp = 50
range = 2
w = 32
h = 48

effectText = "Heals friendly chips by\n"..
				"5HP every tick."

effect = function(self, x, y, z, amt)
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp + amount
	end
	spawnLight(self, 15, 50,100)
end

amount = 10
cost = 50
img = love.graphics.newImage("gfx/units/antivirus/CellHealer.png")
requireText = "-"
requireFunc = function() return shop.bits >= 50 end

info = "Those under my\n"..
		"protection will live.\n"..
		"Others'll have to push\n"..
		"their luck."

maxTroops = 10

return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}
