require "plugins/ground.lua"
require "subclass/class.lua"
ground_controller = class:new() 

function ground_controller:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.ground = ground:new(x, y, width * 32, height * 32)
end

function ground_controller:draw()
  self.ground:draw()
end

function ground_controller:setWH(width, height)
  self:init(self.x, self.y, width, height)
end

function ground_controller:getWidth()
  return self.width
end

function ground_controller:getHeight()
  return self.height
end

function ground_controller:get(index)
  if index == 1 then
    return self.width
  elseif index == 2 then
    return self.height
  end
end