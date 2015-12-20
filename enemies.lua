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

enemies.sound_ghost_die =  love.audio.newSource("data/sounds/ghost_die.wav", "static")
enemies.sound_ghost_boss_die =  love.audio.newSource("data/sounds/ghost_boss_die.wav", "static")

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
	flying = false,
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
		name = "ghost_boss",
		flying = true,
	})
end

function enemies:traverse_vertical(e,o,dt)
        if player.y+player.h/2 < o.y+o.h/2 then
                e.newy = e.y - e.speed * dt
        else
                e.newy = e.y + e.speed * dt
        end
end




function enemies:traverse_horizontal(e,o,dt)

        if player.x+player.w/2 < o.x+o.w/2 then
                e.newx = e.x - e.speed * dt
        else
                e.newx = e.x + e.speed * dt
        end

end


function enemies:main(dt)
	if editing then return end

	local n = 0
	for i, e in pairs(arena.enemies) do
		e.newx = e.x or e.newx
        e.newy = e.y or e.newy
         
		--move towards the player
		local angle = math.atan2(player.y+player.h/2-e.h/2 - e.newy, player.x+player.w/2-e.w/2 - e.newx)
		e.newx = e.newx + (math.cos(angle) * e.speed * dt)
		e.newy = e.newy + (math.sin(angle) * e.speed * dt)

		
		--player
		if collision:overlap(e.newx,e.newy,e.w,e.h,player.newx,player.newy,player.w,player.h) then
			if collision:left(e,player) then e.newx = player.newx -e.w -1 *dt end
			if collision:right(e,player) then e.newx = player.newx +player.w +1 *dt end
			if collision:top(e,player) then e.newy = player.newy -e.h -1 *dt end
			if collision:bottom(e,player) then e.newy = player.newy+player.h +1 *dt end
			
			if not invincible then player.health = player.health - e.damage*dt end
		end
		
		--walls
		for _, w in pairs (arena.walls) do
			if collision:overlap(e.newx,e.newy,e.w,e.h,w.x,w.y,w.w,w.h+(arena.wall_height/2)-(e.h/2)) then
				if collision:left(e,w) then e.newx = w.x -e.w -1 *dt self:traverse_vertical(e,w,dt) end
				if collision:right(e,w) then e.newx = w.x +w.w +1 *dt self:traverse_vertical(e,w,dt) end
				if collision:top(e,w) then e.newy = w.y -e.h -1 *dt self:traverse_horizontal(e,w,dt) end
					
				local y = collision:ret_bottom_overlap(e,w)
				if y then e.newy = y +1 *dt self:traverse_horizontal(e,w,dt) end
			end
		end
		
		if not e.flying then
			for _, p in pairs (arena.pits) do
				if collision:overlap(e.newx,e.newy,e.w,e.h,p.x,p.y,p.w,p.h+(arena.wall_height/2)-(e.h/2)) then
					if collision:left(e,p) then e.newx = p.x -e.w -1 *dt self:traverse_vertical(e,p,dt) end
					if collision:right(e,p) then e.newx = p.x +p.w +1 *dt self:traverse_vertical(e,p,dt) end
					if collision:top(e,p) then e.newy = p.y -e.h -1 *dt self:traverse_horizontal(e,p,dt) end
							
					local y = collision:ret_bottom_overlap(e,p)
					if y then e.newy = y +1 *dt self:traverse_horizontal(e,p,dt) end
				end
			end
		end
		
		--other enemies
		for n, e2 in pairs(arena.enemies) do
			if collision:overlap(e.newx,e.newy,e.w,e.h,e2.x,e2.y,e2.w,e2.h) and not (i == n) then
				if collision:left(e,e2) then e.newx = e2.x -e.w -1 *dt  end
				if collision:right(e,e2) then e.newx = e2.x +e2.w +1 *dt end
				if collision:top(e,e2) then e.newy = e2.y -e.h -1 *dt end
				if collision:bottom(e,e2) then e.newy = e2.y+e2.h +1 *dt  end
			end
		end
		

		--update drawing position
		e.x = math.max(math.min(e.newx, arena.w - e.w), arena.x)
		e.y = math.max(math.min(e.newy, arena.h - e.h), arena.y)
		
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
	
	if debug then
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.name, e.x+e.w/2-e.maxhealth/2,e.y-15,0,0.4)		
		drawbounds(e)
	end
end

function enemies:drawhealth(table)
	for _,e in pairs(table) do
		--health bar
		love.graphics.setColor(255,0,0,55)
		love.graphics.rectangle("fill", e.x+e.w/2-e.maxhealth/2,e.y-5,e.maxhealth,2)
		--health value
		love.graphics.setColor(0,255,0,100)
		love.graphics.rectangle("fill", e.x+e.w/2-e.maxhealth/2,e.y-5,e.health,2)
	end
end

function enemies:die(enemy)
	local seed = math.random(0,100)
	if seed > 90 then
		pickups:add("health",enemy.x+enemy.w/2,enemy.y+enemy.h/2)
	end
	if seed < 10 then
		pickups:add("mana",enemy.x+enemy.w/2,enemy.y+enemy.h/2)
	end
	if seed >= 10 and seed <= 30 then
		pickups:add("coin",enemy.x+enemy.w/2,enemy.y+enemy.h/2)
	end
	
	if enemy.name == "ghost" then
		self.sound_ghost_die:play()
	elseif enemy.name == "ghost_boss" then
		self.sound_ghost_boss_die:play()
	end
end
