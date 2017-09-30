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

local function round_ending_handler(winning_team_name, reason)
    if reason == "t_enemies_killed" then
        team_add_money(getTeamFromName(team_ct_name), 1400)
        team_add_money(getTeamFromName(team_t_name), 3250)
    elseif reason == "ct_enemies_killed" then
        team_add_money(getTeamFromName(team_t_name), 1400)
        team_add_money(getTeamFromName(team_ct_name), 3250)
    elseif reason == "bomb_detonated" then
        team_add_money(getTeamFromName(team_t_name), 3500)
        team_add_money(getTeamFromName(team_ct_name), 1400)
    elseif reason == "bomb_defused" then
        team_add_money(getTeamFromName(team_ct_name), 3500)
        team_add_money(getTeamFromName(team_t_name), 1400)
    elseif reason == "round_timeout" then
        team_add_money(getTeamFromName(team_ct_name), 3250)
        team_add_money(getTeamFromName(team_t_name), 1400)
    end
end

local function ped_wasted_handler(total_ammo, killer, killer_weapon, body_part, stealth)
    if killer and killer ~= source then
        give_player_money(killer, 300)
    end
end

addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)
addEventHandler("onPedWasted", getRootElement(), ped_wasted_handler)


