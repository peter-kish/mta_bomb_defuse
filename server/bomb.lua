local bomb_carrier = nil

local bomb_dropped_col = nil
local bomb_dropped_obj = nil

local bomb_planted_col = nil
local bomb_planted_obj = nil

-- Test site
--local bomb_site_a = {["x1"] = 2036.966796875, ["y1"] = -1682.4130859375, ["x2"] = 2046.388671875, ["y2"] = -1662.7763671875, ["z"] = 13.546875}

-- LS Gas Station
local bomb_site_a = {["x1"] = 1950.7734375, ["y1"] = -1782.8076171875, ["x2"] = 1932.1337890625, ["y2"] = -1762.2880859375, ["z"] = 13.546875}
-- LS Hospital
local bomb_site_b = {["x1"] = 2022.2958984375, ["y1"] = -1403.640625, ["x2"] = 2037.2802734375, ["y2"] = -1435.4267578125, ["z"] = 17.181692123413}

local bomb_site_a_blip = createBlip((bomb_site_a.x1 + bomb_site_a.x2) / 2, (bomb_site_a.y1 + bomb_site_a.y2) / 2, bomb_site_a.z, 41)
local bomb_site_b_blip = createBlip((bomb_site_b.x1 + bomb_site_b.x2) / 2, (bomb_site_b.y1 + bomb_site_b.y2) / 2, bomb_site_b.z, 41)

local bomb_timer = nil
local bomb_time = 30000
local bomb_radius = 10
local bomb_strength = 10
local bomb_explosion_delay = 250
local countdown_timer = nil;
local countdown = 0

local radar_area_bomb_site_a = createRadarArea(math.min(bomb_site_a.x1, bomb_site_a.x2),
    math.min(bomb_site_a.y1, bomb_site_a.y2),
    math.abs(bomb_site_a.x1 - bomb_site_a.x2),
    math.abs(bomb_site_a.y1 - bomb_site_a.y2),
    0, 255, 0, 128)
local radar_area_bomb_site_b = createRadarArea(math.min(bomb_site_b.x1, bomb_site_b.x2),
    math.min(bomb_site_b.y1, bomb_site_b.y2),
    math.abs(bomb_site_b.x1 - bomb_site_b.x2),
    math.abs(bomb_site_b.y1 - bomb_site_b.y2),
    0, 255, 0, 128)

local function create_dropped_bomb(x, y, z)
    bomb_dropped_obj = createObject(2891, x, y, z)
    bomb_dropped_col = createColSphere(x, y, z, 2)
    attachElements(bomb_dropped_obj, bomb_dropped_col)
end

local function remove_dropped_bomb()
    if bomb_dropped_obj then
        destroyElement(bomb_dropped_obj)
        bomb_dropped_obj = nil
    end
    if bomb_dropped_col then
        destroyElement(bomb_dropped_col)
        bomb_dropped_col = nil
    end
end

local function create_planted_bomb(x, y, z)
    bomb_planted_obj = createObject(2891, x, y, z)
    bomb_planted_col = createColSphere(x, y, z, 3)
    attachElements(bomb_planted_obj, bomb_planted_col)
end

local function remove_planted_bomb()
    if bomb_planted_obj then
        destroyElement(bomb_planted_obj)
        bomb_planted_obj = nil
    end
    if bomb_planted_col then
        destroyElement(bomb_planted_col)
        bomb_planted_col = nil
    end
end

local function round_start_handler()
    local terrorist = getPlayersInTeam(getTeamFromName(team_t_name))
    remove_dropped_bomb()
    remove_planted_bomb()
    if #terrorist > 0 then
        local random_player_index = math.random(1, #terrorist)
        bomb_carrier = terrorist[random_player_index]
        outputChatBox("You have the bomb!", bomb_carrier, 255, 0 ,0)
    end
end

local function random_explosion(x, y, z, radius)
    local angle = math.random(0, 359)
    local delta_x = math.cos(angle) * radius
    local delta_y = math.sin(angle) * radius
    createExplosion(x + delta_x, y + delta_y, z, 0)
end

local function multi_explosion(x, y, z, n, radius)
    createExplosion(x, y, z, 0)
    if n > 1 then
        setTimer(function() random_explosion(x, y, z, radius) end, bomb_explosion_delay, n - 1)
    end
end

local function bomb_explode()
    local x, y, z = getElementPosition(bomb_planted_obj)

    remove_planted_bomb()
    
    multi_explosion(x, y, z, bomb_strength, bomb_radius)
    for i,p in ipairs(getElementsByType("player")) do
        triggerEvent("onBombExploded", p)
    end
    
    bomb_timer = nil
end

local function bombCountdown()
    countdown = countdown - 1
    outputChatBox("Bomb: " .. countdown, getRootElement(), 255, 0, 0)
end

local function startBombCountdown(count)
    countdown = count
    outputChatBox("Bomb: " .. countdown, getRootElement(), 255, 0, 0)
    countdown_timer = setTimer(bombCountdown, 1000, count)
end

local function is_on_bomb_site(x, y)
    return (isInsideRadarArea(radar_area_bomb_site_a, x, y) or isInsideRadarArea(radar_area_bomb_site_b, x, y))
end

local function plant_bomb(player)
    if player == bomb_carrier then
        if not isPedInVehicle(player) then
            local player_x, player_y, player_z = getElementPosition(player)
            if is_on_bomb_site(player_x, player_y) then
                create_planted_bomb(player_x, player_y, player_z)
                outputChatBox("The bomb has been planted!", getRootElement(), 255, 0, 0)
                bomb_carrier = nil
                
                bomb_timer = setTimer(bomb_explode, bomb_time, 1)
                
                for i,p in ipairs(getElementsByType("player")) do
                    triggerEvent("onBombPlanted", p)
                    if bomb_time >= 10000 then
                        countdown_timer = setTimer(startBombCountdown, bomb_time - 10000, 1, 10)
                    end
                end
            else
                outputChatBox("You have to be on a bomb site to plant the bomb!", player)
            end
        else
            outputChatBox("Leave the vehicle to plant the bomb!", player)
        end
    else
        outputChatBox("You don't have the bomb!", player)
    end
end

local function defuse_bomb(player)
    if not isPedInVehicle(player) then
        if bomb_planted_col and isElementWithinColShape(player, bomb_planted_col) then
            outputChatBox("The bomb has defused!", getRootElement(), 255, 0, 0)
            
            remove_planted_bomb()
            if bomb_timer then
                killTimer(bomb_timer)
                bomb_timer = nil
            end
            if countdown_timer then
                killTimer(countdown_timer)
                countdown_timer = nil
            end
            
            for i,p in ipairs(getElementsByType("player")) do
                triggerEvent("onBombDefused", p, player)
            end
        else
            outputChatBox("You have to be near the bomb to defuse!", player)
        end
    else
        outputChatBox("Leave the vehicle to defuse the bomb!", player)
    end
end

local function plant_defuse_bomb(player)
    team_name = getTeamName(getPlayerTeam(player))
    if team_name == team_t_name then
        plant_bomb(player)
    elseif team_ct_name then
        defuse_bomb(player)
    end
end

local function player_wasted_handler()
    if source == bomb_carrier then
        local terrorist = getPlayersInTeam(getTeamFromName(team_t_name))
        for i,player in ipairs(terrorist) do
            outputChatBox(getPlayerName(bomb_carrier) .. " has dropped the bomb!", player, 255, 0 ,0)
        end
        bomb_carrier = nil

        local player_x, player_y, player_z = getElementPosition(source)
        create_dropped_bomb(player_x, player_y, player_z)
        triggerEvent("onBombDropped", source, bomb_dropped_obj)
    end
end

local function col_shape_handler(player, dimension)
    if (source == bomb_dropped_col) and (getElementType(player) == "player") then
        if (getTeamName(getPlayerTeam(player)) == team_t_name) and (not isPedDead(player)) then
            bomb_carrier = player
            for i, terrorist in ipairs(getPlayersInTeam(getTeamFromName(team_t_name))) do
                outputChatBox(getPlayerName(player) .. " picked up the bomb", terrorist, 255, 0 ,0)
            end
            remove_dropped_bomb()
            triggerEvent("onBombPickedUp", player)
        end
    end
end

local function round_end_handler(winning_team_name)
    -- Clean up the bomb elements
    remove_dropped_bomb()
    remove_planted_bomb()
    -- Kill the timer, just in case
    if bomb_timer then
        killTimer(bomb_timer)
        bomb_timer = nil
    end
end

local function join_handler()
    bindKey(source, "F5", "down", function (key_presser) plant_defuse_bomb(key_presser) end)
end

addEventHandler("onRoundStart", getRootElement(), round_start_handler )
addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onColShapeHit", getRootElement(), col_shape_handler)
addEventHandler("onRoundEnd", getRootElement(), round_end_handler)
addEventHandler("onPlayerJoin", getRootElement(), join_handler)