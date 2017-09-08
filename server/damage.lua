local damage_types = {
	[19] = "Rocket",
	[37] = "Burnt",
	[49] = "Rammed",
	[50] = "Ranover/Helicopter Blades",
	[51] = "Explosion",
	[52] = "Driveby",
	[53] = "Drowned",
	[54] = "Fall",
	[55] = "Unknown",
	[56] = "Melee",
	[57] = "Weapon",
	[59] = "Tank Grenade",
	[63] = "Blown"
}

local function get_death_cause(cause_id)
    if damage_types[cause_id] then
        return damage_types[cause_id]
    else
        weapon = get_weapon_info_by_id(cause_id)
        if weapon then
            return weapon.name
        else
            return "Unknown"
        end
    end
end

local function player_wasted_handler(total_ammo, killer, killer_weapon, bodypart, stealth)
    if killer == source then
        outputChatBox("SERVER: " .. getPlayerName(source) .. " suicided. (" .. get_death_cause(killer_weapon) .. ")", source)
    elseif killer then
        outputChatBox("SERVER: " .. getPlayerName(source) .. " was killed by " .. getPlayerName(killer) .. "(" .. get_death_cause(killer_weapon) .. ")", source)
    else
        outputChatBox("SERVER: " .. getPlayerName(source) .. " died.", source)
    end
end

-- function player_damage_handler(attacker, attackerweapon, bodypart, loss)
    -- outputChatBox("SERVER: " .. getPlayerName(source) .. " received damage", source)
-- end

addEventHandler("onPlayerWasted", getRootElement(), player_wasted_handler)
-- addEventHandler("onPlayerDamage", getRootElement(), player_damage_handler)