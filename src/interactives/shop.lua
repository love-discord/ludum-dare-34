shop = {
	active = false,
	y = 0,
	x = 0,
}

function shop:load(unitList)
	for i = 1, #unitList do
		shop[#shop + 1] = {name = unitList[i].name, hp = unitList[i].hp, range = unitList[i].range, movable = unitList[i].movable, effectText = unitList[i].effectText, cost = unitList[i].cost, img = unitList[i].img, requireText = unitList.requireText}
	end

	shop:resize(love.window.getWidth(), love.window.getHeight())
end

function shop:update(dt)
	if love.mouse.getX() > 150 and love.mouse.getX() < love.window.getWidth() - 150 and love.mouse.getY() > love.window.getHeight() - 150 then
		shop.active = true
	else
		shop.active = false
	end

	if shop.active then
		if shop.x <= shop.targetX - 1 then
			shop.x = shop.x + ((shop.targetX - shop.x) * 8) * dt
			shop.finised = false
		else
			shop.x = shop.targetX
			shop.finised = true
		end

		if shop.y <= shop.targetY - 1 then
			shop.y = shop.y + ((shop.targetY - shop.y) * 8) * dt
		else
			shop.y = shop.targetY
		end
	else
		if shop.x > 3 then
			shop.x = shop.x - shop.x  * 6 * dt
		else
			shop.x = 0
		end

		if shop.y > 3 then
			shop.y = shop.y - shop.y * 5 * dt
		else
			shop.y = 0
		end
	end
end

function shop:draw()
	local rads = math.rad(75)
	local distanceUntilMainQuad = 150 / math.tan(rads)
	local subDistance = 30

	-- the polygons
	local tri = love.math.triangulate(
		love.window.getWidth() / 2 - shop.targetX, love.window.getHeight(),
		love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad),
		love.window.getHeight() - shop.y, love.window.getWidth() / 2 - shop.targetX + shop.x, love.window.getHeight() - shop.y
	)

	for i = 1, #tri do
		love.graphics.setColor(0, 0, 0, 150)
		love.graphics.polygon("fill", tri[i].x1, tri[i].y1, tri[i].x2, tri[i].y2, tri[i].x3, tri[i].y3)
		print("hi")
	end

	love.graphics.setColor(0, 255, 255, 150)
	-- left side
	-- tilted line1
	love.graphics.line(love.window.getWidth() / 2 - shop.targetX, love.window.getHeight(), love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad), love.window.getHeight() - shop.y)
	-- tilted line2
	love.graphics.line(love.window.getWidth() / 2 - shop.targetX + distanceUntilMainQuad * 3, love.window.getHeight(), love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad) + distanceUntilMainQuad * 3 - subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4)
	if shop.x > distanceUntilMainQuad then
		-- bottom
		love.graphics.line(love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad) + distanceUntilMainQuad * 3 - subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4, love.window.getWidth() / 2 - shop.targetX + shop.x, love.window.getHeight() - shop.y + subDistance * 4)
		--top
		love.graphics.line(love.window.getWidth() / 2 - shop.targetX + distanceUntilMainQuad, love.window.getHeight() - shop.y, love.window.getWidth() / 2 - shop.targetX + shop.x, love.window.getHeight() - shop.y)
	end

	-- right side
	love.graphics.line(love.window.getWidth() / 2 + shop.targetX, love.window.getHeight(), love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad), love.window.getHeight() - shop.y)
	love.graphics.line(love.window.getWidth() / 2 + shop.targetX - distanceUntilMainQuad * 3, love.window.getHeight(), love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad) - distanceUntilMainQuad * 3 + subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4)
	if shop.x > distanceUntilMainQuad then
		love.graphics.line(love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad) - distanceUntilMainQuad * 3 + subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4, love.window.getWidth() /2 + shop.targetX - shop.x, love.window.getHeight() - shop.y + subDistance * 4)
		love.graphics.line(love.window.getWidth() / 2 + shop.targetX - distanceUntilMainQuad, love.window.getHeight() - shop.y, love.window.getWidth() /2 + shop.targetX - shop.x, love.window.getHeight() - shop.y)
	end
end

function shop:mousepressed()

end

function shop:resize(x, y)
	shop.targetX = x / 2 - 150
	shop.targetY = 150
end