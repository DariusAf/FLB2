body = {}

function body.load()
  body.xpos = 50
  body.cycle_length = 0.5
  body.cycle_t = body.cycle_length / 2
  body.is_beginning_cycle = true
  body.f1_xpos = body.xpos
  body.f2_xpos = body.xpos
  body.active_foot = 0

  -- body.f1_last_action = {}
  -- body.f2_last_action = {}
end

function body.update(dt)
  body.cycle_t = body.cycle_t + dt

  if body.is_beginning_cycle then
    body.is_beginning_cycle = false
    body.active_foot = (body.active_foot + 1) % 2
  end

  if body.cycle_t > body.cycle_length then
    body.cycle_t = body.cycle_t - body.cycle_length
    body.is_beginning_cycle = true
  end

  if body.active_foot == 1 then
    body.f1_xpos = body.f1_xpos + dt * 100
  else
    body.f2_xpos = body.f2_xpos + dt * 100
  end
end

function body.draw(dt)
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.circle('fill', body.f1_xpos, 200, 5)
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.circle('fill', body.f2_xpos, 200, 5)
end
