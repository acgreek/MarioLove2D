require "menu.lua"
require "subclass/padding.lua"
require "edit.lua"

sWidth, sHeight = 1280, 640
local screenSpeed = 0
menuItems = {}
object = {} --this is what gets called into action, whether that be the game, level editor, whatever...

function love.load()
  if love.filesystem.isFile("res") then
    file = love.filesystem.newFile("res")
    file:open('r')
    data = file:read()
    file:close()
  
    if data ~= '' and data ~= nil then
      sWidth = tonumber(data)
    end
  end

  --initial graphics setup
  love.graphics.setBackgroundColor(104, 136, 248)
  love.graphics.setMode(sWidth, sHeight, false, false, 0)
  
  object = menu:new()
  
end

function love.update(dt)
  if object.update then
    object:update(dt)
  end
end

function love.draw()
  if object.draw then
    object:draw()
  end
end

function love.keypressed(key, unicode)
  if object.keypressed then
    object:keypressed(key, unicode)
  end
end

function love.keyreleased(key)
  if object.keyreleased then
    object:keyreleased(key)
  end
end

function love.mousepressed(x, y, button)
  if object.mousepressed then
    object:mousepressed(x, y, button)
  end
end

function love.mousereleased(x, y, button)
  if object.mousereleased then
    object:mousereleased(x, y, button)
  end
end

function add(shape1, shape2, collision)
  local sString1, sString2 = nil, nil

  if shape1.getString then
    sString1 = shape1:getString()
  end
  if shape2.getString then
    sString2 = shape2:getString()
  end
  if (sString1 == "pulse" or sString2 == "pulse") then 
	  return;
  end

  if sString1 == "brick" then
    shape1:getObject():collide(shape2)
  elseif sString2 == "brick" then
    shape2:getObject():collide(shape1)
  else
    if shape1.getObject then
      if shape1:getObject().collide then
	shape1:getObject():collide(shape2)
      end
    end
    if shape2.getObject then
      if shape2:getObject().collide then
	shape2:getObject():collide(shape1)
      end
    end
  end

end

function persist(shape1, shape2, collision)
  if shape1.getObject then
    if shape1:getObject().persist then
      shape1:getObject():persist(shape2)
    end
  end
  if shape2.getObject then
    if shape2:getObject().persist then
      shape2:getObject():persist(shape1)
    end
  end
end

function remove(shape1, shape2, collision)
  if shape1.getObject then
    if shape1:getObject().remove then
      shape1:getObject():remove(shape2)
    end
  end
  if shape2.getObject then
    if shape2:getObject().remove then
      shape2:getObject():remove(shape1)
    end
  end
end
