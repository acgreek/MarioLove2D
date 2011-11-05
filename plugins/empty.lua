require "subclass/class.lua"
empty = class:new() 

function empty:init(x, y)
  self.x = x
  self.y = y
  self.body = love.physics.newBody(world, self.x + 16, self.y + 16)
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, 32, 32)
  --self.body:setMassFromShapes()
  self.shape:setData(sdata:new())
  self:setData()
  self.image = love.graphics.newImage("media/img/gfx/empty.png")
  self.table = table
  self.index = index
end

function empty:setData()
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("empty")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(32)
  self.shape:getData():setHeight(32)
  self.shape:getData():setIsJumpable(true)
end

function empty:draw()
    love.graphics.draw(self.image, self.body:getX() - 16 - screenX, self.body:getY() - 16)
end

function empty:collide(shapeData)
  shapeData:getObject():collide(self.shape:getData())
end