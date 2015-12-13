immuneSystem = {
	unitList = {},
	unit = {},
	troop = {},
	troopList = {}
}

function cellHealer(self, x, y, z, amount)
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp + amount
	end
end

function cellDamageBooster(self, x, y, z, amount)
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).dmg = hexMap:getCell(x, y, z).dmg + amount
	end
end

function cellDamager(self, x, y, z, amount)
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team ~= "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp - amount
	end
end

function bugfixerSpawn(self, x, y, z, amount)
	if hexMap:getCell(x, y, z) == nil then return end
	if math.random() < amount and self.troopsAlive < self.maxTroops then
		local hexPixel = {hexMap:hexToPixel(x, y, z)}
		immuneSystem:addTroop("Bugfixer", hexPixel[1], hexPixel[2], self.id)
		self.troopsAlive = self.troopsAlive + 1
	end
end

function immuneSystem:loadUnits()
	immuneSystem:newUnit("Chip Healer", 		50, 2, 32, 48, false, "Heals friendly chips by\n5HP every tick." ,cellHealer, 			10, 50, love.graphics.newImage("gfx/units/antivirus/CellHealer.png"), "Nothing", 				function() return true end, "Those under my\nprotection will live.\nOthers'll have to push\ntheir luck.")
	immuneSystem:newUnit("Chip Damage Booster", 50, 2, 32, 48, false, "Boosts damage of friendly\nchips."		  ,cellDamageBooster, 	2, 50, love.graphics.newImage("gfx/units/antivirus/cellDamageBooster.png"), "2 Cell Healers", 	function() return false end, "Warning:// malware\ndetected.\nUpgrading hardware..")
	immuneSystem:newUnit("Bug Fixing Tower",	50, 1, 32, 48, false, "Damages enemy chips."		  			,cellDamager,		10, 150, love.graphics.newImage("gfx/units/antivirus/cellDamager.png"),		 	"2 Cell Healers", 	function() return false end, "Full-on offensive")
	immuneSystem:newUnit("Debugger Spawn", 		50, 0, 32, 48, false, "Spawns a debugger."						  ,bugfixerSpawn,	 1/12, 666, love.graphics.newImage("gfx/units/antivirus/bugfixerSpawn.png"), "Test", 				function() return true end, "The dream of all\nprogrammers. An\nautomatic debugger.", 10)

	return immuneSystem.unitList
end

-- creates a new unit __TYPE__
function immuneSystem:newUnit(name, hp, range, w, h, movable, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops)
	immuneSystem.unitList[name] = {name = name, hp = hp, range = range, w = w, h = h, movable = movable,
									effectText = effectText, effect = effect, amount = amount, cost = cost, img = img,
									requireText = requireText, requireFunc = requireFunc, info = info or "Unit",
									maxTroops = maxTroops}
	stats.unitsAlive[name] = 0
end

function immuneSystem:find(x, y, z)
	local occupied = false
	local id

	for i = 1, #immuneSystem.unit do
		if immuneSystem.unit[i].x == x and immuneSystem.unit[i].y == y and immuneSystem.unit[i].z == z then
			occupied = true
			id = i
			break
		end
	end

	return occupied, id
end


-- spawns a new unit
function immuneSystem:addUnit(name, x, y, z)
	if not immuneSystem:find(x, y, z) then
		table.insert(immuneSystem.unit, {name = name, x = x, y = y, z = z, id = #immuneSystem.unit + 1,
						hp = immuneSystem.unitList[name].hp, range = immuneSystem.unitList[name].range,
						amount = immuneSystem.unitList[name].amout, w = immuneSystem.unitList[name].w,
						h = immuneSystem.unitList[name].h, effect = immuneSystem.unitList[name].effect,
						amount = immuneSystem.unitList[name].amount, img = immuneSystem.unitList[name].img,
						info = immuneSystem.unitList[name].info, troopsAlive = 0, maxTroops = immuneSystem.unitList[name].maxTroops})
	end
end

function immuneSystem:remove(x, y, z)
	local occupied, id = immuneSystem:find(x, y, z)
	local tempUnit = {}

	if occupied then
		for i = 1, #immuneSystem.unit do
			if i ~= id then
				tempUnit[#tempUnit + 1] = immuneSystem.unit[i]
			end
			immuneSystem.unit[i] = nil
		end

		immuneSystem.unit = tempUnit
	end
end

function immuneSystem:loadTroops()
	self:newTroop("Bugfixer", 5, 0, 20, 20, 2, require("src.AI.antivirus_bugfix"), 50, love.graphics.newImage("res/immuneTroop.png"))
end

function immuneSystem:newTroop(name, hp, range, w, h, amount, effect, speed, img)
	self.troopList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect, speed = speed, img = img}
end

function immuneSystem:addTroop(name, x, y, unit)
	table.insert(self.troop,	{name = name, x = x, y = y,
									hp = self.troopList[name].hp,
									range = self.troopList[name].range,
									w = self.troopList[name].w,
									h = self.troopList[name].h,
									effect = self.troopList[name].effect,
									speed = self.troopList[name].speed,
									amount = self.troopList[name].amount,
									img = self.troopList[name].img,
									target = nil, xvel = 0, yvel = 0,
									unit = unit})
end


function immuneSystem:update(dt)
	for i, unit in pairs(immuneSystem.unit) do
		if unit.hp <= 0 then
			immuneSystem:remove(unit.x, unit.y, unit.z)
		else
			local inRange = hexMap:inRange(unit.x, unit.y, unit.z, unit.range)
			for v = 1, #inRange do
				unit:effect(inRange[v].x, inRange[v].y, inRange[v].z, unit.amount)
			end
		end
	end
	for i, troop in pairs(self.troop) do
		if troop.hp <= 0 then
			if self.unit[troop.unit] then
				self.unit[troop.unit].troopsAlive = self.unit[troop.unit].troopsAlive - 1
			end
			dyingTroop:died(troop)
			self.troop[i] = nil
		else
			troop:effect()
		end
	end
end

function immuneSystem:fastUpdate(dt)
	for i, v in pairs(self.troop) do
		v.xvel, v.yvel = 0, 0
		if v.target then
			v.xvel = v.target.x - v.x
			v.yvel = v.target.y - v.y
		end
		if v.target ~= nil then 
			local velM = v.xvel * v.xvel + v.yvel * v.yvel
			if velM > v.target.radius then -- if not in range (should still move)
				v.x = v.x + v.xvel / math.sqrt(velM) * dt * v.speed
				v.y = v.y + v.yvel / math.sqrt(velM) * dt * v.speed
			end
		end
	end
end

function immuneSystem:draw()
	for i = 1, #immuneSystem.unit do
		local x, y = hexMap:hexToPixel(immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].z)
		local sX = hexMap.cell_size / immuneSystem.unit[i].img:getWidth() 
		local sY = (hexMap.cell_size + hexMap.cell_size / 2) / immuneSystem.unit[i].img:getHeight()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(immuneSystem.unit[i].img, x - hexMap.cell_size / 2, y - (hexMap.cell_size + hexMap.cell_size / 2) / 2 - 10, 0, sX, sY)
	end
	for i, t in pairs(self.troop) do
		love.graphics.setColor(255, 255, 255)
		local sX, sY = (t.w/t.img:getWidth()), (t.h/t.img:getHeight())
		local velX, velY = t.xvel, t.yvel
		local magnitudeSq = velX * velX + velY * velY
		if math.abs(magnitudeSq) > 0.0001 then
			velX = velX / math.sqrt(magnitudeSq)
			velY = velY / math.sqrt(magnitudeSq)
		end
		love.graphics.draw(t.img, t.x - t.w / 2, t.y - t.h / 2 - 10, math.atan2(velY, velX) + math.pi/2, sX, sY)
	end
end

function immuneSystem:mousepressed(key)

end