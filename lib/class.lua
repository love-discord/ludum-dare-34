local class = {}
class.__index = class

function class:subclass()
	local sub = setmetatable({}, self)
	sub.__index = sub
	return sub
end

function class:new(...)
	--print("CLASS NEW")
	local obj = setmetatable({}, self)
	if obj.init then obj:init(...) end
	return obj
end

return class
