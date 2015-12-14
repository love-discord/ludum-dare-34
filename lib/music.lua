-- lib/music.lua

local music = {}
music.playlists = {}
music.tracks = {}
music.activePlaylist = ""

function music:loadTrack(playlist, path, name)
	name = name or path
	if not music.tracks[path] then
		local sounddata = love.sound.newSoundData(path)
		music.tracks[path] = {}
		music.tracks[path].sound = love.audio.newSource(sounddata)
		music.tracks[path].duration = sounddata:getDuration()
		music.tracks[path].path = path
		music.tracks[path].name = name
	end
	if music.playlists[playlist] == nil then
		music.playlists[playlist] = {subscribed = {}, tracks = {}}
	end
	table.insert(music.playlists[playlist].tracks, music.tracks[path])
end

function music:playPlaylist(playlist)
	local p = self.playlists[playlist]
	music.activePlaylist = playlist
	if p.currentTrack == nil then p.currentTrack = 1 end
	love.audio.play(p.tracks[p.currentTrack].sound)
end

function music:pausePlaylist(playlist)
	local p = self.playlists[playlist]
	music.activePlaylist = ""
	love.audio.pause(p.tracks[p.currentTrack].sound)
end

function music:stopPlaylist(playlist)
	local p = self.playlists[playlist]
	music.activePlaylist = ""
	love.audio.stop(p.tracks[p.currentTrack].sound)
	p.currentTrack = 1
end

function music:setVolume(vol)
	love.audio.setVolume(vol / 100)
end

function music:trackChangeSubscribe(playlist, f)
	table.insert(music.playlists[playlist].subscribed, f)
end

function music:update()
	if self.activePlaylist then
		if self.playlists[self.activePlaylist] then
			local p = self.playlists[self.activePlaylist]
			local currentTrack = p.tracks[p.currentTrack]
			if currentTrack.sound:tell() == 0 then -- next track
				if p.currentTrack == #p.tracks then p.currentTrack = 0 end
				p.currentTrack = p.currentTrack + 1
				currentTrack = p.tracks[p.currentTrack]
				for _, subscriber in ipairs(p.subscribed) do 
					subscriber(p.tracks[p.currentTrack])
				end
				love.audio.play(p.tracks[p.currentTrack].sound)
			end
		end
	end
end


return music