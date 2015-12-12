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
	hexMap = hex:new(12, 32, 10)
	shop:load(immuneSystem:loadUnits())
	virus:loadUnits()
	virus:loadTroops()
	immuneSystem:addUnit("Cell Damage Booster", 5, 0, 5)
	virus:addUnit("Protein factory", -5, 0, -5)
end

local timeSinceLastTick = 0
function love.update(dt)
	immuneSystem:update()
	camera:update(dt)

	local TICK_SPEED = 1 -- 1/number
	timeSinceLastTick = timeSinceLastTick + dt
	while timeSinceLastTick > TICK_SPEED do -- maybe it's multiple times a frame
		regulatedTick()
		timeSinceLastTick = timeSinceLastTick - TICK_SPEED
	end
end

function regulatedTick()
	virus:update()
	immuneSystem:update()
	cell:update()
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
	virus:draw()
	
	love.graphics.pop()

	-- UI BEGGINS HERE
	shop:draw()
end

function love.mousepressed(x, y, b)
	camera:mousepressed(x, y, b)
end
