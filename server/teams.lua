team_t = createTeam(team_t_name, 255, 119, 119)
team_ct = createTeam(team_ct_name, 125, 135, 255)

function get_team_alive_count(team)
    local counter = 0
    local players = getPlayersInTeam(team)
    for i = 1, #players do
        if not isPedDead(players[i]) then
            counter = counter + 1
        end
    end
    return counter
end

local function team_chosen_handler(team_name)
    setElementData(source, "team_name", team_name)
end

addEventHandler("onTeamChosen", getRootElement(), team_chosen_handler)