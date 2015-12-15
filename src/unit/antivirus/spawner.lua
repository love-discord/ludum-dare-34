-- src.unit.antivirus.chipHealer.lua

local name, hp, range, w, h, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops
name = "AntiVirus Client"
hp = 45
range = 0
w = 32
h = 48

effectText = "Spawns a scanner."

effect = function(self, x, y, z, amt)
	if hexMap:getCell(x, y, z) == nil then return end
	if math.random() < amount and self.troopsAlive < self.maxTroops then
		local hexPixel = {hexMap:hexToPixel(x, y, z)}
		immuneSystem:addTroop("Scanner", hexPixel[1], hexPixel[2], self.id)
		self.troopsAlive = self.troopsAlive + 1
	end
	spawnLight(self, 50, 50, 50, 2)
end

amount = 1/3
cost = 65
img = love.graphics.newImage("gfx/units/antivirus/bugfixerSpawn.png")
requireText = "65 Bits"
requireFunc = function() return shop.bits >= 75 end

info = "Let's be serious.\n"..
		"If your PC is under\n"..
		"attack, you use\n"..
		"an antivirus client."

maxTroops = 10
 

return {name = name, hp = hp, range = range, w = w, h = h, effectText = effectText,
		effect = effect, amount = amount, cost = cost, img = img, requireText = requireText,
		requireFunc = requireFunc, info = info or "Unit", maxTroops = maxTroops, hasLight = false}