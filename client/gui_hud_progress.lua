local screen_width, screen_height = guiGetScreenSize()
local progress_visible = false
local progress_timer = nil
local progress_time = 0
local progress_bar_width = 400
local progress_bar_height = 20

local function plant_defuse_end()
    progress_visible = false
    if isTimer(progress_timer) then
        killTimer(progress_timer)
    end
end

local function plant_defuse_start(the_time)
    progress_visible = true
    progress_time = the_time
    progress_timer = setTimer(function() plant_defuse_end() end, the_time, 1)
end

local function draw_progress()
    if progress_visible and isTimer(progress_timer) then
        local remaining = getTimerDetails(progress_timer)
        local progress = ((progress_time - remaining) / progress_time)
        dxDrawRectangle(
            screen_width / 2 - progress_bar_width / 2,
            screen_height / 2 - progress_bar_height / 2,
            progress_bar_width,
            progress_bar_height,
            tocolor(0, 0, 0, 128))
        dxDrawRectangle(
            screen_width / 2 - progress_bar_width / 2,
            screen_height / 2 - progress_bar_height / 2,
            progress_bar_width * progress,
            progress_bar_height,
            tocolor(255, 255, 255, 255))
    end
end

local function handle_the_rendering()
    addEventHandler("onClientRender", root, draw_progress) -- keep the text visible with onClientRender.
end

addEventHandler("onClientResourceStart", resourceRoot, handle_the_rendering)
addEventHandler("onPlantDefuseStart", localPlayer, plant_defuse_start)
addEventHandler("onPlantDefuseEnd", localPlayer, plant_defuse_end)