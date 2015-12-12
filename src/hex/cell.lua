local class = require 'lib.class'
local cell = class:subclass()

local colors = {
	neutral = {200, 200, 200},
	immune = {50, 100, 200},
	virus = {200, 20, 20}
}

function cell:init(map, x, y, z, size, hp, damage, regen, defense, team)
	self.map = map

	self.x = x
	self.y = y
	self.z = z
	self.size = 0
  self.tSize = size

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
		if self.x < self.map.radius and self.z > -self.map.radius then
			coroutine.yield(self.map.cells[self.x + 1][self.z - 1])
		end
		if self.x > -self.map.radius and self.z < self.map.radius then
			coroutine.yield(self.map.cells[self.x - 1][self.z + 1])
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
	love.graphics.setColor(255, 255, 255)
	local x, y = hexMap:hexToPixel(self.x, self.y, self.z)
	love.graphics.print(self.hp, x, y)
end

function cell:getCorner(i)
	local angle_deg = 60 * i + 30
	local angle_rad = math.pi / 180 * angle_deg

	local cx, cy = self.map:hexToPixel(self.x, self.y, self.z)

	return cx + math.cos(angle_rad) * self.size,
			cy + math.sin(angle_rad) * self.size
end

function cell:update(dt)
  self.size = self.size + 1*dt*100
  if self.size > self.tSize then self.size = self.size - 1*dt*100 end
	self.hp = self.hp + self.regen
	for neighbor in self:neighbors() do
		if neighbor.team ~= self.team and neighbor.team ~= 'neutral' then
			neighbor.hp = neighbor.hp - self.dmg + neighbor.def
		end
		if neighbor.hp > neighbor.maxHP then
			neighbor.hp = neighbor.maxHP
		elseif neighbor.hp <= 0 then
			neighbor.team = self.team
			neighbor.hp = self.hp / 2
			neighbor.color = colors[self.team]
			neighbor.dmg = 10
			neighbor.mapHP = 100
			neighbor.def = 0
		end
	end
end

return cell
