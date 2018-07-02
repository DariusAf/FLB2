body = {}

default_pos = {t = 0.125, dx = 0, dy = 0, int = 'lin'}
f1_walk = {
  {t = 0.25, dx = 0, dy = 1, int = 'sinin'},
  {t = 0.5, dx = 0.5, dy = 0, int = 'sinout'},
  {t = 0.75, dx = 0, dy = 0, int = 'lin'},
  {t = 1, dx = -0.5, dy = 0, int = 'lin'},
}
f2_walk = {
  {t = 0.25, dx = 0, dy = 0, int = 'lin'},
  {t = 0.5, dx = -0.5, dy = 0, int = 'lin'},
  {t = 0.75, dx = 0, dy = 1, int = 'sinin'},
  {t = 1, dx = 0.5, dy = 0, int = 'sinout'},
}

function body.load()
  body.xpos = 400
  body.ypos = 200

  body.cycle_t = default_pos.t
  body.cycle_speed = 1

  body.f1_xpos = 0
  body.f2_xpos = 0
  body.f1_ypos = 0
  body.f2_ypos = 0

  body.f1_last_action = default_pos
  body.f2_last_action = default_pos
  body.f1_next_action = default_pos
  body.f2_next_action = default_pos

  -- WALK variables
  body.walkcycle_xrange = 100
  body.walkcycle_yrange = 30

  body.f1_walk_index = table.getn(f1_walk)
  body.f2_walk_index = table.getn(f2_walk)

end

function body.next_action()

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
end

function body.draw(dt)
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.circle('fill',
      body.xpos + body.walkcycle_xrange * body.f1_xpos,
      body.ypos - body.walkcycle_yrange * body.f1_ypos,
      5)
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.circle('fill',
      body.xpos + body.walkcycle_xrange * body.f2_xpos,
      body.ypos - body.walkcycle_yrange * body.f2_ypos,
      5)

  love.graphics.print(body.f1_last_action.t, 0, 30)
  love.graphics.print(body.f1_next_action.t, 0, 60)
  love.graphics.print(body.cycle_t, 0, 90)
end
