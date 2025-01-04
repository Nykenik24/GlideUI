---@diagnostic disable: duplicate-set-field

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setVSync(0)

	BUTTONS = {}
	BUTTONS.BUTTON1 = require("src.glide").New(200, 300, 125, 30, { 0.25, 0.75, 0.25 })
	BUTTONS.BUTTON1:SetText("Toggle drag")
	BUTTONS.BUTTON2 = require("src.glide").New(0, 0, 125, 25, { 0.75, 0.25, 0.25 })
	BUTTONS.BUTTON2:SetText("Show debug")

	BUTTONS.BUTTON3 = require("src.glide").New(0, 0, 125, 25, { 0.25, 0.25, 0.75 })
	BUTTONS.BUTTON3:SetText("Grab mouse")

	BUTTONS.QUIT = require("src.glide").New(5, 5, 125, 25, { 0.75, 0.25, 0.25 })
	BUTTONS.QUIT:SetText("Quit")

	TEST_FRAME = require("src.glide").NewFrame(200, 300, 200, 200, { 0.5, 0.5, 0.5 })
	FRAME_BAR = require("src.glide").New(0, 0, TEST_FRAME.w, 15, { 0.25, 0.25, 0.75 })
	FRAME_BAR:SetText("Drag me!")

	SHOW_DEBUG = false
	DRAG_FRAME = false
	GRAB_MOUSE = false

	WINDOW = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }
	TOP_BAR = require("src.glide").New(0, 0, WINDOW.w, 35, { 0.2, 0.2, 0.2 })
end

function love.update(dt)
	require("src.glide").Update()

	BUTTONS.BUTTON1:OnRelease(1, function()
		DRAG_FRAME = not DRAG_FRAME
		print("Pressed button 1")
	end)
	BUTTONS.BUTTON2:OnRelease(1, function()
		SHOW_DEBUG = not SHOW_DEBUG
		print("Pressed button 2")
	end)
	BUTTONS.BUTTON3:OnRelease(1, function()
		GRAB_MOUSE = not GRAB_MOUSE
		print("Pressed button 3")
	end)
	BUTTONS.QUIT:OnRelease(1, love.event.quit)

	for _, button in pairs(BUTTONS) do
		button:OnHover(function()
			button:Darken(0.25)
		end)
		button:OnUnhover(function()
			button:RestoreColor()
		end)
		button:AlignText("center")
	end

	BUTTONS.BUTTON1:AlignToFrameX(TEST_FRAME, "center")
	BUTTONS.BUTTON1:AlignToFrameY(TEST_FRAME, "top", 20)

	BUTTONS.BUTTON2:AlignToFrameX(TEST_FRAME, "center")
	BUTTONS.BUTTON2:AlignToFrameY(TEST_FRAME, "bottom")

	BUTTONS.BUTTON3:AlignToFrameX(TEST_FRAME, "center")
	BUTTONS.BUTTON3:AlignToFrameY(TEST_FRAME, "center")

	FRAME_BAR:AlignToFrameY(TEST_FRAME, "top", -2)
	FRAME_BAR:AlignToFrameX(TEST_FRAME, "center")

	if DRAG_FRAME then
		TEST_FRAME:Drag(nil, 15)
	end
	TEST_FRAME:GrabMouse(GRAB_MOUSE)

	TEST_FRAME:LockToWindow(0, 0, 35, 0)
end

function love.draw()
	TEST_FRAME:Draw()
	FRAME_BAR:Draw()
	TOP_BAR:Draw()

	for _, button in pairs(BUTTONS) do
		if SHOW_DEBUG then
			button:_DrawDebug(0.75)
			TEST_FRAME:_DrawDebug(0.75)
		end
		button:Draw()
	end
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()))
end
