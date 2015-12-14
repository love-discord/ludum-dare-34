mewsic = {
	nowplaying = {
		x = 0,
		targetX = 150
	},
	title = {
		x = 0,
		targetX = 0
	},
	artist = {
		x = 0,
		targetX = 0
	},

	hasbeenout = 0
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

	mewsic.title.targetX = math.max(400, font.roboto.bold[28]:getWidth(title) + 40)
	mewsic.title.text = title
	mewsic.artist.targetX = math.max(300, font.roboto.italic[25]:getWidth(artist) + 40)
	mewsic.artist.text = artist
	mewsic.hasbeenout = 0
end

function mewsic:update(dt)
	mewsic.hasbeenout = mewsic.hasbeenout + dt

	if mewsic.hasbeenout < 3 then
		mewsic.nowplaying.x = mewsic.nowplaying.x + ((self.nowplaying.targetX - self.nowplaying.x) * 8) * dt
		mewsic.title.x = mewsic.title.x + ((mewsic.title.targetX - mewsic.title.x) * 8) * dt
		mewsic.artist.x = mewsic.artist.x + ((mewsic.artist.targetX - mewsic.artist.x) * 8) * dt
	else
		mewsic.nowplaying.x = mewsic.nowplaying.x + ((self.nowplaying.x - self.nowplaying.targetX) * 8) * dt
		mewsic.title.x = mewsic.title.x - (math.abs(mewsic.title.x - mewsic.title.targetX) * 8) * dt
		mewsic.artist.x = mewsic.artist.x - (math.abs(mewsic.artist.x - mewsic.artist.targetX) * 8) * dt
	end
end

function mewsic:draw()
	love.graphics.setColor(200, 200, 200)
	love.graphics.polygon("fill",
		love.window.getWidth(), 150,
		love.window.getWidth() - mewsic.nowplaying.x, 150,
		love.window.getWidth() - mewsic.nowplaying.x + 25, 125,
		love.window.getWidth(), 125
	)
	love.graphics.setColor(40, 40, 35)
	love.graphics.polygon("fill",
		love.window.getWidth(), 150,
		love.window.getWidth() - mewsic.title.x, 150,
		love.window.getWidth() - mewsic.title.x + 40, 190,
		love.window.getWidth(), 190
	)
	love.graphics.setColor(100, 100, 90)
	love.graphics.polygon("fill",
		love.window.getWidth(), 190,
		love.window.getWidth() - mewsic.artist.x, 190,
		love.window.getWidth() - mewsic.artist.x + 28, 218,
		love.window.getWidth(), 218
	)


	love.graphics.setColor(40, 40, 35)
	love.graphics.setFont(font.roboto.regular[18])
	love.graphics.print("Now Playing..", love.window.getWidth() - mewsic.nowplaying.x + 30, 126)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(font.roboto.bold[28])
	love.graphics.print(mewsic.title.text, love.window.getWidth() - mewsic.title.x + 40, 152)
	love.graphics.setFont(font.roboto.italic[25])
	love.graphics.print(mewsic.artist.text, love.window.getWidth() - mewsic.artist.x + 28, 190)
end