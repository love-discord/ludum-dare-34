local class = require 'lib.class'
local hex = require 'src.hex.hex'
--require 'interactives.camera'

function love.load()
	hexMap = hex:new(5, 32, 10)
end

--[[ functions ]]--
	immuneSystem:addUnit("Cell Healer", 3, 1)
	virus:addUnit("Cell Damager", 1, 3)

function love.update(dt)

end

function love.draw()
	--love.graphics.push()
	--love.graphics.translate(camera.x, camera.y)
	hexMap:draw()
	local x, y, z = hexMap:pixelToHex(love.mouse.getPosition())
	local cell = hexMap:getCell(x, y, z)
	if cell ~= {} then cell:draw("line") end
	--love.graphics.pop()
end