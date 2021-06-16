Game = Object:extend()

function Game:new(level)
    player:init()
    bullets = {}
    enemies = {}    --Static({x=100, y=50}),Chaser({x=160, y=100})
    deathMessages = {}

    deathMessages[#deathMessages+1] = "They will not be pleased."
    deathMessages[#deathMessages+1] = "Again, again, again..."
    deathMessages[#deathMessages+1] = "It draws near."
    deathMessages[#deathMessages+1] = "You will meet them."
    deathMessages[#deathMessages+1] = "In time, you'll forget."
    deathMessages[#deathMessages+1] = "It is already happening..."
    deathMessages[#deathMessages+1] = "Do you realize what's at stake?"
    deathMessages[#deathMessages+1] = "Do you need sentience?"
    deathMessages[#deathMessages+1] = "A lost self."
    deathMessages[#deathMessages+1] = "Few know."

    deathMessage = love.graphics.newText(fonts.dos,"")
    currentDeathMessage = nil
    levelNumber = level                                                             -- Current game level
    remainingEncounterDifficulty = 0                                                -- Number of arbitrary difficulty points spent on ennemy placement

    minDistanceBetweenEnemiesAndPlayer = 60 * scale_unit
    minDistanceBetweenEnemies = 15 * scale_unit
    minDistanceWithWall = 15 * scale_unit
    numberOfTriesUntilLoweringMinDistanceBetweenEnemies = 50
    levelText = love.graphics.newText(fonts.dos,"")
    self:loadLevel()                                                                -- Loads the first level
end

function Game:loadLevel()
    if levelNumber == 5 then
        player:init()
        bullets = {}
        enemies = {}
        current_screen = Lore(1,self)
    end
    if levelNumber == 10 then
        player:init()
        bullets = {}
        enemies = {}
        current_screen = Lore(2,self)
    end
    if levelNumber == 15 then
        player:init()
        bullets = {}
        enemies = {}
        current_screen = Lore(3,self)
    end
    if levelNumber < 10 then
        remainingEncounterDifficulty = levelNumber
    else
        remainingEncounterDifficulty = 10 + math.floor(levelNumber/2)               -- Once the difficulty is high enough, slow down the difficulty curve
    end
    self:randomlySpawnEnemies()                                                     -- Randomly spawn enemies depending on the level until we are out of points
    levelText:set(levelNumber)
end

function Game:randomlySpawnEnemies()
    for i = 1, remainingEncounterDifficulty do
        --print("difficulty placed:" .. i)
        --print("remainingEncounterDifficulty:" .. remainingEncounterDifficulty)
        -- Randomly pick a free point on the arena until it works, or lower the expectations
        local placementTry = 1
        local placementSuccess = false
        while placementSuccess == false and placementTry < numberOfTriesUntilLoweringMinDistanceBetweenEnemies do
            --print("placementTry: " .. placementTry)
            local randomX = love.math.random(minDistanceWithWall, room_width - minDistanceWithWall)
            local randomY = love.math.random(minDistanceWithWall, room_height - minDistanceWithWall)
            local currentPos = {x=randomX, y=randomY}

            local isDistanceOK = true
            -- Assure the placement is at a minimum distance from the player
            local distWithPlayer = dist(currentPos, player.pos)
            if distWithPlayer < minDistanceBetweenEnemiesAndPlayer then
                isDistanceOK = false
            end

            -- Iterate through all the ennemies to assure the placement is at a minimum distance
            --print("---#enemies: " .. #enemies)
            for enemyNumber = 1, #enemies do
                --print("ennemy for distance: " .. enemyNumber)

                local distWithNearestEnnemy = dist(currentPos, enemies[enemyNumber].pos)
                if distWithNearestEnnemy < minDistanceBetweenEnemies then
                    --print("placement FAILED: " .. enemyNumber)
                    isDistanceOK = false
                end
            end

            if isDistanceOK then
                -- A correct position have been found : roll for enemy type
                placementSuccess = true
                local ennemyTypeNumber = love.math.random(1, 2)               -- Chooses between the enemy types we have             --TODO change if we add new ennemies
                if ennemyTypeNumber == 1 then
                    table.insert(enemies, Static(currentPos) )
                elseif ennemyTypeNumber == 2 then
                    table.insert(enemies, Chaser(currentPos) )
                end
            else
                placementTry = placementTry + 1
                if placementTry >= numberOfTriesUntilLoweringMinDistanceBetweenEnemies then
                    -- If we exceed the number of tries we lower the minimal distance between enemies and try again
                    minDistanceBetweenEnemies = minDistanceBetweenEnemies - 2
                    placementTry = 1
                end
            end
        end
    end
end

function Game:keypressed(key)
    if key == "x" then
        player:action()
    end
    if key == "r" and player.dead then
        self:new(1)
    end
end

function Game:update(dt)
    if not player.dead then
        player:update(dt)

        for i = 1, #enemies do
            enemies[i]:update(dt)
        end

        for i = 1, #bullets do
            bullets[i]:update(dt)
        end

        if player.bullet then
            local distance = norm(diff(player.bullet.pos,player.pos))
            if distance < player.bullet.hurt_radius + player.hit_radius then
                player:die()
            end
        end
        for i = 1, #bullets do
            local distance = norm(diff(bullets[i].pos,player.pos))
            if distance < bullets[i].hurt_radius + player.hit_radius then
                player:die()
            end
        end
        for i = 1, #enemies do
            if player.bullet then
                local distance = norm(diff(player.bullet.pos,enemies[i].pos))
                if distance < player.bullet.hurt_radius + enemies[i].hit_radius then
                    enemies[i]:die()
                end
            end
            local distance = norm(diff(player.pos,enemies[i].pos))
            if distance < enemies[i].hurt_radius + player.hit_radius then
                player:die()
            end
        end

        for i = #enemies, 1, -1 do
            if enemies[i].delete then
                table.remove(enemies, i)
            end
        end
        for i = #bullets, 1, -1 do
            if bullets[i].delete then
                table.remove(bullets, i)
            end
        end

        if #enemies == 0 then
            levelNumber = levelNumber + 1
            self:loadLevel()
        end
    end
end

function Game:draw()
    --love.graphics.scale(screen_width/room_width,screen_height/room_height)
    player:draw()

    for i = 1, #enemies do
        enemies[i]:draw()
    end

    for i = 1, #bullets do
        bullets[i]:draw()
    end

    -- Death screen
    if player.dead then
        if currentDeathMessage == nil then
            self:pickDeathMessage()
        end

        -- RGB(pure black with 0.7 opacity): 222, 144, 0
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, screen_width, screen_height)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(deathMessage, 10, 200)
        retryMessage = love.graphics.newText(fonts.dos,"NOW PRESS \"R\" AND RETRY.")
        love.graphics.draw(retryMessage, 10, 400)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(levelText,10,10)
end


function Game:pickDeathMessage()
    local isDeathMessageSpecial = love.math.random(1, 3)                            -- 1 chance out of 3 to have a special message
    if normalMessagesInRowCounter >= maxNormalDeathMessagesInRow or isDeathMessageSpecial == 1 then
        currentDeathMessage = deathMessages[love.math.random(1, #deathMessages)]
        normalMessagesInRowCounter = 0
    else
        currentDeathMessage = "YOU HAVE FAILED."
        normalMessagesInRowCounter = normalMessagesInRowCounter + 1
    end
    deathMessage:set(currentDeathMessage)
end
