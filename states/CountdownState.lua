CountdownState = Class{__includes = BaseState}


function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then
        self.timer = self.timer % 1
        self.count = self.count - 1
        if self.count == 0 then 
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    
    
    love.graphics.setFont(hugeFont)
    love.graphics.printf(self.count, 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, 'center')

end