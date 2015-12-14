require("lib.sound")
immuneSystem = {
	unitList = {},
	unit = {},
	troop = {},
	troopList = {},
	readable = {},

	unitInfo = false,
	float = false,
	x = 0
}

function spawnLight(self, r, g, b)
	local x, y = hexMap:hexToPixel(self.x, self.y, self.z)

	if not self.hasLight then
		local range = self.range * hexMap.cell_size * 2
		lightWorld:newLight(x, y, r, g, b, range)
		self.hasLight = true
	end
end

function immuneSystem:loadUnits()
	self.unitList["Chip Healer"] = require("src.unit.antivirus.chipHealer")
	self.unitList["Chip Damage Booster"] = require("src.unit.antivirus.chipDmgBooster")
	self.unitList["Debugging Tower"] = require("src.unit.antivirus.debuggingTower")
	self.unitList["AntiVirus Client"] = require("src.unit.antivirus.spawner")
	self.unitList["Memory Reader"] = require("src.unit.antivirus.memoryRadar")
	self.unitList["Real Time Protector"] = require("src.unit.antivirus.rtProtector")
	self.unitList["Bit Farmer"] = require("src.unit.antivirus.bitFarmer")
end

-- creates a new unit __TYPE__
function immuneSystem:newUnit(name, hp, range, w, h, movable, effectText, effect, amount, cost, img, requireText, requireFunc, info, maxTroops)
	immuneSystem.unitList[name] = {name = name, hp = hp, range = range, w = w, h = h, movable = movable,
									effectText = effectText, effect = effect, amount = amount, cost = cost, img = img,
									requireText = requireText, requireFunc = requireFunc, info = info or "Unit",
									maxTroops = maxTroops, hasLight = false}
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
		local unitType = immuneSystem.unitList[name]
		table.insert(immuneSystem.unit, {name = name, x = x, y = y, z = z, id = #immuneSystem.unit + 1,
						hp = unitType.hp, range = unitType.range,
						amount = unitType.amout, w = unitType.w,
						h = unitType.h, effect = unitType.effect,
						amount = unitType.amount, img = unitType.img,
						info = unitType.info, troopsAlive = 0, maxTroops = unitType.maxTroops})
	end
end

function immuneSystem:selectUnit(key, x, y, z)
	if key == "l" then
		local occupied, id = immuneSystem:find()
		if occupied and immuneSystem.unit[id].team == "immune" then
			immuneSystem.selected = id
		end
	end
end

function immuneSystem:remove(x, y, z)
	cellSound:play()

	local occupied, id = immuneSystem:find(x, y, z)
	local tempUnit = {}

	if occupied then
		for i = 1, #immuneSystem.unit do
			if i ~= id then
				tempUnit[#tempUnit + 1] = immuneSystem.unit[i]
			end
			immuneSystem.unit[i] = nil
		end

		immuneSystem.unit = tempUnit

		immuneSystem.unitInfo = false
		immuneSystem.selected = nil
	end
end

function immuneSystem:getNumber(name)
	local n = 0
	for i, unit in pairs(immuneSystem.unit) do
		if unit.name == name then
			n = n + 1
		end
	end
	return n
end

function immuneSystem:loadTroops()
	self:newTroop("Scanner", 5, 0, 20, 20, 2, require("src.AI.antivirus_bugfix"), 50, love.graphics.newImage("gfx/units/immuneTroop.png"))
end

function immuneSystem:newTroop(name, hp, range, w, h, amount, effect, speed, img)
	self.troopList[name] = {name = name, hp = hp, range = range, w = w, h = h, amount = amount, effect = effect, speed = speed, img = img}
end

function immuneSystem:addTroop(name, x, y, unit)
	table.insert(self.troop,	{name = name, x = x, y = y,
									hp = self.troopList[name].hp,
									range = self.troopList[name].range,
									w = self.troopList[name].w,
									h = self.troopList[name].h,
									effect = self.troopList[name].effect,
									speed = self.troopList[name].speed,
									amount = self.troopList[name].amount,
									img = self.troopList[name].img,
									target = nil, xvel = 0, yvel = 0,
									unit = unit})
end


function immuneSystem:update(dt)
	immuneSystem.readable = {}
	for i, unit in pairs(immuneSystem.unit) do
		if unit.hp <= 0 then
			immuneSystem:remove(unit.x, unit.y, unit.z)
		else
			local inRange = hexMap:inRange(unit.x, unit.y, unit.z, unit.range)
			unit.hasLight = false
			for v = 1, #inRange do
				self.unitList[unit.name].effect(unit, inRange[v].x, inRange[v].y, inRange[v].z, unit.amount)
			end
		end
	end

	for i, troop in pairs(self.troop) do
		if troop.hp <= 0 then
			if self.unit[troop.unit] then
				self.unit[troop.unit].troopsAlive = self.unit[troop.unit].troopsAlive - 1
			end
			dyingTroop:died(troop)
			self.troop[i] = nil
			virus.ai.bits = virus.ai.bits + 1
		else
			troop:effect()
		end
	end
end

function immuneSystem:fastUpdate(dt)
	for i, v in pairs(self.troop) do
		v.xvel, v.yvel = 0, 0
		if v.target then
			v.xvel = (v.target.X or v.target.x) - v.x
			v.yvel = (v.target.Y or v.target.y) - v.y
		end
		if v.target ~= nil then 
			local velM = v.xvel * v.xvel + v.yvel * v.yvel
			if velM > v.target.radius then -- if not in range (should still move)
				v.x = v.x + v.xvel / math.sqrt(velM) * dt * v.speed
				v.y = v.y + v.yvel / math.sqrt(velM) * dt * v.speed
			end
		end
	end
end

function immuneSystem:infoboxUpdate(dt)
	-- selected info box
	if immuneSystem.selected ~= nil then
		local width = font.prototype[32]:getWidth(immuneSystem.unit[immuneSystem.selected].name) + 100
		if immuneSystem.unitInfo then
			if immuneSystem.x < width then
				immuneSystem.x = immuneSystem.x + ((width - immuneSystem.x) * 12) * dt
			else
				immuneSystem.x = width
			end
		else
			if immuneSystem.x > 0 then
				immuneSystem.x = immuneSystem.x - (math.abs(immuneSystem.x - (width + 1)) * 12) * dt
			else
				immuneSystem.x = 0
				immuneSystem.selected = nil
			end
		end

		if love.mouse.getX() > love.graphics.getWidth() - immuneSystem.x + 10 and love.mouse.getX() < love.graphics.getWidth() and love.mouse.getY() > love.graphics.getHeight() / 2 + 160 and love.mouse.getY() < love.graphics.getHeight() / 2 + 190 then
			immuneSystem.float = true
		else
			immuneSystem.float = false
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
	for i, t in pairs(self.troop) do
		love.graphics.setColor(255, 255, 255)
		local sX, sY = (t.w/t.img:getWidth()), (t.h/t.img:getHeight())
		local velX, velY = t.xvel, t.yvel
		local magnitudeSq = velX * velX + velY * velY
		if math.abs(magnitudeSq) > 0.0001 then
			velX = velX / math.sqrt(magnitudeSq)
			velY = velY / math.sqrt(magnitudeSq)
		end
		love.graphics.draw(t.img, t.x - t.w / 2, t.y - t.h / 2 - 10, math.atan2(velY, velX) + math.pi/2, sX, sY)
	end

	if immuneSystem.selected ~= nil then
		hexMap:drawInRange(immuneSystem.unit[immuneSystem.selected].x, immuneSystem.unit[immuneSystem.selected].y, immuneSystem.unit[immuneSystem.selected].z, immuneSystem.unit[immuneSystem.selected].range)
	end
	immuneSystem:drawReadables()
end

function immuneSystem:drawReadables()
	for i = 1, #immuneSystem.readable do
		if state.drawHP then
			local cell = hexMap:getCell(immuneSystem.readable[i].x, immuneSystem.readable[i].y, immuneSystem.readable[i].z)
			local x, y = hexMap:hexToPixel(immuneSystem.readable[i].x, immuneSystem.readable[i].y, immuneSystem.readable[i].z)
			love.graphics.setFont(font.prototype[20])
			local hp = round(cell.hp)
			love.graphics.print(cell.hp, x, y)
		end
	end
end

function immuneSystem:drawSelectedUnitInfo()
	if immuneSystem.x > 0 and immuneSystem.selected ~= nil then
		local width = math.max(300, font.prototype[32]:getWidth(immuneSystem.unit[immuneSystem.selected].name) + 150)

		local polygon = rounded_rectangle(love.graphics.getWidth() - immuneSystem.x, love.graphics.getHeight() / 2 - 200, width, 400, 10, 10, 10, 10, 10)
		love.graphics.setColor(40, 40, 35)
		love.graphics.polygon("fill", polygon)

		local polygon = rounded_rectangle(love.graphics.getWidth() - immuneSystem.x + 5, love.graphics.getHeight() / 2 - 195, width - 10, 390, 10, 10, 10, 10, 10)
		love.graphics.setColor(0, 255, 255)
		love.graphics.polygon("line", polygon)

		local polygon = rounded_rectangle(love.graphics.getWidth() - immuneSystem.x + 10, love.graphics.getHeight() / 2 + 160, width - 20, 30, 10, 10, 10, 10, 10)
		if self.float then
			love.graphics.setColor(0, 255, 255, 150)
			love.graphics.polygon("fill", polygon)
			love.graphics.setColor(0, 255, 255)
		end
		love.graphics.polygon("line", polygon)

		local xcoord = love.graphics.getWidth() - immuneSystem.x + 5
		local ycoord = love.graphics.getHeight() / 2 - 195

		love.graphics.line(xcoord, ycoord + 40, xcoord + width - 10, ycoord + 40)
		love.graphics.setFont(font.prototype[32])
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(immuneSystem.unit[immuneSystem.selected].name, 		 xcoord + 5, ycoord + 3)

		love.graphics.setFont(font.prototype[20])
		love.graphics.print("HP: "..immuneSystem.unit[immuneSystem.selected].hp.."/"..immuneSystem.unitList[immuneSystem.unit[immuneSystem.selected].name].hp, xcoord + 5, ycoord + 45)
		love.graphics.print("Sell for: "..tostring(round(immuneSystem.unitList[immuneSystem.unit[immuneSystem.selected].name].cost / 3)).." [Bits]", xcoord + width / 2 - font.prototype[20]:getWidth("Sell for: "..tostring(round(immuneSystem.unitList[immuneSystem.unit[immuneSystem.selected].name].cost / 3)).." [Bits]") / 2 - 20, love.graphics.getHeight() / 2 + 165)

		love.graphics.setFont(font.roboto.regular[20])
		love.graphics.print(immuneSystem.unitList[immuneSystem.unit[immuneSystem.selected].name].effectText, xcoord + 5, ycoord + 75)

		-- gets how many lines the text has
		local lines = 1
		local text = immuneSystem.unitList[immuneSystem.unit[immuneSystem.selected].name].info

		for i = 1, text:len() do
			if text:sub(i, i) == "\n" then
				lines = lines + 1
			end
		end
		-- end
		love.graphics.setFont(font.roboto.italic[20])
		love.graphics.print(text, xcoord + 5, love.graphics.getHeight() / 2 + 165 - lines * font.roboto.italic[20]:getHeight(text) - 10)
	end
end

function immuneSystem:sell(x, y, z)
	immuneSystem.selected = id
	immuneSystem.unitInfo = true
	immuneSystem.float = false

	oc, id = immuneSystem:find(x, y, z)
	shop.bits = shop.bits + round(self.unitList[immuneSystem.unit[id].name].cost / 3)
	immuneSystem:remove(x, y, z)
end

function immuneSystem:mousepressed(key)
	local x, y, z = mouse:getHexCoords()
	local occupied, id = immuneSystem:find(x, y, z)

	if immuneSystem.float then
		if key == "l" then
			immuneSystem:sell(self.unit[self.selected].x, self.unit[self.selected].y, self.unit[self.selected].z)
		end
	end

	if occupied then
		if key == "l" then
			immuneSystem.selected = id
			immuneSystem.unitInfo = true
			immuneSystem.float = false
		end
	else
		immuneSystem.unitInfo = false
	end
end