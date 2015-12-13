return function(self)	-- fighter behaviour
	self.target = nil
	local pT = {} -- possible targets

	for _, t in pairs(immuneSystem.troop) do	-- loop through enemy troops
		pT[#pT+1] = {x = t.x + t.xvel * t.speed, -- a little bit of prediction
					 y = t.y + t.yvel * t.speed}
		pT[#pT].o = t --the actual object
	end

	for _, b in pairs(immuneSystem.unit) do	-- loop through enemy buildings
		pT[#pT + 1] = {}
		pT[#pT].x, pT[#pT].y = hexMap:hexToPixel(b.x, b.y, b.z)
		pT[#pT].o = b --the actual object
	end

	local minDist = 100000000
	local idx
	for _, p in pairs(pT) do -- loop through all possible targets in order to decide on one
		local dx, dy = (self.x - p.x), (self.y - p.y)
		local distSq = dx*dx + dy*dy
		if distSq < minDist then -- if we have found a closer target
			print("Found target")
			minDist = distSq
			self.target = p
			print(self.target)
		end
	end

	if minDist <= hexMap.cell_size*hexMap.cell_size then -- in range to attack
		self.target.o.hp = self.target.o.hp - self.amount
	end
end