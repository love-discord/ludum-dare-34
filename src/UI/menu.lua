local cell = require("src.hex.cell")

menu = {
	cursorImg = love.graphics.newImage("gfx/menu/cursor.png"),
	title = love.graphics.newImage("gfx/menu/title.png"),
	choice = {}
}

function startGame()
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

	if lightWorld.blur == nil then
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
end

function singleplayer()
	state.game = "singleplayer"
	startGame()
end


function tutorial()
	state.game = "tutorial"
	state.updating = false
	startGame()
end

function optionsFunc()
	love.keyboard.setKeyRepeat(true)
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
	menu:addChoice("Options", optionsFunc)
	menu:addChoice("Tutorial", tutorial)
	menu:addChoice("Credits", credits)
	menu:addChoice("Exit", exit)
end

function menu:addChoice(name, code)
	menu.choice[#menu.choice + 1] = {name = name, code = code}
end

function menu:draw()
	menu:drawChoosables()
	menu:drawCursor()
	menu:drawUI()
end

function menu:update(dt)
	if love.keyboard.isDown("up") then
		menu.percentage = menu.percentage + 200 * dt
	elseif love.keyboard.isDown("down") then
		menu.percentage = menu.percentage - 200 * dt
	end

	if menu.percentage > 100 then
		menu.percentage = 100
	end
	if menu.percentage < 0 then
		menu.percentage = 0
	end
end

function menu:keypressed(key)
	if key == "return" or key == " " then
		menu.choice[menu.current].code()
	end
end

function menu:drawChoosables()
	love.graphics.setColor(0, 150, 255)
	love.graphics.setLineWidth(5)
	love.graphics.line(100, love.window.getHeight(), 100, love.window.getHeight() - 260)

	for i = 1, #menu.choice do
		local prozent = menu.percentage / 10

		if prozent >= 10 - 2 * i and prozent <= 10 - math.abs((1 - i) * 2) then
			menu.current = i
			love.graphics.setFont(font.roboto.bold[28])
		else
			love.graphics.setFont(font.roboto.regular[28])
		end

		love.graphics.print(menu.choice[i].name, 140, love.window.getHeight() - (6 - i) * 50)
	end
end

function menu:drawCursor()
	love.graphics.setColor(0, 150, 255)
	love.graphics.draw(menu.cursorImg, 110, love.window.getHeight() - 200 * menu.percentage / 100 - 48)
end


function menu:drawUI()
	love.graphics.setColor(0, 150, 255)
	local x = love.graphics.getWidth() - 200
	local y = love.graphics.getHeight() - 220
	love.graphics.setLineWidth(15)
	love.graphics.circle("line", x, y, 400, 100)
	love.graphics.setLineWidth(5)
	love.graphics.circle("line", x, y, 350, 100)
	love.graphics.circle("line", x, y, 310, 100)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(menu.title)
	love.graphics.setColor(0, 255, 255)
	love.graphics.setLineWidth(26)
	local totalLen = 315 - 130
	local radian1 = math.rad(130)
	local radian2 = math.rad(130 + totalLen * (menu.percentage / 100))
	love.graphics.arc("line", x, y, 330, radian1, radian2, 100)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", x, y, 307, 100)
	love.graphics.setColor(0, 255, 255)
	love.graphics.setFont(font.ethnocentric.regular[80])
	local text = tostring(round(menu.percentage)).."%"
	love.graphics.print(text, x - font.ethnocentric.regular[80]:getWidth(text) / 2, y - font.ethnocentric.regular[80]:getHeight(text) / 2 - 100)
	love.graphics.setFont(font.roboto.italic[20])
	love.graphics.setColor(200, 20, 20)
	love.graphics.print("Note: Navigate through the menu by pressing\nthe arrow keys. Then press enter or space.", x - 225, love.window.getHeight() - 125)
end