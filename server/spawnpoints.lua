local spawn_area_border = 1

function get_random_element(array)
    return array[math.random(#array)]
end

local spawn_area_ct = get_current_map().spawn_area_ct
local spawn_area_t = get_current_map().spawn_area_t

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

local function new_map_handler()
    spawn_area_ct = get_current_map().spawn_area_ct
    spawn_area_t = get_current_map().spawn_area_t
    
    destroyElement(radar_area_t)
    destroyElement(radar_area_ct)
    radar_area_t = createRadarArea(math.min(spawn_area_t.x1, spawn_area_t.x2),
        math.min(spawn_area_t.y1, spawn_area_t.y2),
        math.abs(spawn_area_t.x1 - spawn_area_t.x2),
        math.abs(spawn_area_t.y1 - spawn_area_t.y2),
        255, 0, 0, 128)
    
    radar_area_ct = createRadarArea(math.min(spawn_area_ct.x1, spawn_area_ct.x2),
        math.min(spawn_area_ct.y1, spawn_area_ct.y2),
        math.abs(spawn_area_ct.x1 - spawn_area_ct.x2),
        math.abs(spawn_area_ct.y1 - spawn_area_ct.y2),
        0, 0, 255, 128)
end

addEventHandler("onNewMap", mtacs_element, new_map_handler)
