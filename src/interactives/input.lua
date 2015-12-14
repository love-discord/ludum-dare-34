input = {
	list = {}
}

function input:load()
	input:add("state.updating = not state.updating", " ")
	input:add("state.drawHP = not state.drawHP", "z")
	input:add("timeScale = timeScale * 1.1", ".")
	input:add("timeScale = timeScale / 1.1", ",")
	input:add("state.game = 'menu'", "c")
end

function input:add(code, key, ctrl)
	input.list[#input.list + 1] = {key = key, ctrl = not not ctrl, code = code}
end

function input:ctrlIsDown()
	return love.keyboard.isDown("rctrl") or love.keyboard.isDown("rctrl")
end

function input:keypressed(key)
	for i = 1, #input.list do
		-- if user pressed the same key
		if input.list[i].key == key then
			-- if the task requires ctrl
			if input.list[i].ctrl then
				-- if ctrl is pressed
				if input:ctrlIsDown() then
					loadstring(input.list[i].code)()
				end
			else
				loadstring(input.list[i].code)()
			end
		end
	end
end