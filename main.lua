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
 
WIDTH = default_width
HEIGHT = default_height 

require("binds")


require("arena")
require("camera")
require("player")
require("collision")
require("projectiles")
require("enemies")
require("shared")
require("hud")
require("pickups")
paused = false
debug = false


	
		
function reset()
	arena:init()
	player:init()
	
	--test map
	arena:addwall(100,100,500,200)
	arena:addwall(300,200,100,400)
	arena:addwall(800,400,200,200)
	arena:addspiketrap(600,800,60,60)	
	arena:addspiketrap(630,800,60,60)	
	arena:addspiketrap(660,800,60,60)	
	arena:addspiketrap(630,900,60,60)	
	arena:addspiketrap(660,900,60,60)	

	arena:addpit(500,800,60,60)	
	arena:addpit(300,900,130,100)	
	
	arena:addpickup("health",450,400)
	arena:addpickup("health",500,400)
	arena:addpickup("mana",500,520)
	arena:addpickup("mana",500,570)
	
	for i=1,10 do
		enemies:test()
	end
end

function love.load()
	love.graphics.setBackgroundColor(0,0,0,255)
	reset()
end

function love.resize(w,h)
	WIDTH = w
	HEIGHT= h
end

function love.update(dt)
	if paused then return end
	
	player:main(dt)
	arena:main(dt)
	enemies:main(dt)
	projectiles:main(dt)
	

	for _,p in pairs(arena.pickups) do
		p.angle = p.angle + dt * math.pi*2
		p.angle = p.angle % (2*math.pi)
	end
end

function love.draw()
	

	
	camera:set()
		arena:draw()
	camera:unset()
	
	hud:draw()
	
	
	
	--debug misc
	if debug then
		love.graphics.setColor(255,255,255,155)
		love.graphics.printf("fps: ".. love.timer.getFPS(),WIDTH-100,10,300,"left",0,1,1)
		love.graphics.printf("x: ".. math.round(player.x),WIDTH-100,25,300,"left",0,1,1)
		love.graphics.printf("y: ".. math.round(player.y),WIDTH-100,40,300,"left",0,1,1)
		love.graphics.printf("dir: ".. player.dir,WIDTH-100,55,300,"left",0,1,1)
		love.graphics.printf("projectiles: ".. tostring(arena.total_projectiles),WIDTH-100,70,300,"left",0,1,1)
		love.graphics.printf("state: " .. (paused and "paused" or "running") ,WIDTH-100,85,300,"left",0,1,1)
		love.graphics.printf("weapon: " .. tostring(projectiles:slot2name(player.weaponslot)) ,WIDTH-100,100,300,"left",0,1,1)
		love.graphics.printf("enemies: " .. arena.total_enemies ,WIDTH-100,115,300,"left",0,1,1)
		love.graphics.printf("coins: " .. player.coins ,WIDTH-100,130,300,"left",0,1,1)
	end

end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "p" then paused = not paused end
	if key == "`" then debug = not debug end
	if key == "f1" then reset() end
	
	if not paused then
		player:keypressed(key)
	end
end




