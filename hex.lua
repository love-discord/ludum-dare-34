local class = require 'class'
local hex = class:subclass()
local cell = class:subclass()

function hex:init(radius)
	self.cells = {}
	self.radius = radius
	for x = -radius, radius do
		self.cells[x] = {}
		for z = -radius, radius do
			self.cells[x][z] = cell:new(self, x, -x-z, z)
		end
	end
end

function cell:init(map, x, y, z)
	self.x = x
	self.y = y
	self.z = z
end

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
