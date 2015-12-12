shop = {}

function shop:load(unitList)
	self.unitList = unitList
end

function shop:update()

end

function shop:draw()
	local shopHeight = 150
	-- RECTANGLE
	love.graphics.setColor(100, 100, 100)
	love.graphics.rectangle("fill", 0, 720-shopHeight, 1280, shopHeight)
	love.graphics.setColor(50, 50, 50)
	love.graphics.setLineWidth(5)
	love.graphics.rectangle("line", 0, 720-shopHeight, 1280, shopHeight)

	-- MONEY TEXT
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(self.money or "0" .. " <<CURRENCY>>", 10, 720-shopHeight + 10)

	-- UNITS
	local unitTypeCount = #self.unitList
	local moneyTextWidth = love.graphics:getFont():getWidth(self.money or "0" .. " <<CURRENCY>>")
	local spacing = (1280 - moneyTextWidth - 20) / unitTypeCount
	for i = 1, unitTypeCount do
		local x = (20 + moneyTextWidth) + spacing * (i - 1)
		local centerX = x + spacing / 2
		local img = self.unitList[i].img
		love.graphics.draw(img, centerX - shopHeight - 40, 720 - shopHeight + 20, 0, img:getHeight()/(shopHeight-20))
	end
end

function shop:mousepressed(x, y, b)

end