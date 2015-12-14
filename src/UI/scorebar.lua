scorebar = {
	virusCells = 0,
	immuneCells = 0,
	neutralCells = 0,
	totalCells = 0,
	virusPercent = 0,
	immunePercent = 0,
	neutralPercent = 0
}

function scorebar:load()
	for _, col in pairs(hexMap.cells) do
		for _, cell in pairs(col) do
			if cell.team == "immune" then
				scorebar.immuneCells = scorebar.immuneCells + 1
			elseif cell.team == "virus" then
				scorebar.virusCells = scorebar.virusCells + 1
			end
			scorebar.totalCells = scorebar.totalCells + 1
		end
	end
end

function scorebar:draw()
	scorebar:drawMainPoly()
	scorebar:drawTickBar()
	scorebar:drawStatistics()
end

function scorebar:drawMainPoly()
	local x = love.window.getWidth() / 2 - 400
	love.graphics.setColor(40, 40, 35)
	-- parralelogramm rechts
	love.graphics.polygon("fill",
		x, 0,
		x + 25, 25,
		x + 50 + 25, 25,
		x + 50, 0
	)
	--dreieck rechts
	love.graphics.polygon("fill",
		x + 50, 0,
		x + 50 + 50, 50,
		x + 50 + 50, 0
	)
	-- parralelogramm links
	love.graphics.polygon("fill",
		love.window.getWidth() - (x + 0), 0,
		love.window.getWidth() - (x + 25), 25,
		love.window.getWidth() - (x + 50 + 25), 25,
		love.window.getWidth() - (x + 50), 0
	)
	--dreieck links
	love.graphics.polygon("fill",
		love.window.getWidth() - (x + 50), 0,
		love.window.getWidth() - (x + 50 + 50), 50,
		love.window.getWidth() - (x + 50 + 50), 0
	)
	-- main rechteck
	love.graphics.polygon("fill",
		x + 50 + 50, 0,
		x + 50 + 50, 50,
		love.window.getWidth() - (x + 50 + 50), 50,
		love.window.getWidth() - (x + 50 + 50), 0
	)
end

function scorebar:drawTickBar(x)
	local x = love.window.getWidth() / 2 - 400
	local totalDistance = (love.window.getWidth() / 2 - (x + 50 + 45)) * 2
	local progress = totalDistance * (timeSinceLastTick / TICK_SPEED)
	if progress <= totalDistance then
		love.graphics.setColor(0, 255, 255)
		love.graphics.polygon("fill",
			x + 50 + 45, 45,
			x + 50 + 50, 50,
			x + 50 + 45 + progress, 50,
			x + 50 + 50 + progress, 45
		)

		love.graphics.setColor(255, 255, 255)
		love.graphics.polygon("fill",
			x + 50 + 50 + progress, 45,
			x + 50 + 45 + progress, 50,
			love.window.getWidth() - (x + 50 + 50), 50,
			love.window.getWidth() - (x + 50 + 45), 45
		)
	end
end

function scorebar:drawStatistics()
	local x = love.window.getWidth() / 2 - 400

	-- time
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(font.ethnocentric.regular[36])
	love.graphics.print(time:getTimeinString(), love.window.getWidth() / 2 - font.ethnocentric.regular[36]:getWidth(time:getTimeinString()) / 2)

	-- raw number
	love.graphics.setFont(font.prototype[32])
	love.graphics.setColor(200, 20, 20)
	love.graphics.print(scorebar.virusCells, x + 50 + 50, 5)
	love.graphics.setColor(50, 100, 200)
	love.graphics.print(scorebar.immuneCells, love.window.getWidth() - (x + 50 + 50) - font.prototype[32]:getWidth(scorebar.immuneCells), 5)

	love.graphics.setFont(font.prototype[20])
	love.graphics.setColor(200, 20, 20)
	love.graphics.print(scorebar.virusPercent.."%", x + 50 - font.prototype[20]:getWidth(scorebar.virusPercent) / 2, 0)
	love.graphics.setColor(50, 100, 200)
	love.graphics.print(scorebar.immunePercent.."%", love.window.getWidth() - (x + 50 + 25), 0)
end

function scorebar:updateStatistics()
	-- percentage
	scorebar.virusPercent = round((scorebar.virusCells / scorebar.totalCells) * 100)
	scorebar.immunePercent = round((scorebar.immuneCells / scorebar.totalCells) * 100)
	scorebar.neutralPercent = round((scorebar.neutralCells / scorebar.totalCells) * 100)
end