
Bullet = Object:extend()

function Bullet:new(pos,speed,size,max_bounces,type)
    self.pos = pos
    self.type = type
    self.speed = speed
    self.size = size
    self.max_bounces = max_bounces
    self.remaining_bounces = max_bounces
    self.flaggedForDeletion = false
    self.hurt_radius = size
    self.delete = false
end

function Bullet:update(dt)
    self.pos = add(self.pos, mul(self.speed, dt))

    local bounce = false

    -- if max_bounces is -1, the ball can bounce forever
    if self.max_bounces == -1 or self.remaining_bounces > 0 then
        if self.pos.x <= 0 then
            self.remaining_bounces = self.remaining_bounces - 1
            self.pos.x = -self.pos.x
            self.speed.x = -self.speed.x
            bounce = true
        end
        if self.pos.x >= room_width then
            self.remaining_bounces = self.remaining_bounces - 1
            self.pos.x = room_width - (self.pos.x - room_width)
            self.speed.x = -self.speed.x
            bounce = true
        end
        if self.pos.y <= 0 then
            self.remaining_bounces = self.remaining_bounces - 1
            self.pos.y = -self.pos.y
            self.speed.y = -self.speed.y
            bounce = true
        end
        if self.pos.y >= room_height then
            self.remaining_bounces = self.remaining_bounces - 1
            self.pos.y = room_height - (self.pos.y - room_height)
            self.speed.y = -self.speed.y
            bounce = true
        end
    else
        if self.pos.x <= 0 or self.pos.x >= room_width or self.pos.y <= 0 or self.pos.y >= room_height then
            self.delete = true
        end
    end

    if bounce then
        sounds:playBulletBounce()
    end
end

function Bullet:draw(dt)
    love.graphics.setLineWidth(1 * scale_unit)
    if self.type == "static" then
        -- rgb bright red (255,0,0)
        love.graphics.setColor(1,0,0)
        love.graphics.circle("line",self.pos.x,self.pos.y,self.size)
    elseif self.type == "player" then
        -- bright purple: rgb(169, 113, 255)
        love.graphics.setColor(0.66,0.44,1)
        love.graphics.circle("fill",self.pos.x,self.pos.y,self.size)
    else
        print("BULLET TYPE UNDEFINED")
    end

end
