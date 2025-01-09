function IsHovering(x, y, w, h)
	local x1, y1 = x, y
	local x2, y2 = x + w, y + h
	local cx, cy = love.mouse.getPosition()
	return (cx > x1 and cx < x2 and cy > y1 and cy < y2)
end

function IsPressing(x, y, w, h, bttn)
	return (IsHovering(x, y, w, h) and love.mouse.isDown(bttn))
end

function GetBorder(x, y, w, h, border_width)
	return {
		x = x - border_width,
		y = y - border_width,
		w = w + border_width * 2,
		h = h + border_width * 2,
	}
end
