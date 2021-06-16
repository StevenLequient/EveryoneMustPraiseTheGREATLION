
Static = Object:extend()

function Static:new(pos)
    self.type = "static"
    self.pos = pos
    self.size = 5 * scale_unit
    self.max_speed = 0 * scale_unit
    self.speed = {x=0,y=0}
    self.angle = 0
    self.fireCooldown = 50
    self.framesSinceLastShot = 0
    self.bulletMaxSpeed = 75 * scale_unit
    self.bulletSize = 2 * scale_unit
    self.hit_radius = self.size
    self.hurt_radius = self.size
    self.dead = false
    self.dead_since = 0
    self.delete = false
end

function Static:update(dt)
    if self.dead then
        self.dead_since = self.dead_since + dt
        if self.dead_since > 0.5 then
            self.delete = true
        end
    else
        self.framesSinceLastShot = self.framesSinceLastShot + 1
        if self.framesSinceLastShot > self.fireCooldown then
            self:fireTowardPlayer()
            self.framesSinceLastShot = 0
        end
    end
end

function Static:draw()
    love.graphics.setLineWidth(1 * scale_unit)
    if self.dead then
        if frame%4 < 3 then
            love.graphics.setColor(1,0,0)
            love.graphics.circle("line", self.pos.x,self.pos.y,self.size)
            love.graphics.draw(cross,self.pos.x-10,self.pos.y-20)
        end
    else
        -- RGB(orange): 222, 144, 0
        love.graphics.setColor(0.87,0.56,0)
        love.graphics.circle("line", self.pos.x,self.pos.y,self.size)

        local angleToPlayer = vec2angle(vectorFromPointToPlayer(self.pos))
        local insideSquare = polygon(4,self.pos,self.size/1.5,angleToPlayer)
        love.graphics.polygon("line", insideSquare)
    end
end

function Static:fireTowardPlayer()
    local bulletSpeed = mul( normalize( vectorFromPointToPlayer(self.pos) ), self.bulletMaxSpeed )
    local new_bullet = Bullet(self.pos, bulletSpeed, self.bulletSize, 0, "static")
    table.insert(bullets, new_bullet)
end

function Static:die()
    if not self.dead then
        sounds:playEnemyDeath()
    end
    self.dead = true
end
