function createSettings()
    local settings = [[
{
    "version": 1
}
]]

    love.filesystem.write("settings.json", settings)
end
createSettings()
onintro = true
local dialogues = {
    {--1
        text1 = "ARE YOU",
        delay = 1,
        text2 = "\nTHERE?"
    },

    {--2
        text1 = "ARE WE",
        delay = 1,
        text2 = "\nCONNECTED?"
    },
        {--3
        text1 = ""
    },
            {--4
        text1 = "EXCELLENT."
    },
                {--5
        text1 = "TRULY",
        delay = 1,
        text2 = "\nEXCELLENT."
    },
                {--6
        text1 = "NOW."
    },
                    {--7
        text1 = "WE MAY",
        delay = 1,
        text2 = "\nBEGIN."
    },
                        {--8
        text1 = "",
    },
                                {--9
        text1 = "",
    },
                            {--10
        text1 = "FIRST.",
    },
                                {--11
        text1 = "YOU MUST CREATE",
        delay = 1,
        text2 = "\n A WEBHOOK."
    },
                                    {--11
        text1 = "SKIP THIS STEP IF ",
        delay = 0,
        text2 = "\n YOU ALREADY HAVE ONE."
    },
                                    {--12
        text1 = "FIRSTLY, CREATE\n A DISCORD CHANNEL \n FOR THE WEBHOOK.",
    },
                                        {--13
        text1 = "MAKE THE WEBHOOK ",
        delay = 0,
        text2 = "\n IN THAT CHANNEL."

    },
                                        {--14
        text1 = "THEN COPY THE WEBHOOK URL.",
        delay = 0,
        text2 = "\n AND PASTE IT HERE."

    },
    {-- 15
            text1 = "YOU CAN ALSO TEST IT",
        delay = 0,
        text2 = "\n IF YOUD LIKE."

    },
        {-- 16
            text1 = "EVEN IF NOT REQUIRED\n IT WOULD BE",
        delay = 0,
        text2 = "\n A GOOD IDEA TO TEST IT."

    },
            {-- 17
            text1 = "THEN CREATE A \nPRIVATE SERVER",
        delay = 0,
        text2 = "\nIN SOLS RNG."

    },
                {-- 18
            text1 = "COPY THE PRIVATE SERVER",
        delay = 0,
        text2 = "\nLINK. AND PASTE IT HERE."

    },
                    { --19
            text1 = "YOU CAN ALSO \nSET THE",
        delay = 0,
        text2 = "\nBIOMES TO DETECT"

    },
                        { -- 20
            text1 = "RARE BIOMES\n PING EVERYONE",
        delay = 0,
        text2 = "\nNO MATTER WHAT."

    },
                            {
            text1 = "THATS ALL",
        delay = 1,
        text2 = "\nFOR NOW."

    },
                                {
            text1 = os.getenv("USERNAME") .. ", THANK YOU FOR",
        delay = 1,
        text2 = "\nFOR YOUR TIME."

    },
                                    {
            text1 = "UNTIL WE MEET AGAIN.",
        delay = 1,
        text2 = "\nGOODBYE."

    },

}





local videoAlpha = 0
local videoFadeSpeed = 1
local videoFadingIn = false
local beamWidth = 0
local beamTimer = 0
local beamDuration = 1.6
local beamActive = false
local dialogueIndex = 1

local currentText = ""
local visibleCharacters = 0

local typeSpeed = 10
local fastTypeSpeed = 100

local waiting = false
local waitTimer = 0

local pendingText = nil
local pendingDelay = 0

local font
local DRONE
local INTROSOUND
local video
local textposmod = 0
local glowTime = 0
local letterSpacing = 16
local soulVisible = false

function love.load()
    love.window.setTitle("SURVEY_PROGRAM")
    font = love.graphics.newFont(
        "assets/fonts/8bitoperator_jve.ttf",
        40
    )

    love.graphics.setFont(font)

    DRONE = love.audio.newSource(
        "assets/sounds/DRONE.mp3",
        "stream"
    )
    TUT1 = love.graphics.newImage(
        "assets/images/TUT1.png"
    )
    TUT2 = love.graphics.newImage(
        "assets/images/TUT2.png"
    )
    TUT3 = love.graphics.newImage(
        "assets/images/TUT3.png"
    )
    TUT4 = love.graphics.newImage(
        "assets/images/TUT4.png"
    )
    TUT5 = love.graphics.newImage(
        "assets/images/TUT5.png"
    )
    TUT6 = love.graphics.newImage(
        "assets/images/TUT6.png"
    )
    TUT7 = love.graphics.newImage(
        "assets/images/TUT7.png"
    )
    TUT8 = love.graphics.newImage(
        "assets/images/TUT8.png"
    )
    DRONE:setLooping(true)
    DRONE:play()

    INTROSOUND = love.audio.newSource(
        "assets/sounds/intro.mp3",
        "stream"
    )
    DEVICE_APPEARANCE = love.audio.newSource(
        "assets/sounds/DEVICE_APPEARENCE.wav",
        "stream"
    )
    SOUL = love.graphics.newImage(
        "assets/images/soul.png"
    )

    video = love.graphics.newVideo(
        "assets/video/intro.ogv"
    )

    local dialogue = dialogues[1]

    speak(
        dialogue.text1,
        dialogue.delay,
        dialogue.text2
    )

end
function restart()
    local exe = arg[0]

    os.execute('start "" "' .. exe .. '"')
    love.event.quit()
end
local dialogueCount = 0
local uhh = true
function dialogueEvent(count)

    if count == 2 then
        DEVICE_APPEARANCE:play()
        soulVisible = true
        beamActive = true
        beamTimer = 0
        beamWidth = 0
                textposmod = -100
    elseif count == 7 then

                beamActive = true
        beamTimer = 0
        beamWidth = 0
        DEVICE_APPEARANCE:clone():play()
        uhh = false


    elseif count == 8 then
                INTROSOUND:play()
        DRONE:stop()
        print("EVENT 10")
    
        elseif count == 24 then
            restart()
    end

end

function speak(text1, delay, text2)

    currentText = text1
    visibleCharacters = 0

    waiting = false
    waitTimer = 0

    if delay and text2 then
        pendingText = text2
        pendingDelay = delay
    else
        pendingText = nil
        pendingDelay = 0
    end

end


function nextDialogue()

    dialogueIndex = dialogueIndex + 1
    dialogueCount = dialogueCount + 1
dialogueEvent(dialogueCount)
    if dialogueIndex > #dialogues then
        return
    end

    local dialogue = dialogues[dialogueIndex]

    speak(
        dialogue.text1,
        dialogue.delay,
        dialogue.text2,
        dialogue.delay2,
        dialogue.text3
    )
    
end

function love.update(dt)
if videoFadingIn then
    videoAlpha = videoAlpha + (1 - videoAlpha) * videoFadeSpeed * dt

    if videoAlpha >= 0.99 then
        videoAlpha = 1
        videoFadingIn = false
    end
end
    if beamActive then

    beamTimer = beamTimer + dt

    local t = beamTimer / beamDuration

    if t >= 1 then
        t = 1
        beamActive = false
    end

    -- 0 -> 1 -> 0
    if t < 0.5 then
        beamWidth = (t / 0.5) * 50
    else
        beamWidth = ((1 - t) / 0.5) * 50
    end

end
    glowTime = glowTime + dt

    if waiting then

        waitTimer = waitTimer + dt

        if waitTimer >= pendingDelay then

            currentText = currentText .. pendingText

            pendingText = nil

            waiting = false
            waitTimer = 0

        end

        return
    end

    if visibleCharacters < #currentText then

        local speed = typeSpeed

        if love.keyboard.isDown("x") then
            speed = fastTypeSpeed
        end

        visibleCharacters =
            visibleCharacters + speed * dt

        if pendingText
        and visibleCharacters >= #currentText then

            visibleCharacters = #currentText

            waiting = true
            waitTimer = 0

        end

    end

end


function love.keypressed(key)

    if key == "return" then

        if waiting then

            currentText = currentText .. pendingText

            pendingText = nil

            waiting = false
            waitTimer = 0

            return
        end

        if visibleCharacters < #currentText then

            visibleCharacters = #currentText

            return
        end

        nextDialogue()

    end

end


function getSpacedWidth(text)

    local width = 0

    for i = 1, #text do

        local char = text:sub(i, i)

        if char ~= "\n" then
            width = width
                + love.graphics.getFont():getWidth(char)
                + letterSpacing
        end

    end

    if width > 0 then
        width = width - letterSpacing
    end

    return width

end


function printSpaced(text, x, y)

    local currentX = x
    local currentY = y + textposmod

    local lineHeight = love.graphics.getFont():getHeight()

    for i = 1, #text do

        local char = text:sub(i, i)

        if char == "\n" then

            currentX = x
            currentY = currentY + lineHeight

        else

            love.graphics.print(
                char,
                currentX,
                currentY
            )

            currentX = currentX
                + love.graphics.getFont():getWidth(char)
                + letterSpacing

        end

    end

end

local makesoulvisible = false
function love.draw()

    local characters = math.floor(visibleCharacters)

    local text = string.sub(
        currentText,
        1,
        characters
    )

    local fullText = currentText

    if pendingText then
        fullText = fullText .. pendingText
    end

    local longestLineWidth = 0

    for line in fullText:gmatch("[^\n]*") do

        local width = getSpacedWidth(line)

        if width > longestLineWidth then
            longestLineWidth = width
        end

    end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local lineHeight = love.graphics.getFont():getHeight()

    local lineCount = 1

    for _ in fullText:gmatch("\n") do
        lineCount = lineCount + 1
    end

    local totalHeight = lineHeight * lineCount

    local x =
        (screenWidth - longestLineWidth) / 2

    local y =
        (screenHeight - totalHeight) / 2

    local glow =
        (math.sin(glowTime * 3) + 1) / 2

    local glowAlpha =
        0.15 + glow * 0.55


if soulVisible then
    
    if beamWidth > 0 then
        love.graphics.setColor(1, 0, 0, 1)

        love.graphics.rectangle(
            "fill",
            470 + (50 - beamWidth) / 2,
            0,
            beamWidth,
            1000
        )
        love.graphics.setColor(1,0,0,0.5)
                love.graphics.rectangle(
            "fill",
            475 + (50 - beamWidth) / 2,
            0,
            beamWidth,
            1000
        )
                        love.graphics.rectangle(
            "fill",
            465 + (50 - beamWidth) / 2,
            0,
            beamWidth,
            1000
        )
                love.graphics.setColor(1,0,0,0.25)
                love.graphics.rectangle(
            "fill",
            480 + (50 - beamWidth) / 2,
            0,
            beamWidth,
            1000
        )
                        love.graphics.rectangle(
            "fill",
            460 + (50 - beamWidth) / 2,
            0,
            beamWidth,
            1000
        )
        if beamWidth >= 30 then
        makesoulvisible = true
end



    end

    love.graphics.setColor(1, 0,0, 1)
end
    if makesoulvisible then
     if uhh then   
    love.graphics.draw(
        SOUL,
        475,
        300,
        0,
        2
    )
end
end
        love.graphics.setColor(1, 1, 1, 1)

    if dialogueCount >= 8 then
               
        
love.graphics.setColor(1, 1, 1, videoAlpha)
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

local scaleX = windowWidth / video:getWidth()
local scaleY = windowHeight / video:getHeight()

love.graphics.draw(
    video,
    0,
    0,
    0,
    scaleX,
    scaleY
)

love.graphics.setColor(1, 1, 1, 1)
        video:play()
video:getSource():setVolume(0)
videoFadingIn = true
        
    end
        love.graphics.setColor(
        1,
        1,
        1,
        glowAlpha * 0.4
    )

    printSpaced(text, x - 2, y )
    printSpaced(text, x + 2, y )
    printSpaced(text, x, y - 2)
    printSpaced(text, x, y + 2)

    love.graphics.setColor(
        1,
        1,
        1,
        glowAlpha
    )

    printSpaced(text, x - 1, y - 1 )
    printSpaced(text, x + 1, y - 1)
    printSpaced(text, x - 1, y + 1)
    printSpaced(text, x + 1, y + 1)

    love.graphics.setColor(
        1,
        1,
        1,
        1
    )
        printSpaced(text, x, y)
if dialogueCount == 13 then
    local t = love.timer.getTime()

    local wobbleX = math.sin(t * 2) * 4
    local wobbleY = math.sin(t * 3) * 2
    local rotation = math.sin(t * 2) * 0.03

    love.graphics.draw(
        TUT1,
        350 + wobbleX,
        300 + wobbleY,
        rotation,
        0.5,
        0.5
    )
end
if dialogueCount == 14 then
    local t = love.timer.getTime()

    local wobbleX = math.sin(t * 2) * 4
    local wobbleY = math.sin(t * 3) * 2
    local rotation = math.sin(t * 2) * 0.03

    love.graphics.draw(
        TUT2,
        150 + wobbleX,
        300 + wobbleY,
        rotation,
        0.5,
        0.5
    )
        love.graphics.draw(
        TUT3,
        500- wobbleX,
        300 - wobbleY,
        rotation,
        0.4,
        0.4
    )
end
if dialogueCount >= 15 and dialogueCount <= 16 then
    local t = love.timer.getTime()

    local wobbleX = math.sin(t * 2) * 4
    local wobbleY = math.sin(t * 3) * 2
    local rotation = math.sin(t * 2) * 0.03

    love.graphics.draw(
        TUT4,
        250 + wobbleX,
        300 + wobbleY,
        rotation,
        0.5,
        0.5

    )
end
if dialogueCount == 17 then
    local t = love.timer.getTime()

    local wobbleX = math.sin(t * 2) * 4
    local wobbleY = math.sin(t * 3) * 2
    local rotation = math.sin(t * 2) * 0.03

    love.graphics.draw(
        TUT5,
        250 + wobbleX,
        300 + wobbleY,
        rotation,
        0.5,
        0.5

    )
end
if dialogueCount == 18 then
    local t = love.timer.getTime()

    local wobbleX = math.sin(t * 2) * 4
    local wobbleY = math.sin(t * 3) * 2
    local rotation = math.sin(t * 2) * 0.03

    love.graphics.draw(
        TUT6,
        200 + wobbleX,
        300 + wobbleY,
        rotation,
        0.5,
        0.5

    )
        love.graphics.draw(
        TUT7,
        300 + wobbleX,
        400 + wobbleY,
        rotation,
        0.3,
        0.3

    )
end
if dialogueCount >= 19 and dialogueCount <= 20 then
    local t = love.timer.getTime()

    local wobbleX = math.sin(t * 2) * 4
    local wobbleY = math.sin(t * 3) * 2
    local rotation = math.sin(t * 2) * 0.03

    love.graphics.draw(
        TUT8,
        200 + wobbleX,
        300 + wobbleY,
        rotation,
        0.5,
        0.5

    )
end
end