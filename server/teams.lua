local team_t = {
    team_name = "t",
    desciption = "Terrorists",
    score = 0,
    members = {},
    mta_team = createTeam("Terrorists", 255, 119, 119)
}
local team_ct = {
    team_name = "ct",
    desciption = "Counter-Terrorists",
    score = 0,
    members = {},
    mta_team = createTeam("Counter-Terrorists", 125, 135, 255)
}
local team_spec = {
    team_name = "spec",
    desciption = "Spectators",
    score = 0,
    members = {},
    mta_team = createTeam("Spectators", 255, 255, 255)
}

function get_team_table(team_name)
    if team_name == "ct" then
        return team_ct
    elseif team_name == "t" then
        return team_t
    elseif team_name == "spec" then
        return team_spec
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

function get_team_table_for_player(player)
    if find_table_element(team_ct.members, player) >= 0 then
        return team_ct
    end
    if find_table_element(team_t.members, player) >= 0 then
        return team_t
    end
    if find_table_element(team_spec.members, player) >= 0 then
        return team_spec
    end
    
    return nil
end

function get_team_name_for_player(player)
    if find_table_element(team_ct.members, player) >= 0 then
        return team_ct.team_name
    end
    if find_table_element(team_t.members, player) >= 0 then
        return team_t.team_name
    end
    if find_table_element(team_spec.members, player) >= 0 then
        return team_spec.team_name
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
    spawn_player_for_team(source, team_name)
end

local function quit_handler()
    remove_player_from_teams(source)
end

function get_team_alive_count(team)
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
        triggerClientEvent ("onMoneyChange", source, getPlayerMoney(source))
    end
end

local function round_ending_handler(winning_team_name)
    outputChatBox("SERVER: Round is over! " .. get_team_table(winning_team_name).desciption .. " win!", source)
end

local function round_end_handler(winning_team_name)
    local winning_team = get_team_table(winning_team_name)
    local losing_team = get_opponent_team(winning_team)
    
    winning_team.score = winning_team.score + 1
    
    team_add_money(losing_team, 400)
    team_add_money(winning_team, 800)
    
    respawn_players(team_ct)
    respawn_players(team_t)
end

addEventHandler("onRoundEnd", getRootElement(), round_end_handler)
addEventHandler("onRoundEnding", getRootElement(), round_ending_handler)
addEventHandler("onPlayerQuit", getRootElement(), quit_handler)
addEventHandler("onTeamChosen", getRootElement(), team_chosen_handler )