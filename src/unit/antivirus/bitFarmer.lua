-- src.unit.antivirus.chipHealer.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "Bit Farmer"
hp = 50
range = 0
w = 32
h = 48

effectText = "Farms bits\n"..
				"for you"

effect = function(self, x, y, z, amt)
	shop.bits = shop.bits + amt
end

amount = 1
cost = 25
img = love.graphics.newImage("gfx/units/antivirus/bitFarmer.png")
requireText = "-"
requireFunc = function() return shop.bits >= 25 end

info = "Does the nasty\n"..
		"work for you"

maxTroops = 10
return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}
