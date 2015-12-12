immuneSystem = {
	unitList = {
		["Cell Healer"] = {hp = 50, range = 2, w = 32, h = 48, movable = false, effect = "hex:getCell(x, y, z).color = {0, 255, 0}"}
	},
	unit = {}
}

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
		immuneSystem.unit[#immuneSystem.unit + 1] = {name = name, x = x, y = y, z = z, hp = immuneSystem.unitList[name].hp, range = immuneSystem.unitList[name].range, w = immuneSystem.unitList[name].w, h = immuneSystem.unitList[name].h, effect = immuneSystem.unitList[name].effect}
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
		local inRange = hex:inRange(immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].z, immuneSystem.unit[i].range)
		for v = 1, #inRange do
			local x, y, z = unpack(inRange[v])
			loadstring(immuneSystem.unitList[immuneSystem.unit[i].name].effect)()
		end
	end
end

function immuneSystem:draw()
	for i = 1, #immuneSystem.unit do
		local x, y = hex:hexToPixel(immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].z)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", x - immuneSystem.unit[i].w / 2, y - immuneSystem.unit[i].h / 2 - 10, immuneSystem.unit[i].w, immuneSystem.unit[i].h)
	end
end

function immuneSystem:mousepressed(key)

end