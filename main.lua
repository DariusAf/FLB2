function love.load()
  love.window.setTitle("Floppywalk")
  love.window.setMode(400 * scale, 300 * scale, {})
  love.graphics.setDefaultFilter("nearest", "nearest")

  require 'body'
  require 'cycles'

  floppyboy = BodyClass(normal_body, confident_body)

  love.graphics.setBackgroundColor(0,0,0.1)
end

function love.draw()
  floppyboy:draw()
  love.graphics.print(floppyboy.modename, 0, 90)
end


function love.update(dt)
  floppyboy:update(dt)
end


function love.keypressed(k)
  floppyboy:keypressed(k)
end

function love.keyreleased(k)

end
