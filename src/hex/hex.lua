local class = require 'lib.class'
local cell = require 'src.hex.cell'

function math.round(x) return
	math.floor(x + 0.5)
end

local hex = class:subclass()

local teams = {"neutral", "virus", "immune"}

function hex:init(radius, cell_size, default_hp)
	self.cells = {}
	self.radius = radius
	CELL_SIZE = cell_size
	for x = -radius, radius do
		self.cells[x] = {}
		for z = -radius, radius do
			local team = teams[math.floor(math.random(3))]
			self.cells[x][z] = cell:new(self, x, -x-z, z, cell_size, default_hp, team)
		end
	end
end

function hex:draw()
	for x = -self.radius, self.radius do
		for z = -self.radius, self.radius do
			self.cells[x][z]:draw("fill")
		end
	end
end

function hex:getCell(x, y, z)
	if self.cells[x] then
		return self.cells[x][z] or {}
	else return {} end
end

function hex:hexToPixel(x, y, z)
	local xP = CELL_SIZE * math.sqrt(3) * (x + z/2)
	local yP = CELL_SIZE * 3/2 * z
	return xP, yP
end

function hex:pixelToHex(x, y)
	local q = (x * math.sqrt(3)/3 - y / 3) / CELL_SIZE
	local r = y * 2/3 / CELL_SIZE
	print(CELL_SIZE)
	return self:round(q, -q-r, r)
end

function hex:round(x, y, z)
	local rx = math.round(x)
	local ry = math.round(y)
	local rz = math.round(z)

	local x_diff = math.abs(rx - x)
	local y_diff = math.abs(ry - y)
	local z_diff = math.abs(rz - z)

	if x_diff > y_diff and x_diff > z_diff then
		rx = -ry-rz
	elseif y_diff > z_diff then
		ry = -rx-rz
	else
		rz = -rx-ry
	end

	return rx, ry, rz
end

return hex