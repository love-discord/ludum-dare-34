--[[ requirements ]]--
love.graphics.setDefaultFilter("nearest", "nearest")

lightWorld = require("lib.lightWorld")

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
require("src.ui.menu")

timeScale = 1

--[[ variables ]]--
font = {
	prototype = {
		[15] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 15),
		[20] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 20),
		[28] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 26),
		[32] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 32),
		[36] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 36),
		[48] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", 48)
	},
	roboto = {
		italic = {
			[12] = love.graphics.newFont("gfx/fonts/roboto/roboto-italic.ttf", 12),
			[20] = love.graphics.newFont("gfx/fonts/roboto/roboto-italic.ttf", 20)
		},
		regular = {
			[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 13),
			[20] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 20),
			[28] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 28)
		},
		bold = {
			[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-bold.ttf", 13),
			[28] = love.graphics.newFont("gfx/fonts/roboto/roboto-bold.ttf", 28)
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
	updating = true,
	debug = false,
	game = "menu"
}

timeSinceLastTick = 0

--[[ functions ]]--
menu:load()
love.mouse.setVisible(false)

function love.update(dt)
	--[[ game ]]--
	if state.game == "singleplayer" then
		if state.updating then
			TICK_SPEED = 3 / timeScale -- 1/number
			timeSinceLastTick = timeSinceLastTick + dt * timeScale
			while timeSinceLastTick > TICK_SPEED do -- maybe it's multiple times a frame
				shop.bits = shop.bits + 5 + math.floor(time.seconds / 60) / 2 -- every minute this increases by 0.5
					cell:update(dt * timeScale)

					lightWorld:clearLights()
					lightWorld:clear()
					neutralLight = lightWorld:newLight(0, 0, 60, 60, 60, love.window.getWidth() / 2)

					virus:update()
					immuneSystem:update()
				timeSinceLastTick = timeSinceLastTick - TICK_SPEED
			end

			virus:fastUpdate(dt * timeScale)
			immuneSystem:fastUpdate(dt * timeScale)
			time:update(dt * timeScale)
		end
		camera:update(dt)
		immuneSystem:infoboxUpdate(dt)
		lightWorld:update(dt)
		lightWorld:setTranslation(camera.x, camera.y, scale)
		shop:update(dt)
	--[[ menu ]]--
	elseif state.game == "menu" then
		menu:update(dt)
	end

	mouse:update()
	lovebird.update()
end

function love.draw()
	if state.game == "singleplayer" then
		love.graphics.push()
		love.graphics.scale(scale)
		love.graphics.pop()
		love.graphics.push()
		love.graphics.translate(camera.x, camera.y)


		lightWorld:clear()
		lightWorld:draw(function()
			hexMap:draw()
			immuneSystem:draw()
			virus:draw()
			dyingTroop:draw()
		end)
		lightWorld.post_shader:addEffect("phosphor")
		-- lightWorld.post_shader:addEffect("tilt_shift")
		shop:drawSelected()

		mouse:drawHex()
		love.graphics.pop()

		-- UI BEGGINS HERE
		immuneSystem:drawSelectedUnitInfo()
		shop:draw()
		love.graphics.setFont(font.prototype[20])
		love.graphics.print("Virus bits: "..virus.ai.bits, 10, 30)
		scorebar:draw()
	elseif state.game == "menu" then
		menu:draw()
	end

	mouse:drawCircle()
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end

function love.mousepressed(x, y, b)
	if state.game == "singleplayer" then
		camera:mousepressed(x, y, b)
		immuneSystem:mousepressed(b)
		shop:mousepressed(x, y, b)
	elseif state.game == "menu" then

	end
end

function love.keypressed(key)
	if state.game == "singleplayer" then
		input:keypressed(key)
	elseif state.game == "menu" then

	end
end

function love.resize(x, y)
	if state.game == "singleplayer" then
		lightWorld:refreshScreenSize(x, y)
	end
end
