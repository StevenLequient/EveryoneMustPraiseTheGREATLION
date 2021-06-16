
Chaser = Object:extend()

function Chaser:new(pos)
    self.type = "chaser"
    self.pos = pos
    self.size = 3 * scale_unit
    self.max_speed = 60 * scale_unit
    self.speed = {x=0,y=0}
    self.hit_radius = self.size
    self.hurt_radius = self.size
    self.dead = false
    self.dead_since = 0
    self.delete = false
end

function Chaser:update(dt)
    if self.dead then
        self.dead_since = self.dead_since + dt
        if self.dead_since > 0.5 then
            self.delete = true
        end
    else
        local unitVectTowardPlayer = normalize( vectorFromPointToPlayer(self.pos) )
        self.pos.x = self.pos.x + self.max_speed*dt*unitVectTowardPlayer.x
        self.pos.y = self.pos.y + self.max_speed*dt*unitVectTowardPlayer.y

        self.pos.x = clamp(self.pos.x,0,room_width)
        self.pos.y = clamp(self.pos.y,0,room_height)
    end
end

function Chaser:draw()
    love.graphics.setLineWidth(1 * scale_unit)
    if self.dead then
        if frame%4 < 3 then
            love.graphics.setColor(1,0,0)
            love.graphics.circle("line", self.pos.x,self.pos.y,self.size)
            love.graphics.draw(cross,self.pos.x-10,self.pos.y-20)
        end
    else
        -- red-pink
        love.graphics.setColor(1,0.1,0.4)
        love.graphics.circle("line", self.pos.x,self.pos.y,self.size)

        local angleToPlayer = vec2angle(vectorFromPointToPlayer(self.pos))
        local insideTriangle = polygon(3,self.pos,self.size/1.5,angleToPlayer)
        love.graphics.polygon("line", insideTriangle)
    end
end

function Chaser:die()
    if not self.dead then
        sounds:playEnemyDeath()
    end
    self.dead = true
end
