return function(self)	-- fighter behaviour
	self.target = nil
	local pT = {} -- possible targets

	for _, t in pairs(virus.troop) do	-- loop through enemy troops
		table.insert(pT, {x = t.x + t.xvel * t.speed, -- a little bit of prediction
					 		y = t.y + t.yvel * t.speed,
							o = virus.troop[_]}) --the actual object
	end

	for _, b in pairs(virus.unit) do	-- loop through enemy buildings
		pT[#pT + 1] = {}
		pT[#pT].x, pT[#pT].y = hexMap:hexToPixel(b.x, b.y, b.z)
		pT[#pT].o = virus.unit[_] --the actual object
	end

	local minDist = 4000000
	local idx
	for _, p in pairs(pT) do -- loop through all possible targets in order to decide on one
		local px, py, pz = hexMap:pixelToHex(p.x, p.y)
		if hexagonal(px, py, pz, 12) then
			local dx, dy = (self.x - p.x), (self.y - p.y)
			local distSq = dx*dx + dy*dy
			if distSq < minDist then -- if we have found a closer target
				minDist = distSq
				self.target = p
			end
		end
	end

	if minDist <= hexMap.cell_size*hexMap.cell_size then -- in range to attack
		self.target.o.hp = self.target.o.hp - self.amount
	end

	if self.target.o.hp <= 0 then self.target = nil end 

end