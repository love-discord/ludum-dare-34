--[[ requirements ]]--
local class = require("lib.class")

hex = require("src.hex.hex")
local cell = require("src.hex.cell")

stats = {unitsAlive = {}}
require("src.entities.immuneSystem")
require("src.entities.virus")

require("src.interactives.camera")
require("src.interactives.shop")


--[[ functions ]]--
function love.load()
	hexMap = hex:new(12, 32, 100)
	shop:load(immuneSystem:loadUnits())
end

updating = true
local timeSinceLastTick = 0
function love.update(dt)
	immuneSystem:update()
	camera:update(dt)

	local TICK_SPEED = 0.5 -- 1/number
	timeSinceLastTick = timeSinceLastTick + dt
	while timeSinceLastTick > TICK_SPEED do -- maybe it's multiple times a frame
		if updating then
			hexMap:update(dt)
		end
		timeSinceLastTick = timeSinceLastTick - TICK_SPEED
	end
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)

	hexMap:draw()

	local mx, my = love.mouse.getPosition()
	mx = mx - camera.x
	my = my - camera.y
	local x, y, z = hexMap:pixelToHex(mx, my)
	if hexMap:getCell(x, y, z) ~= {} then
		local magicCell = cell:new(hexMap, x, y, z, 32, 10, 1, 1, 1, "immune")
		magicCell:draw("line")
	end

	immuneSystem:draw()

	love.graphics.pop()

	-- UI BEGGINS HERE
	shop:draw()
	love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.mousepressed(x, y, b)
	camera:mousepressed(x, y, b)
end

function love.keypressed(key)
	if key == "q" then
		updating = not updating
	end
end
