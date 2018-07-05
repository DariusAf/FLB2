Object = require "classic"
require "transitioner"

BodyClass = Object:extend()

default_pos = {t = 0, dx = 0, dy = 0, int = 'lin'}


---------------------------------------------------------- NEW OBJECT

function BodyClass:new(default_mode, confident_mode)
  self.xpos = 400
  self.ypos = 500

  self.modename = 'default'
  self.transitioner = TransitionerClass(default_mode)
  self.default_mode = default_mode
  self.confident_mode = confident_mode

  self.cycle_t = default_pos.t
  self.cycle_speed = 1

  self.f1_walk = self.default_mode.f1_walk -- TODO : to transition
  self.f2_walk = self.default_mode.f2_walk

  -- FEET variables
  self.f1_xpos = 0
  self.f2_xpos = 0
  self.f1_ypos = 0
  self.f2_ypos = 0

  self.f1_last_action = default_pos
  self.f2_last_action = default_pos
  self.f1_next_action = default_pos
  self.f2_next_action = default_pos

  -- WALK variables
  self.walkcycle_xrange = 100
  self.walkcycle_yrange = 50
  self.leg_length = 150

  self.f1_walk_index = table.getn(self.default_mode.f1_walk)
  self.f2_walk_index = table.getn(self.default_mode.f2_walk)

  -- TORSO variables
  self.torso_dypos_base = 0
  self.torso_dypos_range = 5
  self.torso_dypos_phase = 0
  self.torso_dypos = 0

  self.torso_dr_base = 0
  self.torso_dr_range = 5
  self.torso_dr_phase = 0
  self.torso_dr = 20
end


---------------------------------------------------------- UPDATE

function BodyClass:interpolate_action(last_action, next_action)
  action_duration = next_action.t - (last_action.t % 1) + 0.000001
  action_t = self.cycle_t - (last_action.t % 1)
  action_dt = action_t / action_duration

  -- TODO : add new interpolations for natural movements, like x2in, x3out, ...
  if next_action.int == 'sin' then
    action_dt = math.sin(action_dt * math.pi - math.pi / 2) / 2 + 0.5
  elseif next_action.int == 'sinin' then
    action_dt = math.sin(action_dt * math.pi / 2)
  elseif next_action.int == 'sinout' then
    action_dt = 1 - math.sin(action_dt * math.pi / 2 + math.pi / 2)
  end

  return {last_action.dx + action_dt * (next_action.dx - last_action.dx),
          last_action.dy + action_dt * (next_action.dy - last_action.dy)}
end


function BodyClass:compute_knee_pos(torso_x, torso_y, foot_x, foot_y)
  -- TODO : ajout parametre d'offset pour faire des gens avec des grosses couilles
  mid_x = (torso_x + foot_x) / 2
  mid_y = (torso_y + foot_y) / 2
  dist = math.sqrt(math.pow((torso_x - foot_x), 2) + math.pow((torso_y - foot_y), 2))

  -- stretch
  if dist > self.leg_length then
    return {mid_x, mid_y}
  end

  -- fold
  excentricity = math.sqrt(math.pow(self.leg_length, 2) - math.pow(dist, 2)) / 2
  knee_x = mid_x + (foot_y - torso_y) * excentricity / dist
  knee_y = mid_y - (foot_x - torso_x) * excentricity / dist
  return {knee_x, knee_y}
end


function BodyClass:update(dt)
  --- UPDATE EVERY CONST
  self.transitioner:update(dt, self)

  --- COMPUTE MOVEMENT

  -- TODO : unblock movements, baser la vitesse sur le pieds qui glisse sur le sol (dylast && dynext = 0)
  -- self.xpos = self.xpos + self.cycle_distance / self.cycle_duration * dt

  self.cycle_t = self.cycle_t + dt * self.cycle_speed
  if self.cycle_t > 1 then
    self.cycle_t = self.cycle_t - 1

    -- reset walk cycle
    -- TOREFACTO
    if self.f1_walk_index ~= 1 then
      self.f1_last_action = self.f1_next_action
      self.f1_walk_index = 1
      self.f1_next_action = self.f1_walk[self.f1_walk_index]
    end
    if self.f2_walk_index ~= 1 then
      self.f2_last_action = self.f2_next_action
      self.f2_walk_index = 1
      self.f2_next_action = self.f2_walk[self.f2_walk_index]
    end
  end

  -- TOREFACTO
  if self.cycle_t > self.f1_next_action.t then
    self.f1_last_action = self.f1_next_action
    self.f1_walk_index = 1 + self.f1_walk_index % table.getn(self.f1_walk)
    self.f1_next_action = self.f1_walk[self.f1_walk_index]
  end
  if self.cycle_t > self.f2_next_action.t then
    self.f2_last_action = self.f2_next_action
    self.f2_walk_index = 1 + self.f2_walk_index % table.getn(self.f2_walk)
    self.f2_next_action = self.f2_walk[self.f2_walk_index]
  end

  new_f1_pos = self:interpolate_action(self.f1_last_action, self.f1_next_action)
  self.f1_xpos = new_f1_pos[1]
  self.f1_ypos = new_f1_pos[2]
  new_f2_pos= self:interpolate_action(self.f2_last_action, self.f2_next_action)
  self.f2_xpos = new_f2_pos[1]
  self.f2_ypos = new_f2_pos[2]

  -- TODO : cycles désymétrisés avec des pics violents par exemple
  self.torso_dypos = self.torso_dypos_base + self.torso_dypos_range * math.sin((self.cycle_t + self.torso_dypos_phase) * 4 * math.pi)
  self.torso_dr = self.torso_dr_base + self.torso_dr_range * math.sin((self.cycle_t + self.torso_dr_phase) * 4 * math.pi)
end


---------------------------------------------------------- CHANGE MODE

function BodyClass:transition_mode(modename)
  if modename ~= self.modename then
    self.modename = modename
    if modename == 'default' then
      mode = self.default_mode
    elseif modename == 'confident' then
      mode = self.confident_mode
    end
    self.transitioner:transition(mode)
  end
end


function BodyClass:keypressed(k)
  if k == 'a' then
    self:transition_mode('default')
  elseif k == 'z' then
    self:transition_mode('confident')
  end
end


---------------------------------------------------------- DRAW

function BodyClass:draw(dt)
  -- FEET
  f1_computed_x = self.xpos + self.walkcycle_xrange * self.f1_xpos
  f1_computed_y = self.ypos - self.walkcycle_yrange * self.f1_ypos
  f2_computed_x = self.xpos + self.walkcycle_xrange * self.f2_xpos
  f2_computed_y = self.ypos - self.walkcycle_yrange * self.f2_ypos

  -- LEGS
  love.graphics.setLineWidth(15)
  love.graphics.setLineStyle('smooth')
  torso_computed_x = self.xpos
  torso_computed_y = self.ypos - self.torso_dypos
  f1_knee_pos = self:compute_knee_pos(torso_computed_x, torso_computed_y, f1_computed_x, f1_computed_y)
  f2_knee_pos = self:compute_knee_pos(torso_computed_x, torso_computed_y, f2_computed_x, f2_computed_y)

  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.line(torso_computed_x, torso_computed_y,
    f1_knee_pos[1], f1_knee_pos[2],
    f1_computed_x, f1_computed_y)
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.line(torso_computed_x, torso_computed_y,
    f2_knee_pos[1], f2_knee_pos[2],
    f2_computed_x, f2_computed_y)

  -- TORSO
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.translate(torso_computed_x, torso_computed_y)
  love.graphics.rotate(self.torso_dr * math.pi / 180)
  love.graphics.rectangle("fill", -20, 5, 40, -150)
  love.graphics.rotate(-self.torso_dr * math.pi / 180)
  love.graphics.translate(-torso_computed_x, -torso_computed_y)
end
