function distance(a, b)
    local d = b - a
    return math.sqrt(d.x*d.x + d.y*d.y + d.z*d.z)
end

function mindist(positions, pos)
    local best = nil
    local best_dist = 99999
    for i,v in ipairs(positions) do
        local dist = distance(v, pos)
        if dist < best_dist then
            best = i
            best_dist = dist
        end
    end
    return best, best_dist
end