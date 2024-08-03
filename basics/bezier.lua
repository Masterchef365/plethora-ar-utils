Bezier = {}

function Bezier:new(a, c1, c2, b)
  local t = setmetatable({}, { __index = Bezier })
  t.a = a 
  t.b = b 
  t.c1 = c1
  t.c2 = c2
  return t
end

function Bezier:interp(t)
    local it = 1 - t
    local it2 = it*it
    local t2 = t*t
    return self.a*it*it2 + self.c1*3*it2*t + self.c2*3*t2*it + self.b*t*t2
end

function Bezier:draw(gl, resolution, thickness, color)
    local last = nil
    for i=1,resolution do
        local t = (i-1)/(resolution-1)
        local pos = self:interp(t)
        if last then
            gl:addLine(pos, last, thickness, color)
        end
        last = pos
    end
end