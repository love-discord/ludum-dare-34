local class = require 'lib.class'
local hex = require 'src.hex.hex'
local cell = require 'src.hex.cell'
require 'src.interactives.camera'

function love.load()
	hexMap = hex:new(5, 32, 10)
end

function love.update(dt)
	camera:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)

	hexMap:draw()
	local mx, my = love.mouse.getPosition()
	mx = mx - camera.x
	my = my - camera.y
	local x, y, z = hexMap:pixelToHex(mx, my)
	local magicCell = cell:new(hexMap, x, y, z, 32, 10, "immune")
	magicCell:draw("line")

	love.graphics.pop()
end