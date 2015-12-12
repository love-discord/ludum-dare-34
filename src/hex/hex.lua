local class = require 'lib.class'
local cell = require 'src.hex.cell'

local hex = class:subclass()

function hex:init(radius, cell_size, default_hp)
	self.cells = {}
	self.radius = radius
	for x = -radius, radius do
		self.cells[x] = {}
		for z = -radius, radius do
			local color = {math.random(255), math.random(255), math.random(255)}
			self.cells[x][z] = cell:new(self, x, -x-z, z, cell_size, default_hp, color)
		end
	end
end

function hex:draw()
	print("a")
	for _, row in pairs(self.cells) do
		for _, cell in pairs(self.cells) do
			cell:draw("fill")
		end
	end
end

return hex
