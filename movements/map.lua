Object = require "classic"

MapClass = Object:extend()

function MapClass:new(vec_map)
  self.vec = vec_map
  self.vec_n = table.getn(self.vec)
  self.line_vec = self:convert_vec_to_line(self.vec)
end

function MapClass:convert_vec_to_line(vec)
  line = {}
  for i = 1, self.vec_n do
    table.insert(line, self.vec[i].x * scale)
    table.insert(line, self.vec[i].y * scale)
  end
  return line
end

function MapClass:out_data(controller_in_data)
  cx = controller_in_data.x
  floor_y = math.huge
  for i = 1, (self.vec_n - 1) do
    if (self.vec[i].x <= cx) and (cx <= self.vec[i + 1].x) then
      Dx = self.vec[i + 1].x - self.vec[i].x
      Dy = self.vec[i + 1].y - self.vec[i].y
      floor_th = Dy / Dx -- ce genre d'angle mamène, atan() n'apporte rien
      floor_y = math.min(self.vec[i].y + (cx - self.vec[i].x) * floor_th,
                         floor_y)
    end
  end

  return {floor_y = floor_y, floor_th = floor_th}
end

function MapClass:draw()
  love.graphics.setColor(0, 0, 1)
  love.graphics.line(self.line_vec)
end
