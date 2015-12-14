tut = {
	img = {
		[1] = love.graphics.newImage("gfx/tut/tut1.png"),
		[2] = love.graphics.newImage("gfx/tut/tut2.png"),
		[3] = love.graphics.newImage("gfx/tut/tut3.png"),
		[4] = love.graphics.newImage("gfx/tut/tut4.1.png"),
		[5] = love.graphics.newImage("gfx/tut/tut4.png")
	},
	imgCount = 1
}

function tut:draw()
	local polygon = rounded_rectangle(love.graphics.getWidth() / 2 - 400, love.window.getHeight() / 2 - 300, 800, 600, 10, 10, 10, 10, 10)
	love.graphics.setColor(40, 40, 35)
	love.graphics.polygon("fill", polygon)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(tut.img[tut.imgCount], love.graphics.getWidth() / 2 - 400, love.window.getHeight() / 2 - 300)
end