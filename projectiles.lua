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
projectiles = {}


function projectiles:add(entity,dir,dt)

	player.projectileCycle = math.max(0, player.projectileCycle - dt)

	if player.projectileCycle <= 0 then
	
		local x, y, w, h, xvel, yvel, velocity, damage = 0
		
		if entity.weapon == "gun" then
			if dir == "left" or dir == "right" then
				w = 5
				h = 2
			else
				w = 2
				h = 5
			end
			velocity = 500
			damage = 5
			entity.projectileDelay = 0.25
		end
		
		if entity.weapon == "laser" then
			if dir == "left" or dir == "right" then
				w = 15
				h = 2
			else
				w = 2
				h = 15
			end
			velocity = 800
			damage = 10
			entity.projectileDelay = 0.5
		end

		x = entity.x +entity.w/2
		y = entity.y +entity.h/2
		
		if dir == "up" then yvel = -velocity end
		if dir == "down" then yvel = velocity end
		if dir == "left" then xvel = -velocity end
		if dir == "right" then xvel = velocity end
	
		table.insert(projectiles, {
			type = entity.weapon,
			w = w,
			h = h,
			x = x -w/2 or 0,
			y = y -h/2 or 0,
			xvel = xvel or 0,
			yvel = yvel or 0,
			damage = damage or 0,

		})
				
		player.projectileCycle = player.projectileDelay
		

	end
end

function projectiles:main(dt)
	for i, p in ipairs(projectiles) do
		p.newx = p.x + p.xvel *dt
		p.newy = p.y + p.yvel *dt

		if collision:bounds(p) then
			table.remove(projectiles, i)
		end

		for _, w in ipairs(arena.walls) do
			if collision:overlap(p.newx,p.newy,p.w,p.h, w.x,w.y,w.w,w.h) then
				table.remove(projectiles, i)
			end
		end
		
		p.x = p.newx
		p.y = p.newy
	end
	
end

function projectiles:draw()
	local n = 0
	for i,p in ipairs(projectiles) do
		if p.type == "gun" then
			love.graphics.setColor(255,100,0,255)
			love.graphics.rectangle("fill", p.x,p.y,p.w,p.h)
		elseif p.type == "laser" then
			love.graphics.setColor(255,100,255,255)
			love.graphics.rectangle("fill", p.x,p.y,p.w,p.h)
		end
		n = n +1
	end
	arena.projectiles = n
end
