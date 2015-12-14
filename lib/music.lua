-- lib/music.lua

local music = {}
music.playlists = {}
music.tracks = {}
music.activePlaylist = ""

function music:loadTrack(playlist, path, name)
	name = name or path
	if not music.tracks[path] then
		music.tracks[path] = love.audio.newSource(path)
		music.tracks[path].duration = love.sound.newSoundData(path):getDuration()
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
	love.audio.play(p.tracks[p.currentTrack])
end

function music:pausePlaylist(playlist)
	local p = self.playlists[playlist]
	music.activePlaylist = ""
	love.audio.pause(p.tracks[p.currentTrack])
end

function music:trackChangeSubscribe(playlist, f)
	table.insert(music.playlists[playlist].subscribed, f)
end

function music:update()
	if self.activePlaylist then
		if self.playlists[self.activePlaylist] then
			local p = self.playlists[self.activePlaylist]
			local currentTrack = p.tracks[p.currentTrack]
			if currentTrack:tell() >= currentTrack.duration then
				if p.currentTrack == #p.tracks then p.currentTrack = 0 end
				p.currentTrack = p.currentTrack + 1
				currentTrack = p.tracks[p.currentTrack]
				for _, subscriber in ipairs(p.subscribed) do 
					subscribed(p.tracks[p.currentTrack])
				end
			end
		end
	end
end


return music