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

projectiles.arrow_texture = love.graphics.newImage("data/textures/arrow.png")
projectiles.arrow_sound = love.audio.newSource("data/sounds/arrow.wav", "static")


projectiles.icon_slot1 = love.graphics.newImage("data/textures/pistol.png")
projectiles.icon_slot2 = love.graphics.newImage("data/textures/bow.png")

function projectiles:add(entity,dir,dt)

	if self:slot2name(entity.weaponslot) == nil then return end

	player.projectileCycle = math.max(0, player.projectileCycle - dt)

	if player.projectileCycle <= 0 then
	
		local x, y, w, h, xvel, yvel, velocity, damage = 0
		
		--pistol
		if self:slot2name(entity.weaponslot) == "pistol" then
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
			
		--laser
		elseif self:slot2name(entity.weaponslot) == "bow" then
			if dir == "left" or dir == "right" then
				w = self.arrow_texture:getWidth()
				h = self.arrow_texture:getHeight()
			else
				w = self.arrow_texture:getHeight()
				h = self.arrow_texture:getWidth()
			end
			velocity = 400
			damage = math.random(6,10)
			entity.projectileDelay = 1.2
			self.arrow_sound:play()
		end

		x = entity.x +entity.w/2
		y = entity.y +entity.h/2
		
		if dir == "up" then yvel = -velocity end
		if dir == "down" then yvel = velocity end
		if dir == "left" then xvel = -velocity end
		if dir == "right" then xvel = velocity end
	
		table.insert(arena.projectiles, {
			type = self:slot2name(entity.weaponslot),
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

function projectiles:slot2icon(slot)
	if slot == 1 then return self.icon_slot1
	elseif slot == 2 then return self.icon_slot2 
	elseif slot == 3 then return nil 
	elseif slot == 4 then return nil 
	elseif slot == 5 then return nil 
	elseif slot == 6 then return nil 
	elseif slot == 7 then return nil 
	elseif slot == 8 then return nil 
	elseif slot == 9 then return nil 
	elseif slot == 10 then return nil 
	end
end

function projectiles:slot2name(slot)

	if slot == 1 then return "pistol"
	elseif slot == 2 then return "bow" 
	elseif slot == 3 then return nil 
	elseif slot == 4 then return nil 
	elseif slot == 5 then return nil 
	elseif slot == 6 then return nil 
	elseif slot == 7 then return nil 
	elseif slot == 8 then return nil 
	elseif slot == 9 then return nil 
	elseif slot == 10 then return nil 
	end
end

function projectiles:main(dt)
	local n = 0
	for i, p in pairs(arena.projectiles) do
		p.newx = p.x + p.xvel *dt
		p.newy = p.y + p.yvel *dt

		if collision:bounds(p) then
			table.remove(arena.projectiles, i)
		end

		for _, w in pairs(arena.walls) do
			if collision:overlap(p.newx,p.newy,p.w,p.h, w.x,w.y,w.w,w.h) then
				table.remove(arena.projectiles, i)
			end
		end
		
		for n, e in pairs(arena.enemies) do
			if collision:overlap(p.newx,p.newy,p.w,p.h, e.x,e.y,e.w,e.h) then
				table.remove(arena.projectiles, i)
				e.health = e.health - p.damage
				
				if e.health <= 0 then
					enemies:die(e)
					table.remove(arena.enemies, n)

				end
			end
		end
		
		p.x = p.newx
		p.y = p.newy
		n = n +1
	end
	arena.total_projectiles = n
end

function projectiles:draw()
	for _,p in pairs(arena.projectiles) do
		if p.type == "pistol" then
			love.graphics.setColor(255,100,0,255)
			love.graphics.rectangle("fill", p.x,p.y,p.w,p.h)
		elseif p.type == "bow" then
			love.graphics.setColor(255,255,255,255)
			--love.graphics.rectangle("fill", p.x,p.y,p.w,p.h)
			if p.yvel > 0 then
				love.graphics.draw(
					self.arrow_texture,p.x+self.arrow_texture:getWidth(),p.y+self.arrow_texture:getWidth(),
					math.rad(90),-1,-1,0,self.arrow_texture:getWidth()
				)
			elseif p.yvel < 0 then
				love.graphics.draw(
					self.arrow_texture,p.x+self.arrow_texture:getWidth(),p.y,
					math.rad(-90),-1,1,0,self.arrow_texture:getWidth()
				)
			elseif p.xvel > 0 then
				love.graphics.draw(projectiles.arrow_texture,p.x+self.arrow_texture:getWidth(),p.y,0,-1,1,0)
			elseif p.xvel < 0 then
				love.graphics.draw(projectiles.arrow_texture,p.x,p.y)
			end
		end
		
		if debug then
			drawbounds(p)
		end
	end
end

