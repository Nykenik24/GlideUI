require("src.utils")

return function(x, y, w, h, color, fg_color)
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
		text_x = nil,
		text_y = nil,
		SetBorder = function(self, border_width, border_color)
			self.border_color = border_color
			self.border = GetBorder(self.x, self.y, self.w, self.h, border_width)
		end,
		SetText = function(self, new_text)
			self.text = new_text
		end,
		AlignText = function(self, align)
			if align == "center" then
				local text_w = #self.text * 3.5
				self.text_x = self.x + ((self.w / 2) - text_w)
			elseif align == "left" then
				self.text_x = self.x + 2
			elseif align == "right" then
				local text_w = #self.text * 3.5 * 2.25
				self.text_x = self.x + self.w - text_w - 2
			else
				self.text_x = self.x + 2
			end
		end,
		AttachText = function(self, offsetx, offsety)
			self.text_x = self.x + 2 + offsetx
			self.text_y = self.y + 2 + offsety
		end,
		Darken = function(self, level)
			local c1, c2, c3 = color[1], color[2], color[3]
			self.color = { c1 - level, c2 - level, c3 - level }
		end,
		Lighten = function(self, level)
			local c1, c2, c3 = color[1], color[2], color[3]
			self.color = { c1 + level, c2 + level, c3 + level }
		end,
		RestoreColor = function(self)
			self.color = color
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
		OnUnhover = function(self, func)
			if not self:Hovering() then
				func()
			end
		end,
		OnRelease = function(self, bttn, func)
			if self:Released(bttn) then
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
		Released = function(self, bttn)
			if self:Hovering(bttn) then
				function love.mousereleased(cx, cy, button)
					if bttn == button then
						self._released = true
					end
				end
			end
			if self._released then
				self._released = false
				return true
			end
			return false
		end,
		_pressed = false,
		_released = false,
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
			love.graphics.print(self.text, self.text_x or self.x + 2, self.text_y or self.y + 2)

			love.graphics.setColor(1, 1, 1, 1)
		end,
		_DrawDebug = function(self, opacity)
			opacity = opacity or 1
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
				if self.attached.state then
					love.graphics.setColor(1, 0, 1)
					love.graphics.print(
						("attached x, y: %i, %i\nframe x, y: %i, %i"):format(
							self.attached.x,
							self.attached.y,
							self.attached.frame_x,
							self.attached.frame_y
						),
						self.x,
						self.y + self.h + 5
					)
					love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
				end
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
			if self:Released(1 or 2 or 3) then
				love.graphics.setColor(1, 1, 1, opacity)
				love.graphics.print("Released", self.x, self.y - 15)
			end
			love.graphics.setColor(1, 1, 1, 1)
		end,
		Attach = function(self, targetx, targety, xoffset, yoffset)
			xoffset, yoffset = xoffset or 0, yoffset or 0
			self.x = targetx + xoffset
			self.y = targety + yoffset
		end,
		attached = { x = nil, y = nil, frame_x = nil, frame_y = nil, state = false },
		AttachToFrame = function(self, frame, element_x, element_y)
			self.attached.state = true
			self.x = frame.x + element_x
			self.attached.x = self.x - frame.x
			self.attached.frame_x = frame.x
			self.y = frame.y + element_y
			self.attached.y = self.y - frame.y
			self.attached.frame_y = frame.y
		end,
		AlignToFrameX = function(self, frame, align, offset)
			self.attached.state = true
			offset = offset or 0
			if align == "center" then
				self.x = frame.x + ((frame.w / 2) - (self.w / 2)) + offset
				self.attached.x = self.x - frame.x
				self.attached.frame_x = frame.x
				return true
			elseif align == "left" then
				self.x = frame.x + 2 + offset
				self.attached.x = self.x - frame.x
				self.attached.frame_x = frame.x
				return true
			elseif align == "right" then
				local frame_x2 = frame.x + frame.w
				self.x = frame_x2 - self.w - 2 + offset
				self.attached.x = self.x - frame.x
				self.attached.frame_x = frame.x
				return true
			else
				return false
			end
		end,
		AlignToFrameY = function(self, frame, align, offset)
			self.attached.state = true
			offset = offset or 0
			if align == "center" then
				self.y = frame.y + ((frame.h / 2) - (self.h / 2)) + offset
				self.attached.y = self.y - frame.y
				self.attached.frame_y = frame.y
				return true
			elseif align == "top" then
				self.y = frame.y + 2 + offset
				self.attached.y = self.y - frame.y
				self.attached.frame_y = frame.y
				return true
			elseif align == "bottom" then
				local frame_y2 = frame.y + frame.h + offset
				self.y = frame_y2 - self.h - 2
				self.attached.y = self.y - frame.y
				self.attached.frame_y = frame.y
				return true
			else
				return false
			end
		end,
		LockX = function(self, min, max)
			if self.x < min then
				self.x = min
			elseif self.x > max then
				self.x = max
			end
		end,
		LockY = function(self, min, max)
			if self.y < min then
				self.y = min
			elseif self.y > max then
				self.y = max
			end
		end,
		LockAxisX = function(self)
			self:LockX(self.x - 1, self.x + 1)
		end,
		LockAxisY = function(self)
			self:LockY(self.y - 1, self.y + 1)
		end,
	}
end
