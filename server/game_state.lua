addEvent("onRoundEnding", true)
addEvent("onRoundEnd", true)

local ending_state_time = 5000;
local round_number = 0

local function trigger_round_end(winning_team_name)
    for i,player in ipairs(getElementsByType("player")) do
        round_number = round_number + 1
        triggerEvent("onRoundEnd", player, winning_team_name)
    end
end

local function player_wasted_handler()
    local alive_ct_count = get_team_alive_count(get_team_table("ct"))
    local alive_t_count = get_team_alive_count(get_team_table("t"))

    for i,player in ipairs(getElementsByType("player")) do
        if alive_ct_count == 0 then
            triggerEvent("onRoundEnding", player, "t")
            setTimer(trigger_round_end, ending_state_time, 1, "t")
        elseif alive_t_count == 0 then
            triggerEvent("onRoundEnding", player, "ct")
            setTimer(trigger_round_end, ending_state_time, 1, "ct")
        end
    end
end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)