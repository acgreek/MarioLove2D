require "subclass/class.lua"
ball = class:new() 

function ball:init(x, y)
  self.body = love.physics.newBody(world, x + 16, y + 16)
  self.shape = love.physics.newCircleShape(self.body, 0, 0, 16)
  self.shape:setData(sdata:new())
  self.body:setMassFromShapes()
  self.image = love.graphics.newImage("media/img/gfx/s1.png")
  self:setData()
end

function ball:update(dt)
  local ballX, ballY = self.body:getLinearVelocity()
  if self.body:getY() > 700 then
    self.body:setY(0)
  end
  if ballY > 500 then
    self.body:setLinearVelocity(ballX, 500)
  end

end

function ball:setData()
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setBody(self.body)
  self.shape:getData():setString("ball")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setHeight(32)
  self.shape:getData():setWidth(32)
  self.shape:getData():setIsJumpable(false)
end

function ball:draw()
  love.graphics.draw(self.image, self.body:getX() - 16 - screenX, self.body:getY() - 16)
end