function love.load()
  config = {
    initial_x=200,
    initial_y=400,
    step=500,
    numStars=100
  }
  
  spaceship = {
    image=love.graphics.newImage("images/love-ball.png"),
    x=config.initial_x,
    y=config.initial_y
  }
  
  star = love.graphics.newImage("images/star.png");
	stars = {};
	love.graphics.setColorMode("modulate");
	scrollerHeight = 30;
	letterSize = 21;
	angle = {};
	x = {};
	initStars();
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    spaceship.x = spaceship.x - config.step * dt
  end
  
  if love.keyboard.isDown("right") then
    spaceship.x = spaceship.x + config.step * dt
  end
  
  if love.keyboard.isDown("up") then
    spaceship.y = spaceship.y - config.step * dt
  end
  
  if love.keyboard.isDown("down") then
    spaceship.y = spaceship.y + config.step * dt
  end
  
  for i = 1,config.numStars do
		stars[i].x = stars[i].x - stars[i].speed*dt
		if stars[i].x < -20 then
			stars[i].x = math.random(830, 900);
			stars[i].y = math.random(1,600);
		end
		angle[i] = angle[i] + math.pi/1.5 * dt;		
		x[i] = x[i] - letterSize*3*dt;
		if x[config.numStars-1] < -letterSize*2 then
			initScroller();
		end
	end
end

function love.draw()
  for i = 1,config.numStars do	
		love.graphics.setColor(255 - stars[i].speed,255 - stars[i].speed/2,150,stars[i].speed*0.9);		
		love.graphics.draw(star, stars[i].x, stars[i].y, 0, stars[i].speed/255 + 0.55);
	end
	
	love.graphics.setColor(255, 255, 255)
  love.graphics.draw(spaceship.image, spaceship.x, spaceship.y)
end

function initStars()
  local w = 800;
	for i = 1,config.numStars do
		table.insert(stars, {x = math.random(1,800), y = math.random(1,600), speed = math.random(2,255)});
		angle[i] = i*6;
		x[i] = w+i*letterSize;
	end
end