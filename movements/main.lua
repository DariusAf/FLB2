scale = 2

function love.load()
  love.window.setTitle("Floppymove")
  love.window.setMode(400 * scale, 300 * scale, {})
  love.graphics.setDefaultFilter("nearest", "nearest")

  require "controller"
  require "vec_map"
  require "map"
  require "camera"

  controller = ControllerClass()
  map = MapClass(vec_land)
  camera = CameraClass(view_params)

  love.graphics.setBackgroundColor(0,0,0.1)
end

function love.draw()
  controller:draw(camera:position())
  map:draw(camera:position())
  love.graphics.print(controller.state, 10, 10)
  love.graphics.print(controller.active_key, 10, 40)
  love.graphics.print(controller.floor_angle_ratio, 10, 70)
  love.graphics.print(controller.dx, 10, 100)
end


function love.update(dt)
  controller:update(dt)
  correct_movement_and_update_state(controller, map)
  camera:update(dt, controller.x, controller.y)
end


function love.keypressed(k)
  controller:keypressed(k)
end

function love.keyreleased(k)
  controller:keyreleased(k)
end
