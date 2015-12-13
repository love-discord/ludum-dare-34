-- src/interactives/mouse.lua

function mouse:update()
	self.screenX = love.mouse.getX()
	self.screenY = love.mouse.getY()
end

function mouse:getX()
	return self.screenX
end
function mouse:getY()
	return self.screenY
end

-- scaled functions are if we decide to add scaling again
function mouse:scaledX()
	local sx = self.screenX
	return sx
end

function mouse:scaledY()
	local sy = self.screenY
	return sy
end

function mouse:getHexCoords()
	return hexMap:pixelToHex(self:scaledX() - camera.x, self:scaledY() - camera.y)
end

function mouse:getHex()
	local x, y, z = self:getHexCoords()
	local SIZE = 100
	local tile = cell:new(hexMap, x, y, z, 20, SIZE, SIZE, SIZE, SIZE, SIZE, "other")
	return tile
end
-- colors the hexagon under the mouse
function mouse:draw()
	local x, y, z = hexMap:pixelToHex(mouse.screenX, mouse.screenY)

	local vertices = {}
	for i = 0, 5 do
		getCorner(i, x, y, z)
		vertices[#vertices + 1] = x
		vertices[#vertices + 1] = y
	end

	love.graphics.setColor(unpack(mouse.color))
	love.graphics.polygon("line", vertices)
end

return mouse
