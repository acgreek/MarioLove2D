require "subclass/class.lua"
require "player/object/pulse.lua"

portal_gun = class:new()

function portal_gun:init() 
	self.mouse ={}
  	self.mouse.x, self.mouse.y = love.mouse.getPosition()
	self.time_till_no_gun_show = os.time()-10
end

function portal_gun:update(dt)
	local x, y = love.mouse.getPosition()
	if (self.mouse.x ~= x or self.mouse.y ~= y) then 
		self.time_till_no_gun_show = os.time() + 2 
	end
	self.mouse.x = x
	self.mouse.y = y
end

function portal_gun:draw(mario) 
	local now = os.time();

  	love.graphics.print(self.mouse.x .. " " ..  self.mouse.y, 32, 90)
	if now < self.time_till_no_gun_show then 
		local mx = mario.body:getX();
		local my = mario.body:getY();
		local dx = self.mouse.x-mx;	
		local dy = self.mouse.y-my;	
		local slope  = dy/dx
		
  		love.graphics.print("gun should show. Slope y = " ..dx ..  " " .. dy , 32, 120)
		love.graphics.line(mx,my,self.mouse.x, self.mouse.y);

	--	self.pulses [#self.pulses + 1] = pulse:new(mx, my);
	--	self.pulses [#self.pulses].body:applyImpulse(dx, dy,0,0);
	end
end
