Object = require "classic"

MapClass = Object:extend()

function MapClass:new(vec_map)
  self.vec = vec_map
  self.vec_n = table.getn(self.vec)
  self.vec_line = self:convert_vec_to_line(self.vec)
  self.vec_data = self:compute_vec_data(self.vec)
end

function MapClass:convert_vec_to_line(vec)
  line = {}
  for i = 1, self.vec_n do
    table.insert(line, self.vec[i].x * scale)
    table.insert(line, self.vec[i].y * scale)
  end
  return line
end

function MapClass:compute_vec_data(vec)
  data = {}
  for i = 1, (self.vec_n - 1) do
    xm = (self.vec[i].x + self.vec[i + 1].x) / 2
    ym = (self.vec[i].y + self.vec[i + 1].y) / 2
    Dx = self.vec[i + 1].x - self.vec[i].x
    Dy = self.vec[i + 1].y - self.vec[i].y
    if (math.abs(Dx) >= math.abs(Dy)) then
      angle_ratio = Dy / Dx
      orientation = '-'
      if Dx > 0 then
        normal_dir = -1
      else
        normal_dir = 1
      end
    else
      angle_ratio = Dx / Dy
      orientation = '|'
      if Dy > 0 then
        normal_dir = 1
      else
        normal_dir = -1
      end
    end
    table.insert(data,
    { xm = xm,
      ym = ym,
      Dx = math.abs(Dx),
      Dy = math.abs(Dy),
      angle_ratio = angle_ratio,
      orientation = orientation,
      normal_dir = normal_dir
    })
  end
  return data
end

function MapClass:draw(camera)
  love.graphics.setColor(0, 0, 1)
  love.graphics.translate(-camera.x * scale, -camera.y * scale)
  love.graphics.line(self.vec_line)
  love.graphics.translate(camera.x * scale, camera.y * scale)
end
