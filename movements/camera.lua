Object = require "classic"

CameraClass = Object:extend()

view_params = {
  length = 400,
  width = 300,
  dead_zone = 50,
}

function CameraClass:new(params)
  self.x = 0
  self.y = 0
  self.dx = 0
  self.dy = 0
  self.L = params.length
  self.H = params.width
  self.params = params
  self.mode = 'elastic'

  -- TODO ? : recenter after a while
  -- TODO ? : add inertia to camera
  -- TODO : magnetism to specific scenes
  -- TODO ? : random movements to simalate camera holding
  -- TODO : camera effects (shake, tilt, etc)
end

function CameraClass:update(dt, targetX, targetY)
  if self.mode == 'track' then
    dx = targetX - (self.x + self.L / 2)
    dy = targetY - (self.y + self.H / 2)
    if dx > self.params.dead_zone then
      self.x = targetX - self.params.dead_zone - self.L / 2
    elseif dx < -self.params.dead_zone then
      self.x = targetX + self.params.dead_zone - self.L / 2
    end

  elseif self.mode == 'elastic' then
    K = 50
    self.dx = self.dx + dt * (K * (targetX - self.L / 2 - self.x) - K / 5 * self.dx)
    self.x = self.x + dt * self.dx
    self.y = self.y + dt * self.dy
  end
end

function CameraClass:position()
  return { x = self.x, y = self.y }
end
