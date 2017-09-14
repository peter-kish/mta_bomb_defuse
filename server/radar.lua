local function setElementVisibleToTeam(element, team)
    setElementVisibleTo(element, getRootElement(), false)
    for i,player in ipairs(getPlayersInTeam(team)) do
        setElementVisibleTo(element, team, true)
    end
end

local function get_player_blip(player)
    for j,blip in ipairs(getAttachedElements(player)) do
        if getElementType(blip) == "blip" then
            return blip
        end
    end
    return nil
end

local function player_wasted_handler()
    local blip = get_player_blip(player)
    setElementVisibleTo(blip, getRootElement(), false)
end

local function round_start_handler()
    for i,player in ipairs(getElementsByType("player")) do
        local blip = get_player_blip(player)
        setElementVisibleToTeam(blip, getPlayerTeam(player))
        local player_team_name = getTeamName(getPlayerTeam(player))
        if player_team_name == team_t_name then
            setBlipColor(blip, 255, 0, 0, 255)
        elseif player_team_name == team_ct_name then
            setBlipColor(blip, 0, 0, 255, 255)
        end
    end
end

local function player_join_handler()
    local blip = createBlipAttachedTo(source)
    setElementVisibleTo(blip, getRootElement(), false)
end

local function player_quit_handler()
    for i,element in ipairs(getAttachedElements(source)) do
        destroyElement(element)
    end
end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onRoundStart", getRootElement(), round_start_handler)
addEventHandler("onPlayerJoin", getRootElement(), player_join_handler)
addEventHandler("onPlayerQuit", getRootElement(), player_quit_handler)