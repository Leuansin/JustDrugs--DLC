DrugsDLC = {}

local hideImage = getTexture("media/ui/Hide Effect.png")
local drawHideCanvas = false
local opacity = 0
local screenWidth = nil
local screenHeight = nil
local npcGlitch

local function setHideImage(texturePath)
    hideImage = getTexture("media/ui/" .. texturePath .. ".png")
end

local function forceTeleport()
    local playerObj = getPlayer(); if not playerObj then return end
    if playerObj:getZ() == 13 then return end

    playerObj:setZ(13)
    playerObj:setbFalling(false)
    playerObj:setFallTime(0)
    playerObj:setLastFallSpeed(0)
end

function OnEat_AlucinacionesFunc(playerObj)

    if getWorld():getGameMode() == "Multiplayer" then
        playerObj:setZ(13)
        setHideImage("FullEffect")
        Events.OnTick.Add(forceTeleport)
    else
        setHideImage("MildEffect")
        Events.OnTick.Add(forceTeleport)
    end

    drawHideCanvas = true
end

function DrawHideCanvas()
    if drawHideCanvas == true then
        if opacity < 1 then opacity = opacity + 0.1 end
        UIManager.DrawTexture( hideImage, 0, 0, screenWidth, screenHeight, opacity)
    else
        if opacity > 0 then
            opacity = opacity - 0.006
            UIManager.DrawTexture( hideImage, 0, 0, screenWidth, screenHeight, opacity)
        end
    end
end

Events.OnPreUIDraw.Add(DrawHideCanvas)

local onGameStart = function()
	local playerObj = getPlayer(); if not playerObj then return end
    local playerNum = playerObj:getPlayerNum()
    screenWidth = getPlayerScreenWidth(playerNum)
    screenHeight = getPlayerScreenHeight(playerNum)
end

Events.OnGameStart.Add(onGameStart)