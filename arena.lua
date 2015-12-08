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
end



function arena:draw()

	--floor
	love.graphics.setColor(10,20,30,255)
	love.graphics.rectangle("fill", 0,0,arena.w,arena.h)
		
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("line", 0,0,arena.w,arena.h)
	
	--walls
	
	for i, w in ipairs(arena.walls) do
		love.graphics.setColor(30,30,30,255)
		love.graphics.rectangle("fill", w.x,w.y,w.w,w.h)
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("line", w.x,w.y,w.w,w.h)
	end
	
	for i, st in ipairs(arena.spiketraps) do
		love.graphics.setColor(80,55,55,255)
		love.graphics.rectangle("fill", st.x,st.y,st.w,st.h)
	end
	
	for i, p in ipairs(arena.pickups) do
		if p.type == "health" then
			love.graphics.setColor(255,0,0,255)
			love.graphics.circle("fill", p.x,p.y,p.w,p.h)
		elseif p.type == "mana" then
			love.graphics.setColor(255,0,255,255)
			love.graphics.circle("fill", p.x,p.y,p.w,p.h)
		end
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
	})
end
