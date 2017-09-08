addEvent("onWeaponBuy", true);

local function equip_weapon(weapon)
    local slot_weapon_name = getElementData(source, weapon.slot)
    if slot_weapon_name and slot_weapon_name ~= weapon.name then
        -- Equipping a new weapon, remove the old one
        local slot_weapon = get_weapon_info(slot_weapon_name)
        takeWeapon(source, slot_weapon.ID)
    end
    
    giveWeapon(source, weapon.ID, weapon.ammo_per_mag, true)
    setElementData(source, weapon.slot, weapon.name, true)
end

local function weapon_buy_handler(weapon_name)
    --outputChatBox("SERVER: weaponBuyHandler", source)
    
    local weapon = get_weapon_info(weapon_name)
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

addEventHandler("onSpawn", getRootElement(), give_knife)
addEventHandler("onWeaponBuy", getRootElement(), weapon_buy_handler )