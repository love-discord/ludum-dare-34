-- src/interactives/mouse.lua

mouse = {}

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
