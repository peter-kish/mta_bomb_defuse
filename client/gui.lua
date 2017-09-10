addEvent("onAskTeam", true)
addEvent("onMoneyChange", true)

local gui_wdw_team = nil
local gui_wdw_buy = nil
local gui_weapon_buttons = {}

local function open_dialog(dialog)
    if (dialog ~= nil) then
        guiSetVisible(dialog, true)
        showCursor(true)
        guiSetInputEnabled(true)
    else
        error("GUI - Dialog not created!")
    end
end

local function close_dialog(dialog)
    if (dialog ~= nil) then
        guiSetVisible(dialog, false)
        showCursor(false)
        guiSetInputEnabled(false)
    else
        error("GUI - Dialog not created!")
    end
end

local function toggle_dialog(dialog)
    if (dialog ~= nil) then
        if guiGetVisible(dialog) then
            -- if visible, hide it
            close_dialog(dialog)
        else
            -- if hidden, show it
            open_dialog(dialog)
        end
    else
        error("GUI - Dialog not created!")
    end
end

local function choose_team_ct()
    --outputChatBox("CT chosen", client)
    triggerServerEvent("onTeamChosen", localPlayer, team_ct_name)
    close_dialog(gui_wdw_team)
end

local function choose_team_t()
    --outputChatBox("T chosen", client)
    triggerServerEvent("onTeamChosen", localPlayer, team_t_name)
    close_dialog(gui_wdw_team)
end

local function buy_weapon()
    triggerServerEvent("onWeaponBuy", localPlayer, guiGetText(source))
end

local function buy_close()
    close_dialog(gui_wdw_buy)
end

local function refresh_weapon_buttons(money)
    local player_team = getPlayerTeam(localPlayer)
    local player_team_name = ""
    if player_team then
        player_team_name = getTeamName(player_team)
    end
    for i, button in ipairs(gui_weapon_buttons) do
        local weapon = get_weapon_info(guiGetText(button))
        if weapon and weapon.cost > money then
            guiSetEnabled(button, false)
        else
            guiSetEnabled(button, true)
        end
        
        if player_team then
            if (weapon.team ~= "all") and (weapon.team ~= player_team_name) then
                guiSetEnabled(button, false)
            end
        end
    end
end

local function show_buy_dialog()
    --outputChatBox("show_buy_dialog", client)
    local player_team = getPlayerTeam(localPlayer)
    if (player_team) and (not isPedDead(localPlayer)) then
        toggle_dialog(gui_wdw_buy)
        refresh_weapon_buttons(getPlayerMoney(localPlayer))
    end
end

local function show_team_dialog()
    --outputChatBox("show_team_dialog", client)
    open_dialog(gui_wdw_team)
end

local function create_choose_team_dialog()
    gui_wdw_team = guiCreateWindow(0.25, 0.25, 0.5, 0.5, "Choose a team", true)
    guiWindowSetSizable(gui_wdw_team, false)
    local gui_btn_ct = guiCreateButton(0.1, 0.1, 0.3, 0.8, team_ct_name, true, gui_wdw_team)
    local gui_btn_t = guiCreateButton(0.6, 0.1, 0.3, 0.8, team_t_name, true, gui_wdw_team)
    
    addEventHandler("onClientGUIClick", gui_btn_ct, choose_team_ct, false)
    addEventHandler("onClientGUIClick", gui_btn_t, choose_team_t, false)
end

local function create_buy_menu_dialog()
    gui_wdw_buy = guiCreateWindow(0.25, 0.25, 0.5, 0.5, "Buy Menu", true)
    guiWindowSetSizable(gui_wdw_buy, false)
    local button_index = 0
    
    guiCreateLabel(0.05, 0.05, 0.2, 0.1, "Primary", true, gui_wdw_buy)
    for i = 1, get_weapon_count() do
        local weapon = get_weapon_info_by_index(i)
        if weapon.slot == "primary_slot" then
            local button = guiCreateButton(0.05, 0.1 + button_index * 0.15, 0.2, 0.1, weapon.name, true, gui_wdw_buy)
            button_index = button_index + 1
            addEventHandler("onClientGUIClick", button, buy_weapon, false)
            table.insert(gui_weapon_buttons, button)
        end
    end
    
    button_index = 0
    guiCreateLabel(0.3, 0.05, 0.2, 0.1, "Secondary", true, gui_wdw_buy)
    for i = 1, get_weapon_count() do
        local weapon = get_weapon_info_by_index(i)
        if weapon.slot == "secondary_slot" then
            local button = guiCreateButton(0.3, 0.1 + button_index * 0.15, 0.2, 0.1, weapon.name, true, gui_wdw_buy)
            button_index = button_index + 1
            addEventHandler("onClientGUIClick", button, buy_weapon, false)
            table.insert(gui_weapon_buttons, button)
        end
    end
    
    button_index = 0
    guiCreateLabel(0.55, 0.05, 0.2, 0.1, "Special", true, gui_wdw_buy)
    for i = 1, get_weapon_count() do
        local weapon = get_weapon_info_by_index(i)
        if weapon.slot == "special_slot" then
            local button = guiCreateButton(0.55, 0.1 + button_index * 0.15, 0.2, 0.1, weapon.name, true, gui_wdw_buy)
            button_index = button_index + 1
            addEventHandler("onClientGUIClick", button, buy_weapon, false)
            table.insert(gui_weapon_buttons, button)
        end
    end
    
    --local gui_btn_buy_close = guiCreateButton(0.6, 0.1, 0.3, 0.8, "Close", true, gui_wdw_buy)
    
    --addEventHandler("onClientGUIClick", gui_btn_buy_close, buy_close, false)
end

local function init_gui()
    --outputChatBox("init_gui", client)
    
    create_choose_team_dialog()
    create_buy_menu_dialog()
    
    guiSetVisible(gui_wdw_team, false)
    guiSetVisible(gui_wdw_buy, false)
end

local function started_resource(startedRes )
    --outputChatBox("startedRes", client)
    bindKey("F3", "down", show_buy_dialog)
    init_gui()
end

addEventHandler("onClientResourceStart", getResourceRootElement(), started_resource)	
addEventHandler("onAskTeam", localPlayer, show_team_dialog)
addEventHandler("onMoneyChange", localPlayer, refresh_weapon_buttons)