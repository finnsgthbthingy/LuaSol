

function drawAutoitemusage()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Auto item usage", 400, 10)

    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    autobrusehitbox = drawCheckbox(
        400,
        120,
        "Auto use Biome Randomizer.",
        shouldusebr,
        {0.2784, 0.2706, 0.2667, 1},
        -100
    )
    autoscusehitbox = drawCheckbox(
        700,
        120,
        "Auto use Strange Controller.",
        shouldusesc,
        {0.2784, 0.2706, 0.2667, 1},
        -100
    )

    love.graphics.setColor(1, 1, 1, 1)
end
