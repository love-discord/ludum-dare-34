virus = {
	unitList = {
		["Cell Damager"] = {hp = 50, range = 2, w = 32, h = 48, effect = ""}
	},
	unit = {}
}

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

function virus:draw()
	for i = 1, #virus.unit do
		love.graphics.setColor(200, 0, 0)
		love.graphics.rectangle("fill", virus.unit[i].x * 32, virus.unit[i].y * 32, virus.unit[i].w, virus.unit[i].h)
	end
end