local cls = TOOLS.class
local input = TOOLS.input

---@class GlideButton
---@field type string Is "button"
---@field x number x-coordinate
---@field y number y-coordinate
---@field w number Width
---@field h number Height
---@field color table Color
---@field border table Border
---@field _press function Press event
---@field _hover function Hover event
---@field methods table Global methods
return cls({
	type = "button",
	x = 0,
	y = 0,
	w = 125,
	h = 25,
	color = { 1, 1, 1 },
	border = {
		width = 1,
		color = { 1, 1, 1 },
	},
	_press = function(self)
		local holding, bttn = input.IsHoldingMouse()
		return (self._hover() and holding), bttn
	end,
	_hover = function(self)
		local x1, y1 = self.x, self.y
		local x2, y2 = self.x + self.w, self.y + self.h
		return input.IsHovering(x1, y1, x2, y2)
	end,
	---@class GlideButtonMethods
	methods = {
		---When the button is pressed, calls function
		---@param self GlideButton
		---@param func function
		---@return boolean Pressed Was pressed
		OnPress = function(self, func)
			if self._press() then
				func(self)
				return true
			else
				return false
			end
		end,
		---When the button is hovered, cals function.
		---@param self GlideButton
		---@param func function
		---@return boolean Pressed Was pressed
		OnHover = function(self, func)
			if self._hover() then
				func(self)
				return true
			else
				return false
			end
		end,
		---Draw
		---@param self GlideButton
		Draw = function(self)
			local function setColor(color)
				love.graphics.setColor(unpack(color))
			end
			setColor(self.border.color)
			local width = self.border.width
			local border = {
				x = self.x - width,
				y = self.y - width,
				w = self.w + width * 2,
				h = self.h + width * 2,
			}
			love.graphics.rectangle("fill", border.x, border.y, border.w, border.h)

			setColor(self.color)
			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		end,
	},
})
