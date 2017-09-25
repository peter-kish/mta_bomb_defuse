local ending_state_time = 5000;
local round_number = 0
local bomb_planted = false
local game_state = "limbo" -- limbo/round_running/round_ending

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

local function end_round(winning_team_name)
    if game_state == "round_running" or game_state == "limbo" then
        game_state = "round_ending"
        setTimer(fade_everyone_to_black, ending_state_time - 1000, 1)
        triggerEvent("onRoundEnding", mtacs_element, winning_team_name)
        setTimer(trigger_round_start, ending_state_time, 1, winning_team_name)
    end
end

local function player_wasted_handler()
    local alive_ct_count = get_team_alive_count(getTeamFromName(team_ct_name))
    local alive_t_count = get_team_alive_count(getTeamFromName(team_t_name))

    if alive_ct_count == 0 then
        end_round(team_t_name)
    elseif (alive_t_count == 0) and (bomb_planted == false) then
        end_round(team_ct_name)
    end
    if alive_ct_count == 0 then
        end_round(team_t_name)
    elseif (alive_t_count == 0) and (bomb_planted == false) then
        end_round(team_ct_name)
    end
end

local function bomb_exploded_handler()
    end_round(team_t_name)
end

local function bomb_defused_handler(player)
    end_round(team_ct_name)
end

local function bomb_planted_handler()
    bomb_planted = true
end

local function round_start_handler()
    bomb_planted = false
end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onBombExploded", mtacs_element, bomb_exploded_handler)
addEventHandler("onBombDefused", mtacs_element, bomb_defused_handler)
addEventHandler("onBombPlanted", mtacs_element, bomb_planted_handler)
addEventHandler("onRoundStart", mtacs_element, round_start_handler)