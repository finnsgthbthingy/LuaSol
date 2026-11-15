busyusingstuff = false
warningx = -500
warningTarget = 0
doauradetection = false
local lasttab = ""
privateServerLink = ""
webhookurl = ""
local json = require("json")
local alreadyshownfailure = false
local waitingTasks = {}

function wait(seconds, callback)
    table.insert(waitingTasks, {
        time = love.timer.getTime() + seconds,
        callback = callback
    })
end
local ffi = require("ffi")
ffi.cdef[[
typedef struct {
    long dx; long dy;
    unsigned long mouseData;
    unsigned long dwFlags;
    unsigned long time;
    uintptr_t dwExtraInfo;
} MOUSEINPUT;

typedef struct {
    unsigned short wVk;
    unsigned short wScan;
    unsigned long dwFlags;
    unsigned long time;
    uintptr_t dwExtraInfo;
} KEYBDINPUT;

typedef struct {
    unsigned long type;
    union { MOUSEINPUT mi; KEYBDINPUT ki; };
} INPUT;

typedef void* HWND;
HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
int SetForegroundWindow(HWND hWnd);
int ShowWindow(HWND hWnd, int nCmdShow);
unsigned int SendInput(unsigned int cInputs, INPUT* pInputs, int cbSize);
unsigned int MapVirtualKeyA(unsigned int uCode, unsigned int uMapType);
int SetProcessDPIAware(void);
]]

local user32 = ffi.load("user32")
user32.SetProcessDPIAware()

local MOVE, ABSOLUTE, LEFTDOWN, LEFTUP = 0x0001, 0x8000, 0x0002, 0x0004
local KEYUP, SCANCODE = 0x0002, 0x0008

-- mouse
local function send(flags, dx, dy)
    local inp = ffi.new("INPUT")
    inp.type = 0
    inp.mi.dx, inp.mi.dy = dx or 0, dy or 0
    inp.mi.dwFlags = flags
    user32.SendInput(1, inp, ffi.sizeof("INPUT"))
end

local function moveRel(dx, dy) send(MOVE, dx, dy) end

local function moveAbs(x, y, screenW, screenH)
    send(bit.bor(MOVE, ABSOLUTE),
         math.floor(x * 65535 / (screenW - 1)),
         math.floor(y * 65535 / (screenH - 1)))
end

local function leftClick()
    local inputs = ffi.new("INPUT[2]")
    inputs[0].type = 0
    inputs[0].mi.dwFlags = LEFTDOWN
    inputs[1].type = 0
    inputs[1].mi.dwFlags = LEFTUP
    user32.SendInput(2, inputs, ffi.sizeof("INPUT"))
end

function focusWindow(title)
    local hwnd = user32.FindWindowA(nil, title)
    if hwnd == nil then return false end
    user32.ShowWindow(hwnd, 9)
    return user32.SetForegroundWindow(hwnd) ~= 0
end

-- keyboard
local special = {
    enter = 0x0D, esc = 0x1B, escape = 0x1B, space = 0x20,
    tab = 0x09, backspace = 0x08, shift = 0x10, ctrl = 0x11,
}

local function vkOf(key)
    local k = key:lower()
    if special[k] then return special[k] end
    return key:upper():byte()
end

local function keyEvent(vk, up)
    local inp = ffi.new("INPUT")
    inp.type = 1
    inp.ki.wVk = 0
    inp.ki.wScan = user32.MapVirtualKeyA(vk, 0)
    inp.ki.dwFlags = bit.bor(SCANCODE, up and KEYUP or 0)
    user32.SendInput(1, inp, ffi.sizeof("INPUT"))
end

local function tapKey(key, cb)
    local vk = vkOf(key)
    keyEvent(vk, false)
    wait(0.05, function()
        keyEvent(vk, true)
        if cb then cb() end
    end)
end

local function typeKeys(...)
    local keys = {}
    for _, k in ipairs({...}) do
        if special[k:lower()] or #k == 1 then
            keys[#keys + 1] = k
        else
            for ch in k:gmatch(".") do keys[#keys + 1] = ch end
        end
    end

    local i = 1
    local function nextKey()
        local key = keys[i]
        if not key then return end
        i = i + 1
        tapKey(key, function() wait(0.05, nextKey) end)
    end
    nextKey()
end

-- screen size
local w, h = love.window.getDesktopDimensions()
local scale = love.window.getDPIScale()
local screenW, screenH = w * scale, h * scale

function usebr()
    busyusingstuff = true

    wait(0.15, function()
        moveAbs(31, 513, screenW, screenH)
        wait(1, function()
            moveRel(-1, 0)
            leftClick()
            moveAbs(1222, 335, screenW, screenH)
            wait(1, function()
                moveRel(-1, 0)
                leftClick()
                moveAbs(1088, 369, screenW, screenH)
                wait(1, function()
                    moveRel(-1, 0)
                    leftClick()
                    wait(1, function()
                        typeKeys("Biome Randomizer")
                        moveAbs(832, 473, screenW, screenH)
                        wait(2, function()
                            moveRel(-1, 0)
                            leftClick()
                            moveAbs(569, 581, screenW, screenH)
                            wait(1,function()
                            moveRel(-1, 0)
                            leftClick()
                            wait(0.1,function()
                                

                            leftClick()
                            wait(0.3,function ()
                                tapKey("backspace")
                                typeKeys("1")
                                moveAbs(691, 574, screenW, screenH)
                                wait(0.1,function()
                                    moveRel(-1, 0)
                                    leftClick()
                                    sendWebhookMessage({
                                        title = "Auto BR and SC usage:joystick:",
                                        description = "Used biome randomizer."
                                    })
                                    moveAbs(1413, 304,screenW,screenH)
                                    wait(0.1,function()
                                        moveRel(-1,0)
                                        leftClick()
                                        busyusingstuff = false
                                    end)
                                end)
                             end)
                            end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
    
end
function usesc()
    busyusingstuff = true

    wait(0.15, function()
        moveAbs(31, 513, screenW, screenH)
        wait(1, function()
            moveRel(-1, 0)
            leftClick()
            moveAbs(1222, 335, screenW, screenH)
            wait(1, function()
                moveRel(-1, 0)
                leftClick()
                moveAbs(1088, 369, screenW, screenH)
                wait(1, function()
                    moveRel(-1, 0)
                    leftClick()
                    wait(1, function()
                        typeKeys("Strange Controller")
                        moveAbs(832, 473, screenW, screenH)
                        wait(2, function()
                            moveRel(-1, 0)
                            leftClick()
                            moveAbs(569, 581, screenW, screenH)
                            wait(1,function()
                            moveRel(-1, 0)
                            leftClick()
                            wait(0.1,function()
                                

                            leftClick()
                            wait(0.3,function ()
                                tapKey("backspace")
                                typeKeys("1")
                                moveAbs(691, 574, screenW, screenH)
                                wait(0.1,function()
                                    moveRel(-1, 0)
                                    leftClick()
                                    sendWebhookMessage({
                                        title = "Auto BR and SC usage:joystick:",
                                        description = "Used strange controller."
                                    })
                                    moveAbs(1413, 304,screenW,screenH)
                                    wait(0.1,function()
                                        moveRel(-1,0)
                                        leftClick()
                                        busyusingstuff = false
                                    end)
                                end)
                             end)
                            end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)

end
function updateWaits()
    local now = love.timer.getTime()

    for i = #waitingTasks, 1, -1 do
        local task = waitingTasks[i]

        if now >= task.time then
            table.remove(waitingTasks, i)
            task.callback()
        end
    end
end
function loadSettings()
    if not love.filesystem.getInfo("settings.json") then
        return false
    end

    local contents = love.filesystem.read("settings.json")

    local success, settings = pcall(json.decode, contents)

    if not success or not settings then
        print("Failed to decode settings.json: " .. tostring(settings))
        if alreadyshownfailure then
        else
        alreadyshownfailure = true
        warningtext = "Settings file is invalid, loaded defaults." warningTarget = 500 warningShowing = true warningTimer = 3
        return false
        end
    end


    donormalbiomedetection = settings.donormalbiomedetection or false
    dowindybiomedetection = settings.dowindybiomedetection or false
    dosnowybiomedetection = settings.dosnowybiomedetection or false
    dorainybiomedetection = settings.dorainybiomedetection or false
    dosandstormbiomedetection = settings.dosandstormbiomedetection or false
    dohellbiomedetection = settings.dohellbiomedetection or false
    dostarfallbiomedetection = settings.dostarfallbiomedetection or false
    doheavenbiomedetection = settings.doheavenbiomedetection or false
    docorruptionbiomedetection = settings.docorruptionbiomedetection or false
    donullbiomedetection = settings.donullbiomedetection or false
    dosingularitybiomedetection = settings.dosingularitybiomedetection or false
    doLostForestBiomeDetection = settings.doLostForestBiomeDetection or false
    doTheRadiantForestdetection = settings.doTheRadiantForestdetection or false
    doGraveyardBiomeDetection = settings.doGraveyardBiomeDetection or false
    doPumpkinMoonBiomeDetection = settings.doPumpkinMoonBiomeDetection or false
    shouldusebr = settings.shouldusebr or false
    shouldusesc = settings.shouldusesc or false

    webhookurl = settings.webhookurl or ""
    privateServerLink = settings.privateServerLink or ""
    censored = string.rep("*", #webhookurl)
    doauradetection = settings.doauradetection or false

    return true
end




function love.keypressed(key)

    if currentTab == "webhook" then

        if key == "v" and love.keyboard.isDown("lctrl") then
            local clipboard = love.system.getClipboardText()
            webhookurl = webhookurl .. clipboard
            censored = string.rep("*", #webhookurl)

        elseif key == "c" and love.keyboard.isDown("lctrl") then
            love.system.setClipboardText(webhookurl)

        elseif key == "backspace" then
            webhookurl = webhookurl:sub(1, -2)
            censored = censored:sub(1, -2)

        elseif key == "delete" then
            webhookurl = ""
            censored = ""

        elseif key == "l" and love.keyboard.isDown("lalt") then
            censored = webhookurl
        end


    elseif currentTab == "biome" then

        if key == "backspace" then
            privateServerLink = privateServerLink:sub(1, -2)

        elseif key == "delete" then
            privateServerLink = ""

        elseif key == "v" and love.keyboard.isDown("lctrl") then
            local clipboard = love.system.getClipboardText()
            privateServerLink = privateServerLink .. clipboard

        elseif key == "c" and love.keyboard.isDown("lctrl") then
            love.system.setClipboardText(privateServerLink)
        end

    end
end


function love.keyreleased(key)
    if key == "l" then
        censored = string.rep("*", #webhookurl)
    end

end


function love.textinput(t)

    if currentTab == "webhook" then

        if not love.keyboard.isDown("lalt")
        and not love.keyboard.isDown("lctrl") then
            webhookurl = webhookurl .. t
            censored = string.rep("*", #webhookurl)
        end

    elseif currentTab == "biome" then

        if not love.keyboard.isDown("lctrl") then
            privateServerLink = privateServerLink .. t
        end

    end

end
 local brsincelastused = 0
 local scsincelastused = 0

require("logmonitor")
local handCursor   = love.mouse.getSystemCursor("hand")
local normalCursor = love.mouse.getSystemCursor("arrow")
local tabopenclose  = love.audio.newSource("assets/sounds/coolsound.mp3", "static")
local bgm = love.audio.newSource("assets/sounds/bgm.mp3", "stream")
local bgmnight = love.audio.newSource("assets/sounds/bgmnight.mp3", "stream")
local rew = love.audio.newSource("assets/sounds/rew.mp3", "static")
local save = love.audio.newSource("assets/sounds/undertale-save.mp3", "static")
save:setVolume(0.5)
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";?.lua;?/init.lua")
love.filesystem.setCRequirePath(love.filesystem.getCRequirePath() .. ";?.dll")
local webhookThread = love.thread.newThread("webhookthread.lua")
webhookThread:start()
local robloxLogsPath = os.getenv("LOCALAPPDATA") .. "\\Roblox\\logs"
local biomeCheckTimer = 0
local logFile = nil
local logPosition = 0


bgm:setLooping(true)
macrostarted = false
local http = require("ssl.https")
local json = require("json")
local ltn12 = require("ltn12")
local menuopen = false


function saveSettings()
    print("saving settings")
local settings = {
    webhookurl = webhookurl,
    doauradetection = doauradetection,
    privateServerLink = privateServerLink,

    donormalbiomedetection = donormalbiomedetection,
    dowindybiomedetection = dowindybiomedetection,
    dosnowybiomedetection = dosnowybiomedetection,
    dorainybiomedetection = dorainybiomedetection,
    dosandstormbiomedetection = dosandstormbiomedetection,
    dohellbiomedetection = dohellbiomedetection,
    dostarfallbiomedetection = dostarfallbiomedetection,
    doheavenbiomedetection = doheavenbiomedetection,
    docorruptionbiomedetection = docorruptionbiomedetection,
    donullbiomedetection = donullbiomedetection,
    dosingularitybiomedetection = dosingularitybiomedetection,
    doTheRadiantForestdetection = doTheRadiantForestdetection,
    doLostForestBiomeDetection = doLostForestBiomeDetection,
    doGraveyardBiomeDetection = doGraveyardBiomeDetection,
    doPumpkinMoonBiomeDetection = doPumpkinMoonBiomeDetection,
    shouldusebr = shouldusebr,
    shouldusesc = shouldusesc
}

    local contents = json.encode(settings)
    love.filesystem.write("settings.json", contents)
    save:clone():play()
    warningtext = "Settings saved!"
    warningTarget = 500
    warningShowing = true
    warningTimer = 3
end
local gradient = love.graphics.newShader([[
    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords)
    {
        vec4 pixel = Texel(tex, uv) * color;

        vec3 left   = vec3(0.722, 0.898, 1.000); // #B8E5FF
        vec3 middle = vec3(0.788, 0.773, 1.000); // #C9C5FF
        vec3 right  = vec3(1.000, 0.788, 0.941); // #FFC9F0

        vec3 grad;
        float x = uv.x * 4;
        if (uv.x < 0.5)
            grad = mix(left, middle, uv.x * 2.0);
        else
            grad = mix(middle, right, (uv.x - 0.5) * 2.0);

        return vec4(grad, pixel.a);
    }
]])
function drawCheckbox(x, y, label, value, color, textoffset, gradientt)
    drawCornerBox(x, y, 40, 40)

    textoffset = textoffset or 0

    local hitbox = {
        x = x,
        y = y,
        w = 40,
        h = 40
    }

    love.graphics.setColor(1, 1, 1, 1)

    if value then
        love.graphics.print("X", x + 12, y + 5)
    end

    if color then
        love.graphics.setColor(color)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    if gradientt then
        love.graphics.setShader(gradient)
    end

    love.graphics.print(label, x - 25 + textoffset, y - 25)

    
    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)

    return hitbox
end
function sendtestwebhook(embed, content)
    if webhookurl == "" then
        print("No webhook URL provided.")
        return false
    end
    local payload = {
        embeds = {
            embed
        },
        content = content
    }

    local jsonPayload = json.encode(payload)

    local responseBody, statusCode, responseHeaders, statusLine = http.request {
        url = webhookurl,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#jsonPayload)
        },
        source = ltn12.source.string(jsonPayload)
    }

    if statusCode == 204 then
        print("Webhook sent successfully!")
                        warningtext = "webhook url is valid!"
warningTarget = 500
warningShowing = true
warningTimer = 3
        return true
    else
        print("Failed to send webhook. Status code: " .. tostring(statusCode))
        print("Response: " .. tostring(responseBody))
        warningtext = "Failed to send webhook. Status code: " .. tostring(statusCode)
warningTarget = 500
warningShowing = true
warningTimer = 3
        return false
    end
end

function sendWebhookMessage(embed, content)
    if webhookurl == "" then
        return false
    end

    local channel = love.thread.getChannel("webhookQueue")

    channel:push({
        url = webhookurl,
        embed = embed,
        content = content
    })

    return true
end

    local jsonPayload = json.encode(payload)


function testWebhook()
    sendtestwebhook(nil, "test")
end

local function pointInBox(px, py, box)
    if not box then
        return false
    end

    return px >= box.x and px <= box.x + box.w
       and py >= box.y and py <= box.y + box.h
end

local function isOverMenu(mx, my)
    return pointInBox(mx - tabmenuX, my, menuHitbox)
end

function love.mousepressed(x, y, button)
    if button == 1 then

        local bx, by, bw, bh = 740, 550, 250, 30
        

        if x >= bx and x <= bx + bw and y >= by and y <= by + bh then
            love.system.openURL("https://discord.gg/BvMqebGsjk")
        end
    end

    if button ~= 1 then return end
        if pointInBox(x, y, savesettingshitbox) then
        saveSettings()
    end
    if pointInBox(x, y, doauradetectionbuttonhitbox) and currentTab == "aura" then
        if doauradetection == false then
            doauradetection = true
            rew:clone():play()
        else
            doauradetection = false
            rew:clone():play()
        end
    end
    

    if isOverMenu(x, y) then
        local playingsound = tabopenclose:clone()
        playingsound:play()
        menuopen = not menuopen
    end
    bgmnight:setLooping(true)

local t = os.date("*t")
local seconds = t.hour * 3600 + t.min * 60 + t.sec
    if pointInBox(x, y, songHitbox) then
        if songstate == "play bgm?" then
            if seconds >= 0 and seconds <= 18000 then
                bgmnight:play()
            else
                bgm:play()
            end
            rew:clone():play()
            songstate = "stop bgm?"
        else
            if bgmnight:isPlaying() == true then
                bgmnight:stop()
            else
                bgm:stop()
            end
            rew:clone():play()
            songstate = "play bgm?"
        end
    end

    if pointInBox(x, y, mainControlsHitbox) then
        lasttab = currentTab
        currentTab = "maincontrols"
        rew:clone():play()


    elseif pointInBox(x, y, webhookHitbox) then
        lasttab = currentTab
        currentTab = "webhook"
        rew:clone():play()


    elseif pointInBox(x, y, auraHitbox) then
        lasttab = currentTab
        currentTab = "aura"
        rew:clone():play()


    elseif pointInBox(x, y, biomeHitbox) then
        lasttab = currentTab
        currentTab = "biome"
        rew:clone():play()


    elseif pointInBox(x, y, fishingHitbox) then
        lasttab = currentTab
        currentTab = "fishing"
        rew:clone():play()


    elseif pointInBox(x, y, creditsHitbox) then
        lasttab = currentTab
        currentTab = "credits"
        rew:clone():play()


    elseif pointInBox(x, y, licensesHitbox) then
        lasttab = currentTab
        currentTab = "licenses"
        rew:clone():play()
    elseif pointInBox(x, y, AutoUsageHitbox) then
        lasttab = currentTab
        currentTab = "autobrscuse"
    end
    if pointInBox(x, y, normalBiomeHitbox) then
    donormalbiomedetection = not donormalbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, windyBiomeHitbox) then
    dowindybiomedetection = not dowindybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, snowyBiomeHitbox) then
    dosnowybiomedetection = not dosnowybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, rainyBiomeHitbox) then
    dorainybiomedetection = not dorainybiomedetection
    rew:clone():play()
end

if pointInBox(x, y, sandstormBiomeHitbox) then
    dosandstormbiomedetection = not dosandstormbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, hellBiomeHitbox) then
    dohellbiomedetection = not dohellbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, starfallBiomeHitbox) then
    dostarfallbiomedetection = not dostarfallbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, heavenBiomeHitbox) then
    doheavenbiomedetection = not doheavenbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, corruptionBiomeHitbox) then
    docorruptionbiomedetection = not docorruptionbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, nullBiomeHitbox) then
    donullbiomedetection = not donullbiomedetection
    rew:clone():play()
end

if pointInBox(x, y, singularityBiomeHitbox) then
    dosingularitybiomedetection = not dosingularitybiomedetection
    rew:clone():play()
end

 if pointInBox(x, y, TheRadiantForestBiomeHitbox) then
   doTheRadiantForestdetection = not doTheRadiantForestdetection
   rew:clone():play()
end
 if pointInBox(x, y, LostForestBiomeHitbox) then
    doLostForestBiomeDetection = not doLostForestBiomeDetection
    rew:clone():play()
 end
 if pointInBox(x,y, PumpkinMoonBiomeHitbox) then
    doPumpkinMoonBiomeDetection = not doPumpkinMoonBiomeDetection   
    rew:clone():play()
 end
 if pointInBox(x,y, GraveyardBiomeHitbox) then
    doGraveyardBiomeDetection = not doGraveyardBiomeDetection   
    rew:clone():play()
 end
 if pointInBox(x,y, autobrusehitbox) then
    shouldusebr = not shouldusebr
    rew:clone():play()
 end
    if pointInBox(x,y, autoscusehitbox) then
    shouldusesc = not shouldusesc
    rew:clone():play()
    end

    if currentTab == "maincontrols" then
    if pointInBox(x, y, startButtonHitbox) then

    if macrostarted == false then
        sendWebhookMessage({
    title = os.date("%d.%m.%Y %H:%M:%S"),
    description = "# Macro started!"
    ,
    color = 0x02f042,

    thumbnail = {
        url = "https://raw.githubusercontent.com/finnsgthbthingy/stuff/main/luasol.png"
    },

    footer = {
        text = "LuaSol v1.0"
    }
}, nil)
        macrostarted = true
            focusWindow("Roblox")
     checkBiome()
        warningtext = "Macro started!"
warningTarget = 500
warningShowing = true
warningTimer = 3
        

        rew:clone():play()
    else
        sendWebhookMessage({
    title = os.date("%d.%m.%Y %H:%M:%S"),
    description = "# Macro stopped!"
    ,
    color = 0xf0020a,

    thumbnail = {
        url = "https://raw.githubusercontent.com/finnsgthbthingy/stuff/main/luasol.png"
    },

    footer = {
        text = "LuaSol v1.0"
    }
}, nil)
        macrostarted = false
        
        if logFile then
            logFile:close()
            logFile = nil
        end

        rew:clone():play()
    end
end
end

    if pointInBox(x, y, webhookButtonHitbox) then
        if currentTab ==  "webhook" then
        testWebhook()
        rew:clone():play()
    end
end
end
    local memTimer = 0
        local brTimer = 0
        local sctimer = 0
function love.update(dt)
    if macrostarted == true and busyusingstuff == false and brsincelastused == 0 and shouldusebr == true then
        usebr()
        brsincelastused = 35
    end
        if brsincelastused > 0 then
        brTimer = brTimer + dt
        if brTimer >= 60 then
            brTimer = brTimer - 60
            brsincelastused = brsincelastused - 1
        end
    end
    if macrostarted == true and busyusingstuff == false and scsincelastused == 0 and shouldusesc == true then
        usesc()
        scsincelastused = 20
    end
        if scsincelastused > 0 then
        sctimer = sctimer + dt
        if sctimer >= 60 then
            sctimer = sctimer - 60
            scsincelastused = scsincelastused - 1
        end
    end

    updateWaits()
    
  local speed = 2.5

    if warningTarget == -500 then
        speed = 1.0
    end



    if warningShowing then
        warningTimer = warningTimer - dt

        if warningTimer <= 0 then
            warningTarget = -500
            warningShowing = false
        end
    end
    memTimer = memTimer + dt

    if memTimer >= 5 then
        memTimer = 0

        print(string.format(
            "Lua heap: %.2f MB",
            collectgarbage("count") / 1024

        ))
        collectgarbage("collect")
        print("AFTER GC:", collectgarbage("count") / 1024, "MB")
    end

if macrostarted == true then
    biomeCheckTimer = biomeCheckTimer + dt

    if biomeCheckTimer >= 1 then
        biomeCheckTimer = 0
  checkBiome()
    end
else
    biomeCheckTimer = 0
end
local target = menuopen and 200 or 9
tabmenuX = tabmenuX + (target - tabmenuX) * 10 * dt
    warningx = warningx + (warningTarget - warningx) * 2 * dt

    mainControlsHitbox.x = tabmenuX - 195
    webhookHitbox.x = tabmenuX - 195
    auraHitbox.x = tabmenuX - 195
    biomeHitbox.x = tabmenuX - 195
    fishingHitbox.x = tabmenuX - 195
    creditsHitbox.x = tabmenuX - 195
    licensesHitbox.x = tabmenuX - 195
    AutoUsageHitbox.x = tabmenuX - 195
    local mx, my = love.mouse.getPosition()

    if isOverMenu(mx, my)
    or pointInBox(mx, my, savesettingshitbox)
    or pointInBox(mx, my, mainControlsHitbox)
    or pointInBox(mx, my, doauradetectionbuttonhitbox) and currentTab == "aura"
    or pointInBox(mx, my, startButtonHitbox) and currentTab == "maincontrols"
    or pointInBox(mx, my, webhookButtonHitbox) and currentTab == "webhook"
    or pointInBox(mx, my, webhookHitbox)
    or pointInBox(mx, my, auraHitbox)
    or pointInBox(mx, my, biomeHitbox)
    or pointInBox(mx, my, fishingHitbox)
    or pointInBox(mx, my, creditsHitbox)
    or pointInBox(mx, my, licensesHitbox)
    or pointInBox(mx, my, songHitbox)
    or pointInBox(mx, my, normalBiomeHitbox)
    or pointInBox(mx, my, windyBiomeHitbox)
    or pointInBox(mx, my, snowyBiomeHitbox)
    or pointInBox(mx, my, rainyBiomeHitbox)
    or pointInBox(mx, my, sandstormBiomeHitbox)
    or pointInBox(mx, my, hellBiomeHitbox)
    or pointInBox(mx, my, starfallBiomeHitbox)
    or pointInBox(mx, my, heavenBiomeHitbox)
    or pointInBox(mx, my, corruptionBiomeHitbox)
    or pointInBox(mx, my, singularityBiomeHitbox)
    or pointInBox(mx, my, GraveyardBiomeHitbox)
    or pointInBox(mx, my, PumpkinMoonBiomeHitbox)
    or pointInBox(mx, my, TheRadiantForestBiomeHitbox)
    or pointInBox(mx, my, LostForestBiomeHitbox)
    or pointInBox(mx, my, AutoUsageHitbox)
    or pointInBox(mx, my, autobrusehitbox)
    or pointInBox(mx, my, autoscusehitbox) then

        love.mouse.setCursor(handCursor)
    else
        love.mouse.setCursor(normalCursor)
    end
end
function drawCornerBox(x, y, w, h)
        love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, w, h)

        love.graphics.setColor(0,0,0,0.5)

    love.graphics.rectangle("fill", x + 2, y + 2, w - 4, h - 4)



    


    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", x + 2, y + 2, 10, 2)
    love.graphics.rectangle("fill", x + 2, y + 2, 2, 10)

    love.graphics.rectangle("fill", x + w - 12, y + 2, 10, 2)
    love.graphics.rectangle("fill", x + w - 4, y + 2, 2, 10)

    love.graphics.rectangle("fill", x + 2, y + h - 4, 10, 2)
    love.graphics.rectangle("fill", x + 2, y + h - 12, 2, 10)

    love.graphics.rectangle("fill", x + w - 12, y + h - 4, 10, 2)
    love.graphics.rectangle("fill", x + w - 4, y + h - 12, 2, 10)

    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
end
savesettingshitbox = {
    x = 800,
     y =   60,
     w=   200,
     h=   40
}
mainControlsHitbox = {
    x = tabmenuX - 195,
    y = 5,
    w = 185,
    h = 40
}

webhookHitbox = {
    x = tabmenuX - 195,
    y = 50,
    w = 185,
    h = 40
}

auraHitbox = {
    x = tabmenuX - 195,
    y = 95,
    w = 185,
    h = 40
}

biomeHitbox = {
    x = tabmenuX - 195,
    y = 140,
    w = 185,
    h = 40
}

fishingHitbox = {
    x = tabmenuX - 195,
    y = 185,
    w = 185,
    h = 40
}
AutoUsageHitbox = {
    x = tabmenuX - 195,
    y = 230,
    w = 185,
    h = 40
}
creditsHitbox = {
    x = tabmenuX - 195,
    y = 275,
    w = 185,
    h = 40
}

licensesHitbox = {
    x = tabmenuX - 195,
    y = 320,
    w = 185,
    h = 40
}
startButtonHitbox = {
    x = 400,
    y = 45,
    w = 160,
    h = 30
}
