team_t = createTeam(team_t_name, 255, 119, 119)
team_ct = createTeam(team_ct_name, 125, 135, 255)

local function get_opponent_team(team)
    if team == team_t then
        return team_ct
    elseif team == team_ct then
        return team_t
    else
        error("Bad team!")
    end
end

local function team_chosen_handler(team_name)
    local n_t = countPlayersInTeam(getTeamFromName(team_t_name))
    local n_ct = countPlayersInTeam(getTeamFromName(team_ct_name))
    
    outputChatBox("SERVER: Player " .. getPlayerName(source) .. " joined " .. team_name, source)
    spawn_player_for_team(source, team_name)
    
    if n_t == 0 and n_ct == 0 then
        triggerEvent("onRoundStart", mtacs_element)
    end
end

function get_team_alive_count(team)
    local counter = 0
    local players = getPlayersInTeam(team)
    for i = 1, #players do
        if not isPedDead(players[i]) then
            counter = counter + 1
        end
    end
    return counter
end

local function respawn_players(team)
    local players = getPlayersInTeam(team)
    local team_name = getTeamName(team)
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

local function team_add_money(team, money)
    local players = getPlayersInTeam(team)
    for i = 1, #players do
        setPlayerMoney(players[i], getPlayerMoney(players[i]) + money)
        triggerClientEvent ("onMoneyChange", source, getPlayerMoney(players[i]))
    end
end

local function round_ending_handler(winning_team_name)
    outputChatBox("SERVER: Round is over! " .. winning_team_name .. " win!", getRootElement(), 0, 200, 0)
    
    local winning_team = getTeamFromName(winning_team_name)
    local losing_team = get_opponent_team(winning_team)
    
    --winning_team.score = winning_team.score + 1
    
    team_add_money(losing_team, 400)
    team_add_money(winning_team, 800)
end

local function round_start_handler(winning_team_name)    
    respawn_players(team_ct)
    respawn_players(team_t)
end

addEventHandler("onRoundStart", mtacs_element, round_start_handler)
addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)
addEventHandler("onTeamChosen", getRootElement(), team_chosen_handler )

