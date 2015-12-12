
--local building = require 'src.entities.building'

local cell = class:subclass()

function cell:init(map, x, y, z, size, hp, color)
	self.map = map
	
	self.x = x
	self.y = y
	self.z = z
	self.size = size

	self.color = color

	self.hp = hp
	--self.building = building:new()
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
	print(self.color.." @ "..self.x..","..self.y..","..self.z)
	love.graphics.setColor(self.color)

	local vertices = {}
	for i = 0, 5 do
		vertices[i * 2], vertices[i * 2 + 1] = self:getCorner(i)
	end

	love.graphics.polygon(mode, vertices)
end

function cell:getCorner(i)
	local angle_deg = 60 * i + 30
	local angle_rad = math.pi / 180 * angle_deg

	local cx, cy = self.map:cellPosition(self.x, self.y, self.z)

	return cx + math.cos(angle_rad) * self.size,
			cy + math.sin(angle_rad) * self.size
end

return cell

