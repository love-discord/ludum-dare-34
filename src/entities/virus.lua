virus = {
	unitList = {},
	unit = {}
}

local function proteinFactory(x, y, z, amt)
	if math.random() < amt then
		virus:addTroop("Fighter", x, z)
	end
end

local function cellDamager(x, y, z, amt)
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp - amt
		hexMap:getCell(x, y, z).color = {255, 255, 0}
	end
end

function virus:loadUnits()
	virus:newUnit("Protein factory", 50, 1, 32, 48, 1/12, proteinFactory)
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

function virus:addUnit(name, x, y)
	if not virus:find(x, y) then
		virus.unit[#virus.unit + 1] = {name = name, x = x, y = y, hp = virus.unitList[name].hp, range = virus.unitList[name].range, w = virus.unitList[name].w, h = virus.unitList[name].h}
	end
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
end

function virus:draw()
	for i = 1, #virus.unit do
		love.graphics.setColor(200, 0, 0)
		love.graphics.rectangle("fill", virus.unit[i].x * 32, virus.unit[i].y * 32, virus.unit[i].w, virus.unit[i].h)
	end
end