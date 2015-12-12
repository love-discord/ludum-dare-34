local class = require 'lib.class'
local cell = require 'src.hex.cell'

local hex = class:subclass()

local teams = {"neutral", "virus", "immune"}

function hex:init(radius, cell_size, default_hp)
	self.cells = {}
	self.radius = radius
	for x = -radius, radius do
		self.cells[x] = {}
		for z = -radius, radius do
			local team = teams[math.floor(math.random(3))]
			self.cells[x][z] = cell:new(self, x, -x-z, z, cell_size, default_hp, team)
		end
	end
end

function hex:draw()
	print("a")
	for x = -self.radius, self.radius do
		for z = -self.radius, self.radius do
			self.cells[x][z]:draw("fill")
		end
	end
end


return hex
