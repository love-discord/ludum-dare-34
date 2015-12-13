return function(self) -- fighter behaviour
	self.target = nil
	local pt = {} -- potential targets

	for i, t in pairs(immuneSystem.troop) do -- for each enemy troop
		table.insert(pt, t) -- add it to the potential target table
		pt[#pt].radius = math.sqrt(t.w*t.w + t.h*t.h) / 2
		pt[#pt].distSq = distSq(t.x, t.y, self.x, self.y)
	end

	for i, b in pairs(immuneSystem.unit) do -- for each enemy building
		table.insert(pt, b)
		pt[#pt].X, pt[#pt].Y = hexMap:hexToPixel(b.x, b.y, b.z)
		pt[#pt].radius = hexMap.cell_size
		pt[#pt].distSq = distSq(pt[#pt].X, pt[#pt].Y, self.x, self.y)
	end

	if #pt == 0 then return end -- nothing left to attack

	table.sort(pt,
		function(a, b)
			return a.distSq < b.distSq -- sort the potential targets by their distance from the troop
		end)

	self.target = pt[1]
	if self.target.distSq <= self.target.radius then
		self.target.hp = self.target.hp - self.amount
	end
	if self.target.hp <= 0 then self.target = nil end
end
--]]