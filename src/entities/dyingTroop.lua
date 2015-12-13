-- src/entities/dyingTroop.lua

local dyingTroop = {
	dyingTroops = {},
	frames = {},
	timePerFrame = 0.1,
	frameSize = 32
}

function dyingTroop:load()
	for i = 1, 10 do
		self.frames[i] = love.graphics.newImage("res/dieAnim/"..i..".png")
	end
end

function dyingTroop:draw() 
	for i, t in pairs(self.dyingTroops) do
		local animationTime = love.timer.getTime() - t.deathTime
		local frame = math.floor(animationTime / self.timePerFrame) + 1
		if frame > 10 then
			self.dyingTroops[i] = nil
		else
			local sX, sY = t.w / self.frameSize, t.h / self.frameSize
			print(frame)
			love.graphics.draw(self.frames[frame], t.x - t.w/2, t.y - t.h/2, 0, sX, sY)
		end
	end
end

function dyingTroop:died(troop)
	table.insert(self.dyingTroops, {x = troop.x, y = troop.y, w = troop.w, h = troop.h,
									deathTime = love.timer.getTime()})
end

return dyingTroop