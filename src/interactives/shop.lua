shop = {}

function shop:load(a)
	self.unitList = {}
	for _, u in pairs(a) do
		table.insert(self.unitList, u)
	end
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
		local unit = self.unitList[i]	-- the unit type
		local x = (20 + moneyTextWidth) + spacing * (i - 1) -- draw x coordinate
		local img = unit.img -- unit image
		local imgw = img:getWidth() -- unit image size (w=h because it's a square)
		local drawHeight = shopHeight - 40
		love.graphics.setColor(100, 100, 100) -- grey
		if unit.requireFunc() then love.graphics.setColor(200, 255, 200) end -- pale green if you can buy it
		love.graphics.draw(img, x + 10, 720 - shopHeight + 20, 0, drawHeight/imgw)

		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("line", x+10, 720-shopHeight+20, drawHeight, drawHeight)
		love.graphics.print(unit.name or 0, x + drawHeight + 20, 720 - shopHeight + 20)
		love.graphics.print("Cost: ".. unit.cost or 0, x + drawHeight + 20, 720 - shopHeight + 35)
		love.graphics.print("Alive: ".. stats.unitsAlive[unit.name] or 0, x + drawHeight + 20, 720 - shopHeight + 50)
		love.graphics.print("Requires: ".. unit.requireText or 0, x + drawHeight + 20, 720 - shopHeight + 65)
	end
end

function shop:mousepressed(x, y, b)

end