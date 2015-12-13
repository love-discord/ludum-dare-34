--[[ requirements ]]--
love.graphics.setDefaultFilter("nearest", "nearest")

local class = require("lib.class")
local lovebird = require("lib.lovebird")

hex = require("src.hex.hex")
local cell = require("src.hex.cell")


stats = {unitsAlive = {}}
require("src.entities.immuneSystem")
require("src.entities.virus")

require("src.interactives.camera")
require("src.interactives.shop")
require("src.interactives.mouse")


--[[ functions ]]--
function love.load()
	hexMap = hex:new(12, 48, 100)

	immuneSystem:loadUnits()
	immuneSystem:loadTroops()
	immuneSystem:addUnit("Cell Damage Booster", 7, -9, 2)
	immuneSystem:addUnit("Cell Healer", 8, -10, 2)
	immuneSystem:addUnit("Bugfixer Spawn", 6, -8, 2)
	immuneSystem:addUnit("Cell Healer", 7, -9, 2)
	immuneSystem:addUnit("Cell Damage Booster", 7, -10, 3)
	immuneSystem:addUnit("Bugfixer Spawn", 8, -11, 3)
	immuneSystem:addUnit("Cell Damage Booster", 6, -9, 3)
	immuneSystem:addUnit("Bugfixer Spawn", 7, -10, 3)

	virus:loadUnits()
	virus:loadTroops()

	--virus:addUnit("Bug factory", -8, 10, -2)
	--virus:addUnit("Bug factory", -10, 2, -8)
	--virus:addUnit("Bug factory", -2, 8, 10)

	virus:addTroop("Fighter", 0, 0, 0)

	shop:load()
end

updating = true
local timeSinceLastTick = 0
function love.update(dt)
	local TICK_SPEED = 3 -- 1/number
	timeSinceLastTick = timeSinceLastTick + dt
	while timeSinceLastTick > TICK_SPEED do -- maybe it's multiple times a frame
		if updating then
			cell:update(dt)

			virus:update()
			immuneSystem:update()
		end
		timeSinceLastTick = timeSinceLastTick - TICK_SPEED
	end
 
	camera:update(dt)
	mouse:update()
	shop:update(dt)
	virus:fastUpdate(dt)
	immuneSystem:fastUpdate(dt)
	lovebird.update()
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)

	hexMap:draw()
	mouse:draw()
	immuneSystem:draw()
	virus:draw()
	love.graphics.pop()

	-- UI BEGGINS HERE
	shop:draw()
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end

function love.mousepressed(x, y, b)
	camera:mousepressed(x, y, b)
	shop:mousepressed(x, y, b)
end

function love.keypressed(key)
	if key == "q" then
		updating = not updating
	end
end

function love.resize(x, y)
	shop:resize(x, y)
end