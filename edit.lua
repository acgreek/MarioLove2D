require "subclass/requires.lua"
require "subclass/class.lua"
edit = class:new()

sWidth, sHeight = 1280, 640
lMode = 'line'
rMode = 'line'

grid = {}
for i=0, 480 do
  grid[i] = {}
end

editing = {}
editing.menu = {}

function edit:init() 

  --initial graphics setup
  love.graphics.setBackgroundColor(104, 136, 248)
  love.graphics.setMode(sWidth, sHeight, false, false, 0)
  
  --create some variables
  world = love.physics.newWorld(0,0,15360,640)
  world:setGravity(0, 700)
  world:setMeter(64)
  world:setMeter(64)
  screenX = 0 --screen x position relative to the left edge
  mouse = {}
  objects = {}

  self:generateMaterials()

  for i=1, 2 do
    editing.menu[i] = {}
  end
  editing.menu[1].string = "Width: "
  editing.menu[2].string = "Height: "

end

function edit:generateMaterials()
  grid[10][0] = ground_controller:new(32 * 10, 0, 1, 1)
  grid[11][0] = empty_controller:new(32 * 11, 0, 1, 1)
end

function edit:mousepressed(x, y, button)
  if button == 'l' then
    if mouse.indexY == 0 then
      insertObject = grid[(mouse.x - math.fmod(mouse.x, 32))/32][mouse.indexY]
    elseif insertObject ~= nil then
      editing.object = nil
      grid[mouse.indexX][mouse.indexY] = insertObject:new(mouse.drawX + screenX, mouse.drawY, 1 ,1)
    end
  elseif button == 'm' then
    if mouse.indexY > 0 then
      editing.object = grid[mouse.indexX][mouse.indexY]
      if editing.object ~= nil then
	editing.x = mouse.drawX
	editing.y = mouse.drawY
	editing.screenX = screenX
	editing.index = 1
	editing.menu[1].value = grid[mouse.indexX][mouse.indexY]:getWidth()
	editing.menu[2].value = grid[mouse.indexX][mouse.indexY]:getHeight()
      end
    end
  elseif button == 'r' then
    if mouse.indexY > 0 then
      grid[mouse.indexX][mouse.indexY] = nil
    end
  end
end

function edit:keypressed(key, unicode)
	print("key pressed " .. key .. "\n");
  if key == 'escape' then
    editing.object = nil
  end
  if editing.object ~= nil then
    if key == 'down' then
      if editing.index < #editing.menu then
	editing.index = editing.index + 1
      end
    elseif key == 'up' then
      if editing.index > 1 then
	editing.index = editing.index - 1
      end
    elseif key == 'return' then
      self:applyNumber()
    elseif key == 'kp+' then
      editing.menu[editing.index].value = editing.menu[editing.index].value + 1
      self:applyNumber()
    elseif key == 'kp-' then
      editing.menu[editing.index].value = editing.menu[editing.index].value - 1
      self:applyNumber()
    elseif tonumber(key) ~= nil then
      if editing.menu[editing.index].value == nil or tonumber(editing.menu[editing.index].value) == editing.object:get(editing.index) then
	editing.menu[editing.index].value = ""
      end
      editing.menu[editing.index].value = editing.menu[editing.index].value..key
    end
  end
end

function edit:applyNumber()
  if editing.index == 1 then
	editing.object:setWH(tonumber(editing.menu[editing.index].value),editing.object:getHeight())
      elseif editing.index == 2 then
	editing.object:setWH(editing.object:getWidth(),tonumber(editing.menu[editing.index].value))
      end
end

function edit:draw()
  local temp = screenX
  for i=0, 480 do
    for j=0, 20 do
      if j == 0 then screenX = 0 else screenX = temp end
      if grid[i][j] ~= nil and grid[i][j].draw then
	grid[i][j]:draw()
      end
    end
  end
  screenX = temp

  love.graphics.print(mouse.indexX, 32, 32)
  
  --draw editing menu
  if editing.object ~= nil then
    local drawX = editing.x - (screenX - editing.screenX)
    love.graphics.rectangle('fill', drawX + 32, editing.y - 128, 128, 128)
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle('fill', drawX + 32, editing.y - 128, 128, 32)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Editing Menu", drawX + 55, editing.y - 110)
    self:drawMenu(drawX)
    love.graphics.setColor(255,255,255)
  end
  

  --draw small white square
  if mouse.drawY > 0 then
    love.graphics.rectangle('line', mouse.drawX, mouse.drawY, 32, 32)
  end
end

function edit:drawMenu(drawX)
  if editing.index == 1 then
    love.graphics.setColor(255,0,0)
  end
  love.graphics.print(editing.menu[1].string..tostring(editing.menu[1].value), drawX + 55, editing.y - 110 + 32 * 1)
  if editing.index == 2 then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(0,0,0)
  end
  love.graphics.print(editing.menu[2].string..tostring(editing.menu[2].value), drawX + 55, editing.y - 110 + 32 * 2)
  love.graphics.setColor(255,255,255)
end

function edit:update(dt)
  mouse.x, mouse.y = love.mouse.getPosition()
  mouse.drawX = mouse.x - math.fmod(mouse.x + math.fmod(screenX, 32), 32)
  mouse.drawY = mouse.y - math.fmod(mouse.y, 32)
  mouse.indexX = (mouse.drawX + screenX) / 32
  mouse.indexY = mouse.drawY / 32
  if love.keyboard.isDown('left') then
    screenX = screenX - 300 * dt
  end
  if love.keyboard.isDown('right') then
    screenX = screenX + 300 * dt
  end

  if screenX < 0 then
    screenX = 0
  end
end
