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

enemies.ghost = love.graphics.newImage("data/textures/ghost.png")
enemies.ghost_boss = love.graphics.newImage("data/textures/ghost_boss.png")

function enemies:test()
	speed = math.random(50,70)
	table.insert(arena.enemies, {
		x = math.random(arena.x+1, arena.x+arena.w-w -1),
		y = math.random(arena.y+1, arena.y+arena.h-h -1),
		w = self.ghost:getWidth(),
		h = self.ghost:getHeight(),
		offset = 2,
		speed = speed,
		damage = 50,
		health = 20,
		maxhealth = 20,
		texture = self.ghost,
		name = "ghost",
	})
end

function enemies:testboss()
	w = 100
	h = 100
	speed = math.random(20,30)
	table.insert(arena.enemies, {
		x = math.random(arena.x+1, arena.x+arena.w-w -1),
		y = math.random(arena.y+1, arena.y+arena.h-h -1),
		w = self.ghost_boss:getWidth(),
		h = self.ghost_boss:getHeight(),
		offset = 20,
		speed = speed,
		damage = 100,
		health = 100,
		maxhealth = 100,
		texture = self.ghost_boss,
		name = "big ghost",
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


function enemies:drawbehind(table)
	for _, e in pairs(table) do
		if e.y+e.h < player.y+player.h then
			self:draw(e)
		end
	end
end

function enemies:drawinfront(table)
	for _, e in pairs(table) do
		if e.y+e.h > player.y+player.h then
			self:draw(e)
		end
	end
end

function enemies:draw(e) 
	love.graphics.setColor(255,255,255,155)
	love.graphics.draw(e.texture, e.x,e.y)
			
	--health bar
	love.graphics.setColor(255,0,0,55)
	love.graphics.rectangle("fill", e.x+e.w/2-e.maxhealth/2,e.y-5,e.maxhealth,2)
	--health value
	love.graphics.setColor(0,255,0,100)
	love.graphics.rectangle("fill", e.x+e.w/2-e.maxhealth/2,e.y-5,e.health,2)
		
	if debug then
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.name, e.x+e.w/2-e.maxhealth/2,e.y-15,0,0.5)		
		drawbounds(e)
	end
end



function enemies:die(enemy)
	local seed = math.random(0,100)
	if seed > 90 then
		arena:addpickup("health",enemy.x+enemy.w/2,enemy.y+enemy.h/2)
	end
	if seed < 10 then
		arena:addpickup("mana",enemy.x+enemy.w/2,enemy.y+enemy.h/2)
	end
	if seed >= 10 and seed <= 30 then
		arena:addpickup("coin",enemy.x+enemy.w/2,enemy.y+enemy.h/2)
	end
	
end
