local function team_chosen_handler(team)
    --outputChatBox("SERVER: team chosen", source)
    spawn_player_for_team(source, team)
end

local function join_handler()
    triggerClientEvent (source, "onAskTeam", source)
    setPlayerMoney(source, 800, true)
    triggerClientEvent ("onMoneyChange", source, getPlayerMoney(source))
    
	outputChatBox("SERVER: Welcome to the MTA:Counter-Strike server", source)
    outputChatBox("SERVER: Press F3 to open the buy menu", source)
end

addEventHandler("onPlayerJoin", getRootElement(), join_handler)
addEventHandler("onTeamChosen", getRootElement(), team_chosen_handler )