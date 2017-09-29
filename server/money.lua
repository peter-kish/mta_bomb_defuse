local function give_player_money(player, money)
    setPlayerMoney(player, getPlayerMoney(player) + money)
    triggerClientEvent (player, "onMoneyChange", source, getPlayerMoney(player))
end

local function team_add_money(team, money)
    local players = getPlayersInTeam(team)
    for i = 1, #players do
        give_player_money(players[i], money)
    end
end

local function round_ending_handler(winning_team_name)
    local winning_team = getTeamFromName(winning_team_name)
    local losing_team = get_opponent_team(winning_team)
    
    team_add_money(losing_team, 400)
    team_add_money(winning_team, 800)
end

local function bomb_exploded_handler()
    team_add_money(getTeamFromName(team_t_name), 1000)
end

local function bomb_defused_handler()
    team_add_money(getTeamFromName(team_ct_name), 1000)
end

local function ped_wasted_handler(total_ammo, killer, killer_weapon, body_part, stealth)
    if killer and killer ~= source then
        give_player_money(killer, 300)
    end
end

addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)
addEventHandler("onBombExploded", mtacs_element, bomb_exploded_handler)
addEventHandler("onBombDefused", mtacs_element, bomb_defused_handler)
addEventHandler("onPedWasted", getRootElement(), ped_wasted_handler)


