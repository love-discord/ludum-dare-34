-- src.unit.antivirus.chipHealer.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Bit Farmer"
hp = 50
range = 0
w = 32
h = 48

effectText = "Gives you 3 additional\nbits every tick."

effect = function(self, x, y, z, amt)
	shop.bits = shop.bits + amt
	spawnLight(self, 80, 80, 0, 2)
end

amount = 3
cost = 75
img = love.graphics.newImage("gfx/units/antivirus/bitFarmer.png")
requireText = "75 Bits"
requireFunc = function() return shop.bits >= 75 end

info = "Am I worth it? There's\nonly one way to find out."

maxTroops = 10
return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}
