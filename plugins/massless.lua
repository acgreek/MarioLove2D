require "subclass/class.lua"
massless = class:new()

function massless:init(x, y)
  self.x = x
  self.y = y
  self.image = love.graphics.newImage("media/img/gfx/5.png")
end 

function massless:draw()
  love.graphics.draw(self.image, self.x - screenX, self.y)
end
