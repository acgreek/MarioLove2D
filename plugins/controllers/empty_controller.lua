require "plugins/empty.lua"
require "subclass/class.lua"
empty_controller = class:new()

function empty_controller:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.empty = {}
  for i=0, width - 1 do
    for j=0, height - 1 do
      self.empty[#self.empty + 1] = empty:new(x + i * 32, y + j * 32)
    end
  end
end

function empty_controller:update(dt)
  for i=1, #self.empty do
    self.empty[i]:update(dt)
  end
end

function empty_controller:draw()
  for i=1, #self.empty do
    self.empty[i]:draw()
  end
end

function empty_controller:setWH(width, height)
  self:init(self.x, self.y, width, height)
end

function empty_controller:getWidth()
  return self.width
end

function empty_controller:getHeight()
  return self.height
end

function empty_controller:get(index)
  if index == 1 then
    return self.width
  elseif index == 2 then
    return self.height
  end
end