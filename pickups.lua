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
 
 pickups.health_potion = love.graphics.newImage("data/textures/pickups/health_potion.png")
 
 
 function pickups:drawbehind(table)
	for _, p in pairs(table) do
		if p.y+p.h < player.y+player.h then
			self:draw(p)
		end
	end
end
 
function pickups:drawinfront(table)
	for _, p in pairs(table) do
		if p.y+p.h > player.y+player.h then
			self:draw(p)
		end
	end
end

function pickups:draw(p)
 	--pickups

		if p.texture then
			--graphic pickups
			if p.type == "health_potion" then
				
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(p.texture, p.x,p.y)
			end
			
		else
	
		
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

		end
		
		if debug then
			drawbounds(p)
		end

 end


function pickups:add(type,x,y)
	if type == "health" then
		table.insert(arena.pickups, {
			type = type or nil,
			x = x or 0,
			y = y or 0,
			w = 7,
			h = 7,
			value = 10,
			angle = math.random(360),
			segments = 3
		})
	elseif type == "mana" then
		table.insert(arena.pickups, {
			type = type or nil,
			x = x or 0,
			y = y or 0,
			w = 7,
			h = 7,
			value = 10,
			angle = math.random(360),
			segments = 3
		})
	elseif type == "coin" then
		table.insert(arena.pickups, {
			type = type or nil,
			x = x or 0,
			y = y or 0,
			w = 7,
			h = 7,
			value = 1,
			angle = math.random(360),
			segments = 5
		})
	elseif type == "health_potion" then
				table.insert(arena.pickups, {
			type = type or nil,
			x = x or 0,
			y = y or 0,
			w = 20,
			h = 20,
			value = 40,
			texture = pickups.health_potion
		})
	end

end

function pickups:main(dt)
	if editing then return end
	for _,p in pairs(arena.pickups) do
		if p.angle then
			p.angle = p.angle + dt * math.pi*2
			p.angle = p.angle % (2*math.pi)
		end
	end
end
