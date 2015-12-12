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
 
traps = {}

function traps:drawbehind(table)
	for _, st in pairs(table) do
		--base/floor
		love.graphics.setColor(45,55,60,255)
		love.graphics.rectangle("fill", st.x,st.y+st.offset,st.w,st.h)
		
		love.graphics.setColor(100,100,100,255)
		love.graphics.draw(arena.spike_down_texture, st.x,st.y)

		if st.active then
			love.graphics.draw(arena.spike_up_texture, st.x,st.y)
		end
	
	end
end

function traps:drawinfront(table)
	--traps in front  (move traps into module)
	for _, st in pairs(table) do
		if player.y+player.h > st.y then
		
			if player.y < st.y then
				love.graphics.setColor(100,100,100,255)
				if st.active then
					love.graphics.draw(arena.spike_up_texture, st.x,st.y)
				end
			end
		
		end
		
		if debug then
			love.graphics.setColor(155,0,155,255)
			love.graphics.rectangle("line", st.x,st.y+st.offset,st.w,st.h)
		end
	end
end



function traps:main(table,dt)
	if editing then return end
	for _, st in pairs(table) do
		st.cycle = math.max(0, st.cycle - dt)
		
		if st.cycle <= 0 then
			st.cycle = st.delay
			st.active = not st.active
		end
	end
end
