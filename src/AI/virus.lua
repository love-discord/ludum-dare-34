-- src/AI/virus.lua
-- This is the virus controller AI
-- It basically tries to recreate the setup described by virusSetup.lua

return {
bits = 100,
step = 1,
r = 0,
target = require("src.AI.virusSetup"),
update = function(self)
	self.bits = self.bits + 5 + math.floor(time.seconds / 60) / 2
	self.r = hexMap.radius
	for _, t in ipairs(self.target) do
		if self.bits >= virus.unitList[t[1]].cost then
			if virus:addUnit(t[1], t[2], t[3], t[4]) then
				self.bits = self.bits - virus.unitList[t[1]].cost
			end
		end
	end
end
	--[[local stepFunc = self.steps[self.step]
	stepFunc(self)
end,
steps = {
	[1] = function(self)
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
			self.step = 40
		end
	end,
	[40] = function(self)
		local virusPercent = scorebar.virusPercent / 100 
		if math.random() < 1/10 and self.bits >= 25 then -- randomly place memory readers (1/10 chance)
			local battlefront = (virusPercent - 0.5) * self.r -- get the approximate battlefront zone
			local ox = math.floor(battlefront + math.random(self.r/4) - self.r/8)
			local oy = math.floor(math.random(self.r*2)) - self.r
			local x, z = ox - (oy + (oy % 2)) / 2, oy
			virus:addUnit("Memory Reader", x, -x-z, z)
			self.bits = self.bits - 25
		end

		for _, u in pairs(virus.unit) do
			if u.name == "Memory Reader" then -- loop through all memory readers
				local xPercent = u.x / (self.r*2) + 0.5
				if xPercent < virusPercent * virusPercent then
					virus:sell(u.x, u.y, u.z)
				end
			end
		end
	end
}
--]]
}