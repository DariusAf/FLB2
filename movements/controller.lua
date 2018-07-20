Object = require "classic"

ControllerClass = Object:extend()

collision_tolerance = 20
gravity_acc = 1000
lateral_acc = 1000

LEFT_KEY = 'left'
RIGHT_KEY = 'right'

function ControllerClass:new()
  self.state = "fall"

  self.x = 385
  self.y = 50
  self.dx = 0
  self.dy = 0
  self.maxdx = 250
  self.maxdy = 250

  self.active_key = ''

  self.floor_angle_ratio = 0
end

function ControllerClass:update(dt)
  dir = 0
  if self.active_key == LEFT_KEY then
    dir = -1
  elseif self.active_key == RIGHT_KEY then
    dir = 1
  end
  sdx = 0
  if self.dx > 0 then
    sdx = 1
  elseif self.dx < 0 then
    sdx = -1
  end

  if self.state == "fall" then
    self.dx = self.dx + dt * lateral_acc / 4 * dir
    self.dy = self.dy + dt * gravity_acc

  elseif self.state == "slide" then
    floor_angle_norm = math.sqrt(1 + math.pow(self.floor_angle_ratio, 2))
    self.dy = self.dy + dt * gravity_acc / floor_angle_norm
    self.dx = self.floor_angle_ratio * (self.dy - 1)

  elseif self.state == "snap" then
    if (dir == 0) or (math.abs(self.dx) > self.maxdx) or (dir == -sdx) then
      if self.dx > 0 then
        self.dx = math.max(self.dx - dt * lateral_acc * 3, 0)
      else
        self.dx = math.min(self.dx + dt * lateral_acc * 3, 0)
      end
    else
      self.dx = math.max(math.min(self.dx + dt * dir * lateral_acc, self.maxdx), -self.maxdx)
    end
    self.dy = self.floor_angle_ratio * self.dx + 1
  end

  self.y = self.y + self.dy * dt
  self.x = self.x + self.dx * dt

end

function ControllerClass:draw(camera)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * scale - camera.x, self.y * scale - 20 - camera.y, 20, 10)
end

function ControllerClass:keypressed(k)
  if (k == LEFT_KEY) or (k == RIGHT_KEY) then
    self.active_key = k
  end

  if (k == 'r') then
    self.x = 10
    self.y = 0
    self.dx = 0
    self.dy = 0
  end
end

function ControllerClass:keyreleased(k)
  if k == self.active_key then
    self.active_key = ''
  end
end


function correct_movement_and_update_state(controller, map)
  cx = controller.x
  cy = controller.y
  collides = false

  for i = 1, (map.vec_n - 1) do
    if (math.abs(map.vec_data[i].xm - cx) < (math.abs(map.vec_data[i].Dx) / 2 + collision_tolerance))
        and (math.abs(map.vec_data[i].ym - cy) < (math.abs(map.vec_data[i].Dy) / 2 + collision_tolerance)) then
      rectified_horizontal_pos = map.vec[i].y + (cx - map.vec[i].x) * map.vec_data[i].angle_ratio
      rectified_vertical_pos = map.vec[i].x + (cy - map.vec[i].y) * map.vec_data[i].angle_ratio

      if (map.vec_data[i].orientation == "-")
          and (math.abs(map.vec_data[i].xm - cx) < (math.abs(map.vec_data[i].Dx) / 2 + 1))
          and ((cy - rectified_horizontal_pos) * map.vec_data[i].normal_dir <= 0) then
        collides = true
        controller.y = rectified_horizontal_pos
        cy = controller.y
        controller.dy = 0
        controller.state = "snap"
        controller.floor_angle_ratio = map.vec_data[i].angle_ratio
        -- TODO : ajouter un temps de réception après un atterissage

      elseif (map.vec_data[i].orientation == "|")
          and (math.abs(map.vec_data[i].ym + collision_tolerance - cy) < (math.abs(map.vec_data[i].Dy) / 2 + collision_tolerance))
          and ((cx - rectified_vertical_pos) * map.vec_data[i].normal_dir <= 0) then
        controller.x = rectified_vertical_pos
        cx = controller.x
        if (controller.state == "fall") then
          controller.dy = controller.dy / 5
        end
        if not collides then
          controller.state = "slide"
          controller.floor_angle_ratio = map.vec_data[i].angle_ratio
        end
        collides = true
      end

    end
  end

  if not collides then
    controller.state = "fall"
    controller.floor_angle_ratio = 0
  end
end
