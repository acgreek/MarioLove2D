require "subclass/class.lua"
soundfx = class:new() 

function soundfx:init()
  self.sfx_jump_small = love.audio.newSource("media/sfx/jump-small.wav", "static")
  self.sfx_brick = love.audio.newSource("media/sfx/brick.wav", "static")
  self.sfx_stomp = love.audio.newSource("media/sfx/stomp.wav", "static")
  self.sfx_coin = love.audio.newSource("media/sfx/coin.wav", "static")
  self.sfx_die = love.audio.newSource("media/sfx/die.wav", "static")
  self.sfx_1up = love.audio.newSource("media/sfx/1up.wav", "static")
end

function soundfx:play(sound)
  local tempsound
  if sound == "jumpsmall" then
    tempsound = self.sfx_jump_small
  elseif sound == "brick" then
    tempsound = self.sfx_brick
  elseif sound == "stomp" then
    tempsound = self.sfx_stomp
  elseif sound == "coin" then
    tempsound = self.sfx_coin
  elseif sound == "die" then
    tempsound = self.sfx_die
  elseif sound == "1up" then
	tempsound = self.sfx_1up
  end
  love.audio.stop(tempsound)
  love.audio.play(tempsound)
end