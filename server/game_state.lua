local ending_state_time = 5000;
local round_number = 0
local bomb_planted = false
local game_state = "round_running" -- round_running/round_ending

-- Round time
local round_timer = nil
local round_time = 4 * 60 * 1000 -- 4min
local round_time_warning_time = 30 * 1000 -- 30sec
local round_time_warning_timer = nil
local round_time_display = textCreateDisplay()

local function kill_round_timer()
    if isTimer(round_timer) then
        killTimer(round_timer)
    end
    if isTimer(round_time_warning_timer) then
        killTimer(round_time_warning_timer)
    end
end

local function trigger_round_start(winning_team_name)
    round_number = round_number + 1
    triggerEvent("onRoundStart", mtacs_element, winning_team_name)
    for i,player in ipairs(getElementsByType("player")) do
        fadeCamera(player, true, 1, 0, 0, 0)
    end
    game_state = "round_running"
end

local function fade_everyone_to_black()
    for i,player in ipairs(getElementsByType("player")) do
        fadeCamera(player, false, 1, 0, 0, 0)
    end
end

local function end_round(winning_team_name, reason)
    if game_state == "round_running" then
        game_state = "round_ending"
        kill_round_timer()
        setTimer(fade_everyone_to_black, ending_state_time - 1000, 1)
        triggerEvent("onRoundEnding", mtacs_element, winning_team_name, reason)
        setTimer(trigger_round_start, ending_state_time, 1, winning_team_name)
    end
end

local function player_wasted_handler()
    local team = getPlayerTeam(source)
    local team_name = getTeamName(team)
    local teammates_left = get_team_alive_count(team)

    if teammates_left == 0 then
        if team_name == team_t_name and (bomb_planted == false) then
            end_round(team_ct_name, "ct_enemies_killed")
        elseif (team_name == team_ct_name) then
            end_round(team_t_name, "t_enemies_killed")
        end
    end
end

local function team_chosen_handler(team_name)
    local old_team = getPlayerTeam(source)
    
    if old_team then
        -- Team switch
        local new_team = getTeamFromName(team_name)
        if old_team == new_team then
            -- Team switch to the same team... do nothing
            return
        else
            -- Team switch to a new team
            killPed(source)
            setPlayerTeam(source, new_team)
            -- Restart the round if the new team was empty so far
            if countPlayersInTeam(new_team) == 1 then
                end_round(team_name, "round_restart")
            end
            return
        end
    else
        -- Initial team selection
        local n_t = countPlayersInTeam(getTeamFromName(team_t_name))
        local n_ct = countPlayersInTeam(getTeamFromName(team_ct_name))
        
        outputChatBox("SERVER: Player " .. getPlayerName(source) .. " joined " .. team_name, source)
        setPlayerTeam(source, getTeamFromName(team_name))
        
        if n_t == 0 and n_ct == 0 then
            triggerEvent("onRoundStart", mtacs_element)
        else
            spawn_player_for_team(source, team_name)
        end
    end
end

local function bomb_exploded_handler()
    end_round(team_t_name, "bomb_detonated")
end

local function bomb_defused_handler(player)
    end_round(team_ct_name, "bomb_defused")
end

local function bomb_planted_handler(bomber, bomb_time)
    bomb_planted = true
    kill_round_timer()
    round_timer = setTimer(function() end, bomb_time, 1)
    
    triggerClientEvent("onTimerStart", resourceRoot, bomb_time, 255, 0, 0, 255)
end

local function round_timeout()
    outputChatBox("Round time is up!", getRootElement(), 255, 0, 255)
    end_round(team_ct_name, "round_timeout")
    triggerEvent("onRoundTimeout", mtacs_element)
end

local function round_time_warning()
    outputChatBox("Warning! " .. round_time_warning_time / 1000 .. " seconds remaining!", getRootElement(), 255, 0, 255)
    
    triggerClientEvent("onTimerStart", resourceRoot, round_time_warning_time, 255, 0, 0, 255)
end

local function start_round_timer()
    kill_round_timer()
    round_timer = setTimer(round_timeout, round_time, 1)
    round_time_warning_timer = setTimer(round_time_warning, round_time - round_time_warning_time, 1)
    
    triggerClientEvent("onTimerStart", resourceRoot, round_time, 255, 255, 255, 255)
end

local function round_start_handler()
    bomb_planted = false
    start_round_timer()
    
    respawn_players_for_team(team_ct_name)
    respawn_players_for_team(team_t_name)
end

local function round_ending_handler(winning_team_name, reason)
    if reason == "round_restart" then
        outputChatBox("SERVER: Round will restart.", getRootElement(), 0, 200, 0)
        triggerClientEvent(getRootElement(), "onNotification", resourceRoot, "Round will restart...", 255, 255, 255, 255)
    else
        outputChatBox("SERVER: Round is over! " .. winning_team_name .. " win!", getRootElement(), 0, 200, 0)
        triggerClientEvent(getRootElement(), "onNotification", resourceRoot, winning_team_name .. " win!", 255, 255, 0, 255)
    end
end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onTeamChosen", getRootElement(), team_chosen_handler)
addEventHandler("onBombExploded", mtacs_element, bomb_exploded_handler)
addEventHandler("onBombDefused", mtacs_element, bomb_defused_handler)
addEventHandler("onBombPlanted", mtacs_element, bomb_planted_handler)
addEventHandler("onRoundStart", mtacs_element, round_start_handler)
addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)
