-- src/interactives/mouse.lua

local function getCorner(i, x, y, z)
	local angle_deg = 60 * i + 30
	local angle_rad = math.pi / 180 * angle_deg

	local cx, cy = hexMap:hexToPixel(x, y, z)

	return cx + math.cos(angle_rad) * hexMap.cell_size,
			cy + math.sin(angle_rad) * hexMap.cell_size
end

mouse = {
	color = {0, 255, 0}
}

function mouse:update()
	self.screenX = love.mouse.getX()
	self.screenY = love.mouse.getY()

	self.color = {0, 255, 0}
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

-- colors the hexagon under the mouse
function mouse:draw()
    local x, y, z = mouse:getHexCoords()

    if hexMap:getCell(x, y, z) == nil then return end

    local vertices = {}
    for i = 0, 5 do
        local xC, yC = getCorner(i, x, y, z)
        vertices[#vertices + 1] = xC
        vertices[#vertices + 1] = yC
    end

    love.graphics.setColor(mouse.color)
    love.graphics.polygon("line", vertices)
end

