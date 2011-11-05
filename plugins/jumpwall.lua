require "subclass/class.lua"
jumpWall = class:new() 

function jumpWall:init(x,y,width,height)
  self.x = x
  self.y = y
  self.body = love.physics.newBody(world, x + width * 16, y + height * 16)
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, width * 32, height * 32)
  self.image = self:generateTexture(width * 32, height * 32)
  self:setData(width * 32, height * 32)
end

function jumpWall:setData(width, height)
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("jumpWall")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(width)
  self.shape:getData():setHeight(height)
  self.shape:getData():setIsJumpable(true)
end

function jumpWall:generateTexture(width, height)
  local texture = love.image.newImageData("media/img/gfx/5.png")
  local image = love.image.newImageData(width, height)
  for i=0, width/32 - 1 do
    for j=0, height/32 do
      image:paste(texture, i * 32, j * 32, 0, 0, 32, 32)
    end
  end
  return love.graphics.newImage(image)
end

function jumpWall:collide(shapeData)
  if shapeData.getString then
    if shapeData:getString() == "mario" then
      local marioX, marioY = shapeData:getBody():getLinearVelocity() --keep mario from bouncing
    end
  end
end

function jumpWall:draw()
  love.graphics.draw(self.image, self.x - screenX, self.y)
end

function jumpWall:getImage()
  return self.image
end

function jumpWall:getBody()
  return self.body
end

function jumpWall:getX()
  return self.x
end

function jumpWall:getY()
  return self.y
end

function jumpWall:getHeight()
  return self.height
end

function jumpWall:getWidth()
  return self.width
end

function jumpWall:getXYWH()
  return self.x, self.y, self.width, self.height
end