sounds = {}

function loadSounds()
    sounds.bulletBounce = love.audio.newSource("resources/audio/BulletBounce.wav", "static")
    sounds.bgm = love.audio.newSource("resources/audio/greatlion.ogg", "static")
    sounds.bgm:setVolume(0.7)
    sounds.bgm:setLooping(true)
    sounds.death = love.audio.newSource("resources/audio/death.wav", "static")
    sounds.death:setVolume(0.3)
    sounds.playerDeath = love.audio.newSource("resources/audio/playerDeath.wav", "static")
    sounds.playerDeath:setVolume(0.8)
    sounds.shoot = love.audio.newSource("resources/audio/shoot.wav", "static")
    sounds.action = love.audio.newSource("resources/audio/action.wav", "static")
end

function sounds:playBulletBounce()
    self.bulletBounce:stop()
    local p = love.math.randomNormal(0.2,1)
    self.bulletBounce:setPitch(p)
    self.bulletBounce:play()
end

function sounds:playEnemyDeath()
    self.death:stop()
    local p = love.math.randomNormal(0.2,1)
    self.death:setPitch(p)
    self.death:play()
end

function sounds:playPlayerDeath()
    self.playerDeath:stop()
    local p = love.math.randomNormal(0.2,0.8)
    self.playerDeath:setPitch(p)
    self.playerDeath:play()
end

function sounds:playShoot()
    self.shoot:stop()
    local p = love.math.randomNormal(0.2,1)
    self.shoot:setPitch(p)
    self.shoot:play()
end

function sounds:playAction()
    self.action:stop()
    local p = love.math.randomNormal(0.2,1)
    self.action:setPitch(p)
    self.action:play()
end