
--[[ effects ]]--
function cellHealer(x, y, z, amount)
	hexMap:getCell(x, y, z).color = {0, 255, 0}
end

immuneSystem = {
	unitList = {
		["Cell Healer"] = {hp = 50, range = 2, w = 32, h = 48, movable = false, effect = cellHealer, amount = 1}
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
		immuneSystem.unit[#immuneSystem.unit + 1] = {name = name, x = x, y = y, z = z, hp = immuneSystem.unitList[name].hp, range = immuneSystem.unitList[name].range, amount = immuneSystem.unitList[name].amout, w = immuneSystem.unitList[name].w, h = immuneSystem.unitList[name].h, effect = immuneSystem.unitList[name].effect}
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
		print(immuneSystem.unit[i].x)
		local inRange = hexMap:inRange(immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].z, immuneSystem.unit[i].range)
		for v = 1, #inRange do
			immuneSystem.unit[i].effect(inRange[v].x, inRange[v].y, inRange[v].z)
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