require "subclass/class.lua"
brick = class:new()

function brick:init(x, y, table, index)
  self.x = x
  self.y = y
  self.body = love.physics.newBody(world, x + 16, y + 16)
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, 32, 32)
  --self.body:setMassFromShapes()
  self.shape:setData(sdata:new())
  self:setData()
  self.image = love.graphics.newImage("media/img/gfx/6.png")
  self.table = table
  self.index = index
end

function brick:setData()
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("brick")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(32)
  self.shape:getData():setHeight(32)
  self.shape:getData():setIsJumpable(true)
end

function brick:collide(shapeData)
  if shapeData:getString() == "mario" and self.body ~= nil then
    if shapeData:getBody():getY() > self.body:getY() + 10 then
      shapeData:getObject():play("brick")
      self:explode()
    else
      shapeData:getObject():collide(self.shape:getData())
    end
  end
end


function brick:explode()
  self.body:setY(800)
  --add shape and body to destroy list
  destroyList[#destroyList + 1] = {}
  destroyList[#destroyList].object = self.shape
  destroyList[#destroyList].time = love.timer.getTime()
  destroyList[#destroyList + 1] = {}
  destroyList[#destroyList].object = self.body
  destroyList[#destroyList].time = love.timer.getTime()
  self.body = nil
  self.shape = nil
  --add four small bricks
  self.bricklet = {}
  self.bricklet.image = love.graphics.newImage("media/img/gfx/brick-bit.png")
  self.bricklet[1] = {}
  self.bricklet[1].body = love.physics.newBody(dieWorld, self.x + 8, self.y + 8, 100)
  self.bricklet[1].body:setAngularVelocity(-6)
  self.bricklet[1].shape = love.physics.newRectangleShape(self.bricklet[1].body, 0, 0, 16, 16)
  self.bricklet[1].body:setLinearVelocity(-25, -100)
  self.bricklet[2] = {}
  self.bricklet[2].body = love.physics.newBody(dieWorld, self.x + 40, self.y + 8)
  self.bricklet[2].body:setAngularVelocity(6)
  self.bricklet[2].shape = love.physics.newRectangleShape(self.bricklet[2].body, 0, 0, 16, 16)
  self.bricklet[2].body:setLinearVelocity(25, -100)
  self.bricklet[2].body:setMassFromShapes()
  self.bricklet[3] = {}
  self.bricklet[3].body = love.physics.newBody(dieWorld, self.x + 8, self.y + 40)
  self.bricklet[3].body:setAngularVelocity(-6)
  self.bricklet[3].shape = love.physics.newRectangleShape(self.bricklet[3].body, 0, 0, 16, 16)
  self.bricklet[3].body:setLinearVelocity(-100, 0)
  self.bricklet[3].body:setMassFromShapes()
  self.bricklet[4] = {}
  self.bricklet[4].body = love.physics.newBody(dieWorld, self.x + 40, self.y + 40)
  self.bricklet[4].body:setAngularVelocity(6)
  self.bricklet[4].shape = love.physics.newRectangleShape(self.bricklet[4].body, 0, 0, 16, 16)
  self.bricklet[4].body:setLinearVelocity(100, 0)
  self.bricklet[4].body:setMassFromShapes()
end

function brick:draw()
  if self.body ~= nil then
    love.graphics.draw(self.image, self.body:getX() - 16 - screenX, self.body:getY() - 16)
  else
    for i=1, 4 do
      love.graphics.draw(self.bricklet.image, self.bricklet[i].body:getX() - 8 - screenX, self.bricklet[i].body:getY() - 8, self.bricklet[i].body:getAngle())
    end
  end
end