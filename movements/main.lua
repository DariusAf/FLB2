scale = 2

function love.load()
  love.window.setTitle("Floppymove")
  love.window.setMode(400 * scale, 300 * scale, {})
  love.graphics.setDefaultFilter("nearest", "nearest")

  require "controller"
  require "vec_map"
  require "map"

  controller = ControllerClass()
  map = MapClass(vec_cuvette)

  love.graphics.setBackgroundColor(0,0,0.1)
end

function love.draw()
  controller:draw()
  map:draw()
end


function love.update(dt)
  controller:update(dt)
  controller:update_state(map:out_data(controller:in_data()))
end


function love.keypressed(k)

end

function love.keyreleased(k)

end
