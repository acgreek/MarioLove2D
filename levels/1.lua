require "subclass/requires.lua"
require "subclass/class.lua"
lvl1 = class:new()

bgm = love.audio.newSource("media/music/overworld.ogg", "stream")

function lvl1:init()

  love.audio.stop(bgm)
  love.audio.play(bgm)
  bgm:setLooping(true)

  self.ground = {}
  self.jumpWall = {}
  self.ball = {}
  self.goomba = {}
  self.stairs = {}
  self.massless = {}
  self.brick = {}
  self.moveBrick = {}
  self.pipe = {}
  self.floatGround = {}
  self.coins = {}

  --ground
  self.ground[#self.ground + 1] = ground:new(-32, 576, 672, 64) --1
  self.ground[#self.ground + 1] = ground:new(704, 608, 352, 32) --2
  self.ground[#self.ground + 1] = ground:new(1152, 608, 256, 32) --3
  self.ground[#self.ground + 1] = ground:new(1408, 384, 640, 256) --4
  self.ground[#self.ground + 1] = ground:new(2148, 608, 1280, 32) --5

  --floating ground
  self.floatGround[#self.floatGround + 1] = floatGround:new(2148, 384, 640, 160)

  self.coins[#self.coins + 1] = coinGroup:new(2788, 416, 8, 3)
  self.coins[#self.coins + 1] = coinGroup:new(2148, 0, 30, 12)

  --pipe
  self.pipe[#self.pipe + 1] = pipe:new(640, 480, 5)

  --brick
  for i=1, 6 do
    self.brick[#self.brick + 1] = brick:new(i * 32 + 275, 480)
  end
  self.brick[#self.brick + 1] = brick:new(1500, 256)
  self.brick[#self.brick + 1] = brick:new(1600, 256)
  self.brick[#self.brick + 1] = brick:new(1700, 256)

  --moveBrick
  self.moveBrick[#self.moveBrick + 1] = moveBrick:new(3388, 500)

  --jumpwall
  self.jumpWall[#self.jumpWall + 1] = jumpWall:new(2788, 384, 8, 1)
  self.jumpWall[#self.jumpWall + 1] = jumpWall:new(3044, 384, 4, 5)
  self.jumpWall[#self.jumpWall + 1] = jumpWall:new(2820, 512, 7, 1)

  --goomba
  self.goomba[#self.goomba + 1] = goomba:new(800, 590)
  self.goomba[#self.goomba + 1] = goomba:new(900, 590)
  self.goomba[#self.goomba + 1] = goomba:new(1500, 0)
  self.goomba[#self.goomba + 1] = goomba:new(1600, 0)
  self.goomba[#self.goomba + 1] = goomba:new(1700, 0)

  --stairs
  self.stairs[#self.stairs + 1] = stairs:new(1184, 384, 7, 0, left)
  
end

function lvl1:update(dt)

  if bgm:isStopped() then
    bgm = love.audio.newSource("media/music/overworld.ogg", "stream")
    love.audio.play(bgm)
  end

  for i=1, #self.ball do
    self.ball[i]:update(dt)
  end

  for i=1, #self.goomba do
    self.goomba[i]:update(dt,i)
  end

  for i=1, #self.coins do
    self.coins[i]:update(dt)
  end
  
  for i=1, #self.moveBrick do
    self.moveBrick[i]:update(dt)
  end

end

function lvl1:drawBG()

end

function lvl1:draw()
  for i=1, #self.coins do
    self.coins[i]:draw()
  end

  for i=1, #self.goomba do
    self.goomba[i]:draw(i)
  end

  for i=1, #self.ground do
    self.ground[i]:draw()
  end

  for i=1, #self.floatGround do
    self.floatGround[i]:draw()
  end

  for i=1, #self.jumpWall do
    self.jumpWall[i]:draw()
  end

  for i=1, #self.ball do
    self.ball[i]:draw()
  end

  for i=1, #self.stairs do
    self.stairs[i]:draw()
  end

  for i=1, #self.pipe do
    self.pipe[i]:draw()
  end

  for i=1, #self.brick do
    self.brick[i]:draw()
  end

  for i=1, #self.moveBrick do
    self.moveBrick[i]:draw()
  end

  for i=1, #self.massless do
    self.massless[i]:draw()
  end

end



