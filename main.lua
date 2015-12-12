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
	love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	love.graphics.scale(camera.scale)
	love.graphics.translate(-love.graphics.getWidth()/2, -love.graphics.getHeight()/2)

	love.graphics.translate(camera.x, camera.y)

	local HACK = hexMap:draw()
	local x = HACK.x
	local y = HACK.y
	local z = HACK.z
	local magicCell = cell:new(hexMap, x, y, z, 32, 10, "immune")
	magicCell:draw("line")

	immuneSystem:draw()
	
	love.graphics.pop()

	love.graphics.print(camera.scale, 100, 100)
end

function love.mousepressed(x, y, key)
	camera:mousepressed(key)
end
