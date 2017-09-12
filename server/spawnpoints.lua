function get_random_element(array)
    return array[math.random(#array)]
end

local spawn_area_t = {["x1"] = 2007.099609375, ["y1"] = -1744.5419921875, ["x2"] = 1993.56640625, ["y2"] = -1757.9384765625, ["z"] = 13.546875}
local spawn_area_ct = {["x1"] = 2089.3388671875, ["y1"] = -1621.2353515625, ["x2"] = 2074.244140625, ["y2"] = -1606.11328125, ["z"] = 13.546875}

local radar_area_t = createRadarArea(math.min(spawn_area_t.x1, spawn_area_t.x2),
    math.min(spawn_area_t.y1, spawn_area_t.y2),
    math.abs(spawn_area_t.x1 - spawn_area_t.x2),
    math.abs(spawn_area_t.y1 - spawn_area_t.y2),
    255, 0, 0, 128)
    
local radar_area_ct = createRadarArea(math.min(spawn_area_ct.x1, spawn_area_ct.x2),
    math.min(spawn_area_ct.y1, spawn_area_ct.y2),
    math.abs(spawn_area_ct.x1 - spawn_area_ct.x2),
    math.abs(spawn_area_ct.y1 - spawn_area_ct.y2),
    0, 0, 255, 128)

local function get_point_from_area(radar_area)
    local position = {}
    position.x = math.random(math.min(radar_area.x1, radar_area.x2), math.max(radar_area.x1, radar_area.x2))
    position.y = math.random(math.min(radar_area.y1, radar_area.y2), math.max(radar_area.y1, radar_area.y2))
    position.z = radar_area.z
    return position
end

function get_spawn_point(team_name)
    if team_name == team_ct_name then
        return get_point_from_area(spawn_area_ct)
    elseif team_name == team_t_name then
        return get_point_from_area(spawn_area_t)
    else
        error("Bad team! (" .. team_name .. ")")
    end
end

local function set_player_model(player, team_name)
    if team_name == team_ct_name then
        setElementModel(player, 285)
    elseif team_name == team_t_name then
        setElementModel(player, 312)
    else
        error("Bad team! (" .. team_name .. ")")
    end
end

function spawn_player_for_team(player, team_name)
    local spawn_point = get_spawn_point(team_name)
    setPlayerTeam(player, getTeamFromName(team_name))
	spawnPlayer(player, spawn_point.x, spawn_point.y, spawn_point.z)
    
	fadeCamera(player, true)
	setCameraTarget(player, player)
    
    setPlayerHudComponentVisible(player, "clock", false)
    set_player_model(player, team_name)
    triggerEvent("onSpawn", player)
end

function is_player_in_buy_zone(player)
    team_name = getTeamName(getPlayerTeam(player))
    player_x, player_y, player_z = getElementPosition(player)
    
    if team_name == team_ct_name then
        return isInsideRadarArea(radar_area_ct, player_x, player_y)
    elseif team_name == team_t_name then
        return isInsideRadarArea(radar_area_t, player_x, player_y)
    end
    
    return false
end
