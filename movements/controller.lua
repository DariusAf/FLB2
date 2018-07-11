Object = require "classic"

ControllerClass = Object:extend()

gravity_acc = 1000

LEFT_KEY = 'left'
RIGHT_KEY = 'right'

function ControllerClass:new()
  self.state = "snap"

  self.x = 310
  self.y = 200
  self.dx = 250
  self.dy = 0

  self.active_key = ''
end

function ControllerClass:in_data()
  return { x = self.x,
           y = self.y }
end

function ControllerClass:update(dt, map_link_data)
  dir = 0
  if self.active_key == LEFT_KEY then
    dir = -1
  elseif self.active_key == RIGHT_KEY then
    dir = 1
  end

  if self.state == "fall" then
    self.dy = self.dy + dt * gravity_acc
    self.y = self.y + dt * self.dy
    self.x = self.x + dir * self.dx * dt / 2
  elseif self.state == "snap" then
    floor_th_norm = math.sqrt(1 + math.pow(map_link_data.floor_th, 2))
    delta_x = dir * self.dx / floor_th_norm
    self.x = self.x + delta_x * dt
    delta_y = dir * self.dx * map_link_data.floor_th / floor_th_norm
    self.y = self.y + (delta_y * dt + 1)
  end
end

function ControllerClass:update_state(map_link_data)
  floor_y = map_link_data.floor_y
  collision = self.y >= floor_y
  if not collision then
    self.state = "fall"
  else
    self.state = "snap"
    self.y = floor_y
    self.dy = 0
  end
end

function ControllerClass:draw(dt)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * scale, self.y * scale - 18, 20, 10)
end

function ControllerClass:keypressed(k)
  if not (k == '') then
    self.active_key = k
  end
end

function ControllerClass:keyreleased(k)
  if k == self.active_key then
    self.active_key = ''
  end
end
