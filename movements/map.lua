Object = require "classic"

MapClass = Object:extend()

function MapClass:new(vec_map)
  self.vec = vec_map
  self.line_vec = self:convert_vec_to_line(self.vec)
end

function MapClass:convert_vec_to_line(vec)
  line = {}
  n = table.getn(self.vec)
  for i=1,n do
    table.insert(line, self.vec[i].x * scale)
    table.insert(line, self.vec[i].y * scale)
  end
  return line
end

function MapClass:draw()
  love.graphics.setColor(0, 0, 1)
  love.graphics.line(self.line_vec)
end
