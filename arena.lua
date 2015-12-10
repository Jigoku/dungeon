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
arena = {}



function arena:init()
	--properties
	arena.x = 0
	arena.y = 0
	arena.w = 1000
	arena.h = 1500

	--statistics
	arena.total_projectiles = 0
	arena.total_enemies = 0
	
	--world entities
	arena.walls = {}
	arena.spiketraps = {}
	arena.pickups = {}
	arena.projectiles = {}
	arena.pits = {}
	arena.enemies = {}
	
	arena.wall_height = 50
	
	arena.wall_texture = love.graphics.newImage("data/textures/brick.png")
	arena.wall_texture:setWrap("repeat", "clamp")
	
	arena.floor_texture = love.graphics.newImage("data/textures/checked.png")
	arena.floor_texture:setWrap("repeat", "repeat")

	arena.top_texture = love.graphics.newImage("data/textures/marble.png")
	arena.top_texture:setWrap("repeat", "repeat")
	
	arena.pit_texture = love.graphics.newImage("data/textures/brick_pit.png")
	arena.pit_texture:setWrap("repeat", "clamp")
	
	arena.shroud = love.graphics.newImage("data/textures/shroud.png")
end



function arena:draw()
	
	--floor
	love.graphics.setColor(80,80,100,255)
	
	local quad = love.graphics.newQuad( 0,0,arena.w,arena.h, arena.floor_texture:getDimensions() )
	love.graphics.draw(arena.floor_texture, quad, 0,0)
	
	--walls layer 1
	for _, w in pairs(arena.walls) do
		love.graphics.setColor(40,40,50,255)
		
		local quad = love.graphics.newQuad( 0,0, w.w, arena.wall_height, arena.wall_texture:getDimensions() )
		love.graphics.draw(arena.wall_texture, quad, w.x,w.y+w.h-self.wall_height/2)
	
	end
	
	--pits
	for _, p in pairs(arena.pits) do
		love.graphics.setColor(0,0,0,255)
		love.graphics.rectangle("fill",p.x,p.y,p.w,p.h+arena.wall_height/2)
	
		love.graphics.setColor(40,40,50,255)
		
		local quad = love.graphics.newQuad( 0,0, p.w, arena.wall_height, arena.pit_texture:getDimensions() )
		love.graphics.draw(arena.pit_texture, quad, p.x,p.y)
		
		--outline shadow
		love.graphics.setColor(40,40,50,255)
		love.graphics.rectangle("line",p.x,p.y,p.w,p.h+arena.wall_height/2)
				
		if debug then
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle("line", p.x,p.y,p.w,p.h)
		end
	end
	
	--traps
	for _, st in pairs(arena.spiketraps) do
		love.graphics.setColor(80,55,55,255)
		love.graphics.rectangle("fill", st.x,st.y,st.w,st.h)
	end
	
	--pickups
	for _, p in pairs(arena.pickups) do
		local x = p.x+p.w/2
		local y = p.y+p.h/2
		--shadow
		love.graphics.push()
		love.graphics.translate(x,y+p.h)
		love.graphics.rotate(p.angle)
		love.graphics.translate(-x,-(y+p.h))
	
		love.graphics.setColor(0,0,0,155)
		love.graphics.circle("fill", x,y+p.h,p.w,3)
		love.graphics.pop()
	
		--graphic
		love.graphics.push()
		love.graphics.translate(x,y)
		love.graphics.rotate(p.angle)
		love.graphics.translate(-x,-y)
	
		if p.type == "health" then
			love.graphics.setColor(255,0,0,255)
			love.graphics.circle("fill", x,y,p.w,3)
		elseif p.type == "mana" then
			love.graphics.setColor(255,0,255,255)
			love.graphics.circle("fill", x,y,p.w,3)
		end
		love.graphics.pop()
		
		if debug then
			drawbounds(p)
		end
	end
	
	enemies:drawbehind()
	player:draw()
	enemies:drawinfront()
	projectiles:draw()
	enemies:drawhealth()
	

	
	--walls layer 2
	for _, w in pairs(arena.walls) do
		--shadow
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", w.x+w.w, w.y, 20,w.h)
	end
	
	--walls layer 3
	for _, w in pairs(arena.walls) do

		--top
		love.graphics.setColor(20,20,30,255)
		local quad = love.graphics.newQuad( w.x,w.y-self.wall_height/2,w.w,w.h, arena.top_texture:getDimensions() )
		love.graphics.draw(arena.top_texture, quad, w.x,w.y-self.wall_height/2)


		if debug then
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle("line", w.x,w.y,w.w,w.h)
		end
	end
	

	
	--shadow/shroud
	love.graphics.setColor(0,0,0,200)
	love.graphics.draw(self.shroud, player.x+player.w/2-self.shroud:getWidth()/2,player.y+player.h/2-self.shroud:getHeight()/2)
	
	local x = player.x+player.w/2-self.shroud:getWidth()/2
	local y = player.y+player.h/2-self.shroud:getHeight()/2
	
	--left
	if debug then
		love.graphics.setColor(0,0,255,200)
	end
	love.graphics.rectangle("fill", 
		x-self.shroud:getWidth(),
		y-self.shroud:getHeight()/2,
		self.shroud:getWidth(),
		self.shroud:getHeight()*2
	)
	--right
	if debug then
		love.graphics.setColor(0,0,255,200)
	end
	love.graphics.rectangle("fill", 
		x+self.shroud:getWidth(),
		y-self.shroud:getHeight()/2,
		self.shroud:getWidth(),
		self.shroud:getHeight()*2
	)
	--top
	if debug then
		love.graphics.setColor(0,255,0,200)
	end
	love.graphics.rectangle("fill", 
		x,
		y-self.shroud:getHeight()/2,
		self.shroud:getWidth(),
		self.shroud:getHeight()/2
	)
	--bottom
	if debug then
		love.graphics.setColor(0,255,0,200)
	end
	love.graphics.rectangle("fill", 
		x,
		y+self.shroud:getHeight(),
		self.shroud:getWidth(),
		self.shroud:getHeight()/2
	)
	
end


function arena:addwall(x,y,w,h)
	table.insert(arena.walls, {
		x = x or 0,
		y = y or 0,
		w = w or 0,
		h = h or 0,
	})
end
function arena:addpit(x,y,w,h)
	table.insert(arena.pits, {
		x = x or 0,
		y = y or 0,
		w = w or 0,
		h = h or 0,
	})
end
function arena:addspiketrap(x,y,w,h)
	table.insert(arena.spiketraps, {
		x = x or 0,
		y = y or 0,
		w = w or 0,
		h = h or 0,
	})
end

function arena:addpickup(type,x,y)
	if type == "health" then
		w = 7
		h = 7
		value = 10
	elseif type == "mana" then
		w = 7
		h = 7
		value = 10
	end
	table.insert(arena.pickups, {
		type = type or nil,
		x = x or 0,
		y = y or 0,
		w = w or 0,
		h = h or 0,
		value = value or 0,
		angle = math.random(360)
	})
end
