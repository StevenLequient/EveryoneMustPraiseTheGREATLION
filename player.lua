player = {}

function player:init()
    self.max_speed = 200 * scale_unit
    self.acceleration = 5000 * scale_unit
    self.friction = 2500 * scale_unit
    self.bullet_speed = 300 * scale_unit
    self.pos = {x=50,y=50}
    self.size = 3 * scale_unit
    self.angle = 0
    self.speed = {x=0,y=0}
    self.bullet = nil
    self.bullet_attraction = {}
    self.bullet_attraction.player_pos = {x=0,y=0}
    self.bullet_attraction.bullet_pos = {x=0,y=0}
    self.bullet_attraction.lifetime = 0
    self.bullet_size = 3 * scale_unit
    self.hit_radius = 2 * scale_unit
    self.dead = false
end

function player:update(dt)
    self.bullet_attraction.lifetime = clamp(self.bullet_attraction.lifetime - dt, 0, 10000)

    self.speed.x = self.speed.x - sign(self.speed.x) * clamp(self.friction*dt,0,math.abs(self.speed.x))
    self.speed.y = self.speed.y - sign(self.speed.y) * clamp(self.friction*dt,0,math.abs(self.speed.y))

    if love.keyboard.isDown("down") then
        self.speed.y = self.speed.y + self.acceleration*dt
    end
    if love.keyboard.isDown("up") then
        self.speed.y = self.speed.y - self.acceleration*dt
    end
    if love.keyboard.isDown("right") then
        self.speed.x = self.speed.x + self.acceleration*dt
    end
    if love.keyboard.isDown("left") then
        self.speed.x = self.speed.x - self.acceleration*dt
    end

    self.speed.x = clamp(self.speed.x, -self.max_speed,self.max_speed)
    self.speed.y = clamp(self.speed.y, -self.max_speed,self.max_speed)

    self.pos = add(self.pos, mul(self.speed, dt))

    if(self.speed.x ~= 0 or self.speed.y ~= 0) then
        self.angle = vec2angle(self.speed)
    end

    self.pos.x = clamp(self.pos.x,0,room_width)
    self.pos.y = clamp(self.pos.y,0,room_height)

    if self.bullet then
        self.bullet:update(dt)
    end
end

function player:action()
    if not self.dead then
        if self.bullet == nil then
            sounds:playShoot()
            bullet_speed = angle2vec(self.angle)
            bullet_speed.x = bullet_speed.x * self.bullet_speed
            bullet_speed.y = bullet_speed.y * self.bullet_speed
            self.bullet = Bullet(add(self.pos,mul(angle2vec(self.angle),self.size+self.bullet_size)),bullet_speed,self.bullet_size,-1, "player")
        else
            sounds:playAction()
            self.bullet.speed = mul(normalize(diff(self.pos,self.bullet.pos)),self.bullet_speed)
            self.bullet_attraction.player_pos = copy(self.pos)
            self.bullet_attraction.bullet_pos = copy(self.bullet.pos)
            self.bullet_attraction.lifetime = 0.1
        end
    end
end

function player:draw()
    if self.dead then
        love.graphics.setColor(1,0,0)
        triangle = polygon(3,self.pos,self.size,self.angle)
        love.graphics.polygon("fill", triangle)
        love.graphics.draw(cross,self.pos.x-10,self.pos.y-20)
    else
        if self.bullet then
            self.bullet:draw()
        end

        if self.bullet_attraction.lifetime > 0 then
            love.graphics.setColor(1,0,0,0.5)
            love.graphics.setLineWidth(1 * scale_unit)
            love.graphics.line(
                self.bullet_attraction.player_pos.x,
                self.bullet_attraction.player_pos.y,
                self.bullet_attraction.bullet_pos.x,
                self.bullet_attraction.bullet_pos.y
            )
        end

        love.graphics.setColor(0.6,0.6,1)
        triangle = polygon(3,self.pos,self.size,self.angle)
        love.graphics.polygon("fill", triangle)
    end
end

function player:die()
    if not self.dead then
        sounds:playPlayerDeath()
    end
    self.dead = true
end
