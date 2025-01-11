---@diagnostic disable: duplicate-set-field

local frame = require("src.frame")
local element = require("src.element")

local glide = {}

-- INFO: Variables
local dragging_frame = false

-- INFO: Global functions

---**IMPORTANT: Call at the start of `love.update`, before any GlideUI event**
function glide.Update()
	--avoid OnPress events activating even when not hovered
	love.mousepressed = function() end
	love.mousereleased = function() end
	love.mousemoved = function() end
end

---Create a new GlideUI element
---@param x number x-coordinate
---@param y number y-coordinate
---@param w number width
---@param h number height
---@param color table color
---@param fg_color? table text color
---@return GlideElement
function glide.New(x, y, w, h, color, fg_color)
	--see "src/element.lua"
	return element(x, y, w, h, color, fg_color or nil)
end

---Create a new GlideUI frame
---@param x number x-coordinate
---@param y number y-coordinate
---@param w number width
---@param h number height
---@param color table color
---@return GlideFrame
function glide.NewFrame(x, y, w, h, color)
	--see "src/frame.lua"
	return frame(x, y, w, h, color)
end

return glide
