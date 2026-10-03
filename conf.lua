if onintro == true then
    function love.conf(t)
    t.window.width = 1000
    t.window.height = 600
    t.window.title = "SURVEY_PROGRAM"
    t.window.icon = "/assets/images/luasol.png"
end
else
function love.conf(t)
    t.window.width = 1000
    t.window.height = 600
    t.window.title = "luasol"
    t.window.icon = "/assets/images/luasol.png"
end
end