require "subclass/class.lua"
require "player/object/pulse.lua"

portal_gun = class:new()

function portal_gun:init() 
	self.mouse ={}
  	self.mouse.x, self.mouse.y = love.mouse.getPosition()
	self.time_till_no_gun_show = os.time()-10
	self.pulses = {} ;
end

function portal_gun:update(dt)
	local x, y = love.mouse.getPosition()
	if (self.mouse.x ~= x or self.mouse.y ~= y) then 
		self.time_till_no_gun_show = os.time() + 2 
	end
	self.mouse.x = x
	self.mouse.y = y
end
function drawHorLine(mx, my, y) 
	if (my > y) then 
		love.graphics.line(mx,0, mx,my)
	else 
		love.graphics.line(mx,650,mx,my)
	end
end

function drawVertLine(my, mx, x)
	if (mx > x) then 
		love.graphics.line(0,my, mx,my)
	else 
		love.graphics.line(mx,my, 650,my)
	end
end
function drawTheLine(mx,my,x, y) 
	if (mx == x) then 
		drawHorLine(mx, my, y)
		return
	elseif (my == y) then 
		drawVertLine(my, mx, x)
		return
	end

end

function drawSlopedLine(slope,b, dx,dy,mx, my)

	-- top left quadrant 
	if (dx < 0 and dy < 0)  then  
		--left wall
		if (b >=0 and b <= sHeight) then 
			love.graphics.line(mx, my, 0, b)
			return 
		end
		-- ceiling 
		local nx = -b/slope
		if (nx >= 0 and nx <=sWidth)then 
			love.graphics.line(mx, my, nx, 0)
			return 
		end

	end
	-- bottom left quadrant 
	if (dx < 0 and dy > 0)  then 
		--left wall
		if (b >=0 and b <= sHeight) then 
			love.graphics.line(mx, my, 0, b)
			return 
		end
		-- bottom
		local nx = (sHeight - b)/slope
		if (nx >= 0 and nx <sWidth)then 
			love.graphics.line(mx, my, nx, sHeight)
			return 
		end
	end
	-- top right quadrant 
	if (dx > 0 and dy < 0)  then 
		--ceiling 
		local nx = -b/slope
		if (nx >= 0 and nx <= (sWidth))then 
			love.graphics.line(mx, my, nx, 0)
			return 
		end
		-- right wall
		local ny = (slope *  sWidth) + b
		if (ny >= 0 and ny <= (sHeight))then 
			love.graphics.line(mx, my, sWidth, ny)
			return 
		end
	end
	-- bottom right quadrant 
	if (dx > 0 and dy > 0)  then 
		-- right wall
		local ny = (slope *  sWidth) + b
		if (ny >= 0 and ny <= (sHeight))then 
			love.graphics.line(mx, my, sWidth, ny)
			return 
		end
		-- bottom
		local nx = (sHeight - b)/slope
		if (nx >= 0 and nx <sWidth)then 
			love.graphics.line(mx, my, nx, sHeight)
			return 
		end
	end
	drawStraighLine(mx,my,x, y);
end
function portal_gun:keypressed(key ) 

	if (key == 'z') then 
		self.pulses[#self.pulses +1] = pulse:new()
	end


end

function portal_gun:draw(mario) 
	local now = os.time();

  	love.graphics.print(self.mouse.x .. " " ..  self.mouse.y, 32, 90)
	if now < self.time_till_no_gun_show then 
		local mx = mario.body:getX()-screenX ;
		local my = mario.body:getY();
		local x =self.mouse.x
		local y =self.mouse.y
		local dx = x-mx;	
		local dy = y-my;	
		local slope  = dy/dx
		local b  = y-(slope*x)
		drawSlopedLine (slope,b,dx, dy,  mx, my)
		local nx = -b/slope
  		love.graphics.print("gun should show. Slope y = " .. slope ..  " " .. b .. " " .. dx .. " " .. dy .. " " .. nx , 32, 120)

	end
end
