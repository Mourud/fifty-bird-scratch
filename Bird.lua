Bird = Class{}

local GRAVITY = 20
local JUMP_ACCELERATION = -5

function Bird:init()
    self.image = love.graphics.newImage('assets/images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.flag = true

    self.dy = 0
end

function Bird:collides(pipe)
    
    if (self.x + self.width - 2 > pipe.x and self.x + 2 < pipe.x + pipe.width)then
        if pipe.orientation == 'top' and self.y + 2 < pipe.y + pipe.height  then
            return true
        elseif pipe.orientation == 'bottom' and self.y + self.height - 2 > pipe.y  then
            return true
        else return false
        end
    end
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1)then
        self.dy = JUMP_ACCELERATION
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end