require "subclass/class.lua"
goomba = class:new()

local goombaFlat = love.graphics.newImage("media/img/enemies/goomba-flat.png")

function goomba:init(x, y)
  self.body = love.physics.newBody(world, x, y)
  self.shape = love.physics.newCircleShape(self.body, 0, 0, 16)
  self.shape:setData(sdata:new())
  self.body:setMassFromShapes()
  self.direction = left
  local tmpimg = love.graphics.newImage("media/img/enemies/goomba.png")
  self.image = newAnimation(tmpimg, 32, 32, .35, 2)
  self.isDead = false
  self.deadX = 0
  self.deadY = 0
  self.sleeping = true
  self:setData()
end

function goomba:setData()
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setBody(self.body)
  self.shape:getData():setString("goomba")
  self.shape:getData():setIsLethal(true)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(32)
  self.shape:getData():setHeight(32)
  self.shape:getData():setIsJumpable(true)
end

function goomba:update(dt)
  if self.sleeping then
    if self.body:getX() - 16 < screenX + sWidth then
      self.sleeping = false
      self.body:wakeUp()
    end
  else

    local xVel, yVel = self.body:getLinearVelocity()

    local speed = 50

    if self.direction == left then
      self.body:setLinearVelocity(-speed, yVel)
    elseif self.direction == right then
      self.body:setLinearVelocity(speed, yVel)
    end

    self.image:update(dt)
  end
end

function goomba:kill()
  --throw him in the die world
  self.deadX = self.body:getX()
  self.deadY = self.body:getY()
  self.body:setY(800)
  self:destroy(self.shape)
  self:destroy(self.body)
  self.body = love.physics.newBody(dieWorld, self.deadX, self.deadY)
  self.shape = love.physics.newCircleShape(self.body, 0, 0, 16)
  self.body:setMassFromShapes()
  self.shape:setData(sdata:new())
  self:setData()
end

function goomba:destroy(obj)
  destroyList[#destroyList + 1] = {}
  destroyList[#destroyList].object = obj
  destroyList[#destroyList].time = love.timer.getTime()
end

function goomba:collide(shapeData)
  if shapeData.getString then
    if shapeData:getString() == "mario" then
      if shapeData:getBody():getY() < self.body:getY() - 2 then
	local x, y = shapeData:getBody():getLinearVelocity()
	shapeData:getBody():setLinearVelocity(x, -200) --give mario that jump after he steps on the goomba (realism effect)
	self.shape:getData():setIsLethal(false)
	shapeData:getObject():play("stomp")
	self:kill()
      else
	shapeData:getObject():kill()
      end
    end
  end
  local sHeight = shapeData:getHeight()
  local sWidth = shapeData:getWidth()
  local sX = shapeData:getBody():getX()
  local sY = shapeData:getBody():getY()
  local bHeight = self.shape:getData():getHeight()
  local bWidth = self.shape:getData():getWidth()
  local bX = self.body:getX()
  local bY = self.body:getY()
  --is it below?
  if sY > self.body:getY() and sY - sHeight / 2 >= bY + bHeight / 2 - 5 and sX - sWidth / 2 < bX + bWidth / 2 and sX + sWidth / 2 > bX - bWidth / 2 then
  --nothing
  --is it to the left?
  elseif sX < self.body:getX() and not self.canJump then
    self:switchDirection()
  --is it to the right?
  elseif sX > self.body:getX() and not self.canJump then
    self:switchDirection()
  end
end

function goomba:switchDirection()
  if self.direction == left then
    self.direction = right
  else
    self.direction = left
  end
end

function goomba:draw()
  local newX = self.body:getX() - screenX
  self.image:draw(newX - 16,self.body:getY() - 16)
end

function goomba:getImage()
  return self.image
end

function goomba:getShape()
  return self.shape
end
