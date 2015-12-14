return function()
	----------------------------------- FONTS --------------------------
	font.prototype = {}
	for _, i in pairs({15, 20, 26, 32, 36, 48}) do 
		font.prototype[i] = love.graphics.newFont("gfx/fonts/prototype/prototype.ttf", i)
		coroutine.yield("prototype "..i)
	end

	font.roboto = {italic = {}, regular = {}, bold = {}}
	font.roboto.italic[12] = love.graphics.newFont("gfx/fonts/roboto/roboto-italic.ttf", 12)
	coroutine.yield("roboto italic 12")
	font.roboto.italic[20] = love.graphics.newFont("gfx/fonts/roboto/roboto-italic.ttf", 20)
	coroutine.yield("roboto italic 20")
	font.roboto.regular[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 13)
	coroutine.yield("roboto 13")
	font.roboto.regular[20] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 20)
	coroutine.yield("roboto 20")
	font.roboto.regular[28] = love.graphics.newFont("gfx/fonts/roboto/roboto-regular.ttf", 28)
	coroutine.yield("roboto 28")
	font.roboto.bold[13] = love.graphics.newFont("gfx/fonts/roboto/roboto-bold.ttf", 13)
	coroutine.yield("roboto bold 13")
	font.roboto.bold[28] = love.graphics.newFont("gfx/fonts/roboto/roboto-bold.ttf", 28)
	coroutine.yield("roboto bold 28")

    font.ethnocentric = {regular = {}}
	font.ethnocentric.regular[36] = love.graphics.newFont("gfx/fonts/ethnocentric/ethnocentric rg.ttf", 36)
	coroutine.yield("ethnocentric 36")
	font.ethnocentric.regular[80] = love.graphics.newFont("gfx/fonts/ethnocentric/ethnocentric rg.ttf", 80)
	coroutine.yield("ethnocentric 80")
    

	--------------------------------- MUSIC ---------------------------------------
	music:loadTrack("Playlist", "gfx/sound/bg/Alan Walker - Fade.mp3", "Alan Walker - Fade")
	coroutine.yield("Alan Walker - Fade")
	music:loadTrack("Playlist", "gfx/sound/bg/Distrion & Alex Skrindo - Entropy.mp3", "Distrion & Alex Skrindo - Entropy")
	coroutine.yield("Distrion & Alex Skrindo - Entropy")
	music:loadTrack("Playlist", "gfx/sound/bg/Jim Yosef - Arrow.mp3", "Jim Yosef - Arrow")
	coroutine.yield("Jim Yosef - Arrow")
	music:loadTrack("Playlist", "gfx/sound/bg/Unison-Aperture.mp3", "Unison - Aperture")
	coroutine.yield("Unison - Aperture")
	music:loadTrack("Playlist", "gfx/sound/bg/Lensko - Circles.mp3", "Lensko - Circles")
	coroutine.yield("Lensko - Circles")
	music:trackChangeSubscribe("Playlist", function(nextTrack) print("Now playing: "..nextTrack.name) end)
end