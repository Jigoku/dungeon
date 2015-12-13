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
 
hud = {}

hud.w = 600
hud.h = 45
hud.scale = 1
hud.texture = love.graphics.newImage("data/textures/rocky.png")
hud.texture:setWrap("repeat", "repeat")
hud.quad = love.graphics.newQuad( 0,0, hud.w, hud.h, hud.texture:getDimensions() )
hud.canvas = love.graphics.newCanvas( hud.w, hud.h)

function hud:draw()
	if editing then
		--editor hud drawn here
		editor:draw()
	else
	--hud canvas
	love.graphics.setCanvas(hud.canvas)
	hud.canvas:clear()
	hud.canvas:setFilter("nearest", "nearest")

	love.graphics.setColor(255,255,255,100)
	love.graphics.draw(hud.texture, hud.quad, 0,0)
	
	love.graphics.setColor(255,255,255,100)
	love.graphics.rectangle("line", 0,0,hud.canvas:getWidth(),hud.canvas:getHeight() )
	--hud health bar 
	--behind
	love.graphics.setColor(205,0,0,55)
	love.graphics.rectangle("fill", 10,10,player.maxhealth,10)
	--health value
	love.graphics.setColor(150,0,0,255)
	love.graphics.rectangle("fill", 10,10,player.health,10)
	--outline
	love.graphics.setColor(100,100,100,255)
	love.graphics.rectangle("line", 10,10,player.maxhealth,10)
	
	
	--hud mana bar 
	--behind
	love.graphics.setColor(205,0,205,55)
	love.graphics.rectangle("fill", 10,25,player.maxmana,10)
	--health value
	love.graphics.setColor(100,0,155,255)
	love.graphics.rectangle("fill", 10,25,player.mana,10)
	--outline
	love.graphics.setColor(100,100,100,255)
	love.graphics.rectangle("line", 10,25,player.maxmana,10)
	
	
	--coins
	love.graphics.setColor(100,100,100,255)
	love.graphics.print(player.coins .. " COIN"..(player.coins == 1 and "" or "S"), 120,8)
	
	--lives
	local offset = 0
	for life=1,player.lives do
		love.graphics.setColor(100,0,0,255)
		love.graphics.rectangle("fill",120+offset,25, 10,10)
		offset = offset +15
	end
	
	--weaponslots
	local offset = 0
	for slot=1,10 do
		if player.weaponslot == slot then	
			love.graphics.setColor(100,100,100,50)
			love.graphics.rectangle("fill", 220+offset,10,25,25)
			
			love.graphics.setColor(200,200,200,255)
			love.graphics.rectangle("line", 220+offset,10,25,25)
		else			
			love.graphics.setColor(100,100,100,255)
			love.graphics.rectangle("line", 220+offset,10,25,25)
		end
		

		
		local icon = projectiles:slot2icon(slot)
		if type(icon) == "userdata" then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(icon,220+offset, 10)
		end
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(slot, 220+offset,10)
		
		offset = offset + 30
	end
	
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	
	love.graphics.draw(hud.canvas, WIDTH/2-(hud.w*hud.scale)/2,HEIGHT-(hud.h*hud.scale)-(5*hud.scale),0,hud.scale)
	end
end
