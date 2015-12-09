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
	player.dir = "down"
	player.speed = 100
	player.score = 0
	player.weaponslot = 1
	
	player.health = 72
	player.maxhealth = 100
	
	player.mana = 22
	player.maxmana = 100
	
	player.projectileDelay = 0.1
	player.projectileCycle = 0
	
	
	player.texture_front = love.graphics.newImage("data/textures/guy_front.png")
	player.texture_back = love.graphics.newImage("data/textures/guy_back.png")
	player.texture_left = love.graphics.newImage("data/textures/guy_left.png")
	player.texture_right = love.graphics.newImage("data/textures/guy_right.png")
	--default
	player.texture = player.texture_front
	
	camera:setPosition(player.x+player.w/2,player.y +player.h/2)
end

function player:main(dt)
	player:move(dt)
	player:shoot(dt)
	player:state(dt)
	player:setcamera(dt)
end

function player:shoot(dt)
	--player shooting
	if love.keyboard.isDown(binds.shoot_up) then 
		player.dir = "up"
		player.texture = player.texture_back
		projectiles:add(player,"up",dt) 
		return 
	end
	if love.keyboard.isDown(binds.shoot_down) then 
		player.dir = "down"
		player.texture = player.texture_front
		projectiles:add(player,"down",dt)
		return 
	 end
	if love.keyboard.isDown(binds.shoot_left) then 
		player.dir = "left"
		player.texture = player.texture_left
		projectiles:add(player,"left",dt) 
		return 
	end
	if love.keyboard.isDown(binds.shoot_right) then 
		player.dir = "right"
		player.texture = player.texture_right
		projectiles:add(player,"right",dt) 
		return 
	end
end


function player:keypressed(key)
	if key == binds.slot1 then player.weaponslot = 1 end
	if key == binds.slot2 then player.weaponslot = 2 end
end

function player:move(dt)
	--player movement

	if love.keyboard.isDown(binds.move_left) then 
		player.dir = "left"
		player.texture = player.texture_left
		player.newx = player.x -player.speed *dt 
	end
	if love.keyboard.isDown(binds.move_right) then 
		player.dir = "right"
		player.texture = player.texture_right
		player.newx = player.x +player.speed *dt 
	end
	if love.keyboard.isDown(binds.move_up) then 
		player.dir = "up"
		player.texture = player.texture_back
		player.newy = player.y -player.speed *dt 
	end
	if love.keyboard.isDown(binds.move_down) then 
		player.dir = "down"
		player.texture = player.texture_front
		player.newy = player.y +player.speed *dt
	 end
	
	for _,w in pairs(arena.walls) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, w.x,w.y,w.w,w.h) then
		
			if collision:left(player,w) then player.newx = w.x -player.w -1  end
			if collision:right(player,w) then player.newx = w.x +w.w +1  end
			if collision:top(player,w) then player.newy = w.y -player.h -1  end
			if collision:bottom(player,w) then player.newy = w.y+w.h +1  end
		end
	end
	
	for _,p in pairs(arena.pits) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, p.x,p.y,p.w,p.h) then
	
			if collision:left(player,p) then player.newx = p.x -player.w -1  end
			if collision:right(player,p) then player.newx = p.x +p.w +1  end
			if collision:top(player,p) then player.newy = p.y -player.h -1  end
			if collision:bottom(player,p) then player.newy = p.y+p.h +1  end
		end
	end
	
	for _, st in pairs(arena.spiketraps) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, st.x,st.y,st.w,st.h) then
			player.health = player.health - 100*dt
		end
	end
	
	for i, p in pairs(arena.pickups) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, p.x,p.y,p.w,p.h) then
			if p.type == "health" then
				player.health = player.health + p.value
				table.remove(arena.pickups, i)
			elseif p.type == "mana" then
				player.mana = player.mana + p.value
				table.remove(arena.pickups, i)
			end
		end
	end
	
	if player.newx < arena.x then player.newx = arena.x +1 end
	if player.newy < arena.y then player.newy = arena.y +1 end
	if player.newx+player.w > arena.w then player.newx = arena.w-player.w -1 end
	if player.newy+player.h > arena.h then player.newy = arena.h-player.h -1 end
	
	player.x = math.round(player.newx)
	player.y = math.round(player.newy)
end


function player:setcamera(dt)
	if player.x+player.w/2 > arena.x+WIDTH/3*camera.scaleX and (player.x+player.w/2 < arena.x+arena.w-WIDTH/3*camera.scaleX) then
		camera.x = (player.x+player.w/2)
	end
	if player.y+player.h/2 > arena.y+HEIGHT/3*camera.scaleY and (player.y+player.h/2 < arena.y+arena.h-HEIGHT/3*camera.scaleY) then
		camera.y = (player.y +player.h/2)
	end
end

function player:state(dt)
	if player.health < 1 then print("game over") reset() end
	if player.mana < 1 then player.mana = 0 end
end

function player:draw()
	--draw player
	if debug then
		love.graphics.setColor(155,255,100,255)
		love.graphics.rectangle("fill", player.x,player.y,player.w,player.h)
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line", player.x,player.y,player.w,player.h)

	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(player.texture, player.x,player.y)
end
