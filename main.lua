io.stdout:setvbuf("no")

local hex = require 'src.hex.hex'

function love.load()
	print("Hex")
	hexMap = hex:new(5, 32, 10)
end

function love.update(dt)

end

function love.draw()
	hexMap:draw()
end
