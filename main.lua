--[[ requirements ]]--
love.graphics.setDefaultFilter("nearest", "nearest")

local lightWorld = require("lib.lightWorld")

local class = require("lib.class")
local lovebird = require("lib.lovebird")
require("lib.time")

hex = require("src.hex.hex")
local cell = require("src.hex.cell")

require("src.entities.immuneSystem")
require("src.entities.virus")

dyingTroop = require("src.entities.dyingTroop")

require("src.interactives.camera")
require("src.interactives.mouse")
require("src.interactives.input")

require("src.UI.shop")
require("src.ui.scorebar")

timeScale = 1

--[[ variables ]]--
font = {
	prototype = {
		[15] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 15),
		[20] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 20),
		[32] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 32)
	},
	roboto = {
		italic = {
			[12] = love.graphics.newFont("gfx/fonts/roboto/roboto-italic.ttf", 12)
		},
		regular = {
			[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 13)
		},
		bold = {
			[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-bold.ttf", 13)
		}
	},
	ethnocentric = {
		regular = {
			[36] = love.graphics.newFont("gfx/fonts/ethnocentric/ethnocentric rg.ttf", 36)
		}
	}
}

state = {
	drawHP = false,
	updating = true
}

timeSinceLastTick = 0

--[[ functions ]]--
	hexMap = hex:new(12, 48, 100)

	time:load()
	input:load()
	scorebar:load()

	immuneSystem:loadUnits()
	immuneSystem:loadTroops()

	virus:loadUnits()
	virus:loadTroops()

	virus:addUnit("Bug Factory", -8, 10, -2)
	virus:addUnit("Bug Factory", -9, 11, -2)
	virus:addUnit("Bug Factory", -8, 11, -3)
	virus:addUnit("Bug Factory", -9, 12, -3)

	shop:load()

	love.mouse.setVisible(false)

function love.load()
  lightWorld = lightWorld({
    ambient = {55,55,55},         --the general ambient light in the environment
  })
  lightWorld:newLight(0, 0, 200, 200, 200, love.window.getWidth())
end

function love.update(dt)

  lightWorld:update(dt)
  lightWorld:setTranslation(camera.x, camera.y, scale)
  lightWorld:refreshScreenSize()
  
	if state.updating then
		TICK_SPEED = 3 / timeScale -- 1/number
		timeSinceLastTick = timeSinceLastTick + dt * timeScale
		while timeSinceLastTick > TICK_SPEED do -- maybe it's multiple times a frame
			shop.bits = shop.bits + 7 + math.floor(time.seconds / 60) / 2 -- every minute this increases by 0.5
				cell:update(dt * timeScale)
				virus:update()
				immuneSystem:update()
			timeSinceLastTick = timeSinceLastTick - TICK_SPEED
		end

		virus:fastUpdate(dt * timeScale)
		immuneSystem:fastUpdate(dt * timeScale)
		time:update(dt * timeScale)
	end
	camera:update(dt)
	mouse:update()
	shop:update(dt)
	lovebird.update()
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(scale)
  love.graphics.pop()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)

  lightWorld:draw(function()
	hexMap:draw()
  end)
  lightWorld.post_shader:addEffect("bloom")
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
	scorebar:draw()
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
