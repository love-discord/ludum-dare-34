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

function hex:round(h)
	local rx = math.round(h.x)
	local ry = math.round(h.y)
	local rz = math.round(h.z)

	local x_diff = math.abs(rx - h.x)
	local y_diff = math.abs(ry - h.y)
	local z_diff = math.abs(rz - h.z)

	if x_diff > y_diff and x_diff > z_diff then
		rx = -ry-rz
	elseif y_diff > z_diff then
		ry = -rx-rz
	else
		rz = -rx-ry
	end

	return {x = rx, y = ry, z = rz}
end

return hex
