function get_random_element(array)
    return array[math.random(#array)]
end

local spawn_area_t = {["x1"] = 2007.9140625, ["y1"] = -1680.0068359375, ["x2"] = 1995.9482421875, ["y2"] = -1664.7294921875, ["z"] = 13.546875}
local spawn_area_ct = {["x1"] = 2075.18359375, ["y1"] = -1678.7763671875, ["x2"] = 2087.8046875, ["y2"] = -1664.5517578125, ["z"] = 13.546875}

local radar_area_t = createRadarArea(math.min(spawn_area_t.x1, spawn_area_t.x2),
    math.min(spawn_area_t.y1, spawn_area_t.y2),
    math.abs(spawn_area_t.x1 - spawn_area_t.x2),
    math.abs(spawn_area_t.y1 - spawn_area_t.y2),
    255, 0, 0, 255)
    
local radar_area_ct = createRadarArea(math.min(spawn_area_ct.x1, spawn_area_ct.x2),
    math.min(spawn_area_ct.y1, spawn_area_ct.y2),
    math.abs(spawn_area_ct.x1 - spawn_area_ct.x2),
    math.abs(spawn_area_ct.y1 - spawn_area_ct.y2),
    0, 0, 255, 255)

local function get_point_from_area(radar_area)
    local position = {}
    position.x = math.random(math.min(radar_area.x1, radar_area.x2), math.max(radar_area.x1, radar_area.x2))
    position.y = math.random(math.min(radar_area.y1, radar_area.y2), math.max(radar_area.y1, radar_area.y2))
    position.z = radar_area.z
    return position
end

function get_spawn_point(team_name)
    if team_name == "ct" then
        return get_point_from_area(spawn_area_ct)
    elseif team_name == "t" then
        return get_point_from_area(spawn_area_t)
    else
        error("Bad team! (" .. team_name .. ")")
    end
end

local function set_player_model(player, team_name)
    if team_name == "ct" then
        setElementModel(player, 285)
    elseif team_name == "t" then
        setElementModel(player, 312)
    else
        error("Bad team! (" .. team_name .. ")")
    end
end

function spawn_player_for_team(player, team_name)
    local spawn_point = get_spawn_point(team_name)
	spawnPlayer(player, spawn_point.x, spawn_point.y, spawn_point.z)
    
	fadeCamera(player, true)
	setCameraTarget(player, player)
    
    setPlayerHudComponentVisible(player, "clock", false)
    set_player_model(player, team_name)
    triggerEvent("onSpawn", player)
end

function is_player_in_buy_zone(player)
    team_name = get_team_name_for_player(player)
    player_x, player_y, player_z = getElementPosition(player)
    
    if team_name == "ct" then
        return isInsideRadarArea(radar_area_ct, player_x, player_y)
    elseif team_name == "t" then
        return isInsideRadarArea(radar_area_t, player_x, player_y)
    end
    
    return false
end
