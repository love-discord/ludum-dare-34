virus = {
	unitList = {},
	unit = {},
	troopList = {},
	troop = {}
}

local function proteinFactory(x, y, z, amt)	-- effect is the spawn chance the bigger, the more fighters spawn
	if math.random() < amt then
		virus:addTroop("Fighter", hexMap:hexToPixel(x, y, z))
	end
end

local function cellDamager(x, y, z, amt)
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp - amt
		hexMap:getCell(x, y, z).color = {255, 255, 0}
	end
end

function virus:loadUnits()
	virus:newUnit("Bug factory", 50, 1, 32, 48, 1/12, proteinFactory) -- should spawn a fighter every 5s on average
	virus:newUnit("Cell Damager", 50, 2, 32, 48, 1, cellDamager)
end

-- creates a new unit __TYPE__
function virus:newUnit(name, hp, range, w, h, amount, effect)
	virus.unitList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect}
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
		table.insert(virus.unit, 	{name = name, x = x, y = y, z = z,
										hp = self.unitList[name].hp,
										range = self.unitList[name].range,
										w = self.unitList[name].w,
										h = self.unitList[name].h,
										effect = self.unitList[name].effect,
										amount = self.unitList[name].amount})
	end
end

function virus:loadTroops()
	self:newTroop("Fighter", 1, 0, 10, 10, 4, require("src.AI.virus_fighter"), 50)
end

function virus:newTroop(name, hp, range, w, h, amount, effect, speed)
	self.troopList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect, speed = speed}
end

function virus:addTroop(name, x, y)
	table.insert(self.troop,	{name = name, x = x, y = y,
									hp = self.troopList[name].hp,
									range = self.troopList[name].range,
									w = self.troopList[name].w,
									h = self.troopList[name].h,
									effect = self.troopList[name].effect,
									speed = self.troopList[name].speed,
									amount = self.troopList[name].amount,
									target = nil, xvel = 0, yvel = 0})
end

function virus:remove(x, y)
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
			self.unit[i] = nil
		else
			local inRange = hexMap:inRange(unit.x, unit.y, unit.z, unit.range)
			for v = 1, #inRange do
				unit.effect(inRange[v].x, inRange[v].y, inRange[v].z, unit.amount)
			end
		end
	end
	for i, t in pairs(self.troop) do
		t:effect()
	end
end

function virus:fastUpdate(dt)
	for i, v in pairs(self.troop) do
		v.xvel, v.yvel = 0, 0
		if v.target then
			v.xvel = v.target.x - v.x
			v.yvel = v.target.y - v.y
		end
		local velM = math.sqrt(v.xvel * v.xvel + v.yvel * v.yvel)
		if velM > hexMap.cell_size then -- if not in range (should still move)
			if velM == 0 then velM = 1 end -- handle division by 0
			v.x = v.x + v.xvel / velM * dt * v.speed
			v.y = v.y + v.yvel / velM * dt * v.speed
		end
	end
end

function virus:draw()
	for i, unit in pairs(self.unit) do
		local x, y = hexMap:hexToPixel(unit.x, unit.y, unit.z)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", x - unit.w / 2, y - unit.h / 2 - 10, unit.w, unit.h)
	end
	for i, t in pairs(self.troop) do
		love.graphics.setColor(255, 200, 0)
		love.graphics.rectangle("fill", t.x - t.w / 2, t.y - t.h / 2 - 10, t.w, t.h)
	end
end