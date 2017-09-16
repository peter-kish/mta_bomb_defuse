local ending_state_time = 5000;
local round_number = 0
local bomb_planted = false

local function fade_camera_to_black(player)
    fadeCamera(player, false, 1, 0, 0, 0)
end

local function trigger_round_end(winning_team_name)
    for i,player in ipairs(getElementsByType("player")) do
        round_number = round_number + 1
        triggerEvent("onRoundEnd", player, winning_team_name)
        fadeCamera(player, true, 1, 0, 0, 0)
    end
end

local function player_wasted_handler()
    local alive_ct_count = get_team_alive_count(getTeamFromName(team_ct_name))
    local alive_t_count = get_team_alive_count(getTeamFromName(team_t_name))

    for i,player in ipairs(getElementsByType("player")) do
        if alive_ct_count == 0 then
            triggerEvent("onRoundEnding", player, team_t_name)
            setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
        elseif (alive_t_count == 0) and (bomb_planted == false) then
            triggerEvent("onRoundEnding", player, team_ct_name)
            setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
        end
    end
    if alive_ct_count == 0 then
        setTimer(trigger_round_end, ending_state_time, 1, team_t_name)
    elseif (alive_t_count == 0) and (bomb_planted == false) then
        setTimer(trigger_round_end, ending_state_time, 1, team_ct_name)
    end
end

local function bomb_exploded_handler()
    for i,player in ipairs(getElementsByType("player")) do
        triggerEvent("onRoundEnding", player, team_t_name)
        setTimer(fade_camera_to_black, ending_state_time - 1000, 1, player)
    end
    setTimer(trigger_round_end, ending_state_time, 1, team_t_name)
end

local function bomb_defused_handler(player)
    for i,player in ipairs(getElementsByType("player")) do
        triggerEvent("onRoundEnding", player, team_ct_name)
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
addEventHandler("onBombExploded", getRootElement(), bomb_exploded_handler)
addEventHandler("onBombDefused", getRootElement(), bomb_defused_handler)
addEventHandler("onBombPlanted", getRootElement(), bomb_planted_handler)
addEventHandler("onRoundStart", getRootElement(), round_start_handler)