require("src.utils")

return function(x, y, w, h, color)
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
			opacity = opacity or 1
			if self:Hovering() then
				love.graphics.setColor(1, 0, 1, opacity)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
				love.graphics.setColor(1, 1, 1, opacity)

				local cx, cy = love.mouse.getPosition()
				local distance_x, distance_y = cx - self.x, cy - self.y
				local info_string = ([[
x: %i
y: %i
w: %i
h: %i
cx: %i
cy: %i
				]]):format(self.x, self.y, self.w, self.h, distance_x, distance_y)
				love.graphics.print(info_string, self.x, self.y - 90)

				love.graphics.setColor(1, 0, 0, opacity)
				love.graphics.rectangle("line", self.x, self.y, distance_x, distance_y)
				love.graphics.line(self.x, self.y, self.x + distance_x, self.y + distance_y)
				love.graphics.circle("line", self.x + distance_x, self.y + distance_y, 10)
			end
			if self.grabbed then
				love.graphics.setColor(1, 1, 0)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
			end
			if dragging_frame then
				love.graphics.setColor(1, 0.5, 0)
				love.graphics.print("A frame is being dragged", self.x, self.y + self.h)
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
		dragging = false,
		Drag = function(self, limit_x, limit_y)
			if dragging_frame and not self.dragging then
				return
			end
			limit_x, limit_y = limit_x or self.w, limit_y or self.w
			if IsPressing(self.x, self.y, limit_x, limit_y, 1) then
				dragging_frame = true
				self.dragging = true
				love.mousemoved = function(_, _, dx, dy, _)
					self.x = self.x + dx
					self.y = self.y + dy
				end
			else
				self.dragging = false
				dragging_frame = false
			end
		end,
		grabbed = false,
		GrabMouse = function(self, active)
			if active then
				self.grabbed = true
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
			else
				self.grabbed = false
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
		LockToWindow = function(self, left, right, top, bottom)
			left, right = left or 0, right or 0
			top, bottom = top or 0, bottom or 0
			local window_w, window_h = love.window.getMode()
			self:LockX(0 + left, window_w - self.w - right)
			self:LockY(0 + top, window_h - self.h - bottom)
		end,
	}
end
