setFPSLimit(60)

local function join_handler()
    setPlayerMoney(source, 800, true)
    triggerClientEvent ("onMoneyChange", source, getPlayerMoney(source))
    
	outputChatBox("SERVER: Welcome to the MTA:Counter-Strike server", source)
    outputChatBox("SERVER: Press B to open the buy menu", source)
    outputChatBox("SERVER: Press X to plant/defuse the bomb", source)
end

addEventHandler("onPlayerJoin", getRootElement(), join_handler)