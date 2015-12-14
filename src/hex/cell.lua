local class = require 'lib.class'
local cell = class:subclass()


function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local colors = {
	neutral = {200, 200, 200},
	immune = {50, 100, 200},
	virus = {200, 20, 20},
	other = {255, 0, 255}
}

function cell:init(map, x, y, z, size, hp, maxHP, damage, regen, defense, team)

	self.map = map

	self.x = x
	self.y = y
	self.z = z
	self.size = 0
	self.tSize = size

	self.team = team
	self.color = colors[team] or {0, 0, 0}

	self.hp = hp
	self.maxHP = maxHP
	self.dmg = damage
	self.regen = regen
	self.def = defense
end

--[[
Use example:
	for neighbor in cell:neighbors() do
		--blah
	end
--]]
function cell:neighbors()
	return coroutine.wrap(function()
		if self.x < self.map.radius then
			coroutine.yield(self.map.cells[self.x + 1][self.z])
		end
		if self.x > -self.map.radius then
			coroutine.yield(self.map.cells[self.x - 1][self.z])
		end
		if self.z < self.map.radius then
			coroutine.yield(self.map.cells[self.x][self.z + 1])
		end
		if self.z > -self.map.radius then
			coroutine.yield(self.map.cells[self.x][self.z - 1])
		end
		if self.x < self.map.radius and self.z > -self.map.radius then
			coroutine.yield(self.map.cells[self.x + 1][self.z - 1])
		end
		if self.x > -self.map.radius and self.z < self.map.radius then
			coroutine.yield(self.map.cells[self.x - 1][self.z + 1])
		end
	end)
end

-- Draws the cell on the screen
function cell:draw(mode)

  self.size = self.size + 1
  if self.size > self.tSize - 3 then self.size = self.size - 1 end
  
	self.color[4] = nil
	love.graphics.setColor(self.color)

	local vertices = {}
	for i = 0, 5 do
		local x, y = self:getCorner(i)
		vertices[#vertices + 1] = x
		vertices[#vertices + 1] = y
	end

	love.graphics.setLineWidth(2)
	love.graphics.polygon("line", vertices)

	self.color[4] = self.hp * 2
	love.graphics.setColor(self.color)

	local vertices = {}
	for i = 0, 5 do
		local x, y = self:getCorner(i)
		vertices[#vertices + 1] = x
		vertices[#vertices + 1] = y
	end
  
      
	love.graphics.polygon("fill", vertices)
  
	love.graphics.setColor(255, 255, 255)
  
	if state.drawHP then
		love.graphics.setFont(font.prototype[20])
		local x, y = hexMap:hexToPixel(self.x, self.y, self.z)
		self.hp = round(self.hp)
		love.graphics.print(self.hp, x, y)
	end

end

function cell:getCorner(i)
	local angle_deg = 60 * i + 30
	local angle_rad = math.pi / 180 * angle_deg

	local cx, cy = self.map:hexToPixel(self.x, self.y, self.z)

	return cx + math.cos(angle_rad) * self.size,
			cy + math.sin(angle_rad) * self.size
end

function cell:update(dt)
	scorebar.virusCells = 0
	scorebar.immuneCells = 0
	scorebar.totalCells = 0
	local actions = {}
	
	for _, col in pairs(hexMap.cells) do
		for _, cell in pairs(col) do
			cell.hp = cell.hp + cell.regen
			if cell.hp > cell.maxHP then
				cell.hp = cell.maxHP
			end

			for neighbor in cell:neighbors() do
				if neighbor.team ~= cell.team then
					actions[#actions + 1] = {{x = cell.x, y = cell.y, z = cell.z}, {x = neighbor.x, y =  neighbor.y, z = neighbor.z}}
				end
			end

			if cell.team == "immune" then
				scorebar.immuneCells = scorebar.immuneCells + 1
			elseif cell.team == "virus" then
				scorebar.virusCells = scorebar.virusCells + 1
			end
			scorebar.totalCells = scorebar.totalCells + 1

			cell.color = {colors[cell.team]}
		end
	end

	for i = 1, #actions do
		local mainCell = hexMap:getCell(actions[i][1].x, actions[i][1].y, actions[i][1].z)
		local otherCell = hexMap:getCell(actions[i][2].x, actions[i][2].y, actions[i][2].z)
		if mainCell.team ~= otherCell.team then
			otherCell.hp = otherCell.hp - mainCell.dmg + otherCell.def
		end

		if otherCell.hp < otherCell.maxHP then
			otherCell.hp = math.round(otherCell.hp)
		end
		-- dying
		if otherCell.hp <= 0 then
			local x = otherCell.x
			local z = otherCell.z
			
			immuneSystem:remove(x, -x-z, z) -- i do both virus and immuneSystem because only one
			virus:remove(x, -x-z, z)		-- would actually do something

			hexMap.cells[x][z] = cell:new(hexMap, x, -x-z, z, hexMap.cell_size, math.max(mainCell.hp / 2, default_hp / 2), default_hp, default_dmg, default_regen, default_def, mainCell.team)
		end
	end
end

return cell
