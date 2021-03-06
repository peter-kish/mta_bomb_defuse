local function get_weapon_ammo(weapon)
    local slot = getSlotFromWeapon(weapon.ID)
    if slot then
        return getPedTotalAmmo(source, slot)
    end
    return false
end

local function set_weapon_ammo(weapon, ammo)
    setWeaponAmmo(source, weapon.ID, ammo)
end

local function equip_weapon(weapon)
    local slot_weapon_name = getElementData(source, weapon.slot)
    if slot_weapon_name and slot_weapon_name ~= weapon.name then
        -- Equipping a new weapon, remove the old one
        local slot_weapon = get_weapon_info(slot_weapon_name)
        takeWeapon(source, slot_weapon.ID)
    end
    
    giveWeapon(source, weapon.ID, weapon.ammo_per_mag, true)
    
    if get_weapon_ammo(weapon) >= weapon.max_ammo then
        set_weapon_ammo(weapon, weapon.max_ammo)
        return
    end
    
    setElementData(source, weapon.slot, weapon.name, true)
end

local function weapon_buy_handler(weapon_name)
    --outputChatBox("SERVER: weaponBuyHandler", source)
    if is_player_in_buy_zone(source) == false then
        outputChatBox("SERVER: Can't buy outside the buy zone!", source)
        return
    end
    
    if isPedDead(source) then
        outputChatBox("SERVER: Can't buy before respawn!", source)
        return
    end
    
    local weapon = get_weapon_info(weapon_name)
    
    if get_weapon_ammo(weapon) >= weapon.max_ammo then
        outputChatBox("SERVER: Maximum ammo reached!", source)
        return
    end
    
    if weapon then
        --outputChatBox("SERVER: weaponBuyHandler: Buying " .. weapon.name, source)
        if getPlayerMoney(source) >= weapon.cost then
            --giveWeapon(source, weapon.ID, weapon.ammo_per_mag, true)
            equip_weapon(weapon)
            setPlayerMoney(source, getPlayerMoney(source) - weapon.cost)
            triggerClientEvent ("onMoneyChange", source, getPlayerMoney(source))
        else
            error("Not enough money!");
        end
    end
end

local function give_knife()
    giveWeapon(source, 4, 1, false)
end

function get_player_weapon_status(player)
    local slots = {}

    for slot=0,10 do
        local weapon_id = getPedWeapon(player, slot)
        if weapon_id and weapon_id ~= get_weapon_info("Hand").ID and weapon_id ~= get_weapon_info("Knife").ID then
            local weapon_slot = {}
            weapon_slot.weapon_id = weapon_id
            weapon_slot.ammo = getPedTotalAmmo(player, slot)
            weapon_slot.clip_ammo = getPedAmmoInClip(player, slot)
            table.insert(slots, weapon_slot)
        end
    end
    
    return slots
end

function set_player_weapon_status(player, weapon_status)
    for i, slot in ipairs(weapon_status) do
        giveWeapon(player, slot.weapon_id, slot.ammo)
    end
end

function set_weapon_properties()
    -- AK47
    setWeaponProperty("30", "pro", "damage", 33)
    setWeaponProperty("30", "pro", "accuracy", 0.68)
    setWeaponProperty("30", "pro", "maximum_clip_ammo", 30)
    setWeaponProperty("30", "pro", "weapon_range", 100)
    -- M4
    setWeaponProperty("31", "pro", "damage", 30)
    setWeaponProperty("31", "pro", "accuracy", 0.82)
    setWeaponProperty("31", "pro", "maximum_clip_ammo", 30)
    setWeaponProperty("31", "pro", "weapon_range", 100)
    
    -- SniperRifle
    setWeaponProperty("34", "pro", "weapon_range", 200)

    -- SPAZ12 Shotgun
    setWeaponProperty("27", "pro", "damage", 14)
    setWeaponProperty("27", "pro", "accuracy", 1.2)
    setWeaponProperty("27", "pro", "maximum_clip_ammo", 8)
    setWeaponProperty("27", "pro", "weapon_range", 50)
    setWeaponProperty("27", "pro", "target_range", 50)

    -- Shotgun
    setWeaponProperty("25", "pro", "damage", 12)
    setWeaponProperty("25", "pro", "accuracy", 1.2)
    setWeaponProperty("25", "pro", "weapon_range", 50)
    setWeaponProperty("25", "pro", "target_range", 50)

    -- UZI
    setWeaponProperty("28", "std", "weapon_range", 75)
    setWeaponProperty("28", "std", "target_range", 75)
    setWeaponProperty("28", "std", "damage", 18)
    setWeaponProperty("28", "std", "accuracy", 0.7)
    setWeaponProperty("28", "std", "maximum_clip_ammo", 25)

    -- RPG
    setWeaponProperty("35", "pro", "weapon_range", 80)
end

local function list_weapons_command_handler()
    outputConsole("--- Available Weapons ---", source)
    for i=1,get_weapon_count() do
        outputConsole(get_weapon_info_by_index(i).name, source)
    end
    outputConsole("-------------------------", source)
end

local function set_weapon_prop_command_handler(player_source, command_name, weapon_name, property, value)
    local skill = "pro"
    local weapon_info = get_weapon_info(weapon_name)
    
    if not weapon_info then
        outputConsole("Weapon " .. weapon_name .. " not found!", source)
    end
    
    if weapon_info.ID == 28 then -- UZI
        skill = "std"
    end
    
    local old_value = getWeaponProperty(weapon_info.ID, skill, property)
    if not old_value then
        outputConsole("Error...", source)
        return
    end
    
    if setWeaponProperty(weapon_info.ID, skill, property, value) then
        outputConsole(property .. " for " .. weapon_name .. " changed from " .. old_value .. " to " .. value, source)
    else
        outputConsole("Error...", source)
    end
end

local function get_weapon_prop_command_handler(player_source, command_name, weapon_name, property)
    local skill = "pro"
    local weapon_info = get_weapon_info(weapon_name)
    
    if not weapon_info then
        outputConsole("Weapon " .. weapon_name .. " not found!", source)
    end
    
    if weapon_info.ID == 28 then -- UZI
        skill = "std"
    end
    
    local value = getWeaponProperty(weapon_info.ID, skill, property)
    if value then
        outputConsole(property .. " for " .. weapon_name .. " is " .. value, source)
    else
        outputConsole("Error...", source)
    end
end

addEventHandler("onPlayerSpawn", getRootElement(), give_knife)
addEventHandler("onWeaponBuy", getRootElement(), weapon_buy_handler)
addEventHandler ( "onPlayerJoin", getRootElement(), set_weapon_properties)

addCommandHandler("list_weapons", list_weapons_command_handler, false, true)
addCommandHandler("set_weapon_property", set_weapon_prop_command_handler, true, true)
addCommandHandler("get_weapon_property", get_weapon_prop_command_handler, false, true)
