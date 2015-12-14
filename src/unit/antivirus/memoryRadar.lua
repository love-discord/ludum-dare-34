-- src.unit.antivirus.memoryRadar.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Memory Reader"
hp = 50
range = 3
w = 32
h = 48

effectText = "Reads data of chips in\n"..
				"range."

effect = function(self, x, y, z)
	if hexMap:getCell(x, y, z) == nil then
		return
	end	
	immuneSystem.readable[#immuneSystem.readable + 1] = {x = x, y = y, z = z}
	spawnLight(self, 100, 100, 100, range)
end

cost = 25
img = love.graphics.newImage("gfx/units/antivirus/memoryreader.png")
requireText = "25 Bits"
requireFunc = function() return shop.bits >= 25 end

info = "I will show you things.\n"..
		"Things you have never\n"..
		"imagined to see."

maxTroops = 10
 
return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}
