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

arena.walls = {}

function arena:init()
	--properties
	arena.x = 0
	arena.y = 0
	arena.w = 1000
	arena.h = 1500

	--statistics
	arena.projectiles = 0
	arena.enemies = 0
end



function arena:draw()

	--floor
	love.graphics.setColor(0,78,31,255)
	love.graphics.rectangle("fill", 0,0,arena.w,arena.h)
	
	--walls
	love.graphics.setColor(30,30,30,255)	
	for i, w in ipairs(arena.walls) do
		love.graphics.rectangle("fill", w.x,w.y,w.w,w.h)
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

