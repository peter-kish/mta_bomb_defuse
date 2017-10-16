local bomb_blip = nil

local function destroy_bomb_blip()
    if isElement(bomb_blip) then
        destroyElement(bomb_blip)
        bomb_blip = nil
    end
end

local function setElementVisibleToTeam(element, team)
    if not isElement(element) then
        return false
    end

    setElementVisibleTo(element, getRootElement(), false)
    for i,player in ipairs(getPlayersInTeam(team)) do
        setElementVisibleTo(element, player, true)
    end
end

local function get_player_blip(player)
    if not isElement(player) then
        return false
    end

    for j,blip in ipairs(getAttachedElements(player)) do
        if getElementType(blip) == "blip" then
            return blip
        end
    end
    return nil
end

local function refresh_blips()
    local players = getElementsByType("player")
    for i,player in ipairs(players) do
        local blip = get_player_blip(player)
        setElementVisibleToTeam(blip, getPlayerTeam(player))
    end
end

local function player_wasted_handler()
    local blip = get_player_blip(source)
    setElementVisibleTo(blip, getRootElement(), false)
end

local function player_spawn_handler()
    local blip = get_player_blip(source)
    -- Creat the blip if needed
    if not isElement(blip) then
        blip = createBlipAttachedTo(source)
    end
    -- Show it to teammates only
    setElementVisibleToTeam(blip, getPlayerTeam(source))
    
    -- Set the blip color
    local player_team_name = getTeamName(getPlayerTeam(source))
    if player_team_name == team_t_name then
        setBlipColor(blip, 255, 0, 0, 255)
    elseif player_team_name == team_ct_name then
        setBlipColor(blip, 0, 0, 255, 255)
    end
    
    -- Refresh the blips for all players
    refresh_blips()
end

local function round_ending_handler()
    destroy_bomb_blip()
end

local function player_quit_handler()
    local blip = get_player_blip(source)
    if isElement(blip) then
        destroyElement(blip)
    end
end

local function bomb_dropped_handler(bomb_dropped_obj)
    local x, y, z = getElementPosition(bomb_dropped_obj)
    destroy_bomb_blip()
    bomb_blip = createBlip(x, y, z, 0, 2, 255, 255, 0, 255)
    setElementVisibleToTeam(bomb_blip, getTeamFromName(team_t_name))
end

local function bomb_planted_handler(bomber, bomb_time, bomb_planted_obj)
    local x, y, z = getElementPosition(bomb_planted_obj)
    destroy_bomb_blip()
    bomb_blip = createBlip(x, y, z, 0, 2, 255, 255, 0, 255)
    setElementVisibleToTeam(bomb_blip, getTeamFromName(team_t_name))
end

local function bomb_picked_up_handler(player)
    destroy_bomb_blip()
end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)
addEventHandler("onPlayerSpawn", getRootElement(), player_spawn_handler)
addEventHandler("onPlayerQuit", getRootElement(), player_quit_handler)
addEventHandler("onBombDropped", getRootElement(), bomb_dropped_handler)
addEventHandler("onBombPlanted", getRootElement(), bomb_planted_handler)
addEventHandler("onBombPickedUp", getRootElement(), bomb_picked_up_handler)

