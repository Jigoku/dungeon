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
	player.spawnx = arena.x + arena.w/2 - player.w/2
	player.spawny = arena.y + arena.h/2 - player.h/2
	player.x = player.spawnx
	player.y = player.spawny
	player.newx = player.spawnx
	player.newy = player.spawny
	player.dir = "down"
	player.speed = 80
	player.score = 0
	player.coins = 0
	player.lives = 3
	player.health = 100
	player.maxhealth = 100
	player.mana = 100
	player.maxmana = 100
	
	player.weaponslot = 1		--default weaponslot
	
	player.camerashift = 80 	-- value until camera moves
	
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
	if key == binds.slot3 then player.weaponslot = 3 end
	if key == binds.slot4 then player.weaponslot = 4 end
	if key == binds.slot5 then player.weaponslot = 5 end
	if key == binds.slot6 then player.weaponslot = 6 end
	if key == binds.slot7 then player.weaponslot = 7 end
	if key == binds.slot8 then player.weaponslot = 8 end
	if key == binds.slot9 then player.weaponslot = 9 end
	if key == binds.slot10 then player.weaponslot = 10 end
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
		if collision:overlap(player.newx,player.newy,player.w,player.h, w.x,w.y,w.w,w.h+(arena.wall_height/2)-(player.h/2)) then
		
			if collision:left(player,w) then player.newx = w.x -player.w -1 *dt  end
			if collision:right(player,w) then player.newx = w.x +w.w +1 *dt  end
			if collision:top(player,w) then player.newy = w.y -player.h -1 *dt  end
			
			local y = collision:ret_bottom_overlap(player,w)
			if y then player.newy = y +1 *dt end
		end
	end
	
	for _,p in pairs(arena.pits) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, p.x,p.y,p.w,p.h+(arena.wall_height/2)-(player.h/2)) then
	
			if collision:left(player,p) then player.newx = p.x -player.w -1 *dt  end
			if collision:right(player,p) then player.newx = p.x +p.w +1 *dt  end
			if collision:top(player,p) then player.newy = p.y -player.h -1 *dt  end
			
			local y = collision:ret_bottom_overlap(player,p)
			if y then player.newy = y +1 *dt end
		end
	end
	
	for _, st in pairs(arena.spiketraps) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, st.x,st.y+st.offset,st.w,st.h) then
			if player.y < st.y then
				if st.active then
					player.health = player.health - 100*dt
				end
			end
		end
	end
	
	for i, p in pairs(arena.pickups) do
		if collision:overlap(player.newx,player.newy,player.w,player.h, p.x,p.y,p.w,p.h) then
			if p.type == "health" then
				if player.health < player.maxhealth then
					player.health = player.health + p.value
					table.remove(arena.pickups, i)
					
					if player.health > player.maxhealth then
						player.health = player.maxhealth
					end
				end
			elseif p.type == "mana" then
				if player.mana < player.maxmana then
					player.mana = player.mana + p.value
					table.remove(arena.pickups, i)
					
					if player.mana > player.maxmana then
						player.mana = player.maxmana
					end
				end
			elseif p.type == "coin" then
					player.coins = player.coins + p.value
					table.remove(arena.pickups, i)

			end
		end
	end
	
	if player.newx < arena.x then player.newx = arena.x +1 *dt end
	if player.newy < arena.y then player.newy = arena.y +1 *dt end
	if player.newx+player.w > arena.w then player.newx = arena.w-player.w -1 *dt end
	if player.newy+player.h > arena.h then player.newy = arena.h-player.h -1 *dt end
	
	player.x = player.newx
	player.y = player.newy
end


function player:setcamera(dt)
	if player.x < camera.x -self.camerashift then
		camera.x = camera.x - player.speed *dt
	end
	
	if player.x+player.w > camera.x +self.camerashift then
		camera.x = camera.x + player.speed *dt
	end
	
	if player.y < camera.y -self.camerashift then
		camera.y = camera.y - player.speed *dt
	end
	
	if player.y+player.h > camera.y +self.camerashift then
		camera.y = camera.y + player.speed *dt
	end
	

	
end

function player:state(dt)
	if player.health < 1 then 
		player.lives = player.lives -1
		player.health = player.maxhealth
		
		camera.x = player.spawnx
		camera.y = player.spawny
		player.x = player.spawnx
		player.y = player.spawny
		player.newx = player.spawnx
		player.newy = player.spawny
		

		if player.lives < 0 then print("game over")
			print("game over") 
			reset() 
		end
	end
	if player.mana < 1 then player.mana = 0 end
end

function player:draw()
	--draw player
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(player.texture, player.x,player.y)
	
	if debug then
		drawbounds(player)
	
		love.graphics.setColor(255,255,0,50)
		love.graphics.rectangle("line",camera.x - self.camerashift, camera.y - self.camerashift, 
		self.camerashift*2, self.camerashift*2)
	end
end
