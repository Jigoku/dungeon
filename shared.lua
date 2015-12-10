function math.round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local _newImage = love.graphics.newImage
function love.graphics.newImage(...)
	local img = _newImage(...)
	img:setFilter('nearest', 'nearest')
	return img
end


function drawbounds(entity)
	love.graphics.setColor(0,100,0,55)
	love.graphics.rectangle("fill", entity.x,entity.y,entity.w,entity.h)
	love.graphics.setColor(0,255,0,55)
	love.graphics.rectangle("line", entity.x,entity.y,entity.w,entity.h)
end
