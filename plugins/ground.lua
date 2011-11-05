require "subclass/class.lua"
ground = class:new()

function ground:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.body = love.physics.newBody(world, x + width / 2, y + height / 2)
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, width, height)
  self.image = self:generateGroundTexture(width, height)
  self:setData()
end

function ground:setData()
  self.shape:setData(sdata:new())
  self.shape:getData():setBody(self.body)
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setString("ground")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(self.width)
  self.shape:getData():setHeight(self.height)
  self.shape:getData():setIsJumpable(true)
end

function ground:generateGroundTexture(width, height)
  local capLeft = love.image.newImageData("media/img/gfx/2.png")
  local texture = love.image.newImageData("media/img/gfx/3.png")
  local capRight = love.image.newImageData("media/img/gfx/4.png")
  local bodyLeft = love.image.newImageData("media/img/gfx/9.png")
  local body = love.image.newImageData("media/img/gfx/7.png")
  local bodyRight = love.image.newImageData("media/img/gfx/8.png")
  local image = love.image.newImageData(width, height)
  for k=0, width/32 do
    for h=0, height/32 -1 do
      if h == 0 then
	image:paste(texture, k * 32, 0, 0, 0, 32, 32)
      else
	if k == 0 then
	  image:paste(bodyLeft, k * 32, h * 32, 0, 0, 32, 32)
	elseif k == width/32 - 1 then
	  image:paste(bodyRight, k * 32, h * 32, 0, 0, 32, 32)
	else
	  image:paste(body, k * 32, h * 32, 0, 0, 32, 32)
	end
      end
    end
  end
  image:paste(capLeft,0,0,0,0,32,32)
  image:paste(capRight,width-32,0,0,0,32,32)
  return love.graphics.newImage(image)
end

function ground:draw()
  love.graphics.draw(self.image, self.x - screenX, self.y)
end

function ground:getImage()
  return self.image
end

function ground:getBody()
  return self.body
end

function ground:getX()
  return self.x
end

function ground:getY()
  return self.y
end