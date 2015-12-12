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
	camera:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	love.graphics.scale(camera.scale)
	love.graphics.translate(-love.graphics.getWidth()/2, -love.graphics.getHeight()/2)

	love.graphics.translate(camera.x, camera.y)

	local viewportWidth = love.graphics.getWidth() * camera.scale
	local viewportHeight = love.graphics.getHeight() * camera.scale

	local viewportX = -camera.x - love.graphics.getWidth() / camera.scale
	local viewportY = -camera.y - love.graphics.getHeight() / camera.scale



	hexMap:draw()
	local mx, my = love.mouse.getPosition()
	local xx = math.floor((mx - (camera.x * camera.scale)) / camera.scale) + love.graphics.getWidth() * camera.scale
	local yy = math.floor((my - (camera.y * camera.scale)) / camera.scale) + love.graphics.getHeight() * camera.scale
	local x, y, z = hexMap:pixelToHex(xx, yy)
	local magicCell = cell:new(hexMap, x, y, z, 32, 10, "immune")
	magicCell:draw("line")

	love.graphics.pop()
end

function love.mousepressed(x, y, b) camera:mousepressed(b) end
