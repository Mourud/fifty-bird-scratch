-- external libraries
Class = require 'class'
push = require 'push'

require 'Bird'
require 'Pipe'
require 'PipePair'

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

local bird = Bird()

local pipePairs = {}

local spawnTimer = 0

local lastGapY = -PIPE_HEIGHT + math.random(80) + 20

local scolling = true

function love.load()

    math.randomseed(os.time())

    love.window.setTitle("Fifty Bird")

    love.graphics.setDefaultFilter('nearest','nearest')

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })

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
    if scolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
        
        spawnTimer = spawnTimer + dt
        spawnTime = math.random(2,30)
        if spawnTimer > spawnTime then
            local y = math.max(-PIPE_HEIGHT + 10,
                math.min(lastGapY + math.random(-40 , 40), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
            lastGapY = y
            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
        end

        bird:update(dt)

        -- TODO: Why two loops?
        for k,pair in pairs(pipePairs) do
            pair:update(dt)
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    scolling = false
                end
            end
        end
        for k,pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipes, k)
            end
        end

    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(BACKGROUND_IMAGE, -backgroundScroll, 0)

    bird:render()

    for k,pair in pairs(pipePairs) do
        pair:render()
    end
    love.graphics.draw(GROUND_IMAGE, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end

