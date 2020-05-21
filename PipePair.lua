PipePair = Class{}

GAP_HEIGHT = 80

function PipePair:init(y)
    GAP_HEIGHT = math.random(80, 120)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    self.remove = false

    self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        for k, pipe in pairs(self.pipes) do
            pipe: update(dt)
            self.x = pipe.x
        end
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe: render()
    end
end
