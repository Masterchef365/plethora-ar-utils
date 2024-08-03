GpsGlasses = {}

function gps_vector()
  local x, y, z = gps.locate()
  if not x then
    print("GPS not working")
    return nil
  end
  return vector.new(x, y, z)
end

function v_to_d(vect)
  -- Vector to draw table
  return { vect.x, vect.y, vect.z }
end

function GpsGlasses:new()
  -- Lua stuff
  local t = setmetatable({}, { __index = GpsGlasses })

  -- Set up the canvas
  local neural = peripheral.wrap("back")
  --local neural = peripheral.wrap("neuralInterface")
  if not neural then
    print("Neural Interface not found")
    return nil
  end
  t.neural = neural
  t.canvas3d = t.neural.canvas3d()
  t.canvas3d.clear()

  -- Get current location
  local init_location = gps_vector()
  if not init_location then
    return nil
  end
  t.init_location = init_location

  -- Frames don't work with large numbers, so
  -- we can't just insert the world coordinates here :(
  t.frame = t.canvas3d.create({0,0,0})

  return t
end

function GpsGlasses:addLine(a, b, thickness, color)
  return self.frame.addLine(
    v_to_d(a - self.init_location),
    v_to_d(b - self.init_location),
    color
  )
end

function GpsGlasses:addBox(pos, color)
  local offset = pos - self.init_location
  return self.frame.addBox(
    offset.x, offset.y, offset.z,
    1,1,1,
    color
  )
end

function GpsGlasses:clear()
  return self.frame.clear()
end
