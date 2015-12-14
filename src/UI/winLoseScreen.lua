wlScreen = {
	type = nil
}

function wlScreen:draw()
	if self.type ~= nil then
		local polygon = rounded_rectangle(love.window.getWidth() / 2 - 300, love.window.getHeight() / 2 - 200, 600, 400, 10, 10, 10, 10, 10)
		love.graphics.setColor(40, 40, 35)
		love.graphics.polygon("fill", polygon)
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font.prototype[48])
		love.graphics.print("You've "..wlScreen.type, love.window.getWidth() / 2 - font.prototype[48]:getWidth("You've "..wlScreen.type) / 2, love.window.getHeight() / 2 - 190)
		love.graphics.setFont(font.roboto.italic[13])
		love.graphics.print("Press \"space\" to return to the main menu.", love.window.getWidth() / 2 - font.roboto.italic[13]:getWidth("Press \"space\" to return to the main menu.") / 2, love.window.getHeight() / 2 - 180)
	end
end