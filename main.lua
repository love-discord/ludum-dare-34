--[[ requirements ]]--
	require("src.interactions.camera")

	require("src.hex.hex")

function love.update(dt)
	camera:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)
	love.graphics.scale(camera.scale)
	love.graphics.pop()
end

function love.mousepressed(x, y, key)
	camera:mousepressed(key)
end