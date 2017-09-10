local weapon_slots = {
    {["name"] = "hand_slot",      ["description"] = "Hand"},
    {["name"] = "melee_slot",     ["description"] = "Melee"},
    {["name"] = "primary_slot",   ["description"] = "Primary"},
    {["name"] = "secondary_slot", ["description"] = "Secondary"},
    {["name"] = "special_slot",   ["description"] = "Special"}
}

local weapons = {
    {["name"] = "Hand",            ["ID"] = 0,  ["ammo_per_mag"] = 1,  ["cost"] = 1,   ["slot"] = "hand_slot",      ["team"] = "all"},
    {["name"] = "Knife",           ["ID"] = 4,  ["ammo_per_mag"] = 1,  ["cost"] = 1,   ["slot"] = "melee_slot",     ["team"] = "all"},
    {["name"] = "AK-47",           ["ID"] = 30, ["ammo_per_mag"] = 30, ["cost"] = 100, ["slot"] = "primary_slot",   ["team"] = team_t_name},
    {["name"] = "M4",              ["ID"] = 31, ["ammo_per_mag"] = 30, ["cost"] = 100, ["slot"] = "primary_slot",   ["team"] = team_ct_name},
    {["name"] = "Colt 45",         ["ID"] = 22, ["ammo_per_mag"] = 17, ["cost"] = 50,  ["slot"] = "secondary_slot", ["team"] = "all"},
    {["name"] = "Deagle",          ["ID"] = 24, ["ammo_per_mag"] = 7,  ["cost"] = 75,  ["slot"] = "secondary_slot", ["team"] = "all"},
    {["name"] = "Rocket Launcher", ["ID"] = 35, ["ammo_per_mag"] = 1,  ["cost"] = 200, ["slot"] = "special_slot",   ["team"] = "all"},
    {["name"] = "Granade",         ["ID"] = 16, ["ammo_per_mag"] = 1,  ["cost"] = 100, ["slot"] = "special_slot",   ["team"] = "all"},
}

function get_weapon_info(weapon_name)
    for i, weapon in ipairs(weapons) do
        if weapon.name == weapon_name then
            return weapon
        end
    end
    
    error("Weapon " .. weapon_name .. " not found!")
    return nil
end

function get_weapon_info_by_index(index)
    if index < 1 or index > get_weapon_count() then
        error("Index out of bounds!")
    end
    
    return weapons[index]
end

function get_weapon_info_by_id(id)
    for i, weapon in ipairs(weapons) do
        if weapon.ID == id then
            return weapon
        end
    end
    
    error("Weapon with ID " .. id .. " not found!")
    return nil
end

function get_weapon_count()
    return #weapons
end

function get_weapon_slot_by_index(index)
    if index < 1 or index > get_weapon_slot_count() then
        error("Index out of bounds!")
    end
    
    return weapon_slots[index]
end

function get_weapon_slot_count()
    return #weapon_slots
end