playerposx = 0
playerposy = 0
function createSettings()
    local settings = [[
{
    "version": 1
}
]]

    love.filesystem.write("settings.json", settings)
end
function love.update(dt)
        if not video:isPlaying() then
        video:rewind()
        video:play()
    end
    local speed = 200

    if love.keyboard.isDown("a") then
        playerposx = playerposx - speed * dt
    end

    if love.keyboard.isDown("d") then
        playerposx = playerposx + speed * dt
    end

    if love.keyboard.isDown("w") then
        playerposy = playerposy - speed * dt
    end

    if love.keyboard.isDown("s") then
        playerposy = playerposy + speed * dt
    end
end
function love.load()
    createSettings()
    loadSettings()
        video = love.graphics.newVideo("assets/video/dogcheck.ogv")
      
    video:play()
    font = love.graphics.newFont("assets/fonts/Sarpanch-Regular.ttf", 20)
end

function fontconfig()
    love.graphics.setFont(font)
end
function love.draw()
      local w = love.graphics.getWidth()
local h = love.graphics.getHeight()

local x = (w - video:getWidth()) / 2
local y = (h - video:getHeight()) / 2

love.graphics.draw(video, x, y)
    fontconfig()
    love.graphics.print("hey! so uhh.. either youre a new person or your settings file got corrupted :( (wasd to move)")
    love.graphics.print("this place is reserved for a tutorial but the dog is still constructing it.",0,100)
    love.graphics.print("just restart the app this page shouldve regenerated a barebones setting file",0, 570)
    love.graphics.rectangle(
        "fill",
        100 + playerposx,
        100 + playerposy,
        50,
        50
    )
end