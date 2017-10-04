local spawn_area_border = 1

function get_random_element(array)
    return array[math.random(#array)]
end

-- Test locations
--local spawn_area_t = {["x1"] = 2007.099609375, ["y1"] = -1744.5419921875, ["x2"] = 1993.56640625, ["y2"] = -1757.9384765625, ["z"] = 13.546875}
--local spawn_area_ct = {["x1"] = 2089.3388671875, ["y1"] = -1621.2353515625, ["x2"] = 2074.244140625, ["y2"] = -1606.11328125, ["z"] = 13.546875}

-- Grove
--local spawn_area_t = {["x1"] = 2468.8759765625, ["y1"] = -1654.6201171875, ["x2"] = 2505.0283203125, ["y2"] = -1678.93359375, ["z"] = 13.379979133606}
-- LSPD
--local spawn_area_ct = {["x1"] = 1551.220703125, ["y1"] = -1604.3779296875, ["x2"] = 1604.466796875, ["y2"] = -1631.052734375, ["z"] = 13.513515472412}


-- Chinatown
--local spawn_area_ct = {["x1"] = -2130.2783203125, ["y1"] = 624.5693359375, ["x2"] = -2152.8251953125, ["y2"] = 651.7109375, ["z"] = 52.3671875}
-- Supa Save
local spawn_area_ct = {["x1"] = -2420.09375, ["y1"] = 743.609375, ["x2"] = -2473.2666015625, ["y2"] = 723.6396484375, ["z"] = 35.015625}
-- SF Stadium
--local spawn_area_t = {["x1"] = -1994.1611328125, ["y1"] = -507.376953125, ["x2"] = -2039.8544921875, ["y2"] = -536.4833984375, ["z"] = 35.3359375}
-- SF Highway
local spawn_area_t = {["x1"] = -1962.8759765625, ["y1"] = -385.03515625, ["x2"] = -1986.375, ["y2"] = -357.6708984375, ["z"] = 25.7109375}

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
    position.x = math.random(math.min(radar_area.x1, radar_area.x2) + spawn_area_border, math.max(radar_area.x1, radar_area.x2) - spawn_area_border)
    position.y = math.random(math.min(radar_area.y1, radar_area.y2) + spawn_area_border, math.max(radar_area.y1, radar_area.y2) - spawn_area_border)
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
end

function respawn_players_for_team(team_name)
    local players = getPlayersInTeam(getTeamFromName(team_name))
    for i = 1, #players do
        local spawn_point = get_spawn_point(team_name)
        if isPedDead(players[i]) then
            spawn_player_for_team(players[i], team_name)
        else
            local weapon_status = get_player_weapon_status(players[i])
            spawn_player_for_team(players[i], team_name)
            set_player_weapon_status(players[i], weapon_status)
        end
    end
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
