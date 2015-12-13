-- src/interactives/mouse.lua

local mouse = {}

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

function mouse:getHex()
	return hexMap:pixelToHex(self:scaledX(), self:scaledY())
end

return mouse
