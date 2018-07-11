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
  love.graphics.print(controller.state, 10, 10)
  love.graphics.print(controller.active_key, 10, 40)
  love.graphics.print(map:out_data(controller:in_data()).floor_th, 10, 70)
end


function love.update(dt)
  map_link_data = map:out_data(controller:in_data())
  controller:update(dt, map_link_data)
  controller:update_state(map_link_data)
end


function love.keypressed(k)
  controller:keypressed(k)
end

function love.keyreleased(k)
  controller:keyreleased(k)
end
