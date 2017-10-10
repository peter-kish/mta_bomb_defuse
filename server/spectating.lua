local function get_table_element_index(t, e)
    for i,element in ipairs(t) do
        if element == e then
            return i
        end
    end
    return false
end

local function get_viewable_players(player)
    local valid_players = {}
    local index = 1
    local team = getPlayerTeam(player)
    if team then
        local players = getPlayersInTeam(getPlayerTeam(player))
        for i,teammate in ipairs(players) do
            if teammate ~= player and not isPedDead(teammate) then
                valid_players[index] = teammate
                index = index + 1
            end
        end
        return valid_players
    end
end

local function spectate(player, teammate)
    --outputConsole("CLIENT: spectating.lua: Now watching: " .. getPlayerName(player), player)
    setCameraTarget(player, teammate)
end

local function spectate_next(player)
    if isPedDead(player) then
        --outputConsole("CLIENT: spectating.lua: Next...", player)
        local viewable_players = get_viewable_players(player)
        local current_index = get_table_element_index(viewable_players, getCameraTarget(player))
        if current_index then
            -- Already watching a viewable player
            if #viewable_players > 1 then
                if current_index == #viewable_players then
                    spectate(player, viewable_players[1])
                else
                    spectate(player, viewable_players[current_index + 1])
                end
            end
        else
            -- Not watching any of the viewable players
            if next(viewable_players) ~= nil then
                spectate(player, viewable_players[1])
            end
        end
    end
end

local function spectate_previous(player)
    if isPedDead(player) then
        --outputConsole("CLIENT: spectating.lua: Previous...", player)
        local viewable_players = get_viewable_players(player)
        local current_index = get_table_element_index(viewable_players, getCameraTarget(player))
        if current_index then
            -- Already watching a viewable player
            if #viewable_players > 1 then
                if current_index == 1 then
                    spectate(player, viewable_players[#viewable_players])
                else
                    spectate(player, viewable_players[current_index - 1])
                end
            end
        else
            -- Not watching any of the viewable players
            if next(viewable_players) ~= nil then
                spectate(player, viewable_players[1])
            end
        end
    end
end

local function join_handler()
    bindKey(source, "arrow_l", "down", spectate_previous)
    bindKey(source, "arrow_r", "down", spectate_next)

    --bindKey(source, "mouse1", "down", spectate_previous)
    --bindKey(source, "mouse2", "down", spectate_next)
end

local function quit_handler()
    local all_players = getElementsByType("player")
    for i,player in ipairs(all_players) do
        if isPedDead(player) then
            if getCameraTarget(player) == source then
                spectate_next(player)
            end
        end
    end
end

addEventHandler("onPlayerJoin", getRootElement(), join_handler)
addEventHandler("onPlayerQuit", getRootElement(), quit_handler)
