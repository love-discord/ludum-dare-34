--[[ effects ]]--
function cellHealer(x, y, z, amount)
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).color = {0, 255, 0}
	end
end

function cellDamageBooster(x, y, z, amount)
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).dmg = hexMap:getCell(x, y, z).dmg + amount
		hexMap:getCell(x, y, z).color = {0, 255, 0}
	end
end

immuneSystem = {
	unitList = {},
	unit = {}
}

function immuneSystem:loadUnits()
	immuneSystem:newUnit("Cell Healer", 50, 2, 32, 48, false, cellHealer, 2)
	immuneSystem:newUnit("Cell Damage Booster", 50, 2, 32, 48, false, cellDamageBooster, 2)
end

function immuneSystem:newUnit(name, hp, range, w, h, movable, effect, amount, cost, img)
	immuneSystem.unitList[name] = {hp = hp, range = range, w = w, h = h, movable = movable, effect = effect, amount = amount, cost = cost, img = img}
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

function immuneSystem:addUnit(name, x, y, z)
	if not immuneSystem:find(x, y, z) then
		immuneSystem.unit[#immuneSystem.unit + 1] = {name = name, x = x, y = y, z = z, hp = immuneSystem.unitList[name].hp, range = immuneSystem.unitList[name].range, amount = immuneSystem.unitList[name].amout, w = immuneSystem.unitList[name].w, h = immuneSystem.unitList[name].h, effect = immuneSystem.unitList[name].effect, amount = immuneSystem.unitList[name].amount}
	end
end

function immuneSystem:remove(x, y, z)
	local occupied, id = immuneSystem:find(x, y)
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

function immuneSystem:update(dt)
	for i = 1, #immuneSystem.unit do
		local inRange = hexMap:inRange(immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].z, immuneSystem.unit[i].range)
		for v = 1, #inRange do
			immuneSystem.unit[i].effect(inRange[v].x, inRange[v].y, inRange[v].z, immuneSystem.unit[i].amount)
		end
	end
end

function immuneSystem:draw()
	for i = 1, #immuneSystem.unit do
		local x, y = hexMap:hexToPixel(immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].z)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", x - immuneSystem.unit[i].w / 2, y - immuneSystem.unit[i].h / 2 - 10, immuneSystem.unit[i].w, immuneSystem.unit[i].h)
	end
end

function immuneSystem:mousepressed(key)

end