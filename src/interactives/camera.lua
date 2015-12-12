camera = {
	x = 650,
	y = 380,
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
		camera.x = camera.x - camera.speed * dt
	end
end

function camera:mousepressed(key)
	if key == "wu" then
		if camera.scale < 2 then
			camera.scale = camera.scale * 1.1
		end
	elseif key == "wd" then
		if camera.scale > 0.5 then
			camera.scale = camera.scale / 1.1
		end
	end
end

