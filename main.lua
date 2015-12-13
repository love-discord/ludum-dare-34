--[[ requirements ]]--
love.graphics.setDefaultFilter("nearest", "nearest")

local class = require("lib.class")
local lovebird = require("lib.lovebird")

hex = require("src.hex.hex")
local cell = require("src.hex.cell")


stats = {unitsAlive = {}}
require("src.entities.immuneSystem")
require("src.entities.virus")

dyingTroop = require("src.entities.dyingTroop")

require("src.interactives.camera")
require("src.interactives.mouse")
require("src.interactives.input")

require("src.UI.shop")
require("src.ui.scorebar")

--[[ variables ]]--
font = {
	prototype = {
		[15] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 15),
		[20] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 20)
	},
	roboto = {
		italic = {
			[12] = love.graphics.newFont("gfx/fonts/roboto/roboto-italic.ttf", 14)
		},
		bold = {
			[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-bold.ttf", 13)
		}
	}
}

state = {
	drawHP = false,
	updating = true
}

local timeSinceLastTick = 0

--[[ functions ]]--
	hexMap = hex:new(12, 48, 100)

	input:load()

	immuneSystem:loadUnits()
	immuneSystem:loadTroops()
	immuneSystem:addUnit("Chip Damage Booster", 7, -9, 2)
	immuneSystem:addUnit("Chip Healer", 8, -10, 2)
	immuneSystem:addUnit("Debugger Spawn", 6, -8, 2)
	immuneSystem:addUnit("Chip Healer", 7, -9, 2)
	immuneSystem:addUnit("Chip Damage Booster", 7, -10, 3)
	immuneSystem:addUnit("Debugger Spawn", 8, -11, 3)
	immuneSystem:addUnit("Chip Damage Booster", 6, -9, 3)
	immuneSystem:addUnit("Debugger Spawn", 7, -10, 3)

	virus:loadUnits()
	virus:loadTroops()

	virus:addUnit("Bug factory", -8, 10, -2)
	virus:addUnit("Bug factory", -10, 2, -8)
	virus:addUnit("Bug factory", -2, 8, 10)

	shop:load()

	love.mouse.setVisible(false)

function love.update(dt)

	local TICK_SPEED = 0.5 -- 1/number
	timeSinceLastTick = timeSinceLastTick + dt
	while timeSinceLastTick > TICK_SPEED do -- maybe it's multiple times a frame
		if state.updating then
			cell:update(dt)
			virus:update()
			immuneSystem:update()
		end
		timeSinceLastTick = timeSinceLastTick - TICK_SPEED
	end
 
 	if state.updating then
		virus:fastUpdate(dt)
		immuneSystem:fastUpdate(dt)
	end
	camera:update(dt)
	mouse:update()
	shop:update(dt)
	lovebird.update()
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)

	hexMap:draw()
	mouse:drawHex()
	immuneSystem:draw()
	virus:draw()
	dyingTroop:draw()
	love.graphics.pop()

	-- UI BEGGINS HERE
	shop:draw()
	love.graphics.setFont(font.prototype[20])
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
	mouse:drawCircle()

end

function love.mousepressed(x, y, b)
	camera:mousepressed(x, y, b)
	shop:mousepressed(x, y, b)
end

function love.keypressed(key)
	input:keypressed(key)
end

function love.resize(x, y)
	shop:resize(x, y)
end
