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
 
function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == binds.debug then debug = not debug end
	
	if not editing then
		if key == binds.pause then paused = not paused end
		if key == " " then reset() loadmap() end
	end
	
	if not paused then
		player:keypressed(key)
	end
end


function love.mousepressed(x, y, button)
	if editing then
		editor:mousepressed(x,y,button)
	end
end


function love.mousereleased(x,y, button)
	if editing then
		editor:mousereleased(x,y,button)
	end
end

function love.mousemoved(x,y,dx,dy)
	if editing then
		editor:mousemoved(x,y)
	end
end
