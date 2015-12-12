--[[ requirements ]]--
local class = require("lib.class")

local hex = require("src.hex.hex")
local cell = require("src.hex.cell")

require("src.entities.immuneSystem")
require("src.entities.virus")

require("src.interactives.camera")

--[[ functions ]]--
	hexMap = hex:new(5, 32, 10)

	immuneSystem:addUnit("Cell Healer", 3, 1)
	virus:addUnit("Cell Damager", 1, 3)

function love.update(dt)

end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)
	love.graphics.scale(camera.scale)

	hexMap:draw()
	local mx, my = love.mouse.getPosition()
	mx = mx - camera.x
	my = my - camera.y
	local x, y, z = hexMap:pixelToHex(mx, my)
	local magicCell = cell:new(hexMap, x, y, z, 32, 10, "immune")
	magicCell:draw("line")
	
	love.graphics.pop()
end