local vehicles = {
    {["name"] = "Perennial",       ["ID"] = 404, ["cost"] = 100,  ["team"] = "all"},
    {["name"] = "Police",          ["ID"] = 596, ["cost"] = 400,  ["team"] = team_ct_name},
    {["name"] = "Sultan",          ["ID"] = 560, ["cost"] = 400,  ["team"] = team_t_name},
    {["name"] = "Sanchez",         ["ID"] = 468, ["cost"] = 500,  ["team"] = team_t_name},
    {["name"] = "HPV1000",         ["ID"] = 523, ["cost"] = 500,  ["team"] = team_ct_name},
    {["name"] = "Maverick",        ["ID"] = 487, ["cost"] = 1200, ["team"] = "all"},
}

function get_vehicle_info(vehicle_name)
    for i, vehicle in ipairs(vehicles) do
        if vehicle.name == vehicle_name then
            return vehicle
        end
    end
    
    error("Vehicle " .. vehicle_name .. " not found!")
    return nil
end

function get_vehicle_info_by_index(index)
    if index < 1 or index > get_vehicle_count() then
        error("Index out of bounds!")
    end
    
    return vehicles[index]
end

function get_vehicle_info_by_id(id)
    for i, vehicle in ipairs(vehicles) do
        if vehicle.ID == id then
            return vehicle
        end
    end
    
    error("Vehicle with ID " .. id .. " not found!")
    return nil
end

function get_vehicle_count()
    return #vehicles
end