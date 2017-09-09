local team_t = {
    team_name = "t",
    desciption = "Terrorists",
    score = 0,
    members = {}
}
local team_ct = {
    team_name = "ct",
    desciption = "Counter-Terrorists",
    score = 0,
    members = {}
}

local function get_team_table(team_name)
    if team_name == "ct" then
        return team_ct
    elseif team_name == "t" then
        return team_t
    else
        error("Bad team: " .. team_name)
    end
end

local function get_opponent_team(team)
    if team == team_t then
        return team_ct
    elseif team == team_ct then
        return team_t
    else
        error("Bad team!")
    end
end

local function find_table_element(t, v)
    for i = 1, #t do
        if t[i] == v then
            return i
        end
    end
    
    return -1
end

local function get_team_table_for_player(player)
    if find_table_element(team_ct.members, player) >= 0 then
        return team_ct
    end
    if find_table_element(team_t.members, player) >= 0 then
        return team_t
    end
    
    return nil
end

local function get_team_size(team)
    return #team.members
end

local function remove_player_from_teams(player)
    local team_table = get_team_table_for_player(player)
    if team_table then
        table.remove(team_table.members, find_table_element(team_table.members, player))
    end
end

local function team_chosen_handler(team_name)
    remove_player_from_teams(source)
    local team_table = get_team_table(team_name)
    
    table.insert(team_table.members, source)
    outputChatBox("SERVER: Player " .. getPlayerName(source) .. " joined " .. team_table.desciption, source)
end

local function quit_handler()
    remove_player_from_teams(source)
end

local function get_team_alive_count(team)
    local counter = 0
    for i = 1, #team.members do
        if not isPedDead(team.members[i]) then
            counter = counter + 1
        end
    end
    return counter
end

local function respawn_players(team)
    for i = 1, #team.members do
        local spawn_point = get_spawn_point(team.team_name)
        if isPedDead(team.members[i]) then
            spawn_player_for_team(team.members[i], team.team_name)
        else
            local weapon_status = get_player_weapon_status(team.members[i])
            spawn_player_for_team(team.members[i], team.team_name)
            set_player_weapon_status(team.members[i], weapon_status)
        end
    end
end

local function team_add_money(team, money)
    for i = 1, #team.members do
        setPlayerMoney(team.members[i], getPlayerMoney(team.members[i]) + money)
    end
end

local function player_wasted_handler()
    local team_table = get_team_table_for_player(source)
    if get_team_alive_count(team_table) == 0 then
        local losing_team = team_table
        local winning_team = get_opponent_team(losing_team)
        outputChatBox("SERVER: Round is over! " .. winning_team.desciption .. " win!", source)
        winning_team.score = winning_team.score + 1
        
        team_add_money(losing_team, 400)
        team_add_money(winning_team, 800)
        
        respawn_players(team_ct)
        respawn_players(team_t)
    end
end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onPlayerQuit", getRootElement(), quit_handler)
addEventHandler("onTeamChosen", getRootElement(), team_chosen_handler )