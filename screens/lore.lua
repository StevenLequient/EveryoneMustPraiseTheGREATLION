

Lore = Object:extend()

function Lore:new(n,game_screen)
    self.game_screen = game_screen
    self.n = n
    self.messages = {}
    self.messages[#self.messages+1] = love.graphics.newText( fonts.dos, "The worlds are merging.\nAll at once.\nThe GREAT LION continues." )
    self.messages[#self.messages+1] = love.graphics.newText( fonts.dos, "You might be lost.\nAll in time.\nEveryone will cross.\nAnd be one." )
    self.messages[#self.messages+1] = love.graphics.newText( fonts.dos, "The end is just the edge.\nThe GREAT LION is an exit.\nUnifying the ONE." )
end

function Lore:keypressed(key)
    if key == "x" then
        current_screen = self.game_screen
    end
end


function Lore:update(dt)

end


function Lore:draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.messages[self.n], 10,10)
end
