shop = {
	backgroundImg = love.graphics.newImage("gfx/shop/background.png"),
	active = false,
	y = 0,
	x = 0,

	flick = 0,
	flickRate = 15,
	flicked = 0,
	drawable = false
}

rads = math.rad(75)
distanceUntilMainQuad = 150 / math.tan(rads)
subDistance = 20

function shop:load()
	local i = 1
	for k, v in pairs(immuneSystem.unitList) do
		shop[i] = {name = v.name, hp = v.hp, range = v.range, movable = v.movable, effectText = v.effectText, cost = v.cost, img = v.img, requireText = v.requireText}
		print("Added "..shop[#shop].name)
		i = i + 1
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

	if shop.x >= shop.targetX - 1 then
		shop.ready = true
	else
		shop.ready = false
	end

	if shop.ready then
		shop.flick = shop.flick + dt
		if shop.flick > 1 / shop.flickRate then
			if shop.flicked <= 4 then
				shop.drawable = not shop.drawable
				shop.flicked = shop.flicked + 1
				shop.flick = shop.flick - 1 / shop.flickRate
			end
		end
	else
		shop.flick = 0
		shop.flicked = 0
		shop.drawable = false
	end
end

function shop:draw()
	local rads = math.rad(75)
	love.graphics.setLineWidth(4)
	local subDistance = subDistance + 10

	love.graphics.setColor(0, 0, 0, 150)
	love.graphics.polygon("fill", 
		love.window.getWidth() / 2 - shop.targetX, love.window.getHeight(),
		love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad), love.window.getHeight() - shop.y,
		love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad) + distanceUntilMainQuad * 3 - subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y,
		love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad) + distanceUntilMainQuad * 3 - subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4,
		love.window.getWidth() / 2 - shop.targetX + distanceUntilMainQuad * 3, love.window.getHeight()
	)
	love.graphics.polygon("fill",
		love.window.getWidth() / 2 + shop.targetX, love.window.getHeight(),
		love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad), love.window.getHeight() - shop.y,
		love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad) - distanceUntilMainQuad * 3 + subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y,
		love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad) - distanceUntilMainQuad * 3 + subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4,
		love.window.getWidth() / 2 + shop.targetX - distanceUntilMainQuad * 3, love.window.getHeight()
	)

	if shop.x > distanceUntilMainQuad + 88 then
	love.graphics.rectangle("fill", love.window.getWidth() / 2 - shop.targetX + math.min(shop.x, distanceUntilMainQuad) + distanceUntilMainQuad * 3 - subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y, shop.x - distanceUntilMainQuad - 88, subDistance * 4)
	love.graphics.polygon("fill", 
		love.window.getWidth() / 2 + shop.targetX - shop.x, love.window.getHeight() - shop.y + subDistance * 4,
		love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad) - distanceUntilMainQuad * 3 + subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y + subDistance * 4,
		love.window.getWidth() / 2 + shop.targetX - math.min(shop.x, distanceUntilMainQuad) - distanceUntilMainQuad * 3 + subDistance / math.tan(rads) * 4, love.window.getHeight() - shop.y,
		love.window.getWidth() / 2 + shop.targetX - shop.x, love.window.getHeight() - shop.y
	)
	end

	--[[ lines ]]--
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

	if shop.drawable then
		shop:drawProducts()
	end
end

function shop:drawProducts()
	for i = 1, #shop do
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0, 255, 255, 150)
		love.graphics.polygon("line",
			love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad - 80 - 33, love.window.getHeight() - shop.y + 40 - 1,
			love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad + 20 - 33, love.window.getHeight() - shop.y + 40 - 1,
			love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad - subDistance + 20 - 33, love.window.getHeight() - shop.y + 30 + 80 - 1,
			love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad - subDistance - 80 - 33, love.window.getHeight() - shop.y + 30 + 80 - 1
		)

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(shop[i].img, love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad - 80 - subDistance - 33, love.window.getHeight() - shop.y + 40 - 1)
	end
end

function shop:mousepressed()

end

function shop:resize(x, y)
	shop.targetX = x / 2 - 150
	shop.targetY = 150
end