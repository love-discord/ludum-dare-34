--[[ requirements ]]--
local class = require("lib.class")

hex = require("src.hex.hex")
local cell = require("src.hex.cell")

require("src.entities.immuneSystem")
require("src.entities.virus")

require("src.interactives.camera")

--[[ functions ]]--
	hexMap = hex:new(10, 32, 10)

	immuneSystem:addUnit("Cell Healer", 1, 1, 1)

function love.update(dt)
	camera:update(dt)
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
	immuneSystem:draw()
	
	love.graphics.pop()
end

function love.mousepressed(x, y, key)
	camera:mousepressed(key)
end