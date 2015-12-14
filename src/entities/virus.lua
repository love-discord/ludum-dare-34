require("lib.sound")
virus = {
	unitList = {},
	unit = {},
	troopList = {},
	troop = {}
}


function bugObfuscator(self, x, y, z, amount) -- healer
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team == "virus" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp + amount
	end
end

function bugCascadeMaker(self, x, y, z, amount) -- boost damage
	if hexMap:getCell(x, y, z) == nil then return end
	if hexMap:getCell(x, y, z).team == "virus" then
		hexMap:getCell(x, y, z).dmg = hexMap:getCell(x, y, z).dmg + amount
	end
end

function bugSpawn(self, x, y, z, amount)
	if hexMap:getCell(x, y, z) == nil then return end
	if math.random() < amount and self.troopsAlive < self.maxTroops then
		local hexPixel = {hexMap:hexToPixel(x, y, z)}
		virus:addTroop("Fighter", hexPixel[1], hexPixel[2], self.id)
		self.troopsAlive = self.troopsAlive + 1
	end
end

local function bugActivator(self, x, y, z, amt) -- damage
	if hexMap:getCell(x, y, z).team == "virus" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp - amt
		--hexMap:getCell(x, y, z).color = {255, 255, 0}
	end
end

function virus:loadUnits()
	virus:newUnit("Bug Factory", 		50, 0, 32, 48, 1/3,  bugSpawn, 10,			love.graphics.newImage("gfx/units/virus/bugSpawn.png"))
	virus:newUnit("Bug Activator", 		50, 2, 32, 48, 1,	 bugActivator, nil, 		love.graphics.newImage("gfx/units/virus/cellDamager.png"))
	virus:newUnit("Bug Cascade maker",	50, 2, 32, 48, 1, 	 bugCascadeMaker, nil,love.graphics.newImage("gfx/units/virus/cellDamageBooster.png"))
	virus:newUnit("Bug Obfuscator", 	50, 2, 32, 48, 1, 	 bugObfuscator, nil,		love.graphics.newImage("gfx/units/virus/cellHealer.png"))
end

-- creates a new unit __TYPE__
function virus:newUnit(name, hp, range, w, h, amount, effect, maxTroops, img)
	virus.unitList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect, maxTroops = maxTroops, img = img}
end

function virus:find(x, y)
	local occupied = false
	local id

	for i = 1, #virus.unit do
		if virus.unit[i].x == x and virus.unit[i].y == y then
			occupied = true
			id = i
			break
		end
	end

	return occupied, id
end

function virus:addUnit(name, x, y, z)
	if not virus:find(x, y, z) then
		table.insert(virus.unit, 	{id = #virus.unit+1, name = name, x = x, y = y, z = z,
										hp = self.unitList[name].hp,
										range = self.unitList[name].range,
										w = self.unitList[name].w,
										h = self.unitList[name].h,
										img = self.unitList[name].img,
										effect = self.unitList[name].effect,
										amount = self.unitList[name].amount,
										troopsAlive = 0,
										maxTroops = self.unitList[name].maxTroops})
	end
end

function virus:loadTroops()
	self:newTroop("Fighter", 5, 0, 20, 20, 2, require("src.AI.virus_fighter"), 50, love.graphics.newImage("gfx/units/virusTroop.png"))
end

function virus:newTroop(name, hp, range, w, h, amount, effect, speed, img)
	self.troopList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect, speed = speed, img = img}
end

function virus:addTroop(name, x, y, unit)
	table.insert(self.troop,	{name = name, x = x, y = y,
									hp = self.troopList[name].hp,
									range = self.troopList[name].range,
									w = self.troopList[name].w,
									h = self.troopList[name].h,
									effect = self.troopList[name].effect,
									speed = self.troopList[name].speed,
									amount = self.troopList[name].amount,
									img = self.troopList[name].img,
									unit = unit,
									target = nil, xvel = 0, yvel = 0})
end

function virus:remove(x, y)
  virusSound:play()
  
	local occupied, id = self:find(x, y)
	local tempUnit = {}

	if occupied then
		for i = 1, #self.unit do
			if i ~= id then
				tempUnit[#tempUnit + 1] = self.unit[i]
			end
			self.unit[i] = nil
		end

		self.unit = tempUnit
	end
end

function virus:update()
	for i, unit in pairs(self.unit) do
		if unit.hp <= 0 then
			self:remove(unit.x, unit.y, unit.z)
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

			shop.bits = shop.bits + 10
		else
			troop:effect()
		end
	end
end

function virus:fastUpdate(dt)
	for i, v in pairs(self.troop) do
		v.xvel, v.yvel = 0, 0
		if v.target then
			v.xvel = (v.target.X or v.target.x) - v.x
			v.yvel = (v.target.Y or v.target.y) - v.y
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

function virus:draw()
	for i, unit in pairs(self.unit) do
		local x, y = hexMap:hexToPixel(unit.x, unit.y, unit.z)
		local sX = hexMap.cell_size / unit.img:getWidth() 
		local sY = (hexMap.cell_size + hexMap.cell_size / 2) / unit.img:getHeight()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(unit.img, x - hexMap.cell_size / 2, y - (hexMap.cell_size + hexMap.cell_size / 2) / 2 - 10, 0, sX, sY)
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