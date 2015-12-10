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
enemies = {}

enemies.texture = love.graphics.newImage("data/textures/ghost.png")

function enemies:test()
	w = 20
	h = 20
	speed = math.random(80,100)
	table.insert(arena.enemies, {
		x = math.random(arena.x+1, arena.x+arena.w-w -1),
		y = math.random(arena.y+1, arena.y+arena.h-h -1),
		w = w,
		h = h,
		speed = speed,
		damage = 50,
	})
end

function enemies:main(dt)
	local n = 0
	for i, e in pairs(arena.enemies) do
	
		--move towards the player
		local angle = math.atan2(player.y - e.y, player.x - e.x)
		e.newx = e.x + (math.cos(angle) * e.speed * dt)
		e.newy = e.y + (math.sin(angle) * e.speed * dt)
		
		--player
		if collision:overlap(e.newx,e.newy,e.w,e.h,player.newx,player.newy,player.w,player.h) then
			if collision:left(e,player) then e.newx = player.newx -e.w -1 *dt end
			if collision:right(e,player) then e.newx = player.newx +player.w +1 *dt end
			if collision:top(e,player) then e.newy = player.newy -e.h -1 *dt end
			if collision:bottom(e,player) then e.newy = player.newy+player.h +1 *dt end
			
			player.health = player.health - e.damage*dt
		end
		
		--walls
		for _, w in pairs (arena.walls) do
			if collision:overlap(e.newx,e.newy,e.w,e.h,w.x,w.y,w.w,w.h) then
				if collision:left(e,w) then e.newx = w.x -e.w -1 *dt end
				if collision:right(e,w) then e.newx = w.x +w.w +1 *dt end
				if collision:top(e,w) then e.newy = w.y -e.h -1 *dt end
				if collision:bottom(e,w) then e.newy = w.y+w.h +1 *dt end
			end
		end
		
		--other enemies
		for n, e2 in pairs(arena.enemies) do
			if collision:overlap(e.newx,e.newy,e.w,e.h,e2.x,e2.y,e2.w,e2.h) and not (i == n) then
				if collision:left(e,e2) then e.newx = e2.x -e.w -1 *dt end
				if collision:right(e,e2) then e.newx = e2.x +e2.w +1 *dt end
				if collision:top(e,e2) then e.newy = e2.y -e.h -1 *dt end
				if collision:bottom(e,e2) then e.newy = e2.y+e2.h +1 *dt  end
			end
		end
		

		--update drawing position
		e.x = e.newx
		e.y = e.newy
		
		n = n + 1
	end
	
	arena.total_enemies = n
end


function enemies:draw()
	for _, e in pairs(arena.enemies) do
		love.graphics.setColor(255,255,255,155)
		love.graphics.draw(self.texture, e.x,e.y)
		
		if debug then
			drawbounds(e)
		end
	end

end
