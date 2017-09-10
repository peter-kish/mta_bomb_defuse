local function vehicle_buy_handler(vehicle_name)
    if is_player_in_buy_zone(source) == false then
        outputChatBox("SERVER: Can't buy outside the buy zone!", source)
        return
    end
    
    if isPedDead(source) then
        outputChatBox("SERVER: Can't buy before respawn!", source)
        return
    end
    
    local vehicle_info = get_vehicle_info(vehicle_name)
    if vehicle_info then
        --outputChatBox("SERVER: vehicle_buy_handler: Buying " .. vehicle_info.name, source)
        if getPlayerMoney(source) >= vehicle_info.cost then
            local player_x, player_y, player_z = getElementPosition(source)
            local vehicle = createVehicle(vehicle_info.ID, player_x, player_y, player_z)
            warpPedIntoVehicle(source, vehicle)
            
            setPlayerMoney(source, getPlayerMoney(source) - vehicle_info.cost)
            triggerClientEvent ("onMoneyChange", source, getPlayerMoney(source))
        else
            error("Not enough money!");
        end
    end
end

local function round_end_handler(winning_team_name)
    -- Clean up the vehicles
    outputChatBox("SERVER: Cleaning up the vehicles...", source)
    local vehicles = getElementsByType("vehicle")
    for i,vehicle in ipairs(vehicles) do
        destroyElement(vehicle)
    end
end

addEventHandler("onVehicleBuy", getRootElement(), vehicle_buy_handler )
addEventHandler("onRoundEnd", getRootElement(), round_end_handler)