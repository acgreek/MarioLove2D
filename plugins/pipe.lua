require "subclass/class.lua"
pipe = class:new()

function pipe:init(x, y, height)
  self.height = height
  self.body = love.physics.newBody(world, x + 32, y + height * 16)
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, 64, height * 32)
  self.shape:setData(sdata:new())
  self:setData()
  self.image = self:generateImage(height)
end

function pipe:generateImage(height)
  local cap = love.image.newImageData("media/img/gfx/pipe-cap.png")
  local tube = love.image.newImageData("media/img/gfx/pipe-tube.png")
  local image = love.image.newImageData(64, height * 32)
  for i=0, height do
    image:paste(tube, 0, i * 32, 0, 0, 64, 32)
  end
  image:paste(cap, 0, 0, 0, 0, 64, 32)
  return love.graphics.newImage(image)
end

function pipe:setData()
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("pipe")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setHeight(self.height * 32)
  self.shape:getData():setWidth(64)
  self.shape:getData():setIsJumpable(true)
end

function pipe:draw()
  love.graphics.draw(self.image, self.body:getX() - 32 - screenX, self.body:getY() - self.height * 16)
end