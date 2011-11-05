require "subclass/class.lua"
require "game.lua"
require "edit.lua"
menu = class:new()

-- hand pointer
local ptrHand = {x = (sWidth / 2) - 32, y = 0, xspd = 32, img = 0}
local startY = sHeight / 2

function menu:init()
	self.items = {}
	self:addItem("Play Game")
	self:addItem("Level Editor")
	self:addItem("Quit")
	self.index = 1

	-- hand pointer image
	ptrHand.img = love.graphics.newImage("media/img/interface/ptrHand.png")
end

function menu:update(dt)
	-- Pointer motion
	ptrHand.x = ptrHand.x + (ptrHand.xspd * dt)
	if ptrHand.x <= (sWidth / 2) - 32 then
		ptrHand.x = (sWidth / 2) - 32
		ptrHand.xspd = ptrHand.xspd * -1
	elseif ptrHand.x >= (sWidth / 2) - 16 then
		ptrHand.x = (sWidth / 2) - 16
		ptrHand.xspd = ptrHand.xspd * -1
	end
end

function menu:draw()
	for i=1, #self.items do
		if i == self.index then
			love.graphics.setColor(64, 64, 64)
		else
			love.graphics.setColor(255, 255, 255)
		end
		love.graphics.print(self.items[i], sWidth / 2, startY + 32 * i)
	end
	
	ptrHand.y = (startY + 32 * self.index) - 12
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(ptrHand.img, ptrHand.x, ptrHand.y, 0, 1, 1, 16, 8)
end

function menu:addItem(text)
  self.items[#self.items + 1] = text
end

function menu:process()
	local text = self.items[self.index]
	if text == "Play Game" then
	  object = game:new()
	elseif text == "Level Editor" then
	  object = edit:new()
	elseif text == "Quit" then
	  os.exit()
	end
end

function menu:keypressed(key, unicode)
	if key == "up" then
		if self.index > 1 then
			self.index = self.index - 1
		end
	elseif key == "down" then
		if self.index < #self.items then
			self.index = self.index + 1
		end
	elseif key == "return" then
		self:process()
	end
end