Object = require "classic"

ControllerClass = Object:extend()

gravity_acc = 500

function ControllerClass:new()
  self.x = 150
  self.y = 0
  self.dx = 0
  self.dy = 0
  self.state = "snap"
end

function ControllerClass:in_data()
  return {x = self.x,
          y = self.y}
end

function ControllerClass:update_state(map_out_data)
  floor_y = map_out_data.floor_y
  collision = self.y >= floor_y
  if not collision then
    self.state = "fall"
  else
    self.state = "snap"
    self.y = floor_y
  end
end

function ControllerClass:update(dt, map_out_data)
  if self.state == "fall" then
    self.dy = self.dy + dt * gravity_acc
    self.y = self.y + dt * self.dy
  end
end

function ControllerClass:draw(dt)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * scale, self.y * scale - 18, 20, 10)
end

function ControllerClass:keypressed(k)
end

function ControllerClass:keyreleased(k)
end
