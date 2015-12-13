time = {
	count = false,
	temp = 0,
	seconds = 0
}

function time:load()
	time.count = true
end

function time:update(dt)
	if time.count then
		time.temp = time.temp + dt * timeScale
		if time.temp > 1 then
			time.temp = time.temp - 1
			time.seconds = time.seconds + 1
		end
	end
end

function time:reset()
	time.count = false
	time.seconds = 0
end

-- returns the time in a string format
function time:getTimeinString()
	local seconds = tostring(time.seconds % 60)
	local minutes = tostring(math.floor(time.seconds / 60))

	if seconds:len() < 2 then
		seconds = "0"..seconds
	end
	if minutes:len() < 2 then
		minutes = "0"..minutes
	end
	return minutes..":"..seconds
end