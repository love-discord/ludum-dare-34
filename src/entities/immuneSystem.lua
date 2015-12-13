--[[ effects ]]--
function cellHealer(x, y, z, amount)
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).hp = hexMap:getCell(x, y, z).hp + 5
	end
end

function cellDamageBooster(x, y, z, amount)
	if hexMap:getCell(x, y, z).team == "immune" then
		hexMap:getCell(x, y, z).dmg = hexMap:getCell(x, y, z).dmg + amount
	end
end

immuneSystem = {
	unitList = {},
	unit = {},
	troop = {},
	troopList = {}
}

function immuneSystem:loadUnits()
	local sampleImg = love.graphics.newImage("res/sample.png")
	immuneSystem:newUnit("Cell Healer", 		50, 2, 32, 48, false, "Heals friendly cells with 5HP every tick." ,cellHealer, 			2, 50,  sampleImg, "Nothing", 			function() return true end)
	immuneSystem:newUnit("Cell Damage Booster", 50, 2, 32, 48, false, "Boosts damage of friendly cells."		  ,cellDamageBooster, 	2, 150, love.graphics.newImage("gfx/units/antivirus/CellHealer.png"), "2 Cell Healers", 	function() return false end)
	immuneSystem:newUnit("Smth else", 			50, 2, 32, 48, false, "Does something."							  ,function() end,	 	2, 666, sampleImg, "Test", 				function() return math.floor(os.time() % 2)==1  end)
	immuneSystem:newUnit("Smth else2", 			50, 2, 32, 48, false, "Does something different."				  ,function() end,	 	2, 666, sampleImg, "Test", 				function() return math.floor(os.time() % 2)==0  end)
	return immuneSystem.unitList
end

-- creates a new unit __TYPE__
function immuneSystem:newUnit(name, hp, range, w, h, movable, effectText, effect, amount, cost, img, requireText, requireFunc)
	immuneSystem.unitList[name] = {name = name, hp = hp, range = range, w = w, h = h, movable = movable,
									effectText = effectText, effect = effect, amount = amount, cost = cost, img = img,
									requireText = requireText, requireFunc = requireFunc}
	stats.unitsAlive[name] = 0
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


-- spawns a new unit
function immuneSystem:addUnit(name, x, y, z)
	if not immuneSystem:find(x, y, z) then
		immuneSystem.unit[#immuneSystem.unit + 1] = {name = name, x = x, y = y, z = z, hp = immuneSystem.unitList[name].hp, range = immuneSystem.unitList[name].range, amount = immuneSystem.unitList[name].amout, w = immuneSystem.unitList[name].w, h = immuneSystem.unitList[name].h, effect = immuneSystem.unitList[name].effect, amount = immuneSystem.unitList[name].amount, img = immuneSystem.unitList[name].img}
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
		local sX = hexMap.cell_size / immuneSystem.unit[i].img:getWidth() 
		local sY = (hexMap.cell_size + hexMap.cell_size / 2) / immuneSystem.unit[i].img:getHeight()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(immuneSystem.unit[i].img, x - hexMap.cell_size / 2, y - (hexMap.cell_size + hexMap.cell_size / 2) / 2 - 10, 0, sX, sY)
	end
end

function immuneSystem:mousepressed(key)

end