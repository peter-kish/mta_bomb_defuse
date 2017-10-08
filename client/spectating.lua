local spectate_timer = nil
local currently_spectating = nil

local function get_table_element_index(t, e)
    for i,element in ipairs(t) do
        if element == e then
            return i
        end
    end
    return false
end

local function get_viewable_players()
    local valid_players = {}
    local index = 1
    local players = getElementsByType("player")
    for i,player in ipairs(players) do
        if player ~= localPlayer and not isPedDead(player) then
            valid_players[index] = player
            index = index + 1
        end
    end
    return valid_players
end

local function spectate(player)
    --outputConsole("CLIENT: spectating.lua: Now watching: " .. getPlayerName(player))
    setCameraTarget(player)
    currently_spectating = player
    
    if isTimer(spectate_timer) then
        killTimer(spectate_timer)
    end
end

local function start_spectating()
    local viewable_players = get_viewable_players()
    if next(viewable_players) ~= nil then
        spectate(viewable_players[1])
    end
end

local function spectate_next()
    if isPedDead(localPlayer) then
        local viewable_players = get_viewable_players()
        local current_index = get_table_element_index(viewable_players, currently_spectating)
        if current_index then
            if #viewable_players > 1 then
                if current_index == #viewable_players then
                    spectate(viewable_players[1])
                else
                    spectate(viewable_players[current_index + 1])
                end
            end
        else
            if next(viewable_players) ~= nil then
                spectate(viewable_players[1])
            end
        end
    end
end

local function spectate_previous()
    if isPedDead(localPlayer) then
        local viewable_players = get_viewable_players()
        local current_index = get_table_element_index(viewable_players, currently_spectating)
        if current_index then
            if #viewable_players > 1 then
                if current_index == 1 then
                    spectate(viewable_players[#viewable_players])
                else
                    spectate(viewable_players[current_index - 1])
                end
            end
        else
            if next(viewable_players) ~= nil then
                spectate(viewable_players[1])
            end
        end
    end
end

local function player_wasted_handler()
    if source == localPlayer then
        spectate_timer = setTimer(start_spectating, 1000, 1)
    end
end

local function player_spawn_handler()
    if source == localPlayer then
        if isTimer(spectate_timer) then
            killTimer(spectate_timer)
        end
    end
end

bindKey("arrow_l", "down", spectate_previous)
bindKey("arrow_r", "down", spectate_next)

addEventHandler("onClientPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onClientPlayerSpawn", getRootElement(), player_spawn_handler)