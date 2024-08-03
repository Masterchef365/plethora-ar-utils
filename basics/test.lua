require("gps_glasses")
require("utils")
require("bezier")

local gl = GpsGlasses:new()
local initial_pos = gps_vector()

local positions = {}
local box_pairings = {}
local current_pairing = nil

while true do
    -- Refresh interval
    os.startTimer(0.1) 

    local event, char = os.pullEvent()

    local current_pos = gps_vector()

    -- Find closest point
    local closest_idx, closest_dist = mindist(positions, current_pos)

    if event == "timer" then
        -- Redraw
        gl:clear()

        -- Draw boxes
        for i,v in ipairs(positions) do
            local color = 0xFF00FFFF
            if i == closest_idx then
                color = 0x00FF00FF
            end
            gl:addBox(v, color)
        end

        -- Draw pairings
        for i,v in ipairs(box_pairings) do
            local bez = Bezier:new(
                positions[v[1]],
                positions[v[1]] + vector.new(1,1,1),
                positions[v[2]] + vector.new(-1,-1,-1),
                positions[v[2]]
            )
            bez:draw(gl, 40)
        end

    elseif event == "key" then
        -- Create new box
        if char == 200 then
            positions[#positions+1] = current_pos
        elseif char == 208 then
            if current_pairing and closest_idx then
                print("End Link", current_pairing, current_pos)
                box_pairings[#box_pairings+1] = {current_pairing,closest_idx}
                current_pairing = nil
            else
                print("Start Link")
                current_pairing = closest_idx
            end
        end
    end
end
