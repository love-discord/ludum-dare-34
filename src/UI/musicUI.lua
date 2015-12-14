mewsic = {
	nowplaying = {
		x = 0,
		targetX = 150
	},
	title = {
		x = 0,
	},
	artist = {
		x = 0
	}
}

function mewsic.load(newTrack)
	local pos
	for i = 1, newTrack.name:len() do
		if newTrack.name:sub(i, i) == "-" then
			pos = i
			break
		end
	end

	local artist = newTrack.name:sub(1, pos - 1)
	local title = newTrack.name:sub(pos + 1, newTrack.name:len())

	print(artist, title)

	mewsic.title.targetX = font.roboto.bold[28]:getWidth(title) + 40
	mewsic.artist.targetX = font.roboto.italic[25]:getWidth(artist) + 40
end

function mewsic:update(dt)
	if mewsic.newSong ~= nil then
		mewsic.nowplaying.x = mewsic.nowplaying.x + ((self.nowplaying.targetX - self.nowplaying.x) * 12) * dt
		mewsic.title.x = mewsic.title.x + ((mewsic.title.targetX - mewsic.title.x) * 12) * dt
		mewsic.artist.x = mewsic.artist.x + ((mewsic.artist.targetX - mewsic.title.x) * 12) * dt
	end
end

function mewsic:draw()
	if mewsic.newSong ~= nil then
		love.graphics.setColor(200, 200, 200)
		love.graphics.polygon("fill",
			love.window.getWidth(), 150,
			love.window.getWidth() - mewsic.nowplaying.x, 150,
			love.window.getWidth() - mewsic.nowplaying.x + 25, 125,
			love.window.getWidth(), 125
		)


		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font.roboto.regular[20])
		love.graphics.setFont(font.roboto.bold[28])
		love.graphics.setFont(font.roboto.italic[25])
	end
end