---@diagnostic disable: duplicate-set-field

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setVSync(0)

	WINDOW = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }

	--buttons
	--button 1
	BUTTONS = {}
	BUTTONS.BUTTON1 = require("src.glide").New(200, 300, 125, 30, { 0.25, 0.75, 0.25 })
	BUTTONS.BUTTON1:SetText("Toggle drag")

	--button 2
	BUTTONS.BUTTON2 = require("src.glide").New(0, 0, 125, 25, { 0.75, 0.25, 0.25 })
	BUTTONS.BUTTON2:SetText("Show debug")

	--button 3
	BUTTONS.BUTTON3 = require("src.glide").New(0, 0, 125, 25, { 0.25, 0.25, 0.75 })
	BUTTONS.BUTTON3:SetText("Grab mouse")

	--quit button
	BUTTONS.QUIT = require("src.glide").New(5, 5, 125, 25, { 0.75, 0.25, 0.25 })
	BUTTONS.QUIT:SetText("Quit")

	--frames
	FRAMES = {}
	FRAMES.FRAME1 = require("src.glide").NewFrame(200, 300, 200, 200, { 0.5, 0.5, 0.5 })
	FRAMES.FRAME2 = require("src.glide").NewFrame(450, 550, 200, 200, { 0.3, 0.3, 0.3 })

	--bars
	BARS = {}
	BARS.FRAME1 = require("src.glide").New(0, 0, FRAMES.FRAME1.w, 15, { 0.25, 0.25, 0.75 })
	BARS.FRAME1:SetText("Drag me!")
	BARS.FRAME2 = require("src.glide").New(0, 0, FRAMES.FRAME2.w, 15, { 0.25, 0.25, 0.75 })

	BARS.TOP = require("src.glide").New(0, 0, WINDOW.w, 35, { 0.2, 0.2, 0.2 })

	--variables
	SHOW_DEBUG = false
	DRAG_FRAME = false
	GRAB_MOUSE = false
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

	BUTTONS.BUTTON1:AlignToFrameX(FRAMES.FRAME1, "center")
	BUTTONS.BUTTON1:AlignToFrameY(FRAMES.FRAME1, "top", 20)

	BUTTONS.BUTTON2:AlignToFrameX(FRAMES.FRAME1, "center")
	BUTTONS.BUTTON2:AlignToFrameY(FRAMES.FRAME1, "bottom")

	BUTTONS.BUTTON3:AlignToFrameX(FRAMES.FRAME1, "center")
	BUTTONS.BUTTON3:AlignToFrameY(FRAMES.FRAME1, "center")

	BARS.FRAME1:AlignToFrameY(FRAMES.FRAME1, "top", -2)
	BARS.FRAME1:AlignToFrameX(FRAMES.FRAME1, "center")

	BARS.FRAME2:AlignToFrameY(FRAMES.FRAME2, "top", -2)
	BARS.FRAME2:AlignToFrameX(FRAMES.FRAME2, "center")

	FRAMES.FRAME2:Drag(nil, 15)
	if DRAG_FRAME then
		FRAMES.FRAME1:Drag(nil, 15)
	end
	FRAMES.FRAME1:GrabMouse(GRAB_MOUSE)

	FRAMES.FRAME1:LockToWindow(0, 0, 35, 0)
end

function love.draw()
	for _, frame in pairs(FRAMES) do
		frame:Draw()
		if SHOW_DEBUG then
			frame:_DrawDebug()
		end
	end
	for _, bar in pairs(BARS) do
		bar:Draw()
		if SHOW_DEBUG then
			bar:_DrawDebug()
		end
	end
	for _, button in pairs(BUTTONS) do
		button:Draw()
		if SHOW_DEBUG then
			button:_DrawDebug(0.75)
		end
	end
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()))
end
