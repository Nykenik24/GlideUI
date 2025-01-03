---@diagnostic disable: duplicate-set-field

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.mouse.setGrabbed(true)
	love.window.setVSync(0)

	TEST_BUTTON = require("src.glide").New(200, 300, 125, 30, { 0.25, 0.25, 0.75 })
	TEST_BUTTON:SetText([[
Make frame
draggable
	]])
	TEST_BUTTON_2 = require("src.glide").New(200, 400, 125, 25, { 0.75, 0.25, 0.25 })
	TEST_BUTTON_2:SetText("Show debug")

	TEST_FRAME = require("src.glide").NewFrame(200, 300, 200, 200, { 0.5, 0.5, 0.5 })

	SHOW_DEBUG = false
	DRAG_FRAME = false
end

function love.update(dt)
	require("src.glide").Update()

	TEST_BUTTON:OnPress(1, function()
		DRAG_FRAME = not DRAG_FRAME
	end)
	TEST_BUTTON_2:OnPress(1, function()
		SHOW_DEBUG = not SHOW_DEBUG
	end)

	TEST_BUTTON:AlignToFrameX(TEST_FRAME, "center")
	TEST_BUTTON:AlignToFrameY(TEST_FRAME, "top")

	TEST_BUTTON_2:AlignToFrameX(TEST_FRAME, "right")
	TEST_BUTTON_2:AlignToFrameY(TEST_FRAME, "bottom")

	if DRAG_FRAME then
		TEST_FRAME:Drag()
	end
	TEST_FRAME:GrabMouse()
end

function love.draw()
	TEST_FRAME:Draw()

	TEST_BUTTON:Draw()
	TEST_BUTTON_2:Draw()

	if SHOW_DEBUG then
		TEST_BUTTON_2:_DrawDebug(0.75)
		TEST_BUTTON:_DrawDebug(0.75)
		TEST_FRAME:_DrawDebug(0.75)
	end
	love.graphics.print(tostring(love.timer.getFPS()))
end
