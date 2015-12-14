-- src/AI/virus.lua
-- This si the virus controller AI

return {
lane = nil,
bits = 0,
step = 1,
update = function()
	bits = bits + 7 + math.floor(time.seconds / 60) / 2
	self:steps[step]()
end,
steps = {
	[1] = function()
		local lanes = {"mid", "bot", "top"}
		self.lane = lanes[math.floor(math.random(3))]
		step = 2
	end
	[2] = function()
	end
}

}