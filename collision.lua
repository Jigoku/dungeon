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
collision = {}

function collision:overlap(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end


function collision:right(a,b)
	return a.newx <= b.x+b.w and 
					a.x >= b.x+b.w 
end

function collision:left(a,b)
	return a.newx+a.w >= b.x and 
					a.x+a.w <= b.x 
end

function collision:top(a,b)
	return a.newy+a.h >= b.y  and 
					a.y+a.h <= b.y
end

function collision:bottom(a,b)
	return a.newy <= b.y+b.h and 
					a.y+a.h >= b.y+b.h
end


function collision:bounds(o) 
	return  (o.x < arena.x) or
			(o.y < arena.y) or
			(o.x+o.w > arena.w) or
			(o.y+o.h > arena.h)
end
