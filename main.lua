
io.stdout:setvbuf("no")

Object = require('libraries/classic/classic')
moonshine = require('libraries/moonshine')
require("font")
require("audio")

require("utils")

require("player")
require("bullet")
require("screens/title")
require("screens/lore")
require("screens/game")
require("enemies/static")
require("enemies/chaser")

room_width = 800
room_height = 600

frame = 0

maxNormalDeathMessagesInRow = 3                                                  -- After the third normal death message, the next one is custom
normalMessagesInRowCounter = 0                                                   -- Counter of normal messages in a row


function love.load()
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    scale_unit = room_width/200
    loadSounds()
    loadFonts()
    sounds.bgm:play()
    current_screen = Title()
    cross = love.graphics.newText( fonts.dos, "X" )
    effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt)
    effect.scanlines.opacity = 0.5
end

function love.mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)

end

function love.keypressed(key)
    current_screen:keypressed(key)
end

function love.keyreleased(key)

end


function love.update(dt)
    frame = frame + 1
    current_screen:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor( 0.1, 0.1, 0.1)
    effect(function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, screen_width, screen_height)
        love.graphics.setLineStyle("rough")
        love.graphics.setDefaultFilter("nearest","nearest",1)
        current_screen:draw()
    end)
end


function love.quit()
end
