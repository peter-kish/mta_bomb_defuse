local bomb_carrier = nil

local bomb_dropped_col = nil
local bomb_dropped_obj = nil

local bomb_planted_col = nil
local bomb_planted_obj = nil

local bomb_site_a = get_current_map().bomb_site_a
local bomb_site_b = get_current_map().bomb_site_b

local bomb_site_a_blip = createBlip((bomb_site_a.x1 + bomb_site_a.x2) / 2, (bomb_site_a.y1 + bomb_site_a.y2) / 2, bomb_site_a.z, 41)
local bomb_site_b_blip = createBlip((bomb_site_b.x1 + bomb_site_b.x2) / 2, (bomb_site_b.y1 + bomb_site_b.y2) / 2, bomb_site_b.z, 41)

exports.scoreboard:addScoreboardColumn("bomb")

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
    
local bomb_timer = nil
local bomb_time = 120000
local bomb_radius = 10
local bomb_strength = 10
local bomb_explosion_delay = 250
local plant_timer = nil;
local plant_time = 3000
local defuse_timer = nil;
local defuse_time = 6000
local defuser = nil

local function create_dropped_bomb(x, y, z)
    bomb_dropped_obj = createObject(2891, x, y, z - 1)
    setElementCollisionsEnabled(bomb_dropped_obj, false)
    setElementFrozen(bomb_dropped_obj, true)
    bomb_dropped_col = createColSphere(x, y, z, 2)
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
    bomb_planted_obj = createObject(2891, x, y, z - 1)
    setElementCollisionsEnabled(bomb_planted_obj, false)
    setElementFrozen(bomb_planted_obj, true)
    bomb_planted_col = createColSphere(x, y, z, 3)
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

local function get_random_terrorist()
    local terrorists = getPlayersInTeam(getTeamFromName(team_t_name))
    if #terrorists > 0 then
        local random_player_index = math.random(1, #terrorists)
        return terrorists[random_player_index]
    end
    return false
end

local function give_bomb_to(player)
    if player then
        bomb_carrier = player
        setElementData(player, "bomb", "BOMB")
        outputChatBox("You have the bomb!", bomb_carrier, 255, 0 ,0)
    end
end

local function take_bomb()
    if bomb_carrier then
        setElementData(bomb_carrier, "bomb", "")
        bomb_carrier = nil
    end
end

local function round_start_handler()
    -- Clean up the bomb elements
    remove_dropped_bomb()
    remove_planted_bomb()
    -- Kill the timer, just in case
    if isTimer(bomb_timer) then
        killTimer(bomb_timer)
        bomb_timer = nil
    end
    
    -- Give the bomb to a random terrorist
    if bomb_carrier == nil then
        give_bomb_to(get_random_terrorist())
    end
end

local function round_ending_handler()
    take_bomb()
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
    
    if defuser then
        cancel_defuse_bomb(defuser)
    end

    remove_planted_bomb()
    
    multi_explosion(x, y, z, bomb_strength, bomb_radius)
    triggerEvent("onBombExploded", mtacs_element)
    
    bomb_timer = nil
end

local function is_on_bomb_site(x, y)
    return (isInsideRadarArea(radar_area_bomb_site_a, x, y) or isInsideRadarArea(radar_area_bomb_site_b, x, y))
end

local function plant_bomb(x, y, z)
    create_planted_bomb(x, y, z)
    outputChatBox("The bomb has been planted!", getRootElement(), 255, 0, 0)
    triggerClientEvent(bomb_carrier, "onPlantDefuseEnd", bomb_carrier)
    triggerEvent("onBombPlanted", mtacs_element, bomb_carrier, bomb_time, bomb_planted_obj)
    take_bomb()
    
    bomb_timer = setTimer(bomb_explode, bomb_time, 1)
end

local function start_plant_bomb(player)
    if player == bomb_carrier then
        if not isPedInVehicle(player) then
            local player_x, player_y, player_z = getElementPosition(player)
            if is_on_bomb_site(player_x, player_y) then
                --outputChatBox("Planting the bomb...", player)
                plant_timer = setTimer(plant_bomb, plant_time, 1, player_x, player_y, player_z)
                setPedAnimation(player, -- the player
                    "bomber",           -- animation block
                    "bom_plant_loop",   -- animation name
                    plant_time,         -- animation time
                    true,               -- loop
                    false,              -- don't update position
                    false,              -- not interruptable
                    false)              -- don't freeze last frame
                triggerClientEvent(player, "onPlantDefuseStart", player, plant_time)
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

local function cancel_plant_bomb(player)
    if plant_timer then
        if player == bomb_carrier then
            --outputChatBox("Planting canceled", player)
            if isTimer(plant_timer) then
                killTimer(plant_timer)
            end
            plant_timer = nil
            setPedAnimation(player)
            triggerClientEvent(player, "onPlantDefuseEnd", player)
        end
    end
end

local function defuse_bomb(player)
    outputChatBox("The bomb has defused!", getRootElement(), 255, 0, 0)
    triggerClientEvent(player, "onPlantDefuseEnd", player)
    
    defuser = nil
    remove_planted_bomb()
    if isTimer(bomb_timer) then
        killTimer(bomb_timer)
        bomb_timer = nil
    end
    
    triggerEvent("onBombDefused", mtacs_element, player)
end

local function start_defuse_bomb(player)
    if not isPedInVehicle(player) then
        if bomb_planted_col and isElementWithinColShape(player, bomb_planted_col) then
            --defuse_bomb(player)
            if defuser == nil then
                --outputChatBox("Defusing the bomb...", player)
                defuser = player
                defuse_timer = setTimer(defuse_bomb, defuse_time, 1, player)
                setPedAnimation(player, -- the player
                    "bomber",           -- animation block
                    "bom_plant_loop",   -- animation name
                    defuse_time,        -- animation time
                    true,               -- loop
                    false,              -- don't update position
                    false,              -- not interruptable
                    false)              -- don't freeze last frame
                triggerClientEvent(player, "onPlantDefuseStart", player, defuse_time)
            end
        else
            outputChatBox("You have to be near the bomb to defuse!", player)
        end
    else
        outputChatBox("Leave the vehicle to defuse the bomb!", player)
    end
end

local function cancel_defuse_bomb(player)
    if defuse_timer then
        if player == defuser then
            --outputChatBox("Defusing canceled", player)
            triggerClientEvent(player, "onPlantDefuseEnd", player)
            defuser = nil
            if defuse_timer then
                killTimer(defuse_timer)
                defuse_timer = nil
            end
            setPedAnimation(player)
        end
    end
end

local function start_plant_defuse_bomb(player)
    team_name = getTeamName(getPlayerTeam(player))
    if team_name == team_t_name then
        start_plant_bomb(player)
    elseif team_ct_name then
        start_defuse_bomb(player)
    end
end

local function cancel_plant_defuse_bomb(player)
    team_name = getTeamName(getPlayerTeam(player))
    if team_name == team_t_name then
        cancel_plant_bomb(player)
    elseif team_ct_name then
        cancel_defuse_bomb(player)
    end
end

local function player_wasted_handler()
    if source == bomb_carrier then
        cancel_plant_bomb(bomb_carrier)
        for i,player in ipairs(getPlayersInTeam(getTeamFromName(team_t_name))) do
            outputChatBox(getPlayerName(bomb_carrier) .. " has dropped the bomb!", player, 255, 0 ,0)
        end
        take_bomb()

        local player_x, player_y, player_z = getElementPosition(source)
        create_dropped_bomb(player_x, player_y, player_z)
        triggerEvent("onBombDropped", source, bomb_dropped_obj)
    end
    if source == defuser then
        cancel_defuse_bomb(defuser)
    end
end

local function player_spawn_handler()
    local team = getPlayerTeam(source)
    if getTeamName(team) == team_t_name and countPlayersInTeam(team) == 1 then
        -- The player joined T and is the only player in the team
        if (bomb_carrier == nil) and (bomb_dropped_obj == nil) and (bomb_planted_obj == nil) then
            -- The bomb is not owned by anyone, is not dropped somewhere on the map and is not planted
            give_bomb_to(source)
        end
    end
end

local function col_shape_handler(player, dimension)
    if (source == bomb_dropped_col) and (getElementType(player) == "player") then
        if (getTeamName(getPlayerTeam(player)) == team_t_name) and (not isPedDead(player)) then
            for i, terrorist in ipairs(getPlayersInTeam(getTeamFromName(team_t_name))) do
                outputChatBox(getPlayerName(player) .. " picked up the bomb", terrorist, 255, 0 ,0)
            end
            give_bomb_to(player)
            remove_dropped_bomb()
            triggerEvent("onBombPickedUp", player)
        end
    end
end

local function join_handler()
    bindKey(source, "x", "down", function (key_presser) start_plant_defuse_bomb(key_presser) end)
    bindKey(source, "x", "up", function (key_presser) cancel_plant_defuse_bomb(key_presser) end)
    setElementData(source, "bomb", "")
end

local function quit_handler()
    if source == bomb_carrier then
        cancel_plant_bomb(bomb_carrier)
        
        -- Drop the bomb
        for i,player in ipairs(getPlayersInTeam(getTeamFromName(team_t_name))) do
            outputChatBox(getPlayerName(bomb_carrier) .. " has dropped the bomb!", player, 255, 0 ,0)
        end
        take_bomb()

        local player_x, player_y, player_z = getElementPosition(source)
        create_dropped_bomb(player_x, player_y, player_z)
        triggerEvent("onBombDropped", source, bomb_dropped_obj)
    end
    if source == defuser then
        cancel_defuse_bomb(defuser)
    end
end

local function new_map_handler()
    bomb_site_a = get_current_map().bomb_site_a
    bomb_site_b = get_current_map().bomb_site_b

    destroyElement(bomb_site_a_blip)
    destroyElement(bomb_site_b_blip)
    bomb_site_a_blip = createBlip((bomb_site_a.x1 + bomb_site_a.x2) / 2, (bomb_site_a.y1 + bomb_site_a.y2) / 2, bomb_site_a.z, 41)
    bomb_site_b_blip = createBlip((bomb_site_b.x1 + bomb_site_b.x2) / 2, (bomb_site_b.y1 + bomb_site_b.y2) / 2, bomb_site_b.z, 41)

    destroyElement(radar_area_bomb_site_a)
    destroyElement(radar_area_bomb_site_b)
    radar_area_bomb_site_a = createRadarArea(math.min(bomb_site_a.x1, bomb_site_a.x2),
        math.min(bomb_site_a.y1, bomb_site_a.y2),
        math.abs(bomb_site_a.x1 - bomb_site_a.x2),
        math.abs(bomb_site_a.y1 - bomb_site_a.y2),
        0, 255, 0, 128)
    radar_area_bomb_site_b = createRadarArea(math.min(bomb_site_b.x1, bomb_site_b.x2),
        math.min(bomb_site_b.y1, bomb_site_b.y2),
        math.abs(bomb_site_b.x1 - bomb_site_b.x2),
        math.abs(bomb_site_b.y1 - bomb_site_b.y2),
        0, 255, 0, 128)
end

addEventHandler("onRoundStart", mtacs_element, round_start_handler)
addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)
addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
addEventHandler("onPlayerSpawn", getRootElement(), player_spawn_handler)
addEventHandler("onColShapeHit", getRootElement(), col_shape_handler)
addEventHandler("onPlayerJoin", getRootElement(), join_handler)
addEventHandler("onPlayerQuit", getRootElement(), quit_handler)
addEventHandler("onNewMap", getRootElement(), new_map_handler)
