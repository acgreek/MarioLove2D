require "subclass/class.lua"
require "plugins/empty.lua"
moveBrick = class:new()

function moveBrick:init(x, y, table, index)
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
  self.empty = {}
  self.moving = false
end

function moveBrick:setData()
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("moveBrick")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(32)
  self.shape:getData():setHeight(32)
  self.shape:getData():setIsJumpable(true)
end

function moveBrick:collide(shapeData)
  self.moving = true
  shapeData:getObject():collide(self.shape:getData())
end

function moveBrick:update(dt)
  self.xPos, self.yPos = self.body:getPosition()
  if self.moving then
    self.body:setPosition(self.xPos + 2, self.yPos)
    if math.fmod(self.xPos - self.x, 32) == 0 then
      self.empty[#self.empty + 1] = empty:new(self.xPos - 16, self.yPos - 16)
    end
  end
end

function moveBrick:draw()
  for i=1, #self.empty do
    self.empty[i]:draw()
  end
  love.graphics.draw(self.image, self.body:getX() - 16 - screenX, self.body:getY() - 16)
end