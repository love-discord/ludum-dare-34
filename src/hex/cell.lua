local class = require 'lib.class'
local cell = class:subclass()

local colors = {
	["neutral"] = {200, 200, 200},
	["immune"] = {50, 100, 200},
	["virus"] = {200, 20, 20}
}

function cell:init(map, x, y, z, size, hp, damage, regen, defense, team)
	self.map = map
	
	self.x = x
	self.y = y
	self.z = z
	self.size = size

	self.team = team
	self.color = colors[team] or {0, 0, 0}

	self.hp = hp
	self.maxHP = hp
	self.dmg = damage
	self.regen = regen
	self.def = defense
end

--[[
Use example:
	for neighbor in cell:neighbors() do
		--blah
	end
--]]
function cell:neighbors()
	return coroutine.wrap(function()
		if self.x < self.map.radius then
			coroutine.yield(self.map.cells[self.x + 1][self.z])
		end
		if self.x > -self.map.radius then
			coroutine.yield(self.map.cells[self.x - 1][self.z])
		end
		if self.z < self.map.radius then
			coroutine.yield(self.map.cells[self.x][self.z + 1])
		end
		if self.z > -self.map.radius then
			coroutine.yield(self.map.cells[self.x][self.z - 1])
		end
		if self.y < self.map.radius then
			coroutine.yield(self.map.cells[self.x - 1][self.z + 1])
		end
		if self.y > -self.map.radius then
			coroutine.yield(self.map.cells[self.x + 1][self.z - 1])
		end
	end)
end

-- Draws the cell on the screen
function cell:draw(mode)
	self.color[4] = nil
	love.graphics.setColor(self.color)

	local vertices = {}
	for i = 0, 5 do
		local x, y = self:getCorner(i)
		vertices[#vertices + 1] = x
		vertices[#vertices + 1] = y
	end

	love.graphics.setLineWidth(2)
	love.graphics.polygon("line", vertices)

	self.color[4] = 200
	love.graphics.setColor(self.color)

	local vertices = {}
	for i = 0, 5 do
		local x, y = self:getCorner(i)
		vertices[#vertices + 1] = x
		vertices[#vertices + 1] = y
	end

	love.graphics.polygon("fill", vertices)
end

function cell:getCorner(i)
	local angle_deg = 60 * i + 30
	local angle_rad = math.pi / 180 * angle_deg

	local cx, cy = self.map:hexToPixel(self.x, self.y, self.z)

	return cx + math.cos(angle_rad) * self.size,
			cy + math.sin(angle_rad) * self.size
end

function cell:update(dt)
	-- loops through every cell
	for x = 1, #hexMap.cells do
		for z = 1, #hexMap.cells[x] do

			-- loops through every neighbor
			print(x, z)
			local neighbor = hexMap:inRange(hexMap.cells[x][z].x, hexMap.cells[x][z].y, hexMap.cells[x][z].z, 1)
			for i = 1, #neighbor do
				local target = hexMap:getCell(neighbor[i].x, neighbor[i].y, neighbor[i].z)
				if hexMap.cells[x][z].team ~= target.team then
					if hexMap.cells[x][z].team ~= "neutral" then
						print("hi")
						target.hp = target.hp - hexMap.cells[x][z].dmg + target.def
					end
					if target.hp <= 0 then
						target.team = hexMap.cells[x][z].team
					end
				end
			end
			hexMap.cells = neighbor
		end
	end


	for x, row in pairs(hexGrid.cells) do
		for z, cell in pairs(row) do
			local cellList = hexMap:inRange(cell.x, cell.y, cell.z, 1)
			for i = 1, #cellList do
				local target = hexMap:getCell(cellList[i].x, cellList[i].y, cellList[i].z)
				print(x, z)
				print(cell.team, target.team)
				if cell.team ~= target.team then
					if cell.team ~= "neutral" then
						target.hp = target.hp - cell.dmg + target.def
					end
					if target.hp <= 0 then
						target.team = cell.team
					end
				end
			end
		end
	end
end

return cell