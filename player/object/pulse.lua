require "subclass/class.lua"
pulse = class:new()

pulse.radius = 20

function pulse:init(x, y ) 
  self.body = love.physics.newBody(world, x, y)
  self.shape = love.physics.newCircleShape(self.body, 0, 0,10)
  self.shape:setData(sdata:new())
  self.isOffScreen = false
  self:setData()
end

function pulse:update(dt)
	local nx = self.body:getX()-screenX
	local ny = self.body:getY()
	if (nx < -10 or nx> (650+10) or ny < -10  or ny > (650 +10)) then 
		self.isOffScreen =True;
	end
	
end
function pulse:setData()
  self.shape:getData():setShape(self.shape)
  self.shape:getData():setBody(self.body)
  self.shape:getData():setString("pulse")
  self.shape:getData():setIsLethal(false)
  self.shape:getData():setObject(self)
  self.shape:getData():setWidth(self.radius*2)
  self.shape:getData():setHeight(self.radius*2)
end
function pulse:collide(shapeData)
end

function pulse:draw()
	local r, g, b = love.graphics.getColor() --set the drawing color to red for the ball
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", self.body:getX()-screenX, self.body:getY(),self.shape:getRadius(),self.shape:getRadius() ) -- we want 20 line segments to form the "circle"
	love.graphics.setColor(r, g, b) --set the drawing color to red for the ball

end


