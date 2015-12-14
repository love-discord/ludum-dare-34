cred = {
	img = {
		[1] = love.graphics.newImage("gfx/cred/cred1.png"),
		[2] = love.graphics.newImage("gfx/cred/cred2.png"),
		[3] = love.graphics.newImage("gfx/cred/cred3.png"),
		[4] = love.graphics.newImage("gfx/cred/cred4.png"),
		[5] = love.graphics.newImage("gfx/cred/cred5.png")
	},
	imgCount = 1
}

function cred:draw()
	local polygon = rounded_rectangle(love.graphics.getWidth() / 2 - 400, love.window.getHeight() / 2 - 300, 800, 600, 10, 10, 10, 10, 10)
	love.graphics.setColor(40, 40, 35)
	love.graphics.polygon("fill", polygon)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(cred.img[cred.imgCount], love.graphics.getWidth() / 2 - 400, love.window.getHeight() / 2 - 300)
end