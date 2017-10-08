local max_vehicles_per_round = 2

local function vehicle_buy_handler(vehicle_name)
    if is_player_in_buy_zone(source) == false then
        outputChatBox("SERVER: Can't buy outside the buy zone!", source)
        return
    end
    
    if isPedDead(source) then
        outputChatBox("SERVER: Can't buy before respawn!", source)
        return
    end
    
    if getElementData(source, "vehicles_bought") >= max_vehicles_per_round then
        outputChatBox("SERVER: Can't buy more than " .. max_vehicles_per_round .. " vehicles per round.", source)
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
            
            -- Increase the vehicle counter
            setElementData(source, "vehicles_bought", getElementData(source, "vehicles_bought") + 1);
        else
            error("Not enough money!");
        end
    end
end

local function round_start_handler(winning_team_name)
    -- Clean up the vehicles
    local vehicles = getElementsByType("vehicle")
    for i,vehicle in ipairs(vehicles) do
        destroyElement(vehicle)
    end
end

local function player_spawn_handler()
    -- Reset the vehicle counters
    setElementData(source, "vehicles_bought", 0);
end

addEventHandler("onVehicleBuy", getRootElement(), vehicle_buy_handler )
addEventHandler("onRoundStart", mtacs_element, round_start_handler)
addEventHandler("onPlayerSpawn", getRootElement(), player_spawn_handler)