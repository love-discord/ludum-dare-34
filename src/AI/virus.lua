-- src/AI/virus.lua
-- This si the virus controller AI

return {
lane = nil,
bits = 100,
step = 1,
r = 0,
update = function(self)
	self.bits = self.bits + 7 + math.floor(time.seconds / 60) / 2
	self.r = hexMap.radius
	local stepFunc = self.steps[self.step]
	stepFunc(self)
end,
steps = {
	[1] = function(self)
		local lanes = {"mid", "bot", "top"}
		self.lane = lanes[math.floor(math.random(3))]
		print("Lane: "..self.lane)
		self.step = 21
		local stepFunc = self.steps[self.step]
		stepFunc(self)
	end,
	[21] = function(self)	-- place the healer
		if self.bits >= 50 then
			if virus:addUnit("Bug Obfuscator", -self.r, -self.r, 0) then
				self.step = 22
				self.bits = self.bits - 50
				local stepFunc = self.steps[self.step]
				stepFunc(self)
			end
		end
	end,
	[22] = function(self)
		if self.bits >= 75 then -- place the first spawner
			if virus:addUnit("Bug Factory", -self.r+1, -self.r, -1) then
				self.step = 23
				self.bits = self.bits - 75
				local stepFunc = self.steps[self.step]
				stepFunc(self)
			end
		end
	end,
	[23] = function(self)
		if self.bits >= 75 then -- place the second spawner
			if virus:addUnit("Bug Factory", -self.r, -self.r-1, 1) then
				self.step = 30
				self.bits = self.bits - 75
			end
		end
	end,
	[30] = function(self)
		-- wait for the chip count to get at least 150
		if scorebar.virusCells >= 150 then
			print("150 cells reached. Begginning outpost creation")
			self.step = 31
		end
	end,
	[31] = function(self)
	if math.random() < 1/1 and self.bits >= 25 then -- randomly place memory readers (1/10 chance)
		local battlefront = (scorebar.virusPercent / 100 - 0.5) * self.r -- get the approximate battlefront zone
		print("battlefront: ",battlefront)
		local x, z = 	math.floor(battlefront + math.random(self.r/2) - self.r/4),
						math.floor(math.random(self.r*2)) - self.r
		virus:addUnit("Memory Reader", x, -x-z, z)
		self.bits = self.bits - 25
	end
	end,
	[4] = function(self)
	end,
	[5] = function(self)
	end
}

}