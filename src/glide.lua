local glide = {}

-- INFO: Local functions
local function IsHovering(x, y, w, h)
	local x1, y1 = x, y
	local x2, y2 = x + w, y + h
	local cx, cy = love.mouse.getPosition()
	return (cx > x1 and cx < x2 and cy > y1 and cy < y2)
end

local function IsPressing(x, y, w, h, bttn)
	return (IsHovering(x, y, w, h) and love.mouse.isDown(bttn))
end

local function Pressed(x, y, w, h, bttn, curr)
	return (IsHovering(x, y, w, h) and curr == bttn)
end

local function GetBorder(x, y, w, h, border_width)
	return {
		x = x - border_width,
		y = y - border_width,
		w = w + border_width * 2,
		h = h + border_width * 2,
	}
end

-- INFO: Global functions

---**IMPORTANT: Call at the start of `love.update`, before any GlideUI event**
function glide.Update()
	--avoid OnPress events activating even when not hovered
	love.mousepressed = function() end
end

---Create a new GlideUI element
---@param x number x-coordinate
---@param y number y-coordinate
---@param w number width
---@param h number height
---@param color table color
---@param fg_color? table text color
---@return table
function glide.New(x, y, w, h, color, fg_color)
	return {
		x = x,
		y = y,
		w = w,
		h = h,
		color = color,
		fg_color = fg_color or { 1, 1, 1 },
		border = nil,
		border_color = nil,
		text = "",
		SetBorder = function(self, border_width, border_color)
			self.border_color = border_color
			self.border = GetBorder(self.x, self.y, self.w, self.h, border_width)
		end,
		SetText = function(self, new_text)
			self.text = new_text
		end,
		OnPress = function(self, button, func)
			if self:Pressed(1 or 2 or 3) then
				func()
				return true
			end
			return false
		end,
		OnHold = function(self, button, func)
			if self:Holding(button) then
				func()
				return true
			end
			return false
		end,
		OnHover = function(self, func)
			if self:Hovering() then
				func()
			end
		end,
		Pressed = function(self, bttn)
			if self:Hovering(bttn) then
				function love.mousepressed(cx, cy, button)
					if bttn == button then
						self._pressed = true
					end
				end
			end
			if self._pressed then
				self._pressed = false
				return true
			end
			return false
		end,
		_pressed = false,
		Hovering = function(self)
			return IsHovering(self.x, self.y, self.w, self.h)
		end,
		Holding = function(self, bttn)
			return IsPressing(self.x, self.y, self.w, self.h, bttn)
		end,
		Draw = function(self)
			love.graphics.setColor(unpack(self.color))
			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

			love.graphics.setColor(unpack(self.fg_color))
			love.graphics.print(self.text, self.x + 2, self.y + 2)

			love.graphics.setColor(1, 1, 1, 1)
		end,
		_DrawDebug = function(self, opacity)
			if self:Hovering() then
				love.graphics.setColor(0, 1, 0, opacity)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
				love.graphics.setColor(1, 1, 1, opacity)
				love.graphics.print(
					("x: %i, cx: %i"):format(self.x, love.mouse.getX()),
					self.x + self.w + 2,
					self.y - 2
				)
				love.graphics.print(
					("y: %i, cy: %i"):format(self.y, love.mouse.getY()),
					self.x + self.w + 2,
					self.y + 12
				)
			end
			if self:Pressed(1 or 2 or 3) then
				love.graphics.setColor(1, 0, 0, opacity)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
			elseif self:Holding(1 or 2 or 3) then
				love.graphics.setColor(0, 0, 1, opacity)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
				love.graphics.setColor(1, 1, 1, opacity)
				love.graphics.print("Pressed", self.x, self.y - 15)
			end
			love.graphics.setColor(1, 1, 1, 1)
		end,
		Attach = function(self, targetx, targety, xoffset, yoffset)
			xoffset, yoffset = xoffset or 0, yoffset or 0
			self.x = targetx + xoffset
			self.y = targety + yoffset
		end,
		AttachToFrame = function(self, frame, element_x, element_y)
			self.x = frame.x + element_x
			self.y = frame.y + element_y
		end,
		AlignToFrameX = function(self, frame, align)
			if align == "center" then
				self.x = frame.x + ((frame.w / 2) - (self.w / 2))
				return true
			elseif align == "left" then
				self.x = frame.x + 2
				return true
			elseif align == "right" then
				local frame_x2 = frame.x + frame.w
				self.x = frame_x2 - self.w - 2
				return true
			else
				return false
			end
		end,
		AlignToFrameY = function(self, frame, align)
			if align == "center" then
				self.y = frame.y + ((frame.h / 2) - (self.h / 2))
				return true
			elseif align == "top" then
				self.y = frame.y + 2
				return true
			elseif align == "bottom" then
				local frame_y2 = frame.y + frame.h
				self.y = frame_y2 - self.h - 2
				return true
			else
				return false
			end
		end,
	}
end

function glide.NewFrame(x, y, w, h, color)
	return {
		x = x,
		y = y,
		w = w,
		h = h,
		color = color,
		Draw = function(self)
			love.graphics.setColor(unpack(self.color))
			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
			love.graphics.setColor(1, 1, 1, 1)
		end,
		_DrawDebug = function(self, opacity)
			if self:Hovering() then
				love.graphics.setColor(1, 0, 1, opacity)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
				love.graphics.setColor(1, 1, 1, opacity)
				local info_string = ([[
x: %i
y: %i
w: %i
h: %i
cx: %i
cy: %i
				]]):format(self.x, self.y, self.w, self.h, love.mouse.getPosition())
				love.graphics.print(info_string, self.x, self.y - 90)

				love.graphics.setColor(1, 0, 0, opacity)
				local cx, cy = love.mouse.getPosition()
				local distance_x, distance_y = cx - self.x, cy - self.y
				love.graphics.rectangle("line", self.x, self.y, distance_x, distance_y)
				love.graphics.line(self.x, self.y, self.x + distance_x, self.y + distance_y)
			end

			love.graphics.setColor(1, 1, 1, 1)
		end,
		Pressed = function(self, bttn)
			if self:Hovering(bttn) then
				function love.mousepressed(cx, cy, button)
					if bttn == button then
						self._pressed = true
					end
				end
			end
			if self._pressed then
				self._pressed = false
				return true
			end
			return false
		end,
		_pressed = false,
		Hovering = function(self)
			return IsHovering(self.x, self.y, self.w, self.h)
		end,
		Holding = function(self, bttn)
			return IsPressing(self.x, self.y, self.w, self.h, bttn)
		end,
		Drag = function(self)
			if IsPressing(self.x, self.y, self.w, self.h, 1) then
				local cx, cy = love.mouse.getPosition()
				self.x = cx - 10
				self.y = cy - 10
			end
		end,
		GrabMouse = function(self)
			local cx, cy = love.mouse.getPosition()
			local x1, y1 = self.x, self.y
			local x2, y2 = self.x + self.w, self.y + self.h
			if cx > (x2 - 4) then
				love.mouse.setPosition(x2 - 4, cy)
			elseif cx < (x1 + 4) then
				love.mouse.setPosition(x1 + 4, cy)
			end
			if cy > (y2 - 4) then
				love.mouse.setPosition(cx, y2 - 4)
			elseif cy < (y1 + 4) then
				love.mouse.setPosition(cx, y1 + 4)
			end
		end,
	}
end

return glide
