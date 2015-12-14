--[[ requirements ]]--
love.graphics.setDefaultFilter("nearest", "nearest")

lightWorld = require("lib.lightWorld")

local class = require("lib.class")
local lovebird = require("lib.lovebird")
require("lib.time")
music = require("lib.music")

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
require("src.ui.options")
require("src.ui.tutorial")

timeScale = 1

--[[ variables ]]--
font = {} -- moved this to loading.lua

state = {
	drawHP = false,
	updating = true,
	debug = false,
	game = "loading",
	options = {volume = 100},
	assetsLoaded = 0, currentAsset = "?"
}

timeSinceLastTick = 0

--[[ functions ]]--
local load = coroutine.create(require("loading"))

menu:load()
love.mouse.setVisible(false)

function love.update(dt)
	if coroutine.status(load) == "dead" then state.game = "menu" end
	if state.game == "loading" then
		local a, b = coroutine.resume(load)
		if a then state.currentAsset = b end
		state.assetsLoaded = state.assetsLoaded + 1
		return
	end
	music:update()
	--[[ game ]]--
	if state.game == "singleplayer" or state.game == "tutorial" then
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
	elseif state.game == "options" then
		options:update(dt)
	end

	mouse:update()
	lovebird.update()
	music:update()
end

function love.draw()
	if state.game == "loading" then
		local faces = {"._.", ":/", ":|", ":\\", ".-.", "/:", "|:", "\\:"}
		local face = state.assetsLoaded % #faces + 1
		love.graphics.print(faces[face].."\n"..(state.currentAsset or ""), 100, 100)
		return
	end
	if state.game == "singleplayer" or state.game == "tutorial" then
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
		if state.game == "tutorial" then
			tut:draw()
		end
	elseif state.game == "menu" then
		menu:draw()
	elseif state.game == "options" then
		options:draw()
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
	elseif state.game == "tutorial" then
		if key == " " then
			if tut.imgCount < 4 then
				tut.imgCount = tut.imgCount + 1
			else
				state.game = "menu"
			end
		end
	elseif state.game == "menu" then
		menu:keypressed(key)
	elseif state.game == "options" then
		options:keypressed(key)
	end
end

function love.resize(x, y)
	if state.game == "singleplayer" or state.game == "tutorial" then
		lightWorld:refreshScreenSize(x, y)
	end
end
