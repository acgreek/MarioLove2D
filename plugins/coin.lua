require "subclass/class.lua"
coin = class:new() 

function coin:init(x, y)
  self.body = love.physics.newBody(world, x + 16, y + 16, 0.1)
  self.body:putToSleep()
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, 32, 32)
  self.shape:setData(sdata:new())
  self:setData()
  local tmpimg = love.graphics.newImage("media/img/gfx/coin.png")
  self.image = newAnimation(tmpimg, 32, 32, .1, 3)
end

function coin:collide(shapeData)
  if shapeData:getString() == "mario"  and self.body ~= nil then
    shapeData:getObject():play("coin")
    shapeData:getObject():addCoins(1)
    self.body:setY(800)
    self.body = nil
    self.shape = nil
  end
end

function coin:update(dt)
  if self.body ~= nil then
    self.image:update(dt)
    self.body:setLinearVelocity(0,0)
    self.body:putToSleep()
  end
end

function coin:setData()
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("coin")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setHeight(32)
  self.shape:getData():setWidth(32)
  self.shape:getData():setIsJumpable(false)
end

function coin:draw()
  if self.body ~= nil then
    self.image:draw(self.body:getX() - 16 - screenX, self.body:getY() - 16)
  end
end