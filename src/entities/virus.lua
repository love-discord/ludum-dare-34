virus = {
	unitList = {},
	unit = {},
	troopList = {},
	troop = {}
}

local function proteinFactory(x, y, z, amt)
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
	virus:newUnit("Protein factory", 50, 1, 32, 48, 1/30, proteinFactory) -- should spawn a fighter every 5s on average
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
		print(name)
		print(virus.unitList[name])
		virus.unit[#virus.unit + 1] = {name = name, x = x, y = y, z = z,
										hp = virus.unitList[name].hp,
										range = virus.unitList[name].range,
										w = virus.unitList[name].w,
										h = virus.unitList[name].h,
										effect = virus.unitList[name].effect,
										amount = virus.unitList[name].amount}
	end
end


local function fighter(self)
	if not self.xvel then self.xvel, self.yvel = 0, 0 end
	self.xvel = self.xvel + math.random()*10 - 5
	self.yvel = self.yvel + math.random()*10 - 5
	self.x = self.x + self.xvel
	self.y = self.y + self.yvel
end

function virus:loadTroops()
	virus:newTroop("Fighter", 1, 0, 10, 10, 1, fighter)
end

function virus:newTroop(name, hp, range, w, h, amount, effect)
	virus.troopList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect}
end

function virus:addTroop(name, x, y)
	virus.troop[#virus.troop + 1] = {name = name, x = x, y = y, hp = virus.troopList[name].hp,
									range = virus.troopList[name].range,
									w = virus.troopList[name].w,
									h = virus.troopList[name].h,
									effect = virus.troopList[name].effect}
end

function virus:remove(x, y)
	local occupied, id = virus:find(x, y)
	local tempUnit = {}

	if occupied then
		for i = 1, #virus.unit do
			if i ~= id then
				tempUnit[#tempUnit + 1] = virus.unit[i]
			end
			virus.unit[i] = nil
		end

		virus.unit = tempUnit
	end
end

function virus:update()
	for i = 1, #virus.unit do
		local inRange = hexMap:inRange(virus.unit[i].x, virus.unit[i].y, virus.unit[i].z, virus.unit[i].range)
		for v = 1, #inRange do
			virus.unit[i].effect(inRange[v].x, inRange[v].y, inRange[v].z, virus.unit[i].amount)
		end
	end
	for i = 1, #virus.troop do
		virus.troop[i]:effect()
	end
end

function virus:draw()
	for i = 1, #virus.unit do
		local x, y = hexMap:hexToPixel(virus.unit[i].x, virus.unit[i].y, virus.unit[i].z)
		love.graphics.setColor(255, 100, 0)
		love.graphics.rectangle("fill", x - virus.unit[i].w / 2, y - virus.unit[i].h / 2 - 10, virus.unit[i].w, virus.unit[i].h)
	end
	for i = 1, #virus.troop do
		love.graphics.setColor(255, 200, 0)
		love.graphics.rectangle("fill", virus.troop[i].x - virus.troop[i].w / 2, virus.troop[i].y - virus.troop[i].h / 2 - 10, virus.troop[i].w, virus.troop[i].h)
	end
end