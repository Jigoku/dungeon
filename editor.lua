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

editor = {}
editing = false

editor.cursorx = 0
editor.cursory = 0



editor.entsel = 0 --	arena:addwall(100,100,500,200)
editor.dragging = false

function editor:draw()
	love.graphics.setColor(255,20,10,255)
	love.graphics.print("editing",20,20)
	
	self:drawselection()
	self:drawcursor()
	
	
	love.graphics.print("cursorx:"..self.cursorx .." cursory:".. self.cursory,20,40 )
	love.graphics.print("cursorpressedx:"..tostring(self.cursorpressedx) .." cursorpressedy:".. tostring(self.cursorpressedy),20,65 )
	love.graphics.print("cursorreleasedx:"..tostring(self.cursorreleasedx) .."cursorreleasedy:".. tostring(self.cursorreleasedy),20,80 )
end




function editor:drawcursor()
	--cursor
	love.graphics.setColor(255,200,255,255)
	love.graphics.line(
		math.round(self.cursorx,-1),
		math.round(self.cursory,-1),
		math.round(self.cursorx,-1)+10,
		math.round(self.cursory,-1)
	)
	love.graphics.line(
		math.round(self.cursorx,-1),
		math.round(self.cursory,-1),
		math.round(self.cursorx,-1),
		math.round(self.cursory,-1)+10
	)
	love.graphics.print("x,"..self.cursorx .. " y,".. self.cursory, self.cursorx,self.cursory-20,0,0.9)
end

function editor:drawselection()
	--draw an outline when dragging mouse when entsel is one of these types
	if self.dragging then
				love.graphics.setColor(0,255,255,100)
				love.graphics.rectangle(
					"line", 
					self.cursorpressedx,self.cursorpressedy, 
					self.cursorx-self.cursorpressedx, self.cursory-self.cursorpressedy
				)

	end
end

function editor:main(dt)

end

function editor:mousepressed(x,y,button)
	--zoom camera
	self.cursorpressedx =math.round(camera.x-(WIDTH/2*camera.scaleX)+x*camera.scaleX,-1)
	self.cursorpressedy = math.round(camera.y-(HEIGHT/2*camera.scaleY)+y*camera.scaleY,-1)
	
	
	
	local scaleX,scaleY
	if button == "wu" then 
		if camera.scaleX > 0.2 then
			camera:scale(-0.1,-0.1)
		else
			camera:setScale(0.1,0.1)
		end
	end
	if button == "wd" then 
		if camera.scaleX < 4 then
			camera:scale(0.1,0.1)
		else
			camera:setScale(4,4)
		end
	end
		
	if button == "l" then
		self.dragging = true
	end
end


function editor:mousereleased(x,y,button)
	self.cursorreleasedx = math.round(camera.x-(WIDTH/2*camera.scaleX)+x*camera.scaleX,-1)
	self.cursorreleasedy = math.round(camera.y-(HEIGHT/2*camera.scaleY)+y*camera.scaleY,-1)
	
	if button == "l" then	
		self.dragging = false
		arena:addwall(
					self.cursorpressedx,self.cursorpressedy, 
					self.cursorx-self.cursorpressedx, self.cursory-self.cursorpressedy
		)
	end
end

function editor:mousemoved(x,y)
	self.cursorx = math.round(camera.x-(WIDTH/2*camera.scaleX)+x*camera.scaleX,-1)
	self.cursory = math.round(camera.y-(HEIGHT/2*camera.scaleY)+y*camera.scaleY,-1)
end
