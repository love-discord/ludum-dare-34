mewsic = {}

music:trackChangeSubscribe("Playlist", function(nextTrack) mewsic.newSong = nextTrack.name end)

function mewsic:update(dt)

end

function mewsic:draw()

end