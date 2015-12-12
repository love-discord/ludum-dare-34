--[[ requirements ]]--
	require("src.hex.hex")

	require("src.entities.immuneSystem")
	require("src.entities.virus")

	require("src.interactives.camera")

function love.update(dt)
	camera:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(camera.x, camera.y)
	love.graphics.scale(camera.scale)
	immuneSystem:draw()
	virus:draw()
	love.graphics.pop()
end

function love.mousepressed(x, y, key)
	camera:mousepressed(key)
end