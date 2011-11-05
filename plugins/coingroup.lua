require "subclass/class.lua"
require "plugins/coin.lua"
coinGroup = class:new()  

function coinGroup:init(x, y, width, height)
  
  self.coins = {}

  for i=0, width - 1 do
    for j=0, height - 1 do
      self.coins[#self.coins + 1] = coin:new(x + i * 32, y + j * 32)
    end
  end

end

function coinGroup:update(dt)
  for i=1, #self.coins do
    self.coins[i]:update(dt)
  end
end

function coinGroup:draw()
  for i=1, #self.coins do
    self.coins[i]:draw()
  end
end