function love.load()
  config = {
    initial_x       = 200,
    initial_y       = 400,
    step            = 500,
    numStars        = 100,
    starSpeedFactor = 1
  }

  world = {
    dt = 0
  }

  spaceship = {
    images = {
      normal = love.graphics.newImage("images/hero-ship.png"),
      boosted = love.graphics.newImage("images/hero-ship-boosted.png"),
    },
    x             = config.initial_x,
    y             = config.initial_y,
    isBoosted     = false,
    boostFactor   = 4,
    boostDuration = 2,
    timeBoosted   = 0,
    fireRate      = 1,
    lastFiredAt   = 0.5,
  }
  
  laser = {
    images = {
      default = love.graphics.newImage("images/laser-beam.png"),
    },
    velocity = 1000,
  }
  lasers = {}

  star = love.graphics.newImage("images/star.png")
  stars = {}
  love.graphics.setColorMode("modulate")
  scrollerHeight = 30
  letterSize = 21
  angle = {}
  x = {}
  initStars()
end

function love.update(dt)
  world.dt = dt

  if not spaceship.isBoosted then
    config.starSpeedFactor = 1
  end
  
  if spaceship.isBoosted == false then
    if love.keyboard.isDown("left") and (spaceship.x - config.step * dt) >= 0 then
      spaceship.x = spaceship.x - config.step * dt
    end

    if love.keyboard.isDown("right") and (spaceship.x + config.step * dt) < 740 then
	    spaceship.x = spaceship.x + config.step * dt
    end
  end

  if love.keyboard.isDown("up") and (spaceship.y - config.step * dt) >= 0 then
    spaceship.y = spaceship.y - config.step * dt
  end

  if love.keyboard.isDown("down") and (spaceship.y + config.step * dt) < 540  then
    spaceship.y = spaceship.y + config.step * dt
  end
  
  if love.keyboard.isDown("lshift") and not spaceship.isBoosted then
    config.starSpeedFactor  = spaceship.boostFactor
    spaceship.isBoosted     = true
    spaceship.timeBoosted   = 0
  end
  
  -- LASER STUFF
  totalLaserBeams = table.getn(lasers)

  -- when was that last time we fired
  -- if we should fire again
  -- the only thing we know (right now) is when was the last we checked
  if love.keyboard.isDown(" ") then
  
    if spaceship.lastFiredAt > 0.5 then
      table.insert(lasers, { x = spaceship.x + 125, y = spaceship.y + 30, } )
      spaceship.lastFiredAt = 0
    else
      spaceship.lastFiredAt = spaceship.lastFiredAt + dt
    end
  end
  
  for i = 1, totalLaserBeams do 
    lasers[i].x = lasers[i].x + laser.velocity * dt
  end

  for i = 1,config.numStars do
    stars[i].x = stars[i].x - stars[i].speed * config.starSpeedFactor * dt
    if stars[i].x < -20 then
      stars[i].x = math.random(830, 900)
      stars[i].y = math.random(1,600)
    end
    angle[i] = angle[i] + math.pi/1.5 * dt;
    x[i] = x[i] - letterSize*3*dt
    if x[config.numStars-1] < -letterSize*2 then
      initStars()
    end
  end
end

function love.keyreleased(key)
  if key == "lshift" then
    spaceship.isBoosted = false
  end
  
  if key == " " then
    spaceship.lastFiredAt = 0.5
  end
end

function love.draw()
  for i = 1,config.numStars do
    love.graphics.setColor(255 - stars[i].speed,255 - stars[i].speed/2,150,stars[i].speed*0.9);
    love.graphics.draw(star, stars[i].x, stars[i].y, 0, stars[i].speed/255 + 0.55)
  end

  love.graphics.setColor(255, 255, 255)

  -- if player is not boosted, draw the normal ship
  -- if the player is boosted, draw the boosted ship
  if spaceship.isBoosted == false then
    love.graphics.draw(spaceship.images.normal, spaceship.x, spaceship.y)
  else
    love.graphics.draw(spaceship.images.boosted, spaceship.x, spaceship.y)
  end
  
  for i = 1, totalLaserBeams do 
    love.graphics.draw(laser.images.default, lasers[i].x, lasers[i].y)
  end

  love.graphics.print("dt: " .. world.dt .. " | spaceship.lastFiredAt: " .. spaceship.lastFiredAt, 10, 575)
end

function initStars()
  local w = 800
  for i = 1, config.numStars do
    table.insert(stars, {x = math.random(1,800), y = math.random(1,600), speed = math.random(2,255)})
    angle[i] = i*6
    x[i] = w+i*letterSize
  end
end
