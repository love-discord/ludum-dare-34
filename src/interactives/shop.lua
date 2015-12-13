shop = {
	backgroundImg = love.graphics.newImage("gfx/shop/background.png"),
	active = false,
	selected = nil,
	y = 0,
	x = 0,

	flick = 0,
	flickRate = 15,
	flicked = 0,
	drawable = false,

	items = {}
}

rads = math.rad(75)
distanceUntilMainQuad = 150 / math.tan(rads)
subDistance = 20

function shop:load()
	local i = 1
	for k, v in pairs(immuneSystem.unitList) do
		shop.items[i] = {name = v.name, hp = v.hp, range = v.range, movable = v.movable, effectText = v.effectText, cost = v.cost, img = v.img, requireText = v.requireText, float = false}
		print("Added "..shop.items[#shop.items].name)
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

	shop:mousefloating()
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

	shop:drawSelected()
end

function shop:drawProducts()
	for i = 1, #shop.items do

		-- saw this was repeated a lot: (DRY code FTW)
		local xCoord = love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad

		-- also, since both love.graphics.polygon-s use the same polygon, i'll store it in this table
		local frame = {
			xCoord - 80 - 33, love.window.getHeight() - shop.y + 40 - 1,
			xCoord + 20 - 33, love.window.getHeight() - shop.y + 40 - 1,
			xCoord - subDistance + 20 - 33, love.window.getHeight() - shop.y + 30 + 80 - 1,
			xCoord - subDistance - 80 - 33, love.window.getHeight() - shop.y + 30 + 80 - 1
		}

		local color = {0, 255, 255, 150}

		if shop.items[i].float then	-- if mouse is not over the product
			color[2] = 100
		end
		love.graphics.setLineWidth(3)
		love.graphics.setColor(unpack(color))
		love.graphics.polygon("fill", frame)	-- blue interior
		color[4] = nil
		love.graphics.setColor(unpack(color))
		love.graphics.polygon("line", frame)	-- blue line

		local img = shop.items[i].img -- the item image

		local sX = 40 / img:getWidth()
		local sY = 55 / img:getHeight()

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(shop.items[i].img,
							xCoord - 80 - subDistance - 33 + 100 / 2 - img:getWidth() * sX / 2 + subDistance / 2, love.window.getHeight() - shop.y + 40 - 1 + 70 / 2 - img:getHeight() * sY / 2,
							0, sX, sY)
	end
end

function shop:mousefloating()		-- checks whether the mouse is floating over a product or not
	local mouseX = love.mouse.getX()
	local mouseY = love.mouse.getY()

	for i = 1, #shop.items do
		local xCoord = love.window.getWidth() / 2 - shop.targetX + (120 * i) + distanceUntilMainQuad

		-- also, since both love.graphics.polygon-s use the same polygon, i'll store it in this table
		local frame = {
			xCoord - 80 - 33, love.window.getHeight() - shop.y + 40 - 1,
			xCoord + 20 - 33, love.window.getHeight() - shop.y + 40 - 1,
			xCoord - subDistance + 20 - 33, love.window.getHeight() - shop.y + 30 + 80 - 1,
			xCoord - subDistance - 80 - 33, love.window.getHeight() - shop.y + 30 + 80 - 1
		}

		-- if mouse is inside of bounding box
		if mouseX > frame[7] and mouseX < frame[3] and mouseY > frame[2] and mouseY < frame[6] then
			shop.items[i].float = true
		else 
			shop.items[i].float = false
		end
	end
end

function shop:mousepressed(key)
	for i = 1, #shop.items do
		if shop.items[i].float and key == "l" then
			shop.selected = shop.items[i].name
		end
	end
end

function shop:drawSelected()
	if shop.selected ~= nil then
		local img = immuneSystem.unitList[shop.selected].img
		local x, y = love.mouse.getX() - img:getWidth() / 2, love.mouse.getY() - img:getHeight() / 2
		local sX = hexMap.cell_size / immuneSystem.unitList[name].img:getWidth() 
		local sY = (hexMap.cell_size + hexMap.cell_size / 2) / immuneSystem.unitList[name].img:getHeight()
		
		hexMap:getCell()
		love.graphics.setColor(255, 255, 255, 150)
		love.graphics.draw(img, x, y, 0, sX, sY)
		shop.active = false
	end
end

function shop:resize(x, y)
	shop.targetX = x / 2 - 150
	shop.targetY = 150
end