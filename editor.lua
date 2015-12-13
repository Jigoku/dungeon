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

editor.mousex = 0
editor.mousey = 0
editor.mousexpressed = 0
editor.mouseypressed = 0
editor.mousexreleased = 0
editor.mouseyreleased = 0

editor.dragging = false

function editor:draw()
	love.graphics.setColor(255,20,10,255)
	love.graphics.print("editing",20,20)
	
	self:drawselection()
	self:drawcursor()
end

function editor:drawcursor()
	love.graphics.setColor(255,255,255,255)
	love.graphics.line(
		self.mousex-5,
		self.mousey,
		self.mousex+5,
		self.mousey)
	love.graphics.line(
		self.mousex,
		self.mousey-5,
		self.mousex,
		self.mousey+5
	)
	love.graphics.print("x:"..self.mousex .. ",y:"..self.mousey,self.mousex,self.mousey-20,0,0.9)
end

function editor:drawselection()
	--draw an outline when dragging mouse
	if self.dragging then
		love.graphics.setColor(255,255,255,100)
		love.graphics.rectangle(
			"line", 
			self.mousexpressed,self.mouseypressed, 
			self.mousex-self.mousexpressed, self.mousey-self.mouseypressed
		)
	end
end

function editor:main(dt)
	print ("mouse\t",editor.mousex,editor.mousey)
	print ("mousepressed",editor.mousexpressed,editor.mouseypressed)
	print ("mousereleased",editor.mousexreleased,editor.mouseyreleased)
	print("----")
end
