creditImg = love.graphics.newImage("gfx/creditImg.png")
cred = {}

function cred:draw()
	local polygon = rounded_rectangle(love.graphics.getWidth() / 2 - 400, love.window.getHeight() / 2 - 300, 800, 600, 10, 10, 10, 10, 10)
	love.graphics.setColor(40, 40, 35)
	love.graphics.polygon("fill", polygon)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(creditImg, love.graphics.getWidth() / 2 - 400, love.window.getHeight() / 2 - 300)
end