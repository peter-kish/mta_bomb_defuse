local ending_state_time = 5000;
local round_number = 0
local bomb_planted = false

local function fade_camera_to_black(player)
    fadeCamera(player, false, 1, 0, 0, 0)
end

local function trigger_round_end(winning_team_name)
    round_number = round_number + 1
    triggerEvent("onRoundEnd", mtacs_element, winning_team_name)
    for i,player in ipairs(getElementsByType("player")) do
        fadeCamera(player, true, 1, 0, 0, 0)
    end
end

local function player_wasted_handler()
    local alive_ct_count = get_team_alive_count(getTeamFromName(team_ct_name))
    local alive_t_count = get_team_alive_count(getTeamFromName(team_t_name))

    if alive_ct_count == 0 then
        triggerEvent("onRoundEnding", mtacs_element, team_t_name)
        for i,player in ipairs(getElementsByType("player")) do
            setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
        end
    elseif (alive_t_count == 0) and (bomb_planted == false) then
        triggerEvent("onRoundEnding", mtacs_element, team_ct_name)
        setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
    end
    if alive_ct_count == 0 then
        setTimer(trigger_round_end, ending_state_time, 1, team_t_name)
    elseif (alive_t_count == 0) and (bomb_planted == false) then
        setTimer(trigger_round_end, ending_state_time, 1, team_ct_name)
    end
end

local function bomb_exploded_handler()
    triggerEvent("onRoundEnding", mtacs_element, team_t_name)
    for i,player in ipairs(getElementsByType("player")) do
        setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
    end
    setTimer(trigger_round_end, ending_state_time, 1, team_t_name)
end

local function bomb_defused_handler(player)
    triggerEvent("onRoundEnding", mtacs_element, team_ct_name)
    for i,player in ipairs(getElementsByType("player")) do
        setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
    end
    setTimer(trigger_round_end, ending_state_time, 1, team_ct_name)
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