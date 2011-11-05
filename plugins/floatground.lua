require "subclass/class.lua"
floatGround = class:new()  

function floatGround:init(x, y, width, height)
  self.width = width
  self.height = height
  self.body = love.physics.newBody(world, x + width / 2, y + height / 2)
  self.shape = love.physics.newRectangleShape(self.body, 0, 0, width, height)
  self.shape:setData(sdata:new())
  self:setData()
  self.image = self:generateGroundTexture(width, height)
end

function floatGround:setData()
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

function floatGround:generateGroundTexture(width, height)
  local capLeft = love.image.newImageData("media/img/gfx/2.png")
  local top = love.image.newImageData("media/img/gfx/3.png")
  local capRight = love.image.newImageData("media/img/gfx/4.png")
  local bodyLeft = love.image.newImageData("media/img/gfx/9.png")
  local body = love.image.newImageData("media/img/gfx/7.png")
  local bodyRight = love.image.newImageData("media/img/gfx/8.png")
  local bottomCapLeft = love.image.newImageData("media/img/gfx/bot-cap-left.png")
  local bottom = love.image.newImageData("media/img/gfx/bot.png")
  local bottomCapRight = love.image.newImageData("media/img/gfx/bot-cap-right.png")
  local image = love.image.newImageData(width, height)
  for k=0, width/32 do
    for h=0, height/32 - 1 do
      if h == 0 then
	image:paste(top, k * 32, 0, 0, 0, 32, 32)
      elseif h == height/32 - 1 then
	image:paste(bottom, k * 32, h * 32, 0, 0, 32, 32)
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
  image:paste(bottomCapLeft, 0, height - 32, 0, 0, 32, 32)
  image:paste(bottomCapRight, width - 32, height - 32, 0, 0, 32, 32)
  return love.graphics.newImage(image)
end

function floatGround:draw()
  love.graphics.draw(self.image, self.body:getX() - self.width / 2 - screenX, self.body:getY() - self.height / 2)
end