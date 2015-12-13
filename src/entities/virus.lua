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
		virus.unit[#virus.unit + 1] = {name = name, x = x, y = y, z = z,
										hp = virus.unitList[name].hp,
										range = virus.unitList[name].range,
										w = virus.unitList[name].w,
										h = virus.unitList[name].h,
										effect = virus.unitList[name].effect,
										amount = virus.unitList[name].amount}
	end
end


local function fighter(self)	-- fighter behaviour
	local pT = {} -- possible targets

	for _, t in pairs(immuneSystem.troop) do	-- loop through enemy troops
		pT[#pT+1] = {x = t.x + t.xvel * t.speed, -- a little bit of prediction
					 y = t.y + t.yvel * t.speed}
		pT[#pT].o = t --the actual object
	end

	for _, b in pairs(immuneSystem.unit) do	-- loop through enemy buildings
		pT[#pT + 1] = {}
		pT[#pT].x, pT[#pT].y = hexMap:hexToPixel(b.x, b.y, b.z)
		pT[#pT].o = b --the actual object
	end

	local minDist = 10000000
	local idx
	for _, p in pairs(pT) do -- loop through all possible targets in order to decide on one
		local dx, dy = (self.x - p.x), (self.y - p.y)
		local distSq = dx*dx + dy*dy
		if distSq < minDist then -- if we have found a closer target
			minDist = distSq
			self.target = p
		end
	end

	if minDist <= hexMap.cell_size*hexMap.cell_size then -- in range to attack
		self.target.o.hp = self.target.o.hp - self.amount
		print("Attacking "..self.target.o.name)
	end
end

function virus:loadTroops()
	virus:newTroop("Fighter", 1, 0, 10, 10, 4, fighter, 50)
end

function virus:newTroop(name, hp, range, w, h, amount, effect, speed)
	virus.troopList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect, speed = speed}
end

function virus:addTroop(name, x, y)
	virus.troop[#virus.troop + 1] = {name = name, x = x, y = y, hp = virus.troopList[name].hp,
									range = virus.troopList[name].range,
									w = virus.troopList[name].w,
									h = virus.troopList[name].h,
									effect = virus.troopList[name].effect,
									speed = virus.troopList[name].speed,
									amount = virus.troopList[name].amount,
									target = nil, xvel = 0, yvel = 0}
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

function virus:fastUpdate(dt)
	for i, v in pairs(virus.troop) do
		if v.target then
			v.xvel = v.target.x - v.x
			v.yvel = v.target.y - v.y
		end
		local velM = math.sqrt(v.xvel * v.xvel + v.yvel * v.yvel)
		if velM < hexMap.cell_size then v.xvel, v.yvel = 0, 0 end -- if it gets in range, stop moving
		if velM == 0 then velM = 1 end -- handle division by 0
		v.x = v.x + v.xvel / velM * dt * v.speed
		v.y = v.y + v.yvel / velM * dt * v.speed
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