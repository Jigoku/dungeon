--[[
 * Copyright (C) 2015 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 
 pickups = {}
 
 pickups.coin_sound = love.audio.newSource("data/sounds/coin.wav", "static")
 
 function pickups:draw(table)
 	--pickups
	for _, p in pairs(table) do
		local x = p.x+p.w/2
		local y = p.y+p.h/2
		--shadow
		love.graphics.push()
		love.graphics.translate(x,y+p.h)
		love.graphics.rotate(p.angle)
		love.graphics.translate(-x,-(y+p.h))
	
		love.graphics.setColor(0,0,0,155)
		love.graphics.circle("fill", x,y+p.h,p.w,p.segments)
		love.graphics.pop()
	
		--graphic
		love.graphics.push()
		love.graphics.translate(x,y)
		love.graphics.rotate(p.angle)
		love.graphics.translate(-x,-y)
	
		if p.type == "health" then
			love.graphics.setColor(255,0,0,155)
			love.graphics.circle("fill", x,y,p.w,p.segments)
		elseif p.type == "mana" then
			love.graphics.setColor(155,0,255,155)
			love.graphics.circle("fill", x,y,p.w,p.segments)
		elseif p.type == "coin" then
			love.graphics.setColor(255,155,0,155)
			love.graphics.circle("fill", x,y,p.w,p.segments)
		end
		love.graphics.pop()
		
		if debug then
			drawbounds(p)
		end
	end
 end


function pickups:main(dt)
	if editing then return end
	for _,p in pairs(arena.pickups) do
		p.angle = p.angle + dt * math.pi*2
		p.angle = p.angle % (2*math.pi)
	end
end
