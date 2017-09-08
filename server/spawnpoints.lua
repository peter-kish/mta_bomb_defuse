local spawnpoints_t = {
    {["x"] = 2001.912109375, ["y"] = -1672.9404296875, ["z"] = 13.3828125}
}

local spawnpoints_cs = {
    -- {x, y, z}
    {["x"] = 2081.4833984375, ["y"] = -1671.2314453125, ["z"] = 13.390607833862}
}

function get_random_element(array)
    return array[math.random(#array)]
end

function get_spawnpoint(team)
    if team == "ct" then
        return get_random_element(spawnpoints_cs)
    elseif team == "t" then
        return get_random_element(spawnpoints_t)
    else
        error("Bad team!")
    end
end

local function set_player_model(player, team)
    --outputServerLog("SERVER: Setting " .. team .. " player model for " .. getPlayerName(player), player)
    if team == "ct" then
        setElementModel(player, 285)
    elseif team == "t" then
        setElementModel(player, 312)
    else
        error("Bad team!")
    end
end

function spawn_player_for_team(player, team)
    local spawn_point = get_spawnpoint(team)
	spawnPlayer(player, spawn_point.x, spawn_point.y, spawn_point.z)
    
	fadeCamera(player, true)
	setCameraTarget(player, player)
    
    setPlayerHudComponentVisible(player, "clock", false)
    set_player_model(player, team)
    triggerEvent("onSpawn", player)
end