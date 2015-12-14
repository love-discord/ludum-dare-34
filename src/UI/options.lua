-- options.lua
options = {cursorImg = love.graphics.newImage("gfx/menu/cursor.png"), choice = {}, percentage = 50}

function options:addChoice(name, codeRight, codeLeft, code) -- code (enter of " "); codeLeft left button; codeRight right button
	options.choice[#options.choice + 1] = {name = name, codeLeft = codeLeft, codeRight = codeRight, code = code}
end

options:addChoice("< Volume: 30 >", function(dt)
	state.options.volume = state.options.volume + 1000 * dt
	if state.options.volume > 100 then state.options.volume = 100 end
	options.choice[1].name = "< Volume: "..tostring(state.options.volume):sub(1,4).." >"
	music:setVolume(state.options.volume)
end, function(dt)
	state.options.volume = state.options.volume - 1000 * dt
	if state.options.volume < 0 then state.options.volume = 0 end
	options.choice[1].name = "< Volume: "..tostring(state.options.volume):sub(1,4).." >"
	music:setVolume(state.options.volume)
end)

local function changeSong()
	music:playPlaylist("Playlist")
end

options:addChoice("Switch song", changeSong, changeSong, changeSong)
options:addChoice("")

local function gotoMenu()
	state.game="menu"
	math.randomseed(os.time())
	menu.percentage = 90 + math.random(0, 9)
	love.keyboard.setKeyRepeat(false)
end
options:addChoice("Back", gotoMenu, gotoMenu, gotoMenu)

function options:keypressed(key)
	local dt = love.timer:getDelta()
	if key == "left" then
		pcall(self.choice[self.current].codeLeft, dt)
	elseif key == "right" then
		pcall(self.choice[self.current].codeRight, dt)
	elseif key == "enter" or key == " " then
		pcall(self.choice[self.current].code, dt)
	end
end

function options:update(dt)
	if love.keyboard.isDown("up") then
		self.percentage = self.percentage + 150 * dt
	elseif love.keyboard.isDown("down") then
		self.percentage = self.percentage - 150 * dt
	end

	if self.percentage > 100 then
		self.percentage = 100
	end
	if self.percentage < 0 then
		self.percentage = 0
	end
end

function options:drawChoosables()
	love.graphics.setColor(0, 150, 255)
	love.graphics.setLineWidth(5)
	love.graphics.line(150, love.window.getHeight(), 150, love.window.getHeight() - 220)

	for i = 1, #options.choice do
		local prozent = options.percentage / 10

		if prozent >= 10 - 2.5 * i and prozent <= 10 - math.abs((1 - i) * 2.5) then
			options.current = i
			love.graphics.setFont(font.roboto.bold[28])
		else
			love.graphics.setFont(font.roboto.regular[28])
		end

		love.graphics.print(options.choice[i].name, 190, love.window.getHeight() - (5 - i) * 50)
	end
end


function options:drawUI()
	love.graphics.setColor(0, 150, 255)
	local x = love.graphics.getWidth() - 200
	local y = love.graphics.getHeight() - 220
	love.graphics.setLineWidth(15)
	love.graphics.circle("line", x, y, 400, 100)
	love.graphics.setLineWidth(5)
	love.graphics.circle("line", x, y, 350, 100)
	love.graphics.circle("line", x, y, 310, 100)
	love.graphics.setColor(0, 255, 255)
	love.graphics.setLineWidth(26)
	local totalLen = 315 - 130
	local radian1 = math.rad(130)
	local radian2 = math.rad(130 + totalLen * (options.percentage / 100))
	love.graphics.arc("line", x, y, 330, radian1, radian2, 100)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", x, y, 307, 100)
	love.graphics.setColor(0, 255, 255)
	love.graphics.setFont(font.ethnocentric.regular[80])
	local text = tostring(round(options.percentage)).."%"
	love.graphics.print(text, x - font.ethnocentric.regular[80]:getWidth(text) / 2, y - font.ethnocentric.regular[80]:getHeight(text) / 2 - 100)
	love.graphics.setFont(font.roboto.italic[20])
	love.graphics.setColor(200, 20, 20)
	love.graphics.print("Note: Navigate through the options by pressing\nthe arrow keys. Then press enter, space\nor the arrow keys.", x - 225, love.window.getHeight() - 125)
end

function options:drawCursor()
	love.graphics.setColor(0, 150, 255)
	love.graphics.draw(options.cursorImg, 160, love.window.getHeight() - 150 * options.percentage / 100 - 48)
end

function options:draw()
	self:drawChoosables()
	self:drawCursor()
	self:drawUI()
end
