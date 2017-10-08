local maps = {
    -- LS Test Map
    -- {
        -- ["name"] = "LS Test Map",
        -- ["spawn_area_ct"] = {["x1"] = 2089.3388671875, ["y1"] = -1621.2353515625, ["x2"] = 2074.244140625, ["y2"] = -1606.11328125, ["z"] = 13.546875},
        -- ["spawn_area_t"] = {["x1"] = 2007.099609375, ["y1"] = -1744.5419921875, ["x2"] = 1993.56640625, ["y2"] = -1757.9384765625, ["z"] = 13.546875},
        -- ["bomb_site_a"] = {["x1"] = 2036.966796875, ["y1"] = -1682.4130859375, ["x2"] = 2046.388671875, ["y2"] = -1662.7763671875, ["z"] = 13.546875},
        -- ["bomb_site_b"] = {["x1"] = -2335.8671875, ["y1"] = 284.0615234375, ["x2"] = -2309.89453125, ["y2"] = 268.50390625, ["z"] = 35.3203125}
    -- },
    -- San Fierro Showdown
    {
        ["name"] = "San Fierro Showdown",
        -- Supa Save
        ["spawn_area_ct"] = {["x1"] = -2420.09375, ["y1"] = 743.609375, ["x2"] = -2473.2666015625, ["y2"] = 723.6396484375, ["z"] = 35.015625},
        -- SF Highway
        ["spawn_area_t"] = {["x1"] = -1962.8759765625, ["y1"] = -385.03515625, ["x2"] = -1986.375, ["y2"] = -357.6708984375, ["z"] = 25.7109375},
        -- Wangs Cars
        ["bomb_site_a"] = {["x1"] = -1943.2919921875, ["y1"] = 254.263671875, ["x2"] = -1958.720703125, ["y2"] = 307.6083984375, ["z"] = 41.047080993652},
        -- Baseball Pitch
        ["bomb_site_b"] = {["x1"] = -2335.8671875, ["y1"] = 284.0615234375, ["x2"] = -2309.89453125, ["y2"] = 268.50390625, ["z"] = 35.3203125}
    },
    -- Desert Combat
    {
        ["name"] = "Desert Combat",
        -- Desert Mountain Road
        ["spawn_area_ct"] = {["x1"] = -659.947265625, ["y1"] = 2482.1982421875, ["x2"] = -629.1279296875, ["y2"] = 2510.9453125, ["z"] = 77.270622253418},
        -- Abandoned Airfield
        ["spawn_area_t"] = {["x1"] = 425.6201171875, ["y1"] = 2515.4228515625, ["x2"] = 381.9150390625, ["y2"] = 2480.677734375, ["z"] = 16.484375},
        -- Desert Chicken
        ["bomb_site_a"] = {["x1"] = -245.7060546875, ["y1"] = 2648.30859375, ["x2"] = -226.107421875, ["y2"] = 2676.8955078125, ["z"] = 62.811405181885},
        -- Ghost Town
        ["bomb_site_b"] = {["x1"] = -376.8623046875, ["y1"] = 2217.90234375, ["x2"] = -418.7978515625, ["y2"] = 2244.396484375, ["z"] = 42.4296875}
    },
    -- Viva Las Venturas
    {
        ["name"] = "Viva Las Venturas",
        -- LV Outskirts East
        ["spawn_area_ct"] = {["x1"] = 2872.3994140625, ["y1"] = 2131.1962890625, ["x2"] = 2898.7685546875, ["y2"] = 2085.859375, ["z"] = 10.8203125},
        -- LV Hospital
        ["spawn_area_t"] = {["x1"] = 1632.220703125, ["y1"] = 1822.5205078125, ["x2"] = 1584.3291015625, ["y2"] = 1856.431640625, ["z"] = 10.8203125},
        -- Clown's Pocket
        ["bomb_site_a"] = {["x1"] = 2223.9013671875, ["y1"] = 1851.6298828125, ["x2"] = 2206.509765625, ["y2"] = 1828.03515625, ["z"] = 10.8203125},
        -- LVPD Fountain
        ["bomb_site_b"] = {["x1"] = 2327.32421875, ["y1"] = 2362.9814453125, ["x2"] = 2306.7666015625, ["y2"] = 2341.7958984375, ["z"] = 10.9765625}
    },
    -- Los Santos Hood
    {
        ["name"] = "Los Santos Hood",
        -- LSPD
        ["spawn_area_ct"] = {["x1"] = 1551.220703125, ["y1"] = -1604.3779296875, ["x2"] = 1604.466796875, ["y2"] = -1631.052734375, ["z"] = 13.513515472412},
        -- Grove St.
        ["spawn_area_t"] = {["x1"] = 2468.8759765625, ["y1"] = -1654.6201171875, ["x2"] = 2505.0283203125, ["y2"] = -1678.93359375, ["z"] = 13.379979133606},
        -- Gas Station
        ["bomb_site_a"] = {["x1"] = 1901.349609375, ["y1"] = -1790.0146484375, ["x2"] = 1914.0185546875, ["y2"] = -1766.8359375, ["z"] = 13.546875},
        -- Hospital
        ["bomb_site_b"] = {["x1"] = 2022.2958984375, ["y1"] = -1403.640625, ["x2"] = 2037.2802734375, ["y2"] = -1435.4267578125, ["z"] = 17.181692123413}
    }
}

local current_map_index = 1

function get_current_map()
    return maps[current_map_index]
end

function round_ending_handler()
    -- Getting a new random map
    current_map_index = math.random(1, #maps)
    outputChatBox("Next map will be: " .. maps[current_map_index].name, getRootElement())
    triggerEvent("onNewMap", mtacs_element)
end

addEventHandler("onRoundEnding", mtacs_element, round_ending_handler)