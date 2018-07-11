Object = require "classic"

TransitionerClass = Object:extend()

function TransitionerClass:new(init_mode)
  self.last_mode = init_mode
  self.next_mode = init_mode
  self.transition_duration = 1
  self.transition_t = 5
  self.is_transitioning = true
end

function TransitionerClass:personnality(key)
  if not self.is_transitioning then
    return self.last_mode.personnality[key]
  end
  if self.last_mode.personnality[key] == self.next_mode.personnality[key] then
    return self.last_mode.personnality[key]
  end
  a = math.min(self.transition_t / self.transition_duration, 1)
  return self.last_mode.personnality[key] * (1 - a) +
        self.next_mode.personnality[key] * a
end

function TransitionerClass:f1_walk(key)
  return self.last_mode.f1_walk[key]
end

function TransitionerClass:f2_walk(key)
  return self.last_mode.f2_walk[key]
end

function TransitionerClass:transition(mode)
  if not self.is_transitioning then
    self.is_transitioning = true
    self.transition_t = 0
    self.next_mode = mode
  end
  -- TODO : if pressed during transition, make interpolated mode as last_mode
end

function TransitionerClass:update(dt, parent)
  if self.is_transitioning then
    self.transition_t = self.transition_t + dt
    
    parent.cycle_speed = self:personnality('cycle_speed')

    parent.walkcycle_xrange = self:personnality('walkcycle_xrange')
    parent.walkcycle_yrange = self:personnality('walkcycle_yrange')
    parent.leg_length = self:personnality('leg_length')

    parent.torso_dypos_base = self:personnality('torso_dypos_base')
    parent.torso_dypos_range = self:personnality('torso_dypos_range')
    parent.torso_dypos_phase = self:personnality('torso_dypos_phase')

    parent.torso_dr_base = self:personnality('torso_dr_base')
    parent.torso_dr_range = self:personnality('torso_dr_range')
    parent.torso_dr_phase = self:personnality('torso_dr_phase')

    if self.transition_t > self.transition_duration then
      self.last_mode = self.next_mode

      parent.f1_walk = self.next_mode.f1_walk
      parent.f2_walk = self.next_mode.f2_walk

      self.is_transitioning = false
    end
  end
end
