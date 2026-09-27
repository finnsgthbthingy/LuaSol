

local presetpos = 120
local spacing = 60
function drawBiome()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    drawCornerBox(230, 10, 500, 30)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("BIOME DETECTION", 400, 10)
        if privateServerLink == "" then
                love.graphics.print("Enter a Private Server link here...", 235,55)
        end
    drawCornerBox(230,50,500,40)
    love.graphics.setScissor(230, 50, 490, 40)
    love.graphics.setColor(1,1,1,1)


        love.graphics.print(privateServerLink, 235, 55)
        love.graphics.setScissor()

    love.graphics.setColor(1,1,1,1)
normalBiomeHitbox = drawCheckbox(
    250,
    120,
    "Normal",
    donormalbiomedetection,
    nil,
    7
)

windyBiomeHitbox = drawCheckbox(
    250,
    presetpos + spacing,
    "Windy",
    dowindybiomedetection,
    {0, 1, 0.722, 1},
    10
)

snowyBiomeHitbox = drawCheckbox(
    250,
    presetpos + spacing * 2,
    "Snowy",
    dosnowybiomedetection,
    {0, 0.949, 1, 1},
    10
)

rainyBiomeHitbox = drawCheckbox(
    420,
    presetpos,
    "Rainy",
    dorainybiomedetection,
    {0.243, 0, 0.969, 1},
    15
)

sandstormBiomeHitbox = drawCheckbox(
    420,
    presetpos + spacing,
    "Sandstorm",
    dosandstormbiomedetection,
    {0.969, 0.835, 0, 1},
    -10
)

hellBiomeHitbox = drawCheckbox(
    420,
    presetpos + spacing * 2,
    "Hell",
    dohellbiomedetection,
    {0.969, 0, 0, 1},
    25
)

starfallBiomeHitbox = drawCheckbox(
    590,
    presetpos,
    "Starfall",
    dostarfallbiomedetection,
    {0, 0.314, 0.631, 1},
    5
)

heavenBiomeHitbox = drawCheckbox(
    590,
    presetpos + spacing,
    "Heaven",
    doheavenbiomedetection,
    {1, 0.937, 0, 1},
    5
)

corruptionBiomeHitbox = drawCheckbox(
    590,
    presetpos + spacing * 2,
    "Corruption",
    docorruptionbiomedetection,
    {0.659, 0, 1, 1},
    -5
)

nullBiomeHitbox = drawCheckbox(
    760,
    presetpos,
    "Null",
    donullbiomedetection,
    nil,
    25
)

singularityBiomeHitbox = drawCheckbox(
    760,
    presetpos + spacing,
    "Singularity",
    dosingularitybiomedetection,
    {1, 0.714, 0, 1},
    -5
)

--blazingSunBiomeHitbox = drawCheckbox(
--    760,
--    presetpos + spacing * 2,
--    "Blazing Sun",
--    doblazingsunbiomedetection,
--    {1, 0.906, 0, 1},
--    -10
--)
end

