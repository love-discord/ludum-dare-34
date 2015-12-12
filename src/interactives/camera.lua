camera = {
	x = 0,
	y = 0,
	scale = 1,
	speed = 400
}

function camera:update(dt)
	if love.keyboard.isDown("w") then
		camera.y = camera.y + camera.speed * dt
	end
	if love.keyboard.isDown("a") then
		camera.x = camera.x + camera.speed * dt
	end
	if love.keyboard.isDown("s") then
		camera.y = camera.y - camera.speed * dt
	end
	if love.keyboard.isDown("d") then
		camera.y = camera.y - camera.speed * dt
	end
end

function camera:mousepressed(key)
	if key == "wu" then
		camera.scale = camera.scale + 0.1
	elseif key == "wd" then
		camera.scale = camera.scale - 0.1
	end
end
