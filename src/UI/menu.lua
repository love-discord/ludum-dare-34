local cell = require("src.hex.cell")

menu = {
	cursorImg = love.graphics.newImage("gfx/menu/cursor.png"),
	choice = {}
}

function singleplayer()
	state.game = "singleplayer"
	hexMap = hex:new(12, 48, 100)

	TICK_SPEED = 3 / timeScale -- 1/number

	time:load()
	input:load()
	scorebar:load()

	immuneSystem:loadUnits()
	immuneSystem:loadTroops()

	virus:loadUnits()
	virus:loadTroops()

	shop:load()

	require("src.AI.virusSetup")

	lightWorld = lightWorld({
		ambient = {55,55,55},         --the general ambient light in the environment
		blur = 0,
		glowBlur = 0,
		refractionStrength = 0
	})
	lightWorld:setGlowStrength(0)
	lightWorld:setShadowBlur(0)
	cell:update()
	neutralLight = lightWorld:newLight(0, 0, 60, 60, 60, love.window.getWidth() / 2)
end

function options()
	state.game = "options"
end

function credits()
	state.game = "credits"
end

function exit()
	love.event.quit()
end

function menu:load()
	math.randomseed(os.time())
	menu.percentage = 90 + math.random(0, 9)

	menu:addChoice("Singleplayer", singleplayer)
	menu:addChoice("Options", options)
	menu:addChoice("Credits", credits)
	menu:addChoice("Exit", exit)
end

function menu:addChoice(name, code)
	menu.choice[#menu.choice + 1] = {name = name, code = code}
end

function menu:draw()
	menu:drawChoosables()
	menu:drawCursor()
end

function menu:update(dt)
	if love.keyboard.isDown("up") then
		menu.percentage = menu.percentage + 150 * dt
	elseif love.keyboard.isDown("down") then
		menu.percentage = menu.percentage - 150 * dt
	elseif love.keyboard.isDown("return") or love.keyboard.isDown(" ") then
		menu.choice[menu.current].code()
	end

	if menu.percentage > 100 then
		menu.percentage = 100
	end
	if menu.percentage < 0 then
		menu.percentage = 0
	end
end

function menu:drawChoosables()
	love.graphics.setColor(0, 150, 255)
	love.graphics.setLineWidth(5)
	love.graphics.line(150, love.window.getHeight(), 150, love.window.getHeight() - 220)

	for i = 1, #menu.choice do
		local prozent = menu.percentage / 10

		if prozent >= 10 - 2.5 * i and prozent <= 10 - math.abs((1 - i) * 2.5) then
			menu.current = i
			love.graphics.setFont(font.roboto.bold[28])
		else
			love.graphics.setFont(font.roboto.regular[28])
		end

		love.graphics.print(menu.choice[i].name, 190, love.window.getHeight() - (5 - i) * 50)
	end
end

function menu:drawCursor()
	love.graphics.setColor(0, 150, 255)
	love.graphics.draw(menu.cursorImg, 160, love.window.getHeight() - 150 * menu.percentage / 100 - 48)
end
