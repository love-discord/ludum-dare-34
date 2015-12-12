immuneSystem = {
	unitList = {
		["Cell Healer"] = {hp = 50, range = 2, w = 32, h = 48, effect = ""}
	}
	unit = {}
}

function immuneSystem:find(x, y)
	local occupied = false
	local id

	for i = 1, #immuneSystem.unit do
		if immuneSystem.unit[i].x == x and immuneSystem.unit[i].y == y then
			occupied = true
			id = i
			break
		end
	end

	return occupied, id
end

function immuneSystem:addUnit(name, x, y)
	if not immuneSystem:find(x, y) then
		immuneSystem.unit[#immuneSystem.unit + 1] = {name = name, x = x, y = y, hp = immuneSystem.unitList[name].hp, range = immuneSystem.unitList[name].range, w = immuneSystem.unitList[name].w, h = immuneSystem.unitList[name].h}
	end
end

function immuneSystem:remove(x, y)
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

function immuneSystem:draw()
	for i = 1, #immuneSystem.unit do
		love.graphics.setColor(0, 100, 255)
		love.graphics.rectangle("fill", immuneSystem.unit[i].x, immuneSystem.unit[i].y, immuneSystem.unit[i].w, immuneSystem.unit[i].h)
	end
end