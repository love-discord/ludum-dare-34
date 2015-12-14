shop = {
	backgroundImg = love.graphics.newImage("gfx/shop/background.png"),
	active = false,
	bits = 100,
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
		shop.items[i] = {name = v.name, hp = v.hp, range = v.range, movable = v.movable, effectText = v.effectText, cost = v.cost, img = v.img, requireText = v.requireText, requireFunc = v.requireFunc, float = false, info = v.info}
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
			shop.x = shop.x + ((shop.targetX - shop.x) * 12) * dt
			shop.finised = false
		else
			shop.x = shop.targetX
			shop.finised = true
		end

		if shop.y <= shop.targetY - 1 then
			shop.y = shop.y + ((shop.targetY - shop.y) * 12) * dt
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

	shop:mousefloating(dt)
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
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font.prototype[20])
		love.graphics.print("Bits", love.window.getWidth() / 2 - shop.targetX + 18, love.window.getHeight() - font.prototype[20]:getHeight("Bits: ") - 5)
		love.graphics.print(shop.bits, love.window.getWidth() / 2 - shop.targetX + distanceUntilMainQuad * 3 - font.prototype[20]:getWidth(shop.bits) - 10, love.window.getHeight() - font.prototype[20]:getHeight(shop.bits) - 5)
	end

	shop:drawFloating()
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

function shop:mousefloating(dt)		-- checks whether the mouse is floating over a product or not
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
			shop.items[i].floatNum = shop.items[i].floatNum + dt
		else 
			shop.items[i].float = false
			shop.items[i].floatNum = 0
		end
	end
end

function shop:mousepressed(x, y, key)
	if shop.selected == nil then
		for i = 1, #shop.items do
			if shop.items[i].float and key == "l" then
				if shop.bits >= shop.items[i].cost and shop.items[i].requireFunc() then
					shop.selected = shop.items[i].name
					shop.bits = shop.bits - shop.items[i].cost
				end
			end
		end
	else
		local cell = hexMap:getCell(mouse:getHexCoords())
		if cell and cell.team == "immune" and not shop.active then
			immuneSystem:addUnit(shop.selected, mouse:getHexCoords())
		else
			shop.bits = shop.bits + immuneSystem.unitList[shop.selected].cost
		end
		shop.selected = nil
	end
end

local function rounded_rectangle(x, y, w, h, precision, tl, tr, br, bl)
	local corners = { tl, tr, br, bl }
	local polygon = {}

	-- true if on x/y, false if on w/h; TL, TR, BR, BL
	local xs = { true, false, false, true  }
	local ys = { true, true,  false, false }

	-- Loop through each corner and calculate points based on [r]adius!
	for i, r in ipairs(corners) do
		if r == 0 then
			table.insert(polygon, xs[i] and x or x+w)
			table.insert(polygon, ys[i] and y or y+h)
		else
			for j = 0, precision do
				local angle = (j / precision + (i - 3)) * math.pi / 2
				table.insert(polygon, (xs[i] and x+r or x+w-r) + r * math.cos(angle))
				table.insert(polygon, (ys[i] and y+r or y+h-r) + r * math.sin(angle))
			end
		end
	end

	return polygon
end

function shop:drawFloating()
	if shop.drawable then
		for i = 1, #shop.items do
			if shop.items[i].float and shop.items[i].floatNum > 0.5 then
				love.graphics.setColor(40, 40, 35)
				local w = math.max(150, font.prototype[15]:getWidth(shop.items[i].name) + 20)
				local h = 225
				local y = love.window.getHeight() - shop.y + 40 - 11 - h
				local x = love.mouse.getX()
				local polygon = rounded_rectangle(love.mouse.getX(), y, w, h, 8, 8, 8, 8, 8)

				-- main shape
				love.graphics.polygon("fill", polygon)
				love.graphics.setColor(0, 255, 255)
				love.graphics.setLineWidth(1)
				local polygon = rounded_rectangle(x + 5, y + 5, w - 10, h - 10, 8, 8, 8, 8, 8)
				love.graphics.polygon("line", polygon)

				-- text
				love.graphics.line(x + 5, y + 30, x + 5 + w - 10, y + 30)
				love.graphics.setColor(255, 255, 255)
				love.graphics.setFont(font.prototype[15])
				love.graphics.print(shop.items[i].name, x + 10, y + 30 - font.prototype[15]:getHeight(shop.items[i].name) - 3)
				love.graphics.setFont(font.roboto.bold[13])
				love.graphics.print("HP: "..shop.items[i].hp, x + 10, y + 35)
				love.graphics.print("Range: "..shop.items[i].range, x + w - 10 - font.roboto.bold[13]:getWidth(shop.items[i].range.." :Range"), y + 35)
				love.graphics.print("Cost: "..shop.items[i].cost, x + 10, y + 50)

				if shop.items[i].requireFunc() then
					love.graphics.setColor(0, 255, 0)
				else
					love.graphics.setColor(255, 0, 0)
				end
				love.graphics.print(shop.items[i].requireText, x + 10, y + 120)

				love.graphics.setColor(255, 255, 255)
				love.graphics.setFont(font.roboto.regular[13])
				love.graphics.print(shop.items[i].effectText, x + 10, y + 65)
				love.graphics.setFont(font.roboto.italic[12])

				-- gets how many lines the text has
				local lines = 1
				local text = shop.items[i].info

				for i = 1, text:len() do
					if text:sub(i, i) == "\n" then
						lines = lines + 1
					end
				end
				-- end
				love.graphics.print(shop.items[i].info, x + 10, y + h - lines * font.roboto.italic[12]:getHeight(shop.items[i].info) - 10)
			end
		end
	end
end

function shop:drawSelected()
	if shop.selected ~= nil then
		local img = immuneSystem.unitList[shop.selected].img
		local x, y = hexMap:hexToPixel(mouse:getHexCoords())
		local sX = hexMap.cell_size / immuneSystem.unitList[shop.selected].img:getWidth() 
		local sY = (hexMap.cell_size + hexMap.cell_size / 2) / immuneSystem.unitList[shop.selected].img:getHeight()

		local cell = hexMap:getCell(mouse:getHexCoords())

		if not cell or cell.team ~= "immune" or immuneSystem:find(mouse:getHexCoords()) then
			love.graphics.setColor(255, 0, 0, 150)
		else
			love.graphics.setColor(0, 255, 0, 150)
		end
		love.graphics.draw(img, x + camera.x - (img:getWidth() * sX) / 2, y + camera.y - (img:getHeight() * sY) / 2 - 10, 0, sX, sY)

		print(immuneSystem.unitList[shop.selected].range)
		local x, y, z = mouse:getHexCoords()
		local inRange = hex:inRange(x, y, z, immuneSystem.unitList[shop.selected].range)
		for i = 1, #inRange do
			local cell = hexMap:getCell(inRange[i].x, inRange[i].y, inRange[i].z)
			if cell then
				cell.color = {0, 255, 0}
			end
		end
	end
end

function shop:resize(x, y)
	shop.targetX = x / 2 - 150
	shop.targetY = 150
end