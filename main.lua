-- external libraries
Class = require 'class'
push = require 'push'

require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local BACKGROUND_IMAGE = love.graphics.newImage('assets/images/background.png')
local GROUND_IMAGE = love.graphics.newImage('assets/images/ground.png')

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

function love.load()

    math.randomseed(os.time())

    love.window.setTitle("Fifty Bird")

    love.graphics.setDefaultFilter('nearest','nearest')

    smallFont = love.graphics.newFont('assets/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('assets/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('assets/fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then 
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(BACKGROUND_IMAGE, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(GROUND_IMAGE, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end

