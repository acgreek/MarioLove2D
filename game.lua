require "subclass/AnAL.lua"
require "plugins/goomba.lua"
require "player/mario.lua"
require "subclass/shapeData.lua"
require "subclass/sfx.lua"
require "levels/1.lua"
require "subclass/class.lua"
game = class:new()

left, right = {}, {}

function game:init()

  self:newWorlds()
  screenX = 0 --screen x position relative to the left edge
  destroyList = {} --place items in this list to be destroyed
  --load level
  level = lvl1:new()

  --sprites array (basically, so multiplayer can be easily implemented in the future)
  player = {}
  player[1] = mario:new("up","down","left","right") --create player 1
  --player[2] = mario:new("w", "s", "a", "d")

end

function game:mousepressed(x, y, button)

end

function game:reloadLevel()
	self:newWorlds()
	level = lvl1:new()
end

function game:newWorlds()
  --create some variables
  world = love.physics.newWorld(0,0, 15360,640)
  world:setGravity(0, 700)
  world:setCallbacks(add, persist, remove)
  world:setMeter(64)
  world:setMeter(64)
  dieWorld = love.physics.newWorld(0,0,15360,800)
  dieWorld:setGravity(0, 700)
end

function game:update(dt)

  world:update(dt)
  dieWorld:update(dt)
  for i=1, #player do
    player[i]:update(dt)
  end
  level:update(dt)

  --handle screen position
  if player[1]:getBody():getX() > (sWidth * .8) + screenX then
    screenX = player[1]:getBody():getX() - sWidth * .8
  elseif player[1]:getBody():getX() < (sWidth * .2) + screenX then
    screenX = player[1]:getBody():getX() - sWidth * .2
  end

  if screenX < 0 then
    screenX = 0
  end

  --clean destroy list
  for i=1, #destroyList do
    if destroyList[i].time < love.timer.getTime() + 100 then
      destroyList[i].object:destroy()
      destroyList[i] = nil
    end
  end

  if love.keyboard.isDown('q') then --quit the game
    os.exit()
  end

end

function game:draw()


  --draw mario
  for i=1, #player do
    player[i]:draw()
  end

  level:draw()

  love.graphics.setColor(255,255,255)
  for i=1, #player do
	love.graphics.print("Player: "..i, 20, 32*i)
	love.graphics.print("Lives: "..player[i]:getLives(), 100, 32*i)
	love.graphics.print("Coins: "..player[i]:getCoins(), 200, 32*i)
  end

end

function game:keypressed(key, unicode)

  --local marioX, marioY = player[1]:getBody():getLinearVelocity()
  for i=1, #player do
    player[i]:keyPressed(key)
  end

  --change width
  if key == "1" then
    sWidth = sWidth - 32
    love.graphics.setMode(sWidth, sHeight, false, false, 0)
    file = love.filesystem.newFile("res")
    file:open('w')
    file:write(sWidth)
    file:close()
  elseif key == "2" then
    sWidth = sWidth + 32
    love.graphics.setMode(sWidth, sHeight, false, false, 0)
    file = love.filesystem.newFile("res")
    file:open('w')
    file:write(sWidth)
    file:close()
  end

end

function getabs(number)
  return (number < 0 and -number or number)
end
