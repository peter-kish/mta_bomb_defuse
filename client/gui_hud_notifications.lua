addEvent("onNotification", true)

local screen_width, screen_height = guiGetScreenSize()
local ntf_enabled = false
local ntf_timer = nil
local ntf_time = 4000
local ntf_text = "none"
local ntf_color_r = 255
local ntf_color_g = 255
local ntf_color_b = 255
local ntf_color_a = 255

local function ntf_handler(text, color_r, color_g, color_b, color_a)
    --outputConsole("CLIENT: gui_hud_notifications.lua: " .. text)
    
    if isTimer(ntf_timer) then
        killTimer(ntf_timer)
    end
    
    ntf_text = text
    ntf_color_r = color_r
    ntf_color_g = color_g
    ntf_color_b = color_b
    ntf_color_a = color_a
    ntf_enabled = true
    ntf_timer = setTimer(function() ntf_enabled = false end, ntf_time, 1)
end

local remaining_ms = 0
local alpha = 0

local function draw_ntf()
    if ntf_enabled then
        remaining_ms = getTimerDetails(ntf_timer)
        if remaining_ms > ntf_time / 2 then
            alpha = 1
        else
            alpha = remaining_ms / (ntf_time / 2)
        end
        dxDrawText(ntf_text,
            0,
            screen_height / 2,
            screen_width,
            screen_height,
            tocolor(ntf_color_r, ntf_color_g, ntf_color_b, ntf_color_a * alpha),
            2,
            "default",
            "center",
            "center")
    end
end

function handle_the_rendering()
    addEventHandler("onClientRender", root, draw_ntf)
end
addEventHandler("onClientResourceStart", resourceRoot, handle_the_rendering)
addEventHandler("onNotification", resourceRoot, ntf_handler)