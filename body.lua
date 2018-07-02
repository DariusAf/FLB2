body = {}

default_pos = {t = 0.125, dx = 0, dy = 0, int = 'lin'}
f1_walk = {
  {t = 0.25, dx = 0.1, dy = 1, int = 'sinout'},
  {t = 0.5, dx = 0.4, dy = 0, int = 'sinin'},
  {t = 0.75, dx = 0, dy = 0, int = 'lin'},
  {t = 1, dx = -0.6, dy = 0, int = 'lin'},
}
f2_walk = {
  {t = 0.25, dx = 0, dy = 0, int = 'lin'},
  {t = 0.5, dx = -0.6, dy = 0, int = 'lin'},
  {t = 0.75, dx = 0.1, dy = 1, int = 'sinout'},
  {t = 1, dx = 0.4, dy = 0, int = 'sinin'},
}

function body.load()
  body.xpos = 400
  body.ypos = 500

  body.cycle_t = default_pos.t
  body.cycle_speed = 0.8

  body.f1_xpos = 0
  body.f2_xpos = 0
  body.f1_ypos = 0
  body.f2_ypos = 0

  body.f1_last_action = default_pos
  body.f2_last_action = default_pos
  body.f1_next_action = default_pos
  body.f2_next_action = default_pos

  -- WALK variables
  body.walkcycle_xrange = 150
  body.walkcycle_yrange = 50

  body.f1_walk_index = table.getn(f1_walk)
  body.f2_walk_index = table.getn(f2_walk)

  -- TORSO variables
  body.torso_dypos = 150
  body.leg_length = 165
end


function body.interpolate_action(last_action, next_action)
  action_duration = next_action.t - (last_action.t % 1) + 0.000001
  action_t = body.cycle_t - (last_action.t % 1)
  action_dt = action_t / action_duration
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


function body.compute_knee_pos(torso_x, torso_y, foot_x, foot_y)
  -- du bon vieux théorème de pythagore
  mid_x = (torso_x + foot_x) / 2
  mid_y = (torso_y + foot_y) / 2
  dist = math.sqrt(math.pow((torso_x - foot_x), 2) + math.pow((torso_y - foot_y), 2))
  if dist > body.leg_length then
    return {mid_x, mid_y}
  end

  -- ajout du vecteur tourné de pi / 2
  excentricity = math.sqrt(math.pow(body.leg_length, 2) - math.pow(dist, 2)) / 2
  knee_x = mid_x + (foot_y - torso_y) * excentricity / dist
  knee_y = mid_y - (foot_x - torso_x) * excentricity / dist
  return {knee_x, knee_y}
end


function body.update(dt)
  -- TODO : unblock movements
  -- body.xpos = body.xpos + body.cycle_distance / body.cycle_duration * dt

  body.cycle_t = body.cycle_t + dt * body.cycle_speed
  if body.cycle_t > 1 then
    body.cycle_t = body.cycle_t - 1

    -- RESET WALKING ACTIONS
    body.f1_last_action = body.f1_next_action
    body.f1_walk_index = 1
    body.f1_next_action = f1_walk[body.f1_walk_index]

    body.f2_last_action = body.f2_next_action
    body.f2_walk_index = 1
    body.f2_next_action = f2_walk[body.f2_walk_index]
  end

  -- TODO : refacto
  if body.cycle_t > body.f1_next_action.t then
    body.f1_last_action = body.f1_next_action
    body.f1_walk_index = 1 + body.f1_walk_index % table.getn(f1_walk)
    body.f1_next_action = f1_walk[body.f1_walk_index]
  end
  if body.cycle_t > body.f2_next_action.t then
    body.f2_last_action = body.f2_next_action
    body.f2_walk_index = 1 + body.f2_walk_index % table.getn(f2_walk)
    body.f2_next_action = f2_walk[body.f2_walk_index]
  end

  new_f1_pos = body.interpolate_action(body.f1_last_action, body.f1_next_action)
  body.f1_xpos = new_f1_pos[1]
  body.f1_ypos = new_f1_pos[2]
  new_f2_pos= body.interpolate_action(body.f2_last_action, body.f2_next_action)
  body.f2_xpos = new_f2_pos[1]
  body.f2_ypos = new_f2_pos[2]

  -- TORSO
  body.torso_dypos = 155 + 10 * math.sin((body.cycle_t + 0.3) * 4 * math.pi)
end


function body.draw(dt)
  -- FEET
  f1_computed_x = body.xpos + body.walkcycle_xrange * body.f1_xpos
  f1_computed_y = body.ypos - body.walkcycle_yrange * body.f1_ypos
  f2_computed_x = body.xpos + body.walkcycle_xrange * body.f2_xpos
  f2_computed_y = body.ypos - body.walkcycle_yrange * body.f2_ypos
  --love.graphics.setColor(1, 0, 0, 1)
  --love.graphics.circle('fill', f1_computed_x, f1_computed_y, 5)
  --love.graphics.setColor(0, 0, 1, 1)
  --love.graphics.circle('fill', f2_computed_x, f2_computed_y, 5)

  -- TORSO
  love.graphics.setLineWidth(15)
  love.graphics.setLineStyle('smooth')
  torso_computed_x = body.xpos
  torso_computed_y = body.ypos - body.torso_dypos
  f1_knee_pos = body.compute_knee_pos(torso_computed_x, torso_computed_y, f1_computed_x, f1_computed_y)
  f2_knee_pos = body.compute_knee_pos(torso_computed_x, torso_computed_y, f2_computed_x, f2_computed_y)

  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.line(torso_computed_x, torso_computed_y,
    f1_knee_pos[1], f1_knee_pos[2],
    f1_computed_x, f1_computed_y)
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.line(torso_computed_x, torso_computed_y,
    f2_knee_pos[1], f2_knee_pos[2],
    f2_computed_x, f2_computed_y)

  -- DEBUGGER
  love.graphics.print(body.torso_dypos, 0, 30)
  love.graphics.print(body.cycle_t, 0, 90)
end
