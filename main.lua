function love.load()
	love.window.setTitle("Floppywalk")
	love.window.setMode(400 * scale, 300 * scale, {})
	love.graphics.setDefaultFilter("nearest", "nearest")

  require 'body'

  body.load()

	love.graphics.setBackgroundColor(0,0,0.1)
end

function love.draw()
  body.draw()
end


function love.update(dt)
  body.update(dt)
end


function love.keypressed(k)

end

function love.keyreleased(k)

end
