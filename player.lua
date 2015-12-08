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
player = {}

function player:init()
	player.w = 30
	player.h = 30
	player.x = arena.x + arena.w/2 - player.w/2
	player.y = arena.y + arena.h/2 - player.h/2
	player.newx = player.x
	player.newy = player.y
	player.speed = 250
	player.score = 0
	player.weapon = "gun"
	
	player.projectileDelay = 0.1
	player.projectileCycle = 0
end

function player:main(dt)
	player:move(dt)
	player:shoot(dt)
end

function player:shoot(dt)
	--player shooting
	if love.keyboard.isDown(binds.shoot_up) then projectiles:add(player,"up",dt) return end
	if love.keyboard.isDown(binds.shoot_down) then projectiles:add(player,"down",dt) return end
	if love.keyboard.isDown(binds.shoot_left) then projectiles:add(player,"left",dt) return end
	if love.keyboard.isDown(binds.shoot_right) then projectiles:add(player,"right",dt) return end
end




function player:move(dt)
	--player movement

	
	if love.keyboard.isDown(binds.move_left) then player.newx = player.x -player.speed *dt end
	if love.keyboard.isDown(binds.move_right) then player.newx = player.x +player.speed *dt end
	if love.keyboard.isDown(binds.move_up) then player.newy = player.y -player.speed *dt end
	if love.keyboard.isDown(binds.move_down) then player.newy = player.y +player.speed *dt end
	
	for _,w in ipairs(arena.walls) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, w.x,w.y,w.w,w.h) then
		
			if collision:left(player,w) then player.newx = w.x -player.w -1  end
			if collision:right(player,w) then player.newx = w.x +w.w +1  end
			if collision:top(player,w) then player.newy = w.y -player.h -1  end
			if collision:bottom(player,w) then player.newy = w.y+w.h +1  end
		end
	end
	
	
	if player.newx < arena.x then player.newx = arena.x +1 end
	if player.newy < arena.y then player.newy = arena.y +1 end
	if player.newx+player.w > arena.w then player.newx = arena.w-player.w -1 end
	if player.newy+player.h > arena.h then player.newy = arena.h-player.h -1 end
	
	player.x = player.newx
	player.y = player.newy
end

function player:draw()
	--draw player
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("line", player.x,player.y,player.w,player.h)
end
