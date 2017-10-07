addEvent("onTimerStart", true)

local screen_width, screen_height = guiGetScreenSize()
local timer_str = "00:00"
local timer_color = tocolor(255,255,255,255)
local timer_timer = nil
local timer_update_resolution_ms = 100

local function update_timer_str()
    if isTimer(timer_timer) then
        local ms_remaining = getTimerDetails(timer_timer)
        local sec_remaining = math.floor(ms_remaining / 1000)
        local min_remaining = math.floor(sec_remaining / 60)
        
        local sec_str
        if (sec_remaining % 60) < 10 then
            sec_str = "0" .. (sec_remaining % 60)
        else
            sec_str = tostring(sec_remaining % 60)
        end
        
        local min_str
        if min_remaining < 10 then
            min_str = "0" .. min_remaining
        else
            min_str = tostring(min_remaining)
        end
        
        timer_str = min_str .. ":" .. sec_str
        
        setTimer(update_timer_str, timer_update_resolution_ms, 1)
        
        return true
    else
        timer_str = "00:00"
        return false
    end
end

local function set_timer_countdown(time_ms, color_r, color_g, color_b, color_a)
    if (color_r and color_g and color_b and color_a) then
        timer_color = tocolor(color_r, color_g, color_b, color_a)
    end
    if isTimer(timer_timer) then
        killTimer(timer_timer)
    end
    timer_timer = setTimer(function() killTimer(timer_timer) end, time_ms, 1)
    update_timer_str()
end

local function draw_timer()
    dxDrawText(timer_str, 0, screen_height - 10, screen_width, screen_height, timer_color, 2, "pricedown", "center", "bottom")
end

function handle_the_rendering()
    addEventHandler("onClientRender", root, draw_timer) -- keep the text visible with onClientRender.
end

addEventHandler("onClientResourceStart", resourceRoot, handle_the_rendering)
addEventHandler("onTimerStart", resourceRoot, set_timer_countdown)