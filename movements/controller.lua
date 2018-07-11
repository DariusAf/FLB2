Object = require "classic"

ControllerClass = Object:extend()

function ControllerClass:new()
  self.x = 250
  self.y = 200
end

function ControllerClass:update(dt)
end

function ControllerClass:draw(dt)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * scale, self.y * scale, 20, 10)
end

function ControllerClass:keypressed(k)
end

function ControllerClass:keyreleased(k)
end
