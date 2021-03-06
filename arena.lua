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
	camera:setScale(0.6,0.6)

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
	arena.traps = {}
	arena.pickups = {}
	arena.projectiles = {}
	arena.pits = {}
	arena.enemies = {}
	

	
	arena.wall_texture = love.graphics.newImage("data/textures/wall/brick.png")
	arena.wall_texture:setWrap("repeat", "clamp")
	
	arena.wall_height = arena.wall_texture:getHeight()
	
	arena.floor_texture = love.graphics.newImage("data/textures/floor/tiles.png")
	arena.floor_texture:setWrap("repeat", "repeat")

	arena.top_texture = love.graphics.newImage("data/textures/marble.png")
	arena.top_texture:setWrap("repeat", "repeat")
	
	arena.pit_texture = love.graphics.newImage("data/textures/pit/brick.png")
	arena.pit_texture:setWrap("repeat", "clamp")
	
	arena.shroud = love.graphics.newImage("data/textures/shroud.png")
	
	
	arena.spike_up_texture =  love.graphics.newImage("data/textures/spike_up.png")
	arena.spike_down_texture =  love.graphics.newImage("data/textures/spike_down.png")

	

	arena.bgm = love.audio.newSource("data/music/zhelanov/dark_ambience.ogg")
	
	if not editing then 
		arena.bgm:play() 
	end
end



function arena:draw()
	
	--floor
	love.graphics.setColor(80,70,85,255)
	
	local quad = love.graphics.newQuad( 0,0,arena.w,arena.h, arena.floor_texture:getDimensions() )
	love.graphics.draw(arena.floor_texture, quad, 0,0)
	
	--walls layer 1
	for _, w in pairs(arena.walls) do
		love.graphics.setColor(60,60,70,255)
	
		local quad = love.graphics.newQuad( 0,0, w.w, arena.wall_height, arena.wall_texture:getDimensions() )
		love.graphics.draw(arena.wall_texture, quad, w.x,w.y+w.h-self.wall_height/2)
	
	end
	
	--pits
	for _, p in pairs(arena.pits) do
		love.graphics.setColor(0,0,0,255)
		love.graphics.rectangle("fill",p.x,p.y,p.w,p.h+arena.wall_height/2)
	
		love.graphics.setColor(60,60,70,255)

		
		local quad = love.graphics.newQuad( 0,0, p.w, arena.wall_height, arena.pit_texture:getDimensions() )
		love.graphics.draw(arena.pit_texture, quad, p.x,p.y)
		
		--outline shadow
		love.graphics.setColor(40,40,50,200)
		--left
		love.graphics.line(p.x,p.y,p.x+p.w,p.y)

		if debug then
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle("line", p.x,p.y,p.w,p.h+arena.wall_height/2)
		end
	end
	
	traps:drawbehind(arena.traps)
	pickups:drawbehind(arena.pickups)
	enemies:drawbehind(arena.enemies)
	player:draw()
	pickups:drawinfront(arena.pickups)
	traps:drawinfront(arena.traps)
	
	
	enemies:drawinfront(arena.enemies)
	enemies:drawhealth(arena.enemies)
	projectiles:draw()

	
	--walls layer 2
	for _, w in pairs(arena.walls) do
		--shadow
		love.graphics.setColor(0,0,0,70)
		love.graphics.rectangle("fill", w.x+w.w, w.y, 20,w.h)


		local vertices = { 
			w.x+w.w, 
			w.y+w.h, 
			
			w.x+w.w+20,
			w.y+w.h,
			
			w.x+w.w,
			w.y+w.h+self.wall_height/2
		 }
		love.graphics.polygon("fill", vertices)
		
	end
	
	--walls layer 3
	for _, w in pairs(arena.walls) do

		--top
		love.graphics.setColor(40,40,50,255)

		
		local quad = love.graphics.newQuad( w.x,w.y-self.wall_height/2,w.w,w.h, arena.top_texture:getDimensions() )
		love.graphics.draw(arena.top_texture, quad, w.x,w.y-self.wall_height/2)

		love.graphics.setColor(40,40,50,200)
		love.graphics.rectangle("line",w.x,w.y-self.wall_height/2,w.w,w.h)
		if debug then
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle("line", w.x,w.y,w.w,w.h+arena.wall_height/2)
		end
	end
	

	if not editing then
	--shadow/shroud
	love.graphics.setColor(0,0,0,math.random(200,240))
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
	--math.randomseed( os.time() )
	local offset = 10 -- collision offset
	table.insert(arena.traps, {
		x = x or 0,
		y = y or 0,
		offset = offset,
		w = arena.spike_down_texture:getWidth(),
		h = arena.spike_down_texture:getHeight()-offset,
		cycle = math.random (0,20)/10,
		delay = 1,
		active = false,

	})
end




function arena:main(dt)
	traps:main(arena.traps,dt)
end



