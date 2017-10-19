local screen_width, screen_height = guiGetScreenSize()  -- Get screen resolution.
local icon_size = 64 -- pixels
local blink = true
setTimer(function() blink = (not blink) end, 250, 0)

local function is_in_buy_zone()
    local team_name = getElementData(localPlayer, "team_name")
    if team_name then
        local radar_areas = getElementsByType("radararea")
        for i,area in ipairs(radar_areas) do
            local area_name = getElementData(area, "name")
            if area_name then
                local player_x, player_y = getElementPosition(localPlayer)
                if area_name == "spawn_area_t" and team_name == team_t_name then
                    if isInsideRadarArea(area, player_x, player_y) then
                        return true
                    end
                end
                if area_name == "spawn_area_ct" and team_name == team_ct_name then
                    if isInsideRadarArea(area, player_x, player_y) then
                        return true
                    end
                end
            end
        end
    end
    
    return false
end

local function has_bomb()
    local bomb = getElementData(localPlayer, "bomb")
    return (bomb == "BOMB")
end

local function is_on_bomb_site()
    local radar_areas = getElementsByType("radararea")
    for i,area in ipairs(radar_areas) do
        local area_name = getElementData(area, "name")
        if area_name then
            local player_x, player_y = getElementPosition(localPlayer)
            if area_name == "site_a" then
                if isInsideRadarArea(area, player_x, player_y) then
                    return true
                end
            end
            if area_name == "site_b" then
                if isInsideRadarArea(area, player_x, player_y) then
                    return true
                end
            end
        end
    end
    
    return false
end

local function draw_icons()
    if is_in_buy_zone() then
        dxDrawImage(0, screen_height/2, icon_size, icon_size, "client/icons/shopping_cart_logo.png", 0, 0, 0, tocolor(0, 200, 0, 255))
    end
    if has_bomb() then
        if is_on_bomb_site() and blink then
            dxDrawImage(0, screen_height/2 + icon_size, icon_size, icon_size, "client/icons/bomb_logo.png", 0, 0, 0, tocolor(200, 0, 0, 255))
        else
            dxDrawImage(0, screen_height/2 + icon_size, icon_size, icon_size, "client/icons/bomb_logo.png", 0, 0, 0, tocolor(0, 200, 0, 255))
        end
    end
end

function handle_the_rendering()
    addEventHandler("onClientRender", root, draw_icons)
end
addEventHandler("onClientResourceStart", resourceRoot, handle_the_rendering)