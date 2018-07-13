Object = require "classic"

ControllerClass = Object:extend()

collision_tolerance = 20
gravity_acc = 1000
lateral_acc = 500

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

  if self.state == "fall" then
    self.dy = self.dy + dt * gravity_acc
    self.dx = self.dx + dt * lateral_acc * dir
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
  elseif self.state == "slide" then
    floor_dir = 1
    if self.floor_angle_ratio < 0 then
      floor_dir = -1
    end
    if (dir == floor_dir) then
      -- TODO : improve that crap jump
      self.dx = floor_dir * self.maxdx / 2
      self.dy = -self.maxdy
    elseif (dir == -floor_dir) then
      -- TODO : improve that crap jump
      self.dx = floor_dir * self.maxdx / 3
      self.dy = -self.maxdy / 2
    else
      floor_angle_norm = math.sqrt(1 + math.pow(self.floor_angle_ratio, 2))
      self.dy = self.dy + dt * gravity_acc / floor_angle_norm
      self.dx = floor_dir * self.floor_angle_ratio * self.dy - 1
    end
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
  elseif self.state == "snap" then
    delta_x = dir * self.maxdx
    self.x = self.x + delta_x * dt
    delta_y = self.floor_angle_ratio * delta_x + 1
    self.y = self.y + (delta_y * dt)
  end
end

function ControllerClass:draw(dt)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * scale, self.y * scale - 20, 20, 10)
end

function ControllerClass:keypressed(k)
  if (k == LEFT_KEY) or (k == RIGHT_KEY) then
    -- TODO : only if key is a movement key !
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
