mewsic = {
	nowplaying = {
		x = 0,
		targetX = 150
	}
	title = {
		x = 0,
	}
}

function mewsic:load(newTrack)
	mewsic.title.targetX = 
end

function mewsic:update(dt)
	if mewsic.newSong ~= nil then
		mewsic.nowplaying.x = mewsic.nowplaying.x + ((self.nowplaying.targetX - self.nowplaying.x) * 12) * dt
		mewsic.title.x = mewsic.title.x + ((mewsic.title.targetX - mewsic.title.x) * 12) * dt
	end
end

function mewsic:draw()
	if mewsic.newSong ~= nil then
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font.roboto.regular[20])
		love.graphics.setFont(font.roboto.bold[28])

	end
end