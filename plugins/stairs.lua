require "subclass/class.lua"
stairs = class:new() 

function stairs:init(x, y, width, support, direction)
  self.x = x
  self.y = y
  self.width = width --width of entire entity
  self.support = support --height of support
  self.direction = direction --direction stairs are facing (right/left)
  self.body = {}
  self.shape = {}
  self.image = self:generate()
end

function stairs:generate()
  local texture = love.image.newImageData("media/img/gfx/5.png")
  local image = love.image.newImageData(self.width * 32, self.width * 32 + self.support * 32)
  for i=0, self.width - 1 do --row
    for j=0, i do --column
      if self.direction == right then
	if j > 0 then
	  self.body[#self.body + 1] = love.physics.newBody(world, (j * 32 + 16) + self.x, (i * 32 + 16) + self.y)
	end
	image:paste(texture, j * 32, i * 32, 0, 0, 32, 32)
      elseif self.direction == left then
	if j > 0 then
	  self.body[#self.body + 1] = love.physics.newBody(world, ((self.width - j - 1) * 32 + 16) + self.x, (i * 32 + 16) + self.y)
	end
	image:paste(texture, (self.width - j - 1) * 32, i * 32, 0, 0, 32, 32) 
      end
    if j > 0 then
      self.shape[#self.shape + 1] = love.physics.newRectangleShape(self.body[#self.body], 0, 0, 32, 32)
      self:setData(self.shape[#self.shape], self.body[#self.body], 32, 32)
    end
    end
  end
  --create the side wall
  if self.direction == right then
    self.body[#self.body + 1] = love.physics.newBody(world, self.x + 16, self.y + (self.width * 32) / 2 + (self.support * 32) / 2)
    self.shape[#self.shape + 1] = love.physics.newRectangleShape(self.body[#self.body], 0, 0, 32, self.width * 32 + self.support * 32)
    self:setData(self.shape[#self.shape], self.body[#self.body], 32, self.width * 32 + self.support * 32)
  else
    self.body[#self.body + 1] = love.physics.newBody(world, self.x + self.width * 32 - 16, self.y + (self.width * 32) / 2 + (self.support * 32) / 2)
    self.shape[#self.shape + 1] = love.physics.newRectangleShape(self.body[#self.body], 0, 0, 32, self.width * 32 + self.support * 32)
    self:setData(self.shape[#self.shape], self.body[#self.body], 32, self.width * 32 + self.support * 32)
  end

  --create the support
  if self.support ~= 0 then
    self.body[#self.body + 1] = love.physics.newBody(world, (self.x + ((self.width - 1) * 32) / 2) + 32, self.y + (self.width * 32) + (self.support * 32) / 2)
    self.shape[#self.shape + 1] = love.physics.newRectangleShape(self.body[#self.body], 0, 0, ((self.width - 1) * 32), (self.support * 32))
    self:setData(self.shape[#self.shape], self.body[#self.body], self.width * 32, self.support * 32)
  end
  for i=0, self.support do --row
    for j=0, self.width do --column
      image:paste(texture, j * 32, i * 32  + self.width * 32, 0, 0, 32, 32)
    end
  end
  return love.graphics.newImage(image)
end

function stairs:setData(shape, body, width, height)
  shape:setData(sdata:new())
  shape:getData():setBody(body)
  shape:getData():setShape(shape)
  shape:getData():setString("stairs")
  shape:getData():setIsLethal(false)
  shape:getData():setObject(self)
  shape:getData():setHeight(height)
  shape:getData():setWidth(width)
  shape:getData():setIsJumpable(true)
end

function stairs:draw()
  love.graphics.draw(self.image, self.x - screenX, self.y)
end