
Title = Object:extend()

function Title:new()
    self.game_title = love.graphics.newText( fonts.dos, "Everyone must praise the GREAT LION" )

    self.tutorial_1 = love.graphics.newText( fonts.dos, "Your bullet will destroy them." )
    self.tutorial_2 = love.graphics.newText( fonts.dos, "Avoid it yourself, or die." )
    self.tutorial_3 = love.graphics.newText( fonts.dos, "Press \"x\" to shoot the bullet." )
    self.tutorial_4 = love.graphics.newText( fonts.dos, "Press \"x\" again to attract it." )

    self.start = love.graphics.newText( fonts.dos, "Press \"x\" to start." )
end

function Title:keypressed(key)
    if key == "x" then
        current_screen = Game(1)        -- Starts the first level
    end
end


function Title:update(dt)

end


function Title:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.game_title, 10,10)

    love.graphics.draw(self.tutorial_1, 10,150)
    love.graphics.draw(self.tutorial_2, 10,200)
    love.graphics.draw(self.tutorial_3, 10,350)
    love.graphics.draw(self.tutorial_4, 10,400)

    love.graphics.draw(self.start, 10,550)
end
