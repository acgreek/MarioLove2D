require "subclass/class.lua"
require "subclass/sfx.lua"
mario = class:new()
local sfx = soundfx:new()

local tempRight = love.graphics.newImage("media/img/mario/run-right.png")
local tempLeft = love.graphics.newImage("media/img/mario/run-left.png")

local marioStandRight = love.graphics.newImage("media/img/mario/stand-right.png")
local marioStandLeft = love.graphics.newImage("media/img/mario/stand-left.png")
local marioRunRight = newAnimation(tempRight, 32, 32, .1, 3)
local marioRunLeft = newAnimation(tempLeft, 32, 32, .1, 3)
local marioJumpRight = love.graphics.newImage("media/img/mario/jump-right.png")
local marioJumpLeft = love.graphics.newImage("media/img/mario/jump-left.png")

local left = {}
local right = {}

mario.coins = 0 --number of coins
mario.lives = 3

function mario:init(up, down, left, right)
  self.body = love.physics.newBody(world, 100 , 500,10,0)
  self.shape = love.physics.newCircleShape(self.body,0,0,12)
  self.direction = right --direction mario is facing
  self.canJump = false --can mario jump
  self.maxSpeed = 600 --mario's max running speed
  self.image = marioStandRight
  local newdata = sdata:new()
  self.shape:setData(newdata)
  self.animSpeed = 1
  self.jumpWall = nil
  self:setData()
  self.key = {}
  self.key.up = up
  self.key.down = down
  self.key.left = left
  self.key.right = right
  self.dead = false
end

function mario:collide(shapeData)
  local sHeight = shapeData:getHeight()
  local sWidth = shapeData:getWidth()
  local sX = shapeData:getBody():getX()
  local sY = shapeData:getBody():getY()
  local bHeight = self.shape:getData():getHeight()
  local bWidth = self.shape:getData():getWidth()
  local bX = self.body:getX()
  local bY = self.body:getY()
  --is it below?
  
  if sY > self.body:getY() and sY - sHeight / 2 >= bY + bHeight / 2 - 5 and sX - sWidth / 2 < bX + bWidth / 2 and sX + sWidth / 2 > bX - bWidth / 2 and shapeData:getIsJumpable() then
    self.canJump = true
    self.jumpWall = nil
  --is it to the left?
  elseif sX < self.body:getX() and not self.canJump and sHeight > 32 then
    self.jumpWall = right
  --is it to the right?
  elseif sX > self.body:getX() and not self.canJump and sHeight > 32 then
    self.jumpWall = left
  end
end

function mario:draw()
  local newX = self.body:getX() - screenX
 
  if self.canJump then
    if self.xVel > -0.1 and self.xVel < 0.1 then
      if self.direction == right then
	self.image = marioStandRight
      else
	self.image = marioStandLeft
      end
      love.graphics.draw(self.image, newX, self.body:getY(),0,1,1,16,20)
    else
      if self.direction == right then
	self.animation = marioRunRight
      else
	self.animation = marioRunLeft
      end
      self.animation:draw(newX-18,self.body:getY()-20)
    end
  else
    if self.direction == right then
      self.image = marioJumpRight
    else
      self.image = marioJumpLeft
    end
    love.graphics.draw(self.image, newX, self.body:getY(),0,1,1,16,20)
  end
    
	if self.dead then
		love.graphics.print("Press Enter to continue", sWidth / 2, 20)
	end
	
end

function mario:kill()
  sfx:play("die")
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
  self.body:setLinearVelocity(0,0)
  self.dead = true
end

function mario:destroy(obj)
  destroyList[#destroyList + 1] = {}
  destroyList[#destroyList].object = obj
  destroyList[#destroyList].time = love.timer.getTime()
end

function mario:getBody()
  return self.body
end

function mario:getCanJump()
  return self.canJump
end

function mario:getImage()
  return self.image
end

function mario:getShape()
  return self.shape
end

function mario:setX(newX)
  self.body:setX(newX)
end

function mario:setY(newY)
  self.body:setY(newY)
end

function mario:addCoins(num)
  self.coins = self.coins + num
  while self.coins >= 100 do
	self.coins = self.coins - 100
	self.lives = self.lives + 1
	self:play("1up")
  end
end

function mario:getLives()
  return self.lives
end

function mario:getCoins()
  return self.coins
end

function mario:setData()
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setBody(self.body)
  self.shape:getData():setString("mario")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setHeight(32)
  self.shape:getData():setWidth(32)
  self.shape:getData():setIsJumpable(true)
end

function mario:setCanJump(newCanJump)
  self.canJump = newCanJump
end

function mario:setDirection(newDirection)
  self.direction = newDirection
end

function mario:jump()
  local impulse
  
  if self.dead then
    return
  end

  self.xVel, self.yVel = self.body:getLinearVelocity()

  --set the jump height depending on speed
  if math.abs(self.xVel) > 600 then
    impulse = 125
  else
    impulse = 105
  end

  if self.jumpWall == nil then --regular jump
    if self.canJump then
      self.body:applyImpulse(0, -impulse)
      self.canJump = false
      self:play("jumpsmall")
    end
  else
    if self.jumpWall == left then --wall jump to the right
      --if love.keyboard.isDown("right") then
	self.direction = left
	self.body:setLinearVelocity(-500, -700)
	self.canJump = false
	self:play("jumpsmall")
      --end
    else --wall jump to the left
      --if love.keyboard.isDown("left") then
	self.direction = right
	self.body:setLinearVelocity(500, -700)
	self.canJump = false
	self:play("jumpsmall")
      --end
    end
    self.jumpWall = nil
  end

  if self.xVel > 0 then
    self.jumpDirection = right
  elseif self.xVel < 0 then
    self.jumpDirection = left
  else
    self.jumpDirection = nil
  end

end

function mario:keyPressed(key)
  if key == self.key.up then
    self:jump()
  end
end

function mario:update(dt)
  if self.dead then
	if love.keyboard.isDown('return') then
		self.lives = self.lives - 1
		game:reloadLevel()
		self:init(self.key.up, self.key.down, self.key.left, self.key.right)
	end
    return
  end

  self.xVel, self.yVel = self.body:getLinearVelocity()
  marioRunRight:update(dt)
  marioRunLeft:update(dt)

  if love.keyboard.isDown(self.key.right) then
    if self.canJump then
	  if self.xVel > -10 and self.xVel < 10 then --fix bug where mario wont move in certain spots
		self.body:setLinearVelocity(50, self.yVel)
	  end
      self.direction = right
      self.body:applyForce(250, 0)
    else
      self.body:applyForce(100, 0)
    end
  elseif love.keyboard.isDown(self.key.left) then
    if self.canJump then
	  if self.xVel > -10 and self.xVel < 10 then --fix bug where mario wont move in certain spots
		self.body:setLinearVelocity(-50, self.yVel)
	  end
      self.direction = left
      self.body:applyForce(-250, 0)
    else
      self.body:applyForce(-100, 0)
    end
  end

  --cap mario's speed
  if self.xVel > self.maxSpeed then
    self.body:setLinearVelocity(self.maxSpeed, self.yVel)
  elseif self.xVel < -self.maxSpeed then
    self.body:setLinearVelocity(-self.maxSpeed, self.yVel)
  end

  --3 different speeds for the animation
  local level1, level2, level3 = .3, .7, 1

  --update the animation speeds (running right)
  if self.xVel > 0.1 and self.xVel < 300 and not marioRunRight:getSpeed() == level1 then
    marioRunRight:setSpeed(level1)
  elseif self.xVel > 300 and self.xVel < 500 and not marioRunRight:getSpeed() == level2 then
    marioRunRight:setSpeed(level2)
  elseif self.xVel > 500 and not marioRunRight:getSpeed() == level3 then
    marioRunRight:setSpeed(level3)
  end

  --update the animations speeds (running left)
  if self.xVel < -0.1 and self.xVel > -300 and not marioRunLeft:getSpeed() == level1 then
    marioRunLeft:setSpeed(level1)
  elseif self.xVel < -300 and self.xVel > -500 and not marioRunLeft:getSpeed() == level2 then
    marioRunLeft:setSpeed(level2)
  elseif self.xVel < -500 and not marioRunLeft:getSpeed() == level3 then
    marioRunLeft:setSpeed(level3)
  end
  
  --keep mario from disappearing in hole
  if self.body:getY() > 700 then
    --self.body:putToSleep()
    --self.canJump = false
	self:kill()
  end

  --keep mario from going too far left
  if self.body:getX() < 16 then
    self.body:setX(16)
    self.body:setLinearVelocity(0, self.yVel)
  end

  function mario:play(sound)
    sfx:play(sound)
  end

end
